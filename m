Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:47344 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754769AbcJNRe7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:34:59 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 06/21] [media] imx: Add IPUv3 media common code
Date: Fri, 14 Oct 2016 19:34:26 +0200
Message-Id: <1476466481-24030-7-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sascha Hauer <s.hauer@pengutronix.de>

Add video4linux API routines common to drivers for units that
accept or provide video data via the i.MX IPU IDMAC channels,
such as capture, mem2mem scaler or deinterlacer drivers.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/imx/Kconfig   |   3 +
 drivers/media/platform/imx/Makefile  |   1 +
 drivers/media/platform/imx/imx-ipu.c | 321 +++++++++++++++++++++++++++++++++++
 drivers/media/platform/imx/imx-ipu.h |  34 ++++
 4 files changed, 359 insertions(+)
 create mode 100644 drivers/media/platform/imx/imx-ipu.c
 create mode 100644 drivers/media/platform/imx/imx-ipu.h

diff --git a/drivers/media/platform/imx/Kconfig b/drivers/media/platform/imx/Kconfig
index 3bd699c..1662bb0b 100644
--- a/drivers/media/platform/imx/Kconfig
+++ b/drivers/media/platform/imx/Kconfig
@@ -5,3 +5,6 @@ config MEDIA_IMX
 	---help---
 	  This driver provides a SoC wide media controller device that all
 	  multimedia components in i.MX5 and i.MX6 SoCs can register with.
+
+config VIDEO_IMX_IPU_COMMON
+	tristate
diff --git a/drivers/media/platform/imx/Makefile b/drivers/media/platform/imx/Makefile
index 74bed76..0ba601a 100644
--- a/drivers/media/platform/imx/Makefile
+++ b/drivers/media/platform/imx/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_MEDIA_IMX)			+= imx-media.o
+obj-$(CONFIG_VIDEO_IMX_IPU_COMMON)	+= imx-ipu.o
diff --git a/drivers/media/platform/imx/imx-ipu.c b/drivers/media/platform/imx/imx-ipu.c
new file mode 100644
index 0000000..da1deb0
--- /dev/null
+++ b/drivers/media/platform/imx/imx-ipu.c
@@ -0,0 +1,321 @@
+/*
+ * i.MX IPUv3 common v4l2 support
+ *
+ * Copyright (C) 2011 Pengutronix, Sascha Hauer <kernel@pengutronix.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/module.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-ioctl.h>
+
+#include "imx-ipu.h"
+
+/*
+ * These formats are in order of preference: interleaved YUV first,
+ * because those are the most bandwidth efficient, followed by
+ * chroma-interleaved formats, and planar formats last.
+ * In each category, YUV 4:2:0 may be preferrable to 4:2:2 for bandwidth
+ * reasons, if the IDMAC channel supports double read/write reduction
+ * (all write channels, VDIC read channels).
+ */
+static struct ipu_fmt ipu_fmt_yuv[] = {
+	{
+		.fourcc = V4L2_PIX_FMT_YUYV,
+		.bytes_per_pixel = 2,
+	}, {
+		.fourcc = V4L2_PIX_FMT_UYVY,
+		.bytes_per_pixel = 2,
+	}, {
+		.fourcc = V4L2_PIX_FMT_NV12,
+		.bytes_per_pixel = 1,
+	}, {
+		.fourcc = V4L2_PIX_FMT_NV16,
+		.bytes_per_pixel = 1,
+	}, {
+		.fourcc = V4L2_PIX_FMT_YUV420,
+		.bytes_per_pixel = 1,
+	}, {
+		.fourcc = V4L2_PIX_FMT_YVU420,
+		.bytes_per_pixel = 1,
+	}, {
+		.fourcc = V4L2_PIX_FMT_YUV422P,
+		.bytes_per_pixel = 1,
+	},
+};
+
+static struct ipu_fmt ipu_fmt_rgb[] = {
+	{
+		.fourcc = V4L2_PIX_FMT_RGB32,
+		.bytes_per_pixel = 4,
+	}, {
+		.fourcc = V4L2_PIX_FMT_RGB24,
+		.bytes_per_pixel = 3,
+	}, {
+		.fourcc = V4L2_PIX_FMT_BGR24,
+		.bytes_per_pixel = 3,
+	}, {
+		.fourcc = V4L2_PIX_FMT_RGB565,
+		.bytes_per_pixel = 2,
+	},
+	{
+		.fourcc = V4L2_PIX_FMT_BGR32,
+		.bytes_per_pixel = 4,
+	},
+};
+
+struct ipu_fmt *ipu_find_fmt_yuv(unsigned int pixelformat)
+{
+	struct ipu_fmt *fmt;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ipu_fmt_yuv); i++) {
+		fmt = &ipu_fmt_yuv[i];
+		if (fmt->fourcc == pixelformat)
+			return fmt;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(ipu_find_fmt_yuv);
+
+struct ipu_fmt *ipu_find_fmt_rgb(unsigned int pixelformat)
+{
+	struct ipu_fmt *fmt;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ipu_fmt_rgb); i++) {
+		fmt = &ipu_fmt_rgb[i];
+		if (fmt->fourcc == pixelformat)
+			return fmt;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(ipu_find_fmt_rgb);
+
+static struct ipu_fmt *ipu_find_fmt(unsigned long pixelformat)
+{
+	struct ipu_fmt *fmt;
+
+	fmt = ipu_find_fmt_yuv(pixelformat);
+	if (fmt)
+		return fmt;
+	fmt = ipu_find_fmt_rgb(pixelformat);
+
+	return fmt;
+}
+EXPORT_SYMBOL_GPL(ipu_find_fmt);
+
+int ipu_try_fmt(struct file *file, void *fh,
+		struct v4l2_format *f)
+{
+	struct ipu_fmt *fmt;
+
+	v4l_bound_align_image(&f->fmt.pix.width, 8, 4096, 2,
+			      &f->fmt.pix.height, 2, 4096, 1, 0);
+
+	f->fmt.pix.field = V4L2_FIELD_NONE;
+
+	fmt = ipu_find_fmt(f->fmt.pix.pixelformat);
+	if (!fmt)
+		return -EINVAL;
+
+	f->fmt.pix.bytesperline = f->fmt.pix.width * fmt->bytes_per_pixel;
+	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * f->fmt.pix.height;
+	if (fmt->fourcc == V4L2_PIX_FMT_YUV420 ||
+	    fmt->fourcc == V4L2_PIX_FMT_YVU420 ||
+	    fmt->fourcc == V4L2_PIX_FMT_NV12)
+		f->fmt.pix.sizeimage = f->fmt.pix.sizeimage * 3 / 2;
+	else if (fmt->fourcc == V4L2_PIX_FMT_YUV422P ||
+		 fmt->fourcc == V4L2_PIX_FMT_NV16)
+		f->fmt.pix.sizeimage *= 2;
+
+	switch (f->fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+	case V4L2_PIX_FMT_YUV422P:
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_YUYV:
+		if (f->fmt.pix.width <= 720 && f->fmt.pix.height <= 576)
+			f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+		else
+			f->fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
+		break;
+	case V4L2_PIX_FMT_RGB32:
+	case V4L2_PIX_FMT_RGB24:
+	case V4L2_PIX_FMT_BGR24:
+	case V4L2_PIX_FMT_RGB565:
+	case V4L2_PIX_FMT_BGR32:
+		f->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_try_fmt);
+
+int ipu_try_fmt_rgb(struct file *file, void *fh,
+		struct v4l2_format *f)
+{
+	struct ipu_fmt *fmt;
+
+	fmt = ipu_find_fmt_rgb(f->fmt.pix.pixelformat);
+	if (!fmt)
+		return -EINVAL;
+
+	return ipu_try_fmt(file, fh, f);
+}
+EXPORT_SYMBOL_GPL(ipu_try_fmt_rgb);
+
+int ipu_try_fmt_yuv(struct file *file, void *fh,
+		struct v4l2_format *f)
+{
+	struct ipu_fmt *fmt;
+
+	fmt = ipu_find_fmt_yuv(f->fmt.pix.pixelformat);
+	if (!fmt)
+		return -EINVAL;
+
+	return ipu_try_fmt(file, fh, f);
+}
+EXPORT_SYMBOL_GPL(ipu_try_fmt_yuv);
+
+int ipu_enum_fmt_rgb(struct file *file, void *fh,
+		struct v4l2_fmtdesc *f)
+{
+	struct ipu_fmt *fmt;
+
+	if (f->index >= ARRAY_SIZE(ipu_fmt_rgb))
+		return -EINVAL;
+
+	fmt = &ipu_fmt_rgb[f->index];
+
+	f->pixelformat = fmt->fourcc;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_enum_fmt_rgb);
+
+int ipu_enum_fmt_yuv(struct file *file, void *fh,
+		struct v4l2_fmtdesc *f)
+{
+	struct ipu_fmt *fmt;
+
+	if (f->index >= ARRAY_SIZE(ipu_fmt_yuv))
+		return -EINVAL;
+
+	fmt = &ipu_fmt_yuv[f->index];
+
+	f->pixelformat = fmt->fourcc;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_enum_fmt_yuv);
+
+int ipu_enum_fmt(struct file *file, void *fh,
+		struct v4l2_fmtdesc *f)
+{
+	struct ipu_fmt *fmt;
+	int index = f->index;
+
+	if (index >= ARRAY_SIZE(ipu_fmt_yuv)) {
+		index -= ARRAY_SIZE(ipu_fmt_yuv);
+		if (index >= ARRAY_SIZE(ipu_fmt_rgb))
+			return -EINVAL;
+		fmt = &ipu_fmt_rgb[index];
+	} else {
+		fmt = &ipu_fmt_yuv[index];
+	}
+
+	f->pixelformat = fmt->fourcc;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_enum_fmt);
+
+int ipu_s_fmt(struct file *file, void *fh,
+		struct v4l2_format *f, struct v4l2_pix_format *pix)
+{
+	int ret;
+
+	ret = ipu_try_fmt(file, fh, f);
+	if (ret)
+		return ret;
+
+	*pix = f->fmt.pix;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_s_fmt);
+
+int ipu_s_fmt_rgb(struct file *file, void *fh,
+		struct v4l2_format *f, struct v4l2_pix_format *pix)
+{
+	struct ipu_fmt *fmt;
+
+	fmt = ipu_find_fmt_rgb(f->fmt.pix.pixelformat);
+	if (!fmt)
+		return -EINVAL;
+
+	return ipu_s_fmt(file, fh, f, pix);
+}
+EXPORT_SYMBOL_GPL(ipu_s_fmt_rgb);
+
+int ipu_s_fmt_yuv(struct file *file, void *fh,
+		struct v4l2_format *f, struct v4l2_pix_format *pix)
+{
+	struct ipu_fmt *fmt;
+
+	fmt = ipu_find_fmt_yuv(f->fmt.pix.pixelformat);
+	if (!fmt)
+		return -EINVAL;
+
+	return ipu_s_fmt(file, fh, f, pix);
+}
+EXPORT_SYMBOL_GPL(ipu_s_fmt_yuv);
+
+int ipu_g_fmt(struct v4l2_format *f, struct v4l2_pix_format *pix)
+{
+	f->fmt.pix = *pix;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_g_fmt);
+
+int ipu_enum_framesizes(struct file *file, void *fh,
+			struct v4l2_frmsizeenum *fsize)
+{
+	struct ipu_fmt *fmt;
+
+	if (fsize->index != 0)
+		return -EINVAL;
+
+	fmt = ipu_find_fmt(fsize->pixel_format);
+	if (!fmt)
+		return -EINVAL;
+
+	fsize->type = V4L2_FRMSIZE_TYPE_CONTINUOUS;
+	fsize->stepwise.min_width = 1;
+	fsize->stepwise.min_height = 1;
+	fsize->stepwise.max_width = 4096;
+	fsize->stepwise.max_height = 4096;
+	fsize->stepwise.step_width = fsize->stepwise.step_height = 1;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_enum_framesizes);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/imx/imx-ipu.h b/drivers/media/platform/imx/imx-ipu.h
new file mode 100644
index 0000000..7b344b6
--- /dev/null
+++ b/drivers/media/platform/imx/imx-ipu.h
@@ -0,0 +1,34 @@
+#ifndef __MEDIA_IMX_IPU_H
+#define __MEDIA_IMX_IPU_H
+#include <linux/videodev2.h>
+
+struct ipu_fmt {
+	u32 fourcc;
+	int bytes_per_pixel;
+};
+
+int ipu_enum_fmt(struct file *file, void *fh,
+		struct v4l2_fmtdesc *f);
+int ipu_enum_fmt_rgb(struct file *file, void *fh,
+		struct v4l2_fmtdesc *f);
+int ipu_enum_fmt_yuv(struct file *file, void *fh,
+		struct v4l2_fmtdesc *f);
+struct ipu_fmt *ipu_find_fmt_rgb(unsigned int pixelformat);
+struct ipu_fmt *ipu_find_fmt_yuv(unsigned int pixelformat);
+int ipu_try_fmt(struct file *file, void *fh,
+		struct v4l2_format *f);
+int ipu_try_fmt_rgb(struct file *file, void *fh,
+		struct v4l2_format *f);
+int ipu_try_fmt_yuv(struct file *file, void *fh,
+		struct v4l2_format *f);
+int ipu_s_fmt(struct file *file, void *fh,
+		struct v4l2_format *f, struct v4l2_pix_format *pix);
+int ipu_s_fmt_rgb(struct file *file, void *fh,
+		struct v4l2_format *f, struct v4l2_pix_format *pix);
+int ipu_s_fmt_yuv(struct file *file, void *fh,
+		struct v4l2_format *f, struct v4l2_pix_format *pix);
+int ipu_g_fmt(struct v4l2_format *f, struct v4l2_pix_format *pix);
+int ipu_enum_framesizes(struct file *file, void *fh,
+			struct v4l2_frmsizeenum *fsize);
+
+#endif /* __MEDIA_IMX_IPU_H */
-- 
2.9.3

