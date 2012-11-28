Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:46814 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab2K1TJs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 14:09:48 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ME700HZQP81F3B0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:09:47 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0ME7006TUP7TOU90@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:09:47 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 04/12] s5p-fimc: Clean up capture enable/disable helpers
Date: Wed, 28 Nov 2012 20:09:21 +0100
Message-id: <1354129766-2821-5-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1354129766-2821-1-git-send-email-s.nawrocki@samsung.com>
References: <1354129766-2821-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The FIMC FIFO output is not supported in the driver due to
some hardware issues thus we can remove some code as out_path
is always FIMC_IO_DMA.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-reg.c |   38 ++++++++++++----------------
 drivers/media/platform/s5p-fimc/fimc-reg.h |    4 +--
 2 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-reg.c b/drivers/media/platform/s5p-fimc/fimc-reg.c
index 9c3c461..f0c34ca 100644
--- a/drivers/media/platform/s5p-fimc/fimc-reg.c
+++ b/drivers/media/platform/s5p-fimc/fimc-reg.c
@@ -344,30 +344,31 @@ void fimc_hw_set_mainscaler(struct fimc_ctx *ctx)
 	}
 }
 
-void fimc_hw_en_capture(struct fimc_ctx *ctx)
+void fimc_hw_enable_capture(struct fimc_ctx *ctx)
 {
 	struct fimc_dev *dev = ctx->fimc_dev;
+	u32 cfg;
 
-	u32 cfg = readl(dev->regs + FIMC_REG_CIIMGCPT);
-
-	if (ctx->out_path == FIMC_IO_DMA) {
-		/* one shot mode */
-		cfg |= FIMC_REG_CIIMGCPT_CPT_FREN_ENABLE |
-			FIMC_REG_CIIMGCPT_IMGCPTEN;
-	} else {
-		/* Continuous frame capture mode (freerun). */
-		cfg &= ~(FIMC_REG_CIIMGCPT_CPT_FREN_ENABLE |
-			 FIMC_REG_CIIMGCPT_CPT_FRMOD_CNT);
-		cfg |= FIMC_REG_CIIMGCPT_IMGCPTEN;
-	}
+	cfg = readl(dev->regs + FIMC_REG_CIIMGCPT);
+	cfg |= FIMC_REG_CIIMGCPT_CPT_FREN_ENABLE;
 
 	if (ctx->scaler.enabled)
 		cfg |= FIMC_REG_CIIMGCPT_IMGCPTEN_SC;
+	else
+		cfg &= FIMC_REG_CIIMGCPT_IMGCPTEN_SC;
 
 	cfg |= FIMC_REG_CIIMGCPT_IMGCPTEN;
 	writel(cfg, dev->regs + FIMC_REG_CIIMGCPT);
 }
 
+void fimc_hw_disable_capture(struct fimc_dev *dev)
+{
+	u32 cfg = readl(dev->regs + FIMC_REG_CIIMGCPT);
+	cfg &= ~(FIMC_REG_CIIMGCPT_IMGCPTEN |
+		 FIMC_REG_CIIMGCPT_IMGCPTEN_SC);
+	writel(cfg, dev->regs + FIMC_REG_CIIMGCPT);
+}
+
 void fimc_hw_set_effect(struct fimc_ctx *ctx)
 {
 	struct fimc_dev *dev = ctx->fimc_dev;
@@ -737,13 +738,6 @@ void fimc_hw_activate_input_dma(struct fimc_dev *dev, bool on)
 	writel(cfg, dev->regs + FIMC_REG_MSCTRL);
 }
 
-void fimc_hw_dis_capture(struct fimc_dev *dev)
-{
-	u32 cfg = readl(dev->regs + FIMC_REG_CIIMGCPT);
-	cfg &= ~(FIMC_REG_CIIMGCPT_IMGCPTEN | FIMC_REG_CIIMGCPT_IMGCPTEN_SC);
-	writel(cfg, dev->regs + FIMC_REG_CIIMGCPT);
-}
-
 /* Return an index to the buffer actually being written. */
 s32 fimc_hw_get_frame_index(struct fimc_dev *dev)
 {
@@ -776,13 +770,13 @@ s32 fimc_hw_get_prev_frame_index(struct fimc_dev *dev)
 void fimc_activate_capture(struct fimc_ctx *ctx)
 {
 	fimc_hw_enable_scaler(ctx->fimc_dev, ctx->scaler.enabled);
-	fimc_hw_en_capture(ctx);
+	fimc_hw_enable_capture(ctx);
 }
 
 void fimc_deactivate_capture(struct fimc_dev *fimc)
 {
 	fimc_hw_en_lastirq(fimc, true);
-	fimc_hw_dis_capture(fimc);
+	fimc_hw_disable_capture(fimc);
 	fimc_hw_enable_scaler(fimc, false);
 	fimc_hw_en_lastirq(fimc, false);
 }
diff --git a/drivers/media/platform/s5p-fimc/fimc-reg.h b/drivers/media/platform/s5p-fimc/fimc-reg.h
index b6abfc7..f3e0b78 100644
--- a/drivers/media/platform/s5p-fimc/fimc-reg.h
+++ b/drivers/media/platform/s5p-fimc/fimc-reg.h
@@ -287,7 +287,7 @@ void fimc_hw_en_lastirq(struct fimc_dev *fimc, int enable);
 void fimc_hw_en_irq(struct fimc_dev *fimc, int enable);
 void fimc_hw_set_prescaler(struct fimc_ctx *ctx);
 void fimc_hw_set_mainscaler(struct fimc_ctx *ctx);
-void fimc_hw_en_capture(struct fimc_ctx *ctx);
+void fimc_hw_enable_capture(struct fimc_ctx *ctx);
 void fimc_hw_set_effect(struct fimc_ctx *ctx);
 void fimc_hw_set_rgb_alpha(struct fimc_ctx *ctx);
 void fimc_hw_set_in_dma(struct fimc_ctx *ctx);
@@ -306,7 +306,7 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 void fimc_hw_clear_irq(struct fimc_dev *dev);
 void fimc_hw_enable_scaler(struct fimc_dev *dev, bool on);
 void fimc_hw_activate_input_dma(struct fimc_dev *dev, bool on);
-void fimc_hw_dis_capture(struct fimc_dev *dev);
+void fimc_hw_disable_capture(struct fimc_dev *dev);
 s32 fimc_hw_get_frame_index(struct fimc_dev *dev);
 s32 fimc_hw_get_prev_frame_index(struct fimc_dev *dev);
 void fimc_activate_capture(struct fimc_ctx *ctx);
-- 
1.7.9.5

