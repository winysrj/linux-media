Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:39761 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751635AbdBNHwZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 02:52:25 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCH 11/15] media: s5p-mfc: Split variant DMA memory configuration
 into separate functions
Date: Tue, 14 Feb 2017 08:52:04 +0100
Message-id: <1487058728-16501-12-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
References: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170214075219eucas1p193de247c3127167d68a2cca922e83fb3@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move code for DMA memory configuration with IOMMU into separate function
to make it easier to compare what is being done in each case.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 102 ++++++++++++++++++-------------
 1 file changed, 61 insertions(+), 41 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 92a88c20b26d..a18740c81c55 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1107,41 +1107,13 @@ static struct device *s5p_mfc_alloc_memdev(struct device *dev,
 	return NULL;
 }
 
-static int s5p_mfc_configure_dma_memory(struct s5p_mfc_dev *mfc_dev)
+static int s5p_mfc_configure_2port_memory(struct s5p_mfc_dev *mfc_dev)
 {
 	struct device *dev = &mfc_dev->plat_dev->dev;
 	void *bank2_virt;
 	dma_addr_t bank2_dma_addr;
 	unsigned long align_size = 1 << MFC_BASE_ALIGN_ORDER;
-	struct s5p_mfc_priv_buf *fw_buf = &mfc_dev->fw_buf;
-
-	/*
-	 * When IOMMU is available, we cannot use the default configuration,
-	 * because of MFC firmware requirements: address space limited to
-	 * 256M and non-zero default start address.
-	 * This is still simplified, not optimal configuration, but for now
-	 * IOMMU core doesn't allow to configure device's IOMMUs channel
-	 * separately.
-	 */
-	if (exynos_is_iommu_available(dev)) {
-		int ret = exynos_configure_iommu(dev, S5P_MFC_IOMMU_DMA_BASE,
-						 S5P_MFC_IOMMU_DMA_SIZE);
-		if (ret)
-			return ret;
-
-		mfc_dev->mem_dev[BANK1_CTX] = mfc_dev->mem_dev[BANK2_CTX] = dev;
-		ret = s5p_mfc_alloc_firmware(mfc_dev);
-		if (ret) {
-			exynos_unconfigure_iommu(dev);
-			return ret;
-		}
-
-		mfc_dev->dma_base[BANK1_CTX] = mfc_dev->fw_buf.dma;
-		mfc_dev->dma_base[BANK2_CTX] = mfc_dev->fw_buf.dma;
-		vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
-
-		return 0;
-	}
+	int ret;
 
 	/*
 	 * Create and initialize virtual devices for accessing
@@ -1188,26 +1160,74 @@ static int s5p_mfc_configure_dma_memory(struct s5p_mfc_dev *mfc_dev)
 					DMA_BIT_MASK(32));
 	vb2_dma_contig_set_max_seg_size(mfc_dev->mem_dev[BANK2_CTX],
 					DMA_BIT_MASK(32));
-
 	return 0;
 }
 
-static void s5p_mfc_unconfigure_dma_memory(struct s5p_mfc_dev *mfc_dev)
+static void s5p_mfc_unconfigure_2port_memory(struct s5p_mfc_dev *mfc_dev)
 {
-	struct device *dev = &mfc_dev->plat_dev->dev;
+	device_unregister(mfc_dev->mem_dev[BANK1_CTX]);
+	device_unregister(mfc_dev->mem_dev[BANK2_CTX]);
+	vb2_dma_contig_clear_max_seg_size(mfc_dev->mem_dev[BANK1_CTX]);
+	vb2_dma_contig_clear_max_seg_size(mfc_dev->mem_dev[BANK2_CTX]);
+}
 
-	s5p_mfc_release_firmware(mfc_dev);
+static int s5p_mfc_configure_common_memory(struct s5p_mfc_dev *mfc_dev)
+{
+	struct device *dev = &mfc_dev->plat_dev->dev;
+	/*
+	 * When IOMMU is available, we cannot use the default configuration,
+	 * because of MFC firmware requirements: address space limited to
+	 * 256M and non-zero default start address.
+	 * This is still simplified, not optimal configuration, but for now
+	 * IOMMU core doesn't allow to configure device's IOMMUs channel
+	 * separately.
+	 */
+	int ret = exynos_configure_iommu(dev, S5P_MFC_IOMMU_DMA_BASE,
+					 S5P_MFC_IOMMU_DMA_SIZE);
+	if (ret)
+		return ret;
 
-	if (exynos_is_iommu_available(dev)) {
+	mfc_dev->mem_dev[BANK1_CTX] = mfc_dev->mem_dev[BANK2_CTX] = dev;
+	ret = s5p_mfc_alloc_firmware(mfc_dev);
+	if (ret) {
 		exynos_unconfigure_iommu(dev);
-		vb2_dma_contig_clear_max_seg_size(dev);
-		return;
+		return ret;
 	}
 
-	device_unregister(mfc_dev->mem_dev[BANK1_CTX]);
-	device_unregister(mfc_dev->mem_dev[BANK2_CTX]);
-	vb2_dma_contig_clear_max_seg_size(mfc_dev->mem_dev[BANK1_CTX]);
-	vb2_dma_contig_clear_max_seg_size(mfc_dev->mem_dev[BANK2_CTX]);
+	mfc_dev->dma_base[BANK1_CTX] = mfc_dev->fw_buf.dma;
+	mfc_dev->dma_base[BANK2_CTX] = mfc_dev->fw_buf.dma;
+	vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
+
+	return 0;
+}
+
+static void s5p_mfc_unconfigure_common_memory(struct s5p_mfc_dev *mfc_dev)
+{
+	struct device *dev = &mfc_dev->plat_dev->dev;
+
+	exynos_unconfigure_iommu(dev);
+	vb2_dma_contig_clear_max_seg_size(dev);
+}
+
+static int s5p_mfc_configure_dma_memory(struct s5p_mfc_dev *mfc_dev)
+{
+	struct device *dev = &mfc_dev->plat_dev->dev;
+
+	if (exynos_is_iommu_available(dev))
+		return s5p_mfc_configure_common_memory(mfc_dev);
+	else
+		return s5p_mfc_configure_2port_memory(mfc_dev);
+}
+
+static void s5p_mfc_unconfigure_dma_memory(struct s5p_mfc_dev *mfc_dev)
+{
+	struct device *dev = &mfc_dev->plat_dev->dev;
+
+	s5p_mfc_release_firmware(mfc_dev);
+	if (exynos_is_iommu_available(dev))
+		s5p_mfc_unconfigure_common_memory(mfc_dev);
+	else
+		s5p_mfc_unconfigure_2port_memory(mfc_dev);
 }
 
 /* MFC probe function */
-- 
1.9.1
