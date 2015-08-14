Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:34549 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752127AbbHNMYq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 08:24:46 -0400
Message-ID: <55CDDDEE.9050501@xs4all.nl>
Date: Fri, 14 Aug 2015 14:24:14 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Helen Fornazier <helen.fornazier@gmail.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 6/7] [media] vimc: sca: Add scaler subdevice
References: <cover.1438891530.git.helen.fornazier@gmail.com> <f9c7b62c5f6c3d05c67526cbefdd0697f56b0868.1438891530.git.helen.fornazier@gmail.com>
In-Reply-To: <f9c7b62c5f6c3d05c67526cbefdd0697f56b0868.1438891530.git.helen.fornazier@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/06/2015 10:26 PM, Helen Fornazier wrote:
> Implement scaler and integrated with the core

As per my suggestion in patch 2/7, you don't actually need (or want) to do
image processing here. All you need to do is to tell the tpg how it should
look like. That way you get scaling for free!

Ditto for the debayer module, that actually doesn't have to do anything.
The only thing that you need to keep in mind for the debayer is that video
nodes pre-debayer entity should only support the bayer fourcc pixelformats,
and the video nodes post-debayer entity shouldn't support the bayer fourccs.

Regards,

	Hans

> 
> Signed-off-by: Helen Fornazier <helen.fornazier@gmail.com>
> ---
>  drivers/media/platform/vimc/Makefile      |   3 +-
>  drivers/media/platform/vimc/vimc-core.c   |   6 +-
>  drivers/media/platform/vimc/vimc-scaler.c | 321 ++++++++++++++++++++++++++++++
>  drivers/media/platform/vimc/vimc-scaler.h |  28 +++
>  4 files changed, 356 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/media/platform/vimc/vimc-scaler.c
>  create mode 100644 drivers/media/platform/vimc/vimc-scaler.h
> 
> diff --git a/drivers/media/platform/vimc/Makefile b/drivers/media/platform/vimc/Makefile
> index a6708f9..f13a594 100644
> --- a/drivers/media/platform/vimc/Makefile
> +++ b/drivers/media/platform/vimc/Makefile
> @@ -1,3 +1,4 @@
> -vimc-objs := vimc-core.o vimc-capture.o vimc-debayer.o vimc-sensor.o
> +vimc-objs := vimc-core.o vimc-capture.o vimc-debayer.o vimc-scaler.o \
> +		vimc-sensor.o
>  
>  obj-$(CONFIG_VIDEO_VIMC) += vimc.o
> diff --git a/drivers/media/platform/vimc/vimc-core.c b/drivers/media/platform/vimc/vimc-core.c
> index 373ea9c..8342732 100644
> --- a/drivers/media/platform/vimc/vimc-core.c
> +++ b/drivers/media/platform/vimc/vimc-core.c
> @@ -25,6 +25,7 @@
>  #include "vimc-capture.h"
>  #include "vimc-core.h"
>  #include "vimc-debayer.h"
> +#include "vimc-scaler.h"
>  #include "vimc-sensor.h"
>  
>  #define VIMC_PDEV_NAME "vimc"
> @@ -557,9 +558,12 @@ static int vimc_device_register(struct vimc_device *vimc)
>  			create_func = vimc_deb_create;
>  			break;
>  
> +		case VIMC_ENT_NODE_SCALER:
> +			create_func = vimc_sca_create;
> +			break;
> +
>  		/* TODO: Instantiate the specific topology node */
>  		case VIMC_ENT_NODE_INPUT:
> -		case VIMC_ENT_NODE_SCALER:
>  		default:
>  			/* TODO: remove this when all the entities specific
>  			 * code are implemented */
> diff --git a/drivers/media/platform/vimc/vimc-scaler.c b/drivers/media/platform/vimc/vimc-scaler.c
> new file mode 100644
> index 0000000..ea26930
> --- /dev/null
> +++ b/drivers/media/platform/vimc/vimc-scaler.c
> @@ -0,0 +1,321 @@
> +/*
> + * vimc-scaler.c Virtual Media Controller Driver
> + *
> + * Copyright (C) 2015 Helen Fornazier <helen.fornazier@gmail.com>
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
> +#include <linux/freezer.h>
> +#include <linux/vmalloc.h>
> +#include <linux/v4l2-mediabus.h>
> +#include <media/v4l2-subdev.h>
> +
> +#include "vimc-scaler.h"
> +
> +/* TODO: add this as a parameter of this module */
> +#define VIMC_SCA_MULTIPLIER 3
> +
> +struct vimc_sca_device {
> +	struct vimc_ent_subdevice vsd;
> +	unsigned int mult;
> +	/* The active format */
> +	struct v4l2_mbus_framefmt sink_mbus_fmt;
> +	unsigned int src_width;
> +	unsigned int src_height;
> +	/* Values calculated when the stream starts */
> +	u8 *src_frame;
> +	unsigned int src_frame_size;
> +	unsigned int src_line_size;
> +	unsigned int bpp;
> +};
> +
> +static int vimc_sca_enum_mbus_code(struct v4l2_subdev *sd,
> +				   struct v4l2_subdev_pad_config *cfg,
> +				   struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	struct vimc_sca_device *vsca = v4l2_get_subdevdata(sd);
> +
> +	/* Check if it is a valid pad */
> +	if (code->pad >= vsca->vsd.sd.entity.num_pads)
> +		return -EINVAL;
> +
> +	code->code = vsca->sink_mbus_fmt.code;
> +
> +	return 0;
> +}
> +
> +static int vimc_sca_enum_frame_size(struct v4l2_subdev *sd,
> +				    struct v4l2_subdev_pad_config *cfg,
> +				    struct v4l2_subdev_frame_size_enum *fse)
> +{
> +	struct vimc_sca_device *vsca = v4l2_get_subdevdata(sd);
> +	struct media_pad *pad;
> +
> +	/* Check if it is a valid pad */
> +	if (fse->pad >= vsca->vsd.sd.entity.num_pads)
> +		return -EINVAL;
> +
> +	/* TODO: Add support to other formats sizes */
> +
> +	pad = &vsca->vsd.sd.entity.pads[fse->pad];
> +	if ((pad->flags & MEDIA_PAD_FL_SOURCE)) {
> +		fse->min_width = vsca->src_width;
> +		fse->max_width = vsca->src_width;
> +		fse->min_height = vsca->src_height;
> +		fse->max_height = vsca->src_height;
> +	} else if ((pad->flags & MEDIA_PAD_FL_SINK)) {
> +		fse->min_width = vsca->sink_mbus_fmt.width;
> +		fse->max_width = vsca->sink_mbus_fmt.width;
> +		fse->min_height = vsca->sink_mbus_fmt.height;
> +		fse->max_height = vsca->sink_mbus_fmt.height;
> +	} else
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int vimc_sca_get_fmt(struct v4l2_subdev *sd,
> +			    struct v4l2_subdev_pad_config *cfg,
> +			    struct v4l2_subdev_format *format)
> +{
> +	struct vimc_sca_device *vsca = v4l2_get_subdevdata(sd);
> +	struct media_pad *pad;
> +
> +	/* Check if it is a valid pad */
> +	if (format->pad >= vsca->vsd.sd.entity.num_pads)
> +		return -EINVAL;
> +
> +	pad = &vsca->vsd.sd.entity.pads[format->pad];
> +	if ((pad->flags & MEDIA_PAD_FL_SOURCE)) {
> +		format->format = vsca->sink_mbus_fmt;
> +		format->format.width = vsca->src_width;
> +		format->format.height = vsca->src_height;
> +	} else if ((pad->flags & MEDIA_PAD_FL_SINK))
> +		format->format = vsca->sink_mbus_fmt;
> +	else
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_pad_ops vimc_sca_pad_ops = {
> +	.enum_mbus_code		= vimc_sca_enum_mbus_code,
> +	.enum_frame_size	= vimc_sca_enum_frame_size,
> +	.get_fmt		= vimc_sca_get_fmt,
> +	/* TODO: Add support to other formats */
> +	.set_fmt		= vimc_sca_get_fmt,
> +};
> +
> +static int vimc_sca_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct vimc_sca_device *vsca = v4l2_get_subdevdata(sd);
> +
> +	if (enable) {
> +		const struct vimc_pix_map *vpix;
> +
> +		if (vsca->src_frame)
> +			return -EINVAL;
> +
> +		/* Save the bytes per pixel of the sink */
> +		vpix = vimc_pix_map_by_code(vsca->sink_mbus_fmt.code);
> +		/* This should never be NULL, as we won't allow any format
> +		 * other then the ones in the vimc_pix_map_list table */
> +		BUG_ON(!vpix);
> +		vsca->bpp = vpix->bpp;
> +
> +		/* Calculate the width in bytes of the src frame */
> +		vsca->src_line_size = vsca->src_width * vsca->bpp;
> +
> +		/* Calculate the frame size of the source pad */
> +		vsca->src_frame_size = vsca->src_line_size * vsca->src_height;
> +
> +		/* Allocate the frame buffer. Use vmalloc to be able to
> +		 * allocate a large amount of memory*/
> +		vsca->src_frame = vmalloc(vsca->src_frame_size);
> +		if (!vsca->src_frame)
> +			return -ENOMEM;
> +
> +		/* Turn the stream on in the subdevices directly connected */
> +		if (vimc_pipeline_s_stream(&vsca->vsd.sd.entity, 1)) {
> +			vfree(vsca->src_frame);
> +			vsca->src_frame = NULL;
> +			return -EINVAL;
> +		}
> +	} else {
> +		if (!vsca->src_frame)
> +			return -EINVAL;
> +		vfree(vsca->src_frame);
> +		vsca->src_frame = NULL;
> +		vimc_pipeline_s_stream(&vsca->vsd.sd.entity, 0);
> +	}
> +
> +	return 0;
> +}
> +
> +struct v4l2_subdev_video_ops vimc_sca_video_ops = {
> +	.s_stream = vimc_sca_s_stream,
> +};
> +
> +static const struct v4l2_subdev_ops vimc_sca_ops = {
> +	.pad = &vimc_sca_pad_ops,
> +	.video = &vimc_sca_video_ops,
> +};
> +
> +static void vimc_sca_fill_pix(u8 *const ptr,
> +			      const u8 *const pixel,
> +			      const unsigned int bpp)
> +{
> +	unsigned int i;
> +
> +	/* copy the pixel to the pointer */
> +	for (i = 0; i < bpp; i++)
> +		ptr[i] = pixel[i];
> +}
> +
> +static void vimc_sca_scale_pix(const struct vimc_sca_device *const vsca,
> +			       const unsigned int lin, const unsigned int col,
> +			       const u8 *const sink_frame)
> +{
> +	unsigned int i, j, index;
> +	const u8 *pixel;
> +
> +	/* Point to the pixel value in position (lin, col) in the sink frame */
> +	index = VIMC_FRAME_INDEX(lin, col,
> +				 vsca->sink_mbus_fmt.width,
> +				 vsca->bpp);
> +	pixel = &sink_frame[index];
> +
> +	dev_dbg(vsca->vsd.dev,
> +		"sca: %s: --- scale_pix sink pos %dx%d, index %d ---\n",
> +		vsca->vsd.sd.name, lin, col, index);
> +
> +	/* point to the place we are going to put the first pixel
> +	 * in the scaled src frame */
> +	index = VIMC_FRAME_INDEX(lin * vsca->mult, col * vsca->mult,
> +				 vsca->src_width, vsca->bpp);
> +
> +	dev_dbg(vsca->vsd.dev, "sca: %s: scale_pix src pos %dx%d, index %d\n",
> +		vsca->vsd.sd.name, lin * vsca->mult, col * vsca->mult, index);
> +
> +	/* Repeat this pixel mult times */
> +	for (i = 0; i < vsca->mult; i++) {
> +		/* Iterate though each beginning of a
> +		 * pixel repetition in a line */
> +		for (j = 0; j < vsca->mult * vsca->bpp; j += vsca->bpp) {
> +			dev_dbg(vsca->vsd.dev,
> +				"sca: %s: sca: scale_pix src pos %d\n",
> +				vsca->vsd.sd.name, index + j);
> +
> +			/* copy the pixel to the position index + j */
> +			vimc_sca_fill_pix(&vsca->src_frame[index + j],
> +					  pixel, vsca->bpp);
> +		}
> +
> +		/* move the index to the next line */
> +		index += vsca->src_line_size;
> +	}
> +}
> +
> +static void vimc_sca_fill_src_frame(const struct vimc_sca_device *const vsca,
> +				    const u8 *const sink_frame)
> +{
> +	unsigned int i, j;
> +
> +	/* Scale each pixel from the original sink frame */
> +	/* TODO: implement scale down, only scale up is supported for now */
> +	for (i = 0; i < vsca->sink_mbus_fmt.height; i++)
> +		for (j = 0; j < vsca->sink_mbus_fmt.width; j++)
> +			vimc_sca_scale_pix(vsca, i, j, sink_frame);
> +}
> +
> +static void vimc_sca_process_frame(struct vimc_ent_device *ved,
> +				   struct media_pad *sink,
> +				   const void *sink_frame)
> +{
> +	unsigned int i;
> +	struct vimc_sca_device *vsca = container_of(ved, struct vimc_sca_device,
> +						    vsd.ved);
> +
> +	/* If the stream in this node is not active, just return */
> +	if (!vsca->src_frame)
> +		return;
> +
> +	vimc_sca_fill_src_frame(vsca, sink_frame);
> +
> +	/* Propagate the frame thought all source pads */
> +	for (i = 0; i < vsca->vsd.sd.entity.num_pads; i++) {
> +		struct media_pad *pad = &vsca->vsd.sd.entity.pads[i];
> +
> +		if (pad->flags & MEDIA_PAD_FL_SOURCE)
> +			vimc_propagate_frame(vsca->vsd.dev,
> +					     pad, vsca->src_frame);
> +	}
> +};
> +
> +static void vimc_sca_destroy(struct vimc_ent_device *ved)
> +{
> +	struct vimc_sca_device *vsca = container_of(ved, struct vimc_sca_device,
> +						    vsd.ved);
> +
> +	vimc_ent_sd_cleanup(&vsca->vsd);
> +}
> +
> +struct vimc_ent_device *vimc_sca_create(struct v4l2_device *v4l2_dev,
> +					const char *const name,
> +					u16 num_pads,
> +					const unsigned long *pads_flag)
> +{
> +	int ret;
> +	struct vimc_sca_device *vsca;
> +	struct vimc_ent_subdevice *vsd;
> +
> +	vsd = vimc_ent_sd_init(sizeof(struct vimc_sca_device),
> +			       v4l2_dev, name, num_pads, pads_flag,
> +			       &vimc_sca_ops, vimc_sca_destroy);
> +	if (IS_ERR(vsd))
> +		return (struct vimc_ent_device *)vsd;
> +
> +	vsca = container_of(vsd, struct vimc_sca_device, vsd);
> +
> +	/* Set the default active frame format (this is hardcoded for now) */
> +	vsca->sink_mbus_fmt.width = 640;
> +	vsca->sink_mbus_fmt.height = 480;
> +	vsca->sink_mbus_fmt.code = MEDIA_BUS_FMT_RGB888_1X24;
> +	vsca->sink_mbus_fmt.field = V4L2_FIELD_NONE;
> +	vsca->sink_mbus_fmt.colorspace = V4L2_COLORSPACE_SRGB;
> +	vsca->sink_mbus_fmt.quantization = V4L2_QUANTIZATION_FULL_RANGE;
> +	vsca->sink_mbus_fmt.xfer_func = V4L2_XFER_FUNC_SRGB;
> +
> +	/* Set the scaler multiplier factor */
> +	vsca->mult = VIMC_SCA_MULTIPLIER;
> +
> +	/* Calculate the width and the height of the src frame */
> +	vsca->src_width = vsca->sink_mbus_fmt.width * vsca->mult;
> +	vsca->src_height = vsca->sink_mbus_fmt.height * vsca->mult;
> +
> +	/* Set the process frame callback */
> +	vsca->vsd.ved.process_frame = vimc_sca_process_frame;
> +
> +	/* Register the subdev with the v4l2 and the media framework */
> +	ret = v4l2_device_register_subdev(vsca->vsd.v4l2_dev, &vsca->vsd.sd);
> +	if (ret) {
> +		dev_err(vsca->vsd.dev,
> +			"subdev register failed (err=%d)\n", ret);
> +
> +		vimc_ent_sd_cleanup(vsd);
> +
> +		return ERR_PTR(ret);
> +	}
> +
> +	return &vsca->vsd.ved;
> +}
> diff --git a/drivers/media/platform/vimc/vimc-scaler.h b/drivers/media/platform/vimc/vimc-scaler.h
> new file mode 100644
> index 0000000..863278f
> --- /dev/null
> +++ b/drivers/media/platform/vimc/vimc-scaler.h
> @@ -0,0 +1,28 @@
> +/*
> + * vimc-scaler.h Virtual Media Controller Driver
> + *
> + * Copyright (C) 2015 Helen Fornazier <helen.fornazier@gmail.com>
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
> +#ifndef _VIMC_SCALER_H_
> +#define _VIMC_SCALER_H_
> +
> +#include "vimc-core.h"
> +
> +struct vimc_ent_device *vimc_sca_create(struct v4l2_device *v4l2_dev,
> +					const char *const name,
> +					u16 num_pads,
> +					const unsigned long *pads_flag);
> +
> +#endif
> 

