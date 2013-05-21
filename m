Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41183 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3EUITb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 04:19:31 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: use devm_ioremap_resouce
Date: Tue, 21 May 2013 10:19:27 +0200
Message-Id: <1369124367-22554-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 0319114..4a50386 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1985,17 +1985,9 @@ static int coda_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	if (devm_request_mem_region(&pdev->dev, res->start,
-			resource_size(res), CODA_NAME) == NULL) {
-		dev_err(&pdev->dev, "failed to request memory region\n");
-		return -ENOENT;
-	}
-	dev->regs_base = devm_ioremap(&pdev->dev, res->start,
-				      resource_size(res));
-	if (!dev->regs_base) {
-		dev_err(&pdev->dev, "failed to ioremap address region\n");
-		return -ENOENT;
-	}
+	dev->regs_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(dev->regs_base))
+		return PTR_ERR(dev->regs_base);
 
 	/* IRQ */
 	irq = platform_get_irq(pdev, 0);
-- 
1.8.2.rc2

