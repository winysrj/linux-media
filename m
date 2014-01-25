Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33346 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbaAYRp3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 12:45:29 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 52/52] v4l: add RF tuner gain controls
Date: Sat, 25 Jan 2014 19:10:46 +0200
Message-Id: <1390669846-8131-53-git-send-email-crope@iki.fi>
In-Reply-To: <1390669846-8131-1-git-send-email-crope@iki.fi>
References: <1390669846-8131-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modern silicon RF tuners used nowadays has many controllable gain
stages on signal path. Usually, but not always, there is at least
3 gain stages. Also on some cases there could be multiple gain
stages within the ones specified here. However, I think that having
these three controllable gain stages offers enough fine-tuning for
real use cases.

1) LNA gain. That is first gain just after antenna input.
2) Mixer gain. It is located quite middle of the signal path, where
RF signal is down-converted to IF/BB.
3) IF gain. That is last gain in order to adjust output signal level
to optimal level for receiving party (usually demodulator ADC).

Each gain stage could be set rather often both manual or automatic
(AGC) mode. Due to that add separate controls for controlling
operation mode.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 15 +++++++++++++++
 include/uapi/linux/v4l2-controls.h   | 11 +++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 6ff002b..d201f61 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -857,6 +857,14 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_FM_RX_CLASS:		return "FM Radio Receiver Controls";
 	case V4L2_CID_TUNE_DEEMPHASIS:		return "De-Emphasis";
 	case V4L2_CID_RDS_RECEPTION:		return "RDS Reception";
+
+	case V4L2_CID_RF_TUNER_CLASS:		return "RF Tuner Controls";
+	case V4L2_CID_LNA_GAIN_AUTO:		return "LNA Gain, Auto";
+	case V4L2_CID_LNA_GAIN:			return "LNA Gain";
+	case V4L2_CID_MIXER_GAIN_AUTO:		return "Mixer Gain, Auto";
+	case V4L2_CID_MIXER_GAIN:		return "Mixer Gain";
+	case V4L2_CID_IF_GAIN_AUTO:		return "IF Gain, Auto";
+	case V4L2_CID_IF_GAIN:			return "IF Gain";
 	default:
 		return NULL;
 	}
@@ -906,6 +914,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_WIDE_DYNAMIC_RANGE:
 	case V4L2_CID_IMAGE_STABILIZATION:
 	case V4L2_CID_RDS_RECEPTION:
+	case V4L2_CID_LNA_GAIN_AUTO:
+	case V4L2_CID_MIXER_GAIN_AUTO:
+	case V4L2_CID_IF_GAIN_AUTO:
 		*type = V4L2_CTRL_TYPE_BOOLEAN;
 		*min = 0;
 		*max = *step = 1;
@@ -991,6 +1002,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_IMAGE_PROC_CLASS:
 	case V4L2_CID_DV_CLASS:
 	case V4L2_CID_FM_RX_CLASS:
+	case V4L2_CID_RF_TUNER_CLASS:
 		*type = V4L2_CTRL_TYPE_CTRL_CLASS;
 		/* You can neither read not write these */
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_WRITE_ONLY;
@@ -1063,6 +1075,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_PILOT_TONE_FREQUENCY:
 	case V4L2_CID_TUNE_POWER_LEVEL:
 	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:
+	case V4L2_CID_LNA_GAIN:
+	case V4L2_CID_MIXER_GAIN:
+	case V4L2_CID_IF_GAIN:
 		*flags |= V4L2_CTRL_FLAG_SLIDER;
 		break;
 	case V4L2_CID_PAN_RELATIVE:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 2cbe605..076fa34 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -60,6 +60,7 @@
 #define V4L2_CTRL_CLASS_IMAGE_PROC	0x009f0000	/* Image processing controls */
 #define V4L2_CTRL_CLASS_DV		0x00a00000	/* Digital Video controls */
 #define V4L2_CTRL_CLASS_FM_RX		0x00a10000	/* FM Receiver controls */
+#define V4L2_CTRL_CLASS_RF_TUNER	0x00a20000	/* RF tuner controls */
 
 /* User-class control IDs */
 
@@ -895,4 +896,14 @@ enum v4l2_deemphasis {
 
 #define V4L2_CID_RDS_RECEPTION			(V4L2_CID_FM_RX_CLASS_BASE + 2)
 
+#define V4L2_CID_RF_TUNER_CLASS_BASE		(V4L2_CTRL_CLASS_RF_TUNER | 0x900)
+#define V4L2_CID_RF_TUNER_CLASS			(V4L2_CTRL_CLASS_RF_TUNER | 1)
+
+#define V4L2_CID_LNA_GAIN_AUTO			(V4L2_CID_RF_TUNER_CLASS_BASE + 1)
+#define V4L2_CID_LNA_GAIN			(V4L2_CID_RF_TUNER_CLASS_BASE + 2)
+#define V4L2_CID_MIXER_GAIN_AUTO		(V4L2_CID_RF_TUNER_CLASS_BASE + 3)
+#define V4L2_CID_MIXER_GAIN			(V4L2_CID_RF_TUNER_CLASS_BASE + 4)
+#define V4L2_CID_IF_GAIN_AUTO			(V4L2_CID_RF_TUNER_CLASS_BASE + 5)
+#define V4L2_CID_IF_GAIN			(V4L2_CID_RF_TUNER_CLASS_BASE + 6)
+
 #endif
-- 
1.8.5.3

