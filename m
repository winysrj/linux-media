Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:19599 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933719Ab2HWJwZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Aug 2012 05:52:25 -0400
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M9700EG3CQH07Z0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Aug 2012 18:52:23 +0900 (KST)
Received: from amdc248.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M9700GHMCQHII60@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Aug 2012 18:52:23 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: riverful.kim@samsung.com, sw0312.kim@samsung.com,
	sakari.ailus@iki.fi, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 4/4] s5p-fimc: Add support for V4L2_PIX_FMT_S5C_UYVY_JPG
 fourcc
Date: Thu, 23 Aug 2012 11:51:29 +0200
Message-id: <1345715489-30158-5-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1345715489-30158-1-git-send-email-s.nawrocki@samsung.com>
References: <1345715489-30158-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for the interleaved JPEG/UYVY
V4L2_PIX_FMT_S5C_UYVY_JPG image format.

To ensure the size of allocated buffers is correct for a subdev
configuration during VIDIOC_STREAMON ioctl, an additional check
is added the video at the data pipeline validation routine.

Flag FMT_FLAGS_COMPRESSED indicates the buffer size must be
retrieved from a sensor subdev, by means of V4L2_CID_FRAMESIZE
control.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-capture.c | 86 ++++++++++++++++++++------
 drivers/media/platform/s5p-fimc/fimc-core.c    | 16 ++++-
 drivers/media/platform/s5p-fimc/fimc-core.h    | 26 ++++++--
 drivers/media/platform/s5p-fimc/fimc-reg.c     |  3 +-
 drivers/media/platform/s5p-fimc/mipi-csis.c    |  6 +-
 5 files changed, 111 insertions(+), 26 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 8e413dd..ab062f3 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -349,6 +349,8 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 		unsigned int size = (wh * fmt->depth[i]) / 8;
 		if (pixm)
 			sizes[i] = max(size, pixm->plane_fmt[i].sizeimage);
+		else if (fimc_fmt_is_user_defined(fmt->color))
+			sizes[i] = frame->payload[i];
 		else
 			sizes[i] = max_t(u32, size, frame->payload[i]);
 
@@ -608,10 +610,10 @@ static struct fimc_fmt *fimc_capture_try_format(struct fimc_ctx *ctx,
 	u32 mask = FMT_FLAGS_CAM;
 	struct fimc_fmt *ffmt;
 
-	/* Color conversion from/to JPEG is not supported */
+	/* Conversion from/to JPEG or User Defined format is not supported */
 	if (code && ctx->s_frame.fmt && pad == FIMC_SD_PAD_SOURCE &&
-	    fimc_fmt_is_jpeg(ctx->s_frame.fmt->color))
-		*code = V4L2_MBUS_FMT_JPEG_1X8;
+	    fimc_fmt_is_user_defined(ctx->s_frame.fmt->color))
+		*code = ctx->s_frame.fmt->mbus_code;
 
 	if (fourcc && *fourcc != V4L2_PIX_FMT_JPEG && pad != FIMC_SD_PAD_SINK)
 		mask |= FMT_FLAGS_M2M;
@@ -625,18 +627,19 @@ static struct fimc_fmt *fimc_capture_try_format(struct fimc_ctx *ctx,
 		*fourcc = ffmt->fourcc;
 
 	if (pad == FIMC_SD_PAD_SINK) {
-		max_w = fimc_fmt_is_jpeg(ffmt->color) ?
+		max_w = fimc_fmt_is_user_defined(ffmt->color) ?
 			pl->scaler_dis_w : pl->scaler_en_w;
 		/* Apply the camera input interface pixel constraints */
 		v4l_bound_align_image(width, max_t(u32, *width, 32), max_w, 4,
 				      height, max_t(u32, *height, 32),
 				      FIMC_CAMIF_MAX_HEIGHT,
-				      fimc_fmt_is_jpeg(ffmt->color) ? 3 : 1,
+				      fimc_fmt_is_user_defined(ffmt->color) ?
+				      3 : 1,
 				      0);
 		return ffmt;
 	}
 	/* Can't scale or crop in transparent (JPEG) transfer mode */
-	if (fimc_fmt_is_jpeg(ffmt->color)) {
+	if (fimc_fmt_is_user_defined(ffmt->color)) {
 		*width  = ctx->s_frame.f_width;
 		*height = ctx->s_frame.f_height;
 		return ffmt;
@@ -681,7 +684,7 @@ static void fimc_capture_try_selection(struct fimc_ctx *ctx,
 	u32 max_sc_h, max_sc_v;
 
 	/* In JPEG transparent transfer mode cropping is not supported */
-	if (fimc_fmt_is_jpeg(ctx->d_frame.fmt->color)) {
+	if (fimc_fmt_is_user_defined(ctx->d_frame.fmt->color)) {
 		r->width  = sink->f_width;
 		r->height = sink->f_height;
 		r->left   = r->top = 0;
@@ -844,6 +847,23 @@ static int fimc_pipeline_try_format(struct fimc_ctx *ctx,
 	return 0;
 }
 
+static int get_sensor_frame_size(struct v4l2_subdev *sensor, __u32 *size)
+{
+	struct v4l2_ctrl *ctrl;
+
+	ctrl = v4l2_ctrl_find(sensor->ctrl_handler, V4L2_CID_FRAMESIZE);
+	if (ctrl == NULL)
+		return -ENXIO;
+
+	*size = v4l2_ctrl_g_ctrl(ctrl);
+
+	if (*size <= FIMC_MAX_JPEG_BUF_SIZE)
+		return 0;
+
+	v4l2_err(sensor->v4l2_dev, "Unsupported buffer size: %u\n", *size);
+	return -EINVAL;
+}
+
 static int fimc_cap_g_fmt_mplane(struct file *file, void *fh,
 				 struct v4l2_format *f)
 {
@@ -862,7 +882,7 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 	struct v4l2_mbus_framefmt mf;
 	struct fimc_fmt *ffmt = NULL;
 
-	if (pix->pixelformat == V4L2_PIX_FMT_JPEG) {
+	if (fimc_jpeg_fourcc(pix->pixelformat)) {
 		fimc_capture_try_format(ctx, &pix->width, &pix->height,
 					NULL, &pix->pixelformat,
 					FIMC_SD_PAD_SINK);
@@ -876,25 +896,32 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 		return -EINVAL;
 
 	if (!fimc->vid_cap.user_subdev_api) {
-		mf.width  = pix->width;
+		mf.width = pix->width;
 		mf.height = pix->height;
-		mf.code   = ffmt->mbus_code;
+		mf.code = ffmt->mbus_code;
 		fimc_md_graph_lock(fimc);
 		fimc_pipeline_try_format(ctx, &mf, &ffmt, false);
 		fimc_md_graph_unlock(fimc);
-
-		pix->width	 = mf.width;
-		pix->height	 = mf.height;
+		pix->width = mf.width;
+		pix->height = mf.height;
 		if (ffmt)
 			pix->pixelformat = ffmt->fourcc;
 	}
 
 	fimc_adjust_mplane_format(ffmt, pix->width, pix->height, pix);
+
+	if (ffmt->flags & FMT_FLAGS_COMPRESSED)
+		get_sensor_frame_size(fimc->pipeline.subdevs[IDX_SENSOR],
+				      &pix->plane_fmt[0].sizeimage);
+
 	return 0;
 }
 
-static void fimc_capture_mark_jpeg_xfer(struct fimc_ctx *ctx, bool jpeg)
+static void fimc_capture_mark_jpeg_xfer(struct fimc_ctx *ctx,
+					enum fimc_color_fmt color)
 {
+	bool jpeg = fimc_fmt_is_user_defined(color);
+
 	ctx->scaler.enabled = !jpeg;
 	fimc_ctrls_activate(ctx, !jpeg);
 
@@ -917,7 +944,7 @@ static int fimc_capture_set_format(struct fimc_dev *fimc, struct v4l2_format *f)
 		return -EBUSY;
 
 	/* Pre-configure format at camera interface input, for JPEG only */
-	if (pix->pixelformat == V4L2_PIX_FMT_JPEG) {
+	if (fimc_jpeg_fourcc(pix->pixelformat)) {
 		fimc_capture_try_format(ctx, &pix->width, &pix->height,
 					NULL, &pix->pixelformat,
 					FIMC_SD_PAD_SINK);
@@ -950,7 +977,15 @@ static int fimc_capture_set_format(struct fimc_dev *fimc, struct v4l2_format *f)
 	}
 
 	fimc_adjust_mplane_format(ff->fmt, pix->width, pix->height, pix);
-	for (i = 0; i < ff->fmt->colplanes; i++)
+
+	if (ff->fmt->flags & FMT_FLAGS_COMPRESSED) {
+		ret = get_sensor_frame_size(fimc->pipeline.subdevs[IDX_SENSOR],
+					    &pix->plane_fmt[0].sizeimage);
+		if (ret < 0)
+			return ret;
+	}
+
+	for (i = 0; i < ff->fmt->memplanes; i++)
 		ff->payload[i] = pix->plane_fmt[i].sizeimage;
 
 	set_frame_bounds(ff, pix->width, pix->height);
@@ -958,7 +993,7 @@ static int fimc_capture_set_format(struct fimc_dev *fimc, struct v4l2_format *f)
 	if (!(ctx->state & FIMC_COMPOSE))
 		set_frame_crop(ff, 0, 0, pix->width, pix->height);
 
-	fimc_capture_mark_jpeg_xfer(ctx, fimc_fmt_is_jpeg(ff->fmt->color));
+	fimc_capture_mark_jpeg_xfer(ctx, ff->fmt->color);
 
 	/* Reset cropping and set format at the camera interface input */
 	if (!fimc->vid_cap.user_subdev_api) {
@@ -1060,6 +1095,21 @@ static int fimc_pipeline_validate(struct fimc_dev *fimc)
 		    src_fmt.format.height != sink_fmt.format.height ||
 		    src_fmt.format.code != sink_fmt.format.code)
 			return -EPIPE;
+
+		if (sd == fimc->pipeline.subdevs[IDX_SENSOR] &&
+		    fimc_user_defined_mbus_fmt(src_fmt.format.code)) {
+			struct v4l2_plane_pix_format plane_fmt[FIMC_MAX_PLANES];
+			struct fimc_frame *frame = &vid_cap->ctx->d_frame;
+			unsigned int i;
+
+			ret = get_sensor_frame_size(sd, &plane_fmt[0].sizeimage);
+			if (ret < 0)
+				return -EPIPE;
+			for (i = 0; i < frame->fmt->memplanes; i++) {
+				if (frame->payload[i] < plane_fmt[i].sizeimage)
+					return -EPIPE;
+			}
+		}
 	}
 	return 0;
 }
@@ -1421,7 +1471,7 @@ static int fimc_subdev_set_fmt(struct v4l2_subdev *sd,
 	/* Update RGB Alpha control state and value range */
 	fimc_alpha_ctrl_update(ctx);
 
-	fimc_capture_mark_jpeg_xfer(ctx, fimc_fmt_is_jpeg(ffmt->color));
+	fimc_capture_mark_jpeg_xfer(ctx, ffmt->color);
 
 	ff = fmt->pad == FIMC_SD_PAD_SINK ?
 		&ctx->s_frame : &ctx->d_frame;
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
index 1a44540..b3249b1 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/s5p-fimc/fimc-core.c
@@ -184,7 +184,16 @@ static struct fimc_fmt fimc_formats[] = {
 		.memplanes	= 1,
 		.colplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_JPEG_1X8,
-		.flags		= FMT_FLAGS_CAM,
+		.flags		= FMT_FLAGS_CAM | FMT_FLAGS_COMPRESSED,
+	}, {
+		.name		= "S5C73MX interleaved JPEG/YUYV",
+		.fourcc		= V4L2_PIX_FMT_S5C_UYVY_JPG,
+		.color		= FIMC_FMT_UYVY_JPEG,
+		.depth		= { 8 },
+		.memplanes	= 1,
+		.colplanes	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8,
+		.flags		= FMT_FLAGS_CAM | FMT_FLAGS_COMPRESSED,
 	},
 };
 
@@ -698,6 +707,11 @@ int fimc_fill_format(struct fimc_frame *frame, struct v4l2_format *f)
 		if (frame->fmt->colplanes == 1) /* packed formats */
 			bpl = (bpl * frame->fmt->depth[0]) / 8;
 		pixm->plane_fmt[i].bytesperline = bpl;
+
+		if (frame->fmt->flags & FMT_FLAGS_COMPRESSED) {
+			pixm->plane_fmt[i].sizeimage = frame->payload[i];
+			continue;
+		}
 		pixm->plane_fmt[i].sizeimage = (frame->o_width *
 			frame->o_height * frame->fmt->depth[i]) / 8;
 	}
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.h b/drivers/media/platform/s5p-fimc/fimc-core.h
index 808ccc6..8e1a9e8 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.h
+++ b/drivers/media/platform/s5p-fimc/fimc-core.h
@@ -40,6 +40,8 @@
 #define SCALER_MAX_VRATIO	64
 #define DMA_MIN_SIZE		8
 #define FIMC_CAMIF_MAX_HEIGHT	0x2000
+#define FIMC_MAX_JPEG_BUF_SIZE	SZ_8M
+#define FIMC_MAX_PLANES		3
 
 /* indices to the clocks array */
 enum {
@@ -83,7 +85,7 @@ enum fimc_datapath {
 };
 
 enum fimc_color_fmt {
-	FIMC_FMT_RGB444 = 0x10,
+	FIMC_FMT_RGB444	= 0x10,
 	FIMC_FMT_RGB555,
 	FIMC_FMT_RGB565,
 	FIMC_FMT_RGB666,
@@ -95,14 +97,15 @@ enum fimc_color_fmt {
 	FIMC_FMT_CBYCRY422,
 	FIMC_FMT_CRYCBY422,
 	FIMC_FMT_YCBCR444_LOCAL,
-	FIMC_FMT_JPEG = 0x40,
-	FIMC_FMT_RAW8 = 0x80,
+	FIMC_FMT_RAW8 = 0x40,
 	FIMC_FMT_RAW10,
 	FIMC_FMT_RAW12,
+	FIMC_FMT_JPEG = 0x80,
+	FIMC_FMT_UYVY_JPEG = 0x100,
 };
 
+#define fimc_fmt_is_user_defined(x) (!!((x) & 0x180))
 #define fimc_fmt_is_rgb(x) (!!((x) & 0x10))
-#define fimc_fmt_is_jpeg(x) (!!((x) & 0x40))
 
 #define IS_M2M(__strt) ((__strt) == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE || \
 			__strt == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
@@ -155,6 +158,7 @@ struct fimc_fmt {
 #define FMT_FLAGS_M2M_OUT	(1 << 2)
 #define FMT_FLAGS_M2M		(1 << 1 | 1 << 2)
 #define FMT_HAS_ALPHA		(1 << 3)
+#define FMT_FLAGS_COMPRESSED	(1 << 4)
 };
 
 /**
@@ -272,7 +276,7 @@ struct fimc_frame {
 	u32	offs_v;
 	u32	width;
 	u32	height;
-	unsigned long		payload[VIDEO_MAX_PLANES];
+	unsigned int		payload[VIDEO_MAX_PLANES];
 	struct fimc_addr	paddr;
 	struct fimc_dma_offset	dma_offset;
 	struct fimc_fmt		*fmt;
@@ -576,6 +580,18 @@ static inline int tiled_fmt(struct fimc_fmt *fmt)
 	return fmt->fourcc == V4L2_PIX_FMT_NV12MT;
 }
 
+static inline bool fimc_jpeg_fourcc(u32 pixelformat)
+{
+	return (pixelformat == V4L2_PIX_FMT_JPEG ||
+		pixelformat == V4L2_PIX_FMT_S5C_UYVY_JPG);
+}
+
+static inline bool fimc_user_defined_mbus_fmt(u32 code)
+{
+	return (code == V4L2_MBUS_FMT_JPEG_1X8 ||
+		code == V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8);
+}
+
 /* Return the alpha component bit mask */
 static inline int fimc_get_alpha_mask(struct fimc_fmt *fmt)
 {
diff --git a/drivers/media/platform/s5p-fimc/fimc-reg.c b/drivers/media/platform/s5p-fimc/fimc-reg.c
index 0e3eb9c..db03152 100644
--- a/drivers/media/platform/s5p-fimc/fimc-reg.c
+++ b/drivers/media/platform/s5p-fimc/fimc-reg.c
@@ -625,7 +625,7 @@ int fimc_hw_set_camera_source(struct fimc_dev *fimc,
 				cfg |= FIMC_REG_CISRCFMT_ITU601_16BIT;
 		} /* else defaults to ITU-R BT.656 8-bit */
 	} else if (cam->bus_type == FIMC_MIPI_CSI2) {
-		if (fimc_fmt_is_jpeg(f->fmt->color))
+		if (fimc_fmt_is_user_defined(f->fmt->color))
 			cfg |= FIMC_REG_CISRCFMT_ITU601_8BIT;
 	}
 
@@ -680,6 +680,7 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 			tmp = FIMC_REG_CSIIMGFMT_YCBCR422_8BIT;
 			break;
 		case V4L2_MBUS_FMT_JPEG_1X8:
+		case V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8:
 			tmp = FIMC_REG_CSIIMGFMT_USER(1);
 			cfg |= FIMC_REG_CIGCTRL_CAM_JPEG;
 			break;
diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
index 2f73d9e..e479fe0 100644
--- a/drivers/media/platform/s5p-fimc/mipi-csis.c
+++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
@@ -145,7 +145,11 @@ static const struct csis_pix_format s5pcsis_formats[] = {
 		.code = V4L2_MBUS_FMT_JPEG_1X8,
 		.fmt_reg = S5PCSIS_CFG_FMT_USER(1),
 		.data_alignment = 32,
-	},
+	}, {
+		.code = V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8,
+		.fmt_reg = S5PCSIS_CFG_FMT_USER(1),
+		.data_alignment = 32,
+	}
 };
 
 #define s5pcsis_write(__csis, __r, __v) writel(__v, __csis->regs + __r)
-- 
1.7.11.3

