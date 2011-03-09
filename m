Return-path: <mchehab@pedra>
Received: from ganesha.gnumonks.org ([213.95.27.120]:52702 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311Ab1CINoy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 08:44:54 -0500
From: Jeongtae Park <jtp.park@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, jaeryul.oh@samsung.com,
	kgene.kim@samsung.com, ben-linux@fluff.org,
	jonghun.han@samsung.com, Jeongtae Park <jtp.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH v2 4/8] ARM: S5P: Add platform support for MFC v5.1
Date: Wed,  9 Mar 2011 22:16:03 +0900
Message-Id: <1299676567-14194-5-git-send-email-jtp.park@samsung.com>
In-Reply-To: <1299676567-14194-1-git-send-email-jtp.park@samsung.com>
References: <1299676567-14194-1-git-send-email-jtp.park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add platform support for MFC v5.1 is a module available
on S5PC110 and S5PC210 Samsung SoCs.

Reviewed-by: Peter Oh <jaeryul.oh@samsung.com>
Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>
---
 arch/arm/plat-s5p/Kconfig                 |    5 +++
 arch/arm/plat-s5p/Makefile                |    1 +
 arch/arm/plat-s5p/dev-mfc.c               |   46 +++++++++++++++++++++++++++++
 arch/arm/plat-samsung/include/plat/devs.h |    2 +
 4 files changed, 54 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/plat-s5p/dev-mfc.c

diff --git a/arch/arm/plat-s5p/Kconfig b/arch/arm/plat-s5p/Kconfig
index deb3995..601b5b0 100644
--- a/arch/arm/plat-s5p/Kconfig
+++ b/arch/arm/plat-s5p/Kconfig
@@ -52,6 +52,11 @@ config S5P_DEV_FIMC2
 	help
 	  Compile in platform device definitions for FIMC controller 2
 
+config S5P_DEV_MFC
+	bool
+	help
+	  Compile in platform device definitions for MFC
+
 config S5P_DEV_ONENAND
 	bool
 	help
diff --git a/arch/arm/plat-s5p/Makefile b/arch/arm/plat-s5p/Makefile
index 92efe1a..3577f2a 100644
--- a/arch/arm/plat-s5p/Makefile
+++ b/arch/arm/plat-s5p/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_PM)		+= irq-pm.o
 obj-$(CONFIG_S5P_DEV_FIMC0)	+= dev-fimc0.o
 obj-$(CONFIG_S5P_DEV_FIMC1)	+= dev-fimc1.o
 obj-$(CONFIG_S5P_DEV_FIMC2)	+= dev-fimc2.o
+obj-$(CONFIG_S5P_DEV_MFC)	+= dev-mfc.o
 obj-$(CONFIG_S5P_DEV_ONENAND)	+= dev-onenand.o
 obj-$(CONFIG_S5P_DEV_CSIS0)	+= dev-csis0.o
 obj-$(CONFIG_S5P_DEV_CSIS1)	+= dev-csis1.o
diff --git a/arch/arm/plat-s5p/dev-mfc.c b/arch/arm/plat-s5p/dev-mfc.c
new file mode 100644
index 0000000..67afdae
--- /dev/null
+++ b/arch/arm/plat-s5p/dev-mfc.c
@@ -0,0 +1,46 @@
+/* linux/arch/arm/plat-s5p/dev-mfc.c
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Base S5P MFC resource and device definitions
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/ioport.h>
+#include <linux/dma-mapping.h>
+
+#include <mach/map.h>
+#include <plat/devs.h>
+#include <plat/irqs.h>
+
+static struct resource s5p_mfc_resource[] = {
+	[0] = {
+		.start	= S5P_PA_MFC,
+		.end	= S5P_PA_MFC + SZ_64K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= IRQ_MFC,
+		.end	= IRQ_MFC,
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
+static u64 s5p_mfc_dma_mask = DMA_BIT_MASK(32);
+
+struct platform_device s5p_device_mfc = {
+	.name		= "s5p-mfc",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(s5p_mfc_resource),
+	.resource	= s5p_mfc_resource,
+	.dev		= {
+		.dma_mask		= &s5p_mfc_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
diff --git a/arch/arm/plat-samsung/include/plat/devs.h b/arch/arm/plat-samsung/include/plat/devs.h
index b4d208b..f3ca8db 100644
--- a/arch/arm/plat-samsung/include/plat/devs.h
+++ b/arch/arm/plat-samsung/include/plat/devs.h
@@ -134,6 +134,8 @@ extern struct platform_device s5p_device_fimc0;
 extern struct platform_device s5p_device_fimc1;
 extern struct platform_device s5p_device_fimc2;
 
+extern struct platform_device s5p_device_mfc;
+
 extern struct platform_device s5p_device_mipi_csis0;
 extern struct platform_device s5p_device_mipi_csis1;
 
-- 
1.7.1

