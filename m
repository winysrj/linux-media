Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:63988 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab3IMM6F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Sep 2013 08:58:05 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, kyungmin.park@samsung.com, pawel@osciak.com,
	javier.martin@vista-silicon.com, m.szyprowski@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com, k.debski@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 3/7] exynos4-is: Use mem-to-mem ioctl helpers
Date: Fri, 13 Sep 2013 14:56:22 +0200
Message-id: <1379076986-10446-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1379076986-10446-1-git-send-email-s.nawrocki@samsung.com>
References: <1379076986-10446-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify the FIMC mem-to-mem driver by using the m2m ioctl and vb2 helpers.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyugmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-m2m.c |  119 +++-----------------------
 1 file changed, 14 insertions(+), 105 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index 8d33b68..71ee871 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -226,24 +226,12 @@ static void fimc_buf_queue(struct vb2_buffer *vb)
 		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
 }
 
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
@@ -410,56 +398,6 @@ static int fimc_m2m_s_fmt_mplane(struct file *file, void *fh,
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
@@ -598,13 +536,13 @@ static const struct v4l2_ioctl_ops fimc_m2m_ioctl_ops = {
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
@@ -624,6 +562,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->lock = &ctx->fimc_dev->lock;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -636,6 +575,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->lock = &ctx->fimc_dev->lock;
 
 	return vb2_queue_init(dst_vq);
 }
@@ -713,6 +653,7 @@ static int fimc_m2m_open(struct file *file)
 		ret = PTR_ERR(ctx->m2m_ctx);
 		goto error_c;
 	}
+	ctx->fh.m2m_ctx = ctx->m2m_ctx;
 
 	if (fimc->m2m.refcnt++ == 0)
 		set_bit(ST_M2M_RUN, &fimc->state);
@@ -760,45 +701,13 @@ static int fimc_m2m_release(struct file *file)
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
1.7.9.5

