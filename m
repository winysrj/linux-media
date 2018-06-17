Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:39478 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934728AbeFQRDK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Jun 2018 13:03:10 -0400
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
Subject: [PATCH v3 07/14] net: smc911x: remove the dmaengine compat need
Date: Sun, 17 Jun 2018 19:02:10 +0200
Message-Id: <20180617170217.24177-8-robert.jarzmik@free.fr>
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
---
Since v2: converted to NULL filter function and NULL dma parameter call
---
 drivers/net/ethernet/smsc/smc911x.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/smsc/smc911x.c
index 05157442a980..b1b53f6c452f 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -74,7 +74,6 @@ static const char version[] =
 #include <linux/skbuff.h>
 
 #include <linux/dmaengine.h>
-#include <linux/dma/pxa-dma.h>
 
 #include <asm/io.h>
 
@@ -1795,7 +1794,6 @@ static int smc911x_probe(struct net_device *dev)
 #ifdef SMC_USE_DMA
 	struct dma_slave_config	config;
 	dma_cap_mask_t mask;
-	struct pxad_param param;
 #endif
 
 	DBG(SMC_DEBUG_FUNC, dev, "--> %s\n", __func__);
@@ -1971,15 +1969,8 @@ static int smc911x_probe(struct net_device *dev)
 
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
-	param.prio = PXAD_PRIO_LOWEST;
-	param.drcmr = -1UL;
-
-	lp->rxdma =
-		dma_request_slave_channel_compat(mask, pxad_filter_fn,
-						 &param, &dev->dev, "rx");
-	lp->txdma =
-		dma_request_slave_channel_compat(mask, pxad_filter_fn,
-						 &param, &dev->dev, "tx");
+	lp->rxdma = dma_request_channel(mask, NULL, NULL);
+	lp->txdma = dma_request_channel(mask, NULL, NULL);
 	lp->rxdma_active = 0;
 	lp->txdma_active = 0;
 
-- 
2.11.0
