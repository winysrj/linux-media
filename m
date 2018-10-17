Return-path: <linux-media-owner@vger.kernel.org>
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:42218 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbeJQTua (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 15:50:30 -0400
From: Mark Brown <broonie@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Mark Brown <broonie@kernel.org>, linux-pm@vger.kernel.org,
        linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org
Subject: Applied "spi: pic32-sqi: don't pass GFP_DMA32 to dma_alloc_coherent" to the spi tree
In-Reply-To: <20181013151707.32210-4-hch@lst.de>
Message-Id: <20181017115504.2A15E11224C4@debutante.sirena.org.uk>
Date: Wed, 17 Oct 2018 12:55:04 +0100 (BST)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch

   spi: pic32-sqi: don't pass GFP_DMA32 to dma_alloc_coherent

has been applied to the spi tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git 

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

>From ec506e9246bf42795f1fa8a5cd00740e5686ba73 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Sat, 13 Oct 2018 17:17:02 +0200
Subject: [PATCH] spi: pic32-sqi: don't pass GFP_DMA32 to dma_alloc_coherent

The DMA API does its own zone decisions based on the coherent_dma_mask.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/spi/spi-pic32-sqi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-pic32-sqi.c b/drivers/spi/spi-pic32-sqi.c
index 62e6bf1f50b1..d7e4e18ec3df 100644
--- a/drivers/spi/spi-pic32-sqi.c
+++ b/drivers/spi/spi-pic32-sqi.c
@@ -468,7 +468,7 @@ static int ring_desc_ring_alloc(struct pic32_sqi *sqi)
 	/* allocate coherent DMAable memory for hardware buffer descriptors. */
 	sqi->bd = dma_zalloc_coherent(&sqi->master->dev,
 				      sizeof(*bd) * PESQI_BD_COUNT,
-				      &sqi->bd_dma, GFP_DMA32);
+				      &sqi->bd_dma, GFP_KERNEL);
 	if (!sqi->bd) {
 		dev_err(&sqi->master->dev, "failed allocating dma buffer\n");
 		return -ENOMEM;
-- 
2.19.0.rc2
