Return-path: <linux-media-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:41917 "EHLO
        slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932181AbdKOLPE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 06:15:04 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 05/10] arch: sh: migor: Use new renesas-ceu camera driver
Date: Wed, 15 Nov 2017 11:55:58 +0100
Message-Id: <1510743363-25798-6-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Migo-R platform uses sh_mobile_ceu camera driver, which is now being
replaced by a proper V4L2 camera driver named 'renesas-ceu'.

Move Migo-R platform to use the v4l2 renesas-ceu camera driver
interface and get rid of soc_camera defined components used to register
sensor drivers.

Also, memory for CEU video buffers is now reserved with membocks APIs,
and need to be declared as dma_coherent during machine initialization to
remove that architecture specific part from CEU driver.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 arch/sh/boards/mach-migor/setup.c | 164 ++++++++++++++++++--------------------
 1 file changed, 76 insertions(+), 88 deletions(-)

diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index 98aa094..10a9b3c 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -27,7 +27,7 @@
 #include <linux/videodev2.h>
 #include <linux/sh_intc.h>
 #include <video/sh_mobile_lcdc.h>
-#include <media/drv-intf/sh_mobile_ceu.h>
+#include <media/drv-intf/renesas-ceu.h>
 #include <media/i2c/ov772x.h>
 #include <media/soc_camera.h>
 #include <media/i2c/tw9910.h>
@@ -308,62 +308,80 @@ static struct platform_device migor_lcdc_device = {
 static struct clk *camera_clk;
 static DEFINE_MUTEX(camera_lock);

-static void camera_power_on(int is_tw)
+static void camera_vio_clk_on(void)
 {
-	mutex_lock(&camera_lock);
-
 	/* Use 10 MHz VIO_CKO instead of 24 MHz to work
 	 * around signal quality issues on Panel Board V2.1.
 	 */
 	camera_clk = clk_get(NULL, "video_clk");
 	clk_set_rate(camera_clk, 10000000);
 	clk_enable(camera_clk);	/* start VIO_CKO */
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
 }

-static void camera_power_off(void)
+static void camera_disable(void)
 {
-	clk_disable(camera_clk); /* stop VIO_CKO */
+	/* stop VIO_CKO */
+	clk_disable(camera_clk);
 	clk_put(camera_clk);

+	gpio_set_value(GPIO_PTT0, 0);
+	gpio_set_value(GPIO_PTT2, 1);
 	gpio_set_value(GPIO_PTT3, 0);
+
 	mutex_unlock(&camera_lock);
 }

-static int ov7725_power(struct device *dev, int mode)
+static void camera_reset(void)
 {
-	if (mode)
-		camera_power_on(0);
-	else
-		camera_power_off();
+	/* use VIO_RST to take camera out of reset */
+	gpio_set_value(GPIO_PTT3, 0);
+	mdelay(10);
+	gpio_set_value(GPIO_PTT3, 1);
+	mdelay(10);
+}
+
+static int ov7725_enable(void)
+{
+	mutex_lock(&camera_lock);
+	camera_vio_clk_on();
+	mdelay(10);
+	gpio_set_value(GPIO_PTT0, 1);
+
+	camera_reset();

 	return 0;
 }

-static int tw9910_power(struct device *dev, int mode)
+static int tw9910_enable(void)
 {
-	if (mode)
-		camera_power_on(1);
-	else
-		camera_power_off();
+	mutex_lock(&camera_lock);
+	camera_vio_clk_on();
+	mdelay(10);
+	gpio_set_value(GPIO_PTT2, 0);
+
+	camera_reset();

 	return 0;
 }

-static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
-	.flags = SH_CEU_FLAG_USE_8BIT_BUS,
+static struct ceu_info ceu_info = {
+	.num_subdevs		= 2,
+	.subdevs = {
+		{ /* [0] = ov772x */
+			.flags		= CEU_FLAG_PRIMARY_SENS,
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
@@ -377,18 +395,15 @@ static struct resource migor_ceu_resources[] = {
 		.start  = evt2irq(0x880),
 		.flags  = IORESOURCE_IRQ,
 	},
-	[2] = {
-		/* place holder for contiguous memory */
-	},
 };

 static struct platform_device migor_ceu_device = {
-	.name		= "sh_mobile_ceu",
+	.name		= "renesas-ceu",
 	.id             = 0, /* "ceu0" clock */
 	.num_resources	= ARRAY_SIZE(migor_ceu_resources),
 	.resource	= migor_ceu_resources,
 	.dev	= {
-		.platform_data	= &sh_mobile_ceu_info,
+		.platform_data	= &ceu_info,
 	},
 };

@@ -427,6 +442,19 @@ static struct platform_device sdhi_cn9_device = {
 	},
 };

+static struct ov772x_camera_info ov7725_info = {
+	.platform_enable = ov7725_enable,
+	.platform_disable = camera_disable,
+};
+
+static struct tw9910_video_info tw9910_info = {
+	.buswidth       = TW9910_DATAWIDTH_8,
+	.mpout          = TW9910_MPO_FIELD,
+
+	.platform_enable = tw9910_enable,
+	.platform_disable = camera_disable,
+};
+
 static struct i2c_board_info migor_i2c_devices[] = {
 	{
 		I2C_BOARD_INFO("rs5c372b", 0x32),
@@ -438,51 +466,13 @@ static struct i2c_board_info migor_i2c_devices[] = {
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

@@ -490,12 +480,9 @@ static struct platform_device *migor_devices[] __initdata = {
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
@@ -505,8 +492,6 @@ extern char migor_sdram_leave_end;

 static int __init migor_devices_setup(void)
 {
-	struct resource *r;
-
 	/* register board specific self-refresh code */
 	sh_mobile_register_self_refresh(SUSP_SH_STANDBY | SUSP_SH_SF,
 					&migor_sdram_enter_start,
@@ -651,16 +636,19 @@ static int __init migor_devices_setup(void)
 	 */
 	__raw_writew(__raw_readw(PORT_MSELCRA) | 1, PORT_MSELCRA);

-	/* Setup additional memory resource for CEU video buffers */
-	r = &migor_ceu_device.resource[2];
-	r->flags = IORESOURCE_MEM;
-	r->start = ceu_dma_membase;
-	r->end = r->start + CEU_BUFFER_MEMORY_SIZE - 1;
-	r->name = "ceu";
-
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
--
2.7.4
