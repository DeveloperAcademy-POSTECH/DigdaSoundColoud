//
//  DigdaSoundCloudApp.swift
//  DigdaSoundCloud
//
//  Created by jose Yun on 2023/05/06.
//

import SwiftUI

@main
struct DigdaSoundCloudApp: App {
    
    @StateObject var musicModel: MusicModel = MusicModel(sound: "mercury")
    
    var body: some Scene {
        WindowGroup {
            ContentView(musicModel: musicModel)
        }
    }
}
