Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37999 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760419AbaGYPIv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 11:08:51 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 04/11] [media] coda: Propagate the correct error on devm_request_threaded_irq()
Date: Fri, 25 Jul 2014 17:08:30 +0200
Message-Id: <1406300917-18169-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1406300917-18169-1-git-send-email-p.zabel@pengutronix.de>
References: <1406300917-18169-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

If devm_request_threaded_irq() fails, we should better propagate the real error.

Also, print out the error code in the dev_err message.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 31d0a2f..ab4b4c3 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1843,10 +1843,12 @@ static int coda_probe(struct platform_device *pdev)
 		return irq;
 	}
 
-	if (devm_request_threaded_irq(&pdev->dev, irq, NULL, coda_irq_handler,
-		IRQF_ONESHOT, dev_name(&pdev->dev), dev) < 0) {
-		dev_err(&pdev->dev, "failed to request irq\n");
-		return -ENOENT;
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+					coda_irq_handler, IRQF_ONESHOT,
+					dev_name(&pdev->dev), dev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to request irq: %d\n", ret);
+		return ret;
 	}
 
 	dev->rstc = devm_reset_control_get_optional(&pdev->dev, NULL);
-- 
2.0.1

