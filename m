Return-path: <linux-media-owner@vger.kernel.org>
Received: from [207.46.163.27] ([207.46.163.27]:34256 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750841Ab3HTTc7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 15:32:59 -0400
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <k.debski@samsung.com>
CC: <p.zabel@pengutronix.de>, <linux-media@vger.kernel.org>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v6 1/3] [media] coda: Fix error paths
Date: Tue, 20 Aug 2013 16:29:36 -0300
Message-ID: <1377026978-23322-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some resources were not being released in the error path and some were released
in the incorrect order.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v5:
- Rebased against latest Kamil's tree

 drivers/media/platform/coda.c | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 66db0df..b5d48b7 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -2381,15 +2381,17 @@ static int coda_open(struct file *file)
 	int ret;
 	int idx;
 
-	idx = coda_next_free_instance(dev);
-	if (idx >= CODA_MAX_INSTANCES)
-		return -EBUSY;
-	set_bit(idx, &dev->instance_mask);
-
 	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
+	idx = coda_next_free_instance(dev);
+	if (idx >= CODA_MAX_INSTANCES) {
+		ret = -EBUSY;
+		goto err_coda_max;
+	}
+	set_bit(idx, &dev->instance_mask);
+
 	INIT_WORK(&ctx->skip_run, coda_skip_run);
 	v4l2_fh_init(&ctx->fh, video_devdata(file));
 	file->private_data = &ctx->fh;
@@ -2403,6 +2405,9 @@ static int coda_open(struct file *file)
 	default:
 		ctx->reg_idx = idx;
 	}
+
+	clk_prepare_enable(dev->clk_per);
+	clk_prepare_enable(dev->clk_ahb);
 	set_default_params(ctx);
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx,
 					 &coda_queue_init);
@@ -2411,12 +2416,12 @@ static int coda_open(struct file *file)
 
 		v4l2_err(&dev->v4l2_dev, "%s return error (%d)\n",
 			 __func__, ret);
-		goto err;
+		goto err_ctx_init;
 	}
 	ret = coda_ctrls_setup(ctx);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "failed to setup coda controls\n");
-		goto err;
+		goto err_ctrls_setup;
 	}
 
 	ctx->fh.ctrl_handler = &ctx->ctrls;
@@ -2424,7 +2429,7 @@ static int coda_open(struct file *file)
 	ret = coda_alloc_context_buf(ctx, &ctx->parabuf, CODA_PARA_BUF_SIZE);
 	if (ret < 0) {
 		v4l2_err(&dev->v4l2_dev, "failed to allocate parabuf");
-		goto err;
+		goto err_dma_alloc;
 	}
 
 	ctx->bitstream.size = CODA_MAX_FRAME_SIZE;
@@ -2433,7 +2438,7 @@ static int coda_open(struct file *file)
 	if (!ctx->bitstream.vaddr) {
 		v4l2_err(&dev->v4l2_dev, "failed to allocate bitstream ringbuffer");
 		ret = -ENOMEM;
-		goto err;
+		goto err_dma_writecombine;
 	}
 	kfifo_init(&ctx->bitstream_fifo,
 		ctx->bitstream.vaddr, ctx->bitstream.size);
@@ -2444,17 +2449,27 @@ static int coda_open(struct file *file)
 	list_add(&ctx->list, &dev->instances);
 	coda_unlock(ctx);
 
-	clk_prepare_enable(dev->clk_per);
-	clk_prepare_enable(dev->clk_ahb);
-
 	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Created instance %d (%p)\n",
 		 ctx->idx, ctx);
 
 	return 0;
 
-err:
+err_dma_writecombine:
+	coda_free_context_buffers(ctx);
+	if (ctx->dev->devtype->product == CODA_DX6)
+		coda_free_aux_buf(dev, &ctx->workbuf);
+	coda_free_aux_buf(dev, &ctx->parabuf);
+err_dma_alloc:
+	v4l2_ctrl_handler_free(&ctx->ctrls);
+err_ctrls_setup:
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+err_ctx_init:
+	clk_disable_unprepare(dev->clk_ahb);
+	clk_disable_unprepare(dev->clk_per);
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
+	clear_bit(ctx->idx, &dev->instance_mask);
+err_coda_max:
 	kfree(ctx);
 	return ret;
 }
@@ -2496,8 +2511,8 @@ static int coda_release(struct file *file)
 
 	coda_free_aux_buf(dev, &ctx->parabuf);
 	v4l2_ctrl_handler_free(&ctx->ctrls);
-	clk_disable_unprepare(dev->clk_per);
 	clk_disable_unprepare(dev->clk_ahb);
+	clk_disable_unprepare(dev->clk_per);
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 	clear_bit(ctx->idx, &dev->instance_mask);
-- 
1.8.1.2


