Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:58486 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932291Ab1ETNsu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 09:48:50 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id p4KDml3B011989
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 20 May 2011 08:48:49 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v17 5/6] davinci vpbe: Build infrastructure for VPBE driver
Date: Fri, 20 May 2011 19:18:44 +0530
Message-ID: <1305899324-2118-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds the build infra-structure for Davinci
VPBE dislay driver.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/davinci/Kconfig  |   22 ++++++++++++++++++++++
 drivers/media/video/davinci/Makefile |    2 ++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/davinci/Kconfig b/drivers/media/video/davinci/Kconfig
index 6b19540..a7f11e7 100644
--- a/drivers/media/video/davinci/Kconfig
+++ b/drivers/media/video/davinci/Kconfig
@@ -91,3 +91,25 @@ config VIDEO_ISIF
 
 	   To compile this driver as a module, choose M here: the
 	   module will be called vpfe.
+
+config VIDEO_DM644X_VPBE
+	tristate "DM644X VPBE HW module"
+	select VIDEO_VPSS_SYSTEM
+	select VIDEOBUF_DMA_CONTIG
+	help
+	    Enables VPBE modules used for display on a DM644x
+	    SoC.
+
+	    To compile this driver as a module, choose M here: the
+	    module will be called vpbe.
+
+
+config VIDEO_VPBE_DISPLAY
+	tristate "VPBE V4L2 Display driver"
+	select VIDEO_DM644X_VPBE
+	default y
+	help
+	    Enables VPBE V4L2 Display driver on a DMXXX device
+
+	    To compile this driver as a module, choose M here: the
+	    module will be called vpbe_display.
diff --git a/drivers/media/video/davinci/Makefile b/drivers/media/video/davinci/Makefile
index a379557..ae7dafb 100644
--- a/drivers/media/video/davinci/Makefile
+++ b/drivers/media/video/davinci/Makefile
@@ -16,3 +16,5 @@ obj-$(CONFIG_VIDEO_VPFE_CAPTURE) += vpfe_capture.o
 obj-$(CONFIG_VIDEO_DM6446_CCDC) += dm644x_ccdc.o
 obj-$(CONFIG_VIDEO_DM355_CCDC) += dm355_ccdc.o
 obj-$(CONFIG_VIDEO_ISIF) += isif.o
+obj-$(CONFIG_VIDEO_DM644X_VPBE) += vpbe.o vpbe_osd.o vpbe_venc.o
+obj-$(CONFIG_VIDEO_VPBE_DISPLAY) += vpbe_display.o
-- 
1.6.2.4

