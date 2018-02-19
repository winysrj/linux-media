Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:53275 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753486AbeBSRHW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 12:07:22 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, hverkuil@xs4all.nl, mchehab@kernel.org,
        festevam@gmail.com, sakari.ailus@iki.fi, robh+dt@kernel.org,
        mark.rutland@arm.com, pombredanne@nexb.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v9 10/11] arch: sh: migor: Use new renesas-ceu camera driver
Date: Mon, 19 Feb 2018 17:59:43 +0100
Message-Id: <1519059584-30844-11-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1519059584-30844-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1519059584-30844-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Migo-R platform uses sh_mobile_ceu camera driver, which is now being
replaced by a proper V4L2 camera driver named 'renesas-ceu'.

Move Migo-R platform to use the v4l2 renesas-ceu camera driver
interface and get rid of soc_camera defined components used to register
sensor drivers and of platform specific enable/disable routines.

Register clock source and GPIOs for sensor drivers, so they can use
clock and gpio APIs.

Also, memory for CEU video buffers is now reserved with membocks APIs,
and need to be declared as dma_coherent during machine initialization to
remove that architecture specific part from CEU driver.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 arch/sh/boards/mach-migor/setup.c      | 225 +++++++++++++++------------------
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c |   2 +-
 2 files changed, 101 insertions(+), 126 deletions(-)

diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index 0bcbe58..271dfc2 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -1,17 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Renesas System Solutions Asia Pte. Ltd - Migo-R
  *
  * Copyright (C) 2008 Magnus Damm
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
  */
+#include <linux/clkdev.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/input.h>
 #include <linux/input/sh_keysc.h>
+#include <linux/memblock.h>
 #include <linux/mmc/host.h>
 #include <linux/mtd/physmap.h>
 #include <linux/mfd/tmio.h>
@@ -23,10 +22,11 @@
 #include <linux/delay.h>
 #include <linux/clk.h>
 #include <linux/gpio.h>
+#include <linux/gpio/machine.h>
 #include <linux/videodev2.h>
 #include <linux/sh_intc.h>
 #include <video/sh_mobile_lcdc.h>
-#include <media/drv-intf/sh_mobile_ceu.h>
+#include <media/drv-intf/renesas-ceu.h>
 #include <media/i2c/ov772x.h>
 #include <media/soc_camera.h>
 #include <media/i2c/tw9910.h>
@@ -45,6 +45,9 @@
  * 0x18000000       8GB    8   NAND Flash (K9K8G08U0A)
  */
 
+#define CEU_BUFFER_MEMORY_SIZE		(4 << 20)
+static phys_addr_t ceu_dma_membase;
+
 static struct smc91x_platdata smc91x_info = {
 	.flags = SMC91X_USE_16BIT | SMC91X_NOWAIT,
 };
@@ -301,65 +304,24 @@ static struct platform_device migor_lcdc_device = {
 	},
 };
 
-static struct clk *camera_clk;
-static DEFINE_MUTEX(camera_lock);
-
-static void camera_power_on(int is_tw)
-{
-	mutex_lock(&camera_lock);
-
-	/* Use 10 MHz VIO_CKO instead of 24 MHz to work
-	 * around signal quality issues on Panel Board V2.1.
-	 */
-	camera_clk = clk_get(NULL, "video_clk");
-	clk_set_rate(camera_clk, 10000000);
-	clk_enable(camera_clk);	/* start VIO_CKO */
-
-	/* use VIO_RST to take camera out of reset */
-	mdelay(10);
-	if (is_tw) {
-		gpio_set_value(GPIO_PTT2, 0);
-		gpio_set_value(GPIO_PTT0, 0);
-	} else {
-		gpio_set_value(GPIO_PTT0, 1);
-	}
-	gpio_set_value(GPIO_PTT3, 0);
-	mdelay(10);
-	gpio_set_value(GPIO_PTT3, 1);
-	mdelay(10); /* wait to let chip come out of reset */
-}
-
-static void camera_power_off(void)
-{
-	clk_disable(camera_clk); /* stop VIO_CKO */
-	clk_put(camera_clk);
-
-	gpio_set_value(GPIO_PTT3, 0);
-	mutex_unlock(&camera_lock);
-}
-
-static int ov7725_power(struct device *dev, int mode)
-{
-	if (mode)
-		camera_power_on(0);
-	else
-		camera_power_off();
-
-	return 0;
-}
-
-static int tw9910_power(struct device *dev, int mode)
-{
-	if (mode)
-		camera_power_on(1);
-	else
-		camera_power_off();
-
-	return 0;
-}
-
-static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
-	.flags = SH_CEU_FLAG_USE_8BIT_BUS,
+static struct ceu_platform_data ceu_pdata = {
+	.num_subdevs			= 2,
+	.subdevs = {
+		{ /* [0] = ov772x */
+			.flags		= 0,
+			.bus_width	= 8,
+			.bus_shift	= 0,
+			.i2c_adapter_id	= 0,
+			.i2c_address	= 0x21,
+		},
+		{ /* [1] = tw9910 */
+			.flags		= 0,
+			.bus_width	= 8,
+			.bus_shift	= 0,
+			.i2c_adapter_id	= 0,
+			.i2c_address	= 0x45,
+		},
+	},
 };
 
 static struct resource migor_ceu_resources[] = {
@@ -373,18 +335,32 @@ static struct resource migor_ceu_resources[] = {
 		.start  = evt2irq(0x880),
 		.flags  = IORESOURCE_IRQ,
 	},
-	[2] = {
-		/* place holder for contiguous memory */
-	},
 };
 
 static struct platform_device migor_ceu_device = {
-	.name		= "sh_mobile_ceu",
-	.id             = 0, /* "ceu0" clock */
+	.name		= "renesas-ceu",
+	.id             = 0, /* ceu.0 */
 	.num_resources	= ARRAY_SIZE(migor_ceu_resources),
 	.resource	= migor_ceu_resources,
 	.dev	= {
-		.platform_data	= &sh_mobile_ceu_info,
+		.platform_data	= &ceu_pdata,
+	},
+};
+
+/* Powerdown/reset gpios for CEU image sensors */
+static struct gpiod_lookup_table ov7725_gpios = {
+	.dev_id		= "0-0021",
+	.table		= {
+		GPIO_LOOKUP("sh7722_pfc", GPIO_PTT0, "pwdn", GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("sh7722_pfc", GPIO_PTT3, "rstb", GPIO_ACTIVE_LOW),
+	},
+};
+
+static struct gpiod_lookup_table tw9910_gpios = {
+	.dev_id		= "0-0045",
+	.table		= {
+		GPIO_LOOKUP("sh7722_pfc", GPIO_PTT2, "pdn", GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("sh7722_pfc", GPIO_PTT3, "rstb", GPIO_ACTIVE_LOW),
 	},
 };
 
@@ -423,6 +399,15 @@ static struct platform_device sdhi_cn9_device = {
 	},
 };
 
+static struct ov772x_camera_info ov7725_info = {
+	.flags		= 0,
+};
+
+static struct tw9910_video_info tw9910_info = {
+	.buswidth       = 8,
+	.mpout          = TW9910_MPO_FIELD,
+};
+
 static struct i2c_board_info migor_i2c_devices[] = {
 	{
 		I2C_BOARD_INFO("rs5c372b", 0x32),
@@ -434,51 +419,13 @@ static struct i2c_board_info migor_i2c_devices[] = {
 	{
 		I2C_BOARD_INFO("wm8978", 0x1a),
 	},
-};
-
-static struct i2c_board_info migor_i2c_camera[] = {
 	{
 		I2C_BOARD_INFO("ov772x", 0x21),
+		.platform_data = &ov7725_info,
 	},
 	{
 		I2C_BOARD_INFO("tw9910", 0x45),
-	},
-};
-
-static struct ov772x_camera_info ov7725_info;
-
-static struct soc_camera_link ov7725_link = {
-	.power		= ov7725_power,
-	.board_info	= &migor_i2c_camera[0],
-	.i2c_adapter_id	= 0,
-	.priv		= &ov7725_info,
-};
-
-static struct tw9910_video_info tw9910_info = {
-	.buswidth	= SOCAM_DATAWIDTH_8,
-	.mpout		= TW9910_MPO_FIELD,
-};
-
-static struct soc_camera_link tw9910_link = {
-	.power		= tw9910_power,
-	.board_info	= &migor_i2c_camera[1],
-	.i2c_adapter_id	= 0,
-	.priv		= &tw9910_info,
-};
-
-static struct platform_device migor_camera[] = {
-	{
-		.name	= "soc-camera-pdrv",
-		.id	= 0,
-		.dev	= {
-			.platform_data = &ov7725_link,
-		},
-	}, {
-		.name	= "soc-camera-pdrv",
-		.id	= 1,
-		.dev	= {
-			.platform_data = &tw9910_link,
-		},
+		.platform_data = &tw9910_info,
 	},
 };
 
@@ -486,12 +433,9 @@ static struct platform_device *migor_devices[] __initdata = {
 	&smc91x_eth_device,
 	&sh_keysc_device,
 	&migor_lcdc_device,
-	&migor_ceu_device,
 	&migor_nor_flash_device,
 	&migor_nand_flash_device,
 	&sdhi_cn9_device,
-	&migor_camera[0],
-	&migor_camera[1],
 };
 
 extern char migor_sdram_enter_start;
@@ -501,6 +445,8 @@ extern char migor_sdram_leave_end;
 
 static int __init migor_devices_setup(void)
 {
+	struct clk *video_clk;
+
 	/* register board specific self-refresh code */
 	sh_mobile_register_self_refresh(SUSP_SH_STANDBY | SUSP_SH_SF,
 					&migor_sdram_enter_start,
@@ -620,20 +566,8 @@ static int __init migor_devices_setup(void)
 	gpio_request(GPIO_FN_VIO_D9, NULL);
 	gpio_request(GPIO_FN_VIO_D8, NULL);
 
-	gpio_request(GPIO_PTT3, NULL); /* VIO_RST */
-	gpio_direction_output(GPIO_PTT3, 0);
-	gpio_request(GPIO_PTT2, NULL); /* TV_IN_EN */
-	gpio_direction_output(GPIO_PTT2, 1);
-	gpio_request(GPIO_PTT0, NULL); /* CAM_EN */
-#ifdef CONFIG_SH_MIGOR_RTA_WVGA
-	gpio_direction_output(GPIO_PTT0, 0);
-#else
-	gpio_direction_output(GPIO_PTT0, 1);
-#endif
 	__raw_writew(__raw_readw(PORT_MSELCRB) | 0x2000, PORT_MSELCRB); /* D15->D8 */
 
-	platform_resource_setup_memory(&migor_ceu_device, "ceu", 4 << 20);
-
 	/* SIU: Port B */
 	gpio_request(GPIO_FN_SIUBOLR, NULL);
 	gpio_request(GPIO_FN_SIUBOBT, NULL);
@@ -647,9 +581,36 @@ static int __init migor_devices_setup(void)
 	 */
 	__raw_writew(__raw_readw(PORT_MSELCRA) | 1, PORT_MSELCRA);
 
+	 /*
+	  * Use 10 MHz VIO_CKO instead of 24 MHz to work around signal quality
+	  * issues on Panel Board V2.1.
+	  */
+	video_clk = clk_get(NULL, "video_clk");
+	if (!IS_ERR(video_clk)) {
+		clk_set_rate(video_clk, clk_round_rate(video_clk, 10000000));
+		clk_put(video_clk);
+	}
+
+	/* Add a clock alias for ov7725 xclk source. */
+	clk_add_alias("xclk", "0-0021", "video_clk", NULL);
+
+	/* Register GPIOs for video sources. */
+	gpiod_add_lookup_table(&ov7725_gpios);
+	gpiod_add_lookup_table(&tw9910_gpios);
+
 	i2c_register_board_info(0, migor_i2c_devices,
 				ARRAY_SIZE(migor_i2c_devices));
 
+	/* Initialize CEU platform device separately to map memory first */
+	device_initialize(&migor_ceu_device.dev);
+	arch_setup_pdev_archdata(&migor_ceu_device);
+	dma_declare_coherent_memory(&migor_ceu_device.dev,
+				    ceu_dma_membase, ceu_dma_membase,
+				    ceu_dma_membase + CEU_BUFFER_MEMORY_SIZE - 1,
+				    DMA_MEMORY_EXCLUSIVE);
+
+	platform_device_add(&migor_ceu_device);
+
 	return platform_add_devices(migor_devices, ARRAY_SIZE(migor_devices));
 }
 arch_initcall(migor_devices_setup);
@@ -665,10 +626,24 @@ static int migor_mode_pins(void)
 	return MODE_PIN0 | MODE_PIN1 | MODE_PIN5;
 }
 
+/* Reserve a portion of memory for CEU buffers */
+static void __init migor_mv_mem_reserve(void)
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
 static struct sh_machine_vector mv_migor __initmv = {
 	.mv_name		= "Migo-R",
 	.mv_mode_pins		= migor_mode_pins,
+	.mv_mem_reserve		= migor_mv_mem_reserve,
 };
diff --git a/arch/sh/kernel/cpu/sh4a/clock-sh7722.c b/arch/sh/kernel/cpu/sh4a/clock-sh7722.c
index 8f07a1a..d85091e 100644
--- a/arch/sh/kernel/cpu/sh4a/clock-sh7722.c
+++ b/arch/sh/kernel/cpu/sh4a/clock-sh7722.c
@@ -223,7 +223,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_DEV_ID("sh-vou.0", &mstp_clks[HWBLK_VOU]),
 	CLKDEV_CON_ID("jpu0", &mstp_clks[HWBLK_JPU]),
 	CLKDEV_CON_ID("beu0", &mstp_clks[HWBLK_BEU]),
-	CLKDEV_DEV_ID("sh_mobile_ceu.0", &mstp_clks[HWBLK_CEU]),
+	CLKDEV_DEV_ID("renesas-ceu.0", &mstp_clks[HWBLK_CEU]),
 	CLKDEV_CON_ID("veu0", &mstp_clks[HWBLK_VEU]),
 	CLKDEV_CON_ID("vpu0", &mstp_clks[HWBLK_VPU]),
 	CLKDEV_DEV_ID("sh_mobile_lcdc_fb.0", &mstp_clks[HWBLK_LCDC]),
-- 
2.7.4
