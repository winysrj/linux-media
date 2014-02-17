Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2988 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaBQJ7G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 04:59:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH 27/35] v4l2-ctrls/v4l2-controls.h: add MD controls
Date: Mon, 17 Feb 2014 10:57:42 +0100
Message-Id: <1392631070-41868-28-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
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
index 2a73360..859ac29 100644
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
@@ -861,6 +870,15 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_FM_RX_CLASS:		return "FM Radio Receiver Controls";
 	case V4L2_CID_TUNE_DEEMPHASIS:		return "De-Emphasis";
 	case V4L2_CID_RDS_RECEPTION:		return "RDS Reception";
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
@@ -971,6 +989,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, const char **unit,
 	case V4L2_CID_TEST_PATTERN:
 	case V4L2_CID_TUNE_DEEMPHASIS:
 	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
+	case V4L2_CID_DETECT_MD_MODE:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_LINK_FREQ:
@@ -996,6 +1015,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, const char **unit,
 	case V4L2_CID_IMAGE_PROC_CLASS:
 	case V4L2_CID_DV_CLASS:
 	case V4L2_CID_FM_RX_CLASS:
+	case V4L2_CID_DETECT_CLASS:
 		*type = V4L2_CTRL_TYPE_CTRL_CLASS;
 		/* You can neither read not write these */
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_WRITE_ONLY;
@@ -1041,6 +1061,12 @@ void v4l2_ctrl_fill(u32 id, const char **name, const char **unit,
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
@@ -1077,6 +1103,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, const char **unit,
 	case V4L2_CID_PILOT_TONE_FREQUENCY:
 	case V4L2_CID_TUNE_POWER_LEVEL:
 	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:
+	case V4L2_CID_DETECT_MD_GLOBAL_THRESHOLD:
 		*flags |= V4L2_CTRL_FLAG_SLIDER;
 		break;
 	case V4L2_CID_PAN_RELATIVE:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 2cbe605..93ff343 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -60,6 +60,7 @@
 #define V4L2_CTRL_CLASS_IMAGE_PROC	0x009f0000	/* Image processing controls */
 #define V4L2_CTRL_CLASS_DV		0x00a00000	/* Digital Video controls */
 #define V4L2_CTRL_CLASS_FM_RX		0x00a10000	/* FM Receiver controls */
+#define V4L2_CTRL_CLASS_DETECT		0x00a20000	/* Detection controls */
 
 /* User-class control IDs */
 
@@ -895,4 +896,20 @@ enum v4l2_deemphasis {
 
 #define V4L2_CID_RDS_RECEPTION			(V4L2_CID_FM_RX_CLASS_BASE + 2)
 
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
1.8.4.rc3

