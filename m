Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:49681 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934391AbeE1Qhg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 12:37:36 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        sakari.ailus@iki.fi, mchehab@kernel.org,
        ysato@users.sourceforge.jp, dalias@libc.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] arch: sh: ms7724se: Use new renesas-ceu camera driver
Date: Mon, 28 May 2018 18:37:10 +0200
Message-Id: <1527525431-22852-5-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1527525431-22852-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1527525431-22852-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the new renesas-ceu camera driver is ms7724se board file instead of
the soc_camera based sh_mobile_ceu_camera driver.

Get rid of soc_camera specific components, and register CEU0 and CEU1 with
no active video subdevices.

Memory for the CEU video buffers is now reserved with membocks APIs
and need to be declared as dma_coherent during machine initialization to
remove that architecture specific part from CEU driver.

While at there update license to SPDX header and sort headers
alphabetically.

No need to udapte the clock source names, as
commit c2f9b05fd5c1 ("media: arch: sh: ecovec: Use new renesas-ceu camera driver")
already updated it to the new ceu driver name for all SH7724 boards
(possibly breaking ms7724se before this commit).

Compile tested only.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 arch/sh/boards/mach-se/7724/setup.c | 120 ++++++++++++++++++++++++------------
 1 file changed, 79 insertions(+), 41 deletions(-)

diff --git a/arch/sh/boards/mach-se/7724/setup.c b/arch/sh/boards/mach-se/7724/setup.c
index 2559525..fdbec22a 100644
--- a/arch/sh/boards/mach-se/7724/setup.c
+++ b/arch/sh/boards/mach-se/7724/setup.c
@@ -1,43 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * linux/arch/sh/boards/se/7724/setup.c
  *
  * Copyright (C) 2009 Renesas Solutions Corp.
  *
  * Kuninori Morimoto <morimoto.kuninori@renesas.com>
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
  */
+#include <asm/clock.h>
+#include <asm/heartbeat.h>
+#include <asm/io.h>
+#include <asm/suspend.h>
 
-#include <linux/init.h>
+#include <cpu/sh7724.h>
+
+#include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/gpio.h>
+#include <linux/init.h>
+#include <linux/input.h>
+#include <linux/input/sh_keysc.h>
 #include <linux/interrupt.h>
-#include <linux/platform_device.h>
-#include <linux/mmc/host.h>
+#include <linux/memblock.h>
 #include <linux/mfd/tmio.h>
+#include <linux/mmc/host.h>
 #include <linux/mtd/physmap.h>
-#include <linux/delay.h>
+#include <linux/platform_device.h>
 #include <linux/regulator/fixed.h>
 #include <linux/regulator/machine.h>
-#include <linux/smc91x.h>
-#include <linux/gpio.h>
-#include <linux/input.h>
-#include <linux/input/sh_keysc.h>
-#include <linux/usb/r8a66597.h>
 #include <linux/sh_eth.h>
 #include <linux/sh_intc.h>
+#include <linux/smc91x.h>
+#include <linux/usb/r8a66597.h>
 #include <linux/videodev2.h>
-#include <video/sh_mobile_lcdc.h>
-#include <media/drv-intf/sh_mobile_ceu.h>
+
+#include <mach-se/mach/se7724.h>
+#include <media/drv-intf/renesas-ceu.h>
+
 #include <sound/sh_fsi.h>
 #include <sound/simple_card.h>
-#include <asm/io.h>
-#include <asm/heartbeat.h>
-#include <asm/clock.h>
-#include <asm/suspend.h>
-#include <cpu/sh7724.h>
-#include <mach-se/mach/se7724.h>
+
+#include <video/sh_mobile_lcdc.h>
+
+#define CEU_BUFFER_MEMORY_SIZE		(4 << 20)
+static phys_addr_t ceu0_dma_membase;
+static phys_addr_t ceu1_dma_membase;
 
 /*
  * SWx    1234 5678
@@ -216,8 +222,8 @@ static struct platform_device lcdc_device = {
 };
 
 /* CEU0 */
-static struct sh_mobile_ceu_info sh_mobile_ceu0_info = {
-	.flags = SH_CEU_FLAG_USE_8BIT_BUS,
+static struct ceu_platform_data ceu0_pdata = {
+	.num_subdevs = 0,
 };
 
 static struct resource ceu0_resources[] = {
@@ -231,24 +237,21 @@ static struct resource ceu0_resources[] = {
 		.start  = evt2irq(0x880),
 		.flags  = IORESOURCE_IRQ,
 	},
-	[2] = {
-		/* place holder for contiguous memory */
-	},
 };
 
 static struct platform_device ceu0_device = {
-	.name		= "sh_mobile_ceu",
-	.id             = 0, /* "ceu0" clock */
+	.name		= "renesas-ceu",
+	.id             = 0, /* "ceu.0" clock */
 	.num_resources	= ARRAY_SIZE(ceu0_resources),
 	.resource	= ceu0_resources,
 	.dev	= {
-		.platform_data	= &sh_mobile_ceu0_info,
+		.platform_data	= &ceu0_pdata,
 	},
 };
 
 /* CEU1 */
-static struct sh_mobile_ceu_info sh_mobile_ceu1_info = {
-	.flags = SH_CEU_FLAG_USE_8BIT_BUS,
+static struct ceu_platform_data ceu1_pdata = {
+	.num_subdevs = 0,
 };
 
 static struct resource ceu1_resources[] = {
@@ -262,18 +265,15 @@ static struct resource ceu1_resources[] = {
 		.start  = evt2irq(0x9e0),
 		.flags  = IORESOURCE_IRQ,
 	},
-	[2] = {
-		/* place holder for contiguous memory */
-	},
 };
 
 static struct platform_device ceu1_device = {
-	.name		= "sh_mobile_ceu",
-	.id             = 1, /* "ceu1" clock */
+	.name		= "renesas-ceu",
+	.id             = 1, /* "ceu.1" clock */
 	.num_resources	= ARRAY_SIZE(ceu1_resources),
 	.resource	= ceu1_resources,
 	.dev	= {
-		.platform_data	= &sh_mobile_ceu1_info,
+		.platform_data	= &ceu1_pdata,
 	},
 };
 
@@ -574,13 +574,16 @@ static struct platform_device vou_device = {
 	},
 };
 
+static struct platform_device *ms7724se_ceu_devices[] __initdata = {
+	&ceu0_device,
+	&ceu1_device,
+};
+
 static struct platform_device *ms7724se_devices[] __initdata = {
 	&heartbeat_device,
 	&smc91x_eth_device,
 	&lcdc_device,
 	&nor_flash_device,
-	&ceu0_device,
-	&ceu1_device,
 	&keysc_device,
 	&sh_eth_device,
 	&sh7724_usb0_host_device,
@@ -797,7 +800,6 @@ static int __init devices_setup(void)
 	gpio_request(GPIO_FN_VIO0_CLK, NULL);
 	gpio_request(GPIO_FN_VIO0_FLD, NULL);
 	gpio_request(GPIO_FN_VIO0_HD,  NULL);
-	platform_resource_setup_memory(&ceu0_device, "ceu0", 4 << 20);
 
 	/* enable CEU1 */
 	gpio_request(GPIO_FN_VIO1_D7,  NULL);
@@ -812,7 +814,6 @@ static int __init devices_setup(void)
 	gpio_request(GPIO_FN_VIO1_HD,  NULL);
 	gpio_request(GPIO_FN_VIO1_VD,  NULL);
 	gpio_request(GPIO_FN_VIO1_CLK, NULL);
-	platform_resource_setup_memory(&ceu1_device, "ceu1", 4 << 20);
 
 	/* KEYSC */
 	gpio_request(GPIO_FN_KEYOUT5_IN5, NULL);
@@ -934,12 +935,49 @@ static int __init devices_setup(void)
 	gpio_request(GPIO_FN_DV_VSYNC, NULL);
 	gpio_request(GPIO_FN_DV_HSYNC, NULL);
 
+	/* Initialize CEU platform devices separately to map memory first */
+	device_initialize(&ms7724se_ceu_devices[0]->dev);
+	arch_setup_pdev_archdata(ms7724se_ceu_devices[0]);
+	dma_declare_coherent_memory(&ms7724se_ceu_devices[0]->dev,
+				    ceu0_dma_membase, ceu0_dma_membase,
+				    ceu0_dma_membase +
+				    CEU_BUFFER_MEMORY_SIZE - 1,
+				    DMA_MEMORY_EXCLUSIVE);
+	platform_device_add(ms7724se_ceu_devices[0]);
+
+	device_initialize(&ms7724se_ceu_devices[1]->dev);
+	arch_setup_pdev_archdata(ms7724se_ceu_devices[1]);
+	dma_declare_coherent_memory(&ms7724se_ceu_devices[1]->dev,
+				    ceu1_dma_membase, ceu1_dma_membase,
+				    ceu1_dma_membase +
+				    CEU_BUFFER_MEMORY_SIZE - 1,
+				    DMA_MEMORY_EXCLUSIVE);
+	platform_device_add(ms7724se_ceu_devices[1]);
+
 	return platform_add_devices(ms7724se_devices,
 				    ARRAY_SIZE(ms7724se_devices));
 }
 device_initcall(devices_setup);
 
+/* Reserve a portion of memory for CEU 0 and CEU 1 buffers */
+static void __init ms7724se_mv_mem_reserve(void)
+{
+	phys_addr_t phys;
+	phys_addr_t size = CEU_BUFFER_MEMORY_SIZE;
+
+	phys = memblock_alloc_base(size, PAGE_SIZE, MEMBLOCK_ALLOC_ANYWHERE);
+	memblock_free(phys, size);
+	memblock_remove(phys, size);
+	ceu0_dma_membase = phys;
+
+	phys = memblock_alloc_base(size, PAGE_SIZE, MEMBLOCK_ALLOC_ANYWHERE);
+	memblock_free(phys, size);
+	memblock_remove(phys, size);
+	ceu1_dma_membase = phys;
+}
+
 static struct sh_machine_vector mv_ms7724se __initmv = {
 	.mv_name	= "ms7724se",
 	.mv_init_irq	= init_se7724_IRQ,
+	.mv_mem_reserve	= ms7724se_mv_mem_reserve,
 };
-- 
2.7.4
