Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:10535 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab2CBCSZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2012 21:18:25 -0500
Received: from epcpsbgm2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0M08009KHJNOCED0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 02 Mar 2012 11:18:22 +0900 (KST)
Received: from jtppark ([12.23.118.214])
 by mmp2.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0M08003C4JQMFZ20@mmp2.samsung.com>
 for linux-media@vger.kernel.org; Fri, 02 Mar 2012 11:18:22 +0900 (KST)
Reply-to: jtp.park@samsung.com
From: Jeongtae Park <jtp.park@samsung.com>
To: linux-media@vger.kernel.org, 'Kamil Debski' <k.debski@samsung.com>
Cc: janghyuck.kim@samsung.com, jaeryul.oh@samsung.com,
	'Marek Szyprowski' <m.szyprowski@samsung.com>
Subject: [PATCH 2/3] v4l2-ctrl: add codec controls support to the control
 framework
Date: Fri, 02 Mar 2012 11:18:22 +0900
Message-id: <007201ccf81a$bdf63850$39e2a8f0$%park@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the codec controls to the v4l2 control framework.

Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/video/v4l2-ctrls.c |   41 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 40 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 9091172..1561483 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -361,6 +361,25 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"External",
 		NULL,
 	};
+	static const char * const h264_sei_fp_arrangement_type[] = {
+		"Checkerboard",
+		"Column Interleaved",
+		"Row Interleaved",
+		"Side By Side",
+		"Top And Bottom",
+		"Temporal Interleaved",
+		NULL,
+	};
+	static const char * const h264_fmo_map_type[] = {
+		"Interleaved Slices",
+		"Scattered Slices",
+		"Foreground with Left Over",
+		"Box Out",
+		"Raster Scan",
+		"Wipe Scan",
+		"Explicit",
+		NULL,
+	};
 
 	switch (id) {
 	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
@@ -426,6 +445,10 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return mpeg_mpeg4_level;
 	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
 		return mpeg4_profile;
+	case V4L2_CID_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE:
+		return h264_sei_fp_arrangement_type;
+	case V4L2_CID_MPEG_VIDEO_H264_FMO_MAP_TYPE:
+		return h264_fmo_map_type;
 	default:
 		return NULL;
 	}
@@ -548,6 +571,21 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_H264_VUI_EXT_SAR_WIDTH:	return "Horizontal Size of SAR";
 	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE:		return "Aspect Ratio VUI Enable";
 	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC:		return "VUI Aspect Ratio IDC";
+	case V4L2_CID_MPEG_VIDEO_H264_SEI_FRAME_PACKING:	return "SEI Frame Packing";
+	case V4L2_CID_MPEG_VIDEO_H264_SEI_FP_CURRENT_FRAME_0:	return "Frame Packing Current Frame";
+	case V4L2_CID_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE:	return "Frame Packing Arrangement Type";
+	case V4L2_CID_MPEG_VIDEO_H264_FMO:			return "Flexible Macroblock Order";
+	case V4L2_CID_MPEG_VIDEO_H264_FMO_MAP_TYPE:		return "FMO Map Type";
+	case V4L2_CID_MPEG_VIDEO_H264_FMO_SLICE_GROUP:		return "FMO Slice Group";
+	case V4L2_CID_MPEG_VIDEO_H264_FMO_CHANGE_DIRECTION:	return "FMO Change Direction";
+	case V4L2_CID_MPEG_VIDEO_H264_FMO_CHANGE_RATE:		return "FMO Change Rate";
+	case V4L2_CID_MPEG_VIDEO_H264_FMO_RUN_LENGTH:		return "FMO Run Length";
+	case V4L2_CID_MPEG_VIDEO_H264_ASO:			return "Arbitrary Slice Order";
+	case V4L2_CID_MPEG_VIDEO_H264_ASO_SLICE_ORDER:		return "ASO Slice Order";
+	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING:	return "Hierarchical Coding";
+	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_TYPE:	return "Hierarchical Coding Type";
+	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER: return "Hierarchical Coding Layer";
+	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP: return "Hierarchical Coding Layer QP value";
 	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:		return "MPEG4 I-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:		return "MPEG4 P-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP:		return "MPEG4 B-Frame QP Value";
@@ -556,12 +594,13 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:			return "MPEG4 Level";
 	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:			return "MPEG4 Profile";
 	case V4L2_CID_MPEG_VIDEO_MPEG4_QPEL:			return "Quarter Pixel Search Enable";
-	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES:		return "Maximum Bytes in a Slice";
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BITS:		return "Maximum Bits in a Slice";
 	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB:		return "Number of MBs in a Slice";
 	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE:		return "Slice Partitioning Method";
 	case V4L2_CID_MPEG_VIDEO_VBV_SIZE:			return "VBV Buffer Size";
 	case V4L2_CID_MPEG_VIDEO_DEC_PTS:			return "Video Decoder PTS";
 	case V4L2_CID_MPEG_VIDEO_DEC_FRAME:			return "Video Decoder Frame Count";
+	case V4L2_CID_MPEG_VIDEO_VBV_DELAY:			return "VBV Buffer Initial Delay";
 
 	/* CAMERA controls */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
-- 
1.7.1


