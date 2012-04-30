Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:50430 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab2D3QPI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 12:15:08 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3A002GIVSV1740@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Apr 2012 17:14:55 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3A0083RVSI3M@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Apr 2012 17:14:43 +0100 (BST)
Date: Mon, 30 Apr 2012 18:14:37 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 08/12] s5p-fimc: Minor cleanups
In-reply-to: <1335802481-18153-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	sungchun.kang@samsung.com, subash.ramaswamy@linaro.org,
	s.nawrocki@samsung.com
Message-id: <1335802481-18153-9-git-send-email-s.nawrocki@samsung.com>
References: <1335802481-18153-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tidy up the variant and driver data handling. Remove the 'samsung_'
prefix from some data structures since it doesn't really carry any
useful information and makes the names unnecessarily long.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   33 +++++++++++++----------
 drivers/media/video/s5p-fimc/fimc-core.c    |   39 +++++++++++++--------------
 drivers/media/video/s5p-fimc/fimc-core.h    |   26 +++++++++---------
 drivers/media/video/s5p-fimc/fimc-reg.c     |    2 +-
 4 files changed, 51 insertions(+), 49 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 4855af1..3e3ab85 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -31,7 +31,7 @@
 #include "fimc-core.h"
 #include "fimc-reg.h"
 
-static int fimc_init_capture(struct fimc_dev *fimc)
+static int fimc_capture_hw_init(struct fimc_dev *fimc)
 {
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
 	struct fimc_pipeline *p = &fimc->pipeline;
@@ -73,6 +73,14 @@ static int fimc_init_capture(struct fimc_dev *fimc)
 	return ret;
 }
 
+/*
+ * Reinitialize the driver so it is ready to start the streaming again.
+ * Set fimc->state to indicate stream off and the hardware shut down state.
+ * If not suspending (@suspend is false), return any buffers to videobuf2.
+ * Otherwise put any owned buffers onto the pending buffers queue, so they
+ * can be re-spun when the device is being resumed. Also perform FIMC
+ * software reset and disable streaming on the whole pipeline if required.
+ */
 static int fimc_capture_state_cleanup(struct fimc_dev *fimc, bool suspend)
 {
 	struct fimc_vid_cap *cap = &fimc->vid_cap;
@@ -146,9 +154,6 @@ static int fimc_capture_config_update(struct fimc_ctx *ctx)
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	int ret;
 
-	if (!test_bit(ST_CAPT_APPLY_CFG, &fimc->state))
-		return 0;
-
 	fimc_hw_set_camera_offset(fimc, &ctx->s_frame);
 
 	ret = fimc_set_scaler_info(ctx);
@@ -224,7 +229,8 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc)
 		set_bit(ST_CAPT_RUN, &fimc->state);
 	}
 
-	fimc_capture_config_update(cap->ctx);
+	if (test_bit(ST_CAPT_APPLY_CFG, &fimc->state))
+		fimc_capture_config_update(cap->ctx);
 done:
 	if (cap->active_buf_cnt == 1) {
 		fimc_deactivate_capture(fimc);
@@ -246,9 +252,11 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
 
 	vid_cap->frame_count = 0;
 
-	ret = fimc_init_capture(fimc);
-	if (ret)
-		goto error;
+	ret = fimc_capture_hw_init(fimc);
+	if (ret) {
+		fimc_capture_state_cleanup(fimc, false);
+		return ret;
+	}
 
 	set_bit(ST_CAPT_PEND, &fimc->state);
 
@@ -263,9 +271,6 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
 	}
 
 	return 0;
-error:
-	fimc_capture_state_cleanup(fimc, false);
-	return ret;
 }
 
 static int stop_streaming(struct vb2_queue *q)
@@ -304,7 +309,7 @@ int fimc_capture_resume(struct fimc_dev *fimc)
 	vid_cap->buf_index = 0;
 	fimc_pipeline_initialize(&fimc->pipeline, &vid_cap->vfd->entity,
 				 false);
-	fimc_init_capture(fimc);
+	fimc_capture_hw_init(fimc);
 
 	clear_bit(ST_CAPT_SUSPENDED, &fimc->state);
 
@@ -558,7 +563,7 @@ static struct fimc_fmt *fimc_capture_try_format(struct fimc_ctx *ctx,
 {
 	bool rotation = ctx->rotation == 90 || ctx->rotation == 270;
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct samsung_fimc_variant *var = fimc->variant;
+	struct fimc_variant *var = fimc->variant;
 	struct fimc_pix_limit *pl = var->pix_limit;
 	struct fimc_frame *dst = &ctx->d_frame;
 	u32 depth, min_w, max_w, min_h, align_h = 3;
@@ -624,7 +629,7 @@ static void fimc_capture_try_crop(struct fimc_ctx *ctx, struct v4l2_rect *r,
 {
 	bool rotate = ctx->rotation == 90 || ctx->rotation == 270;
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct samsung_fimc_variant *var = fimc->variant;
+	struct fimc_variant *var = fimc->variant;
 	struct fimc_pix_limit *pl = var->pix_limit;
 	struct fimc_frame *sink = &ctx->s_frame;
 	u32 max_w, max_h, min_w = 0, min_h = 0, min_sz;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 8be7f05..6573029 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -231,7 +231,7 @@ static int fimc_get_scaler_factor(u32 src, u32 tar, u32 *ratio, u32 *shift)
 
 int fimc_set_scaler_info(struct fimc_ctx *ctx)
 {
-	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
+	struct fimc_variant *variant = ctx->fimc_dev->variant;
 	struct device *dev = &ctx->fimc_dev->pdev->dev;
 	struct fimc_scaler *sc = &ctx->scaler;
 	struct fimc_frame *s_frame = &ctx->s_frame;
@@ -428,7 +428,7 @@ void fimc_set_yuv_order(struct fimc_ctx *ctx)
 
 void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f)
 {
-	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
+	struct fimc_variant *variant = ctx->fimc_dev->variant;
 	u32 i, depth = 0;
 
 	for (i = 0; i < f->fmt->colplanes; i++)
@@ -470,7 +470,7 @@ void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f)
 static int __fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_ctrl *ctrl)
 {
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct samsung_fimc_variant *variant = fimc->variant;
+	struct fimc_variant *variant = fimc->variant;
 	unsigned int flags = FIMC_DST_FMT | FIMC_SRC_FMT;
 	int ret = 0;
 
@@ -530,7 +530,7 @@ static const struct v4l2_ctrl_ops fimc_ctrl_ops = {
 
 int fimc_ctrls_create(struct fimc_ctx *ctx)
 {
-	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
+	struct fimc_variant *variant = ctx->fimc_dev->variant;
 	unsigned int max_alpha = fimc_get_alpha_mask(ctx->d_frame.fmt);
 
 	if (ctx->ctrls_rdy)
@@ -792,15 +792,12 @@ static int fimc_m2m_resume(struct fimc_dev *fimc)
 
 static int fimc_probe(struct platform_device *pdev)
 {
+	struct fimc_drvdata *drv_data = fimc_get_drvdata(pdev);
+	struct s5p_platform_fimc *pdata;
 	struct fimc_dev *fimc;
 	struct resource *res;
-	struct samsung_fimc_driverdata *drv_data;
-	struct s5p_platform_fimc *pdata;
 	int ret = 0;
 
-	drv_data = (struct samsung_fimc_driverdata *)
-		platform_get_device_id(pdev)->driver_data;
-
 	if (pdev->id >= drv_data->num_entities) {
 		dev_err(&pdev->dev, "Invalid platform device id: %d\n",
 			pdev->id);
@@ -1003,7 +1000,7 @@ static struct fimc_pix_limit s5p_pix_limit[4] = {
 	},
 };
 
-static struct samsung_fimc_variant fimc0_variant_s5p = {
+static struct fimc_variant fimc0_variant_s5p = {
 	.has_inp_rot	 = 1,
 	.has_out_rot	 = 1,
 	.has_cam_if	 = 1,
@@ -1015,17 +1012,17 @@ static struct samsung_fimc_variant fimc0_variant_s5p = {
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
@@ -1038,7 +1035,7 @@ static struct samsung_fimc_variant fimc0_variant_s5pv210 = {
 	.pix_limit	 = &s5p_pix_limit[1],
 };
 
-static struct samsung_fimc_variant fimc1_variant_s5pv210 = {
+static struct fimc_variant fimc1_variant_s5pv210 = {
 	.pix_hoff	 = 1,
 	.has_inp_rot	 = 1,
 	.has_out_rot	 = 1,
@@ -1052,7 +1049,7 @@ static struct samsung_fimc_variant fimc1_variant_s5pv210 = {
 	.pix_limit	 = &s5p_pix_limit[2],
 };
 
-static struct samsung_fimc_variant fimc2_variant_s5pv210 = {
+static struct fimc_variant fimc2_variant_s5pv210 = {
 	.has_cam_if	 = 1,
 	.pix_hoff	 = 1,
 	.min_inp_pixsize = 16,
@@ -1063,7 +1060,7 @@ static struct samsung_fimc_variant fimc2_variant_s5pv210 = {
 	.pix_limit	 = &s5p_pix_limit[2],
 };
 
-static struct samsung_fimc_variant fimc0_variant_exynos4 = {
+static struct fimc_variant fimc0_variant_exynos4 = {
 	.pix_hoff	 = 1,
 	.has_inp_rot	 = 1,
 	.has_out_rot	 = 1,
@@ -1079,7 +1076,7 @@ static struct samsung_fimc_variant fimc0_variant_exynos4 = {
 	.pix_limit	 = &s5p_pix_limit[1],
 };
 
-static struct samsung_fimc_variant fimc3_variant_exynos4 = {
+static struct fimc_variant fimc3_variant_exynos4 = {
 	.pix_hoff	 = 1,
 	.has_cam_if	 = 1,
 	.has_cistatus2	 = 1,
@@ -1094,7 +1091,7 @@ static struct samsung_fimc_variant fimc3_variant_exynos4 = {
 };
 
 /* S5PC100 */
-static struct samsung_fimc_driverdata fimc_drvdata_s5p = {
+static struct fimc_drvdata fimc_drvdata_s5p = {
 	.variant = {
 		[0] = &fimc0_variant_s5p,
 		[1] = &fimc0_variant_s5p,
@@ -1105,7 +1102,7 @@ static struct samsung_fimc_driverdata fimc_drvdata_s5p = {
 };
 
 /* S5PV210, S5PC110 */
-static struct samsung_fimc_driverdata fimc_drvdata_s5pv210 = {
+static struct fimc_drvdata fimc_drvdata_s5pv210 = {
 	.variant = {
 		[0] = &fimc0_variant_s5pv210,
 		[1] = &fimc1_variant_s5pv210,
@@ -1115,8 +1112,8 @@ static struct samsung_fimc_driverdata fimc_drvdata_s5pv210 = {
 	.lclk_frequency = 166000000UL,
 };
 
-/* S5PV310, S5PC210 */
-static struct samsung_fimc_driverdata fimc_drvdata_exynos4 = {
+/* EXYNOS4210, S5PV310, S5PC210 */
+static struct fimc_drvdata fimc_drvdata_exynos4 = {
 	.variant = {
 		[0] = &fimc0_variant_exynos4,
 		[1] = &fimc0_variant_exynos4,
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index fd0a61e..2fbac03 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -360,8 +360,7 @@ struct fimc_pix_limit {
 };
 
 /**
- * struct samsung_fimc_variant - camera interface variant information
- *
+ * struct fimc_variant - FIMC device variant information
  * @pix_hoff: indicate whether horizontal offset is in pixels or in bytes
  * @has_inp_rot: set if has input rotator
  * @has_out_rot: set if has output rotator
@@ -376,7 +375,7 @@ struct fimc_pix_limit {
  * @min_vsize_align: minimum vertical pixel size alignment
  * @out_buf_count: the number of buffers in output DMA sequence
  */
-struct samsung_fimc_variant {
+struct fimc_variant {
 	unsigned int	pix_hoff:1;
 	unsigned int	has_inp_rot:1;
 	unsigned int	has_out_rot:1;
@@ -393,18 +392,19 @@ struct samsung_fimc_variant {
 };
 
 /**
- * struct samsung_fimc_driverdata - per device type driver data for init time.
- *
- * @variant: the variant information for this driver.
- * @dev_cnt: number of fimc sub-devices available in SoC
- * @lclk_frequency: fimc bus clock frequency
+ * struct fimc_drvdata - per device type driver data
+ * @variant: variant information for this device
+ * @num_entities: number of fimc instances available in a SoC
+ * @lclk_frequency: local bus clock frequency
  */
-struct samsung_fimc_driverdata {
-	struct samsung_fimc_variant *variant[FIMC_MAX_DEVS];
-	unsigned long	lclk_frequency;
-	int		num_entities;
+struct fimc_drvdata {
+	struct fimc_variant *variant[FIMC_MAX_DEVS];
+	int num_entities;
+	unsigned long lclk_frequency;
 };
 
+#define fimc_get_drvdata(_pdev) \
+	((struct fimc_drvdata *) platform_get_device_id(_pdev)->driver_data)
 
 struct fimc_ctx;
 
@@ -431,7 +431,7 @@ struct fimc_dev {
 	struct mutex			lock;
 	struct platform_device		*pdev;
 	struct s5p_platform_fimc	*pdata;
-	struct samsung_fimc_variant	*variant;
+	struct fimc_variant		*variant;
 	u16				id;
 	struct clk			*clock[MAX_FIMC_CLOCKS];
 	void __iomem			*regs;
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index cbce827..78c95d7 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -312,7 +312,7 @@ static void fimc_hw_set_scaler(struct fimc_ctx *ctx)
 void fimc_hw_set_mainscaler(struct fimc_ctx *ctx)
 {
 	struct fimc_dev *dev = ctx->fimc_dev;
-	struct samsung_fimc_variant *variant = dev->variant;
+	struct fimc_variant *variant = dev->variant;
 	struct fimc_scaler *sc = &ctx->scaler;
 	u32 cfg;
 
-- 
1.7.10

