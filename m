Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:47525 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757574AbZCMKX3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 06:23:29 -0400
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id n2DANIZS019973
	for <linux-media@vger.kernel.org>; Fri, 13 Mar 2009 05:23:24 -0500
From: chaithrika@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Chaithrika U S <chaithrika@ti.com>
Subject: [RFC 5/7] ARM: DaVinci: DM646x Video:  Makefile and config files modifications for Display
Date: Fri, 13 Mar 2009 14:32:03 +0530
Message-Id: <1236934923-32216-1-git-send-email-chaithrika@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Chaithrika U S <chaithrika@ti.com>

Makefile and Kconfig changes

Modifies and adds the video Makefiles and Kconfig files to support DM646x Video
display device

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
---
Applies to v4l-dvb repository located at
http://linuxtv.org/hg/v4l-dvb/rev/1fd54a62abde

 drivers/media/video/Kconfig          |   22 ++++++++++++++++++++++
 drivers/media/video/Makefile         |    2 ++
 drivers/media/video/davinci/Makefile |    9 +++++++++
 3 files changed, 33 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/davinci/Makefile

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index b3b591d..9d3c0c7 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -471,6 +471,28 @@ config VIDEO_UPD64083
 
 endmenu # encoder / decoder chips
 
+config DISPLAY_DAVINCI_DM646X_EVM
+        tristate "DM646x EVM Video Display"
+        depends on VIDEO_DEV && MACH_DAVINCI_DM646X_EVM
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
index 1ed9c2c..7f0b7dc 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -151,6 +151,8 @@ obj-$(CONFIG_VIDEO_AU0828) += au0828/
 
 obj-$(CONFIG_USB_VIDEO_CLASS)	+= uvc/
 
+obj-$(CONFIG_ARCH_DAVINCI)	+= davinci/
+
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
 EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
 EXTRA_CFLAGS += -Idrivers/media/common/tuners
diff --git a/drivers/media/video/davinci/Makefile b/drivers/media/video/davinci/Makefile
new file mode 100644
index 0000000..5134585
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
+obj-$(CONFIG_DISPLAY_DAVINCI_DM646X_EVM) += dm646x_display.o
-- 
1.5.6

