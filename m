Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30564 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753669AbdCTK5Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 06:57:16 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCH v3 08/16] media: s5p-mfc: Move firmware allocation to DMA
 configure function
Date: Mon, 20 Mar 2017 11:56:34 +0100
Message-id: <1490007402-30265-9-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1490007402-30265-1-git-send-email-m.szyprowski@samsung.com>
References: <1490007402-30265-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170320105651eucas1p2ff2722b748f1ceb529c4fd844f320c9b@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To complete DMA memory configuration for MFC device, allocation of the
firmware buffer is needed, because some parameters are dependant on its base
address. Till now, this has been handled in the s5p_mfc_alloc_firmware()
function. This patch moves that logic to s5p_mfc_configure_dma_memory() to
keep DMA memory related operations in a single place. This way
s5p_mfc_alloc_firmware() is simplified and does what it name says. The
other consequence of this change is moving s5p_mfc_alloc_firmware() call
from the s5p_mfc_probe() function to the s5p_mfc_configure_dma_memory().

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Acked-by: Andrzej Hajda <a.hajda@samsung.com>
Tested-by: Smitha T Murthy <smitha.t@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c      | 62 +++++++++++++++++++++------
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c | 31 --------------
 2 files changed, 49 insertions(+), 44 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 1fe790d88e70..16f4ba4f25ee 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1105,6 +1105,11 @@ static struct device *s5p_mfc_alloc_memdev(struct device *dev,
 static int s5p_mfc_configure_dma_memory(struct s5p_mfc_dev *mfc_dev)
 {
 	struct device *dev = &mfc_dev->plat_dev->dev;
+	void *bank2_virt;
+	dma_addr_t bank2_dma_addr;
+	unsigned long align_size = 1 << MFC_BASE_ALIGN_ORDER;
+	struct s5p_mfc_priv_buf *fw_buf = &mfc_dev->fw_buf;
+	int ret;
 
 	/*
 	 * When IOMMU is available, we cannot use the default configuration,
@@ -1117,14 +1122,21 @@ static int s5p_mfc_configure_dma_memory(struct s5p_mfc_dev *mfc_dev)
 	if (exynos_is_iommu_available(dev)) {
 		int ret = exynos_configure_iommu(dev, S5P_MFC_IOMMU_DMA_BASE,
 						 S5P_MFC_IOMMU_DMA_SIZE);
-		if (ret == 0) {
-			mfc_dev->mem_dev[BANK1_CTX] =
-				mfc_dev->mem_dev[BANK2_CTX] = dev;
-			vb2_dma_contig_set_max_seg_size(dev,
-							DMA_BIT_MASK(32));
+		if (ret)
+			return ret;
+
+		mfc_dev->mem_dev[BANK1_CTX] = mfc_dev->mem_dev[BANK2_CTX] = dev;
+		ret = s5p_mfc_alloc_firmware(mfc_dev);
+		if (ret) {
+			exynos_unconfigure_iommu(dev);
+			return ret;
 		}
 
-		return ret;
+		mfc_dev->dma_base[BANK1_CTX] = fw_buf->dma;
+		mfc_dev->dma_base[BANK2_CTX] = fw_buf->dma;
+		vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
+
+		return 0;
 	}
 
 	/*
@@ -1142,6 +1154,35 @@ static int s5p_mfc_configure_dma_memory(struct s5p_mfc_dev *mfc_dev)
 		return -ENODEV;
 	}
 
+	/* Allocate memory for firmware and initialize both banks addresses */
+	ret = s5p_mfc_alloc_firmware(mfc_dev);
+	if (ret) {
+		device_unregister(mfc_dev->mem_dev[BANK2_CTX]);
+		device_unregister(mfc_dev->mem_dev[BANK1_CTX]);
+		return ret;
+	}
+
+	mfc_dev->dma_base[BANK1_CTX] = fw_buf->dma;
+
+	bank2_virt = dma_alloc_coherent(mfc_dev->mem_dev[BANK2_CTX], align_size,
+					&bank2_dma_addr, GFP_KERNEL);
+	if (!bank2_virt) {
+		mfc_err("Allocating bank2 base failed\n");
+		s5p_mfc_release_firmware(mfc_dev);
+		device_unregister(mfc_dev->mem_dev[BANK2_CTX]);
+		device_unregister(mfc_dev->mem_dev[BANK1_CTX]);
+		return -ENOMEM;
+	}
+
+	/* Valid buffers passed to MFC encoder with LAST_FRAME command
+	 * should not have address of bank2 - MFC will treat it as a null frame.
+	 * To avoid such situation we set bank2 address below the pool address.
+	 */
+	mfc_dev->dma_base[BANK2_CTX] = bank2_dma_addr - align_size;
+
+	dma_free_coherent(mfc_dev->mem_dev[BANK2_CTX], align_size, bank2_virt,
+			  bank2_dma_addr);
+
 	vb2_dma_contig_set_max_seg_size(mfc_dev->mem_dev[BANK1_CTX],
 					DMA_BIT_MASK(32));
 	vb2_dma_contig_set_max_seg_size(mfc_dev->mem_dev[BANK2_CTX],
@@ -1154,6 +1195,8 @@ static void s5p_mfc_unconfigure_dma_memory(struct s5p_mfc_dev *mfc_dev)
 {
 	struct device *dev = &mfc_dev->plat_dev->dev;
 
+	s5p_mfc_release_firmware(mfc_dev);
+
 	if (exynos_is_iommu_available(dev)) {
 		exynos_unconfigure_iommu(dev);
 		vb2_dma_contig_clear_max_seg_size(dev);
@@ -1230,10 +1273,6 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	dev->watchdog_timer.data = (unsigned long)dev;
 	dev->watchdog_timer.function = s5p_mfc_watchdog;
 
-	ret = s5p_mfc_alloc_firmware(dev);
-	if (ret)
-		goto err_res;
-
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret)
 		goto err_v4l2_dev_reg;
@@ -1308,8 +1347,6 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 err_dec_alloc:
 	v4l2_device_unregister(&dev->v4l2_dev);
 err_v4l2_dev_reg:
-	s5p_mfc_release_firmware(dev);
-err_res:
 	s5p_mfc_final_pm(dev);
 err_dma:
 	s5p_mfc_unconfigure_dma_memory(dev);
@@ -1351,7 +1388,6 @@ static int s5p_mfc_remove(struct platform_device *pdev)
 	video_device_release(dev->vfd_enc);
 	video_device_release(dev->vfd_dec);
 	v4l2_device_unregister(&dev->v4l2_dev);
-	s5p_mfc_release_firmware(dev);
 	s5p_mfc_unconfigure_dma_memory(dev);
 
 	s5p_mfc_final_pm(dev);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index 50d698968049..b0cf3970117a 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -26,9 +26,6 @@
 /* Allocate memory for firmware */
 int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
 {
-	void *bank2_virt;
-	dma_addr_t bank2_dma_addr;
-	unsigned int align_size = 1 << MFC_BASE_ALIGN_ORDER;
 	struct s5p_mfc_priv_buf *fw_buf = &dev->fw_buf;
 
 	fw_buf->size = dev->variant->buf_size->fw;
@@ -44,35 +41,7 @@ int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
 		mfc_err("Allocating bitprocessor buffer failed\n");
 		return -ENOMEM;
 	}
-	dev->dma_base[BANK1_CTX] = fw_buf->dma;
-
-	if (HAS_PORTNUM(dev) && IS_TWOPORT(dev)) {
-		bank2_virt = dma_alloc_coherent(dev->mem_dev[BANK2_CTX],
-				       align_size, &bank2_dma_addr, GFP_KERNEL);
-
-		if (!bank2_virt) {
-			mfc_err("Allocating bank2 base failed\n");
-			dma_free_coherent(dev->mem_dev[BANK1_CTX], fw_buf->size,
-					  fw_buf->virt, fw_buf->dma);
-			fw_buf->virt = NULL;
-			return -ENOMEM;
-		}
-
-		/* Valid buffers passed to MFC encoder with LAST_FRAME command
-		 * should not have address of bank2 - MFC will treat it as a null frame.
-		 * To avoid such situation we set bank2 address below the pool address.
-		 */
-		dev->dma_base[BANK2_CTX] = bank2_dma_addr - align_size;
 
-		dma_free_coherent(dev->mem_dev[BANK2_CTX], align_size,
-				  bank2_virt, bank2_dma_addr);
-
-	} else {
-		/* In this case bank2 can point to the same address as bank1.
-		 * Firmware will always occupy the beginning of this area so it is
-		 * impossible having a video frame buffer with zero address. */
-		dev->dma_base[BANK2_CTX] = dev->dma_base[BANK1_CTX];
-	}
 	return 0;
 }
 
-- 
1.9.1
