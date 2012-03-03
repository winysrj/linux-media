Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34537 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab2CCWRO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Mar 2012 17:17:14 -0500
Received: by eekc41 with SMTP id c41so1024929eek.19
        for <linux-media@vger.kernel.org>; Sat, 03 Mar 2012 14:17:12 -0800 (PST)
Message-ID: <4F529864.2050409@gmail.com>
Date: Sat, 03 Mar 2012 23:17:08 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: sungchun.kang@samsung.com
CC: linux-media@vger.kernel.org, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, jonghun.han@samsung.com,
	sy0816.kang@samsung.com, khw0178.kim@samsung.com
Subject: Re: [PATCH] media: fimc-lite: Add new driver for camera interface
References: <005401cceba7$d4d75790$7e8606b0$%kang@samsung.com>
In-Reply-To: <005401cceba7$d4d75790$7e8606b0$%kang@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sungchun,

On 02/15/2012 07:05 AM, Sungchun Kang wrote:
> This patch adds support fimc-lite device which is a new device
> for camera interface on EXYNOS5 SoCs.

It's also available in the Exynos4 SoC and I was planning adding
it at the s5p-fimc driver eventually. It may take some time though
since it is not described in the datasheets I have.

> This device supports the followings as key feature.
>   1) Multiple input
>    - ITU-R BT 601 mode
>    - MIPI(CSI) mode
>   2) Multiple output
>    - DMA mode
>    - Direct FIFO mode
>
> Signed-off-by: Sungchun Kang<sungchun.kang@samsung.com>
>
> NOTE : This patch is based on
> "media: media-dev: Add media devices for EXYNOS5".
> ---
>   drivers/media/video/Kconfig                        |    3 +-
>   drivers/media/video/Makefile                       |    2 +-
>   drivers/media/video/exynos/Kconfig                 |   20 +
>   drivers/media/video/exynos/Makefile                |    4 +
>   drivers/media/video/exynos/fimc-lite/Kconfig       |   22 +
>   drivers/media/video/exynos/fimc-lite/Makefile      |    6 +
>   .../media/video/exynos/fimc-lite/fimc-lite-core.c  | 1921 ++++++++++++++++++++
>   .../media/video/exynos/fimc-lite/fimc-lite-core.h  |  310 ++++
>   .../media/video/exynos/fimc-lite/fimc-lite-reg.c   |  332 ++++
>   .../media/video/exynos/fimc-lite/fimc-lite-reg.h   |  135 ++
>   include/media/exynos_camera.h                      |   59 +
>   include/media/exynos_flite.h                       |   39 +
>   12 files changed, 2851 insertions(+), 2 deletions(-)
>   create mode 100644 drivers/media/video/exynos/Kconfig
>   create mode 100644 drivers/media/video/exynos/Makefile
>   create mode 100644 drivers/media/video/exynos/fimc-lite/Kconfig
>   create mode 100644 drivers/media/video/exynos/fimc-lite/Makefile
>   create mode 100644 drivers/media/video/exynos/fimc-lite/fimc-lite-core.c
>   create mode 100644 drivers/media/video/exynos/fimc-lite/fimc-lite-core.h
>   create mode 100644 drivers/media/video/exynos/fimc-lite/fimc-lite-reg.c
>   create mode 100644 drivers/media/video/exynos/fimc-lite/fimc-lite-reg.h
>   create mode 100644 include/media/exynos_camera.h
>   create mode 100644 include/media/exynos_flite.h
>
...
> +if VIDEO_EXYNOS_FIMC_LITE&&  VIDEOBUF2_CMA_PHYS
> +comment "Reserved memory configurations"
> +config VIDEO_SAMSUNG_MEMSIZE_FLITE0
> +	int "Memory size in kbytes for FLITE0"
> +	default "10240"
> +
> +config VIDEO_SAMSUNG_MEMSIZE_FLITE1
> +	int "Memory size in kbytes for FLITE1"
> +	default "10240"
> +endif

There is no VIDEOBUF2_CMA_PHYS allocator in the mainline and there 
should be no need for it. CMA should be used through the dma mapping
framework, see https://lkml.org/lkml/2012/2/22/309.

> diff --git a/drivers/media/video/exynos/fimc-lite/Makefile b/drivers/media/video/exynos/fimc-lite/Makefile
> new file mode 100644
> index 0000000..431d199
> --- /dev/null
> +++ b/drivers/media/video/exynos/fimc-lite/Makefile
> @@ -0,0 +1,6 @@
> +ifeq ($(CONFIG_ARCH_EXYNOS5),y)
> +fimc-lite-objs := fimc-lite-core.o fimc-lite-reg.o
> +else
> +fimc-lite-objs := fimc-lite-core.o fimc-lite-reg.o
> +endif
> +obj-$(CONFIG_VIDEO_EXYNOS_FIMC_LITE)	+= fimc-lite.o
> diff --git a/drivers/media/video/exynos/fimc-lite/fimc-lite-core.c b/drivers/media/video/exynos/fimc-lite/fimc-lite-core.c
> new file mode 100644
> index 0000000..9bb1c88
> --- /dev/null
> +++ b/drivers/media/video/exynos/fimc-lite/fimc-lite-core.c
> @@ -0,0 +1,1921 @@
> +/*
> + * Register interface file for Samsung Camera Interface (FIMC-Lite) driver
> + *
> + * Copyright (c) 2011 Samsung Electronics

2011 - 2012 ?

> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +*/
> +
> +#include<linux/module.h>
> +#include<linux/kernel.h>
> +#include<linux/errno.h>
> +#include<linux/interrupt.h>
> +#include<linux/device.h>
> +#include<linux/platform_device.h>
> +#include<linux/slab.h>
> +#include<linux/i2c.h>
> +#include<media/exynos_mc.h>
> +#include<media/videobuf2-dma-contig.h>
> +
> +#include "fimc-lite-core.h"
> +
> +#define MODULE_NAME			"exynos-fimc-lite"
> +#define DEFAULT_FLITE_SINK_WIDTH	800
> +#define DEFAULT_FLITE_SINK_HEIGHT	480
> +
> +static struct flite_fmt flite_formats[] = {
> +	{
> +		.name		= "YUV422 8-bit 1 plane(UYVY)",
> +		.pixelformat	= V4L2_PIX_FMT_UYVY,
> +		.depth		= { 16 },
> +		.code		= V4L2_MBUS_FMT_UYVY8_2X8,
> +		.fmt_reg	= FLITE_REG_CIGCTRL_YUV422_1P,
> +		.is_yuv		= 1,
> +	}, {
> +		.name		= "YUV422 8-bit 1 plane(VYUY)",
> +		.pixelformat	= V4L2_PIX_FMT_VYUY,
> +		.depth		= { 16 },
> +		.code		= V4L2_MBUS_FMT_VYUY8_2X8,
> +		.fmt_reg	= FLITE_REG_CIGCTRL_YUV422_1P,
> +		.is_yuv		= 1,
> +	}, {
> +		.name		= "YUV422 8-bit 1 plane(YUYV)",
> +		.pixelformat	= V4L2_PIX_FMT_YUYV,
> +		.depth		= { 16 },
> +		.code		= V4L2_MBUS_FMT_YUYV8_2X8,
> +		.fmt_reg	= FLITE_REG_CIGCTRL_YUV422_1P,
> +		.is_yuv		= 1,
> +	}, {
> +		.name		= "YUV422 8-bit 1 plane(YVYU)",
> +		.pixelformat	= V4L2_PIX_FMT_YVYU,
> +		.depth		= { 16 },
> +		.code		= V4L2_MBUS_FMT_YVYU8_2X8,
> +		.fmt_reg	= FLITE_REG_CIGCTRL_YUV422_1P,
> +		.is_yuv		= 1,
> +	}, {
> +		.name		= "RAW8(GRBG)",
> +		.pixelformat	= V4L2_PIX_FMT_SGRBG8,
> +		.depth		= { 8 },
> +		.code		= V4L2_MBUS_FMT_SGRBG8_1X8,
> +		.fmt_reg	= FLITE_REG_CIGCTRL_RAW8,
> +		.is_yuv		= 0,
> +	}, {
> +		.name		= "RAW10(GRBG)",
> +		.pixelformat	= V4L2_PIX_FMT_SGRBG10,
> +		.depth		= { 10 },
> +		.code		= V4L2_MBUS_FMT_SGRBG10_1X10,
> +		.fmt_reg	= FLITE_REG_CIGCTRL_RAW10,
> +		.is_yuv		= 0,
> +	}, {
> +		.name		= "RAW12(GRBG)",
> +		.pixelformat	= V4L2_PIX_FMT_SGRBG12,
> +		.depth		= { 12 },
> +		.code		= V4L2_MBUS_FMT_SGRBG12_1X12,
> +		.fmt_reg	= FLITE_REG_CIGCTRL_RAW12,
> +		.is_yuv		= 0,
> +	}, {
> +		.name		= "User Defined(JPEG)",
> +		.code		= V4L2_MBUS_FMT_JPEG_1X8,
> +		.depth		= { 8 },
> +		.fmt_reg	= FLITE_REG_CIGCTRL_USER(1),
> +		.is_yuv		= 0,
> +	},
> +};
> +
> +static struct flite_variant variant = {
> +	.max_w			= 8192,
> +	.max_h			= 8192,
> +	.align_win_offs_w	= 2,
> +	.align_out_w		= 8,
> +	.align_out_offs_w	= 8,
> +};
> +
> +static struct flite_fmt *get_format(int index)
> +{
> +	return&flite_formats[index];
> +}
...
> +
> +static int flite_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct flite_dev *flite = v4l2_get_subdevdata(sd);
> +	u32 index = flite->pdata->active_cam_index;
> +	struct s3c_platform_camera *cam = NULL;
> +	u32 int_src = 0;
> +	unsigned long flags;
> +	int ret = 0;
> +
> +	if (!(flite->output&  FLITE_OUTPUT_MEM)) {
> +		if (enable)
> +			flite_hw_reset(flite);
> +		cam = flite->pdata->cam[index];
> +	}
> +
> +	spin_lock_irqsave(&flite->slock, flags);
> +
> +	if (test_bit(FLITE_ST_SUSPEND,&flite->state))
> +		goto s_stream_unlock;
> +
> +	if (enable) {
> +		flite_hw_set_cam_channel(flite);
> +		flite_hw_set_cam_source_size(flite);
> +
> +		if (!(flite->output&  FLITE_OUTPUT_MEM)) {
> +			flite_info("@local out start@");
> +			flite_hw_set_camera_type(flite, cam);
> +			flite_hw_set_config_irq(flite, cam);
> +			if (cam->use_isp)
> +				flite_hw_set_output_dma(flite, false);
> +			int_src = FLITE_REG_CIGCTRL_IRQ_OVFEN0_ENABLE |
> +				FLITE_REG_CIGCTRL_IRQ_LASTEN0_ENABLE |
> +				FLITE_REG_CIGCTRL_IRQ_ENDEN0_DISABLE |
> +				FLITE_REG_CIGCTRL_IRQ_STARTEN0_DISABLE;
> +		} else {
> +			flite_info("@mem out start@");
> +			flite_hw_set_sensor_type(flite);
> +			flite_hw_set_inverse_polarity(flite);
> +			set_bit(FLITE_ST_PEND,&flite->state);
> +			flite_hw_set_output_dma(flite, true);
> +			int_src = FLITE_REG_CIGCTRL_IRQ_OVFEN0_ENABLE |
> +				FLITE_REG_CIGCTRL_IRQ_LASTEN0_ENABLE |
> +				FLITE_REG_CIGCTRL_IRQ_ENDEN0_ENABLE |
> +				FLITE_REG_CIGCTRL_IRQ_STARTEN0_DISABLE;
> +			flite_hw_set_out_order(flite);
> +			flite_hw_set_output_size(flite);
> +			flite_hw_set_dma_offset(flite);
> +		}
> +		ret = flite_hw_set_source_format(flite);
> +		if (unlikely(ret<  0))
> +			goto s_stream_unlock;
> +
> +		flite_hw_set_interrupt_source(flite, int_src);
> +		flite_hw_set_window_offset(flite);
> +		flite_hw_set_capture_start(flite);
> +
> +		set_bit(FLITE_ST_STREAM,&flite->state);
> +	} else {
> +		if (test_bit(FLITE_ST_STREAM,&flite->state)) {
> +			flite_hw_set_capture_stop(flite);
> +			spin_unlock_irqrestore(&flite->slock, flags);
> +			ret = wait_event_timeout(flite->irq_queue,
> +			!test_bit(FLITE_ST_STREAM,&flite->state), HZ/20);
> +			if (unlikely(!ret)) {
> +				v4l2_err(sd, "wait timeout\n");
> +				ret = -EBUSY;
> +			}
> +			return ret;
> +		} else {
> +			goto s_stream_unlock;
> +		}

You can drop the goto statement.

> +	}
> +s_stream_unlock:
> +	spin_unlock_irqrestore(&flite->slock, flags);
> +	return ret;
> +}
> +
> +static irqreturn_t flite_irq_handler(int irq, void *priv)
> +{
> +	struct flite_dev *flite = priv;
> +	struct flite_buffer *buf;
> +	u32 int_src = 0;
> +
> +	flite_hw_get_int_src(flite,&int_src);
> +	flite_hw_clear_irq(flite);
> +
> +	spin_lock(&flite->slock);
> +
> +	switch (int_src&  FLITE_REG_CISTATUS_IRQ_MASK) {
> +	case FLITE_REG_CISTATUS_IRQ_SRC_OVERFLOW:
> +		clear_bit(FLITE_ST_RUN,&flite->state);
> +		flite_err("overflow generated");
> +		break;
> +	case FLITE_REG_CISTATUS_IRQ_SRC_LASTCAPEND:
> +		flite_hw_set_last_capture_end_clear(flite);
> +		flite_info("last capture end");
> +		clear_bit(FLITE_ST_STREAM,&flite->state);
> +		wake_up(&flite->irq_queue);
> +		break;
> +	case FLITE_REG_CISTATUS_IRQ_SRC_FRMSTART:
> +		flite_dbg("frame start");
> +		break;
> +	case FLITE_REG_CISTATUS_IRQ_SRC_FRMEND:
> +		set_bit(FLITE_ST_RUN,&flite->state);
> +		flite_dbg("frame end");
> +		break;
> +	}
> +
> +	if (flite->output&  FLITE_OUTPUT_MEM) {
> +		if (!list_empty(&flite->active_buf_q)) {
> +			buf = active_queue_pop(flite);
> +			if (!test_bit(FLITE_ST_RUN,&flite->state)) {
> +				vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
> +				goto unlock;
> +			}
> +			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
> +			flite_dbg("done_index : %d", buf->vb.v4l2_buf.index);
> +		}
> +		if (!list_empty(&flite->pending_buf_q)) {
> +			buf = pending_queue_pop(flite);
> +			flite_hw_set_output_addr(flite,&buf->paddr,
> +					buf->vb.v4l2_buf.index);
> +			active_queue_add(flite, buf);
> +		}
> +		if (flite->active_buf_cnt == 0)
> +			clear_bit(FLITE_ST_RUN,&flite->state);
> +	}
> +unlock:
> +	spin_unlock(&flite->slock);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int flite_s_power(struct v4l2_subdev *sd, int on)
> +{
> +	struct flite_dev *flite = v4l2_get_subdevdata(sd);
> +	int ret = 0;
> +
> +	if (on) {
> +		pm_runtime_get_sync(&flite->pdev->dev);
> +		set_bit(FLITE_ST_POWER,&flite->state);
> +	} else {
> +		pm_runtime_put_sync(&flite->pdev->dev);

The runtime PM calls shouldn't be used from within the system sleep
helpers AFAIK, so there may be issues when calling flite_s_power
from within any system suspen or resume callback. And no, I don't
know how to handle this properly yet.

> +		clear_bit(FLITE_ST_POWER,&flite->state);
> +	}
> +
> +	return ret;
> +}
> +
> +static int flite_subdev_enum_mbus_code(struct v4l2_subdev *sd,
> +				       struct v4l2_subdev_fh *fh,
> +				       struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	if (code->index>= ARRAY_SIZE(flite_formats))
> +		return -EINVAL;
> +
> +	code->code = flite_formats[code->index].code;
> +
> +	return 0;
> +}
> +
> +static struct v4l2_mbus_framefmt *__flite_get_format(
> +		struct flite_dev *flite, struct v4l2_subdev_fh *fh,
> +		u32 pad, enum v4l2_subdev_format_whence which)
> +{
> +	if (which == V4L2_SUBDEV_FORMAT_TRY)
> +		return fh ? v4l2_subdev_get_try_format(fh, pad) : NULL;
> +	else
> +		return&flite->mbus_fmt;
> +}
> +
> +static void flite_try_format(struct flite_dev *flite, struct v4l2_subdev_fh *fh,
> +			     struct v4l2_mbus_framefmt *fmt,
> +			     enum v4l2_subdev_format_whence which)
> +{
> +	struct flite_fmt *ffmt;
> +	struct flite_frame *f =&flite->s_frame;

An empty line after variable declaration might be a good idea.

> +	ffmt = find_format(NULL,&fmt->code, 0);
> +	if (ffmt == NULL)
> +		ffmt =&flite_formats[1];
> +
> +	fmt->code = ffmt->code;
> +	fmt->width = clamp_t(u32, fmt->width, 1, variant.max_w);
> +	fmt->height = clamp_t(u32, fmt->height, 1, variant.max_h);
> +
> +	f->offs_h = f->offs_v = 0;
> +	f->width = f->o_width = fmt->width;
> +	f->height = f->o_height = fmt->height;
> +
> +	fmt->colorspace = V4L2_COLORSPACE_JPEG;
> +	fmt->field = V4L2_FIELD_NONE;
> +}
> +
> +static int flite_subdev_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
> +				struct v4l2_subdev_format *fmt)
> +{
> +	struct flite_dev *flite = v4l2_get_subdevdata(sd);
> +	struct v4l2_mbus_framefmt *mf;
> +
> +	mf = __flite_get_format(flite, fh, fmt->pad, fmt->which);
> +	if (mf == NULL) {
> +		flite_err("__flite_get_format is null");

How about using v4l2_err instead ? This apllies to most of other 
occurences as well.

> +		return -EINVAL;
> +	}
> +
> +	fmt->format = *mf;
> +
> +	if (fmt->pad != FLITE_PAD_SINK) {
> +		struct flite_frame *f =&flite->s_frame;
> +		fmt->format.width = f->width;
> +		fmt->format.height = f->height;
> +	}
> +
> +	return 0;
> +}
> +
> +
...
> +static int flite_subdev_registered(struct v4l2_subdev *sd)
> +{
> +	flite_dbg("");
> +	return 0;
> +}
> +
> +static void flite_subdev_unregistered(struct v4l2_subdev *sd)
> +{
> +	flite_dbg("");
> +}

Just remove those empty callbacs.

> +static const struct v4l2_subdev_internal_ops flite_v4l2_internal_ops = {
> +	.open = flite_init_formats,
> +	.close = flite_subdev_close,
> +	.registered = flite_subdev_registered,
> +	.unregistered = flite_subdev_unregistered,
> +};
> +
...
> +static int flite_config_camclk(struct flite_dev *flite,
> +		struct exynos_isp_info *isp_info, int i)
> +{
> +	struct clk *camclk;
> +	struct clk *srclk;
> +
> +	camclk = clk_get(&flite->pdev->dev, isp_info->cam_clk_name);
> +	if (IS_ERR_OR_NULL(camclk)) {
> +		flite_err("failed to get cam clk");
> +		return -ENXIO;
> +	}
> +	flite->sensor[i].camclk = camclk;
> +
> +	srclk = clk_get(&flite->pdev->dev, isp_info->cam_srclk_name);
> +	if (IS_ERR_OR_NULL(srclk)) {
> +		clk_put(camclk);
> +		flite_err("failed to get cam source clk\n");
> +		return -ENXIO;
> +	}
> +	clk_set_parent(camclk, srclk);
> +	clk_set_rate(camclk, isp_info->clk_frequency);
> +	clk_put(srclk);
> +
> +	flite->gsc_clk = clk_get(&flite->pdev->dev, "gscl");
> +	if (IS_ERR_OR_NULL(flite->gsc_clk)) {
> +		flite_err("failed to get gscl clk");
> +		return -ENXIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct v4l2_subdev *flite_register_sensor(struct flite_dev *flite,
> +		int i)
> +{
> +	struct exynos_platform_flite *pdata = flite->pdata;
> +	struct exynos_isp_info *isp_info = pdata->isp_info[i];
> +	struct exynos_md *mdev = flite->mdev;
> +	struct i2c_adapter *adapter;
> +	struct v4l2_subdev *sd = NULL;
> +
> +	adapter = i2c_get_adapter(isp_info->i2c_bus_num);
> +	if (!adapter)
> +		return NULL;
> +	sd = v4l2_i2c_new_subdev_board(&mdev->v4l2_dev, adapter,
> +				       isp_info->board_info, NULL);
> +	if (IS_ERR_OR_NULL(sd)) {
> +		v4l2_err(&mdev->v4l2_dev, "Failed to acquire subdev\n");
> +		return NULL;
> +	}
> +	v4l2_set_subdev_hostdata(sd,&flite->sensor[i]);
> +	sd->grp_id = SENSOR_GRP_ID;
> +
> +	v4l2_info(&mdev->v4l2_dev, "Registered sensor subdevice %s\n",
> +		  isp_info->board_info->type);
> +
> +	return sd;
> +}
> +
> +static int flite_register_sensor_entities(struct flite_dev *flite)
> +{
> +	struct exynos_platform_flite *pdata = flite->pdata;
> +	u32 num_clients = pdata->num_clients;
> +	int i;
> +
> +	for (i = 0; i<  num_clients; i++) {
> +		flite->sensor[i].pdata = pdata->isp_info[i];
> +		flite->sensor[i].sd = flite_register_sensor(flite, i);
> +		if (IS_ERR_OR_NULL(flite->sensor[i].sd)) {
> +			flite_err("failed to get register sensor");
> +			return -EINVAL;
> +		}
> +		flite->mdev->sensor_sd[i] = flite->sensor[i].sd;
> +	}
> +
> +	return 0;
> +}
> +
> +static int flite_create_subdev(struct flite_dev *flite, struct v4l2_subdev *sd)
> +{
> +	struct v4l2_device *v4l2_dev;
> +	int ret;
> +
> +	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	flite->pads[FLITE_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
> +	flite->pads[FLITE_PAD_SOURCE_PREV].flags = MEDIA_PAD_FL_SOURCE;
> +	flite->pads[FLITE_PAD_SOURCE_CAMCORD].flags = MEDIA_PAD_FL_SOURCE;
> +	flite->pads[FLITE_PAD_SOURCE_MEM].flags = MEDIA_PAD_FL_SOURCE;
> +
> +	ret = media_entity_init(&sd->entity, FLITE_PADS_NUM,
> +				flite->pads, 0);
> +	if (ret)
> +		goto err_ent;
> +
> +	sd->internal_ops =&flite_v4l2_internal_ops;
> +	sd->entity.ops =&flite_media_ops;
> +	sd->grp_id = FLITE_GRP_ID;
> +	v4l2_dev =&flite->mdev->v4l2_dev;
> +	flite->mdev->flite_sd[flite->id] = sd;
> +
> +	ret = v4l2_device_register_subdev(v4l2_dev, sd);
> +	if (ret)
> +		goto err_sub;
> +
> +	flite_init_formats(sd, NULL);
> +
> +	return 0;
> +
> +err_sub:
> +	media_entity_cleanup(&sd->entity);
> +err_ent:
> +	return ret;
> +}
> +
> +static int flite_create_link(struct flite_dev *flite)
> +{
> +	struct media_entity *source, *sink;
> +	struct exynos_platform_flite *pdata = flite->pdata;
> +	struct exynos_isp_info *isp_info;
> +	u32 num_clients = pdata->num_clients;
> +	int ret, i;
> +	enum cam_port id;
> +
> +	/* FIMC-LITE-SUBDEV ------>  FIMC-LITE-VIDEO (Always link enable) */
> +	source =&flite->sd_flite->entity;
> +	sink =&flite->vfd->entity;
> +	if (source&&  sink) {
> +		ret = media_entity_create_link(source, FLITE_PAD_SOURCE_MEM, sink,
> +				0, 0);
> +		if (ret) {
> +			flite_err("failed link flite-subdev to flite-video\n");
> +			return ret;
> +		}
> +	}
> +	/* link sensor to mipi-csis */
> +	for (i = 0; i<  num_clients; i++) {
> +		isp_info = pdata->isp_info[i];
> +		id = isp_info->cam_port;
> +		switch (isp_info->bus_type) {
> +		case CAM_TYPE_ITU:
> +			/*	SENSOR ------>  FIMC-LITE	*/
> +			source =&flite->sensor[i].sd->entity;
> +			sink =&flite->sd_flite->entity;
> +			if (source&&  sink) {
> +				ret = media_entity_create_link(source, 0,
> +					      sink, FLITE_PAD_SINK, 0);
> +				if (ret) {
> +					flite_err("failed link sensor to flite\n");
> +					return ret;
> +				}
> +			}
> +			break;
> +		case CAM_TYPE_MIPI:
> +			/*	SENSOR ------>  MIPI-CSI2	*/
> +			source =&flite->sensor[i].sd->entity;
> +			sink =&flite->sd_csis->entity;
> +			if (source&&  sink) {
> +				ret = media_entity_create_link(source, 0,
> +					      sink, CSIS_PAD_SINK, 0);
> +				if (ret) {
> +					flite_err("failed link sensor to csis\n");
> +					return ret;
> +				}
> +			}
> +			/*	MIPI-CSI2 ------>  FIMC-LITE	*/
> +			source =&flite->sd_csis->entity;
> +			sink =&flite->sd_flite->entity;
> +			if (source&&  sink) {
> +				ret = media_entity_create_link(source,
> +						CSIS_PAD_SOURCE,
> +						sink, FLITE_PAD_SINK, 0);
> +				if (ret) {
> +					flite_err("failed link csis to flite\n");
> +					return ret;
> +				}
> +			}
> +			break;
> +		}
> +	}
> +
> +	flite->input = FLITE_INPUT_NONE;
> +	flite->output = FLITE_OUTPUT_NONE;
> +
> +	return 0;
> +}
> +static int flite_register_video_device(struct flite_dev *flite)
> +{
> +	struct video_device *vfd;
> +	struct vb2_queue *q;
> +	int ret = -ENOMEM;
> +
> +	vfd = video_device_alloc();
> +	if (!vfd) {
> +		flite_info("Failed to allocate video device");
> +		return ret;
> +	}
> +
> +	snprintf(vfd->name, sizeof(vfd->name), "%s", dev_name(&flite->pdev->dev));
> +
> +	vfd->fops	=&flite_fops;
> +	vfd->ioctl_ops	=&flite_capture_ioctl_ops;
> +	vfd->v4l2_dev	=&flite->mdev->v4l2_dev;
> +	vfd->minor	= -1;
> +	vfd->release	= video_device_release;
> +	vfd->lock	=&flite->lock;
> +	video_set_drvdata(vfd, flite);
> +
> +	flite->vfd = vfd;
> +	flite->refcnt = 0;
> +	flite->reqbufs_cnt  = 0;
> +	INIT_LIST_HEAD(&flite->active_buf_q);
> +	INIT_LIST_HEAD(&flite->pending_buf_q);
> +
> +	q =&flite->vbq;
> +	memset(q, 0, sizeof(*q));
> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +	q->io_modes = VB2_MMAP | VB2_USERPTR;
> +	q->drv_priv = flite;
> +	q->ops =&flite_qops;
> +	q->mem_ops =&vb2_dma_contig_memops;
> +
> +	vb2_queue_init(q);
> +
> +	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		flite_err("failed to register video device");
> +		goto err_vfd_alloc;
> +	}
> +
> +	flite->vd_pad.flags = MEDIA_PAD_FL_SOURCE;
> +	ret = media_entity_init(&vfd->entity, 1,&flite->vd_pad, 0);
> +	if (ret) {
> +		flite_err("failed to initialize entity");
> +		goto err_unreg_video;
> +	}
> +
> +	flite_dbg("flite video-device driver registered as /dev/video%d", vfd->num);
> +
> +	return 0;
> +
> +err_unreg_video:
> +	video_unregister_device(vfd);
> +err_vfd_alloc:
> +	video_device_release(vfd);
> +
> +	return ret;
> +}
> +
> +static int flite_get_md_callback(struct device *dev, void *p)
> +{
> +	struct exynos_md **md_list = p;
> +	struct exynos_md *md = NULL;
> +
> +	md = dev_get_drvdata(dev);
> +
> +	if (md)
> +		*(md_list + md->id) = md;
> +
> +	return 0; /* non-zero value stops iteration */
> +}
> +
> +static struct exynos_md *flite_get_capture_md(enum mdev_node node)
> +{
> +	struct device_driver *drv;
> +	struct exynos_md *md[MDEV_MAX_NUM] = {NULL,};
> +	int ret;
> +
> +	drv = driver_find(MDEV_MODULE_NAME,&platform_bus_type);
> +	if (!drv)
> +		return ERR_PTR(-ENODEV);
> +
> +	ret = driver_for_each_device(drv, NULL,&md[0],
> +				     flite_get_md_callback);
> +	put_driver(drv);
> +
> +	return ret ? NULL : md[node];
> +
> +}
> +
> +static void flite_destroy_subdev(struct flite_dev *flite)
> +{
> +	struct v4l2_subdev *sd = flite->sd_flite;
> +
> +	if (!sd)
> +		return;
> +	media_entity_cleanup(&sd->entity);
> +	v4l2_device_unregister_subdev(sd);
> +	kfree(sd);
> +	sd = NULL;

It doesn't make sense to clear the local variable here, instead you
should do:
	flite->sd_flite = NULL;

I've fixed that bug in this commit:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=64c570f505a0eac4914402bb7832d019c44eabd8

> +}
> +
> +void flite_unregister_device(struct flite_dev *flite)
> +{
> +	struct video_device *vfd = flite->vfd;
> +
> +	if (vfd) {
> +		media_entity_cleanup(&vfd->entity);
> +		/* Can also be called if video device was
> +		   not registered */
> +		video_unregister_device(vfd);
> +	}
> +	flite_destroy_subdev(flite);
> +}
> +
> +static int flite_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct v4l2_subdev *sd = platform_get_drvdata(pdev);

That's
	struct v4l2_subdev *sd = dev_get_drvdata(dev);

> +	struct flite_dev *flite = v4l2_get_subdevdata(sd);
> +
> +	if (test_bit(FLITE_ST_STREAM,&flite->state))
> +		flite_s_stream(sd, false);
> +	if (test_bit(FLITE_ST_POWER,&flite->state))
> +		flite_s_power(sd, false);
> +
> +	set_bit(FLITE_ST_SUSPEND,&flite->state);
> +
> +	return 0;
> +}
> +
> +static int flite_resume(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct v4l2_subdev *sd = platform_get_drvdata(pdev);

Ditto.

> +	struct flite_dev *flite = v4l2_get_subdevdata(sd);
> +
> +	if (test_bit(FLITE_ST_POWER,&flite->state))
> +		flite_s_power(sd, true);
> +	if (test_bit(FLITE_ST_STREAM,&flite->state))
> +		flite_s_stream(sd, true);
> +
> +	clear_bit(FLITE_ST_SUSPEND,&flite->state);
> +
> +	return 0;
> +}
> +
> +static int flite_runtime_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct v4l2_subdev *sd = platform_get_drvdata(pdev);

Dito.

> +	struct flite_dev *flite = v4l2_get_subdevdata(sd);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&flite->slock, flags);
> +	set_bit(FLITE_ST_SUSPEND,&flite->state);
> +	spin_unlock_irqrestore(&flite->slock, flags);
> +
> +	return 0;
> +}
> +
> +static int flite_runtime_resume(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct v4l2_subdev *sd = platform_get_drvdata(pdev);

Ditto.

> +	struct flite_dev *flite = v4l2_get_subdevdata(sd);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&flite->slock, flags);
> +	clear_bit(FLITE_ST_SUSPEND,&flite->state);
> +	spin_unlock_irqrestore(&flite->slock, flags);
> +
> +	return 0;
> +}
> +
> +static struct v4l2_subdev_core_ops flite_core_ops = {
> +	.s_power = flite_s_power,
> +};
> +
> +static struct v4l2_subdev_video_ops flite_video_ops = {
> +	.s_stream	= flite_s_stream,
> +};
> +
> +static struct v4l2_subdev_ops flite_subdev_ops = {
> +	.core	=&flite_core_ops,
> +	.pad	=&flite_pad_ops,
> +	.video	=&flite_video_ops,
> +};
> +
> +static int flite_probe(struct platform_device *pdev)
> +{
> +	struct resource *mem_res;
> +	struct resource *regs_res;
> +	struct flite_dev *flite;
> +	struct v4l2_subdev *sd;
> +	int ret = -ENODEV;
> +	struct exynos_isp_info *isp_info;
> +	int i;
> +
> +	if (!pdev->dev.platform_data) {
> +		dev_err(&pdev->dev, "platform data is NULL\n");
> +		return -EINVAL;
> +	}
> +
> +	flite = kzalloc(sizeof(struct flite_dev), GFP_KERNEL);
> +	if (!flite)
> +		return -ENOMEM;
> +
> +	flite->pdev = pdev;
> +	flite->pdata = pdev->dev.platform_data;
> +
> +	flite->id = pdev->id;
> +
> +	init_waitqueue_head(&flite->irq_queue);
> +	spin_lock_init(&flite->slock);
> +
> +	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!mem_res) {
> +		dev_err(&pdev->dev, "Failed to get io memory region\n");
> +		goto err_flite;
> +	}
> +
> +	regs_res = request_mem_region(mem_res->start, resource_size(mem_res),
> +				      pdev->name);
> +	if (!regs_res) {
> +		dev_err(&pdev->dev, "Failed to request io memory region\n");
> +		goto err_resource;
> +	}
> +
> +	flite->regs_res = regs_res;
> +	flite->regs = ioremap(mem_res->start, resource_size(mem_res));
> +	if (!flite->regs) {
> +		dev_err(&pdev->dev, "Failed to remap io region\n");
> +		goto err_reg_region;
> +	}
> +
> +	flite->irq = platform_get_irq(pdev, 0);
> +	if (flite->irq<  0) {
> +		dev_err(&pdev->dev, "Failed to get irq\n");
> +		goto err_reg_unmap;
> +	}
> +
> +	ret = request_irq(flite->irq, flite_irq_handler, 0, dev_name(&pdev->dev), flite);
> +	if (ret) {
> +		dev_err(&pdev->dev, "request_irq failed\n");
> +		goto err_reg_unmap;
> +	}

Please consider using device managed resources, here is my patch
converting the s5p-fimc driver:
http://git.infradead.org/users/kmpark/linux-samsung/commitdiff/154ae8a99869da241128139e004bdec60b190b43

It saves you trouble with the error paths.

> +	sd = kzalloc(sizeof(*sd), GFP_KERNEL);
> +	if (!sd)
> +	       goto err_irq;
> +
> +	v4l2_subdev_init(sd,&flite_subdev_ops);
> +	snprintf(sd->name, sizeof(sd->name), "flite-subdev.%d", flite->id);
> +
> +	flite->sd_flite = sd;
> +	v4l2_set_subdevdata(flite->sd_flite, flite);
> +
> +	mutex_init(&flite->lock);
> +	flite->mdev = flite_get_capture_md(MDEV_CAPTURE);
> +	if (IS_ERR_OR_NULL(flite->mdev))
> +		goto err_irq;

How are you making sure the media device driver is already probed 
at this point ?

> +	flite_dbg("mdev = 0x%08x", (u32)flite->mdev);
> +
> +	ret = flite_register_video_device(flite);
> +	if (ret)
> +		goto err_irq;

Not all resources are initialized at this point so it's to early
to register the video node. You need to move that after the allocator
initialization. The driver would crash the system if the video node
is opened right after it is registered, and it is not unusual at all.

> +	/* Get mipi-csis subdev ptr using mdev */
> +	flite->sd_csis = flite->mdev->csis_sd[flite->id];
> +
> +	for (i = 0; i<  flite->pdata->num_clients; i++) {
> +		isp_info = flite->pdata->isp_info[i];
> +		ret = flite_config_camclk(flite, isp_info, i);
> +		if (ret) {
> +			flite_err("failed setup cam clk");
> +			goto err_vfd_alloc;
> +		}
> +	}
> +
> +	ret = flite_register_sensor_entities(flite);
> +	if (ret) {
> +		flite_err("failed register sensor entities");
> +		goto err_clk;
> +	}

ARGH. Please consider moving that to the media device driver probe().

> +	ret = flite_create_subdev(flite, sd);
> +	if (ret) {
> +		flite_err("failed create subdev");
> +		goto err_clk;
> +	}
> +
> +	ret = flite_create_link(flite);
> +	if (ret) {
> +		flite_err("failed create link");
> +		goto err_entity;
> +	}
> +
> +	flite->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	if (IS_ERR(flite->alloc_ctx)) {
> +		ret = PTR_ERR(flite->alloc_ctx);
> +		goto err_entity;
> +	}
> +
> +	platform_set_drvdata(flite->pdev, flite->sd_flite);
> +	pm_runtime_enable(&pdev->dev);
> +
> +	flite_info("FIMC-LITE%d probe success", pdev->id);
> +
> +	return 0;
> +
> +err_entity:
> +	media_entity_cleanup(&sd->entity);
> +err_clk:
> +	for (i = 0; i<  flite->pdata->num_clients; i++)
> +		clk_put(flite->sensor[i].camclk);
> +err_vfd_alloc:
> +	media_entity_cleanup(&flite->vfd->entity);
> +	video_device_release(flite->vfd);
> +err_irq:
> +	free_irq(flite->irq, flite);
> +err_reg_unmap:
> +	iounmap(flite->regs);
> +err_reg_region:
> +	release_mem_region(regs_res->start, resource_size(regs_res));
> +err_resource:
> +	release_resource(flite->regs_res);
> +	kfree(flite->regs_res);
> +err_flite:
> +	kfree(flite);
> +	return ret;
> +}
> +
> +static int flite_remove(struct platform_device *pdev)
> +{
> +	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
> +	struct flite_dev *flite = v4l2_get_subdevdata(sd);
> +	struct resource *res = flite->regs_res;
> +
> +	flite_s_power(flite->sd_flite, 0);
> +	flite_subdev_close(sd, NULL);
> +	flite_unregister_device(flite);
> +
> +	vb2_dma_contig_cleanup_ctx(flite->alloc_ctx);
> +
> +	pm_runtime_disable(&pdev->dev);
> +	free_irq(flite->irq, flite);
> +	iounmap(flite->regs);
> +	release_mem_region(res->start, resource_size(res));
> +	kfree(flite);
> +
> +	return 0;
> +}
> +
> +
> +static const struct dev_pm_ops flite_pm_ops = {
> +	.suspend		= flite_suspend,
> +	.resume			= flite_resume,
> +	.runtime_suspend	= flite_runtime_suspend,
> +	.runtime_resume		= flite_runtime_resume,
> +};
> +
> +static struct platform_driver flite_driver = {
> +	.probe		= flite_probe,
> +	.remove	= __devexit_p(flite_remove),
> +	.driver = {
> +		.name	= MODULE_NAME,
> +		.owner	= THIS_MODULE,
> +		.pm	=&flite_pm_ops,
> +	}
> +};
> +
> +static int __init flite_init(void)
> +{
> +	int ret = platform_driver_register(&flite_driver);
> +	if (ret)
> +		flite_err("platform_driver_register failed: %d", ret);
> +	return ret;
> +}
> +
> +static void __exit flite_exit(void)
> +{
> +	platform_driver_unregister(&flite_driver);
> +}
> +module_init(flite_init);
> +module_exit(flite_exit);

You could also use module_platform_device().

> +
> +MODULE_AUTHOR("Sky Kang<sungchun.kang@samsung.com>");

Is everything correct here ?

> +MODULE_DESCRIPTION("Exynos FIMC-Lite driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/video/exynos/fimc-lite/fimc-lite-core.h b/drivers/media/video/exynos/fimc-lite/fimc-lite-core.h
> new file mode 100644
> index 0000000..d6da3b0
> --- /dev/null
> +++ b/drivers/media/video/exynos/fimc-lite/fimc-lite-core.h
> @@ -0,0 +1,310 @@
> +/*
> + * Register interface file for Samsung Camera Interface (FIMC-Lite) driver
> + *
> + * Copyright (c) 2011 Samsung Electronics
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +*/
> +#ifndef FLITE_CORE_H_
> +#define FLITE_CORE_H_
> +
> +/* #define DEBUG */
> +#include<linux/sched.h>
> +#include<linux/spinlock.h>
> +#include<linux/types.h>
> +#include<linux/videodev2.h>
> +#include<linux/io.h>
> +#include<linux/delay.h>
> +#include<linux/interrupt.h>
> +#include<linux/pm_runtime.h>
> +#include<media/videobuf2-core.h>
> +#include<media/v4l2-ctrls.h>
> +#include<media/v4l2-device.h>
> +#include<media/v4l2-mediabus.h>
> +#include<media/exynos_flite.h>
> +#include<media/v4l2-ioctl.h>
> +#include<media/exynos_mc.h>
> +#include "fimc-lite-reg.h"
> +
> +#define flite_info(fmt, args...) \
> +	printk(KERN_INFO "[INFO]%s:%d: "fmt "\n", __func__, __LINE__, ##args)
> +#define flite_err(fmt, args...) \
> +	printk(KERN_ERR "[ERROR]%s:%d: "fmt "\n", __func__, __LINE__, ##args)
> +#define flite_warn(fmt, args...) \
> +	printk(KERN_WARNING "[WARNNING]%s:%d: "fmt "\n", __func__, __LINE__, ##args)
> +
> +#ifdef DEBUG
> +#define flite_dbg(fmt, args...) \
> +	printk(KERN_DEBUG "[DEBUG]%s:%d: " fmt "\n", __func__, __LINE__, ##args)
> +#else
> +#define flite_dbg(fmt, args...)
> +#endif
> +
> +#define FLITE_MAX_RESET_READY_TIME	20 /* 100ms */
> +#define FLITE_MAX_CTRL_NUM		1
> +#define FLITE_MAX_OUT_BUFS		1
> +
> +enum flite_input_entity {
> +	FLITE_INPUT_NONE,
> +	FLITE_INPUT_SENSOR,
> +	FLITE_INPUT_CSIS,
> +};
> +
> +enum flite_output_entity {
> +	FLITE_OUTPUT_NONE = (1<<  0),
> +	FLITE_OUTPUT_GSC = (1<<  1),
> +	FLITE_OUTPUT_MEM = (1<<  2),
> +};
> +
> +enum flite_out_path {
> +	FLITE_ISP,
> +	FLITE_DMA,
> +};
> +
> +enum flite_state {
> +	FLITE_ST_OPEN,
> +	FLITE_ST_SUBDEV_OPEN,
> +	FLITE_ST_POWER,
> +	FLITE_ST_STREAM,
> +	FLITE_ST_SUSPEND,
> +	FLITE_ST_RUN,
> +	FLITE_ST_PIPE_STREAM,
> +	FLITE_ST_PEND,
> +};
> +
> +#define flite_active(dev) test_bit(FLITE_ST_RUN,&(dev)->state)
> +#define ctrl_to_dev(__ctrl) \
> +	container_of((__ctrl)->handler, struct flite_dev, ctrl_handler)
> +#define flite_get_frame(flite, pad)\
> +	((pad == FLITE_PAD_SINK) ?&flite->s_frame :&flite->d_frame)
> +
> +struct flite_variant {
> +	u16 max_w;
> +	u16 max_h;
> +	u16 align_win_offs_w;
> +	u16 align_out_w;
> +	u16 align_out_offs_w;
> +};
> +
> +/**
> +  * struct flite_fmt - driver's color format data
> +  * @name :	format description
> +  * @code :	Media Bus pixel code
> +  * @fmt_reg :	H/W bit for setting format
> +  */
> +struct flite_fmt {
> +	char				*name;
> +	u32				pixelformat;
> +	enum v4l2_mbus_pixelcode	code;
> +	u32				fmt_reg;
> +	u32				is_yuv;
> +	u8				depth[VIDEO_MAX_PLANES];
> +};
> +
> +struct flite_addr {
> +	dma_addr_t	y;
> +};
> +
> +/**
> + * struct flite_frame - source/target frame properties
> + * @o_width:	buffer width as set by S_FMT
> + * @o_height:	buffer height as set by S_FMT
> + * @width:	image pixel width
> + * @height:	image pixel weight
> + * @offs_h:	image horizontal pixel offset
> + * @offs_v:	image vertical pixel offset
> + */
> +
> +/*
> +		o_width
> +	---------------------
> +	|    width(cropped) |
> +	|	-----	    |
> +	|offs_h |   |	    |
> +	|	-----	    |
> +	|		    |
> +	---------------------
> + */
> +struct flite_frame {
> +	u32 o_width;
> +	u32 o_height;
> +	u32 width;
> +	u32 height;
> +	u32 offs_h;
> +	u32 offs_v;
> +	unsigned long payload;
> +	struct flite_addr addr;
> +	struct flite_fmt *fmt;
> +};
> +
> +struct flite_pipeline {
> +	struct media_pipeline *pipe;
> +	struct v4l2_subdev *flite;
> +	struct v4l2_subdev *csis;
> +	struct v4l2_subdev *sensor;
> +};
> +
> +struct flite_sensor_info {
> +	struct exynos_isp_info *pdata;
> +	struct v4l2_subdev *sd;
> +	struct clk *camclk;
> +};
> +
> +/**
> +  * struct flite_dev - top structure of FIMC-Lite device
> +  * @pdev :	pointer to the FIMC-Lite platform device
> +  * @lock :	the mutex protecting this data structure
> +  * @sd :	subdevice pointer of FIMC-Lite
> +  * @fmt :	Media bus format of FIMC-Lite
> +  * @regs_res :	ioremapped regs of FIMC-Lite
> +  * @regs :	SFR of FIMC-Lite
> +  */
> +struct flite_dev {
> +	struct platform_device		*pdev;
> +	struct exynos_platform_flite	*pdata; /* depended on isp */
> +	spinlock_t			slock;
> +	struct v4l2_subdev		*sd_flite;
> +	struct exynos_md		*mdev;
> +	struct v4l2_subdev		*sd_csis;
> +	struct flite_sensor_info	sensor[SENSOR_MAX_ENTITIES];
> +	struct media_pad		pads[FLITE_PADS_NUM];
> +	struct media_pad		vd_pad;
> +	struct flite_frame		d_frame;
> +	struct mutex			lock;
> +	struct video_device		*vfd;
> +	int				refcnt;
> +	u32				reqbufs_cnt;
> +	struct vb2_queue		vbq;
> +	struct vb2_alloc_ctx		*alloc_ctx;
> +	const struct flite_vb2		*vb2;
> +	struct flite_pipeline		pipeline;
> +	bool				ctrls_rdy;
> +	struct list_head		pending_buf_q;
> +	struct list_head		active_buf_q;
> +	int				active_buf_cnt;
> +	int				pending_buf_cnt;
> +	int				buf_index;
> +	struct clk			*gsc_clk;
> +	struct v4l2_mbus_framefmt	mbus_fmt;
> +	struct flite_frame		s_frame;
> +	struct resource			*regs_res;
> +	void __iomem			*regs;
> +	int				irq;
> +	unsigned long			state;
> +	u32				out_path;
> +	wait_queue_head_t		irq_queue;
> +	u32				id;
> +	enum flite_input_entity		input;
> +	enum flite_output_entity	output;
> +};
...
> diff --git a/drivers/media/video/exynos/fimc-lite/fimc-lite-reg.h b/drivers/media/video/exynos/fimc-lite/fimc-lite-reg.h
...
> +/* Camera General Purpose */
> +#define FLITE_REG_CIGENERAL				0xFC

In the kernel using lower case for hex numbers is preferred. 

> +#define FLITE_REG_CIGENERAL_CAM_A			(0<<  0)
> +#define FLITE_REG_CIGENERAL_CAM_B			(1<<  0)
> +
> +#endif /* FIMC_LITE_REG_H */
> diff --git a/include/media/exynos_camera.h b/include/media/exynos_camera.h
> new file mode 100644
> index 0000000..e7fafd1
> --- /dev/null
> +++ b/include/media/exynos_camera.h
> @@ -0,0 +1,59 @@
> +/* include/media/exynos_camera.h
> + *
> + * Copyright (c) 2011 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * The header file related to camera
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef EXYNOS_CAMERA_H_
> +#define EXYNOS_CAMERA_H_
> +
> +#include<media/exynos_mc.h>
> +
> +enum cam_bus_type {
> +	CAM_TYPE_ITU = 1,
> +	CAM_TYPE_MIPI,
> +};
> +
> +enum cam_port {
> +	CAM_PORT_A,
> +	CAM_PORT_B,
> +};
> +
> +#define CAM_CLK_INV_PCLK	(1<<  0)
> +#define CAM_CLK_INV_VSYNC	(1<<  1)
> +#define CAM_CLK_INV_HREF	(1<<  2)
> +#define CAM_CLK_INV_HSYNC	(1<<  3)

Please consider using the generic polarity flags from 
include/media/v4l2-mediabus.h

> +struct i2c_board_info;
> +
> +/**
> + * struct exynos_isp_info - image sensor information required for host
> + *			      interface configuration.
> + *
> + * @board_info: pointer to I2C subdevice's board info
> + * @clk_frequency: frequency of the clock the host interface provides to sensor
> + * @bus_type: determines bus type, MIPI, ITU-R BT.601 etc.
> + * @csi_data_align: MIPI-CSI interface data alignment in bits
> + * @i2c_bus_num: i2c control bus id the sensor is attached to
> + * @mux_id: FIMC camera interface multiplexer index (separate for MIPI and ITU)
> + * @flags: flags defining bus signals polarity inversion (High by default)
> + * @use_cam: a means of used by GSCALER
> + */
> +struct exynos_isp_info {
> +	struct i2c_board_info *board_info;
> +	unsigned long clk_frequency;
> +	const char *cam_srclk_name;
> +	const char *cam_clk_name;
> +	enum cam_bus_type bus_type;
> +	u16 csi_data_align;
> +	u16 i2c_bus_num;
> +	enum cam_port cam_port;
> +	u16 flags;
> +};
> +#endif /* EXYNOS_CAMERA_H_ */
> diff --git a/include/media/exynos_flite.h b/include/media/exynos_flite.h
> new file mode 100644
> index 0000000..789e040
> --- /dev/null
> +++ b/include/media/exynos_flite.h
> @@ -0,0 +1,39 @@
> +/*
> + * Samsung S5P SoC camera interface driver header
> + *
> + * Copyright (c) 2011 Samsung Electronics Co., Ltd
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef EXYNOS_FLITE_H_
> +#define EXYNOS_FLITE_H_
> +
> +#include<media/exynos_camera.h>
> +
> +struct s3c_platform_camera {
> +	enum cam_bus_type type;
> +	bool use_isp;
> +	int inv_pclk;
> +	int inv_vsync;
> +	int inv_href;
> +	int inv_hsync;

There are generic flags for those in include/media/v4l2-mediabus.h.

> +};
> +
> +/**
> + * struct exynos_platform_flite - camera host interface platform data
> + *
> + * @cam: properties of camera sensor required for host interface setup
> + */
> +struct exynos_platform_flite {
> +	struct s3c_platform_camera *cam[MAX_CAMIF_CLIENTS];
> +	struct exynos_isp_info *isp_info[MAX_CAMIF_CLIENTS];
> +	u32 active_cam_index;
> +	u32 num_clients;
> +};

I don't think it is a good idea to associate the sensors with 
FIMC-LITE devices. This creates a bigger mess to deal with when 
you try to add DT support. It prevents you from re-attaching 
a sensor to different FIMC-LITE instance at runtime, doesn't it ?

Maybe you did that in order to support VIDIOC_S_INPUT, but that 
looks wrong to me. Instead the sensors should be attached to a
top level camera media device.

> +extern struct exynos_platform_flite exynos_flite0_default_data;
> +extern struct exynos_platform_flite exynos_flite1_default_data;
> +#endif /* EXYNOS_FLITE_H_*/

--

Regards,
Sylwester
