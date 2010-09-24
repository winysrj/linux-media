Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:60405 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298Ab0IXOOm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 10:14:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean Delvare <khali@linux-fr.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pete Eberlein <pete@sensoray.com>,
	Mike Isely <isely@pobox.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Muralidharan Karicheri <mkaricheri@gmail.com>
Subject: [PATCH 10/16] soc_camera: Don't use module names to load I2C modules
Date: Fri, 24 Sep 2010 16:14:08 +0200
Message-Id: <1285337654-5044-11-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With the v4l2_i2c_new_subdev* functions now supporting loading modules
based on modaliases, remove the module names hardcoded in platform data
and pass a NULL module name to those functions.

All corresponding I2C modules have been checked, and all of them include
a module aliases table with names corresponding to what the soc_camera
platform data uses.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 arch/arm/mach-mx3/mach-pcm037.c          |    2 --
 arch/arm/mach-mx3/mx31moboard-marxbot.c  |    1 -
 arch/arm/mach-mx3/mx31moboard-smartbot.c |    1 -
 arch/arm/mach-pxa/em-x270.c              |    1 -
 arch/arm/mach-pxa/ezx.c                  |    2 --
 arch/arm/mach-pxa/mioa701.c              |    1 -
 arch/arm/mach-pxa/pcm990-baseboard.c     |    2 --
 arch/sh/boards/mach-ap325rxa/setup.c     |    1 -
 arch/sh/boards/mach-ecovec24/setup.c     |    3 ---
 arch/sh/boards/mach-kfr2r09/setup.c      |    1 -
 arch/sh/boards/mach-migor/setup.c        |    2 --
 drivers/media/video/soc_camera.c         |    2 +-
 12 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/arch/arm/mach-mx3/mach-pcm037.c b/arch/arm/mach-mx3/mach-pcm037.c
index 8a292dd..b097790 100644
--- a/arch/arm/mach-mx3/mach-pcm037.c
+++ b/arch/arm/mach-mx3/mach-pcm037.c
@@ -311,7 +311,6 @@ static struct soc_camera_link iclink_mt9v022 = {
 	.bus_id		= 0,		/* Must match with the camera ID */
 	.board_info	= &pcm037_i2c_camera[1],
 	.i2c_adapter_id	= 2,
-	.module_name	= "mt9v022",
 };
 
 static struct soc_camera_link iclink_mt9t031 = {
@@ -319,7 +318,6 @@ static struct soc_camera_link iclink_mt9t031 = {
 	.power		= pcm037_camera_power,
 	.board_info	= &pcm037_i2c_camera[0],
 	.i2c_adapter_id	= 2,
-	.module_name	= "mt9t031",
 };
 
 static struct i2c_board_info pcm037_i2c_devices[] = {
diff --git a/arch/arm/mach-mx3/mx31moboard-marxbot.c b/arch/arm/mach-mx3/mx31moboard-marxbot.c
index 0551eb3..18069cb 100644
--- a/arch/arm/mach-mx3/mx31moboard-marxbot.c
+++ b/arch/arm/mach-mx3/mx31moboard-marxbot.c
@@ -179,7 +179,6 @@ static struct soc_camera_link base_iclink = {
 	.reset		= marxbot_basecam_reset,
 	.board_info	= &marxbot_i2c_devices[0],
 	.i2c_adapter_id	= 0,
-	.module_name	= "mt9t031",
 };
 
 static struct platform_device marxbot_camera[] = {
diff --git a/arch/arm/mach-mx3/mx31moboard-smartbot.c b/arch/arm/mach-mx3/mx31moboard-smartbot.c
index 40c3e75..7abcede 100644
--- a/arch/arm/mach-mx3/mx31moboard-smartbot.c
+++ b/arch/arm/mach-mx3/mx31moboard-smartbot.c
@@ -88,7 +88,6 @@ static struct soc_camera_link base_iclink = {
 	.reset		= smartbot_cam_reset,
 	.board_info	= &smartbot_i2c_devices[0],
 	.i2c_adapter_id	= 0,
-	.module_name	= "mt9t031",
 };
 
 static struct platform_device smartbot_camera[] = {
diff --git a/arch/arm/mach-pxa/em-x270.c b/arch/arm/mach-pxa/em-x270.c
index 0517c17..0c95476 100644
--- a/arch/arm/mach-pxa/em-x270.c
+++ b/arch/arm/mach-pxa/em-x270.c
@@ -1015,7 +1015,6 @@ static struct soc_camera_link iclink = {
 	.power		= em_x270_sensor_power,
 	.board_info	= &em_x270_i2c_cam_info[0],
 	.i2c_adapter_id	= 0,
-	.module_name	= "mt9m111",
 };
 
 static struct platform_device em_x270_camera = {
diff --git a/arch/arm/mach-pxa/ezx.c b/arch/arm/mach-pxa/ezx.c
index 626c82b..70dfe08 100644
--- a/arch/arm/mach-pxa/ezx.c
+++ b/arch/arm/mach-pxa/ezx.c
@@ -753,7 +753,6 @@ static struct soc_camera_link a780_iclink = {
 	.flags          = SOCAM_SENSOR_INVERT_PCLK,
 	.i2c_adapter_id = 0,
 	.board_info     = &a780_camera_i2c_board_info,
-	.module_name    = "mt9m111",
 	.power          = a780_camera_power,
 	.reset          = a780_camera_reset,
 };
@@ -1025,7 +1024,6 @@ static struct soc_camera_link a910_iclink = {
 	.bus_id         = 0,
 	.i2c_adapter_id = 0,
 	.board_info     = &a910_camera_i2c_board_info,
-	.module_name    = "mt9m111",
 	.power          = a910_camera_power,
 	.reset          = a910_camera_reset,
 };
diff --git a/arch/arm/mach-pxa/mioa701.c b/arch/arm/mach-pxa/mioa701.c
index fa6a708..a197dab 100644
--- a/arch/arm/mach-pxa/mioa701.c
+++ b/arch/arm/mach-pxa/mioa701.c
@@ -707,7 +707,6 @@ static struct soc_camera_link iclink = {
 	.bus_id		= 0, /* Match id in pxa27x_device_camera in device.c */
 	.board_info	= &mioa701_i2c_devices[0],
 	.i2c_adapter_id	= 0,
-	.module_name	= "mt9m111",
 };
 
 struct i2c_pxa_platform_data i2c_pdata = {
diff --git a/arch/arm/mach-pxa/pcm990-baseboard.c b/arch/arm/mach-pxa/pcm990-baseboard.c
index f56ae10..f33647a 100644
--- a/arch/arm/mach-pxa/pcm990-baseboard.c
+++ b/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -453,7 +453,6 @@ static struct soc_camera_link iclink[] = {
 		.query_bus_param	= pcm990_camera_query_bus_param,
 		.set_bus_param		= pcm990_camera_set_bus_param,
 		.free_bus		= pcm990_camera_free_bus,
-		.module_name		= "mt9v022",
 	}, {
 		.bus_id			= 0, /* Must match with the camera ID */
 		.board_info		= &pcm990_camera_i2c[1],
@@ -461,7 +460,6 @@ static struct soc_camera_link iclink[] = {
 		.query_bus_param	= pcm990_camera_query_bus_param,
 		.set_bus_param		= pcm990_camera_set_bus_param,
 		.free_bus		= pcm990_camera_free_bus,
-		.module_name		= "mt9m001",
 	},
 };
 
diff --git a/arch/sh/boards/mach-ap325rxa/setup.c b/arch/sh/boards/mach-ap325rxa/setup.c
index de375b6..18b45c6 100644
--- a/arch/sh/boards/mach-ap325rxa/setup.c
+++ b/arch/sh/boards/mach-ap325rxa/setup.c
@@ -481,7 +481,6 @@ static struct soc_camera_link ov7725_link = {
 	.power		= ov7725_power,
 	.board_info	= &ap325rxa_i2c_camera[0],
 	.i2c_adapter_id	= 0,
-	.module_name	= "ov772x",
 	.priv		= &ov7725_info,
 };
 
diff --git a/arch/sh/boards/mach-ecovec24/setup.c b/arch/sh/boards/mach-ecovec24/setup.c
index 4a9fa5d..ae0b138 100644
--- a/arch/sh/boards/mach-ecovec24/setup.c
+++ b/arch/sh/boards/mach-ecovec24/setup.c
@@ -620,7 +620,6 @@ static struct soc_camera_link tw9910_link = {
 	.bus_id		= 1,
 	.power		= tw9910_power,
 	.board_info	= &i2c_camera[0],
-	.module_name	= "tw9910",
 	.priv		= &tw9910_info,
 };
 
@@ -644,7 +643,6 @@ static struct soc_camera_link mt9t112_link1 = {
 	.power		= mt9t112_power1,
 	.bus_id		= 0,
 	.board_info	= &i2c_camera[1],
-	.module_name	= "mt9t112",
 	.priv		= &mt9t112_info1,
 };
 
@@ -667,7 +665,6 @@ static struct soc_camera_link mt9t112_link2 = {
 	.power		= mt9t112_power2,
 	.bus_id		= 1,
 	.board_info	= &i2c_camera[2],
-	.module_name	= "mt9t112",
 	.priv		= &mt9t112_info2,
 };
 
diff --git a/arch/sh/boards/mach-kfr2r09/setup.c b/arch/sh/boards/mach-kfr2r09/setup.c
index 68994a1..1742849 100644
--- a/arch/sh/boards/mach-kfr2r09/setup.c
+++ b/arch/sh/boards/mach-kfr2r09/setup.c
@@ -333,7 +333,6 @@ static struct soc_camera_link rj54n1_link = {
 	.power		= camera_power,
 	.board_info	= &kfr2r09_i2c_camera,
 	.i2c_adapter_id	= 1,
-	.module_name	= "rj54n1cb0c",
 	.priv		= &rj54n1_priv,
 };
 
diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index 662debe..03af848 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -450,7 +450,6 @@ static struct soc_camera_link ov7725_link = {
 	.power		= ov7725_power,
 	.board_info	= &migor_i2c_camera[0],
 	.i2c_adapter_id	= 0,
-	.module_name	= "ov772x",
 	.priv		= &ov7725_info,
 };
 
@@ -463,7 +462,6 @@ static struct soc_camera_link tw9910_link = {
 	.power		= tw9910_power,
 	.board_info	= &migor_i2c_camera[1],
 	.i2c_adapter_id	= 0,
-	.module_name	= "tw9910",
 	.priv		= &tw9910_info,
 };
 
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index a55d6dc..328cf97 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -898,7 +898,7 @@ static int soc_camera_init_i2c(struct soc_camera_device *icd,
 	icl->board_info->platform_data = icd;
 
 	subdev = v4l2_i2c_new_subdev_board(&ici->v4l2_dev, adap,
-				icl->module_name, icl->board_info, NULL);
+				NULL, icl->board_info, NULL);
 	if (!subdev)
 		goto ei2cnd;
 
-- 
1.7.2.2

