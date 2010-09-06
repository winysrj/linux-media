Return-path: <mchehab@gaivota>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25805 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab0IFGxz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Sep 2010 02:53:55 -0400
Received: from eu_spt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L8B00297CHS60@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Sep 2010 07:53:52 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L8B00E31CHS32@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Sep 2010 07:53:52 +0100 (BST)
Date: Mon, 06 Sep 2010 08:53:44 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 2/8] v4l: s5p-fimc: Fix 3-planar formats handling and pixel
 offset error on S5PV210 SoCs
In-reply-to: <1283756030-28634-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	p.osciak@samsung.com, s.nawrocki@samsung.com
Message-id: <1283756030-28634-3-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1283756030-28634-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

Fix DMA engine pixel offset calculation for 3-planar YUV formats.
On S5PV210 SoCs horizontal offset is applied as number of pixels,
not bytes per line.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |   87 +++++++++++++-----------------
 1 files changed, 37 insertions(+), 50 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index b03b856..e00026b 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -393,6 +393,37 @@ static void fimc_set_yuv_order(struct fimc_ctx *ctx)
 	dbg("ctx->out_order_1p= %d", ctx->out_order_1p);
 }
 
+static void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f)
+{
+	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
+
+	f->dma_offset.y_h = f->offs_h;
+	if (!variant->pix_hoff)
+		f->dma_offset.y_h *= (f->fmt->depth >> 3);
+
+	f->dma_offset.y_v = f->offs_v;
+
+	f->dma_offset.cb_h = f->offs_h;
+	f->dma_offset.cb_v = f->offs_v;
+
+	f->dma_offset.cr_h = f->offs_h;
+	f->dma_offset.cr_v = f->offs_v;
+
+	if (!variant->pix_hoff) {
+		if(f->fmt->planes_cnt == 3) {
+			f->dma_offset.cb_h >>= 1;
+			f->dma_offset.cr_h >>= 1;
+		}
+		if(f->fmt->color == S5P_FIMC_YCBCR420) {
+			f->dma_offset.cb_v >>= 1;
+			f->dma_offset.cr_v >>= 1;
+		}
+	}
+
+	dbg("in_offset: color= %d, y_h= %d, y_v= %d",
+	    f->fmt->color, f->dma_offset.y_h, f->dma_offset.y_v);
+}
+
 /**
  * fimc_prepare_config - check dimensions, operation and color mode
  *			 and pre-calculate offset and the scaling coefficients.
@@ -406,7 +437,6 @@ static int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags)
 {
 	struct fimc_frame *s_frame, *d_frame;
 	struct fimc_vid_buffer *buf = NULL;
-	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
 	int ret = 0;
 
 	s_frame = &ctx->s_frame;
@@ -419,61 +449,16 @@ static int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags)
 			swap(d_frame->width, d_frame->height);
 		}
 
-		/* Prepare the output offset ratios for scaler. */
-		d_frame->dma_offset.y_h = d_frame->offs_h;
-		if (!variant->pix_hoff)
-			d_frame->dma_offset.y_h *= (d_frame->fmt->depth >> 3);
-
-		d_frame->dma_offset.y_v = d_frame->offs_v;
+		/* Prepare the DMA offset ratios for scaler. */
+		fimc_prepare_dma_offset(ctx, &ctx->s_frame);
+		fimc_prepare_dma_offset(ctx, &ctx->d_frame);
 
-		d_frame->dma_offset.cb_h = d_frame->offs_h;
-		d_frame->dma_offset.cb_v = d_frame->offs_v;
-
-		d_frame->dma_offset.cr_h = d_frame->offs_h;
-		d_frame->dma_offset.cr_v = d_frame->offs_v;
-
-		if (!variant->pix_hoff && d_frame->fmt->planes_cnt == 3) {
-			d_frame->dma_offset.cb_h >>= 1;
-			d_frame->dma_offset.cb_v >>= 1;
-			d_frame->dma_offset.cr_h >>= 1;
-			d_frame->dma_offset.cr_v >>= 1;
-		}
-
-		dbg("out offset: color= %d, y_h= %d, y_v= %d",
-			d_frame->fmt->color,
-			d_frame->dma_offset.y_h, d_frame->dma_offset.y_v);
-
-		/* Prepare the input offset ratios for scaler. */
-		s_frame->dma_offset.y_h = s_frame->offs_h;
-		if (!variant->pix_hoff)
-			s_frame->dma_offset.y_h *= (s_frame->fmt->depth >> 3);
-		s_frame->dma_offset.y_v = s_frame->offs_v;
-
-		s_frame->dma_offset.cb_h = s_frame->offs_h;
-		s_frame->dma_offset.cb_v = s_frame->offs_v;
-
-		s_frame->dma_offset.cr_h = s_frame->offs_h;
-		s_frame->dma_offset.cr_v = s_frame->offs_v;
-
-		if (!variant->pix_hoff && s_frame->fmt->planes_cnt == 3) {
-			s_frame->dma_offset.cb_h >>= 1;
-			s_frame->dma_offset.cb_v >>= 1;
-			s_frame->dma_offset.cr_h >>= 1;
-			s_frame->dma_offset.cr_v >>= 1;
-		}
-
-		dbg("in offset: color= %d, y_h= %d, y_v= %d",
-			s_frame->fmt->color, s_frame->dma_offset.y_h,
-			s_frame->dma_offset.y_v);
-
-		fimc_set_yuv_order(ctx);
-
-		/* Check against the scaler ratio. */
 		if (s_frame->height > (SCALER_MAX_VRATIO * d_frame->height) ||
 		    s_frame->width > (SCALER_MAX_HRATIO * d_frame->width)) {
 			err("out of scaler range");
 			return -EINVAL;
 		}
+		fimc_set_yuv_order(ctx);
 	}
 
 	/* Input DMA mode is not allowed when the scaler is disabled. */
@@ -1494,6 +1479,7 @@ static struct samsung_fimc_variant fimc2_variant_s5p = {
 };
 
 static struct samsung_fimc_variant fimc01_variant_s5pv210 = {
+	.pix_hoff	= 1,
 	.has_inp_rot	= 1,
 	.has_out_rot	= 1,
 	.min_inp_pixsize = 16,
@@ -1508,6 +1494,7 @@ static struct samsung_fimc_variant fimc01_variant_s5pv210 = {
 };
 
 static struct samsung_fimc_variant fimc2_variant_s5pv210 = {
+	.pix_hoff	 = 1,
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 32,
 
-- 
1.7.2.2

