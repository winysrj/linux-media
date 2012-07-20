Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63772 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab2GTOEX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 10:04:23 -0400
Received: by yhmm54 with SMTP id m54so3981736yhm.19
        for <linux-media@vger.kernel.org>; Fri, 20 Jul 2012 07:04:23 -0700 (PDT)
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH] davinci: vpbe: add build infrastructure for VPBE on dm365 and dm355
Date: Fri, 20 Jul 2012 19:34:12 +0530
Message-Id: <1342793052-16481-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Manjunath Hadli <manjunath.hadli@ti.com>

add Kconfig and Makefile changes to build VPBE display
driver on dm365 and dm355 along with dm644x.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/video/davinci/Kconfig  |   12 ++++++------
 drivers/media/video/davinci/Makefile |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/davinci/Kconfig b/drivers/media/video/davinci/Kconfig
index 9337b56..7fd125d 100644
--- a/drivers/media/video/davinci/Kconfig
+++ b/drivers/media/video/davinci/Kconfig
@@ -93,13 +93,13 @@ config VIDEO_ISIF
 	   To compile this driver as a module, choose M here: the
 	   module will be called vpfe.
 
-config VIDEO_DM644X_VPBE
-	tristate "DM644X VPBE HW module"
-	depends on ARCH_DAVINCI_DM644x
+config VIDEO_DAVINCI_VPBE
+	tristate "DAVINCI VPBE HW module"
+	depends on ARCH_DAVINCI_DM644x || ARCH_DAVINCI_DM365 || ARCH_DAVINCI_DM355
 	select VIDEO_VPSS_SYSTEM
 	select VIDEOBUF_DMA_CONTIG
 	help
-	    Enables VPBE modules used for display on a DM644x
+	    Enables VPBE modules used for display on a DM644x, DM365, DM355
 	    SoC.
 
 	    To compile this driver as a module, choose M here: the
@@ -108,10 +108,10 @@ config VIDEO_DM644X_VPBE
 
 config VIDEO_VPBE_DISPLAY
 	tristate "VPBE V4L2 Display driver"
-	depends on ARCH_DAVINCI_DM644x
+	depends on ARCH_DAVINCI_DM644x || ARCH_DAVINCI_DM365 || ARCH_DAVINCI_DM355
 	select VIDEO_DM644X_VPBE
 	help
-	    Enables VPBE V4L2 Display driver on a DM644x device
+	    Enables VPBE V4L2 Display driver on a DM644x, DM365, DM355 device
 
 	    To compile this driver as a module, choose M here: the
 	    module will be called vpbe_display.
diff --git a/drivers/media/video/davinci/Makefile b/drivers/media/video/davinci/Makefile
index ae7dafb..3057822 100644
--- a/drivers/media/video/davinci/Makefile
+++ b/drivers/media/video/davinci/Makefile
@@ -16,5 +16,5 @@ obj-$(CONFIG_VIDEO_VPFE_CAPTURE) += vpfe_capture.o
 obj-$(CONFIG_VIDEO_DM6446_CCDC) += dm644x_ccdc.o
 obj-$(CONFIG_VIDEO_DM355_CCDC) += dm355_ccdc.o
 obj-$(CONFIG_VIDEO_ISIF) += isif.o
-obj-$(CONFIG_VIDEO_DM644X_VPBE) += vpbe.o vpbe_osd.o vpbe_venc.o
+obj-$(CONFIG_VIDEO_DAVINCI_VPBE) += vpbe.o vpbe_osd.o vpbe_venc.o
 obj-$(CONFIG_VIDEO_VPBE_DISPLAY) += vpbe_display.o
-- 
1.7.4.1

