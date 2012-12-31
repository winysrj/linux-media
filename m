Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:15709 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab2LaQEM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Dec 2012 11:04:12 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v2 10/15] ARM: EXYNOS4: Add OF_DEV_AUXDATA for FIMC,
 FIMC-LITE and CSIS
Date: Mon, 31 Dec 2012 17:03:08 +0100
Message-id: <1356969793-27268-11-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1356969793-27268-1-git-send-email-s.nawrocki@samsung.com>
References: <1356969793-27268-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add these temporary OF_DEV_AUXDATA entries so we can use clocks
before common clock framework support for Exynos4 is available.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/mach-exynos4-dt.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/mach-exynos/mach-exynos4-dt.c b/arch/arm/mach-exynos/mach-exynos4-dt.c
index 2890bf7..3ce0c52 100644
--- a/arch/arm/mach-exynos/mach-exynos4-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos4-dt.c
@@ -77,6 +77,22 @@ static const struct of_dev_auxdata exynos4_auxdata_lookup[] __initconst = {
 				"exynos4210-spi.2", NULL),
 	OF_DEV_AUXDATA("arm,pl330", EXYNOS4_PA_PDMA0, "dma-pl330.0", NULL),
 	OF_DEV_AUXDATA("arm,pl330", EXYNOS4_PA_PDMA1, "dma-pl330.1", NULL),
+	OF_DEV_AUXDATA("samsung,exynos4210-csis", EXYNOS4_PA_MIPI_CSIS0,
+				"s5p-mipi-csis.0", NULL),
+	OF_DEV_AUXDATA("samsung,exynos4210-csis", EXYNOS4_PA_MIPI_CSIS1,
+				"s5p-mipi-csis.1", NULL),
+	OF_DEV_AUXDATA("samsung,exynos4212-fimc", EXYNOS4_PA_FIMC0,
+				"exynos4-fimc.0", NULL),
+	OF_DEV_AUXDATA("samsung,exynos4212-fimc", EXYNOS4_PA_FIMC1,
+				"exynos4-fimc.1", NULL),
+	OF_DEV_AUXDATA("samsung,exynos4212-fimc", EXYNOS4_PA_FIMC2,
+				"exynos4-fimc.2", NULL),
+	OF_DEV_AUXDATA("samsung,exynos4212-fimc", EXYNOS4_PA_FIMC3,
+				"exynos4-fimc.3", NULL),
+	OF_DEV_AUXDATA("samsung,exynos4212-fimc-lite", EXYNOS4_PA_FIMC_LITE(0),
+				"exynos-fimc-lite.0", NULL),
+	OF_DEV_AUXDATA("samsung,exynos4212-fimc-lite", EXYNOS4_PA_FIMC_LITE(1),
+				"exynos-fimc-lite.1", NULL),
 	{},
 };
 
-- 
1.7.9.5

