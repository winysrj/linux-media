Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44119 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776AbaHZVzU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:20 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 34/35] [media] be sure that HAS_DMA is enabled for vb2-dma-contig
Date: Tue, 26 Aug 2014 18:55:10 -0300
Message-Id: <1409090111-8290-35-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vb2-dma-contig depends on HAS_DMA, but the Kbuild doesn't take
it into account at select.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/pci/solo6x10/Kconfig          |  1 +
 drivers/media/pci/sta2x11/Kconfig           |  1 +
 drivers/media/platform/Kconfig              | 12 ++++++++++++
 drivers/media/platform/blackfin/Kconfig     |  1 +
 drivers/media/platform/davinci/Kconfig      |  6 ++++++
 drivers/media/platform/exynos4-is/Kconfig   |  3 +++
 drivers/media/platform/marvell-ccic/Kconfig |  2 ++
 drivers/media/platform/s5p-tv/Kconfig       |  1 +
 drivers/media/platform/soc_camera/Kconfig   |  6 ++++++
 drivers/staging/media/davinci_vpfe/Kconfig  |  1 +
 drivers/staging/media/dt3155v4l/Kconfig     |  1 +
 drivers/staging/media/omap4iss/Kconfig      |  1 +
 12 files changed, 36 insertions(+)

diff --git a/drivers/media/pci/solo6x10/Kconfig b/drivers/media/pci/solo6x10/Kconfig
index d9e06a6bf1eb..0fb91dc7ca73 100644
--- a/drivers/media/pci/solo6x10/Kconfig
+++ b/drivers/media/pci/solo6x10/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_SOLO6X10
 	tristate "Bluecherry / Softlogic 6x10 capture cards (MPEG-4/H.264)"
 	depends on PCI && VIDEO_DEV && SND && I2C
+	depends on HAS_DMA
 	select BITREVERSE
 	select FONT_SUPPORT
 	select FONT_8x16
diff --git a/drivers/media/pci/sta2x11/Kconfig b/drivers/media/pci/sta2x11/Kconfig
index 03130157db83..f6f30abc088b 100644
--- a/drivers/media/pci/sta2x11/Kconfig
+++ b/drivers/media/pci/sta2x11/Kconfig
@@ -1,6 +1,7 @@
 config STA2X11_VIP
 	tristate "STA2X11 VIP Video For Linux"
 	depends on STA2X11
+	depends on HAS_DMA
 	select VIDEO_ADV7180 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEOBUF2_DMA_CONTIG
 	depends on PCI && VIDEO_V4L2 && VIRT_TO_BUS
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index a8ae457f8a02..ae021faf7a42 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -96,6 +96,7 @@ config VIDEO_M32R_AR_M64278
 config VIDEO_OMAP3
 	tristate "OMAP 3 Camera support"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
+	depends on HAS_DMA
 	select ARM_DMA_USE_IOMMU
 	select OMAP_IOMMU
 	select VIDEOBUF2_DMA_CONTIG
@@ -113,6 +114,7 @@ config VIDEO_S3C_CAMIF
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	depends on PM_RUNTIME
 	depends on ARCH_S3C64XX || PLAT_S3C24XX || COMPILE_TEST
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a v4l2 driver for s3c24xx and s3c64xx SoC series camera
@@ -143,6 +145,7 @@ if V4L_MEM2MEM_DRIVERS
 config VIDEO_CODA
 	tristate "Chips&Media Coda multi-standard codec IP"
 	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MXC
+	depends on HAS_DMA
 	select SRAM
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
@@ -154,6 +157,7 @@ config VIDEO_CODA
 config VIDEO_MEM2MEM_DEINTERLACE
 	tristate "Deinterlace support"
 	depends on VIDEO_DEV && VIDEO_V4L2 && DMA_ENGINE
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	help
@@ -163,6 +167,7 @@ config VIDEO_SAMSUNG_S5P_G2D
 	tristate "Samsung S5P and EXYNOS4 G2D 2d graphics accelerator driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	default n
@@ -174,6 +179,7 @@ config VIDEO_SAMSUNG_S5P_JPEG
 	tristate "Samsung S5P/Exynos3250/Exynos4 JPEG codec driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	---help---
@@ -184,6 +190,7 @@ config VIDEO_SAMSUNG_S5P_MFC
 	tristate "Samsung S5P MFC Video Codec"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	default n
 	help
@@ -193,6 +200,7 @@ config VIDEO_MX2_EMMAPRP
 	tristate "MX2 eMMa-PrP support"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on SOC_IMX27 || COMPILE_TEST
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	help
@@ -204,6 +212,7 @@ config VIDEO_SAMSUNG_EXYNOS_GSC
 	tristate "Samsung Exynos G-Scaler driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_EXYNOS5 || COMPILE_TEST
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	help
@@ -212,6 +221,7 @@ config VIDEO_SAMSUNG_EXYNOS_GSC
 config VIDEO_SH_VEU
 	tristate "SuperH VEU mem2mem video processing driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	help
@@ -221,6 +231,7 @@ config VIDEO_SH_VEU
 config VIDEO_RENESAS_VSP1
 	tristate "Renesas VSP1 Video Processing Engine"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a V4L2 driver for the Renesas VSP1 video processing engine.
@@ -232,6 +243,7 @@ config VIDEO_TI_VPE
 	tristate "TI VPE (Video Processing Engine) driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on SOC_DRA7XX || COMPILE_TEST
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	default n
diff --git a/drivers/media/platform/blackfin/Kconfig b/drivers/media/platform/blackfin/Kconfig
index cc239972fa2c..68fa90151b8f 100644
--- a/drivers/media/platform/blackfin/Kconfig
+++ b/drivers/media/platform/blackfin/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_BLACKFIN_CAPTURE
 	tristate "Blackfin Video Capture Driver"
 	depends on VIDEO_V4L2 && BLACKFIN && I2C
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	help
 	  V4L2 bridge driver for Blackfin video capture device.
diff --git a/drivers/media/platform/davinci/Kconfig b/drivers/media/platform/davinci/Kconfig
index 35809278e349..b04016e8532d 100644
--- a/drivers/media/platform/davinci/Kconfig
+++ b/drivers/media/platform/davinci/Kconfig
@@ -2,6 +2,7 @@ config VIDEO_DAVINCI_VPIF_DISPLAY
 	tristate "TI DaVinci VPIF V4L2-Display driver"
 	depends on VIDEO_DEV
 	depends on ARCH_DAVINCI || COMPILE_TEST
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEO_ADV7343 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_THS7303 if MEDIA_SUBDRV_AUTOSELECT
@@ -17,6 +18,7 @@ config VIDEO_DAVINCI_VPIF_CAPTURE
 	tristate "TI DaVinci VPIF video capture driver"
 	depends on VIDEO_DEV
 	depends on ARCH_DAVINCI || COMPILE_TEST
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	help
 	  Enables Davinci VPIF module used for capture devices.
@@ -30,6 +32,7 @@ config VIDEO_DM6446_CCDC
 	tristate "TI DM6446 CCDC video capture driver"
 	depends on VIDEO_V4L2
 	depends on ARCH_DAVINCI || ARCH_OMAP3 || COMPILE_TEST
+	depends on HAS_DMA
 	select VIDEOBUF_DMA_CONTIG
 	help
 	   Enables DaVinci CCD hw module. DaVinci CCDC hw interfaces
@@ -45,6 +48,7 @@ config VIDEO_DM355_CCDC
 	tristate "TI DM355 CCDC video capture driver"
 	depends on VIDEO_V4L2
 	depends on ARCH_DAVINCI || COMPILE_TEST
+	depends on HAS_DMA
 	select VIDEOBUF_DMA_CONTIG
 	help
 	   Enables DM355 CCD hw module. DM355 CCDC hw interfaces
@@ -59,6 +63,7 @@ config VIDEO_DM355_CCDC
 config VIDEO_DM365_ISIF
 	tristate "TI DM365 ISIF video capture driver"
 	depends on VIDEO_V4L2 && ARCH_DAVINCI
+	depends on HAS_DMA
 	select VIDEOBUF_DMA_CONTIG
 	help
 	   Enables ISIF hw module. This is the hardware module for
@@ -71,6 +76,7 @@ config VIDEO_DM365_ISIF
 config VIDEO_DAVINCI_VPBE_DISPLAY
 	tristate "TI DaVinci VPBE V4L2-Display driver"
 	depends on ARCH_DAVINCI
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	help
 	    Enables Davinci VPBE module used for display devices.
diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
index 811872195f36..77c951237744 100644
--- a/drivers/media/platform/exynos4-is/Kconfig
+++ b/drivers/media/platform/exynos4-is/Kconfig
@@ -16,6 +16,7 @@ config VIDEO_EXYNOS4_IS_COMMON
 config VIDEO_S5P_FIMC
 	tristate "S5P/EXYNOS4 FIMC/CAMIF camera interface driver"
 	depends on I2C
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	select MFD_SYSCON
@@ -43,6 +44,7 @@ if SOC_EXYNOS4212 || SOC_EXYNOS4412 || SOC_EXYNOS5250
 config VIDEO_EXYNOS_FIMC_LITE
 	tristate "EXYNOS FIMC-LITE camera interface driver"
 	depends on I2C
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEO_EXYNOS4_IS_COMMON
 	help
@@ -55,6 +57,7 @@ endif
 
 config VIDEO_EXYNOS4_FIMC_IS
 	tristate "EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver"
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	depends on OF
 	select FW_LOADER
diff --git a/drivers/media/platform/marvell-ccic/Kconfig b/drivers/media/platform/marvell-ccic/Kconfig
index bf739e3b3398..6265d36adceb 100644
--- a/drivers/media/platform/marvell-ccic/Kconfig
+++ b/drivers/media/platform/marvell-ccic/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_CAFE_CCIC
 	tristate "Marvell 88ALP01 (Cafe) CMOS Camera Controller support"
 	depends on PCI && I2C && VIDEO_V4L2
+	depends on HAS_DMA
 	select VIDEO_OV7670
 	select VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_DMA_CONTIG
@@ -12,6 +13,7 @@ config VIDEO_CAFE_CCIC
 config VIDEO_MMP_CAMERA
 	tristate "Marvell Armada 610 integrated camera controller support"
 	depends on ARCH_MMP && I2C && VIDEO_V4L2
+	depends on HAS_DMA
 	select VIDEO_OV7670
 	select I2C_GPIO
 	select VIDEOBUF2_DMA_SG
diff --git a/drivers/media/platform/s5p-tv/Kconfig b/drivers/media/platform/s5p-tv/Kconfig
index 9f38b3dbe0a8..a9d56f8936b4 100644
--- a/drivers/media/platform/s5p-tv/Kconfig
+++ b/drivers/media/platform/s5p-tv/Kconfig
@@ -71,6 +71,7 @@ config VIDEO_SAMSUNG_S5P_MIXER
 	tristate "Samsung Mixer and Video Processor Driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on VIDEO_SAMSUNG_S5P_TV
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	help
 	  Say Y here if you want support for the Mixer in Samsung S5P SoCs.
diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index c0d4c0f822ea..6af6c6dccda8 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -21,6 +21,7 @@ config VIDEO_MX3
 	tristate "i.MX3x Camera Sensor Interface driver"
 	depends on VIDEO_DEV && MX3_IPU && SOC_CAMERA
 	depends on MX3_IPU || COMPILE_TEST
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a v4l2 driver for the i.MX3x Camera Sensor Interface
@@ -36,6 +37,7 @@ config VIDEO_RCAR_VIN
 	tristate "R-Car Video Input (VIN) support"
 	depends on VIDEO_DEV && SOC_CAMERA
 	depends on ARCH_SHMOBILE || COMPILE_TEST
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select SOC_CAMERA_SCALE_CROP
 	---help---
@@ -52,6 +54,7 @@ config VIDEO_SH_MOBILE_CEU
 	tristate "SuperH Mobile CEU Interface driver"
 	depends on VIDEO_DEV && SOC_CAMERA && HAS_DMA && HAVE_CLK
 	depends on ARCH_SHMOBILE || SUPERH || COMPILE_TEST
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select SOC_CAMERA_SCALE_CROP
 	---help---
@@ -61,6 +64,7 @@ config VIDEO_OMAP1
 	tristate "OMAP1 Camera Interface driver"
 	depends on VIDEO_DEV && SOC_CAMERA
 	depends on ARCH_OMAP1 || COMPILE_TEST
+	depends on HAS_DMA
 	select VIDEOBUF_DMA_CONTIG
 	select VIDEOBUF_DMA_SG
 	---help---
@@ -70,6 +74,7 @@ config VIDEO_MX2
 	tristate "i.MX27 Camera Sensor Interface driver"
 	depends on VIDEO_DEV && SOC_CAMERA
 	depends on SOC_IMX27 || COMPILE_TEST
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a v4l2 driver for the i.MX27 Camera Sensor Interface
@@ -78,6 +83,7 @@ config VIDEO_ATMEL_ISI
 	tristate "ATMEL Image Sensor Interface (ISI) support"
 	depends on VIDEO_DEV && SOC_CAMERA
 	depends on ARCH_AT91 || COMPILE_TEST
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This module makes the ATMEL Image Sensor Interface available
diff --git a/drivers/staging/media/davinci_vpfe/Kconfig b/drivers/staging/media/davinci_vpfe/Kconfig
index 12f321dd2399..4de2f082491d 100644
--- a/drivers/staging/media/davinci_vpfe/Kconfig
+++ b/drivers/staging/media/davinci_vpfe/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_DM365_VPFE
 	tristate "DM365 VPFE Media Controller Capture Driver"
 	depends on VIDEO_V4L2 && ARCH_DAVINCI_DM365 && !VIDEO_DM365_ISIF
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	help
 	  Support for DM365 VPFE based Media Controller Capture driver.
diff --git a/drivers/staging/media/dt3155v4l/Kconfig b/drivers/staging/media/dt3155v4l/Kconfig
index 226a1ca90b3c..2d496001b6e8 100644
--- a/drivers/staging/media/dt3155v4l/Kconfig
+++ b/drivers/staging/media/dt3155v4l/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_DT3155
 	tristate "DT3155 frame grabber, Video4Linux interface"
 	depends on PCI && VIDEO_DEV && VIDEO_V4L2
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	default n
 	---help---
diff --git a/drivers/staging/media/omap4iss/Kconfig b/drivers/staging/media/omap4iss/Kconfig
index 8afc6fee40c5..b78643f907e7 100644
--- a/drivers/staging/media/omap4iss/Kconfig
+++ b/drivers/staging/media/omap4iss/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_OMAP4
 	bool "OMAP 4 Camera support"
 	depends on VIDEO_V4L2=y && VIDEO_V4L2_SUBDEV_API && I2C=y && ARCH_OMAP4
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  Driver for an OMAP 4 ISS controller.
-- 
1.9.3

