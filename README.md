# iOS Local Audio Mixing Demo (SwiftUI)

A SwiftUI demo project demonstrating **real-time local audio mixing using PCM buffers** on iOS.

The application simulates multiple audio participants and mixes their audio streams locally using Apple's **AVAudioEngine** pipeline. Each simulated participant generates a unique audio signal which is fed into a shared mixer node and played through the device speaker.

This project serves as a **learning and prototype environment** for understanding how **multi-participant audio mixing works on-device**, which is a core requirement for building VoIP conference systems.

# Demo Video

[![Watch the Demo]](https://github.com/jaybjariwala/AudioMixerDemo/blob/main/Audio_mixer.mp4)

Click the image above to view the demo video.

---

# Purpose of This Demo

The main goal of this project is to demonstrate:

* Local audio mixing on iOS
* Handling multiple independent audio streams
* Real-time PCM buffer scheduling
* Per-participant audio control
* Conference-style audio pipeline architecture

This demo provides a simplified simulation of how VoIP applications mix audio streams before integrating technologies like **WebRTC** and **SIP signaling**.

---

# Key Features

* Multi-participant audio simulation
* Real-time local audio mixing
* Independent audio streams for each participant
* Per-participant controls:

  * Mute / Unmute
  * Volume adjustment
  * Stereo panning
* Low latency PCM audio scheduling
* SwiftUI-based interface
* VoIP-optimized audio session configuration

---

# Technology Stack

Language
Swift

UI Framework
SwiftUI

Audio Engine
AVAudioEngine

Audio Configuration
AVAudioSession (VoiceChat mode)

---

# Audio Architecture

The application uses the following audio graph:

Participant 1 → AVAudioPlayerNode
Participant 2 → AVAudioPlayerNode
Participant 3 → AVAudioPlayerNode
Participant N → AVAudioPlayerNode

All player nodes are connected to a shared mixer:

AVAudioMixerNode → MainMixerNode → Device Output (Speaker / Headphones)

Each participant generates its own **PCM audio buffer** which is scheduled continuously into its player node. The mixer node combines all streams into a single audio output.

---

# Audio Pipeline

Each simulated participant follows this flow:

1. Generate PCM audio samples (sine wave)
2. Create an `AVAudioPCMBuffer`
3. Schedule buffer into `AVAudioPlayerNode`
4. Send audio stream to mixer
5. Mixer combines all streams
6. Output to device speaker

Pipeline representation:

PCM Generator
↓
AVAudioPCMBuffer
↓
AVAudioPlayerNode
↓
AVAudioMixerNode
↓
MainMixerNode
↓
Speaker / Headphones

---

# Why Use Different Frequencies?

Each simulated participant produces a different tone frequency.

Example:

User 1 → 220 Hz
User 2 → 330 Hz
User 3 → 440 Hz

This allows listeners to clearly distinguish multiple audio sources and verify that **audio mixing is occurring in real time**.

---

# Stereo Panning

Each participant is assigned a stereo pan value.

Range:

-1.0 → Left speaker
0.0 → Center
1.0 → Right speaker

This spatial separation makes the mixed audio easier to perceive during testing.

---

# Project Structure

AudioMixerDemoApp.swift
Application entry point.

ConferenceView.swift
SwiftUI interface for managing participants and audio controls.

AudioConferenceManager.swift
Application controller responsible for managing participants and interacting with the audio engine.

AudioMixerEngine.swift
Core audio engine responsible for configuring the audio session, creating the mixer graph, and managing participant audio nodes.

ParticipantAudioNode.swift
Simulates a remote audio stream by generating PCM buffers.

---

# Running the Demo

## 1. Clone the Repository

```
git clone https://github.com/jaybjariwala/AudioMixerDemo.git
```

Open the project in Xcode.

---

## 2. Run the Application

Select a device or simulator and run the project.

Recommended: use a **real iPhone** for best audio performance.

---

## 3. Start Audio Engine

Tap:

Start Audio Engine

This initializes the audio session and starts the AVAudioEngine pipeline.

---

## 4. Add Participants

Tap:

Add Fake Participant

Each participant will begin generating audio and will be connected to the mixer.

Adding multiple participants will produce multiple tones simultaneously, demonstrating **real-time audio mixing**.

---

## 5. Test Audio Controls

For each participant you can:

Mute / Unmute audio
Adjust volume
Observe stereo positioning

---

# Example Test Scenario

Start Audio Engine

Add 3 participants.

Expected audio result:

Three distinct tones playing simultaneously from different stereo positions.

This confirms that:

* Multiple PCM streams are active
* Streams are mixed locally
* Output is produced through a single audio pipeline

---

# Audio Session Configuration

The app configures AVAudioSession using VoIP-friendly settings:

Category
playAndRecord

Mode
voiceChat

Options
allowBluetooth
defaultToSpeaker

These settings enable:

* echo cancellation
* Bluetooth headset support
* proper voice processing

---

# Related Technologies

WebRTC – Real-time media transport
PJSIP – SIP signaling stack

---

# Learning Objectives

This demo helps developers understand:

* how AVAudioEngine works
* how to mix multiple audio streams
* how VoIP applications process PCM audio
* how to structure a conference audio pipeline

---

# License

This project is provided for educational and prototyping purposes.

---

# Author

Demo project created for exploring **local audio mixing and VoIP conference architecture on iOS**.
