Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:44085 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab2K1TJv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 14:09:51 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ME700LI6P8E8G40@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:09:50 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0ME7006TUP7TOU90@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:09:49 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 05/12] s5p-fimc: Add variant data structure for Exynos4x12
Date: Wed, 28 Nov 2012 20:09:22 +0100
Message-id: <1354129766-2821-6-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1354129766-2821-1-git-send-email-s.nawrocki@samsung.com>
References: <1354129766-2821-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add variant data structures for Exynos4212 and Exynos4412 SoC.
Add 'const' qualifier for the variant description structures.

Also remove has_cam_if flags from FIMC3 on Exynos4210 SoC is
it has no interconnections the camera ports.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-capture.c |    8 +--
 drivers/media/platform/s5p-fimc/fimc-core.c    |   90 ++++++++++++++++++------
 drivers/media/platform/s5p-fimc/fimc-core.h    |    8 ++-
 drivers/media/platform/s5p-fimc/fimc-m2m.c     |    2 +-
 drivers/media/platform/s5p-fimc/fimc-reg.c     |    2 +-
 5 files changed, 78 insertions(+), 32 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 299c5c2..5b7253a 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -626,8 +626,8 @@ static struct fimc_fmt *fimc_capture_try_format(struct fimc_ctx *ctx,
 {
 	bool rotation = ctx->rotation == 90 || ctx->rotation == 270;
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct fimc_variant *var = fimc->variant;
-	struct fimc_pix_limit *pl = var->pix_limit;
+	const struct fimc_variant *var = fimc->variant;
+	const struct fimc_pix_limit *pl = var->pix_limit;
 	struct fimc_frame *dst = &ctx->d_frame;
 	u32 depth, min_w, max_w, min_h, align_h = 3;
 	u32 mask = FMT_FLAGS_CAM;
@@ -699,8 +699,8 @@ static void fimc_capture_try_selection(struct fimc_ctx *ctx,
 {
 	bool rotate = ctx->rotation == 90 || ctx->rotation == 270;
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct fimc_variant *var = fimc->variant;
-	struct fimc_pix_limit *pl = var->pix_limit;
+	const struct fimc_variant *var = fimc->variant;
+	const struct fimc_pix_limit *pl = var->pix_limit;
 	struct fimc_frame *sink = &ctx->s_frame;
 	u32 max_w, max_h, min_w = 0, min_h = 0, min_sz;
 	u32 align_sz = 0, align_h = 4;
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
index 8d0d2b9..2a1558a 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/s5p-fimc/fimc-core.c
@@ -241,7 +241,7 @@ static int fimc_get_scaler_factor(u32 src, u32 tar, u32 *ratio, u32 *shift)
 
 int fimc_set_scaler_info(struct fimc_ctx *ctx)
 {
-	struct fimc_variant *variant = ctx->fimc_dev->variant;
+	const struct fimc_variant *variant = ctx->fimc_dev->variant;
 	struct device *dev = &ctx->fimc_dev->pdev->dev;
 	struct fimc_scaler *sc = &ctx->scaler;
 	struct fimc_frame *s_frame = &ctx->s_frame;
@@ -440,7 +440,7 @@ void fimc_set_yuv_order(struct fimc_ctx *ctx)
 
 void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f)
 {
-	struct fimc_variant *variant = ctx->fimc_dev->variant;
+	const struct fimc_variant *variant = ctx->fimc_dev->variant;
 	u32 i, depth = 0;
 
 	for (i = 0; i < f->fmt->colplanes; i++)
@@ -524,7 +524,7 @@ static int fimc_set_color_effect(struct fimc_ctx *ctx, enum v4l2_colorfx colorfx
 static int __fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_ctrl *ctrl)
 {
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct fimc_variant *variant = fimc->variant;
+	const struct fimc_variant *variant = fimc->variant;
 	unsigned int flags = FIMC_DST_FMT | FIMC_SRC_FMT;
 	int ret = 0;
 
@@ -591,7 +591,7 @@ static const struct v4l2_ctrl_ops fimc_ctrl_ops = {
 
 int fimc_ctrls_create(struct fimc_ctx *ctx)
 {
-	struct fimc_variant *variant = ctx->fimc_dev->variant;
+	const struct fimc_variant *variant = ctx->fimc_dev->variant;
 	unsigned int max_alpha = fimc_get_alpha_mask(ctx->d_frame.fmt);
 	struct fimc_ctrls *ctrls = &ctx->ctrls;
 	struct v4l2_ctrl_handler *handler = &ctrls->handler;
@@ -881,7 +881,7 @@ static int fimc_m2m_resume(struct fimc_dev *fimc)
 
 static int fimc_probe(struct platform_device *pdev)
 {
-	struct fimc_drvdata *drv_data = fimc_get_drvdata(pdev);
+	const struct fimc_drvdata *drv_data = fimc_get_drvdata(pdev);
 	struct s5p_platform_fimc *pdata;
 	struct fimc_dev *fimc;
 	struct resource *res;
@@ -1053,7 +1053,7 @@ static int __devexit fimc_remove(struct platform_device *pdev)
 }
 
 /* Image pixel limits, similar across several FIMC HW revisions. */
-static struct fimc_pix_limit s5p_pix_limit[4] = {
+static const struct fimc_pix_limit s5p_pix_limit[4] = {
 	[0] = {
 		.scaler_en_w	= 3264,
 		.scaler_dis_w	= 8192,
@@ -1088,7 +1088,7 @@ static struct fimc_pix_limit s5p_pix_limit[4] = {
 	},
 };
 
-static struct fimc_variant fimc0_variant_s5p = {
+static const struct fimc_variant fimc0_variant_s5p = {
 	.has_inp_rot	 = 1,
 	.has_out_rot	 = 1,
 	.has_cam_if	 = 1,
@@ -1100,7 +1100,7 @@ static struct fimc_variant fimc0_variant_s5p = {
 	.pix_limit	 = &s5p_pix_limit[0],
 };
 
-static struct fimc_variant fimc2_variant_s5p = {
+static const struct fimc_variant fimc2_variant_s5p = {
 	.has_cam_if	 = 1,
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
@@ -1110,7 +1110,7 @@ static struct fimc_variant fimc2_variant_s5p = {
 	.pix_limit	 = &s5p_pix_limit[1],
 };
 
-static struct fimc_variant fimc0_variant_s5pv210 = {
+static const struct fimc_variant fimc0_variant_s5pv210 = {
 	.pix_hoff	 = 1,
 	.has_inp_rot	 = 1,
 	.has_out_rot	 = 1,
@@ -1123,7 +1123,7 @@ static struct fimc_variant fimc0_variant_s5pv210 = {
 	.pix_limit	 = &s5p_pix_limit[1],
 };
 
-static struct fimc_variant fimc1_variant_s5pv210 = {
+static const struct fimc_variant fimc1_variant_s5pv210 = {
 	.pix_hoff	 = 1,
 	.has_inp_rot	 = 1,
 	.has_out_rot	 = 1,
@@ -1137,7 +1137,7 @@ static struct fimc_variant fimc1_variant_s5pv210 = {
 	.pix_limit	 = &s5p_pix_limit[2],
 };
 
-static struct fimc_variant fimc2_variant_s5pv210 = {
+static const struct fimc_variant fimc2_variant_s5pv210 = {
 	.has_cam_if	 = 1,
 	.pix_hoff	 = 1,
 	.min_inp_pixsize = 16,
@@ -1148,7 +1148,7 @@ static struct fimc_variant fimc2_variant_s5pv210 = {
 	.pix_limit	 = &s5p_pix_limit[2],
 };
 
-static struct fimc_variant fimc0_variant_exynos4 = {
+static const struct fimc_variant fimc0_variant_exynos4210 = {
 	.pix_hoff	 = 1,
 	.has_inp_rot	 = 1,
 	.has_out_rot	 = 1,
@@ -1164,9 +1164,8 @@ static struct fimc_variant fimc0_variant_exynos4 = {
 	.pix_limit	 = &s5p_pix_limit[1],
 };
 
-static struct fimc_variant fimc3_variant_exynos4 = {
+static const struct fimc_variant fimc3_variant_exynos4210 = {
 	.pix_hoff	 = 1,
-	.has_cam_if	 = 1,
 	.has_cistatus2	 = 1,
 	.has_mainscaler_ext = 1,
 	.has_alpha	 = 1,
@@ -1178,8 +1177,38 @@ static struct fimc_variant fimc3_variant_exynos4 = {
 	.pix_limit	 = &s5p_pix_limit[3],
 };
 
+static const struct fimc_variant fimc0_variant_exynos4x12 = {
+	.pix_hoff		= 1,
+	.has_inp_rot		= 1,
+	.has_out_rot		= 1,
+	.has_cam_if		= 1,
+	.has_isp_wb		= 1,
+	.has_cistatus2		= 1,
+	.has_mainscaler_ext	= 1,
+	.has_alpha		= 1,
+	.min_inp_pixsize	= 16,
+	.min_out_pixsize	= 16,
+	.hor_offs_align		= 2,
+	.min_vsize_align	= 1,
+	.out_buf_count		= 32,
+	.pix_limit		= &s5p_pix_limit[1],
+};
+
+static const struct fimc_variant fimc3_variant_exynos4x12 = {
+	.pix_hoff		= 1,
+	.has_cistatus2		= 1,
+	.has_mainscaler_ext	= 1,
+	.has_alpha		= 1,
+	.min_inp_pixsize	= 16,
+	.min_out_pixsize	= 16,
+	.hor_offs_align		= 2,
+	.min_vsize_align	= 1,
+	.out_buf_count		= 32,
+	.pix_limit		= &s5p_pix_limit[3],
+};
+
 /* S5PC100 */
-static struct fimc_drvdata fimc_drvdata_s5p = {
+static const struct fimc_drvdata fimc_drvdata_s5p = {
 	.variant = {
 		[0] = &fimc0_variant_s5p,
 		[1] = &fimc0_variant_s5p,
@@ -1190,7 +1219,7 @@ static struct fimc_drvdata fimc_drvdata_s5p = {
 };
 
 /* S5PV210, S5PC110 */
-static struct fimc_drvdata fimc_drvdata_s5pv210 = {
+static const struct fimc_drvdata fimc_drvdata_s5pv210 = {
 	.variant = {
 		[0] = &fimc0_variant_s5pv210,
 		[1] = &fimc1_variant_s5pv210,
@@ -1201,18 +1230,30 @@ static struct fimc_drvdata fimc_drvdata_s5pv210 = {
 };
 
 /* EXYNOS4210, S5PV310, S5PC210 */
-static struct fimc_drvdata fimc_drvdata_exynos4 = {
+static const struct fimc_drvdata fimc_drvdata_exynos4210 = {
+	.variant = {
+		[0] = &fimc0_variant_exynos4210,
+		[1] = &fimc0_variant_exynos4210,
+		[2] = &fimc0_variant_exynos4210,
+		[3] = &fimc3_variant_exynos4210,
+	},
+	.num_entities = 4,
+	.lclk_frequency = 166000000UL,
+};
+
+/* EXYNOS4212, EXYNOS4412 */
+static const struct fimc_drvdata fimc_drvdata_exynos4x12 = {
 	.variant = {
-		[0] = &fimc0_variant_exynos4,
-		[1] = &fimc0_variant_exynos4,
-		[2] = &fimc0_variant_exynos4,
-		[3] = &fimc3_variant_exynos4,
+		[0] = &fimc0_variant_exynos4x12,
+		[1] = &fimc0_variant_exynos4x12,
+		[2] = &fimc0_variant_exynos4x12,
+		[3] = &fimc3_variant_exynos4x12,
 	},
 	.num_entities = 4,
 	.lclk_frequency = 166000000UL,
 };
 
-static struct platform_device_id fimc_driver_ids[] = {
+static const struct platform_device_id fimc_driver_ids[] = {
 	{
 		.name		= "s5p-fimc",
 		.driver_data	= (unsigned long)&fimc_drvdata_s5p,
@@ -1221,7 +1262,10 @@ static struct platform_device_id fimc_driver_ids[] = {
 		.driver_data	= (unsigned long)&fimc_drvdata_s5pv210,
 	}, {
 		.name		= "exynos4-fimc",
-		.driver_data	= (unsigned long)&fimc_drvdata_exynos4,
+		.driver_data	= (unsigned long)&fimc_drvdata_exynos4210,
+	}, {
+		.name		= "exynos4x12-fimc",
+		.driver_data	= (unsigned long)&fimc_drvdata_exynos4x12,
 	},
 	{},
 };
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.h b/drivers/media/platform/s5p-fimc/fimc-core.h
index c0040d7..424ff96 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.h
+++ b/drivers/media/platform/s5p-fimc/fimc-core.h
@@ -372,6 +372,7 @@ struct fimc_pix_limit {
  * @has_mainscaler_ext: 1 if extended mainscaler ratios in CIEXTEN register
  *			 are present in this IP revision
  * @has_cam_if: set if this instance has a camera input interface
+ * @has_isp_wb: set if this instance has ISP writeback input
  * @pix_limit: pixel size constraints for the scaler
  * @min_inp_pixsize: minimum input pixel size
  * @min_out_pixsize: minimum output pixel size
@@ -386,8 +387,9 @@ struct fimc_variant {
 	unsigned int	has_cistatus2:1;
 	unsigned int	has_mainscaler_ext:1;
 	unsigned int	has_cam_if:1;
+	unsigned int	has_isp_wb:1;
 	unsigned int	has_alpha:1;
-	struct fimc_pix_limit *pix_limit;
+	const struct fimc_pix_limit *pix_limit;
 	u16		min_inp_pixsize;
 	u16		min_out_pixsize;
 	u16		hor_offs_align;
@@ -402,7 +404,7 @@ struct fimc_variant {
  * @lclk_frequency: local bus clock frequency
  */
 struct fimc_drvdata {
-	struct fimc_variant *variant[FIMC_MAX_DEVS];
+	const struct fimc_variant *variant[FIMC_MAX_DEVS];
 	int num_entities;
 	unsigned long lclk_frequency;
 };
@@ -435,7 +437,7 @@ struct fimc_dev {
 	struct mutex			lock;
 	struct platform_device		*pdev;
 	struct s5p_platform_fimc	*pdata;
-	struct fimc_variant		*variant;
+	const struct fimc_variant	*variant;
 	u16				id;
 	struct clk			*clock[MAX_FIMC_CLOCKS];
 	void __iomem			*regs;
diff --git a/drivers/media/platform/s5p-fimc/fimc-m2m.c b/drivers/media/platform/s5p-fimc/fimc-m2m.c
index 62afed3..0288d33 100644
--- a/drivers/media/platform/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/platform/s5p-fimc/fimc-m2m.c
@@ -300,7 +300,7 @@ static int fimc_m2m_g_fmt_mplane(struct file *file, void *fh,
 static int fimc_try_fmt_mplane(struct fimc_ctx *ctx, struct v4l2_format *f)
 {
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct fimc_variant *variant = fimc->variant;
+	const struct fimc_variant *variant = fimc->variant;
 	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
 	struct fimc_fmt *fmt;
 	u32 max_w, mod_x, mod_y;
diff --git a/drivers/media/platform/s5p-fimc/fimc-reg.c b/drivers/media/platform/s5p-fimc/fimc-reg.c
index f0c34ca..c05d044 100644
--- a/drivers/media/platform/s5p-fimc/fimc-reg.c
+++ b/drivers/media/platform/s5p-fimc/fimc-reg.c
@@ -312,7 +312,7 @@ static void fimc_hw_set_scaler(struct fimc_ctx *ctx)
 void fimc_hw_set_mainscaler(struct fimc_ctx *ctx)
 {
 	struct fimc_dev *dev = ctx->fimc_dev;
-	struct fimc_variant *variant = dev->variant;
+	const struct fimc_variant *variant = dev->variant;
 	struct fimc_scaler *sc = &ctx->scaler;
 	u32 cfg;
 
-- 
1.7.9.5

