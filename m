Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:60689 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756428AbZHFXGZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Aug 2009 19:06:25 -0400
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com, hverkuil@xs4all.nl,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v0 5/5] V4L: vpif capture - Kconfig and Makefile changes
Date: Thu,  6 Aug 2009 19:06:20 -0400
Message-Id: <1249599980-21832-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

Adds Kconfig and Makefile changes required for vpif capture driver

Mandatory reviewer: Hans Verkuil <hverkuil@xs4all.nl>

NOTE: This is only for review. Final patch for merge will be
sent later. This patch is dependent on the patch from Chaithrika for vpif display

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
 drivers/media/video/Kconfig          |   15 +++++++++++++--
 drivers/media/video/davinci/Makefile |    2 ++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 8460013..f3feb6b 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -501,10 +501,21 @@ config DISPLAY_DAVINCI_DM646X_EVM
 	select VIDEO_ADV7343
 	select VIDEO_THS7303
 	help
-	  Support for DaVinci based display device.
+	  Support for DM6467 based display device.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called davincihd_display.
+	  module will be called vpif_display.
+
+config CAPTURE_DAVINCI_DM646X_EVM
+	tristate "DM646x EVM Video Capture"
+	depends on VIDEO_DEV && MACH_DAVINCI_DM6467_EVM
+	select VIDEOBUF_DMA_CONTIG
+	select VIDEO_DAVINCI_VPIF
+	help
+	  Support for DM6467 based capture device.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called vpif_capture.
 
 config VIDEO_DAVINCI_VPIF
 	tristate "DaVinci VPIF Driver"
diff --git a/drivers/media/video/davinci/Makefile b/drivers/media/video/davinci/Makefile
index f44cad2..1a8b8f3 100644
--- a/drivers/media/video/davinci/Makefile
+++ b/drivers/media/video/davinci/Makefile
@@ -7,6 +7,8 @@ obj-$(CONFIG_VIDEO_DAVINCI_VPIF) += vpif.o
 
 #DM646x EVM Display driver
 obj-$(CONFIG_DISPLAY_DAVINCI_DM646X_EVM) += vpif_display.o
+#DM646x EVM Capture driver
+obj-$(CONFIG_CAPTURE_DAVINCI_DM646X_EVM) += vpif_capture.o
 
 # Capture: DM6446 and DM355
 obj-$(CONFIG_VIDEO_VPSS_SYSTEM) += vpss.o
-- 
1.6.0.4

