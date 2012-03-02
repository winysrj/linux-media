Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:10205 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab2CBCRm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2012 21:17:42 -0500
Received: from epcpsbgm2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0M08009KHJNOCED0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 02 Mar 2012 11:17:41 +0900 (KST)
Received: from jtppark ([12.23.118.214])
 by mmp1.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0M0800EP2JPGVNR0@mmp1.samsung.com>
 for linux-media@vger.kernel.org; Fri, 02 Mar 2012 11:17:40 +0900 (KST)
Reply-to: jtp.park@samsung.com
From: Jeongtae Park <jtp.park@samsung.com>
To: linux-media@vger.kernel.org, 'Kamil Debski' <k.debski@samsung.com>
Cc: janghyuck.kim@samsung.com, jaeryul.oh@samsung.com,
	'Marek Szyprowski' <m.szyprowski@samsung.com>
Subject: [PATCH 1/3] v4l: add contorl definitions for codec devices.
Date: Fri, 02 Mar 2012 11:17:40 +0900
Message-id: <007101ccf81a$a507c610$ef175230$%park@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add control definitions for controls specific to codec devices.

Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>
---
 include/linux/videodev2.h |   51 ++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index b739d7d..a19512a 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -359,7 +359,9 @@ struct v4l2_pix_format {
 
 /* two non contiguous planes - one Y, one Cr + Cb interleaved  */
 #define V4L2_PIX_FMT_NV12M   v4l2_fourcc('N', 'M', '1', '2') /* 12  Y/CbCr 4:2:0  */
+#define V4L2_PIX_FMT_NV21M   v4l2_fourcc('N', 'M', '2', '1') /* 21  Y/CrCb 4:2:0  */
 #define V4L2_PIX_FMT_NV12MT  v4l2_fourcc('T', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 64x32 macroblocks */
+#define V4L2_PIX_FMT_NV12MT_16X16 v4l2_fourcc('V', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 16x16 macroblocks */
 
 /* three non contiguous planes - Y, Cb, Cr */
 #define V4L2_PIX_FMT_YUV420M v4l2_fourcc('Y', 'M', '1', '2') /* 12  YUV420 planar */
@@ -392,6 +394,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_MPEG     v4l2_fourcc('M', 'P', 'E', 'G') /* MPEG-1/2/4 Multiplexed */
 #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264 with start codes */
 #define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') /* H264 without start codes */
+#define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') /* H264 MVC */
 #define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263          */
 #define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-1 ES     */
 #define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-2 ES     */
@@ -399,6 +402,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_XVID     v4l2_fourcc('X', 'V', 'I', 'D') /* Xvid           */
 #define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1', 'G') /* SMPTE 421M Annex G compliant stream */
 #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SMPTE 421M Annex L compliant stream */
+#define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8 */
 
 /*  Vendor-specific formats   */
 #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
@@ -1458,17 +1462,18 @@ enum v4l2_mpeg_video_header_mode {
 };
 #define V4L2_CID_MPEG_VIDEO_MAX_REF_PIC			(V4L2_CID_MPEG_BASE+217)
 #define V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE		(V4L2_CID_MPEG_BASE+218)
-#define V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES	(V4L2_CID_MPEG_BASE+219)
+#define V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BITS	(V4L2_CID_MPEG_BASE+219)
 #define V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB		(V4L2_CID_MPEG_BASE+220)
 #define V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE		(V4L2_CID_MPEG_BASE+221)
 enum v4l2_mpeg_video_multi_slice_mode {
 	V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_SINGLE		= 0,
-	V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB		= 1,
-	V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES	= 2,
+	V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_MB		= 1,
+	V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_BITS	= 2,
 };
 #define V4L2_CID_MPEG_VIDEO_VBV_SIZE			(V4L2_CID_MPEG_BASE+222)
 #define V4L2_CID_MPEG_VIDEO_DEC_PTS			(V4L2_CID_MPEG_BASE+223)
 #define V4L2_CID_MPEG_VIDEO_DEC_FRAME			(V4L2_CID_MPEG_BASE+224)
+#define V4L2_CID_MPEG_VIDEO_VBV_DELAY			(V4L2_CID_MPEG_BASE+225)
 
 #define V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP		(V4L2_CID_MPEG_BASE+300)
 #define V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP		(V4L2_CID_MPEG_BASE+301)
@@ -1559,6 +1564,46 @@ enum v4l2_mpeg_video_h264_vui_sar_idc {
 	V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_2x1		= 16,
 	V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_EXTENDED	= 17,
 };
+#define V4L2_CID_MPEG_VIDEO_H264_SEI_FRAME_PACKING		(V4L2_CID_MPEG_BASE+368)
+#define V4L2_CID_MPEG_VIDEO_H264_SEI_FP_CURRENT_FRAME_0		(V4L2_CID_MPEG_BASE+369)
+#define V4L2_CID_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE	(V4L2_CID_MPEG_BASE+370)
+enum v4l2_mpeg_video_h264_sei_fp_arrangement_type {
+	V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_CHEKERBOARD	= 0,
+	V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_COLUMN		= 1,
+	V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_ROW		= 2,
+	V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_SIDE_BY_SIDE	= 3,
+	V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_TOP_BOTTOM		= 4,
+	V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_TEMPORAL		= 5,
+};
+#define V4L2_CID_MPEG_VIDEO_H264_FMO			(V4L2_CID_MPEG_BASE+371)
+#define V4L2_CID_MPEG_VIDEO_H264_FMO_MAP_TYPE		(V4L2_CID_MPEG_BASE+372)
+enum v4l2_mpeg_video_h264_fmo_map_type {
+	V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_INTERLEAVED_SLICES		= 0,
+	V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_SCATTERED_SLICES		= 1,
+	V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_FOREGROUND_WITH_LEFT_OVER	= 2,
+	V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_BOX_OUT			= 3,
+	V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_RASTER_SCAN			= 4,
+	V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_WIPE_SCAN			= 5,
+	V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_EXPLICIT			= 6,
+};
+#define V4L2_CID_MPEG_VIDEO_H264_FMO_SLICE_GROUP	(V4L2_CID_MPEG_BASE+373)
+#define V4L2_CID_MPEG_VIDEO_H264_FMO_CHANGE_DIRECTION	(V4L2_CID_MPEG_BASE+374)
+enum v4l2_mpeg_video_h264_fmo_change_dir {
+	V4L2_MPEG_VIDEO_H264_FMO_CHANGE_DIR_RIGHT	= 0,
+	V4L2_MPEG_VIDEO_H264_FMO_CHANGE_DIR_LEFT	= 1,
+};
+#define V4L2_CID_MPEG_VIDEO_H264_FMO_CHANGE_RATE	(V4L2_CID_MPEG_BASE+375)
+#define V4L2_CID_MPEG_VIDEO_H264_FMO_RUN_LENGTH		(V4L2_CID_MPEG_BASE+376)
+#define V4L2_CID_MPEG_VIDEO_H264_ASO			(V4L2_CID_MPEG_BASE+377)
+#define V4L2_CID_MPEG_VIDEO_H264_ASO_SLICE_ORDER	(V4L2_CID_MPEG_BASE+378)
+#define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING		(V4L2_CID_MPEG_BASE+379)
+#define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_TYPE	(V4L2_CID_MPEG_BASE+380)
+enum v4l2_mpeg_video_h264_hierarchical_coding_type {
+	V4L2_MPEG_VIDEO_H264_HIERARCHICAL_CODING_B	= 0,
+	V4L2_MPEG_VIDEO_H264_HIERARCHICAL_CODING_P	= 1,
+};
+#define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER	(V4L2_CID_MPEG_BASE+381)
+#define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP	(V4L2_CID_MPEG_BASE+382)
 #define V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP	(V4L2_CID_MPEG_BASE+400)
 #define V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP	(V4L2_CID_MPEG_BASE+401)
 #define V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP	(V4L2_CID_MPEG_BASE+402)
-- 
1.7.1


