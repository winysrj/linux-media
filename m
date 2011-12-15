Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3532 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab1LOOPv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 09:15:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 4/8] v4l2-ctrls: add new controls for MPEG decoder devices.
Date: Thu, 15 Dec 2011 15:15:33 +0100
Message-Id: <cb7da361e50401aecdc8d44b764df58a953bf863.1323957539.git.hans.verkuil@cisco.com>
In-Reply-To: <1323958537-7026-1-git-send-email-hverkuil@xs4all.nl>
References: <1323958537-7026-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <26fac753ffa549b2ffdc5fe64a50e0a9637c2b16.1323957539.git.hans.verkuil@cisco.com>
References: <26fac753ffa549b2ffdc5fe64a50e0a9637c2b16.1323957539.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

As discussed during the 2011 V4L-DVB workshop we want to create a proper V4L2
decoder API that replaces the DVBv5 API that has been used until now.

This adds the four controls necessary to be able to switch ivtv over to this
new API.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ctrls.c |   23 +++++++++++++++++++++++
 include/linux/videodev2.h        |   13 +++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 0f415da..f9469e3 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -175,6 +175,15 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"16-bit CRC",
 		NULL
 	};
+	static const char * const mpeg_audio_dec_playback[] = {
+		"Auto",
+		"Stereo",
+		"Left",
+		"Right",
+		"Mono",
+		"Swapped Stereo",
+		NULL
+	};
 	static const char * const mpeg_video_encoding[] = {
 		"MPEG-1",
 		"MPEG-2",
@@ -374,6 +383,9 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return mpeg_audio_emphasis;
 	case V4L2_CID_MPEG_AUDIO_CRC:
 		return mpeg_audio_crc;
+	case V4L2_CID_MPEG_AUDIO_DEC_PLAYBACK:
+	case V4L2_CID_MPEG_AUDIO_DEC_MULTILINGUAL_PLAYBACK:
+		return mpeg_audio_dec_playback;
 	case V4L2_CID_MPEG_VIDEO_ENCODING:
 		return mpeg_video_encoding;
 	case V4L2_CID_MPEG_VIDEO_ASPECT:
@@ -491,6 +503,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_AUDIO_MUTE:		return "Audio Mute";
 	case V4L2_CID_MPEG_AUDIO_AAC_BITRATE:	return "Audio AAC Bitrate";
 	case V4L2_CID_MPEG_AUDIO_AC3_BITRATE:	return "Audio AC-3 Bitrate";
+	case V4L2_CID_MPEG_AUDIO_DEC_PLAYBACK:	return "Audio Playback";
+	case V4L2_CID_MPEG_AUDIO_DEC_MULTILINGUAL_PLAYBACK: return "Audio Multilingual Playback";
 	case V4L2_CID_MPEG_VIDEO_ENCODING:	return "Video Encoding";
 	case V4L2_CID_MPEG_VIDEO_ASPECT:	return "Video Aspect";
 	case V4L2_CID_MPEG_VIDEO_B_FRAMES:	return "Video B Frames";
@@ -545,6 +559,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB:		return "The Number of MB in a Slice";
 	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE:		return "The Slice Partitioning Method";
 	case V4L2_CID_MPEG_VIDEO_VBV_SIZE:			return "VBV Buffer Size";
+	case V4L2_CID_MPEG_VIDEO_DEC_PTS:			return "Video Decoder PTS";
+	case V4L2_CID_MPEG_VIDEO_DEC_FRAME:			return "Video Decoder Frame Count";
 
 	/* CAMERA controls */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -673,6 +689,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_AUDIO_MODE_EXTENSION:
 	case V4L2_CID_MPEG_AUDIO_EMPHASIS:
 	case V4L2_CID_MPEG_AUDIO_CRC:
+	case V4L2_CID_MPEG_AUDIO_DEC_PLAYBACK:
+	case V4L2_CID_MPEG_AUDIO_DEC_MULTILINGUAL_PLAYBACK:
 	case V4L2_CID_MPEG_VIDEO_ENCODING:
 	case V4L2_CID_MPEG_VIDEO_ASPECT:
 	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
@@ -723,6 +741,11 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
 		break;
+	case V4L2_CID_MPEG_VIDEO_DEC_FRAME:
+	case V4L2_CID_MPEG_VIDEO_DEC_PTS:
+		*type = V4L2_CTRL_TYPE_INTEGER64;
+		*flags |= V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_VOLATILE;
+		break;
 	default:
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		break;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 406f7f7..225ac29 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1350,6 +1350,16 @@ enum v4l2_mpeg_audio_ac3_bitrate {
 	V4L2_MPEG_AUDIO_AC3_BITRATE_576K = 17,
 	V4L2_MPEG_AUDIO_AC3_BITRATE_640K = 18,
 };
+#define V4L2_CID_MPEG_AUDIO_DEC_PLAYBACK	(V4L2_CID_MPEG_BASE+112)
+enum v4l2_mpeg_audio_dec_playback {
+	V4L2_MPEG_AUDIO_DEC_PLAYBACK_AUTO	    = 0,
+	V4L2_MPEG_AUDIO_DEC_PLAYBACK_STEREO	    = 1,
+	V4L2_MPEG_AUDIO_DEC_PLAYBACK_LEFT	    = 2,
+	V4L2_MPEG_AUDIO_DEC_PLAYBACK_RIGHT	    = 3,
+	V4L2_MPEG_AUDIO_DEC_PLAYBACK_MONO	    = 4,
+	V4L2_MPEG_AUDIO_DEC_PLAYBACK_SWAPPED_STEREO = 5,
+};
+#define V4L2_CID_MPEG_AUDIO_DEC_MULTILINGUAL_PLAYBACK (V4L2_CID_MPEG_BASE+113)
 
 /*  MPEG video controls specific to multiplexed streams */
 #define V4L2_CID_MPEG_VIDEO_ENCODING 		(V4L2_CID_MPEG_BASE+200)
@@ -1400,6 +1410,9 @@ enum v4l2_mpeg_video_multi_slice_mode {
 	V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES	= 2,
 };
 #define V4L2_CID_MPEG_VIDEO_VBV_SIZE			(V4L2_CID_MPEG_BASE+222)
+#define V4L2_CID_MPEG_VIDEO_DEC_PTS			(V4L2_CID_MPEG_BASE+223)
+#define V4L2_CID_MPEG_VIDEO_DEC_FRAME			(V4L2_CID_MPEG_BASE+224)
+
 #define V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP		(V4L2_CID_MPEG_BASE+300)
 #define V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP		(V4L2_CID_MPEG_BASE+301)
 #define V4L2_CID_MPEG_VIDEO_H263_B_FRAME_QP		(V4L2_CID_MPEG_BASE+302)
-- 
1.7.7.3

