Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:53671 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab1H3RWD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 13:22:03 -0400
Date: Tue, 30 Aug 2011 19:22:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] media: none of the drivers should be enabled by default
Message-ID: <Pine.LNX.4.64.1108301921040.19151@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

None of the media drivers are compulsory, let users select which drivers
they want to build, instead of having to unselect them one by one.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/common/tuners/Kconfig |   23 +----------------------
 drivers/media/radio/Kconfig         |    1 -
 drivers/media/rc/Kconfig            |   16 +---------------
 drivers/media/rc/keymaps/Kconfig    |    1 -
 drivers/media/video/Kconfig         |    7 ++-----
 5 files changed, 4 insertions(+), 44 deletions(-)

diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
index 996302a..1e53057 100644
--- a/drivers/media/common/tuners/Kconfig
+++ b/drivers/media/common/tuners/Kconfig
@@ -33,7 +33,7 @@ config MEDIA_TUNER
 	select MEDIA_TUNER_MC44S803 if !MEDIA_TUNER_CUSTOMISE
 
 config MEDIA_TUNER_CUSTOMISE
-	bool "Customize analog and hybrid tuner modules to build"
+	bool "Select analog and hybrid tuner modules to build"
 	depends on MEDIA_TUNER
 	default y if EXPERT
 	help
@@ -52,7 +52,6 @@ config MEDIA_TUNER_SIMPLE
 	tristate "Simple tuner support"
 	depends on VIDEO_MEDIA && I2C
 	select MEDIA_TUNER_TDA9887
-	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to include support for various simple tuners.
 
@@ -61,28 +60,24 @@ config MEDIA_TUNER_TDA8290
 	depends on VIDEO_MEDIA && I2C
 	select MEDIA_TUNER_TDA827X
 	select MEDIA_TUNER_TDA18271
-	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to include support for Philips TDA8290+8275(a) tuner.
 
 config MEDIA_TUNER_TDA827X
 	tristate "Philips TDA827X silicon tuner"
 	depends on VIDEO_MEDIA && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  A DVB-T silicon tuner module. Say Y when you want to support this tuner.
 
 config MEDIA_TUNER_TDA18271
 	tristate "NXP TDA18271 silicon tuner"
 	depends on VIDEO_MEDIA && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  A silicon tuner module. Say Y when you want to support this tuner.
 
 config MEDIA_TUNER_TDA9887
 	tristate "TDA 9885/6/7 analog IF demodulator"
 	depends on VIDEO_MEDIA && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to include support for Philips TDA9885/6/7
 	  analog IF demodulator.
@@ -91,63 +86,54 @@ config MEDIA_TUNER_TEA5761
 	tristate "TEA 5761 radio tuner (EXPERIMENTAL)"
 	depends on VIDEO_MEDIA && I2C
 	depends on EXPERIMENTAL
-	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to include support for the Philips TEA5761 radio tuner.
 
 config MEDIA_TUNER_TEA5767
 	tristate "TEA 5767 radio tuner"
 	depends on VIDEO_MEDIA && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to include support for the Philips TEA5767 radio tuner.
 
 config MEDIA_TUNER_MT20XX
 	tristate "Microtune 2032 / 2050 tuners"
 	depends on VIDEO_MEDIA && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to include support for the MT2032 / MT2050 tuner.
 
 config MEDIA_TUNER_MT2060
 	tristate "Microtune MT2060 silicon IF tuner"
 	depends on VIDEO_MEDIA && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  A driver for the silicon IF tuner MT2060 from Microtune.
 
 config MEDIA_TUNER_MT2266
 	tristate "Microtune MT2266 silicon tuner"
 	depends on VIDEO_MEDIA && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  A driver for the silicon baseband tuner MT2266 from Microtune.
 
 config MEDIA_TUNER_MT2131
 	tristate "Microtune MT2131 silicon tuner"
 	depends on VIDEO_MEDIA && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  A driver for the silicon baseband tuner MT2131 from Microtune.
 
 config MEDIA_TUNER_QT1010
 	tristate "Quantek QT1010 silicon tuner"
 	depends on VIDEO_MEDIA && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  A driver for the silicon tuner QT1010 from Quantek.
 
 config MEDIA_TUNER_XC2028
 	tristate "XCeive xc2028/xc3028 tuners"
 	depends on VIDEO_MEDIA && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to include support for the xc2028/xc3028 tuners.
 
 config MEDIA_TUNER_XC5000
 	tristate "Xceive XC5000 silicon tuner"
 	depends on VIDEO_MEDIA && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  A driver for the silicon tuner XC5000 from Xceive.
 	  This device is only used inside a SiP called together with a
@@ -156,7 +142,6 @@ config MEDIA_TUNER_XC5000
 config MEDIA_TUNER_XC4000
 	tristate "Xceive XC4000 silicon tuner"
 	depends on VIDEO_MEDIA && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  A driver for the silicon tuner XC4000 from Xceive.
 	  This device is only used inside a SiP called together with a
@@ -165,42 +150,36 @@ config MEDIA_TUNER_XC4000
 config MEDIA_TUNER_MXL5005S
 	tristate "MaxLinear MSL5005S silicon tuner"
 	depends on VIDEO_MEDIA && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  A driver for the silicon tuner MXL5005S from MaxLinear.
 
 config MEDIA_TUNER_MXL5007T
 	tristate "MaxLinear MxL5007T silicon tuner"
 	depends on VIDEO_MEDIA && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  A driver for the silicon tuner MxL5007T from MaxLinear.
 
 config MEDIA_TUNER_MC44S803
 	tristate "Freescale MC44S803 Low Power CMOS Broadband tuners"
 	depends on VIDEO_MEDIA && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to support the Freescale MC44S803 based tuners
 
 config MEDIA_TUNER_MAX2165
 	tristate "Maxim MAX2165 silicon tuner"
 	depends on VIDEO_MEDIA && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  A driver for the silicon tuner MAX2165 from Maxim.
 
 config MEDIA_TUNER_TDA18218
 	tristate "NXP TDA18218 silicon tuner"
 	depends on VIDEO_MEDIA && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  NXP TDA18218 silicon tuner driver.
 
 config MEDIA_TUNER_TDA18212
 	tristate "NXP TDA18212 silicon tuner"
 	depends on VIDEO_MEDIA && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  NXP TDA18212 silicon tuner driver.
 
diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 52798a1..0195335 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -5,7 +5,6 @@
 menuconfig RADIO_ADAPTERS
 	bool "Radio Adapters"
 	depends on VIDEO_V4L2
-	default y
 	---help---
 	  Say Y here to enable selecting AM/FM radio adapters.
 
diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 899f783..2a4f829 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -1,7 +1,6 @@
 menuconfig RC_CORE
 	tristate "Remote Controller adapters"
 	depends on INPUT
-	default INPUT
 	---help---
 	  Enable support for Remote Controllers on Linux. This is
 	  needed in order to support several video capture adapters.
@@ -11,12 +10,9 @@ menuconfig RC_CORE
 	  if you don't need IR, as otherwise, you may not be able to
 	  compile the driver for your adapter.
 
-if RC_CORE
-
 config LIRC
 	tristate
-	default y
-
+	depends on RC_CORE
 	---help---
 	   Enable this option to build the Linux Infrared Remote
 	   Control (LIRC) core device interface driver. The LIRC
@@ -30,7 +26,6 @@ config IR_NEC_DECODER
 	tristate "Enable IR raw decoder for the NEC protocol"
 	depends on RC_CORE
 	select BITREVERSE
-	default y
 
 	---help---
 	   Enable this option if you have IR with NEC protocol, and
@@ -40,7 +35,6 @@ config IR_RC5_DECODER
 	tristate "Enable IR raw decoder for the RC-5 protocol"
 	depends on RC_CORE
 	select BITREVERSE
-	default y
 
 	---help---
 	   Enable this option if you have IR with RC-5 protocol, and
@@ -50,7 +44,6 @@ config IR_RC6_DECODER
 	tristate "Enable IR raw decoder for the RC6 protocol"
 	depends on RC_CORE
 	select BITREVERSE
-	default y
 
 	---help---
 	   Enable this option if you have an infrared remote control which
@@ -60,7 +53,6 @@ config IR_JVC_DECODER
 	tristate "Enable IR raw decoder for the JVC protocol"
 	depends on RC_CORE
 	select BITREVERSE
-	default y
 
 	---help---
 	   Enable this option if you have an infrared remote control which
@@ -69,7 +61,6 @@ config IR_JVC_DECODER
 config IR_SONY_DECODER
 	tristate "Enable IR raw decoder for the Sony protocol"
 	depends on RC_CORE
-	default y
 
 	---help---
 	   Enable this option if you have an infrared remote control which
@@ -79,7 +70,6 @@ config IR_RC5_SZ_DECODER
 	tristate "Enable IR raw decoder for the RC-5 (streamzap) protocol"
 	depends on RC_CORE
 	select BITREVERSE
-	default y
 
 	---help---
 	   Enable this option if you have IR with RC-5 (streamzap) protocol,
@@ -91,7 +81,6 @@ config IR_MCE_KBD_DECODER
 	tristate "Enable IR raw decoder for the MCE keyboard/mouse protocol"
 	depends on RC_CORE
 	select BITREVERSE
-	default y
 
 	---help---
 	   Enable this option if you have a Microsoft Remote Keyboard for
@@ -102,7 +91,6 @@ config IR_LIRC_CODEC
 	tristate "Enable IR to LIRC bridge"
 	depends on RC_CORE
 	depends on LIRC
-	default y
 
 	---help---
 	   Enable this option to pass raw IR to and from userspace via
@@ -236,5 +224,3 @@ config RC_LOOPBACK
 
 	   To compile this driver as a module, choose M here: the module will
 	   be called rc_loopback.
-
-endif #RC_CORE
diff --git a/drivers/media/rc/keymaps/Kconfig b/drivers/media/rc/keymaps/Kconfig
index 8e615fd..dbaacf1 100644
--- a/drivers/media/rc/keymaps/Kconfig
+++ b/drivers/media/rc/keymaps/Kconfig
@@ -1,7 +1,6 @@
 config RC_MAP
 	tristate "Compile Remote Controller keymap modules"
 	depends on RC_CORE
-	default y
 
 	---help---
 	   This option enables the compilation of lots of Remote
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index f574dc0..d26443d 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -73,7 +73,6 @@ config VIDEOBUF2_DMA_SG
 menuconfig VIDEO_CAPTURE_DRIVERS
 	bool "Video capture adapters"
 	depends on VIDEO_V4L2
-	default y
 	---help---
 	  Say Y here to enable selecting the video adapters for
 	  webcams, analog TV, and hybrid analog/digital TV.
@@ -113,8 +112,8 @@ config VIDEO_HELPER_CHIPS_AUTO
 
 config VIDEO_IR_I2C
 	tristate "I2C module for IR" if !VIDEO_HELPER_CHIPS_AUTO
-	depends on I2C && RC_CORE
-	default y
+	depends on I2C
+	select RC_CORE
 	---help---
 	  Most boards have an IR chip directly connected via GPIO. However,
 	  some video boards have the IR connected via I2C bus.
@@ -556,7 +555,6 @@ config VIDEO_VIU
 	tristate "Freescale VIU Video Driver"
 	depends on VIDEO_V4L2 && PPC_MPC512x
 	select VIDEOBUF_DMA_CONTIG
-	default y
 	---help---
 	  Support for Freescale VIU video driver. This device captures
 	  video data, or overlays video on DIU frame buffer.
@@ -986,7 +984,6 @@ source "drivers/media/video/s5p-tv/Kconfig"
 menuconfig V4L_USB_DRIVERS
 	bool "V4L USB devices"
 	depends on USB
-	default y
 
 if V4L_USB_DRIVERS && USB
 
-- 
1.7.2.5

