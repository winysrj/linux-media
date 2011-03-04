Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:37628 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759288Ab1CDL0k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 06:26:40 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 04 Mar 2011 12:26:19 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: [RFC/PATCH v7 2/5] MFC: Add MFC 5.1 driver to plat-s5p
In-reply-to: <1299237982-31687-1-git-send-email-k.debski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	k.debski@samsung.com, jaeryul.oh@samsung.com, kgene.kim@samsung.com
Message-id: <1299237982-31687-3-git-send-email-k.debski@samsung.com>
References: <1299237982-31687-1-git-send-email-k.debski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds platform support for Multi Format Codec 5.1.
MFC 5.1 is capable of handling a range of video codecs and this driver
provides V4L2 interface for video decoding.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-s5pv310/clock.c                   |   28 ++++++++++++-
 arch/arm/mach-s5pv310/include/mach/map.h        |    2 +
 arch/arm/mach-s5pv310/include/mach/regs-clock.h |    3 +
 arch/arm/plat-s5p/Kconfig                       |    5 ++
 arch/arm/plat-s5p/Makefile                      |    2 +-
 arch/arm/plat-s5p/dev-mfc.c                     |   49 +++++++++++++++++++++++
 arch/arm/plat-samsung/include/plat/devs.h       |    1 +
 7 files changed, 88 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/plat-s5p/dev-mfc.c

diff --git a/arch/arm/mach-s5pv310/clock.c b/arch/arm/mach-s5pv310/clock.c
index f142b8c..d28fa6f 100644
--- a/arch/arm/mach-s5pv310/clock.c
+++ b/arch/arm/mach-s5pv310/clock.c
@@ -523,6 +523,11 @@ static struct clk init_clocks_off[] = {
 		.enable		= s5pv310_clk_ip_lcd1_ctrl,
 		.ctrlbit	= (1 << 0),
 	}, {
+		.name           = "mfc",
+		.id             = -1,
+		.enable         = s5pv310_clk_ip_mfc_ctrl,
+		.ctrlbit        = (1 << 0),
+	}, {
 		.name		= "hsmmc",
 		.id		= 0,
 		.parent		= &clk_aclk_133.clk,
@@ -734,6 +739,18 @@ static struct clksrc_sources clkset_group = {
 	.nr_sources	= ARRAY_SIZE(clkset_group_list),
 };
 
+static struct clk *clkset_group1_list[] = {
+	[0] = &clk_mout_mpll.clk,
+	[1] = &clk_sclk_apll.clk,
+	[2] = &clk_mout_epll.clk,
+	[3] = &clk_sclk_vpll.clk,
+};
+
+static struct clksrc_sources clkset_group1 = {
+	.sources        = clkset_group1_list,
+	.nr_sources     = ARRAY_SIZE(clkset_group1_list),
+};
+
 static struct clk *clkset_mout_g2d0_list[] = {
 	[0] = &clk_mout_mpll.clk,
 	[1] = &clk_sclk_apll.clk,
@@ -1076,7 +1093,16 @@ static struct clksrc_clk clksrcs[] = {
 			.ctrlbit	= (1 << 16),
 		},
 		.reg_div = { .reg = S5P_CLKDIV_FSYS3, .shift = 8, .size = 8 },
-	}
+	}, {
+		.clk            = {
+			.name           = "sclk_mfc",
+			.id             = -1,
+		},
+		.sources = &clkset_group1,
+		.reg_src = { .reg = S5P_CLKSRC_MFC, .shift = 8, .size = 1 },
+		.reg_div = { .reg = S5P_CLKDIV_MFC, .shift = 0, .size = 4 },
+	},
+
 };
 
 /* Clock initialization code */
diff --git a/arch/arm/mach-s5pv310/include/mach/map.h b/arch/arm/mach-s5pv310/include/mach/map.h
index 0db3a47..576ba55 100644
--- a/arch/arm/mach-s5pv310/include/mach/map.h
+++ b/arch/arm/mach-s5pv310/include/mach/map.h
@@ -29,6 +29,7 @@
 #define S5PV310_PA_FIMC1		0x11810000
 #define S5PV310_PA_FIMC2		0x11820000
 #define S5PV310_PA_FIMC3		0x11830000
+#define S5PV310_PA_MFC			0x13400000
 #define S5PV310_PA_I2S0			0x03830000
 #define S5PV310_PA_I2S1			0xE3100000
 #define S5PV310_PA_I2S2			0xE2A00000
@@ -129,6 +130,7 @@
 #define S5P_PA_FIMC1			S5PV310_PA_FIMC1
 #define S5P_PA_FIMC2			S5PV310_PA_FIMC2
 #define S5P_PA_FIMC3			S5PV310_PA_FIMC3
+#define S5P_PA_MFC			S5PV310_PA_MFC
 #define S5P_PA_ONENAND			S5PC210_PA_ONENAND
 #define S5P_PA_ONENAND_DMA		S5PC210_PA_ONENAND_DMA
 #define S5P_PA_SDRAM			S5PV310_PA_SDRAM
diff --git a/arch/arm/mach-s5pv310/include/mach/regs-clock.h b/arch/arm/mach-s5pv310/include/mach/regs-clock.h
index 9ef5f0c..f6b8181 100644
--- a/arch/arm/mach-s5pv310/include/mach/regs-clock.h
+++ b/arch/arm/mach-s5pv310/include/mach/regs-clock.h
@@ -176,4 +176,7 @@
 
 #define S5P_EPLL_CON			S5P_EPLL_CON0
 
+/* MFC related */
+#define S5P_CLKSRC_MFC			S5P_CLKREG(0x0C228)
+#define S5P_CLKDIV_MFC			S5P_CLKREG(0x0C528)
 #endif /* __ASM_ARCH_REGS_CLOCK_H */
diff --git a/arch/arm/plat-s5p/Kconfig b/arch/arm/plat-s5p/Kconfig
index 4166964..ea9032e 100644
--- a/arch/arm/plat-s5p/Kconfig
+++ b/arch/arm/plat-s5p/Kconfig
@@ -5,6 +5,11 @@
 #
 # Licensed under GPLv2
 
+config S5P_DEV_MFC
+	bool
+	help
+	  Compile in platform device definitions for MFC 
+	  
 config PLAT_S5P
 	bool
 	depends on (ARCH_S5P64X0 || ARCH_S5P6442 || ARCH_S5PC100 || ARCH_S5PV210 || ARCH_S5PV310)
diff --git a/arch/arm/plat-s5p/Makefile b/arch/arm/plat-s5p/Makefile
index cfcd1db..54e330d 100644
--- a/arch/arm/plat-s5p/Makefile
+++ b/arch/arm/plat-s5p/Makefile
@@ -24,7 +24,7 @@ obj-$(CONFIG_SUSPEND)		+= pm.o
 obj-$(CONFIG_SUSPEND)		+= irq-pm.o
 
 # devices
-
+obj-$(CONFIG_S5P_DEV_MFC)	+= dev-mfc.o
 obj-$(CONFIG_S5P_DEV_FIMC0)	+= dev-fimc0.o
 obj-$(CONFIG_S5P_DEV_FIMC1)	+= dev-fimc1.o
 obj-$(CONFIG_S5P_DEV_FIMC2)	+= dev-fimc2.o
diff --git a/arch/arm/plat-s5p/dev-mfc.c b/arch/arm/plat-s5p/dev-mfc.c
new file mode 100644
index 0000000..0dfcb1a
--- /dev/null
+++ b/arch/arm/plat-s5p/dev-mfc.c
@@ -0,0 +1,49 @@
+/* linux/arch/arm/plat-s5p/dev-mfc.c
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Base S5P MFC 5.1 resource and device definitions
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+#include <linux/ioport.h>
+
+#include <mach/map.h>
+#include <plat/devs.h>
+#include <plat/irqs.h>
+
+static struct resource s5p_mfc_resource[] = {
+	[0] = {
+		.start  = S5P_PA_MFC,
+		.end    = S5P_PA_MFC + SZ_64K - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = IRQ_MFC,
+		.end    = IRQ_MFC,
+		.flags  = IORESOURCE_IRQ,
+	}
+};
+
+static u64 s5p_mfc_dma_mask = DMA_BIT_MASK(32);
+
+struct platform_device s5p_device_mfc = {
+	.name          = "s5p-mfc",
+	.id            = -1,
+	.num_resources = ARRAY_SIZE(s5p_mfc_resource),
+	.resource      = s5p_mfc_resource,
+	.dev		= {
+		.dma_mask		= &s5p_mfc_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
+EXPORT_SYMBOL(s5p_device_mfc);
diff --git a/arch/arm/plat-samsung/include/plat/devs.h b/arch/arm/plat-samsung/include/plat/devs.h
index 9f42dee..6a869b8 100644
--- a/arch/arm/plat-samsung/include/plat/devs.h
+++ b/arch/arm/plat-samsung/include/plat/devs.h
@@ -135,6 +135,7 @@ extern struct platform_device s5p_device_fimc1;
 extern struct platform_device s5p_device_fimc2;
 extern struct platform_device s5p_device_fimc3;
 
+extern struct platform_device s5p_device_mfc;
 extern struct platform_device s5p_device_mipi_csis0;
 extern struct platform_device s5p_device_mipi_csis1;
 
-- 
1.6.3.3
