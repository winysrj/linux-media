Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:61549 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751616AbeDERy1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 13:54:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 07/16] media: exymos4-is: allow compile test for EXYNOS FIMC-LITE
Date: Thu,  5 Apr 2018 13:54:07 -0400
Message-Id: <3cf43e723f17b55d99d817efa535ded43561b1f6.1522949748.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522949748.git.mchehab@s-opensource.com>
References: <cover.1522949748.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522949748.git.mchehab@s-opensource.com>
References: <cover.1522949748.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's nothing that prevents building this driver with
COMPILE_TEST. So, enable it.

While here, make the Kconfig dependency cleaner by removing
the unneeded if block.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/exynos4-is/Kconfig | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
index 7b2c49e5a592..c8e5ad8f8294 100644
--- a/drivers/media/platform/exynos4-is/Kconfig
+++ b/drivers/media/platform/exynos4-is/Kconfig
@@ -41,11 +41,10 @@ config VIDEO_S5P_MIPI_CSIS
 	  To compile this driver as a module, choose M here: the
 	  module will be called s5p-csis.
 
-if SOC_EXYNOS4412 || SOC_EXYNOS5250
-
 config VIDEO_EXYNOS_FIMC_LITE
 	tristate "EXYNOS FIMC-LITE camera interface driver"
 	depends on I2C
+	depends on SOC_EXYNOS4412 || SOC_EXYNOS5250 || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEO_EXYNOS4_IS_COMMON
@@ -55,7 +54,6 @@ config VIDEO_EXYNOS_FIMC_LITE
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called exynos-fimc-lite.
-endif
 
 config VIDEO_EXYNOS4_FIMC_IS
 	tristate "EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver"
-- 
2.14.3
