Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44182 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821AbaHZVzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:22 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 15/35] [media] gsc: Use %pad for dma_addr_t
Date: Tue, 26 Aug 2014 18:54:51 -0300
Message-Id: <1409090111-8290-16-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/exynos-gsc/gsc-core.c:855:2: note: in expansion of macro 'pr_debug'
  pr_debug("ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d",
  ^
include/linux/dynamic_debug.h:64:16: warning: format '%X' expects argument of type 'unsigned int', but argument 4 has type 'dma
_addr_t' [-Wformat=]
  static struct _ddebug  __aligned(8)   \
                ^

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 4 ++--
 drivers/media/platform/exynos-gsc/gsc-regs.c | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 8d8b3cff8212..b4c9f1d08968 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -852,8 +852,8 @@ int gsc_prepare_addr(struct gsc_ctx *ctx, struct vb2_buffer *vb,
 		(frame->fmt->pixelformat == V4L2_PIX_FMT_YVU420M))
 		swap(addr->cb, addr->cr);
 
-	pr_debug("ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d",
-		addr->y, addr->cb, addr->cr, ret);
+	pr_debug("ADDR: y= %pad  cb= %pad cr= %pad ret= %d",
+		&addr->y, &addr->cb, &addr->cr, ret);
 
 	return ret;
 }
diff --git a/drivers/media/platform/exynos-gsc/gsc-regs.c b/drivers/media/platform/exynos-gsc/gsc-regs.c
index e22d147a6940..ce12a1100511 100644
--- a/drivers/media/platform/exynos-gsc/gsc-regs.c
+++ b/drivers/media/platform/exynos-gsc/gsc-regs.c
@@ -90,8 +90,8 @@ void gsc_hw_set_output_buf_masking(struct gsc_dev *dev, u32 shift,
 void gsc_hw_set_input_addr(struct gsc_dev *dev, struct gsc_addr *addr,
 				int index)
 {
-	pr_debug("src_buf[%d]: 0x%X, cb: 0x%X, cr: 0x%X", index,
-			addr->y, addr->cb, addr->cr);
+	pr_debug("src_buf[%d]: %pad, cb: %pad, cr: %pad", index,
+			&addr->y, &addr->cb, &addr->cr);
 	writel(addr->y, dev->regs + GSC_IN_BASE_ADDR_Y(index));
 	writel(addr->cb, dev->regs + GSC_IN_BASE_ADDR_CB(index));
 	writel(addr->cr, dev->regs + GSC_IN_BASE_ADDR_CR(index));
@@ -101,8 +101,8 @@ void gsc_hw_set_input_addr(struct gsc_dev *dev, struct gsc_addr *addr,
 void gsc_hw_set_output_addr(struct gsc_dev *dev,
 			     struct gsc_addr *addr, int index)
 {
-	pr_debug("dst_buf[%d]: 0x%X, cb: 0x%X, cr: 0x%X",
-			index, addr->y, addr->cb, addr->cr);
+	pr_debug("dst_buf[%d]: %pad, cb: %pad, cr: %pad",
+			index, &addr->y, &addr->cb, &addr->cr);
 	writel(addr->y, dev->regs + GSC_OUT_BASE_ADDR_Y(index));
 	writel(addr->cb, dev->regs + GSC_OUT_BASE_ADDR_CB(index));
 	writel(addr->cr, dev->regs + GSC_OUT_BASE_ADDR_CR(index));
-- 
1.9.3

