Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:52269 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755667AbcJNRfG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:35:06 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 18/21] [media] add mux and video interface bridge entity functions
Date: Fri, 14 Oct 2016 19:34:38 +0200
Message-Id: <1476466481-24030-19-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
2.9.3

