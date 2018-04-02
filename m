Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:32236 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752752AbeDBO2S (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 10:28:18 -0400
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
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, alsa-devel@alsa-project.org
Subject: [PATCH 10/15] ata: pata_pxa: remove the dmaengine compat need
Date: Mon,  2 Apr 2018 16:26:51 +0200
Message-Id: <20180402142656.26815-11-robert.jarzmik@free.fr>
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
 drivers/ata/pata_pxa.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/ata/pata_pxa.c b/drivers/ata/pata_pxa.c
index f6c46e9a4dc0..e8b6a2e464c9 100644
--- a/drivers/ata/pata_pxa.c
+++ b/drivers/ata/pata_pxa.c
@@ -25,7 +25,6 @@
 #include <linux/libata.h>
 #include <linux/platform_device.h>
 #include <linux/dmaengine.h>
-#include <linux/dma/pxa-dma.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
 #include <linux/completion.h>
@@ -180,8 +179,6 @@ static int pxa_ata_probe(struct platform_device *pdev)
 	struct resource *irq_res;
 	struct pata_pxa_pdata *pdata = dev_get_platdata(&pdev->dev);
 	struct dma_slave_config	config;
-	dma_cap_mask_t mask;
-	struct pxad_param param;
 	int ret = 0;
 
 	/*
@@ -278,10 +275,6 @@ static int pxa_ata_probe(struct platform_device *pdev)
 
 	ap->private_data = data;
 
-	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
-	param.prio = PXAD_PRIO_LOWEST;
-	param.drcmr = pdata->dma_dreq;
 	memset(&config, 0, sizeof(config));
 	config.src_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
 	config.dst_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
@@ -294,8 +287,7 @@ static int pxa_ata_probe(struct platform_device *pdev)
 	 * Request the DMA channel
 	 */
 	data->dma_chan =
-		dma_request_slave_channel_compat(mask, pxad_filter_fn,
-						 &param, &pdev->dev, "data");
+		dma_request_slave_channel(&pdev->dev, "data");
 	if (!data->dma_chan)
 		return -EBUSY;
 	ret = dmaengine_slave_config(data->dma_chan, &config);
-- 
2.11.0
