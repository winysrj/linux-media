Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:43249 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaFDSqn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jun 2014 14:46:43 -0400
Received: by mail-yk0-f179.google.com with SMTP id 19so6419750ykq.10
        for <linux-media@vger.kernel.org>; Wed, 04 Jun 2014 11:46:42 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: m.chehab@samsung.com
Cc: p.zabel@pengutronix.de, linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2 1/2] [media] coda: Return the real error on platform_get_irq()
Date: Wed,  4 Jun 2014 15:46:23 -0300
Message-Id: <1401907584-30218-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

No need to return a 'fake' return value on platform_get_irq() failure.

Propagate the real error instead.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
- None. Only rebased against latest tree

 drivers/media/platform/coda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index b178379..32b3b6d 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -3229,7 +3229,7 @@ static int coda_probe(struct platform_device *pdev)
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		dev_err(&pdev->dev, "failed to get irq resource\n");
-		return -ENOENT;
+		return irq;
 	}
 
 	if (devm_request_threaded_irq(&pdev->dev, irq, NULL, coda_irq_handler,
-- 
1.8.3.2

