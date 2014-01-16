Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:59228 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaAPL0n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jan 2014 06:26:43 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZH00AQKRSIHK00@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Jan 2014 20:26:42 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/2] s5p-jpeg: Fix broken indentation in jpeg-regs.h
Date: Thu, 16 Jan 2014 12:26:32 +0100
Message-id: <1389871593-10973-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-regs.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-regs.h b/drivers/media/platform/s5p-jpeg/jpeg-regs.h
index 33f2c73..57fb05b 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-regs.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-regs.h
@@ -210,19 +210,19 @@
 
 /* JPEG CNTL Register bit */
 #define EXYNOS4_ENC_DEC_MODE_MASK	(0xfffffffc << 0)
-#define EXYNOS4_DEC_MODE			(1 << 0)
-#define EXYNOS4_ENC_MODE			(1 << 1)
+#define EXYNOS4_DEC_MODE		(1 << 0)
+#define EXYNOS4_ENC_MODE		(1 << 1)
 #define EXYNOS4_AUTO_RST_MARKER		(1 << 2)
 #define EXYNOS4_RST_INTERVAL_SHIFT	3
 #define EXYNOS4_RST_INTERVAL(x)		(((x) & 0xffff) \
 						<< EXYNOS4_RST_INTERVAL_SHIFT)
 #define EXYNOS4_HUF_TBL_EN		(1 << 19)
 #define EXYNOS4_HOR_SCALING_SHIFT	20
-#define EXYNOS4_HOR_SCALING_MASK		(3 << EXYNOS4_HOR_SCALING_SHIFT)
+#define EXYNOS4_HOR_SCALING_MASK	(3 << EXYNOS4_HOR_SCALING_SHIFT)
 #define EXYNOS4_HOR_SCALING(x)		(((x) & 0x3) \
 						<< EXYNOS4_HOR_SCALING_SHIFT)
 #define EXYNOS4_VER_SCALING_SHIFT	22
-#define EXYNOS4_VER_SCALING_MASK		(3 << EXYNOS4_VER_SCALING_SHIFT)
+#define EXYNOS4_VER_SCALING_MASK	(3 << EXYNOS4_VER_SCALING_SHIFT)
 #define EXYNOS4_VER_SCALING(x)		(((x) & 0x3) \
 						<< EXYNOS4_VER_SCALING_SHIFT)
 #define EXYNOS4_PADDING			(1 << 27)
@@ -238,8 +238,8 @@
 #define EXYNOS4_FRAME_ERR_EN		(1 << 4)
 #define EXYNOS4_INT_EN_ALL		(0x1f << 0)
 
-#define EXYNOS4_MOD_REG_PROC_ENC		(0 << 3)
-#define EXYNOS4_MOD_REG_PROC_DEC		(1 << 3)
+#define EXYNOS4_MOD_REG_PROC_ENC	(0 << 3)
+#define EXYNOS4_MOD_REG_PROC_DEC	(1 << 3)
 
 #define EXYNOS4_MOD_REG_SUBSAMPLE_444	(0 << 0)
 #define EXYNOS4_MOD_REG_SUBSAMPLE_422	(1 << 0)
@@ -270,7 +270,7 @@
 #define EXYNOS4_DEC_YUV_420_IMG		(4 << 0)
 
 #define EXYNOS4_GRAY_IMG_IP_SHIFT	3
-#define EXYNOS4_GRAY_IMG_IP_MASK		(7 << EXYNOS4_GRAY_IMG_IP_SHIFT)
+#define EXYNOS4_GRAY_IMG_IP_MASK	(7 << EXYNOS4_GRAY_IMG_IP_SHIFT)
 #define EXYNOS4_GRAY_IMG_IP		(4 << EXYNOS4_GRAY_IMG_IP_SHIFT)
 
 #define EXYNOS4_RGB_IP_SHIFT		6
@@ -278,18 +278,18 @@
 #define EXYNOS4_RGB_IP_RGB_16BIT_IMG	(4 << EXYNOS4_RGB_IP_SHIFT)
 #define EXYNOS4_RGB_IP_RGB_32BIT_IMG	(5 << EXYNOS4_RGB_IP_SHIFT)
 
-#define EXYNOS4_YUV_444_IP_SHIFT			9
+#define EXYNOS4_YUV_444_IP_SHIFT		9
 #define EXYNOS4_YUV_444_IP_MASK			(7 << EXYNOS4_YUV_444_IP_SHIFT)
 #define EXYNOS4_YUV_444_IP_YUV_444_2P_IMG	(4 << EXYNOS4_YUV_444_IP_SHIFT)
 #define EXYNOS4_YUV_444_IP_YUV_444_3P_IMG	(5 << EXYNOS4_YUV_444_IP_SHIFT)
 
-#define EXYNOS4_YUV_422_IP_SHIFT			12
+#define EXYNOS4_YUV_422_IP_SHIFT		12
 #define EXYNOS4_YUV_422_IP_MASK			(7 << EXYNOS4_YUV_422_IP_SHIFT)
 #define EXYNOS4_YUV_422_IP_YUV_422_1P_IMG	(4 << EXYNOS4_YUV_422_IP_SHIFT)
 #define EXYNOS4_YUV_422_IP_YUV_422_2P_IMG	(5 << EXYNOS4_YUV_422_IP_SHIFT)
 #define EXYNOS4_YUV_422_IP_YUV_422_3P_IMG	(6 << EXYNOS4_YUV_422_IP_SHIFT)
 
-#define EXYNOS4_YUV_420_IP_SHIFT			15
+#define EXYNOS4_YUV_420_IP_SHIFT		15
 #define EXYNOS4_YUV_420_IP_MASK			(7 << EXYNOS4_YUV_420_IP_SHIFT)
 #define EXYNOS4_YUV_420_IP_YUV_420_2P_IMG	(4 << EXYNOS4_YUV_420_IP_SHIFT)
 #define EXYNOS4_YUV_420_IP_YUV_420_3P_IMG	(5 << EXYNOS4_YUV_420_IP_SHIFT)
@@ -303,8 +303,8 @@
 
 #define EXYNOS4_JPEG_DECODED_IMG_FMT_MASK	0x03
 
-#define EXYNOS4_SWAP_CHROMA_CRCB			(1 << 26)
-#define EXYNOS4_SWAP_CHROMA_CBCR			(0 << 26)
+#define EXYNOS4_SWAP_CHROMA_CRCB		(1 << 26)
+#define EXYNOS4_SWAP_CHROMA_CBCR		(0 << 26)
 
 /* JPEG HUFF count Register bit */
 #define EXYNOS4_HUFF_COUNT_MASK			0xffff
-- 
1.7.9.5

