Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:61952 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713Ab1KDOUJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 10:20:09 -0400
Date: Fri, 04 Nov 2011 15:19:58 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 4/8] s5p-fimc: Fix buffer dequeue order issue
In-reply-to: <1320416402-22883-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: samsung-soc@vger.kernel.org, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1320416402-22883-5-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1320416402-22883-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When requested more than 2 buffers the buffer dequeue order was wrong
due to erroneous updating FIMC registers in every interrupt handler
call. This also fixes regression of resetting the output DMA buffer
pointer at wrong time, when some buffers are already queued in hardware.
The hardware is reset in the start_streaming callback in order to align
the H/W state with the software output buffer pointer (buf_index).

Additionally a simple write to S5P_CISCCTRL register is replaced with
a read/modification/write to make sure the scaler is not being disabled
in fimc_hw_set_scaler().

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    9 ++++++---
 drivers/media/video/s5p-fimc/fimc-core.c    |    4 ----
 drivers/media/video/s5p-fimc/fimc-reg.c     |   15 ++++++++++++---
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 382dacd..70f741f 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -98,6 +98,10 @@ static int fimc_capture_state_cleanup(struct fimc_dev *fimc, bool suspend)
 			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 	}
 	set_bit(ST_CAPT_SUSPENDED, &fimc->state);
+
+	fimc_hw_reset(fimc);
+	cap->buf_index = 0;
+
 	spin_unlock_irqrestore(&fimc->slock, flags);
 
 	if (streaming)
@@ -137,7 +141,7 @@ int fimc_capture_config_update(struct fimc_ctx *ctx)
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	int ret;
 
-	if (test_bit(ST_CAPT_APPLY_CFG, &fimc->state))
+	if (!test_bit(ST_CAPT_APPLY_CFG, &fimc->state))
 		return 0;
 
 	spin_lock(&ctx->slock);
@@ -150,7 +154,7 @@ int fimc_capture_config_update(struct fimc_ctx *ctx)
 		fimc_hw_set_rotation(ctx);
 		fimc_prepare_dma_offset(ctx, &ctx->d_frame);
 		fimc_hw_set_out_dma(ctx);
-		set_bit(ST_CAPT_APPLY_CFG, &fimc->state);
+		clear_bit(ST_CAPT_APPLY_CFG, &fimc->state);
 	}
 	spin_unlock(&ctx->slock);
 	return ret;
@@ -164,7 +168,6 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
 	int min_bufs;
 	int ret;
 
-	fimc_hw_reset(fimc);
 	vid_cap->frame_count = 0;
 
 	ret = fimc_init_capture(fimc);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index ef53528..9c3a8c5 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1706,8 +1706,6 @@ static int fimc_runtime_resume(struct device *dev)
 	/* Enable clocks and perform basic initalization */
 	clk_enable(fimc->clock[CLK_GATE]);
 	fimc_hw_reset(fimc);
-	if (fimc->variant->out_buf_count > 4)
-		fimc_hw_set_dma_seq(fimc, 0xF);
 
 	/* Resume the capture or mem-to-mem device */
 	if (fimc_capture_busy(fimc))
@@ -1749,8 +1747,6 @@ static int fimc_resume(struct device *dev)
 		return 0;
 	}
 	fimc_hw_reset(fimc);
-	if (fimc->variant->out_buf_count > 4)
-		fimc_hw_set_dma_seq(fimc, 0xF);
 	spin_unlock_irqrestore(&fimc->slock, flags);
 
 	if (fimc_capture_busy(fimc))
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 20e664e..44f5c2d 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -35,6 +35,9 @@ void fimc_hw_reset(struct fimc_dev *dev)
 	cfg = readl(dev->regs + S5P_CIGCTRL);
 	cfg &= ~S5P_CIGCTRL_SWRST;
 	writel(cfg, dev->regs + S5P_CIGCTRL);
+
+	if (dev->variant->out_buf_count > 4)
+		fimc_hw_set_dma_seq(dev, 0xF);
 }
 
 static u32 fimc_hw_get_in_flip(struct fimc_ctx *ctx)
@@ -251,7 +254,14 @@ static void fimc_hw_set_scaler(struct fimc_ctx *ctx)
 	struct fimc_scaler *sc = &ctx->scaler;
 	struct fimc_frame *src_frame = &ctx->s_frame;
 	struct fimc_frame *dst_frame = &ctx->d_frame;
-	u32 cfg = 0;
+
+	u32 cfg = readl(dev->regs + S5P_CISCCTRL);
+
+	cfg &= ~(S5P_CISCCTRL_CSCR2Y_WIDE | S5P_CISCCTRL_CSCY2R_WIDE |
+		 S5P_CISCCTRL_SCALEUP_H | S5P_CISCCTRL_SCALEUP_V |
+		 S5P_CISCCTRL_SCALERBYPASS | S5P_CISCCTRL_ONE2ONE |
+		 S5P_CISCCTRL_INRGB_FMT_MASK | S5P_CISCCTRL_OUTRGB_FMT_MASK |
+		 S5P_CISCCTRL_INTERLACE | S5P_CISCCTRL_RGB_EXT);
 
 	if (!(ctx->flags & FIMC_COLOR_RANGE_NARROW))
 		cfg |= (S5P_CISCCTRL_CSCR2Y_WIDE | S5P_CISCCTRL_CSCY2R_WIDE);
@@ -308,9 +318,9 @@ void fimc_hw_set_mainscaler(struct fimc_ctx *ctx)
 	fimc_hw_set_scaler(ctx);
 
 	cfg = readl(dev->regs + S5P_CISCCTRL);
+	cfg &= ~(S5P_CISCCTRL_MHRATIO_MASK | S5P_CISCCTRL_MVRATIO_MASK);
 
 	if (variant->has_mainscaler_ext) {
-		cfg &= ~(S5P_CISCCTRL_MHRATIO_MASK | S5P_CISCCTRL_MVRATIO_MASK);
 		cfg |= S5P_CISCCTRL_MHRATIO_EXT(sc->main_hratio);
 		cfg |= S5P_CISCCTRL_MVRATIO_EXT(sc->main_vratio);
 		writel(cfg, dev->regs + S5P_CISCCTRL);
@@ -323,7 +333,6 @@ void fimc_hw_set_mainscaler(struct fimc_ctx *ctx)
 		cfg |= S5P_CIEXTEN_MVRATIO_EXT(sc->main_vratio);
 		writel(cfg, dev->regs + S5P_CIEXTEN);
 	} else {
-		cfg &= ~(S5P_CISCCTRL_MHRATIO_MASK | S5P_CISCCTRL_MVRATIO_MASK);
 		cfg |= S5P_CISCCTRL_MHRATIO(sc->main_hratio);
 		cfg |= S5P_CISCCTRL_MVRATIO(sc->main_vratio);
 		writel(cfg, dev->regs + S5P_CISCCTRL);
-- 
1.7.7.1

