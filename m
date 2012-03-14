Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:30158 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159Ab2CNIAr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 04:00:47 -0400
Received: from epcpsbgm1.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0M0V001A37KVSI80@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Mar 2012 17:00:32 +0900 (KST)
Received: from NOSY0816KAN01 ([12.23.119.130])
 by mmp1.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0M0V00MPP7KX2C00@mmp1.samsung.com>
 for linux-media@vger.kernel.org; Wed, 14 Mar 2012 17:00:34 +0900 (KST)
From: Sunyoung Kang <sy0816.kang@samsung.com>
To: 'Sylwester Nawrocki' <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org,
	'Mauro Carvalho Chehab' <mchehab@infradead.org>,
	jonghun.han@samsung.com, khw0178.kim@samsung.com,
	sungchun.kang@samsung.com, younglak1004.kim@samsung.com,
	kgene.kim@samsung.com, a.sim@samsung.com, sy0816.kang@samsung.com
Subject: [PATCH v2] media: rotator: Add new image rotator driver for EXYNOS
Date: Wed, 14 Mar 2012 17:00:31 +0900
Message-id: <001601cd01b8$873dd8c0$95b98a40$%kang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds new rotator driver which is a device for
rotation on EXYNOS SoCs.

This rotator device supports the belows as key feature.
 1) Image format
   : RGB565/888, YUV422 1p, YUV420 2p/3p
 2) rotation
   : 0/90/180/270 and X/Y Flip

Signed-off-by: Sunyoung Kang <sy0816.kang@samsung.com>
Signed-off-by: Ayoung Sim <a.sim@samsung.com>
---NOTE:
This patch has been created based on following
 - media: media-dev: Add media devices for EXYNOS5 by Sungchun Kang
 - media: fimc-lite: Add new driver for camera interface by Sungchun Kang

Changes since v1:
 - address comments from Sylwester Nawrocki
   
 drivers/media/video/exynos/Kconfig                |    1 +
 drivers/media/video/exynos/Makefile               |    1 +
 drivers/media/video/exynos/rotator/Kconfig        |    7 +
 drivers/media/video/exynos/rotator/Makefile       |    9 +
 drivers/media/video/exynos/rotator/rotator-core.c | 1344 +++++++++++++++++++++
 drivers/media/video/exynos/rotator/rotator-regs.c |  215 ++++
 drivers/media/video/exynos/rotator/rotator-regs.h |   70 ++
 drivers/media/video/exynos/rotator/rotator.h      |  286 +++++
 8 files changed, 1933 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/exynos/rotator/Kconfig
 create mode 100644 drivers/media/video/exynos/rotator/Makefile
 create mode 100644 drivers/media/video/exynos/rotator/rotator-core.c
 create mode 100644 drivers/media/video/exynos/rotator/rotator-regs.c
 create mode 100644 drivers/media/video/exynos/rotator/rotator-regs.h
 create mode 100644 drivers/media/video/exynos/rotator/rotator.h

diff --git a/drivers/media/video/exynos/Kconfig b/drivers/media/video/exynos/Kconfig
index a84097d..38a885d 100644
--- a/drivers/media/video/exynos/Kconfig
+++ b/drivers/media/video/exynos/Kconfig
@@ -12,6 +12,7 @@ config VIDEO_EXYNOS
 if VIDEO_EXYNOS
 	source "drivers/media/video/exynos/mdev/Kconfig"
 	source "drivers/media/video/exynos/fimc-lite/Kconfig"
+	source "drivers/media/video/exynos/rotator/Kconfig"
 endif
 
 config MEDIA_EXYNOS
diff --git a/drivers/media/video/exynos/Makefile b/drivers/media/video/exynos/Makefile
index 56cb7b2..24f19c5 100644
--- a/drivers/media/video/exynos/Makefile
+++ b/drivers/media/video/exynos/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_EXYNOS_MEDIA_DEVICE)	+= mdev/
 obj-$(CONFIG_VIDEO_EXYNOS_FIMC_LITE)	+= fimc-lite/
+obj-$(CONFIG_VIDEO_EXYNOS_ROTATOR)	+= rotator/
 
 EXTRA_CLAGS += -Idrivers/media/video
diff --git a/drivers/media/video/exynos/rotator/Kconfig b/drivers/media/video/exynos/rotator/Kconfig
new file mode 100644
index 0000000..977423a
--- /dev/null
+++ b/drivers/media/video/exynos/rotator/Kconfig
@@ -0,0 +1,7 @@
+config VIDEO_EXYNOS_ROTATOR
+	bool "EXYNOS Image Rotator Driver"
+	select V4L2_MEM2MEM_DEV
+	select VIDEOBUF2_DMA_CONTIG
+	default n
+	---help---
+	  Support for Image Rotator Driver with v4l2 on EXYNOS SoCs
diff --git a/drivers/media/video/exynos/rotator/Makefile b/drivers/media/video/exynos/rotator/Makefile
new file mode 100644
index 0000000..6f74403
--- /dev/null
+++ b/drivers/media/video/exynos/rotator/Makefile
@@ -0,0 +1,9 @@
+#
+# Copyright (c) 2012 Samsung Electronics Co., Ltd.
+#		http://www.samsung.com
+#
+# Licensed under GPLv2
+#
+
+rotator-objs				:= rotator-core.o rotator-regs.o
+obj-$(CONFIG_VIDEO_EXYNOS_ROTATOR)	+= rotator.o
diff --git a/drivers/media/video/exynos/rotator/rotator-core.c b/drivers/media/video/exynos/rotator/rotator-core.c
new file mode 100644
index 0000000..75d28f2
--- /dev/null
+++ b/drivers/media/video/exynos/rotator/rotator-core.c
@@ -0,0 +1,1344 @@
+/*
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Core file for Samsung EXYNOS Image Rotator driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/clk.h>
+#include <linux/slab.h>
+
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "rotator.h"
+
+int log_level;
+module_param_named(log_level, log_level, uint, 0644);
+
+static struct rot_fmt rot_formats[] = {
+	{
+		.name		= "RGB565",
+		.pixelformat	= V4L2_PIX_FMT_RGB565,
+		.num_planes	= 1,
+		.num_comp	= 1,
+		.bitperpixel	= { 16 },
+	}, {
+		.name		= "XRGB-8888, 32 bps",
+		.pixelformat	= V4L2_PIX_FMT_RGB32,
+		.num_planes	= 1,
+		.num_comp	= 1,
+		.bitperpixel	= { 32 },
+	}, {
+		.name		= "YUV 4:2:2 packed, YCbYCr",
+		.pixelformat	= V4L2_PIX_FMT_YUYV,
+		.num_planes	= 1,
+		.num_comp	= 1,
+		.bitperpixel	= { 16 },
+	}, {
+		.name		= "YUV 4:2:0 non-contiguous 2-planar, Y/CbCr",
+		.pixelformat	= V4L2_PIX_FMT_NV12M,
+		.num_planes	= 2,
+		.num_comp	= 2,
+		.bitperpixel	= { 8, 4 },
+	}, {
+		.name		= "YUV 4:2:0 non-contiguous 3-planar, Y/Cb/Cr",
+		.pixelformat	= V4L2_PIX_FMT_YUV420M,
+		.num_planes	= 3,
+		.num_comp	= 3,
+		.bitperpixel	= { 8, 2, 2 },
+	},
+};
+
+/* Find the matches format */
+static struct rot_fmt *rot_find_format(struct v4l2_format *f)
+{
+	struct rot_fmt *rot_fmt;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(rot_formats); ++i) {
+		rot_fmt = &rot_formats[i];
+		if (rot_fmt->pixelformat == f->fmt.pix_mp.pixelformat)
+			return &rot_formats[i];
+	}
+
+	return NULL;
+}
+
+static void rot_bound_align_image(struct rot_ctx *ctx, struct rot_fmt *rot_fmt,
+				  u32 *width, u32 *height)
+{
+	struct exynos_rot_variant *variant = ctx->rot_dev->variant;
+	struct exynos_rot_size_limit *limit = NULL;
+
+	switch (rot_fmt->pixelformat) {
+	case V4L2_PIX_FMT_YUV420M:
+		limit = &variant->limit_yuv420_3p;
+		break;
+	case V4L2_PIX_FMT_NV12M:
+		limit = &variant->limit_yuv420_2p;
+		break;
+	case V4L2_PIX_FMT_YUYV:
+		limit = &variant->limit_yuv422;
+		break;
+	case V4L2_PIX_FMT_RGB565:
+		limit =	&variant->limit_rgb565;
+		break;
+	case V4L2_PIX_FMT_RGB32:
+		limit = &variant->limit_rgb888;
+		break;
+	default:
+		v4l2_err(&ctx->rot_dev->m2m.v4l2_dev,
+				"not supported format values\n");
+		return;
+	}
+
+	/* Bound an image to have width and height in limit */
+	v4l_bound_align_image(width, limit->min_x, limit->max_x,
+			limit->align, height, limit->min_y,
+			limit->max_y, limit->align, 0);
+}
+
+static void rot_adjust_pixminfo(struct rot_ctx *ctx, struct rot_frame *frame,
+				struct v4l2_pix_format_mplane *pixm)
+{
+	struct rot_frame *rot_frame;
+
+	if (frame == &ctx->s_frame) {
+		if (test_bit(CTX_DST, &ctx->flags)) {
+			rot_frame = &ctx->d_frame;
+			pixm->pixelformat = rot_frame->rot_fmt->pixelformat;
+		}
+		set_bit(CTX_SRC, &ctx->flags);
+	} else if (frame == &ctx->d_frame) {
+		if (test_bit(CTX_SRC, &ctx->flags)) {
+			rot_frame = &ctx->s_frame;
+			pixm->pixelformat = rot_frame->rot_fmt->pixelformat;
+		}
+		set_bit(CTX_DST, &ctx->flags);
+	}
+}
+
+static void rot_adjust_cropinfo(struct rot_ctx *ctx, struct rot_frame *frame,
+				struct v4l2_rect *crop)
+{
+	struct rot_frame *rot_frame;
+
+	if (frame == &ctx->s_frame) {
+		if (test_bit(CTX_DST, &ctx->flags)) {
+			rot_frame = &ctx->d_frame;
+			crop->width  = rot_frame->crop.height;
+			crop->height = rot_frame->crop.width;
+		}
+		set_bit(CTX_SRC, &ctx->flags);
+	} else if (frame == &ctx->d_frame) {
+		if (test_bit(CTX_SRC, &ctx->flags)) {
+			rot_frame = &ctx->s_frame;
+			crop->width  = rot_frame->crop.height;
+			crop->height = rot_frame->crop.width;
+		}
+		set_bit(CTX_DST, &ctx->flags);
+	}
+}
+
+static int rot_v4l2_querycap(struct file *file, void *fh,
+			     struct v4l2_capability *cap)
+{
+	strncpy(cap->driver, MODULE_NAME, sizeof(cap->driver) - 1);
+	strncpy(cap->card, MODULE_NAME, sizeof(cap->card) - 1);
+
+	cap->bus_info[0] = 0;
+	cap->capabilities = V4L2_CAP_STREAMING |
+		V4L2_CAP_VIDEO_CAPTURE_MPLANE | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+
+	return 0;
+}
+
+static int rot_v4l2_enum_fmt_mplane(struct file *file, void *fh,
+				    struct v4l2_fmtdesc *f)
+{
+	struct rot_fmt *rot_fmt;
+
+	if (f->index >= ARRAY_SIZE(rot_formats))
+		return -EINVAL;
+
+	rot_fmt = &rot_formats[f->index];
+	strncpy(f->description, rot_fmt->name, sizeof(f->description) - 1);
+	f->pixelformat = rot_fmt->pixelformat;
+
+	return 0;
+}
+
+static int rot_v4l2_g_fmt_mplane(struct file *file, void *fh,
+				 struct v4l2_format *f)
+{
+	struct rot_ctx *ctx = fh_to_rot_ctx(fh);
+	struct rot_fmt *rot_fmt;
+	struct rot_frame *frame;
+	struct v4l2_pix_format_mplane *pixm = &f->fmt.pix_mp;
+	int i;
+
+	frame = ctx_get_frame(ctx, f->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	rot_fmt = frame->rot_fmt;
+
+	pixm->width		= frame->pix_mp.width;
+	pixm->height		= frame->pix_mp.height;
+	pixm->pixelformat	= frame->pix_mp.pixelformat;
+	pixm->field		= V4L2_FIELD_NONE;
+	pixm->num_planes	= frame->rot_fmt->num_planes;
+	pixm->colorspace	= 0;
+
+	for (i = 0; i < pixm->num_planes; ++i) {
+		pixm->plane_fmt[i].bytesperline = (pixm->width *
+				rot_fmt->bitperpixel[i]) >> 3;
+		pixm->plane_fmt[i].sizeimage = pixm->plane_fmt[i].bytesperline
+				* pixm->height;
+
+		v4l2_dbg(1, log_level, &ctx->rot_dev->m2m.v4l2_dev,
+				"[%d] plane: bytesperline %d, sizeimage %d\n",
+				i, pixm->plane_fmt[i].bytesperline,
+				pixm->plane_fmt[i].sizeimage);
+	}
+
+	return 0;
+}
+
+static int rot_v4l2_try_fmt_mplane(struct file *file, void *fh,
+				    struct v4l2_format *f)
+{
+	struct rot_ctx *ctx = fh_to_rot_ctx(fh);
+	struct rot_fmt *rot_fmt;
+	struct v4l2_pix_format_mplane *pixm = &f->fmt.pix_mp;
+	int i;
+
+	if (!V4L2_TYPE_IS_MULTIPLANAR(f->type)) {
+		v4l2_err(&ctx->rot_dev->m2m.v4l2_dev,
+				"not supported v4l2 type\n");
+		return -EINVAL;
+	}
+
+	rot_fmt = rot_find_format(f);
+	if (!rot_fmt) {
+		v4l2_err(&ctx->rot_dev->m2m.v4l2_dev,
+				"not supported format type\n");
+		return -EINVAL;
+	}
+
+	rot_bound_align_image(ctx, rot_fmt, &pixm->width, &pixm->height);
+
+	pixm->num_planes = rot_fmt->num_planes;
+	pixm->colorspace = 0;
+
+	for (i = 0; i < pixm->num_planes; ++i) {
+		pixm->plane_fmt[i].bytesperline = (pixm->width *
+				rot_fmt->bitperpixel[i]) >> 3;
+		pixm->plane_fmt[i].sizeimage = pixm->plane_fmt[i].bytesperline
+				* pixm->height;
+
+		v4l2_dbg(1, log_level, &ctx->rot_dev->m2m.v4l2_dev,
+				"[%d] plane: bytesperline %d, sizeimage %d\n",
+				i, pixm->plane_fmt[i].bytesperline,
+				pixm->plane_fmt[i].sizeimage);
+	}
+
+	return 0;
+}
+
+static int rot_v4l2_s_fmt_mplane(struct file *file, void *fh,
+				 struct v4l2_format *f)
+{
+	struct rot_ctx *ctx = fh_to_rot_ctx(fh);
+	struct vb2_queue *vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	struct rot_frame *frame;
+	struct v4l2_pix_format_mplane *pixm = &f->fmt.pix_mp;
+	int i, ret = 0;
+
+	if (vb2_is_streaming(vq)) {
+		v4l2_err(&ctx->rot_dev->m2m.v4l2_dev, "device is busy\n");
+		return -EBUSY;
+	}
+
+	ret = rot_v4l2_try_fmt_mplane(file, fh, f);
+	if (ret < 0)
+		return ret;
+
+	frame = ctx_get_frame(ctx, f->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	set_bit(CTX_PARAMS, &ctx->flags);
+
+	frame->rot_fmt = rot_find_format(f);
+	if (!frame->rot_fmt) {
+		v4l2_err(&ctx->rot_dev->m2m.v4l2_dev,
+				"not supported format values\n");
+		return -EINVAL;
+	}
+
+	rot_adjust_pixminfo(ctx, frame, pixm);
+
+	frame->pix_mp.pixelformat = pixm->pixelformat;
+	frame->pix_mp.width	= pixm->width;
+	frame->pix_mp.height	= pixm->height;
+
+	/*
+	 * Shouldn't call s_crop or g_crop before called g_fmt or s_fmt.
+	 * Let's assume that we can keep the order.
+	 */
+	frame->crop.width	= pixm->width;
+	frame->crop.height	= pixm->height;
+
+	for (i = 0; i < frame->rot_fmt->num_planes; ++i)
+		frame->bytesused[i] = (pixm->width * pixm->height *
+				frame->rot_fmt->bitperpixel[i]) >> 3;
+
+	return 0;
+}
+
+static int rot_v4l2_reqbufs(struct file *file, void *fh,
+			    struct v4l2_requestbuffers *reqbufs)
+{
+	struct rot_ctx *ctx = fh_to_rot_ctx(fh);
+	struct rot_frame *frame;
+
+	frame = ctx_get_frame(ctx, reqbufs->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	if (frame == &ctx->s_frame)
+		clear_bit(CTX_SRC, &ctx->flags);
+	else if (frame == &ctx->d_frame)
+		clear_bit(CTX_DST, &ctx->flags);
+
+	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
+}
+
+static int rot_v4l2_querybuf(struct file *file, void *fh,
+			     struct v4l2_buffer *buf)
+{
+	struct rot_ctx *ctx = fh_to_rot_ctx(fh);
+	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
+}
+
+static int rot_v4l2_qbuf(struct file *file, void *fh,
+			 struct v4l2_buffer *buf)
+{
+	struct rot_ctx *ctx = fh_to_rot_ctx(fh);
+	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int rot_v4l2_dqbuf(struct file *file, void *fh,
+			  struct v4l2_buffer *buf)
+{
+	struct rot_ctx *ctx = fh_to_rot_ctx(fh);
+	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int rot_v4l2_streamon(struct file *file, void *fh,
+			     enum v4l2_buf_type type)
+{
+	struct rot_ctx *ctx = fh_to_rot_ctx(fh);
+	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
+}
+
+static int rot_v4l2_streamoff(struct file *file, void *fh,
+			      enum v4l2_buf_type type)
+{
+	struct rot_ctx *ctx = fh_to_rot_ctx(fh);
+	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
+}
+
+static int rot_v4l2_cropcap(struct file *file, void *fh,
+			    struct v4l2_cropcap *cr)
+{
+	struct rot_ctx *ctx = fh_to_rot_ctx(fh);
+	struct rot_frame *frame;
+
+	frame = ctx_get_frame(ctx, cr->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	cr->bounds.left		= 0;
+	cr->bounds.top		= 0;
+	cr->bounds.width	= frame->pix_mp.width;
+	cr->bounds.height	= frame->pix_mp.height;
+	cr->defrect		= cr->bounds;
+
+	return 0;
+}
+
+static int rot_v4l2_g_crop(struct file *file, void *fh, struct v4l2_crop *cr)
+{
+	struct rot_ctx *ctx = fh_to_rot_ctx(fh);
+	struct rot_frame *frame;
+
+	frame = ctx_get_frame(ctx, cr->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	cr->c = frame->crop;
+
+	return 0;
+}
+
+static int rot_v4l2_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
+{
+	struct rot_ctx *ctx = fh_to_rot_ctx(fh);
+	struct rot_frame *frame;
+	struct v4l2_pix_format_mplane *pixm;
+	int i;
+
+	frame = ctx_get_frame(ctx, cr->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	if (!test_bit(CTX_PARAMS, &ctx->flags)) {
+		v4l2_err(&ctx->rot_dev->m2m.v4l2_dev,
+				"color format is not set\n");
+		return -EINVAL;
+	}
+
+	if (cr->c.left < 0 || cr->c.top < 0 ||
+			cr->c.width < 0 || cr->c.height < 0) {
+		v4l2_err(&ctx->rot_dev->m2m.v4l2_dev,
+				"crop value is negative\n");
+		return -EINVAL;
+	}
+
+	pixm = &frame->pix_mp;
+	rot_adjust_cropinfo(ctx, frame, &cr->c);
+	rot_bound_align_image(ctx, frame->rot_fmt, &cr->c.width, &cr->c.height);
+
+	/* Adjust left/top if cropping rectangle is out of bounds */
+	if (cr->c.left + cr->c.width > pixm->width) {
+		dev_warn(ctx->rot_dev->dev,
+			"out of bound left cropping size:left %d, width %d\n",
+				cr->c.left, cr->c.width);
+		cr->c.left = pixm->width - cr->c.width;
+	}
+	if (cr->c.top + cr->c.height > pixm->height) {
+		dev_warn(ctx->rot_dev->dev,
+			"out of bound top cropping size:top %d, height %d\n",
+				cr->c.top, cr->c.height);
+		cr->c.top = pixm->height - cr->c.height;
+	}
+
+	frame->crop = cr->c;
+
+	for (i = 0; i < frame->rot_fmt->num_planes; ++i)
+		frame->bytesused[i] = (cr->c.width * cr->c.height *
+				frame->rot_fmt->bitperpixel[i]) >> 3;
+
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops rot_v4l2_ioctl_ops = {
+	.vidioc_querycap		= rot_v4l2_querycap,
+
+	.vidioc_enum_fmt_vid_cap_mplane	= rot_v4l2_enum_fmt_mplane,
+	.vidioc_enum_fmt_vid_out_mplane	= rot_v4l2_enum_fmt_mplane,
+
+	.vidioc_g_fmt_vid_cap_mplane	= rot_v4l2_g_fmt_mplane,
+	.vidioc_g_fmt_vid_out_mplane	= rot_v4l2_g_fmt_mplane,
+
+	.vidioc_try_fmt_vid_cap_mplane	= rot_v4l2_try_fmt_mplane,
+	.vidioc_try_fmt_vid_out_mplane	= rot_v4l2_try_fmt_mplane,
+
+	.vidioc_s_fmt_vid_cap_mplane	= rot_v4l2_s_fmt_mplane,
+	.vidioc_s_fmt_vid_out_mplane	= rot_v4l2_s_fmt_mplane,
+
+	.vidioc_reqbufs			= rot_v4l2_reqbufs,
+	.vidioc_querybuf		= rot_v4l2_querybuf,
+
+	.vidioc_qbuf			= rot_v4l2_qbuf,
+	.vidioc_dqbuf			= rot_v4l2_dqbuf,
+
+	.vidioc_streamon		= rot_v4l2_streamon,
+	.vidioc_streamoff		= rot_v4l2_streamoff,
+
+	.vidioc_g_crop			= rot_v4l2_g_crop,
+	.vidioc_s_crop			= rot_v4l2_s_crop,
+	.vidioc_cropcap			= rot_v4l2_cropcap
+};
+
+static int rot_ctx_stop_req(struct rot_ctx *ctx)
+{
+	struct rot_ctx *curr_ctx;
+	struct rot_dev *rot = ctx->rot_dev;
+	int ret = 0;
+
+	curr_ctx = v4l2_m2m_get_curr_priv(rot->m2m.m2m_dev);
+	if (!test_bit(CTX_RUN, &ctx->flags) || (curr_ctx != ctx))
+		return 0;
+
+	set_bit(CTX_ABORT, &ctx->flags);
+
+	ret = wait_event_timeout(rot->irq.wait,
+			!test_bit(CTX_RUN, &ctx->flags), ROT_TIMEOUT);
+
+	/* TODO: How to handle case of timeout event */
+	if (ret == 0) {
+		dev_err(rot->dev, "device failed to stop request\n");
+		ret = -EBUSY;
+	}
+
+	return ret;
+}
+
+static int rot_vb2_queue_setup(struct vb2_queue *vq,
+		const struct v4l2_format *fmt, unsigned int *num_buffers,
+		unsigned int *num_planes, unsigned int sizes[],
+		void *allocators[])
+{
+	struct rot_ctx *ctx = vb2_get_drv_priv(vq);
+	struct rot_frame *frame;
+	int i;
+
+	frame = ctx_get_frame(ctx, vq->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	/* Get number of planes from format_list in driver */
+	*num_planes = frame->rot_fmt->num_planes;
+	for (i = 0; i < frame->rot_fmt->num_planes; i++) {
+		sizes[i] = (frame->pix_mp.width * frame->pix_mp.height *
+				frame->rot_fmt->bitperpixel[i]) >> 3;
+		allocators[i] = ctx->rot_dev->alloc_ctx;
+	}
+
+	return 0;
+}
+
+static int rot_vb2_buf_prepare(struct vb2_buffer *vb)
+{
+	struct rot_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct rot_frame *frame;
+	int i;
+
+	frame = ctx_get_frame(ctx, vb->vb2_queue->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	if (!V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
+		for (i = 0; i < frame->rot_fmt->num_planes; i++)
+			vb2_set_plane_payload(vb, i, frame->bytesused[i]);
+	}
+
+	return 0;
+}
+
+static void rot_vb2_buf_queue(struct vb2_buffer *vb)
+{
+	struct rot_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+
+	if (ctx->m2m_ctx)
+		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+}
+
+static void rot_vb2_lock(struct vb2_queue *vq)
+{
+	struct rot_ctx *ctx = vb2_get_drv_priv(vq);
+	mutex_lock(&ctx->rot_dev->lock);
+}
+
+static void rot_vb2_unlock(struct vb2_queue *vq)
+{
+	struct rot_ctx *ctx = vb2_get_drv_priv(vq);
+	mutex_unlock(&ctx->rot_dev->lock);
+}
+
+static int rot_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct rot_ctx *ctx = vb2_get_drv_priv(vq);
+	set_bit(CTX_STREAMING, &ctx->flags);
+
+	return 0;
+}
+
+static int rot_vb2_stop_streaming(struct vb2_queue *vq)
+{
+	struct rot_ctx *ctx = vb2_get_drv_priv(vq);
+	int ret;
+
+	ret = rot_ctx_stop_req(ctx);
+	if (ret < 0)
+		dev_err(ctx->rot_dev->dev, "wait timeout\n");
+
+	clear_bit(CTX_STREAMING, &ctx->flags);
+
+	return ret;
+}
+
+static struct vb2_ops rot_vb2_ops = {
+	.queue_setup		= rot_vb2_queue_setup,
+	.buf_prepare		= rot_vb2_buf_prepare,
+	.buf_queue		= rot_vb2_buf_queue,
+	.wait_finish		= rot_vb2_lock,
+	.wait_prepare		= rot_vb2_unlock,
+	.start_streaming	= rot_vb2_start_streaming,
+	.stop_streaming		= rot_vb2_stop_streaming,
+};
+
+static int queue_init(void *priv, struct vb2_queue *src_vq,
+		      struct vb2_queue *dst_vq)
+{
+	struct rot_ctx *ctx = priv;
+	int ret;
+
+	memset(src_vq, 0, sizeof(*src_vq));
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
+	src_vq->ops = &rot_vb2_ops;
+	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->drv_priv = ctx;
+	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	memset(dst_vq, 0, sizeof(*dst_vq));
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
+	dst_vq->ops = &rot_vb2_ops;
+	dst_vq->mem_ops = &vb2_dma_contig_memops;
+	dst_vq->drv_priv = ctx;
+	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+
+	return vb2_queue_init(dst_vq);
+}
+
+static int rot_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct rot_ctx *ctx;
+	unsigned long flags;
+	int ret = 0;
+
+	ctx = container_of(ctrl->handler, struct rot_ctx, ctrl_handler);
+	spin_lock_irqsave(&ctx->slock, flags);
+
+	rot_dbg("ctrl ID:%d, value:%d\n", ctrl->id, ctrl->val);
+	switch (ctrl->id) {
+	case V4L2_CID_VFLIP:
+		if (ctrl->val)
+			ctx->flip |= ROT_VFLIP;
+		else
+			ctx->flip &= ~ROT_VFLIP;
+		break;
+	case V4L2_CID_HFLIP:
+		if (ctrl->val)
+			ctx->flip |= ROT_HFLIP;
+		else
+			ctx->flip &= ~ROT_HFLIP;
+		break;
+	case V4L2_CID_ROTATE:
+		ctx->rotation = ctrl->val;
+		break;
+	default:
+		v4l2_err(&ctx->rot_dev->m2m.v4l2_dev, "invalid control id\n");
+		ret = -EINVAL;
+	}
+
+	spin_unlock_irqrestore(&ctx->slock, flags);
+
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops rot_ctrl_ops = {
+	.s_ctrl = rot_s_ctrl,
+};
+
+static int rot_add_ctrls(struct rot_ctx *ctx)
+{
+	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 4);
+	v4l2_ctrl_new_std(&ctx->ctrl_handler, &rot_ctrl_ops,
+			V4L2_CID_VFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&ctx->ctrl_handler, &rot_ctrl_ops,
+			V4L2_CID_HFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&ctx->ctrl_handler, &rot_ctrl_ops,
+			V4L2_CID_ROTATE, 0, 270, 90, 0);
+
+	if (ctx->ctrl_handler.error) {
+		int err = ctx->ctrl_handler.error;
+		v4l2_err(&ctx->rot_dev->m2m.v4l2_dev,
+				"v4l2_ctrl_handler_init failed\n");
+		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+		return err;
+	}
+
+	return 0;
+}
+
+static int rot_open(struct file *file)
+{
+	struct rot_dev *rot = video_drvdata(file);
+	struct rot_ctx *ctx = NULL;
+	int ret;
+
+	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	if (!ctx) {
+		dev_err(rot->dev, "no memory for open context\n");
+		return -ENOMEM;
+	}
+
+	atomic_inc(&rot->m2m.in_use);
+	ctx->rot_dev = rot;
+
+	v4l2_fh_init(&ctx->fh, rot->m2m.vfd);
+	ret = rot_add_ctrls(ctx);
+	if (ret)
+		goto err_fh;
+
+	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
+	file->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
+
+	/* Default color format */
+	ctx->s_frame.rot_fmt = &rot_formats[0];
+	ctx->d_frame.rot_fmt = &rot_formats[0];
+	init_waitqueue_head(&rot->irq.wait);
+	spin_lock_init(&ctx->slock);
+
+	/* Setup the device context for mem2mem mode. */
+	ctx->m2m_ctx = v4l2_m2m_ctx_init(rot->m2m.m2m_dev, ctx, queue_init);
+	if (IS_ERR(ctx->m2m_ctx)) {
+		ret = -EINVAL;
+		goto err_ctx;
+	}
+
+	return 0;
+
+err_ctx:
+	v4l2_fh_del(&ctx->fh);
+err_fh:
+	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+	v4l2_fh_exit(&ctx->fh);
+	atomic_dec(&rot->m2m.in_use);
+	kfree(ctx);
+
+	return ret;
+}
+
+static int rot_release(struct file *file)
+{
+	struct rot_ctx *ctx = fh_to_rot_ctx(file->private_data);
+	struct rot_dev *rot = ctx->rot_dev;
+
+	rot_dbg("refcnt= %d", atomic_read(&rot->m2m.in_use));
+
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	atomic_dec(&rot->m2m.in_use);
+	kfree(ctx);
+
+	return 0;
+}
+
+static unsigned int rot_poll(struct file *file,
+			     struct poll_table_struct *wait)
+{
+	struct rot_ctx *ctx = fh_to_rot_ctx(file->private_data);
+
+	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
+}
+
+static int rot_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct rot_ctx *ctx = fh_to_rot_ctx(file->private_data);
+
+	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+}
+
+static const struct v4l2_file_operations rot_v4l2_fops = {
+	.owner		= THIS_MODULE,
+	.open		= rot_open,
+	.release	= rot_release,
+	.poll		= rot_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= rot_mmap,
+};
+
+static void rot_watchdog(unsigned long arg)
+{
+	struct rot_dev *rot = (struct rot_dev *)arg;
+	struct rot_ctx *ctx;
+	unsigned long flags;
+	struct vb2_buffer *src_vb, *dst_vb;
+
+	rot_dbg("timeout watchdog\n");
+	if (atomic_read(&rot->wdt.cnt) >= ROT_WDT_CNT) {
+		pm_runtime_put(rot->dev);
+
+		rot_dbg("wakeup blocked process\n");
+		atomic_set(&rot->wdt.cnt, 0);
+		clear_bit(DEV_RUN, &rot->state);
+
+		ctx = v4l2_m2m_get_curr_priv(rot->m2m.m2m_dev);
+		if (!ctx || !ctx->m2m_ctx) {
+			dev_err(rot->dev, "current ctx is NULL\n");
+			return;
+		}
+		spin_lock_irqsave(&rot->slock, flags);
+		clear_bit(CTX_RUN, &ctx->flags);
+		src_vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+		dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+
+		if (src_vb && dst_vb) {
+			v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_ERROR);
+			v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_ERROR);
+
+			v4l2_m2m_job_finish(rot->m2m.m2m_dev, ctx->m2m_ctx);
+		}
+		spin_unlock_irqrestore(&rot->slock, flags);
+		return;
+	}
+
+	if (test_bit(DEV_RUN, &rot->state)) {
+		atomic_inc(&rot->wdt.cnt);
+		dev_err(rot->dev, "rotator is still running\n");
+		rot->wdt.timer.expires = jiffies + ROT_TIMEOUT;
+		add_timer(&rot->wdt.timer);
+	} else {
+		rot_dbg("rotator finished job\n");
+	}
+}
+
+static irqreturn_t rot_irq_handler(int irq, void *priv)
+{
+	struct rot_dev *rot = priv;
+	struct rot_ctx *ctx;
+	struct vb2_buffer *src_vb, *dst_vb;
+	unsigned int irq_src;
+
+	spin_lock(&rot->slock);
+
+	clear_bit(DEV_RUN, &rot->state);
+	if (timer_pending(&rot->wdt.timer))
+		del_timer(&rot->wdt.timer);
+
+	rot_hwget_irq_src(rot, &irq_src);
+	rot_hwset_irq_clear(rot, &irq_src);
+
+	if (irq_src != ISR_PEND_DONE) {
+		dev_err(rot->dev, "####################\n");
+		dev_err(rot->dev, "set SFR illegally\n");
+		dev_err(rot->dev, "maybe the result is wrong\n");
+		dev_err(rot->dev, "####################\n");
+		rot_dump_register(rot);
+	}
+
+	ctx = v4l2_m2m_get_curr_priv(rot->m2m.m2m_dev);
+	if (!ctx || !ctx->m2m_ctx) {
+		dev_err(rot->dev, "current ctx is NULL\n");
+		goto isr_unlock;
+	}
+
+	clear_bit(CTX_RUN, &ctx->flags);
+
+	src_vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+	dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+
+	if (src_vb && dst_vb) {
+		v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
+		v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
+
+		if (test_bit(DEV_SUSPEND, &rot->state)) {
+			rot_dbg("wake up blocked process by suspend\n");
+			wake_up(&rot->irq.wait);
+		} else {
+			v4l2_m2m_job_finish(rot->m2m.m2m_dev, ctx->m2m_ctx);
+		}
+
+		/* Wake up from CTX_ABORT state */
+		if (test_and_clear_bit(CTX_ABORT, &ctx->flags))
+			wake_up(&rot->irq.wait);
+
+		pm_runtime_put(rot->dev);
+	} else {
+		dev_err(rot->dev, "failed to get the buffer done\n");
+	}
+
+isr_unlock:
+	spin_unlock(&rot->slock);
+
+	return IRQ_HANDLED;
+}
+
+static void rot_get_bufaddr(struct rot_dev *rot, struct vb2_buffer *vb,
+			    struct rot_frame *frame, struct rot_addr *addr)
+{
+	unsigned int pix_size;
+
+	pix_size = frame->pix_mp.width * frame->pix_mp.height;
+
+	addr->y = vb2_dma_contig_plane_dma_addr(vb, 0);
+	addr->cb = 0;
+	addr->cr = 0;
+
+	switch (frame->rot_fmt->num_comp) {
+	case 2:
+		if (frame->rot_fmt->num_planes == 1)
+			addr->cb = addr->y + pix_size;
+		else if (frame->rot_fmt->num_planes == 2)
+			addr->cb = vb2_dma_contig_plane_dma_addr(vb, 1);
+		break;
+	case 3:
+		if (frame->rot_fmt->num_planes == 3) {
+			addr->cb = vb2_dma_contig_plane_dma_addr(vb, 1);
+			addr->cr = vb2_dma_contig_plane_dma_addr(vb, 2);
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+static void rot_set_frame_addr(struct rot_ctx *ctx)
+{
+	struct vb2_buffer *vb;
+	struct rot_frame *s_frame, *d_frame;
+	struct rot_dev *rot = ctx->rot_dev;
+
+	s_frame = &ctx->s_frame;
+	d_frame = &ctx->d_frame;
+
+	/* set source buffer address */
+	vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	rot_get_bufaddr(rot, vb, s_frame, &s_frame->addr);
+
+	rot_hwset_src_addr(rot, s_frame->addr.y, ROT_ADDR_Y);
+	rot_hwset_src_addr(rot, s_frame->addr.cb, ROT_ADDR_CB);
+	rot_hwset_src_addr(rot, s_frame->addr.cr, ROT_ADDR_CR);
+
+	/* set destination buffer address */
+	vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	rot_get_bufaddr(rot, vb, d_frame, &d_frame->addr);
+
+	rot_hwset_dst_addr(rot, d_frame->addr.y, ROT_ADDR_Y);
+	rot_hwset_dst_addr(rot, d_frame->addr.cb, ROT_ADDR_CB);
+	rot_hwset_dst_addr(rot, d_frame->addr.cr, ROT_ADDR_CR);
+}
+
+static void rot_mapping_flip(struct rot_ctx *ctx, u32 *degree, u32 *flip)
+{
+	*degree = ctx->rotation;
+	*flip = ctx->flip;
+
+	if (ctx->flip == (ROT_VFLIP | ROT_HFLIP)) {
+		*flip = ROT_NOFLIP;
+		switch (ctx->rotation) {
+		case 0:
+			*degree = 180;
+			break;
+		case 90:
+			*degree = 270;
+			break;
+		case 180:
+			*degree = 0;
+			break;
+		case 270:
+			*degree = 90;
+			break;
+		}
+	}
+}
+
+static void rot_m2m_device_run(void *priv)
+{
+	struct rot_ctx *ctx = priv;
+	struct rot_frame *s_frame, *d_frame;
+	struct rot_dev *rot;
+	unsigned long flags, tmp;
+	u32 degree = 0, flip = 0;
+
+	spin_lock_irqsave(&ctx->slock, flags);
+
+	rot = ctx->rot_dev;
+
+	if (test_bit(DEV_RUN, &rot->state)) {
+		dev_err(rot->dev, "Rotator is already in progress\n");
+		goto run_unlock;
+	}
+
+	if (test_bit(DEV_SUSPEND, &rot->state)) {
+		dev_err(rot->dev, "Rotator is in suspend state\n");
+		goto run_unlock;
+	}
+
+	if (test_bit(CTX_ABORT, &ctx->flags)) {
+		rot_dbg("aborted rot device run\n");
+		goto run_unlock;
+	}
+
+	pm_runtime_get_sync(ctx->rot_dev->dev);
+
+	s_frame = &ctx->s_frame;
+	d_frame = &ctx->d_frame;
+
+	/* Configuration rotator registers */
+	rot_hwset_image_format(rot, s_frame->rot_fmt->pixelformat);
+	rot_mapping_flip(ctx, &degree, &flip);
+	rot_hwset_flip(rot, flip);
+	rot_hwset_rotation(rot, degree);
+
+	if (ctx->rotation == 90 || ctx->rotation == 270) {
+		tmp                     = d_frame->pix_mp.height;
+		d_frame->pix_mp.height  = d_frame->pix_mp.width;
+		d_frame->pix_mp.width   = tmp;
+	}
+
+	rot_hwset_src_imgsize(rot, s_frame);
+	rot_hwset_dst_imgsize(rot, d_frame);
+
+	rot_hwset_src_crop(rot, &s_frame->crop);
+	rot_hwset_dst_crop(rot, &d_frame->crop);
+
+	rot_set_frame_addr(ctx);
+
+	/* Enable rotator interrupt */
+	rot_hwset_irq_frame_done(rot, 1);
+	rot_hwset_irq_illegal_config(rot, 1);
+
+	set_bit(DEV_RUN, &rot->state);
+	set_bit(CTX_RUN, &ctx->flags);
+
+	/* Start rotate operation */
+	rot_hwset_start(rot);
+
+	/* Start watchdog timer */
+	rot->wdt.timer.expires = jiffies + ROT_TIMEOUT;
+	if (timer_pending(&rot->wdt.timer) == 0)
+		add_timer(&rot->wdt.timer);
+	else
+		mod_timer(&rot->wdt.timer, rot->wdt.timer.expires);
+
+run_unlock:
+	spin_unlock_irqrestore(&ctx->slock, flags);
+}
+
+static void rot_m2m_job_abort(void *priv)
+{
+	struct rot_ctx *ctx = priv;
+	int ret;
+
+	ret = rot_ctx_stop_req(ctx);
+	if (ret < 0)
+		dev_err(ctx->rot_dev->dev, "wait timeout\n");
+}
+
+static struct v4l2_m2m_ops rot_m2m_ops = {
+	.device_run	= rot_m2m_device_run,
+	.job_abort	= rot_m2m_job_abort,
+};
+
+static int rot_register_m2m_device(struct rot_dev *rot)
+{
+	struct v4l2_device *v4l2_dev;
+	struct device *dev;
+	struct video_device *vfd;
+	int ret = 0;
+
+	if (!rot)
+		return -ENODEV;
+
+	dev = rot->dev;
+	v4l2_dev = &rot->m2m.v4l2_dev;
+
+	snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "%s.m2m",
+			MODULE_NAME);
+
+	ret = v4l2_device_register(dev, v4l2_dev);
+	if (ret) {
+		dev_err(rot->dev, "failed to register v4l2 device\n");
+		return ret;
+	}
+
+	vfd = video_device_alloc();
+	if (!vfd) {
+		dev_err(rot->dev, "failed to allocate video device\n");
+		goto err_v4l2_dev;
+	}
+
+	vfd->fops	= &rot_v4l2_fops;
+	vfd->ioctl_ops	= &rot_v4l2_ioctl_ops;
+	vfd->release	= video_device_release;
+	snprintf(vfd->name, sizeof(vfd->name), "%s:m2m", MODULE_NAME);
+
+	video_set_drvdata(vfd, rot);
+
+	rot->m2m.vfd = vfd;
+	rot->m2m.m2m_dev = v4l2_m2m_init(&rot_m2m_ops);
+	if (IS_ERR(rot->m2m.m2m_dev)) {
+		dev_err(rot->dev, "failed to initialize v4l2-m2m device\n");
+		ret = PTR_ERR(rot->m2m.m2m_dev);
+		goto err_dev_alloc;
+	}
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
+	if (ret) {
+		dev_err(rot->dev, "failed to register video device\n");
+		goto err_m2m_dev;
+	}
+
+	return 0;
+
+err_m2m_dev:
+	v4l2_m2m_release(rot->m2m.m2m_dev);
+err_dev_alloc:
+	video_device_release(rot->m2m.vfd);
+err_v4l2_dev:
+	v4l2_device_unregister(v4l2_dev);
+
+	return ret;
+}
+
+static int rot_suspend(struct device *dev)
+{
+	struct rot_dev *rot;
+	int ret = 0;
+
+	rot = dev_get_drvdata(dev);
+	set_bit(DEV_SUSPEND, &rot->state);
+
+	ret = wait_event_timeout(rot->irq.wait,
+			!test_bit(DEV_RUN, &rot->state), ROT_TIMEOUT);
+	if (ret == 0)
+		dev_err(rot->dev, "wait timeout\n");
+
+	return 0;
+}
+
+static int rot_resume(struct device *dev)
+{
+	struct rot_dev *rot;
+
+	rot = dev_get_drvdata(dev);
+	clear_bit(DEV_SUSPEND, &rot->state);
+
+	return 0;
+}
+
+static int rot_runtime_suspend(struct device *dev)
+{
+	struct rot_dev *rot;
+	struct platform_device *pdev;
+
+	pdev = to_platform_device(dev);
+	rot = (struct rot_dev *)platform_get_drvdata(pdev);
+
+	clk_disable(rot->clock);
+
+	return 0;
+}
+
+static int rot_runtime_resume(struct device *dev)
+{
+	struct rot_dev *rot;
+	struct platform_device *pdev;
+
+	pdev = to_platform_device(dev);
+	rot = (struct rot_dev *)platform_get_drvdata(pdev);
+
+	clk_enable(rot->clock);
+
+	return 0;
+}
+
+static const struct dev_pm_ops rot_pm_ops = {
+	.suspend		= rot_suspend,
+	.resume			= rot_resume,
+	.runtime_suspend	= rot_runtime_suspend,
+	.runtime_resume		= rot_runtime_resume,
+};
+
+static int rot_probe(struct platform_device *pdev)
+{
+	struct exynos_rot_driverdata *drv_data;
+	struct rot_dev *rot;
+	struct resource *res;
+	int variant_num, ret = 0;
+
+	dev_info(&pdev->dev, "++%s\n", __func__);
+	drv_data = (struct exynos_rot_driverdata *)
+			platform_get_device_id(pdev)->driver_data;
+
+	if (pdev->id >= drv_data->nr_dev) {
+		dev_err(&pdev->dev, "Invalid platform device id\n");
+		return -EINVAL;
+	}
+
+	rot = devm_kzalloc(&pdev->dev, sizeof(struct rot_dev), GFP_KERNEL);
+	if (!rot) {
+		dev_err(&pdev->dev, "no memory for rotator device\n");
+		return -ENOMEM;
+	}
+
+	rot->dev = &pdev->dev;
+	rot->id = pdev->id;
+	variant_num = (rot->id < 0) ? 0 : rot->id;
+	rot->variant = drv_data->variant[variant_num];
+
+	spin_lock_init(&rot->slock);
+
+	/* Get memory resource and map SFR region. */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	rot->regs = devm_request_and_ioremap(&pdev->dev, res);
+	if (rot->regs == NULL) {
+		dev_err(&pdev->dev, "failed to claim register region\n");
+		return -ENOENT;
+	}
+
+	/* Get IRQ resource and register IRQ handler. */
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "failed to get IRQ resource\n");
+		return -ENXIO;
+	}
+	rot->irq.num = res->start;
+
+	ret = devm_request_irq(&pdev->dev, rot->irq.num, rot_irq_handler, 0,
+			pdev->name, rot);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to install irq\n");
+		return ret;
+	}
+
+	atomic_set(&rot->wdt.cnt, 0);
+	setup_timer(&rot->wdt.timer, rot_watchdog, (unsigned long)rot);
+
+	rot->clock = clk_get(rot->dev, "rotator");
+	if (IS_ERR(rot->clock)) {
+		dev_err(&pdev->dev, "failed to get clock for rotator\n");
+		return -ENXIO;
+	}
+
+	rot->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	if (IS_ERR(rot->alloc_ctx)) {
+		dev_err(&pdev->dev, "failed to get alloc_ctx\n");
+		ret = -EPERM;
+		goto err;
+	}
+
+	ret = rot_register_m2m_device(rot);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register m2m device\n");
+		ret = -EPERM;
+		goto err;
+	}
+
+#ifdef CONFIG_PM_RUNTIME
+	pm_runtime_enable(&pdev->dev);
+#else
+	rot_runtime_resume(&pdev->dev);
+#endif
+
+	dev_info(&pdev->dev, "rotator registered successfully\n");
+
+	return 0;
+
+err:
+	clk_put(rot->clock);
+	return ret;
+}
+
+static int rot_remove(struct platform_device *pdev)
+{
+	struct rot_dev *rot = (struct rot_dev *)platform_get_drvdata(pdev);
+
+	clk_put(rot->clock);
+#ifdef CONFIG_PM_RUNTIME
+	pm_runtime_disable(&pdev->dev);
+#else
+	rot_runtime_suspend(&pdev->dev);
+#endif
+
+	if (timer_pending(&rot->wdt.timer))
+		del_timer(&rot->wdt.timer);
+
+	return 0;
+}
+
+static struct exynos_rot_variant rot_variant_exynos = {
+	.limit_rgb565 = {
+		.min_x = 16,
+		.min_y = 16,
+		.max_x = SZ_16K,
+		.max_y = SZ_16K,
+		.align = 2,
+	},
+	.limit_rgb888 = {
+		.min_x = 8,
+		.min_y = 8,
+		.max_x = SZ_8K,
+		.max_y = SZ_8K,
+		.align = 2,
+	},
+	.limit_yuv422 = {
+		.min_x = 16,
+		.min_y = 16,
+		.max_x = SZ_16K,
+		.max_y = SZ_16K,
+		.align = 2,
+	},
+	.limit_yuv420_2p = {
+		.min_x = 32,
+		.min_y = 32,
+		.max_x = SZ_32K,
+		.max_y = SZ_32K,
+		.align = 3,
+	},
+	.limit_yuv420_3p = {
+		.min_x = 64,
+		.min_y = 32,
+		.max_x = SZ_32K,
+		.max_y = SZ_32K,
+		.align = 4,
+	},
+};
+
+static struct exynos_rot_driverdata rot_drvdata_exynos = {
+	.variant = {
+		[0] = &rot_variant_exynos,
+	},
+	.nr_dev = 1,
+};
+
+static struct platform_device_id rot_driver_ids[] = {
+	{
+		.name		= MODULE_NAME,
+		.driver_data	= (unsigned long)&rot_drvdata_exynos,
+	},
+	{},
+};
+
+static struct platform_driver rot_driver = {
+	.probe		= rot_probe,
+	.remove		= rot_remove,
+	.id_table	= rot_driver_ids,
+	.driver = {
+		.name	= MODULE_NAME,
+		.owner	= THIS_MODULE,
+		.pm	= &rot_pm_ops,
+	}
+};
+
+module_platform_driver(rot_driver);
+
+MODULE_AUTHOR("Sunyoung, Kang <sy0816.kang@samsung.com>");
+MODULE_AUTHOR("Ayoung, Sim <a.sim@samsung.com>");
+MODULE_DESCRIPTION("Exynos Image Rotator driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/exynos/rotator/rotator-regs.c b/drivers/media/video/exynos/rotator/rotator-regs.c
new file mode 100644
index 0000000..dcb71cf
--- /dev/null
+++ b/drivers/media/video/exynos/rotator/rotator-regs.c
@@ -0,0 +1,215 @@
+/*
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Register interface file for Exynos Rotator driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include "rotator.h"
+
+void rot_hwset_irq_frame_done(struct rot_dev *rot, u32 enable)
+{
+	unsigned long cfg = readl(rot->regs + ROTATOR_CONFIG);
+
+	if (enable)
+		cfg |= ROTATOR_CONFIG_IRQ_DONE;
+	else
+		cfg &= ~ROTATOR_CONFIG_IRQ_DONE;
+
+	writel(cfg, rot->regs + ROTATOR_CONFIG);
+}
+
+void rot_hwset_irq_illegal_config(struct rot_dev *rot, u32 enable)
+{
+	unsigned long cfg = readl(rot->regs + ROTATOR_CONFIG);
+
+	if (enable)
+		cfg |= ROTATOR_CONFIG_IRQ_ILLEGAL;
+	else
+		cfg &= ~ROTATOR_CONFIG_IRQ_ILLEGAL;
+
+	writel(cfg, rot->regs + ROTATOR_CONFIG);
+}
+
+int rot_hwset_image_format(struct rot_dev *rot, u32 pixelformat)
+{
+	unsigned long cfg = readl(rot->regs + ROTATOR_CONTROL);
+	cfg &= ~ROTATOR_CONTROL_FMT_MASK;
+
+	switch (pixelformat) {
+	case V4L2_PIX_FMT_YUV420M:
+		cfg |= ROTATOR_CONTROL_FMT_YCBCR420_3P;
+		break;
+	case V4L2_PIX_FMT_NV12M:
+		cfg |= ROTATOR_CONTROL_FMT_YCBCR420_2P;
+		break;
+	case V4L2_PIX_FMT_YUYV:
+		cfg |= ROTATOR_CONTROL_FMT_YCBCR422;
+		break;
+	case V4L2_PIX_FMT_RGB565:
+		cfg |= ROTATOR_CONTROL_FMT_RGB565;
+		break;
+	case V4L2_PIX_FMT_RGB32:
+		cfg |= ROTATOR_CONTROL_FMT_RGB888;
+		break;
+	default:
+		dev_err(rot->dev, "invalid pixelformat type\n");
+		return -EINVAL;
+	}
+	writel(cfg, rot->regs + ROTATOR_CONTROL);
+	return 0;
+}
+
+void rot_hwset_flip(struct rot_dev *rot, u32 direction)
+{
+	unsigned long cfg = readl(rot->regs + ROTATOR_CONTROL);
+	cfg &= ~ROTATOR_CONTROL_FLIP_MASK;
+
+	if (direction == ROT_VFLIP)
+		cfg |= ROTATOR_CONTROL_FLIP_V;
+	else if (direction == ROT_HFLIP)
+		cfg |= ROTATOR_CONTROL_FLIP_H;
+
+	writel(cfg, rot->regs + ROTATOR_CONTROL);
+}
+
+void rot_hwset_rotation(struct rot_dev *rot, int degree)
+{
+	unsigned long cfg = readl(rot->regs + ROTATOR_CONTROL);
+	cfg &= ~ROTATOR_CONTROL_ROT_MASK;
+
+	if (degree == 90)
+		cfg |= ROTATOR_CONTROL_ROT_90;
+	else if (degree == 180)
+		cfg |= ROTATOR_CONTROL_ROT_180;
+	else if (degree == 270)
+		cfg |= ROTATOR_CONTROL_ROT_270;
+
+	writel(cfg, rot->regs + ROTATOR_CONTROL);
+}
+
+void rot_hwset_start(struct rot_dev *rot)
+{
+	unsigned long cfg = readl(rot->regs + ROTATOR_CONTROL);
+
+	cfg |= ROTATOR_CONTROL_START;
+
+	writel(cfg, rot->regs + ROTATOR_CONTROL);
+}
+
+void rot_hwset_src_addr(struct rot_dev *rot, dma_addr_t addr, u32 comp)
+{
+	writel(addr, rot->regs + ROTATOR_SRC_IMG_ADDR(comp));
+}
+
+void rot_hwset_dst_addr(struct rot_dev *rot, dma_addr_t addr, u32 comp)
+{
+	writel(addr, rot->regs + ROTATOR_DST_IMG_ADDR(comp));
+}
+
+void rot_hwset_src_imgsize(struct rot_dev *rot, struct rot_frame *frame)
+{
+	unsigned long cfg;
+
+	cfg = ROTATOR_SRCIMG_YSIZE(frame->pix_mp.height) |
+		ROTATOR_SRCIMG_XSIZE(frame->pix_mp.width);
+
+	writel(cfg, rot->regs + ROTATOR_SRCIMG);
+
+	cfg = ROTATOR_SRCROT_YSIZE(frame->pix_mp.height) |
+		ROTATOR_SRCROT_XSIZE(frame->pix_mp.width);
+
+	writel(cfg, rot->regs + ROTATOR_SRCROT);
+}
+
+void rot_hwset_src_crop(struct rot_dev *rot, struct v4l2_rect *rect)
+{
+	unsigned long cfg;
+
+	cfg = ROTATOR_SRC_Y(rect->top) |
+		ROTATOR_SRC_X(rect->left);
+
+	writel(cfg, rot->regs + ROTATOR_SRC);
+
+	cfg = ROTATOR_SRCROT_YSIZE(rect->height) |
+		ROTATOR_SRCROT_XSIZE(rect->width);
+
+	writel(cfg, rot->regs + ROTATOR_SRCROT);
+}
+
+void rot_hwset_dst_imgsize(struct rot_dev *rot, struct rot_frame *frame)
+{
+	unsigned long cfg;
+
+	cfg = ROTATOR_DSTIMG_YSIZE(frame->pix_mp.height) |
+		ROTATOR_DSTIMG_XSIZE(frame->pix_mp.width);
+
+	writel(cfg, rot->regs + ROTATOR_DSTIMG);
+}
+
+void rot_hwset_dst_crop(struct rot_dev *rot, struct v4l2_rect *rect)
+{
+	unsigned long cfg;
+
+	cfg =  ROTATOR_DST_Y(rect->top) |
+		ROTATOR_DST_X(rect->left);
+
+	writel(cfg, rot->regs + ROTATOR_DST);
+}
+
+void rot_hwget_irq_src(struct rot_dev *rot, enum rot_irq_src *irq)
+{
+	unsigned long cfg = readl(rot->regs + ROTATOR_STATUS);
+	cfg = ROTATOR_STATUS_IRQ(cfg);
+
+	if (cfg == 1)
+		*irq = ISR_PEND_DONE;
+	else if (cfg == 2)
+		*irq = ISR_PEND_ILLEGAL;
+}
+
+void rot_hwset_irq_clear(struct rot_dev *rot, enum rot_irq_src *irq)
+{
+	unsigned long cfg = readl(rot->regs + ROTATOR_STATUS);
+	cfg |= ROTATOR_STATUS_IRQ_PENDING((u32)irq);
+
+	writel(cfg, rot->regs + ROTATOR_STATUS);
+}
+
+void rot_hwget_status(struct rot_dev *rot, enum rot_status *state)
+{
+	unsigned long cfg;
+
+	cfg = readl(rot->regs + ROTATOR_STATUS);
+	cfg &= ROTATOR_STATUS_MASK;
+
+	switch (cfg) {
+	case 0:
+		*state = ROT_IDLE;
+		break;
+	case 1:
+		*state = ROT_RESERVED;
+		break;
+	case 2:
+		*state = ROT_RUNNING;
+		break;
+	case 3:
+		*state = ROT_RUNNING_REMAIN;
+		break;
+	};
+}
+
+void rot_dump_register(struct rot_dev *rot)
+{
+	unsigned int tmp, i;
+
+	rot_dbg("dump rotator registers\n");
+	for (i = 0; i <= ROTATOR_DST; i += 0x4) {
+		tmp = readl(rot->regs + i);
+		rot_dbg("0x%08x: 0x%08x", i, tmp);
+	}
+}
diff --git a/drivers/media/video/exynos/rotator/rotator-regs.h b/drivers/media/video/exynos/rotator/rotator-regs.h
new file mode 100644
index 0000000..a603417
--- /dev/null
+++ b/drivers/media/video/exynos/rotator/rotator-regs.h
@@ -0,0 +1,70 @@
+/*
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Register header file for Exynos Rotator driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+/* Configuration */
+#define ROTATOR_CONFIG				0x00
+#define ROTATOR_CONFIG_IRQ_ILLEGAL		(1 << 9)
+#define ROTATOR_CONFIG_IRQ_DONE			(1 << 8)
+
+/* Image0 Control */
+#define ROTATOR_CONTROL				0x10
+#define ROTATOR_CONTROL_PATTERN_WRITE		(1 << 16)
+#define ROTATOR_CONTROL_FMT_YCBCR420_3P		(0 << 8)
+#define ROTATOR_CONTROL_FMT_YCBCR420_2P		(1 << 8)
+#define ROTATOR_CONTROL_FMT_YCBCR422		(3 << 8)
+#define ROTATOR_CONTROL_FMT_RGB565		(4 << 8)
+#define ROTATOR_CONTROL_FMT_RGB888		(6 << 8)
+#define ROTATOR_CONTROL_FMT_MASK		(7 << 8)
+#define ROTATOR_CONTROL_FLIP_V			(2 << 6)
+#define ROTATOR_CONTROL_FLIP_H			(3 << 6)
+#define ROTATOR_CONTROL_FLIP_MASK		(3 << 6)
+#define ROTATOR_CONTROL_ROT_90			(1 << 4)
+#define ROTATOR_CONTROL_ROT_180			(2 << 4)
+#define ROTATOR_CONTROL_ROT_270			(3 << 4)
+#define ROTATOR_CONTROL_ROT_MASK		(3 << 4)
+#define ROTATOR_CONTROL_START			(1 << 0)
+
+/* Status */
+#define ROTATOR_STATUS				0x20
+#define ROTATOR_STATUS_IRQ_PENDING(x)		(1 << (x))
+#define ROTATOR_STATUS_IRQ(x)			(((x) >> 8) & 0x3)
+#define ROTATOR_STATUS_MASK			(3 << 0)
+
+/* Sourc Image Base Address */
+#define ROTATOR_SRC_IMG_ADDR(n)			(0x30 + ((n) << 2))
+
+/* Source Image X,Y Size */
+#define ROTATOR_SRCIMG				0x3c
+#define ROTATOR_SRCIMG_YSIZE(x)			((x) << 16)
+#define ROTATOR_SRCIMG_XSIZE(x)			((x) << 0)
+
+/* Source Image X,Y Coordinates */
+#define ROTATOR_SRC				0x40
+#define ROTATOR_SRC_Y(x)			((x) << 16)
+#define ROTATOR_SRC_X(x)			((x) << 0)
+
+/* Source Image Rotation Size */
+#define ROTATOR_SRCROT				0x44
+#define ROTATOR_SRCROT_YSIZE(x)			((x) << 16)
+#define ROTATOR_SRCROT_XSIZE(x)			((x) << 0)
+
+/* Destination Image Base Address */
+#define ROTATOR_DST_IMG_ADDR(n)			(0x50 + ((n) << 2))
+
+/* Destination Image X,Y Size */
+#define ROTATOR_DSTIMG				0x5c
+#define ROTATOR_DSTIMG_YSIZE(x)			((x) << 16)
+#define ROTATOR_DSTIMG_XSIZE(x)			((x) << 0)
+
+/* Destination Image X,Y Coordinates */
+#define ROTATOR_DST				0x60
+#define ROTATOR_DST_Y(x)			((x) << 16)
+#define ROTATOR_DST_X(x)			((x) << 0)
diff --git a/drivers/media/video/exynos/rotator/rotator.h b/drivers/media/video/exynos/rotator/rotator.h
new file mode 100644
index 0000000..4034383
--- /dev/null
+++ b/drivers/media/video/exynos/rotator/rotator.h
@@ -0,0 +1,286 @@
+/*
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Header file for Exynos Rotator driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef ROTATOR__H_
+#define ROTATOR__H_
+
+#include <linux/delay.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/videodev2.h>
+#include <linux/io.h>
+#include <linux/pm_runtime.h>
+#include <media/videobuf2-core.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-mem2mem.h>
+
+#include "rotator-regs.h"
+
+extern int log_level;
+
+#define rot_dbg(fmt, args...)						\
+	do {								\
+		if (log_level)						\
+			printk(KERN_DEBUG "[%s:%d] "			\
+			fmt, __func__, __LINE__, ##args);		\
+	} while (0)
+
+/* Time to wait for frame done interrupt */
+#define ROT_TIMEOUT			(2 * HZ)
+#define ROT_WDT_CNT			5
+#define MODULE_NAME		"exynos-rot"
+#define ROT_MAX_DEVS			1
+
+/* Address index */
+#define ROT_ADDR_RGB			0
+#define ROT_ADDR_Y			0
+#define ROT_ADDR_CB			1
+#define ROT_ADDR_CBCR			1
+#define ROT_ADDR_CR			2
+
+/* Rotator flip direction */
+#define ROT_NOFLIP		(1 << 0)
+#define ROT_VFLIP		(1 << 1)
+#define ROT_HFLIP		(1 << 2)
+
+/* Rotator hardware device state */
+#define DEV_RUN			(1 << 0)
+#define DEV_SUSPEND		(1 << 1)
+
+/* Rotator m2m context state */
+#define CTX_PARAMS		(1 << 0)
+#define CTX_STREAMING		(1 << 1)
+#define CTX_RUN			(1 << 2)
+#define CTX_ABORT		(1 << 3)
+#define CTX_SRC			(1 << 4)
+#define CTX_DST			(1 << 5)
+
+enum rot_irq_src {
+	ISR_PEND_DONE = 8,
+	ISR_PEND_ILLEGAL = 9,
+};
+
+enum rot_status {
+	ROT_IDLE,
+	ROT_RESERVED,
+	ROT_RUNNING,
+	ROT_RUNNING_REMAIN,
+};
+
+/*
+ * struct exynos_rot_size_limit - Rotator variant size  information
+ *
+ * @min_x: minimum pixel x size
+ * @min_y: minimum pixel y size
+ * @max_x: maximum pixel x size
+ * @max_y: maximum pixel y size
+ */
+struct exynos_rot_size_limit {
+	u32 min_x;
+	u32 min_y;
+	u32 max_x;
+	u32 max_y;
+	u32 align;
+};
+
+struct exynos_rot_variant {
+	struct exynos_rot_size_limit limit_rgb565;
+	struct exynos_rot_size_limit limit_rgb888;
+	struct exynos_rot_size_limit limit_yuv422;
+	struct exynos_rot_size_limit limit_yuv420_2p;
+	struct exynos_rot_size_limit limit_yuv420_3p;
+};
+
+/*
+ * struct exynos_rot_driverdata - per device type driver data for init time.
+ *
+ * @variant: the variant information for this driver.
+ * @nr_dev: number of devices available in SoC
+ */
+struct exynos_rot_driverdata {
+	struct exynos_rot_variant	*variant[ROT_MAX_DEVS];
+	int				nr_dev;
+};
+
+/**
+ * struct rot_fmt - the driver's internal color format data
+ * @name: format description
+ * @pixelformat: the fourcc code for this format, 0 if not applicable
+ * @num_planes: number of physically non-contiguous data planes
+ * @num_comp: number of color components(ex. RGB, Y, Cb, Cr)
+ * @bitperpixel: bits per pixel
+ */
+struct rot_fmt {
+	char	*name;
+	u32	pixelformat;
+	u16	num_planes;
+	u16	num_comp;
+	u32	bitperpixel[VIDEO_MAX_PLANES];
+};
+
+struct rot_addr {
+	dma_addr_t	y;
+	dma_addr_t	cb;
+	dma_addr_t	cr;
+};
+
+/*
+ * struct rot_frame - source/target frame properties
+ * @fmt:	buffer format(like virtual screen)
+ * @crop:	image size / position
+ * @addr:	buffer start address(access using ROT_ADDR_XXX)
+ * @bytesused:	image size in bytes (w x h x bpp)
+ * @cacheable:	cache property for image address
+ */
+struct rot_frame {
+	struct rot_fmt			*rot_fmt;
+	struct v4l2_pix_format_mplane	pix_mp;
+	struct v4l2_rect		crop;
+	struct rot_addr			addr;
+	unsigned long			bytesused[VIDEO_MAX_PLANES];
+	bool				cacheable;
+};
+
+/*
+ * struct rot_m2m_device - v4l2 memory-to-memory device data
+ * @v4l2_dev: v4l2 device
+ * @vfd: the video device node
+ * @m2m_dev: v4l2 memory-to-memory device data
+ * @in_use: the open count
+ */
+struct rot_m2m_device {
+	struct v4l2_device	v4l2_dev;
+	struct video_device	*vfd;
+	struct v4l2_m2m_dev	*m2m_dev;
+	atomic_t		in_use;
+};
+
+/*
+ * struct rot_irq - Rotator irq information
+ * @num:	Rotator interrupt number
+ * @wait:	interrupt handler waitqueue
+ */
+struct rot_irq {
+	int			num;
+	wait_queue_head_t	wait;
+};
+
+struct rot_wdt {
+	struct timer_list	timer;
+	atomic_t		cnt;
+};
+
+struct rot_ctx;
+struct rot_vb2;
+
+/*
+ * struct rot_dev - the abstraction for Rotator device
+ * @dev:	pointer to the Rotator device
+ * @pdata:	pointer to the device platform data
+ * @variant:	the IP variant information
+ * @m2m:	memory-to-memory V4L2 device information
+ * @id:		Rotator device index (0..ROT_MAX_DEVS)
+ * @clock:	clock required for Rotator operation
+ * @regs:	the mapped hardware registers
+ * @regs_res:	the resource claimed for IO registers
+ * @irq:	irq information
+ * @ws:		work struct
+ * @state:	device state flags
+ * @alloc_ctx:	videobuf2 memory allocator context
+ * @rot_vb2:	videobuf2 memory allocator callbacks
+ * @slock:	the spinlock protecting this data structure
+ * @lock:	the mutex protecting this data structure
+ * @wdt:	watchdog timer information
+ */
+struct rot_dev {
+	struct device			*dev;
+	struct exynos_platform_rot	*pdata;
+	struct exynos_rot_variant	*variant;
+	struct rot_m2m_device		m2m;
+	int				id;
+	struct clk			*clock;
+	void __iomem			*regs;
+	struct rot_irq			irq;
+	struct work_struct		ws;
+	unsigned long			state;
+	struct vb2_alloc_ctx		*alloc_ctx;
+	const struct rot_vb2		*vb2;
+	spinlock_t			slock;
+	struct mutex			lock;
+	struct rot_wdt			wdt;
+};
+
+/*
+ * rot_ctx - the abstration for Rotator open context
+ * @rot_dev:		the Rotator device this context applies to
+ * @m2m_ctx:		memory-to-memory device context
+ * @frame:		source frame properties
+ * @ctrl_handler:	v4l2 controls handler
+ * @fh:			v4l2 file handle
+ * @rotation:		image clockwise rotation in degrees
+ * @flip:		image flip mode
+ * @state:		context state flags
+ * @slock:		spinlock protecting this data structure
+ */
+struct rot_ctx {
+	struct rot_dev		*rot_dev;
+	struct v4l2_m2m_ctx	*m2m_ctx;
+	struct rot_frame	s_frame;
+	struct rot_frame	d_frame;
+	struct v4l2_ctrl_handler	ctrl_handler;
+	struct v4l2_fh			fh;
+	int			rotation;
+	u32			flip;
+	unsigned long		flags;
+	spinlock_t		slock;
+};
+
+static inline struct rot_frame *ctx_get_frame(struct rot_ctx *ctx,
+						enum v4l2_buf_type type)
+{
+	struct rot_frame *frame;
+
+	if (V4L2_TYPE_IS_MULTIPLANAR(type)) {
+		if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+			frame = &ctx->s_frame;
+		else
+			frame = &ctx->d_frame;
+	} else {
+		dev_err(ctx->rot_dev->dev,
+				"Wrong V4L2 buffer type %d\n", type);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return frame;
+}
+
+#define fh_to_rot_ctx(__fh)	container_of(__fh, struct rot_ctx, fh)
+
+void rot_hwset_irq_frame_done(struct rot_dev *rot, u32 enable);
+void rot_hwset_irq_illegal_config(struct rot_dev *rot, u32 enable);
+int rot_hwset_image_format(struct rot_dev *rot, u32 pixelformat);
+void rot_hwset_flip(struct rot_dev *rot, u32 direction);
+void rot_hwset_rotation(struct rot_dev *rot, int degree);
+void rot_hwset_start(struct rot_dev *rot);
+void rot_hwset_src_addr(struct rot_dev *rot, dma_addr_t addr, u32 comp);
+void rot_hwset_dst_addr(struct rot_dev *rot, dma_addr_t addr, u32 comp);
+void rot_hwset_src_imgsize(struct rot_dev *rot, struct rot_frame *frame);
+void rot_hwset_src_crop(struct rot_dev *rot, struct v4l2_rect *rect);
+void rot_hwset_dst_imgsize(struct rot_dev *rot, struct rot_frame *frame);
+void rot_hwset_dst_crop(struct rot_dev *rot, struct v4l2_rect *rect);
+void rot_hwget_irq_src(struct rot_dev *rot, enum rot_irq_src *irq);
+void rot_hwset_irq_clear(struct rot_dev *rot, enum rot_irq_src *irq);
+void rot_hwget_status(struct rot_dev *rot, enum rot_status *state);
+void rot_dump_register(struct rot_dev *rot);
+
+#endif /* ROTATOR__H_ */
-- 
1.7.1


