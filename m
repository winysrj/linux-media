Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ye0-f170.google.com ([209.85.213.170]:60496 "EHLO
	mail-ye0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab3GTTKw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jul 2013 15:10:52 -0400
Received: by mail-ye0-f170.google.com with SMTP id q3so1661106yen.29
        for <linux-media@vger.kernel.org>; Sat, 20 Jul 2013 12:10:51 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: k.debski@samsung.com
Cc: m.chehab@samsung.com, kernel@pengutronix.de,
	linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2 1/2] [media] coda: Check the return value from clk_prepare_enable()
Date: Sat, 20 Jul 2013 16:10:40 -0300
Message-Id: <1374347441-15662-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

clk_prepare_enable() may fail, so let's check its return value and propagate it
in the case of error.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v1:
- Add missing 'if'

 drivers/media/platform/coda.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index df4ada88..486db30 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1559,14 +1559,21 @@ static int coda_open(struct file *file)
 	list_add(&ctx->list, &dev->instances);
 	coda_unlock(ctx);
 
-	clk_prepare_enable(dev->clk_per);
-	clk_prepare_enable(dev->clk_ahb);
+	ret = clk_prepare_enable(dev->clk_per);
+	if (ret)
+		goto err;
+
+	ret = clk_prepare_enable(dev->clk_ahb);
+	if (ret)
+		goto err_clk_ahb;
 
 	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Created instance %d (%p)\n",
 		 ctx->idx, ctx);
 
 	return 0;
 
+err_clk_ahb:
+	clk_disable_unprepare(dev->clk_per);
 err:
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
-- 
1.8.1.2

