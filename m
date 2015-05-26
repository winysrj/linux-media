Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50993 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbbEZN0l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2015 09:26:41 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <vinod.koul@intel.com>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
	<linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<linux-mmc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-spi@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<alsa-devel@alsa-project.org>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 04/13] mmc: omap_hsmmc: No need to check DMA channel validity at module remove
Date: Tue, 26 May 2015 16:25:59 +0300
Message-ID: <1432646768-12532-5-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver will not probe without valid DMA channels so no need to check
if they are valid when the module is removed.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/omap_hsmmc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 2cd828f42151..57bb85930f81 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -2190,10 +2190,8 @@ static int omap_hsmmc_remove(struct platform_device *pdev)
 	if (host->use_reg)
 		omap_hsmmc_reg_put(host);
 
-	if (host->tx_chan)
-		dma_release_channel(host->tx_chan);
-	if (host->rx_chan)
-		dma_release_channel(host->rx_chan);
+	dma_release_channel(host->tx_chan);
+	dma_release_channel(host->rx_chan);
 
 	pm_runtime_put_sync(host->dev);
 	pm_runtime_disable(host->dev);
-- 
2.3.5

