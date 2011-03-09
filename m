Return-path: <mchehab@pedra>
Received: from ganesha.gnumonks.org ([213.95.27.120]:52708 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329Ab1CINoy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 08:44:54 -0500
From: Jeongtae Park <jtp.park@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, jaeryul.oh@samsung.com,
	kgene.kim@samsung.com, ben-linux@fluff.org,
	jonghun.han@samsung.com, Jeongtae Park <jtp.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH v2 1/8] media: Changes in include/linux/videodev2.h for MFC 5.1
Date: Wed,  9 Mar 2011 22:16:00 +0900
Message-Id: <1299676567-14194-2-git-send-email-jtp.park@samsung.com>
In-Reply-To: <1299676567-14194-1-git-send-email-jtp.park@samsung.com>
References: <1299676567-14194-1-git-send-email-jtp.park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add V4L2_CTRL_CLASS_CODEC and adds controls used by MFC 5.1 driver

Reviewed-by: Peter Oh <jaeryul.oh@samsung.com>
Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>
---
 include/linux/videodev2.h |  158 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 158 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index a94c4d5..37ed969 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -369,6 +369,19 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_DV       v4l2_fourcc('d', 'v', 's', 'd') /* 1394          */
 #define V4L2_PIX_FMT_MPEG     v4l2_fourcc('M', 'P', 'E', 'G') /* MPEG-1/2/4    */
 
+#define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264          */
+#define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263          */
+#define V4L2_PIX_FMT_MPEG12   v4l2_fourcc('M', 'P', '1', '2') /* MPEG-1/2      */
+#define V4L2_PIX_FMT_MPEG4    v4l2_fourcc('M', 'P', 'G', '4') /* MPEG-4        */
+#define V4L2_PIX_FMT_DIVX     v4l2_fourcc('D', 'I', 'V', 'X') /* DivX          */
+#define V4L2_PIX_FMT_DIVX3    v4l2_fourcc('D', 'I', 'V', '3') /* DivX 3.11     */
+#define V4L2_PIX_FMT_DIVX4    v4l2_fourcc('D', 'I', 'V', '4') /* DivX 4.x      */
+#define V4L2_PIX_FMT_DIVX500  v4l2_fourcc('D', 'X', '5', '2') /* DivX 5.0, 5.01, 5.02 */
+#define V4L2_PIX_FMT_DIVX503  v4l2_fourcc('D', 'X', '5', '3') /* DivX 5.03 ~   */
+#define V4L2_PIX_FMT_XVID     v4l2_fourcc('X', 'V', 'I', 'D') /* XviD          */
+#define V4L2_PIX_FMT_VC1      v4l2_fourcc('V', 'C', '1', 'A') /* VC-1          */
+#define V4L2_PIX_FMT_VC1_RCV  v4l2_fourcc('V', 'C', '1', 'R') /* VC-1 RCV      */
+
 /*  Vendor-specific formats   */
 #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
 #define V4L2_PIX_FMT_WNVA     v4l2_fourcc('W', 'N', 'V', 'A') /* Winnov hw compress */
@@ -1016,6 +1029,7 @@ struct v4l2_ext_controls {
 #define V4L2_CTRL_CLASS_MPEG 0x00990000	/* MPEG-compression controls */
 #define V4L2_CTRL_CLASS_CAMERA 0x009a0000	/* Camera class controls */
 #define V4L2_CTRL_CLASS_FM_TX 0x009b0000	/* FM Modulator control class */
+#define V4L2_CTRL_CLASS_CODEC 0x009c0000	/* Codec control class */
 
 #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
 #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
@@ -1349,6 +1363,150 @@ enum v4l2_mpeg_cx2341x_video_median_filter_type {
 #define V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_MEDIAN_FILTER_TOP 	(V4L2_CID_MPEG_CX2341X_BASE+10)
 #define V4L2_CID_MPEG_CX2341X_STREAM_INSERT_NAV_PACKETS 	(V4L2_CID_MPEG_CX2341X_BASE+11)
 
+/*  Codec class control IDs */
+#define V4L2_CID_CODEC_BASE			(V4L2_CTRL_CLASS_CODEC | 0x900)
+#define V4L2_CID_CODEC_CLASS			(V4L2_CTRL_CLASS_CODEC | 1)
+
+/*  For both decoding and encoding */
+#define V4L2_CID_CODEC_LOOP_FILTER_H264		(V4L2_CID_CODEC_BASE+0)
+enum v4l2_cid_codec_loop_filter_h264 {
+	V4L2_CID_CODEC_LOOP_FILTER_H264_ENABLE = 0,
+	V4L2_CID_CODEC_LOOP_FILTER_H264_DISABLE = 1,
+	V4L2_CID_CODEC_LOOP_FILTER_H264_DISABLE_AT_BOUNDARY = 2,
+};
+
+/*  For decoding */
+#define V4L2_CID_CODEC_LOOP_FILTER_MPEG4_ENABLE	(V4L2_CID_CODEC_BASE+100)
+#define V4L2_CID_CODEC_DISPLAY_DELAY		(V4L2_CID_CODEC_BASE+101)
+#define V4L2_CID_CODEC_REQ_NUM_BUFS		(V4L2_CID_CODEC_BASE+102)
+#define V4L2_CID_CODEC_SLICE_INTERFACE		(V4L2_CID_CODEC_BASE+103)
+#define V4L2_CID_CODEC_PACKED_PB		(V4L2_CID_CODEC_BASE+104)
+#define V4L2_CID_CODEC_FRAME_TAG		(V4L2_CID_CODEC_BASE+105)
+
+/*  For encoding */
+/* common */
+enum v4l2_codec_switch {
+	V4L2_CODEC_SW_DISABLE	= 0,
+	V4L2_CODEC_SW_ENABLE	= 1,
+};
+enum v4l2_codec_switch_inv {
+	V4L2_CODEC_SW_INV_ENABLE	= 0,
+	V4L2_CODEC_SW_INV_DISABLE	= 1,
+};
+#define V4L2_CID_CODEC_GOP_SIZE			(V4L2_CID_CODEC_BASE+200)
+#define V4L2_CID_CODEC_MULTI_SLICE_MODE		(V4L2_CID_CODEC_BASE+201)
+enum v4l2_codec_multi_slice_mode {
+	V4L2_CODEC_MULTI_SLICE_MODE_DISABLE		= 0,
+	V4L2_CODEC_MULTI_SLICE_MODE_MACROBLOCK_COUNT	= 1,
+	V4L2_CODEC_MULTI_SLICE_MODE_BIT_COUNT		= 3,
+};
+#define V4L2_CID_CODEC_MULTI_SLICE_MB		(V4L2_CID_CODEC_BASE+202)
+#define V4L2_CID_CODEC_MULTI_SLICE_BIT		(V4L2_CID_CODEC_BASE+203)
+#define V4L2_CID_CODEC_INTRA_REFRESH_MB		(V4L2_CID_CODEC_BASE+204)
+#define V4L2_CID_CODEC_PAD_CTRL_ENABLE		(V4L2_CID_CODEC_BASE+205)
+#define V4L2_CID_CODEC_PAD_LUMA_VALUE		(V4L2_CID_CODEC_BASE+206)
+#define V4L2_CID_CODEC_PAD_CB_VALUE		(V4L2_CID_CODEC_BASE+207)
+#define V4L2_CID_CODEC_PAD_CR_VALUE		(V4L2_CID_CODEC_BASE+208)
+#define V4L2_CID_CODEC_RC_FRAME_ENABLE		(V4L2_CID_CODEC_BASE+209)
+#define V4L2_CID_CODEC_RC_BIT_RATE		(V4L2_CID_CODEC_BASE+210)
+#define V4L2_CID_CODEC_RC_REACTION_COEFF	(V4L2_CID_CODEC_BASE+211)
+#define V4L2_CID_CODEC_STREAM_SIZE		(V4L2_CID_CODEC_BASE+212)
+#define V4L2_CID_CODEC_FRAME_COUNT		(V4L2_CID_CODEC_BASE+213)
+#define V4L2_CID_CODEC_FRAME_TYPE		(V4L2_CID_CODEC_BASE+214)
+enum v4l2_codec_frame_type {
+	V4L2_CODEC_FRAME_TYPE_INVALID		= -1,
+	V4L2_CODEC_FRAME_TYPE_NOT_CODED		= 0,
+	V4L2_CODEC_FRAME_TYPE_I_FRAME		= 1,
+	V4L2_CODEC_FRAME_TYPE_P_FRAME		= 2,
+	V4L2_CODEC_FRAME_TYPE_B_FRAME		= 3,
+	V4L2_CODEC_FRAME_TYPE_SKIPPED		= 4,
+	V4L2_CODEC_FRAME_TYPE_OTHERS		= 5,
+};
+#define V4L2_CID_CODEC_FORCE_FRAME_TYPE	(V4L2_CID_CODEC_BASE+215)
+enum v4l2_codec_force_frame_type {
+	V4L2_CODEC_FORCE_FRAME_TYPE_I_FRAME	= 1,
+	V4L2_CODEC_FORCE_FRAME_TYPE_NOT_CODED	= 2,
+};
+#define V4L2_CID_CODEC_VBV_BUF_SIZE		(V4L2_CID_CODEC_BASE+216)
+#define V4L2_CID_CODEC_SEQ_HDR_MODE		(V4L2_CID_CODEC_BASE+217)
+enum v4l2_codec_seq_hdr_mode {
+	V4L2_CODEC_SEQ_HDR_MODE_SEQ		= 0,
+	V4L2_CODEC_SEQ_HDR_MODE_SEQ_FRAME	= 1,
+};
+#define V4L2_CID_CODEC_FRAME_SKIP_MODE	(V4L2_CID_CODEC_BASE+218)
+enum v4l2_codec_frame_skip_mode {
+	V4L2_CODEC_FRAME_SKIP_MODE_DISABLE	= 0,
+	V4L2_CODEC_FRAME_SKIP_MODE_LEVEL	= 1,
+	V4L2_CODEC_FRAME_SKIP_MODE_VBV_BUF_SIZE	= 2,
+};
+#define V4L2_CID_CODEC_RC_FIXED_TARGET_BIT	(V4L2_CID_CODEC_BASE+219)
+
+/* codec specific */
+#define V4L2_CID_CODEC_H264_B_FRAMES		(V4L2_CID_CODEC_BASE+300)
+#define V4L2_CID_CODEC_H264_PROFILE		(V4L2_CID_CODEC_BASE+301)
+enum v4l2_codec_h264_profile {
+	V4L2_CODEC_H264_PROFILE_MAIN		= 0,
+	V4L2_CODEC_H264_PROFILE_HIGH		= 1,
+	V4L2_CODEC_H264_PROFILE_BASELINE	= 2,
+};
+#define V4L2_CID_CODEC_H264_LEVEL		(V4L2_CID_CODEC_BASE+302)
+#define V4L2_CID_CODEC_H264_INTERLACE		(V4L2_CID_CODEC_BASE+303)
+#define V4L2_CID_CODEC_H264_LOOP_FILTER_MODE	(V4L2_CID_CODEC_BASE+304)
+enum v4l2_codec_h264_loop_filter {
+	V4L2_CODEC_H264_LOOP_FILTER_ENABLE		= 0,
+	V4L2_CODEC_H264_LOOP_FILTER_DISABLE		= 1,
+	V4L2_CODEC_H264_LOOP_FILTER_DISABLE_AT_BOUNDARY	= 2,
+};
+#define V4L2_CID_CODEC_H264_LOOP_FILTER_ALPHA	(V4L2_CID_CODEC_BASE+305)
+#define V4L2_CID_CODEC_H264_LOOP_FILTER_BETA	(V4L2_CID_CODEC_BASE+306)
+#define V4L2_CID_CODEC_H264_ENTROPY_MODE	(V4L2_CID_CODEC_BASE+307)
+enum v4l2_codec_h264_entropy_mode {
+	V4L2_CODEC_H264_ENTROPY_MODE_CAVLC	= 0,
+	V4L2_CODEC_H264_ENTROPY_MODE_CABAC	= 1,
+};
+#define V4L2_CID_CODEC_H264_MAX_REF_PIC		(V4L2_CID_CODEC_BASE+308)
+#define V4L2_CID_CODEC_H264_NUM_REF_PIC_4P	(V4L2_CID_CODEC_BASE+309)
+#define V4L2_CID_CODEC_H264_8X8_TRANSFORM	(V4L2_CID_CODEC_BASE+310)
+#define V4L2_CID_CODEC_H264_RC_MB_ENABLE	(V4L2_CID_CODEC_BASE+311)
+#define V4L2_CID_CODEC_H264_RC_FRAME_RATE	(V4L2_CID_CODEC_BASE+312)
+#define V4L2_CID_CODEC_H264_RC_FRAME_QP		(V4L2_CID_CODEC_BASE+313)
+#define V4L2_CID_CODEC_H264_RC_MIN_QP		(V4L2_CID_CODEC_BASE+314)
+#define V4L2_CID_CODEC_H264_RC_MAX_QP		(V4L2_CID_CODEC_BASE+315)
+#define V4L2_CID_CODEC_H264_RC_MB_DARK		(V4L2_CID_CODEC_BASE+316)
+#define V4L2_CID_CODEC_H264_RC_MB_SMOOTH	(V4L2_CID_CODEC_BASE+317)
+#define V4L2_CID_CODEC_H264_RC_MB_STATIC	(V4L2_CID_CODEC_BASE+318)
+#define V4L2_CID_CODEC_H264_RC_MB_ACTIVITY	(V4L2_CID_CODEC_BASE+319)
+#define V4L2_CID_CODEC_H264_RC_P_FRAME_QP	(V4L2_CID_CODEC_BASE+320)
+#define V4L2_CID_CODEC_H264_RC_B_FRAME_QP	(V4L2_CID_CODEC_BASE+321)
+#define V4L2_CID_CODEC_H264_AR_VUI_ENABLE	(V4L2_CID_CODEC_BASE+322)
+#define V4L2_CID_CODEC_H264_AR_VUI_IDC		(V4L2_CID_CODEC_BASE+323)
+#define V4L2_CID_CODEC_H264_EXT_SAR_WIDTH	(V4L2_CID_CODEC_BASE+324)
+#define V4L2_CID_CODEC_H264_EXT_SAR_HEIGHT	(V4L2_CID_CODEC_BASE+325)
+#define V4L2_CID_CODEC_H264_OPEN_GOP		(V4L2_CID_CODEC_BASE+326)
+#define V4L2_CID_CODEC_H264_I_PERIOD		(V4L2_CID_CODEC_BASE+327)
+
+#define V4L2_CID_CODEC_MPEG4_B_FRAMES		(V4L2_CID_CODEC_BASE+340)
+#define V4L2_CID_CODEC_MPEG4_PROFILE		(V4L2_CID_CODEC_BASE+341)
+enum v4l2_codec_mpeg4_profile {
+	V4L2_CODEC_MPEG4_PROFILE_SIMPLE		= 0,
+	V4L2_CODEC_MPEG4_PROFILE_ADVANCED_SIMPLE	= 1,
+};
+#define V4L2_CID_CODEC_MPEG4_LEVEL		(V4L2_CID_CODEC_BASE+342)
+#define V4L2_CID_CODEC_MPEG4_RC_FRAME_QP	(V4L2_CID_CODEC_BASE+343)
+#define V4L2_CID_CODEC_MPEG4_RC_MIN_QP		(V4L2_CID_CODEC_BASE+344)
+#define V4L2_CID_CODEC_MPEG4_RC_MAX_QP		(V4L2_CID_CODEC_BASE+345)
+#define V4L2_CID_CODEC_MPEG4_QUARTER_PIXEL	(V4L2_CID_CODEC_BASE+346)
+#define V4L2_CID_CODEC_MPEG4_RC_P_FRAME_QP	(V4L2_CID_CODEC_BASE+347)
+#define V4L2_CID_CODEC_MPEG4_RC_B_FRAME_QP	(V4L2_CID_CODEC_BASE+348)
+#define V4L2_CID_CODEC_MPEG4_VOP_TIME_RES	(V4L2_CID_CODEC_BASE+349)
+#define V4L2_CID_CODEC_MPEG4_VOP_FRM_DELTA	(V4L2_CID_CODEC_BASE+350)
+
+#define V4L2_CID_CODEC_H263_RC_FRAME_RATE	(V4L2_CID_CODEC_BASE+360)
+#define V4L2_CID_CODEC_H263_RC_FRAME_QP		(V4L2_CID_CODEC_BASE+361)
+#define V4L2_CID_CODEC_H263_RC_MIN_QP		(V4L2_CID_CODEC_BASE+362)
+#define V4L2_CID_CODEC_H263_RC_MAX_QP		(V4L2_CID_CODEC_BASE+363)
+#define V4L2_CID_CODEC_H263_RC_P_FRAME_QP	(V4L2_CID_CODEC_BASE+364)
+
 /*  Camera class control IDs */
 #define V4L2_CID_CAMERA_CLASS_BASE 	(V4L2_CTRL_CLASS_CAMERA | 0x900)
 #define V4L2_CID_CAMERA_CLASS 		(V4L2_CTRL_CLASS_CAMERA | 1)
-- 
1.7.1

