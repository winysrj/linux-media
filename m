Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:33693 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934448AbeFQRKm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Jun 2018 13:10:42 -0400
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
Subject: [PATCH v3 08/14] net: smc91x: remove the dmaengine compat need
Date: Sun, 17 Jun 2018 19:02:11 +0200
Message-Id: <20180617170217.24177-9-robert.jarzmik@free.fr>
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
 drivers/net/ethernet/smsc/smc91x.c | 9 +--------
 drivers/net/ethernet/smsc/smc91x.h | 1 -
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index 080428762858..b944828f9ea3 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -2019,17 +2019,10 @@ static int smc_probe(struct net_device *dev, void __iomem *ioaddr,
 #  endif
 	if (lp->cfg.flags & SMC91X_USE_DMA) {
 		dma_cap_mask_t mask;
-		struct pxad_param param;
 
 		dma_cap_zero(mask);
 		dma_cap_set(DMA_SLAVE, mask);
-		param.prio = PXAD_PRIO_LOWEST;
-		param.drcmr = -1UL;
-
-		lp->dma_chan =
-			dma_request_slave_channel_compat(mask, pxad_filter_fn,
-							 &param, &dev->dev,
-							 "data");
+		lp->dma_chan = dma_request_channel(mask, NULL, NULL);
 	}
 #endif
 
diff --git a/drivers/net/ethernet/smsc/smc91x.h b/drivers/net/ethernet/smsc/smc91x.h
index b337ee97e0c0..a27352229fc2 100644
--- a/drivers/net/ethernet/smsc/smc91x.h
+++ b/drivers/net/ethernet/smsc/smc91x.h
@@ -301,7 +301,6 @@ struct smc_local {
  * as RX which can overrun memory and lose packets.
  */
 #include <linux/dma-mapping.h>
-#include <linux/dma/pxa-dma.h>
 
 #ifdef SMC_insl
 #undef SMC_insl
-- 
2.11.0
