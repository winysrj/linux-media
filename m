Return-path: <linux-media-owner@vger.kernel.org>
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:41956 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbeJQTuU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 15:50:20 -0400
From: Mark Brown <broonie@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Mark Brown <broonie@kernel.org>, linux-pm@vger.kernel.org,
        linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Applied "ASoC: intel: don't pass GFP_DMA32 to dma_alloc_coherent" to the asoc tree
In-Reply-To: <20181013151707.32210-6-hch@lst.de>
Message-Id: <20181017115454.BA5D611224C4@debutante.sirena.org.uk>
Date: Wed, 17 Oct 2018 12:54:54 +0100 (BST)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch

   ASoC: intel: don't pass GFP_DMA32 to dma_alloc_coherent

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

>From 3b991038498bc5011b063d6a804503c577a79434 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Sat, 13 Oct 2018 17:17:04 +0200
Subject: [PATCH] ASoC: intel: don't pass GFP_DMA32 to dma_alloc_coherent

The DMA API does its own zone decisions based on the coherent_dma_mask.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 sound/soc/intel/common/sst-firmware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/common/sst-firmware.c b/sound/soc/intel/common/sst-firmware.c
index 11041aedea31..1e067504b604 100644
--- a/sound/soc/intel/common/sst-firmware.c
+++ b/sound/soc/intel/common/sst-firmware.c
@@ -355,7 +355,7 @@ struct sst_fw *sst_fw_new(struct sst_dsp *dsp,
 
 	/* allocate DMA buffer to store FW data */
 	sst_fw->dma_buf = dma_alloc_coherent(dsp->dma_dev, sst_fw->size,
-				&sst_fw->dmable_fw_paddr, GFP_DMA | GFP_KERNEL);
+				&sst_fw->dmable_fw_paddr, GFP_KERNEL);
 	if (!sst_fw->dma_buf) {
 		dev_err(dsp->dev, "error: DMA alloc failed\n");
 		kfree(sst_fw);
-- 
2.19.0.rc2
