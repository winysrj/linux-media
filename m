Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:48651 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726046AbeICRPW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Sep 2018 13:15:22 -0400
Subject: Re: [PATCH 3/3] media: imx-pxp: add i.MX Pixel Pipeline driver
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
References: <20180810151822.18650-1-p.zabel@pengutronix.de>
 <20180810151822.18650-4-p.zabel@pengutronix.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <966eb039-d850-75f0-5a65-56dae142aec5@xs4all.nl>
Date: Mon, 3 Sep 2018 14:55:11 +0200
MIME-Version: 1.0
In-Reply-To: <20180810151822.18650-4-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Apologies for the delay, but the Request API took most of my time.

But I finally got around to it:

On 08/10/2018 05:18 PM, Philipp Zabel wrote:
> Add a V4L2 mem-to-mem scaler/CSC driver for the Pixel Pipeline (PXP)
> version found on i.MX6ULL SoCs. A similar variant is used on i.MX7D.
> 
> Since this driver only uses the legacy pipeline, it should be reasonably
> easy to extend it to work with the older PXP versions found on i.MX6UL,
> i.MX6SX, i.MX6SL, i.MX28, and i.MX23.
> 
> The driver supports scaling and colorspace conversion. There is
> currently no support for rotation, alpha-blending, and the LUTs.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/Kconfig   |    9 +
>  drivers/media/platform/Makefile  |    2 +
>  drivers/media/platform/imx-pxp.c | 1455 ++++++++++++++++++++++++++
>  drivers/media/platform/imx-pxp.h | 1685 ++++++++++++++++++++++++++++++

Missing MAINTAINERS entry.

>  4 files changed, 3151 insertions(+)
>  create mode 100644 drivers/media/platform/imx-pxp.c
>  create mode 100644 drivers/media/platform/imx-pxp.h
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index b25c8d3c1c31..ae1c025c14de 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -181,6 +181,15 @@ config VIDEO_CODA
>  config VIDEO_IMX_VDOA
>  	def_tristate VIDEO_CODA if SOC_IMX6Q || COMPILE_TEST
>  
> +config VIDEO_IMX_PXP
> +	tristate "i.MX Pixel Pipeline (PXP)"
> +	depends on VIDEO_DEV && VIDEO_V4L2 && (ARCH_MXC || COMPILE_TEST)
> +	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_MEM2MEM_DEV
> +	help
> +	  The i.MX Pixel Pipeline is a memory-to-memory engine for scaling,
> +          color space conversion, and rotation.
> +
>  config VIDEO_MEDIATEK_JPEG
>  	tristate "Mediatek JPEG Codec driver"
>  	depends on MTK_IOMMU_V1 || COMPILE_TEST
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index 08640ba87fc2..0c2714c2bb05 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -25,6 +25,8 @@ obj-$(CONFIG_VIDEO_TI_CAL)		+= ti-vpe/
>  obj-$(CONFIG_VIDEO_MX2_EMMAPRP)		+= mx2_emmaprp.o
>  obj-$(CONFIG_VIDEO_CODA)		+= coda/
>  
> +obj-$(CONFIG_VIDEO_IMX_PXP)		+= imx-pxp.o
> +
>  obj-$(CONFIG_VIDEO_SH_VEU)		+= sh_veu.o
>  
>  obj-$(CONFIG_CEC_GPIO)			+= cec-gpio/
> diff --git a/drivers/media/platform/imx-pxp.c b/drivers/media/platform/imx-pxp.c
> new file mode 100644
> index 000000000000..c9e3ef0f92b4
> --- /dev/null
> +++ b/drivers/media/platform/imx-pxp.c
> @@ -0,0 +1,1455 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * i.MX Pixel Pipeline (PXP) mem-to-mem scaler/CSC/rotator driver
> + *
> + * Copyright (c) 2018 Pengutronix, Philipp Zabel
> + *
> + * based on vim2m
> + *
> + * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
> + * Pawel Osciak, <pawel@osciak.com>
> + * Marek Szyprowski, <m.szyprowski@samsung.com>
> + */
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/io.h>
> +#include <linux/iopoll.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +
> +#include <linux/platform_device.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-event.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "imx-pxp.h"
> +
> +static unsigned int debug;
> +module_param(debug, uint, 0644);
> +MODULE_PARM_DESC(debug, "activates debug info");
> +
> +#define MIN_W 8
> +#define MIN_H 8
> +#define MAX_W 4096
> +#define MAX_H 4096
> +#define ALIGN_W 3 /* 8x8 pixel blocks */
> +#define ALIGN_H 3
> +
> +/* Flags that indicate a format can be used for capture/output */
> +#define MEM2MEM_CAPTURE	(1 << 0)
> +#define MEM2MEM_OUTPUT	(1 << 1)
> +
> +#define MEM2MEM_NAME		"pxp"
> +
> +/* Per queue */
> +#define MEM2MEM_DEF_NUM_BUFS	VIDEO_MAX_FRAME
> +/* In bytes, per queue */
> +#define MEM2MEM_VID_MEM_LIMIT	(16 * 1024 * 1024)
> +
> +/* Flags that indicate processing mode */
> +#define MEM2MEM_HFLIP	(1 << 0)
> +#define MEM2MEM_VFLIP	(1 << 1)
> +
> +#define dprintk(dev, fmt, arg...) \
> +	v4l2_dbg(1, debug, &dev->v4l2_dev, "%s: " fmt, __func__, ## arg)
> +
> +struct pxp_fmt {
> +	u32	fourcc;
> +	int	depth;
> +	/* Types the format can be used for */
> +	u32	types;
> +};
> +
> +static struct pxp_fmt formats[] = {
> +	{
> +		.fourcc	= V4L2_PIX_FMT_XBGR32,
> +		.depth	= 32,
> +		/* Both capture and output format */
> +		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
> +	}, {
> +		.fourcc	= V4L2_PIX_FMT_ABGR32,
> +		.depth	= 32,
> +		/* Capture-only format */
> +		.types	= MEM2MEM_CAPTURE,
> +	}, {
> +		.fourcc	= V4L2_PIX_FMT_BGR24,
> +		.depth	= 24,
> +		.types	= MEM2MEM_CAPTURE,
> +	}, {
> +		.fourcc	= V4L2_PIX_FMT_RGB565,
> +		.depth	= 16,
> +		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
> +	}, {
> +		.fourcc	= V4L2_PIX_FMT_RGB555,
> +		.depth	= 16,
> +		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_RGB444,
> +		.depth	= 16,
> +		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_YUV32,
> +		.depth	= 16,
> +		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_UYVY,
> +		.depth	= 16,
> +		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_YUYV,
> +		.depth	= 16,
> +		/* Output-only format */
> +		.types	= MEM2MEM_OUTPUT,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_VYUY,
> +		.depth	= 16,
> +		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_YVYU,
> +		.depth	= 16,
> +		.types	= MEM2MEM_OUTPUT,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_GREY,
> +		.depth	= 8,
> +		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_Y4,
> +		.depth	= 4,
> +		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_NV16,
> +		.depth	= 16,
> +		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_NV12,
> +		.depth	= 12,
> +		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_NV21,
> +		.depth	= 12,
> +		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_NV61,
> +		.depth	= 16,
> +		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_YUV422P,
> +		.depth	= 16,
> +		.types	= MEM2MEM_OUTPUT,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_YUV420,
> +		.depth	= 12,
> +		.types	= MEM2MEM_OUTPUT,
> +	},
> +};
> +
> +#define NUM_FORMATS ARRAY_SIZE(formats)
> +
> +/* Per-queue, driver-specific private data */
> +struct pxp_q_data {
> +	unsigned int		width;
> +	unsigned int		height;
> +	unsigned int		bytesperline;
> +	unsigned int		sizeimage;
> +	unsigned int		sequence;
> +	struct pxp_fmt		*fmt;
> +};
> +
> +enum {
> +	V4L2_M2M_SRC = 0,
> +	V4L2_M2M_DST = 1,
> +};
> +
> +static struct pxp_fmt *find_format(struct v4l2_format *f)
> +{
> +	struct pxp_fmt *fmt;
> +	unsigned int k;
> +
> +	for (k = 0; k < NUM_FORMATS; k++) {
> +		fmt = &formats[k];
> +		if (fmt->fourcc == f->fmt.pix.pixelformat)
> +			break;
> +	}
> +
> +	if (k == NUM_FORMATS)
> +		return NULL;
> +
> +	return &formats[k];
> +}
> +
> +struct pxp_dev {
> +	struct v4l2_device	v4l2_dev;
> +	struct video_device	vfd;
> +
> +	struct clk		*clk;
> +	void __iomem		*mmio;
> +
> +	atomic_t		num_inst;
> +	struct mutex		dev_mutex;
> +	spinlock_t		irqlock;
> +
> +	struct v4l2_m2m_dev	*m2m_dev;
> +};
> +
> +struct pxp_ctx {
> +	struct v4l2_fh		fh;
> +	struct pxp_dev	*dev;
> +
> +	struct v4l2_ctrl_handler hdl;
> +
> +	/* Abort requested by m2m */
> +	int			aborting;
> +
> +	/* Processing mode */
> +	int			mode;
> +	u8			alpha_component;
> +
> +	enum v4l2_colorspace	colorspace;
> +	enum v4l2_ycbcr_encoding ycbcr_enc;
> +	enum v4l2_xfer_func	xfer_func;
> +	enum v4l2_quantization	quant;
> +
> +	/* Source and destination queue data */
> +	struct pxp_q_data   q_data[2];
> +};
> +
> +static inline struct pxp_ctx *file2ctx(struct file *file)
> +{
> +	return container_of(file->private_data, struct pxp_ctx, fh);
> +}
> +
> +static struct pxp_q_data *get_q_data(struct pxp_ctx *ctx,
> +					 enum v4l2_buf_type type)
> +{
> +	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +		return &ctx->q_data[V4L2_M2M_SRC];
> +	else
> +		return &ctx->q_data[V4L2_M2M_DST];
> +}
> +
> +static u32 pxp_v4l2_pix_fmt_to_ps_format(u32 v4l2_pix_fmt)
> +{
> +	switch (v4l2_pix_fmt) {
> +	case V4L2_PIX_FMT_XBGR32:  return BV_PXP_PS_CTRL_FORMAT__RGB888;
> +	case V4L2_PIX_FMT_RGB555:  return BV_PXP_PS_CTRL_FORMAT__RGB555;
> +	case V4L2_PIX_FMT_RGB444:  return BV_PXP_PS_CTRL_FORMAT__RGB444;
> +	case V4L2_PIX_FMT_RGB565:  return BV_PXP_PS_CTRL_FORMAT__RGB565;
> +	case V4L2_PIX_FMT_YUV32:   return BV_PXP_PS_CTRL_FORMAT__YUV1P444;
> +	case V4L2_PIX_FMT_UYVY:    return BV_PXP_PS_CTRL_FORMAT__UYVY1P422;
> +	case V4L2_PIX_FMT_YUYV:    return BM_PXP_PS_CTRL_WB_SWAP |
> +					  BV_PXP_PS_CTRL_FORMAT__UYVY1P422;
> +	case V4L2_PIX_FMT_VYUY:    return BV_PXP_PS_CTRL_FORMAT__VYUY1P422;
> +	case V4L2_PIX_FMT_YVYU:    return BM_PXP_PS_CTRL_WB_SWAP |
> +					  BV_PXP_PS_CTRL_FORMAT__VYUY1P422;
> +	case V4L2_PIX_FMT_GREY:    return BV_PXP_PS_CTRL_FORMAT__Y8;
> +	default:
> +	case V4L2_PIX_FMT_Y4:      return BV_PXP_PS_CTRL_FORMAT__Y4;
> +	case V4L2_PIX_FMT_NV16:    return BV_PXP_PS_CTRL_FORMAT__YUV2P422;
> +	case V4L2_PIX_FMT_NV12:    return BV_PXP_PS_CTRL_FORMAT__YUV2P420;
> +	case V4L2_PIX_FMT_NV21:    return BV_PXP_PS_CTRL_FORMAT__YVU2P420;
> +	case V4L2_PIX_FMT_NV61:    return BV_PXP_PS_CTRL_FORMAT__YVU2P422;
> +	case V4L2_PIX_FMT_YUV422P: return BV_PXP_PS_CTRL_FORMAT__YUV422;
> +	case V4L2_PIX_FMT_YUV420:  return BV_PXP_PS_CTRL_FORMAT__YUV420;
> +	}
> +}
> +
> +static u32 pxp_v4l2_pix_fmt_to_out_format(u32 v4l2_pix_fmt)
> +{
> +	switch (v4l2_pix_fmt) {
> +	case V4L2_PIX_FMT_XBGR32:   return BV_PXP_OUT_CTRL_FORMAT__RGB888;
> +	case V4L2_PIX_FMT_ABGR32:   return BV_PXP_OUT_CTRL_FORMAT__ARGB8888;
> +	case V4L2_PIX_FMT_BGR24:    return BV_PXP_OUT_CTRL_FORMAT__RGB888P;
> +	/* Missing V4L2 pixel formats for ARGB1555 and ARGB4444 */
> +	case V4L2_PIX_FMT_RGB555:   return BV_PXP_OUT_CTRL_FORMAT__RGB555;
> +	case V4L2_PIX_FMT_RGB444:   return BV_PXP_OUT_CTRL_FORMAT__RGB444;
> +	case V4L2_PIX_FMT_RGB565:   return BV_PXP_OUT_CTRL_FORMAT__RGB565;
> +	case V4L2_PIX_FMT_YUV32:    return BV_PXP_OUT_CTRL_FORMAT__YUV1P444;
> +	case V4L2_PIX_FMT_UYVY:     return BV_PXP_OUT_CTRL_FORMAT__UYVY1P422;
> +	case V4L2_PIX_FMT_VYUY:     return BV_PXP_OUT_CTRL_FORMAT__VYUY1P422;
> +	case V4L2_PIX_FMT_GREY:     return BV_PXP_OUT_CTRL_FORMAT__Y8;
> +	default:
> +	case V4L2_PIX_FMT_Y4:       return BV_PXP_OUT_CTRL_FORMAT__Y4;
> +	case V4L2_PIX_FMT_NV16:     return BV_PXP_OUT_CTRL_FORMAT__YUV2P422;
> +	case V4L2_PIX_FMT_NV12:     return BV_PXP_OUT_CTRL_FORMAT__YUV2P420;
> +	case V4L2_PIX_FMT_NV61:     return BV_PXP_OUT_CTRL_FORMAT__YVU2P422;
> +	case V4L2_PIX_FMT_NV21:     return BV_PXP_OUT_CTRL_FORMAT__YVU2P420;
> +	}
> +}
> +
> +static bool pxp_v4l2_pix_fmt_is_yuv(u32 v4l2_pix_fmt)
> +{
> +	switch (v4l2_pix_fmt) {
> +	case V4L2_PIX_FMT_YUV32:
> +	case V4L2_PIX_FMT_UYVY:
> +	case V4L2_PIX_FMT_YUYV:
> +	case V4L2_PIX_FMT_VYUY:
> +	case V4L2_PIX_FMT_YVYU:
> +	case V4L2_PIX_FMT_NV16:
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV61:
> +	case V4L2_PIX_FMT_NV21:
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_YUV422P:
> +	case V4L2_PIX_FMT_GREY:
> +	case V4L2_PIX_FMT_Y4:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
> +static void pxp_setup_csc(struct pxp_ctx *ctx)
> +{
> +	struct pxp_dev *dev = ctx->dev;
> +
> +	if (pxp_v4l2_pix_fmt_is_yuv(ctx->q_data[V4L2_M2M_SRC].fmt->fourcc) &&
> +	    !pxp_v4l2_pix_fmt_is_yuv(ctx->q_data[V4L2_M2M_DST].fmt->fourcc)) {
> +		/*
> +		 * CSC1 YUV/YCbCr to RGB conversion is implemented as follows:
> +		 *
> +		 * |R|   |C0 0  C1|   |Y  + Yoffset |
> +		 * |G| = |C0 C3 C2| * |Cb + UVoffset|
> +		 * |B|   |C0 C4 0 |   |Cr + UVoffset|
> +		 *
> +		 * Results are clamped to 0..255.
> +		 *
> +		 * BT.601 limited range:
> +		 *
> +		 * |R|   |1.1644  0       1.5960|   |Y  - 16 |
> +		 * |G| = |1.1644 -0.3917 -0.8129| * |Cb - 128|
> +		 * |B|   |1.1644  2.0172  0     |   |Cr - 128|
> +		 */
> +		static const u32 csc1_coef_bt601_lim[3] = {
> +			BM_PXP_CSC1_COEF0_YCBCR_MODE |
> +			BF_PXP_CSC1_COEF0_C0(0x12a) |	/*  1.1641 */
> +			BF_PXP_CSC1_COEF0_UV_OFFSET(-128) |
> +			BF_PXP_CSC1_COEF0_Y_OFFSET(-16),
> +			BF_PXP_CSC1_COEF1_C1(0x198) |	/*  1.5938 */
> +			BF_PXP_CSC1_COEF1_C4(0x204),	/*  2.0156 */
> +			BF_PXP_CSC1_COEF2_C2(0x730) |	/* -0.8125 */
> +			BF_PXP_CSC1_COEF2_C3(0x79c),	/* -0.3906 */
> +		};
> +		/*
> +		 * BT.601 full range:
> +		 *
> +		 * |R|   |1  0       1.4020|   |Y  + 0  |
> +		 * |G| = |1 -0.3441 -0.7141| * |Cb - 128|
> +		 * |B|   |1  1.7720  0     |   |Cr - 128|
> +		 */
> +		static const u32 csc1_coef_bt601_full[3] = {
> +			BM_PXP_CSC1_COEF0_YCBCR_MODE |
> +			BF_PXP_CSC1_COEF0_C0(0x100) |	/*  1      */
> +			BF_PXP_CSC1_COEF0_UV_OFFSET(-128) |
> +			BF_PXP_CSC1_COEF0_Y_OFFSET(0),
> +			BF_PXP_CSC1_COEF1_C1(0x166) |	/*  1.3984 */
> +			BF_PXP_CSC1_COEF1_C4(0x1c5),	/*  1.7695 */
> +			BF_PXP_CSC1_COEF2_C2(0x74a) |	/* -0.7109 */
> +			BF_PXP_CSC1_COEF2_C3(0x7a8),	/* -0.3438 */
> +		};
> +		const u32 *csc1_coef;
> +
> +		if (ctx->ycbcr_enc == V4L2_YCBCR_ENC_601 &&
> +		    ctx->quant == V4L2_QUANTIZATION_FULL_RANGE)
> +			csc1_coef = csc1_coef_bt601_full;
> +		else
> +			csc1_coef = csc1_coef_bt601_lim;

This is weird: setting ycbcr_enc to V4L2_YCBCR_ENC_709 would result in
limited range BT601.

> +
> +		writel(csc1_coef[0], dev->mmio + HW_PXP_CSC1_COEF0);
> +		writel(csc1_coef[1], dev->mmio + HW_PXP_CSC1_COEF1);
> +		writel(csc1_coef[2], dev->mmio + HW_PXP_CSC1_COEF2);

No support for Rec. 709?

> +	} else {
> +		writel(BM_PXP_CSC1_COEF0_BYPASS, dev->mmio + HW_PXP_CSC1_COEF0);
> +	}
> +
> +	if (!pxp_v4l2_pix_fmt_is_yuv(ctx->q_data[V4L2_M2M_SRC].fmt->fourcc) &&
> +	    pxp_v4l2_pix_fmt_is_yuv(ctx->q_data[V4L2_M2M_DST].fmt->fourcc)) {
> +		/*
> +		 * CSC2 RGB to YUV/YCbCr conversion is implemented as follows:
> +		 *
> +		 * |Y |   |A1 A2 A3|   |R|   |D1|
> +		 * |Cb| = |B1 B2 B3| * |G| + |D2|
> +		 * |Cr|   |C1 C2 C3|   |B|   |D3|
> +		 *
> +		 * Results are clamped to 0..255.
> +		 *
> +		 * BT.601 limited range:
> +		 *
> +		 * |Y |   | 0.3482  0.6682  0.1298|   |R|   |16 |
> +		 * |Cb| = |-0.1964 -0.3771  0.5692| * |G| + |128|
> +		 * |Cr|   | 0.5822 -0.4766 -0.0926|   |B|   |128|
> +		 */
> +		static const u32 csc2_coef_bt601_lim[6] = {
> +			BF_PXP_CSC2_COEF0_A2(0xab) |	/*  0.6680 */
> +			BF_PXP_CSC2_COEF0_A1(0x59),	/*  0.3477 */
> +			BF_PXP_CSC2_COEF1_B1(0x7ce) |	/* -0.1953 */
> +			BF_PXP_CSC2_COEF1_A3(0x21),	/*  0.1289 */
> +			BF_PXP_CSC2_COEF2_B3(0x92) |	/*  0.5703 */
> +			BF_PXP_CSC2_COEF2_B2(0x79f),	/* -0.3789 */
> +			BF_PXP_CSC2_COEF3_C2(0x786) |	/* -0.4766 */
> +			BF_PXP_CSC2_COEF3_C1(0x95),	/*  0.5820 */
> +			BF_PXP_CSC2_COEF4_D1(16) |
> +			BF_PXP_CSC2_COEF4_C3(0x7e8),	/* -0.0938 */
> +			BF_PXP_CSC2_COEF5_D3(128) |
> +			BF_PXP_CSC2_COEF5_D2(128),
> +		};
> +
> +		/*
> +		 * BT.601 full range:
> +		 *
> +		 * |Y |   | 0.299   0.587   0.114 |   |R|   |0  |
> +		 * |Cb| = |-0.1687 -0.3313  0.5   | * |G| + |128|
> +		 * |Cr|   | 0.5    -0.4187 -0.0813|   |B|   |128|
> +		 */
> +		static const u32 csc2_coef_bt601_full[6] = {
> +			BF_PXP_CSC2_COEF0_A2(0x96) |	/*  0.5859 */
> +			BF_PXP_CSC2_COEF0_A1(0x4d),	/*  0.3008 */
> +			BF_PXP_CSC2_COEF1_B1(0x7d5) |	/* -0.1680 */
> +			BF_PXP_CSC2_COEF1_A3(0x1d),	/*  0.1133 */
> +			BF_PXP_CSC2_COEF2_B3(0x80) |	/*  0.5    */
> +			BF_PXP_CSC2_COEF2_B2(0x7ab),	/* -0.3320 */
> +			BF_PXP_CSC2_COEF3_C2(0x795) |	/* -0.4180 */
> +			BF_PXP_CSC2_COEF3_C1(0x80),	/*  0.5    */
> +			BF_PXP_CSC2_COEF4_D1(0) |
> +			BF_PXP_CSC2_COEF4_C3(0x7eb),	/* -0.0820 */
> +			BF_PXP_CSC2_COEF5_D3(128) |
> +			BF_PXP_CSC2_COEF5_D2(128),
> +		};
> +		const u32 *csc2_coef;
> +		u32 csc2_ctrl;
> +
> +		if (ctx->ycbcr_enc == V4L2_YCBCR_ENC_601 &&
> +		    ctx->quant == V4L2_QUANTIZATION_FULL_RANGE) {

This makes no sense. ctx->ycbcr_enc and ctx->quant refer to the output queue,
i.e. the RGB side. ycbcr_enc is ignored for RGB and quant is in practice always
full range. While you can have limited range RGB as well, that's not however
what you are trying to implement here.

The problem is that you cannot at the moment specify what ycbcr_enc etc.
format you want for the capture queue. See below for a link to an RFC to add
support for this.

> +			csc2_coef = csc2_coef_bt601_full;
> +			csc2_ctrl = BV_PXP_CSC2_CTRL_CSC_MODE__RGB2YUV <<
> +				    BP_PXP_CSC2_CTRL_CSC_MODE;
> +		} else {
> +			csc2_coef = csc2_coef_bt601_lim;
> +			csc2_ctrl = BV_PXP_CSC2_CTRL_CSC_MODE__RGB2YCbCr <<
> +				    BP_PXP_CSC2_CTRL_CSC_MODE;
> +		}
> +
> +		writel(csc2_ctrl, dev->mmio + HW_PXP_CSC2_CTRL);
> +		writel(csc2_coef[0], dev->mmio + HW_PXP_CSC2_COEF0);
> +		writel(csc2_coef[1], dev->mmio + HW_PXP_CSC2_COEF1);
> +		writel(csc2_coef[2], dev->mmio + HW_PXP_CSC2_COEF2);
> +		writel(csc2_coef[3], dev->mmio + HW_PXP_CSC2_COEF3);
> +		writel(csc2_coef[4], dev->mmio + HW_PXP_CSC2_COEF4);
> +		writel(csc2_coef[5], dev->mmio + HW_PXP_CSC2_COEF5);
> +	} else {
> +		writel(BM_PXP_CSC2_CTRL_BYPASS, dev->mmio + HW_PXP_CSC2_CTRL);
> +	}
> +}
> +
> +static int pxp_start(struct pxp_ctx *ctx, struct vb2_v4l2_buffer *in_vb,
> +		     struct vb2_v4l2_buffer *out_vb)
> +{
> +	struct pxp_dev *dev = ctx->dev;
> +	struct pxp_q_data *q_data;
> +	u32 src_width, src_height, src_stride, src_fourcc;
> +	u32 dst_width, dst_height, dst_stride, dst_fourcc;
> +	dma_addr_t p_in, p_out;
> +	u32 ctrl, out_ctrl, out_buf, out_buf2, out_pitch, out_lrc, out_ps_ulc;
> +	u32 out_ps_lrc;
> +	u32 ps_ctrl, ps_buf, ps_ubuf, ps_vbuf, ps_pitch, ps_scale, ps_offset;
> +	u32 as_ulc, as_lrc;
> +	u32 y_size;
> +	u32 decx, decy, xscale, yscale;
> +
> +	q_data = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +
> +	src_width = ctx->q_data[V4L2_M2M_SRC].width;
> +	dst_width = ctx->q_data[V4L2_M2M_DST].width;
> +	src_height = ctx->q_data[V4L2_M2M_SRC].height;
> +	dst_height = ctx->q_data[V4L2_M2M_DST].height;
> +	src_stride = ctx->q_data[V4L2_M2M_SRC].bytesperline;
> +	dst_stride = ctx->q_data[V4L2_M2M_DST].bytesperline;
> +	src_fourcc = ctx->q_data[V4L2_M2M_SRC].fmt->fourcc;
> +	dst_fourcc = ctx->q_data[V4L2_M2M_DST].fmt->fourcc;
> +
> +	p_in = vb2_dma_contig_plane_dma_addr(&in_vb->vb2_buf, 0);
> +	p_out = vb2_dma_contig_plane_dma_addr(&out_vb->vb2_buf, 0);
> +
> +	if (!p_in || !p_out) {
> +		v4l2_err(&dev->v4l2_dev,
> +			 "Acquiring DMA addresses of buffers failed\n");
> +		return -EFAULT;
> +	}
> +
> +	out_vb->sequence =
> +		get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE)->sequence++;
> +	in_vb->sequence = q_data->sequence++;
> +	out_vb->vb2_buf.timestamp = in_vb->vb2_buf.timestamp;
> +
> +	if (in_vb->flags & V4L2_BUF_FLAG_TIMECODE)
> +		out_vb->timecode = in_vb->timecode;
> +	out_vb->field = in_vb->field;
> +	out_vb->flags = in_vb->flags &
> +		(V4L2_BUF_FLAG_TIMECODE |
> +		 V4L2_BUF_FLAG_KEYFRAME |
> +		 V4L2_BUF_FLAG_PFRAME |
> +		 V4L2_BUF_FLAG_BFRAME |
> +		 V4L2_BUF_FLAG_TSTAMP_SRC_MASK);
> +
> +	/* Rotation disabled, 8x8 block size */
> +	ctrl = BF_PXP_CTRL_VFLIP0(!!(ctx->mode & MEM2MEM_VFLIP)) |
> +	       BF_PXP_CTRL_HFLIP0(!!(ctx->mode & MEM2MEM_HFLIP));
> +	/* Always write alpha value as V4L2_CID_ALPHA_COMPONENT */
> +	out_ctrl = BF_PXP_OUT_CTRL_ALPHA(ctx->alpha_component) |
> +		   BF_PXP_OUT_CTRL_ALPHA_OUTPUT(1) |
> +		   pxp_v4l2_pix_fmt_to_out_format(dst_fourcc);
> +	out_buf = p_out;
> +	switch (dst_fourcc) {
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV21:
> +	case V4L2_PIX_FMT_NV16:
> +	case V4L2_PIX_FMT_NV61:
> +		out_buf2 = out_buf + dst_stride * dst_height;
> +		break;
> +	default:
> +		out_buf2 = 0;
> +	}
> +
> +	out_pitch = BF_PXP_OUT_PITCH_PITCH(dst_stride);
> +	out_lrc = BF_PXP_OUT_LRC_X(dst_width - 1) |
> +		  BF_PXP_OUT_LRC_Y(dst_height - 1);
> +	/* PS covers whole output */
> +	out_ps_ulc = BF_PXP_OUT_PS_ULC_X(0) | BF_PXP_OUT_PS_ULC_Y(0);
> +	out_ps_lrc = BF_PXP_OUT_PS_LRC_X(dst_width - 1) |
> +		     BF_PXP_OUT_PS_LRC_Y(dst_height - 1);
> +	/* no AS */
> +	as_ulc = BF_PXP_OUT_AS_ULC_X(1) | BF_PXP_OUT_AS_ULC_Y(1);
> +	as_lrc = BF_PXP_OUT_AS_LRC_X(0) | BF_PXP_OUT_AS_LRC_Y(0);
> +
> +	decx = (src_width <= dst_width) ? 0 : ilog2(src_width / dst_width);
> +	decy = (src_height <= dst_height) ? 0 : ilog2(src_height / dst_height);
> +	ps_ctrl = BF_PXP_PS_CTRL_DECX(decx) | BF_PXP_PS_CTRL_DECY(decy) |
> +		  pxp_v4l2_pix_fmt_to_ps_format(src_fourcc);
> +	ps_buf = p_in;
> +	y_size = src_stride * src_height;
> +	switch (src_fourcc) {
> +	case V4L2_PIX_FMT_YUV420:
> +		ps_ubuf = ps_buf + y_size;
> +		ps_vbuf = ps_ubuf + y_size / 4;
> +		break;
> +	case V4L2_PIX_FMT_YUV422P:
> +		ps_ubuf = ps_buf + y_size;
> +		ps_vbuf = ps_ubuf + y_size / 2;
> +		break;
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV21:
> +	case V4L2_PIX_FMT_NV16:
> +	case V4L2_PIX_FMT_NV61:
> +		ps_ubuf = ps_buf + y_size;
> +		ps_vbuf = 0;
> +		break;
> +	case V4L2_PIX_FMT_GREY:
> +	case V4L2_PIX_FMT_Y4:
> +		ps_ubuf = 0;
> +		/* In grayscale mode, ps_vbuf contents are reused as CbCr */
> +		ps_vbuf = 0x8080;
> +		break;
> +	default:
> +		ps_ubuf = 0;
> +		ps_vbuf = 0;
> +		break;
> +	}
> +	ps_pitch = BF_PXP_PS_PITCH_PITCH(src_stride);
> +	if (decx) {
> +		xscale = (src_width >> decx) * 0x1000 / dst_width;
> +	} else {
> +		switch (src_fourcc) {
> +		case V4L2_PIX_FMT_UYVY:
> +		case V4L2_PIX_FMT_YUYV:
> +		case V4L2_PIX_FMT_VYUY:
> +		case V4L2_PIX_FMT_YVYU:
> +		case V4L2_PIX_FMT_NV16:
> +		case V4L2_PIX_FMT_NV12:
> +		case V4L2_PIX_FMT_NV21:
> +		case V4L2_PIX_FMT_NV61:
> +		case V4L2_PIX_FMT_YUV422P:
> +		case V4L2_PIX_FMT_YUV420:
> +			/*
> +			 * This avoids sampling past the right edge for
> +			 * horizontally chroma subsampled formats.
> +			 */
> +			xscale = (src_width - 2) * 0x1000 / (dst_width - 1);
> +			break;
> +		default:
> +			xscale = (src_width - 1) * 0x1000 / (dst_width - 1);
> +			break;
> +		}
> +	}
> +	if (decy)
> +		yscale = (src_height >> decy) * 0x1000 / dst_height;
> +	else
> +		yscale = (src_height - 1) * 0x1000 / (dst_height - 1);
> +	ps_scale = BF_PXP_PS_SCALE_YSCALE(yscale) |
> +		   BF_PXP_PS_SCALE_XSCALE(xscale);
> +	ps_offset = BF_PXP_PS_OFFSET_YOFFSET(0) | BF_PXP_PS_OFFSET_XOFFSET(0);
> +
> +	writel(ctrl, dev->mmio + HW_PXP_CTRL);
> +	/* skip STAT */
> +	writel(out_ctrl, dev->mmio + HW_PXP_OUT_CTRL);
> +	writel(out_buf, dev->mmio + HW_PXP_OUT_BUF);
> +	writel(out_buf2, dev->mmio + HW_PXP_OUT_BUF2);
> +	writel(out_pitch, dev->mmio + HW_PXP_OUT_PITCH);
> +	writel(out_lrc, dev->mmio + HW_PXP_OUT_LRC);
> +	writel(out_ps_ulc, dev->mmio + HW_PXP_OUT_PS_ULC);
> +	writel(out_ps_lrc, dev->mmio + HW_PXP_OUT_PS_LRC);
> +	writel(as_ulc, dev->mmio + HW_PXP_OUT_AS_ULC);
> +	writel(as_lrc, dev->mmio + HW_PXP_OUT_AS_LRC);
> +	writel(ps_ctrl, dev->mmio + HW_PXP_PS_CTRL);
> +	writel(ps_buf, dev->mmio + HW_PXP_PS_BUF);
> +	writel(ps_ubuf, dev->mmio + HW_PXP_PS_UBUF);
> +	writel(ps_vbuf, dev->mmio + HW_PXP_PS_VBUF);
> +	writel(ps_pitch, dev->mmio + HW_PXP_PS_PITCH);
> +	writel(0x00ffffff, dev->mmio + HW_PXP_PS_BACKGROUND_0);
> +	writel(ps_scale, dev->mmio + HW_PXP_PS_SCALE);
> +	writel(ps_offset, dev->mmio + HW_PXP_PS_OFFSET);
> +	/* disable processed surface color keying */
> +	writel(0x00ffffff, dev->mmio + HW_PXP_PS_CLRKEYLOW_0);
> +	writel(0x00000000, dev->mmio + HW_PXP_PS_CLRKEYHIGH_0);
> +
> +	/* disable alpha surface color keying */
> +	writel(0x00ffffff, dev->mmio + HW_PXP_AS_CLRKEYLOW_0);
> +	writel(0x00000000, dev->mmio + HW_PXP_AS_CLRKEYHIGH_0);
> +
> +	/* setup CSC */
> +	pxp_setup_csc(ctx);
> +
> +	/* bypass LUT */
> +	writel(BM_PXP_LUT_CTRL_BYPASS, dev->mmio + HW_PXP_LUT_CTRL);
> +
> +	writel(BF_PXP_DATA_PATH_CTRL0_MUX15_SEL(0)|
> +	       BF_PXP_DATA_PATH_CTRL0_MUX14_SEL(1)|
> +	       BF_PXP_DATA_PATH_CTRL0_MUX13_SEL(0)|
> +	       BF_PXP_DATA_PATH_CTRL0_MUX12_SEL(0)|
> +	       BF_PXP_DATA_PATH_CTRL0_MUX11_SEL(0)|
> +	       BF_PXP_DATA_PATH_CTRL0_MUX10_SEL(0)|
> +	       BF_PXP_DATA_PATH_CTRL0_MUX9_SEL(1)|
> +	       BF_PXP_DATA_PATH_CTRL0_MUX8_SEL(0)|
> +	       BF_PXP_DATA_PATH_CTRL0_MUX7_SEL(0)|
> +	       BF_PXP_DATA_PATH_CTRL0_MUX6_SEL(0)|
> +	       BF_PXP_DATA_PATH_CTRL0_MUX5_SEL(0)|
> +	       BF_PXP_DATA_PATH_CTRL0_MUX4_SEL(0)|
> +	       BF_PXP_DATA_PATH_CTRL0_MUX3_SEL(0)|
> +	       BF_PXP_DATA_PATH_CTRL0_MUX2_SEL(0)|
> +	       BF_PXP_DATA_PATH_CTRL0_MUX1_SEL(0)|
> +	       BF_PXP_DATA_PATH_CTRL0_MUX0_SEL(0),
> +	       dev->mmio + HW_PXP_DATA_PATH_CTRL0);
> +	writel(BF_PXP_DATA_PATH_CTRL1_MUX17_SEL(1) |
> +	       BF_PXP_DATA_PATH_CTRL1_MUX16_SEL(1),
> +	       dev->mmio + HW_PXP_DATA_PATH_CTRL1);
> +
> +	writel(0xffff, dev->mmio + HW_PXP_IRQ_MASK);
> +
> +	/* ungate, enable PS/AS/OUT and PXP operation */
> +	writel(BM_PXP_CTRL_IRQ_ENABLE, dev->mmio + HW_PXP_CTRL_SET);
> +	writel(BM_PXP_CTRL_ENABLE | BM_PXP_CTRL_ENABLE_CSC2 |
> +	       BM_PXP_CTRL_ENABLE_LUT | BM_PXP_CTRL_ENABLE_ROTATE0 |
> +	       BM_PXP_CTRL_ENABLE_PS_AS_OUT, dev->mmio + HW_PXP_CTRL_SET);
> +
> +	return 0;
> +}
> +
> +static void pxp_job_finish(struct pxp_dev *dev)
> +{
> +	struct pxp_ctx *curr_ctx;
> +	struct vb2_v4l2_buffer *src_vb, *dst_vb;
> +	unsigned long flags;
> +
> +	curr_ctx = v4l2_m2m_get_curr_priv(dev->m2m_dev);
> +
> +	if (curr_ctx == NULL) {
> +		pr_err("Instance released before the end of transaction\n");
> +		return;
> +	}
> +
> +	src_vb = v4l2_m2m_src_buf_remove(curr_ctx->fh.m2m_ctx);
> +	dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->fh.m2m_ctx);
> +
> +	spin_lock_irqsave(&dev->irqlock, flags);
> +	v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
> +	v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
> +	spin_unlock_irqrestore(&dev->irqlock, flags);
> +
> +	dprintk(curr_ctx->dev, "Finishing transaction\n");
> +	v4l2_m2m_job_finish(dev->m2m_dev, curr_ctx->fh.m2m_ctx);
> +}
> +
> +
> +/*
> + * mem2mem callbacks
> + */
> +static void pxp_device_run(void *priv)
> +{
> +	struct pxp_ctx *ctx = priv;
> +	struct vb2_v4l2_buffer *src_buf, *dst_buf;
> +
> +	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
> +	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
> +
> +	pxp_start(ctx, src_buf, dst_buf);
> +}
> +
> +static int pxp_job_ready(void *priv)
> +{
> +	struct pxp_ctx *ctx = priv;
> +
> +	if (v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx) < 1 ||
> +	    v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx) < 1) {
> +		dprintk(ctx->dev, "Not enough buffers available\n");
> +		return 0;
> +	}
> +
> +	return 1;
> +}
> +
> +static void pxp_job_abort(void *priv)
> +{
> +	struct pxp_ctx *ctx = priv;
> +
> +	/* Will cancel the transaction in the next interrupt handler */
> +	ctx->aborting = 1;
> +}
> +
> +/*
> + * interrupt handler
> + */
> +static irqreturn_t pxp_irq_handler(int irq, void *dev_id)
> +{
> +	struct pxp_dev *dev = dev_id;
> +	u32 stat;
> +
> +	stat = readl(dev->mmio + HW_PXP_STAT);
> +
> +	if (stat & BM_PXP_STAT_IRQ0) {
> +		/* we expect x = 0, y = height, irq0 = 1 */
> +		if (stat & ~(BM_PXP_STAT_BLOCKX | BM_PXP_STAT_BLOCKY |
> +			     BM_PXP_STAT_IRQ0))
> +			dprintk(dev, "%s: stat = 0x%08x\n", __func__, stat);
> +		writel(BM_PXP_STAT_IRQ0, dev->mmio + HW_PXP_STAT_CLR);
> +
> +		pxp_job_finish(dev);
> +	} else {
> +		u32 irq = readl(dev->mmio + HW_PXP_IRQ);
> +
> +		dprintk(dev, "%s: stat = 0x%08x\n", __func__, stat);
> +		dprintk(dev, "%s: irq = 0x%08x\n", __func__, irq);
> +
> +		writel(irq, dev->mmio + HW_PXP_IRQ_CLR);
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/*
> + * video ioctls
> + */
> +static int vidioc_querycap(struct file *file, void *priv,
> +			   struct v4l2_capability *cap)
> +{
> +	strncpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver) - 1);
> +	strncpy(cap->card, MEM2MEM_NAME, sizeof(cap->card) - 1);

Use strlcpy.

> +	snprintf(cap->bus_info, sizeof(cap->bus_info),
> +			"platform:%s", MEM2MEM_NAME);
> +	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;

Please set the device_caps field of video_device, and then you can drop
these two lines since the core will fill this in for you.

> +	return 0;
> +}
> +
> +static int enum_fmt(struct v4l2_fmtdesc *f, u32 type)
> +{
> +	int i, num;
> +	struct pxp_fmt *fmt;
> +
> +	num = 0;
> +
> +	for (i = 0; i < NUM_FORMATS; ++i) {
> +		if (formats[i].types & type) {
> +			/* index-th format of type type found ? */
> +			if (num == f->index)
> +				break;
> +			/*
> +			 * Correct type but haven't reached our index yet,
> +			 * just increment per-type index
> +			 */
> +			++num;
> +		}
> +	}
> +
> +	if (i < NUM_FORMATS) {
> +		/* Format found */
> +		fmt = &formats[i];
> +		f->pixelformat = fmt->fourcc;
> +		return 0;
> +	}
> +
> +	/* Format not found */
> +	return -EINVAL;
> +}
> +
> +static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
> +				   struct v4l2_fmtdesc *f)
> +{
> +	return enum_fmt(f, MEM2MEM_CAPTURE);
> +}
> +
> +static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
> +				   struct v4l2_fmtdesc *f)
> +{
> +	return enum_fmt(f, MEM2MEM_OUTPUT);
> +}
> +
> +static int vidioc_g_fmt(struct pxp_ctx *ctx, struct v4l2_format *f)
> +{
> +	struct vb2_queue *vq;
> +	struct pxp_q_data *q_data;
> +
> +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> +	if (!vq)
> +		return -EINVAL;
> +
> +	q_data = get_q_data(ctx, f->type);
> +
> +	f->fmt.pix.width	= q_data->width;
> +	f->fmt.pix.height	= q_data->height;
> +	f->fmt.pix.field	= V4L2_FIELD_NONE;
> +	f->fmt.pix.pixelformat	= q_data->fmt->fourcc;
> +	f->fmt.pix.bytesperline	= q_data->bytesperline;
> +	f->fmt.pix.sizeimage	= q_data->sizeimage;
> +	f->fmt.pix.colorspace	= ctx->colorspace;
> +	f->fmt.pix.xfer_func	= ctx->xfer_func;
> +	f->fmt.pix.ycbcr_enc	= ctx->ycbcr_enc;
> +	f->fmt.pix.quantization	= ctx->quant;

Since you do colorspace conversion, these can't be the same for
both output and capture.

colorspace and xfer_func will be the same (those are not converted),
but ycbcr_enc should be set to 0 for RGB and quantization range
will be different as well (either set to 0 for capture, or set
to FULL for RGB capture and LIMITED for YUV).

Please note that it is not possible at the moment to request
different values for these four field when capturing: they are currently
set by the driver, and userspace cann't request something else.

There is an old RFC to add support for this:

https://patchwork.linuxtv.org/patch/28847/

This driver might be a good opportunity to resurrect this RFC patch.

> +
> +	return 0;
> +}
> +
> +static int vidioc_g_fmt_vid_out(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	return vidioc_g_fmt(file2ctx(file), f);
> +}
> +
> +static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	return vidioc_g_fmt(file2ctx(file), f);
> +}
> +
> +static inline u32 pxp_bytesperline(struct pxp_fmt *fmt, u32 width)
> +{
> +	switch (fmt->fourcc) {
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV21:
> +	case V4L2_PIX_FMT_YUV422P:
> +	case V4L2_PIX_FMT_NV16:
> +	case V4L2_PIX_FMT_NV61:
> +		return width;
> +	default:
> +		return (width * fmt->depth) >> 3;
> +	}
> +}
> +
> +static inline u32 pxp_sizeimage(struct pxp_fmt *fmt, u32 width, u32 height)
> +{
> +	return (fmt->depth * width * height) >> 3;
> +}
> +
> +static int vidioc_try_fmt(struct v4l2_format *f, struct pxp_fmt *fmt)
> +{
> +	v4l_bound_align_image(&f->fmt.pix.width, MIN_W, MAX_W, ALIGN_W,
> +			      &f->fmt.pix.height, MIN_H, MAX_H, ALIGN_H, 0);
> +
> +	f->fmt.pix.bytesperline = pxp_bytesperline(fmt, f->fmt.pix.width);
> +	f->fmt.pix.sizeimage = pxp_sizeimage(fmt, f->fmt.pix.width,
> +					     f->fmt.pix.height);
> +	f->fmt.pix.field = V4L2_FIELD_NONE;
> +
> +	return 0;
> +}
> +
> +static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct pxp_fmt *fmt;
> +	struct pxp_ctx *ctx = file2ctx(file);
> +
> +	fmt = find_format(f);
> +	if (!fmt) {
> +		f->fmt.pix.pixelformat = formats[0].fourcc;
> +		fmt = find_format(f);
> +	}
> +	if (!(fmt->types & MEM2MEM_CAPTURE)) {
> +		v4l2_err(&ctx->dev->v4l2_dev,
> +			 "Fourcc format (0x%08x) invalid.\n",
> +			 f->fmt.pix.pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	f->fmt.pix.colorspace = ctx->colorspace;
> +	f->fmt.pix.xfer_func = ctx->xfer_func;
> +	f->fmt.pix.ycbcr_enc = ctx->ycbcr_enc;
> +	f->fmt.pix.quantization = ctx->quant;
> +
> +	return vidioc_try_fmt(f, fmt);
> +}
> +
> +static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct pxp_fmt *fmt;
> +	struct pxp_ctx *ctx = file2ctx(file);
> +
> +	fmt = find_format(f);
> +	if (!fmt) {
> +		f->fmt.pix.pixelformat = formats[0].fourcc;
> +		fmt = find_format(f);
> +	}
> +	if (!(fmt->types & MEM2MEM_OUTPUT)) {
> +		v4l2_err(&ctx->dev->v4l2_dev,
> +			 "Fourcc format (0x%08x) invalid.\n",
> +			 f->fmt.pix.pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	if (!f->fmt.pix.colorspace)
> +		f->fmt.pix.colorspace = V4L2_COLORSPACE_REC709;

REC709 implies that ycbcr_enc also uses REC709. But you only support
601. To make this a practical driver you want to support both 601
and 709.

Does this hardware also support gamma tables? Without it you can't
convert between different transfer functions. Just curious if the hw
can do this at all.

> +
> +	return vidioc_try_fmt(f, fmt);
> +}
> +
> +static int vidioc_s_fmt(struct pxp_ctx *ctx, struct v4l2_format *f)
> +{
> +	struct pxp_q_data *q_data;
> +	struct vb2_queue *vq;
> +
> +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> +	if (!vq)
> +		return -EINVAL;
> +
> +	q_data = get_q_data(ctx, f->type);
> +	if (!q_data)
> +		return -EINVAL;
> +
> +	if (vb2_is_busy(vq)) {
> +		v4l2_err(&ctx->dev->v4l2_dev, "%s queue busy\n", __func__);
> +		return -EBUSY;
> +	}
> +
> +	q_data->fmt		= find_format(f);
> +	q_data->width		= f->fmt.pix.width;
> +	q_data->height		= f->fmt.pix.height;
> +	q_data->bytesperline	= f->fmt.pix.bytesperline;
> +	q_data->sizeimage	= f->fmt.pix.sizeimage;
> +
> +	dprintk(ctx->dev,
> +		"Setting format for type %d, wxh: %dx%d, fmt: %d\n",
> +		f->type, q_data->width, q_data->height, q_data->fmt->fourcc);
> +
> +	return 0;
> +}
> +
> +static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	int ret;
> +
> +	ret = vidioc_try_fmt_vid_cap(file, priv, f);
> +	if (ret)
> +		return ret;
> +
> +	return vidioc_s_fmt(file2ctx(file), f);
> +}
> +
> +static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct pxp_ctx *ctx = file2ctx(file);
> +	int ret;
> +
> +	ret = vidioc_try_fmt_vid_out(file, priv, f);
> +	if (ret)
> +		return ret;
> +
> +	ret = vidioc_s_fmt(file2ctx(file), f);
> +	if (!ret) {
> +		ctx->colorspace = f->fmt.pix.colorspace;
> +		ctx->xfer_func = f->fmt.pix.xfer_func;
> +		ctx->ycbcr_enc = f->fmt.pix.ycbcr_enc;
> +		ctx->quant = f->fmt.pix.quantization;
> +	}
> +	return ret;
> +}
> +
> +static int pxp_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct pxp_ctx *ctx =
> +		container_of(ctrl->handler, struct pxp_ctx, hdl);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_HFLIP:
> +		if (ctrl->val)
> +			ctx->mode |= MEM2MEM_HFLIP;
> +		else
> +			ctx->mode &= ~MEM2MEM_HFLIP;
> +		break;
> +
> +	case V4L2_CID_VFLIP:
> +		if (ctrl->val)
> +			ctx->mode |= MEM2MEM_VFLIP;
> +		else
> +			ctx->mode &= ~MEM2MEM_VFLIP;
> +		break;
> +
> +	case V4L2_CID_ALPHA_COMPONENT:
> +		ctx->alpha_component = ctrl->val;
> +		break;
> +
> +	default:
> +		v4l2_err(&ctx->dev->v4l2_dev, "Invalid control\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ctrl_ops pxp_ctrl_ops = {
> +	.s_ctrl = pxp_s_ctrl,
> +};
> +
> +static const struct v4l2_ioctl_ops pxp_ioctl_ops = {
> +	.vidioc_querycap	= vidioc_querycap,
> +
> +	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap	= vidioc_g_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_cap	= vidioc_try_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap	= vidioc_s_fmt_vid_cap,
> +
> +	.vidioc_enum_fmt_vid_out = vidioc_enum_fmt_vid_out,
> +	.vidioc_g_fmt_vid_out	= vidioc_g_fmt_vid_out,
> +	.vidioc_try_fmt_vid_out	= vidioc_try_fmt_vid_out,
> +	.vidioc_s_fmt_vid_out	= vidioc_s_fmt_vid_out,
> +
> +	.vidioc_reqbufs		= v4l2_m2m_ioctl_reqbufs,
> +	.vidioc_querybuf	= v4l2_m2m_ioctl_querybuf,
> +	.vidioc_qbuf		= v4l2_m2m_ioctl_qbuf,
> +	.vidioc_dqbuf		= v4l2_m2m_ioctl_dqbuf,
> +	.vidioc_prepare_buf	= v4l2_m2m_ioctl_prepare_buf,
> +	.vidioc_create_bufs	= v4l2_m2m_ioctl_create_bufs,
> +	.vidioc_expbuf		= v4l2_m2m_ioctl_expbuf,
> +
> +	.vidioc_streamon	= v4l2_m2m_ioctl_streamon,
> +	.vidioc_streamoff	= v4l2_m2m_ioctl_streamoff,
> +
> +	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
> +};
> +
> +
> +/*
> + * Queue operations
> + */
> +
> +static int pxp_queue_setup(struct vb2_queue *vq,
> +			   unsigned int *nbuffers, unsigned int *nplanes,
> +			   unsigned int sizes[], struct device *alloc_devs[])
> +{
> +	struct pxp_ctx *ctx = vb2_get_drv_priv(vq);
> +	struct pxp_q_data *q_data;
> +	unsigned int size, count = *nbuffers;
> +
> +	q_data = get_q_data(ctx, vq->type);
> +
> +	size = q_data->sizeimage;
> +
> +	while (size * count > MEM2MEM_VID_MEM_LIMIT)
> +		(count)--;

Why do this? It never made sense to me. If you try to allocate more memory then
there is, you get -ENOMEM, which is just fine.

I'd drop this.

> +	*nbuffers = count;
> +
> +	if (*nplanes)
> +		return sizes[0] < size ? -EINVAL : 0;
> +
> +	*nplanes = 1;
> +	sizes[0] = size;
> +
> +	dprintk(ctx->dev, "get %d buffer(s) of size %d each.\n", count, size);
> +
> +	return 0;
> +}
> +
> +static int pxp_buf_prepare(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct pxp_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +	struct pxp_dev *dev = ctx->dev;
> +	struct pxp_q_data *q_data;
> +
> +	dprintk(ctx->dev, "type: %d\n", vb->vb2_queue->type);
> +
> +	q_data = get_q_data(ctx, vb->vb2_queue->type);
> +	if (V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
> +		if (vbuf->field == V4L2_FIELD_ANY)
> +			vbuf->field = V4L2_FIELD_NONE;
> +		if (vbuf->field != V4L2_FIELD_NONE) {
> +			dprintk(dev, "%s field isn't supported\n", __func__);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
> +		dprintk(dev, "%s data will not fit into plane (%lu < %lu)\n",
> +			__func__, vb2_plane_size(vb, 0),
> +			(long)q_data->sizeimage);
> +		return -EINVAL;
> +	}
> +
> +	vb2_set_plane_payload(vb, 0, q_data->sizeimage);
> +
> +	return 0;
> +}
> +
> +static void pxp_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct pxp_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +
> +	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
> +}
> +
> +static int pxp_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct pxp_ctx *ctx = vb2_get_drv_priv(q);
> +	struct pxp_q_data *q_data = get_q_data(ctx, q->type);
> +
> +	q_data->sequence = 0;
> +	return 0;
> +}
> +
> +static void pxp_stop_streaming(struct vb2_queue *q)
> +{
> +	struct pxp_ctx *ctx = vb2_get_drv_priv(q);
> +	struct vb2_v4l2_buffer *vbuf;
> +	unsigned long flags;
> +
> +	for (;;) {
> +		if (V4L2_TYPE_IS_OUTPUT(q->type))
> +			vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> +		else
> +			vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> +		if (vbuf == NULL)
> +			return;
> +		spin_lock_irqsave(&ctx->dev->irqlock, flags);
> +		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
> +		spin_unlock_irqrestore(&ctx->dev->irqlock, flags);
> +	}
> +}
> +
> +static const struct vb2_ops pxp_qops = {
> +	.queue_setup	 = pxp_queue_setup,
> +	.buf_prepare	 = pxp_buf_prepare,
> +	.buf_queue	 = pxp_buf_queue,
> +	.start_streaming = pxp_start_streaming,
> +	.stop_streaming  = pxp_stop_streaming,
> +	.wait_prepare	 = vb2_ops_wait_prepare,
> +	.wait_finish	 = vb2_ops_wait_finish,
> +};
> +
> +static int queue_init(void *priv, struct vb2_queue *src_vq,
> +		      struct vb2_queue *dst_vq)
> +{
> +	struct pxp_ctx *ctx = priv;
> +	int ret;
> +
> +	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +	src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
> +	src_vq->drv_priv = ctx;
> +	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +	src_vq->ops = &pxp_qops;
> +	src_vq->mem_ops = &vb2_dma_contig_memops;
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->lock = &ctx->dev->dev_mutex;
> +	src_vq->dev = ctx->dev->v4l2_dev.dev;
> +
> +	ret = vb2_queue_init(src_vq);
> +	if (ret)
> +		return ret;
> +
> +	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	dst_vq->io_modes = VB2_MMAP | VB2_DMABUF;
> +	dst_vq->drv_priv = ctx;
> +	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +	dst_vq->ops = &pxp_qops;
> +	dst_vq->mem_ops = &vb2_dma_contig_memops;
> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->lock = &ctx->dev->dev_mutex;
> +	dst_vq->dev = ctx->dev->v4l2_dev.dev;
> +
> +	return vb2_queue_init(dst_vq);
> +}
> +
> +/*
> + * File operations
> + */
> +static int pxp_open(struct file *file)
> +{
> +	struct pxp_dev *dev = video_drvdata(file);
> +	struct pxp_ctx *ctx = NULL;
> +	struct v4l2_ctrl_handler *hdl;
> +	int rc = 0;
> +
> +	if (mutex_lock_interruptible(&dev->dev_mutex))
> +		return -ERESTARTSYS;
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx) {
> +		rc = -ENOMEM;
> +		goto open_unlock;
> +	}
> +
> +	v4l2_fh_init(&ctx->fh, video_devdata(file));
> +	file->private_data = &ctx->fh;
> +	ctx->dev = dev;
> +	hdl = &ctx->hdl;
> +	v4l2_ctrl_handler_init(hdl, 4);
> +	v4l2_ctrl_new_std(hdl, &pxp_ctrl_ops, V4L2_CID_HFLIP, 0, 1, 1, 0);
> +	v4l2_ctrl_new_std(hdl, &pxp_ctrl_ops, V4L2_CID_VFLIP, 0, 1, 1, 0);
> +	v4l2_ctrl_new_std(hdl, &pxp_ctrl_ops, V4L2_CID_ALPHA_COMPONENT,
> +			  0, 255, 1, 255);
> +	if (hdl->error) {
> +		rc = hdl->error;
> +		v4l2_ctrl_handler_free(hdl);
> +		kfree(ctx);
> +		goto open_unlock;
> +	}
> +	ctx->fh.ctrl_handler = hdl;
> +	v4l2_ctrl_handler_setup(hdl);
> +
> +	ctx->q_data[V4L2_M2M_SRC].fmt = &formats[0];
> +	ctx->q_data[V4L2_M2M_SRC].width = 640;
> +	ctx->q_data[V4L2_M2M_SRC].height = 480;
> +	ctx->q_data[V4L2_M2M_SRC].bytesperline =
> +		pxp_bytesperline(&formats[0], 640);
> +	ctx->q_data[V4L2_M2M_SRC].sizeimage =
> +		pxp_sizeimage(&formats[0], 640, 480);
> +	ctx->q_data[V4L2_M2M_DST] = ctx->q_data[V4L2_M2M_SRC];
> +	ctx->colorspace = V4L2_COLORSPACE_REC709;
> +
> +	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx, &queue_init);
> +
> +	if (IS_ERR(ctx->fh.m2m_ctx)) {
> +		rc = PTR_ERR(ctx->fh.m2m_ctx);
> +
> +		v4l2_ctrl_handler_free(hdl);
> +		v4l2_fh_exit(&ctx->fh);
> +		kfree(ctx);
> +		goto open_unlock;
> +	}
> +
> +	v4l2_fh_add(&ctx->fh);
> +	atomic_inc(&dev->num_inst);
> +
> +	dprintk(dev, "Created instance: %p, m2m_ctx: %p\n",
> +		ctx, ctx->fh.m2m_ctx);
> +
> +open_unlock:
> +	mutex_unlock(&dev->dev_mutex);
> +	return rc;
> +}
> +
> +static int pxp_release(struct file *file)
> +{
> +	struct pxp_dev *dev = video_drvdata(file);
> +	struct pxp_ctx *ctx = file2ctx(file);
> +
> +	dprintk(dev, "Releasing instance %p\n", ctx);
> +
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	v4l2_ctrl_handler_free(&ctx->hdl);
> +	mutex_lock(&dev->dev_mutex);
> +	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
> +	mutex_unlock(&dev->dev_mutex);
> +	kfree(ctx);
> +
> +	atomic_dec(&dev->num_inst);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_file_operations pxp_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= pxp_open,
> +	.release	= pxp_release,
> +	.poll		= v4l2_m2m_fop_poll,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.mmap		= v4l2_m2m_fop_mmap,
> +};
> +
> +static const struct video_device pxp_videodev = {
> +	.name		= MEM2MEM_NAME,
> +	.vfl_dir	= VFL_DIR_M2M,
> +	.fops		= &pxp_fops,
> +	.ioctl_ops	= &pxp_ioctl_ops,
> +	.minor		= -1,
> +	.release	= video_device_release_empty,
> +};
> +
> +static const struct v4l2_m2m_ops m2m_ops = {
> +	.device_run	= pxp_device_run,
> +	.job_ready	= pxp_job_ready,
> +	.job_abort	= pxp_job_abort,
> +};
> +
> +static void pxp_soft_reset(struct pxp_dev *dev)
> +{
> +	int ret;
> +	u32 val;
> +
> +	writel(BM_PXP_CTRL_SFTRST, dev->mmio + HW_PXP_CTRL_CLR);
> +	writel(BM_PXP_CTRL_CLKGATE, dev->mmio + HW_PXP_CTRL_CLR);
> +
> +	writel(BM_PXP_CTRL_SFTRST, dev->mmio + HW_PXP_CTRL_SET);
> +
> +	ret = readl_poll_timeout(dev->mmio + HW_PXP_CTRL, val,
> +				 val & BM_PXP_CTRL_CLKGATE, 0, 100);
> +	if (ret < 0)
> +		pr_err("PXP reset timeout\n");
> +
> +	writel(BM_PXP_CTRL_SFTRST, dev->mmio + HW_PXP_CTRL_CLR);
> +	writel(BM_PXP_CTRL_CLKGATE, dev->mmio + HW_PXP_CTRL_CLR);
> +}
> +
> +static int pxp_probe(struct platform_device *pdev)
> +{
> +	struct pxp_dev *dev;
> +	struct resource *res;
> +	struct video_device *vfd;
> +	int irq;
> +	int ret;
> +
> +	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
> +	if (!dev)
> +		return -ENOMEM;
> +
> +	dev->clk = devm_clk_get(&pdev->dev, "axi");
> +	if (IS_ERR(dev->clk)) {
> +		ret = PTR_ERR(dev->clk);
> +		dev_err(&pdev->dev, "Failed to get clk: %d\n", ret);
> +		return ret;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	dev->mmio = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(dev->mmio)) {
> +		ret = PTR_ERR(dev->mmio);
> +		dev_err(&pdev->dev, "Failed to map register space: %d\n", ret);
> +		return ret;
> +	}
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(&pdev->dev, "Failed to get irq resource: %d\n", irq);
> +		return irq;
> +	}
> +
> +	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL, pxp_irq_handler,
> +			IRQF_ONESHOT, dev_name(&pdev->dev), dev);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Failed to request irq: %d\n", ret);
> +		return ret;
> +	}
> +
> +	/* Enable clocks and dump registers */
> +	clk_prepare_enable(dev->clk);
> +	pxp_soft_reset(dev);
> +
> +	spin_lock_init(&dev->irqlock);
> +
> +	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> +	if (ret)
> +		return ret;
> +
> +	atomic_set(&dev->num_inst, 0);
> +	mutex_init(&dev->dev_mutex);
> +
> +	dev->vfd = pxp_videodev;
> +	vfd = &dev->vfd;
> +	vfd->lock = &dev->dev_mutex;
> +	vfd->v4l2_dev = &dev->v4l2_dev;
> +
> +	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);

Please move this down until after v4l2_m2m_init: that should be done
before you register the video device.

> +	if (ret) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
> +		goto unreg_dev;
> +	}
> +
> +	video_set_drvdata(vfd, dev);
> +	snprintf(vfd->name, sizeof(vfd->name), "%s", pxp_videodev.name);
> +	v4l2_info(&dev->v4l2_dev,
> +			"Device registered as /dev/video%d\n", vfd->num);
> +
> +	platform_set_drvdata(pdev, dev);
> +
> +	dev->m2m_dev = v4l2_m2m_init(&m2m_ops);
> +	if (IS_ERR(dev->m2m_dev)) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem device\n");
> +		ret = PTR_ERR(dev->m2m_dev);
> +		goto err_m2m;
> +	}
> +
> +	return 0;
> +
> +err_m2m:
> +	v4l2_m2m_release(dev->m2m_dev);
> +	video_unregister_device(&dev->vfd);
> +unreg_dev:
> +	v4l2_device_unregister(&dev->v4l2_dev);
> +
> +	return ret;
> +}
> +
> +static int pxp_remove(struct platform_device *pdev)
> +{
> +	struct pxp_dev *dev = platform_get_drvdata(pdev);
> +
> +	writel(BM_PXP_CTRL_CLKGATE, dev->mmio + HW_PXP_CTRL_SET);
> +	writel(BM_PXP_CTRL_SFTRST, dev->mmio + HW_PXP_CTRL_SET);
> +
> +	clk_disable_unprepare(dev->clk);
> +
> +	v4l2_info(&dev->v4l2_dev, "Removing " MEM2MEM_NAME);
> +	v4l2_m2m_release(dev->m2m_dev);
> +	video_unregister_device(&dev->vfd);
> +	v4l2_device_unregister(&dev->v4l2_dev);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id pxp_dt_ids[] = {
> +	{ .compatible = "fsl,imx6ull-pxp", .data = NULL },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, pxp_dt_ids);
> +
> +static struct platform_driver pxp_driver = {
> +	.probe		= pxp_probe,
> +	.remove		= pxp_remove,
> +	.driver		= {
> +		.name	= MEM2MEM_NAME,
> +		.of_match_table = of_match_ptr(pxp_dt_ids),
> +	},
> +};
> +
> +module_platform_driver(pxp_driver);
> +
> +MODULE_DESCRIPTION("i.MX PXP mem2mem scaler/CSC/rotator");
> +MODULE_AUTHOR("Philipp Zabel <kernel@pengutronix.de>");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/platform/imx-pxp.h b/drivers/media/platform/imx-pxp.h
> new file mode 100644
> index 000000000000..f1f6a1d3282f
> --- /dev/null
> +++ b/drivers/media/platform/imx-pxp.h


<snip>

Regards,

	Hans
