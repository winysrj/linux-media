Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:39121 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934448AbeFQRDE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Jun 2018 13:03:04 -0400
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
        alsa-devel@alsa-project.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 03/14] dmaengine: pxa: add a default requestor policy
Date: Sun, 17 Jun 2018 19:02:06 +0200
Message-Id: <20180617170217.24177-4-robert.jarzmik@free.fr>
In-Reply-To: <20180617170217.24177-1-robert.jarzmik@free.fr>
References: <20180617170217.24177-1-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As what former drcmr -1 value meant, add a this as a default to each
channel, ie. that by default no requestor line is used.

This is specifically used for network drivers smc91x and smc911x, and
needed for their port to slave maps.

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
Acked-by: Vinod Koul <vkoul@kernel.org>
---
Since v1: changed -1 to U32_MAX
---
 drivers/dma/pxa_dma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/dma/pxa_dma.c b/drivers/dma/pxa_dma.c
index 9505334f9c6e..b31c28b67ad3 100644
--- a/drivers/dma/pxa_dma.c
+++ b/drivers/dma/pxa_dma.c
@@ -762,6 +762,8 @@ static void pxad_free_chan_resources(struct dma_chan *dchan)
 	dma_pool_destroy(chan->desc_pool);
 	chan->desc_pool = NULL;
 
+	chan->drcmr = U32_MAX;
+	chan->prio = PXAD_PRIO_LOWEST;
 }
 
 static void pxad_free_desc(struct virt_dma_desc *vd)
@@ -1386,6 +1388,9 @@ static int pxad_init_dmadev(struct platform_device *op,
 		c = devm_kzalloc(&op->dev, sizeof(*c), GFP_KERNEL);
 		if (!c)
 			return -ENOMEM;
+
+		c->drcmr = U32_MAX;
+		c->prio = PXAD_PRIO_LOWEST;
 		c->vc.desc_free = pxad_free_desc;
 		vchan_init(&c->vc, &pdev->slave);
 		init_waitqueue_head(&c->wq_state);
-- 
2.11.0
