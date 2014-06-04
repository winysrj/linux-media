Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:54656 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaFDSqo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jun 2014 14:46:44 -0400
Received: by mail-yk0-f180.google.com with SMTP id q9so6427035ykb.39
        for <linux-media@vger.kernel.org>; Wed, 04 Jun 2014 11:46:43 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: m.chehab@samsung.com
Cc: p.zabel@pengutronix.de, linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2 2/2] [media] coda: Propagate the correct error on devm_request_threaded_irq()
Date: Wed,  4 Jun 2014 15:46:24 -0300
Message-Id: <1401907584-30218-2-git-send-email-festevam@gmail.com>
In-Reply-To: <1401907584-30218-1-git-send-email-festevam@gmail.com>
References: <1401907584-30218-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

If devm_request_threaded_irq() fails, we should better propagate the real error.

Also, print out the error code in the dev_err message.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
- None. Only rebased against latest tree

 drivers/media/platform/coda.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 32b3b6d..661bbe6 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -3232,10 +3232,11 @@ static int coda_probe(struct platform_device *pdev)
 		return irq;
 	}
 
-	if (devm_request_threaded_irq(&pdev->dev, irq, NULL, coda_irq_handler,
-		IRQF_ONESHOT, dev_name(&pdev->dev), dev) < 0) {
-		dev_err(&pdev->dev, "failed to request irq\n");
-		return -ENOENT;
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL, coda_irq_handler,
+			IRQF_ONESHOT, dev_name(&pdev->dev), dev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to request irq: %d\n", ret);
+		return ret;
 	}
 
 	/* Get IRAM pool from device tree or platform data */
-- 
1.8.3.2

