Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway07.websitewelcome.com ([69.56.176.23]:37091 "HELO
	gateway07.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752442AbZIRVJs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 17:09:48 -0400
Received: from [66.15.212.169] (port=30660 helo=[10.140.5.16])
	by gator886.hostgator.com with esmtpsa (SSLv3:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <pete@sensoray.com>)
	id 1Moi6t-0002b0-8w
	for linux-media@vger.kernel.org; Fri, 18 Sep 2009 13:23:07 -0500
Subject: [PATCH 1/9] go7007: Updates to Kconfig and Makefile
From: Pete <pete@sensoray.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 11:23:11 -0700
Message-Id: <1253298191.4314.565.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace "wierd device" with accurate descriptions. Add menu options and
makefile lines for the i2c modules. Added comment about why dvb-usb is
included. Added include sound/config.h for Ubuntu 8.04 distro kernel.

Priority: normal

Signed-off-by: Pete Eberlein <pete@sensoray.com>

diff -r ae90c0408d70 -r a54a706244cf linux/drivers/staging/go7007/Kconfig
--- a/linux/drivers/staging/go7007/Kconfig	Fri Sep 18 00:49:59 2009 -0300
+++ b/linux/drivers/staging/go7007/Kconfig	Fri Sep 18 11:16:14 2009 -0700
@@ -1,5 +1,5 @@
 config VIDEO_GO7007
-	tristate "Go 7007 support"
+	tristate "WIS GO7007 MPEG encoder support"
 	depends on VIDEO_DEV && PCI && I2C && INPUT
 	depends on SND
 	select VIDEOBUF_DMA_SG
@@ -10,17 +10,19 @@
 	select CRC32
 	default N
 	---help---
-	  This is a video4linux driver for some weird device...
+	  This is a video4linux driver for the WIS GO7007 MPEG
+	  encoder chip.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called go7007
 
 config VIDEO_GO7007_USB
-	tristate "Go 7007 USB support"
+	tristate "WIS GO7007 USB support"
 	depends on VIDEO_GO7007 && USB
 	default N
 	---help---
-	  This is a video4linux driver for some weird device...
+	  This is a video4linux driver for the WIS GO7007 MPEG
+	  encoder chip over USB.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called go7007-usb
@@ -30,8 +32,78 @@
 	depends on VIDEO_GO7007_USB && DVB_USB
 	default N
 	---help---
-	  This is a video4linux driver for the Sensoray 2250/2251 device
+	  This is a video4linux driver for the Sensoray 2250/2251 device.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called s2250-board
+	  module will be called s2250
 
+config VIDEO_GO7007_OV7640
+	tristate "OV7640 subdev support"
+	depends on VIDEO_GO7007
+	default N
+	---help---
+	  This is a video4linux driver for the OV7640 sub-device.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wis-ov7640
+
+config VIDEO_GO7007_SAA7113
+	tristate "SAA7113 subdev support"
+	depends on VIDEO_GO7007
+	default N
+	---help---
+	  This is a video4linux driver for the SAA7113 sub-device.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wis-saa7113
+
+config VIDEO_GO7007_SAA7115
+	tristate "SAA7115 subdev support"
+	depends on VIDEO_GO7007
+	default N
+	---help---
+	  This is a video4linux driver for the SAA7115 sub-device.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wis-saa7115
+
+config VIDEO_GO7007_TW9903
+	tristate "TW9903 subdev support"
+	depends on VIDEO_GO7007
+	default N
+	---help---
+	  This is a video4linux driver for the TW9903 sub-device.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wis-tw9903
+
+config VIDEO_GO7007_UDA1342
+	tristate "UDA1342 subdev support"
+	depends on VIDEO_GO7007
+	default N
+	---help---
+	  This is a video4linux driver for the UDA1342 sub-device.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wis-uda1342
+
+config VIDEO_GO7007_SONY_TUNER
+	tristate "Sony tuner subdev support"
+	depends on VIDEO_GO7007
+	default N
+	---help---
+	  This is a video4linux driver for the Sony Tuner sub-device.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wis-sony-tuner
+
+config VIDEO_GO7007_TW2804
+	tristate "TW2804 subdev support"
+	depends on VIDEO_GO7007
+	default N
+	---help---
+	  This is a video4linux driver for the TW2804 sub-device.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wis-tw2804
+
diff -r ae90c0408d70 -r a54a706244cf linux/drivers/staging/go7007/Makefile
--- a/linux/drivers/staging/go7007/Makefile	Fri Sep 18 00:49:59 2009 -0300
+++ b/linux/drivers/staging/go7007/Makefile	Fri Sep 18 11:16:14 2009 -0700
@@ -6,22 +6,34 @@
 obj-$(CONFIG_VIDEO_GO7007) += go7007.o
 obj-$(CONFIG_VIDEO_GO7007_USB) += go7007-usb.o
 obj-$(CONFIG_VIDEO_GO7007_USB_S2250_BOARD) += s2250.o
+obj-$(CONFIG_VIDEO_GO7007_SAA7113) += wis-saa7113.o
+obj-$(CONFIG_VIDEO_GO7007_OV7640) += wis-ov7640.o
+obj-$(CONFIG_VIDEO_GO7007_SAA7115) += wis-saa7115.o
+obj-$(CONFIG_VIDEO_GO7007_TW9903) += wis-tw9903.o
+obj-$(CONFIG_VIDEO_GO7007_UDA1342) += wis-uda1342.o
+obj-$(CONFIG_VIDEO_GO7007_SONY_TUNER) += wis-sony-tuner.o
+obj-$(CONFIG_VIDEO_GO7007_TW2804) += wis-tw2804.o
 
 go7007-objs += go7007-v4l2.o go7007-driver.o go7007-i2c.o go7007-fw.o \
-		snd-go7007.o wis-saa7113.o
+		snd-go7007.o
 
 s2250-objs += s2250-board.o s2250-loader.o
 
-# Uncompile when the saa7134 patches get into upstream
+# Uncomment when the saa7134 patches get into upstream
 #ifneq ($(CONFIG_VIDEO_SAA7134),)
 #obj-$(CONFIG_VIDEO_SAA7134) += saa7134-go7007.o
-#EXTRA_CFLAGS += -Idrivers/media/video/saa7134
+#EXTRA_CFLAGS += -Idrivers/media/video/saa7134 -DSAA7134_MPEG_GO7007=3
 #endif
 
+# S2250 needs cypress ezusb loader from dvb-usb
 ifneq ($(CONFIG_VIDEO_GO7007_USB_S2250_BOARD),)
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-usb
 endif
 
-EXTRA_CFLAGS += -Idrivers/staging/saa7134
 EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
+
+# Ubuntu 8.04 has CONFIG_SND undefined, so include lum sound/config.h too
+ifeq ($(CONFIG_SND),)
+EXTRA_CFLAGS += -include sound/config.h
+endif


