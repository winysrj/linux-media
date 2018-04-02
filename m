Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:34301 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751344AbeDBOfj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 10:35:39 -0400
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
Subject: [PATCH 08/15] ASoC: pxa: remove the dmaengine compat need
Date: Mon,  2 Apr 2018 16:26:49 +0200
Message-Id: <20180402142656.26815-9-robert.jarzmik@free.fr>
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
 sound/arm/pxa2xx-ac97.c     | 14 ++------------
 sound/arm/pxa2xx-pcm-lib.c  |  6 +++---
 sound/soc/pxa/pxa2xx-ac97.c | 32 +++++---------------------------
 3 files changed, 10 insertions(+), 42 deletions(-)

diff --git a/sound/arm/pxa2xx-ac97.c b/sound/arm/pxa2xx-ac97.c
index 4bc244c40f80..236a63cdaf9f 100644
--- a/sound/arm/pxa2xx-ac97.c
+++ b/sound/arm/pxa2xx-ac97.c
@@ -63,28 +63,18 @@ static struct snd_ac97_bus_ops pxa2xx_ac97_ops = {
 	.reset	= pxa2xx_ac97_legacy_reset,
 };
 
-static struct pxad_param pxa2xx_ac97_pcm_out_req = {
-	.prio = PXAD_PRIO_LOWEST,
-	.drcmr = 12,
-};
-
 static struct snd_dmaengine_dai_dma_data pxa2xx_ac97_pcm_out = {
 	.addr		= __PREG(PCDR),
 	.addr_width	= DMA_SLAVE_BUSWIDTH_4_BYTES,
+	.chan_name	= "pcm_pcm_stereo_out",
 	.maxburst	= 32,
-	.filter_data	= &pxa2xx_ac97_pcm_out_req,
-};
-
-static struct pxad_param pxa2xx_ac97_pcm_in_req = {
-	.prio = PXAD_PRIO_LOWEST,
-	.drcmr = 11,
 };
 
 static struct snd_dmaengine_dai_dma_data pxa2xx_ac97_pcm_in = {
 	.addr		= __PREG(PCDR),
 	.addr_width	= DMA_SLAVE_BUSWIDTH_4_BYTES,
+	.chan_name	= "pcm_pcm_stereo_in",
 	.maxburst	= 32,
-	.filter_data	= &pxa2xx_ac97_pcm_in_req,
 };
 
 static struct snd_pcm *pxa2xx_ac97_pcm;
diff --git a/sound/arm/pxa2xx-pcm-lib.c b/sound/arm/pxa2xx-pcm-lib.c
index e8da3b8ee721..cbfaba60b79a 100644
--- a/sound/arm/pxa2xx-pcm-lib.c
+++ b/sound/arm/pxa2xx-pcm-lib.c
@@ -125,9 +125,9 @@ int __pxa2xx_pcm_open(struct snd_pcm_substream *substream)
 	if (ret < 0)
 		return ret;
 
-	return snd_dmaengine_pcm_open_request_chan(substream,
-					pxad_filter_fn,
-					dma_params->filter_data);
+	return snd_dmaengine_pcm_open(
+		substream, dma_request_slave_channel(rtd->platform->dev,
+						     dma_params->chan_name));
 }
 EXPORT_SYMBOL(__pxa2xx_pcm_open);
 
diff --git a/sound/soc/pxa/pxa2xx-ac97.c b/sound/soc/pxa/pxa2xx-ac97.c
index 803818aabee9..1b41c0f2a8fb 100644
--- a/sound/soc/pxa/pxa2xx-ac97.c
+++ b/sound/soc/pxa/pxa2xx-ac97.c
@@ -68,61 +68,39 @@ static struct snd_ac97_bus_ops pxa2xx_ac97_ops = {
 	.reset	= pxa2xx_ac97_cold_reset,
 };
 
-static struct pxad_param pxa2xx_ac97_pcm_stereo_in_req = {
-	.prio = PXAD_PRIO_LOWEST,
-	.drcmr = 11,
-};
-
 static struct snd_dmaengine_dai_dma_data pxa2xx_ac97_pcm_stereo_in = {
 	.addr		= __PREG(PCDR),
 	.addr_width	= DMA_SLAVE_BUSWIDTH_4_BYTES,
+	.chan_name	= "pcm_pcm_stereo_in",
 	.maxburst	= 32,
-	.filter_data	= &pxa2xx_ac97_pcm_stereo_in_req,
-};
-
-static struct pxad_param pxa2xx_ac97_pcm_stereo_out_req = {
-	.prio = PXAD_PRIO_LOWEST,
-	.drcmr = 12,
 };
 
 static struct snd_dmaengine_dai_dma_data pxa2xx_ac97_pcm_stereo_out = {
 	.addr		= __PREG(PCDR),
 	.addr_width	= DMA_SLAVE_BUSWIDTH_4_BYTES,
+	.chan_name	= "pcm_pcm_stereo_out",
 	.maxburst	= 32,
-	.filter_data	= &pxa2xx_ac97_pcm_stereo_out_req,
 };
 
-static struct pxad_param pxa2xx_ac97_pcm_aux_mono_out_req = {
-	.prio = PXAD_PRIO_LOWEST,
-	.drcmr = 10,
-};
 static struct snd_dmaengine_dai_dma_data pxa2xx_ac97_pcm_aux_mono_out = {
 	.addr		= __PREG(MODR),
 	.addr_width	= DMA_SLAVE_BUSWIDTH_2_BYTES,
+	.chan_name	= "pcm_aux_mono_out",
 	.maxburst	= 16,
-	.filter_data	= &pxa2xx_ac97_pcm_aux_mono_out_req,
 };
 
-static struct pxad_param pxa2xx_ac97_pcm_aux_mono_in_req = {
-	.prio = PXAD_PRIO_LOWEST,
-	.drcmr = 9,
-};
 static struct snd_dmaengine_dai_dma_data pxa2xx_ac97_pcm_aux_mono_in = {
 	.addr		= __PREG(MODR),
 	.addr_width	= DMA_SLAVE_BUSWIDTH_2_BYTES,
+	.chan_name	= "pcm_aux_mono_in",
 	.maxburst	= 16,
-	.filter_data	= &pxa2xx_ac97_pcm_aux_mono_in_req,
 };
 
-static struct pxad_param pxa2xx_ac97_pcm_aux_mic_mono_req = {
-	.prio = PXAD_PRIO_LOWEST,
-	.drcmr = 8,
-};
 static struct snd_dmaengine_dai_dma_data pxa2xx_ac97_pcm_mic_mono_in = {
 	.addr		= __PREG(MCDR),
 	.addr_width	= DMA_SLAVE_BUSWIDTH_2_BYTES,
+	.chan_name	= "pcm_aux_mic_mono",
 	.maxburst	= 16,
-	.filter_data	= &pxa2xx_ac97_pcm_aux_mic_mono_req,
 };
 
 static int pxa2xx_ac97_hifi_startup(struct snd_pcm_substream *substream,
-- 
2.11.0
