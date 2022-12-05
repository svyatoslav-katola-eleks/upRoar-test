import Foundation
import AVKit

struct VideosDataSource {
    
    private let data: [String] = {
        ["1712f4d5-7fe3-4d7e-960d-5bc8bec820ef", "cdb6eceb-de5c-4a07-a1e0-b9e01bfc53da", "18adc87b-83c2-4870-adf5-25d8cb4aad43",
         "90fe815b-c9a8-4196-96b2-96c1e0e8490c", "b7469734-d191-43e2-9350-3c6f037a775d", "b786169b-2aeb-4141-b44f-d86d522f13cc", "ff89221e-2c7f-436e-aaaf-50549786dd53",
         "cf6c0285-7382-4787-a445-ba1063c17eaf", "eb97cb8d-ca24-4c0e-9f7b-32c95e0f163d", "db4c59ee-98b9-4a72-82ac-5f77b59d0048", "924cc022-3e58-4f58-8417-4d05a6ce581f",
         "02a2e134-6c2a-4161-b41d-9aa022aa54a4", "6d244188-cee3-4e72-9cac-74e08cb161e8", "c45999d2-ceb8-4ef8-b089-8e235213bb9a", "de07f1fb-cde4-4443-893a-5513c496f04d",
         "58476238-cd8d-4025-9c76-4c1292014ad1", "d07717fc-c9df-42e4-8220-8b18e75fff84", "cc3d2792-6d02-463e-afa5-9d2cebcc7421", "a904e15b-6c7f-42a8-a23d-6302455aaa33",
         "5f07dc59-ecee-4367-a9a0-1f3aa548ac39", "625e55c3-3d44-4cb4-9393-1c565a512e9a", "7be2b1d8-31ff-41a1-a0fd-93ce23b28257", "f2476933-c8c5-44d3-a2e4-82d339f58f70",
         "07623a0e-86d0-4ac4-ad54-fdc7786edb51", "84e4d56b-c8f5-424f-a965-95aaba862c81", "96e18232-f975-40dc-8146-77ef98187f8c", "de033d53-293d-4b58-b513-40c8c55a7347",
         "fabaf97f-b0a6-47c2-b079-21804dea991a", "0bf565d3-3336-4bc9-aaeb-1ea003cc8161", "871c559f-c129-48b7-a29c-0aacc64baae4", "55a2a1be-1ba1-48d4-89f4-f7963038bd88",
         "c8c0cf17-c4fa-4d3b-906c-d733cd7db99e", "0e1a9d3d-6195-4167-8f8a-bcf7e985888b", "72ebf054-06e2-4339-b298-dac57fb92370", "48a70e9d-8bd8-4a9c-b341-6f88e650c0f1",
         "d97f9c81-3afb-48f2-9bec-b7e52e10660b", "2af8cb68-45a8-479d-8d05-6f8630f0c508", "1d328b98-efb4-4d41-a5b5-cb8fe8198915", "d59d13e5-2adc-49f8-9286-9877d010b5fe",
         "ac825d01-44b2-40b3-a339-177458042416", "b1f466cf-bb69-438b-bc79-84bab7cdc1d1", "de2d3491-5afd-41d4-8bb8-12e245ed0f6c", "15ba74db-45bb-47a3-b69b-fd341f997f64",
         "d1700b8a-0c62-4c59-9af9-4511273126a4", "63cc283e-b148-44d8-85c7-ca2058aa4ee6", "38e4d199-bb83-4b46-96fe-d02a3a2a4cd3", "93bccf43-fbcc-402c-9b51-042e3399e8ae",
         "993d37a9-f42b-4564-8475-7906450e3f70", "6c37bfb9-d0c3-4d82-a68e-f3b60fa1bfe4", "8b8c60fc-ae63-4ac8-83d0-9e88096d0e7e", "8023aa40-9f35-4bd5-8578-5c928d19e968",
         "bae3b0f3-bda6-43af-be39-2b1c307d3f90", "62111cc5-209c-40e4-aadf-2e397957e055", "56c95831-c7ea-488c-b9e7-e66d5f1dd37e", "d018d628-c3de-44d8-8ac9-78b657a70109",
         "fcd841e4-e9a1-43ba-9388-7a6e98d97b48", "04461e11-141d-45d4-a80d-4d52e4be6800", "77de5489-20a8-4b8a-b4d4-877935ce89f3", "40fc5aab-617d-4f12-8d28-33189252428e",
         "df13b9e3-7360-448f-ae36-779bdcccb39b", "728dcb51-90ec-4e54-9da8-786df632103f", "2f0677f9-5b41-445c-82f8-2d69b10a8bb6", "12e702fe-2b2e-437d-8f29-647823ebf788",
         "c68c22ec-93b5-4d4c-a75f-c64fb391ad7b", "f21e84f7-7804-4811-95a6-69b987c8e4f7", "818ee594-8b50-4026-aadd-de25452824b7", "8eb399f7-b23b-4aea-a51f-c6dc6ad69f97",
         "89fe0b0d-59fa-4c55-8c88-892d39efc9b3", "6103be6c-3aeb-4aec-b515-ebc08cb0b7ac", "81364ed9-e71c-42b6-91a3-030ab465ed25", "a02dc661-394a-4e79-9bcf-a2d842f10fb4",
         "060a7401-b509-4c0c-b3ab-82bae6319b7f", "6249a640-cfad-4cd9-bf28-d47b1b55ccfa", "45192d5a-11c1-4465-9704-ea97ac9a1592", "5f9f431e-e92c-4916-920e-e4a5ba1bec20",
         "ed93f1a1-3cd5-4211-a655-6ede39a04ab0", "d66416c3-c385-4ecb-94c6-8f51f0b6728f", "123d949d-d6a3-4e88-8aac-981ea709002a", "71c296e3-634b-4977-9fba-702159e5ba59",
         "420da4ca-eebf-4a37-817f-f7647497061f", "cd3add1a-f359-489f-81ec-4f9727b1cb60", "bcabe485-ed06-4a23-adc4-a39d99ad1bea", "52566598-2481-4b33-846d-610fa78d95e1",
         "03ae8688-4b88-4e29-9ea5-9c6d70112bc0", "59bd4625-b8ba-44aa-b6ea-58941b8f627d", "61753cfd-ddbe-4126-a815-05eae4140a4e", "b6ece791-3e43-4864-8da3-e5afb1b77751",
         "52d977b2-cf28-4725-aa64-e5431214ec6c", "56da4142-72c1-493b-a56b-5f10f75cf054", "abda2406-731a-496d-8dd8-1c229092d02a", "7c2809be-750e-4e3d-9201-ddea445324bd",
         "0f9862b1-e7eb-4b5b-bd8a-14a96563c4fd", "059310da-562a-486a-bec4-e9aa6d1fac91", "14e01b26-7709-44cb-8d18-ac39fdb69429", "2420e92c-e039-4756-b3b4-a6954efdc8bb",
         "8f450902-e997-4318-92f4-0afaa9a6c62c", "07efda24-ed04-4d48-bb55-c7b62d9d47e5", "54a20219-c4cc-41c5-8929-0fc8e984e10c"]
    }()
    
    func getData(offset: Int, length: Int) -> [VideoItem] {
        return data
            .suffix(from: offset)
            .prefix(length)
            .map(Post.init)
            .map {
                VideoItem(url: URL(string: $0.url)!)
            }
    }
}

struct VideoItem: Identifiable {
    var id: String = UUID().uuidString
    let url: URL
    var player: AVPlayer?
    
    init(url: URL) {
        self.url = url
    }
}
