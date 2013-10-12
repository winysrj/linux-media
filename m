Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:44316 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab3JLMcY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Oct 2013 08:32:24 -0400
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, pawel@osciak.com,
	javier.martin@vista-silicon.com, m.szyprowski@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com, k.debski@samsung.com,
	p.zabel@pengutronix.de, kyungmin.park@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v2 06/10] mx2-emmaprp: Use mem-to-mem ioctl helpers
Date: Sat, 12 Oct 2013 14:31:56 +0200
Message-Id: <1381581120-26883-7-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1381581120-26883-1-git-send-email-s.nawrocki@samsung.com>
References: <1381581120-26883-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify the driver by using the m2m ioctl and vb2 helpers.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v1:
 - dropped m2m_ctx member of struct emmaprp_ctx; the patch is now
   complete and there are better chances it actually works.
---
 drivers/media/platform/mx2_emmaprp.c |  135 ++++++----------------------------
 1 files changed, 24 insertions(+), 111 deletions(-)

diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index e91a4d5..43a437c 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -222,7 +222,6 @@ struct emmaprp_ctx {
 	int			aborting;
 	struct emmaprp_q_data	q_data[2];
 	struct v4l2_fh		fh;
-	struct v4l2_m2m_ctx	*m2m_ctx;
 };
 
 #define fh_to_ctx(__fh) container_of(__fh, struct emmaprp_ctx, fh)
@@ -253,21 +252,7 @@ static void emmaprp_job_abort(void *priv)
 
 	dprintk(pcdev, "Aborting task\n");
 
-	v4l2_m2m_job_finish(pcdev->m2m_dev, ctx->m2m_ctx);
-}
-
-static void emmaprp_lock(void *priv)
-{
-	struct emmaprp_ctx *ctx = priv;
-	struct emmaprp_dev *pcdev = ctx->dev;
-	mutex_lock(&pcdev->dev_mutex);
-}
-
-static void emmaprp_unlock(void *priv)
-{
-	struct emmaprp_ctx *ctx = priv;
-	struct emmaprp_dev *pcdev = ctx->dev;
-	mutex_unlock(&pcdev->dev_mutex);
+	v4l2_m2m_job_finish(pcdev->m2m_dev, ctx->fh.m2m_ctx);
 }
 
 static inline void emmaprp_dump_regs(struct emmaprp_dev *pcdev)
@@ -302,8 +287,8 @@ static void emmaprp_device_run(void *priv)
 	dma_addr_t p_in, p_out;
 	u32 tmp;
 
-	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
-	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 
 	s_q_data = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	s_width	= s_q_data->width;
@@ -377,8 +362,8 @@ static irqreturn_t emmaprp_irq(int irq_emma, void *data)
 			pr_err("PrP bus error occurred, this transfer is probably corrupted\n");
 			writel(PRP_CNTL_SWRST, pcdev->base_emma + PRP_CNTL);
 		} else if (irqst & PRP_INTR_ST_CH2B1CI) { /* buffer ready */
-			src_vb = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
-			dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
+			src_vb = v4l2_m2m_src_buf_remove(curr_ctx->fh.m2m_ctx);
+			dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->fh.m2m_ctx);
 
 			src_vb->v4l2_buf.timestamp = dst_vb->v4l2_buf.timestamp;
 			src_vb->v4l2_buf.timecode = dst_vb->v4l2_buf.timecode;
@@ -390,7 +375,7 @@ static irqreturn_t emmaprp_irq(int irq_emma, void *data)
 		}
 	}
 
-	v4l2_m2m_job_finish(pcdev->m2m_dev, curr_ctx->m2m_ctx);
+	v4l2_m2m_job_finish(pcdev->m2m_dev, curr_ctx->fh.m2m_ctx);
 	return IRQ_HANDLED;
 }
 
@@ -459,7 +444,7 @@ static int vidioc_g_fmt(struct emmaprp_ctx *ctx, struct v4l2_format *f)
 	struct vb2_queue *vq;
 	struct emmaprp_q_data *q_data;
 
-	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
 	if (!vq)
 		return -EINVAL;
 
@@ -624,52 +609,6 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
 	return vidioc_s_fmt(ctx, f);
 }
 
-static int vidioc_reqbufs(struct file *file, void *priv,
-			  struct v4l2_requestbuffers *reqbufs)
-{
-	struct emmaprp_ctx *ctx = priv;
-
-	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
-}
-
-static int vidioc_querybuf(struct file *file, void *priv,
-			   struct v4l2_buffer *buf)
-{
-	struct emmaprp_ctx *ctx = priv;
-
-	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
-}
-
-static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
-{
-	struct emmaprp_ctx *ctx = priv;
-
-	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
-}
-
-static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
-{
-	struct emmaprp_ctx *ctx = priv;
-
-	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
-}
-
-static int vidioc_streamon(struct file *file, void *priv,
-			   enum v4l2_buf_type type)
-{
-	struct emmaprp_ctx *ctx = priv;
-
-	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
-}
-
-static int vidioc_streamoff(struct file *file, void *priv,
-			    enum v4l2_buf_type type)
-{
-	struct emmaprp_ctx *ctx = priv;
-
-	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
-}
-
 static const struct v4l2_ioctl_ops emmaprp_ioctl_ops = {
 	.vidioc_querycap	= vidioc_querycap,
 
@@ -683,14 +622,13 @@ static const struct v4l2_ioctl_ops emmaprp_ioctl_ops = {
 	.vidioc_try_fmt_vid_out	= vidioc_try_fmt_vid_out,
 	.vidioc_s_fmt_vid_out	= vidioc_s_fmt_vid_out,
 
-	.vidioc_reqbufs		= vidioc_reqbufs,
-	.vidioc_querybuf	= vidioc_querybuf,
-
-	.vidioc_qbuf		= vidioc_qbuf,
-	.vidioc_dqbuf		= vidioc_dqbuf,
+	.vidioc_reqbufs		= v4l2_m2m_ioctl_reqbufs,
+	.vidioc_querybuf	= v4l2_m2m_ioctl_querybuf,
+	.vidioc_qbuf		= v4l2_m2m_ioctl_qbuf,
+	.vidioc_dqbuf		= v4l2_m2m_ioctl_dqbuf,
 
-	.vidioc_streamon	= vidioc_streamon,
-	.vidioc_streamoff	= vidioc_streamoff,
+	.vidioc_streamon	= v4l2_m2m_ioctl_streamon,
+	.vidioc_streamoff	= v4l2_m2m_ioctl_streamoff,
 };
 
 
@@ -752,7 +690,7 @@ static int emmaprp_buf_prepare(struct vb2_buffer *vb)
 static void emmaprp_buf_queue(struct vb2_buffer *vb)
 {
 	struct emmaprp_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
 }
 
 static struct vb2_ops emmaprp_qops = {
@@ -774,6 +712,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->ops = &emmaprp_qops;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->lock = &ctx->dev->dev_mutex;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -786,6 +725,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->ops = &emmaprp_qops;
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->lock = &ctx->dev->dev_mutex;
 
 	return vb2_queue_init(dst_vq);
 }
@@ -814,10 +754,10 @@ static int emmaprp_open(struct file *file)
 
 	ctx->dev = pcdev;
 
-	ctx->m2m_ctx = v4l2_m2m_ctx_init(pcdev->m2m_dev, ctx, &queue_init);
+	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(pcdev->m2m_dev, ctx, &queue_init);
 
-	if (IS_ERR(ctx->m2m_ctx)) {
-		ret = PTR_ERR(ctx->m2m_ctx);
+	if (IS_ERR(ctx->fh.m2m_ctx)) {
+		ret = PTR_ERR(ctx->fh.m2m_ctx);
 		goto err_fh;
 	}
 
@@ -827,7 +767,8 @@ static int emmaprp_open(struct file *file)
 	ctx->q_data[V4L2_M2M_DST].fmt = &formats[0];
 	mutex_unlock(&pcdev->dev_mutex);
 
-	dprintk(pcdev, "Created instance %p, m2m_ctx: %p\n", ctx, ctx->m2m_ctx);
+	dprintk(pcdev, "Created instance %p, m2m_ctx: %p\n",
+		ctx, ctx->fh.m2m_ctx);
 
 	return 0;
 
@@ -850,7 +791,7 @@ static int emmaprp_release(struct file *file)
 	mutex_lock(&pcdev->dev_mutex);
 	clk_disable_unprepare(pcdev->clk_emma_ahb);
 	clk_disable_unprepare(pcdev->clk_emma_ipg);
-	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 	mutex_unlock(&pcdev->dev_mutex);
@@ -859,39 +800,13 @@ static int emmaprp_release(struct file *file)
 	return 0;
 }
 
-static unsigned int emmaprp_poll(struct file *file,
-				 struct poll_table_struct *wait)
-{
-	struct emmaprp_dev *pcdev = video_drvdata(file);
-	struct emmaprp_ctx *ctx = file->private_data;
-	unsigned int res;
-
-	mutex_lock(&pcdev->dev_mutex);
-	res = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
-	mutex_unlock(&pcdev->dev_mutex);
-	return res;
-}
-
-static int emmaprp_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct emmaprp_dev *pcdev = video_drvdata(file);
-	struct emmaprp_ctx *ctx = file->private_data;
-	int ret;
-
-	if (mutex_lock_interruptible(&pcdev->dev_mutex))
-		return -ERESTARTSYS;
-	ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
-	mutex_unlock(&pcdev->dev_mutex);
-	return ret;
-}
-
 static const struct v4l2_file_operations emmaprp_fops = {
 	.owner		= THIS_MODULE,
 	.open		= emmaprp_open,
 	.release	= emmaprp_release,
-	.poll		= emmaprp_poll,
+	.poll		= v4l2_m2m_fop_poll,
 	.unlocked_ioctl	= video_ioctl2,
-	.mmap		= emmaprp_mmap,
+	.mmap		= v4l2_m2m_fop_mmap,
 };
 
 static struct video_device emmaprp_videodev = {
@@ -906,8 +821,6 @@ static struct video_device emmaprp_videodev = {
 static struct v4l2_m2m_ops m2m_ops = {
 	.device_run	= emmaprp_device_run,
 	.job_abort	= emmaprp_job_abort,
-	.lock		= emmaprp_lock,
-	.unlock		= emmaprp_unlock,
 };
 
 static int emmaprp_probe(struct platform_device *pdev)
-- 
1.7.4.1

