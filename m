Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40828 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaHTUMG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 16:12:06 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 5/5] [media] enable COMPILE_TEST for media drivers
Date: Wed, 20 Aug 2014 15:11:57 -0500
Message-Id: <1408565517-22034-5-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1408565517-22034-1-git-send-email-m.chehab@samsung.com>
References: <1408565517-22034-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several arch-specific media drivers that don't
require asm-specific includes and can be successfully
compiled on x86. Add COMPILE_TEST dependency for them, in
order to allow a broader test on those drivers.

That helps static analysis tools like Coverity to discover
eventual troubles there.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/Kconfig            | 21 ++++++++++++++-------
 drivers/media/platform/davinci/Kconfig    | 12 ++++++++----
 drivers/media/platform/s5p-tv/Kconfig     |  3 ++-
 drivers/media/platform/soc_camera/Kconfig | 10 +++++++---
 drivers/media/rc/Kconfig                  |  5 +++--
 5 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 6d0a0df6d818..a8ae457f8a02 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -56,7 +56,8 @@ config VIDEO_VIU
 
 config VIDEO_TIMBERDALE
 	tristate "Support for timberdale Video In/LogiWIN"
-	depends on MFD_TIMBERDALE && VIDEO_V4L2 && I2C && DMADEVICES
+	depends on VIDEO_V4L2 && I2C && DMADEVICES
+	depends on MFD_TIMBERDALE || COMPILE_TEST
 	select DMA_ENGINE
 	select TIMB_DMA
 	select VIDEO_ADV7180
@@ -74,7 +75,8 @@ config VIDEO_VINO
 
 config VIDEO_M32R_AR
 	tristate "AR devices"
-	depends on M32R && VIDEO_V4L2
+	depends on VIDEO_V4L2
+	depends on M32R || COMPILE_TEST
 	---help---
 	  This is a video4linux driver for the Renesas AR (Artificial Retina)
 	  camera module.
@@ -109,7 +111,8 @@ config VIDEO_OMAP3_DEBUG
 config VIDEO_S3C_CAMIF
 	tristate "Samsung S3C24XX/S3C64XX SoC Camera Interface driver"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
-	depends on (ARCH_S3C64XX || PLAT_S3C24XX) && PM_RUNTIME
+	depends on PM_RUNTIME
+	depends on ARCH_S3C64XX || PLAT_S3C24XX || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a v4l2 driver for s3c24xx and s3c64xx SoC series camera
@@ -158,7 +161,8 @@ config VIDEO_MEM2MEM_DEINTERLACE
 
 config VIDEO_SAMSUNG_S5P_G2D
 	tristate "Samsung S5P and EXYNOS4 G2D 2d graphics accelerator driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && (PLAT_S5P || ARCH_EXYNOS)
+	depends on VIDEO_DEV && VIDEO_V4L2
+	depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	default n
@@ -168,7 +172,8 @@ config VIDEO_SAMSUNG_S5P_G2D
 
 config VIDEO_SAMSUNG_S5P_JPEG
 	tristate "Samsung S5P/Exynos3250/Exynos4 JPEG codec driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && (PLAT_S5P || ARCH_EXYNOS)
+	depends on VIDEO_DEV && VIDEO_V4L2
+	depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	---help---
@@ -177,7 +182,8 @@ config VIDEO_SAMSUNG_S5P_JPEG
 
 config VIDEO_SAMSUNG_S5P_MFC
 	tristate "Samsung S5P MFC Video Codec"
-	depends on VIDEO_DEV && VIDEO_V4L2 && (PLAT_S5P || ARCH_EXYNOS)
+	depends on VIDEO_DEV && VIDEO_V4L2
+	depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	default n
 	help
@@ -196,7 +202,8 @@ config VIDEO_MX2_EMMAPRP
 
 config VIDEO_SAMSUNG_EXYNOS_GSC
 	tristate "Samsung Exynos G-Scaler driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_EXYNOS5
+	depends on VIDEO_DEV && VIDEO_V4L2
+	depends on ARCH_EXYNOS5 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	help
diff --git a/drivers/media/platform/davinci/Kconfig b/drivers/media/platform/davinci/Kconfig
index afb3aec1320e..35809278e349 100644
--- a/drivers/media/platform/davinci/Kconfig
+++ b/drivers/media/platform/davinci/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_DAVINCI_VPIF_DISPLAY
 	tristate "TI DaVinci VPIF V4L2-Display driver"
-	depends on VIDEO_DEV && ARCH_DAVINCI
+	depends on VIDEO_DEV
+	depends on ARCH_DAVINCI || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEO_ADV7343 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_THS7303 if MEDIA_SUBDRV_AUTOSELECT
@@ -14,7 +15,8 @@ config VIDEO_DAVINCI_VPIF_DISPLAY
 
 config VIDEO_DAVINCI_VPIF_CAPTURE
 	tristate "TI DaVinci VPIF video capture driver"
-	depends on VIDEO_DEV && ARCH_DAVINCI
+	depends on VIDEO_DEV
+	depends on ARCH_DAVINCI || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	help
 	  Enables Davinci VPIF module used for capture devices.
@@ -26,7 +28,8 @@ config VIDEO_DAVINCI_VPIF_CAPTURE
 
 config VIDEO_DM6446_CCDC
 	tristate "TI DM6446 CCDC video capture driver"
-	depends on VIDEO_V4L2 && (ARCH_DAVINCI || ARCH_OMAP3)
+	depends on VIDEO_V4L2
+	depends on ARCH_DAVINCI || ARCH_OMAP3 || COMPILE_TEST
 	select VIDEOBUF_DMA_CONTIG
 	help
 	   Enables DaVinci CCD hw module. DaVinci CCDC hw interfaces
@@ -40,7 +43,8 @@ config VIDEO_DM6446_CCDC
 
 config VIDEO_DM355_CCDC
 	tristate "TI DM355 CCDC video capture driver"
-	depends on VIDEO_V4L2 && ARCH_DAVINCI
+	depends on VIDEO_V4L2
+	depends on ARCH_DAVINCI || COMPILE_TEST
 	select VIDEOBUF_DMA_CONTIG
 	help
 	   Enables DM355 CCD hw module. DM355 CCDC hw interfaces
diff --git a/drivers/media/platform/s5p-tv/Kconfig b/drivers/media/platform/s5p-tv/Kconfig
index 369a4c191e18..9f38b3dbe0a8 100644
--- a/drivers/media/platform/s5p-tv/Kconfig
+++ b/drivers/media/platform/s5p-tv/Kconfig
@@ -8,7 +8,8 @@
 
 config VIDEO_SAMSUNG_S5P_TV
 	bool "Samsung TV driver for S5P platform"
-	depends on (PLAT_S5P || ARCH_EXYNOS) && PM_RUNTIME
+	depends on PM_RUNTIME
+	depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
 	default n
 	---help---
 	  Say Y here to enable selecting the TV output devices for
diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index 6540847f4e1d..c0d4c0f822ea 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -20,6 +20,7 @@ config SOC_CAMERA_PLATFORM
 config VIDEO_MX3
 	tristate "i.MX3x Camera Sensor Interface driver"
 	depends on VIDEO_DEV && MX3_IPU && SOC_CAMERA
+	depends on MX3_IPU || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a v4l2 driver for the i.MX3x Camera Sensor Interface
@@ -58,7 +59,8 @@ config VIDEO_SH_MOBILE_CEU
 
 config VIDEO_OMAP1
 	tristate "OMAP1 Camera Interface driver"
-	depends on VIDEO_DEV && ARCH_OMAP1 && SOC_CAMERA
+	depends on VIDEO_DEV && SOC_CAMERA
+	depends on ARCH_OMAP1 || COMPILE_TEST
 	select VIDEOBUF_DMA_CONTIG
 	select VIDEOBUF_DMA_SG
 	---help---
@@ -66,14 +68,16 @@ config VIDEO_OMAP1
 
 config VIDEO_MX2
 	tristate "i.MX27 Camera Sensor Interface driver"
-	depends on VIDEO_DEV && SOC_CAMERA && SOC_IMX27
+	depends on VIDEO_DEV && SOC_CAMERA
+	depends on SOC_IMX27 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a v4l2 driver for the i.MX27 Camera Sensor Interface
 
 config VIDEO_ATMEL_ISI
 	tristate "ATMEL Image Sensor Interface (ISI) support"
-	depends on VIDEO_DEV && SOC_CAMERA && ARCH_AT91
+	depends on VIDEO_DEV && SOC_CAMERA
+	depends on ARCH_AT91 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This module makes the ATMEL Image Sensor Interface available
diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 5e626af8e313..2b0cc4a98e88 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -333,7 +333,8 @@ config IR_GPIO_CIR
 
 config RC_ST
 	tristate "ST remote control receiver"
-	depends on ARCH_STI && RC_CORE
+	depends on RC_CORE
+	depends on ARCH_STI || COMPILE_TEST
 	help
 	 Say Y here if you want support for ST remote control driver
 	 which allows both IR and UHF RX.
@@ -344,7 +345,7 @@ config RC_ST
 config IR_SUNXI
     tristate "SUNXI IR remote control"
     depends on RC_CORE
-    depends on ARCH_SUNXI
+    depends on ARCH_SUNXI || COMPILE_TEST
     ---help---
       Say Y if you want to use sunXi internal IR Controller
 
-- 
1.9.3

