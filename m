Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:46010 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab3JLMcS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Oct 2013 08:32:18 -0400
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, pawel@osciak.com,
	javier.martin@vista-silicon.com, m.szyprowski@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com, k.debski@samsung.com,
	p.zabel@pengutronix.de, kyungmin.park@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v2 03/10] exynos4-is: Use mem-to-mem ioctl helpers
Date: Sat, 12 Oct 2013 14:31:53 +0200
Message-Id: <1381581120-26883-4-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1381581120-26883-1-git-send-email-s.nawrocki@samsung.com>
References: <1381581120-26883-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify the FIMC mem-to-mem driver by using the m2m ioctl
and vb2 helpers.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v1:
 - use m2m context pointer from struct v4l2_fh.
---
 drivers/media/platform/exynos4-is/fimc-core.h |    2 -
 drivers/media/platform/exynos4-is/fimc-m2m.c  |  148 +++++--------------------
 2 files changed, 26 insertions(+), 124 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index 3d376fa..1790fb4 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -481,7 +481,6 @@ struct fimc_ctrls {
  * @flags:		additional flags for image conversion
  * @state:		flags to keep track of user configuration
  * @fimc_dev:		the FIMC device this context applies to
- * @m2m_ctx:		memory-to-memory device context
  * @fh:			v4l2 file handle
  * @ctrls:		v4l2 controls structure
  */
@@ -502,7 +501,6 @@ struct fimc_ctx {
 	u32			flags;
 	u32			state;
 	struct fimc_dev		*fimc_dev;
-	struct v4l2_m2m_ctx	*m2m_ctx;
 	struct v4l2_fh		fh;
 	struct fimc_ctrls	ctrls;
 };
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index 8d33b68..9da95bd 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -44,17 +44,17 @@ void fimc_m2m_job_finish(struct fimc_ctx *ctx, int vb_state)
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
 		v4l2_m2m_buf_done(src_vb, vb_state);
 		v4l2_m2m_buf_done(dst_vb, vb_state);
 		v4l2_m2m_job_finish(ctx->fimc_dev->m2m.m2m_dev,
-				    ctx->m2m_ctx);
+				    ctx->fh.m2m_ctx);
 	}
 }
 
@@ -123,12 +123,12 @@ static void fimc_device_run(void *priv)
 		fimc_prepare_dma_offset(ctx, df);
 	}
 
-	src_vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	src_vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	ret = fimc_prepare_addr(ctx, src_vb, sf, &sf->paddr);
 	if (ret)
 		goto dma_unlock;
 
-	dst_vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	dst_vb = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 	ret = fimc_prepare_addr(ctx, dst_vb, df, &df->paddr);
 	if (ret)
 		goto dma_unlock;
@@ -219,31 +219,15 @@ static int fimc_buf_prepare(struct vb2_buffer *vb)
 static void fimc_buf_queue(struct vb2_buffer *vb)
 {
 	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
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
+	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
 }
 
 static struct vb2_ops fimc_qops = {
 	.queue_setup	 = fimc_queue_setup,
 	.buf_prepare	 = fimc_buf_prepare,
 	.buf_queue	 = fimc_buf_queue,
-	.wait_prepare	 = fimc_unlock,
-	.wait_finish	 = fimc_lock,
+	.wait_prepare	 = vb2_ops_wait_prepare,
+	.wait_finish	 = vb2_ops_wait_finish,
 	.stop_streaming	 = stop_streaming,
 	.start_streaming = start_streaming,
 };
@@ -385,7 +369,7 @@ static int fimc_m2m_s_fmt_mplane(struct file *file, void *fh,
 	if (ret)
 		return ret;
 
-	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
 
 	if (vb2_is_busy(vq)) {
 		v4l2_err(&fimc->m2m.vfd, "queue (%d) busy\n", f->type);
@@ -410,56 +394,6 @@ static int fimc_m2m_s_fmt_mplane(struct file *file, void *fh,
 	return 0;
 }
 
-static int fimc_m2m_reqbufs(struct file *file, void *fh,
-			    struct v4l2_requestbuffers *reqbufs)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
-}
-
-static int fimc_m2m_querybuf(struct file *file, void *fh,
-			     struct v4l2_buffer *buf)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
-}
-
-static int fimc_m2m_qbuf(struct file *file, void *fh,
-			 struct v4l2_buffer *buf)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
-}
-
-static int fimc_m2m_dqbuf(struct file *file, void *fh,
-			  struct v4l2_buffer *buf)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
-}
-
-static int fimc_m2m_expbuf(struct file *file, void *fh,
-			    struct v4l2_exportbuffer *eb)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-	return v4l2_m2m_expbuf(file, ctx->m2m_ctx, eb);
-}
-
-
-static int fimc_m2m_streamon(struct file *file, void *fh,
-			     enum v4l2_buf_type type)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
-}
-
-static int fimc_m2m_streamoff(struct file *file, void *fh,
-			    enum v4l2_buf_type type)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
-}
-
 static int fimc_m2m_cropcap(struct file *file, void *fh,
 			    struct v4l2_cropcap *cr)
 {
@@ -598,13 +532,13 @@ static const struct v4l2_ioctl_ops fimc_m2m_ioctl_ops = {
 	.vidioc_try_fmt_vid_out_mplane	= fimc_m2m_try_fmt_mplane,
 	.vidioc_s_fmt_vid_cap_mplane	= fimc_m2m_s_fmt_mplane,
 	.vidioc_s_fmt_vid_out_mplane	= fimc_m2m_s_fmt_mplane,
-	.vidioc_reqbufs			= fimc_m2m_reqbufs,
-	.vidioc_querybuf		= fimc_m2m_querybuf,
-	.vidioc_qbuf			= fimc_m2m_qbuf,
-	.vidioc_dqbuf			= fimc_m2m_dqbuf,
-	.vidioc_expbuf			= fimc_m2m_expbuf,
-	.vidioc_streamon		= fimc_m2m_streamon,
-	.vidioc_streamoff		= fimc_m2m_streamoff,
+	.vidioc_reqbufs			= v4l2_m2m_ioctl_reqbufs,
+	.vidioc_querybuf		= v4l2_m2m_ioctl_querybuf,
+	.vidioc_qbuf			= v4l2_m2m_ioctl_qbuf,
+	.vidioc_dqbuf			= v4l2_m2m_ioctl_dqbuf,
+	.vidioc_expbuf			= v4l2_m2m_ioctl_expbuf,
+	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
+	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
 	.vidioc_g_crop			= fimc_m2m_g_crop,
 	.vidioc_s_crop			= fimc_m2m_s_crop,
 	.vidioc_cropcap			= fimc_m2m_cropcap
@@ -624,6 +558,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->lock = &ctx->fimc_dev->lock;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -636,6 +571,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->lock = &ctx->fimc_dev->lock;
 
 	return vb2_queue_init(dst_vq);
 }
@@ -708,9 +644,9 @@ static int fimc_m2m_open(struct file *file)
 	ctx->out_path = FIMC_IO_DMA;
 	ctx->scaler.enabled = 1;
 
-	ctx->m2m_ctx = v4l2_m2m_ctx_init(fimc->m2m.m2m_dev, ctx, queue_init);
-	if (IS_ERR(ctx->m2m_ctx)) {
-		ret = PTR_ERR(ctx->m2m_ctx);
+	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(fimc->m2m.m2m_dev, ctx, queue_init);
+	if (IS_ERR(ctx->fh.m2m_ctx)) {
+		ret = PTR_ERR(ctx->fh.m2m_ctx);
 		goto error_c;
 	}
 
@@ -725,7 +661,7 @@ static int fimc_m2m_open(struct file *file)
 	return 0;
 
 error_m2m_ctx:
-	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 error_c:
 	fimc_ctrls_delete(ctx);
 error_fh:
@@ -747,7 +683,7 @@ static int fimc_m2m_release(struct file *file)
 
 	mutex_lock(&fimc->lock);
 
-	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 	fimc_ctrls_delete(ctx);
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
@@ -760,45 +696,13 @@ static int fimc_m2m_release(struct file *file)
 	return 0;
 }
 
-static unsigned int fimc_m2m_poll(struct file *file,
-				  struct poll_table_struct *wait)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(file->private_data);
-	struct fimc_dev *fimc = ctx->fimc_dev;
-	int ret;
-
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
-
-	ret = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
-	mutex_unlock(&fimc->lock);
-
-	return ret;
-}
-
-
-static int fimc_m2m_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(file->private_data);
-	struct fimc_dev *fimc = ctx->fimc_dev;
-	int ret;
-
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
-
-	ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
-	mutex_unlock(&fimc->lock);
-
-	return ret;
-}
-
 static const struct v4l2_file_operations fimc_m2m_fops = {
 	.owner		= THIS_MODULE,
 	.open		= fimc_m2m_open,
 	.release	= fimc_m2m_release,
-	.poll		= fimc_m2m_poll,
+	.poll		= v4l2_m2m_fop_poll,
 	.unlocked_ioctl	= video_ioctl2,
-	.mmap		= fimc_m2m_mmap,
+	.mmap		= v4l2_m2m_fop_mmap,
 };
 
 static struct v4l2_m2m_ops m2m_ops = {
-- 
1.7.4.1

