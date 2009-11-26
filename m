Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4955 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZKZOmO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 09:42:14 -0500
Message-ID: <dc06c2b1fe49c7b64007ec24817e190a.squirrel@webmail.xs4all.nl>
In-Reply-To: <Pine.LNX.4.64.0911261509100.5450@axis700.grange>
References: <Pine.LNX.4.64.0911261509100.5450@axis700.grange>
Date: Thu, 26 Nov 2009 15:42:17 +0100
Subject: Re: [PATCH 1/2 v2] v4l: add a media-bus API for configuring v4l2
 subdev pixel and frame formats
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Just two things really:

1) Can you move v4l2_mbus_packing and v4l2_mbus_order to a soc-mediabus.h
header or something similar? It's now soc-specific, so it doesn't belong
in the public header.

2) What are your plans for documenting the mediabus pixel codes?

Otherwise it looks great!

Regards,

          Hans

> Video subdevices, like cameras, decoders, connect to video bridges over
> specialised busses. Data is being transferred over these busses in various
> formats, which only loosely correspond to fourcc codes, describing how
> video
> data is stored in RAM. This is not a one-to-one correspondence, therefore
> we
> cannot use fourcc codes to configure subdevice output data formats. This
> patch
> adds codes for several such on-the-bus formats and an API, similar to the
> familiar .s_fmt(), .g_fmt(), .try_fmt(), .enum_fmt() API for configuring
> those
> codes. After all users of the old API in struct v4l2_subdev_video_ops are
> converted, it will be removed. Also add helper routines to support generic
> pass-through mode for the soc-camera framework.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>
> v1 -> v2: addressed comments from Hans, namely:
>
> 1. renamed image bus to media bus, now using "mbus" as a shorthand in
> function and data type names
>
> 2. made media-bus helper functions soc-camera local
>
> 3. moved colorspace from struct v4l2_mbus_pixelfmt to struct
> v4l2_mbus_framefmt
>
> 4. added documentation for data types and enums
>
> 5. added
>
> 	V4L2_MBUS_FMT_FIXED = 1,
>
> format as the first in enum
>
> I'm still testing the soc-camera driver conversion patch, I'll post it as
> a reply to this one, marked "2/2 v2" a bit later.
>
> Thanks
> Guennadi
>
>  drivers/media/video/Makefile       |    2 +-
>  drivers/media/video/soc_mediabus.c |  211
> ++++++++++++++++++++++++++++++++++++
>  include/media/soc_camera.h         |   24 ++++
>  include/media/v4l2-mediabus.h      |  103 ++++++++++++++++++
>  include/media/v4l2-subdev.h        |   19 +++-
>  5 files changed, 357 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/media/video/soc_mediabus.c
>  create mode 100644 include/media/v4l2-mediabus.h
>
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 7a2dcc3..e7bc8da 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -149,7 +149,7 @@ obj-$(CONFIG_VIDEO_VIVI) += vivi.o
>  obj-$(CONFIG_VIDEO_CX23885) += cx23885/
>
>  obj-$(CONFIG_VIDEO_OMAP2)		+= omap2cam.o
> -obj-$(CONFIG_SOC_CAMERA)		+= soc_camera.o
> +obj-$(CONFIG_SOC_CAMERA)		+= soc_camera.o soc_mediabus.o
>  obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
>  # soc-camera host drivers have to be linked after camera drivers
>  obj-$(CONFIG_VIDEO_MX1)			+= mx1_camera.o
> diff --git a/drivers/media/video/soc_mediabus.c
> b/drivers/media/video/soc_mediabus.c
> new file mode 100644
> index 0000000..0d5c17d
> --- /dev/null
> +++ b/drivers/media/video/soc_mediabus.c
> @@ -0,0 +1,211 @@
> +/*
> + * soc-camera media bus helper routines
> + *
> + * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-mediabus.h>
> +
> +#define MBUS_IDX(f) (V4L2_MBUS_FMT_ ## f - V4L2_MBUS_FMT_FIXED - 1)
> +
> +static const struct v4l2_mbus_pixelfmt mbus_fmt[] = {
> +	[MBUS_IDX(YUYV)] = {
> +		.fourcc			= V4L2_PIX_FMT_YUYV,
> +		.name			= "YUYV",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_MBUS_PACKING_2X8_PADHI,
> +		.order			= V4L2_MBUS_ORDER_LE,
> +	}, [MBUS_IDX(YVYU)] = {
> +		.fourcc			= V4L2_PIX_FMT_YVYU,
> +		.name			= "YVYU",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_MBUS_PACKING_2X8_PADHI,
> +		.order			= V4L2_MBUS_ORDER_LE,
> +	}, [MBUS_IDX(UYVY)] = {
> +		.fourcc			= V4L2_PIX_FMT_UYVY,
> +		.name			= "UYVY",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_MBUS_PACKING_2X8_PADHI,
> +		.order			= V4L2_MBUS_ORDER_LE,
> +	}, [MBUS_IDX(VYUY)] = {
> +		.fourcc			= V4L2_PIX_FMT_VYUY,
> +		.name			= "VYUY",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_MBUS_PACKING_2X8_PADHI,
> +		.order			= V4L2_MBUS_ORDER_LE,
> +	}, [MBUS_IDX(VYUY_SMPTE170M_8)] = {
> +		.fourcc			= V4L2_PIX_FMT_VYUY,
> +		.name			= "VYUY in SMPTE170M",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_MBUS_PACKING_2X8_PADHI,
> +		.order			= V4L2_MBUS_ORDER_LE,
> +	}, [MBUS_IDX(VYUY_SMPTE170M_16)] = {
> +		.fourcc			= V4L2_PIX_FMT_VYUY,
> +		.name			= "VYUY in SMPTE170M, 16bit",
> +		.bits_per_sample	= 16,
> +		.packing		= V4L2_MBUS_PACKING_NONE,
> +		.order			= V4L2_MBUS_ORDER_LE,
> +	}, [MBUS_IDX(RGB555)] = {
> +		.fourcc			= V4L2_PIX_FMT_RGB555,
> +		.name			= "RGB555",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_MBUS_PACKING_2X8_PADHI,
> +		.order			= V4L2_MBUS_ORDER_LE,
> +	}, [MBUS_IDX(RGB555X)] = {
> +		.fourcc			= V4L2_PIX_FMT_RGB555X,
> +		.name			= "RGB555X",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_MBUS_PACKING_2X8_PADHI,
> +		.order			= V4L2_MBUS_ORDER_LE,
> +	}, [MBUS_IDX(RGB565)] = {
> +		.fourcc			= V4L2_PIX_FMT_RGB565,
> +		.name			= "RGB565",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_MBUS_PACKING_2X8_PADHI,
> +		.order			= V4L2_MBUS_ORDER_LE,
> +	}, [MBUS_IDX(RGB565X)] = {
> +		.fourcc			= V4L2_PIX_FMT_RGB565X,
> +		.name			= "RGB565X",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_MBUS_PACKING_2X8_PADHI,
> +		.order			= V4L2_MBUS_ORDER_LE,
> +	}, [MBUS_IDX(SBGGR8)] = {
> +		.fourcc			= V4L2_PIX_FMT_SBGGR8,
> +		.name			= "Bayer 8 BGGR",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_MBUS_PACKING_NONE,
> +		.order			= V4L2_MBUS_ORDER_LE,
> +	}, [MBUS_IDX(SGBRG8)] = {
> +		.fourcc			= V4L2_PIX_FMT_SGBRG8,
> +		.name			= "Bayer 8 GBRG",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_MBUS_PACKING_NONE,
> +		.order			= V4L2_MBUS_ORDER_LE,
> +	}, [MBUS_IDX(SGRBG8)] = {
> +		.fourcc			= V4L2_PIX_FMT_SGRBG8,
> +		.name			= "Bayer 8 GRBG",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_MBUS_PACKING_NONE,
> +		.order			= V4L2_MBUS_ORDER_LE,
> +	}, [MBUS_IDX(SRGGB8)] = {
> +		.fourcc			= V4L2_PIX_FMT_SRGGB8,
> +		.name			= "Bayer 8 RGGB",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_MBUS_PACKING_NONE,
> +		.order			= V4L2_MBUS_ORDER_LE,
> +	}, [MBUS_IDX(SBGGR10)] = {
> +		.fourcc			= V4L2_PIX_FMT_SBGGR10,
> +		.name			= "Bayer 10 BGGR",
> +		.bits_per_sample	= 10,
> +		.packing		= V4L2_MBUS_PACKING_EXTEND16,
> +		.order			= V4L2_MBUS_ORDER_LE,
> +	}, [MBUS_IDX(SGBRG10)] = {
> +		.fourcc			= V4L2_PIX_FMT_SGBRG10,
> +		.name			= "Bayer 10 GBRG",
> +		.bits_per_sample	= 10,
> +		.packing		= V4L2_MBUS_PACKING_EXTEND16,
> +		.order			= V4L2_MBUS_ORDER_LE,
> +	}, [MBUS_IDX(SGRBG10)] = {
> +		.fourcc			= V4L2_PIX_FMT_SGRBG10,
> +		.name			= "Bayer 10 GRBG",
> +		.bits_per_sample	= 10,
> +		.packing		= V4L2_MBUS_PACKING_EXTEND16,
> +		.order			= V4L2_MBUS_ORDER_LE,
> +	}, [MBUS_IDX(SRGGB10)] = {
> +		.fourcc			= V4L2_PIX_FMT_SRGGB10,
> +		.name			= "Bayer 10 RGGB",
> +		.bits_per_sample	= 10,
> +		.packing		= V4L2_MBUS_PACKING_EXTEND16,
> +		.order			= V4L2_MBUS_ORDER_LE,
> +	}, [MBUS_IDX(GREY)] = {
> +		.fourcc			= V4L2_PIX_FMT_GREY,
> +		.name			= "Grey",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_MBUS_PACKING_NONE,
> +		.order			= V4L2_MBUS_ORDER_LE,
> +	}, [MBUS_IDX(Y16)] = {
> +		.fourcc			= V4L2_PIX_FMT_Y16,
> +		.name			= "Grey 16bit",
> +		.bits_per_sample	= 16,
> +		.packing		= V4L2_MBUS_PACKING_NONE,
> +		.order			= V4L2_MBUS_ORDER_LE,
> +	}, [MBUS_IDX(Y10)] = {
> +		.fourcc			= V4L2_PIX_FMT_Y10,
> +		.name			= "Grey 10bit",
> +		.bits_per_sample	= 10,
> +		.packing		= V4L2_MBUS_PACKING_EXTEND16,
> +		.order			= V4L2_MBUS_ORDER_LE,
> +	}, [MBUS_IDX(SBGGR10_2X8_PADHI_LE)] = {
> +		.fourcc			= V4L2_PIX_FMT_SBGGR10,
> +		.name			= "Bayer 10 BGGR",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_MBUS_PACKING_2X8_PADHI,
> +		.order			= V4L2_MBUS_ORDER_LE,
> +	}, [MBUS_IDX(SBGGR10_2X8_PADLO_LE)] = {
> +		.fourcc			= V4L2_PIX_FMT_SBGGR10,
> +		.name			= "Bayer 10 BGGR",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_MBUS_PACKING_2X8_PADLO,
> +		.order			= V4L2_MBUS_ORDER_LE,
> +	}, [MBUS_IDX(SBGGR10_2X8_PADHI_BE)] = {
> +		.fourcc			= V4L2_PIX_FMT_SBGGR10,
> +		.name			= "Bayer 10 BGGR",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_MBUS_PACKING_2X8_PADHI,
> +		.order			= V4L2_MBUS_ORDER_BE,
> +	}, [MBUS_IDX(SBGGR10_2X8_PADLO_BE)] = {
> +		.fourcc			= V4L2_PIX_FMT_SBGGR10,
> +		.name			= "Bayer 10 BGGR",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_MBUS_PACKING_2X8_PADLO,
> +		.order			= V4L2_MBUS_ORDER_BE,
> +	},
> +};
> +
> +const struct v4l2_mbus_pixelfmt *soc_mbus_get_fmtdesc(
> +	enum v4l2_mbus_pixelcode code)
> +{
> +	if ((unsigned int)(code - V4L2_MBUS_FMT_FIXED) > ARRAY_SIZE(mbus_fmt))
> +		return NULL;
> +	return mbus_fmt + code - V4L2_MBUS_FMT_FIXED - 1;
> +}
> +EXPORT_SYMBOL(soc_mbus_get_fmtdesc);
> +
> +s32 soc_mbus_bytes_per_line(u32 width,
> +			       const struct v4l2_mbus_pixelfmt *mf)
> +{
> +	switch (mf->packing) {
> +	case V4L2_MBUS_PACKING_NONE:
> +		return width * mf->bits_per_sample / 8;
> +	case V4L2_MBUS_PACKING_2X8_PADHI:
> +	case V4L2_MBUS_PACKING_2X8_PADLO:
> +	case V4L2_MBUS_PACKING_EXTEND16:
> +		return width * 2;
> +	}
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL(soc_mbus_bytes_per_line);
> +
> +static int __init soc_mbus_init(void)
> +{
> +	return 0;
> +}
> +
> +static void __exit soc_mbus_exit(void)
> +{
> +}
> +
> +module_init(soc_mbus_init);
> +module_exit(soc_mbus_exit);
> +
> +MODULE_DESCRIPTION("soc-camera media bus interface");
> +MODULE_AUTHOR("Guennadi Liakhovetski <g.liakhovetski@gmx.de>");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> index 831efff..bc74312 100644
> --- a/include/media/soc_camera.h
> +++ b/include/media/soc_camera.h
> @@ -295,4 +295,28 @@ static inline void soc_camera_limit_side(unsigned int
> *start,
>  extern unsigned long soc_camera_apply_sensor_flags(struct soc_camera_link
> *icl,
>  						   unsigned long flags);
>
> +/* soc-camera helper functions for the Media Bus API */
> +const struct v4l2_mbus_pixelfmt *soc_mbus_get_fmtdesc(
> +	enum v4l2_mbus_pixelcode code);
> +s32 soc_mbus_bytes_per_line(u32 width, const struct v4l2_mbus_pixelfmt
> *mf);
> +
> +/* Most clients have only one fixed colorspace per pixelcode */
> +struct soc_camera_datafmt {
> +	enum v4l2_mbus_pixelcode	code;
> +	enum v4l2_colorspace		colorspace;
> +};
> +
> +/* Find a data format by a pixel code in an array */
> +static inline const struct soc_camera_datafmt *soc_camera_find_datafmt(
> +	enum v4l2_mbus_pixelcode code, const struct soc_camera_datafmt *fmt,
> +	int n)
> +{
> +	int i;
> +	for (i = 0; i < n; i++)
> +		if (fmt[i].code == code)
> +			return fmt + i;
> +
> +	return NULL;
> +}
> +
>  #endif
> diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> new file mode 100644
> index 0000000..e99bb32
> --- /dev/null
> +++ b/include/media/v4l2-mediabus.h
> @@ -0,0 +1,103 @@
> +/*
> + * Media Bus API header
> + *
> + * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef V4L2_MBUS_H
> +#define V4L2_MBUS_H
> +
> +/**
> + * enum v4l2_mbus_packing - data packing types on the media-bus
> + * @V4L2_MBUS_PACKING_NONE:		no packing, bit-for-bit transfer to RAM
> + * @V4L2_MBUS_PACKING_2X8_PADHI:	16 bits transferred in 2 8-bit samples,
> + *					in the possibly incomplete byte high
> + *					bits are padding
> + * @V4L2_MBUS_PACKING_2X8_PADLO:	as above, but low bits are padding
> + * @V4L2_MBUS_PACKING_EXTEND16:		sample width (e.g., 10 bits) has to be
> + *					extended to 16 bits
> + */
> +enum v4l2_mbus_packing {
> +	V4L2_MBUS_PACKING_NONE,
> +	V4L2_MBUS_PACKING_2X8_PADHI,
> +	V4L2_MBUS_PACKING_2X8_PADLO,
> +	V4L2_MBUS_PACKING_EXTEND16,
> +};
> +
> +/**
> + * enum v4l2_mbus_order - sample order on the media bus
> + * @V4L2_MBUS_ORDER_LE:			least significant sample first
> + * @V4L2_MBUS_ORDER_BE:			most significant sample first
> + */
> +enum v4l2_mbus_order {
> +	V4L2_MBUS_ORDER_LE,
> +	V4L2_MBUS_ORDER_BE,
> +};
> +
> +enum v4l2_mbus_pixelcode {
> +	V4L2_MBUS_FMT_FIXED = 1,
> +	V4L2_MBUS_FMT_YUYV,
> +	V4L2_MBUS_FMT_YVYU,
> +	V4L2_MBUS_FMT_UYVY,
> +	V4L2_MBUS_FMT_VYUY,
> +	V4L2_MBUS_FMT_VYUY_SMPTE170M_8,
> +	V4L2_MBUS_FMT_VYUY_SMPTE170M_16,
> +	V4L2_MBUS_FMT_RGB555,
> +	V4L2_MBUS_FMT_RGB555X,
> +	V4L2_MBUS_FMT_RGB565,
> +	V4L2_MBUS_FMT_RGB565X,
> +	V4L2_MBUS_FMT_SBGGR8,
> +	V4L2_MBUS_FMT_SGBRG8,
> +	V4L2_MBUS_FMT_SGRBG8,
> +	V4L2_MBUS_FMT_SRGGB8,
> +	V4L2_MBUS_FMT_SBGGR10,
> +	V4L2_MBUS_FMT_SGBRG10,
> +	V4L2_MBUS_FMT_SGRBG10,
> +	V4L2_MBUS_FMT_SRGGB10,
> +	V4L2_MBUS_FMT_GREY,
> +	V4L2_MBUS_FMT_Y16,
> +	V4L2_MBUS_FMT_Y10,
> +	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
> +	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
> +	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE,
> +	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE,
> +};
> +
> +/**
> + * struct v4l2_mbus_pixelfmt - Data format on the media bus
> + * @fourcc:		Fourcc code, that will be obtained if the data is
> + *			stored in memory in the following way:
> + * @name:		Name of the format
> + * @packing:		Type of sample-packing, that has to be used
> + * @order:		Sample order when storing in memory
> + * @bits_per_sample:	How many bits the bridge has to sample
> + */
> +struct v4l2_mbus_pixelfmt {
> +	u32			fourcc;
> +	const char		*name;
> +	enum v4l2_mbus_packing	packing;
> +	enum v4l2_mbus_order	order;
> +	u8			bits_per_sample;
> +};
> +
> +/**
> + * struct v4l2_mbus_framefmt - frame format on the media bus
> + * @width:	frame width
> + * @height:	frame height
> + * @code:	data format code
> + * @field:	used interlacing type
> + * @colorspace:	colorspace of the data
> + */
> +struct v4l2_mbus_framefmt {
> +	__u32				width;
> +	__u32				height;
> +	enum v4l2_mbus_pixelcode	code;
> +	enum v4l2_field			field;
> +	enum v4l2_colorspace		colorspace;
> +};
> +
> +#endif
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 04193eb..574fae3 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -22,6 +22,7 @@
>  #define _V4L2_SUBDEV_H
>
>  #include <media/v4l2-common.h>
> +#include <media/v4l2-mediabus.h>
>
>  struct v4l2_device;
>  struct v4l2_subdev;
> @@ -196,7 +197,7 @@ struct v4l2_subdev_audio_ops {
>     s_std_output: set v4l2_std_id for video OUTPUT devices. This is
> ignored by
>  	video input devices.
>
> -  s_crystal_freq: sets the frequency of the crystal used to generate the
> +   s_crystal_freq: sets the frequency of the crystal used to generate the
>  	clocks in Hz. An extra flags field allows device specific configuration
>  	regarding clock frequency dividers, etc. If not used, then set flags
>  	to 0. If the frequency is not supported, then -EINVAL is returned.
> @@ -206,6 +207,14 @@ struct v4l2_subdev_audio_ops {
>
>     s_routing: see s_routing in audio_ops, except this version is for
> video
>  	devices.
> +
> +   enum_mbus_fmt: enumerate pixel formats, provided by a video data
> source
> +
> +   g_mbus_fmt: get the current pixel format, provided by a video data
> source
> +
> +   try_mbus_fmt: try to set a pixel format on a video data source
> +
> +   s_mbus_fmt: set a pixel format on a video data source
>   */
>  struct v4l2_subdev_video_ops {
>  	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32
> config);
> @@ -227,6 +236,14 @@ struct v4l2_subdev_video_ops {
>  	int (*s_crop)(struct v4l2_subdev *sd, struct v4l2_crop *crop);
>  	int (*g_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
>  	int (*s_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
> +	int (*enum_mbus_fmt)(struct v4l2_subdev *sd, int index,
> +			     enum v4l2_mbus_pixelcode *code);
> +	int (*g_mbus_fmt)(struct v4l2_subdev *sd,
> +			  struct v4l2_mbus_framefmt *fmt);
> +	int (*try_mbus_fmt)(struct v4l2_subdev *sd,
> +			    struct v4l2_mbus_framefmt *fmt);
> +	int (*s_mbus_fmt)(struct v4l2_subdev *sd,
> +			  struct v4l2_mbus_framefmt *fmt);
>  };
>
>  /**
> --
> 1.6.2.4
>
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

