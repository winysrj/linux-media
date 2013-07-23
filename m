Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f49.google.com ([209.85.213.49]:50372 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab3GWBii (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jul 2013 21:38:38 -0400
Received: by mail-yh0-f49.google.com with SMTP id f64so760251yha.36
        for <linux-media@vger.kernel.org>; Mon, 22 Jul 2013 18:38:37 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: k.debski@samsung.com
Cc: m.chehab@samsung.com, kernel@pengutronix.de,
	linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v3 3/3] [media] coda: No need to check the return value of platform_get_resource()
Date: Mon, 22 Jul 2013 22:38:22 -0300
Message-Id: <1374543502-22678-3-git-send-email-festevam@gmail.com>
In-Reply-To: <1374543502-22678-1-git-send-email-festevam@gmail.com>
References: <1374543502-22678-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

When using devm_ioremap_resource(), we do not need to check the return value of
platform_get_resource(), so just remove it.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v2:
- None
Changes since v1:
- None

 drivers/media/platform/coda.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 5f15aaa..78c9236 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -2053,11 +2053,6 @@ static int coda_probe(struct platform_device *pdev)
 
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

