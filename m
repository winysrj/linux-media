Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab2HTSWU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 14:22:20 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7KIMKJs024883
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 20 Aug 2012 14:22:20 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 6/6] [media] Kconfig: merge all customise options into just one
Date: Mon, 20 Aug 2012 15:22:15 -0300
Message-Id: <1345486935-18002-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1345486935-18002-1-git-send-email-mchehab@redhat.com>
References: <1345486935-18002-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of having 3 options to allow customizing the media
sub-drivers (tuners, I2C drivers, frontends), merge all of
them into just one.

That simplifies the life for users, as they can just keep
this untouched.

Life for developers is also simpler, as there's now just
one Kconfig item to remember, for the ancillary sub-drivers
providing supports for chips that could change from one
board design to another.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/Kconfig                  |  19 +++-
 drivers/media/common/b2c2/Kconfig      |  28 ++---
 drivers/media/dvb-frontends/Kconfig    | 195 +++++++++++++++------------------
 drivers/media/i2c/Kconfig              |  21 +---
 drivers/media/pci/bt8xx/Kconfig        |  24 ++--
 drivers/media/pci/cx18/Kconfig         |  10 +-
 drivers/media/pci/cx23885/Kconfig      |  34 +++---
 drivers/media/pci/cx88/Kconfig         |  36 +++---
 drivers/media/pci/ddbridge/Kconfig     |  10 +-
 drivers/media/pci/dm1105/Kconfig       |  14 +--
 drivers/media/pci/mantis/Kconfig       |  20 ++--
 drivers/media/pci/ngene/Kconfig        |  14 +--
 drivers/media/pci/saa7134/Kconfig      |  40 +++----
 drivers/media/pci/saa7146/Kconfig      |   8 +-
 drivers/media/pci/saa7164/Kconfig      |   6 +-
 drivers/media/pci/sta2x11/Kconfig      |   2 +-
 drivers/media/pci/ttpci/Kconfig        |  84 +++++++-------
 drivers/media/pci/zoran/Kconfig        |  26 ++---
 drivers/media/platform/Kconfig         |   2 +-
 drivers/media/platform/davinci/Kconfig |   4 +-
 drivers/media/tuners/Kconfig           |  88 +++++++--------
 drivers/media/usb/au0828/Kconfig       |  10 +-
 drivers/media/usb/cx231xx/Kconfig      |   6 +-
 drivers/media/usb/dvb-usb-v2/Kconfig   |  88 +++++++--------
 drivers/media/usb/dvb-usb/Kconfig      | 148 ++++++++++++-------------
 drivers/media/usb/em28xx/Kconfig       |  28 ++---
 drivers/media/usb/pvrusb2/Kconfig      |  14 +--
 drivers/media/usb/ttusb-budget/Kconfig |  14 +--
 drivers/media/usb/usbvision/Kconfig    |   2 +-
 29 files changed, 488 insertions(+), 507 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 9c3698a..dd13e3a 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -162,10 +162,27 @@ source "drivers/media/common/Kconfig"
 # Ancillary drivers (tuners, i2c, frontends)
 #
 
+config MEDIA_SUBDRV_AUTOSELECT
+	bool "Autoselect analog and hybrid tuner modules to build"
+	depends on MEDIA_TUNER
+	default y
+	help
+	  By default, a TV driver auto-selects all possible tuners
+	  thar could be used by the driver.
+
+	  This is generally the right thing to do, except when there
+	  are strict constraints with regards to the kernel size.
+
+	  Use this option with care, as deselecting tuner drivers which
+	  are in fact necessary will result in TV devices which cannot
+	  be tuned due to lack of the tuning driver.
+
+	  If unsure say Y.
+
 comment "Media ancillary drivers (tuners, sensors, i2c, frontends)"
 
-source "drivers/media/tuners/Kconfig"
 source "drivers/media/i2c/Kconfig"
+source "drivers/media/tuners/Kconfig"
 source "drivers/media/dvb-frontends/Kconfig"
 
 endif # MEDIA_SUPPORT
diff --git a/drivers/media/common/b2c2/Kconfig b/drivers/media/common/b2c2/Kconfig
index e270dd8..29149de 100644
--- a/drivers/media/common/b2c2/Kconfig
+++ b/drivers/media/common/b2c2/Kconfig
@@ -3,20 +3,20 @@ config DVB_B2C2_FLEXCOP
 	depends on DVB_CORE && I2C
 	depends on DVB_B2C2_FLEXCOP_PCI || DVB_B2C2_FLEXCOP_USB
 	default y
-	select DVB_PLL if !DVB_FE_CUSTOMISE
-	select DVB_STV0299 if !DVB_FE_CUSTOMISE
-	select DVB_MT352 if !DVB_FE_CUSTOMISE
-	select DVB_MT312 if !DVB_FE_CUSTOMISE
-	select DVB_NXT200X if !DVB_FE_CUSTOMISE
-	select DVB_STV0297 if !DVB_FE_CUSTOMISE
-	select DVB_BCM3510 if !DVB_FE_CUSTOMISE
-	select DVB_LGDT330X if !DVB_FE_CUSTOMISE
-	select DVB_S5H1420 if !DVB_FE_CUSTOMISE
-	select DVB_TUNER_ITD1000 if !DVB_FE_CUSTOMISE
-	select DVB_ISL6421 if !DVB_FE_CUSTOMISE
-	select DVB_CX24123 if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMISE
-	select DVB_TUNER_CX24113 if !DVB_FE_CUSTOMISE
+	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0299 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_MT352 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_MT312 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_NXT200X if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0297 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_BCM3510 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LGDT330X if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_S5H1420 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TUNER_ITD1000 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_ISL6421 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_CX24123 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_SIMPLE if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TUNER_CX24113 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for the digital TV receiver chip made by B2C2 Inc. included in
 	  Technisats PCI cards and USB boxes.
diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index a08c215..5efec73 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -1,20 +1,5 @@
-config DVB_FE_CUSTOMISE
-	bool "Customise the frontend modules to build"
-	depends on DVB_CORE
-	depends on EXPERT
-	default y if EXPERT
-	help
-	  This allows the user to select/deselect frontend drivers for their
-	  hardware from the build.
-
-	  Use this option with care as deselecting frontends which are in fact
-	  necessary will result in DVB devices which cannot be tuned due to lack
-	  of driver support.
-
-	  If unsure say N.
-
 menu "Customise DVB Frontends"
-	visible if DVB_FE_CUSTOMISE
+	visible if !MEDIA_SUBDRV_AUTOSELECT
 
 comment "Multistandard (satellite) frontends"
 	depends on DVB_CORE
@@ -22,7 +7,7 @@ comment "Multistandard (satellite) frontends"
 config DVB_STB0899
 	tristate "STB0899 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S/S2/DSS Multistandard demodulator. Say Y when you want
 	  to support this demodulator based frontends
@@ -30,7 +15,7 @@ config DVB_STB0899
 config DVB_STB6100
 	tristate "STB6100 based tuners"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A Silicon tuner from ST used in conjunction with the STB0899
 	  demodulator. Say Y when you want to support this tuner.
@@ -38,7 +23,7 @@ config DVB_STB6100
 config DVB_STV090x
 	tristate "STV0900/STV0903(A/B) based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  DVB-S/S2/DSS Multistandard Professional/Broadcast demodulators.
 	  Say Y when you want to support these frontends.
@@ -46,7 +31,7 @@ config DVB_STV090x
 config DVB_STV6110x
 	tristate "STV6110/(A) based tuners"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A Silicon tuner that supports DVB-S and DVB-S2 modes
 
@@ -56,7 +41,7 @@ comment "Multistandard (cable + terrestrial) frontends"
 config DVB_DRXK
 	tristate "Micronas DRXK based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Micronas DRX-K DVB-C/T demodulator.
 
@@ -65,7 +50,7 @@ config DVB_DRXK
 config DVB_TDA18271C2DD
 	tristate "NXP TDA18271C2 silicon tuner"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  NXP TDA18271 silicon tuner.
 
@@ -77,119 +62,119 @@ comment "DVB-S (satellite) frontends"
 config DVB_CX24110
 	tristate "Conexant CX24110 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S tuner module. Say Y when you want to support this frontend.
 
 config DVB_CX24123
 	tristate "Conexant CX24123 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S tuner module. Say Y when you want to support this frontend.
 
 config DVB_MT312
 	tristate "Zarlink VP310/MT312/ZL10313 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S tuner module. Say Y when you want to support this frontend.
 
 config DVB_ZL10036
 	tristate "Zarlink ZL10036 silicon tuner"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S tuner module. Say Y when you want to support this frontend.
 
 config DVB_ZL10039
 	tristate "Zarlink ZL10039 silicon tuner"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S tuner module. Say Y when you want to support this frontend.
 
 config DVB_S5H1420
 	tristate "Samsung S5H1420 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S tuner module. Say Y when you want to support this frontend.
 
 config DVB_STV0288
 	tristate "ST STV0288 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S tuner module. Say Y when you want to support this frontend.
 
 config DVB_STB6000
 	tristate "ST STB6000 silicon tuner"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	  help
 	  A DVB-S silicon tuner module. Say Y when you want to support this tuner.
 
 config DVB_STV0299
 	tristate "ST STV0299 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S tuner module. Say Y when you want to support this frontend.
 
 config DVB_STV6110
 	tristate "ST STV6110 silicon tuner"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	  help
 	  A DVB-S silicon tuner module. Say Y when you want to support this tuner.
 
 config DVB_STV0900
 	tristate "ST STV0900 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S/S2 demodulator. Say Y when you want to support this frontend.
 
 config DVB_TDA8083
 	tristate "Philips TDA8083 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S tuner module. Say Y when you want to support this frontend.
 
 config DVB_TDA10086
 	tristate "Philips TDA10086 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S tuner module. Say Y when you want to support this frontend.
 
 config DVB_TDA8261
 	tristate "Philips TDA8261 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S tuner module. Say Y when you want to support this frontend.
 
 config DVB_VES1X93
 	tristate "VLSI VES1893 or VES1993 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S tuner module. Say Y when you want to support this frontend.
 
 config DVB_TUNER_ITD1000
 	tristate "Integrant ITD1000 Zero IF tuner for DVB-S/DSS"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S tuner module. Say Y when you want to support this frontend.
 
 config DVB_TUNER_CX24113
 	tristate "Conexant CX24113/CX24128 tuner for DVB-S/DSS"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S tuner module. Say Y when you want to support this frontend.
 
@@ -197,42 +182,42 @@ config DVB_TUNER_CX24113
 config DVB_TDA826X
 	tristate "Philips TDA826X silicon tuner"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S silicon tuner module. Say Y when you want to support this tuner.
 
 config DVB_TUA6100
 	tristate "Infineon TUA6100 PLL"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S PLL chip.
 
 config DVB_CX24116
 	tristate "Conexant CX24116 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S/S2 tuner module. Say Y when you want to support this frontend.
 
 config DVB_SI21XX
 	tristate "Silicon Labs SI21XX based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S tuner module. Say Y when you want to support this frontend.
 
 config DVB_DS3000
 	tristate "Montage Tehnology DS3000 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S/S2 tuner module. Say Y when you want to support this frontend.
 
 config DVB_MB86A16
 	tristate "Fujitsu MB86A16 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S/DSS Direct Conversion reveiver.
 	  Say Y when you want to support this frontend.
@@ -240,7 +225,7 @@ config DVB_MB86A16
 config DVB_TDA10071
 	tristate "NXP TDA10071"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y when you want to support this frontend.
 
@@ -250,7 +235,7 @@ comment "DVB-T (terrestrial) frontends"
 config DVB_SP8870
 	tristate "Spase sp8870 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-T tuner module. Say Y when you want to support this frontend.
 
@@ -262,7 +247,7 @@ config DVB_SP8870
 config DVB_SP887X
 	tristate "Spase sp887x based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-T tuner module. Say Y when you want to support this frontend.
 
@@ -274,28 +259,28 @@ config DVB_SP887X
 config DVB_CX22700
 	tristate "Conexant CX22700 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-T tuner module. Say Y when you want to support this frontend.
 
 config DVB_CX22702
 	tristate "Conexant cx22702 demodulator (OFDM)"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-T tuner module. Say Y when you want to support this frontend.
 
 config DVB_S5H1432
 	tristate "Samsung s5h1432 demodulator (OFDM)"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-T tuner module. Say Y when you want to support this frontend.
 
 config DVB_DRXD
 	tristate "Micronas DRXD driver"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-T tuner module. Say Y when you want to support this frontend.
 
@@ -306,14 +291,14 @@ config DVB_DRXD
 config DVB_L64781
 	tristate "LSI L64781"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-T tuner module. Say Y when you want to support this frontend.
 
 config DVB_TDA1004X
 	tristate "Philips TDA10045H/TDA10046H based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-T tuner module. Say Y when you want to support this frontend.
 
@@ -326,28 +311,28 @@ config DVB_TDA1004X
 config DVB_NXT6000
 	tristate "NxtWave Communications NXT6000 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-T tuner module. Say Y when you want to support this frontend.
 
 config DVB_MT352
 	tristate "Zarlink MT352 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-T tuner module. Say Y when you want to support this frontend.
 
 config DVB_ZL10353
 	tristate "Zarlink ZL10353 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-T tuner module. Say Y when you want to support this frontend.
 
 config DVB_DIB3000MB
 	tristate "DiBcom 3000M-B"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-T tuner module. Designed for mobile usage. Say Y when you want
 	  to support this frontend.
@@ -355,7 +340,7 @@ config DVB_DIB3000MB
 config DVB_DIB3000MC
 	tristate "DiBcom 3000P/M-C"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-T tuner module. Designed for mobile usage. Say Y when you want
 	  to support this frontend.
@@ -363,7 +348,7 @@ config DVB_DIB3000MC
 config DVB_DIB7000M
 	tristate "DiBcom 7000MA/MB/PA/PB/MC"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-T tuner module. Designed for mobile usage. Say Y when you want
 	  to support this frontend.
@@ -371,7 +356,7 @@ config DVB_DIB7000M
 config DVB_DIB7000P
 	tristate "DiBcom 7000PC"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-T tuner module. Designed for mobile usage. Say Y when you want
 	  to support this frontend.
@@ -379,7 +364,7 @@ config DVB_DIB7000P
 config DVB_DIB9000
 	tristate "DiBcom 9000"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-T tuner module. Designed for mobile usage. Say Y when you want
 	  to support this frontend.
@@ -387,56 +372,56 @@ config DVB_DIB9000
 config DVB_TDA10048
 	tristate "Philips TDA10048HN based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-T tuner module. Say Y when you want to support this frontend.
 
 config DVB_AF9013
 	tristate "Afatech AF9013 demodulator"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y when you want to support this frontend.
 
 config DVB_EC100
 	tristate "E3C EC100"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y when you want to support this frontend.
 
 config DVB_HD29L2
 	tristate "HDIC HD29L2"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y when you want to support this frontend.
 
 config DVB_STV0367
 	tristate "ST STV0367 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-T/C tuner module. Say Y when you want to support this frontend.
 
 config DVB_CXD2820R
 	tristate "Sony CXD2820R"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y when you want to support this frontend.
 
 config DVB_RTL2830
 	tristate "Realtek RTL2830 DVB-T"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y when you want to support this frontend.
 
 config DVB_RTL2832
 	tristate "Realtek RTL2832 DVB-T"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y when you want to support this frontend.
 
@@ -446,28 +431,28 @@ comment "DVB-C (cable) frontends"
 config DVB_VES1820
 	tristate "VLSI VES1820 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-C tuner module. Say Y when you want to support this frontend.
 
 config DVB_TDA10021
 	tristate "Philips TDA10021 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-C tuner module. Say Y when you want to support this frontend.
 
 config DVB_TDA10023
 	tristate "Philips TDA10023 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-C tuner module. Say Y when you want to support this frontend.
 
 config DVB_STV0297
 	tristate "ST STV0297 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-C tuner module. Say Y when you want to support this frontend.
 
@@ -477,7 +462,7 @@ comment "ATSC (North American/Korean Terrestrial/Cable DTV) frontends"
 config DVB_NXT200X
 	tristate "NxtWave Communications NXT2002/NXT2004 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  An ATSC 8VSB and QAM64/256 tuner module. Say Y when you want
 	  to support this frontend.
@@ -491,7 +476,7 @@ config DVB_NXT200X
 config DVB_OR51211
 	tristate "Oren OR51211 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  An ATSC 8VSB tuner module. Say Y when you want to support this frontend.
 
@@ -503,7 +488,7 @@ config DVB_OR51211
 config DVB_OR51132
 	tristate "Oren OR51132 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  An ATSC 8VSB and QAM64/256 tuner module. Say Y when you want
 	  to support this frontend.
@@ -518,7 +503,7 @@ config DVB_OR51132
 config DVB_BCM3510
 	tristate "Broadcom BCM3510"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  An ATSC 8VSB/16VSB and QAM64/256 tuner module. Say Y when you want to
 	  support this frontend.
@@ -526,7 +511,7 @@ config DVB_BCM3510
 config DVB_LGDT330X
 	tristate "LG Electronics LGDT3302/LGDT3303 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  An ATSC 8VSB and QAM64/256 tuner module. Say Y when you want
 	  to support this frontend.
@@ -534,7 +519,7 @@ config DVB_LGDT330X
 config DVB_LGDT3305
 	tristate "LG Electronics LGDT3304 and LGDT3305 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  An ATSC 8VSB and QAM64/256 tuner module. Say Y when you want
 	  to support this frontend.
@@ -542,7 +527,7 @@ config DVB_LGDT3305
 config DVB_LG2160
 	tristate "LG Electronics LG216x based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  An ATSC/MH demodulator module. Say Y when you want
 	  to support this frontend.
@@ -550,7 +535,7 @@ config DVB_LG2160
 config DVB_S5H1409
 	tristate "Samsung S5H1409 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  An ATSC 8VSB and QAM64/256 tuner module. Say Y when you want
 	  to support this frontend.
@@ -563,7 +548,7 @@ config DVB_AU8522_DTV
 	tristate "Auvitek AU8522 based DTV demod"
 	depends on DVB_CORE && I2C
 	select DVB_AU8522
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  An ATSC 8VSB, QAM64/256 & NTSC demodulator module. Say Y when
 	  you want to enable DTV demodulation support for this frontend.
@@ -572,7 +557,7 @@ config DVB_AU8522_V4L
 	tristate "Auvitek AU8522 based ATV demod"
 	depends on VIDEO_V4L2 && I2C
 	select DVB_AU8522
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  An ATSC 8VSB, QAM64/256 & NTSC demodulator module. Say Y when
 	  you want to enable ATV demodulation support for this frontend.
@@ -580,7 +565,7 @@ config DVB_AU8522_V4L
 config DVB_S5H1411
 	tristate "Samsung S5H1411 based"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  An ATSC 8VSB and QAM64/256 tuner module. Say Y when you want
 	  to support this frontend.
@@ -591,7 +576,7 @@ comment "ISDB-T (terrestrial) frontends"
 config DVB_S921
 	tristate "Sharp S921 frontend"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  AN ISDB-T DQPSK, QPSK, 16QAM and 64QAM 1seg tuner module.
 	  Say Y when you want to support this frontend.
@@ -599,7 +584,7 @@ config DVB_S921
 config DVB_DIB8000
 	tristate "DiBcom 8000MB/MC"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A driver for DiBcom's DiB8000 ISDB-T/ISDB-Tsb demodulator.
 	  Say Y when you want to support this frontend.
@@ -607,7 +592,7 @@ config DVB_DIB8000
 config DVB_MB86A20S
 	tristate "Fujitsu mb86a20s"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A driver for Fujitsu mb86a20s ISDB-T/ISDB-Tsb demodulator.
 	  Say Y when you want to support this frontend.
@@ -618,7 +603,7 @@ comment "Digital terrestrial only tuners/PLL"
 config DVB_PLL
 	tristate "Generic I2C PLL based tuners"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  This module drives a number of tuners based on PLL chips with a
 	  common I2C interface. Say Y when you want to support these tuners.
@@ -626,7 +611,7 @@ config DVB_PLL
 config DVB_TUNER_DIB0070
 	tristate "DiBcom DiB0070 silicon base-band tuner"
 	depends on I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A driver for the silicon baseband tuner DiB0070 from DiBcom.
 	  This device is only used inside a SiP called together with a
@@ -635,7 +620,7 @@ config DVB_TUNER_DIB0070
 config DVB_TUNER_DIB0090
 	tristate "DiBcom DiB0090 silicon base-band tuner"
 	depends on I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A driver for the silicon baseband tuner DiB0090 from DiBcom.
 	  This device is only used inside a SiP called together with a
@@ -647,14 +632,14 @@ comment "SEC control devices for DVB-S"
 config DVB_LNBP21
 	tristate "LNBP21/LNBH24 SEC controllers"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  An SEC control chips.
 
 config DVB_LNBP22
 	tristate "LNBP22 SEC controllers"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  LNB power supply and control voltage
 	  regulator chip with step-up converter
@@ -664,33 +649,33 @@ config DVB_LNBP22
 config DVB_ISL6405
 	tristate "ISL6405 SEC controller"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  An SEC control chip.
 
 config DVB_ISL6421
 	tristate "ISL6421 SEC controller"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  An SEC control chip.
 
 config DVB_ISL6423
 	tristate "ISL6423 SEC controller"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A SEC controller chip from Intersil
 
 config DVB_A8293
 	tristate "Allegro A8293"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 
 config DVB_LGS8GL5
 	tristate "Silicon Legend LGS-8GL5 demodulator (OFDM)"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DMB-TH tuner module. Say Y when you want to support this frontend.
 
@@ -698,21 +683,21 @@ config DVB_LGS8GXX
 	tristate "Legend Silicon LGS8913/LGS8GL5/LGS8GXX DMB-TH demodulator"
 	depends on DVB_CORE && I2C
 	select FW_LOADER
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DMB-TH tuner module. Say Y when you want to support this frontend.
 
 config DVB_ATBM8830
 	tristate "AltoBeam ATBM8830/8831 DMB-TH demodulator"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DMB-TH tuner module. Say Y when you want to support this frontend.
 
 config DVB_TDA665x
 	tristate "TDA665x tuner"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for tuner modules based on Philips TDA6650/TDA6651 chips.
 	  Say Y when you want to support this chip.
@@ -723,14 +708,14 @@ config DVB_TDA665x
 config DVB_IX2505V
 	tristate "Sharp IX2505V silicon tuner"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S tuner module. Say Y when you want to support this frontend.
 
 config DVB_IT913X_FE
 	tristate "it913x frontend and it9137 tuner"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-T tuner module.
 	  Say Y when you want to support this frontend.
@@ -738,7 +723,7 @@ config DVB_IT913X_FE
 config DVB_M88RS2000
 	tristate "M88RS2000 DVB-S demodulator and tuner"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S tuner module.
 	  Say Y when you want to support this frontend.
@@ -746,7 +731,7 @@ config DVB_M88RS2000
 config DVB_AF9033
 	tristate "Afatech AF9033 DVB-T demodulator"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 
 comment "Tools to develop new frontends"
 
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index ad2c9de..fd88c40 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -16,21 +16,8 @@ config VIDEO_TVEEPROM
 
 if VIDEO_V4L2
 
-config VIDEO_HELPER_CHIPS_AUTO
-	bool "Autoselect pertinent encoders/decoders and other helper chips"
-	default y if !EXPERT
-	---help---
-	  Most video cards may require additional modules to encode or
-	  decode audio/video standards. This option will autoselect
-	  all pertinent modules to each selected video module.
-
-	  Unselect this only if you know exactly what you are doing, since
-	  it may break support on some boards.
-
-	  In doubt, say Y.
-
 config VIDEO_IR_I2C
-	tristate "I2C module for IR" if !VIDEO_HELPER_CHIPS_AUTO
+	tristate "I2C module for IR" if !MEDIA_SUBDRV_AUTOSELECT
 	depends on I2C && RC_CORE
 	default y
 	---help---
@@ -47,7 +34,7 @@ config VIDEO_IR_I2C
 #
 
 menu "Encoders, decoders, sensors and other helper chips"
-	visible if !VIDEO_HELPER_CHIPS_AUTO
+	visible if !MEDIA_SUBDRV_AUTOSELECT
 
 comment "Audio decoders, processors and mixers"
 
@@ -561,10 +548,14 @@ config VIDEO_M52790
 
 	 To compile this driver as a module, choose M here: the
 	 module will be called m52790.
+endmenu
+	 
+menu "Sensors used on soc_camera driver"
 
 if SOC_CAMERA
 	source "drivers/media/i2c/soc_camera/Kconfig"
 endif
 
 endmenu
+
 endif
diff --git a/drivers/media/pci/bt8xx/Kconfig b/drivers/media/pci/bt8xx/Kconfig
index f2667a5..61d09e0 100644
--- a/drivers/media/pci/bt8xx/Kconfig
+++ b/drivers/media/pci/bt8xx/Kconfig
@@ -7,10 +7,10 @@ config VIDEO_BT848
 	depends on RC_CORE
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
-	select VIDEO_MSP3400 if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_TVAUDIO if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_TDA7432 if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_SAA6588 if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_MSP3400 if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_TVAUDIO if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_TDA7432 if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_SAA6588 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  Support for BT848 based frame grabber/overlay boards. This includes
 	  the Miro, Hauppauge and STB boards. Please read the material in
@@ -22,14 +22,14 @@ config VIDEO_BT848
 config DVB_BT8XX
 	tristate "DVB/ATSC Support for bt878 based TV cards"
 	depends on DVB_CORE && PCI && I2C && VIDEO_BT848
-	select DVB_MT352 if !DVB_FE_CUSTOMISE
-	select DVB_SP887X if !DVB_FE_CUSTOMISE
-	select DVB_NXT6000 if !DVB_FE_CUSTOMISE
-	select DVB_CX24110 if !DVB_FE_CUSTOMISE
-	select DVB_OR51211 if !DVB_FE_CUSTOMISE
-	select DVB_LGDT330X if !DVB_FE_CUSTOMISE
-	select DVB_ZL10353 if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMISE
+	select DVB_MT352 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_SP887X if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_NXT6000 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_CX24110 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_OR51211 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LGDT330X if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_ZL10353 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_SIMPLE if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for PCI cards based on the Bt8xx PCI bridge. Examples are
 	  the Nebula cards, the Pinnacle PCTV cards, the Twinhan DST cards,
diff --git a/drivers/media/pci/cx18/Kconfig b/drivers/media/pci/cx18/Kconfig
index 53b3c77..9a9f765 100644
--- a/drivers/media/pci/cx18/Kconfig
+++ b/drivers/media/pci/cx18/Kconfig
@@ -8,11 +8,11 @@ config VIDEO_CX18
 	select VIDEO_TVEEPROM
 	select VIDEO_CX2341X
 	select VIDEO_CS5345
-	select DVB_S5H1409 if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_MXL5005S if !MEDIA_TUNER_CUSTOMISE
-	select DVB_S5H1411 if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_TDA18271 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_TDA8290 if !MEDIA_TUNER_CUSTOMISE
+	select DVB_S5H1409 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MXL5005S if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_S5H1411 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA8290 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  This is a video4linux driver for Conexant cx23418 based
 	  PCI combo video recorder devices.
diff --git a/drivers/media/pci/cx23885/Kconfig b/drivers/media/pci/cx23885/Kconfig
index b391e9b..9c6afe9 100644
--- a/drivers/media/pci/cx23885/Kconfig
+++ b/drivers/media/pci/cx23885/Kconfig
@@ -11,23 +11,23 @@ config VIDEO_CX23885
 	select VIDEOBUF_DMA_SG
 	select VIDEO_CX25840
 	select VIDEO_CX2341X
-	select DVB_DIB7000P if !DVB_FE_CUSTOMISE
-	select DVB_S5H1409 if !DVB_FE_CUSTOMISE
-	select DVB_S5H1411 if !DVB_FE_CUSTOMISE
-	select DVB_LGDT330X if !DVB_FE_CUSTOMISE
-	select DVB_ZL10353 if !DVB_FE_CUSTOMISE
-	select DVB_TDA10048 if !DVB_FE_CUSTOMISE
-	select DVB_LNBP21 if !DVB_FE_CUSTOMISE
-	select DVB_STV6110 if !DVB_FE_CUSTOMISE
-	select DVB_CX24116 if !DVB_FE_CUSTOMISE
-	select DVB_STV0900 if !DVB_FE_CUSTOMISE
-	select DVB_DS3000 if !DVB_FE_CUSTOMISE
-	select DVB_STV0367 if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_MT2131 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_TDA8290 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_TDA18271 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMISE
+	select DVB_DIB7000P if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_S5H1409 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_S5H1411 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LGDT330X if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_ZL10353 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA10048 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LNBP21 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV6110 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_CX24116 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0900 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_DS3000 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0367 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MT2131 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_XC2028 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA8290 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  This is a video4linux driver for Conexant 23885 based
 	  TV cards.
diff --git a/drivers/media/pci/cx88/Kconfig b/drivers/media/pci/cx88/Kconfig
index 3598dc0..d27fccb 100644
--- a/drivers/media/pci/cx88/Kconfig
+++ b/drivers/media/pci/cx88/Kconfig
@@ -6,7 +6,7 @@ config VIDEO_CX88
 	select VIDEOBUF_DMA_SG
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
-	select VIDEO_WM8775 if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_WM8775 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  This is a video4linux driver for Conexant 2388x based
 	  TV cards.
@@ -46,23 +46,23 @@ config VIDEO_CX88_DVB
 	tristate "DVB/ATSC Support for cx2388x based TV cards"
 	depends on VIDEO_CX88 && DVB_CORE
 	select VIDEOBUF_DVB
-	select DVB_PLL if !DVB_FE_CUSTOMISE
-	select DVB_MT352 if !DVB_FE_CUSTOMISE
-	select DVB_ZL10353 if !DVB_FE_CUSTOMISE
-	select DVB_OR51132 if !DVB_FE_CUSTOMISE
-	select DVB_CX22702 if !DVB_FE_CUSTOMISE
-	select DVB_LGDT330X if !DVB_FE_CUSTOMISE
-	select DVB_NXT200X if !DVB_FE_CUSTOMISE
-	select DVB_CX24123 if !DVB_FE_CUSTOMISE
-	select DVB_ISL6421 if !DVB_FE_CUSTOMISE
-	select DVB_S5H1411 if !DVB_FE_CUSTOMISE
-	select DVB_CX24116 if !DVB_FE_CUSTOMISE
-	select DVB_STV0299 if !DVB_FE_CUSTOMISE
-	select DVB_STV0288 if !DVB_FE_CUSTOMISE
-	select DVB_STB6000 if !DVB_FE_CUSTOMISE
-	select DVB_STV0900 if !DVB_FE_CUSTOMISE
-	select DVB_STB6100 if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMISE
+	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_MT352 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_ZL10353 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_OR51132 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_CX22702 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LGDT330X if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_NXT200X if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_CX24123 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_ISL6421 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_S5H1411 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_CX24116 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0299 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0288 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STB6000 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0900 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STB6100 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_SIMPLE if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  This adds support for DVB/ATSC cards based on the
 	  Conexant 2388x chip.
diff --git a/drivers/media/pci/ddbridge/Kconfig b/drivers/media/pci/ddbridge/Kconfig
index d099e1a..44e5dc1 100644
--- a/drivers/media/pci/ddbridge/Kconfig
+++ b/drivers/media/pci/ddbridge/Kconfig
@@ -1,11 +1,11 @@
 config DVB_DDBRIDGE
 	tristate "Digital Devices bridge support"
 	depends on DVB_CORE && PCI && I2C
-	select DVB_LNBP21 if !DVB_FE_CUSTOMISE
-	select DVB_STV6110x if !DVB_FE_CUSTOMISE
-	select DVB_STV090x if !DVB_FE_CUSTOMISE
-	select DVB_DRXK if !DVB_FE_CUSTOMISE
-	select DVB_TDA18271C2DD if !DVB_FE_CUSTOMISE
+	select DVB_LNBP21 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV6110x if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV090x if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_DRXK if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA18271C2DD if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  Support for cards with the Digital Devices PCI express bridge:
 	  - Octopus PCIe Bridge
diff --git a/drivers/media/pci/dm1105/Kconfig b/drivers/media/pci/dm1105/Kconfig
index f3de0a4..013df4e 100644
--- a/drivers/media/pci/dm1105/Kconfig
+++ b/drivers/media/pci/dm1105/Kconfig
@@ -1,13 +1,13 @@
 config DVB_DM1105
 	tristate "SDMC DM1105 based PCI cards"
 	depends on DVB_CORE && PCI && I2C
-	select DVB_PLL if !DVB_FE_CUSTOMISE
-	select DVB_STV0299 if !DVB_FE_CUSTOMISE
-	select DVB_STV0288 if !DVB_FE_CUSTOMISE
-	select DVB_STB6000 if !DVB_FE_CUSTOMISE
-	select DVB_CX24116 if !DVB_FE_CUSTOMISE
-	select DVB_SI21XX if !DVB_FE_CUSTOMISE
-	select DVB_DS3000 if !DVB_FE_CUSTOMISE
+	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0299 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0288 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STB6000 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_CX24116 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_SI21XX if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_DS3000 if MEDIA_SUBDRV_AUTOSELECT
 	depends on RC_CORE
 	help
 	  Support for cards based on the SDMC DM1105 PCI chip like
diff --git a/drivers/media/pci/mantis/Kconfig b/drivers/media/pci/mantis/Kconfig
index a13a505..d3cc216 100644
--- a/drivers/media/pci/mantis/Kconfig
+++ b/drivers/media/pci/mantis/Kconfig
@@ -10,15 +10,15 @@ config MANTIS_CORE
 config DVB_MANTIS
 	tristate "MANTIS based cards"
 	depends on MANTIS_CORE && DVB_CORE && PCI && I2C
-	select DVB_MB86A16 if !DVB_FE_CUSTOMISE
-	select DVB_ZL10353 if !DVB_FE_CUSTOMISE
-	select DVB_STV0299 if !DVB_FE_CUSTOMISE
-	select DVB_LNBP21 if !DVB_FE_CUSTOMISE
-	select DVB_STB0899 if !DVB_FE_CUSTOMISE
-	select DVB_STB6100 if !DVB_FE_CUSTOMISE
-	select DVB_TDA665x if !DVB_FE_CUSTOMISE
-	select DVB_TDA10021 if !DVB_FE_CUSTOMISE
-	select DVB_TDA10023 if !DVB_FE_CUSTOMISE
+	select DVB_MB86A16 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_ZL10353 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0299 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LNBP21 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STB0899 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STB6100 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA665x if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA10021 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA10023 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_PLL
 	help
 	  Support for PCI cards based on the Mantis PCI bridge.
@@ -29,7 +29,7 @@ config DVB_MANTIS
 config DVB_HOPPER
 	tristate "HOPPER based cards"
 	depends on MANTIS_CORE && DVB_CORE && PCI && I2C
-	select DVB_ZL10353 if !DVB_FE_CUSTOMISE
+	select DVB_ZL10353 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_PLL
 	help
 	  Support for PCI cards based on the Hopper  PCI bridge.
diff --git a/drivers/media/pci/ngene/Kconfig b/drivers/media/pci/ngene/Kconfig
index 64c8470..637d506 100644
--- a/drivers/media/pci/ngene/Kconfig
+++ b/drivers/media/pci/ngene/Kconfig
@@ -1,13 +1,13 @@
 config DVB_NGENE
 	tristate "Micronas nGene support"
 	depends on DVB_CORE && PCI && I2C
-	select DVB_LNBP21 if !DVB_FE_CUSTOMISE
-	select DVB_STV6110x if !DVB_FE_CUSTOMISE
-	select DVB_STV090x if !DVB_FE_CUSTOMISE
-	select DVB_LGDT330X if !DVB_FE_CUSTOMISE
-	select DVB_DRXK if !DVB_FE_CUSTOMISE
-	select DVB_TDA18271C2DD if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_MT2131 if !MEDIA_TUNER_CUSTOMISE
+	select DVB_LNBP21 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV6110x if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV090x if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LGDT330X if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_DRXK if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA18271C2DD if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MT2131 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  Support for Micronas PCI express cards with nGene bridge.
 
diff --git a/drivers/media/pci/saa7134/Kconfig b/drivers/media/pci/saa7134/Kconfig
index 39fc018..15b90d6 100644
--- a/drivers/media/pci/saa7134/Kconfig
+++ b/drivers/media/pci/saa7134/Kconfig
@@ -5,7 +5,7 @@ config VIDEO_SAA7134
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select CRC32
-	select VIDEO_SAA6588 if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_SAA6588 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  This is a video4linux driver for Philips SAA713x based
 	  TV cards.
@@ -37,25 +37,25 @@ config VIDEO_SAA7134_DVB
 	tristate "DVB/ATSC Support for saa7134 based TV cards"
 	depends on VIDEO_SAA7134 && DVB_CORE
 	select VIDEOBUF_DVB
-	select DVB_PLL if !DVB_FE_CUSTOMISE
-	select DVB_MT352 if !DVB_FE_CUSTOMISE
-	select DVB_TDA1004X if !DVB_FE_CUSTOMISE
-	select DVB_NXT200X if !DVB_FE_CUSTOMISE
-	select DVB_TDA10086 if !DVB_FE_CUSTOMISE
-	select DVB_TDA826X if !DVB_FE_CUSTOMISE
-	select DVB_ISL6421 if !DVB_FE_CUSTOMISE
-	select DVB_ISL6405 if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_TDA827X if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMISE
-	select DVB_ZL10036 if !DVB_FE_CUSTOMISE
-	select DVB_MT312 if !DVB_FE_CUSTOMISE
-	select DVB_LNBP21 if !DVB_FE_CUSTOMISE
-	select DVB_ZL10353 if !DVB_FE_CUSTOMISE
-	select DVB_LGDT3305 if !DVB_FE_CUSTOMISE
-	select DVB_TDA10048 if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_TDA18271 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_TDA8290 if !MEDIA_TUNER_CUSTOMISE
-	select DVB_ZL10039 if !DVB_FE_CUSTOMISE
+	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_MT352 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA1004X if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_NXT200X if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA10086 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA826X if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_ISL6421 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_ISL6405 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA827X if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_SIMPLE if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_ZL10036 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_MT312 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LNBP21 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_ZL10353 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LGDT3305 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA10048 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA8290 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_ZL10039 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  This adds support for DVB cards based on the
 	  Philips saa7134 chip.
diff --git a/drivers/media/pci/saa7146/Kconfig b/drivers/media/pci/saa7146/Kconfig
index 8923b76..da88b77 100644
--- a/drivers/media/pci/saa7146/Kconfig
+++ b/drivers/media/pci/saa7146/Kconfig
@@ -26,10 +26,10 @@ config VIDEO_MXB
 	depends on PCI && VIDEO_V4L2 && I2C
 	select VIDEO_SAA7146_VV
 	select VIDEO_TUNER
-	select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_TDA9840 if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_TEA6415C if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_TEA6420 if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_SAA711X if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_TDA9840 if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_TEA6415C if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_TEA6420 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  This is a video4linux driver for the 'Multimedia eXtension Board'
 	  TV card by Siemens-Nixdorf.
diff --git a/drivers/media/pci/saa7164/Kconfig b/drivers/media/pci/saa7164/Kconfig
index 3532637..8463796 100644
--- a/drivers/media/pci/saa7164/Kconfig
+++ b/drivers/media/pci/saa7164/Kconfig
@@ -6,9 +6,9 @@ config VIDEO_SAA7164
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEOBUF_DVB
-	select DVB_TDA10048 if !DVB_FE_CUSTOMISE
-	select DVB_S5H1411 if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_TDA18271 if !MEDIA_TUNER_CUSTOMISE
+	select DVB_TDA10048 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_S5H1411 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  This is a video4linux driver for NXP SAA7164 based
 	  TV cards.
diff --git a/drivers/media/pci/sta2x11/Kconfig b/drivers/media/pci/sta2x11/Kconfig
index 04a82cb..6749f67 100644
--- a/drivers/media/pci/sta2x11/Kconfig
+++ b/drivers/media/pci/sta2x11/Kconfig
@@ -1,7 +1,7 @@
 config STA2X11_VIP
 	tristate "STA2X11 VIP Video For Linux"
 	depends on STA2X11
-	select VIDEO_ADV7180 if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_ADV7180 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEOBUF_DMA_CONTIG
 	depends on PCI && VIDEO_V4L2 && VIRT_TO_BUS
 	help
diff --git a/drivers/media/pci/ttpci/Kconfig b/drivers/media/pci/ttpci/Kconfig
index 9d83ced..314e417 100644
--- a/drivers/media/pci/ttpci/Kconfig
+++ b/drivers/media/pci/ttpci/Kconfig
@@ -9,14 +9,14 @@ config DVB_AV7110
 	select TTPCI_EEPROM
 	select VIDEO_SAA7146_VV
 	depends on VIDEO_DEV	# dependencies of VIDEO_SAA7146_VV
-	select DVB_VES1820 if !DVB_FE_CUSTOMISE
-	select DVB_VES1X93 if !DVB_FE_CUSTOMISE
-	select DVB_STV0299 if !DVB_FE_CUSTOMISE
-	select DVB_TDA8083 if !DVB_FE_CUSTOMISE
-	select DVB_SP8870 if !DVB_FE_CUSTOMISE
-	select DVB_STV0297 if !DVB_FE_CUSTOMISE
-	select DVB_L64781 if !DVB_FE_CUSTOMISE
-	select DVB_LNBP21 if !DVB_FE_CUSTOMISE
+	select DVB_VES1820 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_VES1X93 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0299 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA8083 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_SP8870 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0297 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_L64781 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LNBP21 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for SAA7146 and AV7110 based DVB cards as produced
 	  by Fujitsu-Siemens, Technotrend, Hauppauge and others.
@@ -63,19 +63,19 @@ config DVB_BUDGET_CORE
 config DVB_BUDGET
 	tristate "Budget cards"
 	depends on DVB_BUDGET_CORE && I2C
-	select DVB_STV0299 if !DVB_FE_CUSTOMISE
-	select DVB_VES1X93 if !DVB_FE_CUSTOMISE
-	select DVB_VES1820 if !DVB_FE_CUSTOMISE
-	select DVB_L64781 if !DVB_FE_CUSTOMISE
-	select DVB_TDA8083 if !DVB_FE_CUSTOMISE
-	select DVB_S5H1420 if !DVB_FE_CUSTOMISE
-	select DVB_TDA10086 if !DVB_FE_CUSTOMISE
-	select DVB_TDA826X if !DVB_FE_CUSTOMISE
-	select DVB_LNBP21 if !DVB_FE_CUSTOMISE
-	select DVB_TDA1004X if !DVB_FE_CUSTOMISE
-	select DVB_ISL6423 if !DVB_FE_CUSTOMISE
-	select DVB_STV090x if !DVB_FE_CUSTOMISE
-	select DVB_STV6110x if !DVB_FE_CUSTOMISE
+	select DVB_STV0299 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_VES1X93 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_VES1820 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_L64781 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA8083 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_S5H1420 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA10086 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA826X if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LNBP21 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA1004X if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_ISL6423 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV090x if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV6110x if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for simple SAA7146 based DVB cards (so called Budget-
 	  or Nova-PCI cards) without onboard MPEG2 decoder, and without
@@ -89,16 +89,16 @@ config DVB_BUDGET
 config DVB_BUDGET_CI
 	tristate "Budget cards with onboard CI connector"
 	depends on DVB_BUDGET_CORE && I2C
-	select DVB_STV0297 if !DVB_FE_CUSTOMISE
-	select DVB_STV0299 if !DVB_FE_CUSTOMISE
-	select DVB_TDA1004X if !DVB_FE_CUSTOMISE
-	select DVB_STB0899 if !DVB_FE_CUSTOMISE
-	select DVB_STB6100 if !DVB_FE_CUSTOMISE
-	select DVB_LNBP21 if !DVB_FE_CUSTOMISE
-	select DVB_STV0288 if !DVB_FE_CUSTOMISE
-	select DVB_STB6000 if !DVB_FE_CUSTOMISE
-	select DVB_TDA10023 if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_TDA827X if !MEDIA_TUNER_CUSTOMISE
+	select DVB_STV0297 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0299 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA1004X if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STB0899 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STB6100 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LNBP21 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0288 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STB6000 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA10023 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA827X if MEDIA_SUBDRV_AUTOSELECT
 	depends on RC_CORE
 	help
 	  Support for simple SAA7146 based DVB cards
@@ -118,14 +118,14 @@ config DVB_BUDGET_AV
 	depends on DVB_BUDGET_CORE && I2C
 	select VIDEO_SAA7146_VV
 	depends on VIDEO_DEV	# dependencies of VIDEO_SAA7146_VV
-	select DVB_PLL if !DVB_FE_CUSTOMISE
-	select DVB_STV0299 if !DVB_FE_CUSTOMISE
-	select DVB_TDA1004X if !DVB_FE_CUSTOMISE
-	select DVB_TDA10021 if !DVB_FE_CUSTOMISE
-	select DVB_TDA10023 if !DVB_FE_CUSTOMISE
-	select DVB_STB0899 if !DVB_FE_CUSTOMISE
-	select DVB_TDA8261 if !DVB_FE_CUSTOMISE
-	select DVB_TUA6100 if !DVB_FE_CUSTOMISE
+	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0299 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA1004X if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA10021 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA10023 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STB0899 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA8261 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TUA6100 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for simple SAA7146 based DVB cards
 	  (so called Budget- or Nova-PCI cards) without onboard
@@ -140,9 +140,9 @@ config DVB_BUDGET_PATCH
 	tristate "AV7110 cards with Budget Patch"
 	depends on DVB_BUDGET_CORE && I2C
 	depends on DVB_AV7110
-	select DVB_STV0299 if !DVB_FE_CUSTOMISE
-	select DVB_VES1X93 if !DVB_FE_CUSTOMISE
-	select DVB_TDA8083 if !DVB_FE_CUSTOMISE
+	select DVB_STV0299 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_VES1X93 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA8083 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for Budget Patch (full TS) modification on
 	  SAA7146+AV7110 based cards (DVB-S cards). This
diff --git a/drivers/media/pci/zoran/Kconfig b/drivers/media/pci/zoran/Kconfig
index fd4120e..a9b2318 100644
--- a/drivers/media/pci/zoran/Kconfig
+++ b/drivers/media/pci/zoran/Kconfig
@@ -14,8 +14,8 @@ config VIDEO_ZORAN
 config VIDEO_ZORAN_DC30
 	tristate "Pinnacle/Miro DC30(+) support"
 	depends on VIDEO_ZORAN
-	select VIDEO_ADV7175 if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_VPX3220 if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_ADV7175 if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_VPX3220 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for the Pinnacle/Miro DC30(+) MJPEG capture/playback
 	  card. This also supports really old DC10 cards based on the
@@ -32,16 +32,16 @@ config VIDEO_ZORAN_ZR36060
 config VIDEO_ZORAN_BUZ
 	tristate "Iomega Buz support"
 	depends on VIDEO_ZORAN_ZR36060
-	select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_SAA7185 if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_SAA711X if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_SAA7185 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for the Iomega Buz MJPEG capture/playback card.
 
 config VIDEO_ZORAN_DC10
 	tristate "Pinnacle/Miro DC10(+) support"
 	depends on VIDEO_ZORAN_ZR36060
-	select VIDEO_SAA7110 if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_ADV7175 if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_SAA7110 if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_ADV7175 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for the Pinnacle/Miro DC10(+) MJPEG capture/playback
 	  card.
@@ -49,8 +49,8 @@ config VIDEO_ZORAN_DC10
 config VIDEO_ZORAN_LML33
 	tristate "Linux Media Labs LML33 support"
 	depends on VIDEO_ZORAN_ZR36060
-	select VIDEO_BT819 if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_BT856 if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_BT819 if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_BT856 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for the Linux Media Labs LML33 MJPEG capture/playback
 	  card.
@@ -58,8 +58,8 @@ config VIDEO_ZORAN_LML33
 config VIDEO_ZORAN_LML33R10
 	tristate "Linux Media Labs LML33R10 support"
 	depends on VIDEO_ZORAN_ZR36060
-	select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_ADV7170 if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_SAA711X if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_ADV7170 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  support for the Linux Media Labs LML33R10 MJPEG capture/playback
 	  card.
@@ -67,8 +67,8 @@ config VIDEO_ZORAN_LML33R10
 config VIDEO_ZORAN_AVS6EYES
 	tristate "AverMedia 6 Eyes support (EXPERIMENTAL)"
 	depends on VIDEO_ZORAN_ZR36060 && EXPERIMENTAL
-	select VIDEO_BT856 if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_BT866 if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_KS0127 if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_BT856 if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_BT866 if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_KS0127 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for the AverMedia 6 Eyes video surveillance card.
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 03ae4e3..a398703 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -66,7 +66,7 @@ config VIDEO_TIMBERDALE
 config VIDEO_VINO
 	tristate "SGI Vino Video For Linux"
 	depends on I2C && SGI_IP22 && VIDEO_V4L2
-	select VIDEO_SAA7191 if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_SAA7191 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to build in support for the Vino video input system found
 	  on SGI Indy machines.
diff --git a/drivers/media/platform/davinci/Kconfig b/drivers/media/platform/davinci/Kconfig
index 52c5ca6..78e26d2 100644
--- a/drivers/media/platform/davinci/Kconfig
+++ b/drivers/media/platform/davinci/Kconfig
@@ -3,8 +3,8 @@ config VIDEO_DAVINCI_VPIF_DISPLAY
 	depends on VIDEO_DEV && (MACH_DAVINCI_DM6467_EVM || MACH_DAVINCI_DA850_EVM)
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEO_DAVINCI_VPIF
-	select VIDEO_ADV7343 if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_THS7303 if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_ADV7343 if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_THS7303 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Enables Davinci VPIF module used for display devices.
 	  This module is common for following DM6467/DA850/OMAPL138
diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index 94c6ff7..80238b9 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -18,43 +18,31 @@ config MEDIA_ATTACH
 
 	  If unsure say Y.
 
+# Analog TV tuners, auto-loaded via tuner.ko
 config MEDIA_TUNER
 	tristate
 	depends on (MEDIA_ANALOG_TV_SUPPORT || MEDIA_RADIO_SUPPORT) && I2C
 	default y
-	select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_XC4000 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_MT20XX if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_TDA8290 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_TEA5761 if !MEDIA_TUNER_CUSTOMISE && MEDIA_RADIO_SUPPORT && EXPERIMENTAL
-	select MEDIA_TUNER_TEA5767 if !MEDIA_TUNER_CUSTOMISE && MEDIA_RADIO_SUPPORT
-	select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_TDA9887 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_MC44S803 if !MEDIA_TUNER_CUSTOMISE
-
-config MEDIA_TUNER_CUSTOMISE
-	bool "Customize analog and hybrid tuner modules to build"
-	depends on MEDIA_TUNER
-	default y if EXPERT
-	help
-	  This allows the user to deselect tuner drivers unnecessary
-	  for their hardware from the build. Use this option with care
-	  as deselecting tuner drivers which are in fact necessary will
-	  result in V4L/DVB devices which cannot be tuned due to lack of
-	  driver support
-
-	  If unsure say N.
+	select MEDIA_TUNER_XC2028 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_XC4000 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MT20XX if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA8290 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TEA5761 if MEDIA_SUBDRV_AUTOSELECT && MEDIA_RADIO_SUPPORT && EXPERIMENTAL
+	select MEDIA_TUNER_TEA5767 if MEDIA_SUBDRV_AUTOSELECT && MEDIA_RADIO_SUPPORT
+	select MEDIA_TUNER_SIMPLE if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA9887 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MC44S803 if MEDIA_SUBDRV_AUTOSELECT
 
 menu "Customize TV tuners"
-	visible if MEDIA_TUNER_CUSTOMISE
+	visible if !MEDIA_SUBDRV_AUTOSELECT
 	depends on MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_RADIO_SUPPORT
 
 config MEDIA_TUNER_SIMPLE
 	tristate "Simple tuner support"
 	depends on MEDIA_SUPPORT && I2C
 	select MEDIA_TUNER_TDA9887
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to include support for various simple tuners.
 
@@ -63,28 +51,28 @@ config MEDIA_TUNER_TDA8290
 	depends on MEDIA_SUPPORT && I2C
 	select MEDIA_TUNER_TDA827X
 	select MEDIA_TUNER_TDA18271
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to include support for Philips TDA8290+8275(a) tuner.
 
 config MEDIA_TUNER_TDA827X
 	tristate "Philips TDA827X silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-T silicon tuner module. Say Y when you want to support this tuner.
 
 config MEDIA_TUNER_TDA18271
 	tristate "NXP TDA18271 silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A silicon tuner module. Say Y when you want to support this tuner.
 
 config MEDIA_TUNER_TDA9887
 	tristate "TDA 9885/6/7 analog IF demodulator"
 	depends on MEDIA_SUPPORT && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to include support for Philips TDA9885/6/7
 	  analog IF demodulator.
@@ -93,70 +81,70 @@ config MEDIA_TUNER_TEA5761
 	tristate "TEA 5761 radio tuner (EXPERIMENTAL)"
 	depends on MEDIA_SUPPORT && I2C
 	depends on EXPERIMENTAL
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to include support for the Philips TEA5761 radio tuner.
 
 config MEDIA_TUNER_TEA5767
 	tristate "TEA 5767 radio tuner"
 	depends on MEDIA_SUPPORT && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to include support for the Philips TEA5767 radio tuner.
 
 config MEDIA_TUNER_MT20XX
 	tristate "Microtune 2032 / 2050 tuners"
 	depends on MEDIA_SUPPORT && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to include support for the MT2032 / MT2050 tuner.
 
 config MEDIA_TUNER_MT2060
 	tristate "Microtune MT2060 silicon IF tuner"
 	depends on MEDIA_SUPPORT && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A driver for the silicon IF tuner MT2060 from Microtune.
 
 config MEDIA_TUNER_MT2063
 	tristate "Microtune MT2063 silicon IF tuner"
 	depends on MEDIA_SUPPORT && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A driver for the silicon IF tuner MT2063 from Microtune.
 
 config MEDIA_TUNER_MT2266
 	tristate "Microtune MT2266 silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A driver for the silicon baseband tuner MT2266 from Microtune.
 
 config MEDIA_TUNER_MT2131
 	tristate "Microtune MT2131 silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A driver for the silicon baseband tuner MT2131 from Microtune.
 
 config MEDIA_TUNER_QT1010
 	tristate "Quantek QT1010 silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A driver for the silicon tuner QT1010 from Quantek.
 
 config MEDIA_TUNER_XC2028
 	tristate "XCeive xc2028/xc3028 tuners"
 	depends on MEDIA_SUPPORT && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to include support for the xc2028/xc3028 tuners.
 
 config MEDIA_TUNER_XC5000
 	tristate "Xceive XC5000 silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A driver for the silicon tuner XC5000 from Xceive.
 	  This device is only used inside a SiP called together with a
@@ -165,7 +153,7 @@ config MEDIA_TUNER_XC5000
 config MEDIA_TUNER_XC4000
 	tristate "Xceive XC4000 silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A driver for the silicon tuner XC4000 from Xceive.
 	  This device is only used inside a SiP called together with a
@@ -174,70 +162,70 @@ config MEDIA_TUNER_XC4000
 config MEDIA_TUNER_MXL5005S
 	tristate "MaxLinear MSL5005S silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A driver for the silicon tuner MXL5005S from MaxLinear.
 
 config MEDIA_TUNER_MXL5007T
 	tristate "MaxLinear MxL5007T silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A driver for the silicon tuner MxL5007T from MaxLinear.
 
 config MEDIA_TUNER_MC44S803
 	tristate "Freescale MC44S803 Low Power CMOS Broadband tuners"
 	depends on MEDIA_SUPPORT && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the Freescale MC44S803 based tuners
 
 config MEDIA_TUNER_MAX2165
 	tristate "Maxim MAX2165 silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A driver for the silicon tuner MAX2165 from Maxim.
 
 config MEDIA_TUNER_TDA18218
 	tristate "NXP TDA18218 silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  NXP TDA18218 silicon tuner driver.
 
 config MEDIA_TUNER_FC0011
 	tristate "Fitipower FC0011 silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Fitipower FC0011 silicon tuner driver.
 
 config MEDIA_TUNER_FC0012
 	tristate "Fitipower FC0012 silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Fitipower FC0012 silicon tuner driver.
 
 config MEDIA_TUNER_FC0013
 	tristate "Fitipower FC0013 silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Fitipower FC0013 silicon tuner driver.
 
 config MEDIA_TUNER_TDA18212
 	tristate "NXP TDA18212 silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  NXP TDA18212 silicon tuner driver.
 
 config MEDIA_TUNER_TUA9001
 	tristate "Infineon TUA 9001 silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
-	default m if MEDIA_TUNER_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Infineon TUA 9001 silicon tuner driver.
 endmenu
diff --git a/drivers/media/usb/au0828/Kconfig b/drivers/media/usb/au0828/Kconfig
index 23f7fd2..385e557b 100644
--- a/drivers/media/usb/au0828/Kconfig
+++ b/drivers/media/usb/au0828/Kconfig
@@ -6,11 +6,11 @@ config VIDEO_AU0828
 	select I2C_ALGOBIT
 	select VIDEO_TVEEPROM
 	select VIDEOBUF_VMALLOC
-	select DVB_AU8522_DTV if !DVB_FE_CUSTOMISE
-	select DVB_AU8522_V4L if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_MXL5007T if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_TDA18271 if !MEDIA_TUNER_CUSTOMISE
+	select DVB_AU8522_DTV if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_AU8522_V4L if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MXL5007T if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  This is a video4linux driver for Auvitek's USB device.
 
diff --git a/drivers/media/usb/cx231xx/Kconfig b/drivers/media/usb/cx231xx/Kconfig
index 446f692..77913df 100644
--- a/drivers/media/usb/cx231xx/Kconfig
+++ b/drivers/media/usb/cx231xx/Kconfig
@@ -42,9 +42,9 @@ config VIDEO_CX231XX_DVB
 	tristate "DVB/ATSC Support for Cx231xx based TV cards"
 	depends on VIDEO_CX231XX && DVB_CORE && DVB_CAPTURE_DRIVERS
 	select VIDEOBUF_DVB
-	select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_TDA18271 if !MEDIA_TUNER_CUSTOMISE
-	select DVB_MB86A20S if !DVB_FE_CUSTOMISE
+	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_MB86A20S if MEDIA_SUBDRV_AUTOSELECT
 
 	---help---
 	  This adds support for DVB cards based on the
diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index 276374f..9671151 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -21,14 +21,14 @@ config DVB_USB_AF9015
 	tristate "Afatech AF9015 DVB-T USB2.0 support"
 	depends on DVB_USB_V2
 	select DVB_AF9013
-	select DVB_PLL              if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_MT2060   if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_QT1010   if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_TDA18271 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_MXL5005S if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_MC44S803 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_TDA18218 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_MXL5007T if !MEDIA_TUNER_CUSTOMISE
+	select DVB_PLL              if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MT2060   if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_QT1010   if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MXL5005S if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MC44S803 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA18218 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MXL5007T if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the Afatech AF9015 based DVB-T USB2.0 receiver
 
@@ -36,26 +36,26 @@ config DVB_USB_AF9035
 	tristate "Afatech AF9035 DVB-T USB2.0 support"
 	depends on DVB_USB_V2
 	select DVB_AF9033
-	select MEDIA_TUNER_TUA9001 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_FC0011 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_MXL5007T if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_TDA18218 if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_TUA9001 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_FC0011 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MXL5007T if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA18218 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the Afatech AF9035 based DVB USB receiver.
 
 config DVB_USB_ANYSEE
 	tristate "Anysee DVB-T/C USB2.0 support"
 	depends on DVB_USB_V2
-	select DVB_PLL if !DVB_FE_CUSTOMISE
-	select DVB_MT352 if !DVB_FE_CUSTOMISE
-	select DVB_ZL10353 if !DVB_FE_CUSTOMISE
-	select DVB_TDA10023 if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_TDA18212 if !MEDIA_TUNER_CUSTOMISE
-	select DVB_CX24116 if !DVB_FE_CUSTOMISE
-	select DVB_STV0900 if !DVB_FE_CUSTOMISE
-	select DVB_STV6110 if !DVB_FE_CUSTOMISE
-	select DVB_ISL6423 if !DVB_FE_CUSTOMISE
-	select DVB_CXD2820R if !DVB_FE_CUSTOMISE
+	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_MT352 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_ZL10353 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA10023 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA18212 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_CX24116 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0900 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV6110 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_ISL6423 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_CXD2820R if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the Anysee E30, Anysee E30 Plus or
 	  Anysee E30 C Plus DVB USB2.0 receiver.
@@ -63,8 +63,8 @@ config DVB_USB_ANYSEE
 config DVB_USB_AU6610
 	tristate "Alcor Micro AU6610 USB2.0 support"
 	depends on DVB_USB_V2
-	select DVB_ZL10353 if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_QT1010 if !MEDIA_TUNER_CUSTOMISE
+	select DVB_ZL10353 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_QT1010 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the Sigmatek DVB-110 DVB-T USB2.0 receiver.
 
@@ -72,8 +72,8 @@ config DVB_USB_AZ6007
 	tristate "AzureWave 6007 and clones DVB-T/C USB2.0 support"
 	depends on DVB_USB_V2
 	select DVB_USB_CYPRESS_FIRMWARE
-	select DVB_DRXK if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_MT2063 if !DVB_FE_CUSTOMISE
+	select DVB_DRXK if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MT2063 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the AZ6007 receivers like Terratec H7.
 
@@ -81,7 +81,7 @@ config DVB_USB_CE6230
 	tristate "Intel CE6230 DVB-T USB2.0 support"
 	depends on DVB_USB_V2
 	select DVB_ZL10353
-	select MEDIA_TUNER_MXL5005S if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_MXL5005S if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the Intel CE6230 DVB-T USB2.0 receiver
 
@@ -89,15 +89,15 @@ config DVB_USB_EC168
 	tristate "E3C EC168 DVB-T USB2.0 support"
 	depends on DVB_USB_V2
 	select DVB_EC100
-	select MEDIA_TUNER_MXL5005S if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_MXL5005S if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the E3C EC168 DVB-T USB2.0 receiver.
 
 config DVB_USB_GL861
 	tristate "Genesys Logic GL861 USB2.0 support"
 	depends on DVB_USB_V2
-	select DVB_ZL10353 if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_QT1010 if !MEDIA_TUNER_CUSTOMISE
+	select DVB_ZL10353 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_QT1010 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the MSI Megasky 580 (55801) DVB-T USB2.0
 	  receiver with USB ID 0db0:5581.
@@ -112,21 +112,21 @@ config DVB_USB_IT913X
 config DVB_USB_LME2510
 	tristate "LME DM04/QQBOX DVB-S USB2.0 support"
 	depends on DVB_USB_V2
-	select DVB_TDA10086 if !DVB_FE_CUSTOMISE
-	select DVB_TDA826X if !DVB_FE_CUSTOMISE
-	select DVB_STV0288 if !DVB_FE_CUSTOMISE
-	select DVB_IX2505V if !DVB_FE_CUSTOMISE
-	select DVB_STV0299 if !DVB_FE_CUSTOMISE
-	select DVB_PLL if !DVB_FE_CUSTOMISE
-	select DVB_M88RS2000 if !DVB_FE_CUSTOMISE
+	select DVB_TDA10086 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA826X if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0288 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_IX2505V if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0299 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_M88RS2000 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the LME DM04/QQBOX DVB-S USB2.0
 
 config DVB_USB_MXL111SF
 	tristate "MxL111SF DTV USB2.0 support"
 	depends on DVB_USB_V2
-	select DVB_LGDT3305 if !DVB_FE_CUSTOMISE
-	select DVB_LG2160 if !DVB_FE_CUSTOMISE
+	select DVB_LGDT3305 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LG2160 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_TVEEPROM
 	help
 	  Say Y here to support the MxL111SF USB2.0 DTV receiver.
@@ -136,11 +136,11 @@ config DVB_USB_RTL28XXU
 	depends on DVB_USB_V2 && EXPERIMENTAL
 	select DVB_RTL2830
 	select DVB_RTL2832
-	select MEDIA_TUNER_QT1010 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_MT2060 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_MXL5005S if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_FC0012 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_FC0013 if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_QT1010 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MXL5005S if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_FC0012 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_FC0013 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the Realtek RTL28xxU DVB USB receiver.
 
diff --git a/drivers/media/usb/dvb-usb/Kconfig b/drivers/media/usb/dvb-usb/Kconfig
index 00173ee..3c5fff8 100644
--- a/drivers/media/usb/dvb-usb/Kconfig
+++ b/drivers/media/usb/dvb-usb/Kconfig
@@ -24,17 +24,17 @@ config DVB_USB_A800
 	tristate "AVerMedia AverTV DVB-T USB 2.0 (A800)"
 	depends on DVB_USB
 	select DVB_DIB3000MC
-	select DVB_PLL if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_MT2060 if !MEDIA_TUNER_CUSTOMISE
+	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the AVerMedia AverTV DVB-T USB 2.0 (A800) receiver.
 
 config DVB_USB_DIBUSB_MB
 	tristate "DiBcom USB DVB-T devices (based on the DiB3000M-B) (see help for device list)"
 	depends on DVB_USB
-	select DVB_PLL if !DVB_FE_CUSTOMISE
+	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_DIB3000MB
-	select MEDIA_TUNER_MT2060 if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for USB 1.1 and 2.0 DVB-T receivers based on reference designs made by
 	  DiBcom (<http://www.dibcom.fr>) equipped with a DiB3000M-B demodulator.
@@ -55,7 +55,7 @@ config DVB_USB_DIBUSB_MC
 	tristate "DiBcom USB DVB-T devices (based on the DiB3000M-C/P) (see help for device list)"
 	depends on DVB_USB
 	select DVB_DIB3000MC
-	select MEDIA_TUNER_MT2060 if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for USB2.0 DVB-T receivers based on reference designs made by
 	  DiBcom (<http://www.dibcom.fr>) equipped with a DiB3000M-C/P demodulator.
@@ -69,20 +69,20 @@ config DVB_USB_DIBUSB_MC
 config DVB_USB_DIB0700
 	tristate "DiBcom DiB0700 USB DVB devices (see help for supported devices)"
 	depends on DVB_USB
-	select DVB_DIB7000P if !DVB_FE_CUSTOMISE
-	select DVB_DIB7000M if !DVB_FE_CUSTOMISE
-	select DVB_DIB8000 if !DVB_FE_CUSTOMISE
-	select DVB_DIB3000MC if !DVB_FE_CUSTOMISE
-	select DVB_S5H1411 if !DVB_FE_CUSTOMISE
-	select DVB_LGDT3305 if !DVB_FE_CUSTOMISE
-	select DVB_TUNER_DIB0070 if !DVB_FE_CUSTOMISE
-	select DVB_TUNER_DIB0090 if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_MT2060 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_MT2266 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_XC4000 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_MXL5007T if !MEDIA_TUNER_CUSTOMISE
+	select DVB_DIB7000P if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_DIB7000M if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_DIB8000 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_DIB3000MC if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_S5H1411 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LGDT3305 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TUNER_DIB0070 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TUNER_DIB0090 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MT2266 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_XC2028 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_XC4000 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MXL5007T if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for USB2.0/1.1 DVB receivers based on the DiB0700 USB bridge. The
 	  USB bridge is also present in devices having the DiB7700 DVB-T-USB
@@ -98,29 +98,29 @@ config DVB_USB_DIB0700
 config DVB_USB_UMT_010
 	tristate "HanfTek UMT-010 DVB-T USB2.0 support"
 	depends on DVB_USB
-	select DVB_PLL if !DVB_FE_CUSTOMISE
+	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_DIB3000MC
-	select MEDIA_TUNER_MT2060 if !MEDIA_TUNER_CUSTOMISE
-	select DVB_MT352 if !DVB_FE_CUSTOMISE
+	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_MT352 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the HanfTek UMT-010 USB2.0 stick-sized DVB-T receiver.
 
 config DVB_USB_CXUSB
 	tristate "Conexant USB2.0 hybrid reference design support"
 	depends on DVB_USB
-	select DVB_PLL if !DVB_FE_CUSTOMISE
-	select DVB_CX22702 if !DVB_FE_CUSTOMISE
-	select DVB_LGDT330X if !DVB_FE_CUSTOMISE
-	select DVB_MT352 if !DVB_FE_CUSTOMISE
-	select DVB_ZL10353 if !DVB_FE_CUSTOMISE
-	select DVB_DIB7000P if !DVB_FE_CUSTOMISE
-	select DVB_TUNER_DIB0070 if !DVB_FE_CUSTOMISE
-	select DVB_ATBM8830 if !DVB_FE_CUSTOMISE
-	select DVB_LGS8GXX if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_MXL5005S if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_MAX2165 if !MEDIA_TUNER_CUSTOMISE
+	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_CX22702 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LGDT330X if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_MT352 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_ZL10353 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_DIB7000P if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TUNER_DIB0070 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_ATBM8830 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LGS8GXX if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_SIMPLE if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_XC2028 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MXL5005S if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MAX2165 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the Conexant USB2.0 hybrid reference design.
 	  Currently, only DVB and ATSC modes are supported, analog mode
@@ -132,11 +132,11 @@ config DVB_USB_CXUSB
 config DVB_USB_M920X
 	tristate "Uli m920x DVB-T USB2.0 support"
 	depends on DVB_USB
-	select DVB_MT352 if !DVB_FE_CUSTOMISE
-	select DVB_TDA1004X if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_QT1010 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_TDA827X if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMISE
+	select DVB_MT352 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA1004X if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_QT1010 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA827X if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_SIMPLE if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the MSI Mega Sky 580 USB2.0 DVB-T receiver.
 	  Currently, only devices with a product id of
@@ -146,9 +146,9 @@ config DVB_USB_M920X
 config DVB_USB_DIGITV
 	tristate "Nebula Electronics uDigiTV DVB-T USB2.0 support"
 	depends on DVB_USB
-	select DVB_PLL if !DVB_FE_CUSTOMISE
-	select DVB_NXT6000 if !DVB_FE_CUSTOMISE
-	select DVB_MT352 if !DVB_FE_CUSTOMISE
+	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_NXT6000 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_MT352 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the Nebula Electronics uDigitV USB2.0 DVB-T receiver.
 
@@ -191,17 +191,17 @@ config DVB_USB_NOVA_T_USB2
 	tristate "Hauppauge WinTV-NOVA-T usb2 DVB-T USB2.0 support"
 	depends on DVB_USB
 	select DVB_DIB3000MC
-	select DVB_PLL if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_MT2060 if !MEDIA_TUNER_CUSTOMISE
+	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the Hauppauge WinTV-NOVA-T usb2 DVB-T USB2.0 receiver.
 
 config DVB_USB_TTUSB2
 	tristate "Pinnacle 400e DVB-S USB2.0 support"
 	depends on DVB_USB
-	select DVB_TDA10086 if !DVB_FE_CUSTOMISE
-	select DVB_LNBP21 if !DVB_FE_CUSTOMISE
-	select DVB_TDA826X if !DVB_FE_CUSTOMISE
+	select DVB_TDA10086 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LNBP21 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA826X if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the Pinnacle 400e DVB-S USB2.0 receiver. The
 	  firmware protocol used by this module is similar to the one used by the
@@ -220,16 +220,16 @@ config DVB_USB_DTT200U
 config DVB_USB_OPERA1
 	tristate "Opera1 DVB-S USB2.0 receiver"
 	depends on DVB_USB
-	select DVB_STV0299 if !DVB_FE_CUSTOMISE
-	select DVB_PLL if !DVB_FE_CUSTOMISE
+	select DVB_STV0299 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the Opera DVB-S USB2.0 receiver.
 
 config DVB_USB_AF9005
 	tristate "Afatech AF9005 DVB-T USB1.1 support"
 	depends on DVB_USB && EXPERIMENTAL
-	select MEDIA_TUNER_MT2060 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_QT1010 if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_QT1010 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the Afatech AF9005 based DVB-T USB1.1 receiver
 	  and the TerraTec Cinergy T USB XE (Rev.1)
@@ -245,9 +245,9 @@ config DVB_USB_PCTV452E
 	tristate "Pinnacle PCTV HDTV Pro USB device/TT Connect S2-3600"
 	depends on DVB_USB
 	select TTPCI_EEPROM
-	select DVB_LNBP22 if !DVB_FE_CUSTOMISE
-	select DVB_STB0899 if !DVB_FE_CUSTOMISE
-	select DVB_STB6100 if !DVB_FE_CUSTOMISE
+	select DVB_LNBP22 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STB0899 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STB6100 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for external USB adapter designed by Pinnacle,
 	  shipped under the brand name 'PCTV HDTV Pro USB'.
@@ -257,19 +257,19 @@ config DVB_USB_PCTV452E
 config DVB_USB_DW2102
 	tristate "DvbWorld & TeVii DVB-S/S2 USB2.0 support"
 	depends on DVB_USB
-	select DVB_PLL if !DVB_FE_CUSTOMISE
-	select DVB_STV0299 if !DVB_FE_CUSTOMISE
-	select DVB_STV0288 if !DVB_FE_CUSTOMISE
-	select DVB_STB6000 if !DVB_FE_CUSTOMISE
-	select DVB_CX24116 if !DVB_FE_CUSTOMISE
-	select DVB_SI21XX if !DVB_FE_CUSTOMISE
-	select DVB_TDA10023 if !DVB_FE_CUSTOMISE
-	select DVB_MT312 if !DVB_FE_CUSTOMISE
-	select DVB_ZL10039 if !DVB_FE_CUSTOMISE
-	select DVB_DS3000 if !DVB_FE_CUSTOMISE
-	select DVB_STB6100 if !DVB_FE_CUSTOMISE
-	select DVB_STV6110 if !DVB_FE_CUSTOMISE
-	select DVB_STV0900 if !DVB_FE_CUSTOMISE
+	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0299 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0288 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STB6000 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_CX24116 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_SI21XX if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA10023 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_MT312 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_ZL10039 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_DS3000 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STB6100 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV6110 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0900 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the DvbWorld, TeVii, Prof DVB-S/S2 USB2.0
 	  receivers.
@@ -285,8 +285,8 @@ config DVB_USB_CINERGY_T2
 config DVB_USB_DTV5100
 	tristate "AME DTV-5100 USB2.0 DVB-T support"
 	depends on DVB_USB
-	select DVB_ZL10353 if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_QT1010 if !MEDIA_TUNER_CUSTOMISE
+	select DVB_ZL10353 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_QT1010 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the AME DTV-5100 USB2.0 DVB-T receiver.
 
@@ -299,15 +299,15 @@ config DVB_USB_FRIIO
 config DVB_USB_AZ6027
 	tristate "Azurewave DVB-S/S2 USB2.0 AZ6027 support"
 	depends on DVB_USB
-	select DVB_STB0899 if !DVB_FE_CUSTOMISE
-	select DVB_STB6100 if !DVB_FE_CUSTOMISE
+	select DVB_STB0899 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STB6100 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the AZ6027 device
 
 config DVB_USB_TECHNISAT_USB2
 	tristate "Technisat DVB-S/S2 USB2.0 support"
 	depends on DVB_USB
-	select DVB_STV090x if !DVB_FE_CUSTOMISE
-	select DVB_STV6110x if !DVB_FE_CUSTOMISE
+	select DVB_STV090x if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV6110x if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the Technisat USB2 DVB-S/S2 device
diff --git a/drivers/media/usb/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
index 928ef0d..7a5bd61 100644
--- a/drivers/media/usb/em28xx/Kconfig
+++ b/drivers/media/usb/em28xx/Kconfig
@@ -4,10 +4,10 @@ config VIDEO_EM28XX
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEOBUF_VMALLOC
-	select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_TVP5150 if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_MSP3400 if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_MT9V011 if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_SAA711X if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_TVP5150 if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_MSP3400 if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_MT9V011 if MEDIA_SUBDRV_AUTOSELECT
 
 	---help---
 	  This is a video4linux driver for Empia 28xx based TV cards.
@@ -33,16 +33,16 @@ config VIDEO_EM28XX_ALSA
 config VIDEO_EM28XX_DVB
 	tristate "DVB/ATSC Support for em28xx based TV cards"
 	depends on VIDEO_EM28XX && DVB_CORE
-	select DVB_LGDT330X if !DVB_FE_CUSTOMISE
-	select DVB_ZL10353 if !DVB_FE_CUSTOMISE
-	select DVB_TDA10023 if !DVB_FE_CUSTOMISE
-	select DVB_S921 if !DVB_FE_CUSTOMISE
-	select DVB_DRXD if !DVB_FE_CUSTOMISE
-	select DVB_CXD2820R if !DVB_FE_CUSTOMISE
-	select DVB_DRXK if !DVB_FE_CUSTOMISE
-	select DVB_TDA18271C2DD if !DVB_FE_CUSTOMISE
-	select DVB_TDA10071 if !DVB_FE_CUSTOMISE
-	select DVB_A8293 if !DVB_FE_CUSTOMISE
+	select DVB_LGDT330X if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_ZL10353 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA10023 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_S921 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_DRXD if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_CXD2820R if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_DRXK if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA18271C2DD if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA10071 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_A8293 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEOBUF_DVB
 	---help---
 	  This adds support for DVB cards based on the
diff --git a/drivers/media/usb/pvrusb2/Kconfig b/drivers/media/usb/pvrusb2/Kconfig
index 25e412e..32b11c1 100644
--- a/drivers/media/usb/pvrusb2/Kconfig
+++ b/drivers/media/usb/pvrusb2/Kconfig
@@ -36,13 +36,13 @@ config VIDEO_PVRUSB2_DVB
 	bool "pvrusb2 ATSC/DVB support (EXPERIMENTAL)"
 	default y
 	depends on VIDEO_PVRUSB2 && DVB_CORE && EXPERIMENTAL
-	select DVB_LGDT330X if !DVB_FE_CUSTOMISE
-	select DVB_S5H1409 if !DVB_FE_CUSTOMISE
-	select DVB_S5H1411 if !DVB_FE_CUSTOMISE
-	select DVB_TDA10048 if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_TDA18271 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_TDA8290 if !MEDIA_TUNER_CUSTOMISE
+	select DVB_LGDT330X if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_S5H1409 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_S5H1411 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA10048 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_SIMPLE if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA8290 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 
 	  This option enables a DVB interface for the pvrusb2 driver.
diff --git a/drivers/media/usb/ttusb-budget/Kconfig b/drivers/media/usb/ttusb-budget/Kconfig
index 2663ae3..97bad7d 100644
--- a/drivers/media/usb/ttusb-budget/Kconfig
+++ b/drivers/media/usb/ttusb-budget/Kconfig
@@ -1,13 +1,13 @@
 config DVB_TTUSB_BUDGET
 	tristate "Technotrend/Hauppauge Nova-USB devices"
 	depends on DVB_CORE && USB && I2C && PCI
-	select DVB_CX22700 if !DVB_FE_CUSTOMISE
-	select DVB_TDA1004X if !DVB_FE_CUSTOMISE
-	select DVB_VES1820 if !DVB_FE_CUSTOMISE
-	select DVB_TDA8083 if !DVB_FE_CUSTOMISE
-	select DVB_STV0299 if !DVB_FE_CUSTOMISE
-	select DVB_STV0297 if !DVB_FE_CUSTOMISE
-	select DVB_LNBP21 if !DVB_FE_CUSTOMISE
+	select DVB_CX22700 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA1004X if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_VES1820 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA8083 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0299 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0297 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LNBP21 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for external USB adapters designed by Technotrend and
 	  produced by Hauppauge, shipped under the brand name 'Nova-USB'.
diff --git a/drivers/media/usb/usbvision/Kconfig b/drivers/media/usb/usbvision/Kconfig
index fc24ef0..6b6afc5 100644
--- a/drivers/media/usb/usbvision/Kconfig
+++ b/drivers/media/usb/usbvision/Kconfig
@@ -2,7 +2,7 @@ config VIDEO_USBVISION
 	tristate "USB video devices based on Nogatech NT1003/1004/1005"
 	depends on I2C && VIDEO_V4L2
 	select VIDEO_TUNER
-	select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_SAA711X if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  There are more than 50 different USB video devices based on
 	  NT1003/1004/1005 USB Bridges. This driver enables using those
-- 
1.7.11.4

