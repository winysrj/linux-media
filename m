Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:45481 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab3HSKzf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 06:55:35 -0400
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, posciak@google.com, arun.kk@samsung.com,
	shaik.ameer@samsung.com
Subject: [PATCH v2 5/5] [media] exynos-mscl: Add Makefile for M-Scaler driver
Date: Mon, 19 Aug 2013 16:28:52 +0530
Message-Id: <1376909932-23644-6-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1376909932-23644-1-git-send-email-shaik.ameer@samsung.com>
References: <1376909932-23644-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the Makefile for the M-Scaler (M2M scaler).

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/Kconfig              |    8 ++++++++
 drivers/media/platform/Makefile             |    1 +
 drivers/media/platform/exynos-mscl/Makefile |    3 +++
 3 files changed, 12 insertions(+)
 create mode 100644 drivers/media/platform/exynos-mscl/Makefile

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 08de865..bff437a 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -201,6 +201,14 @@ config VIDEO_SAMSUNG_EXYNOS_GSC
 	help
 	  This is a v4l2 driver for Samsung EXYNOS5 SoC G-Scaler.
 
+config VIDEO_SAMSUNG_EXYNOS_MSCL
+	tristate "Samsung Exynos M-Scaler driver"
+	depends on OF && VIDEO_DEV && VIDEO_V4L2 && ARCH_EXYNOS5
+	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_MEM2MEM_DEV
+	help
+	  This is a v4l2 driver for Samsung EXYNOS5 SoC M-Scaler.
+
 config VIDEO_SH_VEU
 	tristate "SuperH VEU mem2mem video processing driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && GENERIC_HARDIRQS
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index eee28dd..2452b09 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_VIDEO_SAMSUNG_S5P_TV)	+= s5p-tv/
 
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_G2D)	+= s5p-g2d/
 obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC)	+= exynos-gsc/
+obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_MSCL)	+= exynos-mscl/
 
 obj-$(CONFIG_BLACKFIN)                  += blackfin/
 
diff --git a/drivers/media/platform/exynos-mscl/Makefile b/drivers/media/platform/exynos-mscl/Makefile
new file mode 100644
index 0000000..c9ffcd8
--- /dev/null
+++ b/drivers/media/platform/exynos-mscl/Makefile
@@ -0,0 +1,3 @@
+exynos-mscl-objs := mscl-core.o mscl-m2m.o mscl-regs.o
+
+obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_MSCL)	+= exynos-mscl.o
-- 
1.7.9.5

