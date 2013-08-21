Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f47.google.com ([209.85.213.47]:58182 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab3HUPOa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 11:14:30 -0400
Received: by mail-yh0-f47.google.com with SMTP id 29so129852yhl.34
        for <linux-media@vger.kernel.org>; Wed, 21 Aug 2013 08:14:29 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: k.debski@samsung.com
Cc: p.zabel@pengutronix.de, linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v7 3/3] [media] coda: No need to check the return value of platform_get_resource()
Date: Wed, 21 Aug 2013 12:14:18 -0300
Message-Id: <1377098058-12566-3-git-send-email-festevam@gmail.com>
In-Reply-To: <1377098058-12566-1-git-send-email-festevam@gmail.com>
References: <1377098058-12566-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

When using devm_ioremap_resource(), we do not need to check the return value of
platform_get_resource(), so just remove it.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v6:
- Rebased against correct branch

 drivers/media/platform/coda.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 04ced56..999f9dc 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -3154,11 +3154,6 @@ static int coda_probe(struct platform_device *pdev)
 
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

