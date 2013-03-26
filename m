Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:53849 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab3CZRa1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 13:30:27 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 05/10] s5p-fimc: Add support for ISP Writeback data input
 bus type
Date: Tue, 26 Mar 2013 18:29:47 +0100
Message-id: <1364318992-20562-6-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364318992-20562-1-git-send-email-s.nawrocki@samsung.com>
References: <1364318992-20562-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A second sink pad is added to each FIMC.N subdev that will be used
to link it to the FIMC-IS-ISP subdev. Only V4L2_MBUS_FMT_YUV10_1X30
format is supported at this pad (FIMC_SD_PAD_SINK_FIFO).

The routine checking for mismatch in the image formats at sides of
the links is updated to account for the fact FIMC.X subdevs now have
sink pads at the pad indexes 0, 1 and source pad at pad index 2.

If link to FIMC.X pad 1 is activated we switch FIMC input data bus
type to the ISP Writeback. Only a single active link to FIMC.X pad 0
or 1 will be allowed at any time.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

Changes since v1:

 - Use the syscon interface for SYSREG block registers access,
 - updated fimc_validate_pipeline() function to properly walk
   whole pipeline.
---
 drivers/media/platform/s5p-fimc/Kconfig        |    1 +
 drivers/media/platform/s5p-fimc/fimc-capture.c |  177 ++++++++++++++++--------
 drivers/media/platform/s5p-fimc/fimc-core.c    |   10 ++
 drivers/media/platform/s5p-fimc/fimc-core.h    |   19 ++-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |    7 +-
 drivers/media/platform/s5p-fimc/fimc-reg.c     |   75 ++++++++--
 drivers/media/platform/s5p-fimc/fimc-reg.h     |   11 ++
 7 files changed, 221 insertions(+), 79 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/Kconfig b/drivers/media/platform/s5p-fimc/Kconfig
index c16b20d..64c1116 100644
--- a/drivers/media/platform/s5p-fimc/Kconfig
+++ b/drivers/media/platform/s5p-fimc/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_SAMSUNG_S5P_FIMC
 	bool "Samsung S5P/EXYNOS SoC camera interface driver (experimental)"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && PLAT_S5P && PM_RUNTIME
 	depends on EXPERIMENTAL
+	depends on MFD_SYSCON
 	help
 	  Say Y here to enable camera host interface devices for
 	  Samsung S5P and EXYNOS SoC series.
diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 3f3ceb2..4d79d64 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -33,26 +33,27 @@
 
 static int fimc_capture_hw_init(struct fimc_dev *fimc)
 {
+	struct fimc_source_info *si = &fimc->vid_cap.source_config;
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
-	struct fimc_pipeline *p = &fimc->pipeline;
-	struct fimc_sensor_info *sensor;
+	int ret;
 	unsigned long flags;
-	int ret = 0;
 
-	if (p->subdevs[IDX_SENSOR] == NULL || ctx == NULL)
-		return -ENXIO;
-	if (ctx->s_frame.fmt == NULL)
+	if (ctx == NULL || ctx->s_frame.fmt == NULL)
 		return -EINVAL;
 
-	sensor = v4l2_get_subdev_hostdata(p->subdevs[IDX_SENSOR]);
+	if (si->fimc_bus_type == FIMC_BUS_TYPE_ISP_WRITEBACK) {
+		ret = fimc_hw_camblk_cfg_writeback(fimc);
+		if (ret < 0)
+			return ret;
+	}
 
 	spin_lock_irqsave(&fimc->slock, flags);
 	fimc_prepare_dma_offset(ctx, &ctx->d_frame);
 	fimc_set_yuv_order(ctx);
 
-	fimc_hw_set_camera_polarity(fimc, &sensor->pdata);
-	fimc_hw_set_camera_type(fimc, &sensor->pdata);
-	fimc_hw_set_camera_source(fimc, &sensor->pdata);
+	fimc_hw_set_camera_polarity(fimc, si);
+	fimc_hw_set_camera_type(fimc, si);
+	fimc_hw_set_camera_source(fimc, si);
 	fimc_hw_set_camera_offset(fimc, &ctx->s_frame);
 
 	ret = fimc_set_scaler_info(ctx);
@@ -606,18 +607,22 @@ static struct fimc_fmt *fimc_capture_try_format(struct fimc_ctx *ctx,
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
@@ -851,7 +856,7 @@ static int fimc_pipeline_try_format(struct fimc_ctx *ctx,
 		tfmt->width  = mf->width;
 		tfmt->height = mf->height;
 		ffmt = fimc_capture_try_format(ctx, &tfmt->width, &tfmt->height,
-					NULL, &fcc, FIMC_SD_PAD_SINK);
+					NULL, &fcc, FIMC_SD_PAD_SINK_CAM);
 		ffmt = fimc_capture_try_format(ctx, &tfmt->width, &tfmt->height,
 					NULL, &fcc, FIMC_SD_PAD_SOURCE);
 		if (ffmt && ffmt->mbus_code)
@@ -938,7 +943,7 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 	if (fimc_jpeg_fourcc(pix->pixelformat)) {
 		fimc_capture_try_format(ctx, &pix->width, &pix->height,
 					NULL, &pix->pixelformat,
-					FIMC_SD_PAD_SINK);
+					FIMC_SD_PAD_SINK_CAM);
 		ctx->s_frame.f_width  = pix->width;
 		ctx->s_frame.f_height = pix->height;
 	}
@@ -992,7 +997,7 @@ static int __fimc_capture_set_format(struct fimc_dev *fimc,
 {
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
 	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
-	struct v4l2_mbus_framefmt *mf = &fimc->vid_cap.mf;
+	struct v4l2_mbus_framefmt *mf = &fimc->vid_cap.ci_fmt;
 	struct fimc_frame *ff = &ctx->d_frame;
 	struct fimc_fmt *s_fmt = NULL;
 	int ret, i;
@@ -1004,7 +1009,7 @@ static int __fimc_capture_set_format(struct fimc_dev *fimc,
 	if (fimc_jpeg_fourcc(pix->pixelformat)) {
 		fimc_capture_try_format(ctx, &pix->width, &pix->height,
 					NULL, &pix->pixelformat,
-					FIMC_SD_PAD_SINK);
+					FIMC_SD_PAD_SINK_CAM);
 		ctx->s_frame.f_width  = pix->width;
 		ctx->s_frame.f_height = pix->height;
 	}
@@ -1121,44 +1126,51 @@ static int fimc_cap_g_input(struct file *file, void *priv, unsigned int *i)
 static int fimc_pipeline_validate(struct fimc_dev *fimc)
 {
 	struct v4l2_subdev_format sink_fmt, src_fmt;
-	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
-	struct v4l2_subdev *sd;
-	struct media_pad *pad;
-	int ret;
-
-	/* Start with the video capture node pad */
-	pad = media_entity_remote_source(&vid_cap->vd_pad);
-	if (pad == NULL)
-		return -EPIPE;
-	/* FIMC.{N} subdevice */
-	sd = media_entity_to_v4l2_subdev(pad->entity);
+	struct fimc_vid_cap *vc = &fimc->vid_cap;
+	struct v4l2_subdev *sd = &vc->subdev;
+	struct media_pad *sink_pad, *src_pad;
+	int i, ret;
 
 	while (1) {
-		/* Retrieve format at the sink pad */
-		pad = &sd->entity.pads[0];
-		if (!(pad->flags & MEDIA_PAD_FL_SINK))
+		/*
+		 * Find current entity sink pad and any remote sink pad linked
+		 * to it. We stop if there is no sink pad in current entity or
+		 * it is not linked to any other remote entity.
+		 */
+		src_pad = NULL;
+
+		for (i = 0; i < sd->entity.num_pads; i++) {
+			struct media_pad *p = &sd->entity.pads[i];
+
+			if (p->flags & MEDIA_PAD_FL_SINK) {
+				sink_pad = p;
+				src_pad = media_entity_remote_source(sink_pad);
+				if (src_pad)
+					break;
+			}
+		}
+
+		if (src_pad == NULL ||
+		    media_entity_type(src_pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
 			break;
+
 		/* Don't call FIMC subdev operation to avoid nested locking */
-		if (sd == &fimc->vid_cap.subdev) {
-			struct fimc_frame *ff = &vid_cap->ctx->s_frame;
+		if (sd == &vc->subdev) {
+			struct fimc_frame *ff = &vc->ctx->s_frame;
 			sink_fmt.format.width = ff->f_width;
 			sink_fmt.format.height = ff->f_height;
 			sink_fmt.format.code = ff->fmt ? ff->fmt->mbus_code : 0;
 		} else {
-			sink_fmt.pad = pad->index;
+			sink_fmt.pad = sink_pad->index;
 			sink_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 			ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &sink_fmt);
 			if (ret < 0 && ret != -ENOIOCTLCMD)
 				return -EPIPE;
 		}
-		/* Retrieve format at the source pad */
-		pad = media_entity_remote_source(pad);
-		if (pad == NULL ||
-		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
-			break;
 
-		sd = media_entity_to_v4l2_subdev(pad->entity);
-		src_fmt.pad = pad->index;
+		/* Retrieve format at the source pad */
+		sd = media_entity_to_v4l2_subdev(src_pad->entity);
+		src_fmt.pad = src_pad->index;
 		src_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 		ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &src_fmt);
 		if (ret < 0 && ret != -ENOIOCTLCMD)
@@ -1172,7 +1184,7 @@ static int fimc_pipeline_validate(struct fimc_dev *fimc)
 		if (sd == fimc->pipeline.subdevs[IDX_SENSOR] &&
 		    fimc_user_defined_mbus_fmt(src_fmt.format.code)) {
 			struct v4l2_plane_pix_format plane_fmt[FIMC_MAX_PLANES];
-			struct fimc_frame *frame = &vid_cap->ctx->d_frame;
+			struct fimc_frame *frame = &vc->ctx->d_frame;
 			unsigned int i;
 
 			ret = fimc_get_sensor_frame_desc(sd, plane_fmt,
@@ -1196,6 +1208,8 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 	struct fimc_pipeline *p = &fimc->pipeline;
 	struct fimc_vid_cap *vc = &fimc->vid_cap;
 	struct media_entity *entity = &vc->vfd.entity;
+	struct fimc_source_info *si = NULL;
+	struct v4l2_subdev *sd;
 	int ret;
 
 	if (fimc_capture_active(fimc))
@@ -1205,6 +1219,23 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 	if (ret < 0)
 		return ret;
 
+	sd = p->subdevs[IDX_SENSOR];
+	if (sd)
+		si = v4l2_get_subdev_hostdata(sd);
+
+	if (si == NULL) {
+		ret = -EPIPE;
+		goto err_p_stop;
+	}
+	/*
+	 * Save configuration data related to currently attached image
+	 * sensor or other data source, e.g. FIMC-IS.
+	 */
+	vc->source_config = *si;
+
+	if (vc->input == GRP_ID_FIMC_IS)
+		vc->source_config.fimc_bus_type = FIMC_BUS_TYPE_ISP_WRITEBACK;
+
 	if (vc->user_subdev_api) {
 		ret = fimc_pipeline_validate(fimc);
 		if (ret < 0)
@@ -1461,25 +1492,37 @@ static int fimc_subdev_get_fmt(struct v4l2_subdev *sd,
 {
 	struct fimc_dev *fimc = v4l2_get_subdevdata(sd);
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
+	struct fimc_frame *ff = &ctx->s_frame;
 	struct v4l2_mbus_framefmt *mf;
-	struct fimc_frame *ff;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
 		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
 		fmt->format = *mf;
 		return 0;
 	}
-	mf = &fmt->format;
-	mf->colorspace = V4L2_COLORSPACE_JPEG;
-	ff = fmt->pad == FIMC_SD_PAD_SINK ? &ctx->s_frame : &ctx->d_frame;
 
+	mf = &fmt->format;
 	mutex_lock(&fimc->lock);
-	/* The pixel code is same on both input and output pad */
-	if (!WARN_ON(ctx->s_frame.fmt == NULL))
-		mf->code = ctx->s_frame.fmt->mbus_code;
-	mf->width  = ff->f_width;
-	mf->height = ff->f_height;
+
+	switch (fmt->pad) {
+	case FIMC_SD_PAD_SOURCE:
+		if (!WARN_ON(ff->fmt == NULL))
+			mf->code = ff->fmt->mbus_code;
+		/* Sink pads crop rectangle size */
+		mf->width = ff->width;
+		mf->height = ff->height;
+		break;
+	case FIMC_SD_PAD_SINK_FIFO:
+		*mf = fimc->vid_cap.wb_fmt;
+		break;
+	case FIMC_SD_PAD_SINK_CAM:
+	default:
+		*mf = fimc->vid_cap.ci_fmt;
+		break;
+	}
+
 	mutex_unlock(&fimc->lock);
+	mf->colorspace = V4L2_COLORSPACE_JPEG;
 
 	return 0;
 }
@@ -1490,15 +1533,15 @@ static int fimc_subdev_set_fmt(struct v4l2_subdev *sd,
 {
 	struct fimc_dev *fimc = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *mf = &fmt->format;
-	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
+	struct fimc_vid_cap *vc = &fimc->vid_cap;
+	struct fimc_ctx *ctx = vc->ctx;
 	struct fimc_frame *ff;
 	struct fimc_fmt *ffmt;
 
 	dbg("pad%d: code: 0x%x, %dx%d",
 	    fmt->pad, mf->code, mf->width, mf->height);
 
-	if (fmt->pad == FIMC_SD_PAD_SOURCE &&
-	    vb2_is_busy(&fimc->vid_cap.vbq))
+	if (fmt->pad == FIMC_SD_PAD_SOURCE && vb2_is_busy(&vc->vbq))
 		return -EBUSY;
 
 	mutex_lock(&fimc->lock);
@@ -1520,21 +1563,32 @@ static int fimc_subdev_set_fmt(struct v4l2_subdev *sd,
 	fimc_alpha_ctrl_update(ctx);
 
 	fimc_capture_mark_jpeg_xfer(ctx, ffmt->color);
-
-	ff = fmt->pad == FIMC_SD_PAD_SINK ?
-		&ctx->s_frame : &ctx->d_frame;
+	if (fmt->pad == FIMC_SD_PAD_SOURCE) {
+		ff = &ctx->d_frame;
+		/* Sink pads crop rectangle size */
+		mf->width = ctx->s_frame.width;
+		mf->height = ctx->s_frame.height;
+	} else {
+		ff = &ctx->s_frame;
+	}
 
 	mutex_lock(&fimc->lock);
 	set_frame_bounds(ff, mf->width, mf->height);
-	fimc->vid_cap.mf = *mf;
+
+	if (fmt->pad == FIMC_SD_PAD_SINK_FIFO)
+		vc->wb_fmt = *mf;
+	else if (fmt->pad == FIMC_SD_PAD_SINK_CAM)
+		vc->ci_fmt = *mf;
+
 	ff->fmt = ffmt;
 
 	/* Reset the crop rectangle if required. */
 	if (!(fmt->pad == FIMC_SD_PAD_SOURCE && (ctx->state & FIMC_COMPOSE)))
 		set_frame_crop(ff, 0, 0, mf->width, mf->height);
 
-	if (fmt->pad == FIMC_SD_PAD_SINK)
+	if (fmt->pad != FIMC_SD_PAD_SOURCE)
 		ctx->state &= ~FIMC_COMPOSE;
+
 	mutex_unlock(&fimc->lock);
 	return 0;
 }
@@ -1549,7 +1603,7 @@ static int fimc_subdev_get_selection(struct v4l2_subdev *sd,
 	struct v4l2_rect *r = &sel->r;
 	struct v4l2_rect *try_sel;
 
-	if (sel->pad != FIMC_SD_PAD_SINK)
+	if (sel->pad == FIMC_SD_PAD_SOURCE)
 		return -EINVAL;
 
 	mutex_lock(&fimc->lock);
@@ -1605,7 +1659,7 @@ static int fimc_subdev_set_selection(struct v4l2_subdev *sd,
 	struct v4l2_rect *try_sel;
 	unsigned long flags;
 
-	if (sel->pad != FIMC_SD_PAD_SINK)
+	if (sel->pad == FIMC_SD_PAD_SOURCE)
 		return -EINVAL;
 
 	mutex_lock(&fimc->lock);
@@ -1809,7 +1863,8 @@ int fimc_initialize_capture_subdev(struct fimc_dev *fimc)
 	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
 	snprintf(sd->name, sizeof(sd->name), "FIMC.%d", fimc->id);
 
-	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SINK_CAM].flags = MEDIA_PAD_FL_SINK;
+	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SINK_FIFO].flags = MEDIA_PAD_FL_SINK;
 	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
 	ret = media_entity_init(&sd->entity, FIMC_SD_PADS_NUM,
 				fimc->vid_cap.sd_pads, 0);
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
index 6a8098c..1edd3aa 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/s5p-fimc/fimc-core.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/list.h>
+#include <linux/mfd/syscon.h>
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -79,6 +80,10 @@ static struct fimc_fmt fimc_formats[] = {
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
@@ -959,6 +964,11 @@ static int fimc_probe(struct platform_device *pdev)
 	spin_lock_init(&fimc->slock);
 	mutex_init(&fimc->lock);
 
+	fimc->sysreg = syscon_regmap_lookup_by_phandle(dev->of_node,
+						"samsung,sysreg");
+	if (IS_ERR(fimc->sysreg))
+		return PTR_ERR(fimc->sysreg);
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	fimc->regs = devm_ioremap_resource(dev, res);
 	if (IS_ERR(fimc->regs))
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.h b/drivers/media/platform/s5p-fimc/fimc-core.h
index 145b8cc..6355b33 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.h
+++ b/drivers/media/platform/s5p-fimc/fimc-core.h
@@ -12,6 +12,7 @@
 /*#define DEBUG*/
 
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
@@ -163,6 +164,7 @@ struct fimc_fmt {
 #define FMT_FLAGS_M2M		(1 << 1 | 1 << 2)
 #define FMT_HAS_ALPHA		(1 << 3)
 #define FMT_FLAGS_COMPRESSED	(1 << 4)
+#define FMT_FLAGS_WRITEBACK	(1 << 5)
 };
 
 /**
@@ -303,9 +305,10 @@ struct fimc_m2m_device {
 	int			refcnt;
 };
 
-#define FIMC_SD_PAD_SINK	0
-#define FIMC_SD_PAD_SOURCE	1
-#define FIMC_SD_PADS_NUM	2
+#define FIMC_SD_PAD_SINK_CAM	0
+#define FIMC_SD_PAD_SINK_FIFO	1
+#define FIMC_SD_PAD_SOURCE	2
+#define FIMC_SD_PADS_NUM	3
 
 /**
  * struct fimc_vid_cap - camera capture device information
@@ -314,7 +317,9 @@ struct fimc_m2m_device {
  * @subdev: subdev exposing the FIMC processing block
  * @vd_pad: fimc video capture node pad
  * @sd_pads: fimc video processing block pads
- * @mf: media bus format at the FIMC camera input (and the scaler output) pad
+ * @ci_fmt: image format at the FIMC camera input (and the scaler output)
+ * @wb_fmt: image format at the FIMC ISP Writeback input
+ * @source_config: external image source related configuration structure
  * @pending_buf_q: the pending buffer queue head
  * @active_buf_q: the queue head of buffers scheduled in hardware
  * @vbq: the capture am video buffer queue
@@ -333,8 +338,10 @@ struct fimc_vid_cap {
 	struct video_device		vfd;
 	struct v4l2_subdev		subdev;
 	struct media_pad		vd_pad;
-	struct v4l2_mbus_framefmt	mf;
 	struct media_pad		sd_pads[FIMC_SD_PADS_NUM];
+	struct v4l2_mbus_framefmt	ci_fmt;
+	struct v4l2_mbus_framefmt	wb_fmt;
+	struct fimc_source_info		source_config;
 	struct list_head		pending_buf_q;
 	struct list_head		active_buf_q;
 	struct vb2_queue		vbq;
@@ -426,6 +433,7 @@ struct fimc_ctx;
  * @lock:	the mutex protecting this data structure
  * @pdev:	pointer to the FIMC platform device
  * @pdata:	pointer to the device platform data
+ * @sysreg:	pointer to the SYSREG regmap
  * @variant:	the IP variant information
  * @id:		FIMC device index (0..FIMC_MAX_DEVS)
  * @clock:	clocks required for FIMC operation
@@ -443,6 +451,7 @@ struct fimc_dev {
 	struct mutex			lock;
 	struct platform_device		*pdev;
 	struct s5p_platform_fimc	*pdata;
+	struct regmap			*sysreg;
 	const struct fimc_variant	*variant;
 	const struct fimc_drvdata	*drv_data;
 	u16				id;
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index c5bc0d1..5b11e39 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -267,6 +267,11 @@ static struct v4l2_subdev *fimc_md_register_sensor(struct fimc_md *fmd,
 
 	if (!s_info || !fmd)
 		return NULL;
+	/*
+	 * If FIMC bus type is not Writeback FIFO assume it is same
+	 * as sensor_bus_type.
+	 */
+	s_info->pdata.fimc_bus_type = s_info->pdata.sensor_bus_type;
 
 	adapter = i2c_get_adapter(s_info->pdata.i2c_bus_num);
 	if (!adapter) {
@@ -805,7 +810,7 @@ static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
 
 		sink = &fmd->fimc[i]->vid_cap.subdev.entity;
 		ret = media_entity_create_link(source, pad, sink,
-					      FIMC_SD_PAD_SINK, flags);
+					      FIMC_SD_PAD_SINK_CAM, flags);
 		if (ret)
 			return ret;
 
diff --git a/drivers/media/platform/s5p-fimc/fimc-reg.c b/drivers/media/platform/s5p-fimc/fimc-reg.c
index 4d2fc69..ee88b94 100644
--- a/drivers/media/platform/s5p-fimc/fimc-reg.c
+++ b/drivers/media/platform/s5p-fimc/fimc-reg.c
@@ -1,22 +1,24 @@
 /*
  * Register interface file for Samsung Camera Interface (FIMC) driver
  *
- * Copyright (C) 2010 - 2012 Samsung Electronics Co., Ltd.
- * Sylwester Nawrocki, <s.nawrocki@samsung.com>
+ * Copyright (C) 2010 - 2013 Samsung Electronics Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
 */
 
-#include <linux/io.h>
 #include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/regmap.h>
+
 #include <media/s5p_fimc.h>
+#include "fimc-mdevice.h"
 
 #include "fimc-reg.h"
 #include "fimc-core.h"
 
-
 void fimc_hw_reset(struct fimc_dev *dev)
 {
 	u32 cfg;
@@ -598,7 +600,8 @@ static const struct mbus_pixfmt_desc pix_desc[] = {
 int fimc_hw_set_camera_source(struct fimc_dev *fimc,
 			      struct fimc_source_info *source)
 {
-	struct fimc_frame *f = &fimc->vid_cap.ctx->s_frame;
+	struct fimc_vid_cap *vc = &fimc->vid_cap;
+	struct fimc_frame *f = &vc->ctx->s_frame;
 	u32 bus_width, cfg = 0;
 	int i;
 
@@ -606,7 +609,7 @@ int fimc_hw_set_camera_source(struct fimc_dev *fimc,
 	case FIMC_BUS_TYPE_ITU_601:
 	case FIMC_BUS_TYPE_ITU_656:
 		for (i = 0; i < ARRAY_SIZE(pix_desc); i++) {
-			if (fimc->vid_cap.mf.code == pix_desc[i].pixelcode) {
+			if (vc->ci_fmt.code == pix_desc[i].pixelcode) {
 				cfg = pix_desc[i].cisrcfmt;
 				bus_width = pix_desc[i].bus_width;
 				break;
@@ -614,9 +617,9 @@ int fimc_hw_set_camera_source(struct fimc_dev *fimc,
 		}
 
 		if (i == ARRAY_SIZE(pix_desc)) {
-			v4l2_err(&fimc->vid_cap.vfd,
+			v4l2_err(&vc->vfd,
 				 "Camera color format not supported: %d\n",
-				 fimc->vid_cap.mf.code);
+				 vc->ci_fmt.code);
 			return -EINVAL;
 		}
 
@@ -631,6 +634,10 @@ int fimc_hw_set_camera_source(struct fimc_dev *fimc,
 		if (fimc_fmt_is_user_defined(f->fmt->color))
 			cfg |= FIMC_REG_CISRCFMT_ITU601_8BIT;
 		break;
+	default:
+	case FIMC_BUS_TYPE_ISP_WRITEBACK:
+		/* Anything to do here ? */
+		break;
 	}
 
 	cfg |= (f->o_width << 16) | f->o_height;
@@ -660,16 +667,17 @@ void fimc_hw_set_camera_offset(struct fimc_dev *fimc, struct fimc_frame *f)
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
@@ -679,7 +687,7 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 			cfg |= FIMC_REG_CIGCTRL_SELCAM_MIPI_A;
 
 		/* TODO: add remaining supported formats. */
-		switch (vid_cap->mf.code) {
+		switch (vid_cap->ci_fmt.code) {
 		case V4L2_MBUS_FMT_VYUY8_2X8:
 			tmp = FIMC_REG_CSIIMGFMT_YCBCR422_8BIT;
 			break;
@@ -691,7 +699,7 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 		default:
 			v4l2_err(&vid_cap->vfd,
 				 "Not supported camera pixel format: %#x\n",
-				 vid_cap->mf.code);
+				 vid_cap->ci_fmt.code);
 			return -EINVAL;
 		}
 		tmp |= (csis_data_alignment == 32) << 8;
@@ -704,6 +712,12 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
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
@@ -784,3 +798,40 @@ void fimc_deactivate_capture(struct fimc_dev *fimc)
 	fimc_hw_enable_scaler(fimc, false);
 	fimc_hw_en_lastirq(fimc, false);
 }
+
+int fimc_hw_camblk_cfg_writeback(struct fimc_dev *fimc)
+{
+	struct regmap *map = fimc->sysreg;
+	unsigned int mask, val, camblk_cfg;
+	int ret;
+
+	ret = regmap_read(map, SYSREG_CAMBLK, &camblk_cfg);
+	if (ret < 0 || ((camblk_cfg & 0x00700000) >> 20 != 0x3))
+		return ret;
+
+	if (!WARN(fimc->id >= 3, "not supported id: %d\n", fimc->id))
+		val = 0x1 << (fimc->id + 20);
+	else
+		val = 0;
+
+	mask = SYSREG_CAMBLK_FIFORST_ISP | SYSREG_CAMBLK_ISPWB_FULL_EN;
+	ret = regmap_update_bits(map, SYSREG_CAMBLK, mask, val);
+	if (ret < 0)
+		return ret;
+
+	usleep_range(1000, 2000);
+
+	val |= SYSREG_CAMBLK_FIFORST_ISP;
+	ret = regmap_update_bits(map, SYSREG_CAMBLK, mask, val);
+	if (ret < 0)
+		return ret;
+
+	mask = SYSREG_ISPBLK_FIFORST_CAM_BLK;
+	ret = regmap_update_bits(map, SYSREG_ISPBLK, mask, ~mask);
+	if (ret < 0)
+		return ret;
+
+	usleep_range(1000, 2000);
+
+	return regmap_update_bits(map, SYSREG_ISPBLK, mask, mask);
+}
diff --git a/drivers/media/platform/s5p-fimc/fimc-reg.h b/drivers/media/platform/s5p-fimc/fimc-reg.h
index 1a40df6..01da7f3 100644
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
@@ -276,6 +278,14 @@
 /* Output frame buffer sequence mask */
 #define FIMC_REG_CIFCNTSEQ			0x1fc
 
+/* SYSREG ISP Writeback register address offsets */
+#define SYSREG_ISPBLK				0x020c
+#define SYSREG_ISPBLK_FIFORST_CAM_BLK		(1 << 7)
+
+#define SYSREG_CAMBLK				0x0218
+#define SYSREG_CAMBLK_FIFORST_ISP		(1 << 15)
+#define SYSREG_CAMBLK_ISPWB_FULL_EN		(7 << 20)
+
 /*
  * Function declarations
  */
@@ -309,6 +319,7 @@ void fimc_hw_activate_input_dma(struct fimc_dev *dev, bool on);
 void fimc_hw_disable_capture(struct fimc_dev *dev);
 s32 fimc_hw_get_frame_index(struct fimc_dev *dev);
 s32 fimc_hw_get_prev_frame_index(struct fimc_dev *dev);
+int fimc_hw_camblk_cfg_writeback(struct fimc_dev *fimc);
 void fimc_activate_capture(struct fimc_ctx *ctx);
 void fimc_deactivate_capture(struct fimc_dev *fimc);
 
-- 
1.7.9.5

