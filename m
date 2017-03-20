Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27549 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753395AbdCTK5J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 06:57:09 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCH v3 13/16] media: s5p-mfc: Remove special configuration of IOMMU
 domain
Date: Mon, 20 Mar 2017 11:56:39 +0100
Message-id: <1490007402-30265-14-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1490007402-30265-1-git-send-email-m.szyprowski@samsung.com>
References: <1490007402-30265-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170320105653eucas1p236609e0bbed00d32b41c3eb8b63a159d@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The main reason for using special configuration of IOMMU domain was the
problem with MFC firmware, which failed to operate properly when placed
at 0 DMA address. Instead of adding custom code for configuring each
variant of IOMMU domain and architecture specific glue code, simply use
what arch code provides and if the DMA base address equals zero, skip
first 128 KiB to keep required alignment. This patch also make the driver
operational on ARM64 architecture, because it no longer depends on ARM
specific DMA-mapping and IOMMU glue code functions.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>
Acked-by: Andrzej Hajda <a.hajda@samsung.com>
Tested-by: Smitha T Murthy <smitha.t@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c       | 30 +++++++--------
 drivers/media/platform/s5p-mfc/s5p_mfc_iommu.h | 51 +-------------------------
 2 files changed, 14 insertions(+), 67 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index ea01d0aa8303..f1528054a713 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1179,18 +1179,6 @@ static int s5p_mfc_configure_common_memory(struct s5p_mfc_dev *mfc_dev)
 	struct device *dev = &mfc_dev->plat_dev->dev;
 	unsigned long mem_size = SZ_8M;
 	unsigned int bitmap_size;
-	/*
-	 * When IOMMU is available, we cannot use the default configuration,
-	 * because of MFC firmware requirements: address space limited to
-	 * 256M and non-zero default start address.
-	 * This is still simplified, not optimal configuration, but for now
-	 * IOMMU core doesn't allow to configure device's IOMMUs channel
-	 * separately.
-	 */
-	int ret = exynos_configure_iommu(dev, S5P_MFC_IOMMU_DMA_BASE,
-					 S5P_MFC_IOMMU_DMA_SIZE);
-	if (ret)
-		return ret;
 
 	if (mfc_mem_size)
 		mem_size = memparse(mfc_mem_size, NULL);
@@ -1198,10 +1186,8 @@ static int s5p_mfc_configure_common_memory(struct s5p_mfc_dev *mfc_dev)
 	bitmap_size = BITS_TO_LONGS(mem_size >> PAGE_SHIFT) * sizeof(long);
 
 	mfc_dev->mem_bitmap = kzalloc(bitmap_size, GFP_KERNEL);
-	if (!mfc_dev->mem_bitmap) {
-		exynos_unconfigure_iommu(dev);
+	if (!mfc_dev->mem_bitmap)
 		return -ENOMEM;
-	}
 
 	mfc_dev->mem_virt = dma_alloc_coherent(dev, mem_size,
 					       &mfc_dev->mem_base, GFP_KERNEL);
@@ -1209,13 +1195,24 @@ static int s5p_mfc_configure_common_memory(struct s5p_mfc_dev *mfc_dev)
 		kfree(mfc_dev->mem_bitmap);
 		dev_err(dev, "failed to preallocate %ld MiB for the firmware and context buffers\n",
 			(mem_size / SZ_1M));
-		exynos_unconfigure_iommu(dev);
 		return -ENOMEM;
 	}
 	mfc_dev->mem_size = mem_size;
 	mfc_dev->dma_base[BANK1_CTX] = mfc_dev->mem_base;
 	mfc_dev->dma_base[BANK2_CTX] = mfc_dev->mem_base;
 
+	/*
+	 * MFC hardware cannot handle 0 as a base address, so mark first 128K
+	 * as used (to keep required base alignment) and adjust base address
+	 */
+	if (mfc_dev->mem_base == (dma_addr_t)0) {
+		unsigned int offset = 1 << MFC_BASE_ALIGN_ORDER;
+
+		bitmap_set(mfc_dev->mem_bitmap, 0, offset >> PAGE_SHIFT);
+		mfc_dev->dma_base[BANK1_CTX] += offset;
+		mfc_dev->dma_base[BANK2_CTX] += offset;
+	}
+
 	/* Firmware allocation cannot fail in this case */
 	s5p_mfc_alloc_firmware(mfc_dev);
 
@@ -1232,7 +1229,6 @@ static void s5p_mfc_unconfigure_common_memory(struct s5p_mfc_dev *mfc_dev)
 {
 	struct device *dev = &mfc_dev->plat_dev->dev;
 
-	exynos_unconfigure_iommu(dev);
 	dma_free_coherent(dev, mfc_dev->mem_size, mfc_dev->mem_virt,
 			  mfc_dev->mem_base);
 	kfree(mfc_dev->mem_bitmap);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_iommu.h b/drivers/media/platform/s5p-mfc/s5p_mfc_iommu.h
index 6962132ae8fa..76667924ee2a 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_iommu.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_iommu.h
@@ -11,54 +11,13 @@
 #ifndef S5P_MFC_IOMMU_H_
 #define S5P_MFC_IOMMU_H_
 
-#define S5P_MFC_IOMMU_DMA_BASE	0x20000000lu
-#define S5P_MFC_IOMMU_DMA_SIZE	SZ_256M
-
-#if defined(CONFIG_EXYNOS_IOMMU) && defined(CONFIG_ARM_DMA_USE_IOMMU)
-
-#include <asm/dma-iommu.h>
+#if defined(CONFIG_EXYNOS_IOMMU)
 
 static inline bool exynos_is_iommu_available(struct device *dev)
 {
 	return dev->archdata.iommu != NULL;
 }
 
-static inline void exynos_unconfigure_iommu(struct device *dev)
-{
-	struct dma_iommu_mapping *mapping = to_dma_iommu_mapping(dev);
-
-	arm_iommu_detach_device(dev);
-	arm_iommu_release_mapping(mapping);
-}
-
-static inline int exynos_configure_iommu(struct device *dev,
-					 unsigned int base, unsigned int size)
-{
-	struct dma_iommu_mapping *mapping = NULL;
-	int ret;
-
-	/* Disable the default mapping created by device core */
-	if (to_dma_iommu_mapping(dev))
-		exynos_unconfigure_iommu(dev);
-
-	mapping = arm_iommu_create_mapping(dev->bus, base, size);
-	if (IS_ERR(mapping)) {
-		pr_warn("Failed to create IOMMU mapping for device %s\n",
-			dev_name(dev));
-		return PTR_ERR(mapping);
-	}
-
-	ret = arm_iommu_attach_device(dev, mapping);
-	if (ret) {
-		pr_warn("Failed to attached device %s to IOMMU_mapping\n",
-				dev_name(dev));
-		arm_iommu_release_mapping(mapping);
-		return ret;
-	}
-
-	return 0;
-}
-
 #else
 
 static inline bool exynos_is_iommu_available(struct device *dev)
@@ -66,14 +25,6 @@ static inline bool exynos_is_iommu_available(struct device *dev)
 	return false;
 }
 
-static inline int exynos_configure_iommu(struct device *dev,
-					 unsigned int base, unsigned int size)
-{
-	return -ENOSYS;
-}
-
-static inline void exynos_unconfigure_iommu(struct device *dev) { }
-
 #endif
 
 #endif /* S5P_MFC_IOMMU_H_ */
-- 
1.9.1
