Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47172 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab3JLMca (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Oct 2013 08:32:30 -0400
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, pawel@osciak.com,
	javier.martin@vista-silicon.com, m.szyprowski@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com, k.debski@samsung.com,
	p.zabel@pengutronix.de, kyungmin.park@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v2 09/10] exynos-gsc: Use mem-to-mem ioctl helpers
Date: Sat, 12 Oct 2013 14:31:59 +0200
Message-Id: <1381581120-26883-10-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1381581120-26883-1-git-send-email-s.nawrocki@samsung.com>
References: <1381581120-26883-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify the driver by using the m2m ioctl and vb2 helpers.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v1:
 - removed unused gsc_m2m_reqbufs() function.
---
 drivers/media/platform/exynos-gsc/gsc-core.h |   12 --
 drivers/media/platform/exynos-gsc/gsc-m2m.c  |  152 +++++---------------------
 2 files changed, 27 insertions(+), 137 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index c79b3cb..c4540a8 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.h
+++ b/drivers/media/platform/exynos-gsc/gsc-core.h
@@ -463,18 +463,6 @@ static inline void gsc_hw_clear_irq(struct gsc_dev *dev, int irq)
 	writel(cfg, dev->regs + GSC_IRQ);
 }
 
-static inline void gsc_lock(struct vb2_queue *vq)
-{
-	struct gsc_ctx *ctx = vb2_get_drv_priv(vq);
-	mutex_lock(&ctx->gsc_dev->lock);
-}
-
-static inline void gsc_unlock(struct vb2_queue *vq)
-{
-	struct gsc_ctx *ctx = vb2_get_drv_priv(vq);
-	mutex_unlock(&ctx->gsc_dev->lock);
-}
-
 static inline bool gsc_ctx_state_is_set(u32 mask, struct gsc_ctx *ctx)
 {
 	unsigned long flags;
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index 78bcb92..42da08c 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -73,11 +73,11 @@ void gsc_m2m_job_finish(struct gsc_ctx *ctx, int vb_state)
 {
 	struct vb2_buffer *src_vb, *dst_vb;
 
-	if (!ctx || !ctx->m2m_ctx)
+	if (!ctx || !ctx->fh.m2m_ctx)
 		return;
 
-	src_vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
-	dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+	src_vb = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+	dst_vb = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 
 	if (src_vb && dst_vb) {
 		src_vb->v4l2_buf.timestamp = dst_vb->v4l2_buf.timestamp;
@@ -87,7 +87,7 @@ void gsc_m2m_job_finish(struct gsc_ctx *ctx, int vb_state)
 		v4l2_m2m_buf_done(dst_vb, vb_state);
 
 		v4l2_m2m_job_finish(ctx->gsc_dev->m2m.m2m_dev,
-				    ctx->m2m_ctx);
+				    ctx->fh.m2m_ctx);
 	}
 }
 
@@ -111,12 +111,12 @@ static int gsc_get_bufs(struct gsc_ctx *ctx)
 	s_frame = &ctx->s_frame;
 	d_frame = &ctx->d_frame;
 
-	src_vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	src_vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	ret = gsc_prepare_addr(ctx, src_vb, s_frame, &s_frame->addr);
 	if (ret)
 		return ret;
 
-	dst_vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	dst_vb = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 	ret = gsc_prepare_addr(ctx, dst_vb, d_frame, &d_frame->addr);
 	if (ret)
 		return ret;
@@ -251,19 +251,15 @@ static int gsc_m2m_buf_prepare(struct vb2_buffer *vb)
 static void gsc_m2m_buf_queue(struct vb2_buffer *vb)
 {
 	struct gsc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-
-	pr_debug("ctx: %p, ctx->state: 0x%x", ctx, ctx->state);
-
-	if (ctx->m2m_ctx)
-		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
 }
 
 static struct vb2_ops gsc_m2m_qops = {
 	.queue_setup	 = gsc_m2m_queue_setup,
 	.buf_prepare	 = gsc_m2m_buf_prepare,
 	.buf_queue	 = gsc_m2m_buf_queue,
-	.wait_prepare	 = gsc_unlock,
-	.wait_finish	 = gsc_lock,
+	.wait_prepare	 = vb2_ops_wait_prepare,
+	.wait_finish	 = vb2_ops_wait_finish,
 	.stop_streaming	 = gsc_m2m_stop_streaming,
 	.start_streaming = gsc_m2m_start_streaming,
 };
@@ -319,7 +315,7 @@ static int gsc_m2m_s_fmt_mplane(struct file *file, void *fh,
 	if (ret)
 		return ret;
 
-	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
 
 	if (vb2_is_streaming(vq)) {
 		pr_err("queue (%d) busy", f->type);
@@ -348,73 +344,6 @@ static int gsc_m2m_s_fmt_mplane(struct file *file, void *fh,
 	return 0;
 }
 
-static int gsc_m2m_reqbufs(struct file *file, void *fh,
-			  struct v4l2_requestbuffers *reqbufs)
-{
-	struct gsc_ctx *ctx = fh_to_ctx(fh);
-	struct gsc_dev *gsc = ctx->gsc_dev;
-	u32 max_cnt;
-
-	max_cnt = (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) ?
-		gsc->variant->in_buf_cnt : gsc->variant->out_buf_cnt;
-	if (reqbufs->count > max_cnt) {
-		return -EINVAL;
-	}
-
-	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
-}
-
-static int gsc_m2m_expbuf(struct file *file, void *fh,
-				struct v4l2_exportbuffer *eb)
-{
-	struct gsc_ctx *ctx = fh_to_ctx(fh);
-	return v4l2_m2m_expbuf(file, ctx->m2m_ctx, eb);
-}
-
-static int gsc_m2m_querybuf(struct file *file, void *fh,
-					struct v4l2_buffer *buf)
-{
-	struct gsc_ctx *ctx = fh_to_ctx(fh);
-	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
-}
-
-static int gsc_m2m_qbuf(struct file *file, void *fh,
-			  struct v4l2_buffer *buf)
-{
-	struct gsc_ctx *ctx = fh_to_ctx(fh);
-	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
-}
-
-static int gsc_m2m_dqbuf(struct file *file, void *fh,
-			   struct v4l2_buffer *buf)
-{
-	struct gsc_ctx *ctx = fh_to_ctx(fh);
-	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
-}
-
-static int gsc_m2m_streamon(struct file *file, void *fh,
-			   enum v4l2_buf_type type)
-{
-	struct gsc_ctx *ctx = fh_to_ctx(fh);
-
-	/* The source and target color format need to be set */
-	if (V4L2_TYPE_IS_OUTPUT(type)) {
-		if (!gsc_ctx_state_is_set(GSC_SRC_FMT, ctx))
-			return -EINVAL;
-	} else if (!gsc_ctx_state_is_set(GSC_DST_FMT, ctx)) {
-		return -EINVAL;
-	}
-
-	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
-}
-
-static int gsc_m2m_streamoff(struct file *file, void *fh,
-			    enum v4l2_buf_type type)
-{
-	struct gsc_ctx *ctx = fh_to_ctx(fh);
-	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
-}
-
 /* Return 1 if rectangle a is enclosed in rectangle b, or 0 otherwise. */
 static int is_rectangle_enclosed(struct v4l2_rect *a, struct v4l2_rect *b)
 {
@@ -549,13 +478,15 @@ static const struct v4l2_ioctl_ops gsc_m2m_ioctl_ops = {
 	.vidioc_try_fmt_vid_out_mplane	= gsc_m2m_try_fmt_mplane,
 	.vidioc_s_fmt_vid_cap_mplane	= gsc_m2m_s_fmt_mplane,
 	.vidioc_s_fmt_vid_out_mplane	= gsc_m2m_s_fmt_mplane,
-	.vidioc_reqbufs			= gsc_m2m_reqbufs,
-	.vidioc_expbuf                  = gsc_m2m_expbuf,
-	.vidioc_querybuf		= gsc_m2m_querybuf,
-	.vidioc_qbuf			= gsc_m2m_qbuf,
-	.vidioc_dqbuf			= gsc_m2m_dqbuf,
-	.vidioc_streamon		= gsc_m2m_streamon,
-	.vidioc_streamoff		= gsc_m2m_streamoff,
+
+	.vidioc_reqbufs			= v4l2_m2m_ioctl_reqbufs,
+	.vidioc_querybuf		= v4l2_m2m_ioctl_querybuf,
+	.vidioc_expbuf			= v4l2_m2m_ioctl_expbuf,
+	.vidioc_qbuf			= v4l2_m2m_ioctl_qbuf,
+	.vidioc_dqbuf			= v4l2_m2m_ioctl_dqbuf,
+
+	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
+	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
 	.vidioc_g_selection		= gsc_m2m_g_selection,
 	.vidioc_s_selection		= gsc_m2m_s_selection
 };
@@ -574,6 +505,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->lock = &ctx->gsc_dev->lock;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -587,6 +519,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->lock = &ctx->gsc_dev->lock;
 
 	return vb2_queue_init(dst_vq);
 }
@@ -654,10 +587,10 @@ static int gsc_m2m_open(struct file *file)
 	ctx->in_path = GSC_DMA;
 	ctx->out_path = GSC_DMA;
 
-	ctx->m2m_ctx = v4l2_m2m_ctx_init(gsc->m2m.m2m_dev, ctx, queue_init);
-	if (IS_ERR(ctx->m2m_ctx)) {
+	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(gsc->m2m.m2m_dev, ctx, queue_init);
+	if (IS_ERR(ctx->fh.m2m_ctx)) {
 		pr_err("Failed to initialize m2m context");
-		ret = PTR_ERR(ctx->m2m_ctx);
+		ret = PTR_ERR(ctx->fh.m2m_ctx);
 		goto error_ctrls;
 	}
 
@@ -696,7 +629,7 @@ static int gsc_m2m_release(struct file *file)
 
 	mutex_lock(&gsc->lock);
 
-	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 	gsc_ctrls_delete(ctx);
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
@@ -709,44 +642,13 @@ static int gsc_m2m_release(struct file *file)
 	return 0;
 }
 
-static unsigned int gsc_m2m_poll(struct file *file,
-					struct poll_table_struct *wait)
-{
-	struct gsc_ctx *ctx = fh_to_ctx(file->private_data);
-	struct gsc_dev *gsc = ctx->gsc_dev;
-	int ret;
-
-	if (mutex_lock_interruptible(&gsc->lock))
-		return -ERESTARTSYS;
-
-	ret = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
-	mutex_unlock(&gsc->lock);
-
-	return ret;
-}
-
-static int gsc_m2m_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct gsc_ctx *ctx = fh_to_ctx(file->private_data);
-	struct gsc_dev *gsc = ctx->gsc_dev;
-	int ret;
-
-	if (mutex_lock_interruptible(&gsc->lock))
-		return -ERESTARTSYS;
-
-	ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
-	mutex_unlock(&gsc->lock);
-
-	return ret;
-}
-
 static const struct v4l2_file_operations gsc_m2m_fops = {
 	.owner		= THIS_MODULE,
 	.open		= gsc_m2m_open,
 	.release	= gsc_m2m_release,
-	.poll		= gsc_m2m_poll,
+	.poll		= v4l2_m2m_fop_poll,
 	.unlocked_ioctl	= video_ioctl2,
-	.mmap		= gsc_m2m_mmap,
+	.mmap		= v4l2_m2m_fop_mmap,
 };
 
 static struct v4l2_m2m_ops gsc_m2m_ops = {
-- 
1.7.4.1

