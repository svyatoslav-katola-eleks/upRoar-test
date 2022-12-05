import SwiftUI
import AVKit

struct PlayerQueueView: View {
    
    @ObservedObject var viewModel: PlayerQueueViewModel = .init()
    
    var body: some View {
        GeometryReader { proxy in
            TabView(selection: $viewModel.currentIndex, content: {
                ForEach(Array(viewModel.displayedItems.enumerated()), id: \.offset) { index, post in
                    VideoPlayer(player: post.player)
                        .aspectRatio(contentMode: .fill)
                        .tag(index)
                }
                .rotationEffect(.degrees(-90)) // Rotate content
                .frame(
                    width: proxy.size.width,
                    height: proxy.size.height
                )
            })
            .frame(
                width: proxy.size.height, // Height & width swap
                height: proxy.size.width
            )
            .rotationEffect(.degrees(90), anchor: .topLeading) // Rotate TabView
            .offset(x: proxy.size.width) // Offset back into screens bounds
            .tabViewStyle(
                PageTabViewStyle(indexDisplayMode: .never)
            )
        }
        .background(ProgressView().scaleEffect(2))
        .ignoresSafeArea()
        .onAppear(perform: viewModel.onAppear)
    }
}
