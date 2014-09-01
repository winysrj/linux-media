Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:25801 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaIANGL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Sep 2014 09:06:11 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NB8003NM4EA2DA0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 01 Sep 2014 22:06:10 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 3/4] s5p-jpeg: avoid overwriting JPEG_CNTL register settings
Date: Mon, 01 Sep 2014 15:05:51 +0200
Message-id: <1409576752-24729-3-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1409576752-24729-1-git-send-email-j.anaszewski@samsung.com>
References: <1409576752-24729-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Take into account the JPEG_CNTL register value read before
setting SYS_INT_EN bit field.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
index 2de81c7..d9ce40f 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
@@ -193,9 +193,9 @@ void exynos4_jpeg_set_sys_int_enable(void __iomem *base, int value)
 	reg = readl(base + EXYNOS4_JPEG_CNTL_REG) & ~(EXYNOS4_SYS_INT_EN);
 
 	if (value == 1)
-		writel(EXYNOS4_SYS_INT_EN, base + EXYNOS4_JPEG_CNTL_REG);
+		writel(reg | EXYNOS4_SYS_INT_EN, base + EXYNOS4_JPEG_CNTL_REG);
 	else
-		writel(~EXYNOS4_SYS_INT_EN, base + EXYNOS4_JPEG_CNTL_REG);
+		writel(reg & ~EXYNOS4_SYS_INT_EN, base + EXYNOS4_JPEG_CNTL_REG);
 }
 
 void exynos4_jpeg_set_stream_buf_address(void __iomem *base,
-- 
1.7.9.5

