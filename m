Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58186 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab1BNMWB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:22:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v6 10/10] omap3isp: Kconfig and Makefile
Date: Mon, 14 Feb 2011 13:21:37 +0100
Message-Id: <1297686097-9804-11-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add the OMAP3 ISP driver to the kernel build system.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/Kconfig            |   13 +++++++++++++
 drivers/media/video/Makefile           |    2 ++
 drivers/media/video/omap3-isp/Makefile |   13 +++++++++++++
 include/linux/Kbuild                   |    1 +
 4 files changed, 29 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/omap3-isp/Makefile

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index aa02160..9cf7153 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -718,6 +718,19 @@ config VIDEO_VIA_CAMERA
 	   Chrome9 chipsets.  Currently only tested on OLPC xo-1.5 systems
 	   with ov7670 sensors.
 
+config VIDEO_OMAP3
+	tristate "OMAP 3 Camera support (EXPERIMENTAL)"
+	select OMAP_IOMMU
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3 && EXPERIMENTAL
+	---help---
+	  Driver for an OMAP 3 camera controller.
+
+config VIDEO_OMAP3_DEBUG
+	bool "OMAP 3 Camera debug messages"
+	depends on VIDEO_OMAP3
+	---help---
+	  Enable debug messages on OMAP 3 camera controller driver.
+
 config SOC_CAMERA
 	tristate "SoC camera support"
 	depends on VIDEO_V4L2 && HAS_DMA && I2C
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 35c774d..727b9a8 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -121,6 +121,8 @@ obj-$(CONFIG_VIDEO_CAFE_CCIC) += cafe_ccic.o
 
 obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
 
+obj-$(CONFIG_VIDEO_OMAP3)	+= omap3-isp/
+
 obj-$(CONFIG_USB_ZR364XX)       += zr364xx.o
 obj-$(CONFIG_USB_STKWEBCAM)     += stkwebcam.o
 
diff --git a/drivers/media/video/omap3-isp/Makefile b/drivers/media/video/omap3-isp/Makefile
new file mode 100644
index 0000000..b1b34477
--- /dev/null
+++ b/drivers/media/video/omap3-isp/Makefile
@@ -0,0 +1,13 @@
+# Makefile for OMAP3 ISP driver
+
+ifdef CONFIG_VIDEO_OMAP3_DEBUG
+EXTRA_CFLAGS += -DDEBUG
+endif
+
+omap3-isp-objs += \
+	isp.o ispqueue.o ispvideo.o \
+	ispcsiphy.o ispccp2.o ispcsi2.o \
+	ispccdc.o isppreview.o ispresizer.o \
+	ispstat.o isph3a_aewb.o isph3a_af.o isphist.o
+
+obj-$(CONFIG_VIDEO_OMAP3) += omap3-isp.o
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 19530c6..e879c1b 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -276,6 +276,7 @@ header-y += nfsacl.h
 header-y += nl80211.h
 header-y += nubus.h
 header-y += nvram.h
+header-y += omap3isp.h
 header-y += omapfb.h
 header-y += oom.h
 header-y += param.h
-- 
1.7.3.4

