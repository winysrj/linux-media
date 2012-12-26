Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:50100 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab2LZRtQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Dec 2012 12:49:16 -0500
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 6/6] ARM: shmobile: convert ap4evb to asynchronously register camera subdevices
Date: Wed, 26 Dec 2012 18:49:11 +0100
Message-Id: <1356544151-6313-7-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1356544151-6313-1-git-send-email-g.liakhovetski@gmx.de>
References: <1356544151-6313-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Register the imx074 camera I2C and the CSI-2 platform devices directly
in board platform data instead of letting the sh_mobile_ceu_camera driver
and the soc-camera framework register them at their run-time. This uses
the V4L2 asynchronous subdevice probing capability.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 arch/arm/mach-shmobile/board-ap4evb.c |  103 +++++++++++++++++++-------------
 arch/arm/mach-shmobile/clock-sh7372.c |    1 +
 2 files changed, 62 insertions(+), 42 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-ap4evb.c b/arch/arm/mach-shmobile/board-ap4evb.c
index 790dc68..c2cfbc4 100644
--- a/arch/arm/mach-shmobile/board-ap4evb.c
+++ b/arch/arm/mach-shmobile/board-ap4evb.c
@@ -50,6 +50,7 @@
 #include <media/sh_mobile_ceu.h>
 #include <media/sh_mobile_csi2.h>
 #include <media/soc_camera.h>
+#include <media/v4l2-async.h>
 
 #include <sound/sh_fsi.h>
 #include <sound/simple_card.h>
@@ -992,22 +993,32 @@ static struct platform_device leds_device = {
 	},
 };
 
-static struct i2c_board_info imx074_info = {
-	I2C_BOARD_INFO("imx074", 0x1a),
+/* I2C */
+static struct soc_camera_subdev_desc imx074_desc;
+static struct i2c_board_info i2c0_devices[] = {
+	{
+		I2C_BOARD_INFO("ak4643", 0x13),
+	}, {
+		I2C_BOARD_INFO("imx074", 0x1a),
+		.platform_data = &imx074_desc,
+	},
 };
 
-static struct soc_camera_link imx074_link = {
-	.bus_id		= 0,
-	.board_info	= &imx074_info,
-	.i2c_adapter_id	= 0,
-	.module_name	= "imx074",
+static struct i2c_board_info i2c1_devices[] = {
+	{
+		I2C_BOARD_INFO("r2025sd", 0x32),
+	},
 };
 
-static struct platform_device ap4evb_camera = {
-	.name   = "soc-camera-pdrv",
-	.id     = 0,
-	.dev    = {
-		.platform_data = &imx074_link,
+static struct resource csi2_resources[] = {
+	{
+		.name	= "CSI2",
+		.start	= 0xffc90000,
+		.end	= 0xffc90fff,
+		.flags	= IORESOURCE_MEM,
+	}, {
+		.start	= intcs_evt2irq(0x17a0),
+		.flags  = IORESOURCE_IRQ,
 	},
 };
 
@@ -1016,7 +1027,7 @@ static struct sh_csi2_client_config csi2_clients[] = {
 		.phy		= SH_CSI2_PHY_MAIN,
 		.lanes		= 0,		/* default: 2 lanes */
 		.channel	= 0,
-		.pdev		= &ap4evb_camera,
+		.name		= "imx074",
 	},
 };
 
@@ -1027,31 +1038,50 @@ static struct sh_csi2_pdata csi2_info = {
 	.flags		= SH_CSI2_ECC | SH_CSI2_CRC,
 };
 
-static struct resource csi2_resources[] = {
-	[0] = {
-		.name	= "CSI2",
-		.start	= 0xffc90000,
-		.end	= 0xffc90fff,
-		.flags	= IORESOURCE_MEM,
+static struct platform_device csi2_device = {
+	.name		= "sh-mobile-csi2",
+	.id		= 0,
+	.num_resources	= ARRAY_SIZE(csi2_resources),
+	.resource	= csi2_resources,
+	.dev		= {
+		.platform_data = &csi2_info,
 	},
-	[1] = {
-		.start	= intcs_evt2irq(0x17a0),
-		.flags  = IORESOURCE_IRQ,
+};
+
+static struct soc_camera_async_subdev csi2_sd = {
+	.asd.hw = {
+		.bus_type = V4L2_ASYNC_BUS_PLATFORM,
+		.match.platform.name = "sh-mobile-csi2.0",
 	},
+	.role = SOCAM_SUBDEV_DATA_PROCESSOR,
 };
 
-static struct sh_mobile_ceu_companion csi2 = {
-	.id		= 0,
-	.num_resources	= ARRAY_SIZE(csi2_resources),
-	.resource	= csi2_resources,
-	.platform_data	= &csi2_info,
+static struct soc_camera_async_subdev imx074_sd = {
+	.asd.hw = {
+		.bus_type = V4L2_ASYNC_BUS_I2C,
+		.match.i2c = {
+			.adapter_id = 0,
+			.address = 0x1a,
+		},
+	},
+	.role = SOCAM_SUBDEV_DATA_SOURCE,
 };
 
+static struct v4l2_async_subdev *ceu_subdevs[] = {
+	/* Single 2-element group */
+	&csi2_sd.asd,
+	&imx074_sd.asd,
+};
+
+/* 0-terminated array of group-sizes */
+static int ceu_subdev_sizes[] = {ARRAY_SIZE(ceu_subdevs), 0};
+
 static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
 	.flags = SH_CEU_FLAG_USE_8BIT_BUS,
 	.max_width = 8188,
 	.max_height = 8188,
-	.csi2 = &csi2,
+	.asd = ceu_subdevs,
+	.asd_sizes = ceu_subdev_sizes,
 };
 
 static struct resource ceu_resources[] = {
@@ -1096,7 +1126,7 @@ static struct platform_device *ap4evb_devices[] __initdata = {
 	&lcdc_device,
 	&lcdc1_device,
 	&ceu_device,
-	&ap4evb_camera,
+	&csi2_device,
 	&meram_device,
 };
 
@@ -1212,19 +1242,6 @@ static struct i2c_board_info tsc_device = {
 	/*.irq is selected on ap4evb_init */
 };
 
-/* I2C */
-static struct i2c_board_info i2c0_devices[] = {
-	{
-		I2C_BOARD_INFO("ak4643", 0x13),
-	},
-};
-
-static struct i2c_board_info i2c1_devices[] = {
-	{
-		I2C_BOARD_INFO("r2025sd", 0x32),
-	},
-};
-
 
 #define GPIO_PORT9CR	IOMEM(0xE6051009)
 #define GPIO_PORT10CR	IOMEM(0xE605100A)
@@ -1239,6 +1256,7 @@ static void __init ap4evb_init(void)
 		{ "A3SP", &sdhi0_device, },
 		{ "A3SP", &sdhi1_device, },
 		{ "A4R", &ceu_device, },
+		{ "A4R", &csi2_device, },
 	};
 	u32 srcr4;
 	struct clk *clk;
@@ -1480,6 +1498,7 @@ static void __init ap4evb_init(void)
 	sh7372_pm_init();
 	pm_clk_add(&fsi_device.dev, "spu2");
 	pm_clk_add(&lcdc1_device.dev, "hdmi");
+	pm_clk_add(&csi2_device.dev, "csir");
 }
 
 MACHINE_START(AP4EVB, "ap4evb")
diff --git a/arch/arm/mach-shmobile/clock-sh7372.c b/arch/arm/mach-shmobile/clock-sh7372.c
index 430a90f..e6a4528 100644
--- a/arch/arm/mach-shmobile/clock-sh7372.c
+++ b/arch/arm/mach-shmobile/clock-sh7372.c
@@ -678,6 +678,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_ICK_ID("icka", "sh_fsi2", &div6_reparent_clks[DIV6_FSIA]),
 	CLKDEV_ICK_ID("ickb", "sh_fsi2", &div6_reparent_clks[DIV6_FSIB]),
 	CLKDEV_ICK_ID("spu2", "sh_fsi2", &mstp_clks[MSTP223]),
+	CLKDEV_ICK_ID("csir", "sh-mobile-csi2.0", &div4_clks[DIV4_CSIR]),
 };
 
 void __init sh7372_clock_init(void)
-- 
1.7.2.5

