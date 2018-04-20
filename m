Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:60129 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750858AbeDTTCB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 15:02:01 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH] media: s5p-jpeg: don't return a value on a void function
Date: Fri, 20 Apr 2018 15:01:55 -0400
Message-Id: <180af45d9964a4d9855066b8f74a8629625acfa2.1524250913.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Building this driver on arm64 gives this warning:
	drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c:430:16: error: return expression in void function

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c
index 0974b9a7a584..0861842b2dfc 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c
@@ -425,9 +425,9 @@ unsigned int exynos3250_jpeg_get_int_status(void __iomem *regs)
 }
 
 void exynos3250_jpeg_clear_int_status(void __iomem *regs,
-						unsigned int value)
+				      unsigned int value)
 {
-	return writel(value, regs + EXYNOS3250_JPGINTST);
+	writel(value, regs + EXYNOS3250_JPGINTST);
 }
 
 unsigned int exynos3250_jpeg_operating(void __iomem *regs)
-- 
2.14.3
