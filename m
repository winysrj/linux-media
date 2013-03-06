Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:49022 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879Ab3CFLyr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 06:54:47 -0500
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.samsung@gmail.com
Subject: [RFC 06/12] ARM: EXYNOS: Add devicetree node for FIMC-LITE driver for exynos5
Date: Wed,  6 Mar 2013 17:23:52 +0530
Message-Id: <1362570838-4737-7-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com>
References: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds necessary source definitions needed for FIMC-LITE
driver and adds devicetree node for exynos5250.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi       |   21 +++++++++++++++++++++
 arch/arm/mach-exynos/clock-exynos5.c    |    4 ++++
 arch/arm/mach-exynos/include/mach/map.h |    4 ++++
 arch/arm/mach-exynos/mach-exynos5-dt.c  |    6 ++++++
 4 files changed, 35 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 4fff98b..4754865 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -49,6 +49,9 @@
 		i2c8 = &i2c_8;
 		csis0 = &csis_0;
 		csis1 = &csis_1;
+		fimc-lite0 = &fimc_lite_0;
+		fimc-lite1 = &fimc_lite_1;
+		fimc-lite2 = &fimc_lite_2;
 	};
 
 	gic:interrupt-controller@10481000 {
@@ -375,4 +378,22 @@
 		bus-width = <4>;
 		status = "disabled";
 	};
+
+	fimc_lite_0: fimc-lite@13C00000 {
+		compatible = "samsung,exynos5250-fimc-lite";
+		reg = <0x13C00000 0x1000>;
+		interrupts = <0 125 0>;
+	};
+
+	fimc_lite_1: fimc-lite@13C10000 {
+		compatible = "samsung,exynos5250-fimc-lite";
+		reg = <0x13C10000 0x1000>;
+		interrupts = <0 126 0>;
+	};
+
+	fimc_lite_2: fimc-lite@13C90000 {
+		compatible = "samsung,exynos5250-fimc-lite";
+		reg = <0x13C90000 0x1000>;
+		interrupts = <0 110 0>;
+	};
 };
diff --git a/arch/arm/mach-exynos/clock-exynos5.c b/arch/arm/mach-exynos/clock-exynos5.c
index 34a22ff..4536515 100644
--- a/arch/arm/mach-exynos/clock-exynos5.c
+++ b/arch/arm/mach-exynos/clock-exynos5.c
@@ -859,6 +859,10 @@ static struct clk exynos5_init_clocks_off[] = {
 		.enable		= exynos5_clk_ip_gscl_ctrl,
 		.ctrlbit	= (1 << 3),
 	}, {
+		.name		= "flite",
+		.enable		= exynos5_clk_ip_gscl_ctrl,
+		.ctrlbit	= (1 << 4),
+	}, {
 		.name		= "csis",
 		.devname	= "s5p-mipi-csis.0",
 		.enable		= exynos5_clk_ip_gscl_ctrl,
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index c834321..5bfc744 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -125,6 +125,10 @@
 #define EXYNOS4_PA_SYSMMU_MFC_L		0x13620000
 #define EXYNOS4_PA_SYSMMU_MFC_R		0x13630000
 
+#define EXYNOS5_PA_FIMC_LITE0           0x13C00000
+#define EXYNOS5_PA_FIMC_LITE1           0x13C10000
+#define EXYNOS5_PA_FIMC_LITE2           0x13C90000
+
 #define EXYNOS5_PA_GSC0			0x13E00000
 #define EXYNOS5_PA_GSC1			0x13E10000
 #define EXYNOS5_PA_GSC2			0x13E20000
diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
index c420349..f6c3223 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -108,6 +108,12 @@ static const struct of_dev_auxdata exynos5250_auxdata_lookup[] __initconst = {
 				"s5p-mipi-csis.0", NULL),
 	OF_DEV_AUXDATA("samsung,exynos5250-csis", EXYNOS5_PA_MIPI_CSIS1,
 				"s5p-mipi-csis.1", NULL),
+	OF_DEV_AUXDATA("samsung,exynos5250-fimc-lite", EXYNOS5_PA_FIMC_LITE0,
+				"exynos5-fimc-lite.0", NULL),
+	OF_DEV_AUXDATA("samsung,exynos5250-fimc-lite", EXYNOS5_PA_FIMC_LITE1,
+				"exynos5-fimc-lite.1", NULL),
+	OF_DEV_AUXDATA("samsung,exynos5250-fimc-lite", EXYNOS5_PA_FIMC_LITE2,
+				"exynos5-fimc-lite.2", NULL),
 	{},
 };
 
-- 
1.7.9.5

