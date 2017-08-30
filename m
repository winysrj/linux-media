Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:43080 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750835AbdH3IrY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 04:47:24 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Thomas Kaiser <linux-dvb@kaiser-linux.li>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media: fix media Kconfig help syntax issues
Message-ID: <83028a48-f188-fe8f-7228-4e838044bb81@xs4all.nl>
Date: Wed, 30 Aug 2017 10:47:21 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The help text should be indented by at least two spaces after the
'help' separator. This is both good practice and the media_build system
for building media drivers makes this assumption.

I went through all Kconfigs under drivers/media and fixed any bad help
sections. This makes it conform to the common practice and should fix
problems with 'make menuconfig' when using media_build. This is due to
a "WARNING" message that media_build can insert in the Kconfig and that
assumes the help text is indented by at least two spaces. If not, then the
Kconfig becomes invalid and 'make menuconfig' fails.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Thomas Kaiser <linux-dvb@kaiser-linux.li>
---
Mauro, please double-check the drivers/media/pci/netup_unidvb/Kconfig change:
that Kconfig was really bad and had *two* help sections for the same entry.
---
diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 2631d0e0a024..d17722eb4456 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -173,7 +173,7 @@ config DVB_STB6000
 	tristate "ST STB6000 silicon tuner"
 	depends on DVB_CORE && I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
-	  help
+	help
 	  A DVB-S silicon tuner module. Say Y when you want to support this tuner.

 config DVB_STV0299
@@ -187,7 +187,7 @@ config DVB_STV6110
 	tristate "ST STV6110 silicon tuner"
 	depends on DVB_CORE && I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
-	  help
+	help
 	  A DVB-S silicon tuner module. Say Y when you want to support this tuner.

 config DVB_STV0900
@@ -902,7 +902,7 @@ config DVB_HELENE
 	depends on DVB_CORE && I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
-	Say Y when you want to support this frontend.
+	  Say Y when you want to support this frontend.

 comment "Tools to develop new frontends"

diff --git a/drivers/media/pci/b2c2/Kconfig b/drivers/media/pci/b2c2/Kconfig
index 58761a21caa0..7b818d445f39 100644
--- a/drivers/media/pci/b2c2/Kconfig
+++ b/drivers/media/pci/b2c2/Kconfig
@@ -11,5 +11,5 @@ config DVB_B2C2_FLEXCOP_PCI_DEBUG
 	depends on DVB_B2C2_FLEXCOP_PCI
 	select DVB_B2C2_FLEXCOP_DEBUG
 	help
-	Say Y if you want to enable the module option to control debug messages
-	of all B2C2 FlexCop drivers.
+	  Say Y if you want to enable the module option to control debug messages
+	  of all B2C2 FlexCop drivers.
diff --git a/drivers/media/pci/netup_unidvb/Kconfig b/drivers/media/pci/netup_unidvb/Kconfig
index 0ad37714c7fd..356fff6e6907 100644
--- a/drivers/media/pci/netup_unidvb/Kconfig
+++ b/drivers/media/pci/netup_unidvb/Kconfig
@@ -1,8 +1,8 @@
 config DVB_NETUP_UNIDVB
 	tristate "NetUP Universal DVB card support"
 	depends on DVB_CORE && VIDEO_DEV && PCI && I2C && SPI_MASTER
-    select VIDEOBUF2_DVB
-    select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_DVB
+	select VIDEOBUF2_VMALLOC
 	select DVB_HORUS3A if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_ASCOT2E if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_HELENE if MEDIA_SUBDRV_AUTOSELECT
@@ -10,8 +10,8 @@ config DVB_NETUP_UNIDVB
 	select DVB_CXD2841ER if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  Support for NetUP PCI express Universal DVB card.
-     help
-	Say Y when you want to support NetUP Dual Universal DVB card
-	Card can receive two independent streams in following standards:
+
+	  Say Y when you want to support NetUP Dual Universal DVB card.
+	  Card can receive two independent streams in following standards:
 		DVB-S/S2, T/T2, C/C2
-	Two CI slots available for CAM modules.
+	  Two CI slots available for CAM modules.
diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
index c480efb755f5..46a7d242a1a5 100644
--- a/drivers/media/platform/exynos4-is/Kconfig
+++ b/drivers/media/platform/exynos4-is/Kconfig
@@ -76,7 +76,7 @@ config VIDEO_EXYNOS4_ISP_DMA_CAPTURE
 	depends on VIDEO_EXYNOS4_FIMC_IS
 	select VIDEO_EXYNOS4_IS_COMMON
 	default y
-	  help
+	help
 	  This option enables an additional video device node exposing a V4L2
 	  video capture interface for the FIMC-IS ISP raw (Bayer) capture DMA.

diff --git a/drivers/media/radio/wl128x/Kconfig b/drivers/media/radio/wl128x/Kconfig
index c9e349b169c4..2add222ea346 100644
--- a/drivers/media/radio/wl128x/Kconfig
+++ b/drivers/media/radio/wl128x/Kconfig
@@ -7,11 +7,11 @@ config RADIO_WL128X
 	depends on VIDEO_V4L2 && RFKILL && TTY && TI_ST
 	depends on GPIOLIB || COMPILE_TEST
 	help
-	Choose Y here if you have this FM radio chip.
+	  Choose Y here if you have this FM radio chip.

-	In order to control your radio card, you will need to use programs
-	that are compatible with the Video For Linux 2 API.  Information on
-	this API and pointers to "v4l2" programs may be found at
-	<file:Documentation/video4linux/API.html>.
+	  In order to control your radio card, you will need to use programs
+	  that are compatible with the Video For Linux 2 API.  Information on
+	  this API and pointers to "v4l2" programs may be found at
+	  <file:Documentation/video4linux/API.html>.

 endmenu
diff --git a/drivers/media/usb/b2c2/Kconfig b/drivers/media/usb/b2c2/Kconfig
index 17d35833980c..a620ae42dfc8 100644
--- a/drivers/media/usb/b2c2/Kconfig
+++ b/drivers/media/usb/b2c2/Kconfig
@@ -10,6 +10,6 @@ config DVB_B2C2_FLEXCOP_USB_DEBUG
 	bool "Enable debug for the B2C2 FlexCop drivers"
 	depends on DVB_B2C2_FLEXCOP_USB
 	select DVB_B2C2_FLEXCOP_DEBUG
-	   help
-	Say Y if you want to enable the module option to control debug messages
-	of all B2C2 FlexCop drivers.
+	help
+	  Say Y if you want to enable the module option to control debug messages
+	  of all B2C2 FlexCop drivers.
diff --git a/drivers/media/usb/gspca/Kconfig b/drivers/media/usb/gspca/Kconfig
index 3fd94fe7e1eb..d214a21acff7 100644
--- a/drivers/media/usb/gspca/Kconfig
+++ b/drivers/media/usb/gspca/Kconfig
@@ -204,11 +204,11 @@ config USB_GSPCA_SE401
 	tristate "SE401 USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
-	 Say Y here if you want support for cameras based on the
-	 Endpoints (formerly known as AOX) se401 chip.
+	  Say Y here if you want support for cameras based on the
+	  Endpoints (formerly known as AOX) se401 chip.

-	 To compile this driver as a module, choose M here: the
-	 module will be called gspca_se401.
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_se401.

 config USB_GSPCA_SN9C2028
 	tristate "SONIX Dual-Mode USB Camera Driver"
@@ -224,11 +224,11 @@ config USB_GSPCA_SN9C20X
 	tristate "SN9C20X USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
-	 Say Y here if you want support for cameras based on the
-	 sn9c20x chips (SN9C201 and SN9C202).
+	  Say Y here if you want support for cameras based on the
+	  sn9c20x chips (SN9C201 and SN9C202).

-	 To compile this driver as a module, choose M here: the
-	 module will be called gspca_sn9c20x.
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_sn9c20x.

 config USB_GSPCA_SONIXB
 	tristate "SONIX Bayer USB Camera Driver"
diff --git a/drivers/media/usb/pvrusb2/Kconfig b/drivers/media/usb/pvrusb2/Kconfig
index 60a2604e4cb3..1ad913fc30bf 100644
--- a/drivers/media/usb/pvrusb2/Kconfig
+++ b/drivers/media/usb/pvrusb2/Kconfig
@@ -44,7 +44,6 @@ config VIDEO_PVRUSB2_DVB
 	select MEDIA_TUNER_SIMPLE if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA8290 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
-
 	  This option enables a DVB interface for the pvrusb2 driver.
 	  If your device does not support digital television, this
 	  feature will have no affect on the driver's operation.
