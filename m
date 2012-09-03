Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2541 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab2ICNsz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2012 09:48:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 08/10] v4l2: remove experimental tag from a number of old drivers.
Date: Mon,  3 Sep 2012 15:48:42 +0200
Message-Id: <8325f13373f90cb02b7e4fce16499ab6b3378125.1346679785.git.hans.verkuil@cisco.com>
In-Reply-To: <1346680124-15169-1-git-send-email-hverkuil@xs4all.nl>
References: <1346680124-15169-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c31da93f2bf615b90086d749e3f3eae6d6c3fc41.1346679785.git.hans.verkuil@cisco.com>
References: <c31da93f2bf615b90086d749e3f3eae6d6c3fc41.1346679785.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

A number of old drivers still had the experimental tag. Time to remove it.

It concerns the following drivers:

VIDEO_TLV320AIC23B
USB_STKWEBCAM
VIDEO_CX18
VIDEO_CX18_ALSA
VIDEO_ZORAN_AVS6EYES
DVB_USB_AF9005
MEDIA_TUNER_TEA5761
VIDEO_NOON010PC30

This decision was taken during the 2012 Media Workshop.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/Kconfig           |    4 ++--
 drivers/media/pci/cx18/Kconfig      |    4 ++--
 drivers/media/pci/zoran/Kconfig     |    4 ++--
 drivers/media/tuners/Kconfig        |    5 ++---
 drivers/media/usb/dvb-usb/Kconfig   |    2 +-
 drivers/media/usb/stkwebcam/Kconfig |    2 +-
 6 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 9a5a059..64e0c5c 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -117,7 +117,7 @@ config VIDEO_CS53L32A
 
 config VIDEO_TLV320AIC23B
 	tristate "Texas Instruments TLV320AIC23B audio codec"
-	depends on VIDEO_V4L2 && I2C && EXPERIMENTAL
+	depends on VIDEO_V4L2 && I2C
 	---help---
 	  Support for the Texas Instruments TLV320AIC23B audio codec.
 
@@ -469,7 +469,7 @@ config VIDEO_SR030PC30
 
 config VIDEO_NOON010PC30
 	tristate "Siliconfile NOON010PC30 sensor support"
-	depends on I2C && VIDEO_V4L2 && EXPERIMENTAL && VIDEO_V4L2_SUBDEV_API
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
 	---help---
 	  This driver supports NOON010PC30 CIF camera from Siliconfile
diff --git a/drivers/media/pci/cx18/Kconfig b/drivers/media/pci/cx18/Kconfig
index 9a9f765..c675b83 100644
--- a/drivers/media/pci/cx18/Kconfig
+++ b/drivers/media/pci/cx18/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_CX18
 	tristate "Conexant cx23418 MPEG encoder support"
-	depends on VIDEO_V4L2 && DVB_CORE && PCI && I2C && EXPERIMENTAL
+	depends on VIDEO_V4L2 && DVB_CORE && PCI && I2C
 	select I2C_ALGOBIT
 	select VIDEOBUF_VMALLOC
 	depends on RC_CORE
@@ -25,7 +25,7 @@ config VIDEO_CX18
 
 config VIDEO_CX18_ALSA
 	tristate "Conexant 23418 DMA audio support"
-	depends on VIDEO_CX18 && SND && EXPERIMENTAL
+	depends on VIDEO_CX18 && SND
 	select SND_PCM
 	---help---
 	  This is a video4linux driver for direct (DMA) audio on
diff --git a/drivers/media/pci/zoran/Kconfig b/drivers/media/pci/zoran/Kconfig
index a9b2318..26ca870 100644
--- a/drivers/media/pci/zoran/Kconfig
+++ b/drivers/media/pci/zoran/Kconfig
@@ -65,8 +65,8 @@ config VIDEO_ZORAN_LML33R10
 	  card.
 
 config VIDEO_ZORAN_AVS6EYES
-	tristate "AverMedia 6 Eyes support (EXPERIMENTAL)"
-	depends on VIDEO_ZORAN_ZR36060 && EXPERIMENTAL
+	tristate "AverMedia 6 Eyes support"
+	depends on VIDEO_ZORAN_ZR36060
 	select VIDEO_BT856 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_BT866 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_KS0127 if MEDIA_SUBDRV_AUTOSELECT
diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index 80238b9..901d886 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -28,7 +28,7 @@ config MEDIA_TUNER
 	select MEDIA_TUNER_XC4000 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MT20XX if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA8290 if MEDIA_SUBDRV_AUTOSELECT
-	select MEDIA_TUNER_TEA5761 if MEDIA_SUBDRV_AUTOSELECT && MEDIA_RADIO_SUPPORT && EXPERIMENTAL
+	select MEDIA_TUNER_TEA5761 if MEDIA_SUBDRV_AUTOSELECT && MEDIA_RADIO_SUPPORT
 	select MEDIA_TUNER_TEA5767 if MEDIA_SUBDRV_AUTOSELECT && MEDIA_RADIO_SUPPORT
 	select MEDIA_TUNER_SIMPLE if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA9887 if MEDIA_SUBDRV_AUTOSELECT
@@ -78,9 +78,8 @@ config MEDIA_TUNER_TDA9887
 	  analog IF demodulator.
 
 config MEDIA_TUNER_TEA5761
-	tristate "TEA 5761 radio tuner (EXPERIMENTAL)"
+	tristate "TEA 5761 radio tuner"
 	depends on MEDIA_SUPPORT && I2C
-	depends on EXPERIMENTAL
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to include support for the Philips TEA5761 radio tuner.
diff --git a/drivers/media/usb/dvb-usb/Kconfig b/drivers/media/usb/dvb-usb/Kconfig
index 3c5fff8..fa0b293 100644
--- a/drivers/media/usb/dvb-usb/Kconfig
+++ b/drivers/media/usb/dvb-usb/Kconfig
@@ -227,7 +227,7 @@ config DVB_USB_OPERA1
 
 config DVB_USB_AF9005
 	tristate "Afatech AF9005 DVB-T USB1.1 support"
-	depends on DVB_USB && EXPERIMENTAL
+	depends on DVB_USB
 	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_QT1010 if MEDIA_SUBDRV_AUTOSELECT
 	help
diff --git a/drivers/media/usb/stkwebcam/Kconfig b/drivers/media/usb/stkwebcam/Kconfig
index 2fb0c2b..a6a00aa 100644
--- a/drivers/media/usb/stkwebcam/Kconfig
+++ b/drivers/media/usb/stkwebcam/Kconfig
@@ -1,6 +1,6 @@
 config USB_STKWEBCAM
 	tristate "USB Syntek DC1125 Camera support"
-	depends on VIDEO_V4L2 && EXPERIMENTAL
+	depends on VIDEO_V4L2
 	---help---
 	  Say Y here if you want to use this type of camera.
 	  Supported devices are typically found in some Asus laptops,
-- 
1.7.10.4

