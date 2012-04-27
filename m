Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:11061 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760002Ab2D0JxT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 05:53:19 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M34002RUU2983@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:51:46 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M34009KSU4ONJ@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:53:13 +0100 (BST)
Date: Fri, 27 Apr 2012 11:52:58 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 05/13] s5p-fimc: Refactor the register interface functions
In-reply-to: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	sungchun.kang@samsung.com, subash.ramaswamy@linaro.org,
	s.nawrocki@samsung.com
Message-id: <1335520386-20835-6-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify the register API and use FIMC_REG_ prefix for all register
definitions for consistency with FIMC-LITE. The unused image effect
defines are removed.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    1 +
 drivers/media/video/s5p-fimc/fimc-core.c    |   21 +-
 drivers/media/video/s5p-fimc/fimc-core.h    |  118 ------
 drivers/media/video/s5p-fimc/fimc-m2m.c     |    1 +
 drivers/media/video/s5p-fimc/fimc-reg.c     |  559 +++++++++++++++------------
 drivers/media/video/s5p-fimc/fimc-reg.h     |  326 ++++++++++++++++
 drivers/media/video/s5p-fimc/regs-fimc.h    |  301 ---------------
 7 files changed, 643 insertions(+), 684 deletions(-)
 create mode 100644 drivers/media/video/s5p-fimc/fimc-reg.h
 delete mode 100644 drivers/media/video/s5p-fimc/regs-fimc.h

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 121f101..fca8c4b 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -29,6 +29,7 @@
 
 #include "fimc-mdevice.h"
 #include "fimc-core.h"
+#include "fimc-reg.h"
 
 static int fimc_init_capture(struct fimc_dev *fimc)
 {
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index a733ce4..e4c58e9 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -28,6 +28,7 @@
 #include <media/videobuf2-dma-contig.h>
 
 #include "fimc-core.h"
+#include "fimc-reg.h"
 #include "fimc-mdevice.h"
 
 static char *fimc_clocks[MAX_FIMC_CLOCKS] = {
@@ -386,40 +387,40 @@ int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 void fimc_set_yuv_order(struct fimc_ctx *ctx)
 {
 	/* The one only mode supported in SoC. */
-	ctx->in_order_2p = S5P_FIMC_LSB_CRCB;
-	ctx->out_order_2p = S5P_FIMC_LSB_CRCB;
+	ctx->in_order_2p = FIMC_REG_CIOCTRL_ORDER422_2P_LSB_CRCB;
+	ctx->out_order_2p = FIMC_REG_CIOCTRL_ORDER422_2P_LSB_CRCB;
 
 	/* Set order for 1 plane input formats. */
 	switch (ctx->s_frame.fmt->color) {
 	case S5P_FIMC_YCRYCB422:
-		ctx->in_order_1p = S5P_MSCTRL_ORDER422_CBYCRY;
+		ctx->in_order_1p = FIMC_REG_MSCTRL_ORDER422_CBYCRY;
 		break;
 	case S5P_FIMC_CBYCRY422:
-		ctx->in_order_1p = S5P_MSCTRL_ORDER422_YCRYCB;
+		ctx->in_order_1p = FIMC_REG_MSCTRL_ORDER422_YCRYCB;
 		break;
 	case S5P_FIMC_CRYCBY422:
-		ctx->in_order_1p = S5P_MSCTRL_ORDER422_YCBYCR;
+		ctx->in_order_1p = FIMC_REG_MSCTRL_ORDER422_YCBYCR;
 		break;
 	case S5P_FIMC_YCBYCR422:
 	default:
-		ctx->in_order_1p = S5P_MSCTRL_ORDER422_CRYCBY;
+		ctx->in_order_1p = FIMC_REG_MSCTRL_ORDER422_CRYCBY;
 		break;
 	}
 	dbg("ctx->in_order_1p= %d", ctx->in_order_1p);
 
 	switch (ctx->d_frame.fmt->color) {
 	case S5P_FIMC_YCRYCB422:
-		ctx->out_order_1p = S5P_CIOCTRL_ORDER422_CBYCRY;
+		ctx->out_order_1p = FIMC_REG_CIOCTRL_ORDER422_CBYCRY;
 		break;
 	case S5P_FIMC_CBYCRY422:
-		ctx->out_order_1p = S5P_CIOCTRL_ORDER422_YCRYCB;
+		ctx->out_order_1p = FIMC_REG_CIOCTRL_ORDER422_YCRYCB;
 		break;
 	case S5P_FIMC_CRYCBY422:
-		ctx->out_order_1p = S5P_CIOCTRL_ORDER422_YCBYCR;
+		ctx->out_order_1p = FIMC_REG_CIOCTRL_ORDER422_YCBYCR;
 		break;
 	case S5P_FIMC_YCBYCR422:
 	default:
-		ctx->out_order_1p = S5P_CIOCTRL_ORDER422_CRYCBY;
+		ctx->out_order_1p = FIMC_REG_CIOCTRL_ORDER422_CRYCBY;
 		break;
 	}
 	dbg("ctx->out_order_1p= %d", ctx->out_order_1p);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index ab38e6e..b3f0a98 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -26,8 +26,6 @@
 #include <media/v4l2-mediabus.h>
 #include <media/s5p_fimc.h>
 
-#include "regs-fimc.h"
-
 #define err(fmt, args...) \
 	printk(KERN_ERR "%s:%d: " fmt "\n", __func__, __LINE__, ##args)
 
@@ -106,17 +104,6 @@ enum fimc_color_fmt {
 #define IS_M2M(__strt) ((__strt) == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE || \
 			__strt == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 
-/* Cb/Cr chrominance components order for 2 plane Y/CbCr 4:2:2 formats. */
-#define	S5P_FIMC_LSB_CRCB	S5P_CIOCTRL_ORDER422_2P_LSB_CRCB
-
-/* The embedded image effect selection */
-#define	S5P_FIMC_EFFECT_ORIGINAL	S5P_CIIMGEFF_FIN_BYPASS
-#define	S5P_FIMC_EFFECT_ARBITRARY	S5P_CIIMGEFF_FIN_ARBITRARY
-#define	S5P_FIMC_EFFECT_NEGATIVE	S5P_CIIMGEFF_FIN_NEGATIVE
-#define	S5P_FIMC_EFFECT_ARTFREEZE	S5P_CIIMGEFF_FIN_ARTFREEZE
-#define	S5P_FIMC_EFFECT_EMBOSSING	S5P_CIIMGEFF_FIN_EMBOSSING
-#define	S5P_FIMC_EFFECT_SIKHOUETTE	S5P_CIIMGEFF_FIN_SILHOUETTE
-
 /* The hardware context state. */
 #define	FIMC_PARAMS		(1 << 0)
 #define	FIMC_SRC_FMT		(1 << 3)
@@ -584,54 +571,6 @@ static inline int fimc_get_alpha_mask(struct fimc_fmt *fmt)
 	};
 }
 
-static inline void fimc_hw_clear_irq(struct fimc_dev *dev)
-{
-	u32 cfg = readl(dev->regs + S5P_CIGCTRL);
-	cfg |= S5P_CIGCTRL_IRQ_CLR;
-	writel(cfg, dev->regs + S5P_CIGCTRL);
-}
-
-static inline void fimc_hw_enable_scaler(struct fimc_dev *dev, bool on)
-{
-	u32 cfg = readl(dev->regs + S5P_CISCCTRL);
-	if (on)
-		cfg |= S5P_CISCCTRL_SCALERSTART;
-	else
-		cfg &= ~S5P_CISCCTRL_SCALERSTART;
-	writel(cfg, dev->regs + S5P_CISCCTRL);
-}
-
-static inline void fimc_hw_activate_input_dma(struct fimc_dev *dev, bool on)
-{
-	u32 cfg = readl(dev->regs + S5P_MSCTRL);
-	if (on)
-		cfg |= S5P_MSCTRL_ENVID;
-	else
-		cfg &= ~S5P_MSCTRL_ENVID;
-	writel(cfg, dev->regs + S5P_MSCTRL);
-}
-
-static inline void fimc_hw_dis_capture(struct fimc_dev *dev)
-{
-	u32 cfg = readl(dev->regs + S5P_CIIMGCPT);
-	cfg &= ~(S5P_CIIMGCPT_IMGCPTEN | S5P_CIIMGCPT_IMGCPTEN_SC);
-	writel(cfg, dev->regs + S5P_CIIMGCPT);
-}
-
-/**
- * fimc_hw_set_dma_seq - configure output DMA buffer sequence
- * @mask: each bit corresponds to one of 32 output buffer registers set
- *	  1 to include buffer in the sequence, 0 to disable
- *
- * This function mask output DMA ring buffers, i.e. it allows to configure
- * which of the output buffer address registers will be used by the DMA
- * engine.
- */
-static inline void fimc_hw_set_dma_seq(struct fimc_dev *dev, u32 mask)
-{
-	writel(mask, dev->regs + S5P_CIFCNTSEQ);
-}
-
 static inline struct fimc_frame *ctx_get_frame(struct fimc_ctx *ctx,
 					       enum v4l2_buf_type type)
 {
@@ -653,48 +592,6 @@ static inline struct fimc_frame *ctx_get_frame(struct fimc_ctx *ctx,
 	return frame;
 }
 
-/* Return an index to the buffer actually being written. */
-static inline u32 fimc_hw_get_frame_index(struct fimc_dev *dev)
-{
-	u32 reg;
-
-	if (dev->variant->has_cistatus2) {
-		reg = readl(dev->regs + S5P_CISTATUS2) & 0x3F;
-		return reg > 0 ? --reg : reg;
-	} else {
-		reg = readl(dev->regs + S5P_CISTATUS);
-		return (reg & S5P_CISTATUS_FRAMECNT_MASK) >>
-			S5P_CISTATUS_FRAMECNT_SHIFT;
-	}
-}
-
-/* -----------------------------------------------------*/
-/* fimc-reg.c						*/
-void fimc_hw_reset(struct fimc_dev *fimc);
-void fimc_hw_set_rotation(struct fimc_ctx *ctx);
-void fimc_hw_set_target_format(struct fimc_ctx *ctx);
-void fimc_hw_set_out_dma(struct fimc_ctx *ctx);
-void fimc_hw_en_lastirq(struct fimc_dev *fimc, int enable);
-void fimc_hw_en_irq(struct fimc_dev *fimc, int enable);
-void fimc_hw_set_prescaler(struct fimc_ctx *ctx);
-void fimc_hw_set_mainscaler(struct fimc_ctx *ctx);
-void fimc_hw_en_capture(struct fimc_ctx *ctx);
-void fimc_hw_set_effect(struct fimc_ctx *ctx, bool active);
-void fimc_hw_set_rgb_alpha(struct fimc_ctx *ctx);
-void fimc_hw_set_in_dma(struct fimc_ctx *ctx);
-void fimc_hw_set_input_path(struct fimc_ctx *ctx);
-void fimc_hw_set_output_path(struct fimc_ctx *ctx);
-void fimc_hw_set_input_addr(struct fimc_dev *fimc, struct fimc_addr *paddr);
-void fimc_hw_set_output_addr(struct fimc_dev *fimc, struct fimc_addr *paddr,
-			     int index);
-int fimc_hw_set_camera_source(struct fimc_dev *fimc,
-			      struct s5p_fimc_isp_info *cam);
-int fimc_hw_set_camera_offset(struct fimc_dev *fimc, struct fimc_frame *f);
-int fimc_hw_set_camera_polarity(struct fimc_dev *fimc,
-				struct s5p_fimc_isp_info *cam);
-int fimc_hw_set_camera_type(struct fimc_dev *fimc,
-			    struct s5p_fimc_isp_info *cam);
-
 /* -----------------------------------------------------*/
 /* fimc-core.c */
 int fimc_vidioc_enum_fmt_mplane(struct file *file, void *priv,
@@ -741,21 +638,6 @@ void fimc_sensor_notify(struct v4l2_subdev *sd, unsigned int notification,
 int fimc_capture_suspend(struct fimc_dev *fimc);
 int fimc_capture_resume(struct fimc_dev *fimc);
 
-/* Locking: the caller holds fimc->slock */
-static inline void fimc_activate_capture(struct fimc_ctx *ctx)
-{
-	fimc_hw_enable_scaler(ctx->fimc_dev, ctx->scaler.enabled);
-	fimc_hw_en_capture(ctx);
-}
-
-static inline void fimc_deactivate_capture(struct fimc_dev *fimc)
-{
-	fimc_hw_en_lastirq(fimc, true);
-	fimc_hw_dis_capture(fimc);
-	fimc_hw_enable_scaler(fimc, false);
-	fimc_hw_en_lastirq(fimc, false);
-}
-
 /*
  * Buffer list manipulation functions. Must be called with fimc.slock held.
  */
diff --git a/drivers/media/video/s5p-fimc/fimc-m2m.c b/drivers/media/video/s5p-fimc/fimc-m2m.c
index 90cce00..a693bed 100644
--- a/drivers/media/video/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/video/s5p-fimc/fimc-m2m.c
@@ -28,6 +28,7 @@
 #include <media/videobuf2-dma-contig.h>
 
 #include "fimc-core.h"
+#include "fimc-reg.h"
 #include "fimc-mdevice.h"
 
 
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 1c0be5b..9af3c83 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -1,9 +1,8 @@
 /*
  * Register interface file for Samsung Camera Interface (FIMC) driver
  *
- * Copyright (c) 2010 Samsung Electronics
- *
- * Sylwester Nawrocki, s.nawrocki@samsung.com
+ * Copyright (C) 2010 - 2012 Samsung Electronics Co., Ltd.
+ * Sylwester Nawrocki, <s.nawrocki@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -12,9 +11,9 @@
 
 #include <linux/io.h>
 #include <linux/delay.h>
-#include <mach/map.h>
 #include <media/s5p_fimc.h>
 
+#include "fimc-reg.h"
 #include "fimc-core.h"
 
 
@@ -22,19 +21,19 @@ void fimc_hw_reset(struct fimc_dev *dev)
 {
 	u32 cfg;
 
-	cfg = readl(dev->regs + S5P_CISRCFMT);
-	cfg |= S5P_CISRCFMT_ITU601_8BIT;
-	writel(cfg, dev->regs + S5P_CISRCFMT);
+	cfg = readl(dev->regs + FIMC_REG_CISRCFMT);
+	cfg |= FIMC_REG_CISRCFMT_ITU601_8BIT;
+	writel(cfg, dev->regs + FIMC_REG_CISRCFMT);
 
 	/* Software reset. */
-	cfg = readl(dev->regs + S5P_CIGCTRL);
-	cfg |= (S5P_CIGCTRL_SWRST | S5P_CIGCTRL_IRQ_LEVEL);
-	writel(cfg, dev->regs + S5P_CIGCTRL);
+	cfg = readl(dev->regs + FIMC_REG_CIGCTRL);
+	cfg |= (FIMC_REG_CIGCTRL_SWRST | FIMC_REG_CIGCTRL_IRQ_LEVEL);
+	writel(cfg, dev->regs + FIMC_REG_CIGCTRL);
 	udelay(10);
 
-	cfg = readl(dev->regs + S5P_CIGCTRL);
-	cfg &= ~S5P_CIGCTRL_SWRST;
-	writel(cfg, dev->regs + S5P_CIGCTRL);
+	cfg = readl(dev->regs + FIMC_REG_CIGCTRL);
+	cfg &= ~FIMC_REG_CIGCTRL_SWRST;
+	writel(cfg, dev->regs + FIMC_REG_CIGCTRL);
 
 	if (dev->variant->out_buf_count > 4)
 		fimc_hw_set_dma_seq(dev, 0xF);
@@ -42,32 +41,32 @@ void fimc_hw_reset(struct fimc_dev *dev)
 
 static u32 fimc_hw_get_in_flip(struct fimc_ctx *ctx)
 {
-	u32 flip = S5P_MSCTRL_FLIP_NORMAL;
+	u32 flip = FIMC_REG_MSCTRL_FLIP_NORMAL;
 
 	if (ctx->hflip)
-		flip = S5P_MSCTRL_FLIP_X_MIRROR;
+		flip = FIMC_REG_MSCTRL_FLIP_X_MIRROR;
 	if (ctx->vflip)
-		flip = S5P_MSCTRL_FLIP_Y_MIRROR;
+		flip = FIMC_REG_MSCTRL_FLIP_Y_MIRROR;
 
 	if (ctx->rotation <= 90)
 		return flip;
 
-	return (flip ^ S5P_MSCTRL_FLIP_180) & S5P_MSCTRL_FLIP_180;
+	return (flip ^ FIMC_REG_MSCTRL_FLIP_180) & FIMC_REG_MSCTRL_FLIP_180;
 }
 
 static u32 fimc_hw_get_target_flip(struct fimc_ctx *ctx)
 {
-	u32 flip = S5P_CITRGFMT_FLIP_NORMAL;
+	u32 flip = FIMC_REG_CITRGFMT_FLIP_NORMAL;
 
 	if (ctx->hflip)
-		flip |= S5P_CITRGFMT_FLIP_X_MIRROR;
+		flip |= FIMC_REG_CITRGFMT_FLIP_X_MIRROR;
 	if (ctx->vflip)
-		flip |= S5P_CITRGFMT_FLIP_Y_MIRROR;
+		flip |= FIMC_REG_CITRGFMT_FLIP_Y_MIRROR;
 
 	if (ctx->rotation <= 90)
 		return flip;
 
-	return (flip ^ S5P_CITRGFMT_FLIP_180) & S5P_CITRGFMT_FLIP_180;
+	return (flip ^ FIMC_REG_CITRGFMT_FLIP_180) & FIMC_REG_CITRGFMT_FLIP_180;
 }
 
 void fimc_hw_set_rotation(struct fimc_ctx *ctx)
@@ -75,9 +74,9 @@ void fimc_hw_set_rotation(struct fimc_ctx *ctx)
 	u32 cfg, flip;
 	struct fimc_dev *dev = ctx->fimc_dev;
 
-	cfg = readl(dev->regs + S5P_CITRGFMT);
-	cfg &= ~(S5P_CITRGFMT_INROT90 | S5P_CITRGFMT_OUTROT90 |
-		 S5P_CITRGFMT_FLIP_180);
+	cfg = readl(dev->regs + FIMC_REG_CITRGFMT);
+	cfg &= ~(FIMC_REG_CITRGFMT_INROT90 | FIMC_REG_CITRGFMT_OUTROT90 |
+		 FIMC_REG_CITRGFMT_FLIP_180);
 
 	/*
 	 * The input and output rotator cannot work simultaneously.
@@ -86,20 +85,20 @@ void fimc_hw_set_rotation(struct fimc_ctx *ctx)
 	 */
 	if (ctx->rotation == 90 || ctx->rotation == 270) {
 		if (ctx->out_path == FIMC_LCDFIFO)
-			cfg |= S5P_CITRGFMT_INROT90;
+			cfg |= FIMC_REG_CITRGFMT_INROT90;
 		else
-			cfg |= S5P_CITRGFMT_OUTROT90;
+			cfg |= FIMC_REG_CITRGFMT_OUTROT90;
 	}
 
 	if (ctx->out_path == FIMC_DMA) {
 		cfg |= fimc_hw_get_target_flip(ctx);
-		writel(cfg, dev->regs + S5P_CITRGFMT);
+		writel(cfg, dev->regs + FIMC_REG_CITRGFMT);
 	} else {
 		/* LCD FIFO path */
-		flip = readl(dev->regs + S5P_MSCTRL);
-		flip &= ~S5P_MSCTRL_FLIP_MASK;
+		flip = readl(dev->regs + FIMC_REG_MSCTRL);
+		flip &= ~FIMC_REG_MSCTRL_FLIP_MASK;
 		flip |= fimc_hw_get_in_flip(ctx);
-		writel(flip, dev->regs + S5P_MSCTRL);
+		writel(flip, dev->regs + FIMC_REG_MSCTRL);
 	}
 }
 
@@ -110,43 +109,40 @@ void fimc_hw_set_target_format(struct fimc_ctx *ctx)
 	struct fimc_frame *frame = &ctx->d_frame;
 
 	dbg("w= %d, h= %d color: %d", frame->width,
-		frame->height, frame->fmt->color);
+	    frame->height, frame->fmt->color);
 
-	cfg = readl(dev->regs + S5P_CITRGFMT);
-	cfg &= ~(S5P_CITRGFMT_FMT_MASK | S5P_CITRGFMT_HSIZE_MASK |
-		  S5P_CITRGFMT_VSIZE_MASK);
+	cfg = readl(dev->regs + FIMC_REG_CITRGFMT);
+	cfg &= ~(FIMC_REG_CITRGFMT_FMT_MASK | FIMC_REG_CITRGFMT_HSIZE_MASK |
+		 FIMC_REG_CITRGFMT_VSIZE_MASK);
 
 	switch (frame->fmt->color) {
 	case S5P_FIMC_RGB444...S5P_FIMC_RGB888:
-		cfg |= S5P_CITRGFMT_RGB;
+		cfg |= FIMC_REG_CITRGFMT_RGB;
 		break;
 	case S5P_FIMC_YCBCR420:
-		cfg |= S5P_CITRGFMT_YCBCR420;
+		cfg |= FIMC_REG_CITRGFMT_YCBCR420;
 		break;
 	case S5P_FIMC_YCBYCR422...S5P_FIMC_CRYCBY422:
 		if (frame->fmt->colplanes == 1)
-			cfg |= S5P_CITRGFMT_YCBCR422_1P;
+			cfg |= FIMC_REG_CITRGFMT_YCBCR422_1P;
 		else
-			cfg |= S5P_CITRGFMT_YCBCR422;
+			cfg |= FIMC_REG_CITRGFMT_YCBCR422;
 		break;
 	default:
 		break;
 	}
 
-	if (ctx->rotation == 90 || ctx->rotation == 270) {
-		cfg |= S5P_CITRGFMT_HSIZE(frame->height);
-		cfg |= S5P_CITRGFMT_VSIZE(frame->width);
-	} else {
-
-		cfg |= S5P_CITRGFMT_HSIZE(frame->width);
-		cfg |= S5P_CITRGFMT_VSIZE(frame->height);
-	}
+	if (ctx->rotation == 90 || ctx->rotation == 270)
+		cfg |= (frame->height << 16) | frame->width;
+	else
+		cfg |= (frame->width << 16) | frame->height;
 
-	writel(cfg, dev->regs + S5P_CITRGFMT);
+	writel(cfg, dev->regs + FIMC_REG_CITRGFMT);
 
-	cfg = readl(dev->regs + S5P_CITAREA) & ~S5P_CITAREA_MASK;
+	cfg = readl(dev->regs + FIMC_REG_CITAREA);
+	cfg &= ~FIMC_REG_CITAREA_MASK;
 	cfg |= (frame->width * frame->height);
-	writel(cfg, dev->regs + S5P_CITAREA);
+	writel(cfg, dev->regs + FIMC_REG_CITAREA);
 }
 
 static void fimc_hw_set_out_dma_size(struct fimc_ctx *ctx)
@@ -155,87 +151,82 @@ static void fimc_hw_set_out_dma_size(struct fimc_ctx *ctx)
 	struct fimc_frame *frame = &ctx->d_frame;
 	u32 cfg;
 
-	cfg = S5P_ORIG_SIZE_HOR(frame->f_width);
-	cfg |= S5P_ORIG_SIZE_VER(frame->f_height);
-	writel(cfg, dev->regs + S5P_ORGOSIZE);
+	cfg = (frame->f_height << 16) | frame->f_width;
+	writel(cfg, dev->regs + FIMC_REG_ORGOSIZE);
 
 	/* Select color space conversion equation (HD/SD size).*/
-	cfg = readl(dev->regs + S5P_CIGCTRL);
+	cfg = readl(dev->regs + FIMC_REG_CIGCTRL);
 	if (frame->f_width >= 1280) /* HD */
-		cfg |= S5P_CIGCTRL_CSC_ITU601_709;
+		cfg |= FIMC_REG_CIGCTRL_CSC_ITU601_709;
 	else	/* SD */
-		cfg &= ~S5P_CIGCTRL_CSC_ITU601_709;
-	writel(cfg, dev->regs + S5P_CIGCTRL);
+		cfg &= ~FIMC_REG_CIGCTRL_CSC_ITU601_709;
+	writel(cfg, dev->regs + FIMC_REG_CIGCTRL);
 
 }
 
 void fimc_hw_set_out_dma(struct fimc_ctx *ctx)
 {
-	u32 cfg;
 	struct fimc_dev *dev = ctx->fimc_dev;
 	struct fimc_frame *frame = &ctx->d_frame;
 	struct fimc_dma_offset *offset = &frame->dma_offset;
 	struct fimc_fmt *fmt = frame->fmt;
+	u32 cfg;
 
 	/* Set the input dma offsets. */
-	cfg = 0;
-	cfg |= S5P_CIO_OFFS_HOR(offset->y_h);
-	cfg |= S5P_CIO_OFFS_VER(offset->y_v);
-	writel(cfg, dev->regs + S5P_CIOYOFF);
+	cfg = (offset->y_v << 16) | offset->y_h;
+	writel(cfg, dev->regs + FIMC_REG_CIOYOFF);
 
-	cfg = 0;
-	cfg |= S5P_CIO_OFFS_HOR(offset->cb_h);
-	cfg |= S5P_CIO_OFFS_VER(offset->cb_v);
-	writel(cfg, dev->regs + S5P_CIOCBOFF);
+	cfg = (offset->cb_v << 16) | offset->cb_h;
+	writel(cfg, dev->regs + FIMC_REG_CIOCBOFF);
 
-	cfg = 0;
-	cfg |= S5P_CIO_OFFS_HOR(offset->cr_h);
-	cfg |= S5P_CIO_OFFS_VER(offset->cr_v);
-	writel(cfg, dev->regs + S5P_CIOCROFF);
+	cfg = (offset->cr_v << 16) | offset->cr_h;
+	writel(cfg, dev->regs + FIMC_REG_CIOCROFF);
 
 	fimc_hw_set_out_dma_size(ctx);
 
 	/* Configure chroma components order. */
-	cfg = readl(dev->regs + S5P_CIOCTRL);
+	cfg = readl(dev->regs + FIMC_REG_CIOCTRL);
 
-	cfg &= ~(S5P_CIOCTRL_ORDER2P_MASK | S5P_CIOCTRL_ORDER422_MASK |
-		 S5P_CIOCTRL_YCBCR_PLANE_MASK | S5P_CIOCTRL_RGB16FMT_MASK);
+	cfg &= ~(FIMC_REG_CIOCTRL_ORDER2P_MASK |
+		 FIMC_REG_CIOCTRL_ORDER422_MASK |
+		 FIMC_REG_CIOCTRL_YCBCR_PLANE_MASK |
+		 FIMC_REG_CIOCTRL_RGB16FMT_MASK);
 
 	if (fmt->colplanes == 1)
 		cfg |= ctx->out_order_1p;
 	else if (fmt->colplanes == 2)
-		cfg |= ctx->out_order_2p | S5P_CIOCTRL_YCBCR_2PLANE;
+		cfg |= ctx->out_order_2p | FIMC_REG_CIOCTRL_YCBCR_2PLANE;
 	else if (fmt->colplanes == 3)
-		cfg |= S5P_CIOCTRL_YCBCR_3PLANE;
+		cfg |= FIMC_REG_CIOCTRL_YCBCR_3PLANE;
 
 	if (fmt->color == S5P_FIMC_RGB565)
-		cfg |= S5P_CIOCTRL_RGB565;
+		cfg |= FIMC_REG_CIOCTRL_RGB565;
 	else if (fmt->color == S5P_FIMC_RGB555)
-		cfg |= S5P_CIOCTRL_ARGB1555;
+		cfg |= FIMC_REG_CIOCTRL_ARGB1555;
 	else if (fmt->color == S5P_FIMC_RGB444)
-		cfg |= S5P_CIOCTRL_ARGB4444;
+		cfg |= FIMC_REG_CIOCTRL_ARGB4444;
 
-	writel(cfg, dev->regs + S5P_CIOCTRL);
+	writel(cfg, dev->regs + FIMC_REG_CIOCTRL);
 }
 
 static void fimc_hw_en_autoload(struct fimc_dev *dev, int enable)
 {
-	u32 cfg = readl(dev->regs + S5P_ORGISIZE);
+	u32 cfg = readl(dev->regs + FIMC_REG_ORGISIZE);
 	if (enable)
-		cfg |= S5P_CIREAL_ISIZE_AUTOLOAD_EN;
+		cfg |= FIMC_REG_CIREAL_ISIZE_AUTOLOAD_EN;
 	else
-		cfg &= ~S5P_CIREAL_ISIZE_AUTOLOAD_EN;
-	writel(cfg, dev->regs + S5P_ORGISIZE);
+		cfg &= ~FIMC_REG_CIREAL_ISIZE_AUTOLOAD_EN;
+	writel(cfg, dev->regs + FIMC_REG_ORGISIZE);
 }
 
 void fimc_hw_en_lastirq(struct fimc_dev *dev, int enable)
 {
-	u32 cfg = readl(dev->regs + S5P_CIOCTRL);
+	u32 cfg = readl(dev->regs + FIMC_REG_CIOCTRL);
 	if (enable)
-		cfg |= S5P_CIOCTRL_LASTIRQ_ENABLE;
+		cfg |= FIMC_REG_CIOCTRL_LASTIRQ_ENABLE;
 	else
-		cfg &= ~S5P_CIOCTRL_LASTIRQ_ENABLE;
-	writel(cfg, dev->regs + S5P_CIOCTRL);
+		cfg &= ~FIMC_REG_CIOCTRL_LASTIRQ_ENABLE;
+	writel(cfg, dev->regs + FIMC_REG_CIOCTRL);
 }
 
 void fimc_hw_set_prescaler(struct fimc_ctx *ctx)
@@ -245,15 +236,13 @@ void fimc_hw_set_prescaler(struct fimc_ctx *ctx)
 	u32 cfg, shfactor;
 
 	shfactor = 10 - (sc->hfactor + sc->vfactor);
+	cfg = shfactor << 28;
 
-	cfg = S5P_CISCPRERATIO_SHFACTOR(shfactor);
-	cfg |= S5P_CISCPRERATIO_HOR(sc->pre_hratio);
-	cfg |= S5P_CISCPRERATIO_VER(sc->pre_vratio);
-	writel(cfg, dev->regs + S5P_CISCPRERATIO);
+	cfg |= (sc->pre_hratio << 16) | sc->pre_vratio;
+	writel(cfg, dev->regs + FIMC_REG_CISCPRERATIO);
 
-	cfg = S5P_CISCPREDST_WIDTH(sc->pre_dst_width);
-	cfg |= S5P_CISCPREDST_HEIGHT(sc->pre_dst_height);
-	writel(cfg, dev->regs + S5P_CISCPREDST);
+	cfg = (sc->pre_dst_width << 16) | sc->pre_dst_height;
+	writel(cfg, dev->regs + FIMC_REG_CISCPREDST);
 }
 
 static void fimc_hw_set_scaler(struct fimc_ctx *ctx)
@@ -263,39 +252,40 @@ static void fimc_hw_set_scaler(struct fimc_ctx *ctx)
 	struct fimc_frame *src_frame = &ctx->s_frame;
 	struct fimc_frame *dst_frame = &ctx->d_frame;
 
-	u32 cfg = readl(dev->regs + S5P_CISCCTRL);
+	u32 cfg = readl(dev->regs + FIMC_REG_CISCCTRL);
 
-	cfg &= ~(S5P_CISCCTRL_CSCR2Y_WIDE | S5P_CISCCTRL_CSCY2R_WIDE |
-		 S5P_CISCCTRL_SCALEUP_H | S5P_CISCCTRL_SCALEUP_V |
-		 S5P_CISCCTRL_SCALERBYPASS | S5P_CISCCTRL_ONE2ONE |
-		 S5P_CISCCTRL_INRGB_FMT_MASK | S5P_CISCCTRL_OUTRGB_FMT_MASK |
-		 S5P_CISCCTRL_INTERLACE | S5P_CISCCTRL_RGB_EXT);
+	cfg &= ~(FIMC_REG_CISCCTRL_CSCR2Y_WIDE | FIMC_REG_CISCCTRL_CSCY2R_WIDE |
+		 FIMC_REG_CISCCTRL_SCALEUP_H | FIMC_REG_CISCCTRL_SCALEUP_V |
+		 FIMC_REG_CISCCTRL_SCALERBYPASS | FIMC_REG_CISCCTRL_ONE2ONE |
+		 FIMC_REG_CISCCTRL_INRGB_FMT_MASK | FIMC_REG_CISCCTRL_OUTRGB_FMT_MASK |
+		 FIMC_REG_CISCCTRL_INTERLACE | FIMC_REG_CISCCTRL_RGB_EXT);
 
 	if (!(ctx->flags & FIMC_COLOR_RANGE_NARROW))
-		cfg |= (S5P_CISCCTRL_CSCR2Y_WIDE | S5P_CISCCTRL_CSCY2R_WIDE);
+		cfg |= (FIMC_REG_CISCCTRL_CSCR2Y_WIDE |
+			FIMC_REG_CISCCTRL_CSCY2R_WIDE);
 
 	if (!sc->enabled)
-		cfg |= S5P_CISCCTRL_SCALERBYPASS;
+		cfg |= FIMC_REG_CISCCTRL_SCALERBYPASS;
 
 	if (sc->scaleup_h)
-		cfg |= S5P_CISCCTRL_SCALEUP_H;
+		cfg |= FIMC_REG_CISCCTRL_SCALEUP_H;
 
 	if (sc->scaleup_v)
-		cfg |= S5P_CISCCTRL_SCALEUP_V;
+		cfg |= FIMC_REG_CISCCTRL_SCALEUP_V;
 
 	if (sc->copy_mode)
-		cfg |= S5P_CISCCTRL_ONE2ONE;
+		cfg |= FIMC_REG_CISCCTRL_ONE2ONE;
 
 	if (ctx->in_path == FIMC_DMA) {
 		switch (src_frame->fmt->color) {
 		case S5P_FIMC_RGB565:
-			cfg |= S5P_CISCCTRL_INRGB_FMT_RGB565;
+			cfg |= FIMC_REG_CISCCTRL_INRGB_FMT_RGB565;
 			break;
 		case S5P_FIMC_RGB666:
-			cfg |= S5P_CISCCTRL_INRGB_FMT_RGB666;
+			cfg |= FIMC_REG_CISCCTRL_INRGB_FMT_RGB666;
 			break;
 		case S5P_FIMC_RGB888:
-			cfg |= S5P_CISCCTRL_INRGB_FMT_RGB888;
+			cfg |= FIMC_REG_CISCCTRL_INRGB_FMT_RGB888;
 			break;
 		}
 	}
@@ -304,19 +294,19 @@ static void fimc_hw_set_scaler(struct fimc_ctx *ctx)
 		u32 color = dst_frame->fmt->color;
 
 		if (color >= S5P_FIMC_RGB444 && color <= S5P_FIMC_RGB565)
-			cfg |= S5P_CISCCTRL_OUTRGB_FMT_RGB565;
+			cfg |= FIMC_REG_CISCCTRL_OUTRGB_FMT_RGB565;
 		else if (color == S5P_FIMC_RGB666)
-			cfg |= S5P_CISCCTRL_OUTRGB_FMT_RGB666;
+			cfg |= FIMC_REG_CISCCTRL_OUTRGB_FMT_RGB666;
 		else if (color == S5P_FIMC_RGB888)
-			cfg |= S5P_CISCCTRL_OUTRGB_FMT_RGB888;
+			cfg |= FIMC_REG_CISCCTRL_OUTRGB_FMT_RGB888;
 	} else {
-		cfg |= S5P_CISCCTRL_OUTRGB_FMT_RGB888;
+		cfg |= FIMC_REG_CISCCTRL_OUTRGB_FMT_RGB888;
 
 		if (ctx->flags & FIMC_SCAN_MODE_INTERLACED)
-			cfg |= S5P_CISCCTRL_INTERLACE;
+			cfg |= FIMC_REG_CISCCTRL_INTERLACE;
 	}
 
-	writel(cfg, dev->regs + S5P_CISCCTRL);
+	writel(cfg, dev->regs + FIMC_REG_CISCCTRL);
 }
 
 void fimc_hw_set_mainscaler(struct fimc_ctx *ctx)
@@ -327,29 +317,30 @@ void fimc_hw_set_mainscaler(struct fimc_ctx *ctx)
 	u32 cfg;
 
 	dbg("main_hratio= 0x%X  main_vratio= 0x%X",
-		sc->main_hratio, sc->main_vratio);
+	    sc->main_hratio, sc->main_vratio);
 
 	fimc_hw_set_scaler(ctx);
 
-	cfg = readl(dev->regs + S5P_CISCCTRL);
-	cfg &= ~(S5P_CISCCTRL_MHRATIO_MASK | S5P_CISCCTRL_MVRATIO_MASK);
+	cfg = readl(dev->regs + FIMC_REG_CISCCTRL);
+	cfg &= ~(FIMC_REG_CISCCTRL_MHRATIO_MASK |
+		 FIMC_REG_CISCCTRL_MVRATIO_MASK);
 
 	if (variant->has_mainscaler_ext) {
-		cfg |= S5P_CISCCTRL_MHRATIO_EXT(sc->main_hratio);
-		cfg |= S5P_CISCCTRL_MVRATIO_EXT(sc->main_vratio);
-		writel(cfg, dev->regs + S5P_CISCCTRL);
+		cfg |= FIMC_REG_CISCCTRL_MHRATIO_EXT(sc->main_hratio);
+		cfg |= FIMC_REG_CISCCTRL_MVRATIO_EXT(sc->main_vratio);
+		writel(cfg, dev->regs + FIMC_REG_CISCCTRL);
 
-		cfg = readl(dev->regs + S5P_CIEXTEN);
+		cfg = readl(dev->regs + FIMC_REG_CIEXTEN);
 
-		cfg &= ~(S5P_CIEXTEN_MVRATIO_EXT_MASK |
-			 S5P_CIEXTEN_MHRATIO_EXT_MASK);
-		cfg |= S5P_CIEXTEN_MHRATIO_EXT(sc->main_hratio);
-		cfg |= S5P_CIEXTEN_MVRATIO_EXT(sc->main_vratio);
-		writel(cfg, dev->regs + S5P_CIEXTEN);
+		cfg &= ~(FIMC_REG_CIEXTEN_MVRATIO_EXT_MASK |
+			 FIMC_REG_CIEXTEN_MHRATIO_EXT_MASK);
+		cfg |= FIMC_REG_CIEXTEN_MHRATIO_EXT(sc->main_hratio);
+		cfg |= FIMC_REG_CIEXTEN_MVRATIO_EXT(sc->main_vratio);
+		writel(cfg, dev->regs + FIMC_REG_CIEXTEN);
 	} else {
-		cfg |= S5P_CISCCTRL_MHRATIO(sc->main_hratio);
-		cfg |= S5P_CISCCTRL_MVRATIO(sc->main_vratio);
-		writel(cfg, dev->regs + S5P_CISCCTRL);
+		cfg |= FIMC_REG_CISCCTRL_MHRATIO(sc->main_hratio);
+		cfg |= FIMC_REG_CISCCTRL_MVRATIO(sc->main_vratio);
+		writel(cfg, dev->regs + FIMC_REG_CISCCTRL);
 	}
 }
 
@@ -357,22 +348,24 @@ void fimc_hw_en_capture(struct fimc_ctx *ctx)
 {
 	struct fimc_dev *dev = ctx->fimc_dev;
 
-	u32 cfg = readl(dev->regs + S5P_CIIMGCPT);
+	u32 cfg = readl(dev->regs + FIMC_REG_CIIMGCPT);
 
 	if (ctx->out_path == FIMC_DMA) {
 		/* one shot mode */
-		cfg |= S5P_CIIMGCPT_CPT_FREN_ENABLE | S5P_CIIMGCPT_IMGCPTEN;
+		cfg |= FIMC_REG_CIIMGCPT_CPT_FREN_ENABLE |
+			FIMC_REG_CIIMGCPT_IMGCPTEN;
 	} else {
 		/* Continuous frame capture mode (freerun). */
-		cfg &= ~(S5P_CIIMGCPT_CPT_FREN_ENABLE |
-			 S5P_CIIMGCPT_CPT_FRMOD_CNT);
-		cfg |= S5P_CIIMGCPT_IMGCPTEN;
+		cfg &= ~(FIMC_REG_CIIMGCPT_CPT_FREN_ENABLE |
+			 FIMC_REG_CIIMGCPT_CPT_FRMOD_CNT);
+		cfg |= FIMC_REG_CIIMGCPT_IMGCPTEN;
 	}
 
 	if (ctx->scaler.enabled)
-		cfg |= S5P_CIIMGCPT_IMGCPTEN_SC;
+		cfg |= FIMC_REG_CIIMGCPT_IMGCPTEN_SC;
 
-	writel(cfg | S5P_CIIMGCPT_IMGCPTEN, dev->regs + S5P_CIIMGCPT);
+	cfg |= FIMC_REG_CIIMGCPT_IMGCPTEN;
+	writel(cfg, dev->regs + FIMC_REG_CIIMGCPT);
 }
 
 void fimc_hw_set_effect(struct fimc_ctx *ctx, bool active)
@@ -382,15 +375,14 @@ void fimc_hw_set_effect(struct fimc_ctx *ctx, bool active)
 	u32 cfg = 0;
 
 	if (active) {
-		cfg |= S5P_CIIMGEFF_IE_SC_AFTER | S5P_CIIMGEFF_IE_ENABLE;
+		cfg |= FIMC_REG_CIIMGEFF_IE_SC_AFTER |
+			FIMC_REG_CIIMGEFF_IE_ENABLE;
 		cfg |= effect->type;
-		if (effect->type == S5P_FIMC_EFFECT_ARBITRARY) {
-			cfg |= S5P_CIIMGEFF_PAT_CB(effect->pat_cb);
-			cfg |= S5P_CIIMGEFF_PAT_CR(effect->pat_cr);
-		}
+		if (effect->type == FIMC_REG_CIIMGEFF_FIN_ARBITRARY)
+			cfg |= (effect->pat_cb << 13) | effect->pat_cr;
 	}
 
-	writel(cfg, dev->regs + S5P_CIIMGEFF);
+	writel(cfg, dev->regs + FIMC_REG_CIIMGEFF);
 }
 
 void fimc_hw_set_rgb_alpha(struct fimc_ctx *ctx)
@@ -402,10 +394,10 @@ void fimc_hw_set_rgb_alpha(struct fimc_ctx *ctx)
 	if (!(frame->fmt->flags & FMT_HAS_ALPHA))
 		return;
 
-	cfg = readl(dev->regs + S5P_CIOCTRL);
-	cfg &= ~S5P_CIOCTRL_ALPHA_OUT_MASK;
+	cfg = readl(dev->regs + FIMC_REG_CIOCTRL);
+	cfg &= ~FIMC_REG_CIOCTRL_ALPHA_OUT_MASK;
 	cfg |= (frame->alpha << 4);
-	writel(cfg, dev->regs + S5P_CIOCTRL);
+	writel(cfg, dev->regs + FIMC_REG_CIOCTRL);
 }
 
 static void fimc_hw_set_in_dma_size(struct fimc_ctx *ctx)
@@ -416,15 +408,13 @@ static void fimc_hw_set_in_dma_size(struct fimc_ctx *ctx)
 	u32 cfg_r = 0;
 
 	if (FIMC_LCDFIFO == ctx->out_path)
-		cfg_r |= S5P_CIREAL_ISIZE_AUTOLOAD_EN;
+		cfg_r |= FIMC_REG_CIREAL_ISIZE_AUTOLOAD_EN;
 
-	cfg_o |= S5P_ORIG_SIZE_HOR(frame->f_width);
-	cfg_o |= S5P_ORIG_SIZE_VER(frame->f_height);
-	cfg_r |= S5P_CIREAL_ISIZE_WIDTH(frame->width);
-	cfg_r |= S5P_CIREAL_ISIZE_HEIGHT(frame->height);
+	cfg_o |= (frame->f_height << 16) | frame->f_width;
+	cfg_r |= (frame->height << 16) | frame->width;
 
-	writel(cfg_o, dev->regs + S5P_ORGISIZE);
-	writel(cfg_r, dev->regs + S5P_CIREAL_ISIZE);
+	writel(cfg_o, dev->regs + FIMC_REG_ORGISIZE);
+	writel(cfg_r, dev->regs + FIMC_REG_CIREAL_ISIZE);
 }
 
 void fimc_hw_set_in_dma(struct fimc_ctx *ctx)
@@ -435,17 +425,14 @@ void fimc_hw_set_in_dma(struct fimc_ctx *ctx)
 	u32 cfg;
 
 	/* Set the pixel offsets. */
-	cfg = S5P_CIO_OFFS_HOR(offset->y_h);
-	cfg |= S5P_CIO_OFFS_VER(offset->y_v);
-	writel(cfg, dev->regs + S5P_CIIYOFF);
+	cfg = (offset->y_v << 16) | offset->y_h;
+	writel(cfg, dev->regs + FIMC_REG_CIIYOFF);
 
-	cfg = S5P_CIO_OFFS_HOR(offset->cb_h);
-	cfg |= S5P_CIO_OFFS_VER(offset->cb_v);
-	writel(cfg, dev->regs + S5P_CIICBOFF);
+	cfg = (offset->cb_v << 16) | offset->cb_h;
+	writel(cfg, dev->regs + FIMC_REG_CIICBOFF);
 
-	cfg = S5P_CIO_OFFS_HOR(offset->cr_h);
-	cfg |= S5P_CIO_OFFS_VER(offset->cr_v);
-	writel(cfg, dev->regs + S5P_CIICROFF);
+	cfg = (offset->cr_v << 16) | offset->cr_h;
+	writel(cfg, dev->regs + FIMC_REG_CIICROFF);
 
 	/* Input original and real size. */
 	fimc_hw_set_in_dma_size(ctx);
@@ -454,61 +441,61 @@ void fimc_hw_set_in_dma(struct fimc_ctx *ctx)
 	fimc_hw_en_autoload(dev, ctx->out_path == FIMC_LCDFIFO);
 
 	/* Set the input DMA to process single frame only. */
-	cfg = readl(dev->regs + S5P_MSCTRL);
-	cfg &= ~(S5P_MSCTRL_INFORMAT_MASK
-		| S5P_MSCTRL_IN_BURST_COUNT_MASK
-		| S5P_MSCTRL_INPUT_MASK
-		| S5P_MSCTRL_C_INT_IN_MASK
-		| S5P_MSCTRL_2P_IN_ORDER_MASK);
+	cfg = readl(dev->regs + FIMC_REG_MSCTRL);
+	cfg &= ~(FIMC_REG_MSCTRL_INFORMAT_MASK
+		 | FIMC_REG_MSCTRL_IN_BURST_COUNT_MASK
+		 | FIMC_REG_MSCTRL_INPUT_MASK
+		 | FIMC_REG_MSCTRL_C_INT_IN_MASK
+		 | FIMC_REG_MSCTRL_2P_IN_ORDER_MASK);
 
-	cfg |= (S5P_MSCTRL_IN_BURST_COUNT(4)
-		| S5P_MSCTRL_INPUT_MEMORY
-		| S5P_MSCTRL_FIFO_CTRL_FULL);
+	cfg |= (FIMC_REG_MSCTRL_IN_BURST_COUNT(4)
+		| FIMC_REG_MSCTRL_INPUT_MEMORY
+		| FIMC_REG_MSCTRL_FIFO_CTRL_FULL);
 
 	switch (frame->fmt->color) {
 	case S5P_FIMC_RGB565...S5P_FIMC_RGB888:
-		cfg |= S5P_MSCTRL_INFORMAT_RGB;
+		cfg |= FIMC_REG_MSCTRL_INFORMAT_RGB;
 		break;
 	case S5P_FIMC_YCBCR420:
-		cfg |= S5P_MSCTRL_INFORMAT_YCBCR420;
+		cfg |= FIMC_REG_MSCTRL_INFORMAT_YCBCR420;
 
 		if (frame->fmt->colplanes == 2)
-			cfg |= ctx->in_order_2p | S5P_MSCTRL_C_INT_IN_2PLANE;
+			cfg |= ctx->in_order_2p | FIMC_REG_MSCTRL_C_INT_IN_2PLANE;
 		else
-			cfg |= S5P_MSCTRL_C_INT_IN_3PLANE;
+			cfg |= FIMC_REG_MSCTRL_C_INT_IN_3PLANE;
 
 		break;
 	case S5P_FIMC_YCBYCR422...S5P_FIMC_CRYCBY422:
 		if (frame->fmt->colplanes == 1) {
 			cfg |= ctx->in_order_1p
-				| S5P_MSCTRL_INFORMAT_YCBCR422_1P;
+				| FIMC_REG_MSCTRL_INFORMAT_YCBCR422_1P;
 		} else {
-			cfg |= S5P_MSCTRL_INFORMAT_YCBCR422;
+			cfg |= FIMC_REG_MSCTRL_INFORMAT_YCBCR422;
 
 			if (frame->fmt->colplanes == 2)
 				cfg |= ctx->in_order_2p
-					| S5P_MSCTRL_C_INT_IN_2PLANE;
+					| FIMC_REG_MSCTRL_C_INT_IN_2PLANE;
 			else
-				cfg |= S5P_MSCTRL_C_INT_IN_3PLANE;
+				cfg |= FIMC_REG_MSCTRL_C_INT_IN_3PLANE;
 		}
 		break;
 	default:
 		break;
 	}
 
-	writel(cfg, dev->regs + S5P_MSCTRL);
+	writel(cfg, dev->regs + FIMC_REG_MSCTRL);
 
 	/* Input/output DMA linear/tiled mode. */
-	cfg = readl(dev->regs + S5P_CIDMAPARAM);
-	cfg &= ~S5P_CIDMAPARAM_TILE_MASK;
+	cfg = readl(dev->regs + FIMC_REG_CIDMAPARAM);
+	cfg &= ~FIMC_REG_CIDMAPARAM_TILE_MASK;
 
 	if (tiled_fmt(ctx->s_frame.fmt))
-		cfg |= S5P_CIDMAPARAM_R_64X32;
+		cfg |= FIMC_REG_CIDMAPARAM_R_64X32;
 
 	if (tiled_fmt(ctx->d_frame.fmt))
-		cfg |= S5P_CIDMAPARAM_W_64X32;
+		cfg |= FIMC_REG_CIDMAPARAM_W_64X32;
 
-	writel(cfg, dev->regs + S5P_CIDMAPARAM);
+	writel(cfg, dev->regs + FIMC_REG_CIDMAPARAM);
 }
 
 
@@ -516,40 +503,40 @@ void fimc_hw_set_input_path(struct fimc_ctx *ctx)
 {
 	struct fimc_dev *dev = ctx->fimc_dev;
 
-	u32 cfg = readl(dev->regs + S5P_MSCTRL);
-	cfg &= ~S5P_MSCTRL_INPUT_MASK;
+	u32 cfg = readl(dev->regs + FIMC_REG_MSCTRL);
+	cfg &= ~FIMC_REG_MSCTRL_INPUT_MASK;
 
 	if (ctx->in_path == FIMC_DMA)
-		cfg |= S5P_MSCTRL_INPUT_MEMORY;
+		cfg |= FIMC_REG_MSCTRL_INPUT_MEMORY;
 	else
-		cfg |= S5P_MSCTRL_INPUT_EXTCAM;
+		cfg |= FIMC_REG_MSCTRL_INPUT_EXTCAM;
 
-	writel(cfg, dev->regs + S5P_MSCTRL);
+	writel(cfg, dev->regs + FIMC_REG_MSCTRL);
 }
 
 void fimc_hw_set_output_path(struct fimc_ctx *ctx)
 {
 	struct fimc_dev *dev = ctx->fimc_dev;
 
-	u32 cfg = readl(dev->regs + S5P_CISCCTRL);
-	cfg &= ~S5P_CISCCTRL_LCDPATHEN_FIFO;
+	u32 cfg = readl(dev->regs + FIMC_REG_CISCCTRL);
+	cfg &= ~FIMC_REG_CISCCTRL_LCDPATHEN_FIFO;
 	if (ctx->out_path == FIMC_LCDFIFO)
-		cfg |= S5P_CISCCTRL_LCDPATHEN_FIFO;
-	writel(cfg, dev->regs + S5P_CISCCTRL);
+		cfg |= FIMC_REG_CISCCTRL_LCDPATHEN_FIFO;
+	writel(cfg, dev->regs + FIMC_REG_CISCCTRL);
 }
 
 void fimc_hw_set_input_addr(struct fimc_dev *dev, struct fimc_addr *paddr)
 {
-	u32 cfg = readl(dev->regs + S5P_CIREAL_ISIZE);
-	cfg |= S5P_CIREAL_ISIZE_ADDR_CH_DIS;
-	writel(cfg, dev->regs + S5P_CIREAL_ISIZE);
+	u32 cfg = readl(dev->regs + FIMC_REG_CIREAL_ISIZE);
+	cfg |= FIMC_REG_CIREAL_ISIZE_ADDR_CH_DIS;
+	writel(cfg, dev->regs + FIMC_REG_CIREAL_ISIZE);
 
-	writel(paddr->y, dev->regs + S5P_CIIYSA(0));
-	writel(paddr->cb, dev->regs + S5P_CIICBSA(0));
-	writel(paddr->cr, dev->regs + S5P_CIICRSA(0));
+	writel(paddr->y, dev->regs + FIMC_REG_CIIYSA(0));
+	writel(paddr->cb, dev->regs + FIMC_REG_CIICBSA(0));
+	writel(paddr->cr, dev->regs + FIMC_REG_CIICRSA(0));
 
-	cfg &= ~S5P_CIREAL_ISIZE_ADDR_CH_DIS;
-	writel(cfg, dev->regs + S5P_CIREAL_ISIZE);
+	cfg &= ~FIMC_REG_CIREAL_ISIZE_ADDR_CH_DIS;
+	writel(cfg, dev->regs + FIMC_REG_CIREAL_ISIZE);
 }
 
 void fimc_hw_set_output_addr(struct fimc_dev *dev,
@@ -557,9 +544,9 @@ void fimc_hw_set_output_addr(struct fimc_dev *dev,
 {
 	int i = (index == -1) ? 0 : index;
 	do {
-		writel(paddr->y, dev->regs + S5P_CIOYSA(i));
-		writel(paddr->cb, dev->regs + S5P_CIOCBSA(i));
-		writel(paddr->cr, dev->regs + S5P_CIOCRSA(i));
+		writel(paddr->y, dev->regs + FIMC_REG_CIOYSA(i));
+		writel(paddr->cb, dev->regs + FIMC_REG_CIOCBSA(i));
+		writel(paddr->cr, dev->regs + FIMC_REG_CIOCRSA(i));
 		dbg("dst_buf[%d]: 0x%X, cb: 0x%X, cr: 0x%X",
 		    i, paddr->y, paddr->cb, paddr->cr);
 	} while (index == -1 && ++i < FIMC_MAX_OUT_BUFS);
@@ -568,32 +555,45 @@ void fimc_hw_set_output_addr(struct fimc_dev *dev,
 int fimc_hw_set_camera_polarity(struct fimc_dev *fimc,
 				struct s5p_fimc_isp_info *cam)
 {
-	u32 cfg = readl(fimc->regs + S5P_CIGCTRL);
+	u32 cfg = readl(fimc->regs + FIMC_REG_CIGCTRL);
 
-	cfg &= ~(S5P_CIGCTRL_INVPOLPCLK | S5P_CIGCTRL_INVPOLVSYNC |
-		 S5P_CIGCTRL_INVPOLHREF | S5P_CIGCTRL_INVPOLHSYNC |
-		 S5P_CIGCTRL_INVPOLFIELD);
+	cfg &= ~(FIMC_REG_CIGCTRL_INVPOLPCLK | FIMC_REG_CIGCTRL_INVPOLVSYNC |
+		 FIMC_REG_CIGCTRL_INVPOLHREF | FIMC_REG_CIGCTRL_INVPOLHSYNC |
+		 FIMC_REG_CIGCTRL_INVPOLFIELD);
 
 	if (cam->flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
-		cfg |= S5P_CIGCTRL_INVPOLPCLK;
+		cfg |= FIMC_REG_CIGCTRL_INVPOLPCLK;
 
 	if (cam->flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
-		cfg |= S5P_CIGCTRL_INVPOLVSYNC;
+		cfg |= FIMC_REG_CIGCTRL_INVPOLVSYNC;
 
 	if (cam->flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
-		cfg |= S5P_CIGCTRL_INVPOLHREF;
+		cfg |= FIMC_REG_CIGCTRL_INVPOLHREF;
 
 	if (cam->flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
-		cfg |= S5P_CIGCTRL_INVPOLHSYNC;
+		cfg |= FIMC_REG_CIGCTRL_INVPOLHSYNC;
 
 	if (cam->flags & V4L2_MBUS_FIELD_EVEN_LOW)
-		cfg |= S5P_CIGCTRL_INVPOLFIELD;
+		cfg |= FIMC_REG_CIGCTRL_INVPOLFIELD;
 
-	writel(cfg, fimc->regs + S5P_CIGCTRL);
+	writel(cfg, fimc->regs + FIMC_REG_CIGCTRL);
 
 	return 0;
 }
 
+struct mbus_pixfmt_desc {
+	u32 pixelcode;
+	u32 cisrcfmt;
+	u16 bus_width;
+};
+
+static const struct mbus_pixfmt_desc pix_desc[] = {
+	{ V4L2_MBUS_FMT_YUYV8_2X8, FIMC_REG_CISRCFMT_ORDER422_YCBYCR, 8 },
+	{ V4L2_MBUS_FMT_YVYU8_2X8, FIMC_REG_CISRCFMT_ORDER422_YCRYCB, 8 },
+	{ V4L2_MBUS_FMT_VYUY8_2X8, FIMC_REG_CISRCFMT_ORDER422_CRYCBY, 8 },
+	{ V4L2_MBUS_FMT_UYVY8_2X8, FIMC_REG_CISRCFMT_ORDER422_CBYCRY, 8 },
+};
+
 int fimc_hw_set_camera_source(struct fimc_dev *fimc,
 			      struct s5p_fimc_isp_info *cam)
 {
@@ -602,18 +602,6 @@ int fimc_hw_set_camera_source(struct fimc_dev *fimc,
 	u32 bus_width;
 	int i;
 
-	static const struct {
-		u32 pixelcode;
-		u32 cisrcfmt;
-		u16 bus_width;
-	} pix_desc[] = {
-		{ V4L2_MBUS_FMT_YUYV8_2X8, S5P_CISRCFMT_ORDER422_YCBYCR, 8 },
-		{ V4L2_MBUS_FMT_YVYU8_2X8, S5P_CISRCFMT_ORDER422_YCRYCB, 8 },
-		{ V4L2_MBUS_FMT_VYUY8_2X8, S5P_CISRCFMT_ORDER422_CRYCBY, 8 },
-		{ V4L2_MBUS_FMT_UYVY8_2X8, S5P_CISRCFMT_ORDER422_CBYCRY, 8 },
-		/* TODO: Add pixel codes for 16-bit bus width */
-	};
-
 	if (cam->bus_type == FIMC_ITU_601 || cam->bus_type == FIMC_ITU_656) {
 		for (i = 0; i < ARRAY_SIZE(pix_desc); i++) {
 			if (fimc->vid_cap.mf.code == pix_desc[i].pixelcode) {
@@ -632,41 +620,37 @@ int fimc_hw_set_camera_source(struct fimc_dev *fimc,
 
 		if (cam->bus_type == FIMC_ITU_601) {
 			if (bus_width == 8)
-				cfg |= S5P_CISRCFMT_ITU601_8BIT;
+				cfg |= FIMC_REG_CISRCFMT_ITU601_8BIT;
 			else if (bus_width == 16)
-				cfg |= S5P_CISRCFMT_ITU601_16BIT;
+				cfg |= FIMC_REG_CISRCFMT_ITU601_16BIT;
 		} /* else defaults to ITU-R BT.656 8-bit */
 	} else if (cam->bus_type == FIMC_MIPI_CSI2) {
 		if (fimc_fmt_is_jpeg(f->fmt->color))
-			cfg |= S5P_CISRCFMT_ITU601_8BIT;
+			cfg |= FIMC_REG_CISRCFMT_ITU601_8BIT;
 	}
 
-	cfg |= S5P_CISRCFMT_HSIZE(f->o_width) | S5P_CISRCFMT_VSIZE(f->o_height);
-	writel(cfg, fimc->regs + S5P_CISRCFMT);
+	cfg |= (f->o_width << 16) | f->o_height;
+	writel(cfg, fimc->regs + FIMC_REG_CISRCFMT);
 	return 0;
 }
 
-
-int fimc_hw_set_camera_offset(struct fimc_dev *fimc, struct fimc_frame *f)
+void fimc_hw_set_camera_offset(struct fimc_dev *fimc, struct fimc_frame *f)
 {
 	u32 hoff2, voff2;
 
-	u32 cfg = readl(fimc->regs + S5P_CIWDOFST);
+	u32 cfg = readl(fimc->regs + FIMC_REG_CIWDOFST);
 
-	cfg &= ~(S5P_CIWDOFST_HOROFF_MASK | S5P_CIWDOFST_VEROFF_MASK);
-	cfg |=  S5P_CIWDOFST_OFF_EN |
-		S5P_CIWDOFST_HOROFF(f->offs_h) |
-		S5P_CIWDOFST_VEROFF(f->offs_v);
+	cfg &= ~(FIMC_REG_CIWDOFST_HOROFF_MASK | FIMC_REG_CIWDOFST_VEROFF_MASK);
+	cfg |=  FIMC_REG_CIWDOFST_OFF_EN |
+		(f->offs_h << 16) | f->offs_v;
 
-	writel(cfg, fimc->regs + S5P_CIWDOFST);
+	writel(cfg, fimc->regs + FIMC_REG_CIWDOFST);
 
 	/* See CIWDOFSTn register description in the datasheet for details. */
 	hoff2 = f->o_width - f->width - f->offs_h;
 	voff2 = f->o_height - f->height - f->offs_v;
-	cfg = S5P_CIWDOFST2_HOROFF(hoff2) | S5P_CIWDOFST2_VEROFF(voff2);
-
-	writel(cfg, fimc->regs + S5P_CIWDOFST2);
-	return 0;
+	cfg = (hoff2 << 16) | voff2;
+	writel(cfg, fimc->regs + FIMC_REG_CIWDOFST2);
 }
 
 int fimc_hw_set_camera_type(struct fimc_dev *fimc,
@@ -676,27 +660,27 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
 	u32 csis_data_alignment = 32;
 
-	cfg = readl(fimc->regs + S5P_CIGCTRL);
+	cfg = readl(fimc->regs + FIMC_REG_CIGCTRL);
 
 	/* Select ITU B interface, disable Writeback path and test pattern. */
-	cfg &= ~(S5P_CIGCTRL_TESTPAT_MASK | S5P_CIGCTRL_SELCAM_ITU_A |
-		S5P_CIGCTRL_SELCAM_MIPI | S5P_CIGCTRL_CAMIF_SELWB |
-		S5P_CIGCTRL_SELCAM_MIPI_A | S5P_CIGCTRL_CAM_JPEG);
+	cfg &= ~(FIMC_REG_CIGCTRL_TESTPAT_MASK | FIMC_REG_CIGCTRL_SELCAM_ITU_A |
+		FIMC_REG_CIGCTRL_SELCAM_MIPI | FIMC_REG_CIGCTRL_CAMIF_SELWB |
+		FIMC_REG_CIGCTRL_SELCAM_MIPI_A | FIMC_REG_CIGCTRL_CAM_JPEG);
 
 	if (cam->bus_type == FIMC_MIPI_CSI2) {
-		cfg |= S5P_CIGCTRL_SELCAM_MIPI;
+		cfg |= FIMC_REG_CIGCTRL_SELCAM_MIPI;
 
 		if (cam->mux_id == 0)
-			cfg |= S5P_CIGCTRL_SELCAM_MIPI_A;
+			cfg |= FIMC_REG_CIGCTRL_SELCAM_MIPI_A;
 
 		/* TODO: add remaining supported formats. */
 		switch (vid_cap->mf.code) {
 		case V4L2_MBUS_FMT_VYUY8_2X8:
-			tmp = S5P_CSIIMGFMT_YCBCR422_8BIT;
+			tmp = FIMC_REG_CSIIMGFMT_YCBCR422_8BIT;
 			break;
 		case V4L2_MBUS_FMT_JPEG_1X8:
-			tmp = S5P_CSIIMGFMT_USER(1);
-			cfg |= S5P_CIGCTRL_CAM_JPEG;
+			tmp = FIMC_REG_CSIIMGFMT_USER(1);
+			cfg |= FIMC_REG_CIGCTRL_CAM_JPEG;
 			break;
 		default:
 			v4l2_err(fimc->vid_cap.vfd,
@@ -706,19 +690,84 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 		}
 		tmp |= (csis_data_alignment == 32) << 8;
 
-		writel(tmp, fimc->regs + S5P_CSIIMGFMT);
+		writel(tmp, fimc->regs + FIMC_REG_CSIIMGFMT);
 
 	} else if (cam->bus_type == FIMC_ITU_601 ||
 		   cam->bus_type == FIMC_ITU_656) {
 		if (cam->mux_id == 0) /* ITU-A, ITU-B: 0, 1 */
-			cfg |= S5P_CIGCTRL_SELCAM_ITU_A;
+			cfg |= FIMC_REG_CIGCTRL_SELCAM_ITU_A;
 	} else if (cam->bus_type == FIMC_LCD_WB) {
-		cfg |= S5P_CIGCTRL_CAMIF_SELWB;
+		cfg |= FIMC_REG_CIGCTRL_CAMIF_SELWB;
 	} else {
 		err("invalid camera bus type selected\n");
 		return -EINVAL;
 	}
-	writel(cfg, fimc->regs + S5P_CIGCTRL);
+	writel(cfg, fimc->regs + FIMC_REG_CIGCTRL);
 
 	return 0;
 }
+
+void fimc_hw_clear_irq(struct fimc_dev *dev)
+{
+	u32 cfg = readl(dev->regs + FIMC_REG_CIGCTRL);
+	cfg |= FIMC_REG_CIGCTRL_IRQ_CLR;
+	writel(cfg, dev->regs + FIMC_REG_CIGCTRL);
+}
+
+void fimc_hw_enable_scaler(struct fimc_dev *dev, bool on)
+{
+	u32 cfg = readl(dev->regs + FIMC_REG_CISCCTRL);
+	if (on)
+		cfg |= FIMC_REG_CISCCTRL_SCALERSTART;
+	else
+		cfg &= ~FIMC_REG_CISCCTRL_SCALERSTART;
+	writel(cfg, dev->regs + FIMC_REG_CISCCTRL);
+}
+
+void fimc_hw_activate_input_dma(struct fimc_dev *dev, bool on)
+{
+	u32 cfg = readl(dev->regs + FIMC_REG_MSCTRL);
+	if (on)
+		cfg |= FIMC_REG_MSCTRL_ENVID;
+	else
+		cfg &= ~FIMC_REG_MSCTRL_ENVID;
+	writel(cfg, dev->regs + FIMC_REG_MSCTRL);
+}
+
+void fimc_hw_dis_capture(struct fimc_dev *dev)
+{
+	u32 cfg = readl(dev->regs + FIMC_REG_CIIMGCPT);
+	cfg &= ~(FIMC_REG_CIIMGCPT_IMGCPTEN | FIMC_REG_CIIMGCPT_IMGCPTEN_SC);
+	writel(cfg, dev->regs + FIMC_REG_CIIMGCPT);
+}
+
+/* Return an index to the buffer actually being written. */
+u32 fimc_hw_get_frame_index(struct fimc_dev *dev)
+{
+	u32 reg;
+
+	if (dev->variant->has_cistatus2) {
+		reg = readl(dev->regs + FIMC_REG_CISTATUS2) & 0x3F;
+		return reg > 0 ? --reg : reg;
+	}
+
+	reg = readl(dev->regs + FIMC_REG_CISTATUS);
+
+	return (reg & FIMC_REG_CISTATUS_FRAMECNT_MASK) >>
+		FIMC_REG_CISTATUS_FRAMECNT_SHIFT;
+}
+
+/* Locking: the caller holds fimc->slock */
+void fimc_activate_capture(struct fimc_ctx *ctx)
+{
+	fimc_hw_enable_scaler(ctx->fimc_dev, ctx->scaler.enabled);
+	fimc_hw_en_capture(ctx);
+}
+
+void fimc_deactivate_capture(struct fimc_dev *fimc)
+{
+	fimc_hw_en_lastirq(fimc, true);
+	fimc_hw_dis_capture(fimc);
+	fimc_hw_enable_scaler(fimc, false);
+	fimc_hw_en_lastirq(fimc, false);
+}
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.h b/drivers/media/video/s5p-fimc/fimc-reg.h
new file mode 100644
index 0000000..a612f07
--- /dev/null
+++ b/drivers/media/video/s5p-fimc/fimc-reg.h
@@ -0,0 +1,326 @@
+/*
+ * Samsung camera host interface (FIMC) registers definition
+ *
+ * Copyright (C) 2010 - 2012 Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef FIMC_REG_H_
+#define FIMC_REG_H_
+
+#include "fimc-core.h"
+
+/* Input source format */
+#define FIMC_REG_CISRCFMT			0x00
+#define FIMC_REG_CISRCFMT_ITU601_8BIT		(1 << 31)
+#define FIMC_REG_CISRCFMT_ITU601_16BIT		(1 << 29)
+#define FIMC_REG_CISRCFMT_ORDER422_YCBYCR	(0 << 14)
+#define FIMC_REG_CISRCFMT_ORDER422_YCRYCB	(1 << 14)
+#define FIMC_REG_CISRCFMT_ORDER422_CBYCRY	(2 << 14)
+#define FIMC_REG_CISRCFMT_ORDER422_CRYCBY	(3 << 14)
+
+/* Window offset */
+#define FIMC_REG_CIWDOFST			0x04
+#define FIMC_REG_CIWDOFST_OFF_EN		(1 << 31)
+#define FIMC_REG_CIWDOFST_CLROVFIY		(1 << 30)
+#define FIMC_REG_CIWDOFST_CLROVRLB		(1 << 29)
+#define FIMC_REG_CIWDOFST_HOROFF_MASK		(0x7ff << 16)
+#define FIMC_REG_CIWDOFST_CLROVFICB		(1 << 15)
+#define FIMC_REG_CIWDOFST_CLROVFICR		(1 << 14)
+#define FIMC_REG_CIWDOFST_VEROFF_MASK		(0xfff << 0)
+
+/* Global control */
+#define FIMC_REG_CIGCTRL			0x08
+#define FIMC_REG_CIGCTRL_SWRST			(1 << 31)
+#define FIMC_REG_CIGCTRL_CAMRST_A		(1 << 30)
+#define FIMC_REG_CIGCTRL_SELCAM_ITU_A		(1 << 29)
+#define FIMC_REG_CIGCTRL_TESTPAT_NORMAL		(0 << 27)
+#define FIMC_REG_CIGCTRL_TESTPAT_COLOR_BAR	(1 << 27)
+#define FIMC_REG_CIGCTRL_TESTPAT_HOR_INC	(2 << 27)
+#define FIMC_REG_CIGCTRL_TESTPAT_VER_INC	(3 << 27)
+#define FIMC_REG_CIGCTRL_TESTPAT_MASK		(3 << 27)
+#define FIMC_REG_CIGCTRL_TESTPAT_SHIFT		27
+#define FIMC_REG_CIGCTRL_INVPOLPCLK		(1 << 26)
+#define FIMC_REG_CIGCTRL_INVPOLVSYNC		(1 << 25)
+#define FIMC_REG_CIGCTRL_INVPOLHREF		(1 << 24)
+#define FIMC_REG_CIGCTRL_IRQ_OVFEN		(1 << 22)
+#define FIMC_REG_CIGCTRL_HREF_MASK		(1 << 21)
+#define FIMC_REG_CIGCTRL_IRQ_LEVEL		(1 << 20)
+#define FIMC_REG_CIGCTRL_IRQ_CLR		(1 << 19)
+#define FIMC_REG_CIGCTRL_IRQ_ENABLE		(1 << 16)
+#define FIMC_REG_CIGCTRL_SHDW_DISABLE		(1 << 12)
+#define FIMC_REG_CIGCTRL_CAM_JPEG		(1 << 8)
+#define FIMC_REG_CIGCTRL_SELCAM_MIPI_A		(1 << 7)
+#define FIMC_REG_CIGCTRL_CAMIF_SELWB		(1 << 6)
+/* 0 - ITU601; 1 - ITU709 */
+#define FIMC_REG_CIGCTRL_CSC_ITU601_709		(1 << 5)
+#define FIMC_REG_CIGCTRL_INVPOLHSYNC		(1 << 4)
+#define FIMC_REG_CIGCTRL_SELCAM_MIPI		(1 << 3)
+#define FIMC_REG_CIGCTRL_INVPOLFIELD		(1 << 1)
+#define FIMC_REG_CIGCTRL_INTERLACE		(1 << 0)
+
+/* Window offset 2 */
+#define FIMC_REG_CIWDOFST2			0x14
+#define FIMC_REG_CIWDOFST2_HOROFF_MASK		(0xfff << 16)
+#define FIMC_REG_CIWDOFST2_VEROFF_MASK		(0xfff << 0)
+
+/* Output DMA Y/Cb/Cr plane start addresses */
+#define FIMC_REG_CIOYSA(n)			(0x18 + (n) * 4)
+#define FIMC_REG_CIOCBSA(n)			(0x28 + (n) * 4)
+#define FIMC_REG_CIOCRSA(n)			(0x38 + (n) * 4)
+
+/* Target image format */
+#define FIMC_REG_CITRGFMT			0x48
+#define FIMC_REG_CITRGFMT_INROT90		(1 << 31)
+#define FIMC_REG_CITRGFMT_YCBCR420		(0 << 29)
+#define FIMC_REG_CITRGFMT_YCBCR422		(1 << 29)
+#define FIMC_REG_CITRGFMT_YCBCR422_1P		(2 << 29)
+#define FIMC_REG_CITRGFMT_RGB			(3 << 29)
+#define FIMC_REG_CITRGFMT_FMT_MASK		(3 << 29)
+#define FIMC_REG_CITRGFMT_HSIZE_MASK		(0xfff << 16)
+#define FIMC_REG_CITRGFMT_FLIP_SHIFT		14
+#define FIMC_REG_CITRGFMT_FLIP_NORMAL		(0 << 14)
+#define FIMC_REG_CITRGFMT_FLIP_X_MIRROR		(1 << 14)
+#define FIMC_REG_CITRGFMT_FLIP_Y_MIRROR		(2 << 14)
+#define FIMC_REG_CITRGFMT_FLIP_180		(3 << 14)
+#define FIMC_REG_CITRGFMT_FLIP_MASK		(3 << 14)
+#define FIMC_REG_CITRGFMT_OUTROT90		(1 << 13)
+#define FIMC_REG_CITRGFMT_VSIZE_MASK		(0xfff << 0)
+
+/* Output DMA control */
+#define FIMC_REG_CIOCTRL			0x4c
+#define FIMC_REG_CIOCTRL_ORDER422_MASK		(3 << 0)
+#define FIMC_REG_CIOCTRL_ORDER422_CRYCBY	(0 << 0)
+#define FIMC_REG_CIOCTRL_ORDER422_CBYCRY	(1 << 0)
+#define FIMC_REG_CIOCTRL_ORDER422_YCRYCB	(2 << 0)
+#define FIMC_REG_CIOCTRL_ORDER422_YCBYCR	(3 << 0)
+#define FIMC_REG_CIOCTRL_LASTIRQ_ENABLE		(1 << 2)
+#define FIMC_REG_CIOCTRL_YCBCR_3PLANE		(0 << 3)
+#define FIMC_REG_CIOCTRL_YCBCR_2PLANE		(1 << 3)
+#define FIMC_REG_CIOCTRL_YCBCR_PLANE_MASK	(1 << 3)
+#define FIMC_REG_CIOCTRL_ALPHA_OUT_MASK		(0xff << 4)
+#define FIMC_REG_CIOCTRL_RGB16FMT_MASK		(3 << 16)
+#define FIMC_REG_CIOCTRL_RGB565			(0 << 16)
+#define FIMC_REG_CIOCTRL_ARGB1555		(1 << 16)
+#define FIMC_REG_CIOCTRL_ARGB4444		(2 << 16)
+#define FIMC_REG_CIOCTRL_ORDER2P_SHIFT		24
+#define FIMC_REG_CIOCTRL_ORDER2P_MASK		(3 << 24)
+#define FIMC_REG_CIOCTRL_ORDER422_2P_LSB_CRCB	(0 << 24)
+
+/* Pre-scaler control 1 */
+#define FIMC_REG_CISCPRERATIO			0x50
+
+#define FIMC_REG_CISCPREDST			0x54
+
+/* Main scaler control */
+#define FIMC_REG_CISCCTRL			0x58
+#define FIMC_REG_CISCCTRL_SCALERBYPASS		(1 << 31)
+#define FIMC_REG_CISCCTRL_SCALEUP_H		(1 << 30)
+#define FIMC_REG_CISCCTRL_SCALEUP_V		(1 << 29)
+#define FIMC_REG_CISCCTRL_CSCR2Y_WIDE		(1 << 28)
+#define FIMC_REG_CISCCTRL_CSCY2R_WIDE		(1 << 27)
+#define FIMC_REG_CISCCTRL_LCDPATHEN_FIFO	(1 << 26)
+#define FIMC_REG_CISCCTRL_INTERLACE		(1 << 25)
+#define FIMC_REG_CISCCTRL_SCALERSTART		(1 << 15)
+#define FIMC_REG_CISCCTRL_INRGB_FMT_RGB565	(0 << 13)
+#define FIMC_REG_CISCCTRL_INRGB_FMT_RGB666	(1 << 13)
+#define FIMC_REG_CISCCTRL_INRGB_FMT_RGB888	(2 << 13)
+#define FIMC_REG_CISCCTRL_INRGB_FMT_MASK	(3 << 13)
+#define FIMC_REG_CISCCTRL_OUTRGB_FMT_RGB565	(0 << 11)
+#define FIMC_REG_CISCCTRL_OUTRGB_FMT_RGB666	(1 << 11)
+#define FIMC_REG_CISCCTRL_OUTRGB_FMT_RGB888	(2 << 11)
+#define FIMC_REG_CISCCTRL_OUTRGB_FMT_MASK	(3 << 11)
+#define FIMC_REG_CISCCTRL_RGB_EXT		(1 << 10)
+#define FIMC_REG_CISCCTRL_ONE2ONE		(1 << 9)
+#define FIMC_REG_CISCCTRL_MHRATIO(x)		((x) << 16)
+#define FIMC_REG_CISCCTRL_MVRATIO(x)		((x) << 0)
+#define FIMC_REG_CISCCTRL_MHRATIO_MASK		(0x1ff << 16)
+#define FIMC_REG_CISCCTRL_MVRATIO_MASK		(0x1ff << 0)
+#define FIMC_REG_CISCCTRL_MHRATIO_EXT(x)	(((x) >> 6) << 16)
+#define FIMC_REG_CISCCTRL_MVRATIO_EXT(x)	(((x) >> 6) << 0)
+
+/* Target area */
+#define FIMC_REG_CITAREA			0x5c
+#define FIMC_REG_CITAREA_MASK			0x0fffffff
+
+/* General status */
+#define FIMC_REG_CISTATUS			0x64
+#define FIMC_REG_CISTATUS_OVFIY			(1 << 31)
+#define FIMC_REG_CISTATUS_OVFICB		(1 << 30)
+#define FIMC_REG_CISTATUS_OVFICR		(1 << 29)
+#define FIMC_REG_CISTATUS_VSYNC			(1 << 28)
+#define FIMC_REG_CISTATUS_FRAMECNT_MASK		(3 << 26)
+#define FIMC_REG_CISTATUS_FRAMECNT_SHIFT	26
+#define FIMC_REG_CISTATUS_WINOFF_EN		(1 << 25)
+#define FIMC_REG_CISTATUS_IMGCPT_EN		(1 << 22)
+#define FIMC_REG_CISTATUS_IMGCPT_SCEN		(1 << 21)
+#define FIMC_REG_CISTATUS_VSYNC_A		(1 << 20)
+#define FIMC_REG_CISTATUS_VSYNC_B		(1 << 19)
+#define FIMC_REG_CISTATUS_OVRLB			(1 << 18)
+#define FIMC_REG_CISTATUS_FRAME_END		(1 << 17)
+#define FIMC_REG_CISTATUS_LASTCAPT_END		(1 << 16)
+#define FIMC_REG_CISTATUS_VVALID_A		(1 << 15)
+#define FIMC_REG_CISTATUS_VVALID_B		(1 << 14)
+
+/* Indexes to the last and the currently processed buffer. */
+#define FIMC_REG_CISTATUS2			0x68
+
+/* Image capture control */
+#define FIMC_REG_CIIMGCPT			0xc0
+#define FIMC_REG_CIIMGCPT_IMGCPTEN		(1 << 31)
+#define FIMC_REG_CIIMGCPT_IMGCPTEN_SC		(1 << 30)
+#define FIMC_REG_CIIMGCPT_CPT_FREN_ENABLE	(1 << 25)
+#define FIMC_REG_CIIMGCPT_CPT_FRMOD_CNT		(1 << 18)
+
+/* Frame capture sequence */
+#define FIMC_REG_CICPTSEQ			0xc4
+
+/* Image effect */
+#define FIMC_REG_CIIMGEFF			0xd0
+#define FIMC_REG_CIIMGEFF_IE_ENABLE		(1 << 30)
+#define FIMC_REG_CIIMGEFF_IE_SC_BEFORE		(0 << 29)
+#define FIMC_REG_CIIMGEFF_IE_SC_AFTER		(1 << 29)
+#define FIMC_REG_CIIMGEFF_FIN_BYPASS		(0 << 26)
+#define FIMC_REG_CIIMGEFF_FIN_ARBITRARY		(1 << 26)
+#define FIMC_REG_CIIMGEFF_FIN_NEGATIVE		(2 << 26)
+#define FIMC_REG_CIIMGEFF_FIN_ARTFREEZE		(3 << 26)
+#define FIMC_REG_CIIMGEFF_FIN_EMBOSSING		(4 << 26)
+#define FIMC_REG_CIIMGEFF_FIN_SILHOUETTE	(5 << 26)
+#define FIMC_REG_CIIMGEFF_FIN_MASK		(7 << 26)
+#define FIMC_REG_CIIMGEFF_PAT_CBCR_MASK		((0xff << 13) | 0xff)
+
+/* Input DMA Y/Cb/Cr plane start address 0/1 */
+#define FIMC_REG_CIIYSA(n)			(0xd4 + (n) * 0x70)
+#define FIMC_REG_CIICBSA(n)			(0xd8 + (n) * 0x70)
+#define FIMC_REG_CIICRSA(n)			(0xdc + (n) * 0x70)
+
+/* Real input DMA image size */
+#define FIMC_REG_CIREAL_ISIZE			0xf8
+#define FIMC_REG_CIREAL_ISIZE_AUTOLOAD_EN	(1 << 31)
+#define FIMC_REG_CIREAL_ISIZE_ADDR_CH_DIS	(1 << 30)
+
+/* Input DMA control */
+#define FIMC_REG_MSCTRL				0xfc
+#define FIMC_REG_MSCTRL_IN_BURST_COUNT_MASK	(0xf << 24)
+#define FIMC_REG_MSCTRL_2P_IN_ORDER_MASK	(3 << 16)
+#define FIMC_REG_MSCTRL_2P_IN_ORDER_SHIFT	16
+#define FIMC_REG_MSCTRL_C_INT_IN_3PLANE		(0 << 15)
+#define FIMC_REG_MSCTRL_C_INT_IN_2PLANE		(1 << 15)
+#define FIMC_REG_MSCTRL_C_INT_IN_MASK		(1 << 15)
+#define FIMC_REG_MSCTRL_FLIP_SHIFT		13
+#define FIMC_REG_MSCTRL_FLIP_MASK		(3 << 13)
+#define FIMC_REG_MSCTRL_FLIP_NORMAL		(0 << 13)
+#define FIMC_REG_MSCTRL_FLIP_X_MIRROR		(1 << 13)
+#define FIMC_REG_MSCTRL_FLIP_Y_MIRROR		(2 << 13)
+#define FIMC_REG_MSCTRL_FLIP_180		(3 << 13)
+#define FIMC_REG_MSCTRL_FIFO_CTRL_FULL		(1 << 12)
+#define FIMC_REG_MSCTRL_ORDER422_SHIFT		4
+#define FIMC_REG_MSCTRL_ORDER422_YCBYCR		(0 << 4)
+#define FIMC_REG_MSCTRL_ORDER422_CBYCRY		(1 << 4)
+#define FIMC_REG_MSCTRL_ORDER422_YCRYCB		(2 << 4)
+#define FIMC_REG_MSCTRL_ORDER422_CRYCBY		(3 << 4)
+#define FIMC_REG_MSCTRL_ORDER422_MASK		(3 << 4)
+#define FIMC_REG_MSCTRL_INPUT_EXTCAM		(0 << 3)
+#define FIMC_REG_MSCTRL_INPUT_MEMORY		(1 << 3)
+#define FIMC_REG_MSCTRL_INPUT_MASK		(1 << 3)
+#define FIMC_REG_MSCTRL_INFORMAT_YCBCR420	(0 << 1)
+#define FIMC_REG_MSCTRL_INFORMAT_YCBCR422	(1 << 1)
+#define FIMC_REG_MSCTRL_INFORMAT_YCBCR422_1P 	(2 << 1)
+#define FIMC_REG_MSCTRL_INFORMAT_RGB		(3 << 1)
+#define FIMC_REG_MSCTRL_INFORMAT_MASK		(3 << 1)
+#define FIMC_REG_MSCTRL_ENVID			(1 << 0)
+#define FIMC_REG_MSCTRL_IN_BURST_COUNT(x)	((x) << 24)
+
+/* Output DMA Y/Cb/Cr offset */
+#define FIMC_REG_CIOYOFF			0x168
+#define FIMC_REG_CIOCBOFF			0x16c
+#define FIMC_REG_CIOCROFF			0x170
+
+/* Input DMA Y/Cb/Cr offset */
+#define FIMC_REG_CIIYOFF			0x174
+#define FIMC_REG_CIICBOFF			0x178
+#define FIMC_REG_CIICROFF			0x17c
+
+/* Input DMA original image size */
+#define FIMC_REG_ORGISIZE			0x180
+
+/* Output DMA original image size */
+#define FIMC_REG_ORGOSIZE			0x184
+
+/* Real output DMA image size (extension register) */
+#define FIMC_REG_CIEXTEN			0x188
+#define FIMC_REG_CIEXTEN_MHRATIO_EXT(x)		(((x) & 0x3f) << 10)
+#define FIMC_REG_CIEXTEN_MVRATIO_EXT(x)		((x) & 0x3f)
+#define FIMC_REG_CIEXTEN_MHRATIO_EXT_MASK	(0x3f << 10)
+#define FIMC_REG_CIEXTEN_MVRATIO_EXT_MASK	0x3f
+
+#define FIMC_REG_CIDMAPARAM			0x18c
+#define FIMC_REG_CIDMAPARAM_R_LINEAR		(0 << 29)
+#define FIMC_REG_CIDMAPARAM_R_64X32		(3 << 29)
+#define FIMC_REG_CIDMAPARAM_W_LINEAR		(0 << 13)
+#define FIMC_REG_CIDMAPARAM_W_64X32		(3 << 13)
+#define FIMC_REG_CIDMAPARAM_TILE_MASK		((3 << 29) | (3 << 13))
+
+/* MIPI CSI image format */
+#define FIMC_REG_CSIIMGFMT			0x194
+#define FIMC_REG_CSIIMGFMT_YCBCR422_8BIT	0x1e
+#define FIMC_REG_CSIIMGFMT_RAW8			0x2a
+#define FIMC_REG_CSIIMGFMT_RAW10		0x2b
+#define FIMC_REG_CSIIMGFMT_RAW12		0x2c
+/* User defined formats. x = 0...16. */
+#define FIMC_REG_CSIIMGFMT_USER(x)		(0x30 + x - 1)
+
+/* Output frame buffer sequence mask */
+#define FIMC_REG_CIFCNTSEQ			0x1fc
+
+/*
+ * Function declarations
+ */
+void fimc_hw_reset(struct fimc_dev *fimc);
+void fimc_hw_set_rotation(struct fimc_ctx *ctx);
+void fimc_hw_set_target_format(struct fimc_ctx *ctx);
+void fimc_hw_set_out_dma(struct fimc_ctx *ctx);
+void fimc_hw_en_lastirq(struct fimc_dev *fimc, int enable);
+void fimc_hw_en_irq(struct fimc_dev *fimc, int enable);
+void fimc_hw_set_prescaler(struct fimc_ctx *ctx);
+void fimc_hw_set_mainscaler(struct fimc_ctx *ctx);
+void fimc_hw_en_capture(struct fimc_ctx *ctx);
+void fimc_hw_set_effect(struct fimc_ctx *ctx, bool active);
+void fimc_hw_set_rgb_alpha(struct fimc_ctx *ctx);
+void fimc_hw_set_in_dma(struct fimc_ctx *ctx);
+void fimc_hw_set_input_path(struct fimc_ctx *ctx);
+void fimc_hw_set_output_path(struct fimc_ctx *ctx);
+void fimc_hw_set_input_addr(struct fimc_dev *fimc, struct fimc_addr *paddr);
+void fimc_hw_set_output_addr(struct fimc_dev *fimc, struct fimc_addr *paddr,
+			     int index);
+int fimc_hw_set_camera_source(struct fimc_dev *fimc,
+			      struct s5p_fimc_isp_info *cam);
+void fimc_hw_set_camera_offset(struct fimc_dev *fimc, struct fimc_frame *f);
+int fimc_hw_set_camera_polarity(struct fimc_dev *fimc,
+				struct s5p_fimc_isp_info *cam);
+int fimc_hw_set_camera_type(struct fimc_dev *fimc,
+			    struct s5p_fimc_isp_info *cam);
+void fimc_hw_clear_irq(struct fimc_dev *dev);
+void fimc_hw_enable_scaler(struct fimc_dev *dev, bool on);
+void fimc_hw_activate_input_dma(struct fimc_dev *dev, bool on);
+void fimc_hw_dis_capture(struct fimc_dev *dev);
+u32 fimc_hw_get_frame_index(struct fimc_dev *dev);
+void fimc_activate_capture(struct fimc_ctx *ctx);
+void fimc_deactivate_capture(struct fimc_dev *fimc);
+
+/**
+ * fimc_hw_set_dma_seq - configure output DMA buffer sequence
+ * @mask: bitmask for the DMA output buffer registers, set to 0 to skip buffer
+ * This function masks output DMA ring buffers, it allows to select which of
+ * the 32 available output buffer address registers will be used by the DMA
+ * engine.
+ */
+static inline void fimc_hw_set_dma_seq(struct fimc_dev *dev, u32 mask)
+{
+	writel(mask, dev->regs + FIMC_REG_CIFCNTSEQ);
+}
+
+#endif /* FIMC_REG_H_ */
diff --git a/drivers/media/video/s5p-fimc/regs-fimc.h b/drivers/media/video/s5p-fimc/regs-fimc.h
deleted file mode 100644
index c7a5bc5..0000000
--- a/drivers/media/video/s5p-fimc/regs-fimc.h
+++ /dev/null
@@ -1,301 +0,0 @@
-/*
- * Register definition file for Samsung Camera Interface (FIMC) driver
- *
- * Copyright (c) 2010 Samsung Electronics
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef REGS_FIMC_H_
-#define REGS_FIMC_H_
-
-/* Input source format */
-#define S5P_CISRCFMT			0x00
-#define S5P_CISRCFMT_ITU601_8BIT	(1 << 31)
-#define S5P_CISRCFMT_ITU601_16BIT	(1 << 29)
-#define S5P_CISRCFMT_ORDER422_YCBYCR	(0 << 14)
-#define S5P_CISRCFMT_ORDER422_YCRYCB	(1 << 14)
-#define S5P_CISRCFMT_ORDER422_CBYCRY	(2 << 14)
-#define S5P_CISRCFMT_ORDER422_CRYCBY	(3 << 14)
-#define S5P_CISRCFMT_HSIZE(x)		((x) << 16)
-#define S5P_CISRCFMT_VSIZE(x)		((x) << 0)
-
-/* Window offset */
-#define S5P_CIWDOFST			0x04
-#define S5P_CIWDOFST_OFF_EN		(1 << 31)
-#define S5P_CIWDOFST_CLROVFIY		(1 << 30)
-#define S5P_CIWDOFST_CLROVRLB		(1 << 29)
-#define S5P_CIWDOFST_HOROFF_MASK	(0x7ff << 16)
-#define S5P_CIWDOFST_CLROVFICB		(1 << 15)
-#define S5P_CIWDOFST_CLROVFICR		(1 << 14)
-#define S5P_CIWDOFST_HOROFF(x)		((x) << 16)
-#define S5P_CIWDOFST_VEROFF(x)		((x) << 0)
-#define S5P_CIWDOFST_VEROFF_MASK	(0xfff << 0)
-
-/* Global control */
-#define S5P_CIGCTRL			0x08
-#define S5P_CIGCTRL_SWRST		(1 << 31)
-#define S5P_CIGCTRL_CAMRST_A		(1 << 30)
-#define S5P_CIGCTRL_SELCAM_ITU_A	(1 << 29)
-#define S5P_CIGCTRL_TESTPAT_NORMAL	(0 << 27)
-#define S5P_CIGCTRL_TESTPAT_COLOR_BAR	(1 << 27)
-#define S5P_CIGCTRL_TESTPAT_HOR_INC	(2 << 27)
-#define S5P_CIGCTRL_TESTPAT_VER_INC	(3 << 27)
-#define S5P_CIGCTRL_TESTPAT_MASK	(3 << 27)
-#define S5P_CIGCTRL_TESTPAT_SHIFT	(27)
-#define S5P_CIGCTRL_INVPOLPCLK		(1 << 26)
-#define S5P_CIGCTRL_INVPOLVSYNC		(1 << 25)
-#define S5P_CIGCTRL_INVPOLHREF		(1 << 24)
-#define S5P_CIGCTRL_IRQ_OVFEN		(1 << 22)
-#define S5P_CIGCTRL_HREF_MASK		(1 << 21)
-#define S5P_CIGCTRL_IRQ_LEVEL		(1 << 20)
-#define S5P_CIGCTRL_IRQ_CLR		(1 << 19)
-#define S5P_CIGCTRL_IRQ_ENABLE		(1 << 16)
-#define S5P_CIGCTRL_SHDW_DISABLE	(1 << 12)
-#define S5P_CIGCTRL_CAM_JPEG		(1 << 8)
-#define S5P_CIGCTRL_SELCAM_MIPI_A	(1 << 7)
-#define S5P_CIGCTRL_CAMIF_SELWB		(1 << 6)
-/* 0 - ITU601; 1 - ITU709 */
-#define S5P_CIGCTRL_CSC_ITU601_709	(1 << 5)
-#define S5P_CIGCTRL_INVPOLHSYNC		(1 << 4)
-#define S5P_CIGCTRL_SELCAM_MIPI		(1 << 3)
-#define S5P_CIGCTRL_INVPOLFIELD		(1 << 1)
-#define S5P_CIGCTRL_INTERLACE		(1 << 0)
-
-/* Window offset 2 */
-#define S5P_CIWDOFST2			0x14
-#define S5P_CIWDOFST2_HOROFF_MASK	(0xfff << 16)
-#define S5P_CIWDOFST2_VEROFF_MASK	(0xfff << 0)
-#define S5P_CIWDOFST2_HOROFF(x)		((x) << 16)
-#define S5P_CIWDOFST2_VEROFF(x)		((x) << 0)
-
-/* Output DMA Y/Cb/Cr plane start addresses */
-#define S5P_CIOYSA(n)			(0x18 + (n) * 4)
-#define S5P_CIOCBSA(n)			(0x28 + (n) * 4)
-#define S5P_CIOCRSA(n)			(0x38 + (n) * 4)
-
-/* Target image format */
-#define S5P_CITRGFMT			0x48
-#define S5P_CITRGFMT_INROT90		(1 << 31)
-#define S5P_CITRGFMT_YCBCR420		(0 << 29)
-#define S5P_CITRGFMT_YCBCR422		(1 << 29)
-#define S5P_CITRGFMT_YCBCR422_1P	(2 << 29)
-#define S5P_CITRGFMT_RGB		(3 << 29)
-#define S5P_CITRGFMT_FMT_MASK		(3 << 29)
-#define S5P_CITRGFMT_HSIZE_MASK		(0xfff << 16)
-#define S5P_CITRGFMT_FLIP_SHIFT		(14)
-#define S5P_CITRGFMT_FLIP_NORMAL	(0 << 14)
-#define S5P_CITRGFMT_FLIP_X_MIRROR	(1 << 14)
-#define S5P_CITRGFMT_FLIP_Y_MIRROR	(2 << 14)
-#define S5P_CITRGFMT_FLIP_180		(3 << 14)
-#define S5P_CITRGFMT_FLIP_MASK		(3 << 14)
-#define S5P_CITRGFMT_OUTROT90		(1 << 13)
-#define S5P_CITRGFMT_VSIZE_MASK		(0xfff << 0)
-#define S5P_CITRGFMT_HSIZE(x)		((x) << 16)
-#define S5P_CITRGFMT_VSIZE(x)		((x) << 0)
-
-/* Output DMA control */
-#define S5P_CIOCTRL			0x4c
-#define S5P_CIOCTRL_ORDER422_MASK	(3 << 0)
-#define S5P_CIOCTRL_ORDER422_CRYCBY	(0 << 0)
-#define S5P_CIOCTRL_ORDER422_CBYCRY	(1 << 0)
-#define S5P_CIOCTRL_ORDER422_YCRYCB	(2 << 0)
-#define S5P_CIOCTRL_ORDER422_YCBYCR	(3 << 0)
-#define S5P_CIOCTRL_LASTIRQ_ENABLE	(1 << 2)
-#define S5P_CIOCTRL_YCBCR_3PLANE	(0 << 3)
-#define S5P_CIOCTRL_YCBCR_2PLANE	(1 << 3)
-#define S5P_CIOCTRL_YCBCR_PLANE_MASK	(1 << 3)
-#define S5P_CIOCTRL_ALPHA_OUT_MASK	(0xff << 4)
-#define S5P_CIOCTRL_RGB16FMT_MASK	(3 << 16)
-#define S5P_CIOCTRL_RGB565		(0 << 16)
-#define S5P_CIOCTRL_ARGB1555		(1 << 16)
-#define S5P_CIOCTRL_ARGB4444		(2 << 16)
-#define S5P_CIOCTRL_ORDER2P_SHIFT	(24)
-#define S5P_CIOCTRL_ORDER2P_MASK	(3 << 24)
-#define S5P_CIOCTRL_ORDER422_2P_LSB_CRCB (0 << 24)
-
-/* Pre-scaler control 1 */
-#define S5P_CISCPRERATIO		0x50
-#define S5P_CISCPRERATIO_SHFACTOR(x)	((x) << 28)
-#define S5P_CISCPRERATIO_HOR(x)		((x) << 16)
-#define S5P_CISCPRERATIO_VER(x)		((x) << 0)
-
-#define S5P_CISCPREDST			0x54
-#define S5P_CISCPREDST_WIDTH(x)		((x) << 16)
-#define S5P_CISCPREDST_HEIGHT(x)	((x) << 0)
-
-/* Main scaler control */
-#define S5P_CISCCTRL			0x58
-#define S5P_CISCCTRL_SCALERBYPASS	(1 << 31)
-#define S5P_CISCCTRL_SCALEUP_H		(1 << 30)
-#define S5P_CISCCTRL_SCALEUP_V		(1 << 29)
-#define S5P_CISCCTRL_CSCR2Y_WIDE	(1 << 28)
-#define S5P_CISCCTRL_CSCY2R_WIDE	(1 << 27)
-#define S5P_CISCCTRL_LCDPATHEN_FIFO	(1 << 26)
-#define S5P_CISCCTRL_INTERLACE		(1 << 25)
-#define S5P_CISCCTRL_SCALERSTART	(1 << 15)
-#define S5P_CISCCTRL_INRGB_FMT_RGB565	(0 << 13)
-#define S5P_CISCCTRL_INRGB_FMT_RGB666	(1 << 13)
-#define S5P_CISCCTRL_INRGB_FMT_RGB888	(2 << 13)
-#define S5P_CISCCTRL_INRGB_FMT_MASK	(3 << 13)
-#define S5P_CISCCTRL_OUTRGB_FMT_RGB565	(0 << 11)
-#define S5P_CISCCTRL_OUTRGB_FMT_RGB666	(1 << 11)
-#define S5P_CISCCTRL_OUTRGB_FMT_RGB888	(2 << 11)
-#define S5P_CISCCTRL_OUTRGB_FMT_MASK	(3 << 11)
-#define S5P_CISCCTRL_RGB_EXT		(1 << 10)
-#define S5P_CISCCTRL_ONE2ONE		(1 << 9)
-#define S5P_CISCCTRL_MHRATIO(x)		((x) << 16)
-#define S5P_CISCCTRL_MVRATIO(x)		((x) << 0)
-#define S5P_CISCCTRL_MHRATIO_MASK	(0x1ff << 16)
-#define S5P_CISCCTRL_MVRATIO_MASK	(0x1ff << 0)
-#define S5P_CISCCTRL_MHRATIO_EXT(x)	(((x) >> 6) << 16)
-#define S5P_CISCCTRL_MVRATIO_EXT(x)	(((x) >> 6) << 0)
-
-/* Target area */
-#define S5P_CITAREA			0x5c
-#define S5P_CITAREA_MASK		0x0fffffff
-
-/* General status */
-#define S5P_CISTATUS			0x64
-#define S5P_CISTATUS_OVFIY		(1 << 31)
-#define S5P_CISTATUS_OVFICB		(1 << 30)
-#define S5P_CISTATUS_OVFICR		(1 << 29)
-#define S5P_CISTATUS_VSYNC		(1 << 28)
-#define S5P_CISTATUS_FRAMECNT_MASK	(3 << 26)
-#define S5P_CISTATUS_FRAMECNT_SHIFT	26
-#define S5P_CISTATUS_WINOFF_EN		(1 << 25)
-#define S5P_CISTATUS_IMGCPT_EN		(1 << 22)
-#define S5P_CISTATUS_IMGCPT_SCEN	(1 << 21)
-#define S5P_CISTATUS_VSYNC_A		(1 << 20)
-#define S5P_CISTATUS_VSYNC_B		(1 << 19)
-#define S5P_CISTATUS_OVRLB		(1 << 18)
-#define S5P_CISTATUS_FRAME_END		(1 << 17)
-#define S5P_CISTATUS_LASTCAPT_END	(1 << 16)
-#define S5P_CISTATUS_VVALID_A		(1 << 15)
-#define S5P_CISTATUS_VVALID_B		(1 << 14)
-
-/* Indexes to the last and the currently processed buffer. */
-#define S5P_CISTATUS2			0x68
-
-/* Image capture control */
-#define S5P_CIIMGCPT			0xc0
-#define S5P_CIIMGCPT_IMGCPTEN		(1 << 31)
-#define S5P_CIIMGCPT_IMGCPTEN_SC	(1 << 30)
-#define S5P_CIIMGCPT_CPT_FREN_ENABLE	(1 << 25)
-#define S5P_CIIMGCPT_CPT_FRMOD_CNT	(1 << 18)
-
-/* Frame capture sequence */
-#define S5P_CICPTSEQ			0xc4
-
-/* Image effect */
-#define S5P_CIIMGEFF			0xd0
-#define S5P_CIIMGEFF_IE_ENABLE		(1 << 30)
-#define S5P_CIIMGEFF_IE_SC_BEFORE	(0 << 29)
-#define S5P_CIIMGEFF_IE_SC_AFTER	(1 << 29)
-#define S5P_CIIMGEFF_FIN_BYPASS		(0 << 26)
-#define S5P_CIIMGEFF_FIN_ARBITRARY	(1 << 26)
-#define S5P_CIIMGEFF_FIN_NEGATIVE	(2 << 26)
-#define S5P_CIIMGEFF_FIN_ARTFREEZE	(3 << 26)
-#define S5P_CIIMGEFF_FIN_EMBOSSING	(4 << 26)
-#define S5P_CIIMGEFF_FIN_SILHOUETTE	(5 << 26)
-#define S5P_CIIMGEFF_FIN_MASK		(7 << 26)
-#define S5P_CIIMGEFF_PAT_CBCR_MASK	((0xff < 13) | (0xff < 0))
-#define S5P_CIIMGEFF_PAT_CB(x)		((x) << 13)
-#define S5P_CIIMGEFF_PAT_CR(x)		((x) << 0)
-
-/* Input DMA Y/Cb/Cr plane start address 0/1 */
-#define S5P_CIIYSA(n)			(0xd4 + (n) * 0x70)
-#define S5P_CIICBSA(n)			(0xd8 + (n) * 0x70)
-#define S5P_CIICRSA(n)			(0xdc + (n) * 0x70)
-
-/* Real input DMA image size */
-#define S5P_CIREAL_ISIZE		0xf8
-#define S5P_CIREAL_ISIZE_AUTOLOAD_EN	(1 << 31)
-#define S5P_CIREAL_ISIZE_ADDR_CH_DIS	(1 << 30)
-#define S5P_CIREAL_ISIZE_HEIGHT(x)	((x) << 16)
-#define S5P_CIREAL_ISIZE_WIDTH(x)	((x) << 0)
-
-
-/* Input DMA control */
-#define S5P_MSCTRL			0xfc
-#define S5P_MSCTRL_IN_BURST_COUNT_MASK	(0xF << 24)
-#define S5P_MSCTRL_2P_IN_ORDER_MASK	(3 << 16)
-#define S5P_MSCTRL_2P_IN_ORDER_SHIFT	16
-#define S5P_MSCTRL_C_INT_IN_3PLANE	(0 << 15)
-#define S5P_MSCTRL_C_INT_IN_2PLANE	(1 << 15)
-#define S5P_MSCTRL_C_INT_IN_MASK	(1 << 15)
-#define S5P_MSCTRL_FLIP_SHIFT		13
-#define S5P_MSCTRL_FLIP_MASK		(3 << 13)
-#define S5P_MSCTRL_FLIP_NORMAL		(0 << 13)
-#define S5P_MSCTRL_FLIP_X_MIRROR	(1 << 13)
-#define S5P_MSCTRL_FLIP_Y_MIRROR	(2 << 13)
-#define S5P_MSCTRL_FLIP_180		(3 << 13)
-#define S5P_MSCTRL_FIFO_CTRL_FULL	(1 << 12)
-#define S5P_MSCTRL_ORDER422_SHIFT	4
-#define S5P_MSCTRL_ORDER422_YCBYCR	(0 << 4)
-#define S5P_MSCTRL_ORDER422_CBYCRY	(1 << 4)
-#define S5P_MSCTRL_ORDER422_YCRYCB	(2 << 4)
-#define S5P_MSCTRL_ORDER422_CRYCBY	(3 << 4)
-#define S5P_MSCTRL_ORDER422_MASK	(3 << 4)
-#define S5P_MSCTRL_INPUT_EXTCAM		(0 << 3)
-#define S5P_MSCTRL_INPUT_MEMORY		(1 << 3)
-#define S5P_MSCTRL_INPUT_MASK		(1 << 3)
-#define S5P_MSCTRL_INFORMAT_YCBCR420	(0 << 1)
-#define S5P_MSCTRL_INFORMAT_YCBCR422	(1 << 1)
-#define S5P_MSCTRL_INFORMAT_YCBCR422_1P	(2 << 1)
-#define S5P_MSCTRL_INFORMAT_RGB		(3 << 1)
-#define S5P_MSCTRL_INFORMAT_MASK	(3 << 1)
-#define S5P_MSCTRL_ENVID		(1 << 0)
-#define S5P_MSCTRL_IN_BURST_COUNT(x)	((x) << 24)
-
-/* Output DMA Y/Cb/Cr offset */
-#define S5P_CIOYOFF			0x168
-#define S5P_CIOCBOFF			0x16c
-#define S5P_CIOCROFF			0x170
-
-/* Input DMA Y/Cb/Cr offset */
-#define S5P_CIIYOFF			0x174
-#define S5P_CIICBOFF			0x178
-#define S5P_CIICROFF			0x17c
-
-#define S5P_CIO_OFFS_VER(x)		((x) << 16)
-#define S5P_CIO_OFFS_HOR(x)		((x) << 0)
-
-/* Input DMA original image size */
-#define S5P_ORGISIZE			0x180
-
-/* Output DMA original image size */
-#define S5P_ORGOSIZE			0x184
-
-#define S5P_ORIG_SIZE_VER(x)		((x) << 16)
-#define S5P_ORIG_SIZE_HOR(x)		((x) << 0)
-
-/* Real output DMA image size (extension register) */
-#define S5P_CIEXTEN			0x188
-#define S5P_CIEXTEN_MHRATIO_EXT(x)	(((x) & 0x3f) << 10)
-#define S5P_CIEXTEN_MVRATIO_EXT(x)	((x) & 0x3f)
-#define S5P_CIEXTEN_MHRATIO_EXT_MASK	(0x3f << 10)
-#define S5P_CIEXTEN_MVRATIO_EXT_MASK	0x3f
-
-#define S5P_CIDMAPARAM			0x18c
-#define S5P_CIDMAPARAM_R_LINEAR		(0 << 29)
-#define S5P_CIDMAPARAM_R_64X32		(3 << 29)
-#define S5P_CIDMAPARAM_W_LINEAR		(0 << 13)
-#define S5P_CIDMAPARAM_W_64X32		(3 << 13)
-#define S5P_CIDMAPARAM_TILE_MASK	((3 << 29) | (3 << 13))
-
-/* MIPI CSI image format */
-#define S5P_CSIIMGFMT			0x194
-#define S5P_CSIIMGFMT_YCBCR422_8BIT	0x1e
-#define S5P_CSIIMGFMT_RAW8		0x2a
-#define S5P_CSIIMGFMT_RAW10		0x2b
-#define S5P_CSIIMGFMT_RAW12		0x2c
-/* User defined formats. x = 0...16. */
-#define S5P_CSIIMGFMT_USER(x)		(0x30 + x - 1)
-
-/* Output frame buffer sequence mask */
-#define S5P_CIFCNTSEQ			0x1FC
-
-#endif /* REGS_FIMC_H_ */
-- 
1.7.10

