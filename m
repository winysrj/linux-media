Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:56549 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3KYJ7F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Nov 2013 04:59:05 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWT00AEFD2GE230@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 25 Nov 2013 18:59:04 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, andrzej.p@samsung.com,
	s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 10/16] s5p-jpeg: Add hardware API for the exynos4x12 JPEG
 codec.
Date: Mon, 25 Nov 2013 10:58:17 +0100
Message-id: <1385373503-1657-11-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1385373503-1657-1-git-send-email-j.anaszewski@samsung.com>
References: <1385373503-1657-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/Makefile         |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c      |  620 +++++++++++++++++++---
 drivers/media/platform/s5p-jpeg/jpeg-core.h      |   72 ++-
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos.c |  293 ++++++++++
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos.h |   44 ++
 drivers/media/platform/s5p-jpeg/jpeg-regs.h      |  215 +++++++-
 6 files changed, 1152 insertions(+), 94 deletions(-)
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos.c
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos.h

diff --git a/drivers/media/platform/s5p-jpeg/Makefile b/drivers/media/platform/s5p-jpeg/Makefile
index faf6398..f981dff 100644
--- a/drivers/media/platform/s5p-jpeg/Makefile
+++ b/drivers/media/platform/s5p-jpeg/Makefile
@@ -1,2 +1,2 @@
-s5p-jpeg-objs := jpeg-core.o jpeg-hw-s5p.o
+s5p-jpeg-objs := jpeg-core.o jpeg-hw-exynos.o jpeg-hw-s5p.o
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG) += s5p-jpeg.o
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index b4d7445..02721a1 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1,9 +1,10 @@
 /* linux/drivers/media/platform/s5p-jpeg/jpeg-core.c
  *
- * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Copyright (c) 2011-2013 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
  * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -30,58 +31,212 @@
 
 #include "jpeg-core.h"
 #include "jpeg-hw-s5p.h"
+#include "jpeg-hw-exynos.h"
+#include "jpeg-regs.h"
 
-static struct s5p_jpeg_fmt formats_enc[] = {
+static struct s5p_jpeg_fmt sjpeg_formats[] = {
 	{
 		.name		= "JPEG JFIF",
 		.fourcc		= V4L2_PIX_FMT_JPEG,
+		.flags		= SJPEG_FMT_FLAG_ENC_CAPTURE |
+				  SJPEG_FMT_FLAG_DEC_OUTPUT |
+				  SJPEG_FMT_FLAG_S5P |
+				  SJPEG_FMT_FLAG_EXYNOS,
+	},
+	{
+		.name		= "YUV 4:2:2 packed, YCbYCr",
+		.fourcc		= V4L2_PIX_FMT_YUYV,
+		.depth		= 16,
 		.colplanes	= 1,
-		.types		= MEM2MEM_CAPTURE,
+		.h_align	= 4,
+		.v_align	= 3,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_S5P |
+				  SJPEG_FMT_NON_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_422,
 	},
 	{
 		.name		= "YUV 4:2:2 packed, YCbYCr",
 		.fourcc		= V4L2_PIX_FMT_YUYV,
 		.depth		= 16,
 		.colplanes	= 1,
-		.types		= MEM2MEM_OUTPUT,
+		.h_align	= 1,
+		.v_align	= 0,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_EXYNOS |
+				  SJPEG_FMT_NON_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_422,
+	},
+	{
+		.name		= "YUV 4:2:2 packed, YCrYCb",
+		.fourcc		= V4L2_PIX_FMT_YVYU,
+		.depth		= 16,
+		.colplanes	= 1,
+		.h_align	= 1,
+		.v_align	= 0,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_EXYNOS |
+				  SJPEG_FMT_NON_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_422,
 	},
 	{
 		.name		= "RGB565",
 		.fourcc		= V4L2_PIX_FMT_RGB565,
 		.depth		= 16,
 		.colplanes	= 1,
-		.types		= MEM2MEM_OUTPUT,
+		.h_align	= 0,
+		.v_align	= 0,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_EXYNOS |
+				  SJPEG_FMT_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_444,
+	},
+	{
+		.name		= "RGB565",
+		.fourcc		= V4L2_PIX_FMT_RGB565,
+		.depth		= 16,
+		.colplanes	= 1,
+		.h_align	= 0,
+		.v_align	= 0,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_S5P |
+				  SJPEG_FMT_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_444,
+	},
+	{
+		.name		= "ARGB8888, 32 bpp",
+		.fourcc		= V4L2_PIX_FMT_RGB32,
+		.depth		= 32,
+		.colplanes	= 1,
+		.h_align	= 0,
+		.v_align	= 0,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_EXYNOS |
+				  SJPEG_FMT_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_444,
+	},
+	{
+		.name		= "YUV 4:4:4 planar, Y/CbCr",
+		.fourcc		= V4L2_PIX_FMT_NV24,
+		.depth		= 24,
+		.colplanes	= 2,
+		.h_align	= 0,
+		.v_align	= 0,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_EXYNOS |
+				  SJPEG_FMT_NON_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_444,
+	},
+	{
+		.name		= "YUV 4:4:4 planar, Y/CrCb",
+		.fourcc		= V4L2_PIX_FMT_NV42,
+		.depth		= 24,
+		.colplanes	= 2,
+		.h_align	= 0,
+		.v_align	= 0,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_EXYNOS |
+				  SJPEG_FMT_NON_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_444,
+	},
+	{
+		.name		= "YUV 4:2:2 planar, Y/CrCb",
+		.fourcc		= V4L2_PIX_FMT_NV61,
+		.depth		= 16,
+		.colplanes	= 2,
+		.h_align	= 1,
+		.v_align	= 0,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_EXYNOS |
+				  SJPEG_FMT_NON_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_422,
 	},
-};
-#define NUM_FORMATS_ENC ARRAY_SIZE(formats_enc)
-
-static struct s5p_jpeg_fmt formats_dec[] = {
 	{
-		.name		= "YUV 4:2:0 planar, YCbCr",
+		.name		= "YUV 4:2:2 planar, Y/CbCr",
+		.fourcc		= V4L2_PIX_FMT_NV16,
+		.depth		= 16,
+		.colplanes	= 2,
+		.h_align	= 1,
+		.v_align	= 0,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_EXYNOS |
+				  SJPEG_FMT_NON_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_422,
+	},
+	{
+		.name		= "YUV 4:2:0 planar, Y/CbCr",
 		.fourcc		= V4L2_PIX_FMT_NV12,
-		.depth		= 12,
-		.colplanes	= 3,
-		.h_align	= 4,
-		.v_align	= 4,
-		.types		= MEM2MEM_CAPTURE,
+		.depth		= 16,
+		.colplanes	= 2,
+		.h_align	= 1,
+		.v_align	= 1,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_EXYNOS |
+				  SJPEG_FMT_NON_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_420,
 	},
 	{
-		.name		= "YUV 4:2:2 packed, YCbYCr",
-		.fourcc		= V4L2_PIX_FMT_YUYV,
+		.name		= "YUV 4:2:0 planar, Y/CbCr",
+		.fourcc		= V4L2_PIX_FMT_NV12,
 		.depth		= 16,
-		.colplanes	= 1,
+		.colplanes	= 4,
 		.h_align	= 4,
-		.v_align	= 3,
-		.types		= MEM2MEM_CAPTURE,
+		.v_align	= 1,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_S5P |
+				  SJPEG_FMT_NON_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_420,
 	},
 	{
-		.name		= "JPEG JFIF",
-		.fourcc		= V4L2_PIX_FMT_JPEG,
+		.name		= "YUV 4:2:0 planar, Y/CrCb",
+		.fourcc		= V4L2_PIX_FMT_NV21,
+		.depth		= 12,
+		.colplanes	= 2,
+		.h_align	= 1,
+		.v_align	= 1,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_EXYNOS |
+				  SJPEG_FMT_NON_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_420,
+	},
+	{
+		.name		= "YUV 4:2:0 contiguous 3-planar, Y/Cb/Cr",
+		.fourcc		= V4L2_PIX_FMT_YUV420,
+		.depth		= 12,
+		.colplanes	= 3,
+		.h_align	= 1,
+		.v_align	= 1,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_EXYNOS |
+				  SJPEG_FMT_NON_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_420,
+	},
+	{
+		.name		= "Gray",
+		.fourcc		= V4L2_PIX_FMT_GREY,
+		.depth		= 8,
 		.colplanes	= 1,
-		.types		= MEM2MEM_OUTPUT,
+		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
+				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+				  SJPEG_FMT_FLAG_EXYNOS |
+				  SJPEG_FMT_NON_RGB,
+		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY,
 	},
 };
-#define NUM_FORMATS_DEC ARRAY_SIZE(formats_dec)
+#define SJPEG_NUM_FORMATS ARRAY_SIZE(sjpeg_formats)
 
 static const unsigned char qtbl_luminance[4][64] = {
 	{/*level 0 - high compression quality */
@@ -277,6 +432,58 @@ static inline void s5p_jpeg_set_hactblg(void __iomem *regs)
 						ARRAY_SIZE(hactblg0));
 }
 
+static inline void exynos_jpeg_set_tbl(void __iomem *regs,
+				      const unsigned char *tbl,
+				      unsigned long tab, int len)
+{
+	int i;
+	unsigned int dword;
+
+	for (i = 0; i < len; i += 4) {
+		dword = tbl[i] |
+			(tbl[i + 1] << 8) |
+			(tbl[i + 2] << 16) |
+			(tbl[i + 3] << 24);
+		writel(dword, regs + tab + i);
+	}
+}
+
+static inline void exynos_jpeg_set_qtbl_lum(void __iomem *regs, int quality)
+{
+	/* this driver fills quantisation table 0 with data for luma */
+	exynos_jpeg_set_tbl(regs, qtbl_luminance[quality],
+			     EXYNOS_QTBL_CONTENT(0),
+			     ARRAY_SIZE(qtbl_luminance[quality]));
+}
+
+static inline void exynos_jpeg_set_qtbl_chr(void __iomem *regs, int quality)
+{
+	/* this driver fills quantisation table 1 with data for chroma */
+	exynos_jpeg_set_tbl(regs, qtbl_chrominance[quality],
+			     EXYNOS_QTBL_CONTENT(1),
+			     ARRAY_SIZE(qtbl_chrominance[quality]));
+}
+
+void exynos_jpeg_set_huff_tbl(void __iomem *base)
+{
+	exynos_jpeg_set_tbl(base, hdctbl0, EXYNOS_HUFF_TBL_HDCLL,
+							ARRAY_SIZE(hdctbl0));
+	exynos_jpeg_set_tbl(base, hdctbl0, EXYNOS_HUFF_TBL_HDCCL,
+							ARRAY_SIZE(hdctbl0));
+	exynos_jpeg_set_tbl(base, hdctblg0, EXYNOS_HUFF_TBL_HDCLV,
+							ARRAY_SIZE(hdctblg0));
+	exynos_jpeg_set_tbl(base, hdctblg0, EXYNOS_HUFF_TBL_HDCCV,
+							ARRAY_SIZE(hdctblg0));
+	exynos_jpeg_set_tbl(base, hactbl0, EXYNOS_HUFF_TBL_HACLL,
+							ARRAY_SIZE(hactbl0));
+	exynos_jpeg_set_tbl(base, hactbl0, EXYNOS_HUFF_TBL_HACCL,
+							ARRAY_SIZE(hactbl0));
+	exynos_jpeg_set_tbl(base, hactblg0, EXYNOS_HUFF_TBL_HACLV,
+							ARRAY_SIZE(hactblg0));
+	exynos_jpeg_set_tbl(base, hactblg0, EXYNOS_HUFF_TBL_HACCV,
+							ARRAY_SIZE(hactblg0));
+}
+
 /*
  * ============================================================================
  * Device file operations
@@ -285,8 +492,8 @@ static inline void s5p_jpeg_set_hactblg(void __iomem *regs)
 
 static int queue_init(void *priv, struct vb2_queue *src_vq,
 		      struct vb2_queue *dst_vq);
-static struct s5p_jpeg_fmt *s5p_jpeg_find_format(unsigned int mode,
-						 __u32 pixelformat);
+static struct s5p_jpeg_fmt *s5p_jpeg_find_format(struct s5p_jpeg_ctx *ctx,
+				__u32 pixelformat, unsigned int fmt_type);
 static int s5p_jpeg_controls_create(struct s5p_jpeg_ctx *ctx);
 
 static int s5p_jpeg_open(struct file *file)
@@ -294,7 +501,7 @@ static int s5p_jpeg_open(struct file *file)
 	struct s5p_jpeg *jpeg = video_drvdata(file);
 	struct video_device *vfd = video_devdata(file);
 	struct s5p_jpeg_ctx *ctx;
-	struct s5p_jpeg_fmt *out_fmt;
+	struct s5p_jpeg_fmt *out_fmt, *cap_fmt;
 	int ret = 0;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
@@ -315,16 +522,18 @@ static int s5p_jpeg_open(struct file *file)
 	ctx->jpeg = jpeg;
 	if (vfd == jpeg->vfd_encoder) {
 		ctx->mode = S5P_JPEG_ENCODE;
-		out_fmt = s5p_jpeg_find_format(ctx->mode, V4L2_PIX_FMT_RGB565);
+		out_fmt = s5p_jpeg_find_format(ctx, V4L2_PIX_FMT_RGB565,
+							FMT_TYPE_OUTPUT);
+		cap_fmt = s5p_jpeg_find_format(ctx, V4L2_PIX_FMT_JPEG,
+							FMT_TYPE_CAPTURE);
 	} else {
 		ctx->mode = S5P_JPEG_DECODE;
-		out_fmt = s5p_jpeg_find_format(ctx->mode, V4L2_PIX_FMT_JPEG);
+		out_fmt = s5p_jpeg_find_format(ctx, V4L2_PIX_FMT_JPEG,
+							FMT_TYPE_OUTPUT);
+		cap_fmt = s5p_jpeg_find_format(ctx, V4L2_PIX_FMT_YUYV,
+							FMT_TYPE_CAPTURE);
 	}
 
-	ret = s5p_jpeg_controls_create(ctx);
-	if (ret < 0)
-		goto error;
-
 	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(jpeg->m2m_dev, ctx, queue_init);
 	if (IS_ERR(ctx->fh.m2m_ctx)) {
 		ret = PTR_ERR(ctx->fh.m2m_ctx);
@@ -332,7 +541,12 @@ static int s5p_jpeg_open(struct file *file)
 	}
 
 	ctx->out_q.fmt = out_fmt;
-	ctx->cap_q.fmt = s5p_jpeg_find_format(ctx->mode, V4L2_PIX_FMT_YUYV);
+	ctx->cap_q.fmt = cap_fmt;
+
+	ret = s5p_jpeg_controls_create(ctx);
+	if (ret < 0)
+		goto error;
+
 	mutex_unlock(&jpeg->lock);
 	return 0;
 
@@ -352,11 +566,11 @@ static int s5p_jpeg_release(struct file *file)
 
 	mutex_lock(&jpeg->lock);
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
-	mutex_unlock(&jpeg->lock);
 	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 	kfree(ctx);
+	mutex_unlock(&jpeg->lock);
 
 	return 0;
 }
@@ -504,13 +718,13 @@ static int s5p_jpeg_querycap(struct file *file, void *priv,
 	return 0;
 }
 
-static int enum_fmt(struct s5p_jpeg_fmt *formats, int n,
+static int enum_fmt(struct s5p_jpeg_fmt *sjpeg_formats, int n,
 		    struct v4l2_fmtdesc *f, u32 type)
 {
 	int i, num = 0;
 
 	for (i = 0; i < n; ++i) {
-		if (formats[i].types & type) {
+		if (sjpeg_formats[i].flags & type) {
 			/* index-th format of type type found ? */
 			if (num == f->index)
 				break;
@@ -524,8 +738,8 @@ static int enum_fmt(struct s5p_jpeg_fmt *formats, int n,
 	if (i >= n)
 		return -EINVAL;
 
-	strlcpy(f->description, formats[i].name, sizeof(f->description));
-	f->pixelformat = formats[i].fourcc;
+	strlcpy(f->description, sjpeg_formats[i].name, sizeof(f->description));
+	f->pixelformat = sjpeg_formats[i].fourcc;
 
 	return 0;
 }
@@ -536,10 +750,11 @@ static int s5p_jpeg_enum_fmt_vid_cap(struct file *file, void *priv,
 	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 
 	if (ctx->mode == S5P_JPEG_ENCODE)
-		return enum_fmt(formats_enc, NUM_FORMATS_ENC, f,
-				MEM2MEM_CAPTURE);
+		return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
+				SJPEG_FMT_FLAG_ENC_CAPTURE);
 
-	return enum_fmt(formats_dec, NUM_FORMATS_DEC, f, MEM2MEM_CAPTURE);
+	return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
+					SJPEG_FMT_FLAG_DEC_CAPTURE);
 }
 
 static int s5p_jpeg_enum_fmt_vid_out(struct file *file, void *priv,
@@ -548,10 +763,11 @@ static int s5p_jpeg_enum_fmt_vid_out(struct file *file, void *priv,
 	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 
 	if (ctx->mode == S5P_JPEG_ENCODE)
-		return enum_fmt(formats_enc, NUM_FORMATS_ENC, f,
-				MEM2MEM_OUTPUT);
+		return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
+				SJPEG_FMT_FLAG_ENC_OUTPUT);
 
-	return enum_fmt(formats_dec, NUM_FORMATS_DEC, f, MEM2MEM_OUTPUT);
+	return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
+					SJPEG_FMT_FLAG_DEC_OUTPUT);
 }
 
 static struct s5p_jpeg_q_data *get_q_data(struct s5p_jpeg_ctx *ctx,
@@ -598,29 +814,35 @@ static int s5p_jpeg_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	return 0;
 }
 
-static struct s5p_jpeg_fmt *s5p_jpeg_find_format(unsigned int mode,
-						 u32 pixelformat)
+static struct s5p_jpeg_fmt *s5p_jpeg_find_format(struct s5p_jpeg_ctx *ctx,
+				u32 pixelformat, unsigned int fmt_type)
 {
-	unsigned int k;
-	struct s5p_jpeg_fmt *formats;
-	int n;
+	unsigned int k, fmt_flag, ver_flag;
 
-	if (mode == S5P_JPEG_ENCODE) {
-		formats = formats_enc;
-		n = NUM_FORMATS_ENC;
-	} else {
-		formats = formats_dec;
-		n = NUM_FORMATS_DEC;
-	}
+	if (ctx->mode == S5P_JPEG_ENCODE)
+		fmt_flag = (fmt_type == FMT_TYPE_OUTPUT) ?
+				SJPEG_FMT_FLAG_ENC_OUTPUT :
+				SJPEG_FMT_FLAG_ENC_CAPTURE;
+	else
+		fmt_flag = (fmt_type == FMT_TYPE_OUTPUT) ?
+				SJPEG_FMT_FLAG_DEC_OUTPUT :
+				SJPEG_FMT_FLAG_DEC_CAPTURE;
 
-	for (k = 0; k < n; k++) {
-		struct s5p_jpeg_fmt *fmt = &formats[k];
-		if (fmt->fourcc == pixelformat)
+	if (ctx->jpeg->variant->version == SJPEG_S5P)
+		ver_flag = SJPEG_FMT_FLAG_S5P;
+	else
+		ver_flag = SJPEG_FMT_FLAG_EXYNOS;
+
+	for (k = 0; k < ARRAY_SIZE(sjpeg_formats); k++) {
+		struct s5p_jpeg_fmt *fmt = &sjpeg_formats[k];
+		if (fmt->fourcc == pixelformat &&
+		    fmt->flags & fmt_flag &&
+		    fmt->flags & ver_flag) {
 			return fmt;
+		}
 	}
 
 	return NULL;
-
 }
 
 static void jpeg_bound_align_image(u32 *w, unsigned int wmin, unsigned int wmax,
@@ -656,7 +878,7 @@ static int vidioc_try_fmt(struct v4l2_format *f, struct s5p_jpeg_fmt *fmt,
 
 	/* V4L2 specification suggests the driver corrects the format struct
 	 * if any of the dimensions is unsupported */
-	if (q_type == MEM2MEM_OUTPUT)
+	if (q_type == FMT_TYPE_OUTPUT)
 		jpeg_bound_align_image(&pix->width, S5P_JPEG_MIN_WIDTH,
 				       S5P_JPEG_MAX_WIDTH, 0,
 				       &pix->height, S5P_JPEG_MIN_HEIGHT,
@@ -694,15 +916,16 @@ static int s5p_jpeg_try_fmt_vid_cap(struct file *file, void *priv,
 	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 	struct s5p_jpeg_fmt *fmt;
 
-	fmt = s5p_jpeg_find_format(ctx->mode, f->fmt.pix.pixelformat);
-	if (!fmt || !(fmt->types & MEM2MEM_CAPTURE)) {
+	fmt = s5p_jpeg_find_format(ctx, f->fmt.pix.pixelformat,
+						FMT_TYPE_CAPTURE);
+	if (!fmt) {
 		v4l2_err(&ctx->jpeg->v4l2_dev,
 			 "Fourcc format (0x%08x) invalid.\n",
 			 f->fmt.pix.pixelformat);
 		return -EINVAL;
 	}
 
-	return vidioc_try_fmt(f, fmt, ctx, MEM2MEM_CAPTURE);
+	return vidioc_try_fmt(f, fmt, ctx, FMT_TYPE_CAPTURE);
 }
 
 static int s5p_jpeg_try_fmt_vid_out(struct file *file, void *priv,
@@ -711,15 +934,16 @@ static int s5p_jpeg_try_fmt_vid_out(struct file *file, void *priv,
 	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 	struct s5p_jpeg_fmt *fmt;
 
-	fmt = s5p_jpeg_find_format(ctx->mode, f->fmt.pix.pixelformat);
-	if (!fmt || !(fmt->types & MEM2MEM_OUTPUT)) {
+	fmt = s5p_jpeg_find_format(ctx, f->fmt.pix.pixelformat,
+						FMT_TYPE_OUTPUT);
+	if (!fmt) {
 		v4l2_err(&ctx->jpeg->v4l2_dev,
 			 "Fourcc format (0x%08x) invalid.\n",
 			 f->fmt.pix.pixelformat);
 		return -EINVAL;
 	}
 
-	return vidioc_try_fmt(f, fmt, ctx, MEM2MEM_OUTPUT);
+	return vidioc_try_fmt(f, fmt, ctx, FMT_TYPE_OUTPUT);
 }
 
 static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx *ct, struct v4l2_format *f)
@@ -727,6 +951,7 @@ static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx *ct, struct v4l2_format *f)
 	struct vb2_queue *vq;
 	struct s5p_jpeg_q_data *q_data = NULL;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
+	unsigned int f_type;
 
 	vq = v4l2_m2m_get_vq(ct->fh.m2m_ctx, f->type);
 	if (!vq)
@@ -740,7 +965,10 @@ static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx *ct, struct v4l2_format *f)
 		return -EBUSY;
 	}
 
-	q_data->fmt = s5p_jpeg_find_format(ct->mode, pix->pixelformat);
+	f_type = V4L2_TYPE_IS_OUTPUT(f->type) ?
+			FMT_TYPE_OUTPUT : FMT_TYPE_CAPTURE;
+
+	q_data->fmt = s5p_jpeg_find_format(ct, pix->pixelformat, f_type);
 	q_data->w = pix->width;
 	q_data->h = pix->height;
 	if (q_data->fmt->fourcc != V4L2_PIX_FMT_JPEG)
@@ -781,7 +1009,8 @@ static int s5p_jpeg_g_selection(struct file *file, void *priv,
 	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 
 	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT &&
-	    s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	    s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+	    ctx->jpeg->variant->version != SJPEG_S5P)
 		return -EINVAL;
 
 	/* For JPEG blob active == default == bounds */
@@ -1016,6 +1245,106 @@ static void s5p_jpeg_device_run(void *priv)
 	spin_unlock_irqrestore(&ctx->jpeg->slock, flags);
 }
 
+static void exynos_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
+{
+	struct s5p_jpeg *jpeg = ctx->jpeg;
+	struct s5p_jpeg_fmt *fmt;
+	struct vb2_buffer *vb;
+	struct s5p_jpeg_addr jpeg_addr;
+	u32 pix_size, padding_bytes = 0;
+
+	pix_size = ctx->cap_q.w * ctx->cap_q.h;
+
+	if (ctx->mode == S5P_JPEG_ENCODE) {
+		vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+		fmt = ctx->out_q.fmt;
+		if (ctx->out_q.w % 2 && fmt->h_align > 0)
+			padding_bytes = ctx->out_q.h;
+	} else {
+		fmt = ctx->cap_q.fmt;
+		vb = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
+	}
+
+	jpeg_addr.y = vb2_dma_contig_plane_dma_addr(vb, 0);
+
+	if (fmt->colplanes == 2) {
+		jpeg_addr.cb = jpeg_addr.y + pix_size - padding_bytes;
+	} else if (fmt->colplanes == 3) {
+		jpeg_addr.cb = jpeg_addr.y + pix_size;
+		if (fmt->fourcc == V4L2_PIX_FMT_YUV420)
+			jpeg_addr.cr = jpeg_addr.cb + pix_size / 4;
+		else
+			jpeg_addr.cr = jpeg_addr.cb + pix_size / 2;
+	}
+
+	jpeg_set_frame_buf_address(jpeg->regs, &jpeg_addr);
+}
+
+static void exynos_jpeg_set_jpeg_addr(struct s5p_jpeg_ctx *ctx)
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
+	jpeg_set_stream_buf_address(jpeg->regs, jpeg_addr);
+}
+
+static void exynos_jpeg_device_run(void *priv)
+{
+	struct s5p_jpeg_ctx *ctx = priv;
+	struct s5p_jpeg *jpeg = ctx->jpeg;
+	unsigned int bitstream_size;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->jpeg->slock, flags);
+
+	if (ctx->mode == S5P_JPEG_ENCODE) {
+		jpeg_sw_reset(jpeg->regs);
+		jpeg_set_interrupt(jpeg->regs);
+		jpeg_set_huf_table_enable(jpeg->regs, 1);
+
+		exynos_jpeg_set_huff_tbl(jpeg->regs);
+
+		/*
+		 * JPEG IP allows storing 4 quantization tables
+		 * We fill table 0 for luma and table 1 for chroma
+		 */
+		exynos_jpeg_set_qtbl_lum(jpeg->regs, ctx->compr_quality);
+		exynos_jpeg_set_qtbl_chr(jpeg->regs, ctx->compr_quality);
+
+		jpeg_set_encode_tbl_select(jpeg->regs, ctx->compr_quality);
+		jpeg_set_stream_size(jpeg->regs, ctx->cap_q.w, ctx->cap_q.h);
+
+		jpeg_set_enc_out_fmt(jpeg->regs, ctx->subsampling);
+		jpeg_set_img_fmt(jpeg->regs, ctx->out_q.fmt->fourcc);
+		exynos_jpeg_set_img_addr(ctx);
+		exynos_jpeg_set_jpeg_addr(ctx);
+		jpeg_set_encode_hoff_cnt(jpeg->regs, ctx->out_q.fmt->fourcc);
+		jpeg_set_timer_count(jpeg->regs,
+				     ctx->cap_q.w * ctx->cap_q.h * 32 + 0xff);
+	} else {
+		jpeg_sw_reset(jpeg->regs);
+		jpeg_set_interrupt(jpeg->regs);
+		exynos_jpeg_set_img_addr(ctx);
+		exynos_jpeg_set_jpeg_addr(ctx);
+		jpeg_set_img_fmt(jpeg->regs, ctx->cap_q.fmt->fourcc);
+
+		bitstream_size = DIV_ROUND_UP(ctx->out_q.size, 32);
+
+		jpeg_set_dec_bitstream_size(jpeg->regs, bitstream_size);
+	}
+
+	jpeg_set_enc_dec_mode(jpeg->regs, ctx->mode);
+
+	spin_unlock_irqrestore(&ctx->jpeg->slock, flags);
+}
+
 static int s5p_jpeg_job_ready(void *priv)
 {
 	struct s5p_jpeg_ctx *ctx = priv;
@@ -1033,6 +1362,12 @@ static struct v4l2_m2m_ops s5p_jpeg_m2m_ops = {
 	.device_run	= s5p_jpeg_device_run,
 	.job_ready	= s5p_jpeg_job_ready,
 	.job_abort	= s5p_jpeg_job_abort,
+}
+;
+static struct v4l2_m2m_ops exynos_jpeg_m2m_ops = {
+	.device_run	= exynos_jpeg_device_run,
+	.job_ready	= s5p_jpeg_job_ready,
+	.job_abort	= s5p_jpeg_job_abort,
 };
 
 /*
@@ -1238,6 +1573,69 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t exynos_jpeg_irq(int irq, void *priv)
+{
+	unsigned int int_status;
+	struct vb2_buffer *src_vb, *dst_vb;
+	struct s5p_jpeg *jpeg = priv;
+	struct s5p_jpeg_ctx *curr_ctx;
+	unsigned long payload_size = 0;
+
+	spin_lock(&jpeg->slock);
+
+	curr_ctx = v4l2_m2m_get_curr_priv(jpeg->m2m_dev);
+
+	src_vb = v4l2_m2m_src_buf_remove(curr_ctx->fh.m2m_ctx);
+	dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->fh.m2m_ctx);
+
+	int_status = jpeg_get_int_status(jpeg->regs);
+
+	if (int_status) {
+		switch (int_status & 0x1f) {
+		case 0x1:
+			jpeg->irq_ret = ERR_PROT;
+			break;
+		case 0x2:
+			jpeg->irq_ret = OK_ENC_OR_DEC;
+			break;
+		case 0x4:
+			jpeg->irq_ret = ERR_DEC_INVALID_FORMAT;
+			break;
+		case 0x8:
+			jpeg->irq_ret = ERR_MULTI_SCAN;
+			break;
+		case 0x10:
+			jpeg->irq_ret = ERR_FRAME;
+			break;
+		default:
+			jpeg->irq_ret = ERR_UNKNOWN;
+			break;
+		}
+	} else {
+		jpeg->irq_ret = ERR_UNKNOWN;
+	}
+
+	if (jpeg->irq_ret == OK_ENC_OR_DEC) {
+		if (curr_ctx->mode == S5P_JPEG_ENCODE) {
+			payload_size = jpeg_get_stream_size(jpeg->regs);
+			vb2_set_plane_payload(dst_vb, 0, payload_size);
+		}
+		v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
+		v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
+	} else {
+		v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_ERROR);
+		v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_ERROR);
+	}
+
+	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
+	curr_ctx->subsampling = jpeg_get_frame_fmt(jpeg->regs);
+
+	spin_unlock(&jpeg->slock);
+	return IRQ_HANDLED;
+}
+
+static void *jpeg_get_drv_data(struct platform_device *pdev);
+
 /*
  * ============================================================================
  * Driver basic infrastructure
@@ -1248,13 +1646,19 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 {
 	struct s5p_jpeg *jpeg;
 	struct resource *res;
+	struct v4l2_m2m_ops *samsung_jpeg_m2m_ops;
 	int ret;
 
+	if (!pdev->dev.of_node)
+		return -ENODEV;
+
 	/* JPEG IP abstraction struct */
 	jpeg = devm_kzalloc(&pdev->dev, sizeof(struct s5p_jpeg), GFP_KERNEL);
 	if (!jpeg)
 		return -ENOMEM;
 
+	jpeg->variant = jpeg_get_drv_data(pdev);
+
 	mutex_init(&jpeg->lock);
 	spin_lock_init(&jpeg->slock);
 	jpeg->dev = &pdev->dev;
@@ -1273,8 +1677,8 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	ret = devm_request_irq(&pdev->dev, jpeg->irq, s5p_jpeg_irq, 0,
-			dev_name(&pdev->dev), jpeg);
+	ret = devm_request_irq(&pdev->dev, jpeg->irq, jpeg->variant->jpeg_irq,
+				0, dev_name(&pdev->dev), jpeg);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot claim IRQ %d\n", jpeg->irq);
 		return ret;
@@ -1296,8 +1700,13 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 		goto clk_get_rollback;
 	}
 
+	if (jpeg->variant->version == SJPEG_S5P)
+		samsung_jpeg_m2m_ops = &s5p_jpeg_m2m_ops;
+	else
+		samsung_jpeg_m2m_ops = &exynos_jpeg_m2m_ops;
+
 	/* mem2mem device */
-	jpeg->m2m_dev = v4l2_m2m_init(&s5p_jpeg_m2m_ops);
+	jpeg->m2m_dev = v4l2_m2m_init(samsung_jpeg_m2m_ops);
 	if (IS_ERR(jpeg->m2m_dev)) {
 		v4l2_err(&jpeg->v4l2_dev, "Failed to init mem2mem device\n");
 		ret = PTR_ERR(jpeg->m2m_dev);
@@ -1445,12 +1854,16 @@ static int s5p_jpeg_runtime_resume(struct device *dev)
 
 	/*
 	 * JPEG IP allows storing two Huffman tables for each component
-	 * We fill table 0 for each component
+	 * We fill table 0 for each component and do this here only
+	 * for S5PC210 device as Exynos4x12 requires programming its
+	 * Huffman tables each time the encoding process is initialized.
 	 */
-	s5p_jpeg_set_hdctbl(jpeg->regs);
-	s5p_jpeg_set_hdctblg(jpeg->regs);
-	s5p_jpeg_set_hactbl(jpeg->regs);
-	s5p_jpeg_set_hactblg(jpeg->regs);
+	if (jpeg->variant->version == SJPEG_S5P) {
+		s5p_jpeg_set_hdctbl(jpeg->regs);
+		s5p_jpeg_set_hdctblg(jpeg->regs);
+		s5p_jpeg_set_hactbl(jpeg->regs);
+		s5p_jpeg_set_hactblg(jpeg->regs);
+	}
 
 	spin_unlock_irqrestore(&jpeg->slock, flags);
 
@@ -1479,27 +1892,60 @@ static const struct dev_pm_ops s5p_jpeg_pm_ops = {
 };
 
 #ifdef CONFIG_OF
-static const struct of_device_id s5p_jpeg_of_match[] = {
-	{ .compatible = "samsung,s5pv210-jpeg" },
-	{ .compatible = "samsung,exynos4210-jpeg" },
-	{ /* sentinel */ },
+static struct s5p_jpeg_variant s5p_jpeg_drvdata = {
+	.version	= SJPEG_S5P,
+	.jpeg_irq	= s5p_jpeg_irq,
 };
-MODULE_DEVICE_TABLE(of, s5p_jpeg_of_match);
+
+static struct s5p_jpeg_variant exynos_jpeg_drvdata = {
+	.version	= SJPEG_EXYNOS,
+	.jpeg_irq	= exynos_jpeg_irq,
+};
+
+static const struct of_device_id samsung_jpeg_match[] = {
+	{
+		.compatible = "samsung,s5pv210-jpeg",
+		.data = &s5p_jpeg_drvdata,
+	}, {
+		.compatible = "samsung,exynos4210-jpeg",
+		.data = &s5p_jpeg_drvdata,
+	}, {
+		.compatible = "samsung,exynos4212-jpeg",
+		.data = &exynos_jpeg_drvdata,
+	},
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, samsung_jpeg_match);
+
+static void *jpeg_get_drv_data(struct platform_device *pdev)
+{
+	struct s5p_jpeg_variant *driver_data = NULL;
+	const struct of_device_id *match;
+
+	match = of_match_node(of_match_ptr(samsung_jpeg_match),
+					 pdev->dev.of_node);
+	if (match)
+		driver_data = (struct s5p_jpeg_variant *)match->data;
+
+	return driver_data;
+}
 #endif
 
 static struct platform_driver s5p_jpeg_driver = {
 	.probe = s5p_jpeg_probe,
 	.remove = s5p_jpeg_remove,
 	.driver = {
-		.of_match_table = of_match_ptr(s5p_jpeg_of_match),
-		.owner = THIS_MODULE,
-		.name = S5P_JPEG_M2M_NAME,
-		.pm = &s5p_jpeg_pm_ops,
+		.of_match_table	= of_match_ptr(samsung_jpeg_match),
+		.owner		= THIS_MODULE,
+		.name		= S5P_JPEG_M2M_NAME,
+		.pm		= &s5p_jpeg_pm_ops,
 	},
 };
 
 module_platform_driver(s5p_jpeg_driver);
 
 MODULE_AUTHOR("Andrzej Pietrasiewicz <andrzej.p@samsung.com>");
+MODULE_AUTHOR("Jacek Anaszewski <j.anaszewski@samsung.com>");
 MODULE_DESCRIPTION("Samsung JPEG codec driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.h b/drivers/media/platform/s5p-jpeg/jpeg-core.h
index 7baadf3..749bc61 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.h
@@ -13,6 +13,7 @@
 #ifndef JPEG_CORE_H_
 #define JPEG_CORE_H_
 
+#include <linux/interrupt.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-ctrls.h>
@@ -42,12 +43,52 @@
 #define EOI				0xd9
 #define DHP				0xde
 
+/* Flags that indicate a format can be used for capture/output */
+#define SJPEG_FMT_FLAG_ENC_CAPTURE	(1 << 0)
+#define SJPEG_FMT_FLAG_ENC_OUTPUT	(1 << 1)
+#define SJPEG_FMT_FLAG_DEC_CAPTURE	(1 << 2)
+#define SJPEG_FMT_FLAG_DEC_OUTPUT	(1 << 3)
+#define SJPEG_FMT_FLAG_S5P		(1 << 4)
+#define SJPEG_FMT_FLAG_EXYNOS		(1 << 5)
+#define SJPEG_FMT_RGB			(1 << 6)
+#define SJPEG_FMT_NON_RGB		(1 << 7)
+
 #define S5P_JPEG_ENCODE		0
 #define S5P_JPEG_DECODE		1
 
-/* Flags that indicate a format can be used for capture/output */
-#define MEM2MEM_CAPTURE			(1 << 0)
-#define MEM2MEM_OUTPUT			(1 << 1)
+#define FMT_TYPE_OUTPUT		0
+#define FMT_TYPE_CAPTURE	1
+
+#define SJPEG_SUBSAMPLING_444	0x11
+#define SJPEG_SUBSAMPLING_422	0x21
+#define SJPEG_SUBSAMPLING_420	0x22
+
+/* Version numbers */
+
+#define SJPEG_S5P	1
+#define SJPEG_EXYNOS	2
+
+enum exynos_jpeg_result {
+	OK_ENC_OR_DEC,
+	ERR_PROT,
+	ERR_DEC_INVALID_FORMAT,
+	ERR_MULTI_SCAN,
+	ERR_FRAME,
+	ERR_UNKNOWN,
+};
+
+enum  exynos_jpeg_img_quality_level {
+	QUALITY_LEVEL_1 = 0,	/* high */
+	QUALITY_LEVEL_2,
+	QUALITY_LEVEL_3,
+	QUALITY_LEVEL_4,	/* low */
+};
+
+enum exynos_jpeg_scale_value {
+	JPEG_SCALE_NORMAL,
+	JPEG_SCALE_2,
+	JPEG_SCALE_4,
+};
 
 
 
@@ -76,9 +117,16 @@ struct s5p_jpeg {
 
 	void __iomem		*regs;
 	unsigned int		irq;
+	enum exynos_jpeg_result	irq_ret;
 	struct clk		*clk;
 	struct device		*dev;
 	void			*alloc_ctx;
+	struct s5p_jpeg_variant *variant;
+};
+
+struct s5p_jpeg_variant {
+	unsigned int	version;
+	irqreturn_t	(*jpeg_irq)(int irq, void *priv);
 };
 
 /**
@@ -89,16 +137,18 @@ struct s5p_jpeg {
  * @colplanes:	number of color planes (1 for packed formats)
  * @h_align:	horizontal alignment order (align to 2^h_align)
  * @v_align:	vertical alignment order (align to 2^v_align)
- * @types:	types of queue this format is applicable to
+ * @flags:	flags describing format applicability
  */
 struct s5p_jpeg_fmt {
 	char	*name;
 	u32	fourcc;
 	int	depth;
 	int	colplanes;
+	int	memplanes;
 	int	h_align;
 	int	v_align;
-	u32	types;
+	int	subsampling;
+	u32	flags;
 };
 
 /**
@@ -150,4 +200,16 @@ struct s5p_jpeg_buffer {
 	unsigned long data;
 };
 
+/**
+ * struct s5p_jpeg_addr - JPEG converter physical address set for DMA
+ * @y:   luminance plane physical address
+ * @cb:  Cb plane physical address
+ * @cr:  Cr plane physical address
+ */
+struct s5p_jpeg_addr {
+	u32     y;
+	u32     cb;
+	u32     cr;
+};
+
 #endif /* JPEG_CORE_H */
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos.c
new file mode 100644
index 0000000..fb57adc
--- /dev/null
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos.c
@@ -0,0 +1,293 @@
+/* Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * Register interface file for JPEG driver on Exynos4x12.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/io.h>
+#include <linux/delay.h>
+
+#include "jpeg-core.h"
+#include "jpeg-hw-exynos.h"
+#include "jpeg-regs.h"
+
+void jpeg_sw_reset(void __iomem *base)
+{
+	unsigned int reg;
+
+	reg = readl(base + EXYNOS_JPEG_CNTL_REG);
+	writel(reg & ~EXYNOS_SOFT_RESET_HI, base + EXYNOS_JPEG_CNTL_REG);
+
+	ndelay(100000);
+
+	writel(reg | EXYNOS_SOFT_RESET_HI, base + EXYNOS_JPEG_CNTL_REG);
+}
+
+void jpeg_set_enc_dec_mode(void __iomem *base, unsigned int mode)
+{
+	unsigned int reg;
+
+	reg = readl(base + EXYNOS_JPEG_CNTL_REG);
+	/* set jpeg mod register */
+	if (mode == S5P_JPEG_DECODE) {
+		writel((reg & EXYNOS_ENC_DEC_MODE_MASK) |
+					EXYNOS_DEC_MODE,
+			base + EXYNOS_JPEG_CNTL_REG);
+	} else {/* encode */
+		writel((reg & EXYNOS_ENC_DEC_MODE_MASK) |
+					EXYNOS_ENC_MODE,
+			base + EXYNOS_JPEG_CNTL_REG);
+	}
+}
+
+void jpeg_set_img_fmt(void __iomem *base, unsigned int img_fmt)
+{
+	unsigned int reg;
+
+	reg = readl(base + EXYNOS_IMG_FMT_REG) &
+			EXYNOS_ENC_IN_FMT_MASK; /* clear except enc format */
+
+	switch (img_fmt) {
+	case V4L2_PIX_FMT_GREY:
+		reg = reg | EXYNOS_ENC_GRAY_IMG | EXYNOS_GRAY_IMG_IP;
+		break;
+	case V4L2_PIX_FMT_RGB32:
+		reg = reg | EXYNOS_ENC_RGB_IMG |
+				EXYNOS_RGB_IP_RGB_32BIT_IMG;
+		break;
+	case V4L2_PIX_FMT_RGB565:
+		reg = reg | EXYNOS_ENC_RGB_IMG |
+				EXYNOS_RGB_IP_RGB_16BIT_IMG;
+		break;
+	case V4L2_PIX_FMT_NV24:
+		reg = reg | EXYNOS_ENC_YUV_444_IMG |
+				EXYNOS_YUV_444_IP_YUV_444_2P_IMG |
+				EXYNOS_SWAP_CHROMA_CBCR;
+		break;
+	case V4L2_PIX_FMT_NV42:
+		reg = reg | EXYNOS_ENC_YUV_444_IMG |
+				EXYNOS_YUV_444_IP_YUV_444_2P_IMG |
+				EXYNOS_SWAP_CHROMA_CRCB;
+		break;
+	case V4L2_PIX_FMT_YUYV:
+		reg = reg | EXYNOS_DEC_YUV_422_IMG |
+				EXYNOS_YUV_422_IP_YUV_422_1P_IMG |
+				EXYNOS_SWAP_CHROMA_CBCR;
+		break;
+
+	case V4L2_PIX_FMT_YVYU:
+		reg = reg | EXYNOS_DEC_YUV_422_IMG |
+				EXYNOS_YUV_422_IP_YUV_422_1P_IMG |
+				EXYNOS_SWAP_CHROMA_CRCB;
+		break;
+	case V4L2_PIX_FMT_NV16:
+		reg = reg | EXYNOS_DEC_YUV_422_IMG |
+				EXYNOS_YUV_422_IP_YUV_422_2P_IMG |
+				EXYNOS_SWAP_CHROMA_CBCR;
+		break;
+	case V4L2_PIX_FMT_NV61:
+		reg = reg | EXYNOS_DEC_YUV_422_IMG |
+				EXYNOS_YUV_422_IP_YUV_422_2P_IMG |
+				EXYNOS_SWAP_CHROMA_CRCB;
+		break;
+	case V4L2_PIX_FMT_NV12:
+		reg = reg | EXYNOS_DEC_YUV_420_IMG |
+				EXYNOS_YUV_420_IP_YUV_420_2P_IMG |
+				EXYNOS_SWAP_CHROMA_CBCR;
+		break;
+	case V4L2_PIX_FMT_NV21:
+		reg = reg | EXYNOS_DEC_YUV_420_IMG |
+				EXYNOS_YUV_420_IP_YUV_420_2P_IMG |
+				EXYNOS_SWAP_CHROMA_CRCB;
+		break;
+	case V4L2_PIX_FMT_YUV420:
+		reg = reg | EXYNOS_DEC_YUV_420_IMG |
+				EXYNOS_YUV_420_IP_YUV_420_3P_IMG |
+				EXYNOS_SWAP_CHROMA_CBCR;
+		break;
+	default:
+		break;
+
+	}
+
+	writel(reg, base + EXYNOS_IMG_FMT_REG);
+}
+
+void jpeg_set_enc_out_fmt(void __iomem *base, unsigned int out_fmt)
+{
+	unsigned int reg;
+
+	reg = readl(base + EXYNOS_IMG_FMT_REG) &
+			~EXYNOS_ENC_FMT_MASK; /* clear enc format */
+
+	switch (out_fmt) {
+	case V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY:
+		reg = reg | EXYNOS_ENC_FMT_GRAY;
+		break;
+
+	case V4L2_JPEG_CHROMA_SUBSAMPLING_444:
+		reg = reg | EXYNOS_ENC_FMT_YUV_444;
+		break;
+
+	case V4L2_JPEG_CHROMA_SUBSAMPLING_422:
+		reg = reg | EXYNOS_ENC_FMT_YUV_422;
+		break;
+
+	case V4L2_JPEG_CHROMA_SUBSAMPLING_420:
+		reg = reg | EXYNOS_ENC_FMT_YUV_420;
+		break;
+
+	default:
+		break;
+	}
+
+	writel(reg, base + EXYNOS_IMG_FMT_REG);
+}
+
+void jpeg_set_interrupt(void __iomem *base)
+{
+	unsigned int reg;
+
+	reg = readl(base + EXYNOS_INT_EN_REG) & ~EXYNOS_INT_EN_MASK;
+	writel(EXYNOS_INT_EN_ALL, base + EXYNOS_INT_EN_REG);
+}
+
+unsigned int jpeg_get_int_status(void __iomem *base)
+{
+	unsigned int	int_status;
+
+	int_status = readl(base + EXYNOS_INT_STATUS_REG);
+
+	return int_status;
+}
+
+unsigned int jpeg_get_fifo_status(void __iomem *base)
+{
+	unsigned int fifo_status;
+
+	fifo_status = readl(base + EXYNOS_FIFO_STATUS_REG);
+
+	return fifo_status;
+}
+
+void jpeg_set_huf_table_enable(void __iomem *base, int value)
+{
+	unsigned int	reg;
+
+	reg = readl(base + EXYNOS_JPEG_CNTL_REG) & ~EXYNOS_HUF_TBL_EN;
+
+	if (value == 1)
+		writel(reg | EXYNOS_HUF_TBL_EN,
+					base + EXYNOS_JPEG_CNTL_REG);
+	else
+		writel(reg | ~EXYNOS_HUF_TBL_EN,
+					base + EXYNOS_JPEG_CNTL_REG);
+}
+
+void jpeg_set_dec_scaling(void __iomem *base,
+			  enum exynos_jpeg_scale_value x_value,
+			  enum exynos_jpeg_scale_value y_value)
+{
+	unsigned int	reg;
+
+	reg = readl(base + EXYNOS_JPEG_CNTL_REG) &
+			~(EXYNOS_HOR_SCALING_MASK |
+				EXYNOS_VER_SCALING_MASK);
+
+	writel(reg | EXYNOS_HOR_SCALING(x_value) |
+			EXYNOS_VER_SCALING(y_value),
+				base + EXYNOS_JPEG_CNTL_REG);
+}
+
+void jpeg_set_sys_int_enable(void __iomem *base, int value)
+{
+	unsigned int	reg;
+
+	reg = readl(base + EXYNOS_JPEG_CNTL_REG) & ~(EXYNOS_SYS_INT_EN);
+
+	if (value == 1)
+		writel(EXYNOS_SYS_INT_EN, base + EXYNOS_JPEG_CNTL_REG);
+	else
+		writel(~EXYNOS_SYS_INT_EN, base + EXYNOS_JPEG_CNTL_REG);
+}
+
+void jpeg_set_stream_buf_address(void __iomem *base, unsigned int address)
+{
+	writel(address, base + EXYNOS_OUT_MEM_BASE_REG);
+}
+
+void jpeg_set_stream_size(void __iomem *base,
+		unsigned int x_value, unsigned int y_value)
+{
+	writel(0x0, base + EXYNOS_JPEG_IMG_SIZE_REG); /* clear */
+	writel(EXYNOS_X_SIZE(x_value) | EXYNOS_Y_SIZE(y_value),
+			base + EXYNOS_JPEG_IMG_SIZE_REG);
+}
+
+void jpeg_set_frame_buf_address(void __iomem *base,
+				struct s5p_jpeg_addr *jpeg_addr)
+{
+	writel(jpeg_addr->y, base + EXYNOS_IMG_BA_PLANE_1_REG);
+	writel(jpeg_addr->cb, base + EXYNOS_IMG_BA_PLANE_2_REG);
+	writel(jpeg_addr->cr, base + EXYNOS_IMG_BA_PLANE_3_REG);
+}
+
+void jpeg_set_encode_tbl_select(void __iomem *base,
+		enum exynos_jpeg_img_quality_level level)
+{
+	unsigned int	reg;
+
+	reg = EXYNOS_Q_TBL_COMP1_0 | EXYNOS_Q_TBL_COMP2_1 |
+		EXYNOS_Q_TBL_COMP3_1 |
+		EXYNOS_HUFF_TBL_COMP1_AC_0_DC_1 |
+		EXYNOS_HUFF_TBL_COMP2_AC_0_DC_0 |
+		EXYNOS_HUFF_TBL_COMP3_AC_1_DC_1;
+
+	writel(reg, base + EXYNOS_TBL_SEL_REG);
+}
+
+void jpeg_set_encode_hoff_cnt(void __iomem *base, unsigned int fmt)
+{
+	if (fmt == V4L2_PIX_FMT_GREY)
+		writel(0xd2, base + EXYNOS_HUFF_CNT_REG);
+	else
+		writel(0x1a2, base + EXYNOS_HUFF_CNT_REG);
+}
+
+unsigned int jpeg_get_stream_size(void __iomem *base)
+{
+	unsigned int size;
+
+	size = readl(base + EXYNOS_BITSTREAM_SIZE_REG);
+	return size;
+}
+
+void jpeg_set_dec_bitstream_size(void __iomem *base, unsigned int size)
+{
+	writel(size, base + EXYNOS_BITSTREAM_SIZE_REG);
+}
+
+void jpeg_get_frame_size(void __iomem *base,
+			unsigned int *width, unsigned int *height)
+{
+	*width = (readl(base + EXYNOS_DECODE_XY_SIZE_REG) &
+				EXYNOS_DECODED_SIZE_MASK);
+	*height = (readl(base + EXYNOS_DECODE_XY_SIZE_REG) >> 16) &
+				EXYNOS_DECODED_SIZE_MASK;
+}
+
+unsigned int jpeg_get_frame_fmt(void __iomem *base)
+{
+	return readl(base + EXYNOS_DECODE_IMG_FMT_REG) &
+				EXYNOS_JPEG_DECODED_IMG_FMT_MASK;
+}
+
+void jpeg_set_timer_count(void __iomem *base, unsigned int size)
+{
+	writel(size, base + EXYNOS_INT_TIMER_COUNT_REG);
+}
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos.h b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos.h
new file mode 100644
index 0000000..1ceb593
--- /dev/null
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos.h
@@ -0,0 +1,44 @@
+/* Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * Header file of the register interface for JPEG driver on Exynos4x12.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef JPEG_HW_EXYNOS_H_
+#define JPEG_HW_EXYNOS_H_
+
+void jpeg_sw_reset(void __iomem *base);
+void jpeg_set_enc_dec_mode(void __iomem *base, unsigned int mode);
+void jpeg_set_img_fmt(void __iomem *base, unsigned int img_fmt);
+void jpeg_set_enc_out_fmt(void __iomem *base, unsigned int out_fmt);
+void jpeg_set_enc_tbl(void __iomem *base);
+void jpeg_set_interrupt(void __iomem *base);
+unsigned int jpeg_get_int_status(void __iomem *base);
+void jpeg_set_huf_table_enable(void __iomem *base, int value);
+void jpeg_set_dec_scaling(void __iomem *base,
+		enum exynos_jpeg_scale_value x_value,
+		enum exynos_jpeg_scale_value y_value);
+void jpeg_set_sys_int_enable(void __iomem *base, int value);
+void jpeg_set_stream_buf_address(void __iomem *base, unsigned int address);
+void jpeg_set_stream_size(void __iomem *base,
+		unsigned int x_value, unsigned int y_value);
+void jpeg_set_frame_buf_address(void __iomem *base,
+				struct s5p_jpeg_addr *jpeg_addr);
+void jpeg_set_encode_tbl_select(void __iomem *base,
+		enum exynos_jpeg_img_quality_level level);
+void jpeg_set_encode_hoff_cnt(void __iomem *base, unsigned int fmt);
+void jpeg_set_dec_bitstream_size(void __iomem *base, unsigned int size);
+unsigned int jpeg_get_stream_size(void __iomem *base);
+void jpeg_get_frame_size(void __iomem *base,
+			unsigned int *width, unsigned int *height);
+unsigned int jpeg_get_frame_fmt(void __iomem *base);
+unsigned int jpeg_get_fifo_status(void __iomem *base);
+void jpeg_set_timer_count(void __iomem *base, unsigned int size);
+
+#endif /* JPEG_HW_EXYNOS_H_ */
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-regs.h b/drivers/media/platform/s5p-jpeg/jpeg-regs.h
index 38e5081..0bda8b0 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-regs.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-regs.h
@@ -2,10 +2,11 @@
  *
  * Register definition file for Samsung JPEG codec driver
  *
- * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Copyright (c) 2011-2013 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
  * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -15,6 +16,8 @@
 #ifndef JPEG_REGS_H_
 #define JPEG_REGS_H_
 
+/* Register and bit definitions for S5PC210 */
+
 /* JPEG mode register */
 #define S5P_JPGMOD			0x00
 #define S5P_PROC_MODE_MASK		(0x1 << 3)
@@ -166,5 +169,215 @@
 /* JPEG AC Huffman table register */
 #define S5P_JPG_HACTBLG(n)		(0x8c0 + (n) * 0x400)
 
+
+/* Register and bit definitions for Exynos 4x12 */
+
+/* JPEG Codec Control Registers */
+#define EXYNOS_JPEG_CNTL_REG		0x00
+#define EXYNOS_INT_EN_REG		0x04
+#define EXYNOS_INT_TIMER_COUNT_REG	0x08
+#define EXYNOS_INT_STATUS_REG		0x0c
+#define EXYNOS_OUT_MEM_BASE_REG		0x10
+#define EXYNOS_JPEG_IMG_SIZE_REG	0x14
+#define EXYNOS_IMG_BA_PLANE_1_REG	0x18
+#define EXYNOS_IMG_SO_PLANE_1_REG	0x1c
+#define EXYNOS_IMG_PO_PLANE_1_REG	0x20
+#define EXYNOS_IMG_BA_PLANE_2_REG	0x24
+#define EXYNOS_IMG_SO_PLANE_2_REG	0x28
+#define EXYNOS_IMG_PO_PLANE_2_REG	0x2c
+#define EXYNOS_IMG_BA_PLANE_3_REG	0x30
+#define EXYNOS_IMG_SO_PLANE_3_REG	0x34
+#define EXYNOS_IMG_PO_PLANE_3_REG	0x38
+
+#define EXYNOS_TBL_SEL_REG		0x3c
+
+#define EXYNOS_IMG_FMT_REG		0x40
+
+#define EXYNOS_BITSTREAM_SIZE_REG	0x44
+#define EXYNOS_PADDING_REG		0x48
+#define EXYNOS_HUFF_CNT_REG		0x4c
+#define EXYNOS_FIFO_STATUS_REG	0x50
+#define EXYNOS_DECODE_XY_SIZE_REG	0x54
+#define EXYNOS_DECODE_IMG_FMT_REG	0x58
+
+#define EXYNOS_QUAN_TBL_ENTRY_REG	0x100
+#define EXYNOS_HUFF_TBL_ENTRY_REG	0x200
+
+
+/****************************************************************/
+/* Bit definition part						*/
+/****************************************************************/
+
+/* JPEG CNTL Register bit */
+#define EXYNOS_ENC_DEC_MODE_MASK	(0xfffffffc << 0)
+#define EXYNOS_DEC_MODE			(1 << 0)
+#define EXYNOS_ENC_MODE			(1 << 1)
+#define EXYNOS_AUTO_RST_MARKER		(1 << 2)
+#define EXYNOS_RST_INTERVAL_SHIFT	3
+#define EXYNOS_RST_INTERVAL(x)		(((x) & 0xffff) \
+						<< EXYNOS_RST_INTERVAL_SHIFT)
+#define EXYNOS_HUF_TBL_EN		(1 << 19)
+#define EXYNOS_HOR_SCALING_SHIFT	20
+#define EXYNOS_HOR_SCALING_MASK		(3 << EXYNOS_HOR_SCALING_SHIFT)
+#define EXYNOS_HOR_SCALING(x)		(((x) & 0x3) \
+						<< EXYNOS_HOR_SCALING_SHIFT)
+#define EXYNOS_VER_SCALING_SHIFT	22
+#define EXYNOS_VER_SCALING_MASK		(3 << EXYNOS_VER_SCALING_SHIFT)
+#define EXYNOS_VER_SCALING(x)		(((x) & 0x3) \
+						<< EXYNOS_VER_SCALING_SHIFT)
+#define EXYNOS_PADDING			(1 << 27)
+#define EXYNOS_SYS_INT_EN		(1 << 28)
+#define EXYNOS_SOFT_RESET_HI		(1 << 29)
+
+/* JPEG INT Register bit */
+#define EXYNOS_INT_EN_MASK		(0x1f << 0)
+#define EXYNOS_PROT_ERR_INT_EN		(1 << 0)
+#define EXYNOS_IMG_COMPLETION_INT_EN	(1 << 1)
+#define EXYNOS_DEC_INVALID_FORMAT_EN	(1 << 2)
+#define EXYNOS_MULTI_SCAN_ERROR_EN	(1 << 3)
+#define EXYNOS_FRAME_ERR_EN		(1 << 4)
+#define EXYNOS_INT_EN_ALL		(0x1f << 0)
+
+#define EXYNOS_MOD_REG_PROC_ENC		(0 << 3)
+#define EXYNOS_MOD_REG_PROC_DEC		(1 << 3)
+
+#define EXYNOS_MOD_REG_SUBSAMPLE_444	(0 << 0)
+#define EXYNOS_MOD_REG_SUBSAMPLE_422	(1 << 0)
+#define EXYNOS_MOD_REG_SUBSAMPLE_420	(2 << 0)
+#define EXYNOS_MOD_REG_SUBSAMPLE_GRAY	(3 << 0)
+
+
+/* JPEG IMAGE SIZE Register bit */
+#define EXYNOS_X_SIZE_SHIFT		0
+#define EXYNOS_X_SIZE_MASK		(0xffff << EXYNOS_X_SIZE_SHIFT)
+#define EXYNOS_X_SIZE(x)		(((x) & 0xffff) << EXYNOS_X_SIZE_SHIFT)
+#define EXYNOS_Y_SIZE_SHIFT		16
+#define EXYNOS_Y_SIZE_MASK		(0xffff << EXYNOS_Y_SIZE_SHIFT)
+#define EXYNOS_Y_SIZE(x)		(((x) & 0xffff) << EXYNOS_Y_SIZE_SHIFT)
+
+/* JPEG IMAGE FORMAT Register bit */
+#define EXYNOS_ENC_IN_FMT_MASK		0xffff0000
+#define EXYNOS_ENC_GRAY_IMG		(0 << 0)
+#define EXYNOS_ENC_RGB_IMG		(1 << 0)
+#define EXYNOS_ENC_YUV_444_IMG		(2 << 0)
+#define EXYNOS_ENC_YUV_422_IMG		(3 << 0)
+#define EXYNOS_ENC_YUV_440_IMG		(4 << 0)
+
+#define EXYNOS_DEC_GRAY_IMG		(0 << 0)
+#define EXYNOS_DEC_RGB_IMG		(1 << 0)
+#define EXYNOS_DEC_YUV_444_IMG		(2 << 0)
+#define EXYNOS_DEC_YUV_422_IMG		(3 << 0)
+#define EXYNOS_DEC_YUV_420_IMG		(4 << 0)
+
+#define EXYNOS_GRAY_IMG_IP_SHIFT	3
+#define EXYNOS_GRAY_IMG_IP_MASK		(7 << EXYNOS_GRAY_IMG_IP_SHIFT)
+#define EXYNOS_GRAY_IMG_IP		(4 << EXYNOS_GRAY_IMG_IP_SHIFT)
+
+#define EXYNOS_RGB_IP_SHIFT		6
+#define EXYNOS_RGB_IP_MASK		(7 << EXYNOS_RGB_IP_SHIFT)
+#define EXYNOS_RGB_IP_RGB_16BIT_IMG	(4 << EXYNOS_RGB_IP_SHIFT)
+#define EXYNOS_RGB_IP_RGB_32BIT_IMG	(5 << EXYNOS_RGB_IP_SHIFT)
+
+#define EXYNOS_YUV_444_IP_SHIFT			9
+#define EXYNOS_YUV_444_IP_MASK			(7 << EXYNOS_YUV_444_IP_SHIFT)
+#define EXYNOS_YUV_444_IP_YUV_444_2P_IMG	(4 << EXYNOS_YUV_444_IP_SHIFT)
+#define EXYNOS_YUV_444_IP_YUV_444_3P_IMG	(5 << EXYNOS_YUV_444_IP_SHIFT)
+
+#define EXYNOS_YUV_422_IP_SHIFT			12
+#define EXYNOS_YUV_422_IP_MASK			(7 << EXYNOS_YUV_422_IP_SHIFT)
+#define EXYNOS_YUV_422_IP_YUV_422_1P_IMG	(4 << EXYNOS_YUV_422_IP_SHIFT)
+#define EXYNOS_YUV_422_IP_YUV_422_2P_IMG	(5 << EXYNOS_YUV_422_IP_SHIFT)
+#define EXYNOS_YUV_422_IP_YUV_422_3P_IMG	(6 << EXYNOS_YUV_422_IP_SHIFT)
+
+#define EXYNOS_YUV_420_IP_SHIFT			15
+#define EXYNOS_YUV_420_IP_MASK			(7 << EXYNOS_YUV_420_IP_SHIFT)
+#define EXYNOS_YUV_420_IP_YUV_420_2P_IMG	(4 << EXYNOS_YUV_420_IP_SHIFT)
+#define EXYNOS_YUV_420_IP_YUV_420_3P_IMG	(5 << EXYNOS_YUV_420_IP_SHIFT)
+
+#define EXYNOS_ENC_FMT_SHIFT			24
+#define EXYNOS_ENC_FMT_MASK			(3 << EXYNOS_ENC_FMT_SHIFT)
+#define EXYNOS_ENC_FMT_GRAY			(0 << EXYNOS_ENC_FMT_SHIFT)
+#define EXYNOS_ENC_FMT_YUV_444			(1 << EXYNOS_ENC_FMT_SHIFT)
+#define EXYNOS_ENC_FMT_YUV_422			(2 << EXYNOS_ENC_FMT_SHIFT)
+#define EXYNOS_ENC_FMT_YUV_420			(3 << EXYNOS_ENC_FMT_SHIFT)
+
+#define EXYNOS_JPEG_DECODED_IMG_FMT_MASK	0x03
+
+#define EXYNOS_SWAP_CHROMA_CRCB			(1 << 26)
+#define EXYNOS_SWAP_CHROMA_CBCR			(0 << 26)
+
+/* JPEG HUFF count Register bit */
+#define EXYNOS_HUFF_COUNT_MASK			0xffff
+
+/* JPEG Decoded_img_x_y_size Register bit */
+#define EXYNOS_DECODED_SIZE_MASK		0x0000ffff
+
+/* JPEG Decoded image format Register bit */
+#define EXYNOS_DECODED_IMG_FMT_MASK		0x3
+
+/* JPEG TBL SEL Register bit */
+#define EXYNOS_Q_TBL_COMP1_SHIFT	0
+#define EXYNOS_Q_TBL_COMP1_0		(0 << EXYNOS_Q_TBL_COMP1_SHIFT)
+#define EXYNOS_Q_TBL_COMP1_1		(1 << EXYNOS_Q_TBL_COMP1_SHIFT)
+#define EXYNOS_Q_TBL_COMP1_2		(2 << EXYNOS_Q_TBL_COMP1_SHIFT)
+#define EXYNOS_Q_TBL_COMP1_3		(3 << EXYNOS_Q_TBL_COMP1_SHIFT)
+
+#define EXYNOS_Q_TBL_COMP2_SHIFT	2
+#define EXYNOS_Q_TBL_COMP2_0		(0 << EXYNOS_Q_TBL_COMP2_SHIFT)
+#define EXYNOS_Q_TBL_COMP2_1		(1 << EXYNOS_Q_TBL_COMP2_SHIFT)
+#define EXYNOS_Q_TBL_COMP2_2		(2 << EXYNOS_Q_TBL_COMP2_SHIFT)
+#define EXYNOS_Q_TBL_COMP2_3		(3 << EXYNOS_Q_TBL_COMP2_SHIFT)
+
+#define EXYNOS_Q_TBL_COMP3_SHIFT	4
+#define EXYNOS_Q_TBL_COMP3_0		(0 << EXYNOS_Q_TBL_COMP3_SHIFT)
+#define EXYNOS_Q_TBL_COMP3_1		(1 << EXYNOS_Q_TBL_COMP2_SHIFT)
+#define EXYNOS_Q_TBL_COMP3_2		(2 << EXYNOS_Q_TBL_COMP2_SHIFT)
+#define EXYNOS_Q_TBL_COMP3_3		(3 << EXYNOS_Q_TBL_COMP2_SHIFT)
+
+#define EXYNOS_HUFF_TBL_COMP1_SHIFT	6
+#define EXYNOS_HUFF_TBL_COMP1_AC_0_DC_0	(0 << EXYNOS_HUFF_TBL_COMP1_SHIFT)
+#define EXYNOS_HUFF_TBL_COMP1_AC_0_DC_1	(1 << EXYNOS_HUFF_TBL_COMP1_SHIFT)
+#define EXYNOS_HUFF_TBL_COMP1_AC_1_DC_0	(2 << EXYNOS_HUFF_TBL_COMP1_SHIFT)
+#define EXYNOS_HUFF_TBL_COMP1_AC_1_DC_1	(3 << EXYNOS_HUFF_TBL_COMP1_SHIFT)
+
+#define EXYNOS_HUFF_TBL_COMP2_SHIFT	8
+#define EXYNOS_HUFF_TBL_COMP2_AC_0_DC_0	(0 << EXYNOS_HUFF_TBL_COMP2_SHIFT)
+#define EXYNOS_HUFF_TBL_COMP2_AC_0_DC_1	(1 << EXYNOS_HUFF_TBL_COMP2_SHIFT)
+#define EXYNOS_HUFF_TBL_COMP2_AC_1_DC_0	(2 << EXYNOS_HUFF_TBL_COMP2_SHIFT)
+#define EXYNOS_HUFF_TBL_COMP2_AC_1_DC_1	(3 << EXYNOS_HUFF_TBL_COMP2_SHIFT)
+
+#define EXYNOS_HUFF_TBL_COMP3_SHIFT	10
+#define EXYNOS_HUFF_TBL_COMP3_AC_0_DC_0	(0 << EXYNOS_HUFF_TBL_COMP3_SHIFT)
+#define EXYNOS_HUFF_TBL_COMP3_AC_0_DC_1	(1 << EXYNOS_HUFF_TBL_COMP3_SHIFT)
+#define EXYNOS_HUFF_TBL_COMP3_AC_1_DC_0	(2 << EXYNOS_HUFF_TBL_COMP3_SHIFT)
+#define EXYNOS_HUFF_TBL_COMP3_AC_1_DC_1	(3 << EXYNOS_HUFF_TBL_COMP3_SHIFT)
+
+/* JPEG quantizer table register */
+#define EXYNOS_QTBL_CONTENT(n)	(0x100 + (n) * 0x40)
+
+/* JPEG DC luminance (code length) Huffman table register */
+#define EXYNOS_HUFF_TBL_HDCLL	0x200
+
+/* JPEG DC luminance (values) Huffman table register */
+#define EXYNOS_HUFF_TBL_HDCLV	0x210
+
+/* JPEG DC chrominance (code length) Huffman table register */
+#define EXYNOS_HUFF_TBL_HDCCL	0x220
+
+/* JPEG DC chrominance (values) Huffman table register */
+#define EXYNOS_HUFF_TBL_HDCCV	0x230
+
+/* JPEG AC luminance (code length) Huffman table register */
+#define EXYNOS_HUFF_TBL_HACLL	0x240
+
+/* JPEG AC luminance (values) Huffman table register */
+#define EXYNOS_HUFF_TBL_HACLV	0x250
+
+/* JPEG AC chrominance (code length) Huffman table register */
+#define EXYNOS_HUFF_TBL_HACCL	0x300
+
+/* JPEG AC chrominance (values) Huffman table register */
+#define EXYNOS_HUFF_TBL_HACCV	0x310
+
 #endif /* JPEG_REGS_H_ */
 
-- 
1.7.9.5

