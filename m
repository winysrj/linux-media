Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:19436 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905Ab2IZPyv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 11:54:51 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAY00FPNS65AZJ0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 27 Sep 2012 00:54:50 +0900 (KST)
Received: from amdc248.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MAY000JLS6LTOA0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 27 Sep 2012 00:54:49 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, sakari.ailus@iki.fi,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v3 4/5] s5p-fimc: Add support for V4L2_PIX_FMT_S5C_UYVY_JPG
 fourcc
Date: Wed, 26 Sep 2012 17:54:12 +0200
Message-id: <1348674853-24596-5-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1348674853-24596-1-git-send-email-s.nawrocki@samsung.com>
References: <1348674853-24596-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_PIX_FMT_S5C_YUYV_JPG image formats consists of 2 planes, the
first containing interleaved JPEG/YUYV data and the second containing
meta data describing the interleaving method.

The image data is transferred with MIPI-CSI "User Defined Byte-Based
Data 1" type and is captured to memory by FIMC DMA engine.

The meta data is transferred using MIPI-CSI2 "Embedded 8-bit non Image
Data" and it is captured in the MIPI-CSI slave device and copied to
the bridge provided buffer.

To make sure the size of allocated buffers is correct for the subdevs
configuration when VIDIOC_STREAMON ioctl is invoked, an additional
check is added at the video pipeline validation function.

Flag FMT_FLAGS_COMPRESSED indicates the buffer size must be retrieved
from a sensor subdev.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-capture.c | 135 +++++++++++++++++++++----
 drivers/media/platform/s5p-fimc/fimc-core.c    |  19 +++-
 drivers/media/platform/s5p-fimc/fimc-core.h    |  28 ++++-
 drivers/media/platform/s5p-fimc/fimc-reg.c     |  23 ++++-
 drivers/media/platform/s5p-fimc/fimc-reg.h     |   3 +-
 drivers/media/platform/s5p-fimc/mipi-csis.c    |   8 +-
 6 files changed, 183 insertions(+), 33 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 8a0908b..304b6fd 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -177,7 +177,9 @@ static int fimc_capture_config_update(struct fimc_ctx *ctx)
 
 void fimc_capture_irq_handler(struct fimc_dev *fimc, int deq_buf)
 {
+	struct v4l2_subdev *csis = fimc->pipeline.subdevs[IDX_CSIS];
 	struct fimc_vid_cap *cap = &fimc->vid_cap;
+	struct fimc_frame *f = &cap->ctx->d_frame;
 	struct fimc_vid_buffer *v_buf;
 	struct timeval *tv;
 	struct timespec ts;
@@ -216,6 +218,25 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc, int deq_buf)
 		if (++cap->buf_index >= FIMC_MAX_OUT_BUFS)
 			cap->buf_index = 0;
 	}
+	/*
+	 * Set up a buffer at MIPI-CSIS if current image format
+	 * requires the frame embedded data capture.
+	 */
+	if (f->fmt->mdataplanes && !list_empty(&cap->active_buf_q)) {
+		unsigned int plane = ffs(f->fmt->mdataplanes) - 1;
+		unsigned int size = f->payload[plane];
+		s32 index = fimc_hw_get_frame_index(fimc);
+		void *vaddr;
+
+		list_for_each_entry(v_buf, &cap->active_buf_q, list) {
+			if (v_buf->index != index)
+				continue;
+			vaddr = vb2_plane_vaddr(&v_buf->vb, plane);
+			v4l2_subdev_call(csis, video, s_rx_buffer,
+					 vaddr, &size);
+			break;
+		}
+	}
 
 	if (cap->active_buf_cnt == 0) {
 		if (deq_buf)
@@ -351,6 +372,8 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 		unsigned int size = (wh * fmt->depth[i]) / 8;
 		if (pixm)
 			sizes[i] = max(size, pixm->plane_fmt[i].sizeimage);
+		else if (fimc_fmt_is_user_defined(fmt->color))
+			sizes[i] = frame->payload[i];
 		else
 			sizes[i] = max_t(u32, size, frame->payload[i]);
 
@@ -611,10 +634,10 @@ static struct fimc_fmt *fimc_capture_try_format(struct fimc_ctx *ctx,
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
@@ -628,18 +651,19 @@ static struct fimc_fmt *fimc_capture_try_format(struct fimc_ctx *ctx,
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
@@ -684,7 +708,7 @@ static void fimc_capture_try_selection(struct fimc_ctx *ctx,
 	u32 max_sc_h, max_sc_v;
 
 	/* In JPEG transparent transfer mode cropping is not supported */
-	if (fimc_fmt_is_jpeg(ctx->d_frame.fmt->color)) {
+	if (fimc_fmt_is_user_defined(ctx->d_frame.fmt->color)) {
 		r->width  = sink->f_width;
 		r->height = sink->f_height;
 		r->left   = r->top = 0;
@@ -847,6 +871,48 @@ static int fimc_pipeline_try_format(struct fimc_ctx *ctx,
 	return 0;
 }
 
+/**
+ * fimc_get_sensor_frame_desc - query the sensor for media bus frame parameters
+ * @sensor: pointer to the sensor subdev
+ * @plane_fmt: provides plane sizes corresponding to the frame layout entries
+ * @try: true to set the frame parameters, false to query only
+ *
+ * This function is used by this driver only for compressed/blob data formats.
+ */
+static int fimc_get_sensor_frame_desc(struct v4l2_subdev *sensor,
+				      struct v4l2_plane_pix_format *plane_fmt,
+				      unsigned int num_planes, bool try)
+{
+	struct v4l2_mbus_frame_desc fd;
+	int i, ret;
+
+	for (i = 0; i < num_planes; i++)
+		fd.entry[i].length = plane_fmt[i].sizeimage;
+
+	if (try)
+		ret = v4l2_subdev_call(sensor, pad, set_frame_desc, 0, &fd);
+	else
+		ret = v4l2_subdev_call(sensor, pad, get_frame_desc, 0, &fd);
+
+	if (ret < 0)
+		return ret;
+
+	if (num_planes != fd.num_entries)
+		return -EINVAL;
+
+	for (i = 0; i < num_planes; i++)
+		plane_fmt[i].sizeimage = fd.entry[i].length;
+
+	if (fd.entry[0].length > FIMC_MAX_JPEG_BUF_SIZE) {
+		v4l2_err(sensor->v4l2_dev,  "Unsupported buffer size: %u\n",
+			 fd.entry[0].length);
+
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int fimc_cap_g_fmt_mplane(struct file *file, void *fh,
 				 struct v4l2_format *f)
 {
@@ -865,7 +931,7 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 	struct v4l2_mbus_framefmt mf;
 	struct fimc_fmt *ffmt = NULL;
 
-	if (pix->pixelformat == V4L2_PIX_FMT_JPEG) {
+	if (fimc_jpeg_fourcc(pix->pixelformat)) {
 		fimc_capture_try_format(ctx, &pix->width, &pix->height,
 					NULL, &pix->pixelformat,
 					FIMC_SD_PAD_SINK);
@@ -879,25 +945,32 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
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
+		fimc_get_sensor_frame_desc(fimc->pipeline.subdevs[IDX_SENSOR],
+					pix->plane_fmt, ffmt->memplanes, true);
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
 
@@ -920,7 +993,7 @@ static int fimc_capture_set_format(struct fimc_dev *fimc, struct v4l2_format *f)
 		return -EBUSY;
 
 	/* Pre-configure format at camera interface input, for JPEG only */
-	if (pix->pixelformat == V4L2_PIX_FMT_JPEG) {
+	if (fimc_jpeg_fourcc(pix->pixelformat)) {
 		fimc_capture_try_format(ctx, &pix->width, &pix->height,
 					NULL, &pix->pixelformat,
 					FIMC_SD_PAD_SINK);
@@ -953,7 +1026,16 @@ static int fimc_capture_set_format(struct fimc_dev *fimc, struct v4l2_format *f)
 	}
 
 	fimc_adjust_mplane_format(ff->fmt, pix->width, pix->height, pix);
-	for (i = 0; i < ff->fmt->colplanes; i++)
+
+	if (ff->fmt->flags & FMT_FLAGS_COMPRESSED) {
+		ret = fimc_get_sensor_frame_desc(fimc->pipeline.subdevs[IDX_SENSOR],
+					pix->plane_fmt, ff->fmt->memplanes,
+					true);
+		if (ret < 0)
+			return ret;
+	}
+
+	for (i = 0; i < ff->fmt->memplanes; i++)
 		ff->payload[i] = pix->plane_fmt[i].sizeimage;
 
 	set_frame_bounds(ff, pix->width, pix->height);
@@ -961,7 +1043,7 @@ static int fimc_capture_set_format(struct fimc_dev *fimc, struct v4l2_format *f)
 	if (!(ctx->state & FIMC_COMPOSE))
 		set_frame_crop(ff, 0, 0, pix->width, pix->height);
 
-	fimc_capture_mark_jpeg_xfer(ctx, fimc_fmt_is_jpeg(ff->fmt->color));
+	fimc_capture_mark_jpeg_xfer(ctx, ff->fmt->color);
 
 	/* Reset cropping and set format at the camera interface input */
 	if (!fimc->vid_cap.user_subdev_api) {
@@ -1063,6 +1145,23 @@ static int fimc_pipeline_validate(struct fimc_dev *fimc)
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
+			ret = fimc_get_sensor_frame_desc(sd, plane_fmt,
+							 frame->fmt->memplanes,
+							 false);
+			if (ret < 0)
+				return -EPIPE;
+
+			for (i = 0; i < frame->fmt->memplanes; i++)
+				if (frame->payload[i] < plane_fmt[i].sizeimage)
+					return -EPIPE;
+		}
 	}
 	return 0;
 }
@@ -1433,7 +1532,7 @@ static int fimc_subdev_set_fmt(struct v4l2_subdev *sd,
 	/* Update RGB Alpha control state and value range */
 	fimc_alpha_ctrl_update(ctx);
 
-	fimc_capture_mark_jpeg_xfer(ctx, fimc_fmt_is_jpeg(ffmt->color));
+	fimc_capture_mark_jpeg_xfer(ctx, ffmt->color);
 
 	ff = fmt->pad == FIMC_SD_PAD_SINK ?
 		&ctx->s_frame : &ctx->d_frame;
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
index 93be260..b5e3a74 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/s5p-fimc/fimc-core.c
@@ -184,7 +184,17 @@ static struct fimc_fmt fimc_formats[] = {
 		.memplanes	= 1,
 		.colplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_JPEG_1X8,
-		.flags		= FMT_FLAGS_CAM,
+		.flags		= FMT_FLAGS_CAM | FMT_FLAGS_COMPRESSED,
+	}, {
+		.name		= "S5C73MX interleaved UYVY/JPEG",
+		.fourcc		= V4L2_PIX_FMT_S5C_UYVY_JPG,
+		.color		= FIMC_FMT_YUYV_JPEG,
+		.depth		= { 8 },
+		.memplanes	= 2,
+		.colplanes	= 1,
+		.mdataplanes	= 0x2, /* plane 1 holds frame meta data */
+		.mbus_code	= V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8,
+		.flags		= FMT_FLAGS_CAM | FMT_FLAGS_COMPRESSED,
 	},
 };
 
@@ -371,7 +381,7 @@ int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 		default:
 			return -EINVAL;
 		}
-	} else {
+	} else if (!frame->fmt->mdataplanes) {
 		if (frame->fmt->memplanes >= 2)
 			paddr->cb = vb2_dma_contig_plane_dma_addr(vb, 1);
 
@@ -698,6 +708,11 @@ int fimc_fill_format(struct fimc_frame *frame, struct v4l2_format *f)
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
index cd716ba..c0040d7 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.h
+++ b/drivers/media/platform/s5p-fimc/fimc-core.h
@@ -40,6 +40,8 @@
 #define SCALER_MAX_VRATIO	64
 #define DMA_MIN_SIZE		8
 #define FIMC_CAMIF_MAX_HEIGHT	0x2000
+#define FIMC_MAX_JPEG_BUF_SIZE	(10 * SZ_1M)
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
+	FIMC_FMT_YUYV_JPEG = 0x100,
 };
 
+#define fimc_fmt_is_user_defined(x) (!!((x) & 0x180))
 #define fimc_fmt_is_rgb(x) (!!((x) & 0x10))
-#define fimc_fmt_is_jpeg(x) (!!((x) & 0x40))
 
 #define IS_M2M(__strt) ((__strt) == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE || \
 			__strt == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
@@ -139,6 +142,7 @@ enum fimc_color_fmt {
  * @memplanes: number of physically non-contiguous data planes
  * @colplanes: number of physically contiguous data planes
  * @depth: per plane driver's private 'number of bits per pixel'
+ * @mdataplanes: bitmask indicating meta data plane(s), (1 << plane_no)
  * @flags: flags indicating which operation mode format applies to
  */
 struct fimc_fmt {
@@ -149,12 +153,14 @@ struct fimc_fmt {
 	u16	memplanes;
 	u16	colplanes;
 	u8	depth[VIDEO_MAX_PLANES];
+	u16	mdataplanes;
 	u16	flags;
 #define FMT_FLAGS_CAM		(1 << 0)
 #define FMT_FLAGS_M2M_IN	(1 << 1)
 #define FMT_FLAGS_M2M_OUT	(1 << 2)
 #define FMT_FLAGS_M2M		(1 << 1 | 1 << 2)
 #define FMT_HAS_ALPHA		(1 << 3)
+#define FMT_FLAGS_COMPRESSED	(1 << 4)
 };
 
 /**
@@ -272,7 +278,7 @@ struct fimc_frame {
 	u32	offs_v;
 	u32	width;
 	u32	height;
-	unsigned long		payload[VIDEO_MAX_PLANES];
+	unsigned int		payload[VIDEO_MAX_PLANES];
 	struct fimc_addr	paddr;
 	struct fimc_dma_offset	dma_offset;
 	struct fimc_fmt		*fmt;
@@ -577,6 +583,18 @@ static inline int tiled_fmt(struct fimc_fmt *fmt)
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
index 783408f..2c9d0c0 100644
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
@@ -744,13 +745,13 @@ void fimc_hw_dis_capture(struct fimc_dev *dev)
 }
 
 /* Return an index to the buffer actually being written. */
-u32 fimc_hw_get_frame_index(struct fimc_dev *dev)
+s32 fimc_hw_get_frame_index(struct fimc_dev *dev)
 {
-	u32 reg;
+	s32 reg;
 
 	if (dev->variant->has_cistatus2) {
-		reg = readl(dev->regs + FIMC_REG_CISTATUS2) & 0x3F;
-		return reg > 0 ? --reg : reg;
+		reg = readl(dev->regs + FIMC_REG_CISTATUS2) & 0x3f;
+		return reg - 1;
 	}
 
 	reg = readl(dev->regs + FIMC_REG_CISTATUS);
@@ -759,6 +760,18 @@ u32 fimc_hw_get_frame_index(struct fimc_dev *dev)
 		FIMC_REG_CISTATUS_FRAMECNT_SHIFT;
 }
 
+/* Return an index to the buffer being written previously. */
+s32 fimc_hw_get_prev_frame_index(struct fimc_dev *dev)
+{
+	s32 reg;
+
+	if (!dev->variant->has_cistatus2)
+		return -1;
+
+	reg = readl(dev->regs + FIMC_REG_CISTATUS2);
+	return ((reg >> 7) & 0x3f) - 1;
+}
+
 /* Locking: the caller holds fimc->slock */
 void fimc_activate_capture(struct fimc_ctx *ctx)
 {
diff --git a/drivers/media/platform/s5p-fimc/fimc-reg.h b/drivers/media/platform/s5p-fimc/fimc-reg.h
index 579ac8a..b6abfc7 100644
--- a/drivers/media/platform/s5p-fimc/fimc-reg.h
+++ b/drivers/media/platform/s5p-fimc/fimc-reg.h
@@ -307,7 +307,8 @@ void fimc_hw_clear_irq(struct fimc_dev *dev);
 void fimc_hw_enable_scaler(struct fimc_dev *dev, bool on);
 void fimc_hw_activate_input_dma(struct fimc_dev *dev, bool on);
 void fimc_hw_dis_capture(struct fimc_dev *dev);
-u32 fimc_hw_get_frame_index(struct fimc_dev *dev);
+s32 fimc_hw_get_frame_index(struct fimc_dev *dev);
+s32 fimc_hw_get_prev_frame_index(struct fimc_dev *dev);
 void fimc_activate_capture(struct fimc_ctx *ctx);
 void fimc_deactivate_capture(struct fimc_dev *fimc);
 
diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
index 306410f..384a5df 100644
--- a/drivers/media/platform/s5p-fimc/mipi-csis.c
+++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
@@ -216,7 +216,11 @@ static const struct csis_pix_format s5pcsis_formats[] = {
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
@@ -280,7 +284,7 @@ static void __s5pcsis_set_format(struct csis_state *state)
 	struct v4l2_mbus_framefmt *mf = &state->format;
 	u32 val;
 
-	v4l2_dbg(1, debug, &state->sd, "fmt: %d, %d x %d\n",
+	v4l2_dbg(1, debug, &state->sd, "fmt: %#x, %d x %d\n",
 		 mf->code, mf->width, mf->height);
 
 	/* Color format */
-- 
1.7.11.3

