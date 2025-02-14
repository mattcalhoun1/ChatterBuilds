This repo contains prebuilt binary firmware for devices that support the Chatters protocol.

# What is ChatterBox and Chatters?

See [http://chatters.io](https://www.chatters.io/)

[<img src="https://img.youtube.com/vi/9tA2zRDCW6Q/maxresdefault.jpg" width="50%">](https://youtu.be/9tA2zRDCW6Q)
[<img src="https://img.youtube.com/vi/ilig2YCvYEw/maxresdefault.jpg" width="50%">](https://youtu.be/ilig2YCvYEw)


### Chatters
Chatters is a secure mesh communication protocol and platform that can use pretty much any medium to pass encrypted messages around. Within Chatters, 
a private group of trusted mesh-connected devices is called a "Cluster". All devices in the cluster share a set of symmetric keys and also
each device has its own asymmetric elliptic curve keypair. This combination allows for secure group communication, as well as secure one-on-one 
communication, where devices assisting in mesh delivery between a pair of devices are not able to decrypt the payloads.

Chatters uses a couple of advanced mesh algorithms and techniques, allowing it to route messages through paths that are shortest and most
likely to succeed. Each Chatters device maintains a live ever-changing mesh graph, which is the device's view of how other devices are 
connected. This graph is constructed and maintained by monitoring traffic, pings, and other techniques.

Within a Chatters cluster, devices can be connected to other cluster devices using any combination of the following: LoRa, UDP, Wired via Serial, CAN (wired). Currently, only the LoRa option is active in the UI of ChatterBox.

Chatters automatically uses best path, but each device along the way decides which medium will be used for the next hop. For instance, if the cluster is generally LoRa based, but two devices are connected via CAN, it is likely that CAN connection
will be used, since it is faster and more likely to succeed than any wireless hop.

Chatters supports packet level acknolwedgements as well as message-level signed acknowledgements. Message-level acknowledgements are digitally signed by the recipient, so if a confirmation is received, it is guaranteed to be authentic.

Chatters uses a distributed mesh cache, where each device in the cluster is responsible for holding encrypted packets,
as requested, for delivery throughout the cluster. Typically, these packets are asymmetrically encrypted, so even the
devices holding mesh packets in their cache are not able to decrypt the packet payloads.

## Hardware Compatibility
In order to fully support the ChatterBox protocol, devices that are going to run it must have a few key components that allow the meshing and caching to work properly, and allow the cluster to remain secure and private. 
* GPS and/or a realtime clock to guarantee accurate time. Both is best.
* Storage for frequently-updated encrypted data. FRAM and SD cards are supported, SPIFFS flash is experimental.
* A decent amount of memory. If FRAM is available, 192 KB of memory is sufficient. If SD is utilized, closer to 1 MB is required.
* ESP32 and SAMD51 are the currently supported hardware architectures

Chatters is very new (first released fall/2024), see: [ChatterBox](https://chatters.io/chatterbox). ChatterBox is designed to be a device [you can build](https://www.chatters.io/build) yourself..


[<img src="https://img.youtube.com/vi/rJjFlZsUep0/maxresdefault.jpg" width="50%">](https://youtu.be/rJjFlZsUep0)


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