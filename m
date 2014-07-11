Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:64325 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbaGKPT4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 11:19:56 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N8J00GA5ZX72J60@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 12 Jul 2014 00:19:55 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, andrzej.p@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 1/9] s5p-jpeg: Add support for Exynos3250 SoC
Date: Fri, 11 Jul 2014 17:19:42 +0200
Message-id: <1405091990-28567-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1405091990-28567-1-git-send-email-j.anaszewski@samsung.com>
References: <1405091990-28567-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for jpeg codec on Exynos3250 SoC to
the s5p-jpeg driver. Supported raw formats are: YUYV, YVYU, UYVY,
VYUY, RGB565, RGB565X, RGB32, NV12, NV21. The support includes
also scaling and cropping features.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/Kconfig                     |    5 +-
 drivers/media/platform/s5p-jpeg/Makefile           |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  533 +++++++++++++++++++-
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |   33 +-
 .../media/platform/s5p-jpeg/jpeg-hw-exynos3250.c   |  489 ++++++++++++++++++
 .../media/platform/s5p-jpeg/jpeg-hw-exynos3250.h   |   60 +++
 drivers/media/platform/s5p-jpeg/jpeg-regs.h        |  247 ++++++++-
 7 files changed, 1347 insertions(+), 22 deletions(-)
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 8108c69..3077bba 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -165,12 +165,13 @@ config VIDEO_SAMSUNG_S5P_G2D
 	  2d graphics accelerator.
 
 config VIDEO_SAMSUNG_S5P_JPEG
-	tristate "Samsung S5P/Exynos4 JPEG codec driver"
+	tristate "Samsung S5P/Exynos3250/Exynos4 JPEG codec driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && (PLAT_S5P || ARCH_EXYNOS)
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	---help---
-	  This is a v4l2 driver for Samsung S5P and EXYNOS4 JPEG codec
+	  This is a v4l2 driver for Samsung S5P, EXYNOS3250
+	  and EXYNOS4 JPEG codec
 
 config VIDEO_SAMSUNG_S5P_MFC
 	tristate "Samsung S5P MFC Video Codec"
diff --git a/drivers/media/platform/s5p-jpeg/Makefile b/drivers/media/platform/s5p-jpeg/Makefile
index a1a9169..9e5f214 100644
--- a/drivers/media/platform/s5p-jpeg/Makefile
+++ b/drivers/media/platform/s5p-jpeg/Makefile
@@ -1,2 +1,2 @@
-s5p-jpeg-objs := jpeg-core.o jpeg-hw-exynos4.o jpeg-hw-s5p.o
+s5p-jpeg-objs := jpeg-core.o jpeg-hw-exynos3250.o jpeg-hw-exynos4.o jpeg-hw-s5p.o
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG) += s5p-jpeg.o
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 0dcb796..7d604f2 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1,6 +1,6 @@
 /* linux/drivers/media/platform/s5p-jpeg/jpeg-core.c
  *
- * Copyright (c) 2011-2013 Samsung Electronics Co., Ltd.
+ * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
  * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
@@ -32,6 +32,7 @@
 #include "jpeg-core.h"
 #include "jpeg-hw-s5p.h"
 #include "jpeg-hw-exynos4.h"
+#include "jpeg-hw-exynos3250.h"
 #include "jpeg-regs.h"
 
 static struct s5p_jpeg_fmt sjpeg_formats[] = {
@@ -41,6 +42,7 @@ static struct s5p_jpeg_fmt sjpeg_formats[] = {
 		.flags		= SJPEG_FMT_FLAG_ENC_CAPTURE |
 				  SJPEG_FMT_FLAG_DEC_OUTPUT |
 				  SJPEG_FMT_FLAG_S5P |
+				  SJPEG_FMT_FLAG_EXYNOS3250 |
 				  SJPEG_FMT_FLAG_EXYNOS4,
 	},
 	{
@@ -70,6 +72,19 @@ static struct s5p_jpeg_fmt sjpeg_formats[] = {
 		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_422,
 	},
 	{
+		.name		= "YUV 4:2:2 packed, YCbYCr",
+		.fourcc		= V4L2_PIX_FMT_YUYV,
+		.depth		= 16,
+		.colplanes	= 1,
+		.h_align	= 2,
+		.v_align	= 0,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_EXYNOS3250 |
+				  SJPEG_FMT_NON_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_422,
+	},
+	{
 		.name		= "YUV 4:2:2 packed, YCrYCb",
 		.fourcc		= V4L2_PIX_FMT_YVYU,
 		.depth		= 16,
@@ -83,6 +98,45 @@ static struct s5p_jpeg_fmt sjpeg_formats[] = {
 		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_422,
 	},
 	{
+		.name		= "YUV 4:2:2 packed, YCrYCb",
+		.fourcc		= V4L2_PIX_FMT_YVYU,
+		.depth		= 16,
+		.colplanes	= 1,
+		.h_align	= 2,
+		.v_align	= 0,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_EXYNOS3250 |
+				  SJPEG_FMT_NON_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_422,
+	},
+	{
+		.name		= "YUV 4:2:2 packed, YCrYCb",
+		.fourcc		= V4L2_PIX_FMT_UYVY,
+		.depth		= 16,
+		.colplanes	= 1,
+		.h_align	= 2,
+		.v_align	= 0,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_EXYNOS3250 |
+				  SJPEG_FMT_NON_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_422,
+	},
+	{
+		.name		= "YUV 4:2:2 packed, YCrYCb",
+		.fourcc		= V4L2_PIX_FMT_VYUY,
+		.depth		= 16,
+		.colplanes	= 1,
+		.h_align	= 2,
+		.v_align	= 0,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_EXYNOS3250 |
+				  SJPEG_FMT_NON_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_422,
+	},
+	{
 		.name		= "RGB565",
 		.fourcc		= V4L2_PIX_FMT_RGB565,
 		.depth		= 16,
@@ -100,6 +154,32 @@ static struct s5p_jpeg_fmt sjpeg_formats[] = {
 		.fourcc		= V4L2_PIX_FMT_RGB565,
 		.depth		= 16,
 		.colplanes	= 1,
+		.h_align	= 2,
+		.v_align	= 0,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_EXYNOS3250 |
+				  SJPEG_FMT_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_444,
+	},
+	{
+		.name		= "RGB565X",
+		.fourcc		= V4L2_PIX_FMT_RGB565X,
+		.depth		= 16,
+		.colplanes	= 1,
+		.h_align	= 2,
+		.v_align	= 0,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_EXYNOS3250 |
+				  SJPEG_FMT_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_444,
+	},
+	{
+		.name		= "RGB565",
+		.fourcc		= V4L2_PIX_FMT_RGB565,
+		.depth		= 16,
+		.colplanes	= 1,
 		.h_align	= 0,
 		.v_align	= 0,
 		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
@@ -121,6 +201,19 @@ static struct s5p_jpeg_fmt sjpeg_formats[] = {
 		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_444,
 	},
 	{
+		.name		= "ARGB8888, 32 bpp",
+		.fourcc		= V4L2_PIX_FMT_RGB32,
+		.depth		= 32,
+		.colplanes	= 1,
+		.h_align	= 2,
+		.v_align	= 0,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_EXYNOS3250 |
+				  SJPEG_FMT_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_444,
+	},
+	{
 		.name		= "YUV 4:4:4 planar, Y/CbCr",
 		.fourcc		= V4L2_PIX_FMT_NV24,
 		.depth		= 24,
@@ -190,9 +283,23 @@ static struct s5p_jpeg_fmt sjpeg_formats[] = {
 		.fourcc		= V4L2_PIX_FMT_NV12,
 		.depth		= 12,
 		.colplanes	= 2,
+		.h_align	= 3,
+		.v_align	= 3,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_EXYNOS3250 |
+				  SJPEG_FMT_NON_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_420,
+	},
+	{
+		.name		= "YUV 4:2:0 planar, Y/CbCr",
+		.fourcc		= V4L2_PIX_FMT_NV12,
+		.depth		= 12,
+		.colplanes	= 2,
 		.h_align	= 4,
 		.v_align	= 4,
-		.flags		= SJPEG_FMT_FLAG_DEC_CAPTURE |
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
 				  SJPEG_FMT_FLAG_S5P |
 				  SJPEG_FMT_NON_RGB,
 		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_420,
@@ -202,10 +309,24 @@ static struct s5p_jpeg_fmt sjpeg_formats[] = {
 		.fourcc		= V4L2_PIX_FMT_NV21,
 		.depth		= 12,
 		.colplanes	= 2,
+		.h_align	= 3,
+		.v_align	= 3,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_EXYNOS3250 |
+				  SJPEG_FMT_NON_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_420,
+	},
+	{
+		.name		= "YUV 4:2:0 planar, Y/CrCb",
+		.fourcc		= V4L2_PIX_FMT_NV21,
+		.depth		= 12,
+		.colplanes	= 2,
 		.h_align	= 1,
 		.v_align	= 1,
 		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
 				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_EXYNOS3250 |
 				  SJPEG_FMT_FLAG_EXYNOS4 |
 				  SJPEG_FMT_NON_RGB,
 		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_420,
@@ -224,6 +345,19 @@ static struct s5p_jpeg_fmt sjpeg_formats[] = {
 		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_420,
 	},
 	{
+		.name		= "YUV 4:2:0 contiguous 3-planar, Y/Cb/Cr",
+		.fourcc		= V4L2_PIX_FMT_YUV420,
+		.depth		= 12,
+		.colplanes	= 3,
+		.h_align	= 4,
+		.v_align	= 4,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_EXYNOS3250 |
+				  SJPEG_FMT_NON_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_420,
+	},
+	{
 		.name		= "Gray",
 		.fourcc		= V4L2_PIX_FMT_GREY,
 		.depth		= 8,
@@ -457,6 +591,16 @@ static int exynos4x12_decoded_subsampling[] = {
 	V4L2_JPEG_CHROMA_SUBSAMPLING_420,
 };
 
+static int exynos3250_decoded_subsampling[] = {
+	V4L2_JPEG_CHROMA_SUBSAMPLING_444,
+	V4L2_JPEG_CHROMA_SUBSAMPLING_422,
+	V4L2_JPEG_CHROMA_SUBSAMPLING_420,
+	V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY,
+	-1,
+	-1,
+	V4L2_JPEG_CHROMA_SUBSAMPLING_411,
+};
+
 static inline struct s5p_jpeg_ctx *ctrl_to_ctx(struct v4l2_ctrl *c)
 {
 	return container_of(c->handler, struct s5p_jpeg_ctx, ctrl_handler);
@@ -471,14 +615,21 @@ static int s5p_jpeg_to_user_subsampling(struct s5p_jpeg_ctx *ctx)
 {
 	WARN_ON(ctx->subsampling > 3);
 
-	if (ctx->jpeg->variant->version == SJPEG_S5P) {
+	switch (ctx->jpeg->variant->version) {
+	case SJPEG_S5P:
 		if (ctx->subsampling > 2)
 			return V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY;
 		return ctx->subsampling;
-	} else {
+	case SJPEG_EXYNOS3250:
+		if (ctx->subsampling > 3)
+			return V4L2_JPEG_CHROMA_SUBSAMPLING_411;
+		return exynos3250_decoded_subsampling[ctx->subsampling];
+	case SJPEG_EXYNOS4:
 		if (ctx->subsampling > 2)
 			return V4L2_JPEG_CHROMA_SUBSAMPLING_420;
 		return exynos4x12_decoded_subsampling[ctx->subsampling];
+	default:
+		return V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY;
 	}
 }
 
@@ -646,6 +797,7 @@ static int s5p_jpeg_open(struct file *file)
 							FMT_TYPE_OUTPUT);
 		cap_fmt = s5p_jpeg_find_format(ctx, V4L2_PIX_FMT_YUYV,
 							FMT_TYPE_CAPTURE);
+		ctx->scale_factor = EXYNOS3250_DEC_SCALE_FACTOR_8_8;
 	}
 
 	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(jpeg->m2m_dev, ctx, queue_init);
@@ -1229,6 +1381,101 @@ static int s5p_jpeg_s_fmt_vid_out(struct file *file, void *priv,
 	return s5p_jpeg_s_fmt(fh_to_ctx(priv), f);
 }
 
+static int exynos3250_jpeg_try_downscale(struct s5p_jpeg_ctx *ctx,
+				   struct v4l2_rect *r)
+{
+	int w_ratio, h_ratio, scale_factor, cur_ratio, i;
+
+	w_ratio = ctx->out_q.w / r->width;
+	h_ratio = ctx->out_q.h / r->height;
+
+	scale_factor = w_ratio > h_ratio ? w_ratio : h_ratio;
+	scale_factor = clamp_val(scale_factor, 1, 8);
+
+	/* Align scale ratio to the nearest power of 2 */
+	for (i = 0; i <= 3; ++i) {
+		cur_ratio = 1 << i;
+		if (scale_factor <= cur_ratio) {
+			ctx->scale_factor = cur_ratio;
+			break;
+		}
+	}
+
+	r->width = round_down(ctx->out_q.w / ctx->scale_factor, 2);
+	r->height = round_down(ctx->out_q.h / ctx->scale_factor, 2);
+
+	ctx->crop_rect.width = r->width;
+	ctx->crop_rect.height = r->height;
+	ctx->crop_rect.left = 0;
+	ctx->crop_rect.top = 0;
+
+	ctx->crop_altered = true;
+
+	return 0;
+}
+
+/* Return 1 if rectangle a is enclosed in rectangle b, or 0 otherwise. */
+static int enclosed_rectangle(struct v4l2_rect *a, struct v4l2_rect *b)
+{
+	if (a->left < b->left || a->top < b->top)
+		return 0;
+	if (a->left + a->width > b->left + b->width)
+		return 0;
+	if (a->top + a->height > b->top + b->height)
+		return 0;
+
+	return 1;
+}
+
+static int exynos3250_jpeg_try_crop(struct s5p_jpeg_ctx *ctx,
+				   struct v4l2_rect *r)
+{
+	struct v4l2_rect base_rect;
+	int w_step, h_step;
+
+	switch (ctx->cap_q.fmt->fourcc) {
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+		w_step = 1;
+		h_step = 2;
+		break;
+	case V4L2_PIX_FMT_YUV420:
+		w_step = 2;
+		h_step = 2;
+		break;
+	default:
+		w_step = 1;
+		h_step = 1;
+		break;
+	}
+
+	base_rect.top = 0;
+	base_rect.left = 0;
+	base_rect.width = ctx->out_q.w;
+	base_rect.height = ctx->out_q.h;
+
+	r->width = round_down(r->width, w_step);
+	r->height = round_down(r->height, h_step);
+	r->left = round_down(r->left, 2);
+	r->top = round_down(r->top, 2);
+
+	if (!enclosed_rectangle(r, &base_rect))
+		return -EINVAL;
+
+	ctx->crop_rect.left = r->left;
+	ctx->crop_rect.top = r->top;
+	ctx->crop_rect.width = r->width;
+	ctx->crop_rect.height = r->height;
+
+	ctx->crop_altered = true;
+
+	return 0;
+}
+
+/*
+ * V4L2 controls
+ */
+
 static int s5p_jpeg_g_selection(struct file *file, void *priv,
 			 struct v4l2_selection *s)
 {
@@ -1264,6 +1511,30 @@ static int s5p_jpeg_g_selection(struct file *file, void *priv,
 /*
  * V4L2 controls
  */
+static int s5p_jpeg_s_selection(struct file *file, void *fh,
+				  struct v4l2_selection *s)
+{
+	struct s5p_jpeg_ctx *ctx = fh_to_ctx(file->private_data);
+	struct v4l2_rect *rect = &s->r;
+	int ret = -EINVAL;
+
+	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	if (s->target == V4L2_SEL_TGT_COMPOSE) {
+		if (ctx->mode != S5P_JPEG_DECODE)
+			return -EINVAL;
+		if (ctx->jpeg->variant->version == SJPEG_EXYNOS3250)
+			ret = exynos3250_jpeg_try_downscale(ctx, rect);
+	} else if (s->target == V4L2_SEL_TGT_CROP) {
+		if (ctx->mode != S5P_JPEG_ENCODE)
+			return -EINVAL;
+		if (ctx->jpeg->variant->version == SJPEG_EXYNOS3250)
+			ret = exynos3250_jpeg_try_crop(ctx, rect);
+	}
+
+	return ret;
+}
 
 static int s5p_jpeg_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
@@ -1414,6 +1685,7 @@ static const struct v4l2_ioctl_ops s5p_jpeg_ioctl_ops = {
 	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
 
 	.vidioc_g_selection		= s5p_jpeg_g_selection,
+	.vidioc_s_selection		= s5p_jpeg_s_selection,
 };
 
 /*
@@ -1604,6 +1876,135 @@ static void exynos4_jpeg_device_run(void *priv)
 	spin_unlock_irqrestore(&ctx->jpeg->slock, flags);
 }
 
+static void exynos3250_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
+{
+	struct s5p_jpeg *jpeg = ctx->jpeg;
+	struct s5p_jpeg_fmt *fmt;
+	struct vb2_buffer *vb;
+	struct s5p_jpeg_addr jpeg_addr;
+	u32 pix_size;
+
+	pix_size = ctx->cap_q.w * ctx->cap_q.h;
+
+	if (ctx->mode == S5P_JPEG_ENCODE) {
+		vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+		fmt = ctx->out_q.fmt;
+	} else {
+		vb = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
+		fmt = ctx->cap_q.fmt;
+	}
+
+	jpeg_addr.y = vb2_dma_contig_plane_dma_addr(vb, 0);
+
+	if (fmt->colplanes == 2) {
+		jpeg_addr.cb = jpeg_addr.y + pix_size;
+	} else if (fmt->colplanes == 3) {
+		jpeg_addr.cb = jpeg_addr.y + pix_size;
+		if (fmt->fourcc == V4L2_PIX_FMT_YUV420)
+			jpeg_addr.cr = jpeg_addr.cb + pix_size / 4;
+		else
+			jpeg_addr.cr = jpeg_addr.cb + pix_size / 2;
+	}
+
+	exynos3250_jpeg_imgadr(jpeg->regs, &jpeg_addr);
+}
+
+static void exynos3250_jpeg_set_jpeg_addr(struct s5p_jpeg_ctx *ctx)
+{
+	struct s5p_jpeg *jpeg = ctx->jpeg;
+	struct vb2_buffer *vb;
+	unsigned int jpeg_addr = 0;
+
+	if (ctx->mode == S5P_JPEG_ENCODE)
+		vb = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
+	else
+		vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+
+	jpeg_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+	exynos3250_jpeg_jpgadr(jpeg->regs, jpeg_addr);
+}
+
+static void exynos3250_jpeg_device_run(void *priv)
+{
+	struct s5p_jpeg_ctx *ctx = priv;
+	struct s5p_jpeg *jpeg = ctx->jpeg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->jpeg->slock, flags);
+
+	exynos3250_jpeg_reset(jpeg->regs);
+	exynos3250_jpeg_set_dma_num(jpeg->regs);
+	exynos3250_jpeg_poweron(jpeg->regs);
+	exynos3250_jpeg_clk_set(jpeg->regs);
+	exynos3250_jpeg_proc_mode(jpeg->regs, ctx->mode);
+
+	if (ctx->mode == S5P_JPEG_ENCODE) {
+		exynos3250_jpeg_input_raw_fmt(jpeg->regs,
+					      ctx->out_q.fmt->fourcc);
+		exynos3250_jpeg_dri(jpeg->regs, ctx->restart_interval);
+
+		/*
+		 * JPEG IP allows storing 4 quantization tables
+		 * We fill table 0 for luma and table 1 for chroma
+		 */
+		s5p_jpeg_set_qtbl_lum(jpeg->regs, ctx->compr_quality);
+		s5p_jpeg_set_qtbl_chr(jpeg->regs, ctx->compr_quality);
+		/* use table 0 for Y */
+		exynos3250_jpeg_qtbl(jpeg->regs, 1, 0);
+		/* use table 1 for Cb and Cr*/
+		exynos3250_jpeg_qtbl(jpeg->regs, 2, 1);
+		exynos3250_jpeg_qtbl(jpeg->regs, 3, 1);
+
+		/* Y, Cb, Cr use Huffman table 0 */
+		exynos3250_jpeg_htbl_ac(jpeg->regs, 1);
+		exynos3250_jpeg_htbl_dc(jpeg->regs, 1);
+		exynos3250_jpeg_htbl_ac(jpeg->regs, 2);
+		exynos3250_jpeg_htbl_dc(jpeg->regs, 2);
+		exynos3250_jpeg_htbl_ac(jpeg->regs, 3);
+		exynos3250_jpeg_htbl_dc(jpeg->regs, 3);
+
+		exynos3250_jpeg_set_x(jpeg->regs, ctx->crop_rect.width);
+		exynos3250_jpeg_set_y(jpeg->regs, ctx->crop_rect.height);
+		exynos3250_jpeg_stride(jpeg->regs, ctx->out_q.fmt->fourcc,
+								ctx->out_q.w);
+		exynos3250_jpeg_offset(jpeg->regs, ctx->crop_rect.left,
+							ctx->crop_rect.top);
+		exynos3250_jpeg_set_img_addr(ctx);
+		exynos3250_jpeg_set_jpeg_addr(ctx);
+		exynos3250_jpeg_subsampling_mode(jpeg->regs, ctx->subsampling);
+
+		/* ultimately comes from sizeimage from userspace */
+		exynos3250_jpeg_enc_stream_bound(jpeg->regs, ctx->cap_q.size);
+
+		if (ctx->out_q.fmt->fourcc == V4L2_PIX_FMT_RGB565 ||
+		    ctx->out_q.fmt->fourcc == V4L2_PIX_FMT_RGB565X ||
+		    ctx->out_q.fmt->fourcc == V4L2_PIX_FMT_RGB32)
+			exynos3250_jpeg_set_y16(jpeg->regs, true);
+	} else {
+		exynos3250_jpeg_set_img_addr(ctx);
+		exynos3250_jpeg_set_jpeg_addr(ctx);
+		exynos3250_jpeg_stride(jpeg->regs, ctx->cap_q.fmt->fourcc,
+								ctx->cap_q.w);
+		exynos3250_jpeg_offset(jpeg->regs, 0, 0);
+		exynos3250_jpeg_dec_scaling_ratio(jpeg->regs,
+							ctx->scale_factor);
+		exynos3250_jpeg_dec_stream_size(jpeg->regs, ctx->out_q.size);
+		exynos3250_jpeg_output_raw_fmt(jpeg->regs,
+						ctx->cap_q.fmt->fourcc);
+	}
+
+	exynos3250_jpeg_interrupts_enable(jpeg->regs);
+
+	/* JPEG RGB to YCbCr conversion matrix */
+	exynos3250_jpeg_coef(jpeg->regs, ctx->mode);
+
+	exynos3250_jpeg_set_timer(jpeg->regs, EXYNOS3250_IRQ_TIMEOUT);
+	jpeg->irq_status = 0;
+	exynos3250_jpeg_start(jpeg->regs);
+
+	spin_unlock_irqrestore(&ctx->jpeg->slock, flags);
+}
+
 static int s5p_jpeg_job_ready(void *priv)
 {
 	struct s5p_jpeg_ctx *ctx = priv;
@@ -1621,8 +2022,14 @@ static struct v4l2_m2m_ops s5p_jpeg_m2m_ops = {
 	.device_run	= s5p_jpeg_device_run,
 	.job_ready	= s5p_jpeg_job_ready,
 	.job_abort	= s5p_jpeg_job_abort,
-}
-;
+};
+
+static struct v4l2_m2m_ops exynos3250_jpeg_m2m_ops = {
+	.device_run	= exynos3250_jpeg_device_run,
+	.job_ready	= s5p_jpeg_job_ready,
+	.job_abort	= s5p_jpeg_job_abort,
+};
+
 static struct v4l2_m2m_ops exynos4_jpeg_m2m_ops = {
 	.device_run	= exynos4_jpeg_device_run,
 	.job_ready	= s5p_jpeg_job_ready,
@@ -1895,6 +2302,70 @@ static irqreturn_t exynos4_jpeg_irq(int irq, void *priv)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t exynos3250_jpeg_irq(int irq, void *dev_id)
+{
+	struct s5p_jpeg *jpeg = dev_id;
+	struct s5p_jpeg_ctx *curr_ctx;
+	struct vb2_buffer *src_buf, *dst_buf;
+	unsigned long payload_size = 0;
+	enum vb2_buffer_state state = VB2_BUF_STATE_DONE;
+	bool interrupt_timeout = false;
+	u32 irq_status;
+
+	spin_lock(&jpeg->slock);
+
+	irq_status = exynos3250_jpeg_get_timer_status(jpeg->regs);
+	if (irq_status & EXYNOS3250_TIMER_INT_STAT) {
+		exynos3250_jpeg_clear_timer_status(jpeg->regs);
+		interrupt_timeout = true;
+		dev_err(jpeg->dev, "Interrupt timeout occurred.\n");
+	}
+
+	irq_status = exynos3250_jpeg_get_int_status(jpeg->regs);
+	exynos3250_jpeg_clear_int_status(jpeg->regs, irq_status);
+
+	jpeg->irq_status |= irq_status;
+
+	curr_ctx = v4l2_m2m_get_curr_priv(jpeg->m2m_dev);
+
+	if (!curr_ctx)
+		goto exit_unlock;
+
+	if ((irq_status & EXYNOS3250_HEADER_STAT) &&
+	    (curr_ctx->mode == S5P_JPEG_DECODE)) {
+		exynos3250_jpeg_rstart(jpeg->regs);
+		goto exit_unlock;
+	}
+
+	if (jpeg->irq_status & (EXYNOS3250_JPEG_DONE |
+				EXYNOS3250_WDMA_DONE |
+				EXYNOS3250_RDMA_DONE |
+				EXYNOS3250_RESULT_STAT))
+		payload_size = exynos3250_jpeg_compressed_size(jpeg->regs);
+	else if (interrupt_timeout)
+		state = VB2_BUF_STATE_ERROR;
+	else
+		goto exit_unlock;
+
+	src_buf = v4l2_m2m_src_buf_remove(curr_ctx->fh.m2m_ctx);
+	dst_buf = v4l2_m2m_dst_buf_remove(curr_ctx->fh.m2m_ctx);
+
+	dst_buf->v4l2_buf.timecode = src_buf->v4l2_buf.timecode;
+	dst_buf->v4l2_buf.timestamp = src_buf->v4l2_buf.timestamp;
+
+	v4l2_m2m_buf_done(src_buf, state);
+	if (curr_ctx->mode == S5P_JPEG_ENCODE)
+		vb2_set_plane_payload(dst_buf, 0, payload_size);
+	v4l2_m2m_buf_done(dst_buf, state);
+	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
+
+	curr_ctx->subsampling =
+			exynos3250_jpeg_get_subsampling_mode(jpeg->regs);
+exit_unlock:
+	spin_unlock(&jpeg->slock);
+	return IRQ_HANDLED;
+}
+
 static void *jpeg_get_drv_data(struct device *dev);
 
 /*
@@ -1950,6 +2421,15 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 	}
 	dev_dbg(&pdev->dev, "clock source %p\n", jpeg->clk);
 
+	if (jpeg->variant->has_sclk) {
+		jpeg->sclk = clk_get(&pdev->dev, "sclk-jpeg");
+		if (IS_ERR(jpeg->sclk)) {
+			dev_err(&pdev->dev, "cannot get clock\n");
+			ret = PTR_ERR(jpeg->sclk);
+			return ret;
+		}
+	}
+
 	/* v4l2 device */
 	ret = v4l2_device_register(&pdev->dev, &jpeg->v4l2_dev);
 	if (ret) {
@@ -2057,6 +2537,8 @@ device_register_rollback:
 
 clk_get_rollback:
 	clk_put(jpeg->clk);
+	if (jpeg->variant->has_sclk)
+		clk_put(jpeg->sclk);
 
 	return ret;
 }
@@ -2075,10 +2557,15 @@ static int s5p_jpeg_remove(struct platform_device *pdev)
 	v4l2_m2m_release(jpeg->m2m_dev);
 	v4l2_device_unregister(&jpeg->v4l2_dev);
 
-	if (!pm_runtime_status_suspended(&pdev->dev))
+	if (!pm_runtime_status_suspended(&pdev->dev)) {
 		clk_disable_unprepare(jpeg->clk);
+		if (jpeg->variant->has_sclk)
+			clk_disable_unprepare(jpeg->sclk);
+	}
 
 	clk_put(jpeg->clk);
+	if (jpeg->variant->has_sclk)
+		clk_put(jpeg->sclk);
 
 	return 0;
 }
@@ -2088,6 +2575,8 @@ static int s5p_jpeg_runtime_suspend(struct device *dev)
 	struct s5p_jpeg *jpeg = dev_get_drvdata(dev);
 
 	clk_disable_unprepare(jpeg->clk);
+	if (jpeg->variant->has_sclk)
+		clk_disable_unprepare(jpeg->sclk);
 
 	return 0;
 }
@@ -2102,15 +2591,24 @@ static int s5p_jpeg_runtime_resume(struct device *dev)
 	if (ret < 0)
 		return ret;
 
+	if (jpeg->variant->has_sclk) {
+		ret = clk_prepare_enable(jpeg->sclk);
+		if (ret < 0)
+			return ret;
+	}
+
 	spin_lock_irqsave(&jpeg->slock, flags);
 
 	/*
-	 * JPEG IP allows storing two Huffman tables for each component
+	 * JPEG IP allows storing two Huffman tables for each component.
 	 * We fill table 0 for each component and do this here only
-	 * for S5PC210 device as Exynos4x12 requires programming its
-	 * Huffman tables each time the encoding process is initialized.
+	 * for S5PC210 and Exynos3250 SoCs. Exynos4x12 SoC requires
+	 * programming its Huffman tables each time the encoding process
+	 * is initialized, and thus it is accomplished in the device_run
+	 * callback of m2m_ops.
 	 */
-	if (jpeg->variant->version == SJPEG_S5P) {
+	if (jpeg->variant->version == SJPEG_S5P ||
+	    jpeg->variant->version == SJPEG_EXYNOS3250) {
 		s5p_jpeg_set_hdctbl(jpeg->regs);
 		s5p_jpeg_set_hdctblg(jpeg->regs);
 		s5p_jpeg_set_hactbl(jpeg->regs);
@@ -2150,6 +2648,14 @@ static struct s5p_jpeg_variant s5p_jpeg_drvdata = {
 	.fmt_ver_flag	= SJPEG_FMT_FLAG_S5P,
 };
 
+static struct s5p_jpeg_variant exynos3250_jpeg_drvdata = {
+	.version	= SJPEG_EXYNOS3250,
+	.jpeg_irq	= exynos3250_jpeg_irq,
+	.m2m_ops	= &exynos3250_jpeg_m2m_ops,
+	.has_sclk	= true,
+	.fmt_ver_flag	= SJPEG_FMT_FLAG_EXYNOS3250,
+};
+
 static struct s5p_jpeg_variant exynos4_jpeg_drvdata = {
 	.version	= SJPEG_EXYNOS4,
 	.jpeg_irq	= exynos4_jpeg_irq,
@@ -2162,8 +2668,11 @@ static const struct of_device_id samsung_jpeg_match[] = {
 		.compatible = "samsung,s5pv210-jpeg",
 		.data = &s5p_jpeg_drvdata,
 	}, {
+		.compatible = "samsung,exynos3250-jpeg",
+		.data = &exynos3250_jpeg_drvdata,
+	}, {
 		.compatible = "samsung,exynos4210-jpeg",
-		.data = &s5p_jpeg_drvdata,
+		.data = &exynos4_jpeg_drvdata,
 	}, {
 		.compatible = "samsung,exynos4212-jpeg",
 		.data = &exynos4_jpeg_drvdata,
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.h b/drivers/media/platform/s5p-jpeg/jpeg-core.h
index 3e47863..de3228e 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.h
@@ -35,6 +35,8 @@
 #define S5P_JPEG_COEF32			0x6e
 #define S5P_JPEG_COEF33			0x13
 
+#define EXYNOS3250_IRQ_TIMEOUT		0x10000000
+
 /* a selection of JPEG markers */
 #define TEM				0x01
 #define SOF0				0xc0
@@ -49,9 +51,10 @@
 #define SJPEG_FMT_FLAG_DEC_CAPTURE	(1 << 2)
 #define SJPEG_FMT_FLAG_DEC_OUTPUT	(1 << 3)
 #define SJPEG_FMT_FLAG_S5P		(1 << 4)
-#define SJPEG_FMT_FLAG_EXYNOS4		(1 << 5)
-#define SJPEG_FMT_RGB			(1 << 6)
-#define SJPEG_FMT_NON_RGB		(1 << 7)
+#define SJPEG_FMT_FLAG_EXYNOS3250	(1 << 5)
+#define SJPEG_FMT_FLAG_EXYNOS4		(1 << 6)
+#define SJPEG_FMT_RGB			(1 << 7)
+#define SJPEG_FMT_NON_RGB		(1 << 8)
 
 #define S5P_JPEG_ENCODE		0
 #define S5P_JPEG_DECODE		1
@@ -65,8 +68,9 @@
 
 /* Version numbers */
 
-#define SJPEG_S5P	1
-#define SJPEG_EXYNOS4	2
+#define SJPEG_S5P		1
+#define SJPEG_EXYNOS3250	2
+#define SJPEG_EXYNOS4		3
 
 enum exynos4_jpeg_result {
 	OK_ENC_OR_DEC,
@@ -95,8 +99,13 @@ enum  exynos4_jpeg_img_quality_level {
  * @regs:		JPEG IP registers mapping
  * @irq:		JPEG IP irq
  * @clk:		JPEG IP clock
+ * @sclk:		Exynos3250 JPEG IP special clock
  * @dev:		JPEG IP struct device
  * @alloc_ctx:		videobuf2 memory allocator's context
+ * @variant:		driver variant to be used
+ * @irq_status		interrupt flags set during single encode/decode
+			operation
+
  */
 struct s5p_jpeg {
 	struct mutex		lock;
@@ -111,9 +120,11 @@ struct s5p_jpeg {
 	unsigned int		irq;
 	enum exynos4_jpeg_result irq_ret;
 	struct clk		*clk;
+	struct clk		*sclk;
 	struct device		*dev;
 	void			*alloc_ctx;
 	struct s5p_jpeg_variant *variant;
+	u32			irq_status;
 };
 
 struct s5p_jpeg_variant {
@@ -121,6 +132,7 @@ struct s5p_jpeg_variant {
 	unsigned int		fmt_ver_flag;
 	struct v4l2_m2m_ops	*m2m_ops;
 	irqreturn_t		(*jpeg_irq)(int irq, void *priv);
+	unsigned int		has_sclk:1;
 };
 
 /**
@@ -164,9 +176,15 @@ struct s5p_jpeg_q_data {
  * @jpeg:		JPEG IP device for this context
  * @mode:		compression (encode) operation or decompression (decode)
  * @compr_quality:	destination image quality in compression (encode) mode
+ * @restart_interval:	JPEG restart interval for JPEG encoding
+ * @subsampling:	subsampling of a raw format or a JPEG
  * @out_q:		source (output) queue information
- * @cap_fmt:		destination (capture) queue queue information
+ * @cap_q:		destination (capture) queue queue information
+ * @scale_factor:	scale factor for JPEG decoding
+ * @crop_rect:		a rectangle representing crop area of the output buffer
+ * @fh:			V4L2 file handle
  * @hdr_parsed:		set if header has been parsed during decompression
+ * @crop_altered:	set if crop rectangle has been altered by the user space
  * @ctrl_handler:	controls handler
  */
 struct s5p_jpeg_ctx {
@@ -177,8 +195,11 @@ struct s5p_jpeg_ctx {
 	unsigned short		subsampling;
 	struct s5p_jpeg_q_data	out_q;
 	struct s5p_jpeg_q_data	cap_q;
+	unsigned int		scale_factor;
+	struct v4l2_rect	crop_rect;
 	struct v4l2_fh		fh;
 	bool			hdr_parsed;
+	bool			crop_altered;
 	struct v4l2_ctrl_handler ctrl_handler;
 };
 
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c
new file mode 100644
index 0000000..14327a4
--- /dev/null
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c
@@ -0,0 +1,489 @@
+/* linux/drivers/media/platform/exynos3250-jpeg/jpeg-hw.h
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/io.h>
+#include <linux/videodev2.h>
+#include <linux/delay.h>
+
+#include "jpeg-core.h"
+#include "jpeg-regs.h"
+#include "jpeg-hw-exynos3250.h"
+
+void exynos3250_jpeg_reset(void __iomem *regs)
+{
+	u32 reg = 0;
+	int count = 1000;
+
+	writel(1, regs + EXYNOS3250_SW_RESET);
+	/* no other way but polling for when JPEG IP becomes operational */
+	while (reg != 0 && --count > 0) {
+		udelay(1);
+		cpu_relax();
+		reg = readl(regs + EXYNOS3250_SW_RESET);
+	}
+
+	reg = 0;
+	count = 1000;
+
+	while (reg != 1 && --count > 0) {
+		writel(1, regs + EXYNOS3250_JPGDRI);
+		udelay(1);
+		cpu_relax();
+		reg = readl(regs + EXYNOS3250_JPGDRI);
+	}
+
+	writel(0, regs + EXYNOS3250_JPGDRI);
+}
+
+void exynos3250_jpeg_poweron(void __iomem *regs)
+{
+	writel(EXYNOS3250_POWER_ON, regs + EXYNOS3250_JPGCLKCON);
+}
+
+void exynos3250_jpeg_set_dma_num(void __iomem *regs)
+{
+	writel(((EXYNOS3250_DMA_MO_COUNT << EXYNOS3250_WDMA_ISSUE_NUM_SHIFT) &
+			EXYNOS3250_WDMA_ISSUE_NUM_MASK) |
+	       ((EXYNOS3250_DMA_MO_COUNT << EXYNOS3250_RDMA_ISSUE_NUM_SHIFT) &
+			EXYNOS3250_RDMA_ISSUE_NUM_MASK) |
+	       ((EXYNOS3250_DMA_MO_COUNT << EXYNOS3250_ISSUE_GATHER_NUM_SHIFT) &
+			EXYNOS3250_ISSUE_GATHER_NUM_MASK),
+		regs + EXYNOS3250_DMA_ISSUE_NUM);
+}
+
+void exynos3250_jpeg_clk_set(void __iomem *base)
+{
+	u32 reg;
+
+	reg = readl(base + EXYNOS3250_JPGCMOD) & ~EXYNOS3250_HALF_EN_MASK;
+
+	writel(reg | EXYNOS3250_HALF_EN, base + EXYNOS3250_JPGCMOD);
+}
+
+void exynos3250_jpeg_input_raw_fmt(void __iomem *regs, unsigned int fmt)
+{
+	u32 reg;
+
+	reg = readl(regs + EXYNOS3250_JPGCMOD) &
+			EXYNOS3250_MODE_Y16_MASK;
+
+	switch (fmt) {
+	case V4L2_PIX_FMT_RGB32:
+		reg |= EXYNOS3250_MODE_SEL_ARGB8888;
+		break;
+	case V4L2_PIX_FMT_BGR32:
+		reg |= EXYNOS3250_MODE_SEL_ARGB8888 | EXYNOS3250_SRC_SWAP_RGB;
+		break;
+	case V4L2_PIX_FMT_RGB565:
+		reg |= EXYNOS3250_MODE_SEL_RGB565;
+		break;
+	case V4L2_PIX_FMT_RGB565X:
+		reg |= EXYNOS3250_MODE_SEL_RGB565 | EXYNOS3250_SRC_SWAP_RGB;
+		break;
+	case V4L2_PIX_FMT_YUYV:
+		reg |= EXYNOS3250_MODE_SEL_422_1P_LUM_CHR;
+		break;
+	case V4L2_PIX_FMT_YVYU:
+		reg |= EXYNOS3250_MODE_SEL_422_1P_LUM_CHR |
+			EXYNOS3250_SRC_SWAP_UV;
+		break;
+	case V4L2_PIX_FMT_UYVY:
+		reg |= EXYNOS3250_MODE_SEL_422_1P_CHR_LUM;
+		break;
+	case V4L2_PIX_FMT_VYUY:
+		reg |= EXYNOS3250_MODE_SEL_422_1P_CHR_LUM |
+			EXYNOS3250_SRC_SWAP_UV;
+		break;
+	case V4L2_PIX_FMT_NV12:
+		reg |= EXYNOS3250_MODE_SEL_420_2P | EXYNOS3250_SRC_NV12;
+		break;
+	case V4L2_PIX_FMT_NV21:
+		reg |= EXYNOS3250_MODE_SEL_420_2P | EXYNOS3250_SRC_NV21;
+		break;
+	case V4L2_PIX_FMT_YUV420:
+		reg |= EXYNOS3250_MODE_SEL_420_3P;
+		break;
+	default:
+		break;
+
+	}
+
+	writel(reg, regs + EXYNOS3250_JPGCMOD);
+}
+
+void exynos3250_jpeg_set_y16(void __iomem *regs, bool y16)
+{
+	u32 reg;
+
+	reg = readl(regs + EXYNOS3250_JPGCMOD);
+	if (y16)
+		reg |= EXYNOS3250_MODE_Y16;
+	else
+		reg &= ~EXYNOS3250_MODE_Y16_MASK;
+	writel(reg, regs + EXYNOS3250_JPGCMOD);
+}
+
+void exynos3250_jpeg_proc_mode(void __iomem *regs, unsigned int mode)
+{
+	u32 reg, m;
+
+	if (mode == S5P_JPEG_ENCODE)
+		m = EXYNOS3250_PROC_MODE_COMPR;
+	else
+		m = EXYNOS3250_PROC_MODE_DECOMPR;
+	reg = readl(regs + EXYNOS3250_JPGMOD);
+	reg &= ~EXYNOS3250_PROC_MODE_MASK;
+	reg |= m;
+	writel(reg, regs + EXYNOS3250_JPGMOD);
+}
+
+void exynos3250_jpeg_subsampling_mode(void __iomem *regs, unsigned int mode)
+{
+	u32 reg, m = 0;
+
+	switch (mode) {
+	case V4L2_JPEG_CHROMA_SUBSAMPLING_444:
+		m = EXYNOS3250_SUBSAMPLING_MODE_444;
+		break;
+	case V4L2_JPEG_CHROMA_SUBSAMPLING_422:
+		m = EXYNOS3250_SUBSAMPLING_MODE_422;
+		break;
+	case V4L2_JPEG_CHROMA_SUBSAMPLING_420:
+		m = EXYNOS3250_SUBSAMPLING_MODE_420;
+		break;
+	}
+
+	reg = readl(regs + EXYNOS3250_JPGMOD);
+	reg &= ~EXYNOS3250_SUBSAMPLING_MODE_MASK;
+	reg |= m;
+	writel(reg, regs + EXYNOS3250_JPGMOD);
+}
+
+unsigned int exynos3250_jpeg_get_subsampling_mode(void __iomem *regs)
+{
+	return readl(regs + EXYNOS3250_JPGMOD) &
+				EXYNOS3250_SUBSAMPLING_MODE_MASK;
+}
+
+void exynos3250_jpeg_dri(void __iomem *regs, unsigned int dri)
+{
+	u32 reg;
+
+	reg = dri & EXYNOS3250_JPGDRI_MASK;
+	writel(reg, regs + EXYNOS3250_JPGDRI);
+}
+
+void exynos3250_jpeg_qtbl(void __iomem *regs, unsigned int t, unsigned int n)
+{
+	unsigned long reg;
+
+	reg = readl(regs + EXYNOS3250_QHTBL);
+	reg &= ~EXYNOS3250_QT_NUM_MASK(t);
+	reg |= (n << EXYNOS3250_QT_NUM_SHIFT(t)) &
+					EXYNOS3250_QT_NUM_MASK(t);
+	writel(reg, regs + EXYNOS3250_QHTBL);
+}
+
+void exynos3250_jpeg_htbl_ac(void __iomem *regs, unsigned int t)
+{
+	unsigned long reg;
+
+	reg = readl(regs + EXYNOS3250_QHTBL);
+	reg &= ~EXYNOS3250_HT_NUM_AC_MASK(t);
+	/* this driver uses table 0 for all color components */
+	reg |= (0 << EXYNOS3250_HT_NUM_AC_SHIFT(t)) &
+					EXYNOS3250_HT_NUM_AC_MASK(t);
+	writel(reg, regs + EXYNOS3250_QHTBL);
+}
+
+void exynos3250_jpeg_htbl_dc(void __iomem *regs, unsigned int t)
+{
+	unsigned long reg;
+
+	reg = readl(regs + EXYNOS3250_QHTBL);
+	reg &= ~EXYNOS3250_HT_NUM_DC_MASK(t);
+	/* this driver uses table 0 for all color components */
+	reg |= (0 << EXYNOS3250_HT_NUM_DC_SHIFT(t)) &
+					EXYNOS3250_HT_NUM_DC_MASK(t);
+	writel(reg, regs + EXYNOS3250_QHTBL);
+}
+
+void exynos3250_jpeg_set_y(void __iomem *regs, unsigned int y)
+{
+	u32 reg;
+
+	reg = y & EXYNOS3250_JPGY_MASK;
+	writel(reg, regs + EXYNOS3250_JPGY);
+}
+
+void exynos3250_jpeg_set_x(void __iomem *regs, unsigned int x)
+{
+	u32 reg;
+
+	reg = x & EXYNOS3250_JPGX_MASK;
+	writel(reg, regs + EXYNOS3250_JPGX);
+}
+
+unsigned int exynos3250_jpeg_get_y(void __iomem *regs)
+{
+	return readl(regs + EXYNOS3250_JPGY);
+}
+
+unsigned int exynos3250_jpeg_get_x(void __iomem *regs)
+{
+	return readl(regs + EXYNOS3250_JPGX);
+}
+
+void exynos3250_jpeg_interrupts_enable(void __iomem *regs)
+{
+	u32 reg;
+
+	reg = readl(regs + EXYNOS3250_JPGINTSE);
+	reg |= (EXYNOS3250_JPEG_DONE_EN |
+		EXYNOS3250_WDMA_DONE_EN |
+		EXYNOS3250_RDMA_DONE_EN |
+		EXYNOS3250_ENC_STREAM_INT_EN |
+		EXYNOS3250_CORE_DONE_EN |
+		EXYNOS3250_ERR_INT_EN |
+		EXYNOS3250_HEAD_INT_EN);
+	writel(reg, regs + EXYNOS3250_JPGINTSE);
+}
+
+void exynos3250_jpeg_enc_stream_bound(void __iomem *regs, unsigned int size)
+{
+	u32 reg;
+
+	reg = size & EXYNOS3250_ENC_STREAM_BOUND_MASK;
+	writel(reg, regs + EXYNOS3250_ENC_STREAM_BOUND);
+}
+
+void exynos3250_jpeg_output_raw_fmt(void __iomem *regs, unsigned int fmt)
+{
+	u32 reg;
+
+	switch (fmt) {
+	case V4L2_PIX_FMT_RGB32:
+		reg = EXYNOS3250_OUT_FMT_ARGB8888;
+		break;
+	case V4L2_PIX_FMT_BGR32:
+		reg = EXYNOS3250_OUT_FMT_ARGB8888 | EXYNOS3250_OUT_SWAP_RGB;
+		break;
+	case V4L2_PIX_FMT_RGB565:
+		reg = EXYNOS3250_OUT_FMT_RGB565;
+		break;
+	case V4L2_PIX_FMT_RGB565X:
+		reg = EXYNOS3250_OUT_FMT_RGB565 | EXYNOS3250_OUT_SWAP_RGB;
+		break;
+	case V4L2_PIX_FMT_YUYV:
+		reg = EXYNOS3250_OUT_FMT_422_1P_LUM_CHR;
+		break;
+	case V4L2_PIX_FMT_YVYU:
+		reg = EXYNOS3250_OUT_FMT_422_1P_LUM_CHR |
+			EXYNOS3250_OUT_SWAP_UV;
+		break;
+	case V4L2_PIX_FMT_UYVY:
+		reg = EXYNOS3250_OUT_FMT_422_1P_CHR_LUM;
+		break;
+	case V4L2_PIX_FMT_VYUY:
+		reg = EXYNOS3250_OUT_FMT_422_1P_CHR_LUM |
+			EXYNOS3250_OUT_SWAP_UV;
+		break;
+	case V4L2_PIX_FMT_NV12:
+		reg = EXYNOS3250_OUT_FMT_420_2P | EXYNOS3250_OUT_NV12;
+		break;
+	case V4L2_PIX_FMT_NV21:
+		reg = EXYNOS3250_OUT_FMT_420_2P | EXYNOS3250_OUT_NV21;
+		break;
+	case V4L2_PIX_FMT_YUV420:
+		reg = EXYNOS3250_OUT_FMT_420_3P;
+		break;
+	default:
+		reg = 0;
+		break;
+	}
+
+	writel(reg, regs + EXYNOS3250_OUTFORM);
+}
+
+void exynos3250_jpeg_jpgadr(void __iomem *regs, unsigned int addr)
+{
+	writel(addr, regs + EXYNOS3250_JPG_JPGADR);
+}
+
+void exynos3250_jpeg_imgadr(void __iomem *regs, struct s5p_jpeg_addr *img_addr)
+{
+	writel(img_addr->y, regs + EXYNOS3250_LUMA_BASE);
+	writel(img_addr->cb, regs + EXYNOS3250_CHROMA_BASE);
+	writel(img_addr->cr, regs + EXYNOS3250_CHROMA_CR_BASE);
+}
+
+void exynos3250_jpeg_stride(void __iomem *regs, unsigned int img_fmt,
+			    unsigned int width)
+{
+	u32 reg_luma = 0, reg_cr = 0, reg_cb = 0;
+
+	switch (img_fmt) {
+	case V4L2_PIX_FMT_RGB32:
+		reg_luma = 4 * width;
+		break;
+	case V4L2_PIX_FMT_RGB565:
+	case V4L2_PIX_FMT_RGB565X:
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_YVYU:
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_VYUY:
+		reg_luma = 2 * width;
+		break;
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+		reg_luma = width;
+		reg_cb = reg_luma;
+		break;
+	case V4L2_PIX_FMT_YUV420:
+		reg_luma = width;
+		reg_cb = reg_cr = reg_luma / 2;
+		break;
+	default:
+		break;
+	}
+
+	writel(reg_luma, regs + EXYNOS3250_LUMA_STRIDE);
+	writel(reg_cb, regs + EXYNOS3250_CHROMA_STRIDE);
+	writel(reg_cr, regs + EXYNOS3250_CHROMA_CR_STRIDE);
+}
+
+void exynos3250_jpeg_offset(void __iomem *regs, unsigned int x_offset,
+				unsigned int y_offset)
+{
+	u32 reg;
+
+	reg = (y_offset << EXYNOS3250_LUMA_YY_OFFSET_SHIFT) &
+			EXYNOS3250_LUMA_YY_OFFSET_MASK;
+	reg |= (x_offset << EXYNOS3250_LUMA_YX_OFFSET_SHIFT) &
+			EXYNOS3250_LUMA_YX_OFFSET_MASK;
+
+	writel(reg, regs + EXYNOS3250_LUMA_XY_OFFSET);
+
+	reg = (y_offset << EXYNOS3250_CHROMA_YY_OFFSET_SHIFT) &
+			EXYNOS3250_CHROMA_YY_OFFSET_MASK;
+	reg |= (x_offset << EXYNOS3250_CHROMA_YX_OFFSET_SHIFT) &
+			EXYNOS3250_CHROMA_YX_OFFSET_MASK;
+
+	writel(reg, regs + EXYNOS3250_CHROMA_XY_OFFSET);
+
+	reg = (y_offset << EXYNOS3250_CHROMA_CR_YY_OFFSET_SHIFT) &
+			EXYNOS3250_CHROMA_CR_YY_OFFSET_MASK;
+	reg |= (x_offset << EXYNOS3250_CHROMA_CR_YX_OFFSET_SHIFT) &
+			EXYNOS3250_CHROMA_CR_YX_OFFSET_MASK;
+
+	writel(reg, regs + EXYNOS3250_CHROMA_CR_XY_OFFSET);
+}
+
+void exynos3250_jpeg_coef(void __iomem *base, unsigned int mode)
+{
+	if (mode == S5P_JPEG_ENCODE) {
+		writel(EXYNOS3250_JPEG_ENC_COEF1,
+					base + EXYNOS3250_JPG_COEF(1));
+		writel(EXYNOS3250_JPEG_ENC_COEF2,
+					base + EXYNOS3250_JPG_COEF(2));
+		writel(EXYNOS3250_JPEG_ENC_COEF3,
+					base + EXYNOS3250_JPG_COEF(3));
+	} else {
+		writel(EXYNOS3250_JPEG_DEC_COEF1,
+					base + EXYNOS3250_JPG_COEF(1));
+		writel(EXYNOS3250_JPEG_DEC_COEF2,
+					base + EXYNOS3250_JPG_COEF(2));
+		writel(EXYNOS3250_JPEG_DEC_COEF3,
+					base + EXYNOS3250_JPG_COEF(3));
+	}
+}
+
+void exynos3250_jpeg_start(void __iomem *regs)
+{
+	writel(1, regs + EXYNOS3250_JSTART);
+}
+
+void exynos3250_jpeg_rstart(void __iomem *regs)
+{
+	writel(1, regs + EXYNOS3250_JRSTART);
+}
+
+unsigned int exynos3250_jpeg_get_int_status(void __iomem *regs)
+{
+	return readl(regs + EXYNOS3250_JPGINTST);
+}
+
+void exynos3250_jpeg_clear_int_status(void __iomem *regs,
+						unsigned int value)
+{
+	return writel(value, regs + EXYNOS3250_JPGINTST);
+}
+
+unsigned int exynos3250_jpeg_operating(void __iomem *regs)
+{
+	return readl(regs + S5P_JPGOPR) & EXYNOS3250_JPGOPR_MASK;
+}
+
+unsigned int exynos3250_jpeg_compressed_size(void __iomem *regs)
+{
+	return readl(regs + EXYNOS3250_JPGCNT) & EXYNOS3250_JPGCNT_MASK;
+}
+
+void exynos3250_jpeg_dec_stream_size(void __iomem *regs,
+						unsigned int size)
+{
+	writel(size & EXYNOS3250_DEC_STREAM_MASK,
+				regs + EXYNOS3250_DEC_STREAM_SIZE);
+}
+
+void exynos3250_jpeg_dec_scaling_ratio(void __iomem *regs,
+						unsigned int sratio)
+{
+	switch (sratio) {
+	case 1:
+		sratio = EXYNOS3250_DEC_SCALE_FACTOR_8_8;
+		break;
+	case 2:
+		sratio = EXYNOS3250_DEC_SCALE_FACTOR_4_8;
+		break;
+	case 4:
+		sratio = EXYNOS3250_DEC_SCALE_FACTOR_2_8;
+		break;
+	case 8:
+		sratio = EXYNOS3250_DEC_SCALE_FACTOR_1_8;
+		break;
+	defaut:
+		sratio = EXYNOS3250_DEC_SCALE_FACTOR_8_8;
+		break;
+	}
+
+	writel(sratio & EXYNOS3250_DEC_SCALE_FACTOR_MASK,
+				regs + EXYNOS3250_DEC_SCALING_RATIO);
+}
+
+void exynos3250_jpeg_set_timer(void __iomem *regs, unsigned int time_value)
+{
+	time_value &= EXYNOS3250_TIMER_INIT_MASK;
+
+	writel(EXYNOS3250_TIMER_INT_STAT | time_value,
+					regs + EXYNOS3250_TIMER_SE);
+}
+
+unsigned int exynos3250_jpeg_get_timer_status(void __iomem *regs)
+{
+	return readl(regs + EXYNOS3250_TIMER_ST);
+}
+
+void exynos3250_jpeg_clear_timer_status(void __iomem *regs)
+{
+	writel(EXYNOS3250_TIMER_INT_STAT, regs + EXYNOS3250_TIMER_ST);
+}
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.h b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.h
new file mode 100644
index 0000000..b6e3be8
--- /dev/null
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.h
@@ -0,0 +1,60 @@
+/* linux/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.h
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef JPEG_HW_EXYNOS3250_H_
+#define JPEG_HW_EXYNOS3250_H_
+
+#include <linux/io.h>
+#include <linux/videodev2.h>
+
+#include "jpeg-regs.h"
+
+void exynos3250_jpeg_reset(void __iomem *regs);
+void exynos3250_jpeg_poweron(void __iomem *regs);
+void exynos3250_jpeg_set_dma_num(void __iomem *regs);
+void exynos3250_jpeg_clk_set(void __iomem *base);
+void exynos3250_jpeg_input_raw_fmt(void __iomem *regs, unsigned int fmt);
+void exynos3250_jpeg_output_raw_fmt(void __iomem *regs, unsigned int fmt);
+void exynos3250_jpeg_set_y16(void __iomem *regs, bool y16);
+void exynos3250_jpeg_proc_mode(void __iomem *regs, unsigned int mode);
+void exynos3250_jpeg_subsampling_mode(void __iomem *regs, unsigned int mode);
+unsigned int exynos3250_jpeg_get_subsampling_mode(void __iomem *regs);
+void exynos3250_jpeg_dri(void __iomem *regs, unsigned int dri);
+void exynos3250_jpeg_qtbl(void __iomem *regs, unsigned int t, unsigned int n);
+void exynos3250_jpeg_htbl_ac(void __iomem *regs, unsigned int t);
+void exynos3250_jpeg_htbl_dc(void __iomem *regs, unsigned int t);
+void exynos3250_jpeg_set_y(void __iomem *regs, unsigned int y);
+void exynos3250_jpeg_set_x(void __iomem *regs, unsigned int x);
+void exynos3250_jpeg_interrupts_enable(void __iomem *regs);
+void exynos3250_jpeg_enc_stream_bound(void __iomem *regs, unsigned int size);
+void exynos3250_jpeg_outform_raw(void __iomem *regs, unsigned long format);
+void exynos3250_jpeg_jpgadr(void __iomem *regs, unsigned int addr);
+void exynos3250_jpeg_imgadr(void __iomem *regs, struct s5p_jpeg_addr *img_addr);
+void exynos3250_jpeg_stride(void __iomem *regs, unsigned int img_fmt,
+			    unsigned int width);
+void exynos3250_jpeg_offset(void __iomem *regs, unsigned int x_offset,
+				unsigned int y_offset);
+void exynos3250_jpeg_coef(void __iomem *base, unsigned int mode);
+void exynos3250_jpeg_start(void __iomem *regs);
+void exynos3250_jpeg_rstart(void __iomem *regs);
+unsigned int exynos3250_jpeg_get_int_status(void __iomem *regs);
+void exynos3250_jpeg_clear_int_status(void __iomem *regs,
+						unsigned int value);
+unsigned int exynos3250_jpeg_operating(void __iomem *regs);
+unsigned int exynos3250_jpeg_compressed_size(void __iomem *regs);
+void exynos3250_jpeg_dec_stream_size(void __iomem *regs, unsigned int size);
+void exynos3250_jpeg_dec_scaling_ratio(void __iomem *regs, unsigned int sratio);
+void exynos3250_jpeg_set_timer(void __iomem *regs, unsigned int time_value);
+unsigned int exynos3250_jpeg_get_timer_status(void __iomem *regs);
+void exynos3250_jpeg_set_timer_status(void __iomem *regs);
+void exynos3250_jpeg_clear_timer_status(void __iomem *regs);
+
+#endif /* JPEG_HW_EXYNOS3250_H_ */
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-regs.h b/drivers/media/platform/s5p-jpeg/jpeg-regs.h
index 57fb05b..050fc44 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-regs.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-regs.h
@@ -2,7 +2,7 @@
  *
  * Register definition file for Samsung JPEG codec driver
  *
- * Copyright (c) 2011-2013 Samsung Electronics Co., Ltd.
+ * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
  * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
@@ -373,5 +373,250 @@
 /* JPEG AC chrominance (values) Huffman table register */
 #define EXYNOS4_HUFF_TBL_HACCV	0x310
 
+/* Register and bit definitions for Exynos 3250 */
+
+/* JPEG mode register */
+#define EXYNOS3250_JPGMOD			0x00
+#define EXYNOS3250_PROC_MODE_MASK		(0x1 << 3)
+#define EXYNOS3250_PROC_MODE_DECOMPR		(0x1 << 3)
+#define EXYNOS3250_PROC_MODE_COMPR		(0x0 << 3)
+#define EXYNOS3250_SUBSAMPLING_MODE_MASK	(0x7 << 0)
+#define EXYNOS3250_SUBSAMPLING_MODE_444		(0x0 << 0)
+#define EXYNOS3250_SUBSAMPLING_MODE_422		(0x1 << 0)
+#define EXYNOS3250_SUBSAMPLING_MODE_420		(0x2 << 0)
+#define EXYNOS3250_SUBSAMPLING_MODE_411		(0x6 << 0)
+#define EXYNOS3250_SUBSAMPLING_MODE_GRAY	(0x3 << 0)
+
+/* JPEG operation status register */
+#define EXYNOS3250_JPGOPR			0x04
+#define EXYNOS3250_JPGOPR_MASK			0x01
+
+/* Quantization and Huffman tables register */
+#define EXYNOS3250_QHTBL			0x08
+#define EXYNOS3250_QT_NUM_SHIFT(t)		((((t) - 1) << 1) + 8)
+#define EXYNOS3250_QT_NUM_MASK(t)		(0x3 << EXYNOS3250_QT_NUM_SHIFT(t))
+
+/* Huffman tables */
+#define EXYNOS3250_HT_NUM_AC_SHIFT(t)		(((t) << 1) - 1)
+#define EXYNOS3250_HT_NUM_AC_MASK(t)		(0x1 << EXYNOS3250_HT_NUM_AC_SHIFT(t))
+
+#define EXYNOS3250_HT_NUM_DC_SHIFT(t)		(((t) - 1) << 1)
+#define EXYNOS3250_HT_NUM_DC_MASK(t)		(0x1 << EXYNOS3250_HT_NUM_DC_SHIFT(t))
+
+/* JPEG restart interval register */
+#define EXYNOS3250_JPGDRI			0x0c
+#define EXYNOS3250_JPGDRI_MASK			0xffff
+
+/* JPEG vertical resolution register */
+#define EXYNOS3250_JPGY				0x10
+#define EXYNOS3250_JPGY_MASK			0xffff
+
+/* JPEG horizontal resolution register */
+#define EXYNOS3250_JPGX				0x14
+#define EXYNOS3250_JPGX_MASK			0xffff
+
+/* JPEG byte count register */
+#define EXYNOS3250_JPGCNT			0x18
+#define EXYNOS3250_JPGCNT_MASK			0xffffff
+
+/* JPEG interrupt mask register */
+#define EXYNOS3250_JPGINTSE			0x1c
+#define EXYNOS3250_JPEG_DONE_EN			(1 << 11)
+#define EXYNOS3250_WDMA_DONE_EN			(1 << 10)
+#define EXYNOS3250_RDMA_DONE_EN			(1 << 9)
+#define EXYNOS3250_ENC_STREAM_INT_EN		(1 << 8)
+#define EXYNOS3250_CORE_DONE_EN			(1 << 5)
+#define EXYNOS3250_ERR_INT_EN			(1 << 4)
+#define EXYNOS3250_HEAD_INT_EN			(1 << 3)
+
+/* JPEG interrupt status register */
+#define EXYNOS3250_JPGINTST			0x20
+#define EXYNOS3250_JPEG_DONE			(1 << 11)
+#define EXYNOS3250_WDMA_DONE			(1 << 10)
+#define EXYNOS3250_RDMA_DONE			(1 << 9)
+#define EXYNOS3250_ENC_STREAM_STAT		(1 << 8)
+#define EXYNOS3250_RESULT_STAT			(1 << 5)
+#define EXYNOS3250_STREAM_STAT			(1 << 4)
+#define EXYNOS3250_HEADER_STAT			(1 << 3)
+
+/*
+ * Base address of the luma component DMA buffer
+ * of the raw input or output image.
+ */
+#define EXYNOS3250_LUMA_BASE			0x100
+#define EXYNOS3250_SRC_TILE_EN_MASK		0x100
+
+/* Stride of source or destination luma raw image buffer */
+#define EXYNOS3250_LUMA_STRIDE			0x104
+
+/* Horizontal/vertical offset of active region in luma raw image buffer */
+#define EXYNOS3250_LUMA_XY_OFFSET		0x108
+#define EXYNOS3250_LUMA_YY_OFFSET_SHIFT		18
+#define EXYNOS3250_LUMA_YY_OFFSET_MASK		(0x1fff << EXYNOS3250_LUMA_YY_OFFSET_SHIFT)
+#define EXYNOS3250_LUMA_YX_OFFSET_SHIFT		2
+#define EXYNOS3250_LUMA_YX_OFFSET_MASK		(0x1fff << EXYNOS3250_LUMA_YX_OFFSET_SHIFT)
+
+/*
+ * Base address of the chroma(Cb) component DMA buffer
+ * of the raw input or output image.
+ */
+#define EXYNOS3250_CHROMA_BASE			0x10c
+
+/* Stride of source or destination chroma(Cb) raw image buffer */
+#define EXYNOS3250_CHROMA_STRIDE		0x110
+
+/* Horizontal/vertical offset of active region in chroma(Cb) raw image buffer */
+#define EXYNOS3250_CHROMA_XY_OFFSET		0x114
+#define EXYNOS3250_CHROMA_YY_OFFSET_SHIFT	18
+#define EXYNOS3250_CHROMA_YY_OFFSET_MASK	(0x1fff << EXYNOS3250_CHROMA_YY_OFFSET_SHIFT)
+#define EXYNOS3250_CHROMA_YX_OFFSET_SHIFT	2
+#define EXYNOS3250_CHROMA_YX_OFFSET_MASK	(0x1fff << EXYNOS3250_CHROMA_YX_OFFSET_SHIFT)
+
+/*
+ * Base address of the chroma(Cr) component DMA buffer
+ * of the raw input or output image.
+ */
+#define EXYNOS3250_CHROMA_CR_BASE		0x118
+
+/* Stride of source or destination chroma(Cr) raw image buffer */
+#define EXYNOS3250_CHROMA_CR_STRIDE		0x11c
+
+/* Horizontal/vertical offset of active region in chroma(Cb) raw image buffer */
+#define EXYNOS3250_CHROMA_CR_XY_OFFSET		0x120
+#define EXYNOS3250_CHROMA_CR_YY_OFFSET_SHIFT	18
+#define EXYNOS3250_CHROMA_CR_YY_OFFSET_MASK	(0x1fff << EXYNOS3250_CHROMA_CR_YY_OFFSET_SHIFT)
+#define EXYNOS3250_CHROMA_CR_YX_OFFSET_SHIFT	2
+#define EXYNOS3250_CHROMA_CR_YX_OFFSET_MASK	(0x1fff << EXYNOS3250_CHROMA_CR_YX_OFFSET_SHIFT)
+
+/* Raw image data r/w address register */
+#define EXYNOS3250_JPG_IMGADR			0x50
+
+/* Source or destination JPEG file DMA buffer address */
+#define EXYNOS3250_JPG_JPGADR			0x124
+
+/* Coefficients for RGB-to-YCbCr converter register */
+#define EXYNOS3250_JPG_COEF(n)			(0x128 + (((n) - 1) << 2))
+#define EXYNOS3250_COEF_SHIFT(j)		((3 - (j)) << 3)
+#define EXYNOS3250_COEF_MASK(j)			(0xff << EXYNOS3250_COEF_SHIFT(j))
+
+/* Raw input format setting */
+#define EXYNOS3250_JPGCMOD			0x134
+#define EXYNOS3250_SRC_TILE_EN			(0x1 << 10)
+#define EXYNOS3250_SRC_NV_MASK			(0x1 << 9)
+#define EXYNOS3250_SRC_NV12			(0x0 << 9)
+#define EXYNOS3250_SRC_NV21			(0x1 << 9)
+#define EXYNOS3250_SRC_BIG_ENDIAN_MASK		(0x1 << 8)
+#define EXYNOS3250_SRC_BIG_ENDIAN		(0x1 << 8)
+#define EXYNOS3250_MODE_SEL_MASK		(0x7 << 5)
+#define EXYNOS3250_MODE_SEL_420_2P		(0x0 << 5)
+#define EXYNOS3250_MODE_SEL_422_1P_LUM_CHR	(0x1 << 5)
+#define EXYNOS3250_MODE_SEL_RGB565		(0x2 << 5)
+#define EXYNOS3250_MODE_SEL_422_1P_CHR_LUM	(0x3 << 5)
+#define EXYNOS3250_MODE_SEL_ARGB8888		(0x4 << 5)
+#define EXYNOS3250_MODE_SEL_420_3P		(0x5 << 5)
+#define EXYNOS3250_SRC_SWAP_RGB			(0x1 << 3)
+#define EXYNOS3250_SRC_SWAP_UV			(0x1 << 2)
+#define EXYNOS3250_MODE_Y16_MASK		(0x1 << 1)
+#define EXYNOS3250_MODE_Y16			(0x1 << 1)
+#define EXYNOS3250_HALF_EN_MASK			(0x1 << 0)
+#define EXYNOS3250_HALF_EN			(0x1 << 0)
+
+/* Power on/off and clock down control */
+#define EXYNOS3250_JPGCLKCON			0x138
+#define EXYNOS3250_CLK_DOWN_READY		(0x1 << 1)
+#define EXYNOS3250_POWER_ON			(0x1 << 0)
+
+/* Start compression or decompression */
+#define EXYNOS3250_JSTART			0x13c
+
+/* Restart decompression after header analysis */
+#define EXYNOS3250_JRSTART			0x140
+
+/* JPEG SW reset register */
+#define EXYNOS3250_SW_RESET			0x144
+
+/* JPEG timer setting register */
+#define EXYNOS3250_TIMER_SE			0x148
+#define EXYNOS3250_TIMER_INT_EN_SHIFT		31
+#define EXYNOS3250_TIMER_INT_EN			(1 << EXYNOS3250_TIMER_INT_EN_SHIFT)
+#define EXYNOS3250_TIMER_INIT_MASK		0x7fffffff
+
+/* JPEG timer status register */
+#define EXYNOS3250_TIMER_ST			0x14c
+#define EXYNOS3250_TIMER_INT_STAT_SHIFT		31
+#define EXYNOS3250_TIMER_INT_STAT		(1 << EXYNOS3250_TIMER_INT_STAT_SHIFT)
+#define EXYNOS3250_TIMER_CNT_SHIFT		0
+#define EXYNOS3250_TIMER_CNT_MASK		0x7fffffff
+
+/* Command status register */
+#define EXYNOS3250_COMSTAT			0x150
+#define EXYNOS3250_CUR_PROC_MODE		(0x1 << 1)
+#define EXYNOS3250_CUR_COM_MODE			(0x1 << 0)
+
+/* JPEG decompression output format register */
+#define EXYNOS3250_OUTFORM			0x154
+#define EXYNOS3250_OUT_ALPHA_MASK		(0xff << 24)
+#define EXYNOS3250_OUT_TILE_EN			(0x1 << 10)
+#define EXYNOS3250_OUT_NV_MASK			(0x1 << 9)
+#define EXYNOS3250_OUT_NV12			(0x0 << 9)
+#define EXYNOS3250_OUT_NV21			(0x1 << 9)
+#define EXYNOS3250_OUT_BIG_ENDIAN_MASK		(0x1 << 8)
+#define EXYNOS3250_OUT_BIG_ENDIAN		(0x1 << 8)
+#define EXYNOS3250_OUT_SWAP_RGB			(0x1 << 7)
+#define EXYNOS3250_OUT_SWAP_UV			(0x1 << 6)
+#define EXYNOS3250_OUT_FMT_MASK			(0x7 << 0)
+#define EXYNOS3250_OUT_FMT_420_2P		(0x0 << 0)
+#define EXYNOS3250_OUT_FMT_422_1P_LUM_CHR	(0x1 << 0)
+#define EXYNOS3250_OUT_FMT_422_1P_CHR_LUM	(0x3 << 0)
+#define EXYNOS3250_OUT_FMT_420_3P		(0x4 << 0)
+#define EXYNOS3250_OUT_FMT_RGB565		(0x5 << 0)
+#define EXYNOS3250_OUT_FMT_ARGB8888		(0x6 << 0)
+
+/* Input JPEG stream byte size for decompression */
+#define EXYNOS3250_DEC_STREAM_SIZE		0x158
+#define EXYNOS3250_DEC_STREAM_MASK		0x1fffffff
+
+/* The upper bound of the byte size of output compressed stream */
+#define EXYNOS3250_ENC_STREAM_BOUND		0x15c
+#define EXYNOS3250_ENC_STREAM_BOUND_MASK	0xffffc0
+
+/* Scale-down ratio when decoding */
+#define EXYNOS3250_DEC_SCALING_RATIO		0x160
+#define EXYNOS3250_DEC_SCALE_FACTOR_MASK	0x3
+#define EXYNOS3250_DEC_SCALE_FACTOR_8_8		0x0
+#define EXYNOS3250_DEC_SCALE_FACTOR_4_8		0x1
+#define EXYNOS3250_DEC_SCALE_FACTOR_2_8		0x2
+#define EXYNOS3250_DEC_SCALE_FACTOR_1_8		0x3
+
+/* Error check */
+#define EXYNOS3250_CRC_RESULT			0x164
+
+/* RDMA and WDMA operation status register */
+#define EXYNOS3250_DMA_OPER_STATUS		0x168
+#define EXYNOS3250_WDMA_OPER_STATUS		(0x1 << 1)
+#define EXYNOS3250_RDMA_OPER_STATUS		(0x1 << 0)
+
+/* DMA issue gathering number and issue number settings */
+#define EXYNOS3250_DMA_ISSUE_NUM		0x16c
+#define EXYNOS3250_WDMA_ISSUE_NUM_SHIFT		16
+#define EXYNOS3250_WDMA_ISSUE_NUM_MASK		(0x7 << EXYNOS3250_WDMA_ISSUE_NUM_SHIFT)
+#define EXYNOS3250_RDMA_ISSUE_NUM_SHIFT		8
+#define EXYNOS3250_RDMA_ISSUE_NUM_MASK		(0x7 << EXYNOS3250_RDMA_ISSUE_NUM_SHIFT)
+#define EXYNOS3250_ISSUE_GATHER_NUM_SHIFT	0
+#define EXYNOS3250_ISSUE_GATHER_NUM_MASK	(0x7 << EXYNOS3250_ISSUE_GATHER_NUM_SHIFT)
+#define EXYNOS3250_DMA_MO_COUNT			0x7
+
+/* Version register */
+#define EXYNOS3250_VERSION			0x1fc
+
+/* RGB <-> YUV conversion coefficients */
+#define EXYNOS3250_JPEG_ENC_COEF1		0x01352e1e
+#define EXYNOS3250_JPEG_ENC_COEF2		0x00b0ae83
+#define EXYNOS3250_JPEG_ENC_COEF3		0x020cdc13
+
+#define EXYNOS3250_JPEG_DEC_COEF1		0x04a80199
+#define EXYNOS3250_JPEG_DEC_COEF2		0x04a9a064
+#define EXYNOS3250_JPEG_DEC_COEF3		0x04a80102
+
 #endif /* JPEG_REGS_H_ */
 
-- 
1.7.9.5

