Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40097 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbaI2Myc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 08:54:32 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/6] [media] coda: remove superfluous error message on devm_kzalloc failure
Date: Mon, 29 Sep 2014 14:53:43 +0200
Message-Id: <1411995227-3623-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1411995227-3623-1-git-send-email-p.zabel@pengutronix.de>
References: <1411995227-3623-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When devm_kzalloc causes an OOM condition, this is already reported by
the MM subsystem.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 3f8a04f..538d4ac 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1846,11 +1846,8 @@ static int coda_probe(struct platform_device *pdev)
 	int ret, irq;
 
 	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
-	if (!dev) {
-		dev_err(&pdev->dev, "Not enough memory for %s\n",
-			CODA_NAME);
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	spin_lock_init(&dev->irqlock);
 	INIT_LIST_HEAD(&dev->instances);
-- 
2.1.0

