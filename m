Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35503 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbZILQfd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 12:35:33 -0400
Date: Sat, 12 Sep 2009 13:35:05 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Arm changes upstream
Message-ID: <20090912133505.7573e9ab@caramujo.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi and Murali,

I'm working on cleaning up our pending -arm patches for their upstream
inclusion.

As a first step, I ran a diff between our linux-next tree and -hg and I found
a number of changes that should, be applied at our tree, for it to reflect what
we have currently at linux-next.

This probably means that we'll need to change versions.txt for it to reflect
that the drivers will compile only with 2.6.31 (or 2.6.32 or upper).

As, even if the changes are wrong, we'll need to add a fix at linux-next, I'll
merge it at -hg right now. Yet, could you please double check if everything is
ok upstream, or if some patches are needed there, in order to fix git bisect?

Also, could you please provide the proper versions.txt patches?

Cheers,
Mauro

diff -upr oldtree/arch/arm/mach-pxa/pcm990-baseboard.c /home/v4l/tokernel/wrk/linux-next/arch/arm/mach-pxa/pcm990-baseboard.c
--- oldtree/arch/arm/mach-pxa/pcm990-baseboard.c	2009-09-12 13:15:41.000000000 -0300
+++ /home/v4l/tokernel/wrk/linux-next/arch/arm/mach-pxa/pcm990-baseboard.c	2009-09-12 13:01:16.000000000 -0300
@@ -427,56 +427,25 @@ static void pcm990_camera_free_bus(struc
 	gpio_bus_switch = -EINVAL;
 }
 
+static struct soc_camera_link iclink = {
+	.bus_id	= 0, /* Must match with the camera ID above */
+	.query_bus_param = pcm990_camera_query_bus_param,
+	.set_bus_param = pcm990_camera_set_bus_param,
+	.free_bus = pcm990_camera_free_bus,
+};
+
 /* Board I2C devices. */
 static struct i2c_board_info __initdata pcm990_i2c_devices[] = {
 	{
 		/* Must initialize before the camera(s) */
 		I2C_BOARD_INFO("pca9536", 0x41),
 		.platform_data = &pca9536_data,
-	},
-};
-
-static struct i2c_board_info pcm990_camera_i2c[] = {
-	{
+	}, {
 		I2C_BOARD_INFO("mt9v022", 0x48),
+		.platform_data = &iclink, /* With extender */
 	}, {
 		I2C_BOARD_INFO("mt9m001", 0x5d),
-	},
-};
-
-static struct soc_camera_link iclink[] = {
-	{
-		.bus_id			= 0, /* Must match with the camera ID */
-		.board_info		= &pcm990_camera_i2c[0],
-		.i2c_adapter_id		= 0,
-		.query_bus_param	= pcm990_camera_query_bus_param,
-		.set_bus_param		= pcm990_camera_set_bus_param,
-		.free_bus		= pcm990_camera_free_bus,
-		.module_name		= "mt9v022",
-	}, {
-		.bus_id			= 0, /* Must match with the camera ID */
-		.board_info		= &pcm990_camera_i2c[1],
-		.i2c_adapter_id		= 0,
-		.query_bus_param	= pcm990_camera_query_bus_param,
-		.set_bus_param		= pcm990_camera_set_bus_param,
-		.free_bus		= pcm990_camera_free_bus,
-		.module_name		= "mt9m001",
-	},
-};
-
-static struct platform_device pcm990_camera[] = {
-	{
-		.name	= "soc-camera-pdrv",
-		.id	= 0,
-		.dev	= {
-			.platform_data = &iclink[0],
-		},
-	}, {
-		.name	= "soc-camera-pdrv",
-		.id	= 1,
-		.dev	= {
-			.platform_data = &iclink[1],
-		},
+		.platform_data = &iclink, /* With extender */
 	},
 };
 #endif /* CONFIG_VIDEO_PXA27x ||CONFIG_VIDEO_PXA27x_MODULE */
@@ -532,9 +501,6 @@ void __init pcm990_baseboard_init(void)
 	pxa_set_camera_info(&pcm990_pxacamera_platform_data);
 
 	i2c_register_board_info(0, ARRAY_AND_SIZE(pcm990_i2c_devices));
-
-	platform_device_register(&pcm990_camera[0]);
-	platform_device_register(&pcm990_camera[1]);
 #endif
 
 	printk(KERN_INFO "PCM-990 Evaluation baseboard initialized\n");
diff -upr oldtree/arch/sh/boards/board-ap325rxa.c /home/v4l/tokernel/wrk/linux-next/arch/sh/boards/board-ap325rxa.c
--- oldtree/arch/sh/boards/board-ap325rxa.c	2009-09-12 13:15:41.000000000 -0300
+++ /home/v4l/tokernel/wrk/linux-next/arch/sh/boards/board-ap325rxa.c	2009-09-12 13:02:53.000000000 -0300
@@ -581,7 +581,7 @@ static int __init ap325rxa_devices_setup
 	return platform_add_devices(ap325rxa_devices,
 				ARRAY_SIZE(ap325rxa_devices));
 }
-device_initcall(ap325rxa_devices_setup);
+arch_initcall(ap325rxa_devices_setup);
 
 /* Return the board specific boot mode pin configuration */
 static int ap325rxa_mode_pins(void)
diff -upr oldtree/arch/sh/boards/mach-migor/setup.c /home/v4l/tokernel/wrk/linux-next/arch/sh/boards/mach-migor/setup.c
--- oldtree/arch/sh/boards/mach-migor/setup.c	2009-09-12 13:15:41.000000000 -0300
+++ /home/v4l/tokernel/wrk/linux-next/arch/sh/boards/mach-migor/setup.c	2009-09-12 13:01:19.000000000 -0300
@@ -608,7 +608,7 @@ static int __init migor_devices_setup(vo
 
 	return platform_add_devices(migor_devices, ARRAY_SIZE(migor_devices));
 }
-__initcall(migor_devices_setup);
+arch_initcall(migor_devices_setup);
 
 /* Return the board specific boot mode pin configuration */
 static int migor_mode_pins(void)
diff -upr oldtree/drivers/media/video/davinci/vpif_display.c /home/v4l/tokernel/wrk/linux-next/drivers/media/video/davinci/vpif_display.c
--- oldtree/drivers/media/video/davinci/vpif_display.c	2009-09-12 13:15:44.000000000 -0300
+++ /home/v4l/tokernel/wrk/linux-next/drivers/media/video/davinci/vpif_display.c	2009-09-12 13:11:50.000000000 -0300
@@ -1422,7 +1422,7 @@ vpif_init_free_channel_objects:
  */
 static __init int vpif_probe(struct platform_device *pdev)
 {
-	const struct subdev_info *subdevdata;
+	const struct vpif_subdev_info *subdevdata;
 	int i, j = 0, k, q, m, err = 0;
 	struct i2c_adapter *i2c_adap;
 	struct vpif_config *config;

