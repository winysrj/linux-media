Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:50394 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab1BXOjc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 09:39:32 -0500
Date: Thu, 24 Feb 2011 15:33:50 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/7] s5p-fimc: Prevent hanging on device close and fix the
	locking
In-reply-to: <1298558034-10768-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, s.nawrocki@samsung.com
Message-id: <1298558034-10768-4-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1298558034-10768-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Rework the locking in m2m driver to assure proper operation on SMP systems.

When job_abort or stop_streaming was called to immediately shutdown
a memory-to-memory transaction video buffers scheduled for processing
were never returned to vb2 and v4l2_m2m_job_finish was not called
which led to hanging.

Correct this and also return the unprocessed buffers to vb2 marking
them as erroneous, in case the end of frame interrupt do not occur.

Reported-by: Sewoon Park <seuni.park@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    9 +-
 drivers/media/video/s5p-fimc/fimc-core.c    |  199 ++++++++++++++-------------
 drivers/media/video/s5p-fimc/fimc-core.h    |   44 +++++--
 3 files changed, 137 insertions(+), 115 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 2d8002c..9aa767e 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -252,14 +252,9 @@ static int stop_streaming(struct vb2_queue *q)
 {
 	struct fimc_ctx *ctx = q->drv_priv;
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	unsigned long flags;
 
-	spin_lock_irqsave(&fimc->slock, flags);
-	if (!fimc_capture_running(fimc) && !fimc_capture_pending(fimc)) {
-		spin_unlock_irqrestore(&fimc->slock, flags);
+	if (!fimc_capture_active(fimc))
 		return -EINVAL;
-	}
-	spin_unlock_irqrestore(&fimc->slock, flags);
 
 	return fimc_stop_capture(fimc);
 }
@@ -770,7 +765,7 @@ static int fimc_cap_s_crop(struct file *file, void *fh,
 				      ctx->d_frame.width, ctx->d_frame.height,
 				      ctx->rotation);
 	if (ret) {
-		v4l2_err(&fimc->vid_cap.v4l2_dev, "Out of the scaler range");
+		v4l2_err(&fimc->vid_cap.v4l2_dev, "Out of the scaler range\n");
 		return ret;
 	}
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 461f1f2..f20e286 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -307,24 +307,57 @@ int fimc_set_scaler_info(struct fimc_ctx *ctx)
 	return 0;
 }
 
-static int stop_streaming(struct vb2_queue *q)
+static void fimc_m2m_job_finish(struct fimc_ctx *ctx, int vb_state)
 {
-	struct fimc_ctx *ctx = q->drv_priv;
+	struct vb2_buffer *src_vb, *dst_vb;
 	struct fimc_dev *fimc = ctx->fimc_dev;
 
+	if (!ctx || !ctx->m2m_ctx)
+		return;
+
+	src_vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+	dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+
+	if (src_vb && dst_vb) {
+		v4l2_m2m_buf_done(src_vb, vb_state);
+		v4l2_m2m_buf_done(dst_vb, vb_state);
+		v4l2_m2m_job_finish(fimc->m2m.m2m_dev, ctx->m2m_ctx);
+	}
+}
+
+/* Complete the transaction which has been scheduled for execution. */
+static void fimc_m2m_shutdown(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	int ret;
+
 	if (!fimc_m2m_pending(fimc))
-		return 0;
+		return;
 
-	set_bit(ST_M2M_SHUT, &fimc->state);
+	fimc_ctx_state_lock_set(FIMC_CTX_SHUT, ctx);
 
-	wait_event_timeout(fimc->irq_queue,
-			   !test_bit(ST_M2M_SHUT, &fimc->state),
+	ret = wait_event_timeout(fimc->irq_queue,
+			   !fimc_ctx_state_is_set(FIMC_CTX_SHUT, ctx),
 			   FIMC_SHUTDOWN_TIMEOUT);
+	/*
+	 * In case of a timeout the buffers are not released in the interrupt
+	 * handler so return them here with the error flag set, if there are
+	 * any on the queue.
+	 */
+	if (ret == 0)
+		fimc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
+}
+
+static int stop_streaming(struct vb2_queue *q)
+{
+	struct fimc_ctx *ctx = q->drv_priv;
+
+	fimc_m2m_shutdown(ctx);
 
 	return 0;
 }
 
-static void fimc_capture_handler(struct fimc_dev *fimc)
+static void fimc_capture_irq_handler(struct fimc_dev *fimc)
 {
 	struct fimc_vid_cap *cap = &fimc->vid_cap;
 	struct fimc_vid_buffer *v_buf;
@@ -373,35 +406,30 @@ static irqreturn_t fimc_isr(int irq, void *priv)
 {
 	struct fimc_dev *fimc = priv;
 	struct fimc_vid_cap *cap = &fimc->vid_cap;
+	struct fimc_ctx *ctx;
 
-	BUG_ON(!fimc);
 	fimc_hw_clear_irq(fimc);
 
-	spin_lock(&fimc->slock);
+	if (test_and_clear_bit(ST_M2M_PEND, &fimc->state)) {
+		ctx = v4l2_m2m_get_curr_priv(fimc->m2m.m2m_dev);
+		if (ctx != NULL) {
+			fimc_m2m_job_finish(ctx, VB2_BUF_STATE_DONE);
 
-	if (test_and_clear_bit(ST_M2M_SHUT, &fimc->state)) {
-		wake_up(&fimc->irq_queue);
-		goto isr_unlock;
-	} else if (test_and_clear_bit(ST_M2M_PEND, &fimc->state)) {
-		struct vb2_buffer *src_vb, *dst_vb;
-		struct fimc_ctx *ctx = v4l2_m2m_get_curr_priv(fimc->m2m.m2m_dev);
-
-		if (!ctx || !ctx->m2m_ctx)
-			goto isr_unlock;
-
-		src_vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
-		dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
-		if (src_vb && dst_vb) {
-			v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
-			v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
-			v4l2_m2m_job_finish(fimc->m2m.m2m_dev, ctx->m2m_ctx);
+			spin_lock(&ctx->slock);
+			if (ctx->state & FIMC_CTX_SHUT) {
+				ctx->state &= ~FIMC_CTX_SHUT;
+				wake_up(&fimc->irq_queue);
+			}
+			spin_unlock(&ctx->slock);
 		}
-		goto isr_unlock;
 
+		return IRQ_HANDLED;
 	}
 
+	spin_lock(&fimc->slock);
+
 	if (test_bit(ST_CAPT_RUN, &fimc->state))
-		fimc_capture_handler(fimc);
+		fimc_capture_irq_handler(fimc);
 	else if (test_bit(ST_CAPT_PEND, &fimc->state))
 		set_bit(ST_CAPT_RUN, &fimc->state);
 
@@ -410,7 +438,6 @@ static irqreturn_t fimc_isr(int irq, void *priv)
 		clear_bit(ST_CAPT_STREAM, &fimc->state);
 	}
 
-isr_unlock:
 	spin_unlock(&fimc->slock);
 	return IRQ_HANDLED;
 }
@@ -614,26 +641,26 @@ static void fimc_dma_run(void *priv)
 
 	ctx->state |= (FIMC_SRC_ADDR | FIMC_DST_ADDR);
 	ret = fimc_prepare_config(ctx, ctx->state);
-	if (ret) {
-		err("Wrong parameters");
+	if (ret)
 		goto dma_unlock;
-	}
+
 	/* Reconfigure hardware if the context has changed. */
 	if (fimc->m2m.ctx != ctx) {
 		ctx->state |= FIMC_PARAMS;
 		fimc->m2m.ctx = ctx;
 	}
 
+	spin_lock(&fimc->slock);
 	fimc_hw_set_input_addr(fimc, &ctx->s_frame.paddr);
 
 	if (ctx->state & FIMC_PARAMS) {
 		fimc_hw_set_input_path(ctx);
 		fimc_hw_set_in_dma(ctx);
-		if (fimc_set_scaler_info(ctx)) {
-			err("Scaler setup error");
+		ret = fimc_set_scaler_info(ctx);
+		if (ret) {
+			spin_unlock(&fimc->slock);
 			goto dma_unlock;
 		}
-
 		fimc_hw_set_prescaler(ctx);
 		fimc_hw_set_mainscaler(ctx);
 		fimc_hw_set_target_format(ctx);
@@ -653,6 +680,7 @@ static void fimc_dma_run(void *priv)
 	ctx->state &= (FIMC_CTX_M2M | FIMC_CTX_CAP |
 		       FIMC_SRC_FMT | FIMC_DST_FMT);
 	fimc_hw_activate_input_dma(fimc, true);
+	spin_unlock(&fimc->slock);
 
 dma_unlock:
 	spin_unlock_irqrestore(&ctx->slock, flags);
@@ -660,17 +688,7 @@ dma_unlock:
 
 static void fimc_job_abort(void *priv)
 {
-	struct fimc_ctx *ctx = priv;
-	struct fimc_dev *fimc = ctx->fimc_dev;
-
-	if (!fimc_m2m_pending(fimc))
-		return;
-
-	set_bit(ST_M2M_SHUT, &fimc->state);
-
-	wait_event_timeout(fimc->irq_queue,
-			   !test_bit(ST_M2M_SHUT, &fimc->state),
-			   FIMC_SHUTDOWN_TIMEOUT);
+	fimc_m2m_shutdown(priv);
 }
 
 static int fimc_queue_setup(struct vb2_queue *vq, unsigned int *num_buffers,
@@ -844,7 +862,7 @@ int fimc_vidioc_try_fmt_mplane(struct file *file, void *priv,
 
 
 	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		if (ctx->state & FIMC_CTX_CAP)
+		if (fimc_ctx_state_is_set(FIMC_CTX_CAP, ctx))
 			return -EINVAL;
 		is_output = 1;
 	} else if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
@@ -921,9 +939,7 @@ static int fimc_m2m_s_fmt_mplane(struct file *file, void *priv,
 	struct vb2_queue *vq;
 	struct fimc_frame *frame;
 	struct v4l2_pix_format_mplane *pix;
-	unsigned long flags;
 	int i, ret = 0;
-	u32 tmp;
 
 	ret = fimc_vidioc_try_fmt_mplane(file, priv, f);
 	if (ret)
@@ -964,10 +980,10 @@ static int fimc_m2m_s_fmt_mplane(struct file *file, void *priv,
 	frame->offs_h	= 0;
 	frame->offs_v	= 0;
 
-	spin_lock_irqsave(&ctx->slock, flags);
-	tmp = (frame == &ctx->d_frame) ? FIMC_DST_FMT : FIMC_SRC_FMT;
-	ctx->state |= FIMC_PARAMS | tmp;
-	spin_unlock_irqrestore(&ctx->slock, flags);
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		fimc_ctx_state_lock_set(FIMC_PARAMS | FIMC_DST_FMT, ctx);
+	else
+		fimc_ctx_state_lock_set(FIMC_PARAMS | FIMC_SRC_FMT, ctx);
 
 	dbg("f_w: %d, f_h: %d", frame->f_width, frame->f_height);
 
@@ -1010,9 +1026,9 @@ static int fimc_m2m_streamon(struct file *file, void *priv,
 
 	/* The source and target color format need to be set */
 	if (V4L2_TYPE_IS_OUTPUT(type)) {
-		if (~ctx->state & FIMC_SRC_FMT)
+		if (!fimc_ctx_state_is_set(FIMC_SRC_FMT, ctx))
 			return -EINVAL;
-	} else if (~ctx->state & FIMC_DST_FMT) {
+	} else if (!fimc_ctx_state_is_set(FIMC_DST_FMT, ctx)) {
 		return -EINVAL;
 	}
 
@@ -1039,7 +1055,7 @@ int fimc_vidioc_queryctrl(struct file *file, void *priv,
 		return 0;
 	}
 
-	if (ctx->state & FIMC_CTX_CAP) {
+	if (fimc_ctx_state_is_set(FIMC_CTX_CAP, ctx)) {
 		return v4l2_subdev_call(ctx->fimc_dev->vid_cap.sd,
 					core, queryctrl, qc);
 	}
@@ -1063,12 +1079,11 @@ int fimc_vidioc_g_ctrl(struct file *file, void *priv,
 		ctrl->value = ctx->rotation;
 		break;
 	default:
-		if (ctx->state & FIMC_CTX_CAP) {
+		if (fimc_ctx_state_is_set(FIMC_CTX_CAP, ctx)) {
 			return v4l2_subdev_call(fimc->vid_cap.sd, core,
 						g_ctrl, ctrl);
 		} else {
-			v4l2_err(&fimc->m2m.v4l2_dev,
-				 "Invalid control\n");
+			v4l2_err(&fimc->m2m.v4l2_dev, "Invalid control\n");
 			return -EINVAL;
 		}
 	}
@@ -1098,11 +1113,8 @@ int fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_control *ctrl)
 {
 	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	unsigned long flags;
 	int ret = 0;
 
-	spin_lock_irqsave(&ctx->slock, flags);
-
 	switch (ctrl->id) {
 	case V4L2_CID_HFLIP:
 		if (ctrl->value)
@@ -1119,37 +1131,30 @@ int fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_control *ctrl)
 		break;
 
 	case V4L2_CID_ROTATE:
-		if (!(~ctx->state & (FIMC_DST_FMT | FIMC_SRC_FMT))) {
+		if (fimc_ctx_state_is_set(FIMC_DST_FMT | FIMC_SRC_FMT, ctx)) {
 			ret = fimc_check_scaler_ratio(ctx->s_frame.width,
-						      ctx->s_frame.height,
-						      ctx->d_frame.width,
-						      ctx->d_frame.height,
-						      ctrl->value);
-			if (ret) {
-				v4l2_err(&fimc->m2m.v4l2_dev,
-					 "Out of scaler range");
-				spin_unlock_irqrestore(&ctx->slock, flags);
-				return -EINVAL;
-			}
+					ctx->s_frame.height, ctx->d_frame.width,
+					ctx->d_frame.height, ctrl->value);
+		}
+
+		if (ret) {
+			v4l2_err(&fimc->m2m.v4l2_dev, "Out of scaler range\n");
+			return -EINVAL;
 		}
 
 		/* Check for the output rotator availability */
 		if ((ctrl->value == 90 || ctrl->value == 270) &&
-		    (ctx->in_path == FIMC_DMA && !variant->has_out_rot)) {
-			spin_unlock_irqrestore(&ctx->slock, flags);
+		    (ctx->in_path == FIMC_DMA && !variant->has_out_rot))
 			return -EINVAL;
-		} else {
-			ctx->rotation = ctrl->value;
-		}
+		ctx->rotation = ctrl->value;
 		break;
 
 	default:
-		spin_unlock_irqrestore(&ctx->slock, flags);
 		v4l2_err(&fimc->m2m.v4l2_dev, "Invalid control\n");
 		return -EINVAL;
 	}
-	ctx->state |= FIMC_PARAMS;
-	spin_unlock_irqrestore(&ctx->slock, flags);
+
+	fimc_ctx_state_lock_set(FIMC_PARAMS, ctx);
 
 	return 0;
 }
@@ -1209,6 +1214,7 @@ int fimc_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct fimc_frame *f;
 	u32 min_size, halign, depth = 0;
+	bool is_capture_ctx;
 	int i;
 
 	if (cr->c.top < 0 || cr->c.left < 0) {
@@ -1217,10 +1223,12 @@ int fimc_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
 		return -EINVAL;
 	}
 
+	is_capture_ctx = fimc_ctx_state_is_set(FIMC_CTX_CAP, ctx);
+
 	if (cr->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
-		f = (ctx->state & FIMC_CTX_CAP) ? &ctx->s_frame : &ctx->d_frame;
+		f = is_capture_ctx ? &ctx->s_frame : &ctx->d_frame;
 	else if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
-		 ctx->state & FIMC_CTX_M2M)
+		 !is_capture_ctx)
 		f = &ctx->s_frame;
 	else
 		return -EINVAL;
@@ -1228,15 +1236,15 @@ int fimc_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
 	min_size = (f == &ctx->s_frame) ?
 		fimc->variant->min_inp_pixsize : fimc->variant->min_out_pixsize;
 
-	if (ctx->state & FIMC_CTX_M2M) {
+	/* Get pixel alignment constraints. */
+	if (is_capture_ctx) {
+		min_size = 16;
+		halign = 4;
+	} else {
 		if (fimc->id == 1 && fimc->variant->pix_hoff)
 			halign = fimc_fmt_is_rgb(f->fmt->color) ? 0 : 1;
 		else
 			halign = ffs(min_size) - 1;
-	/* there are more strict aligment requirements at camera interface */
-	} else {
-		min_size = 16;
-		halign = 4;
 	}
 
 	for (i = 0; i < f->fmt->colplanes; i++)
@@ -1254,8 +1262,7 @@ int fimc_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
 		cr->c.top = f->o_height - cr->c.height;
 
 	cr->c.left = round_down(cr->c.left, min_size);
-	cr->c.top  = round_down(cr->c.top,
-				ctx->state & FIMC_CTX_M2M ? 8 : 16);
+	cr->c.top  = round_down(cr->c.top, is_capture_ctx ? 16 : 8);
 
 	dbg("l:%d, t:%d, w:%d, h:%d, f_w: %d, f_h: %d",
 	    cr->c.left, cr->c.top, cr->c.width, cr->c.height,
@@ -1264,12 +1271,10 @@ int fimc_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
 	return 0;
 }
 
-
 static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 {
 	struct fimc_ctx *ctx = file->private_data;
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	unsigned long flags;
 	struct fimc_frame *f;
 	int ret;
 
@@ -1280,9 +1285,8 @@ static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 	f = (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) ?
 		&ctx->s_frame : &ctx->d_frame;
 
-	spin_lock_irqsave(&ctx->slock, flags);
 	/* Check to see if scaling ratio is within supported range */
-	if (!(~ctx->state & (FIMC_DST_FMT | FIMC_SRC_FMT))) {
+	if (fimc_ctx_state_is_set(FIMC_DST_FMT | FIMC_SRC_FMT, ctx)) {
 		if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 			ret = fimc_check_scaler_ratio(cr->c.width, cr->c.height,
 						      ctx->d_frame.width,
@@ -1294,22 +1298,19 @@ static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 						      cr->c.width, cr->c.height,
 						      ctx->rotation);
 		}
-
 		if (ret) {
-			v4l2_err(&fimc->m2m.v4l2_dev, "Out of scaler range");
-			spin_unlock_irqrestore(&ctx->slock, flags);
+			v4l2_err(&fimc->m2m.v4l2_dev, "Out of scaler range\n");
 			return -EINVAL;
 		}
 	}
 
-	ctx->state |= FIMC_PARAMS;
-
 	f->offs_h = cr->c.left;
 	f->offs_v = cr->c.top;
 	f->width  = cr->c.width;
 	f->height = cr->c.height;
 
-	spin_unlock_irqrestore(&ctx->slock, flags);
+	fimc_ctx_state_lock_set(FIMC_PARAMS, ctx);
+
 	return 0;
 }
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 4829a25..41b1352 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -14,6 +14,7 @@
 /*#define DEBUG*/
 
 #include <linux/sched.h>
+#include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/videodev2.h>
 #include <linux/io.h>
@@ -57,7 +58,6 @@ enum fimc_dev_flags {
 	ST_IDLE,
 	ST_OUTDMA_RUN,
 	ST_M2M_PEND,
-	ST_M2M_SHUT,
 	/* for capture node */
 	ST_CAPT_PEND,
 	ST_CAPT_RUN,
@@ -71,13 +71,6 @@ enum fimc_dev_flags {
 #define fimc_capture_running(dev) test_bit(ST_CAPT_RUN, &(dev)->state)
 #define fimc_capture_pending(dev) test_bit(ST_CAPT_PEND, &(dev)->state)
 
-#define fimc_capture_active(dev) \
-	(test_bit(ST_CAPT_RUN, &(dev)->state) || \
-	 test_bit(ST_CAPT_PEND, &(dev)->state))
-
-#define fimc_capture_streaming(dev) \
-	test_bit(ST_CAPT_STREAM, &(dev)->state)
-
 enum fimc_datapath {
 	FIMC_CAMERA,
 	FIMC_DMA,
@@ -119,6 +112,7 @@ enum fimc_color_fmt {
 #define	FIMC_DST_FMT		(1 << 4)
 #define	FIMC_CTX_M2M		(1 << 5)
 #define	FIMC_CTX_CAP		(1 << 6)
+#define	FIMC_CTX_SHUT		(1 << 7)
 
 /* Image conversion flags */
 #define	FIMC_IN_DMA_ACCESS_TILED	(1 << 0)
@@ -476,6 +470,38 @@ struct fimc_ctx {
 	struct v4l2_m2m_ctx	*m2m_ctx;
 };
 
+static inline bool fimc_capture_active(struct fimc_dev *fimc)
+{
+	unsigned long flags;
+	bool ret;
+
+	spin_lock_irqsave(&fimc->slock, flags);
+	ret = !!(fimc->state & (1 << ST_CAPT_RUN) ||
+		 fimc->state & (1 << ST_CAPT_PEND));
+	spin_unlock_irqrestore(&fimc->slock, flags);
+	return ret;
+}
+
+static inline void fimc_ctx_state_lock_set(u32 state, struct fimc_ctx *ctx)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->slock, flags);
+	ctx->state |= state;
+	spin_unlock_irqrestore(&ctx->slock, flags);
+}
+
+static inline bool fimc_ctx_state_is_set(u32 mask, struct fimc_ctx *ctx)
+{
+	unsigned long flags;
+	bool ret;
+
+	spin_lock_irqsave(&ctx->slock, flags);
+	ret = (ctx->state & mask) == mask;
+	spin_unlock_irqrestore(&ctx->slock, flags);
+	return ret;
+}
+
 static inline int tiled_fmt(struct fimc_fmt *fmt)
 {
 	return fmt->fourcc == V4L2_PIX_FMT_NV12MT;
@@ -535,7 +561,7 @@ static inline struct fimc_frame *ctx_get_frame(struct fimc_ctx *ctx,
 	struct fimc_frame *frame;
 
 	if (V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE == type) {
-		if (ctx->state & FIMC_CTX_M2M)
+		if (fimc_ctx_state_is_set(FIMC_CTX_M2M, ctx))
 			frame = &ctx->s_frame;
 		else
 			return ERR_PTR(-EINVAL);
-- 
1.7.4.1
