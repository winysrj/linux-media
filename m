Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:53322 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZFHIWk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2009 04:22:40 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "ext Hans Verkuil" <hverkuil@xs4all.nl>,
	"ext Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv6 2 of 7] v4l2: video device: Add FMTX controls default configurations
Date: Mon,  8 Jun 2009 11:18:02 +0300
Message-Id: <1244449087-5543-3-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1244449087-5543-2-git-send-email-eduardo.valentin@nokia.com>
References: <1244449087-5543-1-git-send-email-eduardo.valentin@nokia.com>
 <1244449087-5543-2-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Eduardo Valentin <eduardo.valentin@nokia.com>

# HG changeset patch
# User Eduardo Valentin <eduardo.valentin@nokia.com>
# Date 1243414606 -10800
# Node ID 6220548f4843ce4d19868dfcf5316d6b58a77824
# Parent  44d477eb96bd219a16b7430937a9b14ae1f9d607
Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 drivers/media/video/v4l2-common.c |   46 +++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff -r 44d477eb96bd -r 6220548f4843 linux/drivers/media/video/v4l2-common.c
--- a/linux/drivers/media/video/v4l2-common.c	Wed May 27 11:56:46 2009 +0300
+++ b/linux/drivers/media/video/v4l2-common.c	Wed May 27 11:56:46 2009 +0300
@@ -341,6 +341,12 @@
 		"Sepia",
 		NULL
 	};
+	static const char *fmtx_preemphasis[] = {
+		"No preemphasis",
+		"50 useconds",
+		"75 useconds",
+		NULL,
+	};
 
 	switch (id) {
 		case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
@@ -379,6 +385,8 @@
 			return camera_exposure_auto;
 		case V4L2_CID_COLORFX:
 			return colorfx;
+		case V4L2_CID_PREEMPHASIS:
+			return fmtx_preemphasis;
 		default:
 			return NULL;
 	}
@@ -477,6 +485,28 @@
 	case V4L2_CID_ZOOM_CONTINUOUS:		return "Zoom, Continuous";
 	case V4L2_CID_PRIVACY:			return "Privacy";
 
+	/* FM Radio Modulator control */
+	case V4L2_CID_FMTX_CLASS:		return "FM Radio Modulator Controls";
+	case V4L2_CID_RDS_ENABLED:		return "RDS Feature Enabled";
+	case V4L2_CID_RDS_PI:			return "RDS Program ID";
+	case V4L2_CID_RDS_PTY:			return "RDS Program Type";
+	case V4L2_CID_RDS_PS_NAME:		return "RDS PS Name";
+	case V4L2_CID_RDS_RADIO_TEXT:		return "RDS Radio Text";
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
+	case V4L2_CID_PREEMPHASIS:		return "Pre-emphasis settings";
+	case V4L2_CID_TUNE_POWER_LEVEL:		return "Tune Power Level";
+	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:	return "Tune Antenna Capacitor";
+
 	default:
 		return NULL;
 	}
@@ -509,6 +539,10 @@
 	case V4L2_CID_EXPOSURE_AUTO_PRIORITY:
 	case V4L2_CID_FOCUS_AUTO:
 	case V4L2_CID_PRIVACY:
+	case V4L2_CID_RDS_ENABLED:
+	case V4L2_CID_AUDIO_LIMITER_ENABLED:
+	case V4L2_CID_AUDIO_COMPRESSION_ENABLED:
+	case V4L2_CID_PILOT_TONE_ENABLED:
 		qctrl->type = V4L2_CTRL_TYPE_BOOLEAN;
 		min = 0;
 		max = step = 1;
@@ -537,12 +571,14 @@
 	case V4L2_CID_MPEG_STREAM_VBI_FMT:
 	case V4L2_CID_EXPOSURE_AUTO:
 	case V4L2_CID_COLORFX:
+	case V4L2_CID_PREEMPHASIS:
 		qctrl->type = V4L2_CTRL_TYPE_MENU;
 		step = 1;
 		break;
 	case V4L2_CID_USER_CLASS:
 	case V4L2_CID_CAMERA_CLASS:
 	case V4L2_CID_MPEG_CLASS:
+	case V4L2_CID_FMTX_CLASS:
 		qctrl->type = V4L2_CTRL_TYPE_CTRL_CLASS;
 		qctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 		min = max = step = def = 0;
@@ -571,6 +607,16 @@
 	case V4L2_CID_BLUE_BALANCE:
 	case V4L2_CID_GAMMA:
 	case V4L2_CID_SHARPNESS:
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
