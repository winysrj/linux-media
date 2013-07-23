Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:28279
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934159Ab3GWSFF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 14:05:05 -0400
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <k.debski@samsung.com>
CC: <m.chehab@samsung.com>, <kernel@pengutronix.de>,
	<linux-media@vger.kernel.org>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v4 1/3] [media] coda: Fix error paths
Date: Tue, 23 Jul 2013 15:04:48 -0300
Message-ID: <1374602690-12842-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some resources were not being released in the error path and some were released
in the incorrect order.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v3:
- Only disable the clocks after v4l2_m2m_ctx_release()
Changes since v2:
- Newly introduced in this series

 drivers/media/platform/coda.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index df4ada88..9384f02 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1514,21 +1514,26 @@ static int coda_open(struct file *file)
 	int ret = 0;
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
+		ret =  -EBUSY;
+		goto err_coda_max;
+	}
+	set_bit(idx, &dev->instance_mask);
+
 	v4l2_fh_init(&ctx->fh, video_devdata(file));
 	file->private_data = &ctx->fh;
 	v4l2_fh_add(&ctx->fh);
 	ctx->dev = dev;
 	ctx->idx = idx;
 
+	clk_prepare_enable(dev->clk_per);
+	clk_prepare_enable(dev->clk_ahb);
+
 	set_default_params(ctx);
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx,
 					 &coda_queue_init);
@@ -1537,12 +1542,12 @@ static int coda_open(struct file *file)
 
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
@@ -1552,24 +1557,29 @@ static int coda_open(struct file *file)
 	if (!ctx->parabuf.vaddr) {
 		v4l2_err(&dev->v4l2_dev, "failed to allocate parabuf");
 		ret = -ENOMEM;
-		goto err;
+		goto err_dma_alloc;
 	}
 
 	coda_lock(ctx);
 	list_add(&ctx->list, &dev->instances);
 	coda_unlock(ctx);
 
-	clk_prepare_enable(dev->clk_per);
-	clk_prepare_enable(dev->clk_ahb);
-
 	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Created instance %d (%p)\n",
 		 ctx->idx, ctx);
 
 	return 0;
 
-err:
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
@@ -1588,10 +1598,10 @@ static int coda_release(struct file *file)
 
 	dma_free_coherent(&dev->plat_dev->dev, CODA_PARA_BUF_SIZE,
 		ctx->parabuf.vaddr, ctx->parabuf.paddr);
-	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 	v4l2_ctrl_handler_free(&ctx->ctrls);
-	clk_disable_unprepare(dev->clk_per);
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 	clk_disable_unprepare(dev->clk_ahb);
+	clk_disable_unprepare(dev->clk_per);
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 	clear_bit(ctx->idx, &dev->instance_mask);
-- 
1.8.1.2


