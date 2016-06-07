Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56190 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbcFGLcb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2016 07:32:31 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-next@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Mark Brown <broonie@kernel.org>, linaro-kernel@lists.linaro.org
Subject: [PATCH] media: s5p-mfc: fix compilation issue on archs other than ARM
 (32bit)
Date: Tue, 07 Jun 2016 13:32:16 +0200
Message-id: <1465299136-8596-1-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <20160607105823.GT7510@sirena.org.uk>
References: <20160607105823.GT7510@sirena.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes build break caused by lack of dma-iommu API on ARM64
(this API is specific to ARM 32bit architecture).

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_iommu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_iommu.h b/drivers/media/platform/s5p-mfc/s5p_mfc_iommu.h
index 5d1d1c2..6962132 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_iommu.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_iommu.h
@@ -14,7 +14,7 @@
 #define S5P_MFC_IOMMU_DMA_BASE	0x20000000lu
 #define S5P_MFC_IOMMU_DMA_SIZE	SZ_256M
 
-#ifdef CONFIG_EXYNOS_IOMMU
+#if defined(CONFIG_EXYNOS_IOMMU) && defined(CONFIG_ARM_DMA_USE_IOMMU)
 
 #include <asm/dma-iommu.h>
 
-- 
1.9.2

