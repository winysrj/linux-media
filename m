Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45620 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754354AbZDXQj7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2009 12:39:59 -0400
Date: Fri, 24 Apr 2009 18:40:12 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Magnus Damm <magnus.damm@gmail.com>,
	eric miao <eric.y.miao@gmail.com>
Subject: [PATCH 3/8] ARM: convert pcm990 to the new platform-device soc-camera
 interface
In-Reply-To: <Pine.LNX.4.64.0904241818130.8309@axis700.grange>
Message-ID: <Pine.LNX.4.64.0904241832120.8309@axis700.grange>
References: <Pine.LNX.4.64.0904241818130.8309@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

For review __ONLY__ for now - will re-submit after I have pushed 1/8

 arch/arm/mach-pxa/pcm990-baseboard.c |   54 +++++++++++++++++++++++++++------
 1 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-pxa/pcm990-baseboard.c b/arch/arm/mach-pxa/pcm990-baseboard.c
index 9ce1ef2..a1ae436 100644
--- a/arch/arm/mach-pxa/pcm990-baseboard.c
+++ b/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -427,25 +427,56 @@ static void pcm990_camera_free_bus(struct soc_camera_link *link)
 	gpio_bus_switch = -EINVAL;
 }
 
-static struct soc_camera_link iclink = {
-	.bus_id	= 0, /* Must match with the camera ID above */
-	.query_bus_param = pcm990_camera_query_bus_param,
-	.set_bus_param = pcm990_camera_set_bus_param,
-	.free_bus = pcm990_camera_free_bus,
-};
-
 /* Board I2C devices. */
 static struct i2c_board_info __initdata pcm990_i2c_devices[] = {
 	{
 		/* Must initialize before the camera(s) */
 		I2C_BOARD_INFO("pca9536", 0x41),
 		.platform_data = &pca9536_data,
-	}, {
+	},
+};
+
+static struct i2c_board_info __initdata pcm990_camera_i2c[] = {
+	{
 		I2C_BOARD_INFO("mt9v022", 0x48),
-		.platform_data = &iclink, /* With extender */
 	}, {
 		I2C_BOARD_INFO("mt9m001", 0x5d),
-		.platform_data = &iclink, /* With extender */
+	},
+};
+
+static struct soc_camera_link iclink[] = {
+	{
+		.bus_id			= 0, /* Must match with the camera ID */
+		.board_info		= &pcm990_camera_i2c[0],
+		.i2c_adapter_id		= 0,
+		.query_bus_param	= pcm990_camera_query_bus_param,
+		.set_bus_param		= pcm990_camera_set_bus_param,
+		.free_bus		= pcm990_camera_free_bus,
+		.module_name		= "mt9v022",
+	}, {
+		.bus_id			= 0, /* Must match with the camera ID */
+		.board_info		= &pcm990_camera_i2c[1],
+		.i2c_adapter_id		= 0,
+		.query_bus_param	= pcm990_camera_query_bus_param,
+		.set_bus_param		= pcm990_camera_set_bus_param,
+		.free_bus		= pcm990_camera_free_bus,
+		.module_name		= "mt9m001",
+	},
+};
+
+static struct platform_device pcm990_camera[] = {
+	{
+		.name	= "soc-camera-pdrv",
+		.id	= 0,
+		.dev	= {
+			.platform_data = &iclink[0],
+		},
+	}, {
+		.name	= "soc-camera-pdrv",
+		.id	= 1,
+		.dev	= {
+			.platform_data = &iclink[1],
+		},
 	},
 };
 #endif /* CONFIG_VIDEO_PXA27x ||CONFIG_VIDEO_PXA27x_MODULE */
@@ -501,6 +532,9 @@ void __init pcm990_baseboard_init(void)
 	pxa_set_camera_info(&pcm990_pxacamera_platform_data);
 
 	i2c_register_board_info(0, ARRAY_AND_SIZE(pcm990_i2c_devices));
+
+	platform_device_register(&pcm990_camera[0]);
+	platform_device_register(&pcm990_camera[1]);
 #endif
 
 	printk(KERN_INFO "PCM-990 Evaluation baseboard initialized\n");
-- 
1.6.2.4

