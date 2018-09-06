Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49465 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727629AbeIFNgu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2018 09:36:50 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Jacopo Mondi <jacopo@jmondi.org>,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH v3 3/4] media: imx-pxp: add i.MX Pixel Pipeline driver
Date: Thu,  6 Sep 2018 11:02:14 +0200
Message-Id: <20180906090215.15719-4-p.zabel@pengutronix.de>
In-Reply-To: <20180906090215.15719-1-p.zabel@pengutronix.de>
References: <20180906090215.15719-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a V4L2 mem-to-mem scaler/CSC driver for the Pixel Pipeline (PXP)
version found on i.MX6ULL SoCs. A similar variant is used on i.MX7D.

Since this driver only uses the legacy pipeline, it should be reasonably
easy to extend it to work with the older PXP versions found on i.MX6UL,
i.MX6SX, i.MX6SL, i.MX28, and i.MX23.

The driver supports scaling and colorspace conversion. There is
currently no support for rotation, alpha-blending, and the LUTs.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v2:
 - fix Kconfig whitespace
 - remove unused defines
 - fix video_unregister_device/v4l2_m2m_release order in pxp_remove
 - use GPL-2.0+ instead of GPL-2.0-or-later SPDX license identifer
 - remove pxp_default_ycbcr_enc/quantization, always map to default
   encoding/quantization
 - rename pxp_fixup_colorimetry to pxp_fixup_colorimetry_cap
---
 drivers/media/platform/Kconfig   |    9 +
 drivers/media/platform/Makefile  |    2 +
 drivers/media/platform/imx-pxp.c | 1752 ++++++++++++++++++++++++++++++
 drivers/media/platform/imx-pxp.h | 1685 ++++++++++++++++++++++++++++
 4 files changed, 3448 insertions(+)
 create mode 100644 drivers/media/platform/imx-pxp.c
 create mode 100644 drivers/media/platform/imx-pxp.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 94c1fe0e9787..f6275874ec9e 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -181,6 +181,15 @@ config VIDEO_CODA
 config VIDEO_IMX_VDOA
 	def_tristate VIDEO_CODA if SOC_IMX6Q || COMPILE_TEST
 
+config VIDEO_IMX_PXP
+	tristate "i.MX Pixel Pipeline (PXP)"
+	depends on VIDEO_DEV && VIDEO_V4L2 && (ARCH_MXC || COMPILE_TEST)
+	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_MEM2MEM_DEV
+	help
+	  The i.MX Pixel Pipeline is a memory-to-memory engine for scaling,
+	  color space conversion, and rotation.
+
 config VIDEO_MEDIATEK_JPEG
 	tristate "Mediatek JPEG Codec driver"
 	depends on MTK_IOMMU_V1 || COMPILE_TEST
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 41322ab65802..6ab6200dd9c9 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -25,6 +25,8 @@ obj-$(CONFIG_VIDEO_TI_CAL)		+= ti-vpe/
 obj-$(CONFIG_VIDEO_MX2_EMMAPRP)		+= mx2_emmaprp.o
 obj-$(CONFIG_VIDEO_CODA)		+= coda/
 
+obj-$(CONFIG_VIDEO_IMX_PXP)		+= imx-pxp.o
+
 obj-$(CONFIG_VIDEO_SH_VEU)		+= sh_veu.o
 
 obj-$(CONFIG_CEC_GPIO)			+= cec-gpio/
diff --git a/drivers/media/platform/imx-pxp.c b/drivers/media/platform/imx-pxp.c
new file mode 100644
index 000000000000..68ecfed7098b
--- /dev/null
+++ b/drivers/media/platform/imx-pxp.c
@@ -0,0 +1,1752 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * i.MX Pixel Pipeline (PXP) mem-to-mem scaler/CSC/rotator driver
+ *
+ * Copyright (c) 2018 Pengutronix, Philipp Zabel
+ *
+ * based on vim2m
+ *
+ * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
+ * Pawel Osciak, <pawel@osciak.com>
+ * Marek Szyprowski, <m.szyprowski@samsung.com>
+ */
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+
+#include <linux/platform_device.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "imx-pxp.h"
+
+static unsigned int debug;
+module_param(debug, uint, 0644);
+MODULE_PARM_DESC(debug, "activates debug info");
+
+#define MIN_W 8
+#define MIN_H 8
+#define MAX_W 4096
+#define MAX_H 4096
+#define ALIGN_W 3 /* 8x8 pixel blocks */
+#define ALIGN_H 3
+
+/* Flags that indicate a format can be used for capture/output */
+#define MEM2MEM_CAPTURE	(1 << 0)
+#define MEM2MEM_OUTPUT	(1 << 1)
+
+#define MEM2MEM_NAME		"pxp"
+
+/* Flags that indicate processing mode */
+#define MEM2MEM_HFLIP	(1 << 0)
+#define MEM2MEM_VFLIP	(1 << 1)
+
+#define dprintk(dev, fmt, arg...) \
+	v4l2_dbg(1, debug, &dev->v4l2_dev, "%s: " fmt, __func__, ## arg)
+
+struct pxp_fmt {
+	u32	fourcc;
+	int	depth;
+	/* Types the format can be used for */
+	u32	types;
+};
+
+static struct pxp_fmt formats[] = {
+	{
+		.fourcc	= V4L2_PIX_FMT_XBGR32,
+		.depth	= 32,
+		/* Both capture and output format */
+		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
+	}, {
+		.fourcc	= V4L2_PIX_FMT_ABGR32,
+		.depth	= 32,
+		/* Capture-only format */
+		.types	= MEM2MEM_CAPTURE,
+	}, {
+		.fourcc	= V4L2_PIX_FMT_BGR24,
+		.depth	= 24,
+		.types	= MEM2MEM_CAPTURE,
+	}, {
+		.fourcc	= V4L2_PIX_FMT_RGB565,
+		.depth	= 16,
+		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
+	}, {
+		.fourcc	= V4L2_PIX_FMT_RGB555,
+		.depth	= 16,
+		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
+	}, {
+		.fourcc = V4L2_PIX_FMT_RGB444,
+		.depth	= 16,
+		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
+	}, {
+		.fourcc = V4L2_PIX_FMT_YUV32,
+		.depth	= 32,
+		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
+	}, {
+		.fourcc = V4L2_PIX_FMT_UYVY,
+		.depth	= 16,
+		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
+	}, {
+		.fourcc = V4L2_PIX_FMT_YUYV,
+		.depth	= 16,
+		/* Output-only format */
+		.types	= MEM2MEM_OUTPUT,
+	}, {
+		.fourcc = V4L2_PIX_FMT_VYUY,
+		.depth	= 16,
+		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
+	}, {
+		.fourcc = V4L2_PIX_FMT_YVYU,
+		.depth	= 16,
+		.types	= MEM2MEM_OUTPUT,
+	}, {
+		.fourcc = V4L2_PIX_FMT_GREY,
+		.depth	= 8,
+		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
+	}, {
+		.fourcc = V4L2_PIX_FMT_Y4,
+		.depth	= 4,
+		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
+	}, {
+		.fourcc = V4L2_PIX_FMT_NV16,
+		.depth	= 16,
+		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
+	}, {
+		.fourcc = V4L2_PIX_FMT_NV12,
+		.depth	= 12,
+		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
+	}, {
+		.fourcc = V4L2_PIX_FMT_NV21,
+		.depth	= 12,
+		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
+	}, {
+		.fourcc = V4L2_PIX_FMT_NV61,
+		.depth	= 16,
+		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
+	}, {
+		.fourcc = V4L2_PIX_FMT_YUV422P,
+		.depth	= 16,
+		.types	= MEM2MEM_OUTPUT,
+	}, {
+		.fourcc = V4L2_PIX_FMT_YUV420,
+		.depth	= 12,
+		.types	= MEM2MEM_OUTPUT,
+	},
+};
+
+#define NUM_FORMATS ARRAY_SIZE(formats)
+
+/* Per-queue, driver-specific private data */
+struct pxp_q_data {
+	unsigned int		width;
+	unsigned int		height;
+	unsigned int		bytesperline;
+	unsigned int		sizeimage;
+	unsigned int		sequence;
+	struct pxp_fmt		*fmt;
+	enum v4l2_ycbcr_encoding ycbcr_enc;
+	enum v4l2_quantization	quant;
+};
+
+enum {
+	V4L2_M2M_SRC = 0,
+	V4L2_M2M_DST = 1,
+};
+
+static struct pxp_fmt *find_format(struct v4l2_format *f)
+{
+	struct pxp_fmt *fmt;
+	unsigned int k;
+
+	for (k = 0; k < NUM_FORMATS; k++) {
+		fmt = &formats[k];
+		if (fmt->fourcc == f->fmt.pix.pixelformat)
+			break;
+	}
+
+	if (k == NUM_FORMATS)
+		return NULL;
+
+	return &formats[k];
+}
+
+struct pxp_dev {
+	struct v4l2_device	v4l2_dev;
+	struct video_device	vfd;
+
+	struct clk		*clk;
+	void __iomem		*mmio;
+
+	atomic_t		num_inst;
+	struct mutex		dev_mutex;
+	spinlock_t		irqlock;
+
+	struct v4l2_m2m_dev	*m2m_dev;
+};
+
+struct pxp_ctx {
+	struct v4l2_fh		fh;
+	struct pxp_dev	*dev;
+
+	struct v4l2_ctrl_handler hdl;
+
+	/* Abort requested by m2m */
+	int			aborting;
+
+	/* Processing mode */
+	int			mode;
+	u8			alpha_component;
+
+	enum v4l2_colorspace	colorspace;
+	enum v4l2_xfer_func	xfer_func;
+
+	/* Source and destination queue data */
+	struct pxp_q_data   q_data[2];
+};
+
+static inline struct pxp_ctx *file2ctx(struct file *file)
+{
+	return container_of(file->private_data, struct pxp_ctx, fh);
+}
+
+static struct pxp_q_data *get_q_data(struct pxp_ctx *ctx,
+					 enum v4l2_buf_type type)
+{
+	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		return &ctx->q_data[V4L2_M2M_SRC];
+	else
+		return &ctx->q_data[V4L2_M2M_DST];
+}
+
+static u32 pxp_v4l2_pix_fmt_to_ps_format(u32 v4l2_pix_fmt)
+{
+	switch (v4l2_pix_fmt) {
+	case V4L2_PIX_FMT_XBGR32:  return BV_PXP_PS_CTRL_FORMAT__RGB888;
+	case V4L2_PIX_FMT_RGB555:  return BV_PXP_PS_CTRL_FORMAT__RGB555;
+	case V4L2_PIX_FMT_RGB444:  return BV_PXP_PS_CTRL_FORMAT__RGB444;
+	case V4L2_PIX_FMT_RGB565:  return BV_PXP_PS_CTRL_FORMAT__RGB565;
+	case V4L2_PIX_FMT_YUV32:   return BV_PXP_PS_CTRL_FORMAT__YUV1P444;
+	case V4L2_PIX_FMT_UYVY:    return BV_PXP_PS_CTRL_FORMAT__UYVY1P422;
+	case V4L2_PIX_FMT_YUYV:    return BM_PXP_PS_CTRL_WB_SWAP |
+					  BV_PXP_PS_CTRL_FORMAT__UYVY1P422;
+	case V4L2_PIX_FMT_VYUY:    return BV_PXP_PS_CTRL_FORMAT__VYUY1P422;
+	case V4L2_PIX_FMT_YVYU:    return BM_PXP_PS_CTRL_WB_SWAP |
+					  BV_PXP_PS_CTRL_FORMAT__VYUY1P422;
+	case V4L2_PIX_FMT_GREY:    return BV_PXP_PS_CTRL_FORMAT__Y8;
+	default:
+	case V4L2_PIX_FMT_Y4:      return BV_PXP_PS_CTRL_FORMAT__Y4;
+	case V4L2_PIX_FMT_NV16:    return BV_PXP_PS_CTRL_FORMAT__YUV2P422;
+	case V4L2_PIX_FMT_NV12:    return BV_PXP_PS_CTRL_FORMAT__YUV2P420;
+	case V4L2_PIX_FMT_NV21:    return BV_PXP_PS_CTRL_FORMAT__YVU2P420;
+	case V4L2_PIX_FMT_NV61:    return BV_PXP_PS_CTRL_FORMAT__YVU2P422;
+	case V4L2_PIX_FMT_YUV422P: return BV_PXP_PS_CTRL_FORMAT__YUV422;
+	case V4L2_PIX_FMT_YUV420:  return BV_PXP_PS_CTRL_FORMAT__YUV420;
+	}
+}
+
+static u32 pxp_v4l2_pix_fmt_to_out_format(u32 v4l2_pix_fmt)
+{
+	switch (v4l2_pix_fmt) {
+	case V4L2_PIX_FMT_XBGR32:   return BV_PXP_OUT_CTRL_FORMAT__RGB888;
+	case V4L2_PIX_FMT_ABGR32:   return BV_PXP_OUT_CTRL_FORMAT__ARGB8888;
+	case V4L2_PIX_FMT_BGR24:    return BV_PXP_OUT_CTRL_FORMAT__RGB888P;
+	/* Missing V4L2 pixel formats for ARGB1555 and ARGB4444 */
+	case V4L2_PIX_FMT_RGB555:   return BV_PXP_OUT_CTRL_FORMAT__RGB555;
+	case V4L2_PIX_FMT_RGB444:   return BV_PXP_OUT_CTRL_FORMAT__RGB444;
+	case V4L2_PIX_FMT_RGB565:   return BV_PXP_OUT_CTRL_FORMAT__RGB565;
+	case V4L2_PIX_FMT_YUV32:    return BV_PXP_OUT_CTRL_FORMAT__YUV1P444;
+	case V4L2_PIX_FMT_UYVY:     return BV_PXP_OUT_CTRL_FORMAT__UYVY1P422;
+	case V4L2_PIX_FMT_VYUY:     return BV_PXP_OUT_CTRL_FORMAT__VYUY1P422;
+	case V4L2_PIX_FMT_GREY:     return BV_PXP_OUT_CTRL_FORMAT__Y8;
+	default:
+	case V4L2_PIX_FMT_Y4:       return BV_PXP_OUT_CTRL_FORMAT__Y4;
+	case V4L2_PIX_FMT_NV16:     return BV_PXP_OUT_CTRL_FORMAT__YUV2P422;
+	case V4L2_PIX_FMT_NV12:     return BV_PXP_OUT_CTRL_FORMAT__YUV2P420;
+	case V4L2_PIX_FMT_NV61:     return BV_PXP_OUT_CTRL_FORMAT__YVU2P422;
+	case V4L2_PIX_FMT_NV21:     return BV_PXP_OUT_CTRL_FORMAT__YVU2P420;
+	}
+}
+
+static bool pxp_v4l2_pix_fmt_is_yuv(u32 v4l2_pix_fmt)
+{
+	switch (v4l2_pix_fmt) {
+	case V4L2_PIX_FMT_YUV32:
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_VYUY:
+	case V4L2_PIX_FMT_YVYU:
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV61:
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YUV422P:
+	case V4L2_PIX_FMT_GREY:
+	case V4L2_PIX_FMT_Y4:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static void pxp_setup_csc(struct pxp_ctx *ctx)
+{
+	struct pxp_dev *dev = ctx->dev;
+	enum v4l2_ycbcr_encoding ycbcr_enc;
+	enum v4l2_quantization quantization;
+
+	if (pxp_v4l2_pix_fmt_is_yuv(ctx->q_data[V4L2_M2M_SRC].fmt->fourcc) &&
+	    !pxp_v4l2_pix_fmt_is_yuv(ctx->q_data[V4L2_M2M_DST].fmt->fourcc)) {
+		/*
+		 * CSC1 YUV/YCbCr to RGB conversion is implemented as follows:
+		 *
+		 * |R|   |C0 0  C1|   |Y  + Yoffset |
+		 * |G| = |C0 C3 C2| * |Cb + UVoffset|
+		 * |B|   |C0 C4 0 |   |Cr + UVoffset|
+		 *
+		 * Results are clamped to 0..255.
+		 *
+		 * BT.601 limited range:
+		 *
+		 * |R|   |1.1644  0.0000  1.5960|   |Y  - 16 |
+		 * |G| = |1.1644 -0.3917 -0.8129| * |Cb - 128|
+		 * |B|   |1.1644  2.0172  0.0000|   |Cr - 128|
+		 */
+		static const u32 csc1_coef_bt601_lim[3] = {
+			BM_PXP_CSC1_COEF0_YCBCR_MODE |
+			BF_PXP_CSC1_COEF0_C0(0x12a) |	/*  1.1641 (-0.03 %) */
+			BF_PXP_CSC1_COEF0_UV_OFFSET(-128) |
+			BF_PXP_CSC1_COEF0_Y_OFFSET(-16),
+			BF_PXP_CSC1_COEF1_C1(0x198) |	/*  1.5938 (-0.23 %) */
+			BF_PXP_CSC1_COEF1_C4(0x204),	/*  2.0156 (-0.16 %) */
+			BF_PXP_CSC1_COEF2_C2(0x730) |	/* -0.8125 (+0.04 %) */
+			BF_PXP_CSC1_COEF2_C3(0x79c),	/* -0.3906 (+0.11 %) */
+		};
+		/*
+		 * BT.601 full range:
+		 *
+		 * |R|   |1.0000  0.0000  1.4020|   |Y  + 0  |
+		 * |G| = |1.0000 -0.3441 -0.7141| * |Cb - 128|
+		 * |B|   |1.0000  1.7720  0.0000|   |Cr - 128|
+		 */
+		static const u32 csc1_coef_bt601_full[3] = {
+			BM_PXP_CSC1_COEF0_YCBCR_MODE |
+			BF_PXP_CSC1_COEF0_C0(0x100) |	/*  1.0000 (+0.00 %) */
+			BF_PXP_CSC1_COEF0_UV_OFFSET(-128) |
+			BF_PXP_CSC1_COEF0_Y_OFFSET(0),
+			BF_PXP_CSC1_COEF1_C1(0x166) |	/*  1.3984 (-0.36 %) */
+			BF_PXP_CSC1_COEF1_C4(0x1c5),	/*  1.7695 (-0.25 %) */
+			BF_PXP_CSC1_COEF2_C2(0x74a) |	/* -0.7109 (+0.32 %) */
+			BF_PXP_CSC1_COEF2_C3(0x7a8),	/* -0.3438 (+0.04 %) */
+		};
+		/*
+		 * Rec.709 limited range:
+		 *
+		 * |R|   |1.1644  0.0000  1.7927|   |Y  - 16 |
+		 * |G| = |1.1644 -0.2132 -0.5329| * |Cb - 128|
+		 * |B|   |1.1644  2.1124  0.0000|   |Cr - 128|
+		 */
+		static const u32 csc1_coef_rec709_lim[3] = {
+			BM_PXP_CSC1_COEF0_YCBCR_MODE |
+			BF_PXP_CSC1_COEF0_C0(0x12a) |	/*  1.1641 (-0.03 %) */
+			BF_PXP_CSC1_COEF0_UV_OFFSET(-128) |
+			BF_PXP_CSC1_COEF0_Y_OFFSET(-16),
+			BF_PXP_CSC1_COEF1_C1(0x1ca) |	/*  1.7891 (-0.37 %) */
+			BF_PXP_CSC1_COEF1_C4(0x21c),	/*  2.1094 (-0.30 %) */
+			BF_PXP_CSC1_COEF2_C2(0x778) |	/* -0.5312 (+0.16 %) */
+			BF_PXP_CSC1_COEF2_C3(0x7ca),	/* -0.2109 (+0.23 %) */
+		};
+		/*
+		 * Rec.709 full range:
+		 *
+		 * |R|   |1.0000  0.0000  1.5748|   |Y  + 0  |
+		 * |G| = |1.0000 -0.1873 -0.4681| * |Cb - 128|
+		 * |B|   |1.0000  1.8556  0.0000|   |Cr - 128|
+		 */
+		static const u32 csc1_coef_rec709_full[3] = {
+			BM_PXP_CSC1_COEF0_YCBCR_MODE |
+			BF_PXP_CSC1_COEF0_C0(0x100) |	/*  1.0000 (+0.00 %) */
+			BF_PXP_CSC1_COEF0_UV_OFFSET(-128) |
+			BF_PXP_CSC1_COEF0_Y_OFFSET(0),
+			BF_PXP_CSC1_COEF1_C1(0x193) |	/*  1.5742 (-0.06 %) */
+			BF_PXP_CSC1_COEF1_C4(0x1db),	/*  1.8555 (-0.01 %) */
+			BF_PXP_CSC1_COEF2_C2(0x789) |	/* -0.4648 (+0.33 %) */
+			BF_PXP_CSC1_COEF2_C3(0x7d1),	/* -0.1836 (+0.37 %) */
+		};
+		/*
+		 * BT.2020 limited range:
+		 *
+		 * |R|   |1.1644  0.0000  1.6787|   |Y  - 16 |
+		 * |G| = |1.1644 -0.1874 -0.6505| * |Cb - 128|
+		 * |B|   |1.1644  2.1418  0.0000|   |Cr - 128|
+		 */
+		static const u32 csc1_coef_bt2020_lim[3] = {
+			BM_PXP_CSC1_COEF0_YCBCR_MODE |
+			BF_PXP_CSC1_COEF0_C0(0x12a) |	/*  1.1641 (-0.03 %) */
+			BF_PXP_CSC1_COEF0_UV_OFFSET(-128) |
+			BF_PXP_CSC1_COEF0_Y_OFFSET(-16),
+			BF_PXP_CSC1_COEF1_C1(0x1ad) |	/*  1.6758 (-0.29 %) */
+			BF_PXP_CSC1_COEF1_C4(0x224),	/*  2.1406 (-0.11 %) */
+			BF_PXP_CSC1_COEF2_C2(0x75a) |	/* -0.6484 (+0.20 %) */
+			BF_PXP_CSC1_COEF2_C3(0x7d1),	/* -0.1836 (+0.38 %) */
+		};
+		/*
+		 * BT.2020 full range:
+		 *
+		 * |R|   |1.0000  0.0000  1.4746|   |Y  + 0  |
+		 * |G| = |1.0000 -0.1646 -0.5714| * |Cb - 128|
+		 * |B|   |1.0000  1.8814  0.0000|   |Cr - 128|
+		 */
+		static const u32 csc1_coef_bt2020_full[3] = {
+			BM_PXP_CSC1_COEF0_YCBCR_MODE |
+			BF_PXP_CSC1_COEF0_C0(0x100) |	/*  1.0000 (+0.00 %) */
+			BF_PXP_CSC1_COEF0_UV_OFFSET(-128) |
+			BF_PXP_CSC1_COEF0_Y_OFFSET(0),
+			BF_PXP_CSC1_COEF1_C1(0x179) |	/*  1.4727 (-0.19 %) */
+			BF_PXP_CSC1_COEF1_C4(0x1e1),	/*  1.8789 (-0.25 %) */
+			BF_PXP_CSC1_COEF2_C2(0x76e) |	/* -0.5703 (+0.11 %) */
+			BF_PXP_CSC1_COEF2_C3(0x7d6),	/* -0.1641 (+0.05 %) */
+		};
+		/*
+		 * SMPTE 240m limited range:
+		 *
+		 * |R|   |1.1644  0.0000  1.7937|   |Y  - 16 |
+		 * |G| = |1.1644 -0.2565 -0.5427| * |Cb - 128|
+		 * |B|   |1.1644  2.0798  0.0000|   |Cr - 128|
+		 */
+		static const u32 csc1_coef_smpte240m_lim[3] = {
+			BM_PXP_CSC1_COEF0_YCBCR_MODE |
+			BF_PXP_CSC1_COEF0_C0(0x12a) |	/*  1.1641 (-0.03 %) */
+			BF_PXP_CSC1_COEF0_UV_OFFSET(-128) |
+			BF_PXP_CSC1_COEF0_Y_OFFSET(-16),
+			BF_PXP_CSC1_COEF1_C1(0x1cb) |	/*  1.7930 (-0.07 %) */
+			BF_PXP_CSC1_COEF1_C4(0x214),	/*  2.0781 (-0.17 %) */
+			BF_PXP_CSC1_COEF2_C2(0x776) |	/* -0.5391 (+0.36 %) */
+			BF_PXP_CSC1_COEF2_C3(0x7bf),	/* -0.2539 (+0.26 %) */
+		};
+		/*
+		 * SMPTE 240m full range:
+		 *
+		 * |R|   |1.0000  0.0000  1.5756|   |Y  + 0  |
+		 * |G| = |1.0000 -0.2253 -0.4767| * |Cb - 128|
+		 * |B|   |1.0000  1.8270  0.0000|   |Cr - 128|
+		 */
+		static const u32 csc1_coef_smpte240m_full[3] = {
+			BM_PXP_CSC1_COEF0_YCBCR_MODE |
+			BF_PXP_CSC1_COEF0_C0(0x100) |	/*  1.0000 (+0.00 %) */
+			BF_PXP_CSC1_COEF0_UV_OFFSET(-128) |
+			BF_PXP_CSC1_COEF0_Y_OFFSET(0),
+			BF_PXP_CSC1_COEF1_C1(0x193) |	/*  1.5742 (-0.14 %) */
+			BF_PXP_CSC1_COEF1_C4(0x1d3),	/*  1.8242 (-0.28 %) */
+			BF_PXP_CSC1_COEF2_C2(0x786) |	/* -0.4766 (+0.01 %) */
+			BF_PXP_CSC1_COEF2_C3(0x7c7),	/* -0.2227 (+0.26 %) */
+		};
+		const u32 *csc1_coef;
+
+		ycbcr_enc = ctx->q_data[V4L2_M2M_SRC].ycbcr_enc;
+		quantization = ctx->q_data[V4L2_M2M_SRC].quant;
+
+		if (ycbcr_enc == V4L2_YCBCR_ENC_601) {
+			if (quantization == V4L2_QUANTIZATION_FULL_RANGE)
+				csc1_coef = csc1_coef_bt601_full;
+			else
+				csc1_coef = csc1_coef_bt601_lim;
+		} else if (ycbcr_enc == V4L2_YCBCR_ENC_709) {
+			if (quantization == V4L2_QUANTIZATION_FULL_RANGE)
+				csc1_coef = csc1_coef_rec709_full;
+			else
+				csc1_coef = csc1_coef_rec709_lim;
+		} else if (ycbcr_enc == V4L2_YCBCR_ENC_BT2020) {
+			if (quantization == V4L2_QUANTIZATION_FULL_RANGE)
+				csc1_coef = csc1_coef_bt2020_full;
+			else
+				csc1_coef = csc1_coef_bt2020_lim;
+		} else {
+			if (quantization == V4L2_QUANTIZATION_FULL_RANGE)
+				csc1_coef = csc1_coef_smpte240m_full;
+			else
+				csc1_coef = csc1_coef_smpte240m_lim;
+		}
+
+		writel(csc1_coef[0], dev->mmio + HW_PXP_CSC1_COEF0);
+		writel(csc1_coef[1], dev->mmio + HW_PXP_CSC1_COEF1);
+		writel(csc1_coef[2], dev->mmio + HW_PXP_CSC1_COEF2);
+	} else {
+		writel(BM_PXP_CSC1_COEF0_BYPASS, dev->mmio + HW_PXP_CSC1_COEF0);
+	}
+
+	if (!pxp_v4l2_pix_fmt_is_yuv(ctx->q_data[V4L2_M2M_SRC].fmt->fourcc) &&
+	    pxp_v4l2_pix_fmt_is_yuv(ctx->q_data[V4L2_M2M_DST].fmt->fourcc)) {
+		/*
+		 * CSC2 RGB to YUV/YCbCr conversion is implemented as follows:
+		 *
+		 * |Y |   |A1 A2 A3|   |R|   |D1|
+		 * |Cb| = |B1 B2 B3| * |G| + |D2|
+		 * |Cr|   |C1 C2 C3|   |B|   |D3|
+		 *
+		 * Results are clamped to 0..255.
+		 *
+		 * BT.601 limited range:
+		 *
+		 * |Y |   | 0.2568  0.5041  0.0979|   |R|   |16 |
+		 * |Cb| = |-0.1482 -0.2910  0.4392| * |G| + |128|
+		 * |Cr|   | 0.4392  0.4392 -0.3678|   |B|   |128|
+		 */
+		static const u32 csc2_coef_bt601_lim[6] = {
+			BF_PXP_CSC2_COEF0_A2(0x081) |	/*  0.5039 (-0.02 %) */
+			BF_PXP_CSC2_COEF0_A1(0x041),	/*  0.2539 (-0.29 %) */
+			BF_PXP_CSC2_COEF1_B1(0x7db) |	/* -0.1445 (+0.37 %) */
+			BF_PXP_CSC2_COEF1_A3(0x019),	/*  0.0977 (-0.02 %) */
+			BF_PXP_CSC2_COEF2_B3(0x070) |	/*  0.4375 (-0.17 %) */
+			BF_PXP_CSC2_COEF2_B2(0x7b6),	/* -0.2891 (+0.20 %) */
+			BF_PXP_CSC2_COEF3_C2(0x7a2) |	/* -0.3672 (+0.06 %) */
+			BF_PXP_CSC2_COEF3_C1(0x070),	/*  0.4375 (-0.17 %) */
+			BF_PXP_CSC2_COEF4_D1(16) |
+			BF_PXP_CSC2_COEF4_C3(0x7ee),	/* -0.0703 (+0.11 %) */
+			BF_PXP_CSC2_COEF5_D3(128) |
+			BF_PXP_CSC2_COEF5_D2(128),
+		};
+		/*
+		 * BT.601 full range:
+		 *
+		 * |Y |   | 0.2990  0.5870  0.1140|   |R|   |0  |
+		 * |Cb| = |-0.1687 -0.3313  0.5000| * |G| + |128|
+		 * |Cr|   | 0.5000  0.5000 -0.4187|   |B|   |128|
+		 */
+		static const u32 csc2_coef_bt601_full[6] = {
+			BF_PXP_CSC2_COEF0_A2(0x096) |	/*  0.5859 (-0.11 %) */
+			BF_PXP_CSC2_COEF0_A1(0x04c),	/*  0.2969 (-0.21 %) */
+			BF_PXP_CSC2_COEF1_B1(0x7d5) |	/* -0.1680 (+0.07 %) */
+			BF_PXP_CSC2_COEF1_A3(0x01d),	/*  0.1133 (-0.07 %) */
+			BF_PXP_CSC2_COEF2_B3(0x080) |	/*  0.5000 (+0.00 %) */
+			BF_PXP_CSC2_COEF2_B2(0x7ac),	/* -0.3281 (+0.32 %) */
+			BF_PXP_CSC2_COEF3_C2(0x795) |	/* -0.4180 (+0.07 %) */
+			BF_PXP_CSC2_COEF3_C1(0x080),	/*  0.5000 (+0.00 %) */
+			BF_PXP_CSC2_COEF4_D1(0) |
+			BF_PXP_CSC2_COEF4_C3(0x7ec),	/* -0.0781 (+0.32 %) */
+			BF_PXP_CSC2_COEF5_D3(128) |
+			BF_PXP_CSC2_COEF5_D2(128),
+		};
+		/*
+		 * Rec.709 limited range:
+		 *
+		 * |Y |   | 0.1826  0.6142  0.0620|   |R|   |16 |
+		 * |Cb| = |-0.1007 -0.3385  0.4392| * |G| + |128|
+		 * |Cr|   | 0.4392  0.4392 -0.3990|   |B|   |128|
+		 */
+		static const u32 csc2_coef_rec709_lim[6] = {
+			BF_PXP_CSC2_COEF0_A2(0x09d) |	/*  0.6133 (-0.09 %) */
+			BF_PXP_CSC2_COEF0_A1(0x02e),	/*  0.1797 (-0.29 %) */
+			BF_PXP_CSC2_COEF1_B1(0x7e7) |	/* -0.0977 (+0.30 %) */
+			BF_PXP_CSC2_COEF1_A3(0x00f),	/*  0.0586 (-0.34 %) */
+			BF_PXP_CSC2_COEF2_B3(0x070) |	/*  0.4375 (-0.17 %) */
+			BF_PXP_CSC2_COEF2_B2(0x7aa),	/* -0.3359 (+0.26 %) */
+			BF_PXP_CSC2_COEF3_C2(0x79a) |	/* -0.3984 (+0.05 %) */
+			BF_PXP_CSC2_COEF3_C1(0x070),	/*  0.4375 (-0.17 %) */
+			BF_PXP_CSC2_COEF4_D1(16) |
+			BF_PXP_CSC2_COEF4_C3(0x7f6),	/* -0.0391 (+0.12 %) */
+			BF_PXP_CSC2_COEF5_D3(128) |
+			BF_PXP_CSC2_COEF5_D2(128),
+		};
+		/*
+		 * Rec.709 full range:
+		 *
+		 * |Y |   | 0.2126  0.7152  0.0722|   |R|   |0  |
+		 * |Cb| = |-0.1146 -0.3854  0.5000| * |G| + |128|
+		 * |Cr|   | 0.5000  0.5000 -0.4542|   |B|   |128|
+		 */
+		static const u32 csc2_coef_rec709_full[6] = {
+			BF_PXP_CSC2_COEF0_A2(0x0b7) |	/*  0.7148 (-0.04 %) */
+			BF_PXP_CSC2_COEF0_A1(0x036),	/*  0.2109 (-0.17 %) */
+			BF_PXP_CSC2_COEF1_B1(0x7e3) |	/* -0.1133 (+0.13 %) */
+			BF_PXP_CSC2_COEF1_A3(0x012),	/*  0.0703 (-0.19 %) */
+			BF_PXP_CSC2_COEF2_B3(0x080) |	/*  0.5000 (+0.00 %) */
+			BF_PXP_CSC2_COEF2_B2(0x79e),	/* -0.3828 (+0.26 %) */
+			BF_PXP_CSC2_COEF3_C2(0x78c) |	/* -0.4531 (+0.11 %) */
+			BF_PXP_CSC2_COEF3_C1(0x080),	/*  0.5000 (+0.00 %) */
+			BF_PXP_CSC2_COEF4_D1(0) |
+			BF_PXP_CSC2_COEF4_C3(0x7f5),	/* -0.0430 (+0.28 %) */
+			BF_PXP_CSC2_COEF5_D3(128) |
+			BF_PXP_CSC2_COEF5_D2(128),
+		};
+		/*
+		 * BT.2020 limited range:
+		 *
+		 * |Y |   | 0.2256  0.5823  0.0509|   |R|   |16 |
+		 * |Cb| = |-0.1226 -0.3166  0.4392| * |G| + |128|
+		 * |Cr|   | 0.4392  0.4392 -0.4039|   |B|   |128|
+		 */
+		static const u32 csc2_coef_bt2020_lim[6] = {
+			BF_PXP_CSC2_COEF0_A2(0x095) |	/*  0.5820 (-0.03 %) */
+			BF_PXP_CSC2_COEF0_A1(0x039),	/*  0.2227 (-0.30 %) */
+			BF_PXP_CSC2_COEF1_B1(0x7e1) |	/* -0.1211 (+0.15 %) */
+			BF_PXP_CSC2_COEF1_A3(0x00d),	/*  0.0508 (-0.01 %) */
+			BF_PXP_CSC2_COEF2_B3(0x070) |	/*  0.4375 (-0.17 %) */
+			BF_PXP_CSC2_COEF2_B2(0x7af),	/* -0.3164 (+0.02 %) */
+			BF_PXP_CSC2_COEF3_C2(0x799) |	/* -0.4023 (+0.16 %) */
+			BF_PXP_CSC2_COEF3_C1(0x070),	/*  0.4375 (-0.17 %) */
+			BF_PXP_CSC2_COEF4_D1(16) |
+			BF_PXP_CSC2_COEF4_C3(0x7f7),	/* -0.0352 (+0.02 %) */
+			BF_PXP_CSC2_COEF5_D3(128) |
+			BF_PXP_CSC2_COEF5_D2(128),
+		};
+		/*
+		 * BT.2020 full range:
+		 *
+		 * |Y |   | 0.2627  0.6780  0.0593|   |R|   |0  |
+		 * |Cb| = |-0.1396 -0.3604  0.5000| * |G| + |128|
+		 * |Cr|   | 0.5000  0.5000 -0.4598|   |B|   |128|
+		 */
+		static const u32 csc2_coef_bt2020_full[6] = {
+			BF_PXP_CSC2_COEF0_A2(0x0ad) |	/*  0.6758 (-0.22 %) */
+			BF_PXP_CSC2_COEF0_A1(0x043),	/*  0.2617 (-0.10 %) */
+			BF_PXP_CSC2_COEF1_B1(0x7dd) |	/* -0.1367 (+0.29 %) */
+			BF_PXP_CSC2_COEF1_A3(0x00f),	/*  0.0586 (-0.07 %) */
+			BF_PXP_CSC2_COEF2_B3(0x080) |	/*  0.5000 (+0.00 %) */
+			BF_PXP_CSC2_COEF2_B2(0x7a4),	/* -0.3594 (+0.10 %) */
+			BF_PXP_CSC2_COEF3_C2(0x78b) |	/* -0.4570 (+0.28 %) */
+			BF_PXP_CSC2_COEF3_C1(0x080),	/*  0.5000 (+0.00 %) */
+			BF_PXP_CSC2_COEF4_D1(0) |
+			BF_PXP_CSC2_COEF4_C3(0x7f6),	/* -0.0391 (+0.11 %) */
+			BF_PXP_CSC2_COEF5_D3(128) |
+			BF_PXP_CSC2_COEF5_D2(128),
+		};
+		/*
+		 * SMPTE 240m limited range:
+		 *
+		 * |Y |   | 0.1821  0.6020  0.0747|   |R|   |16 |
+		 * |Cb| = |-0.1019 -0.3373  0.4392| * |G| + |128|
+		 * |Cr|   | 0.4392  0.4392 -0.3909|   |B|   |128|
+		 */
+		static const u32 csc2_coef_smpte240m_lim[6] = {
+			BF_PXP_CSC2_COEF0_A2(0x09a) |	/*  0.6016 (-0.05 %) */
+			BF_PXP_CSC2_COEF0_A1(0x02e),	/*  0.1797 (-0.24 %) */
+			BF_PXP_CSC2_COEF1_B1(0x7e6) |	/* -0.1016 (+0.03 %) */
+			BF_PXP_CSC2_COEF1_A3(0x013),	/*  0.0742 (-0.05 %) */
+			BF_PXP_CSC2_COEF2_B3(0x070) |	/*  0.4375 (-0.17 %) */
+			BF_PXP_CSC2_COEF2_B2(0x7aa),	/* -0.3359 (+0.14 %) */
+			BF_PXP_CSC2_COEF3_C2(0x79c) |	/* -0.3906 (+0.03 %) */
+			BF_PXP_CSC2_COEF3_C1(0x070),	/*  0.4375 (-0.17 %) */
+			BF_PXP_CSC2_COEF4_D1(16) |
+			BF_PXP_CSC2_COEF4_C3(0x7f4),	/* -0.0469 (+0.14 %) */
+			BF_PXP_CSC2_COEF5_D3(128) |
+			BF_PXP_CSC2_COEF5_D2(128),
+		};
+		/*
+		 * SMPTE 240m full range:
+		 *
+		 * |Y |   | 0.2120  0.7010  0.0870|   |R|   |0  |
+		 * |Cb| = |-0.1160 -0.3840  0.5000| * |G| + |128|
+		 * |Cr|   | 0.5000  0.5000 -0.4450|   |B|   |128|
+		 */
+		static const u32 csc2_coef_smpte240m_full[6] = {
+			BF_PXP_CSC2_COEF0_A2(0x0b3) |	/*  0.6992 (-0.18 %) */
+			BF_PXP_CSC2_COEF0_A1(0x036),	/*  0.2109 (-0.11 %) */
+			BF_PXP_CSC2_COEF1_B1(0x7e3) |	/* -0.1133 (+0.27 %) */
+			BF_PXP_CSC2_COEF1_A3(0x016),	/*  0.0859 (-0.11 %) */
+			BF_PXP_CSC2_COEF2_B3(0x080) |	/*  0.5000 (+0.00 %) */
+			BF_PXP_CSC2_COEF2_B2(0x79e),	/* -0.3828 (+0.12 %) */
+			BF_PXP_CSC2_COEF3_C2(0x78f) |	/* -0.4414 (+0.36 %) */
+			BF_PXP_CSC2_COEF3_C1(0x080),	/*  0.5000 (+0.00 %) */
+			BF_PXP_CSC2_COEF4_D1(0) |
+			BF_PXP_CSC2_COEF4_C3(0x7f2),	/* -0.0547 (+0.03 %) */
+			BF_PXP_CSC2_COEF5_D3(128) |
+			BF_PXP_CSC2_COEF5_D2(128),
+		};
+		const u32 *csc2_coef;
+		u32 csc2_ctrl;
+
+		ycbcr_enc = ctx->q_data[V4L2_M2M_DST].ycbcr_enc;
+		quantization = ctx->q_data[V4L2_M2M_DST].quant;
+
+		if (ycbcr_enc == V4L2_YCBCR_ENC_601) {
+			if (quantization == V4L2_QUANTIZATION_FULL_RANGE)
+				csc2_coef = csc2_coef_bt601_full;
+			else
+				csc2_coef = csc2_coef_bt601_lim;
+		} else if (ycbcr_enc == V4L2_YCBCR_ENC_709) {
+			if (quantization == V4L2_QUANTIZATION_FULL_RANGE)
+				csc2_coef = csc2_coef_rec709_full;
+			else
+				csc2_coef = csc2_coef_rec709_lim;
+		} else if (ycbcr_enc == V4L2_YCBCR_ENC_709) {
+			if (quantization == V4L2_QUANTIZATION_FULL_RANGE)
+				csc2_coef = csc2_coef_bt2020_full;
+			else
+				csc2_coef = csc2_coef_bt2020_lim;
+		} else {
+			if (quantization == V4L2_QUANTIZATION_FULL_RANGE)
+				csc2_coef = csc2_coef_smpte240m_full;
+			else
+				csc2_coef = csc2_coef_smpte240m_lim;
+		}
+		if (quantization == V4L2_QUANTIZATION_FULL_RANGE) {
+			csc2_ctrl = BV_PXP_CSC2_CTRL_CSC_MODE__RGB2YUV <<
+				    BP_PXP_CSC2_CTRL_CSC_MODE;
+		} else {
+			csc2_ctrl = BV_PXP_CSC2_CTRL_CSC_MODE__RGB2YCbCr <<
+				    BP_PXP_CSC2_CTRL_CSC_MODE;
+		}
+
+		writel(csc2_ctrl, dev->mmio + HW_PXP_CSC2_CTRL);
+		writel(csc2_coef[0], dev->mmio + HW_PXP_CSC2_COEF0);
+		writel(csc2_coef[1], dev->mmio + HW_PXP_CSC2_COEF1);
+		writel(csc2_coef[2], dev->mmio + HW_PXP_CSC2_COEF2);
+		writel(csc2_coef[3], dev->mmio + HW_PXP_CSC2_COEF3);
+		writel(csc2_coef[4], dev->mmio + HW_PXP_CSC2_COEF4);
+		writel(csc2_coef[5], dev->mmio + HW_PXP_CSC2_COEF5);
+	} else {
+		writel(BM_PXP_CSC2_CTRL_BYPASS, dev->mmio + HW_PXP_CSC2_CTRL);
+	}
+}
+
+static int pxp_start(struct pxp_ctx *ctx, struct vb2_v4l2_buffer *in_vb,
+		     struct vb2_v4l2_buffer *out_vb)
+{
+	struct pxp_dev *dev = ctx->dev;
+	struct pxp_q_data *q_data;
+	u32 src_width, src_height, src_stride, src_fourcc;
+	u32 dst_width, dst_height, dst_stride, dst_fourcc;
+	dma_addr_t p_in, p_out;
+	u32 ctrl, out_ctrl, out_buf, out_buf2, out_pitch, out_lrc, out_ps_ulc;
+	u32 out_ps_lrc;
+	u32 ps_ctrl, ps_buf, ps_ubuf, ps_vbuf, ps_pitch, ps_scale, ps_offset;
+	u32 as_ulc, as_lrc;
+	u32 y_size;
+	u32 decx, decy, xscale, yscale;
+
+	q_data = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+
+	src_width = ctx->q_data[V4L2_M2M_SRC].width;
+	dst_width = ctx->q_data[V4L2_M2M_DST].width;
+	src_height = ctx->q_data[V4L2_M2M_SRC].height;
+	dst_height = ctx->q_data[V4L2_M2M_DST].height;
+	src_stride = ctx->q_data[V4L2_M2M_SRC].bytesperline;
+	dst_stride = ctx->q_data[V4L2_M2M_DST].bytesperline;
+	src_fourcc = ctx->q_data[V4L2_M2M_SRC].fmt->fourcc;
+	dst_fourcc = ctx->q_data[V4L2_M2M_DST].fmt->fourcc;
+
+	p_in = vb2_dma_contig_plane_dma_addr(&in_vb->vb2_buf, 0);
+	p_out = vb2_dma_contig_plane_dma_addr(&out_vb->vb2_buf, 0);
+
+	if (!p_in || !p_out) {
+		v4l2_err(&dev->v4l2_dev,
+			 "Acquiring DMA addresses of buffers failed\n");
+		return -EFAULT;
+	}
+
+	out_vb->sequence =
+		get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE)->sequence++;
+	in_vb->sequence = q_data->sequence++;
+	out_vb->vb2_buf.timestamp = in_vb->vb2_buf.timestamp;
+
+	if (in_vb->flags & V4L2_BUF_FLAG_TIMECODE)
+		out_vb->timecode = in_vb->timecode;
+	out_vb->field = in_vb->field;
+	out_vb->flags = in_vb->flags &
+		(V4L2_BUF_FLAG_TIMECODE |
+		 V4L2_BUF_FLAG_KEYFRAME |
+		 V4L2_BUF_FLAG_PFRAME |
+		 V4L2_BUF_FLAG_BFRAME |
+		 V4L2_BUF_FLAG_TSTAMP_SRC_MASK);
+
+	/* Rotation disabled, 8x8 block size */
+	ctrl = BF_PXP_CTRL_VFLIP0(!!(ctx->mode & MEM2MEM_VFLIP)) |
+	       BF_PXP_CTRL_HFLIP0(!!(ctx->mode & MEM2MEM_HFLIP));
+	/* Always write alpha value as V4L2_CID_ALPHA_COMPONENT */
+	out_ctrl = BF_PXP_OUT_CTRL_ALPHA(ctx->alpha_component) |
+		   BF_PXP_OUT_CTRL_ALPHA_OUTPUT(1) |
+		   pxp_v4l2_pix_fmt_to_out_format(dst_fourcc);
+	out_buf = p_out;
+	switch (dst_fourcc) {
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV61:
+		out_buf2 = out_buf + dst_stride * dst_height;
+		break;
+	default:
+		out_buf2 = 0;
+	}
+
+	out_pitch = BF_PXP_OUT_PITCH_PITCH(dst_stride);
+	out_lrc = BF_PXP_OUT_LRC_X(dst_width - 1) |
+		  BF_PXP_OUT_LRC_Y(dst_height - 1);
+	/* PS covers whole output */
+	out_ps_ulc = BF_PXP_OUT_PS_ULC_X(0) | BF_PXP_OUT_PS_ULC_Y(0);
+	out_ps_lrc = BF_PXP_OUT_PS_LRC_X(dst_width - 1) |
+		     BF_PXP_OUT_PS_LRC_Y(dst_height - 1);
+	/* no AS */
+	as_ulc = BF_PXP_OUT_AS_ULC_X(1) | BF_PXP_OUT_AS_ULC_Y(1);
+	as_lrc = BF_PXP_OUT_AS_LRC_X(0) | BF_PXP_OUT_AS_LRC_Y(0);
+
+	decx = (src_width <= dst_width) ? 0 : ilog2(src_width / dst_width);
+	decy = (src_height <= dst_height) ? 0 : ilog2(src_height / dst_height);
+	ps_ctrl = BF_PXP_PS_CTRL_DECX(decx) | BF_PXP_PS_CTRL_DECY(decy) |
+		  pxp_v4l2_pix_fmt_to_ps_format(src_fourcc);
+	ps_buf = p_in;
+	y_size = src_stride * src_height;
+	switch (src_fourcc) {
+	case V4L2_PIX_FMT_YUV420:
+		ps_ubuf = ps_buf + y_size;
+		ps_vbuf = ps_ubuf + y_size / 4;
+		break;
+	case V4L2_PIX_FMT_YUV422P:
+		ps_ubuf = ps_buf + y_size;
+		ps_vbuf = ps_ubuf + y_size / 2;
+		break;
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV61:
+		ps_ubuf = ps_buf + y_size;
+		ps_vbuf = 0;
+		break;
+	case V4L2_PIX_FMT_GREY:
+	case V4L2_PIX_FMT_Y4:
+		ps_ubuf = 0;
+		/* In grayscale mode, ps_vbuf contents are reused as CbCr */
+		ps_vbuf = 0x8080;
+		break;
+	default:
+		ps_ubuf = 0;
+		ps_vbuf = 0;
+		break;
+	}
+	ps_pitch = BF_PXP_PS_PITCH_PITCH(src_stride);
+	if (decx) {
+		xscale = (src_width >> decx) * 0x1000 / dst_width;
+	} else {
+		switch (src_fourcc) {
+		case V4L2_PIX_FMT_UYVY:
+		case V4L2_PIX_FMT_YUYV:
+		case V4L2_PIX_FMT_VYUY:
+		case V4L2_PIX_FMT_YVYU:
+		case V4L2_PIX_FMT_NV16:
+		case V4L2_PIX_FMT_NV12:
+		case V4L2_PIX_FMT_NV21:
+		case V4L2_PIX_FMT_NV61:
+		case V4L2_PIX_FMT_YUV422P:
+		case V4L2_PIX_FMT_YUV420:
+			/*
+			 * This avoids sampling past the right edge for
+			 * horizontally chroma subsampled formats.
+			 */
+			xscale = (src_width - 2) * 0x1000 / (dst_width - 1);
+			break;
+		default:
+			xscale = (src_width - 1) * 0x1000 / (dst_width - 1);
+			break;
+		}
+	}
+	if (decy)
+		yscale = (src_height >> decy) * 0x1000 / dst_height;
+	else
+		yscale = (src_height - 1) * 0x1000 / (dst_height - 1);
+	ps_scale = BF_PXP_PS_SCALE_YSCALE(yscale) |
+		   BF_PXP_PS_SCALE_XSCALE(xscale);
+	ps_offset = BF_PXP_PS_OFFSET_YOFFSET(0) | BF_PXP_PS_OFFSET_XOFFSET(0);
+
+	writel(ctrl, dev->mmio + HW_PXP_CTRL);
+	/* skip STAT */
+	writel(out_ctrl, dev->mmio + HW_PXP_OUT_CTRL);
+	writel(out_buf, dev->mmio + HW_PXP_OUT_BUF);
+	writel(out_buf2, dev->mmio + HW_PXP_OUT_BUF2);
+	writel(out_pitch, dev->mmio + HW_PXP_OUT_PITCH);
+	writel(out_lrc, dev->mmio + HW_PXP_OUT_LRC);
+	writel(out_ps_ulc, dev->mmio + HW_PXP_OUT_PS_ULC);
+	writel(out_ps_lrc, dev->mmio + HW_PXP_OUT_PS_LRC);
+	writel(as_ulc, dev->mmio + HW_PXP_OUT_AS_ULC);
+	writel(as_lrc, dev->mmio + HW_PXP_OUT_AS_LRC);
+	writel(ps_ctrl, dev->mmio + HW_PXP_PS_CTRL);
+	writel(ps_buf, dev->mmio + HW_PXP_PS_BUF);
+	writel(ps_ubuf, dev->mmio + HW_PXP_PS_UBUF);
+	writel(ps_vbuf, dev->mmio + HW_PXP_PS_VBUF);
+	writel(ps_pitch, dev->mmio + HW_PXP_PS_PITCH);
+	writel(0x00ffffff, dev->mmio + HW_PXP_PS_BACKGROUND_0);
+	writel(ps_scale, dev->mmio + HW_PXP_PS_SCALE);
+	writel(ps_offset, dev->mmio + HW_PXP_PS_OFFSET);
+	/* disable processed surface color keying */
+	writel(0x00ffffff, dev->mmio + HW_PXP_PS_CLRKEYLOW_0);
+	writel(0x00000000, dev->mmio + HW_PXP_PS_CLRKEYHIGH_0);
+
+	/* disable alpha surface color keying */
+	writel(0x00ffffff, dev->mmio + HW_PXP_AS_CLRKEYLOW_0);
+	writel(0x00000000, dev->mmio + HW_PXP_AS_CLRKEYHIGH_0);
+
+	/* setup CSC */
+	pxp_setup_csc(ctx);
+
+	/* bypass LUT */
+	writel(BM_PXP_LUT_CTRL_BYPASS, dev->mmio + HW_PXP_LUT_CTRL);
+
+	writel(BF_PXP_DATA_PATH_CTRL0_MUX15_SEL(0)|
+	       BF_PXP_DATA_PATH_CTRL0_MUX14_SEL(1)|
+	       BF_PXP_DATA_PATH_CTRL0_MUX13_SEL(0)|
+	       BF_PXP_DATA_PATH_CTRL0_MUX12_SEL(0)|
+	       BF_PXP_DATA_PATH_CTRL0_MUX11_SEL(0)|
+	       BF_PXP_DATA_PATH_CTRL0_MUX10_SEL(0)|
+	       BF_PXP_DATA_PATH_CTRL0_MUX9_SEL(1)|
+	       BF_PXP_DATA_PATH_CTRL0_MUX8_SEL(0)|
+	       BF_PXP_DATA_PATH_CTRL0_MUX7_SEL(0)|
+	       BF_PXP_DATA_PATH_CTRL0_MUX6_SEL(0)|
+	       BF_PXP_DATA_PATH_CTRL0_MUX5_SEL(0)|
+	       BF_PXP_DATA_PATH_CTRL0_MUX4_SEL(0)|
+	       BF_PXP_DATA_PATH_CTRL0_MUX3_SEL(0)|
+	       BF_PXP_DATA_PATH_CTRL0_MUX2_SEL(0)|
+	       BF_PXP_DATA_PATH_CTRL0_MUX1_SEL(0)|
+	       BF_PXP_DATA_PATH_CTRL0_MUX0_SEL(0),
+	       dev->mmio + HW_PXP_DATA_PATH_CTRL0);
+	writel(BF_PXP_DATA_PATH_CTRL1_MUX17_SEL(1) |
+	       BF_PXP_DATA_PATH_CTRL1_MUX16_SEL(1),
+	       dev->mmio + HW_PXP_DATA_PATH_CTRL1);
+
+	writel(0xffff, dev->mmio + HW_PXP_IRQ_MASK);
+
+	/* ungate, enable PS/AS/OUT and PXP operation */
+	writel(BM_PXP_CTRL_IRQ_ENABLE, dev->mmio + HW_PXP_CTRL_SET);
+	writel(BM_PXP_CTRL_ENABLE | BM_PXP_CTRL_ENABLE_CSC2 |
+	       BM_PXP_CTRL_ENABLE_LUT | BM_PXP_CTRL_ENABLE_ROTATE0 |
+	       BM_PXP_CTRL_ENABLE_PS_AS_OUT, dev->mmio + HW_PXP_CTRL_SET);
+
+	return 0;
+}
+
+static void pxp_job_finish(struct pxp_dev *dev)
+{
+	struct pxp_ctx *curr_ctx;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
+	unsigned long flags;
+
+	curr_ctx = v4l2_m2m_get_curr_priv(dev->m2m_dev);
+
+	if (curr_ctx == NULL) {
+		pr_err("Instance released before the end of transaction\n");
+		return;
+	}
+
+	src_vb = v4l2_m2m_src_buf_remove(curr_ctx->fh.m2m_ctx);
+	dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->fh.m2m_ctx);
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+	v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
+	v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	dprintk(curr_ctx->dev, "Finishing transaction\n");
+	v4l2_m2m_job_finish(dev->m2m_dev, curr_ctx->fh.m2m_ctx);
+}
+
+/*
+ * mem2mem callbacks
+ */
+static void pxp_device_run(void *priv)
+{
+	struct pxp_ctx *ctx = priv;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
+
+	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
+
+	pxp_start(ctx, src_buf, dst_buf);
+}
+
+static int pxp_job_ready(void *priv)
+{
+	struct pxp_ctx *ctx = priv;
+
+	if (v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx) < 1 ||
+	    v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx) < 1) {
+		dprintk(ctx->dev, "Not enough buffers available\n");
+		return 0;
+	}
+
+	return 1;
+}
+
+static void pxp_job_abort(void *priv)
+{
+	struct pxp_ctx *ctx = priv;
+
+	/* Will cancel the transaction in the next interrupt handler */
+	ctx->aborting = 1;
+}
+
+/*
+ * interrupt handler
+ */
+static irqreturn_t pxp_irq_handler(int irq, void *dev_id)
+{
+	struct pxp_dev *dev = dev_id;
+	u32 stat;
+
+	stat = readl(dev->mmio + HW_PXP_STAT);
+
+	if (stat & BM_PXP_STAT_IRQ0) {
+		/* we expect x = 0, y = height, irq0 = 1 */
+		if (stat & ~(BM_PXP_STAT_BLOCKX | BM_PXP_STAT_BLOCKY |
+			     BM_PXP_STAT_IRQ0))
+			dprintk(dev, "%s: stat = 0x%08x\n", __func__, stat);
+		writel(BM_PXP_STAT_IRQ0, dev->mmio + HW_PXP_STAT_CLR);
+
+		pxp_job_finish(dev);
+	} else {
+		u32 irq = readl(dev->mmio + HW_PXP_IRQ);
+
+		dprintk(dev, "%s: stat = 0x%08x\n", __func__, stat);
+		dprintk(dev, "%s: irq = 0x%08x\n", __func__, irq);
+
+		writel(irq, dev->mmio + HW_PXP_IRQ_CLR);
+	}
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * video ioctls
+ */
+static int pxp_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	strlcpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver));
+	strlcpy(cap->card, MEM2MEM_NAME, sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info),
+			"platform:%s", MEM2MEM_NAME);
+	return 0;
+}
+
+static int pxp_enum_fmt(struct v4l2_fmtdesc *f, u32 type)
+{
+	int i, num;
+	struct pxp_fmt *fmt;
+
+	num = 0;
+
+	for (i = 0; i < NUM_FORMATS; ++i) {
+		if (formats[i].types & type) {
+			/* index-th format of type type found ? */
+			if (num == f->index)
+				break;
+			/*
+			 * Correct type but haven't reached our index yet,
+			 * just increment per-type index
+			 */
+			++num;
+		}
+	}
+
+	if (i < NUM_FORMATS) {
+		/* Format found */
+		fmt = &formats[i];
+		f->pixelformat = fmt->fourcc;
+		return 0;
+	}
+
+	/* Format not found */
+	return -EINVAL;
+}
+
+static int pxp_enum_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_fmtdesc *f)
+{
+	return pxp_enum_fmt(f, MEM2MEM_CAPTURE);
+}
+
+static int pxp_enum_fmt_vid_out(struct file *file, void *priv,
+				struct v4l2_fmtdesc *f)
+{
+	return pxp_enum_fmt(f, MEM2MEM_OUTPUT);
+}
+
+static int pxp_g_fmt(struct pxp_ctx *ctx, struct v4l2_format *f)
+{
+	struct vb2_queue *vq;
+	struct pxp_q_data *q_data;
+
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
+
+	q_data = get_q_data(ctx, f->type);
+
+	f->fmt.pix.width	= q_data->width;
+	f->fmt.pix.height	= q_data->height;
+	f->fmt.pix.field	= V4L2_FIELD_NONE;
+	f->fmt.pix.pixelformat	= q_data->fmt->fourcc;
+	f->fmt.pix.bytesperline	= q_data->bytesperline;
+	f->fmt.pix.sizeimage	= q_data->sizeimage;
+	f->fmt.pix.colorspace	= ctx->colorspace;
+	f->fmt.pix.xfer_func	= ctx->xfer_func;
+	f->fmt.pix.ycbcr_enc	= q_data->ycbcr_enc;
+	f->fmt.pix.quantization	= q_data->quant;
+
+	return 0;
+}
+
+static int pxp_g_fmt_vid_out(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	return pxp_g_fmt(file2ctx(file), f);
+}
+
+static int pxp_g_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	return pxp_g_fmt(file2ctx(file), f);
+}
+
+static inline u32 pxp_bytesperline(struct pxp_fmt *fmt, u32 width)
+{
+	switch (fmt->fourcc) {
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_YUV422P:
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV61:
+		return width;
+	default:
+		return (width * fmt->depth) >> 3;
+	}
+}
+
+static inline u32 pxp_sizeimage(struct pxp_fmt *fmt, u32 width, u32 height)
+{
+	return (fmt->depth * width * height) >> 3;
+}
+
+static int pxp_try_fmt(struct v4l2_format *f, struct pxp_fmt *fmt)
+{
+	v4l_bound_align_image(&f->fmt.pix.width, MIN_W, MAX_W, ALIGN_W,
+			      &f->fmt.pix.height, MIN_H, MAX_H, ALIGN_H, 0);
+
+	f->fmt.pix.bytesperline = pxp_bytesperline(fmt, f->fmt.pix.width);
+	f->fmt.pix.sizeimage = pxp_sizeimage(fmt, f->fmt.pix.width,
+					     f->fmt.pix.height);
+	f->fmt.pix.field = V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+static void
+pxp_fixup_colorimetry_cap(struct pxp_ctx *ctx, u32 dst_fourcc,
+			  enum v4l2_ycbcr_encoding *ycbcr_enc,
+			  enum v4l2_quantization *quantization)
+{
+	bool dst_is_yuv = pxp_v4l2_pix_fmt_is_yuv(dst_fourcc);
+
+	if (pxp_v4l2_pix_fmt_is_yuv(ctx->q_data[V4L2_M2M_SRC].fmt->fourcc) ==
+	    dst_is_yuv) {
+		/*
+		 * There is no support for conversion between different YCbCr
+		 * encodings or between RGB limited and full range.
+		 */
+		*ycbcr_enc = ctx->q_data[V4L2_M2M_SRC].ycbcr_enc;
+		*quantization = ctx->q_data[V4L2_M2M_SRC].quant;
+	} else {
+		*ycbcr_enc = V4L2_MAP_YCBCR_ENC_DEFAULT(ctx->colorspace);
+		*quantization = V4L2_MAP_QUANTIZATION_DEFAULT(!dst_is_yuv,
+							      ctx->colorspace,
+							      *ycbcr_enc);
+	}
+}
+
+static int pxp_try_fmt_vid_cap(struct file *file, void *priv,
+			       struct v4l2_format *f)
+{
+	struct pxp_fmt *fmt;
+	struct pxp_ctx *ctx = file2ctx(file);
+
+	fmt = find_format(f);
+	if (!fmt) {
+		f->fmt.pix.pixelformat = formats[0].fourcc;
+		fmt = find_format(f);
+	}
+	if (!(fmt->types & MEM2MEM_CAPTURE)) {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			 "Fourcc format (0x%08x) invalid.\n",
+			 f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+	f->fmt.pix.colorspace = ctx->colorspace;
+	f->fmt.pix.xfer_func = ctx->xfer_func;
+
+	pxp_fixup_colorimetry_cap(ctx, fmt->fourcc,
+				  &f->fmt.pix.ycbcr_enc,
+				  &f->fmt.pix.quantization);
+
+	return pxp_try_fmt(f, fmt);
+}
+
+static int pxp_try_fmt_vid_out(struct file *file, void *priv,
+			       struct v4l2_format *f)
+{
+	struct pxp_fmt *fmt;
+	struct pxp_ctx *ctx = file2ctx(file);
+
+	fmt = find_format(f);
+	if (!fmt) {
+		f->fmt.pix.pixelformat = formats[0].fourcc;
+		fmt = find_format(f);
+	}
+	if (!(fmt->types & MEM2MEM_OUTPUT)) {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			 "Fourcc format (0x%08x) invalid.\n",
+			 f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+	if (!f->fmt.pix.colorspace)
+		f->fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
+
+	return pxp_try_fmt(f, fmt);
+}
+
+static int pxp_s_fmt(struct pxp_ctx *ctx, struct v4l2_format *f)
+{
+	struct pxp_q_data *q_data;
+	struct vb2_queue *vq;
+
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
+
+	q_data = get_q_data(ctx, f->type);
+	if (!q_data)
+		return -EINVAL;
+
+	if (vb2_is_busy(vq)) {
+		v4l2_err(&ctx->dev->v4l2_dev, "%s queue busy\n", __func__);
+		return -EBUSY;
+	}
+
+	q_data->fmt		= find_format(f);
+	q_data->width		= f->fmt.pix.width;
+	q_data->height		= f->fmt.pix.height;
+	q_data->bytesperline	= f->fmt.pix.bytesperline;
+	q_data->sizeimage	= f->fmt.pix.sizeimage;
+
+	dprintk(ctx->dev,
+		"Setting format for type %d, wxh: %dx%d, fmt: %d\n",
+		f->type, q_data->width, q_data->height, q_data->fmt->fourcc);
+
+	return 0;
+}
+
+static int pxp_s_fmt_vid_cap(struct file *file, void *priv,
+			     struct v4l2_format *f)
+{
+	struct pxp_ctx *ctx = file2ctx(file);
+	int ret;
+
+	ret = pxp_try_fmt_vid_cap(file, priv, f);
+	if (ret)
+		return ret;
+
+	ret = pxp_s_fmt(file2ctx(file), f);
+	if (ret)
+		return ret;
+
+	ctx->q_data[V4L2_M2M_DST].ycbcr_enc = f->fmt.pix.ycbcr_enc;
+	ctx->q_data[V4L2_M2M_DST].quant = f->fmt.pix.quantization;
+
+	return 0;
+}
+
+static int pxp_s_fmt_vid_out(struct file *file, void *priv,
+			     struct v4l2_format *f)
+{
+	struct pxp_ctx *ctx = file2ctx(file);
+	int ret;
+
+	ret = pxp_try_fmt_vid_out(file, priv, f);
+	if (ret)
+		return ret;
+
+	ret = pxp_s_fmt(file2ctx(file), f);
+	if (ret)
+		return ret;
+
+	ctx->colorspace = f->fmt.pix.colorspace;
+	ctx->xfer_func = f->fmt.pix.xfer_func;
+	ctx->q_data[V4L2_M2M_SRC].ycbcr_enc = f->fmt.pix.ycbcr_enc;
+	ctx->q_data[V4L2_M2M_SRC].quant = f->fmt.pix.quantization;
+
+	pxp_fixup_colorimetry_cap(ctx, ctx->q_data[V4L2_M2M_DST].fmt->fourcc,
+				  &ctx->q_data[V4L2_M2M_DST].ycbcr_enc,
+				  &ctx->q_data[V4L2_M2M_DST].quant);
+
+	return 0;
+}
+
+static int pxp_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct pxp_ctx *ctx =
+		container_of(ctrl->handler, struct pxp_ctx, hdl);
+
+	switch (ctrl->id) {
+	case V4L2_CID_HFLIP:
+		if (ctrl->val)
+			ctx->mode |= MEM2MEM_HFLIP;
+		else
+			ctx->mode &= ~MEM2MEM_HFLIP;
+		break;
+
+	case V4L2_CID_VFLIP:
+		if (ctrl->val)
+			ctx->mode |= MEM2MEM_VFLIP;
+		else
+			ctx->mode &= ~MEM2MEM_VFLIP;
+		break;
+
+	case V4L2_CID_ALPHA_COMPONENT:
+		ctx->alpha_component = ctrl->val;
+		break;
+
+	default:
+		v4l2_err(&ctx->dev->v4l2_dev, "Invalid control\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops pxp_ctrl_ops = {
+	.s_ctrl = pxp_s_ctrl,
+};
+
+static const struct v4l2_ioctl_ops pxp_ioctl_ops = {
+	.vidioc_querycap	= pxp_querycap,
+
+	.vidioc_enum_fmt_vid_cap = pxp_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap	= pxp_g_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap	= pxp_try_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap	= pxp_s_fmt_vid_cap,
+
+	.vidioc_enum_fmt_vid_out = pxp_enum_fmt_vid_out,
+	.vidioc_g_fmt_vid_out	= pxp_g_fmt_vid_out,
+	.vidioc_try_fmt_vid_out	= pxp_try_fmt_vid_out,
+	.vidioc_s_fmt_vid_out	= pxp_s_fmt_vid_out,
+
+	.vidioc_reqbufs		= v4l2_m2m_ioctl_reqbufs,
+	.vidioc_querybuf	= v4l2_m2m_ioctl_querybuf,
+	.vidioc_qbuf		= v4l2_m2m_ioctl_qbuf,
+	.vidioc_dqbuf		= v4l2_m2m_ioctl_dqbuf,
+	.vidioc_prepare_buf	= v4l2_m2m_ioctl_prepare_buf,
+	.vidioc_create_bufs	= v4l2_m2m_ioctl_create_bufs,
+	.vidioc_expbuf		= v4l2_m2m_ioctl_expbuf,
+
+	.vidioc_streamon	= v4l2_m2m_ioctl_streamon,
+	.vidioc_streamoff	= v4l2_m2m_ioctl_streamoff,
+
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+};
+
+/*
+ * Queue operations
+ */
+static int pxp_queue_setup(struct vb2_queue *vq,
+			   unsigned int *nbuffers, unsigned int *nplanes,
+			   unsigned int sizes[], struct device *alloc_devs[])
+{
+	struct pxp_ctx *ctx = vb2_get_drv_priv(vq);
+	struct pxp_q_data *q_data;
+	unsigned int size, count = *nbuffers;
+
+	q_data = get_q_data(ctx, vq->type);
+
+	size = q_data->sizeimage;
+
+	*nbuffers = count;
+
+	if (*nplanes)
+		return sizes[0] < size ? -EINVAL : 0;
+
+	*nplanes = 1;
+	sizes[0] = size;
+
+	dprintk(ctx->dev, "get %d buffer(s) of size %d each.\n", count, size);
+
+	return 0;
+}
+
+static int pxp_buf_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct pxp_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct pxp_dev *dev = ctx->dev;
+	struct pxp_q_data *q_data;
+
+	dprintk(ctx->dev, "type: %d\n", vb->vb2_queue->type);
+
+	q_data = get_q_data(ctx, vb->vb2_queue->type);
+	if (V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
+		if (vbuf->field == V4L2_FIELD_ANY)
+			vbuf->field = V4L2_FIELD_NONE;
+		if (vbuf->field != V4L2_FIELD_NONE) {
+			dprintk(dev, "%s field isn't supported\n", __func__);
+			return -EINVAL;
+		}
+	}
+
+	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
+		dprintk(dev, "%s data will not fit into plane (%lu < %lu)\n",
+			__func__, vb2_plane_size(vb, 0),
+			(long)q_data->sizeimage);
+		return -EINVAL;
+	}
+
+	vb2_set_plane_payload(vb, 0, q_data->sizeimage);
+
+	return 0;
+}
+
+static void pxp_buf_queue(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct pxp_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+
+	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
+}
+
+static int pxp_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct pxp_ctx *ctx = vb2_get_drv_priv(q);
+	struct pxp_q_data *q_data = get_q_data(ctx, q->type);
+
+	q_data->sequence = 0;
+	return 0;
+}
+
+static void pxp_stop_streaming(struct vb2_queue *q)
+{
+	struct pxp_ctx *ctx = vb2_get_drv_priv(q);
+	struct vb2_v4l2_buffer *vbuf;
+	unsigned long flags;
+
+	for (;;) {
+		if (V4L2_TYPE_IS_OUTPUT(q->type))
+			vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+		else
+			vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+		if (vbuf == NULL)
+			return;
+		spin_lock_irqsave(&ctx->dev->irqlock, flags);
+		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
+		spin_unlock_irqrestore(&ctx->dev->irqlock, flags);
+	}
+}
+
+static const struct vb2_ops pxp_qops = {
+	.queue_setup	 = pxp_queue_setup,
+	.buf_prepare	 = pxp_buf_prepare,
+	.buf_queue	 = pxp_buf_queue,
+	.start_streaming = pxp_start_streaming,
+	.stop_streaming  = pxp_stop_streaming,
+	.wait_prepare	 = vb2_ops_wait_prepare,
+	.wait_finish	 = vb2_ops_wait_finish,
+};
+
+static int queue_init(void *priv, struct vb2_queue *src_vq,
+		      struct vb2_queue *dst_vq)
+{
+	struct pxp_ctx *ctx = priv;
+	int ret;
+
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	src_vq->drv_priv = ctx;
+	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	src_vq->ops = &pxp_qops;
+	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->lock = &ctx->dev->dev_mutex;
+	src_vq->dev = ctx->dev->v4l2_dev.dev;
+
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	dst_vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	dst_vq->drv_priv = ctx;
+	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	dst_vq->ops = &pxp_qops;
+	dst_vq->mem_ops = &vb2_dma_contig_memops;
+	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->lock = &ctx->dev->dev_mutex;
+	dst_vq->dev = ctx->dev->v4l2_dev.dev;
+
+	return vb2_queue_init(dst_vq);
+}
+
+/*
+ * File operations
+ */
+static int pxp_open(struct file *file)
+{
+	struct pxp_dev *dev = video_drvdata(file);
+	struct pxp_ctx *ctx = NULL;
+	struct v4l2_ctrl_handler *hdl;
+	int rc = 0;
+
+	if (mutex_lock_interruptible(&dev->dev_mutex))
+		return -ERESTARTSYS;
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		rc = -ENOMEM;
+		goto open_unlock;
+	}
+
+	v4l2_fh_init(&ctx->fh, video_devdata(file));
+	file->private_data = &ctx->fh;
+	ctx->dev = dev;
+	hdl = &ctx->hdl;
+	v4l2_ctrl_handler_init(hdl, 4);
+	v4l2_ctrl_new_std(hdl, &pxp_ctrl_ops, V4L2_CID_HFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(hdl, &pxp_ctrl_ops, V4L2_CID_VFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(hdl, &pxp_ctrl_ops, V4L2_CID_ALPHA_COMPONENT,
+			  0, 255, 1, 255);
+	if (hdl->error) {
+		rc = hdl->error;
+		v4l2_ctrl_handler_free(hdl);
+		kfree(ctx);
+		goto open_unlock;
+	}
+	ctx->fh.ctrl_handler = hdl;
+	v4l2_ctrl_handler_setup(hdl);
+
+	ctx->q_data[V4L2_M2M_SRC].fmt = &formats[0];
+	ctx->q_data[V4L2_M2M_SRC].width = 640;
+	ctx->q_data[V4L2_M2M_SRC].height = 480;
+	ctx->q_data[V4L2_M2M_SRC].bytesperline =
+		pxp_bytesperline(&formats[0], 640);
+	ctx->q_data[V4L2_M2M_SRC].sizeimage =
+		pxp_sizeimage(&formats[0], 640, 480);
+	ctx->q_data[V4L2_M2M_DST] = ctx->q_data[V4L2_M2M_SRC];
+	ctx->colorspace = V4L2_COLORSPACE_REC709;
+
+	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx, &queue_init);
+
+	if (IS_ERR(ctx->fh.m2m_ctx)) {
+		rc = PTR_ERR(ctx->fh.m2m_ctx);
+
+		v4l2_ctrl_handler_free(hdl);
+		v4l2_fh_exit(&ctx->fh);
+		kfree(ctx);
+		goto open_unlock;
+	}
+
+	v4l2_fh_add(&ctx->fh);
+	atomic_inc(&dev->num_inst);
+
+	dprintk(dev, "Created instance: %p, m2m_ctx: %p\n",
+		ctx, ctx->fh.m2m_ctx);
+
+open_unlock:
+	mutex_unlock(&dev->dev_mutex);
+	return rc;
+}
+
+static int pxp_release(struct file *file)
+{
+	struct pxp_dev *dev = video_drvdata(file);
+	struct pxp_ctx *ctx = file2ctx(file);
+
+	dprintk(dev, "Releasing instance %p\n", ctx);
+
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	v4l2_ctrl_handler_free(&ctx->hdl);
+	mutex_lock(&dev->dev_mutex);
+	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
+	mutex_unlock(&dev->dev_mutex);
+	kfree(ctx);
+
+	atomic_dec(&dev->num_inst);
+
+	return 0;
+}
+
+static const struct v4l2_file_operations pxp_fops = {
+	.owner		= THIS_MODULE,
+	.open		= pxp_open,
+	.release	= pxp_release,
+	.poll		= v4l2_m2m_fop_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= v4l2_m2m_fop_mmap,
+};
+
+static const struct video_device pxp_videodev = {
+	.name		= MEM2MEM_NAME,
+	.vfl_dir	= VFL_DIR_M2M,
+	.fops		= &pxp_fops,
+	.device_caps	= V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING,
+	.ioctl_ops	= &pxp_ioctl_ops,
+	.minor		= -1,
+	.release	= video_device_release_empty,
+};
+
+static const struct v4l2_m2m_ops m2m_ops = {
+	.device_run	= pxp_device_run,
+	.job_ready	= pxp_job_ready,
+	.job_abort	= pxp_job_abort,
+};
+
+static void pxp_soft_reset(struct pxp_dev *dev)
+{
+	int ret;
+	u32 val;
+
+	writel(BM_PXP_CTRL_SFTRST, dev->mmio + HW_PXP_CTRL_CLR);
+	writel(BM_PXP_CTRL_CLKGATE, dev->mmio + HW_PXP_CTRL_CLR);
+
+	writel(BM_PXP_CTRL_SFTRST, dev->mmio + HW_PXP_CTRL_SET);
+
+	ret = readl_poll_timeout(dev->mmio + HW_PXP_CTRL, val,
+				 val & BM_PXP_CTRL_CLKGATE, 0, 100);
+	if (ret < 0)
+		pr_err("PXP reset timeout\n");
+
+	writel(BM_PXP_CTRL_SFTRST, dev->mmio + HW_PXP_CTRL_CLR);
+	writel(BM_PXP_CTRL_CLKGATE, dev->mmio + HW_PXP_CTRL_CLR);
+}
+
+static int pxp_probe(struct platform_device *pdev)
+{
+	struct pxp_dev *dev;
+	struct resource *res;
+	struct video_device *vfd;
+	int irq;
+	int ret;
+
+	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	dev->clk = devm_clk_get(&pdev->dev, "axi");
+	if (IS_ERR(dev->clk)) {
+		ret = PTR_ERR(dev->clk);
+		dev_err(&pdev->dev, "Failed to get clk: %d\n", ret);
+		return ret;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	dev->mmio = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(dev->mmio)) {
+		ret = PTR_ERR(dev->mmio);
+		dev_err(&pdev->dev, "Failed to map register space: %d\n", ret);
+		return ret;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "Failed to get irq resource: %d\n", irq);
+		return irq;
+	}
+
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL, pxp_irq_handler,
+			IRQF_ONESHOT, dev_name(&pdev->dev), dev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to request irq: %d\n", ret);
+		return ret;
+	}
+
+	clk_prepare_enable(dev->clk);
+	pxp_soft_reset(dev);
+
+	spin_lock_init(&dev->irqlock);
+
+	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
+	if (ret)
+		goto err_clk;
+
+	atomic_set(&dev->num_inst, 0);
+	mutex_init(&dev->dev_mutex);
+
+	dev->vfd = pxp_videodev;
+	vfd = &dev->vfd;
+	vfd->lock = &dev->dev_mutex;
+	vfd->v4l2_dev = &dev->v4l2_dev;
+
+	video_set_drvdata(vfd, dev);
+	snprintf(vfd->name, sizeof(vfd->name), "%s", pxp_videodev.name);
+	v4l2_info(&dev->v4l2_dev,
+			"Device registered as /dev/video%d\n", vfd->num);
+
+	platform_set_drvdata(pdev, dev);
+
+	dev->m2m_dev = v4l2_m2m_init(&m2m_ops);
+	if (IS_ERR(dev->m2m_dev)) {
+		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem device\n");
+		ret = PTR_ERR(dev->m2m_dev);
+		goto err_v4l2;
+	}
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+		goto err_m2m;
+	}
+
+	return 0;
+
+err_m2m:
+	v4l2_m2m_release(dev->m2m_dev);
+err_v4l2:
+	v4l2_device_unregister(&dev->v4l2_dev);
+err_clk:
+	clk_disable_unprepare(dev->clk);
+
+	return ret;
+}
+
+static int pxp_remove(struct platform_device *pdev)
+{
+	struct pxp_dev *dev = platform_get_drvdata(pdev);
+
+	writel(BM_PXP_CTRL_CLKGATE, dev->mmio + HW_PXP_CTRL_SET);
+	writel(BM_PXP_CTRL_SFTRST, dev->mmio + HW_PXP_CTRL_SET);
+
+	clk_disable_unprepare(dev->clk);
+
+	v4l2_info(&dev->v4l2_dev, "Removing " MEM2MEM_NAME);
+	video_unregister_device(&dev->vfd);
+	v4l2_m2m_release(dev->m2m_dev);
+	v4l2_device_unregister(&dev->v4l2_dev);
+
+	return 0;
+}
+
+static const struct of_device_id pxp_dt_ids[] = {
+	{ .compatible = "fsl,imx6ull-pxp", .data = NULL },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, pxp_dt_ids);
+
+static struct platform_driver pxp_driver = {
+	.probe		= pxp_probe,
+	.remove		= pxp_remove,
+	.driver		= {
+		.name	= MEM2MEM_NAME,
+		.of_match_table = of_match_ptr(pxp_dt_ids),
+	},
+};
+
+module_platform_driver(pxp_driver);
+
+MODULE_DESCRIPTION("i.MX PXP mem2mem scaler/CSC/rotator");
+MODULE_AUTHOR("Philipp Zabel <kernel@pengutronix.de>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/imx-pxp.h b/drivers/media/platform/imx-pxp.h
new file mode 100644
index 000000000000..44f95c749d2e
--- /dev/null
+++ b/drivers/media/platform/imx-pxp.h
@@ -0,0 +1,1685 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Freescale PXP Register Definitions
+ *
+ * based on pxp_dma_v3.h, Xml Revision: 1.77, Template Revision: 1.3
+ *
+ * Copyright 2014-2015 Freescale Semiconductor, Inc. All Rights Reserved.
+ */
+
+#ifndef __IMX_PXP_H__
+#define __IMX_PXP_H__
+
+#define HW_PXP_CTRL	(0x00000000)
+#define HW_PXP_CTRL_SET	(0x00000004)
+#define HW_PXP_CTRL_CLR	(0x00000008)
+#define HW_PXP_CTRL_TOG	(0x0000000c)
+
+#define BM_PXP_CTRL_SFTRST 0x80000000
+#define BF_PXP_CTRL_SFTRST(v) \
+	(((v) << 31) & BM_PXP_CTRL_SFTRST)
+#define BM_PXP_CTRL_CLKGATE 0x40000000
+#define BF_PXP_CTRL_CLKGATE(v)  \
+	(((v) << 30) & BM_PXP_CTRL_CLKGATE)
+#define BM_PXP_CTRL_RSVD4 0x20000000
+#define BF_PXP_CTRL_RSVD4(v)  \
+	(((v) << 29) & BM_PXP_CTRL_RSVD4)
+#define BM_PXP_CTRL_EN_REPEAT 0x10000000
+#define BF_PXP_CTRL_EN_REPEAT(v)  \
+	(((v) << 28) & BM_PXP_CTRL_EN_REPEAT)
+#define BM_PXP_CTRL_ENABLE_ROTATE1 0x08000000
+#define BF_PXP_CTRL_ENABLE_ROTATE1(v)  \
+	(((v) << 27) & BM_PXP_CTRL_ENABLE_ROTATE1)
+#define BM_PXP_CTRL_ENABLE_ROTATE0 0x04000000
+#define BF_PXP_CTRL_ENABLE_ROTATE0(v)  \
+	(((v) << 26) & BM_PXP_CTRL_ENABLE_ROTATE0)
+#define BM_PXP_CTRL_ENABLE_LUT 0x02000000
+#define BF_PXP_CTRL_ENABLE_LUT(v)  \
+	(((v) << 25) & BM_PXP_CTRL_ENABLE_LUT)
+#define BM_PXP_CTRL_ENABLE_CSC2 0x01000000
+#define BF_PXP_CTRL_ENABLE_CSC2(v)  \
+	(((v) << 24) & BM_PXP_CTRL_ENABLE_CSC2)
+#define BM_PXP_CTRL_BLOCK_SIZE 0x00800000
+#define BF_PXP_CTRL_BLOCK_SIZE(v)  \
+	(((v) << 23) & BM_PXP_CTRL_BLOCK_SIZE)
+#define BV_PXP_CTRL_BLOCK_SIZE__8X8   0x0
+#define BV_PXP_CTRL_BLOCK_SIZE__16X16 0x1
+#define BM_PXP_CTRL_RSVD1 0x00400000
+#define BF_PXP_CTRL_RSVD1(v)  \
+	(((v) << 22) & BM_PXP_CTRL_RSVD1)
+#define BM_PXP_CTRL_ENABLE_ALPHA_B 0x00200000
+#define BF_PXP_CTRL_ENABLE_ALPHA_B(v)  \
+	(((v) << 21) & BM_PXP_CTRL_ENABLE_ALPHA_B)
+#define BM_PXP_CTRL_ENABLE_INPUT_FETCH_STORE 0x00100000
+#define BF_PXP_CTRL_ENABLE_INPUT_FETCH_STORE(v)  \
+	(((v) << 20) & BM_PXP_CTRL_ENABLE_INPUT_FETCH_STORE)
+#define BM_PXP_CTRL_ENABLE_WFE_B 0x00080000
+#define BF_PXP_CTRL_ENABLE_WFE_B(v)  \
+	(((v) << 19) & BM_PXP_CTRL_ENABLE_WFE_B)
+#define BM_PXP_CTRL_ENABLE_WFE_A 0x00040000
+#define BF_PXP_CTRL_ENABLE_WFE_A(v)  \
+	(((v) << 18) & BM_PXP_CTRL_ENABLE_WFE_A)
+#define BM_PXP_CTRL_ENABLE_DITHER 0x00020000
+#define BF_PXP_CTRL_ENABLE_DITHER(v)  \
+	(((v) << 17) & BM_PXP_CTRL_ENABLE_DITHER)
+#define BM_PXP_CTRL_ENABLE_PS_AS_OUT 0x00010000
+#define BF_PXP_CTRL_ENABLE_PS_AS_OUT(v)  \
+	(((v) << 16) & BM_PXP_CTRL_ENABLE_PS_AS_OUT)
+#define BM_PXP_CTRL_VFLIP1 0x00008000
+#define BF_PXP_CTRL_VFLIP1(v)  \
+	(((v) << 15) & BM_PXP_CTRL_VFLIP1)
+#define BM_PXP_CTRL_HFLIP1 0x00004000
+#define BF_PXP_CTRL_HFLIP1(v)  \
+	(((v) << 14) & BM_PXP_CTRL_HFLIP1)
+#define BP_PXP_CTRL_ROTATE1      12
+#define BM_PXP_CTRL_ROTATE1 0x00003000
+#define BF_PXP_CTRL_ROTATE1(v)  \
+	(((v) << 12) & BM_PXP_CTRL_ROTATE1)
+#define BV_PXP_CTRL_ROTATE1__ROT_0   0x0
+#define BV_PXP_CTRL_ROTATE1__ROT_90  0x1
+#define BV_PXP_CTRL_ROTATE1__ROT_180 0x2
+#define BV_PXP_CTRL_ROTATE1__ROT_270 0x3
+#define BM_PXP_CTRL_VFLIP0 0x00000800
+#define BF_PXP_CTRL_VFLIP0(v)  \
+	(((v) << 11) & BM_PXP_CTRL_VFLIP0)
+#define BM_PXP_CTRL_HFLIP0 0x00000400
+#define BF_PXP_CTRL_HFLIP0(v)  \
+	(((v) << 10) & BM_PXP_CTRL_HFLIP0)
+#define BP_PXP_CTRL_ROTATE0      8
+#define BM_PXP_CTRL_ROTATE0 0x00000300
+#define BF_PXP_CTRL_ROTATE0(v)  \
+	(((v) << 8) & BM_PXP_CTRL_ROTATE0)
+#define BV_PXP_CTRL_ROTATE0__ROT_0   0x0
+#define BV_PXP_CTRL_ROTATE0__ROT_90  0x1
+#define BV_PXP_CTRL_ROTATE0__ROT_180 0x2
+#define BV_PXP_CTRL_ROTATE0__ROT_270 0x3
+#define BP_PXP_CTRL_RSVD0      6
+#define BM_PXP_CTRL_RSVD0 0x000000C0
+#define BF_PXP_CTRL_RSVD0(v)  \
+	(((v) << 6) & BM_PXP_CTRL_RSVD0)
+#define BM_PXP_CTRL_HANDSHAKE_ABORT_SKIP 0x00000020
+#define BF_PXP_CTRL_HANDSHAKE_ABORT_SKIP(v)  \
+	(((v) << 5) & BM_PXP_CTRL_HANDSHAKE_ABORT_SKIP)
+#define BM_PXP_CTRL_ENABLE_LCD0_HANDSHAKE 0x00000010
+#define BF_PXP_CTRL_ENABLE_LCD0_HANDSHAKE(v)  \
+	(((v) << 4) & BM_PXP_CTRL_ENABLE_LCD0_HANDSHAKE)
+#define BM_PXP_CTRL_LUT_DMA_IRQ_ENABLE 0x00000008
+#define BF_PXP_CTRL_LUT_DMA_IRQ_ENABLE(v)  \
+	(((v) << 3) & BM_PXP_CTRL_LUT_DMA_IRQ_ENABLE)
+#define BM_PXP_CTRL_NEXT_IRQ_ENABLE 0x00000004
+#define BF_PXP_CTRL_NEXT_IRQ_ENABLE(v)  \
+	(((v) << 2) & BM_PXP_CTRL_NEXT_IRQ_ENABLE)
+#define BM_PXP_CTRL_IRQ_ENABLE 0x00000002
+#define BF_PXP_CTRL_IRQ_ENABLE(v)  \
+	(((v) << 1) & BM_PXP_CTRL_IRQ_ENABLE)
+#define BM_PXP_CTRL_ENABLE 0x00000001
+#define BF_PXP_CTRL_ENABLE(v)  \
+	(((v) << 0) & BM_PXP_CTRL_ENABLE)
+
+#define HW_PXP_STAT	(0x00000010)
+#define HW_PXP_STAT_SET	(0x00000014)
+#define HW_PXP_STAT_CLR	(0x00000018)
+#define HW_PXP_STAT_TOG	(0x0000001c)
+
+#define BP_PXP_STAT_BLOCKX      24
+#define BM_PXP_STAT_BLOCKX 0xFF000000
+#define BF_PXP_STAT_BLOCKX(v) \
+	(((v) << 24) & BM_PXP_STAT_BLOCKX)
+#define BP_PXP_STAT_BLOCKY      16
+#define BM_PXP_STAT_BLOCKY 0x00FF0000
+#define BF_PXP_STAT_BLOCKY(v)  \
+	(((v) << 16) & BM_PXP_STAT_BLOCKY)
+#define BP_PXP_STAT_AXI_ERROR_ID_1      12
+#define BM_PXP_STAT_AXI_ERROR_ID_1 0x0000F000
+#define BF_PXP_STAT_AXI_ERROR_ID_1(v)  \
+	(((v) << 12) & BM_PXP_STAT_AXI_ERROR_ID_1)
+#define BM_PXP_STAT_RSVD2 0x00000800
+#define BF_PXP_STAT_RSVD2(v)  \
+	(((v) << 11) & BM_PXP_STAT_RSVD2)
+#define BM_PXP_STAT_AXI_READ_ERROR_1 0x00000400
+#define BF_PXP_STAT_AXI_READ_ERROR_1(v)  \
+	(((v) << 10) & BM_PXP_STAT_AXI_READ_ERROR_1)
+#define BM_PXP_STAT_AXI_WRITE_ERROR_1 0x00000200
+#define BF_PXP_STAT_AXI_WRITE_ERROR_1(v)  \
+	(((v) << 9) & BM_PXP_STAT_AXI_WRITE_ERROR_1)
+#define BM_PXP_STAT_LUT_DMA_LOAD_DONE_IRQ 0x00000100
+#define BF_PXP_STAT_LUT_DMA_LOAD_DONE_IRQ(v)  \
+	(((v) << 8) & BM_PXP_STAT_LUT_DMA_LOAD_DONE_IRQ)
+#define BP_PXP_STAT_AXI_ERROR_ID_0      4
+#define BM_PXP_STAT_AXI_ERROR_ID_0 0x000000F0
+#define BF_PXP_STAT_AXI_ERROR_ID_0(v)  \
+	(((v) << 4) & BM_PXP_STAT_AXI_ERROR_ID_0)
+#define BM_PXP_STAT_NEXT_IRQ 0x00000008
+#define BF_PXP_STAT_NEXT_IRQ(v)  \
+	(((v) << 3) & BM_PXP_STAT_NEXT_IRQ)
+#define BM_PXP_STAT_AXI_READ_ERROR_0 0x00000004
+#define BF_PXP_STAT_AXI_READ_ERROR_0(v)  \
+	(((v) << 2) & BM_PXP_STAT_AXI_READ_ERROR_0)
+#define BM_PXP_STAT_AXI_WRITE_ERROR_0 0x00000002
+#define BF_PXP_STAT_AXI_WRITE_ERROR_0(v)  \
+	(((v) << 1) & BM_PXP_STAT_AXI_WRITE_ERROR_0)
+#define BM_PXP_STAT_IRQ0 0x00000001
+#define BF_PXP_STAT_IRQ0(v)  \
+	(((v) << 0) & BM_PXP_STAT_IRQ0)
+
+#define HW_PXP_OUT_CTRL	(0x00000020)
+#define HW_PXP_OUT_CTRL_SET	(0x00000024)
+#define HW_PXP_OUT_CTRL_CLR	(0x00000028)
+#define HW_PXP_OUT_CTRL_TOG	(0x0000002c)
+
+#define BP_PXP_OUT_CTRL_ALPHA      24
+#define BM_PXP_OUT_CTRL_ALPHA 0xFF000000
+#define BF_PXP_OUT_CTRL_ALPHA(v) \
+	(((v) << 24) & BM_PXP_OUT_CTRL_ALPHA)
+#define BM_PXP_OUT_CTRL_ALPHA_OUTPUT 0x00800000
+#define BF_PXP_OUT_CTRL_ALPHA_OUTPUT(v)  \
+	(((v) << 23) & BM_PXP_OUT_CTRL_ALPHA_OUTPUT)
+#define BP_PXP_OUT_CTRL_RSVD1      10
+#define BM_PXP_OUT_CTRL_RSVD1 0x007FFC00
+#define BF_PXP_OUT_CTRL_RSVD1(v)  \
+	(((v) << 10) & BM_PXP_OUT_CTRL_RSVD1)
+#define BP_PXP_OUT_CTRL_INTERLACED_OUTPUT      8
+#define BM_PXP_OUT_CTRL_INTERLACED_OUTPUT 0x00000300
+#define BF_PXP_OUT_CTRL_INTERLACED_OUTPUT(v)  \
+	(((v) << 8) & BM_PXP_OUT_CTRL_INTERLACED_OUTPUT)
+#define BV_PXP_OUT_CTRL_INTERLACED_OUTPUT__PROGRESSIVE 0x0
+#define BV_PXP_OUT_CTRL_INTERLACED_OUTPUT__FIELD0      0x1
+#define BV_PXP_OUT_CTRL_INTERLACED_OUTPUT__FIELD1      0x2
+#define BV_PXP_OUT_CTRL_INTERLACED_OUTPUT__INTERLACED  0x3
+#define BP_PXP_OUT_CTRL_RSVD0      5
+#define BM_PXP_OUT_CTRL_RSVD0 0x000000E0
+#define BF_PXP_OUT_CTRL_RSVD0(v)  \
+	(((v) << 5) & BM_PXP_OUT_CTRL_RSVD0)
+#define BP_PXP_OUT_CTRL_FORMAT      0
+#define BM_PXP_OUT_CTRL_FORMAT 0x0000001F
+#define BF_PXP_OUT_CTRL_FORMAT(v)  \
+	(((v) << 0) & BM_PXP_OUT_CTRL_FORMAT)
+#define BV_PXP_OUT_CTRL_FORMAT__ARGB8888  0x0
+#define BV_PXP_OUT_CTRL_FORMAT__RGB888    0x4
+#define BV_PXP_OUT_CTRL_FORMAT__RGB888P   0x5
+#define BV_PXP_OUT_CTRL_FORMAT__ARGB1555  0x8
+#define BV_PXP_OUT_CTRL_FORMAT__ARGB4444  0x9
+#define BV_PXP_OUT_CTRL_FORMAT__RGB555    0xC
+#define BV_PXP_OUT_CTRL_FORMAT__RGB444    0xD
+#define BV_PXP_OUT_CTRL_FORMAT__RGB565    0xE
+#define BV_PXP_OUT_CTRL_FORMAT__YUV1P444  0x10
+#define BV_PXP_OUT_CTRL_FORMAT__UYVY1P422 0x12
+#define BV_PXP_OUT_CTRL_FORMAT__VYUY1P422 0x13
+#define BV_PXP_OUT_CTRL_FORMAT__Y8	0x14
+#define BV_PXP_OUT_CTRL_FORMAT__Y4	0x15
+#define BV_PXP_OUT_CTRL_FORMAT__YUV2P422  0x18
+#define BV_PXP_OUT_CTRL_FORMAT__YUV2P420  0x19
+#define BV_PXP_OUT_CTRL_FORMAT__YVU2P422  0x1A
+#define BV_PXP_OUT_CTRL_FORMAT__YVU2P420  0x1B
+
+#define HW_PXP_OUT_BUF	(0x00000030)
+
+#define BP_PXP_OUT_BUF_ADDR      0
+#define BM_PXP_OUT_BUF_ADDR 0xFFFFFFFF
+#define BF_PXP_OUT_BUF_ADDR(v)   (v)
+
+#define HW_PXP_OUT_BUF2	(0x00000040)
+
+#define BP_PXP_OUT_BUF2_ADDR      0
+#define BM_PXP_OUT_BUF2_ADDR 0xFFFFFFFF
+#define BF_PXP_OUT_BUF2_ADDR(v)   (v)
+
+#define HW_PXP_OUT_PITCH	(0x00000050)
+
+#define BP_PXP_OUT_PITCH_RSVD      16
+#define BM_PXP_OUT_PITCH_RSVD 0xFFFF0000
+#define BF_PXP_OUT_PITCH_RSVD(v) \
+	(((v) << 16) & BM_PXP_OUT_PITCH_RSVD)
+#define BP_PXP_OUT_PITCH_PITCH      0
+#define BM_PXP_OUT_PITCH_PITCH 0x0000FFFF
+#define BF_PXP_OUT_PITCH_PITCH(v)  \
+	(((v) << 0) & BM_PXP_OUT_PITCH_PITCH)
+
+#define HW_PXP_OUT_LRC	(0x00000060)
+
+#define BP_PXP_OUT_LRC_RSVD1      30
+#define BM_PXP_OUT_LRC_RSVD1 0xC0000000
+#define BF_PXP_OUT_LRC_RSVD1(v) \
+	(((v) << 30) & BM_PXP_OUT_LRC_RSVD1)
+#define BP_PXP_OUT_LRC_X      16
+#define BM_PXP_OUT_LRC_X 0x3FFF0000
+#define BF_PXP_OUT_LRC_X(v)  \
+	(((v) << 16) & BM_PXP_OUT_LRC_X)
+#define BP_PXP_OUT_LRC_RSVD0      14
+#define BM_PXP_OUT_LRC_RSVD0 0x0000C000
+#define BF_PXP_OUT_LRC_RSVD0(v)  \
+	(((v) << 14) & BM_PXP_OUT_LRC_RSVD0)
+#define BP_PXP_OUT_LRC_Y      0
+#define BM_PXP_OUT_LRC_Y 0x00003FFF
+#define BF_PXP_OUT_LRC_Y(v)  \
+	(((v) << 0) & BM_PXP_OUT_LRC_Y)
+
+#define HW_PXP_OUT_PS_ULC	(0x00000070)
+
+#define BP_PXP_OUT_PS_ULC_RSVD1      30
+#define BM_PXP_OUT_PS_ULC_RSVD1 0xC0000000
+#define BF_PXP_OUT_PS_ULC_RSVD1(v) \
+	(((v) << 30) & BM_PXP_OUT_PS_ULC_RSVD1)
+#define BP_PXP_OUT_PS_ULC_X      16
+#define BM_PXP_OUT_PS_ULC_X 0x3FFF0000
+#define BF_PXP_OUT_PS_ULC_X(v)  \
+	(((v) << 16) & BM_PXP_OUT_PS_ULC_X)
+#define BP_PXP_OUT_PS_ULC_RSVD0      14
+#define BM_PXP_OUT_PS_ULC_RSVD0 0x0000C000
+#define BF_PXP_OUT_PS_ULC_RSVD0(v)  \
+	(((v) << 14) & BM_PXP_OUT_PS_ULC_RSVD0)
+#define BP_PXP_OUT_PS_ULC_Y      0
+#define BM_PXP_OUT_PS_ULC_Y 0x00003FFF
+#define BF_PXP_OUT_PS_ULC_Y(v)  \
+	(((v) << 0) & BM_PXP_OUT_PS_ULC_Y)
+
+#define HW_PXP_OUT_PS_LRC	(0x00000080)
+
+#define BP_PXP_OUT_PS_LRC_RSVD1      30
+#define BM_PXP_OUT_PS_LRC_RSVD1 0xC0000000
+#define BF_PXP_OUT_PS_LRC_RSVD1(v) \
+	(((v) << 30) & BM_PXP_OUT_PS_LRC_RSVD1)
+#define BP_PXP_OUT_PS_LRC_X      16
+#define BM_PXP_OUT_PS_LRC_X 0x3FFF0000
+#define BF_PXP_OUT_PS_LRC_X(v)  \
+	(((v) << 16) & BM_PXP_OUT_PS_LRC_X)
+#define BP_PXP_OUT_PS_LRC_RSVD0      14
+#define BM_PXP_OUT_PS_LRC_RSVD0 0x0000C000
+#define BF_PXP_OUT_PS_LRC_RSVD0(v)  \
+	(((v) << 14) & BM_PXP_OUT_PS_LRC_RSVD0)
+#define BP_PXP_OUT_PS_LRC_Y      0
+#define BM_PXP_OUT_PS_LRC_Y 0x00003FFF
+#define BF_PXP_OUT_PS_LRC_Y(v)  \
+	(((v) << 0) & BM_PXP_OUT_PS_LRC_Y)
+
+#define HW_PXP_OUT_AS_ULC	(0x00000090)
+
+#define BP_PXP_OUT_AS_ULC_RSVD1      30
+#define BM_PXP_OUT_AS_ULC_RSVD1 0xC0000000
+#define BF_PXP_OUT_AS_ULC_RSVD1(v) \
+	(((v) << 30) & BM_PXP_OUT_AS_ULC_RSVD1)
+#define BP_PXP_OUT_AS_ULC_X      16
+#define BM_PXP_OUT_AS_ULC_X 0x3FFF0000
+#define BF_PXP_OUT_AS_ULC_X(v)  \
+	(((v) << 16) & BM_PXP_OUT_AS_ULC_X)
+#define BP_PXP_OUT_AS_ULC_RSVD0      14
+#define BM_PXP_OUT_AS_ULC_RSVD0 0x0000C000
+#define BF_PXP_OUT_AS_ULC_RSVD0(v)  \
+	(((v) << 14) & BM_PXP_OUT_AS_ULC_RSVD0)
+#define BP_PXP_OUT_AS_ULC_Y      0
+#define BM_PXP_OUT_AS_ULC_Y 0x00003FFF
+#define BF_PXP_OUT_AS_ULC_Y(v)  \
+	(((v) << 0) & BM_PXP_OUT_AS_ULC_Y)
+
+#define HW_PXP_OUT_AS_LRC	(0x000000a0)
+
+#define BP_PXP_OUT_AS_LRC_RSVD1      30
+#define BM_PXP_OUT_AS_LRC_RSVD1 0xC0000000
+#define BF_PXP_OUT_AS_LRC_RSVD1(v) \
+	(((v) << 30) & BM_PXP_OUT_AS_LRC_RSVD1)
+#define BP_PXP_OUT_AS_LRC_X      16
+#define BM_PXP_OUT_AS_LRC_X 0x3FFF0000
+#define BF_PXP_OUT_AS_LRC_X(v)  \
+	(((v) << 16) & BM_PXP_OUT_AS_LRC_X)
+#define BP_PXP_OUT_AS_LRC_RSVD0      14
+#define BM_PXP_OUT_AS_LRC_RSVD0 0x0000C000
+#define BF_PXP_OUT_AS_LRC_RSVD0(v)  \
+	(((v) << 14) & BM_PXP_OUT_AS_LRC_RSVD0)
+#define BP_PXP_OUT_AS_LRC_Y      0
+#define BM_PXP_OUT_AS_LRC_Y 0x00003FFF
+#define BF_PXP_OUT_AS_LRC_Y(v)  \
+	(((v) << 0) & BM_PXP_OUT_AS_LRC_Y)
+
+#define HW_PXP_PS_CTRL	(0x000000b0)
+#define HW_PXP_PS_CTRL_SET	(0x000000b4)
+#define HW_PXP_PS_CTRL_CLR	(0x000000b8)
+#define HW_PXP_PS_CTRL_TOG	(0x000000bc)
+
+#define BP_PXP_PS_CTRL_RSVD1      12
+#define BM_PXP_PS_CTRL_RSVD1 0xFFFFF000
+#define BF_PXP_PS_CTRL_RSVD1(v) \
+	(((v) << 12) & BM_PXP_PS_CTRL_RSVD1)
+#define BP_PXP_PS_CTRL_DECX      10
+#define BM_PXP_PS_CTRL_DECX 0x00000C00
+#define BF_PXP_PS_CTRL_DECX(v)  \
+	(((v) << 10) & BM_PXP_PS_CTRL_DECX)
+#define BV_PXP_PS_CTRL_DECX__DISABLE 0x0
+#define BV_PXP_PS_CTRL_DECX__DECX2   0x1
+#define BV_PXP_PS_CTRL_DECX__DECX4   0x2
+#define BV_PXP_PS_CTRL_DECX__DECX8   0x3
+#define BP_PXP_PS_CTRL_DECY      8
+#define BM_PXP_PS_CTRL_DECY 0x00000300
+#define BF_PXP_PS_CTRL_DECY(v)  \
+	(((v) << 8) & BM_PXP_PS_CTRL_DECY)
+#define BV_PXP_PS_CTRL_DECY__DISABLE 0x0
+#define BV_PXP_PS_CTRL_DECY__DECY2   0x1
+#define BV_PXP_PS_CTRL_DECY__DECY4   0x2
+#define BV_PXP_PS_CTRL_DECY__DECY8   0x3
+#define BM_PXP_PS_CTRL_RSVD0 0x00000080
+#define BF_PXP_PS_CTRL_RSVD0(v)  \
+	(((v) << 7) & BM_PXP_PS_CTRL_RSVD0)
+#define BM_PXP_PS_CTRL_WB_SWAP 0x00000040
+#define BF_PXP_PS_CTRL_WB_SWAP(v)  \
+	(((v) << 6) & BM_PXP_PS_CTRL_WB_SWAP)
+#define BP_PXP_PS_CTRL_FORMAT      0
+#define BM_PXP_PS_CTRL_FORMAT 0x0000003F
+#define BF_PXP_PS_CTRL_FORMAT(v)  \
+	(((v) << 0) & BM_PXP_PS_CTRL_FORMAT)
+#define BV_PXP_PS_CTRL_FORMAT__RGB888    0x4
+#define BV_PXP_PS_CTRL_FORMAT__RGB555    0xC
+#define BV_PXP_PS_CTRL_FORMAT__RGB444    0xD
+#define BV_PXP_PS_CTRL_FORMAT__RGB565    0xE
+#define BV_PXP_PS_CTRL_FORMAT__YUV1P444  0x10
+#define BV_PXP_PS_CTRL_FORMAT__UYVY1P422 0x12
+#define BV_PXP_PS_CTRL_FORMAT__VYUY1P422 0x13
+#define BV_PXP_PS_CTRL_FORMAT__Y8	0x14
+#define BV_PXP_PS_CTRL_FORMAT__Y4	0x15
+#define BV_PXP_PS_CTRL_FORMAT__YUV2P422  0x18
+#define BV_PXP_PS_CTRL_FORMAT__YUV2P420  0x19
+#define BV_PXP_PS_CTRL_FORMAT__YVU2P422  0x1A
+#define BV_PXP_PS_CTRL_FORMAT__YVU2P420  0x1B
+#define BV_PXP_PS_CTRL_FORMAT__YUV422    0x1E
+#define BV_PXP_PS_CTRL_FORMAT__YUV420    0x1F
+
+#define HW_PXP_PS_BUF	(0x000000c0)
+
+#define BP_PXP_PS_BUF_ADDR      0
+#define BM_PXP_PS_BUF_ADDR 0xFFFFFFFF
+#define BF_PXP_PS_BUF_ADDR(v)   (v)
+
+#define HW_PXP_PS_UBUF	(0x000000d0)
+
+#define BP_PXP_PS_UBUF_ADDR      0
+#define BM_PXP_PS_UBUF_ADDR 0xFFFFFFFF
+#define BF_PXP_PS_UBUF_ADDR(v)   (v)
+
+#define HW_PXP_PS_VBUF	(0x000000e0)
+
+#define BP_PXP_PS_VBUF_ADDR      0
+#define BM_PXP_PS_VBUF_ADDR 0xFFFFFFFF
+#define BF_PXP_PS_VBUF_ADDR(v)   (v)
+
+#define HW_PXP_PS_PITCH	(0x000000f0)
+
+#define BP_PXP_PS_PITCH_RSVD      16
+#define BM_PXP_PS_PITCH_RSVD 0xFFFF0000
+#define BF_PXP_PS_PITCH_RSVD(v) \
+	(((v) << 16) & BM_PXP_PS_PITCH_RSVD)
+#define BP_PXP_PS_PITCH_PITCH      0
+#define BM_PXP_PS_PITCH_PITCH 0x0000FFFF
+#define BF_PXP_PS_PITCH_PITCH(v)  \
+	(((v) << 0) & BM_PXP_PS_PITCH_PITCH)
+
+#define HW_PXP_PS_BACKGROUND_0	(0x00000100)
+
+#define BP_PXP_PS_BACKGROUND_0_RSVD      24
+#define BM_PXP_PS_BACKGROUND_0_RSVD 0xFF000000
+#define BF_PXP_PS_BACKGROUND_0_RSVD(v) \
+	(((v) << 24) & BM_PXP_PS_BACKGROUND_0_RSVD)
+#define BP_PXP_PS_BACKGROUND_0_COLOR      0
+#define BM_PXP_PS_BACKGROUND_0_COLOR 0x00FFFFFF
+#define BF_PXP_PS_BACKGROUND_0_COLOR(v)  \
+	(((v) << 0) & BM_PXP_PS_BACKGROUND_0_COLOR)
+
+#define HW_PXP_PS_SCALE	(0x00000110)
+
+#define BM_PXP_PS_SCALE_RSVD2 0x80000000
+#define BF_PXP_PS_SCALE_RSVD2(v) \
+	(((v) << 31) & BM_PXP_PS_SCALE_RSVD2)
+#define BP_PXP_PS_SCALE_YSCALE      16
+#define BM_PXP_PS_SCALE_YSCALE 0x7FFF0000
+#define BF_PXP_PS_SCALE_YSCALE(v)  \
+	(((v) << 16) & BM_PXP_PS_SCALE_YSCALE)
+#define BM_PXP_PS_SCALE_RSVD1 0x00008000
+#define BF_PXP_PS_SCALE_RSVD1(v)  \
+	(((v) << 15) & BM_PXP_PS_SCALE_RSVD1)
+#define BP_PXP_PS_SCALE_XSCALE      0
+#define BM_PXP_PS_SCALE_XSCALE 0x00007FFF
+#define BF_PXP_PS_SCALE_XSCALE(v)  \
+	(((v) << 0) & BM_PXP_PS_SCALE_XSCALE)
+
+#define HW_PXP_PS_OFFSET	(0x00000120)
+
+#define BP_PXP_PS_OFFSET_RSVD2      28
+#define BM_PXP_PS_OFFSET_RSVD2 0xF0000000
+#define BF_PXP_PS_OFFSET_RSVD2(v) \
+	(((v) << 28) & BM_PXP_PS_OFFSET_RSVD2)
+#define BP_PXP_PS_OFFSET_YOFFSET      16
+#define BM_PXP_PS_OFFSET_YOFFSET 0x0FFF0000
+#define BF_PXP_PS_OFFSET_YOFFSET(v)  \
+	(((v) << 16) & BM_PXP_PS_OFFSET_YOFFSET)
+#define BP_PXP_PS_OFFSET_RSVD1      12
+#define BM_PXP_PS_OFFSET_RSVD1 0x0000F000
+#define BF_PXP_PS_OFFSET_RSVD1(v)  \
+	(((v) << 12) & BM_PXP_PS_OFFSET_RSVD1)
+#define BP_PXP_PS_OFFSET_XOFFSET      0
+#define BM_PXP_PS_OFFSET_XOFFSET 0x00000FFF
+#define BF_PXP_PS_OFFSET_XOFFSET(v)  \
+	(((v) << 0) & BM_PXP_PS_OFFSET_XOFFSET)
+
+#define HW_PXP_PS_CLRKEYLOW_0	(0x00000130)
+
+#define BP_PXP_PS_CLRKEYLOW_0_RSVD1      24
+#define BM_PXP_PS_CLRKEYLOW_0_RSVD1 0xFF000000
+#define BF_PXP_PS_CLRKEYLOW_0_RSVD1(v) \
+	(((v) << 24) & BM_PXP_PS_CLRKEYLOW_0_RSVD1)
+#define BP_PXP_PS_CLRKEYLOW_0_PIXEL      0
+#define BM_PXP_PS_CLRKEYLOW_0_PIXEL 0x00FFFFFF
+#define BF_PXP_PS_CLRKEYLOW_0_PIXEL(v)  \
+	(((v) << 0) & BM_PXP_PS_CLRKEYLOW_0_PIXEL)
+
+#define HW_PXP_PS_CLRKEYHIGH_0	(0x00000140)
+
+#define BP_PXP_PS_CLRKEYHIGH_0_RSVD1      24
+#define BM_PXP_PS_CLRKEYHIGH_0_RSVD1 0xFF000000
+#define BF_PXP_PS_CLRKEYHIGH_0_RSVD1(v) \
+	(((v) << 24) & BM_PXP_PS_CLRKEYHIGH_0_RSVD1)
+#define BP_PXP_PS_CLRKEYHIGH_0_PIXEL      0
+#define BM_PXP_PS_CLRKEYHIGH_0_PIXEL 0x00FFFFFF
+#define BF_PXP_PS_CLRKEYHIGH_0_PIXEL(v)  \
+	(((v) << 0) & BM_PXP_PS_CLRKEYHIGH_0_PIXEL)
+
+#define HW_PXP_AS_CTRL	(0x00000150)
+
+#define BP_PXP_AS_CTRL_RSVD1      22
+#define BM_PXP_AS_CTRL_RSVD1 0xFFC00000
+#define BF_PXP_AS_CTRL_RSVD1(v) \
+	(((v) << 22) & BM_PXP_AS_CTRL_RSVD1)
+#define BM_PXP_AS_CTRL_ALPHA1_INVERT 0x00200000
+#define BF_PXP_AS_CTRL_ALPHA1_INVERT(v)  \
+	(((v) << 21) & BM_PXP_AS_CTRL_ALPHA1_INVERT)
+#define BM_PXP_AS_CTRL_ALPHA0_INVERT 0x00100000
+#define BF_PXP_AS_CTRL_ALPHA0_INVERT(v)  \
+	(((v) << 20) & BM_PXP_AS_CTRL_ALPHA0_INVERT)
+#define BP_PXP_AS_CTRL_ROP      16
+#define BM_PXP_AS_CTRL_ROP 0x000F0000
+#define BF_PXP_AS_CTRL_ROP(v)  \
+	(((v) << 16) & BM_PXP_AS_CTRL_ROP)
+#define BV_PXP_AS_CTRL_ROP__MASKAS     0x0
+#define BV_PXP_AS_CTRL_ROP__MASKNOTAS  0x1
+#define BV_PXP_AS_CTRL_ROP__MASKASNOT  0x2
+#define BV_PXP_AS_CTRL_ROP__MERGEAS    0x3
+#define BV_PXP_AS_CTRL_ROP__MERGENOTAS 0x4
+#define BV_PXP_AS_CTRL_ROP__MERGEASNOT 0x5
+#define BV_PXP_AS_CTRL_ROP__NOTCOPYAS  0x6
+#define BV_PXP_AS_CTRL_ROP__NOT	0x7
+#define BV_PXP_AS_CTRL_ROP__NOTMASKAS  0x8
+#define BV_PXP_AS_CTRL_ROP__NOTMERGEAS 0x9
+#define BV_PXP_AS_CTRL_ROP__XORAS      0xA
+#define BV_PXP_AS_CTRL_ROP__NOTXORAS   0xB
+#define BP_PXP_AS_CTRL_ALPHA      8
+#define BM_PXP_AS_CTRL_ALPHA 0x0000FF00
+#define BF_PXP_AS_CTRL_ALPHA(v)  \
+	(((v) << 8) & BM_PXP_AS_CTRL_ALPHA)
+#define BP_PXP_AS_CTRL_FORMAT      4
+#define BM_PXP_AS_CTRL_FORMAT 0x000000F0
+#define BF_PXP_AS_CTRL_FORMAT(v)  \
+	(((v) << 4) & BM_PXP_AS_CTRL_FORMAT)
+#define BV_PXP_AS_CTRL_FORMAT__ARGB8888 0x0
+#define BV_PXP_AS_CTRL_FORMAT__RGBA8888 0x1
+#define BV_PXP_AS_CTRL_FORMAT__RGB888   0x4
+#define BV_PXP_AS_CTRL_FORMAT__ARGB1555 0x8
+#define BV_PXP_AS_CTRL_FORMAT__ARGB4444 0x9
+#define BV_PXP_AS_CTRL_FORMAT__RGB555   0xC
+#define BV_PXP_AS_CTRL_FORMAT__RGB444   0xD
+#define BV_PXP_AS_CTRL_FORMAT__RGB565   0xE
+#define BM_PXP_AS_CTRL_ENABLE_COLORKEY 0x00000008
+#define BF_PXP_AS_CTRL_ENABLE_COLORKEY(v)  \
+	(((v) << 3) & BM_PXP_AS_CTRL_ENABLE_COLORKEY)
+#define BP_PXP_AS_CTRL_ALPHA_CTRL      1
+#define BM_PXP_AS_CTRL_ALPHA_CTRL 0x00000006
+#define BF_PXP_AS_CTRL_ALPHA_CTRL(v)  \
+	(((v) << 1) & BM_PXP_AS_CTRL_ALPHA_CTRL)
+#define BV_PXP_AS_CTRL_ALPHA_CTRL__Embedded 0x0
+#define BV_PXP_AS_CTRL_ALPHA_CTRL__Override 0x1
+#define BV_PXP_AS_CTRL_ALPHA_CTRL__Multiply 0x2
+#define BV_PXP_AS_CTRL_ALPHA_CTRL__ROPs     0x3
+#define BM_PXP_AS_CTRL_RSVD0 0x00000001
+#define BF_PXP_AS_CTRL_RSVD0(v)  \
+	(((v) << 0) & BM_PXP_AS_CTRL_RSVD0)
+
+#define HW_PXP_AS_BUF	(0x00000160)
+
+#define BP_PXP_AS_BUF_ADDR      0
+#define BM_PXP_AS_BUF_ADDR 0xFFFFFFFF
+#define BF_PXP_AS_BUF_ADDR(v)   (v)
+
+#define HW_PXP_AS_PITCH	(0x00000170)
+
+#define BP_PXP_AS_PITCH_RSVD      16
+#define BM_PXP_AS_PITCH_RSVD 0xFFFF0000
+#define BF_PXP_AS_PITCH_RSVD(v) \
+	(((v) << 16) & BM_PXP_AS_PITCH_RSVD)
+#define BP_PXP_AS_PITCH_PITCH      0
+#define BM_PXP_AS_PITCH_PITCH 0x0000FFFF
+#define BF_PXP_AS_PITCH_PITCH(v)  \
+	(((v) << 0) & BM_PXP_AS_PITCH_PITCH)
+
+#define HW_PXP_AS_CLRKEYLOW_0	(0x00000180)
+
+#define BP_PXP_AS_CLRKEYLOW_0_RSVD1      24
+#define BM_PXP_AS_CLRKEYLOW_0_RSVD1 0xFF000000
+#define BF_PXP_AS_CLRKEYLOW_0_RSVD1(v) \
+	(((v) << 24) & BM_PXP_AS_CLRKEYLOW_0_RSVD1)
+#define BP_PXP_AS_CLRKEYLOW_0_PIXEL      0
+#define BM_PXP_AS_CLRKEYLOW_0_PIXEL 0x00FFFFFF
+#define BF_PXP_AS_CLRKEYLOW_0_PIXEL(v)  \
+	(((v) << 0) & BM_PXP_AS_CLRKEYLOW_0_PIXEL)
+
+#define HW_PXP_AS_CLRKEYHIGH_0	(0x00000190)
+
+#define BP_PXP_AS_CLRKEYHIGH_0_RSVD1      24
+#define BM_PXP_AS_CLRKEYHIGH_0_RSVD1 0xFF000000
+#define BF_PXP_AS_CLRKEYHIGH_0_RSVD1(v) \
+	(((v) << 24) & BM_PXP_AS_CLRKEYHIGH_0_RSVD1)
+#define BP_PXP_AS_CLRKEYHIGH_0_PIXEL      0
+#define BM_PXP_AS_CLRKEYHIGH_0_PIXEL 0x00FFFFFF
+#define BF_PXP_AS_CLRKEYHIGH_0_PIXEL(v)  \
+	(((v) << 0) & BM_PXP_AS_CLRKEYHIGH_0_PIXEL)
+
+#define HW_PXP_CSC1_COEF0	(0x000001a0)
+
+#define BM_PXP_CSC1_COEF0_YCBCR_MODE 0x80000000
+#define BF_PXP_CSC1_COEF0_YCBCR_MODE(v) \
+	(((v) << 31) & BM_PXP_CSC1_COEF0_YCBCR_MODE)
+#define BM_PXP_CSC1_COEF0_BYPASS 0x40000000
+#define BF_PXP_CSC1_COEF0_BYPASS(v)  \
+	(((v) << 30) & BM_PXP_CSC1_COEF0_BYPASS)
+#define BM_PXP_CSC1_COEF0_RSVD1 0x20000000
+#define BF_PXP_CSC1_COEF0_RSVD1(v)  \
+	(((v) << 29) & BM_PXP_CSC1_COEF0_RSVD1)
+#define BP_PXP_CSC1_COEF0_C0      18
+#define BM_PXP_CSC1_COEF0_C0 0x1FFC0000
+#define BF_PXP_CSC1_COEF0_C0(v)  \
+	(((v) << 18) & BM_PXP_CSC1_COEF0_C0)
+#define BP_PXP_CSC1_COEF0_UV_OFFSET      9
+#define BM_PXP_CSC1_COEF0_UV_OFFSET 0x0003FE00
+#define BF_PXP_CSC1_COEF0_UV_OFFSET(v)  \
+	(((v) << 9) & BM_PXP_CSC1_COEF0_UV_OFFSET)
+#define BP_PXP_CSC1_COEF0_Y_OFFSET      0
+#define BM_PXP_CSC1_COEF0_Y_OFFSET 0x000001FF
+#define BF_PXP_CSC1_COEF0_Y_OFFSET(v)  \
+	(((v) << 0) & BM_PXP_CSC1_COEF0_Y_OFFSET)
+
+#define HW_PXP_CSC1_COEF1	(0x000001b0)
+
+#define BP_PXP_CSC1_COEF1_RSVD1      27
+#define BM_PXP_CSC1_COEF1_RSVD1 0xF8000000
+#define BF_PXP_CSC1_COEF1_RSVD1(v) \
+	(((v) << 27) & BM_PXP_CSC1_COEF1_RSVD1)
+#define BP_PXP_CSC1_COEF1_C1      16
+#define BM_PXP_CSC1_COEF1_C1 0x07FF0000
+#define BF_PXP_CSC1_COEF1_C1(v)  \
+	(((v) << 16) & BM_PXP_CSC1_COEF1_C1)
+#define BP_PXP_CSC1_COEF1_RSVD0      11
+#define BM_PXP_CSC1_COEF1_RSVD0 0x0000F800
+#define BF_PXP_CSC1_COEF1_RSVD0(v)  \
+	(((v) << 11) & BM_PXP_CSC1_COEF1_RSVD0)
+#define BP_PXP_CSC1_COEF1_C4      0
+#define BM_PXP_CSC1_COEF1_C4 0x000007FF
+#define BF_PXP_CSC1_COEF1_C4(v)  \
+	(((v) << 0) & BM_PXP_CSC1_COEF1_C4)
+
+#define HW_PXP_CSC1_COEF2	(0x000001c0)
+
+#define BP_PXP_CSC1_COEF2_RSVD1      27
+#define BM_PXP_CSC1_COEF2_RSVD1 0xF8000000
+#define BF_PXP_CSC1_COEF2_RSVD1(v) \
+	(((v) << 27) & BM_PXP_CSC1_COEF2_RSVD1)
+#define BP_PXP_CSC1_COEF2_C2      16
+#define BM_PXP_CSC1_COEF2_C2 0x07FF0000
+#define BF_PXP_CSC1_COEF2_C2(v)  \
+	(((v) << 16) & BM_PXP_CSC1_COEF2_C2)
+#define BP_PXP_CSC1_COEF2_RSVD0      11
+#define BM_PXP_CSC1_COEF2_RSVD0 0x0000F800
+#define BF_PXP_CSC1_COEF2_RSVD0(v)  \
+	(((v) << 11) & BM_PXP_CSC1_COEF2_RSVD0)
+#define BP_PXP_CSC1_COEF2_C3      0
+#define BM_PXP_CSC1_COEF2_C3 0x000007FF
+#define BF_PXP_CSC1_COEF2_C3(v)  \
+	(((v) << 0) & BM_PXP_CSC1_COEF2_C3)
+
+#define HW_PXP_CSC2_CTRL	(0x000001d0)
+
+#define BP_PXP_CSC2_CTRL_RSVD      3
+#define BM_PXP_CSC2_CTRL_RSVD 0xFFFFFFF8
+#define BF_PXP_CSC2_CTRL_RSVD(v) \
+	(((v) << 3) & BM_PXP_CSC2_CTRL_RSVD)
+#define BP_PXP_CSC2_CTRL_CSC_MODE      1
+#define BM_PXP_CSC2_CTRL_CSC_MODE 0x00000006
+#define BF_PXP_CSC2_CTRL_CSC_MODE(v)  \
+	(((v) << 1) & BM_PXP_CSC2_CTRL_CSC_MODE)
+#define BV_PXP_CSC2_CTRL_CSC_MODE__YUV2RGB   0x0
+#define BV_PXP_CSC2_CTRL_CSC_MODE__YCbCr2RGB 0x1
+#define BV_PXP_CSC2_CTRL_CSC_MODE__RGB2YUV   0x2
+#define BV_PXP_CSC2_CTRL_CSC_MODE__RGB2YCbCr 0x3
+#define BM_PXP_CSC2_CTRL_BYPASS 0x00000001
+#define BF_PXP_CSC2_CTRL_BYPASS(v)  \
+	(((v) << 0) & BM_PXP_CSC2_CTRL_BYPASS)
+
+#define HW_PXP_CSC2_COEF0	(0x000001e0)
+
+#define BP_PXP_CSC2_COEF0_RSVD1      27
+#define BM_PXP_CSC2_COEF0_RSVD1 0xF8000000
+#define BF_PXP_CSC2_COEF0_RSVD1(v) \
+	(((v) << 27) & BM_PXP_CSC2_COEF0_RSVD1)
+#define BP_PXP_CSC2_COEF0_A2      16
+#define BM_PXP_CSC2_COEF0_A2 0x07FF0000
+#define BF_PXP_CSC2_COEF0_A2(v)  \
+	(((v) << 16) & BM_PXP_CSC2_COEF0_A2)
+#define BP_PXP_CSC2_COEF0_RSVD0      11
+#define BM_PXP_CSC2_COEF0_RSVD0 0x0000F800
+#define BF_PXP_CSC2_COEF0_RSVD0(v)  \
+	(((v) << 11) & BM_PXP_CSC2_COEF0_RSVD0)
+#define BP_PXP_CSC2_COEF0_A1      0
+#define BM_PXP_CSC2_COEF0_A1 0x000007FF
+#define BF_PXP_CSC2_COEF0_A1(v)  \
+	(((v) << 0) & BM_PXP_CSC2_COEF0_A1)
+
+#define HW_PXP_CSC2_COEF1	(0x000001f0)
+
+#define BP_PXP_CSC2_COEF1_RSVD1      27
+#define BM_PXP_CSC2_COEF1_RSVD1 0xF8000000
+#define BF_PXP_CSC2_COEF1_RSVD1(v) \
+	(((v) << 27) & BM_PXP_CSC2_COEF1_RSVD1)
+#define BP_PXP_CSC2_COEF1_B1      16
+#define BM_PXP_CSC2_COEF1_B1 0x07FF0000
+#define BF_PXP_CSC2_COEF1_B1(v)  \
+	(((v) << 16) & BM_PXP_CSC2_COEF1_B1)
+#define BP_PXP_CSC2_COEF1_RSVD0      11
+#define BM_PXP_CSC2_COEF1_RSVD0 0x0000F800
+#define BF_PXP_CSC2_COEF1_RSVD0(v)  \
+	(((v) << 11) & BM_PXP_CSC2_COEF1_RSVD0)
+#define BP_PXP_CSC2_COEF1_A3      0
+#define BM_PXP_CSC2_COEF1_A3 0x000007FF
+#define BF_PXP_CSC2_COEF1_A3(v)  \
+	(((v) << 0) & BM_PXP_CSC2_COEF1_A3)
+
+#define HW_PXP_CSC2_COEF2	(0x00000200)
+
+#define BP_PXP_CSC2_COEF2_RSVD1      27
+#define BM_PXP_CSC2_COEF2_RSVD1 0xF8000000
+#define BF_PXP_CSC2_COEF2_RSVD1(v) \
+	(((v) << 27) & BM_PXP_CSC2_COEF2_RSVD1)
+#define BP_PXP_CSC2_COEF2_B3      16
+#define BM_PXP_CSC2_COEF2_B3 0x07FF0000
+#define BF_PXP_CSC2_COEF2_B3(v)  \
+	(((v) << 16) & BM_PXP_CSC2_COEF2_B3)
+#define BP_PXP_CSC2_COEF2_RSVD0      11
+#define BM_PXP_CSC2_COEF2_RSVD0 0x0000F800
+#define BF_PXP_CSC2_COEF2_RSVD0(v)  \
+	(((v) << 11) & BM_PXP_CSC2_COEF2_RSVD0)
+#define BP_PXP_CSC2_COEF2_B2      0
+#define BM_PXP_CSC2_COEF2_B2 0x000007FF
+#define BF_PXP_CSC2_COEF2_B2(v)  \
+	(((v) << 0) & BM_PXP_CSC2_COEF2_B2)
+
+#define HW_PXP_CSC2_COEF3	(0x00000210)
+
+#define BP_PXP_CSC2_COEF3_RSVD1      27
+#define BM_PXP_CSC2_COEF3_RSVD1 0xF8000000
+#define BF_PXP_CSC2_COEF3_RSVD1(v) \
+	(((v) << 27) & BM_PXP_CSC2_COEF3_RSVD1)
+#define BP_PXP_CSC2_COEF3_C2      16
+#define BM_PXP_CSC2_COEF3_C2 0x07FF0000
+#define BF_PXP_CSC2_COEF3_C2(v)  \
+	(((v) << 16) & BM_PXP_CSC2_COEF3_C2)
+#define BP_PXP_CSC2_COEF3_RSVD0      11
+#define BM_PXP_CSC2_COEF3_RSVD0 0x0000F800
+#define BF_PXP_CSC2_COEF3_RSVD0(v)  \
+	(((v) << 11) & BM_PXP_CSC2_COEF3_RSVD0)
+#define BP_PXP_CSC2_COEF3_C1      0
+#define BM_PXP_CSC2_COEF3_C1 0x000007FF
+#define BF_PXP_CSC2_COEF3_C1(v)  \
+	(((v) << 0) & BM_PXP_CSC2_COEF3_C1)
+
+#define HW_PXP_CSC2_COEF4	(0x00000220)
+
+#define BP_PXP_CSC2_COEF4_RSVD1      25
+#define BM_PXP_CSC2_COEF4_RSVD1 0xFE000000
+#define BF_PXP_CSC2_COEF4_RSVD1(v) \
+	(((v) << 25) & BM_PXP_CSC2_COEF4_RSVD1)
+#define BP_PXP_CSC2_COEF4_D1      16
+#define BM_PXP_CSC2_COEF4_D1 0x01FF0000
+#define BF_PXP_CSC2_COEF4_D1(v)  \
+	(((v) << 16) & BM_PXP_CSC2_COEF4_D1)
+#define BP_PXP_CSC2_COEF4_RSVD0      11
+#define BM_PXP_CSC2_COEF4_RSVD0 0x0000F800
+#define BF_PXP_CSC2_COEF4_RSVD0(v)  \
+	(((v) << 11) & BM_PXP_CSC2_COEF4_RSVD0)
+#define BP_PXP_CSC2_COEF4_C3      0
+#define BM_PXP_CSC2_COEF4_C3 0x000007FF
+#define BF_PXP_CSC2_COEF4_C3(v)  \
+	(((v) << 0) & BM_PXP_CSC2_COEF4_C3)
+
+#define HW_PXP_CSC2_COEF5	(0x00000230)
+
+#define BP_PXP_CSC2_COEF5_RSVD1      25
+#define BM_PXP_CSC2_COEF5_RSVD1 0xFE000000
+#define BF_PXP_CSC2_COEF5_RSVD1(v) \
+	(((v) << 25) & BM_PXP_CSC2_COEF5_RSVD1)
+#define BP_PXP_CSC2_COEF5_D3      16
+#define BM_PXP_CSC2_COEF5_D3 0x01FF0000
+#define BF_PXP_CSC2_COEF5_D3(v)  \
+	(((v) << 16) & BM_PXP_CSC2_COEF5_D3)
+#define BP_PXP_CSC2_COEF5_RSVD0      9
+#define BM_PXP_CSC2_COEF5_RSVD0 0x0000FE00
+#define BF_PXP_CSC2_COEF5_RSVD0(v)  \
+	(((v) << 9) & BM_PXP_CSC2_COEF5_RSVD0)
+#define BP_PXP_CSC2_COEF5_D2      0
+#define BM_PXP_CSC2_COEF5_D2 0x000001FF
+#define BF_PXP_CSC2_COEF5_D2(v)  \
+	(((v) << 0) & BM_PXP_CSC2_COEF5_D2)
+
+#define HW_PXP_LUT_CTRL	(0x00000240)
+
+#define BM_PXP_LUT_CTRL_BYPASS 0x80000000
+#define BF_PXP_LUT_CTRL_BYPASS(v) \
+	(((v) << 31) & BM_PXP_LUT_CTRL_BYPASS)
+#define BP_PXP_LUT_CTRL_RSVD3      26
+#define BM_PXP_LUT_CTRL_RSVD3 0x7C000000
+#define BF_PXP_LUT_CTRL_RSVD3(v)  \
+	(((v) << 26) & BM_PXP_LUT_CTRL_RSVD3)
+#define BP_PXP_LUT_CTRL_LOOKUP_MODE      24
+#define BM_PXP_LUT_CTRL_LOOKUP_MODE 0x03000000
+#define BF_PXP_LUT_CTRL_LOOKUP_MODE(v)  \
+	(((v) << 24) & BM_PXP_LUT_CTRL_LOOKUP_MODE)
+#define BV_PXP_LUT_CTRL_LOOKUP_MODE__CACHE_RGB565  0x0
+#define BV_PXP_LUT_CTRL_LOOKUP_MODE__DIRECT_Y8     0x1
+#define BV_PXP_LUT_CTRL_LOOKUP_MODE__DIRECT_RGB444 0x2
+#define BV_PXP_LUT_CTRL_LOOKUP_MODE__DIRECT_RGB454 0x3
+#define BP_PXP_LUT_CTRL_RSVD2      18
+#define BM_PXP_LUT_CTRL_RSVD2 0x00FC0000
+#define BF_PXP_LUT_CTRL_RSVD2(v)  \
+	(((v) << 18) & BM_PXP_LUT_CTRL_RSVD2)
+#define BP_PXP_LUT_CTRL_OUT_MODE      16
+#define BM_PXP_LUT_CTRL_OUT_MODE 0x00030000
+#define BF_PXP_LUT_CTRL_OUT_MODE(v)  \
+	(((v) << 16) & BM_PXP_LUT_CTRL_OUT_MODE)
+#define BV_PXP_LUT_CTRL_OUT_MODE__RESERVED    0x0
+#define BV_PXP_LUT_CTRL_OUT_MODE__Y8	  0x1
+#define BV_PXP_LUT_CTRL_OUT_MODE__RGBW4444CFA 0x2
+#define BV_PXP_LUT_CTRL_OUT_MODE__RGB888      0x3
+#define BP_PXP_LUT_CTRL_RSVD1      11
+#define BM_PXP_LUT_CTRL_RSVD1 0x0000F800
+#define BF_PXP_LUT_CTRL_RSVD1(v)  \
+	(((v) << 11) & BM_PXP_LUT_CTRL_RSVD1)
+#define BM_PXP_LUT_CTRL_SEL_8KB 0x00000400
+#define BF_PXP_LUT_CTRL_SEL_8KB(v)  \
+	(((v) << 10) & BM_PXP_LUT_CTRL_SEL_8KB)
+#define BM_PXP_LUT_CTRL_LRU_UPD 0x00000200
+#define BF_PXP_LUT_CTRL_LRU_UPD(v)  \
+	(((v) << 9) & BM_PXP_LUT_CTRL_LRU_UPD)
+#define BM_PXP_LUT_CTRL_INVALID 0x00000100
+#define BF_PXP_LUT_CTRL_INVALID(v)  \
+	(((v) << 8) & BM_PXP_LUT_CTRL_INVALID)
+#define BP_PXP_LUT_CTRL_RSVD0      1
+#define BM_PXP_LUT_CTRL_RSVD0 0x000000FE
+#define BF_PXP_LUT_CTRL_RSVD0(v)  \
+	(((v) << 1) & BM_PXP_LUT_CTRL_RSVD0)
+#define BM_PXP_LUT_CTRL_DMA_START 0x00000001
+#define BF_PXP_LUT_CTRL_DMA_START(v)  \
+	(((v) << 0) & BM_PXP_LUT_CTRL_DMA_START)
+
+#define HW_PXP_LUT_ADDR	(0x00000250)
+
+#define BM_PXP_LUT_ADDR_RSVD2 0x80000000
+#define BF_PXP_LUT_ADDR_RSVD2(v) \
+	(((v) << 31) & BM_PXP_LUT_ADDR_RSVD2)
+#define BP_PXP_LUT_ADDR_NUM_BYTES      16
+#define BM_PXP_LUT_ADDR_NUM_BYTES 0x7FFF0000
+#define BF_PXP_LUT_ADDR_NUM_BYTES(v)  \
+	(((v) << 16) & BM_PXP_LUT_ADDR_NUM_BYTES)
+#define BP_PXP_LUT_ADDR_RSVD1      14
+#define BM_PXP_LUT_ADDR_RSVD1 0x0000C000
+#define BF_PXP_LUT_ADDR_RSVD1(v)  \
+	(((v) << 14) & BM_PXP_LUT_ADDR_RSVD1)
+#define BP_PXP_LUT_ADDR_ADDR      0
+#define BM_PXP_LUT_ADDR_ADDR 0x00003FFF
+#define BF_PXP_LUT_ADDR_ADDR(v)  \
+	(((v) << 0) & BM_PXP_LUT_ADDR_ADDR)
+
+#define HW_PXP_LUT_DATA	(0x00000260)
+
+#define BP_PXP_LUT_DATA_DATA      0
+#define BM_PXP_LUT_DATA_DATA 0xFFFFFFFF
+#define BF_PXP_LUT_DATA_DATA(v)   (v)
+
+#define HW_PXP_LUT_EXTMEM	(0x00000270)
+
+#define BP_PXP_LUT_EXTMEM_ADDR      0
+#define BM_PXP_LUT_EXTMEM_ADDR 0xFFFFFFFF
+#define BF_PXP_LUT_EXTMEM_ADDR(v)   (v)
+
+#define HW_PXP_CFA	(0x00000280)
+
+#define BP_PXP_CFA_DATA      0
+#define BM_PXP_CFA_DATA 0xFFFFFFFF
+#define BF_PXP_CFA_DATA(v)   (v)
+
+#define HW_PXP_ALPHA_A_CTRL	(0x00000290)
+
+#define BP_PXP_ALPHA_A_CTRL_S1_GLOBAL_ALPHA      24
+#define BM_PXP_ALPHA_A_CTRL_S1_GLOBAL_ALPHA 0xFF000000
+#define BF_PXP_ALPHA_A_CTRL_S1_GLOBAL_ALPHA(v) \
+	(((v) << 24) & BM_PXP_ALPHA_A_CTRL_S1_GLOBAL_ALPHA)
+#define BP_PXP_ALPHA_A_CTRL_S0_GLOBAL_ALPHA      16
+#define BM_PXP_ALPHA_A_CTRL_S0_GLOBAL_ALPHA 0x00FF0000
+#define BF_PXP_ALPHA_A_CTRL_S0_GLOBAL_ALPHA(v)  \
+	(((v) << 16) & BM_PXP_ALPHA_A_CTRL_S0_GLOBAL_ALPHA)
+#define BP_PXP_ALPHA_A_CTRL_RSVD0      14
+#define BM_PXP_ALPHA_A_CTRL_RSVD0 0x0000C000
+#define BF_PXP_ALPHA_A_CTRL_RSVD0(v)  \
+	(((v) << 14) & BM_PXP_ALPHA_A_CTRL_RSVD0)
+#define BM_PXP_ALPHA_A_CTRL_S1_COLOR_MODE 0x00002000
+#define BF_PXP_ALPHA_A_CTRL_S1_COLOR_MODE(v)  \
+	(((v) << 13) & BM_PXP_ALPHA_A_CTRL_S1_COLOR_MODE)
+#define BV_PXP_ALPHA_A_CTRL_S1_COLOR_MODE__0 0x0
+#define BV_PXP_ALPHA_A_CTRL_S1_COLOR_MODE__1 0x1
+#define BM_PXP_ALPHA_A_CTRL_S1_ALPHA_MODE 0x00001000
+#define BF_PXP_ALPHA_A_CTRL_S1_ALPHA_MODE(v)  \
+	(((v) << 12) & BM_PXP_ALPHA_A_CTRL_S1_ALPHA_MODE)
+#define BV_PXP_ALPHA_A_CTRL_S1_ALPHA_MODE__0 0x0
+#define BV_PXP_ALPHA_A_CTRL_S1_ALPHA_MODE__1 0x1
+#define BP_PXP_ALPHA_A_CTRL_S1_GLOBAL_ALPHA_MODE      10
+#define BM_PXP_ALPHA_A_CTRL_S1_GLOBAL_ALPHA_MODE 0x00000C00
+#define BF_PXP_ALPHA_A_CTRL_S1_GLOBAL_ALPHA_MODE(v)  \
+	(((v) << 10) & BM_PXP_ALPHA_A_CTRL_S1_GLOBAL_ALPHA_MODE)
+#define BV_PXP_ALPHA_A_CTRL_S1_GLOBAL_ALPHA_MODE__0 0x0
+#define BV_PXP_ALPHA_A_CTRL_S1_GLOBAL_ALPHA_MODE__1 0x0
+#define BV_PXP_ALPHA_A_CTRL_S1_GLOBAL_ALPHA_MODE__2 0x0
+#define BV_PXP_ALPHA_A_CTRL_S1_GLOBAL_ALPHA_MODE__3 0x0
+#define BP_PXP_ALPHA_A_CTRL_S1_S0_FACTOR_MODE      8
+#define BM_PXP_ALPHA_A_CTRL_S1_S0_FACTOR_MODE 0x00000300
+#define BF_PXP_ALPHA_A_CTRL_S1_S0_FACTOR_MODE(v)  \
+	(((v) << 8) & BM_PXP_ALPHA_A_CTRL_S1_S0_FACTOR_MODE)
+#define BV_PXP_ALPHA_A_CTRL_S1_S0_FACTOR_MODE__0 0x0
+#define BV_PXP_ALPHA_A_CTRL_S1_S0_FACTOR_MODE__1 0x1
+#define BV_PXP_ALPHA_A_CTRL_S1_S0_FACTOR_MODE__2 0x2
+#define BV_PXP_ALPHA_A_CTRL_S1_S0_FACTOR_MODE__3 0x3
+#define BM_PXP_ALPHA_A_CTRL_RSVD1 0x00000080
+#define BF_PXP_ALPHA_A_CTRL_RSVD1(v)  \
+	(((v) << 7) & BM_PXP_ALPHA_A_CTRL_RSVD1)
+#define BM_PXP_ALPHA_A_CTRL_S0_COLOR_MODE 0x00000040
+#define BF_PXP_ALPHA_A_CTRL_S0_COLOR_MODE(v)  \
+	(((v) << 6) & BM_PXP_ALPHA_A_CTRL_S0_COLOR_MODE)
+#define BV_PXP_ALPHA_A_CTRL_S0_COLOR_MODE__0 0x0
+#define BV_PXP_ALPHA_A_CTRL_S0_COLOR_MODE__1 0x1
+#define BM_PXP_ALPHA_A_CTRL_S0_ALPHA_MODE 0x00000020
+#define BF_PXP_ALPHA_A_CTRL_S0_ALPHA_MODE(v)  \
+	(((v) << 5) & BM_PXP_ALPHA_A_CTRL_S0_ALPHA_MODE)
+#define BV_PXP_ALPHA_A_CTRL_S0_ALPHA_MODE__0 0x0
+#define BV_PXP_ALPHA_A_CTRL_S0_ALPHA_MODE__1 0x1
+#define BP_PXP_ALPHA_A_CTRL_S0_GLOBAL_ALPHA_MODE      3
+#define BM_PXP_ALPHA_A_CTRL_S0_GLOBAL_ALPHA_MODE 0x00000018
+#define BF_PXP_ALPHA_A_CTRL_S0_GLOBAL_ALPHA_MODE(v)  \
+	(((v) << 3) & BM_PXP_ALPHA_A_CTRL_S0_GLOBAL_ALPHA_MODE)
+#define BV_PXP_ALPHA_A_CTRL_S0_GLOBAL_ALPHA_MODE__0 0x0
+#define BV_PXP_ALPHA_A_CTRL_S0_GLOBAL_ALPHA_MODE__1 0x1
+#define BV_PXP_ALPHA_A_CTRL_S0_GLOBAL_ALPHA_MODE__2 0x2
+#define BV_PXP_ALPHA_A_CTRL_S0_GLOBAL_ALPHA_MODE__3 0x3
+#define BP_PXP_ALPHA_A_CTRL_S0_S1_FACTOR_MODE      1
+#define BM_PXP_ALPHA_A_CTRL_S0_S1_FACTOR_MODE 0x00000006
+#define BF_PXP_ALPHA_A_CTRL_S0_S1_FACTOR_MODE(v)  \
+	(((v) << 1) & BM_PXP_ALPHA_A_CTRL_S0_S1_FACTOR_MODE)
+#define BV_PXP_ALPHA_A_CTRL_S0_S1_FACTOR_MODE__0 0x0
+#define BV_PXP_ALPHA_A_CTRL_S0_S1_FACTOR_MODE__1 0x1
+#define BV_PXP_ALPHA_A_CTRL_S0_S1_FACTOR_MODE__2 0x2
+#define BV_PXP_ALPHA_A_CTRL_S0_S1_FACTOR_MODE__3 0x3
+#define BM_PXP_ALPHA_A_CTRL_POTER_DUFF_ENABLE 0x00000001
+#define BF_PXP_ALPHA_A_CTRL_POTER_DUFF_ENABLE(v)  \
+	(((v) << 0) & BM_PXP_ALPHA_A_CTRL_POTER_DUFF_ENABLE)
+#define BV_PXP_ALPHA_A_CTRL_POTER_DUFF_ENABLE__0 0x0
+#define BV_PXP_ALPHA_A_CTRL_POTER_DUFF_ENABLE__1 0x1
+
+#define HW_PXP_ALPHA_B_CTRL	(0x000002a0)
+
+#define BP_PXP_ALPHA_B_CTRL_S1_GLOBAL_ALPHA      24
+#define BM_PXP_ALPHA_B_CTRL_S1_GLOBAL_ALPHA 0xFF000000
+#define BF_PXP_ALPHA_B_CTRL_S1_GLOBAL_ALPHA(v) \
+	(((v) << 24) & BM_PXP_ALPHA_B_CTRL_S1_GLOBAL_ALPHA)
+#define BP_PXP_ALPHA_B_CTRL_S0_GLOBAL_ALPHA      16
+#define BM_PXP_ALPHA_B_CTRL_S0_GLOBAL_ALPHA 0x00FF0000
+#define BF_PXP_ALPHA_B_CTRL_S0_GLOBAL_ALPHA(v)  \
+	(((v) << 16) & BM_PXP_ALPHA_B_CTRL_S0_GLOBAL_ALPHA)
+#define BP_PXP_ALPHA_B_CTRL_RSVD0      14
+#define BM_PXP_ALPHA_B_CTRL_RSVD0 0x0000C000
+#define BF_PXP_ALPHA_B_CTRL_RSVD0(v)  \
+	(((v) << 14) & BM_PXP_ALPHA_B_CTRL_RSVD0)
+#define BM_PXP_ALPHA_B_CTRL_S1_COLOR_MODE 0x00002000
+#define BF_PXP_ALPHA_B_CTRL_S1_COLOR_MODE(v)  \
+	(((v) << 13) & BM_PXP_ALPHA_B_CTRL_S1_COLOR_MODE)
+#define BV_PXP_ALPHA_B_CTRL_S1_COLOR_MODE__0 0x0
+#define BV_PXP_ALPHA_B_CTRL_S1_COLOR_MODE__1 0x1
+#define BM_PXP_ALPHA_B_CTRL_S1_ALPHA_MODE 0x00001000
+#define BF_PXP_ALPHA_B_CTRL_S1_ALPHA_MODE(v)  \
+	(((v) << 12) & BM_PXP_ALPHA_B_CTRL_S1_ALPHA_MODE)
+#define BV_PXP_ALPHA_B_CTRL_S1_ALPHA_MODE__0 0x0
+#define BV_PXP_ALPHA_B_CTRL_S1_ALPHA_MODE__1 0x1
+#define BP_PXP_ALPHA_B_CTRL_S1_GLOBAL_ALPHA_MODE      10
+#define BM_PXP_ALPHA_B_CTRL_S1_GLOBAL_ALPHA_MODE 0x00000C00
+#define BF_PXP_ALPHA_B_CTRL_S1_GLOBAL_ALPHA_MODE(v)  \
+	(((v) << 10) & BM_PXP_ALPHA_B_CTRL_S1_GLOBAL_ALPHA_MODE)
+#define BV_PXP_ALPHA_B_CTRL_S1_GLOBAL_ALPHA_MODE__0 0x0
+#define BV_PXP_ALPHA_B_CTRL_S1_GLOBAL_ALPHA_MODE__1 0x1
+#define BV_PXP_ALPHA_B_CTRL_S1_GLOBAL_ALPHA_MODE__2 0x2
+#define BV_PXP_ALPHA_B_CTRL_S1_GLOBAL_ALPHA_MODE__3 0x3
+#define BP_PXP_ALPHA_B_CTRL_S1_S0_FACTOR_MODE      8
+#define BM_PXP_ALPHA_B_CTRL_S1_S0_FACTOR_MODE 0x00000300
+#define BF_PXP_ALPHA_B_CTRL_S1_S0_FACTOR_MODE(v)  \
+	(((v) << 8) & BM_PXP_ALPHA_B_CTRL_S1_S0_FACTOR_MODE)
+#define BV_PXP_ALPHA_B_CTRL_S1_S0_FACTOR_MODE__0 0x0
+#define BV_PXP_ALPHA_B_CTRL_S1_S0_FACTOR_MODE__1 0x1
+#define BV_PXP_ALPHA_B_CTRL_S1_S0_FACTOR_MODE__2 0x2
+#define BV_PXP_ALPHA_B_CTRL_S1_S0_FACTOR_MODE__3 0x3
+#define BM_PXP_ALPHA_B_CTRL_RSVD1 0x00000080
+#define BF_PXP_ALPHA_B_CTRL_RSVD1(v)  \
+	(((v) << 7) & BM_PXP_ALPHA_B_CTRL_RSVD1)
+#define BM_PXP_ALPHA_B_CTRL_S0_COLOR_MODE 0x00000040
+#define BF_PXP_ALPHA_B_CTRL_S0_COLOR_MODE(v)  \
+	(((v) << 6) & BM_PXP_ALPHA_B_CTRL_S0_COLOR_MODE)
+#define BV_PXP_ALPHA_B_CTRL_S0_COLOR_MODE__0 0x0
+#define BV_PXP_ALPHA_B_CTRL_S0_COLOR_MODE__1 0x1
+#define BM_PXP_ALPHA_B_CTRL_S0_ALPHA_MODE 0x00000020
+#define BF_PXP_ALPHA_B_CTRL_S0_ALPHA_MODE(v)  \
+	(((v) << 5) & BM_PXP_ALPHA_B_CTRL_S0_ALPHA_MODE)
+#define BV_PXP_ALPHA_B_CTRL_S0_ALPHA_MODE__0 0x0
+#define BV_PXP_ALPHA_B_CTRL_S0_ALPHA_MODE__1 0x1
+#define BP_PXP_ALPHA_B_CTRL_S0_GLOBAL_ALPHA_MODE      3
+#define BM_PXP_ALPHA_B_CTRL_S0_GLOBAL_ALPHA_MODE 0x00000018
+#define BF_PXP_ALPHA_B_CTRL_S0_GLOBAL_ALPHA_MODE(v)  \
+	(((v) << 3) & BM_PXP_ALPHA_B_CTRL_S0_GLOBAL_ALPHA_MODE)
+#define BV_PXP_ALPHA_B_CTRL_S0_GLOBAL_ALPHA_MODE__0 0x0
+#define BV_PXP_ALPHA_B_CTRL_S0_GLOBAL_ALPHA_MODE__1 0x1
+#define BV_PXP_ALPHA_B_CTRL_S0_GLOBAL_ALPHA_MODE__2 0x2
+#define BV_PXP_ALPHA_B_CTRL_S0_GLOBAL_ALPHA_MODE__3 0x3
+#define BP_PXP_ALPHA_B_CTRL_S0_S1_FACTOR_MODE      1
+#define BM_PXP_ALPHA_B_CTRL_S0_S1_FACTOR_MODE 0x00000006
+#define BF_PXP_ALPHA_B_CTRL_S0_S1_FACTOR_MODE(v)  \
+	(((v) << 1) & BM_PXP_ALPHA_B_CTRL_S0_S1_FACTOR_MODE)
+#define BV_PXP_ALPHA_B_CTRL_S0_S1_FACTOR_MODE__0 0x0
+#define BV_PXP_ALPHA_B_CTRL_S0_S1_FACTOR_MODE__1 0x1
+#define BV_PXP_ALPHA_B_CTRL_S0_S1_FACTOR_MODE__2 0x2
+#define BV_PXP_ALPHA_B_CTRL_S0_S1_FACTOR_MODE__3 0x3
+#define BM_PXP_ALPHA_B_CTRL_POTER_DUFF_ENABLE 0x00000001
+#define BF_PXP_ALPHA_B_CTRL_POTER_DUFF_ENABLE(v)  \
+	(((v) << 0) & BM_PXP_ALPHA_B_CTRL_POTER_DUFF_ENABLE)
+#define BV_PXP_ALPHA_B_CTRL_POTER_DUFF_ENABLE__0 0x0
+#define BV_PXP_ALPHA_B_CTRL_POTER_DUFF_ENABLE__1 0x1
+
+#define HW_PXP_ALPHA_B_CTRL_1	(0x000002b0)
+
+#define BP_PXP_ALPHA_B_CTRL_1_RSVD0      8
+#define BM_PXP_ALPHA_B_CTRL_1_RSVD0 0xFFFFFF00
+#define BF_PXP_ALPHA_B_CTRL_1_RSVD0(v) \
+	(((v) << 8) & BM_PXP_ALPHA_B_CTRL_1_RSVD0)
+#define BP_PXP_ALPHA_B_CTRL_1_ROP      4
+#define BM_PXP_ALPHA_B_CTRL_1_ROP 0x000000F0
+#define BF_PXP_ALPHA_B_CTRL_1_ROP(v)  \
+	(((v) << 4) & BM_PXP_ALPHA_B_CTRL_1_ROP)
+#define BV_PXP_ALPHA_B_CTRL_1_ROP__MASKAS     0x0
+#define BV_PXP_ALPHA_B_CTRL_1_ROP__MASKNOTAS  0x1
+#define BV_PXP_ALPHA_B_CTRL_1_ROP__MASKASNOT  0x2
+#define BV_PXP_ALPHA_B_CTRL_1_ROP__MERGEAS    0x3
+#define BV_PXP_ALPHA_B_CTRL_1_ROP__MERGENOTAS 0x4
+#define BV_PXP_ALPHA_B_CTRL_1_ROP__MERGEASNOT 0x5
+#define BV_PXP_ALPHA_B_CTRL_1_ROP__NOTCOPYAS  0x6
+#define BV_PXP_ALPHA_B_CTRL_1_ROP__NOT	0x7
+#define BV_PXP_ALPHA_B_CTRL_1_ROP__NOTMASKAS  0x8
+#define BV_PXP_ALPHA_B_CTRL_1_ROP__NOTMERGEAS 0x9
+#define BV_PXP_ALPHA_B_CTRL_1_ROP__XORAS      0xA
+#define BV_PXP_ALPHA_B_CTRL_1_ROP__NOTXORAS   0xB
+#define BP_PXP_ALPHA_B_CTRL_1_RSVD1      2
+#define BM_PXP_ALPHA_B_CTRL_1_RSVD1 0x0000000C
+#define BF_PXP_ALPHA_B_CTRL_1_RSVD1(v)  \
+	(((v) << 2) & BM_PXP_ALPHA_B_CTRL_1_RSVD1)
+#define BM_PXP_ALPHA_B_CTRL_1_OL_CLRKEY_ENABLE 0x00000002
+#define BF_PXP_ALPHA_B_CTRL_1_OL_CLRKEY_ENABLE(v)  \
+	(((v) << 1) & BM_PXP_ALPHA_B_CTRL_1_OL_CLRKEY_ENABLE)
+#define BM_PXP_ALPHA_B_CTRL_1_ROP_ENABLE 0x00000001
+#define BF_PXP_ALPHA_B_CTRL_1_ROP_ENABLE(v)  \
+	(((v) << 0) & BM_PXP_ALPHA_B_CTRL_1_ROP_ENABLE)
+
+#define HW_PXP_PS_BACKGROUND_1	(0x000002c0)
+
+#define BP_PXP_PS_BACKGROUND_1_RSVD      24
+#define BM_PXP_PS_BACKGROUND_1_RSVD 0xFF000000
+#define BF_PXP_PS_BACKGROUND_1_RSVD(v) \
+	(((v) << 24) & BM_PXP_PS_BACKGROUND_1_RSVD)
+#define BP_PXP_PS_BACKGROUND_1_COLOR      0
+#define BM_PXP_PS_BACKGROUND_1_COLOR 0x00FFFFFF
+#define BF_PXP_PS_BACKGROUND_1_COLOR(v)  \
+	(((v) << 0) & BM_PXP_PS_BACKGROUND_1_COLOR)
+
+#define HW_PXP_PS_CLRKEYLOW_1	(0x000002d0)
+
+#define BP_PXP_PS_CLRKEYLOW_1_RSVD1      24
+#define BM_PXP_PS_CLRKEYLOW_1_RSVD1 0xFF000000
+#define BF_PXP_PS_CLRKEYLOW_1_RSVD1(v) \
+	(((v) << 24) & BM_PXP_PS_CLRKEYLOW_1_RSVD1)
+#define BP_PXP_PS_CLRKEYLOW_1_PIXEL      0
+#define BM_PXP_PS_CLRKEYLOW_1_PIXEL 0x00FFFFFF
+#define BF_PXP_PS_CLRKEYLOW_1_PIXEL(v)  \
+	(((v) << 0) & BM_PXP_PS_CLRKEYLOW_1_PIXEL)
+
+#define HW_PXP_PS_CLRKEYHIGH_1	(0x000002e0)
+
+#define BP_PXP_PS_CLRKEYHIGH_1_RSVD1      24
+#define BM_PXP_PS_CLRKEYHIGH_1_RSVD1 0xFF000000
+#define BF_PXP_PS_CLRKEYHIGH_1_RSVD1(v) \
+	(((v) << 24) & BM_PXP_PS_CLRKEYHIGH_1_RSVD1)
+#define BP_PXP_PS_CLRKEYHIGH_1_PIXEL      0
+#define BM_PXP_PS_CLRKEYHIGH_1_PIXEL 0x00FFFFFF
+#define BF_PXP_PS_CLRKEYHIGH_1_PIXEL(v)  \
+	(((v) << 0) & BM_PXP_PS_CLRKEYHIGH_1_PIXEL)
+
+#define HW_PXP_AS_CLRKEYLOW_1	(0x000002f0)
+
+#define BP_PXP_AS_CLRKEYLOW_1_RSVD1      24
+#define BM_PXP_AS_CLRKEYLOW_1_RSVD1 0xFF000000
+#define BF_PXP_AS_CLRKEYLOW_1_RSVD1(v) \
+	(((v) << 24) & BM_PXP_AS_CLRKEYLOW_1_RSVD1)
+#define BP_PXP_AS_CLRKEYLOW_1_PIXEL      0
+#define BM_PXP_AS_CLRKEYLOW_1_PIXEL 0x00FFFFFF
+#define BF_PXP_AS_CLRKEYLOW_1_PIXEL(v)  \
+	(((v) << 0) & BM_PXP_AS_CLRKEYLOW_1_PIXEL)
+
+#define HW_PXP_AS_CLRKEYHIGH_1	(0x00000300)
+
+#define BP_PXP_AS_CLRKEYHIGH_1_RSVD1      24
+#define BM_PXP_AS_CLRKEYHIGH_1_RSVD1 0xFF000000
+#define BF_PXP_AS_CLRKEYHIGH_1_RSVD1(v) \
+	(((v) << 24) & BM_PXP_AS_CLRKEYHIGH_1_RSVD1)
+#define BP_PXP_AS_CLRKEYHIGH_1_PIXEL      0
+#define BM_PXP_AS_CLRKEYHIGH_1_PIXEL 0x00FFFFFF
+#define BF_PXP_AS_CLRKEYHIGH_1_PIXEL(v)  \
+	(((v) << 0) & BM_PXP_AS_CLRKEYHIGH_1_PIXEL)
+
+#define HW_PXP_CTRL2	(0x00000310)
+#define HW_PXP_CTRL2_SET	(0x00000314)
+#define HW_PXP_CTRL2_CLR	(0x00000318)
+#define HW_PXP_CTRL2_TOG	(0x0000031c)
+
+#define BP_PXP_CTRL2_RSVD3      28
+#define BM_PXP_CTRL2_RSVD3 0xF0000000
+#define BF_PXP_CTRL2_RSVD3(v) \
+	(((v) << 28) & BM_PXP_CTRL2_RSVD3)
+#define BM_PXP_CTRL2_ENABLE_ROTATE1 0x08000000
+#define BF_PXP_CTRL2_ENABLE_ROTATE1(v)  \
+	(((v) << 27) & BM_PXP_CTRL2_ENABLE_ROTATE1)
+#define BM_PXP_CTRL2_ENABLE_ROTATE0 0x04000000
+#define BF_PXP_CTRL2_ENABLE_ROTATE0(v)  \
+	(((v) << 26) & BM_PXP_CTRL2_ENABLE_ROTATE0)
+#define BM_PXP_CTRL2_ENABLE_LUT 0x02000000
+#define BF_PXP_CTRL2_ENABLE_LUT(v)  \
+	(((v) << 25) & BM_PXP_CTRL2_ENABLE_LUT)
+#define BM_PXP_CTRL2_ENABLE_CSC2 0x01000000
+#define BF_PXP_CTRL2_ENABLE_CSC2(v)  \
+	(((v) << 24) & BM_PXP_CTRL2_ENABLE_CSC2)
+#define BM_PXP_CTRL2_BLOCK_SIZE 0x00800000
+#define BF_PXP_CTRL2_BLOCK_SIZE(v)  \
+	(((v) << 23) & BM_PXP_CTRL2_BLOCK_SIZE)
+#define BV_PXP_CTRL2_BLOCK_SIZE__8X8   0x0
+#define BV_PXP_CTRL2_BLOCK_SIZE__16X16 0x1
+#define BM_PXP_CTRL2_RSVD2 0x00400000
+#define BF_PXP_CTRL2_RSVD2(v)  \
+	(((v) << 22) & BM_PXP_CTRL2_RSVD2)
+#define BM_PXP_CTRL2_ENABLE_ALPHA_B 0x00200000
+#define BF_PXP_CTRL2_ENABLE_ALPHA_B(v)  \
+	(((v) << 21) & BM_PXP_CTRL2_ENABLE_ALPHA_B)
+#define BM_PXP_CTRL2_ENABLE_INPUT_FETCH_STORE 0x00100000
+#define BF_PXP_CTRL2_ENABLE_INPUT_FETCH_STORE(v)  \
+	(((v) << 20) & BM_PXP_CTRL2_ENABLE_INPUT_FETCH_STORE)
+#define BM_PXP_CTRL2_ENABLE_WFE_B 0x00080000
+#define BF_PXP_CTRL2_ENABLE_WFE_B(v)  \
+	(((v) << 19) & BM_PXP_CTRL2_ENABLE_WFE_B)
+#define BM_PXP_CTRL2_ENABLE_WFE_A 0x00040000
+#define BF_PXP_CTRL2_ENABLE_WFE_A(v)  \
+	(((v) << 18) & BM_PXP_CTRL2_ENABLE_WFE_A)
+#define BM_PXP_CTRL2_ENABLE_DITHER 0x00020000
+#define BF_PXP_CTRL2_ENABLE_DITHER(v)  \
+	(((v) << 17) & BM_PXP_CTRL2_ENABLE_DITHER)
+#define BM_PXP_CTRL2_RSVD1 0x00010000
+#define BF_PXP_CTRL2_RSVD1(v)  \
+	(((v) << 16) & BM_PXP_CTRL2_RSVD1)
+#define BM_PXP_CTRL2_VFLIP1 0x00008000
+#define BF_PXP_CTRL2_VFLIP1(v)  \
+	(((v) << 15) & BM_PXP_CTRL2_VFLIP1)
+#define BM_PXP_CTRL2_HFLIP1 0x00004000
+#define BF_PXP_CTRL2_HFLIP1(v)  \
+	(((v) << 14) & BM_PXP_CTRL2_HFLIP1)
+#define BP_PXP_CTRL2_ROTATE1      12
+#define BM_PXP_CTRL2_ROTATE1 0x00003000
+#define BF_PXP_CTRL2_ROTATE1(v)  \
+	(((v) << 12) & BM_PXP_CTRL2_ROTATE1)
+#define BV_PXP_CTRL2_ROTATE1__ROT_0   0x0
+#define BV_PXP_CTRL2_ROTATE1__ROT_90  0x1
+#define BV_PXP_CTRL2_ROTATE1__ROT_180 0x2
+#define BV_PXP_CTRL2_ROTATE1__ROT_270 0x3
+#define BM_PXP_CTRL2_VFLIP0 0x00000800
+#define BF_PXP_CTRL2_VFLIP0(v)  \
+	(((v) << 11) & BM_PXP_CTRL2_VFLIP0)
+#define BM_PXP_CTRL2_HFLIP0 0x00000400
+#define BF_PXP_CTRL2_HFLIP0(v)  \
+	(((v) << 10) & BM_PXP_CTRL2_HFLIP0)
+#define BP_PXP_CTRL2_ROTATE0      8
+#define BM_PXP_CTRL2_ROTATE0 0x00000300
+#define BF_PXP_CTRL2_ROTATE0(v)  \
+	(((v) << 8) & BM_PXP_CTRL2_ROTATE0)
+#define BV_PXP_CTRL2_ROTATE0__ROT_0   0x0
+#define BV_PXP_CTRL2_ROTATE0__ROT_90  0x1
+#define BV_PXP_CTRL2_ROTATE0__ROT_180 0x2
+#define BV_PXP_CTRL2_ROTATE0__ROT_270 0x3
+#define BP_PXP_CTRL2_RSVD0      1
+#define BM_PXP_CTRL2_RSVD0 0x000000FE
+#define BF_PXP_CTRL2_RSVD0(v)  \
+	(((v) << 1) & BM_PXP_CTRL2_RSVD0)
+#define BM_PXP_CTRL2_ENABLE 0x00000001
+#define BF_PXP_CTRL2_ENABLE(v)  \
+	(((v) << 0) & BM_PXP_CTRL2_ENABLE)
+
+#define HW_PXP_POWER_REG0	(0x00000320)
+
+#define BP_PXP_POWER_REG0_CTRL      12
+#define BM_PXP_POWER_REG0_CTRL 0xFFFFF000
+#define BF_PXP_POWER_REG0_CTRL(v) \
+	(((v) << 12) & BM_PXP_POWER_REG0_CTRL)
+#define BP_PXP_POWER_REG0_ROT0_MEM_LP_STATE      9
+#define BM_PXP_POWER_REG0_ROT0_MEM_LP_STATE 0x00000E00
+#define BF_PXP_POWER_REG0_ROT0_MEM_LP_STATE(v)  \
+	(((v) << 9) & BM_PXP_POWER_REG0_ROT0_MEM_LP_STATE)
+#define BV_PXP_POWER_REG0_ROT0_MEM_LP_STATE__NONE 0x0
+#define BV_PXP_POWER_REG0_ROT0_MEM_LP_STATE__LS   0x1
+#define BV_PXP_POWER_REG0_ROT0_MEM_LP_STATE__DS   0x2
+#define BV_PXP_POWER_REG0_ROT0_MEM_LP_STATE__SD   0x4
+#define BP_PXP_POWER_REG0_LUT_LP_STATE_WAY1_BANKN      6
+#define BM_PXP_POWER_REG0_LUT_LP_STATE_WAY1_BANKN 0x000001C0
+#define BF_PXP_POWER_REG0_LUT_LP_STATE_WAY1_BANKN(v)  \
+	(((v) << 6) & BM_PXP_POWER_REG0_LUT_LP_STATE_WAY1_BANKN)
+#define BV_PXP_POWER_REG0_LUT_LP_STATE_WAY1_BANKN__NONE 0x0
+#define BV_PXP_POWER_REG0_LUT_LP_STATE_WAY1_BANKN__LS   0x1
+#define BV_PXP_POWER_REG0_LUT_LP_STATE_WAY1_BANKN__DS   0x2
+#define BV_PXP_POWER_REG0_LUT_LP_STATE_WAY1_BANKN__SD   0x4
+#define BP_PXP_POWER_REG0_LUT_LP_STATE_WAY0_BANKN      3
+#define BM_PXP_POWER_REG0_LUT_LP_STATE_WAY0_BANKN 0x00000038
+#define BF_PXP_POWER_REG0_LUT_LP_STATE_WAY0_BANKN(v)  \
+	(((v) << 3) & BM_PXP_POWER_REG0_LUT_LP_STATE_WAY0_BANKN)
+#define BV_PXP_POWER_REG0_LUT_LP_STATE_WAY0_BANKN__NONE 0x0
+#define BV_PXP_POWER_REG0_LUT_LP_STATE_WAY0_BANKN__LS   0x1
+#define BV_PXP_POWER_REG0_LUT_LP_STATE_WAY0_BANKN__DS   0x2
+#define BV_PXP_POWER_REG0_LUT_LP_STATE_WAY0_BANKN__SD   0x4
+#define BP_PXP_POWER_REG0_LUT_LP_STATE_WAY0_BANK0      0
+#define BM_PXP_POWER_REG0_LUT_LP_STATE_WAY0_BANK0 0x00000007
+#define BF_PXP_POWER_REG0_LUT_LP_STATE_WAY0_BANK0(v)  \
+	(((v) << 0) & BM_PXP_POWER_REG0_LUT_LP_STATE_WAY0_BANK0)
+#define BV_PXP_POWER_REG0_LUT_LP_STATE_WAY0_BANK0__NONE 0x0
+#define BV_PXP_POWER_REG0_LUT_LP_STATE_WAY0_BANK0__LS   0x1
+#define BV_PXP_POWER_REG0_LUT_LP_STATE_WAY0_BANK0__DS   0x2
+#define BV_PXP_POWER_REG0_LUT_LP_STATE_WAY0_BANK0__SD   0x4
+
+#define HW_PXP_POWER_REG1	(0x00000330)
+
+#define BP_PXP_POWER_REG1_RSVD0      24
+#define BM_PXP_POWER_REG1_RSVD0 0xFF000000
+#define BF_PXP_POWER_REG1_RSVD0(v) \
+	(((v) << 24) & BM_PXP_POWER_REG1_RSVD0)
+#define BP_PXP_POWER_REG1_ALU_B_MEM_LP_STATE      21
+#define BM_PXP_POWER_REG1_ALU_B_MEM_LP_STATE 0x00E00000
+#define BF_PXP_POWER_REG1_ALU_B_MEM_LP_STATE(v)  \
+	(((v) << 21) & BM_PXP_POWER_REG1_ALU_B_MEM_LP_STATE)
+#define BV_PXP_POWER_REG1_ALU_B_MEM_LP_STATE__NONE 0x0
+#define BV_PXP_POWER_REG1_ALU_B_MEM_LP_STATE__LS   0x1
+#define BV_PXP_POWER_REG1_ALU_B_MEM_LP_STATE__DS   0x2
+#define BV_PXP_POWER_REG1_ALU_B_MEM_LP_STATE__SD   0x4
+#define BP_PXP_POWER_REG1_ALU_A_MEM_LP_STATE      18
+#define BM_PXP_POWER_REG1_ALU_A_MEM_LP_STATE 0x001C0000
+#define BF_PXP_POWER_REG1_ALU_A_MEM_LP_STATE(v)  \
+	(((v) << 18) & BM_PXP_POWER_REG1_ALU_A_MEM_LP_STATE)
+#define BV_PXP_POWER_REG1_ALU_A_MEM_LP_STATE__NONE 0x0
+#define BV_PXP_POWER_REG1_ALU_A_MEM_LP_STATE__LS   0x1
+#define BV_PXP_POWER_REG1_ALU_A_MEM_LP_STATE__DS   0x2
+#define BV_PXP_POWER_REG1_ALU_A_MEM_LP_STATE__SD   0x4
+#define BP_PXP_POWER_REG1_DITH2_LUT_MEM_LP_STATE      15
+#define BM_PXP_POWER_REG1_DITH2_LUT_MEM_LP_STATE 0x00038000
+#define BF_PXP_POWER_REG1_DITH2_LUT_MEM_LP_STATE(v)  \
+	(((v) << 15) & BM_PXP_POWER_REG1_DITH2_LUT_MEM_LP_STATE)
+#define BV_PXP_POWER_REG1_DITH2_LUT_MEM_LP_STATE__NONE 0x0
+#define BV_PXP_POWER_REG1_DITH2_LUT_MEM_LP_STATE__LS   0x1
+#define BV_PXP_POWER_REG1_DITH2_LUT_MEM_LP_STATE__DS   0x2
+#define BV_PXP_POWER_REG1_DITH2_LUT_MEM_LP_STATE__SD   0x4
+#define BP_PXP_POWER_REG1_DITH1_LUT_MEM_LP_STATE      12
+#define BM_PXP_POWER_REG1_DITH1_LUT_MEM_LP_STATE 0x00007000
+#define BF_PXP_POWER_REG1_DITH1_LUT_MEM_LP_STATE(v)  \
+	(((v) << 12) & BM_PXP_POWER_REG1_DITH1_LUT_MEM_LP_STATE)
+#define BV_PXP_POWER_REG1_DITH1_LUT_MEM_LP_STATE__NONE 0x0
+#define BV_PXP_POWER_REG1_DITH1_LUT_MEM_LP_STATE__LS   0x1
+#define BV_PXP_POWER_REG1_DITH1_LUT_MEM_LP_STATE__DS   0x2
+#define BV_PXP_POWER_REG1_DITH1_LUT_MEM_LP_STATE__SD   0x4
+#define BP_PXP_POWER_REG1_DITH0_ERR1_MEM_LP_STATE      9
+#define BM_PXP_POWER_REG1_DITH0_ERR1_MEM_LP_STATE 0x00000E00
+#define BF_PXP_POWER_REG1_DITH0_ERR1_MEM_LP_STATE(v)  \
+	(((v) << 9) & BM_PXP_POWER_REG1_DITH0_ERR1_MEM_LP_STATE)
+#define BV_PXP_POWER_REG1_DITH0_ERR1_MEM_LP_STATE__NONE 0x0
+#define BV_PXP_POWER_REG1_DITH0_ERR1_MEM_LP_STATE__LS   0x1
+#define BV_PXP_POWER_REG1_DITH0_ERR1_MEM_LP_STATE__DS   0x2
+#define BV_PXP_POWER_REG1_DITH0_ERR1_MEM_LP_STATE__SD   0x4
+#define BP_PXP_POWER_REG1_DITH0_ERR0_MEM_LP_STATE      6
+#define BM_PXP_POWER_REG1_DITH0_ERR0_MEM_LP_STATE 0x000001C0
+#define BF_PXP_POWER_REG1_DITH0_ERR0_MEM_LP_STATE(v)  \
+	(((v) << 6) & BM_PXP_POWER_REG1_DITH0_ERR0_MEM_LP_STATE)
+#define BV_PXP_POWER_REG1_DITH0_ERR0_MEM_LP_STATE__NONE 0x0
+#define BV_PXP_POWER_REG1_DITH0_ERR0_MEM_LP_STATE__LS   0x1
+#define BV_PXP_POWER_REG1_DITH0_ERR0_MEM_LP_STATE__DS   0x2
+#define BV_PXP_POWER_REG1_DITH0_ERR0_MEM_LP_STATE__SD   0x4
+#define BP_PXP_POWER_REG1_DITH0_LUT_MEM_LP_STATE      3
+#define BM_PXP_POWER_REG1_DITH0_LUT_MEM_LP_STATE 0x00000038
+#define BF_PXP_POWER_REG1_DITH0_LUT_MEM_LP_STATE(v)  \
+	(((v) << 3) & BM_PXP_POWER_REG1_DITH0_LUT_MEM_LP_STATE)
+#define BV_PXP_POWER_REG1_DITH0_LUT_MEM_LP_STATE__NONE 0x0
+#define BV_PXP_POWER_REG1_DITH0_LUT_MEM_LP_STATE__LS   0x1
+#define BV_PXP_POWER_REG1_DITH0_LUT_MEM_LP_STATE__DS   0x2
+#define BV_PXP_POWER_REG1_DITH0_LUT_MEM_LP_STATE__SD   0x4
+#define BP_PXP_POWER_REG1_ROT1_MEM_LP_STATE      0
+#define BM_PXP_POWER_REG1_ROT1_MEM_LP_STATE 0x00000007
+#define BF_PXP_POWER_REG1_ROT1_MEM_LP_STATE(v)  \
+	(((v) << 0) & BM_PXP_POWER_REG1_ROT1_MEM_LP_STATE)
+#define BV_PXP_POWER_REG1_ROT1_MEM_LP_STATE__NONE 0x0
+#define BV_PXP_POWER_REG1_ROT1_MEM_LP_STATE__LS   0x1
+#define BV_PXP_POWER_REG1_ROT1_MEM_LP_STATE__DS   0x2
+#define BV_PXP_POWER_REG1_ROT1_MEM_LP_STATE__SD   0x4
+
+#define HW_PXP_DATA_PATH_CTRL0	(0x00000340)
+#define HW_PXP_DATA_PATH_CTRL0_SET	(0x00000344)
+#define HW_PXP_DATA_PATH_CTRL0_CLR	(0x00000348)
+#define HW_PXP_DATA_PATH_CTRL0_TOG	(0x0000034c)
+
+#define BP_PXP_DATA_PATH_CTRL0_MUX15_SEL      30
+#define BM_PXP_DATA_PATH_CTRL0_MUX15_SEL 0xC0000000
+#define BF_PXP_DATA_PATH_CTRL0_MUX15_SEL(v) \
+	(((v) << 30) & BM_PXP_DATA_PATH_CTRL0_MUX15_SEL)
+#define BV_PXP_DATA_PATH_CTRL0_MUX15_SEL__0 0x0
+#define BV_PXP_DATA_PATH_CTRL0_MUX15_SEL__1 0x1
+#define BV_PXP_DATA_PATH_CTRL0_MUX15_SEL__2 0x2
+#define BV_PXP_DATA_PATH_CTRL0_MUX15_SEL__3 0x3
+#define BP_PXP_DATA_PATH_CTRL0_MUX14_SEL      28
+#define BM_PXP_DATA_PATH_CTRL0_MUX14_SEL 0x30000000
+#define BF_PXP_DATA_PATH_CTRL0_MUX14_SEL(v)  \
+	(((v) << 28) & BM_PXP_DATA_PATH_CTRL0_MUX14_SEL)
+#define BV_PXP_DATA_PATH_CTRL0_MUX14_SEL__0 0x0
+#define BV_PXP_DATA_PATH_CTRL0_MUX14_SEL__1 0x1
+#define BV_PXP_DATA_PATH_CTRL0_MUX14_SEL__2 0x2
+#define BV_PXP_DATA_PATH_CTRL0_MUX14_SEL__3 0x3
+#define BP_PXP_DATA_PATH_CTRL0_MUX13_SEL      26
+#define BM_PXP_DATA_PATH_CTRL0_MUX13_SEL 0x0C000000
+#define BF_PXP_DATA_PATH_CTRL0_MUX13_SEL(v)  \
+	(((v) << 26) & BM_PXP_DATA_PATH_CTRL0_MUX13_SEL)
+#define BV_PXP_DATA_PATH_CTRL0_MUX13_SEL__0 0x0
+#define BV_PXP_DATA_PATH_CTRL0_MUX13_SEL__1 0x1
+#define BV_PXP_DATA_PATH_CTRL0_MUX13_SEL__2 0x2
+#define BV_PXP_DATA_PATH_CTRL0_MUX13_SEL__3 0x3
+#define BP_PXP_DATA_PATH_CTRL0_MUX12_SEL      24
+#define BM_PXP_DATA_PATH_CTRL0_MUX12_SEL 0x03000000
+#define BF_PXP_DATA_PATH_CTRL0_MUX12_SEL(v)  \
+	(((v) << 24) & BM_PXP_DATA_PATH_CTRL0_MUX12_SEL)
+#define BV_PXP_DATA_PATH_CTRL0_MUX12_SEL__0 0x0
+#define BV_PXP_DATA_PATH_CTRL0_MUX12_SEL__1 0x1
+#define BV_PXP_DATA_PATH_CTRL0_MUX12_SEL__2 0x2
+#define BV_PXP_DATA_PATH_CTRL0_MUX12_SEL__3 0x3
+#define BP_PXP_DATA_PATH_CTRL0_MUX11_SEL      22
+#define BM_PXP_DATA_PATH_CTRL0_MUX11_SEL 0x00C00000
+#define BF_PXP_DATA_PATH_CTRL0_MUX11_SEL(v)  \
+	(((v) << 22) & BM_PXP_DATA_PATH_CTRL0_MUX11_SEL)
+#define BV_PXP_DATA_PATH_CTRL0_MUX11_SEL__0 0x0
+#define BV_PXP_DATA_PATH_CTRL0_MUX11_SEL__1 0x1
+#define BV_PXP_DATA_PATH_CTRL0_MUX11_SEL__2 0x2
+#define BV_PXP_DATA_PATH_CTRL0_MUX11_SEL__3 0x3
+#define BP_PXP_DATA_PATH_CTRL0_MUX10_SEL      20
+#define BM_PXP_DATA_PATH_CTRL0_MUX10_SEL 0x00300000
+#define BF_PXP_DATA_PATH_CTRL0_MUX10_SEL(v)  \
+	(((v) << 20) & BM_PXP_DATA_PATH_CTRL0_MUX10_SEL)
+#define BV_PXP_DATA_PATH_CTRL0_MUX10_SEL__0 0x0
+#define BV_PXP_DATA_PATH_CTRL0_MUX10_SEL__1 0x1
+#define BV_PXP_DATA_PATH_CTRL0_MUX10_SEL__2 0x2
+#define BV_PXP_DATA_PATH_CTRL0_MUX10_SEL__3 0x3
+#define BP_PXP_DATA_PATH_CTRL0_MUX9_SEL      18
+#define BM_PXP_DATA_PATH_CTRL0_MUX9_SEL 0x000C0000
+#define BF_PXP_DATA_PATH_CTRL0_MUX9_SEL(v)  \
+	(((v) << 18) & BM_PXP_DATA_PATH_CTRL0_MUX9_SEL)
+#define BV_PXP_DATA_PATH_CTRL0_MUX9_SEL__0 0x0
+#define BV_PXP_DATA_PATH_CTRL0_MUX9_SEL__1 0x1
+#define BV_PXP_DATA_PATH_CTRL0_MUX9_SEL__2 0x2
+#define BV_PXP_DATA_PATH_CTRL0_MUX9_SEL__3 0x3
+#define BP_PXP_DATA_PATH_CTRL0_MUX8_SEL      16
+#define BM_PXP_DATA_PATH_CTRL0_MUX8_SEL 0x00030000
+#define BF_PXP_DATA_PATH_CTRL0_MUX8_SEL(v)  \
+	(((v) << 16) & BM_PXP_DATA_PATH_CTRL0_MUX8_SEL)
+#define BV_PXP_DATA_PATH_CTRL0_MUX8_SEL__0 0x0
+#define BV_PXP_DATA_PATH_CTRL0_MUX8_SEL__1 0x1
+#define BV_PXP_DATA_PATH_CTRL0_MUX8_SEL__2 0x2
+#define BV_PXP_DATA_PATH_CTRL0_MUX8_SEL__3 0x3
+#define BP_PXP_DATA_PATH_CTRL0_MUX7_SEL      14
+#define BM_PXP_DATA_PATH_CTRL0_MUX7_SEL 0x0000C000
+#define BF_PXP_DATA_PATH_CTRL0_MUX7_SEL(v)  \
+	(((v) << 14) & BM_PXP_DATA_PATH_CTRL0_MUX7_SEL)
+#define BV_PXP_DATA_PATH_CTRL0_MUX7_SEL__0 0x0
+#define BV_PXP_DATA_PATH_CTRL0_MUX7_SEL__1 0x1
+#define BV_PXP_DATA_PATH_CTRL0_MUX7_SEL__2 0x2
+#define BV_PXP_DATA_PATH_CTRL0_MUX7_SEL__3 0x3
+#define BP_PXP_DATA_PATH_CTRL0_MUX6_SEL      12
+#define BM_PXP_DATA_PATH_CTRL0_MUX6_SEL 0x00003000
+#define BF_PXP_DATA_PATH_CTRL0_MUX6_SEL(v)  \
+	(((v) << 12) & BM_PXP_DATA_PATH_CTRL0_MUX6_SEL)
+#define BV_PXP_DATA_PATH_CTRL0_MUX6_SEL__0 0x0
+#define BV_PXP_DATA_PATH_CTRL0_MUX6_SEL__1 0x1
+#define BV_PXP_DATA_PATH_CTRL0_MUX6_SEL__2 0x2
+#define BV_PXP_DATA_PATH_CTRL0_MUX6_SEL__3 0x3
+#define BP_PXP_DATA_PATH_CTRL0_MUX5_SEL      10
+#define BM_PXP_DATA_PATH_CTRL0_MUX5_SEL 0x00000C00
+#define BF_PXP_DATA_PATH_CTRL0_MUX5_SEL(v)  \
+	(((v) << 10) & BM_PXP_DATA_PATH_CTRL0_MUX5_SEL)
+#define BV_PXP_DATA_PATH_CTRL0_MUX5_SEL__0 0x0
+#define BV_PXP_DATA_PATH_CTRL0_MUX5_SEL__1 0x1
+#define BV_PXP_DATA_PATH_CTRL0_MUX5_SEL__2 0x2
+#define BV_PXP_DATA_PATH_CTRL0_MUX5_SEL__3 0x3
+#define BP_PXP_DATA_PATH_CTRL0_MUX4_SEL      8
+#define BM_PXP_DATA_PATH_CTRL0_MUX4_SEL 0x00000300
+#define BF_PXP_DATA_PATH_CTRL0_MUX4_SEL(v)  \
+	(((v) << 8) & BM_PXP_DATA_PATH_CTRL0_MUX4_SEL)
+#define BV_PXP_DATA_PATH_CTRL0_MUX4_SEL__0 0x0
+#define BV_PXP_DATA_PATH_CTRL0_MUX4_SEL__1 0x1
+#define BV_PXP_DATA_PATH_CTRL0_MUX4_SEL__2 0x2
+#define BV_PXP_DATA_PATH_CTRL0_MUX4_SEL__3 0x3
+#define BP_PXP_DATA_PATH_CTRL0_MUX3_SEL      6
+#define BM_PXP_DATA_PATH_CTRL0_MUX3_SEL 0x000000C0
+#define BF_PXP_DATA_PATH_CTRL0_MUX3_SEL(v)  \
+	(((v) << 6) & BM_PXP_DATA_PATH_CTRL0_MUX3_SEL)
+#define BV_PXP_DATA_PATH_CTRL0_MUX3_SEL__0 0x0
+#define BV_PXP_DATA_PATH_CTRL0_MUX3_SEL__1 0x1
+#define BV_PXP_DATA_PATH_CTRL0_MUX3_SEL__2 0x2
+#define BV_PXP_DATA_PATH_CTRL0_MUX3_SEL__3 0x3
+#define BP_PXP_DATA_PATH_CTRL0_MUX2_SEL      4
+#define BM_PXP_DATA_PATH_CTRL0_MUX2_SEL 0x00000030
+#define BF_PXP_DATA_PATH_CTRL0_MUX2_SEL(v)  \
+	(((v) << 4) & BM_PXP_DATA_PATH_CTRL0_MUX2_SEL)
+#define BV_PXP_DATA_PATH_CTRL0_MUX2_SEL__0 0x0
+#define BV_PXP_DATA_PATH_CTRL0_MUX2_SEL__1 0x1
+#define BV_PXP_DATA_PATH_CTRL0_MUX2_SEL__2 0x2
+#define BV_PXP_DATA_PATH_CTRL0_MUX2_SEL__3 0x3
+#define BP_PXP_DATA_PATH_CTRL0_MUX1_SEL      2
+#define BM_PXP_DATA_PATH_CTRL0_MUX1_SEL 0x0000000C
+#define BF_PXP_DATA_PATH_CTRL0_MUX1_SEL(v)  \
+	(((v) << 2) & BM_PXP_DATA_PATH_CTRL0_MUX1_SEL)
+#define BV_PXP_DATA_PATH_CTRL0_MUX1_SEL__0 0x0
+#define BV_PXP_DATA_PATH_CTRL0_MUX1_SEL__1 0x1
+#define BV_PXP_DATA_PATH_CTRL0_MUX1_SEL__2 0x2
+#define BV_PXP_DATA_PATH_CTRL0_MUX1_SEL__3 0x3
+#define BP_PXP_DATA_PATH_CTRL0_MUX0_SEL      0
+#define BM_PXP_DATA_PATH_CTRL0_MUX0_SEL 0x00000003
+#define BF_PXP_DATA_PATH_CTRL0_MUX0_SEL(v)  \
+	(((v) << 0) & BM_PXP_DATA_PATH_CTRL0_MUX0_SEL)
+#define BV_PXP_DATA_PATH_CTRL0_MUX0_SEL__0 0x0
+#define BV_PXP_DATA_PATH_CTRL0_MUX0_SEL__1 0x1
+#define BV_PXP_DATA_PATH_CTRL0_MUX0_SEL__2 0x2
+#define BV_PXP_DATA_PATH_CTRL0_MUX0_SEL__3 0x3
+
+#define HW_PXP_DATA_PATH_CTRL1	(0x00000350)
+#define HW_PXP_DATA_PATH_CTRL1_SET	(0x00000354)
+#define HW_PXP_DATA_PATH_CTRL1_CLR	(0x00000358)
+#define HW_PXP_DATA_PATH_CTRL1_TOG	(0x0000035c)
+
+#define BP_PXP_DATA_PATH_CTRL1_RSVD0      4
+#define BM_PXP_DATA_PATH_CTRL1_RSVD0 0xFFFFFFF0
+#define BF_PXP_DATA_PATH_CTRL1_RSVD0(v) \
+	(((v) << 4) & BM_PXP_DATA_PATH_CTRL1_RSVD0)
+#define BP_PXP_DATA_PATH_CTRL1_MUX17_SEL      2
+#define BM_PXP_DATA_PATH_CTRL1_MUX17_SEL 0x0000000C
+#define BF_PXP_DATA_PATH_CTRL1_MUX17_SEL(v)  \
+	(((v) << 2) & BM_PXP_DATA_PATH_CTRL1_MUX17_SEL)
+#define BV_PXP_DATA_PATH_CTRL1_MUX17_SEL__0 0x0
+#define BV_PXP_DATA_PATH_CTRL1_MUX17_SEL__1 0x1
+#define BV_PXP_DATA_PATH_CTRL1_MUX17_SEL__2 0x2
+#define BV_PXP_DATA_PATH_CTRL1_MUX17_SEL__3 0x3
+#define BP_PXP_DATA_PATH_CTRL1_MUX16_SEL      0
+#define BM_PXP_DATA_PATH_CTRL1_MUX16_SEL 0x00000003
+#define BF_PXP_DATA_PATH_CTRL1_MUX16_SEL(v)  \
+	(((v) << 0) & BM_PXP_DATA_PATH_CTRL1_MUX16_SEL)
+#define BV_PXP_DATA_PATH_CTRL1_MUX16_SEL__0 0x0
+#define BV_PXP_DATA_PATH_CTRL1_MUX16_SEL__1 0x1
+#define BV_PXP_DATA_PATH_CTRL1_MUX16_SEL__2 0x2
+#define BV_PXP_DATA_PATH_CTRL1_MUX16_SEL__3 0x3
+
+#define HW_PXP_INIT_MEM_CTRL	(0x00000360)
+#define HW_PXP_INIT_MEM_CTRL_SET	(0x00000364)
+#define HW_PXP_INIT_MEM_CTRL_CLR	(0x00000368)
+#define HW_PXP_INIT_MEM_CTRL_TOG	(0x0000036c)
+
+#define BM_PXP_INIT_MEM_CTRL_START 0x80000000
+#define BF_PXP_INIT_MEM_CTRL_START(v) \
+	(((v) << 31) & BM_PXP_INIT_MEM_CTRL_START)
+#define BP_PXP_INIT_MEM_CTRL_SELECT      27
+#define BM_PXP_INIT_MEM_CTRL_SELECT 0x78000000
+#define BF_PXP_INIT_MEM_CTRL_SELECT(v)  \
+	(((v) << 27) & BM_PXP_INIT_MEM_CTRL_SELECT)
+#define BV_PXP_INIT_MEM_CTRL_SELECT__DITHER0_LUT  0x0
+#define BV_PXP_INIT_MEM_CTRL_SELECT__DITHER0_ERR0 0x1
+#define BV_PXP_INIT_MEM_CTRL_SELECT__DITHER0_ERR1 0x2
+#define BV_PXP_INIT_MEM_CTRL_SELECT__DITHER1_LUT  0x3
+#define BV_PXP_INIT_MEM_CTRL_SELECT__DITHER2_LUT  0x4
+#define BV_PXP_INIT_MEM_CTRL_SELECT__ALU_A	0x5
+#define BV_PXP_INIT_MEM_CTRL_SELECT__ALU_B	0x6
+#define BV_PXP_INIT_MEM_CTRL_SELECT__WFE_A_FETCH  0x7
+#define BV_PXP_INIT_MEM_CTRL_SELECT__WFE_B_FETCH  0x8
+#define BV_PXP_INIT_MEM_CTRL_SELECT__RESERVED     0x15
+#define BP_PXP_INIT_MEM_CTRL_RSVD0      16
+#define BM_PXP_INIT_MEM_CTRL_RSVD0 0x07FF0000
+#define BF_PXP_INIT_MEM_CTRL_RSVD0(v)  \
+	(((v) << 16) & BM_PXP_INIT_MEM_CTRL_RSVD0)
+#define BP_PXP_INIT_MEM_CTRL_ADDR      0
+#define BM_PXP_INIT_MEM_CTRL_ADDR 0x0000FFFF
+#define BF_PXP_INIT_MEM_CTRL_ADDR(v)  \
+	(((v) << 0) & BM_PXP_INIT_MEM_CTRL_ADDR)
+
+#define HW_PXP_INIT_MEM_DATA	(0x00000370)
+
+#define BP_PXP_INIT_MEM_DATA_DATA      0
+#define BM_PXP_INIT_MEM_DATA_DATA 0xFFFFFFFF
+#define BF_PXP_INIT_MEM_DATA_DATA(v)   (v)
+
+#define HW_PXP_INIT_MEM_DATA_HIGH	(0x00000380)
+
+#define BP_PXP_INIT_MEM_DATA_HIGH_DATA      0
+#define BM_PXP_INIT_MEM_DATA_HIGH_DATA 0xFFFFFFFF
+#define BF_PXP_INIT_MEM_DATA_HIGH_DATA(v)   (v)
+
+#define HW_PXP_IRQ_MASK	(0x00000390)
+#define HW_PXP_IRQ_MASK_SET	(0x00000394)
+#define HW_PXP_IRQ_MASK_CLR	(0x00000398)
+#define HW_PXP_IRQ_MASK_TOG	(0x0000039c)
+
+#define BM_PXP_IRQ_MASK_COMPRESS_DONE_IRQ_EN 0x80000000
+#define BF_PXP_IRQ_MASK_COMPRESS_DONE_IRQ_EN(v) \
+	(((v) << 31) & BM_PXP_IRQ_MASK_COMPRESS_DONE_IRQ_EN)
+#define BP_PXP_IRQ_MASK_RSVD1      16
+#define BM_PXP_IRQ_MASK_RSVD1 0x7FFF0000
+#define BF_PXP_IRQ_MASK_RSVD1(v)  \
+	(((v) << 16) & BM_PXP_IRQ_MASK_RSVD1)
+#define BM_PXP_IRQ_MASK_WFE_B_STORE_IRQ_EN 0x00008000
+#define BF_PXP_IRQ_MASK_WFE_B_STORE_IRQ_EN(v)  \
+	(((v) << 15) & BM_PXP_IRQ_MASK_WFE_B_STORE_IRQ_EN)
+#define BM_PXP_IRQ_MASK_WFE_A_STORE_IRQ_EN 0x00004000
+#define BF_PXP_IRQ_MASK_WFE_A_STORE_IRQ_EN(v)  \
+	(((v) << 14) & BM_PXP_IRQ_MASK_WFE_A_STORE_IRQ_EN)
+#define BM_PXP_IRQ_MASK_DITHER_STORE_IRQ_EN 0x00002000
+#define BF_PXP_IRQ_MASK_DITHER_STORE_IRQ_EN(v)  \
+	(((v) << 13) & BM_PXP_IRQ_MASK_DITHER_STORE_IRQ_EN)
+#define BM_PXP_IRQ_MASK_FIRST_STORE_IRQ_EN 0x00001000
+#define BF_PXP_IRQ_MASK_FIRST_STORE_IRQ_EN(v)  \
+	(((v) << 12) & BM_PXP_IRQ_MASK_FIRST_STORE_IRQ_EN)
+#define BM_PXP_IRQ_MASK_WFE_B_CH1_STORE_IRQ_EN 0x00000800
+#define BF_PXP_IRQ_MASK_WFE_B_CH1_STORE_IRQ_EN(v)  \
+	(((v) << 11) & BM_PXP_IRQ_MASK_WFE_B_CH1_STORE_IRQ_EN)
+#define BM_PXP_IRQ_MASK_WFE_B_CH0_STORE_IRQ_EN 0x00000400
+#define BF_PXP_IRQ_MASK_WFE_B_CH0_STORE_IRQ_EN(v)  \
+	(((v) << 10) & BM_PXP_IRQ_MASK_WFE_B_CH0_STORE_IRQ_EN)
+#define BM_PXP_IRQ_MASK_WFE_A_CH1_STORE_IRQ_EN 0x00000200
+#define BF_PXP_IRQ_MASK_WFE_A_CH1_STORE_IRQ_EN(v)  \
+	(((v) << 9) & BM_PXP_IRQ_MASK_WFE_A_CH1_STORE_IRQ_EN)
+#define BM_PXP_IRQ_MASK_WFE_A_CH0_STORE_IRQ_EN 0x00000100
+#define BF_PXP_IRQ_MASK_WFE_A_CH0_STORE_IRQ_EN(v)  \
+	(((v) << 8) & BM_PXP_IRQ_MASK_WFE_A_CH0_STORE_IRQ_EN)
+#define BM_PXP_IRQ_MASK_DITHER_CH1_STORE_IRQ_EN 0x00000080
+#define BF_PXP_IRQ_MASK_DITHER_CH1_STORE_IRQ_EN(v)  \
+	(((v) << 7) & BM_PXP_IRQ_MASK_DITHER_CH1_STORE_IRQ_EN)
+#define BM_PXP_IRQ_MASK_DITHER_CH0_STORE_IRQ_EN 0x00000040
+#define BF_PXP_IRQ_MASK_DITHER_CH0_STORE_IRQ_EN(v)  \
+	(((v) << 6) & BM_PXP_IRQ_MASK_DITHER_CH0_STORE_IRQ_EN)
+#define BM_PXP_IRQ_MASK_DITHER_CH1_PREFETCH_IRQ_EN 0x00000020
+#define BF_PXP_IRQ_MASK_DITHER_CH1_PREFETCH_IRQ_EN(v)  \
+	(((v) << 5) & BM_PXP_IRQ_MASK_DITHER_CH1_PREFETCH_IRQ_EN)
+#define BM_PXP_IRQ_MASK_DITHER_CH0_PREFETCH_IRQ_EN 0x00000010
+#define BF_PXP_IRQ_MASK_DITHER_CH0_PREFETCH_IRQ_EN(v)  \
+	(((v) << 4) & BM_PXP_IRQ_MASK_DITHER_CH0_PREFETCH_IRQ_EN)
+#define BM_PXP_IRQ_MASK_FIRST_CH1_STORE_IRQ_EN 0x00000008
+#define BF_PXP_IRQ_MASK_FIRST_CH1_STORE_IRQ_EN(v)  \
+	(((v) << 3) & BM_PXP_IRQ_MASK_FIRST_CH1_STORE_IRQ_EN)
+#define BM_PXP_IRQ_MASK_FIRST_CH0_STORE_IRQ_EN 0x00000004
+#define BF_PXP_IRQ_MASK_FIRST_CH0_STORE_IRQ_EN(v)  \
+	(((v) << 2) & BM_PXP_IRQ_MASK_FIRST_CH0_STORE_IRQ_EN)
+#define BM_PXP_IRQ_MASK_FIRST_CH1_PREFETCH_IRQ_EN 0x00000002
+#define BF_PXP_IRQ_MASK_FIRST_CH1_PREFETCH_IRQ_EN(v)  \
+	(((v) << 1) & BM_PXP_IRQ_MASK_FIRST_CH1_PREFETCH_IRQ_EN)
+#define BM_PXP_IRQ_MASK_FIRST_CH0_PREFETCH_IRQ_EN 0x00000001
+#define BF_PXP_IRQ_MASK_FIRST_CH0_PREFETCH_IRQ_EN(v)  \
+	(((v) << 0) & BM_PXP_IRQ_MASK_FIRST_CH0_PREFETCH_IRQ_EN)
+
+#define HW_PXP_IRQ	(0x000003a0)
+#define HW_PXP_IRQ_SET	(0x000003a4)
+#define HW_PXP_IRQ_CLR	(0x000003a8)
+#define HW_PXP_IRQ_TOG	(0x000003ac)
+
+#define BM_PXP_IRQ_COMPRESS_DONE_IRQ 0x80000000
+#define BF_PXP_IRQ_COMPRESS_DONE_IRQ(v) \
+	(((v) << 31) & BM_PXP_IRQ_COMPRESS_DONE_IRQ)
+#define BP_PXP_IRQ_RSVD1      16
+#define BM_PXP_IRQ_RSVD1 0x7FFF0000
+#define BF_PXP_IRQ_RSVD1(v)  \
+	(((v) << 16) & BM_PXP_IRQ_RSVD1)
+#define BM_PXP_IRQ_WFE_B_STORE_IRQ 0x00008000
+#define BF_PXP_IRQ_WFE_B_STORE_IRQ(v)  \
+	(((v) << 15) & BM_PXP_IRQ_WFE_B_STORE_IRQ)
+#define BM_PXP_IRQ_WFE_A_STORE_IRQ 0x00004000
+#define BF_PXP_IRQ_WFE_A_STORE_IRQ(v)  \
+	(((v) << 14) & BM_PXP_IRQ_WFE_A_STORE_IRQ)
+#define BM_PXP_IRQ_DITHER_STORE_IRQ 0x00002000
+#define BF_PXP_IRQ_DITHER_STORE_IRQ(v)  \
+	(((v) << 13) & BM_PXP_IRQ_DITHER_STORE_IRQ)
+#define BM_PXP_IRQ_FIRST_STORE_IRQ 0x00001000
+#define BF_PXP_IRQ_FIRST_STORE_IRQ(v)  \
+	(((v) << 12) & BM_PXP_IRQ_FIRST_STORE_IRQ)
+#define BM_PXP_IRQ_WFE_B_CH1_STORE_IRQ 0x00000800
+#define BF_PXP_IRQ_WFE_B_CH1_STORE_IRQ(v)  \
+	(((v) << 11) & BM_PXP_IRQ_WFE_B_CH1_STORE_IRQ)
+#define BM_PXP_IRQ_WFE_B_CH0_STORE_IRQ 0x00000400
+#define BF_PXP_IRQ_WFE_B_CH0_STORE_IRQ(v)  \
+	(((v) << 10) & BM_PXP_IRQ_WFE_B_CH0_STORE_IRQ)
+#define BM_PXP_IRQ_WFE_A_CH1_STORE_IRQ 0x00000200
+#define BF_PXP_IRQ_WFE_A_CH1_STORE_IRQ(v)  \
+	(((v) << 9) & BM_PXP_IRQ_WFE_A_CH1_STORE_IRQ)
+#define BM_PXP_IRQ_WFE_A_CH0_STORE_IRQ 0x00000100
+#define BF_PXP_IRQ_WFE_A_CH0_STORE_IRQ(v)  \
+	(((v) << 8) & BM_PXP_IRQ_WFE_A_CH0_STORE_IRQ)
+#define BM_PXP_IRQ_DITHER_CH1_STORE_IRQ 0x00000080
+#define BF_PXP_IRQ_DITHER_CH1_STORE_IRQ(v)  \
+	(((v) << 7) & BM_PXP_IRQ_DITHER_CH1_STORE_IRQ)
+#define BM_PXP_IRQ_DITHER_CH0_STORE_IRQ 0x00000040
+#define BF_PXP_IRQ_DITHER_CH0_STORE_IRQ(v)  \
+	(((v) << 6) & BM_PXP_IRQ_DITHER_CH0_STORE_IRQ)
+#define BM_PXP_IRQ_DITHER_CH1_PREFETCH_IRQ 0x00000020
+#define BF_PXP_IRQ_DITHER_CH1_PREFETCH_IRQ(v)  \
+	(((v) << 5) & BM_PXP_IRQ_DITHER_CH1_PREFETCH_IRQ)
+#define BM_PXP_IRQ_DITHER_CH0_PREFETCH_IRQ 0x00000010
+#define BF_PXP_IRQ_DITHER_CH0_PREFETCH_IRQ(v)  \
+	(((v) << 4) & BM_PXP_IRQ_DITHER_CH0_PREFETCH_IRQ)
+#define BM_PXP_IRQ_FIRST_CH1_STORE_IRQ 0x00000008
+#define BF_PXP_IRQ_FIRST_CH1_STORE_IRQ(v)  \
+	(((v) << 3) & BM_PXP_IRQ_FIRST_CH1_STORE_IRQ)
+#define BM_PXP_IRQ_FIRST_CH0_STORE_IRQ 0x00000004
+#define BF_PXP_IRQ_FIRST_CH0_STORE_IRQ(v)  \
+	(((v) << 2) & BM_PXP_IRQ_FIRST_CH0_STORE_IRQ)
+#define BM_PXP_IRQ_FIRST_CH1_PREFETCH_IRQ 0x00000002
+#define BF_PXP_IRQ_FIRST_CH1_PREFETCH_IRQ(v)  \
+	(((v) << 1) & BM_PXP_IRQ_FIRST_CH1_PREFETCH_IRQ)
+#define BM_PXP_IRQ_FIRST_CH0_PREFETCH_IRQ 0x00000001
+#define BF_PXP_IRQ_FIRST_CH0_PREFETCH_IRQ(v)  \
+	(((v) << 0) & BM_PXP_IRQ_FIRST_CH0_PREFETCH_IRQ)
+
+#define HW_PXP_NEXT	(0x00000400)
+
+#define BP_PXP_NEXT_POINTER      2
+#define BM_PXP_NEXT_POINTER 0xFFFFFFFC
+#define BF_PXP_NEXT_POINTER(v) \
+	(((v) << 2) & BM_PXP_NEXT_POINTER)
+#define BM_PXP_NEXT_RSVD 0x00000002
+#define BF_PXP_NEXT_RSVD(v)  \
+	(((v) << 1) & BM_PXP_NEXT_RSVD)
+#define BM_PXP_NEXT_ENABLED 0x00000001
+#define BF_PXP_NEXT_ENABLED(v)  \
+	(((v) << 0) & BM_PXP_NEXT_ENABLED)
+
+#define HW_PXP_DEBUGCTRL	(0x00000410)
+
+#define BP_PXP_DEBUGCTRL_RSVD      12
+#define BM_PXP_DEBUGCTRL_RSVD 0xFFFFF000
+#define BF_PXP_DEBUGCTRL_RSVD(v) \
+	(((v) << 12) & BM_PXP_DEBUGCTRL_RSVD)
+#define BP_PXP_DEBUGCTRL_LUT_CLR_STAT_CNT      8
+#define BM_PXP_DEBUGCTRL_LUT_CLR_STAT_CNT 0x00000F00
+#define BF_PXP_DEBUGCTRL_LUT_CLR_STAT_CNT(v)  \
+	(((v) << 8) & BM_PXP_DEBUGCTRL_LUT_CLR_STAT_CNT)
+#define BV_PXP_DEBUGCTRL_LUT_CLR_STAT_CNT__NONE     0x0
+#define BV_PXP_DEBUGCTRL_LUT_CLR_STAT_CNT__MISS_CNT 0x1
+#define BV_PXP_DEBUGCTRL_LUT_CLR_STAT_CNT__HIT_CNT  0x2
+#define BV_PXP_DEBUGCTRL_LUT_CLR_STAT_CNT__LAT_CNT  0x4
+#define BV_PXP_DEBUGCTRL_LUT_CLR_STAT_CNT__MAX_LAT  0x8
+#define BP_PXP_DEBUGCTRL_SELECT      0
+#define BM_PXP_DEBUGCTRL_SELECT 0x000000FF
+#define BF_PXP_DEBUGCTRL_SELECT(v)  \
+	(((v) << 0) & BM_PXP_DEBUGCTRL_SELECT)
+#define BV_PXP_DEBUGCTRL_SELECT__NONE	0x0
+#define BV_PXP_DEBUGCTRL_SELECT__CTRL	0x1
+#define BV_PXP_DEBUGCTRL_SELECT__PSBUF       0x2
+#define BV_PXP_DEBUGCTRL_SELECT__PSBAX       0x3
+#define BV_PXP_DEBUGCTRL_SELECT__PSBAY       0x4
+#define BV_PXP_DEBUGCTRL_SELECT__ASBUF       0x5
+#define BV_PXP_DEBUGCTRL_SELECT__ROTATION    0x6
+#define BV_PXP_DEBUGCTRL_SELECT__OUTBUF0     0x7
+#define BV_PXP_DEBUGCTRL_SELECT__OUTBUF1     0x8
+#define BV_PXP_DEBUGCTRL_SELECT__OUTBUF2     0x9
+#define BV_PXP_DEBUGCTRL_SELECT__LUT_STAT    0x10
+#define BV_PXP_DEBUGCTRL_SELECT__LUT_MISS    0x11
+#define BV_PXP_DEBUGCTRL_SELECT__LUT_HIT     0x12
+#define BV_PXP_DEBUGCTRL_SELECT__LUT_LAT     0x13
+#define BV_PXP_DEBUGCTRL_SELECT__LUT_MAX_LAT 0x14
+
+#define HW_PXP_DEBUG	(0x00000420)
+
+#define BP_PXP_DEBUG_DATA      0
+#define BM_PXP_DEBUG_DATA 0xFFFFFFFF
+#define BF_PXP_DEBUG_DATA(v)   (v)
+
+#define HW_PXP_VERSION	(0x00000430)
+
+#define BP_PXP_VERSION_MAJOR      24
+#define BM_PXP_VERSION_MAJOR 0xFF000000
+#define BF_PXP_VERSION_MAJOR(v) \
+	(((v) << 24) & BM_PXP_VERSION_MAJOR)
+#define BP_PXP_VERSION_MINOR      16
+#define BM_PXP_VERSION_MINOR 0x00FF0000
+#define BF_PXP_VERSION_MINOR(v)  \
+	(((v) << 16) & BM_PXP_VERSION_MINOR)
+#define BP_PXP_VERSION_STEP      0
+#define BM_PXP_VERSION_STEP 0x0000FFFF
+#define BF_PXP_VERSION_STEP(v)  \
+	(((v) << 0) & BM_PXP_VERSION_STEP)
+
+#endif /* __IMX_PXP_H__ */
-- 
2.18.0
