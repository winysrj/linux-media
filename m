Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:19208 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab1EPNAs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2011 09:00:48 -0400
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, nkanchev@mm-sol.com,
	g.liakhovetski@gmx.de, hverkuil@xs4all.nl, dacohen@gmail.com,
	riverful@gmail.com, andrew.b.adams@gmail.com, shpark7@stanford.edu
Subject: [PATCH 1/3] v4l: Add a class and a set of controls for flash devices.
Date: Mon, 16 May 2011 16:00:37 +0300
Message-Id: <1305550839-16724-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4DD11FEC.8050308@maxwell.research.nokia.com>
References: <4DD11FEC.8050308@maxwell.research.nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Sakari Ailus <sakari.ailus@iki.fi>

Add a control class and a set of controls to support LED and Xenon flash
devices. An example of such a device is the adp1653.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/v4l2-ctrls.c |   45 ++++++++++++++++++++++++++++++++++++++
 include/linux/videodev2.h        |   36 ++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 2412f08..74aae36 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -216,6 +216,17 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"75 useconds",
 		NULL,
 	};
+	static const char * const flash_led_mode[] = {
+		"Off",
+		"Flash",
+		"Torch",
+		NULL,
+	};
+	static const char * const flash_strobe_source[] = {
+		"Software",
+		"External",
+		NULL,
+	};
 
 	switch (id) {
 	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
@@ -256,6 +267,10 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return colorfx;
 	case V4L2_CID_TUNE_PREEMPHASIS:
 		return tune_preemphasis;
+	case V4L2_CID_FLASH_LED_MODE:
+		return flash_led_mode;
+	case V4L2_CID_FLASH_STROBE_SOURCE:
+		return flash_strobe_source;
 	default:
 		return NULL;
 	}
@@ -389,6 +404,21 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_TUNE_POWER_LEVEL:		return "Tune Power Level";
 	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:	return "Tune Antenna Capacitor";
 
+	/* Flash controls */
+	case V4L2_CID_FLASH_CLASS:		return "Flash controls";
+	case V4L2_CID_FLASH_LED_MODE:		return "LED mode";
+	case V4L2_CID_FLASH_STROBE_SOURCE:	return "Strobe source";
+	case V4L2_CID_FLASH_STROBE:		return "Strobe";
+	case V4L2_CID_FLASH_STROBE_STOP:	return "Stop strobe";
+	case V4L2_CID_FLASH_STROBE_STATUS:	return "Strobe status";
+	case V4L2_CID_FLASH_TIMEOUT:		return "Strobe timeout";
+	case V4L2_CID_FLASH_INTENSITY:		return "Intensity, flash mode";
+	case V4L2_CID_FLASH_TORCH_INTENSITY:	return "Intensity, torch mode";
+	case V4L2_CID_FLASH_INDICATOR_INTENSITY: return "Intensity, indicator";
+	case V4L2_CID_FLASH_FAULT:		return "Faults";
+	case V4L2_CID_FLASH_CHARGE:		return "Charge";
+	case V4L2_CID_FLASH_READY:		return "Ready to strobe";
+
 	default:
 		return NULL;
 	}
@@ -423,12 +453,17 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_PILOT_TONE_ENABLED:
 	case V4L2_CID_ILLUMINATORS_1:
 	case V4L2_CID_ILLUMINATORS_2:
+	case V4L2_CID_FLASH_STROBE_STATUS:
+	case V4L2_CID_FLASH_CHARGE:
+	case V4L2_CID_FLASH_READY:
 		*type = V4L2_CTRL_TYPE_BOOLEAN;
 		*min = 0;
 		*max = *step = 1;
 		break;
 	case V4L2_CID_PAN_RESET:
 	case V4L2_CID_TILT_RESET:
+	case V4L2_CID_FLASH_STROBE:
+	case V4L2_CID_FLASH_STROBE_STOP:
 		*type = V4L2_CTRL_TYPE_BUTTON;
 		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
 		*min = *max = *step = *def = 0;
@@ -452,6 +487,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_EXPOSURE_AUTO:
 	case V4L2_CID_COLORFX:
 	case V4L2_CID_TUNE_PREEMPHASIS:
+	case V4L2_CID_FLASH_LED_MODE:
+	case V4L2_CID_FLASH_STROBE_SOURCE:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_RDS_TX_PS_NAME:
@@ -462,6 +499,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_CAMERA_CLASS:
 	case V4L2_CID_MPEG_CLASS:
 	case V4L2_CID_FM_TX_CLASS:
+	case V4L2_CID_FLASH_CLASS:
 		*type = V4L2_CTRL_TYPE_CTRL_CLASS;
 		/* You can neither read not write these */
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_WRITE_ONLY;
@@ -474,6 +512,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		/* Max is calculated as RGB888 that is 2^24 */
 		*max = 0xFFFFFF;
 		break;
+	case V4L2_CID_FLASH_FAULT:
+		*type = V4L2_CTRL_TYPE_BITMASK;
+		break;
 	default:
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		break;
@@ -519,6 +560,10 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_ZOOM_RELATIVE:
 		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
 		break;
+	case V4L2_CID_FLASH_STROBE_STATUS:
+	case V4L2_CID_FLASH_READY:
+		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
+		break;
 	}
 }
 EXPORT_SYMBOL(v4l2_ctrl_fill);
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index be82c8e..e364350 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1022,6 +1022,7 @@ struct v4l2_ext_controls {
 #define V4L2_CTRL_CLASS_MPEG 0x00990000	/* MPEG-compression controls */
 #define V4L2_CTRL_CLASS_CAMERA 0x009a0000	/* Camera class controls */
 #define V4L2_CTRL_CLASS_FM_TX 0x009b0000	/* FM Modulator control class */
+#define V4L2_CTRL_CLASS_FLASH 0x009c0000	/* Camera flash controls */
 
 #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
 #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
@@ -1423,6 +1424,41 @@ enum v4l2_preemphasis {
 #define V4L2_CID_TUNE_POWER_LEVEL		(V4L2_CID_FM_TX_CLASS_BASE + 113)
 #define V4L2_CID_TUNE_ANTENNA_CAPACITOR		(V4L2_CID_FM_TX_CLASS_BASE + 114)
 
+/* Flash and privacy (indicator) light controls */
+#define V4L2_CID_FLASH_CLASS_BASE		(V4L2_CTRL_CLASS_FLASH | 0x900)
+#define V4L2_CID_FLASH_CLASS			(V4L2_CTRL_CLASS_FLASH | 1)
+
+#define V4L2_CID_FLASH_LED_MODE			(V4L2_CID_FLASH_CLASS_BASE + 1)
+enum v4l2_flash_led_mode {
+	V4L2_FLASH_LED_MODE_NONE,
+	V4L2_FLASH_LED_MODE_FLASH,
+	V4L2_FLASH_LED_MODE_TORCH,
+};
+
+#define V4L2_CID_FLASH_STROBE_SOURCE		(V4L2_CID_FLASH_CLASS_BASE + 2)
+enum v4l2_flash_strobe_source {
+	V4L2_FLASH_STROBE_SOURCE_SOFTWARE,
+	V4L2_FLASH_STROBE_SOURCE_EXTERNAL,
+};
+
+#define V4L2_CID_FLASH_STROBE			(V4L2_CID_FLASH_CLASS_BASE + 3)
+#define V4L2_CID_FLASH_STROBE_STOP		(V4L2_CID_FLASH_CLASS_BASE + 4)
+#define V4L2_CID_FLASH_STROBE_STATUS		(V4L2_CID_FLASH_CLASS_BASE + 5)
+
+#define V4L2_CID_FLASH_TIMEOUT			(V4L2_CID_FLASH_CLASS_BASE + 6)
+#define V4L2_CID_FLASH_INTENSITY		(V4L2_CID_FLASH_CLASS_BASE + 7)
+#define V4L2_CID_FLASH_TORCH_INTENSITY		(V4L2_CID_FLASH_CLASS_BASE + 8)
+#define V4L2_CID_FLASH_INDICATOR_INTENSITY	(V4L2_CID_FLASH_CLASS_BASE + 9)
+
+#define V4L2_CID_FLASH_FAULT			(V4L2_CID_FLASH_CLASS_BASE + 10)
+#define V4L2_FLASH_FAULT_OVER_VOLTAGE		(1 << 0)
+#define V4L2_FLASH_FAULT_TIMEOUT		(1 << 1)
+#define V4L2_FLASH_FAULT_OVER_TEMPERATURE	(1 << 2)
+#define V4L2_FLASH_FAULT_SHORT_CIRCUIT		(1 << 3)
+
+#define V4L2_CID_FLASH_CHARGE			(V4L2_CID_FLASH_CLASS_BASE + 11)
+#define V4L2_CID_FLASH_READY			(V4L2_CID_FLASH_CLASS_BASE + 12)
+
 /*
  *	T U N I N G
  */
-- 
1.7.2.5

