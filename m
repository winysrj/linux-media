Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4148 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab0EPNTQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 May 2010 09:19:16 -0400
Message-Id: <62e87c2ddc93072f2919719fc2a953f3b56cab55.1274015085.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1274015084.git.hverkuil@xs4all.nl>
References: <cover.1274015084.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 16 May 2010 15:20:51 +0200
Subject: [PATCH 01/15] [RFCv2] v4l2: Add new control handling framework
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new framework to handle controls which makes life for driver
developers much easier.

Note that this patch moves some of the control support that used to be in
v4l2-common.c to v4l2-ctrls.c. The tables were copied unchanged. The body
of v4l2_ctrl_query_fill() was copied to a new v4l2_ctrl_fill() function
in v4l2-ctrls.c. This new function doesn't use the v4l2_queryctrl
struct anymore, which makes it more general.

The remainder of v4l2-ctrls.c is all new. Highlights include:

- No need to implement VIDIOC_QUERYCTRL, QUERYMENU, S_CTRL, G_CTRL,
  S_EXT_CTRLS, G_EXT_CTRLS or TRY_EXT_CTRLS in either bridge drivers
  or subdevs. New wrapper functions are provided that can just be plugged in.
  Once everything has been converted these wrapper functions can be removed as well.

- When subdevices are added their controls can be automatically merged
  with the bridge driver's controls.

- Most drivers just need to implement s_ctrl to set the controls.
  The framework handles the locking and tries to be as 'atomic' as possible.

- Ready for the subdev device nodes: the same mechanism applies to subdevs
  and their device nodes as well. Sub-device drivers can make controls
  local, preventing them from being merged with bridge drivers.

- Takes care of backwards compatibility handling of VIDIOC_S_CTRL and
  VIDIOC_G_CTRL. Handling of V4L2_CID_PRIVATE_BASE is fully transparent.
  CTRL_CLASS controls are automatically added.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/Makefile      |    2 +-
 drivers/media/video/v4l2-common.c |  479 +----------
 drivers/media/video/v4l2-ctrls.c  | 1840 +++++++++++++++++++++++++++++++++++++
 include/media/v4l2-ctrls.h        |  448 +++++++++
 include/media/v4l2-dev.h          |    4 +
 include/media/v4l2-device.h       |    4 +
 include/media/v4l2-subdev.h       |    3 +
 7 files changed, 2305 insertions(+), 475 deletions(-)
 create mode 100644 drivers/media/video/v4l2-ctrls.c
 create mode 100644 include/media/v4l2-ctrls.h

diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index cc93859..2ea34a6 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -11,7 +11,7 @@ stkwebcam-objs	:=	stk-webcam.o stk-sensor.o
 omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
 
 videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
-			v4l2-event.o
+			v4l2-event.o v4l2-ctrls.o
 
 # V4L2 core modules
 
diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 4e53b0b..3ce7c64 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -62,6 +62,7 @@
 #define __OLD_VIDIOC_ /* To allow fixing old calls*/
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-chip-ident.h>
 
 #include <linux/videodev2.h>
@@ -172,487 +173,17 @@ int v4l2_ctrl_check(struct v4l2_ext_control *ctrl, struct v4l2_queryctrl *qctrl,
 }
 EXPORT_SYMBOL(v4l2_ctrl_check);
 
-/* Returns NULL or a character pointer array containing the menu for
-   the given control ID. The pointer array ends with a NULL pointer.
-   An empty string signifies a menu entry that is invalid. This allows
-   drivers to disable certain options if it is not supported. */
-const char **v4l2_ctrl_get_menu(u32 id)
-{
-	static const char *mpeg_audio_sampling_freq[] = {
-		"44.1 kHz",
-		"48 kHz",
-		"32 kHz",
-		NULL
-	};
-	static const char *mpeg_audio_encoding[] = {
-		"MPEG-1/2 Layer I",
-		"MPEG-1/2 Layer II",
-		"MPEG-1/2 Layer III",
-		"MPEG-2/4 AAC",
-		"AC-3",
-		NULL
-	};
-	static const char *mpeg_audio_l1_bitrate[] = {
-		"32 kbps",
-		"64 kbps",
-		"96 kbps",
-		"128 kbps",
-		"160 kbps",
-		"192 kbps",
-		"224 kbps",
-		"256 kbps",
-		"288 kbps",
-		"320 kbps",
-		"352 kbps",
-		"384 kbps",
-		"416 kbps",
-		"448 kbps",
-		NULL
-	};
-	static const char *mpeg_audio_l2_bitrate[] = {
-		"32 kbps",
-		"48 kbps",
-		"56 kbps",
-		"64 kbps",
-		"80 kbps",
-		"96 kbps",
-		"112 kbps",
-		"128 kbps",
-		"160 kbps",
-		"192 kbps",
-		"224 kbps",
-		"256 kbps",
-		"320 kbps",
-		"384 kbps",
-		NULL
-	};
-	static const char *mpeg_audio_l3_bitrate[] = {
-		"32 kbps",
-		"40 kbps",
-		"48 kbps",
-		"56 kbps",
-		"64 kbps",
-		"80 kbps",
-		"96 kbps",
-		"112 kbps",
-		"128 kbps",
-		"160 kbps",
-		"192 kbps",
-		"224 kbps",
-		"256 kbps",
-		"320 kbps",
-		NULL
-	};
-	static const char *mpeg_audio_ac3_bitrate[] = {
-		"32 kbps",
-		"40 kbps",
-		"48 kbps",
-		"56 kbps",
-		"64 kbps",
-		"80 kbps",
-		"96 kbps",
-		"112 kbps",
-		"128 kbps",
-		"160 kbps",
-		"192 kbps",
-		"224 kbps",
-		"256 kbps",
-		"320 kbps",
-		"384 kbps",
-		"448 kbps",
-		"512 kbps",
-		"576 kbps",
-		"640 kbps",
-		NULL
-	};
-	static const char *mpeg_audio_mode[] = {
-		"Stereo",
-		"Joint Stereo",
-		"Dual",
-		"Mono",
-		NULL
-	};
-	static const char *mpeg_audio_mode_extension[] = {
-		"Bound 4",
-		"Bound 8",
-		"Bound 12",
-		"Bound 16",
-		NULL
-	};
-	static const char *mpeg_audio_emphasis[] = {
-		"No Emphasis",
-		"50/15 us",
-		"CCITT J17",
-		NULL
-	};
-	static const char *mpeg_audio_crc[] = {
-		"No CRC",
-		"16-bit CRC",
-		NULL
-	};
-	static const char *mpeg_video_encoding[] = {
-		"MPEG-1",
-		"MPEG-2",
-		"MPEG-4 AVC",
-		NULL
-	};
-	static const char *mpeg_video_aspect[] = {
-		"1x1",
-		"4x3",
-		"16x9",
-		"2.21x1",
-		NULL
-	};
-	static const char *mpeg_video_bitrate_mode[] = {
-		"Variable Bitrate",
-		"Constant Bitrate",
-		NULL
-	};
-	static const char *mpeg_stream_type[] = {
-		"MPEG-2 Program Stream",
-		"MPEG-2 Transport Stream",
-		"MPEG-1 System Stream",
-		"MPEG-2 DVD-compatible Stream",
-		"MPEG-1 VCD-compatible Stream",
-		"MPEG-2 SVCD-compatible Stream",
-		NULL
-	};
-	static const char *mpeg_stream_vbi_fmt[] = {
-		"No VBI",
-		"Private packet, IVTV format",
-		NULL
-	};
-	static const char *camera_power_line_frequency[] = {
-		"Disabled",
-		"50 Hz",
-		"60 Hz",
-		NULL
-	};
-	static const char *camera_exposure_auto[] = {
-		"Auto Mode",
-		"Manual Mode",
-		"Shutter Priority Mode",
-		"Aperture Priority Mode",
-		NULL
-	};
-	static const char *colorfx[] = {
-		"None",
-		"Black & White",
-		"Sepia",
-		"Negative",
-		"Emboss",
-		"Sketch",
-		"Sky blue",
-		"Grass green",
-		"Skin whiten",
-		"Vivid",
-		NULL
-	};
-	static const char *tune_preemphasis[] = {
-		"No preemphasis",
-		"50 useconds",
-		"75 useconds",
-		NULL,
-	};
-
-	switch (id) {
-		case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
-			return mpeg_audio_sampling_freq;
-		case V4L2_CID_MPEG_AUDIO_ENCODING:
-			return mpeg_audio_encoding;
-		case V4L2_CID_MPEG_AUDIO_L1_BITRATE:
-			return mpeg_audio_l1_bitrate;
-		case V4L2_CID_MPEG_AUDIO_L2_BITRATE:
-			return mpeg_audio_l2_bitrate;
-		case V4L2_CID_MPEG_AUDIO_L3_BITRATE:
-			return mpeg_audio_l3_bitrate;
-		case V4L2_CID_MPEG_AUDIO_AC3_BITRATE:
-			return mpeg_audio_ac3_bitrate;
-		case V4L2_CID_MPEG_AUDIO_MODE:
-			return mpeg_audio_mode;
-		case V4L2_CID_MPEG_AUDIO_MODE_EXTENSION:
-			return mpeg_audio_mode_extension;
-		case V4L2_CID_MPEG_AUDIO_EMPHASIS:
-			return mpeg_audio_emphasis;
-		case V4L2_CID_MPEG_AUDIO_CRC:
-			return mpeg_audio_crc;
-		case V4L2_CID_MPEG_VIDEO_ENCODING:
-			return mpeg_video_encoding;
-		case V4L2_CID_MPEG_VIDEO_ASPECT:
-			return mpeg_video_aspect;
-		case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
-			return mpeg_video_bitrate_mode;
-		case V4L2_CID_MPEG_STREAM_TYPE:
-			return mpeg_stream_type;
-		case V4L2_CID_MPEG_STREAM_VBI_FMT:
-			return mpeg_stream_vbi_fmt;
-		case V4L2_CID_POWER_LINE_FREQUENCY:
-			return camera_power_line_frequency;
-		case V4L2_CID_EXPOSURE_AUTO:
-			return camera_exposure_auto;
-		case V4L2_CID_COLORFX:
-			return colorfx;
-		case V4L2_CID_TUNE_PREEMPHASIS:
-			return tune_preemphasis;
-		default:
-			return NULL;
-	}
-}
-EXPORT_SYMBOL(v4l2_ctrl_get_menu);
-
-/* Return the control name. */
-const char *v4l2_ctrl_get_name(u32 id)
-{
-	switch (id) {
-	/* USER controls */
-	case V4L2_CID_USER_CLASS: 		return "User Controls";
-	case V4L2_CID_BRIGHTNESS: 		return "Brightness";
-	case V4L2_CID_CONTRAST: 		return "Contrast";
-	case V4L2_CID_SATURATION: 		return "Saturation";
-	case V4L2_CID_HUE: 			return "Hue";
-	case V4L2_CID_AUDIO_VOLUME: 		return "Volume";
-	case V4L2_CID_AUDIO_BALANCE: 		return "Balance";
-	case V4L2_CID_AUDIO_BASS: 		return "Bass";
-	case V4L2_CID_AUDIO_TREBLE: 		return "Treble";
-	case V4L2_CID_AUDIO_MUTE: 		return "Mute";
-	case V4L2_CID_AUDIO_LOUDNESS: 		return "Loudness";
-	case V4L2_CID_BLACK_LEVEL:		return "Black Level";
-	case V4L2_CID_AUTO_WHITE_BALANCE:	return "White Balance, Automatic";
-	case V4L2_CID_DO_WHITE_BALANCE:		return "Do White Balance";
-	case V4L2_CID_RED_BALANCE:		return "Red Balance";
-	case V4L2_CID_BLUE_BALANCE:		return "Blue Balance";
-	case V4L2_CID_GAMMA:			return "Gamma";
-	case V4L2_CID_EXPOSURE:			return "Exposure";
-	case V4L2_CID_AUTOGAIN:			return "Gain, Automatic";
-	case V4L2_CID_GAIN:			return "Gain";
-	case V4L2_CID_HFLIP:			return "Horizontal Flip";
-	case V4L2_CID_VFLIP:			return "Vertical Flip";
-	case V4L2_CID_HCENTER:			return "Horizontal Center";
-	case V4L2_CID_VCENTER:			return "Vertical Center";
-	case V4L2_CID_POWER_LINE_FREQUENCY:	return "Power Line Frequency";
-	case V4L2_CID_HUE_AUTO:			return "Hue, Automatic";
-	case V4L2_CID_WHITE_BALANCE_TEMPERATURE: return "White Balance Temperature";
-	case V4L2_CID_SHARPNESS:		return "Sharpness";
-	case V4L2_CID_BACKLIGHT_COMPENSATION:	return "Backlight Compensation";
-	case V4L2_CID_CHROMA_AGC:		return "Chroma AGC";
-	case V4L2_CID_CHROMA_GAIN:		return "Chroma Gain";
-	case V4L2_CID_COLOR_KILLER:		return "Color Killer";
-	case V4L2_CID_COLORFX:			return "Color Effects";
-	case V4L2_CID_AUTOBRIGHTNESS:		return "Brightness, Automatic";
-	case V4L2_CID_BAND_STOP_FILTER:		return "Band-Stop Filter";
-	case V4L2_CID_ROTATE:			return "Rotate";
-	case V4L2_CID_BG_COLOR:			return "Background Color";
-
-	/* MPEG controls */
-	case V4L2_CID_MPEG_CLASS: 		return "MPEG Encoder Controls";
-	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ: return "Audio Sampling Frequency";
-	case V4L2_CID_MPEG_AUDIO_ENCODING: 	return "Audio Encoding";
-	case V4L2_CID_MPEG_AUDIO_L1_BITRATE: 	return "Audio Layer I Bitrate";
-	case V4L2_CID_MPEG_AUDIO_L2_BITRATE: 	return "Audio Layer II Bitrate";
-	case V4L2_CID_MPEG_AUDIO_L3_BITRATE: 	return "Audio Layer III Bitrate";
-	case V4L2_CID_MPEG_AUDIO_AAC_BITRATE: 	return "Audio AAC Bitrate";
-	case V4L2_CID_MPEG_AUDIO_AC3_BITRATE: 	return "Audio AC-3 Bitrate";
-	case V4L2_CID_MPEG_AUDIO_MODE: 		return "Audio Stereo Mode";
-	case V4L2_CID_MPEG_AUDIO_MODE_EXTENSION: return "Audio Stereo Mode Extension";
-	case V4L2_CID_MPEG_AUDIO_EMPHASIS: 	return "Audio Emphasis";
-	case V4L2_CID_MPEG_AUDIO_CRC: 		return "Audio CRC";
-	case V4L2_CID_MPEG_AUDIO_MUTE: 		return "Audio Mute";
-	case V4L2_CID_MPEG_VIDEO_ENCODING: 	return "Video Encoding";
-	case V4L2_CID_MPEG_VIDEO_ASPECT: 	return "Video Aspect";
-	case V4L2_CID_MPEG_VIDEO_B_FRAMES: 	return "Video B Frames";
-	case V4L2_CID_MPEG_VIDEO_GOP_SIZE: 	return "Video GOP Size";
-	case V4L2_CID_MPEG_VIDEO_GOP_CLOSURE: 	return "Video GOP Closure";
-	case V4L2_CID_MPEG_VIDEO_PULLDOWN: 	return "Video Pulldown";
-	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE: 	return "Video Bitrate Mode";
-	case V4L2_CID_MPEG_VIDEO_BITRATE: 	return "Video Bitrate";
-	case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK: 	return "Video Peak Bitrate";
-	case V4L2_CID_MPEG_VIDEO_TEMPORAL_DECIMATION: return "Video Temporal Decimation";
-	case V4L2_CID_MPEG_VIDEO_MUTE: 		return "Video Mute";
-	case V4L2_CID_MPEG_VIDEO_MUTE_YUV:	return "Video Mute YUV";
-	case V4L2_CID_MPEG_STREAM_TYPE: 	return "Stream Type";
-	case V4L2_CID_MPEG_STREAM_PID_PMT: 	return "Stream PMT Program ID";
-	case V4L2_CID_MPEG_STREAM_PID_AUDIO: 	return "Stream Audio Program ID";
-	case V4L2_CID_MPEG_STREAM_PID_VIDEO: 	return "Stream Video Program ID";
-	case V4L2_CID_MPEG_STREAM_PID_PCR: 	return "Stream PCR Program ID";
-	case V4L2_CID_MPEG_STREAM_PES_ID_AUDIO: return "Stream PES Audio ID";
-	case V4L2_CID_MPEG_STREAM_PES_ID_VIDEO: return "Stream PES Video ID";
-	case V4L2_CID_MPEG_STREAM_VBI_FMT:	return "Stream VBI Format";
-
-	/* CAMERA controls */
-	case V4L2_CID_CAMERA_CLASS:		return "Camera Controls";
-	case V4L2_CID_EXPOSURE_AUTO:		return "Auto Exposure";
-	case V4L2_CID_EXPOSURE_ABSOLUTE:	return "Exposure Time, Absolute";
-	case V4L2_CID_EXPOSURE_AUTO_PRIORITY:	return "Exposure, Dynamic Framerate";
-	case V4L2_CID_PAN_RELATIVE:		return "Pan, Relative";
-	case V4L2_CID_TILT_RELATIVE:		return "Tilt, Relative";
-	case V4L2_CID_PAN_RESET:		return "Pan, Reset";
-	case V4L2_CID_TILT_RESET:		return "Tilt, Reset";
-	case V4L2_CID_PAN_ABSOLUTE:		return "Pan, Absolute";
-	case V4L2_CID_TILT_ABSOLUTE:		return "Tilt, Absolute";
-	case V4L2_CID_FOCUS_ABSOLUTE:		return "Focus, Absolute";
-	case V4L2_CID_FOCUS_RELATIVE:		return "Focus, Relative";
-	case V4L2_CID_FOCUS_AUTO:		return "Focus, Automatic";
-	case V4L2_CID_IRIS_ABSOLUTE:		return "Iris, Absolute";
-	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
-	case V4L2_CID_ZOOM_ABSOLUTE:		return "Zoom, Absolute";
-	case V4L2_CID_ZOOM_RELATIVE:		return "Zoom, Relative";
-	case V4L2_CID_ZOOM_CONTINUOUS:		return "Zoom, Continuous";
-	case V4L2_CID_PRIVACY:			return "Privacy";
-
-	/* FM Radio Modulator control */
-	case V4L2_CID_FM_TX_CLASS:		return "FM Radio Modulator Controls";
-	case V4L2_CID_RDS_TX_DEVIATION:		return "RDS Signal Deviation";
-	case V4L2_CID_RDS_TX_PI:		return "RDS Program ID";
-	case V4L2_CID_RDS_TX_PTY:		return "RDS Program Type";
-	case V4L2_CID_RDS_TX_PS_NAME:		return "RDS PS Name";
-	case V4L2_CID_RDS_TX_RADIO_TEXT:	return "RDS Radio Text";
-	case V4L2_CID_AUDIO_LIMITER_ENABLED:	return "Audio Limiter Feature Enabled";
-	case V4L2_CID_AUDIO_LIMITER_RELEASE_TIME: return "Audio Limiter Release Time";
-	case V4L2_CID_AUDIO_LIMITER_DEVIATION:	return "Audio Limiter Deviation";
-	case V4L2_CID_AUDIO_COMPRESSION_ENABLED: return "Audio Compression Feature Enabled";
-	case V4L2_CID_AUDIO_COMPRESSION_GAIN:	return "Audio Compression Gain";
-	case V4L2_CID_AUDIO_COMPRESSION_THRESHOLD: return "Audio Compression Threshold";
-	case V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME: return "Audio Compression Attack Time";
-	case V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME: return "Audio Compression Release Time";
-	case V4L2_CID_PILOT_TONE_ENABLED:	return "Pilot Tone Feature Enabled";
-	case V4L2_CID_PILOT_TONE_DEVIATION:	return "Pilot Tone Deviation";
-	case V4L2_CID_PILOT_TONE_FREQUENCY:	return "Pilot Tone Frequency";
-	case V4L2_CID_TUNE_PREEMPHASIS:	return "Pre-emphasis settings";
-	case V4L2_CID_TUNE_POWER_LEVEL:		return "Tune Power Level";
-	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:	return "Tune Antenna Capacitor";
-
-	default:
-		return NULL;
-	}
-}
-EXPORT_SYMBOL(v4l2_ctrl_get_name);
-
 /* Fill in a struct v4l2_queryctrl */
 int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 step, s32 def)
 {
-	const char *name = v4l2_ctrl_get_name(qctrl->id);
+	const char *name;
+
+	v4l2_ctrl_fill(qctrl->id, &name, &qctrl->type,
+		       &min, &max, &step, &def, &qctrl->flags);
 
-	qctrl->flags = 0;
 	if (name == NULL)
 		return -EINVAL;
 
-	switch (qctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-	case V4L2_CID_AUDIO_LOUDNESS:
-	case V4L2_CID_AUTO_WHITE_BALANCE:
-	case V4L2_CID_AUTOGAIN:
-	case V4L2_CID_HFLIP:
-	case V4L2_CID_VFLIP:
-	case V4L2_CID_HUE_AUTO:
-	case V4L2_CID_CHROMA_AGC:
-	case V4L2_CID_COLOR_KILLER:
-	case V4L2_CID_MPEG_AUDIO_MUTE:
-	case V4L2_CID_MPEG_VIDEO_MUTE:
-	case V4L2_CID_MPEG_VIDEO_GOP_CLOSURE:
-	case V4L2_CID_MPEG_VIDEO_PULLDOWN:
-	case V4L2_CID_EXPOSURE_AUTO_PRIORITY:
-	case V4L2_CID_FOCUS_AUTO:
-	case V4L2_CID_PRIVACY:
-	case V4L2_CID_AUDIO_LIMITER_ENABLED:
-	case V4L2_CID_AUDIO_COMPRESSION_ENABLED:
-	case V4L2_CID_PILOT_TONE_ENABLED:
-		qctrl->type = V4L2_CTRL_TYPE_BOOLEAN;
-		min = 0;
-		max = step = 1;
-		break;
-	case V4L2_CID_PAN_RESET:
-	case V4L2_CID_TILT_RESET:
-		qctrl->type = V4L2_CTRL_TYPE_BUTTON;
-		qctrl->flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
-		min = max = step = def = 0;
-		break;
-	case V4L2_CID_POWER_LINE_FREQUENCY:
-	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
-	case V4L2_CID_MPEG_AUDIO_ENCODING:
-	case V4L2_CID_MPEG_AUDIO_L1_BITRATE:
-	case V4L2_CID_MPEG_AUDIO_L2_BITRATE:
-	case V4L2_CID_MPEG_AUDIO_L3_BITRATE:
-	case V4L2_CID_MPEG_AUDIO_AC3_BITRATE:
-	case V4L2_CID_MPEG_AUDIO_MODE:
-	case V4L2_CID_MPEG_AUDIO_MODE_EXTENSION:
-	case V4L2_CID_MPEG_AUDIO_EMPHASIS:
-	case V4L2_CID_MPEG_AUDIO_CRC:
-	case V4L2_CID_MPEG_VIDEO_ENCODING:
-	case V4L2_CID_MPEG_VIDEO_ASPECT:
-	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
-	case V4L2_CID_MPEG_STREAM_TYPE:
-	case V4L2_CID_MPEG_STREAM_VBI_FMT:
-	case V4L2_CID_EXPOSURE_AUTO:
-	case V4L2_CID_COLORFX:
-	case V4L2_CID_TUNE_PREEMPHASIS:
-		qctrl->type = V4L2_CTRL_TYPE_MENU;
-		step = 1;
-		break;
-	case V4L2_CID_RDS_TX_PS_NAME:
-	case V4L2_CID_RDS_TX_RADIO_TEXT:
-		qctrl->type = V4L2_CTRL_TYPE_STRING;
-		break;
-	case V4L2_CID_USER_CLASS:
-	case V4L2_CID_CAMERA_CLASS:
-	case V4L2_CID_MPEG_CLASS:
-	case V4L2_CID_FM_TX_CLASS:
-		qctrl->type = V4L2_CTRL_TYPE_CTRL_CLASS;
-		qctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
-		min = max = step = def = 0;
-		break;
-	case V4L2_CID_BG_COLOR:
-		qctrl->type = V4L2_CTRL_TYPE_INTEGER;
-		step = 1;
-		min = 0;
-		/* Max is calculated as RGB888 that is 2^24 */
-		max = 0xFFFFFF;
-		break;
-	default:
-		qctrl->type = V4L2_CTRL_TYPE_INTEGER;
-		break;
-	}
-	switch (qctrl->id) {
-	case V4L2_CID_MPEG_AUDIO_ENCODING:
-	case V4L2_CID_MPEG_AUDIO_MODE:
-	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
-	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
-	case V4L2_CID_MPEG_STREAM_TYPE:
-		qctrl->flags |= V4L2_CTRL_FLAG_UPDATE;
-		break;
-	case V4L2_CID_AUDIO_VOLUME:
-	case V4L2_CID_AUDIO_BALANCE:
-	case V4L2_CID_AUDIO_BASS:
-	case V4L2_CID_AUDIO_TREBLE:
-	case V4L2_CID_BRIGHTNESS:
-	case V4L2_CID_CONTRAST:
-	case V4L2_CID_SATURATION:
-	case V4L2_CID_HUE:
-	case V4L2_CID_RED_BALANCE:
-	case V4L2_CID_BLUE_BALANCE:
-	case V4L2_CID_GAMMA:
-	case V4L2_CID_SHARPNESS:
-	case V4L2_CID_CHROMA_GAIN:
-	case V4L2_CID_RDS_TX_DEVIATION:
-	case V4L2_CID_AUDIO_LIMITER_RELEASE_TIME:
-	case V4L2_CID_AUDIO_LIMITER_DEVIATION:
-	case V4L2_CID_AUDIO_COMPRESSION_GAIN:
-	case V4L2_CID_AUDIO_COMPRESSION_THRESHOLD:
-	case V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME:
-	case V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME:
-	case V4L2_CID_PILOT_TONE_DEVIATION:
-	case V4L2_CID_PILOT_TONE_FREQUENCY:
-	case V4L2_CID_TUNE_POWER_LEVEL:
-	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:
-		qctrl->flags |= V4L2_CTRL_FLAG_SLIDER;
-		break;
-	case V4L2_CID_PAN_RELATIVE:
-	case V4L2_CID_TILT_RELATIVE:
-	case V4L2_CID_FOCUS_RELATIVE:
-	case V4L2_CID_IRIS_RELATIVE:
-	case V4L2_CID_ZOOM_RELATIVE:
-		qctrl->flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
-		break;
-	}
 	qctrl->minimum = min;
 	qctrl->maximum = max;
 	qctrl->step = step;
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
new file mode 100644
index 0000000..6c97ff0
--- /dev/null
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -0,0 +1,1840 @@
+/*
+    V4L2 controls framework implementation.
+
+    Copyright (C) 2010  Hans Verkuil <hverkuil@xs4all.nl>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/ctype.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-dev.h>
+
+/* Internal temporary helper struct, one for each v4l2_ext_control */
+struct ctrl_helper {
+	/* The control corresponding to the v4l2_ext_control ID field. */
+	struct v4l2_ctrl *ctrl;
+	/* Used internally to mark whether this control was already
+	   processed. */
+	bool handled;
+};
+
+/* Returns NULL or a character pointer array containing the menu for
+   the given control ID. The pointer array ends with a NULL pointer.
+   An empty string signifies a menu entry that is invalid. This allows
+   drivers to disable certain options if it is not supported. */
+const char **v4l2_ctrl_get_menu(u32 id)
+{
+	static const char *mpeg_audio_sampling_freq[] = {
+		"44.1 kHz",
+		"48 kHz",
+		"32 kHz",
+		NULL
+	};
+	static const char *mpeg_audio_encoding[] = {
+		"MPEG-1/2 Layer I",
+		"MPEG-1/2 Layer II",
+		"MPEG-1/2 Layer III",
+		"MPEG-2/4 AAC",
+		"AC-3",
+		NULL
+	};
+	static const char *mpeg_audio_l1_bitrate[] = {
+		"32 kbps",
+		"64 kbps",
+		"96 kbps",
+		"128 kbps",
+		"160 kbps",
+		"192 kbps",
+		"224 kbps",
+		"256 kbps",
+		"288 kbps",
+		"320 kbps",
+		"352 kbps",
+		"384 kbps",
+		"416 kbps",
+		"448 kbps",
+		NULL
+	};
+	static const char *mpeg_audio_l2_bitrate[] = {
+		"32 kbps",
+		"48 kbps",
+		"56 kbps",
+		"64 kbps",
+		"80 kbps",
+		"96 kbps",
+		"112 kbps",
+		"128 kbps",
+		"160 kbps",
+		"192 kbps",
+		"224 kbps",
+		"256 kbps",
+		"320 kbps",
+		"384 kbps",
+		NULL
+	};
+	static const char *mpeg_audio_l3_bitrate[] = {
+		"32 kbps",
+		"40 kbps",
+		"48 kbps",
+		"56 kbps",
+		"64 kbps",
+		"80 kbps",
+		"96 kbps",
+		"112 kbps",
+		"128 kbps",
+		"160 kbps",
+		"192 kbps",
+		"224 kbps",
+		"256 kbps",
+		"320 kbps",
+		NULL
+	};
+	static const char *mpeg_audio_ac3_bitrate[] = {
+		"32 kbps",
+		"40 kbps",
+		"48 kbps",
+		"56 kbps",
+		"64 kbps",
+		"80 kbps",
+		"96 kbps",
+		"112 kbps",
+		"128 kbps",
+		"160 kbps",
+		"192 kbps",
+		"224 kbps",
+		"256 kbps",
+		"320 kbps",
+		"384 kbps",
+		"448 kbps",
+		"512 kbps",
+		"576 kbps",
+		"640 kbps",
+		NULL
+	};
+	static const char *mpeg_audio_mode[] = {
+		"Stereo",
+		"Joint Stereo",
+		"Dual",
+		"Mono",
+		NULL
+	};
+	static const char *mpeg_audio_mode_extension[] = {
+		"Bound 4",
+		"Bound 8",
+		"Bound 12",
+		"Bound 16",
+		NULL
+	};
+	static const char *mpeg_audio_emphasis[] = {
+		"No Emphasis",
+		"50/15 us",
+		"CCITT J17",
+		NULL
+	};
+	static const char *mpeg_audio_crc[] = {
+		"No CRC",
+		"16-bit CRC",
+		NULL
+	};
+	static const char *mpeg_video_encoding[] = {
+		"MPEG-1",
+		"MPEG-2",
+		"MPEG-4 AVC",
+		NULL
+	};
+	static const char *mpeg_video_aspect[] = {
+		"1x1",
+		"4x3",
+		"16x9",
+		"2.21x1",
+		NULL
+	};
+	static const char *mpeg_video_bitrate_mode[] = {
+		"Variable Bitrate",
+		"Constant Bitrate",
+		NULL
+	};
+	static const char *mpeg_stream_type[] = {
+		"MPEG-2 Program Stream",
+		"MPEG-2 Transport Stream",
+		"MPEG-1 System Stream",
+		"MPEG-2 DVD-compatible Stream",
+		"MPEG-1 VCD-compatible Stream",
+		"MPEG-2 SVCD-compatible Stream",
+		NULL
+	};
+	static const char *mpeg_stream_vbi_fmt[] = {
+		"No VBI",
+		"Private packet, IVTV format",
+		NULL
+	};
+	static const char *camera_power_line_frequency[] = {
+		"Disabled",
+		"50 Hz",
+		"60 Hz",
+		NULL
+	};
+	static const char *camera_exposure_auto[] = {
+		"Auto Mode",
+		"Manual Mode",
+		"Shutter Priority Mode",
+		"Aperture Priority Mode",
+		NULL
+	};
+	static const char *colorfx[] = {
+		"None",
+		"Black & White",
+		"Sepia",
+		"Negative",
+		"Emboss",
+		"Sketch",
+		"Sky blue",
+		"Grass green",
+		"Skin whiten",
+		"Vivid",
+		NULL
+	};
+	static const char *tune_preemphasis[] = {
+		"No preemphasis",
+		"50 useconds",
+		"75 useconds",
+		NULL,
+	};
+
+	switch (id) {
+	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
+		return mpeg_audio_sampling_freq;
+	case V4L2_CID_MPEG_AUDIO_ENCODING:
+		return mpeg_audio_encoding;
+	case V4L2_CID_MPEG_AUDIO_L1_BITRATE:
+		return mpeg_audio_l1_bitrate;
+	case V4L2_CID_MPEG_AUDIO_L2_BITRATE:
+		return mpeg_audio_l2_bitrate;
+	case V4L2_CID_MPEG_AUDIO_L3_BITRATE:
+		return mpeg_audio_l3_bitrate;
+	case V4L2_CID_MPEG_AUDIO_AC3_BITRATE:
+		return mpeg_audio_ac3_bitrate;
+	case V4L2_CID_MPEG_AUDIO_MODE:
+		return mpeg_audio_mode;
+	case V4L2_CID_MPEG_AUDIO_MODE_EXTENSION:
+		return mpeg_audio_mode_extension;
+	case V4L2_CID_MPEG_AUDIO_EMPHASIS:
+		return mpeg_audio_emphasis;
+	case V4L2_CID_MPEG_AUDIO_CRC:
+		return mpeg_audio_crc;
+	case V4L2_CID_MPEG_VIDEO_ENCODING:
+		return mpeg_video_encoding;
+	case V4L2_CID_MPEG_VIDEO_ASPECT:
+		return mpeg_video_aspect;
+	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
+		return mpeg_video_bitrate_mode;
+	case V4L2_CID_MPEG_STREAM_TYPE:
+		return mpeg_stream_type;
+	case V4L2_CID_MPEG_STREAM_VBI_FMT:
+		return mpeg_stream_vbi_fmt;
+	case V4L2_CID_POWER_LINE_FREQUENCY:
+		return camera_power_line_frequency;
+	case V4L2_CID_EXPOSURE_AUTO:
+		return camera_exposure_auto;
+	case V4L2_CID_COLORFX:
+		return colorfx;
+	case V4L2_CID_TUNE_PREEMPHASIS:
+		return tune_preemphasis;
+	default:
+		return NULL;
+	}
+}
+EXPORT_SYMBOL(v4l2_ctrl_get_menu);
+
+/* Return the control name. */
+const char *v4l2_ctrl_get_name(u32 id)
+{
+	switch (id) {
+	/* USER controls */
+	case V4L2_CID_USER_CLASS: 		return "User Controls";
+	case V4L2_CID_BRIGHTNESS: 		return "Brightness";
+	case V4L2_CID_CONTRAST: 		return "Contrast";
+	case V4L2_CID_SATURATION: 		return "Saturation";
+	case V4L2_CID_HUE: 			return "Hue";
+	case V4L2_CID_AUDIO_VOLUME: 		return "Volume";
+	case V4L2_CID_AUDIO_BALANCE: 		return "Balance";
+	case V4L2_CID_AUDIO_BASS: 		return "Bass";
+	case V4L2_CID_AUDIO_TREBLE: 		return "Treble";
+	case V4L2_CID_AUDIO_MUTE: 		return "Mute";
+	case V4L2_CID_AUDIO_LOUDNESS: 		return "Loudness";
+	case V4L2_CID_BLACK_LEVEL:		return "Black Level";
+	case V4L2_CID_AUTO_WHITE_BALANCE:	return "White Balance, Automatic";
+	case V4L2_CID_DO_WHITE_BALANCE:		return "Do White Balance";
+	case V4L2_CID_RED_BALANCE:		return "Red Balance";
+	case V4L2_CID_BLUE_BALANCE:		return "Blue Balance";
+	case V4L2_CID_GAMMA:			return "Gamma";
+	case V4L2_CID_EXPOSURE:			return "Exposure";
+	case V4L2_CID_AUTOGAIN:			return "Gain, Automatic";
+	case V4L2_CID_GAIN:			return "Gain";
+	case V4L2_CID_HFLIP:			return "Horizontal Flip";
+	case V4L2_CID_VFLIP:			return "Vertical Flip";
+	case V4L2_CID_HCENTER:			return "Horizontal Center";
+	case V4L2_CID_VCENTER:			return "Vertical Center";
+	case V4L2_CID_POWER_LINE_FREQUENCY:	return "Power Line Frequency";
+	case V4L2_CID_HUE_AUTO:			return "Hue, Automatic";
+	case V4L2_CID_WHITE_BALANCE_TEMPERATURE: return "White Balance Temperature";
+	case V4L2_CID_SHARPNESS:		return "Sharpness";
+	case V4L2_CID_BACKLIGHT_COMPENSATION:	return "Backlight Compensation";
+	case V4L2_CID_CHROMA_AGC:		return "Chroma AGC";
+	case V4L2_CID_CHROMA_GAIN:		return "Chroma Gain";
+	case V4L2_CID_COLOR_KILLER:		return "Color Killer";
+	case V4L2_CID_COLORFX:			return "Color Effects";
+	case V4L2_CID_AUTOBRIGHTNESS:		return "Brightness, Automatic";
+	case V4L2_CID_BAND_STOP_FILTER:		return "Band-Stop Filter";
+	case V4L2_CID_ROTATE:			return "Rotate";
+	case V4L2_CID_BG_COLOR:			return "Background Color";
+
+	/* MPEG controls */
+	case V4L2_CID_MPEG_CLASS: 		return "MPEG Encoder Controls";
+	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ: return "Audio Sampling Frequency";
+	case V4L2_CID_MPEG_AUDIO_ENCODING: 	return "Audio Encoding";
+	case V4L2_CID_MPEG_AUDIO_L1_BITRATE: 	return "Audio Layer I Bitrate";
+	case V4L2_CID_MPEG_AUDIO_L2_BITRATE: 	return "Audio Layer II Bitrate";
+	case V4L2_CID_MPEG_AUDIO_L3_BITRATE: 	return "Audio Layer III Bitrate";
+	case V4L2_CID_MPEG_AUDIO_AAC_BITRATE: 	return "Audio AAC Bitrate";
+	case V4L2_CID_MPEG_AUDIO_AC3_BITRATE: 	return "Audio AC-3 Bitrate";
+	case V4L2_CID_MPEG_AUDIO_MODE: 		return "Audio Stereo Mode";
+	case V4L2_CID_MPEG_AUDIO_MODE_EXTENSION: return "Audio Stereo Mode Extension";
+	case V4L2_CID_MPEG_AUDIO_EMPHASIS: 	return "Audio Emphasis";
+	case V4L2_CID_MPEG_AUDIO_CRC: 		return "Audio CRC";
+	case V4L2_CID_MPEG_AUDIO_MUTE: 		return "Audio Mute";
+	case V4L2_CID_MPEG_VIDEO_ENCODING: 	return "Video Encoding";
+	case V4L2_CID_MPEG_VIDEO_ASPECT: 	return "Video Aspect";
+	case V4L2_CID_MPEG_VIDEO_B_FRAMES: 	return "Video B Frames";
+	case V4L2_CID_MPEG_VIDEO_GOP_SIZE: 	return "Video GOP Size";
+	case V4L2_CID_MPEG_VIDEO_GOP_CLOSURE: 	return "Video GOP Closure";
+	case V4L2_CID_MPEG_VIDEO_PULLDOWN: 	return "Video Pulldown";
+	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE: 	return "Video Bitrate Mode";
+	case V4L2_CID_MPEG_VIDEO_BITRATE: 	return "Video Bitrate";
+	case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK: 	return "Video Peak Bitrate";
+	case V4L2_CID_MPEG_VIDEO_TEMPORAL_DECIMATION: return "Video Temporal Decimation";
+	case V4L2_CID_MPEG_VIDEO_MUTE: 		return "Video Mute";
+	case V4L2_CID_MPEG_VIDEO_MUTE_YUV:	return "Video Mute YUV";
+	case V4L2_CID_MPEG_STREAM_TYPE: 	return "Stream Type";
+	case V4L2_CID_MPEG_STREAM_PID_PMT: 	return "Stream PMT Program ID";
+	case V4L2_CID_MPEG_STREAM_PID_AUDIO: 	return "Stream Audio Program ID";
+	case V4L2_CID_MPEG_STREAM_PID_VIDEO: 	return "Stream Video Program ID";
+	case V4L2_CID_MPEG_STREAM_PID_PCR: 	return "Stream PCR Program ID";
+	case V4L2_CID_MPEG_STREAM_PES_ID_AUDIO: return "Stream PES Audio ID";
+	case V4L2_CID_MPEG_STREAM_PES_ID_VIDEO: return "Stream PES Video ID";
+	case V4L2_CID_MPEG_STREAM_VBI_FMT:	return "Stream VBI Format";
+
+	/* CAMERA controls */
+	case V4L2_CID_CAMERA_CLASS:		return "Camera Controls";
+	case V4L2_CID_EXPOSURE_AUTO:		return "Auto Exposure";
+	case V4L2_CID_EXPOSURE_ABSOLUTE:	return "Exposure Time, Absolute";
+	case V4L2_CID_EXPOSURE_AUTO_PRIORITY:	return "Exposure, Dynamic Framerate";
+	case V4L2_CID_PAN_RELATIVE:		return "Pan, Relative";
+	case V4L2_CID_TILT_RELATIVE:		return "Tilt, Relative";
+	case V4L2_CID_PAN_RESET:		return "Pan, Reset";
+	case V4L2_CID_TILT_RESET:		return "Tilt, Reset";
+	case V4L2_CID_PAN_ABSOLUTE:		return "Pan, Absolute";
+	case V4L2_CID_TILT_ABSOLUTE:		return "Tilt, Absolute";
+	case V4L2_CID_FOCUS_ABSOLUTE:		return "Focus, Absolute";
+	case V4L2_CID_FOCUS_RELATIVE:		return "Focus, Relative";
+	case V4L2_CID_FOCUS_AUTO:		return "Focus, Automatic";
+	case V4L2_CID_IRIS_ABSOLUTE:		return "Iris, Absolute";
+	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
+	case V4L2_CID_ZOOM_ABSOLUTE:		return "Zoom, Absolute";
+	case V4L2_CID_ZOOM_RELATIVE:		return "Zoom, Relative";
+	case V4L2_CID_ZOOM_CONTINUOUS:		return "Zoom, Continuous";
+	case V4L2_CID_PRIVACY:			return "Privacy";
+
+	/* FM Radio Modulator control */
+	case V4L2_CID_FM_TX_CLASS:		return "FM Radio Modulator Controls";
+	case V4L2_CID_RDS_TX_DEVIATION:		return "RDS Signal Deviation";
+	case V4L2_CID_RDS_TX_PI:		return "RDS Program ID";
+	case V4L2_CID_RDS_TX_PTY:		return "RDS Program Type";
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
+	case V4L2_CID_TUNE_PREEMPHASIS:		return "Pre-emphasis settings";
+	case V4L2_CID_TUNE_POWER_LEVEL:		return "Tune Power Level";
+	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:	return "Tune Antenna Capacitor";
+
+	default:
+		return NULL;
+	}
+}
+EXPORT_SYMBOL(v4l2_ctrl_get_name);
+
+void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
+		    s32 *min, s32 *max, s32 *step, s32 *def, u32 *flags)
+{
+	*name = v4l2_ctrl_get_name(id);
+	*flags = 0;
+
+	switch (id) {
+	case V4L2_CID_AUDIO_MUTE:
+	case V4L2_CID_AUDIO_LOUDNESS:
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+	case V4L2_CID_AUTOGAIN:
+	case V4L2_CID_HFLIP:
+	case V4L2_CID_VFLIP:
+	case V4L2_CID_HUE_AUTO:
+	case V4L2_CID_CHROMA_AGC:
+	case V4L2_CID_COLOR_KILLER:
+	case V4L2_CID_MPEG_AUDIO_MUTE:
+	case V4L2_CID_MPEG_VIDEO_MUTE:
+	case V4L2_CID_MPEG_VIDEO_GOP_CLOSURE:
+	case V4L2_CID_MPEG_VIDEO_PULLDOWN:
+	case V4L2_CID_EXPOSURE_AUTO_PRIORITY:
+	case V4L2_CID_FOCUS_AUTO:
+	case V4L2_CID_PRIVACY:
+	case V4L2_CID_AUDIO_LIMITER_ENABLED:
+	case V4L2_CID_AUDIO_COMPRESSION_ENABLED:
+	case V4L2_CID_PILOT_TONE_ENABLED:
+		*type = V4L2_CTRL_TYPE_BOOLEAN;
+		*min = 0;
+		*max = *step = 1;
+		break;
+	case V4L2_CID_PAN_RESET:
+	case V4L2_CID_TILT_RESET:
+		*type = V4L2_CTRL_TYPE_BUTTON;
+		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
+		*min = *max = *step = *def = 0;
+		break;
+	case V4L2_CID_POWER_LINE_FREQUENCY:
+	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
+	case V4L2_CID_MPEG_AUDIO_ENCODING:
+	case V4L2_CID_MPEG_AUDIO_L1_BITRATE:
+	case V4L2_CID_MPEG_AUDIO_L2_BITRATE:
+	case V4L2_CID_MPEG_AUDIO_L3_BITRATE:
+	case V4L2_CID_MPEG_AUDIO_AC3_BITRATE:
+	case V4L2_CID_MPEG_AUDIO_MODE:
+	case V4L2_CID_MPEG_AUDIO_MODE_EXTENSION:
+	case V4L2_CID_MPEG_AUDIO_EMPHASIS:
+	case V4L2_CID_MPEG_AUDIO_CRC:
+	case V4L2_CID_MPEG_VIDEO_ENCODING:
+	case V4L2_CID_MPEG_VIDEO_ASPECT:
+	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
+	case V4L2_CID_MPEG_STREAM_TYPE:
+	case V4L2_CID_MPEG_STREAM_VBI_FMT:
+	case V4L2_CID_EXPOSURE_AUTO:
+	case V4L2_CID_COLORFX:
+	case V4L2_CID_TUNE_PREEMPHASIS:
+		*type = V4L2_CTRL_TYPE_MENU;
+		break;
+	case V4L2_CID_RDS_TX_PS_NAME:
+	case V4L2_CID_RDS_TX_RADIO_TEXT:
+		*type = V4L2_CTRL_TYPE_STRING;
+		break;
+	case V4L2_CID_USER_CLASS:
+	case V4L2_CID_CAMERA_CLASS:
+	case V4L2_CID_MPEG_CLASS:
+	case V4L2_CID_FM_TX_CLASS:
+		*type = V4L2_CTRL_TYPE_CTRL_CLASS;
+		/* You can neither read not write these */
+		*flags |= V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_WRITE_ONLY;
+		*min = *max = *step = *def = 0;
+		break;
+	case V4L2_CID_BG_COLOR:
+		*type = V4L2_CTRL_TYPE_INTEGER;
+		*step = 1;
+		*min = 0;
+		/* Max is calculated as RGB888 that is 2^24 */
+		*max = 0xFFFFFF;
+		break;
+	default:
+		*type = V4L2_CTRL_TYPE_INTEGER;
+		break;
+	}
+	switch (id) {
+	case V4L2_CID_MPEG_AUDIO_ENCODING:
+	case V4L2_CID_MPEG_AUDIO_MODE:
+	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
+	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
+	case V4L2_CID_MPEG_STREAM_TYPE:
+		*flags |= V4L2_CTRL_FLAG_UPDATE;
+		break;
+	case V4L2_CID_AUDIO_VOLUME:
+	case V4L2_CID_AUDIO_BALANCE:
+	case V4L2_CID_AUDIO_BASS:
+	case V4L2_CID_AUDIO_TREBLE:
+	case V4L2_CID_BRIGHTNESS:
+	case V4L2_CID_CONTRAST:
+	case V4L2_CID_SATURATION:
+	case V4L2_CID_HUE:
+	case V4L2_CID_RED_BALANCE:
+	case V4L2_CID_BLUE_BALANCE:
+	case V4L2_CID_GAMMA:
+	case V4L2_CID_SHARPNESS:
+	case V4L2_CID_CHROMA_GAIN:
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
+		*flags |= V4L2_CTRL_FLAG_SLIDER;
+		break;
+	case V4L2_CID_PAN_RELATIVE:
+	case V4L2_CID_TILT_RELATIVE:
+	case V4L2_CID_FOCUS_RELATIVE:
+	case V4L2_CID_IRIS_RELATIVE:
+	case V4L2_CID_ZOOM_RELATIVE:
+		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
+		break;
+	}
+}
+EXPORT_SYMBOL(v4l2_ctrl_fill);
+
+/* Helper function to determine whether the control type is compatible with
+   VIDIOC_G/S_CTRL. */
+static bool type_is_int(const struct v4l2_ctrl *ctrl)
+{
+	switch (ctrl->type) {
+	case V4L2_CTRL_TYPE_INTEGER64:
+	case V4L2_CTRL_TYPE_STRING:
+		/* Nope, these need v4l2_ext_control */
+		return false;
+	default:
+		return true;
+	}
+}
+
+/* Helper function: copy the current control value back to the caller */
+static int cur_to_user(struct v4l2_ext_control *c,
+		       struct v4l2_ctrl *ctrl)
+{
+	u32 len;
+
+	switch (ctrl->type) {
+	case V4L2_CTRL_TYPE_STRING:
+		len = strlen(ctrl->cur.string);
+		if (c->size < len + 1) {
+			c->size = len + 1;
+			return -ENOSPC;
+		}
+		return copy_to_user(c->string, ctrl->cur.string,
+						len + 1) ? -EFAULT : 0;
+	case V4L2_CTRL_TYPE_INTEGER64:
+		c->value64 = ctrl->cur.val64;
+		break;
+	default:
+		c->value = ctrl->cur.val;
+		break;
+	}
+	return 0;
+}
+
+/* Helper function: copy the caller-provider value as the new control value */
+static int user_to_new(struct v4l2_ext_control *c,
+		       struct v4l2_ctrl *ctrl)
+{
+	int ret;
+	u32 size;
+
+	ctrl->has_new = 1;
+	switch (ctrl->type) {
+	case V4L2_CTRL_TYPE_INTEGER64:
+		ctrl->val64 = c->value64;
+		break;
+	case V4L2_CTRL_TYPE_STRING:
+		size = c->size;
+		if (size == 0)
+			return -ERANGE;
+		if (size > ctrl->maximum + 1)
+			size = ctrl->maximum + 1;
+		ret = copy_from_user(ctrl->string, c->string, size);
+		if (!ret) {
+			char last = ctrl->string[size - 1];
+
+			ctrl->string[size - 1] = 0;
+			/* If the string was longer than ctrl->maximum,
+			   then return an error. */
+			if (strlen(ctrl->string) == ctrl->maximum && last)
+				return -ERANGE;
+		}
+		return ret ? -EFAULT : 0;
+	default:
+		ctrl->val = c->value;
+		break;
+	}
+	return 0;
+}
+
+/* Helper function: copy the new control value back to the caller */
+static int new_to_user(struct v4l2_ext_control *c,
+		       struct v4l2_ctrl *ctrl)
+{
+	u32 len;
+
+	switch (ctrl->type) {
+	case V4L2_CTRL_TYPE_STRING:
+		len = strlen(ctrl->string);
+		if (c->size < len + 1) {
+			c->size = ctrl->maximum + 1;
+			return -ENOSPC;
+		}
+		return copy_to_user(c->string, ctrl->string,
+						len + 1) ? -EFAULT : 0;
+	case V4L2_CTRL_TYPE_INTEGER64:
+		c->value64 = ctrl->val64;
+		break;
+	default:
+		c->value = ctrl->val;
+		break;
+	}
+	return 0;
+}
+
+/* Copy the new value to the current value. */
+static void new_to_cur(struct v4l2_ctrl *ctrl)
+{
+	if (ctrl == NULL)
+		return;
+	switch (ctrl->type) {
+	case V4L2_CTRL_TYPE_STRING:
+		/* strings are always 0-terminated */
+		strcpy(ctrl->cur.string, ctrl->string);
+		break;
+	case V4L2_CTRL_TYPE_INTEGER64:
+		ctrl->cur.val64 = ctrl->val64;
+		break;
+	default:
+		ctrl->cur.val = ctrl->val;
+		break;
+	}
+}
+
+/* Copy the current value to the new value */
+static void cur_to_new(struct v4l2_ctrl *ctrl)
+{
+	if (ctrl == NULL)
+		return;
+	switch (ctrl->type) {
+	case V4L2_CTRL_TYPE_STRING:
+		/* strings are always 0-terminated */
+		strcpy(ctrl->string, ctrl->cur.string);
+		break;
+	case V4L2_CTRL_TYPE_INTEGER64:
+		ctrl->val64 = ctrl->cur.val64;
+		break;
+	default:
+		ctrl->val = ctrl->cur.val;
+		break;
+	}
+}
+
+/* Return non-zero if one or more of the controls in the cluster has a new
+   value that differs from the current value. */
+static int cluster_changed(struct v4l2_ctrl *master)
+{
+	int diff = 0;
+	int i;
+
+	for (i = 0; !diff && i < master->ncontrols; i++) {
+		struct v4l2_ctrl *ctrl = master->cluster[i];
+
+		if (ctrl == NULL)
+			continue;
+		switch (ctrl->type) {
+		case V4L2_CTRL_TYPE_BUTTON:
+			/* Button controls are always 'different' */
+			return 1;
+		case V4L2_CTRL_TYPE_STRING:
+			/* strings are always 0-terminated */
+			diff = strcmp(ctrl->string, ctrl->cur.string);
+			break;
+		case V4L2_CTRL_TYPE_INTEGER64:
+			diff = ctrl->val64 != ctrl->cur.val64;
+			break;
+		default:
+			diff = ctrl->val != ctrl->cur.val;
+			break;
+		}
+	}
+	return diff;
+}
+
+/* Validate a new control */
+static int validate_new(struct v4l2_ctrl *ctrl)
+{
+	s32 val = ctrl->val;
+	char *s = ctrl->string;
+	u32 offset;
+	size_t len;
+
+	switch (ctrl->type) {
+	case V4L2_CTRL_TYPE_INTEGER:
+		/* Round towards the closest legal value */
+		val += ctrl->step / 2;
+		if (val < ctrl->minimum)
+			val = ctrl->minimum;
+		if (val > ctrl->maximum)
+			val = ctrl->maximum;
+		offset = val - ctrl->minimum;
+		offset = ctrl->step * (offset / ctrl->step);
+		val = ctrl->minimum + offset;
+		ctrl->val = val;
+		return 0;
+
+	case V4L2_CTRL_TYPE_BOOLEAN:
+		ctrl->val = !!ctrl->val;
+		return 0;
+
+	case V4L2_CTRL_TYPE_MENU:
+		if (val < ctrl->minimum || val > ctrl->maximum)
+			return -ERANGE;
+		if (ctrl->qmenu[val][0] == '\0' ||
+		    (ctrl->menu_skip_mask & (1 << val)))
+			return -EINVAL;
+		return 0;
+
+	case V4L2_CTRL_TYPE_BUTTON:
+	case V4L2_CTRL_TYPE_CTRL_CLASS:
+		ctrl->val64 = 0;
+		return 0;
+
+	case V4L2_CTRL_TYPE_INTEGER64:
+		return 0;
+
+	case V4L2_CTRL_TYPE_STRING:
+		len = strlen(s);
+		if (len < ctrl->minimum)
+			return -ERANGE;
+		if ((len - ctrl->minimum) % ctrl->step)
+			return -ERANGE;
+		return 0;
+
+	default:
+		return -EINVAL;
+	}
+}
+
+static inline u32 node2id(struct list_head *node)
+{
+	return list_entry(node, struct v4l2_ctrl_ref, node)->ctrl->id;
+}
+
+/* Set the handler's error code if it wasn't set earlier already */
+static inline int handler_set_err(struct v4l2_ctrl_handler *hdl, int err)
+{
+	if (hdl->error == 0)
+		hdl->error = err;
+	return err;
+}
+
+/* Initialize the handler */
+int v4l2_ctrl_handler_init(struct v4l2_ctrl_handler *hdl,
+			   unsigned nr_of_controls_hint)
+{
+	mutex_init(&hdl->lock);
+	INIT_LIST_HEAD(&hdl->ctrls);
+	INIT_LIST_HEAD(&hdl->ctrl_refs);
+	hdl->nr_of_buckets = 1 + nr_of_controls_hint / 8;
+	hdl->buckets = kzalloc(sizeof(hdl->buckets[0]) * hdl->nr_of_buckets,
+								GFP_KERNEL);
+	hdl->error = hdl->buckets ? 0 : -ENOMEM;
+	return hdl->error;
+}
+EXPORT_SYMBOL(v4l2_ctrl_handler_init);
+
+/* Free all controls and control refs */
+void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
+{
+	struct v4l2_ctrl_ref *ref, *next_ref;
+	struct v4l2_ctrl *ctrl, *next_ctrl;
+
+	if (hdl == NULL || hdl->buckets == NULL)
+		return;
+
+	mutex_lock(&hdl->lock);
+	/* Free all nodes */
+	list_for_each_entry_safe(ref, next_ref, &hdl->ctrl_refs, node) {
+		list_del(&ref->node);
+		kfree(ref);
+	}
+	/* Free all controls owned by the handler */
+	list_for_each_entry_safe(ctrl, next_ctrl, &hdl->ctrls, node) {
+		list_del(&ctrl->node);
+		kfree(ctrl);
+	}
+	kfree(hdl->buckets);
+	hdl->buckets = NULL;
+	hdl->cached = NULL;
+	hdl->error = 0;
+	mutex_unlock(&hdl->lock);
+}
+EXPORT_SYMBOL(v4l2_ctrl_handler_free);
+
+/* For backwards compatibility: V4L2_CID_PRIVATE_BASE should no longer
+   be used except in G_CTRL, S_CTRL, QUERYCTRL and QUERYMENU when dealing
+   with applications that do not use the NEXT_CTRL flag.
+
+   We just find the n-th private user control. It's O(N), but that should not
+   be an issue in this particular case. */
+static struct v4l2_ctrl_ref *find_private_ref(
+		struct v4l2_ctrl_handler *hdl, u32 id)
+{
+	struct v4l2_ctrl_ref *ref;
+
+	id -= V4L2_CID_PRIVATE_BASE;
+	list_for_each_entry(ref, &hdl->ctrl_refs, node) {
+		/* Search for private user controls that are compatible with
+		   VIDIOC_G/S_CTRL. */
+		if (V4L2_CTRL_ID2CLASS(ref->ctrl->id) == V4L2_CTRL_CLASS_USER &&
+		    V4L2_CTRL_DRIVER_PRIV(ref->ctrl->id) &&
+		    ref->ctrl->ops->init == NULL &&
+		    type_is_int(ref->ctrl)) {
+			if (id == 0)
+				return ref;
+			id--;
+		}
+	}
+	return NULL;
+}
+
+static void v4l2_ctrl_initialize(struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_ctrl *master = ctrl->cluster[0];
+	int i;
+
+	master->ops->init(master);
+	for (i = 0; i < master->ncontrols; i++)
+		master->cluster[i]->initialized = 1;
+}
+
+/* Find a control with the given ID. */
+static struct v4l2_ctrl_ref *find_ref(struct v4l2_ctrl_handler *hdl, u32 id)
+{
+	struct v4l2_ctrl_ref *ref;
+	int bucket;
+
+	id &= V4L2_CTRL_ID_MASK;
+
+	/* Old-style private controls need special handling */
+	if (id >= V4L2_CID_PRIVATE_BASE)
+		return find_private_ref(hdl, id);
+	bucket = id % hdl->nr_of_buckets;
+
+	/* Simple optimization: cache the last control found */
+	if (hdl->cached && hdl->cached->ctrl->id == id)
+		return hdl->cached;
+
+	/* Not in cache, search the hash */
+	ref = hdl->buckets ? hdl->buckets[bucket] : NULL;
+	while (ref && ref->ctrl->id != id)
+		ref = ref->next;
+
+	if (ref) {
+		if (!ref->ctrl->initialized)
+			v4l2_ctrl_initialize(ref->ctrl);
+		hdl->cached = ref; /* cache it! */
+	}
+	return ref;
+}
+
+/* Find a control with the given ID. Take the handler's lock first. */
+static struct v4l2_ctrl_ref *find_ref_lock(
+		struct v4l2_ctrl_handler *hdl, u32 id)
+{
+	struct v4l2_ctrl_ref *ref = NULL;
+
+	if (hdl) {
+		mutex_lock(&hdl->lock);
+		ref = find_ref(hdl, id);
+		mutex_unlock(&hdl->lock);
+	}
+	return ref;
+}
+
+/* Find a control with the given ID. */
+struct v4l2_ctrl *v4l2_ctrl_find(struct v4l2_ctrl_handler *hdl, u32 id)
+{
+	struct v4l2_ctrl_ref *ref = find_ref_lock(hdl, id);
+
+	return ref ? ref->ctrl : NULL;
+}
+EXPORT_SYMBOL(v4l2_ctrl_find);
+
+/* Allocate a new v4l2_ctrl_ref and hook it into the handler. */
+static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
+			   struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_ctrl_ref *ref;
+	struct v4l2_ctrl_ref *new_ref;
+	u32 id = ctrl->id;
+	u32 class_ctrl = V4L2_CTRL_ID2CLASS(id) | 1;
+	int bucket = id % hdl->nr_of_buckets;	/* which bucket to use */
+
+	/* Automatically add the control class if it is not yet present. */
+	if (id != class_ctrl && find_ref_lock(hdl, class_ctrl) == NULL)
+		if (!v4l2_ctrl_new_std(hdl, NULL, class_ctrl, 0, 0, 0, 0))
+			return hdl->error;
+
+	if (hdl->error)
+		return hdl->error;
+
+	new_ref = kzalloc(sizeof(*new_ref), GFP_KERNEL);
+	if (!new_ref)
+		return handler_set_err(hdl, -ENOMEM);
+	new_ref->ctrl = ctrl;
+	if (ctrl->handler == hdl) {
+		/* By default each control starts in a cluster of its own.
+		   new_ref->ctrl is basically a cluster array with one
+		   element, so that's perfect to use as the cluster pointer.
+		   But only do this for the handler that owns the control. */
+		ctrl->cluster = &new_ref->ctrl;
+		ctrl->ncontrols = 1;
+	}
+
+	INIT_LIST_HEAD(&new_ref->node);
+
+	mutex_lock(&hdl->lock);
+
+	/* Add immediately at the end of the list if the list is empty, or if
+	   the last element in the list has a lower ID.
+	   This ensures that when elements are added in ascending order the
+	   insertion is an O(1) operation. */
+	if (list_empty(&hdl->ctrl_refs) || id > node2id(hdl->ctrl_refs.prev)) {
+		list_add_tail(&new_ref->node, &hdl->ctrl_refs);
+		goto insert_in_hash;
+	}
+
+	/* Find insert position in sorted list */
+	list_for_each_entry(ref, &hdl->ctrl_refs, node) {
+		if (ref->ctrl->id < id)
+			continue;
+		/* Don't add duplicates */
+		if (ref->ctrl->id == id) {
+			kfree(new_ref);
+			goto unlock;
+		}
+		list_add(&new_ref->node, ref->node.prev);
+		break;
+	}
+
+insert_in_hash:
+	/* Insert the control node in the hash */
+	new_ref->next = hdl->buckets[bucket];
+	hdl->buckets[bucket] = new_ref;
+
+unlock:
+	mutex_unlock(&hdl->lock);
+	return 0;
+}
+
+/* Add a new control */
+static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
+			const struct v4l2_ctrl_ops *ops,
+			u32 id, const char *name, enum v4l2_ctrl_type type,
+			s32 min, s32 max, u32 step, s32 def,
+			u32 flags, const char **qmenu, void *priv)
+{
+	struct v4l2_ctrl *ctrl;
+	unsigned sz_extra = 0;
+
+	if (hdl->error)
+		return NULL;
+
+	/* Sanity checks */
+	if (id == 0 || name == NULL || id >= V4L2_CID_PRIVATE_BASE ||
+	    def < min || def > max || max < min ||
+	    (type == V4L2_CTRL_TYPE_INTEGER && step == 0) ||
+	    (type == V4L2_CTRL_TYPE_STRING && max == 0)) {
+		handler_set_err(hdl, -ERANGE);
+		return NULL;
+	}
+
+	if (type == V4L2_CTRL_TYPE_BUTTON)
+		flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
+	else if (type == V4L2_CTRL_TYPE_CTRL_CLASS)
+		flags |= V4L2_CTRL_FLAG_READ_ONLY;
+	else if (type == V4L2_CTRL_TYPE_STRING)
+		sz_extra += 2 * (max + 1);
+
+	ctrl = kzalloc(sizeof(*ctrl) + sz_extra, GFP_KERNEL);
+	if (ctrl == NULL) {
+		handler_set_err(hdl, -ENOMEM);
+		return NULL;
+	}
+
+	INIT_LIST_HEAD(&ctrl->node);
+	ctrl->handler = hdl;
+	ctrl->ops = ops;
+	ctrl->id = id;
+	ctrl->name = name;
+	ctrl->type = type;
+	ctrl->flags = flags;
+	ctrl->minimum = min;
+	ctrl->maximum = max;
+	ctrl->step = step;
+	ctrl->qmenu = qmenu;
+	ctrl->priv = priv;
+	ctrl->cur.val = ctrl->val = ctrl->default_value = def;
+	if (!ops || !ops->init)
+		ctrl->initialized = 1;
+
+	if (ctrl->type == V4L2_CTRL_TYPE_STRING) {
+		ctrl->cur.string = (char *)&ctrl[1] + sz_extra - (max + 1);
+		ctrl->string = (char *)&ctrl[1] + sz_extra - 2 * (max + 1);
+		if (ctrl->minimum)
+			memset(ctrl->cur.string, ' ', ctrl->minimum);
+	}
+	if (handler_new_ref(hdl, ctrl)) {
+		kfree(ctrl);
+		return NULL;
+	}
+	mutex_lock(&hdl->lock);
+	list_add_tail(&ctrl->node, &hdl->ctrls);
+	mutex_unlock(&hdl->lock);
+	return ctrl;
+}
+
+struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
+			const struct v4l2_ctrl_config *cfg, void *priv)
+{
+	bool is_menu = (cfg->type == V4L2_CTRL_TYPE_MENU);
+
+	if (is_menu)
+		WARN_ON(cfg->step);
+	else
+		WARN_ON(cfg->menu_skip_mask);
+
+	return v4l2_ctrl_new(hdl, cfg->ops, cfg->id, cfg->name,
+			cfg->type, cfg->min, cfg->max,
+			is_menu ? cfg->menu_skip_mask : cfg->step,
+			cfg->def, cfg->flags, cfg->qmenu, priv);
+}
+EXPORT_SYMBOL(v4l2_ctrl_new_custom);
+
+/* Helper function for standard controls */
+struct v4l2_ctrl *v4l2_ctrl_new_std(struct v4l2_ctrl_handler *hdl,
+			const struct v4l2_ctrl_ops *ops,
+			u32 id, s32 min, s32 max, u32 step, s32 def)
+{
+	const char *name;
+	enum v4l2_ctrl_type type;
+	u32 flags;
+	const char **qmenu = v4l2_ctrl_get_menu(id);
+
+	v4l2_ctrl_fill(id, &name, &type, &min, &max, &step, &def, &flags);
+	return v4l2_ctrl_new(hdl, ops, id, name, type,
+				    min, max, step, def, flags, qmenu, NULL);
+}
+EXPORT_SYMBOL(v4l2_ctrl_new_std);
+
+/* Helper function for standard menu controls */
+struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
+			const struct v4l2_ctrl_ops *ops,
+			u32 id, s32 mask, s32 def)
+{
+	const char **menu = v4l2_ctrl_get_menu(id);
+	s32 items = -1;
+
+	if (menu)
+		while (*menu++)
+			items++;
+	return v4l2_ctrl_new_std(hdl, ops, id, 0, items, mask, def);
+}
+EXPORT_SYMBOL(v4l2_ctrl_new_std_menu);
+
+/* Add a control from another handler to this handler */
+struct v4l2_ctrl *v4l2_ctrl_add_ctrl(struct v4l2_ctrl_handler *hdl,
+					  struct v4l2_ctrl *ctrl)
+{
+	if (hdl == NULL || hdl->error)
+		return NULL;
+	if (ctrl == NULL) {
+		handler_set_err(hdl, -EINVAL);
+		return NULL;
+	}
+	if (ctrl->handler == hdl)
+		return ctrl;
+	return handler_new_ref(hdl, ctrl) ? NULL : ctrl;
+}
+EXPORT_SYMBOL(v4l2_ctrl_add_ctrl);
+
+/* Add the controls from another handler to our own. */
+int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
+			  struct v4l2_ctrl_handler *add)
+{
+	struct v4l2_ctrl *ctrl;
+	int ret = 0;
+
+	/* Do nothing if either handler is NULL or if they are the same */
+	if (!hdl || !add || hdl == add)
+		return 0;
+	if (hdl->error)
+		return hdl->error;
+	mutex_lock(&add->lock);
+	list_for_each_entry(ctrl, &add->ctrls, node) {
+		/* Skip handler-private controls. */
+		if (ctrl->is_private)
+			continue;
+		ret = handler_new_ref(hdl, ctrl);
+		if (ret)
+			break;
+	}
+	mutex_unlock(&add->lock);
+	return ret;
+}
+EXPORT_SYMBOL(v4l2_ctrl_add_handler);
+
+/* Cluster controls */
+void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
+{
+	int i;
+
+	/* The first control is the master control and it must not be NULL */
+	BUG_ON(controls[0] == NULL);
+
+	for (i = 0; i < ncontrols; i++) {
+		if (controls[i]) {
+			controls[i]->cluster = controls;
+			controls[i]->ncontrols = ncontrols;
+		}
+	}
+}
+EXPORT_SYMBOL(v4l2_ctrl_cluster);
+
+/* Activate/deactivate a control. */
+void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active)
+{
+	if (ctrl && ctrl->initialized) {
+		if (active)
+			ctrl->flags &= ~V4L2_CTRL_FLAG_INACTIVE;
+		else
+			ctrl->flags |= V4L2_CTRL_FLAG_INACTIVE;
+	}
+}
+EXPORT_SYMBOL(v4l2_ctrl_activate);
+
+/* Grab/ungrab a control.
+   Typically used when streaming starts and you want to lock controls,
+   preventing the user from changing them.
+
+   Just call this and the framework will block any attempts to change
+   these controls. */
+void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed)
+{
+	if (ctrl && ctrl->initialized) {
+		if (grabbed)
+			ctrl->flags |= V4L2_CTRL_FLAG_GRABBED;
+		else
+			ctrl->flags &= ~V4L2_CTRL_FLAG_GRABBED;
+		v4l2_ctrl_unlock(ctrl);
+	}
+}
+EXPORT_SYMBOL(v4l2_ctrl_grab);
+
+/* Log the control name and value */
+static void log_ctrl(const struct v4l2_ctrl *ctrl,
+		     const char *prefix, const char *colon)
+{
+	int fl_inact = ctrl->flags & V4L2_CTRL_FLAG_INACTIVE;
+	int fl_grabbed = ctrl->flags & V4L2_CTRL_FLAG_GRABBED;
+
+	if (ctrl->flags & (V4L2_CTRL_FLAG_DISABLED | V4L2_CTRL_FLAG_WRITE_ONLY))
+		return;
+	if (ctrl->type == V4L2_CTRL_TYPE_CTRL_CLASS)
+		return;
+
+	printk(KERN_INFO "%s%s%s: ", prefix, colon, ctrl->name);
+
+	switch (ctrl->type) {
+	case V4L2_CTRL_TYPE_INTEGER:
+		printk(KERN_CONT "%d", ctrl->cur.val);
+		break;
+	case V4L2_CTRL_TYPE_BOOLEAN:
+		printk(KERN_CONT "%s", ctrl->cur.val ? "true" : "false");
+		break;
+	case V4L2_CTRL_TYPE_MENU:
+		printk(KERN_CONT "%s", ctrl->qmenu[ctrl->cur.val]);
+		break;
+	case V4L2_CTRL_TYPE_INTEGER64:
+		printk(KERN_CONT "%lld", ctrl->cur.val64);
+		break;
+	case V4L2_CTRL_TYPE_STRING:
+		printk(KERN_CONT "%s", ctrl->cur.string);
+		break;
+	default:
+		printk(KERN_CONT "unknown type %d", ctrl->type);
+		break;
+	}
+	if (fl_inact && fl_grabbed)
+		printk(KERN_CONT " (inactive, grabbed)\n");
+	else if (fl_inact)
+		printk(KERN_CONT " (inactive)\n");
+	else if (fl_grabbed)
+		printk(KERN_CONT " (grabbed)\n");
+	else
+		printk(KERN_CONT "\n");
+}
+
+/* Log all controls owned by the handler */
+void v4l2_ctrl_handler_log_status(struct v4l2_ctrl_handler *hdl,
+				  const char *prefix)
+{
+	struct v4l2_ctrl *ctrl;
+	const char *colon = "";
+	int len;
+
+	if (hdl == NULL)
+		return;
+	if (prefix == NULL)
+		prefix = "";
+	len = strlen(prefix);
+	if (len && prefix[len - 1] != ' ')
+		colon = ": ";
+	mutex_lock(&hdl->lock);
+	list_for_each_entry(ctrl, &hdl->ctrls, node) {
+		if (!ctrl->initialized)
+			v4l2_ctrl_initialize(ctrl);
+		if (!(ctrl->flags & V4L2_CTRL_FLAG_DISABLED))
+			log_ctrl(ctrl, prefix, colon);
+	}
+	mutex_unlock(&hdl->lock);
+}
+EXPORT_SYMBOL(v4l2_ctrl_handler_log_status);
+
+/* Call s_ctrl for all controls owned by the handler */
+int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl)
+{
+	struct v4l2_ctrl *ctrl;
+	int ret = 0;
+
+	if (hdl == NULL)
+		return 0;
+	mutex_lock(&hdl->lock);
+	list_for_each_entry(ctrl, &hdl->ctrls, node)
+		ctrl->done = false;
+
+	list_for_each_entry(ctrl, &hdl->ctrls, node) {
+		struct v4l2_ctrl *master = ctrl->cluster[0];
+		int i;
+
+		/* Skip if this control was already handled by a cluster. */
+		if (ctrl->done)
+			continue;
+
+		/* Skip if this control is not yet initialized. */
+		if (!ctrl->initialized)
+			continue;
+
+		for (i = 0; i < master->ncontrols; i++)
+			cur_to_new(master->cluster[i]);
+
+		/* Skip button controls and read-only controls. */
+		if (ctrl->type == V4L2_CTRL_TYPE_BUTTON ||
+		    (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY))
+			continue;
+		ret = master->ops->s_ctrl(master);
+		if (ret)
+			break;
+		for (i = 0; i < master->ncontrols; i++)
+			if (master->cluster[i])
+				master->cluster[i]->done = true;
+	}
+	mutex_unlock(&hdl->lock);
+	return ret;
+}
+EXPORT_SYMBOL(v4l2_ctrl_handler_setup);
+
+/* Implement VIDIOC_QUERYCTRL */
+int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc)
+{
+	u32 id = qc->id & V4L2_CTRL_ID_MASK;
+	struct v4l2_ctrl_ref *ref;
+	struct v4l2_ctrl *ctrl;
+
+	if (hdl == NULL)
+		return -EINVAL;
+
+	mutex_lock(&hdl->lock);
+
+	/* Try to find it */
+	ref = find_ref(hdl, id);
+
+	if ((qc->id & V4L2_CTRL_FLAG_NEXT_CTRL) && !list_empty(&hdl->ctrl_refs)) {
+		/* Find the next control with ID > qc->id */
+
+		/* Did we reach the end of the control list? */
+		if (id >= node2id(hdl->ctrl_refs.prev)) {
+			ref = NULL; /* Yes, so there is no next control */
+		} else if (ref) {
+			/* We found a control with the given ID, so just get
+			   the next one in the list. */
+			ref = list_entry(ref->node.next, typeof(*ref), node);
+		} else {
+			/* No control with the given ID exists, so start
+			   searching for the next largest ID. We know there
+			   is one, otherwise the first 'if' above would have
+			   been true. */
+			list_for_each_entry(ref, &hdl->ctrl_refs, node)
+				if (id < ref->ctrl->id)
+					break;
+		}
+	}
+	if (ref && !ref->ctrl->initialized)
+		v4l2_ctrl_initialize(ref->ctrl);
+	mutex_unlock(&hdl->lock);
+	if (!ref)
+		return -EINVAL;
+
+	ctrl = ref->ctrl;
+	memset(qc, 0, sizeof(*qc));
+	qc->id = ctrl->id;
+	strlcpy(qc->name, ctrl->name, sizeof(qc->name));
+	qc->minimum = ctrl->minimum;
+	qc->maximum = ctrl->maximum;
+	qc->default_value = ctrl->default_value;
+	if (qc->type == V4L2_CTRL_TYPE_MENU)
+		qc->step = 1;
+	else
+		qc->step = ctrl->step;
+	qc->flags = ctrl->flags;
+	qc->type = ctrl->type;
+	return 0;
+}
+EXPORT_SYMBOL(v4l2_queryctrl);
+
+int v4l2_subdev_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
+{
+	return v4l2_queryctrl(sd->ctrl_handler, qc);
+}
+EXPORT_SYMBOL(v4l2_subdev_queryctrl);
+
+/* Implement VIDIOC_QUERYMENU */
+int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm)
+{
+	struct v4l2_ctrl *ctrl;
+	u32 i = qm->index;
+
+	ctrl = v4l2_ctrl_find(hdl, qm->id);
+	if (!ctrl)
+		return -EINVAL;
+
+	qm->reserved = 0;
+	/* Sanity checks */
+	if (ctrl->qmenu == NULL ||
+	    i < ctrl->minimum || i > ctrl->maximum)
+		return -EINVAL;
+	/* Use mask to see if this menu item should be skipped */
+	if (ctrl->menu_skip_mask & (1 << i))
+		return -EINVAL;
+	/* Empty menu items should also be skipped */
+	if (ctrl->qmenu[i] == NULL || ctrl->qmenu[i][0] == '\0')
+		return -EINVAL;
+	strlcpy(qm->name, ctrl->qmenu[i], sizeof(qm->name));
+	return 0;
+}
+EXPORT_SYMBOL(v4l2_querymenu);
+
+int v4l2_subdev_querymenu(struct v4l2_subdev *sd, struct v4l2_querymenu *qm)
+{
+	return v4l2_querymenu(sd->ctrl_handler, qm);
+}
+EXPORT_SYMBOL(v4l2_subdev_querymenu);
+
+
+
+/* Some general notes on the atomic requirements of VIDIOC_G/TRY/S_EXT_CTRLS:
+
+   It is not a fully atomic operation, just best-effort only. After all, if
+   multiple controls have to be set through multiple i2c writes (for example)
+   then some initial writes may succeed while others fail. Thus leaving the
+   system in an inconsistent state. The question is how much effort you are
+   willing to spend on trying to make something atomic that really isn't.
+
+   From the point of view of an application the main requirement is that
+   when you call VIDIOC_S_EXT_CTRLS and some values are invalid then an
+   error should be returned without actually affecting any controls.
+
+   If all the values are correct, then it is acceptable to just give up
+   in case of low-level errors.
+
+   It is important though that the application can tell when only a partial
+   configuration was done. The way we do that is through the error_idx field
+   of struct v4l2_ext_controls: if that is equal to the count field then no
+   controls were affected. Otherwise all controls before that index were
+   successful in performing their 'get' or 'set' operation, the control at
+   the given index failed, and you don't know what happened with the controls
+   after the failed one. Since if they were part of a control cluster they
+   could have been successfully processed (if a cluster member was encountered
+   at index < error_idx), they could have failed (if a cluster member was at
+   error_idx), or they may not have been processed yet (if the first cluster
+   member appeared after error_idx).
+
+   It is all fairly theoretical, though. In practice all you can do is to
+   bail out. If error_idx == count, then it is an application bug. If
+   error_idx < count then it is only an application bug if the error code was
+   EBUSY. That usually means that something started streaming just when you
+   tried to set the controls. In all other cases it is a driver/hardware
+   problem and all you can do is to retry or bail out.
+
+   Note that these rules do not apply to VIDIOC_TRY_EXT_CTRLS: since that
+   never modifies controls the error_idx is just set to whatever control
+   has an invalid value.
+ */
+
+/* Prepare for the extended g/s/try functions.
+   Find the controls in the control array and do some basic checks. */
+static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
+			     struct v4l2_ext_controls *cs,
+			     struct ctrl_helper *helpers,
+			     bool try)
+{
+	u32 i;
+
+	for (i = 0; i < cs->count; i++) {
+		struct v4l2_ext_control *c = &cs->controls[i];
+		struct v4l2_ctrl *ctrl;
+		u32 id = c->id & V4L2_CTRL_ID_MASK;
+
+		if (try)
+			cs->error_idx = i;
+
+		if (cs->ctrl_class && V4L2_CTRL_ID2CLASS(id) != cs->ctrl_class)
+			return -EINVAL;
+
+		/* Old-style private controls are not allowed for
+		   extended controls */
+		if (id >= V4L2_CID_PRIVATE_BASE)
+			return -EINVAL;
+		ctrl = v4l2_ctrl_find(hdl, id);
+		if (ctrl == NULL)
+			return -EINVAL;
+		if (ctrl->flags & V4L2_CTRL_FLAG_DISABLED)
+			return -EINVAL;
+
+		helpers[i].ctrl = ctrl;
+		helpers[i].handled = false;
+	}
+	return 0;
+}
+
+typedef int (*cluster_func)(struct v4l2_ext_control *c,
+			    struct v4l2_ctrl *ctrl);
+
+/* Walk over all controls in v4l2_ext_controls belonging to the same cluster
+   and call the provided function. */
+static int cluster_walk(unsigned from,
+			struct v4l2_ext_controls *cs,
+			struct ctrl_helper *helpers,
+			cluster_func f)
+{
+	struct v4l2_ctrl **cluster = helpers[from].ctrl->cluster;
+	int ret = 0;
+	int i;
+
+	/* Find any controls from the same cluster and call the function */
+	for (i = from; !ret && i < cs->count; i++) {
+		struct v4l2_ctrl *ctrl = helpers[i].ctrl;
+
+		if (!helpers[i].handled && ctrl->cluster == cluster)
+			ret = f(&cs->controls[i], ctrl);
+	}
+	return ret;
+}
+
+static void cluster_done(unsigned from,
+			 struct v4l2_ext_controls *cs,
+			 struct ctrl_helper *helpers)
+{
+	struct v4l2_ctrl **cluster = helpers[from].ctrl->cluster;
+	int i;
+
+	/* Find any controls from the same cluster and mark them as handled */
+	for (i = from; i < cs->count; i++)
+		if (helpers[i].ctrl->cluster == cluster)
+			helpers[i].handled = true;
+}
+
+/* Handles the corner case where cs->count == 0. It checks whether the
+   specified control class exists. If that class ID is 0, then it checks
+   whether there are any controls at all. */
+static int class_check(struct v4l2_ctrl_handler *hdl, u32 ctrl_class)
+{
+	if (ctrl_class == 0)
+		return list_empty(&hdl->ctrl_refs) ? -EINVAL : 0;
+	return find_ref_lock(hdl, ctrl_class | 1) ? 0 : -EINVAL;
+}
+
+
+
+/* Get extended controls. Allocates the helpers array if needed. */
+int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs)
+{
+	struct ctrl_helper helper[4];
+	struct ctrl_helper *helpers = helper;
+	int ret;
+	int i;
+
+	cs->error_idx = cs->count;
+	cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
+
+	if (hdl == NULL)
+		return -EINVAL;
+
+	if (cs->count == 0)
+		return class_check(hdl, cs->ctrl_class);
+
+	if (cs->count > ARRAY_SIZE(helper)) {
+		helpers = kmalloc(sizeof(helper[0]) * cs->count, GFP_KERNEL);
+		if (helpers == NULL)
+			return -ENOMEM;
+	}
+
+	ret = prepare_ext_ctrls(hdl, cs, helpers, false);
+
+	for (i = 0; !ret && i < cs->count; i++)
+		if (helpers[i].ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY)
+			ret = -EACCES;
+
+	for (i = 0; !ret && i < cs->count; i++) {
+		struct v4l2_ctrl *ctrl = helpers[i].ctrl;
+		struct v4l2_ctrl *master = ctrl->cluster[0];
+
+		if (helpers[i].handled)
+			continue;
+
+		cs->error_idx = i;
+
+		v4l2_ctrl_lock(master);
+		/* g_volatile_ctrl will update the current control values */
+		if (master->ops->g_volatile_ctrl)
+			ret = master->ops->g_volatile_ctrl(master);
+		/* If OK, then copy the current control values to the caller */
+		if (!ret)
+			ret = cluster_walk(i, cs, helpers, cur_to_user);
+		v4l2_ctrl_unlock(master);
+		cluster_done(i, cs, helpers);
+	}
+
+	if (cs->count > ARRAY_SIZE(helper))
+		kfree(helpers);
+	return ret;
+}
+EXPORT_SYMBOL(v4l2_g_ext_ctrls);
+
+int v4l2_subdev_g_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs)
+{
+	return v4l2_g_ext_ctrls(sd->ctrl_handler, cs);
+}
+EXPORT_SYMBOL(v4l2_subdev_g_ext_ctrls);
+
+/* Helper function to get a single control */
+static int get_ctrl(struct v4l2_ctrl *ctrl, s32 *val)
+{
+	struct v4l2_ctrl *master = ctrl->cluster[0];
+	int ret = 0;
+
+	if (ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY)
+		return -EACCES;
+
+	v4l2_ctrl_lock(master);
+	/* g_volatile_ctrl will update the current control values */
+	if (master->ops->g_volatile_ctrl)
+		ret = master->ops->g_volatile_ctrl(master);
+	*val = ctrl->cur.val;
+	v4l2_ctrl_unlock(master);
+	return ret;
+}
+
+int v4l2_g_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *control)
+{
+	struct v4l2_ctrl *ctrl = v4l2_ctrl_find(hdl, control->id);
+
+	if (ctrl == NULL || !type_is_int(ctrl))
+		return -EINVAL;
+	return get_ctrl(ctrl, &control->value);
+}
+EXPORT_SYMBOL(v4l2_g_ctrl);
+
+int v4l2_subdev_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *control)
+{
+	return v4l2_g_ctrl(sd->ctrl_handler, control);
+}
+EXPORT_SYMBOL(v4l2_subdev_g_ctrl);
+
+s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl)
+{
+	s32 val = 0;
+
+	if (!ctrl->initialized)
+		v4l2_ctrl_initialize(ctrl);
+
+	/* It's a driver bug if this happens. */
+	WARN_ON(!type_is_int(ctrl));
+	get_ctrl(ctrl, &val);
+	return val;
+}
+EXPORT_SYMBOL(v4l2_ctrl_g_ctrl);
+
+
+/* Core function that calls try/s_ctrl and ensures that the new value is
+   copied to the current value on a set.
+   Must be called with ctrl->handler->lock held. */
+static int try_or_set_control_cluster(struct v4l2_ctrl *master, bool set)
+{
+	bool try = !set;
+	int ret = 0;
+	int i;
+
+	/* Go through the cluster and either validate the new value or
+	   (if no new value was set), copy the current value to the new
+	   value, ensuring a consistent view for the control ops when
+	   called. */
+	for (i = 0; !ret && i < master->ncontrols; i++) {
+		struct v4l2_ctrl *ctrl = master->cluster[i];
+
+		if (ctrl == NULL)
+			continue;
+
+		if (ctrl->has_new) {
+			/* Double check this: it may have changed since the
+			   last check in try_or_set_ext_ctrls(). */
+			if (set && (ctrl->flags & V4L2_CTRL_FLAG_GRABBED))
+				return -EBUSY;
+
+			/* Validate if required */
+			if (!set)
+				ret = validate_new(ctrl);
+			continue;
+		}
+		/* No new value was set, so copy the current and force
+		   a call to try_ctrl later, since the values for the cluster
+		   may now have changed and the end result might be invalid. */
+		try = true;
+		cur_to_new(ctrl);
+	}
+
+	/* For larger clusters you have to call try_ctrl again to
+	   verify that the controls are still valid after the
+	   'cur_to_new' above. */
+	if (!ret && master->ops->try_ctrl && try)
+		ret = master->ops->try_ctrl(master);
+
+	/* Don't set if there is no change */
+	if (!ret && set && cluster_changed(master)) {
+		ret = master->ops->s_ctrl(master);
+		/* If OK, then make the new values permanent. */
+		if (!ret)
+			for (i = 0; i < master->ncontrols; i++)
+				new_to_cur(master->cluster[i]);
+	}
+	return ret;
+}
+
+/* Try or set controls. */
+static int try_or_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
+				struct v4l2_ext_controls *cs,
+				struct ctrl_helper *helpers,
+				bool set)
+{
+	unsigned i, j;
+	int ret = 0;
+
+	cs->error_idx = cs->count;
+	for (i = 0; i < cs->count; i++) {
+		struct v4l2_ctrl *ctrl = helpers[i].ctrl;
+
+		if (!set)
+			cs->error_idx = i;
+
+		if (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY)
+			return -EACCES;
+		/* This test is also done in try_set_control_cluster() which
+		   is called in atomic context, so that has the final say,
+		   but it makes sense to do an up-front check as well. Once
+		   an error occurs in try_set_control_cluster() some other
+		   controls may have been set already and we want to do a
+		   best-effort to avoid that. */
+		if (set && (ctrl->flags & V4L2_CTRL_FLAG_GRABBED))
+			return -EBUSY;
+	}
+
+	for (i = 0; !ret && i < cs->count; i++) {
+		struct v4l2_ctrl *ctrl = helpers[i].ctrl;
+		struct v4l2_ctrl *master = ctrl->cluster[0];
+
+		cs->error_idx = i;
+
+		if (helpers[i].handled)
+			continue;
+
+		v4l2_ctrl_lock(ctrl);
+
+		/* Reset the 'has_new' flags of the cluster */
+		for (j = 0; j < master->ncontrols; j++)
+			if (master->cluster[j])
+				master->cluster[j]->has_new = 0;
+
+		/* Copy the new caller-supplied control values.
+		   user_to_new() sets 'has_new' to 1. */
+		ret = cluster_walk(i, cs, helpers, user_to_new);
+
+		if (!ret)
+			ret = try_or_set_control_cluster(master, set);
+
+		/* Copy the new values back to userspace. */
+		if (!ret)
+			ret = cluster_walk(i, cs, helpers, new_to_user);
+
+		v4l2_ctrl_unlock(ctrl);
+		cluster_done(i, cs, helpers);
+	}
+	return ret;
+}
+
+/* Try or try-and-set controls */
+static int try_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
+			     struct v4l2_ext_controls *cs,
+			     bool set)
+{
+	struct ctrl_helper helper[4];
+	struct ctrl_helper *helpers = helper;
+	int ret;
+	int i;
+
+	cs->error_idx = cs->count;
+	cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
+
+	if (hdl == NULL)
+		return -EINVAL;
+
+	if (cs->count == 0)
+		return class_check(hdl, cs->ctrl_class);
+
+	if (cs->count > ARRAY_SIZE(helper)) {
+		helpers = kmalloc(sizeof(helper[0]) * cs->count, GFP_KERNEL);
+		if (!helpers)
+			return -ENOMEM;
+	}
+	ret = prepare_ext_ctrls(hdl, cs, helpers, !set);
+	if (ret)
+		goto free;
+
+	/* First 'try' all controls and abort on error */
+	ret = try_or_set_ext_ctrls(hdl, cs, helpers, false);
+	/* If this is a 'set' operation and the initial 'try' failed,
+	   then set error_idx to count to tell the application that no
+	   controls changed value yet. */
+	if (set)
+		cs->error_idx = cs->count;
+	if (!ret && set) {
+		/* Reset 'handled' state */
+		for (i = 0; i < cs->count; i++)
+			helpers[i].handled = false;
+		ret = try_or_set_ext_ctrls(hdl, cs, helpers, true);
+	}
+
+free:
+	if (cs->count > ARRAY_SIZE(helper))
+		kfree(helpers);
+	return ret;
+}
+
+int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs)
+{
+	return try_set_ext_ctrls(hdl, cs, false);
+}
+EXPORT_SYMBOL(v4l2_try_ext_ctrls);
+
+int v4l2_s_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs)
+{
+	return try_set_ext_ctrls(hdl, cs, true);
+}
+EXPORT_SYMBOL(v4l2_s_ext_ctrls);
+
+int v4l2_subdev_try_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs)
+{
+	return try_set_ext_ctrls(sd->ctrl_handler, cs, false);
+}
+EXPORT_SYMBOL(v4l2_subdev_try_ext_ctrls);
+
+int v4l2_subdev_s_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs)
+{
+	return try_set_ext_ctrls(sd->ctrl_handler, cs, true);
+}
+EXPORT_SYMBOL(v4l2_subdev_s_ext_ctrls);
+
+/* Helper function for VIDIOC_S_CTRL compatibility */
+static int set_ctrl(struct v4l2_ctrl *ctrl, s32 *val)
+{
+	struct v4l2_ctrl *master = ctrl->cluster[0];
+	int ret;
+	int i;
+
+	v4l2_ctrl_lock(ctrl);
+
+	/* Reset the 'has_new' flags of the cluster */
+	for (i = 0; i < master->ncontrols; i++)
+		if (master->cluster[i])
+			master->cluster[i]->has_new = 0;
+
+	ctrl->val = *val;
+	ctrl->has_new = 1;
+	ret = try_or_set_control_cluster(master, false);
+	if (!ret)
+		ret = try_or_set_control_cluster(master, true);
+	*val = ctrl->cur.val;
+	v4l2_ctrl_unlock(ctrl);
+	return ret;
+}
+
+int v4l2_s_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *control)
+{
+	struct v4l2_ctrl *ctrl = v4l2_ctrl_find(hdl, control->id);
+
+	if (ctrl == NULL || !type_is_int(ctrl))
+		return -EINVAL;
+
+	return set_ctrl(ctrl, &control->value);
+}
+EXPORT_SYMBOL(v4l2_s_ctrl);
+
+int v4l2_subdev_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *control)
+{
+	return v4l2_s_ctrl(sd->ctrl_handler, control);
+}
+EXPORT_SYMBOL(v4l2_subdev_s_ctrl);
+
+int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
+{
+	if (!ctrl->initialized)
+		v4l2_ctrl_initialize(ctrl);
+
+	/* It's a driver bug if this happens. */
+	WARN_ON(!type_is_int(ctrl));
+	return set_ctrl(ctrl, &val);
+}
+EXPORT_SYMBOL(v4l2_ctrl_s_ctrl);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
new file mode 100644
index 0000000..1bb3a17
--- /dev/null
+++ b/include/media/v4l2-ctrls.h
@@ -0,0 +1,448 @@
+/*
+    V4L2 controls support header.
+
+    Copyright (C) 2010  Hans Verkuil <hverkuil@xs4all.nl>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef _V4L2_CTRLS_H
+#define _V4L2_CTRLS_H
+
+#include <linux/list.h>
+#include <linux/device.h>
+
+/* forward references */
+struct v4l2_ctrl_handler;
+struct v4l2_ctrl;
+struct video_device;
+struct v4l2_subdev;
+
+/** struct v4l2_ctrl_ops - The control operations that the driver has to provide.
+  * @init:	Initialize struct v4l2_ctrl fields on first use. The following
+  *		fields may be initialized here:
+  *		type, minimum, maximum, default_value, step/menu_skip_mask,
+  *		qmenu, flags, cur and priv.
+  *		Typically only used if one or more of these values only become
+  *		known during runtime or if obtaining these values is an
+  *		expensive operation.
+  * @g_volatile_ctrl: Get a new value for this control. Generally only relevant
+  *		for volatile (and usually read-only) controls such as a control
+  *		that returns the current signal strength which changes
+  *		continuously.
+  *		If not set, then the currently cached value will be returned.
+  * @try_ctrl:	Test whether the control's value is valid. Only relevant when
+  *		the usual min/max/step checks are not sufficient.
+  * @s_ctrl:	Actually set the new control value. s_ctrl is compulsory. The
+  *		ctrl->handler->lock is held when these ops are called, so no
+  *		one else can access controls owned by that handler.
+  */
+struct v4l2_ctrl_ops {
+	void (*init)(struct v4l2_ctrl *ctrl);
+	int (*g_volatile_ctrl)(struct v4l2_ctrl *ctrl);
+	int (*try_ctrl)(struct v4l2_ctrl *ctrl);
+	int (*s_ctrl)(struct v4l2_ctrl *ctrl);
+};
+
+/** struct v4l2_ctrl - The control structure.
+  * @node:	The list node.
+  * @handler:	The handler that owns the control.
+  * @cluster:	Point to start of cluster array.
+  * @ncontrols:	Number of controls in cluster array.
+  * @has_new:	Internal flag: set when there is a valid new value.
+  * @done:	Internal flag: set for each processed control.
+  * @initialized: Internal flag: set if the control was initialized.
+  * @is_private: If set, then this control is private to its handler and it
+  *		will not be added to any other handlers. Drivers can set
+  *		this flag.
+  * @ops:	The control ops.
+  * @id:	The control ID.
+  * @name:	The control name.
+  * @type:	The control type.
+  * @minimum:	The control's minimum value.
+  * @maximum:	The control's maximum value.
+  * @default_value: The control's default value.
+  * @step:	The control's step value for non-menu controls.
+  * @menu_skip_mask: The control's skip mask for menu controls. This makes it
+  *		easy to skip menu items that are not valid. If bit X is set,
+  *		then menu item X is skipped. Of course, this only works for
+  *		menus with <= 32 menu items. There are no menus that come
+  *		close to that number, so this is OK. Should we ever need more,
+  *		then this will have to be extended to a u64 or a bit array.
+  * @qmenu:	A const char * array for all menu items. Array entries that are
+  *		empty strings ("") correspond to non-existing menu items (this
+  *		is in addition to the menu_skip_mask above). The last entry
+  *		must be NULL.
+  * @flags:	The control's flags.
+  * @cur:	The control's current value.
+  * @val:	The control's new s32 value.
+  * @val64:	The control's new s64 value.
+  * @string:	The control's new string value.
+  * @priv:	The control's private pointer. For use by the driver. It is
+  *		untouched by the control framework. Note that this pointer is
+  *		not freed when the control is deleted. Should this be needed
+  *		then a new internal bitfield can be added to tell the framework
+  *		to free this pointer.
+  */
+struct v4l2_ctrl {
+	/* Administrative fields */
+	struct list_head node;
+	struct v4l2_ctrl_handler *handler;
+	struct v4l2_ctrl **cluster;
+	unsigned ncontrols;
+	unsigned int has_new:1;
+	unsigned int done:1;
+	unsigned int initialized:1;
+
+	unsigned int is_private:1;
+
+	const struct v4l2_ctrl_ops *ops;
+	u32 id;
+	const char *name;
+	enum v4l2_ctrl_type type;
+	s32 minimum, maximum, default_value;
+	union {
+		u32 step;
+		u32 menu_skip_mask;
+	};
+	const char **qmenu;
+	u32 flags;
+	union {
+		s32 val;
+		s64 val64;
+		char *string;
+	} cur;
+	union {
+		s32 val;
+		s64 val64;
+		char *string;
+	};
+	void *priv;
+};
+
+/** struct v4l2_ctrl_ref - The control reference.
+  * @node:	List node for the sorted list.
+  * @next:	Single-link list node for the hash.
+  * @ctrl:	The actual control information.
+  *
+  * Each control handler has a list of these refs. The list_head is used to
+  * keep a sorted-by-control-ID list of all controls, while the next pointer
+  * is used to link the control in the hash's bucket.
+  */
+struct v4l2_ctrl_ref {
+	struct list_head node;
+	struct v4l2_ctrl_ref *next;
+	struct v4l2_ctrl *ctrl;
+};
+
+/** struct v4l2_ctrl_handler - The control handler keeps track of all the
+  * controls: both the controls owned by the handler and those inherited
+  * from other handlers.
+  * @lock:	Lock to control access to this handler and its controls.
+  * @ctrls:	The list of controls owned by this handler.
+  * @ctrl_refs:	The list of control references.
+  * @cached:	The last found control reference. It is common that the same
+  *		control is needed multiple times, so this is a simple
+  *		optimization.
+  * @buckets:	Buckets for the hashing. Allows for quick control lookup.
+  * @nr_of_buckets: Total number of buckets in the array.
+  * @error:	The error code of the first failed control addition.
+  */
+struct v4l2_ctrl_handler {
+	struct mutex lock;
+	struct list_head ctrls;
+	struct list_head ctrl_refs;
+	struct v4l2_ctrl_ref *cached;
+	struct v4l2_ctrl_ref **buckets;
+	u16 nr_of_buckets;
+	int error;
+};
+
+/** struct v4l2_ctrl_config - Control configuration structure.
+  * @ops:	The control ops.
+  * @id:	The control ID.
+  * @name:	The control name.
+  * @type:	The control type.
+  * @min:	The control's minimum value.
+  * @max:	The control's maximum value.
+  * @step:	The control's step value for non-menu controls.
+  * @def: 	The control's default value.
+  * @flags:	The control's flags.
+  * @menu_skip_mask: The control's skip mask for menu controls. This makes it
+  *		easy to skip menu items that are not valid. If bit X is set,
+  *		then menu item X is skipped. Of course, this only works for
+  *		menus with <= 32 menu items. There are no menus that come
+  *		close to that number, so this is OK. Should we ever need more,
+  *		then this will have to be extended to a u64 or a bit array.
+  * @qmenu:	A const char * array for all menu items. Array entries that are
+  *		empty strings ("") correspond to non-existing menu items (this
+  *		is in addition to the menu_skip_mask above). The last entry
+  *		must be NULL.
+  */
+struct v4l2_ctrl_config {
+	const struct v4l2_ctrl_ops *ops;
+	u32 id;
+	const char *name;
+	enum v4l2_ctrl_type type;
+	s32 min;
+	s32 max;
+	u32 step;
+	s32 def;
+	u32 flags;
+	u32 menu_skip_mask;
+	const char **qmenu;
+};
+
+/** v4l2_ctrl_fill() - Fill in the control fields based on the control ID.
+  *
+  * This works for all standard V4L2 controls.
+  * For non-standard controls it will only fill in the given arguments
+  * and @name will be NULL.
+  *
+  * This function will overwrite the contents of @name, @type and @flags.
+  * The contents of @min, @max, @step and @def may be modified depending on
+  * the type.
+  *
+  * Do not use in drivers! It is used internally for backwards compatibility
+  * control handling only. Once all drivers are converted to use the new
+  * control framework this function will no longer be exported.
+  */
+void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
+		    s32 *min, s32 *max, s32 *step, s32 *def, u32 *flags);
+
+
+/** v4l2_ctrl_handler_init() - Initialize the control handler.
+  * @hdl:	The control handler.
+  * @nr_of_controls_hint: A hint of how many controls this handler is
+  *		expected to refer to. This is the total number, so including
+  *		any inherited controls. It doesn't have to be precise, but if
+  *		it is way off, then you either waste memory (too many buckets
+  *		are allocated) or the control lookup becomes slower (not enough
+  *		buckets are allocated, so there are more slow list lookups).
+  *		It will always work, though.
+  *
+  * Returns an error if the buckets could not be allocated. This error will
+  * also be stored in @hdl->error.
+  */
+int v4l2_ctrl_handler_init(struct v4l2_ctrl_handler *hdl,
+			   unsigned nr_of_controls_hint);
+
+/** v4l2_ctrl_handler_free() - Free all controls owned by the handler and free
+  * the control list.
+  * @hdl:	The control handler.
+  *
+  * Does nothing if @hdl == NULL.
+  */
+void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl);
+
+/** v4l2_ctrl_handler_setup() - Call the s_ctrl op for all controls belonging
+  * to the handler to initialize the hardware to the current control values.
+  * @hdl:	The control handler.
+  *
+  * Button controls will be skipped, as are read-only controls. Controls that
+  * require initialization (@ops->init is set) are also skipped.
+  *
+  * If @hdl == NULL, then this just returns 0.
+  */
+int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl);
+
+/** v4l2_ctrl_handler_log_status() - Log all controls owned by the handler.
+  * @hdl:	The control handler.
+  * @prefix:	The prefix to use when logging the control values. If the
+  *		prefix does not end with a space, then ": " will be added
+  *		after the prefix. If @prefix == NULL, then no prefix will be
+  *		used.
+  *
+  * For use with VIDIOC_LOG_STATUS.
+  *
+  * Does nothing if @hdl == NULL.
+  */
+void v4l2_ctrl_handler_log_status(struct v4l2_ctrl_handler *hdl,
+				  const char *prefix);
+
+/** v4l2_ctrl_new_custom() - Allocate and initialize a new custom V4L2
+  * control.
+  * @hdl:	The control handler.
+  * @cfg:	The control's configuration data.
+  * @priv:	The control's driver-specific private data.
+  *
+  * If the &v4l2_ctrl struct could not be allocated then NULL is returned
+  * and @hdl->error is set to the error code (if it wasn't set already).
+  */
+struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
+			const struct v4l2_ctrl_config *cfg, void *priv);
+
+/** v4l2_ctrl_new_std() - Allocate and initialize a new standard V4L2 control.
+  * @hdl:	The control handler.
+  * @ops:	The control ops.
+  * @id:	The control ID.
+  * @min:	The control's minimum value.
+  * @max:	The control's maximum value.
+  * @step:	The control's step value for non-menu controls.
+  * @def: 	The control's default value.
+  *
+  * If the &v4l2_ctrl struct could not be allocated, or the control
+  * ID is not known, then NULL is returned and @hdl->error is set to the
+  * appropriate error code (if it wasn't set already).
+  */
+struct v4l2_ctrl *v4l2_ctrl_new_std(struct v4l2_ctrl_handler *hdl,
+			const struct v4l2_ctrl_ops *ops,
+			u32 id, s32 min, s32 max, u32 step, s32 def);
+
+/** v4l2_ctrl_new_std_menu() - Helper function for standard menu controls.
+  * @hdl:	The control handler.
+  * @ops:	The control ops.
+  * @id:	The control ID.
+  * @mask: 	The control's skip mask for menu controls. This makes it
+  *		easy to skip menu items that are not valid. If bit X is set,
+  *		then menu item X is skipped. Of course, this only works for
+  *		menus with <= 32 menu items. There are no menus that come
+  *		close to that number, so this is OK. Should we ever need more,
+  *		then this will have to be extended to a u64 or a bit array.
+  * @def: 	The control's default value.
+  *
+  * Same as v4l2_ctrl_new_std(), but @min is set to 0, @max is calculated based
+  * on the size of the menu and the @mask value determines which menu items
+  * are to be skipped.
+  */
+struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
+			const struct v4l2_ctrl_ops *ops,
+			u32 id, s32 mask, s32 def);
+
+/** v4l2_ctrl_add_ctrl() - Add a control from another handler to this handler.
+  * @hdl:	The control handler.
+  * @ctrl:	The control to add.
+  *
+  * It will return NULL if it was unable to add the control reference.
+  * If the control already belonged to the handler, then it will do
+  * nothing and just return @ctrl.
+  */
+struct v4l2_ctrl *v4l2_ctrl_add_ctrl(struct v4l2_ctrl_handler *hdl,
+					  struct v4l2_ctrl *ctrl);
+
+/** v4l2_ctrl_add_handler() - Add all controls from handler @add to
+  * handler @hdl.
+  * @hdl:	The control handler.
+  * @add:	The control handler whose controls you want to add to
+  *		the @hdl control handler.
+  *
+  * Does nothing if either of the two is a NULL pointer.
+  * In case of an error @hdl->error will be set to the error code (if it
+  * wasn't set already).
+  */
+int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
+			  struct v4l2_ctrl_handler *add);
+
+
+/** v4l2_ctrl_cluster() - Mark all controls in the cluster as belonging to that cluster.
+  * @ncontrols:	The number of controls in this cluster.
+  * @controls: 	The cluster control array of size @ncontrols.
+  */
+void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls);
+
+
+/** v4l2_ctrl_find() - Find a control with the given ID.
+  * @hdl:	The control handler.
+  * @id:	The control ID to find.
+  *
+  * If @hdl == NULL this will return NULL as well. Will lock the handler so
+  * do not use from inside &v4l2_ctrl_ops.
+  */
+struct v4l2_ctrl *v4l2_ctrl_find(struct v4l2_ctrl_handler *hdl, u32 id);
+
+/** v4l2_ctrl_activate() - Make the control active or inactive.
+  * @ctrl:	The control to (de)activate.
+  * @active:	True if the control should become active.
+  *
+  * This sets or clears the V4L2_CTRL_FLAG_INACTIVE flag.
+  * Does nothing if @ctrl == NULL or if the control is uninitialized.
+  * Does not lock the @ctrl->handler. This will usually be called from
+  * within the s_ctrl op.
+  */
+void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active);
+
+/** v4l2_ctrl_grab() - Mark the control as grabbed or not grabbed.
+  * @ctrl:	The control to (de)activate.
+  * @grabbed:	True if the control should become grabbed.
+  *
+  * This sets or clears the V4L2_CTRL_FLAG_GRABBED flag. Does nothing
+  * if @ctrl == NULL or if the control is uninitialized.
+  * Will lock the @ctrl->handler. This will usually be called when starting
+  * or stopping streaming in the driver.
+  */
+void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed);
+
+/** v4l2_ctrl_lock() - Helper function to lock the handler
+  * associated with the control.
+  * @ctrl:	The control to lock.
+  */
+static inline void v4l2_ctrl_lock(struct v4l2_ctrl *ctrl)
+{
+	mutex_lock(&ctrl->handler->lock);
+}
+
+/** v4l2_ctrl_lock() - Helper function to unlock the handler
+  * associated with the control.
+  * @ctrl:	The control to unlock.
+  */
+static inline void v4l2_ctrl_unlock(struct v4l2_ctrl *ctrl)
+{
+	mutex_unlock(&ctrl->handler->lock);
+}
+
+/** v4l2_ctrl_g_ctrl() - Helper function to get the control's value from within a driver.
+  * @ctrl:	The control.
+  *
+  * This returns the control's value safely by going through the control
+  * framework. This function will lock the control's handler, so it cannot be
+  * used from within the &v4l2_ctrl_ops functions.
+  *
+  * This function is for integer type controls only.
+  */
+s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl);
+
+/** v4l2_ctrl_s_ctrl() - Helper function to set the control's value from within a driver.
+  * @ctrl:	The control.
+  * @val:	The new value.
+  *
+  * This set the control's new value safely by going through the control
+  * framework. This function will lock the control's handler, so it cannot be
+  * used from within the &v4l2_ctrl_ops functions.
+  *
+  * This function is for integer type controls only.
+  */
+int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val);
+
+
+/* Helpers for ioctl_ops. If hdl == NULL then they will all return -EINVAL. */
+int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc);
+int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm);
+int v4l2_g_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *ctrl);
+int v4l2_s_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *ctrl);
+int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *c);
+int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *c);
+int v4l2_s_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *c);
+
+/* Helpers for subdevices. If the associated ctrl_handler == NULL then they
+   will all return -EINVAL. */
+int v4l2_subdev_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc);
+int v4l2_subdev_querymenu(struct v4l2_subdev *sd, struct v4l2_querymenu *qm);
+int v4l2_subdev_g_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs);
+int v4l2_subdev_try_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs);
+int v4l2_subdev_s_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs);
+int v4l2_subdev_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
+int v4l2_subdev_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
+
+#endif
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index bebe44b..1efcacb 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -27,6 +27,7 @@
 struct v4l2_ioctl_callbacks;
 struct video_device;
 struct v4l2_device;
+struct v4l2_ctrl_handler;
 
 /* Flag to mark the video_device struct as registered.
    Drivers can clear this flag if they want to block all future
@@ -67,6 +68,9 @@ struct video_device
 	struct device *parent;		/* device parent */
 	struct v4l2_device *v4l2_dev;	/* v4l2_device parent */
 
+	/* Control handler associated with this device node. May be NULL. */
+	struct v4l2_ctrl_handler *ctrl_handler;
+
 	/* device info */
 	char name[32];
 	int vfl_type;
diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index 5d5d550..8bcbd7a 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -32,6 +32,8 @@
 
 #define V4L2_DEVICE_NAME_SIZE (20 + 16)
 
+struct v4l2_ctrl_handler;
+
 struct v4l2_device {
 	/* dev->driver_data points to this struct.
 	   Note: dev might be NULL if there is no parent device
@@ -47,6 +49,8 @@ struct v4l2_device {
 	/* notify callback called by some sub-devices. */
 	void (*notify)(struct v4l2_subdev *sd,
 			unsigned int notification, void *arg);
+	/* The control handler. May be NULL. */
+	struct v4l2_ctrl_handler *ctrl_handler;
 };
 
 /* Initialize v4l2_dev and make dev->driver_data point to v4l2_dev.
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index a888893..927b4a6 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -35,6 +35,7 @@
 #define V4L2_SUBDEV_IR_TX_FIFO_SERVICE_REQ	0x00000001
 
 struct v4l2_device;
+struct v4l2_ctrl_handler;
 struct v4l2_subdev;
 struct tuner_setup;
 
@@ -415,6 +416,8 @@ struct v4l2_subdev {
 	u32 flags;
 	struct v4l2_device *v4l2_dev;
 	const struct v4l2_subdev_ops *ops;
+	/* The control handler of this subdev. May be NULL. */
+	struct v4l2_ctrl_handler *ctrl_handler;
 	/* name must be unique */
 	char name[V4L2_SUBDEV_NAME_SIZE];
 	/* can be used to group similar subdevs, value is driver-specific */
-- 
1.6.4.2

