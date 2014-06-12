Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2751 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236AbaFLLyq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 26/34] v4l2-ctrls/v4l2-controls.h: add MD controls
Date: Thu, 12 Jun 2014 13:52:58 +0200
Message-Id: <9db872d06f8e7930acbcd4e6f4aac034eda05347.1402573818.git.hans.verkuil@cisco.com>
In-Reply-To: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
References: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
References: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add the 'Detect' control class and the new motion detection controls.
Those controls will be used by the solo6x10 and go7007 drivers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 27 +++++++++++++++++++++++++++
 include/uapi/linux/v4l2-controls.h   | 17 +++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 5aaf15e..5c3b8de 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -462,6 +462,13 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"RGB full range (0-255)",
 		NULL,
 	};
+	static const char * const detect_md_mode[] = {
+		"Disabled",
+		"Global",
+		"Threshold Grid",
+		"Region Grid",
+		NULL,
+	};
 
 
 	switch (id) {
@@ -553,6 +560,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 	case V4L2_CID_DV_TX_RGB_RANGE:
 	case V4L2_CID_DV_RX_RGB_RANGE:
 		return dv_rgb_range;
+	case V4L2_CID_DETECT_MD_MODE:
+		return detect_md_mode;
 
 	default:
 		return NULL;
@@ -874,6 +883,15 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_RF_TUNER_BANDWIDTH_AUTO:	return "Bandwidth, Auto";
 	case V4L2_CID_RF_TUNER_BANDWIDTH:	return "Bandwidth";
 	case V4L2_CID_RF_TUNER_PLL_LOCK:	return "PLL Lock";
+
+	/* Detection controls */
+	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
+	case V4L2_CID_DETECT_CLASS:		return "Detection Controls";
+	case V4L2_CID_DETECT_MD_MODE:		return "Motion Detection Mode";
+	case V4L2_CID_DETECT_MD_GLOBAL_THRESHOLD: return "MD Global Threshold";
+	case V4L2_CID_DETECT_MD_THRESHOLD_GRID:	return "MD Threshold Grid";
+	case V4L2_CID_DETECT_MD_REGION_GRID:	return "MD Region Grid";
+
 	default:
 		return NULL;
 	}
@@ -992,6 +1010,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_TEST_PATTERN:
 	case V4L2_CID_TUNE_DEEMPHASIS:
 	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
+	case V4L2_CID_DETECT_MD_MODE:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_LINK_FREQ:
@@ -1018,6 +1037,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_DV_CLASS:
 	case V4L2_CID_FM_RX_CLASS:
 	case V4L2_CID_RF_TUNER_CLASS:
+	case V4L2_CID_DETECT_CLASS:
 		*type = V4L2_CTRL_TYPE_CTRL_CLASS;
 		/* You can neither read not write these */
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_WRITE_ONLY;
@@ -1063,6 +1083,12 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		*type = V4L2_CTRL_TYPE_INTEGER64;
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
 		break;
+	case V4L2_CID_DETECT_MD_REGION_GRID:
+		*type = V4L2_CTRL_TYPE_U8;
+		break;
+	case V4L2_CID_DETECT_MD_THRESHOLD_GRID:
+		*type = V4L2_CTRL_TYPE_U16;
+		break;
 	default:
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		break;
@@ -1103,6 +1129,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_RF_TUNER_MIXER_GAIN:
 	case V4L2_CID_RF_TUNER_IF_GAIN:
 	case V4L2_CID_RF_TUNER_BANDWIDTH:
+	case V4L2_CID_DETECT_MD_GLOBAL_THRESHOLD:
 		*flags |= V4L2_CTRL_FLAG_SLIDER;
 		break;
 	case V4L2_CID_PAN_RELATIVE:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 2ac5597..db526d1 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -61,6 +61,7 @@
 #define V4L2_CTRL_CLASS_DV		0x00a00000	/* Digital Video controls */
 #define V4L2_CTRL_CLASS_FM_RX		0x00a10000	/* FM Receiver controls */
 #define V4L2_CTRL_CLASS_RF_TUNER	0x00a20000	/* RF tuner controls */
+#define V4L2_CTRL_CLASS_DETECT		0x00a30000	/* Detection controls */
 
 /* User-class control IDs */
 
@@ -914,4 +915,20 @@ enum v4l2_deemphasis {
 #define V4L2_CID_RF_TUNER_IF_GAIN		(V4L2_CID_RF_TUNER_CLASS_BASE + 62)
 #define V4L2_CID_RF_TUNER_PLL_LOCK			(V4L2_CID_RF_TUNER_CLASS_BASE + 91)
 
+
+/*  Detection-class control IDs defined by V4L2 */
+#define V4L2_CID_DETECT_CLASS_BASE		(V4L2_CTRL_CLASS_DETECT | 0x900)
+#define V4L2_CID_DETECT_CLASS			(V4L2_CTRL_CLASS_DETECT | 1)
+
+#define V4L2_CID_DETECT_MD_MODE			(V4L2_CID_DETECT_CLASS_BASE + 1)
+enum v4l2_detect_md_mode {
+	V4L2_DETECT_MD_MODE_DISABLED		= 0,
+	V4L2_DETECT_MD_MODE_GLOBAL		= 1,
+	V4L2_DETECT_MD_MODE_THRESHOLD_GRID	= 2,
+	V4L2_DETECT_MD_MODE_REGION_GRID		= 3,
+};
+#define V4L2_CID_DETECT_MD_GLOBAL_THRESHOLD	(V4L2_CID_DETECT_CLASS_BASE + 2)
+#define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
+#define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
+
 #endif
-- 
2.0.0.rc0

