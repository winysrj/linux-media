Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:65492 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbcFKXBk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2016 19:01:40 -0400
From: Henrik Austad <henrik@austad.us>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, alsa-devel@vger.kernel.org,
	netdev@vger.kernel.org, henrk@austad.us,
	Henrik Austad <haustad@cisco.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [very-RFC 1/8] TSN: add documentation
Date: Sun, 12 Jun 2016 01:01:29 +0200
Message-Id: <1465686096-22156-2-git-send-email-henrik@austad.us>
In-Reply-To: <1465686096-22156-1-git-send-email-henrik@austad.us>
References: <1465686096-22156-1-git-send-email-henrik@austad.us>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Henrik Austad <haustad@cisco.com>

Describe the overall design behind the TSN standard, the TSN-driver,
requirements to userspace and new functionality introduced.

Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Henrik Austad <haustad@cisco.com>
---
 Documentation/TSN/tsn.txt | 147 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 147 insertions(+)
 create mode 100644 Documentation/TSN/tsn.txt

Index: linux/Documentation/TSN/tsn.txt
===================================================================
--- /dev/null
+++ linux/Documentation/TSN/tsn.txt
@@ -0,0 +1,188 @@
+		Time Sensitive Networking (TSN)
+		-------------------------------
+
+[work in progress]
+
+1. Motivation
+=============
+
+TSN is a set of open standards, formerly known as 'AVB' (Audio/Video
+Bridging). It was renamed to TSN to better reflect that it can do much
+more than just media transport.
+
+TSN is a way to create reliable streams across a network without loss of
+frames due to congestion in the network. By using gPTP (a specialized
+IEEE-1588v2 PTP profile), the time can be synchronized with sub-us
+granularity across all the connected devices in the AVB domain.
+
+2. Intro to AVB/TSN
+===================
+
+The original standards were written with Audio/Video in mind, so the
+initial standards refer to this as 'AVB'. In later standards, this has
+changed to TSN, and AVB now refers to a service you can add on top of
+TSN. Hopefully it will not be too confusing.
+
+In this document, we refer to the infrastructure part as TSN and AVB to
+the ALSA/V4L2 shim which can be added on top of TSN to provide a
+media-service.
+
+TSN operates with 'streams', and one stream can contain pretty much
+whatever you like. Currently, only media has been defined properly
+though, which is why you only have media-subtypes for the
+avtp_subtype-field.
+
+For a media-setup, one stream can contain multiple channels, all going
+to the same destination. A destination can be a single Listener
+(singlecast) or a group of Listeners (multicast).
+
+2.1 Endpoints
+
+A TSN 'endpoint' is where a stream either originates or ends -what
+others would call sources (Talkers) and sinks (Listeners). Looking back
+at pre-TSN when this was called AVB, these names make a bit more sense.
+
+Common for both types, they need to be PTPv2 capable, i.e. you need to
+timestamp gPTP frames upon ingress/egress to improve the accuracy of
+PTP.
+
+2.1.1 Talkers
+
+Hardware requirements:
+- Multiple Tx-queues
+- Credit based shaper on at least one of the queues for pacing the
+  frames onto the network
+- VLAN capable
+
+2.1.2 Listener
+
+A Listener does not have the same requirements as a Talker as it cannot
+control the pace of the incoming frames anyway. It is beneficial if the
+NIC understands VLANs and has a few Rx-queues so that you can steer all
+TSN-frames to a dedicated queue.
+
+2.2 Bridges
+
+What TSN calls switches that are TSN-capable. They must be able to
+prioritize TSN-streams, have the credit-based shaper available for that
+class, support SRP, support gPTP and so on.
+
+2.3 Relevant standards
+
+* IEEE 802.1BA-2011 Audio Video Bridging (AVB) Systems
+
+* IEEE 802.1Q-2011 sec 34 and 35
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
+exposed devices (currently we only have an ALSA-device).
+
+       	       /--------------------\
+       	       |                    |
+	       |  Media application |
+	       |       	       	    |
+	       \--------------------/
+		     | 	      |
+       	  +----------+	      +----+
+	  | 			   |
+	  | 			   |
+     +------------+		   |
+     |   ALSA  	  |		   |
+     +------------+		   |
+	  |			   |
+	  |			   |
+     +------------+          +--------------+
+     | 	avb_alsa  | 	     | tsn_configfs |
+     | (tsn-shim) |	     +--------------+
+     +------------+ 		   |
+       	  |  	    		   |
+	  |    	  		   |
+	  +------+     	  	   |
+	   	 |		   |
+       	       	 |		   |
+            +------------+	   |
+ 	    |  tsn_core  |<--------+
+            +------------+
+       	       	 |
+		 |
+            +------------+
+       	    |  tsn_net   |
+            +------------+
+		 |
+		 |
+	    +------------+
+	    |  network	 |
+       	    | subsystem  |
+	    +------------+
+	       	 |
+		 |
+		...
+
+
+3.1 Terms and concepts
+
+TSN uses the concept of streams and shims.
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
+4. Creating a new link from userspace
+=====================================
+
+[coming]
+
+
+5. Creating a new shim
+======================
+
+shim_ops
+[coming]
+
+
+6. Other resources:
+===================
+
+https://en.wikipedia.org/wiki/Audio_Video_Bridging
