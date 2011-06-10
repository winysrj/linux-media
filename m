Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58899 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758039Ab1FJShN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 14:37:13 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 10 Jun 2011 20:36:57 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 16/19] s5p-fimc: Add support for camera capture in JPEG
 format
In-reply-to: <1307731020-7100-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1307731020-7100-17-git-send-email-s.nawrocki@samsung.com>
References: <1307731020-7100-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add support for transparent DMA transfer of JPEG data with MIPI-CSI2
USER1 format. In JPEG mode the color effect, scaling and cropping
is not supported. Same applies to image rotation and flip thus those
controls are marked as inactive when V4L2_PIX_FMT_JPEG pixelformat
is selected.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   22 +++++++-
 drivers/media/video/s5p-fimc/fimc-core.c    |   73 ++++++++++++++------------
 drivers/media/video/s5p-fimc/fimc-core.h    |    7 ++-
 drivers/media/video/s5p-fimc/fimc-reg.c     |   31 ++++++++----
 drivers/media/video/s5p-fimc/regs-fimc.h    |    8 +--
 5 files changed, 87 insertions(+), 54 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index f3efdbf..d9f5829 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -65,7 +65,7 @@ static int fimc_start_capture(struct fimc_dev *fimc)
 		fimc_hw_set_mainscaler(ctx);
 		fimc_hw_set_target_format(ctx);
 		fimc_hw_set_rotation(ctx);
-		fimc_hw_set_effect(ctx);
+		fimc_hw_set_effect(ctx, false);
 		fimc_hw_set_output_path(ctx);
 		fimc_hw_set_out_dma(ctx);
 		clear_bit(ST_CAPT_APPLY_CFG, &fimc->state);
@@ -519,6 +519,17 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 	return fimc_try_fmt_mplane(ctx, f);
 }
 
+static void fimc_capture_mark_jpeg_xfer(struct fimc_ctx *ctx, bool jpeg)
+{
+	ctx->scaler.enabled = !jpeg;
+	fimc_ctrls_activate(ctx, !jpeg);
+
+	if (jpeg)
+		set_bit(ST_CAPT_JPEG, &ctx->fimc_dev->state);
+	else
+		clear_bit(ST_CAPT_JPEG, &ctx->fimc_dev->state);
+}
+
 static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
 				 struct v4l2_format *f)
 {
@@ -553,6 +564,9 @@ static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
 			(pix->width * pix->height * frame->fmt->depth[i]) >> 3;
 	}
 
+	/* Switch to the transparent DMA transfer mode if required */
+	fimc_capture_mark_jpeg_xfer(ctx, fimc_fmt_is_jpeg(frame->fmt->color));
+
 	fimc_fill_frame(frame, f);
 	ctx->state |= FIMC_DST_FMT;
 
@@ -781,7 +795,7 @@ static int fimc_cap_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 
 	f = &ctx->s_frame;
 	/* Check for the pixel scaling ratio when cropping input image. */
-	ret = fimc_check_scaler_ratio(cr->c.width, cr->c.height,
+	ret = fimc_check_scaler_ratio(ctx, cr->c.width, cr->c.height,
 				      ctx->d_frame.width, ctx->d_frame.height,
 				      ctx->rotation);
 	if (ret) {
@@ -981,6 +995,8 @@ static int fimc_subdev_set_fmt(struct v4l2_subdev *sd,
 		*mf = fmt->format;
 		return 0;
 	}
+	fimc_capture_mark_jpeg_xfer(ctx, fimc_fmt_is_jpeg(ffmt->color));
+
 	ff = fmt->pad == FIMC_SD_PAD_SINK ?
 		&ctx->s_frame : &ctx->d_frame;
 
@@ -1046,7 +1062,7 @@ static int fimc_capture_try_crop(struct fimc_ctx *ctx, struct v4l2_rect *r,
 	u32 min_sz;
 
 	/* In JPEG transparent transfer mode cropping is not supported */
-	if (fimc_fmt_is_jpeg(sink->fmt->color)) {
+	if (fimc_fmt_is_jpeg(ctx->d_frame.fmt->color)) {
 		r->width  = sink->f_width;
 		r->height = sink->f_height;
 		r->left   = r->top = 0;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 6d5d3e1..4261822 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -160,22 +160,28 @@ static struct fimc_fmt fimc_formats[] = {
 		.memplanes	= 2,
 		.colplanes	= 2,
 		.flags		= FMT_FLAGS_M2M,
+	}, {
+		.name		= "JPEG encoded data",
+		.fourcc		= V4L2_PIX_FMT_JPEG,
+		.color		= S5P_FIMC_JPEG,
+		.depth		= { 8 },
+		.memplanes	= 1,
+		.colplanes	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_JPEG_1X8,
+		.flags		= FMT_FLAGS_CAM,
 	},
 };
 
-int fimc_check_scaler_ratio(int sw, int sh, int dw, int dh, int rot)
+int fimc_check_scaler_ratio(struct fimc_ctx *ctx, int sw, int sh,
+			    int dw, int dh, int rotation)
 {
-	int tx, ty;
+	if (rotation == 90 || rotation == 270)
+		swap(dw, dh);
 
-	if (rot == 90 || rot == 270) {
-		ty = dw;
-		tx = dh;
-	} else {
-		tx = dw;
-		ty = dh;
-	}
+	if (!ctx->scaler.enabled)
+		return (sw == dw && sh == dh) ? 0 : -EINVAL;
 
-	if ((sw >= SCALER_MAX_HRATIO * tx) || (sh >= SCALER_MAX_VRATIO * ty))
+	if ((sw >= SCALER_MAX_HRATIO * dw) || (sh >= SCALER_MAX_VRATIO * dh))
 		return -EINVAL;
 
 	return 0;
@@ -311,7 +317,7 @@ static int stop_streaming(struct vb2_queue *q)
 	return 0;
 }
 
-void fimc_capture_irq_handler(struct fimc_dev *fimc)
+void fimc_capture_irq_handler(struct fimc_dev *fimc, bool rel_buf)
 {
 	struct fimc_vid_cap *cap = &fimc->vid_cap;
 	struct fimc_vid_buffer *v_buf;
@@ -319,7 +325,7 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc)
 	struct timespec ts;
 
 	if (!list_empty(&cap->active_buf_q) &&
-	    test_bit(ST_CAPT_RUN, &fimc->state)) {
+	    test_bit(ST_CAPT_RUN, &fimc->state) && rel_buf) {
 		ktime_get_real_ts(&ts);
 
 		v_buf = active_queue_pop(cap);
@@ -354,7 +360,8 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc)
 	}
 
 	if (cap->active_buf_cnt == 0) {
-		clear_bit(ST_CAPT_RUN, &fimc->state);
+		if (rel_buf)
+			clear_bit(ST_CAPT_RUN, &fimc->state);
 
 		if (++cap->buf_index >= FIMC_MAX_OUT_BUFS)
 			cap->buf_index = 0;
@@ -401,14 +408,12 @@ static irqreturn_t fimc_irq_handler(int irq, void *priv)
 			spin_unlock(&ctx->slock);
 		}
 		return IRQ_HANDLED;
-	} else {
-		if (test_bit(ST_CAPT_PEND, &fimc->state)) {
-			fimc_capture_irq_handler(fimc);
-
-			if (cap->active_buf_cnt == 1) {
-				fimc_deactivate_capture(fimc);
-				clear_bit(ST_CAPT_STREAM, &fimc->state);
-			}
+	} else if (test_bit(ST_CAPT_PEND, &fimc->state)) {
+		fimc_capture_irq_handler(fimc,
+				 !test_bit(ST_CAPT_JPEG, &fimc->state));
+		if (cap->active_buf_cnt == 1) {
+			fimc_deactivate_capture(fimc);
+			clear_bit(ST_CAPT_STREAM, &fimc->state);
 		}
 	}
 out:
@@ -580,9 +585,6 @@ int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags)
 		fimc_set_yuv_order(ctx);
 	}
 
-	/* Input DMA mode is not allowed when the scaler is disabled. */
-	ctx->scaler.enabled = 1;
-
 	if (flags & FIMC_SRC_ADDR) {
 		vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
 		ret = fimc_prepare_addr(ctx, vb, s_frame, &s_frame->paddr);
@@ -642,7 +644,7 @@ static void fimc_dma_run(void *priv)
 		fimc_hw_set_mainscaler(ctx);
 		fimc_hw_set_target_format(ctx);
 		fimc_hw_set_rotation(ctx);
-		fimc_hw_set_effect(ctx);
+		fimc_hw_set_effect(ctx, false);
 	}
 
 	fimc_hw_set_output_path(ctx);
@@ -754,6 +756,9 @@ static int fimc_s_ctrl(struct v4l2_ctrl *ctrl)
 	unsigned long flags;
 	int ret = 0;
 
+	if (ctrl->flags & V4L2_CTRL_FLAG_INACTIVE)
+		return 0;
+
 	switch (ctrl->id) {
 	case V4L2_CID_HFLIP:
 		spin_lock_irqsave(&ctx->slock, flags);
@@ -768,7 +773,7 @@ static int fimc_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_ROTATE:
 		if (fimc_capture_pending(fimc) ||
 		    fimc_ctx_state_is_set(FIMC_DST_FMT | FIMC_SRC_FMT, ctx)) {
-			ret = fimc_check_scaler_ratio(ctx->s_frame.width,
+			ret = fimc_check_scaler_ratio(ctx, ctx->s_frame.width,
 					ctx->s_frame.height, ctx->d_frame.width,
 					ctx->d_frame.height, ctrl->val);
 		}
@@ -1084,6 +1089,8 @@ static int fimc_m2m_s_fmt_mplane(struct file *file, void *fh,
 
 	fimc_fill_frame(frame, f);
 
+	ctx->scaler.enabled = 1;
+
 	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		fimc_ctx_state_lock_set(FIMC_PARAMS | FIMC_DST_FMT, ctx);
 	else
@@ -1265,15 +1272,13 @@ static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 	/* Check to see if scaling ratio is within supported range */
 	if (fimc_ctx_state_is_set(FIMC_DST_FMT | FIMC_SRC_FMT, ctx)) {
 		if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-			ret = fimc_check_scaler_ratio(cr->c.width, cr->c.height,
-						      ctx->d_frame.width,
-						      ctx->d_frame.height,
-						      ctx->rotation);
+			ret = fimc_check_scaler_ratio(ctx, cr->c.width,
+					cr->c.height, ctx->d_frame.width,
+					ctx->d_frame.height, ctx->rotation);
 		} else {
-			ret = fimc_check_scaler_ratio(ctx->s_frame.width,
-						      ctx->s_frame.height,
-						      cr->c.width, cr->c.height,
-						      ctx->rotation);
+			ret = fimc_check_scaler_ratio(ctx, ctx->s_frame.width,
+					ctx->s_frame.height, cr->c.width,
+					cr->c.height, ctx->rotation);
 		}
 		if (ret) {
 			v4l2_err(fimc->m2m.vfd, "Out of scaler range\n");
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 3a388b0..ca8d357 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -66,6 +66,7 @@ enum fimc_dev_flags {
 	ST_CAPT_SHUT,
 	ST_CAPT_INUSE,
 	ST_CAPT_APPLY_CFG,
+	ST_CAPT_JPEG,
 };
 
 #define fimc_m2m_active(dev) test_bit(ST_M2M_RUN, &(dev)->state)
@@ -646,7 +647,7 @@ void fimc_hw_en_irq(struct fimc_dev *fimc, int enable);
 void fimc_hw_set_prescaler(struct fimc_ctx *ctx);
 void fimc_hw_set_mainscaler(struct fimc_ctx *ctx);
 void fimc_hw_en_capture(struct fimc_ctx *ctx);
-void fimc_hw_set_effect(struct fimc_ctx *ctx);
+void fimc_hw_set_effect(struct fimc_ctx *ctx, bool active);
 void fimc_hw_set_in_dma(struct fimc_ctx *ctx);
 void fimc_hw_set_input_path(struct fimc_ctx *ctx);
 void fimc_hw_set_output_path(struct fimc_ctx *ctx);
@@ -676,7 +677,8 @@ struct fimc_fmt *fimc_find_format(struct v4l2_format *f,
 				  struct v4l2_mbus_framefmt *mf,
 				  unsigned int mask, int index);
 
-int fimc_check_scaler_ratio(int sw, int sh, int dw, int dh, int rot);
+int fimc_check_scaler_ratio(struct fimc_ctx *ctx, int sw, int sh,
+			    int dw, int dh, int rotation);
 int fimc_set_scaler_info(struct fimc_ctx *ctx);
 int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags);
 int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
@@ -684,6 +686,7 @@ int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f);
 void fimc_set_yuv_order(struct fimc_ctx *ctx);
 void fimc_fill_frame(struct fimc_frame *frame, struct v4l2_format *f);
+void fimc_capture_irq_handler(struct fimc_dev *fimc, bool done);
 
 int fimc_register_m2m_device(struct fimc_dev *fimc,
 			     struct v4l2_device *v4l2_dev);
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index a1fff02..2a1ae51 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -352,17 +352,19 @@ void fimc_hw_en_capture(struct fimc_ctx *ctx)
 	writel(cfg | S5P_CIIMGCPT_IMGCPTEN, dev->regs + S5P_CIIMGCPT);
 }
 
-void fimc_hw_set_effect(struct fimc_ctx *ctx)
+void fimc_hw_set_effect(struct fimc_ctx *ctx, bool active)
 {
 	struct fimc_dev *dev = ctx->fimc_dev;
 	struct fimc_effect *effect = &ctx->effect;
-	u32 cfg = (S5P_CIIMGEFF_IE_ENABLE | S5P_CIIMGEFF_IE_SC_AFTER);
-
-	cfg |= effect->type;
+	u32 cfg = 0;
 
-	if (effect->type == S5P_FIMC_EFFECT_ARBITRARY) {
-		cfg |= S5P_CIIMGEFF_PAT_CB(effect->pat_cb);
-		cfg |= S5P_CIIMGEFF_PAT_CR(effect->pat_cr);
+	if (active) {
+		cfg |= S5P_CIIMGEFF_IE_SC_AFTER | S5P_CIIMGEFF_IE_ENABLE;
+		cfg |= effect->type;
+		if (effect->type == S5P_FIMC_EFFECT_ARBITRARY) {
+			cfg |= S5P_CIIMGEFF_PAT_CB(effect->pat_cb);
+			cfg |= S5P_CIIMGEFF_PAT_CR(effect->pat_cr);
+		}
 	}
 
 	writel(cfg, dev->regs + S5P_CIIMGEFF);
@@ -592,6 +594,9 @@ int fimc_hw_set_camera_source(struct fimc_dev *fimc,
 			else if (bus_width == 16)
 				cfg |= S5P_CISRCFMT_ITU601_16BIT;
 		} /* else defaults to ITU-R BT.656 8-bit */
+	} else if (cam->bus_type == FIMC_MIPI_CSI2) {
+		if (fimc_fmt_is_jpeg(f->fmt->color))
+			cfg |= S5P_CISRCFMT_ITU601_8BIT;
 	}
 
 	cfg |= S5P_CISRCFMT_HSIZE(f->o_width) | S5P_CISRCFMT_VSIZE(f->o_height);
@@ -633,7 +638,7 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 	/* Select ITU B interface, disable Writeback path and test pattern. */
 	cfg &= ~(S5P_CIGCTRL_TESTPAT_MASK | S5P_CIGCTRL_SELCAM_ITU_A |
 		S5P_CIGCTRL_SELCAM_MIPI | S5P_CIGCTRL_CAMIF_SELWB |
-		S5P_CIGCTRL_SELCAM_MIPI_A);
+		S5P_CIGCTRL_SELCAM_MIPI_A | S5P_CIGCTRL_CAM_JPEG);
 
 	if (cam->bus_type == FIMC_MIPI_CSI2) {
 		cfg |= S5P_CIGCTRL_SELCAM_MIPI;
@@ -642,9 +647,15 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 			cfg |= S5P_CIGCTRL_SELCAM_MIPI_A;
 
 		/* TODO: add remaining supported formats. */
-		if (vid_cap->mf.code == V4L2_MBUS_FMT_VYUY8_2X8) {
+		switch (vid_cap->mf.code) {
+		case V4L2_MBUS_FMT_VYUY8_2X8:
 			tmp = S5P_CSIIMGFMT_YCBCR422_8BIT;
-		} else {
+			break;
+		case V4L2_MBUS_FMT_JPEG_1X8:
+			tmp = S5P_CSIIMGFMT_USER(1);
+			cfg |= S5P_CIGCTRL_CAM_JPEG;
+			break;
+		default:
 			v4l2_err(fimc->vid_cap.vfd,
 				 "Not supported camera pixel format: %d",
 				 vid_cap->mf.code);
diff --git a/drivers/media/video/s5p-fimc/regs-fimc.h b/drivers/media/video/s5p-fimc/regs-fimc.h
index 0fea3e6..94d2302 100644
--- a/drivers/media/video/s5p-fimc/regs-fimc.h
+++ b/drivers/media/video/s5p-fimc/regs-fimc.h
@@ -54,6 +54,7 @@
 #define S5P_CIGCTRL_IRQ_CLR		(1 << 19)
 #define S5P_CIGCTRL_IRQ_ENABLE		(1 << 16)
 #define S5P_CIGCTRL_SHDW_DISABLE	(1 << 12)
+#define S5P_CIGCTRL_CAM_JPEG		(1 << 8)
 #define S5P_CIGCTRL_SELCAM_MIPI_A	(1 << 7)
 #define S5P_CIGCTRL_CAMIF_SELWB		(1 << 6)
 /* 0 - ITU601; 1 - ITU709 */
@@ -184,7 +185,6 @@
 
 /* Image effect */
 #define S5P_CIIMGEFF			0xd0
-#define S5P_CIIMGEFF_IE_DISABLE		(0 << 30)
 #define S5P_CIIMGEFF_IE_ENABLE		(1 << 30)
 #define S5P_CIIMGEFF_IE_SC_BEFORE	(0 << 29)
 #define S5P_CIIMGEFF_IE_SC_AFTER	(1 << 29)
@@ -286,10 +286,8 @@
 #define S5P_CSIIMGFMT_RAW8		0x2a
 #define S5P_CSIIMGFMT_RAW10		0x2b
 #define S5P_CSIIMGFMT_RAW12		0x2c
-#define S5P_CSIIMGFMT_USER1		0x30
-#define S5P_CSIIMGFMT_USER2		0x31
-#define S5P_CSIIMGFMT_USER3		0x32
-#define S5P_CSIIMGFMT_USER4		0x33
+/* User defined formats. x = 0...16. */
+#define S5P_CSIIMGFMT_USER(x)		(0x30 + x - 1)
 
 /* Output frame buffer sequence mask */
 #define S5P_CIFCNTSEQ			0x1FC
-- 
1.7.5.4

