Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57696 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753088AbeBVJd4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 04:33:56 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@s-opensource.com
Subject: [PATCH 1/1] videobuf2: Add VIDEOBUF2_V4L2 Kconfig option for videobuf2 V4L2 part
Date: Thu, 22 Feb 2018 11:33:53 +0200
Message-Id: <20180222093353.22402-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Videobuf2 is now separate from V4L2 and can be now built without it, at
least in principle --- enabling videobuf2 in kernel configuration attempts
to compile videobuf2-v4l2.c but that will fail if CONFIG_VIDEO_V4L2 isn't
enabled.

Solve this by adding a separate Kconfig option for videobuf2-v4l2 and make
it a separate module as well. This means that drivers now need to choose
both the appropriate videobuf2 memory type
(VIDEOBUF2_{VMALLOC,DMA_CONTIG,DMA_SG}) and VIDEOBUF2_V4L2 if they need
both.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi,

This patch addresses the recent issues pointed to by kbuild bot such as
this one:

<URL:https://www.spinics.net/lists/linux-media/msg129339.html>

It's not entirely clear to me which patch introduced the issue but it
appears to be fairly recent. This patch just passed kbuild bot test.

 drivers/input/rmi4/Kconfig                         |  1 +
 drivers/input/touchscreen/Kconfig                  |  2 ++
 drivers/media/common/videobuf2/Kconfig             |  5 ++++
 drivers/media/common/videobuf2/Makefile            |  3 ++-
 drivers/media/pci/cobalt/Kconfig                   |  1 +
 drivers/media/pci/cx23885/Kconfig                  |  1 +
 drivers/media/pci/cx25821/Kconfig                  |  1 +
 drivers/media/pci/cx88/Kconfig                     |  1 +
 drivers/media/pci/dt3155/Kconfig                   |  1 +
 drivers/media/pci/intel/ipu3/Kconfig               |  1 +
 drivers/media/pci/saa7134/Kconfig                  |  1 +
 drivers/media/pci/solo6x10/Kconfig                 |  1 +
 drivers/media/pci/sta2x11/Kconfig                  |  1 +
 drivers/media/pci/tw5864/Kconfig                   |  1 +
 drivers/media/pci/tw68/Kconfig                     |  1 +
 drivers/media/pci/tw686x/Kconfig                   |  1 +
 drivers/media/platform/Kconfig                     | 29 ++++++++++++++++++++++
 drivers/media/platform/am437x/Kconfig              |  1 +
 drivers/media/platform/atmel/Kconfig               |  2 ++
 drivers/media/platform/blackfin/Kconfig            |  1 +
 drivers/media/platform/davinci/Kconfig             |  3 +++
 drivers/media/platform/exynos4-is/Kconfig          |  3 +++
 drivers/media/platform/marvell-ccic/Kconfig        |  2 ++
 drivers/media/platform/rcar-vin/Kconfig            |  1 +
 drivers/media/platform/soc_camera/Kconfig          |  1 +
 drivers/media/platform/vimc/Kconfig                |  1 +
 drivers/media/platform/vivid/Kconfig               |  1 +
 drivers/media/platform/xilinx/Kconfig              |  1 +
 drivers/media/usb/airspy/Kconfig                   |  1 +
 drivers/media/usb/em28xx/Kconfig                   |  1 +
 drivers/media/usb/go7007/Kconfig                   |  1 +
 drivers/media/usb/hackrf/Kconfig                   |  1 +
 drivers/media/usb/msi2500/Kconfig                  |  1 +
 drivers/media/usb/pwc/Kconfig                      |  1 +
 drivers/media/usb/s2255/Kconfig                    |  1 +
 drivers/media/usb/stk1160/Kconfig                  |  1 +
 drivers/media/usb/usbtv/Kconfig                    |  1 +
 drivers/media/usb/uvc/Kconfig                      |  1 +
 drivers/media/v4l2-core/Kconfig                    |  5 ++--
 drivers/staging/media/davinci_vpfe/Kconfig         |  1 +
 drivers/staging/media/imx/Kconfig                  |  1 +
 drivers/staging/media/omap4iss/Kconfig             |  1 +
 .../staging/vc04_services/bcm2835-camera/Kconfig   |  1 +
 drivers/usb/gadget/Kconfig                         |  1 +
 drivers/usb/gadget/legacy/Kconfig                  |  1 +
 45 files changed, 87 insertions(+), 3 deletions(-)

diff --git a/drivers/input/rmi4/Kconfig b/drivers/input/rmi4/Kconfig
index 7172b88cd064..1d296cb9f0ab 100644
--- a/drivers/input/rmi4/Kconfig
+++ b/drivers/input/rmi4/Kconfig
@@ -102,6 +102,7 @@ config RMI4_F54
 	bool "RMI4 Function 54 (Analog diagnostics)"
 	depends on VIDEO_V4L2=y || (RMI4_CORE=m && VIDEO_V4L2=m)
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_V4L2
 	select RMI4_F55
 	help
 	  Say Y here if you want to add support for RMI4 function 54
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 4f15496fec8b..891bb3422146 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -122,6 +122,7 @@ config TOUCHSCREEN_ATMEL_MXT_T37
 	depends on TOUCHSCREEN_ATMEL_MXT
 	depends on VIDEO_V4L2=y || (TOUCHSCREEN_ATMEL_MXT=m && VIDEO_V4L2=m)
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_V4L2
 	help
 	  Say Y here if you want support to output data from the T37
 	  Diagnostic Data object using a V4L device.
@@ -1171,6 +1172,7 @@ config TOUCHSCREEN_SUR40
 	depends on VIDEO_V4L2
 	select INPUT_POLLDEV
 	select VIDEOBUF2_DMA_SG
+	select VIDEOBUF2_V4L2
 	help
 	  Say Y here if you want support for the Samsung SUR40 touchscreen
 	  (also known as Microsoft Surface 2.0 or Microsoft PixelSense).
diff --git a/drivers/media/common/videobuf2/Kconfig b/drivers/media/common/videobuf2/Kconfig
index 5df05250de94..fc8f5a734ddc 100644
--- a/drivers/media/common/videobuf2/Kconfig
+++ b/drivers/media/common/videobuf2/Kconfig
@@ -3,6 +3,11 @@ config VIDEOBUF2_CORE
 	select DMA_SHARED_BUFFER
 	tristate
 
+config VIDEOBUF2_V4L2
+	tristate
+	select VIDEOBUF2_CORE
+	depends on VIDEO_V4L2
+
 config VIDEOBUF2_MEMOPS
 	tristate
 	select FRAME_VECTOR
diff --git a/drivers/media/common/videobuf2/Makefile b/drivers/media/common/videobuf2/Makefile
index 19de5ccda20b..7e27bdd44dcc 100644
--- a/drivers/media/common/videobuf2/Makefile
+++ b/drivers/media/common/videobuf2/Makefile
@@ -1,5 +1,6 @@
 
-obj-$(CONFIG_VIDEOBUF2_CORE) += videobuf2-core.o videobuf2-v4l2.o
+obj-$(CONFIG_VIDEOBUF2_CORE) += videobuf2-core.o
+obj-$(CONFIG_VIDEOBUF2_V4L2) += videobuf2-v4l2.o
 obj-$(CONFIG_VIDEOBUF2_MEMOPS) += videobuf2-memops.o
 obj-$(CONFIG_VIDEOBUF2_VMALLOC) += videobuf2-vmalloc.o
 obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG) += videobuf2-dma-contig.o
diff --git a/drivers/media/pci/cobalt/Kconfig b/drivers/media/pci/cobalt/Kconfig
index aa35cbc0a904..2532aba1cb6b 100644
--- a/drivers/media/pci/cobalt/Kconfig
+++ b/drivers/media/pci/cobalt/Kconfig
@@ -11,6 +11,7 @@ config VIDEO_COBALT
 	select VIDEO_ADV7511
 	select VIDEO_ADV7842
 	select VIDEOBUF2_DMA_SG
+	select VIDEOBUF2_V4L2
 	---help---
 	  This is a video4linux driver for the Cisco PCIe Cobalt card.
 
diff --git a/drivers/media/pci/cx23885/Kconfig b/drivers/media/pci/cx23885/Kconfig
index 3435bbaa3167..297d1ea0a071 100644
--- a/drivers/media/pci/cx23885/Kconfig
+++ b/drivers/media/pci/cx23885/Kconfig
@@ -8,6 +8,7 @@ config VIDEO_CX23885
 	depends on RC_CORE
 	select VIDEOBUF2_DVB
 	select VIDEOBUF2_DMA_SG
+	select VIDEOBUF2_V4L2
 	select VIDEO_CX25840
 	select VIDEO_CX2341X
 	select VIDEO_CS3308
diff --git a/drivers/media/pci/cx25821/Kconfig b/drivers/media/pci/cx25821/Kconfig
index 1755d3d2feaa..c78296f3c73a 100644
--- a/drivers/media/pci/cx25821/Kconfig
+++ b/drivers/media/pci/cx25821/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_CX25821
 	depends on VIDEO_DEV && PCI && I2C
 	select I2C_ALGOBIT
 	select VIDEOBUF2_DMA_SG
+	select VIDEOBUF2_V4L2
 	---help---
 	  This is a video4linux driver for Conexant 25821 based
 	  TV cards.
diff --git a/drivers/media/pci/cx88/Kconfig b/drivers/media/pci/cx88/Kconfig
index 14b813d634a8..c06d6721155b 100644
--- a/drivers/media/pci/cx88/Kconfig
+++ b/drivers/media/pci/cx88/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_CX88
 	depends on VIDEO_DEV && PCI && I2C && RC_CORE
 	select I2C_ALGOBIT
 	select VIDEOBUF2_DMA_SG
+	select VIDEOBUF2_V4L2
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEO_WM8775 if MEDIA_SUBDRV_AUTOSELECT
diff --git a/drivers/media/pci/dt3155/Kconfig b/drivers/media/pci/dt3155/Kconfig
index 5145e0dfa2aa..de9c664bc186 100644
--- a/drivers/media/pci/dt3155/Kconfig
+++ b/drivers/media/pci/dt3155/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_DT3155
 	depends on PCI && VIDEO_DEV && VIDEO_V4L2
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	default n
 	---help---
 	  Enables dt3155 device driver for the DataTranslation DT3155 frame grabber.
diff --git a/drivers/media/pci/intel/ipu3/Kconfig b/drivers/media/pci/intel/ipu3/Kconfig
index a82d3fe277d2..e4fb5960998a 100644
--- a/drivers/media/pci/intel/ipu3/Kconfig
+++ b/drivers/media/pci/intel/ipu3/Kconfig
@@ -8,6 +8,7 @@ config VIDEO_IPU3_CIO2
 	depends on ACPI
 	select V4L2_FWNODE
 	select VIDEOBUF2_DMA_SG
+	select VIDEOBUF2_V4L2
 
 	---help---
 	This is the Intel IPU3 CIO2 CSI-2 receiver unit, found in Intel
diff --git a/drivers/media/pci/saa7134/Kconfig b/drivers/media/pci/saa7134/Kconfig
index b44e0d70907e..8cc1d62d3e96 100644
--- a/drivers/media/pci/saa7134/Kconfig
+++ b/drivers/media/pci/saa7134/Kconfig
@@ -2,6 +2,7 @@ config VIDEO_SAA7134
 	tristate "Philips SAA7134 support"
 	depends on VIDEO_DEV && PCI && I2C
 	select VIDEOBUF2_DMA_SG
+	select VIDEOBUF2_V4L2
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select CRC32
diff --git a/drivers/media/pci/solo6x10/Kconfig b/drivers/media/pci/solo6x10/Kconfig
index 0fb91dc7ca73..3ece37765a08 100644
--- a/drivers/media/pci/solo6x10/Kconfig
+++ b/drivers/media/pci/solo6x10/Kconfig
@@ -7,6 +7,7 @@ config VIDEO_SOLO6X10
 	select FONT_8x16
 	select VIDEOBUF2_DMA_SG
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select SND_PCM
 	select FONT_8x16
 	---help---
diff --git a/drivers/media/pci/sta2x11/Kconfig b/drivers/media/pci/sta2x11/Kconfig
index e03587b1af71..1ea0ef52c702 100644
--- a/drivers/media/pci/sta2x11/Kconfig
+++ b/drivers/media/pci/sta2x11/Kconfig
@@ -4,6 +4,7 @@ config STA2X11_VIP
 	depends on HAS_DMA
 	select VIDEO_ADV7180 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	depends on PCI && VIDEO_V4L2 && VIRT_TO_BUS
 	depends on VIDEO_V4L2_SUBDEV_API
 	depends on I2C
diff --git a/drivers/media/pci/tw5864/Kconfig b/drivers/media/pci/tw5864/Kconfig
index 87c8f327e2d4..2706c06e86c3 100644
--- a/drivers/media/pci/tw5864/Kconfig
+++ b/drivers/media/pci/tw5864/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_TW5864
 	depends on VIDEO_DEV && PCI && VIDEO_V4L2
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	---help---
 	  Support for boards based on Techwell TW5864 chip which provides
 	  multichannel video & audio grabbing and encoding (H.264, MJPEG,
diff --git a/drivers/media/pci/tw68/Kconfig b/drivers/media/pci/tw68/Kconfig
index 95d5d5202048..ecdd17768ec3 100644
--- a/drivers/media/pci/tw68/Kconfig
+++ b/drivers/media/pci/tw68/Kconfig
@@ -2,6 +2,7 @@ config VIDEO_TW68
 	tristate "Techwell tw68x Video For Linux"
 	depends on VIDEO_DEV && PCI && VIDEO_V4L2
 	select VIDEOBUF2_DMA_SG
+	select VIDEOBUF2_V4L2
 	---help---
 	  Support for Techwell tw68xx based frame grabber boards.
 
diff --git a/drivers/media/pci/tw686x/Kconfig b/drivers/media/pci/tw686x/Kconfig
index 34ff37712313..1ddcaa42be35 100644
--- a/drivers/media/pci/tw686x/Kconfig
+++ b/drivers/media/pci/tw686x/Kconfig
@@ -5,6 +5,7 @@ config VIDEO_TW686X
 	select VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEOBUF2_DMA_SG
+	select VIDEOBUF2_V4L2
 	select SND_PCM
 	help
 	  Support for Intersil/Techwell TW686x-based frame grabber cards.
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 614fbef08ddc..7763c399cdf4 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -39,6 +39,7 @@ config VIDEO_SH_VOU
 	depends on VIDEO_DEV && I2C && HAS_DMA
 	depends on ARCH_SHMOBILE || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	help
 	  Support for the Video Output Unit (VOU) on SuperH SoCs.
 
@@ -89,6 +90,7 @@ config VIDEO_OMAP3
 	depends on OMAP_IOMMU
 	select ARM_DMA_USE_IOMMU
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select MFD_SYSCON
 	select V4L2_FWNODE
 	---help---
@@ -105,6 +107,7 @@ config VIDEO_PXA27x
 	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
 	depends on PXA27x || COMPILE_TEST
 	select VIDEOBUF2_DMA_SG
+	select VIDEOBUF2_V4L2
 	select SG_SPLIT
 	select V4L2_FWNODE
 	---help---
@@ -115,6 +118,7 @@ config VIDEO_QCOM_CAMSS
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
 	depends on (ARCH_QCOM && IOMMU_DMA) || COMPILE_TEST
 	select VIDEOBUF2_DMA_SG
+	select VIDEOBUF2_V4L2
 	select V4L2_FWNODE
 
 config VIDEO_S3C_CAMIF
@@ -124,6 +128,7 @@ config VIDEO_S3C_CAMIF
 	depends on ARCH_S3C64XX || PLAT_S3C24XX || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	---help---
 	  This is a v4l2 driver for s3c24xx and s3c64xx SoC series camera
 	  host interface (CAMIF).
@@ -136,6 +141,7 @@ config VIDEO_STM32_DCMI
 	depends on VIDEO_V4L2 && OF && HAS_DMA
 	depends on ARCH_STM32 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_FWNODE
 	---help---
 	  This module makes the STM32 Digital Camera Memory Interface (DCMI)
@@ -157,6 +163,7 @@ config VIDEO_TI_CAL
 	depends on SOC_DRA7XX || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_FWNODE
 	default n
 	---help---
@@ -186,6 +193,7 @@ config VIDEO_CODA
 	depends on HAS_DMA
 	select SRAM
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select VIDEOBUF2_VMALLOC
 	select V4L2_MEM2MEM_DEV
 	select GENERIC_ALLOCATOR
@@ -203,6 +211,7 @@ config VIDEO_MEDIATEK_JPEG
 	depends on ARCH_MEDIATEK || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_MEM2MEM_DEV
 	---help---
 	  Mediatek jpeg codec driver provides HW capability to decode
@@ -231,6 +240,7 @@ config VIDEO_MEDIATEK_MDP
 	depends on ARCH_MEDIATEK || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_MEM2MEM_DEV
 	select VIDEO_MEDIATEK_VPU
 	default n
@@ -247,6 +257,7 @@ config VIDEO_MEDIATEK_VCODEC
 	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
 	depends on ARCH_MEDIATEK || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_MEM2MEM_DEV
 	select VIDEO_MEDIATEK_VPU
 	default n
@@ -263,6 +274,7 @@ config VIDEO_MEM2MEM_DEINTERLACE
 	depends on VIDEO_DEV && VIDEO_V4L2 && DMA_ENGINE
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_MEM2MEM_DEV
 	help
 	    Generic deinterlacing V4L2 driver.
@@ -273,6 +285,7 @@ config VIDEO_SAMSUNG_S5P_G2D
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_MEM2MEM_DEV
 	default n
 	---help---
@@ -285,6 +298,7 @@ config VIDEO_SAMSUNG_S5P_JPEG
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_MEM2MEM_DEV
 	---help---
 	  This is a v4l2 driver for Samsung S5P, EXYNOS3250
@@ -296,6 +310,7 @@ config VIDEO_SAMSUNG_S5P_MFC
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	default n
 	help
 	    MFC 5.1 and 6.x driver for V4L2
@@ -306,6 +321,7 @@ config VIDEO_MX2_EMMAPRP
 	depends on SOC_IMX27 || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_MEM2MEM_DEV
 	help
 	    MX2X chips have a PrP that can be used to process buffers from
@@ -318,6 +334,7 @@ config VIDEO_SAMSUNG_EXYNOS_GSC
 	depends on ARCH_EXYNOS || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_MEM2MEM_DEV
 	help
 	  This is a v4l2 driver for Samsung EXYNOS5 SoC G-Scaler.
@@ -328,6 +345,7 @@ config VIDEO_STI_BDISP
 	depends on HAS_DMA
 	depends on ARCH_STI || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_MEM2MEM_DEV
 	help
 	  This v4l2 mem2mem driver is a 2D blitter for STMicroelectronics SoC.
@@ -338,6 +356,7 @@ config VIDEO_STI_HVA
 	depends on HAS_DMA
 	depends on ARCH_STI || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_MEM2MEM_DEV
 	help
 	  This V4L2 driver enables HVA (Hardware Video Accelerator) multi-format
@@ -392,6 +411,7 @@ config VIDEO_STI_DELTA_DRIVER
 	depends on VIDEO_STI_DELTA_MJPEG
 	default VIDEO_STI_DELTA_MJPEG
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_MEM2MEM_DEV
 	select RPMSG
 
@@ -401,6 +421,7 @@ config VIDEO_SH_VEU
 	tristate "SuperH VEU mem2mem video processing driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_MEM2MEM_DEV
 	help
 	    Support for the Video Engine Unit (VEU) on SuperH and
@@ -412,6 +433,7 @@ config VIDEO_RENESAS_FDP1
 	depends on ARCH_SHMOBILE || COMPILE_TEST
 	depends on (!ARCH_RENESAS && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_MEM2MEM_DEV
 	---help---
 	  This is a V4L2 driver for the Renesas Fine Display Processor
@@ -425,6 +447,7 @@ config VIDEO_RENESAS_JPU
 	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_MEM2MEM_DEV
 	---help---
 	  This is a V4L2 driver for the Renesas JPEG Processing Unit.
@@ -451,6 +474,7 @@ config VIDEO_RENESAS_VSP1
 	depends on (ARCH_RENESAS && OF) || COMPILE_TEST
 	depends on (!ARM64 && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select VIDEOBUF2_VMALLOC
 	---help---
 	  This is a V4L2 driver for the Renesas VSP1 video processing engine.
@@ -463,6 +487,7 @@ config VIDEO_ROCKCHIP_RGA
 	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
 	depends on ARCH_ROCKCHIP || COMPILE_TEST
 	select VIDEOBUF2_DMA_SG
+	select VIDEOBUF2_V4L2
 	select V4L2_MEM2MEM_DEV
 	default n
 	---help---
@@ -479,6 +504,7 @@ config VIDEO_TI_VPE
 	depends on SOC_DRA7XX || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_MEM2MEM_DEV
 	select VIDEO_TI_VPDMA
 	select VIDEO_TI_SC
@@ -501,6 +527,7 @@ config VIDEO_QCOM_VENUS
 	select QCOM_MDT_LOADER if ARCH_QCOM
 	select QCOM_SCM if ARCH_QCOM
 	select VIDEOBUF2_DMA_SG
+	select VIDEOBUF2_V4L2
 	select V4L2_MEM2MEM_DEV
 	---help---
 	  This is a V4L2 driver for Qualcomm Venus video accelerator
@@ -535,6 +562,7 @@ config VIDEO_VIM2M
 	tristate "Virtual Memory-to-Memory Driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_V4L2
 	select V4L2_MEM2MEM_DEV
 	default n
 	---help---
@@ -641,6 +669,7 @@ config VIDEO_RCAR_DRIF
 	depends on VIDEO_V4L2 && HAS_DMA
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_V4L2
 	---help---
 	  Say Y if you want to enable R-Car Gen3 DRIF support. DRIF is Digital
 	  Radio Interface that interfaces with an RF front end chip. It is a
diff --git a/drivers/media/platform/am437x/Kconfig b/drivers/media/platform/am437x/Kconfig
index 160e77e9a0fb..3f302f63fca6 100644
--- a/drivers/media/platform/am437x/Kconfig
+++ b/drivers/media/platform/am437x/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_AM437X_VPFE
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
 	depends on SOC_AM43XX || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_FWNODE
 	help
 	   Support for AM437x Video Processing Front End based Video
diff --git a/drivers/media/platform/atmel/Kconfig b/drivers/media/platform/atmel/Kconfig
index 55de751e5f51..fdd51dc6d79c 100644
--- a/drivers/media/platform/atmel/Kconfig
+++ b/drivers/media/platform/atmel/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_ATMEL_ISC
 	depends on VIDEO_V4L2 && COMMON_CLK && VIDEO_V4L2_SUBDEV_API && HAS_DMA
 	depends on ARCH_AT91 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select REGMAP_MMIO
 	select V4L2_FWNODE
 	help
@@ -14,6 +15,7 @@ config VIDEO_ATMEL_ISI
 	depends on VIDEO_V4L2 && OF && HAS_DMA
 	depends on ARCH_AT91 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_FWNODE
 	---help---
 	  This module makes the ATMEL Image Sensor Interface available
diff --git a/drivers/media/platform/blackfin/Kconfig b/drivers/media/platform/blackfin/Kconfig
index 68fa90151b8f..2e0e1eb591de 100644
--- a/drivers/media/platform/blackfin/Kconfig
+++ b/drivers/media/platform/blackfin/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_BLACKFIN_CAPTURE
 	depends on VIDEO_V4L2 && BLACKFIN && I2C
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	help
 	  V4L2 bridge driver for Blackfin video capture device.
 	  Choose PPI or EPPI as its interface.
diff --git a/drivers/media/platform/davinci/Kconfig b/drivers/media/platform/davinci/Kconfig
index 55982e681d77..8ac9346085d6 100644
--- a/drivers/media/platform/davinci/Kconfig
+++ b/drivers/media/platform/davinci/Kconfig
@@ -5,6 +5,7 @@ config VIDEO_DAVINCI_VPIF_DISPLAY
 	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select VIDEO_ADV7343 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_THS7303 if MEDIA_SUBDRV_AUTOSELECT
 	help
@@ -22,6 +23,7 @@ config VIDEO_DAVINCI_VPIF_CAPTURE
 	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_FWNODE
 	help
 	  Enables Davinci VPIF module used for capture devices.
@@ -85,6 +87,7 @@ config VIDEO_DAVINCI_VPBE_DISPLAY
 	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	help
 	    Enables Davinci VPBE module used for display devices.
 	    This module is used for display on TI DM644x/DM365/DM355
diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
index 7b2c49e5a592..679bee63f959 100644
--- a/drivers/media/platform/exynos4-is/Kconfig
+++ b/drivers/media/platform/exynos4-is/Kconfig
@@ -19,6 +19,7 @@ config VIDEO_S5P_FIMC
 	depends on I2C
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_MEM2MEM_DEV
 	select MFD_SYSCON
 	select VIDEO_EXYNOS4_IS_COMMON
@@ -48,6 +49,7 @@ config VIDEO_EXYNOS_FIMC_LITE
 	depends on I2C
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select VIDEO_EXYNOS4_IS_COMMON
 	help
 	  This is a V4L2 driver for Samsung EXYNOS4/5 SoC FIMC-LITE camera
@@ -62,6 +64,7 @@ config VIDEO_EXYNOS4_FIMC_IS
 	depends on I2C
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	depends on OF
 	select FW_LOADER
 	help
diff --git a/drivers/media/platform/marvell-ccic/Kconfig b/drivers/media/platform/marvell-ccic/Kconfig
index 4bf5bd1e90d6..daf73b62fa7a 100644
--- a/drivers/media/platform/marvell-ccic/Kconfig
+++ b/drivers/media/platform/marvell-ccic/Kconfig
@@ -6,6 +6,7 @@ config VIDEO_CAFE_CCIC
 	select VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEOBUF2_DMA_SG
+	select VIDEOBUF2_V4L2
 	---help---
 	  This is a video4linux2 driver for the Marvell 88ALP01 integrated
 	  CMOS camera controller.  This is the controller found on first-
@@ -18,6 +19,7 @@ config VIDEO_MMP_CAMERA
 	select VIDEO_OV7670
 	select I2C_GPIO
 	select VIDEOBUF2_DMA_SG
+	select VIDEOBUF2_V4L2
 	---help---
 	  This is a Video4Linux2 driver for the integrated camera
 	  controller found on Marvell Armada 610 application
diff --git a/drivers/media/platform/rcar-vin/Kconfig b/drivers/media/platform/rcar-vin/Kconfig
index af4c98b44d2e..64764eec2210 100644
--- a/drivers/media/platform/rcar-vin/Kconfig
+++ b/drivers/media/platform/rcar-vin/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_RCAR_VIN
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && HAS_DMA && MEDIA_CONTROLLER
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_FWNODE
 	---help---
 	  Support for Renesas R-Car Video Input (VIN) driver.
diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index f5979c12ad61..08f88505ab22 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -2,6 +2,7 @@ config SOC_CAMERA
 	tristate "SoC camera support"
 	depends on VIDEO_V4L2 && HAS_DMA && I2C
 	select VIDEOBUF2_CORE
+	select VIDEOBUF2_V4L2
 	help
 	  SoC Camera is a common API to several cameras, not connecting
 	  over a bus like PCI or USB. For example some i2c camera connected
diff --git a/drivers/media/platform/vimc/Kconfig b/drivers/media/platform/vimc/Kconfig
index 71c9fe7d3370..911954d120b7 100644
--- a/drivers/media/platform/vimc/Kconfig
+++ b/drivers/media/platform/vimc/Kconfig
@@ -2,6 +2,7 @@ config VIDEO_VIMC
 	tristate "Virtual Media Controller Driver (VIMC)"
 	depends on VIDEO_DEV && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_V4L2
 	select VIDEO_V4L2_TPG
 	default n
 	---help---
diff --git a/drivers/media/platform/vivid/Kconfig b/drivers/media/platform/vivid/Kconfig
index 154de92dd809..e9035d09f487 100644
--- a/drivers/media/platform/vivid/Kconfig
+++ b/drivers/media/platform/vivid/Kconfig
@@ -9,6 +9,7 @@ config VIDEO_VIVID
 	select FB_CFB_IMAGEBLIT
 	select VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select VIDEO_V4L2_TPG
 	default n
 	---help---
diff --git a/drivers/media/platform/xilinx/Kconfig b/drivers/media/platform/xilinx/Kconfig
index a5d21b7c6e0b..8e61ccdba361 100644
--- a/drivers/media/platform/xilinx/Kconfig
+++ b/drivers/media/platform/xilinx/Kconfig
@@ -2,6 +2,7 @@ config VIDEO_XILINX
 	tristate "Xilinx Video IP (EXPERIMENTAL)"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_FWNODE
 	---help---
 	  Driver for Xilinx Video IP Pipelines
diff --git a/drivers/media/usb/airspy/Kconfig b/drivers/media/usb/airspy/Kconfig
index 10b204cf4dbc..281ea0edeef2 100644
--- a/drivers/media/usb/airspy/Kconfig
+++ b/drivers/media/usb/airspy/Kconfig
@@ -2,6 +2,7 @@ config USB_AIRSPY
 	tristate "AirSpy"
 	depends on VIDEO_V4L2
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_V4L2
 	---help---
 	  This is a video4linux2 driver for AirSpy SDR device.
 
diff --git a/drivers/media/usb/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
index 451e076525d3..db7e2b532d5a 100644
--- a/drivers/media/usb/em28xx/Kconfig
+++ b/drivers/media/usb/em28xx/Kconfig
@@ -8,6 +8,7 @@ config VIDEO_EM28XX_V4L2
 	tristate "Empia EM28xx analog TV, video capture and/or webcam support"
 	depends on VIDEO_EM28XX
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_V4L2
 	select VIDEO_SAA711X if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_TVP5150 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_MSP3400 if MEDIA_SUBDRV_AUTOSELECT
diff --git a/drivers/media/usb/go7007/Kconfig b/drivers/media/usb/go7007/Kconfig
index af1d02430931..a54d39585c60 100644
--- a/drivers/media/usb/go7007/Kconfig
+++ b/drivers/media/usb/go7007/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_GO7007
 	depends on VIDEO_DEV && I2C
 	depends on SND && USB
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_V4L2
 	select VIDEO_TUNER
 	select CYPRESS_FIRMWARE
 	select SND_PCM
diff --git a/drivers/media/usb/hackrf/Kconfig b/drivers/media/usb/hackrf/Kconfig
index 937e6f5c1e8e..4810f13434fc 100644
--- a/drivers/media/usb/hackrf/Kconfig
+++ b/drivers/media/usb/hackrf/Kconfig
@@ -2,6 +2,7 @@ config USB_HACKRF
 	tristate "HackRF"
 	depends on VIDEO_V4L2
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_V4L2
 	---help---
 	  This is a video4linux2 driver for HackRF SDR device.
 
diff --git a/drivers/media/usb/msi2500/Kconfig b/drivers/media/usb/msi2500/Kconfig
index 9eff8a76ff0e..4593ef52c71e 100644
--- a/drivers/media/usb/msi2500/Kconfig
+++ b/drivers/media/usb/msi2500/Kconfig
@@ -2,4 +2,5 @@ config USB_MSI2500
 	tristate "Mirics MSi2500"
 	depends on VIDEO_V4L2 && SPI
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_V4L2
 	select MEDIA_TUNER_MSI001
diff --git a/drivers/media/usb/pwc/Kconfig b/drivers/media/usb/pwc/Kconfig
index d63d0a850035..b2a79191ed85 100644
--- a/drivers/media/usb/pwc/Kconfig
+++ b/drivers/media/usb/pwc/Kconfig
@@ -2,6 +2,7 @@ config USB_PWC
 	tristate "USB Philips Cameras"
 	depends on VIDEO_V4L2
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_V4L2
 	---help---
 	  Say Y or M here if you want to use one of these Philips & OEM
 	  webcams:
diff --git a/drivers/media/usb/s2255/Kconfig b/drivers/media/usb/s2255/Kconfig
index 8c3fceef9a09..9aba7c42feae 100644
--- a/drivers/media/usb/s2255/Kconfig
+++ b/drivers/media/usb/s2255/Kconfig
@@ -2,6 +2,7 @@ config USB_S2255
 	tristate "USB Sensoray 2255 video capture device"
 	depends on VIDEO_V4L2
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_V4L2
 	default n
 	help
 	  Say Y here if you want support for the Sensoray 2255 USB device.
diff --git a/drivers/media/usb/stk1160/Kconfig b/drivers/media/usb/stk1160/Kconfig
index 425ed00e2599..90485a624109 100644
--- a/drivers/media/usb/stk1160/Kconfig
+++ b/drivers/media/usb/stk1160/Kconfig
@@ -17,4 +17,5 @@ config VIDEO_STK1160
 	depends on VIDEO_STK1160_COMMON
 	default y
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_V4L2
 	select VIDEO_SAA711X
diff --git a/drivers/media/usb/usbtv/Kconfig b/drivers/media/usb/usbtv/Kconfig
index 14a0941fa0d0..89512fd658d2 100644
--- a/drivers/media/usb/usbtv/Kconfig
+++ b/drivers/media/usb/usbtv/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_USBTV
 	depends on VIDEO_V4L2 && SND
 	select SND_PCM
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_V4L2
 
 	---help---
 	  This is a video4linux2 driver for USBTV007 based video capture devices.
diff --git a/drivers/media/usb/uvc/Kconfig b/drivers/media/usb/uvc/Kconfig
index 6ed85efabcaa..ea366645e85e 100644
--- a/drivers/media/usb/uvc/Kconfig
+++ b/drivers/media/usb/uvc/Kconfig
@@ -2,6 +2,7 @@ config USB_VIDEO_CLASS
 	tristate "USB Video Class (UVC)"
 	depends on VIDEO_V4L2
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_V4L2
 	---help---
 	  Support for the USB Video Class (UVC).  Currently only video
 	  input devices, such as webcams, are supported.
diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index bf52fbd07aed..6ffbf137fefb 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -29,8 +29,9 @@ config VIDEO_FIXED_MINOR_RANGES
 config VIDEO_PCI_SKELETON
 	tristate "Skeleton PCI V4L2 driver"
 	depends on PCI
-	depends on VIDEO_V4L2 && VIDEOBUF2_CORE
+	depends on VIDEO_V4L2
 	depends on VIDEOBUF2_MEMOPS && VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	---help---
 	  Enable build of the skeleton PCI driver, used as a reference
 	  when developing new drivers.
@@ -42,7 +43,7 @@ config VIDEO_TUNER
 # Used by drivers that need v4l2-mem2mem.ko
 config V4L2_MEM2MEM_DEV
 	tristate
-	depends on VIDEOBUF2_CORE
+	depends on VIDEOBUF2_V4L2
 
 # Used by LED subsystem flash drivers
 config V4L2_FLASH_LED_CLASS
diff --git a/drivers/staging/media/davinci_vpfe/Kconfig b/drivers/staging/media/davinci_vpfe/Kconfig
index f40a06954a92..8fd9527b4461 100644
--- a/drivers/staging/media/davinci_vpfe/Kconfig
+++ b/drivers/staging/media/davinci_vpfe/Kconfig
@@ -5,6 +5,7 @@ config VIDEO_DM365_VPFE
 	depends on VIDEO_V4L2_SUBDEV_API
 	depends on VIDEO_DAVINCI_VPBE_DISPLAY
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	help
 	  Support for DM365 VPFE based Media Controller Capture driver.
 
diff --git a/drivers/staging/media/imx/Kconfig b/drivers/staging/media/imx/Kconfig
index 2be921cd0d55..e4540c89ad98 100644
--- a/drivers/staging/media/imx/Kconfig
+++ b/drivers/staging/media/imx/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_IMX_MEDIA
 	depends on MEDIA_CONTROLLER && VIDEO_V4L2 && ARCH_MXC && IMX_IPUV3_CORE
 	depends on VIDEO_V4L2_SUBDEV_API
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	select V4L2_FWNODE
 	---help---
 	  Say yes here to enable support for video4linux media controller
diff --git a/drivers/staging/media/omap4iss/Kconfig b/drivers/staging/media/omap4iss/Kconfig
index 46183464ee79..99ebaf149df5 100644
--- a/drivers/staging/media/omap4iss/Kconfig
+++ b/drivers/staging/media/omap4iss/Kconfig
@@ -4,5 +4,6 @@ config VIDEO_OMAP4
 	depends on HAS_DMA
 	select MFD_SYSCON
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_V4L2
 	---help---
 	  Driver for an OMAP 4 ISS controller.
diff --git a/drivers/staging/vc04_services/bcm2835-camera/Kconfig b/drivers/staging/vc04_services/bcm2835-camera/Kconfig
index b8b01aa4e426..6dec4a83556c 100644
--- a/drivers/staging/vc04_services/bcm2835-camera/Kconfig
+++ b/drivers/staging/vc04_services/bcm2835-camera/Kconfig
@@ -4,6 +4,7 @@ config VIDEO_BCM2835
 	depends on VIDEO_V4L2 && (ARCH_BCM2835 || COMPILE_TEST)
 	select BCM2835_VCHIQ
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_V4L2
 	select BTREE
 	help
 	  Say Y here to enable camera host interface devices for
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 31cce7805eb2..85162b205a1d 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -448,6 +448,7 @@ config USB_CONFIGFS_F_UVC
 	depends on VIDEO_V4L2
 	depends on VIDEO_DEV
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_V4L2
 	select USB_F_UVC
 	help
 	  The Webcam function acts as a composite USB Audio and Video Class
diff --git a/drivers/usb/gadget/legacy/Kconfig b/drivers/usb/gadget/legacy/Kconfig
index 784bf86dad4f..bf39b0700b2c 100644
--- a/drivers/usb/gadget/legacy/Kconfig
+++ b/drivers/usb/gadget/legacy/Kconfig
@@ -482,6 +482,7 @@ config USB_G_WEBCAM
 	depends on VIDEO_V4L2
 	select USB_LIBCOMPOSITE
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_V4L2
 	select USB_F_UVC
 	help
 	  The Webcam Gadget acts as a composite USB Audio and Video Class
-- 
2.11.0
