Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39810 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835AbcCDBCj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 20:02:39 -0500
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2] media: platform: Add missing MFD_SYSCON dependency on
 HAS_IOMEM
Date: Fri, 04 Mar 2016 10:02:24 +0900
Message-id: <1457053344-28992-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MFD_SYSCON depends on HAS_IOMEM so when selecting it avoid unmet
direct dependencies.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

---

Changes since v1:
1. Fix comments from Arnd: VIDEO_OMAP3 does not require it, however
   VIDEO_S5P_FIMC still needs it.
---
 drivers/media/platform/exynos4-is/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
index 57d42c6172c5..c4317b99d257 100644
--- a/drivers/media/platform/exynos4-is/Kconfig
+++ b/drivers/media/platform/exynos4-is/Kconfig
@@ -17,6 +17,7 @@ config VIDEO_S5P_FIMC
 	tristate "S5P/EXYNOS4 FIMC/CAMIF camera interface driver"
 	depends on I2C
 	depends on HAS_DMA
+	depends on HAS_IOMEM	# For MFD_SYSCON
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	select MFD_SYSCON
-- 
2.5.0

