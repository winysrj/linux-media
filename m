Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:40415 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759777AbZFQULb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 16:11:31 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id n5HKBTLl009842
	for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 15:11:34 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 11/11 - v3] Makefile and config file changes for davinci git tree
Date: Wed, 17 Jun 2009 16:11:24 -0400
Message-Id: <1245269484-8325-12-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1245269484-8325-11-git-send-email-m-karicheri2@ti.com>
References: <1245269484-8325-1-git-send-email-m-karicheri2@ti.com>
 <1245269484-8325-2-git-send-email-m-karicheri2@ti.com>
 <1245269484-8325-3-git-send-email-m-karicheri2@ti.com>
 <1245269484-8325-4-git-send-email-m-karicheri2@ti.com>
 <1245269484-8325-5-git-send-email-m-karicheri2@ti.com>
 <1245269484-8325-6-git-send-email-m-karicheri2@ti.com>
 <1245269484-8325-7-git-send-email-m-karicheri2@ti.com>
 <1245269484-8325-8-git-send-email-m-karicheri2@ti.com>
 <1245269484-8325-9-git-send-email-m-karicheri2@ti.com>
 <1245269484-8325-10-git-send-email-m-karicheri2@ti.com>
 <1245269484-8325-11-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

Makefile and config files for vpfe capture driver that applies
to DaVinci GIT tree only. This is added to help in applying this
patch to DaVinci GIT tree since the tree has some obsolete davinci
drivers that is being removed by this patch. These files are not
available in upstream kernel. Please use this patch instead of 
Patch #6 of this series for DaVinci GIT tree.

Reviewed by: Hans Verkuil <hverkuil@xs4all.nl>
Reviewed by: Laurent Pinchart <laurent.pinchart@skynet.be>
Reviewed by: Kevin Hilman <khilman@deeprootsystems.com>

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to DaVinci GIT tree

 drivers/media/video/Kconfig          |   57 +++++++++++++++++++++++++--------
 drivers/media/video/Makefile         |    6 +---
 drivers/media/video/davinci/Makefile |    9 +++++
 3 files changed, 53 insertions(+), 19 deletions(-)
 create mode 100644 drivers/media/video/davinci/Makefile

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index e037e3f..ee6806c 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -479,25 +479,54 @@ config VIDEO_VIVI
 	  Say Y here if you want to test video apps or debug V4L devices.
 	  In doubt, say N.
 
-config VIDEO_TVP5146
-	tristate "TVP5146 video decoder"
-	depends on I2C && ARCH_DAVINCI
+config VIDEO_VPSS_SYSTEM
+	tristate "VPSS System module driver"
+	depends on ARCH_DAVINCI
 	help
-	  Support for I2C bus based TVP5146 configuration.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called tvp5146.
+	  Support for vpss system module for video driver
+	default y
 
-config VIDEO_DAVINCI
-	tristate "Davinci Video Capture"
-	depends on VIDEO_DEV && VIDEO_TVP5146 && ARCH_DAVINCI
-	select VIDEOBUF_GEN
-	select VIDEOBUF_DMA_SG
+config VIDEO_VPFE_CAPTURE
+	tristate "VPFE Video Capture Driver"
+	depends on VIDEO_V4L2 && ARCH_DAVINCI
+	select VIDEOBUF_DMA_CONTIG
 	help
-	  Support for Davinci based frame grabber through CCDC.
+	  Support for DMXXXX VPFE based frame grabber. This is the
+	  common V4L2 module for following DMXXX SoCs from Texas
+	  Instruments:- DM6446 & DM355.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called vpfe.
+	  module will be called vpfe-capture.
+
+config VIDEO_DM6446_CCDC
+	tristate "DM6446 CCDC HW module"
+	depends on ARCH_DAVINCI_DM644x && VIDEO_VPFE_CAPTURE
+	select VIDEO_VPSS_SYSTEM
+	default y
+	help
+	   Enables DaVinci CCD hw module. DaVinci CCDC hw interfaces
+	   with decoder modules such as TVP5146 over BT656 or
+	   sensor module such as MT9T001 over a raw interface. This
+	   module configures the interface and CCDC/ISIF to do
+	   video frame capture from slave decoders.
+
+	   To compile this driver as a module, choose M here: the
+	   module will be called vpfe.
+
+config VIDEO_DM355_CCDC
+	tristate "DM355 CCDC HW module"
+	depends on ARCH_DAVINCI_DM355 && VIDEO_VPFE_CAPTURE
+	select VIDEO_VPSS_SYSTEM
+	default y
+	help
+	   Enables DM355 CCD hw module. DM355 CCDC hw interfaces
+	   with decoder modules such as TVP5146 over BT656 or
+	   sensor module such as MT9T001 over a raw interface. This
+	   module configures the interface and CCDC/ISIF to do
+	   video frame capture from a slave decoders
+
+	   To compile this driver as a module, choose M here: the
+	   module will be called vpfe.
 
 source "drivers/media/video/bt8xx/Kconfig"
 
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 12ddb9a..76db635 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -10,8 +10,6 @@ stkwebcam-objs	:=	stk-webcam.o stk-sensor.o
 
 omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
 
-davinci-vpfe-objs   :=  ccdc_davinci.o davinci_vpfe.o
-
 videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o
 
 obj-$(CONFIG_VIDEO_DEV) += videodev.o v4l2-int-device.o
@@ -133,9 +131,6 @@ obj-$(CONFIG_USB_S2255)		+= s2255drv.o
 obj-$(CONFIG_VIDEO_IVTV) += ivtv/
 obj-$(CONFIG_VIDEO_CX18) += cx18/
 
-obj-$(CONFIG_VIDEO_DAVINCI)     += davinci-vpfe.o
-obj-$(CONFIG_VIDEO_TVP5146)     += tvp5146.o
-
 obj-$(CONFIG_VIDEO_VIVI) += vivi.o
 obj-$(CONFIG_VIDEO_CX23885) += cx23885/
 
@@ -152,6 +147,7 @@ obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
 obj-$(CONFIG_SOC_CAMERA_OV772X)		+= ov772x.o
 obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
 obj-$(CONFIG_SOC_CAMERA_TW9910)		+= tw9910.o
+obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
 
 obj-$(CONFIG_VIDEO_AU0828) += au0828/
 
diff --git a/drivers/media/video/davinci/Makefile b/drivers/media/video/davinci/Makefile
new file mode 100644
index 0000000..b84a405
--- /dev/null
+++ b/drivers/media/video/davinci/Makefile
@@ -0,0 +1,9 @@
+#
+# Makefile for the davinci video device drivers.
+#
+
+# Capture: DM6446 and DM355
+obj-$(CONFIG_VIDEO_VPSS_SYSTEM) += vpss.o
+obj-$(CONFIG_VIDEO_VPFE_CAPTURE) += vpfe_capture.o
+obj-$(CONFIG_VIDEO_DM6446_CCDC) += dm644x_ccdc.o
+obj-$(CONFIG_VIDEO_DM355_CCDC) += dm355_ccdc.o
-- 
1.6.0.4

