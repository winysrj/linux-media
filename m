Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:49855 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759836Ab3BZQcI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Feb 2013 11:32:08 -0500
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: andrew.smirnov@gmail.com
Cc: hverkuil@xs4all.nl, mchehab@redhat.com, sameo@linux.intel.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 6/9] v4l2: Add standard controls for FM receivers
Date: Tue, 26 Feb 2013 08:31:32 -0800
Message-Id: <1361896295-26138-7-git-send-email-andrew.smirnov@gmail.com>
In-Reply-To: <1361896295-26138-1-git-send-email-andrew.smirnov@gmail.com>
References: <1361896295-26138-1-git-send-email-andrew.smirnov@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This commit introduces new class of standard controls
V4L2_CTRL_CLASS_FM_RX. This class is intended to all controls
pertaining to FM receiver chips. Also, two controls belonging to said
class are added as a part of this commit: V4L2_CID_TUNE_DEEMPHASIS and
V4L2_CID_RDS_RECEPTION.

This patch is based on the code found in the patch by Manjunatha Halli [1]

[1] http://lists-archives.com/linux-kernel/27641307-new-control-class-and-features-for-fm-rx.html

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c |   14 +++++++++++---
 include/uapi/linux/v4l2-controls.h   |   13 +++++++++++++
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 6b28b58..8b89fb8 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -297,8 +297,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Text",
 		NULL
 	};
-	static const char * const tune_preemphasis[] = {
-		"No Preemphasis",
+	static const char * const tune_emphasis[] = {
+		"None",
 		"50 Microseconds",
 		"75 Microseconds",
 		NULL,
@@ -508,7 +508,9 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 	case V4L2_CID_SCENE_MODE:
 		return scene_mode;
 	case V4L2_CID_TUNE_PREEMPHASIS:
-		return tune_preemphasis;
+		return tune_emphasis;
+	case V4L2_CID_TUNE_DEEMPHASIS:
+		return tune_emphasis;
 	case V4L2_CID_FLASH_LED_MODE:
 		return flash_led_mode;
 	case V4L2_CID_FLASH_STROBE_SOURCE:
@@ -799,6 +801,9 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_DV_RX_POWER_PRESENT:	return "Power Present";
 	case V4L2_CID_DV_RX_RGB_RANGE:		return "Rx RGB Quantization Range";
 
+	case V4L2_CID_FM_RX_CLASS:		return "FM Radio Receiver Controls";
+	case V4L2_CID_TUNE_DEEMPHASIS:		return "De-Emphasis";
+	case V4L2_CID_RDS_RECEPTION:		return "RDS Reception";
 	default:
 		return NULL;
 	}
@@ -846,6 +851,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_MPEG4_QPEL:
 	case V4L2_CID_WIDE_DYNAMIC_RANGE:
 	case V4L2_CID_IMAGE_STABILIZATION:
+	case V4L2_CID_RDS_RECEPTION:
 		*type = V4L2_CTRL_TYPE_BOOLEAN;
 		*min = 0;
 		*max = *step = 1;
@@ -904,6 +910,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_DV_TX_RGB_RANGE:
 	case V4L2_CID_DV_RX_RGB_RANGE:
 	case V4L2_CID_TEST_PATTERN:
+	case V4L2_CID_TUNE_DEEMPHASIS:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_LINK_FREQ:
@@ -926,6 +933,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_IMAGE_SOURCE_CLASS:
 	case V4L2_CID_IMAGE_PROC_CLASS:
 	case V4L2_CID_DV_CLASS:
+	case V4L2_CID_FM_RX_CLASS:
 		*type = V4L2_CTRL_TYPE_CTRL_CLASS;
 		/* You can neither read not write these */
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_WRITE_ONLY;
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index dcd6374..3e985be 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -59,6 +59,7 @@
 #define V4L2_CTRL_CLASS_IMAGE_SOURCE	0x009e0000	/* Image source controls */
 #define V4L2_CTRL_CLASS_IMAGE_PROC	0x009f0000	/* Image processing controls */
 #define V4L2_CTRL_CLASS_DV		0x00a00000	/* Digital Video controls */
+#define V4L2_CTRL_CLASS_FM_RX		0x00a10000	/* Digital Video controls */
 
 /* User-class control IDs */
 
@@ -825,4 +826,16 @@ enum v4l2_dv_rgb_range {
 #define	V4L2_CID_DV_RX_POWER_PRESENT		(V4L2_CID_DV_CLASS_BASE + 100)
 #define V4L2_CID_DV_RX_RGB_RANGE		(V4L2_CID_DV_CLASS_BASE + 101)
 
+#define V4L2_CID_FM_RX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_RX | 0x900)
+#define V4L2_CID_FM_RX_CLASS			(V4L2_CTRL_CLASS_FM_RX | 1)
+
+#define V4L2_CID_TUNE_DEEMPHASIS		(V4L2_CID_FM_RX_CLASS_BASE + 1)
+enum v4l2_deemphasis {
+	V4L2_DEEMPHASIS_DISABLED	= V4L2_PREEMPHASIS_DISABLED,
+	V4L2_DEEMPHASIS_50_uS		= V4L2_PREEMPHASIS_50_uS,
+	V4L2_DEEMPHASIS_75_uS		= V4L2_PREEMPHASIS_75_uS,
+};
+
+#define V4L2_CID_RDS_RECEPTION			(V4L2_CID_FM_RX_CLASS_BASE + 2)
+
 #endif
-- 
1.7.10.4

