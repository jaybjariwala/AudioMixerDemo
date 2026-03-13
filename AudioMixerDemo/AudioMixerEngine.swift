//
//  AudioMixerEngine.swift
//  AudioMixerDemo
//
//  Created by Jay Jariwala on 13/03/26.
//
//
//  AudioMixerEngine.swift
//
//  Core audio mixing engine.
//  Creates an AVAudioEngine graph where multiple
//  participant audio streams are mixed locally.
//
//  Audio Graph:
//
//  Participant A -> PlayerNode
//  Participant B -> PlayerNode
//  Participant C -> PlayerNode
//                        ↓
//                  MixerNode
//                        ↓
//                 MainMixerNode
//                        ↓
//                     Speaker
//

import AVFoundation

class AudioMixerEngine {

    /// Main audio engine
    private let engine = AVAudioEngine()

    /// Mixer where all participants connect
    private let mixerNode = AVAudioMixerNode()

    /// Store participant audio nodes
    private var participantNodes: [UUID: ParticipantAudioNode] = [:]

    init() {

        /// Attach mixer node to engine
        engine.attach(mixerNode)

        /// Connect mixer → main output
        engine.connect(
            mixerNode,
            to: engine.mainMixerNode,
            format: nil
        )
    }

    // MARK: Start Engine

    func startEngine() {

        configureAudioSession()
        engine.prepare()

        do {

            try engine.start()

            print("Audio Engine Started")

        } catch {

            print("Audio engine failed:", error)
        }
    }

    // MARK: Audio Session Setup

    /// Configure system audio routing
    private func configureAudioSession() {

        let session = AVAudioSession.sharedInstance()

        do {

            try session.setCategory(
                .playAndRecord,
                mode: .voiceChat,
                options: [
                    .allowBluetooth,
                    .defaultToSpeaker
                ]
            )

            try session.setActive(true)

        } catch {

            print("Audio session error:", error)
        }
    }

    // MARK: Create Participant

    /// Creates a simulated participant audio stream
    func createParticipant(id: UUID) {

        /// Assign unique tone frequency
        let baseFrequency: Float = 220
        let step: Float = 110
        let frequency = baseFrequency + Float(participantNodes.count) * step

        let node = ParticipantAudioNode(frequency: frequency)

        participantNodes[id] = node

        /// Attach player node to engine
        engine.attach(node.player)

        /// Connect to mixer
        engine.connect(
            node.player,
            to: mixerNode,
            format: node.format
        )

        /// Assign random stereo position
        let index = participantNodes.count
        let pan = Float(index % 5) / 2.0 - 1.0
        node.player.pan = pan

        /// Start generating audio
        node.startGeneratingAudio()
    }

    // MARK: Mute Control

    func setMute(id: UUID, muted: Bool) {

        guard let node = participantNodes[id] else { return }

        node.player.volume = muted ? 0 : 1
    }

    // MARK: Volume Control

    func setVolume(id: UUID, volume: Float) {

        guard let node = participantNodes[id] else { return }

        node.player.volume = volume
    }
}
