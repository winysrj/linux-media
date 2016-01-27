Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:55758 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932139AbcA0NFN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 08:05:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 1/5] v4l2-ctrls: add V4L2_CID_DV_RX/TX_IT_CONTENT_TYPE controls
Date: Wed, 27 Jan 2016 14:04:59 +0100
Message-Id: <1453899903-17790-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1453899903-17790-1-git-send-email-hverkuil@xs4all.nl>
References: <1453899903-17790-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

HDMI and DisplayPort both support IT Content Type information that
tells the receiver what type of material the video is, graphics such
as from a PC desktop, Photo, Cinema or Game (low-latency).

This patch adds controls for receivers and transmitters to get/set
this information.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 16 ++++++++++++++++
 include/uapi/linux/v4l2-controls.h   | 10 ++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index c9d5537..bed04b1 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -462,6 +462,14 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"RGB full range (0-255)",
 		NULL,
 	};
+	static const char * const dv_it_content_type[] = {
+		"Graphics",
+		"Photo",
+		"Cinema",
+		"Game",
+		"No IT Content",
+		NULL,
+	};
 	static const char * const detect_md_mode[] = {
 		"Disabled",
 		"Global",
@@ -560,6 +568,9 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 	case V4L2_CID_DV_TX_RGB_RANGE:
 	case V4L2_CID_DV_RX_RGB_RANGE:
 		return dv_rgb_range;
+	case V4L2_CID_DV_TX_IT_CONTENT_TYPE:
+	case V4L2_CID_DV_RX_IT_CONTENT_TYPE:
+		return dv_it_content_type;
 	case V4L2_CID_DETECT_MD_MODE:
 		return detect_md_mode;
 
@@ -881,8 +892,10 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_DV_TX_EDID_PRESENT:	return "EDID Present";
 	case V4L2_CID_DV_TX_MODE:		return "Transmit Mode";
 	case V4L2_CID_DV_TX_RGB_RANGE:		return "Tx RGB Quantization Range";
+	case V4L2_CID_DV_TX_IT_CONTENT_TYPE:	return "Tx IT Content Type";
 	case V4L2_CID_DV_RX_POWER_PRESENT:	return "Power Present";
 	case V4L2_CID_DV_RX_RGB_RANGE:		return "Rx RGB Quantization Range";
+	case V4L2_CID_DV_RX_IT_CONTENT_TYPE:	return "Rx IT Content Type";
 
 	case V4L2_CID_FM_RX_CLASS:		return "FM Radio Receiver Controls";
 	case V4L2_CID_TUNE_DEEMPHASIS:		return "De-Emphasis";
@@ -1038,7 +1051,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_SCENE_MODE:
 	case V4L2_CID_DV_TX_MODE:
 	case V4L2_CID_DV_TX_RGB_RANGE:
+	case V4L2_CID_DV_TX_IT_CONTENT_TYPE:
 	case V4L2_CID_DV_RX_RGB_RANGE:
+	case V4L2_CID_DV_RX_IT_CONTENT_TYPE:
 	case V4L2_CID_TEST_PATTERN:
 	case V4L2_CID_TUNE_DEEMPHASIS:
 	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
@@ -1185,6 +1200,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_DV_TX_RXSENSE:
 	case V4L2_CID_DV_TX_EDID_PRESENT:
 	case V4L2_CID_DV_RX_POWER_PRESENT:
+	case V4L2_CID_DV_RX_IT_CONTENT_TYPE:
 	case V4L2_CID_RDS_RX_PTY:
 	case V4L2_CID_RDS_RX_PS_NAME:
 	case V4L2_CID_RDS_RX_RADIO_TEXT:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 2d225bc..2ae5c3e 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -912,8 +912,18 @@ enum v4l2_dv_rgb_range {
 	V4L2_DV_RGB_RANGE_FULL	  = 2,
 };
 
+#define V4L2_CID_DV_TX_IT_CONTENT_TYPE		(V4L2_CID_DV_CLASS_BASE + 6)
+enum v4l2_dv_it_content_type {
+	V4L2_DV_IT_CONTENT_TYPE_GRAPHICS  = 0,
+	V4L2_DV_IT_CONTENT_TYPE_PHOTO	  = 1,
+	V4L2_DV_IT_CONTENT_TYPE_CINEMA	  = 2,
+	V4L2_DV_IT_CONTENT_TYPE_GAME	  = 3,
+	V4L2_DV_IT_CONTENT_TYPE_NO_ITC	  = 4,
+};
+
 #define	V4L2_CID_DV_RX_POWER_PRESENT		(V4L2_CID_DV_CLASS_BASE + 100)
 #define V4L2_CID_DV_RX_RGB_RANGE		(V4L2_CID_DV_CLASS_BASE + 101)
+#define V4L2_CID_DV_RX_IT_CONTENT_TYPE		(V4L2_CID_DV_CLASS_BASE + 102)
 
 #define V4L2_CID_FM_RX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_RX | 0x900)
 #define V4L2_CID_FM_RX_CLASS			(V4L2_CTRL_CLASS_FM_RX | 1)
-- 
2.7.0.rc3

