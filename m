Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38056 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbaGYPJQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 11:09:16 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 03/11] [media] coda: Return the real error on platform_get_irq()
Date: Fri, 25 Jul 2014 17:08:29 +0200
Message-Id: <1406300917-18169-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1406300917-18169-1-git-send-email-p.zabel@pengutronix.de>
References: <1406300917-18169-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

No need to return a 'fake' return value on platform_get_irq() failure.

Propagate the real error instead.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 65c7a12..31d0a2f 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1840,7 +1840,7 @@ static int coda_probe(struct platform_device *pdev)
 		irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		dev_err(&pdev->dev, "failed to get irq resource\n");
-		return -ENOENT;
+		return irq;
 	}
 
 	if (devm_request_threaded_irq(&pdev->dev, irq, NULL, coda_irq_handler,
-- 
2.0.1

