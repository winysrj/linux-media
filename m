Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:48490 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751385AbdK0LkJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 06:40:09 -0500
Subject: Re: [PATCH v2 03/11] media: rkisp1: add rockchip isp1 driver
To: Jacob Chen <jacob-chen@iotwrt.com>,
        linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        tfiga@chromium.org, zhengsq@rock-chips.com,
        laurent.pinchart@ideasonboard.com, zyc@rock-chips.com,
        eddie.cai.linux@gmail.com, jeffy.chen@rock-chips.com,
        allon.huang@rock-chips.com, devicetree@vger.kernel.org,
        heiko@sntech.de, robh+dt@kernel.org,
        Jacob Chen <jacob2.chen@rock-chips.com>,
        Jacob Chen <cc@rock-chips.com>
References: <20171124023706.5702-1-jacob-chen@iotwrt.com>
 <20171124023706.5702-4-jacob-chen@iotwrt.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c198f7ee-81c7-8e1b-4762-7f58f1d2fc0e@xs4all.nl>
Date: Mon, 27 Nov 2017 12:40:01 +0100
MIME-Version: 1.0
In-Reply-To: <20171124023706.5702-4-jacob-chen@iotwrt.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacob,

Thank you for this driver! Much appreciated.

I have a bunch of comments below, nothing big, really. The main thing is that
you really need to sprinkle some more comments in the source code.

On 11/24/2017 03:36 AM, Jacob Chen wrote:
> From: Jacob Chen <jacob2.chen@rock-chips.com>
> 
> This commit adds a ISP(Camera) v4l2 driver for rockchip rk3288/rk3399 SoC.
> 
> Signed-off-by: Jacob Chen <jacob2.chen@rock-chips.com>
> Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
> Signed-off-by: Yichong Zhong <zyc@rock-chips.com>
> Signed-off-by: Jacob Chen <cc@rock-chips.com>
> Signed-off-by: Eddie Cai <eddie.cai.linux@gmail.com>
> Signed-off-by: Jeffy Chen <jeffy.chen@rock-chips.com>
> Signed-off-by: Allon Huang <allon.huang@rock-chips.com>
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> ---
>  drivers/media/platform/Kconfig                    |   10 +
>  drivers/media/platform/Makefile                   |    1 +
>  drivers/media/platform/rockchip/isp1/Makefile     |    7 +
>  drivers/media/platform/rockchip/isp1/capture.c    | 1691 +++++++++++++++++++++
>  drivers/media/platform/rockchip/isp1/capture.h    |   46 +
>  drivers/media/platform/rockchip/isp1/common.h     |  330 ++++
>  drivers/media/platform/rockchip/isp1/dev.c        |  632 ++++++++
>  drivers/media/platform/rockchip/isp1/isp_params.c | 1556 +++++++++++++++++++
>  drivers/media/platform/rockchip/isp1/isp_params.h |   81 +
>  drivers/media/platform/rockchip/isp1/isp_stats.c  |  537 +++++++
>  drivers/media/platform/rockchip/isp1/isp_stats.h  |   81 +
>  drivers/media/platform/rockchip/isp1/regs.c       |  251 +++
>  drivers/media/platform/rockchip/isp1/regs.h       | 1578 +++++++++++++++++++
>  drivers/media/platform/rockchip/isp1/rkisp1.c     | 1230 +++++++++++++++
>  drivers/media/platform/rockchip/isp1/rkisp1.h     |  130 ++
>  15 files changed, 8161 insertions(+)
>  create mode 100644 drivers/media/platform/rockchip/isp1/Makefile
>  create mode 100644 drivers/media/platform/rockchip/isp1/capture.c
>  create mode 100644 drivers/media/platform/rockchip/isp1/capture.h
>  create mode 100644 drivers/media/platform/rockchip/isp1/common.h
>  create mode 100644 drivers/media/platform/rockchip/isp1/dev.c
>  create mode 100644 drivers/media/platform/rockchip/isp1/isp_params.c
>  create mode 100644 drivers/media/platform/rockchip/isp1/isp_params.h
>  create mode 100644 drivers/media/platform/rockchip/isp1/isp_stats.c
>  create mode 100644 drivers/media/platform/rockchip/isp1/isp_stats.h
>  create mode 100644 drivers/media/platform/rockchip/isp1/regs.c
>  create mode 100644 drivers/media/platform/rockchip/isp1/regs.h
>  create mode 100644 drivers/media/platform/rockchip/isp1/rkisp1.c
>  create mode 100644 drivers/media/platform/rockchip/isp1/rkisp1.h
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index fd0c99859d6f..062fffc9ffb6 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -117,6 +117,16 @@ config VIDEO_QCOM_CAMSS
>  	select VIDEOBUF2_DMA_SG
>  	select V4L2_FWNODE
>  
> +config VIDEO_ROCKCHIP_ISP1
> +	tristate "Rockchip Image Signal Processing v1 Unit driver"
> +	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +	depends on ARCH_ROCKCHIP || COMPILE_TEST
> +	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_FWNODE
> +	default n
> +	---help---
> +	  Support for ISP1 on the rockchip SoC.
> +
>  config VIDEO_S3C_CAMIF
>  	tristate "Samsung S3C24XX/S3C64XX SoC Camera Interface driver"
>  	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index 003b0bb2cddf..d235908df63e 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -67,6 +67,7 @@ obj-$(CONFIG_VIDEO_RENESAS_FDP1)	+= rcar_fdp1.o
>  obj-$(CONFIG_VIDEO_RENESAS_JPU) 	+= rcar_jpu.o
>  obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
>  
> +obj-$(CONFIG_VIDEO_ROCKCHIP_ISP1)	+= rockchip/isp1/
>  obj-$(CONFIG_VIDEO_ROCKCHIP_RGA)	+= rockchip/rga/
>  
>  obj-y	+= omap/
> diff --git a/drivers/media/platform/rockchip/isp1/Makefile b/drivers/media/platform/rockchip/isp1/Makefile
> new file mode 100644
> index 000000000000..8f52f959398e
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/isp1/Makefile
> @@ -0,0 +1,7 @@
> +obj-$(CONFIG_VIDEO_ROCKCHIP_ISP1) += 	video_rkisp1.o
> +video_rkisp1-objs 	   += 	rkisp1.o \
> +				dev.o \
> +				regs.o \
> +				isp_stats.o \
> +				isp_params.o \
> +				capture.o
> diff --git a/drivers/media/platform/rockchip/isp1/capture.c b/drivers/media/platform/rockchip/isp1/capture.c
> new file mode 100644
> index 000000000000..a751a923ba5d
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/isp1/capture.c
> @@ -0,0 +1,1691 @@
> +/*
> + * Rockchip isp1 driver
> + *
> + * Copyright (C) 2017 Rockchip Electronics Co., Ltd.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/pm_runtime.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-fh.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/videobuf2-dma-contig.h>
> +#include "capture.h"
> +#include "rkisp1.h"
> +#include "regs.h"
> +
> +#define CIF_ISP_REQ_BUFS_MIN 1
> +#define CIF_ISP_REQ_BUFS_MAX 8
> +
> +/*
> + * mp sink source: isp
> + * sp sink source : isp, no dma now
> + * mp sink pad fmts: yuv 422, raw
> + * sp sink pad fmts: yuv422( source isp), yuv420......
> + * mp source fmts: yuv, raw, no jpeg now
> + * sp source fmts: yuv, rgb
> + */

Is this a left-over comment as a reminder to yourself? If so, remove it,
if not, then it needs to be expanded since it's not clear what the
purpose of this comment is.

> +
> +#define STREAM_PAD_SINK				0
> +#define STREAM_PAD_SOURCE			1
> +
> +#define STREAM_MAX_MP_RSZ_OUTPUT_WIDTH		4416
> +#define STREAM_MAX_MP_RSZ_OUTPUT_HEIGHT		3312
> +#define STREAM_MAX_SP_RSZ_OUTPUT_WIDTH		1920
> +#define STREAM_MAX_SP_RSZ_OUTPUT_HEIGHT		1080
> +#define STREAM_MIN_RSZ_OUTPUT_WIDTH		32
> +#define STREAM_MIN_RSZ_OUTPUT_HEIGHT		16
> +
> +#define STREAM_MAX_MP_SP_INPUT_WIDTH STREAM_MAX_MP_RSZ_OUTPUT_WIDTH
> +#define STREAM_MAX_MP_SP_INPUT_HEIGHT STREAM_MAX_MP_RSZ_OUTPUT_HEIGHT
> +#define STREAM_MIN_MP_SP_INPUT_WIDTH		32
> +#define STREAM_MIN_MP_SP_INPUT_HEIGHT		32
> +
> +/*
> + * crop accepts only yuv422 format
> + * resizer can accept yuv444,yuv422,yuv420 format, can output yuv422, yuv420,
> + * yuv444 format
> + * sp resizer has two data source: DMA-reader or crop
> + * mp resizer has only one data source:  crop
> + * if format is unsupported by path, crop and resizer should be bypassed
> + * (disabled)
> + */

Same for this comment.

> +
> +/* Get xsubs and ysubs for fourcc formats
> + *
> + * @xsubs: horizon color samples in a 4*4 matrix, for yuv

horizon -> horizontal

> + * @ysubs: vertical color samples in a 4*4 matrix, for yuv
> + */
> +static int fcc_xysubs(u32 fcc, u32 *xsubs, u32 *ysubs)
> +{
> +	switch (fcc) {
> +	case V4L2_PIX_FMT_GREY:
> +	case V4L2_PIX_FMT_YUV444M:
> +		*xsubs = 1;
> +		*ysubs = 1;
> +		break;
> +	case V4L2_PIX_FMT_YUYV:
> +	case V4L2_PIX_FMT_YVYU:
> +	case V4L2_PIX_FMT_VYUY:
> +	case V4L2_PIX_FMT_YUV422P:
> +	case V4L2_PIX_FMT_NV16:
> +	case V4L2_PIX_FMT_NV61:
> +	case V4L2_PIX_FMT_YVU422M:
> +		*xsubs = 2;
> +		*ysubs = 1;
> +		break;
> +	case V4L2_PIX_FMT_NV21:
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV21M:
> +	case V4L2_PIX_FMT_NV12M:
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_YVU420:
> +		*xsubs = 2;
> +		*ysubs = 2;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mbus_code_xysubs(u32 code, u32 *xsubs, u32 *ysubs)
> +{
> +	switch (code) {
> +	case MEDIA_BUS_FMT_YUYV8_2X8:
> +	case MEDIA_BUS_FMT_YUYV8_1X16:
> +	case MEDIA_BUS_FMT_YVYU8_1X16:
> +	case MEDIA_BUS_FMT_UYVY8_1X16:
> +	case MEDIA_BUS_FMT_VYUY8_1X16:
> +		*xsubs = 2;
> +		*ysubs = 1;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mbus_code_sp_in_fmt(u32 code, u32 *format)
> +{
> +	switch (code) {
> +	case MEDIA_BUS_FMT_YUYV8_2X8:
> +		*format = MI_CTRL_SP_INPUT_YUV422;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct capture_fmt mp_fmts[] = {
> +	/* yuv422 */
> +	{
> +		.fourcc = V4L2_PIX_FMT_YUYV,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 16 },
> +		.cplanes = 1,
> +		.mplanes = 1,
> +		.uv_swap = 0,
> +		.write_format = MI_CTRL_MP_WRITE_YUVINT,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_YVYU,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 16 },
> +		.cplanes = 1,
> +		.mplanes = 1,
> +		.uv_swap = 1,
> +		.write_format = MI_CTRL_MP_WRITE_YUVINT,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_VYUY,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 16 },
> +		.cplanes = 1,
> +		.mplanes = 1,
> +		.uv_swap = 1,
> +		.write_format = MI_CTRL_MP_WRITE_YUVINT,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_YUV422P,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8, 4, 4 },
> +		.cplanes = 3,
> +		.mplanes = 1,
> +		.uv_swap = 0,
> +		.write_format = MI_CTRL_MP_WRITE_YUV_PLA_OR_RAW8,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_NV16,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8, 16 },
> +		.cplanes = 2,
> +		.mplanes = 1,
> +		.uv_swap = 0,
> +		.write_format = MI_CTRL_MP_WRITE_YUV_SPLA,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_NV61,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8, 16 },
> +		.cplanes = 2,
> +		.mplanes = 1,
> +		.uv_swap = 1,
> +		.write_format = MI_CTRL_MP_WRITE_YUV_SPLA,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_YVU422M,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8, 8, 8 },
> +		.cplanes = 3,
> +		.mplanes = 3,
> +		.uv_swap = 1,
> +		.write_format = MI_CTRL_MP_WRITE_YUV_PLA_OR_RAW8,
> +	},
> +	/* yuv420 */
> +	{
> +		.fourcc = V4L2_PIX_FMT_NV21,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8, 16 },
> +		.cplanes = 2,
> +		.mplanes = 1,
> +		.uv_swap = 1,
> +		.write_format = MI_CTRL_MP_WRITE_YUV_SPLA,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_NV12,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8, 16 },
> +		.cplanes = 2,
> +		.mplanes = 1,
> +		.uv_swap = 0,
> +		.write_format = MI_CTRL_MP_WRITE_YUV_SPLA,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_NV21M,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8, 16 },
> +		.cplanes = 2,
> +		.mplanes = 2,
> +		.uv_swap = 1,
> +		.write_format = MI_CTRL_MP_WRITE_YUV_SPLA,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_NV12M,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8, 16 },
> +		.cplanes = 2,
> +		.mplanes = 2,
> +		.uv_swap = 0,
> +		.write_format = MI_CTRL_MP_WRITE_YUV_SPLA,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_YUV420,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8, 8, 8 },
> +		.cplanes = 3,
> +		.mplanes = 1,
> +		.uv_swap = 0,
> +		.write_format = MI_CTRL_MP_WRITE_YUV_PLA_OR_RAW8,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_YVU420,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8, 8, 8 },
> +		.cplanes = 3,
> +		.mplanes = 1,
> +		.uv_swap = 1,
> +		.write_format = MI_CTRL_MP_WRITE_YUV_PLA_OR_RAW8,
> +	},
> +	/* yuv444 */
> +	{
> +		.fourcc = V4L2_PIX_FMT_YUV444M,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8, 8, 8 },
> +		.cplanes = 3,
> +		.mplanes = 3,
> +		.uv_swap = 0,
> +		.write_format = MI_CTRL_MP_WRITE_YUV_PLA_OR_RAW8,
> +	},
> +	/* yuv400 */
> +	{
> +		.fourcc = V4L2_PIX_FMT_GREY,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8 },
> +		.cplanes = 1,
> +		.mplanes = 1,
> +		.uv_swap = 0,
> +		.write_format = MI_CTRL_MP_WRITE_YUVINT,
> +	},
> +	/* raw */
> +	{
> +		.fourcc = V4L2_PIX_FMT_SRGGB8,
> +		.fmt_type = FMT_BAYER,
> +		.bpp = { 8 },
> +		.mplanes = 1,
> +		.write_format = MI_CTRL_MP_WRITE_YUV_PLA_OR_RAW8,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_SGRBG8,
> +		.fmt_type = FMT_BAYER,
> +		.bpp = { 8 },
> +		.mplanes = 1,
> +		.write_format = MI_CTRL_MP_WRITE_YUV_PLA_OR_RAW8,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_SGBRG8,
> +		.fmt_type = FMT_BAYER,
> +		.bpp = { 8 },
> +		.mplanes = 1,
> +		.write_format = MI_CTRL_MP_WRITE_YUV_PLA_OR_RAW8,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_SBGGR8,
> +		.fmt_type = FMT_BAYER,
> +		.bpp = { 8 },
> +		.mplanes = 1,
> +		.write_format = MI_CTRL_MP_WRITE_YUV_PLA_OR_RAW8,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_SRGGB8,
> +		.fmt_type = FMT_BAYER,
> +		.bpp = { 10 },
> +		.mplanes = 1,
> +		.write_format = MI_CTRL_MP_WRITE_RAW12,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_SGRBG10,
> +		.fmt_type = FMT_BAYER,
> +		.bpp = { 10 },
> +		.mplanes = 1,
> +		.write_format = MI_CTRL_MP_WRITE_RAW12,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_SGBRG10,
> +		.fmt_type = FMT_BAYER,
> +		.bpp = { 10 },
> +		.mplanes = 1,
> +		.write_format = MI_CTRL_MP_WRITE_RAW12,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_SBGGR10,
> +		.fmt_type = FMT_BAYER,
> +		.bpp = { 10 },
> +		.mplanes = 1,
> +		.write_format = MI_CTRL_MP_WRITE_RAW12,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_SRGGB12,
> +		.fmt_type = FMT_BAYER,
> +		.bpp = { 12 },
> +		.mplanes = 1,
> +		.write_format = MI_CTRL_MP_WRITE_RAW12,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_SGRBG12,
> +		.fmt_type = FMT_BAYER,
> +		.bpp = { 12 },
> +		.mplanes = 1,
> +		.write_format = MI_CTRL_MP_WRITE_RAW12,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_SGBRG12,
> +		.fmt_type = FMT_BAYER,
> +		.bpp = { 12 },
> +		.mplanes = 1,
> +		.write_format = MI_CTRL_MP_WRITE_RAW12,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_SBGGR12,
> +		.fmt_type = FMT_BAYER,
> +		.bpp = { 12 },
> +		.mplanes = 1,
> +		.write_format = MI_CTRL_MP_WRITE_RAW12,
> +	},
> +};
> +
> +static const struct capture_fmt sp_fmts[] = {
> +	/* yuv422 */
> +	{
> +		.fourcc = V4L2_PIX_FMT_YUYV,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 16 },
> +		.cplanes = 1,
> +		.mplanes = 1,
> +		.uv_swap = 0,
> +		.write_format = MI_CTRL_SP_WRITE_INT,
> +		.output_format = MI_CTRL_SP_OUTPUT_YUV422,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_YVYU,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 16 },
> +		.cplanes = 1,
> +		.mplanes = 1,
> +		.uv_swap = 1,
> +		.write_format = MI_CTRL_SP_WRITE_INT,
> +		.output_format = MI_CTRL_SP_OUTPUT_YUV422,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_VYUY,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 16 },
> +		.cplanes = 1,
> +		.mplanes = 1,
> +		.uv_swap = 1,
> +		.write_format = MI_CTRL_SP_WRITE_INT,
> +		.output_format = MI_CTRL_SP_OUTPUT_YUV422,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_YUV422P,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8, 8, 8 },
> +		.cplanes = 3,
> +		.mplanes = 1,
> +		.uv_swap = 0,
> +		.write_format = MI_CTRL_SP_WRITE_PLA,
> +		.output_format = MI_CTRL_SP_OUTPUT_YUV422,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_NV16,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8, 16 },
> +		.cplanes = 2,
> +		.mplanes = 1,
> +		.uv_swap = 0,
> +		.write_format = MI_CTRL_SP_WRITE_SPLA,
> +		.output_format = MI_CTRL_SP_OUTPUT_YUV422,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_NV61,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8, 16 },
> +		.cplanes = 2,
> +		.mplanes = 1,
> +		.uv_swap = 1,
> +		.write_format = MI_CTRL_SP_WRITE_SPLA,
> +		.output_format = MI_CTRL_SP_OUTPUT_YUV422,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_YVU422M,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8, 8, 8 },
> +		.cplanes = 3,
> +		.mplanes = 3,
> +		.uv_swap = 1,
> +		.write_format = MI_CTRL_SP_WRITE_PLA,
> +		.output_format = MI_CTRL_SP_OUTPUT_YUV422,
> +	},
> +	/* yuv420 */
> +	{
> +		.fourcc = V4L2_PIX_FMT_NV21,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8, 16 },
> +		.cplanes = 2,
> +		.mplanes = 1,
> +		.uv_swap = 1,
> +		.write_format = MI_CTRL_SP_WRITE_SPLA,
> +		.output_format = MI_CTRL_SP_OUTPUT_YUV420,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_NV12,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8, 16 },
> +		.cplanes = 2,
> +		.mplanes = 1,
> +		.uv_swap = 0,
> +		.write_format = MI_CTRL_SP_WRITE_SPLA,
> +		.output_format = MI_CTRL_SP_OUTPUT_YUV420,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_NV21M,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8, 16 },
> +		.cplanes = 2,
> +		.mplanes = 2,
> +		.uv_swap = 1,
> +		.write_format = MI_CTRL_SP_WRITE_SPLA,
> +		.output_format = MI_CTRL_SP_OUTPUT_YUV420,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_NV12M,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8, 16 },
> +		.cplanes = 2,
> +		.mplanes = 2,
> +		.uv_swap = 0,
> +		.write_format = MI_CTRL_SP_WRITE_SPLA,
> +		.output_format = MI_CTRL_SP_OUTPUT_YUV420,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_YUV420,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8, 8, 8 },
> +		.cplanes = 3,
> +		.mplanes = 1,
> +		.uv_swap = 0,
> +		.write_format = MI_CTRL_SP_WRITE_PLA,
> +		.output_format = MI_CTRL_SP_OUTPUT_YUV420,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_YVU420,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8, 8, 8 },
> +		.cplanes = 3,
> +		.mplanes = 1,
> +		.uv_swap = 1,
> +		.write_format = MI_CTRL_SP_WRITE_PLA,
> +		.output_format = MI_CTRL_SP_OUTPUT_YUV420,
> +	},
> +	/* yuv444 */
> +	{
> +		.fourcc = V4L2_PIX_FMT_YUV444M,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8, 8, 8 },
> +		.cplanes = 3,
> +		.mplanes = 3,
> +		.uv_swap = 0,
> +		.write_format = MI_CTRL_SP_WRITE_PLA,
> +		.output_format = MI_CTRL_SP_OUTPUT_YUV444,
> +	},
> +	/* yuv400 */
> +	{
> +		.fourcc = V4L2_PIX_FMT_GREY,
> +		.fmt_type = FMT_YUV,
> +		.bpp = { 8 },
> +		.cplanes = 1,
> +		.mplanes = 1,
> +		.uv_swap = 0,
> +		.write_format = MI_CTRL_SP_WRITE_INT,
> +		.output_format = MI_CTRL_SP_OUTPUT_YUV400,
> +	},
> +	/* rgb */
> +	{
> +		.fourcc = V4L2_PIX_FMT_RGB24,
> +		.fmt_type = FMT_RGB,
> +		.bpp = { 24 },
> +		.mplanes = 1,
> +		.write_format = MI_CTRL_SP_WRITE_PLA,
> +		.output_format = MI_CTRL_SP_OUTPUT_RGB888,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_RGB565,
> +		.fmt_type = FMT_RGB,
> +		.bpp = { 16 },
> +		.mplanes = 1,
> +		.write_format = MI_CTRL_SP_WRITE_PLA,
> +		.output_format = MI_CTRL_SP_OUTPUT_RGB565,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_BGR666,
> +		.fmt_type = FMT_RGB,
> +		.bpp = { 18 },
> +		.mplanes = 1,
> +		.write_format = MI_CTRL_SP_WRITE_PLA,
> +		.output_format = MI_CTRL_SP_OUTPUT_RGB666,
> +	},
> +};
> +
> +static struct stream_config rkisp1_mp_stream_config = {
> +	.fmts = mp_fmts,
> +	.fmt_size = ARRAY_SIZE(mp_fmts),
> +	/* constrains */

constrains -> constraints

> +	.max_rsz_width = STREAM_MAX_MP_RSZ_OUTPUT_WIDTH,
> +	.max_rsz_height = STREAM_MAX_MP_RSZ_OUTPUT_HEIGHT,
> +	.min_rsz_width = STREAM_MIN_RSZ_OUTPUT_WIDTH,
> +	.min_rsz_height = STREAM_MIN_RSZ_OUTPUT_HEIGHT,
> +	/* registers */
> +	.rsz = {
> +		.ctrl = CIF_MRSZ_CTRL,
> +		.scale_hy = CIF_MRSZ_SCALE_HY,
> +		.scale_hcr = CIF_MRSZ_SCALE_HCR,
> +		.scale_hcb = CIF_MRSZ_SCALE_HCB,
> +		.scale_vy = CIF_MRSZ_SCALE_VY,
> +		.scale_vc = CIF_MRSZ_SCALE_VC,
> +		.scale_lut = CIF_MRSZ_SCALE_LUT,
> +		.scale_lut_addr = CIF_MRSZ_SCALE_LUT_ADDR,
> +		.scale_hy_shd = CIF_MRSZ_SCALE_HY_SHD,
> +		.scale_hcr_shd = CIF_MRSZ_SCALE_HCR_SHD,
> +		.scale_hcb_shd = CIF_MRSZ_SCALE_HCB_SHD,
> +		.scale_vy_shd = CIF_MRSZ_SCALE_VY_SHD,
> +		.scale_vc_shd = CIF_MRSZ_SCALE_VC_SHD,
> +		.phase_hy = CIF_MRSZ_PHASE_HY,
> +		.phase_hc = CIF_MRSZ_PHASE_HC,
> +		.phase_vy = CIF_MRSZ_PHASE_VY,
> +		.phase_vc = CIF_MRSZ_PHASE_VC,
> +		.ctrl_shd = CIF_MRSZ_CTRL_SHD,
> +		.phase_hy_shd = CIF_MRSZ_PHASE_HY_SHD,
> +		.phase_hc_shd = CIF_MRSZ_PHASE_HC_SHD,
> +		.phase_vy_shd = CIF_MRSZ_PHASE_VY_SHD,
> +		.phase_vc_shd = CIF_MRSZ_PHASE_VC_SHD,
> +	},
> +	.dual_crop = {
> +		.ctrl = CIF_DUAL_CROP_CTRL,
> +		.yuvmode_mask = CIF_DUAL_CROP_MP_MODE_YUV,
> +		.rawmode_mask = CIF_DUAL_CROP_MP_MODE_RAW,
> +		.h_offset = CIF_DUAL_CROP_M_H_OFFS,
> +		.v_offset = CIF_DUAL_CROP_M_V_OFFS,
> +		.h_size = CIF_DUAL_CROP_M_H_SIZE,
> +		.v_size = CIF_DUAL_CROP_M_V_SIZE,
> +	},
> +	.mi = {
> +		.y_size_init = CIF_MI_MP_Y_SIZE_INIT,
> +		.cb_size_init = CIF_MI_MP_CB_SIZE_INIT,
> +		.cr_size_init = CIF_MI_MP_CR_SIZE_INIT,
> +		.y_base_ad_init = CIF_MI_MP_Y_BASE_AD_INIT,
> +		.cb_base_ad_init = CIF_MI_MP_CB_BASE_AD_INIT,
> +		.cr_base_ad_init = CIF_MI_MP_CR_BASE_AD_INIT,
> +		.y_offs_cnt_init = CIF_MI_MP_Y_OFFS_CNT_INIT,
> +		.cb_offs_cnt_init = CIF_MI_MP_CB_OFFS_CNT_INIT,
> +		.cr_offs_cnt_init = CIF_MI_MP_CR_OFFS_CNT_INIT,
> +	},
> +};
> +
> +static struct stream_config rkisp1_sp_stream_config = {
> +	.fmts = sp_fmts,
> +	.fmt_size = ARRAY_SIZE(sp_fmts),
> +	/* constrains */
> +	.max_rsz_width = STREAM_MAX_SP_RSZ_OUTPUT_WIDTH,
> +	.max_rsz_height = STREAM_MAX_SP_RSZ_OUTPUT_HEIGHT,
> +	.min_rsz_width = STREAM_MIN_RSZ_OUTPUT_WIDTH,
> +	.min_rsz_height = STREAM_MIN_RSZ_OUTPUT_HEIGHT,
> +	/* registers */
> +	.rsz = {
> +		.ctrl = CIF_SRSZ_CTRL,
> +		.scale_hy = CIF_SRSZ_SCALE_HY,
> +		.scale_hcr = CIF_SRSZ_SCALE_HCR,
> +		.scale_hcb = CIF_SRSZ_SCALE_HCB,
> +		.scale_vy = CIF_SRSZ_SCALE_VY,
> +		.scale_vc = CIF_SRSZ_SCALE_VC,
> +		.scale_lut = CIF_SRSZ_SCALE_LUT,
> +		.scale_lut_addr = CIF_SRSZ_SCALE_LUT_ADDR,
> +		.scale_hy_shd = CIF_SRSZ_SCALE_HY_SHD,
> +		.scale_hcr_shd = CIF_SRSZ_SCALE_HCR_SHD,
> +		.scale_hcb_shd = CIF_SRSZ_SCALE_HCB_SHD,
> +		.scale_vy_shd = CIF_SRSZ_SCALE_VY_SHD,
> +		.scale_vc_shd = CIF_SRSZ_SCALE_VC_SHD,
> +		.phase_hy = CIF_SRSZ_PHASE_HY,
> +		.phase_hc = CIF_SRSZ_PHASE_HC,
> +		.phase_vy = CIF_SRSZ_PHASE_VY,
> +		.phase_vc = CIF_SRSZ_PHASE_VC,
> +		.ctrl_shd = CIF_SRSZ_CTRL_SHD,
> +		.phase_hy_shd = CIF_SRSZ_PHASE_HY_SHD,
> +		.phase_hc_shd = CIF_SRSZ_PHASE_HC_SHD,
> +		.phase_vy_shd = CIF_SRSZ_PHASE_VY_SHD,
> +		.phase_vc_shd = CIF_SRSZ_PHASE_VC_SHD,
> +	},
> +	.dual_crop = {
> +		.ctrl = CIF_DUAL_CROP_CTRL,
> +		.yuvmode_mask = CIF_DUAL_CROP_SP_MODE_YUV,
> +		.rawmode_mask = CIF_DUAL_CROP_SP_MODE_RAW,
> +		.h_offset = CIF_DUAL_CROP_S_H_OFFS,
> +		.v_offset = CIF_DUAL_CROP_S_V_OFFS,
> +		.h_size = CIF_DUAL_CROP_S_H_SIZE,
> +		.v_size = CIF_DUAL_CROP_S_V_SIZE,
> +	},
> +	.mi = {
> +		.y_size_init = CIF_MI_SP_Y_SIZE_INIT,
> +		.cb_size_init = CIF_MI_SP_CB_SIZE_INIT,
> +		.cr_size_init = CIF_MI_SP_CR_SIZE_INIT,
> +		.y_base_ad_init = CIF_MI_SP_Y_BASE_AD_INIT,
> +		.cb_base_ad_init = CIF_MI_SP_CB_BASE_AD_INIT,
> +		.cr_base_ad_init = CIF_MI_SP_CR_BASE_AD_INIT,
> +		.y_offs_cnt_init = CIF_MI_SP_Y_OFFS_CNT_INIT,
> +		.cb_offs_cnt_init = CIF_MI_SP_CB_OFFS_CNT_INIT,
> +		.cr_offs_cnt_init = CIF_MI_SP_CR_OFFS_CNT_INIT,
> +	},
> +};
> +
> +static const
> +struct capture_fmt *find_fmt(struct rkisp1_stream *stream, const u32 pixelfmt)
> +{
> +	const struct capture_fmt *fmt;
> +	int i;
> +
> +	for (i = 0; i < stream->config->fmt_size; i++) {
> +		fmt = &stream->config->fmts[i];
> +		if (fmt->fourcc == pixelfmt)
> +			return fmt;
> +	}
> +	return NULL;
> +}
> +
> +static int rkisp1_config_dcrop(struct rkisp1_stream *stream, bool async)
> +{
> +	struct rkisp1_device *dev = stream->ispdev;
> +	struct v4l2_rect *dcrop = &stream->dcrop;
> +	struct v4l2_rect *input_win;
> +
> +	input_win = rkisp1_get_isp_sd_win(dev);
> +
> +	if (dcrop->width == input_win->width &&
> +	    dcrop->height == input_win->height &&
> +	    dcrop->left == 0 && dcrop->top == 0) {
> +		disable_dcrop(stream, async);
> +		return 0;
> +	}
> +
> +	config_dcrop(stream, dcrop, async);
> +
> +	return 0;
> +}
> +
> +static int rkisp1_config_rsz(struct rkisp1_stream *stream, bool async)
> +{
> +	struct rkisp1_device *dev = stream->ispdev;
> +	struct v4l2_pix_format_mplane output_fmt = stream->out_fmt;
> +	struct capture_fmt *output_isp_fmt = &stream->out_isp_fmt;
> +	struct ispsd_out_fmt *input_isp_fmt = rkisp1_get_ispsd_out_fmt(dev);
> +	struct v4l2_rect in_y, in_c, out_y, out_c;
> +	u32 xsubs_in, ysubs_in, xsubs_out, ysubs_out;
> +
> +	if (input_isp_fmt->fmt_type == FMT_BAYER)
> +		goto disable;
> +
> +	/* set input and output sizes for scale calculation */
> +	in_y.width = stream->dcrop.width;
> +	in_y.height = stream->dcrop.height;
> +	out_y.width = output_fmt.width;
> +	out_y.height = output_fmt.height;
> +
> +	if (mbus_code_xysubs(input_isp_fmt->mbus_code, &xsubs_in, &ysubs_in)) {
> +		v4l2_err(&dev->v4l2_dev, "Not xsubs/ysubs found\n");
> +		return -EINVAL;
> +	}
> +	in_c.width = in_y.width / xsubs_in;
> +	in_c.height = in_y.height / ysubs_in;
> +
> +	if (output_isp_fmt->fmt_type == FMT_YUV) {
> +		fcc_xysubs(output_isp_fmt->fourcc, &xsubs_out, &ysubs_out);
> +		out_c.width = out_y.width / xsubs_out;
> +		out_c.height = out_y.height / ysubs_out;
> +	} else {
> +		out_c.width = out_y.width / xsubs_in;
> +		out_c.height = out_y.height / ysubs_in;
> +	}
> +
> +	if (in_c.width == out_c.width && in_c.height == out_c.height)
> +		goto disable;
> +
> +	/* set RSZ input and output */
> +	v4l2_dbg(1, rkisp1_debug, &dev->v4l2_dev,
> +		 "stream: %d fmt: %08x %dx%d -> fmt: %08x %dx%d\n",
> +		 stream->id, input_isp_fmt->mbus_code,
> +		 stream->dcrop.width, stream->dcrop.height,
> +		 output_isp_fmt->fourcc, output_fmt.width,
> +		 output_fmt.height);
> +	v4l2_dbg(1, rkisp1_debug, &dev->v4l2_dev,
> +		 "chroma scaling %dx%d -> %dx%d\n",
> +		 in_c.width, in_c.height, out_c.width, out_c.height);
> +
> +	/* calculate and set scale */
> +	config_rsz(stream, &in_y, &in_c, &out_y, &out_c, async);
> +
> +	if (rkisp1_debug)
> +		dump_rsz_regs(stream);
> +
> +	return 0;
> +
> +disable:
> +	disable_rsz(stream, async);
> +
> +	return 0;
> +}
> +
> +/***************************** stream operations*******************************/
> +static int mp_config_mi(struct rkisp1_stream *stream)
> +{
> +	void __iomem *base = stream->ispdev->base_addr;
> +
> +       /*
> +	* plane_fmt[0].sizeimage is total size of all planes for single
> +	* memory plane formats, so calculate the size explicitly.
> +	*/
> +	mi_set_y_size(stream, stream->out_fmt.plane_fmt[0].bytesperline *
> +			 stream->out_fmt.height);
> +	mi_set_cb_size(stream, stream->out_fmt.plane_fmt[1].sizeimage);
> +	mi_set_cr_size(stream, stream->out_fmt.plane_fmt[2].sizeimage);
> +
> +	mp_frame_end_int_enable(base);
> +	if (stream->out_isp_fmt.uv_swap)
> +		mp_set_uv_swap(base);
> +
> +	config_mi_ctrl(stream);
> +	mp_mi_ctrl_set_format(base, stream->out_isp_fmt.write_format);
> +	mp_mi_ctrl_autoupdate_en(base);
> +
> +	return 0;
> +}
> +
> +static int sp_config_mi(struct rkisp1_stream *stream)
> +{
> +	void __iomem *base = stream->ispdev->base_addr;
> +	struct rkisp1_device *dev = stream->ispdev;
> +	struct capture_fmt *output_isp_fmt = &stream->out_isp_fmt;
> +	struct ispsd_out_fmt *input_isp_fmt = rkisp1_get_ispsd_out_fmt(dev);
> +	u32 sp_in_fmt;
> +
> +	if (mbus_code_sp_in_fmt(input_isp_fmt->mbus_code, &sp_in_fmt)) {
> +		v4l2_err(&dev->v4l2_dev, "Can't find the input format\n");
> +		return -EINVAL;
> +	}
> +	mi_set_y_size(stream, stream->out_fmt.plane_fmt[0].bytesperline *
> +		      stream->out_fmt.height);
> +	mi_set_cb_size(stream, stream->out_fmt.plane_fmt[1].sizeimage);
> +	mi_set_cr_size(stream, stream->out_fmt.plane_fmt[2].sizeimage);
> +
> +	sp_set_y_width(base, stream->out_fmt.width);
> +	sp_set_y_height(base, stream->out_fmt.height);
> +	sp_set_y_line_length(base, stream->u.sp.y_stride);
> +
> +	sp_frame_end_int_enable(base);
> +	if (output_isp_fmt->uv_swap)
> +		sp_set_uv_swap(base);
> +
> +	config_mi_ctrl(stream);
> +	sp_mi_ctrl_set_format(base, stream->out_isp_fmt.write_format |
> +			      sp_in_fmt | output_isp_fmt->output_format);
> +
> +	sp_mi_ctrl_autoupdate_en(base);
> +
> +	return 0;
> +}
> +
> +static struct rkisp1_stream *get_other_stream(struct rkisp1_stream *stream)
> +{
> +	struct rkisp1_device *dev = stream->ispdev;
> +
> +	return &dev->stream[stream->id ^ 1];
> +}
> +
> +static int mp_check_against(struct rkisp1_stream *stream)
> +{
> +	struct rkisp1_stream *sp = get_other_stream(stream);
> +
> +	if (sp->state == RKISP1_STATE_STREAMING)
> +		return -EAGAIN;
> +
> +	return 0;
> +}

Hmm, can you add some comments before these functions? I noticed very few comments in
this driver, and it really could use some. E.g. 'mp_check_against': it's not clear
what it checks against. And what's _mi in sp_config_mi?

I know, adding comments is a bit of a chore, but this driver really could use some
more of that.

> +
> +static int sp_check_against(struct rkisp1_stream *stream)
> +{
> +	struct rkisp1_stream *mp = get_other_stream(stream);
> +	struct v4l2_device *v4l2_dev = &stream->ispdev->v4l2_dev;
> +
> +	if (mp->u.mp.raw_enable && mp->state == RKISP1_STATE_STREAMING) {
> +		v4l2_err(v4l2_dev, "can't start SP path when MP RAW active\n");
> +		return -EBUSY;
> +	}
> +
> +	if (mp->state == RKISP1_STATE_STREAMING)
> +		return -EAGAIN;
> +
> +	return 0;
> +}
> +
> +static void mp_enable_mi(struct rkisp1_stream *stream)
> +{
> +	void __iomem *base = stream->ispdev->base_addr;
> +	struct capture_fmt *isp_fmt = &stream->out_isp_fmt;
> +
> +	mi_ctrl_mp_disable(base);
> +	if (isp_fmt->fmt_type == FMT_BAYER)
> +		mi_ctrl_mpraw_enable(base);
> +	else if (isp_fmt->fmt_type == FMT_YUV)
> +		mi_ctrl_mpyuv_enable(base);
> +}
> +
> +static void sp_enable_mi(struct rkisp1_stream *stream)
> +{
> +	void __iomem *base = stream->ispdev->base_addr;
> +
> +	mi_ctrl_spyuv_enable(base);
> +}
> +
> +static void mp_disable_mi(struct rkisp1_stream *stream)
> +{
> +	void __iomem *base = stream->ispdev->base_addr;
> +
> +	mi_ctrl_mp_disable(base);
> +}
> +
> +static void sp_disable_mi(struct rkisp1_stream *stream)
> +{
> +	void __iomem *base = stream->ispdev->base_addr;
> +
> +	mi_ctrl_spyuv_disable(base);
> +}
> +
> +static void update_mi(struct rkisp1_stream *stream)
> +{
> +	struct rkisp1_dummy_buffer *dummy_buf = &stream->dummy_buf;
> +
> +	if (stream->next_buf) {
> +		mi_set_y_addr(stream,
> +			stream->next_buf->buff_addr[RKISP1_PLANE_Y]);
> +		mi_set_cb_addr(stream,
> +			stream->next_buf->buff_addr[RKISP1_PLANE_CB]);
> +		mi_set_cr_addr(stream,
> +			stream->next_buf->buff_addr[RKISP1_PLANE_CR]);
> +	} else {
> +		/* Throw data to dummy space */
> +		mi_set_y_addr(stream, dummy_buf->dma_addr);
> +		mi_set_cb_addr(stream, dummy_buf->dma_addr);
> +		mi_set_cr_addr(stream, dummy_buf->dma_addr);
> +	}
> +
> +	mi_set_y_offset(stream, 0);
> +	mi_set_cb_offset(stream, 0);
> +	mi_set_cr_offset(stream, 0);
> +}
> +
> +static void mp_stop_mi(struct rkisp1_stream *stream)
> +{
> +	void __iomem *base = stream->ispdev->base_addr;
> +
> +	if (stream->state != RKISP1_STATE_STREAMING)
> +		return;
> +	/*mp_frame_end_int_disable(base);*/
> +	stream->ops->clr_frame_end_int(base);
> +	stream->ops->disable_mi(stream);
> +}
> +
> +static void sp_stop_mi(struct rkisp1_stream *stream)
> +{
> +	void __iomem *base = stream->ispdev->base_addr;
> +
> +	if (stream->state != RKISP1_STATE_STREAMING)
> +		return;
> +	/*sp_frame_end_int_disable(base);*/
> +	stream->ops->clr_frame_end_int(base);
> +	stream->ops->disable_mi(stream);
> +}
> +
> +static struct streams_ops rkisp1_mp_streams_ops = {
> +	.check_against = mp_check_against,
> +	.config_mi = mp_config_mi,
> +	.enable_mi = mp_enable_mi,
> +	.disable_mi = mp_disable_mi,
> +	.stop_mi = mp_stop_mi,
> +	.set_data_path = mp_set_data_path,
> +	.clr_frame_end_int = mp_clr_frame_end_int,
> +	.is_frame_end_int_masked = mp_is_frame_end_int_masked,
> +};
> +
> +static struct streams_ops rkisp1_sp_streams_ops = {
> +	.check_against = sp_check_against,
> +	.config_mi = sp_config_mi,
> +	.enable_mi = sp_enable_mi,
> +	.disable_mi = sp_disable_mi,
> +	.stop_mi = sp_stop_mi,
> +	.set_data_path = sp_set_data_path,
> +	.clr_frame_end_int = sp_clr_frame_end_int,
> +	.is_frame_end_int_masked = sp_is_frame_end_int_masked,
> +};
> +
> +static void rkisp1_stream_stop(struct rkisp1_stream *stream)
> +{
> +	struct rkisp1_device *dev = stream->ispdev;
> +	struct v4l2_device *v4l2_dev = &dev->v4l2_dev;
> +	int ret = 0;
> +
> +	stream->stop = true;
> +	ret = wait_event_timeout(stream->done,
> +				 stream->state != RKISP1_STATE_STREAMING,
> +				 msecs_to_jiffies(1000));
> +	if (!ret) {
> +		v4l2_warn(v4l2_dev, "waiting on event return error %d\n", ret);
> +		stream->ops->stop_mi(stream);
> +		stream->stop = false;
> +		stream->state = RKISP1_STATE_READY;
> +	}
> +	disable_dcrop(stream, true);
> +	disable_rsz(stream, true);
> +}
> +
> +static int mi_frame_end(struct rkisp1_stream *stream)
> +{
> +	struct rkisp1_isp_subdev *isp_sd = &stream->ispdev->isp_sdev;
> +	struct capture_fmt *isp_fmt = &stream->out_isp_fmt;
> +	unsigned long lock_flags = 0;
> +	int i = 0;
> +
> +	if (stream->curr_buf) {
> +		/* Dequeue a filled buffer */
> +		for (i = 0; i < isp_fmt->mplanes; i++) {
> +			u32 payload_size =
> +				stream->out_fmt.plane_fmt[i].sizeimage;
> +			vb2_set_plane_payload(
> +				&stream->curr_buf->vb.vb2_buf, i,
> +				payload_size);
> +		}
> +		stream->curr_buf->vb.sequence =
> +				atomic_read(&isp_sd->frm_sync_seq) - 1;
> +		stream->curr_buf->vb.vb2_buf.timestamp = ktime_get_ns();
> +		vb2_buffer_done(&stream->curr_buf->vb.vb2_buf,
> +				VB2_BUF_STATE_DONE);
> +	}
> +
> +	/* Next frame is writing to it */
> +	stream->curr_buf = stream->next_buf;
> +	stream->next_buf = NULL;
> +
> +	/* Set up an empty buffer for the next-next frame */
> +	spin_lock_irqsave(&stream->vbq_lock, lock_flags);
> +	if (!list_empty(&stream->buf_queue)) {
> +		stream->next_buf = list_first_entry(&stream->buf_queue,
> +					struct rkisp1_buffer, queue);
> +		list_del(&stream->next_buf->queue);
> +	}
> +
> +	spin_unlock_irqrestore(&stream->vbq_lock, lock_flags);
> +
> +	update_mi(stream);
> +
> +	return 0;
> +}
> +
> +/*
> + * Videobuf2 operations.
> + */
> +static int rkisp1_start(struct rkisp1_stream *stream)
> +{
> +	void __iomem *base = stream->ispdev->base_addr;
> +	int ret;
> +
> +	stream->ops->set_data_path(base);
> +	ret = stream->ops->config_mi(stream);
> +	if (ret)
> +		return ret;
> +
> +	/* Set up an buffer for the next frame */
> +	mi_frame_end(stream);
> +	/* Update shadow register */
> +	force_cfg_update(base);
> +	/* Set up an buffer for the next-next frame */
> +	mi_frame_end(stream);
> +
> +	stream->ops->enable_mi(stream);
> +	stream->state = RKISP1_STATE_STREAMING;
> +
> +	return 0;
> +}
> +
> +static int rkisp1_restart(struct rkisp1_stream *stream)
> +{
> +	struct rkisp1_device *dev = stream->ispdev;
> +	int ret;
> +
> +	rkisp1_stream_stop(stream);
> +
> +	ret = dev->pipe.set_stream(&dev->pipe, false);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = rkisp1_start(stream);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int rkisp1_queue_setup(struct vb2_queue *queue,
> +			      unsigned int *num_buffers,
> +			      unsigned int *num_planes,
> +			      unsigned int sizes[],
> +			      struct device *alloc_devs[])
> +{
> +	struct rkisp1_stream *stream = queue->drv_priv;
> +	struct rkisp1_device *isp_dev = stream->ispdev;
> +	const struct v4l2_pix_format_mplane *pixm = &stream->out_fmt;
> +	const struct capture_fmt *isp_fmt = &stream->out_isp_fmt;
> +	u32 i;
> +
> +	*num_buffers = clamp_t(u32, *num_buffers, CIF_ISP_REQ_BUFS_MIN,
> +			       CIF_ISP_REQ_BUFS_MAX);

Since min_buffers_needed is set to CIF_ISP_REQ_BUFS_MIN, then you don't need to check
against CIF_ISP_REQ_BUFS_MIN again.

> +	*num_planes = isp_fmt->mplanes;
> +
> +	for (i = 0; i < isp_fmt->mplanes; i++) {
> +		const struct v4l2_plane_pix_format *plane_fmt;
> +
> +		plane_fmt = &pixm->plane_fmt[i];
> +
> +		sizes[i] = plane_fmt->sizeimage;
> +		alloc_devs[i] = isp_dev->dev;

You don't need this. Just set queue->dev to isp_dev->dev when initializing the queue.

alloc_devs[] is only needed if the device would differ per-plane (seen in weird
Samsung exynos hardware).

> +	}
> +
> +	v4l2_dbg(1, rkisp1_debug, &isp_dev->v4l2_dev, "%s count %d, size %d\n",
> +		 v4l2_type_names[queue->type], *num_buffers, sizes[0]);
> +
> +	return 0;
> +}
> +
> +static void rkisp1_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct rkisp1_buffer *ispbuf = to_rkisp1_buffer(vbuf);
> +	struct vb2_queue *queue = vb->vb2_queue;
> +	struct rkisp1_stream *stream = queue->drv_priv;
> +	unsigned long lock_flags = 0;
> +	struct v4l2_pix_format_mplane *pixm = &stream->out_fmt;
> +	struct capture_fmt *isp_fmt = &stream->out_isp_fmt;
> +	int i;
> +
> +	memset(ispbuf->buff_addr, 0, sizeof(ispbuf->buff_addr));
> +	for (i = 0; i < isp_fmt->mplanes; i++)
> +		ispbuf->buff_addr[i] = vb2_dma_contig_plane_dma_addr(vb, i);
> +
> +	if (isp_fmt->mplanes == 1) {
> +		for (i = 0; i < isp_fmt->cplanes - 1; i++) {
> +			ispbuf->buff_addr[i + 1] =
> +				ispbuf->buff_addr[i] +
> +				pixm->plane_fmt[i].bytesperline *
> +				pixm->height;
> +		}
> +	}
> +
> +	spin_lock_irqsave(&stream->vbq_lock, lock_flags);
> +	list_add_tail(&ispbuf->queue, &stream->buf_queue);
> +	spin_unlock_irqrestore(&stream->vbq_lock, lock_flags);
> +}
> +
> +static int rkisp1_create_dummy_buf(struct rkisp1_stream *stream)
> +{
> +	struct rkisp1_dummy_buffer *dummy_buf = &stream->dummy_buf;
> +	struct rkisp1_device *dev = stream->ispdev;
> +
> +	/* get a minimum size */
> +	dummy_buf->size = max3(stream->out_fmt.plane_fmt[0].bytesperline *
> +		stream->out_fmt.height,
> +		stream->out_fmt.plane_fmt[1].sizeimage,
> +		stream->out_fmt.plane_fmt[2].sizeimage);
> +
> +	dummy_buf->vaddr = dma_alloc_coherent(dev->dev, dummy_buf->size,
> +					      &dummy_buf->dma_addr,
> +					      GFP_KERNEL);
> +	if (!dummy_buf->vaddr) {
> +		v4l2_err(&dev->v4l2_dev,
> +			 "Failed to allocate the memory for dummy buffer\n");
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +static void rkisp1_destory_dummy_buf(struct rkisp1_stream *stream)
> +{
> +	struct rkisp1_dummy_buffer *dummy_buf = &stream->dummy_buf;
> +	struct rkisp1_device *dev = stream->ispdev;
> +
> +	dma_free_coherent(dev->dev, dummy_buf->size,
> +			  dummy_buf->vaddr, dummy_buf->dma_addr);
> +}
> +
> +static void rkisp1_stop_streaming(struct vb2_queue *queue)
> +{
> +	struct rkisp1_stream *stream = queue->drv_priv;
> +	struct rkisp1_vdev_node *node = &stream->vnode;
> +	struct rkisp1_device *dev = stream->ispdev;
> +	struct v4l2_device *v4l2_dev = &dev->v4l2_dev;
> +	struct rkisp1_buffer *buf;
> +	unsigned long lock_flags = 0;
> +	int ret;
> +	LIST_HEAD(queued_buffers);
> +
> +	rkisp1_stream_stop(stream);
> +	ret = dev->pipe.set_stream(&dev->pipe, false);
> +	if (ret < 0)
> +		return;
> +
> +	stream->state = RKISP1_STATE_READY;
> +
> +	spin_lock_irqsave(&stream->vbq_lock, lock_flags);
> +	if (stream->curr_buf) {
> +		list_add_tail(&stream->curr_buf->queue, &stream->buf_queue);
> +		stream->curr_buf = NULL;
> +	}
> +	if (stream->next_buf) {
> +		list_add_tail(&stream->next_buf->queue, &stream->buf_queue);
> +		stream->next_buf = NULL;
> +	}
> +	while (!list_empty(&stream->buf_queue)) {
> +		buf = list_first_entry(&stream->buf_queue,
> +				       struct rkisp1_buffer, queue);
> +		list_del(&buf->queue);
> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> +	}
> +	spin_unlock_irqrestore(&stream->vbq_lock, lock_flags);
> +
> +	ret = dev->pipe.close(&dev->pipe);
> +	if (ret < 0) {
> +		v4l2_err(v4l2_dev, "pipeline close failed error:%d\n", ret);
> +		return;
> +	}
> +
> +	media_pipeline_stop(&node->vdev.entity);
> +
> +	rkisp1_destory_dummy_buf(stream);
> +}
> +
> +static int
> +rkisp1_start_streaming(struct vb2_queue *queue, unsigned int count)
> +{
> +	struct rkisp1_stream *stream = queue->drv_priv;
> +	struct rkisp1_vdev_node *node = &stream->vnode;
> +	struct rkisp1_device *dev = stream->ispdev;
> +	struct v4l2_device *v4l2_dev = &dev->v4l2_dev;
> +	int ret;
> +
> +	ret = rkisp1_create_dummy_buf(stream);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = media_pipeline_start(&node->vdev.entity, &dev->pipe.pipe);
> +	if (ret < 0) {
> +		v4l2_err(&dev->v4l2_dev, "start pipeline failed %d\n", ret);
> +		goto err;
> +	}
> +
> +	ret = dev->pipe.open(&dev->pipe, &node->vdev.entity, true);
> +	if (ret < 0) {
> +		v4l2_err(v4l2_dev, "open cif pipeline failed %d\n", ret);
> +		goto err;
> +	}
> +
> +	if (stream->state != RKISP1_STATE_READY) {
> +		v4l2_err(v4l2_dev, "stream not enabled\n");
> +		ret = -EBUSY;
> +		goto err;
> +	}
> +
> +	ret = stream->ops->check_against(stream);
> +	if (ret == -EAGAIN) {
> +		struct rkisp1_stream *other;
> +
> +		other = get_other_stream(stream);
> +		if (other)
> +			rkisp1_restart(other);
> +	} else if (ret == -EBUSY) {
> +		goto err;
> +	}
> +
> +	ret = rkisp1_start(stream);
> +	if (ret < 0)
> +		goto err;
> +
> +	ret = rkisp1_config_rsz(stream, false);
> +	if (ret < 0) {
> +		v4l2_err(v4l2_dev, "failed with error %d\n", ret);
> +		goto err;
> +	}
> +
> +	ret = rkisp1_config_dcrop(stream, false);
> +	if (ret < 0) {
> +		v4l2_err(v4l2_dev, "failed with error %d\n", ret);
> +		goto err;
> +	}
> +
> +	/* pipeline stream on */
> +	ret = dev->pipe.set_stream(&dev->pipe, true);
> +	if (ret < 0)
> +		goto err;
> +	return 0;
> +
> +err:
> +	rkisp1_destory_dummy_buf(stream);
> +
> +	return ret;
> +}
> +
> +static struct vb2_ops rkisp1_vb2_ops = {
> +	.queue_setup = rkisp1_queue_setup,
> +	.buf_queue = rkisp1_buf_queue,
> +	.wait_prepare = vb2_ops_wait_prepare,
> +	.wait_finish = vb2_ops_wait_finish,
> +	.stop_streaming = rkisp1_stop_streaming,
> +	.start_streaming = rkisp1_start_streaming,
> +};
> +
> +static int rkisp_init_vb2_queue(struct vb2_queue *q,
> +				struct rkisp1_stream *stream,
> +				enum v4l2_buf_type buf_type)
> +{
> +	struct rkisp1_vdev_node *node;
> +
> +	node = queue_to_node(q);
> +
> +	q->type = buf_type;
> +	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;

Don't use VB2_USERPTR unless there is an iommu that would allow you to
use a malloc()ed buffer. Usually that's not the case for dma-contig streaming.
Either because there is no iommu, or because there are alignment requirements
(e.g. start at the page boundary) that do not fit a malloc()ed buffer.

> +	q->drv_priv = stream;
> +	q->ops = &rkisp1_vb2_ops;
> +	q->mem_ops = &vb2_dma_contig_memops;
> +	q->buf_struct_size = sizeof(struct rkisp1_buffer);
> +	q->min_buffers_needed = CIF_ISP_REQ_BUFS_MIN;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->lock = &node->vlock;
> +
> +	return vb2_queue_init(q);
> +}
> +
> +static void rkisp1_set_fmt(struct rkisp1_stream *stream,
> +			   struct v4l2_pix_format_mplane *pixm,
> +			   bool try)
> +{
> +	const struct capture_fmt *fmt;
> +	unsigned int imagsize = 0;
> +	unsigned int planes;
> +	u32 xsubs = 1, ysubs = 1;
> +	int i;
> +
> +	fmt = find_fmt(stream, pixm->pixelformat);
> +	if (!fmt)
> +		fmt = stream->config->fmts;
> +
> +	/* do checks on resolution */
> +	pixm->width = clamp_t(u32, pixm->width,
> +			      stream->config->min_rsz_width,
> +			      stream->config->max_rsz_width);
> +	pixm->height = clamp_t(u32, pixm->height,
> +			      stream->config->min_rsz_height,
> +			      stream->config->max_rsz_height);
> +	pixm->num_planes = fmt->mplanes;
> +	pixm->colorspace = rkisp1_get_colorspace(fmt->fmt_type);
> +	pixm->field = V4L2_FIELD_NONE;
> +	/* TODO: quantization */
> +	pixm->quantization = 0;
> +
> +	fcc_xysubs(fmt->fourcc, &xsubs, &ysubs);
> +	planes = fmt->cplanes ? fmt->cplanes : fmt->mplanes;
> +	for (i = 0; i < planes; i++) {
> +		struct v4l2_plane_pix_format *plane_fmt;
> +		int width, height, bytesperline;
> +
> +		plane_fmt = pixm->plane_fmt + i;
> +
> +		if (i == 0) {
> +			width = pixm->width;
> +			height = pixm->height;
> +		} else {
> +			width = pixm->width / xsubs;
> +			height = pixm->height / ysubs;
> +		}
> +
> +		bytesperline = width * DIV_ROUND_UP(fmt->bpp[i], 8);
> +		/* stride is only available for sp stream and y plane */
> +		if (stream->id != RKISP1_STREAM_SP || i != 0 ||
> +		    plane_fmt->bytesperline < bytesperline)
> +			plane_fmt->bytesperline = bytesperline;
> +
> +		plane_fmt->sizeimage = plane_fmt->bytesperline * height;
> +
> +		imagsize += plane_fmt->sizeimage;
> +	}
> +
> +	/* convert to non-MPLANE format */
> +	if (fmt->mplanes == 1)
> +		pixm->plane_fmt[0].sizeimage = imagsize;
> +
> +	if (!try) {
> +		stream->out_isp_fmt = *fmt;
> +		stream->out_fmt = *pixm;
> +
> +		if (stream->id == RKISP1_STREAM_SP) {
> +			stream->u.sp.y_stride =
> +				pixm->plane_fmt[0].bytesperline /
> +				DIV_ROUND_UP(fmt->bpp[0], 8);
> +		} else {
> +			stream->u.mp.raw_enable = (fmt->fmt_type == FMT_BAYER);
> +		}
> +	}
> +}
> +
> +/************************* v4l2_file_operations***************************/
> +void rkisp1_stream_init(struct rkisp1_device *dev, u32 id)
> +{
> +	struct rkisp1_stream *stream = &dev->stream[id];
> +	struct v4l2_pix_format_mplane pixm;
> +
> +	memset(stream, 0, sizeof(*stream));
> +	stream->id = id;
> +	stream->ispdev = dev;
> +
> +	INIT_LIST_HEAD(&stream->buf_queue);
> +	init_waitqueue_head(&stream->done);
> +	spin_lock_init(&stream->vbq_lock);
> +	if (stream->id == RKISP1_STREAM_SP) {
> +		stream->ops = &rkisp1_sp_streams_ops;
> +		stream->config = &rkisp1_sp_stream_config;
> +	} else {
> +		stream->ops = &rkisp1_mp_streams_ops;
> +		stream->config = &rkisp1_mp_stream_config;
> +	}
> +
> +	stream->state = RKISP1_STATE_READY;
> +
> +	memset(&pixm, 0, sizeof(pixm));
> +	pixm.pixelformat = V4L2_PIX_FMT_YUYV;
> +	pixm.width = RKISP1_DEFAULT_WIDTH;
> +	pixm.height = RKISP1_DEFAULT_HEIGHT;
> +	rkisp1_set_fmt(stream, &pixm, false);
> +
> +	stream->dcrop.left = 0;
> +	stream->dcrop.top = 0;
> +	stream->dcrop.width = RKISP1_DEFAULT_WIDTH;
> +	stream->dcrop.height = RKISP1_DEFAULT_HEIGHT;
> +}
> +
> +static const struct v4l2_file_operations rkisp1_fops = {
> +	.open = v4l2_fh_open,
> +	.release = vb2_fop_release,
> +	.unlocked_ioctl = video_ioctl2,
> +	.poll = vb2_fop_poll,
> +	.mmap = vb2_fop_mmap,
> +};
> +
> +/*
> + * mp and sp v4l2_ioctl_ops
> + */
> +
> +/* keep for compatibility */
> +static int rkisp1_enum_input(struct file *file, void *priv,
> +			     struct v4l2_input *input)
> +{
> +	if (input->index > 0)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int rkisp1_try_fmt_vid_cap_mplane(struct file *file, void *fh,
> +					 struct v4l2_format *f)
> +{
> +	struct rkisp1_stream *stream = video_drvdata(file);
> +
> +	rkisp1_set_fmt(stream, &f->fmt.pix_mp, true);
> +
> +	return 0;
> +}
> +
> +static int rkisp1_enum_fmt_vid_cap_mplane(struct file *file, void *priv,
> +					  struct v4l2_fmtdesc *f)
> +{
> +	struct rkisp1_stream *stream = video_drvdata(file);
> +	const struct capture_fmt *fmt = NULL;
> +
> +	if (f->index >= stream->config->fmt_size)
> +		return -EINVAL;
> +
> +	fmt = &stream->config->fmts[f->index];
> +	f->pixelformat = fmt->fourcc;
> +
> +	return 0;
> +}
> +
> +static int rkisp1_s_fmt_vid_cap_mplane(struct file *file,
> +				       void *priv, struct v4l2_format *f)
> +{
> +	struct rkisp1_stream *stream = video_drvdata(file);
> +	struct video_device *vdev = &stream->vnode.vdev;
> +	struct rkisp1_vdev_node *node = vdev_to_node(vdev);
> +	struct rkisp1_device *dev = stream->ispdev;
> +
> +	if (vb2_is_busy(&node->buf_queue)) {
> +		v4l2_err(&dev->v4l2_dev, "%s queue busy\n", __func__);
> +		return -EBUSY;
> +	}
> +
> +	rkisp1_set_fmt(stream, &f->fmt.pix_mp, false);
> +
> +	return 0;
> +}
> +
> +static int rkisp1_g_fmt_vid_cap_mplane(struct file *file, void *fh,
> +				       struct v4l2_format *f)
> +{
> +	struct rkisp1_stream *stream = video_drvdata(file);
> +
> +	f->fmt.pix_mp = stream->out_fmt;
> +
> +	return 0;
> +}
> +
> +static int rkisp1_g_selection(struct file *file, void *prv,
> +			      struct v4l2_selection *sel)
> +{
> +	struct rkisp1_stream *stream = video_drvdata(file);
> +	struct rkisp1_device *dev = stream->ispdev;
> +	struct v4l2_rect *dcrop = &stream->dcrop;
> +	struct v4l2_rect *input_win;
> +
> +	input_win = rkisp1_get_isp_sd_win(dev);
> +
> +	switch (sel->target) {
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +		sel->r.width = input_win->width;
> +		sel->r.height = input_win->height;
> +		sel->r.left = 0;
> +		sel->r.top = 0;
> +		break;
> +	case V4L2_SEL_TGT_CROP:
> +		sel->r = *dcrop;
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +		sel->r.width = stream->out_fmt.width;
> +		sel->r.height = stream->out_fmt.height;
> +		sel->r.left = 0;
> +		sel->r.top = 0;
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE:
> +		/* The composing rectangles always have the same size */
> +		sel->r.width = stream->out_fmt.width;
> +		sel->r.height = stream->out_fmt.height;
> +		sel->r.left = 0;
> +		sel->r.top = 0;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rkisp1_s_selection(struct file *file, void *prv,
> +			      struct v4l2_selection *sel)
> +{
> +	struct rkisp1_stream *stream = video_drvdata(file);
> +	struct rkisp1_device *dev = stream->ispdev;
> +	struct v4l2_rect *dcrop = &stream->dcrop;
> +	struct v4l2_rect *input_win;
> +
> +	input_win = rkisp1_get_isp_sd_win(dev);
> +
> +	if (sel->target != V4L2_SEL_TGT_CROP  &&
> +	    sel->target != V4L2_SEL_TGT_COMPOSE)
> +		return -EINVAL;
> +
> +	if (sel->flags != 0)
> +		return -EINVAL;
> +
> +	if (sel->target == V4L2_SEL_TGT_CROP) {
> +		sel->r.left = ALIGN(sel->r.left, 2);
> +		sel->r.width = ALIGN(sel->r.width, 2);
> +
> +		sel->r.left =
> +		    clamp_t(u32, sel->r.left, 0,
> +			    input_win->width - STREAM_MIN_MP_SP_INPUT_WIDTH);
> +		sel->r.top =
> +		    clamp_t(u32, sel->r.top, 0,
> +			    input_win->height - STREAM_MIN_MP_SP_INPUT_HEIGHT);
> +		sel->r.width =
> +		    clamp_t(u32, sel->r.width,
> +			    STREAM_MIN_MP_SP_INPUT_WIDTH,
> +			    input_win->width - sel->r.left);
> +		sel->r.height =
> +		    clamp_t(u32, sel->r.height,
> +			    STREAM_MIN_MP_SP_INPUT_HEIGHT,
> +			    input_win->height - sel->r.top);
> +
> +		/* check whether input fmt is raw */
> +		if (stream->id == RKISP1_STREAM_MP &&
> +		    stream->out_isp_fmt.fmt_type == FMT_BAYER) {
> +			sel->r.left = 0;
> +			sel->r.top = 0;
> +			sel->r.width = input_win->width;
> +			sel->r.height = input_win->height;
> +		}
> +
> +		*dcrop = sel->r;
> +	} else if (sel->target == V4L2_SEL_TGT_COMPOSE) {
> +		/* CamHal compatibility */

Huh? If you don't support compose, then this shouldn't be indicated.
When you say "CamHal compatibility" then I assume you refer to a Rockchip
Android Camera HAL implementation? I think it should be fixed there instead
of adding a hack here.

> +		sel->r.left = 0;
> +		sel->r.top = 0;
> +		sel->r.width = stream->out_fmt.width;
> +		sel->r.height = stream->out_fmt.height;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rkisp1_querycap(struct file *file, void *priv,
> +			   struct v4l2_capability *cap)
> +{
> +	struct rkisp1_stream *stream = video_drvdata(file);
> +	struct device *dev = stream->ispdev->dev;
> +
> +	strlcpy(cap->driver, dev->driver->name, sizeof(cap->driver));
> +	strlcpy(cap->card, dev->driver->name, sizeof(cap->card));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info),
> +		 "platform:%s", dev_name(dev));
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ioctl_ops rkisp1_v4l2_ioctl_ops = {
> +	.vidioc_reqbufs = vb2_ioctl_reqbufs,
> +	.vidioc_querybuf = vb2_ioctl_querybuf,
> +	.vidioc_create_bufs = vb2_ioctl_create_bufs,
> +	.vidioc_qbuf = vb2_ioctl_qbuf,
> +	.vidioc_expbuf = vb2_ioctl_expbuf,
> +	.vidioc_dqbuf = vb2_ioctl_dqbuf,

vidioc_preparebuf is missing.

> +	.vidioc_streamon = vb2_ioctl_streamon,
> +	.vidioc_streamoff = vb2_ioctl_streamoff,
> +	.vidioc_enum_input = rkisp1_enum_input,
> +	.vidioc_try_fmt_vid_cap_mplane = rkisp1_try_fmt_vid_cap_mplane,
> +	.vidioc_enum_fmt_vid_cap_mplane = rkisp1_enum_fmt_vid_cap_mplane,
> +	.vidioc_s_fmt_vid_cap_mplane = rkisp1_s_fmt_vid_cap_mplane,
> +	.vidioc_g_fmt_vid_cap_mplane = rkisp1_g_fmt_vid_cap_mplane,
> +	.vidioc_s_selection = rkisp1_s_selection,
> +	.vidioc_g_selection = rkisp1_g_selection,
> +	.vidioc_querycap = rkisp1_querycap,
> +};
> +
> +static void rkisp1_unregister_stream_vdev(struct rkisp1_stream *stream)
> +{
> +	media_entity_cleanup(&stream->vnode.vdev.entity);
> +	video_unregister_device(&stream->vnode.vdev);
> +}
> +
> +void rkisp1_unregister_stream_vdevs(struct rkisp1_device *dev)
> +{
> +	struct rkisp1_stream *mp_stream = &dev->stream[RKISP1_STREAM_MP];
> +	struct rkisp1_stream *sp_stream = &dev->stream[RKISP1_STREAM_SP];
> +
> +	rkisp1_unregister_stream_vdev(mp_stream);
> +	rkisp1_unregister_stream_vdev(sp_stream);
> +}
> +
> +static int rkisp1_register_stream_vdev(struct rkisp1_stream *stream)
> +{
> +	struct rkisp1_device *dev = stream->ispdev;
> +	struct v4l2_device *v4l2_dev = &dev->v4l2_dev;
> +	struct video_device *vdev = &stream->vnode.vdev;
> +	struct rkisp1_vdev_node *node;
> +	int ret;
> +
> +	strlcpy(vdev->name,
> +		stream->id == RKISP1_STREAM_SP ? SP_VDEV_NAME : MP_VDEV_NAME,
> +		sizeof(vdev->name));
> +	node = vdev_to_node(vdev);
> +	mutex_init(&node->vlock);
> +
> +	vdev->ioctl_ops = &rkisp1_v4l2_ioctl_ops;
> +	vdev->release = video_device_release_empty;
> +	vdev->fops = &rkisp1_fops;
> +	vdev->minor = -1;
> +	vdev->v4l2_dev = v4l2_dev;
> +	vdev->lock = &node->vlock;
> +	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE_MPLANE |
> +				V4L2_CAP_STREAMING;
> +	video_set_drvdata(vdev, stream);
> +	vdev->vfl_dir = VFL_DIR_RX;
> +	node->pad.flags = MEDIA_PAD_FL_SINK;
> +
> +	rkisp_init_vb2_queue(&node->buf_queue, stream,
> +			     V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
> +	vdev->queue = &node->buf_queue;
> +
> +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret < 0) {
> +		v4l2_err(v4l2_dev,
> +			 "video_register_device failed with error %d\n", ret);
> +		return ret;
> +	}
> +
> +	vdev->entity.function = MEDIA_ENT_F_IO_V4L;
> +	ret = media_entity_pads_init(&vdev->entity, 1, &node->pad);
> +	if (ret < 0)
> +		goto unreg;
> +
> +	return 0;
> +unreg:
> +	video_unregister_device(vdev);
> +	return ret;
> +}
> +
> +int rkisp1_register_stream_vdevs(struct rkisp1_device *dev)
> +{
> +	struct rkisp1_stream *stream;
> +	int i, j, ret;
> +
> +	for (i = 0; i < RKISP1_MAX_STREAM; i++) {
> +		stream = &dev->stream[i];
> +		stream->ispdev = dev;
> +		ret = rkisp1_register_stream_vdev(stream);
> +		if (ret < 0)
> +			goto err;
> +	}
> +
> +	return 0;
> +err:
> +	for (j = 0; j < i; j++) {
> +		stream = &dev->stream[j];
> +		rkisp1_unregister_stream_vdev(stream);
> +	}
> +
> +	return ret;
> +}
> +
> +void rkisp1_mi_isr(struct rkisp1_stream *stream)
> +{
> +	struct rkisp1_device *dev = stream->ispdev;
> +	void __iomem *base = stream->ispdev->base_addr;
> +	u32 val;
> +
> +	stream->ops->clr_frame_end_int(base);
> +	val = stream->ops->is_frame_end_int_masked(base);
> +	if (val) {
> +		val = mi_get_masked_int_status(base);
> +		v4l2_err(&dev->v4l2_dev, "icr err: 0x%x\n", val);
> +	}
> +
> +	mi_frame_end(stream);
> +
> +	if (stream->stop) {
> +		stream->ops->stop_mi(stream);
> +		stream->stop = false;
> +		stream->state = RKISP1_STATE_READY;
> +		v4l2_dbg(1, rkisp1_debug, &dev->v4l2_dev,
> +			 "stream %d stopped\n", stream->id);
> +		wake_up(&stream->done);
> +	}
> +}
> diff --git a/drivers/media/platform/rockchip/isp1/capture.h b/drivers/media/platform/rockchip/isp1/capture.h
> new file mode 100644
> index 000000000000..e30d49deb214
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/isp1/capture.h
> @@ -0,0 +1,46 @@
> +/*
> + * Rockchip isp1 driver
> + *
> + * Copyright (C) 2017 Rockchip Electronics Co., Ltd.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#ifndef _RKISP1_PATH_VIDEO_H
> +#define _RKISP1_PATH_VIDEO_H
> +
> +struct rkisp1_device;
> +struct rkisp1_stream;
> +
> +void rkisp1_unregister_stream_vdevs(struct rkisp1_device *dev);
> +int rkisp1_register_stream_vdevs(struct rkisp1_device *dev);
> +void rkisp1_mi_isr(struct rkisp1_stream *stream);
> +void rkisp1_stream_init(struct rkisp1_device *dev, u32 id);
> +
> +#endif /* _RKISP1_PATH_VIDEO_H */
> diff --git a/drivers/media/platform/rockchip/isp1/common.h b/drivers/media/platform/rockchip/isp1/common.h
> new file mode 100644
> index 000000000000..5c5b8c3814ea
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/isp1/common.h
> @@ -0,0 +1,330 @@
> +/*
> + * Rockchip isp1 driver
> + *
> + * Copyright (C) 2017 Rockchip Electronics Co., Ltd.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#ifndef _RKISP1_COMMON_H
> +#define _RKISP1_COMMON_H
> +
> +#include <media/media-device.h>
> +#include <media/media-entity.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/videobuf2-v4l2.h>
> +
> +#define DRIVER_NAME "rkisp1"
> +#define ISP_VDEV_NAME DRIVER_NAME  "_ispdev"
> +#define SP_VDEV_NAME DRIVER_NAME   "_selfpath"
> +#define MP_VDEV_NAME DRIVER_NAME   "_mainpath"
> +#define DMA_VDEV_NAME DRIVER_NAME  "_dmapath"
> +
> +#define GRP_ID_SENSOR			BIT(0)
> +#define GRP_ID_MIPIPHY			BIT(1)
> +#define GRP_ID_ISP			BIT(2)
> +#define GRP_ID_ISP_MP			BIT(3)
> +#define GRP_ID_ISP_SP			BIT(4)
> +
> +#define RKISP1_DEFAULT_WIDTH		800
> +#define RKISP1_DEFAULT_HEIGHT		600
> +
> +#define RKISP1_MAX_STREAM		2
> +#define RKISP1_STREAM_SP		0
> +#define RKISP1_STREAM_MP		1
> +
> +#define RKISP1_PLANE_Y			0
> +#define RKISP1_PLANE_CB			1
> +#define RKISP1_PLANE_CR			2
> +
> +#define RKISP1_PIPELINE_MAX		4
> +
> +enum rkisp1_sd_type {
> +	RKISP1_SD_SENSOR,
> +	RKISP1_SD_PHY_CSI,
> +	RKISP1_SD_VCM,
> +	RKISP1_SD_FLASH,
> +	RKISP1_SD_MAX,
> +};
> +
> +struct rkisp1_pipeline;
> +
> +/*
> + * struct rkisp1_pipeline - An ISP hardware pipeline
> + * @entities: Bitmask of entities in the pipeline (indexed by entity ID)
> + */
> +struct rkisp1_pipeline {
> +	struct media_pipeline pipe;
> +	int num_subdevs;
> +	struct v4l2_subdev *subdevs[RKISP1_PIPELINE_MAX];
> +	int (*open)(struct rkisp1_pipeline *p,
> +		    struct media_entity *me, bool prepare);
> +	int (*close)(struct rkisp1_pipeline *p);
> +	int (*set_stream)(struct rkisp1_pipeline *p, bool on);
> +};
> +
> +/* One structure per video node */
> +struct rkisp1_vdev_node {
> +	struct vb2_queue buf_queue;
> +	/* vfd lock */
> +	struct mutex vlock;
> +	struct video_device vdev;
> +	struct media_pad pad;
> +};
> +
> +enum rkisp1_fmt_pix_type {
> +	FMT_YUV,
> +	FMT_RGB,
> +	FMT_BAYER,
> +	FMT_JPEG,
> +	FMT_MAX
> +};
> +
> +enum rkisp1_fmt_raw_pat_type {
> +	RAW_RGGB = 0,
> +	RAW_GRBG,
> +	RAW_GBRG,
> +	RAW_BGGR,
> +};
> +
> +struct ispsd_in_fmt {
> +	u32 mbus_code;
> +	u8 fmt_type;
> +	u32 mipi_dt;
> +	u32 yuv_seq;
> +	enum rkisp1_fmt_raw_pat_type bayer_pat;
> +	u8 bus_width;
> +};
> +
> +struct ispsd_out_fmt {
> +	u32 mbus_code;
> +	u8 fmt_type;
> +};
> +
> +/*
> + * @fourcc: pixel format
> + * @mbus_code: pixel format over bus
> + * @fmt_type: helper filed for pixel format
> + * @bpp: bits per pixel
> + * @bayer_pat: bayer patten type
> + * @cplanes: number of colour planes
> + * @mplanes: number of stored memory planes
> + * @uv_swap: if cb cr swaped, for yuv
> + * @write_format: defines how YCbCr self picture data is written to memory
> + * @input_format: defines sp input format
> + * @output_format: defines sp output format
> + */
> +struct capture_fmt {
> +	u32 fourcc;
> +	u32 mbus_code;
> +	u8 fmt_type;
> +	u8 cplanes;
> +	u8 mplanes;
> +	u8 uv_swap;
> +	u32 write_format;
> +	u32 output_format;
> +	u8 bpp[VIDEO_MAX_PLANES];
> +};
> +
> +enum rkisp1_state {
> +	/* path not yet opened: */
> +	RKISP1_STATE_DISABLED,
> +	/* path opened and configured, ready for streaming: */
> +	RKISP1_STATE_READY,
> +	/* path is streaming: */
> +	RKISP1_STATE_STREAMING
> +};
> +
> +struct rkisp1_buffer {
> +	struct vb2_v4l2_buffer vb;
> +	struct list_head queue;
> +	union {
> +		u32 buff_addr[VIDEO_MAX_PLANES];
> +		void *vaddr[VIDEO_MAX_PLANES];
> +	};
> +};
> +
> +struct rkisp1_dummy_buffer {
> +	void *vaddr;
> +	dma_addr_t dma_addr;
> +	u32 size;
> +};
> +
> +enum rkisp1_sp_inp {
> +	RKISP1_SP_INP_ISP,
> +	RKISP1_SP_INP_DMA_SP,
> +	RKISP1_SP_INP_MAX
> +};
> +
> +struct rkisp1_device;
> +struct rkisp1_stream;
> +
> +struct rkisp1_stream_sp {
> +	int y_stride;
> +	enum rkisp1_sp_inp input_sel;
> +};
> +
> +struct rkisp1_stream_mp {
> +	bool raw_enable;
> +};
> +
> +struct stream_config {
> +	const struct capture_fmt *fmts;
> +	int fmt_size;
> +	/* constrains */
> +	const int max_rsz_width;
> +	const int max_rsz_height;
> +	const int min_rsz_width;
> +	const int min_rsz_height;
> +	/* registers */
> +	struct {
> +		u32 ctrl;
> +		u32 ctrl_shd;
> +		u32 scale_hy;
> +		u32 scale_hcr;
> +		u32 scale_hcb;
> +		u32 scale_vy;
> +		u32 scale_vc;
> +		u32 scale_lut;
> +		u32 scale_lut_addr;
> +		u32 scale_hy_shd;
> +		u32 scale_hcr_shd;
> +		u32 scale_hcb_shd;
> +		u32 scale_vy_shd;
> +		u32 scale_vc_shd;
> +		u32 phase_hy;
> +		u32 phase_hc;
> +		u32 phase_vy;
> +		u32 phase_vc;
> +		u32 phase_hy_shd;
> +		u32 phase_hc_shd;
> +		u32 phase_vy_shd;
> +		u32 phase_vc_shd;
> +	} rsz;
> +	struct {
> +		u32 ctrl;
> +		u32 yuvmode_mask;
> +		u32 rawmode_mask;
> +		u32 h_offset;
> +		u32 v_offset;
> +		u32 h_size;
> +		u32 v_size;
> +	} dual_crop;
> +	struct {
> +		u32 y_size_init;
> +		u32 cb_size_init;
> +		u32 cr_size_init;
> +		u32 y_base_ad_init;
> +		u32 cb_base_ad_init;
> +		u32 cr_base_ad_init;
> +		u32 y_offs_cnt_init;
> +		u32 cb_offs_cnt_init;
> +		u32 cr_offs_cnt_init;
> +	} mi;
> +};
> +
> +struct streams_ops {
> +	int (*check_against)(struct rkisp1_stream *stream);
> +	int (*config_mi)(struct rkisp1_stream *stream);
> +	void (*stop_mi)(struct rkisp1_stream *stream);
> +	void (*enable_mi)(struct rkisp1_stream *stream);
> +	void (*disable_mi)(struct rkisp1_stream *stream);
> +	void (*set_data_path)(void __iomem *base);
> +	void (*clr_frame_end_int)(void __iomem *base);
> +	u32 (*is_frame_end_int_masked)(void __iomem *base);
> +};
> +
> +struct rkisp1_stream {
> +	u32 id;
> +	struct rkisp1_device *ispdev;
> +	struct rkisp1_vdev_node vnode;
> +	enum rkisp1_state state;
> +	enum rkisp1_state saved_state;
> +	struct capture_fmt out_isp_fmt;
> +	struct v4l2_pix_format_mplane out_fmt;
> +	struct v4l2_rect dcrop;
> +	struct streams_ops *ops;
> +	struct stream_config *config;
> +	/* spinlock for videobuf queues */
> +	spinlock_t vbq_lock;
> +	/* mi config */
> +	struct list_head buf_queue;
> +	struct rkisp1_dummy_buffer dummy_buf;
> +	struct rkisp1_buffer *curr_buf;
> +	struct rkisp1_buffer *next_buf;
> +	bool stop;
> +	wait_queue_head_t done;
> +	union {
> +		struct rkisp1_stream_sp sp;
> +		struct rkisp1_stream_mp mp;
> +	} u;
> +};
> +
> +extern int rkisp1_debug;
> +
> +static inline u32 rkisp1_get_colorspace(u32 fmt_type)
> +{
> +	switch (fmt_type) {
> +	case FMT_BAYER:
> +		return V4L2_COLORSPACE_SRGB;
> +	case FMT_YUV:
> +	case FMT_JPEG:
> +		return V4L2_COLORSPACE_JPEG;
> +	case FMT_RGB:
> +		return V4L2_COLORSPACE_RAW;
> +	default:
> +		return V4L2_COLORSPACE_DEFAULT;

This is wrong. The colorspace needs to come from the source subdevice.
You can't set it here, the ISP won't know it. Instead read it from the
media bus format.

> +	}
> +}
> +
> +static inline
> +struct rkisp1_vdev_node *vdev_to_node(struct video_device *vdev)
> +{
> +	return container_of(vdev, struct rkisp1_vdev_node, vdev);
> +}
> +
> +static inline struct rkisp1_vdev_node *queue_to_node(struct vb2_queue *q)
> +{
> +	return container_of(q, struct rkisp1_vdev_node, buf_queue);
> +}
> +
> +static inline struct rkisp1_buffer *to_rkisp1_buffer(struct vb2_v4l2_buffer *vb)
> +{
> +	return container_of(vb, struct rkisp1_buffer, vb);
> +}
> +
> +static inline struct vb2_queue *to_vb2_queue(struct file *file)
> +{
> +	struct rkisp1_vdev_node *vnode = video_drvdata(file);
> +
> +	return &vnode->buf_queue;
> +}
> +
> +#endif /* _RKISP1_COMMON_H */
> diff --git a/drivers/media/platform/rockchip/isp1/dev.c b/drivers/media/platform/rockchip/isp1/dev.c
> new file mode 100644
> index 000000000000..3d6537077209
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/isp1/dev.c
> @@ -0,0 +1,632 @@
> +/*
> + * Rockchip isp1 driver
> + *
> + * Copyright (C) 2017 Rockchip Electronics Co., Ltd.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_graph.h>
> +#include <linux/of_platform.h>
> +#include <linux/pm_runtime.h>
> +#include "regs.h"
> +#include "rkisp1.h"
> +
> +struct isp_match_data {
> +	const char * const *clks;
> +	int size;
> +};
> +
> +int rkisp1_debug;
> +module_param_named(debug, rkisp1_debug, int, 0644);
> +MODULE_PARM_DESC(debug, "Debug level (0-1)");
> +
> +static int __isp_pipeline_prepare(struct rkisp1_pipeline *p,
> +				  struct media_entity *me)
> +{
> +	struct rkisp1_device *dev = container_of(p, struct rkisp1_device, pipe);
> +	struct v4l2_subdev *sd;
> +	int i;
> +
> +	p->num_subdevs = 0;
> +	memset(p->subdevs, 0, sizeof(p->subdevs));
> +
> +	while (1) {
> +		struct media_pad *pad = NULL;
> +
> +		/* Find remote source pad */
> +		for (i = 0; i < me->num_pads; i++) {
> +			struct media_pad *spad = &me->pads[i];
> +
> +			if (!(spad->flags & MEDIA_PAD_FL_SINK))
> +				continue;
> +			pad = media_entity_remote_pad(spad);
> +			if (pad)
> +				break;
> +		}
> +
> +		if (!pad)
> +			break;
> +
> +		sd = media_entity_to_v4l2_subdev(pad->entity);
> +		if (sd != &dev->isp_sdev.sd)
> +			p->subdevs[p->num_subdevs++] = sd;
> +
> +		me = &sd->entity;
> +		if (me->num_pads == 1)
> +			break;
> +	}
> +	return 0;
> +}
> +
> +static int __subdev_set_power(struct v4l2_subdev *sd, int on)
> +{
> +	int *use_count;
> +	int ret;
> +
> +	v4l2_info(sd, "%d: name %s,on %d\n", __LINE__, sd->name, on);
> +
> +	if (!sd)
> +		return -ENXIO;
> +
> +	use_count = &sd->entity.use_count;
> +	if (on && (*use_count)++ > 0)
> +		return 0;
> +	else if (!on && (*use_count == 0 || --(*use_count) > 0))
> +		return 0;
> +	ret = v4l2_subdev_call(sd, core, s_power, on);
> +
> +	return ret != -ENOIOCTLCMD ? ret : 0;
> +}
> +
> +static int __isp_pipeline_s_power(struct rkisp1_pipeline *p, bool on)
> +{
> +	struct rkisp1_device *dev = container_of(p, struct rkisp1_device, pipe);
> +	int i, ret;
> +
> +	if (on) {
> +		__subdev_set_power(&dev->isp_sdev.sd, true);
> +
> +		for (i = p->num_subdevs - 1; i >= 0; --i) {
> +			ret = __subdev_set_power(p->subdevs[i], true);
> +			if (ret < 0 && ret != -ENXIO)
> +				goto err_power_off;
> +		}
> +	} else {
> +		for (i = 0; i < p->num_subdevs; ++i)
> +			__subdev_set_power(p->subdevs[i], false);
> +
> +		__subdev_set_power(&dev->isp_sdev.sd, false);
> +	}
> +
> +	return 0;
> +
> +err_power_off:
> +	for (++i; i < p->num_subdevs; ++i)
> +		__subdev_set_power(p->subdevs[i], false);
> +	__subdev_set_power(&dev->isp_sdev.sd, true);
> +	return ret;
> +}
> +
> +static int rkisp1_pipeline_open(struct rkisp1_pipeline *p,
> +				struct media_entity *me,
> +				bool prepare)
> +{
> +	int ret;
> +
> +	if (WARN_ON(!p || !me))
> +		return -EINVAL;
> +
> +	if (prepare)
> +		__isp_pipeline_prepare(p, me);
> +
> +	if (!p->num_subdevs)
> +		return -EINVAL;
> +
> +	ret = __isp_pipeline_s_power(p, 1);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int rkisp1_pipeline_close(struct rkisp1_pipeline *p)
> +{
> +	int ret;
> +
> +	ret = __isp_pipeline_s_power(p, 0);
> +
> +	return ret == -ENXIO ? 0 : ret;
> +}
> +
> +static int rkisp1_pipeline_set_stream(struct rkisp1_pipeline *p, bool on)
> +{
> +	struct rkisp1_device *dev = container_of(p, struct rkisp1_device, pipe);
> +	int i, ret;
> +
> +	if (on)
> +		v4l2_subdev_call(&dev->isp_sdev.sd, video, s_stream, true);
> +
> +	for (i = 0; i < p->num_subdevs; ++i) {
> +		ret = v4l2_subdev_call(p->subdevs[i], video, s_stream, on);
> +		if (on && ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
> +			goto err_stream_off;
> +	}
> +
> +	if (!on)
> +		v4l2_subdev_call(&dev->isp_sdev.sd, video, s_stream, false);
> +
> +	return 0;
> +
> +err_stream_off:
> +	for (--i; i >= 0; --i)
> +		v4l2_subdev_call(p->subdevs[i], video, s_stream, false);
> +	v4l2_subdev_call(&dev->isp_sdev.sd, video, s_stream, false);
> +	return ret;
> +}
> +
> +static int rkisp1_create_links(struct rkisp1_device *dev)
> +{
> +	struct media_entity *source, *sink;
> +	unsigned int flags, s, pad;
> +	int ret;
> +
> +	/* sensor links(or mipi-phy) */
> +	for (s = 0; s < dev->num_sensors; ++s) {
> +		struct rkisp1_sensor_info *sensor = &dev->sensors[s];
> +
> +		for (pad = 0; pad < sensor->sd->entity.num_pads; pad++)
> +			if (sensor->sd->entity.pads[pad].flags & MEDIA_PAD_FL_SOURCE)
> +				break;
> +
> +		if (pad == sensor->sd->entity.num_pads) {
> +			dev_err(dev->dev,
> +				"failed to find src pad for %s\n",
> +				sensor->sd->name);
> +
> +			return -ENXIO;
> +		}
> +
> +		ret = media_create_pad_link(&sensor->sd->entity, pad,
> +				&dev->isp_sdev.sd.entity,
> +				RKISP1_ISP_PAD_SINK + s,
> +				s ? 0 : MEDIA_LNK_FL_ENABLED);
> +		if (ret) {
> +			dev_err(dev->dev,
> +				"failed to create link for %s\n",
> +				sensor->sd->name);
> +			return ret;
> +		}
> +	}
> +
> +	/* params links */
> +	source = &dev->params_vdev.vnode.vdev.entity;
> +	sink = &dev->isp_sdev.sd.entity;
> +	flags = MEDIA_LNK_FL_ENABLED;
> +	ret = media_create_pad_link(source, 0, sink,
> +				    RKISP1_ISP_PAD_SINK_PARAMS, flags);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* create isp internal links */
> +	/* SP links */
> +	source = &dev->isp_sdev.sd.entity;
> +	sink = &dev->stream[RKISP1_STREAM_SP].vnode.vdev.entity;
> +	ret = media_create_pad_link(source, RKISP1_ISP_PAD_SOURCE_PATH,
> +				       sink, 0, flags);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* MP links */
> +	source = &dev->isp_sdev.sd.entity;
> +	sink = &dev->stream[RKISP1_STREAM_MP].vnode.vdev.entity;
> +	ret = media_create_pad_link(source, RKISP1_ISP_PAD_SOURCE_PATH,
> +				       sink, 0, flags);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* 3A stats links */
> +	source = &dev->isp_sdev.sd.entity;
> +	sink = &dev->stats_vdev.vnode.vdev.entity;
> +	return media_create_pad_link(source, RKISP1_ISP_PAD_SOURCE_STATS,
> +					sink, 0, flags);
> +}
> +
> +static int subdev_notifier_complete(struct v4l2_async_notifier *notifier)
> +{
> +	struct rkisp1_device *dev;
> +	int ret;
> +
> +	dev = container_of(notifier, struct rkisp1_device, notifier);
> +
> +	mutex_lock(&dev->media_dev.graph_mutex);
> +	ret = rkisp1_create_links(dev);
> +	if (ret < 0)
> +		goto unlock;
> +	ret = v4l2_device_register_subdev_nodes(&dev->v4l2_dev);
> +	if (ret < 0)
> +		goto unlock;
> +
> +	v4l2_info(&dev->v4l2_dev, "Async subdev notifier completed\n");
> +
> +unlock:
> +	mutex_unlock(&dev->media_dev.graph_mutex);
> +	return ret;
> +}
> +
> +struct rkisp1_async_subdev {
> +	struct v4l2_async_subdev asd;
> +	struct v4l2_mbus_config mbus;
> +};
> +
> +static int subdev_notifier_bound(struct v4l2_async_notifier *notifier,
> +				 struct v4l2_subdev *subdev,
> +				 struct v4l2_async_subdev *asd)
> +{
> +	struct rkisp1_device *isp_dev = container_of(notifier,
> +					struct rkisp1_device, notifier);
> +	struct rkisp1_async_subdev *s_asd = container_of(asd,
> +					struct rkisp1_async_subdev, asd);
> +
> +	if (isp_dev->num_sensors == ARRAY_SIZE(isp_dev->sensors))
> +		return -EBUSY;
> +
> +	isp_dev->sensors[isp_dev->num_sensors].mbus = s_asd->mbus;
> +	isp_dev->sensors[isp_dev->num_sensors].sd = subdev;
> +	++isp_dev->num_sensors;
> +
> +	v4l2_dbg(1, rkisp1_debug, subdev, "Async registered subdev\n");
> +
> +	return 0;
> +}
> +
> +static int rkisp1_fwnode_parse(struct device *dev,
> +			       struct v4l2_fwnode_endpoint *vep,
> +			       struct v4l2_async_subdev *asd)
> +{
> +	struct rkisp1_async_subdev *rk_asd =
> +			container_of(asd, struct rkisp1_async_subdev, asd);
> +	struct v4l2_fwnode_bus_parallel *bus = &vep->bus.parallel;
> +
> +	if (vep->bus_type != V4L2_MBUS_BT656 &&
> +	    vep->bus_type != V4L2_MBUS_PARALLEL)
> +		return 0;
> +
> +	rk_asd->mbus.flags = bus->flags;
> +	rk_asd->mbus.type = vep->bus_type;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_async_notifier_operations subdev_notifier_ops = {
> +	.bound = subdev_notifier_bound,
> +	.complete = subdev_notifier_complete,
> +};
> +
> +static int isp_subdev_notifier(struct rkisp1_device *isp_dev)
> +{
> +	struct v4l2_async_notifier *ntf = &isp_dev->notifier;
> +	struct device *dev = isp_dev->dev;
> +	int ret;
> +
> +	ret = v4l2_async_notifier_parse_fwnode_endpoints(dev, ntf,
> +		sizeof(struct rkisp1_async_subdev), rkisp1_fwnode_parse);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!ntf->num_subdevs)
> +		return -ENODEV;	/* no endpoint */
> +
> +	ntf->ops = &subdev_notifier_ops;
> +
> +	return v4l2_async_notifier_register(&isp_dev->v4l2_dev, ntf);
> +}
> +
> +static int rkisp1_register_platform_subdevs(struct rkisp1_device *dev)
> +{
> +	int ret;
> +
> +	ret = rkisp1_register_isp_subdev(dev, &dev->v4l2_dev);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = rkisp1_register_stream_vdevs(dev);
> +	if (ret < 0)
> +		goto err_unreg_isp_subdev;
> +
> +	ret = rkisp1_register_stats_vdev(&dev->stats_vdev, &dev->v4l2_dev, dev);
> +	if (ret < 0)
> +		goto err_unreg_stream_vdev;
> +
> +	ret = rkisp1_register_params_vdev(&dev->params_vdev, &dev->v4l2_dev,
> +					  dev);
> +	if (ret < 0)
> +		goto err_unreg_stats_vdev;
> +
> +	ret = isp_subdev_notifier(dev);
> +	if (ret < 0) {
> +		v4l2_err(&dev->v4l2_dev,
> +			 "Failed to register subdev notifier(%d)\n", ret);
> +		goto err_unreg_params_vdev;
> +	}
> +
> +	return 0;
> +err_unreg_params_vdev:
> +	rkisp1_unregister_params_vdev(&dev->params_vdev);
> +err_unreg_stats_vdev:
> +	rkisp1_unregister_stats_vdev(&dev->stats_vdev);
> +err_unreg_stream_vdev:
> +	rkisp1_unregister_stream_vdevs(dev);
> +err_unreg_isp_subdev:
> +	rkisp1_unregister_isp_subdev(dev);
> +	return ret;
> +}
> +
> +static const char * const rk3399_isp_clks[] = {
> +	"clk_isp",
> +	"aclk_isp",
> +	"hclk_isp",
> +	"aclk_isp_wrap",
> +	"hclk_isp_wrap",
> +};
> +
> +static const char * const rk3288_isp_clks[] = {
> +	"clk_isp",
> +	"aclk_isp",
> +	"hclk_isp",
> +	"pclk_isp_in",
> +	"sclk_isp_jpe",
> +};
> +
> +static const struct isp_match_data rk3288_isp_clk_data = {
> +	.clks = rk3288_isp_clks,
> +	.size = ARRAY_SIZE(rk3288_isp_clks),
> +};
> +
> +static const struct isp_match_data rk3399_isp_clk_data = {
> +	.clks = rk3399_isp_clks,
> +	.size = ARRAY_SIZE(rk3399_isp_clks),
> +};
> +
> +static const struct of_device_id rkisp1_plat_of_match[] = {
> +	{
> +		.compatible = "rockchip,rk3288-cif-isp",
> +		.data = &rk3288_isp_clk_data,
> +	}, {
> +		.compatible = "rockchip,rk3399-cif-isp",
> +		.data = &rk3399_isp_clk_data,
> +	},
> +	{},
> +};
> +
> +static irqreturn_t rkisp1_irq_handler(int irq, void *cntxt)
> +{
> +	struct device *dev = cntxt;
> +	struct rkisp1_device *rkisp1_dev = dev_get_drvdata(dev);
> +	void __iomem *base = rkisp1_dev->base_addr;
> +	unsigned int mis_val, i;
> +
> +	mis_val = readl(rkisp1_dev->base_addr + CIF_ISP_MIS);
> +	if (mis_val)
> +		rkisp1_isp_isr(mis_val, rkisp1_dev);
> +
> +	mis_val = readl(rkisp1_dev->base_addr + CIF_MIPI_MIS);
> +	if (mis_val)
> +		rkisp1_mipi_isr(mis_val, rkisp1_dev);
> +
> +	for (i = 0; i < RKISP1_MAX_STREAM; ++i) {
> +		struct rkisp1_stream *stream = &rkisp1_dev->stream[i];
> +
> +		mis_val = stream->ops->is_frame_end_int_masked(base);
> +		if (mis_val)
> +			rkisp1_mi_isr(stream);
> +	}
> +
> +	clr_all_int(base);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void rkisp1_disable_sys_clk(struct rkisp1_device *rkisp1_dev)
> +{
> +	int i;
> +
> +	for (i = rkisp1_dev->clk_size - 1; i >= 0; i--)
> +		clk_disable_unprepare(rkisp1_dev->clks[i]);
> +}
> +
> +static int rkisp1_enable_sys_clk(struct rkisp1_device *rkisp1_dev)
> +{
> +	int i, ret = -EINVAL;
> +
> +	for (i = 0; i < rkisp1_dev->clk_size; i++) {
> +		ret = clk_prepare_enable(rkisp1_dev->clks[i]);
> +		if (ret < 0)
> +			goto err;
> +	}
> +	return 0;
> +err:
> +	for (--i; i >= 0; --i)
> +		clk_disable_unprepare(rkisp1_dev->clks[i]);
> +	return ret;
> +}
> +
> +static int rkisp1_plat_probe(struct platform_device *pdev)
> +{
> +	const struct of_device_id *match;
> +	struct device_node *node = pdev->dev.of_node;
> +	struct device *dev = &pdev->dev;
> +	struct v4l2_device *v4l2_dev;
> +	struct rkisp1_device *isp_dev;
> +	const struct isp_match_data *clk_data;
> +
> +	struct resource *res;
> +	int i, ret, irq;
> +
> +	match = of_match_node(rkisp1_plat_of_match, node);
> +	isp_dev = devm_kzalloc(dev, sizeof(*isp_dev), GFP_KERNEL);
> +	if (!isp_dev)
> +		return -ENOMEM;
> +
> +	dev_set_drvdata(dev, isp_dev);
> +	atomic_set(&isp_dev->poweron_cnt, 0);
> +	isp_dev->dev = dev;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	isp_dev->base_addr = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(isp_dev->base_addr))
> +		return PTR_ERR(isp_dev->base_addr);
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0)
> +		return irq;
> +
> +	ret = devm_request_irq(dev, irq, rkisp1_irq_handler, IRQF_SHARED,
> +			       dev_driver_string(dev), dev);
> +	if (ret < 0) {
> +		dev_err(dev, "request irq failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	isp_dev->irq = irq;
> +	clk_data = match->data;
> +	for (i = 0; i < clk_data->size; i++) {
> +		struct clk *clk = devm_clk_get(dev, clk_data->clks[i]);
> +
> +		if (IS_ERR(clk)) {
> +			dev_err(dev, "failed to get %s\n", clk_data->clks[i]);
> +			return PTR_ERR(clk);
> +		}
> +		isp_dev->clks[i] = clk;
> +	}
> +	isp_dev->clk_size = clk_data->size;
> +
> +	isp_dev->pipe.open = rkisp1_pipeline_open;
> +	isp_dev->pipe.close = rkisp1_pipeline_close;
> +	isp_dev->pipe.set_stream = rkisp1_pipeline_set_stream;
> +
> +	rkisp1_stream_init(isp_dev, RKISP1_STREAM_SP);
> +	rkisp1_stream_init(isp_dev, RKISP1_STREAM_MP);
> +
> +	strlcpy(isp_dev->media_dev.model, "rkisp1",
> +		sizeof(isp_dev->media_dev.model));
> +	isp_dev->media_dev.dev = &pdev->dev;
> +	media_device_init(&isp_dev->media_dev);
> +
> +	v4l2_dev = &isp_dev->v4l2_dev;
> +	v4l2_dev->mdev = &isp_dev->media_dev;
> +	strlcpy(v4l2_dev->name, "rkisp1", sizeof(v4l2_dev->name));
> +
> +	ret = v4l2_device_register(isp_dev->dev, &isp_dev->v4l2_dev);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = media_device_register(&isp_dev->media_dev);
> +	if (ret < 0) {
> +		v4l2_err(v4l2_dev, "Failed to register media device: %d\n",
> +			 ret);
> +		goto err_unreg_v4l2_dev;
> +	}
> +
> +	/* create & register platefom subdev (from of_node) */
> +	ret = rkisp1_register_platform_subdevs(isp_dev);
> +	if (ret < 0)
> +		goto err_unreg_media_dev;
> +
> +	pm_runtime_enable(&pdev->dev);
> +
> +	return 0;
> +
> +err_unreg_media_dev:
> +	media_device_unregister(&isp_dev->media_dev);
> +err_unreg_v4l2_dev:
> +	v4l2_device_unregister(&isp_dev->v4l2_dev);
> +	return ret;
> +}
> +
> +static int rkisp1_plat_remove(struct platform_device *pdev)
> +{
> +	struct rkisp1_device *isp_dev = platform_get_drvdata(pdev);
> +
> +	pm_runtime_disable(&pdev->dev);
> +	media_device_unregister(&isp_dev->media_dev);
> +	v4l2_device_unregister(&isp_dev->v4l2_dev);
> +	rkisp1_unregister_params_vdev(&isp_dev->params_vdev);
> +	rkisp1_unregister_stats_vdev(&isp_dev->stats_vdev);
> +	rkisp1_unregister_stream_vdevs(isp_dev);
> +	rkisp1_unregister_isp_subdev(isp_dev);
> +
> +	return 0;
> +}
> +
> +static int __maybe_unused rkisp1_runtime_suspend(struct device *dev)
> +{
> +	struct rkisp1_device *isp_dev = dev_get_drvdata(dev);
> +
> +	rkisp1_disable_sys_clk(isp_dev);
> +	return pinctrl_pm_select_sleep_state(dev);
> +}
> +
> +static int __maybe_unused rkisp1_runtime_resume(struct device *dev)
> +{
> +	struct rkisp1_device *isp_dev = dev_get_drvdata(dev);
> +	int ret;
> +
> +	ret = pinctrl_pm_select_default_state(dev);
> +	if (ret < 0)
> +		return ret;
> +	rkisp1_enable_sys_clk(isp_dev);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops rkisp1_plat_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
> +				pm_runtime_force_resume)
> +	SET_RUNTIME_PM_OPS(rkisp1_runtime_suspend, rkisp1_runtime_resume, NULL)
> +};
> +
> +static struct platform_driver rkisp1_plat_drv = {
> +	.driver = {
> +		   .name = DRIVER_NAME,
> +		   .of_match_table = of_match_ptr(rkisp1_plat_of_match),
> +		   .pm = &rkisp1_plat_pm_ops,
> +	},
> +	.probe = rkisp1_plat_probe,
> +	.remove = rkisp1_plat_remove,
> +};
> +
> +module_platform_driver(rkisp1_plat_drv);
> +MODULE_AUTHOR("Rockchip Camera/ISP team");
> +MODULE_DESCRIPTION("Rockchip ISP1 platform driver");
> +MODULE_LICENSE("Dual BSD/GPL");
> diff --git a/drivers/media/platform/rockchip/isp1/isp_params.c b/drivers/media/platform/rockchip/isp1/isp_params.c
> new file mode 100644
> index 000000000000..76c9755bde2a
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/isp1/isp_params.c
> @@ -0,0 +1,1556 @@
> +/*
> + * Rockchip isp1 driver
> + *
> + * Copyright (C) 2017 Rockchip Electronics Co., Ltd.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-vmalloc.h>	/* for ISP params */
> +#include "regs.h"
> +#include "rkisp1.h"
> +#include "isp_params.h"
> +
> +#define RKISP1_ISP_PARAMS_REQ_BUFS_MIN	2
> +#define RKISP1_ISP_PARAMS_REQ_BUFS_MAX	8
> +
> +#define BLS_START_H_MAX_IS_VALID(val)	((val) < CIFISP_BLS_START_H_MAX)
> +#define BLS_STOP_H_MAX_IS_VALID(val)	((val) < CIFISP_BLS_STOP_H_MAX)
> +
> +#define BLS_START_V_MAX_IS_VALID(val)	((val) < CIFISP_BLS_START_V_MAX)
> +#define BLS_STOP_V_MAX_IS_VALID(val)	((val) < CIFISP_BLS_STOP_V_MAX)
> +
> +#define BLS_SAMPLE_MAX_IS_VALID(val)	((val) < CIFISP_BLS_SAMPLES_MAX)
> +
> +#define BLS_FIX_SUB_IS_VALID(val)	\
> +	((val) > (s16)CIFISP_BLS_FIX_SUB_MIN && (val) < CIFISP_BLS_FIX_SUB_MAX)
> +
> +static inline void rkisp1_iowrite32(struct rkisp1_isp_params_vdev *params_vdev,
> +				    u32 value, u32 addr)
> +{
> +	iowrite32(value, params_vdev->dev->base_addr + addr);
> +}
> +
> +static inline u32 rkisp1_ioread32(struct rkisp1_isp_params_vdev *params_vdev,
> +				  u32 addr)
> +{
> +	return ioread32(params_vdev->dev->base_addr + addr);
> +}
> +
> +static inline void isp_param_set_bits(struct rkisp1_isp_params_vdev
> +					     *params_vdev,
> +				      u32 reg, u32 bit_mask)
> +{
> +	u32 val;
> +
> +	val = rkisp1_ioread32(params_vdev, reg);
> +	rkisp1_iowrite32(params_vdev, val | bit_mask, reg);
> +}
> +
> +static inline void isp_param_clear_bits(struct rkisp1_isp_params_vdev
> +					       *params_vdev,
> +					u32 reg, u32 bit_mask)
> +{
> +	u32 val;
> +
> +	val = rkisp1_ioread32(params_vdev, reg);
> +	rkisp1_iowrite32(params_vdev, val & ~bit_mask, reg);
> +}
> +
> +/* ISP BP interface function */
> +static void dpcc_config(struct rkisp1_isp_params_vdev *params_vdev,
> +			const struct cifisp_dpcc_config *arg)
> +{
> +	unsigned int i;
> +
> +	rkisp1_iowrite32(params_vdev, arg->mode, CIF_ISP_DPCC_MODE);
> +	rkisp1_iowrite32(params_vdev, arg->output_mode,
> +			 CIF_ISP_DPCC_OUTPUT_MODE);
> +	rkisp1_iowrite32(params_vdev, arg->set_use, CIF_ISP_DPCC_SET_USE);
> +
> +	rkisp1_iowrite32(params_vdev, arg->methods[0].method,
> +			 CIF_ISP_DPCC_METHODS_SET_1);
> +	rkisp1_iowrite32(params_vdev, arg->methods[1].method,
> +			 CIF_ISP_DPCC_METHODS_SET_2);
> +	rkisp1_iowrite32(params_vdev, arg->methods[2].method,
> +			 CIF_ISP_DPCC_METHODS_SET_3);
> +	for (i = 0; i < CIFISP_DPCC_METHODS_MAX; i++) {
> +		rkisp1_iowrite32(params_vdev, arg->methods[i].line_thresh,
> +				 CIF_ISP_DPCC_LINE_THRESH_1 + 0x14 * i);
> +		rkisp1_iowrite32(params_vdev, arg->methods[i].line_mad_fac,
> +				 CIF_ISP_DPCC_LINE_MAD_FAC_1 + 0x14 * i);
> +		rkisp1_iowrite32(params_vdev, arg->methods[i].pg_fac,
> +				 CIF_ISP_DPCC_PG_FAC_1 + 0x14 * i);
> +		rkisp1_iowrite32(params_vdev, arg->methods[i].rnd_thresh,
> +				 CIF_ISP_DPCC_RND_THRESH_1 + 0x14 * i);
> +		rkisp1_iowrite32(params_vdev, arg->methods[i].rg_fac,
> +				 CIF_ISP_DPCC_RG_FAC_1 + 0x14 * i);
> +	}
> +
> +	rkisp1_iowrite32(params_vdev, arg->rnd_offs, CIF_ISP_DPCC_RND_OFFS);
> +	rkisp1_iowrite32(params_vdev, arg->ro_limits, CIF_ISP_DPCC_RO_LIMITS);
> +}
> +
> +/* ISP black level subtraction interface function */
> +static void bls_config(struct rkisp1_isp_params_vdev *params_vdev,
> +		       const struct cifisp_bls_config *arg)
> +{
> +	u32 new_control = 0;
> +
> +	/* fixed subtraction values */
> +	if (!arg->enable_auto) {
> +		const struct cifisp_bls_fixed_val *pval = &arg->fixed_val;
> +
> +		switch (params_vdev->raw_type) {
> +		case RAW_BGGR:
> +			rkisp1_iowrite32(params_vdev,
> +					 pval->r, CIF_ISP_BLS_D_FIXED);
> +			rkisp1_iowrite32(params_vdev,
> +					 pval->gr, CIF_ISP_BLS_C_FIXED);
> +			rkisp1_iowrite32(params_vdev,
> +					 pval->gb, CIF_ISP_BLS_B_FIXED);
> +			rkisp1_iowrite32(params_vdev,
> +					 pval->b, CIF_ISP_BLS_A_FIXED);
> +			break;
> +		case RAW_GBRG:
> +			rkisp1_iowrite32(params_vdev,
> +					 pval->r, CIF_ISP_BLS_C_FIXED);
> +			rkisp1_iowrite32(params_vdev,
> +					 pval->gr, CIF_ISP_BLS_D_FIXED);
> +			rkisp1_iowrite32(params_vdev,
> +					 pval->gb, CIF_ISP_BLS_A_FIXED);
> +			rkisp1_iowrite32(params_vdev,
> +					 pval->b, CIF_ISP_BLS_B_FIXED);
> +			break;
> +		case RAW_GRBG:
> +			rkisp1_iowrite32(params_vdev,
> +					 pval->r, CIF_ISP_BLS_B_FIXED);
> +			rkisp1_iowrite32(params_vdev,
> +					 pval->gr, CIF_ISP_BLS_A_FIXED);
> +			rkisp1_iowrite32(params_vdev,
> +					 pval->gb, CIF_ISP_BLS_D_FIXED);
> +			rkisp1_iowrite32(params_vdev,
> +					 pval->b, CIF_ISP_BLS_C_FIXED);
> +			break;
> +		case RAW_RGGB:
> +			rkisp1_iowrite32(params_vdev,
> +					 pval->r, CIF_ISP_BLS_A_FIXED);
> +			rkisp1_iowrite32(params_vdev,
> +					 pval->gr, CIF_ISP_BLS_B_FIXED);
> +			rkisp1_iowrite32(params_vdev,
> +					 pval->gb, CIF_ISP_BLS_C_FIXED);
> +			rkisp1_iowrite32(params_vdev,
> +					 pval->b, CIF_ISP_BLS_D_FIXED);
> +			break;
> +		default:
> +			break;
> +		}
> +
> +		new_control = CIF_ISP_BLS_MODE_FIXED;
> +		rkisp1_iowrite32(params_vdev, new_control, CIF_ISP_BLS_CTRL);
> +	} else {
> +		if (arg->en_windows & 2) {
> +			rkisp1_iowrite32(params_vdev, arg->bls_window2.h_offs,
> +					 CIF_ISP_BLS_H2_START);
> +			rkisp1_iowrite32(params_vdev, arg->bls_window2.h_size,
> +					 CIF_ISP_BLS_H2_STOP);
> +			rkisp1_iowrite32(params_vdev, arg->bls_window2.v_offs,
> +					 CIF_ISP_BLS_V2_START);
> +			rkisp1_iowrite32(params_vdev, arg->bls_window2.v_size,
> +					 CIF_ISP_BLS_V2_STOP);
> +			new_control |= CIF_ISP_BLS_WINDOW_2;
> +		}
> +
> +		if (arg->en_windows & 1) {
> +			rkisp1_iowrite32(params_vdev, arg->bls_window1.h_offs,
> +					 CIF_ISP_BLS_H1_START);
> +			rkisp1_iowrite32(params_vdev, arg->bls_window1.h_size,
> +					 CIF_ISP_BLS_H1_STOP);
> +			rkisp1_iowrite32(params_vdev, arg->bls_window1.v_offs,
> +					 CIF_ISP_BLS_V1_START);
> +			rkisp1_iowrite32(params_vdev, arg->bls_window1.v_size,
> +					 CIF_ISP_BLS_V1_STOP);
> +			new_control |= CIF_ISP_BLS_WINDOW_1;
> +		}
> +
> +		rkisp1_iowrite32(params_vdev, arg->bls_samples,
> +				 CIF_ISP_BLS_SAMPLES);
> +
> +		new_control |= CIF_ISP_BLS_MODE_MEASURED;
> +
> +		rkisp1_iowrite32(params_vdev, new_control, CIF_ISP_BLS_CTRL);
> +	}
> +}
> +
> +/* ISP LS correction interface function */
> +static void
> +__lsc_correct_matrix_config(struct rkisp1_isp_params_vdev *params_vdev,
> +			    const struct cifisp_lsc_config *pconfig)
> +{
> +	int i, j;
> +	unsigned int isp_lsc_status, sram_addr, isp_lsc_table_sel;
> +	unsigned int data;
> +
> +	isp_lsc_status = rkisp1_ioread32(params_vdev, CIF_ISP_LSC_STATUS);
> +
> +	/* CIF_ISP_LSC_TABLE_ADDRESS_153 = ( 17 * 18 ) >> 1 */
> +	sram_addr = (isp_lsc_status & CIF_ISP_LSC_ACTIVE_TABLE) ?
> +		     CIF_ISP_LSC_TABLE_ADDRESS_0 :
> +		     CIF_ISP_LSC_TABLE_ADDRESS_153;
> +	rkisp1_iowrite32(params_vdev, sram_addr, CIF_ISP_LSC_R_TABLE_ADDR);
> +	rkisp1_iowrite32(params_vdev, sram_addr, CIF_ISP_LSC_GR_TABLE_ADDR);
> +	rkisp1_iowrite32(params_vdev, sram_addr, CIF_ISP_LSC_GB_TABLE_ADDR);
> +	rkisp1_iowrite32(params_vdev, sram_addr, CIF_ISP_LSC_B_TABLE_ADDR);
> +
> +	/* program data tables (table size is 9 * 17 = 153) */
> +	for (i = 0; i < ((CIF_ISP_LSC_SECTORS_MAX + 1) *
> +	     (CIF_ISP_LSC_SECTORS_MAX + 1));
> +	     i += CIF_ISP_LSC_SECTORS_MAX + 1) {
> +		/*
> +		 * 17 sectors with 2 values in one DWORD = 9
> +		 * DWORDs (2nd value of last DWORD unused)
> +		 */
> +		for (j = 0; j < (CIF_ISP_LSC_SECTORS_MAX + 1); j += 2) {
> +			data = CIF_ISP_LSC_TABLE_DATA(
> +					pconfig->r_data_tbl[i + j],
> +					pconfig->r_data_tbl[i + j + 1]);
> +			rkisp1_iowrite32(params_vdev, data,
> +					 CIF_ISP_LSC_R_TABLE_DATA);
> +
> +			data = CIF_ISP_LSC_TABLE_DATA(
> +					pconfig->gr_data_tbl[i + j],
> +					pconfig->gr_data_tbl[i + j + 1]);
> +			rkisp1_iowrite32(params_vdev, data,
> +					 CIF_ISP_LSC_GR_TABLE_DATA);
> +
> +			data = CIF_ISP_LSC_TABLE_DATA(
> +					pconfig->gb_data_tbl[i + j],
> +					pconfig->gb_data_tbl[i + j + 1]);
> +			rkisp1_iowrite32(params_vdev, data,
> +					 CIF_ISP_LSC_GB_TABLE_DATA);
> +
> +			data = CIF_ISP_LSC_TABLE_DATA(
> +					pconfig->b_data_tbl[i + j],
> +					pconfig->b_data_tbl[i + j + 1]);
> +			rkisp1_iowrite32(params_vdev, data,
> +					 CIF_ISP_LSC_B_TABLE_DATA);
> +		}
> +	}
> +
> +	isp_lsc_table_sel = (isp_lsc_status & CIF_ISP_LSC_ACTIVE_TABLE) ?
> +				CIF_ISP_LSC_TABLE_0 : CIF_ISP_LSC_TABLE_1;
> +	rkisp1_iowrite32(params_vdev, isp_lsc_table_sel, CIF_ISP_LSC_TABLE_SEL);
> +}
> +
> +static void lsc_config(struct rkisp1_isp_params_vdev *params_vdev,
> +		       const struct cifisp_lsc_config *arg)
> +{
> +	int i;
> +	unsigned int data;
> +	u32 lsc_ctrl;
> +
> +	/* To config must be off , store the current status firstly */
> +	lsc_ctrl = rkisp1_ioread32(params_vdev, CIF_ISP_LSC_CTRL);
> +	isp_param_clear_bits(params_vdev, CIF_ISP_LSC_CTRL,
> +			     CIF_ISP_LSC_CTRL_ENA);
> +	__lsc_correct_matrix_config(params_vdev, arg);
> +
> +	if (params_vdev->active_lsc_width !=
> +	    arg->config_width ||
> +	    params_vdev->active_lsc_height != arg->config_height) {
> +		for (i = 0; i < 4; i++) {
> +			/* program x size tables */
> +			data = CIF_ISP_LSC_SECT_SIZE(arg->x_size_tbl[i * 2],
> +						arg->x_size_tbl[i * 2 + 1]);
> +			rkisp1_iowrite32(params_vdev, data,
> +					 CIF_ISP_LSC_XSIZE_01 + i * 4);
> +
> +			/* program x grad tables */
> +			data = CIF_ISP_LSC_SECT_SIZE(arg->x_grad_tbl[i * 2],
> +						arg->x_grad_tbl[i * 2 + 1]);
> +			rkisp1_iowrite32(params_vdev, data,
> +					 CIF_ISP_LSC_XGRAD_01 + i * 4);
> +
> +			/* program y size tables */
> +			data = CIF_ISP_LSC_SECT_SIZE(arg->y_size_tbl[i * 2],
> +						arg->y_size_tbl[i * 2 + 1]);
> +			rkisp1_iowrite32(params_vdev, data,
> +					 CIF_ISP_LSC_YSIZE_01 + i * 4);
> +
> +			/* program y grad tables */
> +			data = CIF_ISP_LSC_SECT_SIZE(arg->y_grad_tbl[i * 2],
> +						arg->y_grad_tbl[i * 2 + 1]);
> +			rkisp1_iowrite32(params_vdev, data,
> +					 CIF_ISP_LSC_YGRAD_01 + i * 4);
> +		}
> +
> +		params_vdev->active_lsc_width = arg->config_width;
> +		params_vdev->active_lsc_height = arg->config_height;
> +	}
> +
> +	/* restore the bls ctrl status */
> +	if (lsc_ctrl & CIF_ISP_LSC_CTRL_ENA) {
> +		isp_param_set_bits(params_vdev,
> +				   CIF_ISP_LSC_CTRL,
> +				   CIF_ISP_LSC_CTRL_ENA);
> +	} else {
> +		isp_param_clear_bits(params_vdev,
> +				     CIF_ISP_LSC_CTRL,
> +				     CIF_ISP_LSC_CTRL_ENA);
> +	}
> +}
> +
> +/* ISP Filtering function */
> +static void flt_config(struct rkisp1_isp_params_vdev *params_vdev,
> +		       const struct cifisp_flt_config *arg)
> +{
> +	rkisp1_iowrite32(params_vdev, arg->thresh_bl0, CIF_ISP_FILT_THRESH_BL0);
> +	rkisp1_iowrite32(params_vdev, arg->thresh_bl1, CIF_ISP_FILT_THRESH_BL1);
> +	rkisp1_iowrite32(params_vdev, arg->thresh_sh0, CIF_ISP_FILT_THRESH_SH0);
> +	rkisp1_iowrite32(params_vdev, arg->thresh_sh1, CIF_ISP_FILT_THRESH_SH1);
> +	rkisp1_iowrite32(params_vdev, arg->fac_bl0, CIF_ISP_FILT_FAC_BL0);
> +	rkisp1_iowrite32(params_vdev, arg->fac_bl1, CIF_ISP_FILT_FAC_BL1);
> +	rkisp1_iowrite32(params_vdev, arg->fac_mid, CIF_ISP_FILT_FAC_MID);
> +	rkisp1_iowrite32(params_vdev, arg->fac_sh0, CIF_ISP_FILT_FAC_SH0);
> +	rkisp1_iowrite32(params_vdev, arg->fac_sh1, CIF_ISP_FILT_FAC_SH1);
> +	rkisp1_iowrite32(params_vdev, arg->lum_weight, CIF_ISP_FILT_LUM_WEIGHT);
> +
> +	rkisp1_iowrite32(params_vdev, (arg->mode ? CIF_ISP_FLT_MODE_DNR : 0) |
> +			 CIF_ISP_FLT_CHROMA_V_MODE(arg->chr_v_mode) |
> +			 CIF_ISP_FLT_CHROMA_H_MODE(arg->chr_h_mode) |
> +			 CIF_ISP_FLT_GREEN_STAGE1(arg->grn_stage1),
> +			 CIF_ISP_FILT_MODE);
> +}
> +
> +/* ISP demosaic interface function */
> +static int bdm_config(struct rkisp1_isp_params_vdev *params_vdev,
> +		      const struct cifisp_bdm_config *arg)
> +{
> +	/*set demosaic threshold */
> +	rkisp1_iowrite32(params_vdev, arg->demosaic_th, CIF_ISP_DEMOSAIC);
> +	return 0;
> +}
> +
> +/* ISP GAMMA correction interface function */
> +static void sdg_config(struct rkisp1_isp_params_vdev *params_vdev,
> +		       const struct cifisp_sdg_config *arg)
> +{
> +	int i;
> +
> +	rkisp1_iowrite32(params_vdev,
> +			 arg->xa_pnts.gamma_dx0, CIF_ISP_GAMMA_DX_LO);
> +	rkisp1_iowrite32(params_vdev,
> +			 arg->xa_pnts.gamma_dx1, CIF_ISP_GAMMA_DX_HI);
> +
> +	for (i = 0; i < CIFISP_DEGAMMA_CURVE_SIZE; i++) {
> +		rkisp1_iowrite32(params_vdev, arg->curve_r.gamma_y[i],
> +				 CIF_ISP_GAMMA_R_Y0 + i * 4);
> +		rkisp1_iowrite32(params_vdev, arg->curve_g.gamma_y[i],
> +				 CIF_ISP_GAMMA_G_Y0 + i * 4);
> +		rkisp1_iowrite32(params_vdev, arg->curve_b.gamma_y[i],
> +				 CIF_ISP_GAMMA_B_Y0 + i * 4);
> +	}
> +}
> +
> +/* ISP GAMMA correction interface function */
> +static void goc_config(struct rkisp1_isp_params_vdev *params_vdev,
> +		       const struct cifisp_goc_config *arg)
> +{
> +	int i;
> +
> +	isp_param_clear_bits(params_vdev, CIF_ISP_CTRL,
> +			     CIF_ISP_CTRL_ISP_GAMMA_OUT_ENA);
> +	rkisp1_iowrite32(params_vdev, arg->mode, CIF_ISP_GAMMA_OUT_MODE);
> +
> +	for (i = 0; i < CIFISP_GAMMA_OUT_MAX_SAMPLES; i++)
> +		rkisp1_iowrite32(params_vdev, arg->gamma_y[i],
> +				 CIF_ISP_GAMMA_OUT_Y_0 + i * 4);
> +}
> +
> +/* ISP Cross Talk */
> +static void ctk_config(struct rkisp1_isp_params_vdev *params_vdev,
> +		       const struct cifisp_ctk_config *arg)
> +{
> +	rkisp1_iowrite32(params_vdev, arg->coeff0, CIF_ISP_CT_COEFF_0);
> +	rkisp1_iowrite32(params_vdev, arg->coeff1, CIF_ISP_CT_COEFF_1);
> +	rkisp1_iowrite32(params_vdev, arg->coeff2, CIF_ISP_CT_COEFF_2);
> +	rkisp1_iowrite32(params_vdev, arg->coeff3, CIF_ISP_CT_COEFF_3);
> +	rkisp1_iowrite32(params_vdev, arg->coeff4, CIF_ISP_CT_COEFF_4);
> +	rkisp1_iowrite32(params_vdev, arg->coeff5, CIF_ISP_CT_COEFF_5);
> +	rkisp1_iowrite32(params_vdev, arg->coeff6, CIF_ISP_CT_COEFF_6);
> +	rkisp1_iowrite32(params_vdev, arg->coeff7, CIF_ISP_CT_COEFF_7);
> +	rkisp1_iowrite32(params_vdev, arg->coeff8, CIF_ISP_CT_COEFF_8);
> +	rkisp1_iowrite32(params_vdev, arg->ct_offset_r, CIF_ISP_CT_OFFSET_R);
> +	rkisp1_iowrite32(params_vdev, arg->ct_offset_g, CIF_ISP_CT_OFFSET_G);
> +	rkisp1_iowrite32(params_vdev, arg->ct_offset_b, CIF_ISP_CT_OFFSET_B);
> +}
> +
> +static void ctk_enable(struct rkisp1_isp_params_vdev *params_vdev, bool en)
> +{
> +	if (en)
> +		return;
> +
> +	/* Write back the default values. */
> +	rkisp1_iowrite32(params_vdev, 0x80, CIF_ISP_CT_COEFF_0);
> +	rkisp1_iowrite32(params_vdev, 0, CIF_ISP_CT_COEFF_1);
> +	rkisp1_iowrite32(params_vdev, 0, CIF_ISP_CT_COEFF_2);
> +	rkisp1_iowrite32(params_vdev, 0, CIF_ISP_CT_COEFF_3);
> +	rkisp1_iowrite32(params_vdev, 0x80, CIF_ISP_CT_COEFF_4);
> +	rkisp1_iowrite32(params_vdev, 0, CIF_ISP_CT_COEFF_5);
> +	rkisp1_iowrite32(params_vdev, 0, CIF_ISP_CT_COEFF_6);
> +	rkisp1_iowrite32(params_vdev, 0, CIF_ISP_CT_COEFF_7);
> +	rkisp1_iowrite32(params_vdev, 0x80, CIF_ISP_CT_COEFF_8);
> +
> +	rkisp1_iowrite32(params_vdev, 0, CIF_ISP_CT_OFFSET_R);
> +	rkisp1_iowrite32(params_vdev, 0, CIF_ISP_CT_OFFSET_G);
> +	rkisp1_iowrite32(params_vdev, 0, CIF_ISP_CT_OFFSET_B);
> +}
> +
> +/* ISP White Balance Mode */
> +static void awb_meas_config(struct rkisp1_isp_params_vdev *params_vdev,
> +			    const struct cifisp_awb_meas_config *arg)
> +{
> +	/* based on the mode,configure the awb module */
> +	if (arg->awb_mode == CIFISP_AWB_MODE_YCBCR) {
> +		/* Reference Cb and Cr */
> +		rkisp1_iowrite32(params_vdev,
> +				 CIF_ISP_AWB_REF_CR_SET(arg->awb_ref_cr) |
> +				 arg->awb_ref_cb, CIF_ISP_AWB_REF);
> +		/* Yc Threshold */
> +		rkisp1_iowrite32(params_vdev,
> +				 CIF_ISP_AWB_MAX_Y_SET(arg->max_y) |
> +				 CIF_ISP_AWB_MIN_Y_SET(arg->min_y) |
> +				 CIF_ISP_AWB_MAX_CS_SET(arg->max_csum) |
> +				 arg->min_c, CIF_ISP_AWB_THRESH);
> +	}
> +
> +	/* window offset */
> +	rkisp1_iowrite32(params_vdev,
> +			 arg->awb_wnd.v_offs, CIF_ISP_AWB_WND_V_OFFS);
> +	rkisp1_iowrite32(params_vdev,
> +			 arg->awb_wnd.h_offs, CIF_ISP_AWB_WND_H_OFFS);
> +	/* AWB window size */
> +	rkisp1_iowrite32(params_vdev,
> +			 arg->awb_wnd.v_size, CIF_ISP_AWB_WND_V_SIZE);
> +	rkisp1_iowrite32(params_vdev,
> +			 arg->awb_wnd.h_size, CIF_ISP_AWB_WND_H_SIZE);
> +	/* Number of frames */
> +	rkisp1_iowrite32(params_vdev,
> +			 arg->frames, CIF_ISP_AWB_FRAMES);
> +}
> +
> +static void awb_meas_enable(struct rkisp1_isp_params_vdev *params_vdev,
> +			    const struct cifisp_awb_meas_config *arg, bool en)
> +{
> +	u32 reg_val = rkisp1_ioread32(params_vdev, CIF_ISP_AWB_PROP);
> +
> +	/* switch off */
> +	reg_val &= CIF_ISP_AWB_MODE_MASK_NONE;
> +
> +	if (en) {
> +		if (arg->awb_mode == CIFISP_AWB_MODE_RGB)
> +			reg_val |= CIF_ISP_AWB_MODE_RGB_EN;
> +		else
> +			reg_val |= CIF_ISP_AWB_MODE_YCBCR_EN;
> +
> +		rkisp1_iowrite32(params_vdev, reg_val, CIF_ISP_AWB_PROP);
> +
> +		/* Measurements require AWB block be active. */
> +		/* TODO: need to enable here ? awb_gain_enable has done this */
> +		isp_param_set_bits(params_vdev, CIF_ISP_CTRL,
> +				   CIF_ISP_CTRL_ISP_AWB_ENA);
> +	} else {
> +		rkisp1_iowrite32(params_vdev,
> +				 reg_val, CIF_ISP_AWB_PROP);
> +		isp_param_clear_bits(params_vdev, CIF_ISP_CTRL,
> +				     CIF_ISP_CTRL_ISP_AWB_ENA);
> +	}
> +}
> +
> +static void awb_gain_config(struct rkisp1_isp_params_vdev *params_vdev,
> +			    const struct cifisp_awb_gain_config *arg)
> +{
> +	rkisp1_iowrite32(params_vdev,
> +			 CIF_ISP_AWB_GAIN_R_SET(arg->gain_green_r) |
> +			 arg->gain_green_b, CIF_ISP_AWB_GAIN_G);
> +
> +	rkisp1_iowrite32(params_vdev, CIF_ISP_AWB_GAIN_R_SET(arg->gain_red) |
> +			 arg->gain_blue, CIF_ISP_AWB_GAIN_RB);
> +}
> +
> +static void aec_config(struct rkisp1_isp_params_vdev *params_vdev,
> +		       const struct cifisp_aec_config *arg)
> +{
> +	unsigned int block_hsize, block_vsize;
> +
> +	rkisp1_iowrite32(params_vdev,
> +			 ((arg->autostop) ? CIF_ISP_EXP_CTRL_AUTOSTOP : 0) |
> +			 ((arg->mode == CIFISP_EXP_MEASURING_MODE_1) ?
> +			 CIF_ISP_EXP_CTRL_MEASMODE_1 : 0), CIF_ISP_EXP_CTRL);
> +
> +	rkisp1_iowrite32(params_vdev,
> +			 arg->meas_window.h_offs, CIF_ISP_EXP_H_OFFSET);
> +	rkisp1_iowrite32(params_vdev,
> +			 arg->meas_window.v_offs, CIF_ISP_EXP_V_OFFSET);
> +
> +	block_hsize = arg->meas_window.h_size / CIF_ISP_EXP_COLUMN_NUM - 1;
> +	block_vsize = arg->meas_window.v_size / CIF_ISP_EXP_ROW_NUM - 1;
> +
> +	rkisp1_iowrite32(params_vdev, CIF_ISP_EXP_H_SIZE_SET(block_hsize),
> +			 CIF_ISP_EXP_H_SIZE);
> +	rkisp1_iowrite32(params_vdev, CIF_ISP_EXP_V_SIZE_SET(block_vsize),
> +			 CIF_ISP_EXP_V_SIZE);
> +}
> +
> +static void cproc_config(struct rkisp1_isp_params_vdev *params_vdev,
> +			 const struct cifisp_cproc_config *arg)
> +{
> +	/* TODO: get quantization, ie effect*/
> +	u32 quantization = V4L2_QUANTIZATION_FULL_RANGE;
> +	u32 effect = V4L2_COLORFX_NONE;
> +
> +	rkisp1_iowrite32(params_vdev, arg->contrast, CIF_C_PROC_CONTRAST);
> +	rkisp1_iowrite32(params_vdev, arg->hue, CIF_C_PROC_HUE);
> +	rkisp1_iowrite32(params_vdev, arg->sat, CIF_C_PROC_SATURATION);
> +	rkisp1_iowrite32(params_vdev, arg->brightness, CIF_C_PROC_BRIGHTNESS);
> +
> +	if (quantization != V4L2_QUANTIZATION_FULL_RANGE ||
> +	    effect != V4L2_COLORFX_NONE) {
> +		isp_param_clear_bits(params_vdev, CIF_C_PROC_CTRL,
> +				     CIF_C_PROC_YOUT_FULL |
> +				     CIF_C_PROC_YIN_FULL |
> +				     CIF_C_PROC_COUT_FULL);
> +	} else {
> +		isp_param_set_bits(params_vdev, CIF_C_PROC_CTRL,
> +				   CIF_C_PROC_YOUT_FULL |
> +				   CIF_C_PROC_YIN_FULL |
> +				   CIF_C_PROC_COUT_FULL);
> +	}
> +}
> +
> +static void hst_config(struct rkisp1_isp_params_vdev *params_vdev,
> +		       const struct cifisp_hst_config *arg)
> +{
> +	unsigned int block_hsize, block_vsize;
> +	static const u32 hist_weight_regs[] = {
> +		CIF_ISP_HIST_WEIGHT_00TO30, CIF_ISP_HIST_WEIGHT_40TO21,
> +		CIF_ISP_HIST_WEIGHT_31TO12, CIF_ISP_HIST_WEIGHT_22TO03,
> +		CIF_ISP_HIST_WEIGHT_13TO43, CIF_ISP_HIST_WEIGHT_04TO34,
> +		CIF_ISP_HIST_WEIGHT_44,
> +	};
> +	const u8 *weight;
> +	int i;
> +
> +	rkisp1_iowrite32(params_vdev,
> +			 CIF_ISP_HIST_PREDIV_SET(arg->histogram_predivider),
> +			 CIF_ISP_HIST_PROP);
> +	rkisp1_iowrite32(params_vdev,
> +			 arg->meas_window.h_offs,
> +			 CIF_ISP_HIST_H_OFFS);
> +	rkisp1_iowrite32(params_vdev,
> +			 arg->meas_window.v_offs,
> +			 CIF_ISP_HIST_V_OFFS);
> +
> +	block_hsize = arg->meas_window.h_size / CIF_ISP_HIST_COLUMN_NUM - 1;
> +	block_vsize = arg->meas_window.v_size / CIF_ISP_HIST_ROW_NUM - 1;
> +
> +	rkisp1_iowrite32(params_vdev, block_hsize, CIF_ISP_HIST_H_SIZE);
> +	rkisp1_iowrite32(params_vdev, block_vsize, CIF_ISP_HIST_V_SIZE);
> +
> +	weight = arg->hist_weight;
> +	for (i = 0; i < ARRAY_SIZE(hist_weight_regs); ++i, weight += 4)
> +		rkisp1_iowrite32(params_vdev, CIF_ISP_HIST_WEIGHT_SET(
> +				 weight[0], weight[1], weight[2], weight[3]),
> +				 hist_weight_regs[i]);
> +}
> +
> +static void hst_enable(struct rkisp1_isp_params_vdev *params_vdev,
> +		       const struct cifisp_hst_config *arg, bool en)
> +{
> +	if (en)	{
> +		u32 hist_prop = rkisp1_ioread32(params_vdev, CIF_ISP_HIST_PROP);
> +
> +		hist_prop &= ~CIF_ISP_HIST_PROP_MODE_MASK | arg->mode;
> +		isp_param_set_bits(params_vdev, CIF_ISP_HIST_PROP, hist_prop);
> +	} else {
> +		isp_param_clear_bits(params_vdev, CIF_ISP_HIST_PROP,
> +				     CIF_ISP_HIST_PROP_MODE_MASK);
> +	}
> +}
> +
> +static inline unsigned int afm_calc_luminanceshift(const unsigned int
> +							maxpixelcnt)
> +{
> +	unsigned int lgrad = maxpixelcnt;
> +	unsigned int lshift = 0U;
> +
> +	while (lgrad > 65793) {
> +		++lshift;
> +		lgrad >>= 1;
> +	}
> +
> +	return lshift;
> +}
> +
> +static inline unsigned int afm_calc_tennenggradshift(const unsigned int
> +							maxpixelcnt)
> +{
> +	unsigned int tgrad = maxpixelcnt;
> +	unsigned int tshift = 0U;
> +
> +	while (tgrad > (128 * 128)) {
> +		++tshift;
> +		tgrad >>= 1;
> +	}
> +
> +	return tshift;
> +}
> +
> +static void afm_config(struct rkisp1_isp_params_vdev *params_vdev,
> +		       const struct cifisp_afc_config *arg)
> +{
> +	size_t num_of_win = min_t(size_t, ARRAY_SIZE(arg->afm_win), arg->num_afm_win);
> +	int i;
> +
> +	/* Switch off to configure. Enabled during normal flow in frame isr. */
> +	isp_param_clear_bits(params_vdev, CIF_ISP_AFM_CTRL, CIF_ISP_AFM_ENA);
> +
> +	for (i = 0; i < num_of_win; i++) {
> +		rkisp1_iowrite32(params_vdev,
> +				 CIF_ISP_AFM_WINDOW_X(arg->afm_win[i].h_offs) |
> +				 CIF_ISP_AFM_WINDOW_Y(arg->afm_win[i].v_offs),
> +				 CIF_ISP_AFM_LT_A + i * 8);
> +		rkisp1_iowrite32(params_vdev,
> +				 CIF_ISP_AFM_WINDOW_X(arg->afm_win[i].h_size +
> +						      arg->afm_win[i].h_offs) |
> +				 CIF_ISP_AFM_WINDOW_Y(arg->afm_win[i].v_size +
> +						      arg->afm_win[i].v_offs),
> +				 CIF_ISP_AFM_RB_A + i * 8);
> +	}
> +	rkisp1_iowrite32(params_vdev, arg->thres, CIF_ISP_AFM_THRES);
> +	rkisp1_iowrite32(params_vdev, arg->var_shift, CIF_ISP_AFM_VAR_SHIFT);
> +}
> +
> +static void ie_config(struct rkisp1_isp_params_vdev *params_vdev,
> +		      const struct cifisp_ie_config *arg)
> +{
> +	u32 eff_ctrl;
> +
> +	eff_ctrl = rkisp1_ioread32(params_vdev, CIF_IMG_EFF_CTRL);
> +	eff_ctrl &= ~CIF_IMG_EFF_CTRL_MODE_MASK;
> +
> +	switch (arg->effect) {
> +	case V4L2_COLORFX_SEPIA:
> +		eff_ctrl |= CIF_IMG_EFF_CTRL_MODE_SEPIA;
> +		break;
> +	case V4L2_COLORFX_SET_CBCR:
> +		rkisp1_iowrite32(params_vdev, arg->eff_tint, CIF_IMG_EFF_TINT);
> +		eff_ctrl |= CIF_IMG_EFF_CTRL_MODE_SEPIA;
> +		break;
> +		/*
> +		 * Color selection is similar to water color(AQUA):
> +		 * grayscale + selected color w threshold
> +		 */
> +	case V4L2_COLORFX_AQUA:
> +		eff_ctrl |= CIF_IMG_EFF_CTRL_MODE_COLOR_SEL;
> +		rkisp1_iowrite32(params_vdev, arg->color_sel,
> +				 CIF_IMG_EFF_COLOR_SEL);
> +		break;
> +	case V4L2_COLORFX_EMBOSS:
> +		eff_ctrl |= CIF_IMG_EFF_CTRL_MODE_EMBOSS;
> +		rkisp1_iowrite32(params_vdev, arg->eff_mat_1,
> +				 CIF_IMG_EFF_MAT_1);
> +		rkisp1_iowrite32(params_vdev, arg->eff_mat_2,
> +				 CIF_IMG_EFF_MAT_2);
> +		rkisp1_iowrite32(params_vdev, arg->eff_mat_3,
> +				 CIF_IMG_EFF_MAT_3);
> +		break;
> +	case V4L2_COLORFX_SKETCH:
> +		eff_ctrl |= CIF_IMG_EFF_CTRL_MODE_SKETCH;
> +		rkisp1_iowrite32(params_vdev, arg->eff_mat_3,
> +				 CIF_IMG_EFF_MAT_3);
> +		rkisp1_iowrite32(params_vdev, arg->eff_mat_4,
> +				 CIF_IMG_EFF_MAT_4);
> +		rkisp1_iowrite32(params_vdev, arg->eff_mat_5,
> +				 CIF_IMG_EFF_MAT_5);
> +		break;
> +	case V4L2_COLORFX_BW:
> +		eff_ctrl |= CIF_IMG_EFF_CTRL_MODE_BLACKWHITE;
> +		break;
> +	case V4L2_COLORFX_NEGATIVE:
> +		eff_ctrl |= CIF_IMG_EFF_CTRL_MODE_NEGATIVE;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	rkisp1_iowrite32(params_vdev, eff_ctrl, CIF_IMG_EFF_CTRL);
> +}
> +
> +static void ie_enable(struct rkisp1_isp_params_vdev *params_vdev, bool en)
> +{
> +	if (en) {
> +		isp_param_set_bits(params_vdev, CIF_ICCL, CIF_ICCL_IE_CLK);
> +		rkisp1_iowrite32(params_vdev, CIF_IMG_EFF_CTRL_ENABLE,
> +				 CIF_IMG_EFF_CTRL);
> +		isp_param_set_bits(params_vdev, CIF_IMG_EFF_CTRL,
> +				   CIF_IMG_EFF_CTRL_CFG_UPD);
> +	} else {
> +		/* Disable measurement */
> +		isp_param_clear_bits(params_vdev, CIF_IMG_EFF_CTRL,
> +				     CIF_IMG_EFF_CTRL_ENABLE);
> +		isp_param_clear_bits(params_vdev, CIF_ICCL, CIF_ICCL_IE_CLK);
> +	}
> +}
> +
> +static void csm_config(struct rkisp1_isp_params_vdev *params_vdev,
> +		       bool full_range)
> +{
> +	static const u16 full_range_coeff[] = {
> +		0x0026, 0x004b, 0x000f,
> +		0x01ea, 0x01d6, 0x0040,
> +		0x0040, 0x01ca, 0x01f6
> +	};
> +	static const u16 limited_range_coeff[] = {
> +		0x0021, 0x0040, 0x000d,
> +		0x01ed, 0x01db, 0x0038,
> +		0x0038, 0x01d1, 0x01f7,
> +	};
> +	int i;
> +
> +	if (full_range) {
> +		for (i = 0; i < ARRAY_SIZE(full_range_coeff); i++)
> +			rkisp1_iowrite32(params_vdev, full_range_coeff[i],
> +					 CIF_ISP_CC_COEFF_0 + i * 4);
> +
> +		isp_param_set_bits(params_vdev, CIF_ISP_CTRL,
> +				   CIF_ISP_CTRL_ISP_CSM_Y_FULL_ENA |
> +				   CIF_ISP_CTRL_ISP_CSM_C_FULL_ENA);
> +	} else {
> +		for (i = 0; i < ARRAY_SIZE(limited_range_coeff); i++)
> +			rkisp1_iowrite32(params_vdev, limited_range_coeff[i],
> +					 CIF_ISP_CC_COEFF_0 + i * 4);
> +
> +		isp_param_clear_bits(params_vdev, CIF_ISP_CTRL,
> +				     CIF_ISP_CTRL_ISP_CSM_Y_FULL_ENA |
> +				     CIF_ISP_CTRL_ISP_CSM_C_FULL_ENA);
> +	}
> +}
> +
> +/* ISP De-noise Pre-Filter(DPF) function */
> +static void dpf_config(struct rkisp1_isp_params_vdev *params_vdev,
> +		       const struct cifisp_dpf_config *arg)
> +{
> +	unsigned int isp_dpf_mode;
> +	unsigned int spatial_coeff;
> +	unsigned int i;
> +
> +	switch (arg->gain.mode) {
> +	case CIFISP_DPF_GAIN_USAGE_NF_GAINS:
> +		isp_dpf_mode = CIF_ISP_DPF_MODE_USE_NF_GAIN |
> +				CIF_ISP_DPF_MODE_AWB_GAIN_COMP;
> +		break;
> +	case CIFISP_DPF_GAIN_USAGE_LSC_GAINS:
> +		isp_dpf_mode = CIF_ISP_DPF_MODE_LSC_GAIN_COMP;
> +		break;
> +	case CIFISP_DPF_GAIN_USAGE_NF_LSC_GAINS:
> +		isp_dpf_mode = CIF_ISP_DPF_MODE_USE_NF_GAIN |
> +				CIF_ISP_DPF_MODE_AWB_GAIN_COMP |
> +				CIF_ISP_DPF_MODE_LSC_GAIN_COMP;
> +		break;
> +	case CIFISP_DPF_GAIN_USAGE_AWB_GAINS:
> +		isp_dpf_mode = CIF_ISP_DPF_MODE_AWB_GAIN_COMP;
> +		break;
> +	case CIFISP_DPF_GAIN_USAGE_AWB_LSC_GAINS:
> +		isp_dpf_mode = CIF_ISP_DPF_MODE_LSC_GAIN_COMP |
> +				CIF_ISP_DPF_MODE_AWB_GAIN_COMP;
> +		break;
> +	case CIFISP_DPF_GAIN_USAGE_DISABLED:
> +	default:
> +		isp_dpf_mode = 0;
> +		break;
> +	}
> +
> +	if (arg->nll.scale_mode == CIFISP_NLL_SCALE_LOGARITHMIC)
> +		isp_dpf_mode |= CIF_ISP_DPF_MODE_NLL_SEGMENTATION;
> +	if (arg->rb_flt.fltsize == CIFISP_DPF_RB_FILTERSIZE_9x9)
> +		isp_dpf_mode |= CIF_ISP_DPF_MODE_RB_FLTSIZE_9x9;
> +	if (!arg->rb_flt.r_enable)
> +		isp_dpf_mode |= CIF_ISP_DPF_MODE_R_FLT_DIS;
> +	if (!arg->rb_flt.b_enable)
> +		isp_dpf_mode |= CIF_ISP_DPF_MODE_B_FLT_DIS;
> +	if (!arg->g_flt.gb_enable)
> +		isp_dpf_mode |= CIF_ISP_DPF_MODE_GB_FLT_DIS;
> +	if (!arg->g_flt.gr_enable)
> +		isp_dpf_mode |= CIF_ISP_DPF_MODE_GR_FLT_DIS;
> +
> +	isp_param_set_bits(params_vdev, CIF_ISP_DPF_MODE, isp_dpf_mode);
> +	rkisp1_iowrite32(params_vdev, arg->gain.nf_b_gain,
> +			 CIF_ISP_DPF_NF_GAIN_B);
> +	rkisp1_iowrite32(params_vdev, arg->gain.nf_r_gain,
> +			 CIF_ISP_DPF_NF_GAIN_R);
> +	rkisp1_iowrite32(params_vdev, arg->gain.nf_gb_gain,
> +			 CIF_ISP_DPF_NF_GAIN_GB);
> +	rkisp1_iowrite32(params_vdev, arg->gain.nf_gr_gain,
> +			 CIF_ISP_DPF_NF_GAIN_GR);
> +
> +	for (i = 0; i < CIFISP_DPF_MAX_NLF_COEFFS; i++) {
> +		rkisp1_iowrite32(params_vdev, arg->nll.coeff[i],
> +				 CIF_ISP_DPF_NULL_COEFF_0 + i * 4);
> +	}
> +
> +	spatial_coeff = arg->g_flt.spatial_coeff[0] |
> +			(arg->g_flt.spatial_coeff[1] << 8) |
> +			(arg->g_flt.spatial_coeff[2] << 16) |
> +			(arg->g_flt.spatial_coeff[3] << 24);
> +	rkisp1_iowrite32(params_vdev, spatial_coeff,
> +			 CIF_ISP_DPF_S_WEIGHT_G_1_4);
> +
> +	spatial_coeff = arg->g_flt.spatial_coeff[4] |
> +			(arg->g_flt.spatial_coeff[5] << 8);
> +	rkisp1_iowrite32(params_vdev, spatial_coeff,
> +			 CIF_ISP_DPF_S_WEIGHT_G_5_6);
> +
> +	spatial_coeff = arg->rb_flt.spatial_coeff[0] |
> +			(arg->rb_flt.spatial_coeff[1] << 8) |
> +			(arg->rb_flt.spatial_coeff[2] << 16) |
> +			(arg->rb_flt.spatial_coeff[3] << 24);
> +	rkisp1_iowrite32(params_vdev, spatial_coeff,
> +			 CIF_ISP_DPF_S_WEIGHT_RB_1_4);
> +
> +	spatial_coeff = arg->rb_flt.spatial_coeff[4] |
> +			(arg->rb_flt.spatial_coeff[5] << 8);
> +	rkisp1_iowrite32(params_vdev, spatial_coeff,
> +			CIF_ISP_DPF_S_WEIGHT_RB_5_6);
> +}
> +
> +static void dpf_strength_config(struct rkisp1_isp_params_vdev *params_vdev,
> +				const struct cifisp_dpf_strength_config *arg)
> +{
> +	rkisp1_iowrite32(params_vdev, arg->b, CIF_ISP_DPF_STRENGTH_B);
> +	rkisp1_iowrite32(params_vdev, arg->g, CIF_ISP_DPF_STRENGTH_G);
> +	rkisp1_iowrite32(params_vdev, arg->r, CIF_ISP_DPF_STRENGTH_R);
> +}
> +
> +static __maybe_unused
> +void __isp_isr_other_config(struct rkisp1_isp_params_vdev *params_vdev,
> +			    const struct rkisp1_isp_params_cfg *new_params)
> +{
> +	unsigned int module_en_update, module_cfg_update, module_ens;
> +
> +	module_en_update = new_params->module_en_update;
> +	module_cfg_update = new_params->module_cfg_update;
> +	module_ens = new_params->module_ens;
> +
> +	if ((module_en_update & CIFISP_MODULE_DPCC) ||
> +	    (module_cfg_update & CIFISP_MODULE_DPCC)) {
> +		/*update dpc config */
> +		if ((module_cfg_update & CIFISP_MODULE_DPCC))
> +			dpcc_config(params_vdev,
> +				    &new_params->others.dpcc_config);
> +
> +		if (module_en_update & CIFISP_MODULE_DPCC) {
> +			if (!!(module_ens & CIFISP_MODULE_DPCC))
> +				isp_param_set_bits(params_vdev,
> +						   CIF_ISP_DPCC_MODE,
> +						   CIF_ISP_DPCC_ENA);
> +			else
> +				isp_param_clear_bits(params_vdev,
> +						     CIF_ISP_DPCC_MODE,
> +						     CIF_ISP_DPCC_ENA);
> +		}
> +	}
> +
> +	if ((module_en_update & CIFISP_MODULE_BLS) ||
> +	    (module_cfg_update & CIFISP_MODULE_BLS)) {
> +		/* update bls config */
> +		if ((module_cfg_update & CIFISP_MODULE_BLS))
> +			bls_config(params_vdev, &new_params->others.bls_config);
> +
> +		if (module_en_update & CIFISP_MODULE_BLS) {
> +			if (!!(module_ens & CIFISP_MODULE_BLS))
> +				isp_param_set_bits(params_vdev,
> +						   CIF_ISP_BLS_CTRL,
> +						   CIF_ISP_BLS_ENA);
> +			else
> +				isp_param_clear_bits(params_vdev,
> +						     CIF_ISP_BLS_CTRL,
> +						     CIF_ISP_BLS_ENA);
> +		}
> +	}
> +
> +	if ((module_en_update & CIFISP_MODULE_SDG) ||
> +	    (module_cfg_update & CIFISP_MODULE_SDG)) {
> +		/* update sdg config */
> +		if ((module_cfg_update & CIFISP_MODULE_SDG))
> +			sdg_config(params_vdev, &new_params->others.sdg_config);
> +
> +		if (module_en_update & CIFISP_MODULE_SDG) {
> +			if (!!(module_ens & CIFISP_MODULE_SDG))
> +				isp_param_set_bits(params_vdev,
> +						CIF_ISP_CTRL,
> +						CIF_ISP_CTRL_ISP_GAMMA_IN_ENA);
> +			else
> +				isp_param_clear_bits(params_vdev,
> +						CIF_ISP_CTRL,
> +						CIF_ISP_CTRL_ISP_GAMMA_IN_ENA);
> +		}
> +	}
> +
> +	if ((module_en_update & CIFISP_MODULE_LSC) ||
> +	    (module_cfg_update & CIFISP_MODULE_LSC)) {
> +		/* update lsc config */
> +		if ((module_cfg_update & CIFISP_MODULE_LSC))
> +			lsc_config(params_vdev, &new_params->others.lsc_config);
> +
> +		if (module_en_update & CIFISP_MODULE_LSC) {
> +			if (!!(module_ens & CIFISP_MODULE_LSC))
> +				isp_param_set_bits(params_vdev,
> +						   CIF_ISP_LSC_CTRL,
> +						   CIF_ISP_LSC_CTRL_ENA);
> +			else
> +				isp_param_clear_bits(params_vdev,
> +						     CIF_ISP_LSC_CTRL,
> +						     CIF_ISP_LSC_CTRL_ENA);
> +		}
> +	}
> +
> +	if ((module_en_update & CIFISP_MODULE_AWB_GAIN) ||
> +	    (module_cfg_update & CIFISP_MODULE_AWB_GAIN)) {
> +		/* update awb gains */
> +		if ((module_cfg_update & CIFISP_MODULE_AWB_GAIN))
> +			awb_gain_config(params_vdev,
> +					&new_params->others.awb_gain_config);
> +
> +		if (module_en_update & CIFISP_MODULE_AWB_GAIN) {
> +			if (!!(module_ens & CIFISP_MODULE_AWB_GAIN))
> +				isp_param_set_bits(params_vdev,
> +						   CIF_ISP_CTRL,
> +						   CIF_ISP_CTRL_ISP_AWB_ENA);
> +			else
> +				isp_param_clear_bits(params_vdev,
> +						     CIF_ISP_CTRL,
> +						     CIF_ISP_CTRL_ISP_AWB_ENA);
> +		}
> +	}
> +
> +	if ((module_en_update & CIFISP_MODULE_BDM) ||
> +	    (module_cfg_update & CIFISP_MODULE_BDM)) {
> +		/* update bdm config */
> +		if ((module_cfg_update & CIFISP_MODULE_BDM))
> +			bdm_config(params_vdev, &new_params->others.bdm_config);
> +
> +		if (module_en_update & CIFISP_MODULE_BDM) {
> +			if (!!(module_ens & CIFISP_MODULE_BDM))
> +				isp_param_set_bits(params_vdev,
> +						   CIF_ISP_DEMOSAIC,
> +						   CIF_ISP_DEMOSAIC_BYPASS);
> +			else
> +				isp_param_clear_bits(params_vdev,
> +						     CIF_ISP_DEMOSAIC,
> +						     CIF_ISP_DEMOSAIC_BYPASS);
> +		}
> +	}
> +
> +	if ((module_en_update & CIFISP_MODULE_FLT) ||
> +	    (module_cfg_update & CIFISP_MODULE_FLT)) {
> +		/* update filter config */
> +		if ((module_cfg_update & CIFISP_MODULE_FLT))
> +			flt_config(params_vdev, &new_params->others.flt_config);
> +
> +		if (module_en_update & CIFISP_MODULE_FLT) {
> +			if (!!(module_ens & CIFISP_MODULE_FLT))
> +				isp_param_set_bits(params_vdev,
> +						   CIF_ISP_FILT_MODE,
> +						   CIF_ISP_FLT_ENA);
> +			else
> +				isp_param_clear_bits(params_vdev,
> +						     CIF_ISP_FILT_MODE,
> +						     CIF_ISP_FLT_ENA);
> +		}
> +	}
> +
> +	if ((module_en_update & CIFISP_MODULE_CTK) ||
> +	    (module_cfg_update & CIFISP_MODULE_CTK)) {
> +		/* update ctk config */
> +		if ((module_cfg_update & CIFISP_MODULE_CTK))
> +			ctk_config(params_vdev, &new_params->others.ctk_config);
> +
> +		if (module_en_update & CIFISP_MODULE_CTK)
> +			ctk_enable(params_vdev,
> +				   !!(module_ens & CIFISP_MODULE_CTK));
> +	}
> +
> +	if ((module_en_update & CIFISP_MODULE_GOC) ||
> +	    (module_cfg_update & CIFISP_MODULE_GOC)) {
> +		/* update goc config */
> +		if ((module_cfg_update & CIFISP_MODULE_CTK))
> +			goc_config(params_vdev, &new_params->others.goc_config);
> +
> +		if (module_en_update & CIFISP_MODULE_GOC) {
> +			if (!!(module_ens & CIFISP_MODULE_GOC))
> +				isp_param_set_bits(params_vdev,
> +						CIF_ISP_CTRL,
> +						CIF_ISP_CTRL_ISP_GAMMA_OUT_ENA);
> +			else
> +				isp_param_clear_bits(params_vdev,
> +						CIF_ISP_CTRL,
> +						CIF_ISP_CTRL_ISP_GAMMA_OUT_ENA);
> +		}
> +	}
> +
> +	if ((module_en_update & CIFISP_MODULE_CPROC) ||
> +	    (module_cfg_update & CIFISP_MODULE_CPROC)) {
> +		/* update cprc config */
> +		if ((module_cfg_update & CIFISP_MODULE_CPROC)) {
> +			cproc_config(params_vdev,
> +				     &new_params->others.cproc_config);
> +			/* TODO: get range */
> +			csm_config(params_vdev, true);
> +		}
> +
> +		if (module_en_update & CIFISP_MODULE_CPROC) {
> +			if (!!(module_ens & CIFISP_MODULE_CPROC))
> +				isp_param_set_bits(params_vdev,
> +						   CIF_C_PROC_CTRL,
> +						   CIF_C_PROC_CTR_ENABLE);
> +			else
> +				isp_param_clear_bits(params_vdev,
> +						   CIF_C_PROC_CTRL,
> +						   CIF_C_PROC_CTR_ENABLE);
> +		}
> +	}
> +
> +	if ((module_en_update & CIFISP_MODULE_IE) ||
> +	    (module_cfg_update & CIFISP_MODULE_IE)) {
> +		/* update ie config */
> +		if ((module_cfg_update & CIFISP_MODULE_IE))
> +			ie_config(params_vdev, &new_params->others.ie_config);
> +
> +		if (module_en_update & CIFISP_MODULE_IE)
> +			ie_enable(params_vdev,
> +				   !!(module_ens & CIFISP_MODULE_IE));
> +	}
> +
> +	if ((module_en_update & CIFISP_MODULE_DPF) ||
> +	    (module_cfg_update & CIFISP_MODULE_DPF)) {
> +		/* update dpf  config */
> +		if ((module_cfg_update & CIFISP_MODULE_DPF))
> +			dpf_config(params_vdev, &new_params->others.dpf_config);
> +
> +		if (module_en_update & CIFISP_MODULE_DPF) {
> +			if (!!(module_ens & CIFISP_MODULE_DPF))
> +				isp_param_set_bits(params_vdev,
> +						   CIF_ISP_DPF_MODE,
> +						   CIF_ISP_DPF_MODE_EN);
> +			else
> +				isp_param_clear_bits(params_vdev,
> +						     CIF_ISP_DPF_MODE,
> +						     CIF_ISP_DPF_MODE_EN);
> +		}
> +	}
> +
> +	if ((module_en_update & CIFISP_MODULE_DPF_STRENGTH) ||
> +	    (module_cfg_update & CIFISP_MODULE_DPF_STRENGTH)) {
> +		/* update dpf strength config */
> +		dpf_strength_config(params_vdev,
> +				    &new_params->others.dpf_strength_config);
> +	}
> +}
> +
> +static __maybe_unused
> +void __isp_isr_meas_config(struct rkisp1_isp_params_vdev *params_vdev,
> +			   struct  rkisp1_isp_params_cfg *new_params)
> +{
> +	unsigned int module_en_update, module_cfg_update, module_ens;
> +
> +	module_en_update = new_params->module_en_update;
> +	module_cfg_update = new_params->module_cfg_update;
> +	module_ens = new_params->module_ens;
> +
> +	if ((module_en_update & CIFISP_MODULE_AWB) ||
> +	    (module_cfg_update & CIFISP_MODULE_AWB)) {
> +		/* update awb config */
> +		if ((module_cfg_update & CIFISP_MODULE_AWB))
> +			awb_meas_config(params_vdev,
> +					&new_params->meas.awb_meas_config);
> +
> +		if (module_en_update & CIFISP_MODULE_AWB)
> +			awb_meas_enable(params_vdev,
> +					&new_params->meas.awb_meas_config,
> +					!!(module_ens & CIFISP_MODULE_AWB));
> +	}
> +
> +	if ((module_en_update & CIFISP_MODULE_AFC) ||
> +	    (module_cfg_update & CIFISP_MODULE_AFC)) {
> +		/* update afc config */
> +		if ((module_cfg_update & CIFISP_MODULE_AFC))
> +			afm_config(params_vdev, &new_params->meas.afc_config);
> +
> +		if (module_en_update & CIFISP_MODULE_AFC) {
> +			if (!!(module_ens & CIFISP_MODULE_AFC))
> +				isp_param_set_bits(params_vdev,
> +						   CIF_ISP_AFM_CTRL,
> +						   CIF_ISP_AFM_ENA);
> +			else
> +				isp_param_clear_bits(params_vdev,
> +						     CIF_ISP_AFM_CTRL,
> +						     CIF_ISP_AFM_ENA);
> +		}
> +	}
> +
> +	if ((module_en_update & CIFISP_MODULE_HST) ||
> +	    (module_cfg_update & CIFISP_MODULE_HST)) {
> +		/* update hst config */
> +		if ((module_cfg_update & CIFISP_MODULE_HST))
> +			hst_config(params_vdev, &new_params->meas.hst_config);
> +
> +		if (module_en_update & CIFISP_MODULE_HST)
> +			hst_enable(params_vdev,
> +				   &new_params->meas.hst_config,
> +				   !!(module_ens & CIFISP_MODULE_HST));
> +	}
> +
> +	if ((module_en_update & CIFISP_MODULE_AEC) ||
> +	    (module_cfg_update & CIFISP_MODULE_AEC)) {
> +		/* update aec config */
> +		if ((module_cfg_update & CIFISP_MODULE_AEC))
> +			aec_config(params_vdev, &new_params->meas.aec_config);
> +
> +		if (module_en_update & CIFISP_MODULE_AEC) {
> +			if (!!(module_ens & CIFISP_MODULE_AEC))
> +				isp_param_set_bits(params_vdev,
> +						   CIF_ISP_EXP_CTRL,
> +						   CIF_ISP_EXP_ENA);
> +			else
> +				isp_param_clear_bits(params_vdev,
> +						     CIF_ISP_EXP_CTRL,
> +						     CIF_ISP_EXP_ENA);
> +		}
> +	}
> +}
> +
> +void rkisp1_params_isr(struct rkisp1_isp_params_vdev *params_vdev, u32 isp_mis)
> +{
> +	struct rkisp1_isp_params_cfg *new_params;
> +	struct rkisp1_buffer *cur_buf = NULL;
> +
> +	spin_lock(&params_vdev->config_lock);
> +	if (!params_vdev->streamon) {
> +		spin_unlock(&params_vdev->config_lock);
> +		return;
> +	}
> +
> +	/* get one empty buffer */
> +	if (!list_empty(&params_vdev->params))
> +		cur_buf = list_first_entry(&params_vdev->params,
> +					   struct rkisp1_buffer, queue);
> +	spin_unlock(&params_vdev->config_lock);
> +
> +	if (!cur_buf)
> +		return;
> +
> +	new_params = (struct rkisp1_isp_params_cfg *)(cur_buf->vaddr[0]);
> +
> +	if (isp_mis & CIF_ISP_FRAME) {
> +		/* __isp_isr_other_config(params_vdev, new_params); */
> +		/* __isp_isr_meas_config(params_vdev, new_params); */
> +		spin_lock(&params_vdev->config_lock);
> +		list_del(&cur_buf->queue);
> +		spin_unlock(&params_vdev->config_lock);
> +		vb2_buffer_done(&cur_buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
> +	}
> +}
> +
> +static const struct cifisp_awb_meas_config awb_params_default_config = {
> +	{
> +		0, 0, RKISP1_DEFAULT_WIDTH, RKISP1_DEFAULT_HEIGHT
> +	},
> +	CIFISP_AWB_MODE_YCBCR, 200, 30, 20, 20, 0, 128, 128
> +};
> +
> +static const struct cifisp_aec_config aec_params_default_config = {
> +	CIFISP_EXP_MEASURING_MODE_0,
> +	CIFISP_EXP_CTRL_AUTOSTOP_0,
> +	{
> +		RKISP1_DEFAULT_WIDTH >> 2, RKISP1_DEFAULT_HEIGHT >> 2,
> +		RKISP1_DEFAULT_WIDTH >> 1, RKISP1_DEFAULT_HEIGHT >> 1
> +	}
> +};
> +
> +static const struct cifisp_hst_config hst_params_default_config = {
> +	CIFISP_HISTOGRAM_MODE_RGB_COMBINED,
> +	3,
> +	{
> +		RKISP1_DEFAULT_WIDTH >> 2, RKISP1_DEFAULT_HEIGHT >> 2,
> +		RKISP1_DEFAULT_WIDTH >> 1, RKISP1_DEFAULT_HEIGHT >> 1
> +	},
> +	{
> +		0, /* To be filled in with 0x01 at runtime. */
> +	}
> +};
> +
> +static const struct cifisp_afc_config afc_params_default_config = {
> +	1,
> +	{
> +		{
> +			300, 225, 200, 150
> +		}
> +	},
> +	4,
> +	14
> +};
> +
> +static
> +void rkisp1_params_config_parameter(struct rkisp1_isp_params_vdev *params_vdev)
> +{
> +	struct cifisp_hst_config hst = hst_params_default_config;
> +
> +	spin_lock(&params_vdev->config_lock);
> +
> +	awb_meas_config(params_vdev, &awb_params_default_config);
> +	awb_meas_enable(params_vdev, &awb_params_default_config, true);
> +
> +	aec_config(params_vdev, &aec_params_default_config);
> +	isp_param_set_bits(params_vdev, CIF_ISP_EXP_CTRL, CIF_ISP_EXP_ENA);
> +
> +	afm_config(params_vdev, &afc_params_default_config);
> +	isp_param_set_bits(params_vdev, CIF_ISP_AFM_CTRL, CIF_ISP_AFM_ENA);
> +
> +	memset(hst.hist_weight, 0x01, sizeof(hst.hist_weight));
> +	hst_config(params_vdev, &hst);
> +	isp_param_set_bits(params_vdev, CIF_ISP_HIST_PROP,
> +			   ~CIF_ISP_HIST_PROP_MODE_MASK |
> +			   hst_params_default_config.mode);
> +
> +	spin_unlock(&params_vdev->config_lock);
> +}
> +
> +/* Not called when the camera active, thus not isr protection. */
> +void rkisp1_configure_isp(struct rkisp1_isp_params_vdev *params_vdev,
> +			  struct ispsd_in_fmt *in_fmt,
> +			  enum v4l2_quantization quantization)
> +{
> +	/*TODO: default config ?  */
> +	rkisp1_params_config_parameter(params_vdev);
> +}
> +
> +/* Not called when the camera active, thus not isr protection. */
> +void rkisp1_disable_isp(struct rkisp1_isp_params_vdev *params_vdev)
> +{
> +	isp_param_clear_bits(params_vdev, CIF_ISP_DPCC_MODE, CIF_ISP_DPCC_ENA);
> +	isp_param_clear_bits(params_vdev, CIF_ISP_LSC_CTRL,
> +			     CIF_ISP_LSC_CTRL_ENA);
> +	isp_param_clear_bits(params_vdev, CIF_ISP_BLS_CTRL, CIF_ISP_BLS_ENA);
> +	isp_param_clear_bits(params_vdev, CIF_ISP_CTRL,
> +			     CIF_ISP_CTRL_ISP_GAMMA_IN_ENA);
> +	isp_param_clear_bits(params_vdev, CIF_ISP_CTRL,
> +			     CIF_ISP_CTRL_ISP_GAMMA_OUT_ENA);
> +	isp_param_clear_bits(params_vdev, CIF_ISP_DEMOSAIC,
> +			     CIF_ISP_DEMOSAIC_BYPASS);
> +	isp_param_clear_bits(params_vdev, CIF_ISP_FILT_MODE, CIF_ISP_FLT_ENA);
> +	awb_meas_enable(params_vdev, NULL, false);
> +	isp_param_clear_bits(params_vdev, CIF_ISP_CTRL,
> +			     CIF_ISP_CTRL_ISP_AWB_ENA);
> +	isp_param_clear_bits(params_vdev, CIF_ISP_EXP_CTRL, CIF_ISP_EXP_ENA);
> +	ctk_enable(params_vdev, false);
> +	isp_param_clear_bits(params_vdev, CIF_C_PROC_CTRL,
> +			     CIF_C_PROC_CTR_ENABLE);
> +	hst_enable(params_vdev, NULL, false);
> +	isp_param_clear_bits(params_vdev, CIF_ISP_AFM_CTRL, CIF_ISP_AFM_ENA);
> +	ie_enable(params_vdev, false);
> +	isp_param_clear_bits(params_vdev, CIF_ISP_DPF_MODE,
> +			     CIF_ISP_DPF_MODE_EN);
> +}
> +
> +/* TODO: should add RKISP1_PARAMS_FMT pixel format  to V4L2 framework ? */
> +static int rkisp1_params_enum_fmt_meta_out(struct file *file, void *priv,
> +					   struct v4l2_fmtdesc *f)
> +{
> +	struct video_device *video = video_devdata(file);
> +	struct rkisp1_isp_params_vdev *params_vdev = video_get_drvdata(video);
> +
> +	if (f->index > 0 || f->type != video->queue->type)
> +		return -EINVAL;
> +
> +	f->pixelformat = params_vdev->vdev_fmt.fmt.meta.dataformat;
> +
> +	return 0;
> +}
> +
> +static int rkisp1_params_g_fmt_meta_out(struct file *file, void *fh,
> +					struct v4l2_format *f)
> +{
> +	struct video_device *video = video_devdata(file);
> +	struct rkisp1_isp_params_vdev *params_vdev = video_get_drvdata(video);
> +	struct v4l2_meta_format *meta = &f->fmt.meta;
> +
> +	if (f->type != video->queue->type)
> +		return -EINVAL;
> +
> +	memset(meta, 0, sizeof(*meta));
> +	meta->dataformat = params_vdev->vdev_fmt.fmt.meta.dataformat;
> +	meta->buffersize = params_vdev->vdev_fmt.fmt.meta.buffersize;
> +
> +	return 0;
> +}
> +
> +static int rkisp1_params_querycap(struct file *file,
> +				  void *priv, struct v4l2_capability *cap)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +
> +	strcpy(cap->driver, DRIVER_NAME);
> +	strlcpy(cap->card, vdev->name, sizeof(cap->card));
> +	strlcpy(cap->bus_info, "platform: " DRIVER_NAME, sizeof(cap->bus_info));
> +
> +	return 0;
> +}
> +
> +/* ISP params video device IOCTLs */
> +static const struct v4l2_ioctl_ops rkisp1_params_ioctl = {
> +	.vidioc_reqbufs = vb2_ioctl_reqbufs,
> +	.vidioc_querybuf = vb2_ioctl_querybuf,
> +	.vidioc_create_bufs = vb2_ioctl_create_bufs,
> +	.vidioc_qbuf = vb2_ioctl_qbuf,
> +	.vidioc_dqbuf = vb2_ioctl_dqbuf,
> +	.vidioc_prepare_buf = vb2_ioctl_prepare_buf,
> +	.vidioc_expbuf = vb2_ioctl_expbuf,
> +	.vidioc_streamon = vb2_ioctl_streamon,
> +	.vidioc_streamoff = vb2_ioctl_streamoff,
> +	.vidioc_enum_fmt_meta_out = rkisp1_params_enum_fmt_meta_out,
> +	.vidioc_g_fmt_meta_out = rkisp1_params_g_fmt_meta_out,
> +	.vidioc_s_fmt_meta_out = rkisp1_params_g_fmt_meta_out,
> +	.vidioc_try_fmt_meta_out = rkisp1_params_g_fmt_meta_out,
> +	.vidioc_querycap = rkisp1_params_querycap
> +};
> +
> +static int rkisp1_params_vb2_queue_setup(struct vb2_queue *vq,
> +					 unsigned int *num_buffers,
> +					 unsigned int *num_planes,
> +					 unsigned int sizes[],
> +					 struct device *alloc_devs[])
> +{
> +	struct rkisp1_isp_params_vdev *params_vdev = vq->drv_priv;
> +
> +	*num_buffers = clamp_t(u32, *num_buffers,
> +			       RKISP1_ISP_PARAMS_REQ_BUFS_MIN,
> +			       RKISP1_ISP_PARAMS_REQ_BUFS_MAX);
> +
> +	*num_planes = 1;
> +
> +	sizes[0] = sizeof(struct rkisp1_isp_params_cfg);
> +
> +	INIT_LIST_HEAD(&params_vdev->params);
> +	params_vdev->first_params = true;
> +
> +	return 0;
> +}
> +
> +static void rkisp1_params_vb2_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct rkisp1_buffer *params_buf = to_rkisp1_buffer(vbuf);
> +	struct vb2_queue *vq = vb->vb2_queue;
> +	struct rkisp1_isp_params_vdev *params_vdev = vq->drv_priv;
> +	struct rkisp1_isp_params_cfg *new_params;
> +	unsigned long flags;
> +
> +	if (params_vdev->first_params) {
> +		new_params = (struct rkisp1_isp_params_cfg *)
> +			(vb2_plane_vaddr(vb, 0));
> +		spin_lock_irqsave(&params_vdev->config_lock, flags);
> +		/* __isp_isr_other_config(params_vdev, new_params); */
> +		/* __isp_isr_meas_config(params_vdev, new_params); */
> +		spin_unlock_irqrestore(&params_vdev->config_lock, flags);
> +		vb2_buffer_done(&params_buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
> +		params_vdev->first_params = false;
> +		params_vdev->cur_params = *new_params;
> +		return;
> +	}
> +
> +	params_buf->vaddr[0] = vb2_plane_vaddr(vb, 0);
> +	spin_lock_irqsave(&params_vdev->config_lock, flags);
> +	list_add_tail(&params_buf->queue, &params_vdev->params);
> +	spin_unlock_irqrestore(&params_vdev->config_lock, flags);
> +}
> +
> +static void rkisp1_params_vb2_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct rkisp1_isp_params_vdev *params_vdev = vq->drv_priv;
> +	struct rkisp1_buffer *buf;
> +	unsigned long flags;
> +	int i;
> +
> +	/* stop params input firstly */
> +	spin_lock_irqsave(&params_vdev->config_lock, flags);
> +	params_vdev->streamon = false;
> +	spin_unlock_irqrestore(&params_vdev->config_lock, flags);
> +
> +	for (i = 0; i < RKISP1_ISP_PARAMS_REQ_BUFS_MAX; i++) {
> +		spin_lock_irqsave(&params_vdev->config_lock, flags);
> +		if (!list_empty(&params_vdev->params)) {
> +			buf = list_first_entry(&params_vdev->params,
> +					       struct rkisp1_buffer, queue);
> +			list_del(&buf->queue);
> +			spin_unlock_irqrestore(&params_vdev->config_lock,
> +					       flags);
> +		} else {
> +			spin_unlock_irqrestore(&params_vdev->config_lock,
> +					       flags);
> +			break;
> +		}
> +
> +		if (buf)
> +			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> +		buf = NULL;
> +	}
> +}
> +
> +static int
> +rkisp1_params_vb2_start_streaming(struct vb2_queue *queue, unsigned int count)
> +{
> +	struct rkisp1_isp_params_vdev *params_vdev = queue->drv_priv;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&params_vdev->config_lock, flags);
> +	params_vdev->streamon = true;
> +	spin_unlock_irqrestore(&params_vdev->config_lock, flags);
> +
> +	return 0;
> +}
> +
> +static struct vb2_ops rkisp1_params_vb2_ops = {
> +	.queue_setup = rkisp1_params_vb2_queue_setup,
> +	.wait_prepare = vb2_ops_wait_prepare,
> +	.wait_finish = vb2_ops_wait_finish,
> +	.buf_queue = rkisp1_params_vb2_buf_queue,
> +	.start_streaming = rkisp1_params_vb2_start_streaming,
> +	.stop_streaming = rkisp1_params_vb2_stop_streaming,
> +
> +};
> +
> +struct v4l2_file_operations rkisp1_params_fops = {
> +	.mmap = vb2_fop_mmap,
> +	.unlocked_ioctl = video_ioctl2,
> +	.poll = vb2_fop_poll,
> +	.open = v4l2_fh_open,
> +	.release = vb2_fop_release
> +};
> +
> +static int
> +rkisp1_params_init_vb2_queue(struct vb2_queue *q,
> +			     struct rkisp1_isp_params_vdev *params_vdev)
> +{
> +	struct rkisp1_vdev_node *node;
> +
> +	node = queue_to_node(q);
> +
> +	q->type = V4L2_BUF_TYPE_META_OUTPUT;
> +	q->io_modes = VB2_MMAP | VB2_USERPTR;

Either add VB2_DMABUF or remove expbuf from the ioctl ops. I would just add VB2_DMABUF.
It doesn't cost anything.

> +	q->drv_priv = params_vdev;
> +	q->ops = &rkisp1_params_vb2_ops;
> +	q->mem_ops = &vb2_vmalloc_memops;
> +	q->buf_struct_size = sizeof(struct rkisp1_buffer);
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->lock = &node->vlock;
> +
> +	return vb2_queue_init(q);
> +}
> +
> +static void rkisp1_init_params_vdev(struct rkisp1_isp_params_vdev *params_vdev)
> +{
> +	params_vdev->vdev_fmt.fmt.meta.dataformat =
> +		V4L2_META_FMT_RK_ISP1_PARAMS;
> +	params_vdev->vdev_fmt.fmt.meta.buffersize =
> +		sizeof(struct rkisp1_isp_params_cfg);
> +}
> +
> +int rkisp1_register_params_vdev(struct rkisp1_isp_params_vdev *params_vdev,
> +				struct v4l2_device *v4l2_dev,
> +				struct rkisp1_device *dev)
> +{
> +	int ret;
> +	struct rkisp1_vdev_node *node = &params_vdev->vnode;
> +	struct video_device *vdev = &node->vdev;
> +
> +	params_vdev->dev = dev;
> +	mutex_init(&node->vlock);
> +	spin_lock_init(&params_vdev->config_lock);
> +
> +	strlcpy(vdev->name, "rkisp1-input-params", sizeof(vdev->name));
> +
> +	video_set_drvdata(vdev, params_vdev);
> +	vdev->ioctl_ops = &rkisp1_params_ioctl;
> +	vdev->fops = &rkisp1_params_fops;
> +	vdev->release = video_device_release_empty;
> +	/*
> +	 * Provide a mutex to v4l2 core. It will be used
> +	 * to protect all fops and v4l2 ioctls.
> +	 */
> +	vdev->lock = &node->vlock;
> +	vdev->v4l2_dev = v4l2_dev;
> +	vdev->queue = &node->buf_queue;
> +	vdev->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_META_OUTPUT;
> +	vdev->vfl_dir = VFL_DIR_TX;
> +	rkisp1_params_init_vb2_queue(vdev->queue, params_vdev);
> +	rkisp1_init_params_vdev(params_vdev);
> +	video_set_drvdata(vdev, params_vdev);
> +
> +	node->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	vdev->entity.function = MEDIA_ENT_F_IO_V4L;
> +	ret = media_entity_pads_init(&vdev->entity, 1, &node->pad);
> +	if (ret < 0)
> +		goto err_release_queue;
> +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret < 0) {
> +		dev_err(&vdev->dev,
> +			"could not register Video for Linux device\n");
> +		goto err_cleanup_media_entity;
> +	}
> +	return 0;
> +err_cleanup_media_entity:
> +	media_entity_cleanup(&vdev->entity);
> +err_release_queue:
> +	vb2_queue_release(vdev->queue);
> +	return ret;
> +}
> +
> +void rkisp1_unregister_params_vdev(struct rkisp1_isp_params_vdev *params_vdev)
> +{
> +	struct rkisp1_vdev_node *node = &params_vdev->vnode;
> +	struct video_device *vdev = &node->vdev;
> +
> +	video_unregister_device(vdev);
> +	media_entity_cleanup(&vdev->entity);
> +	vb2_queue_release(vdev->queue);
> +}
> diff --git a/drivers/media/platform/rockchip/isp1/isp_params.h b/drivers/media/platform/rockchip/isp1/isp_params.h
> new file mode 100644
> index 000000000000..87604dc370bd
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/isp1/isp_params.h
> @@ -0,0 +1,81 @@
> +/*
> + * Rockchip isp1 driver
> + *
> + * Copyright (C) 2017 Rockchip Electronics Co., Ltd.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#ifndef _RKISP1_ISP_H
> +#define _RKISP1_ISP_H
> +
> +#include <linux/rkisp1-config.h>
> +#include "common.h"
> +
> +struct rkisp1_device;
> +
> +struct rkisp1_isp_params_vdev {
> +	struct rkisp1_vdev_node vnode;
> +	struct rkisp1_device *dev;
> +
> +	/* Current ISP parameters */
> +	spinlock_t config_lock;
> +	struct list_head params;
> +	struct rkisp1_isp_params_cfg cur_params;
> +	struct v4l2_format vdev_fmt;
> +	bool streamon;
> +	bool first_params;
> +
> +	bool rkisp1_ism_cropping;
> +	enum v4l2_quantization quantization;
> +	enum rkisp1_fmt_raw_pat_type raw_type;
> +
> +	/* input resolution needed for LSC param check */
> +	unsigned int isp_acq_width;
> +	unsigned int isp_acq_height;
> +	unsigned int active_lsc_width;
> +	unsigned int active_lsc_height;
> +
> +};
> +
> +/* config params before ISP streaming */
> +void rkisp1_configure_isp(struct rkisp1_isp_params_vdev *params_vdev,
> +			  struct ispsd_in_fmt *in_fmt,
> +			  enum v4l2_quantization quantization);
> +void rkisp1_disable_isp(struct rkisp1_isp_params_vdev *params_vdev);
> +
> +int rkisp1_register_params_vdev(struct rkisp1_isp_params_vdev *params_vdev,
> +				struct v4l2_device *v4l2_dev,
> +				struct rkisp1_device *dev);
> +
> +void rkisp1_unregister_params_vdev(struct rkisp1_isp_params_vdev *params_vdev);
> +
> +void rkisp1_params_isr(struct rkisp1_isp_params_vdev *params_vdev, u32 isp_mis);
> +
> +#endif /* _RKISP1_ISP_H */
> diff --git a/drivers/media/platform/rockchip/isp1/isp_stats.c b/drivers/media/platform/rockchip/isp1/isp_stats.c
> new file mode 100644
> index 000000000000..afa2579a1241
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/isp1/isp_stats.c
> @@ -0,0 +1,537 @@
> +/*
> + * Rockchip isp1 driver
> + *
> + * Copyright (C) 2017 Rockchip Electronics Co., Ltd.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-vmalloc.h>	/* for ISP statistics */
> +#include "regs.h"
> +#include "isp_stats.h"
> +#include "isp_params.h"
> +#include "rkisp1.h"
> +
> +#define RKISP1_ISP_STATS_REQ_BUFS_MIN 2
> +#define RKISP1_ISP_STATS_REQ_BUFS_MAX 8
> +
> +static int rkisp1_stats_enum_fmt_meta_cap(struct file *file, void *priv,
> +					  struct v4l2_fmtdesc *f)
> +{
> +	struct video_device *video = video_devdata(file);
> +	struct rkisp1_isp_stats_vdev *stats_vdev = video_get_drvdata(video);
> +
> +	if (f->index > 0 || f->type != video->queue->type)
> +		return -EINVAL;
> +
> +	f->pixelformat = stats_vdev->vdev_fmt.fmt.meta.dataformat;
> +	return 0;
> +}
> +
> +static int rkisp1_stats_g_fmt_meta_cap(struct file *file, void *priv,
> +				       struct v4l2_format *f)
> +{
> +	struct video_device *video = video_devdata(file);
> +	struct rkisp1_isp_stats_vdev *stats_vdev = video_get_drvdata(video);
> +	struct v4l2_meta_format *meta = &f->fmt.meta;
> +
> +	if (f->type != video->queue->type)
> +		return -EINVAL;
> +
> +	memset(meta, 0, sizeof(*meta));
> +	meta->dataformat = stats_vdev->vdev_fmt.fmt.meta.dataformat;
> +	meta->buffersize = stats_vdev->vdev_fmt.fmt.meta.buffersize;
> +
> +	return 0;
> +}
> +
> +static int rkisp1_stats_querycap(struct file *file,
> +				 void *priv, struct v4l2_capability *cap)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +
> +	strcpy(cap->driver, DRIVER_NAME);
> +	strlcpy(cap->card, vdev->name, sizeof(cap->card));
> +	strlcpy(cap->bus_info, "platform: " DRIVER_NAME, sizeof(cap->bus_info));
> +
> +	return 0;
> +}
> +
> +/* ISP video device IOCTLs */
> +static const struct v4l2_ioctl_ops rkisp1_stats_ioctl = {
> +	.vidioc_reqbufs = vb2_ioctl_reqbufs,
> +	.vidioc_querybuf = vb2_ioctl_querybuf,
> +	.vidioc_create_bufs = vb2_ioctl_create_bufs,
> +	.vidioc_qbuf = vb2_ioctl_qbuf,
> +	.vidioc_dqbuf = vb2_ioctl_dqbuf,
> +	.vidioc_prepare_buf = vb2_ioctl_prepare_buf,
> +	.vidioc_expbuf = vb2_ioctl_expbuf,
> +	.vidioc_streamon = vb2_ioctl_streamon,
> +	.vidioc_streamoff = vb2_ioctl_streamoff,
> +	.vidioc_enum_fmt_meta_cap = rkisp1_stats_enum_fmt_meta_cap,
> +	.vidioc_g_fmt_meta_cap = rkisp1_stats_g_fmt_meta_cap,
> +	.vidioc_s_fmt_meta_cap = rkisp1_stats_g_fmt_meta_cap,
> +	.vidioc_try_fmt_meta_cap = rkisp1_stats_g_fmt_meta_cap,
> +	.vidioc_querycap = rkisp1_stats_querycap
> +};
> +
> +struct v4l2_file_operations rkisp1_stats_fops = {
> +	.mmap = vb2_fop_mmap,
> +	.unlocked_ioctl = video_ioctl2,
> +	.poll = vb2_fop_poll,
> +	.open = v4l2_fh_open,
> +	.release = vb2_fop_release
> +};
> +
> +static int rkisp1_stats_vb2_queue_setup(struct vb2_queue *vq,
> +					unsigned int *num_buffers,
> +					unsigned int *num_planes,
> +					unsigned int sizes[],
> +					struct device *alloc_devs[])
> +{
> +	struct rkisp1_isp_stats_vdev *stats_vdev = vq->drv_priv;
> +
> +	*num_planes = 1;
> +
> +	*num_buffers = clamp_t(u32, *num_buffers, RKISP1_ISP_STATS_REQ_BUFS_MIN,
> +			       RKISP1_ISP_STATS_REQ_BUFS_MAX);
> +
> +	sizes[0] = sizeof(struct rkisp1_stat_buffer);
> +
> +	INIT_LIST_HEAD(&stats_vdev->stat);
> +
> +	return 0;
> +}
> +
> +static void rkisp1_stats_vb2_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct rkisp1_buffer *stats_buf = to_rkisp1_buffer(vbuf);
> +	struct vb2_queue *vq = vb->vb2_queue;
> +	struct rkisp1_isp_stats_vdev *stats_dev = vq->drv_priv;
> +	unsigned long flags;
> +
> +	stats_buf->vaddr[0] = vb2_plane_vaddr(vb, 0);
> +	spin_lock_irqsave(&stats_dev->irq_lock, flags);
> +	list_add_tail(&stats_buf->queue, &stats_dev->stat);
> +	spin_unlock_irqrestore(&stats_dev->irq_lock, flags);
> +}
> +
> +static void rkisp1_stats_vb2_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct rkisp1_isp_stats_vdev *stats_vdev = vq->drv_priv;
> +	struct rkisp1_buffer *buf;
> +	unsigned long flags;
> +	int i;
> +
> +	/* stop stats received firstly */
> +	spin_lock_irqsave(&stats_vdev->irq_lock, flags);
> +	stats_vdev->streamon = false;
> +	spin_unlock_irqrestore(&stats_vdev->irq_lock, flags);
> +
> +	drain_workqueue(stats_vdev->readout_wq);
> +
> +	for (i = 0; i < RKISP1_ISP_STATS_REQ_BUFS_MAX; i++) {
> +		spin_lock_irqsave(&stats_vdev->irq_lock, flags);
> +		if (!list_empty(&stats_vdev->stat)) {
> +			buf = list_first_entry(&stats_vdev->stat,
> +					       struct rkisp1_buffer, queue);
> +			list_del(&buf->queue);
> +			spin_unlock_irqrestore(&stats_vdev->irq_lock, flags);
> +		} else {
> +			spin_unlock_irqrestore(&stats_vdev->irq_lock, flags);
> +			break;
> +		}
> +
> +		if (buf)
> +			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> +		buf = NULL;
> +	}
> +}
> +
> +static int
> +rkisp1_stats_vb2_start_streaming(struct vb2_queue *queue,
> +				 unsigned int count)
> +{
> +	struct rkisp1_isp_stats_vdev *stats_vdev = queue->drv_priv;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&stats_vdev->irq_lock, flags);
> +	stats_vdev->streamon = true;
> +	spin_unlock_irqrestore(&stats_vdev->irq_lock, flags);
> +
> +	return 0;
> +}
> +
> +static struct vb2_ops rkisp1_stats_vb2_ops = {
> +	.queue_setup = rkisp1_stats_vb2_queue_setup,
> +	.buf_queue = rkisp1_stats_vb2_buf_queue,
> +	.wait_prepare = vb2_ops_wait_prepare,
> +	.wait_finish = vb2_ops_wait_finish,
> +	.stop_streaming = rkisp1_stats_vb2_stop_streaming,
> +	.start_streaming = rkisp1_stats_vb2_start_streaming,
> +};
> +
> +static int rkisp1_stats_init_vb2_queue(struct vb2_queue *q,
> +				       struct rkisp1_isp_stats_vdev *stats_vdev)
> +{
> +	struct rkisp1_vdev_node *node;
> +
> +	node = queue_to_node(q);
> +
> +	q->type = V4L2_BUF_TYPE_META_CAPTURE;
> +	q->io_modes = VB2_MMAP | VB2_USERPTR;

Either add VB2_DMABUF or remove vidioc_expbuf from the ioctl ops.

> +	q->drv_priv = stats_vdev;
> +	q->ops = &rkisp1_stats_vb2_ops;
> +	q->mem_ops = &vb2_vmalloc_memops;
> +	q->buf_struct_size = sizeof(struct rkisp1_buffer);
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->lock = &node->vlock;
> +
> +	return vb2_queue_init(q);
> +}
> +
> +static void rkisp1_stats_get_awb_meas(struct rkisp1_isp_stats_vdev *stats_vdev,
> +				      struct rkisp1_stat_buffer *pbuf)
> +{
> +	/* Protect against concurrent access from ISR? */
> +	u32 reg_val;
> +
> +	pbuf->meas_type |= CIFISP_STAT_AWB;
> +	reg_val = readl(stats_vdev->dev->base_addr + CIF_ISP_AWB_WHITE_CNT);
> +	pbuf->params.awb.awb_mean[0].cnt = CIF_ISP_AWB_GET_PIXEL_CNT(reg_val);
> +	reg_val = readl(stats_vdev->dev->base_addr + CIF_ISP_AWB_MEAN);
> +
> +	pbuf->params.awb.awb_mean[0].mean_cr_or_r =
> +		CIF_ISP_AWB_GET_MEAN_CR_R(reg_val);
> +	pbuf->params.awb.awb_mean[0].mean_cb_or_b =
> +		CIF_ISP_AWB_GET_MEAN_CB_B(reg_val);
> +	pbuf->params.awb.awb_mean[0].mean_y_or_g =
> +		CIF_ISP_AWB_GET_MEAN_Y_G(reg_val);
> +}
> +
> +static void rkisp1_stats_get_aec_meas(struct rkisp1_isp_stats_vdev *stats_vdev,
> +				      struct rkisp1_stat_buffer *pbuf)
> +{
> +	unsigned int i;
> +	void __iomem *addr = stats_vdev->dev->base_addr + CIF_ISP_EXP_MEAN_00;
> +
> +	pbuf->meas_type |= CIFISP_STAT_AUTOEXP;
> +	for (i = 0; i < CIFISP_AE_MEAN_MAX; i++)
> +		pbuf->params.ae.exp_mean[i] = (u8)readl(addr + i * 4);
> +}
> +
> +static void rkisp1_stats_get_afc_meas(struct rkisp1_isp_stats_vdev *stats_vdev,
> +				      struct rkisp1_stat_buffer *pbuf)
> +{
> +	pbuf->meas_type = CIFISP_STAT_AFM_FIN;
> +
> +	pbuf->params.af.window[0].sum =
> +		readl(stats_vdev->dev->base_addr + CIF_ISP_AFM_SUM_A);
> +	pbuf->params.af.window[0].lum =
> +		readl(stats_vdev->dev->base_addr + CIF_ISP_AFM_LUM_A);
> +	pbuf->params.af.window[1].sum =
> +		readl(stats_vdev->dev->base_addr + CIF_ISP_AFM_SUM_B);
> +	pbuf->params.af.window[1].lum =
> +		readl(stats_vdev->dev->base_addr + CIF_ISP_AFM_LUM_B);
> +	pbuf->params.af.window[2].sum =
> +		readl(stats_vdev->dev->base_addr + CIF_ISP_AFM_SUM_C);
> +	pbuf->params.af.window[2].lum =
> +		readl(stats_vdev->dev->base_addr + CIF_ISP_AFM_LUM_C);
> +}
> +
> +static void rkisp1_stats_get_hst_meas(struct rkisp1_isp_stats_vdev *stats_vdev,
> +				      struct rkisp1_stat_buffer *pbuf)
> +{
> +	int i;
> +	void __iomem *addr = stats_vdev->dev->base_addr + CIF_ISP_HIST_BIN_0;
> +
> +	pbuf->meas_type |= CIFISP_STAT_HIST;
> +	for (i = 0; i < CIFISP_HIST_BIN_N_MAX; i++)
> +		pbuf->params.hist.hist_bins[i] = readl(addr + (i * 4));
> +}
> +
> +static void rkisp1_stats_get_bls_meas(struct rkisp1_isp_stats_vdev *stats_vdev,
> +				      struct rkisp1_stat_buffer *pbuf)
> +{
> +	struct rkisp1_device *dev = stats_vdev->dev;
> +	struct rkisp1_isp_subdev *sd = &dev->isp_sdev;
> +	const struct ispsd_in_fmt *in_fmt = &sd->in_fmt;
> +	void __iomem *base = stats_vdev->dev->base_addr;
> +
> +	/* TODO: get in_fmt */
> +	if (in_fmt->bayer_pat == RAW_BGGR) {
> +		pbuf->params.ae.bls_val.meas_b =
> +			readl(base + CIF_ISP_BLS_A_MEASURED);
> +		pbuf->params.ae.bls_val.meas_gb =
> +			readl(base + CIF_ISP_BLS_B_MEASURED);
> +		pbuf->params.ae.bls_val.meas_gr =
> +			readl(base + CIF_ISP_BLS_C_MEASURED);
> +		pbuf->params.ae.bls_val.meas_r =
> +			readl(base + CIF_ISP_BLS_D_MEASURED);
> +	} else if (in_fmt->bayer_pat == RAW_GBRG) {
> +		pbuf->params.ae.bls_val.meas_gb =
> +			readl(base + CIF_ISP_BLS_A_MEASURED);
> +		pbuf->params.ae.bls_val.meas_b =
> +			readl(base + CIF_ISP_BLS_B_MEASURED);
> +		pbuf->params.ae.bls_val.meas_r =
> +			readl(base + CIF_ISP_BLS_C_MEASURED);
> +		pbuf->params.ae.bls_val.meas_gr =
> +			readl(base + CIF_ISP_BLS_D_MEASURED);
> +	} else if (in_fmt->bayer_pat == RAW_GRBG) {
> +		pbuf->params.ae.bls_val.meas_gr =
> +			readl(base + CIF_ISP_BLS_A_MEASURED);
> +		pbuf->params.ae.bls_val.meas_r =
> +			readl(base + CIF_ISP_BLS_B_MEASURED);
> +		pbuf->params.ae.bls_val.meas_b =
> +			readl(base + CIF_ISP_BLS_C_MEASURED);
> +		pbuf->params.ae.bls_val.meas_gb =
> +			readl(base + CIF_ISP_BLS_D_MEASURED);
> +	} else if (in_fmt->bayer_pat == RAW_RGGB) {
> +		pbuf->params.ae.bls_val.meas_r =
> +			readl(base + CIF_ISP_BLS_A_MEASURED);
> +		pbuf->params.ae.bls_val.meas_gr =
> +			readl(base + CIF_ISP_BLS_B_MEASURED);
> +		pbuf->params.ae.bls_val.meas_gb =
> +			readl(base + CIF_ISP_BLS_C_MEASURED);
> +		pbuf->params.ae.bls_val.meas_b =
> +			readl(base + CIF_ISP_BLS_D_MEASURED);
> +	}
> +}
> +
> +static void
> +rkisp1_stats_send_measurement(struct rkisp1_isp_stats_vdev *stats_vdev,
> +			      struct rkisp1_isp_readout_work *meas_work)
> +{
> +	unsigned long lock_flags = 0;
> +	unsigned int cur_frame_id = -1;
> +	struct rkisp1_stat_buffer *cur_stat_buf;
> +	struct rkisp1_buffer *cur_buf = NULL;
> +
> +	spin_lock_irqsave(&stats_vdev->irq_lock, lock_flags);
> +	cur_frame_id = atomic_read(&stats_vdev->dev->isp_sdev.frm_sync_seq) - 1;
> +	if (cur_frame_id != meas_work->frame_id) {
> +		v4l2_warn(stats_vdev->vnode.vdev.v4l2_dev,
> +			  "Measurement late(%d, %d)\n",
> +			  cur_frame_id, meas_work->frame_id);
> +	}
> +	/* get one empty buffer */
> +	if (!list_empty(&stats_vdev->stat)) {
> +		cur_buf = list_first_entry(&stats_vdev->stat,
> +					   struct rkisp1_buffer, queue);
> +		list_del(&cur_buf->queue);
> +	}
> +	spin_unlock_irqrestore(&stats_vdev->irq_lock, lock_flags);
> +
> +	if (!cur_buf)
> +		return;
> +
> +	cur_stat_buf =
> +		(struct rkisp1_stat_buffer *)(cur_buf->vaddr[0]);
> +
> +	if (meas_work->isp_ris & CIF_ISP_AWB_DONE) {
> +		rkisp1_stats_get_awb_meas(stats_vdev, cur_stat_buf);
> +		cur_stat_buf->meas_type |= CIFISP_STAT_AWB;
> +	}
> +
> +	if (meas_work->isp_ris & CIF_ISP_AFM_FIN) {
> +		rkisp1_stats_get_afc_meas(stats_vdev, cur_stat_buf);
> +		cur_stat_buf->meas_type |= CIFISP_STAT_AFM_FIN;
> +	}
> +
> +	if (meas_work->isp_ris & CIF_ISP_EXP_END) {
> +		rkisp1_stats_get_aec_meas(stats_vdev, cur_stat_buf);
> +		rkisp1_stats_get_bls_meas(stats_vdev, cur_stat_buf);
> +		cur_stat_buf->meas_type |= CIFISP_STAT_AUTOEXP;
> +	}
> +
> +	if (meas_work->isp_ris & CIF_ISP_HIST_MEASURE_RDY) {
> +		rkisp1_stats_get_hst_meas(stats_vdev, cur_stat_buf);
> +		cur_stat_buf->meas_type |= CIFISP_STAT_HIST;
> +	}
> +
> +	vb2_set_plane_payload(&cur_buf->vb.vb2_buf, 0,
> +			      sizeof(struct rkisp1_stat_buffer));
> +	vb2_buffer_done(&cur_buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
> +}
> +
> +static void rkisp1_stats_readout_work(struct work_struct *work)
> +{
> +	struct rkisp1_isp_readout_work *readout_work = container_of(work,
> +						struct rkisp1_isp_readout_work,
> +						work);
> +	struct rkisp1_isp_stats_vdev *stats_vdev = readout_work->stats_vdev;
> +
> +	if (readout_work->readout == RKISP1_ISP_READOUT_MEAS)
> +		rkisp1_stats_send_measurement(stats_vdev, readout_work);
> +
> +	kfree(readout_work);
> +}
> +
> +int rkisp1_stats_isr(struct rkisp1_isp_stats_vdev *stats_vdev, u32 isp_ris)
> +{
> +	unsigned int isp_mis_tmp = 0;
> +	struct rkisp1_isp_readout_work *work;
> +	unsigned int cur_frame_id =
> +		atomic_read(&stats_vdev->dev->isp_sdev.frm_sync_seq) - 1;
> +#ifdef LOG_ISR_EXE_TIME
> +	ktime_t in_t = ktime_get();
> +#endif
> +
> +	writel((CIF_ISP_AWB_DONE | CIF_ISP_AFM_FIN | CIF_ISP_EXP_END |
> +		CIF_ISP_HIST_MEASURE_RDY),
> +		stats_vdev->dev->base_addr + CIF_ISP_ICR);
> +
> +	isp_mis_tmp = readl(stats_vdev->dev->base_addr + CIF_ISP_MIS);
> +	if (isp_mis_tmp &
> +		(CIF_ISP_AWB_DONE | CIF_ISP_AFM_FIN |
> +		 CIF_ISP_EXP_END | CIF_ISP_HIST_MEASURE_RDY))
> +		v4l2_err(stats_vdev->vnode.vdev.v4l2_dev,
> +			 "isp icr 3A info err: 0x%x\n",
> +			 isp_mis_tmp);
> +
> +	if (isp_ris & (CIF_ISP_AWB_DONE | CIF_ISP_AFM_FIN | CIF_ISP_EXP_END |
> +		CIF_ISP_HIST_MEASURE_RDY)) {
> +		work = (struct rkisp1_isp_readout_work *)
> +			kzalloc(sizeof(struct rkisp1_isp_readout_work),
> +				GFP_ATOMIC);
> +		if (work) {
> +			INIT_WORK(&work->work,
> +				  rkisp1_stats_readout_work);
> +			work->readout = RKISP1_ISP_READOUT_MEAS;
> +			work->stats_vdev = stats_vdev;
> +			work->frame_id = cur_frame_id;
> +			work->isp_ris = isp_ris;
> +			if (!queue_work(stats_vdev->readout_wq,
> +					&work->work))
> +				kfree(work);
> +		} else {
> +			v4l2_err(stats_vdev->vnode.vdev.v4l2_dev,
> +				 "Could not allocate work\n");
> +		}
> +	}
> +
> +#ifdef LOG_ISR_EXE_TIME
> +	if (isp_ris & (CIF_ISP_EXP_END | CIF_ISP_AWB_DONE |
> +		       CIF_ISP_FRAME | CIF_ISP_HIST_MEASURE_RDY)) {
> +		unsigned int diff_us =
> +		    ktime_to_us(ktime_sub(ktime_get(), in_t));
> +
> +		if (diff_us > g_longest_isr_time)
> +			g_longest_isr_time = diff_us;
> +
> +		v4l2_info(stats_vdev->vnode.vdev.v4l2_dev,
> +			  "isp_isr time %d %d\n", diff_us, g_longest_isr_time);
> +	}
> +#endif
> +
> +	return 0;
> +}
> +
> +static void rkisp1_init_stats_vdev(struct rkisp1_isp_stats_vdev *stats_vdev)
> +{
> +	stats_vdev->vdev_fmt.fmt.meta.dataformat =
> +		V4L2_META_FMT_RK_ISP1_STAT_3A;
> +	stats_vdev->vdev_fmt.fmt.meta.buffersize =
> +		sizeof(struct rkisp1_stat_buffer);
> +}
> +
> +int rkisp1_register_stats_vdev(struct rkisp1_isp_stats_vdev *stats_vdev,
> +			       struct v4l2_device *v4l2_dev,
> +			       struct rkisp1_device *dev)
> +{
> +	int ret;
> +	struct rkisp1_vdev_node *node = &stats_vdev->vnode;
> +	struct video_device *vdev = &node->vdev;
> +
> +	stats_vdev->dev = dev;
> +	mutex_init(&node->vlock);
> +	INIT_LIST_HEAD(&stats_vdev->stat);
> +	spin_lock_init(&stats_vdev->irq_lock);
> +
> +	strlcpy(vdev->name, "rkisp1-statistics", sizeof(vdev->name));
> +
> +	video_set_drvdata(vdev, stats_vdev);
> +	vdev->ioctl_ops = &rkisp1_stats_ioctl;
> +	vdev->fops = &rkisp1_stats_fops;
> +	vdev->release = video_device_release_empty;
> +	vdev->lock = &node->vlock;
> +	vdev->v4l2_dev = v4l2_dev;
> +	vdev->queue = &node->buf_queue;
> +	vdev->device_caps = V4L2_CAP_META_CAPTURE | V4L2_CAP_STREAMING;
> +	vdev->vfl_dir =  VFL_DIR_RX;
> +	rkisp1_stats_init_vb2_queue(vdev->queue, stats_vdev);
> +	rkisp1_init_stats_vdev(stats_vdev);
> +	video_set_drvdata(vdev, stats_vdev);
> +
> +	node->pad.flags = MEDIA_PAD_FL_SINK;
> +	vdev->entity.function = MEDIA_ENT_F_IO_V4L;
> +	ret = media_entity_pads_init(&vdev->entity, 1, &node->pad);
> +	if (ret < 0)
> +		goto err_release_queue;
> +
> +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret < 0) {
> +		dev_err(&vdev->dev,
> +			"could not register Video for Linux device\n");
> +		goto err_cleanup_media_entity;
> +	}
> +
> +	stats_vdev->readout_wq =
> +	    alloc_workqueue("measurement_queue",
> +			    WQ_UNBOUND | WQ_MEM_RECLAIM, 1);
> +
> +	if (!stats_vdev->readout_wq) {
> +		ret = -ENOMEM;
> +			goto err_unreg_vdev;
> +	}
> +
> +	return 0;
> +err_unreg_vdev:
> +	video_unregister_device(vdev);
> +err_cleanup_media_entity:
> +	media_entity_cleanup(&vdev->entity);
> +err_release_queue:
> +	vb2_queue_release(vdev->queue);
> +	return ret;
> +}
> +
> +void rkisp1_unregister_stats_vdev(struct rkisp1_isp_stats_vdev *stats_vdev)
> +{
> +	struct rkisp1_vdev_node *node = &stats_vdev->vnode;
> +	struct video_device *vdev = &node->vdev;
> +
> +	destroy_workqueue(stats_vdev->readout_wq);
> +	video_unregister_device(vdev);
> +	media_entity_cleanup(&vdev->entity);
> +	vb2_queue_release(vdev->queue);
> +}
> diff --git a/drivers/media/platform/rockchip/isp1/isp_stats.h b/drivers/media/platform/rockchip/isp1/isp_stats.h
> new file mode 100644
> index 000000000000..d42cd9e75efd
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/isp1/isp_stats.h
> @@ -0,0 +1,81 @@
> +/*
> + * Rockchip isp1 driver
> + *
> + * Copyright (C) 2017 Rockchip Electronics Co., Ltd.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#ifndef _RKISP1_ISP_STATS_H
> +#define _RKISP1_ISP_STATS_H
> +
> +#include <linux/rkisp1-config.h>
> +#include "common.h"
> +
> +struct rkisp1_isp_stats_vdev;
> +struct rkisp1_device;
> +
> +enum rkisp1_isp_readout_cmd {
> +	RKISP1_ISP_READOUT_MEAS,
> +	/* TODO: metadata */
> +	RKISP1_ISP_READOUT_META,
> +};
> +
> +struct rkisp1_isp_readout_work {
> +	struct work_struct work;
> +	struct rkisp1_isp_stats_vdev *stats_vdev;
> +
> +	unsigned int frame_id;
> +	unsigned int isp_ris;
> +	enum rkisp1_isp_readout_cmd readout;
> +	struct vb2_buffer *vb;
> +};
> +
> +struct rkisp1_isp_stats_vdev {
> +	struct rkisp1_vdev_node vnode;
> +	struct rkisp1_device *dev;
> +
> +	/* ISP statistics related */
> +	spinlock_t irq_lock;
> +	struct list_head stat;		/* stats buffer list */
> +	struct v4l2_format vdev_fmt;
> +	bool streamon;
> +
> +	struct workqueue_struct *readout_wq;
> +};
> +
> +int rkisp1_stats_isr(struct rkisp1_isp_stats_vdev *stats_vdev, u32 isp_ris);
> +
> +int rkisp1_register_stats_vdev(struct rkisp1_isp_stats_vdev *stats_vdev,
> +			       struct v4l2_device *v4l2_dev,
> +			       struct rkisp1_device *dev);
> +
> +void rkisp1_unregister_stats_vdev(struct rkisp1_isp_stats_vdev *stats_vdev);
> +
> +#endif /* _RKISP1_ISP_STATS_H */
> diff --git a/drivers/media/platform/rockchip/isp1/regs.c b/drivers/media/platform/rockchip/isp1/regs.c
> new file mode 100644
> index 000000000000..496fdcef466f
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/isp1/regs.c
> @@ -0,0 +1,251 @@
> +/*
> + * Rockchip isp1 driver
> + *
> + * Copyright (C) 2017 Rockchip Electronics Co., Ltd.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#include <media/v4l2-common.h>
> +#include "regs.h"
> +
> +void disable_dcrop(struct rkisp1_stream *stream, bool async)
> +{
> +	void __iomem *base = stream->ispdev->base_addr;
> +	void __iomem *dc_ctrl_addr = base + stream->config->dual_crop.ctrl;
> +	u32 dc_ctrl = readl(dc_ctrl_addr);
> +	u32 mask = ~(stream->config->dual_crop.yuvmode_mask |
> +			stream->config->dual_crop.rawmode_mask);
> +	u32 val = dc_ctrl & mask;
> +
> +	if (async)
> +		val |= CIF_DUAL_CROP_GEN_CFG_UPD;
> +	else
> +		val |= CIF_DUAL_CROP_CFG_UPD;
> +	writel(val, dc_ctrl_addr);
> +}
> +
> +void config_dcrop(struct rkisp1_stream *stream, struct v4l2_rect *rect, bool async)
> +{
> +	void __iomem *base = stream->ispdev->base_addr;
> +	void __iomem *dc_ctrl_addr = base + stream->config->dual_crop.ctrl;
> +	u32 dc_ctrl = readl(dc_ctrl_addr);
> +
> +	writel(rect->left, base + stream->config->dual_crop.h_offset);
> +	writel(rect->top, base + stream->config->dual_crop.v_offset);
> +	writel(rect->width, base + stream->config->dual_crop.h_size);
> +	writel(rect->height, base + stream->config->dual_crop.v_size);
> +	dc_ctrl |= stream->config->dual_crop.yuvmode_mask;
> +	if (async)
> +		dc_ctrl |= CIF_DUAL_CROP_GEN_CFG_UPD;
> +	else
> +		dc_ctrl |= CIF_DUAL_CROP_CFG_UPD;
> +	writel(dc_ctrl, dc_ctrl_addr);
> +}
> +
> +void dump_rsz_regs(struct rkisp1_stream *stream)
> +{
> +	void __iomem *base = stream->ispdev->base_addr;
> +
> +	pr_info("RSZ_CTRL 0x%08x/0x%08x\n"
> +			"RSZ_SCALE_HY %d/%d\n"
> +			"RSZ_SCALE_HCB %d/%d\n"
> +			"RSZ_SCALE_HCR %d/%d\n"
> +			"RSZ_SCALE_VY %d/%d\n"
> +			"RSZ_SCALE_VC %d/%d\n"
> +			"RSZ_PHASE_HY %d/%d\n"
> +			"RSZ_PHASE_HC %d/%d\n"
> +			"RSZ_PHASE_VY %d/%d\n"
> +			"RSZ_PHASE_VC %d/%d\n",
> +			readl(base + stream->config->rsz.ctrl),
> +			readl(base + stream->config->rsz.ctrl_shd),
> +			readl(base + stream->config->rsz.scale_hy),
> +			readl(base + stream->config->rsz.scale_hy_shd),
> +			readl(base + stream->config->rsz.scale_hcb),
> +			readl(base + stream->config->rsz.scale_hcb_shd),
> +			readl(base + stream->config->rsz.scale_hcr),
> +			readl(base + stream->config->rsz.scale_hcr_shd),
> +			readl(base + stream->config->rsz.scale_vy),
> +			readl(base + stream->config->rsz.scale_vy_shd),
> +			readl(base + stream->config->rsz.scale_vc),
> +			readl(base + stream->config->rsz.scale_vc_shd),
> +			readl(base + stream->config->rsz.phase_hy),
> +			readl(base + stream->config->rsz.phase_hy_shd),
> +			readl(base + stream->config->rsz.phase_hc),
> +			readl(base + stream->config->rsz.phase_hc_shd),
> +			readl(base + stream->config->rsz.phase_vy),
> +			readl(base + stream->config->rsz.phase_vy_shd),
> +			readl(base + stream->config->rsz.phase_vc),
> +			readl(base + stream->config->rsz.phase_vc_shd));
> +}
> +
> +static void update_rsz_shadow(struct rkisp1_stream *stream)
> +{
> +	void *addr = stream->ispdev->base_addr + stream->config->rsz.ctrl;
> +	u32 ctrl_cfg = readl(addr);
> +
> +	writel(CIF_RSZ_CTRL_CFG_UPD | ctrl_cfg, addr);
> +}
> +
> +static void set_scale(struct rkisp1_stream *stream, struct v4l2_rect *in_y,
> +		struct v4l2_rect *in_c, struct v4l2_rect *out_y,
> +		struct v4l2_rect *out_c)
> +{
> +	void __iomem *base = stream->ispdev->base_addr;
> +	void __iomem *scale_hy_addr = base + stream->config->rsz.scale_hy;
> +	void __iomem *scale_hcr_addr = base + stream->config->rsz.scale_hcr;
> +	void __iomem *scale_hcb_addr = base + stream->config->rsz.scale_hcb;
> +	void __iomem *scale_vy_addr = base + stream->config->rsz.scale_vy;
> +	void __iomem *scale_vc_addr = base + stream->config->rsz.scale_vc;
> +	void __iomem *rsz_ctrl_addr = base + stream->config->rsz.ctrl;
> +	u32 scale_hy, scale_hc, scale_vy, scale_vc, rsz_ctrl = 0;
> +
> +	if (in_y->width < out_y->width) {
> +		rsz_ctrl |= CIF_RSZ_CTRL_SCALE_HY_ENABLE |
> +				CIF_RSZ_CTRL_SCALE_HY_UP;
> +		scale_hy = ((in_y->width - 1) * CIF_RSZ_SCALER_FACTOR) /
> +				(out_y->width - 1);
> +		writel(scale_hy, scale_hy_addr);
> +	} else if (in_y->width > out_y->width) {
> +		rsz_ctrl |= CIF_RSZ_CTRL_SCALE_HY_ENABLE;
> +		scale_hy = ((out_y->width - 1) * CIF_RSZ_SCALER_FACTOR) /
> +				(in_y->width - 1) + 1;
> +		writel(scale_hy, scale_hy_addr);
> +	}
> +	if (in_c->width < out_c->width) {
> +		rsz_ctrl |= CIF_RSZ_CTRL_SCALE_HC_ENABLE |
> +				CIF_RSZ_CTRL_SCALE_HC_UP;
> +		scale_hc = ((in_c->width - 1) * CIF_RSZ_SCALER_FACTOR) /
> +				(out_c->width - 1);
> +		writel(scale_hc, scale_hcb_addr);
> +		writel(scale_hc, scale_hcr_addr);
> +	} else if (in_c->width > out_c->width) {
> +		rsz_ctrl |= CIF_RSZ_CTRL_SCALE_HC_ENABLE;
> +		scale_hc = ((out_c->width - 1) * CIF_RSZ_SCALER_FACTOR) /
> +				(in_c->width - 1) + 1;
> +		writel(scale_hc, scale_hcb_addr);
> +		writel(scale_hc, scale_hcr_addr);
> +	}
> +
> +	if (in_y->height < out_y->height) {
> +		rsz_ctrl |= CIF_RSZ_CTRL_SCALE_VY_ENABLE |
> +				CIF_RSZ_CTRL_SCALE_VY_UP;
> +		scale_vy = ((in_y->height - 1) * CIF_RSZ_SCALER_FACTOR) /
> +				(out_y->height - 1);
> +		writel(scale_vy, scale_vy_addr);
> +	} else if (in_y->height > out_y->height) {
> +		rsz_ctrl |= CIF_RSZ_CTRL_SCALE_VY_ENABLE;
> +		scale_vy = ((out_y->height - 1) * CIF_RSZ_SCALER_FACTOR) /
> +				(in_y->height - 1) + 1;
> +		writel(scale_vy, scale_vy_addr);
> +	}
> +
> +	if (in_c->height < out_c->height) {
> +		rsz_ctrl |= CIF_RSZ_CTRL_SCALE_VC_ENABLE |
> +				CIF_RSZ_CTRL_SCALE_VC_UP;
> +		scale_vc = ((in_c->height - 1) * CIF_RSZ_SCALER_FACTOR) /
> +				(out_c->height - 1);
> +		writel(scale_vc, scale_vc_addr);
> +	} else if (in_c->height > out_c->height) {
> +		rsz_ctrl |= CIF_RSZ_CTRL_SCALE_VC_ENABLE;
> +		scale_vc = ((out_c->height - 1) * CIF_RSZ_SCALER_FACTOR) /
> +				(in_c->height - 1) + 1;
> +		writel(scale_vc, scale_vc_addr);
> +	}
> +
> +	writel(rsz_ctrl, rsz_ctrl_addr);
> +}
> +
> +void config_rsz(struct rkisp1_stream *stream, struct v4l2_rect *in_y,
> +	struct v4l2_rect *in_c, struct v4l2_rect *out_y,
> +	struct v4l2_rect *out_c, bool async)
> +{
> +	int i = 0;
> +
> +	/* No phase offset */
> +	writel(0, stream->ispdev->base_addr + stream->config->rsz.phase_hy);
> +	writel(0, stream->ispdev->base_addr + stream->config->rsz.phase_hc);
> +	writel(0, stream->ispdev->base_addr + stream->config->rsz.phase_vy);
> +	writel(0, stream->ispdev->base_addr + stream->config->rsz.phase_vc);
> +
> +	/* Linear interpolation */
> +	for (i = 0; i < 64; i++) {
> +		writel(i, stream->ispdev->base_addr + stream->config->rsz.scale_lut_addr);
> +		writel(i, stream->ispdev->base_addr + stream->config->rsz.scale_lut);
> +	}
> +
> +	set_scale(stream, in_y, in_c, out_y, out_c);
> +
> +	if (!async)
> +		update_rsz_shadow(stream);
> +}
> +
> +void disable_rsz(struct rkisp1_stream *stream, bool async)
> +{
> +	writel(0, stream->ispdev->base_addr + stream->config->rsz.ctrl);
> +
> +	if (!async)
> +		update_rsz_shadow(stream);
> +}
> +
> +void config_mi_ctrl(struct rkisp1_stream *stream)
> +{
> +	void __iomem *base = stream->ispdev->base_addr;
> +	void __iomem *addr = base + CIF_MI_CTRL;
> +	u32 reg;
> +
> +	reg = readl(addr) & ~GENMASK(17, 16);
> +	writel(reg | CIF_MI_CTRL_BURST_LEN_LUM_64, addr);
> +	reg = readl(addr) & ~GENMASK(19, 18);
> +	writel(reg | CIF_MI_CTRL_BURST_LEN_CHROM_64, addr);
> +	reg = readl(addr);
> +	writel(reg | CIF_MI_CTRL_INIT_BASE_EN, addr);
> +	reg = readl(addr);
> +	writel(reg | CIF_MI_CTRL_INIT_OFFSET_EN, addr);
> +}
> +
> +void mp_clr_frame_end_int(void __iomem *base)
> +{
> +	writel(CIF_MI_MP_FRAME, base + CIF_MI_ICR);
> +}
> +
> +void sp_clr_frame_end_int(void __iomem *base)
> +{
> +	writel(CIF_MI_SP_FRAME, base + CIF_MI_ICR);
> +}
> +
> +u32 mp_is_frame_end_int_masked(void __iomem *base)
> +{
> +	return (mi_get_masked_int_status(base) & CIF_MI_MP_FRAME);
> +}
> +
> +u32 sp_is_frame_end_int_masked(void __iomem *base)
> +{
> +	return (mi_get_masked_int_status(base) & CIF_MI_SP_FRAME);
> +}
> diff --git a/drivers/media/platform/rockchip/isp1/regs.h b/drivers/media/platform/rockchip/isp1/regs.h
> new file mode 100644
> index 000000000000..70c554459b7d
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/isp1/regs.h
> @@ -0,0 +1,1578 @@
> +/*
> + * Rockchip isp1 driver
> + *
> + * Copyright (C) 2017 Rockchip Electronics Co., Ltd.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#ifndef _RKISP1_REGS_H
> +#define _RKISP1_REGS_H
> +#include "common.h"
> +#include "rkisp1.h"
> +
> +/* ISP_CTRL */
> +#define CIF_ISP_CTRL_ISP_ENABLE			BIT(0)
> +#define CIF_ISP_CTRL_ISP_MODE_RAW_PICT		(0 << 1)
> +#define CIF_ISP_CTRL_ISP_MODE_ITU656		(1 << 1)
> +#define CIF_ISP_CTRL_ISP_MODE_ITU601		(2 << 1)
> +#define CIF_ISP_CTRL_ISP_MODE_BAYER_ITU601	(3 << 1)
> +#define CIF_ISP_CTRL_ISP_MODE_DATA_MODE		(4 << 1)
> +#define CIF_ISP_CTRL_ISP_MODE_BAYER_ITU656	(5 << 1)
> +#define CIF_ISP_CTRL_ISP_MODE_RAW_PICT_ITU656	(6 << 1)
> +#define CIF_ISP_CTRL_ISP_INFORM_ENABLE		BIT(4)
> +#define CIF_ISP_CTRL_ISP_GAMMA_IN_ENA		BIT(6)
> +#define CIF_ISP_CTRL_ISP_AWB_ENA		BIT(7)
> +#define CIF_ISP_CTRL_ISP_CFG_UPD_PERMANENT	BIT(8)
> +#define CIF_ISP_CTRL_ISP_CFG_UPD		BIT(9)
> +#define CIF_ISP_CTRL_ISP_GEN_CFG_UPD		BIT(10)
> +#define CIF_ISP_CTRL_ISP_GAMMA_OUT_ENA		BIT(11)
> +#define CIF_ISP_CTRL_ISP_FLASH_MODE_ENA		BIT(12)
> +#define CIF_ISP_CTRL_ISP_CSM_Y_FULL_ENA		BIT(13)
> +#define CIF_ISP_CTRL_ISP_CSM_C_FULL_ENA		BIT(14)
> +
> +/* ISP_ACQ_PROP */
> +#define CIF_ISP_ACQ_PROP_POS_EDGE		BIT(0)
> +#define CIF_ISP_ACQ_PROP_HSYNC_LOW		BIT(1)
> +#define CIF_ISP_ACQ_PROP_VSYNC_LOW		BIT(2)
> +#define CIF_ISP_ACQ_PROP_BAYER_PAT_RGGB		(0 << 3)
> +#define CIF_ISP_ACQ_PROP_BAYER_PAT_GRBG		(1 << 3)
> +#define CIF_ISP_ACQ_PROP_BAYER_PAT_GBRG		(2 << 3)
> +#define CIF_ISP_ACQ_PROP_BAYER_PAT_BGGR		(3 << 3)
> +#define CIF_ISP_ACQ_PROP_BAYER_PAT(pat)		((pat) << 3)
> +#define CIF_ISP_ACQ_PROP_YCBYCR			(0 << 7)
> +#define CIF_ISP_ACQ_PROP_YCRYCB			(1 << 7)
> +#define CIF_ISP_ACQ_PROP_CBYCRY			(2 << 7)
> +#define CIF_ISP_ACQ_PROP_CRYCBY			(3 << 7)
> +#define CIF_ISP_ACQ_PROP_FIELD_SEL_ALL		(0 << 9)
> +#define CIF_ISP_ACQ_PROP_FIELD_SEL_EVEN		(1 << 9)
> +#define CIF_ISP_ACQ_PROP_FIELD_SEL_ODD		(2 << 9)
> +#define CIF_ISP_ACQ_PROP_IN_SEL_12B		(0 << 12)
> +#define CIF_ISP_ACQ_PROP_IN_SEL_10B_ZERO	(1 << 12)
> +#define CIF_ISP_ACQ_PROP_IN_SEL_10B_MSB		(2 << 12)
> +#define CIF_ISP_ACQ_PROP_IN_SEL_8B_ZERO		(3 << 12)
> +#define CIF_ISP_ACQ_PROP_IN_SEL_8B_MSB		(4 << 12)
> +
> +/* VI_DPCL */
> +#define CIF_VI_DPCL_DMA_JPEG			(0 << 0)
> +#define CIF_VI_DPCL_MP_MUX_MRSZ_MI		(1 << 0)
> +#define CIF_VI_DPCL_MP_MUX_MRSZ_JPEG		(2 << 0)
> +#define CIF_VI_DPCL_CHAN_MODE_MP		(1 << 2)
> +#define CIF_VI_DPCL_CHAN_MODE_SP		(2 << 2)
> +#define CIF_VI_DPCL_CHAN_MODE_MPSP		(3 << 2)
> +#define CIF_VI_DPCL_DMA_SW_SPMUX		(0 << 4)
> +#define CIF_VI_DPCL_DMA_SW_SI			(1 << 4)
> +#define CIF_VI_DPCL_DMA_SW_IE			(2 << 4)
> +#define CIF_VI_DPCL_DMA_SW_JPEG			(3 << 4)
> +#define CIF_VI_DPCL_DMA_SW_ISP			(4 << 4)
> +#define CIF_VI_DPCL_IF_SEL_PARALLEL		(0 << 8)
> +#define CIF_VI_DPCL_IF_SEL_SMIA			(1 << 8)
> +#define CIF_VI_DPCL_IF_SEL_MIPI			(2 << 8)
> +#define CIF_VI_DPCL_DMA_IE_MUX_DMA		BIT(10)
> +#define CIF_VI_DPCL_DMA_SP_MUX_DMA		BIT(11)
> +
> +/* ISP_IMSC - ISP_MIS - ISP_RIS - ISP_ICR - ISP_ISR */
> +#define CIF_ISP_OFF				BIT(0)
> +#define CIF_ISP_FRAME				BIT(1)
> +#define CIF_ISP_DATA_LOSS			BIT(2)
> +#define CIF_ISP_PIC_SIZE_ERROR			BIT(3)
> +#define CIF_ISP_AWB_DONE			BIT(4)
> +#define CIF_ISP_FRAME_IN			BIT(5)
> +#define CIF_ISP_V_START				BIT(6)
> +#define CIF_ISP_H_START				BIT(7)
> +#define CIF_ISP_FLASH_ON			BIT(8)
> +#define CIF_ISP_FLASH_OFF			BIT(9)
> +#define CIF_ISP_SHUTTER_ON			BIT(10)
> +#define CIF_ISP_SHUTTER_OFF			BIT(11)
> +#define CIF_ISP_AFM_SUM_OF			BIT(12)
> +#define CIF_ISP_AFM_LUM_OF			BIT(13)
> +#define CIF_ISP_AFM_FIN				BIT(14)
> +#define CIF_ISP_HIST_MEASURE_RDY		BIT(15)
> +#define CIF_ISP_FLASH_CAP			BIT(17)
> +#define CIF_ISP_EXP_END				BIT(18)
> +#define CIF_ISP_VSM_END				BIT(19)
> +
> +/* ISP_ERR */
> +#define CIF_ISP_ERR_INFORM_SIZE			BIT(0)
> +#define CIF_ISP_ERR_IS_SIZE			BIT(1)
> +#define CIF_ISP_ERR_OUTFORM_SIZE		BIT(2)
> +
> +/* MI_CTRL */
> +#define CIF_MI_CTRL_MP_ENABLE			(1 << 0)
> +#define CIF_MI_CTRL_SP_ENABLE			(2 << 0)
> +#define CIF_MI_CTRL_JPEG_ENABLE			(4 << 0)
> +#define CIF_MI_CTRL_RAW_ENABLE			(8 << 0)
> +#define CIF_MI_CTRL_HFLIP			BIT(4)
> +#define CIF_MI_CTRL_VFLIP			BIT(5)
> +#define CIF_MI_CTRL_ROT				BIT(6)
> +#define CIF_MI_BYTE_SWAP			BIT(7)
> +#define CIF_MI_SP_Y_FULL_YUV2RGB		BIT(8)
> +#define CIF_MI_SP_CBCR_FULL_YUV2RGB		BIT(9)
> +#define CIF_MI_SP_422NONCOSITEED		BIT(10)
> +#define CIF_MI_MP_PINGPONG_ENABEL		BIT(11)
> +#define CIF_MI_SP_PINGPONG_ENABEL		BIT(12)
> +#define CIF_MI_MP_AUTOUPDATE_ENABLE		BIT(13)
> +#define CIF_MI_SP_AUTOUPDATE_ENABLE		BIT(14)
> +#define CIF_MI_LAST_PIXEL_SIG_ENABLE		BIT(15)
> +#define CIF_MI_CTRL_BURST_LEN_LUM_16		(0 << 16)
> +#define CIF_MI_CTRL_BURST_LEN_LUM_32		(1 << 16)
> +#define CIF_MI_CTRL_BURST_LEN_LUM_64		(2 << 16)
> +#define CIF_MI_CTRL_BURST_LEN_CHROM_16		(0 << 18)
> +#define CIF_MI_CTRL_BURST_LEN_CHROM_32		(1 << 18)
> +#define CIF_MI_CTRL_BURST_LEN_CHROM_64		(2 << 18)
> +#define CIF_MI_CTRL_INIT_BASE_EN		BIT(20)
> +#define CIF_MI_CTRL_INIT_OFFSET_EN		BIT(21)
> +#define MI_CTRL_MP_WRITE_YUV_PLA_OR_RAW8	(0 << 22)
> +#define MI_CTRL_MP_WRITE_YUV_SPLA		(1 << 22)
> +#define MI_CTRL_MP_WRITE_YUVINT			(2 << 22)
> +#define MI_CTRL_MP_WRITE_RAW12			(2 << 22)
> +#define MI_CTRL_SP_WRITE_PLA			(0 << 24)
> +#define MI_CTRL_SP_WRITE_SPLA			(1 << 24)
> +#define MI_CTRL_SP_WRITE_INT			(2 << 24)
> +#define MI_CTRL_SP_INPUT_YUV400			(0 << 26)
> +#define MI_CTRL_SP_INPUT_YUV420			(1 << 26)
> +#define MI_CTRL_SP_INPUT_YUV422			(2 << 26)
> +#define MI_CTRL_SP_INPUT_YUV444			(3 << 26)
> +#define MI_CTRL_SP_OUTPUT_YUV400		(0 << 28)
> +#define MI_CTRL_SP_OUTPUT_YUV420		(1 << 28)
> +#define MI_CTRL_SP_OUTPUT_YUV422		(2 << 28)
> +#define MI_CTRL_SP_OUTPUT_YUV444		(3 << 28)
> +#define MI_CTRL_SP_OUTPUT_RGB565		(4 << 28)
> +#define MI_CTRL_SP_OUTPUT_RGB666		(5 << 28)
> +#define MI_CTRL_SP_OUTPUT_RGB888		(6 << 28)
> +
> +#define MI_CTRL_MP_FMT_MASK			GENMASK(23, 22)
> +#define MI_CTRL_SP_FMT_MASK			GENMASK(30, 24)
> +
> +/* MI_INIT */
> +#define CIF_MI_INIT_SKIP			BIT(2)
> +#define CIF_MI_INIT_SOFT_UPD			BIT(4)
> +
> +/* RSZ_CTRL */
> +#define CIF_RSZ_CTRL_SCALE_HY_ENABLE		BIT(0)
> +#define CIF_RSZ_CTRL_SCALE_HC_ENABLE		BIT(1)
> +#define CIF_RSZ_CTRL_SCALE_VY_ENABLE		BIT(2)
> +#define CIF_RSZ_CTRL_SCALE_VC_ENABLE		BIT(3)
> +#define CIF_RSZ_CTRL_SCALE_HY_UP		BIT(4)
> +#define CIF_RSZ_CTRL_SCALE_HC_UP		BIT(5)
> +#define CIF_RSZ_CTRL_SCALE_VY_UP		BIT(6)
> +#define CIF_RSZ_CTRL_SCALE_VC_UP		BIT(7)
> +#define CIF_RSZ_CTRL_CFG_UPD			BIT(8)
> +#define CIF_RSZ_CTRL_CFG_UPD_AUTO		BIT(9)
> +#define CIF_RSZ_SCALER_FACTOR			BIT(16)
> +
> +/* MI_IMSC - MI_MIS - MI_RIS - MI_ICR - MI_ISR */
> +#define CIF_MI_MP_FRAME				BIT(0)
> +#define CIF_MI_SP_FRAME				BIT(1)
> +#define CIF_MI_MBLK_LINE			BIT(2)
> +#define CIF_MI_FILL_MP_Y			BIT(3)
> +#define CIF_MI_WRAP_MP_Y			BIT(4)
> +#define CIF_MI_WRAP_MP_CB			BIT(5)
> +#define CIF_MI_WRAP_MP_CR			BIT(6)
> +#define CIF_MI_WRAP_SP_Y			BIT(7)
> +#define CIF_MI_WRAP_SP_CB			BIT(8)
> +#define CIF_MI_WRAP_SP_CR			BIT(9)
> +#define CIF_MI_DMA_READY			BIT(11)
> +
> +/* MI_STATUS */
> +#define CIF_MI_STATUS_MP_Y_FIFO_FULL		BIT(0)
> +#define CIF_MI_STATUS_SP_Y_FIFO_FULL		BIT(4)
> +
> +/* MI_DMA_CTRL */
> +#define CIF_MI_DMA_CTRL_BURST_LEN_LUM_16	(0 << 0)
> +#define CIF_MI_DMA_CTRL_BURST_LEN_LUM_32	(1 << 0)
> +#define CIF_MI_DMA_CTRL_BURST_LEN_LUM_64	(2 << 0)
> +#define CIF_MI_DMA_CTRL_BURST_LEN_CHROM_16	(0 << 2)
> +#define CIF_MI_DMA_CTRL_BURST_LEN_CHROM_32	(1 << 2)
> +#define CIF_MI_DMA_CTRL_BURST_LEN_CHROM_64	(2 << 2)
> +#define CIF_MI_DMA_CTRL_READ_FMT_PLANAR		(0 << 4)
> +#define CIF_MI_DMA_CTRL_READ_FMT_SPLANAR	(1 << 4)
> +#define CIF_MI_DMA_CTRL_FMT_YUV400		(0 << 6)
> +#define CIF_MI_DMA_CTRL_FMT_YUV420		(1 << 6)
> +#define CIF_MI_DMA_CTRL_READ_FMT_PACKED		(2 << 4)
> +#define CIF_MI_DMA_CTRL_FMT_YUV422		(2 << 6)
> +#define CIF_MI_DMA_CTRL_FMT_YUV444		(3 << 6)
> +#define CIF_MI_DMA_CTRL_BYTE_SWAP		BIT(8)
> +#define CIF_MI_DMA_CTRL_CONTINUOUS_ENA		BIT(9)
> +#define CIF_MI_DMA_CTRL_RGB_BAYER_NO		(0 << 12)
> +#define CIF_MI_DMA_CTRL_RGB_BAYER_8BIT		(1 << 12)
> +#define CIF_MI_DMA_CTRL_RGB_BAYER_16BIT		(2 << 12)
> +/* MI_DMA_START */
> +#define CIF_MI_DMA_START_ENABLE			BIT(0)
> +/* MI_XTD_FORMAT_CTRL  */
> +#define CIF_MI_XTD_FMT_CTRL_MP_CB_CR_SWAP	BIT(0)
> +#define CIF_MI_XTD_FMT_CTRL_SP_CB_CR_SWAP	BIT(1)
> +#define CIF_MI_XTD_FMT_CTRL_DMA_CB_CR_SWAP	BIT(2)
> +
> +/* CCL */
> +#define CIF_CCL_CIF_CLK_DIS			BIT(2)
> +/* ICCL */
> +#define CIF_ICCL_ISP_CLK			BIT(0)
> +#define CIF_ICCL_CP_CLK				BIT(1)
> +#define CIF_ICCL_RES_2				BIT(2)
> +#define CIF_ICCL_MRSZ_CLK			BIT(3)
> +#define CIF_ICCL_SRSZ_CLK			BIT(4)
> +#define CIF_ICCL_JPEG_CLK			BIT(5)
> +#define CIF_ICCL_MI_CLK				BIT(6)
> +#define CIF_ICCL_RES_7				BIT(7)
> +#define CIF_ICCL_IE_CLK				BIT(8)
> +#define CIF_ICCL_SIMP_CLK			BIT(9)
> +#define CIF_ICCL_SMIA_CLK			BIT(10)
> +#define CIF_ICCL_MIPI_CLK			BIT(11)
> +#define CIF_ICCL_DCROP_CLK			BIT(12)
> +/* IRCL */
> +#define CIF_IRCL_ISP_SW_RST			BIT(0)
> +#define CIF_IRCL_CP_SW_RST			BIT(1)
> +#define CIF_IRCL_YCS_SW_RST			BIT(2)
> +#define CIF_IRCL_MRSZ_SW_RST			BIT(3)
> +#define CIF_IRCL_SRSZ_SW_RST			BIT(4)
> +#define CIF_IRCL_JPEG_SW_RST			BIT(5)
> +#define CIF_IRCL_MI_SW_RST			BIT(6)
> +#define CIF_IRCL_CIF_SW_RST			BIT(7)
> +#define CIF_IRCL_IE_SW_RST			BIT(8)
> +#define CIF_IRCL_SI_SW_RST			BIT(9)
> +#define CIF_IRCL_MIPI_SW_RST			BIT(11)
> +
> +/* C_PROC_CTR */
> +#define CIF_C_PROC_CTR_ENABLE			BIT(0)
> +#define CIF_C_PROC_YOUT_FULL			BIT(1)
> +#define CIF_C_PROC_YIN_FULL			BIT(2)
> +#define CIF_C_PROC_COUT_FULL			BIT(3)
> +#define CIF_C_PROC_CTRL_RESERVED		0xFFFFFFFE
> +#define CIF_C_PROC_CONTRAST_RESERVED		0xFFFFFF00
> +#define CIF_C_PROC_BRIGHTNESS_RESERVED		0xFFFFFF00
> +#define CIF_C_PROC_HUE_RESERVED			0xFFFFFF00
> +#define CIF_C_PROC_SATURATION_RESERVED		0xFFFFFF00
> +#define CIF_C_PROC_MACC_RESERVED		0xE000E000
> +#define CIF_C_PROC_TONE_RESERVED		0xF000
> +/* DUAL_CROP_CTRL */
> +#define CIF_DUAL_CROP_MP_MODE_BYPASS		(0 << 0)
> +#define CIF_DUAL_CROP_MP_MODE_YUV		(1 << 0)
> +#define CIF_DUAL_CROP_MP_MODE_RAW		(2 << 0)
> +#define CIF_DUAL_CROP_SP_MODE_BYPASS		(0 << 2)
> +#define CIF_DUAL_CROP_SP_MODE_YUV		(1 << 2)
> +#define CIF_DUAL_CROP_SP_MODE_RAW		(2 << 2)
> +#define CIF_DUAL_CROP_CFG_UPD_PERMANENT		BIT(4)
> +#define CIF_DUAL_CROP_CFG_UPD			BIT(5)
> +#define CIF_DUAL_CROP_GEN_CFG_UPD		BIT(6)
> +
> +/* IMG_EFF_CTRL */
> +#define CIF_IMG_EFF_CTRL_ENABLE			BIT(0)
> +#define CIF_IMG_EFF_CTRL_MODE_BLACKWHITE	(0 << 1)
> +#define CIF_IMG_EFF_CTRL_MODE_NEGATIVE		(1 << 1)
> +#define CIF_IMG_EFF_CTRL_MODE_SEPIA		(2 << 1)
> +#define CIF_IMG_EFF_CTRL_MODE_COLOR_SEL		(3 << 1)
> +#define CIF_IMG_EFF_CTRL_MODE_EMBOSS		(4 << 1)
> +#define CIF_IMG_EFF_CTRL_MODE_SKETCH		(5 << 1)
> +#define CIF_IMG_EFF_CTRL_MODE_SHARPEN		(6 << 1)
> +#define CIF_IMG_EFF_CTRL_CFG_UPD		BIT(4)
> +#define CIF_IMG_EFF_CTRL_YCBCR_FULL		BIT(5)
> +
> +#define CIF_IMG_EFF_CTRL_MODE_BLACKWHITE_SHIFT	0
> +#define CIF_IMG_EFF_CTRL_MODE_NEGATIVE_SHIFT	1
> +#define CIF_IMG_EFF_CTRL_MODE_SEPIA_SHIFT	2
> +#define CIF_IMG_EFF_CTRL_MODE_COLOR_SEL_SHIFT	3
> +#define CIF_IMG_EFF_CTRL_MODE_EMBOSS_SHIFT	4
> +#define CIF_IMG_EFF_CTRL_MODE_SKETCH_SHIFT	5
> +#define CIF_IMG_EFF_CTRL_MODE_SHARPEN_SHIFT	6
> +#define CIF_IMG_EFF_CTRL_MODE_MASK		0xE
> +
> +/* IMG_EFF_COLOR_SEL */
> +#define CIF_IMG_EFF_COLOR_RGB			0
> +#define CIF_IMG_EFF_COLOR_B			(1 << 0)
> +#define CIF_IMG_EFF_COLOR_G			(2 << 0)
> +#define CIF_IMG_EFF_COLOR_GB			(3 << 0)
> +#define CIF_IMG_EFF_COLOR_R			(4 << 0)
> +#define CIF_IMG_EFF_COLOR_RB			(5 << 0)
> +#define CIF_IMG_EFF_COLOR_RG			(6 << 0)
> +#define CIF_IMG_EFF_COLOR_RGB2			(7 << 0)
> +
> +/* MIPI_CTRL */
> +#define CIF_MIPI_CTRL_OUTPUT_ENA		BIT(0)
> +#define CIF_MIPI_CTRL_SHUTDOWNLANES(a)		(((a) & 0xF) << 8)
> +#define CIF_MIPI_CTRL_NUM_LANES(a)		(((a) & 0x3) << 12)
> +#define CIF_MIPI_CTRL_ERR_SOT_HS_SKIP		BIT(16)
> +#define CIF_MIPI_CTRL_ERR_SOT_SYNC_HS_SKIP	BIT(17)
> +#define CIF_MIPI_CTRL_CLOCKLANE_ENA		BIT(18)
> +
> +/* MIPI_DATA_SEL */
> +#define CIF_MIPI_DATA_SEL_VC(a)			(((a) & 0x3) << 6)
> +#define CIF_MIPI_DATA_SEL_DT(a)			(((a) & 0x3F) << 0)
> +/* MIPI DATA_TYPE */
> +#define CIF_CSI2_DT_YUV420_8b			0x18
> +#define CIF_CSI2_DT_YUV420_10b			0x19
> +#define CIF_CSI2_DT_YUV422_8b			0x1E
> +#define CIF_CSI2_DT_YUV422_10b			0x1F
> +#define CIF_CSI2_DT_RGB565			0x22
> +#define CIF_CSI2_DT_RGB666			0x23
> +#define CIF_CSI2_DT_RGB888			0x24
> +#define CIF_CSI2_DT_RAW8			0x2A
> +#define CIF_CSI2_DT_RAW10			0x2B
> +#define CIF_CSI2_DT_RAW12			0x2C
> +
> +/* MIPI_IMSC, MIPI_RIS, MIPI_MIS, MIPI_ICR, MIPI_ISR */
> +#define CIF_MIPI_SYNC_FIFO_OVFLW(a)		(((a) & 0xF) << 0)
> +#define CIF_MIPI_ERR_SOT(a)			(((a) & 0xF) << 4)
> +#define CIF_MIPI_ERR_SOT_SYNC(a)		(((a) & 0xF) << 8)
> +#define CIF_MIPI_ERR_EOT_SYNC(a)		(((a) & 0xF) << 12)
> +#define CIF_MIPI_ERR_CTRL(a)			(((a) & 0xF) << 16)
> +#define CIF_MIPI_ERR_PROTOCOL			BIT(20)
> +#define CIF_MIPI_ERR_ECC1			BIT(21)
> +#define CIF_MIPI_ERR_ECC2			BIT(22)
> +#define CIF_MIPI_ERR_CS				BIT(23)
> +#define CIF_MIPI_FRAME_END			BIT(24)
> +#define CIF_MIPI_ADD_DATA_OVFLW			BIT(25)
> +#define CIF_MIPI_ADD_DATA_WATER_MARK		BIT(26)
> +
> +#define CIF_MIPI_ERR_CSI  (CIF_MIPI_ERR_PROTOCOL | \
> +	CIF_MIPI_ERR_ECC1 | \
> +	CIF_MIPI_ERR_ECC2 | \
> +	CIF_MIPI_ERR_CS)
> +
> +#define CIF_MIPI_ERR_DPHY  (CIF_MIPI_ERR_SOT(3) | \
> +	CIF_MIPI_ERR_SOT_SYNC(3) | \
> +	CIF_MIPI_ERR_EOT_SYNC(3) | \
> +	CIF_MIPI_ERR_CTRL(3))
> +
> +/* SUPER_IMPOSE */
> +#define CIF_SUPER_IMP_CTRL_NORMAL_MODE		BIT(0)
> +#define CIF_SUPER_IMP_CTRL_REF_IMG_MEM		BIT(1)
> +#define CIF_SUPER_IMP_CTRL_TRANSP_DIS		BIT(2)
> +
> +/* ISP HISTOGRAM CALCULATION : ISP_HIST_PROP */
> +#define CIF_ISP_HIST_PROP_MODE_DIS		(0 << 0)
> +#define CIF_ISP_HIST_PROP_MODE_RGB		(1 << 0)
> +#define CIF_ISP_HIST_PROP_MODE_RED		(2 << 0)
> +#define CIF_ISP_HIST_PROP_MODE_GREEN		(3 << 0)
> +#define CIF_ISP_HIST_PROP_MODE_BLUE		(4 << 0)
> +#define CIF_ISP_HIST_PROP_MODE_LUM		(5 << 0)
> +#define CIF_ISP_HIST_PROP_MODE_MASK		0x7
> +#define CIF_ISP_HIST_PREDIV_SET(x)		(((x) & 0x7F) << 3)
> +#define CIF_ISP_HIST_WEIGHT_SET(v0, v1, v2, v3)	\
> +				     (((v0) & 0x1F) | (((v1) & 0x1F) << 8)  |\
> +				     (((v2) & 0x1F) << 16) | \
> +				     (((v3) & 0x1F) << 24))
> +
> +#define CIF_ISP_HIST_WINDOW_OFFSET_RESERVED	0xFFFFF000
> +#define CIF_ISP_HIST_WINDOW_SIZE_RESERVED	0xFFFFF800
> +#define CIF_ISP_HIST_WEIGHT_RESERVED		0xE0E0E0E0
> +#define CIF_ISP_MAX_HIST_PREDIVIDER		0x0000007F
> +#define CIF_ISP_HIST_ROW_NUM			5
> +#define CIF_ISP_HIST_COLUMN_NUM			5
> +
> +/* AUTO FOCUS MEASUREMENT:  ISP_AFM_CTRL */
> +#define ISP_AFM_CTRL_ENABLE			BIT(0)
> +
> +/* SHUTTER CONTROL */
> +#define CIF_ISP_SH_CTRL_SH_ENA			BIT(0)
> +#define CIF_ISP_SH_CTRL_REP_EN			BIT(1)
> +#define CIF_ISP_SH_CTRL_SRC_SH_TRIG		BIT(2)
> +#define CIF_ISP_SH_CTRL_EDGE_POS		BIT(3)
> +#define CIF_ISP_SH_CTRL_POL_LOW			BIT(4)
> +
> +/* FLASH MODULE */
> +/* ISP_FLASH_CMD */
> +#define CIF_FLASH_CMD_PRELIGHT_ON		BIT(0)
> +#define CIF_FLASH_CMD_FLASH_ON			BIT(1)
> +#define CIF_FLASH_CMD_PRE_FLASH_ON		BIT(2)
> +/* ISP_FLASH_CONFIG */
> +#define CIF_FLASH_CONFIG_PRELIGHT_END		BIT(0)
> +#define CIF_FLASH_CONFIG_VSYNC_POS		BIT(1)
> +#define CIF_FLASH_CONFIG_PRELIGHT_LOW		BIT(2)
> +#define CIF_FLASH_CONFIG_SRC_FL_TRIG		BIT(3)
> +#define CIF_FLASH_CONFIG_DELAY(a)		(((a) & 0xF) << 4)
> +
> +/* Demosaic:  ISP_DEMOSAIC */
> +#define CIF_ISP_DEMOSAIC_BYPASS			BIT(10)
> +#define CIF_ISP_DEMOSAIC_TH(x)			((x) & 0xFF)
> +
> +/* AWB */
> +/* ISP_AWB_PROP */
> +#define CIF_ISP_AWB_YMAX_CMP_EN			BIT(2)
> +#define CIFISP_AWB_YMAX_READ(x)			(((x) >> 2) & 1)
> +#define CIF_ISP_AWB_MODE_RGB_EN			((1 << 31) | (0x2 << 0))
> +#define CIF_ISP_AWB_MODE_YCBCR_EN		((0 << 31) | (0x2 << 0))
> +#define CIF_ISP_AWB_MODE_YCBCR_EN		((0 << 31) | (0x2 << 0))
> +#define CIF_ISP_AWB_MODE_MASK_NONE		0xFFFFFFFC
> +#define CIF_ISP_AWB_MODE_READ(x)		((x) & 3)
> +/* ISP_AWB_GAIN_RB, ISP_AWB_GAIN_G  */
> +#define CIF_ISP_AWB_GAIN_R_SET(x)		(((x) & 0x3FF) << 16)
> +#define CIF_ISP_AWB_GAIN_R_READ(x)		(((x) >> 16) & 0x3FF)
> +#define CIF_ISP_AWB_GAIN_B_SET(x)		((x) & 0x3FFF)
> +#define CIF_ISP_AWB_GAIN_B_READ(x)		((x) & 0x3FFF)
> +/* ISP_AWB_REF */
> +#define CIF_ISP_AWB_REF_CR_SET(x)		(((x) & 0xFF) << 8)
> +#define CIF_ISP_AWB_REF_CR_READ(x)		(((x) >> 8) & 0xFF)
> +#define CIF_ISP_AWB_REF_CB_READ(x)		((x) & 0xFF)
> +/* ISP_AWB_THRESH */
> +#define CIF_ISP_AWB_MAX_CS_SET(x)		(((x) & 0xFF) << 8)
> +#define CIF_ISP_AWB_MAX_CS_READ(x)		(((x) >> 8) & 0xFF)
> +#define CIF_ISP_AWB_MIN_C_READ(x)		((x) & 0xFF)
> +#define CIF_ISP_AWB_MIN_Y_SET(x)		(((x) & 0xFF) << 16)
> +#define CIF_ISP_AWB_MIN_Y_READ(x)		(((x) >> 16) & 0xFF)
> +#define CIF_ISP_AWB_MAX_Y_SET(x)		(((x) & 0xFF) << 24)
> +#define CIF_ISP_AWB_MAX_Y_READ(x)		(((x) >> 24) & 0xFF)
> +/* ISP_AWB_MEAN */
> +#define CIF_ISP_AWB_GET_MEAN_CR_R(x)		((x) & 0xFF)
> +#define CIF_ISP_AWB_GET_MEAN_CB_B(x)		(((x) >> 8) & 0xFF)
> +#define CIF_ISP_AWB_GET_MEAN_Y_G(x)		(((x) >> 16) & 0xFF)
> +/* ISP_AWB_WHITE_CNT */
> +#define CIF_ISP_AWB_GET_PIXEL_CNT(x)		((x) & 0x3FFFFFF)
> +
> +#define CIF_ISP_AWB_GAINS_MAX_VAL		0x000003FF
> +#define CIF_ISP_AWB_WINDOW_OFFSET_MAX		0x00000FFF
> +#define CIF_ISP_AWB_WINDOW_MAX_SIZE		0x00001FFF
> +#define CIF_ISP_AWB_CBCR_MAX_REF		0x000000FF
> +#define CIF_ISP_AWB_THRES_MAX_YC		0x000000FF
> +
> +/* AE */
> +/* ISP_EXP_CTRL */
> +#define CIF_ISP_EXP_ENA				BIT(0)
> +#define CIF_ISP_EXP_CTRL_AUTOSTOP		BIT(1)
> +/*
> + *'1' luminance calculation according to  Y=(R+G+B) x 0.332 (85/256)
> + *'0' luminance calculation according to Y=16+0.25R+0.5G+0.1094B
> + */
> +#define CIF_ISP_EXP_CTRL_MEASMODE_1		BIT(31)
> +
> +/* ISP_EXP_H_SIZE */
> +#define CIF_ISP_EXP_H_SIZE_SET(x)		((x) & 0x7FF)
> +#define CIF_ISP_EXP_HEIGHT_MASK			0x000007FF
> +/* ISP_EXP_V_SIZE : vertical size must be a multiple of 2). */
> +#define CIF_ISP_EXP_V_SIZE_SET(x)		((x) & 0x7FE)
> +
> +/* ISP_EXP_H_OFFSET */
> +#define CIF_ISP_EXP_H_OFFSET_SET(x)		((x) & 0x1FFF)
> +#define CIF_ISP_EXP_MAX_HOFFS			2424
> +/* ISP_EXP_V_OFFSET */
> +#define CIF_ISP_EXP_V_OFFSET_SET(x)		((x) & 0x1FFF)
> +#define CIF_ISP_EXP_MAX_VOFFS			1806
> +
> +#define CIF_ISP_EXP_ROW_NUM			5
> +#define CIF_ISP_EXP_COLUMN_NUM			5
> +#define CIF_ISP_EXP_NUM_LUMA_REGS \
> +	(CIF_ISP_EXP_ROW_NUM * CIF_ISP_EXP_COLUMN_NUM)
> +#define CIF_ISP_EXP_BLOCK_MAX_HSIZE		516
> +#define CIF_ISP_EXP_BLOCK_MIN_HSIZE		35
> +#define CIF_ISP_EXP_BLOCK_MAX_VSIZE		390
> +#define CIF_ISP_EXP_BLOCK_MIN_VSIZE		28
> +#define CIF_ISP_EXP_MAX_HSIZE	\
> +	(CIF_ISP_EXP_BLOCK_MAX_HSIZE * CIF_ISP_EXP_COLUMN_NUM + 1)
> +#define CIF_ISP_EXP_MIN_HSIZE	\
> +	(CIF_ISP_EXP_BLOCK_MIN_HSIZE * CIF_ISP_EXP_COLUMN_NUM + 1)
> +#define CIF_ISP_EXP_MAX_VSIZE	\
> +	(CIF_ISP_EXP_BLOCK_MAX_VSIZE * CIF_ISP_EXP_ROW_NUM + 1)
> +#define CIF_ISP_EXP_MIN_VSIZE	\
> +	(CIF_ISP_EXP_BLOCK_MIN_VSIZE * CIF_ISP_EXP_ROW_NUM + 1)
> +
> +/* LSC: ISP_LSC_CTRL */
> +#define CIF_ISP_LSC_CTRL_ENA			BIT(0)
> +#define CIF_ISP_LSC_SECT_SIZE_RESERVED		0xFC00FC00
> +#define CIF_ISP_LSC_GRAD_RESERVED		0xF000F000
> +#define CIF_ISP_LSC_SAMPLE_RESERVED		0xF000F000
> +#define CIF_ISP_LSC_SECTORS_MAX			16
> +#define CIF_ISP_LSC_TABLE_DATA(v0, v1)     \
> +	(((v0) & 0xFFF) | (((v1) & 0xFFF) << 12))
> +#define CIF_ISP_LSC_SECT_SIZE(v0, v1)      \
> +	(((v0) & 0xFFF) | (((v1) & 0xFFF) << 16))
> +#define CIF_ISP_LSC_GRAD_SIZE(v0, v1)      \
> +	(((v0) & 0xFFF) | (((v1) & 0xFFF) << 16))
> +
> +/* LSC: ISP_LSC_TABLE_SEL */
> +#define CIF_ISP_LSC_TABLE_0			0
> +#define CIF_ISP_LSC_TABLE_1			1
> +
> +/* LSC: ISP_LSC_STATUS */
> +#define CIF_ISP_LSC_ACTIVE_TABLE		BIT(1)
> +#define CIF_ISP_LSC_TABLE_ADDRESS_0		0
> +#define CIF_ISP_LSC_TABLE_ADDRESS_153		153
> +
> +/* FLT */
> +/* ISP_FILT_MODE */
> +#define CIF_ISP_FLT_ENA				BIT(0)
> +
> +/*
> + * 0: green filter static mode (active filter factor = FILT_FAC_MID)
> + * 1: dynamic noise reduction/sharpen Default
> + */
> +#define CIF_ISP_FLT_MODE_DNR			BIT(1)
> +#define CIF_ISP_FLT_MODE_MAX			1
> +#define CIF_ISP_FLT_CHROMA_V_MODE(x)		(((x) & 0x3) << 4)
> +#define CIF_ISP_FLT_CHROMA_H_MODE(x)		(((x) & 0x3) << 6)
> +#define CIF_ISP_FLT_CHROMA_MODE_MAX		3
> +#define CIF_ISP_FLT_GREEN_STAGE1(x)		(((x) & 0xF) << 8)
> +#define CIF_ISP_FLT_GREEN_STAGE1_MAX		8
> +#define CIF_ISP_FLT_THREAD_RESERVED		0xFFFFFC00
> +#define CIF_ISP_FLT_FAC_RESERVED		0xFFFFFFC0
> +#define CIF_ISP_FLT_LUM_WEIGHT_RESERVED		0xFFF80000
> +
> +#define CIF_ISP_CTK_COEFF_RESERVED		0xFFFFF800
> +#define CIF_ISP_XTALK_OFFSET_RESERVED		0xFFFFF000
> +
> +/* GOC */
> +#define CIF_ISP_GAMMA_OUT_MODE_EQU		BIT(0)
> +#define CIF_ISP_GOC_MODE_MAX			1
> +#define CIF_ISP_GOC_RESERVED			0xFFFFF800
> +/* ISP_CTRL BIT 11*/
> +#define CIF_ISP_CTRL_ISP_GAMMA_OUT_ENA_READ(x)	(((x) >> 11) & 1)
> +
> +/* DPCC */
> +/* ISP_DPCC_MODE */
> +#define CIF_ISP_DPCC_ENA			BIT(0)
> +#define CIF_ISP_DPCC_MODE_MAX			0x07
> +#define CIF_ISP_DPCC_OUTPUTMODE_MAX		0x0F
> +#define CIF_ISP_DPCC_SETUSE_MAX			0x0F
> +#define CIF_ISP_DPCC_METHODS_SET_RESERVED	0xFFFFE000
> +#define CIF_ISP_DPCC_LINE_THRESH_RESERVED	0xFFFF0000
> +#define CIF_ISP_DPCC_LINE_MAD_FAC_RESERVED	0xFFFFC0C0
> +#define CIF_ISP_DPCC_PG_FAC_RESERVED		0xFFFFC0C0
> +#define CIF_ISP_DPCC_RND_THRESH_RESERVED	0xFFFF0000
> +#define CIF_ISP_DPCC_RG_FAC_RESERVED		0xFFFFC0C0
> +#define CIF_ISP_DPCC_RO_LIMIT_RESERVED		0xFFFFF000
> +#define CIF_ISP_DPCC_RND_OFFS_RESERVED		0xFFFFF000
> +
> +/* BLS */
> +/* ISP_BLS_CTRL */
> +#define CIF_ISP_BLS_ENA				BIT(0)
> +#define CIF_ISP_BLS_MODE_MEASURED		BIT(1)
> +#define CIF_ISP_BLS_MODE_FIXED			0
> +#define CIF_ISP_BLS_WINDOW_1			(1 << 2)
> +#define CIF_ISP_BLS_WINDOW_2			(2 << 2)
> +
> +/* GAMMA-IN */
> +#define CIFISP_DEGAMMA_X_RESERVED	\
> +	((1 << 31) | (1 << 27) | (1 << 23) | (1 << 19) |\
> +	(1 << 15) | (1 << 11) | (1 << 7) | (1 << 3))
> +#define CIFISP_DEGAMMA_Y_RESERVED               0xFFFFF000
> +
> +/* AFM */
> +#define CIF_ISP_AFM_ENA				BIT(0)
> +#define CIF_ISP_AFM_THRES_RESERVED		0xFFFF0000
> +#define CIF_ISP_AFM_VAR_SHIFT_RESERVED		0xFFF8FFF8
> +#define CIF_ISP_AFM_WINDOW_X_RESERVED		0xE000
> +#define CIF_ISP_AFM_WINDOW_Y_RESERVED		0xF000
> +#define CIF_ISP_AFM_WINDOW_X_MIN		0x5
> +#define CIF_ISP_AFM_WINDOW_Y_MIN		0x2
> +#define CIF_ISP_AFM_WINDOW_X(x)			(((x) & 0x1FFF) << 16)
> +#define CIF_ISP_AFM_WINDOW_Y(x)			((x) & 0x1FFF)
> +
> +/* DPF */
> +#define CIF_ISP_DPF_MODE_EN			BIT(0)
> +#define CIF_ISP_DPF_MODE_B_FLT_DIS		BIT(1)
> +#define CIF_ISP_DPF_MODE_GB_FLT_DIS		BIT(2)
> +#define CIF_ISP_DPF_MODE_GR_FLT_DIS		BIT(3)
> +#define CIF_ISP_DPF_MODE_R_FLT_DIS		BIT(4)
> +#define CIF_ISP_DPF_MODE_RB_FLTSIZE_9x9		BIT(5)
> +#define CIF_ISP_DPF_MODE_NLL_SEGMENTATION	BIT(6)
> +#define CIF_ISP_DPF_MODE_AWB_GAIN_COMP		BIT(7)
> +#define CIF_ISP_DPF_MODE_LSC_GAIN_COMP		BIT(8)
> +#define CIF_ISP_DPF_MODE_USE_NF_GAIN		BIT(9)
> +#define CIF_ISP_DPF_NF_GAIN_RESERVED		0xFFFFF000
> +#define CIF_ISP_DPF_SPATIAL_COEFF_MAX		0x1F
> +#define CIF_ISP_DPF_NLL_COEFF_N_MAX		0x3FF
> +
> +/* =================================================================== */
> +/*                            CIF Registers                            */
> +/* =================================================================== */
> +#define CIF_CTRL_BASE			0x00000000
> +#define CIF_CCL				(CIF_CTRL_BASE + 0x00000000)
> +#define CIF_VI_ID			(CIF_CTRL_BASE + 0x00000008)
> +#define CIF_ICCL			(CIF_CTRL_BASE + 0x00000010)
> +#define CIF_IRCL			(CIF_CTRL_BASE + 0x00000014)
> +#define CIF_VI_DPCL			(CIF_CTRL_BASE + 0x00000018)
> +
> +#define CIF_IMG_EFF_BASE		0x00000200
> +#define CIF_IMG_EFF_CTRL		(CIF_IMG_EFF_BASE + 0x00000000)
> +#define CIF_IMG_EFF_COLOR_SEL		(CIF_IMG_EFF_BASE + 0x00000004)
> +#define CIF_IMG_EFF_MAT_1		(CIF_IMG_EFF_BASE + 0x00000008)
> +#define CIF_IMG_EFF_MAT_2		(CIF_IMG_EFF_BASE + 0x0000000C)
> +#define CIF_IMG_EFF_MAT_3		(CIF_IMG_EFF_BASE + 0x00000010)
> +#define CIF_IMG_EFF_MAT_4		(CIF_IMG_EFF_BASE + 0x00000014)
> +#define CIF_IMG_EFF_MAT_5		(CIF_IMG_EFF_BASE + 0x00000018)
> +#define CIF_IMG_EFF_TINT		(CIF_IMG_EFF_BASE + 0x0000001C)
> +#define CIF_IMG_EFF_CTRL_SHD		(CIF_IMG_EFF_BASE + 0x00000020)
> +#define CIF_IMG_EFF_SHARPEN		(CIF_IMG_EFF_BASE + 0x00000024)
> +
> +#define CIF_SUPER_IMP_BASE		0x00000300
> +#define CIF_SUPER_IMP_CTRL		(CIF_SUPER_IMP_BASE + 0x00000000)
> +#define CIF_SUPER_IMP_OFFSET_X		(CIF_SUPER_IMP_BASE + 0x00000004)
> +#define CIF_SUPER_IMP_OFFSET_Y		(CIF_SUPER_IMP_BASE + 0x00000008)
> +#define CIF_SUPER_IMP_COLOR_Y		(CIF_SUPER_IMP_BASE + 0x0000000C)
> +#define CIF_SUPER_IMP_COLOR_CB		(CIF_SUPER_IMP_BASE + 0x00000010)
> +#define CIF_SUPER_IMP_COLOR_CR		(CIF_SUPER_IMP_BASE + 0x00000014)
> +
> +#define CIF_ISP_BASE			0x00000400
> +#define CIF_ISP_CTRL			(CIF_ISP_BASE + 0x00000000)
> +#define CIF_ISP_ACQ_PROP		(CIF_ISP_BASE + 0x00000004)
> +#define CIF_ISP_ACQ_H_OFFS		(CIF_ISP_BASE + 0x00000008)
> +#define CIF_ISP_ACQ_V_OFFS		(CIF_ISP_BASE + 0x0000000C)
> +#define CIF_ISP_ACQ_H_SIZE		(CIF_ISP_BASE + 0x00000010)
> +#define CIF_ISP_ACQ_V_SIZE		(CIF_ISP_BASE + 0x00000014)
> +#define CIF_ISP_ACQ_NR_FRAMES		(CIF_ISP_BASE + 0x00000018)
> +#define CIF_ISP_GAMMA_DX_LO		(CIF_ISP_BASE + 0x0000001C)
> +#define CIF_ISP_GAMMA_DX_HI		(CIF_ISP_BASE + 0x00000020)
> +#define CIF_ISP_GAMMA_R_Y0		(CIF_ISP_BASE + 0x00000024)
> +#define CIF_ISP_GAMMA_R_Y1		(CIF_ISP_BASE + 0x00000028)
> +#define CIF_ISP_GAMMA_R_Y2		(CIF_ISP_BASE + 0x0000002C)
> +#define CIF_ISP_GAMMA_R_Y3		(CIF_ISP_BASE + 0x00000030)
> +#define CIF_ISP_GAMMA_R_Y4		(CIF_ISP_BASE + 0x00000034)
> +#define CIF_ISP_GAMMA_R_Y5		(CIF_ISP_BASE + 0x00000038)
> +#define CIF_ISP_GAMMA_R_Y6		(CIF_ISP_BASE + 0x0000003C)
> +#define CIF_ISP_GAMMA_R_Y7		(CIF_ISP_BASE + 0x00000040)
> +#define CIF_ISP_GAMMA_R_Y8		(CIF_ISP_BASE + 0x00000044)
> +#define CIF_ISP_GAMMA_R_Y9		(CIF_ISP_BASE + 0x00000048)
> +#define CIF_ISP_GAMMA_R_Y10		(CIF_ISP_BASE + 0x0000004C)
> +#define CIF_ISP_GAMMA_R_Y11		(CIF_ISP_BASE + 0x00000050)
> +#define CIF_ISP_GAMMA_R_Y12		(CIF_ISP_BASE + 0x00000054)
> +#define CIF_ISP_GAMMA_R_Y13		(CIF_ISP_BASE + 0x00000058)
> +#define CIF_ISP_GAMMA_R_Y14		(CIF_ISP_BASE + 0x0000005C)
> +#define CIF_ISP_GAMMA_R_Y15		(CIF_ISP_BASE + 0x00000060)
> +#define CIF_ISP_GAMMA_R_Y16		(CIF_ISP_BASE + 0x00000064)
> +#define CIF_ISP_GAMMA_G_Y0		(CIF_ISP_BASE + 0x00000068)
> +#define CIF_ISP_GAMMA_G_Y1		(CIF_ISP_BASE + 0x0000006C)
> +#define CIF_ISP_GAMMA_G_Y2		(CIF_ISP_BASE + 0x00000070)
> +#define CIF_ISP_GAMMA_G_Y3		(CIF_ISP_BASE + 0x00000074)
> +#define CIF_ISP_GAMMA_G_Y4		(CIF_ISP_BASE + 0x00000078)
> +#define CIF_ISP_GAMMA_G_Y5		(CIF_ISP_BASE + 0x0000007C)
> +#define CIF_ISP_GAMMA_G_Y6		(CIF_ISP_BASE + 0x00000080)
> +#define CIF_ISP_GAMMA_G_Y7		(CIF_ISP_BASE + 0x00000084)
> +#define CIF_ISP_GAMMA_G_Y8		(CIF_ISP_BASE + 0x00000088)
> +#define CIF_ISP_GAMMA_G_Y9		(CIF_ISP_BASE + 0x0000008C)
> +#define CIF_ISP_GAMMA_G_Y10		(CIF_ISP_BASE + 0x00000090)
> +#define CIF_ISP_GAMMA_G_Y11		(CIF_ISP_BASE + 0x00000094)
> +#define CIF_ISP_GAMMA_G_Y12		(CIF_ISP_BASE + 0x00000098)
> +#define CIF_ISP_GAMMA_G_Y13		(CIF_ISP_BASE + 0x0000009C)
> +#define CIF_ISP_GAMMA_G_Y14		(CIF_ISP_BASE + 0x000000A0)
> +#define CIF_ISP_GAMMA_G_Y15		(CIF_ISP_BASE + 0x000000A4)
> +#define CIF_ISP_GAMMA_G_Y16		(CIF_ISP_BASE + 0x000000A8)
> +#define CIF_ISP_GAMMA_B_Y0		(CIF_ISP_BASE + 0x000000AC)
> +#define CIF_ISP_GAMMA_B_Y1		(CIF_ISP_BASE + 0x000000B0)
> +#define CIF_ISP_GAMMA_B_Y2		(CIF_ISP_BASE + 0x000000B4)
> +#define CIF_ISP_GAMMA_B_Y3		(CIF_ISP_BASE + 0x000000B8)
> +#define CIF_ISP_GAMMA_B_Y4		(CIF_ISP_BASE + 0x000000BC)
> +#define CIF_ISP_GAMMA_B_Y5		(CIF_ISP_BASE + 0x000000C0)
> +#define CIF_ISP_GAMMA_B_Y6		(CIF_ISP_BASE + 0x000000C4)
> +#define CIF_ISP_GAMMA_B_Y7		(CIF_ISP_BASE + 0x000000C8)
> +#define CIF_ISP_GAMMA_B_Y8		(CIF_ISP_BASE + 0x000000CC)
> +#define CIF_ISP_GAMMA_B_Y9		(CIF_ISP_BASE + 0x000000D0)
> +#define CIF_ISP_GAMMA_B_Y10		(CIF_ISP_BASE + 0x000000D4)
> +#define CIF_ISP_GAMMA_B_Y11		(CIF_ISP_BASE + 0x000000D8)
> +#define CIF_ISP_GAMMA_B_Y12		(CIF_ISP_BASE + 0x000000DC)
> +#define CIF_ISP_GAMMA_B_Y13		(CIF_ISP_BASE + 0x000000E0)
> +#define CIF_ISP_GAMMA_B_Y14		(CIF_ISP_BASE + 0x000000E4)
> +#define CIF_ISP_GAMMA_B_Y15		(CIF_ISP_BASE + 0x000000E8)
> +#define CIF_ISP_GAMMA_B_Y16		(CIF_ISP_BASE + 0x000000EC)
> +#define CIF_ISP_AWB_PROP		(CIF_ISP_BASE + 0x00000110)
> +#define CIF_ISP_AWB_WND_H_OFFS		(CIF_ISP_BASE + 0x00000114)
> +#define CIF_ISP_AWB_WND_V_OFFS		(CIF_ISP_BASE + 0x00000118)
> +#define CIF_ISP_AWB_WND_H_SIZE		(CIF_ISP_BASE + 0x0000011C)
> +#define CIF_ISP_AWB_WND_V_SIZE		(CIF_ISP_BASE + 0x00000120)
> +#define CIF_ISP_AWB_FRAMES		(CIF_ISP_BASE + 0x00000124)
> +#define CIF_ISP_AWB_REF			(CIF_ISP_BASE + 0x00000128)
> +#define CIF_ISP_AWB_THRESH		(CIF_ISP_BASE + 0x0000012C)
> +#define CIF_ISP_AWB_GAIN_G		(CIF_ISP_BASE + 0x00000138)
> +#define CIF_ISP_AWB_GAIN_RB		(CIF_ISP_BASE + 0x0000013C)
> +#define CIF_ISP_AWB_WHITE_CNT		(CIF_ISP_BASE + 0x00000140)
> +#define CIF_ISP_AWB_MEAN		(CIF_ISP_BASE + 0x00000144)
> +#define CIF_ISP_CC_COEFF_0		(CIF_ISP_BASE + 0x00000170)
> +#define CIF_ISP_CC_COEFF_1		(CIF_ISP_BASE + 0x00000174)
> +#define CIF_ISP_CC_COEFF_2		(CIF_ISP_BASE + 0x00000178)
> +#define CIF_ISP_CC_COEFF_3		(CIF_ISP_BASE + 0x0000017C)
> +#define CIF_ISP_CC_COEFF_4		(CIF_ISP_BASE + 0x00000180)
> +#define CIF_ISP_CC_COEFF_5		(CIF_ISP_BASE + 0x00000184)
> +#define CIF_ISP_CC_COEFF_6		(CIF_ISP_BASE + 0x00000188)
> +#define CIF_ISP_CC_COEFF_7		(CIF_ISP_BASE + 0x0000018C)
> +#define CIF_ISP_CC_COEFF_8		(CIF_ISP_BASE + 0x00000190)
> +#define CIF_ISP_OUT_H_OFFS		(CIF_ISP_BASE + 0x00000194)
> +#define CIF_ISP_OUT_V_OFFS		(CIF_ISP_BASE + 0x00000198)
> +#define CIF_ISP_OUT_H_SIZE		(CIF_ISP_BASE + 0x0000019C)
> +#define CIF_ISP_OUT_V_SIZE		(CIF_ISP_BASE + 0x000001A0)
> +#define CIF_ISP_DEMOSAIC		(CIF_ISP_BASE + 0x000001A4)
> +#define CIF_ISP_FLAGS_SHD		(CIF_ISP_BASE + 0x000001A8)
> +#define CIF_ISP_OUT_H_OFFS_SHD		(CIF_ISP_BASE + 0x000001AC)
> +#define CIF_ISP_OUT_V_OFFS_SHD		(CIF_ISP_BASE + 0x000001B0)
> +#define CIF_ISP_OUT_H_SIZE_SHD		(CIF_ISP_BASE + 0x000001B4)
> +#define CIF_ISP_OUT_V_SIZE_SHD		(CIF_ISP_BASE + 0x000001B8)
> +#define CIF_ISP_IMSC			(CIF_ISP_BASE + 0x000001BC)
> +#define CIF_ISP_RIS			(CIF_ISP_BASE + 0x000001C0)
> +#define CIF_ISP_MIS			(CIF_ISP_BASE + 0x000001C4)
> +#define CIF_ISP_ICR			(CIF_ISP_BASE + 0x000001C8)
> +#define CIF_ISP_ISR			(CIF_ISP_BASE + 0x000001CC)
> +#define CIF_ISP_CT_COEFF_0		(CIF_ISP_BASE + 0x000001D0)
> +#define CIF_ISP_CT_COEFF_1		(CIF_ISP_BASE + 0x000001D4)
> +#define CIF_ISP_CT_COEFF_2		(CIF_ISP_BASE + 0x000001D8)
> +#define CIF_ISP_CT_COEFF_3		(CIF_ISP_BASE + 0x000001DC)
> +#define CIF_ISP_CT_COEFF_4		(CIF_ISP_BASE + 0x000001E0)
> +#define CIF_ISP_CT_COEFF_5		(CIF_ISP_BASE + 0x000001E4)
> +#define CIF_ISP_CT_COEFF_6		(CIF_ISP_BASE + 0x000001E8)
> +#define CIF_ISP_CT_COEFF_7		(CIF_ISP_BASE + 0x000001EC)
> +#define CIF_ISP_CT_COEFF_8		(CIF_ISP_BASE + 0x000001F0)
> +#define CIF_ISP_GAMMA_OUT_MODE		(CIF_ISP_BASE + 0x000001F4)
> +#define CIF_ISP_GAMMA_OUT_Y_0		(CIF_ISP_BASE + 0x000001F8)
> +#define CIF_ISP_GAMMA_OUT_Y_1		(CIF_ISP_BASE + 0x000001FC)
> +#define CIF_ISP_GAMMA_OUT_Y_2		(CIF_ISP_BASE + 0x00000200)
> +#define CIF_ISP_GAMMA_OUT_Y_3		(CIF_ISP_BASE + 0x00000204)
> +#define CIF_ISP_GAMMA_OUT_Y_4		(CIF_ISP_BASE + 0x00000208)
> +#define CIF_ISP_GAMMA_OUT_Y_5		(CIF_ISP_BASE + 0x0000020C)
> +#define CIF_ISP_GAMMA_OUT_Y_6		(CIF_ISP_BASE + 0x00000210)
> +#define CIF_ISP_GAMMA_OUT_Y_7		(CIF_ISP_BASE + 0x00000214)
> +#define CIF_ISP_GAMMA_OUT_Y_8		(CIF_ISP_BASE + 0x00000218)
> +#define CIF_ISP_GAMMA_OUT_Y_9		(CIF_ISP_BASE + 0x0000021C)
> +#define CIF_ISP_GAMMA_OUT_Y_10		(CIF_ISP_BASE + 0x00000220)
> +#define CIF_ISP_GAMMA_OUT_Y_11		(CIF_ISP_BASE + 0x00000224)
> +#define CIF_ISP_GAMMA_OUT_Y_12		(CIF_ISP_BASE + 0x00000228)
> +#define CIF_ISP_GAMMA_OUT_Y_13		(CIF_ISP_BASE + 0x0000022C)
> +#define CIF_ISP_GAMMA_OUT_Y_14		(CIF_ISP_BASE + 0x00000230)
> +#define CIF_ISP_GAMMA_OUT_Y_15		(CIF_ISP_BASE + 0x00000234)
> +#define CIF_ISP_GAMMA_OUT_Y_16		(CIF_ISP_BASE + 0x00000238)
> +#define CIF_ISP_ERR			(CIF_ISP_BASE + 0x0000023C)
> +#define CIF_ISP_ERR_CLR			(CIF_ISP_BASE + 0x00000240)
> +#define CIF_ISP_FRAME_COUNT		(CIF_ISP_BASE + 0x00000244)
> +#define CIF_ISP_CT_OFFSET_R		(CIF_ISP_BASE + 0x00000248)
> +#define CIF_ISP_CT_OFFSET_G		(CIF_ISP_BASE + 0x0000024C)
> +#define CIF_ISP_CT_OFFSET_B		(CIF_ISP_BASE + 0x00000250)
> +
> +#define CIF_ISP_FLASH_BASE		0x00000660
> +#define CIF_ISP_FLASH_CMD		(CIF_ISP_FLASH_BASE + 0x00000000)
> +#define CIF_ISP_FLASH_CONFIG		(CIF_ISP_FLASH_BASE + 0x00000004)
> +#define CIF_ISP_FLASH_PREDIV		(CIF_ISP_FLASH_BASE + 0x00000008)
> +#define CIF_ISP_FLASH_DELAY		(CIF_ISP_FLASH_BASE + 0x0000000C)
> +#define CIF_ISP_FLASH_TIME		(CIF_ISP_FLASH_BASE + 0x00000010)
> +#define CIF_ISP_FLASH_MAXP		(CIF_ISP_FLASH_BASE + 0x00000014)
> +
> +#define CIF_ISP_SH_BASE			0x00000680
> +#define CIF_ISP_SH_CTRL			(CIF_ISP_SH_BASE + 0x00000000)
> +#define CIF_ISP_SH_PREDIV		(CIF_ISP_SH_BASE + 0x00000004)
> +#define CIF_ISP_SH_DELAY		(CIF_ISP_SH_BASE + 0x00000008)
> +#define CIF_ISP_SH_TIME			(CIF_ISP_SH_BASE + 0x0000000C)
> +
> +#define CIF_C_PROC_BASE			0x00000800
> +#define CIF_C_PROC_CTRL			(CIF_C_PROC_BASE + 0x00000000)
> +#define CIF_C_PROC_CONTRAST		(CIF_C_PROC_BASE + 0x00000004)
> +#define CIF_C_PROC_BRIGHTNESS		(CIF_C_PROC_BASE + 0x00000008)
> +#define CIF_C_PROC_SATURATION		(CIF_C_PROC_BASE + 0x0000000C)
> +#define CIF_C_PROC_HUE			(CIF_C_PROC_BASE + 0x00000010)
> +
> +#define CIF_DUAL_CROP_BASE		0x00000880
> +#define CIF_DUAL_CROP_CTRL		(CIF_DUAL_CROP_BASE + 0x00000000)
> +#define CIF_DUAL_CROP_M_H_OFFS		(CIF_DUAL_CROP_BASE + 0x00000004)
> +#define CIF_DUAL_CROP_M_V_OFFS		(CIF_DUAL_CROP_BASE + 0x00000008)
> +#define CIF_DUAL_CROP_M_H_SIZE		(CIF_DUAL_CROP_BASE + 0x0000000C)
> +#define CIF_DUAL_CROP_M_V_SIZE		(CIF_DUAL_CROP_BASE + 0x00000010)
> +#define CIF_DUAL_CROP_S_H_OFFS		(CIF_DUAL_CROP_BASE + 0x00000014)
> +#define CIF_DUAL_CROP_S_V_OFFS		(CIF_DUAL_CROP_BASE + 0x00000018)
> +#define CIF_DUAL_CROP_S_H_SIZE		(CIF_DUAL_CROP_BASE + 0x0000001C)
> +#define CIF_DUAL_CROP_S_V_SIZE		(CIF_DUAL_CROP_BASE + 0x00000020)
> +#define CIF_DUAL_CROP_M_H_OFFS_SHD	(CIF_DUAL_CROP_BASE + 0x00000024)
> +#define CIF_DUAL_CROP_M_V_OFFS_SHD	(CIF_DUAL_CROP_BASE + 0x00000028)
> +#define CIF_DUAL_CROP_M_H_SIZE_SHD	(CIF_DUAL_CROP_BASE + 0x0000002C)
> +#define CIF_DUAL_CROP_M_V_SIZE_SHD	(CIF_DUAL_CROP_BASE + 0x00000030)
> +#define CIF_DUAL_CROP_S_H_OFFS_SHD	(CIF_DUAL_CROP_BASE + 0x00000034)
> +#define CIF_DUAL_CROP_S_V_OFFS_SHD	(CIF_DUAL_CROP_BASE + 0x00000038)
> +#define CIF_DUAL_CROP_S_H_SIZE_SHD	(CIF_DUAL_CROP_BASE + 0x0000003C)
> +#define CIF_DUAL_CROP_S_V_SIZE_SHD	(CIF_DUAL_CROP_BASE + 0x00000040)
> +
> +#define CIF_MRSZ_BASE			0x00000C00
> +#define CIF_MRSZ_CTRL			(CIF_MRSZ_BASE + 0x00000000)
> +#define CIF_MRSZ_SCALE_HY		(CIF_MRSZ_BASE + 0x00000004)
> +#define CIF_MRSZ_SCALE_HCB		(CIF_MRSZ_BASE + 0x00000008)
> +#define CIF_MRSZ_SCALE_HCR		(CIF_MRSZ_BASE + 0x0000000C)
> +#define CIF_MRSZ_SCALE_VY		(CIF_MRSZ_BASE + 0x00000010)
> +#define CIF_MRSZ_SCALE_VC		(CIF_MRSZ_BASE + 0x00000014)
> +#define CIF_MRSZ_PHASE_HY		(CIF_MRSZ_BASE + 0x00000018)
> +#define CIF_MRSZ_PHASE_HC		(CIF_MRSZ_BASE + 0x0000001C)
> +#define CIF_MRSZ_PHASE_VY		(CIF_MRSZ_BASE + 0x00000020)
> +#define CIF_MRSZ_PHASE_VC		(CIF_MRSZ_BASE + 0x00000024)
> +#define CIF_MRSZ_SCALE_LUT_ADDR		(CIF_MRSZ_BASE + 0x00000028)
> +#define CIF_MRSZ_SCALE_LUT		(CIF_MRSZ_BASE + 0x0000002C)
> +#define CIF_MRSZ_CTRL_SHD		(CIF_MRSZ_BASE + 0x00000030)
> +#define CIF_MRSZ_SCALE_HY_SHD		(CIF_MRSZ_BASE + 0x00000034)
> +#define CIF_MRSZ_SCALE_HCB_SHD		(CIF_MRSZ_BASE + 0x00000038)
> +#define CIF_MRSZ_SCALE_HCR_SHD		(CIF_MRSZ_BASE + 0x0000003C)
> +#define CIF_MRSZ_SCALE_VY_SHD		(CIF_MRSZ_BASE + 0x00000040)
> +#define CIF_MRSZ_SCALE_VC_SHD		(CIF_MRSZ_BASE + 0x00000044)
> +#define CIF_MRSZ_PHASE_HY_SHD		(CIF_MRSZ_BASE + 0x00000048)
> +#define CIF_MRSZ_PHASE_HC_SHD		(CIF_MRSZ_BASE + 0x0000004C)
> +#define CIF_MRSZ_PHASE_VY_SHD		(CIF_MRSZ_BASE + 0x00000050)
> +#define CIF_MRSZ_PHASE_VC_SHD		(CIF_MRSZ_BASE + 0x00000054)
> +
> +#define CIF_SRSZ_BASE			0x00001000
> +#define CIF_SRSZ_CTRL			(CIF_SRSZ_BASE + 0x00000000)
> +#define CIF_SRSZ_SCALE_HY		(CIF_SRSZ_BASE + 0x00000004)
> +#define CIF_SRSZ_SCALE_HCB		(CIF_SRSZ_BASE + 0x00000008)
> +#define CIF_SRSZ_SCALE_HCR		(CIF_SRSZ_BASE + 0x0000000C)
> +#define CIF_SRSZ_SCALE_VY		(CIF_SRSZ_BASE + 0x00000010)
> +#define CIF_SRSZ_SCALE_VC		(CIF_SRSZ_BASE + 0x00000014)
> +#define CIF_SRSZ_PHASE_HY		(CIF_SRSZ_BASE + 0x00000018)
> +#define CIF_SRSZ_PHASE_HC		(CIF_SRSZ_BASE + 0x0000001C)
> +#define CIF_SRSZ_PHASE_VY		(CIF_SRSZ_BASE + 0x00000020)
> +#define CIF_SRSZ_PHASE_VC		(CIF_SRSZ_BASE + 0x00000024)
> +#define CIF_SRSZ_SCALE_LUT_ADDR		(CIF_SRSZ_BASE + 0x00000028)
> +#define CIF_SRSZ_SCALE_LUT		(CIF_SRSZ_BASE + 0x0000002C)
> +#define CIF_SRSZ_CTRL_SHD		(CIF_SRSZ_BASE + 0x00000030)
> +#define CIF_SRSZ_SCALE_HY_SHD		(CIF_SRSZ_BASE + 0x00000034)
> +#define CIF_SRSZ_SCALE_HCB_SHD		(CIF_SRSZ_BASE + 0x00000038)
> +#define CIF_SRSZ_SCALE_HCR_SHD		(CIF_SRSZ_BASE + 0x0000003C)
> +#define CIF_SRSZ_SCALE_VY_SHD		(CIF_SRSZ_BASE + 0x00000040)
> +#define CIF_SRSZ_SCALE_VC_SHD		(CIF_SRSZ_BASE + 0x00000044)
> +#define CIF_SRSZ_PHASE_HY_SHD		(CIF_SRSZ_BASE + 0x00000048)
> +#define CIF_SRSZ_PHASE_HC_SHD		(CIF_SRSZ_BASE + 0x0000004C)
> +#define CIF_SRSZ_PHASE_VY_SHD		(CIF_SRSZ_BASE + 0x00000050)
> +#define CIF_SRSZ_PHASE_VC_SHD		(CIF_SRSZ_BASE + 0x00000054)
> +
> +#define CIF_MI_BASE			0x00001400
> +#define CIF_MI_CTRL			(CIF_MI_BASE + 0x00000000)
> +#define CIF_MI_INIT			(CIF_MI_BASE + 0x00000004)
> +#define CIF_MI_MP_Y_BASE_AD_INIT	(CIF_MI_BASE + 0x00000008)
> +#define CIF_MI_MP_Y_SIZE_INIT		(CIF_MI_BASE + 0x0000000C)
> +#define CIF_MI_MP_Y_OFFS_CNT_INIT	(CIF_MI_BASE + 0x00000010)
> +#define CIF_MI_MP_Y_OFFS_CNT_START	(CIF_MI_BASE + 0x00000014)
> +#define CIF_MI_MP_Y_IRQ_OFFS_INIT	(CIF_MI_BASE + 0x00000018)
> +#define CIF_MI_MP_CB_BASE_AD_INIT	(CIF_MI_BASE + 0x0000001C)
> +#define CIF_MI_MP_CB_SIZE_INIT		(CIF_MI_BASE + 0x00000020)
> +#define CIF_MI_MP_CB_OFFS_CNT_INIT	(CIF_MI_BASE + 0x00000024)
> +#define CIF_MI_MP_CB_OFFS_CNT_START	(CIF_MI_BASE + 0x00000028)
> +#define CIF_MI_MP_CR_BASE_AD_INIT	(CIF_MI_BASE + 0x0000002C)
> +#define CIF_MI_MP_CR_SIZE_INIT		(CIF_MI_BASE + 0x00000030)
> +#define CIF_MI_MP_CR_OFFS_CNT_INIT	(CIF_MI_BASE + 0x00000034)
> +#define CIF_MI_MP_CR_OFFS_CNT_START	(CIF_MI_BASE + 0x00000038)
> +#define CIF_MI_SP_Y_BASE_AD_INIT	(CIF_MI_BASE + 0x0000003C)
> +#define CIF_MI_SP_Y_SIZE_INIT		(CIF_MI_BASE + 0x00000040)
> +#define CIF_MI_SP_Y_OFFS_CNT_INIT	(CIF_MI_BASE + 0x00000044)
> +#define CIF_MI_SP_Y_OFFS_CNT_START	(CIF_MI_BASE + 0x00000048)
> +#define CIF_MI_SP_Y_LLENGTH		(CIF_MI_BASE + 0x0000004C)
> +#define CIF_MI_SP_CB_BASE_AD_INIT	(CIF_MI_BASE + 0x00000050)
> +#define CIF_MI_SP_CB_SIZE_INIT		(CIF_MI_BASE + 0x00000054)
> +#define CIF_MI_SP_CB_OFFS_CNT_INIT	(CIF_MI_BASE + 0x00000058)
> +#define CIF_MI_SP_CB_OFFS_CNT_START	(CIF_MI_BASE + 0x0000005C)
> +#define CIF_MI_SP_CR_BASE_AD_INIT	(CIF_MI_BASE + 0x00000060)
> +#define CIF_MI_SP_CR_SIZE_INIT		(CIF_MI_BASE + 0x00000064)
> +#define CIF_MI_SP_CR_OFFS_CNT_INIT	(CIF_MI_BASE + 0x00000068)
> +#define CIF_MI_SP_CR_OFFS_CNT_START	(CIF_MI_BASE + 0x0000006C)
> +#define CIF_MI_BYTE_CNT			(CIF_MI_BASE + 0x00000070)
> +#define CIF_MI_CTRL_SHD			(CIF_MI_BASE + 0x00000074)
> +#define CIF_MI_MP_Y_BASE_AD_SHD		(CIF_MI_BASE + 0x00000078)
> +#define CIF_MI_MP_Y_SIZE_SHD		(CIF_MI_BASE + 0x0000007C)
> +#define CIF_MI_MP_Y_OFFS_CNT_SHD	(CIF_MI_BASE + 0x00000080)
> +#define CIF_MI_MP_Y_IRQ_OFFS_SHD	(CIF_MI_BASE + 0x00000084)
> +#define CIF_MI_MP_CB_BASE_AD_SHD	(CIF_MI_BASE + 0x00000088)
> +#define CIF_MI_MP_CB_SIZE_SHD		(CIF_MI_BASE + 0x0000008C)
> +#define CIF_MI_MP_CB_OFFS_CNT_SHD	(CIF_MI_BASE + 0x00000090)
> +#define CIF_MI_MP_CR_BASE_AD_SHD	(CIF_MI_BASE + 0x00000094)
> +#define CIF_MI_MP_CR_SIZE_SHD		(CIF_MI_BASE + 0x00000098)
> +#define CIF_MI_MP_CR_OFFS_CNT_SHD	(CIF_MI_BASE + 0x0000009C)
> +#define CIF_MI_SP_Y_BASE_AD_SHD		(CIF_MI_BASE + 0x000000A0)
> +#define CIF_MI_SP_Y_SIZE_SHD		(CIF_MI_BASE + 0x000000A4)
> +#define CIF_MI_SP_Y_OFFS_CNT_SHD	(CIF_MI_BASE + 0x000000A8)
> +#define CIF_MI_SP_CB_BASE_AD_SHD	(CIF_MI_BASE + 0x000000B0)
> +#define CIF_MI_SP_CB_SIZE_SHD		(CIF_MI_BASE + 0x000000B4)
> +#define CIF_MI_SP_CB_OFFS_CNT_SHD	(CIF_MI_BASE + 0x000000B8)
> +#define CIF_MI_SP_CR_BASE_AD_SHD	(CIF_MI_BASE + 0x000000BC)
> +#define CIF_MI_SP_CR_SIZE_SHD		(CIF_MI_BASE + 0x000000C0)
> +#define CIF_MI_SP_CR_OFFS_CNT_SHD	(CIF_MI_BASE + 0x000000C4)
> +#define CIF_MI_DMA_Y_PIC_START_AD	(CIF_MI_BASE + 0x000000C8)
> +#define CIF_MI_DMA_Y_PIC_WIDTH		(CIF_MI_BASE + 0x000000CC)
> +#define CIF_MI_DMA_Y_LLENGTH		(CIF_MI_BASE + 0x000000D0)
> +#define CIF_MI_DMA_Y_PIC_SIZE		(CIF_MI_BASE + 0x000000D4)
> +#define CIF_MI_DMA_CB_PIC_START_AD	(CIF_MI_BASE + 0x000000D8)
> +#define CIF_MI_DMA_CR_PIC_START_AD	(CIF_MI_BASE + 0x000000E8)
> +#define CIF_MI_IMSC			(CIF_MI_BASE + 0x000000F8)
> +#define CIF_MI_RIS			(CIF_MI_BASE + 0x000000FC)
> +#define CIF_MI_MIS			(CIF_MI_BASE + 0x00000100)
> +#define CIF_MI_ICR			(CIF_MI_BASE + 0x00000104)
> +#define CIF_MI_ISR			(CIF_MI_BASE + 0x00000108)
> +#define CIF_MI_STATUS			(CIF_MI_BASE + 0x0000010C)
> +#define CIF_MI_STATUS_CLR		(CIF_MI_BASE + 0x00000110)
> +#define CIF_MI_SP_Y_PIC_WIDTH		(CIF_MI_BASE + 0x00000114)
> +#define CIF_MI_SP_Y_PIC_HEIGHT		(CIF_MI_BASE + 0x00000118)
> +#define CIF_MI_SP_Y_PIC_SIZE		(CIF_MI_BASE + 0x0000011C)
> +#define CIF_MI_DMA_CTRL			(CIF_MI_BASE + 0x00000120)
> +#define CIF_MI_DMA_START		(CIF_MI_BASE + 0x00000124)
> +#define CIF_MI_DMA_STATUS		(CIF_MI_BASE + 0x00000128)
> +#define CIF_MI_PIXEL_COUNT		(CIF_MI_BASE + 0x0000012C)
> +#define CIF_MI_MP_Y_BASE_AD_INIT2	(CIF_MI_BASE + 0x00000130)
> +#define CIF_MI_MP_CB_BASE_AD_INIT2	(CIF_MI_BASE + 0x00000134)
> +#define CIF_MI_MP_CR_BASE_AD_INIT2	(CIF_MI_BASE + 0x00000138)
> +#define CIF_MI_SP_Y_BASE_AD_INIT2	(CIF_MI_BASE + 0x0000013C)
> +#define CIF_MI_SP_CB_BASE_AD_INIT2	(CIF_MI_BASE + 0x00000140)
> +#define CIF_MI_SP_CR_BASE_AD_INIT2	(CIF_MI_BASE + 0x00000144)
> +#define CIF_MI_XTD_FORMAT_CTRL		(CIF_MI_BASE + 0x00000148)
> +
> +#define CIF_SMIA_BASE			0x00001A00
> +#define CIF_SMIA_CTRL			(CIF_SMIA_BASE + 0x00000000)
> +#define CIF_SMIA_STATUS			(CIF_SMIA_BASE + 0x00000004)
> +#define CIF_SMIA_IMSC			(CIF_SMIA_BASE + 0x00000008)
> +#define CIF_SMIA_RIS			(CIF_SMIA_BASE + 0x0000000C)
> +#define CIF_SMIA_MIS			(CIF_SMIA_BASE + 0x00000010)
> +#define CIF_SMIA_ICR			(CIF_SMIA_BASE + 0x00000014)
> +#define CIF_SMIA_ISR			(CIF_SMIA_BASE + 0x00000018)
> +#define CIF_SMIA_DATA_FORMAT_SEL	(CIF_SMIA_BASE + 0x0000001C)
> +#define CIF_SMIA_SOF_EMB_DATA_LINES	(CIF_SMIA_BASE + 0x00000020)
> +#define CIF_SMIA_EMB_HSTART		(CIF_SMIA_BASE + 0x00000024)
> +#define CIF_SMIA_EMB_HSIZE		(CIF_SMIA_BASE + 0x00000028)
> +#define CIF_SMIA_EMB_VSTART		(CIF_SMIA_BASE + 0x0000002c)
> +#define CIF_SMIA_NUM_LINES		(CIF_SMIA_BASE + 0x00000030)
> +#define CIF_SMIA_EMB_DATA_FIFO		(CIF_SMIA_BASE + 0x00000034)
> +#define CIF_SMIA_EMB_DATA_WATERMARK	(CIF_SMIA_BASE + 0x00000038)
> +
> +#define CIF_MIPI_BASE			0x00001C00
> +#define CIF_MIPI_CTRL			(CIF_MIPI_BASE + 0x00000000)
> +#define CIF_MIPI_STATUS			(CIF_MIPI_BASE + 0x00000004)
> +#define CIF_MIPI_IMSC			(CIF_MIPI_BASE + 0x00000008)
> +#define CIF_MIPI_RIS			(CIF_MIPI_BASE + 0x0000000C)
> +#define CIF_MIPI_MIS			(CIF_MIPI_BASE + 0x00000010)
> +#define CIF_MIPI_ICR			(CIF_MIPI_BASE + 0x00000014)
> +#define CIF_MIPI_ISR			(CIF_MIPI_BASE + 0x00000018)
> +#define CIF_MIPI_CUR_DATA_ID		(CIF_MIPI_BASE + 0x0000001C)
> +#define CIF_MIPI_IMG_DATA_SEL		(CIF_MIPI_BASE + 0x00000020)
> +#define CIF_MIPI_ADD_DATA_SEL_1		(CIF_MIPI_BASE + 0x00000024)
> +#define CIF_MIPI_ADD_DATA_SEL_2		(CIF_MIPI_BASE + 0x00000028)
> +#define CIF_MIPI_ADD_DATA_SEL_3		(CIF_MIPI_BASE + 0x0000002C)
> +#define CIF_MIPI_ADD_DATA_SEL_4		(CIF_MIPI_BASE + 0x00000030)
> +#define CIF_MIPI_ADD_DATA_FIFO		(CIF_MIPI_BASE + 0x00000034)
> +#define CIF_MIPI_FIFO_FILL_LEVEL	(CIF_MIPI_BASE + 0x00000038)
> +#define CIF_MIPI_COMPRESSED_MODE	(CIF_MIPI_BASE + 0x0000003C)
> +#define CIF_MIPI_FRAME			(CIF_MIPI_BASE + 0x00000040)
> +#define CIF_MIPI_GEN_SHORT_DT		(CIF_MIPI_BASE + 0x00000044)
> +#define CIF_MIPI_GEN_SHORT_8_9		(CIF_MIPI_BASE + 0x00000048)
> +#define CIF_MIPI_GEN_SHORT_A_B		(CIF_MIPI_BASE + 0x0000004C)
> +#define CIF_MIPI_GEN_SHORT_C_D		(CIF_MIPI_BASE + 0x00000050)
> +#define CIF_MIPI_GEN_SHORT_E_F		(CIF_MIPI_BASE + 0x00000054)
> +
> +#define CIF_ISP_AFM_BASE		0x00002000
> +#define CIF_ISP_AFM_CTRL		(CIF_ISP_AFM_BASE + 0x00000000)
> +#define CIF_ISP_AFM_LT_A		(CIF_ISP_AFM_BASE + 0x00000004)
> +#define CIF_ISP_AFM_RB_A		(CIF_ISP_AFM_BASE + 0x00000008)
> +#define CIF_ISP_AFM_LT_B		(CIF_ISP_AFM_BASE + 0x0000000C)
> +#define CIF_ISP_AFM_RB_B		(CIF_ISP_AFM_BASE + 0x00000010)
> +#define CIF_ISP_AFM_LT_C		(CIF_ISP_AFM_BASE + 0x00000014)
> +#define CIF_ISP_AFM_RB_C		(CIF_ISP_AFM_BASE + 0x00000018)
> +#define CIF_ISP_AFM_THRES		(CIF_ISP_AFM_BASE + 0x0000001C)
> +#define CIF_ISP_AFM_VAR_SHIFT		(CIF_ISP_AFM_BASE + 0x00000020)
> +#define CIF_ISP_AFM_SUM_A		(CIF_ISP_AFM_BASE + 0x00000024)
> +#define CIF_ISP_AFM_SUM_B		(CIF_ISP_AFM_BASE + 0x00000028)
> +#define CIF_ISP_AFM_SUM_C		(CIF_ISP_AFM_BASE + 0x0000002C)
> +#define CIF_ISP_AFM_LUM_A		(CIF_ISP_AFM_BASE + 0x00000030)
> +#define CIF_ISP_AFM_LUM_B		(CIF_ISP_AFM_BASE + 0x00000034)
> +#define CIF_ISP_AFM_LUM_C		(CIF_ISP_AFM_BASE + 0x00000038)
> +
> +#define CIF_ISP_LSC_BASE		0x00002200
> +#define CIF_ISP_LSC_CTRL		(CIF_ISP_LSC_BASE + 0x00000000)
> +#define CIF_ISP_LSC_R_TABLE_ADDR	(CIF_ISP_LSC_BASE + 0x00000004)
> +#define CIF_ISP_LSC_GR_TABLE_ADDR	(CIF_ISP_LSC_BASE + 0x00000008)
> +#define CIF_ISP_LSC_B_TABLE_ADDR	(CIF_ISP_LSC_BASE + 0x0000000C)
> +#define CIF_ISP_LSC_GB_TABLE_ADDR	(CIF_ISP_LSC_BASE + 0x00000010)
> +#define CIF_ISP_LSC_R_TABLE_DATA	(CIF_ISP_LSC_BASE + 0x00000014)
> +#define CIF_ISP_LSC_GR_TABLE_DATA	(CIF_ISP_LSC_BASE + 0x00000018)
> +#define CIF_ISP_LSC_B_TABLE_DATA	(CIF_ISP_LSC_BASE + 0x0000001C)
> +#define CIF_ISP_LSC_GB_TABLE_DATA	(CIF_ISP_LSC_BASE + 0x00000020)
> +#define CIF_ISP_LSC_XGRAD_01		(CIF_ISP_LSC_BASE + 0x00000024)
> +#define CIF_ISP_LSC_XGRAD_23		(CIF_ISP_LSC_BASE + 0x00000028)
> +#define CIF_ISP_LSC_XGRAD_45		(CIF_ISP_LSC_BASE + 0x0000002C)
> +#define CIF_ISP_LSC_XGRAD_67		(CIF_ISP_LSC_BASE + 0x00000030)
> +#define CIF_ISP_LSC_YGRAD_01		(CIF_ISP_LSC_BASE + 0x00000034)
> +#define CIF_ISP_LSC_YGRAD_23		(CIF_ISP_LSC_BASE + 0x00000038)
> +#define CIF_ISP_LSC_YGRAD_45		(CIF_ISP_LSC_BASE + 0x0000003C)
> +#define CIF_ISP_LSC_YGRAD_67		(CIF_ISP_LSC_BASE + 0x00000040)
> +#define CIF_ISP_LSC_XSIZE_01		(CIF_ISP_LSC_BASE + 0x00000044)
> +#define CIF_ISP_LSC_XSIZE_23		(CIF_ISP_LSC_BASE + 0x00000048)
> +#define CIF_ISP_LSC_XSIZE_45		(CIF_ISP_LSC_BASE + 0x0000004C)
> +#define CIF_ISP_LSC_XSIZE_67		(CIF_ISP_LSC_BASE + 0x00000050)
> +#define CIF_ISP_LSC_YSIZE_01		(CIF_ISP_LSC_BASE + 0x00000054)
> +#define CIF_ISP_LSC_YSIZE_23		(CIF_ISP_LSC_BASE + 0x00000058)
> +#define CIF_ISP_LSC_YSIZE_45		(CIF_ISP_LSC_BASE + 0x0000005C)
> +#define CIF_ISP_LSC_YSIZE_67		(CIF_ISP_LSC_BASE + 0x00000060)
> +#define CIF_ISP_LSC_TABLE_SEL		(CIF_ISP_LSC_BASE + 0x00000064)
> +#define CIF_ISP_LSC_STATUS		(CIF_ISP_LSC_BASE + 0x00000068)
> +
> +#define CIF_ISP_IS_BASE			0x00002300
> +#define CIF_ISP_IS_CTRL			(CIF_ISP_IS_BASE + 0x00000000)
> +#define CIF_ISP_IS_RECENTER		(CIF_ISP_IS_BASE + 0x00000004)
> +#define CIF_ISP_IS_H_OFFS		(CIF_ISP_IS_BASE + 0x00000008)
> +#define CIF_ISP_IS_V_OFFS		(CIF_ISP_IS_BASE + 0x0000000C)
> +#define CIF_ISP_IS_H_SIZE		(CIF_ISP_IS_BASE + 0x00000010)
> +#define CIF_ISP_IS_V_SIZE		(CIF_ISP_IS_BASE + 0x00000014)
> +#define CIF_ISP_IS_MAX_DX		(CIF_ISP_IS_BASE + 0x00000018)
> +#define CIF_ISP_IS_MAX_DY		(CIF_ISP_IS_BASE + 0x0000001C)
> +#define CIF_ISP_IS_DISPLACE		(CIF_ISP_IS_BASE + 0x00000020)
> +#define CIF_ISP_IS_H_OFFS_SHD		(CIF_ISP_IS_BASE + 0x00000024)
> +#define CIF_ISP_IS_V_OFFS_SHD		(CIF_ISP_IS_BASE + 0x00000028)
> +#define CIF_ISP_IS_H_SIZE_SHD		(CIF_ISP_IS_BASE + 0x0000002C)
> +#define CIF_ISP_IS_V_SIZE_SHD		(CIF_ISP_IS_BASE + 0x00000030)
> +
> +#define CIF_ISP_HIST_BASE		0x00002400
> +
> +#define CIF_ISP_HIST_PROP		(CIF_ISP_HIST_BASE + 0x00000000)
> +#define CIF_ISP_HIST_H_OFFS		(CIF_ISP_HIST_BASE + 0x00000004)
> +#define CIF_ISP_HIST_V_OFFS		(CIF_ISP_HIST_BASE + 0x00000008)
> +#define CIF_ISP_HIST_H_SIZE		(CIF_ISP_HIST_BASE + 0x0000000C)
> +#define CIF_ISP_HIST_V_SIZE		(CIF_ISP_HIST_BASE + 0x00000010)
> +#define CIF_ISP_HIST_BIN_0		(CIF_ISP_HIST_BASE + 0x00000014)
> +#define CIF_ISP_HIST_BIN_1		(CIF_ISP_HIST_BASE + 0x00000018)
> +#define CIF_ISP_HIST_BIN_2		(CIF_ISP_HIST_BASE + 0x0000001C)
> +#define CIF_ISP_HIST_BIN_3		(CIF_ISP_HIST_BASE + 0x00000020)
> +#define CIF_ISP_HIST_BIN_4		(CIF_ISP_HIST_BASE + 0x00000024)
> +#define CIF_ISP_HIST_BIN_5		(CIF_ISP_HIST_BASE + 0x00000028)
> +#define CIF_ISP_HIST_BIN_6		(CIF_ISP_HIST_BASE + 0x0000002C)
> +#define CIF_ISP_HIST_BIN_7		(CIF_ISP_HIST_BASE + 0x00000030)
> +#define CIF_ISP_HIST_BIN_8		(CIF_ISP_HIST_BASE + 0x00000034)
> +#define CIF_ISP_HIST_BIN_9		(CIF_ISP_HIST_BASE + 0x00000038)
> +#define CIF_ISP_HIST_BIN_10		(CIF_ISP_HIST_BASE + 0x0000003C)
> +#define CIF_ISP_HIST_BIN_11		(CIF_ISP_HIST_BASE + 0x00000040)
> +#define CIF_ISP_HIST_BIN_12		(CIF_ISP_HIST_BASE + 0x00000044)
> +#define CIF_ISP_HIST_BIN_13		(CIF_ISP_HIST_BASE + 0x00000048)
> +#define CIF_ISP_HIST_BIN_14		(CIF_ISP_HIST_BASE + 0x0000004C)
> +#define CIF_ISP_HIST_BIN_15		(CIF_ISP_HIST_BASE + 0x00000050)
> +#define CIF_ISP_HIST_WEIGHT_00TO30	(CIF_ISP_HIST_BASE + 0x00000054)
> +#define CIF_ISP_HIST_WEIGHT_40TO21	(CIF_ISP_HIST_BASE + 0x00000058)
> +#define CIF_ISP_HIST_WEIGHT_31TO12	(CIF_ISP_HIST_BASE + 0x0000005C)
> +#define CIF_ISP_HIST_WEIGHT_22TO03	(CIF_ISP_HIST_BASE + 0x00000060)
> +#define CIF_ISP_HIST_WEIGHT_13TO43	(CIF_ISP_HIST_BASE + 0x00000064)
> +#define CIF_ISP_HIST_WEIGHT_04TO34	(CIF_ISP_HIST_BASE + 0x00000068)
> +#define CIF_ISP_HIST_WEIGHT_44		(CIF_ISP_HIST_BASE + 0x0000006C)
> +
> +#define CIF_ISP_FILT_BASE		0x00002500
> +#define CIF_ISP_FILT_MODE		(CIF_ISP_FILT_BASE + 0x00000000)
> +#define CIF_ISP_FILT_THRESH_BL0		(CIF_ISP_FILT_BASE + 0x00000028)
> +#define CIF_ISP_FILT_THRESH_BL1		(CIF_ISP_FILT_BASE + 0x0000002c)
> +#define CIF_ISP_FILT_THRESH_SH0		(CIF_ISP_FILT_BASE + 0x00000030)
> +#define CIF_ISP_FILT_THRESH_SH1		(CIF_ISP_FILT_BASE + 0x00000034)
> +#define CIF_ISP_FILT_LUM_WEIGHT		(CIF_ISP_FILT_BASE + 0x00000038)
> +#define CIF_ISP_FILT_FAC_SH1		(CIF_ISP_FILT_BASE + 0x0000003c)
> +#define CIF_ISP_FILT_FAC_SH0		(CIF_ISP_FILT_BASE + 0x00000040)
> +#define CIF_ISP_FILT_FAC_MID		(CIF_ISP_FILT_BASE + 0x00000044)
> +#define CIF_ISP_FILT_FAC_BL0		(CIF_ISP_FILT_BASE + 0x00000048)
> +#define CIF_ISP_FILT_FAC_BL1		(CIF_ISP_FILT_BASE + 0x0000004C)
> +
> +#define CIF_ISP_CAC_BASE		0x00002580
> +#define CIF_ISP_CAC_CTRL		(CIF_ISP_CAC_BASE + 0x00000000)
> +#define CIF_ISP_CAC_COUNT_START		(CIF_ISP_CAC_BASE + 0x00000004)
> +#define CIF_ISP_CAC_A			(CIF_ISP_CAC_BASE + 0x00000008)
> +#define CIF_ISP_CAC_B			(CIF_ISP_CAC_BASE + 0x0000000C)
> +#define CIF_ISP_CAC_C			(CIF_ISP_CAC_BASE + 0x00000010)
> +#define CIF_ISP_X_NORM			(CIF_ISP_CAC_BASE + 0x00000014)
> +#define CIF_ISP_Y_NORM			(CIF_ISP_CAC_BASE + 0x00000018)
> +
> +#define CIF_ISP_EXP_BASE		0x00002600
> +#define CIF_ISP_EXP_CTRL		(CIF_ISP_EXP_BASE + 0x00000000)
> +#define CIF_ISP_EXP_H_OFFSET		(CIF_ISP_EXP_BASE + 0x00000004)
> +#define CIF_ISP_EXP_V_OFFSET		(CIF_ISP_EXP_BASE + 0x00000008)
> +#define CIF_ISP_EXP_H_SIZE		(CIF_ISP_EXP_BASE + 0x0000000C)
> +#define CIF_ISP_EXP_V_SIZE		(CIF_ISP_EXP_BASE + 0x00000010)
> +#define CIF_ISP_EXP_MEAN_00		(CIF_ISP_EXP_BASE + 0x00000014)
> +#define CIF_ISP_EXP_MEAN_10		(CIF_ISP_EXP_BASE + 0x00000018)
> +#define CIF_ISP_EXP_MEAN_20		(CIF_ISP_EXP_BASE + 0x0000001c)
> +#define CIF_ISP_EXP_MEAN_30		(CIF_ISP_EXP_BASE + 0x00000020)
> +#define CIF_ISP_EXP_MEAN_40		(CIF_ISP_EXP_BASE + 0x00000024)
> +#define CIF_ISP_EXP_MEAN_01		(CIF_ISP_EXP_BASE + 0x00000028)
> +#define CIF_ISP_EXP_MEAN_11		(CIF_ISP_EXP_BASE + 0x0000002c)
> +#define CIF_ISP_EXP_MEAN_21		(CIF_ISP_EXP_BASE + 0x00000030)
> +#define CIF_ISP_EXP_MEAN_31		(CIF_ISP_EXP_BASE + 0x00000034)
> +#define CIF_ISP_EXP_MEAN_41		(CIF_ISP_EXP_BASE + 0x00000038)
> +#define CIF_ISP_EXP_MEAN_02		(CIF_ISP_EXP_BASE + 0x0000003c)
> +#define CIF_ISP_EXP_MEAN_12		(CIF_ISP_EXP_BASE + 0x00000040)
> +#define CIF_ISP_EXP_MEAN_22		(CIF_ISP_EXP_BASE + 0x00000044)
> +#define CIF_ISP_EXP_MEAN_32		(CIF_ISP_EXP_BASE + 0x00000048)
> +#define CIF_ISP_EXP_MEAN_42		(CIF_ISP_EXP_BASE + 0x0000004c)
> +#define CIF_ISP_EXP_MEAN_03		(CIF_ISP_EXP_BASE + 0x00000050)
> +#define CIF_ISP_EXP_MEAN_13		(CIF_ISP_EXP_BASE + 0x00000054)
> +#define CIF_ISP_EXP_MEAN_23		(CIF_ISP_EXP_BASE + 0x00000058)
> +#define CIF_ISP_EXP_MEAN_33		(CIF_ISP_EXP_BASE + 0x0000005c)
> +#define CIF_ISP_EXP_MEAN_43		(CIF_ISP_EXP_BASE + 0x00000060)
> +#define CIF_ISP_EXP_MEAN_04		(CIF_ISP_EXP_BASE + 0x00000064)
> +#define CIF_ISP_EXP_MEAN_14		(CIF_ISP_EXP_BASE + 0x00000068)
> +#define CIF_ISP_EXP_MEAN_24		(CIF_ISP_EXP_BASE + 0x0000006c)
> +#define CIF_ISP_EXP_MEAN_34		(CIF_ISP_EXP_BASE + 0x00000070)
> +#define CIF_ISP_EXP_MEAN_44		(CIF_ISP_EXP_BASE + 0x00000074)
> +
> +#define CIF_ISP_BLS_BASE		0x00002700
> +#define CIF_ISP_BLS_CTRL		(CIF_ISP_BLS_BASE + 0x00000000)
> +#define CIF_ISP_BLS_SAMPLES		(CIF_ISP_BLS_BASE + 0x00000004)
> +#define CIF_ISP_BLS_H1_START		(CIF_ISP_BLS_BASE + 0x00000008)
> +#define CIF_ISP_BLS_H1_STOP		(CIF_ISP_BLS_BASE + 0x0000000c)
> +#define CIF_ISP_BLS_V1_START		(CIF_ISP_BLS_BASE + 0x00000010)
> +#define CIF_ISP_BLS_V1_STOP		(CIF_ISP_BLS_BASE + 0x00000014)
> +#define CIF_ISP_BLS_H2_START		(CIF_ISP_BLS_BASE + 0x00000018)
> +#define CIF_ISP_BLS_H2_STOP		(CIF_ISP_BLS_BASE + 0x0000001c)
> +#define CIF_ISP_BLS_V2_START		(CIF_ISP_BLS_BASE + 0x00000020)
> +#define CIF_ISP_BLS_V2_STOP		(CIF_ISP_BLS_BASE + 0x00000024)
> +#define CIF_ISP_BLS_A_FIXED		(CIF_ISP_BLS_BASE + 0x00000028)
> +#define CIF_ISP_BLS_B_FIXED		(CIF_ISP_BLS_BASE + 0x0000002c)
> +#define CIF_ISP_BLS_C_FIXED		(CIF_ISP_BLS_BASE + 0x00000030)
> +#define CIF_ISP_BLS_D_FIXED		(CIF_ISP_BLS_BASE + 0x00000034)
> +#define CIF_ISP_BLS_A_MEASURED		(CIF_ISP_BLS_BASE + 0x00000038)
> +#define CIF_ISP_BLS_B_MEASURED		(CIF_ISP_BLS_BASE + 0x0000003c)
> +#define CIF_ISP_BLS_C_MEASURED		(CIF_ISP_BLS_BASE + 0x00000040)
> +#define CIF_ISP_BLS_D_MEASURED		(CIF_ISP_BLS_BASE + 0x00000044)
> +
> +#define CIF_ISP_DPF_BASE		0x00002800
> +#define CIF_ISP_DPF_MODE		(CIF_ISP_DPF_BASE + 0x00000000)
> +#define CIF_ISP_DPF_STRENGTH_R		(CIF_ISP_DPF_BASE + 0x00000004)
> +#define CIF_ISP_DPF_STRENGTH_G		(CIF_ISP_DPF_BASE + 0x00000008)
> +#define CIF_ISP_DPF_STRENGTH_B		(CIF_ISP_DPF_BASE + 0x0000000C)
> +#define CIF_ISP_DPF_S_WEIGHT_G_1_4	(CIF_ISP_DPF_BASE + 0x00000010)
> +#define CIF_ISP_DPF_S_WEIGHT_G_5_6	(CIF_ISP_DPF_BASE + 0x00000014)
> +#define CIF_ISP_DPF_S_WEIGHT_RB_1_4	(CIF_ISP_DPF_BASE + 0x00000018)
> +#define CIF_ISP_DPF_S_WEIGHT_RB_5_6	(CIF_ISP_DPF_BASE + 0x0000001C)
> +#define CIF_ISP_DPF_NULL_COEFF_0	(CIF_ISP_DPF_BASE + 0x00000020)
> +#define CIF_ISP_DPF_NULL_COEFF_1	(CIF_ISP_DPF_BASE + 0x00000024)
> +#define CIF_ISP_DPF_NULL_COEFF_2	(CIF_ISP_DPF_BASE + 0x00000028)
> +#define CIF_ISP_DPF_NULL_COEFF_3	(CIF_ISP_DPF_BASE + 0x0000002C)
> +#define CIF_ISP_DPF_NULL_COEFF_4	(CIF_ISP_DPF_BASE + 0x00000030)
> +#define CIF_ISP_DPF_NULL_COEFF_5	(CIF_ISP_DPF_BASE + 0x00000034)
> +#define CIF_ISP_DPF_NULL_COEFF_6	(CIF_ISP_DPF_BASE + 0x00000038)
> +#define CIF_ISP_DPF_NULL_COEFF_7	(CIF_ISP_DPF_BASE + 0x0000003C)
> +#define CIF_ISP_DPF_NULL_COEFF_8	(CIF_ISP_DPF_BASE + 0x00000040)
> +#define CIF_ISP_DPF_NULL_COEFF_9	(CIF_ISP_DPF_BASE + 0x00000044)
> +#define CIF_ISP_DPF_NULL_COEFF_10	(CIF_ISP_DPF_BASE + 0x00000048)
> +#define CIF_ISP_DPF_NULL_COEFF_11	(CIF_ISP_DPF_BASE + 0x0000004C)
> +#define CIF_ISP_DPF_NULL_COEFF_12	(CIF_ISP_DPF_BASE + 0x00000050)
> +#define CIF_ISP_DPF_NULL_COEFF_13	(CIF_ISP_DPF_BASE + 0x00000054)
> +#define CIF_ISP_DPF_NULL_COEFF_14	(CIF_ISP_DPF_BASE + 0x00000058)
> +#define CIF_ISP_DPF_NULL_COEFF_15	(CIF_ISP_DPF_BASE + 0x0000005C)
> +#define CIF_ISP_DPF_NULL_COEFF_16	(CIF_ISP_DPF_BASE + 0x00000060)
> +#define CIF_ISP_DPF_NF_GAIN_R		(CIF_ISP_DPF_BASE + 0x00000064)
> +#define CIF_ISP_DPF_NF_GAIN_GR		(CIF_ISP_DPF_BASE + 0x00000068)
> +#define CIF_ISP_DPF_NF_GAIN_GB		(CIF_ISP_DPF_BASE + 0x0000006C)
> +#define CIF_ISP_DPF_NF_GAIN_B		(CIF_ISP_DPF_BASE + 0x00000070)
> +
> +#define CIF_ISP_DPCC_BASE		0x00002900
> +#define CIF_ISP_DPCC_MODE		(CIF_ISP_DPCC_BASE + 0x00000000)
> +#define CIF_ISP_DPCC_OUTPUT_MODE	(CIF_ISP_DPCC_BASE + 0x00000004)
> +#define CIF_ISP_DPCC_SET_USE		(CIF_ISP_DPCC_BASE + 0x00000008)
> +#define CIF_ISP_DPCC_METHODS_SET_1	(CIF_ISP_DPCC_BASE + 0x0000000C)
> +#define CIF_ISP_DPCC_METHODS_SET_2	(CIF_ISP_DPCC_BASE + 0x00000010)
> +#define CIF_ISP_DPCC_METHODS_SET_3	(CIF_ISP_DPCC_BASE + 0x00000014)
> +#define CIF_ISP_DPCC_LINE_THRESH_1	(CIF_ISP_DPCC_BASE + 0x00000018)
> +#define CIF_ISP_DPCC_LINE_MAD_FAC_1	(CIF_ISP_DPCC_BASE + 0x0000001C)
> +#define CIF_ISP_DPCC_PG_FAC_1		(CIF_ISP_DPCC_BASE + 0x00000020)
> +#define CIF_ISP_DPCC_RND_THRESH_1	(CIF_ISP_DPCC_BASE + 0x00000024)
> +#define CIF_ISP_DPCC_RG_FAC_1		(CIF_ISP_DPCC_BASE + 0x00000028)
> +#define CIF_ISP_DPCC_LINE_THRESH_2	(CIF_ISP_DPCC_BASE + 0x0000002C)
> +#define CIF_ISP_DPCC_LINE_MAD_FAC_2	(CIF_ISP_DPCC_BASE + 0x00000030)
> +#define CIF_ISP_DPCC_PG_FAC_2		(CIF_ISP_DPCC_BASE + 0x00000034)
> +#define CIF_ISP_DPCC_RND_THRESH_2	(CIF_ISP_DPCC_BASE + 0x00000038)
> +#define CIF_ISP_DPCC_RG_FAC_2		(CIF_ISP_DPCC_BASE + 0x0000003C)
> +#define CIF_ISP_DPCC_LINE_THRESH_3	(CIF_ISP_DPCC_BASE + 0x00000040)
> +#define CIF_ISP_DPCC_LINE_MAD_FAC_3	(CIF_ISP_DPCC_BASE + 0x00000044)
> +#define CIF_ISP_DPCC_PG_FAC_3		(CIF_ISP_DPCC_BASE + 0x00000048)
> +#define CIF_ISP_DPCC_RND_THRESH_3	(CIF_ISP_DPCC_BASE + 0x0000004C)
> +#define CIF_ISP_DPCC_RG_FAC_3		(CIF_ISP_DPCC_BASE + 0x00000050)
> +#define CIF_ISP_DPCC_RO_LIMITS		(CIF_ISP_DPCC_BASE + 0x00000054)
> +#define CIF_ISP_DPCC_RND_OFFS		(CIF_ISP_DPCC_BASE + 0x00000058)
> +#define CIF_ISP_DPCC_BPT_CTRL		(CIF_ISP_DPCC_BASE + 0x0000005C)
> +#define CIF_ISP_DPCC_BPT_NUMBER		(CIF_ISP_DPCC_BASE + 0x00000060)
> +#define CIF_ISP_DPCC_BPT_ADDR		(CIF_ISP_DPCC_BASE + 0x00000064)
> +#define CIF_ISP_DPCC_BPT_DATA		(CIF_ISP_DPCC_BASE + 0x00000068)
> +
> +#define CIF_ISP_WDR_BASE		0x00002A00
> +#define CIF_ISP_WDR_CTRL		(CIF_ISP_WDR_BASE + 0x00000000)
> +#define CIF_ISP_WDR_TONECURVE_1		(CIF_ISP_WDR_BASE + 0x00000004)
> +#define CIF_ISP_WDR_TONECURVE_2		(CIF_ISP_WDR_BASE + 0x00000008)
> +#define CIF_ISP_WDR_TONECURVE_3		(CIF_ISP_WDR_BASE + 0x0000000C)
> +#define CIF_ISP_WDR_TONECURVE_4		(CIF_ISP_WDR_BASE + 0x00000010)
> +#define CIF_ISP_WDR_TONECURVE_YM_0	(CIF_ISP_WDR_BASE + 0x00000014)
> +#define CIF_ISP_WDR_TONECURVE_YM_1	(CIF_ISP_WDR_BASE + 0x00000018)
> +#define CIF_ISP_WDR_TONECURVE_YM_2	(CIF_ISP_WDR_BASE + 0x0000001C)
> +#define CIF_ISP_WDR_TONECURVE_YM_3	(CIF_ISP_WDR_BASE + 0x00000020)
> +#define CIF_ISP_WDR_TONECURVE_YM_4	(CIF_ISP_WDR_BASE + 0x00000024)
> +#define CIF_ISP_WDR_TONECURVE_YM_5	(CIF_ISP_WDR_BASE + 0x00000028)
> +#define CIF_ISP_WDR_TONECURVE_YM_6	(CIF_ISP_WDR_BASE + 0x0000002C)
> +#define CIF_ISP_WDR_TONECURVE_YM_7	(CIF_ISP_WDR_BASE + 0x00000030)
> +#define CIF_ISP_WDR_TONECURVE_YM_8	(CIF_ISP_WDR_BASE + 0x00000034)
> +#define CIF_ISP_WDR_TONECURVE_YM_9	(CIF_ISP_WDR_BASE + 0x00000038)
> +#define CIF_ISP_WDR_TONECURVE_YM_10	(CIF_ISP_WDR_BASE + 0x0000003C)
> +#define CIF_ISP_WDR_TONECURVE_YM_11	(CIF_ISP_WDR_BASE + 0x00000040)
> +#define CIF_ISP_WDR_TONECURVE_YM_12	(CIF_ISP_WDR_BASE + 0x00000044)
> +#define CIF_ISP_WDR_TONECURVE_YM_13	(CIF_ISP_WDR_BASE + 0x00000048)
> +#define CIF_ISP_WDR_TONECURVE_YM_14	(CIF_ISP_WDR_BASE + 0x0000004C)
> +#define CIF_ISP_WDR_TONECURVE_YM_15	(CIF_ISP_WDR_BASE + 0x00000050)
> +#define CIF_ISP_WDR_TONECURVE_YM_16	(CIF_ISP_WDR_BASE + 0x00000054)
> +#define CIF_ISP_WDR_TONECURVE_YM_17	(CIF_ISP_WDR_BASE + 0x00000058)
> +#define CIF_ISP_WDR_TONECURVE_YM_18	(CIF_ISP_WDR_BASE + 0x0000005C)
> +#define CIF_ISP_WDR_TONECURVE_YM_19	(CIF_ISP_WDR_BASE + 0x00000060)
> +#define CIF_ISP_WDR_TONECURVE_YM_20	(CIF_ISP_WDR_BASE + 0x00000064)
> +#define CIF_ISP_WDR_TONECURVE_YM_21	(CIF_ISP_WDR_BASE + 0x00000068)
> +#define CIF_ISP_WDR_TONECURVE_YM_22	(CIF_ISP_WDR_BASE + 0x0000006C)
> +#define CIF_ISP_WDR_TONECURVE_YM_23	(CIF_ISP_WDR_BASE + 0x00000070)
> +#define CIF_ISP_WDR_TONECURVE_YM_24	(CIF_ISP_WDR_BASE + 0x00000074)
> +#define CIF_ISP_WDR_TONECURVE_YM_25	(CIF_ISP_WDR_BASE + 0x00000078)
> +#define CIF_ISP_WDR_TONECURVE_YM_26	(CIF_ISP_WDR_BASE + 0x0000007C)
> +#define CIF_ISP_WDR_TONECURVE_YM_27	(CIF_ISP_WDR_BASE + 0x00000080)
> +#define CIF_ISP_WDR_TONECURVE_YM_28	(CIF_ISP_WDR_BASE + 0x00000084)
> +#define CIF_ISP_WDR_TONECURVE_YM_29	(CIF_ISP_WDR_BASE + 0x00000088)
> +#define CIF_ISP_WDR_TONECURVE_YM_30	(CIF_ISP_WDR_BASE + 0x0000008C)
> +#define CIF_ISP_WDR_TONECURVE_YM_31	(CIF_ISP_WDR_BASE + 0x00000090)
> +#define CIF_ISP_WDR_TONECURVE_YM_32	(CIF_ISP_WDR_BASE + 0x00000094)
> +#define CIF_ISP_WDR_OFFSET		(CIF_ISP_WDR_BASE + 0x00000098)
> +#define CIF_ISP_WDR_DELTAMIN		(CIF_ISP_WDR_BASE + 0x0000009C)
> +#define CIF_ISP_WDR_TONECURVE_1_SHD	(CIF_ISP_WDR_BASE + 0x000000A0)
> +#define CIF_ISP_WDR_TONECURVE_2_SHD	(CIF_ISP_WDR_BASE + 0x000000A4)
> +#define CIF_ISP_WDR_TONECURVE_3_SHD	(CIF_ISP_WDR_BASE + 0x000000A8)
> +#define CIF_ISP_WDR_TONECURVE_4_SHD	(CIF_ISP_WDR_BASE + 0x000000AC)
> +#define CIF_ISP_WDR_TONECURVE_YM_0_SHD	(CIF_ISP_WDR_BASE + 0x000000B0)
> +#define CIF_ISP_WDR_TONECURVE_YM_1_SHD	(CIF_ISP_WDR_BASE + 0x000000B4)
> +#define CIF_ISP_WDR_TONECURVE_YM_2_SHD	(CIF_ISP_WDR_BASE + 0x000000B8)
> +#define CIF_ISP_WDR_TONECURVE_YM_3_SHD	(CIF_ISP_WDR_BASE + 0x000000BC)
> +#define CIF_ISP_WDR_TONECURVE_YM_4_SHD	(CIF_ISP_WDR_BASE + 0x000000C0)
> +#define CIF_ISP_WDR_TONECURVE_YM_5_SHD	(CIF_ISP_WDR_BASE + 0x000000C4)
> +#define CIF_ISP_WDR_TONECURVE_YM_6_SHD	(CIF_ISP_WDR_BASE + 0x000000C8)
> +#define CIF_ISP_WDR_TONECURVE_YM_7_SHD	(CIF_ISP_WDR_BASE + 0x000000CC)
> +#define CIF_ISP_WDR_TONECURVE_YM_8_SHD	(CIF_ISP_WDR_BASE + 0x000000D0)
> +#define CIF_ISP_WDR_TONECURVE_YM_9_SHD	(CIF_ISP_WDR_BASE + 0x000000D4)
> +#define CIF_ISP_WDR_TONECURVE_YM_10_SHD	(CIF_ISP_WDR_BASE + 0x000000D8)
> +#define CIF_ISP_WDR_TONECURVE_YM_11_SHD	(CIF_ISP_WDR_BASE + 0x000000DC)
> +#define CIF_ISP_WDR_TONECURVE_YM_12_SHD	(CIF_ISP_WDR_BASE + 0x000000E0)
> +#define CIF_ISP_WDR_TONECURVE_YM_13_SHD	(CIF_ISP_WDR_BASE + 0x000000E4)
> +#define CIF_ISP_WDR_TONECURVE_YM_14_SHD	(CIF_ISP_WDR_BASE + 0x000000E8)
> +#define CIF_ISP_WDR_TONECURVE_YM_15_SHD	(CIF_ISP_WDR_BASE + 0x000000EC)
> +#define CIF_ISP_WDR_TONECURVE_YM_16_SHD	(CIF_ISP_WDR_BASE + 0x000000F0)
> +#define CIF_ISP_WDR_TONECURVE_YM_17_SHD	(CIF_ISP_WDR_BASE + 0x000000F4)
> +#define CIF_ISP_WDR_TONECURVE_YM_18_SHD	(CIF_ISP_WDR_BASE + 0x000000F8)
> +#define CIF_ISP_WDR_TONECURVE_YM_19_SHD	(CIF_ISP_WDR_BASE + 0x000000FC)
> +#define CIF_ISP_WDR_TONECURVE_YM_20_SHD	(CIF_ISP_WDR_BASE + 0x00000100)
> +#define CIF_ISP_WDR_TONECURVE_YM_21_SHD	(CIF_ISP_WDR_BASE + 0x00000104)
> +#define CIF_ISP_WDR_TONECURVE_YM_22_SHD	(CIF_ISP_WDR_BASE + 0x00000108)
> +#define CIF_ISP_WDR_TONECURVE_YM_23_SHD	(CIF_ISP_WDR_BASE + 0x0000010C)
> +#define CIF_ISP_WDR_TONECURVE_YM_24_SHD	(CIF_ISP_WDR_BASE + 0x00000110)
> +#define CIF_ISP_WDR_TONECURVE_YM_25_SHD	(CIF_ISP_WDR_BASE + 0x00000114)
> +#define CIF_ISP_WDR_TONECURVE_YM_26_SHD	(CIF_ISP_WDR_BASE + 0x00000118)
> +#define CIF_ISP_WDR_TONECURVE_YM_27_SHD	(CIF_ISP_WDR_BASE + 0x0000011C)
> +#define CIF_ISP_WDR_TONECURVE_YM_28_SHD	(CIF_ISP_WDR_BASE + 0x00000120)
> +#define CIF_ISP_WDR_TONECURVE_YM_29_SHD	(CIF_ISP_WDR_BASE + 0x00000124)
> +#define CIF_ISP_WDR_TONECURVE_YM_30_SHD	(CIF_ISP_WDR_BASE + 0x00000128)
> +#define CIF_ISP_WDR_TONECURVE_YM_31_SHD	(CIF_ISP_WDR_BASE + 0x0000012C)
> +#define CIF_ISP_WDR_TONECURVE_YM_32_SHD	(CIF_ISP_WDR_BASE + 0x00000130)
> +
> +#define CIF_ISP_VSM_BASE		0x00002F00
> +#define CIF_ISP_VSM_MODE		(CIF_ISP_VSM_BASE + 0x00000000)
> +#define CIF_ISP_VSM_H_OFFS		(CIF_ISP_VSM_BASE + 0x00000004)
> +#define CIF_ISP_VSM_V_OFFS		(CIF_ISP_VSM_BASE + 0x00000008)
> +#define CIF_ISP_VSM_H_SIZE		(CIF_ISP_VSM_BASE + 0x0000000C)
> +#define CIF_ISP_VSM_V_SIZE		(CIF_ISP_VSM_BASE + 0x00000010)
> +#define CIF_ISP_VSM_H_SEGMENTS		(CIF_ISP_VSM_BASE + 0x00000014)
> +#define CIF_ISP_VSM_V_SEGMENTS		(CIF_ISP_VSM_BASE + 0x00000018)
> +#define CIF_ISP_VSM_DELTA_H		(CIF_ISP_VSM_BASE + 0x0000001C)
> +#define CIF_ISP_VSM_DELTA_V		(CIF_ISP_VSM_BASE + 0x00000020)
> +
> +void disable_dcrop(struct rkisp1_stream *stream, bool async);
> +void config_dcrop(struct rkisp1_stream *stream, struct v4l2_rect *rect,
> +		  bool async);
> +
> +void dump_rsz_regs(struct rkisp1_stream *stream);
> +void disable_rsz(struct rkisp1_stream *stream, bool async);
> +void config_rsz(struct rkisp1_stream *stream, struct v4l2_rect *in_y,
> +		struct v4l2_rect *in_c, struct v4l2_rect *out_y,
> +		struct v4l2_rect *out_c, bool async);
> +
> +void config_mi_ctrl(struct rkisp1_stream *stream);
> +
> +void mp_clr_frame_end_int(void __iomem * base);
> +void sp_clr_frame_end_int(void __iomem * base);
> +
> +u32 mp_is_frame_end_int_masked(void __iomem * base);
> +u32 sp_is_frame_end_int_masked(void __iomem * base);
> +
> +static inline void mi_set_y_size(struct rkisp1_stream *stream, int val)
> +{
> +	void __iomem *base = stream->ispdev->base_addr;
> +
> +	writel(val, base + stream->config->mi.y_size_init);
> +}
> +
> +static inline void mi_set_cb_size(struct rkisp1_stream *stream, int val)
> +{
> +	void __iomem *base = stream->ispdev->base_addr;
> +
> +	writel(val, base + stream->config->mi.cb_size_init);
> +}
> +
> +static inline void mi_set_cr_size(struct rkisp1_stream *stream, int val)
> +{
> +	void __iomem *base = stream->ispdev->base_addr;
> +
> +	writel(val, base + stream->config->mi.cr_size_init);
> +}
> +
> +static inline void mi_set_y_addr(struct rkisp1_stream *stream, int val)
> +{
> +	void __iomem *base = stream->ispdev->base_addr;
> +
> +	writel(val, base + stream->config->mi.y_base_ad_init);
> +}
> +
> +static inline void mi_set_cb_addr(struct rkisp1_stream *stream, int val)
> +{
> +	void __iomem *base = stream->ispdev->base_addr;
> +
> +	writel(val, base + stream->config->mi.cb_base_ad_init);
> +}
> +
> +static inline void mi_set_cr_addr(struct rkisp1_stream *stream, int val)
> +{
> +	void __iomem *base = stream->ispdev->base_addr;
> +
> +	writel(val, base + stream->config->mi.cr_base_ad_init);
> +}
> +
> +static inline void mi_set_y_offset(struct rkisp1_stream *stream, int val)
> +{
> +	void __iomem *base = stream->ispdev->base_addr;
> +
> +	writel(val, base + stream->config->mi.y_offs_cnt_init);
> +}
> +
> +static inline void mi_set_cb_offset(struct rkisp1_stream *stream, int val)
> +{
> +	void __iomem *base = stream->ispdev->base_addr;
> +
> +	writel(val, base + stream->config->mi.cb_offs_cnt_init);
> +}
> +
> +static inline void mi_set_cr_offset(struct rkisp1_stream *stream, int val)
> +{
> +	void __iomem *base = stream->ispdev->base_addr;
> +
> +	writel(val, base + stream->config->mi.cr_offs_cnt_init);
> +}
> +
> +static inline void mp_set_chain_mode(void __iomem *base)
> +{
> +	u32 dpcl = readl(base + CIF_VI_DPCL);
> +
> +	dpcl |= CIF_VI_DPCL_CHAN_MODE_MP;
> +	writel(dpcl, base + CIF_VI_DPCL);
> +}
> +
> +static inline void sp_set_chain_mode(void __iomem *base)
> +{
> +	u32 dpcl = readl(base + CIF_VI_DPCL);
> +
> +	dpcl |= CIF_VI_DPCL_CHAN_MODE_SP;
> +	writel(dpcl, base + CIF_VI_DPCL);
> +}
> +
> +static inline void mp_set_data_path(void __iomem *base)
> +{
> +	u32 dpcl = readl(base + CIF_VI_DPCL);
> +
> +	dpcl = dpcl | CIF_VI_DPCL_CHAN_MODE_MP | CIF_VI_DPCL_MP_MUX_MRSZ_MI;
> +	writel(dpcl, base + CIF_VI_DPCL);
> +}
> +
> +static inline void sp_set_data_path(void __iomem *base)
> +{
> +	u32 dpcl = readl(base + CIF_VI_DPCL);
> +
> +	dpcl |= CIF_VI_DPCL_CHAN_MODE_SP;
> +	writel(dpcl, base + CIF_VI_DPCL);
> +}
> +
> +static inline void mp_frame_end_int_enable(void __iomem *base)
> +{
> +	void __iomem *addr = base + CIF_MI_IMSC;
> +
> +	writel(CIF_MI_MP_FRAME | readl(addr), addr);
> +}
> +
> +static inline void sp_frame_end_int_enable(void __iomem *base)
> +{
> +	void __iomem *addr = base + CIF_MI_IMSC;
> +
> +	writel(CIF_MI_SP_FRAME | readl(addr), addr);
> +}
> +
> +static inline void mp_frame_end_int_disable(void __iomem *base)
> +{
> +	void __iomem *addr = base + CIF_MI_IMSC;
> +
> +	writel(~CIF_MI_MP_FRAME & readl(addr), addr);
> +}
> +
> +static inline void sp_frame_end_int_disable(void __iomem *base)
> +{
> +	void __iomem *addr = base + CIF_MI_IMSC;
> +
> +	writel(~CIF_MI_SP_FRAME & readl(addr), addr);
> +}
> +
> +static inline void frame_end_int_disable(void __iomem *base)
> +{
> +	void __iomem *addr = base + CIF_MI_IMSC;
> +
> +	writel(~(CIF_MI_SP_FRAME | CIF_MI_MP_FRAME) & readl(addr), addr);
> +}
> +
> +static inline void clr_mpsp_frame_end_int(void __iomem *base)
> +{
> +	writel(CIF_MI_SP_FRAME | CIF_MI_MP_FRAME, base + CIF_MI_ICR);
> +}
> +
> +static inline void clr_mp_crop_rsz_int(void __iomem *base)
> +{
> +	writel(~CIF_MI_MP_FRAME, base + CIF_MI_ICR);
> +}
> +
> +static inline void clr_sp_crop_rsz_int(void __iomem *base)
> +{
> +	writel(~CIF_MI_SP_FRAME, base + CIF_MI_ICR);
> +}
> +
> +static inline void clr_all_int(void __iomem *base)
> +{
> +	writel(~0, base + CIF_MI_ICR);
> +}
> +
> +static inline void mp_set_uv_swap(void __iomem *base)
> +{
> +	void __iomem *addr = base + CIF_MI_XTD_FORMAT_CTRL;
> +	u32 reg = readl(addr) & ~GENMASK(2, 0);
> +
> +	writel(reg | CIF_MI_XTD_FMT_CTRL_MP_CB_CR_SWAP, addr);
> +}
> +
> +static inline void sp_set_uv_swap(void __iomem *base)
> +{
> +	void __iomem *addr = base + CIF_MI_XTD_FORMAT_CTRL;
> +	u32 reg = readl(addr) & ~GENMASK(2, 0);
> +
> +	writel(reg | CIF_MI_XTD_FMT_CTRL_SP_CB_CR_SWAP, addr);
> +}
> +
> +static inline void sp_set_y_width(void __iomem *base, u32 val)
> +{
> +	writel(val, base + CIF_MI_SP_Y_PIC_WIDTH);
> +}
> +
> +static inline void sp_set_y_height(void __iomem *base, u32 val)
> +{
> +	writel(val, base + CIF_MI_SP_Y_PIC_HEIGHT);
> +}
> +
> +static inline void sp_set_y_line_length(void __iomem *base, u32 val)
> +{
> +	writel(val, base + CIF_MI_SP_Y_LLENGTH);
> +}
> +
> +static inline void mp_mi_ctrl_set_format(void __iomem *base, u32 val)
> +{
> +	void __iomem *addr = base + CIF_MI_CTRL;
> +	u32 reg = readl(addr) & ~MI_CTRL_MP_FMT_MASK;
> +
> +	writel(reg | val, addr);
> +}
> +
> +static inline void sp_mi_ctrl_set_format(void __iomem *base, u32 val)
> +{
> +	void __iomem *addr = base + CIF_MI_CTRL;
> +	u32 reg = readl(addr) & ~MI_CTRL_SP_FMT_MASK;
> +
> +	writel(reg | val, addr);
> +}
> +
> +static inline void mi_ctrl_mpyuv_enable(void __iomem *base)
> +{
> +	void __iomem *addr = base + CIF_MI_CTRL;
> +
> +	writel(CIF_MI_CTRL_MP_ENABLE | readl(addr), addr);
> +}
> +
> +static inline void mi_ctrl_mpyuv_disable(void __iomem *base)
> +{
> +	void __iomem *addr = base + CIF_MI_CTRL;
> +
> +	writel(~CIF_MI_CTRL_MP_ENABLE & readl(addr), addr);
> +}
> +
> +static inline void mi_ctrl_mp_disable(void __iomem *base)
> +{
> +	void __iomem *addr = base + CIF_MI_CTRL;
> +
> +	writel(~(CIF_MI_CTRL_MP_ENABLE | CIF_MI_CTRL_RAW_ENABLE) & readl(addr),
> +	       addr);
> +}
> +
> +static inline void mi_ctrl_spyuv_enable(void __iomem *base)
> +{
> +	void __iomem *addr = base + CIF_MI_CTRL;
> +
> +	writel(CIF_MI_CTRL_SP_ENABLE | readl(addr), addr);
> +}
> +
> +static inline void mi_ctrl_spyuv_disable(void __iomem *base)
> +{
> +	void __iomem *addr = base + CIF_MI_CTRL;
> +
> +	writel(~CIF_MI_CTRL_SP_ENABLE & readl(addr), addr);
> +}
> +
> +static inline void mi_ctrl_sp_disable(void __iomem *base)
> +{
> +	mi_ctrl_spyuv_disable(base);
> +}
> +
> +static inline void mi_ctrl_mpraw_enable(void __iomem *base)
> +{
> +	void __iomem *addr = base + CIF_MI_CTRL;
> +
> +	writel(CIF_MI_CTRL_RAW_ENABLE | readl(addr), addr);
> +}
> +
> +static inline void mi_ctrl_mpraw_disable(void __iomem *base)
> +{
> +	void __iomem *addr = base + CIF_MI_CTRL;
> +
> +	writel(~CIF_MI_CTRL_RAW_ENABLE & readl(addr), addr);
> +}
> +
> +static inline void mp_mi_ctrl_autoupdate_en(void __iomem *base)
> +{
> +	void __iomem *addr = base + CIF_MI_CTRL;
> +
> +	writel(readl(addr) | CIF_MI_MP_AUTOUPDATE_ENABLE, addr);
> +}
> +
> +static inline void sp_mi_ctrl_autoupdate_en(void __iomem *base)
> +{
> +	void __iomem *addr = base + CIF_MI_CTRL;
> +
> +	writel(readl(addr) | CIF_MI_SP_AUTOUPDATE_ENABLE, addr);
> +}
> +
> +static inline void force_cfg_update(void __iomem * base)
> +{
> +	writel(CIF_MI_INIT_SOFT_UPD, base + CIF_MI_INIT);
> +}
> +
> +static inline u32 mi_get_masked_int_status(void __iomem *base)
> +{
> +	return readl(base + CIF_MI_MIS);
> +}
> +
> +#endif /* _RKISP1_REGS_H */
> diff --git a/drivers/media/platform/rockchip/isp1/rkisp1.c b/drivers/media/platform/rockchip/isp1/rkisp1.c
> new file mode 100644
> index 000000000000..98be90f4d24a
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/isp1/rkisp1.c
> @@ -0,0 +1,1230 @@
> +/*
> + * Rockchip isp1 driver
> + *
> + * Copyright (C) 2017 Rockchip Electronics Co., Ltd.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#include <linux/iopoll.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/videodev2.h>
> +#include <linux/vmalloc.h>
> +#include <media/v4l2-event.h>
> +#include "capture.h"
> +#include "regs.h"
> +#include "rkisp1.h"
> +
> +/* TODO: define the isp frame size constrains */
> +#define CIF_ISP_INPUT_W_MAX		4032
> +#define CIF_ISP_INPUT_H_MAX		3024
> +#define CIF_ISP_INPUT_W_MIN		32
> +#define CIF_ISP_INPUT_H_MIN		32
> +#define CIF_ISP_OUTPUT_W_MAX		CIF_ISP_INPUT_W_MAX
> +#define CIF_ISP_OUTPUT_H_MAX		CIF_ISP_INPUT_H_MAX
> +#define CIF_ISP_OUTPUT_W_MIN		CIF_ISP_INPUT_W_MIN
> +#define CIF_ISP_OUTPUT_H_MIN		CIF_ISP_INPUT_H_MIN
> +
> +/*
> + * Cropping regions of ISP
> + *
> + * +---------------------------------------------------------+
> + * | Sensor image                                            |
> + * | +---------------------------------------------------+   |
> + * | | ISP_ACQ (for black level)                         |   |
> + * | | in_frm               			         |   |
> + * | | +--------------------------------------------+    |   |
> + * | | |    ISP_OUT                                 |    |   |
> + * | | |    in_crop                                 |    |   |
> + * | | |    +---------------------------------+     |    |   |
> + * | | |    |   ISP_IS                        |     |    |   |
> + * | | |    |   rkisp1_isp_subdev: out_crop   |     |    |   |
> + * | | |    +---------------------------------+     |    |   |
> + * | | +--------------------------------------------+    |   |
> + * | +---------------------------------------------------+   |
> + * +---------------------------------------------------------+
> + */
> +
> +static struct v4l2_subdev *get_remote_sensor(struct v4l2_subdev *sd)
> +{
> +	struct media_pad *local, *remote;
> +	struct media_entity *sensor_me;
> +
> +	local = &sd->entity.pads[RKISP1_ISP_PAD_SINK];
> +	remote = media_entity_remote_pad(local);
> +	if (!remote) {
> +		v4l2_warn(sd, "No link between dphy and sensor\n");
> +		return NULL;
> +	}
> +
> +	sensor_me = media_entity_remote_pad(local)->entity;
> +	return media_entity_to_v4l2_subdev(sensor_me);
> +}
> +
> +static struct rkisp1_sensor_info *sd_to_sensor(struct rkisp1_device *dev,
> +					       struct v4l2_subdev *sd)
> +{
> +	int i;
> +
> +	for (i = 0; i < dev->num_sensors; ++i)
> +		if (dev->sensors[i].sd == sd)
> +			return &dev->sensors[i];
> +
> +	return NULL;
> +}
> +
> +/*
> + * This should only be called when configuring CIF
> + * or at the frame end interrupt
> + */
> +static void rkisp1_config_ism(struct rkisp1_device *dev)
> +{
> +	void __iomem *base = dev->base_addr;
> +	struct v4l2_rect *out_crop = &dev->isp_sdev.out_crop;
> +	u32 val;
> +
> +	writel(0, base + CIF_ISP_IS_RECENTER);
> +	writel(0, base + CIF_ISP_IS_MAX_DX);
> +	writel(0, base + CIF_ISP_IS_MAX_DY);
> +	writel(0, base + CIF_ISP_IS_DISPLACE);
> +	writel(out_crop->left, base + CIF_ISP_IS_H_OFFS);
> +	writel(out_crop->top, base + CIF_ISP_IS_V_OFFS);
> +	writel(out_crop->width, base + CIF_ISP_IS_H_SIZE);
> +	writel(out_crop->height, base + CIF_ISP_IS_V_SIZE);
> +
> +	/* IS(Image Stabilization) is always on, working as output crop */
> +	writel(1, base + CIF_ISP_IS_CTRL);
> +	val = readl(base + CIF_ISP_CTRL);
> +	val |= CIF_ISP_CTRL_ISP_CFG_UPD;
> +	writel(val, base + CIF_ISP_CTRL);
> +}
> +
> +static int rkisp1_config_isp(struct rkisp1_device *dev)
> +{
> +	struct ispsd_in_fmt *in_fmt;
> +	struct ispsd_out_fmt *out_fmt;
> +	struct v4l2_mbus_framefmt *in_frm;
> +	struct v4l2_rect *out_crop, *in_crop;
> +	struct rkisp1_sensor_info *sensor;
> +	void __iomem *base = dev->base_addr;
> +	u32 isp_ctrl;
> +	u32 irq_mask = 0;
> +	u32 signal = 0;
> +	u32 acq_mult;
> +	u32 val;
> +
> +	sensor = dev->active_sensor;
> +	in_frm = &dev->isp_sdev.in_frm;
> +	in_fmt = &dev->isp_sdev.in_fmt;
> +	out_fmt = &dev->isp_sdev.out_fmt;
> +	out_crop = &dev->isp_sdev.out_crop;
> +	in_crop = &dev->isp_sdev.in_crop;
> +	val = readl(base + CIF_ICCL);
> +	writel(val | CIF_ICCL_ISP_CLK, base + CIF_ICCL);
> +
> +	if (in_fmt->fmt_type == FMT_BAYER) {
> +		acq_mult = 1;
> +		if (out_fmt->fmt_type == FMT_BAYER) {
> +			if (sensor->mbus.type == V4L2_MBUS_BT656)
> +				isp_ctrl =
> +					CIF_ISP_CTRL_ISP_MODE_RAW_PICT_ITU656;
> +			else
> +				isp_ctrl =
> +					CIF_ISP_CTRL_ISP_MODE_RAW_PICT;
> +		} else {
> +			writel(CIF_ISP_DEMOSAIC_TH(0xc),
> +			       base + CIF_ISP_DEMOSAIC);
> +
> +			if (sensor->mbus.type == V4L2_MBUS_BT656)
> +				isp_ctrl = CIF_ISP_CTRL_ISP_MODE_BAYER_ITU656;
> +			else
> +				isp_ctrl = CIF_ISP_CTRL_ISP_MODE_BAYER_ITU601;
> +		}
> +	} else if (in_fmt->fmt_type == FMT_YUV) {
> +		acq_mult = 2;
> +		if (sensor->mbus.type == V4L2_MBUS_CSI2) {
> +			isp_ctrl = CIF_ISP_CTRL_ISP_MODE_ITU601;
> +		} else {
> +			if (sensor->mbus.type == V4L2_MBUS_BT656)
> +				isp_ctrl = CIF_ISP_CTRL_ISP_MODE_ITU656;
> +			else
> +				isp_ctrl = CIF_ISP_CTRL_ISP_MODE_ITU601;
> +
> +		}
> +
> +		irq_mask |= CIF_ISP_DATA_LOSS;
> +	}
> +
> +	/* Set up input acquisition properties */
> +	if (sensor->mbus.type == V4L2_MBUS_BT656 ||
> +	    sensor->mbus.type == V4L2_MBUS_PARALLEL) {
> +		if (sensor->mbus.flags &
> +			V4L2_MBUS_PCLK_SAMPLE_RISING)
> +			signal = CIF_ISP_ACQ_PROP_POS_EDGE;
> +	}
> +
> +	if (sensor->mbus.type == V4L2_MBUS_PARALLEL) {
> +		if (sensor->mbus.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
> +			signal |= CIF_ISP_ACQ_PROP_VSYNC_LOW;
> +
> +		if (sensor->mbus.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
> +			signal |= CIF_ISP_ACQ_PROP_HSYNC_LOW;
> +	}
> +
> +	writel(isp_ctrl, base + CIF_ISP_CTRL);
> +	writel(signal | in_fmt->yuv_seq |
> +	       CIF_ISP_ACQ_PROP_BAYER_PAT(in_fmt->bayer_pat) |
> +	       CIF_ISP_ACQ_PROP_FIELD_SEL_ALL, base + CIF_ISP_ACQ_PROP);
> +	writel(0, base + CIF_ISP_ACQ_NR_FRAMES);
> +
> +	/* Acquisition Size */
> +	writel(0, base + CIF_ISP_ACQ_H_OFFS);
> +	writel(0, base + CIF_ISP_ACQ_V_OFFS);
> +	writel(acq_mult * in_frm->width, base + CIF_ISP_ACQ_H_SIZE);
> +	writel(in_frm->height, base + CIF_ISP_ACQ_V_SIZE);
> +
> +	/* ISP Out Area */
> +	writel(in_crop->left, base + CIF_ISP_OUT_H_OFFS);
> +	writel(in_crop->top, base + CIF_ISP_OUT_V_OFFS);
> +	writel(in_crop->width, base + CIF_ISP_OUT_H_SIZE);
> +	writel(in_crop->height, base + CIF_ISP_OUT_V_SIZE);
> +
> +	/* interrupt mask */
> +	irq_mask |= CIF_ISP_FRAME | CIF_ISP_V_START | CIF_ISP_PIC_SIZE_ERROR |
> +		    CIF_ISP_FRAME_IN;
> +	writel(irq_mask, base + CIF_ISP_IMSC);
> +
> +	if (out_fmt->fmt_type == FMT_BAYER)
> +		rkisp1_disable_isp(&dev->params_vdev);
> +	else
> +		rkisp1_configure_isp(&dev->params_vdev, in_fmt,
> +				     V4L2_QUANTIZATION_FULL_RANGE);
> +
> +	return 0;
> +}
> +
> +static int rkisp1_config_dvp(struct rkisp1_device *dev)
> +{
> +	struct ispsd_in_fmt *in_fmt = &dev->isp_sdev.in_fmt;
> +	void __iomem *base = dev->base_addr;
> +	u32 val, input_sel;
> +
> +	switch (in_fmt->bus_width) {
> +	case 8:
> +		input_sel = CIF_ISP_ACQ_PROP_IN_SEL_8B_ZERO;
> +		break;
> +	case 10:
> +		input_sel = CIF_ISP_ACQ_PROP_IN_SEL_10B_ZERO;
> +		break;
> +	case 12:
> +		input_sel = CIF_ISP_ACQ_PROP_IN_SEL_12B;
> +		break;
> +	default:
> +		v4l2_err(&dev->v4l2_dev, "Invalid bus width\n");
> +		return -EINVAL;
> +	}
> +
> +	val = readl(base + CIF_ISP_ACQ_PROP);
> +	writel(val | input_sel, base + CIF_ISP_ACQ_PROP);
> +
> +	return 0;
> +}
> +
> +static int rkisp1_config_mipi(struct rkisp1_device *dev)
> +{
> +	u32 mipi_ctrl, val;
> +	void __iomem *base = dev->base_addr;
> +	struct ispsd_in_fmt *in_fmt = &dev->isp_sdev.in_fmt;
> +	struct rkisp1_sensor_info *sensor = dev->active_sensor;
> +	int lanes;
> +
> +	switch (sensor->mbus.flags & V4L2_MBUS_CSI2_LANES) {
> +	case V4L2_MBUS_CSI2_4_LANE:
> +		lanes = 4;
> +		break;
> +	case V4L2_MBUS_CSI2_3_LANE:
> +		lanes = 3;
> +		break;
> +	case V4L2_MBUS_CSI2_2_LANE:
> +		lanes = 2;
> +		break;
> +	case V4L2_MBUS_CSI2_1_LANE:
> +		lanes = 1;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	val = readl(base + CIF_ICCL);
> +	writel(val | CIF_ICCL_MIPI_CLK, base + CIF_ICCL);
> +
> +	mipi_ctrl = CIF_MIPI_CTRL_NUM_LANES(lanes - 1) |
> +		    CIF_MIPI_CTRL_SHUTDOWNLANES(0xf) |
> +		    CIF_MIPI_CTRL_ERR_SOT_SYNC_HS_SKIP |
> +		    CIF_MIPI_CTRL_CLOCKLANE_ENA;
> +
> +	writel(mipi_ctrl, base + CIF_MIPI_CTRL);
> +
> +	/* Configure Data Type and Virtual Channel */
> +	writel(CIF_MIPI_DATA_SEL_DT(in_fmt->mipi_dt) | CIF_MIPI_DATA_SEL_VC(0),
> +	       base + CIF_MIPI_IMG_DATA_SEL);
> +
> +	/* Clear MIPI interrupts */
> +	writel(~0, base + CIF_MIPI_ICR);
> +	/*
> +	 * Disable CIF_MIPI_ERR_DPHY interrupt here temporary for
> +	 * isp bus may be dead when switch isp.
> +	 */
> +	writel(CIF_MIPI_FRAME_END | CIF_MIPI_ERR_CSI | CIF_MIPI_ERR_DPHY |
> +	       CIF_MIPI_SYNC_FIFO_OVFLW(0x03) | CIF_MIPI_ADD_DATA_OVFLW,
> +	       base + CIF_MIPI_IMSC);
> +
> +	v4l2_dbg(1, rkisp1_debug, &dev->v4l2_dev, "\n  MIPI_CTRL 0x%08x\n"
> +		 "  MIPI_IMG_DATA_SEL 0x%08x\n"
> +		 "  MIPI_STATUS 0x%08x\n"
> +		 "  MIPI_IMSC 0x%08x\n",
> +		 readl(base + CIF_MIPI_CTRL),
> +		 readl(base + CIF_MIPI_IMG_DATA_SEL),
> +		 readl(base + CIF_MIPI_STATUS),
> +		 readl(base + CIF_MIPI_IMSC));
> +
> +	return 0;
> +}
> +
> +static int rkisp1_config_path(struct rkisp1_device *dev)
> +{
> +	int ret = 0;
> +	struct rkisp1_sensor_info *sensor = dev->active_sensor;
> +	u32 dpcl = readl(dev->base_addr + CIF_VI_DPCL);
> +
> +	if (sensor->mbus.type == V4L2_MBUS_BT656 ||
> +	    sensor->mbus.type == V4L2_MBUS_PARALLEL) {
> +		ret = rkisp1_config_dvp(dev);
> +		dpcl |= CIF_VI_DPCL_IF_SEL_PARALLEL;
> +	} else if (sensor->mbus.type == V4L2_MBUS_CSI2) {
> +		ret = rkisp1_config_mipi(dev);
> +		dpcl |= CIF_VI_DPCL_IF_SEL_MIPI;
> +	}
> +
> +	writel(dpcl, dev->base_addr + CIF_VI_DPCL);
> +
> +	return ret;
> +}
> +
> +static int rkisp1_config_cif(struct rkisp1_device *dev)
> +{
> +	int ret = 0;
> +	u32 cif_id;
> +
> +	v4l2_dbg(1, rkisp1_debug, &dev->v4l2_dev,
> +		 "SP state = %d, MP state = %d\n",
> +		 dev->stream[RKISP1_STREAM_SP].state,
> +		 dev->stream[RKISP1_STREAM_MP].state);
> +
> +	cif_id = readl(dev->base_addr + CIF_VI_ID);
> +	v4l2_dbg(1, rkisp1_debug, &dev->v4l2_dev, "CIF_ID 0x%08x\n", cif_id);
> +
> +	ret = rkisp1_config_isp(dev);
> +	if (ret < 0)
> +		return ret;
> +	ret = rkisp1_config_path(dev);
> +	if (ret < 0)
> +		return ret;
> +	rkisp1_config_ism(dev);
> +
> +	return 0;
> +}
> +
> +static int rkisp1_isp_stop(struct rkisp1_device *dev)
> +{
> +	void __iomem *base = dev->base_addr;
> +	u32 val;
> +
> +	v4l2_dbg(1, rkisp1_debug, &dev->v4l2_dev,
> +		 "SP state = %d, MP state = %d\n",
> +		 dev->stream[RKISP1_STREAM_SP].state,
> +		 dev->stream[RKISP1_STREAM_MP].state);
> +
> +	/*
> +	 * ISP(mi) stop in mi frame end -> Stop ISP(mipi) ->
> +	 * Stop ISP(isp) ->wait for ISP isp off
> +	 */
> +	/* stop and clear MI, MIPI, and ISP interrupts */
> +	writel(0, base + CIF_MIPI_IMSC);
> +	writel(~0, base + CIF_MIPI_ICR);
> +
> +	writel(0, base + CIF_ISP_IMSC);
> +	writel(~0, base + CIF_ISP_ICR);
> +
> +	writel(0, base + CIF_MI_IMSC);
> +	writel(~0, base + CIF_MI_ICR);
> +	val = readl(base + CIF_MIPI_CTRL);
> +	writel(val & (~CIF_MIPI_CTRL_OUTPUT_ENA), base + CIF_MIPI_CTRL);
> +	/* stop ISP */
> +	val = readl(base + CIF_ISP_CTRL);
> +	val &= ~(CIF_ISP_CTRL_ISP_INFORM_ENABLE | CIF_ISP_CTRL_ISP_ENABLE);
> +	writel(val, base + CIF_ISP_CTRL);
> +
> +	val = readl(base + CIF_ISP_CTRL);
> +	writel(val | CIF_ISP_CTRL_ISP_CFG_UPD, base + CIF_ISP_CTRL);
> +
> +	readx_poll_timeout(readl, base + CIF_ISP_RIS,
> +			   val, val & CIF_ISP_OFF, 20, 100);
> +	v4l2_dbg(1, rkisp1_debug, &dev->v4l2_dev,
> +		"state(MP:%d, SP:%d), MI_CTRL:%x, ISP_CTRL:%x, MIPI_CTRL:%x\n",
> +		 dev->stream[RKISP1_STREAM_SP].state,
> +		 dev->stream[RKISP1_STREAM_MP].state,
> +		 readl(base + CIF_MI_CTRL),
> +		 readl(base + CIF_ISP_CTRL),
> +		 readl(base + CIF_MIPI_CTRL));
> +
> +	writel(CIF_IRCL_MIPI_SW_RST | CIF_IRCL_ISP_SW_RST, base + CIF_IRCL);
> +	writel(0x0, base + CIF_IRCL);
> +
> +	return 0;
> +}
> +
> +static int rkisp1_isp_start(struct rkisp1_device *dev)
> +{
> +	struct rkisp1_sensor_info *sensor = dev->active_sensor;
> +	void __iomem *base = dev->base_addr;
> +	u32 val;
> +
> +	v4l2_dbg(1, rkisp1_debug, &dev->v4l2_dev,
> +		 "SP state = %d, MP state = %d\n",
> +		 dev->stream[RKISP1_STREAM_SP].state,
> +		 dev->stream[RKISP1_STREAM_MP].state);
> +
> +	/* Activate MIPI */
> +	if (sensor->mbus.type == V4L2_MBUS_CSI2) {
> +		val = readl(base + CIF_MIPI_CTRL);
> +		writel(val | CIF_MIPI_CTRL_OUTPUT_ENA, base + CIF_MIPI_CTRL);
> +	}
> +	/* Activate ISP */
> +	val = readl(base + CIF_ISP_CTRL);
> +	val |= CIF_ISP_CTRL_ISP_CFG_UPD | CIF_ISP_CTRL_ISP_ENABLE |
> +	       CIF_ISP_CTRL_ISP_INFORM_ENABLE;
> +	writel(val, base + CIF_ISP_CTRL);
> +
> +	/* TODO: Is the 1000us too long?
> +	 * CIF spec says to wait for sufficient time after enabling
> +	 * the MIPI interface and before starting the sensor output.
> +	 */
> +	usleep_range(1000, 1200);
> +
> +	v4l2_dbg(1, rkisp1_debug, &dev->v4l2_dev,
> +		 "SP state = %d, MP state = %d MI_CTRL 0x%08x\n"
> +		 "  ISP_CTRL 0x%08x MIPI_CTRL 0x%08x\n",
> +		 dev->stream[RKISP1_STREAM_SP].state,
> +		 dev->stream[RKISP1_STREAM_MP].state,
> +		 readl(base + CIF_MI_CTRL),
> +		 readl(base + CIF_ISP_CTRL),
> +		 readl(base + CIF_MIPI_CTRL));
> +
> +	return 0;
> +}
> +
> +static const struct ispsd_in_fmt rkisp1_isp_input_formats[] = {
> +	{
> +		.mbus_code	= MEDIA_BUS_FMT_SBGGR10_1X10,
> +		.fmt_type	= FMT_BAYER,
> +		.mipi_dt	= CIF_CSI2_DT_RAW10,
> +		.bayer_pat	= RAW_BGGR,
> +		.bus_width	= 10,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SRGGB10_1X10,
> +		.fmt_type	= FMT_BAYER,
> +		.mipi_dt	= CIF_CSI2_DT_RAW10,
> +		.bayer_pat	= RAW_RGGB,
> +		.bus_width	= 10,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SGBRG10_1X10,
> +		.fmt_type	= FMT_BAYER,
> +		.mipi_dt	= CIF_CSI2_DT_RAW10,
> +		.bayer_pat	= RAW_GBRG,
> +		.bus_width	= 10,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SGRBG10_1X10,
> +		.fmt_type	= FMT_BAYER,
> +		.mipi_dt	= CIF_CSI2_DT_RAW10,
> +		.bayer_pat	= RAW_GRBG,
> +		.bus_width	= 10,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SRGGB12_1X12,
> +		.fmt_type	= FMT_BAYER,
> +		.mipi_dt	= CIF_CSI2_DT_RAW12,
> +		.bayer_pat	= RAW_RGGB,
> +		.bus_width	= 12,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SBGGR12_1X12,
> +		.fmt_type	= FMT_BAYER,
> +		.mipi_dt	= CIF_CSI2_DT_RAW12,
> +		.bayer_pat	= RAW_BGGR,
> +		.bus_width	= 12,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SGBRG12_1X12,
> +		.fmt_type	= FMT_BAYER,
> +		.mipi_dt	= CIF_CSI2_DT_RAW12,
> +		.bayer_pat	= RAW_GBRG,
> +		.bus_width	= 12,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SGRBG12_1X12,
> +		.fmt_type	= FMT_BAYER,
> +		.mipi_dt	= CIF_CSI2_DT_RAW12,
> +		.bayer_pat	= RAW_GRBG,
> +		.bus_width	= 12,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SRGGB8_1X8,
> +		.fmt_type	= FMT_BAYER,
> +		.mipi_dt	= CIF_CSI2_DT_RAW8,
> +		.bayer_pat	= RAW_RGGB,
> +		.bus_width	= 8,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SBGGR8_1X8,
> +		.fmt_type	= FMT_BAYER,
> +		.mipi_dt	= CIF_CSI2_DT_RAW8,
> +		.bayer_pat	= RAW_BGGR,
> +		.bus_width	= 8,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SGBRG8_1X8,
> +		.fmt_type	= FMT_BAYER,
> +		.mipi_dt	= CIF_CSI2_DT_RAW8,
> +		.bayer_pat	= RAW_GBRG,
> +		.bus_width	= 8,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SGRBG8_1X8,
> +		.fmt_type	= FMT_BAYER,
> +		.mipi_dt	= CIF_CSI2_DT_RAW8,
> +		.bayer_pat	= RAW_GRBG,
> +		.bus_width	= 8,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_YUYV8_1X16,
> +		.fmt_type	= FMT_YUV,
> +		.mipi_dt	= CIF_CSI2_DT_YUV422_8b,
> +		.yuv_seq	= CIF_ISP_ACQ_PROP_YCBYCR,
> +		.bus_width	= 16,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_YVYU8_1X16,
> +		.fmt_type	= FMT_YUV,
> +		.mipi_dt	= CIF_CSI2_DT_YUV422_8b,
> +		.yuv_seq	= CIF_ISP_ACQ_PROP_YCRYCB,
> +		.bus_width	= 16,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_UYVY8_1X16,
> +		.fmt_type	= FMT_YUV,
> +		.mipi_dt	= CIF_CSI2_DT_YUV422_8b,
> +		.yuv_seq	= CIF_ISP_ACQ_PROP_CBYCRY,
> +		.bus_width	= 16,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_VYUY8_1X16,
> +		.fmt_type	= FMT_YUV,
> +		.mipi_dt	= CIF_CSI2_DT_YUV422_8b,
> +		.yuv_seq	= CIF_ISP_ACQ_PROP_CRYCBY,
> +		.bus_width	= 16,
> +	},
> +};
> +
> +static const struct ispsd_out_fmt rkisp1_isp_output_formats[] = {
> +	{
> +		.mbus_code	= MEDIA_BUS_FMT_YUYV8_2X8,
> +		.fmt_type	= FMT_YUV,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SRGGB12_1X12,
> +		.fmt_type	= FMT_BAYER,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SBGGR12_1X12,
> +		.fmt_type	= FMT_BAYER,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SGBRG12_1X12,
> +		.fmt_type	= FMT_BAYER,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SGRBG12_1X12,
> +		.fmt_type	= FMT_BAYER,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SRGGB10_1X10,
> +		.fmt_type	= FMT_BAYER,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SBGGR10_1X10,
> +		.fmt_type	= FMT_BAYER,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SGBRG10_1X10,
> +		.fmt_type	= FMT_BAYER,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SGRBG10_1X10,
> +		.fmt_type	= FMT_BAYER,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SRGGB8_1X8,
> +		.fmt_type	= FMT_BAYER,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SBGGR8_1X8,
> +		.fmt_type	= FMT_BAYER,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SGBRG8_1X8,
> +		.fmt_type	= FMT_BAYER,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SGRBG8_1X8,
> +		.fmt_type	= FMT_BAYER,
> +	},
> +};
> +
> +static const struct ispsd_in_fmt *find_in_fmt(u32 mbus_code)
> +{
> +	const struct ispsd_in_fmt *fmt;
> +	int i, array_size = ARRAY_SIZE(rkisp1_isp_input_formats);
> +
> +	for (i = 0; i < array_size; i++) {
> +		fmt = &rkisp1_isp_input_formats[i];
> +		if (fmt->mbus_code == mbus_code)
> +			return fmt;
> +	}
> +
> +	return NULL;
> +}
> +
> +static const struct ispsd_out_fmt *find_out_fmt(u32 mbus_code)
> +{
> +	const struct ispsd_out_fmt *fmt;
> +	int i, array_size = ARRAY_SIZE(rkisp1_isp_output_formats);
> +
> +	for (i = 0; i < array_size; i++) {
> +		fmt = &rkisp1_isp_output_formats[i];
> +		if (fmt->mbus_code == mbus_code)
> +			return fmt;
> +	}
> +
> +	return NULL;
> +}
> +
> +static int rkisp1_isp_sd_enum_mbus_code(struct v4l2_subdev *sd,
> +					struct v4l2_subdev_pad_config *cfg,
> +					struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	int i = code->index;
> +
> +	if (code->pad == RKISP1_ISP_PAD_SINK) {
> +		if (i >= ARRAY_SIZE(rkisp1_isp_input_formats))
> +			return -EINVAL;
> +		code->code = rkisp1_isp_input_formats[i].mbus_code;
> +	} else {
> +		if (i >= ARRAY_SIZE(rkisp1_isp_output_formats))
> +			return -EINVAL;
> +		code->code = rkisp1_isp_output_formats[i].mbus_code;
> +	}
> +
> +	return 0;
> +}
> +
> +#define sd_to_isp_sd(_sd) container_of(_sd, struct rkisp1_isp_subdev, sd)
> +static int rkisp1_isp_sd_get_fmt(struct v4l2_subdev *sd,
> +				 struct v4l2_subdev_pad_config *cfg,
> +				 struct v4l2_subdev_format *fmt)
> +{
> +	struct v4l2_mbus_framefmt *mf = &fmt->format;
> +	struct rkisp1_isp_subdev *isp_sd = sd_to_isp_sd(sd);
> +
> +	if ((fmt->pad != RKISP1_ISP_PAD_SINK) &&
> +	    (fmt->pad != RKISP1_ISP_PAD_SOURCE_PATH))
> +		return -EINVAL;
> +
> +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		mf = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
> +		fmt->format = *mf;
> +		return 0;
> +	}
> +
> +	if (fmt->pad == RKISP1_ISP_PAD_SINK) {
> +		*mf = isp_sd->in_frm;
> +	} else if (fmt->pad == RKISP1_ISP_PAD_SOURCE_PATH) {
> +		*mf = isp_sd->in_frm;
> +		mf->width = isp_sd->out_crop.width;
> +		mf->height = isp_sd->out_crop.height;
> +	}
> +	mf->field = V4L2_FIELD_NONE;
> +
> +	return 0;
> +}
> +
> +static void rkisp1_isp_sd_try_fmt(struct v4l2_subdev *sd,
> +				  unsigned int pad,
> +				  struct v4l2_mbus_framefmt *fmt)
> +{
> +	struct rkisp1_device *isp_dev = sd_to_isp_dev(sd);
> +	struct rkisp1_isp_subdev *isp_sd = &isp_dev->isp_sdev;
> +	const struct ispsd_in_fmt *in_fmt;
> +	const struct ispsd_out_fmt *out_fmt;
> +
> +	switch (pad) {
> +	case RKISP1_ISP_PAD_SINK:
> +		in_fmt = find_in_fmt(fmt->code);
> +		if (in_fmt) {
> +			fmt->code = in_fmt->mbus_code;
> +			fmt->colorspace = rkisp1_get_colorspace(in_fmt->fmt_type);

Just propagate the colorspace information from the incoming mediabus format. You
can't guess it based on the mbus_code.

> +		} else {
> +			fmt->code = MEDIA_BUS_FMT_SRGGB10_1X10;
> +			fmt->colorspace = V4L2_COLORSPACE_SRGB;
> +		}
> +		fmt->width  = clamp_t(u32, fmt->width, CIF_ISP_INPUT_W_MIN,
> +				      CIF_ISP_INPUT_W_MAX);
> +		fmt->height = clamp_t(u32, fmt->height, CIF_ISP_INPUT_H_MIN,
> +				      CIF_ISP_INPUT_H_MAX);
> +		break;
> +	case RKISP1_ISP_PAD_SOURCE_PATH:
> +		out_fmt = find_out_fmt(fmt->code);
> +		if (out_fmt) {
> +			fmt->code = out_fmt->mbus_code;
> +			fmt->colorspace = rkisp1_get_colorspace(out_fmt->fmt_type);

Ditto.

> +		} else {
> +			fmt->code = MEDIA_BUS_FMT_YUYV8_2X8;
> +			fmt->colorspace = V4L2_COLORSPACE_JPEG;
> +		}
> +		/* Size is set in s_selection */
> +		fmt->width  = isp_sd->out_crop.width;
> +		fmt->height = isp_sd->out_crop.height;
> +		break;
> +	}
> +
> +	fmt->field = V4L2_FIELD_NONE;
> +}
> +
> +static int rkisp1_isp_sd_set_fmt(struct v4l2_subdev *sd,
> +				 struct v4l2_subdev_pad_config *cfg,
> +				 struct v4l2_subdev_format *fmt)
> +{
> +	struct rkisp1_device *isp_dev = sd_to_isp_dev(sd);
> +	struct rkisp1_isp_subdev *isp_sd = &isp_dev->isp_sdev;
> +	struct v4l2_mbus_framefmt *mf = &fmt->format;
> +
> +	if ((fmt->pad != RKISP1_ISP_PAD_SINK) &&
> +	    (fmt->pad != RKISP1_ISP_PAD_SOURCE_PATH))
> +		return -EINVAL;
> +
> +	rkisp1_isp_sd_try_fmt(sd, fmt->pad, mf);
> +
> +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		struct v4l2_mbus_framefmt *try_mf;
> +
> +		mf = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
> +		*try_mf = *mf;
> +		return 0;
> +	}
> +
> +	if (fmt->pad == RKISP1_ISP_PAD_SINK) {
> +		const struct ispsd_in_fmt *in_fmt;
> +
> +		in_fmt = find_in_fmt(mf->code);
> +		isp_sd->in_fmt = *in_fmt;
> +		isp_sd->in_frm = *mf;
> +	} else if (fmt->pad == RKISP1_ISP_PAD_SOURCE_PATH) {
> +		const struct ispsd_out_fmt *out_fmt;
> +
> +		/* Ignore width/height */
> +		out_fmt = find_out_fmt(mf->code);
> +		isp_sd->out_fmt = *out_fmt;
> +	}
> +
> +	return 0;
> +}
> +
> +static void rkisp1_isp_sd_try_crop(struct v4l2_subdev *sd,
> +				  struct v4l2_subdev_pad_config *cfg,
> +				  struct v4l2_subdev_selection *sel)
> +{
> +	struct rkisp1_isp_subdev *isp_sd = sd_to_isp_sd(sd);
> +	struct v4l2_mbus_framefmt in_frm = isp_sd->in_frm;
> +	struct v4l2_rect in_crop = isp_sd->in_crop;
> +	struct v4l2_rect *input = &sel->r;
> +
> +	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		in_frm = *v4l2_subdev_get_try_format(sd, cfg, RKISP1_ISP_PAD_SINK);
> +		in_crop = *v4l2_subdev_get_try_crop(sd, cfg, RKISP1_ISP_PAD_SINK);
> +	}
> +
> +	input->left = ALIGN(input->left, 2);
> +	input->width = ALIGN(input->width, 2);
> +
> +	if (sel->pad == RKISP1_ISP_PAD_SINK) {
> +		input->left = clamp_t(u32, input->left, 0, in_frm.width);
> +		input->top = clamp_t(u32, input->top, 0, in_frm.height);
> +		input->width = clamp_t(u32, input->width, CIF_ISP_INPUT_W_MIN,
> +				in_frm.width - input->left);
> +		input->height = clamp_t(u32, input->height,
> +				CIF_ISP_INPUT_H_MIN,
> +				in_frm.height - input->top);
> +	} else if (sel->pad == RKISP1_ISP_PAD_SOURCE_PATH) {
> +		input->left = clamp_t(u32, input->left, 0, in_crop.width);
> +		input->top = clamp_t(u32, input->top, 0, in_crop.height);
> +		input->width = clamp_t(u32, input->width, CIF_ISP_OUTPUT_W_MIN,
> +				in_crop.width - input->left);
> +		input->height = clamp_t(u32, input->height, CIF_ISP_OUTPUT_H_MIN,
> +				in_crop.height - input->top);
> +	}
> +}
> +
> +static int rkisp1_isp_sd_get_selection(struct v4l2_subdev *sd,
> +				       struct v4l2_subdev_pad_config *cfg,
> +				       struct v4l2_subdev_selection *sel)
> +{
> +	struct rkisp1_isp_subdev *isp_sd = sd_to_isp_sd(sd);
> +
> +	if (sel->pad != RKISP1_ISP_PAD_SOURCE_PATH &&
> +	    sel->pad != RKISP1_ISP_PAD_SINK)
> +		return -EINVAL;

Just checking: the hardware can crop both on the sink (incoming) side and on
the source (outgoing) side? I would expect it to be just on the sink side.

> +
> +	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		struct v4l2_rect *try_sel;
> +
> +		try_sel = v4l2_subdev_get_try_crop(sd, cfg, sel->pad);
> +		sel->r = *try_sel;
> +		return 0;
> +	}
> +
> +	switch (sel->target) {
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +		if (sel->pad == RKISP1_ISP_PAD_SINK) {
> +			sel->r.height = isp_sd->in_frm.height;
> +			sel->r.width = isp_sd->in_frm.width;
> +			sel->r.left = 0;
> +			sel->r.top = 0;
> +		} else {
> +			sel->r = isp_sd->in_crop;
> +		}
> +		break;
> +	case V4L2_SEL_TGT_CROP:
> +		if (sel->pad == RKISP1_ISP_PAD_SINK)
> +			sel->r = isp_sd->in_crop;
> +		else
> +			sel->r = isp_sd->out_crop;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rkisp1_isp_sd_set_selection(struct v4l2_subdev *sd,
> +				       struct v4l2_subdev_pad_config *cfg,
> +				       struct v4l2_subdev_selection *sel)
> +{
> +	struct rkisp1_isp_subdev *isp_sd = sd_to_isp_sd(sd);
> +
> +	if (sel->pad != RKISP1_ISP_PAD_SOURCE_PATH &&
> +	    sel->pad != RKISP1_ISP_PAD_SINK)
> +		return -EINVAL;
> +	if (sel->target != V4L2_SEL_TGT_CROP)
> +		return -EINVAL;
> +
> +	rkisp1_isp_sd_try_crop(sd, cfg, sel);
> +
> +	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		struct v4l2_rect *try_sel;
> +
> +		try_sel = v4l2_subdev_get_try_crop(sd, cfg, sel->pad);
> +		*try_sel = sel->r;
> +		return 0;
> +	}
> +
> +	if (sel->pad == RKISP1_ISP_PAD_SINK)
> +		isp_sd->in_crop = sel->r;
> +	else
> +		isp_sd->out_crop = sel->r;
> +
> +	return 0;
> +}
> +
> +static int rkisp1_isp_sd_s_stream(struct v4l2_subdev *sd, int on)
> +{
> +	struct rkisp1_device *isp_dev = sd_to_isp_dev(sd);
> +	struct rkisp1_sensor_info *sensor;
> +	struct v4l2_subdev *sensor_sd;
> +	int ret = 0;
> +
> +	if (!on)
> +		return rkisp1_isp_stop(isp_dev);
> +
> +	sensor_sd = get_remote_sensor(sd);
> +	if (!sensor_sd)
> +		return -ENODEV;
> +
> +	sensor = sd_to_sensor(isp_dev, sensor_sd);
> +	/*
> +	 * Update sensor bus configuration. This is only effective
> +	 * for sensors chained off an external CSI2 PHY.
> +	 */
> +	ret = v4l2_subdev_call(sensor->sd, video, g_mbus_config,
> +			       &sensor->mbus);

What do you need g_mbus_config for? We have plans to remove this op in the
future.

> +	if (ret && ret != -ENOIOCTLCMD)
> +		return ret;
> +	isp_dev->active_sensor = sensor;
> +
> +	atomic_set(&isp_dev->isp_sdev.frm_sync_seq, 0);
> +	ret = rkisp1_config_cif(isp_dev);
> +	if (ret < 0)
> +		return ret;
> +
> +	return rkisp1_isp_start(isp_dev);
> +}
> +
> +static void rkisp1_config_clk(struct rkisp1_device *dev)
> +{
> +	u32 val = CIF_ICCL_ISP_CLK | CIF_ICCL_CP_CLK | CIF_ICCL_MRSZ_CLK |
> +		CIF_ICCL_SRSZ_CLK | CIF_ICCL_JPEG_CLK | CIF_ICCL_MI_CLK |
> +		CIF_ICCL_MIPI_CLK | CIF_ICCL_DCROP_CLK;
> +
> +	writel(val, dev->base_addr + CIF_ICCL);
> +}
> +
> +static int rkisp1_isp_sd_s_power(struct v4l2_subdev *sd, int on)
> +{
> +	struct rkisp1_device *dev = sd_to_isp_dev(sd);
> +	int ret;
> +
> +	v4l2_dbg(1, rkisp1_debug, &dev->v4l2_dev,
> +		 "streaming count %d, s_power: %d\n",
> +		 atomic_read(&dev->poweron_cnt), on);
> +
> +	if (on) {
> +		ret = pm_runtime_get_sync(dev->dev);
> +		if (ret < 0)
> +			return ret;
> +
> +		/* TODO: Reset the isp would clear iommu too */
> +		/* writel(CIF_IRCL_CIF_SW_RST, dev->base_addr + CIF_IRCL); */
> +		/* udelay(1); wait at least 10 module clock cycles */
> +
> +		rkisp1_config_clk(dev);
> +	} else {
> +		ret = pm_runtime_put(dev->dev);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rkisp1_subdev_link_validate(struct media_link *link)
> +{
> +	if (link->source->index == RKISP1_ISP_PAD_SINK_PARAMS)
> +		return 0;
> +
> +	return v4l2_subdev_link_validate(link);
> +}
> +
> +static int rkisp1_subdev_fmt_link_validate(struct v4l2_subdev *sd,
> +			     struct media_link *link,
> +			     struct v4l2_subdev_format *source_fmt,
> +			     struct v4l2_subdev_format *sink_fmt)
> +{
> +	if (source_fmt->format.code != sink_fmt->format.code)
> +		return -EINVAL;
> +
> +	/* Crop is available */
> +	if (source_fmt->format.width < sink_fmt->format.width ||
> +		source_fmt->format.height < sink_fmt->format.height)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static void
> +riksp1_isp_queue_event_sof(struct rkisp1_isp_subdev *isp)
> +{
> +	struct v4l2_event event = {
> +		.type = V4L2_EVENT_FRAME_SYNC,
> +		.u.frame_sync.frame_sequence =
> +			atomic_inc_return(&isp->frm_sync_seq) - 1,
> +	};
> +	v4l2_event_queue(isp->sd.devnode, &event);
> +}
> +
> +static int rkisp1_isp_sd_subs_evt(struct v4l2_subdev *sd, struct v4l2_fh *fh,
> +				  struct v4l2_event_subscription *sub)
> +{
> +	if (sub->type != V4L2_EVENT_FRAME_SYNC)
> +		return -EINVAL;
> +
> +	/* Line number. For now only zero accepted. */
> +	if (sub->id != 0)
> +		return -EINVAL;
> +
> +	return v4l2_event_subscribe(fh, sub, 0, NULL);
> +}
> +
> +static const struct v4l2_subdev_pad_ops rkisp1_isp_sd_pad_ops = {
> +	.enum_mbus_code = rkisp1_isp_sd_enum_mbus_code,
> +	.get_selection = rkisp1_isp_sd_get_selection,
> +	.set_selection = rkisp1_isp_sd_set_selection,
> +	.get_fmt = rkisp1_isp_sd_get_fmt,
> +	.set_fmt = rkisp1_isp_sd_set_fmt,
> +	.link_validate = rkisp1_subdev_fmt_link_validate,
> +};
> +
> +static const struct media_entity_operations rkisp1_isp_sd_media_ops = {
> +	.link_validate = rkisp1_subdev_link_validate,
> +};
> +
> +static const struct v4l2_subdev_video_ops rkisp1_isp_sd_video_ops = {
> +	.s_stream = rkisp1_isp_sd_s_stream,
> +};
> +
> +static const struct v4l2_subdev_core_ops rkisp1_isp_core_ops = {
> +	.subscribe_event = rkisp1_isp_sd_subs_evt,
> +	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
> +	.s_power = rkisp1_isp_sd_s_power,
> +};
> +
> +static struct v4l2_subdev_ops rkisp1_isp_sd_ops = {
> +	.core = &rkisp1_isp_core_ops,
> +	.video = &rkisp1_isp_sd_video_ops,
> +	.pad = &rkisp1_isp_sd_pad_ops,
> +};
> +
> +static void rkisp1_isp_sd_init_default_fmt(struct rkisp1_isp_subdev *isp_sd)
> +{
> +	struct v4l2_mbus_framefmt *in_frm = &isp_sd->in_frm;
> +	struct v4l2_rect *in_crop = &isp_sd->in_crop;
> +	struct v4l2_rect *out_crop = &isp_sd->out_crop;
> +	struct ispsd_in_fmt *in_fmt = &isp_sd->in_fmt;
> +	struct ispsd_out_fmt *out_fmt = &isp_sd->out_fmt;
> +
> +	*in_fmt = rkisp1_isp_input_formats[0];
> +	in_frm->width = RKISP1_DEFAULT_WIDTH;
> +	in_frm->height = RKISP1_DEFAULT_HEIGHT;
> +	in_frm->colorspace = rkisp1_get_colorspace(in_fmt->fmt_type);
> +	in_frm->code = in_fmt->mbus_code;
> +
> +	in_crop->width = in_frm->width;
> +	in_crop->height = in_frm->height;
> +	in_crop->left = 0;
> +	in_crop->top = 0;
> +
> +	/* propagate to source */
> +	*out_crop = *in_crop;
> +	*out_fmt = rkisp1_isp_output_formats[0];
> +}
> +
> +int rkisp1_register_isp_subdev(struct rkisp1_device *isp_dev,
> +			       struct v4l2_device *v4l2_dev)
> +{
> +	struct rkisp1_isp_subdev *isp_sdev = &isp_dev->isp_sdev;
> +	struct v4l2_subdev *sd = &isp_sdev->sd;
> +	int ret;
> +
> +	v4l2_subdev_init(sd, &rkisp1_isp_sd_ops);
> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
> +	sd->entity.ops = &rkisp1_isp_sd_media_ops;
> +	snprintf(sd->name, sizeof(sd->name), "rkisp1-isp-subdev");
> +
> +	isp_sdev->pads[RKISP1_ISP_PAD_SINK].flags =
> +		MEDIA_PAD_FL_SINK | MEDIA_PAD_FL_MUST_CONNECT;
> +	isp_sdev->pads[RKISP1_ISP_PAD_SINK_PARAMS].flags = MEDIA_PAD_FL_SINK;
> +	isp_sdev->pads[RKISP1_ISP_PAD_SOURCE_PATH].flags = MEDIA_PAD_FL_SOURCE;
> +	isp_sdev->pads[RKISP1_ISP_PAD_SOURCE_STATS].flags = MEDIA_PAD_FL_SOURCE;
> +	sd->entity.function = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
> +	ret = media_entity_pads_init(&sd->entity, RKISP1_ISP_PAD_MAX,
> +				     isp_sdev->pads);
> +	if (ret < 0)
> +		return ret;
> +
> +	sd->owner = THIS_MODULE;
> +	v4l2_set_subdevdata(sd, isp_dev);
> +
> +	sd->grp_id = GRP_ID_ISP;
> +	ret = v4l2_device_register_subdev(v4l2_dev, sd);
> +	if (ret < 0) {
> +		v4l2_err(sd, "Failed to register isp subdev\n");
> +		goto err_cleanup_media_entity;
> +	}
> +
> +	rkisp1_isp_sd_init_default_fmt(isp_sdev);
> +
> +	return 0;
> +err_cleanup_media_entity:
> +	media_entity_cleanup(&sd->entity);
> +	return ret;
> +}
> +
> +void rkisp1_unregister_isp_subdev(struct rkisp1_device *isp_dev)
> +{
> +	struct v4l2_subdev *sd = &isp_dev->isp_sdev.sd;
> +
> +	v4l2_device_unregister_subdev(sd);
> +	media_entity_cleanup(&sd->entity);
> +}
> +
> +static void rkisp1_hw_restart(struct rkisp1_device *dev)
> +{
> +	void __iomem *base = dev->base_addr;
> +	u32 val;
> +
> +	writel(CIF_IRCL_MIPI_SW_RST | CIF_IRCL_ISP_SW_RST | CIF_IRCL_MI_SW_RST,
> +	       base + CIF_IRCL);
> +	writel(0x0, base + CIF_IRCL);
> +
> +	/* enable mipi interrupts */
> +	writel(CIF_MIPI_FRAME_END | CIF_MIPI_ERR_CSI |
> +	       CIF_MIPI_ERR_DPHY | CIF_MIPI_SYNC_FIFO_OVFLW(0x03) |
> +	       CIF_MIPI_ADD_DATA_OVFLW, base + CIF_MIPI_IMSC);
> +
> +	writel(0x0, base + CIF_MI_MP_Y_OFFS_CNT_INIT);
> +	writel(0x0, base + CIF_MI_MP_CR_OFFS_CNT_INIT);
> +	writel(0x0, base + CIF_MI_MP_CB_OFFS_CNT_INIT);
> +	writel(0x0, base + CIF_MI_SP_Y_OFFS_CNT_INIT);
> +	writel(0x0, base + CIF_MI_SP_CR_OFFS_CNT_INIT);
> +	writel(0x0, base + CIF_MI_SP_CB_OFFS_CNT_INIT);
> +	val = readl(base + CIF_MI_CTRL);
> +	writel(CIF_MI_CTRL_INIT_OFFSET_EN | val, base + CIF_MI_CTRL);
> +
> +	/* Enable ISP */
> +	val = readl(base + CIF_ISP_CTRL);
> +	val |= CIF_ISP_CTRL_ISP_CFG_UPD | CIF_ISP_CTRL_ISP_ENABLE |
> +	       CIF_ISP_CTRL_ISP_INFORM_ENABLE;
> +	writel(val, base + CIF_ISP_CTRL);
> +	/* enable MIPI */
> +	val = readl(base + CIF_MIPI_CTRL);
> +	writel(val | CIF_MIPI_CTRL_OUTPUT_ENA, base + CIF_MIPI_CTRL);
> +}
> +
> +void rkisp1_mipi_isr(unsigned int mis, struct rkisp1_device *dev)
> +{
> +	struct v4l2_device *v4l2_dev = &dev->v4l2_dev;
> +	void __iomem *base = dev->base_addr;
> +	u32 val;
> +
> +	writel(~0, base + CIF_MIPI_ICR);
> +
> +	/*
> +	 * Disable DPHY errctrl interrupt, because this dphy
> +	 * erctrl signal is asserted until the next changes
> +	 * of line state. This time is may be too long and cpu
> +	 * is hold in this interrupt.
> +	 */
> +	if (mis & CIF_MIPI_ERR_CTRL(3)) {
> +		val = readl(base + CIF_MIPI_IMSC);
> +		/*TODO: 0xf - one bit per lane?*/
> +		writel(val | ~CIF_MIPI_ERR_CTRL(0x03), base + CIF_MIPI_IMSC);
> +		dev->isp_sdev.dphy_errctrl_disabled = true;
> +	}
> +
> +	/*
> +	 * Enable DPHY errctrl interrupt again, if mipi have receive
> +	 * the whole frame without any error.
> +	 */
> +	if (mis == CIF_MIPI_FRAME_END) {
> +		/*
> +		 * Enable DPHY errctrl interrupt again, if mipi have receive
> +		 * the whole frame without any error.
> +		 */
> +		if (dev->isp_sdev.dphy_errctrl_disabled) {
> +			val = readl(base + CIF_MIPI_IMSC);
> +			val |= CIF_MIPI_ERR_CTRL(0x03);
> +			writel(val, base + CIF_MIPI_IMSC);
> +			dev->isp_sdev.dphy_errctrl_disabled = false;
> +		}
> +	} else {
> +		v4l2_warn(v4l2_dev, "MIPI mis error: 0x%08x\n", mis);
> +	}
> +}
> +
> +void rkisp1_isp_isr(unsigned int isp_mis, struct rkisp1_device *dev)
> +{
> +	void __iomem *base = dev->base_addr;
> +	unsigned int isp_mis_tmp = 0;
> +	unsigned int isp_err = 0;
> +	u32 val;
> +
> +	if (isp_mis & CIF_ISP_V_START) {
> +		riksp1_isp_queue_event_sof(&dev->isp_sdev);
> +
> +		writel(CIF_ISP_V_START, base + CIF_ISP_ICR);
> +		isp_mis_tmp = readl(base + CIF_ISP_MIS);
> +		if (isp_mis_tmp & CIF_ISP_V_START)
> +			v4l2_err(&dev->v4l2_dev, "isp icr v_statr err: 0x%x\n",
> +				 isp_mis_tmp);
> +	}
> +
> +	if (isp_mis & (CIF_ISP_DATA_LOSS | CIF_ISP_PIC_SIZE_ERROR)) {
> +		if ((isp_mis & CIF_ISP_PIC_SIZE_ERROR)) {
> +			/* Clear pic_size_error */
> +			writel(CIF_ISP_PIC_SIZE_ERROR, base + CIF_ISP_ICR);
> +			isp_err = readl(base + CIF_ISP_ERR);
> +			v4l2_err(&dev->v4l2_dev,
> +				 "CIF_ISP_PIC_SIZE_ERROR (0x%08x)", isp_err);
> +			writel(isp_err, base + CIF_ISP_ERR_CLR);
> +		} else if ((isp_mis & CIF_ISP_DATA_LOSS)) {
> +			/* Clear data_loss */
> +			writel(CIF_ISP_DATA_LOSS, base + CIF_ISP_ICR);
> +			v4l2_err(&dev->v4l2_dev, "CIF_ISP_DATA_LOSS\n");
> +			writel(CIF_ISP_DATA_LOSS, base + CIF_ISP_ICR);
> +		}
> +
> +		/* TODO: Restart ISP safely */
> +		if (0) {
> +			val = readl(base + CIF_ISP_CTRL);
> +			val &= ~(CIF_ISP_CTRL_ISP_INFORM_ENABLE &
> +				CIF_ISP_CTRL_ISP_ENABLE);
> +			writel(val, base + CIF_ISP_CTRL);
> +			/* isp_update */
> +			val = readl(base + CIF_ISP_CTRL);
> +			writel(val | CIF_ISP_CTRL_ISP_CFG_UPD, base + CIF_ISP_CTRL);
> +			/*TODO: restart hw here is not safe, may cause machine hanging*/
> +			rkisp1_hw_restart(dev);
> +		}
> +	}
> +
> +	if (isp_mis & CIF_ISP_FRAME_IN) {
> +		writel(CIF_ISP_FRAME_IN, base + CIF_ISP_ICR);
> +		isp_mis_tmp = readl(base + CIF_ISP_MIS);
> +		if (isp_mis_tmp & CIF_ISP_FRAME_IN)
> +			v4l2_err(&dev->v4l2_dev, "isp icr frame_in err: 0x%x\n",
> +				 isp_mis_tmp);
> +	}
> +
> +	if (isp_mis & CIF_ISP_FRAME) {
> +		u32 isp_ris = 0;
> +		/* Clear Frame In (ISP) */
> +		writel(CIF_ISP_FRAME, base + CIF_ISP_ICR);
> +		isp_mis_tmp = readl(base + CIF_ISP_MIS);
> +		if (isp_mis_tmp & CIF_ISP_FRAME)
> +			v4l2_err(&dev->v4l2_dev,
> +				 "isp icr frame end err: 0x%x\n", isp_mis_tmp);
> +
> +		isp_ris = readl(base + CIF_ISP_RIS);
> +		if (isp_ris & (CIF_ISP_AWB_DONE | CIF_ISP_AFM_FIN |
> +				CIF_ISP_EXP_END | CIF_ISP_HIST_MEASURE_RDY))
> +			rkisp1_stats_isr(&dev->stats_vdev, isp_ris);
> +	}
> +
> +	/*
> +	 * Then update changed configs. Some of them involve
> +	 * lot of register writes. Do those only one per frame.
> +	 * Do the updates in the order of the processing flow.
> +	 */
> +	rkisp1_params_isr(&dev->params_vdev, isp_mis);
> +}
> diff --git a/drivers/media/platform/rockchip/isp1/rkisp1.h b/drivers/media/platform/rockchip/isp1/rkisp1.h
> new file mode 100644
> index 000000000000..506b1efd4de8
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/isp1/rkisp1.h
> @@ -0,0 +1,130 @@
> +/*
> + * Rockchip isp1 driver
> + *
> + * Copyright (C) 2017 Rockchip Electronics Co., Ltd.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#ifndef _RKISP1_H
> +#define _RKISP1_H
> +
> +#include <linux/platform_device.h>
> +#include <media/v4l2-fwnode.h>
> +#include "common.h"
> +#include "isp_stats.h"
> +#include "isp_params.h"
> +#include "capture.h"
> +
> +#define RKISP1_MAX_BUS_CLK	8
> +#define RKISP1_MAX_SENSOR	2
> +
> +struct rkisp1_ie_config {
> +	/* TODO: bit field ? */
> +	unsigned int effect;
> +};
> +
> +enum rkisp1_isp_pad {
> +	RKISP1_ISP_PAD_SINK,
> +	RKISP1_ISP_PAD_SINK_PARAMS,
> +	RKISP1_ISP_PAD_SOURCE_PATH,
> +	RKISP1_ISP_PAD_SOURCE_STATS,
> +	/* TODO: meta data pad ? */
> +	RKISP1_ISP_PAD_MAX
> +};
> +
> +struct rkisp1_isp_subdev {
> +	struct v4l2_subdev sd;
> +	struct media_pad pads[RKISP1_ISP_PAD_MAX];
> +	struct v4l2_ctrl_handler ctrl_handler;
> +	struct v4l2_mbus_framefmt in_frm;
> +	struct ispsd_in_fmt in_fmt;
> +	struct v4l2_rect in_crop;
> +	struct ispsd_out_fmt out_fmt;
> +	struct v4l2_rect out_crop;
> +	bool dphy_errctrl_disabled;
> +	atomic_t frm_sync_seq;
> +};
> +
> +struct rkisp1_sensor_info {
> +	struct v4l2_subdev *sd;
> +	struct v4l2_mbus_config mbus;
> +};
> +
> +struct rkisp1_device {
> +	void __iomem *base_addr;
> +	int irq;
> +	struct device *dev;
> +	struct clk *clks[RKISP1_MAX_BUS_CLK];
> +	int clk_size;
> +	struct v4l2_device v4l2_dev;
> +	struct media_device media_dev;
> +	struct v4l2_async_notifier notifier;
> +	struct v4l2_subdev *subdevs[RKISP1_SD_MAX];
> +	struct rkisp1_sensor_info *active_sensor;
> +	struct rkisp1_sensor_info sensors[RKISP1_MAX_SENSOR];
> +	int num_sensors;
> +	spinlock_t writel_verify_lock;
> +	struct rkisp1_isp_subdev isp_sdev;
> +	struct rkisp1_stream stream[RKISP1_MAX_STREAM];
> +	struct rkisp1_isp_stats_vdev stats_vdev;
> +	struct rkisp1_isp_params_vdev params_vdev;
> +	struct rkisp1_pipeline pipe;
> +	atomic_t poweron_cnt;
> +};
> +
> +/* Clean code starts from here */
> +
> +int rkisp1_register_isp_subdev(struct rkisp1_device *isp_dev,
> +			       struct v4l2_device *v4l2_dev);
> +
> +void rkisp1_unregister_isp_subdev(struct rkisp1_device *isp_dev);
> +
> +void rkisp1_mipi_isr(unsigned int mipi_mis, struct rkisp1_device *dev);
> +
> +void rkisp1_isp_isr(unsigned int isp_mis, struct rkisp1_device *dev);
> +
> +static inline struct rkisp1_device *sd_to_isp_dev(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd->v4l2_dev, struct rkisp1_device, v4l2_dev);
> +}
> +
> +static inline
> +struct ispsd_out_fmt *rkisp1_get_ispsd_out_fmt(struct rkisp1_device *isp_dev)
> +{
> +	return &isp_dev->isp_sdev.out_fmt;
> +}
> +
> +static inline
> +struct v4l2_rect *rkisp1_get_isp_sd_win(struct rkisp1_device *isp_dev)
> +{
> +	return &isp_dev->isp_sdev.out_crop;
> +}
> +
> +#endif /* _RKISP1_H */
> 

Regards,

	Hans
