Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59276 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758268AbaGWP3L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 11:29:11 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 6/8] [media] coda: move per-instance buffer allocation and cleanup
Date: Wed, 23 Jul 2014 17:28:43 +0200
Message-Id: <1406129325-10771-7-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1406129325-10771-1-git-send-email-p.zabel@pengutronix.de>
References: <1406129325-10771-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch moves the context buffer allocation into the context start_streaming
callbacks. The context buffer and internal framebuffer cleanup is moved into
the context release callback.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 547744a..df0470e 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1863,6 +1863,11 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 	bitstream_size = ctx->bitstream.size;
 	src_fourcc = q_data_src->fourcc;
 
+	/* Allocate per-instance buffers */
+	ret = coda_alloc_context_buffers(ctx, q_data_src);
+	if (ret < 0)
+		return ret;
+
 	coda_write(dev, ctx->parabuf.paddr, CODA_REG_BIT_PARA_BUF_ADDR);
 
 	/* Update coda bitstream read and write pointers from kfifo */
@@ -2139,11 +2144,6 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 		return -EINVAL;
 	}
 
-	/* Allocate per-instance buffers */
-	ret = coda_alloc_context_buffers(ctx, q_data_src);
-	if (ret < 0)
-		return ret;
-
 	ret = ctx->ops->start_streaming(ctx);
 	if (ctx->inst_type == CODA_INST_DECODER) {
 		if (ret == -EAGAIN)
@@ -2170,6 +2170,11 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	dst_fourcc = q_data_dst->fourcc;
 
+	/* Allocate per-instance buffers */
+	ret = coda_alloc_context_buffers(ctx, q_data_src);
+	if (ret < 0)
+		return ret;
+
 	buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 	bitstream_buf = vb2_dma_contig_plane_dma_addr(buf, 0);
 	bitstream_size = q_data_dst->sizeimage;
@@ -2840,7 +2845,6 @@ static int coda_open(struct file *file, enum coda_inst_type inst_type,
 	return 0;
 
 err_dma_writecombine:
-	coda_free_context_buffers(ctx);
 	if (ctx->dev->devtype->product == CODA_DX6)
 		coda_free_aux_buf(dev, &ctx->workbuf);
 	coda_free_aux_buf(dev, &ctx->parabuf);
@@ -2863,12 +2867,19 @@ err_coda_max:
 	return ret;
 }
 
+static void coda_bit_release(struct coda_ctx *ctx)
+{
+	coda_free_framebuffers(ctx);
+	coda_free_context_buffers(ctx);
+}
+
 struct coda_context_ops coda_encode_ops = {
 	.queue_init = coda_encoder_queue_init,
 	.start_streaming = coda_start_encoding,
 	.prepare_run = coda_prepare_encode,
 	.finish_run = coda_finish_encode,
 	.seq_end_work = coda_seq_end_work,
+	.release = coda_bit_release,
 };
 
 struct coda_context_ops coda_decode_ops = {
@@ -2876,7 +2887,8 @@ struct coda_context_ops coda_decode_ops = {
 	.start_streaming = coda_start_decoding,
 	.prepare_run = coda_prepare_decode,
 	.finish_run = coda_finish_decode,
-	.seq_end_work = coda_seq_end_work
+	.seq_end_work = coda_seq_end_work,
+	.release = coda_bit_release,
 };
 
 static int coda_encoder_open(struct file *file)
@@ -2908,15 +2920,12 @@ static int coda_release(struct file *file)
 		flush_work(&ctx->seq_end_work);
 	}
 
-	coda_free_framebuffers(ctx);
-
 	coda_lock(ctx);
 	list_del(&ctx->list);
 	coda_unlock(ctx);
 
 	dma_free_writecombine(&dev->plat_dev->dev, ctx->bitstream.size,
 		ctx->bitstream.vaddr, ctx->bitstream.paddr);
-	coda_free_context_buffers(ctx);
 	if (ctx->dev->devtype->product == CODA_DX6)
 		coda_free_aux_buf(dev, &ctx->workbuf);
 
@@ -2928,6 +2937,8 @@ static int coda_release(struct file *file)
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 	clear_bit(ctx->idx, &dev->instance_mask);
+	if (ctx->ops->release)
+		ctx->ops->release(ctx);
 	kfree(ctx);
 
 	return 0;
-- 
2.0.1

