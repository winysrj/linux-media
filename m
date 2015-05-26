Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45254 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578AbbEZN1X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2015 09:27:23 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <vinod.koul@intel.com>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
	<linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<linux-mmc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-spi@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<alsa-devel@alsa-project.org>, Mark Brown <broonie@kernel.org>,
	Jarkko Nikula <jarkko.nikula@bitmer.com>,
	Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH 13/13] ASoC: omap-pcm: Switch to use dma_request_slave_channel_compat_reason()
Date: Tue, 26 May 2015 16:26:08 +0300
Message-ID: <1432646768-12532-14-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dmaengine provides a wrapper function to handle DT and non DT boots when
requesting DMA channel. Use that instead of checking for of_node in the
platform driver.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Mark Brown <broonie@kernel.org>
CC: Jarkko Nikula <jarkko.nikula@bitmer.com>
CC: Liam Girdwood <lgirdwood@gmail.com>
---
 sound/soc/omap/omap-pcm.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/sound/soc/omap/omap-pcm.c b/sound/soc/omap/omap-pcm.c
index 52fd7cbbd1f4..ae04834f4697 100644
--- a/sound/soc/omap/omap-pcm.c
+++ b/sound/soc/omap/omap-pcm.c
@@ -132,6 +132,7 @@ static int omap_pcm_open(struct snd_pcm_substream *substream)
 	struct snd_dmaengine_dai_dma_data *dma_data;
 	struct dma_slave_caps dma_caps;
 	struct dma_chan *chan;
+	dma_cap_mask_t mask;
 	u32 addr_widths = BIT(DMA_SLAVE_BUSWIDTH_1_BYTE) |
 			  BIT(DMA_SLAVE_BUSWIDTH_2_BYTES) |
 			  BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
@@ -139,12 +140,15 @@ static int omap_pcm_open(struct snd_pcm_substream *substream)
 
 	dma_data = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
 
-	if (rtd->cpu_dai->dev->of_node)
-		chan = dma_request_slave_channel(rtd->cpu_dai->dev,
-						 dma_data->filter_data);
-	else
-		chan = snd_dmaengine_pcm_request_channel(omap_dma_filter_fn,
-							 dma_data->filter_data);
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+	dma_cap_set(DMA_CYCLIC, mask);
+	chan = dma_request_slave_channel_compat_reason(mask, omap_dma_filter_fn,
+				dma_data->filter_data, rtd->cpu_dai->dev,
+				dma_data->filter_data);
+
+	if (IS_ERR(chan))
+		return PTR_ERR(chan);
 
 	if (!dma_get_slave_caps(chan, &dma_caps)) {
 		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-- 
2.3.5

