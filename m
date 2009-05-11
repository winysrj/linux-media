Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:40564 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbZEKJhI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2009 05:37:08 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCH v2 2/7] v4l2: video device: Add FMTX controls default configurations
Date: Mon, 11 May 2009 12:31:44 +0300
Message-Id: <1242034309-13448-3-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1242034309-13448-2-git-send-email-eduardo.valentin@nokia.com>
References: <1242034309-13448-1-git-send-email-eduardo.valentin@nokia.com>
 <1242034309-13448-2-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 drivers/media/video/v4l2-common.c |   66 +++++++++++++++++++++++++++++++++++++
 1 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index f576ef6..c17d93c 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -340,6 +340,20 @@ const char **v4l2_ctrl_get_menu(u32 id)
 		"Sepia",
 		NULL
 	};
+	static const char *fmtx_region[] = {
+		"USA region settings",
+		"Australia region settings",
+		"Europe region settings",
+		"Japan region settings",
+		"Japan Wide Band region settings",
+		NULL,
+	};
+	static const char *fmtx_preemphasis[] = {
+		"75 useconds",
+		"50 useconds",
+		"No preemphasis",
+		NULL,
+	};
 
 	switch (id) {
 		case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
@@ -378,6 +392,10 @@ const char **v4l2_ctrl_get_menu(u32 id)
 			return camera_exposure_auto;
 		case V4L2_CID_COLORFX:
 			return colorfx;
+		case V4L2_CID_REGION:
+			return fmtx_region;
+		case V4L2_CID_REGION_PREEMPHASIS:
+			return fmtx_preemphasis;
 		default:
 			return NULL;
 	}
@@ -476,6 +494,32 @@ const char *v4l2_ctrl_get_name(u32 id)
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
+	case V4L2_CID_REGION:			return "Region Settings";
+	case V4L2_CID_REGION_BOTTOM_FREQUENCY:	return "Region Bottom Frequency";
+	case V4L2_CID_REGION_TOP_FREQUENCY:	return "Region Top Frequency";
+	case V4L2_CID_REGION_PREEMPHASIS:	return "Region Preemphasis";
+	case V4L2_CID_REGION_CHANNEL_SPACING:	return "Region Channel Spacing";
+	case V4L2_CID_TUNE_POWER_LEVEL:		return "Tune Power Level";
+	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:	return "Tune Antenna Capacitor";
+
 	default:
 		return NULL;
 	}
@@ -508,6 +552,10 @@ int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 ste
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
@@ -536,12 +584,15 @@ int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 ste
 	case V4L2_CID_MPEG_STREAM_VBI_FMT:
 	case V4L2_CID_EXPOSURE_AUTO:
 	case V4L2_CID_COLORFX:
+	case V4L2_CID_REGION:
+	case V4L2_CID_REGION_PREEMPHASIS:
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
@@ -570,8 +621,23 @@ int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 ste
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
+	case V4L2_CID_REGION_BOTTOM_FREQUENCY:
+	case V4L2_CID_REGION_TOP_FREQUENCY:
+	case V4L2_CID_REGION_CHANNEL_SPACING:
+		qctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+		break;
 	case V4L2_CID_PAN_RELATIVE:
 	case V4L2_CID_TILT_RELATIVE:
 	case V4L2_CID_FOCUS_RELATIVE:
-- 
1.6.2.GIT

