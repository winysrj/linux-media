Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback1.mail.ru ([94.100.176.18]:42718 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaDZJPG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Apr 2014 05:15:06 -0400
Received: from smtp40.i.mail.ru (smtp40.i.mail.ru [94.100.177.100])
	by fallback1.mail.ru (mPOP.Fallback_MX) with ESMTP id 0590A37A8575
	for <linux-media@vger.kernel.org>; Sat, 26 Apr 2014 13:15:04 +0400 (MSK)
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Kamil Debski <k.debski@samsung.com>,
	Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] media: coda: Use full device name for request_irq()
Date: Sat, 26 Apr 2014 13:14:46 +0400
Message-Id: <1398503686-21102-1-git-send-email-shc_work@mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This will help to debug driver, allows us to see the full name of
the device through /proc/interrupts.

           CPU0
...
 69:          0  mxc-avic  53  10023000.coda
...

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/media/platform/coda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 3e5199e..11023b1 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -3235,7 +3235,7 @@ static int coda_probe(struct platform_device *pdev)
 	}
 
 	if (devm_request_threaded_irq(&pdev->dev, irq, NULL, coda_irq_handler,
-		IRQF_ONESHOT, CODA_NAME, dev) < 0) {
+		IRQF_ONESHOT, dev_name(&pdev->dev), dev) < 0) {
 		dev_err(&pdev->dev, "failed to request irq\n");
 		return -ENOENT;
 	}
-- 
1.8.3.2

