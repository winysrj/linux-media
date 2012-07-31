Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:42470 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab2GaL5N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 07:57:13 -0400
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M80000GTX6V8DW0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 31 Jul 2012 20:57:11 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8000CIRX6VNU20@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 31 Jul 2012 20:57:11 +0900 (KST)
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org
Cc: sungchun.kang@samsung.com, khw0178.kim@samsung.com,
	mchehab@infradead.org, laurent.pinchart@ideasonboard.com,
	sy0816.kang@samsung.com, s.nawrocki@samsung.com,
	posciak@google.com, alim.akhtar@gmail.com, prashanth.g@samsung.com,
	joshi@samsung.com, shaik.samsung@gmail.com, shaik.ameer@samsung.com
Subject: [PATCH v4 3/5] media: gscaler: Add core functionality for the G-Scaler
 driver
Date: Tue, 31 Jul 2012 17:42:31 +0530
Message-id: <1343736753-18454-4-git-send-email-shaik.ameer@samsung.com>
In-reply-to: <1343736753-18454-1-git-send-email-shaik.ameer@samsung.com>
References: <1343736753-18454-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sungchun Kang <sungchun.kang@samsung.com>

This patch adds the core functionality for the G-Scaler driver.

Signed-off-by: Hynwoong Kim <khw0178.kim@samsung.com>
Signed-off-by: Sungchun Kang <sungchun.kang@samsung.com>
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/video/exynos-gsc/gsc-core.c | 1263 +++++++++++++++++++++++++++++
 drivers/media/video/exynos-gsc/gsc-core.h |  537 ++++++++++++
 2 files changed, 1800 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/exynos-gsc/gsc-core.c
 create mode 100644 drivers/media/video/exynos-gsc/gsc-core.h

diff --git a/drivers/media/video/exynos-gsc/gsc-core.c b/drivers/media/video/exynos-gsc/gsc-core.c
new file mode 100644
index 0000000..defd14d
--- /dev/null
+++ b/drivers/media/video/exynos-gsc/gsc-core.c
@@ -0,0 +1,1263 @@
+/*
+ * Copyright (c) 2011 - 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Samsung EXYNOS5 SoC series G-Scaler driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation, either version 2 of the License,
+ * or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/bug.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/list.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/of.h>
+#include <media/v4l2-ioctl.h>
+
+#include "gsc-core.h"
+
+#define GSC_CLOCK_GATE_NAME	"gscl"
+
+static const struct gsc_fmt gsc_formats[] = {
+	{
+		.name		= "RGB565",
+		.pixelformat	= V4L2_PIX_FMT_RGB565X,
+		.depth		= { 16 },
+		.color		= GSC_RGB,
+		.num_planes	= 1,
+		.num_comp	= 1,
+	}, {
+		.name		= "XRGB-8-8-8-8, 32 bpp",
+		.pixelformat	= V4L2_PIX_FMT_RGB32,
+		.depth		= { 32 },
+		.color		= GSC_RGB,
+		.num_planes	= 1,
+		.num_comp	= 1,
+	}, {
+		.name		= "YUV 4:2:2 packed, YCbYCr",
+		.pixelformat	= V4L2_PIX_FMT_YUYV,
+		.depth		= { 16 },
+		.color		= GSC_YUV422,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CBCR,
+		.num_planes	= 1,
+		.num_comp	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
+	}, {
+		.name		= "YUV 4:2:2 packed, CbYCrY",
+		.pixelformat	= V4L2_PIX_FMT_UYVY,
+		.depth		= { 16 },
+		.color		= GSC_YUV422,
+		.yorder		= GSC_LSB_C,
+		.corder		= GSC_CBCR,
+		.num_planes	= 1,
+		.num_comp	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_UYVY8_2X8,
+	}, {
+		.name		= "YUV 4:2:2 packed, CrYCbY",
+		.pixelformat	= V4L2_PIX_FMT_VYUY,
+		.depth		= { 16 },
+		.color		= GSC_YUV422,
+		.yorder		= GSC_LSB_C,
+		.corder		= GSC_CRCB,
+		.num_planes	= 1,
+		.num_comp	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_VYUY8_2X8,
+	}, {
+		.name		= "YUV 4:2:2 packed, YCrYCb",
+		.pixelformat	= V4L2_PIX_FMT_YVYU,
+		.depth		= { 16 },
+		.color		= GSC_YUV422,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CRCB,
+		.num_planes	= 1,
+		.num_comp	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_YVYU8_2X8,
+	}, {
+		.name		= "YUV 4:4:4 planar, YCbYCr",
+		.pixelformat	= V4L2_PIX_FMT_YUV32,
+		.depth		= { 32 },
+		.color		= GSC_YUV444,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CBCR,
+		.num_planes	= 1,
+		.num_comp	= 1,
+	}, {
+		.name		= "YUV 4:2:2 planar, Y/Cb/Cr",
+		.pixelformat	= V4L2_PIX_FMT_YUV422P,
+		.depth		= { 16 },
+		.color		= GSC_YUV422,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CBCR,
+		.num_planes	= 1,
+		.num_comp	= 3,
+	}, {
+		.name		= "YUV 4:2:2 planar, Y/CbCr",
+		.pixelformat	= V4L2_PIX_FMT_NV16,
+		.depth		= { 16 },
+		.color		= GSC_YUV422,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CBCR,
+		.num_planes	= 1,
+		.num_comp	= 2,
+	}, {
+		.name		= "YUV 4:2:2 planar, Y/CrCb",
+		.pixelformat	= V4L2_PIX_FMT_NV61,
+		.depth		= { 16 },
+		.color		= GSC_YUV422,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CRCB,
+		.num_planes	= 1,
+		.num_comp	= 2,
+	}, {
+		.name		= "YUV 4:2:0 planar, YCbCr",
+		.pixelformat	= V4L2_PIX_FMT_YUV420,
+		.depth		= { 12 },
+		.color		= GSC_YUV420,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CBCR,
+		.num_planes	= 1,
+		.num_comp	= 3,
+	}, {
+		.name		= "YUV 4:2:0 planar, YCrCb",
+		.pixelformat	= V4L2_PIX_FMT_YVU420,
+		.depth		= { 12 },
+		.color		= GSC_YUV420,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CRCB,
+		.num_planes	= 1,
+		.num_comp	= 3,
+
+	}, {
+		.name		= "YUV 4:2:0 planar, Y/CbCr",
+		.pixelformat	= V4L2_PIX_FMT_NV12,
+		.depth		= { 12 },
+		.color		= GSC_YUV420,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CBCR,
+		.num_planes	= 1,
+		.num_comp	= 2,
+	}, {
+		.name		= "YUV 4:2:0 planar, Y/CrCb",
+		.pixelformat	= V4L2_PIX_FMT_NV21,
+		.depth		= { 12 },
+		.color		= GSC_YUV420,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CRCB,
+		.num_planes	= 1,
+		.num_comp	= 2,
+	}, {
+		.name		= "YUV 4:2:0 non-contig. 2p, Y/CbCr",
+		.pixelformat	= V4L2_PIX_FMT_NV12M,
+		.depth		= { 8, 4 },
+		.color		= GSC_YUV420,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CBCR,
+		.num_planes	= 2,
+		.num_comp	= 2,
+	}, {
+		.name		= "YUV 4:2:0 non-contig. 3p, Y/Cb/Cr",
+		.pixelformat	= V4L2_PIX_FMT_YUV420M,
+		.depth		= { 8, 2, 2 },
+		.color		= GSC_YUV420,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CBCR,
+		.num_planes	= 3,
+		.num_comp	= 3,
+	}, {
+		.name		= "YUV 4:2:0 non-contig. 3p, Y/Cr/Cb",
+		.pixelformat	= V4L2_PIX_FMT_YVU420M,
+		.depth		= { 8, 2, 2 },
+		.color		= GSC_YUV420,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CRCB,
+		.num_planes	= 3,
+		.num_comp	= 3,
+	}, {
+		.name		= "YUV 4:2:0 non-contig. 2p, tiled",
+		.pixelformat	= V4L2_PIX_FMT_NV12MT_16X16,
+		.depth		= { 8, 4 },
+		.color		= GSC_YUV420,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CBCR,
+		.num_planes	= 2,
+		.num_comp	= 2,
+	},
+};
+
+const struct gsc_fmt *get_format(int index)
+{
+	if (index >= ARRAY_SIZE(gsc_formats))
+		return NULL;
+
+	return (struct gsc_fmt *)&gsc_formats[index];
+}
+
+const struct gsc_fmt *find_fmt(u32 *pixelformat, u32 *mbus_code, u32 index)
+{
+	const struct gsc_fmt *fmt, *def_fmt = NULL;
+	unsigned int i;
+
+	if (index >= ARRAY_SIZE(gsc_formats))
+		return NULL;
+
+	for (i = 0; i < ARRAY_SIZE(gsc_formats); ++i) {
+		fmt = get_format(i);
+		if (pixelformat && fmt->pixelformat == *pixelformat)
+			return fmt;
+		if (mbus_code && fmt->mbus_code == *mbus_code)
+			return fmt;
+		if (index == i)
+			def_fmt = fmt;
+	}
+	return def_fmt;
+
+}
+
+void gsc_set_frame_size(struct gsc_frame *frame, int width, int height)
+{
+	frame->f_width	= width;
+	frame->f_height	= height;
+	frame->crop.width = width;
+	frame->crop.height = height;
+	frame->crop.left = 0;
+	frame->crop.top = 0;
+}
+
+int gsc_cal_prescaler_ratio(struct gsc_variant *var, u32 src, u32 dst,
+								u32 *ratio)
+{
+	if ((dst > src) || (dst >= src / var->poly_sc_down_max)) {
+		*ratio = 1;
+		return 0;
+	}
+
+	if ((src / var->poly_sc_down_max / var->pre_sc_down_max) > dst) {
+		pr_err("Exceeded maximum downscaling ratio (1/16))");
+		return -EINVAL;
+	}
+
+	*ratio = (dst > (src / 8)) ? 2 : 4;
+
+	return 0;
+}
+
+void gsc_get_prescaler_shfactor(u32 hratio, u32 vratio, u32 *sh)
+{
+	if (hratio == 4 && vratio == 4)
+		*sh = 4;
+	else if ((hratio == 4 && vratio == 2) ||
+		 (hratio == 2 && vratio == 4))
+		*sh = 3;
+	else if ((hratio == 4 && vratio == 1) ||
+		 (hratio == 1 && vratio == 4) ||
+		 (hratio == 2 && vratio == 2))
+		*sh = 2;
+	else if (hratio == 1 && vratio == 1)
+		*sh = 0;
+	else
+		*sh = 1;
+}
+
+void gsc_check_src_scale_info(struct gsc_variant *var,
+				struct gsc_frame *s_frame, u32 *wratio,
+				 u32 tx, u32 ty, u32 *hratio)
+{
+	int remainder = 0, walign, halign;
+
+	if (is_yuv420(s_frame->fmt->color)) {
+		walign = GSC_SC_ALIGN_4;
+		halign = GSC_SC_ALIGN_4;
+	} else if (is_yuv422(s_frame->fmt->color)) {
+		walign = GSC_SC_ALIGN_4;
+		halign = GSC_SC_ALIGN_2;
+	} else {
+		walign = GSC_SC_ALIGN_2;
+		halign = GSC_SC_ALIGN_2;
+	}
+
+	remainder = s_frame->crop.width % (*wratio * walign);
+	if (remainder) {
+		s_frame->crop.width -= remainder;
+		gsc_cal_prescaler_ratio(var, s_frame->crop.width, tx, wratio);
+		pr_info("cropped src width size is recalculated from %d to %d",
+			s_frame->crop.width + remainder, s_frame->crop.width);
+	}
+
+	remainder = s_frame->crop.height % (*hratio * halign);
+	if (remainder) {
+		s_frame->crop.height -= remainder;
+		gsc_cal_prescaler_ratio(var, s_frame->crop.height, ty, hratio);
+		pr_info("cropped src height size is recalculated from %d to %d",
+			s_frame->crop.height + remainder, s_frame->crop.height);
+	}
+}
+
+int gsc_enum_fmt_mplane(struct v4l2_fmtdesc *f)
+{
+	const struct gsc_fmt *fmt;
+
+	fmt = find_fmt(NULL, NULL, f->index);
+	if (!fmt)
+		return -EINVAL;
+
+	strlcpy(f->description, fmt->name, sizeof(f->description));
+	f->pixelformat = fmt->pixelformat;
+
+	return 0;
+}
+
+u32 get_plane_info(struct gsc_frame *frm, u32 addr, u32 *index)
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
+	} else {
+		pr_err("Plane address is wrong");
+		return -EINVAL;
+	}
+}
+
+void gsc_set_prefbuf(struct gsc_dev *gsc, struct gsc_frame *frm)
+{
+	u32 f_chk_addr, f_chk_len, s_chk_addr, s_chk_len;
+	f_chk_addr = f_chk_len = s_chk_addr = s_chk_len = 0;
+
+	f_chk_addr = frm->addr.y;
+	f_chk_len = frm->payload[0];
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
+	pr_debug("f_addr = 0x%08x, f_len = %d, s_addr = 0x%08x, s_len = %d\n",
+			f_chk_addr, f_chk_len, s_chk_addr, s_chk_len);
+}
+
+int gsc_try_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f)
+{
+	struct gsc_dev *gsc = ctx->gsc_dev;
+	struct gsc_variant *variant = gsc->variant;
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	const struct gsc_fmt *fmt;
+	u32 max_w, max_h, mod_x, mod_y;
+	u32 min_w, min_h, tmp_w, tmp_h;
+	int i;
+
+	pr_debug("user put w: %d, h: %d", pix_mp->width, pix_mp->height);
+
+	fmt = find_fmt(&pix_mp->pixelformat, NULL, 0);
+	if (!fmt) {
+		pr_err("pixelformat format (0x%X) invalid\n",
+						pix_mp->pixelformat);
+		return -EINVAL;
+	}
+
+	if (pix_mp->field == V4L2_FIELD_ANY)
+		pix_mp->field = V4L2_FIELD_NONE;
+	else if (pix_mp->field != V4L2_FIELD_NONE) {
+		pr_err("Not supported field order(%d)\n", pix_mp->field);
+		return -EINVAL;
+	}
+
+	max_w = variant->pix_max->target_rot_dis_w;
+	max_h = variant->pix_max->target_rot_dis_h;
+
+	mod_x = ffs(variant->pix_align->org_w) - 1;
+	if (is_yuv420(fmt->color))
+		mod_y = ffs(variant->pix_align->org_h) - 1;
+	else
+		mod_y = ffs(variant->pix_align->org_h) - 2;
+
+	if (V4L2_TYPE_IS_OUTPUT(f->type)) {
+		min_w = variant->pix_min->org_w;
+		min_h = variant->pix_min->org_h;
+	} else {
+		min_w = variant->pix_min->target_rot_dis_w;
+		min_h = variant->pix_min->target_rot_dis_h;
+	}
+
+	pr_debug("mod_x: %d, mod_y: %d, max_w: %d, max_h = %d",
+			mod_x, mod_y, max_w, max_h);
+
+	/* To check if image size is modified to adjust parameter against
+	   hardware abilities */
+	tmp_w = pix_mp->width;
+	tmp_h = pix_mp->height;
+
+	v4l_bound_align_image(&pix_mp->width, min_w, max_w, mod_x,
+		&pix_mp->height, min_h, max_h, mod_y, 0);
+	if (tmp_w != pix_mp->width || tmp_h != pix_mp->height)
+		pr_info("Image size has been modified from %dx%d to %dx%d",
+			 tmp_w, tmp_h, pix_mp->width, pix_mp->height);
+
+	pix_mp->num_planes = fmt->num_planes;
+
+	if (pix_mp->width >= 1280) /* HD */
+		pix_mp->colorspace = V4L2_COLORSPACE_REC709;
+	else /* SD */
+		pix_mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
+
+
+	for (i = 0; i < pix_mp->num_planes; ++i) {
+		int bpl = (pix_mp->width * fmt->depth[i]) >> 3;
+		pix_mp->plane_fmt[i].bytesperline = bpl;
+		pix_mp->plane_fmt[i].sizeimage = bpl * pix_mp->height;
+
+		pr_debug("[%d]: bpl: %d, sizeimage: %d",
+				i, bpl, pix_mp->plane_fmt[i].sizeimage);
+	}
+
+	return 0;
+}
+
+int gsc_g_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f)
+{
+	struct gsc_frame *frame;
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
+void gsc_check_crop_change(u32 tmp_w, u32 tmp_h, u32 *w, u32 *h)
+{
+	if (tmp_w != *w || tmp_h != *h) {
+		pr_info("Cropped size has been modified from %dx%d to %dx%d",
+							*w, *h, tmp_w, tmp_h);
+		*w = tmp_w;
+		*h = tmp_h;
+	}
+}
+
+int gsc_g_crop(struct gsc_ctx *ctx, struct v4l2_crop *cr)
+{
+	struct gsc_frame *frame;
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
+int gsc_try_crop(struct gsc_ctx *ctx, struct v4l2_crop *cr)
+{
+	struct gsc_frame *f;
+	struct gsc_dev *gsc = ctx->gsc_dev;
+	struct gsc_variant *variant = gsc->variant;
+	u32 mod_x = 0, mod_y = 0, tmp_w, tmp_h;
+	u32 min_w, min_h, max_w, max_h;
+
+	if (cr->c.top < 0 || cr->c.left < 0) {
+		pr_err("doesn't support negative values for top & left\n");
+		return -EINVAL;
+	}
+	pr_debug("user put w: %d, h: %d", cr->c.width, cr->c.height);
+
+	if (cr->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		f = &ctx->d_frame;
+	else if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		f = &ctx->s_frame;
+	else
+		return -EINVAL;
+
+	max_w = f->f_width;
+	max_h = f->f_height;
+	tmp_w = cr->c.width;
+	tmp_h = cr->c.height;
+
+	if (V4L2_TYPE_IS_OUTPUT(cr->type)) {
+		if ((is_yuv422(f->fmt->color) && f->fmt->num_comp == 1) ||
+		    is_rgb(f->fmt->color))
+			min_w = 32;
+		else
+			min_w = 64;
+		if ((is_yuv422(f->fmt->color) && f->fmt->num_comp == 3) ||
+		    is_yuv420(f->fmt->color))
+			min_h = 32;
+		else
+			min_h = 16;
+	} else {
+		if (is_yuv420(f->fmt->color) || is_yuv422(f->fmt->color))
+			mod_x = ffs(variant->pix_align->target_w) - 1;
+		if (is_yuv420(f->fmt->color))
+			mod_y = ffs(variant->pix_align->target_h) - 1;
+		if (ctx->gsc_ctrls.rotate->val == 90 ||
+		    ctx->gsc_ctrls.rotate->val == 270) {
+			max_w = f->f_height;
+			max_h = f->f_width;
+			min_w = variant->pix_min->target_rot_en_w;
+			min_h = variant->pix_min->target_rot_en_h;
+			tmp_w = cr->c.height;
+			tmp_h = cr->c.width;
+		} else {
+			min_w = variant->pix_min->target_rot_dis_w;
+			min_h = variant->pix_min->target_rot_dis_h;
+		}
+	}
+	pr_debug("mod_x: %d, mod_y: %d, min_w: %d, min_h = %d",
+					mod_x, mod_y, min_w, min_h);
+	pr_debug("tmp_w : %d, tmp_h : %d", tmp_w, tmp_h);
+
+	v4l_bound_align_image(&tmp_w, min_w, max_w, mod_x,
+			      &tmp_h, min_h, max_h, mod_y, 0);
+
+	if (!V4L2_TYPE_IS_OUTPUT(cr->type) &&
+		(ctx->gsc_ctrls.rotate->val == 90 ||
+		ctx->gsc_ctrls.rotate->val == 270))
+		gsc_check_crop_change(tmp_h, tmp_w,
+					&cr->c.width, &cr->c.height);
+	else
+		gsc_check_crop_change(tmp_w, tmp_h,
+					&cr->c.width, &cr->c.height);
+
+
+	/* adjust left/top if cropping rectangle is out of bounds */
+	/* Need to add code to algin left value with 2's multiple */
+	if (cr->c.left + tmp_w > max_w)
+		cr->c.left = max_w - tmp_w;
+	if (cr->c.top + tmp_h > max_h)
+		cr->c.top = max_h - tmp_h;
+
+	if ((is_yuv420(f->fmt->color) || is_yuv422(f->fmt->color)) &&
+		cr->c.left & 1)
+			cr->c.left -= 1;
+
+	pr_debug("Aligned l:%d, t:%d, w:%d, h:%d, f_w: %d, f_h: %d",
+	    cr->c.left, cr->c.top, cr->c.width, cr->c.height, max_w, max_h);
+
+	return 0;
+}
+
+int gsc_check_scaler_ratio(struct gsc_variant *var, int sw, int sh, int dw,
+			   int dh, int rot, int out_path)
+{
+	int tmp_w, tmp_h, sc_down_max;
+
+	if (out_path == GSC_DMA)
+		sc_down_max = var->sc_down_max;
+	else
+		sc_down_max = var->local_sc_down;
+
+	if (rot == 90 || rot == 270) {
+		tmp_w = dh;
+		tmp_h = dw;
+	} else {
+		tmp_w = dw;
+		tmp_h = dh;
+	}
+
+	if ((sw / tmp_w) > sc_down_max ||
+	    (sh / tmp_h) > sc_down_max ||
+	    (tmp_w / sw) > var->sc_up_max ||
+	    (tmp_h / sh) > var->sc_up_max)
+		return -EINVAL;
+
+	return 0;
+}
+
+int gsc_set_scaler_info(struct gsc_ctx *ctx)
+{
+	struct gsc_scaler *sc = &ctx->scaler;
+	struct gsc_frame *s_frame = &ctx->s_frame;
+	struct gsc_frame *d_frame = &ctx->d_frame;
+	struct gsc_variant *variant = ctx->gsc_dev->variant;
+	struct device *dev = &ctx->gsc_dev->pdev->dev;
+	int tx, ty;
+	int ret;
+
+	ret = gsc_check_scaler_ratio(variant, s_frame->crop.width,
+		s_frame->crop.height, d_frame->crop.width, d_frame->crop.height,
+		ctx->gsc_ctrls.rotate->val, ctx->out_path);
+	if (ret) {
+		pr_err("out of scaler range");
+		return ret;
+	}
+
+	if (ctx->gsc_ctrls.rotate->val == 90 ||
+	    ctx->gsc_ctrls.rotate->val == 270) {
+		ty = d_frame->crop.width;
+		tx = d_frame->crop.height;
+	} else {
+		tx = d_frame->crop.width;
+		ty = d_frame->crop.height;
+	}
+
+	if (tx <= 0 || ty <= 0) {
+		dev_err(dev, "Invalid target size: %dx%d", tx, ty);
+		return -EINVAL;
+	}
+
+	ret = gsc_cal_prescaler_ratio(variant, s_frame->crop.width,
+				      tx, &sc->pre_hratio);
+	if (ret) {
+		pr_err("Horizontal scale ratio is out of range");
+		return ret;
+	}
+
+	ret = gsc_cal_prescaler_ratio(variant, s_frame->crop.height,
+				      ty, &sc->pre_vratio);
+	if (ret) {
+		pr_err("Vertical scale ratio is out of range");
+		return ret;
+	}
+
+	gsc_check_src_scale_info(variant, s_frame, &sc->pre_hratio,
+				 tx, ty, &sc->pre_vratio);
+
+	gsc_get_prescaler_shfactor(sc->pre_hratio, sc->pre_vratio,
+				   &sc->pre_shfactor);
+
+	sc->main_hratio = (s_frame->crop.width << 16) / tx;
+	sc->main_vratio = (s_frame->crop.height << 16) / ty;
+
+	pr_debug("scaler input/output size : sx = %d, sy = %d, tx = %d, ty = %d",
+			s_frame->crop.width, s_frame->crop.height, tx, ty);
+	pr_debug("scaler ratio info : pre_shfactor : %d, pre_h : %d",
+			sc->pre_shfactor, sc->pre_hratio);
+	pr_debug("pre_v :%d, main_h : %d, main_v : %d",
+			sc->pre_vratio, sc->main_hratio, sc->main_vratio);
+
+	return 0;
+}
+
+static int __gsc_s_ctrl(struct gsc_ctx *ctx, struct v4l2_ctrl *ctrl)
+{
+	struct gsc_dev *gsc = ctx->gsc_dev;
+	struct gsc_variant *variant = gsc->variant;
+	unsigned int flags = GSC_DST_FMT | GSC_SRC_FMT;
+	int ret = 0;
+
+	if (ctrl->flags & V4L2_CTRL_FLAG_INACTIVE)
+		return 0;
+
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
+		if ((ctx->state & flags) == flags) {
+			ret = gsc_check_scaler_ratio(variant,
+					ctx->s_frame.crop.width,
+					ctx->s_frame.crop.height,
+					ctx->d_frame.crop.width,
+					ctx->d_frame.crop.height,
+					ctx->gsc_ctrls.rotate->val,
+					ctx->out_path);
+
+			if (ret)
+				return -EINVAL;
+		}
+
+		ctx->rotation = ctrl->val;
+		break;
+
+	case V4L2_CID_ALPHA_COMPONENT:
+		ctx->d_frame.alpha = ctrl->val;
+		break;
+	}
+
+	ctx->state |= GSC_PARAMS;
+	return 0;
+}
+
+static int gsc_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct gsc_ctx *ctx = ctrl_to_ctx(ctrl);
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&ctx->gsc_dev->slock, flags);
+	ret = __gsc_s_ctrl(ctx, ctrl);
+	spin_unlock_irqrestore(&ctx->gsc_dev->slock, flags);
+
+	return ret;
+}
+
+const struct v4l2_ctrl_ops gsc_ctrl_ops = {
+	.s_ctrl = gsc_s_ctrl,
+};
+
+int gsc_ctrls_create(struct gsc_ctx *ctx)
+{
+	if (ctx->ctrls_rdy) {
+		pr_err("Control handler of this context was created already");
+		return 0;
+	}
+
+	v4l2_ctrl_handler_init(&ctx->ctrl_handler, GSC_MAX_CTRL_NUM);
+
+	ctx->gsc_ctrls.rotate = v4l2_ctrl_new_std(&ctx->ctrl_handler,
+				&gsc_ctrl_ops, V4L2_CID_ROTATE, 0, 270, 90, 0);
+	ctx->gsc_ctrls.hflip = v4l2_ctrl_new_std(&ctx->ctrl_handler,
+				&gsc_ctrl_ops, V4L2_CID_HFLIP, 0, 1, 1, 0);
+	ctx->gsc_ctrls.vflip = v4l2_ctrl_new_std(&ctx->ctrl_handler,
+				&gsc_ctrl_ops, V4L2_CID_VFLIP, 0, 1, 1, 0);
+	ctx->gsc_ctrls.global_alpha = v4l2_ctrl_new_std(&ctx->ctrl_handler,
+			&gsc_ctrl_ops, V4L2_CID_ALPHA_COMPONENT, 0, 255, 1, 0);
+
+	ctx->ctrls_rdy = ctx->ctrl_handler.error == 0;
+
+	if (ctx->ctrl_handler.error) {
+		int err = ctx->ctrl_handler.error;
+		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+		pr_err("Failed to create G-Scaler control handlers");
+		return err;
+	}
+
+	return 0;
+}
+
+void gsc_ctrls_delete(struct gsc_ctx *ctx)
+{
+	if (ctx->ctrls_rdy) {
+		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+		ctx->ctrls_rdy = false;
+	}
+}
+
+/* The color format (num_comp, num_planes) must be already configured. */
+int gsc_prepare_addr(struct gsc_ctx *ctx, struct vb2_buffer *vb,
+			struct gsc_frame *frame, struct gsc_addr *addr)
+{
+	int ret = 0;
+	u32 pix_size;
+
+	if ((vb == NULL) || (frame == NULL))
+		return -EINVAL;
+
+	pix_size = frame->f_width * frame->f_height;
+
+	pr_debug("num_planes= %d, num_comp= %d, pix_size= %d",
+		frame->fmt->num_planes, frame->fmt->num_comp, pix_size);
+
+	addr->y = vb2_dma_contig_plane_dma_addr(vb, 0);
+
+	if (frame->fmt->num_planes == 1) {
+		switch (frame->fmt->num_comp) {
+		case 1:
+			addr->cb = 0;
+			addr->cr = 0;
+			break;
+		case 2:
+			/* decompose Y into Y/Cb */
+			addr->cb = (dma_addr_t)(addr->y + pix_size);
+			addr->cr = 0;
+			break;
+		case 3:
+			/* decompose Y into Y/Cb/Cr */
+			addr->cb = (dma_addr_t)(addr->y + pix_size);
+			if (GSC_YUV420 == frame->fmt->color)
+				addr->cr = (dma_addr_t)(addr->cb
+						+ (pix_size >> 2));
+			else /* 422 */
+				addr->cr = (dma_addr_t)(addr->cb
+						+ (pix_size >> 1));
+			break;
+		default:
+			pr_err("Invalid the number of color planes");
+			return -EINVAL;
+		}
+	} else {
+		if (frame->fmt->num_planes >= 2)
+			addr->cb = vb2_dma_contig_plane_dma_addr(vb, 1);
+
+		if (frame->fmt->num_planes == 3)
+			addr->cr = vb2_dma_contig_plane_dma_addr(vb, 2);
+	}
+
+	if ((frame->fmt->pixelformat == V4L2_PIX_FMT_VYUY) ||
+		(frame->fmt->pixelformat == V4L2_PIX_FMT_YVYU) ||
+		(frame->fmt->pixelformat == V4L2_PIX_FMT_NV61) ||
+		(frame->fmt->pixelformat == V4L2_PIX_FMT_YVU420) ||
+		(frame->fmt->pixelformat == V4L2_PIX_FMT_NV21) ||
+		(frame->fmt->pixelformat == V4L2_PIX_FMT_YVU420M))
+		swap(addr->cb, addr->cr);
+
+	pr_debug("ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d",
+		addr->y, addr->cb, addr->cr, ret);
+
+	return ret;
+}
+
+static irqreturn_t gsc_irq_handler(int irq, void *priv)
+{
+	struct gsc_dev *gsc = priv;
+	struct gsc_ctx *ctx;
+	int gsc_irq;
+
+	gsc_irq = gsc_hw_get_irq_status(gsc);
+	gsc_hw_clear_irq(gsc, gsc_irq);
+
+	if (gsc_irq == GSC_IRQ_OVERRUN) {
+		pr_err("Local path input over-run interrupt has occurred!\n");
+		return IRQ_HANDLED;
+	}
+
+	spin_lock(&gsc->slock);
+
+	if (test_and_clear_bit(ST_M2M_PEND, &gsc->state)) {
+
+		gsc_hw_enable_control(gsc, false);
+
+		if (test_and_clear_bit(ST_M2M_SUSPENDING, &gsc->state)) {
+			set_bit(ST_M2M_SUSPENDED, &gsc->state);
+			wake_up(&gsc->irq_queue);
+			goto isr_unlock;
+		}
+		ctx = v4l2_m2m_get_curr_priv(gsc->m2m.m2m_dev);
+
+		if (!ctx || !ctx->m2m_ctx)
+			goto isr_unlock;
+
+		spin_unlock(&gsc->slock);
+		gsc_m2m_job_finish(ctx, VB2_BUF_STATE_DONE);
+
+		/* wake_up job_abort, stop_streaming */
+		if (ctx->state & GSC_CTX_STOP_REQ) {
+			ctx->state &= ~GSC_CTX_STOP_REQ;
+			wake_up(&gsc->irq_queue);
+		}
+		return IRQ_HANDLED;
+	}
+
+isr_unlock:
+	spin_unlock(&gsc->slock);
+	return IRQ_HANDLED;
+}
+
+static struct gsc_pix_max gsc_v_100_max = {
+	.org_scaler_bypass_w	= 8192,
+	.org_scaler_bypass_h	= 8192,
+	.org_scaler_input_w	= 4800,
+	.org_scaler_input_h	= 3344,
+	.real_rot_dis_w		= 4800,
+	.real_rot_dis_h		= 3344,
+	.real_rot_en_w		= 2047,
+	.real_rot_en_h		= 2047,
+	.target_rot_dis_w	= 4800,
+	.target_rot_dis_h	= 3344,
+	.target_rot_en_w	= 2016,
+	.target_rot_en_h	= 2016,
+};
+
+static struct gsc_pix_min gsc_v_100_min = {
+	.org_w			= 64,
+	.org_h			= 32,
+	.real_w			= 64,
+	.real_h			= 32,
+	.target_rot_dis_w	= 64,
+	.target_rot_dis_h	= 32,
+	.target_rot_en_w	= 32,
+	.target_rot_en_h	= 16,
+};
+
+static struct gsc_pix_align gsc_v_100_align = {
+	.org_h			= 16,
+	.org_w			= 16, /* yuv420 : 16, others : 8 */
+	.offset_h		= 2,  /* yuv420/422 : 2, others : 1 */
+	.real_w			= 16, /* yuv420/422 : 4~16, others : 2~8 */
+	.real_h			= 16, /* yuv420 : 4~16, others : 1 */
+	.target_w		= 2,  /* yuv420/422 : 2, others : 1 */
+	.target_h		= 2,  /* yuv420 : 2, others : 1 */
+};
+
+static struct gsc_variant gsc_v_100_variant = {
+	.pix_max		= &gsc_v_100_max,
+	.pix_min		= &gsc_v_100_min,
+	.pix_align		= &gsc_v_100_align,
+	.in_buf_cnt		= 8,
+	.out_buf_cnt		= 16,
+	.sc_up_max		= 8,
+	.sc_down_max		= 16,
+	.poly_sc_down_max	= 4,
+	.pre_sc_down_max	= 4,
+	.local_sc_down		= 2,
+};
+
+static struct gsc_driverdata gsc_v_100_drvdata = {
+	.variant = {
+		[0] = &gsc_v_100_variant,
+		[1] = &gsc_v_100_variant,
+		[2] = &gsc_v_100_variant,
+		[3] = &gsc_v_100_variant,
+	},
+	.num_entities = 4,
+	.lclk_frequency = 266000000UL,
+};
+
+static struct platform_device_id gsc_driver_ids[] = {
+	{
+		.name		= "exynos-gsc",
+		.driver_data	= (unsigned long)&gsc_v_100_drvdata,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(platform, gsc_driver_ids);
+
+static const struct of_device_id exynos_gsc_match[] = {
+	{ .compatible = "samsung,exynos5250-gsc",
+	.data = &gsc_v_100_drvdata, },
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos_gsc_match);
+
+static void *gsc_get_drv_data(struct platform_device *pdev)
+{
+	struct gsc_driverdata *driver_data = NULL;
+
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_node(of_match_ptr(exynos_gsc_match),
+					pdev->dev.of_node);
+		if (match)
+			driver_data =  match->data;
+	} else {
+		driver_data = (struct gsc_driverdata *)
+			platform_get_device_id(pdev)->driver_data;
+	}
+
+	return driver_data;
+}
+
+static void gsc_clk_put(struct gsc_dev *gsc)
+{
+	if (IS_ERR_OR_NULL(gsc->clock))
+		return;
+
+	clk_unprepare(gsc->clock);
+	clk_put(gsc->clock);
+	gsc->clock = NULL;
+}
+
+static int gsc_clk_get(struct gsc_dev *gsc)
+{
+	int ret;
+
+	dev_dbg(&gsc->pdev->dev, "gsc_clk_get Called\n");
+
+	gsc->clock = clk_get(&gsc->pdev->dev, GSC_CLOCK_GATE_NAME);
+	if (IS_ERR(gsc->clock))
+		goto err_print;
+
+	ret = clk_prepare(gsc->clock);
+	if (ret < 0) {
+		clk_put(gsc->clock);
+		gsc->clock = NULL;
+		goto err;
+	}
+
+	return 0;
+
+err:
+	dev_err(&gsc->pdev->dev, "clock prepare failed for clock: %s\n",
+					GSC_CLOCK_GATE_NAME);
+	gsc_clk_put(gsc);
+err_print:
+	dev_err(&gsc->pdev->dev, "failed to get clock~~~: %s\n",
+					GSC_CLOCK_GATE_NAME);
+	return -ENXIO;
+}
+
+static int gsc_m2m_suspend(struct gsc_dev *gsc)
+{
+	unsigned long flags;
+	int timeout;
+
+	spin_lock_irqsave(&gsc->slock, flags);
+	if (!gsc_m2m_pending(gsc)) {
+		spin_unlock_irqrestore(&gsc->slock, flags);
+		return 0;
+	}
+	clear_bit(ST_M2M_SUSPENDED, &gsc->state);
+	set_bit(ST_M2M_SUSPENDING, &gsc->state);
+	spin_unlock_irqrestore(&gsc->slock, flags);
+
+	timeout = wait_event_timeout(gsc->irq_queue,
+			     test_bit(ST_M2M_SUSPENDED, &gsc->state),
+			     GSC_SHUTDOWN_TIMEOUT);
+
+	clear_bit(ST_M2M_SUSPENDING, &gsc->state);
+	return timeout == 0 ? -EAGAIN : 0;
+}
+
+static int gsc_m2m_resume(struct gsc_dev *gsc)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&gsc->slock, flags);
+	/* Clear for full H/W setup in first run after resume */
+	gsc->m2m.ctx = NULL;
+	spin_unlock_irqrestore(&gsc->slock, flags);
+
+	if (test_and_clear_bit(ST_M2M_SUSPENDED, &gsc->state))
+		gsc_m2m_job_finish(gsc->m2m.ctx,
+				    VB2_BUF_STATE_ERROR);
+	return 0;
+}
+
+static int gsc_probe(struct platform_device *pdev)
+{
+	struct gsc_dev *gsc;
+	struct resource *res;
+	struct gsc_driverdata *drv_data = gsc_get_drv_data(pdev);
+	struct device *dev = &pdev->dev;
+	int ret = 0;
+
+	gsc = devm_kzalloc(dev, sizeof(struct gsc_dev), GFP_KERNEL);
+	if (!gsc)
+		return -ENOMEM;
+
+	if (dev->of_node)
+		gsc->id = of_alias_get_id(pdev->dev.of_node, "gsc");
+	else
+		gsc->id = pdev->id;
+
+	if (gsc->id < 0 || gsc->id >= drv_data->num_entities) {
+		dev_err(dev, "Invalid platform device id: %d\n", gsc->id);
+		return -EINVAL;
+	}
+
+	pdev->id = gsc->id;
+	gsc->variant = drv_data->variant[gsc->id];
+	gsc->pdev = pdev;
+	gsc->pdata = dev->platform_data;
+
+	init_waitqueue_head(&gsc->irq_queue);
+	spin_lock_init(&gsc->slock);
+	mutex_init(&gsc->lock);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	gsc->regs = devm_request_and_ioremap(dev, res);
+	if (!gsc->regs) {
+		dev_err(dev, "failed to map registers\n");
+		return -ENOENT;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		dev_err(dev, "failed to get IRQ resource\n");
+		return -ENXIO;
+	}
+
+	ret = gsc_clk_get(gsc);
+	if (ret)
+		return ret;
+
+	ret = devm_request_irq(dev, res->start, gsc_irq_handler,
+				0, pdev->name, gsc);
+	if (ret) {
+		dev_err(dev, "failed to install irq (%d)\n", ret);
+		goto err_clk;
+	}
+
+	ret = gsc_register_m2m_device(gsc);
+	if (ret)
+		goto err_clk;
+
+	platform_set_drvdata(pdev, gsc);
+	pm_runtime_enable(dev);
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (ret < 0)
+		goto err_m2m;
+
+	/* Initialize continious memory allocator */
+	gsc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
+	if (IS_ERR(gsc->alloc_ctx)) {
+		ret = PTR_ERR(gsc->alloc_ctx);
+		goto err_pm;
+	}
+
+	dev_dbg(dev, "gsc-%d registered successfully\n", gsc->id);
+
+	pm_runtime_put(dev);
+	return 0;
+err_pm:
+	pm_runtime_put(dev);
+err_m2m:
+	gsc_unregister_m2m_device(gsc);
+err_clk:
+	gsc_clk_put(gsc);
+	return ret;
+}
+
+static int __devexit gsc_remove(struct platform_device *pdev)
+{
+	struct gsc_dev *gsc = platform_get_drvdata(pdev);
+
+	gsc_unregister_m2m_device(gsc);
+
+	vb2_dma_contig_cleanup_ctx(gsc->alloc_ctx);
+	pm_runtime_disable(&pdev->dev);
+
+	dev_dbg(&pdev->dev, "%s driver unloaded\n", pdev->name);
+	return 0;
+}
+
+static int gsc_runtime_resume(struct device *dev)
+{
+	struct gsc_dev *gsc = dev_get_drvdata(dev);
+	int ret = 0;
+
+	pr_debug("gsc%d: state: 0x%lx", gsc->id, gsc->state);
+
+	ret = clk_enable(gsc->clock);
+	if (ret)
+		return ret;
+
+	gsc_hw_set_sw_reset(gsc);
+	gsc_wait_reset(gsc);
+
+	return gsc_m2m_resume(gsc);
+}
+
+static int gsc_runtime_suspend(struct device *dev)
+{
+	struct gsc_dev *gsc = dev_get_drvdata(dev);
+	int ret = 0;
+
+	ret = gsc_m2m_suspend(gsc);
+	if (!ret)
+		clk_disable(gsc->clock);
+
+	pr_debug("gsc%d: state: 0x%lx", gsc->id, gsc->state);
+	return ret;
+}
+
+static int gsc_resume(struct device *dev)
+{
+	struct gsc_dev *gsc = dev_get_drvdata(dev);
+	unsigned long flags;
+
+	pr_debug("gsc%d: state: 0x%lx", gsc->id, gsc->state);
+
+	/* Do not resume if the device was idle before system suspend */
+	spin_lock_irqsave(&gsc->slock, flags);
+	if (!test_and_clear_bit(ST_SUSPEND, &gsc->state) ||
+	    !gsc_m2m_active(gsc)) {
+		spin_unlock_irqrestore(&gsc->slock, flags);
+		return 0;
+	}
+	gsc_hw_set_sw_reset(gsc);
+	gsc_wait_reset(gsc);
+
+	spin_unlock_irqrestore(&gsc->slock, flags);
+
+	return gsc_m2m_resume(gsc);
+}
+
+static int gsc_suspend(struct device *dev)
+{
+	struct gsc_dev *gsc = dev_get_drvdata(dev);
+
+	pr_debug("gsc%d: state: 0x%lx", gsc->id, gsc->state);
+
+	if (test_and_set_bit(ST_SUSPEND, &gsc->state))
+		return 0;
+
+	return gsc_m2m_suspend(gsc);
+}
+
+static const struct dev_pm_ops gsc_pm_ops = {
+	.suspend		= gsc_suspend,
+	.resume			= gsc_resume,
+	.runtime_suspend	= gsc_runtime_suspend,
+	.runtime_resume		= gsc_runtime_resume,
+};
+
+static struct platform_driver gsc_driver = {
+	.probe		= gsc_probe,
+	.remove	= __devexit_p(gsc_remove),
+	.id_table	= gsc_driver_ids,
+	.driver = {
+		.name	= GSC_MODULE_NAME,
+		.owner	= THIS_MODULE,
+		.pm	= &gsc_pm_ops,
+		.of_match_table = exynos_gsc_match,
+	}
+};
+
+module_platform_driver(gsc_driver);
+
+MODULE_AUTHOR("Hyunwong Kim <khw0178.kim@xxxxxxxxxxx>");
+MODULE_DESCRIPTION("Samsung EXYNOS5 Soc series G-Scaler driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/exynos-gsc/gsc-core.h b/drivers/media/video/exynos-gsc/gsc-core.h
new file mode 100644
index 0000000..59ac86b
--- /dev/null
+++ b/drivers/media/video/exynos-gsc/gsc-core.h
@@ -0,0 +1,537 @@
+/*
+ * Copyright (c) 2011 - 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * header file for Samsung EXYNOS5 SoC series G-Scaler driver
+
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef GSC_CORE_H_
+#define GSC_CORE_H_
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
+#include <media/v4l2-mediabus.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "gsc-regs.h"
+
+#define CONFIG_VB2_GSC_DMA_CONTIG	1
+#define GSC_MODULE_NAME			"exynos-gsc"
+
+#define GSC_SHUTDOWN_TIMEOUT		((100*HZ)/1000)
+#define GSC_MAX_DEVS			4
+#define GSC_M2M_BUF_NUM			0
+#define GSC_MAX_CTRL_NUM		10
+#define GSC_SC_ALIGN_4			4
+#define GSC_SC_ALIGN_2			2
+#define DEFAULT_CSC_EQ			1
+#define DEFAULT_CSC_RANGE		1
+
+#define	GSC_PARAMS			(1 << 0)
+#define	GSC_SRC_FMT			(1 << 1)
+#define	GSC_DST_FMT			(1 << 2)
+#define	GSC_CTX_M2M			(1 << 3)
+#define	GSC_CTX_STOP_REQ		(1 << 6)
+
+enum gsc_dev_flags {
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
+enum gsc_irq {
+	GSC_IRQ_DONE,
+	GSC_IRQ_OVERRUN
+};
+
+/**
+ * enum gsc_datapath - the path of data used for G-Scaler
+ * @GSC_CAMERA: from camera
+ * @GSC_DMA: from/to DMA
+ * @GSC_LOCAL: to local path
+ * @GSC_WRITEBACK: from FIMD
+ */
+enum gsc_datapath {
+	GSC_CAMERA = 0x1,
+	GSC_DMA,
+	GSC_MIXER,
+	GSC_FIMD,
+	GSC_WRITEBACK,
+};
+
+enum gsc_color_fmt {
+	GSC_RGB = 0x1,
+	GSC_YUV420 = 0x2,
+	GSC_YUV422 = 0x4,
+	GSC_YUV444 = 0x8,
+};
+
+enum gsc_yuv_fmt {
+	GSC_LSB_Y = 0x10,
+	GSC_LSB_C,
+	GSC_CBCR = 0x20,
+	GSC_CRCB,
+};
+
+#define fh_to_ctx(__fh) container_of(__fh, struct gsc_ctx, fh)
+#define is_rgb(x) (!!((x) & 0x1))
+#define is_yuv420(x) (!!((x) & 0x2))
+#define is_yuv422(x) (!!((x) & 0x4))
+
+#define gsc_m2m_active(dev)	test_bit(ST_M2M_RUN, &(dev)->state)
+#define gsc_m2m_pending(dev)	test_bit(ST_M2M_PEND, &(dev)->state)
+#define gsc_m2m_opened(dev)	test_bit(ST_M2M_OPEN, &(dev)->state)
+
+#define ctrl_to_ctx(__ctrl) \
+	container_of((__ctrl)->handler, struct gsc_ctx, ctrl_handler)
+/**
+ * struct gsc_fmt - the driver's internal color format data
+ * @mbus_code: Media Bus pixel code, -1 if not applicable
+ * @name: format description
+ * @pixelformat: the fourcc code for this format, 0 if not applicable
+ * @yorder: Y/C order
+ * @corder: Chrominance order control
+ * @num_planes: number of physically non-contiguous data planes
+ * @nr_comp: number of physically contiguous data planes
+ * @depth: per plane driver's private 'number of bits per pixel'
+ * @flags: flags indicating which operation mode format applies to
+ */
+struct gsc_fmt {
+	enum v4l2_mbus_pixelcode mbus_code;
+	char	*name;
+	u32	pixelformat;
+	u32	color;
+	u32	yorder;
+	u32	corder;
+	u16	num_planes;
+	u16	num_comp;
+	u8	depth[VIDEO_MAX_PLANES];
+	u32	flags;
+};
+
+/**
+ * struct gsc_input_buf - the driver's video buffer
+ * @vb:	videobuf2 buffer
+ * @list : linked list structure for buffer queue
+ * @idx : index of G-Scaler input buffer
+ */
+struct gsc_input_buf {
+	struct vb2_buffer	vb;
+	struct list_head	list;
+	int			idx;
+};
+
+/**
+ * struct gsc_addr - the G-Scaler physical address set
+ * @y:	 luminance plane address
+ * @cb:	 Cb plane address
+ * @cr:	 Cr plane address
+ */
+struct gsc_addr {
+	dma_addr_t	y;
+	dma_addr_t	cb;
+	dma_addr_t	cr;
+};
+
+/* struct gsc_ctrls - the G-Scaler control set
+ * @rotate: rotation degree
+ * @hflip: horizontal flip
+ * @vflip: vertical flip
+ * @global_alpha: the alpha value of current frame
+ */
+struct gsc_ctrls {
+	struct v4l2_ctrl	*rotate;
+	struct v4l2_ctrl	*hflip;
+	struct v4l2_ctrl	*vflip;
+	struct v4l2_ctrl	*global_alpha;
+};
+
+/**
+ * struct gsc_scaler - the configuration data for G-Scaler inetrnal scaler
+ * @pre_shfactor:	pre sclaer shift factor
+ * @pre_hratio:		horizontal ratio of the prescaler
+ * @pre_vratio:		vertical ratio of the prescaler
+ * @main_hratio:	the main scaler's horizontal ratio
+ * @main_vratio:	the main scaler's vertical ratio
+ */
+struct gsc_scaler {
+	u32	pre_shfactor;
+	u32	pre_hratio;
+	u32	pre_vratio;
+	u32	main_hratio;
+	u32	main_vratio;
+};
+
+struct gsc_dev;
+
+struct gsc_ctx;
+
+/**
+ * struct gsc_frame - source/target frame properties
+ * @f_width:	SRC : SRCIMG_WIDTH, DST : OUTPUTDMA_WHOLE_IMG_WIDTH
+ * @f_height:	SRC : SRCIMG_HEIGHT, DST : OUTPUTDMA_WHOLE_IMG_HEIGHT
+ * @crop:	cropped(source)/scaled(destination) size
+ * @payload:	image size in bytes (w x h x bpp)
+ * @addr:	image frame buffer physical addresses
+ * @fmt:	G-Scaler color format pointer
+ * @colorspace: value indicating v4l2_colorspace
+ * @alpha:	frame's alpha value
+ */
+struct gsc_frame {
+	u32 f_width;
+	u32 f_height;
+	struct v4l2_rect crop;
+	unsigned long payload[VIDEO_MAX_PLANES];
+	struct gsc_addr	addr;
+	const struct gsc_fmt *fmt;
+	u32 colorspace;
+	u8 alpha;
+};
+
+/**
+ * struct gsc_m2m_device - v4l2 memory-to-memory device data
+ * @vfd: the video device node for v4l2 m2m mode
+ * @m2m_dev: v4l2 memory-to-memory device data
+ * @ctx: hardware context data
+ * @refcnt: the reference counter
+ */
+struct gsc_m2m_device {
+	struct video_device	*vfd;
+	struct v4l2_m2m_dev	*m2m_dev;
+	struct gsc_ctx		*ctx;
+	int			refcnt;
+};
+
+/**
+ *  struct gsc_pix_max - image pixel size limits in various IP configurations
+ *
+ *  @org_scaler_bypass_w: max pixel width when the scaler is disabled
+ *  @org_scaler_bypass_h: max pixel height when the scaler is disabled
+ *  @org_scaler_input_w: max pixel width when the scaler is enabled
+ *  @org_scaler_input_h: max pixel height when the scaler is enabled
+ *  @real_rot_dis_w: max pixel src cropped height with the rotator is off
+ *  @real_rot_dis_h: max pixel src croppped width with the rotator is off
+ *  @real_rot_en_w: max pixel src cropped width with the rotator is on
+ *  @real_rot_en_h: max pixel src cropped height with the rotator is on
+ *  @target_rot_dis_w: max pixel dst scaled width with the rotator is off
+ *  @target_rot_dis_h: max pixel dst scaled height with the rotator is off
+ *  @target_rot_en_w: max pixel dst scaled width with the rotator is on
+ *  @target_rot_en_h: max pixel dst scaled height with the rotator is on
+ */
+struct gsc_pix_max {
+	u16 org_scaler_bypass_w;
+	u16 org_scaler_bypass_h;
+	u16 org_scaler_input_w;
+	u16 org_scaler_input_h;
+	u16 real_rot_dis_w;
+	u16 real_rot_dis_h;
+	u16 real_rot_en_w;
+	u16 real_rot_en_h;
+	u16 target_rot_dis_w;
+	u16 target_rot_dis_h;
+	u16 target_rot_en_w;
+	u16 target_rot_en_h;
+};
+
+/**
+ *  struct gsc_pix_min - image pixel size limits in various IP configurations
+ *
+ *  @org_w: minimum source pixel width
+ *  @org_h: minimum source pixel height
+ *  @real_w: minimum input crop pixel width
+ *  @real_h: minimum input crop pixel height
+ *  @target_rot_dis_w: minimum output scaled pixel height when rotator is off
+ *  @target_rot_dis_h: minimum output scaled pixel height when rotator is off
+ *  @target_rot_en_w: minimum output scaled pixel height when rotator is on
+ *  @target_rot_en_h: minimum output scaled pixel height when rotator is on
+ */
+struct gsc_pix_min {
+	u16 org_w;
+	u16 org_h;
+	u16 real_w;
+	u16 real_h;
+	u16 target_rot_dis_w;
+	u16 target_rot_dis_h;
+	u16 target_rot_en_w;
+	u16 target_rot_en_h;
+};
+
+struct gsc_pix_align {
+	u16 org_h;
+	u16 org_w;
+	u16 offset_h;
+	u16 real_w;
+	u16 real_h;
+	u16 target_w;
+	u16 target_h;
+};
+
+/**
+ * struct gsc_variant - G-Scaler variant information
+ */
+struct gsc_variant {
+	struct gsc_pix_max *pix_max;
+	struct gsc_pix_min *pix_min;
+	struct gsc_pix_align *pix_align;
+	u16		in_buf_cnt;
+	u16		out_buf_cnt;
+	u16		sc_up_max;
+	u16		sc_down_max;
+	u16		poly_sc_down_max;
+	u16		pre_sc_down_max;
+	u16		local_sc_down;
+};
+
+/**
+ * struct gsc_driverdata - per device type driver data for init time.
+ *
+ * @variant: the variant information for this driver.
+ * @lclk_frequency: G-Scaler clock frequency
+ * @num_entities: the number of g-scalers
+ */
+struct gsc_driverdata {
+	struct gsc_variant *variant[GSC_MAX_DEVS];
+	unsigned long	lclk_frequency;
+	int		num_entities;
+};
+
+/**
+ * struct gsc_dev - abstraction for G-Scaler entity
+ * @slock:	the spinlock protecting this data structure
+ * @lock:	the mutex protecting this data structure
+ * @pdev:	pointer to the G-Scaler platform device
+ * @variant:	the IP variant information
+ * @id:		G-Scaler device index (0..GSC_MAX_DEVS)
+ * @clock:	clocks required for G-Scaler operation
+ * @regs:	the mapped hardware registers
+ * @irq_queue:	interrupt handler waitqueue
+ * @m2m:	memory-to-memory V4L2 device information
+ * @state:	flags used to synchronize m2m and capture mode operation
+ * @alloc_ctx:	videobuf2 memory allocator context
+ * @vdev:	video device for G-Scaler instance
+ */
+struct gsc_dev {
+	spinlock_t			slock;
+	struct mutex			lock;
+	struct platform_device		*pdev;
+	struct gsc_variant		*variant;
+	u16				id;
+	struct clk			*clock;
+	void __iomem			*regs;
+	wait_queue_head_t		irq_queue;
+	struct gsc_m2m_device		m2m;
+	struct exynos_platform_gscaler	*pdata;
+	unsigned long			state;
+	struct vb2_alloc_ctx		*alloc_ctx;
+	struct video_device		vdev;
+};
+
+/**
+ * gsc_ctx - the device context data
+ * @s_frame:		source frame properties
+ * @d_frame:		destination frame properties
+ * @in_path:		input mode (DMA or camera)
+ * @out_path:		output mode (DMA or FIFO)
+ * @scaler:		image scaler properties
+ * @flags:		additional flags for image conversion
+ * @state:		flags to keep track of user configuration
+ * @gsc_dev:		the G-Scaler device this context applies to
+ * @m2m_ctx:		memory-to-memory device context
+ * @fh:                 v4l2 file handle
+ * @ctrl_handler:       v4l2 controls handler
+ * @gsc_ctrls		G-Scaler control set
+ * @ctrls_rdy:          true if the control handler is initialized
+ */
+struct gsc_ctx {
+	struct gsc_frame	s_frame;
+	struct gsc_frame	d_frame;
+	enum gsc_datapath	in_path;
+	enum gsc_datapath	out_path;
+	struct gsc_scaler	scaler;
+	u32			flags;
+	u32			state;
+	int			rotation;
+	unsigned int		hflip:1;
+	unsigned int		vflip:1;
+	struct gsc_dev		*gsc_dev;
+	struct v4l2_m2m_ctx	*m2m_ctx;
+	struct v4l2_fh		fh;
+	struct v4l2_ctrl_handler ctrl_handler;
+	struct gsc_ctrls	gsc_ctrls;
+	bool			ctrls_rdy;
+};
+
+void gsc_set_prefbuf(struct gsc_dev *gsc, struct gsc_frame *frm);
+int gsc_register_m2m_device(struct gsc_dev *gsc);
+void gsc_unregister_m2m_device(struct gsc_dev *gsc);
+void gsc_m2m_job_finish(struct gsc_ctx *ctx, int vb_state);
+
+u32 get_plane_size(struct gsc_frame *fr, unsigned int plane);
+const struct gsc_fmt *get_format(int index);
+const struct gsc_fmt *find_fmt(u32 *pixelformat, u32 *mbus_code, u32 index);
+int gsc_enum_fmt_mplane(struct v4l2_fmtdesc *f);
+int gsc_try_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f);
+void gsc_set_frame_size(struct gsc_frame *frame, int width, int height);
+int gsc_g_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f);
+void gsc_check_crop_change(u32 tmp_w, u32 tmp_h, u32 *w, u32 *h);
+int gsc_g_crop(struct gsc_ctx *ctx, struct v4l2_crop *cr);
+int gsc_try_crop(struct gsc_ctx *ctx, struct v4l2_crop *cr);
+int gsc_cal_prescaler_ratio(struct gsc_variant *var, u32 src, u32 dst,
+							u32 *ratio);
+void gsc_get_prescaler_shfactor(u32 hratio, u32 vratio, u32 *sh);
+void gsc_check_src_scale_info(struct gsc_variant *var,
+				struct gsc_frame *s_frame,
+				u32 *wratio, u32 tx, u32 ty, u32 *hratio);
+int gsc_check_scaler_ratio(struct gsc_variant *var, int sw, int sh, int dw,
+			   int dh, int rot, int out_path);
+int gsc_set_scaler_info(struct gsc_ctx *ctx);
+int gsc_ctrls_create(struct gsc_ctx *ctx);
+void gsc_ctrls_delete(struct gsc_ctx *ctx);
+int gsc_prepare_addr(struct gsc_ctx *ctx, struct vb2_buffer *vb,
+		     struct gsc_frame *frame, struct gsc_addr *addr);
+
+static inline void gsc_ctx_state_lock_set(u32 state, struct gsc_ctx *ctx)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->gsc_dev->slock, flags);
+	ctx->state |= state;
+	spin_unlock_irqrestore(&ctx->gsc_dev->slock, flags);
+}
+
+static inline void gsc_ctx_state_lock_clear(u32 state, struct gsc_ctx *ctx)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->gsc_dev->slock, flags);
+	ctx->state &= ~state;
+	spin_unlock_irqrestore(&ctx->gsc_dev->slock, flags);
+}
+
+static inline int is_tiled(const struct gsc_fmt *fmt)
+{
+	return fmt->pixelformat == V4L2_PIX_FMT_NV12MT_16X16;
+}
+
+static inline void gsc_hw_enable_control(struct gsc_dev *dev, bool on)
+{
+	u32 cfg = readl(dev->regs + GSC_ENABLE);
+
+	if (on)
+		cfg |= GSC_ENABLE_ON;
+	else
+		cfg &= ~GSC_ENABLE_ON;
+
+	writel(cfg, dev->regs + GSC_ENABLE);
+}
+
+static inline int gsc_hw_get_irq_status(struct gsc_dev *dev)
+{
+	u32 cfg = readl(dev->regs + GSC_IRQ);
+	if (cfg & GSC_IRQ_STATUS_OR_IRQ)
+		return GSC_IRQ_OVERRUN;
+	else
+		return GSC_IRQ_DONE;
+
+}
+
+static inline void gsc_hw_clear_irq(struct gsc_dev *dev, int irq)
+{
+	u32 cfg = readl(dev->regs + GSC_IRQ);
+	if (irq == GSC_IRQ_OVERRUN)
+		cfg |= GSC_IRQ_STATUS_OR_IRQ;
+	else if (irq == GSC_IRQ_DONE)
+		cfg |= GSC_IRQ_STATUS_FRM_DONE_IRQ;
+	writel(cfg, dev->regs + GSC_IRQ);
+}
+
+static inline void gsc_lock(struct vb2_queue *vq)
+{
+	struct gsc_ctx *ctx = vb2_get_drv_priv(vq);
+	mutex_lock(&ctx->gsc_dev->lock);
+}
+
+static inline void gsc_unlock(struct vb2_queue *vq)
+{
+	struct gsc_ctx *ctx = vb2_get_drv_priv(vq);
+	mutex_unlock(&ctx->gsc_dev->lock);
+}
+
+static inline bool gsc_ctx_state_is_set(u32 mask, struct gsc_ctx *ctx)
+{
+	unsigned long flags;
+	bool ret;
+
+	spin_lock_irqsave(&ctx->gsc_dev->slock, flags);
+	ret = (ctx->state & mask) == mask;
+	spin_unlock_irqrestore(&ctx->gsc_dev->slock, flags);
+	return ret;
+}
+
+static inline struct gsc_frame *ctx_get_frame(struct gsc_ctx *ctx,
+					      enum v4l2_buf_type type)
+{
+	struct gsc_frame *frame;
+
+	if (V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE == type) {
+		frame = &ctx->s_frame;
+	} else if (V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE == type) {
+		frame = &ctx->d_frame;
+	} else {
+		pr_err("Wrong buffer/video queue type (%d)", type);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return frame;
+}
+
+static inline void user_to_drv(struct v4l2_ctrl *ctrl, s32 value)
+{
+	ctrl->cur.val = ctrl->val = value;
+}
+
+void gsc_hw_set_sw_reset(struct gsc_dev *dev);
+int gsc_wait_reset(struct gsc_dev *dev);
+
+void gsc_hw_set_frm_done_irq_mask(struct gsc_dev *dev, bool mask);
+void gsc_hw_set_gsc_irq_enable(struct gsc_dev *dev, bool mask);
+void gsc_hw_set_input_buf_masking(struct gsc_dev *dev, u32 shift, bool enable);
+void gsc_hw_set_output_buf_masking(struct gsc_dev *dev, u32 shift, bool enable);
+void gsc_hw_set_input_addr(struct gsc_dev *dev, struct gsc_addr *addr,
+							int index);
+void gsc_hw_set_output_addr(struct gsc_dev *dev, struct gsc_addr *addr,
+							int index);
+void gsc_hw_set_input_path(struct gsc_ctx *ctx);
+void gsc_hw_set_in_size(struct gsc_ctx *ctx);
+void gsc_hw_set_in_image_rgb(struct gsc_ctx *ctx);
+void gsc_hw_set_in_image_format(struct gsc_ctx *ctx);
+void gsc_hw_set_output_path(struct gsc_ctx *ctx);
+void gsc_hw_set_out_size(struct gsc_ctx *ctx);
+void gsc_hw_set_out_image_rgb(struct gsc_ctx *ctx);
+void gsc_hw_set_out_image_format(struct gsc_ctx *ctx);
+void gsc_hw_set_prescaler(struct gsc_ctx *ctx);
+void gsc_hw_set_mainscaler(struct gsc_ctx *ctx);
+void gsc_hw_set_rotation(struct gsc_ctx *ctx);
+void gsc_hw_set_global_alpha(struct gsc_ctx *ctx);
+void gsc_hw_set_sfr_update(struct gsc_ctx *ctx);
+
+#endif /* GSC_CORE_H_ */
-- 
1.7.0.4

