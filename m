Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:42093 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940339AbeE1Qhm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 12:37:42 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        sakari.ailus@iki.fi, mchehab@kernel.org,
        ysato@users.sourceforge.jp, dalias@libc.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] arch: sh: ap325rxa: Use new renesas-ceu camera driver
Date: Mon, 28 May 2018 18:37:11 +0200
Message-Id: <1527525431-22852-6-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1527525431-22852-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1527525431-22852-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the new renesas-ceu camera driver in ap325rxa board file instead of
the soc_camera based sh_mobile_ceu_camera driver.

Get rid of soc_camera specific components, and register CEU0 with a single
video sensor (ov7725).

Memory for the CEU video buffers is now reserved with membocks APIs
and need to be declared as dma_coherent during machine initialization to
remove that architecture specific part from CEU driver.

The ap325rxa board file registers another camera (ncm03j) for which I found no
driver in mainline kernel version, and that was configured/probed by sending
i2c messages (of 'magic blobs) from the board file itself. I removed the
sensor registration from this new version as it used soc_camera components
that will be later removed.

While at there update license to SPDX header and sort headers alphabetically.

Compile tested only.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 arch/sh/boards/mach-ap325rxa/setup.c   | 282 +++++++++------------------------
 arch/sh/kernel/cpu/sh4a/clock-sh7723.c |   2 +-
 2 files changed, 80 insertions(+), 204 deletions(-)

diff --git a/arch/sh/boards/mach-ap325rxa/setup.c b/arch/sh/boards/mach-ap325rxa/setup.c
index de8393c..8f234d04 100644
--- a/arch/sh/boards/mach-ap325rxa/setup.c
+++ b/arch/sh/boards/mach-ap325rxa/setup.c
@@ -1,40 +1,45 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Renesas - AP-325RXA
  * (Compatible with Algo System ., LTD. - AP-320A)
  *
  * Copyright (C) 2008 Renesas Solutions Corp.
  * Author : Yusuke Goda <goda.yuske@renesas.com>
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
  */
 
-#include <linux/init.h>
+#include <asm/clock.h>
+#include <asm/io.h>
+#include <asm/suspend.h>
+
+#include <cpu/sh7723.h>
+
+#include <linux/clkdev.h>
+#include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/gpio.h>
+#include <linux/gpio/machine.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
 #include <linux/interrupt.h>
-#include <linux/platform_device.h>
+#include <linux/memblock.h>
+#include <linux/mfd/tmio.h>
 #include <linux/mmc/host.h>
 #include <linux/mtd/physmap.h>
 #include <linux/mtd/sh_flctl.h>
-#include <linux/mfd/tmio.h>
-#include <linux/delay.h>
-#include <linux/i2c.h>
+#include <linux/platform_device.h>
 #include <linux/regulator/fixed.h>
 #include <linux/regulator/machine.h>
+#include <linux/sh_intc.h>
 #include <linux/smsc911x.h>
-#include <linux/gpio.h>
 #include <linux/videodev2.h>
-#include <linux/sh_intc.h>
+
+#include <media/drv-intf/renesas-ceu.h>
 #include <media/i2c/ov772x.h>
-#include <media/soc_camera.h>
-#include <linux/platform_data/media/soc_camera_platform.h>
-#include <media/drv-intf/sh_mobile_ceu.h>
+
 #include <video/sh_mobile_lcdc.h>
-#include <asm/io.h>
-#include <asm/clock.h>
-#include <asm/suspend.h>
-#include <cpu/sh7723.h>
+
+#define CEU_BUFFER_MEMORY_SIZE		(4 << 20)
+static phys_addr_t ceu_dma_membase;
 
 /* Dummy supplies, where voltage doesn't matter */
 static struct regulator_consumer_supply dummy_supplies[] = {
@@ -253,150 +258,25 @@ static struct platform_device lcdc_device = {
 	},
 };
 
-static void camera_power(int val)
-{
-	gpio_set_value(GPIO_PTZ5, val); /* RST_CAM/RSTB */
-	mdelay(10);
-}
-
-#ifdef CONFIG_I2C
-/* support for the old ncm03j camera */
-static unsigned char camera_ncm03j_magic[] =
-{
-	0x87, 0x00, 0x88, 0x08, 0x89, 0x01, 0x8A, 0xE8,
-	0x1D, 0x00, 0x1E, 0x8A, 0x21, 0x00, 0x33, 0x36,
-	0x36, 0x60, 0x37, 0x08, 0x3B, 0x31, 0x44, 0x0F,
-	0x46, 0xF0, 0x4B, 0x28, 0x4C, 0x21, 0x4D, 0x55,
-	0x4E, 0x1B, 0x4F, 0xC7, 0x50, 0xFC, 0x51, 0x12,
-	0x58, 0x02, 0x66, 0xC0, 0x67, 0x46, 0x6B, 0xA0,
-	0x6C, 0x34, 0x7E, 0x25, 0x7F, 0x25, 0x8D, 0x0F,
-	0x92, 0x40, 0x93, 0x04, 0x94, 0x26, 0x95, 0x0A,
-	0x99, 0x03, 0x9A, 0xF0, 0x9B, 0x14, 0x9D, 0x7A,
-	0xC5, 0x02, 0xD6, 0x07, 0x59, 0x00, 0x5A, 0x1A,
-	0x5B, 0x2A, 0x5C, 0x37, 0x5D, 0x42, 0x5E, 0x56,
-	0xC8, 0x00, 0xC9, 0x1A, 0xCA, 0x2A, 0xCB, 0x37,
-	0xCC, 0x42, 0xCD, 0x56, 0xCE, 0x00, 0xCF, 0x1A,
-	0xD0, 0x2A, 0xD1, 0x37, 0xD2, 0x42, 0xD3, 0x56,
-	0x5F, 0x68, 0x60, 0x87, 0x61, 0xA3, 0x62, 0xBC,
-	0x63, 0xD4, 0x64, 0xEA, 0xD6, 0x0F,
-};
-
-static int camera_probe(void)
-{
-	struct i2c_adapter *a = i2c_get_adapter(0);
-	struct i2c_msg msg;
-	int ret;
-
-	if (!a)
-		return -ENODEV;
-
-	camera_power(1);
-	msg.addr = 0x6e;
-	msg.buf = camera_ncm03j_magic;
-	msg.len = 2;
-	msg.flags = 0;
-	ret = i2c_transfer(a, &msg, 1);
-	camera_power(0);
-
-	return ret;
-}
-
-static int camera_set_capture(struct soc_camera_platform_info *info,
-			      int enable)
-{
-	struct i2c_adapter *a = i2c_get_adapter(0);
-	struct i2c_msg msg;
-	int ret = 0;
-	int i;
-
-	camera_power(0);
-	if (!enable)
-		return 0; /* no disable for now */
-
-	camera_power(1);
-	for (i = 0; i < ARRAY_SIZE(camera_ncm03j_magic); i += 2) {
-		u_int8_t buf[8];
-
-		msg.addr = 0x6e;
-		msg.buf = buf;
-		msg.len = 2;
-		msg.flags = 0;
-
-		buf[0] = camera_ncm03j_magic[i];
-		buf[1] = camera_ncm03j_magic[i + 1];
-
-		ret = (ret < 0) ? ret : i2c_transfer(a, &msg, 1);
-	}
-
-	return ret;
-}
-
-static int ap325rxa_camera_add(struct soc_camera_device *icd);
-static void ap325rxa_camera_del(struct soc_camera_device *icd);
-
-static struct soc_camera_platform_info camera_info = {
-	.format_name = "UYVY",
-	.format_depth = 16,
-	.format = {
-		.code = MEDIA_BUS_FMT_UYVY8_2X8,
-		.colorspace = V4L2_COLORSPACE_SMPTE170M,
-		.field = V4L2_FIELD_NONE,
-		.width = 640,
-		.height = 480,
+/* Powerdown/reset gpios for CEU image sensors */
+static struct gpiod_lookup_table ov7725_gpios = {
+	.dev_id		= "0-0021",
+	.table		= {
+		GPIO_LOOKUP("sh7723_pfc", GPIO_PTZ5, "reset", GPIO_ACTIVE_LOW),
 	},
-	.mbus_param = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
-	V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
-	V4L2_MBUS_DATA_ACTIVE_HIGH,
-	.mbus_type = V4L2_MBUS_PARALLEL,
-	.set_capture = camera_set_capture,
-};
-
-static struct soc_camera_link camera_link = {
-	.bus_id		= 0,
-	.add_device	= ap325rxa_camera_add,
-	.del_device	= ap325rxa_camera_del,
-	.module_name	= "soc_camera_platform",
-	.priv		= &camera_info,
 };
 
-static struct platform_device *camera_device;
-
-static void ap325rxa_camera_release(struct device *dev)
-{
-	soc_camera_platform_release(&camera_device);
-}
-
-static int ap325rxa_camera_add(struct soc_camera_device *icd)
-{
-	int ret = soc_camera_platform_add(icd, &camera_device, &camera_link,
-					  ap325rxa_camera_release, 0);
-	if (ret < 0)
-		return ret;
-
-	ret = camera_probe();
-	if (ret < 0)
-		soc_camera_platform_del(icd, camera_device, &camera_link);
-
-	return ret;
-}
-
-static void ap325rxa_camera_del(struct soc_camera_device *icd)
-{
-	soc_camera_platform_del(icd, camera_device, &camera_link);
-}
-#endif /* CONFIG_I2C */
-
-static int ov7725_power(struct device *dev, int mode)
-{
-	camera_power(0);
-	if (mode)
-		camera_power(1);
-
-	return 0;
-}
-
-static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
-	.flags = SH_CEU_FLAG_USE_8BIT_BUS,
+static struct ceu_platform_data ceu0_pdata = {
+	.num_subdevs			= 1,
+	.subdevs = {
+		{ /* [0] = ov7725  */
+			.flags		= 0,
+			.bus_width	= 8,
+			.bus_shift	= 0,
+			.i2c_adapter_id	= 0,
+			.i2c_address	= 0x21,
+		},
+	},
 };
 
 static struct resource ceu_resources[] = {
@@ -410,18 +290,15 @@ static struct resource ceu_resources[] = {
 		.start  = evt2irq(0x880),
 		.flags  = IORESOURCE_IRQ,
 	},
-	[2] = {
-		/* place holder for contiguous memory */
-	},
 };
 
-static struct platform_device ceu_device = {
-	.name		= "sh_mobile_ceu",
-	.id             = 0, /* "ceu0" clock */
+static struct platform_device ap325rxa_ceu_device = {
+	.name		= "renesas-ceu",
+	.id             = 0, /* "ceu.0" clock */
 	.num_resources	= ARRAY_SIZE(ceu_resources),
 	.resource	= ceu_resources,
 	.dev		= {
-		.platform_data	= &sh_mobile_ceu_info,
+		.platform_data	= &ceu0_pdata,
 	},
 };
 
@@ -488,44 +365,18 @@ static struct platform_device sdhi1_cn7_device = {
 	},
 };
 
-static struct i2c_board_info __initdata ap325rxa_i2c_devices[] = {
-	{
-		I2C_BOARD_INFO("pcf8563", 0x51),
-	},
-};
-
-static struct i2c_board_info ap325rxa_i2c_camera[] = {
-	{
-		I2C_BOARD_INFO("ov772x", 0x21),
-	},
-};
-
 static struct ov772x_camera_info ov7725_info = {
 	.flags		= OV772X_FLAG_VFLIP | OV772X_FLAG_HFLIP,
 	.edgectrl	= OV772X_AUTO_EDGECTRL(0xf, 0),
 };
 
-static struct soc_camera_link ov7725_link = {
-	.bus_id		= 0,
-	.power		= ov7725_power,
-	.board_info	= &ap325rxa_i2c_camera[0],
-	.i2c_adapter_id	= 0,
-	.priv		= &ov7725_info,
-};
-
-static struct platform_device ap325rxa_camera[] = {
+static struct i2c_board_info ap325rxa_i2c_devices[] __initdata = {
 	{
-		.name	= "soc-camera-pdrv",
-		.id	= 0,
-		.dev	= {
-			.platform_data = &ov7725_link,
-		},
-	}, {
-		.name	= "soc-camera-pdrv",
-		.id	= 1,
-		.dev	= {
-			.platform_data = &camera_link,
-		},
+		I2C_BOARD_INFO("pcf8563", 0x51),
+	},
+	{
+		I2C_BOARD_INFO("ov772x", 0x21),
+		.platform_data = &ov7725_info,
 	},
 };
 
@@ -533,12 +384,9 @@ static struct platform_device *ap325rxa_devices[] __initdata = {
 	&smsc9118_device,
 	&ap325rxa_nor_flash_device,
 	&lcdc_device,
-	&ceu_device,
 	&nand_flash_device,
 	&sdhi0_cn3_device,
 	&sdhi1_cn7_device,
-	&ap325rxa_camera[0],
-	&ap325rxa_camera[1],
 };
 
 extern char ap325rxa_sdram_enter_start;
@@ -649,8 +497,6 @@ static int __init ap325rxa_devices_setup(void)
 	__raw_writew(0xFFFF, PORT_DRVCRA);
 	__raw_writew(0xFFFF, PORT_DRVCRB);
 
-	platform_resource_setup_memory(&ceu_device, "ceu", 4 << 20);
-
 	/* SDHI0 - CN3 - SD CARD */
 	gpio_request(GPIO_FN_SDHI0CD_PTD, NULL);
 	gpio_request(GPIO_FN_SDHI0WP_PTD, NULL);
@@ -670,9 +516,25 @@ static int __init ap325rxa_devices_setup(void)
 	gpio_request(GPIO_FN_SDHI1CMD, NULL);
 	gpio_request(GPIO_FN_SDHI1CLK, NULL);
 
+	/* Add a clock alias for ov7725 xclk source. */
+	clk_add_alias(NULL, "0-0021", "video_clk", NULL);
+
+	/* Register RSTB gpio for ov7725 camera sensor. */
+	gpiod_add_lookup_table(&ov7725_gpios);
+
 	i2c_register_board_info(0, ap325rxa_i2c_devices,
 				ARRAY_SIZE(ap325rxa_i2c_devices));
 
+	/* Initialize CEU platform device separately to map memory first */
+	device_initialize(&ap325rxa_ceu_device.dev);
+	arch_setup_pdev_archdata(&ap325rxa_ceu_device);
+	dma_declare_coherent_memory(&ap325rxa_ceu_device.dev,
+				    ceu_dma_membase, ceu_dma_membase,
+				    ceu_dma_membase + CEU_BUFFER_MEMORY_SIZE - 1,
+				    DMA_MEMORY_EXCLUSIVE);
+
+	platform_device_add(&ap325rxa_ceu_device);
+
 	return platform_add_devices(ap325rxa_devices,
 				ARRAY_SIZE(ap325rxa_devices));
 }
@@ -689,7 +551,21 @@ static int ap325rxa_mode_pins(void)
 	return MODE_PIN5 | MODE_PIN8;
 }
 
+/* Reserve a portion of memory for CEU buffers */
+static void __init ap325rxa_mv_mem_reserve(void)
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
 static struct sh_machine_vector mv_ap325rxa __initmv = {
 	.mv_name = "AP-325RXA",
 	.mv_mode_pins = ap325rxa_mode_pins,
+	.mv_mem_reserve	= ap325rxa_mv_mem_reserve,
 };
diff --git a/arch/sh/kernel/cpu/sh4a/clock-sh7723.c b/arch/sh/kernel/cpu/sh4a/clock-sh7723.c
index fe84422..af01664 100644
--- a/arch/sh/kernel/cpu/sh4a/clock-sh7723.c
+++ b/arch/sh/kernel/cpu/sh4a/clock-sh7723.c
@@ -260,7 +260,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_CON_ID("veu1", &mstp_clks[HWBLK_VEU2H1]),
 	CLKDEV_DEV_ID("sh-vou.0", &mstp_clks[HWBLK_VOU]),
 	CLKDEV_CON_ID("beu0", &mstp_clks[HWBLK_BEU]),
-	CLKDEV_DEV_ID("sh_mobile_ceu.0", &mstp_clks[HWBLK_CEU]),
+	CLKDEV_DEV_ID("ceu.0", &mstp_clks[HWBLK_CEU]),
 	CLKDEV_CON_ID("veu0", &mstp_clks[HWBLK_VEU2H0]),
 	CLKDEV_CON_ID("vpu0", &mstp_clks[HWBLK_VPU]),
 
-- 
2.7.4
