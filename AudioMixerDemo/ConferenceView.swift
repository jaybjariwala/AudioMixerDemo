//
//  ConferenceView.swift
//  AudioMixerDemo
//
//  Created by Jay Jariwala on 13/03/26.
//
//
//  ConferenceView.swift
//
//  SwiftUI screen that simulates a conference call UI.
//  Allows adding participants and controlling mute/volume.
//

import SwiftUI

struct ConferenceView: View {

    /// Access the global conference manager
    @EnvironmentObject var manager: AudioConferenceManager

    var body: some View {

        VStack(spacing: 20) {

            Text("Local Audio Mixer Demo")
                .font(.title)

            /// Start the audio engine
            Button("Start Audio Engine") {

                manager.startConferenceEngine()
            }

            /// Add a simulated participant
            Button("Add Fake Participant") {

                manager.addFakeParticipant()
            }

            Divider()

            /// List of participants currently connected
            List(manager.participants) { participant in

                VStack(alignment: .leading, spacing: 10) {

                    Text(participant.name)
                        .font(.headline)

                    HStack {

                        /// Toggle mute
                        Button(participant.isMuted ? "Unmute" : "Mute") {

                            manager.toggleMute(participant.id)
                        }

                        /// Volume slider
                        Slider(
                            value: Binding(
                                get: { participant.volume },
                                set: { manager.setVolume(participant.id, volume: $0) }
                            ),
                            in: 0...1
                        )
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ConferenceView()
}
