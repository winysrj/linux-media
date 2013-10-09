Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:52357 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab3JIXuh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Oct 2013 19:50:37 -0400
Received: by mail-yh0-f73.google.com with SMTP id z12so112881yhz.0
        for <linux-media@vger.kernel.org>; Wed, 09 Oct 2013 16:50:36 -0700 (PDT)
From: John Sheu <sheu@google.com>
To: linux-media@vger.kernel.org
Cc: John Sheu <sheu@google.com>, m.chehab@samsung.com,
	k.debski@samsung.com, pawel@osciak.com
Subject: [PATCH 5/6] [media] gsc-m2m: report correct format bytesperline and sizeimage
Date: Wed,  9 Oct 2013 16:49:48 -0700
Message-Id: <1381362589-32237-6-git-send-email-sheu@google.com>
In-Reply-To: <1381362589-32237-1-git-send-email-sheu@google.com>
References: <1381362589-32237-1-git-send-email-sheu@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Explicitly specify sampling period for subsampled chroma formats, so
stride and image size are properly reported through VIDIOC_{S,G}_FMT.

Signed-off-by: John Sheu <sheu@google.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 154 +++++++++++++++------------
 drivers/media/platform/exynos-gsc/gsc-core.h |  16 +--
 drivers/media/platform/exynos-gsc/gsc-regs.c |  40 +++----
 drivers/media/platform/exynos-gsc/gsc-regs.h |   4 +-
 4 files changed, 116 insertions(+), 98 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 9d0cc04..c02adde 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -34,167 +34,185 @@ static const struct gsc_fmt gsc_formats[] = {
 	{
 		.name		= "RGB565",
 		.pixelformat	= V4L2_PIX_FMT_RGB565X,
-		.depth		= { 16 },
 		.color		= GSC_RGB,
 		.num_planes	= 1,
 		.num_comp	= 1,
+		.depth		= { 16 },
+		.sampling	= { { 1, 1 } },
 	}, {
 		.name		= "XRGB-8-8-8-8, 32 bpp",
 		.pixelformat	= V4L2_PIX_FMT_RGB32,
-		.depth		= { 32 },
 		.color		= GSC_RGB,
 		.num_planes	= 1,
 		.num_comp	= 1,
+		.depth		= { 32 },
+		.sampling	= { { 1, 1 } },
 	}, {
 		.name		= "YUV 4:2:2 packed, YCbYCr",
 		.pixelformat	= V4L2_PIX_FMT_YUYV,
-		.depth		= { 16 },
 		.color		= GSC_YUV422,
 		.yorder		= GSC_LSB_Y,
 		.corder		= GSC_CBCR,
 		.num_planes	= 1,
 		.num_comp	= 1,
+		.depth		= { 16 },
+		.sampling	= { { 1, 1 } },
 		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
 	}, {
 		.name		= "YUV 4:2:2 packed, CbYCrY",
 		.pixelformat	= V4L2_PIX_FMT_UYVY,
-		.depth		= { 16 },
 		.color		= GSC_YUV422,
 		.yorder		= GSC_LSB_C,
 		.corder		= GSC_CBCR,
 		.num_planes	= 1,
 		.num_comp	= 1,
+		.depth		= { 16 },
+		.sampling	= { { 1, 1 } },
 		.mbus_code	= V4L2_MBUS_FMT_UYVY8_2X8,
 	}, {
 		.name		= "YUV 4:2:2 packed, CrYCbY",
 		.pixelformat	= V4L2_PIX_FMT_VYUY,
-		.depth		= { 16 },
 		.color		= GSC_YUV422,
 		.yorder		= GSC_LSB_C,
 		.corder		= GSC_CRCB,
 		.num_planes	= 1,
 		.num_comp	= 1,
+		.depth		= { 16 },
+		.sampling	= { { 1, 1 } },
 		.mbus_code	= V4L2_MBUS_FMT_VYUY8_2X8,
 	}, {
 		.name		= "YUV 4:2:2 packed, YCrYCb",
 		.pixelformat	= V4L2_PIX_FMT_YVYU,
-		.depth		= { 16 },
 		.color		= GSC_YUV422,
 		.yorder		= GSC_LSB_Y,
 		.corder		= GSC_CRCB,
 		.num_planes	= 1,
 		.num_comp	= 1,
+		.depth		= { 16 },
+		.sampling	= { { 1, 1 } },
 		.mbus_code	= V4L2_MBUS_FMT_YVYU8_2X8,
 	}, {
 		.name		= "YUV 4:4:4 planar, YCbYCr",
 		.pixelformat	= V4L2_PIX_FMT_YUV32,
-		.depth		= { 32 },
 		.color		= GSC_YUV444,
 		.yorder		= GSC_LSB_Y,
 		.corder		= GSC_CBCR,
 		.num_planes	= 1,
 		.num_comp	= 1,
+		.depth		= { 32 },
+		.sampling	= { { 1, 1 } },
 	}, {
 		.name		= "YUV 4:2:2 planar, Y/Cb/Cr",
 		.pixelformat	= V4L2_PIX_FMT_YUV422P,
-		.depth		= { 16 },
 		.color		= GSC_YUV422,
 		.yorder		= GSC_LSB_Y,
 		.corder		= GSC_CBCR,
 		.num_planes	= 1,
 		.num_comp	= 3,
+		.depth		= { 8, 8, 8 },
+		.sampling	= { { 1, 1 }, { 2, 1 }, { 2, 1 } },
 	}, {
 		.name		= "YUV 4:2:2 planar, Y/CbCr",
 		.pixelformat	= V4L2_PIX_FMT_NV16,
-		.depth		= { 16 },
 		.color		= GSC_YUV422,
 		.yorder		= GSC_LSB_Y,
 		.corder		= GSC_CBCR,
 		.num_planes	= 1,
 		.num_comp	= 2,
+		.depth		= { 8, 16 },
+		.sampling	= { { 1, 1 }, { 2, 1 } },
 	}, {
 		.name		= "YUV 4:2:2 planar, Y/CrCb",
 		.pixelformat	= V4L2_PIX_FMT_NV61,
-		.depth		= { 16 },
 		.color		= GSC_YUV422,
 		.yorder		= GSC_LSB_Y,
 		.corder		= GSC_CRCB,
 		.num_planes	= 1,
 		.num_comp	= 2,
+		.depth		= { 8, 16 },
+		.sampling	= { { 1, 1 }, { 2, 1 } },
 	}, {
 		.name		= "YUV 4:2:0 planar, YCbCr",
 		.pixelformat	= V4L2_PIX_FMT_YUV420,
-		.depth		= { 12 },
 		.color		= GSC_YUV420,
 		.yorder		= GSC_LSB_Y,
 		.corder		= GSC_CBCR,
 		.num_planes	= 1,
 		.num_comp	= 3,
+		.depth		= { 8, 8, 8 },
+		.sampling	= { { 1, 1 }, { 2, 2 }, { 2, 2 } },
 	}, {
 		.name		= "YUV 4:2:0 planar, YCrCb",
 		.pixelformat	= V4L2_PIX_FMT_YVU420,
-		.depth		= { 12 },
 		.color		= GSC_YUV420,
 		.yorder		= GSC_LSB_Y,
 		.corder		= GSC_CRCB,
 		.num_planes	= 1,
 		.num_comp	= 3,
-
+		.depth		= { 8, 8, 8 },
+		.sampling	= { { 1, 1 }, { 2, 2 }, { 2, 2 } },
 	}, {
 		.name		= "YUV 4:2:0 planar, Y/CbCr",
 		.pixelformat	= V4L2_PIX_FMT_NV12,
-		.depth		= { 12 },
 		.color		= GSC_YUV420,
 		.yorder		= GSC_LSB_Y,
 		.corder		= GSC_CBCR,
 		.num_planes	= 1,
 		.num_comp	= 2,
+		.depth		= { 8, 16 },
+		.sampling	= { { 1, 1 }, { 2, 2 } },
 	}, {
 		.name		= "YUV 4:2:0 planar, Y/CrCb",
 		.pixelformat	= V4L2_PIX_FMT_NV21,
-		.depth		= { 12 },
 		.color		= GSC_YUV420,
 		.yorder		= GSC_LSB_Y,
 		.corder		= GSC_CRCB,
 		.num_planes	= 1,
 		.num_comp	= 2,
+		.depth		= { 8, 16 },
+		.sampling	= { { 1, 1 }, { 2, 2 } },
 	}, {
-		.name		= "YUV 4:2:0 non-contig. 2p, Y/CbCr",
+		.name		= "YUV 4:2:0 non-contiguous 2-planar, Y/CbCr",
 		.pixelformat	= V4L2_PIX_FMT_NV12M,
-		.depth		= { 8, 4 },
 		.color		= GSC_YUV420,
 		.yorder		= GSC_LSB_Y,
 		.corder		= GSC_CBCR,
 		.num_planes	= 2,
 		.num_comp	= 2,
+		.depth		= { 8, 16 },
+		.sampling	= { { 1, 1 }, { 2, 2 } },
 	}, {
-		.name		= "YUV 4:2:0 non-contig. 3p, Y/Cb/Cr",
+		.name		= "YUV 4:2:0 non-contiguous 3-planar, Y/Cb/Cr",
 		.pixelformat	= V4L2_PIX_FMT_YUV420M,
-		.depth		= { 8, 2, 2 },
 		.color		= GSC_YUV420,
 		.yorder		= GSC_LSB_Y,
 		.corder		= GSC_CBCR,
 		.num_planes	= 3,
 		.num_comp	= 3,
+		.depth		= { 8, 8, 8 },
+		.sampling	= { { 1, 1 }, { 2, 2 }, { 2, 2 } },
 	}, {
-		.name		= "YUV 4:2:0 non-contig. 3p, Y/Cr/Cb",
+		.name		= "YUV 4:2:0 non-contiguous 3-planar, Y/Cr/Cb",
 		.pixelformat	= V4L2_PIX_FMT_YVU420M,
-		.depth		= { 8, 2, 2 },
 		.color		= GSC_YUV420,
 		.yorder		= GSC_LSB_Y,
 		.corder		= GSC_CRCB,
 		.num_planes	= 3,
 		.num_comp	= 3,
+		.depth		= { 8, 8, 8 },
+		.sampling	= { { 1, 1 }, { 2, 2 }, { 2, 2 } },
 	}, {
-		.name		= "YUV 4:2:0 n.c. 2p, Y/CbCr tiled",
+		.name		=
+			"YUV 4:2:0 non-contiguous 2-planar, Y/CbCr, tiled",
 		.pixelformat	= V4L2_PIX_FMT_NV12MT_16X16,
-		.depth		= { 8, 4 },
 		.color		= GSC_YUV420,
 		.yorder		= GSC_LSB_Y,
 		.corder		= GSC_CBCR,
 		.num_planes	= 2,
 		.num_comp	= 2,
-	}
+		.depth		= { 8, 16 },
+		.sampling	= { { 1, 1 }, { 2, 2 } },
+	},
 };
 
 const struct gsc_fmt *get_format(int index)
@@ -384,6 +402,14 @@ void gsc_set_prefbuf(struct gsc_dev *gsc, struct gsc_frame *frm)
 			f_chk_addr, f_chk_len, s_chk_addr, s_chk_len);
 }
 
+static void get_format_size(__u32 width, __u32 height,
+			    const struct gsc_fmt *fmt, int plane,
+			    __u16 *bytesperline, __u32 *sizeimage) {
+	__u16 bpl = ((width * fmt->depth[plane]) / fmt->sampling[plane][0]) / 8;
+	*bytesperline = bpl;
+	*sizeimage = (height * bpl) / fmt->sampling[plane][0];
+}
+
 int gsc_try_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f)
 {
 	struct gsc_dev *gsc = ctx->gsc_dev;
@@ -448,14 +474,16 @@ int gsc_try_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f)
 	else /* SD */
 		pix_mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
 
-
+	/* V4L2 specifies for contiguous planar formats that bytesperline and
+	   sizeimage are set to values appropriate for the first plane. */
 	for (i = 0; i < pix_mp->num_planes; ++i) {
-		int bpl = (pix_mp->width * fmt->depth[i]) >> 3;
-		pix_mp->plane_fmt[i].bytesperline = bpl;
-		pix_mp->plane_fmt[i].sizeimage = bpl * pix_mp->height;
+		get_format_size(pix_mp->width, pix_mp->height, fmt, i,
+				&pix_mp->plane_fmt[i].bytesperline,
+				&pix_mp->plane_fmt[i].sizeimage);
 
 		pr_debug("[%d]: bpl: %d, sizeimage: %d",
-				i, bpl, pix_mp->plane_fmt[i].sizeimage);
+				i, pix_mp->plane_fmt[i].bytesperline,
+				pix_mp->plane_fmt[i].sizeimage);
 	}
 
 	return 0;
@@ -465,26 +493,27 @@ int gsc_g_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f)
 {
 	struct gsc_frame *frame;
 	struct v4l2_pix_format_mplane *pix_mp;
+	const struct gsc_fmt *fmt;
 	int i;
 
 	frame = ctx_get_frame(ctx, f->type);
 	if (IS_ERR(frame))
 		return PTR_ERR(frame);
+	fmt = frame->fmt;
 
 	pix_mp = &f->fmt.pix_mp;
 
 	pix_mp->width		= frame->f_width;
 	pix_mp->height		= frame->f_height;
 	pix_mp->field		= V4L2_FIELD_NONE;
-	pix_mp->pixelformat	= frame->fmt->pixelformat;
+	pix_mp->pixelformat	= fmt->pixelformat;
 	pix_mp->colorspace	= V4L2_COLORSPACE_REC709;
-	pix_mp->num_planes	= frame->fmt->num_planes;
+	pix_mp->num_planes	= fmt->num_planes;
 
 	for (i = 0; i < pix_mp->num_planes; ++i) {
-		pix_mp->plane_fmt[i].bytesperline = (frame->f_width *
-			frame->fmt->depth[i]) / 8;
-		pix_mp->plane_fmt[i].sizeimage =
-			 pix_mp->plane_fmt[i].bytesperline * frame->f_height;
+		get_format_size(pix_mp->width, pix_mp->height, fmt, i,
+				&pix_mp->plane_fmt[i].bytesperline,
+				&pix_mp->plane_fmt[i].sizeimage);
 	}
 
 	return 0;
@@ -794,11 +823,12 @@ void gsc_ctrls_delete(struct gsc_ctx *ctx)
 	}
 }
 
-/* The color format (num_comp, num_planes) must be already configured. */
+/* The color format (num_planes, num_comp) must be already configured. */
 int gsc_prepare_addr(struct gsc_ctx *ctx, struct vb2_buffer *vb,
 			struct gsc_frame *frame, struct gsc_addr *addr)
 {
 	int ret = 0;
+	const struct gsc_fmt *fmt = frame->fmt;
 	u32 pix_size;
 
 	if ((vb == NULL) || (frame == NULL))
@@ -810,46 +840,30 @@ int gsc_prepare_addr(struct gsc_ctx *ctx, struct vb2_buffer *vb,
 		frame->fmt->num_planes, frame->fmt->num_comp, pix_size);
 
 	addr->y = vb2_dma_contig_plane_dma_addr(vb, 0);
-
-	if (frame->fmt->num_planes == 1) {
-		switch (frame->fmt->num_comp) {
-		case 1:
-			addr->cb = 0;
-			addr->cr = 0;
-			break;
-		case 2:
-			/* decompose Y into Y/Cb */
-			addr->cb = (dma_addr_t)(addr->y + pix_size);
-			addr->cr = 0;
-			break;
-		case 3:
-			/* decompose Y into Y/Cb/Cr */
-			addr->cb = (dma_addr_t)(addr->y + pix_size);
-			if (GSC_YUV420 == frame->fmt->color)
-				addr->cr = (dma_addr_t)(addr->cb
-						+ (pix_size >> 2));
-			else /* 422 */
-				addr->cr = (dma_addr_t)(addr->cb
-						+ (pix_size >> 1));
-			break;
-		default:
-			pr_err("Invalid the number of color planes");
-			return -EINVAL;
+	addr->cb = 0;
+	addr->cr = 0;
+
+	if (fmt->num_planes == 1) {
+		if (fmt->num_comp >= 2) {
+			addr->cb = (dma_addr_t)(addr->y +
+				((pix_size * fmt->depth[0]) /
+				(fmt->sampling[0][0] *
+				 fmt->sampling[0][1]) / 8));
+		}
+		if (fmt->num_comp >= 3) {
+			addr->cr = (dma_addr_t)(addr->cb +
+				((pix_size * fmt->depth[1]) /
+				(fmt->sampling[1][0] *
+				 fmt->sampling[1][1]) / 8));
 		}
 	} else {
-		if (frame->fmt->num_planes >= 2)
+		if (fmt->num_comp >= 2)
 			addr->cb = vb2_dma_contig_plane_dma_addr(vb, 1);
-
-		if (frame->fmt->num_planes == 3)
+		if (fmt->num_comp == 3)
 			addr->cr = vb2_dma_contig_plane_dma_addr(vb, 2);
 	}
 
-	if ((frame->fmt->pixelformat == V4L2_PIX_FMT_VYUY) ||
-		(frame->fmt->pixelformat == V4L2_PIX_FMT_YVYU) ||
-		(frame->fmt->pixelformat == V4L2_PIX_FMT_NV61) ||
-		(frame->fmt->pixelformat == V4L2_PIX_FMT_YVU420) ||
-		(frame->fmt->pixelformat == V4L2_PIX_FMT_NV21) ||
-		(frame->fmt->pixelformat == V4L2_PIX_FMT_YVU420M))
+	if (fmt->corder == GSC_CRCB)
 		swap(addr->cb, addr->cr);
 
 	pr_debug("ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d",
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index 76435d3..c393678 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.h
+++ b/drivers/media/platform/exynos-gsc/gsc-core.h
@@ -105,27 +105,27 @@ enum gsc_yuv_fmt {
 	container_of((__ctrl)->handler, struct gsc_ctx, ctrl_handler)
 /**
  * struct gsc_fmt - the driver's internal color format data
- * @mbus_code: Media Bus pixel code, -1 if not applicable
  * @name: format description
  * @pixelformat: the fourcc code for this format, 0 if not applicable
  * @yorder: Y/C order
  * @corder: Chrominance order control
  * @num_planes: number of physically non-contiguous data planes
- * @nr_comp: number of physically contiguous data planes
- * @depth: per plane driver's private 'number of bits per pixel'
- * @flags: flags indicating which operation mode format applies to
+ * @num_comp: number of physically contiguous data planes
+ * @depth: bit depth of each component
+ * @sampling: sampling frequency of each components, X and Y
+ * @mbus_code: Media Bus pixel code, -1 if not applicable
  */
 struct gsc_fmt {
-	enum v4l2_mbus_pixelcode mbus_code;
 	char	*name;
 	u32	pixelformat;
 	u32	color;
 	u32	yorder;
 	u32	corder;
-	u16	num_planes;
-	u16	num_comp;
+	u8	num_planes;
+	u8	num_comp;
 	u8	depth[VIDEO_MAX_PLANES];
-	u32	flags;
+	u8	sampling[VIDEO_MAX_PLANES][2];
+	enum v4l2_mbus_pixelcode mbus_code;
 };
 
 /**
diff --git a/drivers/media/platform/exynos-gsc/gsc-regs.c b/drivers/media/platform/exynos-gsc/gsc-regs.c
index e22d147..a8d6c90 100644
--- a/drivers/media/platform/exynos-gsc/gsc-regs.c
+++ b/drivers/media/platform/exynos-gsc/gsc-regs.c
@@ -167,6 +167,7 @@ void gsc_hw_set_in_image_format(struct gsc_ctx *ctx)
 {
 	struct gsc_dev *dev = ctx->gsc_dev;
 	struct gsc_frame *frame = &ctx->s_frame;
+	const struct gsc_fmt *fmt = frame->fmt;
 	u32 i, depth = 0;
 	u32 cfg;
 
@@ -176,21 +177,22 @@ void gsc_hw_set_in_image_format(struct gsc_ctx *ctx)
 		 GSC_IN_TILE_TYPE_MASK | GSC_IN_TILE_MODE);
 	writel(cfg, dev->regs + GSC_IN_CON);
 
-	if (is_rgb(frame->fmt->color)) {
+	if (is_rgb(fmt->color)) {
 		gsc_hw_set_in_image_rgb(ctx);
 		return;
 	}
-	for (i = 0; i < frame->fmt->num_planes; i++)
-		depth += frame->fmt->depth[i];
+	for (i = 0; i < fmt->num_comp; i++)
+		depth += fmt->depth[i] /
+			(fmt->sampling[i][0] * fmt->sampling[i][1]);
 
-	switch (frame->fmt->num_comp) {
+	switch (fmt->num_comp) {
 	case 1:
 		cfg |= GSC_IN_YUV422_1P;
-		if (frame->fmt->yorder == GSC_LSB_Y)
+		if (fmt->yorder == GSC_LSB_Y)
 			cfg |= GSC_IN_YUV422_1P_ORDER_LSB_Y;
 		else
-			cfg |= GSC_IN_YUV422_1P_OEDER_LSB_C;
-		if (frame->fmt->corder == GSC_CBCR)
+			cfg |= GSC_IN_YUV422_1P_ORDER_LSB_C;
+		if (fmt->corder == GSC_CBCR)
 			cfg |= GSC_IN_CHROMA_ORDER_CBCR;
 		else
 			cfg |= GSC_IN_CHROMA_ORDER_CRCB;
@@ -200,7 +202,7 @@ void gsc_hw_set_in_image_format(struct gsc_ctx *ctx)
 			cfg |= GSC_IN_YUV420_2P;
 		else
 			cfg |= GSC_IN_YUV422_2P;
-		if (frame->fmt->corder == GSC_CBCR)
+		if (fmt->corder == GSC_CBCR)
 			cfg |= GSC_IN_CHROMA_ORDER_CBCR;
 		else
 			cfg |= GSC_IN_CHROMA_ORDER_CRCB;
@@ -213,7 +215,7 @@ void gsc_hw_set_in_image_format(struct gsc_ctx *ctx)
 		break;
 	}
 
-	if (is_tiled(frame->fmt))
+	if (is_tiled(fmt))
 		cfg |= GSC_IN_TILE_C_16x8 | GSC_IN_TILE_MODE;
 
 	writel(cfg, dev->regs + GSC_IN_CON);
@@ -287,6 +289,7 @@ void gsc_hw_set_out_image_format(struct gsc_ctx *ctx)
 {
 	struct gsc_dev *dev = ctx->gsc_dev;
 	struct gsc_frame *frame = &ctx->d_frame;
+	const struct gsc_fmt *fmt = frame->fmt;
 	u32 i, depth = 0;
 	u32 cfg;
 
@@ -296,7 +299,7 @@ void gsc_hw_set_out_image_format(struct gsc_ctx *ctx)
 		 GSC_OUT_TILE_TYPE_MASK | GSC_OUT_TILE_MODE);
 	writel(cfg, dev->regs + GSC_OUT_CON);
 
-	if (is_rgb(frame->fmt->color)) {
+	if (is_rgb(fmt->color)) {
 		gsc_hw_set_out_image_rgb(ctx);
 		return;
 	}
@@ -306,17 +309,18 @@ void gsc_hw_set_out_image_format(struct gsc_ctx *ctx)
 		goto end_set;
 	}
 
-	for (i = 0; i < frame->fmt->num_planes; i++)
-		depth += frame->fmt->depth[i];
+	for (i = 0; i < fmt->num_comp; i++)
+		depth += fmt->depth[i] /
+			(fmt->sampling[i][0] * fmt->sampling[i][1]);
 
-	switch (frame->fmt->num_comp) {
+	switch (fmt->num_comp) {
 	case 1:
 		cfg |= GSC_OUT_YUV422_1P;
-		if (frame->fmt->yorder == GSC_LSB_Y)
+		if (fmt->yorder == GSC_LSB_Y)
 			cfg |= GSC_OUT_YUV422_1P_ORDER_LSB_Y;
 		else
-			cfg |= GSC_OUT_YUV422_1P_OEDER_LSB_C;
-		if (frame->fmt->corder == GSC_CBCR)
+			cfg |= GSC_OUT_YUV422_1P_ORDER_LSB_C;
+		if (fmt->corder == GSC_CBCR)
 			cfg |= GSC_OUT_CHROMA_ORDER_CBCR;
 		else
 			cfg |= GSC_OUT_CHROMA_ORDER_CRCB;
@@ -326,7 +330,7 @@ void gsc_hw_set_out_image_format(struct gsc_ctx *ctx)
 			cfg |= GSC_OUT_YUV420_2P;
 		else
 			cfg |= GSC_OUT_YUV422_2P;
-		if (frame->fmt->corder == GSC_CBCR)
+		if (fmt->corder == GSC_CBCR)
 			cfg |= GSC_OUT_CHROMA_ORDER_CBCR;
 		else
 			cfg |= GSC_OUT_CHROMA_ORDER_CRCB;
@@ -336,7 +340,7 @@ void gsc_hw_set_out_image_format(struct gsc_ctx *ctx)
 		break;
 	}
 
-	if (is_tiled(frame->fmt))
+	if (is_tiled(fmt))
 		cfg |= GSC_OUT_TILE_C_16x8 | GSC_OUT_TILE_MODE;
 
 end_set:
diff --git a/drivers/media/platform/exynos-gsc/gsc-regs.h b/drivers/media/platform/exynos-gsc/gsc-regs.h
index 4678f9a..b03401d 100644
--- a/drivers/media/platform/exynos-gsc/gsc-regs.h
+++ b/drivers/media/platform/exynos-gsc/gsc-regs.h
@@ -46,7 +46,7 @@
 #define GSC_IN_RGB_SD_WIDE		(0 << 14)
 #define GSC_IN_YUV422_1P_ORDER_MASK	(1 << 13)
 #define GSC_IN_YUV422_1P_ORDER_LSB_Y	(0 << 13)
-#define GSC_IN_YUV422_1P_OEDER_LSB_C	(1 << 13)
+#define GSC_IN_YUV422_1P_ORDER_LSB_C	(1 << 13)
 #define GSC_IN_CHROMA_ORDER_MASK	(1 << 12)
 #define GSC_IN_CHROMA_ORDER_CBCR	(0 << 12)
 #define GSC_IN_CHROMA_ORDER_CRCB	(1 << 12)
@@ -91,7 +91,7 @@
 #define GSC_OUT_RGB_SD_NARROW		(0 << 10)
 #define GSC_OUT_YUV422_1P_ORDER_MASK	(1 << 9)
 #define GSC_OUT_YUV422_1P_ORDER_LSB_Y	(0 << 9)
-#define GSC_OUT_YUV422_1P_OEDER_LSB_C	(1 << 9)
+#define GSC_OUT_YUV422_1P_ORDER_LSB_C	(1 << 9)
 #define GSC_OUT_CHROMA_ORDER_MASK	(1 << 8)
 #define GSC_OUT_CHROMA_ORDER_CBCR	(0 << 8)
 #define GSC_OUT_CHROMA_ORDER_CRCB	(1 << 8)
-- 
1.8.4

