Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:62441 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaJDTlX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Oct 2014 15:41:23 -0400
Received: by mail-qg0-f54.google.com with SMTP id z107so2248489qgd.41
        for <linux-media@vger.kernel.org>; Sat, 04 Oct 2014 12:41:22 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: m.chehab@samsung.com
Cc: p.zabel@pengutronix.de, linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 2/3] [media] coda: Unregister v4l2 upon alloc_workqueue() error
Date: Sat,  4 Oct 2014 16:40:51 -0300
Message-Id: <1412451652-27220-2-git-send-email-festevam@gmail.com>
In-Reply-To: <1412451652-27220-1-git-send-email-festevam@gmail.com>
References: <1412451652-27220-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

If alloc_workqueue() fails, we should go to the 'err_v4l2_register' label, which
will unregister the v4l2 device.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/platform/coda/coda-common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 7cd82e8..951f1d4 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1971,7 +1971,8 @@ static int coda_probe(struct platform_device *pdev)
 	dev->workqueue = alloc_workqueue("coda", WQ_UNBOUND | WQ_MEM_RECLAIM, 1);
 	if (!dev->workqueue) {
 		dev_err(&pdev->dev, "unable to alloc workqueue\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_v4l2_register;
 	}
 
 	platform_set_drvdata(pdev, dev);
-- 
1.9.1

