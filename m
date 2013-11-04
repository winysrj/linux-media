Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48329 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab3KDAGZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 19:06:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 06/18] v4l: omap4iss: Add support for OMAP4 camera interface - Build system
Date: Mon,  4 Nov 2013 01:06:31 +0100
Message-Id: <1383523603-3907-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds a very simplistic driver to utilize the CSI2A interface inside
the ISS subsystem in OMAP4, and dump the data to memory.

Check Documentation/video4linux/omap4_camera.txt for details.

This commit adds and updates Kconfig's and Makefile's, as well as a TODO
list.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/Kconfig           |  2 ++
 drivers/staging/media/Makefile          |  1 +
 drivers/staging/media/omap4iss/Kconfig  | 12 ++++++++++++
 drivers/staging/media/omap4iss/Makefile |  6 ++++++
 drivers/staging/media/omap4iss/TODO     |  4 ++++
 5 files changed, 25 insertions(+)
 create mode 100644 drivers/staging/media/omap4iss/Kconfig
 create mode 100644 drivers/staging/media/omap4iss/Makefile
 create mode 100644 drivers/staging/media/omap4iss/TODO

diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 46f1e61..bc4c798 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -33,6 +33,8 @@ source "drivers/staging/media/msi3101/Kconfig"
 
 source "drivers/staging/media/solo6x10/Kconfig"
 
+source "drivers/staging/media/omap4iss/Kconfig"
+
 # Keep LIRC at the end, as it has sub-menus
 source "drivers/staging/media/lirc/Kconfig"
 
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index eb7f30b..a528d3f 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_VIDEO_DT3155)	+= dt3155v4l/
 obj-$(CONFIG_VIDEO_GO7007)	+= go7007/
 obj-$(CONFIG_USB_MSI3101)	+= msi3101/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
+obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
diff --git a/drivers/staging/media/omap4iss/Kconfig b/drivers/staging/media/omap4iss/Kconfig
new file mode 100644
index 0000000..b9fe753
--- /dev/null
+++ b/drivers/staging/media/omap4iss/Kconfig
@@ -0,0 +1,12 @@
+config VIDEO_OMAP4
+	bool "OMAP 4 Camera support"
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && I2C && ARCH_OMAP4
+	select VIDEOBUF2_DMA_CONTIG
+	---help---
+	  Driver for an OMAP 4 ISS controller.
+
+config VIDEO_OMAP4_DEBUG
+	bool "OMAP 4 Camera debug messages"
+	depends on VIDEO_OMAP4
+	---help---
+	  Enable debug messages on OMAP 4 ISS controller driver.
diff --git a/drivers/staging/media/omap4iss/Makefile b/drivers/staging/media/omap4iss/Makefile
new file mode 100644
index 0000000..a716ce9
--- /dev/null
+++ b/drivers/staging/media/omap4iss/Makefile
@@ -0,0 +1,6 @@
+# Makefile for OMAP4 ISS driver
+
+omap4-iss-objs += \
+	iss.o iss_csi2.o iss_csiphy.o iss_ipipeif.o iss_ipipe.o iss_resizer.o iss_video.o
+
+obj-$(CONFIG_VIDEO_OMAP4) += omap4-iss.o
diff --git a/drivers/staging/media/omap4iss/TODO b/drivers/staging/media/omap4iss/TODO
new file mode 100644
index 0000000..fcde888
--- /dev/null
+++ b/drivers/staging/media/omap4iss/TODO
@@ -0,0 +1,4 @@
+* Make the driver compile as a module
+* Fix FIFO/buffer overflows and underflows
+* Replace dummy resizer code with a real implementation
+* Fix checkpatch errors and warnings
-- 
1.8.1.5

