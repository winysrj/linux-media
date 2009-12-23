Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:63915 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbZLWKI5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 05:08:57 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 23 Dec 2009 11:08:51 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH 1/2] [ARM] samsung-rotator: Add rotator device platform
 definitions.
In-reply-to: <1261562933-26987-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1261562933-26987-2-git-send-email-p.osciak@samsung.com>
References: <1261562933-26987-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add S3C/S5P rotator platform device.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-s3c6400/include/mach/map.h      |    2 +
 arch/arm/plat-s3c/Kconfig                     |    5 ++
 arch/arm/plat-s3c/Makefile                    |    1 +
 arch/arm/plat-s3c/dev-rotator.c               |   42 +++++++++++++++++
 arch/arm/plat-s3c/include/plat/devs.h         |    2 +
 arch/arm/plat-s3c/include/plat/regs-rotator.h |   62 +++++++++++++++++++++++++
 6 files changed, 114 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/plat-s3c/dev-rotator.c
 create mode 100644 arch/arm/plat-s3c/include/plat/regs-rotator.h

diff --git a/arch/arm/mach-s3c6400/include/mach/map.h b/arch/arm/mach-s3c6400/include/mach/map.h
index 106ee13..718438e 100644
--- a/arch/arm/mach-s3c6400/include/mach/map.h
+++ b/arch/arm/mach-s3c6400/include/mach/map.h
@@ -40,6 +40,7 @@
 
 #define S3C64XX_PA_NAND		(0x70200000)
 #define S3C64XX_PA_FB		(0x77100000)
+#define S3C64XX_PA_ROTATOR      (0x77200000)
 #define S3C64XX_PA_USB_HSOTG	(0x7C000000)
 #define S3C64XX_PA_WATCHDOG	(0x7E004000)
 #define S3C64XX_PA_SYSCON	(0x7E00F000)
@@ -85,5 +86,6 @@
 #define S3C_PA_USBHOST		S3C64XX_PA_USBHOST
 #define S3C_PA_USB_HSOTG	S3C64XX_PA_USB_HSOTG
 #define S3C_VA_USB_HSPHY	S3C64XX_VA_USB_HSPHY
+#define S3C_PA_ROTATOR          S3C64XX_PA_ROTATOR
 
 #endif /* __ASM_ARCH_6400_MAP_H */
diff --git a/arch/arm/plat-s3c/Kconfig b/arch/arm/plat-s3c/Kconfig
index 9e9d028..668c80d 100644
--- a/arch/arm/plat-s3c/Kconfig
+++ b/arch/arm/plat-s3c/Kconfig
@@ -212,4 +212,9 @@ config S3C_DEV_NAND
 	help
 	  Compile in platform device definition for NAND controller
 
+config S3C_DEV_ROTATOR
+	bool
+	help
+	  Compile in platform device definition for image rotator
+
 endif
diff --git a/arch/arm/plat-s3c/Makefile b/arch/arm/plat-s3c/Makefile
index 50444da..a827cfe 100644
--- a/arch/arm/plat-s3c/Makefile
+++ b/arch/arm/plat-s3c/Makefile
@@ -43,3 +43,4 @@ obj-$(CONFIG_S3C_DEV_FB)	+= dev-fb.o
 obj-$(CONFIG_S3C_DEV_USB_HOST)	+= dev-usb.o
 obj-$(CONFIG_S3C_DEV_USB_HSOTG)	+= dev-usb-hsotg.o
 obj-$(CONFIG_S3C_DEV_NAND)	+= dev-nand.o
+obj-$(CONFIG_S3C_DEV_ROTATOR)	+= dev-rotator.o
diff --git a/arch/arm/plat-s3c/dev-rotator.c b/arch/arm/plat-s3c/dev-rotator.c
new file mode 100644
index 0000000..8409f70
--- /dev/null
+++ b/arch/arm/plat-s3c/dev-rotator.c
@@ -0,0 +1,42 @@
+/*
+ * Samsung S3C/S5P image rotator resource and device definitions.
+ *
+ * Copyright (c) 2009 Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
+ */
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/ioport.h>
+
+#include <mach/map.h>
+#include <plat/map-base.h>
+#include <plat/devs.h>
+#include <plat/irqs.h>
+
+static struct resource s3c_rotator_resource[] = {
+	[0] = {
+		.start  = S3C_PA_ROTATOR,
+		.end    = S3C_PA_ROTATOR + SZ_4K - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = IRQ_ROTATOR,
+		.end    = IRQ_ROTATOR,
+		.flags  = IORESOURCE_IRQ,
+	}
+};
+
+struct platform_device s3c_device_rotator = {
+	.name		= "s3c-rotator",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(s3c_rotator_resource),
+	.resource	= s3c_rotator_resource,
+};
+
+EXPORT_SYMBOL(s3c_device_rotator);
+
diff --git a/arch/arm/plat-s3c/include/plat/devs.h b/arch/arm/plat-s3c/include/plat/devs.h
index 932cbbb..ff912a9 100644
--- a/arch/arm/plat-s3c/include/plat/devs.h
+++ b/arch/arm/plat-s3c/include/plat/devs.h
@@ -56,6 +56,8 @@ extern struct platform_device s3c_device_nand;
 extern struct platform_device s3c_device_usbgadget;
 extern struct platform_device s3c_device_usb_hsotg;
 
+extern struct platform_device s3c_device_rotator;
+
 /* s3c2440 specific devices */
 
 #ifdef CONFIG_CPU_S3C2440
diff --git a/arch/arm/plat-s3c/include/plat/regs-rotator.h b/arch/arm/plat-s3c/include/plat/regs-rotator.h
new file mode 100644
index 0000000..6cd1cc9
--- /dev/null
+++ b/arch/arm/plat-s3c/include/plat/regs-rotator.h
@@ -0,0 +1,62 @@
+/*
+ * Copyright (c) 2009 Samsung Electronics
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * S3C/S5P image rotator register map
+ */
+
+#ifndef __ASM_ARCH_PLAT_S3C_ROTATOR_H
+#define __ASM_ARCH_PLAT_S3C_ROTATOR_H __FILE__
+
+#define S3C_ROT_SRC_WIDTH(x)				(((x) << 0) & 0xFFFF)
+#define S3C_ROT_SRC_HEIGHT(x)				((x) << 16)
+
+#define S3C_ROTATOR_CTRLREG_INT_MASK			(1 << 24)
+#define S3C_ROTATOR_CTRLREG_FORMAT_MASK			(7 << 13)
+#define S3C_ROTATOR_CTRLREG_ROT_DEG_MASK		(3 << 6)
+#define S3C_ROTATOR_CTRLREG_FLIP_MASK			(3 << 4)
+#define S3C_ROTATOR_CTRLREG_START_MASK			(1 << 0)
+
+#define S3C_ROTATOR_CTRLREG_MASK	( S3C_ROTATOR_CTRLREG_INT_MASK     \
+					| S3C_ROTATOR_CTRLREG_FORMAT_MASK  \
+					| S3C_ROTATOR_CTRLREG_ROT_DEG_MASK \
+					| S3C_ROTATOR_CTRLREG_FLIP_MASK    \
+					| S3C_ROTATOR_CTRLREG_START_MASK   \
+					| S3C_ROTATOR_CTRLREG_ENABLE_INT )
+
+#define S3C_ROTATOR_CTRLREG_ENABLE_INT			(1 << 24)
+#define S3C_ROTATOR_CTRLREG_SRC_YCBCR420		(0 << 13)
+#define S3C_ROTATOR_CTRLREG_SRC_YCBCR422		(3 << 13)
+#define S3C_ROTATOR_CTRLREG_SRC_RGB565			(4 << 13)
+#define S3C_ROTATOR_CTRLREG_SRC_RGB888			(5 << 13)
+
+#define S3C_ROTATOR_CTRLREG_DEGREE_90			(1 << 6)
+#define S3C_ROTATOR_CTRLREG_DEGREE_180			(2 << 6)
+#define S3C_ROTATOR_CTRLREG_DEGREE_270			(3 << 6)
+
+#define S3C_ROTATOR_CTRLREG_FLIP_VERT			(2 << 4)
+#define S3C_ROTATOR_CTRLREG_FLIP_HORIZ			(3 << 4)
+#define S3C_ROTATOR_CTRLREG_START			(1 << 0)
+
+#define S3C_ROTATOR_STATREG_STATUS_IDLE			(0 << 0)
+#define S3C_ROTATOR_CTRLREG_START_ROTATE		(1 << 0)
+#define S3C_ROTATOR_STATREG_STATUS_BUSY			(2 << 0)
+#define S3C_ROTATOR_STATREG_STATUS_BUSY_MORE		(3 << 0)
+#define S3C_ROTATOR_STATREG_INT_PEND			(1 << 8)
+
+
+#define S3C_ROTATOR_CTRLREG				(0x0)
+#define S3C_ROTATOR_SRCADDRREG0				(0x4)
+#define S3C_ROTATOR_SRCADDRREG1				(0x8)
+#define S3C_ROTATOR_SRCADDRREG2				(0xC)
+#define S3C_ROTATOR_SRCSIZEREG				(0x10)
+#define S3C_ROTATOR_DESTADDRREG0			(0x18)
+#define S3C_ROTATOR_DESTADDRREG1			(0x1C)
+#define S3C_ROTATOR_DESTADDRREG2			(0x20)
+#define S3C_ROTATOR_STATREG				(0x2C)
+
+#endif /* __ASM_ARCH_PLAT_S3C_ROTATOR_H */
+
-- 
1.6.4.2.253.g0b1fac

