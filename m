Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:62641 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3IMM6V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Sep 2013 08:58:21 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, kyungmin.park@samsung.com, pawel@osciak.com,
	javier.martin@vista-silicon.com, m.szyprowski@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com, k.debski@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 6/7] exynos-gsc: Use mem-to-mem ioctl helpers
Date: Fri, 13 Sep 2013 14:56:25 +0200
Message-id: <1379076986-10446-7-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1379076986-10446-1-git-send-email-s.nawrocki@samsung.com>
References: <1379076986-10446-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify the driver by using the m2m ioctl and vb2 helpers.

TODO: Add setting of default initial format.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyugmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.h |   12 ---
 drivers/media/platform/exynos-gsc/gsc-m2m.c  |  109 ++++----------------------
 2 files changed, 16 insertions(+), 105 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index cc19bba..1afad32 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.h
+++ b/drivers/media/platform/exynos-gsc/gsc-core.h
@@ -464,18 +464,6 @@ static inline void gsc_hw_clear_irq(struct gsc_dev *dev, int irq)
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
index 40a73f7..4f5d6cb 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -262,8 +262,8 @@ static struct vb2_ops gsc_m2m_qops = {
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
@@ -376,57 +376,6 @@ static int gsc_m2m_reqbufs(struct file *file, void *fh,
 	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
 }
 
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
@@ -563,13 +512,15 @@ static const struct v4l2_ioctl_ops gsc_m2m_ioctl_ops = {
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
@@ -588,6 +539,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->lock = &ctx->gsc_dev->lock;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -601,6 +553,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->lock = &ctx->gsc_dev->lock;
 
 	return vb2_queue_init(dst_vq);
 }
@@ -648,6 +601,7 @@ static int gsc_m2m_open(struct file *file)
 		ret = PTR_ERR(ctx->m2m_ctx);
 		goto error_ctrls;
 	}
+	ctx->fh.m2m_ctx = ctx->m2m_ctx;
 
 	if (gsc->m2m.refcnt++ == 0)
 		set_bit(ST_M2M_OPEN, &gsc->state);
@@ -691,44 +645,13 @@ static int gsc_m2m_release(struct file *file)
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
1.7.9.5

