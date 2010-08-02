Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:34078 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab0HBOHf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 10:07:35 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	eduardo.valentin@nokia.com, mchehab@redhat.com
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v7 1/5] V4L2: Add seek spacing and FM RX class.
Date: Mon,  2 Aug 2010 17:06:39 +0300
Message-Id: <1280758003-16118-2-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1280758003-16118-1-git-send-email-matti.j.aaltonen@nokia.com>
References: <1280758003-16118-1-git-send-email-matti.j.aaltonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add spacing field to v4l2_hw_freq_seek and also add FM RX class to
control classes.

Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
---
 drivers/media/video/v4l2-common.c |   12 ++++++++++++
 include/linux/videodev2.h         |   15 ++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index cd1f21d..41b1bb2 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -351,6 +351,12 @@ const char **v4l2_ctrl_get_menu(u32 id)
 		"75 useconds",
 		NULL,
 	};
+	static const char *fm_band[] = {
+		"87.5 - 108. MHz",
+		"76. - 90. MHz, Japan",
+		"65. - 74. MHz, OIRT",
+		NULL,
+	};
 
 	switch (id) {
 		case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
@@ -391,6 +397,8 @@ const char **v4l2_ctrl_get_menu(u32 id)
 			return colorfx;
 		case V4L2_CID_TUNE_PREEMPHASIS:
 			return tune_preemphasis;
+		case V4L2_CID_FM_BAND:
+			return fm_band;
 		default:
 			return NULL;
 	}
@@ -515,6 +523,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_TUNE_PREEMPHASIS:	return "Pre-emphasis settings";
 	case V4L2_CID_TUNE_POWER_LEVEL:		return "Tune Power Level";
 	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:	return "Tune Antenna Capacitor";
+	case V4L2_CID_FM_RX_CLASS:		return "FM Radio Tuner Controls";
+	case V4L2_CID_FM_BAND:			return "FM Band";
 
 	default:
 		return NULL;
@@ -580,6 +590,7 @@ int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 ste
 	case V4L2_CID_EXPOSURE_AUTO:
 	case V4L2_CID_COLORFX:
 	case V4L2_CID_TUNE_PREEMPHASIS:
+	case V4L2_CID_FM_BAND:
 		qctrl->type = V4L2_CTRL_TYPE_MENU;
 		step = 1;
 		break;
@@ -591,6 +602,7 @@ int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 ste
 	case V4L2_CID_CAMERA_CLASS:
 	case V4L2_CID_MPEG_CLASS:
 	case V4L2_CID_FM_TX_CLASS:
+	case V4L2_CID_FM_RX_CLASS:
 		qctrl->type = V4L2_CTRL_TYPE_CTRL_CLASS;
 		qctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 		min = max = step = def = 0;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 418dacf..26522cb 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -935,6 +935,7 @@ struct v4l2_ext_controls {
 #define V4L2_CTRL_CLASS_MPEG 0x00990000	/* MPEG-compression controls */
 #define V4L2_CTRL_CLASS_CAMERA 0x009a0000	/* Camera class controls */
 #define V4L2_CTRL_CLASS_FM_TX 0x009b0000	/* FM Modulator control class */
+#define V4L2_CTRL_CLASS_FM_RX 0x009c0000	/* FM Tuner control class */
 
 #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
 #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
@@ -1313,6 +1314,17 @@ enum v4l2_preemphasis {
 #define V4L2_CID_TUNE_POWER_LEVEL		(V4L2_CID_FM_TX_CLASS_BASE + 113)
 #define V4L2_CID_TUNE_ANTENNA_CAPACITOR		(V4L2_CID_FM_TX_CLASS_BASE + 114)
 
+/* FM Tuner class control IDs */
+#define V4L2_CID_FM_RX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_RX | 0x900)
+#define V4L2_CID_FM_RX_CLASS			(V4L2_CTRL_CLASS_FM_RX | 1)
+
+#define V4L2_CID_FM_BAND			(V4L2_CID_FM_RX_CLASS_BASE + 1)
+enum v4l2_fm_band {
+	V4L2_FM_BAND_OTHER		= 0,
+	V4L2_FM_BAND_JAPAN		= 1,
+	V4L2_FM_BAND_OIRT		= 2
+};
+
 /*
  *	T U N I N G
  */
@@ -1377,7 +1389,8 @@ struct v4l2_hw_freq_seek {
 	enum v4l2_tuner_type  type;
 	__u32		      seek_upward;
 	__u32		      wrap_around;
-	__u32		      reserved[8];
+	__u32		      spacing;
+	__u32		      reserved[7];
 };
 
 /*
-- 
1.6.1.3

