Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:54244 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822Ab0E0NLe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 09:11:34 -0400
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, m-karicheri2@ti.com,
	linux-omap@vger.kernel.org, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 1/2] Davinci: Create seperate Kconfig file for davinci devices
Date: Thu, 27 May 2010 18:41:15 +0530
Message-Id: <1274965876-21845-2-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

Currently VPFE Capture driver and DM6446 CCDC driver is being
reused for AM3517. So this patch is preparing the Kconfig/makefile
for re-use of such IP's.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/Kconfig         |   61 +----------------------
 drivers/media/video/Makefile        |    2 +-
 drivers/media/video/davinci/Kconfig |   93 +++++++++++++++++++++++++++++++++++
 3 files changed, 95 insertions(+), 61 deletions(-)
 create mode 100644 drivers/media/video/davinci/Kconfig

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index ad9e6f9..e5d74ae 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -570,66 +570,7 @@ config VIDEO_VIVI
 	  Say Y here if you want to test video apps or debug V4L devices.
 	  In doubt, say N.
 
-config VIDEO_VPSS_SYSTEM
-	tristate "VPSS System module driver"
-	depends on ARCH_DAVINCI
-	help
-	  Support for vpss system module for video driver
-
-config VIDEO_VPFE_CAPTURE
-	tristate "VPFE Video Capture Driver"
-	depends on VIDEO_V4L2 && ARCH_DAVINCI
-	select VIDEOBUF_DMA_CONTIG
-	help
-	  Support for DMXXXX VPFE based frame grabber. This is the
-	  common V4L2 module for following DMXXX SoCs from Texas
-	  Instruments:- DM6446 & DM355.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called vpfe-capture.
-
-config VIDEO_DM6446_CCDC
-	tristate "DM6446 CCDC HW module"
-	depends on ARCH_DAVINCI_DM644x && VIDEO_VPFE_CAPTURE
-	select VIDEO_VPSS_SYSTEM
-	default y
-	help
-	   Enables DaVinci CCD hw module. DaVinci CCDC hw interfaces
-	   with decoder modules such as TVP5146 over BT656 or
-	   sensor module such as MT9T001 over a raw interface. This
-	   module configures the interface and CCDC/ISIF to do
-	   video frame capture from slave decoders.
-
-	   To compile this driver as a module, choose M here: the
-	   module will be called vpfe.
-
-config VIDEO_DM355_CCDC
-	tristate "DM355 CCDC HW module"
-	depends on ARCH_DAVINCI_DM355 && VIDEO_VPFE_CAPTURE
-	select VIDEO_VPSS_SYSTEM
-	default y
-	help
-	   Enables DM355 CCD hw module. DM355 CCDC hw interfaces
-	   with decoder modules such as TVP5146 over BT656 or
-	   sensor module such as MT9T001 over a raw interface. This
-	   module configures the interface and CCDC/ISIF to do
-	   video frame capture from a slave decoders
-
-	   To compile this driver as a module, choose M here: the
-	   module will be called vpfe.
-
-config VIDEO_ISIF
-	tristate "ISIF HW module"
-	depends on ARCH_DAVINCI_DM365 && VIDEO_VPFE_CAPTURE
-	select VIDEO_VPSS_SYSTEM
-	default y
-	help
-	   Enables ISIF hw module. This is the hardware module for
-	   configuring ISIF in VPFE to capture Raw Bayer RGB data  from
-	   a image sensor or YUV data from a YUV source.
-
-	   To compile this driver as a module, choose M here: the
-	   module will be called vpfe.
+source "drivers/media/video/davinci/Kconfig"
 
 source "drivers/media/video/omap/Kconfig"
 
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index cc93859..aa1ea2f 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -177,7 +177,7 @@ obj-$(CONFIG_VIDEO_SAA7164)     += saa7164/
 
 obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
 
-obj-$(CONFIG_ARCH_DAVINCI)	+= davinci/
+obj-y	+= davinci/
 
 obj-$(CONFIG_ARCH_OMAP)	+= omap/
 
diff --git a/drivers/media/video/davinci/Kconfig b/drivers/media/video/davinci/Kconfig
new file mode 100644
index 0000000..97f889d
--- /dev/null
+++ b/drivers/media/video/davinci/Kconfig
@@ -0,0 +1,93 @@
+config DISPLAY_DAVINCI_DM646X_EVM
+	tristate "DM646x EVM Video Display"
+	depends on VIDEO_DEV && MACH_DAVINCI_DM6467_EVM
+	select VIDEOBUF_DMA_CONTIG
+	select VIDEO_DAVINCI_VPIF
+	select VIDEO_ADV7343
+	select VIDEO_THS7303
+	help
+	  Support for DM6467 based display device.
+
+	  To compile this driver as a module, choose M here: the
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
+
+config VIDEO_DAVINCI_VPIF
+	tristate "DaVinci VPIF Driver"
+	depends on DISPLAY_DAVINCI_DM646X_EVM
+	help
+	  Support for DaVinci VPIF Driver.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called vpif.
+
+config VIDEO_VPSS_SYSTEM
+	tristate "VPSS System module driver"
+	depends on ARCH_DAVINCI
+	help
+	  Support for vpss system module for video driver
+
+config VIDEO_VPFE_CAPTURE
+	tristate "VPFE Video Capture Driver"
+	depends on VIDEO_V4L2 && (ARCH_DAVINCI || ARCH_OMAP3)
+	select VIDEOBUF_DMA_CONTIG
+	help
+	  Support for DMx/AMx VPFE based frame grabber. This is the
+	  common V4L2 module for following DMx/AMx SoCs from Texas
+	  Instruments:- DM6446, DM355 & AM3517/05.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called vpfe-capture.
+
+config VIDEO_DM6446_CCDC
+	tristate "DM6446 CCDC HW module"
+	depends on VIDEO_VPFE_CAPTURE
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
+config VIDEO_ISIF
+	tristate "ISIF HW module"
+	depends on ARCH_DAVINCI_DM365 && VIDEO_VPFE_CAPTURE
+	select VIDEO_VPSS_SYSTEM
+	default y
+	help
+	   Enables ISIF hw module. This is the hardware module for
+	   configuring ISIF in VPFE to capture Raw Bayer RGB data  from
+	   a image sensor or YUV data from a YUV source.
+
+	   To compile this driver as a module, choose M here: the
+	   module will be called vpfe.
-- 
1.6.2.4

