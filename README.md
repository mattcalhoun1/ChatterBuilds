This repo contains prebuilt binary firmware for Blackout Comms devices. See [http://chatters.io](https://www.chatters.io/).

# What is Blackout Comms?
Blackout Comms is a protocol and firmware designed to allow private text-based communication, location sharing, and remote circuit control that is independent of any grid, internet, or cell service. Transmissions in Blackout Comms are encrypted and digitally signed.

[<img src="https://img.youtube.com/vi/PC1gccxTL68/maxresdefault.jpg" width="30%">](https://youtu.be/PC1gccxTL68) [<img src="https://img.youtube.com/vi/JMSKM4LN3Uc/maxresdefault.jpg" width="30%">](https://youtu.be/JMSKM4LN3Uc)

Although you can download the firmware binaries from this repo, you
will find it much easier to install from one of our download sites:
* [chatters.io](https://chatters.io/flash)
* [offgridcomms.club](https://content.chatters.io/esp32/index.html)
* [meshcomms.club](https://www.meshcomms.club/firmware/esp32/index.html)

## Chatters Protocol
Chatters is a secure mesh communication protocol and platform that can use pretty much any medium to pass encrypted messages around. Within Chatters, 
a private group of trusted mesh-connected devices is called a "Cluster". All devices in the cluster or channel share a set of symmetric keys.
These keys allow for secure group communication and unpredictable (to outsiders) synchronized frequency hopping.

### Direct Messages / Broadcasts
All messages, whether direct (to a specific device) or broadcast are encrypted during transmission and at rest.

![Mesh Communicators](https://github.com/mattcalhoun1/ChatterBuilds/blob/main/images/blackout_comms_github_devices.png?raw=true)

### Clusters
A Chatters Cluster is a group of associated devices, each with a unique address, with access given by a "root" device.
The root device is the one that initialized the cluster. Only a root can onboard new identifiable devices.

![neighbors screen](https://github.com/mattcalhoun1/ChatterBuilds/blob/main/ChatterBox/esp32/images/neighbors_screen.png?raw=true)

Within a cluter, each device has its own asymmetric elliptic curve keypair. This allows direct messages 
to be end-to-end asymmetrically encrypted. This means trusted on-cluster devices assisting in mesh delivery are not able to decrypt the payloads, even
though they can assist with delivery.


### Channels
Channels allow encrypted/signed broadcasts and unpredictable synchronized frequency hopping without the necessity of a cluster. There is no "root" device in a channel. Instead, a channel ID and set of passwords
are shared however people want, and those allow devices to have secure communication. Within a channel, there is only
symmetric encryption and only broadcasts (no DM), so everyone in the channel within mesh range can see the message.

### Acknowledgements / Confirmations
For direct messages within a cluster, chatters supports packet level acknowledgements as well as message-level signed acknowledgements. Message-level acknowledgements are digitally signed by the recipient, so if a confirmation is received, it is guaranteed to be authentic.

For broadcasts (such as within a Channel) there is no confirmation that a specific device received the broadcast. Instead, you can 
receive confirmation that another device has picked up and accepted the transmission, so it will continue to travel until expiry.

### Location
![location screen](https://github.com/mattcalhoun1/ChatterBuilds/blob/main/ChatterBox/esp32/images/location_screen.png?raw=true)

Unless disabled, all on-cluster Blackout Comms devices are sharing GPS data of themselves and others regularly for all GPS-equipped nodes and communicators.
Within a channel, location can optionally be shared with each broadcast message.


### Meshing
Chatters uses a couple of advanced mesh algorithms and techniques, allowing it to route messages through paths that are shortest and most
likely to succeed. Each Chatters device maintains a live ever-changing mesh graph, which is the device's view of how other devices are 
connected. This graph is constructed and maintained by monitoring traffic, pings, and other techniques.

![Mesh Protocol Mixing](https://github.com/mattcalhoun1/ChatterBuilds/blob/main/images/protocol_modes.png?raw=true)

As of March 2026, Blackout Comms allows use of MeshCore repeaters, as well as
a [mesh network mixed mode](https://youtu.be/Q1fMCrBZGD0) that automatically hops between Blackout Comms native
protocol and MeshCore's fixed-frequency mode, to allow both anti-jamming and
increased range that may be offered by nearby MeshCore repeaters.

Chatters uses a distributed mesh cache, where each device in the cluster is responsible for holding encrypted packets,
as requested, for delivery throughout the cluster. Typically, these packets are asymmetrically encrypted, so even the
devices holding mesh packets in their cache are not able to decrypt the packet payloads.

### Connectivity
Within a Chatters cluster, devices can be connected to other cluster devices using any combination of the following: LoRa, UDP, Wired via Serial, CAN (wired). Currently, only the LoRa option is active in the UI of Blackout Comms.

Chatters automatically uses best path, but each device along the way decides which medium will be used for the next hop. For instance, if the cluster is generally LoRa based, but two devices are connected via CAN, it is likely that CAN connection
will be used, since it is faster and more likely to succeed than any wireless hop.

## Chatters Devices
All devices within Chatters support the distributed mesh cache, path planning, and other important features. Learn to [build your own off-grid encrypted communication devices](https://chatterbuilds.pages.dev/ChatterBox/esp32/).

### Communicators
Blackout Comms [Mesh Communicators](https://chatterbuilds.pages.dev/ChatterBox/esp32/tdeck_firmware) are devices you can carry around and use to share location, send/receive messages, and interact with other devices/sensors in a cluster or channel.
They usually have a touchscreen and keypad for easy use.

### Mesh Links (Nodes)
Blackout Comms [Mesh Links](https://chatterbuilds.pages.dev/ChatterBox/esp32/mesh_node_firmware) are devices that work in the background to extend the range and resilience of your cluster or channel. You may want to use one as a base station and connect a good LoRa antenna or LoRa amplifier to it for best results.

![Blackout Comms - Mesh Links](https://github.com/mattcalhoun1/ChatterBuilds/blob/main/images/blackout_comms_github_links.png?raw=true)

### Hardware Compatibility
In order to fully support the Blackout Comms protocol, devices that are going to run it must have a few key components that allow the meshing and caching to work properly, and allow the cluster to remain secure and private. 
* GPS and/or a realtime clock to guarantee accurate time. Both is best.
* Storage for frequently-updated encrypted data. FRAM and SD cards are supported, SPIFFS flash is experimental.
* A decent amount of memory. If FRAM is available, 192 KB of memory is sufficient. If SD is utilized, closer to 1 MB is required.
* ESP32 and SAMD51 are the currently supported hardware architectures

## Change Log

|      Date    | Short Description | Longer Description |
| ------------ | ----------------- | ------------------ |
| 2024-08-01 | Mesh Improvements | Improve mesh path finding, lock time changes except for root, more. |
| 2024-08-08 | Channel Hopping | Add ability to hop channels for security and also to be an RF "good citizen" |
| 2024-08-09 | Hopping + Fixes | Change channel hopping for mesh hops and for onboarding. Also, a few bug fixes. |
| 2024-11-01 | Hardware Changes | Integrate proximity sensor (dfrobot mmwave) and relay (adafruit) |
| 2024-12-31 | Time Synchronization | Allow time synchronization when GPS and RTC are not present. Improve broadcast |
| 2025-01-31 | Improve DM / Meshing | Alter mesh algorithm to take advantage of differing tx power between devices, opportunistic delivery, improved frequency hopping |
| 2025-02-01 | Open channels | Added concept of open channels, nodes can display messages, visual pixel map showing device locations |
| 2025-02-18 | Flash Support + Heltec | Added flash storage support, so SD cards are not required. Also added Heltec E290 node option |
| 2025-03-06 | Free Public Channel | Open/public channel is free, requiring no license. Improved command UI. |
| 2025-03-08 | DST + Timezone | Allow private nodes to remotely accept DST and timezone changes from communicators |
| 2025-03-27 | True RNG + fixes | Hardware RNG for T-Deck, faster time acquisition, fix occasional sx1262 deadlock |
| 2025-04-11 | MQTT Support | MQTT is supported in parallel with LoRa or by itself, on tdecks |
| 2025-04-15 | MQTT/TLS + fixes | Enable TLS for MQTT, memory fixes on t-deck |
| 2025-04-23 | Amp Control | Add ability to power amps on/off on demand for nodes |
| 2025-05-01 | UI Improvements | Critical device tagging, GPS improvements, more |
| 2025-05-04 | Fix battery level indicator on tdeck |
| 2025-05-05 | Storage Portability | Make SD cards portable between T-Decks, fix flash storage issue |
| 2025-08-?? | Name Change| | ChatterBox is now Blackout Comms
| 2026-03-?? | Protocol, Heltec, More | Capability to use MeshCore repeaters, support for Heltec v4, more |