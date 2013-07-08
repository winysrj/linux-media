Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:63372 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3GHMHf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jul 2013 08:07:35 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MPM00MEQ9O933P0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 08 Jul 2013 21:07:34 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, avnd.kiran@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH v4 8/8] [media] s5p-mfc: Add support for VP8 encoder
Date: Mon, 08 Jul 2013 18:00:36 +0530
Message-id: <1373286637-30154-9-git-send-email-arun.kk@samsung.com>
In-reply-to: <1373286637-30154-1-git-send-email-arun.kk@samsung.com>
References: <1373286637-30154-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MFC v7 supports VP8 encoding and this patch adds support
for it in the driver.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c |    3 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |   19 ++++-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   90 ++++++++++++++++++++++-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   90 +++++++++++++++++++++++
 4 files changed, 200 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
index 5708fc3..db796c8 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
@@ -108,6 +108,9 @@ static int s5p_mfc_open_inst_cmd_v6(struct s5p_mfc_ctx *ctx)
 	case S5P_MFC_CODEC_H263_ENC:
 		codec_type = S5P_FIMV_CODEC_H263_ENC_V6;
 		break;
+	case S5P_MFC_CODEC_VP8_ENC:
+		codec_type = S5P_FIMV_CODEC_VP8_ENC_V7;
+		break;
 	default:
 		codec_type = S5P_FIMV_CODEC_NONE_V6;
 	};
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 17545d7..6920b54 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -65,7 +65,7 @@ static inline dma_addr_t s5p_mfc_mem_cookie(void *a, void *b)
 #define MFC_ENC_CAP_PLANE_COUNT	1
 #define MFC_ENC_OUT_PLANE_COUNT	2
 #define STUFF_BYTE		4
-#define MFC_MAX_CTRLS		70
+#define MFC_MAX_CTRLS		77
 
 #define S5P_MFC_CODEC_NONE		-1
 #define S5P_MFC_CODEC_H264_DEC		0
@@ -81,6 +81,7 @@ static inline dma_addr_t s5p_mfc_mem_cookie(void *a, void *b)
 #define S5P_MFC_CODEC_H264_MVC_ENC	21
 #define S5P_MFC_CODEC_MPEG4_ENC		22
 #define S5P_MFC_CODEC_H263_ENC		23
+#define S5P_MFC_CODEC_VP8_ENC		24
 
 #define S5P_MFC_R2H_CMD_EMPTY			0
 #define S5P_MFC_R2H_CMD_SYS_INIT_RET		1
@@ -409,6 +410,21 @@ struct s5p_mfc_mpeg4_enc_params {
 };
 
 /**
+ * struct s5p_mfc_vp8_enc_params - encoding parameters for vp8
+ */
+struct s5p_mfc_vp8_enc_params {
+	u8 imd_4x4;
+	enum v4l2_vp8_num_partitions num_partitions;
+	enum v4l2_vp8_num_ref_frames num_ref;
+	u8 filter_level;
+	u8 filter_sharpness;
+	u32 golden_frame_ref_period;
+	enum v4l2_vp8_golden_frame_sel golden_frame_sel;
+	u8 hier_layer;
+	u8 hier_layer_qp[3];
+};
+
+/**
  * struct s5p_mfc_enc_params - general encoding parameters
  */
 struct s5p_mfc_enc_params {
@@ -442,6 +458,7 @@ struct s5p_mfc_enc_params {
 	struct {
 		struct s5p_mfc_h264_enc_params h264;
 		struct s5p_mfc_mpeg4_enc_params mpeg4;
+		struct s5p_mfc_vp8_enc_params vp8;
 	} codec;
 
 };
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 6dafe96..fb077b3 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -84,6 +84,13 @@ static struct s5p_mfc_fmt formats[] = {
 		.type		= MFC_FMT_ENC,
 		.num_planes	= 1,
 	},
+	{
+		.name		= "VP8 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_VP8,
+		.codec_mode	= S5P_MFC_CODEC_VP8_ENC,
+		.type		= MFC_FMT_ENC,
+		.num_planes	= 1,
+	},
 };
 
 #define NUM_FORMATS ARRAY_SIZE(formats)
@@ -557,6 +564,60 @@ static struct mfc_control controls[] = {
 		.step = 1,
 		.default_value = 0,
 	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS,
+		.type = V4L2_CTRL_TYPE_INTEGER_MENU,
+		.maximum = V4L2_CID_MPEG_VIDEO_VPX_8_PARTITIONS,
+		.default_value = V4L2_CID_MPEG_VIDEO_VPX_1_PARTITION,
+		.menu_skip_mask = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_VPX_IMD_DISABLE_4X4,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_VPX_NUM_REF_FRAMES,
+		.type = V4L2_CTRL_TYPE_INTEGER_MENU,
+		.maximum = V4L2_CID_MPEG_VIDEO_VPX_2_REF_FRAME,
+		.default_value = V4L2_CID_MPEG_VIDEO_VPX_1_REF_FRAME,
+		.menu_skip_mask = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_VPX_FILTER_LEVEL,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = 63,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_VPX_FILTER_SHARPNESS,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = 7,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_REF_PERIOD,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = (1 << 16) - 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.minimum = V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_USE_PREV,
+		.maximum = V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_USE_REF_PERIOD,
+		.default_value = V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_USE_PREV,
+		.menu_skip_mask = 0,
+	},
 };
 
 #define NUM_CTRLS ARRAY_SIZE(controls)
@@ -965,6 +1026,10 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			mfc_err("failed to set capture format\n");
 			return -EINVAL;
 		}
+		if (!IS_MFCV7(dev) && (fmt->fourcc == V4L2_PIX_FMT_VP8)) {
+			mfc_err("VP8 is supported only in MFC v7\n");
+			return -EINVAL;
+		}
 		ctx->state = MFCINST_INIT;
 		ctx->dst_fmt = fmt;
 		ctx->codec_mode = ctx->dst_fmt->codec_mode;
@@ -1482,6 +1547,27 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_MPEG4_QPEL:
 		p->codec.mpeg4.quarter_pixel = ctrl->val;
 		break;
+	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:
+		p->codec.vp8.num_partitions = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_VPX_IMD_DISABLE_4X4:
+		p->codec.vp8.imd_4x4 = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_VPX_NUM_REF_FRAMES:
+		p->codec.vp8.num_ref = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_VPX_FILTER_LEVEL:
+		p->codec.vp8.filter_level = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_VPX_FILTER_SHARPNESS:
+		p->codec.vp8.filter_sharpness = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_REF_PERIOD:
+		p->codec.vp8.golden_frame_ref_period = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
+		p->codec.vp8.golden_frame_sel = ctrl->val;
+		break;
 	default:
 		v4l2_err(&dev->v4l2_dev, "Invalid control, id=%d, val=%d\n",
 							ctrl->id, ctrl->val);
@@ -1930,7 +2016,9 @@ int s5p_mfc_enc_ctrls_setup(struct s5p_mfc_ctx *ctx)
 			ctx->ctrls[i] = v4l2_ctrl_new_custom(&ctx->ctrl_handler,
 					&cfg, NULL);
 		} else {
-			if (controls[i].type == V4L2_CTRL_TYPE_MENU) {
+			if ((controls[i].type == V4L2_CTRL_TYPE_MENU) ||
+				(controls[i].type ==
+					V4L2_CTRL_TYPE_INTEGER_MENU)) {
 				ctx->ctrls[i] = v4l2_ctrl_new_std_menu(
 					&ctx->ctrl_handler,
 					&s5p_mfc_enc_ctrl_ops, controls[i].id,
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 3440317..1a66b9b 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -188,6 +188,19 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 			ctx->chroma_dpb_size + ctx->me_buffer_size));
 		ctx->bank2.size = 0;
 		break;
+	case S5P_MFC_CODEC_VP8_ENC:
+		ctx->scratch_buf_size =
+			S5P_FIMV_SCRATCH_BUF_SIZE_VP8_ENC_V7(
+					mb_width,
+					mb_height);
+		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
+				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
+		ctx->bank1.size =
+			ctx->scratch_buf_size + ctx->tmv_buffer_size +
+			(ctx->pb_count * (ctx->luma_dpb_size +
+			ctx->chroma_dpb_size + ctx->me_buffer_size));
+		ctx->bank2.size = 0;
+		break;
 	default:
 		break;
 	}
@@ -237,6 +250,7 @@ static int s5p_mfc_alloc_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
 		break;
 	case S5P_MFC_CODEC_MPEG4_ENC:
 	case S5P_MFC_CODEC_H263_ENC:
+	case S5P_MFC_CODEC_VP8_ENC:
 		ctx->ctx.size = buf_size->other_enc_ctx;
 		break;
 	default:
@@ -1165,6 +1179,80 @@ static int s5p_mfc_set_enc_params_h263(struct s5p_mfc_ctx *ctx)
 	return 0;
 }
 
+static int s5p_mfc_set_enc_params_vp8(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+	struct s5p_mfc_vp8_enc_params *p_vp8 = &p->codec.vp8;
+	unsigned int reg = 0;
+	unsigned int val = 0;
+
+	mfc_debug_enter();
+
+	s5p_mfc_set_enc_params(ctx);
+
+	/* pictype : number of B */
+	reg = READL(S5P_FIMV_E_GOP_CONFIG_V6);
+	reg &= ~(0x3 << 16);
+	reg |= ((p->num_b_frame & 0x3) << 16);
+	WRITEL(reg, S5P_FIMV_E_GOP_CONFIG_V6);
+
+	/* profile & level */
+	reg = 0;
+	/** profile */
+	reg |= (0x1 << 4);
+	WRITEL(reg, S5P_FIMV_E_PICTURE_PROFILE_V6);
+
+	/* rate control config. */
+	reg = READL(S5P_FIMV_E_RC_CONFIG_V6);
+	/** macroblock level rate control */
+	reg &= ~(0x1 << 8);
+	reg |= ((p->rc_mb & 0x1) << 8);
+	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
+
+	/* frame rate */
+	if (p->rc_frame && p->rc_framerate_num && p->rc_framerate_denom) {
+		reg = 0;
+		reg |= ((p->rc_framerate_num & 0xFFFF) << 16);
+		reg |= p->rc_framerate_denom & 0xFFFF;
+		WRITEL(reg, S5P_FIMV_E_RC_FRAME_RATE_V6);
+	}
+
+	/* vbv buffer size */
+	if (p->frame_skip_mode ==
+			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
+		WRITEL(p->vbv_size & 0xFFFF, S5P_FIMV_E_VBV_BUFFER_SIZE_V6);
+
+		if (p->rc_frame)
+			WRITEL(p->vbv_delay, S5P_FIMV_E_VBV_INIT_DELAY_V6);
+	}
+
+	/* VP8 specific params */
+	reg = 0;
+	reg |= (p_vp8->imd_4x4 & 0x1) << 10;
+	switch (p_vp8->num_partitions) {
+	case V4L2_CID_MPEG_VIDEO_VPX_1_PARTITION:
+		val = 0;
+		break;
+	case V4L2_CID_MPEG_VIDEO_VPX_2_PARTITIONS:
+		val = 2;
+		break;
+	case V4L2_CID_MPEG_VIDEO_VPX_4_PARTITIONS:
+		val = 4;
+		break;
+	case V4L2_CID_MPEG_VIDEO_VPX_8_PARTITIONS:
+		val = 8;
+		break;
+	}
+	reg |= (val & 0xF) << 3;
+	reg |= (p_vp8->num_ref & 0x2);
+	WRITEL(reg, S5P_FIMV_E_VP8_OPTIONS_V7);
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
 /* Initialize decoding */
 static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 {
@@ -1283,6 +1371,8 @@ static int s5p_mfc_init_encode_v6(struct s5p_mfc_ctx *ctx)
 		s5p_mfc_set_enc_params_mpeg4(ctx);
 	else if (ctx->codec_mode == S5P_MFC_CODEC_H263_ENC)
 		s5p_mfc_set_enc_params_h263(ctx);
+	else if (ctx->codec_mode == S5P_MFC_CODEC_VP8_ENC)
+		s5p_mfc_set_enc_params_vp8(ctx);
 	else {
 		mfc_err("Unknown codec for encoding (%x).\n",
 			ctx->codec_mode);
-- 
1.7.9.5

