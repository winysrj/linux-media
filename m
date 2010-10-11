Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34155 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab0JKR0m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 13:26:42 -0400
Date: Mon, 11 Oct 2010 19:26:33 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 6/6 v5] V4L/DVB: s5p-fimc: Add suport for FIMC on S5PC210 SoCs
In-reply-to: <1286817993-21558-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1286817993-21558-7-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1286817993-21558-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Enable FIMC operation on S5PC210 (S5PV310) SoCs. This a minimal
adaptation to obtain functionality of older FIMC IP revisions
(S5PC100, S5PC110) on S5PC210 SOcs.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |  157 +++++++++++++++++++++---------
 drivers/media/video/s5p-fimc/fimc-core.h |   56 ++++++++---
 drivers/media/video/s5p-fimc/regs-fimc.h |    3 +
 3 files changed, 156 insertions(+), 60 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 064e7d5..7e63a49 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -823,10 +823,10 @@ int fimc_vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		goto tf_out;
 
 	if (is_output) {
-		max_width = variant->scaler_dis_w;
+		max_width = variant->pix_limit->scaler_dis_w;
 		mod_x = ffs(variant->min_inp_pixsize) - 1;
 	} else {
-		max_width = variant->out_rot_dis_w;
+		max_width = variant->pix_limit->out_rot_dis_w;
 		mod_x = ffs(variant->min_out_pixsize) - 1;
 	}
 
@@ -843,7 +843,7 @@ int fimc_vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	dbg("mod_x: %d, mod_y: %d, max_w: %d", mod_x, mod_y, max_width);
 
 	v4l_bound_align_image(&pix->width, 16, max_width, mod_x,
-		&pix->height, 8, variant->scaler_dis_w, mod_y, 0);
+		&pix->height, 8, variant->pix_limit->scaler_dis_w, mod_y, 0);
 
 	if (pix->bytesperline == 0 ||
 	    (pix->bytesperline * 8 / fmt->depth) > pix->width)
@@ -1519,7 +1519,7 @@ static int fimc_probe(struct platform_device *pdev)
 	drv_data = (struct samsung_fimc_driverdata *)
 		platform_get_device_id(pdev)->driver_data;
 
-	if (pdev->id >= drv_data->devs_cnt) {
+	if (pdev->id >= drv_data->num_entities) {
 		dev_err(&pdev->dev, "Invalid platform device id: %d\n",
 			pdev->id);
 		return -EINVAL;
@@ -1602,6 +1602,13 @@ static int fimc_probe(struct platform_device *pdev)
 		}
 	}
 
+	/*
+	 * Exclude the additional output DMA address registers by masking
+	 * them out on HW revisions that provide extended capabilites.
+	 */
+	if (fimc->variant->out_buf_count > 4)
+		fimc_hw_set_dma_seq(fimc, 0xF);
+
 	dev_dbg(&pdev->dev, "%s(): fimc-%d registered successfully\n",
 		__func__, fimc->id);
 
@@ -1645,78 +1652,135 @@ static int __devexit fimc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct samsung_fimc_variant fimc01_variant_s5p = {
-	.has_inp_rot	= 1,
-	.has_out_rot	= 1,
+/* Image pixel limits, similar across several FIMC HW revisions. */
+static struct fimc_pix_limit s5p_pix_limit[3] = {
+	[0] = {
+		.scaler_en_w	= 3264,
+		.scaler_dis_w	= 8192,
+		.in_rot_en_h	= 1920,
+		.in_rot_dis_w	= 8192,
+		.out_rot_en_w	= 1920,
+		.out_rot_dis_w	= 4224,
+	},
+	[1] = {
+		.scaler_en_w	= 4224,
+		.scaler_dis_w	= 8192,
+		.in_rot_en_h	= 1920,
+		.in_rot_dis_w	= 8192,
+		.out_rot_en_w	= 1920,
+		.out_rot_dis_w	= 4224,
+	},
+	[2] = {
+		.scaler_en_w	= 1920,
+		.scaler_dis_w	= 8192,
+		.in_rot_en_h	= 1280,
+		.in_rot_dis_w	= 8192,
+		.out_rot_en_w	= 1280,
+		.out_rot_dis_w	= 1920,
+	},
+};
+
+static struct samsung_fimc_variant fimc0_variant_s5p = {
+	.has_inp_rot	 = 1,
+	.has_out_rot	 = 1,
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
-
-	.scaler_en_w	= 3264,
-	.scaler_dis_w	= 8192,
-	.in_rot_en_h	= 1920,
-	.in_rot_dis_w	= 8192,
-	.out_rot_en_w	= 1920,
-	.out_rot_dis_w	= 4224,
+	.hor_offs_align	 = 8,
+	.out_buf_count	 = 4,
+	.pix_limit	 = &s5p_pix_limit[0],
 };
 
 static struct samsung_fimc_variant fimc2_variant_s5p = {
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
-
-	.scaler_en_w	= 4224,
-	.scaler_dis_w	= 8192,
-	.in_rot_en_h	= 1920,
-	.in_rot_dis_w	= 8192,
-	.out_rot_en_w	= 1920,
-	.out_rot_dis_w	= 4224,
+	.hor_offs_align	 = 8,
+	.out_buf_count	 = 4,
+	.pix_limit = &s5p_pix_limit[1],
 };
 
-static struct samsung_fimc_variant fimc01_variant_s5pv210 = {
-	.pix_hoff	= 1,
-	.has_inp_rot	= 1,
-	.has_out_rot	= 1,
+static struct samsung_fimc_variant fimc0_variant_s5pv210 = {
+	.pix_hoff	 = 1,
+	.has_inp_rot	 = 1,
+	.has_out_rot	 = 1,
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
+	.hor_offs_align	 = 8,
+	.out_buf_count	 = 4,
+	.pix_limit	 = &s5p_pix_limit[1],
+};
 
-	.scaler_en_w	= 4224,
-	.scaler_dis_w	= 8192,
-	.in_rot_en_h	= 1920,
-	.in_rot_dis_w	= 8192,
-	.out_rot_en_w	= 1920,
-	.out_rot_dis_w	= 4224,
+static struct samsung_fimc_variant fimc1_variant_s5pv210 = {
+	.pix_hoff	 = 1,
+	.has_inp_rot	 = 1,
+	.has_out_rot	 = 1,
+	.min_inp_pixsize = 16,
+	.min_out_pixsize = 16,
+	.hor_offs_align	 = 1,
+	.out_buf_count	 = 4,
+	.pix_limit	 = &s5p_pix_limit[2],
 };
 
 static struct samsung_fimc_variant fimc2_variant_s5pv210 = {
 	.pix_hoff	 = 1,
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
+	.hor_offs_align	 = 8,
+	.out_buf_count	 = 4,
+	.pix_limit	 = &s5p_pix_limit[2],
+};
 
-	.scaler_en_w	= 1920,
-	.scaler_dis_w	= 8192,
-	.in_rot_en_h	= 1280,
-	.in_rot_dis_w	= 8192,
-	.out_rot_en_w	= 1280,
-	.out_rot_dis_w	= 1920,
+static struct samsung_fimc_variant fimc0_variant_s5pv310 = {
+	.pix_hoff	 = 1,
+	.has_inp_rot	 = 1,
+	.has_out_rot	 = 1,
+	.min_inp_pixsize = 16,
+	.min_out_pixsize = 16,
+	.hor_offs_align	 = 1,
+	.out_buf_count	 = 32,
+	.pix_limit	 = &s5p_pix_limit[1],
+};
+
+static struct samsung_fimc_variant fimc2_variant_s5pv310 = {
+	.pix_hoff	 = 1,
+	.min_inp_pixsize = 16,
+	.min_out_pixsize = 16,
+	.hor_offs_align	 = 1,
+	.out_buf_count	 = 32,
+	.pix_limit	 = &s5p_pix_limit[2],
 };
 
+/* S5PC100 */
 static struct samsung_fimc_driverdata fimc_drvdata_s5p = {
 	.variant = {
-		[0] = &fimc01_variant_s5p,
-		[1] = &fimc01_variant_s5p,
+		[0] = &fimc0_variant_s5p,
+		[1] = &fimc0_variant_s5p,
 		[2] = &fimc2_variant_s5p,
 	},
-	.devs_cnt	= 3,
-	.lclk_frequency	= 133000000UL,
+	.num_entities = 3,
+	.lclk_frequency = 133000000UL,
 };
 
+/* S5PV210, S5PC110 */
 static struct samsung_fimc_driverdata fimc_drvdata_s5pv210 = {
 	.variant = {
-		[0] = &fimc01_variant_s5pv210,
-		[1] = &fimc01_variant_s5pv210,
+		[0] = &fimc0_variant_s5pv210,
+		[1] = &fimc1_variant_s5pv210,
 		[2] = &fimc2_variant_s5pv210,
 	},
-	.devs_cnt = 3,
-	.lclk_frequency	= 166000000UL,
+	.num_entities = 3,
+	.lclk_frequency = 166000000UL,
+};
+
+/* S5PV310, S5PC210 */
+static struct samsung_fimc_driverdata fimc_drvdata_s5pv310 = {
+	.variant = {
+		[0] = &fimc0_variant_s5pv310,
+		[1] = &fimc0_variant_s5pv310,
+		[2] = &fimc0_variant_s5pv310,
+		[3] = &fimc2_variant_s5pv310,
+	},
+	.num_entities = 4,
+	.lclk_frequency = 166000000UL,
 };
 
 static struct platform_device_id fimc_driver_ids[] = {
@@ -1726,6 +1790,9 @@ static struct platform_device_id fimc_driver_ids[] = {
 	}, {
 		.name		= "s5pv210-fimc",
 		.driver_data	= (unsigned long)&fimc_drvdata_s5pv210,
+	}, {
+		.name		= "s5pv310-fimc",
+		.driver_data	= (unsigned long)&fimc_drvdata_s5pv310,
 	},
 	{},
 };
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index ce0a6b8..e3a7c6a 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -36,7 +36,7 @@
 #define FIMC_SHUTDOWN_TIMEOUT	((100*HZ)/1000)
 #define NUM_FIMC_CLOCKS		2
 #define MODULE_NAME		"s5p-fimc"
-#define FIMC_MAX_DEVS		3
+#define FIMC_MAX_DEVS		4
 #define FIMC_MAX_OUT_BUFS	4
 #define SCALER_MAX_HRATIO	64
 #define SCALER_MAX_VRATIO	64
@@ -345,33 +345,45 @@ struct fimc_vid_cap {
 };
 
 /**
+ *  struct fimc_pix_limit - image pixel size limits in various IP configurations
+ *
+ *  @scaler_en_w: max input pixel width when the scaler is enabled
+ *  @scaler_dis_w: max input pixel width when the scaler is disabled
+ *  @in_rot_en_h: max input width with the input rotator is on
+ *  @in_rot_dis_w: max input width with the input rotator is off
+ *  @out_rot_en_w: max output width with the output rotator on
+ *  @out_rot_dis_w: max output width with the output rotator off
+ */
+struct fimc_pix_limit {
+	u16 scaler_en_w;
+	u16 scaler_dis_w;
+	u16 in_rot_en_h;
+	u16 in_rot_dis_w;
+	u16 out_rot_en_w;
+	u16 out_rot_dis_w;
+};
+
+/**
  * struct samsung_fimc_variant - camera interface variant information
  *
  * @pix_hoff: indicate whether horizontal offset is in pixels or in bytes
  * @has_inp_rot: set if has input rotator
  * @has_out_rot: set if has output rotator
+ * @pix_limit: pixel size constraints for the scaler
  * @min_inp_pixsize: minimum input pixel size
  * @min_out_pixsize: minimum output pixel size
- * @scaler_en_w: maximum input pixel width when the scaler is enabled
- * @scaler_dis_w: maximum input pixel width when the scaler is disabled
- * @in_rot_en_h: maximum input width when the input rotator is enabled
- * @in_rot_dis_w: maximum input width when the input rotator is disabled
- * @out_rot_en_w: maximum target width when the output rotator enabled
- * @out_rot_dis_w: maximum target width when the output rotator disnabled
+ * @hor_offs_align: horizontal pixel offset aligment
+ * @out_buf_count: the number of buffers in output DMA sequence
  */
 struct samsung_fimc_variant {
 	unsigned int	pix_hoff:1;
 	unsigned int	has_inp_rot:1;
 	unsigned int	has_out_rot:1;
-
+	struct fimc_pix_limit *pix_limit;
 	u16		min_inp_pixsize;
 	u16		min_out_pixsize;
-	u16		scaler_en_w;
-	u16		scaler_dis_w;
-	u16		in_rot_en_h;
-	u16		in_rot_dis_w;
-	u16		out_rot_en_w;
-	u16		out_rot_dis_w;
+	u16		hor_offs_align;
+	u16		out_buf_count;
 };
 
 /**
@@ -384,7 +396,7 @@ struct samsung_fimc_variant {
 struct samsung_fimc_driverdata {
 	struct samsung_fimc_variant *variant[FIMC_MAX_DEVS];
 	unsigned long	lclk_frequency;
-	int		devs_cnt;
+	int		num_entities;
 };
 
 struct fimc_ctx;
@@ -507,6 +519,20 @@ static inline void fimc_hw_dis_capture(struct fimc_dev *dev)
 	writel(cfg, dev->regs + S5P_CIIMGCPT);
 }
 
+/**
+ * fimc_hw_set_dma_seq - configure output DMA buffer sequence
+ * @mask: each bit corresponds to one of 32 output buffer registers set
+ *	  1 to include buffer in the sequence, 0 to disable
+ *
+ * This function mask output DMA ring buffers, i.e. it allows to configure
+ * which of the output buffer address registers will be used by the DMA
+ * engine.
+ */
+static inline void fimc_hw_set_dma_seq(struct fimc_dev *dev, u32 mask)
+{
+	writel(mask, dev->regs + S5P_CIFCNTSEQ);
+}
+
 static inline struct fimc_frame *ctx_get_frame(struct fimc_ctx *ctx,
 					       enum v4l2_buf_type type)
 {
diff --git a/drivers/media/video/s5p-fimc/regs-fimc.h b/drivers/media/video/s5p-fimc/regs-fimc.h
index 9e83315..a57daed 100644
--- a/drivers/media/video/s5p-fimc/regs-fimc.h
+++ b/drivers/media/video/s5p-fimc/regs-fimc.h
@@ -279,4 +279,7 @@
 #define S5P_CSIIMGFMT_USER3		0x32
 #define S5P_CSIIMGFMT_USER4		0x33
 
+/* Output frame buffer sequence mask */
+#define S5P_CIFCNTSEQ			0x1FC
+
 #endif /* REGS_FIMC_H_ */
-- 
1.7.3.1

