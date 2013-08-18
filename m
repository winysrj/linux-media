Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:32950 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab3HRKKV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Aug 2013 06:10:21 -0400
Received: by mail-pb0-f43.google.com with SMTP id md4so3750391pbc.2
        for <linux-media@vger.kernel.org>; Sun, 18 Aug 2013 03:10:21 -0700 (PDT)
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, posciak@google.com
Subject: =?UTF-8?q?=5BPATCH=5D=20=5Bmedia=5D=3A=20exynos-mscl=3A=20Add=20new=20driver=20for=20M2M=20scaler?=
Date: Sun, 18 Aug 2013 15:44:04 +0530
Message-Id: <1376820844-27261-1-git-send-email-shaik.ameer@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for M-Scaler (M2M Scaler) device which is a
new device for scaling, blending, color fill  and color space
conversion on EXYNOS5 SoCs.

This device supports the followings as key feature.
    input image format
        - YCbCr420 2P(UV/VU), 3P
        - YCbCr422 1P(YUYV/UYVY/YVYU), 2P(UV,VU), 3P
        - YCbCr444 2P(UV,VU), 3P
        - RGB565, ARGB1555, ARGB4444, ARGB8888, RGBA8888
        - Pre-multiplexed ARGB8888, L8A8 and L8
    output image format
        - YCbCr420 2P(UV/VU), 3P
        - YCbCr422 1P(YUYV/UYVY/YVYU), 2P(UV,VU), 3P
        - YCbCr444 2P(UV,VU), 3P
        - RGB565, ARGB1555, ARGB4444, ARGB8888, RGBA8888
        - Pre-multiplexed ARGB8888
    input rotation
        - 0/90/180/270 degree, X/Y/XY Flip
    scale ratio
        - 1/4 scale down to 16 scale up
    color space conversion
        - RGB to YUV / YUV to RGB
    Size
        - Input : 16x16 to 8192x8192
        - Output:   4x4 to 8192x8192
    alpha blending, color fill

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/Kconfig                 |    8 +
 drivers/media/platform/Makefile                |    1 +
 drivers/media/platform/exynos-mscl/Makefile    |    3 +
 drivers/media/platform/exynos-mscl/mscl-core.c | 1326 ++++++++++++++++++++++++
 drivers/media/platform/exynos-mscl/mscl-core.h |  554 ++++++++++
 drivers/media/platform/exynos-mscl/mscl-m2m.c  |  773 ++++++++++++++
 drivers/media/platform/exynos-mscl/mscl-regs.c |  386 +++++++
 drivers/media/platform/exynos-mscl/mscl-regs.h |  282 +++++
 8 files changed, 3333 insertions(+)
 create mode 100644 drivers/media/platform/exynos-mscl/Makefile
 create mode 100644 drivers/media/platform/exynos-mscl/mscl-core.c
 create mode 100644 drivers/media/platform/exynos-mscl/mscl-core.h
 create mode 100644 drivers/media/platform/exynos-mscl/mscl-m2m.c
 create mode 100644 drivers/media/platform/exynos-mscl/mscl-regs.c
 create mode 100644 drivers/media/platform/exynos-mscl/mscl-regs.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 08de865..f6e5510 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -201,6 +201,14 @@ config VIDEO_SAMSUNG_EXYNOS_GSC
 	help
 	  This is a v4l2 driver for Samsung EXYNOS5 SoC G-Scaler.
 
+config VIDEO_SAMSUNG_EXYNOS_MSCL
+	tristate "Samsung Exynos M2M-Scaler driver"
+	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_EXYNOS5
+	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_MEM2MEM_DEV
+	help
+	  This is a v4l2 driver for Samsung EXYNOS5 SoC M2M-Scaler.
+
 config VIDEO_SH_VEU
 	tristate "SuperH VEU mem2mem video processing driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && GENERIC_HARDIRQS
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index eee28dd..2452b09 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_VIDEO_SAMSUNG_S5P_TV)	+= s5p-tv/
 
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_G2D)	+= s5p-g2d/
 obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC)	+= exynos-gsc/
+obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_MSCL)	+= exynos-mscl/
 
 obj-$(CONFIG_BLACKFIN)                  += blackfin/
 
diff --git a/drivers/media/platform/exynos-mscl/Makefile b/drivers/media/platform/exynos-mscl/Makefile
new file mode 100644
index 0000000..c9ffcd8
--- /dev/null
+++ b/drivers/media/platform/exynos-mscl/Makefile
@@ -0,0 +1,3 @@
+exynos-mscl-objs := mscl-core.o mscl-m2m.o mscl-regs.o
+
+obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_MSCL)	+= exynos-mscl.o
diff --git a/drivers/media/platform/exynos-mscl/mscl-core.c b/drivers/media/platform/exynos-mscl/mscl-core.c
new file mode 100644
index 0000000..81ce122
--- /dev/null
+++ b/drivers/media/platform/exynos-mscl/mscl-core.c
@@ -0,0 +1,1326 @@
+/*
+ * Copyright (c) 2013 - 2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Samsung EXYNOS5 SoC series M2M SCALER driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation, either version 2 of the License,
+ * or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
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
+#ifdef CONFIG_EXYNOS_IOMMU
+#include <linux/dma-mapping.h>
+#include <linux/iommu.h>
+#include <linux/kref.h>
+#include <linux/of_platform.h>
+
+#include <asm/dma-iommu.h>
+#endif
+
+#include "mscl-core.h"
+
+#define MSCL_CLOCK_GATE_NAME	"mscl"
+
+static const struct mscl_fmt mscl_formats[] = {
+	{
+		.name		= "YUV 4:2:0 non-contig. 2p, Y/CbCr",
+		.pixelformat	= V4L2_PIX_FMT_NV12M,
+		.depth		= { 8, 4 },
+		.color		= MSCL_YUV420,
+		.corder		= MSCL_CBCR,
+		.num_planes	= 2,
+		.num_comp	= 2,
+		.mscl_color	= MSCL_YUV420_2P_Y_UV,
+		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
+
+	}, {
+		.name		= "YUV 4:2:0 contig. 2p, Y/CbCr",
+		.pixelformat	= V4L2_PIX_FMT_NV12,
+		.depth		= { 12 },
+		.color		= MSCL_YUV420,
+		.corder		= MSCL_CBCR,
+		.num_planes	= 1,
+		.num_comp	= 2,
+		.mscl_color	= MSCL_YUV420_2P_Y_UV,
+		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
+	}, {
+		.name		= "YUV 4:2:0 n.c. 2p, Y/CbCr tiled",
+		.pixelformat	= V4L2_PIX_FMT_NV12MT_16X16,
+		.depth		= { 8, 4 },
+		.color		= MSCL_YUV420,
+		.corder		= MSCL_CBCR,
+		.num_planes	= 2,
+		.num_comp	= 2,
+		.mscl_color	= MSCL_YUV420_2P_Y_UV,
+		.mscl_color_fmt_type = (MSCL_FMT_SRC),
+		.is_tiled	= true,
+	}, {
+		.name		= "YUV 4:2:2 contig. 2p, Y/CbCr",
+		.pixelformat	= V4L2_PIX_FMT_NV16,
+		.depth		= { 16 },
+		.color		= MSCL_YUV422,
+		.corder		= MSCL_CBCR,
+		.num_planes	= 1,
+		.num_comp	= 2,
+		.mscl_color	= MSCL_YUV422_2P_Y_UV,
+		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
+	}, {
+		.name		= "YUV 4:4:4 contig. 2p, Y/CbCr",
+		.pixelformat	= V4L2_PIX_FMT_NV24,
+		.depth		= { 24 },
+		.color		= MSCL_YUV444,
+		.corder		= MSCL_CBCR,
+		.num_planes	= 1,
+		.num_comp	= 2,
+		.mscl_color	= MSCL_YUV444_2P_Y_UV,
+		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
+	}, {
+		.name		= "RGB565",
+		.pixelformat	= V4L2_PIX_FMT_RGB565X,
+		.depth		= { 16 },
+		.color		= MSCL_RGB,
+		.num_planes	= 1,
+		.num_comp	= 1,
+		.mscl_color	= MSCL_RGB565,
+		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
+	}, {
+		.name		= "XRGB-1555, 16 bpp",
+		.pixelformat	= V4L2_PIX_FMT_RGB555,
+		.depth		= { 16 },
+		.color		= MSCL_RGB,
+		.num_planes	= 1,
+		.num_comp	= 1,
+		.mscl_color	= MSCL_ARGB1555,
+		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
+	}, {
+		.name		= "XRGB-8888, 32 bpp",
+		.pixelformat	= V4L2_PIX_FMT_RGB32,
+		.depth		= { 32 },
+		.color		= MSCL_RGB,
+		.num_planes	= 1,
+		.num_comp	= 1,
+		.mscl_color	= MSCL_ARGB8888,
+		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
+	}, {
+		.name		= "YUV 4:2:2 packed, YCrYCb",
+		.pixelformat	= V4L2_PIX_FMT_YVYU,
+		.depth		= { 16 },
+		.color		= MSCL_YUV422,
+		.corder		= MSCL_CRCB,
+		.num_planes	= 1,
+		.num_comp	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_YVYU8_2X8,
+		.mscl_color	= MSCL_YUV422_1P_YVYU,
+		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
+	}, {
+		.name		= "YUV 4:2:2 packed, YCbYCr",
+		.pixelformat	= V4L2_PIX_FMT_YUYV,
+		.depth		= { 16 },
+		.color		= MSCL_YUV422,
+		.corder		= MSCL_CBCR,
+		.num_planes	= 1,
+		.num_comp	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
+		.mscl_color	= MSCL_YUV422_1P_YUYV,
+		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
+	}, {
+		.name		= "YUV 4:2:2 packed, CbYCrY",
+		.pixelformat	= V4L2_PIX_FMT_UYVY,
+		.depth		= { 16 },
+		.color		= MSCL_YUV422,
+		.corder		= MSCL_CBCR,
+		.num_planes	= 1,
+		.num_comp	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_UYVY8_2X8,
+		.mscl_color	= MSCL_YUV422_1P_UYVY,
+		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
+	}, {
+		.name		= "XRGB-4444, 16 bpp",
+		.pixelformat	= V4L2_PIX_FMT_RGB444,
+		.depth		= { 16 },
+		.color		= MSCL_RGB,
+		.num_planes	= 1,
+		.num_comp	= 1,
+		.mscl_color	= MSCL_ARGB4444,
+		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
+	}, {
+		.name		= "YUV 4:2:0 non-contig. 2p, Y/CrCb",
+		.pixelformat	= V4L2_PIX_FMT_NV21M,
+		.depth		= { 8, 4 },
+		.color		= MSCL_YUV420,
+		.corder		= MSCL_CRCB,
+		.num_planes	= 2,
+		.num_comp	= 2,
+		.mscl_color	= MSCL_YUV420_2P_Y_VU,
+		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
+	}, {
+		.name		= "YUV 4:2:0 contig. 2p, Y/CrCb",
+		.pixelformat	= V4L2_PIX_FMT_NV21,
+		.depth		= { 12 },
+		.color		= MSCL_YUV420,
+		.corder		= MSCL_CRCB,
+		.num_planes	= 1,
+		.num_comp	= 2,
+		.mscl_color	= MSCL_YUV420_2P_Y_VU,
+		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
+	}, {
+		.name		= "YUV 4:2:2 contig. 2p, Y/CrCb",
+		.pixelformat	= V4L2_PIX_FMT_NV61,
+		.depth		= { 16 },
+		.color		= MSCL_YUV422,
+		.corder		= MSCL_CRCB,
+		.num_planes	= 1,
+		.num_comp	= 2,
+		.mscl_color	= MSCL_YUV422_2P_Y_VU,
+		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
+	}, {
+		.name		= "YUV 4:4:4 contig. 2p, Y/CrCb",
+		.pixelformat	= V4L2_PIX_FMT_NV42,
+		.depth		= { 24 },
+		.color		= MSCL_YUV444,
+		.corder		= MSCL_CRCB,
+		.num_planes	= 1,
+		.num_comp	= 2,
+		.mscl_color	= MSCL_YUV444_2P_Y_VU,
+		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
+	}, {
+		.name		= "YUV 4:2:0 contig. 3p, YCbCr",
+		.pixelformat	= V4L2_PIX_FMT_YUV420,
+		.depth		= { 12 },
+		.color		= MSCL_YUV420,
+		.corder		= MSCL_CBCR,
+		.num_planes	= 1,
+		.num_comp	= 3,
+		.mscl_color	= MSCL_YUV420_3P_Y_U_V,
+		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
+	}, {
+		.name		= "YUV 4:2:0 contig. 3p, YCrCb",
+		.pixelformat	= V4L2_PIX_FMT_YVU420,
+		.depth		= { 12 },
+		.color		= MSCL_YUV420,
+		.corder		= MSCL_CRCB,
+		.num_planes	= 1,
+		.num_comp	= 3,
+		.mscl_color	= MSCL_YUV420_3P_Y_U_V,
+		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
+	}, {
+		.name		= "YUV 4:2:0 non-contig. 3p, Y/Cb/Cr",
+		.pixelformat	= V4L2_PIX_FMT_YUV420M,
+		.depth		= { 8, 2, 2 },
+		.color		= MSCL_YUV420,
+		.corder		= MSCL_CBCR,
+		.num_planes	= 3,
+		.num_comp	= 3,
+		.mscl_color	= MSCL_YUV420_3P_Y_U_V,
+		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
+	}, {
+		.name		= "YUV 4:2:0 non-contig. 3p, Y/Cr/Cb",
+		.pixelformat	= V4L2_PIX_FMT_YVU420M,
+		.depth		= { 8, 2, 2 },
+		.color		= MSCL_YUV420,
+		.corder		= MSCL_CRCB,
+		.num_planes	= 3,
+		.num_comp	= 3,
+		.mscl_color	= MSCL_YUV420_3P_Y_U_V,
+		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
+	}, {
+		.name		= "YUV 4:2:2 contig. 3p, Y/Cb/Cr",
+		.pixelformat	= V4L2_PIX_FMT_YUV422P,
+		.depth		= { 16 },
+		.color		= MSCL_YUV422,
+		.corder		= MSCL_CBCR,
+		.num_planes	= 1,
+		.num_comp	= 3,
+		.mscl_color	= MSCL_YUV422_3P_Y_U_V,
+		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
+	},
+
+	/* TBD:: support pixel formats, corresponds to these mscl_color formats
+	 * MSCL_L8A8, MSCL_RGBA8888, MSCL_L8 etc
+	 */
+};
+
+const struct mscl_fmt *mscl_get_format(int index)
+{
+	if (index >= ARRAY_SIZE(mscl_formats))
+		return NULL;
+
+	return (struct mscl_fmt *)&mscl_formats[index];
+}
+
+const struct mscl_fmt *mscl_find_fmt(u32 *pixelformat,
+				u32 *mbus_code, u32 index)
+{
+	const struct mscl_fmt *fmt, *def_fmt = NULL;
+	unsigned int i;
+
+	if (index >= ARRAY_SIZE(mscl_formats))
+		return NULL;
+
+	for (i = 0; i < ARRAY_SIZE(mscl_formats); ++i) {
+		fmt = mscl_get_format(i);
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
+void mscl_set_frame_size(struct mscl_frame *frame, int width, int height)
+{
+	frame->f_width	= width;
+	frame->f_height	= height;
+	frame->crop.width = width;
+	frame->crop.height = height;
+	frame->crop.left = 0;
+	frame->crop.top = 0;
+}
+
+int mscl_enum_fmt_mplane(struct v4l2_fmtdesc *f)
+{
+	const struct mscl_fmt *fmt;
+
+	fmt = mscl_find_fmt(NULL, NULL, f->index);
+	if (!fmt)
+		return -EINVAL;
+
+	/* input supports all mscl_formats but all mscl_formats are not
+	 * supported for output. don't return the unsupported formats for output
+	 */
+	if (!(V4L2_TYPE_IS_OUTPUT(f->type) &&
+		(fmt->mscl_color_fmt_type & MSCL_FMT_SRC)))
+		return -EINVAL;
+
+	strlcpy(f->description, fmt->name, sizeof(f->description));
+	f->pixelformat = fmt->pixelformat;
+
+	return 0;
+}
+
+static u32 get_plane_info(struct mscl_frame *frm, u32 addr, u32 *index)
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
+		pr_debug("Plane address is wrong");
+		return -EINVAL;
+	}
+}
+
+void mscl_set_prefbuf(struct mscl_dev *mscl, struct mscl_frame *frm)
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
+	dev_dbg(&mscl->pdev->dev,
+		"f_addr = 0x%08x, f_len = %d, s_addr = 0x%08x, s_len = %d\n",
+		f_chk_addr, f_chk_len, s_chk_addr, s_chk_len);
+}
+
+int mscl_try_fmt_mplane(struct mscl_ctx *ctx, struct v4l2_format *f)
+{
+	struct mscl_dev *mscl = ctx->mscl_dev;
+	struct device *dev = &mscl->pdev->dev;
+	struct mscl_variant *variant = mscl->variant;
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	const struct mscl_fmt *fmt;
+	u32 max_w, max_h, mod_w = 0, mod_h = 0;
+	u32 min_w, min_h, tmp_w, tmp_h;
+	int i;
+	struct mscl_frm_limit *frm_limit;
+
+	dev_dbg(dev, "user put w: %d, h: %d",
+			pix_mp->width, pix_mp->height);
+
+	fmt = mscl_find_fmt(&pix_mp->pixelformat, NULL, 0);
+	if (!fmt) {
+		dev_dbg(dev, "pixelformat format (0x%X) invalid\n",
+						pix_mp->pixelformat);
+		return -EINVAL;
+	}
+
+	if (pix_mp->field == V4L2_FIELD_ANY)
+		pix_mp->field = V4L2_FIELD_NONE;
+	else if (pix_mp->field != V4L2_FIELD_NONE) {
+		dev_dbg(dev, "Not supported field order(%d)\n", pix_mp->field);
+		return -EINVAL;
+	}
+
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
+	/* Span has to be even number for YCbCr422-2p or YCbCr420 format */
+	if (is_yuv422_2p(fmt) || is_yuv420(fmt))
+		mod_w = 1;
+
+	dev_dbg(dev, "mod_w: %d, mod_h: %d, max_w: %d, max_h = %d",
+			mod_w, mod_h, max_w, max_h);
+
+	/* To check if image size is modified to adjust parameter against
+	   hardware abilities */
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
+	/* nothing mentioned about the colorspace in m2m-scaler
+	 * default value is set to V4L2_COLORSPACE_REC709
+	 */
+	pix_mp->colorspace = V4L2_COLORSPACE_REC709;
+
+	for (i = 0; i < pix_mp->num_planes; ++i) {
+		int bpl = (pix_mp->width * fmt->depth[i]) >> 3;
+		pix_mp->plane_fmt[i].bytesperline = bpl;
+		pix_mp->plane_fmt[i].sizeimage = bpl * pix_mp->height;
+
+		dev_dbg(dev, "[%d]: bpl: %d, sizeimage: %d",
+				i, bpl, pix_mp->plane_fmt[i].sizeimage);
+	}
+
+	return 0;
+}
+
+int mscl_g_fmt_mplane(struct mscl_ctx *ctx, struct v4l2_format *f)
+{
+	struct mscl_frame *frame;
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
+void mscl_check_crop_change(u32 tmp_w, u32 tmp_h, u32 *w, u32 *h)
+{
+	if (tmp_w != *w || tmp_h != *h) {
+		pr_info("Cropped size has been modified from %dx%d to %dx%d",
+							*w, *h, tmp_w, tmp_h);
+		*w = tmp_w;
+		*h = tmp_h;
+	}
+}
+
+int mscl_g_crop(struct mscl_ctx *ctx, struct v4l2_crop *cr)
+{
+	struct mscl_frame *frame;
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
+int mscl_try_crop(struct mscl_ctx *ctx, struct v4l2_crop *cr)
+{
+	struct mscl_frame *f;
+	const struct mscl_fmt *fmt;
+	struct mscl_dev *mscl = ctx->mscl_dev;
+	struct device *dev = &mscl->pdev->dev;
+	struct mscl_variant *variant = mscl->variant;
+	u32 mod_w = 0, mod_h = 0, tmp_w, tmp_h;
+	u32 min_w, min_h, max_w, max_h;
+	struct mscl_frm_limit *frm_limit;
+
+	if (cr->c.top < 0 || cr->c.left < 0) {
+		dev_dbg(dev, "doesn't support negative values\n");
+		return -EINVAL;
+	}
+	dev_dbg(dev, "user requested width: %d, height: %d",
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
+		if (ctx->ctrls_mscl.rotate->val == 90 ||
+		    ctx->ctrls_mscl.rotate->val == 270) {
+			max_w = f->f_height;
+			max_h = f->f_width;
+			tmp_w = cr->c.height;
+			tmp_h = cr->c.width;
+		}
+	}
+
+	dev_dbg(dev, "mod_x: %d, mod_y: %d, min_w: %d, min_h = %d",
+					mod_w, mod_h, min_w, min_h);
+	dev_dbg(dev, "tmp_w : %d, tmp_h : %d", tmp_w, tmp_h);
+
+	v4l_bound_align_image(&tmp_w, min_w, max_w, mod_w,
+			      &tmp_h, min_h, max_h, mod_h, 0);
+
+	if (!V4L2_TYPE_IS_OUTPUT(cr->type) &&
+		(ctx->ctrls_mscl.rotate->val == 90 ||
+		 ctx->ctrls_mscl.rotate->val == 270))
+		mscl_check_crop_change(tmp_h, tmp_w,
+					&cr->c.width, &cr->c.height);
+	else
+		mscl_check_crop_change(tmp_w, tmp_h,
+					&cr->c.width, &cr->c.height);
+
+	/* adjust left/top if cropping rectangle is out of bounds */
+	/* Need to add code to algin left value with 2's multiple */
+	if (cr->c.left + tmp_w > max_w)
+		cr->c.left = max_w - tmp_w;
+	if (cr->c.top + tmp_h > max_h)
+		cr->c.top = max_h - tmp_h;
+
+	if (is_yuv422_1p(fmt) && (cr->c.left & 1))
+		cr->c.left -= 1;
+
+	dev_dbg(dev, "Aligned l:%d, t:%d, w:%d, h:%d, f_w: %d, f_h: %d",
+	    cr->c.left, cr->c.top, cr->c.width, cr->c.height, max_w, max_h);
+
+	return 0;
+}
+
+int mscl_check_scaler_ratio(struct mscl_variant *var, int sw, int sh, int dw,
+			   int dh, int rot)
+{
+	if ((dw == 0) || (dh == 0))
+		return -EINVAL;
+
+	if (rot == 90 || rot == 270)
+		swap(dh, dw);
+
+	pr_debug("sw: %d, sh: %d, dw: %d, dh: %d\n", sw, sh, dw, dh);
+
+	if ((sw/dw) > var->scl_down_max || (sh/dh) > var->scl_down_max ||
+	    (dw/sw) > var->scl_up_max   || (dh/sh) > var->scl_up_max)
+		return -EINVAL;
+
+	return 0;
+}
+
+int mscl_set_scaler_info(struct mscl_ctx *ctx)
+{
+	struct mscl_scaler *sc = &ctx->scaler;
+	struct mscl_frame *s_frame = &ctx->s_frame;
+	struct mscl_frame *d_frame = &ctx->d_frame;
+	struct mscl_variant *variant = ctx->mscl_dev->variant;
+	struct device *dev = &ctx->mscl_dev->pdev->dev;
+	int src_w, src_h, ret;
+
+	ret = mscl_check_scaler_ratio(variant,
+				s_frame->crop.width, s_frame->crop.height,
+				d_frame->crop.width, d_frame->crop.height,
+				ctx->ctrls_mscl.rotate->val);
+	if (ret) {
+		dev_dbg(dev, "out of scaler range\n");
+		return ret;
+	}
+
+	if (ctx->ctrls_mscl.rotate->val == 90 ||
+		ctx->ctrls_mscl.rotate->val == 270) {
+		src_w = s_frame->crop.height;
+		src_h = s_frame->crop.width;
+	} else {
+		src_w = s_frame->crop.width;
+		src_h = s_frame->crop.height;
+	}
+
+	sc->hratio = (src_w << 16) / d_frame->crop.width;
+	sc->vratio = (src_h << 16) / d_frame->crop.height;
+
+	dev_dbg(dev, "scaler settings::\n"
+		 "sx = %d, sy = %d, sw = %d, sh = %d\n"
+		 "dx = %d, dy = %d, dw = %d, dh = %d\n"
+		 "h-ratio : %d, v-ratio: %d\n",
+		 s_frame->crop.left, s_frame->crop.top,
+		 s_frame->crop.width, s_frame->crop.height,
+		 d_frame->crop.left, d_frame->crop.top,
+		 d_frame->crop.width, s_frame->crop.height,
+		 sc->hratio, sc->vratio);
+
+	return 0;
+}
+
+static int __mscl_s_ctrl(struct mscl_ctx *ctx, struct v4l2_ctrl *ctrl)
+{
+	struct mscl_dev *mscl = ctx->mscl_dev;
+	struct mscl_variant *variant = mscl->variant;
+	unsigned int flags = MSCL_DST_FMT | MSCL_SRC_FMT;
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
+			ret = mscl_check_scaler_ratio(variant,
+					ctx->s_frame.crop.width,
+					ctx->s_frame.crop.height,
+					ctx->d_frame.crop.width,
+					ctx->d_frame.crop.height,
+					ctx->ctrls_mscl.rotate->val);
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
+	ctx->state |= MSCL_PARAMS;
+	return 0;
+}
+
+static int mscl_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct mscl_ctx *ctx = ctrl_to_ctx(ctrl);
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&ctx->mscl_dev->slock, flags);
+	ret = __mscl_s_ctrl(ctx, ctrl);
+	spin_unlock_irqrestore(&ctx->mscl_dev->slock, flags);
+
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops mscl_ctrl_ops = {
+	.s_ctrl = mscl_s_ctrl,
+};
+
+int mscl_ctrls_create(struct mscl_ctx *ctx)
+{
+	struct device *dev = &ctx->mscl_dev->pdev->dev;
+
+	if (ctx->ctrls_rdy) {
+		dev_dbg(dev, "Control handler of this ctx was created already");
+		return 0;
+	}
+
+	v4l2_ctrl_handler_init(&ctx->ctrl_handler, MSCL_MAX_CTRL_NUM);
+
+	ctx->ctrls_mscl.rotate = v4l2_ctrl_new_std(&ctx->ctrl_handler,
+			&mscl_ctrl_ops, V4L2_CID_ROTATE, 0, 270, 90, 0);
+	ctx->ctrls_mscl.hflip = v4l2_ctrl_new_std(&ctx->ctrl_handler,
+			&mscl_ctrl_ops, V4L2_CID_HFLIP, 0, 1, 1, 0);
+	ctx->ctrls_mscl.vflip = v4l2_ctrl_new_std(&ctx->ctrl_handler,
+			&mscl_ctrl_ops, V4L2_CID_VFLIP, 0, 1, 1, 0);
+	ctx->ctrls_mscl.global_alpha = v4l2_ctrl_new_std(&ctx->ctrl_handler,
+			&mscl_ctrl_ops, V4L2_CID_ALPHA_COMPONENT, 0, 255, 1, 0);
+
+	ctx->ctrls_rdy = ctx->ctrl_handler.error == 0;
+
+	if (ctx->ctrl_handler.error) {
+		int err = ctx->ctrl_handler.error;
+		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+		dev_dbg(dev, "Failed to create G-Scaler control handlers");
+		return err;
+	}
+
+	return 0;
+}
+
+void mscl_ctrls_delete(struct mscl_ctx *ctx)
+{
+	if (ctx->ctrls_rdy) {
+		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+		ctx->ctrls_rdy = false;
+	}
+}
+
+/* The color format (num_comp, num_planes) must be already configured. */
+int mscl_prepare_addr(struct mscl_ctx *ctx, struct vb2_buffer *vb,
+			struct mscl_frame *frame, struct mscl_addr *addr)
+{
+	struct device *dev = &ctx->mscl_dev->pdev->dev;
+	int ret = 0;
+	u32 pix_size;
+
+	if ((vb == NULL) || (frame == NULL))
+		return -EINVAL;
+
+	pix_size = frame->f_width * frame->f_height;
+
+	dev_dbg(dev, "planes= %d, comp= %d, pix_size= %d, fmt = %d\n",
+		     frame->fmt->num_planes, frame->fmt->num_comp,
+		     pix_size, frame->fmt->mscl_color);
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
+			if (MSCL_YUV420 == frame->fmt->color)
+				addr->cr = (dma_addr_t)(addr->cb
+						+ (pix_size >> 2));
+			else if (MSCL_YUV422 == frame->fmt->color)
+				addr->cr = (dma_addr_t)(addr->cb
+						+ (pix_size >> 1));
+			else /* 444 */
+				addr->cr = (dma_addr_t)(addr->cb + pix_size);
+			break;
+		default:
+			dev_dbg(dev, "Invalid number of color planes\n");
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
+	if ((frame->fmt->corder == MSCL_CBCR) && (frame->fmt->num_planes == 3))
+		swap(addr->cb, addr->cr);
+
+	if (V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type))
+		dev_dbg(dev, "\nIN:ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d\n",
+					addr->y, addr->cb, addr->cr, ret);
+	else
+		dev_dbg(dev, "\nOUT:ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d\n",
+					addr->y, addr->cb, addr->cr, ret);
+
+	return ret;
+}
+
+static void mscl_sw_reset(struct mscl_dev *mscl)
+{
+	mscl_hw_set_sw_reset(mscl);
+	mscl_wait_reset(mscl);
+
+	mscl->coeff_type = MSCL_CSC_COEFF_NONE;
+}
+
+static void mscl_check_for_illegal_status(struct device *dev,
+					  unsigned int irq_status)
+{
+	if (irq_status & MSCL_INT_STATUS_TIMEOUT)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_TIMEOUT\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_BLEND)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_BLEND\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_RATIO)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_RATIO\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_DST_HEIGHT)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_DST_HEIGHT\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_DST_WIDTH)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_DST_WIDTH\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_DST_V_POS)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_DST_V_POS\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_DST_H_POS)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_DST_H_POS\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_DST_C_SPAN)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_DST_C_SPAN\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_DST_Y_SPAN)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_DST_Y_SPAN\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_DST_CR_BASE)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_DST_CR_BASE\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_DST_CB_BASE)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_DST_CB_BASE\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_DST_Y_BASE)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_DST_Y_BASE\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_DST_COLOR)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_DST_COLOR\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_HEIGHT)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_HEIGHT\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_WIDTH)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_WIDTH\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_CV_POS)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_CV_POS\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_CH_POS)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_CH_POS\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_YV_POS)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_YV_POS\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_YH_POS)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_YH_POS\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_C_SPAN)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_C_SPAN\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_Y_SPAN)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_Y_SPAN\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_CR_BASE)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_CR_BASE\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_CB_BASE)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_CB_BASE\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_Y_BASE)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_Y_BASE\n");
+	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_COLOR)
+		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_COLOR\n");
+}
+
+static irqreturn_t mscl_irq_handler(int irq, void *priv)
+{
+	struct mscl_dev *mscl = priv;
+	struct mscl_ctx *ctx;
+	unsigned int mscl_irq;
+	struct device *dev = &mscl->pdev->dev;
+
+	mscl_irq = mscl_hw_get_irq_status(mscl);
+	dev_dbg(dev, "irq_status: 0x%x\n", mscl_irq);
+	mscl_hw_clear_irq(mscl, mscl_irq);
+
+	if (mscl_irq & MSCL_INT_STATUS_ERROR)
+		mscl_check_for_illegal_status(dev, mscl_irq);
+
+	if (!(mscl_irq & MSCL_INT_EN_FRAME_END))
+		return IRQ_HANDLED;
+
+	spin_lock(&mscl->slock);
+
+	if (test_and_clear_bit(ST_M2M_PEND, &mscl->state)) {
+
+		mscl_hw_enable_control(mscl, false);
+
+		if (test_and_clear_bit(ST_M2M_SUSPENDING, &mscl->state)) {
+			set_bit(ST_M2M_SUSPENDED, &mscl->state);
+			wake_up(&mscl->irq_queue);
+			goto isr_unlock;
+		}
+		ctx = v4l2_m2m_get_curr_priv(mscl->m2m.m2m_dev);
+
+		if (!ctx || !ctx->m2m_ctx)
+			goto isr_unlock;
+
+		spin_unlock(&mscl->slock);
+		mscl_m2m_job_finish(ctx, VB2_BUF_STATE_DONE);
+
+		/* wake_up job_abort, stop_streaming */
+		if (ctx->state & MSCL_CTX_STOP_REQ) {
+			ctx->state &= ~MSCL_CTX_STOP_REQ;
+			wake_up(&mscl->irq_queue);
+		}
+		return IRQ_HANDLED;
+	}
+
+isr_unlock:
+	spin_unlock(&mscl->slock);
+	return IRQ_HANDLED;
+}
+
+static struct mscl_frm_limit mscl_inp_frm_limit = {
+	.min_w	= 16,
+	.min_h	= 16,
+	.max_w	= 8192,
+	.max_h	= 8192,
+};
+
+static struct mscl_frm_limit mscl_out_frm_limit = {
+	.min_w	= 4,
+	.min_h	= 4,
+	.max_w	= 8192,
+	.max_h	= 8192,
+};
+
+static struct mscl_pix_align mscl_align_v0 = {
+	.src_w_420 = 2,
+	.src_w_422 = 2,
+	.src_h_420 = 2,
+	.dst_w_420 = 2,
+	.dst_w_422 = 2,
+	.dst_h_420 = 2,
+};
+
+
+static struct mscl_variant mscl_variant0 = {
+	.pix_in = &mscl_inp_frm_limit,
+	.pix_out = &mscl_out_frm_limit,
+	.pix_align = &mscl_align_v0,
+	.scl_up_max = 16,
+	.scl_down_max = 4,
+	.in_buf_cnt = 32,
+	.out_buf_cnt = 32,
+};
+
+static struct mscl_driverdata mscl_drvdata = {
+	.variant = {
+		[0] = &mscl_variant0,
+		[1] = &mscl_variant0,
+		[2] = &mscl_variant0,
+	},
+	.num_entities = 3,
+	.lclk_frequency = 266000000UL,
+};
+
+static struct platform_device_id mscl_driver_ids[] = {
+	{
+		.name		= "exynos-mscl",
+		.driver_data	= (unsigned long)&mscl_drvdata,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(platform, mscl_driver_ids);
+
+static const struct of_device_id exynos_mscl_match[] = {
+	{
+		.compatible = "samsung,exynos5-mscl",
+		.data = &mscl_drvdata,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos_mscl_match);
+
+static void *mscl_get_drv_data(struct platform_device *pdev)
+{
+	struct mscl_driverdata *driver_data = NULL;
+
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_node(of_match_ptr(exynos_mscl_match),
+					pdev->dev.of_node);
+		if (match)
+			driver_data = (struct mscl_driverdata *)match->data;
+	}
+
+	return driver_data;
+}
+
+static void mscl_clk_put(struct mscl_dev *mscl)
+{
+	if (!IS_ERR(mscl->clock))
+		clk_unprepare(mscl->clock);
+}
+
+static int mscl_clk_get(struct mscl_dev *mscl)
+{
+	int ret;
+
+	dev_dbg(&mscl->pdev->dev, "mscl_clk_get Called\n");
+
+	mscl->clock = devm_clk_get(&mscl->pdev->dev, MSCL_CLOCK_GATE_NAME);
+	if (IS_ERR(mscl->clock)) {
+		dev_err(&mscl->pdev->dev, "failed to get clock~~~: %s\n",
+			MSCL_CLOCK_GATE_NAME);
+		return PTR_ERR(mscl->clock);
+	}
+
+	ret = clk_prepare(mscl->clock);
+	if (ret < 0) {
+		dev_err(&mscl->pdev->dev, "clock prepare fail for clock: %s\n",
+			MSCL_CLOCK_GATE_NAME);
+		mscl->clock = ERR_PTR(-EINVAL);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int mscl_m2m_suspend(struct mscl_dev *mscl)
+{
+	unsigned long flags;
+	int timeout;
+
+	spin_lock_irqsave(&mscl->slock, flags);
+	if (!mscl_m2m_pending(mscl)) {
+		spin_unlock_irqrestore(&mscl->slock, flags);
+		return 0;
+	}
+	clear_bit(ST_M2M_SUSPENDED, &mscl->state);
+	set_bit(ST_M2M_SUSPENDING, &mscl->state);
+	spin_unlock_irqrestore(&mscl->slock, flags);
+
+	timeout = wait_event_timeout(mscl->irq_queue,
+			     test_bit(ST_M2M_SUSPENDED, &mscl->state),
+			     MSCL_SHUTDOWN_TIMEOUT);
+
+	clear_bit(ST_M2M_SUSPENDING, &mscl->state);
+	return timeout == 0 ? -EAGAIN : 0;
+}
+
+static int mscl_m2m_resume(struct mscl_dev *mscl)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mscl->slock, flags);
+	/* Clear for full H/W setup in first run after resume */
+	mscl->m2m.ctx = NULL;
+	spin_unlock_irqrestore(&mscl->slock, flags);
+
+	if (test_and_clear_bit(ST_M2M_SUSPENDED, &mscl->state))
+		mscl_m2m_job_finish(mscl->m2m.ctx,
+				    VB2_BUF_STATE_ERROR);
+	return 0;
+}
+
+#ifdef CONFIG_EXYNOS_IOMMU
+static int mscl_iommu_init(struct mscl_dev *mscl)
+{
+	struct dma_iommu_mapping *mapping;
+	struct device *dev = &mscl->pdev->dev;
+
+	mapping = arm_iommu_create_mapping(&platform_bus_type, 0x20000000,
+						SZ_256M, 4);
+	if (mapping == NULL) {
+		dev_err(dev, "IOMMU mapping failed for MSCL\n");
+		return -EFAULT;
+	}
+
+	dev->dma_parms = devm_kzalloc(dev, sizeof(*dev->dma_parms),
+						GFP_KERNEL);
+	dma_set_max_seg_size(dev, 0xffffffffu);
+	arm_iommu_attach_device(dev, mapping);
+
+	mscl->mapping = mapping;
+
+	return 0;
+}
+
+static void mscl_iommu_deinit(struct mscl_dev *mscl)
+{
+	if (mscl->mapping)
+		arm_iommu_release_mapping(mscl->mapping);
+
+	mscl->mapping = NULL;
+}
+
+#else
+static int mscl_iommu_init(struct mscl_dev *mscl)
+{
+	return 0;
+}
+
+static void mscl_iommu_deinit(struct mscl_dev *mscl)
+{
+	return;
+}
+#endif
+
+static int mscl_probe(struct platform_device *pdev)
+{
+	struct mscl_dev *mscl;
+	struct resource *res;
+	struct mscl_driverdata *drv_data = mscl_get_drv_data(pdev);
+	struct device *dev = &pdev->dev;
+	int ret = 0;
+
+	if (!dev->of_node) {
+		dev_err(dev, "Invalid device node\n");
+		return -EINVAL;
+	}
+
+	mscl = devm_kzalloc(dev, sizeof(struct mscl_dev), GFP_KERNEL);
+	if (!mscl)
+		return -ENOMEM;
+
+	mscl->id = of_alias_get_id(pdev->dev.of_node, "mscl");
+	if (mscl->id < 0 || mscl->id >= drv_data->num_entities) {
+		dev_err(dev, "Invalid platform device id: %d\n", mscl->id);
+		return -EINVAL;
+	}
+
+	mscl->variant = drv_data->variant[mscl->id];
+	mscl->pdev = pdev;
+	mscl->pdata = dev->platform_data;
+
+	init_waitqueue_head(&mscl->irq_queue);
+	spin_lock_init(&mscl->slock);
+	mutex_init(&mscl->lock);
+	mscl->clock = ERR_PTR(-EINVAL);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	mscl->regs = devm_request_and_ioremap(dev, res);
+	if (!mscl->regs)
+		return -ENODEV;
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		dev_err(dev, "failed to get IRQ resource\n");
+		return -ENXIO;
+	}
+
+	ret = mscl_clk_get(mscl);
+	if (ret)
+		return ret;
+
+	if (mscl_iommu_init(mscl)) {
+		dev_err(&pdev->dev, "IOMMU Initialization failed\n");
+		return -EINVAL;
+	}
+
+	ret = devm_request_irq(dev, res->start, mscl_irq_handler,
+				0, pdev->name, mscl);
+	if (ret) {
+		dev_err(dev, "failed to install irq (%d)\n", ret);
+		goto err_clk;
+	}
+
+	ret = mscl_register_m2m_device(mscl);
+	if (ret)
+		goto err_clk;
+
+	platform_set_drvdata(pdev, mscl);
+	pm_runtime_enable(dev);
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (ret < 0)
+		goto err_m2m;
+
+	/* Initialize continious memory allocator */
+	mscl->alloc_ctx = vb2_dma_contig_init_ctx(dev);
+	if (IS_ERR(mscl->alloc_ctx)) {
+		ret = PTR_ERR(mscl->alloc_ctx);
+		goto err_pm;
+	}
+
+	dev_err(dev, "mscl-%d registered successfully\n", mscl->id);
+
+	pm_runtime_put(dev);
+	return 0;
+err_pm:
+	pm_runtime_put(dev);
+err_m2m:
+	mscl_unregister_m2m_device(mscl);
+err_clk:
+	mscl_iommu_deinit(mscl);
+	mscl_clk_put(mscl);
+	return ret;
+}
+
+static int mscl_remove(struct platform_device *pdev)
+{
+	struct mscl_dev *mscl = platform_get_drvdata(pdev);
+
+	mscl_unregister_m2m_device(mscl);
+
+	vb2_dma_contig_cleanup_ctx(mscl->alloc_ctx);
+	pm_runtime_disable(&pdev->dev);
+	mscl_iommu_deinit(mscl);
+	mscl_clk_put(mscl);
+
+	dev_dbg(&pdev->dev, "%s driver unloaded\n", pdev->name);
+	return 0;
+}
+
+static int mscl_runtime_resume(struct device *dev)
+{
+	struct mscl_dev *mscl = dev_get_drvdata(dev);
+	int ret = 0;
+
+	dev_dbg(dev, "mscl%d: state: 0x%lx", mscl->id, mscl->state);
+
+	ret = clk_enable(mscl->clock);
+	if (ret)
+		return ret;
+
+	mscl_sw_reset(mscl);
+
+	return mscl_m2m_resume(mscl);
+}
+
+static int mscl_runtime_suspend(struct device *dev)
+{
+	struct mscl_dev *mscl = dev_get_drvdata(dev);
+	int ret = 0;
+
+	ret = mscl_m2m_suspend(mscl);
+	if (!ret)
+		clk_disable(mscl->clock);
+
+	dev_dbg(dev, "mscl%d: state: 0x%lx", mscl->id, mscl->state);
+	return ret;
+}
+
+static int mscl_resume(struct device *dev)
+{
+	struct mscl_dev *mscl = dev_get_drvdata(dev);
+	unsigned long flags;
+
+	dev_dbg(dev, "mscl%d: state: 0x%lx", mscl->id, mscl->state);
+
+	/* Do not resume if the device was idle before system suspend */
+	spin_lock_irqsave(&mscl->slock, flags);
+	if (!test_and_clear_bit(ST_SUSPEND, &mscl->state) ||
+	    !mscl_m2m_active(mscl)) {
+		spin_unlock_irqrestore(&mscl->slock, flags);
+		return 0;
+	}
+
+	mscl_sw_reset(mscl);
+	spin_unlock_irqrestore(&mscl->slock, flags);
+
+	return mscl_m2m_resume(mscl);
+}
+
+static int mscl_suspend(struct device *dev)
+{
+	struct mscl_dev *mscl = dev_get_drvdata(dev);
+
+	dev_dbg(dev, "mscl%d: state: 0x%lx", mscl->id, mscl->state);
+
+	if (test_and_set_bit(ST_SUSPEND, &mscl->state))
+		return 0;
+
+	return mscl_m2m_suspend(mscl);
+}
+
+static const struct dev_pm_ops mscl_pm_ops = {
+	.suspend		= mscl_suspend,
+	.resume			= mscl_resume,
+	.runtime_suspend	= mscl_runtime_suspend,
+	.runtime_resume		= mscl_runtime_resume,
+};
+
+static struct platform_driver mscl_driver = {
+	.probe		= mscl_probe,
+	.remove		= mscl_remove,
+	.id_table	= mscl_driver_ids,
+	.driver = {
+		.name	= MSCL_MODULE_NAME,
+		.owner	= THIS_MODULE,
+		.pm	= &mscl_pm_ops,
+		.of_match_table = exynos_mscl_match,
+	}
+};
+
+module_platform_driver(mscl_driver);
+
+MODULE_AUTHOR("Shaik Ameer Basha <shaik.ameer@samsung.com>");
+MODULE_DESCRIPTION("Samsung EXYNOS5 Soc series M2M Scaler driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/exynos-mscl/mscl-core.h b/drivers/media/platform/exynos-mscl/mscl-core.h
new file mode 100644
index 0000000..32e94b7
--- /dev/null
+++ b/drivers/media/platform/exynos-mscl/mscl-core.h
@@ -0,0 +1,554 @@
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
+#ifndef MSCL_CORE_H_
+#define MSCL_CORE_H_
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
+#include "mscl-regs.h"
+
+#define CONFIG_VB2_MSCL_DMA_CONTIG	1
+#define MSCL_MODULE_NAME		"exynos-mscl"
+
+#define MSCL_SHUTDOWN_TIMEOUT		((100*HZ)/1000)
+#define MSCL_MAX_DEVS			4
+#define MSCL_MAX_CTRL_NUM		10
+#define MSCL_SC_ALIGN_4			4
+#define MSCL_SC_ALIGN_2			2
+#define DEFAULT_CSC_EQ			1
+#define DEFAULT_CSC_RANGE		1
+
+#define MSCL_PARAMS			(1 << 0)
+#define MSCL_SRC_FMT			(1 << 1)
+#define MSCL_DST_FMT			(1 << 2)
+#define MSCL_CTX_M2M			(1 << 3)
+#define MSCL_CTX_STOP_REQ		(1 << 4)
+
+enum mscl_dev_flags {
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
+enum mscl_irq {
+	MSCL_INT_FRAME_END = 0,
+	MSCL_INT_ILLEGAL_SRC_COLOR,
+	MSCL_INT_ILLEGAL_SRC_Y_BASE,
+	MSCL_INT_ILLEGAL_SRC_CB_BASE,
+	MSCL_INT_ILLEGAL_SRC_CR_BASE,
+	MSCL_INT_ILLEGAL_SRC_Y_SPAN,
+	MSCL_INT_ILLEGAL_SRC_C_SPAN,
+	MSCL_INT_ILLEGAL_SRC_YH_POS,
+	MSCL_INT_ILLEGAL_SRC_YV_POS,
+	MSCL_INT_ILLEGAL_SRC_CH_POS,
+	MSCL_INT_ILLEGAL_SRC_CV_POS,
+	MSCL_INT_ILLEGAL_SRC_WIDTH,
+	MSCL_INT_ILLEGAL_SRC_HEIGHT,
+	MSCL_INT_ILLEGAL_DST_COLOR,
+	MSCL_INT_ILLEGAL_DST_Y_BASE,
+	MSCL_INT_ILLEGAL_DST_CB_BASE,
+	MSCL_INT_ILLEGAL_DST_CR_BASE,
+	MSCL_INT_ILLEGAL_DST_Y_SPAN,
+	MSCL_INT_ILLEGAL_DST_C_SPAN,
+	MSCL_INT_ILLEGAL_DST_H_POS,
+	MSCL_INT_ILLEGAL_DST_V_POS,
+	MSCL_INT_ILLEGAL_DST_WIDTH,
+	MSCL_INT_ILLEGAL_DST_HEIGHT,
+	MSCL_INT_ILLEGAL_RATIO,
+	MSCL_INT_ILLEGAL_BLEND,
+	MSCL_INT_TIMEOUT,
+};
+
+enum mscl_color_fmt {
+	MSCL_RGB = (0x1 << 0),
+	MSCL_YUV420 = (0x1 << 1),
+	MSCL_YUV422 = (0x1 << 2),
+	MSCL_YUV444 = (0x1 << 3),
+};
+
+enum mscl_yuv_fmt {
+	MSCL_CBCR = 0x10,
+	MSCL_CRCB,
+};
+
+enum mscl_clr_fmt_type {
+	MSCL_FMT_SRC = (0x1 << 0),
+	MSCL_FMT_DST = (0x1 << 1),
+};
+
+enum mscl_clr_fmt {
+	MSCL_YUV420_2P_Y_UV = 0,
+	MSCL_YUV422_2P_Y_UV = 2,
+	MSCL_YUV444_2P_Y_UV,
+	MSCL_RGB565,
+	MSCL_ARGB1555,
+	MSCL_ARGB8888,
+	MSCL_PREMULTIPLIED_ARGB8888,
+	MSCL_YUV422_1P_YVYU = 9,
+	MSCL_YUV422_1P_YUYV,
+	MSCL_YUV422_1P_UYVY,
+	MSCL_ARGB4444,
+	MSCL_L8A8,
+	MSCL_RGBA8888,
+	MSCL_L8,
+	MSCL_YUV420_2P_Y_VU,
+	MSCL_YUV422_2P_Y_VU = 18,
+	MSCL_YUV444_2P_Y_VU,
+	MSCL_YUV420_3P_Y_U_V,
+	MSCL_YUV422_3P_Y_U_V = 22,
+	MSCL_YUV444_3P_Y_U_V,
+};
+
+#define fh_to_ctx(__fh) container_of(__fh, struct mscl_ctx, fh)
+#define is_rgb(fmt) (!!(((fmt)->color) & MSCL_RGB))
+#define is_yuv(fmt) ((fmt->color >= MSCL_YUV420) && (fmt->color <= MSCL_YUV444))
+#define is_yuv420(fmt) (!!((fmt->color) & MSCL_YUV420))
+#define is_yuv422(fmt) (!!((fmt->color) & MSCL_YUV422))
+#define is_yuv422_1p(fmt) (is_yuv422(fmt) && (fmt->num_planes == 1))
+#define is_yuv420_2p(fmt) (is_yuv420(fmt) && (fmt->num_planes == 2))
+#define is_yuv422_2p(fmt) (is_yuv422(fmt) && (fmt->num_planes == 2))
+#define is_yuv42x_2p(fmt) (is_yuv420_2p(fmt) || is_yuv422_2p(fmt))
+#define is_src_fmt(fmt)	((fmt->mscl_color_fmt_type) & MSCL_FMT_SRC)
+#define is_dst_fmt(fmt)	((fmt->mscl_color_fmt_type) & MSCL_FMT_DST)
+
+#define mscl_m2m_active(dev)	test_bit(ST_M2M_RUN, &(dev)->state)
+#define mscl_m2m_pending(dev)	test_bit(ST_M2M_PEND, &(dev)->state)
+#define mscl_m2m_opened(dev)	test_bit(ST_M2M_OPEN, &(dev)->state)
+
+#define ctrl_to_ctx(__ctrl) \
+	container_of((__ctrl)->handler, struct mscl_ctx, ctrl_handler)
+/**
+ * struct mscl_fmt - the driver's internal color format data
+ * @mbus_code: Media Bus pixel code, -1 if not applicable
+ * @name: format description
+ * @pixelformat: the fourcc code for this format, 0 if not applicable
+ * @yorder: Y/C order
+ * @corder: Chrominance order control
+ * @num_planes: number of physically non-contiguous data planes
+ * @num_comp: number of physically contiguous data planes
+ * @depth: per plane driver's private 'number of bits per pixel'
+ * @flags: flags indicating which operation mode format applies to
+ */
+struct mscl_fmt {
+	enum v4l2_mbus_pixelcode mbus_code;
+	enum mscl_clr_fmt mscl_color;
+	enum mscl_clr_fmt_type mscl_color_fmt_type;
+	u32	is_tiled;
+	char	*name;
+	u32	pixelformat;
+	u32	color;
+	u32	corder;
+	u16	num_planes;
+	u16	num_comp;
+	u8	depth[VIDEO_MAX_PLANES];
+	u32	flags;
+};
+
+/**
+ * struct mscl_input_buf - the driver's video buffer
+ * @vb:	videobuf2 buffer
+ * @list : linked list structure for buffer queue
+ * @idx : index of G-Scaler input buffer
+ */
+struct mscl_input_buf {
+	struct vb2_buffer	vb;
+	struct list_head	list;
+	int			idx;
+};
+
+/**
+ * struct mscl_addr - the G-Scaler physical address set
+ * @y:	 luminance plane address
+ * @cb:	 Cb plane address
+ * @cr:	 Cr plane address
+ */
+struct mscl_addr {
+	dma_addr_t y;
+	dma_addr_t cb;
+	dma_addr_t cr;
+};
+
+/* struct mscl_ctrls - the G-Scaler control set
+ * @rotate: rotation degree
+ * @hflip: horizontal flip
+ * @vflip: vertical flip
+ * @global_alpha: the alpha value of current frame
+ */
+struct mscl_ctrls {
+	struct v4l2_ctrl *rotate;
+	struct v4l2_ctrl *hflip;
+	struct v4l2_ctrl *vflip;
+	struct v4l2_ctrl *global_alpha;
+};
+
+/* struct mscl_csc_info - color space conversion information
+ *
+ */
+enum mscl_csc_coeff {
+	MSCL_CSC_COEFF_YCBCR_TO_RGB,
+	MSCL_CSC_COEFF_YCBCR_TO_RGB_OFF16,
+	MSCL_CSC_COEFF_RGB_TO_YCBCR,
+	MSCL_CSC_COEFF_RGB_TO_YCBCR_OFF16,
+	MSCL_CSC_COEFF_MAX,
+	MSCL_CSC_COEFF_NONE,
+};
+
+struct mscl_csc_info {
+	enum mscl_csc_coeff coeff_type;
+};
+
+/**
+ * struct mscl_scaler - the configuration data for G-Scaler inetrnal scaler
+ * @hratio:	the main scaler's horizontal ratio
+ * @vratio:	the main scaler's vertical ratio
+ */
+struct mscl_scaler {
+	u32 hratio;
+	u32 vratio;
+};
+
+struct mscl_dev;
+
+struct mscl_ctx;
+
+/**
+ * struct mscl_frame - source/target frame properties
+ * @f_width:	SRC : SRCIMG_WIDTH, DST : OUTPUTDMA_WHOLE_IMG_WIDTH
+ * @f_height:	SRC : SRCIMG_HEIGHT, DST : OUTPUTDMA_WHOLE_IMG_HEIGHT
+ * @crop:	cropped(source)/scaled(destination) size
+ * @payload:	image size in bytes (w x h x bpp)
+ * @addr:	image frame buffer physical addresses
+ * @fmt:	G-Scaler color format pointer
+ * @colorspace: value indicating v4l2_colorspace
+ * @alpha:	frame's alpha value
+ */
+struct mscl_frame {
+	u32 f_width;
+	u32 f_height;
+	struct v4l2_rect crop;
+	unsigned long payload[VIDEO_MAX_PLANES];
+	struct mscl_addr	addr;
+	const struct mscl_fmt *fmt;
+	u32 colorspace;
+	u8 alpha;
+};
+
+/**
+ * struct mscl_m2m_device - v4l2 memory-to-memory device data
+ * @vfd: the video device node for v4l2 m2m mode
+ * @m2m_dev: v4l2 memory-to-memory device data
+ * @ctx: hardware context data
+ * @refcnt: the reference counter
+ */
+struct mscl_m2m_device {
+	struct video_device	*vfd;
+	struct v4l2_m2m_dev	*m2m_dev;
+	struct mscl_ctx		*ctx;
+	int			refcnt;
+};
+
+/**
+ *  struct mscl_pix_input - image pixel size limits for input frame
+ *
+ */
+struct mscl_frm_limit {
+	u16	min_w;
+	u16	min_h;
+	u16	max_w;
+	u16	max_h;
+
+};
+
+struct mscl_pix_align {
+	u16 src_w_420;
+	u16 src_w_422;
+	u16 src_h_420;
+	u16 dst_w_420;
+	u16 dst_w_422;
+	u16 dst_h_420;
+};
+
+/**
+ * struct mscl_variant - M2M-Scaler variant information
+ */
+struct mscl_variant {
+	struct mscl_frm_limit	*pix_in;
+	struct mscl_frm_limit	*pix_out;
+	struct mscl_pix_align	*pix_align;
+	u16	scl_up_max;
+	u16	scl_down_max;
+	u16	in_buf_cnt;
+	u16	out_buf_cnt;
+};
+
+/**
+ * struct mscl_driverdata - per device type driver data for init time.
+ *
+ * @variant: the variant information for this driver.
+ * @lclk_frequency: G-Scaler clock frequency
+ * @num_entities: the number of g-scalers
+ */
+struct mscl_driverdata {
+	struct mscl_variant *variant[MSCL_MAX_DEVS];
+	unsigned long	lclk_frequency;
+	int		num_entities;
+};
+
+/**
+ * struct mscl_dev - abstraction for G-Scaler entity
+ * @slock: the spinlock protecting this data structure
+ * @lock: the mutex protecting this data structure
+ * @pdev: pointer to the M2M-Scaler platform device
+ * @variant: the IP variant information
+ * @id: M2M-Scaler device index (0..MSCL_MAX_DEVS)
+ * @clock: clocks required for G-Scaler operation
+ * @regs: the mapped hardware registers
+ * @irq_queue: interrupt handler waitqueue
+ * @m2m: memory-to-memory V4L2 device information
+ * @state: flags used to synchronize m2m and capture mode operation
+ * @alloc_ctx: videobuf2 memory allocator context
+ * @vdev: video device for G-Scaler instance
+ */
+struct mscl_dev {
+	spinlock_t			slock;
+	struct mutex			lock;
+	struct platform_device		*pdev;
+	struct mscl_variant		*variant;
+	u16				id;
+	struct clk			*clock;
+	void __iomem			*regs;
+	wait_queue_head_t		irq_queue;
+	struct mscl_m2m_device		m2m;
+	struct exynos_platform_msclaler	*pdata;
+	unsigned long			state;
+	struct vb2_alloc_ctx		*alloc_ctx;
+	struct video_device		vdev;
+	enum mscl_csc_coeff		coeff_type;
+#ifdef CONFIG_EXYNOS_IOMMU
+	struct dma_iommu_mapping	*mapping;
+#endif
+};
+
+/**
+ * mscl_ctx - the device context data
+ * @s_frame: source frame properties
+ * @d_frame: destination frame properties
+ * @scaler: image scaler properties
+ * @flags: additional flags for image conversion
+ * @state: flags to keep track of user configuration
+ * @mscl_dev: the G-Scaler device this context applies to
+ * @m2m_ctx: memory-to-memory device context
+ * @fh: v4l2 file handle
+ * @ctrl_handler: v4l2 controls handler
+ * @ctrls_mscl: M2M-Scaler control set
+ * @ctrls_rdy: true if the control handler is initialized
+ */
+struct mscl_ctx {
+	struct mscl_frame	s_frame;
+	struct mscl_frame	d_frame;
+	struct mscl_scaler	scaler;
+	u32			flags;
+	u32			state;
+	int			rotation;
+	unsigned int		hflip:1;
+	unsigned int		vflip:1;
+	struct mscl_dev		*mscl_dev;
+	struct v4l2_m2m_ctx	*m2m_ctx;
+	struct v4l2_fh		fh;
+	struct v4l2_ctrl_handler ctrl_handler;
+	struct mscl_ctrls	ctrls_mscl;
+	bool			ctrls_rdy;
+};
+
+void mscl_set_prefbuf(struct mscl_dev *mscl, struct mscl_frame *frm);
+int mscl_register_m2m_device(struct mscl_dev *mscl);
+void mscl_unregister_m2m_device(struct mscl_dev *mscl);
+void mscl_m2m_job_finish(struct mscl_ctx *ctx, int vb_state);
+
+u32 get_plane_size(struct mscl_frame *fr, unsigned int plane);
+const struct mscl_fmt *mscl_get_format(int index);
+const struct mscl_fmt *mscl_find_fmt(u32 *pixelformat,
+				u32 *mbus_code, u32 index);
+int mscl_enum_fmt_mplane(struct v4l2_fmtdesc *f);
+int mscl_try_fmt_mplane(struct mscl_ctx *ctx, struct v4l2_format *f);
+void mscl_set_frame_size(struct mscl_frame *frame, int width, int height);
+int mscl_g_fmt_mplane(struct mscl_ctx *ctx, struct v4l2_format *f);
+void mscl_check_crop_change(u32 tmp_w, u32 tmp_h, u32 *w, u32 *h);
+int mscl_g_crop(struct mscl_ctx *ctx, struct v4l2_crop *cr);
+int mscl_try_crop(struct mscl_ctx *ctx, struct v4l2_crop *cr);
+int mscl_cal_prescaler_ratio(struct mscl_variant *var, u32 src, u32 dst,
+							u32 *ratio);
+void mscl_get_prescaler_shfactor(u32 hratio, u32 vratio, u32 *sh);
+void mscl_check_src_scale_info(struct mscl_variant *var,
+				struct mscl_frame *s_frame,
+				u32 *wratio, u32 tx, u32 ty, u32 *hratio);
+int mscl_check_scaler_ratio(struct mscl_variant *var, int sw, int sh, int dw,
+			   int dh, int rot);
+int mscl_set_scaler_info(struct mscl_ctx *ctx);
+int mscl_ctrls_create(struct mscl_ctx *ctx);
+void mscl_ctrls_delete(struct mscl_ctx *ctx);
+int mscl_prepare_addr(struct mscl_ctx *ctx, struct vb2_buffer *vb,
+		     struct mscl_frame *frame, struct mscl_addr *addr);
+
+static inline void mscl_ctx_state_lock_set(u32 state, struct mscl_ctx *ctx)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->mscl_dev->slock, flags);
+	ctx->state |= state;
+	spin_unlock_irqrestore(&ctx->mscl_dev->slock, flags);
+}
+
+static inline void mscl_ctx_state_lock_clear(u32 state, struct mscl_ctx *ctx)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->mscl_dev->slock, flags);
+	ctx->state &= ~state;
+	spin_unlock_irqrestore(&ctx->mscl_dev->slock, flags);
+}
+
+static inline int is_tiled(const struct mscl_fmt *fmt)
+{
+	return fmt->pixelformat == V4L2_PIX_FMT_NV12MT_16X16;
+}
+
+static inline void mscl_hw_src_y_offset_en(struct mscl_dev *dev, bool on)
+{
+	u32 cfg;
+
+	cfg = readl(dev->regs + MSCL_CFG);
+	if (on)
+		cfg |= MSCL_CFG_CSC_Y_OFFSET_SRC_EN;
+	else
+		cfg &= ~MSCL_CFG_CSC_Y_OFFSET_SRC_EN;
+
+	writel(cfg, dev->regs + MSCL_CFG);
+}
+
+static inline void mscl_hw_dst_y_offset_en(struct mscl_dev *dev, bool on)
+{
+	u32 cfg;
+
+	cfg = readl(dev->regs + MSCL_CFG);
+	if (on)
+		cfg |= MSCL_CFG_CSC_Y_OFFSET_DST_EN;
+	else
+		cfg &= ~MSCL_CFG_CSC_Y_OFFSET_DST_EN;
+
+	writel(cfg, dev->regs + MSCL_CFG);
+}
+
+static inline void mscl_hw_enable_control(struct mscl_dev *dev, bool on)
+{
+	u32 cfg;
+
+	if (on)
+		writel(0xFFFFFFFF, dev->regs + MSCL_INT_EN);
+
+	cfg = readl(dev->regs + MSCL_CFG);
+	cfg |= MSCL_CFG_16_BURST_MODE;
+	if (on)
+		cfg |= MSCL_CFG_START_CMD;
+	else
+		cfg &= ~MSCL_CFG_START_CMD;
+
+	dev_dbg(&dev->pdev->dev,
+		"mscl_hw_enable_control: MSCL_CFG:0x%x\n", cfg);
+
+	writel(cfg, dev->regs + MSCL_CFG);
+}
+
+static inline unsigned int mscl_hw_get_irq_status(struct mscl_dev *dev)
+{
+	return readl(dev->regs + MSCL_INT_STATUS);
+}
+
+static inline void mscl_hw_clear_irq(struct mscl_dev *dev, unsigned int irq)
+{
+	writel(irq, dev->regs + MSCL_INT_STATUS);
+}
+
+static inline void mscl_lock(struct vb2_queue *vq)
+{
+	struct mscl_ctx *ctx = vb2_get_drv_priv(vq);
+	mutex_lock(&ctx->mscl_dev->lock);
+}
+
+static inline void mscl_unlock(struct vb2_queue *vq)
+{
+	struct mscl_ctx *ctx = vb2_get_drv_priv(vq);
+	mutex_unlock(&ctx->mscl_dev->lock);
+}
+
+static inline bool mscl_ctx_state_is_set(u32 mask, struct mscl_ctx *ctx)
+{
+	unsigned long flags;
+	bool ret;
+
+	spin_lock_irqsave(&ctx->mscl_dev->slock, flags);
+	ret = (ctx->state & mask) == mask;
+	spin_unlock_irqrestore(&ctx->mscl_dev->slock, flags);
+	return ret;
+}
+
+static inline struct mscl_frame *ctx_get_frame(struct mscl_ctx *ctx,
+					      enum v4l2_buf_type type)
+{
+	struct mscl_frame *frame;
+
+	if (V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE == type) {
+		frame = &ctx->s_frame;
+	} else if (V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE == type) {
+		frame = &ctx->d_frame;
+	} else {
+		dev_dbg(&ctx->mscl_dev->pdev->dev,
+			"Wrong buffer/video queue type (%d)", type);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return frame;
+}
+
+void mscl_hw_set_sw_reset(struct mscl_dev *dev);
+int mscl_wait_reset(struct mscl_dev *dev);
+void mscl_hw_set_irq_mask(struct mscl_dev *dev, int interrupt, bool mask);
+void mscl_hw_set_input_addr(struct mscl_dev *dev, struct mscl_addr *addr);
+void mscl_hw_set_output_addr(struct mscl_dev *dev, struct mscl_addr *addr);
+void mscl_hw_set_in_size(struct mscl_ctx *ctx);
+void mscl_hw_set_in_image_format(struct mscl_ctx *ctx);
+void mscl_hw_set_out_size(struct mscl_ctx *ctx);
+void mscl_hw_set_out_image_format(struct mscl_ctx *ctx);
+void mscl_hw_set_scaler_ratio(struct mscl_ctx *ctx);
+void mscl_hw_set_rotation(struct mscl_ctx *ctx);
+void mscl_hw_address_queue_reset(struct mscl_ctx *ctx);
+void mscl_hw_set_csc_coeff(struct mscl_ctx *ctx);
+
+#endif /* MSCL_CORE_H_ */
diff --git a/drivers/media/platform/exynos-mscl/mscl-m2m.c b/drivers/media/platform/exynos-mscl/mscl-m2m.c
new file mode 100644
index 0000000..3ac6999
--- /dev/null
+++ b/drivers/media/platform/exynos-mscl/mscl-m2m.c
@@ -0,0 +1,773 @@
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
+
+#include <media/v4l2-ioctl.h>
+
+#include "mscl-core.h"
+
+static int mscl_m2m_ctx_stop_req(struct mscl_ctx *ctx)
+{
+	struct mscl_ctx *curr_ctx;
+	struct mscl_dev *mscl = ctx->mscl_dev;
+	int ret;
+
+	curr_ctx = v4l2_m2m_get_curr_priv(mscl->m2m.m2m_dev);
+	if (!mscl_m2m_pending(mscl) || (curr_ctx != ctx))
+		return 0;
+
+	mscl_ctx_state_lock_set(MSCL_CTX_STOP_REQ, ctx);
+	ret = wait_event_timeout(mscl->irq_queue,
+			!mscl_ctx_state_is_set(MSCL_CTX_STOP_REQ, ctx),
+			MSCL_SHUTDOWN_TIMEOUT);
+
+	return ret == 0 ? -ETIMEDOUT : ret;
+}
+
+static int mscl_m2m_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct mscl_ctx *ctx = q->drv_priv;
+	int ret;
+
+	ret = pm_runtime_get_sync(&ctx->mscl_dev->pdev->dev);
+
+	return ret > 0 ? 0 : ret;
+}
+
+static int mscl_m2m_stop_streaming(struct vb2_queue *q)
+{
+	struct mscl_ctx *ctx = q->drv_priv;
+	int ret;
+
+	ret = mscl_m2m_ctx_stop_req(ctx);
+	if (ret == -ETIMEDOUT)
+		mscl_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
+
+	pm_runtime_put(&ctx->mscl_dev->pdev->dev);
+
+	return 0;
+}
+
+void mscl_m2m_job_finish(struct mscl_ctx *ctx, int vb_state)
+{
+	struct vb2_buffer *src_vb, *dst_vb;
+
+	if (!ctx || !ctx->m2m_ctx)
+		return;
+
+	src_vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+	dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+
+	if (src_vb && dst_vb) {
+		v4l2_m2m_buf_done(src_vb, vb_state);
+		v4l2_m2m_buf_done(dst_vb, vb_state);
+
+		v4l2_m2m_job_finish(ctx->mscl_dev->m2m.m2m_dev,
+							ctx->m2m_ctx);
+	}
+}
+
+
+static void mscl_m2m_job_abort(void *priv)
+{
+	struct mscl_ctx *ctx = priv;
+	int ret;
+
+	ret = mscl_m2m_ctx_stop_req(ctx);
+	if (ret == -ETIMEDOUT)
+		mscl_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
+}
+
+static int mscl_get_bufs(struct mscl_ctx *ctx)
+{
+	struct mscl_frame *s_frame, *d_frame;
+	struct vb2_buffer *src_vb, *dst_vb;
+	int ret;
+
+	s_frame = &ctx->s_frame;
+	d_frame = &ctx->d_frame;
+
+	src_vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	ret = mscl_prepare_addr(ctx, src_vb, s_frame, &s_frame->addr);
+	if (ret)
+		return ret;
+
+	dst_vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	ret = mscl_prepare_addr(ctx, dst_vb, d_frame, &d_frame->addr);
+	if (ret)
+		return ret;
+
+	dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
+
+	return 0;
+}
+
+static void mscl_m2m_device_run(void *priv)
+{
+	struct mscl_ctx *ctx = priv;
+	struct mscl_dev *mscl;
+	unsigned long flags;
+	int ret;
+	bool is_set = false;
+
+	if (WARN(!ctx, "null hardware context\n"))
+		return;
+
+	mscl = ctx->mscl_dev;
+	spin_lock_irqsave(&mscl->slock, flags);
+
+	set_bit(ST_M2M_PEND, &mscl->state);
+
+	/* Reconfigure hardware if the context has changed. */
+	if (mscl->m2m.ctx != ctx) {
+		dev_dbg(&mscl->pdev->dev,
+			"mscl->m2m.ctx = 0x%p, current_ctx = 0x%p",
+			mscl->m2m.ctx, ctx);
+		ctx->state |= MSCL_PARAMS;
+		mscl->m2m.ctx = ctx;
+	}
+
+	is_set = (ctx->state & MSCL_CTX_STOP_REQ) ? 1 : 0;
+	ctx->state &= ~MSCL_CTX_STOP_REQ;
+	if (is_set) {
+		wake_up(&mscl->irq_queue);
+		goto put_device;
+	}
+
+	ret = mscl_get_bufs(ctx);
+	if (ret) {
+		dev_dbg(&mscl->pdev->dev, "Wrong address");
+		goto put_device;
+	}
+
+	mscl_hw_address_queue_reset(ctx);
+	mscl_set_prefbuf(mscl, &ctx->s_frame);
+	mscl_hw_set_input_addr(mscl, &ctx->s_frame.addr);
+	mscl_hw_set_output_addr(mscl, &ctx->d_frame.addr);
+	mscl_hw_set_csc_coeff(ctx);
+
+	if (ctx->state & MSCL_PARAMS) {
+		mscl_hw_set_irq_mask(mscl, MSCL_INT_FRAME_END, false);
+		if (mscl_set_scaler_info(ctx)) {
+			dev_dbg(&mscl->pdev->dev, "Scaler setup error");
+			goto put_device;
+		}
+
+		mscl_hw_set_in_size(ctx);
+		mscl_hw_set_in_image_format(ctx);
+
+		mscl_hw_set_out_size(ctx);
+		mscl_hw_set_out_image_format(ctx);
+
+		mscl_hw_set_scaler_ratio(ctx);
+		mscl_hw_set_rotation(ctx);
+	}
+
+	ctx->state &= ~MSCL_PARAMS;
+	mscl_hw_enable_control(mscl, true);
+
+	spin_unlock_irqrestore(&mscl->slock, flags);
+	return;
+
+put_device:
+	ctx->state &= ~MSCL_PARAMS;
+	spin_unlock_irqrestore(&mscl->slock, flags);
+}
+
+static int mscl_m2m_queue_setup(struct vb2_queue *vq,
+			const struct v4l2_format *fmt,
+			unsigned int *num_buffers, unsigned int *num_planes,
+			unsigned int sizes[], void *allocators[])
+{
+	struct mscl_ctx *ctx = vb2_get_drv_priv(vq);
+	struct mscl_frame *frame;
+	int i;
+
+	frame = ctx_get_frame(ctx, vq->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	if (!frame->fmt)
+		return -EINVAL;
+
+	*num_planes = frame->fmt->num_planes;
+	for (i = 0; i < frame->fmt->num_planes; i++) {
+		sizes[i] = frame->payload[i];
+		allocators[i] = ctx->mscl_dev->alloc_ctx;
+	}
+	return 0;
+}
+
+static int mscl_m2m_buf_prepare(struct vb2_buffer *vb)
+{
+	struct mscl_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct mscl_frame *frame;
+	int i;
+
+	frame = ctx_get_frame(ctx, vb->vb2_queue->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	if (!V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
+		for (i = 0; i < frame->fmt->num_planes; i++)
+			vb2_set_plane_payload(vb, i, frame->payload[i]);
+	}
+
+	return 0;
+}
+
+static void mscl_m2m_buf_queue(struct vb2_buffer *vb)
+{
+	struct mscl_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+
+	dev_dbg(&ctx->mscl_dev->pdev->dev,
+		"ctx: %p, ctx->state: 0x%x", ctx, ctx->state);
+
+	if (ctx->m2m_ctx)
+		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+}
+
+static struct vb2_ops mscl_m2m_qops = {
+	.queue_setup	 = mscl_m2m_queue_setup,
+	.buf_prepare	 = mscl_m2m_buf_prepare,
+	.buf_queue	 = mscl_m2m_buf_queue,
+	.wait_prepare	 = mscl_unlock,
+	.wait_finish	 = mscl_lock,
+	.stop_streaming	 = mscl_m2m_stop_streaming,
+	.start_streaming = mscl_m2m_start_streaming,
+};
+
+static int mscl_m2m_querycap(struct file *file, void *fh,
+			   struct v4l2_capability *cap)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+	struct mscl_dev *mscl = ctx->mscl_dev;
+
+	strlcpy(cap->driver, mscl->pdev->name, sizeof(cap->driver));
+	strlcpy(cap->card, mscl->pdev->name, sizeof(cap->card));
+	strlcpy(cap->bus_info, "platform", sizeof(cap->bus_info));
+	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE |
+		V4L2_CAP_VIDEO_CAPTURE_MPLANE |	V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
+	return 0;
+}
+
+static int mscl_m2m_enum_fmt_mplane(struct file *file, void *priv,
+				struct v4l2_fmtdesc *f)
+{
+	return mscl_enum_fmt_mplane(f);
+}
+
+static int mscl_m2m_g_fmt_mplane(struct file *file, void *fh,
+			     struct v4l2_format *f)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+
+	return mscl_g_fmt_mplane(ctx, f);
+}
+
+static int mscl_m2m_try_fmt_mplane(struct file *file, void *fh,
+				  struct v4l2_format *f)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+
+	return mscl_try_fmt_mplane(ctx, f);
+}
+
+static int mscl_m2m_s_fmt_mplane(struct file *file, void *fh,
+				 struct v4l2_format *f)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+	struct vb2_queue *vq;
+	struct mscl_frame *frame;
+	struct v4l2_pix_format_mplane *pix;
+	int i, ret = 0;
+
+	ret = mscl_m2m_try_fmt_mplane(file, fh, f);
+	if (ret)
+		return ret;
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+
+	if (vb2_is_streaming(vq)) {
+		dev_dbg(&ctx->mscl_dev->pdev->dev, "queue (%d) busy", f->type);
+		return -EBUSY;
+	}
+
+	if (V4L2_TYPE_IS_OUTPUT(f->type))
+		frame = &ctx->s_frame;
+	else
+		frame = &ctx->d_frame;
+
+	pix = &f->fmt.pix_mp;
+	frame->fmt = mscl_find_fmt(&pix->pixelformat, NULL, 0);
+	frame->colorspace = pix->colorspace;
+	if (!frame->fmt)
+		return -EINVAL;
+
+	for (i = 0; i < frame->fmt->num_planes; i++)
+		frame->payload[i] = pix->plane_fmt[i].sizeimage;
+
+	mscl_set_frame_size(frame, pix->width, pix->height);
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		mscl_ctx_state_lock_set(MSCL_PARAMS | MSCL_DST_FMT, ctx);
+	else
+		mscl_ctx_state_lock_set(MSCL_PARAMS | MSCL_SRC_FMT, ctx);
+
+	dev_dbg(&ctx->mscl_dev->pdev->dev, "f_w: %d, f_h: %d",
+					   frame->f_width, frame->f_height);
+
+	return 0;
+}
+
+static int mscl_m2m_reqbufs(struct file *file, void *fh,
+			  struct v4l2_requestbuffers *reqbufs)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+	struct mscl_dev *mscl = ctx->mscl_dev;
+	struct mscl_frame *frame;
+	u32 max_cnt;
+
+	max_cnt = (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) ?
+		mscl->variant->in_buf_cnt : mscl->variant->out_buf_cnt;
+	if (reqbufs->count > max_cnt) {
+		return -EINVAL;
+	} else if (reqbufs->count == 0) {
+		if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+			mscl_ctx_state_lock_clear(MSCL_SRC_FMT, ctx);
+		else
+			mscl_ctx_state_lock_clear(MSCL_DST_FMT, ctx);
+	}
+
+	frame = ctx_get_frame(ctx, reqbufs->type);
+
+	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
+}
+
+static int mscl_m2m_expbuf(struct file *file, void *fh,
+				struct v4l2_exportbuffer *eb)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+	return v4l2_m2m_expbuf(file, ctx->m2m_ctx, eb);
+}
+
+static int mscl_m2m_querybuf(struct file *file, void *fh,
+					struct v4l2_buffer *buf)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
+}
+
+static int mscl_m2m_qbuf(struct file *file, void *fh,
+			  struct v4l2_buffer *buf)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int mscl_m2m_dqbuf(struct file *file, void *fh,
+			   struct v4l2_buffer *buf)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int mscl_m2m_streamon(struct file *file, void *fh,
+			   enum v4l2_buf_type type)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+
+	/* The source and target color format need to be set */
+	if (V4L2_TYPE_IS_OUTPUT(type)) {
+		if (!mscl_ctx_state_is_set(MSCL_SRC_FMT, ctx))
+			return -EINVAL;
+	} else if (!mscl_ctx_state_is_set(MSCL_DST_FMT, ctx)) {
+		return -EINVAL;
+	}
+
+	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
+}
+
+static int mscl_m2m_streamoff(struct file *file, void *fh,
+			    enum v4l2_buf_type type)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
+}
+
+/* Return 1 if rectangle a is enclosed in rectangle b, or 0 otherwise. */
+static int is_rectangle_enclosed(struct v4l2_rect *a, struct v4l2_rect *b)
+{
+	if (a->left < b->left || a->top < b->top)
+		return 0;
+
+	if (a->left + a->width > b->left + b->width)
+		return 0;
+
+	if (a->top + a->height > b->top + b->height)
+		return 0;
+
+	return 1;
+}
+
+static int mscl_m2m_g_selection(struct file *file, void *fh,
+			struct v4l2_selection *s)
+{
+	struct mscl_frame *frame;
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+
+	if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) &&
+	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE))
+		return -EINVAL;
+
+	frame = ctx_get_frame(ctx, s->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = frame->f_width;
+		s->r.height = frame->f_height;
+		return 0;
+
+	case V4L2_SEL_TGT_COMPOSE:
+	case V4L2_SEL_TGT_CROP:
+		s->r.left = frame->crop.left;
+		s->r.top = frame->crop.top;
+		s->r.width = frame->crop.width;
+		s->r.height = frame->crop.height;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int mscl_m2m_s_selection(struct file *file, void *fh,
+				struct v4l2_selection *s)
+{
+	struct mscl_frame *frame;
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+	struct v4l2_crop cr;
+	struct mscl_variant *variant = ctx->mscl_dev->variant;
+	int ret;
+
+	cr.type = s->type;
+	cr.c = s->r;
+
+	if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) &&
+	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE))
+		return -EINVAL;
+
+	ret = mscl_try_crop(ctx, &cr);
+	if (ret)
+		return ret;
+
+	if (s->flags & V4L2_SEL_FLAG_LE &&
+	    !is_rectangle_enclosed(&cr.c, &s->r))
+		return -ERANGE;
+
+	if (s->flags & V4L2_SEL_FLAG_GE &&
+	    !is_rectangle_enclosed(&s->r, &cr.c))
+		return -ERANGE;
+
+	s->r = cr.c;
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+	case V4L2_SEL_TGT_COMPOSE:
+		frame = &ctx->s_frame;
+		break;
+
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		frame = &ctx->d_frame;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	/* Check to see if scaling ratio is within supported range */
+	if (mscl_ctx_state_is_set(MSCL_DST_FMT | MSCL_SRC_FMT, ctx)) {
+		if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+			ret = mscl_check_scaler_ratio(variant, cr.c.width,
+				cr.c.height, ctx->d_frame.crop.width,
+				ctx->d_frame.crop.height,
+				ctx->ctrls_mscl.rotate->val);
+		} else {
+			ret = mscl_check_scaler_ratio(variant,
+				ctx->s_frame.crop.width,
+				ctx->s_frame.crop.height, cr.c.width,
+				cr.c.height, ctx->ctrls_mscl.rotate->val);
+		}
+
+		if (ret) {
+			dev_dbg(&ctx->mscl_dev->pdev->dev,
+				"Out of scaler range");
+			return -EINVAL;
+		}
+	}
+
+	frame->crop = cr.c;
+
+	mscl_ctx_state_lock_set(MSCL_PARAMS, ctx);
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops mscl_m2m_ioctl_ops = {
+	.vidioc_querycap		= mscl_m2m_querycap,
+	.vidioc_enum_fmt_vid_cap_mplane	= mscl_m2m_enum_fmt_mplane,
+	.vidioc_enum_fmt_vid_out_mplane	= mscl_m2m_enum_fmt_mplane,
+	.vidioc_g_fmt_vid_cap_mplane	= mscl_m2m_g_fmt_mplane,
+	.vidioc_g_fmt_vid_out_mplane	= mscl_m2m_g_fmt_mplane,
+	.vidioc_try_fmt_vid_cap_mplane	= mscl_m2m_try_fmt_mplane,
+	.vidioc_try_fmt_vid_out_mplane	= mscl_m2m_try_fmt_mplane,
+	.vidioc_s_fmt_vid_cap_mplane	= mscl_m2m_s_fmt_mplane,
+	.vidioc_s_fmt_vid_out_mplane	= mscl_m2m_s_fmt_mplane,
+	.vidioc_reqbufs			= mscl_m2m_reqbufs,
+	.vidioc_expbuf                  = mscl_m2m_expbuf,
+	.vidioc_querybuf		= mscl_m2m_querybuf,
+	.vidioc_qbuf			= mscl_m2m_qbuf,
+	.vidioc_dqbuf			= mscl_m2m_dqbuf,
+	.vidioc_streamon		= mscl_m2m_streamon,
+	.vidioc_streamoff		= mscl_m2m_streamoff,
+	.vidioc_g_selection		= mscl_m2m_g_selection,
+	.vidioc_s_selection		= mscl_m2m_s_selection
+};
+
+static int queue_init(void *priv, struct vb2_queue *src_vq,
+			struct vb2_queue *dst_vq)
+{
+	struct mscl_ctx *ctx = priv;
+	int ret;
+
+	memset(src_vq, 0, sizeof(*src_vq));
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+	src_vq->drv_priv = ctx;
+	src_vq->ops = &mscl_m2m_qops;
+	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	memset(dst_vq, 0, sizeof(*dst_vq));
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+	dst_vq->drv_priv = ctx;
+	dst_vq->ops = &mscl_m2m_qops;
+	dst_vq->mem_ops = &vb2_dma_contig_memops;
+	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+
+	return vb2_queue_init(dst_vq);
+}
+
+static int mscl_m2m_open(struct file *file)
+{
+	struct mscl_dev *mscl = video_drvdata(file);
+	struct mscl_ctx *ctx = NULL;
+	int ret;
+
+	dev_dbg(&mscl->pdev->dev,
+		"pid: %d, state: 0x%lx", task_pid_nr(current), mscl->state);
+
+	if (mutex_lock_interruptible(&mscl->lock))
+		return -ERESTARTSYS;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
+	v4l2_fh_init(&ctx->fh, mscl->m2m.vfd);
+	ret = mscl_ctrls_create(ctx);
+	if (ret)
+		goto error_fh;
+
+	/* Use separate control handler per file handle */
+	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
+	file->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
+
+	ctx->mscl_dev = mscl;
+	/* Default color format */
+	ctx->s_frame.fmt = mscl_get_format(0);
+	ctx->d_frame.fmt = mscl_get_format(0);
+	/* Setup the device context for mem2mem mode. */
+	ctx->state = MSCL_CTX_M2M;
+	ctx->flags = 0;
+
+	ctx->m2m_ctx = v4l2_m2m_ctx_init(mscl->m2m.m2m_dev, ctx, queue_init);
+	if (IS_ERR(ctx->m2m_ctx)) {
+		dev_dbg(&mscl->pdev->dev, "Failed to initialize m2m context");
+		ret = PTR_ERR(ctx->m2m_ctx);
+		goto error_ctrls;
+	}
+
+	if (mscl->m2m.refcnt++ == 0)
+		set_bit(ST_M2M_OPEN, &mscl->state);
+
+	dev_dbg(&mscl->pdev->dev, "mscl m2m driver is opened, ctx(0x%p)", ctx);
+
+	mutex_unlock(&mscl->lock);
+	return 0;
+
+error_ctrls:
+	mscl_ctrls_delete(ctx);
+error_fh:
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	kfree(ctx);
+unlock:
+	mutex_unlock(&mscl->lock);
+	return ret;
+}
+
+static int mscl_m2m_release(struct file *file)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(file->private_data);
+	struct mscl_dev *mscl = ctx->mscl_dev;
+
+	dev_dbg(&mscl->pdev->dev, "pid: %d, state: 0x%lx, refcnt= %d",
+		task_pid_nr(current), mscl->state, mscl->m2m.refcnt);
+
+	mutex_lock(&mscl->lock);
+
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	mscl_ctrls_delete(ctx);
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+
+	if (--mscl->m2m.refcnt <= 0)
+		clear_bit(ST_M2M_OPEN, &mscl->state);
+	kfree(ctx);
+
+	mutex_unlock(&mscl->lock);
+	return 0;
+}
+
+static unsigned int mscl_m2m_poll(struct file *file,
+					struct poll_table_struct *wait)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(file->private_data);
+	struct mscl_dev *mscl = ctx->mscl_dev;
+	int ret;
+
+	if (mutex_lock_interruptible(&mscl->lock))
+		return -ERESTARTSYS;
+
+	ret = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
+	mutex_unlock(&mscl->lock);
+
+	return ret;
+}
+
+static int mscl_m2m_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(file->private_data);
+	struct mscl_dev *mscl = ctx->mscl_dev;
+	int ret;
+
+	if (mutex_lock_interruptible(&mscl->lock))
+		return -ERESTARTSYS;
+
+	ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+	mutex_unlock(&mscl->lock);
+
+	return ret;
+}
+
+static const struct v4l2_file_operations mscl_m2m_fops = {
+	.owner		= THIS_MODULE,
+	.open		= mscl_m2m_open,
+	.release	= mscl_m2m_release,
+	.poll		= mscl_m2m_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= mscl_m2m_mmap,
+};
+
+static struct v4l2_m2m_ops mscl_m2m_ops = {
+	.device_run	= mscl_m2m_device_run,
+	.job_abort	= mscl_m2m_job_abort,
+};
+
+int mscl_register_m2m_device(struct mscl_dev *mscl)
+{
+	struct platform_device *pdev;
+	int ret;
+
+	if (!mscl)
+		return -ENODEV;
+
+	pdev = mscl->pdev;
+
+	mscl->vdev.fops		= &mscl_m2m_fops;
+	mscl->vdev.ioctl_ops	= &mscl_m2m_ioctl_ops;
+	mscl->vdev.release	= video_device_release_empty;
+	mscl->vdev.lock		= &mscl->lock;
+	mscl->vdev.vfl_dir	= VFL_DIR_M2M;
+	snprintf(mscl->vdev.name, sizeof(mscl->vdev.name), "%s.%d:m2m",
+					MSCL_MODULE_NAME, mscl->id);
+
+	video_set_drvdata(&mscl->vdev, mscl);
+
+	mscl->m2m.vfd = &mscl->vdev;
+	mscl->m2m.m2m_dev = v4l2_m2m_init(&mscl_m2m_ops);
+	if (IS_ERR(mscl->m2m.m2m_dev)) {
+		dev_err(&pdev->dev, "failed to initialize v4l2-m2m device\n");
+		return PTR_ERR(mscl->m2m.m2m_dev);
+	}
+
+	ret = video_register_device(&mscl->vdev, VFL_TYPE_GRABBER, -1);
+	if (ret) {
+		dev_err(&pdev->dev,
+			 "%s(): failed to register video device\n", __func__);
+		v4l2_m2m_release(mscl->m2m.m2m_dev);
+		return ret;
+	}
+
+	dev_info(&pdev->dev,
+		 "mscl m2m driver registered as /dev/video%d", mscl->vdev.num);
+	return 0;
+}
+
+void mscl_unregister_m2m_device(struct mscl_dev *mscl)
+{
+	if (mscl)
+		v4l2_m2m_release(mscl->m2m.m2m_dev);
+}
diff --git a/drivers/media/platform/exynos-mscl/mscl-regs.c b/drivers/media/platform/exynos-mscl/mscl-regs.c
new file mode 100644
index 0000000..a0bd00f
--- /dev/null
+++ b/drivers/media/platform/exynos-mscl/mscl-regs.c
@@ -0,0 +1,386 @@
+/*
+ * Copyright (c) 2013 - 2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Samsung EXYNOS5 SoC series M2M-Scaler driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation, either version 2 of the License,
+ * or (at your option) any later version.
+ */
+
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <mach/map.h>
+
+#include "mscl-core.h"
+
+void mscl_hw_set_sw_reset(struct mscl_dev *dev)
+{
+	u32 cfg;
+
+	cfg = readl(dev->regs + MSCL_CFG);
+	cfg |= MSCL_CFG_SOFT_RESET;
+
+	writel(cfg, dev->regs + MSCL_CFG);
+}
+
+int mscl_wait_reset(struct mscl_dev *dev)
+{
+	unsigned long end = jiffies + msecs_to_jiffies(50);
+	u32 cfg, reset_done = 0;
+
+	while (time_before(jiffies, end)) {
+		cfg = readl(dev->regs + MSCL_CFG);
+		if (!(cfg & MSCL_CFG_SOFT_RESET)) {
+			reset_done = 1;
+			break;
+		}
+		usleep_range(10, 20);
+	}
+
+	/* write any value to r/w reg and read it back */
+	while (reset_done) {
+
+		/* [TBD:SAB] need to define number to tries before returning
+		 * -EBUSY to the caller
+		 */
+
+		writel(MSCL_CFG_SOFT_RESET_CHECK_VAL,
+				dev->regs + MSCL_CFG_SOFT_RESET_CHECK_REG);
+		if (MSCL_CFG_SOFT_RESET_CHECK_VAL ==
+			readl(dev->regs + MSCL_CFG_SOFT_RESET_CHECK_REG))
+			return 0;
+	}
+
+	return -EBUSY;
+}
+
+void mscl_hw_set_irq_mask(struct mscl_dev *dev, int interrupt, bool mask)
+{
+	u32 cfg;
+
+	switch (interrupt) {
+	case MSCL_INT_TIMEOUT:
+	case MSCL_INT_ILLEGAL_BLEND:
+	case MSCL_INT_ILLEGAL_RATIO:
+	case MSCL_INT_ILLEGAL_DST_HEIGHT:
+	case MSCL_INT_ILLEGAL_DST_WIDTH:
+	case MSCL_INT_ILLEGAL_DST_V_POS:
+	case MSCL_INT_ILLEGAL_DST_H_POS:
+	case MSCL_INT_ILLEGAL_DST_C_SPAN:
+	case MSCL_INT_ILLEGAL_DST_Y_SPAN:
+	case MSCL_INT_ILLEGAL_DST_CR_BASE:
+	case MSCL_INT_ILLEGAL_DST_CB_BASE:
+	case MSCL_INT_ILLEGAL_DST_Y_BASE:
+	case MSCL_INT_ILLEGAL_DST_COLOR:
+	case MSCL_INT_ILLEGAL_SRC_HEIGHT:
+	case MSCL_INT_ILLEGAL_SRC_WIDTH:
+	case MSCL_INT_ILLEGAL_SRC_CV_POS:
+	case MSCL_INT_ILLEGAL_SRC_CH_POS:
+	case MSCL_INT_ILLEGAL_SRC_YV_POS:
+	case MSCL_INT_ILLEGAL_SRC_YH_POS:
+	case MSCL_INT_ILLEGAL_SRC_C_SPAN:
+	case MSCL_INT_ILLEGAL_SRC_Y_SPAN:
+	case MSCL_INT_ILLEGAL_SRC_CR_BASE:
+	case MSCL_INT_ILLEGAL_SRC_CB_BASE:
+	case MSCL_INT_ILLEGAL_SRC_Y_BASE:
+	case MSCL_INT_ILLEGAL_SRC_COLOR:
+	case MSCL_INT_FRAME_END:
+		break;
+	default:
+		return;
+	}
+	cfg = readl(dev->regs + MSCL_INT_EN);
+	if (mask)
+		cfg |= interrupt;
+	else
+		cfg &= ~interrupt;
+	writel(cfg, dev->regs + MSCL_INT_EN);
+}
+
+void mscl_hw_set_input_addr(struct mscl_dev *dev, struct mscl_addr *addr)
+{
+	dev_dbg(&dev->pdev->dev, "src_buf: 0x%X, cb: 0x%X, cr: 0x%X",
+				addr->y, addr->cb, addr->cr);
+	writel(addr->y, dev->regs + MSCL_SRC_Y_BASE);
+	writel(addr->cb, dev->regs + MSCL_SRC_CB_BASE);
+	writel(addr->cr, dev->regs + MSCL_SRC_CR_BASE);
+}
+
+void mscl_hw_set_output_addr(struct mscl_dev *dev,
+			     struct mscl_addr *addr)
+{
+	dev_dbg(&dev->pdev->dev, "dst_buf: 0x%X, cb: 0x%X, cr: 0x%X",
+				addr->y, addr->cb, addr->cr);
+	writel(addr->y, dev->regs + MSCL_DST_Y_BASE);
+	writel(addr->cb, dev->regs + MSCL_DST_CB_BASE);
+	writel(addr->cr, dev->regs + MSCL_DST_CR_BASE);
+}
+
+void mscl_hw_set_in_size(struct mscl_ctx *ctx)
+{
+	struct mscl_dev *dev = ctx->mscl_dev;
+	struct mscl_frame *frame = &ctx->s_frame;
+	u32 cfg;
+
+	/* set input pixel offset */
+	cfg = MSCL_SRC_YH_POS(frame->crop.left);
+	cfg |= MSCL_SRC_YV_POS(frame->crop.top);
+	writel(cfg, dev->regs + MSCL_SRC_Y_POS);
+
+	/* [TBD] calculate 'C' plane h/v offset using 'Y' plane h/v offset */
+
+	/* set input span */
+	cfg = MSCL_SRC_Y_SPAN(frame->f_width);
+	if (is_yuv420_2p(frame->fmt))
+		cfg |= MSCL_SRC_C_SPAN(frame->f_width);
+	else
+		cfg |= MSCL_SRC_C_SPAN(frame->f_width); /* [TBD] Verify */
+
+	writel(cfg, dev->regs + MSCL_SRC_SPAN);
+
+	/* Set input cropped size */
+	cfg = MSCL_SRC_WIDTH(frame->crop.width);
+	cfg |= MSCL_SRC_HEIGHT(frame->crop.height);
+	writel(cfg, dev->regs + MSCL_SRC_WH);
+
+	dev_dbg(&dev->pdev->dev,
+		"src: posx: %d, posY: %d, spanY: %d, spanC: %d, "
+		"cropX: %d, cropY: %d\n",
+		frame->crop.left, frame->crop.top, frame->f_width,
+		frame->f_width, frame->crop.width, frame->crop.height);
+}
+
+void mscl_hw_set_in_image_format(struct mscl_ctx *ctx)
+{
+	struct mscl_dev *dev = ctx->mscl_dev;
+	struct mscl_frame *frame = &ctx->s_frame;
+	u32 cfg;
+
+	cfg = readl(dev->regs + MSCL_SRC_CFG);
+	cfg &= ~MSCL_SRC_COLOR_FORMAT_MASK;
+	cfg |= MSCL_SRC_COLOR_FORMAT(frame->fmt->mscl_color);
+
+	/* setting tile/linear format */
+	if (frame->fmt->is_tiled)
+		cfg |= MSCL_SRC_TILE_EN;
+	else
+		cfg &= ~MSCL_SRC_TILE_EN;
+
+	writel(cfg, dev->regs + MSCL_SRC_CFG);
+}
+
+void mscl_hw_set_out_size(struct mscl_ctx *ctx)
+{
+	struct mscl_dev *dev = ctx->mscl_dev;
+	struct mscl_frame *frame = &ctx->d_frame;
+	u32 cfg;
+
+	/* set output pixel offset */
+	cfg = MSCL_DST_H_POS(frame->crop.left);
+	cfg |= MSCL_DST_V_POS(frame->crop.top);
+	writel(cfg, dev->regs + MSCL_DST_POS);
+
+	/* set output span */
+	cfg = MSCL_DST_Y_SPAN(frame->f_width);
+	if (is_yuv420_2p(frame->fmt))
+		cfg |= MSCL_DST_C_SPAN(frame->f_width/2);
+	else
+		cfg |= MSCL_DST_C_SPAN(frame->f_width);
+	writel(cfg, dev->regs + MSCL_DST_SPAN);
+
+	/* set output scaled size */
+	cfg = MSCL_DST_WIDTH(frame->crop.width);
+	cfg |= MSCL_DST_HEIGHT(frame->crop.height);
+	writel(cfg, dev->regs + MSCL_DST_WH);
+
+	dev_dbg(&dev->pdev->dev,
+		"dst: posx: %d, posY: %d, spanY: %d, spanC: %d, "
+		"cropX: %d, cropY: %d\n",
+		frame->crop.left, frame->crop.top, frame->f_width,
+		frame->f_width, frame->crop.width, frame->crop.height);
+}
+
+void mscl_hw_set_out_image_format(struct mscl_ctx *ctx)
+{
+	struct mscl_dev *dev = ctx->mscl_dev;
+	struct mscl_frame *frame = &ctx->d_frame;
+	u32 cfg;
+
+	cfg = readl(dev->regs + MSCL_DST_CFG);
+	cfg &= ~MSCL_DST_COLOR_FORMAT_MASK;
+	cfg |= MSCL_DST_COLOR_FORMAT(frame->fmt->mscl_color);
+
+	writel(cfg, dev->regs + MSCL_DST_CFG);
+}
+
+void mscl_hw_set_scaler_ratio(struct mscl_ctx *ctx)
+{
+	struct mscl_dev *dev = ctx->mscl_dev;
+	struct mscl_scaler *sc = &ctx->scaler;
+	u32 cfg;
+
+	cfg = MSCL_H_RATIO_VALUE(sc->hratio);
+	writel(cfg, dev->regs + MSCL_H_RATIO);
+
+	cfg = MSCL_V_RATIO_VALUE(sc->vratio);
+	writel(cfg, dev->regs + MSCL_V_RATIO);
+}
+
+void mscl_hw_set_rotation(struct mscl_ctx *ctx)
+{
+	struct mscl_dev *dev = ctx->mscl_dev;
+	u32 cfg = 0;
+
+	cfg = MSCL_ROTMODE(ctx->ctrls_mscl.rotate->val/90);
+
+	if (ctx->ctrls_mscl.hflip->val)
+		cfg |= MSCL_FLIP_X_EN;
+
+	if (ctx->ctrls_mscl.vflip->val)
+		cfg |= MSCL_FLIP_Y_EN;
+
+	writel(cfg, dev->regs + MSCL_ROT_CFG);
+}
+
+void mscl_hw_address_queue_reset(struct mscl_ctx *ctx)
+{
+	struct mscl_dev *dev = ctx->mscl_dev;
+
+	writel(MSCL_ADDR_QUEUE_RST, dev->regs + MSCL_ADDR_QUEUE_CONFIG);
+}
+
+void mscl_hw_set_csc_coeff(struct mscl_ctx *ctx)
+{
+	struct mscl_dev *dev = ctx->mscl_dev;
+	enum mscl_csc_coeff type;
+	u32 cfg = 0;
+	int i, j;
+	static const u32 csc_coeff[MSCL_CSC_COEFF_MAX][3][3] = {
+		{ /* YCbCr to RGB */
+			{0x200, 0x000, 0x2be},
+			{0x200, 0xeac, 0x165},
+			{0x200, 0x377, 0x000}
+		},
+		{ /* YCbCr to RGB with -16 offset */
+			{0x254, 0x000, 0x331},
+			{0x254, 0xec8, 0xFA0},
+			{0x254, 0x409, 0x000}
+		},
+		{ /* RGB to YCbCr */
+			{0x099, 0x12d, 0x03a},
+			{0xe58, 0xeae, 0x106},
+			{0x106, 0xedb, 0xe2a}
+		},
+		{ /* RGB to YCbCr with -16 offset */
+			{0x084, 0x102, 0x032},
+			{0xe4c, 0xe95, 0x0e1},
+			{0x0e1, 0xebc, 0xe24}
+		} };
+
+	if (is_rgb(ctx->s_frame.fmt) == is_rgb(ctx->d_frame.fmt))
+		type = MSCL_CSC_COEFF_NONE;
+	else if (is_rgb(ctx->d_frame.fmt))
+		type = MSCL_CSC_COEFF_YCBCR_TO_RGB_OFF16;
+	else
+		type = MSCL_CSC_COEFF_RGB_TO_YCBCR_OFF16;
+
+	if ((type == ctx->mscl_dev->coeff_type) || (type >= MSCL_CSC_COEFF_MAX))
+		return;
+
+	for (i = 0; i < 3; i++) {
+		for (j = 0; j < 3; j++) {
+			cfg = csc_coeff[type][i][j];
+			writel(cfg, dev->regs + MSCL_CSC_COEF(i, j));
+		}
+	}
+
+	switch (type) {
+	case MSCL_CSC_COEFF_YCBCR_TO_RGB:
+		mscl_hw_src_y_offset_en(ctx->mscl_dev, false);
+		break;
+	case MSCL_CSC_COEFF_YCBCR_TO_RGB_OFF16:
+		mscl_hw_src_y_offset_en(ctx->mscl_dev, true);
+		break;
+	case MSCL_CSC_COEFF_RGB_TO_YCBCR:
+		mscl_hw_src_y_offset_en(ctx->mscl_dev, false);
+		break;
+	case MSCL_CSC_COEFF_RGB_TO_YCBCR_OFF16:
+		mscl_hw_src_y_offset_en(ctx->mscl_dev, true);
+		break;
+	default:
+		return;
+	}
+
+	ctx->mscl_dev->coeff_type = type;
+	return;
+}
+
+void mscl_hw_set_blending(struct mscl_ctx *ctx)
+{
+#if 0 /* Blending */
+
+	/* CO		[7:0]	src_color_op·CS + dst_color_op·CD
+	 * AO		[7:0]	src_alpha_op·AS + dst_color_op·AD
+	 * where
+	 * CO		[7:0]	output color
+	 * AO		[7:0]	output alpha
+	 * CS		[7:0]	SRC color selected
+	 * AS		[7:0]	SRC alpha selected
+	 * CD		[7:0]	DST color selected
+	 * AD		[7:0]	DST alpha selected
+	 * src_color_op	[7:0]	SRC color operand selected
+	 * src_alpha_op	[7:0]	SRC alpha operand selected
+	 * dst_color_op	[7:0]	DST color operand selected
+	 * dst_alpha_op	[7:0]	DST alpha operand selected
+	 */
+
+	/* Set src alpha/color blending */
+	cfg  = MSCL_SRC_COLOR_SEL(0);
+	cfg |= MSCL_SRC_COLOR_OP_SEL(0);
+	cfg |= MSCL_SRC_GLOBAL_COLOR0(0xff);
+	cfg |= MSCL_SRC_GLOBAL_COLOR1(0xff);
+	cfg |= MSCL_SRC_GLOBAL_COLOR2(0xff);
+	writel(cfg, dev->regs + MSCL_SRC_BLEND_COLOR);
+
+	cfg  = MSCL_SRC_ALPHA_SEL(0);
+	cfg |= MSCL_SRC_ALPHA_OP_SEL(0);
+	cfg |= MSCL_SRC_GLOBAL_ALPHA(0xff);
+	writel(cfg, dev->regs + MSCL_SRC_BLEND_ALPHA);
+
+	/* set dst alpha/color blending */
+	cfg  = MSCL_DST_COLOR_SEL(0);
+	cfg |= MSCL_DST_COLOR_OP_SEL(0);
+	cfg |= MSCL_DST_GLOBAL_COLOR0(0xff);
+	cfg |= MSCL_DST_GLOBAL_COLOR1(0xff);
+	cfg |= MSCL_DST_GLOBAL_COLOR2(0xff);
+	writel(cfg, dev->regs + MSCL_DST_BLEND_COLOR);
+
+	cfg  = MSCL_DST_ALPHA_SEL(0);
+	cfg |= MSCL_DST_ALPHA_OP_SEL(0);
+	cfg |= MSCL_DST_GLOBAL_ALPHA(0xff);
+	writel(cfg, dev->regs + MSCL_DST_BLEND_ALPHA);
+
+#endif
+}
+
+void mscl_hw_set_fill_color(struct mscl_ctx *ctx)
+{
+#if 0 /* fill color */
+	/* fill color */
+	cfg  = MSCL_FILL_ALPHA(0xff);
+	cfg |= MSCL_FILL_COLOR0(0xff);
+	cfg |= MSCL_FILL_COLOR1(0xff);
+	cfg |= MSCL_FILL_COLOR2(0xff);
+	writel(cfg, dev->regs + MSCL_FILL_COLOR);
+
+	/* enable fill color */
+	cfg = readl(dev->regs + MSCL_CFG);
+	cfg |= MSCL_CFG_FILL_EN;
+	writel(cfg, dev->regs + MSCL_CFG);
+#endif
+}
diff --git a/drivers/media/platform/exynos-mscl/mscl-regs.h b/drivers/media/platform/exynos-mscl/mscl-regs.h
new file mode 100644
index 0000000..874b9ff
--- /dev/null
+++ b/drivers/media/platform/exynos-mscl/mscl-regs.h
@@ -0,0 +1,282 @@
+/*
+ * Copyright (c) 2013 - 2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Register definition file for Samsung M2M-Scaler driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef REGS_MSCL_H_
+#define REGS_MSCL_H_
+
+/* m2m-scaler status */
+#define MSCL_STATUS				0x00
+#define MSCL_STATUS_RUNNING			(1 << 1)
+#define MSCL_STATUS_READY_CLK_DOWN		(1 << 0)
+
+/* m2m-scaler config */
+#define MSCL_CFG				0x04
+#define MSCL_CFG_FILL_EN			(1 << 24)
+#define MSCL_CFG_BLEND_CLR_DIV_ALPHA_EN		(1 << 17)
+#define MSCL_CFG_BLEND_EN			(1 << 16)
+#define MSCL_CFG_CSC_Y_OFFSET_SRC_EN		(1 << 10)
+#define MSCL_CFG_CSC_Y_OFFSET_DST_EN		(1 << 9)
+#define MSCL_CFG_16_BURST_MODE			(1 << 8)
+#define MSCL_CFG_SOFT_RESET			(1 << 1)
+#define MSCL_CFG_START_CMD			(1 << 0)
+
+/* m2m-scaler interrupt enable */
+#define MSCL_INT_EN				0x08
+#define MSCL_INT_EN_DEFAULT			0x81ffffff
+#define MSCL_INT_EN_TIMEOUT			(1 << 31)
+#define MSCL_INT_EN_ILLEGAL_BLEND		(1 << 24)
+#define MSCL_INT_EN_ILLEGAL_RATIO		(1 << 23)
+#define MSCL_INT_EN_ILLEGAL_DST_HEIGHT		(1 << 22)
+#define MSCL_INT_EN_ILLEGAL_DST_WIDTH		(1 << 21)
+#define MSCL_INT_EN_ILLEGAL_DST_V_POS		(1 << 20)
+#define MSCL_INT_EN_ILLEGAL_DST_H_POS		(1 << 19)
+#define MSCL_INT_EN_ILLEGAL_DST_C_SPAN		(1 << 18)
+#define MSCL_INT_EN_ILLEGAL_DST_Y_SPAN		(1 << 17)
+#define MSCL_INT_EN_ILLEGAL_DST_CR_BASE		(1 << 16)
+#define MSCL_INT_EN_ILLEGAL_DST_CB_BASE		(1 << 15)
+#define MSCL_INT_EN_ILLEGAL_DST_Y_BASE		(1 << 14)
+#define MSCL_INT_EN_ILLEGAL_DST_COLOR		(1 << 13)
+#define MSCL_INT_EN_ILLEGAL_SRC_HEIGHT		(1 << 12)
+#define MSCL_INT_EN_ILLEGAL_SRC_WIDTH		(1 << 11)
+#define MSCL_INT_EN_ILLEGAL_SRC_CV_POS		(1 << 10)
+#define MSCL_INT_EN_ILLEGAL_SRC_CH_POS		(1 << 9)
+#define MSCL_INT_EN_ILLEGAL_SRC_YV_POS		(1 << 8)
+#define MSCL_INT_EN_ILLEGAL_SRC_YH_POS		(1 << 7)
+#define MSCL_INT_EN_ILLEGAL_SRC_C_SPAN		(1 << 6)
+#define MSCL_INT_EN_ILLEGAL_SRC_Y_SPAN		(1 << 5)
+#define MSCL_INT_EN_ILLEGAL_SRC_CR_BASE		(1 << 4)
+#define MSCL_INT_EN_ILLEGAL_SRC_CB_BASE		(1 << 3)
+#define MSCL_INT_EN_ILLEGAL_SRC_Y_BASE		(1 << 2)
+#define MSCL_INT_EN_ILLEGAL_SRC_COLOR		(1 << 1)
+#define MSCL_INT_EN_FRAME_END			(1 << 0)
+
+/* m2m-scaler interrupt status */
+#define MSCL_INT_STATUS				0x0c
+#define MSCL_INT_STATUS_CLEAR			(0xffffffff)
+#define MSCL_INT_STATUS_ERROR			(0x81fffffe)
+#define MSCL_INT_STATUS_TIMEOUT			(1 << 31)
+#define MSCL_INT_STATUS_ILLEGAL_BLEND		(1 << 24)
+#define MSCL_INT_STATUS_ILLEGAL_RATIO		(1 << 23)
+#define MSCL_INT_STATUS_ILLEGAL_DST_HEIGHT	(1 << 22)
+#define MSCL_INT_STATUS_ILLEGAL_DST_WIDTH	(1 << 21)
+#define MSCL_INT_STATUS_ILLEGAL_DST_V_POS	(1 << 20)
+#define MSCL_INT_STATUS_ILLEGAL_DST_H_POS	(1 << 19)
+#define MSCL_INT_STATUS_ILLEGAL_DST_C_SPAN	(1 << 18)
+#define MSCL_INT_STATUS_ILLEGAL_DST_Y_SPAN	(1 << 17)
+#define MSCL_INT_STATUS_ILLEGAL_DST_CR_BASE	(1 << 16)
+#define MSCL_INT_STATUS_ILLEGAL_DST_CB_BASE	(1 << 15)
+#define MSCL_INT_STATUS_ILLEGAL_DST_Y_BASE	(1 << 14)
+#define MSCL_INT_STATUS_ILLEGAL_DST_COLOR	(1 << 13)
+#define MSCL_INT_STATUS_ILLEGAL_SRC_HEIGHT	(1 << 12)
+#define MSCL_INT_STATUS_ILLEGAL_SRC_WIDTH	(1 << 11)
+#define MSCL_INT_STATUS_ILLEGAL_SRC_CV_POS	(1 << 10)
+#define MSCL_INT_STATUS_ILLEGAL_SRC_CH_POS	(1 << 9)
+#define MSCL_INT_STATUS_ILLEGAL_SRC_YV_POS	(1 << 8)
+#define MSCL_INT_STATUS_ILLEGAL_SRC_YH_POS	(1 << 7)
+#define MSCL_INT_STATUS_ILLEGAL_SRC_C_SPAN	(1 << 6)
+#define MSCL_INT_STATUS_ILLEGAL_SRC_Y_SPAN	(1 << 5)
+#define MSCL_INT_STATUS_ILLEGAL_SRC_CR_BASE	(1 << 4)
+#define MSCL_INT_STATUS_ILLEGAL_SRC_CB_BASE	(1 << 3)
+#define MSCL_INT_STATUS_ILLEGAL_SRC_Y_BASE	(1 << 2)
+#define MSCL_INT_STATUS_ILLEGAL_SRC_COLOR	(1 << 1)
+#define MSCL_INT_STATUS_FRAME_END		(1 << 0)
+
+/* m2m-scaler source format configuration */
+#define MSCL_SRC_CFG				0x10
+#define MSCL_SRC_TILE_EN			(0x1 << 10)
+#define MSCL_SRC_BYTE_SWAP_MASK			(0x3 << 5)
+#define MSCL_SRC_BYTE_SWAP(x)			(((x) & 0x3) << 5)
+#define MSCL_SRC_COLOR_FORMAT_MASK		(0xf << 0)
+#define MSCL_SRC_COLOR_FORMAT(x)		(((x) & 0xf) << 0)
+
+/* m2m-scaler source y-base */
+#define MSCL_SRC_Y_BASE				0x14
+
+/* m2m-scaler source cb-base */
+#define MSCL_SRC_CB_BASE			0x18
+
+/* m2m-scaler source cr-base */
+#define MSCL_SRC_CR_BASE			0x294
+
+/* m2m-scaler source span */
+#define MSCL_SRC_SPAN				0x1c
+#define MSCL_SRC_C_SPAN_MASK			(0x3fff << 16)
+#define MSCL_SRC_C_SPAN(x)			(((x) & 0x3fff) << 16)
+#define MSCL_SRC_Y_SPAN_MASK			(0x3fff << 0)
+#define MSCL_SRC_Y_SPAN(x)			(((x) & 0x3fff) << 0)
+
+/* m2m-scaler source y-position */
+#define MSCL_SRC_Y_POS				0x20
+#define MSCL_SRC_YH_POS_MASK			(0xffff << (16 + 2))
+#define MSCL_SRC_YH_POS(x)			(((x) & 0xffff) << (16 + 2))
+#define MSCL_SRC_YV_POS_MASK			(0xffff << (0 + 2))
+#define MSCL_SRC_YV_POS(x)			(((x) & 0xffff) << (0 + 2))
+
+/* m2m-scaler source width/height */
+#define MSCL_SRC_WH				0x24
+#define MSCL_SRC_WIDTH_MASK			(0x3fff << 16)
+#define MSCL_SRC_WIDTH(x)			(((x) & 0x3fff) << 16)
+#define MSCL_SRC_HEIGHT_MASK			(0x3fff << 0)
+#define MSCL_SRC_HEIGHT(x)			(((x) & 0x3fff) << 0)
+
+/* m2m-scaler source c-position */
+#define MSCL_SRC_C_POS				0x28
+#define MSCL_SRC_CH_POS_MASK			(0xffff << (16 + 2))
+#define MSCL_SRC_CH_POS(x)			(((x) & 0xffff) << (16 + 2))
+#define MSCL_SRC_CV_POS_MASK			(0xffff << (0 + 2))
+#define MSCL_SRC_CV_POS(x)			(((x) & 0xffff) << (0 + 2))
+
+/* m2m-scaler destination format configuration */
+#define MSCL_DST_CFG				0x30
+#define MSCL_DST_BYTE_SWAP_MASK			(0x3 << 5)
+#define MSCL_DST_BYTE_SWAP(x)			(((x) & 0x3) << 5)
+#define MSCL_DST_COLOR_FORMAT_MASK		(0xf << 0)
+#define MSCL_DST_COLOR_FORMAT(x)		(((x) & 0xf) << 0)
+
+/* m2m-scaler destination y-base */
+#define MSCL_DST_Y_BASE				0x34
+
+/* m2m-scaler destination cb-base */
+#define MSCL_DST_CB_BASE			0x38
+
+/* m2m-scaler destination cr-base */
+#define MSCL_DST_CR_BASE			0x298
+
+/* m2m-scaler destination span */
+#define MSCL_DST_SPAN				0x3c
+#define MSCL_DST_C_SPAN_MASK			(0x3fff << 16)
+#define MSCL_DST_C_SPAN(x)			(((x) & 0x3fff) << 16)
+#define MSCL_DST_Y_SPAN_MASK			(0x3fff << 0)
+#define MSCL_DST_Y_SPAN(x)			(((x) & 0x3fff) << 0)
+
+/* m2m-scaler destination width/height */
+#define MSCL_DST_WH				0x40
+#define MSCL_DST_WIDTH_MASK			(0x3fff << 16)
+#define MSCL_DST_WIDTH(x)			(((x) & 0x3fff) << 16)
+#define MSCL_DST_HEIGHT_MASK			(0x3fff << 0)
+#define MSCL_DST_HEIGHT(x)			(((x) & 0x3fff) << 0)
+
+/* m2m-scaler destination position */
+#define MSCL_DST_POS				0x44
+#define MSCL_DST_H_POS_MASK			(0x3fff << 16)
+#define MSCL_DST_H_POS(x)			(((x) & 0x3fff) << 16)
+#define MSCL_DST_V_POS_MASK			(0x3fff << 0)
+#define MSCL_DST_V_POS(x)			(((x) & 0x3fff) << 0)
+
+/* m2m-scaler horizontal scale ratio */
+#define MSCL_H_RATIO				0x50
+#define MSCL_H_RATIO_VALUE(x)			(((x) & 0x7ffff) << 0)
+
+/* m2m-scaler vertical scale ratio */
+#define MSCL_V_RATIO				0x54
+#define MSCL_V_RATIO_VALUE(x)			(((x) & 0x7ffff) << 0)
+
+/* m2m-scaler rotation config */
+#define MSCL_ROT_CFG				0x58
+#define MSCL_FLIP_X_EN				(1 << 3)
+#define MSCL_FLIP_Y_EN				(1 << 2)
+#define MSCL_ROTMODE_MASK			(0x3 << 0)
+#define MSCL_ROTMODE(x)				(((x) & 0x3) << 0)
+
+/* m2m-scaler csc coefficients */
+#define MSCL_CSC_COEF_00			0x220
+#define MSCL_CSC_COEF_10			0x224
+#define MSCL_CSC_COEF_20			0x228
+#define MSCL_CSC_COEF_01			0x22C
+#define MSCL_CSC_COEF_11			0x230
+#define MSCL_CSC_COEF_21			0x234
+#define MSCL_CSC_COEF_02			0x238
+#define MSCL_CSC_COEF_12			0x23C
+#define MSCL_CSC_COEF_22			0x240
+
+#define MSCL_CSC_COEF(x, y)			(0x220 + ((x * 12) + (y * 4)))
+
+/* m2m-scaler dither config */
+#define MSCL_DITH_CFG				0x250
+#define MSCL_DITHER_R_TYPE_MASK			(0x7 << 6)
+#define MSCL_DITHER_R_TYPE(x)			(((x) & 0x7) << 6)
+#define MSCL_DITHER_G_TYPE_MASK			(0x7 << 3)
+#define MSCL_DITHER_G_TYPE(x)			(((x) & 0x7) << 3)
+#define MSCL_DITHER_B_TYPE_MASK			(0x7 << 0)
+#define MSCL_DITHER_B_TYPE(x)			(((x) & 0x7) << 0)
+
+/* m2m-scaler src blend color */
+#define MSCL_SRC_BLEND_COLOR			0x280
+#define MSCL_SRC_COLOR_SEL_INV			(1 << 31)
+#define MSCL_SRC_COLOR_SEL_MASK			(0x3 << 29)
+#define MSCL_SRC_COLOR_SEL(x)			(((x) & 0x3) << 29)
+#define MSCL_SRC_COLOR_OP_SEL_INV		(1 << 28)
+#define MSCL_SRC_COLOR_OP_SEL_MASK		(0xf << 24)
+#define MSCL_SRC_COLOR_OP_SEL(x)		(((x) & 0xf) << 24)
+#define MSCL_SRC_GLOBAL_COLOR0_MASK		(0xff << 16)
+#define MSCL_SRC_GLOBAL_COLOR0(x)		(((x) & 0xff) << 16)
+#define MSCL_SRC_GLOBAL_COLOR1_MASK		(0xff << 8)
+#define MSCL_SRC_GLOBAL_COLOR1(x)		(((x) & 0xff) << 8)
+#define MSCL_SRC_GLOBAL_COLOR2_MASK		(0xff << 0)
+#define MSCL_SRC_GLOBAL_COLOR2(x)		(((x) & 0xff) << 0)
+
+/* m2m-scaler src blend alpha */
+#define MSCL_SRC_BLEND_ALPHA			0x284
+#define MSCL_SRC_ALPHA_SEL_INV			(1 << 31)
+#define MSCL_SRC_ALPHA_SEL_MASK			(0x3 << 29)
+#define MSCL_SRC_ALPHA_SEL(x)			(((x) & 0x3) << 29)
+#define MSCL_SRC_ALPHA_OP_SEL_INV		(1 << 28)
+#define MSCL_SRC_ALPHA_OP_SEL_MASK		(0xf << 24)
+#define MSCL_SRC_ALPHA_OP_SEL(x)		(((x) & 0xf) << 24)
+#define MSCL_SRC_GLOBAL_ALPHA_MASK		(0xff << 0)
+#define MSCL_SRC_GLOBAL_ALPHA(x)		(((x) & 0xff) << 0)
+
+/* m2m-scaler dst blend color */
+#define MSCL_DST_BLEND_COLOR			0x288
+#define MSCL_DST_COLOR_SEL_INV			(1 << 31)
+#define MSCL_DST_COLOR_SEL_MASK			(0x3 << 29)
+#define MSCL_DST_COLOR_SEL(x)			(((x) & 0x3) << 29)
+#define MSCL_DST_COLOR_OP_SEL_INV		(1 << 28)
+#define MSCL_DST_COLOR_OP_SEL_MASK		(0xf << 24)
+#define MSCL_DST_COLOR_OP_SEL(x)		(((x) & 0xf) << 24)
+#define MSCL_DST_GLOBAL_COLOR0_MASK		(0xff << 16)
+#define MSCL_DST_GLOBAL_COLOR0(x)		(((x) & 0xff) << 16)
+#define MSCL_DST_GLOBAL_COLOR1_MASK		(0xff << 8)
+#define MSCL_DST_GLOBAL_COLOR1(x)		(((x) & 0xff) << 8)
+#define MSCL_DST_GLOBAL_COLOR2_MASK		(0xff << 0)
+#define MSCL_DST_GLOBAL_COLOR2(x)		(((x) & 0xff) << 0)
+
+/* m2m-scaler dst blend alpha */
+#define MSCL_DST_BLEND_ALPHA			0x28C
+#define MSCL_DST_ALPHA_SEL_INV			(1 << 31)
+#define MSCL_DST_ALPHA_SEL_MASK			(0x3 << 29)
+#define MSCL_DST_ALPHA_SEL(x)			(((x) & 0x3) << 29)
+#define MSCL_DST_ALPHA_OP_SEL_INV		(1 << 28)
+#define MSCL_DST_ALPHA_OP_SEL_MASK		(0xf << 24)
+#define MSCL_DST_ALPHA_OP_SEL(x)		(((x) & 0xf) << 24)
+#define MSCL_DST_GLOBAL_ALPHA_MASK		(0xff << 0)
+#define MSCL_DST_GLOBAL_ALPHA(x)		(((x) & 0xff) << 0)
+
+/* m2m-scaler fill color */
+#define MSCL_FILL_COLOR				0x290
+#define MSCL_FILL_ALPHA_MASK			(0xff << 24)
+#define MSCL_FILL_ALPHA(x)			(((x) & 0xff) << 24)
+#define MSCL_FILL_COLOR0_MASK			(0xff << 16)
+#define MSCL_FILL_COLOR0(x)			(((x) & 0xff) << 16)
+#define MSCL_FILL_COLOR1_MASK			(0xff << 8)
+#define MSCL_FILL_COLOR1(x)			(((x) & 0xff) << 8)
+#define MSCL_FILL_COLOR2_MASK			(0xff << 0)
+#define MSCL_FILL_COLOR2(x)			(((x) & 0xff) << 0)
+
+/* m2m-scaler address queue config */
+#define MSCL_ADDR_QUEUE_CONFIG			0x2a0
+#define MSCL_ADDR_QUEUE_RST			(1 << 0)
+
+/* arbitrary r/w register and reg-value to check soft reset is success */
+#define MSCL_CFG_SOFT_RESET_CHECK_REG		MSCL_SRC_CFG
+#define MSCL_CFG_SOFT_RESET_CHECK_VAL		0x3
+
+#endif /* REGS_MSCL_H_ */
-- 
1.7.9.5

