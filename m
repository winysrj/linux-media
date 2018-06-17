Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:55083 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935157AbeFQRDU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Jun 2018 13:03:20 -0400
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
Subject: [PATCH v3 12/14] dmaengine: pxa: make the filter function internal
Date: Sun, 17 Jun 2018 19:02:15 +0200
Message-Id: <20180617170217.24177-13-robert.jarzmik@free.fr>
In-Reply-To: <20180617170217.24177-1-robert.jarzmik@free.fr>
References: <20180617170217.24177-1-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the pxa architecture and all its related drivers do not rely anymore
on the filter function, thanks to the slave map conversion, make
pxad_filter_fn() static, and remove it from the global namespace.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
Acked-by: Vinod Koul <vkoul@kernel.org>
---
Since v1: added Vinod's ack
---
 drivers/dma/pxa_dma.c       |  5 ++---
 include/linux/dma/pxa-dma.h | 11 -----------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/pxa_dma.c b/drivers/dma/pxa_dma.c
index b31c28b67ad3..0db29bd1b096 100644
--- a/drivers/dma/pxa_dma.c
+++ b/drivers/dma/pxa_dma.c
@@ -179,7 +179,7 @@ static unsigned int pxad_drcmr(unsigned int line)
 	return 0x1000 + line * 4;
 }
 
-bool pxad_filter_fn(struct dma_chan *chan, void *param);
+static bool pxad_filter_fn(struct dma_chan *chan, void *param);
 
 /*
  * Debug fs
@@ -1501,7 +1501,7 @@ static struct platform_driver pxad_driver = {
 	.remove		= pxad_remove,
 };
 
-bool pxad_filter_fn(struct dma_chan *chan, void *param)
+static bool pxad_filter_fn(struct dma_chan *chan, void *param)
 {
 	struct pxad_chan *c = to_pxad_chan(chan);
 	struct pxad_param *p = param;
@@ -1514,7 +1514,6 @@ bool pxad_filter_fn(struct dma_chan *chan, void *param)
 
 	return true;
 }
-EXPORT_SYMBOL_GPL(pxad_filter_fn);
 
 module_platform_driver(pxad_driver);
 
diff --git a/include/linux/dma/pxa-dma.h b/include/linux/dma/pxa-dma.h
index 9fc594f69eff..fceb5df07097 100644
--- a/include/linux/dma/pxa-dma.h
+++ b/include/linux/dma/pxa-dma.h
@@ -23,15 +23,4 @@ struct pxad_param {
 	enum pxad_chan_prio prio;
 };
 
-struct dma_chan;
-
-#ifdef CONFIG_PXA_DMA
-bool pxad_filter_fn(struct dma_chan *chan, void *param);
-#else
-static inline bool pxad_filter_fn(struct dma_chan *chan, void *param)
-{
-	return false;
-}
-#endif
-
 #endif /* _PXA_DMA_H_ */
-- 
2.11.0
