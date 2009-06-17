Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:53720 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759569AbZFQULa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 16:11:30 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id n5HKBS8p012953
	for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 15:11:33 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 6/11 - v3] Makefile and config files for vpfe capture driver
Date: Wed, 17 Jun 2009 16:11:19 -0400
Message-Id: <1245269484-8325-7-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1245269484-8325-6-git-send-email-m-karicheri2@ti.com>
References: <1245269484-8325-1-git-send-email-m-karicheri2@ti.com>
 <1245269484-8325-2-git-send-email-m-karicheri2@ti.com>
 <1245269484-8325-3-git-send-email-m-karicheri2@ti.com>
 <1245269484-8325-4-git-send-email-m-karicheri2@ti.com>
 <1245269484-8325-5-git-send-email-m-karicheri2@ti.com>
 <1245269484-8325-6-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

Makefile and config files for the driver

This adds Makefile and Kconfig changes to build vpfe capture driver.

No change in this version

Reviewed by: Hans Verkuil <hverkuil@xs4all.nl>
Reviewed by: Laurent Pinchart <laurent.pinchart@skynet.be>

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to v4l-dvb repository

 drivers/media/video/Kconfig          |   49 ++++++++++++++++++++++++++++++++++
 drivers/media/video/Makefile         |    2 +
 drivers/media/video/davinci/Makefile |    9 ++++++
 3 files changed, 60 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/davinci/Makefile

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 94f4405..8a1bd1c 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -497,6 +497,55 @@ config VIDEO_VIVI
 	  Say Y here if you want to test video apps or debug V4L devices.
 	  In doubt, say N.
 
+config VIDEO_VPSS_SYSTEM
+	tristate "VPSS System module driver"
+	depends on ARCH_DAVINCI
+	help
+	  Support for vpss system module for video driver
+	default y
+
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
+
 source "drivers/media/video/bt8xx/Kconfig"
 
 config VIDEO_PMS
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 7fb3add..1f28495 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -153,6 +153,8 @@ obj-$(CONFIG_VIDEO_MX3)			+= mx3_camera.o
 obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
 
+obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
+
 obj-$(CONFIG_VIDEO_AU0828) += au0828/
 
 obj-$(CONFIG_USB_VIDEO_CLASS)	+= uvc/
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

