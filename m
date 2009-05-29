Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:18630 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbZE2HiF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2009 03:38:05 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "\\\"ext Hans Verkuil\\\"" <hverkuil@xs4all.nl>,
	"\\\"ext Mauro Carvalho Chehab\\\"" <mchehab@infradead.org>
Cc: "\\\"Nurkkala Eero.An (EXT-Offcode/Oulu)\\\""
	<ext-Eero.Nurkkala@nokia.com>,
	"\\\"ext Douglas Schilling Landgraf\\\"" <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv5 3 of 8] v4l2: video device: Add FMTX controls default configurations
Date: Fri, 29 May 2009 10:33:23 +0300
Message-Id: <1243582408-13084-4-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1243582408-13084-3-git-send-email-eduardo.valentin@nokia.com>
References: <1243582408-13084-1-git-send-email-eduardo.valentin@nokia.com>
 <1243582408-13084-2-git-send-email-eduardo.valentin@nokia.com>
 <1243582408-13084-3-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Eduardo Valentin <eduardo.valentin@nokia.com>
# Date 1243414606 -10800
# Branch export
# Node ID 85b64a6cc67c0c0d6a795388f8ca02dad2ff9da7
# Parent  ebb409d7a258df2bc7a6dcd72113584b4c0e7ce2
Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 drivers/media/video/v4l2-common.c |   46 +++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff -r ebb409d7a258 -r 85b64a6cc67c linux/drivers/media/video/v4l2-common.c
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
