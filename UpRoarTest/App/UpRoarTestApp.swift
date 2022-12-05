//
//  UpRoarTestApp.swift
//  UpRoarTest
//
//  Created by Svyatoslav Katola on 02.12.2022.
//

import SwiftUI
import AVKit

@main
struct UpRoarTestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
        } catch {
            assertionFailure("Failed to configure `AVAAudioSession`: \(error.localizedDescription)")
        }
    }
}
