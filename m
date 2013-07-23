Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f43.google.com ([209.85.213.43]:35485 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab3GWBie (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jul 2013 21:38:34 -0400
Received: by mail-yh0-f43.google.com with SMTP id b12so2718726yha.30
        for <linux-media@vger.kernel.org>; Mon, 22 Jul 2013 18:38:33 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: k.debski@samsung.com
Cc: m.chehab@samsung.com, kernel@pengutronix.de,
	linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v3 1/3] [media] coda: Fix error paths
Date: Mon, 22 Jul 2013 22:38:20 -0300
Message-Id: <1374543502-22678-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

Some resources were not being released in the error path and some were released
in the incorrect order.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v2:
- Newly introduced in this series

 drivers/media/platform/coda.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index df4ada88..ea16c20 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1514,15 +1514,17 @@ static int coda_open(struct file *file)
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
@@ -1537,12 +1539,12 @@ static int coda_open(struct file *file)
 
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
@@ -1552,7 +1554,7 @@ static int coda_open(struct file *file)
 	if (!ctx->parabuf.vaddr) {
 		v4l2_err(&dev->v4l2_dev, "failed to allocate parabuf");
 		ret = -ENOMEM;
-		goto err;
+		goto err_dma_alloc;
 	}
 
 	coda_lock(ctx);
@@ -1567,9 +1569,15 @@ static int coda_open(struct file *file)
 
 	return 0;
 
-err:
+err_dma_alloc:
+	v4l2_ctrl_handler_free(&ctx->ctrls);
+err_ctrls_setup:
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+err_ctx_init:
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
+	clear_bit(ctx->idx, &dev->instance_mask);
+err_coda_max:
 	kfree(ctx);
 	return ret;
 }
@@ -1582,16 +1590,16 @@ static int coda_release(struct file *file)
 	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Releasing instance %p\n",
 		 ctx);
 
+	clk_disable_unprepare(dev->clk_ahb);
+	clk_disable_unprepare(dev->clk_per);
 	coda_lock(ctx);
 	list_del(&ctx->list);
 	coda_unlock(ctx);
 
 	dma_free_coherent(&dev->plat_dev->dev, CODA_PARA_BUF_SIZE,
 		ctx->parabuf.vaddr, ctx->parabuf.paddr);
-	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 	v4l2_ctrl_handler_free(&ctx->ctrls);
-	clk_disable_unprepare(dev->clk_per);
-	clk_disable_unprepare(dev->clk_ahb);
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 	clear_bit(ctx->idx, &dev->instance_mask);
-- 
1.8.1.2

