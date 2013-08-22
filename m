Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3608 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab3HVKOv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 06:14:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: ismael.luceno@corp.bluecherry.net, pete@sensoray.com,
	sakari.ailus@iki.fi, sylvester.nawrocki@gmail.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 01/10] v4l2-controls: add motion detection controls.
Date: Thu, 22 Aug 2013 12:14:15 +0200
Message-Id: <7c5a78eea892dd37d172f24081402be354758894.1377166147.git.hans.verkuil@cisco.com>
In-Reply-To: <1377166464-27448-1-git-send-email-hverkuil@xs4all.nl>
References: <1377166464-27448-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for two motion detection controls and a 'detect control class'.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 33 +++++++++++++++++++++++++++------
 include/uapi/linux/v4l2-controls.h   | 14 ++++++++++++++
 2 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index fccd08b..89e7cfb 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -456,6 +456,12 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"RGB full range (0-255)",
 		NULL,
 	};
+	static const char * const detect_motion_mode[] = {
+		"Disabled",
+		"Global",
+		"Regional",
+		NULL,
+	};
 
 
 	switch (id) {
@@ -545,6 +551,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 	case V4L2_CID_DV_TX_RGB_RANGE:
 	case V4L2_CID_DV_RX_RGB_RANGE:
 		return dv_rgb_range;
+	case V4L2_CID_DETECT_MOTION_MODE:
+		return detect_motion_mode;
 
 	default:
 		return NULL;
@@ -557,7 +565,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 {
 	switch (id) {
 	/* USER controls */
-	/* Keep the order of the 'case's the same as in videodev2.h! */
+	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_USER_CLASS:		return "User Controls";
 	case V4L2_CID_BRIGHTNESS:		return "Brightness";
 	case V4L2_CID_CONTRAST:			return "Contrast";
@@ -601,7 +609,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_COLORFX_CBCR:		return "Color Effects, CbCr";
 
 	/* MPEG controls */
-	/* Keep the order of the 'case's the same as in videodev2.h! */
+	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_MPEG_CLASS:		return "MPEG Encoder Controls";
 	case V4L2_CID_MPEG_STREAM_TYPE:		return "Stream Type";
 	case V4L2_CID_MPEG_STREAM_PID_PMT:	return "Stream PMT Program ID";
@@ -701,7 +709,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:		return "Repeat Sequence Header";
 
 	/* CAMERA controls */
-	/* Keep the order of the 'case's the same as in videodev2.h! */
+	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_CAMERA_CLASS:		return "Camera Controls";
 	case V4L2_CID_EXPOSURE_AUTO:		return "Auto Exposure";
 	case V4L2_CID_EXPOSURE_ABSOLUTE:	return "Exposure Time, Absolute";
@@ -735,8 +743,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_AUTO_FOCUS_STATUS:	return "Auto Focus, Status";
 	case V4L2_CID_AUTO_FOCUS_RANGE:		return "Auto Focus, Range";
 
-	/* FM Radio Modulator control */
-	/* Keep the order of the 'case's the same as in videodev2.h! */
+	/* FM Radio Modulator controls */
+	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_FM_TX_CLASS:		return "FM Radio Modulator Controls";
 	case V4L2_CID_RDS_TX_DEVIATION:		return "RDS Signal Deviation";
 	case V4L2_CID_RDS_TX_PI:		return "RDS Program ID";
@@ -759,6 +767,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:	return "Tune Antenna Capacitor";
 
 	/* Flash controls */
+	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_FLASH_CLASS:		return "Flash Controls";
 	case V4L2_CID_FLASH_LED_MODE:		return "LED Mode";
 	case V4L2_CID_FLASH_STROBE_SOURCE:	return "Strobe Source";
@@ -774,7 +783,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_FLASH_READY:		return "Ready to Strobe";
 
 	/* JPEG encoder controls */
-	/* Keep the order of the 'case's the same as in videodev2.h! */
+	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_JPEG_CLASS:		return "JPEG Compression Controls";
 	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:	return "Chroma Subsampling";
 	case V4L2_CID_JPEG_RESTART_INTERVAL:	return "Restart Interval";
@@ -782,18 +791,21 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_JPEG_ACTIVE_MARKER:	return "Active Markers";
 
 	/* Image source controls */
+	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_IMAGE_SOURCE_CLASS:	return "Image Source Controls";
 	case V4L2_CID_VBLANK:			return "Vertical Blanking";
 	case V4L2_CID_HBLANK:			return "Horizontal Blanking";
 	case V4L2_CID_ANALOGUE_GAIN:		return "Analogue Gain";
 
 	/* Image processing controls */
+	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_IMAGE_PROC_CLASS:		return "Image Processing Controls";
 	case V4L2_CID_LINK_FREQ:		return "Link Frequency";
 	case V4L2_CID_PIXEL_RATE:		return "Pixel Rate";
 	case V4L2_CID_TEST_PATTERN:		return "Test Pattern";
 
 	/* DV controls */
+	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_DV_CLASS:			return "Digital Video Controls";
 	case V4L2_CID_DV_TX_HOTPLUG:		return "Hotplug Present";
 	case V4L2_CID_DV_TX_RXSENSE:		return "RxSense Present";
@@ -806,6 +818,12 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_FM_RX_CLASS:		return "FM Radio Receiver Controls";
 	case V4L2_CID_TUNE_DEEMPHASIS:		return "De-Emphasis";
 	case V4L2_CID_RDS_RECEPTION:		return "RDS Reception";
+
+	/* FM Radio Receiver controls */
+	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
+	case V4L2_CID_DETECT_CLASS:		return "Detection Controls";
+	case V4L2_CID_DETECT_MOTION_MODE:	return "Motion Detection Mode";
+	case V4L2_CID_DETECT_MOTION_THRESHOLD:	return "Motion Detection Threshold";
 	default:
 		return NULL;
 	}
@@ -914,6 +932,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_DV_RX_RGB_RANGE:
 	case V4L2_CID_TEST_PATTERN:
 	case V4L2_CID_TUNE_DEEMPHASIS:
+	case V4L2_CID_DETECT_MOTION_MODE:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_LINK_FREQ:
@@ -937,6 +956,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_IMAGE_PROC_CLASS:
 	case V4L2_CID_DV_CLASS:
 	case V4L2_CID_FM_RX_CLASS:
+	case V4L2_CID_DETECT_CLASS:
 		*type = V4L2_CTRL_TYPE_CTRL_CLASS;
 		/* You can neither read not write these */
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_WRITE_ONLY;
@@ -1009,6 +1029,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_PILOT_TONE_FREQUENCY:
 	case V4L2_CID_TUNE_POWER_LEVEL:
 	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:
+	case V4L2_CID_DETECT_MOTION_THRESHOLD:
 		*flags |= V4L2_CTRL_FLAG_SLIDER;
 		break;
 	case V4L2_CID_PAN_RELATIVE:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index e90a88a..d88eebd 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -60,6 +60,7 @@
 #define V4L2_CTRL_CLASS_IMAGE_PROC	0x009f0000	/* Image processing controls */
 #define V4L2_CTRL_CLASS_DV		0x00a00000	/* Digital Video controls */
 #define V4L2_CTRL_CLASS_FM_RX		0x00a10000	/* FM Receiver controls */
+#define V4L2_CTRL_CLASS_DETECT		0x00a20000	/* Detection controls */
 
 /* User-class control IDs */
 
@@ -853,4 +854,17 @@ enum v4l2_deemphasis {
 
 #define V4L2_CID_RDS_RECEPTION			(V4L2_CID_FM_RX_CLASS_BASE + 2)
 
+
+/*  Detection-class control IDs defined by V4L2 */
+#define V4L2_CID_DETECT_CLASS_BASE		(V4L2_CTRL_CLASS_DETECT | 0x900)
+#define V4L2_CID_DETECT_CLASS			(V4L2_CTRL_CLASS_DETECT | 1)
+
+#define	V4L2_CID_DETECT_MOTION_MODE		(V4L2_CID_DETECT_CLASS_BASE + 1)
+enum v4l2_detect_motion_mode {
+	V4L2_DETECT_MOTION_DISABLED	= 0,
+	V4L2_DETECT_MOTION_GLOBAL	= 1,
+	V4L2_DETECT_MOTION_REGIONAL	= 2,
+};
+#define	V4L2_CID_DETECT_MOTION_THRESHOLD	(V4L2_CID_DETECT_CLASS_BASE + 2)
+
 #endif
-- 
1.8.3.2

