Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:21520 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752520AbdBTNjU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 08:39:20 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCH v2 14/15] media: s5p-mfc: Use preallocated block allocator
 always for MFC v6+
Date: Mon, 20 Feb 2017 14:39:03 +0100
Message-id: <1487597944-2000-15-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1487597944-2000-1-git-send-email-m.szyprowski@samsung.com>
References: <1487597944-2000-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170220133917eucas1p2f141e73392ee36596410ce308360a5d7@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It turned out that all versions of MFC v6+ hardware doesn't have a strict
requirement for ALL buffers to be allocated on higher addresses than the
firmware base like it was documented for MFC v5. This requirement is true
only for the device and per-context buffers. All video data buffers can be
allocated anywhere for all MFC v6+ versions. Basing on this fact, the
special DMA configuration based on two reserved memory regions is not
really needed for MFC v6+ devices, because the memory requirements for the
firmware, device and per-context buffers can be fulfilled by the simple
probe-time pre-allocated block allocator instroduced in previous patch.

This patch enables support for such pre-allocated block based allocator
always for MFC v6+ devices. Due to the limitations of the memory management
subsystem the largest supported size of the pre-allocated buffer when no
CMA (Contiguous Memory Allocator) is enabled is 4MiB.

This patch also removes the requirement to provide two reserved memory
regions for MFC v6+ devices in device tree. Now the driver is fully
functional without them.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>
---
 Documentation/devicetree/bindings/media/s5p-mfc.txt | 2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c            | 9 ++++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/s5p-mfc.txt b/Documentation/devicetree/bindings/media/s5p-mfc.txt
index 2c901286d818..d3404b5d4d17 100644
--- a/Documentation/devicetree/bindings/media/s5p-mfc.txt
+++ b/Documentation/devicetree/bindings/media/s5p-mfc.txt
@@ -28,7 +28,7 @@ Optional properties:
   - memory-region : from reserved memory binding: phandles to two reserved
 	memory regions, first is for "left" mfc memory bus interfaces,
 	second if for the "right" mfc memory bus, used when no SYSMMU
-	support is available
+	support is available; used only by MFC v5 present in Exynos4 SoCs
 
 Obsolete properties:
   - samsung,mfc-r, samsung,mfc-l : support removed, please use memory-region
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index b70cbd637851..b4a13e4cc9d4 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1182,9 +1182,12 @@ static void s5p_mfc_unconfigure_2port_memory(struct s5p_mfc_dev *mfc_dev)
 static int s5p_mfc_configure_common_memory(struct s5p_mfc_dev *mfc_dev)
 {
 	struct device *dev = &mfc_dev->plat_dev->dev;
-	unsigned long mem_size = SZ_8M;
+	unsigned long mem_size = SZ_4M;
 	unsigned int bitmap_size;
 
+	if (IS_ENABLED(CONFIG_DMA_CMA) || exynos_is_iommu_available(dev))
+		mem_size = SZ_8M;
+
 	if (mfc_mem_size)
 		mem_size = memparse(mfc_mem_size, NULL);
 
@@ -1244,7 +1247,7 @@ static int s5p_mfc_configure_dma_memory(struct s5p_mfc_dev *mfc_dev)
 {
 	struct device *dev = &mfc_dev->plat_dev->dev;
 
-	if (exynos_is_iommu_available(dev))
+	if (exynos_is_iommu_available(dev) || !IS_TWOPORT(mfc_dev))
 		return s5p_mfc_configure_common_memory(mfc_dev);
 	else
 		return s5p_mfc_configure_2port_memory(mfc_dev);
@@ -1255,7 +1258,7 @@ static void s5p_mfc_unconfigure_dma_memory(struct s5p_mfc_dev *mfc_dev)
 	struct device *dev = &mfc_dev->plat_dev->dev;
 
 	s5p_mfc_release_firmware(mfc_dev);
-	if (exynos_is_iommu_available(dev))
+	if (exynos_is_iommu_available(dev) || !IS_TWOPORT(mfc_dev))
 		s5p_mfc_unconfigure_common_memory(mfc_dev);
 	else
 		s5p_mfc_unconfigure_2port_memory(mfc_dev);
-- 
1.9.1
