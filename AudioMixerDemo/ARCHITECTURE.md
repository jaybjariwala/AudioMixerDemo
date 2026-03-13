# AudioMixerDemo Architecture

This document describes the **architecture of the iOS Local Audio Mixing Demo**, including its **audio engine design, participant management, and UI interactions**.  

The demo simulates a **conference audio engine** using **AVAudioEngine** and **SwiftUI**.

---

## 1. Overview

The demo demonstrates:

- Multiple participants generating independent PCM audio streams.
- Local audio mixing on-device.
- Real-time scheduling of audio buffers.
- Per-participant controls like volume, mute, and stereo panning.
- A conference-style audio pipeline suitable as a foundation for **WebRTC + SIP** integration.

---

## 2. Components

| Component                     | Responsibility                                                                 |
|--------------------------------|-------------------------------------------------------------------------------|
| `AudioMixerEngine`            | Core AVAudioEngine setup, mixer node, participant node management             |
| `ParticipantAudioNode`        | Simulates a remote participant, generates PCM buffers, handles playback       |
| `AudioConferenceManager`      | Interface between UI and audio engine; manages participant creation/removal    |
| `ConferenceView`              | SwiftUI interface for controlling participants and audio playback             |
| `AudioMixerDemoApp`           | Entry point of the application                                                |

---

## 3. Audio Engine Graph

Each participant has its own **AVAudioPlayerNode**, which is connected to a **shared mixer node**. The mixer outputs to the **main mixer node**, which sends audio to the device output.

```

Participant 1 → AVAudioPlayerNode ┐
Participant 2 → AVAudioPlayerNode ├─> AVAudioMixerNode ──> MainMixerNode ──> Device Output (Speaker/Headphones)
Participant 3 → AVAudioPlayerNode ┘
...
Participant N → AVAudioPlayerNode

```

- Each participant node schedules PCM buffers continuously (~20ms per buffer).
- The mixer node sums all participant audio streams.
- Stereo panning and per-participant volume are applied at the player node level.

---

## 4. Audio Session Configuration

The demo uses **AVAudioSession** configured for **VoIP/voice chat**:

- **Category**: `.playAndRecord`
- **Mode**: `.voiceChat`
- **Options**: `.allowBluetooth`, `.defaultToSpeaker`

Benefits:

- Acoustic Echo Cancellation (AEC)
- Bluetooth headset support
- Low-latency audio for real-time voice

---

## 5. Participant Lifecycle

1. **Create** `ParticipantAudioNode` with a unique frequency for demo purposes.
2. **Attach** its `AVAudioPlayerNode` to the AVAudioEngine.
3. **Connect** the node to the `AVAudioMixerNode`.
4. **Set optional properties**:
   - `volume` (0–1)
   - `pan` (-1.0 left → 1.0 right)
5. **Start generating audio buffers** and play the node.
6. **Mute/unmute** or **remove** participants dynamically.

---

## 6. UI Interaction Flow

```

User taps "Start Audio Engine" ──> AudioMixerEngine starts AVAudioEngine
User taps "Add Fake Participant" ──> AudioConferenceManager adds participant:
- Player node created
- Attached to mixer
- Started generating PCM buffers
User adjusts volume/mute/pan ──> AudioConferenceManager updates ParticipantAudioNode

```

---

## 7. Key Design Principles

- **Real-time local audio mixing**: all audio streams are mixed on-device with low latency.
- **Per-participant control**: supports mute, volume, and pan adjustments.
- **Scalable architecture**: can support multiple participants and future WebRTC streams.
- **Separation of concerns**: clear division between audio engine, participant nodes, manager, and UI.

---

## 8. Component Interaction Diagram

```

+--------------------+        +-------------------------+
| ConferenceView     | ---->  | AudioConferenceManager  |
|  (SwiftUI UI)      |        | (manages participants) |
+--------------------+        +-------------------------+
|
v
+------------------+
| AudioMixerEngine |
| (AVAudioEngine,  |
|  Mixer Node)     |
+------------------+
|
---------------------------------------------
|           |             |                 |
v           v             v                 v
Participant 1  Participant 2  Participant 3 ... Participant N
(Audio Node)  (Audio Node)  (Audio Node)       (Audio Node)

```

---

## 9. Summary

- Each participant generates **independent PCM buffers**.
- Mixer node sums streams into a **single output pipeline**.
- Audio session is configured for **VoIP-friendly low-latency playback**.
- The architecture is modular and ready for integration with **live microphone input**, **WebRTC streams**, or **SIP signaling** for a full softphone/conference application.

---
