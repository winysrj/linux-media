Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:29591 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbZG0NyP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2009 09:54:15 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "ext Hans Verkuil" <hverkuil@xs4all.nl>,
	"ext Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv13 3/8] v4l2: video device: Add FM TX controls default configurations
Date: Mon, 27 Jul 2009 16:42:54 +0300
Message-Id: <1248702179-10403-4-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1248702179-10403-3-git-send-email-eduardo.valentin@nokia.com>
References: <1248702179-10403-1-git-send-email-eduardo.valentin@nokia.com>
 <1248702179-10403-2-git-send-email-eduardo.valentin@nokia.com>
 <1248702179-10403-3-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds basic configurations for FM TX extended controls.
That includes controls names, menu strings, pointer identification,
type classification and flags configuration.

Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 linux/drivers/media/video/v4l2-common.c         |   50 +++++++++++++++++++++++
 linux/drivers/media/video/v4l2-compat-ioctl32.c |    8 +++-
 2 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/linux/drivers/media/video/v4l2-common.c b/linux/drivers/media/video/v4l2-common.c
index 870dc20..9e1ae23 100644
--- a/linux/drivers/media/video/v4l2-common.c
+++ b/linux/drivers/media/video/v4l2-common.c
@@ -343,6 +343,12 @@ const char **v4l2_ctrl_get_menu(u32 id)
 		"Sepia",
 		NULL
 	};
+	static const char *fm_tx_preemphasis[] = {
+		"No preemphasis",
+		"50 useconds",
+		"75 useconds",
+		NULL,
+	};
 
 	switch (id) {
 		case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
@@ -381,6 +387,8 @@ const char **v4l2_ctrl_get_menu(u32 id)
 			return camera_exposure_auto;
 		case V4L2_CID_COLORFX:
 			return colorfx;
+		case V4L2_CID_FM_TX_PREEMPHASIS:
+			return fm_tx_preemphasis;
 		default:
 			return NULL;
 	}
@@ -479,6 +487,28 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_ZOOM_CONTINUOUS:		return "Zoom, Continuous";
 	case V4L2_CID_PRIVACY:			return "Privacy";
 
+	/* FM Radio Modulator control */
+	case V4L2_CID_FM_TX_CLASS:		return "FM Radio Modulator Controls";
+	case V4L2_CID_RDS_TX_PI:		return "RDS Program ID";
+	case V4L2_CID_RDS_TX_PTY:		return "RDS Program Type";
+	case V4L2_CID_RDS_TX_DEVIATION:		return "RDS Signal Deviation";
+	case V4L2_CID_RDS_TX_PS_NAME:		return "RDS PS Name";
+	case V4L2_CID_RDS_TX_RADIO_TEXT:	return "RDS Radio Text";
+	case V4L2_CID_AUDIO_LIMITER_ENABLED:	return "Audio Limiter Feature Enabled";
+	case V4L2_CID_AUDIO_LIMITER_RELEASE_TIME: return "Audio Limiter Release Time";
+	case V4L2_CID_AUDIO_LIMITER_DEVIATION:	return "Audio Limiter Deviation";
+	case V4L2_CID_AUDIO_COMPRESSION_ENABLED: return "Audio Compression Feature Enabled";
+	case V4L2_CID_AUDIO_COMPRESSION_GAIN:	return "Audio Compression Gain";
+	case V4L2_CID_AUDIO_COMPRESSION_THRESHOLD: return "Audio Compression Threshold";
+	case V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME: return "Audio Compression Attack Time";
+	case V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME: return "Audio Compression Release Time";
+	case V4L2_CID_PILOT_TONE_ENABLED:	return "Pilot Tone Feature Enabled";
+	case V4L2_CID_PILOT_TONE_DEVIATION:	return "Pilot Tone Deviation";
+	case V4L2_CID_PILOT_TONE_FREQUENCY:	return "Pilot Tone Frequency";
+	case V4L2_CID_FM_TX_PREEMPHASIS:	return "Pre-emphasis settings";
+	case V4L2_CID_TUNE_POWER_LEVEL:		return "Tune Power Level";
+	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:	return "Tune Antenna Capacitor";
+
 	default:
 		return NULL;
 	}
@@ -511,6 +541,9 @@ int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 ste
 	case V4L2_CID_EXPOSURE_AUTO_PRIORITY:
 	case V4L2_CID_FOCUS_AUTO:
 	case V4L2_CID_PRIVACY:
+	case V4L2_CID_AUDIO_LIMITER_ENABLED:
+	case V4L2_CID_AUDIO_COMPRESSION_ENABLED:
+	case V4L2_CID_PILOT_TONE_ENABLED:
 		qctrl->type = V4L2_CTRL_TYPE_BOOLEAN;
 		min = 0;
 		max = step = 1;
@@ -539,12 +572,18 @@ int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 ste
 	case V4L2_CID_MPEG_STREAM_VBI_FMT:
 	case V4L2_CID_EXPOSURE_AUTO:
 	case V4L2_CID_COLORFX:
+	case V4L2_CID_FM_TX_PREEMPHASIS:
 		qctrl->type = V4L2_CTRL_TYPE_MENU;
 		step = 1;
 		break;
+	case V4L2_CID_RDS_TX_PS_NAME:
+	case V4L2_CID_RDS_TX_RADIO_TEXT:
+		qctrl->type = V4L2_CTRL_TYPE_STRING;
+		break;
 	case V4L2_CID_USER_CLASS:
 	case V4L2_CID_CAMERA_CLASS:
 	case V4L2_CID_MPEG_CLASS:
+	case V4L2_CID_FM_TX_CLASS:
 		qctrl->type = V4L2_CTRL_TYPE_CTRL_CLASS;
 		qctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 		min = max = step = def = 0;
@@ -573,6 +612,17 @@ int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 ste
 	case V4L2_CID_BLUE_BALANCE:
 	case V4L2_CID_GAMMA:
 	case V4L2_CID_SHARPNESS:
+	case V4L2_CID_RDS_TX_DEVIATION:
+	case V4L2_CID_AUDIO_LIMITER_RELEASE_TIME:
+	case V4L2_CID_AUDIO_LIMITER_DEVIATION:
+	case V4L2_CID_AUDIO_COMPRESSION_GAIN:
+	case V4L2_CID_AUDIO_COMPRESSION_THRESHOLD:
+	case V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME:
+	case V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME:
+	case V4L2_CID_PILOT_TONE_DEVIATION:
+	case V4L2_CID_PILOT_TONE_FREQUENCY:
+	case V4L2_CID_TUNE_POWER_LEVEL:
+	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:
 		qctrl->flags |= V4L2_CTRL_FLAG_SLIDER;
 		break;
 	case V4L2_CID_PAN_RELATIVE:
diff --git a/linux/drivers/media/video/v4l2-compat-ioctl32.c b/linux/drivers/media/video/v4l2-compat-ioctl32.c
index 991fca1..f24009a 100644
--- a/linux/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/linux/drivers/media/video/v4l2-compat-ioctl32.c
@@ -620,7 +620,13 @@ static int ctrl_is_value64(u32 id)
  * This information is used inside v4l2_compat_ioctl32. */
 static int ctrl_is_pointer(u32 id)
 {
-	return 0;
+	switch (id) {
+	case V4L2_CID_RDS_TX_PS_NAME:
+	case V4L2_CID_RDS_TX_RADIO_TEXT:
+		return 1;
+	default:
+		return 0;
+	}
 }
 
 static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext_controls32 __user *up)
-- 
1.6.2.GIT

