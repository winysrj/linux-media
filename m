Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:55496 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab3EaMqo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 08:46:44 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MNN00FUPY5VX7R0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 May 2013 21:46:43 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, kilyeon.im@samsung.com,
	shaik.ameer@samsung.com, arunkk.samsung@gmail.com
Subject: [RFC v2 10/10] exynos5-fimc-is: Adds the Kconfig and Makefile
Date: Fri, 31 May 2013 18:33:28 +0530
Message-id: <1370005408-10853-11-git-send-email-arun.kk@samsung.com>
In-reply-to: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
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
index 7aacf3b..f8bd17c 100644
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
+	  This is a V4L2 driver for Samsung Exynos5 SoC series Imaging
+	  Subsystem known as FIMC-IS.
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

