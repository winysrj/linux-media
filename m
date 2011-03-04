Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22339 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab1CDJB3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 04:01:29 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 04 Mar 2011 10:01:08 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 1/7] ARM: S5PV310: Add platform definitions for FIMC
In-reply-to: <1299229274-9753-1-git-send-email-m.szyprowski@samsung.com>
To: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, andrzej.p@samsung.com,
	t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Message-id: <1299229274-9753-2-git-send-email-m.szyprowski@samsung.com>
References: <1299229274-9753-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

Add support for fourth FIMC platform device definition and define
resources for FIMC modules on S5PV310 machines.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/mach-s5pv310/cpu.c                    |    7 ++++
 arch/arm/mach-s5pv310/include/mach/irqs.h      |    4 ++
 arch/arm/mach-s5pv310/include/mach/map.h       |    8 ++++
 arch/arm/plat-s5p/Kconfig                      |    5 +++
 arch/arm/plat-s5p/Makefile                     |    1 +
 arch/arm/plat-s5p/dev-fimc3.c                  |   43 ++++++++++++++++++++++++
 arch/arm/plat-samsung/include/plat/devs.h      |    1 +
 arch/arm/plat-samsung/include/plat/fimc-core.h |    5 +++
 8 files changed, 74 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/plat-s5p/dev-fimc3.c

diff --git a/arch/arm/mach-s5pv310/cpu.c b/arch/arm/mach-s5pv310/cpu.c
index 0db0fb6..0bdb0b0 100644
--- a/arch/arm/mach-s5pv310/cpu.c
+++ b/arch/arm/mach-s5pv310/cpu.c
@@ -21,6 +21,8 @@
 #include <plat/clock.h>
 #include <plat/s5pv310.h>
 #include <plat/sdhci.h>
+#include <plat/devs.h>
+#include <plat/fimc-core.h>
 
 #include <mach/regs-irq.h>
 
@@ -114,6 +116,11 @@ void __init s5pv310_map_io(void)
 	s5pv310_default_sdhci1();
 	s5pv310_default_sdhci2();
 	s5pv310_default_sdhci3();
+
+	s3c_fimc_setname(0, "s5pv310-fimc");
+	s3c_fimc_setname(1, "s5pv310-fimc");
+	s3c_fimc_setname(2, "s5pv310-fimc");
+	s3c_fimc_setname(3, "s5pv310-fimc");
 }
 
 void __init s5pv310_init_clocks(int xtal)
diff --git a/arch/arm/mach-s5pv310/include/mach/irqs.h b/arch/arm/mach-s5pv310/include/mach/irqs.h
index 536b0b5..0e99968 100644
--- a/arch/arm/mach-s5pv310/include/mach/irqs.h
+++ b/arch/arm/mach-s5pv310/include/mach/irqs.h
@@ -107,6 +107,10 @@
 
 #define IRQ_MIPI_CSIS0		COMBINER_IRQ(30, 0)
 #define IRQ_MIPI_CSIS1		COMBINER_IRQ(30, 1)
+#define IRQ_FIMC0		COMBINER_IRQ(32, 0)
+#define IRQ_FIMC1		COMBINER_IRQ(32, 1)
+#define IRQ_FIMC2		COMBINER_IRQ(33, 0)
+#define IRQ_FIMC3		COMBINER_IRQ(33, 1)
 
 #define IRQ_ONENAND_AUDI	COMBINER_IRQ(34, 0)
 
diff --git a/arch/arm/mach-s5pv310/include/mach/map.h b/arch/arm/mach-s5pv310/include/mach/map.h
index 901657f..0db3a47 100644
--- a/arch/arm/mach-s5pv310/include/mach/map.h
+++ b/arch/arm/mach-s5pv310/include/mach/map.h
@@ -25,6 +25,10 @@
 
 #define S5PV310_PA_SYSRAM		0x02025000
 
+#define S5PV310_PA_FIMC0		0x11800000
+#define S5PV310_PA_FIMC1		0x11810000
+#define S5PV310_PA_FIMC2		0x11820000
+#define S5PV310_PA_FIMC3		0x11830000
 #define S5PV310_PA_I2S0			0x03830000
 #define S5PV310_PA_I2S1			0xE3100000
 #define S5PV310_PA_I2S2			0xE2A00000
@@ -121,6 +125,10 @@
 #define S5P_PA_CHIPID			S5PV310_PA_CHIPID
 #define S5P_PA_MIPI_CSIS0		S5PV310_PA_MIPI_CSIS0
 #define S5P_PA_MIPI_CSIS1		S5PV310_PA_MIPI_CSIS1
+#define S5P_PA_FIMC0			S5PV310_PA_FIMC0
+#define S5P_PA_FIMC1			S5PV310_PA_FIMC1
+#define S5P_PA_FIMC2			S5PV310_PA_FIMC2
+#define S5P_PA_FIMC3			S5PV310_PA_FIMC3
 #define S5P_PA_ONENAND			S5PC210_PA_ONENAND
 #define S5P_PA_ONENAND_DMA		S5PC210_PA_ONENAND_DMA
 #define S5P_PA_SDRAM			S5PV310_PA_SDRAM
diff --git a/arch/arm/plat-s5p/Kconfig b/arch/arm/plat-s5p/Kconfig
index 557f8c5..0db2a7a 100644
--- a/arch/arm/plat-s5p/Kconfig
+++ b/arch/arm/plat-s5p/Kconfig
@@ -60,6 +60,11 @@ config S5P_DEV_FIMC2
 	help
 	  Compile in platform device definitions for FIMC controller 2
 
+config S5P_DEV_FIMC3
+	bool
+	help
+	  Compile in platform device definitions for FIMC controller 3
+	  
 config S5P_DEV_ONENAND
 	bool
 	help
diff --git a/arch/arm/plat-s5p/Makefile b/arch/arm/plat-s5p/Makefile
index ce5a0a7..cfcd1db 100644
--- a/arch/arm/plat-s5p/Makefile
+++ b/arch/arm/plat-s5p/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_SUSPEND)		+= irq-pm.o
 obj-$(CONFIG_S5P_DEV_FIMC0)	+= dev-fimc0.o
 obj-$(CONFIG_S5P_DEV_FIMC1)	+= dev-fimc1.o
 obj-$(CONFIG_S5P_DEV_FIMC2)	+= dev-fimc2.o
+obj-$(CONFIG_S5P_DEV_FIMC3)	+= dev-fimc3.o
 obj-$(CONFIG_S5P_DEV_ONENAND)	+= dev-onenand.o
 obj-$(CONFIG_S5P_DEV_CSIS0)	+= dev-csis0.o
 obj-$(CONFIG_S5P_DEV_CSIS1)	+= dev-csis1.o
diff --git a/arch/arm/plat-s5p/dev-fimc3.c b/arch/arm/plat-s5p/dev-fimc3.c
new file mode 100644
index 0000000..ef31bec
--- /dev/null
+++ b/arch/arm/plat-s5p/dev-fimc3.c
@@ -0,0 +1,43 @@
+/* linux/arch/arm/plat-s5p/dev-fimc3.c
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Base S5P FIMC3 resource and device definitions
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/ioport.h>
+#include <mach/map.h>
+
+static struct resource s5p_fimc3_resource[] = {
+	[0] = {
+		.start	= S5P_PA_FIMC3,
+		.end	= S5P_PA_FIMC3 + SZ_4K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= IRQ_FIMC3,
+		.end	= IRQ_FIMC3,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static u64 s5p_fimc3_dma_mask = DMA_BIT_MASK(32);
+
+struct platform_device s5p_device_fimc3 = {
+	.name		= "s5p-fimc",
+	.id		= 3,
+	.num_resources	= ARRAY_SIZE(s5p_fimc3_resource),
+	.resource	= s5p_fimc3_resource,
+	.dev		= {
+		.dma_mask		= &s5p_fimc3_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
diff --git a/arch/arm/plat-samsung/include/plat/devs.h b/arch/arm/plat-samsung/include/plat/devs.h
index b4d208b..b0123f3 100644
--- a/arch/arm/plat-samsung/include/plat/devs.h
+++ b/arch/arm/plat-samsung/include/plat/devs.h
@@ -133,6 +133,7 @@ extern struct platform_device samsung_device_keypad;
 extern struct platform_device s5p_device_fimc0;
 extern struct platform_device s5p_device_fimc1;
 extern struct platform_device s5p_device_fimc2;
+extern struct platform_device s5p_device_fimc3;
 
 extern struct platform_device s5p_device_mipi_csis0;
 extern struct platform_device s5p_device_mipi_csis1;
diff --git a/arch/arm/plat-samsung/include/plat/fimc-core.h b/arch/arm/plat-samsung/include/plat/fimc-core.h
index 81a3bfe..945a99d 100644
--- a/arch/arm/plat-samsung/include/plat/fimc-core.h
+++ b/arch/arm/plat-samsung/include/plat/fimc-core.h
@@ -38,6 +38,11 @@ static inline void s3c_fimc_setname(int id, char *name)
 		s5p_device_fimc2.name = name;
 		break;
 #endif
+#ifdef CONFIG_S5P_DEV_FIMC3
+	case 3:
+		s5p_device_fimc3.name = name;
+		break;
+#endif
 	}
 }
 
-- 
1.7.1.569.g6f426
