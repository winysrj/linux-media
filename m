Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60876 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755529AbZDXQkP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2009 12:40:15 -0400
Date: Fri, 24 Apr 2009 18:40:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Magnus Damm <magnus.damm@gmail.com>,
	eric miao <eric.y.miao@gmail.com>
Subject: [PATCH 5/8] ARM: convert mioa701 to the new platform-device soc-camera
 interface
In-Reply-To: <Pine.LNX.4.64.0904241818130.8309@axis700.grange>
Message-ID: <Pine.LNX.4.64.0904241833330.8309@axis700.grange>
References: <Pine.LNX.4.64.0904241818130.8309@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

For review __ONLY__ for now - will re-submit after I have pushed 1/8

 arch/arm/mach-pxa/mioa701.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-pxa/mioa701.c b/arch/arm/mach-pxa/mioa701.c
index ff8052c..c360bce 100644
--- a/arch/arm/mach-pxa/mioa701.c
+++ b/arch/arm/mach-pxa/mioa701.c
@@ -725,19 +725,20 @@ struct pxacamera_platform_data mioa701_pxacamera_platform_data = {
 	.mclk_10khz = 5000,
 };
 
-static struct soc_camera_link iclink = {
-	.bus_id	= 0, /* Must match id in pxa27x_device_camera in device.c */
-};
-
 /* Board I2C devices. */
 static struct i2c_board_info __initdata mioa701_i2c_devices[] = {
 	{
-		/* Must initialize before the camera(s) */
 		I2C_BOARD_INFO("mt9m111", 0x5d),
-		.platform_data = &iclink,
 	},
 };
 
+static struct soc_camera_link iclink = {
+	.bus_id		= 0, /* Match id in pxa27x_device_camera in device.c */
+	.board_info	= &mioa701_i2c_devices[0],
+	.i2c_adapter_id	= 0,
+	.module_name	= "mt9m111",
+};
+
 struct i2c_pxa_platform_data i2c_pdata = {
 	.fast_mode = 1,
 };
@@ -771,6 +772,7 @@ MIO_SIMPLE_DEV(pxa2xx_pcm,	  "pxa2xx-pcm",	    NULL)
 MIO_SIMPLE_DEV(mioa701_sound,	  "mioa701-wm9713", NULL)
 MIO_SIMPLE_DEV(mioa701_board,	  "mioa701-board",  NULL)
 MIO_SIMPLE_DEV(gpio_vbus,	  "gpio-vbus",      &gpio_vbus_data);
+MIO_SIMPLE_DEV(mioa701_camera,	  "soc-camera-pdrv",&iclink);
 
 static struct platform_device *devices[] __initdata = {
 	&mioa701_gpio_keys,
@@ -781,6 +783,7 @@ static struct platform_device *devices[] __initdata = {
 	&power_dev,
 	&strataflash,
 	&gpio_vbus,
+	&mioa701_camera,
 	&mioa701_board,
 };
 
@@ -827,7 +830,6 @@ static void __init mioa701_machine_init(void)
 
 	pxa_set_i2c_info(&i2c_pdata);
 	pxa_set_camera_info(&mioa701_pxacamera_platform_data);
-	i2c_register_board_info(0, ARRAY_AND_SIZE(mioa701_i2c_devices));
 }
 
 static void mioa701_machine_exit(void)
-- 
1.6.2.4

