Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54536 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751253AbdJDGij (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Oct 2017 02:38:39 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 4/7] media: exynos4-is: Remove dependency on obsolete SoC
 support
Date: Wed, 04 Oct 2017 08:38:25 +0200
Message-id: <20171004063828.22068-5-m.szyprowski@samsung.com>
In-reply-to: <20171004063828.22068-1-m.szyprowski@samsung.com>
References: <20171004063828.22068-1-m.szyprowski@samsung.com>
        <CGME20171004063836eucas1p1c45902d81f8520b4bfc6b06ded50cc2b@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for Exynos4212 SoCs has been removed by commit bca9085e0ae9 ("ARM:
dts: exynos: remove Exynos4212 support (dead code)"), so there is no need
to keep remaining dead code related to this SoC version.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/exynos4-is/Kconfig     | 2 +-
 drivers/media/platform/exynos4-is/fimc-core.c | 2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
index 46a7d242a1a5..7b2c49e5a592 100644
--- a/drivers/media/platform/exynos4-is/Kconfig
+++ b/drivers/media/platform/exynos4-is/Kconfig
@@ -41,7 +41,7 @@ config VIDEO_S5P_MIPI_CSIS
 	  To compile this driver as a module, choose M here: the
 	  module will be called s5p-csis.
 
-if SOC_EXYNOS4212 || SOC_EXYNOS4412 || SOC_EXYNOS5250
+if SOC_EXYNOS4412 || SOC_EXYNOS5250
 
 config VIDEO_EXYNOS_FIMC_LITE
 	tristate "EXYNOS FIMC-LITE camera interface driver"
diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index 099c735a39b7..7ae239f2b0fd 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -1211,7 +1211,7 @@ static const struct fimc_drvdata fimc_drvdata_exynos4210 = {
 	.out_buf_count	= 32,
 };
 
-/* EXYNOS4212, EXYNOS4412 */
+/* EXYNOS4412 */
 static const struct fimc_drvdata fimc_drvdata_exynos4x12 = {
 	.num_entities	= 4,
 	.lclk_frequency	= 166000000UL,
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 4a3c9948ca54..3805a6daa3f4 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1646,7 +1646,7 @@ static const struct dev_pm_ops fimc_lite_pm_ops = {
 			   NULL)
 };
 
-/* EXYNOS4212, EXYNOS4412 */
+/* EXYNOS4412 */
 static struct flite_drvdata fimc_lite_drvdata_exynos4 = {
 	.max_width		= 8192,
 	.max_height		= 8192,
-- 
2.14.2
