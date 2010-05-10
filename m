Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47143 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab0EJP4J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 May 2010 11:56:09 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 10 May 2010 17:55:48 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 1/3] ARM: Samsung S5P: Add FIMC driver register definition
 and platform helpers
In-reply-to: <1273506950-25920-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, ben-linux@fluff.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1273506950-25920-2-git-send-email-s.nawrocki@samsung.com>
References: <1273506950-25920-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	FIMC device is a camera interface embedded in S5P Samsung SOC
	series. It supports ITU-R BT.601/656 and MIPI(CSI) standards,
	memory to memory operations, color conversion, resizing and rotation.
	On most of the SOCs there are multiple FIMC entities available which
	can be deployed in camera capture/preview or video encoding chains.

        Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
        Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
        Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/mach-s5pv210/Kconfig              |   22 ++
 arch/arm/mach-s5pv210/Makefile             |    4 +
 arch/arm/mach-s5pv210/clock.c              |   30 +++
 arch/arm/mach-s5pv210/include/mach/map.h   |    8 +
 arch/arm/mach-s5pv210/setup-fimc0.c        |   27 +++
 arch/arm/mach-s5pv210/setup-fimc1.c        |   27 +++
 arch/arm/mach-s5pv210/setup-fimc2.c        |   27 +++
 arch/arm/plat-s5p/Kconfig                  |   17 ++
 arch/arm/plat-s5p/Makefile                 |    8 +
 arch/arm/plat-s5p/dev-fimc0.c              |   57 +++++
 arch/arm/plat-s5p/dev-fimc1.c              |   56 +++++
 arch/arm/plat-s5p/dev-fimc2.c              |   56 +++++
 arch/arm/plat-s5p/include/plat/fimc.h      |   52 +++++
 arch/arm/plat-s5p/include/plat/irqs.h      |    4 +
 arch/arm/plat-s5p/include/plat/regs-fimc.h |  339 ++++++++++++++++++++++++++++
 15 files changed, 734 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-s5pv210/setup-fimc0.c
 create mode 100644 arch/arm/mach-s5pv210/setup-fimc1.c
 create mode 100644 arch/arm/mach-s5pv210/setup-fimc2.c
 create mode 100644 arch/arm/plat-s5p/dev-fimc0.c
 create mode 100644 arch/arm/plat-s5p/dev-fimc1.c
 create mode 100644 arch/arm/plat-s5p/dev-fimc2.c
 create mode 100644 arch/arm/plat-s5p/include/plat/fimc.h
 create mode 100644 arch/arm/plat-s5p/include/plat/regs-fimc.h

diff --git a/arch/arm/mach-s5pv210/Kconfig b/arch/arm/mach-s5pv210/Kconfig
index 3048a21..f65c698 100644
--- a/arch/arm/mach-s5pv210/Kconfig
+++ b/arch/arm/mach-s5pv210/Kconfig
@@ -49,6 +49,22 @@ config S5PC110_DEV_ONENAND
 	help
 	  Compile in platform device definition for OneNAND1 controller
 
+config S5PV210_SETUP_FIMC0
+	bool
+	help
+	  Setup code for FIMC controller 0
+
+config S5PV210_SETUP_FIMC1
+	bool
+	help
+	  Setup code for FIMC controller 1
+
+config S5PV210_SETUP_FIMC2
+	bool
+	help
+	  Setup code for FIMC controller 2
+
+
 config MACH_SMDKV210
 	bool "SMDKV210"
 	select CPU_S5PV210
@@ -77,6 +93,12 @@ config MACH_AQUILA
 	select S3C_DEV_HSMMC2
 	select S3C_DEV_RTC
 	select S3C_DEV_USB_HS_UDC
+	select S5P_DEV_FIMC0
+	select S5PV210_SETUP_FIMC0
+	select S5P_DEV_FIMC1
+	select S5PV210_SETUP_FIMC1
+	select S5P_DEV_FIMC2
+	select S5PV210_SETUP_FIMC2
 	help
 	  Machine support for the Samsung Aquila target based on S5PC110 SoC
 
diff --git a/arch/arm/mach-s5pv210/Makefile b/arch/arm/mach-s5pv210/Makefile
index 91323e9..da545a6 100644
--- a/arch/arm/mach-s5pv210/Makefile
+++ b/arch/arm/mach-s5pv210/Makefile
@@ -25,6 +25,10 @@ obj-$(CONFIG_S5PV210_SETUP_SDHCI_GPIO)	+= setup-sdhci-gpio.o
 
 obj-$(CONFIG_S5PC110_DEV_ONENAND)	+= dev-onenand.o
 
+obj-$(CONFIG_S5PV210_SETUP_FIMC0)	+= setup-fimc0.o
+obj-$(CONFIG_S5PV210_SETUP_FIMC1)	+= setup-fimc1.o
+obj-$(CONFIG_S5PV210_SETUP_FIMC2)	+= setup-fimc2.o
+
 # machine support
 
 obj-$(CONFIG_MACH_SMDKV210)	+= mach-smdkv210.o
diff --git a/arch/arm/mach-s5pv210/clock.c b/arch/arm/mach-s5pv210/clock.c
index f1e2b9d..ceb9af8 100644
--- a/arch/arm/mach-s5pv210/clock.c
+++ b/arch/arm/mach-s5pv210/clock.c
@@ -361,6 +361,36 @@ static struct clksrc_clk clksrcs[] = {
 		.sources = &clkset_default,
 		.reg_src = { .reg = S5P_CLK_SRC4, .shift = 16, .size = 4 },
 		.reg_div = { .reg = S5P_CLK_DIV4, .shift = 16, .size = 4 },
+	}, {
+		.clk	= {
+			.name		= "fimc",
+			.id		= 0,
+			.ctrlbit	= (1<<24),
+			.enable		= s5pv210_clk_ip0_ctrl,
+		},
+		.sources = &clkset_default,
+		.reg_src = { .reg = S5P_CLK_SRC3, .shift = 12, .size = 4, },
+		.reg_div = { .reg = S5P_CLK_DIV3, .shift = 12, .size = 4, },
+	}, {
+		.clk	= {
+			.name		= "fimc",
+			.id		= 1,
+			.ctrlbit	= (1<<25),
+			.enable		= s5pv210_clk_ip0_ctrl,
+		},
+		.sources = &clkset_default,
+		.reg_div = { .reg = S5P_CLK_DIV3, .shift = 16, .size = 4, },
+		.reg_src = { .reg = S5P_CLK_SRC3, .shift = 16, .size = 4, },
+	}, {
+		.clk	= {
+			.name		= "fimc",
+			.id		= 2,
+			.ctrlbit	= (1<<26),
+			.enable		= s5pv210_clk_ip0_ctrl,
+		},
+		.sources = &clkset_default,
+		.reg_div = { .reg = S5P_CLK_DIV3, .shift = 20, .size = 4, },
+		.reg_src = { .reg = S5P_CLK_SRC3, .shift = 20, .size = 4, },
 	}
 };
 
diff --git a/arch/arm/mach-s5pv210/include/mach/map.h b/arch/arm/mach-s5pv210/include/mach/map.h
index e785e7b..71ec1c0 100644
--- a/arch/arm/mach-s5pv210/include/mach/map.h
+++ b/arch/arm/mach-s5pv210/include/mach/map.h
@@ -81,6 +81,11 @@
 #define S5PV210_PA_USB_HSOTG	(0xEC000000)
 #define S5PV210_PA_USB_HSPHY	(0xEC100000)
 
+/* FIMC */
+#define S5PV210_PA_FIMC0	(0xFB200000)
+#define S5PV210_PA_FIMC1	(0xFB300000)
+#define S5PV210_PA_FIMC2	(0xFB400000)
+
 /* compatibiltiy defines. */
 #define S3C_PA_UART		S5PV210_PA_UART
 #define S3C_PA_HSMMC0		S5PV210_PA_HSMMC0
@@ -93,5 +98,8 @@
 #define S3C_PA_USB_HSOTG	S5PV210_PA_USB_HSOTG
 #define S3C_PA_USB_HSPHY	S5PV210_PA_USB_HSPHY
 #define S3C_PA_RTC		S5PV210_PA_RTC
+#define S5P_PA_FIMC0		S5PV210_PA_FIMC0
+#define S5P_PA_FIMC1		S5PV210_PA_FIMC1
+#define S5P_PA_FIMC2		S5PV210_PA_FIMC2
 
 #endif /* __ASM_ARCH_MAP_H */
diff --git a/arch/arm/mach-s5pv210/setup-fimc0.c b/arch/arm/mach-s5pv210/setup-fimc0.c
new file mode 100644
index 0000000..e539c61
--- /dev/null
+++ b/arch/arm/mach-s5pv210/setup-fimc0.c
@@ -0,0 +1,27 @@
+/* linux/arch/arm/mach-s5pv210/setup-fimc0.c
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * S5PV210 - setup and capabilities definitions for S5P FIMC device 0
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <plat/fimc.h>
+
+struct s5p_platform_fimc s5p_fimc0_default_data __initdata = {
+	.srclk_name	= "mout_epll",
+	.clockrate	= 133000000,
+	.capability	= S5P_FIMC_IN_ROT | S5P_FIMC_OUT_ROT,
+	/* scaler input pixel size constraints */
+	.scaler_en_w	= 4224,
+	.scaler_dis_w	= 8192,
+	/* input rotator limits for (input) image pixel size */
+	.in_rot_en_h	= 1920,
+	.in_rot_dis_w	= 8192,
+	/* output rotator limits for (output) image pixel size */
+	.out_rot_en_w	= 1920,
+	.out_rot_dis_w	= 4224
+};
diff --git a/arch/arm/mach-s5pv210/setup-fimc1.c b/arch/arm/mach-s5pv210/setup-fimc1.c
new file mode 100644
index 0000000..badca6e
--- /dev/null
+++ b/arch/arm/mach-s5pv210/setup-fimc1.c
@@ -0,0 +1,27 @@
+/* linux/arch/arm/mach-s5pv210/setup-fimc1.c
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * S5PV210 - setup and capabilities definitions for S5P FIMC device 1
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <plat/fimc.h>
+
+struct s5p_platform_fimc s5p_fimc1_default_data __initdata = {
+	.srclk_name	= "mout_epll",
+	.clockrate	= 133000000,
+	.capability	= S5P_FIMC_IN_ROT | S5P_FIMC_OUT_ROT,
+	/* scaler input pixel size constraints */
+	.scaler_en_w	= 4224,
+	.scaler_dis_w	= 8192,
+	/* input rotator limits for (input) image pixel size */
+	.in_rot_en_h	= 1920,
+	.in_rot_dis_w	= 8192,
+	/* output rotator limits for (output) image pixel size */
+	.out_rot_en_w	= 1920,
+	.out_rot_dis_w	= 4224
+};
diff --git a/arch/arm/mach-s5pv210/setup-fimc2.c b/arch/arm/mach-s5pv210/setup-fimc2.c
new file mode 100644
index 0000000..374d946
--- /dev/null
+++ b/arch/arm/mach-s5pv210/setup-fimc2.c
@@ -0,0 +1,27 @@
+/* linux/arch/arm/mach-s5pv210/setup-fimc2.c
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * S5PV210 - setup and capabilities definitions for S5P FIMC device 2
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <plat/fimc.h>
+
+struct s5p_platform_fimc s5p_fimc2_default_data __initdata = {
+	.srclk_name	= "mout_epll",
+	.clockrate	= 133000000,
+	.capability	= S5P_FIMC_IN_ROT | S5P_FIMC_OUT_ROT,
+	/* scaler input pixel size constraints */
+	.scaler_en_w	= 1920,
+	.scaler_dis_w	= 8192,
+	/* input rotator limits for (input) image pixel size */
+	.in_rot_en_h	= 1280,
+	.in_rot_dis_w	= 8192,
+	/* output rotator limits for (output) image pixel size */
+	.out_rot_en_w	= 1280,
+	.out_rot_dis_w	= 1920
+};
diff --git a/arch/arm/plat-s5p/Kconfig b/arch/arm/plat-s5p/Kconfig
index 9f4ebc8..ade982e 100644
--- a/arch/arm/plat-s5p/Kconfig
+++ b/arch/arm/plat-s5p/Kconfig
@@ -5,6 +5,23 @@
 #
 # Licensed under GPLv2
 
+
+config S5P_DEV_FIMC0
+	bool
+	help
+	  Compile in platform device definitions for FIMC controller 0
+
+config S5P_DEV_FIMC1
+	bool
+	help
+	  Compile in platform device definitions for FIMC controller 1
+
+config S5P_DEV_FIMC2
+	bool
+	help
+	  Compile in platform device definitions for FIMC controller 2
+
+
 config PLAT_S5P
 	bool
 	depends on (ARCH_S5P6440 || ARCH_S5P6442 || ARCH_S5PC100 || ARCH_S5PV210)
diff --git a/arch/arm/plat-s5p/Makefile b/arch/arm/plat-s5p/Makefile
index 649b21f..ac8dfe2 100644
--- a/arch/arm/plat-s5p/Makefile
+++ b/arch/arm/plat-s5p/Makefile
@@ -23,3 +23,11 @@ obj-$(CONFIG_SYSTIMER_S5P)	+= systimer-s5p.o
 
 # obj-$(CONFIG_CPU_FREQ)	+= s5pc110-cpufreq.o
 obj-$(CONFIG_PM)		+= sleep.o
+obj-$(CONFIG_S5P_DEV_FIMC2)	+= dev-fimc2.o
+
+# Helper and device support
+
+obj-$(CONFIG_S5P_DEV_FIMC0)	+= dev-fimc0.o
+obj-$(CONFIG_S5P_DEV_FIMC1)	+= dev-fimc1.o
+obj-$(CONFIG_S5P_DEV_FIMC2)	+= dev-fimc2.o
+
diff --git a/arch/arm/plat-s5p/dev-fimc0.c b/arch/arm/plat-s5p/dev-fimc0.c
new file mode 100644
index 0000000..d5a17b2
--- /dev/null
+++ b/arch/arm/plat-s5p/dev-fimc0.c
@@ -0,0 +1,57 @@
+/* linux/arch/arm/plat-s5p/dev-fimc0.c
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Base S5P FIMC0 resource and device definitions
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/platform_device.h>
+#include <mach/map.h>
+#include <plat/fimc.h>
+#include <plat/devs.h>
+#include <plat/cpu.h>
+#include <plat/irqs.h>
+
+
+static struct resource s5p_fimc_resource[] = {
+	[0] = {
+		.start	= S5P_PA_FIMC0,
+		.end	= S5P_PA_FIMC0 + SZ_1M - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= IRQ_FIMC0,
+		.end	= IRQ_FIMC0,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device s5p_device_fimc0 = {
+	.name		= "s5p-fimc",
+	.id		= 0,
+	.num_resources	= ARRAY_SIZE(s5p_fimc_resource),
+	.resource	= s5p_fimc_resource,
+};
+
+
+void __init s5p_fimc0_set_platdata(struct s5p_platform_fimc *pd)
+{
+	struct s5p_platform_fimc *npd;
+
+	if (!pd)
+		pd = &s5p_fimc0_default_data;
+
+	npd = kmemdup(pd, sizeof(*npd), GFP_KERNEL);
+	if (!npd)
+		printk(KERN_ERR "%s: platform_data allocation failed\n",
+			__func__);
+
+	s5p_device_fimc0.dev.platform_data = npd;
+}
+
diff --git a/arch/arm/plat-s5p/dev-fimc1.c b/arch/arm/plat-s5p/dev-fimc1.c
new file mode 100644
index 0000000..21419a4
--- /dev/null
+++ b/arch/arm/plat-s5p/dev-fimc1.c
@@ -0,0 +1,56 @@
+/* linux/arch/arm/plat-s5p/dev-fimc1.c
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Base S5P FIMC1 resource and device definitions
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/platform_device.h>
+#include <mach/map.h>
+#include <plat/fimc.h>
+#include <plat/devs.h>
+#include <plat/cpu.h>
+#include <plat/irqs.h>
+
+
+static struct resource s5p_fimc_resource[] = {
+	[0] = {
+		.start	= S5P_PA_FIMC1,
+		.end	= S5P_PA_FIMC1 + SZ_1M - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= IRQ_FIMC1,
+		.end	= IRQ_FIMC1,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device s5p_device_fimc1 = {
+	.name		= "s5p-fimc",
+	.id		= 1,
+	.num_resources	= ARRAY_SIZE(s5p_fimc_resource),
+	.resource	= s5p_fimc_resource,
+};
+
+void __init s5p_fimc1_set_platdata(struct s5p_platform_fimc *pd)
+{
+	struct s5p_platform_fimc *npd;
+
+	if (!pd)
+		pd = &s5p_fimc1_default_data;
+
+	npd = kmemdup(pd, sizeof(*npd), GFP_KERNEL);
+	if (!npd)
+		printk(KERN_ERR "%s: platform_data allocation failed\n",
+			__func__);
+
+	s5p_device_fimc1.dev.platform_data = npd;
+}
+
diff --git a/arch/arm/plat-s5p/dev-fimc2.c b/arch/arm/plat-s5p/dev-fimc2.c
new file mode 100644
index 0000000..a363805
--- /dev/null
+++ b/arch/arm/plat-s5p/dev-fimc2.c
@@ -0,0 +1,56 @@
+/* linux/arch/arm/plat-s5p/dev-fimc2.c
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Base S5P FIMC2 resource and device definitions
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/platform_device.h>
+#include <mach/map.h>
+#include <plat/fimc.h>
+#include <plat/devs.h>
+#include <plat/cpu.h>
+#include <plat/irqs.h>
+
+
+static struct resource s5p_fimc_resource[] = {
+	[0] = {
+		.start	= S5P_PA_FIMC2,
+		.end	= S5P_PA_FIMC2 + SZ_1M - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= IRQ_FIMC2,
+		.end	= IRQ_FIMC2,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device s5p_device_fimc2 = {
+	.name		= "s5p-fimc",
+	.id		= 2,
+	.num_resources	= ARRAY_SIZE(s5p_fimc_resource),
+	.resource	= s5p_fimc_resource,
+};
+
+void __init s5p_fimc2_set_platdata(struct s5p_platform_fimc *pd)
+{
+	struct s5p_platform_fimc *npd;
+
+	if (!pd)
+		pd = &s5p_fimc2_default_data;
+
+	npd = kmemdup(pd, sizeof(*npd), GFP_KERNEL);
+	if (!npd)
+		printk(KERN_ERR "%s: platform_data allocation failed\n",
+			__func__);
+
+	s5p_device_fimc2.dev.platform_data = npd;
+}
+
diff --git a/arch/arm/plat-s5p/include/plat/fimc.h b/arch/arm/plat-s5p/include/plat/fimc.h
new file mode 100644
index 0000000..f360f6d
--- /dev/null
+++ b/arch/arm/plat-s5p/include/plat/fimc.h
@@ -0,0 +1,52 @@
+/* linux/arch/arm/plat-s5p/include/plat/fimc.h
+ *
+ * Platform header file for FIMC driver
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Sylwester Nawrocki, <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef FIMC_H_
+#define FIMC_H_
+
+#include <linux/platform_device.h>
+
+
+extern struct platform_device s5p_device_fimc0;
+extern struct platform_device s5p_device_fimc1;
+extern struct platform_device s5p_device_fimc2;
+
+struct s5p_platform_fimc {
+	char		srclk_name[16];
+	u32		clockrate;
+
+/* Input and output rotator availability */
+#define S5P_FIMC_IN_ROT    (1 << 0)
+#define S5P_FIMC_OUT_ROT   (1 << 1)
+	u32             capability;
+	/* scaler input pixel size constraints */
+	u16		scaler_en_w;
+	u16		scaler_dis_w;
+	/* input rotator limits for (input) image pixel size */
+	u16		in_rot_en_h;
+	u16		in_rot_dis_w;
+	/* output rotator limits for (output) image pixel size */
+	u16		out_rot_en_w;
+	u16		out_rot_dis_w;
+};
+
+extern struct s5p_platform_fimc s5p_fimc0_default_data;
+extern struct s5p_platform_fimc s5p_fimc1_default_data;
+extern struct s5p_platform_fimc s5p_fimc2_default_data;
+
+extern void s5p_fimc0_set_platdata(struct s5p_platform_fimc *fimc);
+extern void s5p_fimc1_set_platdata(struct s5p_platform_fimc *fimc);
+extern void s5p_fimc2_set_platdata(struct s5p_platform_fimc *fimc);
+
+#endif /* FIMC_H_ */
+
diff --git a/arch/arm/plat-s5p/include/plat/irqs.h b/arch/arm/plat-s5p/include/plat/irqs.h
index 9ff3d71..ead3cad 100644
--- a/arch/arm/plat-s5p/include/plat/irqs.h
+++ b/arch/arm/plat-s5p/include/plat/irqs.h
@@ -87,4 +87,8 @@
 #define IRQ_TIMER3		S5P_TIMER_IRQ(3)
 #define IRQ_TIMER4		S5P_TIMER_IRQ(4)
 
+#define IRQ_FIMC0		S5P_IRQ_VIC2(5)
+#define IRQ_FIMC1		S5P_IRQ_VIC2(6)
+#define IRQ_FIMC2		S5P_IRQ_VIC2(7)
+
 #endif /* __ASM_PLAT_S5P_IRQS_H */
diff --git a/arch/arm/plat-s5p/include/plat/regs-fimc.h b/arch/arm/plat-s5p/include/plat/regs-fimc.h
new file mode 100644
index 0000000..82d2db1
--- /dev/null
+++ b/arch/arm/plat-s5p/include/plat/regs-fimc.h
@@ -0,0 +1,339 @@
+/* arch/arm/plat-s5p/include/plat/regs-fimc.h
+ *
+ * Register definition file for Samsung Camera Interface (FIMC) driver
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef REGS_FIMC_H_
+#define REGS_FIMC_H_
+
+#define S5P_CIOYSA(__x)				(0x18 + (__x) * 4)
+#define S5P_CIOCBSA(__x)			(0x28 + (__x) * 4)
+#define S5P_CIOCRSA(__x)			(0x38 + (__x) * 4)
+
+/* Input source format */
+#define S5P_CISRCFMT				0x00
+/* Window offset */
+#define S5P_CIWDOFST				0x04
+/* Global control */
+#define S5P_CIGCTRL				0x08
+/* Window offset 2 */
+#define S5P_CIWDOFST2				0x14
+/* Output DMA Y 1st frame start address */
+#define S5P_CIOYSA1				0x18
+/* Output DMA Y 2nd frame start address */
+#define S5P_CIOYSA2				0x1c
+/* Output DMA Y 3rd frame start address */
+#define S5P_CIOYSA3				0x20
+/* Output DMA Y 4th frame start address */
+#define S5P_CIOYSA4				0x24
+/* Output DMA Cb 1st frame start address */
+#define S5P_CIOCBSA1				0x28
+/* Output DMA Cb 2nd frame start address */
+#define S5P_CIOCBSA2				0x2c
+/* Output DMA Cb 3rd frame start address */
+#define S5P_CIOCBSA3				0x30
+/* Output DMA Cb 4th frame start address */
+#define S5P_CIOCBSA4				0x34
+/* Output DMA Cr 1st frame start address */
+#define S5P_CIOCRSA1				0x38
+/* Output DMA Cr 2nd frame start address */
+#define S5P_CIOCRSA2				0x3c
+/* Output DMA Cr 3rd frame start address */
+#define S5P_CIOCRSA3				0x40
+/* Output DMA Cr 4th frame start address */
+#define S5P_CIOCRSA4				0x44
+/* Target image format */
+#define S5P_CITRGFMT				0x48
+/* Output DMA control */
+#define S5P_CIOCTRL				0x4c
+/* Pre-scaler control 1 */
+#define S5P_CISCPRERATIO			0x50
+/* Pre-scaler control 2 */
+#define S5P_CISCPREDST				0x54
+/* Main scaler control */
+#define S5P_CISCCTRL				0x58
+/* Target area */
+#define S5P_CITAREA				0x5c
+/* Status */
+#define S5P_CISTATUS				0x64
+/* Image capture enable command */
+#define S5P_CIIMGCPT				0xc0
+/* Capture sequence */
+#define S5P_CICPTSEQ				0xc4
+/* Image effects */
+#define S5P_CIIMGEFF				0xd0
+/* Y frame start address for input DMA */
+#define S5P_CIIYSA0				0xd4
+/* Cb frame start address for input DMA */
+#define S5P_CIICBSA0				0xd8
+/* Cr frame start address for input DMA */
+#define S5P_CIICRSA0				0xdc
+/* Real input DMA image size */
+#define S5P_CIREAL_ISIZE			0xf8
+/* Input DMA control */
+#define S5P_MSCTRL				0xfc
+/* Output DMA Y offset */
+#define S5P_CIOYOFF				0x168
+/* Output DMA CB offset */
+#define S5P_CIOCBOFF				0x16c
+/* Output DMA CR offset */
+#define S5P_CIOCROFF				0x170
+/* Input DMA Y offset */
+#define S5P_CIIYOFF				0x174
+/* Input DMA CB offset */
+#define S5P_CIICBOFF				0x178
+/* Input DMA CR offset */
+#define S5P_CIICROFF				0x17c
+/* Input DMA original image size */
+#define S5P_ORGISIZE				0x180
+/* Output DMA original image size */
+#define S5P_ORGOSIZE				0x184
+/* Real output DMA image size */
+#define S5P_CIEXTEN				0x188
+/* DMA parameter */
+#define S5P_CIDMAPARAM				0x18c
+/* MIPI CSI image format */
+#define S5P_CSIIMGFMT				0x194
+
+
+#define S5P_CISRCFMT_SOURCEHSIZE(x)		((x) << 16)
+#define S5P_CISRCFMT_SOURCEVSIZE(x)		((x) << 0)
+
+#define S5P_CIWDOFST_WINHOROFST(x)		((x) << 16)
+#define S5P_CIWDOFST_WINVEROFST(x)		((x) << 0)
+
+#define S5P_CIWDOFST2_WINHOROFST2(x)		((x) << 16)
+#define S5P_CIWDOFST2_WINVEROFST2(x)		((x) << 0)
+
+#define S5P_CITRGFMT_TARGETHSIZE(x)		((x) << 16)
+#define S5P_CITRGFMT_TARGETVSIZE(x)		((x) << 0)
+
+#define S5P_CISCPRERATIO_SHFACTOR(x)		((x) << 28)
+#define S5P_CISCPRERATIO_PREHORRATIO(x)		((x) << 16)
+#define S5P_CISCPRERATIO_PREVERRATIO(x)		((x) << 0)
+
+#define S5P_CISCPREDST_PREDSTWIDTH(x)		((x) << 16)
+#define S5P_CISCPREDST_PREDSTHEIGHT(x)		((x) << 0)
+
+#define S5P_CISCCTRL_MAINHORRATIO(x)		((x) << 16)
+#define S5P_CISCCTRL_MAINVERRATIO(x)		((x) << 0)
+
+#define S5P_CITAREA_TARGET_AREA(x)		((x) << 0)
+
+#define S5P_CIIMGEFF_PAT_CB(x)			((x) << 13)
+#define S5P_CIIMGEFF_PAT_CR(x)			((x) << 0)
+
+#define S5P_CIREAL_ISIZE_HEIGHT(x)		((x) << 16)
+#define S5P_CIREAL_ISIZE_WIDTH(x)		((x) << 0)
+
+#define S5P_MSCTRL_SUCCESSIVE_COUNT(x)		((x) << 24)
+
+#define S5P_CIOYOFF_VERTICAL(x)			((x) << 16)
+#define S5P_CIOYOFF_HORIZONTAL(x)		((x) << 0)
+
+#define S5P_CIOCBOFF_VERTICAL(x)		((x) << 16)
+#define S5P_CIOCBOFF_HORIZONTAL(x)		((x) << 0)
+
+#define S5P_CIOCROFF_VERTICAL(x)		((x) << 16)
+#define S5P_CIOCROFF_HORIZONTAL(x)		((x) << 0)
+
+#define S5P_CIIYOFF_VERTICAL(x)			((x) << 16)
+#define S5P_CIIYOFF_HORIZONTAL(x)		((x) << 0)
+
+#define S5P_CIICBOFF_VERTICAL(x)		((x) << 16)
+#define S5P_CIICBOFF_HORIZONTAL(x)		((x) << 0)
+
+#define S5P_CIICROFF_VERTICAL(x)		((x) << 16)
+#define S5P_CIICROFF_HORIZONTAL(x)		((x) << 0)
+
+#define S5P_ORGISIZE_VERTICAL(x)		((x) << 16)
+#define S5P_ORGISIZE_HORIZONTAL(x)		((x) << 0)
+
+#define S5P_ORGOSIZE_VERTICAL(x)		((x) << 16)
+#define S5P_ORGOSIZE_HORIZONTAL(x)		((x) << 0)
+
+
+/* Register's bit definitions */
+
+/* Source format register */
+#define S5P_CISRCFMT_ITU601_8BIT		(1 << 31)
+#define S5P_CISRCFMT_ITU656_8BIT		(0 << 31)
+#define S5P_CISRCFMT_ITU601_16BIT		(1 << 29)
+#define S5P_CISRCFMT_ORDER422_YCBYCR		(0 << 14)
+#define S5P_CISRCFMT_ORDER422_YCRYCB		(1 << 14)
+#define S5P_CISRCFMT_ORDER422_CBYCRY		(2 << 14)
+#define S5P_CISRCFMT_ORDER422_CRYCBY		(3 << 14)
+/* ITU601 16bit only */
+#define S5P_CISRCFMT_ORDER422_Y4CBCRCBCR	(0 << 14)
+/* ITU601 16bit only */
+#define S5P_CISRCFMT_ORDER422_Y4CRCBCRCB	(1 << 14)
+
+/* Window offset register */
+#define S5P_CIWDOFST_WINOFSEN			(1 << 31)
+#define S5P_CIWDOFST_CLROVFIY			(1 << 30)
+#define S5P_CIWDOFST_CLROVRLB			(1 << 29)
+#define S5P_CIWDOFST_WINHOROFST_MASK		(0x7ff << 16)
+#define S5P_CIWDOFST_CLROVFICB			(1 << 15)
+#define S5P_CIWDOFST_CLROVFICR			(1 << 14)
+#define S5P_CIWDOFST_WINVEROFST_MASK		(0xfff << 0)
+
+/* Global control register */
+#define S5P_CIGCTRL_SWRST			(1 << 31)
+#define S5P_CIGCTRL_CAMRST_A			(1 << 30)
+#define S5P_CIGCTRL_SELCAM_ITU_B		(0 << 29)
+#define S5P_CIGCTRL_SELCAM_ITU_A		(1 << 29)
+#define S5P_CIGCTRL_SELCAM_ITU_MASK		(1 << 29)
+#define S5P_CIGCTRL_TESTPATTERN_NORMAL		(0 << 27)
+#define S5P_CIGCTRL_TESTPATTERN_COLOR_BAR	(1 << 27)
+#define S5P_CIGCTRL_TESTPATTERN_HOR_INC		(2 << 27)
+#define S5P_CIGCTRL_TESTPATTERN_VER_INC		(3 << 27)
+#define S5P_CIGCTRL_TESTPATTERN_MASK		(3 << 27)
+#define S5P_CIGCTRL_TESTPATTERN_SHIFT		(27)
+#define S5P_CIGCTRL_INVPOLPCLK			(1 << 26)
+#define S5P_CIGCTRL_INVPOLVSYNC			(1 << 25)
+#define S5P_CIGCTRL_INVPOLHREF			(1 << 24)
+#define S5P_CIGCTRL_IRQ_OVFEN			(1 << 22)
+#define S5P_CIGCTRL_HREF_MASK			(1 << 21)
+#define S5P_CIGCTRL_IRQ_EDGE			(0 << 20)
+#define S5P_CIGCTRL_IRQ_LEVEL			(1 << 20)
+#define S5P_CIGCTRL_IRQ_CLR			(1 << 19)
+#define S5P_CIGCTRL_IRQ_DISABLE			(0 << 16)
+#define S5P_CIGCTRL_IRQ_ENABLE			(1 << 16)
+#define S5P_CIGCTRL_INVPOLHSYNC			(1 << 4)
+#define S5P_CIGCTRL_SELCAM_ITU			(0 << 3)
+#define S5P_CIGCTRL_SELCAM_MIPI			(1 << 3)
+#define S5P_CIGCTRL_PROGRESSIVE			(0 << 0)
+#define S5P_CIGCTRL_INTERLACE			(1 << 0)
+
+/* Window offset2 register */
+#define S5P_CIWDOFST_WINHOROFST2_MASK		(0xfff << 16)
+#define S5P_CIWDOFST_WINVEROFST2_MASK		(0xfff << 16)
+
+/* Target format register */
+#define S5P_CITRGFMT_INROT90_CLOCKWISE		(1 << 31)
+#define S5P_CITRGFMT_OUTFORMAT_YCBCR420		(0 << 29)
+#define S5P_CITRGFMT_OUTFORMAT_YCBCR422		(1 << 29)
+#define S5P_CITRGFMT_OUTFORMAT_YCBCR422_1PLANE	(2 << 29)
+#define S5P_CITRGFMT_OUTFORMAT_RGB		(3 << 29)
+#define S5P_CITRGFMT_FLIP_SHIFT			(14)
+#define S5P_CITRGFMT_FLIP_NORMAL		(0 << 14)
+#define S5P_CITRGFMT_FLIP_X_MIRROR		(1 << 14)
+#define S5P_CITRGFMT_FLIP_Y_MIRROR		(2 << 14)
+#define S5P_CITRGFMT_FLIP_180			(3 << 14)
+#define S5P_CITRGFMT_FLIP_MASK			(3 << 14)
+#define S5P_CITRGFMT_OUTROT90_CLOCKWISE		(1 << 13)
+
+/* Output DMA control register */
+#define S5P_CIOCTRL_ORDER422_MASK		(3 << 0)
+#define S5P_CIOCTRL_ORDER422_CRYCBY		(0 << 0)
+#define S5P_CIOCTRL_ORDER422_YCRYCB		(1 << 0)
+#define S5P_CIOCTRL_ORDER422_CBYCRY		(2 << 0)
+#define S5P_CIOCTRL_ORDER422_YCBYCR		(3 << 0)
+#define S5P_CIOCTRL_LASTIRQ_ENABLE		(1 << 2)
+#define S5P_CIOCTRL_YCBCR_3PLANE		(0 << 3)
+#define S5P_CIOCTRL_YCBCR_2PLANE		(1 << 3)
+#define S5P_CIOCTRL_YCBCR_PLANE_MASK		(1 << 3)
+#define S5P_CIOCTRL_ORDER2P_SHIFT		(24)
+#define S5P_CIOCTRL_ORDER2P_MASK		(3 << 24)
+#define S5P_CIOCTRL_ORDER422_2P_LSB_CRCB	(0 << 24)
+
+
+/* Main scaler control register */
+#define S5P_CISCCTRL_SCALERBYPASS		(1 << 31)
+#define S5P_CISCCTRL_SCALEUP_H			(1 << 30)
+#define S5P_CISCCTRL_SCALEUP_V			(1 << 29)
+#define S5P_CISCCTRL_CSCR2Y_NARROW		(0 << 28)
+#define S5P_CISCCTRL_CSCR2Y_WIDE		(1 << 28)
+#define S5P_CISCCTRL_CSCY2R_NARROW		(0 << 27)
+#define S5P_CISCCTRL_CSCY2R_WIDE		(1 << 27)
+#define S5P_CISCCTRL_LCDPATHEN_FIFO		(1 << 26)
+#define S5P_CISCCTRL_PROGRESSIVE		(0 << 25)
+#define S5P_CISCCTRL_INTERLACE			(1 << 25)
+#define S5P_CISCCTRL_SCALERSTART		(1 << 15)
+#define S5P_CISCCTRL_INRGB_FMT_RGB565		(0 << 13)
+#define S5P_CISCCTRL_INRGB_FMT_RGB666		(1 << 13)
+#define S5P_CISCCTRL_INRGB_FMT_RGB888		(2 << 13)
+#define S5P_CISCCTRL_OUTRGB_FMT_RGB565		(0 << 11)
+#define S5P_CISCCTRL_OUTRGB_FMT_RGB666		(1 << 11)
+#define S5P_CISCCTRL_OUTRGB_FMT_RGB888		(2 << 11)
+#define S5P_CISCCTRL_EXTRGB_NORMAL		(0 << 10)
+#define S5P_CISCCTRL_EXTRGB_EXTENSION		(1 << 10)
+#define S5P_CISCCTRL_ONE2ONE			(1 << 9)
+
+/* Status register */
+#define S5P_CISTATUS_OVFIY			(1 << 31)
+#define S5P_CISTATUS_OVFICB			(1 << 30)
+#define S5P_CISTATUS_OVFICR			(1 << 29)
+#define S5P_CISTATUS_VSYNC			(1 << 28)
+#define S5P_CISTATUS_WINOFSTEN			(1 << 25)
+#define S5P_CISTATUS_IMGCPTEN			(1 << 22)
+#define S5P_CISTATUS_IMGCPTENSC			(1 << 21)
+#define S5P_CISTATUS_VSYNC_A			(1 << 20)
+#define S5P_CISTATUS_VSYNC_B			(1 << 19)
+#define S5P_CISTATUS_OVRLB			(1 << 18)
+#define S5P_CISTATUS_FRAMEEND			(1 << 17)
+#define S5P_CISTATUS_LASTCAPTUREEND		(1 << 16)
+#define S5P_CISTATUS_VVALID_A			(1 << 15)
+#define S5P_CISTATUS_VVALID_B			(1 << 14)
+
+/* Image capture enable register */
+#define S5P_CIIMGCPT_IMGCPTEN			(1 << 31)
+#define S5P_CIIMGCPT_IMGCPTEN_SC		(1 << 30)
+#define S5P_CIIMGCPT_CPT_FREN_ENABLE		(1 << 25)
+#define S5P_CIIMGCPT_CPT_FRMOD_EN		(0 << 18)
+#define S5P_CIIMGCPT_CPT_FRMOD_CNT		(1 << 18)
+
+/* Image effects register */
+#define S5P_CIIMGEFF_IE_DISABLE			(0 << 30)
+#define S5P_CIIMGEFF_IE_ENABLE			(1 << 30)
+#define S5P_CIIMGEFF_IE_SC_BEFORE		(0 << 29)
+#define S5P_CIIMGEFF_IE_SC_AFTER		(1 << 29)
+#define S5P_CIIMGEFF_FIN_BYPASS			(0 << 26)
+#define S5P_CIIMGEFF_FIN_ARBITRARY		(1 << 26)
+#define S5P_CIIMGEFF_FIN_NEGATIVE		(2 << 26)
+#define S5P_CIIMGEFF_FIN_ARTFREEZE		(3 << 26)
+#define S5P_CIIMGEFF_FIN_EMBOSSING		(4 << 26)
+#define S5P_CIIMGEFF_FIN_SILHOUETTE		(5 << 26)
+#define S5P_CIIMGEFF_FIN_MASK			(7 << 26)
+#define S5P_CIIMGEFF_PAT_CBCR_MASK		((0xff < 13) | (0xff < 0))
+
+/* Real input DMA size register */
+#define S5P_CIREAL_ISIZE_AUTOLOAD_ENABLE	(1 << 31)
+#define S5P_CIREAL_ISIZE_ADDR_CH_DISABLE	(1 << 30)
+
+/* Input DMA control register */
+#define S5P_MSCTRL_2PLANE_SHIFT			(16)
+#define S5P_MSCTRL_C_INT_IN_3PLANE		(0 << 15)
+#define S5P_MSCTRL_C_INT_IN_2PLANE		(1 << 15)
+#define S5P_MSCTRL_FLIP_SHIFT			(13)
+#define S5P_MSCTRL_FLIP_NORMAL			(0 << 13)
+#define S5P_MSCTRL_FLIP_X_MIRROR		(1 << 13)
+#define S5P_MSCTRL_FLIP_Y_MIRROR		(2 << 13)
+#define S5P_MSCTRL_FLIP_180			(3 << 13)
+#define S5P_MSCTRL_ORDER422_SHIFT		(4)
+#define S5P_MSCTRL_ORDER422_CRYCBY		(0 << 4)
+#define S5P_MSCTRL_ORDER422_YCRYCB		(1 << 4)
+#define S5P_MSCTRL_ORDER422_CBYCRY		(2 << 4)
+#define S5P_MSCTRL_ORDER422_YCBYCR		(3 << 4)
+#define S5P_MSCTRL_INPUT_EXTCAM			(0 << 3)
+#define S5P_MSCTRL_INPUT_MEMORY			(1 << 3)
+#define S5P_MSCTRL_INPUT_MASK			(1 << 3)
+#define S5P_MSCTRL_INFORMAT_YCBCR420		(0 << 1)
+#define S5P_MSCTRL_INFORMAT_YCBCR422		(1 << 1)
+#define S5P_MSCTRL_INFORMAT_YCBCR422_1PLANE	(2 << 1)
+#define S5P_MSCTRL_INFORMAT_RGB			(3 << 1)
+#define S5P_MSCTRL_ENVID			(1 << 0)
+
+/* DMA parameter register */
+#define S5P_CIDMAPARAM_R_MODE_64X32		(3 << 29)
+#define S5P_CIDMAPARAM_W_MODE_LINEAR		(0 << 13)
+#define S5P_CIDMAPARAM_W_MODE_CONFTILE		(1 << 13)
+#define S5P_CIDMAPARAM_W_MODE_64X32		(3 << 13)
+
+#endif /* REGS_FIMC_H_ */
-- 
1.7.0.4

