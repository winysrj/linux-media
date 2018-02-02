Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:25983 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751914AbeBBMuW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Feb 2018 07:50:22 -0500
From: Smitha T Murthy <smitha.t@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        Smitha T Murthy <smitha.t@samsung.com>
Subject: [Patch v8 11/12] [media] s5p-mfc: Add support for HEVC encoder
Date: Fri, 02 Feb 2018 17:55:47 +0530
Message-id: <1517574348-22111-12-git-send-email-smitha.t@samsung.com>
In-reply-to: <1517574348-22111-1-git-send-email-smitha.t@samsung.com>
References: <1517574348-22111-1-git-send-email-smitha.t@samsung.com>
        <CGME20180202125018epcas1p31771ade936e0290e579b8e0805f3f0a1@epcas1p3.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add HEVC encoder support and necessary registers, V4L2 CIDs,
and hevc encoder parameters

Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/s5p-mfc/regs-mfc-v10.h   |  28 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |   1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c |   3 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  54 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    | 536 ++++++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    |   8 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 182 ++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h |   8 +
 8 files changed, 818 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v10.h b/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
index bbfa1cf..fadd913 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
@@ -19,13 +19,35 @@
 #define S5P_FIMV_MFC_STATE_V10				0x7124
 #define S5P_FIMV_D_STATIC_BUFFER_ADDR_V10		0xF570
 #define S5P_FIMV_D_STATIC_BUFFER_SIZE_V10		0xF574
+#define S5P_FIMV_E_NUM_T_LAYER_V10			0xFBAC
+#define S5P_FIMV_E_HIERARCHICAL_QP_LAYER0_V10		0xFBB0
+#define S5P_FIMV_E_HIERARCHICAL_QP_LAYER1_V10		0xFBB4
+#define S5P_FIMV_E_HIERARCHICAL_QP_LAYER2_V10		0xFBB8
+#define S5P_FIMV_E_HIERARCHICAL_QP_LAYER3_V10		0xFBBC
+#define S5P_FIMV_E_HIERARCHICAL_QP_LAYER4_V10		0xFBC0
+#define S5P_FIMV_E_HIERARCHICAL_QP_LAYER5_V10		0xFBC4
+#define S5P_FIMV_E_HIERARCHICAL_QP_LAYER6_V10		0xFBC8
+#define S5P_FIMV_E_HIERARCHICAL_BIT_RATE_LAYER0_V10	0xFD18
+#define S5P_FIMV_E_HIERARCHICAL_BIT_RATE_LAYER1_V10	0xFD1C
+#define S5P_FIMV_E_HIERARCHICAL_BIT_RATE_LAYER2_V10	0xFD20
+#define S5P_FIMV_E_HIERARCHICAL_BIT_RATE_LAYER3_V10	0xFD24
+#define S5P_FIMV_E_HIERARCHICAL_BIT_RATE_LAYER4_V10	0xFD28
+#define S5P_FIMV_E_HIERARCHICAL_BIT_RATE_LAYER5_V10	0xFD2C
+#define S5P_FIMV_E_HIERARCHICAL_BIT_RATE_LAYER6_V10	0xFD30
+#define S5P_FIMV_E_HEVC_OPTIONS_V10			0xFDD4
+#define S5P_FIMV_E_HEVC_REFRESH_PERIOD_V10		0xFDD8
+#define S5P_FIMV_E_HEVC_CHROMA_QP_OFFSET_V10		0xFDDC
+#define S5P_FIMV_E_HEVC_LF_BETA_OFFSET_DIV2_V10		0xFDE0
+#define S5P_FIMV_E_HEVC_LF_TC_OFFSET_DIV2_V10		0xFDE4
+#define S5P_FIMV_E_HEVC_NAL_CONTROL_V10			0xFDE8
 
 /* MFCv10 Context buffer sizes */
 #define MFC_CTX_BUF_SIZE_V10		(30 * SZ_1K)
 #define MFC_H264_DEC_CTX_BUF_SIZE_V10	(2 * SZ_1M)
 #define MFC_OTHER_DEC_CTX_BUF_SIZE_V10	(20 * SZ_1K)
 #define MFC_H264_ENC_CTX_BUF_SIZE_V10	(100 * SZ_1K)
-#define MFC_OTHER_ENC_CTX_BUF_SIZE_V10	(15 * SZ_1K)
+#define MFC_HEVC_ENC_CTX_BUF_SIZE_V10	(30 * SZ_1K)
+#define MFC_OTHER_ENC_CTX_BUF_SIZE_V10  (15 * SZ_1K)
 
 /* MFCv10 variant defines */
 #define MAX_FW_SIZE_V10		(SZ_1M)
@@ -57,5 +79,9 @@
 #define ENC_V100_VP8_ME_SIZE(x, y) \
 	ENC_V100_BASE_SIZE(x, y)
 
+#define ENC_V100_HEVC_ME_SIZE(x, y)	\
+	(((x + 3) * (y + 3) * 32)	\
+	 + ((y * 128) + 1280) * DIV_ROUND_UP(x, 4))
+
 #endif /*_REGS_MFC_V10_H*/
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 461635c..da62f26 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1619,6 +1619,7 @@ static struct s5p_mfc_buf_size_v6 mfc_buf_size_v10 = {
 	.h264_dec_ctx   = MFC_H264_DEC_CTX_BUF_SIZE_V10,
 	.other_dec_ctx  = MFC_OTHER_DEC_CTX_BUF_SIZE_V10,
 	.h264_enc_ctx   = MFC_H264_ENC_CTX_BUF_SIZE_V10,
+	.hevc_enc_ctx   = MFC_HEVC_ENC_CTX_BUF_SIZE_V10,
 	.other_enc_ctx  = MFC_OTHER_ENC_CTX_BUF_SIZE_V10,
 };
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
index 102b47e..7521fce 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
@@ -122,6 +122,9 @@ static int s5p_mfc_open_inst_cmd_v6(struct s5p_mfc_ctx *ctx)
 	case S5P_MFC_CODEC_VP8_ENC:
 		codec_type = S5P_FIMV_CODEC_VP8_ENC_V7;
 		break;
+	case S5P_MFC_CODEC_HEVC_ENC:
+		codec_type = S5P_FIMV_CODEC_HEVC_ENC;
+		break;
 	default:
 		codec_type = S5P_FIMV_CODEC_NONE_V6;
 	}
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index e748b99..20442a9 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -61,7 +61,7 @@
 #define MFC_ENC_CAP_PLANE_COUNT	1
 #define MFC_ENC_OUT_PLANE_COUNT	2
 #define STUFF_BYTE		4
-#define MFC_MAX_CTRLS		77
+#define MFC_MAX_CTRLS		128
 
 #define S5P_MFC_CODEC_NONE		-1
 #define S5P_MFC_CODEC_H264_DEC		0
@@ -80,6 +80,7 @@
 #define S5P_MFC_CODEC_MPEG4_ENC		22
 #define S5P_MFC_CODEC_H263_ENC		23
 #define S5P_MFC_CODEC_VP8_ENC		24
+#define S5P_MFC_CODEC_HEVC_ENC		26
 
 #define S5P_MFC_R2H_CMD_EMPTY			0
 #define S5P_MFC_R2H_CMD_SYS_INIT_RET		1
@@ -215,6 +216,7 @@ struct s5p_mfc_buf_size_v6 {
 	unsigned int h264_dec_ctx;
 	unsigned int other_dec_ctx;
 	unsigned int h264_enc_ctx;
+	unsigned int hevc_enc_ctx;
 	unsigned int other_enc_ctx;
 };
 
@@ -432,6 +434,55 @@ struct s5p_mfc_vp8_enc_params {
 	u8 profile;
 };
 
+struct s5p_mfc_hevc_enc_params {
+	enum v4l2_mpeg_video_hevc_profile profile;
+	int level;
+	enum v4l2_mpeg_video_h264_level level_v4l2;
+	u8 tier;
+	u32 rc_framerate;
+	u8 rc_min_qp;
+	u8 rc_max_qp;
+	u8 rc_lcu_dark;
+	u8 rc_lcu_smooth;
+	u8 rc_lcu_static;
+	u8 rc_lcu_activity;
+	u8 rc_frame_qp;
+	u8 rc_p_frame_qp;
+	u8 rc_b_frame_qp;
+	u8 max_partition_depth;
+	u8 num_refs_for_p;
+	u8 refreshtype;
+	u16 refreshperiod;
+	s32 lf_beta_offset_div2;
+	s32 lf_tc_offset_div2;
+	u8 loopfilter;
+	u8 loopfilter_disable;
+	u8 loopfilter_across;
+	u8 nal_control_length_filed;
+	u8 nal_control_user_ref;
+	u8 nal_control_store_ref;
+	u8 const_intra_period_enable;
+	u8 lossless_cu_enable;
+	u8 wavefront_enable;
+	u8 enable_ltr;
+	u8 hier_qp_enable;
+	enum v4l2_mpeg_video_hevc_hier_coding_type hier_qp_type;
+	u8 num_hier_layer;
+	u8 hier_qp_layer[7];
+	u32 hier_bit_layer[7];
+	u8 sign_data_hiding;
+	u8 general_pb_enable;
+	u8 temporal_id_enable;
+	u8 strong_intra_smooth;
+	u8 intra_pu_split_disable;
+	u8 tmv_prediction_disable;
+	u8 max_num_merge_mv;
+	u8 eco_mode_enable;
+	u8 encoding_nostartcode_enable;
+	u8 size_of_length_field;
+	u8 prepend_sps_pps_to_idr;
+};
+
 /**
  * struct s5p_mfc_enc_params - general encoding parameters
  */
@@ -469,6 +520,7 @@ struct s5p_mfc_enc_params {
 		struct s5p_mfc_h264_enc_params h264;
 		struct s5p_mfc_mpeg4_enc_params mpeg4;
 		struct s5p_mfc_vp8_enc_params vp8;
+		struct s5p_mfc_hevc_enc_params hevc;
 	} codec;
 
 };
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index a846a4d..6c80ebc 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -99,6 +99,13 @@ static struct s5p_mfc_fmt formats[] = {
 		.num_planes	= 1,
 		.versions	= MFC_V7PLUS_BITS,
 	},
+	{
+		.fourcc		= V4L2_PIX_FMT_HEVC,
+		.codec_mode	= S5P_FIMV_CODEC_HEVC_ENC,
+		.type		= MFC_FMT_ENC,
+		.num_planes	= 1,
+		.versions	= MFC_V10_BIT,
+	},
 };
 
 #define NUM_FORMATS ARRAY_SIZE(formats)
@@ -693,6 +700,368 @@ static struct mfc_control controls[] = {
 		.default_value = 0,
 	},
 	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "HEVC I Frame QP Value",
+		.minimum = 0,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "HEVC P Frame QP Value",
+		.minimum = 0,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_PROFILE,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.minimum = V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN,
+		.maximum = V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_STILL_PICTURE,
+		.step = 1,
+		.default_value = V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_LEVEL,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.minimum = V4L2_MPEG_VIDEO_HEVC_LEVEL_1,
+		.maximum = V4L2_MPEG_VIDEO_HEVC_LEVEL_6_2,
+		.step = 1,
+		.default_value = V4L2_MPEG_VIDEO_HEVC_LEVEL_1,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_TIER,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.minimum = V4L2_MPEG_VIDEO_HEVC_TIER_MAIN,
+		.maximum = V4L2_MPEG_VIDEO_HEVC_TIER_HIGH,
+		.step = 1,
+		.default_value = V4L2_MPEG_VIDEO_HEVC_TIER_MAIN,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_FRAME_RATE_RESOLUTION,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 1,
+		.maximum = (1 << 16) - 1,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_REF_NUMBER_FOR_PFRAMES,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 1,
+		.maximum = 2,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.minimum = V4L2_MPEG_VIDEO_HEVC_REFRESH_NONE,
+		.maximum = V4L2_MPEG_VIDEO_HEVC_REFRESH_IDR,
+		.step = 1,
+		.default_value = V4L2_MPEG_VIDEO_HEVC_REFRESH_NONE,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.minimum = V4L2_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE_DISABLED,
+		.maximum = V4L2_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE_DISABLED_AT_SLICE_BOUNDARY,
+		.step = 1,
+		.default_value = V4L2_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE_DISABLED,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_QP,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_TYPE,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.minimum = V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_B,
+		.maximum = V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_P,
+		.step = 1,
+		.default_value = V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_B,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = 6,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = INT_MIN,
+		.maximum = INT_MAX,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = INT_MIN,
+		.maximum = INT_MAX,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = INT_MIN,
+		.maximum = INT_MAX,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = INT_MIN,
+		.maximum = INT_MAX,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = INT_MIN,
+		.maximum = INT_MAX,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = INT_MIN,
+		.maximum = INT_MAX,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = INT_MIN,
+		.maximum = INT_MAX,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_BR,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = INT_MIN,
+		.maximum = INT_MAX,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_BR,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = INT_MIN,
+		.maximum = INT_MAX,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_BR,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = INT_MIN,
+		.maximum = INT_MAX,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_BR,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = INT_MIN,
+		.maximum = INT_MAX,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_BR,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = INT_MIN,
+		.maximum = INT_MAX,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_BR,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = INT_MIN,
+		.maximum = INT_MAX,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_BR,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = INT_MIN,
+		.maximum = INT_MAX,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOOTHING,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_INTRA_PU_SPLIT,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_TMV_PREDICTION,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = 4,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_WITHOUT_STARTCODE,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = (1 << 16) - 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = -6,
+		.maximum = 6,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = -6,
+		.maximum = 6,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.minimum = V4L2_MPEG_VIDEO_HEVC_SIZE_0,
+		.maximum = V4L2_MPEG_VIDEO_HEVC_SIZE_4,
+		.step = 1,
+		.default_value = V4L2_MPEG_VIDEO_HEVC_SIZE_0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_PREPEND_SPSPPS_TO_IDR,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
 		.id = V4L2_CID_MIN_BUFFERS_FOR_OUTPUT,
 		.type = V4L2_CTRL_TYPE_INTEGER,
 		.name = "Minimum number of output bufs",
@@ -1359,6 +1728,26 @@ static inline int mpeg4_level(enum v4l2_mpeg_video_mpeg4_level lvl)
 	return t[lvl];
 }
 
+static inline int hevc_level(enum v4l2_mpeg_video_hevc_level lvl)
+{
+	static unsigned int t[] = {
+		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_1    */ 10,
+		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_2    */ 20,
+		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_2_1  */ 21,
+		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_3    */ 30,
+		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_3_1  */ 31,
+		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_4    */ 40,
+		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_4_1  */ 41,
+		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_5    */ 50,
+		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_5_1  */ 51,
+		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_5_2  */ 52,
+		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_6    */ 60,
+		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_6_1  */ 61,
+		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_6_2  */ 62,
+	};
+	return t[lvl];
+}
+
 static inline int vui_sar_idc(enum v4l2_mpeg_video_h264_vui_sar_idc sar)
 {
 	static unsigned int t[V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_EXTENDED + 1] = {
@@ -1635,6 +2024,153 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:
 		p->codec.vp8.profile = ctrl->val;
 		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP:
+		p->codec.hevc.rc_frame_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP:
+		p->codec.hevc.rc_p_frame_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP:
+		p->codec.hevc.rc_b_frame_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_FRAME_RATE_RESOLUTION:
+		p->codec.hevc.rc_framerate = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP:
+		p->codec.hevc.rc_min_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP:
+		p->codec.hevc.rc_max_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:
+		p->codec.hevc.level_v4l2 = ctrl->val;
+		p->codec.hevc.level = hevc_level(ctrl->val);
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:
+		switch (ctrl->val) {
+		case V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN:
+			p->codec.hevc.profile =
+				V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN;
+			break;
+		case V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_STILL_PICTURE:
+			p->codec.hevc.profile =
+			V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_STILL_PICTURE;
+			break;
+		default:
+			ret = -EINVAL;
+		}
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_TIER:
+		p->codec.hevc.tier = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH:
+		p->codec.hevc.max_partition_depth = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_REF_NUMBER_FOR_PFRAMES:
+		p->codec.hevc.num_refs_for_p = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE:
+		p->codec.hevc.refreshtype = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED:
+		p->codec.hevc.const_intra_period_enable = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU:
+		p->codec.hevc.lossless_cu_enable = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT:
+		p->codec.hevc.wavefront_enable = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE:
+		p->codec.hevc.loopfilter = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_QP:
+		p->codec.hevc.hier_qp_enable = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_TYPE:
+		p->codec.hevc.hier_qp_type = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER:
+		p->codec.hevc.num_hier_layer = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_QP:
+		p->codec.hevc.hier_qp_layer[0] = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_QP:
+		p->codec.hevc.hier_qp_layer[1] = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_QP:
+		p->codec.hevc.hier_qp_layer[2] = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_QP:
+		p->codec.hevc.hier_qp_layer[3] = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_QP:
+		p->codec.hevc.hier_qp_layer[4] = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_QP:
+		p->codec.hevc.hier_qp_layer[5] = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_QP:
+		p->codec.hevc.hier_qp_layer[6] = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_BR:
+		p->codec.hevc.hier_bit_layer[0] = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_BR:
+		p->codec.hevc.hier_bit_layer[1] = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_BR:
+		p->codec.hevc.hier_bit_layer[2] = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_BR:
+		p->codec.hevc.hier_bit_layer[3] = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_BR:
+		p->codec.hevc.hier_bit_layer[4] = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_BR:
+		p->codec.hevc.hier_bit_layer[5] = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_BR:
+		p->codec.hevc.hier_bit_layer[6] = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB:
+		p->codec.hevc.general_pb_enable = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID:
+		p->codec.hevc.temporal_id_enable = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOOTHING:
+		p->codec.hevc.strong_intra_smooth = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_INTRA_PU_SPLIT:
+		p->codec.hevc.intra_pu_split_disable = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_TMV_PREDICTION:
+		p->codec.hevc.tmv_prediction_disable = !ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1:
+		p->codec.hevc.max_num_merge_mv = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_WITHOUT_STARTCODE:
+		p->codec.hevc.encoding_nostartcode_enable = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD:
+		p->codec.hevc.refreshperiod = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2:
+		p->codec.hevc.lf_beta_offset_div2 = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2:
+		p->codec.hevc.lf_tc_offset_div2 = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD:
+		p->codec.hevc.size_of_length_field = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_PREPEND_SPSPPS_TO_IDR:
+		p->codec.hevc.prepend_sps_pps_to_idr = ctrl->val;
+		break;
 	default:
 		v4l2_err(&dev->v4l2_dev, "Invalid control, id=%d, val=%d\n",
 							ctrl->id, ctrl->val);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
index 57f4560..8c295f0 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
@@ -272,6 +272,14 @@ struct s5p_mfc_regs {
 	void __iomem *e_vp8_hierarchical_qp_layer1;/* v7 and v8 */
 	void __iomem *e_vp8_hierarchical_qp_layer2;/* v7 and v8 */
 	void __iomem *e_min_scratch_buffer_size; /* v10 */
+	void __iomem *e_num_t_layer; /* v10 */
+	void __iomem *e_hier_qp_layer0; /* v10 */
+	void __iomem *e_hier_bit_rate_layer0; /* v10 */
+	void __iomem *e_hevc_options; /* v10 */
+	void __iomem *e_hevc_refresh_period; /* v10 */
+	void __iomem *e_hevc_lf_beta_offset_div2; /* v10 */
+	void __iomem *e_hevc_lf_tc_offset_div2; /* v10 */
+	void __iomem *e_hevc_nal_control; /* v10 */
 };
 
 struct s5p_mfc_hw_ops {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index f47612c..7c629be 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -299,6 +299,17 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 			ctx->chroma_dpb_size + ctx->me_buffer_size));
 		ctx->bank2.size = 0;
 		break;
+	case S5P_MFC_CODEC_HEVC_ENC:
+		mfc_debug(2, "Use min scratch buffer size\n");
+		ctx->me_buffer_size =
+			ALIGN(ENC_V100_HEVC_ME_SIZE(lcu_width, lcu_height), 16);
+		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size, 256);
+		ctx->bank1.size =
+			ctx->scratch_buf_size + ctx->tmv_buffer_size +
+			(ctx->pb_count * (ctx->luma_dpb_size +
+			ctx->chroma_dpb_size + ctx->me_buffer_size));
+		ctx->bank2.size = 0;
+		break;
 	default:
 		break;
 	}
@@ -348,6 +359,9 @@ static int s5p_mfc_alloc_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
 	case S5P_MFC_CODEC_H264_ENC:
 		ctx->ctx.size = buf_size->h264_enc_ctx;
 		break;
+	case S5P_MFC_CODEC_HEVC_ENC:
+		ctx->ctx.size = buf_size->hevc_enc_ctx;
+		break;
 	case S5P_MFC_CODEC_MPEG4_ENC:
 	case S5P_MFC_CODEC_H263_ENC:
 	case S5P_MFC_CODEC_VP8_ENC:
@@ -1426,6 +1440,162 @@ static int s5p_mfc_set_enc_params_vp8(struct s5p_mfc_ctx *ctx)
 	return 0;
 }
 
+static int s5p_mfc_set_enc_params_hevc(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+	struct s5p_mfc_hevc_enc_params *p_hevc = &p->codec.hevc;
+	unsigned int reg = 0;
+	int i;
+
+	mfc_debug_enter();
+
+	s5p_mfc_set_enc_params(ctx);
+
+	/* pictype : number of B */
+	reg = readl(mfc_regs->e_gop_config);
+	/* num_b_frame - 0 ~ 2 */
+	reg &= ~(0x3 << 16);
+	reg |= (p->num_b_frame << 16);
+	writel(reg, mfc_regs->e_gop_config);
+
+	/* UHD encoding case */
+	if ((ctx->img_width == 3840) && (ctx->img_height == 2160)) {
+		p_hevc->level = 51;
+		p_hevc->tier = 0;
+	/* this tier can be changed */
+	}
+
+	/* tier & level */
+	reg = 0;
+	/* profile */
+	reg |= p_hevc->profile & 0x3;
+	/* level */
+	reg &= ~(0xFF << 8);
+	reg |= (p_hevc->level << 8);
+	/* tier - 0 ~ 1 */
+	reg |= (p_hevc->tier << 16);
+	writel(reg, mfc_regs->e_picture_profile);
+
+	switch (p_hevc->loopfilter) {
+	case V4L2_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE_DISABLED:
+		p_hevc->loopfilter_disable = 1;
+		break;
+	case V4L2_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE_ENABLED:
+		p_hevc->loopfilter_disable = 0;
+		p_hevc->loopfilter_across = 1;
+		break;
+	case V4L2_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE_DISABLED_AT_SLICE_BOUNDARY:
+		p_hevc->loopfilter_disable = 0;
+		p_hevc->loopfilter_across = 0;
+		break;
+	}
+
+	/* max partition depth */
+	reg = 0;
+	reg |= (p_hevc->max_partition_depth & 0x1);
+	reg |= (p_hevc->num_refs_for_p-1) << 2;
+	reg |= (p_hevc->refreshtype & 0x3) << 3;
+	reg |= (p_hevc->const_intra_period_enable & 0x1) << 5;
+	reg |= (p_hevc->lossless_cu_enable & 0x1) << 6;
+	reg |= (p_hevc->wavefront_enable & 0x1) << 7;
+	reg |= (p_hevc->loopfilter_disable & 0x1) << 8;
+	reg |= (p_hevc->loopfilter_across & 0x1) << 9;
+	reg |= (p_hevc->enable_ltr & 0x1) << 10;
+	reg |= (p_hevc->hier_qp_enable & 0x1) << 11;
+	reg |= (p_hevc->general_pb_enable & 0x1) << 13;
+	reg |= (p_hevc->temporal_id_enable & 0x1) << 14;
+	reg |= (p_hevc->strong_intra_smooth & 0x1) << 15;
+	reg |= (p_hevc->intra_pu_split_disable & 0x1) << 16;
+	reg |= (p_hevc->tmv_prediction_disable & 0x1) << 17;
+	reg |= (p_hevc->max_num_merge_mv & 0x7) << 18;
+	reg |= (p_hevc->encoding_nostartcode_enable & 0x1) << 23;
+	reg |= (p_hevc->prepend_sps_pps_to_idr << 26);
+
+	writel(reg, mfc_regs->e_hevc_options);
+	/* refresh period */
+	if (p_hevc->refreshtype) {
+		reg = 0;
+		reg |= (p_hevc->refreshperiod & 0xFFFF);
+		writel(reg, mfc_regs->e_hevc_refresh_period);
+	}
+	/* loop filter setting */
+	if (!(p_hevc->loopfilter_disable & 0x1)) {
+		reg = 0;
+		reg |= (p_hevc->lf_beta_offset_div2);
+		writel(reg, mfc_regs->e_hevc_lf_beta_offset_div2);
+		reg = 0;
+		reg |= (p_hevc->lf_tc_offset_div2);
+		writel(reg, mfc_regs->e_hevc_lf_tc_offset_div2);
+	}
+	/* hier qp enable */
+	if (p_hevc->num_hier_layer) {
+		reg = 0;
+		reg |= (p_hevc->hier_qp_type & 0x1) << 0x3;
+		reg |= p_hevc->num_hier_layer & 0x7;
+		writel(reg, mfc_regs->e_num_t_layer);
+		/* QP value for each layer */
+		if (p_hevc->hier_qp_enable) {
+			for (i = 0; i < 7; i++)
+				writel(p_hevc->hier_qp_layer[i],
+					mfc_regs->e_hier_qp_layer0 + i * 4);
+		}
+		if (p->rc_frame) {
+			for (i = 0; i < 7; i++)
+				writel(p_hevc->hier_bit_layer[i],
+						mfc_regs->e_hier_bit_rate_layer0
+						+ i * 4);
+		}
+	}
+
+	/* rate control config. */
+	reg = readl(mfc_regs->e_rc_config);
+	/* macroblock level rate control */
+	reg &= ~(0x1 << 8);
+	reg |= (p->rc_mb << 8);
+	writel(reg, mfc_regs->e_rc_config);
+	/* frame QP */
+	reg &= ~(0xFF);
+	reg |= p_hevc->rc_frame_qp;
+	writel(reg, mfc_regs->e_rc_config);
+
+	/* frame rate */
+	if (p->rc_frame) {
+		reg = 0;
+		reg &= ~(0xFFFF << 16);
+		reg |= ((p_hevc->rc_framerate) << 16);
+		reg &= ~(0xFFFF);
+		reg |= FRAME_DELTA_DEFAULT;
+		writel(reg, mfc_regs->e_rc_frame_rate);
+	}
+
+	/* max & min value of QP */
+	reg = 0;
+	/* max QP */
+	reg &= ~(0xFF << 8);
+	reg |= (p_hevc->rc_max_qp << 8);
+	/* min QP */
+	reg &= ~(0xFF);
+	reg |= p_hevc->rc_min_qp;
+	writel(reg, mfc_regs->e_rc_qp_bound);
+
+	writel(0x0, mfc_regs->e_fixed_picture_qp);
+	if (!p->rc_frame && !p->rc_mb) {
+		reg = 0;
+		reg &= ~(0xFF << 16);
+		reg |= (p_hevc->rc_b_frame_qp << 16);
+		reg &= ~(0xFF << 8);
+		reg |= (p_hevc->rc_p_frame_qp << 8);
+		reg &= ~(0xFF);
+		reg |= p_hevc->rc_frame_qp;
+		writel(reg, mfc_regs->e_fixed_picture_qp);
+	}
+	mfc_debug_leave();
+
+	return 0;
+}
+
 /* Initialize decoding */
 static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 {
@@ -1545,6 +1715,8 @@ static int s5p_mfc_init_encode_v6(struct s5p_mfc_ctx *ctx)
 		s5p_mfc_set_enc_params_h263(ctx);
 	else if (ctx->codec_mode == S5P_MFC_CODEC_VP8_ENC)
 		s5p_mfc_set_enc_params_vp8(ctx);
+	else if (ctx->codec_mode == S5P_FIMV_CODEC_HEVC_ENC)
+		s5p_mfc_set_enc_params_hevc(ctx);
 	else {
 		mfc_err("Unknown codec for encoding (%x).\n",
 			ctx->codec_mode);
@@ -2298,6 +2470,16 @@ const struct s5p_mfc_regs *s5p_mfc_init_regs_v6_plus(struct s5p_mfc_dev *dev)
 	R(d_static_buffer_addr, S5P_FIMV_D_STATIC_BUFFER_ADDR_V10);
 	R(d_static_buffer_size, S5P_FIMV_D_STATIC_BUFFER_SIZE_V10);
 
+	/* encoder registers */
+	R(e_num_t_layer, S5P_FIMV_E_NUM_T_LAYER_V10);
+	R(e_hier_qp_layer0, S5P_FIMV_E_HIERARCHICAL_QP_LAYER0_V10);
+	R(e_hier_bit_rate_layer0, S5P_FIMV_E_HIERARCHICAL_BIT_RATE_LAYER0_V10);
+	R(e_hevc_options, S5P_FIMV_E_HEVC_OPTIONS_V10);
+	R(e_hevc_refresh_period, S5P_FIMV_E_HEVC_REFRESH_PERIOD_V10);
+	R(e_hevc_lf_beta_offset_div2, S5P_FIMV_E_HEVC_LF_BETA_OFFSET_DIV2_V10);
+	R(e_hevc_lf_tc_offset_div2, S5P_FIMV_E_HEVC_LF_TC_OFFSET_DIV2_V10);
+	R(e_hevc_nal_control, S5P_FIMV_E_HEVC_NAL_CONTROL_V10);
+
 done:
 	return &mfc_regs;
 #undef S5P_MFC_REG_ADDR
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
index f6cb703..f013b29 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
@@ -46,6 +46,14 @@
 #define ENC_MPEG4_VOP_TIME_RES_MAX	((1 << 16) - 1)
 #define FRAME_DELTA_H264_H263		1
 #define TIGHT_CBR_MAX			10
+#define ENC_HEVC_RC_FRAME_RATE_MAX	((1 << 16) - 1)
+#define ENC_HEVC_QP_INDEX_MIN		-12
+#define ENC_HEVC_QP_INDEX_MAX		12
+#define ENC_HEVC_LOOP_FILTER_MIN	-12
+#define ENC_HEVC_LOOP_FILTER_MAX	12
+#define ENC_HEVC_LEVEL_MAX		62
+
+#define FRAME_DELTA_DEFAULT		1
 
 struct s5p_mfc_hw_ops *s5p_mfc_init_hw_ops_v6(void);
 const struct s5p_mfc_regs *s5p_mfc_init_regs_v6_plus(struct s5p_mfc_dev *dev);
-- 
2.7.4
