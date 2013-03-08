Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:59296 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab3CHOnH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 09:43:07 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org
Cc: s.nawrocki@samsung.com, kgene.kim@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: [RFC 11/12] exynos-fimc-is: Adds the Kconfig and Makefile
Date: Fri, 08 Mar 2013 09:59:24 -0500
Message-id: <1362754765-2651-12-git-send-email-arun.kk@samsung.com>
In-reply-to: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modifies the exynos5-is Makefile and Kconfig to include the new
fimc-is driver.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
---
 drivers/media/platform/exynos5-is/Kconfig  |   12 ++++++++++++
 drivers/media/platform/exynos5-is/Makefile |    3 +++
 2 files changed, 15 insertions(+)

diff --git a/drivers/media/platform/exynos5-is/Kconfig b/drivers/media/platform/exynos5-is/Kconfig
index 7aacf3b..588103e 100644
--- a/drivers/media/platform/exynos5-is/Kconfig
+++ b/drivers/media/platform/exynos5-is/Kconfig
@@ -5,3 +5,15 @@ config VIDEO_SAMSUNG_EXYNOS5_MDEV
 	  This is a v4l2 based media controller driver for
 	  Exynos5 SoC.
 
+if VIDEO_SAMSUNG_EXYNOS5_MDEV
+
+config VIDEO_SAMSUNG_EXYNOS5_FIMC_IS
+	tristate "Samsung Exynos5 SoC FIMC-IS driver"
+	depends on VIDEO_V4L2_SUBDEV_API
+	depends on VIDEO_SAMSUNG_EXYNOS5_MDEV
+	select VIDEOBUF2_DMA_CONTIG
+	help
+	  This is a v4l2 driver for Samsung Exynos5 SoC series Imaging
+	  subsystem known as FIMC-IS.
+
+endif #VIDEO_SAMSUNG_EXYNOS5_MDEV
diff --git a/drivers/media/platform/exynos5-is/Makefile b/drivers/media/platform/exynos5-is/Makefile
index 472d8e1..e5003d0 100644
--- a/drivers/media/platform/exynos5-is/Makefile
+++ b/drivers/media/platform/exynos5-is/Makefile
@@ -1,4 +1,7 @@
 ccflags-y += -Idrivers/media/platform/s5p-fimc
+exynos5-fimc-is-objs := fimc-is-core.o fimc-is-isp.o fimc-is-scaler.o fimc-is-sensor.o
+exynos5-fimc-is-objs += fimc-is-pipeline.o fimc-is-interface.o
 exynos-mdevice-objs := exynos5-mdev.o
 
+obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS5_FIMC_IS) += exynos5-fimc-is.o
 obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS5_MDEV) += exynos-mdevice.o
-- 
1.7.9.5

