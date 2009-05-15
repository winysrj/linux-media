Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:43079 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbZEOSiO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 14:38:14 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id n4FIcAa9008738
	for <linux-media@vger.kernel.org>; Fri, 15 May 2009 13:38:15 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 6/9] Makefile and config files for vpfe capture driver
Date: Fri, 15 May 2009 14:38:09 -0400
Message-Id: <1242412689-11484-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>

Makefile and config files for the driver

This adds Makefile and Kconfig changes to build vpfe capture driver.

This has comments incorporated from previous review.

Reviewed By "Hans Verkuil".
Reviewed By "Laurent Pinchart".

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to v4l-dvb repository

 drivers/media/video/Kconfig          |   40 ++++++++++++++++++++++++++++++++++
 drivers/media/video/Makefile         |    1 +
 drivers/media/video/davinci/Makefile |    8 ++++++
 3 files changed, 49 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/davinci/Makefile

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 9d48da2..49fbb8d 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -479,6 +479,46 @@ config VIDEO_VIVI
 	  Say Y here if you want to test video apps or debug V4L devices.
 	  In doubt, say N.
 
+config VIDEO_VPFE_CAPTURE
+	tristate "VPFE Video Capture Driver"
+	depends on VIDEO_V4L2 && ARCH_DAVINCI
+	select VIDEOBUF_DMA_CONTIG
+	help
+	  Support for DMXXXX VPFE based frame grabber. This is the
+	  common V4L2 module for following DMXXX SoCs from Texas
+	  Instruments:- DM6446 & DM355.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called vpfe-capture.
+
+config VIDEO_DM6446_CCDC
+	tristate "DM6446 CCDC HW module"
+	depends on ARCH_DAVINCI_DM644x && VIDEO_VPFE_CAPTURE
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
+
 source "drivers/media/video/bt8xx/Kconfig"
 
 config VIDEO_PMS
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 3f1a035..bc8ac8e 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -147,6 +147,7 @@ obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
 obj-$(CONFIG_SOC_CAMERA_OV772X)		+= ov772x.o
 obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
 obj-$(CONFIG_SOC_CAMERA_TW9910)		+= tw9910.o
+obj-$(CONFIG_ARCH_DAVINCI)        += davinci/
 
 obj-$(CONFIG_VIDEO_AU0828) += au0828/
 
diff --git a/drivers/media/video/davinci/Makefile b/drivers/media/video/davinci/Makefile
new file mode 100644
index 0000000..d0b4b41
--- /dev/null
+++ b/drivers/media/video/davinci/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile for the davinci video device drivers.
+#
+
+# Capture: DM6446 and DM355
+obj-$(CONFIG_VIDEO_VPFE_CAPTURE) += vpfe_capture.o
+obj-$(CONFIG_VIDEO_DM6446_CCDC) += dm644x_ccdc.o
+obj-$(CONFIG_VIDEO_DM355_CCDC) += dm355_ccdc.o
-- 
1.6.0.4

