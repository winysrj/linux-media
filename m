Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42794 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbbBWPUZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 10:20:25 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Peter Seiderer <ps.report@gmx.net>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 12/12] [media] coda: fix fill bitstream errors in nonstreaming case
Date: Mon, 23 Feb 2015 16:20:13 +0100
Message-Id: <1424704813-20792-13-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1424704813-20792-1-git-send-email-p.zabel@pengutronix.de>
References: <1424704813-20792-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <philipp.zabel@gmail.com>

When queueing a buffer into the bitstream fails, it has to be requeued
in the videobuf2 queue before streaming starts, but while streaming it
should be returned to userspace with an error.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/media/platform/coda/coda-bit.c    | 11 +++++++----
 drivers/media/platform/coda/coda-common.c |  6 +++---
 drivers/media/platform/coda/coda.h        |  2 +-
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 2304158..d39789d 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -218,7 +218,7 @@ static bool coda_bitstream_try_queue(struct coda_ctx *ctx,
 	return true;
 }
 
-void coda_fill_bitstream(struct coda_ctx *ctx)
+void coda_fill_bitstream(struct coda_ctx *ctx, bool streaming)
 {
 	struct vb2_buffer *src_buf;
 	struct coda_buffer_meta *meta;
@@ -239,9 +239,12 @@ void coda_fill_bitstream(struct coda_ctx *ctx)
 		if (ctx->codec->src_fourcc == V4L2_PIX_FMT_JPEG &&
 		    !coda_jpeg_check_buffer(ctx, src_buf)) {
 			v4l2_err(&ctx->dev->v4l2_dev,
-				 "dropping invalid JPEG frame\n");
+				 "dropping invalid JPEG frame %d\n",
+				 ctx->qsequence);
 			src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
-			v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
+			v4l2_m2m_buf_done(src_buf, streaming ?
+					  VB2_BUF_STATE_ERROR :
+					  VB2_BUF_STATE_QUEUED);
 			continue;
 		}
 
@@ -1648,7 +1651,7 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 
 	/* Try to copy source buffer contents into the bitstream ringbuffer */
 	mutex_lock(&ctx->bitstream_mutex);
-	coda_fill_bitstream(ctx);
+	coda_fill_bitstream(ctx, true);
 	mutex_unlock(&ctx->bitstream_mutex);
 
 	if (coda_get_bitstream_payload(ctx) < 512 &&
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 54c972f..5e159da 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1192,7 +1192,7 @@ static void coda_buf_queue(struct vb2_buffer *vb)
 		mutex_lock(&ctx->bitstream_mutex);
 		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
 		if (vb2_is_streaming(vb->vb2_queue))
-			coda_fill_bitstream(ctx);
+			coda_fill_bitstream(ctx, true);
 		mutex_unlock(&ctx->bitstream_mutex);
 	} else {
 		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
@@ -1252,9 +1252,9 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 		if (q_data_src->fourcc == V4L2_PIX_FMT_H264 ||
 		    (q_data_src->fourcc == V4L2_PIX_FMT_JPEG &&
 		     ctx->dev->devtype->product == CODA_7541)) {
-			/* copy the buffers that where queued before streamon */
+			/* copy the buffers that were queued before streamon */
 			mutex_lock(&ctx->bitstream_mutex);
-			coda_fill_bitstream(ctx);
+			coda_fill_bitstream(ctx, false);
 			mutex_unlock(&ctx->bitstream_mutex);
 
 			if (coda_get_bitstream_payload(ctx) < 512) {
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 2b59e16..970f0b3 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -256,7 +256,7 @@ int coda_decoder_queue_init(void *priv, struct vb2_queue *src_vq,
 
 int coda_hw_reset(struct coda_ctx *ctx);
 
-void coda_fill_bitstream(struct coda_ctx *ctx);
+void coda_fill_bitstream(struct coda_ctx *ctx, bool streaming);
 
 void coda_set_gdi_regs(struct coda_ctx *ctx);
 
-- 
2.1.4

