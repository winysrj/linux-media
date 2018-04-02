Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:33376 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752724AbeDBO2P (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 10:28:15 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tejun Heo <tj@kernel.org>, Vinod Koul <vinod.koul@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Cyrille Pitchen <cyrille.pitchen@wedev4u.fr>,
        Nicolas Pitre <nico@fluxnic.net>,
        Samuel Ortiz <samuel@sortiz.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Pravin Shedge <pravin.shedge4linux@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, alsa-devel@alsa-project.org
Subject: [PATCH 09/15] net: irda: pxaficp_ir: remove the dmaengine compat need
Date: Mon,  2 Apr 2018 16:26:50 +0200
Message-Id: <20180402142656.26815-10-robert.jarzmik@free.fr>
In-Reply-To: <20180402142656.26815-1-robert.jarzmik@free.fr>
References: <20180402142656.26815-1-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the pxa architecture switched towards the dmaengine slave map, the
old compatibility mechanism to acquire the dma requestor line number and
priority are not needed anymore.

This patch simplifies the dma resource acquisition, using the more
generic function dma_request_slave_channel().

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/staging/irda/drivers/pxaficp_ir.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/irda/drivers/pxaficp_ir.c b/drivers/staging/irda/drivers/pxaficp_ir.c
index 2ea00a6531f9..9dd6e21dc11e 100644
--- a/drivers/staging/irda/drivers/pxaficp_ir.c
+++ b/drivers/staging/irda/drivers/pxaficp_ir.c
@@ -20,7 +20,6 @@
 #include <linux/clk.h>
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
-#include <linux/dma/pxa-dma.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
 #include <linux/sched/clock.h>
@@ -735,9 +734,7 @@ static void pxa_irda_shutdown(struct pxa_irda *si)
 static int pxa_irda_start(struct net_device *dev)
 {
 	struct pxa_irda *si = netdev_priv(dev);
-	dma_cap_mask_t mask;
 	struct dma_slave_config	config;
-	struct pxad_param param;
 	int err;
 
 	si->speed = 9600;
@@ -757,9 +754,6 @@ static int pxa_irda_start(struct net_device *dev)
 	disable_irq(si->icp_irq);
 
 	err = -EBUSY;
-	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
-	param.prio = PXAD_PRIO_LOWEST;
 
 	memset(&config, 0, sizeof(config));
 	config.src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
@@ -769,15 +763,11 @@ static int pxa_irda_start(struct net_device *dev)
 	config.src_maxburst = 32;
 	config.dst_maxburst = 32;
 
-	param.drcmr = si->drcmr_rx;
-	si->rxdma = dma_request_slave_channel_compat(mask, pxad_filter_fn,
-						     &param, &dev->dev, "rx");
+	si->rxdma = dma_request_slave_channel(&dev->dev, "rx");
 	if (!si->rxdma)
 		goto err_rx_dma;
 
-	param.drcmr = si->drcmr_tx;
-	si->txdma = dma_request_slave_channel_compat(mask, pxad_filter_fn,
-						     &param, &dev->dev, "tx");
+	si->txdma = dma_request_slave_channel(&dev->dev, "tx");
 	if (!si->txdma)
 		goto err_tx_dma;
 
-- 
2.11.0
