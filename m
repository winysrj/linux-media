Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:9290 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaIANGI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Sep 2014 09:06:08 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NB80018T4E6PP40@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 01 Sep 2014 22:06:07 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 2/4] s5p-jpeg: remove stray call to readl
Date: Mon, 01 Sep 2014 15:05:50 +0200
Message-id: <1409576752-24729-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1409576752-24729-1-git-send-email-j.anaszewski@samsung.com>
References: <1409576752-24729-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to read INT_EN_REG before enabling interrupts.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
index da8d6a1..2de81c7 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
@@ -151,9 +151,6 @@ void exynos4_jpeg_set_enc_out_fmt(void __iomem *base, unsigned int out_fmt)
 
 void exynos4_jpeg_set_interrupt(void __iomem *base)
 {
-	unsigned int reg;
-
-	reg = readl(base + EXYNOS4_INT_EN_REG) & ~EXYNOS4_INT_EN_MASK;
 	writel(EXYNOS4_INT_EN_ALL, base + EXYNOS4_INT_EN_REG);
 }
 
-- 
1.7.9.5

