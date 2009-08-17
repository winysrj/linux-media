Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:52685 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343AbZHQTer (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2009 15:34:47 -0400
From: neilsikka@ti.com
To: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
Cc: khilman@deeprootsystems.com, hverkuil@xs4all.nl,
	Neil Sikka <neilsikka@ti.com>
Subject: [PATCH] Build system support for DM365 CCDC
Date: Mon, 17 Aug 2009 15:34:39 -0400
Message-Id: <1250537679-2239-5-git-send-email-neilsikka@ti.com>
In-Reply-To: <1250537679-2239-4-git-send-email-neilsikka@ti.com>
References: <1250537679-2239-1-git-send-email-neilsikka@ti.com>
 <1250537679-2239-2-git-send-email-neilsikka@ti.com>
 <1250537679-2239-3-git-send-email-neilsikka@ti.com>
 <1250537679-2239-4-git-send-email-neilsikka@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Neil Sikka <neilsikka@ti.com>

This patch sets up the build system for DM365 VPFE support

Reviewed-by: Muralidharan Karicheri <m-karicheri2@ti.com>
Mandatory-Reviewer: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Neil Sikka <neilsikka@ti.com>
---
Applies to v4l-dvb linux-next repository
 drivers/media/video/Kconfig          |    9 +++++++++
 drivers/media/video/davinci/Makefile |    3 ++-
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 1fa3c87..e0dd402 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -578,6 +578,15 @@ config VIDEO_DM355_CCDC
 	   To compile this driver as a module, choose M here: the
 	   module will be called vpfe.
 
+config VIDEO_DM365_ISIF
+	tristate "DM365 CCDC/ISIF HW module"
+	depends on ARCH_DAVINCI_DM365 && VIDEO_VPFE_CAPTURE
+	default y
+	help
+	   Enables DM365 ISIF hw module. This is the hardware module for
+	   configuring ISIF in VPFE to capture Raw Bayer RGB data  from
+	   a image sensor or YUV data from a YUV source.
+
 source "drivers/media/video/bt8xx/Kconfig"
 
 config VIDEO_PMS
diff --git a/drivers/media/video/davinci/Makefile b/drivers/media/video/davinci/Makefile
index f44cad2..5f4c830 100644
--- a/drivers/media/video/davinci/Makefile
+++ b/drivers/media/video/davinci/Makefile
@@ -8,8 +8,9 @@ obj-$(CONFIG_VIDEO_DAVINCI_VPIF) += vpif.o
 #DM646x EVM Display driver
 obj-$(CONFIG_DISPLAY_DAVINCI_DM646X_EVM) += vpif_display.o
 
-# Capture: DM6446 and DM355
+# Capture: DM6446, DM355, DM365
 obj-$(CONFIG_VIDEO_VPSS_SYSTEM) += vpss.o
 obj-$(CONFIG_VIDEO_VPFE_CAPTURE) += vpfe_capture.o
 obj-$(CONFIG_VIDEO_DM6446_CCDC) += dm644x_ccdc.o
 obj-$(CONFIG_VIDEO_DM355_CCDC) += dm355_ccdc.o
+obj-$(CONFIG_VIDEO_DM365_ISIF) += dm365_ccdc.o
-- 
1.6.0.4

