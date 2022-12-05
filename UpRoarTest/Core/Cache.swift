import Combine
import Foundation

final class MediaCache: NSObject {
    
    var readyToPlayItems = PassthroughSubject<CachingPlayerItem, Never>()

    private let cache = NSCache<NSString, NSData>()
    private let queue = DispatchQueue(label: "cache.queue", qos: .userInitiated)

    func cacheItem(_ mediaItem: Data, forKey key: String, item: CachingPlayerItem) {
        queue.sync {
            cache.setObject(mediaItem as NSData, forKey: key as NSString)
            readyToPlayItems.send(item)
        }
    }
    
    func removeObject(forKey key: String) {
        queue.sync {
            cache.removeObject(forKey: key as NSString)
        }
    }

    func getItem(forKey key: String) -> Data? {
        return cache.object(forKey: key as NSString) as Data?
    }
}
