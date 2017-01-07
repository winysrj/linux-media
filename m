Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35844 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940572AbdAGCMQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2017 21:12:16 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH v3 12/24] add mux and video interface bridge entity functions
Date: Fri,  6 Jan 2017 18:11:30 -0800
Message-Id: <1483755102-24785-13-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 Documentation/media/uapi/mediactl/media-types.rst | 22 ++++++++++++++++++++++
 include/uapi/linux/media.h                        |  6 ++++++
 2 files changed, 28 insertions(+)

diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
index 3e03dc2..023be29 100644
--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -298,6 +298,28 @@ Types and flags used to represent the media graph elements
 	  received on its sink pad and outputs the statistics data on
 	  its source pad.
 
+    -  ..  row 29
+
+       ..  _MEDIA-ENT-F-MUX:
+
+       -  ``MEDIA_ENT_F_MUX``
+
+       - Video multiplexer. An entity capable of multiplexing must have at
+         least two sink pads and one source pad, and must pass the video
+         frame(s) received from the active sink pad to the source pad. Video
+         frame(s) from the inactive sink pads are discarded.
+
+    -  ..  row 30
+
+       ..  _MEDIA-ENT-F-VID-IF-BRIDGE:
+
+       -  ``MEDIA_ENT_F_VID_IF_BRIDGE``
+
+       - Video interface bridge. A video interface bridge entity must have at
+         least one sink pad and one source pad. It receives video frame(s) on
+         its sink pad in one bus format (HDMI, eDP, MIPI CSI-2, ...) and
+         converts them and outputs them on its source pad in another bus format
+         (eDP, MIPI CSI-2, parallel, ...).
 
 ..  tabularcolumns:: |p{5.5cm}|p{12.0cm}|
 
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 4890787..08a8bfa 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -105,6 +105,12 @@ struct media_device_info {
 #define MEDIA_ENT_F_PROC_VIDEO_STATISTICS	(MEDIA_ENT_F_BASE + 0x4006)
 
 /*
+ * Switch and bridge entitites
+ */
+#define MEDIA_ENT_F_MUX				(MEDIA_ENT_F_BASE + 0x5001)
+#define MEDIA_ENT_F_VID_IF_BRIDGE		(MEDIA_ENT_F_BASE + 0x5002)
+
+/*
  * Connectors
  */
 /* It is a responsibility of the entity drivers to add connectors and links */
-- 
2.7.4

