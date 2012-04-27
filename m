Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:11061 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab2D0JxS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 05:53:18 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M34002RUU2983@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:51:45 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M340063PU4K3A@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:53:14 +0100 (BST)
Date: Fri, 27 Apr 2012 11:52:56 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 03/13] s5p-fimc: Simplify the variant data structure
In-reply-to: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	sungchun.kang@samsung.com, subash.ramaswamy@linaro.org,
	s.nawrocki@samsung.com
Message-id: <1335520386-20835-4-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove num_entities from the driver data structure as this information
is already there as the variant array's length. Remove the 'samsung_'
prefix from some data structures since it doesn't really carry any
useful information and makes the names unnecessarily long.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    4 +--
 drivers/media/video/s5p-fimc/fimc-core.c    |   41 +++++++++++++--------------
 drivers/media/video/s5p-fimc/fimc-core.h    |   22 ++++++--------
 drivers/media/video/s5p-fimc/fimc-reg.c     |    2 +-
 4 files changed, 31 insertions(+), 38 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 513ffbc..8488089 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -556,7 +556,7 @@ static struct fimc_fmt *fimc_capture_try_format(struct fimc_ctx *ctx,
 {
 	bool rotation = ctx->rotation == 90 || ctx->rotation == 270;
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct samsung_fimc_variant *var = fimc->variant;
+	struct fimc_variant *var = fimc->variant;
 	struct fimc_pix_limit *pl = var->pix_limit;
 	struct fimc_frame *dst = &ctx->d_frame;
 	u32 depth, min_w, max_w, min_h, align_h = 3;
@@ -622,7 +622,7 @@ static void fimc_capture_try_crop(struct fimc_ctx *ctx, struct v4l2_rect *r,
 {
 	bool rotate = ctx->rotation == 90 || ctx->rotation == 270;
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct samsung_fimc_variant *var = fimc->variant;
+	struct fimc_variant *var = fimc->variant;
 	struct fimc_pix_limit *pl = var->pix_limit;
 	struct fimc_frame *sink = &ctx->s_frame;
 	u32 max_w, max_h, min_w = 0, min_h = 0, min_sz;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 55858c5..b35c0a6 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -230,7 +230,7 @@ static int fimc_get_scaler_factor(u32 src, u32 tar, u32 *ratio, u32 *shift)
 
 int fimc_set_scaler_info(struct fimc_ctx *ctx)
 {
-	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
+	struct fimc_variant *variant = ctx->fimc_dev->variant;
 	struct device *dev = &ctx->fimc_dev->pdev->dev;
 	struct fimc_scaler *sc = &ctx->scaler;
 	struct fimc_frame *s_frame = &ctx->s_frame;
@@ -427,7 +427,7 @@ void fimc_set_yuv_order(struct fimc_ctx *ctx)
 
 void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f)
 {
-	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
+	struct fimc_variant *variant = ctx->fimc_dev->variant;
 	u32 i, depth = 0;
 
 	for (i = 0; i < f->fmt->colplanes; i++)
@@ -469,7 +469,7 @@ void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f)
 static int __fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_ctrl *ctrl)
 {
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct samsung_fimc_variant *variant = fimc->variant;
+	struct fimc_variant *variant = fimc->variant;
 	unsigned int flags = FIMC_DST_FMT | FIMC_SRC_FMT;
 	int ret = 0;
 
@@ -529,7 +529,7 @@ static const struct v4l2_ctrl_ops fimc_ctrl_ops = {
 
 int fimc_ctrls_create(struct fimc_ctx *ctx)
 {
-	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
+	struct fimc_variant *variant = ctx->fimc_dev->variant;
 	unsigned int max_alpha = fimc_get_alpha_mask(ctx->d_frame.fmt);
 
 	if (ctx->ctrls_rdy)
@@ -793,14 +793,14 @@ static int fimc_probe(struct platform_device *pdev)
 {
 	struct fimc_dev *fimc;
 	struct resource *res;
-	struct samsung_fimc_driverdata *drv_data;
+	struct fimc_drvdata *drv_data;
 	struct s5p_platform_fimc *pdata;
 	int ret = 0;
 
-	drv_data = (struct samsung_fimc_driverdata *)
+	drv_data = (struct fimc_drvdata *)
 		platform_get_device_id(pdev)->driver_data;
 
-	if (pdev->id >= drv_data->num_entities) {
+	if (pdev->id >= ARRAY_SIZE(drv_data->variant)) {
 		dev_err(&pdev->dev, "Invalid platform device id: %d\n",
 			pdev->id);
 		return -EINVAL;
@@ -996,7 +996,7 @@ static struct fimc_pix_limit s5p_pix_limit[4] = {
 	},
 };
 
-static struct samsung_fimc_variant fimc0_variant_s5p = {
+static struct fimc_variant fimc0_variant_s5p = {
 	.has_inp_rot	 = 1,
 	.has_out_rot	 = 1,
 	.has_cam_if	 = 1,
@@ -1008,17 +1008,17 @@ static struct samsung_fimc_variant fimc0_variant_s5p = {
 	.pix_limit	 = &s5p_pix_limit[0],
 };
 
-static struct samsung_fimc_variant fimc2_variant_s5p = {
+static struct fimc_variant fimc2_variant_s5p = {
 	.has_cam_if	 = 1,
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 8,
 	.min_vsize_align = 16,
 	.out_buf_count	 = 4,
-	.pix_limit = &s5p_pix_limit[1],
+	.pix_limit	 = &s5p_pix_limit[1],
 };
 
-static struct samsung_fimc_variant fimc0_variant_s5pv210 = {
+static struct fimc_variant fimc0_variant_s5pv210 = {
 	.pix_hoff	 = 1,
 	.has_inp_rot	 = 1,
 	.has_out_rot	 = 1,
@@ -1031,7 +1031,7 @@ static struct samsung_fimc_variant fimc0_variant_s5pv210 = {
 	.pix_limit	 = &s5p_pix_limit[1],
 };
 
-static struct samsung_fimc_variant fimc1_variant_s5pv210 = {
+static struct fimc_variant fimc1_variant_s5pv210 = {
 	.pix_hoff	 = 1,
 	.has_inp_rot	 = 1,
 	.has_out_rot	 = 1,
@@ -1045,7 +1045,7 @@ static struct samsung_fimc_variant fimc1_variant_s5pv210 = {
 	.pix_limit	 = &s5p_pix_limit[2],
 };
 
-static struct samsung_fimc_variant fimc2_variant_s5pv210 = {
+static struct fimc_variant fimc2_variant_s5pv210 = {
 	.has_cam_if	 = 1,
 	.pix_hoff	 = 1,
 	.min_inp_pixsize = 16,
@@ -1056,7 +1056,7 @@ static struct samsung_fimc_variant fimc2_variant_s5pv210 = {
 	.pix_limit	 = &s5p_pix_limit[2],
 };
 
-static struct samsung_fimc_variant fimc0_variant_exynos4 = {
+static struct fimc_variant fimc0_variant_exynos4 = {
 	.pix_hoff	 = 1,
 	.has_inp_rot	 = 1,
 	.has_out_rot	 = 1,
@@ -1072,7 +1072,7 @@ static struct samsung_fimc_variant fimc0_variant_exynos4 = {
 	.pix_limit	 = &s5p_pix_limit[1],
 };
 
-static struct samsung_fimc_variant fimc3_variant_exynos4 = {
+static struct fimc_variant fimc3_variant_exynos4 = {
 	.pix_hoff	 = 1,
 	.has_cam_if	 = 1,
 	.has_cistatus2	 = 1,
@@ -1087,36 +1087,33 @@ static struct samsung_fimc_variant fimc3_variant_exynos4 = {
 };
 
 /* S5PC100 */
-static struct samsung_fimc_driverdata fimc_drvdata_s5p = {
+static struct fimc_drvdata fimc_drvdata_s5p = {
 	.variant = {
 		[0] = &fimc0_variant_s5p,
 		[1] = &fimc0_variant_s5p,
 		[2] = &fimc2_variant_s5p,
 	},
-	.num_entities = 3,
 	.lclk_frequency = 133000000UL,
 };
 
 /* S5PV210, S5PC110 */
-static struct samsung_fimc_driverdata fimc_drvdata_s5pv210 = {
+static struct fimc_drvdata fimc_drvdata_s5pv210 = {
 	.variant = {
 		[0] = &fimc0_variant_s5pv210,
 		[1] = &fimc1_variant_s5pv210,
 		[2] = &fimc2_variant_s5pv210,
 	},
-	.num_entities = 3,
 	.lclk_frequency = 166000000UL,
 };
 
-/* S5PV310, S5PC210 */
-static struct samsung_fimc_driverdata fimc_drvdata_exynos4 = {
+/* EXYNOS4210, S5PV310, S5PC210 */
+static struct fimc_drvdata fimc_drvdata_exynos4 = {
 	.variant = {
 		[0] = &fimc0_variant_exynos4,
 		[1] = &fimc0_variant_exynos4,
 		[2] = &fimc0_variant_exynos4,
 		[3] = &fimc3_variant_exynos4,
 	},
-	.num_entities = 4,
 	.lclk_frequency = 166000000UL,
 };
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index a590cc3..eddc370 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -368,8 +368,7 @@ struct fimc_pix_limit {
 };
 
 /**
- * struct samsung_fimc_variant - camera interface variant information
- *
+ * struct fimc_variant - FIMC device variant information
  * @pix_hoff: indicate whether horizontal offset is in pixels or in bytes
  * @has_inp_rot: set if has input rotator
  * @has_out_rot: set if has output rotator
@@ -384,7 +383,7 @@ struct fimc_pix_limit {
  * @min_vsize_align: minimum vertical pixel size alignment
  * @out_buf_count: the number of buffers in output DMA sequence
  */
-struct samsung_fimc_variant {
+struct fimc_variant {
 	unsigned int	pix_hoff:1;
 	unsigned int	has_inp_rot:1;
 	unsigned int	has_out_rot:1;
@@ -401,16 +400,13 @@ struct samsung_fimc_variant {
 };
 
 /**
- * struct samsung_fimc_driverdata - per device type driver data for init time.
- *
- * @variant: the variant information for this driver.
- * @dev_cnt: number of fimc sub-devices available in SoC
- * @lclk_frequency: fimc bus clock frequency
+ * struct fimc_drvdata - per device type driver data
+ * @variant: variant information for this device
+ * @lclk_frequency: local bus clock frequency
  */
-struct samsung_fimc_driverdata {
-	struct samsung_fimc_variant *variant[FIMC_MAX_DEVS];
-	unsigned long	lclk_frequency;
-	int		num_entities;
+struct fimc_drvdata {
+	struct fimc_variant *variant[FIMC_MAX_DEVS];
+	unsigned long lclk_frequency;
 };
 
 struct fimc_pipeline {
@@ -444,7 +440,7 @@ struct fimc_dev {
 	struct mutex			lock;
 	struct platform_device		*pdev;
 	struct s5p_platform_fimc	*pdata;
-	struct samsung_fimc_variant	*variant;
+	struct fimc_variant		*variant;
 	u16				id;
 	struct clk			*clock[MAX_FIMC_CLOCKS];
 	void __iomem			*regs;
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index ff11f10..1c0be5b 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -322,7 +322,7 @@ static void fimc_hw_set_scaler(struct fimc_ctx *ctx)
 void fimc_hw_set_mainscaler(struct fimc_ctx *ctx)
 {
 	struct fimc_dev *dev = ctx->fimc_dev;
-	struct samsung_fimc_variant *variant = dev->variant;
+	struct fimc_variant *variant = dev->variant;
 	struct fimc_scaler *sc = &ctx->scaler;
 	u32 cfg;
 
-- 
1.7.10

