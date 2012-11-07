Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:49017 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2KGGT0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Nov 2012 01:19:26 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MD300FMTTIRNO70@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Nov 2012 15:19:03 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MD300HXHTHI5N50@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Nov 2012 15:19:02 +0900 (KST)
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, kgene.kim@samsung.com,
	shaik.samsung@gmail.com
Subject: [PATCH] [media] exynos-gsc: Fix settings for input and output image
 RGB type
Date: Wed, 07 Nov 2012 12:08:31 +0530
Message-id: <1352270311-9577-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Macros used to set input and output RGB type aren't correct.
Updating the macros as per register manual.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-regs.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-regs.h b/drivers/media/platform/exynos-gsc/gsc-regs.h
index 533e994..4678f9a 100644
--- a/drivers/media/platform/exynos-gsc/gsc-regs.h
+++ b/drivers/media/platform/exynos-gsc/gsc-regs.h
@@ -40,10 +40,10 @@
 #define GSC_IN_ROT_YFLIP		(2 << 16)
 #define GSC_IN_ROT_XFLIP		(1 << 16)
 #define GSC_IN_RGB_TYPE_MASK		(3 << 14)
-#define GSC_IN_RGB_HD_WIDE		(3 << 14)
-#define GSC_IN_RGB_HD_NARROW		(2 << 14)
-#define GSC_IN_RGB_SD_WIDE		(1 << 14)
-#define GSC_IN_RGB_SD_NARROW		(0 << 14)
+#define GSC_IN_RGB_HD_NARROW		(3 << 14)
+#define GSC_IN_RGB_HD_WIDE		(2 << 14)
+#define GSC_IN_RGB_SD_NARROW		(1 << 14)
+#define GSC_IN_RGB_SD_WIDE		(0 << 14)
 #define GSC_IN_YUV422_1P_ORDER_MASK	(1 << 13)
 #define GSC_IN_YUV422_1P_ORDER_LSB_Y	(0 << 13)
 #define GSC_IN_YUV422_1P_OEDER_LSB_C	(1 << 13)
@@ -85,10 +85,10 @@
 #define GSC_OUT_GLOBAL_ALPHA_MASK	(0xff << 24)
 #define GSC_OUT_GLOBAL_ALPHA(x)		((x) << 24)
 #define GSC_OUT_RGB_TYPE_MASK		(3 << 10)
-#define GSC_OUT_RGB_HD_NARROW		(3 << 10)
-#define GSC_OUT_RGB_HD_WIDE		(2 << 10)
-#define GSC_OUT_RGB_SD_NARROW		(1 << 10)
-#define GSC_OUT_RGB_SD_WIDE		(0 << 10)
+#define GSC_OUT_RGB_HD_WIDE		(3 << 10)
+#define GSC_OUT_RGB_HD_NARROW		(2 << 10)
+#define GSC_OUT_RGB_SD_WIDE		(1 << 10)
+#define GSC_OUT_RGB_SD_NARROW		(0 << 10)
 #define GSC_OUT_YUV422_1P_ORDER_MASK	(1 << 9)
 #define GSC_OUT_YUV422_1P_ORDER_LSB_Y	(0 << 9)
 #define GSC_OUT_YUV422_1P_OEDER_LSB_C	(1 << 9)
-- 
1.7.0.4

