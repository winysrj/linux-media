Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46107 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936696AbeCBQgb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 11:36:31 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        sakari.ailus@iki.fi, mchehab@kernel.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] arch: sh: ecovec: Use new renesas-ceu camera driver
Date: Fri,  2 Mar 2018 17:35:40 +0100
Message-Id: <1520008541-3961-5-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1520008541-3961-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1520008541-3961-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SH4 7724 Ecovec platform uses sh_mobile_ceu camera driver, which is now
being replaced by a proper V4L2 camera driver named 'renesas-ceu'.

Get rid of soc_camera defined components used to register sensor drivers
and of platform specific enable/disable routines.

Register GPIOs for sensor drivers and declare memory reserved with
memblock APIs as dma capable to be used for CEU buffers.

While at there re-order include directives to respect alphabetical
ordering.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 arch/sh/boards/mach-ecovec24/setup.c   | 338 ++++++++++++++++-----------------
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c |   4 +-
 2 files changed, 171 insertions(+), 171 deletions(-)

diff --git a/arch/sh/boards/mach-ecovec24/setup.c b/arch/sh/boards/mach-ecovec24/setup.c
index 6f929ab..adc61d1 100644
--- a/arch/sh/boards/mach-ecovec24/setup.c
+++ b/arch/sh/boards/mach-ecovec24/setup.c
@@ -7,44 +7,47 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  */
-
-#include <linux/init.h>
+#include <asm/clock.h>
+#include <asm/heartbeat.h>
+#include <asm/suspend.h>
+#include <cpu/sh7724.h>
+#include <linux/delay.h>
 #include <linux/device.h>
-#include <linux/platform_device.h>
+#include <linux/i2c.h>
+#include <linux/io.h>
+#include <linux/init.h>
+#include <linux/input.h>
+#include <linux/input/sh_keysc.h>
+#include <linux/interrupt.h>
+#include <linux/memblock.h>
+#include <linux/mfd/tmio.h>
 #include <linux/mmc/host.h>
 #include <linux/mmc/sh_mmcif.h>
 #include <linux/mtd/physmap.h>
-#include <linux/mfd/tmio.h>
 #include <linux/gpio.h>
-#include <linux/interrupt.h>
-#include <linux/io.h>
-#include <linux/delay.h>
+#include <linux/gpio/machine.h>
+#include <linux/platform_data/gpio_backlight.h>
+#include <linux/platform_data/tsc2007.h>
+#include <linux/platform_device.h>
 #include <linux/regulator/fixed.h>
 #include <linux/regulator/machine.h>
-#include <linux/usb/r8a66597.h>
-#include <linux/usb/renesas_usbhs.h>
-#include <linux/i2c.h>
-#include <linux/platform_data/tsc2007.h>
-#include <linux/spi/spi.h>
-#include <linux/spi/sh_msiof.h>
-#include <linux/spi/mmc_spi.h>
-#include <linux/input.h>
-#include <linux/input/sh_keysc.h>
-#include <linux/platform_data/gpio_backlight.h>
 #include <linux/sh_eth.h>
 #include <linux/sh_intc.h>
+#include <linux/spi/mmc_spi.h>
+#include <linux/spi/sh_msiof.h>
+#include <linux/spi/spi.h>
+#include <linux/usb/r8a66597.h>
+#include <linux/usb/renesas_usbhs.h>
 #include <linux/videodev2.h>
-#include <video/sh_mobile_lcdc.h>
+
+#include <media/drv-intf/renesas-ceu.h>
+#include <media/i2c/mt9t112.h>
+#include <media/i2c/tw9910.h>
+
 #include <sound/sh_fsi.h>
 #include <sound/simple_card.h>
-#include <media/drv-intf/sh_mobile_ceu.h>
-#include <media/soc_camera.h>
-#include <media/i2c/tw9910.h>
-#include <media/i2c/mt9t112.h>
-#include <asm/heartbeat.h>
-#include <asm/clock.h>
-#include <asm/suspend.h>
-#include <cpu/sh7724.h>
+
+#include <video/sh_mobile_lcdc.h>
 
 /*
  *  Address      Interface        BusWidth
@@ -81,6 +84,10 @@
  * amixer set 'Out Mixer Right DAC Right' on
  */
 
+#define CEU_BUFFER_MEMORY_SIZE		(4 << 20)
+static phys_addr_t ceu0_dma_membase;
+static phys_addr_t ceu1_dma_membase;
+
 /* Heartbeat */
 static unsigned char led_pos[] = { 0, 1, 2, 3 };
 
@@ -382,8 +389,24 @@ static struct platform_device gpio_backlight_device = {
 };
 
 /* CEU0 */
-static struct sh_mobile_ceu_info sh_mobile_ceu0_info = {
-	.flags = SH_CEU_FLAG_USE_8BIT_BUS,
+static struct ceu_platform_data ceu0_pdata = {
+	.num_subdevs			= 2,
+	.subdevs = {
+		{ /* [0] = mt9t112  */
+			.flags		= 0,
+			.bus_width	= 8,
+			.bus_shift	= 0,
+			.i2c_adapter_id	= 0,
+			.i2c_address	= 0x3c,
+		},
+		{ /* [1] = tw9910  */
+			.flags		= 0,
+			.bus_width	= 8,
+			.bus_shift	= 0,
+			.i2c_adapter_id	= 0,
+			.i2c_address	= 0x45,
+		},
+	},
 };
 
 static struct resource ceu0_resources[] = {
@@ -397,24 +420,30 @@ static struct resource ceu0_resources[] = {
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
+	.id             = 0, /* ceu.0 */
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
+	.num_subdevs			= 1,
+	.subdevs = {
+		{ /* [0] = mt9t112  */
+			.flags		= 0,
+			.bus_width	= 8,
+			.bus_shift	= 0,
+			.i2c_adapter_id	= 1,
+			.i2c_address	= 0x3c,
+		},
+	},
 };
 
 static struct resource ceu1_resources[] = {
@@ -428,26 +457,71 @@ static struct resource ceu1_resources[] = {
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
+	.id             = 1, /* ceu.1 */
 	.num_resources	= ARRAY_SIZE(ceu1_resources),
 	.resource	= ceu1_resources,
 	.dev	= {
-		.platform_data	= &sh_mobile_ceu1_info,
+		.platform_data	= &ceu1_pdata,
+	},
+};
+
+/* Power up/down GPIOs for camera devices and video decoder */
+static struct gpiod_lookup_table tw9910_gpios = {
+	.dev_id		= "0-0045",
+	.table		= {
+		GPIO_LOOKUP("sh7724_pfc", GPIO_PTU2, "pdn", GPIO_ACTIVE_HIGH),
+	},
+};
+
+static struct gpiod_lookup_table mt9t112_0_gpios = {
+	.dev_id		= "0-003c",
+	.table		= {
+		GPIO_LOOKUP("sh7724_pfc", GPIO_PTA3, "standby",
+			    GPIO_ACTIVE_HIGH),
+	},
+};
+
+static struct gpiod_lookup_table mt9t112_1_gpios = {
+	.dev_id		= "1-003c",
+	.table		= {
+		GPIO_LOOKUP("sh7724_pfc", GPIO_PTA4, "standby",
+			    GPIO_ACTIVE_HIGH),
 	},
 };
 
 /* I2C device */
+static struct tw9910_video_info tw9910_info = {
+	.buswidth	= 8,
+	.mpout		= TW9910_MPO_FIELD,
+};
+
+static struct mt9t112_platform_data mt9t112_0_pdata = {
+	.flags = MT9T112_FLAG_PCLK_RISING_EDGE,
+	.divider = { 0x49, 0x6, 0, 6, 0, 9, 9, 6, 0 }, /* for 24MHz */
+};
+
+static struct mt9t112_platform_data mt9t112_1_pdata = {
+	.flags = MT9T112_FLAG_PCLK_RISING_EDGE,
+	.divider = { 0x49, 0x6, 0, 6, 0, 9, 9, 6, 0 }, /* for 24MHz */
+};
+
 static struct i2c_board_info i2c0_devices[] = {
 	{
 		I2C_BOARD_INFO("da7210", 0x1a),
 	},
+	{
+		I2C_BOARD_INFO("tw9910", 0x45),
+		.platform_data = &tw9910_info,
+	},
+	{
+		/* 1st camera */
+		I2C_BOARD_INFO("mt9t112", 0x3c),
+		.platform_data = &mt9t112_0_pdata,
+	},
 };
 
 static struct i2c_board_info i2c1_devices[] = {
@@ -457,7 +531,12 @@ static struct i2c_board_info i2c1_devices[] = {
 	{
 		I2C_BOARD_INFO("lis3lv02d", 0x1c),
 		.irq = evt2irq(0x620),
-	}
+	},
+	{
+		/* 2nd camera */
+		I2C_BOARD_INFO("mt9t112", 0x3c),
+		.platform_data = &mt9t112_1_pdata,
+	},
 };
 
 /* KEYSC */
@@ -724,115 +803,6 @@ static struct platform_device msiof0_device = {
 
 #endif
 
-/* I2C Video/Camera */
-static struct i2c_board_info i2c_camera[] = {
-	{
-		I2C_BOARD_INFO("tw9910", 0x45),
-	},
-	{
-		/* 1st camera */
-		I2C_BOARD_INFO("mt9t112", 0x3c),
-	},
-	{
-		/* 2nd camera */
-		I2C_BOARD_INFO("mt9t112", 0x3c),
-	},
-};
-
-/* tw9910 */
-static int tw9910_power(struct device *dev, int mode)
-{
-	int val = mode ? 0 : 1;
-
-	gpio_set_value(GPIO_PTU2, val);
-	if (mode)
-		mdelay(100);
-
-	return 0;
-}
-
-static struct tw9910_video_info tw9910_info = {
-	.buswidth	= SOCAM_DATAWIDTH_8,
-	.mpout		= TW9910_MPO_FIELD,
-};
-
-static struct soc_camera_link tw9910_link = {
-	.i2c_adapter_id	= 0,
-	.bus_id		= 1,
-	.power		= tw9910_power,
-	.board_info	= &i2c_camera[0],
-	.priv		= &tw9910_info,
-};
-
-/* mt9t112 */
-static int mt9t112_power1(struct device *dev, int mode)
-{
-	gpio_set_value(GPIO_PTA3, mode);
-	if (mode)
-		mdelay(100);
-
-	return 0;
-}
-
-static struct mt9t112_camera_info mt9t112_info1 = {
-	.flags = MT9T112_FLAG_PCLK_RISING_EDGE | MT9T112_FLAG_DATAWIDTH_8,
-	.divider = { 0x49, 0x6, 0, 6, 0, 9, 9, 6, 0 }, /* for 24MHz */
-};
-
-static struct soc_camera_link mt9t112_link1 = {
-	.i2c_adapter_id	= 0,
-	.power		= mt9t112_power1,
-	.bus_id		= 0,
-	.board_info	= &i2c_camera[1],
-	.priv		= &mt9t112_info1,
-};
-
-static int mt9t112_power2(struct device *dev, int mode)
-{
-	gpio_set_value(GPIO_PTA4, mode);
-	if (mode)
-		mdelay(100);
-
-	return 0;
-}
-
-static struct mt9t112_camera_info mt9t112_info2 = {
-	.flags = MT9T112_FLAG_PCLK_RISING_EDGE | MT9T112_FLAG_DATAWIDTH_8,
-	.divider = { 0x49, 0x6, 0, 6, 0, 9, 9, 6, 0 }, /* for 24MHz */
-};
-
-static struct soc_camera_link mt9t112_link2 = {
-	.i2c_adapter_id	= 1,
-	.power		= mt9t112_power2,
-	.bus_id		= 1,
-	.board_info	= &i2c_camera[2],
-	.priv		= &mt9t112_info2,
-};
-
-static struct platform_device camera_devices[] = {
-	{
-		.name	= "soc-camera-pdrv",
-		.id	= 0,
-		.dev	= {
-			.platform_data = &tw9910_link,
-		},
-	},
-	{
-		.name	= "soc-camera-pdrv",
-		.id	= 1,
-		.dev	= {
-			.platform_data = &mt9t112_link1,
-		},
-	},
-	{
-		.name	= "soc-camera-pdrv",
-		.id	= 2,
-		.dev	= {
-			.platform_data = &mt9t112_link2,
-		},
-	},
-};
-
 /* FSI */
 static struct resource fsi_resources[] = {
 	[0] = {
@@ -979,6 +949,11 @@ static struct platform_device sh_mmcif_device = {
 };
 #endif
 
+static struct platform_device *ecovec_ceu_devices[] __initdata = {
+	&ceu0_device,
+	&ceu1_device,
+};
+
 static struct platform_device *ecovec_devices[] __initdata = {
 	&heartbeat_device,
 	&nor_flash_device,
@@ -988,8 +963,6 @@ static struct platform_device *ecovec_devices[] __initdata = {
 	&usbhs_device,
 	&lcdc_device,
 	&gpio_backlight_device,
-	&ceu0_device,
-	&ceu1_device,
 	&keysc_device,
 	&cn12_power,
 #if defined(CONFIG_MMC_SDHI) || defined(CONFIG_MMC_SDHI_MODULE)
@@ -1001,9 +974,6 @@ static struct platform_device *ecovec_devices[] __initdata = {
 #else
 	&msiof0_device,
 #endif
-	&camera_devices[0],
-	&camera_devices[1],
-	&camera_devices[2],
 	&fsi_device,
 	&fsi_da7210_device,
 	&irda_device,
@@ -1240,7 +1210,6 @@ static int __init arch_setup(void)
 	gpio_request(GPIO_FN_VIO0_CLK, NULL);
 	gpio_request(GPIO_FN_VIO0_FLD, NULL);
 	gpio_request(GPIO_FN_VIO0_HD,  NULL);
-	platform_resource_setup_memory(&ceu0_device, "ceu0", 4 << 20);
 
 	/* enable CEU1 */
 	gpio_request(GPIO_FN_VIO1_D7,  NULL);
@@ -1255,7 +1224,6 @@ static int __init arch_setup(void)
 	gpio_request(GPIO_FN_VIO1_HD,  NULL);
 	gpio_request(GPIO_FN_VIO1_VD,  NULL);
 	gpio_request(GPIO_FN_VIO1_CLK, NULL);
-	platform_resource_setup_memory(&ceu1_device, "ceu1", 4 << 20);
 
 	/* enable KEYSC */
 	gpio_request(GPIO_FN_KEYOUT5_IN5, NULL);
@@ -1332,16 +1300,6 @@ static int __init arch_setup(void)
 		__raw_writew((__raw_readw(IODRIVEA) & ~0x3000) | 0x2000,
 			     IODRIVEA);
 
-	/* enable Video */
-	gpio_request(GPIO_PTU2, NULL);
-	gpio_direction_output(GPIO_PTU2, 1);
-
-	/* enable Camera */
-	gpio_request(GPIO_PTA3, NULL);
-	gpio_request(GPIO_PTA4, NULL);
-	gpio_direction_output(GPIO_PTA3, 0);
-	gpio_direction_output(GPIO_PTA4, 0);
-
 	/* enable FSI */
 	gpio_request(GPIO_FN_FSIMCKB,    NULL);
 	gpio_request(GPIO_FN_FSIIBSD,    NULL);
@@ -1390,6 +1348,11 @@ static int __init arch_setup(void)
 	gpio_request(GPIO_PTU5, NULL);
 	gpio_direction_output(GPIO_PTU5, 0);
 
+	/* Register gpio lookup tables for cameras and video decoder */
+	gpiod_add_lookup_table(&tw9910_gpios);
+	gpiod_add_lookup_table(&mt9t112_0_gpios);
+	gpiod_add_lookup_table(&mt9t112_1_gpios);
+
 	/* enable I2C device */
 	i2c_register_board_info(0, i2c0_devices,
 				ARRAY_SIZE(i2c0_devices));
@@ -1431,6 +1394,25 @@ static int __init arch_setup(void)
 	gpio_set_value(GPIO_PTG4, 1);
 #endif
 
+	/* Initialize CEU platform devices separately to map memory first */
+	device_initialize(&ecovec_ceu_devices[0]->dev);
+	arch_setup_pdev_archdata(ecovec_ceu_devices[0]);
+	dma_declare_coherent_memory(&ecovec_ceu_devices[0]->dev,
+				    ceu0_dma_membase, ceu0_dma_membase,
+				    ceu0_dma_membase +
+				    CEU_BUFFER_MEMORY_SIZE - 1,
+				    DMA_MEMORY_EXCLUSIVE);
+	platform_device_add(ecovec_ceu_devices[0]);
+
+	device_initialize(&ecovec_ceu_devices[1]->dev);
+	arch_setup_pdev_archdata(ecovec_ceu_devices[1]);
+	dma_declare_coherent_memory(&ecovec_ceu_devices[1]->dev,
+				    ceu1_dma_membase, ceu1_dma_membase,
+				    ceu1_dma_membase +
+				    CEU_BUFFER_MEMORY_SIZE - 1,
+				    DMA_MEMORY_EXCLUSIVE);
+	platform_device_add(ecovec_ceu_devices[1]);
+
 	return platform_add_devices(ecovec_devices,
 				    ARRAY_SIZE(ecovec_devices));
 }
@@ -1443,6 +1425,24 @@ static int __init devices_setup(void)
 }
 device_initcall(devices_setup);
 
+/* Reserve a portion of memory for CEU 0 and CEU 1 buffers */
+static void __init ecovec_mv_mem_reserve(void)
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
 static struct sh_machine_vector mv_ecovec __initmv = {
 	.mv_name	= "R0P7724 (EcoVec)",
+	.mv_mem_reserve	= ecovec_mv_mem_reserve,
 };
diff --git a/arch/sh/kernel/cpu/sh4a/clock-sh7724.c b/arch/sh/kernel/cpu/sh4a/clock-sh7724.c
index f27c618..3194336 100644
--- a/arch/sh/kernel/cpu/sh4a/clock-sh7724.c
+++ b/arch/sh/kernel/cpu/sh4a/clock-sh7724.c
@@ -338,14 +338,14 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_DEV_ID("sh_mobile_sdhi.0", &mstp_clks[HWBLK_SDHI0]),
 	CLKDEV_DEV_ID("sh_mobile_sdhi.1", &mstp_clks[HWBLK_SDHI1]),
 	CLKDEV_CON_ID("veu1", &mstp_clks[HWBLK_VEU1]),
-	CLKDEV_DEV_ID("sh_mobile_ceu.1", &mstp_clks[HWBLK_CEU1]),
+	CLKDEV_DEV_ID("renesas-ceu.1", &mstp_clks[HWBLK_CEU1]),
 	CLKDEV_CON_ID("beu1", &mstp_clks[HWBLK_BEU1]),
 	CLKDEV_CON_ID("2ddmac0", &mstp_clks[HWBLK_2DDMAC]),
 	CLKDEV_DEV_ID("sh_fsi.0", &mstp_clks[HWBLK_SPU]),
 	CLKDEV_CON_ID("jpu0", &mstp_clks[HWBLK_JPU]),
 	CLKDEV_DEV_ID("sh-vou", &mstp_clks[HWBLK_VOU]),
 	CLKDEV_CON_ID("beu0", &mstp_clks[HWBLK_BEU0]),
-	CLKDEV_DEV_ID("sh_mobile_ceu.0", &mstp_clks[HWBLK_CEU0]),
+	CLKDEV_DEV_ID("renesas-ceu.0", &mstp_clks[HWBLK_CEU0]),
 	CLKDEV_CON_ID("veu0", &mstp_clks[HWBLK_VEU0]),
 	CLKDEV_CON_ID("vpu0", &mstp_clks[HWBLK_VPU]),
 	CLKDEV_DEV_ID("sh_mobile_lcdc_fb.0", &mstp_clks[HWBLK_LCDC]),
-- 
2.7.4
