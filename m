Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:63292 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab3JIXuh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Oct 2013 19:50:37 -0400
Received: by mail-qc0-f202.google.com with SMTP id r5so112687qcx.5
        for <linux-media@vger.kernel.org>; Wed, 09 Oct 2013 16:50:36 -0700 (PDT)
From: John Sheu <sheu@google.com>
To: linux-media@vger.kernel.org
Cc: John Sheu <sheu@google.com>, m.chehab@samsung.com,
	k.debski@samsung.com, pawel@osciak.com
Subject: [PATCH 4/6] [media] s5p-mfc: support dynamic encoding parameter changes
Date: Wed,  9 Oct 2013 16:49:47 -0700
Message-Id: <1381362589-32237-5-git-send-email-sheu@google.com>
In-Reply-To: <1381362589-32237-1-git-send-email-sheu@google.com>
References: <1381362589-32237-1-git-send-email-sheu@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for dynamic encoding parameter changes in MFCv6.  Parameters
set are applied with the next OUTPUT buffer queued to the device with
VIDIOC_QBUF.

Supported parameters are:

* GOP size (V4L2_CID_MPEG_VIDEO_GOP_SIZE)
* framerate (from VIDIOC_S_PARM)
* VBR target bitrate (V4L2_CID_MPEG_VIDEO_BITRATE)
* (h264) frame type (V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE)

Signed-off-by: John Sheu <sheu@google.com>
---
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h    |  4 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h | 32 +++++++--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    | 53 +++++++++++---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c | 29 ++++----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 94 ++++++++++++++-----------
 5 files changed, 140 insertions(+), 72 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
index 2398cdf..495ed21 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
@@ -330,6 +330,10 @@
 #define S5P_FIMV_E_MVC_RC_RPARA_VIEW1_V6		0xfd50
 #define S5P_FIMV_E_MVC_INTER_VIEW_PREDICTION_ON_V6	0xfd80
 
+#define S5P_FIMV_E_GOP_CONFIG_CHANGE_SHIFT_V6		0
+#define S5P_FIMV_E_FRAME_RATE_CHANGE_SHIFT_V6		1
+#define S5P_FIMV_E_BIT_RATE_CHANGE_SHIFT_V6		2
+
 /* Codec numbers  */
 #define S5P_FIMV_CODEC_NONE_V6		-1
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 48f706f..af134fd 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -173,12 +173,35 @@ enum s5p_mfc_decode_arg {
 	MFC_DEC_RES_CHANGE,
 };
 
+
+/**
+ * enum s5p_mfc_encoder_param_change - indicates runtime parameter change
+ */
+enum s5p_mfc_encode_param_change {
+	MFC_ENC_GOP_CONFIG_CHANGE,
+	MFC_ENC_FRAME_RATE_CHANGE,
+	MFC_ENC_BIT_RATE_CHANGE,
+	MFC_ENC_FRAME_INSERTION,
+};
+
 #define MFC_BUF_FLAG_USED	(1 << 0)
 #define MFC_BUF_FLAG_EOS	(1 << 1)
 
 struct s5p_mfc_ctx;
 
 /**
+ * struct s5p_mfc_enc_params - runtime modifiable encoding parameters
+ */
+struct s5p_mfc_runtime_enc_params {
+	u32 params_changed;
+	u16 gop_size;
+	u32 rc_framerate_num;
+	u32 rc_framerate_denom;
+	u32 rc_bitrate;
+	enum v4l2_mpeg_mfc51_video_force_frame_type force_frame_type;
+};
+
+/**
  * struct s5p_mfc_buf - MFC buffer
  */
 struct s5p_mfc_buf {
@@ -192,6 +215,7 @@ struct s5p_mfc_buf {
 		size_t stream;
 	} cookie;
 	int flags;
+	struct s5p_mfc_runtime_enc_params runtime_enc_params;
 };
 
 /**
@@ -433,7 +457,6 @@ struct s5p_mfc_enc_params {
 	u16 crop_top_offset;
 	u16 crop_bottom_offset;
 
-	u16 gop_size;
 	enum v4l2_mpeg_video_multi_slice_mode slice_mode;
 	u16 slice_mb;
 	u32 slice_bit;
@@ -444,7 +467,6 @@ struct s5p_mfc_enc_params {
 	u8 pad_cr;
 	int rc_frame;
 	int rc_mb;
-	u32 rc_bitrate;
 	u16 rc_reaction_coeff;
 	u16 vbv_size;
 	u32 vbv_delay;
@@ -454,15 +476,13 @@ struct s5p_mfc_enc_params {
 	int fixed_target_bit;
 
 	u8 num_b_frame;
-	u32 rc_framerate_num;
-	u32 rc_framerate_denom;
 
 	struct {
+		struct s5p_mfc_runtime_enc_params runtime;
 		struct s5p_mfc_h264_enc_params h264;
 		struct s5p_mfc_mpeg4_enc_params mpeg4;
 		struct s5p_mfc_vp8_enc_params vp8;
 	} codec;
-
 };
 
 /**
@@ -638,8 +658,6 @@ struct s5p_mfc_ctx {
 	size_t me_buffer_size;
 	size_t tmv_buffer_size;
 
-	enum v4l2_mpeg_mfc51_video_force_frame_type force_frame_type;
-
 	struct list_head ref_queue;
 	unsigned int ref_queue_cnt;
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 4ad9349..0898dee 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1342,7 +1342,9 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
 
 	switch (ctrl->id) {
 	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
-		p->gop_size = ctrl->val;
+		p->codec.runtime.params_changed |=
+			(1 << MFC_ENC_GOP_CONFIG_CHANGE);
+		p->codec.runtime.gop_size = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE:
 		p->slice_mode = ctrl->val;
@@ -1368,13 +1370,17 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
 		p->rc_frame = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_VIDEO_BITRATE:
-		p->rc_bitrate = ctrl->val;
+		p->codec.runtime.params_changed |=
+			(1 << MFC_ENC_BIT_RATE_CHANGE);
+		p->codec.runtime.rc_bitrate = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_MFC51_VIDEO_RC_REACTION_COEFF:
 		p->rc_reaction_coeff = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE:
-		ctx->force_frame_type = ctrl->val;
+		p->codec.runtime.params_changed |=
+			(1 << MFC_ENC_FRAME_INSERTION);
+		p->codec.runtime.force_frame_type = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_VIDEO_VBV_SIZE:
 		p->vbv_size = ctrl->val;
@@ -1575,12 +1581,29 @@ static int vidioc_s_parm(struct file *file, void *priv,
 			 struct v4l2_streamparm *a)
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	struct s5p_mfc_runtime_enc_params *runtime_params =
+		&ctx->enc_params.codec.runtime;
 
+	/*
+	 * Note that MFC hardware specifies framerate but the V4L2 API specifies
+	 * timeperframe. Take the reciprocal of one to get the other.
+	 */
 	if (a->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		ctx->enc_params.rc_framerate_num =
-					a->parm.output.timeperframe.denominator;
-		ctx->enc_params.rc_framerate_denom =
-					a->parm.output.timeperframe.numerator;
+		if ((runtime_params->rc_framerate_num !=
+			a->parm.output.timeperframe.denominator) ||
+			(runtime_params->rc_framerate_denom !=
+			a->parm.output.timeperframe.numerator)) {
+			if (a->parm.output.timeperframe.numerator == 0) {
+				mfc_err("Cannot set an infinite FPS\n");
+				return -EINVAL;
+			}
+			runtime_params->params_changed |=
+				(1 << MFC_ENC_FRAME_RATE_CHANGE);
+			runtime_params->rc_framerate_num =
+				a->parm.output.timeperframe.denominator;
+			runtime_params->rc_framerate_denom =
+				a->parm.output.timeperframe.numerator;
+		}
 	} else {
 		mfc_err("Setting FPS is only possible for the output queue\n");
 		return -EINVAL;
@@ -1595,9 +1618,9 @@ static int vidioc_g_parm(struct file *file, void *priv,
 
 	if (a->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		a->parm.output.timeperframe.denominator =
-					ctx->enc_params.rc_framerate_num;
+			ctx->enc_params.codec.runtime.rc_framerate_num;
 		a->parm.output.timeperframe.numerator =
-					ctx->enc_params.rc_framerate_denom;
+			ctx->enc_params.codec.runtime.rc_framerate_denom;
 	} else {
 		mfc_err("Getting FPS is only possible for the output queue\n");
 		return -EINVAL;
@@ -1983,7 +2006,19 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 		ctx->dst_queue_cnt++;
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		struct s5p_mfc_runtime_enc_params *runtime_params =
+			&ctx->enc_params.codec.runtime;
 		mfc_buf = &ctx->src_bufs[vb->v4l2_buf.index];
+		/* Tag buffer with runtime encoding parameters */
+		memcpy(&mfc_buf->runtime_enc_params, runtime_params,
+			sizeof(mfc_buf->runtime_enc_params));
+		runtime_params->params_changed = 0;
+		/* force_frame_type needs to revert to 0 after being sent. */
+		if (runtime_params->force_frame_type != 0) {
+			v4l2_ctrl_s_ctrl(v4l2_ctrl_find(&ctx->ctrl_handler,
+				V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE),
+				V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_DISABLED);
+		}
 		mfc_buf->flags &= ~MFC_BUF_FLAG_USED;
 		spin_lock_irqsave(&dev->irqlock, flags);
 		list_add_tail(&mfc_buf->list, &ctx->src_queue);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index 368582b..428cbb8 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -688,7 +688,7 @@ static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx *ctx)
 	reg = mfc_read(dev, S5P_FIMV_ENC_PIC_TYPE_CTRL);
 	reg |= (1 << 18);
 	reg &= ~(0xFFFF);
-	reg |= p->gop_size;
+	reg |= p->codec.runtime.gop_size;
 	mfc_write(dev, reg, S5P_FIMV_ENC_PIC_TYPE_CTRL);
 	mfc_write(dev, 0, S5P_FIMV_ENC_B_RECON_WRITE_ON);
 	/* multi-slice control */
@@ -736,7 +736,7 @@ static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx *ctx)
 	mfc_write(dev, reg, S5P_FIMV_ENC_RC_CONFIG);
 	/* bit rate */
 	if (p->rc_frame)
-		mfc_write(dev, p->rc_bitrate,
+		mfc_write(dev, p->codec.runtime.rc_bitrate,
 			S5P_FIMV_ENC_RC_BIT_RATE);
 	else
 		mfc_write(dev, 0, S5P_FIMV_ENC_RC_BIT_RATE);
@@ -831,9 +831,10 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	reg |= p_264->rc_frame_qp;
 	mfc_write(dev, reg, S5P_FIMV_ENC_RC_CONFIG);
 	/* frame rate */
-	if (p->rc_frame && p->rc_framerate_denom)
-		mfc_write(dev, p->rc_framerate_num * 1000
-			/ p->rc_framerate_denom, S5P_FIMV_ENC_RC_FRAME_RATE);
+	if (p->rc_frame && p->codec.runtime.rc_framerate_denom)
+		mfc_write(dev, p->codec.runtime.rc_framerate_num * 1000
+			/ p->codec.runtime.rc_framerate_denom,
+			S5P_FIMV_ENC_RC_FRAME_RATE);
 	else
 		mfc_write(dev, 0, S5P_FIMV_ENC_RC_FRAME_RATE);
 	/* max & min value of QP */
@@ -950,16 +951,17 @@ static int s5p_mfc_set_enc_params_mpeg4(struct s5p_mfc_ctx *ctx)
 	}
 	/* frame rate */
 	if (p->rc_frame) {
-		if (p->rc_framerate_denom > 0) {
-			framerate = p->rc_framerate_num * 1000 /
-						p->rc_framerate_denom;
+		if (p->codec.runtime.rc_framerate_denom > 0) {
+			framerate = p->codec.runtime.rc_framerate_num * 1000 /
+				p->codec.runtime.rc_framerate_denom;
 			mfc_write(dev, framerate,
 				S5P_FIMV_ENC_RC_FRAME_RATE);
 			shm = s5p_mfc_read_info_v5(ctx, RC_VOP_TIMING);
 			shm &= ~(0xFFFFFFFF);
 			shm |= (1 << 31);
-			shm |= ((p->rc_framerate_num & 0x7FFF) << 16);
-			shm |= (p->rc_framerate_denom & 0xFFFF);
+			shm |= ((p->codec.runtime.rc_framerate_num & 0x7FFF)
+				<< 16);
+			shm |= (p->codec.runtime.rc_framerate_denom & 0xFFFF);
 			s5p_mfc_write_info_v5(ctx, shm, RC_VOP_TIMING);
 		}
 	} else {
@@ -1009,9 +1011,10 @@ static int s5p_mfc_set_enc_params_h263(struct s5p_mfc_ctx *ctx)
 		s5p_mfc_write_info_v5(ctx, shm, P_B_FRAME_QP);
 	}
 	/* frame rate */
-	if (p->rc_frame && p->rc_framerate_denom)
-		mfc_write(dev, p->rc_framerate_num * 1000
-			/ p->rc_framerate_denom, S5P_FIMV_ENC_RC_FRAME_RATE);
+	if (p->rc_frame && p->codec.runtime.rc_framerate_denom)
+		mfc_write(dev, p->codec.runtime.rc_framerate_num * 1000
+		/ p->codec.runtime.rc_framerate_denom,
+		S5P_FIMV_ENC_RC_FRAME_RATE);
 	else
 		mfc_write(dev, 0, S5P_FIMV_ENC_RC_FRAME_RATE);
 	/* rate control config. */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 1bb487c..4b82338 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -587,6 +587,52 @@ static int s5p_mfc_set_slice_mode(struct s5p_mfc_ctx *ctx)
 	return 0;
 }
 
+static int s5p_mfc_set_runtime_enc_params(struct s5p_mfc_ctx *ctx,
+		struct s5p_mfc_runtime_enc_params *runtime_p)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+	unsigned int params_changed = 0;
+
+	if (runtime_p->params_changed & (1 << MFC_ENC_GOP_CONFIG_CHANGE)) {
+		params_changed |= (1 << S5P_FIMV_E_GOP_CONFIG_CHANGE_SHIFT_V6);
+		/* pictype: IDR period */
+		WRITEL((runtime_p->gop_size & 0xFFFF),
+			S5P_FIMV_E_GOP_CONFIG_V6);
+	}
+	if (runtime_p->params_changed & (1 << MFC_ENC_FRAME_RATE_CHANGE)) {
+		/* frame rate */
+		if (p->rc_frame && runtime_p->rc_framerate_num &&
+			runtime_p->rc_framerate_denom) {
+			params_changed |=
+				(1 << S5P_FIMV_E_FRAME_RATE_CHANGE_SHIFT_V6);
+			WRITEL((((runtime_p->rc_framerate_num & 0xFFFF) << 16) |
+				(runtime_p->rc_framerate_denom & 0xFFFF)),
+				S5P_FIMV_E_RC_FRAME_RATE_V6);
+		}
+	}
+	if (runtime_p->params_changed & (1 << MFC_ENC_BIT_RATE_CHANGE)) {
+		/* bit rate */
+		if (p->rc_frame) {
+			params_changed |=
+				(1 << S5P_FIMV_E_BIT_RATE_CHANGE_SHIFT_V6);
+			WRITEL(runtime_p->rc_bitrate,
+				S5P_FIMV_E_RC_BIT_RATE_V6);
+		}
+	}
+	if (runtime_p->params_changed & (1 << MFC_ENC_FRAME_INSERTION)) {
+		unsigned int reg = READL(S5P_FIMV_E_FRAME_INSERTION_V6);
+		reg &= ~0x3;
+		reg |= runtime_p->force_frame_type & 0x3;
+		WRITEL(reg, S5P_FIMV_E_FRAME_INSERTION_V6);
+	}
+
+	if (params_changed)
+		WRITEL(params_changed, S5P_FIMV_E_PARAM_CHANGE_V6);
+
+	return 0;
+}
+
 static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
@@ -611,10 +657,10 @@ static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx *ctx)
 		(((p->crop_top_offset / 16) & 0x2FF) << 10),
 		S5P_FIMV_E_FRAME_CROP_OFFSET_V6);
 
-	/* pictype : IDR period */
-	reg = 0;
-	reg |= p->gop_size & 0xFFFF;
-	WRITEL(reg, S5P_FIMV_E_GOP_CONFIG_V6);
+	/* send all runtime encoder parameters. */
+	p->codec.runtime.params_changed = ~0;
+	s5p_mfc_set_runtime_enc_params(ctx, &p->codec.runtime);
+	p->codec.runtime.params_changed = 0;
 
 	/* multi-slice control */
 	/* multi-slice MB number or bit size */
@@ -700,13 +746,6 @@ static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx *ctx)
 	reg |= ((p->rc_frame & 0x1) << 9);
 	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
 
-	/* bit rate */
-	if (p->rc_frame)
-		WRITEL(p->rc_bitrate,
-			S5P_FIMV_E_RC_BIT_RATE_V6);
-	else
-		WRITEL(1, S5P_FIMV_E_RC_BIT_RATE_V6);
-
 	/* reaction coefficient */
 	if (p->rc_frame) {
 		if (p->rc_reaction_coeff < TIGHT_CBR_MAX) /* tight CBR */
@@ -814,14 +853,6 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 		WRITEL(reg, S5P_FIMV_E_FIXED_PICTURE_QP_V6);
 	}
 
-	/* frame rate */
-	if (p->rc_frame && p->rc_framerate_num && p->rc_framerate_denom) {
-		reg = 0;
-		reg |= ((p->rc_framerate_num & 0xFFFF) << 16);
-		reg |= p->rc_framerate_denom & 0xFFFF;
-		WRITEL(reg, S5P_FIMV_E_RC_FRAME_RATE_V6);
-	}
-
 	/* vbv buffer size */
 	if (p->frame_skip_mode ==
 			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
@@ -1089,14 +1120,6 @@ static int s5p_mfc_set_enc_params_mpeg4(struct s5p_mfc_ctx *ctx)
 		WRITEL(reg, S5P_FIMV_E_FIXED_PICTURE_QP_V6);
 	}
 
-	/* frame rate */
-	if (p->rc_frame && p->rc_framerate_num && p->rc_framerate_denom) {
-		reg = 0;
-		reg |= ((p->rc_framerate_num & 0xFFFF) << 16);
-		reg |= p->rc_framerate_denom & 0xFFFF;
-		WRITEL(reg, S5P_FIMV_E_RC_FRAME_RATE_V6);
-	}
-
 	/* vbv buffer size */
 	if (p->frame_skip_mode ==
 			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
@@ -1161,14 +1184,6 @@ static int s5p_mfc_set_enc_params_h263(struct s5p_mfc_ctx *ctx)
 		WRITEL(reg, S5P_FIMV_E_FIXED_PICTURE_QP_V6);
 	}
 
-	/* frame rate */
-	if (p->rc_frame && p->rc_framerate_num && p->rc_framerate_denom) {
-		reg = 0;
-		reg |= ((p->rc_framerate_num & 0xFFFF) << 16);
-		reg |= p->rc_framerate_denom & 0xFFFF;
-		WRITEL(reg, S5P_FIMV_E_RC_FRAME_RATE_V6);
-	}
-
 	/* vbv buffer size */
 	if (p->frame_skip_mode ==
 			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
@@ -1214,14 +1229,6 @@ static int s5p_mfc_set_enc_params_vp8(struct s5p_mfc_ctx *ctx)
 	reg |= ((p->rc_mb & 0x1) << 8);
 	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
 
-	/* frame rate */
-	if (p->rc_frame && p->rc_framerate_num && p->rc_framerate_denom) {
-		reg = 0;
-		reg |= ((p->rc_framerate_num & 0xFFFF) << 16);
-		reg |= p->rc_framerate_denom & 0xFFFF;
-		WRITEL(reg, S5P_FIMV_E_RC_FRAME_RATE_V6);
-	}
-
 	/* vbv buffer size */
 	if (p->frame_skip_mode ==
 			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
@@ -1560,6 +1567,7 @@ static inline int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 	mfc_debug(2, "enc src c addr: 0x%08lx\n", src_c_addr);
 
 	s5p_mfc_set_enc_frame_buffer_v6(ctx, src_y_addr, src_c_addr);
+	s5p_mfc_set_runtime_enc_params(ctx, &src_mb->runtime_enc_params);
 
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_mb->flags |= MFC_BUF_FLAG_USED;
-- 
1.8.4

