Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:22371 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934357AbeFQRKh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Jun 2018 13:10:37 -0400
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
Subject: [PATCH v3 05/14] media: pxa_camera: remove the dmaengine compat need
Date: Sun, 17 Jun 2018 19:02:08 +0200
Message-Id: <20180617170217.24177-6-robert.jarzmik@free.fr>
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
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/pxa_camera.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index c71a00736541..4c82d1880753 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -2357,8 +2357,6 @@ static int pxa_camera_probe(struct platform_device *pdev)
 		.src_maxburst = 8,
 		.direction = DMA_DEV_TO_MEM,
 	};
-	dma_cap_mask_t mask;
-	struct pxad_param params;
 	char clk_name[V4L2_CLK_NAME_SIZE];
 	int irq;
 	int err = 0, i;
@@ -2432,34 +2430,20 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	pcdev->base = base;
 
 	/* request dma */
-	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
-	dma_cap_set(DMA_PRIVATE, mask);
-
-	params.prio = 0;
-	params.drcmr = 68;
-	pcdev->dma_chans[0] =
-		dma_request_slave_channel_compat(mask, pxad_filter_fn,
-						 &params, &pdev->dev, "CI_Y");
+	pcdev->dma_chans[0] = dma_request_slave_channel(&pdev->dev, "CI_Y");
 	if (!pcdev->dma_chans[0]) {
 		dev_err(&pdev->dev, "Can't request DMA for Y\n");
 		return -ENODEV;
 	}
 
-	params.drcmr = 69;
-	pcdev->dma_chans[1] =
-		dma_request_slave_channel_compat(mask, pxad_filter_fn,
-						 &params, &pdev->dev, "CI_U");
+	pcdev->dma_chans[1] = dma_request_slave_channel(&pdev->dev, "CI_U");
 	if (!pcdev->dma_chans[1]) {
 		dev_err(&pdev->dev, "Can't request DMA for Y\n");
 		err = -ENODEV;
 		goto exit_free_dma_y;
 	}
 
-	params.drcmr = 70;
-	pcdev->dma_chans[2] =
-		dma_request_slave_channel_compat(mask, pxad_filter_fn,
-						 &params, &pdev->dev, "CI_V");
+	pcdev->dma_chans[2] = dma_request_slave_channel(&pdev->dev, "CI_V");
 	if (!pcdev->dma_chans[2]) {
 		dev_err(&pdev->dev, "Can't request DMA for V\n");
 		err = -ENODEV;
-- 
2.11.0
