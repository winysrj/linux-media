Return-path: <mchehab@gaivota>
Received: from ganesha.gnumonks.org ([213.95.27.120]:37195 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab0LWBrp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 20:47:45 -0500
From: Hyunwoong Kim <khw0178.kim@samsung.com>
To: s.nawrocki@samsung.com
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	Hyunwoong Kim <khw0178.kim@samsung.com>
Subject: [PATCH v2.1] [media] s5p-fimc: Configure scaler registers depending on FIMC version
Date: Thu, 23 Dec 2010 10:26:16 +0900
Message-Id: <1293067576-18614-1-git-send-email-khw0178.kim@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The main scaler has four SFRs for main scaler ratio depending on FIMC version.
FIMC 4.x has only two SFRs and FIMC 5.x has four SFRs for main scaler.
Those are MainHorRatio, MainHorRatio_ext, MainVerRatio and MainverRatio_ext.

The FIMC 5.x has 15 bit resolution for scaling ratio as below.
{MainHorRatio,MainHorRatio_ext} = {[14:6],[5:0]}.
{MainVerRatio,MainVerRatio_ext} = {[14:6],[5:0]}.
MainHorRatio = CISCCTRL[24:16], MainHorRatio_ext = CIEXTEN[15:10]
MainVerRatio = CISCCTRL[8:0],   MainVerRatio_ext = CIEXTEN[5:0]

This patch supports FIMC 4.x and FIMC 5.x using platform_device_id::driver_data.

Reviewed-by: Jonghun Han <jonghun.han@samsung.com>
Signed-off-by: Hyunwoong Kim <khw0178.kim@samsung.com>
---
Depends on the below patch
- [PATCH v3.2] [media] s5p-fimc: fix the value of YUV422 1-plane formats

Changes since V2:
- Code sync with http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/vb2-mfc-fimc

Changes since V1:
- Change the summary line.
- Change the definitions of extended mainscaler ratios
  commented by Sylwester Nawrocki.
- Change the conditional expressions.

 drivers/media/video/s5p-fimc/fimc-capture.c |    7 +++-
 drivers/media/video/s5p-fimc/fimc-core.c    |   22 ++++++++++--
 drivers/media/video/s5p-fimc/fimc-core.h    |    7 +++-
 drivers/media/video/s5p-fimc/fimc-reg.c     |   52 +++++++++++++++++++++++---
 drivers/media/video/s5p-fimc/regs-fimc.h    |   12 +++++-
 5 files changed, 87 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 4e4441f..b1cb937 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -210,6 +210,7 @@ static int start_streaming(struct vb2_queue *q)
 	struct fimc_ctx *ctx = q->drv_priv;
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct s3c_fimc_isp_info *isp_info;
+	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
 	int ret;
 
 	ret = v4l2_subdev_call(fimc->vid_cap.sd, video, s_stream, 1);
@@ -232,7 +233,11 @@ static int start_streaming(struct vb2_queue *q)
 			return ret;
 		}
 		fimc_hw_set_input_path(ctx);
-		fimc_hw_set_scaler(ctx);
+		fimc_hw_set_prescaler(ctx);
+		if (variant->has_mainscaler_ext)
+			fimc_hw_set_mainscaler_ext(ctx);
+		else
+			fimc_hw_set_mainscaler(ctx);
 		fimc_hw_set_target_format(ctx);
 		fimc_hw_set_rotation(ctx);
 		fimc_hw_set_effect(ctx);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 6e388ff..2b65961 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -246,6 +246,7 @@ int fimc_set_scaler_info(struct fimc_ctx *ctx)
 	struct fimc_scaler *sc = &ctx->scaler;
 	struct fimc_frame *s_frame = &ctx->s_frame;
 	struct fimc_frame *d_frame = &ctx->d_frame;
+	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
 	int tx, ty, sx, sy;
 	int ret;
 
@@ -284,8 +285,14 @@ int fimc_set_scaler_info(struct fimc_ctx *ctx)
 	sc->pre_dst_width = sx / sc->pre_hratio;
 	sc->pre_dst_height = sy / sc->pre_vratio;
 
-	sc->main_hratio = (sx << 8) / (tx << sc->hfactor);
-	sc->main_vratio = (sy << 8) / (ty << sc->vfactor);
+	if (variant->has_mainscaler_ext) {
+		sc->main_hratio = (sx << 14) / (tx << sc->hfactor);
+		sc->main_vratio = (sy << 14) / (ty << sc->vfactor);
+	} else {
+		sc->main_hratio = (sx << 8) / (tx << sc->hfactor);
+		sc->main_vratio = (sy << 8) / (ty << sc->vfactor);
+
+	}
 
 	sc->scaleup_h = (tx >= sx) ? 1 : 0;
 	sc->scaleup_v = (ty >= sy) ? 1 : 0;
@@ -569,6 +576,7 @@ static void fimc_dma_run(void *priv)
 {
 	struct fimc_ctx *ctx = priv;
 	struct fimc_dev *fimc;
+	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
 	unsigned long flags;
 	u32 ret;
 
@@ -601,7 +609,12 @@ static void fimc_dma_run(void *priv)
 			err("Scaler setup error");
 			goto dma_unlock;
 		}
-		fimc_hw_set_scaler(ctx);
+
+		fimc_hw_set_prescaler(ctx);
+		if (variant->has_mainscaler_ext)
+			fimc_hw_set_mainscaler_ext(ctx);
+		else
+			fimc_hw_set_mainscaler(ctx);
 		fimc_hw_set_target_format(ctx);
 		fimc_hw_set_rotation(ctx);
 		fimc_hw_set_effect(ctx);
@@ -1720,6 +1733,7 @@ static struct samsung_fimc_variant fimc1_variant_s5pv210 = {
 	.pix_hoff	 = 1,
 	.has_inp_rot	 = 1,
 	.has_out_rot	 = 1,
+	.has_mainscaler_ext = 1,
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 1,
@@ -1741,6 +1755,7 @@ static struct samsung_fimc_variant fimc0_variant_s5pv310 = {
 	.has_inp_rot	 = 1,
 	.has_out_rot	 = 1,
 	.has_cistatus2	 = 1,
+	.has_mainscaler_ext = 1,
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 1,
@@ -1751,6 +1766,7 @@ static struct samsung_fimc_variant fimc0_variant_s5pv310 = {
 static struct samsung_fimc_variant fimc2_variant_s5pv310 = {
 	.pix_hoff	 = 1,
 	.has_cistatus2	 = 1,
+	.has_mainscaler_ext = 1,
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 1,
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index d684138..d690398 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -356,6 +356,8 @@ struct fimc_pix_limit {
  * @has_inp_rot: set if has input rotator
  * @has_out_rot: set if has output rotator
  * @has_cistatus2: 1 if CISTATUS2 register is present in this IP revision
+ * @has_mainscaler_ext: 1 if extended mainscaler ratios in CIEXTEN register are
+ *			present in this IP revision
  * @pix_limit: pixel size constraints for the scaler
  * @min_inp_pixsize: minimum input pixel size
  * @min_out_pixsize: minimum output pixel size
@@ -367,6 +369,7 @@ struct samsung_fimc_variant {
 	unsigned int	has_inp_rot:1;
 	unsigned int	has_out_rot:1;
 	unsigned int	has_cistatus2:1;
+	unsigned int	has_mainscaler_ext:1;
 	struct fimc_pix_limit *pix_limit;
 	u16		min_inp_pixsize;
 	u16		min_out_pixsize;
@@ -562,7 +565,9 @@ void fimc_hw_set_target_format(struct fimc_ctx *ctx);
 void fimc_hw_set_out_dma(struct fimc_ctx *ctx);
 void fimc_hw_en_lastirq(struct fimc_dev *fimc, int enable);
 void fimc_hw_en_irq(struct fimc_dev *fimc, int enable);
-void fimc_hw_set_scaler(struct fimc_ctx *ctx);
+void fimc_hw_set_prescaler(struct fimc_ctx *ctx);
+void fimc_hw_set_mainscaler(struct fimc_ctx *ctx);
+void fimc_hw_set_mainscaler_ext(struct fimc_ctx *ctx);
 void fimc_hw_en_capture(struct fimc_ctx *ctx);
 void fimc_hw_set_effect(struct fimc_ctx *ctx);
 void fimc_hw_set_in_dma(struct fimc_ctx *ctx);
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 5ed8f06..88951b8 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -249,7 +249,7 @@ void fimc_hw_en_lastirq(struct fimc_dev *dev, int enable)
 	writel(cfg, dev->regs + S5P_CIOCTRL);
 }
 
-static void fimc_hw_set_prescaler(struct fimc_ctx *ctx)
+void fimc_hw_set_prescaler(struct fimc_ctx *ctx)
 {
 	struct fimc_dev *dev =  ctx->fimc_dev;
 	struct fimc_scaler *sc = &ctx->scaler;
@@ -267,7 +267,7 @@ static void fimc_hw_set_prescaler(struct fimc_ctx *ctx)
 	writel(cfg, dev->regs + S5P_CISCPREDST);
 }
 
-void fimc_hw_set_scaler(struct fimc_ctx *ctx)
+static void fimc_hw_set_scaler(struct fimc_ctx *ctx)
 {
 	struct fimc_dev *dev = ctx->fimc_dev;
 	struct fimc_scaler *sc = &ctx->scaler;
@@ -275,8 +275,6 @@ void fimc_hw_set_scaler(struct fimc_ctx *ctx)
 	struct fimc_frame *dst_frame = &ctx->d_frame;
 	u32 cfg = 0;
 
-	fimc_hw_set_prescaler(ctx);
-
 	if (!(ctx->flags & FIMC_COLOR_RANGE_NARROW))
 		cfg |= (S5P_CISCCTRL_CSCR2Y_WIDE | S5P_CISCCTRL_CSCY2R_WIDE);
 
@@ -316,13 +314,55 @@ void fimc_hw_set_scaler(struct fimc_ctx *ctx)
 			cfg |= S5P_CISCCTRL_INTERLACE;
 	}
 
+	writel(cfg, dev->regs + S5P_CISCCTRL);
+}
+
+void fimc_hw_set_mainscaler(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+	struct fimc_scaler *sc = &ctx->scaler;
+	u32 cfg;
+
+	dbg("main_hratio= 0x%X  main_vratio= 0x%X",
+		sc->main_hratio, sc->main_vratio);
+
+	fimc_hw_set_scaler(ctx);
+
+	cfg = readl(dev->regs + S5P_CISCCTRL);
+	cfg &= ~S5P_CISCCTRL_MHRATIO_MASK;
+	cfg &= ~S5P_CISCCTRL_MVRATIO_MASK;
+	cfg |= S5P_CISCCTRL_MHRATIO(sc->main_hratio);
+	cfg |= S5P_CISCCTRL_MVRATIO(sc->main_vratio);
+
+	writel(cfg, dev->regs + S5P_CISCCTRL);
+}
+
+void fimc_hw_set_mainscaler_ext(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+	struct fimc_scaler *sc = &ctx->scaler;
+	u32 cfg, cfg_ext;
+
 	dbg("main_hratio= 0x%X  main_vratio= 0x%X",
 		sc->main_hratio, sc->main_vratio);
 
-	cfg |= S5P_CISCCTRL_SC_HORRATIO(sc->main_hratio);
-	cfg |= S5P_CISCCTRL_SC_VERRATIO(sc->main_vratio);
+	fimc_hw_set_scaler(ctx);
+
+	cfg = readl(dev->regs + S5P_CISCCTRL);
+	cfg &= ~S5P_CISCCTRL_MHRATIO_MASK;
+	cfg &= ~S5P_CISCCTRL_MVRATIO_MASK;
+	cfg |= S5P_CISCCTRL_MHRATIO_EXT(sc->main_hratio);
+	cfg |= S5P_CISCCTRL_MVRATIO_EXT(sc->main_vratio);
 
 	writel(cfg, dev->regs + S5P_CISCCTRL);
+
+	cfg_ext = readl(dev->regs + S5P_CIEXTEN);
+	cfg_ext &= ~S5P_CIEXTEN_MHRATIO_EXT_MASK;
+	cfg_ext &= ~S5P_CIEXTEN_MVRATIO_EXT_MASK;
+	cfg_ext |= S5P_CIEXTEN_MHRATIO_EXT(sc->main_hratio);
+	cfg_ext |= S5P_CIEXTEN_MVRATIO_EXT(sc->main_vratio);
+
+	writel(cfg_ext, dev->regs + S5P_CIEXTEN);
 }
 
 void fimc_hw_en_capture(struct fimc_ctx *ctx)
diff --git a/drivers/media/video/s5p-fimc/regs-fimc.h b/drivers/media/video/s5p-fimc/regs-fimc.h
index cd86c18..28bd2fb 100644
--- a/drivers/media/video/s5p-fimc/regs-fimc.h
+++ b/drivers/media/video/s5p-fimc/regs-fimc.h
@@ -139,8 +139,12 @@
 #define S5P_CISCCTRL_OUTRGB_FMT_MASK	(3 << 11)
 #define S5P_CISCCTRL_RGB_EXT		(1 << 10)
 #define S5P_CISCCTRL_ONE2ONE		(1 << 9)
-#define S5P_CISCCTRL_SC_HORRATIO(x)	((x) << 16)
-#define S5P_CISCCTRL_SC_VERRATIO(x)	((x) << 0)
+#define S5P_CISCCTRL_MHRATIO(x)		((x) << 16)
+#define S5P_CISCCTRL_MVRATIO(x)		((x) << 0)
+#define S5P_CISCCTRL_MHRATIO_MASK	(0x1ff << 16)
+#define S5P_CISCCTRL_MVRATIO_MASK	(0x1ff << 0)
+#define S5P_CISCCTRL_MHRATIO_EXT(x)	(((x) >> 6) << 16)
+#define S5P_CISCCTRL_MVRATIO_EXT(x)	(((x) >> 6) << 0)
 
 /* Target area */
 #define S5P_CITAREA			0x5c
@@ -263,6 +267,10 @@
 
 /* Real output DMA image size (extension register) */
 #define S5P_CIEXTEN			0x188
+#define S5P_CIEXTEN_MHRATIO_EXT(x)	(((x) & 0x3f) << 10)
+#define S5P_CIEXTEN_MVRATIO_EXT(x)	((x) & 0x3f)
+#define S5P_CIEXTEN_MHRATIO_EXT_MASK	(0x3f << 10)
+#define S5P_CIEXTEN_MVRATIO_EXT_MASK	0x3f
 
 #define S5P_CIDMAPARAM			0x18c
 #define S5P_CIDMAPARAM_R_LINEAR		(0 << 29)
-- 
1.6.2.5

