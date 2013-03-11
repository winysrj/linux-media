Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:58386 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab3CKTBJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 15:01:09 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	shaik.samsung@gmail.com, arun.kk@samsung.com, a.hajda@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 06/11] s5p-fimc: Add the FIMC ISP writeback input support
Date: Mon, 11 Mar 2013 20:00:21 +0100
Message-id: <1363028426-2771-7-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1363028426-2771-1-git-send-email-s.nawrocki@samsung.com>
References: <1363028426-2771-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A second sink pad is added to each FIMC.N subdev that will be used
to link it to the ISP subdev. Only V4L2_MBUS_FMT_YUV10_1X30 format
is supported at the pad FIMC_SD_PAD_SINK_FIFO.

TODO:
 - Implement the FIMC input bus type selection based on
   state of media link from FIMC-IS-ISP to FIMC.N subdev.
 - Implement an interface for CAMBLK registers, the CAMBLK glue
   logic registers are shared by multiple drivers so this
   probably belongs to the platform at arch/arm/mach-exynos/.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-capture.c |   31 +++++++----
 drivers/media/platform/s5p-fimc/fimc-core.c    |    4 ++
 drivers/media/platform/s5p-fimc/fimc-core.h    |    6 ++-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |    5 ++
 drivers/media/platform/s5p-fimc/fimc-reg.c     |   65 +++++++++++++++++++++++-
 drivers/media/platform/s5p-fimc/fimc-reg.h     |   10 ++++
 6 files changed, 108 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 52abc9f..a3a58c4 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -46,6 +46,9 @@ static int fimc_capture_hw_init(struct fimc_dev *fimc)
 
 	sensor = v4l2_get_subdev_hostdata(p->subdevs[IDX_SENSOR]);
 
+	if (sensor->pdata.fimc_bus_type == FIMC_BUS_TYPE_ISP_WRITEBACK)
+		fimc_hw_camblk_set_isp_wb(fimc, 1 << fimc->id, 1);
+
 	spin_lock_irqsave(&fimc->slock, flags);
 	fimc_prepare_dma_offset(ctx, &ctx->d_frame);
 	fimc_set_yuv_order(ctx);
@@ -647,18 +650,22 @@ static struct fimc_fmt *fimc_capture_try_format(struct fimc_ctx *ctx,
 	    fimc_fmt_is_user_defined(ctx->s_frame.fmt->color))
 		*code = ctx->s_frame.fmt->mbus_code;
 
-	if (fourcc && *fourcc != V4L2_PIX_FMT_JPEG && pad != FIMC_SD_PAD_SINK)
+	if (fourcc && *fourcc != V4L2_PIX_FMT_JPEG && pad == FIMC_SD_PAD_SOURCE)
 		mask |= FMT_FLAGS_M2M;
 
+	if (pad == FIMC_SD_PAD_SINK_FIFO)
+		mask = FMT_FLAGS_WRITEBACK;
+
 	ffmt = fimc_find_format(fourcc, code, mask, 0);
 	if (WARN_ON(!ffmt))
 		return NULL;
+
 	if (code)
 		*code = ffmt->mbus_code;
 	if (fourcc)
 		*fourcc = ffmt->fourcc;
 
-	if (pad == FIMC_SD_PAD_SINK) {
+	if (pad != FIMC_SD_PAD_SOURCE) {
 		max_w = fimc_fmt_is_user_defined(ffmt->color) ?
 			pl->scaler_dis_w : pl->scaler_en_w;
 		/* Apply the camera input interface pixel constraints */
@@ -1552,12 +1559,16 @@ static int fimc_subdev_get_fmt(struct v4l2_subdev *sd,
 	}
 	mf = &fmt->format;
 	mf->colorspace = V4L2_COLORSPACE_JPEG;
-	ff = fmt->pad == FIMC_SD_PAD_SINK ? &ctx->s_frame : &ctx->d_frame;
+	if (fmt->pad == FIMC_SD_PAD_SOURCE)
+		ff = &ctx->d_frame;
+	else
+		ff = &ctx->s_frame;
 
 	mutex_lock(&fimc->lock);
 	/* The pixel code is same on both input and output pad */
 	if (!WARN_ON(ctx->s_frame.fmt == NULL))
 		mf->code = ctx->s_frame.fmt->mbus_code;
+
 	mf->width  = ff->f_width;
 	mf->height = ff->f_height;
 	mutex_unlock(&fimc->lock);
@@ -1601,9 +1612,10 @@ static int fimc_subdev_set_fmt(struct v4l2_subdev *sd,
 	fimc_alpha_ctrl_update(ctx);
 
 	fimc_capture_mark_jpeg_xfer(ctx, ffmt->color);
-
-	ff = fmt->pad == FIMC_SD_PAD_SINK ?
-		&ctx->s_frame : &ctx->d_frame;
+	if (fmt->pad == FIMC_SD_PAD_SOURCE)
+		ff = &ctx->d_frame;
+	else
+		ff = &ctx->s_frame;
 
 	mutex_lock(&fimc->lock);
 	set_frame_bounds(ff, mf->width, mf->height);
@@ -1614,7 +1626,7 @@ static int fimc_subdev_set_fmt(struct v4l2_subdev *sd,
 	if (!(fmt->pad == FIMC_SD_PAD_SOURCE && (ctx->state & FIMC_COMPOSE)))
 		set_frame_crop(ff, 0, 0, mf->width, mf->height);
 
-	if (fmt->pad == FIMC_SD_PAD_SINK)
+	if (fmt->pad != FIMC_SD_PAD_SOURCE)
 		ctx->state &= ~FIMC_COMPOSE;
 	mutex_unlock(&fimc->lock);
 	return 0;
@@ -1630,7 +1642,7 @@ static int fimc_subdev_get_selection(struct v4l2_subdev *sd,
 	struct v4l2_rect *r = &sel->r;
 	struct v4l2_rect *try_sel;
 
-	if (sel->pad != FIMC_SD_PAD_SINK)
+	if (sel->pad == FIMC_SD_PAD_SOURCE)
 		return -EINVAL;
 
 	mutex_lock(&fimc->lock);
@@ -1686,7 +1698,7 @@ static int fimc_subdev_set_selection(struct v4l2_subdev *sd,
 	struct v4l2_rect *try_sel;
 	unsigned long flags;
 
-	if (sel->pad != FIMC_SD_PAD_SINK)
+	if (sel->pad == FIMC_SD_PAD_SOURCE)
 		return -EINVAL;
 
 	mutex_lock(&fimc->lock);
@@ -1892,6 +1904,7 @@ int fimc_initialize_capture_subdev(struct fimc_dev *fimc)
 	snprintf(sd->name, sizeof(sd->name), "FIMC.%d", fimc->id);
 
 	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SINK_FIFO].flags = MEDIA_PAD_FL_SINK;
 	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
 	ret = media_entity_init(&sd->entity, FIMC_SD_PADS_NUM,
 				fimc->vid_cap.sd_pads, 0);
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
index c968e80..9ad72f1 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/s5p-fimc/fimc-core.c
@@ -79,6 +79,10 @@ static struct fimc_fmt fimc_formats[] = {
 		.colplanes	= 1,
 		.flags		= FMT_FLAGS_M2M_OUT | FMT_HAS_ALPHA,
 	}, {
+		.name		= "YUV 4:4:4",
+		.mbus_code	= V4L2_MBUS_FMT_YUV10_1X30,
+		.flags		= FMT_FLAGS_WRITEBACK,
+	}, {
 		.name		= "YUV 4:2:2 packed, YCbYCr",
 		.fourcc		= V4L2_PIX_FMT_YUYV,
 		.depth		= { 16 },
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.h b/drivers/media/platform/s5p-fimc/fimc-core.h
index 67e3201..d95aa66 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.h
+++ b/drivers/media/platform/s5p-fimc/fimc-core.h
@@ -165,6 +165,7 @@ struct fimc_fmt {
 #define FMT_FLAGS_M2M		(1 << 1 | 1 << 2)
 #define FMT_HAS_ALPHA		(1 << 3)
 #define FMT_FLAGS_COMPRESSED	(1 << 4)
+#define FMT_FLAGS_WRITEBACK	(1 << 5)
 };
 
 /**
@@ -306,8 +307,9 @@ struct fimc_m2m_device {
 };
 
 #define FIMC_SD_PAD_SINK	0
-#define FIMC_SD_PAD_SOURCE	1
-#define FIMC_SD_PADS_NUM	2
+#define FIMC_SD_PAD_SINK_FIFO	1
+#define FIMC_SD_PAD_SOURCE	2
+#define FIMC_SD_PADS_NUM	3
 
 /**
  * struct fimc_vid_cap - camera capture device information
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index b9f9976..d26b7bf 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -236,6 +236,11 @@ static struct v4l2_subdev *fimc_md_register_sensor(struct fimc_md *fmd,
 
 	if (!s_info || !fmd)
 		return NULL;
+	/*
+	 * If FIMC bus type is not Writeback FIFO assume it is same
+	 * as sensor_bus_type.
+	 */
+	s_info->pdata.fimc_bus_type = s_info->pdata.sensor_bus_type;
 
 	adapter = i2c_get_adapter(s_info->pdata.i2c_bus_num);
 	if (!adapter) {
diff --git a/drivers/media/platform/s5p-fimc/fimc-reg.c b/drivers/media/platform/s5p-fimc/fimc-reg.c
index 4d2fc69..fbdef48 100644
--- a/drivers/media/platform/s5p-fimc/fimc-reg.c
+++ b/drivers/media/platform/s5p-fimc/fimc-reg.c
@@ -8,6 +8,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
 */
+#define pr_fmt(fmt) "%s:%d " fmt, __func__, __LINE__
 
 #include <linux/io.h>
 #include <linux/delay.h>
@@ -631,6 +632,10 @@ int fimc_hw_set_camera_source(struct fimc_dev *fimc,
 		if (fimc_fmt_is_user_defined(f->fmt->color))
 			cfg |= FIMC_REG_CISRCFMT_ITU601_8BIT;
 		break;
+	default:
+	case FIMC_BUS_TYPE_ISP_WRITEBACK:
+		/* Anything to do here ? */
+		break;
 	}
 
 	cfg |= (f->o_width << 16) | f->o_height;
@@ -660,16 +665,17 @@ void fimc_hw_set_camera_offset(struct fimc_dev *fimc, struct fimc_frame *f)
 int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 			    struct fimc_source_info *source)
 {
-	u32 cfg, tmp;
 	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
 	u32 csis_data_alignment = 32;
+	u32 cfg, tmp;
 
 	cfg = readl(fimc->regs + FIMC_REG_CIGCTRL);
 
 	/* Select ITU B interface, disable Writeback path and test pattern. */
 	cfg &= ~(FIMC_REG_CIGCTRL_TESTPAT_MASK | FIMC_REG_CIGCTRL_SELCAM_ITU_A |
 		FIMC_REG_CIGCTRL_SELCAM_MIPI | FIMC_REG_CIGCTRL_CAMIF_SELWB |
-		FIMC_REG_CIGCTRL_SELCAM_MIPI_A | FIMC_REG_CIGCTRL_CAM_JPEG);
+		FIMC_REG_CIGCTRL_SELCAM_MIPI_A | FIMC_REG_CIGCTRL_CAM_JPEG |
+		FIMC_REG_CIGCTRL_SELWB_A);
 
 	switch (source->fimc_bus_type) {
 	case FIMC_BUS_TYPE_MIPI_CSI2:
@@ -704,6 +710,12 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 		break;
 	case FIMC_BUS_TYPE_LCD_WRITEBACK_A:
 		cfg |= FIMC_REG_CIGCTRL_CAMIF_SELWB;
+		/* fall through */
+	case FIMC_BUS_TYPE_ISP_WRITEBACK:
+		if (fimc->variant->has_isp_wb)
+			cfg |= FIMC_REG_CIGCTRL_CAMIF_SELWB;
+		else
+			WARN_ONCE(1, "ISP Writeback input is not supported\n");
 		break;
 	default:
 		v4l2_err(&vid_cap->vfd, "Invalid FIMC bus type selected: %d\n",
@@ -784,3 +796,52 @@ void fimc_deactivate_capture(struct fimc_dev *fimc)
 	fimc_hw_enable_scaler(fimc, false);
 	fimc_hw_en_lastirq(fimc, false);
 }
+
+/*
+ * TODO: Create common System Registers API for all relevant drivers
+ * Now there is are races/conflicts possible when two drivers access same
+ * register, e.g. V4L2 FIMC and DRM FIMC/FIMD.
+ */
+
+#define CAMBLK_CFG_FIFORST_ISP		(1 << 15)
+#define CAMBLK_CFG_RST_MASK_ISP		(1 << 7)
+
+/**
+ * fimc_hw_camblk_set_isp_wb() - enable selected writeback output at CAMERA_BLK
+ * @mask: mask selecting output for FIMC, b[2:0] <-> {FIMC2, FIMC1, FIMC0}
+ */
+int fimc_hw_camblk_set_isp_wb(struct fimc_dev *fimc, unsigned int mask,
+			      unsigned int enable)
+{
+	u32 camblk = readl(SYSREG_CAMERA_BLK);
+	u32 ispblk = readl(SYSREG_ISP_BLK);
+
+
+	/* FIMC3 has no ISP writeback link */
+	if (WARN_ON(fimc->id == 3))
+		return -EINVAL;
+
+	/* FIXME: we're disabling FIFO full signal for all FIMC0..2 devices */
+	camblk &= ~(0x7 << 20);
+
+	if (enable) {
+		camblk |= (mask << 20);
+		camblk &= ~CAMBLK_CFG_FIFORST_ISP;
+		writel(camblk, SYSREG_CAMERA_BLK);
+
+		usleep_range(1000, 1500);
+		camblk |= CAMBLK_CFG_FIFORST_ISP;
+		writel(camblk, SYSREG_CAMERA_BLK);
+
+		ispblk &= ~CAMBLK_CFG_RST_MASK_ISP;
+		writel(ispblk, SYSREG_ISP_BLK);
+		usleep_range(1000, 1500);
+
+		ispblk |= CAMBLK_CFG_RST_MASK_ISP;
+		writel(ispblk, SYSREG_ISP_BLK);
+	} else {
+		writel(camblk, SYSREG_CAMERA_BLK);
+	}
+
+	return 0;
+}
diff --git a/drivers/media/platform/s5p-fimc/fimc-reg.h b/drivers/media/platform/s5p-fimc/fimc-reg.h
index 1a40df6..3b53b47 100644
--- a/drivers/media/platform/s5p-fimc/fimc-reg.h
+++ b/drivers/media/platform/s5p-fimc/fimc-reg.h
@@ -52,6 +52,8 @@
 #define FIMC_REG_CIGCTRL_IRQ_CLR		(1 << 19)
 #define FIMC_REG_CIGCTRL_IRQ_ENABLE		(1 << 16)
 #define FIMC_REG_CIGCTRL_SHDW_DISABLE		(1 << 12)
+/* 0 - selects Writeback A (LCD), 1 - selects Writeback B (LCD/ISP) */
+#define FIMC_REG_CIGCTRL_SELWB_A		(1 << 10)
 #define FIMC_REG_CIGCTRL_CAM_JPEG		(1 << 8)
 #define FIMC_REG_CIGCTRL_SELCAM_MIPI_A		(1 << 7)
 #define FIMC_REG_CIGCTRL_CAMIF_SELWB		(1 << 6)
@@ -276,6 +278,12 @@
 /* Output frame buffer sequence mask */
 #define FIMC_REG_CIFCNTSEQ			0x1fc
 
+/* SYSREG for writeback */
+#include <plat/map-base.h>
+/* FIXME: make it independent of the map-base.h */
+#define SYSREG_CAMERA_BLK			(S3C_VA_SYS + 0x0218)
+#define SYSREG_ISP_BLK				(S3C_VA_SYS + 0x020c)
+
 /*
  * Function declarations
  */
@@ -309,6 +317,8 @@ void fimc_hw_activate_input_dma(struct fimc_dev *dev, bool on);
 void fimc_hw_disable_capture(struct fimc_dev *dev);
 s32 fimc_hw_get_frame_index(struct fimc_dev *dev);
 s32 fimc_hw_get_prev_frame_index(struct fimc_dev *dev);
+int fimc_hw_camblk_set_isp_wb(struct fimc_dev *fimc, unsigned int mask,
+			      unsigned int enable);
 void fimc_activate_capture(struct fimc_ctx *ctx);
 void fimc_deactivate_capture(struct fimc_dev *fimc);
 
-- 
1.7.9.5

