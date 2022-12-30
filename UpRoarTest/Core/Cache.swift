import Combine
import Foundation

final actor MediaCache {
    
    private let cache = NSCache<NSString, NSData>()

    func cacheItem(_ mediaItem: Data, forKey key: String, item: CachingPlayerItem) {
        cache.setObject(mediaItem as NSData, forKey: key as NSString)
    }
    
    func removeObject(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func getItem(forKey key: String) -> Data? {
        return cache.object(forKey: key as NSString) as Data?
    }
}
