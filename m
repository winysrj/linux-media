Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33143 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756712AbcLPSAL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 13:00:11 -0500
Received: by mail-lf0-f67.google.com with SMTP id y21so1917582lfa.0
        for <linux-media@vger.kernel.org>; Fri, 16 Dec 2016 10:00:05 -0800 (PST)
From: henrik@austad.us
To: linux-kernel@vger.kernel.org
Cc: Richard Cochran <richardcochran@gmail.com>, henrik@austad.us,
        Henrik Austad <haustad@cisco.com>, linux-media@vger.kernel.org,
        alsa-devel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [TSN RFC v2 2/9] TSN: add documentation
Date: Fri, 16 Dec 2016 18:59:06 +0100
Message-Id: <1481911153-549-3-git-send-email-henrik@austad.us>
In-Reply-To: <1481911153-549-1-git-send-email-henrik@austad.us>
References: <1481911153-549-1-git-send-email-henrik@austad.us>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Henrik Austad <haustad@cisco.com>

Describe the overall design behind the TSN standard, the TSN-driver,
requirements to userspace and new functionality introduced.

Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Henrik Austad <haustad@cisco.com>
---
 Documentation/TSN/tsn.txt | 345 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 345 insertions(+)
 create mode 100644 Documentation/TSN/tsn.txt

diff --git a/Documentation/TSN/tsn.txt b/Documentation/TSN/tsn.txt
new file mode 100644
index 0000000..540246f
--- /dev/null
+++ b/Documentation/TSN/tsn.txt
@@ -0,0 +1,345 @@
+                Time Sensitive Networking (TSN)
+                -------------------------------
+
+[work in progress]
+
+1. Motivation
+=============
+
+TSN is a set of open standards, formerly known as 'AVB' (Audio/Video
+Bridging). It was renamed to TSN to better reflect that it can do much
+more than just media transport and extended to handle more types of
+traffic.
+
+TSN is a way to create reliable, deterministic streams across a network
+without loss of frames due to congestion in the network. By using gPTP
+(a specialized IEEE-1588v2 PTP profile), the time can be synchronized
+with sub-us granularity across all the connected devices in the AVB
+domain.
+
+In its current version, this driver only supports L2 traffic (i.e
+etherframes only), but later version is planned to handle L3. L2-L3
+traversing is currently being worked on by the IETF detnet working
+group.
+
+2. Intro to AVB/TSN
+===================
+
+The original standards were written with Audio/Video in mind, so the
+initial standards refer to this as 'AVB'. In later standards, this has
+changed to TSN, and AVB now refers to a service you can add on top of
+TSN. In some parts of the driver, this naming shines through, in
+particular for AVTP (AVB Transport Protocol), and this is to reflect the
+naming in the standards.
+
+In this document, we refer to the infrastructure part as TSN, and AVB to
+the ALSA/V4L2 shim which can be added on top of TSN to provide a
+media-service.
+
+TSN operates with 'streams', and one stream can contain pretty much
+whatever you like. An AVB stream carrying audio can carry multiple
+channels. The current revision of AVTP (defined in IEEE 1722 d16)
+defines many more types than media.
+
+A stream flows through the network from a Talker to a Listener. A Talker
+is a single End-station in the network, a Listener can be a single
+End-station (unicast) or a group of end-stdations (multicast).
+
+2.1 Domains
+
+2.1.1 SRP Domain
+
+An SRP domain is the set of entities in the network that support the
+Stream Reservation Protocol (IEEE 802.1Q-2014 Sec 35) and where all
+entities agree on the priority code points (PCP). A bridge will mark
+each port as either SRP capable or not capable.
+
+PCP is used to map a specific priority to a given traffic-class,
+typically class A or B.
+
+2.1.2 gPTP domain
+
+This is the set of all connected bridges and end-stations that support
+the gPTP protocol. gPTO is a PTPv2 profile.
+
+2.1.3 AVB Domain
+
+An AVB domain is the intersection of an SRP Domain and gPTP domain.
+
+
+2.2 End Station (ES)
+
+An TSN ES is where a stream either originates or ends -what others would
+call sources (Talkers) and sinks (Listeners). Looking back at pre-TSN
+when this was called AVB, these names make a bit more sense.
+
+Common for both types, they need to be PTPv2 capable, i.e. you need to
+timestamp gPTP frames upon ingress/egress to improve the accuracy of
+PTP.
+
+2.2.1 Talkers
+
+A Talker must be single ES in the AVB Domain.
+
+Hardware requirements:
+- Multiple Tx-queues
+- Credit based shaper on at least one of the queues for pacing the
+  frames onto the network
+- VLAN capable
+
+2.2.2 Listener
+
+A Listener does not have the same requirements as a Talker as it cannot
+control the pace of the incoming frames anyway. It is beneficial if the
+NIC understands VLANs and has a few Rx-queues so that you can steer all
+TSN-frames to a dedicated queue, but this is not a hard requirement.
+
+If the Listener receives audio, having an adjustable PL/L is a clear
+benefit to avoid resampling.
+
+2.3 Bridges
+
+A Bridge is what TSN calls switches that are TSN-capable. They must be
+able to prioritize TSN-streams, have the credit-based shaper available
+for that class, support SRP, support gPTP and so on. The requirements is
+laid down in "Forwardin and Queueing of Time Sensitive Streams" (IEEE
+802.1Q-2014 sec. 34).
+
+2.4 Relevant standards
+
+* IEEE 802.1BA-2011 Audio Video Bridging (AVB) Systems
+
+* IEEE 802.1Q-2014 sec 34 and 35
+
+  What is referred to as:
+  IEEE 802.1Qav (Forwarding and Queueing for Time-sensitive Streams)
+  IEEE 802.1Qat (Stream Registration protocol)
+
+* IEEE 802.1AS gPTP
+
+  A PTPv2 profile (from IEEE 1588) tailored for this domain. Notable
+  changes include the requirement that all nodes in the network must be
+  gPTP capable (i.e. no traversing non-PTP entities), and it allows
+  traffic over a wider range of medium that what "pure" PTPv2 allows.
+
+* IEEE 1722 AVTP Layer 2 Transport Protocol for Time-Sensitive
+  Applications in Bridged Local Area Networks
+  Further improvements in IEEE 1722.d16-2015.
+
+* IEEE 1722.1 Device Discovery, Connection Management and Control for 1722
+
+  What allows AVB (TSN) devices to handle discovery, enumeration and
+  control, basically let you connect 2 devices from a 3rd
+
+  In this (in the scope of the Linux kernel TSN driver) must be done
+  purely from userspace as we do not want the kernel to suddenly attach
+  to a remote system without the user's knowledge. This is further
+  reflected in how the attributes for the link is managed via ConfigFS.
+
+
+3. Overview and/or design of the TSN-driver
+===========================================
+
+The driver handles the shifting of data for TSN-streams. Anything else
+is left for userspace to handle. This includes stream reservation (using
+some sort of MSRP client), negotiating multicast addresses, finding the
+value of the different attributes and connect application(s) to the
+exposed devices (currently we only have an ALSA-device via the AVB ALSA
+Shim).
+
+Note: the kernel-driver for TSN is tsn (lowercase). When we refer to the
+_standard_ TSN, we use uppercase. Hopefully this won't be too confusing.
+
+               /--------------------\
+               |                    |
+               |  Media application |
+               |                    |
+               \--------------------/
+                     |        |
+          +----------+        +----+
+          |                        |
+          |                        |
+     +------------+                |
+     |   ALSA     |                |
+     +------------+                |
+          |                        |
+          |                        |
+     +------------+          +--------------+
+     |  avb_alsa  |          | tsn_configfs |
+     | (tsn-shim) |          +--------------+
+     +------------+                |
+          |                        |
+          |                        |
+          +------+                 |
+                 |                 |
+                 |                 |
+            +------------+         |
+            |  tsn_core  |<--------+
+            +------------+
+                 |
+                 |
+            +------------+
+            |  tsn_net   |
+            +------------+
+                 |
+                 |
+            +------------+
+            |  network   |
+            | subsystem  |
+            +------------+
+                 |
+                 |
+                ...
+
+
+3.1 Terms and concepts
+
+tsn uses the concept of streams and shims.
+
+- A shim is a thin wrapper that binds TSN to another subsystem (or
+  directly to userspace). avb_alsa is an example of such a shim.
+
+- A stream is the only data TSN cares about. What the data inside the
+  stream represents, is left for the associated shim to handle. TSN will
+  verify the headers up to the protocol specific header and then pass it
+  along to the shim.
+
+Note: currently, only the data-unit part is implemented, the control
+part, in which 1722.1 (discovery and enumeration) is part, is not
+handled.
+
+3.2 Userspace requirements
+
+(msrp-client, "tsnctl"-tool
+
+4. ConfigFS overview
+=====================================
+
+4.1 Global attributes
+
+4.1.1 available_shims
+
+Read-only, lists all shims that has been loaded. When no shims has been
+loaded, 'none' is the only available.
+
+e.g.
+     /config/tsn# cat available_shims
+     none
+     alsa
+
+
+4.1.2 stream_ids
+
+Read-only, list of all StreamIDs used by the links. This is for _all_
+links on all NICs. Even if 2 NICs are on separate networks and therefore
+in theory have identical stream_id, we do a global approach.
+
+
+4.2 Per NIC attributes
+
+4.2.1  pcp_a
+
+Priority Code Point, class A. This must be the same for all streams in
+a AVB-domain, and a NIC can only partake in one.
+
+4.2.2  pcp_b
+
+Priority Code Point, class B
+
+4.2.3 list of NICs
+
+Each TSN-capable NIC is listed as a directory, inside each NIC it is
+possible to instantiate a new link using mkdir.
+
+4.3 Per stream attributes
+
+The value of the per-stream attributes need to be coordinated with the
+network. Many of these can/must be found using MSRP during link
+negotiation. The TSN driver expects userspace to do all the reservation
+so that when the link is set to active, the network will accept the
+outgoing frames.
+
+4.3.1  buffer_size
+
+Size (in kB) of the buffer the shim will use to store data before
+packing it into frames and sending (or storing incoming data in).
+
+4.3.2  class
+
+TSN splits traffic in 2 class, class A and B, 'A' or 'B' will signal
+which class this link belongs to.
+
+4.3.3  enabled
+
+'on' or 'off', indicating that the link is currently not pushing data or
+that it is fully configured and is pushing data over the network.
+
+Only valid options are 'on' and 'off' (lowercase only).
+
+4.3.4  end_station
+
+'Talker' or 'Listener'. A link cannot be both. It either sends (Talker)
+or receives (Listener) data.
+
+4.3.5  local_mac
+
+MAC address that receives data for this link. Currently this is the MAC
+for the NIC, in theory it could be a multicast address (not supported
+right now).
+
+4.3.6  max_payload_size
+
+Upper bound on how much data will be pushed in each frame. A shim can
+send _less_ than this, but never more. This is due to bandwidth
+reservation constraints.
+
+4.3.7 remote_mac
+
+Destination for L2-traffic.
+
+4.3.8 shim
+
+Shim registered to this link. 'None' means no shim, and the link cannot
+be set to active. Valid shims are listed in the global
+'available_shims' (see 4.1.1).
+
+4.3.9 shim_header_size
+
+A shim will most likely need some header to go along with the data. This
+indicates to tsn how large the header is so that frame-size constraints
+can be respected.
+
+4.3.10 stream_id
+
+StreamID for the stream this link runs. Must be globally unique on the
+host, see 4.1.2.
+
+4.3.11 vlan_id
+
+TSN does not really care about the VLAN ID, but the network may care a
+whole lot. This sets the VLAN ID to use for the traffic belonging to
+this link.
+
+
+5. Creating a new TSN Link from userspace
+=====================================
+
+A link is created in multiple steps.
+
+1. Create space for the link:
+   mkdir /config/tsn/eth0/link
+
+2. Sett values for the attributes for the link
+
+
+6. Creating a new shim
+======================
+
+shim_ops
+[coming]
+
+
+7. Other resources:
+===================
+
+https://en.wikipedia.org/wiki/Audio_Video_Bridging
-- 
2.7.4

