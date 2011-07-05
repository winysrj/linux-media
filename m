Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61193 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab1GEL4a (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2011 07:56:30 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LNU00FW8ZU4TD00@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 05 Jul 2011 12:56:28 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNU003MXZU3VF@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 05 Jul 2011 12:56:27 +0100 (BST)
Date: Tue, 05 Jul 2011 13:56:15 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 3/4 v10] v4l2-ctrl: add codec controls support to the control
 framework
In-reply-to: <1309866976-15113-1-git-send-email-k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	k.debski@samsung.com, jaeryul.oh@samsung.com, jtp.park@samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Message-id: <1309866976-15113-4-git-send-email-k.debski@samsung.com>
References: <1309866976-15113-1-git-send-email-k.debski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add support for the codec controls to the v4l2 control framework.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/v4l2-ctrls.c |  197 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 192 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 37a50e5..4e629a0 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -203,7 +203,7 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 	};
 	static const char * const mpeg_stream_vbi_fmt[] = {
 		"No VBI",
-		"Private packet, IVTV format",
+		"Private Packet, IVTV Format",
 		NULL
 	};
 	static const char * const camera_power_line_frequency[] = {
@@ -226,18 +226,118 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Negative",
 		"Emboss",
 		"Sketch",
-		"Sky blue",
-		"Grass green",
-		"Skin whiten",
+		"Sky Blue",
+		"Grass Green",
+		"Skin Whiten",
 		"Vivid",
 		NULL
 	};
 	static const char * const tune_preemphasis[] = {
-		"No preemphasis",
+		"No Preemphasis",
 		"50 useconds",
 		"75 useconds",
 		NULL,
 	};
+	static const char * const header_mode[] = {
+		"Separate Buffer",
+		"Joined With 1st Frame",
+		NULL,
+	};
+	static const char * const multi_slice[] = {
+		"Single",
+		"Max Macroblocks",
+		"Max Bytes",
+		NULL,
+	};
+	static const char * const entropy_mode[] = {
+		"CAVLC",
+		"CABAC",
+		NULL,
+	};
+	static const char * const mpeg_h264_level[] = {
+		"1",
+		"1b",
+		"1.1",
+		"1.2",
+		"1.3",
+		"2",
+		"2.1",
+		"2.2",
+		"3",
+		"3.1",
+		"3.2",
+		"4",
+		"4.1",
+		"4.2",
+		"5",
+		"5.1",
+		NULL,
+	};
+	static const char * const h264_loop_filter[] = {
+		"Enabled",
+		"Disabled",
+		"Disabled at Slice Boundary",
+		NULL,
+	};
+	static const char * const h264_profile[] = {
+		"Baseline",
+		"Constrained Baseline",
+		"Main",
+		"Extended",
+		"High",
+		"High 10",
+		"High 422",
+		"High 444 Predictive",
+		"High 10 Intra",
+		"High 422 Intra",
+		"High 444 Intra",
+		"CAVLC 444 Intra",
+		"Scalable Baseline",
+		"Scalable High",
+		"Scalable High Intra",
+		"Multiview High",
+		NULL,
+	};
+	static const char * const vui_sar_idc[] = {
+		"Unspecified",
+		"1:1",
+		"12:11",
+		"10:11",
+		"16:11",
+		"40:33",
+		"24:11",
+		"20:11",
+		"32:11",
+		"80:33",
+		"18:11",
+		"15:11",
+		"64:33",
+		"160:99",
+		"4:3",
+		"3:2",
+		"2:1",
+		"Extended SAR",
+		NULL,
+	};
+	static const char * const mpeg_mpeg4_level[] = {
+		"0",
+		"0b",
+		"1",
+		"2",
+		"3",
+		"3b",
+		"4",
+		"5",
+		NULL,
+	};
+	static const char * const mpeg4_profile[] = {
+		"Simple",
+		"Adcanved Simple",
+		"Core",
+		"Simple Scalable",
+		"Advanced Coding Efficency",
+		NULL,
+	};
 
 	switch (id) {
 	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
@@ -278,6 +378,24 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return colorfx;
 	case V4L2_CID_TUNE_PREEMPHASIS:
 		return tune_preemphasis;
+	case V4L2_CID_MPEG_VIDEO_HEADER_MODE:
+		return header_mode;
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE:
+		return multi_slice;
+	case V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE:
+		return entropy_mode;
+	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
+		return mpeg_h264_level;
+	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE:
+		return h264_loop_filter;
+	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
+		return h264_profile;
+	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC:
+		return vui_sar_idc;
+	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
+		return mpeg_mpeg4_level;
+	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
+		return mpeg4_profile;
 	default:
 		return NULL;
 	}
@@ -329,6 +447,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_CHROMA_GAIN:		return "Chroma Gain";
 	case V4L2_CID_ILLUMINATORS_1:		return "Illuminator 1";
 	case V4L2_CID_ILLUMINATORS_2:		return "Illuminator 2";
+	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:	return "Minimum Number of Capture Buffers";
+	case V4L2_CID_MIN_BUFFERS_FOR_OUTPUT:	return "Minimum Number of Output Buffers";
 
 	/* MPEG controls */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -365,6 +485,48 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_TEMPORAL_DECIMATION: return "Video Temporal Decimation";
 	case V4L2_CID_MPEG_VIDEO_MUTE:		return "Video Mute";
 	case V4L2_CID_MPEG_VIDEO_MUTE_YUV:	return "Video Mute YUV";
+	case V4L2_CID_MPEG_VIDEO_DECODER_SLICE_INTERFACE:	return "Decoder Slice Interface";
+	case V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER:	return "MPEG4 Loop Filter Enable";
+	case V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB:	return "The Number of Intra Refresh MBs";
+	case V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE:		return "Frame Level Rate Control Enable";
+	case V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE:			return "H264 MB Level Rate Control";
+	case V4L2_CID_MPEG_VIDEO_HEADER_MODE:			return "Sequence Header Mode";
+	case V4L2_CID_MPEG_VIDEO_MAX_REF_PIC:			return "The Max Number of Reference Picture";
+	case V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP:		return "H263 I-Frame QP Value";
+	case V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP:		return "H263 P frame QP Value";
+	case V4L2_CID_MPEG_VIDEO_H263_B_FRAME_QP:		return "H263 B frame QP Value";
+	case V4L2_CID_MPEG_VIDEO_H263_MIN_QP:			return "H263 Minimum QP Value";
+	case V4L2_CID_MPEG_VIDEO_H263_MAX_QP:			return "H263 Maximum QP Value";
+	case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP:		return "H264 I-Frame QP Value";
+	case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP:		return "H264 P frame QP Value";
+	case V4L2_CID_MPEG_VIDEO_H264_B_FRAME_QP:		return "H264 B frame QP Value";
+	case V4L2_CID_MPEG_VIDEO_H264_MAX_QP:			return "H264 Maximum QP Value";
+	case V4L2_CID_MPEG_VIDEO_H264_MIN_QP:			return "H264 Minimum QP Value";
+	case V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM:		return "H264 8x8 Transform Enable";
+	case V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE:			return "H264 CPB Buffer Size";
+	case V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE:		return "H264 Entorpy Mode";
+	case V4L2_CID_MPEG_VIDEO_H264_I_PERIOD:			return "H264 I Period";
+	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:			return "H264 Level";
+	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA:	return "H264 Loop Filter Alpha Offset";
+	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA:		return "H264 Loop Filter Beta Offset";
+	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE:		return "H264 Loop Filter Mode";
+	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:			return "H264 Profile";
+	case V4L2_CID_MPEG_VIDEO_H264_VUI_EXT_SAR_HEIGHT:	return "Vertical Size of SAR";
+	case V4L2_CID_MPEG_VIDEO_H264_VUI_EXT_SAR_WIDTH:	return "Horizontal Size of SAR";
+	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE:		return "Aspect Ratio VUI Enable";
+	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC:		return "VUI Aspect Ratio IDC";
+	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:		return "MPEG4 I-Frame QP Value";
+	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:		return "MPEG4 P frame QP Value";
+	case V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP:		return "MPEG4 B frame QP Value";
+	case V4L2_CID_MPEG_VIDEO_MPEG4_MIN_QP:			return "MPEG4 Minimum QP Value";
+	case V4L2_CID_MPEG_VIDEO_MPEG4_MAX_QP:			return "MPEG4 Maximum QP Value";
+	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:			return "MPEG4 Level";
+	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:			return "MPEG4 Profile";
+	case V4L2_CID_MPEG_VIDEO_MPEG4_QPEL:			return "Quarter Pixel Search Enable";
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES:		return "The Maximum Bytes Per Slice";
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB:		return "The Number of MB in a Slice";
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE:		return "The Slice Partitioning Method";
+	case V4L2_CID_MPEG_VIDEO_VBV_SIZE:			return "VBV Buffer Size";
 
 	/* CAMERA controls */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -411,6 +573,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_TUNE_POWER_LEVEL:		return "Tune Power Level";
 	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:	return "Tune Antenna Capacitor";
 
+
 	default:
 		return NULL;
 	}
@@ -445,6 +608,13 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_PILOT_TONE_ENABLED:
 	case V4L2_CID_ILLUMINATORS_1:
 	case V4L2_CID_ILLUMINATORS_2:
+	case V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER:
+	case V4L2_CID_MPEG_VIDEO_DECODER_SLICE_INTERFACE:
+	case V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE:
+	case V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE:
+	case V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM:
+	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE:
+	case V4L2_CID_MPEG_VIDEO_MPEG4_QPEL:
 		*type = V4L2_CTRL_TYPE_BOOLEAN;
 		*min = 0;
 		*max = *step = 1;
@@ -474,6 +644,15 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_EXPOSURE_AUTO:
 	case V4L2_CID_COLORFX:
 	case V4L2_CID_TUNE_PREEMPHASIS:
+	case V4L2_CID_MPEG_VIDEO_HEADER_MODE:
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE:
+	case V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE:
+	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
+	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE:
+	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
+	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC:
+	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
+	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_RDS_TX_PS_NAME:
@@ -496,6 +675,11 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		/* Max is calculated as RGB888 that is 2^24 */
 		*max = 0xFFFFFF;
 		break;
+	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
+	case V4L2_CID_MIN_BUFFERS_FOR_OUTPUT:
+		*type = V4L2_CTRL_TYPE_INTEGER;
+		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
+		break;
 	default:
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		break;
@@ -542,6 +726,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
 		break;
 	}
+
 }
 EXPORT_SYMBOL(v4l2_ctrl_fill);
 
@@ -1865,6 +2050,7 @@ static int validate_ctrls(struct v4l2_ext_controls *cs,
 			return -EBUSY;
 		ret = validate_new(ctrl, &cs->controls[i]);
 		if (ret)
+
 			return ret;
 	}
 	return 0;
@@ -1898,6 +2084,7 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 	if (!ret)
 		ret = validate_ctrls(cs, helpers, set);
 	if (ret && set)
+
 		cs->error_idx = cs->count;
 	for (i = 0; !ret && i < cs->count; i++) {
 		struct v4l2_ctrl *master;
-- 
1.6.3.3

