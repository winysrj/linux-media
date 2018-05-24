Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:33007 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964979AbeEXHHr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 03:07:47 -0400
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
Subject: [PATCH v2 13/13] ARM: pxa: change SSP DMA channels allocation
Date: Thu, 24 May 2018 09:07:03 +0200
Message-Id: <20180524070703.11901-14-robert.jarzmik@free.fr>
In-Reply-To: <20180524070703.11901-1-robert.jarzmik@free.fr>
References: <20180524070703.11901-1-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now the dma_slave_map is available for PXA architecture, switch the SSP
device to it.

This specifically means that :
- for platform data based machines, the DMA requestor channels are
  extracted from the slave map, where pxa-ssp-dai.<N> is a 1-1 match to
  ssp.<N>, and the channels are either "rx" or "tx".

- for device tree platforms, the dma node should be hooked into the
  pxa2xx-ac97 or pxa-ssp-dai node.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
Since v1: Removed channel names from platform_data
---
 arch/arm/plat-pxa/ssp.c    | 47 ----------------------------------------------
 include/linux/pxa2xx_ssp.h |  2 --
 sound/soc/pxa/pxa-ssp.c    |  5 ++---
 3 files changed, 2 insertions(+), 52 deletions(-)

diff --git a/arch/arm/plat-pxa/ssp.c b/arch/arm/plat-pxa/ssp.c
index ba13f793fbce..ed36dcab80f1 100644
--- a/arch/arm/plat-pxa/ssp.c
+++ b/arch/arm/plat-pxa/ssp.c
@@ -127,53 +127,6 @@ static int pxa_ssp_probe(struct platform_device *pdev)
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
-	}
-
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
 		dev_err(dev, "no memory resource defined\n");
diff --git a/include/linux/pxa2xx_ssp.h b/include/linux/pxa2xx_ssp.h
index 8461b18e4608..03a7ca46735b 100644
--- a/include/linux/pxa2xx_ssp.h
+++ b/include/linux/pxa2xx_ssp.h
@@ -212,8 +212,6 @@ struct ssp_device {
 	int		type;
 	int		use_count;
 	int		irq;
-	int		drcmr_rx;
-	int		drcmr_tx;
 
 	struct device_node	*of_node;
 };
diff --git a/sound/soc/pxa/pxa-ssp.c b/sound/soc/pxa/pxa-ssp.c
index 0291c7cb64eb..e09368d89bbc 100644
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
+		"tx" : "rx";
 
 	snd_soc_dai_set_dma_data(cpu_dai, substream, dma);
 
-- 
2.11.0
