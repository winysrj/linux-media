Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4701 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab0EPNTR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 May 2010 09:19:17 -0400
Message-Id: <a68680ffd1a15f5a71dd83ac82e5e641102263f1.1274015085.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1274015084.git.hverkuil@xs4all.nl>
References: <cover.1274015084.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 16 May 2010 15:20:54 +0200
Subject: [PATCH 02/15] [RFCv2] v4l2-ctrls: reorder 'case' statements to match order in header.
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To make it easier to determine whether all controls are added in v4l2-ctrls.c
the case statements inside the switch are re-ordered to match the header.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/v4l2-ctrls.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 6c97ff0..21bf740 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -266,6 +266,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 {
 	switch (id) {
 	/* USER controls */
+	/* Keep the order of the 'case's the same as in videodev2.h! */
 	case V4L2_CID_USER_CLASS: 		return "User Controls";
 	case V4L2_CID_BRIGHTNESS: 		return "Brightness";
 	case V4L2_CID_CONTRAST: 		return "Contrast";
@@ -296,28 +297,37 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_SHARPNESS:		return "Sharpness";
 	case V4L2_CID_BACKLIGHT_COMPENSATION:	return "Backlight Compensation";
 	case V4L2_CID_CHROMA_AGC:		return "Chroma AGC";
-	case V4L2_CID_CHROMA_GAIN:		return "Chroma Gain";
 	case V4L2_CID_COLOR_KILLER:		return "Color Killer";
 	case V4L2_CID_COLORFX:			return "Color Effects";
 	case V4L2_CID_AUTOBRIGHTNESS:		return "Brightness, Automatic";
 	case V4L2_CID_BAND_STOP_FILTER:		return "Band-Stop Filter";
 	case V4L2_CID_ROTATE:			return "Rotate";
 	case V4L2_CID_BG_COLOR:			return "Background Color";
+	case V4L2_CID_CHROMA_GAIN:		return "Chroma Gain";
 
 	/* MPEG controls */
+	/* Keep the order of the 'case's the same as in videodev2.h! */
 	case V4L2_CID_MPEG_CLASS: 		return "MPEG Encoder Controls";
+	case V4L2_CID_MPEG_STREAM_TYPE: 	return "Stream Type";
+	case V4L2_CID_MPEG_STREAM_PID_PMT: 	return "Stream PMT Program ID";
+	case V4L2_CID_MPEG_STREAM_PID_AUDIO: 	return "Stream Audio Program ID";
+	case V4L2_CID_MPEG_STREAM_PID_VIDEO: 	return "Stream Video Program ID";
+	case V4L2_CID_MPEG_STREAM_PID_PCR: 	return "Stream PCR Program ID";
+	case V4L2_CID_MPEG_STREAM_PES_ID_AUDIO: return "Stream PES Audio ID";
+	case V4L2_CID_MPEG_STREAM_PES_ID_VIDEO: return "Stream PES Video ID";
+	case V4L2_CID_MPEG_STREAM_VBI_FMT:	return "Stream VBI Format";
 	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ: return "Audio Sampling Frequency";
 	case V4L2_CID_MPEG_AUDIO_ENCODING: 	return "Audio Encoding";
 	case V4L2_CID_MPEG_AUDIO_L1_BITRATE: 	return "Audio Layer I Bitrate";
 	case V4L2_CID_MPEG_AUDIO_L2_BITRATE: 	return "Audio Layer II Bitrate";
 	case V4L2_CID_MPEG_AUDIO_L3_BITRATE: 	return "Audio Layer III Bitrate";
-	case V4L2_CID_MPEG_AUDIO_AAC_BITRATE: 	return "Audio AAC Bitrate";
-	case V4L2_CID_MPEG_AUDIO_AC3_BITRATE: 	return "Audio AC-3 Bitrate";
 	case V4L2_CID_MPEG_AUDIO_MODE: 		return "Audio Stereo Mode";
 	case V4L2_CID_MPEG_AUDIO_MODE_EXTENSION: return "Audio Stereo Mode Extension";
 	case V4L2_CID_MPEG_AUDIO_EMPHASIS: 	return "Audio Emphasis";
 	case V4L2_CID_MPEG_AUDIO_CRC: 		return "Audio CRC";
 	case V4L2_CID_MPEG_AUDIO_MUTE: 		return "Audio Mute";
+	case V4L2_CID_MPEG_AUDIO_AAC_BITRATE: 	return "Audio AAC Bitrate";
+	case V4L2_CID_MPEG_AUDIO_AC3_BITRATE: 	return "Audio AC-3 Bitrate";
 	case V4L2_CID_MPEG_VIDEO_ENCODING: 	return "Video Encoding";
 	case V4L2_CID_MPEG_VIDEO_ASPECT: 	return "Video Aspect";
 	case V4L2_CID_MPEG_VIDEO_B_FRAMES: 	return "Video B Frames";
@@ -330,16 +340,9 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_TEMPORAL_DECIMATION: return "Video Temporal Decimation";
 	case V4L2_CID_MPEG_VIDEO_MUTE: 		return "Video Mute";
 	case V4L2_CID_MPEG_VIDEO_MUTE_YUV:	return "Video Mute YUV";
-	case V4L2_CID_MPEG_STREAM_TYPE: 	return "Stream Type";
-	case V4L2_CID_MPEG_STREAM_PID_PMT: 	return "Stream PMT Program ID";
-	case V4L2_CID_MPEG_STREAM_PID_AUDIO: 	return "Stream Audio Program ID";
-	case V4L2_CID_MPEG_STREAM_PID_VIDEO: 	return "Stream Video Program ID";
-	case V4L2_CID_MPEG_STREAM_PID_PCR: 	return "Stream PCR Program ID";
-	case V4L2_CID_MPEG_STREAM_PES_ID_AUDIO: return "Stream PES Audio ID";
-	case V4L2_CID_MPEG_STREAM_PES_ID_VIDEO: return "Stream PES Video ID";
-	case V4L2_CID_MPEG_STREAM_VBI_FMT:	return "Stream VBI Format";
 
 	/* CAMERA controls */
+	/* Keep the order of the 'case's the same as in videodev2.h! */
 	case V4L2_CID_CAMERA_CLASS:		return "Camera Controls";
 	case V4L2_CID_EXPOSURE_AUTO:		return "Auto Exposure";
 	case V4L2_CID_EXPOSURE_ABSOLUTE:	return "Exposure Time, Absolute";
@@ -353,14 +356,15 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_FOCUS_ABSOLUTE:		return "Focus, Absolute";
 	case V4L2_CID_FOCUS_RELATIVE:		return "Focus, Relative";
 	case V4L2_CID_FOCUS_AUTO:		return "Focus, Automatic";
-	case V4L2_CID_IRIS_ABSOLUTE:		return "Iris, Absolute";
-	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
 	case V4L2_CID_ZOOM_ABSOLUTE:		return "Zoom, Absolute";
 	case V4L2_CID_ZOOM_RELATIVE:		return "Zoom, Relative";
 	case V4L2_CID_ZOOM_CONTINUOUS:		return "Zoom, Continuous";
 	case V4L2_CID_PRIVACY:			return "Privacy";
+	case V4L2_CID_IRIS_ABSOLUTE:		return "Iris, Absolute";
+	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
 
 	/* FM Radio Modulator control */
+	/* Keep the order of the 'case's the same as in videodev2.h! */
 	case V4L2_CID_FM_TX_CLASS:		return "FM Radio Modulator Controls";
 	case V4L2_CID_RDS_TX_DEVIATION:		return "RDS Signal Deviation";
 	case V4L2_CID_RDS_TX_PI:		return "RDS Program ID";
-- 
1.6.4.2

