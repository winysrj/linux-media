Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:62655 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3IMM6b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Sep 2013 08:58:31 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, kyungmin.park@samsung.com, pawel@osciak.com,
	javier.martin@vista-silicon.com, m.szyprowski@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com, k.debski@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 7/7] s5p-g2d: Use mem-to-mem ioctl helpers
Date: Fri, 13 Sep 2013 14:56:26 +0200
Message-id: <1379076986-10446-8-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1379076986-10446-1-git-send-email-s.nawrocki@samsung.com>
References: <1379076986-10446-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify the driver by using the m2m ioctl and vb2 helpers.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyugmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-g2d/g2d.c |  103 ++++------------------------------
 1 file changed, 11 insertions(+), 92 deletions(-)

diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 553d87e..d59d546 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -139,7 +139,6 @@ static void g2d_buf_queue(struct vb2_buffer *vb)
 	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
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
@@ -263,6 +264,7 @@ static int g2d_open(struct file *file)
 	v4l2_fh_init(&ctx->fh, video_devdata(file));
 	file->private_data = &ctx->fh;
 	v4l2_fh_add(&ctx->fh);
+	ctx->fh.m2m_ctx = ctx->m2m_ctx;
 
 	g2d_setup_ctrls(ctx);
 
@@ -410,72 +412,6 @@ static int vidioc_s_fmt(struct file *file, void *prv, struct v4l2_format *f)
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
@@ -551,20 +487,6 @@ static int vidioc_s_crop(struct file *file, void *prv, const struct v4l2_crop *c
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
@@ -653,9 +575,9 @@ static const struct v4l2_file_operations g2d_fops = {
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
@@ -671,14 +593,13 @@ static const struct v4l2_ioctl_ops g2d_ioctl_ops = {
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
@@ -697,8 +618,6 @@ static struct video_device g2d_videodev = {
 static struct v4l2_m2m_ops g2d_m2m_ops = {
 	.device_run	= device_run,
 	.job_abort	= job_abort,
-	.lock		= g2d_lock,
-	.unlock		= g2d_unlock,
 };
 
 static const struct of_device_id exynos_g2d_match[];
-- 
1.7.9.5

