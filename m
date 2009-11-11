Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:2464 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbZKKHz4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 02:55:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH/RFC 7/9 v2] v4l: add an image-bus API for configuring v4l2 subdev pixel and frame formats
Date: Wed, 11 Nov 2009 08:55:56 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange> <Pine.LNX.4.64.0910301438500.4378@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0910301438500.4378@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911110855.56628.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

OK, I've looked at this again. See my comments below.

On Friday 30 October 2009 15:01:27 Guennadi Liakhovetski wrote:
> Video subdevices, like cameras, decoders, connect to video bridges over
> specialised busses. Data is being transferred over these busses in various
> formats, which only loosely correspond to fourcc codes, describing how video
> data is stored in RAM. This is not a one-to-one correspondence, therefore we
> cannot use fourcc codes to configure subdevice output data formats. This patch
> adds codes for several such on-the-bus formats and an API, similar to the
> familiar .s_fmt(), .g_fmt(), .try_fmt(), .enum_fmt() API for configuring those
> codes. After all users of the old API in struct v4l2_subdev_video_ops are
> converted, the API will be removed.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/media/video/Makefile        |    2 +-
>  drivers/media/video/v4l2-imagebus.c |  218 +++++++++++++++++++++++++++++++++++
>  include/media/v4l2-imagebus.h       |   84 ++++++++++++++
>  include/media/v4l2-subdev.h         |   10 ++-
>  4 files changed, 312 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/media/video/v4l2-imagebus.c
>  create mode 100644 include/media/v4l2-imagebus.h
> 
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 7a2dcc3..62d8907 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -10,7 +10,7 @@ stkwebcam-objs	:=	stk-webcam.o stk-sensor.o
>  
>  omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
>  
> -videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o
> +videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-imagebus.o
>  
>  # V4L2 core modules
>  
> diff --git a/drivers/media/video/v4l2-imagebus.c b/drivers/media/video/v4l2-imagebus.c
> new file mode 100644
> index 0000000..e0a3a83
> --- /dev/null
> +++ b/drivers/media/video/v4l2-imagebus.c
> @@ -0,0 +1,218 @@
> +/*
> + * Image Bus API
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
> +#include <media/v4l2-imagebus.h>
> +
> +static const struct v4l2_imgbus_pixelfmt imgbus_fmt[] = {
> +	[V4L2_IMGBUS_FMT_YUYV] = {
> +		.fourcc			= V4L2_PIX_FMT_YUYV,
> +		.colorspace		= V4L2_COLORSPACE_JPEG,
> +		.name			= "YUYV",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_IMGBUS_PACKING_2X8_PADHI,
> +		.order			= V4L2_IMGBUS_ORDER_LE,
> +	}, [V4L2_IMGBUS_FMT_YVYU] = {
> +		.fourcc			= V4L2_PIX_FMT_YVYU,
> +		.colorspace		= V4L2_COLORSPACE_JPEG,
> +		.name			= "YVYU",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_IMGBUS_PACKING_2X8_PADHI,
> +		.order			= V4L2_IMGBUS_ORDER_LE,
> +	}, [V4L2_IMGBUS_FMT_UYVY] = {
> +		.fourcc			= V4L2_PIX_FMT_UYVY,
> +		.colorspace		= V4L2_COLORSPACE_JPEG,
> +		.name			= "UYVY",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_IMGBUS_PACKING_2X8_PADHI,
> +		.order			= V4L2_IMGBUS_ORDER_LE,
> +	}, [V4L2_IMGBUS_FMT_VYUY] = {
> +		.fourcc			= V4L2_PIX_FMT_VYUY,
> +		.colorspace		= V4L2_COLORSPACE_JPEG,
> +		.name			= "VYUY",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_IMGBUS_PACKING_2X8_PADHI,
> +		.order			= V4L2_IMGBUS_ORDER_LE,
> +	}, [V4L2_IMGBUS_FMT_VYUY_SMPTE170M_8] = {
> +		.fourcc			= V4L2_PIX_FMT_VYUY,
> +		.colorspace		= V4L2_COLORSPACE_SMPTE170M,
> +		.name			= "VYUY in SMPTE170M",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_IMGBUS_PACKING_2X8_PADHI,
> +		.order			= V4L2_IMGBUS_ORDER_LE,
> +	}, [V4L2_IMGBUS_FMT_VYUY_SMPTE170M_16] = {
> +		.fourcc			= V4L2_PIX_FMT_VYUY,
> +		.colorspace		= V4L2_COLORSPACE_SMPTE170M,
> +		.name			= "VYUY in SMPTE170M, 16bit",
> +		.bits_per_sample	= 16,
> +		.packing		= V4L2_IMGBUS_PACKING_NONE,
> +		.order			= V4L2_IMGBUS_ORDER_LE,
> +	}, [V4L2_IMGBUS_FMT_RGB555] = {
> +		.fourcc			= V4L2_PIX_FMT_RGB555,
> +		.colorspace		= V4L2_COLORSPACE_SRGB,
> +		.name			= "RGB555",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_IMGBUS_PACKING_2X8_PADHI,
> +		.order			= V4L2_IMGBUS_ORDER_LE,
> +	}, [V4L2_IMGBUS_FMT_RGB555X] = {
> +		.fourcc			= V4L2_PIX_FMT_RGB555X,
> +		.colorspace		= V4L2_COLORSPACE_SRGB,
> +		.name			= "RGB555X",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_IMGBUS_PACKING_2X8_PADHI,
> +		.order			= V4L2_IMGBUS_ORDER_LE,
> +	}, [V4L2_IMGBUS_FMT_RGB565] = {
> +		.fourcc			= V4L2_PIX_FMT_RGB565,
> +		.colorspace		= V4L2_COLORSPACE_SRGB,
> +		.name			= "RGB565",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_IMGBUS_PACKING_2X8_PADHI,
> +		.order			= V4L2_IMGBUS_ORDER_LE,
> +	}, [V4L2_IMGBUS_FMT_RGB565X] = {
> +		.fourcc			= V4L2_PIX_FMT_RGB565X,
> +		.colorspace		= V4L2_COLORSPACE_SRGB,
> +		.name			= "RGB565X",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_IMGBUS_PACKING_2X8_PADHI,
> +		.order			= V4L2_IMGBUS_ORDER_LE,
> +	}, [V4L2_IMGBUS_FMT_SBGGR8] = {
> +		.fourcc			= V4L2_PIX_FMT_SBGGR8,
> +		.colorspace		= V4L2_COLORSPACE_SRGB,
> +		.name			= "Bayer 8 BGGR",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_IMGBUS_PACKING_NONE,
> +		.order			= V4L2_IMGBUS_ORDER_LE,
> +	}, [V4L2_IMGBUS_FMT_SGBRG8] = {
> +		.fourcc			= V4L2_PIX_FMT_SGBRG8,
> +		.colorspace		= V4L2_COLORSPACE_SRGB,
> +		.name			= "Bayer 8 GBRG",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_IMGBUS_PACKING_NONE,
> +		.order			= V4L2_IMGBUS_ORDER_LE,
> +	}, [V4L2_IMGBUS_FMT_SGRBG8] = {
> +		.fourcc			= V4L2_PIX_FMT_SGRBG8,
> +		.colorspace		= V4L2_COLORSPACE_SRGB,
> +		.name			= "Bayer 8 GRBG",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_IMGBUS_PACKING_NONE,
> +		.order			= V4L2_IMGBUS_ORDER_LE,
> +	}, [V4L2_IMGBUS_FMT_SRGGB8] = {
> +		.fourcc			= V4L2_PIX_FMT_SRGGB8,
> +		.colorspace		= V4L2_COLORSPACE_SRGB,
> +		.name			= "Bayer 8 RGGB",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_IMGBUS_PACKING_NONE,
> +		.order			= V4L2_IMGBUS_ORDER_LE,
> +	}, [V4L2_IMGBUS_FMT_SBGGR10] = {
> +		.fourcc			= V4L2_PIX_FMT_SBGGR10,
> +		.colorspace		= V4L2_COLORSPACE_SRGB,
> +		.name			= "Bayer 10 BGGR",
> +		.bits_per_sample	= 10,
> +		.packing		= V4L2_IMGBUS_PACKING_EXTEND16,
> +		.order			= V4L2_IMGBUS_ORDER_LE,
> +	}, [V4L2_IMGBUS_FMT_SGBRG10] = {
> +		.fourcc			= V4L2_PIX_FMT_SGBRG10,
> +		.colorspace		= V4L2_COLORSPACE_SRGB,
> +		.name			= "Bayer 10 GBRG",
> +		.bits_per_sample	= 10,
> +		.packing		= V4L2_IMGBUS_PACKING_EXTEND16,
> +		.order			= V4L2_IMGBUS_ORDER_LE,
> +	}, [V4L2_IMGBUS_FMT_SGRBG10] = {
> +		.fourcc			= V4L2_PIX_FMT_SGRBG10,
> +		.colorspace		= V4L2_COLORSPACE_SRGB,
> +		.name			= "Bayer 10 GRBG",
> +		.bits_per_sample	= 10,
> +		.packing		= V4L2_IMGBUS_PACKING_EXTEND16,
> +		.order			= V4L2_IMGBUS_ORDER_LE,
> +	}, [V4L2_IMGBUS_FMT_SRGGB10] = {
> +		.fourcc			= V4L2_PIX_FMT_SRGGB10,
> +		.colorspace		= V4L2_COLORSPACE_SRGB,
> +		.name			= "Bayer 10 RGGB",
> +		.bits_per_sample	= 10,
> +		.packing		= V4L2_IMGBUS_PACKING_EXTEND16,
> +		.order			= V4L2_IMGBUS_ORDER_LE,
> +	}, [V4L2_IMGBUS_FMT_GREY] = {
> +		.fourcc			= V4L2_PIX_FMT_GREY,
> +		.colorspace		= V4L2_COLORSPACE_JPEG,
> +		.name			= "Grey",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_IMGBUS_PACKING_NONE,
> +		.order			= V4L2_IMGBUS_ORDER_LE,
> +	}, [V4L2_IMGBUS_FMT_Y16] = {
> +		.fourcc			= V4L2_PIX_FMT_Y16,
> +		.colorspace		= V4L2_COLORSPACE_JPEG,
> +		.name			= "Grey 16bit",
> +		.bits_per_sample	= 16,
> +		.packing		= V4L2_IMGBUS_PACKING_NONE,
> +		.order			= V4L2_IMGBUS_ORDER_LE,
> +	}, [V4L2_IMGBUS_FMT_Y10] = {
> +		.fourcc			= V4L2_PIX_FMT_Y10,
> +		.colorspace		= V4L2_COLORSPACE_JPEG,
> +		.name			= "Grey 10bit",
> +		.bits_per_sample	= 10,
> +		.packing		= V4L2_IMGBUS_PACKING_EXTEND16,
> +		.order			= V4L2_IMGBUS_ORDER_LE,
> +	}, [V4L2_IMGBUS_FMT_SBGGR10_2X8_PADHI_LE] = {
> +		.fourcc			= V4L2_PIX_FMT_SBGGR10,
> +		.colorspace		= V4L2_COLORSPACE_SRGB,
> +		.name			= "Bayer 10 BGGR",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_IMGBUS_PACKING_2X8_PADHI,
> +		.order			= V4L2_IMGBUS_ORDER_LE,
> +	}, [V4L2_IMGBUS_FMT_SBGGR10_2X8_PADLO_LE] = {
> +		.fourcc			= V4L2_PIX_FMT_SBGGR10,
> +		.colorspace		= V4L2_COLORSPACE_SRGB,
> +		.name			= "Bayer 10 BGGR",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_IMGBUS_PACKING_2X8_PADLO,
> +		.order			= V4L2_IMGBUS_ORDER_LE,
> +	}, [V4L2_IMGBUS_FMT_SBGGR10_2X8_PADHI_BE] = {
> +		.fourcc			= V4L2_PIX_FMT_SBGGR10,
> +		.colorspace		= V4L2_COLORSPACE_SRGB,
> +		.name			= "Bayer 10 BGGR",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_IMGBUS_PACKING_2X8_PADHI,
> +		.order			= V4L2_IMGBUS_ORDER_BE,
> +	}, [V4L2_IMGBUS_FMT_SBGGR10_2X8_PADLO_BE] = {
> +		.fourcc			= V4L2_PIX_FMT_SBGGR10,
> +		.colorspace		= V4L2_COLORSPACE_SRGB,
> +		.name			= "Bayer 10 BGGR",
> +		.bits_per_sample	= 8,
> +		.packing		= V4L2_IMGBUS_PACKING_2X8_PADLO,
> +		.order			= V4L2_IMGBUS_ORDER_BE,
> +	},
> +};
> +
> +const struct v4l2_imgbus_pixelfmt *v4l2_imgbus_get_fmtdesc(
> +	enum v4l2_imgbus_pixelcode code)
> +{
> +	if ((unsigned int)code > ARRAY_SIZE(imgbus_fmt))
> +		return NULL;
> +	return imgbus_fmt + code;
> +}
> +EXPORT_SYMBOL(v4l2_imgbus_get_fmtdesc);
> +
> +s32 v4l2_imgbus_bytes_per_line(u32 width,
> +			       const struct v4l2_imgbus_pixelfmt *imgf)
> +{
> +	switch (imgf->packing) {
> +	case V4L2_IMGBUS_PACKING_NONE:
> +		return width * imgf->bits_per_sample / 8;
> +	case V4L2_IMGBUS_PACKING_2X8_PADHI:
> +	case V4L2_IMGBUS_PACKING_2X8_PADLO:
> +	case V4L2_IMGBUS_PACKING_EXTEND16:
> +		return width * 2;
> +	}
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL(v4l2_imgbus_bytes_per_line);

As you know, I am not convinced that this code belongs in the core. I do not
think this translation from IMGBUS to PIXFMT is generic enough. However, if
you just make this part of soc-camera then I am OK with this.

> diff --git a/include/media/v4l2-imagebus.h b/include/media/v4l2-imagebus.h
> new file mode 100644
> index 0000000..022d044
> --- /dev/null
> +++ b/include/media/v4l2-imagebus.h
> @@ -0,0 +1,84 @@
> +/*
> + * Image Bus API header
> + *
> + * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef V4L2_IMGBUS_H
> +#define V4L2_IMGBUS_H
> +
> +enum v4l2_imgbus_packing {
> +	V4L2_IMGBUS_PACKING_NONE,
> +	V4L2_IMGBUS_PACKING_2X8_PADHI,
> +	V4L2_IMGBUS_PACKING_2X8_PADLO,
> +	V4L2_IMGBUS_PACKING_EXTEND16,
> +};
> +
> +enum v4l2_imgbus_order {
> +	V4L2_IMGBUS_ORDER_LE,
> +	V4L2_IMGBUS_ORDER_BE,
> +};

For the same reason I think these enums should be soc-camera internal.

> +
> +enum v4l2_imgbus_pixelcode {

It's probably a good idea to start with something like:

	V4L2_IMGBUS_FMT_FIXED = 1,

since many video encoders/decoders have a fixed bus format, so in those cases
there is nothing to set up.

I also like to leave value 0 free, that way it can be used as a special value
internally (or as sentinel in a imgbus array as suggested below).

One other comment to throw into the pot: what about calling this just
V4L2_BUS_FMT...? So imgbus becomes just bus. For some reason I find imgbus a
bit odd. Probably because I think of it more as a video bus or even as a more
general data bus. For all I know it might be used in the future to choose
between different types of histogram data or something like that.

Or is this just me?

> +	V4L2_IMGBUS_FMT_YUYV,
> +	V4L2_IMGBUS_FMT_YVYU,
> +	V4L2_IMGBUS_FMT_UYVY,
> +	V4L2_IMGBUS_FMT_VYUY,
> +	V4L2_IMGBUS_FMT_VYUY_SMPTE170M_8,
> +	V4L2_IMGBUS_FMT_VYUY_SMPTE170M_16,
> +	V4L2_IMGBUS_FMT_RGB555,
> +	V4L2_IMGBUS_FMT_RGB555X,
> +	V4L2_IMGBUS_FMT_RGB565,
> +	V4L2_IMGBUS_FMT_RGB565X,
> +	V4L2_IMGBUS_FMT_SBGGR8,
> +	V4L2_IMGBUS_FMT_SGBRG8,
> +	V4L2_IMGBUS_FMT_SGRBG8,
> +	V4L2_IMGBUS_FMT_SRGGB8,
> +	V4L2_IMGBUS_FMT_SBGGR10,
> +	V4L2_IMGBUS_FMT_SGBRG10,
> +	V4L2_IMGBUS_FMT_SGRBG10,
> +	V4L2_IMGBUS_FMT_SRGGB10,
> +	V4L2_IMGBUS_FMT_GREY,
> +	V4L2_IMGBUS_FMT_Y16,
> +	V4L2_IMGBUS_FMT_Y10,
> +	V4L2_IMGBUS_FMT_SBGGR10_2X8_PADHI_BE,
> +	V4L2_IMGBUS_FMT_SBGGR10_2X8_PADLO_BE,
> +	V4L2_IMGBUS_FMT_SBGGR10_2X8_PADHI_LE,
> +	V4L2_IMGBUS_FMT_SBGGR10_2X8_PADLO_LE,

Obviously the meaning of these formats need to be documented in this header
as well. Are all these imgbus formats used? Anything that is not used shouldn't
be in this list IMHO.

> +};
> +
> +/**
> + * struct v4l2_imgbus_pixelfmt - Data format on the image bus
> + * @fourcc:		Fourcc code...
> + * @colorspace:		and colorspace, that will be obtained if the data is
> + *			stored in memory in the following way:
> + * @bits_per_sample:	How many bits the bridge has to sample
> + * @packing:		Type of sample-packing, that has to be used
> + * @order:		Sample order when storing in memory
> + */
> +struct v4l2_imgbus_pixelfmt {
> +	u32				fourcc;
> +	enum v4l2_colorspace		colorspace;
> +	const char			*name;
> +	enum v4l2_imgbus_packing	packing;
> +	enum v4l2_imgbus_order		order;
> +	u8				bits_per_sample;
> +};

Ditto for this struct. Note that the colorspace field should be moved to
imgbus_framefmt.

> +
> +struct v4l2_imgbus_framefmt {
> +	__u32				width;
> +	__u32				height;
> +	enum v4l2_imgbus_pixelcode	code;
> +	enum v4l2_field			field;
> +};

Interesting observation: this struct is almost identical to struct
v4l2_pix_format. Frankly, I really wonder whether we shouldn't reuse that
struct. In many cases (mostly for video encoders/decoders) the VIDIOC_S_FMT
ioctl and friends can just pass the fmt.pix pointer directly to the subdev.

So keeping this struct will make life easier. The only thing we have to make
a note of in the subdev header is that the pixelformat will be interpreted
as an imgbus 'pixelformat' instead.

Note that the current g/s/try_fmt subdev functions receive a struct v4l2_format
pointer. I think that can be replaced by struct v4l2_pix_format. I don't think
that there is any subdev driver that needs anything other than that struct. That
would definitely simplify the driver code.

Regarding the enum_imgbus_fmt: what about just adding a 'const u32 *imgbus_fmts'
field to v4l2_subdev? Or do you think that this might be something that cannot
be const? I.e., that the subdev driver needs to modify the list of available fmts
dynamically?

Regards,

	Hans

> +
> +const struct v4l2_imgbus_pixelfmt *v4l2_imgbus_get_fmtdesc(
> +	enum v4l2_imgbus_pixelcode code);
> +s32 v4l2_imgbus_bytes_per_line(u32 width,
> +			       const struct v4l2_imgbus_pixelfmt *imgf);
> +
> +#endif
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 04193eb..1e86f39 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -22,6 +22,7 @@
>  #define _V4L2_SUBDEV_H
>  
>  #include <media/v4l2-common.h>
> +#include <media/v4l2-imagebus.h>
>  
>  struct v4l2_device;
>  struct v4l2_subdev;
> @@ -196,7 +197,7 @@ struct v4l2_subdev_audio_ops {
>     s_std_output: set v4l2_std_id for video OUTPUT devices. This is ignored by
>  	video input devices.
>  
> -  s_crystal_freq: sets the frequency of the crystal used to generate the
> +   s_crystal_freq: sets the frequency of the crystal used to generate the
>  	clocks in Hz. An extra flags field allows device specific configuration
>  	regarding clock frequency dividers, etc. If not used, then set flags
>  	to 0. If the frequency is not supported, then -EINVAL is returned.
> @@ -206,6 +207,8 @@ struct v4l2_subdev_audio_ops {
>  
>     s_routing: see s_routing in audio_ops, except this version is for video
>  	devices.
> +
> +   enum_imgbus_fmt: enumerate pixel formats provided by a video data source
>   */
>  struct v4l2_subdev_video_ops {
>  	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 config);
> @@ -227,6 +230,11 @@ struct v4l2_subdev_video_ops {
>  	int (*s_crop)(struct v4l2_subdev *sd, struct v4l2_crop *crop);
>  	int (*g_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
>  	int (*s_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
> +	int (*enum_imgbus_fmt)(struct v4l2_subdev *sd, int index,
> +			       enum v4l2_imgbus_pixelcode *code);
> +	int (*g_imgbus_fmt)(struct v4l2_subdev *sd, struct v4l2_imgbus_framefmt *fmt);
> +	int (*try_imgbus_fmt)(struct v4l2_subdev *sd, struct v4l2_imgbus_framefmt *fmt);
> +	int (*s_imgbus_fmt)(struct v4l2_subdev *sd, struct v4l2_imgbus_framefmt *fmt);
>  };
>  
>  /**



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
