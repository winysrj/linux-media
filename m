Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:55933 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab3CFLyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 06:54:43 -0500
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.samsung@gmail.com
Subject: [RFC 05/12] ARM: EXYNOS: Add devicetree node for mipi-csis driver for exynos5
Date: Wed,  6 Mar 2013 17:23:51 +0530
Message-Id: <1362570838-4737-6-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com>
References: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds necessary source definations needed for mipi-csis
driver and adds devicetree node for exynos5250.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi       |   18 ++++++++++++++++++
 arch/arm/mach-exynos/clock-exynos5.c    |   16 ++++++++++++++--
 arch/arm/mach-exynos/include/mach/map.h |    3 +++
 arch/arm/mach-exynos/mach-exynos5-dt.c  |    4 ++++
 4 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 3a2cd9a..4fff98b 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -47,6 +47,8 @@
 		i2c6 = &i2c_6;
 		i2c7 = &i2c_7;
 		i2c8 = &i2c_8;
+		csis0 = &csis_0;
+		csis1 = &csis_1;
 	};
 
 	gic:interrupt-controller@10481000 {
@@ -357,4 +359,20 @@
 		reg = <0x14450000 0x10000>;
 		interrupts = <0 94 0>;
 	};
+
+	csis_0: csis@13C20000 {
+		compatible = "samsung,exynos5250-csis";
+		reg = <0x13C20000 0x4000>;
+		interrupts = <0 79 0>;
+		bus-width = <4>;
+		status = "disabled";
+	};
+
+	csis_1: csis@13C30000 {
+		compatible = "samsung,exynos5250-csis";
+		reg = <0x13C30000 0x4000>;
+		interrupts = <0 80 0>;
+		bus-width = <4>;
+		status = "disabled";
+	};
 };
diff --git a/arch/arm/mach-exynos/clock-exynos5.c b/arch/arm/mach-exynos/clock-exynos5.c
index e9d7b80..34a22ff 100644
--- a/arch/arm/mach-exynos/clock-exynos5.c
+++ b/arch/arm/mach-exynos/clock-exynos5.c
@@ -859,6 +859,16 @@ static struct clk exynos5_init_clocks_off[] = {
 		.enable		= exynos5_clk_ip_gscl_ctrl,
 		.ctrlbit	= (1 << 3),
 	}, {
+		.name		= "csis",
+		.devname	= "s5p-mipi-csis.0",
+		.enable		= exynos5_clk_ip_gscl_ctrl,
+		.ctrlbit	= (1 << 5),
+	}, {
+		.name		= "csis",
+		.devname	= "s5p-mipi-csis.1",
+		.enable		= exynos5_clk_ip_gscl_ctrl,
+		.ctrlbit	= (1 << 6),
+	}, {
 		.name		= SYSMMU_CLOCK_NAME,
 		.devname	= SYSMMU_CLOCK_DEVNAME(mfc_l, 0),
 		.enable		= &exynos5_clk_ip_mfc_ctrl,
@@ -1263,9 +1273,10 @@ static struct clksrc_clk exynos5_clksrcs[] = {
 		.reg_div = { .reg = EXYNOS5_CLKDIV_FSYS0, .shift = 20, .size = 4 },
 	}, {
 		.clk	= {
-			.name		= "sclk_gscl_wrap",
+			.name		= "sclk_csis",
 			.devname	= "s5p-mipi-csis.0",
 			.enable		= exynos5_clksrc_mask_gscl_ctrl,
+			.parent		= &exynos5_clk_mout_mpll_user.clk,
 			.ctrlbit	= (1 << 24),
 		},
 		.sources = &exynos5_clkset_group,
@@ -1273,9 +1284,10 @@ static struct clksrc_clk exynos5_clksrcs[] = {
 		.reg_div = { .reg = EXYNOS5_CLKDIV_GSCL, .shift = 24, .size = 4 },
 	}, {
 		.clk	= {
-			.name		= "sclk_gscl_wrap",
+			.name		= "sclk_csis",
 			.devname	= "s5p-mipi-csis.1",
 			.enable		= exynos5_clksrc_mask_gscl_ctrl,
+			.parent		= &exynos5_clk_mout_mpll_user.clk,
 			.ctrlbit	= (1 << 28),
 		},
 		.sources = &exynos5_clkset_group,
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index 1df6abb..c834321 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -177,6 +177,9 @@
 #define EXYNOS4_PA_MIPI_CSIS0		0x11880000
 #define EXYNOS4_PA_MIPI_CSIS1		0x11890000
 
+#define EXYNOS5_PA_MIPI_CSIS0		0x13C20000
+#define EXYNOS5_PA_MIPI_CSIS1		0x13C30000
+
 #define EXYNOS4_PA_FIMD0		0x11C00000
 
 #define EXYNOS4_PA_HSMMC(x)		(0x12510000 + ((x) * 0x10000))
diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
index e99d3d8..c420349 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -104,6 +104,10 @@ static const struct of_dev_auxdata exynos5250_auxdata_lookup[] __initconst = {
 	OF_DEV_AUXDATA("samsung,mfc-v6", 0x11000000, "s5p-mfc-v6", NULL),
 	OF_DEV_AUXDATA("samsung,exynos5250-tmu", 0x10060000,
 				"exynos-tmu", NULL),
+	OF_DEV_AUXDATA("samsung,exynos5250-csis", EXYNOS5_PA_MIPI_CSIS0,
+				"s5p-mipi-csis.0", NULL),
+	OF_DEV_AUXDATA("samsung,exynos5250-csis", EXYNOS5_PA_MIPI_CSIS1,
+				"s5p-mipi-csis.1", NULL),
 	{},
 };
 
-- 
1.7.9.5

