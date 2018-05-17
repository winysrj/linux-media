Return-path: <linux-media-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:33364 "EHLO
        baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751047AbeEQRSQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 13:18:16 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v4] media: Remove depends on HAS_DMA in case of platform dependency
Date: Thu, 17 May 2018 19:18:12 +0200
Message-Id: <1526577492-19538-1-git-send-email-geert@linux-m68k.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove dependencies on HAS_DMA where a Kconfig symbol depends on another
symbol that implies HAS_DMA, and, optionally, on "|| COMPILE_TEST".
In most cases this other symbol is an architecture or platform specific
symbol, or PCI.

Generic symbols and drivers without platform dependencies keep their
dependencies on HAS_DMA, to prevent compiling subsystems or drivers that
cannot work anyway.

This simplifies the dependencies, and allows to improve compile-testing.

Note:
  - The various VIDEOBUF*DMA* symbols had to loose their dependencies on
    HAS_DMA, as they are selected by several individual drivers.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: Robin Murphy <robin.murphy@arm.com>
---
From: kbuild test robot <lkp@intel.com>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git  no-dma-compile-testing-v4-media
branch HEAD: 9fd4215b490cae0bb6dd058a18a19e60dbcd3020  media: Remove depends on HAS_DMA in case of platform dependency

elapsed time: 41m

configs tested: 99

---
v4:
  - Rebase to media-next on 2018-05-17,

v3:
  - Rebase to v4.17-rc1,
  - Handle new VIDEO_RENESAS_CEU symbol,

v2:
  - Add Reviewed-by, Acked-by,
  - Drop RFC state,
  - Drop dependency of VIDEOBUF{,2}_DMA_{CONTIG,SG} on HAS_DMA,
  - Drop new dependencies of VIDEO_IPU3_CIO2 and DVB_C8SECTPFE on
    HAS_DMA,
  - Split per subsystem.
---
 drivers/media/common/videobuf2/Kconfig       |  2 --
 drivers/media/pci/dt3155/Kconfig             |  1 -
 drivers/media/pci/intel/ipu3/Kconfig         |  1 -
 drivers/media/pci/solo6x10/Kconfig           |  1 -
 drivers/media/pci/sta2x11/Kconfig            |  1 -
 drivers/media/pci/tw5864/Kconfig             |  1 -
 drivers/media/pci/tw686x/Kconfig             |  1 -
 drivers/media/platform/Kconfig               | 43 +++++++++-------------------
 drivers/media/platform/am437x/Kconfig        |  2 +-
 drivers/media/platform/atmel/Kconfig         |  4 +--
 drivers/media/platform/davinci/Kconfig       |  6 ----
 drivers/media/platform/marvell-ccic/Kconfig  |  2 --
 drivers/media/platform/rcar-vin/Kconfig      |  2 +-
 drivers/media/platform/soc_camera/Kconfig    |  3 +-
 drivers/media/platform/sti/c8sectpfe/Kconfig |  2 +-
 drivers/media/v4l2-core/Kconfig              |  2 --
 drivers/staging/media/davinci_vpfe/Kconfig   |  1 -
 drivers/staging/media/omap4iss/Kconfig       |  1 -
 18 files changed, 20 insertions(+), 56 deletions(-)

diff --git a/drivers/media/common/videobuf2/Kconfig b/drivers/media/common/videobuf2/Kconfig
index 17c32ea58395d78f..4ed11b46676ac4d0 100644
--- a/drivers/media/common/videobuf2/Kconfig
+++ b/drivers/media/common/videobuf2/Kconfig
@@ -12,7 +12,6 @@ config VIDEOBUF2_MEMOPS
 
 config VIDEOBUF2_DMA_CONTIG
 	tristate
-	depends on HAS_DMA
 	select VIDEOBUF2_CORE
 	select VIDEOBUF2_MEMOPS
 	select DMA_SHARED_BUFFER
@@ -25,7 +24,6 @@ config VIDEOBUF2_VMALLOC
 
 config VIDEOBUF2_DMA_SG
 	tristate
-	depends on HAS_DMA
 	select VIDEOBUF2_CORE
 	select VIDEOBUF2_MEMOPS
 
diff --git a/drivers/media/pci/dt3155/Kconfig b/drivers/media/pci/dt3155/Kconfig
index 5145e0dfa2aa9e12..858b0f2f15bef9c8 100644
--- a/drivers/media/pci/dt3155/Kconfig
+++ b/drivers/media/pci/dt3155/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_DT3155
 	tristate "DT3155 frame grabber"
 	depends on PCI && VIDEO_DEV && VIDEO_V4L2
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	default n
 	---help---
diff --git a/drivers/media/pci/intel/ipu3/Kconfig b/drivers/media/pci/intel/ipu3/Kconfig
index 45cf99a512e484d5..c8bd98d7564afdfb 100644
--- a/drivers/media/pci/intel/ipu3/Kconfig
+++ b/drivers/media/pci/intel/ipu3/Kconfig
@@ -4,7 +4,6 @@ config VIDEO_IPU3_CIO2
 	depends on VIDEO_V4L2_SUBDEV_API
 	depends on (X86 && ACPI) || COMPILE_TEST
 	depends on MEDIA_CONTROLLER
-	depends on HAS_DMA
 	select V4L2_FWNODE
 	select VIDEOBUF2_DMA_SG
 
diff --git a/drivers/media/pci/solo6x10/Kconfig b/drivers/media/pci/solo6x10/Kconfig
index 0fb91dc7ca73529e..d9e06a6bf1ebc1a7 100644
--- a/drivers/media/pci/solo6x10/Kconfig
+++ b/drivers/media/pci/solo6x10/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_SOLO6X10
 	tristate "Bluecherry / Softlogic 6x10 capture cards (MPEG-4/H.264)"
 	depends on PCI && VIDEO_DEV && SND && I2C
-	depends on HAS_DMA
 	select BITREVERSE
 	select FONT_SUPPORT
 	select FONT_8x16
diff --git a/drivers/media/pci/sta2x11/Kconfig b/drivers/media/pci/sta2x11/Kconfig
index 7af3f1cbcea824b9..4407b9f881e400d8 100644
--- a/drivers/media/pci/sta2x11/Kconfig
+++ b/drivers/media/pci/sta2x11/Kconfig
@@ -1,7 +1,6 @@
 config STA2X11_VIP
 	tristate "STA2X11 VIP Video For Linux"
 	depends on STA2X11 || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEO_ADV7180 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEOBUF2_DMA_CONTIG
 	depends on PCI && VIDEO_V4L2 && VIRT_TO_BUS
diff --git a/drivers/media/pci/tw5864/Kconfig b/drivers/media/pci/tw5864/Kconfig
index 87c8f327e2d49dfa..760fb11dfeaef47b 100644
--- a/drivers/media/pci/tw5864/Kconfig
+++ b/drivers/media/pci/tw5864/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_TW5864
 	tristate "Techwell TW5864 video/audio grabber and encoder"
 	depends on VIDEO_DEV && PCI && VIDEO_V4L2
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  Support for boards based on Techwell TW5864 chip which provides
diff --git a/drivers/media/pci/tw686x/Kconfig b/drivers/media/pci/tw686x/Kconfig
index 34ff37712313b780..da8bfee71b44cca5 100644
--- a/drivers/media/pci/tw686x/Kconfig
+++ b/drivers/media/pci/tw686x/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_TW686X
 	tristate "Intersil/Techwell TW686x video capture cards"
 	depends on PCI && VIDEO_DEV && VIDEO_V4L2 && SND
-	depends on HAS_DMA
 	select VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEOBUF2_DMA_SG
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 5c3ae58cc40cdebd..254f09a8ef6b1a4e 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -34,7 +34,7 @@ source "drivers/media/platform/omap/Kconfig"
 config VIDEO_SH_VOU
 	tristate "SuperH VOU video output driver"
 	depends on MEDIA_CAMERA_SUPPORT
-	depends on VIDEO_DEV && I2C && HAS_DMA
+	depends on VIDEO_DEV && I2C
 	depends on ARCH_SHMOBILE || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	help
@@ -64,8 +64,7 @@ config VIDEO_OMAP3
 	tristate "OMAP 3 Camera support"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	depends on (ARCH_OMAP3 && OMAP_IOMMU) || COMPILE_TEST
-	depends on COMMON_CLK
-	depends on HAS_DMA && OF
+	depends on COMMON_CLK && OF
 	select ARM_DMA_USE_IOMMU if OMAP_IOMMU
 	select VIDEOBUF2_DMA_CONTIG
 	select MFD_SYSCON
@@ -81,7 +80,7 @@ config VIDEO_OMAP3_DEBUG
 
 config VIDEO_PXA27x
 	tristate "PXA27x Quick Capture Interface driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on PXA27x || COMPILE_TEST
 	select VIDEOBUF2_DMA_SG
 	select SG_SPLIT
@@ -91,7 +90,7 @@ config VIDEO_PXA27x
 
 config VIDEO_QCOM_CAMSS
 	tristate "Qualcomm 8x16 V4L2 Camera Subsystem driver"
-	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on (ARCH_QCOM && IOMMU_DMA) || COMPILE_TEST
 	select VIDEOBUF2_DMA_SG
 	select V4L2_FWNODE
@@ -101,7 +100,6 @@ config VIDEO_S3C_CAMIF
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	depends on PM
 	depends on ARCH_S3C64XX || PLAT_S3C24XX || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a v4l2 driver for s3c24xx and s3c64xx SoC series camera
@@ -112,7 +110,7 @@ config VIDEO_S3C_CAMIF
 
 config VIDEO_STM32_DCMI
 	tristate "STM32 Digital Camera Memory Interface (DCMI) support"
-	depends on VIDEO_V4L2 && OF && HAS_DMA
+	depends on VIDEO_V4L2 && OF
 	depends on ARCH_STM32 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
@@ -125,7 +123,7 @@ config VIDEO_STM32_DCMI
 
 config VIDEO_RENESAS_CEU
 	tristate "Renesas Capture Engine Unit (CEU) driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_SHMOBILE || ARCH_R7S72100 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
@@ -143,7 +141,6 @@ config VIDEO_TI_CAL
 	tristate "TI CAL (Camera Adaptation Layer) driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on SOC_DRA7XX || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
 	default n
@@ -171,7 +168,6 @@ if V4L_MEM2MEM_DRIVERS
 config VIDEO_CODA
 	tristate "Chips&Media Coda multi-standard codec IP"
 	depends on VIDEO_DEV && VIDEO_V4L2 && (ARCH_MXC || COMPILE_TEST)
-	depends on HAS_DMA
 	select SRAM
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEOBUF2_VMALLOC
@@ -189,7 +185,6 @@ config VIDEO_MEDIATEK_JPEG
 	depends on MTK_IOMMU_V1 || COMPILE_TEST
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_MEDIATEK || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	---help---
@@ -201,7 +196,7 @@ config VIDEO_MEDIATEK_JPEG
 
 config VIDEO_MEDIATEK_VPU
 	tristate "Mediatek Video Processor Unit"
-	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_MEDIATEK || COMPILE_TEST
 	---help---
 	    This driver provides downloading VPU firmware and
@@ -217,7 +212,6 @@ config VIDEO_MEDIATEK_MDP
 	depends on MTK_IOMMU || COMPILE_TEST
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_MEDIATEK || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	select VIDEO_MEDIATEK_VPU
@@ -232,7 +226,7 @@ config VIDEO_MEDIATEK_MDP
 config VIDEO_MEDIATEK_VCODEC
 	tristate "Mediatek Video Codec driver"
 	depends on MTK_IOMMU || COMPILE_TEST
-	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_MEDIATEK || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
@@ -259,7 +253,6 @@ config VIDEO_SAMSUNG_S5P_G2D
 	tristate "Samsung S5P and EXYNOS4 G2D 2d graphics accelerator driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	default n
@@ -271,7 +264,6 @@ config VIDEO_SAMSUNG_S5P_JPEG
 	tristate "Samsung S5P/Exynos3250/Exynos4 JPEG codec driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	---help---
@@ -282,7 +274,6 @@ config VIDEO_SAMSUNG_S5P_MFC
 	tristate "Samsung S5P MFC Video Codec"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	default n
 	help
@@ -292,7 +283,6 @@ config VIDEO_MX2_EMMAPRP
 	tristate "MX2 eMMa-PrP support"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on SOC_IMX27 || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	help
@@ -304,7 +294,6 @@ config VIDEO_SAMSUNG_EXYNOS_GSC
 	tristate "Samsung Exynos G-Scaler driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_EXYNOS || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	help
@@ -313,7 +302,6 @@ config VIDEO_SAMSUNG_EXYNOS_GSC
 config VIDEO_STI_BDISP
 	tristate "STMicroelectronics BDISP 2D blitter driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
-	depends on HAS_DMA
 	depends on ARCH_STI || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
@@ -323,7 +311,6 @@ config VIDEO_STI_BDISP
 config VIDEO_STI_HVA
 	tristate "STMicroelectronics HVA multi-format video encoder V4L2 driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
-	depends on HAS_DMA
 	depends on ARCH_STI || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
@@ -350,7 +337,6 @@ config VIDEO_STI_DELTA
 	tristate "STMicroelectronics DELTA multi-format video decoder V4L2 driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_STI || COMPILE_TEST
-	depends on HAS_DMA
 	help
 		This V4L2 driver enables DELTA multi-format video decoder
 		of STMicroelectronics STiH4xx SoC series allowing hardware
@@ -396,7 +382,7 @@ config VIDEO_SH_VEU
 
 config VIDEO_RENESAS_FDP1
 	tristate "Renesas Fine Display Processor"
-	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_SHMOBILE || COMPILE_TEST
 	depends on (!ARCH_RENESAS && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
 	select VIDEOBUF2_DMA_CONTIG
@@ -410,7 +396,7 @@ config VIDEO_RENESAS_FDP1
 
 config VIDEO_RENESAS_JPU
 	tristate "Renesas JPEG Processing Unit"
-	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
@@ -435,7 +421,7 @@ config VIDEO_RENESAS_FCP
 
 config VIDEO_RENESAS_VSP1
 	tristate "Renesas VSP1 Video Processing Engine"
-	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on (ARCH_RENESAS && OF) || COMPILE_TEST
 	depends on (!ARM64 && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
 	select VIDEOBUF2_DMA_CONTIG
@@ -448,7 +434,7 @@ config VIDEO_RENESAS_VSP1
 
 config VIDEO_ROCKCHIP_RGA
 	tristate "Rockchip Raster 2d Graphic Acceleration Unit"
-	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_ROCKCHIP || COMPILE_TEST
 	select VIDEOBUF2_DMA_SG
 	select V4L2_MEM2MEM_DEV
@@ -465,7 +451,6 @@ config VIDEO_TI_VPE
 	tristate "TI VPE (Video Processing Engine) driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on SOC_DRA7XX || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	select VIDEO_TI_VPDMA
@@ -484,7 +469,7 @@ config VIDEO_TI_VPE_DEBUG
 
 config VIDEO_QCOM_VENUS
 	tristate "Qualcomm Venus V4L2 encoder/decoder driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on (ARCH_QCOM && IOMMU_DMA) || COMPILE_TEST
 	select QCOM_MDT_LOADER if ARCH_QCOM
 	select QCOM_SCM if ARCH_QCOM
@@ -626,7 +611,7 @@ if SDR_PLATFORM_DRIVERS
 
 config VIDEO_RCAR_DRIF
 	tristate "Renesas Digitial Radio Interface (DRIF)"
-	depends on VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_V4L2
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select VIDEOBUF2_VMALLOC
 	---help---
diff --git a/drivers/media/platform/am437x/Kconfig b/drivers/media/platform/am437x/Kconfig
index 160e77e9a0fbfa61..f4ce1176e4dc8179 100644
--- a/drivers/media/platform/am437x/Kconfig
+++ b/drivers/media/platform/am437x/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_AM437X_VPFE
 	tristate "TI AM437x VPFE video capture driver"
-	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on SOC_AM43XX || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
diff --git a/drivers/media/platform/atmel/Kconfig b/drivers/media/platform/atmel/Kconfig
index 55de751e5f51500b..a211ef20f77eadba 100644
--- a/drivers/media/platform/atmel/Kconfig
+++ b/drivers/media/platform/atmel/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_ATMEL_ISC
 	tristate "ATMEL Image Sensor Controller (ISC) support"
-	depends on VIDEO_V4L2 && COMMON_CLK && VIDEO_V4L2_SUBDEV_API && HAS_DMA
+	depends on VIDEO_V4L2 && COMMON_CLK && VIDEO_V4L2_SUBDEV_API
 	depends on ARCH_AT91 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select REGMAP_MMIO
@@ -11,7 +11,7 @@ config VIDEO_ATMEL_ISC
 
 config VIDEO_ATMEL_ISI
 	tristate "ATMEL Image Sensor Interface (ISI) support"
-	depends on VIDEO_V4L2 && OF && HAS_DMA
+	depends on VIDEO_V4L2 && OF
 	depends on ARCH_AT91 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
diff --git a/drivers/media/platform/davinci/Kconfig b/drivers/media/platform/davinci/Kconfig
index b463d1726335a51d..06b5e581f25f2416 100644
--- a/drivers/media/platform/davinci/Kconfig
+++ b/drivers/media/platform/davinci/Kconfig
@@ -2,7 +2,6 @@ config VIDEO_DAVINCI_VPIF_DISPLAY
 	tristate "TI DaVinci VPIF V4L2-Display driver"
 	depends on VIDEO_V4L2
 	depends on ARCH_DAVINCI || COMPILE_TEST
-	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEO_ADV7343 if MEDIA_SUBDRV_AUTOSELECT
@@ -19,7 +18,6 @@ config VIDEO_DAVINCI_VPIF_CAPTURE
 	tristate "TI DaVinci VPIF video capture driver"
 	depends on VIDEO_V4L2
 	depends on ARCH_DAVINCI || COMPILE_TEST
-	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
@@ -35,7 +33,6 @@ config VIDEO_DM6446_CCDC
 	tristate "TI DM6446 CCDC video capture driver"
 	depends on VIDEO_V4L2
 	depends on ARCH_DAVINCI || COMPILE_TEST
-	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF_DMA_CONTIG
 	help
@@ -52,7 +49,6 @@ config VIDEO_DM355_CCDC
 	tristate "TI DM355 CCDC video capture driver"
 	depends on VIDEO_V4L2
 	depends on ARCH_DAVINCI || COMPILE_TEST
-	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF_DMA_CONTIG
 	help
@@ -69,7 +65,6 @@ config VIDEO_DM365_ISIF
 	tristate "TI DM365 ISIF video capture driver"
 	depends on VIDEO_V4L2
 	depends on ARCH_DAVINCI || COMPILE_TEST
-	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF_DMA_CONTIG
 	help
@@ -84,7 +79,6 @@ config VIDEO_DAVINCI_VPBE_DISPLAY
 	tristate "TI DaVinci VPBE V4L2-Display driver"
 	depends on VIDEO_V4L2
 	depends on ARCH_DAVINCI || COMPILE_TEST
-	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF2_DMA_CONTIG
 	help
diff --git a/drivers/media/platform/marvell-ccic/Kconfig b/drivers/media/platform/marvell-ccic/Kconfig
index 21dacef7c2fccdfc..60dbe6d1fae9c9d5 100644
--- a/drivers/media/platform/marvell-ccic/Kconfig
+++ b/drivers/media/platform/marvell-ccic/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_CAFE_CCIC
 	tristate "Marvell 88ALP01 (Cafe) CMOS Camera Controller support"
 	depends on PCI && I2C && VIDEO_V4L2
-	depends on HAS_DMA
 	select VIDEO_OV7670
 	select VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_DMA_CONTIG
@@ -14,7 +13,6 @@ config VIDEO_CAFE_CCIC
 config VIDEO_MMP_CAMERA
 	tristate "Marvell Armada 610 integrated camera controller support"
 	depends on I2C && VIDEO_V4L2
-	depends on HAS_DMA
 	depends on ARCH_MMP || COMPILE_TEST
 	select VIDEO_OV7670
 	select I2C_GPIO
diff --git a/drivers/media/platform/rcar-vin/Kconfig b/drivers/media/platform/rcar-vin/Kconfig
index 8fa7ee468c63afb9..89b4860bafba566d 100644
--- a/drivers/media/platform/rcar-vin/Kconfig
+++ b/drivers/media/platform/rcar-vin/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_RCAR_VIN
 	tristate "R-Car Video Input (VIN) Driver"
-	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && HAS_DMA && MEDIA_CONTROLLER
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && MEDIA_CONTROLLER
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index f5979c12ad618f4a..669d116b8f09b2aa 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -18,9 +18,8 @@ config SOC_CAMERA_PLATFORM
 
 config VIDEO_SH_MOBILE_CEU
 	tristate "SuperH Mobile CEU Interface driver"
-	depends on VIDEO_DEV && SOC_CAMERA && HAS_DMA && HAVE_CLK
+	depends on VIDEO_DEV && SOC_CAMERA && HAVE_CLK
 	depends on ARCH_SHMOBILE || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select SOC_CAMERA_SCALE_CROP
 	---help---
diff --git a/drivers/media/platform/sti/c8sectpfe/Kconfig b/drivers/media/platform/sti/c8sectpfe/Kconfig
index 740190f8a3b606d3..7420a50572d347ef 100644
--- a/drivers/media/platform/sti/c8sectpfe/Kconfig
+++ b/drivers/media/platform/sti/c8sectpfe/Kconfig
@@ -1,6 +1,6 @@
 config DVB_C8SECTPFE
 	tristate "STMicroelectronics C8SECTPFE DVB support"
-	depends on PINCTRL && DVB_CORE && I2C && HAS_DMA
+	depends on PINCTRL && DVB_CORE && I2C
 	depends on ARCH_STI || ARCH_MULTIPLATFORM || COMPILE_TEST
 	select FW_LOADER
 	select DEBUG_FS
diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index 2a56f37f186bbe4b..b97090e859968c99 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -65,7 +65,6 @@ config VIDEOBUF_GEN
 
 config VIDEOBUF_DMA_SG
 	tristate
-	depends on HAS_DMA
 	select VIDEOBUF_GEN
 
 config VIDEOBUF_VMALLOC
@@ -74,5 +73,4 @@ config VIDEOBUF_VMALLOC
 
 config VIDEOBUF_DMA_CONTIG
 	tristate
-	depends on HAS_DMA
 	select VIDEOBUF_GEN
diff --git a/drivers/staging/media/davinci_vpfe/Kconfig b/drivers/staging/media/davinci_vpfe/Kconfig
index bcba9a64c514bef6..aea449a8dbf8a08a 100644
--- a/drivers/staging/media/davinci_vpfe/Kconfig
+++ b/drivers/staging/media/davinci_vpfe/Kconfig
@@ -2,7 +2,6 @@ config VIDEO_DM365_VPFE
 	tristate "DM365 VPFE Media Controller Capture Driver"
 	depends on VIDEO_V4L2
 	depends on (ARCH_DAVINCI_DM365 && !VIDEO_DM365_ISIF) || COMPILE_TEST
-	depends on HAS_DMA
 	depends on VIDEO_V4L2_SUBDEV_API
 	depends on VIDEO_DAVINCI_VPBE_DISPLAY
 	select VIDEOBUF2_DMA_CONTIG
diff --git a/drivers/staging/media/omap4iss/Kconfig b/drivers/staging/media/omap4iss/Kconfig
index 192ba0829128a76a..dddd27335cb433bf 100644
--- a/drivers/staging/media/omap4iss/Kconfig
+++ b/drivers/staging/media/omap4iss/Kconfig
@@ -2,7 +2,6 @@ config VIDEO_OMAP4
 	tristate "OMAP 4 Camera support"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && I2C
 	depends on ARCH_OMAP4 || COMPILE_TEST
-	depends on HAS_DMA
 	select MFD_SYSCON
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
-- 
2.7.4
