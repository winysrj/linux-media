Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33546 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbeJMWyx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 13 Oct 2018 18:54:53 -0400
From: Christoph Hellwig <hch@lst.de>
To: linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] sound: hpios: don't pass GFP_DMA32 to dma_alloc_coherent
Date: Sat, 13 Oct 2018 17:17:03 +0200
Message-Id: <20181013151707.32210-5-hch@lst.de>
In-Reply-To: <20181013151707.32210-1-hch@lst.de>
References: <20181013151707.32210-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DMA API does its own zone decisions based on the coherent_dma_mask.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 sound/pci/asihpi/hpios.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/asihpi/hpios.c b/sound/pci/asihpi/hpios.c
index 5ef4fe964366..7c91330af719 100644
--- a/sound/pci/asihpi/hpios.c
+++ b/sound/pci/asihpi/hpios.c
@@ -49,7 +49,7 @@ u16 hpios_locked_mem_alloc(struct consistent_dma_area *p_mem_area, u32 size,
 	/*?? any benefit in using managed dmam_alloc_coherent? */
 	p_mem_area->vaddr =
 		dma_alloc_coherent(&pdev->dev, size, &p_mem_area->dma_handle,
-		GFP_DMA32 | GFP_KERNEL);
+		GFP_KERNEL);
 
 	if (p_mem_area->vaddr) {
 		HPI_DEBUG_LOG(DEBUG, "allocated %d bytes, dma 0x%x vma %p\n",
-- 
2.19.1
