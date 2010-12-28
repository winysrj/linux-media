Return-path: <mchehab@gaivota>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20175 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab0L1RD1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 12:03:27 -0500
Date: Tue, 28 Dec 2010 18:03:16 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 11/15] [media] s5p-fimc: Enable simultaneous rotation and
 flipping
In-reply-to: <1293555798-31578-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1293555798-31578-12-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1293555798-31578-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Map all (0, 90, 180, 270) deg counterclockwise rotation and
horizontal and vertical flip controls to (0, 90) deg rotation,
horizontal and vertical flip transformations available in the device.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |    9 +---
 drivers/media/video/s5p-fimc/fimc-reg.c  |   76 ++++++++++++------------------
 2 files changed, 32 insertions(+), 53 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 7899814..b273fe1 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1051,13 +1051,6 @@ int fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_control *ctrl)
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	unsigned long flags;
 
-	if (ctx->rotation != 0 &&
-	    (ctrl->id == V4L2_CID_HFLIP || ctrl->id == V4L2_CID_VFLIP)) {
-		v4l2_err(&fimc->m2m.v4l2_dev,
-			 "Simultaneous flip and rotation is not supported\n");
-		return -EINVAL;
-	}
-
 	spin_lock_irqsave(&ctx->slock, flags);
 
 	switch (ctrl->id) {
@@ -1098,7 +1091,7 @@ int fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_control *ctrl)
 }
 
 static int fimc_m2m_s_ctrl(struct file *file, void *priv,
-			 struct v4l2_control *ctrl)
+			   struct v4l2_control *ctrl)
 {
 	struct fimc_ctx *ctx = priv;
 	int ret = 0;
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 11422e9..a64d41c 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -37,11 +37,11 @@ void fimc_hw_reset(struct fimc_dev *dev)
 	writel(cfg, dev->regs + S5P_CIGCTRL);
 }
 
-static u32 fimc_hw_get_in_flip(u32 ctx_flip)
+static u32 fimc_hw_get_in_flip(struct fimc_ctx *ctx)
 {
 	u32 flip = S5P_MSCTRL_FLIP_NORMAL;
 
-	switch (ctx_flip) {
+	switch (ctx->flip) {
 	case FLIP_X_AXIS:
 		flip = S5P_MSCTRL_FLIP_X_MIRROR;
 		break;
@@ -51,16 +51,20 @@ static u32 fimc_hw_get_in_flip(u32 ctx_flip)
 	case FLIP_XY_AXIS:
 		flip = S5P_MSCTRL_FLIP_180;
 		break;
+	default:
+		return flip;
 	}
+	if (ctx->rotation <= 90)
+		return flip;
 
-	return flip;
+	return (flip ^ S5P_MSCTRL_FLIP_180) & S5P_MSCTRL_FLIP_180;
 }
 
-static u32 fimc_hw_get_target_flip(u32 ctx_flip)
+static u32 fimc_hw_get_target_flip(struct fimc_ctx *ctx)
 {
 	u32 flip = S5P_CITRGFMT_FLIP_NORMAL;
 
-	switch (ctx_flip) {
+	switch (ctx->flip) {
 	case FLIP_X_AXIS:
 		flip = S5P_CITRGFMT_FLIP_X_MIRROR;
 		break;
@@ -70,11 +74,13 @@ static u32 fimc_hw_get_target_flip(u32 ctx_flip)
 	case FLIP_XY_AXIS:
 		flip = S5P_CITRGFMT_FLIP_180;
 		break;
-	case FLIP_NONE:
-		break;
-
+	default:
+		return flip;
 	}
-	return flip;
+	if (ctx->rotation <= 90)
+		return flip;
+
+	return (flip ^ S5P_CITRGFMT_FLIP_180) & S5P_CITRGFMT_FLIP_180;
 }
 
 void fimc_hw_set_rotation(struct fimc_ctx *ctx)
@@ -84,10 +90,7 @@ void fimc_hw_set_rotation(struct fimc_ctx *ctx)
 
 	cfg = readl(dev->regs + S5P_CITRGFMT);
 	cfg &= ~(S5P_CITRGFMT_INROT90 | S5P_CITRGFMT_OUTROT90 |
-		  S5P_CITRGFMT_FLIP_180);
-
-	flip = readl(dev->regs + S5P_MSCTRL);
-	flip &= ~S5P_MSCTRL_FLIP_MASK;
+		 S5P_CITRGFMT_FLIP_180);
 
 	/*
 	 * The input and output rotator cannot work simultaneously.
@@ -95,26 +98,22 @@ void fimc_hw_set_rotation(struct fimc_ctx *ctx)
 	 * in direct fifo output mode.
 	 */
 	if (ctx->rotation == 90 || ctx->rotation == 270) {
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
 		if (ctx->out_path == FIMC_LCDFIFO)
-			flip |= S5P_MSCTRL_FLIP_180;
+			cfg |= S5P_CITRGFMT_INROT90;
 		else
-			cfg |= S5P_CITRGFMT_FLIP_180;
+			cfg |= S5P_CITRGFMT_OUTROT90;
 	}
-	if (ctx->rotation == 180 || ctx->rotation == 270)
-		writel(flip, dev->regs + S5P_MSCTRL);
 
-	cfg |= fimc_hw_get_target_flip(ctx->flip);
-	writel(cfg, dev->regs + S5P_CITRGFMT);
+	if (ctx->out_path == FIMC_DMA) {
+		cfg |= fimc_hw_get_target_flip(ctx);
+		writel(cfg, dev->regs + S5P_CITRGFMT);
+	} else {
+		/* LCD FIFO path */
+		flip = readl(dev->regs + S5P_MSCTRL);
+		flip &= ~S5P_MSCTRL_FLIP_MASK;
+		flip |= fimc_hw_get_in_flip(ctx);
+		writel(flip, dev->regs + S5P_MSCTRL);
+	}
 }
 
 void fimc_hw_set_target_format(struct fimc_ctx *ctx)
@@ -131,18 +130,13 @@ void fimc_hw_set_target_format(struct fimc_ctx *ctx)
 		  S5P_CITRGFMT_VSIZE_MASK);
 
 	switch (frame->fmt->color) {
-	case S5P_FIMC_RGB565:
-	case S5P_FIMC_RGB666:
-	case S5P_FIMC_RGB888:
+	case S5P_FIMC_RGB565...S5P_FIMC_RGB888:
 		cfg |= S5P_CITRGFMT_RGB;
 		break;
 	case S5P_FIMC_YCBCR420:
 		cfg |= S5P_CITRGFMT_YCBCR420;
 		break;
-	case S5P_FIMC_YCBYCR422:
-	case S5P_FIMC_YCRYCB422:
-	case S5P_FIMC_CBYCRY422:
-	case S5P_FIMC_CRYCBY422:
+	case S5P_FIMC_YCBYCR422...S5P_FIMC_CRYCBY422:
 		if (frame->fmt->colplanes == 1)
 			cfg |= S5P_CITRGFMT_YCBCR422_1P;
 		else
@@ -410,8 +404,7 @@ void fimc_hw_set_in_dma(struct fimc_ctx *ctx)
 
 	/* Set the input DMA to process single frame only. */
 	cfg = readl(dev->regs + S5P_MSCTRL);
-	cfg &= ~(S5P_MSCTRL_FLIP_MASK
-		| S5P_MSCTRL_INFORMAT_MASK
+	cfg &= ~(S5P_MSCTRL_INFORMAT_MASK
 		| S5P_MSCTRL_IN_BURST_COUNT_MASK
 		| S5P_MSCTRL_INPUT_MASK
 		| S5P_MSCTRL_C_INT_IN_MASK
@@ -450,13 +443,6 @@ void fimc_hw_set_in_dma(struct fimc_ctx *ctx)
 		break;
 	}
 
-	/*
-	 * Input DMA flip mode (and rotation).
-	 * Do not allow simultaneous rotation and flipping.
-	 */
-	if (!ctx->rotation && ctx->out_path == FIMC_LCDFIFO)
-		cfg |= fimc_hw_get_in_flip(ctx->flip);
-
 	writel(cfg, dev->regs + S5P_MSCTRL);
 
 	/* Input/output DMA linear/tiled mode. */
-- 
1.7.2.3

