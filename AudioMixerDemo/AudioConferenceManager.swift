//
//  AudioConferenceManager.swift
//  AudioMixerDemo
//
//  Created by Jay Jariwala on 13/03/26.
//
//
//  AudioConferenceManager.swift
//
//  Acts as the main controller between SwiftUI UI
//  and the AudioMixerEngine.
//
//  Responsibilities:
//  - Manage participant list
//  - Handle UI commands (mute/volume/add)
//  - Forward commands to audio engine
//

import Foundation
import AVFoundation

/// Model representing a participant in the conference
struct Participant: Identifiable {

    let id = UUID()

    /// Display name
    let name: String

    /// Volume level (0.0 → 1.0)
    var volume: Float = 1.0

    /// Mute state
    var isMuted: Bool = false
}

class AudioConferenceManager: ObservableObject {

    /// List of participants shown in UI
    @Published var participants: [Participant] = []

    /// Core audio mixing engine
    private let mixerEngine = AudioMixerEngine()

    // MARK: Start Conference

    /// Starts the AVAudioEngine pipeline
    func startConferenceEngine() {

        mixerEngine.startEngine()
    }

    // MARK: Add Participant

    /// Adds a simulated participant
    func addFakeParticipant() {

        let participant = Participant(
            name: "User \(participants.count + 1)"
        )

        participants.append(participant)

        /// Tell mixer to create an audio stream for this participant
        mixerEngine.createParticipant(id: participant.id)
    }

    // MARK: Toggle Mute

    func toggleMute(_ id: UUID) {

        guard let index = participants.firstIndex(where: {$0.id == id}) else { return }

        participants[index].isMuted.toggle()

        mixerEngine.setMute(
            id: id,
            muted: participants[index].isMuted
        )
    }

    // MARK: Set Volume

    func setVolume(_ id: UUID, volume: Float) {

        guard let index = participants.firstIndex(where: {$0.id == id}) else { return }

        participants[index].volume = volume

        mixerEngine.setVolume(id: id, volume: volume)
    }
}
