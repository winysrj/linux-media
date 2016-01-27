Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:35698 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753745AbcA0H5K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 02:57:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] v4l2-ctrls: add V4L2_CID_DV_TX_CONTENT_TYPE
Date: Wed, 27 Jan 2016 08:57:00 +0100
Message-Id: <1453881421-15865-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1453881421-15865-1-git-send-email-hverkuil@xs4all.nl>
References: <1453881421-15865-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add new control to set the content type of an HDMI/DP AVI InfoFrame.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 11 +++++++++++
 include/uapi/linux/v4l2-controls.h   |  8 ++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index c9d5537..ecfa5d7 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -462,6 +462,13 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"RGB full range (0-255)",
 		NULL,
 	};
+	static const char * const dv_content_type[] = {
+		"Graphics",
+		"Photo",
+		"Cinema",
+		"Game",
+		NULL,
+	};
 	static const char * const detect_md_mode[] = {
 		"Disabled",
 		"Global",
@@ -560,6 +567,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 	case V4L2_CID_DV_TX_RGB_RANGE:
 	case V4L2_CID_DV_RX_RGB_RANGE:
 		return dv_rgb_range;
+	case V4L2_CID_DV_TX_CONTENT_TYPE:
+		return dv_content_type;
 	case V4L2_CID_DETECT_MD_MODE:
 		return detect_md_mode;
 
@@ -881,6 +890,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_DV_TX_EDID_PRESENT:	return "EDID Present";
 	case V4L2_CID_DV_TX_MODE:		return "Transmit Mode";
 	case V4L2_CID_DV_TX_RGB_RANGE:		return "Tx RGB Quantization Range";
+	case V4L2_CID_DV_TX_CONTENT_TYPE:	return "Tx Content Type";
 	case V4L2_CID_DV_RX_POWER_PRESENT:	return "Power Present";
 	case V4L2_CID_DV_RX_RGB_RANGE:		return "Rx RGB Quantization Range";
 
@@ -1038,6 +1048,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_SCENE_MODE:
 	case V4L2_CID_DV_TX_MODE:
 	case V4L2_CID_DV_TX_RGB_RANGE:
+	case V4L2_CID_DV_TX_CONTENT_TYPE:
 	case V4L2_CID_DV_RX_RGB_RANGE:
 	case V4L2_CID_TEST_PATTERN:
 	case V4L2_CID_TUNE_DEEMPHASIS:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 2d225bc..9303717 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -912,6 +912,14 @@ enum v4l2_dv_rgb_range {
 	V4L2_DV_RGB_RANGE_FULL	  = 2,
 };
 
+#define V4L2_CID_DV_TX_CONTENT_TYPE		(V4L2_CID_DV_CLASS_BASE + 6)
+enum v4l2_dv_content_type {
+	V4L2_DV_CONTENT_TYPE_GRAPHICS	  = 0,
+	V4L2_DV_CONTENT_TYPE_PHOTO	  = 1,
+	V4L2_DV_CONTENT_TYPE_CINEMA	  = 2,
+	V4L2_DV_CONTENT_TYPE_GAME	  = 3,
+};
+
 #define	V4L2_CID_DV_RX_POWER_PRESENT		(V4L2_CID_DV_CLASS_BASE + 100)
 #define V4L2_CID_DV_RX_RGB_RANGE		(V4L2_CID_DV_CLASS_BASE + 101)
 
-- 
2.7.0.rc3

