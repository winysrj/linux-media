Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53857 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755900Ab3AEWxH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Jan 2013 17:53:07 -0500
Received: from localhost.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:6d9a::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id DEABB60099
	for <linux-media@vger.kernel.org>; Sun,  6 Jan 2013 00:53:00 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] v4l: Don't compile v4l2-int-device unless really needed
Date: Sun,  6 Jan 2013 00:56:10 +0200
Message-Id: <1357426570-9879-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a configuration option for v4l2-int-device so it is only compiled when
necessary, which is only by omap24xxcam and tcm825x drivers.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
The side effect of this patch is that there's a new config option in the
main media menu to select V4L2 int device. The drivers using it are hidden
unless the option is selected.

 drivers/media/i2c/Kconfig        |    2 +-
 drivers/media/platform/Kconfig   |    2 +-
 drivers/media/v4l2-core/Kconfig  |   11 +++++++++++
 drivers/media/v4l2-core/Makefile |    3 ++-
 4 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 24d78e2..1e4b2d0 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -477,7 +477,7 @@ config VIDEO_MT9V032
 
 config VIDEO_TCM825X
 	tristate "TCM825x camera sensor support"
-	depends on I2C && VIDEO_V4L2
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_INT_DEVICE
 	depends on MEDIA_CAMERA_SUPPORT
 	---help---
 	  This is a driver for the Toshiba TCM825x VGA camera sensor.
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 3dcfea6..0641ade 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -92,7 +92,7 @@ config VIDEO_M32R_AR_M64278
 
 config VIDEO_OMAP2
 	tristate "OMAP2 Camera Capture Interface driver"
-	depends on VIDEO_DEV && ARCH_OMAP2
+	depends on VIDEO_DEV && ARCH_OMAP2 && VIDEO_V4L2_INT_DEVICE
 	select VIDEOBUF_DMA_SG
 	---help---
 	  This is a v4l2 driver for the TI OMAP2 camera capture interface
diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index 65875c3..1f16110 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -82,3 +82,14 @@ config VIDEOBUF2_DMA_SG
 	#depends on HAS_DMA
 	select VIDEOBUF2_CORE
 	select VIDEOBUF2_MEMOPS
+
+config VIDEO_V4L2_INT_DEVICE
+	tristate "V4L2 int device (DEPRECATED)"
+	depends on VIDEO_V4L2
+	---help---
+	  An early framework for a hardware-independent interface for
+	  image sensors and bridges etc. Currently used by omap24xxcam and
+	  tcm825x drivers that should be converted to V4L2 subdev.
+
+	  Do not use for new developments.
+
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index c2d61d4..a9d3552 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -10,7 +10,8 @@ ifeq ($(CONFIG_COMPAT),y)
   videodev-objs += v4l2-compat-ioctl32.o
 endif
 
-obj-$(CONFIG_VIDEO_DEV) += videodev.o v4l2-int-device.o
+obj-$(CONFIG_VIDEO_DEV) += videodev.o
+obj-$(CONFIG_VIDEO_V4L2_INT_DEVICE) += v4l2-int-device.o
 obj-$(CONFIG_VIDEO_V4L2) += v4l2-common.o
 
 obj-$(CONFIG_VIDEO_TUNER) += tuner.o
-- 
1.7.10.4

