Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201Ab2E1MSI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 08:18:08 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	stefanr@s5r6.in-berlin.de
Subject: [RFC PATCHv2 3/3] [media] media: only show V4L devices based on device type selection
Date: Mon, 28 May 2012 09:17:49 -0300
Message-Id: <1338207469-32606-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1338207469-32606-1-git-send-email-mchehab@redhat.com>
References: <1338207469-32606-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After this patch, the MEDIA*_SUPPORT will be used as a filter,
exposing only devices that are pertinent to one of the 3
V4L types: webcam/grabber, radio, analog TV.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/radio/Kconfig        |    1 +
 drivers/media/video/Kconfig        |   76 ++++++++++++++++++++++++++---------
 drivers/media/video/m5mols/Kconfig |    1 +
 drivers/media/video/smiapp/Kconfig |    1 +
 4 files changed, 59 insertions(+), 20 deletions(-)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index c257da1..24ce5a4 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -5,6 +5,7 @@
 menuconfig RADIO_ADAPTERS
 	bool "Radio Adapters"
 	depends on VIDEO_V4L2
+	depends on MEDIA_RADIO_SUPPORT
 	default y
 	---help---
 	  Say Y here to enable selecting AM/FM radio adapters.
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 99937c9..da363c4 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -5,7 +5,7 @@
 config VIDEO_V4L2
 	tristate
 	depends on VIDEO_DEV && VIDEO_V4L2_COMMON
-	default VIDEO_DEV && VIDEO_V4L2_COMMON
+	default y
 
 config VIDEOBUF_GEN
 	tristate
@@ -73,6 +73,7 @@ config VIDEOBUF2_DMA_SG
 menuconfig VIDEO_CAPTURE_DRIVERS
 	bool "Video capture adapters"
 	depends on VIDEO_V4L2
+	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT
 	default y
 	---help---
 	  Say Y here to enable selecting the video adapters for
@@ -478,6 +479,7 @@ config VIDEO_SMIAPP_PLL
 config VIDEO_OV7670
 	tristate "OmniVision OV7670 sensor support"
 	depends on I2C && VIDEO_V4L2
+	depends on MEDIA_CAMERA_SUPPORT
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the OmniVision
 	  OV7670 VGA camera.  It currently only works with the M88ALP01
@@ -486,6 +488,7 @@ config VIDEO_OV7670
 config VIDEO_VS6624
 	tristate "ST VS6624 sensor support"
 	depends on VIDEO_V4L2 && I2C
+	depends on MEDIA_CAMERA_SUPPORT
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the ST VS6624
 	  camera.
@@ -496,6 +499,7 @@ config VIDEO_VS6624
 config VIDEO_MT9M032
 	tristate "MT9M032 camera sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on MEDIA_CAMERA_SUPPORT
 	select VIDEO_APTINA_PLL
 	---help---
 	  This driver supports MT9M032 camera sensors from Aptina, monochrome
@@ -504,6 +508,7 @@ config VIDEO_MT9M032
 config VIDEO_MT9P031
 	tristate "Aptina MT9P031 support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on MEDIA_CAMERA_SUPPORT
 	select VIDEO_APTINA_PLL
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the Aptina
@@ -512,6 +517,7 @@ config VIDEO_MT9P031
 config VIDEO_MT9T001
 	tristate "Aptina MT9T001 support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on MEDIA_CAMERA_SUPPORT
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the Aptina
 	  (Micron) mt0t001 3 Mpixel camera.
@@ -519,6 +525,7 @@ config VIDEO_MT9T001
 config VIDEO_MT9V011
 	tristate "Micron mt9v011 sensor support"
 	depends on I2C && VIDEO_V4L2
+	depends on MEDIA_CAMERA_SUPPORT
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the Micron
 	  mt0v011 1.3 Mpixel camera.  It currently only works with the
@@ -527,6 +534,7 @@ config VIDEO_MT9V011
 config VIDEO_MT9V032
 	tristate "Micron MT9V032 sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on MEDIA_CAMERA_SUPPORT
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the Micron
 	  MT9V032 752x480 CMOS sensor.
@@ -534,6 +542,7 @@ config VIDEO_MT9V032
 config VIDEO_TCM825X
 	tristate "TCM825x camera sensor support"
 	depends on I2C && VIDEO_V4L2
+	depends on MEDIA_CAMERA_SUPPORT
 	---help---
 	  This is a driver for the Toshiba TCM825x VGA camera sensor.
 	  It is used for example in Nokia N800.
@@ -541,12 +550,14 @@ config VIDEO_TCM825X
 config VIDEO_SR030PC30
 	tristate "Siliconfile SR030PC30 sensor support"
 	depends on I2C && VIDEO_V4L2
+	depends on MEDIA_CAMERA_SUPPORT
 	---help---
 	  This driver supports SR030PC30 VGA camera from Siliconfile
 
 config VIDEO_NOON010PC30
 	tristate "Siliconfile NOON010PC30 sensor support"
 	depends on I2C && VIDEO_V4L2 && EXPERIMENTAL && VIDEO_V4L2_SUBDEV_API
+	depends on MEDIA_CAMERA_SUPPORT
 	---help---
 	  This driver supports NOON010PC30 CIF camera from Siliconfile
 
@@ -554,6 +565,7 @@ source "drivers/media/video/m5mols/Kconfig"
 
 config VIDEO_S5K6AA
 	tristate "Samsung S5K6AAFX sensor support"
+	depends on MEDIA_CAMERA_SUPPORT
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	---help---
 	  This is a V4L2 sensor-level driver for Samsung S5K6AA(FX) 1.3M
@@ -566,6 +578,7 @@ comment "Flash devices"
 config VIDEO_ADP1653
 	tristate "ADP1653 flash support"
 	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+	depends on MEDIA_CAMERA_SUPPORT
 	---help---
 	  This is a driver for the ADP1653 flash controller. It is used for
 	  example in Nokia N900.
@@ -573,6 +586,7 @@ config VIDEO_ADP1653
 config VIDEO_AS3645A
 	tristate "AS3645A flash driver support"
 	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+	depends on MEDIA_CAMERA_SUPPORT
 	---help---
 	  This is a driver for the AS3645A and LM3555 flash controllers. It has
 	  build in control for flash, torch and indicator LEDs.
@@ -647,30 +661,14 @@ menuconfig V4L_USB_DRIVERS
 	depends on USB
 	default y
 
-if V4L_USB_DRIVERS
+if V4L_USB_DRIVERS && MEDIA_CAMERA_SUPPORT
 
-source "drivers/media/video/au0828/Kconfig"
+	comment "Webcam devices"
 
 source "drivers/media/video/uvc/Kconfig"
 
 source "drivers/media/video/gspca/Kconfig"
 
-source "drivers/media/video/pvrusb2/Kconfig"
-
-source "drivers/media/video/hdpvr/Kconfig"
-
-source "drivers/media/video/em28xx/Kconfig"
-
-source "drivers/media/video/tlg2300/Kconfig"
-
-source "drivers/media/video/cx231xx/Kconfig"
-
-source "drivers/media/video/tm6000/Kconfig"
-
-source "drivers/media/video/usbvision/Kconfig"
-
-source "drivers/media/video/sn9c102/Kconfig"
-
 source "drivers/media/video/pwc/Kconfig"
 
 source "drivers/media/video/cpia2/Kconfig"
@@ -711,15 +709,46 @@ config USB_S2255
 	  Say Y here if you want support for the Sensoray 2255 USB device.
 	  This driver can be compiled as a module, called s2255drv.
 
+source "drivers/media/video/sn9c102/Kconfig"
+
+endif # V4L_USB_DRIVERS && MEDIA_CAMERA_SUPPORT
+
+if V4L_USB_DRIVERS
+
+	comment "Webcam and/or TV USB devices"
+
+source "drivers/media/video/em28xx/Kconfig"
+
+endif
+
+if V4L_USB_DRIVERS && MEDIA_ANALOG_TV_SUPPORT
+
+	comment "TV USB devices"
+
+source "drivers/media/video/au0828/Kconfig"
+
+source "drivers/media/video/pvrusb2/Kconfig"
+
+source "drivers/media/video/hdpvr/Kconfig"
+
+source "drivers/media/video/tlg2300/Kconfig"
+
+source "drivers/media/video/cx231xx/Kconfig"
+
+source "drivers/media/video/tm6000/Kconfig"
+
+source "drivers/media/video/usbvision/Kconfig"
+
 endif # V4L_USB_DRIVERS
 
 #
-# PCI drivers configuration
+# PCI drivers configuration - No devices here are for webcams
 #
 
 menuconfig V4L_PCI_DRIVERS
 	bool "V4L PCI(e) devices"
 	depends on PCI
+	depends on MEDIA_ANALOG_TV_SUPPORT
 	default y
 	---help---
 	  Say Y here to enable support for these PCI(e) drivers.
@@ -814,11 +843,13 @@ endif # V4L_PCI_DRIVERS
 
 #
 # ISA & parallel port drivers configuration
+#	All devices here are webcam or grabber devices
 #
 
 menuconfig V4L_ISA_PARPORT_DRIVERS
 	bool "V4L ISA and parallel port devices"
 	depends on ISA || PARPORT
+	depends on MEDIA_CAMERA_SUPPORT
 	default n
 	---help---
 	  Say Y here to enable support for these ISA and parallel port drivers.
@@ -871,8 +902,13 @@ config VIDEO_W9966
 
 endif # V4L_ISA_PARPORT_DRIVERS
 
+#
+# Platform drivers
+#	All drivers here are currently for webcam support
+
 menuconfig V4L_PLATFORM_DRIVERS
 	bool "V4L platform devices"
+	depends on MEDIA_CAMERA_SUPPORT
 	default n
 	---help---
 	  Say Y here to enable support for platform-specific V4L drivers.
diff --git a/drivers/media/video/m5mols/Kconfig b/drivers/media/video/m5mols/Kconfig
index 302dc3d..dc8c250 100644
--- a/drivers/media/video/m5mols/Kconfig
+++ b/drivers/media/video/m5mols/Kconfig
@@ -1,5 +1,6 @@
 config VIDEO_M5MOLS
 	tristate "Fujitsu M-5MOLS 8MP sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on MEDIA_CAMERA_SUPPORT
 	---help---
 	  This driver supports Fujitsu M-5MOLS camera sensor with ISP
diff --git a/drivers/media/video/smiapp/Kconfig b/drivers/media/video/smiapp/Kconfig
index f7b35ff..5dac63f 100644
--- a/drivers/media/video/smiapp/Kconfig
+++ b/drivers/media/video/smiapp/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_SMIAPP
 	tristate "SMIA++/SMIA sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on MEDIA_CAMERA_SUPPORT
 	select VIDEO_SMIAPP_PLL
 	---help---
 	  This is a generic driver for SMIA++/SMIA camera modules.
-- 
1.7.8

