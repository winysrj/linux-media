Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54344 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755527AbZDXQkJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2009 12:40:09 -0400
Date: Fri, 24 Apr 2009 18:40:22 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Magnus Damm <magnus.damm@gmail.com>,
	eric miao <eric.y.miao@gmail.com>
Subject: [PATCH 4/8] ARM: convert em-x270 to the new platform-device soc-camera
 interface
In-Reply-To: <Pine.LNX.4.64.0904241818130.8309@axis700.grange>
Message-ID: <Pine.LNX.4.64.0904241832500.8309@axis700.grange>
References: <Pine.LNX.4.64.0904241818130.8309@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

For review __ONLY__ for now - will re-submit after I have pushed 1/8

 arch/arm/mach-pxa/em-x270.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-pxa/em-x270.c b/arch/arm/mach-pxa/em-x270.c
index bc0f73f..d35bc25 100644
--- a/arch/arm/mach-pxa/em-x270.c
+++ b/arch/arm/mach-pxa/em-x270.c
@@ -917,14 +917,24 @@ static int em_x270_sensor_power(struct device *dev, int on)
 	return 0;
 }
 
-static struct soc_camera_link iclink = {
-	.bus_id	= 0,
-	.power = em_x270_sensor_power,
-};
-
 static struct i2c_board_info em_x270_i2c_cam_info[] = {
 	{
 		I2C_BOARD_INFO("mt9m111", 0x48),
+	},
+};
+
+static struct soc_camera_link iclink = {
+	.bus_id		= 0,
+	.power		= em_x270_sensor_power,
+	.board_info	= &em_x270_i2c_cam_info[0],
+	.i2c_adapter_id	= 0,
+	.module_name	= "mt9m111",
+};
+
+static struct platform_device em_x270_camera = {
+	.name	= "soc-camera-pdrv",
+	.id	= -1,
+	.dev	= {
 		.platform_data = &iclink,
 	},
 };
@@ -936,8 +946,8 @@ static struct i2c_pxa_platform_data em_x270_i2c_info = {
 static void  __init em_x270_init_camera(void)
 {
 	pxa_set_i2c_info(&em_x270_i2c_info);
-	i2c_register_board_info(0, ARRAY_AND_SIZE(em_x270_i2c_cam_info));
 	pxa_set_camera_info(&em_x270_camera_platform_data);
+	platform_device_register(&em_x270_camera);
 }
 #else
 static inline void em_x270_init_camera(void) {}
-- 
1.6.2.4

