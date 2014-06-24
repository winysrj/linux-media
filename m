Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57609 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbaFXO4Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 10:56:25 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 10/29] [media] coda: Use mem-to-mem ioctl helpers
Date: Tue, 24 Jun 2014 16:55:52 +0200
Message-Id: <1403621771-11636-11-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
References: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the mem2mem helpers introduced to get rid of some duplicated code.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 113 ++++++------------------------------------
 1 file changed, 14 insertions(+), 99 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index bc5b6c0..742187c 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -780,22 +780,6 @@ static int coda_s_fmt_vid_out(struct file *file, void *priv,
 	return ret;
 }
 
-static int coda_reqbufs(struct file *file, void *priv,
-			struct v4l2_requestbuffers *reqbufs)
-{
-	struct coda_ctx *ctx = fh_to_ctx(priv);
-
-	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
-}
-
-static int coda_querybuf(struct file *file, void *priv,
-			 struct v4l2_buffer *buf)
-{
-	struct coda_ctx *ctx = fh_to_ctx(priv);
-
-	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
-}
-
 static int coda_qbuf(struct file *file, void *priv,
 		     struct v4l2_buffer *buf)
 {
@@ -804,14 +788,6 @@ static int coda_qbuf(struct file *file, void *priv,
 	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
 }
 
-static int coda_expbuf(struct file *file, void *priv,
-		       struct v4l2_exportbuffer *eb)
-{
-	struct coda_ctx *ctx = fh_to_ctx(priv);
-
-	return v4l2_m2m_expbuf(file, ctx->m2m_ctx, eb);
-}
-
 static bool coda_buf_is_end_of_stream(struct coda_ctx *ctx,
 				      struct v4l2_buffer *buf)
 {
@@ -844,40 +820,6 @@ static int coda_dqbuf(struct file *file, void *priv,
 	return ret;
 }
 
-static int coda_create_bufs(struct file *file, void *priv,
-			    struct v4l2_create_buffers *create)
-{
-	struct coda_ctx *ctx = fh_to_ctx(priv);
-
-	return v4l2_m2m_create_bufs(file, ctx->m2m_ctx, create);
-}
-
-static int coda_streamon(struct file *file, void *priv,
-			 enum v4l2_buf_type type)
-{
-	struct coda_ctx *ctx = fh_to_ctx(priv);
-
-	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
-}
-
-static int coda_streamoff(struct file *file, void *priv,
-			  enum v4l2_buf_type type)
-{
-	struct coda_ctx *ctx = fh_to_ctx(priv);
-	int ret;
-
-	/*
-	 * This indirectly calls __vb2_queue_cancel, which dequeues all buffers.
-	 * We therefore have to lock it against running hardware in this context,
-	 * which still needs the buffers.
-	 */
-	mutex_lock(&ctx->buffer_mutex);
-	ret = v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
-	mutex_unlock(&ctx->buffer_mutex);
-
-	return ret;
-}
-
 static int coda_g_selection(struct file *file, void *fh,
 			    struct v4l2_selection *s)
 {
@@ -989,16 +931,16 @@ static const struct v4l2_ioctl_ops coda_ioctl_ops = {
 	.vidioc_try_fmt_vid_out	= coda_try_fmt_vid_out,
 	.vidioc_s_fmt_vid_out	= coda_s_fmt_vid_out,
 
-	.vidioc_reqbufs		= coda_reqbufs,
-	.vidioc_querybuf	= coda_querybuf,
+	.vidioc_reqbufs		= v4l2_m2m_ioctl_reqbufs,
+	.vidioc_querybuf	= v4l2_m2m_ioctl_querybuf,
 
 	.vidioc_qbuf		= coda_qbuf,
-	.vidioc_expbuf		= coda_expbuf,
+	.vidioc_expbuf		= v4l2_m2m_ioctl_expbuf,
 	.vidioc_dqbuf		= coda_dqbuf,
-	.vidioc_create_bufs	= coda_create_bufs,
+	.vidioc_create_bufs	= v4l2_m2m_ioctl_create_bufs,
 
-	.vidioc_streamon	= coda_streamon,
-	.vidioc_streamoff	= coda_streamoff,
+	.vidioc_streamon	= v4l2_m2m_ioctl_streamon,
+	.vidioc_streamoff	= v4l2_m2m_ioctl_streamoff,
 
 	.vidioc_g_selection	= coda_g_selection,
 
@@ -1677,18 +1619,6 @@ static void coda_buf_queue(struct vb2_buffer *vb)
 	}
 }
 
-static void coda_wait_prepare(struct vb2_queue *q)
-{
-	struct coda_ctx *ctx = vb2_get_drv_priv(q);
-	coda_unlock(ctx);
-}
-
-static void coda_wait_finish(struct vb2_queue *q)
-{
-	struct coda_ctx *ctx = vb2_get_drv_priv(q);
-	coda_lock(ctx);
-}
-
 static void coda_parabuf_write(struct coda_ctx *ctx, int index, u32 value)
 {
 	struct coda_dev *dev = ctx->dev;
@@ -2647,10 +2577,10 @@ static struct vb2_ops coda_qops = {
 	.queue_setup		= coda_queue_setup,
 	.buf_prepare		= coda_buf_prepare,
 	.buf_queue		= coda_buf_queue,
-	.wait_prepare		= coda_wait_prepare,
-	.wait_finish		= coda_wait_finish,
 	.start_streaming	= coda_start_streaming,
 	.stop_streaming		= coda_stop_streaming,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
 };
 
 static int coda_s_ctrl(struct v4l2_ctrl *ctrl)
@@ -2773,6 +2703,7 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->ops = &coda_qops;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->lock = &ctx->dev->dev_mutex;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -2785,6 +2716,7 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->ops = &coda_qops;
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->lock = &ctx->dev->dev_mutex;
 
 	return vb2_queue_init(dst_vq);
 }
@@ -2853,6 +2785,8 @@ static int coda_open(struct file *file)
 			 __func__, ret);
 		goto err_ctx_init;
 	}
+	ctx->fh.m2m_ctx = ctx->m2m_ctx;
+
 	ret = coda_ctrls_setup(ctx);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "failed to setup coda controls\n");
@@ -2952,32 +2886,13 @@ static int coda_release(struct file *file)
 	return 0;
 }
 
-static unsigned int coda_poll(struct file *file,
-				 struct poll_table_struct *wait)
-{
-	struct coda_ctx *ctx = fh_to_ctx(file->private_data);
-	int ret;
-
-	coda_lock(ctx);
-	ret = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
-	coda_unlock(ctx);
-	return ret;
-}
-
-static int coda_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct coda_ctx *ctx = fh_to_ctx(file->private_data);
-
-	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
-}
-
 static const struct v4l2_file_operations coda_fops = {
 	.owner		= THIS_MODULE,
 	.open		= coda_open,
 	.release	= coda_release,
-	.poll		= coda_poll,
+	.poll		= v4l2_m2m_fop_poll,
 	.unlocked_ioctl	= video_ioctl2,
-	.mmap		= coda_mmap,
+	.mmap		= v4l2_m2m_fop_mmap,
 };
 
 static void coda_finish_decode(struct coda_ctx *ctx)
-- 
2.0.0

