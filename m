Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46101 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab2K1Ko1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 05:44:27 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	<devel@driverdev.osuosl.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v3 8/9] davinci: vpfe: dm365: add build infrastructure for capture driver
Date: Wed, 28 Nov 2012 16:12:08 +0530
Message-Id: <1354099329-20722-9-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1354099329-20722-1-git-send-email-prabhakar.lad@ti.com>
References: <1354099329-20722-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Manjunath Hadli <manjunath.hadli@ti.com>

add build infrastructure for dm365 specific modules for VPFE
capture driver.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/staging/media/Kconfig               |    2 ++
 drivers/staging/media/Makefile              |    1 +
 drivers/staging/media/davinci_vpfe/Kconfig  |    9 +++++++++
 drivers/staging/media/davinci_vpfe/Makefile |    3 +++
 4 files changed, 15 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/media/davinci_vpfe/Kconfig
 create mode 100644 drivers/staging/media/davinci_vpfe/Makefile

diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 427218b..ae0abc3 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -23,6 +23,8 @@ source "drivers/staging/media/as102/Kconfig"
 
 source "drivers/staging/media/cxd2099/Kconfig"
 
+source "drivers/staging/media/davinci_vpfe/Kconfig"
+
 source "drivers/staging/media/dt3155v4l/Kconfig"
 
 source "drivers/staging/media/go7007/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index aec6eb9..2b97cae 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_LIRC_STAGING)	+= lirc/
 obj-$(CONFIG_SOLO6X10)		+= solo6x10/
 obj-$(CONFIG_VIDEO_DT3155)	+= dt3155v4l/
 obj-$(CONFIG_VIDEO_GO7007)	+= go7007/
+obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
diff --git a/drivers/staging/media/davinci_vpfe/Kconfig b/drivers/staging/media/davinci_vpfe/Kconfig
new file mode 100644
index 0000000..2e4a28b
--- /dev/null
+++ b/drivers/staging/media/davinci_vpfe/Kconfig
@@ -0,0 +1,9 @@
+config VIDEO_DM365_VPFE
+	tristate "DM365 VPFE Media Controller Capture Driver"
+	depends on VIDEO_V4L2 && ARCH_DAVINCI_DM365 && !VIDEO_VPFE_CAPTURE
+	select VIDEOBUF2_DMA_CONTIG
+	help
+	  Support for DM365 VPFE based Media Controller Capture driver.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called vpfe-mc-capture.
diff --git a/drivers/staging/media/davinci_vpfe/Makefile b/drivers/staging/media/davinci_vpfe/Makefile
new file mode 100644
index 0000000..c64515c
--- /dev/null
+++ b/drivers/staging/media/davinci_vpfe/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_VIDEO_DM365_VPFE) += \
+	dm365_isif.o dm365_ipipe_hw.o dm365_ipipe.o \
+	dm365_resizer.o dm365_ipipeif.o vpfe_mc_capture.o vpfe_video.o
-- 
1.7.4.1

