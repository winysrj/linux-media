Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f179.google.com ([209.85.160.179]:57955 "EHLO
	mail-gh0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab3GTTKy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jul 2013 15:10:54 -0400
Received: by mail-gh0-f179.google.com with SMTP id f16so1667897ghb.38
        for <linux-media@vger.kernel.org>; Sat, 20 Jul 2013 12:10:53 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: k.debski@samsung.com
Cc: m.chehab@samsung.com, kernel@pengutronix.de,
	linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 2/2] [media] coda: No need to check the return value of platform_get_resource()
Date: Sat, 20 Jul 2013 16:10:41 -0300
Message-Id: <1374347441-15662-2-git-send-email-festevam@gmail.com>
In-Reply-To: <1374347441-15662-1-git-send-email-festevam@gmail.com>
References: <1374347441-15662-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

When using devm_ioremap_resource(), we do not need to check the return value of
platform_get_resource(), so just remove it.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v1:
- None

 drivers/media/platform/coda.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 486db30..f9a4b33 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -2039,11 +2039,6 @@ static int coda_probe(struct platform_device *pdev)
 
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

