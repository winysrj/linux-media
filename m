Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6RD5hMB018223
	for <video4linux-list@redhat.com>; Sun, 27 Jul 2008 09:05:43 -0400
Received: from smtp5.pp.htv.fi (smtp5.pp.htv.fi [213.243.153.39])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6RD5VVk024514
	for <video4linux-list@redhat.com>; Sun, 27 Jul 2008 09:05:31 -0400
Date: Sun, 27 Jul 2008 16:04:55 +0300
From: Adrian Bunk <bunk@kernel.org>
To: mchehab@infradead.org
Message-ID: <20080727130455.GL9301@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: [2.6 patch] drivers/media/: remove select's of FW_LOADER
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

After commit d9b19199e4894089456aaad295023263b5225c1a
(always enable FW_LOADER unless EMBEDDED=y) we can remove
the FW_LOADER select's and corresponding dependencies
on HOTPLUG.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/common/tuners/Kconfig |    9 ++-------
 drivers/media/dvb/bt8xx/Kconfig     |    2 --
 drivers/media/dvb/dvb-usb/Kconfig   |    2 --
 drivers/media/dvb/frontends/Kconfig |   24 ++++++++----------------
 drivers/media/dvb/ttpci/Kconfig     |    4 ----
 drivers/media/dvb/ttusb-dec/Kconfig |    2 --
 drivers/media/video/bt8xx/Kconfig   |    2 --
 drivers/media/video/cx18/Kconfig    |    2 --
 drivers/media/video/cx23885/Kconfig |    2 --
 drivers/media/video/cx25840/Kconfig |    2 --
 drivers/media/video/cx88/Kconfig    |    3 +--
 drivers/media/video/ivtv/Kconfig    |    2 --
 drivers/media/video/pvrusb2/Kconfig |    2 --
 drivers/media/video/saa7134/Kconfig |    2 --
 14 files changed, 11 insertions(+), 49 deletions(-)

3545e7bf967e5e42113ce9e073305fd68389b160 
diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
index 850d568..912c103 100644
--- a/drivers/media/common/tuners/Kconfig
+++ b/drivers/media/common/tuners/Kconfig
@@ -21,9 +21,8 @@ config MEDIA_TUNER
 	tristate
 	default VIDEO_MEDIA && I2C
 	depends on VIDEO_MEDIA && I2C
-	select FW_LOADER if !MEDIA_TUNER_CUSTOMIZE && HOTPLUG
-	select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMIZE && HOTPLUG
-	select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMIZE && HOTPLUG
+	select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMIZE
+	select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMIZE
 	select MEDIA_TUNER_MT20XX if !MEDIA_TUNER_CUSTOMIZE
 	select MEDIA_TUNER_TDA8290 if !MEDIA_TUNER_CUSTOMIZE
 	select MEDIA_TUNER_TEA5761 if !MEDIA_TUNER_CUSTOMIZE
@@ -138,8 +137,6 @@ config MEDIA_TUNER_QT1010
 config MEDIA_TUNER_XC2028
 	tristate "XCeive xc2028/xc3028 tuners"
 	depends on VIDEO_MEDIA && I2C
-	depends on HOTPLUG
-	select FW_LOADER
 	default m if MEDIA_TUNER_CUSTOMIZE
 	help
 	  Say Y here to include support for the xc2028/xc3028 tuners.
@@ -147,8 +144,6 @@ config MEDIA_TUNER_XC2028
 config MEDIA_TUNER_XC5000
 	tristate "Xceive XC5000 silicon tuner"
 	depends on VIDEO_MEDIA && I2C
-	depends on HOTPLUG
-	select FW_LOADER
 	default m if DVB_FE_CUSTOMISE
 	help
 	  A driver for the silicon tuner XC5000 from Xceive.
diff --git a/drivers/media/dvb/bt8xx/Kconfig b/drivers/media/dvb/bt8xx/Kconfig
index 7588db1..7e9c090 100644
--- a/drivers/media/dvb/bt8xx/Kconfig
+++ b/drivers/media/dvb/bt8xx/Kconfig
@@ -1,7 +1,6 @@
 config DVB_BT8XX
 	tristate "BT8xx based PCI cards"
 	depends on DVB_CORE && PCI && I2C && VIDEO_BT848
-	depends on HOTPLUG	# due to FW_LOADER
 	select DVB_MT352 if !DVB_FE_CUSTOMISE
 	select DVB_SP887X if !DVB_FE_CUSTOMISE
 	select DVB_NXT6000 if !DVB_FE_CUSTOMISE
@@ -10,7 +9,6 @@ config DVB_BT8XX
 	select DVB_LGDT330X if !DVB_FE_CUSTOMISE
 	select DVB_ZL10353 if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_SIMPLE if !DVB_FE_CUSTOMISE
-	select FW_LOADER
 	help
 	  Support for PCI cards based on the Bt8xx PCI bridge. Examples are
 	  the Nebula cards, the Pinnacle PCTV cards, the Twinhan DST cards,
diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index a577c0f..eb12591 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -1,8 +1,6 @@
 config DVB_USB
 	tristate "Support for various USB DVB devices"
 	depends on DVB_CORE && USB && I2C && INPUT
-	depends on HOTPLUG	# due to FW_LOADER
-	select FW_LOADER
 	help
 	  By enabling this you will be able to choose the various supported
 	  USB1.1 and USB2.0 DVB devices.
diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
index c20553c..605a6e9 100644
--- a/drivers/media/dvb/frontends/Kconfig
+++ b/drivers/media/dvb/frontends/Kconfig
@@ -97,9 +97,8 @@ comment "DVB-T (terrestrial) frontends"
 
 config DVB_SP8870
 	tristate "Spase sp8870 based"
-	depends on DVB_CORE && I2C && HOTPLUG
+	depends on DVB_CORE && I2C
 	default m if DVB_FE_CUSTOMISE
-	select FW_LOADER
 	help
 	  A DVB-T tuner module. Say Y when you want to support this frontend.
 
@@ -110,9 +109,8 @@ config DVB_SP8870
 
 config DVB_SP887X
 	tristate "Spase sp887x based"
-	depends on DVB_CORE && I2C && HOTPLUG
+	depends on DVB_CORE && I2C
 	default m if DVB_FE_CUSTOMISE
-	select FW_LOADER
 	help
 	  A DVB-T tuner module. Say Y when you want to support this frontend.
 
@@ -144,9 +142,8 @@ config DVB_L64781
 
 config DVB_TDA1004X
 	tristate "Philips TDA10045H/TDA10046H based"
-	depends on DVB_CORE && I2C && HOTPLUG
+	depends on DVB_CORE && I2C
 	default m if DVB_FE_CUSTOMISE
-	select FW_LOADER
 	help
 	  A DVB-T tuner module. Say Y when you want to support this frontend.
 
@@ -211,9 +208,8 @@ config DVB_DIB7000P
 
 config DVB_TDA10048
 	tristate "Philips TDA10048HN based"
-	depends on DVB_CORE && I2C && HOTPLUG
+	depends on DVB_CORE && I2C
 	default m if DVB_FE_CUSTOMISE
-	select FW_LOADER
 	help
 	  A DVB-T tuner module. Say Y when you want to support this frontend.
 
@@ -253,9 +249,8 @@ comment "ATSC (North American/Korean Terrestrial/Cable DTV) frontends"
 
 config DVB_NXT200X
 	tristate "NxtWave Communications NXT2002/NXT2004 based"
-	depends on DVB_CORE && I2C && HOTPLUG
+	depends on DVB_CORE && I2C
 	default m if DVB_FE_CUSTOMISE
-	select FW_LOADER
 	help
 	  An ATSC 8VSB and QAM64/256 tuner module. Say Y when you want
 	  to support this frontend.
@@ -268,9 +263,8 @@ config DVB_NXT200X
 
 config DVB_OR51211
 	tristate "Oren OR51211 based"
-	depends on DVB_CORE && I2C && HOTPLUG
+	depends on DVB_CORE && I2C
 	default m if DVB_FE_CUSTOMISE
-	select FW_LOADER
 	help
 	  An ATSC 8VSB tuner module. Say Y when you want to support this frontend.
 
@@ -281,9 +275,8 @@ config DVB_OR51211
 
 config DVB_OR51132
 	tristate "Oren OR51132 based"
-	depends on DVB_CORE && I2C && HOTPLUG
+	depends on DVB_CORE && I2C
 	default m if DVB_FE_CUSTOMISE
-	select FW_LOADER
 	help
 	  An ATSC 8VSB and QAM64/256 tuner module. Say Y when you want
 	  to support this frontend.
@@ -297,9 +290,8 @@ config DVB_OR51132
 
 config DVB_BCM3510
 	tristate "Broadcom BCM3510"
-	depends on DVB_CORE && I2C && HOTPLUG
+	depends on DVB_CORE && I2C
 	default m if DVB_FE_CUSTOMISE
-	select FW_LOADER
 	help
 	  An ATSC 8VSB/16VSB and QAM64/256 tuner module. Say Y when you want to
 	  support this frontend.
diff --git a/drivers/media/dvb/ttpci/Kconfig b/drivers/media/dvb/ttpci/Kconfig
index 87c973a..41b5a98 100644
--- a/drivers/media/dvb/ttpci/Kconfig
+++ b/drivers/media/dvb/ttpci/Kconfig
@@ -5,8 +5,6 @@ config TTPCI_EEPROM
 config DVB_AV7110
 	tristate "AV7110 cards"
 	depends on DVB_CORE && PCI && I2C
-	depends on HOTPLUG
-	select FW_LOADER if !DVB_AV7110_FIRMWARE
 	select TTPCI_EEPROM
 	select VIDEO_SAA7146_VV
 	depends on VIDEO_DEV	# dependencies of VIDEO_SAA7146_VV
@@ -127,14 +125,12 @@ config DVB_BUDGET_AV
 	depends on DVB_BUDGET_CORE && I2C
 	select VIDEO_SAA7146_VV
 	depends on VIDEO_DEV	# dependencies of VIDEO_SAA7146_VV
-	depends on HOTPLUG	# dependency of FW_LOADER
 	select DVB_PLL if !DVB_FE_CUSTOMISE
 	select DVB_STV0299 if !DVB_FE_CUSTOMISE
 	select DVB_TDA1004X if !DVB_FE_CUSTOMISE
 	select DVB_TDA10021 if !DVB_FE_CUSTOMISE
 	select DVB_TDA10023 if !DVB_FE_CUSTOMISE
 	select DVB_TUA6100 if !DVB_FE_CUSTOMISE
-	select FW_LOADER
 	help
 	  Support for simple SAA7146 based DVB cards
 	  (so called Budget- or Nova-PCI cards) without onboard
diff --git a/drivers/media/dvb/ttusb-dec/Kconfig b/drivers/media/dvb/ttusb-dec/Kconfig
index a23cc0a..d5f48a3 100644
--- a/drivers/media/dvb/ttusb-dec/Kconfig
+++ b/drivers/media/dvb/ttusb-dec/Kconfig
@@ -1,8 +1,6 @@
 config DVB_TTUSB_DEC
 	tristate "Technotrend/Hauppauge USB DEC devices"
 	depends on DVB_CORE && USB && INPUT
-	depends on HOTPLUG	# due to FW_LOADER
-	select FW_LOADER
 	select CRC32
 	help
 	  Support for external USB adapters designed by Technotrend and
diff --git a/drivers/media/video/bt8xx/Kconfig b/drivers/media/video/bt8xx/Kconfig
index 24a34fc..ce71e8e 100644
--- a/drivers/media/video/bt8xx/Kconfig
+++ b/drivers/media/video/bt8xx/Kconfig
@@ -1,9 +1,7 @@
 config VIDEO_BT848
 	tristate "BT848 Video For Linux"
 	depends on VIDEO_DEV && PCI && I2C && VIDEO_V4L2 && INPUT
-	depends on HOTPLUG	# due to FW_LOADER
 	select I2C_ALGOBIT
-	select FW_LOADER
 	select VIDEO_BTCX
 	select VIDEOBUF_DMA_SG
 	select VIDEO_IR
diff --git a/drivers/media/video/cx18/Kconfig b/drivers/media/video/cx18/Kconfig
index 9aefdc5..ef48565 100644
--- a/drivers/media/video/cx18/Kconfig
+++ b/drivers/media/video/cx18/Kconfig
@@ -2,9 +2,7 @@ config VIDEO_CX18
 	tristate "Conexant cx23418 MPEG encoder support"
 	depends on VIDEO_V4L2 && DVB_CORE && PCI && I2C && EXPERIMENTAL
 	depends on INPUT	# due to VIDEO_IR
-	depends on HOTPLUG	# due to FW_LOADER
 	select I2C_ALGOBIT
-	select FW_LOADER
 	select VIDEO_IR
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
diff --git a/drivers/media/video/cx23885/Kconfig b/drivers/media/video/cx23885/Kconfig
index 5cfb46b..e60bd31 100644
--- a/drivers/media/video/cx23885/Kconfig
+++ b/drivers/media/video/cx23885/Kconfig
@@ -1,9 +1,7 @@
 config VIDEO_CX23885
 	tristate "Conexant cx23885 (2388x successor) support"
 	depends on DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT
-	depends on HOTPLUG	# due to FW_LOADER
 	select I2C_ALGOBIT
-	select FW_LOADER
 	select VIDEO_BTCX
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
diff --git a/drivers/media/video/cx25840/Kconfig b/drivers/media/video/cx25840/Kconfig
index 448f4cd..de515da 100644
--- a/drivers/media/video/cx25840/Kconfig
+++ b/drivers/media/video/cx25840/Kconfig
@@ -1,8 +1,6 @@
 config VIDEO_CX25840
 	tristate "Conexant CX2584x audio/video decoders"
 	depends on VIDEO_V4L2 && I2C && EXPERIMENTAL
-	depends on HOTPLUG # due to FW_LOADER
-	select FW_LOADER
 	---help---
 	  Support for the Conexant CX2584x audio/video decoders.
 
diff --git a/drivers/media/video/cx88/Kconfig b/drivers/media/video/cx88/Kconfig
index 10e20d8..9dd7bdf 100644
--- a/drivers/media/video/cx88/Kconfig
+++ b/drivers/media/video/cx88/Kconfig
@@ -33,9 +33,8 @@ config VIDEO_CX88_ALSA
 
 config VIDEO_CX88_BLACKBIRD
 	tristate "Blackbird MPEG encoder support (cx2388x + cx23416)"
-	depends on VIDEO_CX88 && HOTPLUG
+	depends on VIDEO_CX88
 	select VIDEO_CX2341X
-	select FW_LOADER
 	---help---
 	  This adds support for MPEG encoder cards based on the
 	  Blackbird reference design, using the Conexant 2388x
diff --git a/drivers/media/video/ivtv/Kconfig b/drivers/media/video/ivtv/Kconfig
index 5d7ee8f..0069898 100644
--- a/drivers/media/video/ivtv/Kconfig
+++ b/drivers/media/video/ivtv/Kconfig
@@ -2,9 +2,7 @@ config VIDEO_IVTV
 	tristate "Conexant cx23416/cx23415 MPEG encoder/decoder support"
 	depends on VIDEO_V4L1 && VIDEO_V4L2 && PCI && I2C && EXPERIMENTAL
 	depends on INPUT   # due to VIDEO_IR
-	depends on HOTPLUG # due to FW_LOADER
 	select I2C_ALGOBIT
-	select FW_LOADER
 	select VIDEO_IR
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
diff --git a/drivers/media/video/pvrusb2/Kconfig b/drivers/media/video/pvrusb2/Kconfig
index 4482b2c..19eb274 100644
--- a/drivers/media/video/pvrusb2/Kconfig
+++ b/drivers/media/video/pvrusb2/Kconfig
@@ -2,8 +2,6 @@ config VIDEO_PVRUSB2
 	tristate "Hauppauge WinTV-PVR USB2 support"
 	depends on VIDEO_V4L2 && I2C
 	depends on VIDEO_MEDIA	# Avoids pvrusb = Y / DVB = M
-	depends on HOTPLUG	# due to FW_LOADER
-	select FW_LOADER
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEO_CX2341X
diff --git a/drivers/media/video/saa7134/Kconfig b/drivers/media/video/saa7134/Kconfig
index 83f076a..7021bbf 100644
--- a/drivers/media/video/saa7134/Kconfig
+++ b/drivers/media/video/saa7134/Kconfig
@@ -27,9 +27,7 @@ config VIDEO_SAA7134_ALSA
 config VIDEO_SAA7134_DVB
 	tristate "DVB/ATSC Support for saa7134 based TV cards"
 	depends on VIDEO_SAA7134 && DVB_CORE
-	depends on HOTPLUG	# due to FW_LOADER
 	select VIDEOBUF_DVB
-	select FW_LOADER
 	select DVB_PLL if !DVB_FE_CUSTOMISE
 	select DVB_MT352 if !DVB_FE_CUSTOMISE
 	select DVB_TDA1004X if !DVB_FE_CUSTOMISE

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
