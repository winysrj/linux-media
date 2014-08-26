Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44164 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749AbaHZVzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:22 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 18/35] [media] s5p-jpeg: get rid of some warnings
Date: Tue, 26 Aug 2014 18:54:54 -0300
Message-Id: <1409090111-8290-19-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Declare this as static:

drivers/media/platform/s5p-jpeg/jpeg-core.c:732:6: warning: no previous prototype for 'exynos4_jpeg_set_huff_tbl' [-Wmissing-prototypes]
 void exynos4_jpeg_set_huff_tbl(void __iomem *base)
      ^

And don't compile this dead code, while not needed:
drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c:236:14: warning: no previous prototype for 'exynos3250_jpeg_get_y' [-Wmissing-prototypes]
 unsigned int exynos3250_jpeg_get_y(void __iomem *regs)
              ^
drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c:241:14: warning: no previous prototype for 'exynos3250_jpeg_get_x' [-Wmissing-prototypes]
 unsigned int exynos3250_jpeg_get_x(void __iomem *regs)
              ^

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c          | 2 +-
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index e66acbc2a82d..e525a7c8d885 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -729,7 +729,7 @@ static inline void exynos4_jpeg_set_qtbl_chr(void __iomem *regs, int quality)
 			     ARRAY_SIZE(qtbl_chrominance[quality]));
 }
 
-void exynos4_jpeg_set_huff_tbl(void __iomem *base)
+static void exynos4_jpeg_set_huff_tbl(void __iomem *base)
 {
 	exynos4_jpeg_set_tbl(base, hdctbl0, EXYNOS4_HUFF_TBL_HDCLL,
 							ARRAY_SIZE(hdctbl0));
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c
index d26e1f846553..e8c2cad93962 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c
@@ -233,6 +233,7 @@ void exynos3250_jpeg_set_x(void __iomem *regs, unsigned int x)
 	writel(reg, regs + EXYNOS3250_JPGX);
 }
 
+#if 0	/* Currently unused */
 unsigned int exynos3250_jpeg_get_y(void __iomem *regs)
 {
 	return readl(regs + EXYNOS3250_JPGY);
@@ -242,6 +243,7 @@ unsigned int exynos3250_jpeg_get_x(void __iomem *regs)
 {
 	return readl(regs + EXYNOS3250_JPGX);
 }
+#endif
 
 void exynos3250_jpeg_interrupts_enable(void __iomem *regs)
 {
-- 
1.9.3

