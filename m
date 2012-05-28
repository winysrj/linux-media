Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab2E1MSJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 08:18:09 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	stefanr@s5r6.in-berlin.de
Subject: [RFC PATCHv2 2/3] [media] media: Remove VIDEO_MEDIA Kconfig option
Date: Mon, 28 May 2012 09:17:48 -0300
Message-Id: <1338207469-32606-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1338207469-32606-1-git-send-email-mchehab@redhat.com>
References: <1338207469-32606-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the past, it was possible to have either DVB or V4L2 core
as module and the other as builtin. Such config never make much
sense, and created several issues in order to make the Kconfig
dependency to work, as all drivers that depend on both (most
TV drivers) would need to be compiled as 'm'. Due to that,
the VIDEO_MEDIA config option were added.

Instead of such weird approach, let's just use the MEDIA_SUPPORT
=y or =m to select if the media subsystem core will be either
builtin or module, simplifying the building system logic.

Also, fix the tuners configuration, by enabling them only if
a tuner is required. So, if just webcam/grabbers support is
selected, no tuner option will be selected. Also, if only digital
TV is selected, no analog tuner support is selected.

That removes the need of using EXPERT customise options, when
analog TV is not selected.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/Kconfig               |    4 --
 drivers/media/common/tuners/Kconfig |   63 ++++++++++++++++++-----------------
 drivers/media/video/pvrusb2/Kconfig |    1 -
 3 files changed, 32 insertions(+), 36 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 323b2f0..6d10ccb 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -138,10 +138,6 @@ config DVB_NET
 	  You may want to disable the network support on embedded devices. If
 	  unsure say Y.
 
-config VIDEO_MEDIA
-	tristate
-	default (DVB_CORE && (VIDEO_DEV = n)) || (VIDEO_DEV && (DVB_CORE = n)) || (DVB_CORE && VIDEO_DEV)
-
 source "drivers/media/common/Kconfig"
 source "drivers/media/rc/Kconfig"
 
diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
index 16ee1a4..94c6ff7 100644
--- a/drivers/media/common/tuners/Kconfig
+++ b/drivers/media/common/tuners/Kconfig
@@ -1,6 +1,6 @@
 config MEDIA_ATTACH
 	bool "Load and attach frontend and tuner driver modules as needed"
-	depends on VIDEO_MEDIA
+	depends on MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_RADIO_SUPPORT
 	depends on MODULES
 	default y if !EXPERT
 	help
@@ -20,15 +20,15 @@ config MEDIA_ATTACH
 
 config MEDIA_TUNER
 	tristate
-	default VIDEO_MEDIA && I2C
-	depends on VIDEO_MEDIA && I2C
+	depends on (MEDIA_ANALOG_TV_SUPPORT || MEDIA_RADIO_SUPPORT) && I2C
+	default y
 	select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_XC4000 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MT20XX if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_TDA8290 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_TEA5761 if !MEDIA_TUNER_CUSTOMISE && EXPERIMENTAL
-	select MEDIA_TUNER_TEA5767 if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_TEA5761 if !MEDIA_TUNER_CUSTOMISE && MEDIA_RADIO_SUPPORT && EXPERIMENTAL
+	select MEDIA_TUNER_TEA5767 if !MEDIA_TUNER_CUSTOMISE && MEDIA_RADIO_SUPPORT
 	select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_TDA9887 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MC44S803 if !MEDIA_TUNER_CUSTOMISE
@@ -48,10 +48,11 @@ config MEDIA_TUNER_CUSTOMISE
 
 menu "Customize TV tuners"
 	visible if MEDIA_TUNER_CUSTOMISE
+	depends on MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_RADIO_SUPPORT
 
 config MEDIA_TUNER_SIMPLE
 	tristate "Simple tuner support"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	select MEDIA_TUNER_TDA9887
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
@@ -59,7 +60,7 @@ config MEDIA_TUNER_SIMPLE
 
 config MEDIA_TUNER_TDA8290
 	tristate "TDA 8290/8295 + 8275(a)/18271 tuner combo"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	select MEDIA_TUNER_TDA827X
 	select MEDIA_TUNER_TDA18271
 	default m if MEDIA_TUNER_CUSTOMISE
@@ -68,21 +69,21 @@ config MEDIA_TUNER_TDA8290
 
 config MEDIA_TUNER_TDA827X
 	tristate "Philips TDA827X silicon tuner"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  A DVB-T silicon tuner module. Say Y when you want to support this tuner.
 
 config MEDIA_TUNER_TDA18271
 	tristate "NXP TDA18271 silicon tuner"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  A silicon tuner module. Say Y when you want to support this tuner.
 
 config MEDIA_TUNER_TDA9887
 	tristate "TDA 9885/6/7 analog IF demodulator"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to include support for Philips TDA9885/6/7
@@ -90,7 +91,7 @@ config MEDIA_TUNER_TDA9887
 
 config MEDIA_TUNER_TEA5761
 	tristate "TEA 5761 radio tuner (EXPERIMENTAL)"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	depends on EXPERIMENTAL
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
@@ -98,63 +99,63 @@ config MEDIA_TUNER_TEA5761
 
 config MEDIA_TUNER_TEA5767
 	tristate "TEA 5767 radio tuner"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to include support for the Philips TEA5767 radio tuner.
 
 config MEDIA_TUNER_MT20XX
 	tristate "Microtune 2032 / 2050 tuners"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to include support for the MT2032 / MT2050 tuner.
 
 config MEDIA_TUNER_MT2060
 	tristate "Microtune MT2060 silicon IF tuner"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  A driver for the silicon IF tuner MT2060 from Microtune.
 
 config MEDIA_TUNER_MT2063
 	tristate "Microtune MT2063 silicon IF tuner"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  A driver for the silicon IF tuner MT2063 from Microtune.
 
 config MEDIA_TUNER_MT2266
 	tristate "Microtune MT2266 silicon tuner"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  A driver for the silicon baseband tuner MT2266 from Microtune.
 
 config MEDIA_TUNER_MT2131
 	tristate "Microtune MT2131 silicon tuner"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  A driver for the silicon baseband tuner MT2131 from Microtune.
 
 config MEDIA_TUNER_QT1010
 	tristate "Quantek QT1010 silicon tuner"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  A driver for the silicon tuner QT1010 from Quantek.
 
 config MEDIA_TUNER_XC2028
 	tristate "XCeive xc2028/xc3028 tuners"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to include support for the xc2028/xc3028 tuners.
 
 config MEDIA_TUNER_XC5000
 	tristate "Xceive XC5000 silicon tuner"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  A driver for the silicon tuner XC5000 from Xceive.
@@ -163,7 +164,7 @@ config MEDIA_TUNER_XC5000
 
 config MEDIA_TUNER_XC4000
 	tristate "Xceive XC4000 silicon tuner"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  A driver for the silicon tuner XC4000 from Xceive.
@@ -172,70 +173,70 @@ config MEDIA_TUNER_XC4000
 
 config MEDIA_TUNER_MXL5005S
 	tristate "MaxLinear MSL5005S silicon tuner"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  A driver for the silicon tuner MXL5005S from MaxLinear.
 
 config MEDIA_TUNER_MXL5007T
 	tristate "MaxLinear MxL5007T silicon tuner"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  A driver for the silicon tuner MxL5007T from MaxLinear.
 
 config MEDIA_TUNER_MC44S803
 	tristate "Freescale MC44S803 Low Power CMOS Broadband tuners"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to support the Freescale MC44S803 based tuners
 
 config MEDIA_TUNER_MAX2165
 	tristate "Maxim MAX2165 silicon tuner"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  A driver for the silicon tuner MAX2165 from Maxim.
 
 config MEDIA_TUNER_TDA18218
 	tristate "NXP TDA18218 silicon tuner"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  NXP TDA18218 silicon tuner driver.
 
 config MEDIA_TUNER_FC0011
 	tristate "Fitipower FC0011 silicon tuner"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  Fitipower FC0011 silicon tuner driver.
 
 config MEDIA_TUNER_FC0012
 	tristate "Fitipower FC0012 silicon tuner"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  Fitipower FC0012 silicon tuner driver.
 
 config MEDIA_TUNER_FC0013
 	tristate "Fitipower FC0013 silicon tuner"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  Fitipower FC0013 silicon tuner driver.
 
 config MEDIA_TUNER_TDA18212
 	tristate "NXP TDA18212 silicon tuner"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  NXP TDA18212 silicon tuner driver.
 
 config MEDIA_TUNER_TUA9001
 	tristate "Infineon TUA 9001 silicon tuner"
-	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_SUPPORT && I2C
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  Infineon TUA 9001 silicon tuner driver.
diff --git a/drivers/media/video/pvrusb2/Kconfig b/drivers/media/video/pvrusb2/Kconfig
index f9b6001..25e412e 100644
--- a/drivers/media/video/pvrusb2/Kconfig
+++ b/drivers/media/video/pvrusb2/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_PVRUSB2
 	tristate "Hauppauge WinTV-PVR USB2 support"
 	depends on VIDEO_V4L2 && I2C
-	depends on VIDEO_MEDIA	# Avoids pvrusb = Y / DVB = M
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEO_CX2341X
-- 
1.7.8

