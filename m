Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60122 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670AbbCXRbD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 13:31:03 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Peter Seiderer <ps.report@gmx.net>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 06/11] [media] coda: allocate bitstream buffer from REQBUFS, size depends on the format
Date: Tue, 24 Mar 2015 18:30:52 +0100
Message-Id: <1427218257-1507-7-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1427218257-1507-1-git-send-email-p.zabel@pengutronix.de>
References: <1427218257-1507-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allocating the bitstream buffer only when the format is set allows to guarantee
that at least two frames fit into the bitstream buffer. For small frame sizes
a smaller bitstream buffer can be allocated. Since the bitstream buffer size now
depends on the format, replace CODA_MAX_FRAME_SIZE with ctx->bitstream.size
where appropriate and remove the now unused constant.
Since REQBUFS can be called multiple times, but the format can't be changed
unless REQBUFS 0 was called before, we can just keep the allocated context and
bitstream buffers if REQBUFS is called multiple times with a non-zero buffer
count.

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
[fixed a resource leak preventing repeatedly decoding]
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Merged Peter's fix, calling coda_free_bitstream_buffer from coda_bit_release.
---
 drivers/media/platform/coda/coda-bit.c    | 85 +++++++++++++++++++++----------
 drivers/media/platform/coda/coda-common.c | 22 --------
 drivers/media/platform/coda/coda.h        |  1 -
 3 files changed, 58 insertions(+), 50 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 12b9386..5aa8d87 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -15,6 +15,7 @@
 #include <linux/clk.h>
 #include <linux/irqreturn.h>
 #include <linux/kernel.h>
+#include <linux/log2.h>
 #include <linux/platform_device.h>
 #include <linux/reset.h>
 #include <linux/slab.h>
@@ -36,6 +37,8 @@
 #define CODA_DEFAULT_GAMMA	4096
 #define CODA9_DEFAULT_GAMMA	24576	/* 0.75 * 32768 */
 
+static void coda_free_bitstream_buffer(struct coda_ctx *ctx);
+
 static inline int coda_is_initialized(struct coda_dev *dev)
 {
 	return coda_read(dev, CODA_REG_BIT_CUR_PC) != 0;
@@ -389,21 +392,7 @@ static int coda_alloc_context_buffers(struct coda_ctx *ctx,
 	if (dev->devtype->product == CODA_DX6)
 		return 0;
 
-	if (ctx->psbuf.vaddr) {
-		v4l2_err(&dev->v4l2_dev, "psmembuf still allocated\n");
-		return -EBUSY;
-	}
-	if (ctx->slicebuf.vaddr) {
-		v4l2_err(&dev->v4l2_dev, "slicebuf still allocated\n");
-		return -EBUSY;
-	}
-	if (ctx->workbuf.vaddr) {
-		v4l2_err(&dev->v4l2_dev, "context buffer still allocated\n");
-		ret = -EBUSY;
-		return -ENOMEM;
-	}
-
-	if (q_data->fourcc == V4L2_PIX_FMT_H264) {
+	if (!ctx->slicebuf.vaddr && q_data->fourcc == V4L2_PIX_FMT_H264) {
 		/* worst case slice size */
 		size = (DIV_ROUND_UP(q_data->width, 16) *
 			DIV_ROUND_UP(q_data->height, 16)) * 3200 / 8 + 512;
@@ -417,7 +406,7 @@ static int coda_alloc_context_buffers(struct coda_ctx *ctx,
 		}
 	}
 
-	if (dev->devtype->product == CODA_7541) {
+	if (!ctx->psbuf.vaddr && dev->devtype->product == CODA_7541) {
 		ret = coda_alloc_context_buf(ctx, &ctx->psbuf,
 					     CODA7_PS_BUF_SIZE, "psbuf");
 		if (ret < 0) {
@@ -427,16 +416,19 @@ static int coda_alloc_context_buffers(struct coda_ctx *ctx,
 		}
 	}
 
-	size = dev->devtype->workbuf_size;
-	if (dev->devtype->product == CODA_960 &&
-	    q_data->fourcc == V4L2_PIX_FMT_H264)
-		size += CODA9_PS_SAVE_SIZE;
-	ret = coda_alloc_context_buf(ctx, &ctx->workbuf, size, "workbuf");
-	if (ret < 0) {
-		v4l2_err(&dev->v4l2_dev,
-			 "failed to allocate %d byte context buffer",
-			 ctx->workbuf.size);
-		goto err;
+	if (!ctx->workbuf.vaddr) {
+		size = dev->devtype->workbuf_size;
+		if (dev->devtype->product == CODA_960 &&
+		    q_data->fourcc == V4L2_PIX_FMT_H264)
+			size += CODA9_PS_SAVE_SIZE;
+		ret = coda_alloc_context_buf(ctx, &ctx->workbuf, size,
+					     "workbuf");
+		if (ret < 0) {
+			v4l2_err(&dev->v4l2_dev,
+				 "failed to allocate %d byte context buffer",
+				 ctx->workbuf.size);
+			goto err;
+		}
 	}
 
 	return 0;
@@ -1337,6 +1329,7 @@ static void coda_bit_release(struct coda_ctx *ctx)
 	mutex_lock(&ctx->buffer_mutex);
 	coda_free_framebuffers(ctx);
 	coda_free_context_buffers(ctx);
+	coda_free_bitstream_buffer(ctx);
 	mutex_unlock(&ctx->buffer_mutex);
 }
 
@@ -1354,6 +1347,38 @@ const struct coda_context_ops coda_bit_encode_ops = {
  * Decoder context operations
  */
 
+static int coda_alloc_bitstream_buffer(struct coda_ctx *ctx,
+				       struct coda_q_data *q_data)
+{
+	if (ctx->bitstream.vaddr)
+		return 0;
+
+	ctx->bitstream.size = roundup_pow_of_two(q_data->sizeimage * 2);
+	ctx->bitstream.vaddr = dma_alloc_writecombine(
+			&ctx->dev->plat_dev->dev, ctx->bitstream.size,
+			&ctx->bitstream.paddr, GFP_KERNEL);
+	if (!ctx->bitstream.vaddr) {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			 "failed to allocate bitstream ringbuffer");
+		return -ENOMEM;
+	}
+	kfifo_init(&ctx->bitstream_fifo,
+		   ctx->bitstream.vaddr, ctx->bitstream.size);
+
+	return 0;
+}
+
+static void coda_free_bitstream_buffer(struct coda_ctx *ctx)
+{
+	if (ctx->bitstream.vaddr == NULL)
+		return;
+
+	dma_free_writecombine(&ctx->dev->plat_dev->dev, ctx->bitstream.size,
+			      ctx->bitstream.vaddr, ctx->bitstream.paddr);
+	ctx->bitstream.vaddr = NULL;
+	kfifo_init(&ctx->bitstream_fifo, NULL, 0);
+}
+
 static int coda_decoder_reqbufs(struct coda_ctx *ctx,
 				struct v4l2_requestbuffers *rb)
 {
@@ -1368,7 +1393,13 @@ static int coda_decoder_reqbufs(struct coda_ctx *ctx,
 		ret = coda_alloc_context_buffers(ctx, q_data_src);
 		if (ret < 0)
 			return ret;
+		ret = coda_alloc_bitstream_buffer(ctx, q_data_src);
+		if (ret < 0) {
+			coda_free_context_buffers(ctx);
+			return ret;
+		}
 	} else {
+		coda_free_bitstream_buffer(ctx);
 		coda_free_context_buffers(ctx);
 	}
 
@@ -1736,7 +1767,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 	 * by up to 512 bytes
 	 */
 	if (ctx->bit_stream_param & CODA_BIT_STREAM_END_FLAG) {
-		if (coda_get_bitstream_payload(ctx) >= CODA_MAX_FRAME_SIZE - 512)
+		if (coda_get_bitstream_payload(ctx) >= ctx->bitstream.size - 512)
 			kfifo_init(&ctx->bitstream_fifo,
 				ctx->bitstream.vaddr, ctx->bitstream.size);
 	}
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 0026e3a..b34a0db 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1716,20 +1716,6 @@ static int coda_open(struct file *file)
 			goto err_dma_alloc;
 		}
 	}
-	if (ctx->use_bit && ctx->inst_type == CODA_INST_DECODER) {
-		ctx->bitstream.size = CODA_MAX_FRAME_SIZE;
-		ctx->bitstream.vaddr = dma_alloc_writecombine(
-				&dev->plat_dev->dev, ctx->bitstream.size,
-				&ctx->bitstream.paddr, GFP_KERNEL);
-		if (!ctx->bitstream.vaddr) {
-			v4l2_err(&dev->v4l2_dev,
-				 "failed to allocate bitstream ringbuffer");
-			ret = -ENOMEM;
-			goto err_dma_writecombine;
-		}
-	}
-	kfifo_init(&ctx->bitstream_fifo,
-		ctx->bitstream.vaddr, ctx->bitstream.size);
 	mutex_init(&ctx->bitstream_mutex);
 	mutex_init(&ctx->buffer_mutex);
 	INIT_LIST_HEAD(&ctx->buffer_meta_list);
@@ -1743,10 +1729,6 @@ static int coda_open(struct file *file)
 
 	return 0;
 
-err_dma_writecombine:
-	if (ctx->dev->devtype->product == CODA_DX6)
-		coda_free_aux_buf(dev, &ctx->workbuf);
-	coda_free_aux_buf(dev, &ctx->parabuf);
 err_dma_alloc:
 	v4l2_ctrl_handler_free(&ctx->ctrls);
 err_ctrls_setup:
@@ -1791,10 +1773,6 @@ static int coda_release(struct file *file)
 	list_del(&ctx->list);
 	coda_unlock(ctx);
 
-	if (ctx->bitstream.vaddr) {
-		dma_free_writecombine(&dev->plat_dev->dev, ctx->bitstream.size,
-			ctx->bitstream.vaddr, ctx->bitstream.paddr);
-	}
 	if (ctx->dev->devtype->product == CODA_DX6)
 		coda_free_aux_buf(dev, &ctx->workbuf);
 
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 57d070c..01d940c 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -26,7 +26,6 @@
 #include "coda_regs.h"
 
 #define CODA_MAX_FRAMEBUFFERS	8
-#define CODA_MAX_FRAME_SIZE	0x100000
 #define FMO_SLICE_SAVE_BUF_SIZE	(32)
 
 enum {
-- 
2.1.4

