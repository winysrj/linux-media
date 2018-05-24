Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:53181 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964922AbeEXHHh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 03:07:37 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH v2 07/13] net: smc91x: remove the dmaengine compat need
Date: Thu, 24 May 2018 09:06:57 +0200
Message-Id: <20180524070703.11901-8-robert.jarzmik@free.fr>
In-Reply-To: <20180524070703.11901-1-robert.jarzmik@free.fr>
References: <20180524070703.11901-1-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the pxa architecture switched towards the dmaengine slave map, the
old compatibility mechanism to acquire the dma requestor line number and
priority are not needed anymore.

This patch simplifies the dma resource acquisition, using the more
generic function dma_request_slave_channel().

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/net/ethernet/smsc/smc91x.c | 12 +-----------
 drivers/net/ethernet/smsc/smc91x.h |  1 -
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index 080428762858..4c600f430f6d 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -2018,18 +2018,8 @@ static int smc_probe(struct net_device *dev, void __iomem *ioaddr,
 	lp->cfg.flags |= SMC91X_USE_DMA;
 #  endif
 	if (lp->cfg.flags & SMC91X_USE_DMA) {
-		dma_cap_mask_t mask;
-		struct pxad_param param;
-
-		dma_cap_zero(mask);
-		dma_cap_set(DMA_SLAVE, mask);
-		param.prio = PXAD_PRIO_LOWEST;
-		param.drcmr = -1UL;
-
 		lp->dma_chan =
-			dma_request_slave_channel_compat(mask, pxad_filter_fn,
-							 &param, &dev->dev,
-							 "data");
+			dma_request_slave_channel(lp->device, "data");
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
