Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46966 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab3JLMcb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Oct 2013 08:32:31 -0400
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, pawel@osciak.com,
	javier.martin@vista-silicon.com, m.szyprowski@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com, k.debski@samsung.com,
	p.zabel@pengutronix.de, kyungmin.park@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v2 10/10] s5p-g2d: Use mem-to-mem ioctl helpers
Date: Sat, 12 Oct 2013 14:32:00 +0200
Message-Id: <1381581120-26883-11-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1381581120-26883-1-git-send-email-s.nawrocki@samsung.com>
References: <1381581120-26883-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify the driver by using the m2m ioctl and vb2 helpers.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v1:
 - use m2m context pointer from struct v4l2_fh.
---
 drivers/media/platform/s5p-g2d/g2d.c |  124 ++++++----------------------------
 drivers/media/platform/s5p-g2d/g2d.h |    1 -
 2 files changed, 21 insertions(+), 104 deletions(-)

diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index fd6289d..9c12008 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -136,10 +136,9 @@ static int g2d_buf_prepare(struct vb2_buffer *vb)
 static void g2d_buf_queue(struct vb2_buffer *vb)
 {
 	struct g2d_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
 }
 
-
 static struct vb2_ops g2d_qops = {
 	.queue_setup	= g2d_queue_setup,
 	.buf_prepare	= g2d_buf_prepare,
@@ -159,6 +158,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->lock = &ctx->dev->mutex;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -171,6 +171,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->lock = &ctx->dev->mutex;
 
 	return vb2_queue_init(dst_vq);
 }
@@ -253,9 +254,9 @@ static int g2d_open(struct file *file)
 		kfree(ctx);
 		return -ERESTARTSYS;
 	}
-	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx, &queue_init);
-	if (IS_ERR(ctx->m2m_ctx)) {
-		ret = PTR_ERR(ctx->m2m_ctx);
+	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx, &queue_init);
+	if (IS_ERR(ctx->fh.m2m_ctx)) {
+		ret = PTR_ERR(ctx->fh.m2m_ctx);
 		mutex_unlock(&dev->mutex);
 		kfree(ctx);
 		return ret;
@@ -324,7 +325,7 @@ static int vidioc_g_fmt(struct file *file, void *prv, struct v4l2_format *f)
 	struct vb2_queue *vq;
 	struct g2d_frame *frm;
 
-	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
 	if (!vq)
 		return -EINVAL;
 	frm = get_frame(ctx, f->type);
@@ -384,7 +385,7 @@ static int vidioc_s_fmt(struct file *file, void *prv, struct v4l2_format *f)
 	ret = vidioc_try_fmt(file, prv, f);
 	if (ret)
 		return ret;
-	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
 	if (vb2_is_busy(vq)) {
 		v4l2_err(&dev->v4l2_dev, "queue (%d) bust\n", f->type);
 		return -EBUSY;
@@ -410,72 +411,6 @@ static int vidioc_s_fmt(struct file *file, void *prv, struct v4l2_format *f)
 	return 0;
 }
 
-static unsigned int g2d_poll(struct file *file, struct poll_table_struct *wait)
-{
-	struct g2d_ctx *ctx = fh2ctx(file->private_data);
-	struct g2d_dev *dev = ctx->dev;
-	unsigned int res;
-
-	mutex_lock(&dev->mutex);
-	res = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
-	mutex_unlock(&dev->mutex);
-	return res;
-}
-
-static int g2d_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct g2d_ctx *ctx = fh2ctx(file->private_data);
-	struct g2d_dev *dev = ctx->dev;
-	int ret;
-
-	if (mutex_lock_interruptible(&dev->mutex))
-		return -ERESTARTSYS;
-	ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
-	mutex_unlock(&dev->mutex);
-	return ret;
-}
-
-static int vidioc_reqbufs(struct file *file, void *priv,
-			struct v4l2_requestbuffers *reqbufs)
-{
-	struct g2d_ctx *ctx = priv;
-	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
-}
-
-static int vidioc_querybuf(struct file *file, void *priv,
-			struct v4l2_buffer *buf)
-{
-	struct g2d_ctx *ctx = priv;
-	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
-}
-
-static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
-{
-	struct g2d_ctx *ctx = priv;
-	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
-}
-
-static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
-{
-	struct g2d_ctx *ctx = priv;
-	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
-}
-
-
-static int vidioc_streamon(struct file *file, void *priv,
-					enum v4l2_buf_type type)
-{
-	struct g2d_ctx *ctx = priv;
-	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
-}
-
-static int vidioc_streamoff(struct file *file, void *priv,
-					enum v4l2_buf_type type)
-{
-	struct g2d_ctx *ctx = priv;
-	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
-}
-
 static int vidioc_cropcap(struct file *file, void *priv,
 					struct v4l2_cropcap *cr)
 {
@@ -551,20 +486,6 @@ static int vidioc_s_crop(struct file *file, void *prv, const struct v4l2_crop *c
 	return 0;
 }
 
-static void g2d_lock(void *prv)
-{
-	struct g2d_ctx *ctx = prv;
-	struct g2d_dev *dev = ctx->dev;
-	mutex_lock(&dev->mutex);
-}
-
-static void g2d_unlock(void *prv)
-{
-	struct g2d_ctx *ctx = prv;
-	struct g2d_dev *dev = ctx->dev;
-	mutex_unlock(&dev->mutex);
-}
-
 static void job_abort(void *prv)
 {
 	struct g2d_ctx *ctx = prv;
@@ -589,8 +510,8 @@ static void device_run(void *prv)
 
 	dev->curr = ctx;
 
-	src = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
-	dst = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	src = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+	dst = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 
 	clk_enable(dev->gate);
 	g2d_reset(dev);
@@ -631,8 +552,8 @@ static irqreturn_t g2d_isr(int irq, void *prv)
 
 	BUG_ON(ctx == NULL);
 
-	src = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
-	dst = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+	src = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+	dst = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 
 	BUG_ON(src == NULL);
 	BUG_ON(dst == NULL);
@@ -642,7 +563,7 @@ static irqreturn_t g2d_isr(int irq, void *prv)
 
 	v4l2_m2m_buf_done(src, VB2_BUF_STATE_DONE);
 	v4l2_m2m_buf_done(dst, VB2_BUF_STATE_DONE);
-	v4l2_m2m_job_finish(dev->m2m_dev, ctx->m2m_ctx);
+	v4l2_m2m_job_finish(dev->m2m_dev, ctx->fh.m2m_ctx);
 
 	dev->curr = NULL;
 	wake_up(&dev->irq_queue);
@@ -653,9 +574,9 @@ static const struct v4l2_file_operations g2d_fops = {
 	.owner		= THIS_MODULE,
 	.open		= g2d_open,
 	.release	= g2d_release,
-	.poll		= g2d_poll,
+	.poll		= v4l2_m2m_fop_poll,
 	.unlocked_ioctl	= video_ioctl2,
-	.mmap		= g2d_mmap,
+	.mmap		= v4l2_m2m_fop_mmap,
 };
 
 static const struct v4l2_ioctl_ops g2d_ioctl_ops = {
@@ -671,14 +592,13 @@ static const struct v4l2_ioctl_ops g2d_ioctl_ops = {
 	.vidioc_try_fmt_vid_out		= vidioc_try_fmt,
 	.vidioc_s_fmt_vid_out		= vidioc_s_fmt,
 
-	.vidioc_reqbufs			= vidioc_reqbufs,
-	.vidioc_querybuf		= vidioc_querybuf,
-
-	.vidioc_qbuf			= vidioc_qbuf,
-	.vidioc_dqbuf			= vidioc_dqbuf,
+	.vidioc_reqbufs			= v4l2_m2m_ioctl_reqbufs,
+	.vidioc_querybuf		= v4l2_m2m_ioctl_querybuf,
+	.vidioc_qbuf			= v4l2_m2m_ioctl_qbuf,
+	.vidioc_dqbuf			= v4l2_m2m_ioctl_dqbuf,
 
-	.vidioc_streamon		= vidioc_streamon,
-	.vidioc_streamoff		= vidioc_streamoff,
+	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
+	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
 
 	.vidioc_g_crop			= vidioc_g_crop,
 	.vidioc_s_crop			= vidioc_s_crop,
@@ -697,8 +617,6 @@ static struct video_device g2d_videodev = {
 static struct v4l2_m2m_ops g2d_m2m_ops = {
 	.device_run	= device_run,
 	.job_abort	= job_abort,
-	.lock		= g2d_lock,
-	.unlock		= g2d_unlock,
 };
 
 static const struct of_device_id exynos_g2d_match[];
diff --git a/drivers/media/platform/s5p-g2d/g2d.h b/drivers/media/platform/s5p-g2d/g2d.h
index 300ca05..b0e52ab 100644
--- a/drivers/media/platform/s5p-g2d/g2d.h
+++ b/drivers/media/platform/s5p-g2d/g2d.h
@@ -57,7 +57,6 @@ struct g2d_frame {
 struct g2d_ctx {
 	struct v4l2_fh fh;
 	struct g2d_dev		*dev;
-	struct v4l2_m2m_ctx	*m2m_ctx;
 	struct g2d_frame	in;
 	struct g2d_frame	out;
 	struct v4l2_ctrl	*ctrl_hflip;
-- 
1.7.4.1

