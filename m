Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f47.google.com ([209.85.213.47]:43534 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab3GWBoR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jul 2013 21:44:17 -0400
Received: by mail-yh0-f47.google.com with SMTP id z20so936258yhz.6
        for <linux-media@vger.kernel.org>; Mon, 22 Jul 2013 18:44:16 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: k.debski@samsung.com
Cc: m.chehab@samsung.com, kernel@pengutronix.de,
	linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v3 2/3] [media] coda: Check the return value from clk_prepare_enable()
Date: Mon, 22 Jul 2013 22:38:21 -0300
Message-Id: <1374543502-22678-2-git-send-email-festevam@gmail.com>
In-Reply-To: <1374543502-22678-1-git-send-email-festevam@gmail.com>
References: <1374543502-22678-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

clk_prepare_enable() may fail, so let's check its return value and propagate it
in the case of error.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
- Changes since v2:
- Release the previously acquired resources
Changes since v1:
- Add missing 'if'

 drivers/media/platform/coda.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index ea16c20..5f15aaa 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1561,14 +1561,27 @@ static int coda_open(struct file *file)
 	list_add(&ctx->list, &dev->instances);
 	coda_unlock(ctx);
 
-	clk_prepare_enable(dev->clk_per);
-	clk_prepare_enable(dev->clk_ahb);
+	ret = clk_prepare_enable(dev->clk_per);
+	if (ret)
+		goto err_clk_per;
+
+	ret = clk_prepare_enable(dev->clk_ahb);
+	if (ret)
+		goto err_clk_ahb;
 
 	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Created instance %d (%p)\n",
 		 ctx->idx, ctx);
 
 	return 0;
 
+err_clk_ahb:
+	clk_disable_unprepare(dev->clk_per);
+err_clk_per:
+	coda_lock(ctx);
+	list_del(&ctx->list);
+	coda_unlock(ctx);
+	dma_free_coherent(&dev->plat_dev->dev, CODA_PARA_BUF_SIZE,
+			  ctx->parabuf.vaddr, ctx->parabuf.paddr);
 err_dma_alloc:
 	v4l2_ctrl_handler_free(&ctx->ctrls);
 err_ctrls_setup:
-- 
1.8.1.2

