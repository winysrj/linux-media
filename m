Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42788 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbbBWPUY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 10:20:24 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Peter Seiderer <ps.report@gmx.net>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 08/12] [media] coda: move parameter buffer in together with context buffer allocation
Date: Mon, 23 Feb 2015 16:20:09 +0100
Message-Id: <1424704813-20792-9-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1424704813-20792-1-git-send-email-p.zabel@pengutronix.de>
References: <1424704813-20792-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The parameter buffer is a per-context buffer, so we can allocate and free it
together with the other context buffers during REQBUFS.
Since this was the last context buffer allocated in coda-common.c, we can now
move coda_alloc_context_buf into coda-bit.c.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 21 ++++++++++++++++++++-
 drivers/media/platform/coda/coda-common.c | 12 ------------
 drivers/media/platform/coda/coda.h        |  7 -------
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 5aa8d87..0073f5a 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -31,6 +31,7 @@
 
 #include "coda.h"
 
+#define CODA_PARA_BUF_SIZE	(10 * 1024)
 #define CODA7_PS_BUF_SIZE	0x28000
 #define CODA9_PS_SAVE_SIZE	(512 * 1024)
 
@@ -300,6 +301,14 @@ static void coda_parabuf_write(struct coda_ctx *ctx, int index, u32 value)
 		p[index ^ 1] = value;
 }
 
+static inline int coda_alloc_context_buf(struct coda_ctx *ctx,
+					 struct coda_aux_buf *buf, size_t size,
+					 const char *name)
+{
+	return coda_alloc_aux_buf(ctx->dev, buf, size, name, ctx->debugfs_entry);
+}
+
+
 static void coda_free_framebuffers(struct coda_ctx *ctx)
 {
 	int i;
@@ -380,6 +389,7 @@ static void coda_free_context_buffers(struct coda_ctx *ctx)
 	coda_free_aux_buf(dev, &ctx->psbuf);
 	if (dev->devtype->product != CODA_DX6)
 		coda_free_aux_buf(dev, &ctx->workbuf);
+	coda_free_aux_buf(dev, &ctx->parabuf);
 }
 
 static int coda_alloc_context_buffers(struct coda_ctx *ctx,
@@ -389,6 +399,15 @@ static int coda_alloc_context_buffers(struct coda_ctx *ctx,
 	size_t size;
 	int ret;
 
+	if (!ctx->parabuf.vaddr) {
+		ret = coda_alloc_context_buf(ctx, &ctx->parabuf,
+					     CODA_PARA_BUF_SIZE, "parabuf");
+		if (ret < 0) {
+			v4l2_err(&dev->v4l2_dev, "failed to allocate parabuf");
+			return ret;
+		}
+	}
+
 	if (dev->devtype->product == CODA_DX6)
 		return 0;
 
@@ -402,7 +421,7 @@ static int coda_alloc_context_buffers(struct coda_ctx *ctx,
 			v4l2_err(&dev->v4l2_dev,
 				 "failed to allocate %d byte slice buffer",
 				 ctx->slicebuf.size);
-			return ret;
+			goto err;
 		}
 	}
 
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index b34a0db..172805b 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -46,7 +46,6 @@
 #define CODADX6_MAX_INSTANCES	4
 #define CODA_MAX_FORMATS	4
 
-#define CODA_PARA_BUF_SIZE	(10 * 1024)
 #define CODA_ISRAM_SIZE	(2048 * 2)
 
 #define MIN_W 176
@@ -1708,14 +1707,6 @@ static int coda_open(struct file *file)
 
 	ctx->fh.ctrl_handler = &ctx->ctrls;
 
-	if (ctx->use_bit) {
-		ret = coda_alloc_context_buf(ctx, &ctx->parabuf,
-					     CODA_PARA_BUF_SIZE, "parabuf");
-		if (ret < 0) {
-			v4l2_err(&dev->v4l2_dev, "failed to allocate parabuf");
-			goto err_dma_alloc;
-		}
-	}
 	mutex_init(&ctx->bitstream_mutex);
 	mutex_init(&ctx->buffer_mutex);
 	INIT_LIST_HEAD(&ctx->buffer_meta_list);
@@ -1729,8 +1720,6 @@ static int coda_open(struct file *file)
 
 	return 0;
 
-err_dma_alloc:
-	v4l2_ctrl_handler_free(&ctx->ctrls);
 err_ctrls_setup:
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 err_ctx_init:
@@ -1776,7 +1765,6 @@ static int coda_release(struct file *file)
 	if (ctx->dev->devtype->product == CODA_DX6)
 		coda_free_aux_buf(dev, &ctx->workbuf);
 
-	coda_free_aux_buf(dev, &ctx->parabuf);
 	v4l2_ctrl_handler_free(&ctx->ctrls);
 	clk_disable_unprepare(dev->clk_ahb);
 	clk_disable_unprepare(dev->clk_per);
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 01d940c..2b59e16 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -249,13 +249,6 @@ int coda_alloc_aux_buf(struct coda_dev *dev, struct coda_aux_buf *buf,
 		       size_t size, const char *name, struct dentry *parent);
 void coda_free_aux_buf(struct coda_dev *dev, struct coda_aux_buf *buf);
 
-static inline int coda_alloc_context_buf(struct coda_ctx *ctx,
-					 struct coda_aux_buf *buf, size_t size,
-					 const char *name)
-{
-	return coda_alloc_aux_buf(ctx->dev, buf, size, name, ctx->debugfs_entry);
-}
-
 int coda_encoder_queue_init(void *priv, struct vb2_queue *src_vq,
 			    struct vb2_queue *dst_vq);
 int coda_decoder_queue_init(void *priv, struct vb2_queue *src_vq,
-- 
2.1.4

