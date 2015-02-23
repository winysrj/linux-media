Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42791 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbbBWPUY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 10:20:24 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Peter Seiderer <ps.report@gmx.net>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 06/12] [media] coda: allocate per-context buffers from REQBUFS
Date: Mon, 23 Feb 2015 16:20:07 +0100
Message-Id: <1424704813-20792-7-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1424704813-20792-1-git-send-email-p.zabel@pengutronix.de>
References: <1424704813-20792-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allocate the per-context buffers from REQBUFS instead in start_encoding or
start_decoding. This allows to stop and start streaming independently of
buffer (re)allocation

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 55 ++++++++++++++++++++++++-------
 drivers/media/platform/coda/coda-common.c | 22 ++++++++++++-
 drivers/media/platform/coda/coda.h        |  1 +
 3 files changed, 66 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 3801a37..ce64c91 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -711,6 +711,27 @@ err_clk_per:
  * Encoder context operations
  */
 
+static int coda_encoder_reqbufs(struct coda_ctx *ctx,
+				struct v4l2_requestbuffers *rb)
+{
+	struct coda_q_data *q_data_src;
+	int ret;
+
+	if (rb->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		return 0;
+
+	if (rb->count) {
+		q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+		ret = coda_alloc_context_buffers(ctx, q_data_src);
+		if (ret < 0)
+			return ret;
+	} else {
+		coda_free_context_buffers(ctx);
+	}
+
+	return 0;
+}
+
 static int coda_start_encoding(struct coda_ctx *ctx)
 {
 	struct coda_dev *dev = ctx->dev;
@@ -727,11 +748,6 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	dst_fourcc = q_data_dst->fourcc;
 
-	/* Allocate per-instance buffers */
-	ret = coda_alloc_context_buffers(ctx, q_data_src);
-	if (ret < 0)
-		return ret;
-
 	buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 	bitstream_buf = vb2_dma_contig_plane_dma_addr(buf, 0);
 	bitstream_size = q_data_dst->sizeimage;
@@ -1313,7 +1329,6 @@ static void coda_seq_end_work(struct work_struct *work)
 		ctx->bitstream.vaddr, ctx->bitstream.size);
 
 	coda_free_framebuffers(ctx);
-	coda_free_context_buffers(ctx);
 
 	mutex_unlock(&dev->coda_mutex);
 	mutex_unlock(&ctx->buffer_mutex);
@@ -1330,6 +1345,7 @@ static void coda_bit_release(struct coda_ctx *ctx)
 
 const struct coda_context_ops coda_bit_encode_ops = {
 	.queue_init = coda_encoder_queue_init,
+	.reqbufs = coda_encoder_reqbufs,
 	.start_streaming = coda_start_encoding,
 	.prepare_run = coda_prepare_encode,
 	.finish_run = coda_finish_encode,
@@ -1341,6 +1357,27 @@ const struct coda_context_ops coda_bit_encode_ops = {
  * Decoder context operations
  */
 
+static int coda_decoder_reqbufs(struct coda_ctx *ctx,
+				struct v4l2_requestbuffers *rb)
+{
+	struct coda_q_data *q_data_src;
+	int ret;
+
+	if (rb->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		return 0;
+
+	if (rb->count) {
+		q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+		ret = coda_alloc_context_buffers(ctx, q_data_src);
+		if (ret < 0)
+			return ret;
+	} else {
+		coda_free_context_buffers(ctx);
+	}
+
+	return 0;
+}
+
 static int __coda_start_decoding(struct coda_ctx *ctx)
 {
 	struct coda_q_data *q_data_src, *q_data_dst;
@@ -1359,11 +1396,6 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 	src_fourcc = q_data_src->fourcc;
 	dst_fourcc = q_data_dst->fourcc;
 
-	/* Allocate per-instance buffers */
-	ret = coda_alloc_context_buffers(ctx, q_data_src);
-	if (ret < 0)
-		return ret;
-
 	coda_write(dev, ctx->parabuf.paddr, CODA_REG_BIT_PARA_BUF_ADDR);
 
 	/* Update coda bitstream read and write pointers from kfifo */
@@ -1909,6 +1941,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 
 const struct coda_context_ops coda_bit_decode_ops = {
 	.queue_init = coda_decoder_queue_init,
+	.reqbufs = coda_decoder_reqbufs,
 	.start_streaming = coda_start_decoding,
 	.prepare_run = coda_prepare_decode,
 	.finish_run = coda_finish_decode,
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 04130ea..0026e3a 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -696,6 +696,26 @@ static int coda_s_fmt_vid_out(struct file *file, void *priv,
 	return coda_s_fmt(ctx, &f_cap);
 }
 
+static int coda_reqbufs(struct file *file, void *priv,
+			struct v4l2_requestbuffers *rb)
+{
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+	int ret;
+
+	ret = v4l2_m2m_reqbufs(file, ctx->fh.m2m_ctx, rb);
+	if (ret)
+		return ret;
+
+	/*
+	 * Allow to allocate instance specific per-context buffers, such as
+	 * bitstream ringbuffer, slice buffer, work buffer, etc. if needed.
+	 */
+	if (rb->type == V4L2_BUF_TYPE_VIDEO_OUTPUT && ctx->ops->reqbufs)
+		return ctx->ops->reqbufs(ctx, rb);
+
+	return 0;
+}
+
 static int coda_qbuf(struct file *file, void *priv,
 		     struct v4l2_buffer *buf)
 {
@@ -841,7 +861,7 @@ static const struct v4l2_ioctl_ops coda_ioctl_ops = {
 	.vidioc_try_fmt_vid_out	= coda_try_fmt_vid_out,
 	.vidioc_s_fmt_vid_out	= coda_s_fmt_vid_out,
 
-	.vidioc_reqbufs		= v4l2_m2m_ioctl_reqbufs,
+	.vidioc_reqbufs		= coda_reqbufs,
 	.vidioc_querybuf	= v4l2_m2m_ioctl_querybuf,
 
 	.vidioc_qbuf		= coda_qbuf,
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 499049f..57d070c 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -178,6 +178,7 @@ struct coda_ctx;
 struct coda_context_ops {
 	int (*queue_init)(void *priv, struct vb2_queue *src_vq,
 			  struct vb2_queue *dst_vq);
+	int (*reqbufs)(struct coda_ctx *ctx, struct v4l2_requestbuffers *rb);
 	int (*start_streaming)(struct coda_ctx *ctx);
 	int (*prepare_run)(struct coda_ctx *ctx);
 	void (*finish_run)(struct coda_ctx *ctx);
-- 
2.1.4

