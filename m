Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:8421 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab2ICNGy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2012 09:06:54 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org, linux-media@vger.kernel.org
Cc: kgene.kim@samsung.com, k.debski@samsung.com, jtp.park@samsung.com,
	ch.naveen@samsung.com, arun.kk@samsung.com,
	thomas.abraham@linaro.org, kmpark@infradead.org, joshi@samsung.com
Subject: [PATCH v1 1/2] ARM: EXYNOS: Add MFC device tree support
Date: Mon, 03 Sep 2012 22:22:57 +0530
Message-id: <1346691178-29580-2-git-send-email-arun.kk@samsung.com>
In-reply-to: <1346691178-29580-1-git-send-email-arun.kk@samsung.com>
References: <1346691178-29580-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>

This patch adds device tree entry for MFC in the Exynos
machines. Exynos4 SoCs support MFC v5 version and Exynos5 has
MFC v6 version. So making the required changes in the clock
files and adds MFC to the DT device list.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 arch/arm/boot/dts/exynos4210-origen.dts   |    7 +++++++
 arch/arm/boot/dts/exynos4210.dtsi         |    6 ++++++
 arch/arm/boot/dts/exynos5250-smdk5250.dts |    7 +++++++
 arch/arm/boot/dts/exynos5250.dtsi         |    6 ++++++
 arch/arm/mach-exynos/Kconfig              |    2 ++
 arch/arm/mach-exynos/clock-exynos5.c      |    2 +-
 arch/arm/mach-exynos/mach-exynos4-dt.c    |    9 +++++++++
 arch/arm/mach-exynos/mach-exynos5-dt.c    |    9 +++++++++
 8 files changed, 47 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4210-origen.dts b/arch/arm/boot/dts/exynos4210-origen.dts
index 0c49caa..5cf9e93 100644
--- a/arch/arm/boot/dts/exynos4210-origen.dts
+++ b/arch/arm/boot/dts/exynos4210-origen.dts
@@ -146,4 +146,11 @@
 	spi_2: spi@13940000 {
 		status = "disabled";
 	};
+
+	mfc {
+		samsung,mfc-r = <0x43000000>;
+		samsung,mfc-r-size = <8388608>;
+		samsung,mfc-l = <0x51000000>;
+		samsung,mfc-l-size = <8388608>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index 02891fe..5d57348 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -56,6 +56,12 @@
 		interrupts = <0 43 0>;
 	};
 
+	mfc {
+		compatible = "samsung,mfc-v5";
+		reg = <0x13400000 0x10000>;
+		interrupts = <0 94 0>;
+	};
+
 	rtc@10070000 {
 		compatible = "samsung,s3c6410-rtc";
 		reg = <0x10070000 0x100>;
diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index 8a5e348..5824c97 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -109,4 +109,11 @@
 	spi_2: spi@12d40000 {
 		status = "disabled";
 	};
+
+	mfc {
+		samsung,mfc-r = <0x43000000>;
+		samsung,mfc-r-size = <8388608>;
+		samsung,mfc-l = <0x51000000>;
+		samsung,mfc-l-size = <8388608>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 004aaa8..d727b8b 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -58,6 +58,12 @@
 		interrupts = <0 42 0>;
 	};
 
+	mfc {
+		compatible = "samsung,mfc-v6";
+		reg = <0x11000000 0x10000>;
+		interrupts = <0 96 0>;
+	};
+
 	rtc {
 		compatible = "samsung,s3c6410-rtc";
 		reg = <0x101E0000 0x100>;
diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index b5b4c8c..19e8313 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -36,6 +36,7 @@ config CPU_EXYNOS4210
 	select S5P_PM if PM
 	select S5P_SLEEP if PM
 	select PM_GENERIC_DOMAINS
+	select S5P_DEV_MFC
 	help
 	  Enable EXYNOS4210 CPU support
 
@@ -64,6 +65,7 @@ config SOC_EXYNOS5250
 	select SAMSUNG_DMADEV
 	select S5P_PM if PM
 	select S5P_SLEEP if PM
+	select S5P_DEV_MFC
 	help
 	  Enable EXYNOS5250 SoC support
 
diff --git a/arch/arm/mach-exynos/clock-exynos5.c b/arch/arm/mach-exynos/clock-exynos5.c
index 774533c..480c251 100644
--- a/arch/arm/mach-exynos/clock-exynos5.c
+++ b/arch/arm/mach-exynos/clock-exynos5.c
@@ -612,7 +612,7 @@ static struct clk exynos5_init_clocks_off[] = {
 		.ctrlbit	= (1 << 25),
 	}, {
 		.name		= "mfc",
-		.devname	= "s5p-mfc",
+		.devname	= "s5p-mfc-v6",
 		.enable		= exynos5_clk_ip_mfc_ctrl,
 		.ctrlbit	= (1 << 0),
 	}, {
diff --git a/arch/arm/mach-exynos/mach-exynos4-dt.c b/arch/arm/mach-exynos/mach-exynos4-dt.c
index b2b5d5f..44bcfa4 100644
--- a/arch/arm/mach-exynos/mach-exynos4-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos4-dt.c
@@ -13,6 +13,7 @@
 
 #include <linux/of_platform.h>
 #include <linux/serial_core.h>
+#include <linux/memblock.h>
 
 #include <asm/mach/arch.h>
 #include <asm/hardware/gic.h>
@@ -20,6 +21,7 @@
 
 #include <plat/cpu.h>
 #include <plat/regs-serial.h>
+#include <plat/mfc.h>
 
 #include "common.h"
 
@@ -63,6 +65,7 @@ static const struct of_dev_auxdata exynos4210_auxdata_lookup[] __initconst = {
 				"exynos4210-spi.2", NULL),
 	OF_DEV_AUXDATA("arm,pl330", EXYNOS4_PA_PDMA0, "dma-pl330.0", NULL),
 	OF_DEV_AUXDATA("arm,pl330", EXYNOS4_PA_PDMA1, "dma-pl330.1", NULL),
+	OF_DEV_AUXDATA("samsung,mfc-v5", 0x13400000, "s5p-mfc", NULL),
 	{},
 };
 
@@ -83,6 +86,11 @@ static char const *exynos4210_dt_compat[] __initdata = {
 	NULL
 };
 
+static void __init exynos4_reserve(void)
+{
+	s5p_mfc_reserve_mem(0x43000000, 8 << 20, 0x51000000, 8 << 20);
+}
+
 DT_MACHINE_START(EXYNOS4210_DT, "Samsung Exynos4 (Flattened Device Tree)")
 	/* Maintainer: Thomas Abraham <thomas.abraham@linaro.org> */
 	.init_irq	= exynos4_init_irq,
@@ -93,4 +101,5 @@ DT_MACHINE_START(EXYNOS4210_DT, "Samsung Exynos4 (Flattened Device Tree)")
 	.timer		= &exynos4_timer,
 	.dt_compat	= exynos4210_dt_compat,
 	.restart        = exynos4_restart,
+	.reserve	= exynos4_reserve,
 MACHINE_END
diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
index ef770bc..e258db4 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -11,6 +11,7 @@
 
 #include <linux/of_platform.h>
 #include <linux/serial_core.h>
+#include <linux/memblock.h>
 
 #include <asm/mach/arch.h>
 #include <asm/hardware/gic.h>
@@ -18,6 +19,7 @@
 
 #include <plat/cpu.h>
 #include <plat/regs-serial.h>
+#include <plat/mfc.h>
 
 #include "common.h"
 
@@ -56,6 +58,7 @@ static const struct of_dev_auxdata exynos5250_auxdata_lookup[] __initconst = {
 	OF_DEV_AUXDATA("arm,pl330", EXYNOS5_PA_PDMA0, "dma-pl330.0", NULL),
 	OF_DEV_AUXDATA("arm,pl330", EXYNOS5_PA_PDMA1, "dma-pl330.1", NULL),
 	OF_DEV_AUXDATA("arm,pl330", EXYNOS5_PA_MDMA1, "dma-pl330.2", NULL),
+	OF_DEV_AUXDATA("samsung,mfc-v6", 0x11000000, "s5p-mfc-v6", NULL),
 	{},
 };
 
@@ -76,6 +79,11 @@ static char const *exynos5250_dt_compat[] __initdata = {
 	NULL
 };
 
+static void __init exynos5_reserve(void)
+{
+	s5p_mfc_reserve_mem(0x43000000, 8 << 20, 0x51000000, 8 << 20);
+}
+
 DT_MACHINE_START(EXYNOS5_DT, "SAMSUNG EXYNOS5 (Flattened Device Tree)")
 	/* Maintainer: Kukjin Kim <kgene.kim@samsung.com> */
 	.init_irq	= exynos5_init_irq,
@@ -86,4 +94,5 @@ DT_MACHINE_START(EXYNOS5_DT, "SAMSUNG EXYNOS5 (Flattened Device Tree)")
 	.timer		= &exynos4_timer,
 	.dt_compat	= exynos5250_dt_compat,
 	.restart        = exynos5_restart,
+	.reserve	= exynos5_reserve,
 MACHINE_END
-- 
1.7.0.4

