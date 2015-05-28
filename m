Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:11864 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbbE1LMF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 07:12:05 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NP200G6E4G3PQ90@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 28 May 2015 12:12:03 +0100 (BST)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media: s5p-mfc: fix sparse warnings
Date: Thu, 28 May 2015 13:11:47 +0200
Message-id: <1432811507-3171-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commits a0f10c131cc49d7d84394beb7903e1f246331224 and
6c9fe765360efa97c63b89af685b620baf5e0012 ("media: s5p-mfc: fix broken
pointer cast on 64bit arch") fixed issue with lossy cast on 64-bit
architectures. However it also removed __iomem attribute from that cast.
This leads to sparse warnings. This patch fixes those warnings by adding
__iomem cast in case of v6+ code version and replacing readl/writel by
simple u32 load/store operations in case of v5 code (which is called on
system memory allocated by dma_alloc_coherent() instead of io registers).

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c | 4 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index c7adc3d..9a923b1 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -263,7 +263,7 @@ static void s5p_mfc_release_dev_context_buffer_v5(struct s5p_mfc_dev *dev)
 static void s5p_mfc_write_info_v5(struct s5p_mfc_ctx *ctx, unsigned int data,
 			unsigned int ofs)
 {
-	writel(data, (void *)(ctx->shm.virt + ofs));
+	*(u32 *)(ctx->shm.virt + ofs) = data;
 	wmb();
 }
 
@@ -271,7 +271,7 @@ static unsigned int s5p_mfc_read_info_v5(struct s5p_mfc_ctx *ctx,
 				unsigned long ofs)
 {
 	rmb();
-	return readl((void *)(ctx->shm.virt + ofs));
+	return *(u32 *)(ctx->shm.virt + ofs);
 }
 
 static void s5p_mfc_dec_calc_dpb_size_v5(struct s5p_mfc_ctx *ctx)
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index cefad18..12497f5 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1852,7 +1852,7 @@ static void s5p_mfc_write_info_v6(struct s5p_mfc_ctx *ctx, unsigned int data,
 		unsigned int ofs)
 {
 	s5p_mfc_clock_on();
-	writel(data, (void *)((unsigned long)ofs));
+	writel(data, (void __iomem *)((unsigned long)ofs));
 	s5p_mfc_clock_off();
 }
 
@@ -1862,7 +1862,7 @@ s5p_mfc_read_info_v6(struct s5p_mfc_ctx *ctx, unsigned long ofs)
 	int ret;
 
 	s5p_mfc_clock_on();
-	ret = readl((void *)ofs);
+	ret = readl((void __iomem *)ofs);
 	s5p_mfc_clock_off();
 
 	return ret;
-- 
1.9.2

