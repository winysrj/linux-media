Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:25812 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaIANGV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Sep 2014 09:06:21 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NB800MGS4ED7V00@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 01 Sep 2014 22:06:13 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 4/4] s5p-jpeg: fix HUF_TBL_EN bit clearing path
Date: Mon, 01 Sep 2014 15:05:52 +0200
Message-id: <1409576752-24729-4-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1409576752-24729-1-git-send-email-j.anaszewski@samsung.com>
References: <1409576752-24729-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use proper bitwise operator while clearing HUF_TBL_EN bit.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
index d9ce40f..e51c078 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
@@ -182,7 +182,7 @@ void exynos4_jpeg_set_huf_table_enable(void __iomem *base, int value)
 		writel(reg | EXYNOS4_HUF_TBL_EN,
 					base + EXYNOS4_JPEG_CNTL_REG);
 	else
-		writel(reg | ~EXYNOS4_HUF_TBL_EN,
+		writel(reg & ~EXYNOS4_HUF_TBL_EN,
 					base + EXYNOS4_JPEG_CNTL_REG);
 }
 
-- 
1.7.9.5

