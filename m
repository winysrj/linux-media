Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36967 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760034Ab2D0Jx1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 05:53:27 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3400F45U5CS200@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:53:36 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3400I6NU4Q93@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:53:24 +0100 (BST)
Date: Fri, 27 Apr 2012 11:53:06 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 13/13] s5p-fimc: Add color effect control
In-reply-to: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	sungchun.kang@samsung.com, subash.ramaswamy@linaro.org,
	s.nawrocki@samsung.com
Message-id: <1335520386-20835-14-git-send-email-s.nawrocki@samsung.com>
References: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for V4L2_CID_COLORFX control at the mem-to-mem and capture
video nodes.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   11 +--
 drivers/media/video/s5p-fimc/fimc-core.c    |  127 +++++++++++++++++++++------
 drivers/media/video/s5p-fimc/fimc-core.h    |   39 +++++---
 drivers/media/video/s5p-fimc/fimc-m2m.c     |    4 +-
 drivers/media/video/s5p-fimc/fimc-reg.c     |    4 +-
 drivers/media/video/s5p-fimc/fimc-reg.h     |    2 +-
 6 files changed, 137 insertions(+), 50 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 9a6224f..0d675a5 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -62,7 +62,7 @@ static int fimc_capture_hw_init(struct fimc_dev *fimc)
 		fimc_hw_set_mainscaler(ctx);
 		fimc_hw_set_target_format(ctx);
 		fimc_hw_set_rotation(ctx);
-		fimc_hw_set_effect(ctx, false);
+		fimc_hw_set_effect(ctx);
 		fimc_hw_set_output_path(ctx);
 		fimc_hw_set_out_dma(ctx);
 		if (fimc->variant->has_alpha)
@@ -164,6 +164,7 @@ static int fimc_capture_config_update(struct fimc_ctx *ctx)
 	fimc_hw_set_mainscaler(ctx);
 	fimc_hw_set_target_format(ctx);
 	fimc_hw_set_rotation(ctx);
+	fimc_hw_set_effect(ctx);
 	fimc_prepare_dma_offset(ctx, &ctx->d_frame);
 	fimc_hw_set_out_dma(ctx);
 	if (fimc->variant->has_alpha)
@@ -457,14 +458,14 @@ int fimc_capture_ctrls_create(struct fimc_dev *fimc)
 
 	if (WARN_ON(vid_cap->ctx == NULL))
 		return -ENXIO;
-	if (vid_cap->ctx->ctrls_rdy)
+	if (vid_cap->ctx->ctrls.ready)
 		return 0;
 
 	ret = fimc_ctrls_create(vid_cap->ctx);
-	if (ret || vid_cap->user_subdev_api)
+	if (ret || vid_cap->user_subdev_api || !vid_cap->ctx->ctrls.ready)
 		return ret;
 
-	return v4l2_ctrl_add_handler(&vid_cap->ctx->ctrl_handler,
+	return v4l2_ctrl_add_handler(&vid_cap->ctx->ctrls.handler,
 		    fimc->pipeline.subdevs[IDX_SENSOR]->ctrl_handler);
 }
 
@@ -1579,7 +1580,7 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
 	v4l2_info(v4l2_dev, "Registered %s as /dev/%s\n",
 		  vfd->name, video_device_node_name(vfd));
 
-	vfd->ctrl_handler = &ctx->ctrl_handler;
+	vfd->ctrl_handler = &ctx->ctrls.handler;
 	return 0;
 
 err_vd:
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index d5872e6..2540243 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -461,11 +461,53 @@ void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f)
 	    f->fmt->color, f->dma_offset.y_h, f->dma_offset.y_v);
 }
 
+int fimc_set_color_effect(struct fimc_ctx *ctx, enum v4l2_colorfx colorfx)
+{
+	struct fimc_effect *effect = &ctx->effect;
+
+	switch (colorfx) {
+	case V4L2_COLORFX_NONE:
+		effect->type = FIMC_REG_CIIMGEFF_FIN_BYPASS;
+		break;
+	case V4L2_COLORFX_BW:
+		effect->type = FIMC_REG_CIIMGEFF_FIN_ARBITRARY;
+		effect->pat_cb = 128;
+		effect->pat_cr = 128;
+		break;
+	case V4L2_COLORFX_SEPIA:
+		effect->type = FIMC_REG_CIIMGEFF_FIN_ARBITRARY;
+		effect->pat_cb = 115;
+		effect->pat_cr = 145;
+		break;
+	case V4L2_COLORFX_NEGATIVE:
+		effect->type = FIMC_REG_CIIMGEFF_FIN_NEGATIVE;
+		break;
+	case V4L2_COLORFX_EMBOSS:
+		effect->type = FIMC_REG_CIIMGEFF_FIN_EMBOSSING;
+		break;
+	case V4L2_COLORFX_ART_FREEZE:
+		effect->type = FIMC_REG_CIIMGEFF_FIN_ARTFREEZE;
+		break;
+	case V4L2_COLORFX_SILHOUETTE:
+		effect->type = FIMC_REG_CIIMGEFF_FIN_SILHOUETTE;
+		break;
+	case V4L2_COLORFX_ARBITRARY_CBCR:
+		effect->type = FIMC_REG_CIIMGEFF_FIN_ARBITRARY;
+		effect->pat_cb = ctx->ctrls.colorfx_cb->val;
+		effect->pat_cr = ctx->ctrls.colorfx_cr->val;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /*
  * V4L2 controls handling
  */
 #define ctrl_to_ctx(__ctrl) \
-	container_of((__ctrl)->handler, struct fimc_ctx, ctrl_handler)
+	container_of((__ctrl)->handler, struct fimc_ctx, ctrls.handler)
 
 static int __fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_ctrl *ctrl)
 {
@@ -505,7 +547,14 @@ static int __fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_ctrl *ctrl)
 	case V4L2_CID_ALPHA_COMPONENT:
 		ctx->d_frame.alpha = ctrl->val;
 		break;
+
+	case V4L2_CID_COLORFX:
+		ret = fimc_set_color_effect(ctx, ctrl->val);
+		if (ret)
+			return ret;
+		break;
 	}
+
 	ctx->state |= FIMC_PARAMS;
 	set_bit(ST_CAPT_APPLY_CFG, &fimc->state);
 	return 0;
@@ -532,69 +581,91 @@ int fimc_ctrls_create(struct fimc_ctx *ctx)
 {
 	struct fimc_variant *variant = ctx->fimc_dev->variant;
 	unsigned int max_alpha = fimc_get_alpha_mask(ctx->d_frame.fmt);
+	struct fimc_ctrls *ctrls = &ctx->ctrls;
+	struct v4l2_ctrl_handler *handler = &ctrls->handler;
 
-	if (ctx->ctrls_rdy)
+	if (ctx->ctrls.ready)
 		return 0;
-	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 4);
 
-	ctx->ctrl_rotate = v4l2_ctrl_new_std(&ctx->ctrl_handler, &fimc_ctrl_ops,
+	v4l2_ctrl_handler_init(handler, 7);
+
+	ctrls->rotate = v4l2_ctrl_new_std(handler, &fimc_ctrl_ops,
 					V4L2_CID_ROTATE, 0, 270, 90, 0);
-	ctx->ctrl_hflip = v4l2_ctrl_new_std(&ctx->ctrl_handler, &fimc_ctrl_ops,
+	ctrls->hflip = v4l2_ctrl_new_std(handler, &fimc_ctrl_ops,
 					V4L2_CID_HFLIP, 0, 1, 1, 0);
-	ctx->ctrl_vflip = v4l2_ctrl_new_std(&ctx->ctrl_handler, &fimc_ctrl_ops,
+	ctrls->vflip = v4l2_ctrl_new_std(handler, &fimc_ctrl_ops,
 					V4L2_CID_VFLIP, 0, 1, 1, 0);
+
 	if (variant->has_alpha)
-		ctx->ctrl_alpha = v4l2_ctrl_new_std(&ctx->ctrl_handler,
-				    &fimc_ctrl_ops, V4L2_CID_ALPHA_COMPONENT,
-				    0, max_alpha, 1, 0);
+		ctrls->alpha = v4l2_ctrl_new_std(handler, &fimc_ctrl_ops,
+					V4L2_CID_ALPHA_COMPONENT,
+					0, max_alpha, 1, 0);
 	else
-		ctx->ctrl_alpha = NULL;
+		ctrls->alpha = NULL;
+
+	ctrls->colorfx = v4l2_ctrl_new_std_menu(handler, &fimc_ctrl_ops,
+				V4L2_CID_COLORFX, V4L2_COLORFX_ARBITRARY_CBCR,
+				~0x983f, V4L2_COLORFX_NONE);
+
+	ctrls->colorfx_cb = v4l2_ctrl_new_std(handler, &fimc_ctrl_ops,
+				V4L2_CID_BLUE_BALANCE, 0, 255, 1, 127);
+
+	ctrls->colorfx_cr = v4l2_ctrl_new_std(handler, &fimc_ctrl_ops,
+				V4L2_CID_RED_BALANCE, 0, 255, 1, 127);
 
-	ctx->ctrls_rdy = ctx->ctrl_handler.error == 0;
+	ctx->effect.type = FIMC_REG_CIIMGEFF_FIN_BYPASS;
 
-	return ctx->ctrl_handler.error;
+	if (!handler->error) {
+		v4l2_ctrl_cluster(3, &ctrls->colorfx);
+		ctrls->ready = true;
+	}
+
+	return handler->error;
 }
 
 void fimc_ctrls_delete(struct fimc_ctx *ctx)
 {
-	if (ctx->ctrls_rdy) {
-		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
-		ctx->ctrls_rdy = false;
-		ctx->ctrl_alpha = NULL;
+	struct fimc_ctrls *ctrls = &ctx->ctrls;
+
+	if (ctrls->ready) {
+		v4l2_ctrl_handler_free(&ctrls->handler);
+		ctrls->ready = false;
+		ctrls->alpha = NULL;
 	}
 }
 
 void fimc_ctrls_activate(struct fimc_ctx *ctx, bool active)
 {
 	unsigned int has_alpha = ctx->d_frame.fmt->flags & FMT_HAS_ALPHA;
+	struct fimc_ctrls *ctrls = &ctx->ctrls;
 
-	if (!ctx->ctrls_rdy)
+	if (!ctrls->ready)
 		return;
 
-	mutex_lock(&ctx->ctrl_handler.lock);
-	v4l2_ctrl_activate(ctx->ctrl_rotate, active);
-	v4l2_ctrl_activate(ctx->ctrl_hflip, active);
-	v4l2_ctrl_activate(ctx->ctrl_vflip, active);
-	if (ctx->ctrl_alpha)
-		v4l2_ctrl_activate(ctx->ctrl_alpha, active && has_alpha);
+	mutex_lock(&ctrls->handler.lock);
+	v4l2_ctrl_activate(ctrls->rotate, active);
+	v4l2_ctrl_activate(ctrls->hflip, active);
+	v4l2_ctrl_activate(ctrls->vflip, active);
+	if (ctrls->alpha)
+		v4l2_ctrl_activate(ctrls->alpha, active && has_alpha);
 
 	if (active) {
-		ctx->rotation = ctx->ctrl_rotate->val;
-		ctx->hflip    = ctx->ctrl_hflip->val;
-		ctx->vflip    = ctx->ctrl_vflip->val;
+		ctx->rotation = ctrls->rotate->val;
+		ctx->hflip    = ctrls->hflip->val;
+		ctx->vflip    = ctrls->vflip->val;
 	} else {
 		ctx->rotation = 0;
 		ctx->hflip    = 0;
 		ctx->vflip    = 0;
 	}
-	mutex_unlock(&ctx->ctrl_handler.lock);
+	mutex_unlock(&ctrls->handler.lock);
 }
 
 /* Update maximum value of the alpha color control */
 void fimc_alpha_ctrl_update(struct fimc_ctx *ctx)
 {
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct v4l2_ctrl *ctrl = ctx->ctrl_alpha;
+	struct v4l2_ctrl *ctrl = ctx->ctrls.alpha;
 
 	if (ctrl == NULL || !fimc->variant->has_alpha)
 		return;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index a4fe52c..90f2cbf 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -444,6 +444,31 @@ struct fimc_dev {
 };
 
 /**
+ * @handler:	controls handler
+ * @colorfx:	image effect control
+ * @colorfx_cb:	arbitrary image effect CB coefficient control
+ * @colorfx_cr:	arbitrary image effect CR coefficient control
+ * @rotate:	image rotation control
+ * @hflip:	horizontal flip control
+ * @vflip:	vertical flip control
+ * @alpha:	RGB alpha control
+ * @ready:	true if the control handler is initialized
+ */
+struct fimc_ctrls {
+	struct v4l2_ctrl_handler handler;
+	struct {
+		struct v4l2_ctrl *colorfx;
+		struct v4l2_ctrl *colorfx_cb;
+		struct v4l2_ctrl *colorfx_cr;
+	};
+	struct v4l2_ctrl *rotate;
+	struct v4l2_ctrl *hflip;
+	struct v4l2_ctrl *vflip;
+	struct v4l2_ctrl *alpha;
+	bool ready;
+};
+
+/**
  * fimc_ctx - the device context data
  * @s_frame:		source frame properties
  * @d_frame:		destination frame properties
@@ -463,12 +488,7 @@ struct fimc_dev {
  * @fimc_dev:		the FIMC device this context applies to
  * @m2m_ctx:		memory-to-memory device context
  * @fh:			v4l2 file handle
- * @ctrl_handler:	v4l2 controls handler
- * @ctrl_rotate		image rotation control
- * @ctrl_hflip		horizontal flip control
- * @ctrl_vflip		vertical flip control
- * @ctrl_alpha		RGB alpha control
- * @ctrls_rdy:		true if the control handler is initialized
+ * @ctrls:		v4l2 controls structure
  */
 struct fimc_ctx {
 	struct fimc_frame	s_frame;
@@ -489,12 +509,7 @@ struct fimc_ctx {
 	struct fimc_dev		*fimc_dev;
 	struct v4l2_m2m_ctx	*m2m_ctx;
 	struct v4l2_fh		fh;
-	struct v4l2_ctrl_handler ctrl_handler;
-	struct v4l2_ctrl	*ctrl_rotate;
-	struct v4l2_ctrl	*ctrl_hflip;
-	struct v4l2_ctrl	*ctrl_vflip;
-	struct v4l2_ctrl	*ctrl_alpha;
-	bool			ctrls_rdy;
+	struct fimc_ctrls	ctrls;
 };
 
 #define fh_to_ctx(__fh) container_of(__fh, struct fimc_ctx, fh)
diff --git a/drivers/media/video/s5p-fimc/fimc-m2m.c b/drivers/media/video/s5p-fimc/fimc-m2m.c
index 0f15b26..117a167 100644
--- a/drivers/media/video/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/video/s5p-fimc/fimc-m2m.c
@@ -150,7 +150,7 @@ static void fimc_device_run(void *priv)
 		fimc_hw_set_mainscaler(ctx);
 		fimc_hw_set_target_format(ctx);
 		fimc_hw_set_rotation(ctx);
-		fimc_hw_set_effect(ctx, false);
+		fimc_hw_set_effect(ctx);
 		fimc_hw_set_out_dma(ctx);
 		if (fimc->variant->has_alpha)
 			fimc_hw_set_rgb_alpha(ctx);
@@ -669,7 +669,7 @@ static int fimc_m2m_open(struct file *file)
 		goto error_fh;
 
 	/* Use separate control handler per file handle */
-	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
+	ctx->fh.ctrl_handler = &ctx->ctrls.handler;
 	file->private_data = &ctx->fh;
 	v4l2_fh_add(&ctx->fh);
 
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 78c95d7..1fc4ce8 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -368,13 +368,13 @@ void fimc_hw_en_capture(struct fimc_ctx *ctx)
 	writel(cfg, dev->regs + FIMC_REG_CIIMGCPT);
 }
 
-void fimc_hw_set_effect(struct fimc_ctx *ctx, bool active)
+void fimc_hw_set_effect(struct fimc_ctx *ctx)
 {
 	struct fimc_dev *dev = ctx->fimc_dev;
 	struct fimc_effect *effect = &ctx->effect;
 	u32 cfg = 0;
 
-	if (active) {
+	if (effect->type != FIMC_REG_CIIMGEFF_FIN_BYPASS) {
 		cfg |= FIMC_REG_CIIMGEFF_IE_SC_AFTER |
 			FIMC_REG_CIIMGEFF_IE_ENABLE;
 		cfg |= effect->type;
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.h b/drivers/media/video/s5p-fimc/fimc-reg.h
index a612f07..d18ecbb 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.h
+++ b/drivers/media/video/s5p-fimc/fimc-reg.h
@@ -288,7 +288,7 @@ void fimc_hw_en_irq(struct fimc_dev *fimc, int enable);
 void fimc_hw_set_prescaler(struct fimc_ctx *ctx);
 void fimc_hw_set_mainscaler(struct fimc_ctx *ctx);
 void fimc_hw_en_capture(struct fimc_ctx *ctx);
-void fimc_hw_set_effect(struct fimc_ctx *ctx, bool active);
+void fimc_hw_set_effect(struct fimc_ctx *ctx);
 void fimc_hw_set_rgb_alpha(struct fimc_ctx *ctx);
 void fimc_hw_set_in_dma(struct fimc_ctx *ctx);
 void fimc_hw_set_input_path(struct fimc_ctx *ctx);
-- 
1.7.10

