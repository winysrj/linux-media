Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:42497 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab2GaL5R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 07:57:17 -0400
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M80000GTX6V8DW0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 31 Jul 2012 20:57:17 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8000CIRX6VNU20@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 31 Jul 2012 20:57:16 +0900 (KST)
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org
Cc: sungchun.kang@samsung.com, khw0178.kim@samsung.com,
	mchehab@infradead.org, laurent.pinchart@ideasonboard.com,
	sy0816.kang@samsung.com, s.nawrocki@samsung.com,
	posciak@google.com, alim.akhtar@gmail.com, prashanth.g@samsung.com,
	joshi@samsung.com, shaik.samsung@gmail.com, shaik.ameer@samsung.com
Subject: [PATCH v4 5/5] media: gscaler: Add Makefile for G-Scaler Driver
Date: Tue, 31 Jul 2012 17:42:33 +0530
Message-id: <1343736753-18454-6-git-send-email-shaik.ameer@samsung.com>
In-reply-to: <1343736753-18454-1-git-send-email-shaik.ameer@samsung.com>
References: <1343736753-18454-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the Makefile for G-Scaler driver.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/video/Kconfig             |    8 ++++++++
 drivers/media/video/Makefile            |    2 ++
 drivers/media/video/exynos-gsc/Makefile |    3 +++
 3 files changed, 13 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/exynos-gsc/Makefile

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 99937c9..36efda9 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1215,4 +1215,12 @@ config VIDEO_MX2_EMMAPRP
 	    memory to memory. Operations include resizing and format
 	    conversion.
 
+config VIDEO_SAMSUNG_EXYNOS_GSC
+        tristate "Samsung Exynos G-Scaler driver"
+        depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
+        select VIDEOBUF2_DMA_CONTIG
+        select V4L2_MEM2MEM_DEV
+        help
+            This is v4l2 based G-Scaler driver for EXYNOS5
+
 endif # V4L_MEM2MEM_DRIVERS
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index d209de0..763e8b4 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -195,6 +195,8 @@ obj-$(CONFIG_VIDEO_SAMSUNG_S5P_TV)	+= s5p-tv/
 
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_G2D)	+= s5p-g2d/
 
+obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC)	+= exynos-gsc/
+
 obj-$(CONFIG_BLACKFIN)                  += blackfin/
 
 obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
diff --git a/drivers/media/video/exynos-gsc/Makefile b/drivers/media/video/exynos-gsc/Makefile
new file mode 100644
index 0000000..e9d7f8a
--- /dev/null
+++ b/drivers/media/video/exynos-gsc/Makefile
@@ -0,0 +1,3 @@
+gsc-objs := gsc-core.o gsc-m2m.o gsc-regs.o
+
+obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC)	+= gsc.o
-- 
1.7.0.4

