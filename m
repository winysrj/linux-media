Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ye0-f174.google.com ([209.85.213.174]:36342 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab3GTStH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jul 2013 14:49:07 -0400
Received: by mail-ye0-f174.google.com with SMTP id m9so1639525yen.33
        for <linux-media@vger.kernel.org>; Sat, 20 Jul 2013 11:49:07 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: k.debski@samsung.com
Cc: m.chehab@samsung.com, kernel@pengutronix.de,
	linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 1/2] [media] coda: Check the return value from clk_prepare_enable()
Date: Sat, 20 Jul 2013 15:48:48 -0300
Message-Id: <1374346129-12907-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

clk_prepare_enable() may fail, so let's check its return value and propagate it
in the case of error.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/platform/coda.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index df4ada88..dd76228 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1559,14 +1559,20 @@ static int coda_open(struct file *file)
 	list_add(&ctx->list, &dev->instances);
 	coda_unlock(ctx);
 
-	clk_prepare_enable(dev->clk_per);
-	clk_prepare_enable(dev->clk_ahb);
+	ret = clk_prepare_enable(dev->clk_per);
+	if (ret)
+		goto err;
+
+	ret = clk_prepare_enable(dev->clk_ahb);
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

