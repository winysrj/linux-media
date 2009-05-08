Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:51181 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944AbZEHN6B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2009 09:58:01 -0400
Received: from dflp53.itg.ti.com ([128.247.5.6])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id n48Dvv0q028196
	for <linux-media@vger.kernel.org>; Fri, 8 May 2009 08:58:02 -0500
From: Chaithrika U S <chaithrika@ti.com>
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Chaithrika U S <chaithrika@ti.com>,
	Manjunath Hadli <mrh@ti.com>, Brijesh Jadav <brijesh.j@ti.com>
Subject: [PATCH v3 4/4] ARM: DaVinci: DM646x Video:  Makefile and config files modifications for Display
Date: Fri,  8 May 2009 09:26:44 -0400
Message-Id: <1241789204-23433-1-git-send-email-chaithrika@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Makefile and Kconfig changes

Modifies and adds the video Makefiles and Kconfig files to support DM646x Video
display device

Signed-off-by: Manjunath Hadli <mrh@ti.com>
Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
Signed-off-by: Chaithrika U S <chaithrika@ti.com>
---
Applies v4l-dvb repository

 drivers/media/video/Kconfig          |   22 ++++++++++++++++++++++
 drivers/media/video/Makefile         |    2 ++
 drivers/media/video/davinci/Makefile |    9 +++++++++
 3 files changed, 33 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/davinci/Makefile

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 9d48da2..6f0c6d2 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -467,6 +467,28 @@ config VIDEO_UPD64083
 
 endmenu # encoder / decoder chips
 
+config DISPLAY_DAVINCI_DM646X_EVM
+        tristate "DM646x EVM Video Display"
+        depends on VIDEO_DEV && MACH_DAVINCI_DM6467_EVM
+        select VIDEOBUF_DMA_CONTIG
+        select VIDEO_DAVINCI_VPIF
+        select VIDEO_ADV7343
+        select VIDEO_THS7303
+        help
+          Support for DaVinci based display device.
+
+          To compile this driver as a module, choose M here: the
+          module will be called davincihd_display.
+
+config VIDEO_DAVINCI_VPIF
+        tristate "DaVinci VPIF Driver"
+        depends on DISPLAY_DAVINCI_DM646X_EVM
+        help
+          Support for DaVinci VPIF Driver.
+
+          To compile this driver as a module, choose M here: the
+          module will be called vpif.
+
 config VIDEO_VIVI
 	tristate "Virtual Video Driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 7aefac6..d9ceb2c 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -153,6 +153,8 @@ obj-$(CONFIG_VIDEO_AU0828) += au0828/
 
 obj-$(CONFIG_USB_VIDEO_CLASS)	+= uvc/
 
+obj-$(CONFIG_ARCH_DAVINCI)	+= davinci/
+
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
 EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
 EXTRA_CFLAGS += -Idrivers/media/common/tuners
diff --git a/drivers/media/video/davinci/Makefile b/drivers/media/video/davinci/Makefile
new file mode 100644
index 0000000..7fe9bce
--- /dev/null
+++ b/drivers/media/video/davinci/Makefile
@@ -0,0 +1,9 @@
+#
+# Makefile for the davinci video device drivers.
+#
+
+# VPIF
+obj-$(CONFIG_VIDEO_DAVINCI_VPIF) += vpif.o
+
+#DM646x EVM Display driver
+obj-$(CONFIG_DISPLAY_DAVINCI_DM646X_EVM) += vpif_display.o
-- 
1.5.6

