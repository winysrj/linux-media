Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46438 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752373AbZDXQjs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2009 12:39:48 -0400
Date: Fri, 24 Apr 2009 18:40:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Magnus Damm <magnus.damm@gmail.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 2/8] ARM: convert pcm037 to the new platform-device soc-camera
 interface
In-Reply-To: <Pine.LNX.4.64.0904241818130.8309@axis700.grange>
Message-ID: <Pine.LNX.4.64.0904241830160.8309@axis700.grange>
References: <Pine.LNX.4.64.0904241818130.8309@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

For review __ONLY__ for now - will re-submit after I have pushed 1/8

 arch/arm/mach-mx3/pcm037.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-mx3/pcm037.c b/arch/arm/mach-mx3/pcm037.c
index bfa814d..af49f03 100644
--- a/arch/arm/mach-mx3/pcm037.c
+++ b/arch/arm/mach-mx3/pcm037.c
@@ -293,9 +293,18 @@ static int pcm037_camera_power(struct device *dev, int on)
 	return 0;
 }
 
+static struct i2c_board_info pcm037_i2c_2_devices[] = {
+	{
+		I2C_BOARD_INFO("mt9t031", 0x5d),
+	},
+};
+
 static struct soc_camera_link iclink = {
-	.bus_id	= 0,			/* Must match with the camera ID */
-	.power = pcm037_camera_power,
+	.bus_id		= 0,		/* Must match with the camera ID */
+	.power		= pcm037_camera_power,
+	.board_info	= &pcm037_i2c_2_devices[0],
+	.i2c_adapter_id	= 2,
+	.module_name	= "mt9t031",
 };
 
 static struct i2c_board_info pcm037_i2c_devices[] = {
@@ -308,9 +317,10 @@ static struct i2c_board_info pcm037_i2c_devices[] = {
 	}
 };
 
-static struct i2c_board_info pcm037_i2c_2_devices[] = {
-	{
-		I2C_BOARD_INFO("mt9t031", 0x5d),
+static struct platform_device pcm037_camera = {
+	.name	= "soc-camera-pdrv",
+	.id	= 0,
+	.dev	= {
 		.platform_data = &iclink,
 	},
 };
@@ -390,6 +400,9 @@ static struct platform_device *devices[] __initdata = {
 	&pcm037_flash,
 	&pcm037_eth,
 	&pcm037_sram_device,
+#if defined(CONFIG_I2C_IMX) || defined(CONFIG_I2C_IMX_MODULE)
+	&pcm037_camera,
+#endif
 };
 
 static struct ipu_platform_data mx3_ipu_data = {
@@ -447,9 +460,6 @@ static void __init mxc_board_init(void)
 	i2c_register_board_info(1, pcm037_i2c_devices,
 			ARRAY_SIZE(pcm037_i2c_devices));
 
-	i2c_register_board_info(2, pcm037_i2c_2_devices,
-			ARRAY_SIZE(pcm037_i2c_2_devices));
-
 	mxc_register_device(&mxc_i2c_device1, &pcm037_i2c_1_data);
 	mxc_register_device(&mxc_i2c_device2, &pcm037_i2c_2_data);
 #endif
-- 
1.6.2.4

