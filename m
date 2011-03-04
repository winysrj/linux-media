Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:62828 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759756Ab1CDPmE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 10:42:04 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 04 Mar 2011 16:41:53 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 5/6] s5pv310: add s5p-tv to platform devices
In-reply-to: <1299253314-10065-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com
Message-id: <1299253314-10065-6-git-send-email-t.stanislaws@samsung.com>
References: <1299253314-10065-1-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>

s5pv310: fix and clean code for TV power
s5pv310: tv: fix clock setup
s5pv310: tv: integrate with Power Domain driver
s5pv310: tv: register fix
s5pv310: tv: add port HDMI_EN1 gpio to regulator api
s5pv310: tv: use hdmiphy as clock
s5pv310: tv: moved TV setup to separete function
s5pv310: hdmi: removed control for clocks and regulators
s5pv310: mixer: removed control for clocks and regulators
---
 arch/arm/mach-s5pv310/Kconfig                   |    5 +
 arch/arm/mach-s5pv310/Makefile                  |    1 +
 arch/arm/mach-s5pv310/clock.c                   |  132 ++++++++++++++++++++++-
 arch/arm/mach-s5pv310/dev-tv.c                  |  103 ++++++++++++++++++
 arch/arm/mach-s5pv310/include/mach/irqs.h       |    4 +
 arch/arm/mach-s5pv310/include/mach/map.h        |   26 +++++
 arch/arm/mach-s5pv310/include/mach/regs-clock.h |    3 +
 arch/arm/mach-s5pv310/include/mach/regs-pmu.h   |    2 +
 arch/arm/plat-samsung/include/plat/devs.h       |    2 +
 9 files changed, 277 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-s5pv310/dev-tv.c

diff --git a/arch/arm/mach-s5pv310/Kconfig b/arch/arm/mach-s5pv310/Kconfig
index 6f83817..4c863850 100644
--- a/arch/arm/mach-s5pv310/Kconfig
+++ b/arch/arm/mach-s5pv310/Kconfig
@@ -20,6 +20,11 @@ config S5PV310_DEV_PD
 	help
 	  Compile in platform device definitions for Power Domain
 
+config S5PV310_DEV_TV
+	bool
+	help
+	  Compile in platform device definition for TV interface
+
 config S5PV310_SETUP_I2C1
 	bool
 	help
diff --git a/arch/arm/mach-s5pv310/Makefile b/arch/arm/mach-s5pv310/Makefile
index 036fb38..a234b80 100644
--- a/arch/arm/mach-s5pv310/Makefile
+++ b/arch/arm/mach-s5pv310/Makefile
@@ -32,6 +32,7 @@ obj-y					+= dev-audio.o
 obj-$(CONFIG_S5PV310_DEV_PD)		+= dev-pd.o
 obj-$(CONFIG_S5PV310_DEV_SYSMMU)	+= dev-sysmmu.o
 
+obj-$(CONFIG_S5PV310_DEV_TV)		+= dev-tv.o
 obj-$(CONFIG_S5PV310_SETUP_I2C1)	+= setup-i2c1.o
 obj-$(CONFIG_S5PV310_SETUP_I2C2)	+= setup-i2c2.o
 obj-$(CONFIG_S5PV310_SETUP_I2C3)	+= setup-i2c3.o
diff --git a/arch/arm/mach-s5pv310/clock.c b/arch/arm/mach-s5pv310/clock.c
index 465beb9..f037be6 100644
--- a/arch/arm/mach-s5pv310/clock.c
+++ b/arch/arm/mach-s5pv310/clock.c
@@ -24,6 +24,7 @@
 
 #include <mach/map.h>
 #include <mach/regs-clock.h>
+#include <mach/regs-pmu.h>
 
 static struct clk clk_sclk_hdmi27m = {
 	.name		= "sclk_hdmi27m",
@@ -82,6 +83,11 @@ static int s5pv310_clksrc_mask_peril1_ctrl(struct clk *clk, int enable)
 	return s5p_gatectrl(S5P_CLKSRC_MASK_PERIL1, clk, enable);
 }
 
+static int s5pv310_clksrc_mask_tv_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(S5P_CLKSRC_MASK_TV, clk, enable);
+}
+
 static int s5pv310_clk_ip_cam_ctrl(struct clk *clk, int enable)
 {
 	return s5p_gatectrl(S5P_CLKGATE_IP_CAM, clk, enable);
@@ -132,6 +138,11 @@ static int s5pv310_clk_ip_tv_ctrl(struct clk *clk, int enable)
 	return s5p_gatectrl(S5P_CLKGATE_IP_TV, clk, enable);
 }
 
+static int s5pv310_clk_hdmiphy_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(S5P_HDMI_PHY_CONTROL, clk, enable);
+}
+
 /* Core list of CMU_CPU side */
 
 static struct clksrc_clk clk_mout_apll = {
@@ -528,6 +539,31 @@ static struct clk init_clocks_off[] = {
 		.enable         = s5pv310_clk_ip_mfc_ctrl,
 		.ctrlbit        = (1 << 0),
 	}, {
+		.name           = "dac",
+		.id             = -1,
+		.enable         = s5pv310_clk_ip_tv_ctrl,
+		.ctrlbit        = (1 << 2),
+	}, {
+		.name           = "mixer",
+		.id             = -1,
+		.enable         = s5pv310_clk_ip_tv_ctrl,
+		.ctrlbit        = (1 << 1),
+	}, {
+		.name           = "vp",
+		.id             = -1,
+		.enable         = s5pv310_clk_ip_tv_ctrl,
+		.ctrlbit        = (1 << 0),
+	}, {
+		.name           = "hdmi",
+		.id             = -1,
+		.enable         = s5pv310_clk_ip_tv_ctrl,
+		.ctrlbit        = (1 << 3),
+	}, {
+		.name		= "hdmiphy",
+		.id		= -1,
+		.enable		= s5pv310_clk_hdmiphy_ctrl,
+		.ctrlbit	= (1 << 0),
+	}, {
 		.name		= "hsmmc",
 		.id		= 0,
 		.parent		= &clk_aclk_133.clk,
@@ -805,6 +841,93 @@ static struct clksrc_sources clkset_mout_g2d = {
 	.nr_sources	= ARRAY_SIZE(clkset_mout_g2d_list),
 };
 
+/* --------------------------------------
+ *         TV subsystem CLOCKS
+ * --------------------------------------
+ */
+
+static struct clk *clkset_sclk_dac_list[] = {
+	[0] = &clk_sclk_vpll.clk,
+	[1] = &clk_sclk_hdmiphy,
+};
+
+static struct clksrc_sources clkset_sclk_dac = {
+	.sources	= clkset_sclk_dac_list,
+	.nr_sources	= ARRAY_SIZE(clkset_sclk_dac_list),
+};
+
+static struct clksrc_clk clk_sclk_dac = {
+	.clk		= {
+		.name		= "sclk_dac",
+		.id		= -1,
+		.enable		= s5pv310_clksrc_mask_tv_ctrl,
+		.ctrlbit	= (1 << 8),
+	},
+	.sources = &clkset_sclk_dac,
+	.reg_src = { .reg = S5P_CLKSRC_TV, .shift = 8, .size = 1 },
+};
+
+static struct clksrc_clk clk_sclk_pixel  = {
+	.clk		= {
+		.name		= "sclk_pixel",
+		.id		= -1,
+		.parent = &clk_sclk_vpll.clk,
+	},
+	.reg_div = { .reg = S5P_CLKDIV_TV, .shift = 0, .size = 4 },
+};
+
+static struct clk *clkset_sclk_hdmi_list[] = {
+	[0] = &clk_sclk_pixel.clk,
+	[1] = &clk_sclk_hdmiphy,
+};
+
+static struct clksrc_sources clkset_sclk_hdmi = {
+	.sources	= clkset_sclk_hdmi_list,
+	.nr_sources	= ARRAY_SIZE(clkset_sclk_hdmi_list),
+};
+
+static struct clksrc_clk clk_sclk_hdmi = {
+	.clk		= {
+		.name		= "sclk_hdmi",
+		.id		= -1,
+		.enable		= s5pv310_clksrc_mask_tv_ctrl,
+		.ctrlbit	= (1 << 0),
+	},
+	.sources = &clkset_sclk_hdmi,
+	.reg_src = { .reg = S5P_CLKSRC_TV, .shift = 0, .size = 1 },
+};
+
+static struct clk *clkset_sclk_mixer_list[] = {
+	[0] = &clk_sclk_dac.clk,
+	[1] = &clk_sclk_hdmi.clk,
+};
+
+static struct clksrc_sources clkset_sclk_mixer = {
+	.sources	= clkset_sclk_mixer_list,
+	.nr_sources	= ARRAY_SIZE(clkset_sclk_mixer_list),
+};
+
+static struct clksrc_clk clk_sclk_mixer = {
+	.clk		= {
+		.name		= "sclk_mixer",
+		.id		= -1,
+		.enable		= s5pv310_clksrc_mask_tv_ctrl,
+		.ctrlbit	= (1 << 4),
+	},
+	.sources = &clkset_sclk_mixer,
+	.reg_src = { .reg = S5P_CLKSRC_TV, .shift = 4, .size = 1 },
+};
+
+static struct clksrc_clk *sclk_tv[] = {
+	&clk_sclk_dac,
+	&clk_sclk_pixel,
+	&clk_sclk_hdmi,
+	&clk_sclk_mixer,
+	NULL,
+};
+
+/* -------------------------------------------- */
+
 static struct clksrc_clk clk_dout_mmc0 = {
 	.clk		= {
 		.name		= "dout_mmc0",
@@ -1223,7 +1346,10 @@ void __init_or_cpufreq s5pv310_setup_clocks(void)
 }
 
 static struct clk *clks[] __initdata = {
-	/* Nothing here yet */
+	&clk_sclk_hdmi27m,
+	&clk_sclk_hdmiphy,
+	&clk_sclk_usbphy0,
+	&clk_sclk_usbphy1,
 };
 
 void __init s5pv310_register_clocks(void)
@@ -1235,6 +1361,10 @@ void __init s5pv310_register_clocks(void)
 	for (ptr = 0; ptr < ARRAY_SIZE(sysclks); ptr++)
 		s3c_register_clksrc(sysclks[ptr], 1);
 
+	/* register TV clocks */
+	for (ptr = 0; sclk_tv[ptr]; ++ptr)
+		s3c_register_clksrc(sclk_tv[ptr], 1);
+
 	s3c_register_clksrc(clksrcs, ARRAY_SIZE(clksrcs));
 	s3c_register_clocks(init_clocks, ARRAY_SIZE(init_clocks));
 
diff --git a/arch/arm/mach-s5pv310/dev-tv.c b/arch/arm/mach-s5pv310/dev-tv.c
new file mode 100644
index 0000000..5a53b97
--- /dev/null
+++ b/arch/arm/mach-s5pv310/dev-tv.c
@@ -0,0 +1,103 @@
+/* linux/arch/arm/mach-s5pv310/dev-tv.c
+ *
+ * Copyright 20i10 Samsung Electronics
+ *      Tomasz Stanislawski <t.stanislaws@samsung.com>
+ *
+ * S5P series device definition for TV device
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include "plat/tv.h"
+
+#include <mach/gpio.h>
+#include <plat/gpio-cfg.h>
+#include <mach/regs-clock.h>
+#include <mach/regs-pmu.h>
+
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/platform_device.h>
+#include <linux/fb.h>
+#include <linux/gfp.h>
+#include <linux/dma-mapping.h>
+#include <linux/clk.h>
+#include <linux/regulator/consumer.h>
+#include <linux/delay.h>
+
+#include <mach/irqs.h>
+#include <mach/map.h>
+
+#include <plat/devs.h>
+#include <plat/cpu.h>
+
+/* HDMI interface */
+static struct resource s5p_hdmi_resources[] = {
+	[0] = {
+		.start  = S5P_PA_HDMI,
+		.end    = S5P_PA_HDMI + S5P_SZ_HDMI - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = IRQ_HDMI,
+		.end    = IRQ_HDMI,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device s5p_device_hdmi = {
+	.name           = "s5p-hdmi",
+	.id             = -1,
+	.num_resources  = ARRAY_SIZE(s5p_hdmi_resources),
+	.resource       = s5p_hdmi_resources,
+};
+EXPORT_SYMBOL(s5p_device_hdmi);
+
+/* MIXER */
+static struct resource s5p_mixer_resources[] = {
+	[0] = {
+		.start  = S5P_PA_MIXER,
+		.end    = S5P_PA_MIXER + S5P_SZ_MIXER - 1,
+		.flags  = IORESOURCE_MEM,
+		.name	= "mxr"
+	},
+	[1] = {
+		.start  = S5P_PA_VP,
+		.end    = S5P_PA_VP + S5P_SZ_VP - 1,
+		.flags  = IORESOURCE_MEM,
+		.name	= "vp"
+	},
+	[2] = {
+		.start  = IRQ_MIXER,
+		.end    = IRQ_MIXER,
+		.flags  = IORESOURCE_IRQ,
+		.name	= "irq"
+	},
+};
+
+static struct mxr_platform_data mxr_pdata;
+
+struct platform_device s5p_device_mixer = {
+	.name           = "s5p-mixer",
+	.id             = -1,
+	.num_resources  = ARRAY_SIZE(s5p_mixer_resources),
+	.resource       = s5p_mixer_resources,
+	.dev		= {
+		.coherent_dma_mask = DMA_BIT_MASK(32),
+		.dma_mask = &s5p_device_mixer.dev.coherent_dma_mask,
+		.platform_data = &mxr_pdata,
+	}
+};
+EXPORT_SYMBOL(s5p_device_mixer);
+
+static struct mxr_platform_output output[] = {
+	{ .output_name = "S5P HDMI connector", .module_name = "s5p-hdmi" },
+};
+
+static struct mxr_platform_data mxr_pdata = {
+	.output = output,
+	.output_cnt = ARRAY_SIZE(output),
+};
+
diff --git a/arch/arm/mach-s5pv310/include/mach/irqs.h b/arch/arm/mach-s5pv310/include/mach/irqs.h
index f7ddc98..f1ec61b 100644
--- a/arch/arm/mach-s5pv310/include/mach/irqs.h
+++ b/arch/arm/mach-s5pv310/include/mach/irqs.h
@@ -121,6 +121,10 @@
 
 #define IRQ_MCT_L1		COMBINER_IRQ(35, 3)
 
+/* Set the default NR_IRQS */
+#define IRQ_MIXER		COMBINER_IRQ(36, 0)
+#define IRQ_TVENC		COMBINER_IRQ(36, 1)
+
 #define IRQ_EINT4		COMBINER_IRQ(37, 0)
 #define IRQ_EINT5		COMBINER_IRQ(37, 1)
 #define IRQ_EINT6		COMBINER_IRQ(37, 2)
diff --git a/arch/arm/mach-s5pv310/include/mach/map.h b/arch/arm/mach-s5pv310/include/mach/map.h
index 0aa0171..7120933 100644
--- a/arch/arm/mach-s5pv310/include/mach/map.h
+++ b/arch/arm/mach-s5pv310/include/mach/map.h
@@ -152,4 +152,30 @@
 
 #define S5P_SZ_UART			SZ_256
 
+/* CEC */
+#define S5PV210_PA_CEC		(0x100B0000)
+#define S5P_PA_CEC		S5PV210_PA_CEC
+#define S5P_SZ_CEC		SZ_4K
+
+/* TVOUT */
+#define S5PV210_PA_TVENC	(0x12C20000)
+#define S5P_PA_TVENC		S5PV210_PA_TVENC
+#define S5P_SZ_TVENC		SZ_64K
+
+#define S5PV210_PA_VP		(0x12C00000)
+#define S5P_PA_VP		S5PV210_PA_VP
+#define S5P_SZ_VP		SZ_64K
+
+#define S5PV210_PA_MIXER	(0x12C10000)
+#define S5P_PA_MIXER		S5PV210_PA_MIXER
+#define S5P_SZ_MIXER		SZ_64K
+
+#define S5PV210_PA_HDMI		(0x12D00000)
+#define S5P_PA_HDMI		S5PV210_PA_HDMI
+#define S5P_SZ_HDMI		SZ_1M
+
+#define S5PV210_I2C_HDMI_PHY	(0x138E0000)
+#define S5P_I2C_HDMI_PHY	S5PV210_I2C_HDMI_PHY
+#define S5P_I2C_HDMI_SZ_PHY	SZ_1K
+
 #endif /* __ASM_ARCH_MAP_H */
diff --git a/arch/arm/mach-s5pv310/include/mach/regs-clock.h b/arch/arm/mach-s5pv310/include/mach/regs-clock.h
index f6b8181..26c7d9b 100644
--- a/arch/arm/mach-s5pv310/include/mach/regs-clock.h
+++ b/arch/arm/mach-s5pv310/include/mach/regs-clock.h
@@ -33,6 +33,7 @@
 #define S5P_CLKSRC_TOP0			S5P_CLKREG(0x0C210)
 #define S5P_CLKSRC_TOP1			S5P_CLKREG(0x0C214)
 #define S5P_CLKSRC_CAM			S5P_CLKREG(0x0C220)
+#define S5P_CLKSRC_TV			S5P_CLKREG(0x0C224)
 #define S5P_CLKSRC_IMAGE		S5P_CLKREG(0x0C230)
 #define S5P_CLKSRC_LCD0			S5P_CLKREG(0x0C234)
 #define S5P_CLKSRC_LCD1			S5P_CLKREG(0x0C238)
@@ -42,6 +43,7 @@
 
 #define S5P_CLKDIV_TOP			S5P_CLKREG(0x0C510)
 #define S5P_CLKDIV_CAM			S5P_CLKREG(0x0C520)
+#define S5P_CLKDIV_TV			S5P_CLKREG(0x0C524)
 #define S5P_CLKDIV_IMAGE		S5P_CLKREG(0x0C530)
 #define S5P_CLKDIV_LCD0			S5P_CLKREG(0x0C534)
 #define S5P_CLKDIV_LCD1			S5P_CLKREG(0x0C538)
@@ -58,6 +60,7 @@
 
 #define S5P_CLKSRC_MASK_TOP		S5P_CLKREG(0x0C310)
 #define S5P_CLKSRC_MASK_CAM		S5P_CLKREG(0x0C320)
+#define S5P_CLKSRC_MASK_TV		S5P_CLKREG(0x0C324)
 #define S5P_CLKSRC_MASK_LCD0		S5P_CLKREG(0x0C334)
 #define S5P_CLKSRC_MASK_LCD1		S5P_CLKREG(0x0C338)
 #define S5P_CLKSRC_MASK_FSYS		S5P_CLKREG(0x0C340)
diff --git a/arch/arm/mach-s5pv310/include/mach/regs-pmu.h b/arch/arm/mach-s5pv310/include/mach/regs-pmu.h
index fb333d0..ea71322 100644
--- a/arch/arm/mach-s5pv310/include/mach/regs-pmu.h
+++ b/arch/arm/mach-s5pv310/include/mach/regs-pmu.h
@@ -27,4 +27,6 @@
 
 #define S5P_INT_LOCAL_PWR_EN		0x7
 
+#define S5P_HDMI_PHY_CONTROL		S5P_PMUREG(0x0700)
+
 #endif /* __ASM_ARCH_REGS_PMU_H */
diff --git a/arch/arm/plat-samsung/include/plat/devs.h b/arch/arm/plat-samsung/include/plat/devs.h
index f14709c..4b87344 100644
--- a/arch/arm/plat-samsung/include/plat/devs.h
+++ b/arch/arm/plat-samsung/include/plat/devs.h
@@ -135,6 +135,8 @@ extern struct platform_device s5p_device_fimc0;
 extern struct platform_device s5p_device_fimc1;
 extern struct platform_device s5p_device_fimc2;
 extern struct platform_device s5p_device_fimc3;
+extern struct platform_device s5p_device_hdmi;
+extern struct platform_device s5p_device_mixer;
 
 extern struct platform_device s5p_device_mfc;
 extern struct platform_device s5p_device_mipi_csis0;
-- 
1.7.1.569.g6f426
