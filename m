Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54591 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab0I2KYG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Sep 2010 06:24:06 -0400
Date: Wed, 29 Sep 2010 12:23:46 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 2/4] V4L/DVB: s5p-fimc: M2M driver cleanup and minor
 improvements
In-reply-to: <1285755828-7815-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-arm-kernel@lists.infraded.org,
	linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1285755828-7815-3-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1285755828-7815-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Fixed errors on module unload, comments and whitespace cleanup.
Removed workqueue since it was only useful for FIFO output mode
which is not supported at this time.
Fixed 90/270 deg rotation errors (driver performing 270 deg rotation
instead of 90 in some conditions).

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |  151 +++++++++++-------------------
 drivers/media/video/s5p-fimc/fimc-core.h |  132 ++++++++++++++------------
 drivers/media/video/s5p-fimc/fimc-reg.c  |   27 +++---
 3 files changed, 142 insertions(+), 168 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 6961c55..fe46aea 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -117,7 +117,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.buff_cnt = 1,
 		.planes_cnt = 2
 	}
- };
+};
 
 static struct v4l2_queryctrl fimc_ctrls[] = {
 	{
@@ -127,16 +127,14 @@ static struct v4l2_queryctrl fimc_ctrls[] = {
 		.minimum	= 0,
 		.maximum	= 1,
 		.default_value	= 0,
-	},
-	{
+	}, {
 		.id		= V4L2_CID_VFLIP,
 		.type		= V4L2_CTRL_TYPE_BOOLEAN,
 		.name		= "Vertical flip",
 		.minimum	= 0,
 		.maximum	= 1,
 		.default_value	= 0,
-	},
-	{
+	}, {
 		.id		= V4L2_CID_ROTATE,
 		.type		= V4L2_CTRL_TYPE_INTEGER,
 		.name		= "Rotation (CCW)",
@@ -181,28 +179,23 @@ static int fimc_check_scaler_ratio(struct v4l2_rect *r, struct fimc_frame *f)
 
 static int fimc_get_scaler_factor(u32 src, u32 tar, u32 *ratio, u32 *shift)
 {
-	if (src >= tar * 64) {
+	u32 sh = 6;
+
+	if (src >= 64 * tar)
 		return -EINVAL;
-	} else if (src >= tar * 32) {
-		*ratio = 32;
-		*shift = 5;
-	} else if (src >= tar * 16) {
-		*ratio = 16;
-		*shift = 4;
-	} else if (src >= tar * 8) {
-		*ratio = 8;
-		*shift = 3;
-	} else if (src >= tar * 4) {
-		*ratio = 4;
-		*shift = 2;
-	} else if (src >= tar * 2) {
-		*ratio = 2;
-		*shift = 1;
-	} else {
-		*ratio = 1;
-		*shift = 0;
+
+	while (sh--) {
+		u32 tmp = 1 << sh;
+		if (src >= tar * tmp) {
+			*shift = sh, *ratio = tmp;
+			return 0;
+		}
 	}
 
+	*shift = 0, *ratio = 1;
+
+	dbg("s: %d, t: %d, shift: %d, ratio: %d",
+	    src, tar, *shift, *ratio);
 	return 0;
 }
 
@@ -265,8 +258,8 @@ static int fimc_set_scaler_info(struct fimc_ctx *ctx)
 static irqreturn_t fimc_isr(int irq, void *priv)
 {
 	struct fimc_vid_buffer *src_buf, *dst_buf;
-	struct fimc_dev *fimc = (struct fimc_dev *)priv;
 	struct fimc_ctx *ctx;
+	struct fimc_dev *fimc = priv;
 
 	BUG_ON(!fimc);
 	fimc_hw_clear_irq(fimc);
@@ -281,7 +274,7 @@ static irqreturn_t fimc_isr(int irq, void *priv)
 		dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
 		if (src_buf && dst_buf) {
 			spin_lock(&fimc->irqlock);
-			src_buf->vb.state = dst_buf->vb.state =  VIDEOBUF_DONE;
+			src_buf->vb.state = dst_buf->vb.state = VIDEOBUF_DONE;
 			wake_up(&src_buf->vb.done);
 			wake_up(&dst_buf->vb.done);
 			spin_unlock(&fimc->irqlock);
@@ -295,20 +288,13 @@ isr_unlock:
 }
 
 /* The color format (planes_cnt, buff_cnt) must be already configured. */
-static int fimc_prepare_addr(struct fimc_ctx *ctx,
-		struct fimc_vid_buffer *buf, enum v4l2_buf_type type)
+int fimc_prepare_addr(struct fimc_ctx *ctx, struct fimc_vid_buffer *buf,
+		      struct fimc_frame *frame, struct fimc_addr *paddr)
 {
-	struct fimc_frame *frame;
-	struct fimc_addr *paddr;
-	u32 pix_size;
 	int ret = 0;
+	u32 pix_size;
 
-	frame = ctx_m2m_get_frame(ctx, type);
-	if (IS_ERR(frame))
-		return PTR_ERR(frame);
-	paddr = &frame->paddr;
-
-	if (!buf)
+	if (buf == NULL || frame == NULL)
 		return -EINVAL;
 
 	pix_size = frame->width * frame->height;
@@ -344,8 +330,8 @@ static int fimc_prepare_addr(struct fimc_ctx *ctx,
 		}
 	}
 
-	dbg("PHYS_ADDR: type= %d, y= 0x%X  cb= 0x%X cr= 0x%X ret= %d",
-	type, paddr->y, paddr->cb, paddr->cr, ret);
+	dbg("PHYS_ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d",
+	    paddr->y, paddr->cb, paddr->cr, ret);
 
 	return ret;
 }
@@ -466,16 +452,14 @@ static int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags)
 
 	if (flags & FIMC_SRC_ADDR) {
 		buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
-		ret = fimc_prepare_addr(ctx, buf,
-			V4L2_BUF_TYPE_VIDEO_OUTPUT);
+		ret = fimc_prepare_addr(ctx, buf, s_frame, &s_frame->paddr);
 		if (ret)
 			return ret;
 	}
 
 	if (flags & FIMC_DST_ADDR) {
 		buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
-		ret = fimc_prepare_addr(ctx, buf,
-			V4L2_BUF_TYPE_VIDEO_CAPTURE);
+		ret = fimc_prepare_addr(ctx, buf, d_frame, &d_frame->paddr);
 	}
 
 	return ret;
@@ -499,12 +483,14 @@ static void fimc_dma_run(void *priv)
 	ctx->state |= (FIMC_SRC_ADDR | FIMC_DST_ADDR);
 	ret = fimc_prepare_config(ctx, ctx->state);
 	if (ret) {
-		err("general configuration error");
+		err("Wrong parameters");
 		goto dma_unlock;
 	}
-
-	if (fimc->m2m.ctx != ctx)
+	/* Reconfigure hardware if the context has changed. */
+	if (fimc->m2m.ctx != ctx) {
 		ctx->state |= FIMC_PARAMS;
+		fimc->m2m.ctx = ctx;
+	}
 
 	fimc_hw_set_input_addr(fimc, &ctx->s_frame.paddr);
 
@@ -512,10 +498,9 @@ static void fimc_dma_run(void *priv)
 		fimc_hw_set_input_path(ctx);
 		fimc_hw_set_in_dma(ctx);
 		if (fimc_set_scaler_info(ctx)) {
-			err("scaler configuration error");
+			err("Scaler setup error");
 			goto dma_unlock;
 		}
-		fimc_hw_set_prescaler(ctx);
 		fimc_hw_set_scaler(ctx);
 		fimc_hw_set_target_format(ctx);
 		fimc_hw_set_rotation(ctx);
@@ -524,19 +509,15 @@ static void fimc_dma_run(void *priv)
 
 	fimc_hw_set_output_path(ctx);
 	if (ctx->state & (FIMC_DST_ADDR | FIMC_PARAMS))
-		fimc_hw_set_output_addr(fimc, &ctx->d_frame.paddr);
+		fimc_hw_set_output_addr(fimc, &ctx->d_frame.paddr, -1);
 
 	if (ctx->state & FIMC_PARAMS)
 		fimc_hw_set_out_dma(ctx);
 
-	if (ctx->scaler.enabled)
-		fimc_hw_start_scaler(fimc);
-	fimc_hw_en_capture(ctx);
-
 	ctx->state = 0;
-	fimc_hw_start_in_dma(fimc);
+	fimc_activate_capture(ctx);
 
-	fimc->m2m.ctx = ctx;
+	fimc_hw_activate_input_dma(fimc, true);
 
 dma_unlock:
 	spin_unlock_irqrestore(&ctx->slock, flags);
@@ -560,7 +541,7 @@ static int fimc_buf_setup(struct videobuf_queue *vq, unsigned int *count,
 	struct fimc_ctx *ctx = vq->priv_data;
 	struct fimc_frame *frame;
 
-	frame = ctx_m2m_get_frame(ctx, vq->type);
+	frame = ctx_get_frame(ctx, vq->type);
 	if (IS_ERR(frame))
 		return PTR_ERR(frame);
 
@@ -578,7 +559,7 @@ static int fimc_buf_prepare(struct videobuf_queue *vq,
 	struct fimc_frame *frame;
 	int ret;
 
-	frame = ctx_m2m_get_frame(ctx, vq->type);
+	frame = ctx_get_frame(ctx, vq->type);
 	if (IS_ERR(frame))
 		return PTR_ERR(frame);
 
@@ -663,7 +644,7 @@ static int fimc_m2m_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	struct fimc_ctx *ctx = priv;
 	struct fimc_frame *frame;
 
-	frame = ctx_m2m_get_frame(ctx, f->type);
+	frame = ctx_get_frame(ctx, f->type);
 	if (IS_ERR(frame))
 		return PTR_ERR(frame);
 
@@ -999,7 +980,7 @@ static int fimc_m2m_cropcap(struct file *file, void *fh,
 	struct fimc_frame *frame;
 	struct fimc_ctx *ctx = fh;
 
-	frame = ctx_m2m_get_frame(ctx, cr->type);
+	frame = ctx_get_frame(ctx, cr->type);
 	if (IS_ERR(frame))
 		return PTR_ERR(frame);
 
@@ -1019,7 +1000,7 @@ static int fimc_m2m_g_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 	struct fimc_frame *frame;
 	struct fimc_ctx *ctx = file->private_data;
 
-	frame = ctx_m2m_get_frame(ctx, cr->type);
+	frame = ctx_get_frame(ctx, cr->type);
 	if (IS_ERR(frame))
 		return PTR_ERR(frame);
 
@@ -1052,7 +1033,7 @@ static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 		return -EINVAL;
 	}
 
-	f = ctx_m2m_get_frame(ctx, cr->type);
+	f = ctx_get_frame(ctx, cr->type);
 	if (IS_ERR(f))
 		return PTR_ERR(f);
 
@@ -1136,7 +1117,7 @@ static void queue_init(void *priv, struct videobuf_queue *vq,
 	struct fimc_dev *fimc = ctx->fimc_dev;
 
 	videobuf_queue_dma_contig_init(vq, &fimc_qops,
-		fimc->m2m.v4l2_dev.dev,
+		&fimc->pdev->dev,
 		&fimc->irqlock, type, V4L2_FIELD_NONE,
 		sizeof(struct fimc_vid_buffer), priv);
 }
@@ -1159,13 +1140,12 @@ static int fimc_m2m_open(struct file *file)
 
 	file->private_data = ctx;
 	ctx->fimc_dev = fimc;
-	/* default format */
+	/* Default color format */
 	ctx->s_frame.fmt = &fimc_formats[0];
 	ctx->d_frame.fmt = &fimc_formats[0];
 	/* per user process device context initialization */
 	ctx->state = 0;
 	ctx->flags = 0;
-	ctx->effect.type = S5P_FIMC_EFFECT_ORIGINAL;
 	ctx->in_path = FIMC_DMA;
 	ctx->out_path = FIMC_DMA;
 	spin_lock_init(&ctx->slock);
@@ -1241,7 +1221,7 @@ static int fimc_register_m2m_device(struct fimc_dev *fimc)
 
 	ret = v4l2_device_register(&pdev->dev, v4l2_dev);
 	if (ret)
-		return ret;;
+		goto err_m2m_r1;
 
 	vfd = video_device_alloc();
 	if (!vfd) {
@@ -1293,7 +1273,7 @@ static void fimc_unregister_m2m_device(struct fimc_dev *fimc)
 	if (fimc) {
 		v4l2_m2m_release(fimc->m2m.m2m_dev);
 		video_unregister_device(fimc->m2m.vfd);
-		video_device_release(fimc->m2m.vfd);
+
 		v4l2_device_unregister(&fimc->m2m.v4l2_dev);
 	}
 }
@@ -1399,25 +1379,15 @@ static int fimc_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
-	fimc->work_queue = create_workqueue(dev_name(&fimc->pdev->dev));
-	if (!fimc->work_queue) {
-		ret = -ENOMEM;
-		goto err_irq;
-	}
-
 	ret = fimc_register_m2m_device(fimc);
 	if (ret)
-		goto err_wq;
-
-	fimc_hw_en_lastirq(fimc, true);
+		goto err_irq;
 
 	dev_dbg(&pdev->dev, "%s(): fimc-%d registered successfully\n",
 		__func__, fimc->id);
 
 	return 0;
 
-err_wq:
-	destroy_workqueue(fimc->work_queue);
 err_irq:
 	free_irq(fimc->irq, fimc);
 err_clk:
@@ -1429,7 +1399,7 @@ err_req_region:
 	kfree(fimc->regs_res);
 err_info:
 	kfree(fimc);
-	dev_err(&pdev->dev, "failed to install\n");
+
 	return ret;
 }
 
@@ -1438,10 +1408,7 @@ static int __devexit fimc_remove(struct platform_device *pdev)
 	struct fimc_dev *fimc =
 		(struct fimc_dev *)platform_get_drvdata(pdev);
 
-	v4l2_info(&fimc->m2m.v4l2_dev, "Removing %s\n", pdev->name);
-
 	free_irq(fimc->irq, fimc);
-
 	fimc_hw_reset(fimc);
 
 	fimc_unregister_m2m_device(fimc);
@@ -1450,6 +1417,8 @@ static int __devexit fimc_remove(struct platform_device *pdev)
 	release_resource(fimc->regs_res);
 	kfree(fimc->regs_res);
 	kfree(fimc);
+
+	dev_info(&pdev->dev, "%s driver unloaded\n", pdev->name);
 	return 0;
 }
 
@@ -1484,7 +1453,7 @@ static struct samsung_fimc_variant fimc01_variant_s5pv210 = {
 	.has_inp_rot	= 1,
 	.has_out_rot	= 1,
 	.min_inp_pixsize = 16,
-	.min_out_pixsize = 32,
+	.min_out_pixsize = 16,
 
 	.scaler_en_w	= 4224,
 	.scaler_dis_w	= 8192,
@@ -1497,7 +1466,7 @@ static struct samsung_fimc_variant fimc01_variant_s5pv210 = {
 static struct samsung_fimc_variant fimc2_variant_s5pv210 = {
 	.pix_hoff	 = 1,
 	.min_inp_pixsize = 16,
-	.min_out_pixsize = 32,
+	.min_out_pixsize = 16,
 
 	.scaler_en_w	= 1920,
 	.scaler_dis_w	= 8192,
@@ -1547,20 +1516,12 @@ static struct platform_driver fimc_driver = {
 	}
 };
 
-static char banner[] __initdata = KERN_INFO
-	"S5PC Camera Interface V4L2 Driver, (c) 2010 Samsung Electronics\n";
-
 static int __init fimc_init(void)
 {
-	u32 ret;
-	printk(banner);
-
-	ret = platform_driver_register(&fimc_driver);
-	if (ret) {
-		printk(KERN_ERR "FIMC platform driver register failed\n");
-		return -1;
-	}
-	return 0;
+	int ret = platform_driver_register(&fimc_driver);
+	if (ret)
+		err("platform_driver_register failed: %d\n", ret);
+	return ret;
 }
 
 static void __exit fimc_exit(void)
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 6b3e0cd..5aeb3ef 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -34,6 +34,7 @@
 #define FIMC_MAX_OUT_BUFS	4
 #define SCALER_MAX_HRATIO	64
 #define SCALER_MAX_VRATIO	64
+#define DMA_MIN_SIZE		8
 
 enum {
 	ST_IDLE,
@@ -54,21 +55,21 @@ enum fimc_datapath {
 };
 
 enum fimc_color_fmt {
-	S5P_FIMC_RGB565,
+	S5P_FIMC_RGB565 = 0x10,
 	S5P_FIMC_RGB666,
 	S5P_FIMC_RGB888,
-	S5P_FIMC_YCBCR420,
+	S5P_FIMC_RGB30_LOCAL,
+	S5P_FIMC_YCBCR420 = 0x20,
 	S5P_FIMC_YCBCR422,
 	S5P_FIMC_YCBYCR422,
 	S5P_FIMC_YCRYCB422,
 	S5P_FIMC_CBYCRY422,
 	S5P_FIMC_CRYCBY422,
-	S5P_FIMC_RGB30_LOCAL,
 	S5P_FIMC_YCBCR444_LOCAL,
-	S5P_FIMC_MAX_COLOR = S5P_FIMC_YCBCR444_LOCAL,
-	S5P_FIMC_COLOR_MASK = 0x0F,
 };
 
+#define fimc_fmt_is_rgb(x) ((x) & 0x10)
+
 /* Y/Cb/Cr components order at DMA output for 1 plane YCbCr 4:2:2 formats. */
 #define	S5P_FIMC_OUT_CRYCBY	S5P_CIOCTRL_ORDER422_CRYCBY
 #define	S5P_FIMC_OUT_CBYCRY	S5P_CIOCTRL_ORDER422_YCRYCB
@@ -93,11 +94,13 @@ enum fimc_color_fmt {
 #define	S5P_FIMC_EFFECT_SIKHOUETTE	S5P_CIIMGEFF_FIN_SILHOUETTE
 
 /* The hardware context state. */
-#define	FIMC_PARAMS			(1 << 0)
-#define	FIMC_SRC_ADDR			(1 << 1)
-#define	FIMC_DST_ADDR			(1 << 2)
-#define	FIMC_SRC_FMT			(1 << 3)
-#define	FIMC_DST_FMT			(1 << 4)
+#define	FIMC_PARAMS		(1 << 0)
+#define	FIMC_SRC_ADDR		(1 << 1)
+#define	FIMC_DST_ADDR		(1 << 2)
+#define	FIMC_SRC_FMT		(1 << 3)
+#define	FIMC_DST_FMT		(1 << 4)
+#define	FIMC_CTX_M2M		(1 << 5)
+#define	FIMC_CTX_CAP		(1 << 6)
 
 /* Image conversion flags */
 #define	FIMC_IN_DMA_ACCESS_TILED	(1 << 0)
@@ -106,7 +109,9 @@ enum fimc_color_fmt {
 #define	FIMC_OUT_DMA_ACCESS_LINEAR	(0 << 1)
 #define	FIMC_SCAN_MODE_PROGRESSIVE	(0 << 2)
 #define	FIMC_SCAN_MODE_INTERLACED	(1 << 2)
-/* YCbCr data dynamic range for RGB-YUV color conversion. Y/Cb/Cr: (0 ~ 255) */
+/*
+ * YCbCr data dynamic range for RGB-YUV color conversion.
+ * Y/Cb/Cr: (0 ~ 255) */
 #define	FIMC_COLOR_RANGE_WIDE		(0 << 3)
 /* Y (16 ~ 235), Cb/Cr (16 ~ 240) */
 #define	FIMC_COLOR_RANGE_NARROW		(1 << 3)
@@ -167,37 +172,37 @@ struct fimc_effect {
 /**
  * struct fimc_scaler - the configuration data for FIMC inetrnal scaler
  *
- * @enabled:		the flag set when the scaler is used
+ * @scaleup_h:		flag indicating scaling up horizontally
+ * @scaleup_v:		flag indicating scaling up vertically
+ * @copy_mode:		flag indicating transparent DMA transfer (no scaling
+ *			and color format conversion)
+ * @enabled:		flag indicating if the scaler is used
  * @hfactor:		horizontal shift factor
  * @vfactor:		vertical shift factor
  * @pre_hratio:		horizontal ratio of the prescaler
  * @pre_vratio:		vertical ratio of the prescaler
  * @pre_dst_width:	the prescaler's destination width
  * @pre_dst_height:	the prescaler's destination height
- * @scaleup_h:		flag indicating scaling up horizontally
- * @scaleup_v:		flag indicating scaling up vertically
  * @main_hratio:	the main scaler's horizontal ratio
  * @main_vratio:	the main scaler's vertical ratio
- * @real_width:		source width - offset
- * @real_height:	source height - offset
- * @copy_mode:		flag set if one-to-one mode is used, i.e. no scaling
- *			and color format conversion
+ * @real_width:		source pixel (width - offset)
+ * @real_height:	source pixel (height - offset)
  */
 struct fimc_scaler {
-	u32	enabled;
+	int	scaleup_h:1;
+	int	scaleup_v:1;
+	int	copy_mode:1;
+	int	enabled:1;
 	u32	hfactor;
 	u32	vfactor;
 	u32	pre_hratio;
 	u32	pre_vratio;
 	u32	pre_dst_width;
 	u32	pre_dst_height;
-	u32	scaleup_h;
-	u32	scaleup_v;
 	u32	main_hratio;
 	u32	main_vratio;
 	u32	real_width;
 	u32	real_height;
-	u32	copy_mode;
 };
 
 /**
@@ -222,8 +227,7 @@ struct fimc_vid_buffer {
 };
 
 /**
- * struct fimc_frame - input/output frame format properties
- *
+ * struct fimc_frame - source/target frame properties
  * @f_width:	image full width (virtual screen size)
  * @f_height:	image full height (virtual screen size)
  * @o_width:	original image width as set by S_FMT
@@ -279,10 +283,10 @@ struct fimc_m2m_device {
  * @min_out_pixsize: minimum output pixel size
  * @scaler_en_w: maximum input pixel width when the scaler is enabled
  * @scaler_dis_w: maximum input pixel width when the scaler is disabled
- * @in_rot_en_h: maximum input width when the input rotator is used
- * @in_rot_dis_w: maximum input width when the input rotator is used
- * @out_rot_en_w: maximum output width for the output rotator enabled
- * @out_rot_dis_w: maximum output width for the output rotator enabled
+ * @in_rot_en_h: maximum input width when the input rotator is enabled
+ * @in_rot_dis_w: maximum input width when the input rotator is disabled
+ * @out_rot_en_w: maximum target width when the output rotator enabled
+ * @out_rot_dis_w: maximum target width when the output rotator disnabled
  */
 struct samsung_fimc_variant {
 	unsigned int	pix_hoff:1;
@@ -300,7 +304,7 @@ struct samsung_fimc_variant {
 };
 
 /**
- * struct samsung_fimc_driverdata - per-device type driver data for init time.
+ * struct samsung_fimc_driverdata - per device type driver data for init time.
  *
  * @variant: the variant information for this driver.
  * @dev_cnt: number of fimc sub-devices available in SoC
@@ -313,7 +317,7 @@ struct samsung_fimc_driverdata {
 struct fimc_ctx;
 
 /**
- * struct fimc_subdev - abstraction for a FIMC entity
+ * struct fimc_dev - abstraction for FIMC entity
  *
  * @slock:	the spinlock protecting this data structure
  * @lock:	the mutex protecting this data structure
@@ -323,7 +327,7 @@ struct fimc_ctx;
  * @regs:	the mapped hardware registers
  * @regs_res:	the resource claimed for IO registers
  * @irq:	interrupt number of the FIMC subdevice
- * @irqlock:	spinlock protecting videbuffer queue
+ * @irqlock:	spinlock protecting videobuffer queue
  * @m2m:	memory-to-memory V4L2 device information
  * @state:	the FIMC device state flags
  */
@@ -338,7 +342,6 @@ struct fimc_dev {
 	struct resource			*regs_res;
 	int				irq;
 	spinlock_t			irqlock;
-	struct workqueue_struct		*work_queue;
 	struct fimc_m2m_device		m2m;
 	unsigned long			state;
 };
@@ -359,7 +362,7 @@ struct fimc_dev {
  * @effect:		image effect
  * @rotation:		image clockwise rotation in degrees
  * @flip:		image flip mode
- * @flags:		an additional flags for image conversion
+ * @flags:		additional flags for image conversion
  * @state:		flags to keep track of user configuration
  * @fimc_dev:		the FIMC device this context applies to
  * @m2m_ctx:		memory-to-memory device context
@@ -397,18 +400,24 @@ static inline void fimc_hw_clear_irq(struct fimc_dev *dev)
 	writel(cfg, dev->regs + S5P_CIGCTRL);
 }
 
-static inline void fimc_hw_start_scaler(struct fimc_dev *dev)
+static inline void fimc_hw_enable_scaler(struct fimc_dev *dev, bool on)
 {
 	u32 cfg = readl(dev->regs + S5P_CISCCTRL);
-	cfg |= S5P_CISCCTRL_SCALERSTART;
+	if (on)
+		cfg |= S5P_CISCCTRL_SCALERSTART;
+	else
+		cfg &= ~S5P_CISCCTRL_SCALERSTART;
 	writel(cfg, dev->regs + S5P_CISCCTRL);
 }
 
-static inline void fimc_hw_stop_scaler(struct fimc_dev *dev)
+static inline void fimc_hw_activate_input_dma(struct fimc_dev *dev, bool on)
 {
-	u32 cfg = readl(dev->regs + S5P_CISCCTRL);
-	cfg &= ~S5P_CISCCTRL_SCALERSTART;
-	writel(cfg, dev->regs + S5P_CISCCTRL);
+	u32 cfg = readl(dev->regs + S5P_MSCTRL);
+	if (on)
+		cfg |= S5P_MSCTRL_ENVID;
+	else
+		cfg &= ~S5P_MSCTRL_ENVID;
+	writel(cfg, dev->regs + S5P_MSCTRL);
 }
 
 static inline void fimc_hw_dis_capture(struct fimc_dev *dev)
@@ -418,22 +427,8 @@ static inline void fimc_hw_dis_capture(struct fimc_dev *dev)
 	writel(cfg, dev->regs + S5P_CIIMGCPT);
 }
 
-static inline void fimc_hw_start_in_dma(struct fimc_dev *dev)
-{
-	u32 cfg = readl(dev->regs + S5P_MSCTRL);
-	cfg |= S5P_MSCTRL_ENVID;
-	writel(cfg, dev->regs + S5P_MSCTRL);
-}
-
-static inline void fimc_hw_stop_in_dma(struct fimc_dev *dev)
-{
-	u32 cfg = readl(dev->regs + S5P_MSCTRL);
-	cfg &= ~S5P_MSCTRL_ENVID;
-	writel(cfg, dev->regs + S5P_MSCTRL);
-}
-
-static inline struct fimc_frame *ctx_m2m_get_frame(struct fimc_ctx *ctx,
-						   enum v4l2_buf_type type)
+static inline struct fimc_frame *ctx_get_frame(struct fimc_ctx *ctx,
+					       enum v4l2_buf_type type)
 {
 	struct fimc_frame *frame;
 
@@ -452,20 +447,35 @@ static inline struct fimc_frame *ctx_m2m_get_frame(struct fimc_ctx *ctx,
 
 /* -----------------------------------------------------*/
 /* fimc-reg.c						*/
-void fimc_hw_reset(struct fimc_dev *dev);
+void fimc_hw_reset(struct fimc_dev *fimc);
 void fimc_hw_set_rotation(struct fimc_ctx *ctx);
 void fimc_hw_set_target_format(struct fimc_ctx *ctx);
 void fimc_hw_set_out_dma(struct fimc_ctx *ctx);
-void fimc_hw_en_lastirq(struct fimc_dev *dev, int enable);
-void fimc_hw_en_irq(struct fimc_dev *dev, int enable);
-void fimc_hw_set_prescaler(struct fimc_ctx *ctx);
+void fimc_hw_en_lastirq(struct fimc_dev *fimc, int enable);
+void fimc_hw_en_irq(struct fimc_dev *fimc, int enable);
 void fimc_hw_set_scaler(struct fimc_ctx *ctx);
 void fimc_hw_en_capture(struct fimc_ctx *ctx);
 void fimc_hw_set_effect(struct fimc_ctx *ctx);
 void fimc_hw_set_in_dma(struct fimc_ctx *ctx);
 void fimc_hw_set_input_path(struct fimc_ctx *ctx);
 void fimc_hw_set_output_path(struct fimc_ctx *ctx);
-void fimc_hw_set_input_addr(struct fimc_dev *dev, struct fimc_addr *paddr);
-void fimc_hw_set_output_addr(struct fimc_dev *dev, struct fimc_addr *paddr);
+void fimc_hw_set_input_addr(struct fimc_dev *fimc, struct fimc_addr *paddr);
+void fimc_hw_set_output_addr(struct fimc_dev *fimc, struct fimc_addr *paddr,
+			      int index);
+
+/* Locking: the caller holds fimc->slock */
+static inline void fimc_activate_capture(struct fimc_ctx *ctx)
+{
+	fimc_hw_enable_scaler(ctx->fimc_dev, ctx->scaler.enabled);
+	fimc_hw_en_capture(ctx);
+}
+
+static inline void fimc_deactivate_capture(struct fimc_dev *fimc)
+{
+	fimc_hw_en_lastirq(fimc, true);
+	fimc_hw_dis_capture(fimc);
+	fimc_hw_enable_scaler(fimc, false);
+	fimc_hw_en_lastirq(fimc, false);
+}
 
 #endif /* FIMC_CORE_H_ */
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 70f29c5..13d4796 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -29,7 +29,7 @@ void fimc_hw_reset(struct fimc_dev *dev)
 	cfg = readl(dev->regs + S5P_CIGCTRL);
 	cfg |= (S5P_CIGCTRL_SWRST | S5P_CIGCTRL_IRQ_LEVEL);
 	writel(cfg, dev->regs + S5P_CIGCTRL);
-	msleep(1);
+	usleep_range(1000, 5000);
 
 	cfg = readl(dev->regs + S5P_CIGCTRL);
 	cfg &= ~S5P_CIGCTRL_SWRST;
@@ -43,7 +43,8 @@ void fimc_hw_set_rotation(struct fimc_ctx *ctx)
 	struct fimc_dev *dev = ctx->fimc_dev;
 
 	cfg = readl(dev->regs + S5P_CITRGFMT);
-	cfg &= ~(S5P_CITRGFMT_INROT90 | S5P_CITRGFMT_OUTROT90);
+	cfg &= ~(S5P_CITRGFMT_INROT90 | S5P_CITRGFMT_OUTROT90 |
+		  S5P_CITRGFMT_FLIP_180);
 
 	flip = readl(dev->regs + S5P_MSCTRL);
 	flip &= ~S5P_MSCTRL_FLIP_MASK;
@@ -247,7 +248,7 @@ void fimc_hw_en_lastirq(struct fimc_dev *dev, int enable)
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-void fimc_hw_set_prescaler(struct fimc_ctx *ctx)
+static void fimc_hw_set_prescaler(struct fimc_ctx *ctx)
 {
 	struct fimc_dev *dev =  ctx->fimc_dev;
 	struct fimc_scaler *sc = &ctx->scaler;
@@ -274,6 +275,8 @@ void fimc_hw_set_scaler(struct fimc_ctx *ctx)
 	struct fimc_frame *dst_frame = &ctx->d_frame;
 	u32 cfg = 0;
 
+	fimc_hw_set_prescaler(ctx);
+
 	if (!(ctx->flags & FIMC_COLOR_RANGE_NARROW))
 		cfg |= (S5P_CISCCTRL_CSCR2Y_WIDE | S5P_CISCCTRL_CSCY2R_WIDE);
 
@@ -400,7 +403,7 @@ void fimc_hw_set_in_dma(struct fimc_ctx *ctx)
 	/* Input original and real size. */
 	fimc_hw_set_in_dma_size(ctx);
 
-	/* Autoload is used currently only in FIFO mode. */
+	/* Use DMA autoload only in FIFO mode. */
 	fimc_hw_en_autoload(dev, ctx->out_path == FIMC_LCDFIFO);
 
 	/* Set the input DMA to process single frame only. */
@@ -501,9 +504,7 @@ void fimc_hw_set_output_path(struct fimc_ctx *ctx)
 
 void fimc_hw_set_input_addr(struct fimc_dev *dev, struct fimc_addr *paddr)
 {
-	u32 cfg = 0;
-
-	cfg = readl(dev->regs + S5P_CIREAL_ISIZE);
+	u32 cfg = readl(dev->regs + S5P_CIREAL_ISIZE);
 	cfg |= S5P_CIREAL_ISIZE_ADDR_CH_DIS;
 	writel(cfg, dev->regs + S5P_CIREAL_ISIZE);
 
@@ -515,13 +516,15 @@ void fimc_hw_set_input_addr(struct fimc_dev *dev, struct fimc_addr *paddr)
 	writel(cfg, dev->regs + S5P_CIREAL_ISIZE);
 }
 
-void fimc_hw_set_output_addr(struct fimc_dev *dev, struct fimc_addr *paddr)
+void fimc_hw_set_output_addr(struct fimc_dev *dev,
+			     struct fimc_addr *paddr, int index)
 {
-	int i;
-	/* Set all the output register sets to point to single video buffer. */
-	for (i = 0; i < FIMC_MAX_OUT_BUFS; i++) {
+	int i = (index == -1) ? 0 : index;
+	do {
 		writel(paddr->y, dev->regs + S5P_CIOYSA(i));
 		writel(paddr->cb, dev->regs + S5P_CIOCBSA(i));
 		writel(paddr->cr, dev->regs + S5P_CIOCRSA(i));
-	}
+		dbg("dst_buf[%d]: 0x%X, cb: 0x%X, cr: 0x%X",
+		    i, paddr->y, paddr->cb, paddr->cr);
+	} while (index == -1 && ++i < FIMC_MAX_OUT_BUFS);
 }
-- 
1.7.3

