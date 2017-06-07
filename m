Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:56943 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751485AbdFGJeC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 05:34:02 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Peter Rosin <peda@axentia.se>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Pavel Machek <pavel@ucw.cz>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v8 2/3] [media] add mux and video interface bridge entity functions
Date: Wed,  7 Jun 2017 11:33:44 +0200
Message-Id: <1496828025-4848-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1496828025-4848-1-git-send-email-p.zabel@pengutronix.de>
References: <1496828025-4848-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add two new media entity function definitions for video multiplexers
and video interface bridges.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

- renamed MEDIA_ENT_F_MUX to MEDIA_ENT_F_VID_MUX

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Changes since v7 [1]:

- Drop a redundant sentence.
- Clarify number of video interface bridge source pads.

[1] https://patchwork.linuxtv.org/patch/41536/
---
 Documentation/media/uapi/mediactl/media-types.rst | 21 +++++++++++++++++++++
 include/uapi/linux/media.h                        |  6 ++++++
 2 files changed, 27 insertions(+)

diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
index 2a5164aea2b40..71078565d6444 100644
--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -299,6 +299,27 @@ Types and flags used to represent the media graph elements
 	  received on its sink pad and outputs the statistics data on
 	  its source pad.
 
+    -  ..  row 29
+
+       ..  _MEDIA-ENT-F-VID-MUX:
+
+       -  ``MEDIA_ENT_F_VID_MUX``
+
+       - Video multiplexer. An entity capable of multiplexing must have at
+         least two sink pads and one source pad, and must pass the video
+         frame(s) received from the active sink pad to the source pad.
+
+    -  ..  row 30
+
+       ..  _MEDIA-ENT-F-VID-IF-BRIDGE:
+
+       -  ``MEDIA_ENT_F_VID_IF_BRIDGE``
+
+       - Video interface bridge. A video interface bridge entity must have at
+         least one sink pad and at least one source pad. It receives video
+         frames on its sink pad from an input video bus of one type (HDMI, eDP,
+         MIPI CSI-2, ...), and outputs them on its source pad to an output
+         video bus of another type (eDP, MIPI CSI-2, parallel, ...).
 
 ..  tabularcolumns:: |p{5.5cm}|p{12.0cm}|
 
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 4890787731b85..fac96c64fe513 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -105,6 +105,12 @@ struct media_device_info {
 #define MEDIA_ENT_F_PROC_VIDEO_STATISTICS	(MEDIA_ENT_F_BASE + 0x4006)
 
 /*
+ * Switch and bridge entitites
+ */
+#define MEDIA_ENT_F_VID_MUX			(MEDIA_ENT_F_BASE + 0x5001)
+#define MEDIA_ENT_F_VID_IF_BRIDGE		(MEDIA_ENT_F_BASE + 0x5002)
+
+/*
  * Connectors
  */
 /* It is a responsibility of the entity drivers to add connectors and links */
-- 
2.11.0
