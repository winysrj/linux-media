Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34373 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbeKFFyS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 00:54:18 -0500
Received: by mail-qt1-f194.google.com with SMTP id r14so148362qtp.1
        for <linux-media@vger.kernel.org>; Mon, 05 Nov 2018 12:32:52 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: p.zabel@pengutronix.de
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH] media: imx-pxp: Check the return value from clk_prepare_enable()
Date: Mon,  5 Nov 2018 18:33:10 -0200
Message-Id: <1541449991-24768-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

clk_prepare_enable() may fail, so we should better check its return value
and propagate it in the case of error.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 drivers/media/platform/imx-pxp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/imx-pxp.c b/drivers/media/platform/imx-pxp.c
index b76cd0e..27780f1 100644
--- a/drivers/media/platform/imx-pxp.c
+++ b/drivers/media/platform/imx-pxp.c
@@ -1666,7 +1666,10 @@ static int pxp_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	clk_prepare_enable(dev->clk);
+	ret = clk_prepare_enable(dev->clk);
+	if (ret < 0)
+		return ret;
+
 	pxp_soft_reset(dev);
 
 	spin_lock_init(&dev->irqlock);
-- 
2.7.4
