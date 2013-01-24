Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2883 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab3AXHvc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 02:51:32 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 1/3] Move DV-class control IDs from videodev2.h to v4l2-controls.h
Date: Thu, 24 Jan 2013 08:51:14 +0100
Message-Id: <d84dbbfc5a7fd0b99e02aa9bd4d697f39cc5fb6e.1359013702.git.hans.verkuil@cisco.com>
In-Reply-To: <1359013876-12443-1-git-send-email-hverkuil@xs4all.nl>
References: <1359013876-12443-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When the control IDs were split off from videodev2.h to v4l2-controls.h
these new Digital Video controls were forgotten (the two patches may
have crossed one another).

Move these controls to their proper place in v4l2-controls.h.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/v4l2-controls.h |   24 ++++++++++++++++++++++++
 include/uapi/linux/videodev2.h     |   22 ----------------------
 2 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 4dc0822..0bece06 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -778,6 +778,7 @@ enum v4l2_jpeg_chroma_subsampling {
 #define	V4L2_JPEG_ACTIVE_MARKER_DQT		(1 << 17)
 #define	V4L2_JPEG_ACTIVE_MARKER_DHT		(1 << 18)
 
+
 /* Image source controls */
 #define V4L2_CID_IMAGE_SOURCE_CLASS_BASE	(V4L2_CTRL_CLASS_IMAGE_SOURCE | 0x900)
 #define V4L2_CID_IMAGE_SOURCE_CLASS		(V4L2_CTRL_CLASS_IMAGE_SOURCE | 1)
@@ -796,4 +797,27 @@ enum v4l2_jpeg_chroma_subsampling {
 #define V4L2_CID_PIXEL_RATE			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 2)
 #define V4L2_CID_TEST_PATTERN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 3)
 
+
+/*  DV-class control IDs defined by V4L2 */
+#define V4L2_CID_DV_CLASS_BASE			(V4L2_CTRL_CLASS_DV | 0x900)
+#define V4L2_CID_DV_CLASS			(V4L2_CTRL_CLASS_DV | 1)
+
+#define	V4L2_CID_DV_TX_HOTPLUG			(V4L2_CID_DV_CLASS_BASE + 1)
+#define	V4L2_CID_DV_TX_RXSENSE			(V4L2_CID_DV_CLASS_BASE + 2)
+#define	V4L2_CID_DV_TX_EDID_PRESENT		(V4L2_CID_DV_CLASS_BASE + 3)
+#define	V4L2_CID_DV_TX_MODE			(V4L2_CID_DV_CLASS_BASE + 4)
+enum v4l2_dv_tx_mode {
+	V4L2_DV_TX_MODE_DVI_D	= 0,
+	V4L2_DV_TX_MODE_HDMI	= 1,
+};
+#define V4L2_CID_DV_TX_RGB_RANGE		(V4L2_CID_DV_CLASS_BASE + 5)
+enum v4l2_dv_rgb_range {
+	V4L2_DV_RGB_RANGE_AUTO	  = 0,
+	V4L2_DV_RGB_RANGE_LIMITED = 1,
+	V4L2_DV_RGB_RANGE_FULL	  = 2,
+};
+
+#define	V4L2_CID_DV_RX_POWER_PRESENT		(V4L2_CID_DV_CLASS_BASE + 100)
+#define V4L2_CID_DV_RX_RGB_RANGE		(V4L2_CID_DV_CLASS_BASE + 101)
+
 #endif
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 94cbe26..132a9c5 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1354,28 +1354,6 @@ struct v4l2_querymenu {
 #define V4L2_CID_PRIVATE_BASE		0x08000000
 
 
-/*  DV-class control IDs defined by V4L2 */
-#define V4L2_CID_DV_CLASS_BASE			(V4L2_CTRL_CLASS_DV | 0x900)
-#define V4L2_CID_DV_CLASS			(V4L2_CTRL_CLASS_DV | 1)
-
-#define	V4L2_CID_DV_TX_HOTPLUG			(V4L2_CID_DV_CLASS_BASE + 1)
-#define	V4L2_CID_DV_TX_RXSENSE			(V4L2_CID_DV_CLASS_BASE + 2)
-#define	V4L2_CID_DV_TX_EDID_PRESENT		(V4L2_CID_DV_CLASS_BASE + 3)
-#define	V4L2_CID_DV_TX_MODE			(V4L2_CID_DV_CLASS_BASE + 4)
-enum v4l2_dv_tx_mode {
-	V4L2_DV_TX_MODE_DVI_D	= 0,
-	V4L2_DV_TX_MODE_HDMI	= 1,
-};
-#define V4L2_CID_DV_TX_RGB_RANGE		(V4L2_CID_DV_CLASS_BASE + 5)
-enum v4l2_dv_rgb_range {
-	V4L2_DV_RGB_RANGE_AUTO	  = 0,
-	V4L2_DV_RGB_RANGE_LIMITED = 1,
-	V4L2_DV_RGB_RANGE_FULL	  = 2,
-};
-
-#define	V4L2_CID_DV_RX_POWER_PRESENT		(V4L2_CID_DV_CLASS_BASE + 100)
-#define V4L2_CID_DV_RX_RGB_RANGE		(V4L2_CID_DV_CLASS_BASE + 101)
-
 /*
  *	T U N I N G
  */
-- 
1.7.10.4

