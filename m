Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:45399 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727265AbeGPPvI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jul 2018 11:51:08 -0400
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id A715A2006B
        for <linux-media@vger.kernel.org>; Mon, 16 Jul 2018 18:23:08 +0300 (EEST)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1ff5KM-0004SL-27
        for linux-media@vger.kernel.org; Mon, 16 Jul 2018 18:22:18 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] v4l: i2c: Replace "sensor-level" by "sensor"
Date: Mon, 16 Jul 2018 18:22:17 +0300
Message-Id: <20180716152217.17089-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A lot of sensor drivers are labelled as "sensor-level" drivers. That's odd
and somewhat confusing as the term isn't used elsewhere: these are just
sensor drivers. Call them such.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/Kconfig | 62 +++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 8669853e13614..5ee7a09001a7d 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -398,7 +398,7 @@ config VIDEO_TVP514X
 	depends on VIDEO_V4L2 && I2C
 	select V4L2_FWNODE
 	---help---
-	  This is a Video4Linux2 sensor-level driver for the TI TVP5146/47
+	  This is a Video4Linux2 sensor driver for the TI TVP5146/47
 	  decoder. It is currently working with the TI OMAP3 camera
 	  controller.
 
@@ -600,7 +600,7 @@ config VIDEO_IMX258
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
 	---help---
-	  This is a Video4Linux2 sensor-level driver for the Sony
+	  This is a Video4Linux2 sensor driver for the Sony
 	  IMX258 camera.
 
 	  To compile this driver as a module, choose M here: the
@@ -611,7 +611,7 @@ config VIDEO_IMX274
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
 	---help---
-	  This is a V4L2 sensor-level driver for the Sony IMX274
+	  This is a V4L2 sensor driver for the Sony IMX274
 	  CMOS image sensor.
 
 config VIDEO_OV2640
@@ -619,7 +619,7 @@ config VIDEO_OV2640
 	depends on VIDEO_V4L2 && I2C
 	depends on MEDIA_CAMERA_SUPPORT
 	help
-	  This is a Video4Linux2 sensor-level driver for the OmniVision
+	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV2640 camera.
 
 	  To compile this driver as a module, choose M here: the
@@ -631,7 +631,7 @@ config VIDEO_OV2659
 	depends on MEDIA_CAMERA_SUPPORT
 	select V4L2_FWNODE
 	---help---
-	  This is a Video4Linux2 sensor-level driver for the OmniVision
+	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV2659 camera.
 
 	  To compile this driver as a module, choose M here: the
@@ -643,7 +643,7 @@ config VIDEO_OV2685
 	depends on MEDIA_CAMERA_SUPPORT
 	select V4L2_FWNODE
 	---help---
-	  This is a Video4Linux2 sensor-level driver for the OmniVision
+	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV2685 camera.
 
 	  To compile this driver as a module, choose M here: the
@@ -656,7 +656,7 @@ config VIDEO_OV5640
 	depends on MEDIA_CAMERA_SUPPORT
 	select V4L2_FWNODE
 	---help---
-	  This is a Video4Linux2 sensor-level driver for the Omnivision
+	  This is a Video4Linux2 sensor driver for the Omnivision
 	  OV5640 camera sensor with a MIPI CSI-2 interface.
 
 config VIDEO_OV5645
@@ -666,7 +666,7 @@ config VIDEO_OV5645
 	depends on MEDIA_CAMERA_SUPPORT
 	select V4L2_FWNODE
 	---help---
-	  This is a Video4Linux2 sensor-level driver for the OmniVision
+	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV5645 camera.
 
 	  To compile this driver as a module, choose M here: the
@@ -678,7 +678,7 @@ config VIDEO_OV5647
 	depends on MEDIA_CAMERA_SUPPORT
 	select V4L2_FWNODE
 	---help---
-	  This is a Video4Linux2 sensor-level driver for the OmniVision
+	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV5647 camera.
 
 	  To compile this driver as a module, choose M here: the
@@ -689,7 +689,7 @@ config VIDEO_OV6650
 	depends on I2C && VIDEO_V4L2
 	depends on MEDIA_CAMERA_SUPPORT
 	---help---
-	  This is a Video4Linux2 sensor-level driver for the OmniVision
+	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV6650 camera.
 
 	  To compile this driver as a module, choose M here: the
@@ -702,7 +702,7 @@ config VIDEO_OV5670
 	depends on MEDIA_CONTROLLER
 	select V4L2_FWNODE
 	---help---
-	  This is a Video4Linux2 sensor-level driver for the OmniVision
+	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV5670 camera.
 
 	  To compile this driver as a module, choose M here: the
@@ -713,7 +713,7 @@ config VIDEO_OV5695
 	depends on I2C && VIDEO_V4L2
 	depends on MEDIA_CAMERA_SUPPORT
 	---help---
-	  This is a Video4Linux2 sensor-level driver for the OmniVision
+	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV5695 camera.
 
 	  To compile this driver as a module, choose M here: the
@@ -725,7 +725,7 @@ config VIDEO_OV7251
 	depends on MEDIA_CAMERA_SUPPORT
 	select V4L2_FWNODE
 	help
-	  This is a Video4Linux2 sensor-level driver for the OmniVision
+	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV7251 camera.
 
 	  To compile this driver as a module, choose M here: the
@@ -736,7 +736,7 @@ config VIDEO_OV772X
 	depends on I2C && VIDEO_V4L2
 	depends on MEDIA_CAMERA_SUPPORT
 	---help---
-	  This is a Video4Linux2 sensor-level driver for the OmniVision
+	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV772x camera.
 
 	  To compile this driver as a module, choose M here: the
@@ -747,7 +747,7 @@ config VIDEO_OV7640
 	depends on I2C && VIDEO_V4L2
 	depends on MEDIA_CAMERA_SUPPORT
 	---help---
-	  This is a Video4Linux2 sensor-level driver for the OmniVision
+	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV7640 camera.
 
 	  To compile this driver as a module, choose M here: the
@@ -759,7 +759,7 @@ config VIDEO_OV7670
 	depends on MEDIA_CAMERA_SUPPORT
 	select V4L2_FWNODE
 	---help---
-	  This is a Video4Linux2 sensor-level driver for the OmniVision
+	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV7670 VGA camera.  It currently only works with the M88ALP01
 	  controller.
 
@@ -768,14 +768,14 @@ config VIDEO_OV7740
 	depends on I2C && VIDEO_V4L2
 	depends on MEDIA_CAMERA_SUPPORT
 	---help---
-	  This is a Video4Linux2 sensor-level driver for the OmniVision
+	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV7740 VGA camera sensor.
 
 config VIDEO_OV9650
 	tristate "OmniVision OV9650/OV9652 sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	---help---
-	  This is a V4L2 sensor-level driver for the Omnivision
+	  This is a V4L2 sensor driver for the Omnivision
 	  OV9650 and OV9652 camera sensors.
 
 config VIDEO_OV13858
@@ -784,7 +784,7 @@ config VIDEO_OV13858
 	depends on MEDIA_CAMERA_SUPPORT
 	select V4L2_FWNODE
 	---help---
-	  This is a Video4Linux2 sensor-level driver for the OmniVision
+	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV13858 camera.
 
 config VIDEO_VS6624
@@ -792,7 +792,7 @@ config VIDEO_VS6624
 	depends on VIDEO_V4L2 && I2C
 	depends on MEDIA_CAMERA_SUPPORT
 	---help---
-	  This is a Video4Linux2 sensor-level driver for the ST VS6624
+	  This is a Video4Linux2 sensor driver for the ST VS6624
 	  camera.
 
 	  To compile this driver as a module, choose M here: the
@@ -820,7 +820,7 @@ config VIDEO_MT9P031
 	depends on MEDIA_CAMERA_SUPPORT
 	select VIDEO_APTINA_PLL
 	---help---
-	  This is a Video4Linux2 sensor-level driver for the Aptina
+	  This is a Video4Linux2 sensor driver for the Aptina
 	  (Micron) mt9p031 5 Mpixel camera.
 
 config VIDEO_MT9T001
@@ -828,7 +828,7 @@ config VIDEO_MT9T001
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
 	---help---
-	  This is a Video4Linux2 sensor-level driver for the Aptina
+	  This is a Video4Linux2 sensor driver for the Aptina
 	  (Micron) mt0t001 3 Mpixel camera.
 
 config VIDEO_MT9T112
@@ -836,7 +836,7 @@ config VIDEO_MT9T112
 	depends on I2C && VIDEO_V4L2
 	depends on MEDIA_CAMERA_SUPPORT
 	---help---
-	  This is a Video4Linux2 sensor-level driver for the Aptina
+	  This is a Video4Linux2 sensor driver for the Aptina
 	  (Micron) MT9T111 and MT9T112 3 Mpixel camera.
 
 	  To compile this driver as a module, choose M here: the
@@ -847,7 +847,7 @@ config VIDEO_MT9V011
 	depends on I2C && VIDEO_V4L2
 	depends on MEDIA_CAMERA_SUPPORT
 	---help---
-	  This is a Video4Linux2 sensor-level driver for the Micron
+	  This is a Video4Linux2 sensor driver for the Micron
 	  mt0v011 1.3 Mpixel camera.  It currently only works with the
 	  em28xx driver.
 
@@ -858,7 +858,7 @@ config VIDEO_MT9V032
 	select REGMAP_I2C
 	select V4L2_FWNODE
 	---help---
-	  This is a Video4Linux2 sensor-level driver for the Micron
+	  This is a Video4Linux2 sensor driver for the Micron
 	  MT9V032 752x480 CMOS sensor.
 
 config VIDEO_SR030PC30
@@ -882,7 +882,7 @@ config VIDEO_RJ54N1
 	depends on I2C && VIDEO_V4L2
 	depends on MEDIA_CAMERA_SUPPORT
 	help
-	  This is a V4L2 sensor-level driver for Sharp RJ54N1CB0C CMOS image
+	  This is a V4L2 sensor driver for Sharp RJ54N1CB0C CMOS image
 	  sensor.
 
 	  To compile this driver as a module, choose M here: the
@@ -893,7 +893,7 @@ config VIDEO_S5K6AA
 	depends on MEDIA_CAMERA_SUPPORT
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	---help---
-	  This is a V4L2 sensor-level driver for Samsung S5K6AA(FX) 1.3M
+	  This is a V4L2 sensor driver for Samsung S5K6AA(FX) 1.3M
 	  camera sensor with an embedded SoC image signal processor.
 
 config VIDEO_S5K6A3
@@ -901,7 +901,7 @@ config VIDEO_S5K6A3
 	depends on MEDIA_CAMERA_SUPPORT
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	---help---
-	  This is a V4L2 sensor-level driver for Samsung S5K6A3 raw
+	  This is a V4L2 sensor driver for Samsung S5K6A3 raw
 	  camera sensor.
 
 config VIDEO_S5K4ECGX
@@ -909,7 +909,7 @@ config VIDEO_S5K4ECGX
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	select CRC32
 	---help---
-	  This is a V4L2 sensor-level driver for Samsung S5K4ECGX 5M
+	  This is a V4L2 sensor driver for Samsung S5K4ECGX 5M
 	  camera sensor with an embedded SoC image signal processor.
 
 config VIDEO_S5K5BAF
@@ -917,7 +917,7 @@ config VIDEO_S5K5BAF
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	select V4L2_FWNODE
 	---help---
-	  This is a V4L2 sensor-level driver for Samsung S5K5BAF 2M
+	  This is a V4L2 sensor driver for Samsung S5K5BAF 2M
 	  camera sensor with an embedded SoC image signal processor.
 
 source "drivers/media/i2c/smiapp/Kconfig"
@@ -928,7 +928,7 @@ config VIDEO_S5C73M3
 	depends on I2C && SPI && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	select V4L2_FWNODE
 	---help---
-	  This is a V4L2 sensor-level driver for Samsung S5C73M3
+	  This is a V4L2 sensor driver for Samsung S5C73M3
 	  8 Mpixel camera.
 
 comment "Flash devices"
-- 
2.11.0
