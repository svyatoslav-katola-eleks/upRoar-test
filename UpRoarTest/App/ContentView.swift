import SwiftUI

/**
 
 Tech requirements:
 
 - present list with fullscreen size video items (violating iOS safe area)
 - play video when it becomes visible / pause when it starts dissapearing (like TikTok)
 - loop video playback
 - add pagination
 
 Limitation: you can use whatever frameworks, instruments & tools you like, but the `ContentView().body` should persist as a parent view for them
 
 Note: for more information - please check video attachment
 
 */

struct ContentView: View {
    var body: some View {
        PlayerQueueView()
    }
}
