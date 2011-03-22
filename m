Return-path: <mchehab@pedra>
Received: from mailout3.samsung.com ([203.254.224.33]:49843 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab1CVIxS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 04:53:18 -0400
Received: from epmmp1 (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LIG001C2B9NKX10@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Mar 2011 17:51:23 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LIG003AGB9ND5@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Mar 2011 17:51:23 +0900 (KST)
Date: Tue, 22 Mar 2011 17:51:19 +0900
From: "Kim, Heungjun" <riverful.kim@samsung.com>
Subject: [RFC PATCH v3 1/2] v4l2-ctrls: support various modes and 4 coordinates
 of rectangle auto focus
In-reply-to: <4D886294.5060300@samsung.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, kyungmin.park@samsung.com,
	"Kim, Heungjun" <riverful.kim@samsung.com>
Message-id: <1300783880-15157-1-git-send-email-riverful.kim@samsung.com>
Content-transfer-encoding: 7BIT
References: <4D886294.5060300@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

It supports various modes of auto focus. Each modes define as the enumerations
of menu type.

	V4L2_FOCUS_AUTO_NORMAL,
	V4L2_FOCUS_AUTO_MACRO,
	V4L2_FOCUS_AUTO_CONTINUOUS,
	V4L2_FOCUS_AUTO_FACE_DETECTION,
	V4L2_FOCUS_AUTO_RECTANGLE

In the cause of rectangle it needs the 4 kinds of coordinate control ID of
integer type for expression about focus-spot, and each control ID means
similar to the struct v4l2_rect.

	V4L2_CID_FOCUS_AUTO_RECTANGLE_LEFT
	V4L2_CID_FOCUS_AUTO_RECTANGLE_TOP
	V4L2_CID_FOCUS_AUTO_RECTANGLE_WIDTH
	V4L2_CID_FOCUS_AUTO_RECTANGLE_HEIGHT

Signed-off-by: Kim, Heungjun <riverful.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/v4l2-ctrls.c |   16 ++++++++++++++++
 include/linux/videodev2.h        |   13 +++++++++++++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 2412f08..365540f 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -197,6 +197,14 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Aperture Priority Mode",
 		NULL
 	};
+	static const char * const camera_focus_auto_mode[] = {
+		"Normal Mode",
+		"Macro Mode",
+		"Continuous Mode",
+		"Face Detection Mode",
+		"Rectangle Mode",
+		NULL
+	};
 	static const char * const colorfx[] = {
 		"None",
 		"Black & White",
@@ -252,6 +260,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return camera_power_line_frequency;
 	case V4L2_CID_EXPOSURE_AUTO:
 		return camera_exposure_auto;
+	case V4L2_CID_FOCUS_AUTO_MODE:
+		return camera_focus_auto_mode;
 	case V4L2_CID_COLORFX:
 		return colorfx;
 	case V4L2_CID_TUNE_PREEMPHASIS:
@@ -365,6 +375,11 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_PRIVACY:			return "Privacy";
 	case V4L2_CID_IRIS_ABSOLUTE:		return "Iris, Absolute";
 	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
+	case V4L2_CID_FOCUS_AUTO_MODE:		return "Focus, Mode";
+	case V4L2_CID_FOCUS_AUTO_RECTANGLE_LEFT: return "Focus, Rectangle Left";
+	case V4L2_CID_FOCUS_AUTO_RECTANGLE_TOP: return "Focus, Rectangle Top";
+	case V4L2_CID_FOCUS_AUTO_RECTANGLE_WIDTH: return "Focus, Rectangle Width";
+	case V4L2_CID_FOCUS_AUTO_RECTANGLE_HEIGHT: return "Focus, Rectangle Height";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -450,6 +465,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_STREAM_TYPE:
 	case V4L2_CID_MPEG_STREAM_VBI_FMT:
 	case V4L2_CID_EXPOSURE_AUTO:
+	case V4L2_CID_FOCUS_AUTO_MODE:
 	case V4L2_CID_COLORFX:
 	case V4L2_CID_TUNE_PREEMPHASIS:
 		*type = V4L2_CTRL_TYPE_MENU;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index aa6c393..99cd1b7 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1389,6 +1389,19 @@ enum  v4l2_exposure_auto_type {
 #define V4L2_CID_IRIS_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+17)
 #define V4L2_CID_IRIS_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+18)
 
+#define V4L2_CID_FOCUS_AUTO_MODE		(V4L2_CID_CAMERA_CLASS_BASE+19)
+enum  v4l2_focus_mode_type {
+	V4L2_FOCUS_AUTO_NORMAL = 0,
+	V4L2_FOCUS_AUTO_MACRO = 1,
+	V4L2_FOCUS_AUTO_CONTINUOUS = 2,
+	V4L2_FOCUS_AUTO_FACE_DETECTION = 3,
+	V4L2_FOCUS_AUTO_RECTANGLE = 4
+};
+#define V4L2_CID_FOCUS_AUTO_RECTANGLE_LEFT	(V4L2_CID_CAMERA_CLASS_BASE+20)
+#define V4L2_CID_FOCUS_AUTO_RECTANGLE_TOP	(V4L2_CID_CAMERA_CLASS_BASE+21)
+#define V4L2_CID_FOCUS_AUTO_RECTANGLE_WIDTH	(V4L2_CID_CAMERA_CLASS_BASE+22)
+#define V4L2_CID_FOCUS_AUTO_RECTANGLE_HEIGHT	(V4L2_CID_CAMERA_CLASS_BASE+23)
+
 /* FM Modulator class control IDs */
 #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
 #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
-- 
1.7.0.4

