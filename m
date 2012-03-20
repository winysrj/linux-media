Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:62043 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758618Ab2CTKjN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 06:39:13 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M1600FUDIWRWA@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Mar 2012 10:38:51 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M16002P6IX8BS@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Mar 2012 10:39:09 +0000 (GMT)
Date: Tue, 20 Mar 2012 11:39:03 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 4/6] s5p-fimc: Refactor hardware setup for m2m transaction
In-reply-to: <1332239945-32711-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1332239945-32711-5-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1332239945-32711-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove redundant H/W setup logic by merging fimc_prepare_config()
and the device_run() callback.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |   77 ++++++++----------------------
 drivers/media/video/s5p-fimc/fimc-core.h |    2 -
 2 files changed, 21 insertions(+), 58 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 8a5951f..21691e4 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -582,55 +582,11 @@ void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f)
 	    f->fmt->color, f->dma_offset.y_h, f->dma_offset.y_v);
 }
 
-/**
- * fimc_prepare_config - check dimensions, operation and color mode
- *			 and pre-calculate offset and the scaling coefficients.
- *
- * @ctx: hardware context information
- * @flags: flags indicating which parameters to check/update
- *
- * Return: 0 if dimensions are valid or non zero otherwise.
- */
-int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags)
-{
-	struct fimc_frame *s_frame, *d_frame;
-	struct vb2_buffer *vb = NULL;
-	int ret = 0;
-
-	s_frame = &ctx->s_frame;
-	d_frame = &ctx->d_frame;
-
-	if (flags & FIMC_PARAMS) {
-		/* Prepare the DMA offset ratios for scaler. */
-		fimc_prepare_dma_offset(ctx, &ctx->s_frame);
-		fimc_prepare_dma_offset(ctx, &ctx->d_frame);
-
-		if (s_frame->height > (SCALER_MAX_VRATIO * d_frame->height) ||
-		    s_frame->width > (SCALER_MAX_HRATIO * d_frame->width)) {
-			err("out of scaler range");
-			return -EINVAL;
-		}
-		fimc_set_yuv_order(ctx);
-	}
-
-	if (flags & FIMC_SRC_ADDR) {
-		vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
-		ret = fimc_prepare_addr(ctx, vb, s_frame, &s_frame->paddr);
-		if (ret)
-			return ret;
-	}
-
-	if (flags & FIMC_DST_ADDR) {
-		vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
-		ret = fimc_prepare_addr(ctx, vb, d_frame, &d_frame->paddr);
-	}
-
-	return ret;
-}
-
 static void fimc_dma_run(void *priv)
 {
+	struct vb2_buffer *vb = NULL;
 	struct fimc_ctx *ctx = priv;
+	struct fimc_frame *sf, *df;
 	struct fimc_dev *fimc;
 	unsigned long flags;
 	u32 ret;
@@ -641,9 +597,22 @@ static void fimc_dma_run(void *priv)
 	fimc = ctx->fimc_dev;
 	spin_lock_irqsave(&fimc->slock, flags);
 	set_bit(ST_M2M_PEND, &fimc->state);
+	sf = &ctx->s_frame;
+	df = &ctx->d_frame;
+
+	if (ctx->state & FIMC_PARAMS) {
+		/* Prepare the DMA offsets for scaler */
+		fimc_prepare_dma_offset(ctx, sf);
+		fimc_prepare_dma_offset(ctx, df);
+	}
 
-	ctx->state |= (FIMC_SRC_ADDR | FIMC_DST_ADDR);
-	ret = fimc_prepare_config(ctx, ctx->state);
+	vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	ret = fimc_prepare_addr(ctx, vb, sf, &sf->paddr);
+	if (ret)
+		goto dma_unlock;
+
+	vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	ret = fimc_prepare_addr(ctx, vb, df, &df->paddr);
 	if (ret)
 		goto dma_unlock;
 
@@ -652,9 +621,9 @@ static void fimc_dma_run(void *priv)
 		ctx->state |= FIMC_PARAMS;
 		fimc->m2m.ctx = ctx;
 	}
-	fimc_hw_set_input_addr(fimc, &ctx->s_frame.paddr);
 
 	if (ctx->state & FIMC_PARAMS) {
+		fimc_set_yuv_order(ctx);
 		fimc_hw_set_input_path(ctx);
 		fimc_hw_set_in_dma(ctx);
 		ret = fimc_set_scaler_info(ctx);
@@ -665,17 +634,13 @@ static void fimc_dma_run(void *priv)
 		fimc_hw_set_target_format(ctx);
 		fimc_hw_set_rotation(ctx);
 		fimc_hw_set_effect(ctx, false);
-	}
-
-	fimc_hw_set_output_path(ctx);
-	if (ctx->state & (FIMC_DST_ADDR | FIMC_PARAMS))
-		fimc_hw_set_output_addr(fimc, &ctx->d_frame.paddr, -1);
-
-	if (ctx->state & FIMC_PARAMS) {
 		fimc_hw_set_out_dma(ctx);
 		if (fimc->variant->has_alpha)
 			fimc_hw_set_rgb_alpha(ctx);
+		fimc_hw_set_output_path(ctx);
 	}
+	fimc_hw_set_input_addr(fimc, &sf->paddr);
+	fimc_hw_set_output_addr(fimc, &df->paddr, -1);
 
 	fimc_activate_capture(ctx);
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 54198c7..101c930 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -119,8 +119,6 @@ enum fimc_color_fmt {
 
 /* The hardware context state. */
 #define	FIMC_PARAMS		(1 << 0)
-#define	FIMC_SRC_ADDR		(1 << 1)
-#define	FIMC_DST_ADDR		(1 << 2)
 #define	FIMC_SRC_FMT		(1 << 3)
 #define	FIMC_DST_FMT		(1 << 4)
 #define	FIMC_DST_CROP		(1 << 5)
-- 
1.7.9.2

