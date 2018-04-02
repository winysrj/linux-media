Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:29392 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752418AbeDBO3P (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 10:29:15 -0400
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
        Russell King <linux@armlinux.org.uk>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, alsa-devel@alsa-project.org
Subject: [PATCH 15/15] ARM: pxa: change SSP DMA channels allocation
Date: Mon,  2 Apr 2018 16:26:56 +0200
Message-Id: <20180402142656.26815-16-robert.jarzmik@free.fr>
In-Reply-To: <20180402142656.26815-1-robert.jarzmik@free.fr>
References: <20180402142656.26815-1-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now the dma_slave_map is available for PXA architecture, switch the SSP
device to it.

This specifically means that :
- for platform data based machines, the DMA requestor channels are
  extracted from platform data and passed further to the SSP user,
  ie. usually the pxa-pcm-audio driver

- for device tree platforms, the dma node should be hooked into the
  pxa-pcm-audio node.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 arch/arm/plat-pxa/ssp.c    | 50 +++++-----------------------------------------
 include/linux/pxa2xx_ssp.h |  4 ++--
 sound/soc/pxa/pxa-ssp.c    |  5 ++---
 3 files changed, 9 insertions(+), 50 deletions(-)

diff --git a/arch/arm/plat-pxa/ssp.c b/arch/arm/plat-pxa/ssp.c
index ba13f793fbce..3457f01e3340 100644
--- a/arch/arm/plat-pxa/ssp.c
+++ b/arch/arm/plat-pxa/ssp.c
@@ -16,6 +16,7 @@
  *  Author: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
  */
 
+#include <mach/audio.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -116,6 +117,7 @@ static int pxa_ssp_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct ssp_device *ssp;
 	struct device *dev = &pdev->dev;
+	struct pxa_ssp_info *info = dev_get_platdata(dev);
 
 	ssp = devm_kzalloc(dev, sizeof(struct ssp_device), GFP_KERNEL);
 	if (ssp == NULL)
@@ -127,51 +129,9 @@ static int pxa_ssp_probe(struct platform_device *pdev)
 	if (IS_ERR(ssp->clk))
 		return PTR_ERR(ssp->clk);
 
-	if (dev->of_node) {
-		struct of_phandle_args dma_spec;
-		struct device_node *np = dev->of_node;
-		int ret;
-
-		/*
-		 * FIXME: we should allocate the DMA channel from this
-		 * context and pass the channel down to the ssp users.
-		 * For now, we lookup the rx and tx indices manually
-		 */
-
-		/* rx */
-		ret = of_parse_phandle_with_args(np, "dmas", "#dma-cells",
-						 0, &dma_spec);
-
-		if (ret) {
-			dev_err(dev, "Can't parse dmas property\n");
-			return -ENODEV;
-		}
-		ssp->drcmr_rx = dma_spec.args[0];
-		of_node_put(dma_spec.np);
-
-		/* tx */
-		ret = of_parse_phandle_with_args(np, "dmas", "#dma-cells",
-						 1, &dma_spec);
-		if (ret) {
-			dev_err(dev, "Can't parse dmas property\n");
-			return -ENODEV;
-		}
-		ssp->drcmr_tx = dma_spec.args[0];
-		of_node_put(dma_spec.np);
-	} else {
-		res = platform_get_resource(pdev, IORESOURCE_DMA, 0);
-		if (res == NULL) {
-			dev_err(dev, "no SSP RX DRCMR defined\n");
-			return -ENODEV;
-		}
-		ssp->drcmr_rx = res->start;
-
-		res = platform_get_resource(pdev, IORESOURCE_DMA, 1);
-		if (res == NULL) {
-			dev_err(dev, "no SSP TX DRCMR defined\n");
-			return -ENODEV;
-		}
-		ssp->drcmr_tx = res->start;
+	if (!dev->of_node && info) {
+		ssp->dma_chan_rx = info->dma_chan_rx_name;
+		ssp->dma_chan_tx = info->dma_chan_tx_name;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
diff --git a/include/linux/pxa2xx_ssp.h b/include/linux/pxa2xx_ssp.h
index 8461b18e4608..99c99d397e4d 100644
--- a/include/linux/pxa2xx_ssp.h
+++ b/include/linux/pxa2xx_ssp.h
@@ -212,9 +212,9 @@ struct ssp_device {
 	int		type;
 	int		use_count;
 	int		irq;
-	int		drcmr_rx;
-	int		drcmr_tx;
 
+	const char	*dma_chan_rx;
+	const char	*dma_chan_tx;
 	struct device_node	*of_node;
 };
 
diff --git a/sound/soc/pxa/pxa-ssp.c b/sound/soc/pxa/pxa-ssp.c
index 0291c7cb64eb..a0189b88f1d2 100644
--- a/sound/soc/pxa/pxa-ssp.c
+++ b/sound/soc/pxa/pxa-ssp.c
@@ -104,9 +104,8 @@ static int pxa_ssp_startup(struct snd_pcm_substream *substream,
 	dma = kzalloc(sizeof(struct snd_dmaengine_dai_dma_data), GFP_KERNEL);
 	if (!dma)
 		return -ENOMEM;
-
-	dma->filter_data = substream->stream == SNDRV_PCM_STREAM_PLAYBACK ?
-				&ssp->drcmr_tx : &ssp->drcmr_rx;
+	dma->chan_name = substream->stream == SNDRV_PCM_STREAM_PLAYBACK ?
+		ssp->dma_chan_tx : ssp->dma_chan_rx;
 
 	snd_soc_dai_set_dma_data(cpu_dai, substream, dma);
 
-- 
2.11.0
