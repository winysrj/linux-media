Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36047 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387480AbeKFTkQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 14:40:16 -0500
Received: by mail-qt1-f194.google.com with SMTP id u34-v6so1918762qth.3
        for <linux-media@vger.kernel.org>; Tue, 06 Nov 2018 02:15:47 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: p.zabel@pengutronix.de
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v3 1/3] media: imx-pxp: Check the return value from clk_prepare_enable()
Date: Tue,  6 Nov 2018 08:16:03 -0200
Message-Id: <1541499365-10069-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

clk_prepare_enable() may fail, so we should better check its return value
and propagate it in the case of error.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v2:
- None

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
