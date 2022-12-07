import Combine
import AVKit

final class PlayerQueueViewModel: ObservableObject {
    
    // These constants might affect app performance
    enum Constants {
        static let maximumItemsInBuffering: Int = 10
        static let maximumItemsCached: Int = 20
        static let playersWorkingRange: Int = 5
    }
    
    @Published var displayedItems: [VideoItem] = []
    @Published var currentIndex: Int = 0
    
    private var pendingItems: [VideoItem] = []
    private var cancellable: [AnyCancellable] = []
    
    private let cache = MediaCache()
    private let dataSource = VideosDataSource()
    
    private var cachedItemsSubject = PassthroughSubject<CachingPlayerItem, Never>()
    
    func onAppear() {
        $currentIndex
            .sink(receiveValue: onPageUpdate)
            .store(in: &cancellable)
        
        cachedItemsSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                guard let self else { return }
                
                if let index = self.pendingItems.firstIndex(where: { $0.url == item.url }) {
                    self.displayedItems.append(self.pendingItems[index])
                    self.pendingItems.remove(at: index)
                    
                    if self.displayedItems.count == 1 {
                        self.displayedItems.first?.player?.play()
                    }
                }
                
                self.loadMoreIfNeeded()
            }
            .store(in: &cancellable)
        
        NotificationCenter.default
            .publisher(for: NSNotification.Name.AVPlayerItemDidPlayToEndTime)
            .sink { [weak self] _ in
                guard let self else { return }
                
                if let player = self.displayedItems[self.currentIndex].player {
                    player.seek(to: .zero)
                    player.play()
                }
            }
            .store(in: &cancellable)
    }

    func loadMoreIfNeeded() {
        // Prevent new loadings when currently buffering maximum
        guard pendingItems.count < Constants.maximumItemsInBuffering else {
            return
        }
        
        // Prevent new loadings when current index is not in working range of displayed items
        guard currentIndex + Constants.maximumItemsInBuffering > displayedItems.count else {
            return
        }
        
        loadMore()
    }
    
    func loadMore() {
        let itemsToLoad = dataSource.getData(
            offset: displayedItems.count + pendingItems.count,
            length: Constants.maximumItemsInBuffering - pendingItems.count
        )
        
        itemsToLoad.forEach { videoItem in
            prepare(item: videoItem)
        }
    }
        
    func onPageUpdate(index: Int) {
        loadMoreIfNeeded()
        clearCacheIfNeeded()
                
        guard index < displayedItems.count else {
            return
        }
        
        // If item was already removed from cache, need to load it
        if displayedItems[index].player == nil {
            Task {
                let item = await resolveItem(for: displayedItems[index].url)
                let player = AVPlayer(playerItem: item)
                await MainActor.run { displayedItems[index].player = player }
            }
        }

        displayedItems[index].player?.seek(to: .zero)
        displayedItems[index].player?.play()

        // If there is previous video, we pause it
        if index > 0 {
            displayedItems[index - 1].player?.pause()
        }

        // If there is next video, we pause it
        if index + 1 < displayedItems.count {
            displayedItems[index + 1].player?.pause()
        }
    }

    private func prepare(item: VideoItem) {
        Task {
            let playerItem: CachingPlayerItem = await resolveItem(for: item.url)
            playerItem.delegate = self
            
            let player = AVPlayer(playerItem: playerItem)
            player.automaticallyWaitsToMinimizeStalling = false
            
            let item = VideoItem(url: item.url, player: player)
            pendingItems.append(item)
        }
    }
    
    private func resolveItem(for url: URL) async -> CachingPlayerItem {
        let key = url.absoluteString
        
        if let videoData = await cache.getItem(forKey: key) {
            return CachingPlayerItem(data: videoData as Data, mimeType: "video/mp4", fileExtension: "mp4")
        } else {
            let item = CachingPlayerItem.init(url: url, customFileExtension: "mp4")
            item.download()
            return item
        }
    }
    
    private func clearCacheIfNeeded() {
        // Remove cached items
        let cachedItemsToClear = currentIndex - Constants.maximumItemsCached
        if cachedItemsToClear > 0 {
            for cachedItemIndex in 0 ..< cachedItemsToClear {
                Task {
                    await cache.removeObject(
                        forKey: displayedItems[cachedItemIndex].url.absoluteString
                    )
                }
            }
        }
        
        // Clear player instances that are not in working range
        let nextPlayersToClear = currentIndex - Constants.playersWorkingRange
        if nextPlayersToClear > 0 {
            for cachedItemIndex in 0 ..< nextPlayersToClear {
                displayedItems[cachedItemIndex].player?.replaceCurrentItem(with: nil)
                displayedItems[cachedItemIndex].player = nil
            }
        }
        
        // Clear player instances that are not in working range
        let previousPlayersToClear = currentIndex + Constants.playersWorkingRange
        if previousPlayersToClear < displayedItems.count {
            for cachedItemIndex in previousPlayersToClear ..< displayedItems.count {
                displayedItems[cachedItemIndex].player?.replaceCurrentItem(with: nil)
                displayedItems[cachedItemIndex].player = nil
            }
        }
    }
}

extension PlayerQueueViewModel: CachingPlayerItemDelegate {
    
    func playerItem(_ playerItem: CachingPlayerItem, didFinishDownloadingData data: Data) {
        Task {
            await cache.cacheItem(data, forKey: playerItem.url.absoluteString, item: playerItem)
            cachedItemsSubject.send(playerItem)
        }
    }
}
