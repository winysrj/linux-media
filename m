Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:55879 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394Ab2ENVjI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 17:39:08 -0400
Received: by weyu7 with SMTP id u7so2086973wey.19
        for <linux-media@vger.kernel.org>; Mon, 14 May 2012 14:39:07 -0700 (PDT)
Message-ID: <4FB17B79.2000207@gmail.com>
Date: Mon, 14 May 2012 23:39:05 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [GIT PULL FOR 3.5] s5p-fimc driver updates
References: <4FA3F635.60409@samsung.com> <4FAB80D5.50500@samsung.com>
In-Reply-To: <4FAB80D5.50500@samsung.com>
Content-Type: multipart/mixed;
 boundary="------------000606000007020108060102"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000606000007020108060102
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05/10/2012 10:48 AM, Sylwester Nawrocki wrote:
> On 05/04/2012 05:31 PM, Sylwester Nawrocki wrote:
>> Hi Mauro,
>>
>> The following changes since commit 34b2debaa62bfa384ef91b61cf2c40c48e86a5e2:
>>
>>    s5p-fimc: Correct memory allocation for VIDIOC_CREATE_BUFS (2012-05-04 17:07:24 +0200)
>>
>> are available in the git repository at:
>>
>>    git://git.infradead.org/users/kmpark/linux-samsung v4l-fimc-exynos4x12
>>
>> for you to fetch changes up to bab96b068afa07105139be09d3830cc9ed580382:
>>
>>    s5p-fimc: Use selection API in place of crop operations (2012-05-04 17:18:38 +0200)
> 
> Mauro,
> 
> I've found a few issues in this series afterwards and re-edited 3 commits there.
> Here is an updated pull request:
> 
> The following changes since commit ae45d3e9aea0ab951dbbca2238fbfbf3993f1e7f:
> 
>    s5p-fimc: Correct memory allocation for VIDIOC_CREATE_BUFS (2012-05-09 16:07:49 +0200)
> 
> are available in the git repository at:
> 
>    git://git.infradead.org/users/kmpark/linux-samsung v4l-fimc-exynos4x12
> 
> for you to fetch changes up to 5feefe6656583de6fd4ef1d53b19031dd5efeec1:
> 
>    s5p-fimc: Use selection API in place of crop operations (2012-05-09 16:11:29 +0200)
> 
> ----------------------------------------------------------------
> Sylwester Nawrocki (14):
>        V4L: Extend V4L2_CID_COLORFX with more image effects
>        s5p-fimc: Avoid crash with null platform_data
>        s5p-fimc: Move m2m node driver into separate file

It seems there is a conflict now with this patch:
http://git.linuxtv.org/media_tree.git/commit/5126f2590bee412e3053de851cb07f531e4be36a

Attached are updated versions of the two conflicting patches, the others 
don't need touching.

I could provide rebased version of the whole change set tomorrow - if needed.

Kind regards,
Sylwester

>        s5p-fimc: Use v4l2_subdev internal ops to register video nodes
>        s5p-fimc: Refactor the register interface functions
>        s5p-fimc: Add FIMC-LITE register definitions
>        s5p-fimc: Rework the video pipeline control functions
>        s5p-fimc: Prefix format enumerations with FIMC_FMT_
>        s5p-fimc: Minor cleanups
>        s5p-fimc: Make sure an interrupt is properly requested
>        s5p-fimc: Add support for Exynos4x12 FIMC-LITE
>        s5p-fimc: Update copyright notices
>        s5p-fimc: Add color effect control
>        s5p-fimc: Use selection API in place of crop operations

--------------000606000007020108060102
Content-Type: text/x-patch;
 name="0001-s5p-fimc-Move-m2m-node-driver-into-separate-file.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-s5p-fimc-Move-m2m-node-driver-into-separate-file.patch"

>From c962fb892bebe91e05f2b9f5348e8a390afe5f27 Mon Sep 17 00:00:00 2001
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Date: Mon, 14 May 2012 23:10:49 +0200
Subject: [PATCH 1/2] s5p-fimc: Move m2m node driver into separate file

Virtually no functional changes, just code reordering. This let us to
clearly separate all logical functions available in the driver: fimc
capture, mem-to-mem, and later fimc-lite capture, ISP features, etc.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/Makefile       |    2 +-
 drivers/media/video/s5p-fimc/fimc-capture.c |   68 ++-
 drivers/media/video/s5p-fimc/fimc-core.c    |  859 +--------------------------
 drivers/media/video/s5p-fimc/fimc-core.h    |   10 +-
 drivers/media/video/s5p-fimc/fimc-m2m.c     |  813 +++++++++++++++++++++++++
 5 files changed, 895 insertions(+), 857 deletions(-)
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
index 9a0d952..2c7a4f8 100644
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
@@ -166,6 +166,70 @@ int fimc_capture_config_update(struct fimc_ctx *ctx)
 	return ret;
 }
 
+void fimc_capture_irq_handler(struct fimc_dev *fimc, int deq_buf)
+{
+	struct fimc_vid_cap *cap = &fimc->vid_cap;
+	struct fimc_vid_buffer *v_buf;
+	struct timeval *tv;
+	struct timespec ts;
+
+	if (test_and_clear_bit(ST_CAPT_SHUT, &fimc->state)) {
+		wake_up(&fimc->irq_queue);
+		goto done;
+	}
+
+	if (!list_empty(&cap->active_buf_q) &&
+	    test_bit(ST_CAPT_RUN, &fimc->state) && deq_buf) {
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
+		if (deq_buf)
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
@@ -1245,7 +1309,7 @@ void fimc_sensor_notify(struct v4l2_subdev *sd, unsigned int notification,
 					 struct fimc_vid_buffer, list);
 			vb2_set_plane_payload(&buf->vb, 0, *((u32 *)arg));
 		}
-		fimc_capture_irq_handler(fimc, true);
+		fimc_capture_irq_handler(fimc, 1);
 		fimc_deactivate_capture(fimc);
 		spin_unlock_irqrestore(&fimc->slock, irq_flags);
 	}
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index f6b9060..749db4d 100644
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
@@ -437,12 +320,9 @@ static irqreturn_t fimc_irq_handler(int irq, void *priv)
 			return IRQ_HANDLED;
 		}
 	} else if (test_bit(ST_CAPT_PEND, &fimc->state)) {
-		fimc_capture_irq_handler(fimc,
-				 !test_bit(ST_CAPT_JPEG, &fimc->state));
-		if (cap->active_buf_cnt == 1) {
-			fimc_deactivate_capture(fimc);
-			clear_bit(ST_CAPT_STREAM, &fimc->state);
-		}
+		int last_buf = test_bit(ST_CAPT_JPEG, &fimc->state) &&
+				fimc->vid_cap.reqbufs_count == 1;
+		fimc_capture_irq_handler(fimc, !last_buf);
 	}
 out:
 	spin_unlock(&fimc->slock);
@@ -582,154 +462,6 @@ void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f)
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
@@ -877,39 +609,6 @@ void fimc_alpha_ctrl_update(struct fimc_ctx *ctx)
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
@@ -988,18 +687,6 @@ void fimc_adjust_mplane_format(struct fimc_fmt *fmt, u32 width, u32 height,
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
@@ -1032,534 +719,6 @@ struct fimc_fmt *fimc_find_format(const u32 *pixelformat, const u32 *mbus_code,
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
-	/* Locking in file operations other than ioctl should be done
-	   by the driver, not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
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
index 7afabb0..288631a 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -712,6 +712,7 @@ void fimc_adjust_mplane_format(struct fimc_fmt *fmt, u32 width, u32 height,
 			       struct v4l2_pix_format_mplane *pix);
 struct fimc_fmt *fimc_find_format(const u32 *pixelformat, const u32 *mbus_code,
 				  unsigned int mask, int index);
+struct fimc_fmt *fimc_get_format(unsigned int index);
 
 int fimc_check_scaler_ratio(struct fimc_ctx *ctx, int sw, int sh,
 			    int dw, int dh, int rotation);
@@ -722,7 +723,7 @@ int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f);
 void fimc_set_yuv_order(struct fimc_ctx *ctx);
 void fimc_fill_frame(struct fimc_frame *frame, struct v4l2_format *f);
-void fimc_capture_irq_handler(struct fimc_dev *fimc, bool done);
+void fimc_capture_irq_handler(struct fimc_dev *fimc, int deq_buf);
 
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
index 0000000..4a755ff
--- /dev/null
+++ b/drivers/media/video/s5p-fimc/fimc-m2m.c
@@ -0,0 +1,813 @@
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
+	struct samsung_fimc_variant *variant = fimc->variant;
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
+	/*
+	 * Locking in file operations other than ioctl should be done
+	 * by the driver, not the V4L2 core.
+	 * This driver needs auditing so that this flag can be removed.
+	 */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
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
1.7.4.1


--------------000606000007020108060102
Content-Type: text/x-patch;
 name="0002-s5p-fimc-Use-v4l2_subdev-internal-ops-to-register-vi.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-s5p-fimc-Use-v4l2_subdev-internal-ops-to-register-vi.pa";
 filename*1="tch"

>From 610f467a3cb02ca34ce48bb8d6cc3f2409571f93 Mon Sep 17 00:00:00 2001
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Date: Mon, 14 May 2012 23:15:21 +0200
Subject: [PATCH 2/2] s5p-fimc: Use v4l2_subdev internal ops to register video nodes

In order to be able to select only FIMC-LITE support, which is added
with subsequent patches, the regular FIMC support is now contained
only in fimc-core.c, fimc-m2m.c and fimc-capture.c files. The graph
and pipeline management is now solely handled in fimc-mdevice.[ch].
This means the FIMC driver can now be excluded with Kconfig option,
leaving only FIMC-LITE and allowing this driver to be reused in SoCs
that have only FIMC-LITE and no regular FIMC IP.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |  142 +++++++++++++++------------
 drivers/media/video/s5p-fimc/fimc-core.c    |   13 ++-
 drivers/media/video/s5p-fimc/fimc-core.h    |    7 +-
 drivers/media/video/s5p-fimc/fimc-m2m.c     |   18 +++-
 drivers/media/video/s5p-fimc/fimc-mdevice.c |   89 +++++++----------
 drivers/media/video/s5p-fimc/fimc-mdevice.h |    1 +
 6 files changed, 139 insertions(+), 131 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 2c7a4f8..51cb447 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -993,7 +993,7 @@ static int fimc_pipeline_validate(struct fimc_dev *fimc)
 		if (!(pad->flags & MEDIA_PAD_FL_SINK))
 			break;
 		/* Don't call FIMC subdev operation to avoid nested locking */
-		if (sd == fimc->vid_cap.subdev) {
+		if (sd == &fimc->vid_cap.subdev) {
 			struct fimc_frame *ff = &vid_cap->ctx->s_frame;
 			sink_fmt.format.width = ff->f_width;
 			sink_fmt.format.height = ff->f_height;
@@ -1489,53 +1489,6 @@ static struct v4l2_subdev_ops fimc_subdev_ops = {
 	.pad = &fimc_subdev_pad_ops,
 };
 
-static int fimc_create_capture_subdev(struct fimc_dev *fimc,
-				      struct v4l2_device *v4l2_dev)
-{
-	struct v4l2_subdev *sd;
-	int ret;
-
-	sd = kzalloc(sizeof(*sd), GFP_KERNEL);
-	if (!sd)
-		return -ENOMEM;
-
-	v4l2_subdev_init(sd, &fimc_subdev_ops);
-	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
-	snprintf(sd->name, sizeof(sd->name), "FIMC.%d", fimc->pdev->id);
-
-	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
-	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
-	ret = media_entity_init(&sd->entity, FIMC_SD_PADS_NUM,
-				fimc->vid_cap.sd_pads, 0);
-	if (ret)
-		goto me_err;
-	ret = v4l2_device_register_subdev(v4l2_dev, sd);
-	if (ret)
-		goto sd_err;
-
-	fimc->vid_cap.subdev = sd;
-	v4l2_set_subdevdata(sd, fimc);
-	sd->entity.ops = &fimc_sd_media_ops;
-	return 0;
-sd_err:
-	media_entity_cleanup(&sd->entity);
-me_err:
-	kfree(sd);
-	return ret;
-}
-
-static void fimc_destroy_capture_subdev(struct fimc_dev *fimc)
-{
-	struct v4l2_subdev *sd = fimc->vid_cap.subdev;
-
-	if (!sd)
-		return;
-	media_entity_cleanup(&sd->entity);
-	v4l2_device_unregister_subdev(sd);
-	kfree(sd);
-	fimc->vid_cap.subdev = NULL;
-}
-
 /* Set default format at the sensor and host interface */
 static int fimc_capture_set_default_format(struct fimc_dev *fimc)
 {
@@ -1554,7 +1507,7 @@ static int fimc_capture_set_default_format(struct fimc_dev *fimc)
 }
 
 /* fimc->lock must be already initialized */
-int fimc_register_capture_device(struct fimc_dev *fimc,
+static int fimc_register_capture_device(struct fimc_dev *fimc,
 				 struct v4l2_device *v4l2_dev)
 {
 	struct video_device *vfd;
@@ -1572,7 +1525,7 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
 	ctx->out_path	 = FIMC_DMA;
 	ctx->state	 = FIMC_CTX_CAP;
 	ctx->s_frame.fmt = fimc_find_format(NULL, NULL, FMT_FLAGS_CAM, 0);
-	ctx->d_frame.fmt = fimc_find_format(NULL, NULL, FMT_FLAGS_CAM, 0);
+	ctx->d_frame.fmt = ctx->s_frame.fmt;
 
 	vfd = video_device_alloc();
 	if (!vfd) {
@@ -1580,8 +1533,7 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
 		goto err_vd_alloc;
 	}
 
-	snprintf(vfd->name, sizeof(vfd->name), "%s.capture",
-		 dev_name(&fimc->pdev->dev));
+	snprintf(vfd->name, sizeof(vfd->name), "fimc.%d.capture", fimc->id);
 
 	vfd->fops	= &fimc_capture_fops;
 	vfd->ioctl_ops	= &fimc_capture_ioctl_ops;
@@ -1616,18 +1568,22 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
 
 	vb2_queue_init(q);
 
-	fimc->vid_cap.vd_pad.flags = MEDIA_PAD_FL_SINK;
-	ret = media_entity_init(&vfd->entity, 1, &fimc->vid_cap.vd_pad, 0);
+	vid_cap->vd_pad.flags = MEDIA_PAD_FL_SINK;
+	ret = media_entity_init(&vfd->entity, 1, &vid_cap->vd_pad, 0);
 	if (ret)
 		goto err_ent;
-	ret = fimc_create_capture_subdev(fimc, v4l2_dev);
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
 	if (ret)
-		goto err_sd_reg;
+		goto err_vd;
+
+	v4l2_info(v4l2_dev, "Registered %s as /dev/%s\n",
+		  vfd->name, video_device_node_name(vfd));
 
 	vfd->ctrl_handler = &ctx->ctrl_handler;
 	return 0;
 
-err_sd_reg:
+err_vd:
 	media_entity_cleanup(&vfd->entity);
 err_ent:
 	video_device_release(vfd);
@@ -1636,17 +1592,73 @@ err_vd_alloc:
 	return ret;
 }
 
-void fimc_unregister_capture_device(struct fimc_dev *fimc)
+static int fimc_capture_subdev_registered(struct v4l2_subdev *sd)
 {
-	struct video_device *vfd = fimc->vid_cap.vfd;
+	struct fimc_dev *fimc = v4l2_get_subdevdata(sd);
+	int ret;
 
-	if (vfd) {
-		media_entity_cleanup(&vfd->entity);
-		/* Can also be called if video device was
-		   not registered */
-		video_unregister_device(vfd);
+	ret = fimc_register_m2m_device(fimc, sd->v4l2_dev);
+	if (ret)
+		return ret;
+
+	ret = fimc_register_capture_device(fimc, sd->v4l2_dev);
+	if (ret)
+		fimc_unregister_m2m_device(fimc);
+
+	return ret;
+}
+
+static void fimc_capture_subdev_unregistered(struct v4l2_subdev *sd)
+{
+	struct fimc_dev *fimc = v4l2_get_subdevdata(sd);
+
+	if (fimc == NULL)
+		return;
+
+	fimc_unregister_m2m_device(fimc);
+
+	if (fimc->vid_cap.vfd) {
+		media_entity_cleanup(&fimc->vid_cap.vfd->entity);
+		video_unregister_device(fimc->vid_cap.vfd);
+		fimc->vid_cap.vfd = NULL;
 	}
-	fimc_destroy_capture_subdev(fimc);
+
 	kfree(fimc->vid_cap.ctx);
 	fimc->vid_cap.ctx = NULL;
 }
+
+static const struct v4l2_subdev_internal_ops fimc_capture_sd_internal_ops = {
+	.registered = fimc_capture_subdev_registered,
+	.unregistered = fimc_capture_subdev_unregistered,
+};
+
+int fimc_initialize_capture_subdev(struct fimc_dev *fimc)
+{
+	struct v4l2_subdev *sd = &fimc->vid_cap.subdev;
+	int ret;
+
+	v4l2_subdev_init(sd, &fimc_subdev_ops);
+	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	snprintf(sd->name, sizeof(sd->name), "FIMC.%d", fimc->pdev->id);
+
+	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&sd->entity, FIMC_SD_PADS_NUM,
+				fimc->vid_cap.sd_pads, 0);
+	if (ret)
+		return ret;
+
+	sd->entity.ops = &fimc_sd_media_ops;
+	sd->internal_ops = &fimc_capture_sd_internal_ops;
+	v4l2_set_subdevdata(sd, fimc);
+	return 0;
+}
+
+void fimc_unregister_capture_subdev(struct fimc_dev *fimc)
+{
+	struct v4l2_subdev *sd = &fimc->vid_cap.subdev;
+
+	v4l2_device_unregister_subdev(sd);
+	media_entity_cleanup(&sd->entity);
+	v4l2_set_subdevdata(sd, NULL);
+}
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 749db4d..add24cd 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -842,8 +842,6 @@ static int fimc_probe(struct platform_device *pdev)
 	clk_set_rate(fimc->clock[CLK_BUS], drv_data->lclk_frequency);
 	clk_enable(fimc->clock[CLK_BUS]);
 
-	platform_set_drvdata(pdev, fimc);
-
 	ret = devm_request_irq(&pdev->dev, res->start, fimc_irq_handler,
 			       0, pdev->name, fimc);
 	if (ret) {
@@ -851,10 +849,15 @@ static int fimc_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
+	ret = fimc_initialize_capture_subdev(fimc);
+	if (ret)
+		goto err_clk;
+
+	platform_set_drvdata(pdev, fimc);
 	pm_runtime_enable(&pdev->dev);
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0)
-		goto err_clk;
+		goto err_sd;
 	/* Initialize contiguous memory allocator */
 	fimc->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
 	if (IS_ERR(fimc->alloc_ctx)) {
@@ -866,9 +869,10 @@ static int fimc_probe(struct platform_device *pdev)
 
 	pm_runtime_put(&pdev->dev);
 	return 0;
-
 err_pm:
 	pm_runtime_put(&pdev->dev);
+err_sd:
+	fimc_unregister_capture_subdev(fimc);
 err_clk:
 	fimc_clk_put(fimc);
 	return ret;
@@ -953,6 +957,7 @@ static int __devexit fimc_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 
+	fimc_unregister_capture_subdev(fimc);
 	vb2_dma_contig_cleanup_ctx(fimc->alloc_ctx);
 
 	clk_disable(fimc->clock[CLK_BUS]);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 288631a..ef7c6a2 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -331,7 +331,7 @@ struct fimc_vid_cap {
 	struct fimc_ctx			*ctx;
 	struct vb2_alloc_ctx		*alloc_ctx;
 	struct video_device		*vfd;
-	struct v4l2_subdev		*subdev;
+	struct v4l2_subdev		subdev;
 	struct media_pad		vd_pad;
 	struct v4l2_mbus_framefmt	mf;
 	struct media_pad		sd_pads[FIMC_SD_PADS_NUM];
@@ -737,9 +737,8 @@ void fimc_m2m_job_finish(struct fimc_ctx *ctx, int vb_state);
 
 /* -----------------------------------------------------*/
 /* fimc-capture.c					*/
-int fimc_register_capture_device(struct fimc_dev *fimc,
-				 struct v4l2_device *v4l2_dev);
-void fimc_unregister_capture_device(struct fimc_dev *fimc);
+int fimc_initialize_capture_subdev(struct fimc_dev *fimc);
+void fimc_unregister_capture_subdev(struct fimc_dev *fimc);
 int fimc_capture_ctrls_create(struct fimc_dev *fimc);
 void fimc_sensor_notify(struct v4l2_subdev *sd, unsigned int notification,
 			void *arg);
diff --git a/drivers/media/video/s5p-fimc/fimc-m2m.c b/drivers/media/video/s5p-fimc/fimc-m2m.c
index 4a755ff..bb81126 100644
--- a/drivers/media/video/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/video/s5p-fimc/fimc-m2m.c
@@ -777,7 +777,8 @@ int fimc_register_m2m_device(struct fimc_dev *fimc,
 	 * This driver needs auditing so that this flag can be removed.
 	 */
 	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
-	snprintf(vfd->name, sizeof(vfd->name), "%s.m2m", dev_name(&pdev->dev));
+
+	snprintf(vfd->name, sizeof(vfd->name), "fimc.%d.m2m", fimc->id);
 	video_set_drvdata(vfd, fimc);
 
 	fimc->m2m.vfd = vfd;
@@ -789,9 +790,20 @@ int fimc_register_m2m_device(struct fimc_dev *fimc,
 	}
 
 	ret = media_entity_init(&vfd->entity, 0, NULL, 0);
-	if (!ret)
-		return 0;
+	if (ret)
+		goto err_me;
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
+	if (ret)
+		goto err_vd;
+
+	v4l2_info(v4l2_dev, "Registered %s as /dev/%s\n",
+		  vfd->name, video_device_node_name(vfd));
+	return 0;
 
+err_vd:
+	media_entity_cleanup(&vfd->entity);
+err_me:
 	v4l2_m2m_release(fimc->m2m.m2m_dev);
 err_init:
 	video_device_release(fimc->m2m.vfd);
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index f97ac02..c319842 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -304,8 +304,9 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 static int fimc_register_callback(struct device *dev, void *p)
 {
 	struct fimc_dev *fimc = dev_get_drvdata(dev);
+	struct v4l2_subdev *sd = &fimc->vid_cap.subdev;
 	struct fimc_md *fmd = p;
-	int ret;
+	int ret = 0;
 
 	if (!fimc || !fimc->pdev)
 		return 0;
@@ -313,12 +314,14 @@ static int fimc_register_callback(struct device *dev, void *p)
 		return 0;
 
 	fmd->fimc[fimc->pdev->id] = fimc;
-	ret = fimc_register_m2m_device(fimc, &fmd->v4l2_dev);
-	if (ret)
-		return ret;
-	ret = fimc_register_capture_device(fimc, &fmd->v4l2_dev);
-	if (!ret)
-		fimc->vid_cap.user_subdev_api = fmd->user_subdev_api;
+	sd->grp_id = FIMC_GROUP_ID;
+
+	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
+	if (ret) {
+		v4l2_err(&fmd->v4l2_dev, "Failed to register FIMC.%d (%d)\n",
+			 fimc->id, ret);
+	}
+
 	return ret;
 }
 
@@ -401,8 +404,7 @@ static void fimc_md_unregister_entities(struct fimc_md *fmd)
 	for (i = 0; i < FIMC_MAX_DEVS; i++) {
 		if (fmd->fimc[i] == NULL)
 			continue;
-		fimc_unregister_m2m_device(fmd->fimc[i]);
-		fimc_unregister_capture_device(fmd->fimc[i]);
+		v4l2_device_unregister_subdev(&fmd->fimc[i]->vid_cap.subdev);
 		fmd->fimc[i] = NULL;
 	}
 	for (i = 0; i < CSIS_MAX_ENTITIES; i++) {
@@ -420,35 +422,6 @@ static void fimc_md_unregister_entities(struct fimc_md *fmd)
 	}
 }
 
-static int fimc_md_register_video_nodes(struct fimc_md *fmd)
-{
-	struct video_device *vdev;
-	int i, ret = 0;
-
-	for (i = 0; i < FIMC_MAX_DEVS && !ret; i++) {
-		if (!fmd->fimc[i])
-			continue;
-
-		vdev = fmd->fimc[i]->m2m.vfd;
-		if (vdev) {
-			ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
-			if (ret)
-				break;
-			v4l2_info(&fmd->v4l2_dev, "Registered %s as /dev/%s\n",
-				  vdev->name, video_device_node_name(vdev));
-		}
-
-		vdev = fmd->fimc[i]->vid_cap.vfd;
-		if (vdev == NULL)
-			continue;
-		ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
-		v4l2_info(&fmd->v4l2_dev, "Registered %s as /dev/%s\n",
-			  vdev->name, video_device_node_name(vdev));
-	}
-
-	return ret;
-}
-
 /**
  * __fimc_md_create_fimc_links - create links to all FIMC entities
  * @fmd: fimc media device
@@ -479,7 +452,7 @@ static int __fimc_md_create_fimc_links(struct fimc_md *fmd,
 			continue;
 
 		flags = (i == fimc_id) ? MEDIA_LNK_FL_ENABLED : 0;
-		sink = &fmd->fimc[i]->vid_cap.subdev->entity;
+		sink = &fmd->fimc[i]->vid_cap.subdev.entity;
 		ret = media_entity_create_link(source, pad, sink,
 					      FIMC_SD_PAD_SINK, flags);
 		if (ret)
@@ -588,7 +561,7 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 	for (i = 0; i < FIMC_MAX_DEVS; i++) {
 		if (!fmd->fimc[i])
 			continue;
-		source = &fmd->fimc[i]->vid_cap.subdev->entity;
+		source = &fmd->fimc[i]->vid_cap.subdev.entity;
 		sink = &fmd->fimc[i]->vid_cap.vfd->entity;
 		ret = media_entity_create_link(source, FIMC_SD_PAD_SOURCE,
 					      sink, 0, flags);
@@ -817,42 +790,48 @@ static int fimc_md_probe(struct platform_device *pdev)
 	ret = media_device_register(&fmd->media_dev);
 	if (ret < 0) {
 		v4l2_err(v4l2_dev, "Failed to register media device: %d\n", ret);
-		goto err2;
+		goto err_md;
 	}
 	ret = fimc_md_get_clocks(fmd);
 	if (ret)
-		goto err3;
+		goto err_clk;
 
 	fmd->user_subdev_api = false;
+
+	/* Protect the media graph while we're registering entities */
+	mutex_lock(&fmd->media_dev.graph_mutex);
+
 	ret = fimc_md_register_platform_entities(fmd);
 	if (ret)
-		goto err3;
+		goto err_unlock;
 
 	if (pdev->dev.platform_data) {
 		ret = fimc_md_register_sensor_entities(fmd);
 		if (ret)
-			goto err3;
+			goto err_unlock;
 	}
 	ret = fimc_md_create_links(fmd);
 	if (ret)
-		goto err3;
+		goto err_unlock;
 	ret = v4l2_device_register_subdev_nodes(&fmd->v4l2_dev);
 	if (ret)
-		goto err3;
-	ret = fimc_md_register_video_nodes(fmd);
-	if (ret)
-		goto err3;
+		goto err_unlock;
 
 	ret = device_create_file(&pdev->dev, &dev_attr_subdev_conf_mode);
-	if (!ret) {
-		platform_set_drvdata(pdev, fmd);
-		return 0;
-	}
-err3:
+	if (ret)
+		goto err_unlock;
+
+	platform_set_drvdata(pdev, fmd);
+	mutex_unlock(&fmd->media_dev.graph_mutex);
+	return 0;
+
+err_unlock:
+	mutex_unlock(&fmd->media_dev.graph_mutex);
+err_clk:
 	media_device_unregister(&fmd->media_dev);
 	fimc_md_put_clocks(fmd);
 	fimc_md_unregister_entities(fmd);
-err2:
+err_md:
 	v4l2_device_unregister(&fmd->v4l2_dev);
 	return ret;
 }
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.h b/drivers/media/video/s5p-fimc/fimc-mdevice.h
index da37808..4f3b69c 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.h
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.h
@@ -24,6 +24,7 @@
 #define SENSOR_GROUP_ID		(1 << 8)
 #define CSIS_GROUP_ID		(1 << 9)
 #define WRITEBACK_GROUP_ID	(1 << 10)
+#define FIMC_GROUP_ID		(1 << 11)
 
 #define FIMC_MAX_SENSORS	8
 #define FIMC_MAX_CAMCLKS	2
-- 
1.7.4.1


--------------000606000007020108060102--
