Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60826 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675AbbAWQvk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 11:51:40 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 19/21] [media] coda: add support for contexts that do not use the BIT processor
Date: Fri, 23 Jan 2015 17:51:33 +0100
Message-Id: <1422031895-7740-20-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
References: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for CODA9 JPEG support, allow contexts that
control hardware units directly, without the BIT processor.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 42 +++++++++++++++++--------------
 drivers/media/platform/coda/coda.h        |  1 +
 2 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 40074fa..2defa4b 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -181,6 +181,7 @@ struct coda_video_device {
 	const char *name;
 	enum coda_inst_type type;
 	const struct coda_context_ops *ops;
+	bool direct;
 	u32 src_formats[CODA_MAX_FORMATS];
 	u32 dst_formats[CODA_MAX_FORMATS];
 };
@@ -953,7 +954,7 @@ static int coda_job_ready(void *m2m_priv)
 		return 0;
 	}
 
-	if (ctx->inst_type == CODA_INST_DECODER) {
+	if (ctx->inst_type == CODA_INST_DECODER && ctx->use_bit) {
 		struct list_head *meta;
 		bool stream_end;
 		int num_metas;
@@ -1161,7 +1162,7 @@ static void coda_buf_queue(struct vb2_buffer *vb)
 	 * In the decoder case, immediately try to copy the buffer into the
 	 * bitstream ringbuffer and mark it as ready to be dequeued.
 	 */
-	if (ctx->inst_type == CODA_INST_DECODER &&
+	if (ctx->use_bit && ctx->inst_type == CODA_INST_DECODER &&
 	    vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		/*
 		 * For backwards compatibility, queuing an empty buffer marks
@@ -1262,7 +1263,7 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 		return 0;
 
 	/* Allow BIT decoder device_run with no new buffers queued */
-	if (ctx->inst_type == CODA_INST_DECODER)
+	if (ctx->inst_type == CODA_INST_DECODER && ctx->use_bit)
 		v4l2_m2m_set_src_buffered(ctx->fh.m2m_ctx, true);
 
 	ctx->gopcounter = ctx->params.gop_size - 1;
@@ -1626,6 +1627,7 @@ static int coda_open(struct file *file)
 	ctx->cvd = to_coda_video_device(vdev);
 	ctx->inst_type = ctx->cvd->type;
 	ctx->ops = ctx->cvd->ops;
+	ctx->use_bit = !ctx->cvd->direct;
 	init_completion(&ctx->completion);
 	INIT_WORK(&ctx->pic_run_work, coda_pic_run_work);
 	if (ctx->ops->seq_end_work)
@@ -1680,22 +1682,24 @@ static int coda_open(struct file *file)
 
 	ctx->fh.ctrl_handler = &ctx->ctrls;
 
-	ret = coda_alloc_context_buf(ctx, &ctx->parabuf,
-				     CODA_PARA_BUF_SIZE, "parabuf");
-	if (ret < 0) {
-		v4l2_err(&dev->v4l2_dev, "failed to allocate parabuf");
-		goto err_dma_alloc;
-	}
+	if (ctx->use_bit) {
+		ret = coda_alloc_context_buf(ctx, &ctx->parabuf,
+					     CODA_PARA_BUF_SIZE, "parabuf");
+		if (ret < 0) {
+			v4l2_err(&dev->v4l2_dev, "failed to allocate parabuf");
+			goto err_dma_alloc;
+		}
 
-	ctx->bitstream.size = CODA_MAX_FRAME_SIZE;
-	ctx->bitstream.vaddr = dma_alloc_writecombine(
-			&dev->plat_dev->dev, ctx->bitstream.size,
-			&ctx->bitstream.paddr, GFP_KERNEL);
-	if (!ctx->bitstream.vaddr) {
-		v4l2_err(&dev->v4l2_dev,
-			 "failed to allocate bitstream ringbuffer");
-		ret = -ENOMEM;
-		goto err_dma_writecombine;
+		ctx->bitstream.size = CODA_MAX_FRAME_SIZE;
+		ctx->bitstream.vaddr = dma_alloc_writecombine(
+				&dev->plat_dev->dev, ctx->bitstream.size,
+				&ctx->bitstream.paddr, GFP_KERNEL);
+		if (!ctx->bitstream.vaddr) {
+			v4l2_err(&dev->v4l2_dev,
+				 "failed to allocate bitstream ringbuffer");
+			ret = -ENOMEM;
+			goto err_dma_writecombine;
+		}
 	}
 	kfifo_init(&ctx->bitstream_fifo,
 		ctx->bitstream.vaddr, ctx->bitstream.size);
@@ -1743,7 +1747,7 @@ static int coda_release(struct file *file)
 	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Releasing instance %p\n",
 		 ctx);
 
-	if (ctx->inst_type == CODA_INST_DECODER)
+	if (ctx->inst_type == CODA_INST_DECODER && ctx->use_bit)
 		coda_bit_stream_end_flag(ctx);
 
 	/* If this instance is running, call .job_abort and wait for it to end */
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 2ddfe51..0c35cd5 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -235,6 +235,7 @@ struct coda_ctx {
 	u32				frame_mem_ctrl;
 	int				display_idx;
 	struct dentry			*debugfs_entry;
+	bool				use_bit;
 };
 
 extern int coda_debug;
-- 
2.1.4

