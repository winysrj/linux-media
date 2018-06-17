Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:57556 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934504AbeFQRDF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Jun 2018 13:03:05 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tejun Heo <tj@kernel.org>, Vinod Koul <vinod.koul@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Nicolas Pitre <nico@fluxnic.net>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH v3 04/14] mmc: pxamci: remove the dmaengine compat need
Date: Sun, 17 Jun 2018 19:02:07 +0200
Message-Id: <20180617170217.24177-5-robert.jarzmik@free.fr>
In-Reply-To: <20180617170217.24177-1-robert.jarzmik@free.fr>
References: <20180617170217.24177-1-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the pxa architecture switched towards the dmaengine slave map, the
old compatibility mechanism to acquire the dma requestor line number and
priority are not needed anymore.

This patch simplifies the dma resource acquisition, using the more
generic function dma_request_slave_channel().

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/pxamci.c | 29 +++--------------------------
 1 file changed, 3 insertions(+), 26 deletions(-)

diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index c763b404510f..6c94474e36f4 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -24,7 +24,6 @@
 #include <linux/interrupt.h>
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
-#include <linux/dma/pxa-dma.h>
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/mmc/host.h>
@@ -637,10 +636,8 @@ static int pxamci_probe(struct platform_device *pdev)
 {
 	struct mmc_host *mmc;
 	struct pxamci_host *host = NULL;
-	struct resource *r, *dmarx, *dmatx;
-	struct pxad_param param_rx, param_tx;
+	struct resource *r;
 	int ret, irq, gpio_cd = -1, gpio_ro = -1, gpio_power = -1;
-	dma_cap_mask_t mask;
 
 	ret = pxamci_of_init(pdev);
 	if (ret)
@@ -739,34 +736,14 @@ static int pxamci_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, mmc);
 
-	if (!pdev->dev.of_node) {
-		dmarx = platform_get_resource(pdev, IORESOURCE_DMA, 0);
-		dmatx = platform_get_resource(pdev, IORESOURCE_DMA, 1);
-		if (!dmarx || !dmatx) {
-			ret = -ENXIO;
-			goto out;
-		}
-		param_rx.prio = PXAD_PRIO_LOWEST;
-		param_rx.drcmr = dmarx->start;
-		param_tx.prio = PXAD_PRIO_LOWEST;
-		param_tx.drcmr = dmatx->start;
-	}
-
-	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
-
-	host->dma_chan_rx =
-		dma_request_slave_channel_compat(mask, pxad_filter_fn,
-						 &param_rx, &pdev->dev, "rx");
+	host->dma_chan_rx = dma_request_slave_channel(&pdev->dev, "rx");
 	if (host->dma_chan_rx == NULL) {
 		dev_err(&pdev->dev, "unable to request rx dma channel\n");
 		ret = -ENODEV;
 		goto out;
 	}
 
-	host->dma_chan_tx =
-		dma_request_slave_channel_compat(mask, pxad_filter_fn,
-						 &param_tx,  &pdev->dev, "tx");
+	host->dma_chan_tx = dma_request_slave_channel(&pdev->dev, "tx");
 	if (host->dma_chan_tx == NULL) {
 		dev_err(&pdev->dev, "unable to request tx dma channel\n");
 		ret = -ENODEV;
-- 
2.11.0
