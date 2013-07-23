Return-path: <linux-media-owner@vger.kernel.org>
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:49319
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934209Ab3GWSFH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 14:05:07 -0400
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <k.debski@samsung.com>
CC: <m.chehab@samsung.com>, <kernel@pengutronix.de>,
	<linux-media@vger.kernel.org>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v4 3/3] [media] coda: No need to check the return value of platform_get_resource()
Date: Tue, 23 Jul 2013 15:04:50 -0300
Message-ID: <1374602690-12842-3-git-send-email-fabio.estevam@freescale.com>
In-Reply-To: <1374602690-12842-1-git-send-email-fabio.estevam@freescale.com>
References: <1374602690-12842-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When using devm_ioremap_resource(), we do not need to check the return value of
platform_get_resource(), so just remove it.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v3:
- None
Changes since v2:
- None
Changes since v1:
- None

 drivers/media/platform/coda.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 2d1576b..4a0a421 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -2049,11 +2049,6 @@ static int coda_probe(struct platform_device *pdev)
 
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


