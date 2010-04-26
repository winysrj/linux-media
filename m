Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1334 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab0DZHdj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 03:33:39 -0400
Message-Id: <5f14ea711d1d98ea7fbdfbbc27422e679a9a1f63.1272267137.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1272267136.git.hverkuil@xs4all.nl>
References: <cover.1272267136.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Mon, 26 Apr 2010 09:33:33 +0200
Subject: [PATCH 02/15] [RFC] v4l2-ctrls: reorder 'case' statements to match order in header.
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To make it easier to determine whether all controls are added in v4l2-ctrls.c
the case statements inside the switch are re-ordered to match the header.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/v4l2-ctrls.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 442f0c5..0193b2d 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -259,6 +259,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 {
 	switch (id) {
 	/* USER controls */
+	/* Keep the order of the 'case's the same as in videodev2.h! */
 	case V4L2_CID_USER_CLASS: 		return "User Controls";
 	case V4L2_CID_BRIGHTNESS: 		return "Brightness";
 	case V4L2_CID_CONTRAST: 		return "Contrast";
@@ -289,28 +290,37 @@ const char *v4l2_ctrl_get_name(u32 id)
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
@@ -323,16 +333,9 @@ const char *v4l2_ctrl_get_name(u32 id)
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
@@ -346,14 +349,15 @@ const char *v4l2_ctrl_get_name(u32 id)
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

