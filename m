Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:57481 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666AbZLAVix (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 16:38:53 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	khilman@deeprootsystems.com
Cc: davinci-linux-open-source@linux.davincidsp.com, hvaibhav@ti.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 4/5 - v0] V4L - vpfe capture - build environment to support DM365 CCDC
Date: Tue,  1 Dec 2009 16:38:52 -0500
Message-Id: <1259703533-1789-4-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1259703533-1789-3-git-send-email-m-karicheri2@ti.com>
References: <1259703533-1789-1-git-send-email-m-karicheri2@ti.com>
 <1259703533-1789-2-git-send-email-m-karicheri2@ti.com>
 <1259703533-1789-3-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

Added support for building DM365 CCDC module. Also made VPSS module default
configuration variable value to n.

NOTE: This patch is for review purpose only

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
 drivers/media/video/Kconfig          |   15 ++++++++++++++-
 drivers/media/video/davinci/Makefile |    1 +
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 9dc74c9..6d3ae06 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -552,7 +552,7 @@ config VIDEO_VPSS_SYSTEM
 	depends on ARCH_DAVINCI
 	help
 	  Support for vpss system module for video driver
-	default y
+	default n
 
 config VIDEO_VPFE_CAPTURE
 	tristate "VPFE Video Capture Driver"
@@ -596,6 +596,19 @@ config VIDEO_DM355_CCDC
 	   To compile this driver as a module, choose M here: the
 	   module will be called vpfe.
 
+config VIDEO_DM365_ISIF
+	tristate "DM365 CCDC/ISIF HW module"
+	depends on ARCH_DAVINCI_DM365 && VIDEO_VPFE_CAPTURE
+	select VIDEO_VPSS_SYSTEM
+	default y
+	help
+	   Enables DM365 ISIF hw module. This is the hardware module for
+	   configuring ISIF in VPFE to capture Raw Bayer RGB data  from
+	   a image sensor or YUV data from a YUV source.
+
+	   To compile this driver as a module, choose M here: the
+	   module will be called vpfe.
+
 source "drivers/media/video/bt8xx/Kconfig"
 
 config VIDEO_PMS
diff --git a/drivers/media/video/davinci/Makefile b/drivers/media/video/davinci/Makefile
index 1a8b8f3..3642d79 100644
--- a/drivers/media/video/davinci/Makefile
+++ b/drivers/media/video/davinci/Makefile
@@ -15,3 +15,4 @@ obj-$(CONFIG_VIDEO_VPSS_SYSTEM) += vpss.o
 obj-$(CONFIG_VIDEO_VPFE_CAPTURE) += vpfe_capture.o
 obj-$(CONFIG_VIDEO_DM6446_CCDC) += dm644x_ccdc.o
 obj-$(CONFIG_VIDEO_DM355_CCDC) += dm355_ccdc.o
+obj-$(CONFIG_VIDEO_DM365_ISIF) += dm365_ccdc.o
-- 
1.6.0.4

