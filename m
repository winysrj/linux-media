Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:8636 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab3CHOj5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 09:39:57 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org
Cc: s.nawrocki@samsung.com, kgene.kim@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: [RFC 02/12] exynos-fimc-is: Adding ARCH support for fimc-is
Date: Fri, 08 Mar 2013 09:59:15 -0500
Message-id: <1362754765-2651-3-git-send-email-arun.kk@samsung.com>
In-reply-to: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds new clocks needed for ISP submodules in the camera
subsystem of Exynos5250. Also adds the AUXDATA entry in
mach-exynos5-dt.c.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
---
 arch/arm/mach-exynos/clock-exynos5.c           |  129 ++++++++++++++++++++++++
 arch/arm/mach-exynos/include/mach/map.h        |    2 +
 arch/arm/mach-exynos/include/mach/regs-clock.h |    7 ++
 arch/arm/mach-exynos/mach-exynos5-dt.c         |    2 +
 4 files changed, 140 insertions(+)

diff --git a/arch/arm/mach-exynos/clock-exynos5.c b/arch/arm/mach-exynos/clock-exynos5.c
index 4536515..b2c0825 100644
--- a/arch/arm/mach-exynos/clock-exynos5.c
+++ b/arch/arm/mach-exynos/clock-exynos5.c
@@ -28,6 +28,8 @@
 
 #include "common.h"
 
+#define FIMC_IS_NAME "exynos5-fimc-is"
+
 #ifdef CONFIG_PM_SLEEP
 static struct sleep_save exynos5_clock_save[] = {
 	SAVE_ITEM(EXYNOS5_CLKSRC_MASK_TOP),
@@ -863,6 +865,16 @@ static struct clk exynos5_init_clocks_off[] = {
 		.enable		= exynos5_clk_ip_gscl_ctrl,
 		.ctrlbit	= (1 << 4),
 	}, {
+		.name		= "fimc-is0",
+		.devname	= FIMC_IS_NAME,
+		.enable		= exynos5_clk_ip_isp0_ctrl,
+		.ctrlbit	= (0xFFC << 20) | (0xFF << 0),
+	}, {
+		.name		= "fimc-is1",
+		.devname	= FIMC_IS_NAME,
+		.enable		= exynos5_clk_ip_isp1_ctrl,
+		.ctrlbit	= (0x3 << 12) | (0x7 << 0)
+	}, {
 		.name		= "csis",
 		.devname	= "s5p-mipi-csis.0",
 		.enable		= exynos5_clk_ip_gscl_ctrl,
@@ -1248,6 +1260,107 @@ static struct clksrc_clk exynos5_clk_sclk_fimd1 = {
 	.reg_div = { .reg = EXYNOS5_CLKDIV_DISP1_0, .shift = 0, .size = 4 },
 };
 
+/* For ACLK_400_ISP */
+static struct clksrc_clk exynos5_clk_mout_aclk_400_isp = {
+	.clk    = {
+		.name           = "mout_aclk_400_isp",
+		.parent		= &exynos5_clk_mout_mpll_user.clk,
+	},
+	.sources = &exynos5_clkset_aclk,
+	.reg_src = { .reg = EXYNOS5_CLKSRC_TOP1, .shift = 24, .size = 1 },
+};
+
+static struct clksrc_clk exynos5_clk_dout_aclk_400_isp = {
+	.clk    = {
+		.name           = "dout_aclk_400_isp",
+		.parent         = &exynos5_clk_mout_aclk_400_isp.clk,
+	},
+	.reg_div = { .reg = EXYNOS5_CLKDIV_TOP1, .shift = 20, .size = 3 },
+};
+
+static struct clk *exynos5_clkset_aclk_400_isp_list[] = {
+	[0] = &clk_ext_xtal_mux,
+	[1] = &exynos5_clk_dout_aclk_400_isp.clk,
+};
+
+static struct clksrc_sources exynos5_clkset_aclk_400_isp = {
+	.sources        = exynos5_clkset_aclk_400_isp_list,
+	.nr_sources     = ARRAY_SIZE(exynos5_clkset_aclk_400_isp_list),
+};
+
+static struct clksrc_clk exynos5_clk_aclk_400_isp = {
+	.clk    = {
+		.name           = "aclk_400_isp",
+		.devname	= FIMC_IS_NAME,
+	},
+	.sources = &exynos5_clkset_aclk_400_isp,
+	.reg_src = { .reg = EXYNOS5_CLKSRC_TOP3, .shift = 20, .size = 1 },
+};
+
+static struct clksrc_clk exynos5_clk_aclk_266_isp = {
+	.clk	= {
+		.name		= "aclk_266_isp",
+		.devname	= FIMC_IS_NAME,
+
+	},
+	.sources = &clk_src_gscl_266,
+	.reg_src = { .reg = EXYNOS5_CLKSRC_TOP3, .shift = 16, .size = 1 },
+};
+
+static struct clksrc_clk exynos5_clk_aclk_266_isp_div0 = {
+	.clk	= {
+		.name		= "aclk_266_isp_div0",
+		.devname	= FIMC_IS_NAME,
+		.parent		= &exynos5_clk_aclk_266_isp.clk,
+	},
+	.reg_div = { .reg = EXYNOS5_CLKDIV_ISP0, .shift = 0, .size = 3 },
+};
+
+static struct clksrc_clk exynos5_clk_aclk_266_isp_div1 = {
+	.clk	= {
+		.name		= "aclk_266_isp_div1",
+		.devname	= FIMC_IS_NAME,
+		.parent		= &exynos5_clk_aclk_266_isp.clk,
+	},
+	.reg_div = { .reg = EXYNOS5_CLKDIV_ISP0, .shift = 4, .size = 3 },
+};
+
+static struct clksrc_clk exynos5_clk_aclk_266_isp_divmpwm = {
+	.clk	= {
+		.name		= "aclk_266_isp_divmpwm",
+		.devname	= FIMC_IS_NAME,
+		.parent		= &exynos5_clk_aclk_266_isp_div1.clk,
+	},
+	.reg_div = { .reg = EXYNOS5_CLKDIV_ISP2, .shift = 0, .size = 3 },
+};
+
+static struct clksrc_clk exynos5_clk_aclk_400_isp_div0 = {
+	.clk		= {
+		.name		= "aclk_400_isp_div0",
+		.devname	= FIMC_IS_NAME,
+		.parent		= &exynos5_clk_aclk_400_isp.clk,
+	},
+	.reg_div = { .reg = EXYNOS5_CLKDIV_ISP1, .shift = 0, .size = 3 },
+};
+
+static struct clksrc_clk exynos5_clk_aclk_400_isp_div1 = {
+	.clk		= {
+		.name		= "aclk_400_isp_div1",
+		.devname	= FIMC_IS_NAME,
+		.parent		= &exynos5_clk_aclk_400_isp.clk,
+	},
+	.reg_div = { .reg = EXYNOS5_CLKDIV_ISP1, .shift = 4, .size = 3 },
+};
+
+static struct clksrc_clk exynos5_clk_aclk_266_gscl = {
+	.clk	= {
+		.name		= "aclk_266_gscl",
+		.parent		= &exynos5_clk_aclk_266.clk,
+	},
+	.sources = &clk_src_gscl_266,
+	.reg_src = { .reg = EXYNOS5_CLKSRC_TOP3, .shift = 8, .size = 1 },
+};
+
 static struct clksrc_clk exynos5_clksrcs[] = {
 	{
 		.clk	= {
@@ -1299,6 +1412,15 @@ static struct clksrc_clk exynos5_clksrcs[] = {
 		.reg_div = { .reg = EXYNOS5_CLKDIV_GSCL, .shift = 28, .size = 4 },
 	}, {
 		.clk	= {
+			.name		= "sclk_bayer",
+			.enable		= exynos5_clksrc_mask_gscl_ctrl,
+			.ctrlbit	= (1 << 12),
+		},
+		.sources = &exynos5_clkset_group,
+		.reg_src = { .reg = EXYNOS5_CLKSRC_GSCL, .shift = 12, .size = 4 },
+		.reg_div = { .reg = EXYNOS5_CLKDIV_GSCL, .shift = 12, .size = 4 },
+	}, {
+		.clk	= {
 			.name		= "sclk_cam0",
 			.enable		= exynos5_clksrc_mask_gscl_ctrl,
 			.ctrlbit	= (1 << 16),
@@ -1367,6 +1489,13 @@ static struct clksrc_clk *exynos5_sysclks[] = {
 	&exynos5_clk_mdout_spi1,
 	&exynos5_clk_mdout_spi2,
 	&exynos5_clk_sclk_fimd1,
+	&exynos5_clk_aclk_400_isp,
+	&exynos5_clk_aclk_400_isp_div0,
+	&exynos5_clk_aclk_400_isp_div1,
+	&exynos5_clk_aclk_266_isp,
+	&exynos5_clk_aclk_266_isp_div0,
+	&exynos5_clk_aclk_266_isp_div1,
+	&exynos5_clk_aclk_266_isp_divmpwm,
 };
 
 static struct clk *exynos5_clk_cdev[] = {
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index 5bfc744..64bd07d 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -125,6 +125,8 @@
 #define EXYNOS4_PA_SYSMMU_MFC_L		0x13620000
 #define EXYNOS4_PA_SYSMMU_MFC_R		0x13630000
 
+#define EXYNOS5_PA_FIMC_IS		0x13000000
+
 #define EXYNOS5_PA_FIMC_LITE0           0x13C00000
 #define EXYNOS5_PA_FIMC_LITE1           0x13C10000
 #define EXYNOS5_PA_FIMC_LITE2           0x13C90000
diff --git a/arch/arm/mach-exynos/include/mach/regs-clock.h b/arch/arm/mach-exynos/include/mach/regs-clock.h
index d36ad76..2a09c9f 100644
--- a/arch/arm/mach-exynos/include/mach/regs-clock.h
+++ b/arch/arm/mach-exynos/include/mach/regs-clock.h
@@ -345,6 +345,13 @@
 
 #define EXYNOS5_EPLL_LOCK			EXYNOS_CLKREG(0x10030)
 
+#define EXYNOS5_CLKDIV2_RATIO0                  EXYNOS_CLKREG(0x10590)
+#define EXYNOS5_CLKDIV2_RATIO1                  EXYNOS_CLKREG(0x10594)
+#define EXYNOS5_CLKDIV4_RATIO                   EXYNOS_CLKREG(0x105A0)
+#define EXYNOS5_CLKDIV_ISP0                     EXYNOS_CLKREG(0x0C300)
+#define EXYNOS5_CLKDIV_ISP1                     EXYNOS_CLKREG(0x0C304)
+#define EXYNOS5_CLKDIV_ISP2                     EXYNOS_CLKREG(0x0C308)
+
 #define EXYNOS5_EPLLCON0_LOCKED_SHIFT		(29)
 
 #define PWR_CTRL1_CORE2_DOWN_RATIO		(7 << 28)
diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
index f6c3223..4df9929 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -114,6 +114,8 @@ static const struct of_dev_auxdata exynos5250_auxdata_lookup[] __initconst = {
 				"exynos5-fimc-lite.1", NULL),
 	OF_DEV_AUXDATA("samsung,exynos5250-fimc-lite", EXYNOS5_PA_FIMC_LITE2,
 				"exynos5-fimc-lite.2", NULL),
+	OF_DEV_AUXDATA("samsung,exynos5250-fimc-is", EXYNOS5_PA_FIMC_IS,
+				"exynos5-fimc-is", NULL),
 	{},
 };
 
-- 
1.7.9.5

