Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:50253 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940222AbeE1Qhd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 12:37:33 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        sakari.ailus@iki.fi, mchehab@kernel.org,
        ysato@users.sourceforge.jp, dalias@libc.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] arch: sh: kfr2r09: Use new renesas-ceu camera driver
Date: Mon, 28 May 2018 18:37:09 +0200
Message-Id: <1527525431-22852-4-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1527525431-22852-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1527525431-22852-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the new renesas-ceu camera driver in kfr2r09 board file instead of
the soc_camera based sh_mobile_ceu_camera driver.

Get rid of soc_camera specific components, and move clk and gpio handling
away from board file, registering the clock source and the enable gpios
for driver consumption.

Memory for the CEU video buffers is now reserved with membocks APIs,
and need to be declared as dma_coherent during machine initialization to
remove that architecture specific part from CEU driver.

While at there update license to SPDX header and sort headers alphabetically.

No need to udapte the clock source names, as
commit c2f9b05fd5c1 ("media: arch: sh: ecovec: Use new renesas-ceu camera driver")
already updated it to the new ceu driver name for all SH7724 boards (possibly
breaking kfr2r09 before this commit).

Compile tested only.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 arch/sh/boards/mach-kfr2r09/setup.c | 217 +++++++++++++++++-------------------
 1 file changed, 103 insertions(+), 114 deletions(-)

diff --git a/arch/sh/boards/mach-kfr2r09/setup.c b/arch/sh/boards/mach-kfr2r09/setup.c
index 6af7777..e59c577 100644
--- a/arch/sh/boards/mach-kfr2r09/setup.c
+++ b/arch/sh/boards/mach-kfr2r09/setup.c
@@ -1,41 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * KFR2R09 board support code
  *
  * Copyright (C) 2009 Magnus Damm
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
  */
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/interrupt.h>
-#include <linux/mmc/host.h>
-#include <linux/mfd/tmio.h>
-#include <linux/mtd/physmap.h>
-#include <linux/mtd/onenand.h>
+
+#include <asm/clock.h>
+#include <asm/io.h>
+#include <asm/machvec.h>
+#include <asm/suspend.h>
+
+#include <cpu/sh7724.h>
+
+#include <linux/clkdev.h>
 #include <linux/delay.h>
-#include <linux/clk.h>
+#include <linux/dma-mapping.h>
 #include <linux/gpio.h>
+#include <linux/gpio/machine.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/input/sh_keysc.h>
-#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/memblock.h>
+#include <linux/mfd/tmio.h>
+#include <linux/mmc/host.h>
+#include <linux/mtd/onenand.h>
+#include <linux/mtd/physmap.h>
 #include <linux/platform_data/lv5207lp.h>
+#include <linux/platform_device.h>
 #include <linux/regulator/fixed.h>
 #include <linux/regulator/machine.h>
+#include <linux/sh_intc.h>
 #include <linux/usb/r8a66597.h>
 #include <linux/videodev2.h>
-#include <linux/sh_intc.h>
+
+#include <mach/kfr2r09.h>
+
+#include <media/drv-intf/renesas-ceu.h>
 #include <media/i2c/rj54n1cb0c.h>
-#include <media/soc_camera.h>
-#include <media/drv-intf/sh_mobile_ceu.h>
+
 #include <video/sh_mobile_lcdc.h>
-#include <asm/suspend.h>
-#include <asm/clock.h>
-#include <asm/machvec.h>
-#include <asm/io.h>
-#include <cpu/sh7724.h>
-#include <mach/kfr2r09.h>
+
+#define CEU_BUFFER_MEMORY_SIZE		(4 << 20)
+static phys_addr_t ceu_dma_membase;
+
+/* set VIO_CKO clock to 25MHz */
+#define CEU_MCLK_FREQ			25000000
+#define DRVCRB				0xA405018C
 
 static struct mtd_partition kfr2r09_nor_flash_partitions[] =
 {
@@ -230,8 +242,17 @@ static struct platform_device kfr2r09_usb0_gadget_device = {
 	.resource	= kfr2r09_usb0_gadget_resources,
 };
 
-static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
-	.flags = SH_CEU_FLAG_USE_8BIT_BUS,
+static struct ceu_platform_data ceu_pdata = {
+	.num_subdevs			= 1,
+	.subdevs = {
+		{ /* [0] = rj54n1cb0c */
+			.flags		= 0,
+			.bus_width	= 8,
+			.bus_shift	= 0,
+			.i2c_adapter_id	= 1,
+			.i2c_address	= 0x50,
+		},
+	},
 };
 
 static struct resource kfr2r09_ceu_resources[] = {
@@ -246,109 +267,35 @@ static struct resource kfr2r09_ceu_resources[] = {
 		.end	= evt2irq(0x880),
 		.flags  = IORESOURCE_IRQ,
 	},
-	[2] = {
-		/* place holder for contiguous memory */
-	},
 };
 
 static struct platform_device kfr2r09_ceu_device = {
-	.name		= "sh_mobile_ceu",
+	.name		= "renesas-ceu",
 	.id             = 0, /* "ceu0" clock */
 	.num_resources	= ARRAY_SIZE(kfr2r09_ceu_resources),
 	.resource	= kfr2r09_ceu_resources,
 	.dev	= {
-		.platform_data	= &sh_mobile_ceu_info,
+		.platform_data	= &ceu_pdata,
 	},
 };
 
-static struct i2c_board_info kfr2r09_i2c_camera = {
-	I2C_BOARD_INFO("rj54n1cb0c", 0x50),
-};
-
-static struct clk *camera_clk;
-
-/* set VIO_CKO clock to 25MHz */
-#define CEU_MCLK_FREQ 25000000
-
-#define DRVCRB 0xA405018C
-static int camera_power(struct device *dev, int mode)
-{
-	int ret;
-
-	if (mode) {
-		long rate;
-
-		camera_clk = clk_get(NULL, "video_clk");
-		if (IS_ERR(camera_clk))
-			return PTR_ERR(camera_clk);
-
-		rate = clk_round_rate(camera_clk, CEU_MCLK_FREQ);
-		ret = clk_set_rate(camera_clk, rate);
-		if (ret < 0)
-			goto eclkrate;
-
-		/* set DRVCRB
-		 *
-		 * use 1.8 V for VccQ_VIO
-		 * use 2.85V for VccQ_SR
-		 */
-		__raw_writew((__raw_readw(DRVCRB) & ~0x0003) | 0x0001, DRVCRB);
-
-		/* reset clear */
-		ret = gpio_request(GPIO_PTB4, NULL);
-		if (ret < 0)
-			goto eptb4;
-		ret = gpio_request(GPIO_PTB7, NULL);
-		if (ret < 0)
-			goto eptb7;
-
-		ret = gpio_direction_output(GPIO_PTB4, 1);
-		if (!ret)
-			ret = gpio_direction_output(GPIO_PTB7, 1);
-		if (ret < 0)
-			goto egpioout;
-		msleep(1);
-
-		ret = clk_enable(camera_clk);	/* start VIO_CKO */
-		if (ret < 0)
-			goto eclkon;
-
-		return 0;
-	}
-
-	ret = 0;
-
-	clk_disable(camera_clk);
-eclkon:
-	gpio_set_value(GPIO_PTB7, 0);
-egpioout:
-	gpio_set_value(GPIO_PTB4, 0);
-	gpio_free(GPIO_PTB7);
-eptb7:
-	gpio_free(GPIO_PTB4);
-eptb4:
-eclkrate:
-	clk_put(camera_clk);
-	return ret;
-}
-
 static struct rj54n1_pdata rj54n1_priv = {
 	.mclk_freq	= CEU_MCLK_FREQ,
 	.ioctl_high	= false,
 };
 
-static struct soc_camera_link rj54n1_link = {
-	.power		= camera_power,
-	.board_info	= &kfr2r09_i2c_camera,
-	.i2c_adapter_id	= 1,
-	.priv		= &rj54n1_priv,
+static struct i2c_board_info kfr2r09_i2c_camera = {
+	I2C_BOARD_INFO("rj54n1cb0c", 0x50),
+	.platform_data = &rj54n1_priv,
 };
 
-static struct platform_device kfr2r09_camera = {
-	.name	= "soc-camera-pdrv",
-	.id	= 0,
-	.dev	= {
-		.platform_data = &rj54n1_link,
+static struct gpiod_lookup_table rj54n1_gpios = {
+	.dev_id		= "1-0050",
+	.table		= {
+		GPIO_LOOKUP("sh7724_pfc", GPIO_PTB4, "poweron",
+			    GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("sh7724_pfc", GPIO_PTB7, "enable",
+			    GPIO_ACTIVE_HIGH),
 	},
 };
 
@@ -393,8 +340,6 @@ static struct platform_device *kfr2r09_devices[] __initdata = {
 	&kfr2r09_nand_flash_device,
 	&kfr2r09_sh_keysc_device,
 	&kfr2r09_sh_lcdc_device,
-	&kfr2r09_ceu_device,
-	&kfr2r09_camera,
 	&kfr2r09_sh_sdhi0_device,
 };
 
@@ -533,6 +478,8 @@ extern char kfr2r09_sdram_leave_end;
 
 static int __init kfr2r09_devices_setup(void)
 {
+	static struct clk *camera_clk;
+
 	/* register board specific self-refresh code */
 	sh_mobile_register_self_refresh(SUSP_SH_STANDBY | SUSP_SH_SF |
 					SUSP_SH_RSTANDBY,
@@ -622,8 +569,6 @@ static int __init kfr2r09_devices_setup(void)
 	gpio_request(GPIO_FN_VIO0_D1, NULL);
 	gpio_request(GPIO_FN_VIO0_D0, NULL);
 
-	platform_resource_setup_memory(&kfr2r09_ceu_device, "ceu", 4 << 20);
-
 	/* SDHI0 connected to yc304 */
 	gpio_request(GPIO_FN_SDHI0CD, NULL);
 	gpio_request(GPIO_FN_SDHI0D3, NULL);
@@ -635,6 +580,36 @@ static int __init kfr2r09_devices_setup(void)
 
 	i2c_register_board_info(0, &kfr2r09_backlight_board_info, 1);
 
+	/* Set camera clock frequency and register and alias for rj54n1. */
+	camera_clk = clk_get(NULL, "video_clk");
+	if (!IS_ERR(camera_clk)) {
+		clk_set_rate(camera_clk,
+			     clk_round_rate(camera_clk, CEU_MCLK_FREQ));
+		clk_put(camera_clk);
+	}
+	clk_add_alias(NULL, "1-0050", "video_clk", NULL);
+
+	/* set DRVCRB
+	 *
+	 * use 1.8 V for VccQ_VIO
+	 * use 2.85V for VccQ_SR
+	 */
+	__raw_writew((__raw_readw(DRVCRB) & ~0x0003) | 0x0001, DRVCRB);
+
+	gpiod_add_lookup_table(&rj54n1_gpios);
+
+	i2c_register_board_info(1, &kfr2r09_i2c_camera, 1);
+
+	/* Initialize CEU platform device separately to map memory first */
+	device_initialize(&kfr2r09_ceu_device.dev);
+	arch_setup_pdev_archdata(&kfr2r09_ceu_device);
+	dma_declare_coherent_memory(&kfr2r09_ceu_device.dev,
+				    ceu_dma_membase, ceu_dma_membase,
+				    ceu_dma_membase + CEU_BUFFER_MEMORY_SIZE - 1,
+				    DMA_MEMORY_EXCLUSIVE);
+
+	platform_device_add(&kfr2r09_ceu_device);
+
 	return platform_add_devices(kfr2r09_devices,
 				    ARRAY_SIZE(kfr2r09_devices));
 }
@@ -651,10 +626,24 @@ static int kfr2r09_mode_pins(void)
 	return MODE_PIN0 | MODE_PIN1 | MODE_PIN5 | MODE_PIN8;
 }
 
+/* Reserve a portion of memory for CEU buffers */
+static void __init kfr2r09_mv_mem_reserve(void)
+{
+	phys_addr_t phys;
+	phys_addr_t size = CEU_BUFFER_MEMORY_SIZE;
+
+	phys = memblock_alloc_base(size, PAGE_SIZE, MEMBLOCK_ALLOC_ANYWHERE);
+	memblock_free(phys, size);
+	memblock_remove(phys, size);
+
+	ceu_dma_membase = phys;
+}
+
 /*
  * The Machine Vector
  */
 static struct sh_machine_vector mv_kfr2r09 __initmv = {
 	.mv_name		= "kfr2r09",
 	.mv_mode_pins		= kfr2r09_mode_pins,
+	.mv_mem_reserve         = kfr2r09_mv_mem_reserve,
 };
-- 
2.7.4
