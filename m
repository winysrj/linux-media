Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45226 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459AbbEZN0s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2015 09:26:48 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <vinod.koul@intel.com>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
	<linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<linux-mmc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-spi@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<alsa-devel@alsa-project.org>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 07/13] mmc: davinci_mmc: Support for deferred probing when requesting DMA channels
Date: Tue, 26 May 2015 16:26:02 +0300
Message-ID: <1432646768-12532-8-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch to use ma_request_slave_channel_compat_reason() to request the DMA
channels. Only fall back to pio mode if the error code returned is not
-EPROBE_DEFER, otherwise return from the probe with the -EPROBE_DEFER.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/davinci_mmc.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index b2b3f8bbfd8c..df81e4e2f662 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -530,20 +530,20 @@ static int __init davinci_acquire_dma_channels(struct mmc_davinci_host *host)
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 
-	host->dma_tx =
-		dma_request_slave_channel_compat(mask, edma_filter_fn,
-				&host->txdma, mmc_dev(host->mmc), "tx");
-	if (!host->dma_tx) {
+	host->dma_tx = dma_request_slave_channel_compat_reason(mask,
+				edma_filter_fn, &host->txdma,
+				mmc_dev(host->mmc), "tx");
+	if (IS_ERR(host->dma_tx)) {
 		dev_err(mmc_dev(host->mmc), "Can't get dma_tx channel\n");
-		return -ENODEV;
+		return PTR_ERR(host->dma_tx);
 	}
 
-	host->dma_rx =
-		dma_request_slave_channel_compat(mask, edma_filter_fn,
-				&host->rxdma, mmc_dev(host->mmc), "rx");
-	if (!host->dma_rx) {
+	host->dma_rx = dma_request_slave_channel_compat_reason(mask,
+				edma_filter_fn, &host->rxdma,
+				mmc_dev(host->mmc), "rx");
+	if (IS_ERR(host->dma_rx)) {
 		dev_err(mmc_dev(host->mmc), "Can't get dma_rx channel\n");
-		r = -ENODEV;
+		r = PTR_ERR(host->dma_rx);
 		goto free_master_write;
 	}
 
@@ -1307,8 +1307,12 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
 	host->mmc_irq = irq;
 	host->sdio_irq = platform_get_irq(pdev, 1);
 
-	if (host->use_dma && davinci_acquire_dma_channels(host) != 0)
+	if (host->use_dma) {
+		ret = davinci_acquire_dma_channels(host);
+		if (ret == -EPROBE_DEFER)
+			goto out;
 		host->use_dma = 0;
+	}
 
 	/* REVISIT:  someday, support IRQ-driven card detection.  */
 	mmc->caps |= MMC_CAP_NEEDS_POLL;
-- 
2.3.5

