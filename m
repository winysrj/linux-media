Return-path: <linux-media-owner@vger.kernel.org>
Received: from d1.icnet.pl ([212.160.220.21]:56088 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab0GREXh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jul 2010 00:23:37 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: [RFC] [PATCH 2/6] OMAP1: Add support for SoC camera interface
Date: Sun, 18 Jul 2010 06:23:09 +0200
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Tony Lindgren <tony@atomide.com>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201007180618.08266.jkrzyszt@tis.icnet.pl>
In-Reply-To: <201007180618.08266.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007180623.10663.jkrzyszt@tis.icnet.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for SoC camera interface to OMAP1 devices.

Created and tested against linux-2.6.35-rc3 on Amstrad Delta.

For successfull compilation, requires a header file provided by PATCH 1/6 from 
this series, "SoC Camera: add driver for OMAP1 camera interface".

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 arch/arm/mach-omap1/devices.c             |   43 ++++++++++++++++++++++++++++++
 arch/arm/mach-omap1/include/mach/camera.h |    8 +++++
 2 files changed, 51 insertions(+)

--- linux-2.6.35-rc3.orig/arch/arm/mach-omap1/devices.c	2010-06-26 15:54:47.000000000 +0200
+++ linux-2.6.35-rc3/arch/arm/mach-omap1/devices.c	2010-07-18 01:54:39.000000000 +0200
@@ -15,6 +15,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/spi/spi.h>
+#include <linux/dma-mapping.h>
 
 #include <mach/hardware.h>
 #include <asm/mach/map.h>
@@ -25,6 +26,7 @@
 #include <mach/gpio.h>
 #include <plat/mmc.h>
 #include <plat/omap7xx.h>
+#include <mach/camera.h>
 
 /*-------------------------------------------------------------------------*/
 
@@ -267,6 +269,47 @@ static inline void omap_init_sti(void)
 static inline void omap_init_sti(void) {}
 #endif
 
+
+#define OMAP1_CAMERA_BASE	0xfffb6800
+
+static struct resource omap1_camera_resources[] = {
+	[0] = {
+		.start	= OMAP1_CAMERA_BASE,
+		.end	= OMAP1_CAMERA_BASE + OMAP1_CAMERA_IOSIZE - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= INT_CAMERA,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static u64 omap1_camera_dma_mask = DMA_BIT_MASK(32);
+
+static struct platform_device omap1_camera_device = {
+	.name		= "omap1-camera",
+	.id		= 0, /* This is used to put cameras on this interface */
+	.dev		= {
+		.dma_mask		= &omap1_camera_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+	.num_resources	= ARRAY_SIZE(omap1_camera_resources),
+	.resource	= omap1_camera_resources,
+};
+
+void __init omap1_set_camera_info(struct omap1_cam_platform_data *info)
+{
+	struct platform_device *dev = &omap1_camera_device;
+	int ret;
+
+	dev->dev.platform_data = info;
+
+	ret = platform_device_register(dev);
+	if (ret)
+		dev_err(&dev->dev, "unable to register device: %d\n", ret);
+}
+
+
 /*-------------------------------------------------------------------------*/
 
 /*
--- linux-2.6.35-rc3.orig/arch/arm/mach-omap1/include/mach/camera.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.35-rc3/arch/arm/mach-omap1/include/mach/camera.h	2010-07-18 01:57:18.000000000 +0200
@@ -0,0 +1,8 @@
+#ifndef __ASM_ARCH_CAMERA_H_
+#define __ASM_ARCH_CAMERA_H_
+
+#include <media/omap1_camera.h>
+
+extern void omap1_set_camera_info(struct omap1_cam_platform_data *);
+
+#endif /* __ASM_ARCH_CAMERA_H_ */
