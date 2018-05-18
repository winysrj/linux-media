Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:56108 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751429AbeERVbH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 17:31:07 -0400
Subject: Re: [PATCH 05/15] mtd: nand: pxa3xx: remove the dmaengine compat need
To: Robert Jarzmik <robert.jarzmik@free.fr>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
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
        devel@driverdev.osuosl.org, alsa-devel@alsa-project.org,
        Robert Jarzmik <robert.jarzmik@renault.com>
References: <20180402142656.26815-1-robert.jarzmik@free.fr>
 <20180402142656.26815-6-robert.jarzmik@free.fr>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <a09d80dc-e8fd-1e9a-1878-8875ddc83134@zonque.org>
Date: Fri, 18 May 2018 23:31:02 +0200
MIME-Version: 1.0
In-Reply-To: <20180402142656.26815-6-robert.jarzmik@free.fr>
Content-Type: multipart/mixed;
 boundary="------------39EE53F47ACFCC5932325DF0"
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------39EE53F47ACFCC5932325DF0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Robert,

Thanks for this series.

On Monday, April 02, 2018 04:26 PM, Robert Jarzmik wrote:
> From: Robert Jarzmik <robert.jarzmik@renault.com>
> 
> As the pxa architecture switched towards the dmaengine slave map, the
> old compatibility mechanism to acquire the dma requestor line number and
> priority are not needed anymore.
> 
> This patch simplifies the dma resource acquisition, using the more
> generic function dma_request_slave_channel().
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>   drivers/mtd/nand/pxa3xx_nand.c | 10 +---------

This driver was replaced by drivers/mtd/nand/raw/marvell_nand.c 
recently, so this patch can be dropped. I attached a version for the new 
driver which you can pick instead.


Thanks,
Daniel

--------------39EE53F47ACFCC5932325DF0
Content-Type: text/x-patch;
 name="0001-mtd-rawnand-marvell-remove-dmaengine-compat-code.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-mtd-rawnand-marvell-remove-dmaengine-compat-code.patch"

>From c63bc40bdfe2d596e42919235840109a2f1b2776 Mon Sep 17 00:00:00 2001
From: Daniel Mack <daniel@zonque.org>
Date: Sat, 12 May 2018 21:50:13 +0200
Subject: [PATCH] mtd: rawnand: marvell: remove dmaengine compat code

As the pxa architecture switched towards the dmaengine slave map, the
old compatibility mechanism to acquire the dma requestor line number and
priority are not needed anymore.

This patch simplifies the dma resource acquisition, using the more
generic function dma_request_slave_channel().

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/mtd/nand/raw/marvell_nand.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/mtd/nand/raw/marvell_nand.c b/drivers/mtd/nand/raw/marvell_nand.c
index ebb1d141b900..30017cd7d91c 100644
--- a/drivers/mtd/nand/raw/marvell_nand.c
+++ b/drivers/mtd/nand/raw/marvell_nand.c
@@ -2612,8 +2612,6 @@ static int marvell_nfc_init_dma(struct marvell_nfc *nfc)
 						    dev);
 	struct dma_slave_config config = {};
 	struct resource *r;
-	dma_cap_mask_t mask;
-	struct pxad_param param;
 	int ret;
 
 	if (!IS_ENABLED(CONFIG_PXA_DMA)) {
@@ -2632,14 +2630,7 @@ static int marvell_nfc_init_dma(struct marvell_nfc *nfc)
 		return -ENXIO;
 	}
 
-	param.drcmr = r->start;
-	param.prio = PXAD_PRIO_LOWEST;
-	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
-	nfc->dma_chan =
-		dma_request_slave_channel_compat(mask, pxad_filter_fn,
-						 &param, nfc->dev,
-						 "data");
+	nfc->dma_chan = dma_request_slave_channel(nfc->dev, "data");
 	if (!nfc->dma_chan) {
 		dev_err(nfc->dev,
 			"Unable to request data DMA channel\n");
-- 
2.14.3


--------------39EE53F47ACFCC5932325DF0--
