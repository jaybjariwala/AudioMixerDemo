# AudioMixerDemo Audio Pipeline

This document provides a detailed explanation of the **audio pipeline** used in the iOS Local Audio Mixing Demo. It covers **PCM frame generation, buffer scheduling, local mixing, and per-participant audio controls**.

---

## 1. Overview

The demo simulates a **conference audio system** on iOS using **AVAudioEngine**:

- Each participant generates a unique **PCM audio stream**.
- Audio streams are mixed locally in real-time using a **mixer node**.
- The mixed audio is sent to the **device output** (speaker/headphones).

This setup **mirrors the core mechanics** used in real VoIP and conferencing apps before integrating network streams.

---

## 2. PCM Audio Generation

Each participant generates a sine wave for demonstration purposes.

- **Audio format**:
  - Sample rate: 48,000 Hz
  - Channels: 1 (mono)
  - Format: 32-bit float

- **Frame size**:
  - 960 samples per buffer (~20ms at 48kHz)
  - Matches typical VoIP packet duration

- **Frequency assignment**:
  - Each participant has a unique frequency (e.g., 220 Hz, 330 Hz, 440 Hz)
  - Ensures audible distinction between multiple participants

### Example Code Snippet

```swift
let frameCount: AVAudioFrameCount = 960
let samples = buffer.floatChannelData![0]

for i in 0..<Int(frameCount) {
    samples[i] = sin(phase) * 0.15
    phase += (2 * .pi * frequency) / Float(format.sampleRate)
    if phase > (2 * .pi) { phase -= (2 * .pi) }
}
````

* `phase` ensures smooth, continuous waveform across buffers.
* Amplitude is limited to avoid clipping.

---

## 3. Buffer Scheduling

* Each participant uses `AVAudioPlayerNode.scheduleBuffer(buffer)` to send PCM frames to the audio engine.
* Buffers are scheduled approximately every 20ms.
* Continuous scheduling simulates **streamed audio** like a VoIP session.
* Playback is started **after the node is attached and connected** to the mixer.

---

## 4. Local Audio Mixing

* **AVAudioMixerNode** sums PCM streams from all active participants.
* Mixing is performed **on-device in real-time**.
* The mixed audio is routed through **MainMixerNode** to the output.

### Mixing Example

```
Participant 1: 220 Hz sine wave
Participant 2: 330 Hz sine wave
Participant 3: 440 Hz sine wave
----------------------------------- (Mixer Node)
Output: 3 sine waves mixed together
```

* Each participant contributes **linearly to the final output**.
* The mixer can apply **per-participant volume adjustments**.

---

## 5. Stereo Panning

* Each participant has a **pan property**:

```
-1.0 → full left
 0.0 → center
+1.0 → full right
```

* Enhances spatial perception in multi-participant scenarios.
* Panning can be **deterministic or random**.

Example:

```swift
node.player.pan = Float.random(in: -1.0...1.0)
```

Or deterministic spread:

```swift
let index = participantNodes.count
node.player.pan = Float(index % 5) / 2.0 - 1.0
```

* Provides a **conference-like audio effect**, allowing listeners to distinguish participants.

---

## 6. Per-Participant Controls

| Control | Description                                         |
| ------- | --------------------------------------------------- |
| Mute    | Stops buffer playback temporarily                   |
| Volume  | Adjusts node output amplitude (0.0 → 1.0)           |
| Pan     | Adjusts stereo positioning (-1.0 → 1.0)             |
| Remove  | Detaches node from mixer and stops audio generation |

---

## 7. Audio Session Configuration

* **Category**: `.playAndRecord`
* **Mode**: `.voiceChat`
* **Options**: `.allowBluetooth`, `.defaultToSpeaker`

Benefits:

* Echo cancellation (AEC)
* Bluetooth routing
* Low-latency audio for real-time mixing
* Ensures **voice-quality output** suitable for conference simulations

---

## 8. Buffer Scheduling & Latency Considerations

* Each participant schedules a buffer every ~20ms.
* The AVAudioEngine mixer node sums all inputs with **minimal latency**.
* Engine preparation:

```swift
engine.prepare()
try? engine.start()
```

* Ensures smooth playback with **low risk of underrun**.

---

## 9. Limitations

* Participants generate **synthetic sine waves** instead of real microphone or network audio.
* No jitter buffering, packet loss simulation, or Opus decoding.
* Echo cancellation relies on AVAudioSession defaults.
* No SIP or WebRTC network streams yet.

---

## 10. Future Enhancements

* Replace synthetic audio with **live microphone input**.
* Add **WebRTC decoded audio streams** as participants.
* Implement **jitter buffer and packet loss handling**.
* Dynamic participant join/leave handling.
* Visual speaker indicators.
* Full **conference call management** (merging, multi-party audio, routing).

---

## 11. Audio Flow Summary

```
PCM Generator (per participant)
        ↓
AVAudioPCMBuffer
        ↓
AVAudioPlayerNode
        ↓
AVAudioMixerNode (sums all participants)
        ↓
MainMixerNode
        ↓
Device Output (Speaker / Headphones)
```

* Optional per-participant:

  * Volume adjustment
  * Stereo panning
  * Mute/unmute

* Multiple participants → mixed into a **single audio output stream**.

---
