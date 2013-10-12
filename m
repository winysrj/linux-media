Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:56238 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab3JLMcU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Oct 2013 08:32:20 -0400
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, pawel@osciak.com,
	javier.martin@vista-silicon.com, m.szyprowski@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com, k.debski@samsung.com,
	p.zabel@pengutronix.de, kyungmin.park@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v2 04/10] s5p-jpeg: Use mem-to-mem ioctl helpers
Date: Sat, 12 Oct 2013 14:31:54 +0200
Message-Id: <1381581120-26883-5-git-send-email-s.nawrocki@samsung.com>
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
 drivers/media/platform/s5p-jpeg/jpeg-core.c |  134 +++++----------------------
 drivers/media/platform/s5p-jpeg/jpeg-core.h |    2 -
 2 files changed, 24 insertions(+), 112 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 15d2396..160af4e 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -316,9 +316,9 @@ static int s5p_jpeg_open(struct file *file)
 	if (ret < 0)
 		goto error;
 
-	ctx->m2m_ctx = v4l2_m2m_ctx_init(jpeg->m2m_dev, ctx, queue_init);
-	if (IS_ERR(ctx->m2m_ctx)) {
-		ret = PTR_ERR(ctx->m2m_ctx);
+	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(jpeg->m2m_dev, ctx, queue_init);
+	if (IS_ERR(ctx->fh.m2m_ctx)) {
+		ret = PTR_ERR(ctx->fh.m2m_ctx);
 		goto error;
 	}
 
@@ -342,7 +342,7 @@ static int s5p_jpeg_release(struct file *file)
 	struct s5p_jpeg_ctx *ctx = fh_to_ctx(file->private_data);
 
 	mutex_lock(&jpeg->lock);
-	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 	mutex_unlock(&jpeg->lock);
 	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
 	v4l2_fh_del(&ctx->fh);
@@ -352,39 +352,13 @@ static int s5p_jpeg_release(struct file *file)
 	return 0;
 }
 
-static unsigned int s5p_jpeg_poll(struct file *file,
-				 struct poll_table_struct *wait)
-{
-	struct s5p_jpeg *jpeg = video_drvdata(file);
-	struct s5p_jpeg_ctx *ctx = fh_to_ctx(file->private_data);
-	unsigned int res;
-
-	mutex_lock(&jpeg->lock);
-	res = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
-	mutex_unlock(&jpeg->lock);
-	return res;
-}
-
-static int s5p_jpeg_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct s5p_jpeg *jpeg = video_drvdata(file);
-	struct s5p_jpeg_ctx *ctx = fh_to_ctx(file->private_data);
-	int ret;
-
-	if (mutex_lock_interruptible(&jpeg->lock))
-		return -ERESTARTSYS;
-	ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
-	mutex_unlock(&jpeg->lock);
-	return ret;
-}
-
 static const struct v4l2_file_operations s5p_jpeg_fops = {
 	.owner		= THIS_MODULE,
 	.open		= s5p_jpeg_open,
 	.release	= s5p_jpeg_release,
-	.poll		= s5p_jpeg_poll,
+	.poll		= v4l2_m2m_fop_poll,
 	.unlocked_ioctl	= video_ioctl2,
-	.mmap		= s5p_jpeg_mmap,
+	.mmap		= v4l2_m2m_fop_mmap,
 };
 
 /*
@@ -589,7 +563,7 @@ static int s5p_jpeg_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct s5p_jpeg_ctx *ct = fh_to_ctx(priv);
 
-	vq = v4l2_m2m_get_vq(ct->m2m_ctx, f->type);
+	vq = v4l2_m2m_get_vq(ct->fh.m2m_ctx, f->type);
 	if (!vq)
 		return -EINVAL;
 
@@ -745,7 +719,7 @@ static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx *ct, struct v4l2_format *f)
 	struct s5p_jpeg_q_data *q_data = NULL;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	vq = v4l2_m2m_get_vq(ct->m2m_ctx, f->type);
+	vq = v4l2_m2m_get_vq(ct->fh.m2m_ctx, f->type);
 	if (!vq)
 		return -EINVAL;
 
@@ -792,53 +766,6 @@ static int s5p_jpeg_s_fmt_vid_out(struct file *file, void *priv,
 	return s5p_jpeg_s_fmt(fh_to_ctx(priv), f);
 }
 
-static int s5p_jpeg_reqbufs(struct file *file, void *priv,
-			  struct v4l2_requestbuffers *reqbufs)
-{
-	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
-
-	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
-}
-
-static int s5p_jpeg_querybuf(struct file *file, void *priv,
-			   struct v4l2_buffer *buf)
-{
-	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
-
-	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
-}
-
-static int s5p_jpeg_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
-{
-	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
-
-	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
-}
-
-static int s5p_jpeg_dqbuf(struct file *file, void *priv,
-			  struct v4l2_buffer *buf)
-{
-	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
-
-	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
-}
-
-static int s5p_jpeg_streamon(struct file *file, void *priv,
-			   enum v4l2_buf_type type)
-{
-	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
-
-	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
-}
-
-static int s5p_jpeg_streamoff(struct file *file, void *priv,
-			    enum v4l2_buf_type type)
-{
-	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
-
-	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
-}
-
 static int s5p_jpeg_g_selection(struct file *file, void *priv,
 			 struct v4l2_selection *s)
 {
@@ -972,14 +899,13 @@ static const struct v4l2_ioctl_ops s5p_jpeg_ioctl_ops = {
 	.vidioc_s_fmt_vid_cap		= s5p_jpeg_s_fmt_vid_cap,
 	.vidioc_s_fmt_vid_out		= s5p_jpeg_s_fmt_vid_out,
 
-	.vidioc_reqbufs			= s5p_jpeg_reqbufs,
-	.vidioc_querybuf		= s5p_jpeg_querybuf,
+	.vidioc_reqbufs			= v4l2_m2m_ioctl_reqbufs,
+	.vidioc_querybuf		= v4l2_m2m_ioctl_querybuf,
+	.vidioc_qbuf			= v4l2_m2m_ioctl_qbuf,
+	.vidioc_dqbuf			= v4l2_m2m_ioctl_dqbuf,
 
-	.vidioc_qbuf			= s5p_jpeg_qbuf,
-	.vidioc_dqbuf			= s5p_jpeg_dqbuf,
-
-	.vidioc_streamon		= s5p_jpeg_streamon,
-	.vidioc_streamoff		= s5p_jpeg_streamoff,
+	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
+	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
 
 	.vidioc_g_selection		= s5p_jpeg_g_selection,
 };
@@ -997,8 +923,8 @@ static void s5p_jpeg_device_run(void *priv)
 	struct vb2_buffer *src_buf, *dst_buf;
 	unsigned long src_addr, dst_addr;
 
-	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
-	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 	src_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
 	dst_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
 
@@ -1170,22 +1096,8 @@ static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
 				      );
 		q_data->size = q_data->w * q_data->h * q_data->fmt->depth >> 3;
 	}
-	if (ctx->m2m_ctx)
-		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
-}
-
-static void s5p_jpeg_wait_prepare(struct vb2_queue *vq)
-{
-	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vq);
-
-	mutex_unlock(&ctx->jpeg->lock);
-}
-
-static void s5p_jpeg_wait_finish(struct vb2_queue *vq)
-{
-	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vq);
 
-	mutex_lock(&ctx->jpeg->lock);
+	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
 }
 
 static int s5p_jpeg_start_streaming(struct vb2_queue *q, unsigned int count)
@@ -1211,8 +1123,8 @@ static struct vb2_ops s5p_jpeg_qops = {
 	.queue_setup		= s5p_jpeg_queue_setup,
 	.buf_prepare		= s5p_jpeg_buf_prepare,
 	.buf_queue		= s5p_jpeg_buf_queue,
-	.wait_prepare		= s5p_jpeg_wait_prepare,
-	.wait_finish		= s5p_jpeg_wait_finish,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
 	.start_streaming	= s5p_jpeg_start_streaming,
 	.stop_streaming		= s5p_jpeg_stop_streaming,
 };
@@ -1230,6 +1142,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->ops = &s5p_jpeg_qops;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->lock = &ctx->jpeg->lock;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -1242,6 +1155,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->ops = &s5p_jpeg_qops;
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->lock = &ctx->jpeg->lock;
 
 	return vb2_queue_init(dst_vq);
 }
@@ -1267,8 +1181,8 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 
 	curr_ctx = v4l2_m2m_get_curr_priv(jpeg->m2m_dev);
 
-	src_buf = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
-	dst_buf = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
+	src_buf = v4l2_m2m_src_buf_remove(curr_ctx->fh.m2m_ctx);
+	dst_buf = v4l2_m2m_dst_buf_remove(curr_ctx->fh.m2m_ctx);
 
 	if (curr_ctx->mode == S5P_JPEG_ENCODE)
 		enc_jpeg_too_large = jpeg_enc_stream_stat(jpeg->regs);
@@ -1296,7 +1210,7 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 	if (curr_ctx->mode == S5P_JPEG_ENCODE)
 		vb2_set_plane_payload(dst_buf, 0, payload_size);
 	v4l2_m2m_buf_done(dst_buf, state);
-	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->m2m_ctx);
+	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
 
 	curr_ctx->subsampling = jpeg_get_subsampling_mode(jpeg->regs);
 	spin_unlock(&jpeg->slock);
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.h b/drivers/media/platform/s5p-jpeg/jpeg-core.h
index 8a4013e..4a4776b 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.h
@@ -115,7 +115,6 @@ struct s5p_jpeg_q_data {
  * @jpeg:		JPEG IP device for this context
  * @mode:		compression (encode) operation or decompression (decode)
  * @compr_quality:	destination image quality in compression (encode) mode
- * @m2m_ctx:		mem2mem device context
  * @out_q:		source (output) queue information
  * @cap_fmt:		destination (capture) queue queue information
  * @hdr_parsed:		set if header has been parsed during decompression
@@ -127,7 +126,6 @@ struct s5p_jpeg_ctx {
 	unsigned short		compr_quality;
 	unsigned short		restart_interval;
 	unsigned short		subsampling;
-	struct v4l2_m2m_ctx	*m2m_ctx;
 	struct s5p_jpeg_q_data	out_q;
 	struct s5p_jpeg_q_data	cap_q;
 	struct v4l2_fh		fh;
-- 
1.7.4.1

