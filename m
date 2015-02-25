Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:46387 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbbBYLyP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 06:54:15 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKB00FZCT2D7Q20@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 Feb 2015 20:54:13 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH] s5p-jpeg: exynos3250: fix erroneous reset procedure
Date: Wed, 25 Feb 2015 12:53:49 +0100
Message-id: <1424865229-31634-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first while loop in the function exynos3250_jpeg_reset had no chance
to be executed because the reg variable was initialized to 0.
Initialize reg variable to 1 to fix the issue.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Reported-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
---
 .../media/platform/s5p-jpeg/jpeg-hw-exynos3250.c   |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c
index e8c2cad..0974b9a 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c
@@ -20,7 +20,7 @@
 
 void exynos3250_jpeg_reset(void __iomem *regs)
 {
-	u32 reg = 0;
+	u32 reg = 1;
 	int count = 1000;
 
 	writel(1, regs + EXYNOS3250_SW_RESET);
-- 
1.7.9.5

