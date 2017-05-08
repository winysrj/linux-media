Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:48321 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751311AbdEHMDw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 May 2017 08:03:52 -0400
Subject: Re: [PATCH v2 6/7] [media] vimc: deb: Add debayer filter
To: Helen Koike <helen.koike@collabora.com>,
        linux-media@vger.kernel.org
Cc: jgebben@codeaurora.org, mchehab@osg.samsung.com,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <cover.1438891530.git.helen.fornazier@gmail.com>
 <1491604632-23544-1-git-send-email-helen.koike@collabora.com>
 <1491604632-23544-7-git-send-email-helen.koike@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <750d53e8-a1d3-69d8-2b29-145d5fa3e8ad@xs4all.nl>
Date: Mon, 8 May 2017 14:03:46 +0200
MIME-Version: 1.0
In-Reply-To: <1491604632-23544-7-git-send-email-helen.koike@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/08/2017 12:37 AM, Helen Koike wrote:
> Implement the debayer filter and integrate it with the core
> 
> Signed-off-by: Helen Koike <helen.koike@collabora.com>
> 
> ---
> 
> Changes in v2:
> [media] vimc: deb: Add debayer filter
> 	- Using MEDIA_ENT_F_ATV_DECODER in function
> 	- remove v4l2_dev and dev from vimc_deb_device struct
> 	- src fmt propagates from the sink
> 	- coding style
> 	- remove redundant else if statements
> 	- check end of enum and remove BUG_ON
> 	- enum frame size with min and max values
> 	- set/try fmt
> 	- remove unecessary include freezer.h
> 	- check pad types on create
> 	- return EBUSY when trying to set the format while stream is on
> 	- remove vsd struct
> 	- add IS_SRC and IS_SINK macros
> 	- add deb_mean_win_size as a parameter of the module
> 	- check set_fmt default parameters for quantization, colorspace ...
> 	- add more dev_dbg
> 
> 
> ---
>  drivers/media/platform/vimc/Makefile       |   2 +-
>  drivers/media/platform/vimc/vimc-core.c    |   6 +-
>  drivers/media/platform/vimc/vimc-core.h    |   2 +
>  drivers/media/platform/vimc/vimc-debayer.c | 573 +++++++++++++++++++++++++++++
>  drivers/media/platform/vimc/vimc-debayer.h |  28 ++
>  5 files changed, 609 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/media/platform/vimc/vimc-debayer.c
>  create mode 100644 drivers/media/platform/vimc/vimc-debayer.h
> 
> diff --git a/drivers/media/platform/vimc/Makefile b/drivers/media/platform/vimc/Makefile
> index c45195e..a6708f9 100644
> --- a/drivers/media/platform/vimc/Makefile
> +++ b/drivers/media/platform/vimc/Makefile
> @@ -1,3 +1,3 @@
> -vimc-objs := vimc-core.o vimc-capture.o vimc-sensor.o
> +vimc-objs := vimc-core.o vimc-capture.o vimc-debayer.o vimc-sensor.o
>  
>  obj-$(CONFIG_VIDEO_VIMC) += vimc.o
> diff --git a/drivers/media/platform/vimc/vimc-core.c b/drivers/media/platform/vimc/vimc-core.c
> index bc4b1bb..51cbbf6 100644
> --- a/drivers/media/platform/vimc/vimc-core.c
> +++ b/drivers/media/platform/vimc/vimc-core.c
> @@ -23,6 +23,7 @@
>  
>  #include "vimc-capture.h"
>  #include "vimc-core.h"
> +#include "vimc-debayer.h"
>  #include "vimc-sensor.h"
>  
>  #define VIMC_PDEV_NAME "vimc"
> @@ -637,9 +638,12 @@ static int vimc_device_register(struct vimc_device *vimc)
>  			create_func = vimc_cap_create;
>  			break;
>  
> +		case VIMC_ENT_NODE_DEBAYER:
> +			create_func = vimc_deb_create;
> +			break;
> +
>  		/* TODO: Instantiate the specific topology node */
>  		case VIMC_ENT_NODE_INPUT:
> -		case VIMC_ENT_NODE_DEBAYER:
>  		case VIMC_ENT_NODE_SCALER:
>  		default:
>  			/*
> diff --git a/drivers/media/platform/vimc/vimc-core.h b/drivers/media/platform/vimc/vimc-core.h
> index 2146672..2e621fe 100644
> --- a/drivers/media/platform/vimc/vimc-core.h
> +++ b/drivers/media/platform/vimc/vimc-core.h
> @@ -26,6 +26,8 @@
>  #define VIMC_FRAME_MIN_WIDTH 16
>  #define VIMC_FRAME_MIN_HEIGHT 16
>  
> +#define VIMC_FRAME_INDEX(lin, col, width, bpp) ((lin * width + col) * bpp)
> +
>  /**
>   * struct vimc_pix_map - maps media bus code with v4l2 pixel format
>   *
> diff --git a/drivers/media/platform/vimc/vimc-debayer.c b/drivers/media/platform/vimc/vimc-debayer.c
> new file mode 100644
> index 0000000..24e5952
> --- /dev/null
> +++ b/drivers/media/platform/vimc/vimc-debayer.c
> @@ -0,0 +1,573 @@
> +/*
> + * vimc-debayer.c Virtual Media Controller Driver
> + *
> + * Copyright (C) 2015-2017 Helen Koike <helen.fornazier@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/vmalloc.h>
> +#include <linux/v4l2-mediabus.h>
> +#include <media/v4l2-subdev.h>
> +
> +#include "vimc-debayer.h"
> +
> +static unsigned int deb_mean_win_size = 3;
> +module_param(deb_mean_win_size, uint, 0000);
> +MODULE_PARM_DESC(deb_mean_win_size, " the window size to calculate the mean.\n"
> +	"NOTE: the window size need to be an odd number, as the main pixel "
> +	"stays in the center of the window, otherwise the next odd number "
> +	"is considered");
> +
> +#define IS_SINK(pad) (!pad)
> +#define IS_SRC(pad)  (pad)
> +
> +enum vimc_deb_rgb_colors {
> +	VIMC_DEB_RED = 0,
> +	VIMC_DEB_GREEN = 1,
> +	VIMC_DEB_BLUE = 2,
> +};
> +
> +struct vimc_deb_pix_map {
> +	u32 code;
> +	enum vimc_deb_rgb_colors order[2][2];
> +};
> +
> +struct vimc_deb_device {
> +	struct vimc_ent_device ved;
> +	struct v4l2_subdev sd;
> +	/* The active format */
> +	struct v4l2_mbus_framefmt sink_fmt;
> +	u32 src_code;
> +	void (*set_rgb_src)(struct vimc_deb_device *vdeb, unsigned int lin,
> +			    unsigned int col, unsigned int rgb[3]);
> +	/* Values calculated when the stream starts */
> +	u8 *src_frame;
> +	unsigned int src_frame_size;
> +	const struct vimc_deb_pix_map *sink_pix_map;
> +	unsigned int sink_bpp;
> +};
> +
> +static const struct v4l2_mbus_framefmt sink_fmt_default = {
> +	.width = 640,
> +	.height = 480,
> +	.code = MEDIA_BUS_FMT_RGB888_1X24,
> +	.field = V4L2_FIELD_NONE,
> +	.colorspace = V4L2_COLORSPACE_SRGB,
> +	.quantization = V4L2_QUANTIZATION_FULL_RANGE,
> +	.xfer_func = V4L2_XFER_FUNC_SRGB,
> +};
> +
> +static const struct vimc_deb_pix_map vimc_deb_pix_map_list[] = {
> +	{
> +		.code = MEDIA_BUS_FMT_SBGGR8_1X8,
> +		.order = { { VIMC_DEB_BLUE, VIMC_DEB_GREEN },
> +			   { VIMC_DEB_GREEN, VIMC_DEB_RED } }
> +	},
> +	{
> +		.code = MEDIA_BUS_FMT_SGBRG8_1X8,
> +		.order = { { VIMC_DEB_GREEN, VIMC_DEB_BLUE },
> +			   { VIMC_DEB_RED, VIMC_DEB_GREEN } }
> +	},
> +	{
> +		.code = MEDIA_BUS_FMT_SGRBG8_1X8,
> +		.order = { { VIMC_DEB_GREEN, VIMC_DEB_RED },
> +			   { VIMC_DEB_BLUE, VIMC_DEB_GREEN } }
> +	},
> +	{
> +		.code = MEDIA_BUS_FMT_SRGGB8_1X8,
> +		.order = { { VIMC_DEB_RED, VIMC_DEB_GREEN },
> +			   { VIMC_DEB_GREEN, VIMC_DEB_BLUE } }
> +	},
> +	{
> +		.code = MEDIA_BUS_FMT_SBGGR10_1X10,
> +		.order = { { VIMC_DEB_BLUE, VIMC_DEB_GREEN },
> +			   { VIMC_DEB_GREEN, VIMC_DEB_RED } }
> +	},
> +	{
> +		.code = MEDIA_BUS_FMT_SGBRG10_1X10,
> +		.order = { { VIMC_DEB_GREEN, VIMC_DEB_BLUE },
> +			   { VIMC_DEB_RED, VIMC_DEB_GREEN } }
> +	},
> +	{
> +		.code = MEDIA_BUS_FMT_SGRBG10_1X10,
> +		.order = { { VIMC_DEB_GREEN, VIMC_DEB_RED },
> +			   { VIMC_DEB_BLUE, VIMC_DEB_GREEN } }
> +	},
> +	{
> +		.code = MEDIA_BUS_FMT_SRGGB10_1X10,
> +		.order = { { VIMC_DEB_RED, VIMC_DEB_GREEN },
> +			   { VIMC_DEB_GREEN, VIMC_DEB_BLUE } }
> +	},
> +	{
> +		.code = MEDIA_BUS_FMT_SBGGR12_1X12,
> +		.order = { { VIMC_DEB_BLUE, VIMC_DEB_GREEN },
> +			   { VIMC_DEB_GREEN, VIMC_DEB_RED } }
> +	},
> +	{
> +		.code = MEDIA_BUS_FMT_SGBRG12_1X12,
> +		.order = { { VIMC_DEB_GREEN, VIMC_DEB_BLUE },
> +			   { VIMC_DEB_RED, VIMC_DEB_GREEN } }
> +	},
> +	{
> +		.code = MEDIA_BUS_FMT_SGRBG12_1X12,
> +		.order = { { VIMC_DEB_GREEN, VIMC_DEB_RED },
> +			   { VIMC_DEB_BLUE, VIMC_DEB_GREEN } }
> +	},
> +	{
> +		.code = MEDIA_BUS_FMT_SRGGB12_1X12,
> +		.order = { { VIMC_DEB_RED, VIMC_DEB_GREEN },
> +			   { VIMC_DEB_GREEN, VIMC_DEB_BLUE } }
> +	},
> +};
> +
> +static const struct vimc_deb_pix_map *vimc_deb_pix_map_by_code(u32 code)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(vimc_deb_pix_map_list); i++)
> +		if (vimc_deb_pix_map_list[i].code == code)
> +			return &vimc_deb_pix_map_list[i];
> +
> +	return NULL;
> +}
> +
> +static int vimc_deb_init_cfg(struct v4l2_subdev *sd,
> +			     struct v4l2_subdev_pad_config *cfg)
> +{
> +	struct vimc_deb_device *vdeb = v4l2_get_subdevdata(sd);
> +	struct v4l2_mbus_framefmt *mf;
> +	unsigned int i;
> +
> +	mf = v4l2_subdev_get_try_format(sd, cfg, 0);
> +	*mf = sink_fmt_default;
> +
> +	for (i = 1; i < sd->entity.num_pads; i++) {
> +		mf = v4l2_subdev_get_try_format(sd, cfg, i);
> +		*mf = sink_fmt_default;
> +		mf->code = vdeb->src_code;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vimc_deb_enum_mbus_code(struct v4l2_subdev *sd,
> +				   struct v4l2_subdev_pad_config *cfg,
> +				   struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	/* We only support one format for source pads */
> +	if (IS_SRC(code->pad)) {
> +		struct vimc_deb_device *vdeb = v4l2_get_subdevdata(sd);
> +
> +		if (code->index)
> +			return -EINVAL;
> +
> +		code->code = vdeb->src_code;
> +	} else {
> +		if (code->index >= ARRAY_SIZE(vimc_deb_pix_map_list))
> +			return -EINVAL;
> +
> +		code->code = vimc_deb_pix_map_list[code->index].code;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vimc_deb_enum_frame_size(struct v4l2_subdev *sd,
> +				    struct v4l2_subdev_pad_config *cfg,
> +				    struct v4l2_subdev_frame_size_enum *fse)
> +{
> +	struct vimc_deb_device *vdeb = v4l2_get_subdevdata(sd);
> +
> +	if (fse->index)
> +		return -EINVAL;
> +
> +	if (IS_SINK(fse->pad)) {
> +		const struct vimc_deb_pix_map *vpix =
> +			vimc_deb_pix_map_by_code(fse->code);
> +
> +		if (!vpix)
> +			return -EINVAL;
> +	} else if (fse->code != vdeb->src_code) {
> +		return -EINVAL;
> +	}
> +
> +	fse->min_width = VIMC_FRAME_MIN_WIDTH;
> +	fse->max_width = VIMC_FRAME_MAX_WIDTH;
> +	fse->min_height = VIMC_FRAME_MIN_HEIGHT;
> +	fse->max_height = VIMC_FRAME_MAX_HEIGHT;
> +
> +	return 0;
> +}
> +
> +static int vimc_deb_get_fmt(struct v4l2_subdev *sd,
> +			    struct v4l2_subdev_pad_config *cfg,
> +			    struct v4l2_subdev_format *fmt)
> +{
> +	struct vimc_deb_device *vdeb = v4l2_get_subdevdata(sd);
> +
> +	/* Get the current sink format */
> +	fmt->format = fmt->which == V4L2_SUBDEV_FORMAT_TRY ?
> +		      *v4l2_subdev_get_try_format(sd, cfg, 0) :
> +		      vdeb->sink_fmt;
> +
> +	/* Set the right code for the source pad */
> +	if (IS_SRC(fmt->pad))
> +		fmt->format.code = vdeb->src_code;
> +
> +	return 0;
> +}
> +
> +static void vimc_deb_adjust_sink_fmt(struct v4l2_mbus_framefmt *fmt)
> +{
> +	const struct vimc_deb_pix_map *vpix;
> +
> +	/* Don't accept a code that is not on the debayer table */
> +	vpix = vimc_deb_pix_map_by_code(fmt->code);
> +	if (!vpix)
> +		fmt->code = sink_fmt_default.code;
> +
> +	fmt->width = clamp_t(u32, fmt->width, VIMC_FRAME_MIN_WIDTH,
> +			     VIMC_FRAME_MAX_WIDTH);
> +	fmt->height = clamp_t(u32, fmt->height, VIMC_FRAME_MIN_HEIGHT,
> +			      VIMC_FRAME_MAX_HEIGHT);
> +
> +	if (fmt->field == V4L2_FIELD_ANY)
> +		fmt->field = sink_fmt_default.field;
> +
> +	/* Check if values are out of range */
> +	if (fmt->colorspace == V4L2_COLORSPACE_DEFAULT
> +	    || fmt->colorspace > V4L2_COLORSPACE_DCI_P3)
> +		fmt->colorspace = sink_fmt_default.colorspace;
> +	if (fmt->ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT
> +	    || fmt->ycbcr_enc > V4L2_YCBCR_ENC_SMPTE240M)
> +		fmt->ycbcr_enc = sink_fmt_default.ycbcr_enc;
> +	if (fmt->quantization == V4L2_QUANTIZATION_DEFAULT
> +	    || fmt->quantization > V4L2_QUANTIZATION_LIM_RANGE)
> +		fmt->quantization = sink_fmt_default.quantization;
> +	if (fmt->xfer_func == V4L2_XFER_FUNC_DEFAULT
> +	    || fmt->xfer_func > V4L2_XFER_FUNC_SMPTE2084)
> +		fmt->xfer_func = sink_fmt_default.xfer_func;
> +}

Same comments as from the previous patches apply here as well.

> +
> +static int vimc_deb_set_fmt(struct v4l2_subdev *sd,
> +			    struct v4l2_subdev_pad_config *cfg,
> +			    struct v4l2_subdev_format *fmt)
> +{
> +	struct vimc_deb_device *vdeb = v4l2_get_subdevdata(sd);
> +	struct v4l2_mbus_framefmt *sink_fmt;
> +
> +	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> +		/* Do not change the format while stream is on */
> +		if (vdeb->src_frame)
> +			return -EBUSY;
> +
> +		sink_fmt = &vdeb->sink_fmt;
> +	} else {
> +		sink_fmt = v4l2_subdev_get_try_format(sd, cfg, 0);
> +	}
> +
> +	/*
> +	 * Do not change the format of the source pad,
> +	 * it is propagated from the sink
> +	 */
> +	if (IS_SRC(fmt->pad)) {
> +		fmt->format = *sink_fmt;
> +		/* TODO: Add support for other formats */
> +		fmt->format.code = vdeb->src_code;
> +	} else {
> +		/* Set the new format in the sink pad */
> +		vimc_deb_adjust_sink_fmt(&fmt->format);
> +
> +		dev_dbg(vdeb->sd.v4l2_dev->mdev->dev, "%s: sink format update: "
> +			"old:%dx%d (0x%x, %d, %d, %d, %d) "
> +			"new:%dx%d (0x%x, %d, %d, %d, %d)\n", vdeb->sd.name,
> +			/* old */
> +			sink_fmt->width, sink_fmt->height, sink_fmt->code,
> +			sink_fmt->colorspace, sink_fmt->quantization,
> +			sink_fmt->xfer_func, sink_fmt->ycbcr_enc,
> +			/* new */
> +			fmt->format.width, fmt->format.height, fmt->format.code,
> +			fmt->format.colorspace,	fmt->format.quantization,
> +			fmt->format.xfer_func, fmt->format.ycbcr_enc);
> +
> +		*sink_fmt = fmt->format;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_pad_ops vimc_deb_pad_ops = {
> +	.init_cfg		= vimc_deb_init_cfg,
> +	.enum_mbus_code		= vimc_deb_enum_mbus_code,
> +	.enum_frame_size	= vimc_deb_enum_frame_size,
> +	.get_fmt		= vimc_deb_get_fmt,
> +	.set_fmt		= vimc_deb_set_fmt,
> +};
> +
> +static void vimc_deb_set_rgb_mbus_fmt_rgb888_1x24(struct vimc_deb_device *vdeb,
> +						  unsigned int lin,
> +						  unsigned int col,
> +						  unsigned int rgb[3])
> +{
> +	unsigned int i, index;
> +
> +	index = VIMC_FRAME_INDEX(lin, col, vdeb->sink_fmt.width, 3);
> +	for (i = 0; i < 3; i++)
> +		vdeb->src_frame[index + i] = rgb[i];
> +}
> +
> +static int vimc_deb_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct vimc_deb_device *vdeb = v4l2_get_subdevdata(sd);
> +
> +	if (enable) {
> +		const struct vimc_pix_map *vpix;
> +
> +		if (vdeb->src_frame)
> +			return -EINVAL;
> +
> +		/* Calculate the frame size of the source pad */
> +		vpix = vimc_pix_map_by_code(vdeb->src_code);
> +		vdeb->src_frame_size = vdeb->sink_fmt.width *
> +				       vpix->bpp * vdeb->sink_fmt.height;
> +
> +		/* Save the bytes per pixel of the sink */
> +		vpix = vimc_pix_map_by_code(vdeb->sink_fmt.code);
> +		vdeb->sink_bpp = vpix->bpp;
> +
> +		/* Get the corresponding pixel map from the table */
> +		vdeb->sink_pix_map =
> +			vimc_deb_pix_map_by_code(vdeb->sink_fmt.code);
> +
> +		/*
> +		 * Allocate the frame buffer. Use vmalloc to be able to
> +		 * allocate a large amount of memory
> +		 */
> +		vdeb->src_frame = vmalloc(vdeb->src_frame_size);
> +		if (!vdeb->src_frame)
> +			return -ENOMEM;
> +
> +		/* Turn the stream on in the subdevices directly connected */
> +		if (vimc_pipeline_s_stream(&vdeb->sd.entity, 1)) {
> +			vfree(vdeb->src_frame);
> +			vdeb->src_frame = NULL;
> +			return -EINVAL;
> +		}
> +
> +	} else {
> +		if (!vdeb->src_frame)
> +			return -EINVAL;
> +
> +		/* Disable streaming from the pipe */
> +		vimc_pipeline_s_stream(&vdeb->sd.entity, 0);
> +		vfree(vdeb->src_frame);
> +		vdeb->src_frame = NULL;
> +	}
> +
> +	return 0;
> +}
> +
> +struct v4l2_subdev_video_ops vimc_deb_video_ops = {
> +	.s_stream = vimc_deb_s_stream,
> +};
> +
> +static const struct v4l2_subdev_ops vimc_deb_ops = {
> +	.pad = &vimc_deb_pad_ops,
> +	.video = &vimc_deb_video_ops,
> +};
> +
> +static unsigned int vimc_deb_get_val(const u8 *bytes,
> +				     const unsigned int n_bytes)
> +{
> +	unsigned int i;
> +	unsigned int acc = 0;
> +
> +	for (i = 0; i < n_bytes; i++)
> +		acc = acc + (bytes[i] << (8 * i));
> +
> +	return acc;
> +}
> +
> +static void vimc_deb_calc_rgb_sink(struct vimc_deb_device *vdeb,
> +				   const u8 *frame,
> +				   const unsigned int lin,
> +				   const unsigned int col,
> +				   unsigned int rgb[3])
> +{
> +	unsigned int i, seek, wlin, wcol;
> +	unsigned int n_rgb[3] = {0, 0, 0};
> +
> +	for (i = 0; i < 3; i++)
> +		rgb[i] = 0;
> +
> +	/*
> +	 * Calculate how many we need to subtract to get to the pixel in
> +	 * the top left corner of the mean window (considering the current
> +	 * pixel as the center)
> +	 */
> +	seek = deb_mean_win_size / 2;
> +
> +	/* Sum the values of the colors in the mean window */
> +
> +	dev_dbg(vdeb->sd.v4l2_dev->mdev->dev,
> +		"deb: %s: --- Calc pixel %dx%d, window mean %d, seek %d ---\n",
> +		vdeb->sd.name, lin, col, vdeb->sink_fmt.height, seek);
> +
> +	/*
> +	 * Iterate through all the lines in the mean window, start
> +	 * with zero if the pixel is outside the frame and don't pass
> +	 * the height when the pixel is in the bottom border of the
> +	 * frame
> +	 */
> +	for (wlin = seek > lin ? 0 : lin - seek;
> +	     wlin < lin + seek + 1 && wlin < vdeb->sink_fmt.height;
> +	     wlin++) {
> +
> +		/*
> +		 * Iterate through all the columns in the mean window, start
> +		 * with zero if the pixel is outside the frame and don't pass
> +		 * the width when the pixel is in the right border of the
> +		 * frame
> +		 */
> +		for (wcol = seek > col ? 0 : col - seek;
> +		     wcol < col + seek + 1 && wcol < vdeb->sink_fmt.width;
> +		     wcol++) {
> +			enum vimc_deb_rgb_colors color;
> +			unsigned int index;
> +
> +			/* Check which color this pixel is */
> +			color = vdeb->sink_pix_map->order[wlin % 2][wcol % 2];
> +
> +			index = VIMC_FRAME_INDEX(wlin, wcol,
> +						 vdeb->sink_fmt.width,
> +						 vdeb->sink_bpp);
> +
> +			dev_dbg(vdeb->sd.v4l2_dev->mdev->dev,
> +				"deb: %s: RGB CALC: frame index %d, win pos %dx%d, color %d\n",
> +				vdeb->sd.name, index, wlin, wcol, color);
> +
> +			/* Get its value */
> +			rgb[color] = rgb[color] +
> +				vimc_deb_get_val(&frame[index], vdeb->sink_bpp);
> +
> +			/* Save how many values we already added */
> +			n_rgb[color]++;
> +
> +			dev_dbg(vdeb->sd.v4l2_dev->mdev->dev,
> +				"deb: %s: RGB CALC: val %d, n %d\n",
> +				vdeb->sd.name, rgb[color], n_rgb[color]);
> +		}
> +	}
> +
> +	/* Calculate the mean */
> +	for (i = 0; i < 3; i++) {
> +		dev_dbg(vdeb->sd.v4l2_dev->mdev->dev,
> +			"deb: %s: PRE CALC: %dx%d Color %d, val %d, n %d\n",
> +			vdeb->sd.name, lin, col, i, rgb[i], n_rgb[i]);
> +
> +		if (n_rgb[i])
> +			rgb[i] = rgb[i] / n_rgb[i];
> +
> +		dev_dbg(vdeb->sd.v4l2_dev->mdev->dev,
> +			"deb: %s: FINAL CALC: %dx%d Color %d, val %d\n",
> +			vdeb->sd.name, lin, col, i, rgb[i]);
> +	}
> +}
> +
> +static void vimc_deb_process_frame(struct vimc_ent_device *ved,
> +				   struct media_pad *sink,
> +				   const void *sink_frame)
> +{
> +	struct vimc_deb_device *vdeb = container_of(ved, struct vimc_deb_device,
> +						    ved);
> +	unsigned int rgb[3];
> +	unsigned int i, j;
> +
> +	/* If the stream in this node is not active, just return */
> +	if (!vdeb->src_frame)
> +		return;
> +
> +	for (i = 0; i < vdeb->sink_fmt.height; i++)
> +		for (j = 0; j < vdeb->sink_fmt.width; j++) {
> +			vimc_deb_calc_rgb_sink(vdeb, sink_frame, i, j, rgb);
> +			vdeb->set_rgb_src(vdeb, i, j, rgb);
> +		}
> +
> +	/* Propagate the frame thought all source pads */

thought -> through

> +	for (i = 1; i < vdeb->sd.entity.num_pads; i++) {
> +		struct media_pad *pad = &vdeb->sd.entity.pads[i];
> +
> +		vimc_propagate_frame(pad, vdeb->src_frame);
> +	}
> +}
> +
> +static void vimc_deb_destroy(struct vimc_ent_device *ved)
> +{
> +	struct vimc_deb_device *vdeb = container_of(ved, struct vimc_deb_device,
> +						    ved);
> +
> +	vimc_ent_sd_unregister(ved, &vdeb->sd);
> +	kfree(vdeb);
> +}
> +
> +struct vimc_ent_device *vimc_deb_create(struct v4l2_device *v4l2_dev,
> +					const char *const name,
> +					u16 num_pads,
> +					const unsigned long *pads_flag)
> +{
> +	struct vimc_deb_device *vdeb;
> +	unsigned int i;
> +	int ret;
> +
> +	/* check pads types
> +	 * NOTE: we support a single sink pad and multiple source pads
> +	 * the sink pad must be the first
> +	 */
> +	if (num_pads < 2 || !(pads_flag[0] & MEDIA_PAD_FL_SINK))
> +		return ERR_PTR(-EINVAL);
> +
> +	/* check if the rest of pads are sources */
> +	for (i = 1; i < num_pads; i++)
> +		if (!(pads_flag[i] & MEDIA_PAD_FL_SOURCE))
> +			return ERR_PTR(-EINVAL);
> +
> +	/* Allocate the vdeb struct */
> +	vdeb = kzalloc(sizeof(*vdeb), GFP_KERNEL);
> +	if (!vdeb)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* Initialize ved and sd */
> +	ret = vimc_ent_sd_register(&vdeb->ved, &vdeb->sd, v4l2_dev, name,
> +				   MEDIA_ENT_F_ATV_DECODER, num_pads, pads_flag,
> +				   &vimc_deb_ops, vimc_deb_destroy);
> +	if (ret) {
> +		kfree(vdeb);
> +		return ERR_PTR(ret);
> +	}
> +
> +	/* Initialize the frame format */
> +	vdeb->sink_fmt = sink_fmt_default;
> +	/* TODO: Add support for more output formats, we only support
> +	 * RGB8888 for now

RGB888, not 8888.

> +	 * NOTE: the src format is always the same as the sink, except
> +	 * for the code
> +	 */
> +	vdeb->src_code = MEDIA_BUS_FMT_RGB888_1X24;
> +	vdeb->set_rgb_src = vimc_deb_set_rgb_mbus_fmt_rgb888_1x24;
> +
> +	/* Set the process frame callback */
> +	vdeb->ved.process_frame = vimc_deb_process_frame;
> +
> +	return &vdeb->ved;
> +}
> diff --git a/drivers/media/platform/vimc/vimc-debayer.h b/drivers/media/platform/vimc/vimc-debayer.h
> new file mode 100644
> index 0000000..7801c07
> --- /dev/null
> +++ b/drivers/media/platform/vimc/vimc-debayer.h
> @@ -0,0 +1,28 @@
> +/*
> + * vimc-debayer.h Virtual Media Controller Driver
> + *
> + * Copyright (C) 2015-2017 Helen Koike <helen.fornazier@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef _VIMC_DEBAYER_H_
> +#define _VIMC_DEBAYER_H_
> +
> +#include "vimc-core.h"
> +
> +struct vimc_ent_device *vimc_deb_create(struct v4l2_device *v4l2_dev,
> +					const char *const name,
> +					u16 num_pads,
> +					const unsigned long *pads_flag);
> +
> +#endif
> 

Regards,

	Hans
