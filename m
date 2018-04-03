Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42742 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753289AbeDCWJV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2018 18:09:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v13 16/33] rcar-vin: simplify how formats are set and reset
Date: Wed, 04 Apr 2018 01:09:29 +0300
Message-ID: <1544952.AcMr2TBica@avalon>
In-Reply-To: <20180326214456.6655-17-niklas.soderlund+renesas@ragnatech.se>
References: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se> <20180326214456.6655-17-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Tuesday, 27 March 2018 00:44:39 EEST Niklas S=F6derlund wrote:
> With the recent cleanup of the format code to prepare for Gen3 it's
> possible to simplify the Gen2 format code path as well. Clean up the
> process by defining two functions to handle the set format and reset of
> format when the standard is changed.
>=20
> While at it replace the driver local struct rvin_source_fmt with a
> struct v4l2_rect as all it's used for is keep track of the source
> dimensions.

I wonder whether we should introduce v4l2_size (or <insert your preferred n=
ame=20
here>) when all we need is width and height, as v4l2_rect stores the top an=
d=20
left offsets too. This doesn't have to be fixed here though.

> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> ---
>=20
> * Changes since v11
> - This patch where 'rcar-vin: read subdevice format for crop only when
> needed'
> - Keep caching the source dimensions and drop all changes to
> rvin_g_selection() and rvin_s_selection().
> - Inline rvin_get_vin_format_from_source() into rvin_reset_format()
> which now is the only user left.
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 116 +++++++++++-----------=
=2D--
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  14 +---
>  2 files changed, 52 insertions(+), 78 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> c39891386576afb8..c4be0bcb8b16f941 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -138,67 +138,60 @@ static int rvin_format_align(struct rvin_dev *vin,
> struct v4l2_pix_format *pix) * V4L2
>   */
>=20
> -static void rvin_reset_crop_compose(struct rvin_dev *vin)
> -{
> -	vin->crop.top =3D vin->crop.left =3D 0;
> -	vin->crop.width =3D vin->source.width;
> -	vin->crop.height =3D vin->source.height;
> -
> -	vin->compose.top =3D vin->compose.left =3D 0;
> -	vin->compose.width =3D vin->format.width;
> -	vin->compose.height =3D vin->format.height;
> -}
> -
>  static int rvin_reset_format(struct rvin_dev *vin)
>  {
>  	struct v4l2_subdev_format fmt =3D {
>  		.which =3D V4L2_SUBDEV_FORMAT_ACTIVE,
> +		.pad =3D vin->digital->source_pad,
>  	};
> -	struct v4l2_mbus_framefmt *mf =3D &fmt.format;
>  	int ret;
>=20
> -	fmt.pad =3D vin->digital->source_pad;
> -
>  	ret =3D v4l2_subdev_call(vin_to_source(vin), pad, get_fmt, NULL, &fmt);
>  	if (ret)
>  		return ret;
>=20
> -	vin->format.width	=3D mf->width;
> -	vin->format.height	=3D mf->height;
> -	vin->format.colorspace	=3D mf->colorspace;
> -	vin->format.field	=3D mf->field;
> +	v4l2_fill_pix_format(&vin->format, &fmt.format);
>=20
> -	rvin_reset_crop_compose(vin);
> +	ret =3D rvin_format_align(vin, &vin->format);
> +	if (ret)
> +		return ret;

rvin_format_align() always returns 0 so you can remove the error check. You=
=20
can actually turn the function into a void function.

> -	vin->format.bytesperline =3D rvin_format_bytesperline(&vin->format);
> -	vin->format.sizeimage =3D rvin_format_sizeimage(&vin->format);
> +	vin->source.top =3D vin->crop.top =3D 0;
> +	vin->source.left =3D vin->crop.left =3D 0;
> +	vin->source.width =3D vin->crop.width =3D vin->format.width;
> +	vin->source.height =3D vin->crop.height =3D vin->format.height;

I find multiple assignations on the same line hard to read. How about

	vin->source.top =3D 0;
	vin->source.left =3D 0;
	vin->source.width =3D vin->format.width;
	vin->source.height =3D vin->format.height;

	vin->crop =3D vin->source;
	vin->compose =3D vin->source;

> +	vin->compose.top =3D vin->compose.left =3D 0;
> +	vin->compose.width =3D vin->format.width;
> +	vin->compose.height =3D vin->format.height;
>=20
>  	return 0;
>  }

I like the new rvin_reset_format(), it's much simpler.

> -static int __rvin_try_format_source(struct rvin_dev *vin,
> -				    u32 which,
> -				    struct v4l2_pix_format *pix,
> -				    struct rvin_source_fmt *source)
> +static int rvin_try_format(struct rvin_dev *vin, u32 which,
> +			   struct v4l2_pix_format *pix,
> +			   struct v4l2_rect *crop, struct v4l2_rect *compose)
>  {
> -	struct v4l2_subdev *sd;
> +	struct v4l2_subdev *sd =3D vin_to_source(vin);
>  	struct v4l2_subdev_pad_config *pad_cfg;
>  	struct v4l2_subdev_format format =3D {
>  		.which =3D which,
> +		.pad =3D vin->digital->source_pad,
>  	};
>  	enum v4l2_field field;
>  	u32 width, height;
>  	int ret;
>=20
> -	sd =3D vin_to_source(vin);
> -
> -	v4l2_fill_mbus_format(&format.format, pix, vin->digital->code);
> -
>  	pad_cfg =3D v4l2_subdev_alloc_pad_config(sd);
>  	if (pad_cfg =3D=3D NULL)
>  		return -ENOMEM;
>=20
> -	format.pad =3D vin->digital->source_pad;
> +	if (!rvin_format_from_pixel(pix->pixelformat) ||
> +	    (vin->info->model =3D=3D RCAR_M1 &&
> +	     pix->pixelformat =3D=3D V4L2_PIX_FMT_XBGR32))
> +		pix->pixelformat =3D RVIN_DEFAULT_FORMAT;
> +
> +	v4l2_fill_mbus_format(&format.format, pix, vin->digital->code);
>=20
>  	/* Allow the video device to override field and to scale */
>  	field =3D pix->field;
> @@ -211,8 +204,16 @@ static int __rvin_try_format_source(struct rvin_dev
> *vin,
>=20
>  	v4l2_fill_pix_format(pix, &format.format);
>=20
> -	source->width =3D pix->width;
> -	source->height =3D pix->height;
> +	crop->top =3D crop->left =3D 0;

I'd split this in two lines, it would be easier to read.

> +	crop->width =3D pix->width;
> +	crop->height =3D pix->height;
> +
> +	/*
> +	 * If source is ALTERNATE the driver will use the VIN hardware
> +	 * to INTERLACE it. The crop height then needs to be doubled.
> +	 */
> +	if (pix->field =3D=3D V4L2_FIELD_ALTERNATE)
> +		crop->height *=3D 2;

You're duplicating this logic in rvin_format_align() so it makes me feel th=
at=20
there's still room for some simplification, but that can be done in a separ=
ate=20
patch (or I could simply be wrong).

>  	if (field !=3D V4L2_FIELD_ANY)
>  		pix->field =3D field;
> @@ -220,32 +221,17 @@ static int __rvin_try_format_source(struct rvin_dev
> *vin, pix->width =3D width;
>  	pix->height =3D height;
>=20
> -	vin_dbg(vin, "Source resolution: %ux%u\n", source->width,
> -		source->height);
> +	ret =3D rvin_format_align(vin, pix);
> +	if (ret)
> +		return ret;
>=20
> +	compose->top =3D compose->left =3D 0;

Ditto.

> +	compose->width =3D pix->width;
> +	compose->height =3D pix->height;
>  done:
>  	v4l2_subdev_free_pad_config(pad_cfg);
> -	return ret;
> -}
>=20
> -static int __rvin_try_format(struct rvin_dev *vin,
> -			     u32 which,
> -			     struct v4l2_pix_format *pix,
> -			     struct rvin_source_fmt *source)
> -{
> -	int ret;
> -
> -	if (!rvin_format_from_pixel(pix->pixelformat) ||
> -	    (vin->info->model =3D=3D RCAR_M1 &&
> -	     pix->pixelformat =3D=3D V4L2_PIX_FMT_XBGR32))
> -		pix->pixelformat =3D RVIN_DEFAULT_FORMAT;
> -
> -	/* Limit to source capabilities */
> -	ret =3D __rvin_try_format_source(vin, which, pix, source);
> -	if (ret)
> -		return ret;
> -
> -	return rvin_format_align(vin, pix);
> +	return 0;
>  }
>=20
>  static int rvin_querycap(struct file *file, void *priv,
> @@ -264,33 +250,31 @@ static int rvin_try_fmt_vid_cap(struct file *file,
> void *priv, struct v4l2_format *f)
>  {
>  	struct rvin_dev *vin =3D video_drvdata(file);
> -	struct rvin_source_fmt source;
> +	struct v4l2_rect crop, compose;
>=20
> -	return __rvin_try_format(vin, V4L2_SUBDEV_FORMAT_TRY, &f->fmt.pix,
> -				 &source);
> +	return rvin_try_format(vin, V4L2_SUBDEV_FORMAT_TRY, &f->fmt.pix, &crop,
> +			       &compose);

How about making crop and compose optional in rvin_try_format() to avoid a=
=20
need for the two local variables here ?

Apart from these small issues, I think this is a nice simplification,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  }
>=20
>  static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
>  			      struct v4l2_format *f)
>  {
>  	struct rvin_dev *vin =3D video_drvdata(file);
> -	struct rvin_source_fmt source;
> +	struct v4l2_rect crop, compose;
>  	int ret;
>=20
>  	if (vb2_is_busy(&vin->queue))
>  		return -EBUSY;
>=20
> -	ret =3D __rvin_try_format(vin, V4L2_SUBDEV_FORMAT_ACTIVE, &f->fmt.pix,
> -				&source);
> +	ret =3D rvin_try_format(vin, V4L2_SUBDEV_FORMAT_ACTIVE, &f->fmt.pix,
> +			      &crop, &compose);
>  	if (ret)
>  		return ret;
>=20
> -	vin->source.width =3D source.width;
> -	vin->source.height =3D source.height;
> -
>  	vin->format =3D f->fmt.pix;
> -
> -	rvin_reset_crop_compose(vin);
> +	vin->crop =3D crop;
> +	vin->compose =3D compose;
> +	vin->source =3D crop;
>=20
>  	return 0;
>  }
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> 1c91b774205a7750..e940366d7e8d0e76 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -46,16 +46,6 @@ enum rvin_dma_state {
>  	STOPPING,
>  };
>=20
> -/**
> - * struct rvin_source_fmt - Source information
> - * @width:	Width from source
> - * @height:	Height from source
> - */
> -struct rvin_source_fmt {
> -	u32 width;
> -	u32 height;
> -};
> -
>  /**
>   * struct rvin_video_format - Data format stored in memory
>   * @fourcc:	Pixelformat
> @@ -123,11 +113,11 @@ struct rvin_info {
>   * @sequence:		V4L2 buffers sequence number
>   * @state:		keeps track of operation state
>   *
> - * @source:		active format from the video source
>   * @format:		active V4L2 pixel format
>   *
>   * @crop:		active cropping
>   * @compose:		active composing
> + * @source:		active size of the video source
>   */
>  struct rvin_dev {
>  	struct device *dev;
> @@ -151,11 +141,11 @@ struct rvin_dev {
>  	unsigned int sequence;
>  	enum rvin_dma_state state;
>=20
> -	struct rvin_source_fmt source;
>  	struct v4l2_pix_format format;
>=20
>  	struct v4l2_rect crop;
>  	struct v4l2_rect compose;
> +	struct v4l2_rect source;
>  };
>=20
>  #define vin_to_source(vin)		((vin)->digital->subdev)


=2D-=20
Regards,

Laurent Pinchart
