Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:55758 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab3KEMOI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 07:14:08 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.ameer@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH v12 10/12] [media] exynos5-is: Add Kconfig and Makefile
Date: Tue,  5 Nov 2013 17:43:27 +0530
Message-Id: <1383653610-11835-11-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1383653610-11835-1-git-send-email-arun.kk@samsung.com>
References: <1383653610-11835-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds Kconfig and Makefile for exynos5-is driver files.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/Kconfig                   |    1 +
 drivers/media/platform/Makefile                  |    1 +
 drivers/media/platform/exynos5-is/Kconfig        |   20 ++++++++++++++++++++
 drivers/media/platform/exynos5-is/Makefile       |    7 +++++++
 drivers/media/platform/exynos5-is/fimc-is-core.c |    1 +
 5 files changed, 30 insertions(+)
 create mode 100644 drivers/media/platform/exynos5-is/Kconfig
 create mode 100644 drivers/media/platform/exynos5-is/Makefile

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 08de865..4b0475e 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -123,6 +123,7 @@ config VIDEO_S3C_CAMIF
 
 source "drivers/media/platform/soc_camera/Kconfig"
 source "drivers/media/platform/exynos4-is/Kconfig"
+source "drivers/media/platform/exynos5-is/Kconfig"
 source "drivers/media/platform/s5p-tv/Kconfig"
 
 endif # V4L_PLATFORM_DRIVERS
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index eee28dd..40bf09f 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_VIDEO_SAMSUNG_S5P_TV)	+= s5p-tv/
 
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_G2D)	+= s5p-g2d/
 obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC)	+= exynos-gsc/
+obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS5_CAMERA) += exynos5-is/
 
 obj-$(CONFIG_BLACKFIN)                  += blackfin/
 
diff --git a/drivers/media/platform/exynos5-is/Kconfig b/drivers/media/platform/exynos5-is/Kconfig
new file mode 100644
index 0000000..b67d11a
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/Kconfig
@@ -0,0 +1,20 @@
+config VIDEO_SAMSUNG_EXYNOS5_CAMERA
+	bool "Samsung Exynos5 SoC Camera Media Device driver"
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && PM_RUNTIME
+	depends on VIDEO_SAMSUNG_EXYNOS4_IS
+	help
+	  This is a V4L2 media device driver for Exynos5 SoC series
+	  camera subsystem.
+
+if VIDEO_SAMSUNG_EXYNOS5_CAMERA
+
+config VIDEO_SAMSUNG_EXYNOS5_FIMC_IS
+	tristate "Samsung Exynos5 SoC FIMC-IS driver"
+	depends on I2C && OF
+	depends on VIDEO_EXYNOS4_FIMC_IS
+	select VIDEOBUF2_DMA_CONTIG
+	help
+	  This is a V4L2 driver for Samsung Exynos5 SoC series Imaging
+	  Subsystem known as FIMC-IS.
+
+endif #VIDEO_SAMSUNG_EXYNOS5_MDEV
diff --git a/drivers/media/platform/exynos5-is/Makefile b/drivers/media/platform/exynos5-is/Makefile
new file mode 100644
index 0000000..6cdb037
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/Makefile
@@ -0,0 +1,7 @@
+ccflags-y += -Idrivers/media/platform/exynos4-is
+exynos5-fimc-is-objs := fimc-is-core.o fimc-is-isp.o fimc-is-scaler.o
+exynos5-fimc-is-objs += fimc-is-pipeline.o fimc-is-interface.o fimc-is-sensor.o
+exynos-mdevice-objs := exynos5-mdev.o
+
+obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS5_FIMC_IS) += exynos5-fimc-is.o
+obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS5_CAMERA) += exynos-mdevice.o
diff --git a/drivers/media/platform/exynos5-is/fimc-is-core.c b/drivers/media/platform/exynos5-is/fimc-is-core.c
index 136e3c1..0b391f2 100644
--- a/drivers/media/platform/exynos5-is/fimc-is-core.c
+++ b/drivers/media/platform/exynos5-is/fimc-is-core.c
@@ -12,6 +12,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/of_platform.h>
 #include <linux/videodev2.h>
 
 #include <media/v4l2-device.h>
-- 
1.7.9.5

