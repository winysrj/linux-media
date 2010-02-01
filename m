Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:41906 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895Ab0BAW1X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2010 17:27:23 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org, khilman@deeprootsystems.com
Cc: hverkuil@xs4all.nl, davinci-linux-open-source@linux.davincidsp.com,
	Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v3 5/6] V4L - vpfe capture - build environment for isif driver
Date: Mon,  1 Feb 2010 17:27:14 -0500
Message-Id: <1265063238-29072-2-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1265063238-29072-1-git-send-email-m-karicheri2@ti.com>
References: <1265063238-29072-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Murali Karicheri <m-karicheri2@ti.com>

Adding Makefile and Kconfig for ISIF driver

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
Reviewed-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
Applies to linux-next tree
 - rebasing to latest tree for merge (v3)
 drivers/media/video/Kconfig          |   14 +++++++++++++-
 drivers/media/video/davinci/Makefile |    1 +
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 64682bf..d92268d 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -548,7 +548,6 @@ config VIDEO_VPSS_SYSTEM
 	depends on ARCH_DAVINCI
 	help
 	  Support for vpss system module for video driver
-	default y
 
 config VIDEO_VPFE_CAPTURE
 	tristate "VPFE Video Capture Driver"
@@ -592,6 +591,19 @@ config VIDEO_DM355_CCDC
 	   To compile this driver as a module, choose M here: the
 	   module will be called vpfe.
 
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
+
 source "drivers/media/video/bt8xx/Kconfig"
 
 config VIDEO_PMS
diff --git a/drivers/media/video/davinci/Makefile b/drivers/media/video/davinci/Makefile
index 1a8b8f3..a379557 100644
--- a/drivers/media/video/davinci/Makefile
+++ b/drivers/media/video/davinci/Makefile
@@ -15,3 +15,4 @@ obj-$(CONFIG_VIDEO_VPSS_SYSTEM) += vpss.o
 obj-$(CONFIG_VIDEO_VPFE_CAPTURE) += vpfe_capture.o
 obj-$(CONFIG_VIDEO_DM6446_CCDC) += dm644x_ccdc.o
 obj-$(CONFIG_VIDEO_DM355_CCDC) += dm355_ccdc.o
+obj-$(CONFIG_VIDEO_ISIF) += isif.o
-- 
1.6.0.4

