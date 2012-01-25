Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:40591 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab2AYPFl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 10:05:41 -0500
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id q0PF5dY4020855
	for <linux-media@vger.kernel.org>; Wed, 25 Jan 2012 09:05:40 -0600
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH 4/4] davinci: da850: add build configuration for vpif drivers
Date: Wed, 25 Jan 2012 20:35:34 +0530
Message-ID: <1327503934-28186-5-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1327503934-28186-1-git-send-email-manjunath.hadli@ti.com>
References: <1327503934-28186-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add build configuration for da850/omapl-138 for vpif
capture and display drivers.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/video/davinci/Kconfig  |   26 +++++++++++++++++++++++++-
 drivers/media/video/davinci/Makefile |    5 +++++
 2 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/davinci/Kconfig b/drivers/media/video/davinci/Kconfig
index 60a456e..a0b0fb3 100644
--- a/drivers/media/video/davinci/Kconfig
+++ b/drivers/media/video/davinci/Kconfig
@@ -22,9 +22,33 @@ config CAPTURE_DAVINCI_DM646X_EVM
 	  To compile this driver as a module, choose M here: the
 	  module will be called vpif_capture.
 
+config DISPLAY_DAVINCI_DA850_EVM
+	tristate "DA850/OMAPL138 EVM Video Display"
+	depends on DA850_UI_SD_VIDEO_PORT && VIDEO_DEV && MACH_DAVINCI_DA850_EVM
+	select VIDEOBUF_DMA_CONTIG
+	select VIDEO_DAVINCI_VPIF
+	select VIDEO_ADV7343
+	select VIDEO_THS7303
+	help
+	  Support for DA850/OMAP-L138/AM18xx  based display device.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called vpif_display.
+
+config CAPTURE_DAVINCI_DA850_EVM
+	tristate "DA850/OMAPL138 EVM Video Capture"
+	depends on DA850_UI_SD_VIDEO_PORT && VIDEO_DEV && MACH_DAVINCI_DA850_EVM
+	select VIDEOBUF_DMA_CONTIG
+	select VIDEO_DAVINCI_VPIF
+	help
+	  Support for DA850/OMAP-L138/AM18xx  based capture device.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called vpif_capture.
+
 config VIDEO_DAVINCI_VPIF
 	tristate "DaVinci VPIF Driver"
-	depends on DISPLAY_DAVINCI_DM646X_EVM
+	depends on DISPLAY_DAVINCI_DM646X_EVM || DISPLAY_DAVINCI_DA850_EVM
 	help
 	  Support for DaVinci VPIF Driver.
 
diff --git a/drivers/media/video/davinci/Makefile b/drivers/media/video/davinci/Makefile
index ae7dafb..2c7cfb0 100644
--- a/drivers/media/video/davinci/Makefile
+++ b/drivers/media/video/davinci/Makefile
@@ -10,6 +10,11 @@ obj-$(CONFIG_DISPLAY_DAVINCI_DM646X_EVM) += vpif_display.o
 #DM646x EVM Capture driver
 obj-$(CONFIG_CAPTURE_DAVINCI_DM646X_EVM) += vpif_capture.o
 
+#DA850 EVM Display driver
+obj-$(CONFIG_DISPLAY_DAVINCI_DA850_EVM) += vpif_display.o
+#DA850 EVM Capture driver
+obj-$(CONFIG_CAPTURE_DAVINCI_DA850_EVM) += vpif_capture.o
+
 # Capture: DM6446 and DM355
 obj-$(CONFIG_VIDEO_VPSS_SYSTEM) += vpss.o
 obj-$(CONFIG_VIDEO_VPFE_CAPTURE) += vpfe_capture.o
-- 
1.6.2.4

