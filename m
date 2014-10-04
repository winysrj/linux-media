Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:56042 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaJDTlZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Oct 2014 15:41:25 -0400
Received: by mail-qc0-f175.google.com with SMTP id w7so2420016qcr.20
        for <linux-media@vger.kernel.org>; Sat, 04 Oct 2014 12:41:25 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: m.chehab@samsung.com
Cc: p.zabel@pengutronix.de, linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 3/3] [media] coda: Remove devm_kzalloc() error message
Date: Sat,  4 Oct 2014 16:40:52 -0300
Message-Id: <1412451652-27220-3-git-send-email-festevam@gmail.com>
In-Reply-To: <1412451652-27220-1-git-send-email-festevam@gmail.com>
References: <1412451652-27220-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

Core code already prints on OOM errors, so no need to keep this here.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/platform/coda/coda-common.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 951f1d4..72b624e 100644
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
1.9.1

