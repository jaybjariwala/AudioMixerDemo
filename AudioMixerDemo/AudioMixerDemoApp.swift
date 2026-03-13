//
//  AudioMixerDemoApp.swift
//  AudioMixerDemo
//
//  Created by Jay Jariwala on 13/03/26.
//
//
//  AudioMixerDemoApp.swift
//
//  Entry point of the SwiftUI demo application.
//  It creates the global AudioConferenceManager
//  and injects it into the SwiftUI environment.
//

import SwiftUI

@main
struct AudioMixerDemoApp: App {

    /// Global conference manager shared across UI
    @StateObject private var conferenceManager = AudioConferenceManager()

    var body: some Scene {

        WindowGroup {

            ConferenceView()
                .environmentObject(conferenceManager)

        }
    }
}
