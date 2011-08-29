Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:39568 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791Ab1H2PH3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 11:07:29 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id p7TF7P7I010117
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 29 Aug 2011 10:07:28 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Nagabhushana Netagunte <nagabhushana.netagunte@ti.com>
Subject: [PATCH v2 8/8] davinci: vpfe: build infrastructure for dm365
Date: Mon, 29 Aug 2011 20:37:19 +0530
Message-ID: <1314630439-1122-9-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1314630439-1122-1-git-send-email-manjunath.hadli@ti.com>
References: <1314630439-1122-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add build infrastructure for dm365 specific modules
such as IPIPE, AEW, AF.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Nagabhushana Netagunte <nagabhushana.netagunte@ti.com>
---
 drivers/media/video/davinci/Kconfig  |   46 ++++++++++++++++++++++++++++++++-
 drivers/media/video/davinci/Makefile |   17 +++++++++++-
 2 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/davinci/Kconfig b/drivers/media/video/davinci/Kconfig
index 6b19540..6f6da53 100644
--- a/drivers/media/video/davinci/Kconfig
+++ b/drivers/media/video/davinci/Kconfig
@@ -11,6 +11,48 @@ config DISPLAY_DAVINCI_DM646X_EVM
 	  To compile this driver as a module, choose M here: the
 	  module will be called vpif_display.
 
+config VIDEO_DM365_3A_HW
+	tristate "DM365 Auto Focus, Auto Exposure/ White Balance HW module"
+	depends on ARCH_DAVINCI_DM365
+	help
+	  DM365 Auto Focus, Auto Exposure and Auto White Balancing HW module
+
+	  This module has functions which configure AEW/AF hardware, high level
+	  AF module and AEW module use these functionalities. It collects metrics
+	  about the image or video data
+
+config VIDEO_DM365_AF
+	tristate "DM365 Auto Focus Driver"
+	depends on ARCH_DAVINCI_DM365
+	select VIDEO_DM365_3A_HW
+	help
+	  DM365 Auto Focus hardware module.
+
+	  Auto Focus driver is used to support control loop for Auto Focus.
+	  It collects metrics about the image or video data. This provides
+	  hooks to AF subdevice driver.
+
+config VIDEO_DM365_AEW
+	tristate "DM365 Auto exposure /White Balance Driver"
+	depends on ARCH_DAVINCI_DM365
+	select VIDEO_DM365_3A_HW
+	help
+	  DM365 Auto Exposure and Auto White Balance hardware module.
+
+	  This is used to support the control loops for Auto Exposure
+	  and Auto White Balance. It collects metrics about the image
+	  or video data
+
+config DM365_IPIPE
+	depends on ARCH_DAVINCI && ARCH_DAVINCI_DM365
+	tristate "DM365 IPIPE"
+	help
+	  dm365 IPIPE hardware module.
+
+	  This is the hardware module that implements imp_hw_interface
+	  for DM365. This hardware module provides previewer and resizer
+	  functionality for image processing.
+
 config CAPTURE_DAVINCI_DM646X_EVM
 	tristate "DM646x EVM Video Capture"
 	depends on VIDEO_DEV && MACH_DAVINCI_DM6467_EVM
@@ -51,7 +93,7 @@ config VIDEO_VPFE_CAPTURE
 
 config VIDEO_DM6446_CCDC
 	tristate "DM6446 CCDC HW module"
-	depends on VIDEO_VPFE_CAPTURE
+	depends on VIDEO_VPFE_CAPTURE && ARCH_DAVINCI_DM644x
 	select VIDEO_VPSS_SYSTEM
 	default y
 	help
@@ -80,7 +122,7 @@ config VIDEO_DM355_CCDC
 	   module will be called vpfe.
 
 config VIDEO_ISIF
-	tristate "ISIF HW module"
+	tristate "DM365 ISIF HW module"
 	depends on ARCH_DAVINCI_DM365 && VIDEO_VPFE_CAPTURE
 	select VIDEO_VPSS_SYSTEM
 	default y
diff --git a/drivers/media/video/davinci/Makefile b/drivers/media/video/davinci/Makefile
index a379557..8544040 100644
--- a/drivers/media/video/davinci/Makefile
+++ b/drivers/media/video/davinci/Makefile
@@ -12,7 +12,20 @@ obj-$(CONFIG_CAPTURE_DAVINCI_DM646X_EVM) += vpif_capture.o
 
 # Capture: DM6446 and DM355
 obj-$(CONFIG_VIDEO_VPSS_SYSTEM) += vpss.o
-obj-$(CONFIG_VIDEO_VPFE_CAPTURE) += vpfe_capture.o
+obj-$(CONFIG_VIDEO_VPFE_CAPTURE) += vpfe_capture.o vpfe_ccdc.o \
+                                       vpfe_resizer.o vpfe_previewer.o \
+                                       vpfe_aew.o vpfe_af.o vpfe_video.o
 obj-$(CONFIG_VIDEO_DM6446_CCDC) += dm644x_ccdc.o
 obj-$(CONFIG_VIDEO_DM355_CCDC) += dm355_ccdc.o
-obj-$(CONFIG_VIDEO_ISIF) += isif.o
+obj-$(CONFIG_VIDEO_ISIF) += dm365_ccdc.o
+
+dm365_a3_hw_driver-objs := dm365_a3_hw.o
+obj-$(CONFIG_VIDEO_DM365_3A_HW) += dm365_a3_hw_driver.o
+dm365_af_driver-objs := dm365_af.o
+obj-$(CONFIG_VIDEO_DM365_AF)    += dm365_af_driver.o
+dm365_aew_driver-objs := dm365_aew.o
+obj-$(CONFIG_VIDEO_DM365_AEW)   += dm365_aew_driver.o
+
+dm365_imp-objs                  := dm365_ipipe.o dm365_def_para.o \
+                                        dm365_ipipe_hw.o dm3xx_ipipeif.o
+obj-$(CONFIG_DM365_IPIPE)       += dm365_imp.o
-- 
1.6.2.4

