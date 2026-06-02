# Blackout Comms

**Encrypted · Private · Off-Grid · Mesh Memory · Zero-Touch Trust**

Blackout Comms is a secure, private mesh communication firmware for LoRa-capable hardware. It enables encrypted text messaging, GPS location sharing, and broadcast communication between a trusted group of devices — with no cell towers, no internet, no servers, and no external infrastructure of any kind.

This repository contains pre-built firmware binaries for all supported hardware. Full documentation is at **[chatters.io](https://chatters.io)**.

---

## Table of Contents

- [What Is Blackout Comms?](#what-is-blackout-comms)
- [Supported Hardware](#supported-hardware)
- [Key Capabilities](#key-capabilities)
  - [Mesh Memory](#mesh-memory)
  - [Zero-Touch Trust](#zero-touch-trust)
  - [ECDSA Message Signing](#ecdsa-message-signing)
  - [Private Clusters](#private-clusters)
  - [Frequency Hopping & Anti-Jamming](#frequency-hopping--anti-jamming)
  - [Intelligent Message Routing](#intelligent-message-routing)
- [Blackout Comms Live — Android Companion App](#blackout-comms-live--android-companion-app)
- [How a Cluster Works](#how-a-cluster-works)
- [Security Architecture Summary](#security-architecture-summary)
- [Blackout Comms vs. Meshtastic vs. MeshCore](#blackout-comms-vs-meshtastic-vs-meshcore)
- [Firmware Binaries](#firmware-binaries)
- [Flashing Instructions](#flashing-instructions)
- [Licensing](#licensing)
- [Links](#links)

---

## What Is Blackout Comms?

Blackout Comms is firmware for LoRa mesh communication devices. Once flashed, a device becomes a member of a **private cluster** — a closed, encrypted mesh network in which only authorized devices participate.

Cluster members can:

- Send and receive encrypted text messages and broadcasts
- Share live GPS position, heading, speed, and battery status
- View all cluster members on a live map via the companion Android app
- Maintain awareness of devices that have gone offline via **mesh memory**
- Establish automatic cryptographic trust with other cluster members they have never directly encountered

The system is designed for scenarios where infrastructure cannot be relied upon — emergency preparedness, grid-down events, supply run coordination, civil disruption, off-grid field operations, rural property communication, and search and rescue. It works in environments with no cell signal, no internet, and no external dependencies of any kind.

Blackout Comms is developed and maintained by **Altware Development LLC**.

---

## Supported Hardware

| Device | Form Factor | Notes |
|---|---|---|
| **Lilygo T-Deck** | Keyboard + display | Full keyboard, touchscreen, preferred for messaging |
| **Lilygo T-Pager** | Pager form factor | Compact, wearable, belt-clip friendly |
| **Heltec Vision Master T190** | Touchscreen display | Touch interface, compact |
| **Compatible DIY LoRa builds** | Custom | See hardware guide at chatters.io |

> All supported devices use LoRa radio for mesh communication. GPS is used for location sharing where hardware supports it.

---

## Key Capabilities

### Mesh Memory

Mesh memory is the capability that most distinguishes Blackout Comms from every other civilian LoRa mesh system.

In a standard mesh network, when a device goes offline it disappears — the network loses all knowledge of it. Blackout Comms works differently. Every node in the cluster continuously retains and propagates the **last known state** of every other cluster member, including devices that are currently powered off:

- Last known GPS position
- Last known heading
- Last known speed
- Last known battery level
- RF connectivity data between all device pairs
- Trust credentials (certificates and public keys) of all cluster members

This data is **distributed across every active node**, not stored on any single device or server. When a device powers off, its last known state remains in the mesh — visible to the coordinator, visible to any device that joins the cluster later.

**A device that boots after an extended absence receives the full cluster state immediately** — every active device's current position, every offline device's last known state, every broadcast sent while it was offline. No briefing required. Immediately operational.

Mesh memory is encrypted at all times. No other civilian LoRa mesh firmware — including Meshtastic and MeshCore — implements mesh memory.

---

### Zero-Touch Trust

Zero-Touch Trust is the automatic establishment of cryptographic trust between any two cluster devices the first time they come within radio range — without manual configuration, without an administrator present, and without any external infrastructure.

Every Blackout Comms cluster has a **root device** — the device that created the cluster and is the sole authority for onboarding new members. When the root onboards a new device it:

1. Shares the cluster's symmetric encryption keys with the new device
2. Assigns a unique cluster identity to the new device
3. Cryptographically signs that identity and issues a **certificate** to the new device

That certificate is the device's proof of cluster membership. Any other cluster device can verify it using the root's public key — without contacting the root, without any server, without any human involvement.

When two cluster devices meet for the first time in the field, they exchange certificates automatically. Signatures are verified. Trust is established. They cooperate fully from that moment — mesh routing, location sharing, broadcasts, all cluster functions.

**Trust credentials are part of mesh memory** and propagate through the cluster the same way location data does. Two devices that never physically meet will have each other's certificates delivered through the mesh by intermediate nodes. When they eventually come within range, trust is already established before the first direct transmission.

---

### ECDSA Message Signing

Every message and broadcast transmitted by a Blackout Comms device is **cryptographically signed** using that device's private key before transmission.

- Signature algorithm: **ECDSA** (Elliptic Curve Digital Signature Algorithm)
- Every signature is **timestamped** — preventing replay attacks
- Receiving devices verify every signature before acting on any message
- **Private keys are generated on-device at setup, stored encrypted, and never transmitted** — not to other cluster members, not to the root device

This means:

- **Message integrity** — content cannot be altered in transit without invalidating the signature
- **Authentication** — the sending device cannot be spoofed
- **Non-repudiation** — the sending device cannot deny having sent a message
- **Replay protection** — captured messages cannot be retransmitted as if new
- **Key isolation** — compromise of any single device, including the root, cannot be used to forge messages from any other cluster member

No other civilian LoRa mesh firmware implements per-message ECDSA signing.

---

### Private Clusters

A Blackout Comms cluster is a **closed network**. Only devices onboarded by the root device can join. Outsiders cannot:

- Join the cluster
- Read cluster traffic
- Receive location data or broadcasts
- Determine cluster membership

The cluster's encryption keys, device certificates, and symmetric keys exist only on the hardware of authorized members. There is no account system, no server, no cloud service, and no third party involved in any cluster function.

**Stealth modes** reduce the RF footprint of the network, making it less visible to passive RF observers.

**Remote wipe** allows the root device to render any cluster member's credentials and stored data unrecoverable. The target device must be within mesh range to receive the wipe command. For situations where a device may not return to mesh range, generating a new cluster (new keys, new certificates, new identities) is the recommended response to a compromised member.

---

### Frequency Hopping & Anti-Jamming

Blackout Comms transmissions **change frequency in a coordinated pattern** known only to cluster members. This makes cluster traffic significantly harder to:

- Intercept with fixed-frequency monitoring
- Locate using direction-finding equipment
- Disrupt using fixed-frequency jamming

Meshtastic and MeshCore operate on fixed LoRa channels. Blackout Comms does not.

---

### Intelligent Message Routing

RF connectivity data — **signal strength and link reliability between every observed device pair, measured in both directions** — is part of what mesh memory carries and propagates cluster-wide.

The firmware uses this continuously updated RF topology map to route messages intelligently. When a message needs to travel between two out-of-range devices, the firmware selects the path with the strongest, most reliable links — not the shortest path, and not a flood.

Both directions of every link are tracked independently, accounting for asymmetric RF conditions common in real-world LoRa deployments.

This same RF topology data powers the connection line visualization in the Blackout Comms Live companion app.

---

## Blackout Comms Live — Android Companion App

**Blackout Comms Live** is the free Android companion app for Blackout Comms clusters.

[![Get it on Google Play](https://img.shields.io/badge/Google_Play-Get_it_Free-3DDC84?style=flat&logo=google-play&logoColor=white)](https://play.google.com/store/apps/details?id=com.blackoutcomms.live)

### Connection

The app connects to any Blackout Comms communicator via **Bluetooth Low Energy (BLE)**. Once connected, it receives a live feed of the entire cluster's state through the connected device — not just the immediately visible devices, but the full cluster picture carried by mesh memory.

### Map View

- Live map showing all cluster devices with real-time position updates
- **Offline devices displayed at last known position** — dot remains on map with last known heading, speed, and battery level visible
- **Range indicator circles** showing which devices are within direct RF range of the connected communicator vs. communicating via mesh hops
- **Mesh Graph overlay** — toggleable connection lines between devices showing live RF topology
- Broadcast messages displayed on the map, anchored to the sender's geographic location
- Filter by device, time range, and map type (OpenTopoMap, standard)
- **Google Cast support** — cast the live map to any Chromecast-enabled display for central command use

### Traffic View

- Live mesh traffic chart — bytes and packets in/out over time
- Ping log showing each device, timestamp, signal strength in dBm, and DIRECT vs. INDIRECT connection status

### Requirements

- Android device with Bluetooth support
- Any Blackout Comms communicator (T-Deck, Lilygo Pager, Heltec v4, or compatible)
- At least one licensed root device in the cluster

> **iOS:** Blackout Comms Live is currently Android only. iOS support is not available in the current release.

---

## How a Cluster Works

```
┌─────────────────────────────────────────────────────────────┐
│                    BLACKOUT COMMS CLUSTER                   │
│                                                             │
│   ┌──────────┐         ┌──────────┐         ┌──────────┐   │
│   │  ROOT    │ ──────► │ MEMBER A │ ──────► │ MEMBER B │   │
│   │ DEVICE   │         │          │         │          │   │
│   │(licensed)│ ◄────── │          │ ◄────── │          │   │
│   └──────────┘         └──────────┘         └──────────┘   │
│        │                    │                    │          │
│        ▼                    ▼                    ▼          │
│   Issues signed        Carries full         Carries full   │
│   certificates         mesh memory          mesh memory    │
│   to new members       for all nodes        for all nodes  │
│                                                             │
│   ┌─────────────────────────────────────────────────────┐   │
│   │              MESH MEMORY (encrypted)                │   │
│   │  • Last known position / heading / speed / battery  │   │
│   │  • RF link quality between all device pairs         │   │
│   │  • Device certificates and public keys              │   │
│   │  • Broadcast message history                        │   │
│   │  Carried by every active node · Delivered on boot   │   │
│   └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

**Step 1 — Create a cluster.** Flash the firmware on your root device and create a new cluster. The root generates cluster keys and becomes the onboarding authority.

**Step 2 — Onboard members.** Bring member devices within range of the root. The root issues each one a signed certificate and shares cluster keys. Members are now part of the cluster.

**Step 3 — Deploy.** Cluster members can be deployed anywhere. As they encounter each other in the field, certificates are exchanged automatically and trust is established. Mesh memory propagates operational state across all nodes continuously.

**Step 4 — Monitor.** Connect a phone or tablet running Blackout Comms Live to any cluster device via Bluetooth. View the live cluster map, offline device positions, broadcasts, and RF topology from anywhere in the cluster.

---

## Security Architecture Summary

| Layer | Mechanism | Purpose |
|---|---|---|
| **Confidentiality** | Symmetric encryption of all cluster traffic | Only cluster members can read transmissions |
| **Identity** | Root-signed per-device certificates | Cryptographic proof of cluster membership |
| **Authentication** | Zero-touch certificate exchange | Automatic trust between any two cluster members |
| **Trust propagation** | Certificates distributed via mesh memory | Mutual trust without physical meeting |
| **Integrity** | ECDSA message signing | Content cannot be altered in transit |
| **Non-repudiation** | Per-device private keys (on-device only) | Sender identity is cryptographically provable |
| **Replay protection** | Timestamped signatures | Captured messages cannot be retransmitted |
| **Intercept resistance** | Frequency hopping | RF footprint is unpredictable to outside observers |
| **Jamming resistance** | Frequency hopping | Fixed-frequency jamming is ineffective |
| **Compromise response** | Remote wipe + cluster regeneration | Controlled response to lost or compromised devices |

No element of this architecture depends on external servers, cloud services, accounts, or any infrastructure outside the cluster hardware.

---

## Blackout Comms vs. Meshtastic vs. MeshCore

| Capability | Blackout Comms | Meshtastic | MeshCore |
|---|:---:|:---:|:---:|
| **Mesh memory** | ✅ | ❌ | ❌ |
| Last known position of offline device | ✅ | ❌ | ❌ |
| New device receives full cluster state on boot | ✅ | ❌ | ❌ |
| RF topology propagated cluster-wide | ✅ | ❌ | ❌ |
| **Root-of-trust certificate architecture** | ✅ | ❌ | ❌ |
| Zero-touch trust | ✅ | ❌ | ❌ |
| Trust propagated via mesh memory | ✅ | ❌ | ❌ |
| **ECDSA message signing** | ✅ | ❌ | ❌ |
| Per-device private key (never leaves device) | ✅ | ❌ | ❌ |
| Replay attack protection | ✅ | ❌ | ❌ |
| **Frequency hopping / anti-jamming** | ✅ | ❌ | ❌ |
| Symmetric encryption of cluster traffic | ✅ | ✅ | ✅ |
| Private cluster / closed network | ✅ | Partial | Partial |
| Remote wipe | ✅ | ❌ | ❌ |
| Live companion app (Android) | ✅ | ✅ | ✅ |
| Live companion app (iOS) | ❌ | ✅ | Partial |
| Offline devices shown at last known position | ✅ | ❌ | ❌ |
| Google Cast support | ✅ | ❌ | ❌ |
| Broadcast messages anchored to map location | ✅ | ❌ | ❌ |
| Open source firmware | ❌ | ✅ | ✅ |
| Hardware compatibility | Select devices | 50+ devices | Select devices |
| Firmware license required (root device) | ✅ | ❌ | ❌ |
| Subscription / monthly fee | ❌ | ❌ | ❌ |
| MeshCore network mixing / interoperability | ✅ | ❌ | ✅ |

> **A note on fairness:** Meshtastic is an excellent open-source system with broad hardware support, a large community, and full iOS support. MeshCore offers structured routing optimized for planned infrastructure. The table above shows where each system differs — not which is universally better. The right system depends on your use case. If open-source auditability, maximum hardware compatibility, or iOS support are your primary requirements, Meshtastic may be the better fit. If private cluster operation with mesh memory, zero-touch trust, and message signing are your requirements, Blackout Comms is built for that.

---

## Firmware Binaries

Pre-built firmware binaries for all supported hardware are in this repository.

You can manually search through this repo for the binary you want or you can use the more user-friendly html page (also hosted in this repo) to choose the correct one:
[Download Pre-Built Binary](https://chatterbuilds.pages.dev/ChatterBox/esp32/)

> Always use the binary for your specific hardware. Flashing the wrong binary may render the device unresponsive.

---

## Flashing Instructions

### T-Deck / T-Pager / Heltec T190 — Web Flasher (Recommended)

The easiest method for most users. No software installation required.

1. Connect your device to your computer via USB
2. Visit **[chatters.io/flash](https://chatters.io/flash)**
3. Select your hardware from the dropdown
4. Click Flash and follow the on-screen instructions
5. Chrome or Edge browser required (Web Serial API)

### Manual Flash — esptool

For advanced users who prefer command-line flashing:

```bash
# Install esptool
pip install esptool

# Flash firmware (replace PORT and BINARY with your values)
esptool.py --chip esp32s3 --port /dev/ttyUSB0 --baud 921600 \
  write_flash 0x0 blackoutcomms-tdeck-vX.X.X.bin
```

Common port values:
- **Linux/macOS:** `/dev/ttyUSB0` or `/dev/tty.usbserial-*`
- **Windows:** `COM3`, `COM4`, etc. (check Device Manager)

### After Flashing

1. Power cycle the device
2. Follow the on-screen setup to create or join a cluster
3. If creating a new cluster, this device becomes the root
4. Download Blackout Comms Live from Google Play to monitor your cluster from a phone or tablet

Full setup documentation: **[chatters.io/docs](https://chatters.io/docs)**

---

## Licensing

Blackout Comms firmware is **proprietary software** developed by Altware Development LLC.

**A firmware license is required for the root device of each cluster.** Member devices do not require individual licenses. The Blackout Comms Live Android app is free with no license required.

Licenses are available at **[chatters.io](https://chatters.io)**.

The pre-built binaries in this repository may be downloaded and flashed freely for evaluation. A license must be activated on any device operating as a cluster root.

> This repository does not contain firmware source code. Source code for the Blackout Comms firmware is not publicly available.

---

## Links

| Resource | URL |
|---|---|
| Website & documentation | [chatters.io](https://chatters.io) |
| Blackout Comms Live (Google Play) | [Google Play](https://play.google.com/store/apps/details?id=com.blackoutcomms.live) |
| Getting Started | [chatters.io/docs](https://www.chatters.io/build) |
| DIY Hardware | [chatters.io/hardware](https://chatters.io/diy) |
| Mesh Memory explained | [chatters.io/mesh-memory](https://chatters.io/mesh-memory) |
| Zero-Touch Trust explained | [chatters.io/zero-touch-trust](https://chatters.io/zero-touch-trust) |
| Comparison: BC vs. Meshtastic vs. MeshCore | [chatters.io/comparison](https://www.chatters.io/mesh-comparison-blackout-comms-vs-meshtastic-vs-meshcore) |
| Web flasher | [chatters.io/flash](https://chatters.io/flash) |
| Firmware licensing | [chatters.io/license](https://www.chatters.io/licensing) |

---

## About

Blackout Comms is developed by **Altware Development LLC**.

For questions, support, and community discussion, visit [chatters.io](https://chatters.io).

---

*Blackout Comms. When the grid goes down — your network stays up.*