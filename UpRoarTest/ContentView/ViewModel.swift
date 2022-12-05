import Combine
import AVKit

final class ViewModel: ObservableObject {
    
    // these values affects app performance
    enum Constants {
        static let maximumItemsInBuffering: Int = 9
        static let maximumItemsCached: Int = 5
    }
    
    @Published var displayedItems: [VideoItem] = []
    @Published var currentIndex: Int = 0
    
    private var pendingItems: [VideoItem] = []
    private var cancellable: [AnyCancellable] = []
    
    private let cache = MediaCache()
    private let dataSource = VideosDataSource()
    private let processItemsQueue: OperationQueue = {
       let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        return queue
    }()
    
    func onAppear() {
        loadMoreIfNeeded()
        
        $currentIndex
            .sink(receiveValue: onPageUpdate)
            .store(in: &cancellable)
        
        cache
            .readyToPlayItems
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
        
        processItemsQueue.addOperation(BlockOperation(block: loadMore))
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
        
        // free up cached items if needed
        let itemsToLoop = index - Constants.maximumItemsCached
        if itemsToLoop > 0 {
            for cachedItemIndex in 0 ..< itemsToLoop {
                displayedItems[cachedItemIndex].player?.replaceCurrentItem(with: nil)
                displayedItems[cachedItemIndex].player = nil
                cache.removeObject(
                    forKey: displayedItems[cachedItemIndex].url.absoluteString
                )
            }
        }
                
        guard index < displayedItems.count else {
            return
        }
        
        // if item was already removed from cache, need to download (when scrolling back)
        if displayedItems[index].player == nil {
            let item = resolveItem(for: displayedItems[index].url)
            displayedItems[index].player = AVPlayer(playerItem: item)
        }

        displayedItems[index].player?.seek(to: .zero)
        displayedItems[index].player?.play()

        // if there is previous video, we pause it
        if index > 0 {
            displayedItems[index - 1].player?.pause()
        }

        // if there is next video, we pause it
        if index + 1 < displayedItems.count {
            displayedItems[index + 1].player?.pause()
        }
    }

    private func prepare(item: VideoItem) {
        let playerItem: CachingPlayerItem = resolveItem(for: item.url)
        var item: VideoItem = .init(url: item.url)
        item.player = .init(playerItem: playerItem)
        item.player?.automaticallyWaitsToMinimizeStalling = false
        playerItem.delegate = self
        
        pendingItems.append(item)
    }
    
    private func resolveItem(for url: URL) -> CachingPlayerItem {
        let key = url.absoluteString
        
        if let videoData = cache.getItem(forKey: key) {
            return CachingPlayerItem(data: videoData as Data, mimeType: "video/mp4", fileExtension: "mp4")
        } else {
            let item = CachingPlayerItem.init(url: url, customFileExtension: "mp4")
            item.download()
            return item
        }
    }
}

extension ViewModel: CachingPlayerItemDelegate {
    
    func playerItem(_ playerItem: CachingPlayerItem, didFinishDownloadingData data: Data) {
        cache.cacheItem(data, forKey: playerItem.url.absoluteString, item: playerItem)
    }
}
