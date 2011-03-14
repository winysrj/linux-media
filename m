Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29782 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab1CNIWk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 04:22:40 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 14 Mar 2011 09:22:27 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] ARM: Samsung: Add MFC 5.1 platform device to plat-s5p
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	k.debski@samsung.com, jaeryul.oh@samsung.com, kgene.kim@samsung.com
Message-id: <1300090947-20382-1-git-send-email-k.debski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds platform support for Multi Format Codec 5.1.
MFC 5.1 is capable of handling a range of video codecs and this driver
provides V4L2 interface for video decoding.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/plat-s5p/Kconfig                 |    5 +++
 arch/arm/plat-s5p/Makefile                |    1 +
 arch/arm/plat-s5p/dev-mfc.c               |   49 +++++++++++++++++++++++++++++
 arch/arm/plat-samsung/include/plat/devs.h |    1 +
 4 files changed, 56 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/plat-s5p/dev-mfc.c

diff --git a/arch/arm/plat-s5p/Kconfig b/arch/arm/plat-s5p/Kconfig
index 8492297..d851e24 100644
--- a/arch/arm/plat-s5p/Kconfig
+++ b/arch/arm/plat-s5p/Kconfig
@@ -70,6 +70,11 @@ config S5P_DEV_FIMC3
 	help
 	  Compile in platform device definitions for FIMC controller 3
 
+config S5P_DEV_MFC
+	bool
+	help
+	  Compile in platform device definitions for MFC 
+
 config S5P_DEV_ONENAND
 	bool
 	help
diff --git a/arch/arm/plat-s5p/Makefile b/arch/arm/plat-s5p/Makefile
index 42afff7..5ceab24 100644
--- a/arch/arm/plat-s5p/Makefile
+++ b/arch/arm/plat-s5p/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_S5P_DEV_FIMC0)	+= dev-fimc0.o
 obj-$(CONFIG_S5P_DEV_FIMC1)	+= dev-fimc1.o
 obj-$(CONFIG_S5P_DEV_FIMC2)	+= dev-fimc2.o
 obj-$(CONFIG_S5P_DEV_FIMC3)	+= dev-fimc3.o
+obj-$(CONFIG_S5P_DEV_MFC)	+= dev-mfc.o
 obj-$(CONFIG_S5P_DEV_ONENAND)	+= dev-onenand.o
 obj-$(CONFIG_S5P_DEV_CSIS0)	+= dev-csis0.o
 obj-$(CONFIG_S5P_DEV_CSIS1)	+= dev-csis1.o
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
index 7231ccf..bc06c28 100644
--- a/arch/arm/plat-samsung/include/plat/devs.h
+++ b/arch/arm/plat-samsung/include/plat/devs.h
@@ -137,6 +137,7 @@ extern struct platform_device s5p_device_fimc0;
 extern struct platform_device s5p_device_fimc1;
 extern struct platform_device s5p_device_fimc2;
 extern struct platform_device s5p_device_fimc3;
+extern struct platform_device s5p_device_mfc;
 
 extern struct platform_device s5p_device_mipi_csis0;
 extern struct platform_device s5p_device_mipi_csis1;
-- 
1.7.1.569.g6f426
