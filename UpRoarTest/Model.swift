import Foundation

public struct Post: Identifiable, Equatable, Decodable {
    public var id: String
    public var url: String {
        "https://uproar-backend-content-upload-alpha-plus-v2.s3.amazonaws.com/\(id)"
    }
}
