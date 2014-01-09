Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:39100 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaAID27 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 22:28:59 -0500
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: s.nawrocki@samsung.com, posciak@google.com, hverkuil@xs4all.nl,
	shaik.ameer@samsung.com, m.chehab@samsung.com
Subject: [PATCH v5 2/4] [media] exynos-scaler: Add core functionality for the SCALER driver
Date: Thu,  9 Jan 2014 08:58:12 +0530
Message-Id: <1389238094-19386-3-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1389238094-19386-1-git-send-email-shaik.ameer@samsung.com>
References: <1389238094-19386-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the core functionality for the SCALER driver.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos-scaler/scaler.c | 1231 +++++++++++++++++++++++++
 drivers/media/platform/exynos-scaler/scaler.h |  376 ++++++++
 2 files changed, 1607 insertions(+)
 create mode 100644 drivers/media/platform/exynos-scaler/scaler.c
 create mode 100644 drivers/media/platform/exynos-scaler/scaler.h

diff --git a/drivers/media/platform/exynos-scaler/scaler.c b/drivers/media/platform/exynos-scaler/scaler.c
new file mode 100644
index 0000000..db2cad1
--- /dev/null
+++ b/drivers/media/platform/exynos-scaler/scaler.c
@@ -0,0 +1,1231 @@
+/*
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Samsung EXYNOS5 SoC series SCALER driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/of_platform.h>
+#include <linux/pm_runtime.h>
+
+#include "scaler-regs.h"
+
+#define SCALER_CLOCK_GATE_NAME	"scaler"
+
+static const struct scaler_fmt scaler_formats[] = {
+	{
+		.name		= "YUV 4:2:0 non-contig. 2p, Y/CbCr",
+		.pixelformat	= V4L2_PIX_FMT_NV12M,
+		.depth		= { 8, 4 },
+		.color		= SCALER_YUV420,
+		.color_order	= SCALER_CBCR,
+		.num_planes	= 2,
+		.num_comp	= 2,
+		.scaler_color	= SCALER_YUV420_2P_Y_UV,
+		.flags		= SCALER_FMT_SRC | SCALER_FMT_DST,
+
+	}, {
+		.name		= "YUV 4:2:0 contig. 2p, Y/CbCr",
+		.pixelformat	= V4L2_PIX_FMT_NV12,
+		.depth		= { 12 },
+		.color		= SCALER_YUV420,
+		.color_order	= SCALER_CBCR,
+		.num_planes	= 1,
+		.num_comp	= 2,
+		.scaler_color	= SCALER_YUV420_2P_Y_UV,
+		.flags		= SCALER_FMT_SRC | SCALER_FMT_DST,
+	}, {
+		.name		= "YUV 4:2:0 n.c. 2p, Y/CbCr tiled",
+		.pixelformat	= V4L2_PIX_FMT_NV12MT_16X16,
+		.depth		= { 8, 4 },
+		.color		= SCALER_YUV420,
+		.color_order	= SCALER_CBCR,
+		.num_planes	= 2,
+		.num_comp	= 2,
+		.scaler_color	= SCALER_YUV420_2P_Y_UV,
+		.flags		= SCALER_FMT_SRC | SCALER_FMT_TILED,
+	}, {
+		.name		= "YUV 4:2:2 contig. 2p, Y/CbCr",
+		.pixelformat	= V4L2_PIX_FMT_NV16,
+		.depth		= { 16 },
+		.color		= SCALER_YUV422,
+		.color_order	= SCALER_CBCR,
+		.num_planes	= 1,
+		.num_comp	= 2,
+		.scaler_color	= SCALER_YUV422_2P_Y_UV,
+		.flags		= SCALER_FMT_SRC | SCALER_FMT_DST,
+	}, {
+		.name		= "YUV 4:4:4 contig. 2p, Y/CbCr",
+		.pixelformat	= V4L2_PIX_FMT_NV24,
+		.depth		= { 24 },
+		.color		= SCALER_YUV444,
+		.color_order	= SCALER_CBCR,
+		.num_planes	= 1,
+		.num_comp	= 2,
+		.scaler_color	= SCALER_YUV444_2P_Y_UV,
+		.flags		= SCALER_FMT_SRC | SCALER_FMT_DST,
+	}, {
+		.name		= "RGB565",
+		.pixelformat	= V4L2_PIX_FMT_RGB565X,
+		.depth		= { 16 },
+		.color		= SCALER_RGB,
+		.num_planes	= 1,
+		.num_comp	= 1,
+		.scaler_color	= SCALER_RGB565,
+		.flags		= SCALER_FMT_SRC | SCALER_FMT_DST,
+	}, {
+		.name		= "XRGB-1555, 16 bpp",
+		.pixelformat	= V4L2_PIX_FMT_RGB555,
+		.depth		= { 16 },
+		.color		= SCALER_RGB,
+		.num_planes	= 1,
+		.num_comp	= 1,
+		.scaler_color	= SCALER_ARGB1555,
+		.flags		= SCALER_FMT_SRC | SCALER_FMT_DST,
+	}, {
+		.name		= "XRGB-8888, 32 bpp",
+		.pixelformat	= V4L2_PIX_FMT_RGB32,
+		.depth		= { 32 },
+		.color		= SCALER_RGB,
+		.num_planes	= 1,
+		.num_comp	= 1,
+		.scaler_color	= SCALER_ARGB8888,
+		.flags		= SCALER_FMT_SRC | SCALER_FMT_DST,
+	}, {
+		.name		= "YUV 4:2:2 packed, YCrYCb",
+		.pixelformat	= V4L2_PIX_FMT_YVYU,
+		.depth		= { 16 },
+		.color		= SCALER_YUV422,
+		.color_order	= SCALER_CRCB,
+		.num_planes	= 1,
+		.num_comp	= 1,
+		.scaler_color	= SCALER_YUV422_1P_YVYU,
+		.flags		= SCALER_FMT_SRC | SCALER_FMT_DST,
+	}, {
+		.name		= "YUV 4:2:2 packed, YCbYCr",
+		.pixelformat	= V4L2_PIX_FMT_YUYV,
+		.depth		= { 16 },
+		.color		= SCALER_YUV422,
+		.color_order	= SCALER_CBCR,
+		.num_planes	= 1,
+		.num_comp	= 1,
+		.scaler_color	= SCALER_YUV422_1P_YUYV,
+		.flags		= SCALER_FMT_SRC | SCALER_FMT_DST,
+	}, {
+		.name		= "YUV 4:2:2 packed, CbYCrY",
+		.pixelformat	= V4L2_PIX_FMT_UYVY,
+		.depth		= { 16 },
+		.color		= SCALER_YUV422,
+		.color_order	= SCALER_CBCR,
+		.num_planes	= 1,
+		.num_comp	= 1,
+		.scaler_color	= SCALER_YUV422_1P_UYVY,
+		.flags		= SCALER_FMT_SRC | SCALER_FMT_DST,
+	}, {
+		.name		= "XRGB-4444, 16 bpp",
+		.pixelformat	= V4L2_PIX_FMT_RGB444,
+		.depth		= { 16 },
+		.color		= SCALER_RGB,
+		.num_planes	= 1,
+		.num_comp	= 1,
+		.scaler_color	= SCALER_ARGB4444,
+		.flags		= SCALER_FMT_SRC | SCALER_FMT_DST,
+	}, {
+		.name		= "YUV 4:2:0 non-contig. 2p, Y/CrCb",
+		.pixelformat	= V4L2_PIX_FMT_NV21M,
+		.depth		= { 8, 4 },
+		.color		= SCALER_YUV420,
+		.color_order	= SCALER_CRCB,
+		.num_planes	= 2,
+		.num_comp	= 2,
+		.scaler_color	= SCALER_YUV420_2P_Y_VU,
+		.flags		= SCALER_FMT_SRC | SCALER_FMT_DST,
+	}, {
+		.name		= "YUV 4:2:0 contig. 2p, Y/CrCb",
+		.pixelformat	= V4L2_PIX_FMT_NV21,
+		.depth		= { 12 },
+		.color		= SCALER_YUV420,
+		.color_order	= SCALER_CRCB,
+		.num_planes	= 1,
+		.num_comp	= 2,
+		.scaler_color	= SCALER_YUV420_2P_Y_VU,
+		.flags		= SCALER_FMT_SRC | SCALER_FMT_DST,
+	}, {
+		.name		= "YUV 4:2:2 contig. 2p, Y/CrCb",
+		.pixelformat	= V4L2_PIX_FMT_NV61,
+		.depth		= { 16 },
+		.color		= SCALER_YUV422,
+		.color_order	= SCALER_CRCB,
+		.num_planes	= 1,
+		.num_comp	= 2,
+		.scaler_color	= SCALER_YUV422_2P_Y_VU,
+		.flags		= SCALER_FMT_SRC | SCALER_FMT_DST,
+	}, {
+		.name		= "YUV 4:4:4 contig. 2p, Y/CrCb",
+		.pixelformat	= V4L2_PIX_FMT_NV42,
+		.depth		= { 24 },
+		.color		= SCALER_YUV444,
+		.color_order	= SCALER_CRCB,
+		.num_planes	= 1,
+		.num_comp	= 2,
+		.scaler_color	= SCALER_YUV444_2P_Y_VU,
+		.flags		= SCALER_FMT_SRC | SCALER_FMT_DST,
+	}, {
+		.name		= "YUV 4:2:0 contig. 3p, YCbCr",
+		.pixelformat	= V4L2_PIX_FMT_YUV420,
+		.depth		= { 12 },
+		.color		= SCALER_YUV420,
+		.color_order	= SCALER_CBCR,
+		.num_planes	= 1,
+		.num_comp	= 3,
+		.scaler_color	= SCALER_YUV420_3P_Y_U_V,
+		.flags		= SCALER_FMT_SRC | SCALER_FMT_DST,
+	}, {
+		.name		= "YUV 4:2:0 contig. 3p, YCrCb",
+		.pixelformat	= V4L2_PIX_FMT_YVU420,
+		.depth		= { 12 },
+		.color		= SCALER_YUV420,
+		.color_order	= SCALER_CRCB,
+		.num_planes	= 1,
+		.num_comp	= 3,
+		.scaler_color	= SCALER_YUV420_3P_Y_U_V,
+		.flags		= SCALER_FMT_SRC | SCALER_FMT_DST,
+	}, {
+		.name		= "YUV 4:2:0 non-contig. 3p, Y/Cb/Cr",
+		.pixelformat	= V4L2_PIX_FMT_YUV420M,
+		.depth		= { 8, 2, 2 },
+		.color		= SCALER_YUV420,
+		.color_order	= SCALER_CBCR,
+		.num_planes	= 3,
+		.num_comp	= 3,
+		.scaler_color	= SCALER_YUV420_3P_Y_U_V,
+		.flags		= SCALER_FMT_SRC | SCALER_FMT_DST,
+	}, {
+		.name		= "YUV 4:2:0 non-contig. 3p, Y/Cr/Cb",
+		.pixelformat	= V4L2_PIX_FMT_YVU420M,
+		.depth		= { 8, 2, 2 },
+		.color		= SCALER_YUV420,
+		.color_order	= SCALER_CRCB,
+		.num_planes	= 3,
+		.num_comp	= 3,
+		.scaler_color	= SCALER_YUV420_3P_Y_U_V,
+		.flags		= SCALER_FMT_SRC | SCALER_FMT_DST,
+	}, {
+		.name		= "YUV 4:2:2 contig. 3p, Y/Cb/Cr",
+		.pixelformat	= V4L2_PIX_FMT_YUV422P,
+		.depth		= { 16 },
+		.color		= SCALER_YUV422,
+		.color_order	= SCALER_CBCR,
+		.num_planes	= 1,
+		.num_comp	= 3,
+		.scaler_color	= SCALER_YUV422_3P_Y_U_V,
+		.flags		= SCALER_FMT_SRC | SCALER_FMT_DST,
+	},
+
+	/*
+	 * TODO: support pixel formats, corresponds to these scaler_color
+	 * formats. SCALER_L8A8, SCALER_RGBA8888, SCALER_L8 etc
+	 */
+};
+
+const struct scaler_fmt *scaler_get_format(int index)
+{
+	if (index >= ARRAY_SIZE(scaler_formats))
+		return NULL;
+
+	return &scaler_formats[index];
+}
+
+const struct scaler_fmt *scaler_find_fmt(u32 *pixelformat, int index)
+{
+	unsigned int i;
+	int num_fmts = ARRAY_SIZE(scaler_formats);
+
+	if (index >= num_fmts)
+		return NULL;
+
+	if (index >= 0)
+		return &scaler_formats[index];
+
+	if (!pixelformat)
+		return NULL;
+
+	for (i = 0; i < num_fmts; ++i)
+		if (scaler_formats[i].pixelformat == *pixelformat)
+			return &scaler_formats[i];
+
+	return NULL;
+}
+
+void scaler_set_frame_size(struct scaler_frame *frame, int width, int height)
+{
+	frame->f_width = width;
+	frame->f_height = height;
+	frame->selection.width = width;
+	frame->selection.height = height;
+	frame->selection.left = 0;
+	frame->selection.top = 0;
+}
+
+int scaler_enum_fmt_mplane(struct v4l2_fmtdesc *f)
+{
+	const struct scaler_fmt *fmt;
+
+	fmt = scaler_find_fmt(NULL, f->index);
+	if (!fmt)
+		return -EINVAL;
+
+	/*
+	 * Input supports all scaler_formats but all scaler_formats are not
+	 * supported for output. Don't return unsupported formats for output.
+	 */
+	if (!(V4L2_TYPE_IS_OUTPUT(f->type) &&
+	    (fmt->flags & SCALER_FMT_SRC)))
+		return -EINVAL;
+
+	strlcpy(f->description, fmt->name, sizeof(f->description));
+	f->pixelformat = fmt->pixelformat;
+
+	return 0;
+}
+
+struct scaler_frame *ctx_get_frame(struct scaler_ctx *ctx,
+					      enum v4l2_buf_type type)
+{
+	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		return &ctx->s_frame;
+
+	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return &ctx->d_frame;
+
+	scaler_dbg(ctx->scaler_dev, "Wrong buffer/video queue type (%d)", type);
+	return ERR_PTR(-EINVAL);
+}
+
+
+static u32 get_plane_info(struct scaler_frame *frm, u32 addr, u32 *index)
+{
+	if (frm->addr.y == addr) {
+		*index = 0;
+		return frm->addr.y;
+	} else if (frm->addr.cb == addr) {
+		*index = 1;
+		return frm->addr.cb;
+	} else if (frm->addr.cr == addr) {
+		*index = 2;
+		return frm->addr.cr;
+	}
+
+	pr_debug("Plane address is wrong\n");
+	return -EINVAL;
+}
+
+void scaler_set_prefbuf(struct scaler_dev *scaler, struct scaler_frame *frm)
+{
+	u32 f_chk_addr, f_chk_len, s_chk_addr, s_chk_len;
+	f_chk_addr = f_chk_len = s_chk_addr = s_chk_len = 0;
+
+	f_chk_addr = frm->addr.y;
+	f_chk_len = frm->payload[0];
+
+	if (frm->fmt->num_planes == 2) {
+		s_chk_addr = frm->addr.cb;
+		s_chk_len = frm->payload[1];
+	} else if (frm->fmt->num_planes == 3) {
+		u32 low_addr, low_plane, mid_addr, mid_plane;
+		u32 high_addr, high_plane;
+		u32 t_min, t_max;
+
+		t_min = min3(frm->addr.y, frm->addr.cb, frm->addr.cr);
+		low_addr = get_plane_info(frm, t_min, &low_plane);
+		t_max = max3(frm->addr.y, frm->addr.cb, frm->addr.cr);
+		high_addr = get_plane_info(frm, t_max, &high_plane);
+
+		mid_plane = 3 - (low_plane + high_plane);
+		if (mid_plane == 0)
+			mid_addr = frm->addr.y;
+		else if (mid_plane == 1)
+			mid_addr = frm->addr.cb;
+		else if (mid_plane == 2)
+			mid_addr = frm->addr.cr;
+		else
+			return;
+
+		f_chk_addr = low_addr;
+		if (mid_addr + frm->payload[mid_plane] - low_addr >
+		    high_addr + frm->payload[high_plane] - mid_addr) {
+			f_chk_len = frm->payload[low_plane];
+			s_chk_addr = mid_addr;
+			s_chk_len = high_addr +
+					frm->payload[high_plane] - mid_addr;
+		} else {
+			f_chk_len = mid_addr +
+					frm->payload[mid_plane] - low_addr;
+			s_chk_addr = high_addr;
+			s_chk_len = frm->payload[high_plane];
+		}
+	}
+
+	scaler_dbg(scaler,
+		"f_addr = 0x%08x, f_len = %d, s_addr = 0x%08x, s_len = %d\n",
+		f_chk_addr, f_chk_len, s_chk_addr, s_chk_len);
+}
+
+int scaler_try_fmt_mplane(struct scaler_ctx *ctx, struct v4l2_format *f)
+{
+	struct scaler_dev *scaler = ctx->scaler_dev;
+	struct device *dev = &scaler->pdev->dev;
+	struct scaler_variant *variant = scaler->variant;
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	const struct scaler_fmt *fmt;
+	u32 max_w, max_h, mod_w = 0, mod_h = 0;
+	u32 min_w, min_h, tmp_w, tmp_h;
+	int i;
+	struct scaler_frm_limit *frm_limit;
+
+	scaler_dbg(scaler, "user put w: %d, h: %d",
+			pix_mp->width, pix_mp->height);
+
+	fmt = scaler_find_fmt(&pix_mp->pixelformat, -1);
+	if (!fmt) {
+		scaler_dbg(scaler, "pixelformat format (0x%X) invalid\n",
+					pix_mp->pixelformat);
+		/* Falling back to default pixel format */
+		fmt = scaler_find_fmt(NULL, 0);
+		pix_mp->pixelformat = fmt->pixelformat;
+	}
+
+	pix_mp->field = V4L2_FIELD_NONE;
+	if (V4L2_TYPE_IS_OUTPUT(f->type))
+		frm_limit = variant->pix_out;
+	else
+		frm_limit = variant->pix_in;
+
+	max_w = frm_limit->max_w;
+	max_h = frm_limit->max_h;
+	min_w = frm_limit->min_w;
+	min_h = frm_limit->min_h;
+
+	/* Span has to be even number for YCbCr422-2p or YCbCr420 format. */
+	if (is_yuv422_2p(fmt) || is_yuv420(fmt))
+		mod_w = 1;
+
+	scaler_dbg(scaler, "mod_w: %d, mod_h: %d, max_w: %d, max_h = %d",
+			mod_w, mod_h, max_w, max_h);
+
+	tmp_w = pix_mp->width;
+	tmp_h = pix_mp->height;
+
+	v4l_bound_align_image(&pix_mp->width, min_w, max_w, mod_w,
+		&pix_mp->height, min_h, max_h, mod_h, 0);
+	if (tmp_w != pix_mp->width || tmp_h != pix_mp->height)
+		dev_info(dev,
+			 "Image size has been modified from %dx%d to %dx%d",
+			 tmp_w, tmp_h, pix_mp->width, pix_mp->height);
+
+	pix_mp->num_planes = fmt->num_planes;
+
+	/*
+	 * Nothing mentioned about the colorspace in SCALER. Default value is
+	 * set to V4L2_COLORSPACE_REC709.
+	 */
+	pix_mp->colorspace = V4L2_COLORSPACE_REC709;
+
+	for (i = 0; i < pix_mp->num_planes; ++i) {
+		int bpl = (pix_mp->width * fmt->depth[i]) >> 3;
+		pix_mp->plane_fmt[i].bytesperline = bpl;
+		pix_mp->plane_fmt[i].sizeimage = bpl * pix_mp->height;
+
+		scaler_dbg(scaler, "[%d]: bpl: %d, sizeimage: %d",
+				i, bpl, pix_mp->plane_fmt[i].sizeimage);
+	}
+
+	return 0;
+}
+
+int scaler_g_fmt_mplane(struct scaler_ctx *ctx, struct v4l2_format *f)
+{
+	struct scaler_frame *frame;
+	struct v4l2_pix_format_mplane *pix_mp;
+	int i;
+
+	frame = ctx_get_frame(ctx, f->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	pix_mp = &f->fmt.pix_mp;
+
+	pix_mp->width		= frame->f_width;
+	pix_mp->height		= frame->f_height;
+	pix_mp->field		= V4L2_FIELD_NONE;
+	pix_mp->pixelformat	= frame->fmt->pixelformat;
+	pix_mp->colorspace	= V4L2_COLORSPACE_REC709;
+	pix_mp->num_planes	= frame->fmt->num_planes;
+
+	for (i = 0; i < pix_mp->num_planes; ++i) {
+		pix_mp->plane_fmt[i].bytesperline = (frame->f_width *
+			frame->fmt->depth[i]) / 8;
+		pix_mp->plane_fmt[i].sizeimage =
+			 pix_mp->plane_fmt[i].bytesperline * frame->f_height;
+	}
+
+	return 0;
+}
+
+void scaler_check_crop_change(u32 tmp_w, u32 tmp_h, u32 *w, u32 *h)
+{
+	if (tmp_w != *w || tmp_h != *h) {
+		pr_info("Cropped size has been modified from %dx%d to %dx%d",
+							*w, *h, tmp_w, tmp_h);
+		*w = tmp_w;
+		*h = tmp_h;
+	}
+}
+
+int scaler_g_crop(struct scaler_ctx *ctx, struct v4l2_crop *cr)
+{
+	struct scaler_frame *frame;
+
+	frame = ctx_get_frame(ctx, cr->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	cr->c = frame->selection;
+
+	return 0;
+}
+
+int scaler_try_crop(struct scaler_ctx *ctx, struct v4l2_crop *cr)
+{
+	struct scaler_frame *f;
+	const struct scaler_fmt *fmt;
+	struct scaler_dev *scaler = ctx->scaler_dev;
+	struct scaler_variant *variant = scaler->variant;
+	u32 mod_w = 0, mod_h = 0, tmp_w, tmp_h;
+	u32 min_w, min_h, max_w, max_h;
+	struct scaler_frm_limit *frm_limit;
+
+	if (cr->c.top < 0) {
+		scaler_dbg(scaler, "Adjusting crop.top value\n");
+		cr->c.top = 0;
+	}
+
+	if (cr->c.left < 0) {
+		scaler_dbg(scaler, "Adjusting crop.left value\n");
+		cr->c.left = 0;
+	}
+
+	scaler_dbg(scaler, "user requested width: %d, height: %d",
+					cr->c.width, cr->c.height);
+
+	f = ctx_get_frame(ctx, cr->type);
+	if (IS_ERR(f))
+		return PTR_ERR(f);
+
+	fmt = f->fmt;
+	tmp_w = cr->c.width;
+	tmp_h = cr->c.height;
+
+	if (V4L2_TYPE_IS_OUTPUT(cr->type))
+		frm_limit = variant->pix_out;
+	else
+		frm_limit = variant->pix_in;
+
+	max_w = f->f_width;
+	max_h = f->f_height;
+	min_w = frm_limit->min_w;
+	min_h = frm_limit->min_h;
+
+	if (V4L2_TYPE_IS_OUTPUT(cr->type)) {
+		if (is_yuv420(fmt)) {
+			mod_w = ffs(variant->pix_align->dst_w_420) - 1;
+			mod_h = ffs(variant->pix_align->dst_h_420) - 1;
+		} else if (is_yuv422(fmt)) {
+			mod_w = ffs(variant->pix_align->dst_w_422) - 1;
+		}
+	} else {
+		if (is_yuv420(fmt)) {
+			mod_w = ffs(variant->pix_align->src_w_420) - 1;
+			mod_h = ffs(variant->pix_align->src_h_420) - 1;
+		} else if (is_yuv422(fmt)) {
+			mod_w = ffs(variant->pix_align->src_w_422) - 1;
+		}
+
+		if (ctx->ctrls_scaler.rotate->val == 90 ||
+		    ctx->ctrls_scaler.rotate->val == 270) {
+			max_w = f->f_height;
+			max_h = f->f_width;
+			tmp_w = cr->c.height;
+			tmp_h = cr->c.width;
+		}
+	}
+
+	scaler_dbg(scaler, "mod_x: %d, mod_y: %d, min_w: %d, min_h = %d, tmp_w : %d, tmp_h : %d",
+			mod_w, mod_h, min_w, min_h, tmp_w, tmp_h);
+
+	v4l_bound_align_image(&tmp_w, min_w, max_w, mod_w,
+			      &tmp_h, min_h, max_h, mod_h, 0);
+
+	if (!V4L2_TYPE_IS_OUTPUT(cr->type) &&
+		(ctx->ctrls_scaler.rotate->val == 90 ||
+		 ctx->ctrls_scaler.rotate->val == 270))
+		scaler_check_crop_change(tmp_h, tmp_w,
+					&cr->c.width, &cr->c.height);
+	else
+		scaler_check_crop_change(tmp_w, tmp_h,
+					&cr->c.width, &cr->c.height);
+
+	/*
+	 * Adjust left/top if cropping rectangle is out of bounds. Need to add
+	 * code to algin left value with 2's multiple.
+	 */
+	if (cr->c.left + tmp_w > max_w)
+		cr->c.left = max_w - tmp_w;
+	if (cr->c.top + tmp_h > max_h)
+		cr->c.top = max_h - tmp_h;
+
+	if (is_yuv422_1p(fmt) && (cr->c.left & 1))
+		cr->c.left -= 1;
+
+	scaler_dbg(scaler, "Aligned l:%d, t:%d, w:%d, h:%d, f_w: %d, f_h: %d",
+	    cr->c.left, cr->c.top, cr->c.width, cr->c.height, max_w, max_h);
+
+	return 0;
+}
+
+int scaler_check_scaler_ratio(struct scaler_variant *var, int sw, int sh,
+					int dw, int dh, int rot)
+{
+	if ((dw == 0) || (dh == 0))
+		return -EINVAL;
+
+	if (rot == 90 || rot == 270)
+		swap(dh, dw);
+
+	pr_debug("sw: %d, sh: %d, dw: %d, dh: %d\n", sw, sh, dw, dh);
+
+	if ((sw / dw) > var->scl_down_max || (sh / dh) > var->scl_down_max ||
+	    (dw / sw) > var->scl_up_max   || (dh / sh) > var->scl_up_max)
+		return -EINVAL;
+
+	return 0;
+}
+
+int scaler_set_scaler_info(struct scaler_ctx *ctx)
+{
+	struct scaler_scaler *sc = &ctx->scaler;
+	struct scaler_frame *s_frame = &ctx->s_frame;
+	struct scaler_frame *d_frame = &ctx->d_frame;
+	struct scaler_variant *variant = ctx->scaler_dev->variant;
+	int src_w, src_h, ret;
+
+	ret = scaler_check_scaler_ratio(variant,
+			s_frame->selection.width, s_frame->selection.height,
+			d_frame->selection.width, d_frame->selection.height,
+			ctx->ctrls_scaler.rotate->val);
+	if (ret < 0) {
+		scaler_dbg(ctx->scaler_dev, "out of scaler range\n");
+		return ret;
+	}
+
+	if (ctx->ctrls_scaler.rotate->val == 90 ||
+		ctx->ctrls_scaler.rotate->val == 270) {
+		src_w = s_frame->selection.height;
+		src_h = s_frame->selection.width;
+	} else {
+		src_w = s_frame->selection.width;
+		src_h = s_frame->selection.height;
+	}
+
+	sc->hratio = (src_w << 16) / d_frame->selection.width;
+	sc->vratio = (src_h << 16) / d_frame->selection.height;
+
+	scaler_dbg(ctx->scaler_dev, "scaler settings::\n"
+		 "sx = %d, sy = %d, sw = %d, sh = %d\n"
+		 "dx = %d, dy = %d, dw = %d, dh = %d\n"
+		 "h-ratio : %d, v-ratio: %d\n",
+		 s_frame->selection.left, s_frame->selection.top,
+		 s_frame->selection.width, s_frame->selection.height,
+		 d_frame->selection.left, d_frame->selection.top,
+		 d_frame->selection.width, s_frame->selection.height,
+		 sc->hratio, sc->vratio);
+
+	return 0;
+}
+
+static int __scaler_try_ctrl(struct scaler_ctx *ctx, struct v4l2_ctrl *ctrl)
+{
+	struct scaler_dev *scaler = ctx->scaler_dev;
+	struct scaler_variant *variant = scaler->variant;
+
+	switch (ctrl->id) {
+	case V4L2_CID_ROTATE:
+		return scaler_check_scaler_ratio(variant,
+			ctx->s_frame.selection.width,
+			ctx->s_frame.selection.height,
+			ctx->d_frame.selection.width,
+			ctx->d_frame.selection.height,
+			ctx->ctrls_scaler.rotate->val);
+	}
+
+	return 0;
+}
+
+static int scaler_try_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct scaler_ctx *ctx = ctrl_to_ctx(ctrl);
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&ctx->scaler_dev->slock, flags);
+	ret = __scaler_try_ctrl(ctx, ctrl);
+	spin_unlock_irqrestore(&ctx->scaler_dev->slock, flags);
+
+	return ret;
+}
+
+static int __scaler_s_ctrl(struct scaler_ctx *ctx, struct v4l2_ctrl *ctrl)
+{
+	switch (ctrl->id) {
+	case V4L2_CID_HFLIP:
+		ctx->hflip = ctrl->val;
+		break;
+
+	case V4L2_CID_VFLIP:
+		ctx->vflip = ctrl->val;
+		break;
+
+	case V4L2_CID_ROTATE:
+		ctx->rotation = ctrl->val;
+		break;
+
+	case V4L2_CID_ALPHA_COMPONENT:
+		ctx->d_frame.alpha = ctrl->val;
+		break;
+	}
+
+	ctx->state |= SCALER_PARAMS;
+	return 0;
+}
+
+static int scaler_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct scaler_ctx *ctx = ctrl_to_ctx(ctrl);
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&ctx->scaler_dev->slock, flags);
+	ret = __scaler_s_ctrl(ctx, ctrl);
+	spin_unlock_irqrestore(&ctx->scaler_dev->slock, flags);
+
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops scaler_ctrl_ops = {
+	.try_ctrl = scaler_try_ctrl,
+	.s_ctrl = scaler_s_ctrl,
+};
+
+int scaler_ctrls_create(struct scaler_ctx *ctx)
+{
+	if (ctx->ctrls_rdy) {
+		scaler_dbg(ctx->scaler_dev,
+			"Control handler of this ctx was created already");
+		return 0;
+	}
+
+	v4l2_ctrl_handler_init(&ctx->ctrl_handler, SCALER_MAX_CTRL_NUM);
+
+	ctx->ctrls_scaler.rotate = v4l2_ctrl_new_std(&ctx->ctrl_handler,
+		&scaler_ctrl_ops, V4L2_CID_ROTATE, 0, 270, 90, 0);
+	ctx->ctrls_scaler.hflip = v4l2_ctrl_new_std(&ctx->ctrl_handler,
+		&scaler_ctrl_ops, V4L2_CID_HFLIP, 0, 1, 1, 0);
+	ctx->ctrls_scaler.vflip = v4l2_ctrl_new_std(&ctx->ctrl_handler,
+		&scaler_ctrl_ops, V4L2_CID_VFLIP, 0, 1, 1, 0);
+	ctx->ctrls_scaler.global_alpha = v4l2_ctrl_new_std(&ctx->ctrl_handler,
+		&scaler_ctrl_ops, V4L2_CID_ALPHA_COMPONENT, 0, 255, 1, 0);
+
+	ctx->ctrls_rdy = ctx->ctrl_handler.error == 0;
+
+	if (ctx->ctrl_handler.error) {
+		int err = ctx->ctrl_handler.error;
+		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+		dev_err(&ctx->scaler_dev->pdev->dev,
+			"Failed to create SCALER control handlers");
+		return err;
+	}
+
+	return 0;
+}
+
+void scaler_ctrls_delete(struct scaler_ctx *ctx)
+{
+	if (ctx->ctrls_rdy) {
+		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+		ctx->ctrls_rdy = false;
+	}
+}
+
+/* The color format (num_comp, num_planes) must be already configured. */
+int scaler_prepare_addr(struct scaler_ctx *ctx, struct vb2_buffer *vb,
+			struct scaler_frame *frame, struct scaler_addr *addr)
+{
+	int ret = 0;
+	u32 pix_size;
+	const struct scaler_fmt *fmt;
+
+	if (vb == NULL || frame == NULL)
+		return -EINVAL;
+
+	pix_size = frame->f_width * frame->f_height;
+	fmt = frame->fmt;
+
+	scaler_dbg(ctx->scaler_dev,
+		"planes= %d, comp= %d, pix_size= %d, fmt = %d\n",
+		fmt->num_planes, fmt->num_comp,
+		pix_size, fmt->scaler_color);
+
+	addr->y = vb2_dma_contig_plane_dma_addr(vb, 0);
+
+	if (fmt->num_planes == 1) {
+		switch (fmt->num_comp) {
+		case 1:
+			addr->cb = 0;
+			addr->cr = 0;
+			break;
+		case 2:
+			/* Decompose Y into Y/Cb */
+			addr->cb = (dma_addr_t)(addr->y + pix_size);
+			addr->cr = 0;
+			break;
+		case 3:
+			/* Decompose Y into Y/Cb/Cr */
+			addr->cb = (dma_addr_t)(addr->y + pix_size);
+			if (SCALER_YUV420 == fmt->color)
+				addr->cr = (dma_addr_t)(addr->cb
+						+ (pix_size >> 2));
+			else if (SCALER_YUV422 == fmt->color)
+				addr->cr = (dma_addr_t)(addr->cb
+						+ (pix_size >> 1));
+			else /* 444 */
+				addr->cr = (dma_addr_t)(addr->cb + pix_size);
+			break;
+		default:
+			scaler_dbg(ctx->scaler_dev,
+				"Invalid number of color planes\n");
+			return -EINVAL;
+		}
+	} else {
+		if (fmt->num_planes >= 2)
+			addr->cb = vb2_dma_contig_plane_dma_addr(vb, 1);
+
+		if (fmt->num_planes == 3)
+			addr->cr = vb2_dma_contig_plane_dma_addr(vb, 2);
+	}
+
+	if ((fmt->color_order == SCALER_CRCB) && (fmt->num_planes == 3))
+		swap(addr->cb, addr->cr);
+
+	if (V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type))
+		scaler_dbg(ctx->scaler_dev,
+			 "\nIN:ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d\n",
+			 addr->y, addr->cb, addr->cr, ret);
+	else
+		scaler_dbg(ctx->scaler_dev,
+			 "\nOUT:ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d\n",
+			 addr->y, addr->cb, addr->cr, ret);
+
+	return ret;
+}
+
+static void scaler_sw_reset(struct scaler_dev *scaler)
+{
+	scaler_hw_set_sw_reset(scaler);
+	scaler_wait_reset(scaler);
+
+	scaler->coeff_type = SCALER_CSC_COEFF_NONE;
+}
+
+static void scaler_check_for_illegal_status(struct device *dev,
+					  unsigned int irq_status)
+{
+	int i;
+
+	for (i = 0; i < SCALER_NUM_ERRORS; i++)
+		if ((1 << scaler_errors[i].irq_num) & irq_status)
+			dev_err(dev, "ERROR:: %s\n", scaler_errors[i].name);
+}
+
+static irqreturn_t scaler_irq_handler(int irq, void *priv)
+{
+	struct scaler_dev *scaler = priv;
+	struct scaler_ctx *ctx;
+	unsigned int scaler_irq;
+	struct device *dev = &scaler->pdev->dev;
+
+	scaler_irq = scaler_hw_get_irq_status(scaler);
+	scaler_dbg(scaler, "irq_status: 0x%x\n", scaler_irq);
+	scaler_hw_clear_irq(scaler, scaler_irq);
+
+	if (scaler_irq & SCALER_INT_STATUS_ERROR)
+		scaler_check_for_illegal_status(dev, scaler_irq);
+
+	if (!(scaler_irq & (1 << SCALER_INT_FRAME_END)))
+		return IRQ_HANDLED;
+
+	spin_lock(&scaler->slock);
+
+	if (test_and_clear_bit(ST_M2M_PEND, &scaler->state)) {
+
+		scaler_hw_enable_control(scaler, false);
+
+		if (test_and_clear_bit(ST_M2M_SUSPENDING, &scaler->state)) {
+			set_bit(ST_M2M_SUSPENDED, &scaler->state);
+			wake_up(&scaler->irq_queue);
+			goto isr_unlock;
+		}
+		ctx = v4l2_m2m_get_curr_priv(scaler->m2m.m2m_dev);
+
+		if (!ctx || !ctx->m2m_ctx)
+			goto isr_unlock;
+
+		spin_unlock(&scaler->slock);
+		scaler_m2m_job_finish(ctx, VB2_BUF_STATE_DONE);
+
+		/* wake_up job_abort, stop_streaming */
+		if (ctx->state & SCALER_CTX_STOP_REQ) {
+			ctx->state &= ~SCALER_CTX_STOP_REQ;
+			wake_up(&scaler->irq_queue);
+		}
+		return IRQ_HANDLED;
+	}
+
+isr_unlock:
+	spin_unlock(&scaler->slock);
+	return IRQ_HANDLED;
+}
+
+static struct scaler_frm_limit scaler_frm_limit_5410 = {
+	.min_w = 4,
+	.min_h = 4,
+	.max_w = 4096,
+	.max_h = 4096,
+};
+
+static struct scaler_frm_limit scaler_inp_frm_limit_5420 = {
+	.min_w = 16,
+	.min_h = 16,
+	.max_w = 8192,
+	.max_h = 8192,
+};
+
+static struct scaler_frm_limit scaler_out_frm_limit_5420 = {
+	.min_w = 4,
+	.min_h = 4,
+	.max_w = 8192,
+	.max_h = 8192,
+};
+
+static struct scaler_pix_align scaler_align_info = {
+	.src_w_420 = 2,
+	.src_w_422 = 2,
+	.src_h_420 = 2,
+	.dst_w_420 = 2,
+	.dst_w_422 = 2,
+	.dst_h_420 = 2,
+};
+
+
+static struct scaler_variant scaler_variant_info_5410 = {
+	.pix_in		= &scaler_frm_limit_5410,
+	.pix_out	= &scaler_frm_limit_5410,
+	.pix_align	= &scaler_align_info,
+	.scl_up_max	= 16,
+	.scl_down_max	= 4,
+	.in_buf_cnt	= 32,
+	.out_buf_cnt	= 32,
+};
+
+static struct scaler_variant scaler_variant_info_5420 = {
+	.pix_in		= &scaler_inp_frm_limit_5420,
+	.pix_out	= &scaler_out_frm_limit_5420,
+	.pix_align	= &scaler_align_info,
+	.scl_up_max	= 16,
+	.scl_down_max	= 4,
+	.in_buf_cnt	= 32,
+	.out_buf_cnt	= 32,
+};
+
+static const struct of_device_id exynos_scaler_match[] = {
+	{
+		.compatible = "samsung,exynos5410-scaler",
+		.data = &scaler_variant_info_5410,
+	},
+	{
+		.compatible = "samsung,exynos5420-scaler",
+		.data = &scaler_variant_info_5420,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos_scaler_match);
+
+static void *scaler_get_variant_data(struct platform_device *pdev)
+{
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_node(exynos_scaler_match, pdev->dev.of_node);
+		if (match)
+			return (void *)match->data;
+	}
+
+	return NULL;
+}
+
+static void scaler_clk_put(struct scaler_dev *scaler)
+{
+	if (!IS_ERR(scaler->clock))
+		clk_unprepare(scaler->clock);
+}
+
+static int scaler_clk_get(struct scaler_dev *scaler)
+{
+	int ret;
+
+	scaler_dbg(scaler, "scaler_clk_get Called\n");
+
+	scaler->clock = devm_clk_get(&scaler->pdev->dev,
+					SCALER_CLOCK_GATE_NAME);
+	if (IS_ERR(scaler->clock)) {
+		dev_err(&scaler->pdev->dev, "failed to get clock: %s\n",
+			SCALER_CLOCK_GATE_NAME);
+		return PTR_ERR(scaler->clock);
+	}
+
+	ret = clk_prepare(scaler->clock);
+	if (ret < 0) {
+		dev_err(&scaler->pdev->dev,
+			"clock prepare fail for clock: %s\n",
+			SCALER_CLOCK_GATE_NAME);
+		scaler->clock = ERR_PTR(-EINVAL);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int scaler_m2m_suspend(struct scaler_dev *scaler)
+{
+	unsigned long flags;
+	int timeout;
+
+	spin_lock_irqsave(&scaler->slock, flags);
+	if (!scaler_m2m_pending(scaler)) {
+		spin_unlock_irqrestore(&scaler->slock, flags);
+		return 0;
+	}
+	clear_bit(ST_M2M_SUSPENDED, &scaler->state);
+	set_bit(ST_M2M_SUSPENDING, &scaler->state);
+	spin_unlock_irqrestore(&scaler->slock, flags);
+
+	timeout = wait_event_timeout(scaler->irq_queue,
+			     test_bit(ST_M2M_SUSPENDED, &scaler->state),
+			     SCALER_SHUTDOWN_TIMEOUT);
+
+	clear_bit(ST_M2M_SUSPENDING, &scaler->state);
+	return timeout == 0 ? -EAGAIN : 0;
+}
+
+static int scaler_m2m_resume(struct scaler_dev *scaler)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&scaler->slock, flags);
+	/* Clear for full H/W setup in first run after resume */
+	scaler->m2m.ctx = NULL;
+	spin_unlock_irqrestore(&scaler->slock, flags);
+
+	if (test_and_clear_bit(ST_M2M_SUSPENDED, &scaler->state))
+		scaler_m2m_job_finish(scaler->m2m.ctx,
+				    VB2_BUF_STATE_ERROR);
+	return 0;
+}
+
+static int scaler_probe(struct platform_device *pdev)
+{
+	struct scaler_dev *scaler;
+	struct resource *res;
+	struct device *dev = &pdev->dev;
+	int ret;
+
+	if (!dev->of_node)
+		return -ENODEV;
+
+	scaler = devm_kzalloc(dev, sizeof(*scaler), GFP_KERNEL);
+	if (!scaler)
+		return -ENOMEM;
+
+	scaler->pdev = pdev;
+	scaler->variant = scaler_get_variant_data(pdev);
+
+	init_waitqueue_head(&scaler->irq_queue);
+	spin_lock_init(&scaler->slock);
+	mutex_init(&scaler->lock);
+	scaler->clock = ERR_PTR(-EINVAL);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	scaler->regs = devm_request_and_ioremap(dev, res);
+	if (!scaler->regs)
+		return -ENODEV;
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		dev_err(dev, "failed to get IRQ resource\n");
+		return -ENXIO;
+	}
+
+	ret = scaler_clk_get(scaler);
+	if (ret < 0)
+		return ret;
+
+	ret = devm_request_irq(dev, res->start, scaler_irq_handler,
+				0, pdev->name, scaler);
+	if (ret < 0) {
+		dev_err(dev, "failed to install irq (%d)\n", ret);
+		goto err_clk;
+	}
+
+	platform_set_drvdata(pdev, scaler);
+	pm_runtime_enable(dev);
+
+	/* Initialize the continious memory allocator */
+	scaler->alloc_ctx = vb2_dma_contig_init_ctx(dev);
+	if (IS_ERR(scaler->alloc_ctx)) {
+		ret = PTR_ERR(scaler->alloc_ctx);
+		goto err_clk;
+	}
+
+	ret = v4l2_device_register(dev, &scaler->v4l2_dev);
+	if (ret < 0)
+		goto err_clk;
+
+	ret = scaler_register_m2m_device(scaler);
+	if (ret < 0)
+		goto err_v4l2;
+
+	dev_info(dev, "registered successfully\n");
+	return 0;
+
+err_v4l2:
+	v4l2_device_unregister(&scaler->v4l2_dev);
+err_clk:
+	scaler_clk_put(scaler);
+	return ret;
+}
+
+static int scaler_remove(struct platform_device *pdev)
+{
+	struct scaler_dev *scaler = platform_get_drvdata(pdev);
+
+	scaler_unregister_m2m_device(scaler);
+	v4l2_device_unregister(&scaler->v4l2_dev);
+
+	vb2_dma_contig_cleanup_ctx(scaler->alloc_ctx);
+	pm_runtime_disable(&pdev->dev);
+	scaler_clk_put(scaler);
+
+	scaler_dbg(scaler, "%s driver unloaded\n", pdev->name);
+	return 0;
+}
+
+static int scaler_runtime_resume(struct device *dev)
+{
+	struct scaler_dev *scaler = dev_get_drvdata(dev);
+	int ret;
+
+	scaler_dbg(scaler, "state: 0x%lx", scaler->state);
+
+	ret = clk_enable(scaler->clock);
+	if (ret < 0)
+		return ret;
+
+	scaler_sw_reset(scaler);
+
+	return scaler_m2m_resume(scaler);
+}
+
+static int scaler_runtime_suspend(struct device *dev)
+{
+	struct scaler_dev *scaler = dev_get_drvdata(dev);
+	int ret;
+
+	ret = scaler_m2m_suspend(scaler);
+	if (!ret)
+		clk_disable(scaler->clock);
+
+	scaler_dbg(scaler, "state: 0x%lx", scaler->state);
+	return ret;
+}
+
+static int scaler_resume(struct device *dev)
+{
+	struct scaler_dev *scaler = dev_get_drvdata(dev);
+	unsigned long flags;
+
+	scaler_dbg(scaler, "state: 0x%lx", scaler->state);
+
+	/* Do not resume if the device was idle before system suspend */
+	spin_lock_irqsave(&scaler->slock, flags);
+	if (!test_and_clear_bit(ST_SUSPEND, &scaler->state) ||
+	    !scaler_m2m_active(scaler)) {
+		spin_unlock_irqrestore(&scaler->slock, flags);
+		return 0;
+	}
+
+	scaler_sw_reset(scaler);
+	spin_unlock_irqrestore(&scaler->slock, flags);
+
+	return scaler_m2m_resume(scaler);
+}
+
+static int scaler_suspend(struct device *dev)
+{
+	struct scaler_dev *scaler = dev_get_drvdata(dev);
+
+	scaler_dbg(scaler, "state: 0x%lx", scaler->state);
+
+	if (test_and_set_bit(ST_SUSPEND, &scaler->state))
+		return 0;
+
+	return scaler_m2m_suspend(scaler);
+}
+
+static const struct dev_pm_ops scaler_pm_ops = {
+	.suspend		= scaler_suspend,
+	.resume			= scaler_resume,
+	.runtime_suspend	= scaler_runtime_suspend,
+	.runtime_resume		= scaler_runtime_resume,
+};
+
+static struct platform_driver scaler_driver = {
+	.probe		= scaler_probe,
+	.remove		= scaler_remove,
+	.driver = {
+		.name	= SCALER_MODULE_NAME,
+		.owner	= THIS_MODULE,
+		.pm	= &scaler_pm_ops,
+		.of_match_table = exynos_scaler_match,
+	}
+};
+
+module_platform_driver(scaler_driver);
+
+MODULE_AUTHOR("Shaik Ameer Basha <shaik.ameer@samsung.com>");
+MODULE_DESCRIPTION("Samsung EXYNOS5 Soc series SCALER driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/platform/exynos-scaler/scaler.h b/drivers/media/platform/exynos-scaler/scaler.h
new file mode 100644
index 0000000..9bb7f99
--- /dev/null
+++ b/drivers/media/platform/exynos-scaler/scaler.h
@@ -0,0 +1,376 @@
+/*
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Header file for Samsung EXYNOS5 SoC series SCALER driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef SCALER_CORE_H_
+#define SCALER_CORE_H_
+
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf2-dma-contig.h>
+
+#define scaler_dbg(_dev, fmt, args...) dev_dbg(&_dev->pdev->dev, fmt, ##args)
+
+#define SCALER_MODULE_NAME		"exynos5-scaler"
+
+#define SCALER_SHUTDOWN_TIMEOUT		((100 * HZ) / 1000)
+#define SCALER_MAX_DEVS			4
+#define SCALER_MAX_CTRL_NUM		10
+#define SCALER_SC_ALIGN_4		4
+#define SCALER_SC_ALIGN_2		2
+#define DEFAULT_CSC_EQ			1
+#define DEFAULT_CSC_RANGE		1
+#define SCALER_MAX_PLANES		3
+
+#define SCALER_PARAMS			(1 << 0)
+#define SCALER_CTX_STOP_REQ		(1 << 1)
+
+/* color format */
+#define SCALER_RGB			(0x1 << 0)
+#define SCALER_YUV420			(0x1 << 1)
+#define SCALER_YUV422			(0x1 << 2)
+#define SCALER_YUV444			(0x1 << 3)
+
+/* yuv color order */
+#define SCALER_CBCR			0
+#define SCALER_CRCB			1
+
+#define	SCALER_YUV420_2P_Y_UV		0
+#define SCALER_YUV422_2P_Y_UV		2
+#define SCALER_YUV444_2P_Y_UV		3
+#define SCALER_RGB565			4
+#define SCALER_ARGB1555			5
+#define SCALER_ARGB8888			6
+#define SCALER_PREMULTIPLIED_ARGB8888	7
+#define SCALER_YUV422_1P_YVYU		9
+#define SCALER_YUV422_1P_YUYV		10
+#define SCALER_YUV422_1P_UYVY		11
+#define SCALER_ARGB4444			12
+#define SCALER_L8A8			13
+#define SCALER_RGBA8888			14
+#define SCALER_L8			15
+#define SCALER_YUV420_2P_Y_VU		16
+#define SCALER_YUV422_2P_Y_VU		18
+#define SCALER_YUV444_2P_Y_VU		19
+#define SCALER_YUV420_3P_Y_U_V		20
+#define SCALER_YUV422_3P_Y_U_V		22
+#define SCALER_YUV444_3P_Y_U_V		23
+
+#define	SCALER_FMT_SRC			(0x1 << 0)
+#define	SCALER_FMT_DST			(0x1 << 1)
+#define	SCALER_FMT_TILED		(0x1 << 2)
+
+enum scaler_dev_flags {
+	/* for global */
+	ST_SUSPEND,
+
+	/* for m2m node */
+	ST_M2M_OPEN,
+	ST_M2M_RUN,
+	ST_M2M_PEND,
+	ST_M2M_SUSPENDED,
+	ST_M2M_SUSPENDING,
+};
+
+#define fh_to_ctx(__fh)		container_of(__fh, struct scaler_ctx, fh)
+#define is_rgb(fmt)		(!!(((fmt)->color) & SCALER_RGB))
+#define is_yuv(fmt)		((fmt->color >= SCALER_YUV420) && \
+					(fmt->color <= SCALER_YUV444))
+#define is_yuv420(fmt)		(!!((fmt->color) & SCALER_YUV420))
+#define is_yuv422(fmt)		(!!((fmt->color) & SCALER_YUV422))
+#define is_yuv422_1p(fmt)	(is_yuv422(fmt) && (fmt->num_planes == 1))
+#define is_yuv420_2p(fmt)	(is_yuv420(fmt) && (fmt->num_planes == 2))
+#define is_yuv422_2p(fmt)	(is_yuv422(fmt) && (fmt->num_planes == 2))
+#define is_yuv42x_2p(fmt)	(is_yuv420_2p(fmt) || is_yuv422_2p(fmt))
+#define is_src_fmt(fmt)		((fmt->flags) & SCALER_FMT_SRC)
+#define is_dst_fmt(fmt)		((fmt->flags) & SCALER_FMT_DST)
+#define is_tiled_fmt(fmt)	((fmt->flags) & SCALER_FMT_TILED)
+
+#define scaler_m2m_active(dev)	test_bit(ST_M2M_RUN, &(dev)->state)
+#define scaler_m2m_pending(dev)	test_bit(ST_M2M_PEND, &(dev)->state)
+#define scaler_m2m_opened(dev)	test_bit(ST_M2M_OPEN, &(dev)->state)
+
+#define ctrl_to_ctx(__ctrl) \
+	container_of((__ctrl)->handler, struct scaler_ctx, ctrl_handler)
+/**
+ * struct scaler_fmt - the driver's internal color format data
+ * @scaler_color: SCALER color format
+ * @name: format description
+ * @pixelformat: the fourcc code for this format, 0 if not applicable
+ * @color_order: Chrominance order control
+ * @num_planes: number of physically non-contiguous data planes
+ * @num_comp: number of physically contiguous data planes
+ * @depth: per plane driver's private 'number of bits per pixel'
+ * @flags: flags indicating which operation mode format applies to
+ */
+struct scaler_fmt {
+	u32	scaler_color;
+	char	*name;
+	u32	pixelformat;
+	u32	color;
+	u32	color_order;
+	u16	num_planes;
+	u16	num_comp;
+	u8	depth[SCALER_MAX_PLANES];
+	u32	flags;
+};
+
+/**
+ * struct scaler_input_buf - the driver's video buffer
+ * @vb:	videobuf2 buffer
+ * @list : linked list structure for buffer queue
+ * @idx : index of SCALER input buffer
+ */
+struct scaler_input_buf {
+	struct vb2_buffer	vb;
+	struct list_head	list;
+	int			idx;
+};
+
+/**
+ * struct scaler_addr - the SCALER DMA address set
+ * @y:	 luminance plane address
+ * @cb:	 Cb plane address
+ * @cr:	 Cr plane address
+ */
+struct scaler_addr {
+	dma_addr_t y;
+	dma_addr_t cb;
+	dma_addr_t cr;
+};
+
+/**
+ * struct scaler_ctrls - the SCALER control set
+ * @rotate: rotation degree
+ * @hflip: horizontal flip
+ * @vflip: vertical flip
+ * @global_alpha: the alpha value of current frame
+ */
+struct scaler_ctrls {
+	struct v4l2_ctrl *rotate;
+	struct v4l2_ctrl *hflip;
+	struct v4l2_ctrl *vflip;
+	struct v4l2_ctrl *global_alpha;
+};
+
+/* struct scaler_csc_info - color space conversion information */
+enum scaler_csc_coeff {
+	SCALER_CSC_COEFF_YCBCR_TO_RGB,
+	SCALER_CSC_COEFF_RGB_TO_YCBCR,
+	SCALER_CSC_COEFF_MAX,
+	SCALER_CSC_COEFF_NONE,
+};
+
+struct scaler_csc_info {
+	enum scaler_csc_coeff coeff_type;
+};
+
+/**
+ * struct scaler_scaler - the configuration data for SCALER inetrnal scaler
+ * @hratio:	the main scaler's horizontal ratio
+ * @vratio:	the main scaler's vertical ratio
+ */
+struct scaler_scaler {
+	u32 hratio;
+	u32 vratio;
+};
+
+struct scaler_dev;
+struct scaler_ctx;
+
+/**
+ * struct scaler_frame - source/target frame properties
+ * @f_width:	SRC : SRCIMG_WIDTH, DST : OUTPUTDMA_WHOLE_IMG_WIDTH
+ * @f_height:	SRC : SRCIMG_HEIGHT, DST : OUTPUTDMA_WHOLE_IMG_HEIGHT
+ * @selection:	crop(source)/compose(destination) size
+ * @payload:	image size in bytes (w x h x bpp)
+ * @addr:	image frame buffer DMA addresses
+ * @fmt:	SCALER color format pointer
+ * @colorspace: value indicating v4l2_colorspace
+ * @alpha:	frame's alpha value
+ */
+struct scaler_frame {
+	u32 f_width;
+	u32 f_height;
+	struct v4l2_rect selection;
+	unsigned long payload[SCALER_MAX_PLANES];
+	struct scaler_addr	addr;
+	const struct scaler_fmt *fmt;
+	u32 colorspace;
+	u8 alpha;
+};
+
+/**
+ * struct scaler_m2m_device - v4l2 memory-to-memory device data
+ * @vfd: the video device node for v4l2 m2m mode
+ * @m2m_dev: v4l2 memory-to-memory device data
+ * @ctx: hardware context data
+ */
+struct scaler_m2m_device {
+	struct video_device	*vfd;
+	struct v4l2_m2m_dev	*m2m_dev;
+	struct scaler_ctx	*ctx;
+};
+
+/* struct scaler_pix_input - image pixel size limits for input frame */
+struct scaler_frm_limit {
+	u16	min_w;
+	u16	min_h;
+	u16	max_w;
+	u16	max_h;
+
+};
+
+struct scaler_pix_align {
+	u16 src_w_420;
+	u16 src_w_422;
+	u16 src_h_420;
+	u16 dst_w_420;
+	u16 dst_w_422;
+	u16 dst_h_420;
+};
+
+/* struct scaler_variant - SCALER variant information */
+struct scaler_variant {
+	struct scaler_frm_limit	*pix_in;
+	struct scaler_frm_limit	*pix_out;
+	struct scaler_pix_align	*pix_align;
+	u16	scl_up_max;
+	u16	scl_down_max;
+	u16	in_buf_cnt;
+	u16	out_buf_cnt;
+};
+
+/**
+ * struct scaler_dev - abstraction for SCALER entity
+ * @slock: the spinlock protecting this data structure
+ * @lock: the mutex protecting this data structure
+ * @pdev: pointer to the SCALER platform device
+ * @variant: the IP variant information
+ * @id: SCALER device index (0..SCALER_MAX_DEVS)
+ * @clock: clocks required for SCALER operation
+ * @regs: the mapped hardware registers
+ * @irq_queue: interrupt handler waitqueue
+ * @m2m: memory-to-memory V4L2 device information
+ * @state: flags used to synchronize m2m and capture mode operation
+ * @alloc_ctx: videobuf2 memory allocator context
+ * @vdev: video device for SCALER instance
+ */
+struct scaler_dev {
+	spinlock_t			slock;
+	struct mutex			lock;
+	struct platform_device		*pdev;
+	struct scaler_variant		*variant;
+	struct clk			*clock;
+	void __iomem			*regs;
+	wait_queue_head_t		irq_queue;
+	struct scaler_m2m_device	m2m;
+	unsigned long			state;
+	struct vb2_alloc_ctx		*alloc_ctx;
+	struct video_device		vdev;
+	struct v4l2_device		v4l2_dev;
+	enum scaler_csc_coeff		coeff_type;
+};
+
+/**
+ * scaler_ctx - the device context data
+ * @s_frame: source frame properties
+ * @d_frame: destination frame properties
+ * @scaler: image scaler properties
+ * @flags: additional flags for image conversion
+ * @state: flags to keep track of user configuration
+ * @scaler_dev: the SCALER device this context applies to
+ * @m2m_ctx: memory-to-memory device context
+ * @fh: v4l2 file handle
+ * @ctrl_handler: v4l2 controls handler
+ * @ctrls_scaler: SCALER control set
+ * @ctrls_rdy: true if the control handler is initialized
+ */
+struct scaler_ctx {
+	struct scaler_frame	s_frame;
+	struct scaler_frame	d_frame;
+	struct scaler_scaler	scaler;
+	u32			flags;
+	u32			state;
+	int			rotation;
+	unsigned int		hflip:1;
+	unsigned int		vflip:1;
+	struct scaler_dev	*scaler_dev;
+	struct v4l2_m2m_ctx	*m2m_ctx;
+	struct v4l2_fh		fh;
+	struct v4l2_ctrl_handler ctrl_handler;
+	struct scaler_ctrls	ctrls_scaler;
+	bool			ctrls_rdy;
+};
+
+static inline void scaler_ctx_state_lock_set(u32 state, struct scaler_ctx *ctx)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->scaler_dev->slock, flags);
+	ctx->state |= state;
+	spin_unlock_irqrestore(&ctx->scaler_dev->slock, flags);
+}
+
+static inline void scaler_ctx_state_lock_clear(u32 state,
+					struct scaler_ctx *ctx)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->scaler_dev->slock, flags);
+	ctx->state &= ~state;
+	spin_unlock_irqrestore(&ctx->scaler_dev->slock, flags);
+}
+
+static inline bool scaler_ctx_state_is_set(u32 mask, struct scaler_ctx *ctx)
+{
+	unsigned long flags;
+	bool ret;
+
+	spin_lock_irqsave(&ctx->scaler_dev->slock, flags);
+	ret = (ctx->state & mask) == mask;
+	spin_unlock_irqrestore(&ctx->scaler_dev->slock, flags);
+	return ret;
+}
+
+void scaler_set_prefbuf(struct scaler_dev *scaler, struct scaler_frame *frm);
+int scaler_register_m2m_device(struct scaler_dev *scaler);
+void scaler_unregister_m2m_device(struct scaler_dev *scaler);
+void scaler_m2m_job_finish(struct scaler_ctx *ctx, int vb_state);
+u32 get_plane_size(struct scaler_frame *fr, unsigned int plane);
+const struct scaler_fmt *scaler_get_format(int index);
+const struct scaler_fmt *scaler_find_fmt(u32 *pixelformat, int index);
+struct scaler_frame *ctx_get_frame(struct scaler_ctx *ctx,
+			enum v4l2_buf_type type);
+int scaler_enum_fmt_mplane(struct v4l2_fmtdesc *f);
+int scaler_try_fmt_mplane(struct scaler_ctx *ctx, struct v4l2_format *f);
+void scaler_set_frame_size(struct scaler_frame *frame, int width, int height);
+int scaler_g_fmt_mplane(struct scaler_ctx *ctx, struct v4l2_format *f);
+void scaler_check_crop_change(u32 tmp_w, u32 tmp_h, u32 *w, u32 *h);
+int scaler_g_crop(struct scaler_ctx *ctx, struct v4l2_crop *cr);
+int scaler_try_crop(struct scaler_ctx *ctx, struct v4l2_crop *cr);
+int scaler_cal_prescaler_ratio(struct scaler_variant *var, u32 src, u32 dst,
+			u32 *ratio);
+void scaler_get_prescaler_shfactor(u32 hratio, u32 vratio, u32 *sh);
+void scaler_check_src_scale_info(struct scaler_variant *var,
+			struct scaler_frame *s_frame,
+			u32 *wratio, u32 tx, u32 ty, u32 *hratio);
+int scaler_check_scaler_ratio(struct scaler_variant *var, int sw, int sh,
+			int dw,	int dh, int rot);
+int scaler_set_scaler_info(struct scaler_ctx *ctx);
+int scaler_ctrls_create(struct scaler_ctx *ctx);
+void scaler_ctrls_delete(struct scaler_ctx *ctx);
+int scaler_prepare_addr(struct scaler_ctx *ctx, struct vb2_buffer *vb,
+			struct scaler_frame *frame, struct scaler_addr *addr);
+
+#endif /* SCALER_CORE_H_ */
-- 
1.7.9.5

