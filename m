Return-path: <linux-media-owner@vger.kernel.org>
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:36862 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933728AbeFYNPn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Jun 2018 09:15:43 -0400
From: Mark Brown <broonie@kernel.org>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        alsa-devel@alsa-project.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-mtd@lists.infradead.org,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Applied "media: pxa_camera: remove the dmaengine compat need" to the asoc tree
In-Reply-To: <20180524070703.11901-5-robert.jarzmik@free.fr>
Message-Id: <E1fXRL4-0008Q6-RV@debutante>
Date: Mon, 25 Jun 2018 14:15:26 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch

   media: pxa_camera: remove the dmaengine compat need

has been applied to the asoc tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git 

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.  

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

>From f727b6cda449184188d8a64987f194687bf01782 Mon Sep 17 00:00:00 2001
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sun, 17 Jun 2018 19:02:08 +0200
Subject: [PATCH] media: pxa_camera: remove the dmaengine compat need

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
index d85ffbfb7c1f..b6e9e93bde7a 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -2375,8 +2375,6 @@ static int pxa_camera_probe(struct platform_device *pdev)
 		.src_maxburst = 8,
 		.direction = DMA_DEV_TO_MEM,
 	};
-	dma_cap_mask_t mask;
-	struct pxad_param params;
 	char clk_name[V4L2_CLK_NAME_SIZE];
 	int irq;
 	int err = 0, i;
@@ -2450,34 +2448,20 @@ static int pxa_camera_probe(struct platform_device *pdev)
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
2.18.0.rc2
