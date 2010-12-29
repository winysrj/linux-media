Return-path: <mchehab@gaivota>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29488 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab0L2RdG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 12:33:06 -0500
Date: Wed, 29 Dec 2010 18:32:55 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 15/15 v2] [media] s5p-fimc: Move scaler details handling to the
 register API file
In-reply-to: <1293643975-4528-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1293643975-4528-14-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1293643975-4528-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    6 +---
 drivers/media/video/s5p-fimc/fimc-core.c    |    6 +---
 drivers/media/video/s5p-fimc/fimc-core.h    |    1 -
 drivers/media/video/s5p-fimc/fimc-reg.c     |   49 ++++++++++-----------------
 4 files changed, 20 insertions(+), 42 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index a948c7c..aadbee1 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -238,7 +238,6 @@ static int start_streaming(struct vb2_queue *q)
 	struct fimc_ctx *ctx = q->drv_priv;
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct s5p_fimc_isp_info *isp_info;
-	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
 	int ret;
 
 	ret = v4l2_subdev_call(fimc->vid_cap.sd, video, s_stream, 1);
@@ -262,10 +261,7 @@ static int start_streaming(struct vb2_queue *q)
 		}
 		fimc_hw_set_input_path(ctx);
 		fimc_hw_set_prescaler(ctx);
-		if (variant->has_mainscaler_ext)
-			fimc_hw_set_mainscaler_ext(ctx);
-		else
-			fimc_hw_set_mainscaler(ctx);
+		fimc_hw_set_mainscaler(ctx);
 		fimc_hw_set_target_format(ctx);
 		fimc_hw_set_rotation(ctx);
 		fimc_hw_set_effect(ctx);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 8296646..a6b3d49 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -578,7 +578,6 @@ static void fimc_dma_run(void *priv)
 {
 	struct fimc_ctx *ctx = priv;
 	struct fimc_dev *fimc;
-	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
 	unsigned long flags;
 	u32 ret;
 
@@ -613,10 +612,7 @@ static void fimc_dma_run(void *priv)
 		}
 
 		fimc_hw_set_prescaler(ctx);
-		if (variant->has_mainscaler_ext)
-			fimc_hw_set_mainscaler_ext(ctx);
-		else
-			fimc_hw_set_mainscaler(ctx);
+		fimc_hw_set_mainscaler(ctx);
 		fimc_hw_set_target_format(ctx);
 		fimc_hw_set_rotation(ctx);
 		fimc_hw_set_effect(ctx);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 5ad2762..20144d6 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -575,7 +575,6 @@ void fimc_hw_en_lastirq(struct fimc_dev *fimc, int enable);
 void fimc_hw_en_irq(struct fimc_dev *fimc, int enable);
 void fimc_hw_set_prescaler(struct fimc_ctx *ctx);
 void fimc_hw_set_mainscaler(struct fimc_ctx *ctx);
-void fimc_hw_set_mainscaler_ext(struct fimc_ctx *ctx);
 void fimc_hw_en_capture(struct fimc_ctx *ctx);
 void fimc_hw_set_effect(struct fimc_ctx *ctx);
 void fimc_hw_set_in_dma(struct fimc_ctx *ctx);
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index a4ea838..68866ea 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -314,6 +314,7 @@ static void fimc_hw_set_scaler(struct fimc_ctx *ctx)
 void fimc_hw_set_mainscaler(struct fimc_ctx *ctx)
 {
 	struct fimc_dev *dev = ctx->fimc_dev;
+	struct samsung_fimc_variant *variant = dev->variant;
 	struct fimc_scaler *sc = &ctx->scaler;
 	u32 cfg;
 
@@ -323,40 +324,26 @@ void fimc_hw_set_mainscaler(struct fimc_ctx *ctx)
 	fimc_hw_set_scaler(ctx);
 
 	cfg = readl(dev->regs + S5P_CISCCTRL);
-	cfg &= ~S5P_CISCCTRL_MHRATIO_MASK;
-	cfg &= ~S5P_CISCCTRL_MVRATIO_MASK;
-	cfg |= S5P_CISCCTRL_MHRATIO(sc->main_hratio);
-	cfg |= S5P_CISCCTRL_MVRATIO(sc->main_vratio);
 
-	writel(cfg, dev->regs + S5P_CISCCTRL);
-}
+	if (variant->has_mainscaler_ext) {
+		cfg &= ~(S5P_CISCCTRL_MHRATIO_MASK | S5P_CISCCTRL_MVRATIO_MASK);
+		cfg |= S5P_CISCCTRL_MHRATIO_EXT(sc->main_hratio);
+		cfg |= S5P_CISCCTRL_MVRATIO_EXT(sc->main_vratio);
+		writel(cfg, dev->regs + S5P_CISCCTRL);
 
-void fimc_hw_set_mainscaler_ext(struct fimc_ctx *ctx)
-{
-	struct fimc_dev *dev = ctx->fimc_dev;
-	struct fimc_scaler *sc = &ctx->scaler;
-	u32 cfg, cfg_ext;
+		cfg = readl(dev->regs + S5P_CIEXTEN);
 
-	dbg("main_hratio= 0x%X  main_vratio= 0x%X",
-		sc->main_hratio, sc->main_vratio);
-
-	fimc_hw_set_scaler(ctx);
-
-	cfg = readl(dev->regs + S5P_CISCCTRL);
-	cfg &= ~S5P_CISCCTRL_MHRATIO_MASK;
-	cfg &= ~S5P_CISCCTRL_MVRATIO_MASK;
-	cfg |= S5P_CISCCTRL_MHRATIO_EXT(sc->main_hratio);
-	cfg |= S5P_CISCCTRL_MVRATIO_EXT(sc->main_vratio);
-
-	writel(cfg, dev->regs + S5P_CISCCTRL);
-
-	cfg_ext = readl(dev->regs + S5P_CIEXTEN);
-	cfg_ext &= ~S5P_CIEXTEN_MHRATIO_EXT_MASK;
-	cfg_ext &= ~S5P_CIEXTEN_MVRATIO_EXT_MASK;
-	cfg_ext |= S5P_CIEXTEN_MHRATIO_EXT(sc->main_hratio);
-	cfg_ext |= S5P_CIEXTEN_MVRATIO_EXT(sc->main_vratio);
-
-	writel(cfg_ext, dev->regs + S5P_CIEXTEN);
+		cfg &= ~(S5P_CIEXTEN_MVRATIO_EXT_MASK |
+			 S5P_CIEXTEN_MHRATIO_EXT_MASK);
+		cfg |= S5P_CIEXTEN_MHRATIO_EXT(sc->main_hratio);
+		cfg |= S5P_CIEXTEN_MVRATIO_EXT(sc->main_vratio);
+		writel(cfg, dev->regs + S5P_CIEXTEN);
+	} else {
+		cfg &= ~(S5P_CISCCTRL_MHRATIO_MASK | S5P_CISCCTRL_MVRATIO_MASK);
+		cfg |= S5P_CISCCTRL_MHRATIO(sc->main_hratio);
+		cfg |= S5P_CISCCTRL_MVRATIO(sc->main_vratio);
+		writel(cfg, dev->regs + S5P_CISCCTRL);
+	}
 }
 
 void fimc_hw_en_capture(struct fimc_ctx *ctx)
-- 
1.7.2.3

