Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:50484 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726224AbeHBKpC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Aug 2018 06:45:02 -0400
Subject: Re: [PATCH 3/3] media: add Rockchip VPU driver
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org
References: <20180801210714.1620-1-ezequiel@collabora.com>
 <20180801210714.1620-4-ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <13de5e62-8c73-7e46-d848-6ae78dde1588@xs4all.nl>
Date: Thu, 2 Aug 2018 10:54:44 +0200
MIME-Version: 1.0
In-Reply-To: <20180801210714.1620-4-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/01/18 23:07, Ezequiel Garcia wrote:
> Add a mem2mem driver for the VPU available on Rockchip SoCs.
> Currently only JPEG encoding is supported, for RK3399 and RK3288
> platforms.
> 
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  drivers/media/platform/Kconfig                |  12 +
>  drivers/media/platform/Makefile               |   1 +
>  drivers/media/platform/rockchip/vpu/Makefile  |   8 +
>  .../platform/rockchip/vpu/rk3288_vpu_hw.c     | 127 +++
>  .../rockchip/vpu/rk3288_vpu_hw_jpege.c        | 156 ++++
>  .../platform/rockchip/vpu/rk3288_vpu_regs.h   | 442 ++++++++++
>  .../platform/rockchip/vpu/rk3399_vpu_hw.c     | 127 +++
>  .../rockchip/vpu/rk3399_vpu_hw_jpege.c        | 165 ++++
>  .../platform/rockchip/vpu/rk3399_vpu_regs.h   | 601 ++++++++++++++
>  .../platform/rockchip/vpu/rockchip_vpu.h      | 270 +++++++
>  .../platform/rockchip/vpu/rockchip_vpu_drv.c  | 416 ++++++++++
>  .../platform/rockchip/vpu/rockchip_vpu_enc.c  | 763 ++++++++++++++++++
>  .../platform/rockchip/vpu/rockchip_vpu_enc.h  |  25 +
>  .../platform/rockchip/vpu/rockchip_vpu_hw.h   |  67 ++

There is no update for the MAINTAINERS file, please add an entry there.

>  14 files changed, 3180 insertions(+)
>  create mode 100644 drivers/media/platform/rockchip/vpu/Makefile
>  create mode 100644 drivers/media/platform/rockchip/vpu/rk3288_vpu_hw.c
>  create mode 100644 drivers/media/platform/rockchip/vpu/rk3288_vpu_hw_jpege.c
>  create mode 100644 drivers/media/platform/rockchip/vpu/rk3288_vpu_regs.h
>  create mode 100644 drivers/media/platform/rockchip/vpu/rk3399_vpu_hw.c
>  create mode 100644 drivers/media/platform/rockchip/vpu/rk3399_vpu_hw_jpege.c
>  create mode 100644 drivers/media/platform/rockchip/vpu/rk3399_vpu_regs.h
>  create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu.h
>  create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu_drv.c
>  create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.c
>  create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.h
>  create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu_hw.h
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 2728376b04b5..7244a2360732 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -448,6 +448,18 @@ config VIDEO_ROCKCHIP_RGA
>  
>  	  To compile this driver as a module choose m here.
>  
> +config VIDEO_ROCKCHIP_VPU
> +	tristate "Rockchip VPU driver"
> +	depends on VIDEO_DEV && VIDEO_V4L2
> +	depends on ARCH_ROCKCHIP || COMPILE_TEST
> +	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_MEM2MEM_DEV
> +	default n
> +	---help---
> +	  Support for the VPU video codec found on Rockchip SoC.
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called rockchip-vpu.
> +
>  config VIDEO_TI_VPE
>  	tristate "TI VPE (Video Processing Engine) driver"
>  	depends on VIDEO_DEV && VIDEO_V4L2
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index 04bc1502a30e..83378180d8ac 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -66,6 +66,7 @@ obj-$(CONFIG_VIDEO_RENESAS_JPU)		+= rcar_jpu.o
>  obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
>  
>  obj-$(CONFIG_VIDEO_ROCKCHIP_RGA)	+= rockchip/rga/
> +obj-$(CONFIG_VIDEO_ROCKCHIP_VPU)        += rockchip/vpu/
>  
>  obj-y	+= omap/
>  
> diff --git a/drivers/media/platform/rockchip/vpu/Makefile b/drivers/media/platform/rockchip/vpu/Makefile
> new file mode 100644
> index 000000000000..cab0123c49d4
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/vpu/Makefile
> @@ -0,0 +1,8 @@
> +obj-$(CONFIG_VIDEO_ROCKCHIP_VPU) += rockchip-vpu.o
> +
> +rockchip-vpu-y += rockchip_vpu_drv.o \
> +		rockchip_vpu_enc.o \
> +		rk3288_vpu_hw.o \
> +		rk3288_vpu_hw_jpege.o \
> +		rk3399_vpu_hw.o \
> +		rk3399_vpu_hw_jpege.o
> diff --git a/drivers/media/platform/rockchip/vpu/rk3288_vpu_hw.c b/drivers/media/platform/rockchip/vpu/rk3288_vpu_hw.c
> new file mode 100644
> index 000000000000..0caff8ecf343
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/vpu/rk3288_vpu_hw.c
> @@ -0,0 +1,127 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Rockchip VPU codec driver
> + *
> + * Copyright (C) 2018 Rockchip Electronics Co., Ltd.
> + *	Jeffy Chen <jeffy.chen@rock-chips.com>
> + */
> +
> +#include <linux/clk.h>
> +
> +#include "rockchip_vpu.h"
> +#include "rk3288_vpu_regs.h"
> +
> +#define RK3288_ACLK_MAX_FREQ (400 * 1000 * 1000)
> +
> +/*
> + * Supported formats.
> + */
> +
> +static const struct rockchip_vpu_fmt rk3288_vpu_enc_fmts[] = {
> +	/* Source formats. */
> +	{
> +		.name = "4:2:0 3 planes Y/Cb/Cr",

Please drop the name field. This is filled in by v4l2-ioctl.c in its
enum_fmt implementation.

> +		.fourcc = V4L2_PIX_FMT_YUV420M,
> +		.codec_mode = RK_VPU_CODEC_NONE,
> +		.num_planes = 3,
> +		.depth = { 8, 4, 4 },
> +		.enc_fmt = RK3288_VPU_ENC_FMT_YUV420P,
> +	},
> +	{
> +		.name = "4:2:0 2 plane Y/CbCr",
> +		.fourcc = V4L2_PIX_FMT_NV12M,
> +		.codec_mode = RK_VPU_CODEC_NONE,
> +		.num_planes = 2,
> +		.depth = { 8, 8 },
> +		.enc_fmt = RK3288_VPU_ENC_FMT_YUV420SP,
> +	},
> +	{
> +		.name = "4:2:2 1 plane YUYV",
> +		.fourcc = V4L2_PIX_FMT_YUYV,
> +		.codec_mode = RK_VPU_CODEC_NONE,
> +		.num_planes = 1,
> +		.depth = { 16 },
> +		.enc_fmt = RK3288_VPU_ENC_FMT_YUYV422,
> +	},
> +	{
> +		.name = "4:2:2 1 plane UYVY",
> +		.fourcc = V4L2_PIX_FMT_UYVY,
> +		.codec_mode = RK_VPU_CODEC_NONE,
> +		.num_planes = 1,
> +		.depth = { 16 },
> +		.enc_fmt = RK3288_VPU_ENC_FMT_UYVY422,
> +	},
> +	/* Destination formats. */
> +	{
> +		.name = "JPEG Encoded Stream",
> +		.fourcc = V4L2_PIX_FMT_JPEG_RAW,
> +		.codec_mode = RK_VPU_CODEC_JPEGE,
> +		.num_planes = 1,
> +		.frmsize = {
> +			.min_width = 96,
> +			.max_width = 8192,
> +			.step_width = MB_DIM,
> +			.min_height = 32,
> +			.max_height = 8192,
> +			.step_height = MB_DIM,
> +		},
> +	},
> +};

<snip>

> diff --git a/drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.c b/drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.c
> new file mode 100644
> index 000000000000..6a5e45f7d69f
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.c
> @@ -0,0 +1,763 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Rockchip VPU codec driver
> + *
> + * Copyright (C) 2018 Collabora, Ltd.
> + * Copyright (C) 2018 Rockchip Electronics Co., Ltd.
> + *	Alpha Lin <Alpha.Lin@rock-chips.com>
> + *	Jeffy Chen <jeffy.chen@rock-chips.com>
> + *
> + * Copyright (C) 2018 Google, Inc.
> + *	Tomasz Figa <tfiga@chromium.org>
> + *
> + * Based on s5p-mfc driver by Samsung Electronics Co., Ltd.
> + * Copyright (C) 2010-2011 Samsung Electronics Co., Ltd.
> + */
> +
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/videodev2.h>
> +#include <linux/workqueue.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-dma-sg.h>
> +
> +#include "rockchip_vpu.h"
> +#include "rockchip_vpu_enc.h"
> +#include "rockchip_vpu_hw.h"
> +
> +#define JPEG_MAX_BYTES_PER_PIXEL 2
> +
> +static const struct rockchip_vpu_fmt *
> +rockchip_vpu_find_format(struct rockchip_vpu_dev *dev, u32 fourcc)
> +{
> +	const struct rockchip_vpu_fmt *formats = dev->variant->enc_fmts;
> +	unsigned int i;
> +
> +	for (i = 0; i < dev->variant->num_enc_fmts; i++) {
> +		if (formats[i].fourcc == fourcc)
> +			return &formats[i];
> +	}
> +
> +	return NULL;
> +}
> +
> +static const struct rockchip_vpu_fmt *
> +rockchip_vpu_get_default_fmt(struct rockchip_vpu_dev *dev, bool bitstream)
> +{
> +	const struct rockchip_vpu_fmt *formats = dev->variant->enc_fmts;
> +	unsigned int i;
> +
> +	for (i = 0; i < dev->variant->num_enc_fmts; i++) {
> +		if (bitstream == (formats[i].codec_mode != RK_VPU_CODEC_NONE))
> +			return &formats[i];
> +	}
> +
> +	/* There must be at least one raw and one coded format in the array. */
> +	BUG_ON(i >= dev->variant->num_enc_fmts);
> +	return NULL;
> +}
> +
> +static const struct v4l2_ctrl_config controls[] = {
> +	[ROCKCHIP_VPU_ENC_CTRL_Y_QUANT_TBL] = {
> +		.id = V4L2_CID_JPEG_LUMA_QUANTIZATION,
> +		.type = V4L2_CTRL_TYPE_U8,
> +		.step = 1,
> +		.def = 0x00,
> +		.min = 0x00,
> +		.max = 0xff,
> +		.dims = { 8, 8 }
> +	},
> +	[ROCKCHIP_VPU_ENC_CTRL_C_QUANT_TBL] = {
> +		.id = V4L2_CID_JPEG_CHROMA_QUANTIZATION,
> +		.type = V4L2_CTRL_TYPE_U8,
> +		.step = 1,
> +		.def = 0x00,
> +		.min = 0x00,
> +		.max = 0xff,
> +		.dims = { 8, 8 }
> +	},
> +};
> +
> +static int vidioc_querycap(struct file *file, void *priv,
> +			   struct v4l2_capability *cap)
> +{
> +	struct rockchip_vpu_dev *vpu = video_drvdata(file);
> +
> +	strlcpy(cap->driver, vpu->dev->driver->name, sizeof(cap->driver));
> +	strlcpy(cap->card, vpu->vfd->name, sizeof(cap->card));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform: %s",
> +		 vpu->dev->driver->name);
> +
> +	/*
> +	 * This is only a mem-to-mem video device.
> +	 */
> +	cap->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;

Just set device_caps in struct video_device and you can drop this and the
next line from this function.

> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +
> +	return 0;
> +}
> +
> +static int vidioc_enum_framesizes(struct file *file, void *prov,
> +				  struct v4l2_frmsizeenum *fsize)
> +{
> +	struct rockchip_vpu_dev *dev = video_drvdata(file);
> +	const struct rockchip_vpu_fmt *fmt;
> +
> +	if (fsize->index != 0) {
> +		vpu_debug(0, "invalid frame size index (expected 0, got %d)\n",
> +				fsize->index);
> +		return -EINVAL;
> +	}
> +
> +	fmt = rockchip_vpu_find_format(dev, fsize->pixel_format);
> +	if (!fmt) {
> +		vpu_debug(0, "unsupported bitstream format (%08x)\n",
> +				fsize->pixel_format);
> +		return -EINVAL;
> +	}
> +
> +	/* This only makes sense for codec formats */
> +	if (fmt->codec_mode == RK_VPU_CODEC_NONE)
> +		return -ENOTTY;
> +
> +	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
> +	fsize->stepwise = fmt->frmsize;
> +
> +	return 0;
> +}
> +
> +static int vidioc_enum_fmt_vid_cap_mplane(struct file *file, void *priv,
> +					  struct v4l2_fmtdesc *f)
> +{
> +	struct rockchip_vpu_dev *dev = video_drvdata(file);
> +	const struct rockchip_vpu_fmt *fmt;
> +	const struct rockchip_vpu_fmt *formats = dev->variant->enc_fmts;
> +	int i, j = 0;
> +
> +	for (i = 0; i < dev->variant->num_enc_fmts; i++) {
> +		/* Skip uncompressed formats */
> +		if (formats[i].codec_mode == RK_VPU_CODEC_NONE)
> +			continue;
> +		if (j == f->index) {
> +			fmt = &formats[i];
> +			strlcpy(f->description,
> +				fmt->name, sizeof(f->description));

Drop this,

> +			f->pixelformat = fmt->fourcc;
> +			f->flags = 0;
> +			f->flags |= V4L2_FMT_FLAG_COMPRESSED;

and this. Both fields are assigned for you in v4l2-ioctl.c.

> +			return 0;
> +		}
> +		++j;
> +	}
> +	return -EINVAL;
> +}
> +
> +static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *priv,
> +					  struct v4l2_fmtdesc *f)
> +{
> +	struct rockchip_vpu_dev *dev = video_drvdata(file);
> +	const struct rockchip_vpu_fmt *fmt;
> +	const struct rockchip_vpu_fmt *formats = dev->variant->enc_fmts;
> +	int i, j = 0;
> +
> +	for (i = 0; i < dev->variant->num_enc_fmts; i++) {
> +		if (formats[i].codec_mode != RK_VPU_CODEC_NONE)
> +			continue;
> +		if (j == f->index) {
> +			fmt = &formats[i];
> +			strlcpy(f->description,
> +				fmt->name, sizeof(f->description));
> +			f->pixelformat = fmt->fourcc;
> +			f->flags = 0;

Ditto.

> +			return 0;
> +		}
> +		++j;
> +	}
> +	return -EINVAL;
> +}
> +
> +static int vidioc_g_fmt_out(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
> +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +
> +	vpu_debug(4, "f->type = %d\n", f->type);
> +
> +	*pix_mp = ctx->src_fmt;
> +	pix_mp->colorspace = ctx->colorspace;
> +	pix_mp->ycbcr_enc = ctx->ycbcr_enc;
> +	pix_mp->xfer_func = ctx->xfer_func;
> +	pix_mp->quantization = ctx->quantization;
> +
> +	return 0;
> +}
> +
> +static int vidioc_g_fmt_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
> +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +
> +	vpu_debug(4, "f->type = %d\n", f->type);
> +
> +	*pix_mp = ctx->dst_fmt;
> +	pix_mp->colorspace = ctx->colorspace;
> +	pix_mp->ycbcr_enc = ctx->ycbcr_enc;
> +	pix_mp->xfer_func = ctx->xfer_func;
> +	pix_mp->quantization = ctx->quantization;
> +
> +	return 0;
> +}
> +
> +static void calculate_plane_sizes(const struct rockchip_vpu_fmt *fmt,
> +				  struct v4l2_pix_format_mplane *pix_mp)
> +{
> +	unsigned int w = pix_mp->width;
> +	unsigned int h = pix_mp->height;
> +	int i;
> +
> +	for (i = 0; i < fmt->num_planes; ++i) {
> +		memset(pix_mp->plane_fmt[i].reserved, 0,
> +		       sizeof(pix_mp->plane_fmt[i].reserved));
> +		pix_mp->plane_fmt[i].bytesperline = w * fmt->depth[i] / 8;
> +		pix_mp->plane_fmt[i].sizeimage = h *
> +					pix_mp->plane_fmt[i].bytesperline;
> +		/*
> +		 * All of multiplanar formats we support have chroma
> +		 * planes subsampled by 2 vertically.
> +		 */
> +		if (i != 0)
> +			pix_mp->plane_fmt[i].sizeimage /= 2;
> +	}
> +}
> +
> +static int vidioc_try_fmt_cap(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct rockchip_vpu_dev *dev = video_drvdata(file);
> +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
> +	const struct rockchip_vpu_fmt *fmt;
> +	char str[5];
> +
> +	vpu_debug(4, "%s\n", fmt2str(pix_mp->pixelformat, str));
> +
> +	fmt = rockchip_vpu_find_format(dev, pix_mp->pixelformat);
> +	if (!fmt) {
> +		fmt = rockchip_vpu_get_default_fmt(dev, true);
> +		f->fmt.pix.pixelformat = fmt->fourcc;
> +	}
> +
> +	/* Limit to hardware min/max. */
> +	pix_mp->width = clamp(pix_mp->width,
> +			ctx->vpu_dst_fmt->frmsize.min_width,
> +			ctx->vpu_dst_fmt->frmsize.max_width);
> +	pix_mp->height = clamp(pix_mp->height,
> +			ctx->vpu_dst_fmt->frmsize.min_height,
> +			ctx->vpu_dst_fmt->frmsize.max_height);
> +	pix_mp->num_planes = fmt->num_planes;
> +
> +	pix_mp->plane_fmt[0].sizeimage =
> +		pix_mp->width * pix_mp->height * JPEG_MAX_BYTES_PER_PIXEL;
> +	memset(pix_mp->plane_fmt[0].reserved, 0,
> +	       sizeof(pix_mp->plane_fmt[0].reserved));
> +	pix_mp->field = V4L2_FIELD_NONE;
> +
> +	return 0;
> +}
> +
> +static int vidioc_try_fmt_out(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct rockchip_vpu_dev *dev = video_drvdata(file);
> +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
> +	const struct rockchip_vpu_fmt *fmt;
> +	char str[5];
> +	unsigned long dma_align;
> +	bool need_alignment;
> +	int i;
> +
> +	vpu_debug(4, "%s\n", fmt2str(pix_mp->pixelformat, str));
> +
> +	fmt = rockchip_vpu_find_format(dev, pix_mp->pixelformat);
> +	if (!fmt) {
> +		fmt = rockchip_vpu_get_default_fmt(dev, false);
> +		f->fmt.pix.pixelformat = fmt->fourcc;
> +	}
> +
> +	/* Limit to hardware min/max. */
> +	pix_mp->width = clamp(pix_mp->width,
> +			ctx->vpu_dst_fmt->frmsize.min_width,
> +			ctx->vpu_dst_fmt->frmsize.max_width);
> +	pix_mp->height = clamp(pix_mp->height,
> +			ctx->vpu_dst_fmt->frmsize.min_height,
> +			ctx->vpu_dst_fmt->frmsize.max_height);
> +	/* Round up to macroblocks. */
> +	pix_mp->width = round_up(pix_mp->width, MB_DIM);
> +	pix_mp->height = round_up(pix_mp->height, MB_DIM);
> +	pix_mp->num_planes = fmt->num_planes;
> +	pix_mp->field = V4L2_FIELD_NONE;
> +
> +	vpu_debug(0, "OUTPUT codec mode: %d\n", fmt->codec_mode);
> +	vpu_debug(0, "fmt - w: %d, h: %d, mb - w: %d, h: %d\n",
> +		  pix_mp->width, pix_mp->height,
> +		  MB_WIDTH(pix_mp->width),
> +		  MB_HEIGHT(pix_mp->height));
> +
> +	/* Fill remaining fields */
> +	calculate_plane_sizes(fmt, pix_mp);
> +
> +	dma_align = dma_get_cache_alignment();
> +	need_alignment = false;
> +	for (i = 0; i < fmt->num_planes; i++) {
> +		if (!IS_ALIGNED(pix_mp->plane_fmt[i].sizeimage,
> +				dma_align)) {
> +			need_alignment = true;
> +			break;
> +		}
> +	}
> +	if (!need_alignment)
> +		return 0;
> +
> +	pix_mp->height = round_up(pix_mp->height, dma_align * 4 / MB_DIM);
> +	if (pix_mp->height > ctx->vpu_dst_fmt->frmsize.max_height) {
> +		vpu_err("Aligned height higher than maximum.\n");
> +		return -EINVAL;
> +	}
> +	/* Fill in remaining fields, again */
> +	calculate_plane_sizes(fmt, pix_mp);
> +	return 0;
> +}
> +
> +static void rockchip_vpu_reset_dst_fmt(struct rockchip_vpu_dev *vpu,
> +					struct rockchip_vpu_ctx *ctx)
> +{
> +	struct v4l2_pix_format_mplane *fmt = &ctx->dst_fmt;
> +
> +	ctx->vpu_dst_fmt = rockchip_vpu_get_default_fmt(vpu, true);
> +
> +	memset(fmt, 0, sizeof(*fmt));
> +
> +	fmt->width = ctx->vpu_dst_fmt->frmsize.min_width;
> +	fmt->height = ctx->vpu_dst_fmt->frmsize.min_height;
> +	fmt->pixelformat = ctx->vpu_dst_fmt->fourcc;
> +	fmt->num_planes = ctx->vpu_dst_fmt->num_planes;
> +	fmt->plane_fmt[0].sizeimage =
> +		fmt->width * fmt->height * JPEG_MAX_BYTES_PER_PIXEL;
> +
> +	fmt->field = V4L2_FIELD_NONE;
> +
> +	fmt->colorspace = ctx->colorspace;
> +	fmt->ycbcr_enc = ctx->ycbcr_enc;
> +	fmt->xfer_func = ctx->xfer_func;
> +	fmt->quantization = ctx->quantization;
> +}
> +
> +static void rockchip_vpu_reset_src_fmt(struct rockchip_vpu_dev *vpu,
> +					struct rockchip_vpu_ctx *ctx)
> +{
> +	struct v4l2_pix_format_mplane *fmt = &ctx->src_fmt;
> +
> +	ctx->vpu_src_fmt = rockchip_vpu_get_default_fmt(vpu, false);
> +
> +	memset(fmt, 0, sizeof(*fmt));
> +
> +	fmt->width = ctx->vpu_dst_fmt->frmsize.min_width;
> +	fmt->height = ctx->vpu_dst_fmt->frmsize.min_height;
> +	fmt->pixelformat = ctx->vpu_src_fmt->fourcc;
> +	fmt->num_planes = ctx->vpu_src_fmt->num_planes;
> +
> +	fmt->field = V4L2_FIELD_NONE;
> +
> +	fmt->colorspace = ctx->colorspace;
> +	fmt->ycbcr_enc = ctx->ycbcr_enc;
> +	fmt->xfer_func = ctx->xfer_func;
> +	fmt->quantization = ctx->quantization;
> +
> +	calculate_plane_sizes(ctx->vpu_src_fmt, fmt);
> +}
> +
> +static int vidioc_s_fmt_out(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
> +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +	struct rockchip_vpu_dev *vpu = ctx->dev;
> +	struct vb2_queue *vq, *peer_vq;
> +	int ret;
> +
> +	/* Change not allowed if queue is streaming. */
> +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> +	if (vb2_is_streaming(vq))
> +		return -EBUSY;
> +
> +	ctx->colorspace = pix_mp->colorspace;
> +	ctx->ycbcr_enc = pix_mp->ycbcr_enc;
> +	ctx->xfer_func = pix_mp->xfer_func;
> +	ctx->quantization = pix_mp->quantization;

See my comments about this in my reply to your v1 cover letter.

Does the HW support limited to full range (or vv) conversion? If so, then you
need to handle quantization in the driver. If not, then this code is fine.

> +
> +	/*
> +	 * Pixel format change is not allowed when the other queue has
> +	 * buffers allocated.
> +	 */
> +	peer_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
> +		V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
> +	if (vb2_is_busy(peer_vq) &&
> +	    pix_mp->pixelformat != ctx->src_fmt.pixelformat)
> +		return -EBUSY;
> +
> +	ret = vidioc_try_fmt_out(file, priv, f);
> +	if (ret)
> +		return ret;
> +
> +	ctx->vpu_src_fmt = rockchip_vpu_find_format(vpu,
> +		pix_mp->pixelformat);
> +
> +	/* Reset crop rectangle. */
> +	ctx->src_crop.width = pix_mp->width;
> +	ctx->src_crop.height = pix_mp->height;
> +	ctx->src_fmt = *pix_mp;
> +
> +	return 0;
> +}
> +
> +static int vidioc_s_fmt_cap(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
> +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +	struct rockchip_vpu_dev *vpu = ctx->dev;
> +	struct vb2_queue *vq, *peer_vq;
> +	int ret;
> +
> +	/* Change not allowed if queue is streaming. */
> +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> +	if (vb2_is_streaming(vq))
> +		return -EBUSY;
> +
> +	ctx->colorspace = pix_mp->colorspace;
> +	ctx->ycbcr_enc = pix_mp->ycbcr_enc;
> +	ctx->xfer_func = pix_mp->xfer_func;
> +	ctx->quantization = pix_mp->quantization;
> +
> +	/*
> +	 * Pixel format change is not allowed when the other queue has
> +	 * buffers allocated.
> +	 */
> +	peer_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
> +			V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
> +	if (vb2_is_busy(peer_vq) &&
> +	    pix_mp->pixelformat != ctx->dst_fmt.pixelformat)
> +		return -EBUSY;
> +
> +	ret = vidioc_try_fmt_cap(file, priv, f);
> +	if (ret)
> +		return ret;
> +
> +	ctx->vpu_dst_fmt = rockchip_vpu_find_format(vpu, pix_mp->pixelformat);
> +	ctx->dst_fmt = *pix_mp;
> +
> +	/*
> +	 * Current raw format might have become invalid with newly
> +	 * selected codec, so reset it to default just to be safe and
> +	 * keep internal driver state sane. User is mandated to set
> +	 * the raw format again after we return, so we don't need
> +	 * anything smarter.
> +	 */
> +	rockchip_vpu_reset_src_fmt(vpu, ctx);
> +
> +	return 0;
> +}
> +
> +static int vidioc_cropcap(struct file *file, void *priv,
> +			  struct v4l2_cropcap *cap)
> +{
> +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +	struct v4l2_pix_format_mplane *fmt = &ctx->src_fmt;
> +
> +	/* Crop only supported on source. */
> +	if (cap->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		return -EINVAL;
> +
> +	cap->bounds.left = 0;
> +	cap->bounds.top = 0;
> +	cap->bounds.width = fmt->width;
> +	cap->bounds.height = fmt->height;
> +	cap->defrect = cap->bounds;
> +	cap->pixelaspect.numerator = 1;
> +	cap->pixelaspect.denominator = 1;
> +
> +	return 0;
> +}
> +
> +static int vidioc_g_crop(struct file *file, void *priv, struct v4l2_crop *crop)
> +{
> +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +	int ret = 0;
> +
> +	/* Crop only supported on source. */
> +	if (crop->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		return -EINVAL;
> +
> +	crop->c = ctx->src_crop;
> +
> +	return ret;
> +}
> +
> +static int vidioc_s_crop(struct file *file, void *priv,
> +			 const struct v4l2_crop *crop)
> +{
> +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +	struct v4l2_pix_format_mplane *fmt = &ctx->src_fmt;
> +	const struct v4l2_rect *rect = &crop->c;
> +	struct vb2_queue *vq;
> +
> +	/* Crop only supported on source. */
> +	if (crop->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		return -EINVAL;
> +
> +	/* Change not allowed if the queue is streaming. */
> +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, crop->type);
> +	if (vb2_is_streaming(vq))
> +		return -EBUSY;
> +
> +	/* We do not support offsets. */
> +	if (rect->left != 0 || rect->top != 0)
> +		goto fallback;
> +
> +	/* We can crop only inside right- or bottom-most macroblocks. */
> +	if (round_up(rect->width, MB_DIM) != fmt->width
> +	    || round_up(rect->height, MB_DIM) != fmt->height)
> +		goto fallback;
> +
> +	/* We support widths aligned to 4 pixels and arbitrary heights. */
> +	ctx->src_crop.width = round_up(rect->width, 4);
> +	ctx->src_crop.height = rect->height;
> +
> +	return 0;
> +
> +fallback:
> +	/* Default to full frame for incorrect settings. */
> +	ctx->src_crop.width = fmt->width;
> +	ctx->src_crop.height = fmt->height;
> +	return 0;
> +}

Use selection API. I'm sure I've asked for this before.

I stop reviewing here since I wonder if this is really the v2 source code.
I see too many things I've commented about in v1. Did you accidentally
post the v1 again?

Regards,

	Hans
