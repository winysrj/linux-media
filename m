Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54015 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab2D3QO5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 12:14:57 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3A00IQQVRNXM40@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Apr 2012 17:14:11 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3A00FEZVSKG1@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Apr 2012 17:14:45 +0100 (BST)
Date: Mon, 30 Apr 2012 18:14:31 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 02/12] s5p-fimc: Move m2m node driver into separate file
In-reply-to: <1335802481-18153-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	sungchun.kang@samsung.com, subash.ramaswamy@linaro.org,
	s.nawrocki@samsung.com
Message-id: <1335802481-18153-3-git-send-email-s.nawrocki@samsung.com>
References: <1335802481-18153-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Virtually no functional changes, just code reordering. This let us to
clearly separate all logical functions available in the driver: fimc
capture, mem-to-mem, and later fimc-lite capture, ISP features, etc.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/Makefile       |    2 +-
 drivers/media/video/s5p-fimc/fimc-capture.c |   72 ++-
 drivers/media/video/s5p-fimc/fimc-core.c    |  853 +--------------------------
 drivers/media/video/s5p-fimc/fimc-core.h    |   10 +-
 drivers/media/video/s5p-fimc/fimc-m2m.c     |  808 +++++++++++++++++++++++++
 5 files changed, 892 insertions(+), 853 deletions(-)
 create mode 100644 drivers/media/video/s5p-fimc/fimc-m2m.c

diff --git a/drivers/media/video/s5p-fimc/Makefile b/drivers/media/video/s5p-fimc/Makefile
index 33dec7f..1da3c6a 100644
--- a/drivers/media/video/s5p-fimc/Makefile
+++ b/drivers/media/video/s5p-fimc/Makefile
@@ -1,4 +1,4 @@
-s5p-fimc-objs := fimc-core.o fimc-reg.o fimc-capture.o fimc-mdevice.o
+s5p-fimc-objs := fimc-core.o fimc-reg.o fimc-m2m.o fimc-capture.o fimc-mdevice.o
 s5p-csis-objs := mipi-csis.o
 
 obj-$(CONFIG_VIDEO_S5P_MIPI_CSIS)	+= s5p-csis.o
diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index dc18ba5..513ffbc 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -139,7 +139,7 @@ static int fimc_stop_capture(struct fimc_dev *fimc, bool suspend)
  * spinlock held. It updates the camera pixel crop, rotation and
  * image flip in H/W.
  */
-int fimc_capture_config_update(struct fimc_ctx *ctx)
+static int fimc_capture_config_update(struct fimc_ctx *ctx)
 {
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	int ret;
@@ -166,6 +166,74 @@ int fimc_capture_config_update(struct fimc_ctx *ctx)
 	return ret;
 }
 
+void fimc_capture_irq_handler(struct fimc_dev *fimc)
+{
+	struct fimc_vid_cap *cap = &fimc->vid_cap;
+	struct fimc_vid_buffer *v_buf;
+	bool capture_stop;
+	struct timeval *tv;
+	struct timespec ts;
+
+	if (test_and_clear_bit(ST_CAPT_SHUT, &fimc->state)) {
+		wake_up(&fimc->irq_queue);
+		goto done;
+	}
+
+	capture_stop = !test_bit(ST_CAPT_JPEG, &fimc->state) ||
+			(cap->reqbufs_count == 1);
+
+	if (!list_empty(&cap->active_buf_q) &&
+	    test_bit(ST_CAPT_RUN, &fimc->state) && capture_stop) {
+		ktime_get_real_ts(&ts);
+
+		v_buf = fimc_active_queue_pop(cap);
+
+		tv = &v_buf->vb.v4l2_buf.timestamp;
+		tv->tv_sec = ts.tv_sec;
+		tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+		v_buf->vb.v4l2_buf.sequence = cap->frame_count++;
+
+		vb2_buffer_done(&v_buf->vb, VB2_BUF_STATE_DONE);
+	}
+
+	if (!list_empty(&cap->pending_buf_q)) {
+
+		v_buf = fimc_pending_queue_pop(cap);
+		fimc_hw_set_output_addr(fimc, &v_buf->paddr, cap->buf_index);
+		v_buf->index = cap->buf_index;
+
+		/* Move the buffer to the capture active queue */
+		fimc_active_queue_add(cap, v_buf);
+
+		dbg("next frame: %d, done frame: %d",
+		    fimc_hw_get_frame_index(fimc), v_buf->index);
+
+		if (++cap->buf_index >= FIMC_MAX_OUT_BUFS)
+			cap->buf_index = 0;
+	}
+
+	if (cap->active_buf_cnt == 0) {
+		if (capture_stop)
+			clear_bit(ST_CAPT_RUN, &fimc->state);
+
+		if (++cap->buf_index >= FIMC_MAX_OUT_BUFS)
+			cap->buf_index = 0;
+	} else {
+		set_bit(ST_CAPT_RUN, &fimc->state);
+	}
+
+	fimc_capture_config_update(cap->ctx);
+done:
+	if (cap->active_buf_cnt == 1) {
+		fimc_deactivate_capture(fimc);
+		clear_bit(ST_CAPT_STREAM, &fimc->state);
+	}
+
+	dbg("frame: %d, active_buf_cnt: %d",
+	    fimc_hw_get_frame_index(fimc), cap->active_buf_cnt);
+}
+
+
 static int start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct fimc_ctx *ctx = q->drv_priv;
@@ -1236,7 +1304,7 @@ void fimc_sensor_notify(struct v4l2_subdev *sd, unsigned int notification,
 					 struct fimc_vid_buffer, list);
 			vb2_set_plane_payload(&buf->vb, 0, *((u32 *)arg));
 		}
-		fimc_capture_irq_handler(fimc, true);
+		fimc_capture_irq_handler(fimc);
 		fimc_deactivate_capture(fimc);
 		spin_unlock_irqrestore(&fimc->slock, irq_flags);
 	}
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 7b90a89..55858c5 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1,5 +1,5 @@
 /*
- * Samsung S5P/EXYNOS4 SoC series camera interface (video postprocessor) driver
+ * Samsung S5P/EXYNOS4 SoC series FIMC (CAMIF) driver
  *
  * Copyright (C) 2010-2011 Samsung Electronics Co., Ltd.
  * Contact: Sylwester Nawrocki, <s.nawrocki@samsung.com>
@@ -187,12 +187,12 @@ static struct fimc_fmt fimc_formats[] = {
 	},
 };
 
-static unsigned int get_m2m_fmt_flags(unsigned int stream_type)
+struct fimc_fmt * fimc_get_format(unsigned int index)
 {
-	if (stream_type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-		return FMT_FLAGS_M2M_IN;
-	else
-		return FMT_FLAGS_M2M_OUT;
+	if (index >= ARRAY_SIZE(fimc_formats))
+		return NULL;
+
+	return &fimc_formats[index];
 }
 
 int fimc_check_scaler_ratio(struct fimc_ctx *ctx, int sw, int sh,
@@ -293,126 +293,9 @@ int fimc_set_scaler_info(struct fimc_ctx *ctx)
 	return 0;
 }
 
-static void fimc_m2m_job_finish(struct fimc_ctx *ctx, int vb_state)
-{
-	struct vb2_buffer *src_vb, *dst_vb;
-
-	if (!ctx || !ctx->m2m_ctx)
-		return;
-
-	src_vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
-	dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
-
-	if (src_vb && dst_vb) {
-		v4l2_m2m_buf_done(src_vb, vb_state);
-		v4l2_m2m_buf_done(dst_vb, vb_state);
-		v4l2_m2m_job_finish(ctx->fimc_dev->m2m.m2m_dev,
-				    ctx->m2m_ctx);
-	}
-}
-
-/* Complete the transaction which has been scheduled for execution. */
-static int fimc_m2m_shutdown(struct fimc_ctx *ctx)
-{
-	struct fimc_dev *fimc = ctx->fimc_dev;
-	int ret;
-
-	if (!fimc_m2m_pending(fimc))
-		return 0;
-
-	fimc_ctx_state_set(FIMC_CTX_SHUT, ctx);
-
-	ret = wait_event_timeout(fimc->irq_queue,
-			   !fimc_ctx_state_is_set(FIMC_CTX_SHUT, ctx),
-			   FIMC_SHUTDOWN_TIMEOUT);
-
-	return ret == 0 ? -ETIMEDOUT : ret;
-}
-
-static int start_streaming(struct vb2_queue *q, unsigned int count)
-{
-	struct fimc_ctx *ctx = q->drv_priv;
-	int ret;
-
-	ret = pm_runtime_get_sync(&ctx->fimc_dev->pdev->dev);
-	return ret > 0 ? 0 : ret;
-}
-
-static int stop_streaming(struct vb2_queue *q)
-{
-	struct fimc_ctx *ctx = q->drv_priv;
-	int ret;
-
-	ret = fimc_m2m_shutdown(ctx);
-	if (ret == -ETIMEDOUT)
-		fimc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
-
-	pm_runtime_put(&ctx->fimc_dev->pdev->dev);
-	return 0;
-}
-
-void fimc_capture_irq_handler(struct fimc_dev *fimc, bool final)
-{
-	struct fimc_vid_cap *cap = &fimc->vid_cap;
-	struct fimc_vid_buffer *v_buf;
-	struct timeval *tv;
-	struct timespec ts;
-
-	if (test_and_clear_bit(ST_CAPT_SHUT, &fimc->state)) {
-		wake_up(&fimc->irq_queue);
-		return;
-	}
-
-	if (!list_empty(&cap->active_buf_q) &&
-	    test_bit(ST_CAPT_RUN, &fimc->state) && final) {
-		ktime_get_real_ts(&ts);
-
-		v_buf = fimc_active_queue_pop(cap);
-
-		tv = &v_buf->vb.v4l2_buf.timestamp;
-		tv->tv_sec = ts.tv_sec;
-		tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
-		v_buf->vb.v4l2_buf.sequence = cap->frame_count++;
-
-		vb2_buffer_done(&v_buf->vb, VB2_BUF_STATE_DONE);
-	}
-
-	if (!list_empty(&cap->pending_buf_q)) {
-
-		v_buf = fimc_pending_queue_pop(cap);
-		fimc_hw_set_output_addr(fimc, &v_buf->paddr, cap->buf_index);
-		v_buf->index = cap->buf_index;
-
-		/* Move the buffer to the capture active queue */
-		fimc_active_queue_add(cap, v_buf);
-
-		dbg("next frame: %d, done frame: %d",
-		    fimc_hw_get_frame_index(fimc), v_buf->index);
-
-		if (++cap->buf_index >= FIMC_MAX_OUT_BUFS)
-			cap->buf_index = 0;
-	}
-
-	if (cap->active_buf_cnt == 0) {
-		if (final)
-			clear_bit(ST_CAPT_RUN, &fimc->state);
-
-		if (++cap->buf_index >= FIMC_MAX_OUT_BUFS)
-			cap->buf_index = 0;
-	} else {
-		set_bit(ST_CAPT_RUN, &fimc->state);
-	}
-
-	fimc_capture_config_update(cap->ctx);
-
-	dbg("frame: %d, active_buf_cnt: %d",
-	    fimc_hw_get_frame_index(fimc), cap->active_buf_cnt);
-}
-
 static irqreturn_t fimc_irq_handler(int irq, void *priv)
 {
 	struct fimc_dev *fimc = priv;
-	struct fimc_vid_cap *cap = &fimc->vid_cap;
 	struct fimc_ctx *ctx;
 
 	fimc_hw_clear_irq(fimc);
@@ -437,12 +320,7 @@ static irqreturn_t fimc_irq_handler(int irq, void *priv)
 			return IRQ_HANDLED;
 		}
 	} else if (test_bit(ST_CAPT_PEND, &fimc->state)) {
-		fimc_capture_irq_handler(fimc,
-				 !test_bit(ST_CAPT_JPEG, &fimc->state));
-		if (cap->active_buf_cnt == 1) {
-			fimc_deactivate_capture(fimc);
-			clear_bit(ST_CAPT_STREAM, &fimc->state);
-		}
+		fimc_capture_irq_handler(fimc);
 	}
 out:
 	spin_unlock(&fimc->slock);
@@ -582,154 +460,6 @@ void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f)
 	    f->fmt->color, f->dma_offset.y_h, f->dma_offset.y_v);
 }
 
-static void fimc_dma_run(void *priv)
-{
-	struct vb2_buffer *vb = NULL;
-	struct fimc_ctx *ctx = priv;
-	struct fimc_frame *sf, *df;
-	struct fimc_dev *fimc;
-	unsigned long flags;
-	u32 ret;
-
-	if (WARN(!ctx, "null hardware context\n"))
-		return;
-
-	fimc = ctx->fimc_dev;
-	spin_lock_irqsave(&fimc->slock, flags);
-	set_bit(ST_M2M_PEND, &fimc->state);
-	sf = &ctx->s_frame;
-	df = &ctx->d_frame;
-
-	if (ctx->state & FIMC_PARAMS) {
-		/* Prepare the DMA offsets for scaler */
-		fimc_prepare_dma_offset(ctx, sf);
-		fimc_prepare_dma_offset(ctx, df);
-	}
-
-	vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
-	ret = fimc_prepare_addr(ctx, vb, sf, &sf->paddr);
-	if (ret)
-		goto dma_unlock;
-
-	vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
-	ret = fimc_prepare_addr(ctx, vb, df, &df->paddr);
-	if (ret)
-		goto dma_unlock;
-
-	/* Reconfigure hardware if the context has changed. */
-	if (fimc->m2m.ctx != ctx) {
-		ctx->state |= FIMC_PARAMS;
-		fimc->m2m.ctx = ctx;
-	}
-
-	if (ctx->state & FIMC_PARAMS) {
-		fimc_set_yuv_order(ctx);
-		fimc_hw_set_input_path(ctx);
-		fimc_hw_set_in_dma(ctx);
-		ret = fimc_set_scaler_info(ctx);
-		if (ret)
-			goto dma_unlock;
-		fimc_hw_set_prescaler(ctx);
-		fimc_hw_set_mainscaler(ctx);
-		fimc_hw_set_target_format(ctx);
-		fimc_hw_set_rotation(ctx);
-		fimc_hw_set_effect(ctx, false);
-		fimc_hw_set_out_dma(ctx);
-		if (fimc->variant->has_alpha)
-			fimc_hw_set_rgb_alpha(ctx);
-		fimc_hw_set_output_path(ctx);
-	}
-	fimc_hw_set_input_addr(fimc, &sf->paddr);
-	fimc_hw_set_output_addr(fimc, &df->paddr, -1);
-
-	fimc_activate_capture(ctx);
-
-	ctx->state &= (FIMC_CTX_M2M | FIMC_CTX_CAP |
-		       FIMC_SRC_FMT | FIMC_DST_FMT);
-	fimc_hw_activate_input_dma(fimc, true);
-dma_unlock:
-	spin_unlock_irqrestore(&fimc->slock, flags);
-}
-
-static void fimc_job_abort(void *priv)
-{
-	fimc_m2m_shutdown(priv);
-}
-
-static int fimc_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
-			    unsigned int *num_buffers, unsigned int *num_planes,
-			    unsigned int sizes[], void *allocators[])
-{
-	struct fimc_ctx *ctx = vb2_get_drv_priv(vq);
-	struct fimc_frame *f;
-	int i;
-
-	f = ctx_get_frame(ctx, vq->type);
-	if (IS_ERR(f))
-		return PTR_ERR(f);
-	/*
-	 * Return number of non-contigous planes (plane buffers)
-	 * depending on the configured color format.
-	 */
-	if (!f->fmt)
-		return -EINVAL;
-
-	*num_planes = f->fmt->memplanes;
-	for (i = 0; i < f->fmt->memplanes; i++) {
-		sizes[i] = (f->f_width * f->f_height * f->fmt->depth[i]) / 8;
-		allocators[i] = ctx->fimc_dev->alloc_ctx;
-	}
-	return 0;
-}
-
-static int fimc_buf_prepare(struct vb2_buffer *vb)
-{
-	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	struct fimc_frame *frame;
-	int i;
-
-	frame = ctx_get_frame(ctx, vb->vb2_queue->type);
-	if (IS_ERR(frame))
-		return PTR_ERR(frame);
-
-	for (i = 0; i < frame->fmt->memplanes; i++)
-		vb2_set_plane_payload(vb, i, frame->payload[i]);
-
-	return 0;
-}
-
-static void fimc_buf_queue(struct vb2_buffer *vb)
-{
-	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-
-	dbg("ctx: %p, ctx->state: 0x%x", ctx, ctx->state);
-
-	if (ctx->m2m_ctx)
-		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
-}
-
-static void fimc_lock(struct vb2_queue *vq)
-{
-	struct fimc_ctx *ctx = vb2_get_drv_priv(vq);
-	mutex_lock(&ctx->fimc_dev->lock);
-}
-
-static void fimc_unlock(struct vb2_queue *vq)
-{
-	struct fimc_ctx *ctx = vb2_get_drv_priv(vq);
-	mutex_unlock(&ctx->fimc_dev->lock);
-}
-
-static struct vb2_ops fimc_qops = {
-	.queue_setup	 = fimc_queue_setup,
-	.buf_prepare	 = fimc_buf_prepare,
-	.buf_queue	 = fimc_buf_queue,
-	.wait_prepare	 = fimc_unlock,
-	.wait_finish	 = fimc_lock,
-	.stop_streaming	 = stop_streaming,
-	.start_streaming = start_streaming,
-};
-
 /*
  * V4L2 controls handling
  */
@@ -877,39 +607,6 @@ void fimc_alpha_ctrl_update(struct fimc_ctx *ctx)
 	v4l2_ctrl_unlock(ctrl);
 }
 
-/*
- * V4L2 ioctl handlers
- */
-static int fimc_m2m_querycap(struct file *file, void *fh,
-			     struct v4l2_capability *cap)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-	struct fimc_dev *fimc = ctx->fimc_dev;
-
-	strncpy(cap->driver, fimc->pdev->name, sizeof(cap->driver) - 1);
-	strncpy(cap->card, fimc->pdev->name, sizeof(cap->card) - 1);
-	cap->bus_info[0] = 0;
-	cap->capabilities = V4L2_CAP_STREAMING |
-		V4L2_CAP_VIDEO_CAPTURE_MPLANE | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
-
-	return 0;
-}
-
-static int fimc_m2m_enum_fmt_mplane(struct file *file, void *priv,
-				    struct v4l2_fmtdesc *f)
-{
-	struct fimc_fmt *fmt;
-
-	fmt = fimc_find_format(NULL, NULL, get_m2m_fmt_flags(f->type),
-			       f->index);
-	if (!fmt)
-		return -EINVAL;
-
-	strncpy(f->description, fmt->name, sizeof(f->description) - 1);
-	f->pixelformat = fmt->fourcc;
-	return 0;
-}
-
 int fimc_fill_format(struct fimc_frame *frame, struct v4l2_format *f)
 {
 	struct v4l2_pix_format_mplane *pixm = &f->fmt.pix_mp;
@@ -988,18 +685,6 @@ void fimc_adjust_mplane_format(struct fimc_fmt *fmt, u32 width, u32 height,
 	}
 }
 
-static int fimc_m2m_g_fmt_mplane(struct file *file, void *fh,
-				 struct v4l2_format *f)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-	struct fimc_frame *frame = ctx_get_frame(ctx, f->type);
-
-	if (IS_ERR(frame))
-		return PTR_ERR(frame);
-
-	return fimc_fill_format(frame, f);
-}
-
 /**
  * fimc_find_format - lookup fimc color format by fourcc or media bus format
  * @pixelformat: fourcc to match, ignored if null
@@ -1032,530 +717,6 @@ struct fimc_fmt *fimc_find_format(u32 *pixelformat, u32 *mbus_code,
 	return def_fmt;
 }
 
-static int fimc_try_fmt_mplane(struct fimc_ctx *ctx, struct v4l2_format *f)
-{
-	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct samsung_fimc_variant *variant = fimc->variant;
-	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
-	struct fimc_fmt *fmt;
-	u32 max_w, mod_x, mod_y;
-
-	if (!IS_M2M(f->type))
-		return -EINVAL;
-
-	dbg("w: %d, h: %d", pix->width, pix->height);
-
-	fmt = fimc_find_format(&pix->pixelformat, NULL,
-			       get_m2m_fmt_flags(f->type), 0);
-	if (WARN(fmt == NULL, "Pixel format lookup failed"))
-		return -EINVAL;
-
-	if (pix->field == V4L2_FIELD_ANY)
-		pix->field = V4L2_FIELD_NONE;
-	else if (pix->field != V4L2_FIELD_NONE)
-		return -EINVAL;
-
-	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		max_w = variant->pix_limit->scaler_dis_w;
-		mod_x = ffs(variant->min_inp_pixsize) - 1;
-	} else {
-		max_w = variant->pix_limit->out_rot_dis_w;
-		mod_x = ffs(variant->min_out_pixsize) - 1;
-	}
-
-	if (tiled_fmt(fmt)) {
-		mod_x = 6; /* 64 x 32 pixels tile */
-		mod_y = 5;
-	} else {
-		if (variant->min_vsize_align == 1)
-			mod_y = fimc_fmt_is_rgb(fmt->color) ? 0 : 1;
-		else
-			mod_y = ffs(variant->min_vsize_align) - 1;
-	}
-
-	v4l_bound_align_image(&pix->width, 16, max_w, mod_x,
-		&pix->height, 8, variant->pix_limit->scaler_dis_w, mod_y, 0);
-
-	fimc_adjust_mplane_format(fmt, pix->width, pix->height, &f->fmt.pix_mp);
-	return 0;
-}
-
-static int fimc_m2m_try_fmt_mplane(struct file *file, void *fh,
-				   struct v4l2_format *f)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-
-	return fimc_try_fmt_mplane(ctx, f);
-}
-
-static int fimc_m2m_s_fmt_mplane(struct file *file, void *fh,
-				 struct v4l2_format *f)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct vb2_queue *vq;
-	struct fimc_frame *frame;
-	struct v4l2_pix_format_mplane *pix;
-	int i, ret = 0;
-
-	ret = fimc_try_fmt_mplane(ctx, f);
-	if (ret)
-		return ret;
-
-	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
-
-	if (vb2_is_busy(vq)) {
-		v4l2_err(fimc->m2m.vfd, "queue (%d) busy\n", f->type);
-		return -EBUSY;
-	}
-
-	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-		frame = &ctx->s_frame;
-	else
-		frame = &ctx->d_frame;
-
-	pix = &f->fmt.pix_mp;
-	frame->fmt = fimc_find_format(&pix->pixelformat, NULL,
-				      get_m2m_fmt_flags(f->type), 0);
-	if (!frame->fmt)
-		return -EINVAL;
-
-	/* Update RGB Alpha control state and value range */
-	fimc_alpha_ctrl_update(ctx);
-
-	for (i = 0; i < frame->fmt->colplanes; i++) {
-		frame->payload[i] =
-			(pix->width * pix->height * frame->fmt->depth[i]) / 8;
-	}
-
-	fimc_fill_frame(frame, f);
-
-	ctx->scaler.enabled = 1;
-
-	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
-		fimc_ctx_state_set(FIMC_PARAMS | FIMC_DST_FMT, ctx);
-	else
-		fimc_ctx_state_set(FIMC_PARAMS | FIMC_SRC_FMT, ctx);
-
-	dbg("f_w: %d, f_h: %d", frame->f_width, frame->f_height);
-
-	return 0;
-}
-
-static int fimc_m2m_reqbufs(struct file *file, void *fh,
-			    struct v4l2_requestbuffers *reqbufs)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-
-	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
-}
-
-static int fimc_m2m_querybuf(struct file *file, void *fh,
-			     struct v4l2_buffer *buf)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-
-	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
-}
-
-static int fimc_m2m_qbuf(struct file *file, void *fh,
-			 struct v4l2_buffer *buf)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-
-	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
-}
-
-static int fimc_m2m_dqbuf(struct file *file, void *fh,
-			  struct v4l2_buffer *buf)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-
-	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
-}
-
-static int fimc_m2m_streamon(struct file *file, void *fh,
-			     enum v4l2_buf_type type)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-
-	/* The source and target color format need to be set */
-	if (V4L2_TYPE_IS_OUTPUT(type)) {
-		if (!fimc_ctx_state_is_set(FIMC_SRC_FMT, ctx))
-			return -EINVAL;
-	} else if (!fimc_ctx_state_is_set(FIMC_DST_FMT, ctx)) {
-		return -EINVAL;
-	}
-
-	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
-}
-
-static int fimc_m2m_streamoff(struct file *file, void *fh,
-			    enum v4l2_buf_type type)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-
-	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
-}
-
-static int fimc_m2m_cropcap(struct file *file, void *fh,
-			    struct v4l2_cropcap *cr)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-	struct fimc_frame *frame;
-
-	frame = ctx_get_frame(ctx, cr->type);
-	if (IS_ERR(frame))
-		return PTR_ERR(frame);
-
-	cr->bounds.left		= 0;
-	cr->bounds.top		= 0;
-	cr->bounds.width	= frame->o_width;
-	cr->bounds.height	= frame->o_height;
-	cr->defrect		= cr->bounds;
-
-	return 0;
-}
-
-static int fimc_m2m_g_crop(struct file *file, void *fh, struct v4l2_crop *cr)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-	struct fimc_frame *frame;
-
-	frame = ctx_get_frame(ctx, cr->type);
-	if (IS_ERR(frame))
-		return PTR_ERR(frame);
-
-	cr->c.left = frame->offs_h;
-	cr->c.top = frame->offs_v;
-	cr->c.width = frame->width;
-	cr->c.height = frame->height;
-
-	return 0;
-}
-
-static int fimc_m2m_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
-{
-	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct fimc_frame *f;
-	u32 min_size, halign, depth = 0;
-	int i;
-
-	if (cr->c.top < 0 || cr->c.left < 0) {
-		v4l2_err(fimc->m2m.vfd,
-			"doesn't support negative values for top & left\n");
-		return -EINVAL;
-	}
-	if (cr->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
-		f = &ctx->d_frame;
-	else if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-		f = &ctx->s_frame;
-	else
-		return -EINVAL;
-
-	min_size = (f == &ctx->s_frame) ?
-		fimc->variant->min_inp_pixsize : fimc->variant->min_out_pixsize;
-
-	/* Get pixel alignment constraints. */
-	if (fimc->variant->min_vsize_align == 1)
-		halign = fimc_fmt_is_rgb(f->fmt->color) ? 0 : 1;
-	else
-		halign = ffs(fimc->variant->min_vsize_align) - 1;
-
-	for (i = 0; i < f->fmt->colplanes; i++)
-		depth += f->fmt->depth[i];
-
-	v4l_bound_align_image(&cr->c.width, min_size, f->o_width,
-			      ffs(min_size) - 1,
-			      &cr->c.height, min_size, f->o_height,
-			      halign, 64/(ALIGN(depth, 8)));
-
-	/* adjust left/top if cropping rectangle is out of bounds */
-	if (cr->c.left + cr->c.width > f->o_width)
-		cr->c.left = f->o_width - cr->c.width;
-	if (cr->c.top + cr->c.height > f->o_height)
-		cr->c.top = f->o_height - cr->c.height;
-
-	cr->c.left = round_down(cr->c.left, min_size);
-	cr->c.top  = round_down(cr->c.top, fimc->variant->hor_offs_align);
-
-	dbg("l:%d, t:%d, w:%d, h:%d, f_w: %d, f_h: %d",
-	    cr->c.left, cr->c.top, cr->c.width, cr->c.height,
-	    f->f_width, f->f_height);
-
-	return 0;
-}
-
-static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct fimc_frame *f;
-	int ret;
-
-	ret = fimc_m2m_try_crop(ctx, cr);
-	if (ret)
-		return ret;
-
-	f = (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) ?
-		&ctx->s_frame : &ctx->d_frame;
-
-	/* Check to see if scaling ratio is within supported range */
-	if (fimc_ctx_state_is_set(FIMC_DST_FMT | FIMC_SRC_FMT, ctx)) {
-		if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-			ret = fimc_check_scaler_ratio(ctx, cr->c.width,
-					cr->c.height, ctx->d_frame.width,
-					ctx->d_frame.height, ctx->rotation);
-		} else {
-			ret = fimc_check_scaler_ratio(ctx, ctx->s_frame.width,
-					ctx->s_frame.height, cr->c.width,
-					cr->c.height, ctx->rotation);
-		}
-		if (ret) {
-			v4l2_err(fimc->m2m.vfd, "Out of scaler range\n");
-			return -EINVAL;
-		}
-	}
-
-	f->offs_h = cr->c.left;
-	f->offs_v = cr->c.top;
-	f->width  = cr->c.width;
-	f->height = cr->c.height;
-
-	fimc_ctx_state_set(FIMC_PARAMS, ctx);
-
-	return 0;
-}
-
-static const struct v4l2_ioctl_ops fimc_m2m_ioctl_ops = {
-	.vidioc_querycap		= fimc_m2m_querycap,
-
-	.vidioc_enum_fmt_vid_cap_mplane	= fimc_m2m_enum_fmt_mplane,
-	.vidioc_enum_fmt_vid_out_mplane	= fimc_m2m_enum_fmt_mplane,
-
-	.vidioc_g_fmt_vid_cap_mplane	= fimc_m2m_g_fmt_mplane,
-	.vidioc_g_fmt_vid_out_mplane	= fimc_m2m_g_fmt_mplane,
-
-	.vidioc_try_fmt_vid_cap_mplane	= fimc_m2m_try_fmt_mplane,
-	.vidioc_try_fmt_vid_out_mplane	= fimc_m2m_try_fmt_mplane,
-
-	.vidioc_s_fmt_vid_cap_mplane	= fimc_m2m_s_fmt_mplane,
-	.vidioc_s_fmt_vid_out_mplane	= fimc_m2m_s_fmt_mplane,
-
-	.vidioc_reqbufs			= fimc_m2m_reqbufs,
-	.vidioc_querybuf		= fimc_m2m_querybuf,
-
-	.vidioc_qbuf			= fimc_m2m_qbuf,
-	.vidioc_dqbuf			= fimc_m2m_dqbuf,
-
-	.vidioc_streamon		= fimc_m2m_streamon,
-	.vidioc_streamoff		= fimc_m2m_streamoff,
-
-	.vidioc_g_crop			= fimc_m2m_g_crop,
-	.vidioc_s_crop			= fimc_m2m_s_crop,
-	.vidioc_cropcap			= fimc_m2m_cropcap
-
-};
-
-static int queue_init(void *priv, struct vb2_queue *src_vq,
-		      struct vb2_queue *dst_vq)
-{
-	struct fimc_ctx *ctx = priv;
-	int ret;
-
-	memset(src_vq, 0, sizeof(*src_vq));
-	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
-	src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
-	src_vq->drv_priv = ctx;
-	src_vq->ops = &fimc_qops;
-	src_vq->mem_ops = &vb2_dma_contig_memops;
-	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
-
-	ret = vb2_queue_init(src_vq);
-	if (ret)
-		return ret;
-
-	memset(dst_vq, 0, sizeof(*dst_vq));
-	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
-	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
-	dst_vq->drv_priv = ctx;
-	dst_vq->ops = &fimc_qops;
-	dst_vq->mem_ops = &vb2_dma_contig_memops;
-	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
-
-	return vb2_queue_init(dst_vq);
-}
-
-static int fimc_m2m_open(struct file *file)
-{
-	struct fimc_dev *fimc = video_drvdata(file);
-	struct fimc_ctx *ctx;
-	int ret;
-
-	dbg("pid: %d, state: 0x%lx, refcnt: %d",
-		task_pid_nr(current), fimc->state, fimc->vid_cap.refcnt);
-
-	/*
-	 * Return if the corresponding video capture node
-	 * is already opened.
-	 */
-	if (fimc->vid_cap.refcnt > 0)
-		return -EBUSY;
-
-	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
-	v4l2_fh_init(&ctx->fh, fimc->m2m.vfd);
-	ctx->fimc_dev = fimc;
-
-	/* Default color format */
-	ctx->s_frame.fmt = &fimc_formats[0];
-	ctx->d_frame.fmt = &fimc_formats[0];
-
-	ret = fimc_ctrls_create(ctx);
-	if (ret)
-		goto error_fh;
-
-	/* Use separate control handler per file handle */
-	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
-	file->private_data = &ctx->fh;
-	v4l2_fh_add(&ctx->fh);
-
-	/* Setup the device context for memory-to-memory mode */
-	ctx->state = FIMC_CTX_M2M;
-	ctx->flags = 0;
-	ctx->in_path = FIMC_DMA;
-	ctx->out_path = FIMC_DMA;
-
-	ctx->m2m_ctx = v4l2_m2m_ctx_init(fimc->m2m.m2m_dev, ctx, queue_init);
-	if (IS_ERR(ctx->m2m_ctx)) {
-		ret = PTR_ERR(ctx->m2m_ctx);
-		goto error_c;
-	}
-
-	if (fimc->m2m.refcnt++ == 0)
-		set_bit(ST_M2M_RUN, &fimc->state);
-	return 0;
-
-error_c:
-	fimc_ctrls_delete(ctx);
-error_fh:
-	v4l2_fh_del(&ctx->fh);
-	v4l2_fh_exit(&ctx->fh);
-	kfree(ctx);
-	return ret;
-}
-
-static int fimc_m2m_release(struct file *file)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(file->private_data);
-	struct fimc_dev *fimc = ctx->fimc_dev;
-
-	dbg("pid: %d, state: 0x%lx, refcnt= %d",
-		task_pid_nr(current), fimc->state, fimc->m2m.refcnt);
-
-	v4l2_m2m_ctx_release(ctx->m2m_ctx);
-	fimc_ctrls_delete(ctx);
-	v4l2_fh_del(&ctx->fh);
-	v4l2_fh_exit(&ctx->fh);
-
-	if (--fimc->m2m.refcnt <= 0)
-		clear_bit(ST_M2M_RUN, &fimc->state);
-	kfree(ctx);
-	return 0;
-}
-
-static unsigned int fimc_m2m_poll(struct file *file,
-				  struct poll_table_struct *wait)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(file->private_data);
-
-	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
-}
-
-
-static int fimc_m2m_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(file->private_data);
-
-	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
-}
-
-static const struct v4l2_file_operations fimc_m2m_fops = {
-	.owner		= THIS_MODULE,
-	.open		= fimc_m2m_open,
-	.release	= fimc_m2m_release,
-	.poll		= fimc_m2m_poll,
-	.unlocked_ioctl	= video_ioctl2,
-	.mmap		= fimc_m2m_mmap,
-};
-
-static struct v4l2_m2m_ops m2m_ops = {
-	.device_run	= fimc_dma_run,
-	.job_abort	= fimc_job_abort,
-};
-
-int fimc_register_m2m_device(struct fimc_dev *fimc,
-			     struct v4l2_device *v4l2_dev)
-{
-	struct video_device *vfd;
-	struct platform_device *pdev;
-	int ret = 0;
-
-	if (!fimc)
-		return -ENODEV;
-
-	pdev = fimc->pdev;
-	fimc->v4l2_dev = v4l2_dev;
-
-	vfd = video_device_alloc();
-	if (!vfd) {
-		v4l2_err(v4l2_dev, "Failed to allocate video device\n");
-		return -ENOMEM;
-	}
-
-	vfd->fops	= &fimc_m2m_fops;
-	vfd->ioctl_ops	= &fimc_m2m_ioctl_ops;
-	vfd->v4l2_dev	= v4l2_dev;
-	vfd->minor	= -1;
-	vfd->release	= video_device_release;
-	vfd->lock	= &fimc->lock;
-
-	snprintf(vfd->name, sizeof(vfd->name), "%s.m2m", dev_name(&pdev->dev));
-	video_set_drvdata(vfd, fimc);
-
-	fimc->m2m.vfd = vfd;
-	fimc->m2m.m2m_dev = v4l2_m2m_init(&m2m_ops);
-	if (IS_ERR(fimc->m2m.m2m_dev)) {
-		v4l2_err(v4l2_dev, "failed to initialize v4l2-m2m device\n");
-		ret = PTR_ERR(fimc->m2m.m2m_dev);
-		goto err_init;
-	}
-
-	ret = media_entity_init(&vfd->entity, 0, NULL, 0);
-	if (!ret)
-		return 0;
-
-	v4l2_m2m_release(fimc->m2m.m2m_dev);
-err_init:
-	video_device_release(fimc->m2m.vfd);
-	return ret;
-}
-
-void fimc_unregister_m2m_device(struct fimc_dev *fimc)
-{
-	if (!fimc)
-		return;
-
-	if (fimc->m2m.m2m_dev)
-		v4l2_m2m_release(fimc->m2m.m2m_dev);
-	if (fimc->m2m.vfd) {
-		media_entity_cleanup(&fimc->m2m.vfd->entity);
-		/* Can also be called if video device wasn't registered */
-		video_unregister_device(fimc->m2m.vfd);
-	}
-}
-
 static void fimc_clk_put(struct fimc_dev *fimc)
 {
 	int i;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 193e8f6..a590cc3 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -712,6 +712,7 @@ void fimc_adjust_mplane_format(struct fimc_fmt *fmt, u32 width, u32 height,
 			       struct v4l2_pix_format_mplane *pix);
 struct fimc_fmt *fimc_find_format(u32 *pixelformat, u32 *mbus_code,
 				  unsigned int mask, int index);
+struct fimc_fmt *fimc_get_format(unsigned int index);
 
 int fimc_check_scaler_ratio(struct fimc_ctx *ctx, int sw, int sh,
 			    int dw, int dh, int rotation);
@@ -722,7 +723,7 @@ int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f);
 void fimc_set_yuv_order(struct fimc_ctx *ctx);
 void fimc_fill_frame(struct fimc_frame *frame, struct v4l2_format *f);
-void fimc_capture_irq_handler(struct fimc_dev *fimc, bool done);
+void fimc_capture_irq_handler(struct fimc_dev *fimc);
 
 int fimc_register_m2m_device(struct fimc_dev *fimc,
 			     struct v4l2_device *v4l2_dev);
@@ -731,18 +732,19 @@ int fimc_register_driver(void);
 void fimc_unregister_driver(void);
 
 /* -----------------------------------------------------*/
+/* fimc-m2m.c */
+void fimc_m2m_job_finish(struct fimc_ctx *ctx, int vb_state);
+
+/* -----------------------------------------------------*/
 /* fimc-capture.c					*/
 int fimc_register_capture_device(struct fimc_dev *fimc,
 				 struct v4l2_device *v4l2_dev);
 void fimc_unregister_capture_device(struct fimc_dev *fimc);
 int fimc_capture_ctrls_create(struct fimc_dev *fimc);
-int fimc_vid_cap_buf_queue(struct fimc_dev *fimc,
-			     struct fimc_vid_buffer *fimc_vb);
 void fimc_sensor_notify(struct v4l2_subdev *sd, unsigned int notification,
 			void *arg);
 int fimc_capture_suspend(struct fimc_dev *fimc);
 int fimc_capture_resume(struct fimc_dev *fimc);
-int fimc_capture_config_update(struct fimc_ctx *ctx);
 
 /* Locking: the caller holds fimc->slock */
 static inline void fimc_activate_capture(struct fimc_ctx *ctx)
diff --git a/drivers/media/video/s5p-fimc/fimc-m2m.c b/drivers/media/video/s5p-fimc/fimc-m2m.c
new file mode 100644
index 0000000..01e79f2
--- /dev/null
+++ b/drivers/media/video/s5p-fimc/fimc-m2m.c
@@ -0,0 +1,808 @@
+/*
+ * Samsung S5P/EXYNOS4 SoC series FIMC (video postprocessor) driver
+ *
+ * Copyright (C) 2012 Samsung Electronics Co., Ltd.
+ * Sylwester Nawrocki, <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation, either version 2 of the License,
+ * or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/bug.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/list.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "fimc-core.h"
+#include "fimc-mdevice.h"
+
+
+static unsigned int get_m2m_fmt_flags(unsigned int stream_type)
+{
+	if (stream_type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		return FMT_FLAGS_M2M_IN;
+	else
+		return FMT_FLAGS_M2M_OUT;
+}
+
+void fimc_m2m_job_finish(struct fimc_ctx *ctx, int vb_state)
+{
+	struct vb2_buffer *src_vb, *dst_vb;
+
+	if (!ctx || !ctx->m2m_ctx)
+		return;
+
+	src_vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+	dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+
+	if (src_vb && dst_vb) {
+		v4l2_m2m_buf_done(src_vb, vb_state);
+		v4l2_m2m_buf_done(dst_vb, vb_state);
+		v4l2_m2m_job_finish(ctx->fimc_dev->m2m.m2m_dev,
+				    ctx->m2m_ctx);
+	}
+}
+
+/* Complete the transaction which has been scheduled for execution. */
+static int fimc_m2m_shutdown(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	int ret;
+
+	if (!fimc_m2m_pending(fimc))
+		return 0;
+
+	fimc_ctx_state_set(FIMC_CTX_SHUT, ctx);
+
+	ret = wait_event_timeout(fimc->irq_queue,
+			   !fimc_ctx_state_is_set(FIMC_CTX_SHUT, ctx),
+			   FIMC_SHUTDOWN_TIMEOUT);
+
+	return ret == 0 ? -ETIMEDOUT : ret;
+}
+
+static int start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct fimc_ctx *ctx = q->drv_priv;
+	int ret;
+
+	ret = pm_runtime_get_sync(&ctx->fimc_dev->pdev->dev);
+	return ret > 0 ? 0 : ret;
+}
+
+static int stop_streaming(struct vb2_queue *q)
+{
+	struct fimc_ctx *ctx = q->drv_priv;
+	int ret;
+
+	ret = fimc_m2m_shutdown(ctx);
+	if (ret == -ETIMEDOUT)
+		fimc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
+
+	pm_runtime_put(&ctx->fimc_dev->pdev->dev);
+	return 0;
+}
+
+static void fimc_device_run(void *priv)
+{
+	struct vb2_buffer *vb = NULL;
+	struct fimc_ctx *ctx = priv;
+	struct fimc_frame *sf, *df;
+	struct fimc_dev *fimc;
+	unsigned long flags;
+	u32 ret;
+
+	if (WARN(!ctx, "Null context\n"))
+		return;
+
+	fimc = ctx->fimc_dev;
+	spin_lock_irqsave(&fimc->slock, flags);
+
+	set_bit(ST_M2M_PEND, &fimc->state);
+	sf = &ctx->s_frame;
+	df = &ctx->d_frame;
+
+	if (ctx->state & FIMC_PARAMS) {
+		/* Prepare the DMA offsets for scaler */
+		fimc_prepare_dma_offset(ctx, sf);
+		fimc_prepare_dma_offset(ctx, df);
+	}
+
+	vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	ret = fimc_prepare_addr(ctx, vb, sf, &sf->paddr);
+	if (ret)
+		goto dma_unlock;
+
+	vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	ret = fimc_prepare_addr(ctx, vb, df, &df->paddr);
+	if (ret)
+		goto dma_unlock;
+
+	/* Reconfigure hardware if the context has changed. */
+	if (fimc->m2m.ctx != ctx) {
+		ctx->state |= FIMC_PARAMS;
+		fimc->m2m.ctx = ctx;
+	}
+
+	if (ctx->state & FIMC_PARAMS) {
+		fimc_set_yuv_order(ctx);
+		fimc_hw_set_input_path(ctx);
+		fimc_hw_set_in_dma(ctx);
+		ret = fimc_set_scaler_info(ctx);
+		if (ret)
+			goto dma_unlock;
+		fimc_hw_set_prescaler(ctx);
+		fimc_hw_set_mainscaler(ctx);
+		fimc_hw_set_target_format(ctx);
+		fimc_hw_set_rotation(ctx);
+		fimc_hw_set_effect(ctx, false);
+		fimc_hw_set_out_dma(ctx);
+		if (fimc->variant->has_alpha)
+			fimc_hw_set_rgb_alpha(ctx);
+		fimc_hw_set_output_path(ctx);
+	}
+	fimc_hw_set_input_addr(fimc, &sf->paddr);
+	fimc_hw_set_output_addr(fimc, &df->paddr, -1);
+
+	fimc_activate_capture(ctx);
+	ctx->state &= (FIMC_CTX_M2M | FIMC_CTX_CAP |
+		       FIMC_SRC_FMT | FIMC_DST_FMT);
+	fimc_hw_activate_input_dma(fimc, true);
+
+dma_unlock:
+	spin_unlock_irqrestore(&fimc->slock, flags);
+}
+
+static void fimc_job_abort(void *priv)
+{
+	fimc_m2m_shutdown(priv);
+}
+
+static int fimc_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+			    unsigned int *num_buffers, unsigned int *num_planes,
+			    unsigned int sizes[], void *allocators[])
+{
+	struct fimc_ctx *ctx = vb2_get_drv_priv(vq);
+	struct fimc_frame *f;
+	int i;
+
+	f = ctx_get_frame(ctx, vq->type);
+	if (IS_ERR(f))
+		return PTR_ERR(f);
+	/*
+	 * Return number of non-contigous planes (plane buffers)
+	 * depending on the configured color format.
+	 */
+	if (!f->fmt)
+		return -EINVAL;
+
+	*num_planes = f->fmt->memplanes;
+	for (i = 0; i < f->fmt->memplanes; i++) {
+		sizes[i] = (f->f_width * f->f_height * f->fmt->depth[i]) / 8;
+		allocators[i] = ctx->fimc_dev->alloc_ctx;
+	}
+	return 0;
+}
+
+static int fimc_buf_prepare(struct vb2_buffer *vb)
+{
+	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct fimc_frame *frame;
+	int i;
+
+	frame = ctx_get_frame(ctx, vb->vb2_queue->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	for (i = 0; i < frame->fmt->memplanes; i++)
+		vb2_set_plane_payload(vb, i, frame->payload[i]);
+
+	return 0;
+}
+
+static void fimc_buf_queue(struct vb2_buffer *vb)
+{
+	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+
+	dbg("ctx: %p, ctx->state: 0x%x", ctx, ctx->state);
+
+	if (ctx->m2m_ctx)
+		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+}
+
+static void fimc_lock(struct vb2_queue *vq)
+{
+	struct fimc_ctx *ctx = vb2_get_drv_priv(vq);
+	mutex_lock(&ctx->fimc_dev->lock);
+}
+
+static void fimc_unlock(struct vb2_queue *vq)
+{
+	struct fimc_ctx *ctx = vb2_get_drv_priv(vq);
+	mutex_unlock(&ctx->fimc_dev->lock);
+}
+
+static struct vb2_ops fimc_qops = {
+	.queue_setup	 = fimc_queue_setup,
+	.buf_prepare	 = fimc_buf_prepare,
+	.buf_queue	 = fimc_buf_queue,
+	.wait_prepare	 = fimc_unlock,
+	.wait_finish	 = fimc_lock,
+	.stop_streaming	 = stop_streaming,
+	.start_streaming = start_streaming,
+};
+
+/*
+ * V4L2 ioctl handlers
+ */
+static int fimc_m2m_querycap(struct file *file, void *fh,
+			     struct v4l2_capability *cap)
+{
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
+	struct fimc_dev *fimc = ctx->fimc_dev;
+
+	strncpy(cap->driver, fimc->pdev->name, sizeof(cap->driver) - 1);
+	strncpy(cap->card, fimc->pdev->name, sizeof(cap->card) - 1);
+	cap->bus_info[0] = 0;
+	cap->capabilities = V4L2_CAP_STREAMING |
+		V4L2_CAP_VIDEO_CAPTURE_MPLANE | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+
+	return 0;
+}
+
+static int fimc_m2m_enum_fmt_mplane(struct file *file, void *priv,
+				    struct v4l2_fmtdesc *f)
+{
+	struct fimc_fmt *fmt;
+
+	fmt = fimc_find_format(NULL, NULL, get_m2m_fmt_flags(f->type),
+			       f->index);
+	if (!fmt)
+		return -EINVAL;
+
+	strncpy(f->description, fmt->name, sizeof(f->description) - 1);
+	f->pixelformat = fmt->fourcc;
+	return 0;
+}
+
+static int fimc_m2m_g_fmt_mplane(struct file *file, void *fh,
+				 struct v4l2_format *f)
+{
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
+	struct fimc_frame *frame = ctx_get_frame(ctx, f->type);
+
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	return fimc_fill_format(frame, f);
+}
+
+static int fimc_try_fmt_mplane(struct fimc_ctx *ctx, struct v4l2_format *f)
+{
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct fimc_variant *variant = fimc->variant;
+	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
+	struct fimc_fmt *fmt;
+	u32 max_w, mod_x, mod_y;
+
+	if (!IS_M2M(f->type))
+		return -EINVAL;
+
+	dbg("w: %d, h: %d", pix->width, pix->height);
+
+	fmt = fimc_find_format(&pix->pixelformat, NULL,
+			       get_m2m_fmt_flags(f->type), 0);
+	if (WARN(fmt == NULL, "Pixel format lookup failed"))
+		return -EINVAL;
+
+	if (pix->field == V4L2_FIELD_ANY)
+		pix->field = V4L2_FIELD_NONE;
+	else if (pix->field != V4L2_FIELD_NONE)
+		return -EINVAL;
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		max_w = variant->pix_limit->scaler_dis_w;
+		mod_x = ffs(variant->min_inp_pixsize) - 1;
+	} else {
+		max_w = variant->pix_limit->out_rot_dis_w;
+		mod_x = ffs(variant->min_out_pixsize) - 1;
+	}
+
+	if (tiled_fmt(fmt)) {
+		mod_x = 6; /* 64 x 32 pixels tile */
+		mod_y = 5;
+	} else {
+		if (variant->min_vsize_align == 1)
+			mod_y = fimc_fmt_is_rgb(fmt->color) ? 0 : 1;
+		else
+			mod_y = ffs(variant->min_vsize_align) - 1;
+	}
+
+	v4l_bound_align_image(&pix->width, 16, max_w, mod_x,
+		&pix->height, 8, variant->pix_limit->scaler_dis_w, mod_y, 0);
+
+	fimc_adjust_mplane_format(fmt, pix->width, pix->height, &f->fmt.pix_mp);
+	return 0;
+}
+
+static int fimc_m2m_try_fmt_mplane(struct file *file, void *fh,
+				   struct v4l2_format *f)
+{
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
+
+	return fimc_try_fmt_mplane(ctx, f);
+}
+
+static int fimc_m2m_s_fmt_mplane(struct file *file, void *fh,
+				 struct v4l2_format *f)
+{
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct vb2_queue *vq;
+	struct fimc_frame *frame;
+	struct v4l2_pix_format_mplane *pix;
+	int i, ret = 0;
+
+	ret = fimc_try_fmt_mplane(ctx, f);
+	if (ret)
+		return ret;
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+
+	if (vb2_is_busy(vq)) {
+		v4l2_err(fimc->m2m.vfd, "queue (%d) busy\n", f->type);
+		return -EBUSY;
+	}
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		frame = &ctx->s_frame;
+	else
+		frame = &ctx->d_frame;
+
+	pix = &f->fmt.pix_mp;
+	frame->fmt = fimc_find_format(&pix->pixelformat, NULL,
+				      get_m2m_fmt_flags(f->type), 0);
+	if (!frame->fmt)
+		return -EINVAL;
+
+	/* Update RGB Alpha control state and value range */
+	fimc_alpha_ctrl_update(ctx);
+
+	for (i = 0; i < frame->fmt->colplanes; i++) {
+		frame->payload[i] =
+			(pix->width * pix->height * frame->fmt->depth[i]) / 8;
+	}
+
+	fimc_fill_frame(frame, f);
+
+	ctx->scaler.enabled = 1;
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		fimc_ctx_state_set(FIMC_PARAMS | FIMC_DST_FMT, ctx);
+	else
+		fimc_ctx_state_set(FIMC_PARAMS | FIMC_SRC_FMT, ctx);
+
+	dbg("f_w: %d, f_h: %d", frame->f_width, frame->f_height);
+
+	return 0;
+}
+
+static int fimc_m2m_reqbufs(struct file *file, void *fh,
+			    struct v4l2_requestbuffers *reqbufs)
+{
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
+
+	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
+}
+
+static int fimc_m2m_querybuf(struct file *file, void *fh,
+			     struct v4l2_buffer *buf)
+{
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
+
+	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
+}
+
+static int fimc_m2m_qbuf(struct file *file, void *fh,
+			 struct v4l2_buffer *buf)
+{
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
+
+	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int fimc_m2m_dqbuf(struct file *file, void *fh,
+			  struct v4l2_buffer *buf)
+{
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
+
+	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int fimc_m2m_streamon(struct file *file, void *fh,
+			     enum v4l2_buf_type type)
+{
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
+
+	/* The source and target color format need to be set */
+	if (V4L2_TYPE_IS_OUTPUT(type)) {
+		if (!fimc_ctx_state_is_set(FIMC_SRC_FMT, ctx))
+			return -EINVAL;
+	} else if (!fimc_ctx_state_is_set(FIMC_DST_FMT, ctx)) {
+		return -EINVAL;
+	}
+
+	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
+}
+
+static int fimc_m2m_streamoff(struct file *file, void *fh,
+			    enum v4l2_buf_type type)
+{
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
+
+	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
+}
+
+static int fimc_m2m_cropcap(struct file *file, void *fh,
+			    struct v4l2_cropcap *cr)
+{
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
+	struct fimc_frame *frame;
+
+	frame = ctx_get_frame(ctx, cr->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	cr->bounds.left = 0;
+	cr->bounds.top = 0;
+	cr->bounds.width = frame->o_width;
+	cr->bounds.height = frame->o_height;
+	cr->defrect = cr->bounds;
+
+	return 0;
+}
+
+static int fimc_m2m_g_crop(struct file *file, void *fh, struct v4l2_crop *cr)
+{
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
+	struct fimc_frame *frame;
+
+	frame = ctx_get_frame(ctx, cr->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	cr->c.left = frame->offs_h;
+	cr->c.top = frame->offs_v;
+	cr->c.width = frame->width;
+	cr->c.height = frame->height;
+
+	return 0;
+}
+
+static int fimc_m2m_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
+{
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct fimc_frame *f;
+	u32 min_size, halign, depth = 0;
+	int i;
+
+	if (cr->c.top < 0 || cr->c.left < 0) {
+		v4l2_err(fimc->m2m.vfd,
+			"doesn't support negative values for top & left\n");
+		return -EINVAL;
+	}
+	if (cr->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		f = &ctx->d_frame;
+	else if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		f = &ctx->s_frame;
+	else
+		return -EINVAL;
+
+	min_size = (f == &ctx->s_frame) ?
+		fimc->variant->min_inp_pixsize : fimc->variant->min_out_pixsize;
+
+	/* Get pixel alignment constraints. */
+	if (fimc->variant->min_vsize_align == 1)
+		halign = fimc_fmt_is_rgb(f->fmt->color) ? 0 : 1;
+	else
+		halign = ffs(fimc->variant->min_vsize_align) - 1;
+
+	for (i = 0; i < f->fmt->colplanes; i++)
+		depth += f->fmt->depth[i];
+
+	v4l_bound_align_image(&cr->c.width, min_size, f->o_width,
+			      ffs(min_size) - 1,
+			      &cr->c.height, min_size, f->o_height,
+			      halign, 64/(ALIGN(depth, 8)));
+
+	/* adjust left/top if cropping rectangle is out of bounds */
+	if (cr->c.left + cr->c.width > f->o_width)
+		cr->c.left = f->o_width - cr->c.width;
+	if (cr->c.top + cr->c.height > f->o_height)
+		cr->c.top = f->o_height - cr->c.height;
+
+	cr->c.left = round_down(cr->c.left, min_size);
+	cr->c.top  = round_down(cr->c.top, fimc->variant->hor_offs_align);
+
+	dbg("l:%d, t:%d, w:%d, h:%d, f_w: %d, f_h: %d",
+	    cr->c.left, cr->c.top, cr->c.width, cr->c.height,
+	    f->f_width, f->f_height);
+
+	return 0;
+}
+
+static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
+{
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct fimc_frame *f;
+	int ret;
+
+	ret = fimc_m2m_try_crop(ctx, cr);
+	if (ret)
+		return ret;
+
+	f = (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) ?
+		&ctx->s_frame : &ctx->d_frame;
+
+	/* Check to see if scaling ratio is within supported range */
+	if (fimc_ctx_state_is_set(FIMC_DST_FMT | FIMC_SRC_FMT, ctx)) {
+		if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+			ret = fimc_check_scaler_ratio(ctx, cr->c.width,
+					cr->c.height, ctx->d_frame.width,
+					ctx->d_frame.height, ctx->rotation);
+		} else {
+			ret = fimc_check_scaler_ratio(ctx, ctx->s_frame.width,
+					ctx->s_frame.height, cr->c.width,
+					cr->c.height, ctx->rotation);
+		}
+		if (ret) {
+			v4l2_err(fimc->m2m.vfd, "Out of scaler range\n");
+			return -EINVAL;
+		}
+	}
+
+	f->offs_h = cr->c.left;
+	f->offs_v = cr->c.top;
+	f->width  = cr->c.width;
+	f->height = cr->c.height;
+
+	fimc_ctx_state_set(FIMC_PARAMS, ctx);
+
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops fimc_m2m_ioctl_ops = {
+	.vidioc_querycap		= fimc_m2m_querycap,
+	.vidioc_enum_fmt_vid_cap_mplane	= fimc_m2m_enum_fmt_mplane,
+	.vidioc_enum_fmt_vid_out_mplane	= fimc_m2m_enum_fmt_mplane,
+	.vidioc_g_fmt_vid_cap_mplane	= fimc_m2m_g_fmt_mplane,
+	.vidioc_g_fmt_vid_out_mplane	= fimc_m2m_g_fmt_mplane,
+	.vidioc_try_fmt_vid_cap_mplane	= fimc_m2m_try_fmt_mplane,
+	.vidioc_try_fmt_vid_out_mplane	= fimc_m2m_try_fmt_mplane,
+	.vidioc_s_fmt_vid_cap_mplane	= fimc_m2m_s_fmt_mplane,
+	.vidioc_s_fmt_vid_out_mplane	= fimc_m2m_s_fmt_mplane,
+	.vidioc_reqbufs			= fimc_m2m_reqbufs,
+	.vidioc_querybuf		= fimc_m2m_querybuf,
+	.vidioc_qbuf			= fimc_m2m_qbuf,
+	.vidioc_dqbuf			= fimc_m2m_dqbuf,
+	.vidioc_streamon		= fimc_m2m_streamon,
+	.vidioc_streamoff		= fimc_m2m_streamoff,
+	.vidioc_g_crop			= fimc_m2m_g_crop,
+	.vidioc_s_crop			= fimc_m2m_s_crop,
+	.vidioc_cropcap			= fimc_m2m_cropcap
+
+};
+
+static int queue_init(void *priv, struct vb2_queue *src_vq,
+		      struct vb2_queue *dst_vq)
+{
+	struct fimc_ctx *ctx = priv;
+	int ret;
+
+	memset(src_vq, 0, sizeof(*src_vq));
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
+	src_vq->drv_priv = ctx;
+	src_vq->ops = &fimc_qops;
+	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	memset(dst_vq, 0, sizeof(*dst_vq));
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
+	dst_vq->drv_priv = ctx;
+	dst_vq->ops = &fimc_qops;
+	dst_vq->mem_ops = &vb2_dma_contig_memops;
+	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+
+	return vb2_queue_init(dst_vq);
+}
+
+static int fimc_m2m_open(struct file *file)
+{
+	struct fimc_dev *fimc = video_drvdata(file);
+	struct fimc_ctx *ctx;
+	int ret;
+
+	dbg("pid: %d, state: 0x%lx, refcnt: %d",
+	    task_pid_nr(current), fimc->state, fimc->vid_cap.refcnt);
+
+	/*
+	 * Return if the corresponding video capture node
+	 * is already opened.
+	 */
+	if (fimc->vid_cap.refcnt > 0)
+		return -EBUSY;
+
+	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+	v4l2_fh_init(&ctx->fh, fimc->m2m.vfd);
+	ctx->fimc_dev = fimc;
+
+	/* Default color format */
+	ctx->s_frame.fmt = fimc_get_format(0);
+	ctx->d_frame.fmt = fimc_get_format(0);
+
+	ret = fimc_ctrls_create(ctx);
+	if (ret)
+		goto error_fh;
+
+	/* Use separate control handler per file handle */
+	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
+	file->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
+
+	/* Setup the device context for memory-to-memory mode */
+	ctx->state = FIMC_CTX_M2M;
+	ctx->flags = 0;
+	ctx->in_path = FIMC_DMA;
+	ctx->out_path = FIMC_DMA;
+
+	ctx->m2m_ctx = v4l2_m2m_ctx_init(fimc->m2m.m2m_dev, ctx, queue_init);
+	if (IS_ERR(ctx->m2m_ctx)) {
+		ret = PTR_ERR(ctx->m2m_ctx);
+		goto error_c;
+	}
+
+	if (fimc->m2m.refcnt++ == 0)
+		set_bit(ST_M2M_RUN, &fimc->state);
+	return 0;
+
+error_c:
+	fimc_ctrls_delete(ctx);
+error_fh:
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	kfree(ctx);
+	return ret;
+}
+
+static int fimc_m2m_release(struct file *file)
+{
+	struct fimc_ctx *ctx = fh_to_ctx(file->private_data);
+	struct fimc_dev *fimc = ctx->fimc_dev;
+
+	dbg("pid: %d, state: 0x%lx, refcnt= %d",
+		task_pid_nr(current), fimc->state, fimc->m2m.refcnt);
+
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	fimc_ctrls_delete(ctx);
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+
+	if (--fimc->m2m.refcnt <= 0)
+		clear_bit(ST_M2M_RUN, &fimc->state);
+	kfree(ctx);
+	return 0;
+}
+
+static unsigned int fimc_m2m_poll(struct file *file,
+				  struct poll_table_struct *wait)
+{
+	struct fimc_ctx *ctx = fh_to_ctx(file->private_data);
+
+	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
+}
+
+
+static int fimc_m2m_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct fimc_ctx *ctx = fh_to_ctx(file->private_data);
+
+	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+}
+
+static const struct v4l2_file_operations fimc_m2m_fops = {
+	.owner		= THIS_MODULE,
+	.open		= fimc_m2m_open,
+	.release	= fimc_m2m_release,
+	.poll		= fimc_m2m_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= fimc_m2m_mmap,
+};
+
+static struct v4l2_m2m_ops m2m_ops = {
+	.device_run	= fimc_device_run,
+	.job_abort	= fimc_job_abort,
+};
+
+int fimc_register_m2m_device(struct fimc_dev *fimc,
+			     struct v4l2_device *v4l2_dev)
+{
+	struct video_device *vfd;
+	struct platform_device *pdev;
+	int ret = 0;
+
+	if (!fimc)
+		return -ENODEV;
+
+	pdev = fimc->pdev;
+	fimc->v4l2_dev = v4l2_dev;
+
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(v4l2_dev, "Failed to allocate video device\n");
+		return -ENOMEM;
+	}
+
+	vfd->fops = &fimc_m2m_fops;
+	vfd->ioctl_ops = &fimc_m2m_ioctl_ops;
+	vfd->v4l2_dev = v4l2_dev;
+	vfd->minor = -1;
+	vfd->release = video_device_release;
+	vfd->lock = &fimc->lock;
+
+	snprintf(vfd->name, sizeof(vfd->name), "%s.m2m", dev_name(&pdev->dev));
+	video_set_drvdata(vfd, fimc);
+
+	fimc->m2m.vfd = vfd;
+	fimc->m2m.m2m_dev = v4l2_m2m_init(&m2m_ops);
+	if (IS_ERR(fimc->m2m.m2m_dev)) {
+		v4l2_err(v4l2_dev, "failed to initialize v4l2-m2m device\n");
+		ret = PTR_ERR(fimc->m2m.m2m_dev);
+		goto err_init;
+	}
+
+	ret = media_entity_init(&vfd->entity, 0, NULL, 0);
+	if (!ret)
+		return 0;
+
+	v4l2_m2m_release(fimc->m2m.m2m_dev);
+err_init:
+	video_device_release(fimc->m2m.vfd);
+	return ret;
+}
+
+void fimc_unregister_m2m_device(struct fimc_dev *fimc)
+{
+	if (!fimc)
+		return;
+
+	if (fimc->m2m.m2m_dev)
+		v4l2_m2m_release(fimc->m2m.m2m_dev);
+	if (fimc->m2m.vfd) {
+		media_entity_cleanup(&fimc->m2m.vfd->entity);
+		/* Can also be called if video device wasn't registered */
+		video_unregister_device(fimc->m2m.vfd);
+	}
+}
-- 
1.7.10

