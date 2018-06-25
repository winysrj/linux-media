Return-path: <linux-media-owner@vger.kernel.org>
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:36640 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755558AbeFYNPf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Jun 2018 09:15:35 -0400
From: Mark Brown <broonie@kernel.org>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Daniel Mack <daniel@zonque.org>, Daniel Mack <daniel@zonque.org>,
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
Subject: Applied "ARM: pxa: change SSP DMA channels allocation" to the asoc tree
In-Reply-To: <20180524070703.11901-14-robert.jarzmik@free.fr>
Message-Id: <E1fXRKt-0008Il-HJ@debutante>
Date: Mon, 25 Jun 2018 14:15:15 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch

   ARM: pxa: change SSP DMA channels allocation

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

>From cd31b80736852d34bc1072f3e579a6fd73a244e7 Mon Sep 17 00:00:00 2001
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sun, 17 Jun 2018 19:02:17 +0200
Subject: [PATCH] ARM: pxa: change SSP DMA channels allocation

Now the dma_slave_map is available for PXA architecture, switch the SSP
device to it.

This specifically means that :
- for platform data based machines, the DMA requestor channels are
  extracted from the slave map, where pxa-ssp-dai.<N> is a 1-1 match to
  ssp.<N>, and the channels are either "rx" or "tx".

- for device tree platforms, the dma node should be hooked into the
  pxa2xx-ac97 or pxa-ssp-dai node.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
Acked-by: Daniel Mack <daniel@zonque.org>
---
 arch/arm/plat-pxa/ssp.c    | 47 --------------------------------------
 include/linux/pxa2xx_ssp.h |  2 --
 sound/soc/pxa/pxa-ssp.c    |  5 ++--
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
index 6fc986080130..0b441338bdd4 100644
--- a/sound/soc/pxa/pxa-ssp.c
+++ b/sound/soc/pxa/pxa-ssp.c
@@ -105,9 +105,8 @@ static int pxa_ssp_startup(struct snd_pcm_substream *substream,
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
2.18.0.rc2
