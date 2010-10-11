Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34155 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab0JKR0l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 13:26:41 -0400
Date: Mon, 11 Oct 2010 19:26:30 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/6 v5] V4L/DVB: s5p-fimc: Fix 90/270 deg rotation errors
In-reply-to: <1286817993-21558-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1286817993-21558-4-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1286817993-21558-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Due to errorneous swapping of image dimensions the rotation
control was not handled properly in subsequent calls.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |   15 ++---
 drivers/media/video/s5p-fimc/fimc-reg.c  |  101 +++++++++++++++---------------
 2 files changed, 57 insertions(+), 59 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 99ab46f..6bddec3 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -207,8 +207,13 @@ static int fimc_set_scaler_info(struct fimc_ctx *ctx)
 	int tx, ty, sx, sy;
 	int ret;
 
-	tx = d_frame->width;
-	ty = d_frame->height;
+	if (ctx->rotation == 90 || ctx->rotation == 270) {
+		ty = d_frame->width;
+		tx = d_frame->height;
+	} else {
+		tx = d_frame->width;
+		ty = d_frame->height;
+	}
 	if (tx <= 0 || ty <= 0) {
 		v4l2_err(&ctx->fimc_dev->m2m.v4l2_dev,
 			"invalid target size: %d x %d", tx, ty);
@@ -429,12 +434,6 @@ static int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags)
 	d_frame = &ctx->d_frame;
 
 	if (flags & FIMC_PARAMS) {
-		if ((ctx->out_path == FIMC_DMA) &&
-			(ctx->rotation == 90 || ctx->rotation == 270)) {
-			swap(d_frame->f_width, d_frame->f_height);
-			swap(d_frame->width, d_frame->height);
-		}
-
 		/* Prepare the DMA offset ratios for scaler. */
 		fimc_prepare_dma_offset(ctx, &ctx->s_frame);
 		fimc_prepare_dma_offset(ctx, &ctx->d_frame);
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 94e98d4..95adc84 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -34,44 +34,6 @@ void fimc_hw_reset(struct fimc_dev *dev)
 	cfg = readl(dev->regs + S5P_CIGCTRL);
 	cfg &= ~S5P_CIGCTRL_SWRST;
 	writel(cfg, dev->regs + S5P_CIGCTRL);
-
-}
-
-void fimc_hw_set_rotation(struct fimc_ctx *ctx)
-{
-	u32 cfg, flip;
-	struct fimc_dev *dev = ctx->fimc_dev;
-
-	cfg = readl(dev->regs + S5P_CITRGFMT);
-	cfg &= ~(S5P_CITRGFMT_INROT90 | S5P_CITRGFMT_OUTROT90);
-
-	flip = readl(dev->regs + S5P_MSCTRL);
-	flip &= ~S5P_MSCTRL_FLIP_MASK;
-
-	/*
-	 * The input and output rotator cannot work simultaneously.
-	 * Use the output rotator in output DMA mode or the input rotator
-	 * in direct fifo output mode.
-	 */
-	if (ctx->rotation == 90 || ctx->rotation == 270) {
-		if (ctx->out_path == FIMC_LCDFIFO) {
-			cfg |= S5P_CITRGFMT_INROT90;
-			if (ctx->rotation == 270)
-				flip |= S5P_MSCTRL_FLIP_180;
-		} else {
-			cfg |= S5P_CITRGFMT_OUTROT90;
-			if (ctx->rotation == 270)
-				cfg |= S5P_CITRGFMT_FLIP_180;
-		}
-	} else if (ctx->rotation == 180) {
-		if (ctx->out_path == FIMC_LCDFIFO)
-			flip |= S5P_MSCTRL_FLIP_180;
-		else
-			cfg |= S5P_CITRGFMT_FLIP_180;
-	}
-	if (ctx->rotation == 180 || ctx->rotation == 270)
-		writel(flip, dev->regs + S5P_MSCTRL);
-	writel(cfg, dev->regs + S5P_CITRGFMT);
 }
 
 static u32 fimc_hw_get_in_flip(u32 ctx_flip)
@@ -114,6 +76,46 @@ static u32 fimc_hw_get_target_flip(u32 ctx_flip)
 	return flip;
 }
 
+void fimc_hw_set_rotation(struct fimc_ctx *ctx)
+{
+	u32 cfg, flip;
+	struct fimc_dev *dev = ctx->fimc_dev;
+
+	cfg = readl(dev->regs + S5P_CITRGFMT);
+	cfg &= ~(S5P_CITRGFMT_INROT90 | S5P_CITRGFMT_OUTROT90 |
+		  S5P_CITRGFMT_FLIP_180);
+
+	flip = readl(dev->regs + S5P_MSCTRL);
+	flip &= ~S5P_MSCTRL_FLIP_MASK;
+
+	/*
+	 * The input and output rotator cannot work simultaneously.
+	 * Use the output rotator in output DMA mode or the input rotator
+	 * in direct fifo output mode.
+	 */
+	if (ctx->rotation == 90 || ctx->rotation == 270) {
+		if (ctx->out_path == FIMC_LCDFIFO) {
+			cfg |= S5P_CITRGFMT_INROT90;
+			if (ctx->rotation == 270)
+				flip |= S5P_MSCTRL_FLIP_180;
+		} else {
+			cfg |= S5P_CITRGFMT_OUTROT90;
+			if (ctx->rotation == 270)
+				cfg |= S5P_CITRGFMT_FLIP_180;
+		}
+	} else if (ctx->rotation == 180) {
+		if (ctx->out_path == FIMC_LCDFIFO)
+			flip |= S5P_MSCTRL_FLIP_180;
+		else
+			cfg |= S5P_CITRGFMT_FLIP_180;
+	}
+	if (ctx->rotation == 180 || ctx->rotation == 270)
+		writel(flip, dev->regs + S5P_MSCTRL);
+
+	cfg |= fimc_hw_get_target_flip(ctx->flip);
+	writel(cfg, dev->regs + S5P_CITRGFMT);
+}
+
 void fimc_hw_set_target_format(struct fimc_ctx *ctx)
 {
 	u32 cfg;
@@ -149,13 +151,15 @@ void fimc_hw_set_target_format(struct fimc_ctx *ctx)
 		break;
 	}
 
-	cfg |= S5P_CITRGFMT_HSIZE(frame->width);
-	cfg |= S5P_CITRGFMT_VSIZE(frame->height);
+	if (ctx->rotation == 90 || ctx->rotation == 270) {
+		cfg |= S5P_CITRGFMT_HSIZE(frame->height);
+		cfg |= S5P_CITRGFMT_VSIZE(frame->width);
+	} else {
 
-	if (ctx->rotation == 0) {
-		cfg &= ~S5P_CITRGFMT_FLIP_MASK;
-		cfg |= fimc_hw_get_target_flip(ctx->flip);
+		cfg |= S5P_CITRGFMT_HSIZE(frame->width);
+		cfg |= S5P_CITRGFMT_VSIZE(frame->height);
 	}
+
 	writel(cfg, dev->regs + S5P_CITRGFMT);
 
 	cfg = readl(dev->regs + S5P_CITAREA) & ~S5P_CITAREA_MASK;
@@ -167,15 +171,10 @@ static void fimc_hw_set_out_dma_size(struct fimc_ctx *ctx)
 {
 	struct fimc_dev *dev = ctx->fimc_dev;
 	struct fimc_frame *frame = &ctx->d_frame;
-	u32 cfg = 0;
+	u32 cfg;
 
-	if (ctx->rotation == 90 || ctx->rotation == 270) {
-		cfg |= S5P_ORIG_SIZE_HOR(frame->f_height);
-		cfg |= S5P_ORIG_SIZE_VER(frame->f_width);
-	} else {
-		cfg |= S5P_ORIG_SIZE_HOR(frame->f_width);
-		cfg |= S5P_ORIG_SIZE_VER(frame->f_height);
-	}
+	cfg = S5P_ORIG_SIZE_HOR(frame->f_width);
+	cfg |= S5P_ORIG_SIZE_VER(frame->f_height);
 	writel(cfg, dev->regs + S5P_ORGOSIZE);
 }
 
-- 
1.7.3.1

