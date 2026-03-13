//
//  ParticipantAudioNode.swift
//  AudioMixerDemo
//
//  Created by Jay Jariwala on 13/03/26.
//
//
//  ParticipantAudioNode.swift
//
//  Simulates an incoming remote audio stream.
//  In a real VoIP app this would receive PCM frames
//  from WebRTC or SIP RTP packets.
//

import AVFoundation

class ParticipantAudioNode {

    /// Audio node that plays PCM buffers
    let player = AVAudioPlayerNode()
    
    /// Unique frequency for each participant
    private let frequency: Float

    /// Standard VoIP audio format
    let format = AVAudioFormat(
        standardFormatWithSampleRate: 48000,
        channels: 1
    )!

    /// Timer used to generate fake audio
    private var timer: Timer?

    /// Phase used for sine wave
    private var phase: Float = 0

    init(frequency: Float) {
        self.frequency = frequency
    }

    // Start generating PCM audio
    func startGeneratingAudio() {

        /// Start playback AFTER node is attached
        player.play()

        /// Simulate incoming VoIP packets every 20ms
        timer = Timer.scheduledTimer(
            withTimeInterval: 0.02,
            repeats: true
        ) { _ in

            self.generatePCMBuffer()
        }
    }

    private func generatePCMBuffer() {

        /// 20ms frame size used in VoIP
        let frameCount: AVAudioFrameCount = 960

        guard let buffer = AVAudioPCMBuffer(
            pcmFormat: format,
            frameCapacity: frameCount
        ) else { return }

        buffer.frameLength = frameCount

        let sampleRate = Float(format.sampleRate)
        let samples = buffer.floatChannelData![0]

        /// Angular increment for sine wave
        let phaseIncrement = (2 * Float.pi * frequency) / sampleRate

        for i in 0..<Int(frameCount) {

            /// Generate sine wave sample
            samples[i] = sin(phase) * 0.15

            /// Advance phase
            phase += phaseIncrement

            /// Prevent floating overflow
            if phase > (2 * Float.pi) {
                phase -= (2 * Float.pi)
            }
        }

        /// Send PCM buffer to audio engine
        player.scheduleBuffer(buffer)
    }

    
}
