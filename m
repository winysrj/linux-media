Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f173.google.com ([209.85.161.173]:50733 "EHLO
	mail-gg0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab3GTStJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jul 2013 14:49:09 -0400
Received: by mail-gg0-f173.google.com with SMTP id k3so1627411ggn.18
        for <linux-media@vger.kernel.org>; Sat, 20 Jul 2013 11:49:08 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: k.debski@samsung.com
Cc: m.chehab@samsung.com, kernel@pengutronix.de,
	linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 2/2] [media] coda: No need to check the return value of platform_get_resource()
Date: Sat, 20 Jul 2013 15:48:49 -0300
Message-Id: <1374346129-12907-2-git-send-email-festevam@gmail.com>
In-Reply-To: <1374346129-12907-1-git-send-email-festevam@gmail.com>
References: <1374346129-12907-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

When using devm_ioremap_resource(), we do not need to check the return value of
platform_get_resource(), so just remove it.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/platform/coda.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index dd76228..236385f 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -2038,11 +2038,6 @@ static int coda_probe(struct platform_device *pdev)
 
 	/* Get  memory for physical registers */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "failed to get memory region resource\n");
-		return -ENOENT;
-	}
-
 	dev->regs_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(dev->regs_base))
 		return PTR_ERR(dev->regs_base);
-- 
1.8.1.2

