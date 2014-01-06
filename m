Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3851 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773AbaAFOVn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 09:21:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 24/27] v4l2-controls.h: add new property class and new properties.
Date: Mon,  6 Jan 2014 15:21:23 +0100
Message-Id: <1389018086-15903-25-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1389018086-15903-1-git-send-email-hverkuil@xs4all.nl>
References: <1389018086-15903-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a class for properties (for demonstration purposes only, will need to be
renamed) and capture/output crop/compose and motion detection matrix
properties.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c |  3 +++
 include/uapi/linux/v4l2-controls.h   | 16 ++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 0014324..2191451 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -852,6 +852,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_FM_RX_CLASS:		return "FM Radio Receiver Controls";
 	case V4L2_CID_TUNE_DEEMPHASIS:		return "De-Emphasis";
 	case V4L2_CID_RDS_RECEPTION:		return "RDS Reception";
+
+	case V4L2_CID_PROPS_CLASS:		return "Properties";
 	default:
 		return NULL;
 	}
@@ -987,6 +989,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, const char **unit,
 	case V4L2_CID_IMAGE_PROC_CLASS:
 	case V4L2_CID_DV_CLASS:
 	case V4L2_CID_FM_RX_CLASS:
+	case V4L2_CID_PROPS_CLASS:
 		*type = V4L2_CTRL_TYPE_CTRL_CLASS;
 		/* You can neither read not write these */
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_WRITE_ONLY;
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 1666aab..6c3616e 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -60,6 +60,7 @@
 #define V4L2_CTRL_CLASS_IMAGE_PROC	0x009f0000	/* Image processing controls */
 #define V4L2_CTRL_CLASS_DV		0x00a00000	/* Digital Video controls */
 #define V4L2_CTRL_CLASS_FM_RX		0x00a10000	/* FM Receiver controls */
+#define V4L2_CTRL_CLASS_PROPS		0x00a20000	/* Properties */
 
 /* User-class control IDs */
 
@@ -886,4 +887,19 @@ enum v4l2_deemphasis {
 
 #define V4L2_CID_RDS_RECEPTION			(V4L2_CID_FM_RX_CLASS_BASE + 2)
 
+
+/* Properties */
+
+#define V4L2_CID_PROPS_CLASS_BASE		(V4L2_CTRL_CLASS_PROPS | 0x900)
+#define V4L2_CID_PROPS_CLASS			(V4L2_CTRL_CLASS_PROPS | 1)
+
+#define V4L2_CID_CAPTURE_CROP			(V4L2_CID_PROPS_CLASS_BASE + 0)
+#define V4L2_CID_CAPTURE_COMPOSE		(V4L2_CID_PROPS_CLASS_BASE + 1)
+#define V4L2_CID_OUTPUT_CROP			(V4L2_CID_PROPS_CLASS_BASE + 2)
+#define V4L2_CID_OUTPUT_COMPOSE			(V4L2_CID_PROPS_CLASS_BASE + 3)
+
+/* TODO: use a Motion Detection property class */
+#define V4L2_CID_MD_REGION			(V4L2_CID_PROPS_CLASS_BASE + 4)
+#define V4L2_CID_MD_THRESHOLD			(V4L2_CID_PROPS_CLASS_BASE + 5)
+
 #endif
-- 
1.8.5.2

