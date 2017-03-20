Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30564 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753662AbdCTK5P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 06:57:15 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCH v3 06/16] media: s5p-mfc: Move setting DMA max segment size to
 DMA configure function
Date: Mon, 20 Mar 2017 11:56:32 +0100
Message-id: <1490007402-30265-7-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1490007402-30265-1-git-send-email-m.szyprowski@samsung.com>
References: <1490007402-30265-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170320105651eucas1p1c80766207bf60d211200f2f5daa2c799@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Setting DMA max segment size to 32 bit mask is a part of DMA memory
configuration, so move those calls to s5p_mfc_configure_dma_memory()
function.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>
Acked-by: Andrzej Hajda <a.hajda@samsung.com>
Tested-by: Smitha T Murthy <smitha.t@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index c03ed1a737b7..1fe790d88e70 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1117,9 +1117,13 @@ static int s5p_mfc_configure_dma_memory(struct s5p_mfc_dev *mfc_dev)
 	if (exynos_is_iommu_available(dev)) {
 		int ret = exynos_configure_iommu(dev, S5P_MFC_IOMMU_DMA_BASE,
 						 S5P_MFC_IOMMU_DMA_SIZE);
-		if (ret == 0)
+		if (ret == 0) {
 			mfc_dev->mem_dev[BANK1_CTX] =
 				mfc_dev->mem_dev[BANK2_CTX] = dev;
+			vb2_dma_contig_set_max_seg_size(dev,
+							DMA_BIT_MASK(32));
+		}
+
 		return ret;
 	}
 
@@ -1138,6 +1142,11 @@ static int s5p_mfc_configure_dma_memory(struct s5p_mfc_dev *mfc_dev)
 		return -ENODEV;
 	}
 
+	vb2_dma_contig_set_max_seg_size(mfc_dev->mem_dev[BANK1_CTX],
+					DMA_BIT_MASK(32));
+	vb2_dma_contig_set_max_seg_size(mfc_dev->mem_dev[BANK2_CTX],
+					DMA_BIT_MASK(32));
+
 	return 0;
 }
 
@@ -1147,11 +1156,14 @@ static void s5p_mfc_unconfigure_dma_memory(struct s5p_mfc_dev *mfc_dev)
 
 	if (exynos_is_iommu_available(dev)) {
 		exynos_unconfigure_iommu(dev);
+		vb2_dma_contig_clear_max_seg_size(dev);
 		return;
 	}
 
 	device_unregister(mfc_dev->mem_dev[BANK1_CTX]);
 	device_unregister(mfc_dev->mem_dev[BANK2_CTX]);
+	vb2_dma_contig_clear_max_seg_size(mfc_dev->mem_dev[BANK1_CTX]);
+	vb2_dma_contig_clear_max_seg_size(mfc_dev->mem_dev[BANK2_CTX]);
 }
 
 /* MFC probe function */
@@ -1209,11 +1221,6 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 		goto err_dma;
 	}
 
-	vb2_dma_contig_set_max_seg_size(dev->mem_dev[BANK1_CTX],
-					DMA_BIT_MASK(32));
-	vb2_dma_contig_set_max_seg_size(dev->mem_dev[BANK2_CTX],
-					DMA_BIT_MASK(32));
-
 	mutex_init(&dev->mfc_mutex);
 	init_waitqueue_head(&dev->queue);
 	dev->hw_lock = 0;
@@ -1346,8 +1353,6 @@ static int s5p_mfc_remove(struct platform_device *pdev)
 	v4l2_device_unregister(&dev->v4l2_dev);
 	s5p_mfc_release_firmware(dev);
 	s5p_mfc_unconfigure_dma_memory(dev);
-	vb2_dma_contig_clear_max_seg_size(dev->mem_dev[BANK1_CTX]);
-	vb2_dma_contig_clear_max_seg_size(dev->mem_dev[BANK2_CTX]);
 
 	s5p_mfc_final_pm(dev);
 	return 0;
-- 
1.9.1
