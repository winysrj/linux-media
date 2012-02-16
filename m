Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42400 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab2BPSYL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 13:24:11 -0500
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LZI00GT30G5NM@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 18:24:05 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZI00FB20G4MA@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 18:24:05 +0000 (GMT)
Date: Thu, 16 Feb 2012 19:23:58 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH 5/6] s5p-fimc: Add support for V4L2_PIX_FMT_JPG_YUYV_S5C
 fourcc
In-reply-to: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1329416639-19454-6-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_PIX_FMT_JPG_YUYV_S5C image formats consists of
2 planes, the first containing interleaved JPEG/YUYV data
and the second containing meta data describing the
interleaving method.

The image data is transferred with MIPI-CSI "User Defined
Byte-Based Data 1" type and is captured to memory by FIMC
DMA engine.

The meta data is transferred using MIPI-CSI2 "Embedded 8-bit
non Image Data" and it is captured in the MIPI-CSI slave device
and retrieved by the bridge through a subdev callback.

Copying data from MIPI-CSIS doesn't influence performance a lot
(copying 4KiB buffer takes about 5 us) and simplifies the subdev
- bridge interactions. In opposite to having the bridge driver
allocating memory for meta data and passing it to the subdev.

The interrupt_service_routine subdev callback is used to provide
the MIPI-CSI receiver subdev with frame sequence numbers. This
is needed to discard non-image packets when FIMC DMA engine is
stopped, e.g. because user space is not de-queueing buffers.

To make sure the size of allocated buffers is correct for a
subdev configuration during VIDIOC_STREAMON ioctl the video
pipeline validation has been extended with an additional
check.

Flag FMT_FLAGS_COMPRESSED indicates the buffer size should
be retrieved from a sensor subdev.

For the discussion purposes this patch relies on new vendor
specific media bus pixel code - V4L2_MBUS_FMT_VYUY_JPEG_I1_1X8.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |  123 ++++++++++++++++++++------
 drivers/media/video/s5p-fimc/fimc-core.c    |   37 ++++++++-
 drivers/media/video/s5p-fimc/fimc-core.h    |   22 +++++-
 drivers/media/video/s5p-fimc/fimc-reg.c     |    5 +-
 drivers/media/video/s5p-fimc/mipi-csis.c    |    7 +-
 5 files changed, 157 insertions(+), 37 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index b06efd2..fb4eea8 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -246,29 +246,27 @@ int fimc_capture_resume(struct fimc_dev *fimc)
 
 }
 
-static unsigned int get_plane_size(struct fimc_frame *fr, unsigned int plane)
-{
-	if (!fr || plane >= fr->fmt->memplanes)
-		return 0;
-	return fr->f_width * fr->f_height * fr->fmt->depth[plane] / 8;
-}
-
 static int queue_setup(struct vb2_queue *vq,  const struct v4l2_format *pfmt,
 		       unsigned int *num_buffers, unsigned int *num_planes,
 		       unsigned int sizes[], void *allocators[])
 {
 	struct fimc_ctx *ctx = vq->drv_priv;
-	struct fimc_fmt *fmt = ctx->d_frame.fmt;
-	int i;
+	struct fimc_frame *f = &ctx->d_frame;
+	int plane;
 
-	if (!fmt)
+	if (!f->fmt)
 		return -EINVAL;
 
-	*num_planes = fmt->memplanes;
+	*num_planes = f->fmt->memplanes;
+
+	for (plane = 0; plane < f->fmt->memplanes; plane++) {
+		allocators[plane] = ctx->fimc_dev->alloc_ctx;
 
-	for (i = 0; i < fmt->memplanes; i++) {
-		sizes[i] = get_plane_size(&ctx->d_frame, i);
-		allocators[i] = ctx->fimc_dev->alloc_ctx;
+		if (fimc_fmt_is_user_defined(f->fmt->color))
+			sizes[plane] = f->payload[plane];
+		else
+			sizes[plane] = f->f_width * f->f_height *
+				f->fmt->depth[plane] / 8;
 	}
 
 	return 0;
@@ -493,10 +491,10 @@ static struct fimc_fmt *fimc_capture_try_format(struct fimc_ctx *ctx,
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
@@ -510,18 +508,19 @@ static struct fimc_fmt *fimc_capture_try_format(struct fimc_ctx *ctx,
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
@@ -560,7 +559,7 @@ static void fimc_capture_try_crop(struct fimc_ctx *ctx, struct v4l2_rect *r,
 	u32 max_sc_h, max_sc_v;
 
 	/* In JPEG transparent transfer mode cropping is not supported */
-	if (fimc_fmt_is_jpeg(ctx->d_frame.fmt->color)) {
+	if (fimc_fmt_is_user_defined(ctx->d_frame.fmt->color)) {
 		r->width  = sink->f_width;
 		r->height = sink->f_height;
 		r->left   = r->top = 0;
@@ -723,6 +722,36 @@ static int fimc_pipeline_try_format(struct fimc_ctx *ctx,
 	return 0;
 }
 
+/* Query the sensor for required buffer size (only for compressed data). */
+static int fimc_sd_get_plane_size(struct fimc_dev *fimc, unsigned int *size,
+				  unsigned int plane)
+{
+	struct v4l2_subdev *sd = fimc->pipeline.sensor;
+	struct v4l2_frame_config fc;
+	int ret;
+
+	fc.length = *size;
+
+	ret = v4l2_subdev_call(sd, pad, set_frame_config, 0, &fc);
+	if (ret < 0)
+		return ret;
+
+	switch (plane) {
+	case 0:
+		if (fc.length > FIMC_MAX_JPEG_BUF_SIZE) {
+			v4l2_err(sd, "Unsupported buffer size\n");
+			return -EINVAL;
+		}
+		*size = fc.length;
+		break;
+	case 1:
+		*size = fc.footer_length;
+		break;
+	}
+
+	return 0;
+}
+
 static int fimc_cap_g_fmt_mplane(struct file *file, void *fh,
 				 struct v4l2_format *f)
 {
@@ -743,11 +772,12 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
 	struct v4l2_mbus_framefmt mf;
 	struct fimc_fmt *ffmt = NULL;
+	int i;
 
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		return -EINVAL;
 
-	if (pix->pixelformat == V4L2_PIX_FMT_JPEG) {
+	if (fimc_jpeg_fourcc(pix->pixelformat)) {
 		fimc_capture_try_format(ctx, &pix->width, &pix->height,
 					NULL, &pix->pixelformat,
 					FIMC_SD_PAD_SINK);
@@ -775,11 +805,26 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 	}
 
 	fimc_adjust_mplane_format(ffmt, pix->width, pix->height, pix);
+
+	if (!(ffmt->flags & FMT_FLAGS_COMPRESSED))
+		return 0;
+
+	for (i = 0; i < ffmt->memplanes; i++) {
+		unsigned int size = 0;
+		int ret = fimc_sd_get_plane_size(fimc, &size, i);
+		if (ret < 0)
+			return ret;
+		pix->plane_fmt[i].sizeimage = size;
+	}
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
 
@@ -804,7 +849,7 @@ static int fimc_capture_set_format(struct fimc_dev *fimc, struct v4l2_format *f)
 		return -EBUSY;
 
 	/* Pre-configure format at camera interface input, for JPEG only */
-	if (pix->pixelformat == V4L2_PIX_FMT_JPEG) {
+	if (fimc_jpeg_fourcc(pix->pixelformat)) {
 		fimc_capture_try_format(ctx, &pix->width, &pix->height,
 					NULL, &pix->pixelformat,
 					FIMC_SD_PAD_SINK);
@@ -836,16 +881,28 @@ static int fimc_capture_set_format(struct fimc_dev *fimc, struct v4l2_format *f)
 		pix->height = mf->height;
 	}
 	fimc_adjust_mplane_format(ff->fmt, pix->width, pix->height, pix);
-	for (i = 0; i < ff->fmt->colplanes; i++)
-		ff->payload[i] =
-			(pix->width * pix->height * ff->fmt->depth[i]) / 8;
+
+	if (ff->fmt->flags & FMT_FLAGS_COMPRESSED) {
+		for (i = 0; i < ff->fmt->memplanes; i++) {
+			unsigned int size = 0;
+			ret = fimc_sd_get_plane_size(fimc, &size, i);
+			if (ret < 0)
+				return ret;
+			pix->plane_fmt[i].sizeimage = size;
+			ff->payload[i] = size;
+		}
+	} else {
+		for (i = 0; i < ff->fmt->colplanes; i++)
+			ff->payload[i] = pix->width * pix->height *
+					 ff->fmt->depth[i] / 8;
+	}
 
 	set_frame_bounds(ff, pix->width, pix->height);
 	/* Reset the composition rectangle if not yet configured */
 	if (!(ctx->state & FIMC_DST_CROP))
 		set_frame_crop(ff, 0, 0, pix->width, pix->height);
 
-	fimc_capture_mark_jpeg_xfer(ctx, fimc_fmt_is_jpeg(ff->fmt->color));
+	fimc_capture_mark_jpeg_xfer(ctx, ff->fmt->color);
 
 	/* Reset cropping and set format at the camera interface input */
 	if (!fimc->vid_cap.user_subdev_api) {
@@ -947,6 +1004,14 @@ static int fimc_pipeline_validate(struct fimc_dev *fimc)
 		    src_fmt.format.height != sink_fmt.format.height ||
 		    src_fmt.format.code != sink_fmt.format.code)
 			return -EPIPE;
+
+		if (sd == fimc->pipeline.sensor &&
+		    fimc_user_defined_mbus_fmt(src_fmt.format.code)) {
+			unsigned int size = 0;
+			fimc_sd_get_plane_size(fimc, &size, 0);
+			if (vid_cap->ctx->d_frame.payload[0] < size)
+				return -EPIPE;
+		    }
 	}
 	return 0;
 }
@@ -1314,7 +1379,7 @@ static int fimc_subdev_set_fmt(struct v4l2_subdev *sd,
 	/* Update RGB Alpha control state and value range */
 	fimc_alpha_ctrl_update(ctx);
 
-	fimc_capture_mark_jpeg_xfer(ctx, fimc_fmt_is_jpeg(ffmt->color));
+	fimc_capture_mark_jpeg_xfer(ctx, ffmt->color);
 
 	ff = fmt->pad == FIMC_SD_PAD_SINK ?
 		&ctx->s_frame : &ctx->d_frame;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index e184e65..8e53c9a 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -183,7 +183,17 @@ static struct fimc_fmt fimc_formats[] = {
 		.memplanes	= 1,
 		.colplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_JPEG_1X8,
-		.flags		= FMT_FLAGS_CAM,
+		.flags		= FMT_FLAGS_CAM | FMT_FLAGS_COMPRESSED,
+	}, {
+		.name		= "Interleaved JPEG/YUYV S5C73MX sensor data",
+		.fourcc		= V4L2_PIX_FMT_JPG_YUYV_S5C,
+		.color		= S5P_FIMC_VYUY_JPEG,
+		.depth		= { 8 },
+		.memplanes	= 2,
+		.colplanes	= 1,
+		.mdataplanes	= 0x2, /* plane 1 holds frame meta data */
+		.mbus_code	= V4L2_MBUS_FMT_VYUY_JPEG_I1_1X8,
+		.flags		= FMT_FLAGS_CAM | FMT_FLAGS_COMPRESSED,
 	},
 };
 
@@ -353,6 +363,7 @@ static int stop_streaming(struct vb2_queue *q)
 
 void fimc_capture_irq_handler(struct fimc_dev *fimc, bool final)
 {
+	struct v4l2_subdev *csis = fimc->pipeline.csis;
 	struct fimc_vid_cap *cap = &fimc->vid_cap;
 	struct fimc_vid_buffer *v_buf;
 	struct timeval *tv;
@@ -363,8 +374,12 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc, bool final)
 		return;
 	}
 
+	v4l2_subdev_call(csis, core, interrupt_service_routine, 0, NULL);
+
 	if (!list_empty(&cap->active_buf_q) &&
 	    test_bit(ST_CAPT_RUN, &fimc->state) && final) {
+		struct fimc_frame *f = &cap->ctx->d_frame;
+
 		ktime_get_real_ts(&ts);
 
 		v_buf = fimc_active_queue_pop(cap);
@@ -374,6 +389,19 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc, bool final)
 		tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 		v_buf->vb.v4l2_buf.sequence = cap->frame_count++;
 
+		if (f->fmt->mdataplanes) {
+			unsigned int size = f->payload[1];
+			void *vaddr;
+			dma_addr_t addr;
+
+			addr = vb2_dma_contig_plane_dma_addr(&v_buf->vb,
+					     ffs(f->fmt->mdataplanes) - 1);
+			vaddr = phys_to_virt(addr);
+
+			v4l2_subdev_call(csis, video, g_embedded_data,
+					 &size, &vaddr);
+		}
+
 		vb2_buffer_done(&v_buf->vb, VB2_BUF_STATE_DONE);
 	}
 
@@ -492,7 +520,7 @@ int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 		default:
 			return -EINVAL;
 		}
-	} else {
+	} else if (!frame->fmt->mdataplanes) {
 		if (frame->fmt->memplanes >= 2)
 			paddr->cb = vb2_dma_contig_plane_dma_addr(vb, 1);
 
@@ -968,6 +996,11 @@ int fimc_fill_format(struct fimc_frame *frame, struct v4l2_format *f)
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
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index a18291e..f42260f 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -17,6 +17,7 @@
 #include <linux/types.h>
 #include <linux/videodev2.h>
 #include <linux/io.h>
+#include <asm/sizes.h>
 
 #include <media/media-entity.h>
 #include <media/videobuf2-core.h>
@@ -44,6 +45,7 @@
 #define SCALER_MAX_VRATIO	64
 #define DMA_MIN_SIZE		8
 #define FIMC_CAMIF_MAX_HEIGHT	0x2000
+#define FIMC_MAX_JPEG_BUF_SIZE	SZ_8M
 
 /* indices to the clocks array */
 enum {
@@ -98,10 +100,11 @@ enum fimc_color_fmt {
 	S5P_FIMC_CRYCBY422,
 	S5P_FIMC_YCBCR444_LOCAL,
 	S5P_FIMC_JPEG = 0x40,
+	S5P_FIMC_VYUY_JPEG = 0x80,
 };
 
+#define fimc_fmt_is_user_defined(x) (!!((x) & 0xC0))
 #define fimc_fmt_is_rgb(x) (!!((x) & 0x10))
-#define fimc_fmt_is_jpeg(x) (!!((x) & 0x40))
 
 #define IS_M2M(__strt) ((__strt) == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE || \
 			__strt == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
@@ -151,6 +154,7 @@ enum fimc_color_fmt {
  * @memplanes: number of physically non-contiguous data planes
  * @colplanes: number of physically contiguous data planes
  * @depth: per plane driver's private 'number of bits per pixel'
+ * @mdataplanes: bitmask indicating meta data plane(s), (1 << plane_no)
  * @flags: flags indicating which operation mode format applies to
  */
 struct fimc_fmt {
@@ -161,12 +165,14 @@ struct fimc_fmt {
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
@@ -284,7 +290,7 @@ struct fimc_frame {
 	u32	offs_v;
 	u32	width;
 	u32	height;
-	unsigned long		payload[VIDEO_MAX_PLANES];
+	unsigned int		payload[VIDEO_MAX_PLANES];
 	struct fimc_addr	paddr;
 	struct fimc_dma_offset	dma_offset;
 	struct fimc_fmt		*fmt;
@@ -585,6 +591,18 @@ static inline int tiled_fmt(struct fimc_fmt *fmt)
 	return fmt->fourcc == V4L2_PIX_FMT_NV12MT;
 }
 
+static inline bool fimc_jpeg_fourcc(u32 pixelformat)
+{
+	return (pixelformat == V4L2_PIX_FMT_JPEG ||
+		pixelformat == V4L2_PIX_FMT_JPG_YUYV_S5C);
+}
+
+static inline bool fimc_user_defined_mbus_fmt(u32 code)
+{
+	return (code == V4L2_MBUS_FMT_JPEG_1X8 ||
+		code == V4L2_MBUS_FMT_VYUY_JPEG_I1_1X8);
+}
+
 /* Return the alpha component bit mask */
 static inline int fimc_get_alpha_mask(struct fimc_fmt *fmt)
 {
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 15466d0..2821459 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -637,7 +637,7 @@ int fimc_hw_set_camera_source(struct fimc_dev *fimc,
 				cfg |= S5P_CISRCFMT_ITU601_16BIT;
 		} /* else defaults to ITU-R BT.656 8-bit */
 	} else if (cam->bus_type == FIMC_MIPI_CSI2) {
-		if (fimc_fmt_is_jpeg(f->fmt->color))
+		if (fimc_fmt_is_user_defined(f->fmt->color))
 			cfg |= S5P_CISRCFMT_ITU601_8BIT;
 	}
 
@@ -694,12 +694,13 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 			tmp = S5P_CSIIMGFMT_YCBCR422_8BIT;
 			break;
 		case V4L2_MBUS_FMT_JPEG_1X8:
+		case V4L2_MBUS_FMT_VYUY_JPEG_I1_1X8:
 			tmp = S5P_CSIIMGFMT_USER(1);
 			cfg |= S5P_CIGCTRL_CAM_JPEG;
 			break;
 		default:
 			v4l2_err(fimc->vid_cap.vfd,
-				 "Not supported camera pixel format: %d",
+				 "Not supported camera pixel format: %#x",
 				 vid_cap->mf.code);
 			return -EINVAL;
 		}
diff --git a/drivers/media/video/s5p-fimc/mipi-csis.c b/drivers/media/video/s5p-fimc/mipi-csis.c
index a903138..04f1a0d 100644
--- a/drivers/media/video/s5p-fimc/mipi-csis.c
+++ b/drivers/media/video/s5p-fimc/mipi-csis.c
@@ -141,7 +141,10 @@ static const struct csis_pix_format s5pcsis_formats[] = {
 	}, {
 		.code = V4L2_MBUS_FMT_JPEG_1X8,
 		.fmt_reg = S5PCSIS_CFG_FMT_USER(1),
-	},
+	}, {
+		.code = V4L2_MBUS_FMT_VYUY_JPEG_I1_1X8,
+		.fmt_reg = S5PCSIS_CFG_FMT_USER(1),
+	}
 };
 
 #define s5pcsis_write(__csis, __r, __v) writel(__v, __csis->regs + __r)
@@ -205,7 +208,7 @@ static void __s5pcsis_set_format(struct csis_state *state)
 	struct v4l2_mbus_framefmt *mf = &state->format;
 	u32 val;
 
-	v4l2_dbg(1, debug, &state->sd, "fmt: %d, %d x %d\n",
+	v4l2_dbg(1, debug, &state->sd, "fmt: %#x, %d x %d\n",
 		 mf->code, mf->width, mf->height);
 
 	/* Color format */
-- 
1.7.9

