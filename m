Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:48510 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751820AbcBWMNF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 07:13:05 -0500
To: linux-media <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@iki.fi>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] soc_camera/omap1: move to staging in preparation for removal
Message-ID: <56CC4CD0.7050308@xs4all.nl>
Date: Tue, 23 Feb 2016 13:13:04 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver is deprecated: it needs to be converted to vb2 and
it should become a stand-alone driver instead of using the
soc-camera framework.

Unless someone is willing to take this on (unlikely with such
ancient hardware) it is going to be removed from the kernel
soon.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/soc_camera/Kconfig                   | 10 ----------
 drivers/media/platform/soc_camera/Makefile                  |  1 -
 drivers/staging/media/Kconfig                               |  2 ++
 drivers/staging/media/Makefile                              |  1 +
 drivers/staging/media/omap1/Kconfig                         | 13 +++++++++++++
 drivers/staging/media/omap1/Makefile                        |  3 +++
 .../soc_camera => staging/media/omap1}/omap1_camera.c       |  0
 7 files changed, 19 insertions(+), 11 deletions(-)
 create mode 100644 drivers/staging/media/omap1/Kconfig
 create mode 100644 drivers/staging/media/omap1/Makefile
 rename drivers/{media/platform/soc_camera => staging/media/omap1}/omap1_camera.c (100%)

diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index f2776cd..954dd36 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -60,16 +60,6 @@ config VIDEO_SH_MOBILE_CEU
 	---help---
 	  This is a v4l2 driver for the SuperH Mobile CEU Interface

-config VIDEO_OMAP1
-	tristate "OMAP1 Camera Interface driver"
-	depends on VIDEO_DEV && SOC_CAMERA
-	depends on ARCH_OMAP1
-	depends on HAS_DMA
-	select VIDEOBUF_DMA_CONTIG
-	select VIDEOBUF_DMA_SG
-	---help---
-	  This is a v4l2 driver for the TI OMAP1 camera interface
-
 config VIDEO_MX2
 	tristate "i.MX27 Camera Sensor Interface driver"
 	depends on VIDEO_DEV && SOC_CAMERA
diff --git a/drivers/media/platform/soc_camera/Makefile b/drivers/media/platform/soc_camera/Makefile
index 2826382..bdd7fc9 100644
--- a/drivers/media/platform/soc_camera/Makefile
+++ b/drivers/media/platform/soc_camera/Makefile
@@ -9,7 +9,6 @@ obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
 obj-$(CONFIG_VIDEO_ATMEL_ISI)		+= atmel-isi.o
 obj-$(CONFIG_VIDEO_MX2)			+= mx2_camera.o
 obj-$(CONFIG_VIDEO_MX3)			+= mx3_camera.o
-obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
 obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)	+= sh_mobile_csi2.o
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index d48a5c2..382d868 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -29,6 +29,8 @@ source "drivers/staging/media/mn88472/Kconfig"

 source "drivers/staging/media/mn88473/Kconfig"

+source "drivers/staging/media/omap1/Kconfig"
+
 source "drivers/staging/media/omap4iss/Kconfig"

 source "drivers/staging/media/timb/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index fb94f04..89d038c 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_I2C_BCM2048)	+= bcm2048/
 obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
 obj-$(CONFIG_LIRC_STAGING)	+= lirc/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
+obj-$(CONFIG_VIDEO_OMAP1)	+= omap1/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
 obj-$(CONFIG_DVB_MN88472)       += mn88472/
 obj-$(CONFIG_DVB_MN88473)       += mn88473/
diff --git a/drivers/staging/media/omap1/Kconfig b/drivers/staging/media/omap1/Kconfig
new file mode 100644
index 0000000..6cfab3a
--- /dev/null
+++ b/drivers/staging/media/omap1/Kconfig
@@ -0,0 +1,13 @@
+config VIDEO_OMAP1
+	tristate "OMAP1 Camera Interface driver"
+	depends on VIDEO_DEV && SOC_CAMERA
+	depends on ARCH_OMAP1
+	depends on HAS_DMA
+	select VIDEOBUF_DMA_CONTIG
+	select VIDEOBUF_DMA_SG
+	---help---
+	  This is a v4l2 driver for the TI OMAP1 camera interface
+
+	  This driver is deprecated and will be removed soon unless someone
+	  will start the work to convert this driver to the vb2 framework
+	  and remove the soc-camera dependency.
diff --git a/drivers/staging/media/omap1/Makefile b/drivers/staging/media/omap1/Makefile
new file mode 100644
index 0000000..2885622
--- /dev/null
+++ b/drivers/staging/media/omap1/Makefile
@@ -0,0 +1,3 @@
+# Makefile for OMAP1 driver
+
+obj-$(CONFIG_VIDEO_OMAP1) += omap1_camera.o
diff --git a/drivers/media/platform/soc_camera/omap1_camera.c b/drivers/staging/media/omap1/omap1_camera.c
similarity index 100%
rename from drivers/media/platform/soc_camera/omap1_camera.c
rename to drivers/staging/media/omap1/omap1_camera.c
-- 
2.7.0

