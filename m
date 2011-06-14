Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36591 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab1FNQhN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 12:37:13 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LMS00KA9GU06C@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Jun 2011 17:37:12 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LMS00F7EGTZC8@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Jun 2011 17:37:11 +0100 (BST)
Date: Tue, 14 Jun 2011 18:36:55 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 3/4 v9] v4l2-ctrl: add codec controls support to the control
 framework
In-reply-to: <1308069416-24723-1-git-send-email-k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	k.debski@samsung.com, jaeryul.oh@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, jtp.park@samsung.com
Message-id: <1308069416-24723-4-git-send-email-k.debski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1308069416-24723-1-git-send-email-k.debski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add support for the codec controls to the v4l2 control framework.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/v4l2-ctrls.c |  281 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 281 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 2412f08..acc76f5 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -216,6 +216,118 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"75 useconds",
 		NULL,
 	};
+	static const char * const multi_slice[] = {
+		"Single",
+		"Max macroblocks",
+		"Max bits",
+		NULL,
+	};
+	static const char * const force_frame[] = {
+		"Disabled",
+		"I frame",
+		"Not coded",
+		NULL,
+	};
+	static const char * const header_mode[] = {
+		"Separate buffer",
+		"Joined with 1st frame",
+		NULL,
+	};
+	static const char * const frame_skip[] = {
+		"Disabled",
+		"Level limit",
+		"VBV/CPB limit",
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
+	static const char * const mpeg4_profile[] = {
+		"Simple",
+		"Adcanved simple",
+		"Core",
+		"Simple scalable",
+		"Advanced Coding Efficency",
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
+	static const char * const h264_loop_filter[] = {
+		"Enabled",
+		"Disabled",
+		"Disabled at slice boundary",
+		NULL,
+	};
+	static const char * const symbol_mode[] = {
+		"CAVLC",
+		"CABAC",
+		NULL,
+	};
+	static const char * vui_sar_idc[] = {
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
 
 	switch (id) {
 	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
@@ -256,6 +368,28 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return colorfx;
 	case V4L2_CID_TUNE_PREEMPHASIS:
 		return tune_preemphasis;
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE:
+		return multi_slice;
+	case V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE:
+		return force_frame;
+	case V4L2_CID_MPEG_VIDEO_HEADER_MODE:
+		return header_mode;
+	case V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE:
+		return frame_skip;
+	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
+		return h264_profile;
+	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
+		return mpeg_h264_level;
+	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
+		return mpeg_mpeg4_level;
+	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE:
+		return h264_loop_filter;
+	case V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE:
+		return symbol_mode;
+	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
+		return mpeg4_profile;
+	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC:
+		return vui_sar_idc;
 	default:
 		return NULL;
 	}
@@ -389,6 +523,72 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_TUNE_POWER_LEVEL:		return "Tune Power Level";
 	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:	return "Tune Antenna Capacitor";
 
+	case V4L2_CID_MPEG_VIDEO_DECODER_SLICE_INTERFACE:	return "Decoder Slice Interface";
+	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:			return "Minimum number of cap bufs"; 
+	case V4L2_CID_MIN_BUFFERS_FOR_OUTPUT:			return "Minimum number of out bufs"; 
+
+	case V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY:		return "Decoder H264 Display Delay";
+	case V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY_ENABLE:	return "H264 Display Delay Enable";
+	case V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER:			return "Mpeg4 Loop Filter Enable";
+
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE:		return "The slice partitioning method";
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB:		return "The number of MB in a slice";
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES:		return "The maximum bits per slices";
+	case V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB:	return "The number of intra refresh MBs";
+	case V4L2_CID_MPEG_MFC51_VIDEO_PADDING:			return "Padding control enable";
+	case V4L2_CID_MPEG_MFC51_VIDEO_PADDING_YUV:		return "Padding color YUV value";
+	case V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE:		return "Frame level rate control enable";
+	case V4L2_CID_MPEG_MFC51_VIDEO_RC_REACTION_COEFF:	return "Rate control reaction coeff.";
+	case V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE:	return "Force frame type";
+	case V4L2_CID_MPEG_VIDEO_VBV_SIZE:			return "VBV buffer size";
+	case V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE:			return "H264 CPB buffer size";
+	case V4L2_CID_MPEG_VIDEO_HEADER_MODE:			return "Sequence header mode";
+	case V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE:		return "Frame skip enable";
+	case V4L2_CID_MPEG_MFC51_VIDEO_RC_FIXED_TARGET_BIT:	return "Fixed target bit enable";
+	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:			return "H264 profile";
+	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:			return "H264 level";
+	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:			return "MPEG4 level";
+	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE:		return "H264 loop filter mode";
+	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA:	return "H264 loop filter alpha offset";
+	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA:		return "H264 loop filter beta offset";
+	case V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE:		return "H264 entorpy mode";
+	case V4L2_CID_MPEG_VIDEO_MAX_REF_PIC:			return "The max number of ref. picture";
+	case V4L2_CID_MPEG_MFC51_VIDEO_H264_NUM_REF_PIC_FOR_P:	return "The number of ref. picture of P";
+	case V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM:		return "H264 8x8 transform enable";
+	case V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE:			return "H264 MB level rate control";
+
+	case V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP:		return "H263 I-Frame QP value";
+	case V4L2_CID_MPEG_VIDEO_H263_MIN_QP:			return "H263 Minimum QP value";
+	case V4L2_CID_MPEG_VIDEO_H263_MAX_QP:			return "H263 Maximum QP value";
+	case V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP:		return "H263 P frame QP value";
+	case V4L2_CID_MPEG_VIDEO_H263_B_FRAME_QP:		return "H263 B frame QP value";
+
+	case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP:		return "H264 I-Frame QP value";
+	case V4L2_CID_MPEG_VIDEO_H264_MIN_QP:			return "H264 Minimum QP value";
+	case V4L2_CID_MPEG_VIDEO_H264_MAX_QP:			return "H264 Maximum QP value";
+	case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP:		return "H264 P frame QP value";
+	case V4L2_CID_MPEG_VIDEO_H264_B_FRAME_QP:		return "H264 B frame QP value";
+
+	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:		return "MPEG4 I-Frame QP value";
+	case V4L2_CID_MPEG_VIDEO_MPEG4_MIN_QP:			return "MPEG4 Minimum QP value";
+	case V4L2_CID_MPEG_VIDEO_MPEG4_MAX_QP:			return "MPEG4 Maximum QP value";
+	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:		return "MPEG4 P frame QP value";
+	case V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP:		return "MPEG4 B frame QP value";
+
+	case V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_DARK: 	return "H264 dark region adaptive";
+	case V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_SMOOTH: return "H264 smooth region adaptive";
+	case V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_STATIC: return "H264 static region adaptive";
+	case V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_ACTIVITY: return "H264 MB activity adaptive";
+	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE:		return "Aspect ratio VUI enable";
+	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC:		return "VUI aspect ratio IDC";
+	case V4L2_CID_MPEG_VIDEO_H264_VUI_EXT_SAR_WIDTH:	return "Horizontal size of SAR";
+	case V4L2_CID_MPEG_VIDEO_H264_VUI_EXT_SAR_HEIGHT:	return "Vertical size of SAR";
+	case V4L2_CID_MPEG_VIDEO_H264_I_PERIOD:			return "H264 I period";
+	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:			return "MPEG4 profile";
+	case V4L2_CID_MPEG_VIDEO_MPEG4_QPEL:			return "Quarter pixel search enable";
+	case V4L2_CID_MPEG_VIDEO_MPEG4_VOP_TIME_RES:		return "MPEG4 vop time resolution";
+	case V4L2_CID_MPEG_VIDEO_MPEG4_VOP_TIME_INC:		return "MPEG4 frame delta";
+
 	default:
 		return NULL;
 	}
@@ -520,6 +720,87 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
 		break;
 	}
+	switch(id) {
+	case V4L2_CID_MPEG_VIDEO_DECODER_SLICE_INTERFACE:
+		*type = V4L2_CTRL_TYPE_BOOLEAN;
+		break;
+	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
+	case V4L2_CID_MIN_BUFFERS_FOR_OUTPUT:
+		*type = V4L2_CTRL_TYPE_INTEGER;
+		break;
+	case V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY:
+		*type = V4L2_CTRL_TYPE_INTEGER;
+		break;
+	case V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY_ENABLE:
+	case V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER:
+		*type = V4L2_CTRL_TYPE_BOOLEAN;
+		break;
+
+
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE:
+	case V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE:
+	case V4L2_CID_MPEG_VIDEO_HEADER_MODE:
+	case V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE:
+	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
+	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
+	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
+	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE:
+	case V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE:
+	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
+	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC:
+		*type = V4L2_CTRL_TYPE_MENU;
+		break;
+
+	case V4L2_CID_MPEG_MFC51_VIDEO_PADDING:
+	case V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE:
+	case V4L2_CID_MPEG_MFC51_VIDEO_RC_FIXED_TARGET_BIT:
+	case V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM:
+	case V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE:
+	case V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_DARK:
+	case V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_SMOOTH:
+	case V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_STATIC:
+	case V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_ACTIVITY:
+	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE:
+	case V4L2_CID_MPEG_VIDEO_MPEG4_QPEL:
+		*type = V4L2_CTRL_TYPE_BOOLEAN;
+		break;
+
+	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB:
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES:
+	case V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB:
+	case V4L2_CID_MPEG_MFC51_VIDEO_PADDING_YUV:
+	case V4L2_CID_MPEG_MFC51_VIDEO_RC_REACTION_COEFF:
+	case V4L2_CID_MPEG_VIDEO_VBV_SIZE:
+	case V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE:
+	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
+	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA:
+	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA:
+	case V4L2_CID_MPEG_VIDEO_MAX_REF_PIC:
+	case V4L2_CID_MPEG_MFC51_VIDEO_H264_NUM_REF_PIC_FOR_P:
+	case V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP:
+	case V4L2_CID_MPEG_VIDEO_H263_MIN_QP:
+	case V4L2_CID_MPEG_VIDEO_H263_MAX_QP:
+	case V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP:
+	case V4L2_CID_MPEG_VIDEO_H263_B_FRAME_QP:
+	case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP:
+	case V4L2_CID_MPEG_VIDEO_H264_MIN_QP:
+	case V4L2_CID_MPEG_VIDEO_H264_MAX_QP:
+	case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP:
+	case V4L2_CID_MPEG_VIDEO_H264_B_FRAME_QP:
+	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:
+	case V4L2_CID_MPEG_VIDEO_MPEG4_MIN_QP:
+	case V4L2_CID_MPEG_VIDEO_MPEG4_MAX_QP:
+	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:
+	case V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP:
+	case V4L2_CID_MPEG_VIDEO_H264_VUI_EXT_SAR_WIDTH:
+	case V4L2_CID_MPEG_VIDEO_H264_VUI_EXT_SAR_HEIGHT:
+	case V4L2_CID_MPEG_VIDEO_H264_I_PERIOD:
+	case V4L2_CID_MPEG_VIDEO_MPEG4_VOP_TIME_RES:
+	case V4L2_CID_MPEG_VIDEO_MPEG4_VOP_TIME_INC:
+		*type = V4L2_CTRL_TYPE_INTEGER;
+		break;
+	}
 }
 EXPORT_SYMBOL(v4l2_ctrl_fill);
 
-- 
1.6.3.3

