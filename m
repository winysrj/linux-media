Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52727 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423637AbeCBLFi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 06:05:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v11 16/32] rcar-vin: read subdevice format for crop only when needed
Date: Fri, 02 Mar 2018 13:06:27 +0200
Message-ID: <1860931.WLVs16Imm2@avalon>
In-Reply-To: <20180302015751.25596-17-niklas.soderlund+renesas@ragnatech.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se> <20180302015751.25596-17-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 2 March 2018 03:57:35 EET Niklas S=F6derlund wrote:
> Instead of caching the subdevice format each time the video device
> format is set read it directly when it's needed. As it turns out the
> format is only needed when figuring out the max rectangle for cropping.
>=20
> This simplifies the code and makes it clearer what the source format is
> used for.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 158 +++++++++++++---------=
=2D--
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  12 ---
>  2 files changed, 80 insertions(+), 90 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 3290e603b44cdf3a..55640c6b2a1200ca 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -144,67 +144,62 @@ static int rvin_format_align(struct rvin_dev *vin,
> struct v4l2_pix_format *pix) * V4L2
>   */
>=20
> -static void rvin_reset_crop_compose(struct rvin_dev *vin)
> +static int rvin_get_vin_format_from_source(struct rvin_dev *vin,
> +					   struct v4l2_pix_format *pix)
>  {
> +	struct v4l2_subdev_format fmt =3D {
> +		.which =3D V4L2_SUBDEV_FORMAT_ACTIVE,
> +		.pad =3D vin->digital->source_pad,
> +	};
> +	int ret;
> +
> +	ret =3D v4l2_subdev_call(vin_to_source(vin), pad, get_fmt, NULL, &fmt);
> +	if (ret)
> +		return ret;
> +
> +	v4l2_fill_pix_format(pix, &fmt.format);
> +
> +	return rvin_format_align(vin, pix);
> +}
> +
> +static int rvin_reset_format(struct rvin_dev *vin)
> +{
> +	int ret;
> +
> +	ret =3D rvin_get_vin_format_from_source(vin, &vin->format);
> +	if (ret)
> +		return ret;
> +
>  	vin->crop.top =3D vin->crop.left =3D 0;
> -	vin->crop.width =3D vin->source.width;
> -	vin->crop.height =3D vin->source.height;
> +	vin->crop.width =3D vin->format.width;
> +	vin->crop.height =3D vin->format.height;
>=20
>  	vin->compose.top =3D vin->compose.left =3D 0;
>  	vin->compose.width =3D vin->format.width;
>  	vin->compose.height =3D vin->format.height;
> -}
> -
> -static int rvin_reset_format(struct rvin_dev *vin)
> -{
> -	struct v4l2_subdev_format fmt =3D {
> -		.which =3D V4L2_SUBDEV_FORMAT_ACTIVE,
> -	};
> -	struct v4l2_mbus_framefmt *mf =3D &fmt.format;
> -	int ret;
> -
> -	fmt.pad =3D vin->digital->source_pad;
> -
> -	ret =3D v4l2_subdev_call(vin_to_source(vin), pad, get_fmt, NULL, &fmt);
> -	if (ret)
> -		return ret;
> -
> -	vin->format.width	=3D mf->width;
> -	vin->format.height	=3D mf->height;
> -	vin->format.colorspace	=3D mf->colorspace;
> -	vin->format.field	=3D mf->field;
> -
> -	rvin_reset_crop_compose(vin);
> -
> -	vin->format.bytesperline =3D rvin_format_bytesperline(&vin->format);
> -	vin->format.sizeimage =3D rvin_format_sizeimage(&vin->format);
>=20
>  	return 0;
>  }
>=20
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
> +	v4l2_fill_mbus_format(&format.format, pix, vin->digital->code);
>=20
>  	/* Allow the video device to override field and to scale */
>  	field =3D pix->field;
> @@ -217,34 +212,34 @@ static int __rvin_try_format_source(struct rvin_dev
> *vin,
>=20
>  	v4l2_fill_pix_format(pix, &format.format);
>=20
> -	source->width =3D pix->width;
> -	source->height =3D pix->height;
> +	crop->top =3D crop->left =3D 0;
> +	crop->width =3D pix->width;
> +	crop->height =3D pix->height;
> +
> +	/*
> +	 * If source is ALTERNATE the driver will use the VIN hardware
> +	 * to INTERLACE it. The crop height then needs to be doubled.
> +	 */
> +	if (pix->field =3D=3D V4L2_FIELD_ALTERNATE)
> +		crop->height *=3D 2;
> +
> +	if (field !=3D V4L2_FIELD_ANY)
> +		pix->field =3D field;
>=20
> -	pix->field =3D field;
>  	pix->width =3D width;
>  	pix->height =3D height;
>=20
> -	vin_dbg(vin, "Source resolution: %ux%u\n", source->width,
> -		source->height);
> +	ret =3D rvin_format_align(vin, pix);
> +	if (ret)
> +		return ret;
>=20
> +	compose->top =3D compose->left =3D 0;
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
> @@ -263,33 +258,30 @@ static int rvin_try_fmt_vid_cap(struct file *file,
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
>=20
>  	return 0;
>  }
> @@ -319,6 +311,8 @@ static int rvin_g_selection(struct file *file, void *=
fh,
> struct v4l2_selection *s)
>  {
>  	struct rvin_dev *vin =3D video_drvdata(file);
> +	struct v4l2_pix_format pix;
> +	int ret;
>=20
>  	if (s->type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
> @@ -326,9 +320,12 @@ static int rvin_g_selection(struct file *file, void
> *fh, switch (s->target) {
>  	case V4L2_SEL_TGT_CROP_BOUNDS:
>  	case V4L2_SEL_TGT_CROP_DEFAULT:
> +		ret =3D rvin_get_vin_format_from_source(vin, &pix);
> +		if (ret)
> +			return ret;
>  		s->r.left =3D s->r.top =3D 0;
> -		s->r.width =3D vin->source.width;
> -		s->r.height =3D vin->source.height;
> +		s->r.width =3D pix.width;
> +		s->r.height =3D pix.height;
>  		break;
>  	case V4L2_SEL_TGT_CROP:
>  		s->r =3D vin->crop;
> @@ -353,6 +350,7 @@ static int rvin_s_selection(struct file *file, void *=
fh,
> struct v4l2_selection *s)
>  {
>  	struct rvin_dev *vin =3D video_drvdata(file);
> +	struct v4l2_pix_format pix;
>  	const struct rvin_video_format *fmt;
>  	struct v4l2_rect r =3D s->r;
>  	struct v4l2_rect max_rect;
> @@ -360,6 +358,7 @@ static int rvin_s_selection(struct file *file, void *=
fh,
> .width =3D 6,
>  		.height =3D 2,
>  	};
> +	int ret;
>=20
>  	if (s->type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
> @@ -369,22 +368,25 @@ static int rvin_s_selection(struct file *file, void
> *fh, switch (s->target) {
>  	case V4L2_SEL_TGT_CROP:
>  		/* Can't crop outside of source input */
> +		ret =3D rvin_get_vin_format_from_source(vin, &pix);
> +		if (ret)
> +			return ret;

I don't think the crop rectangle should be validated against the current=20
source format, but against the current video node format. As noted in my=20
review of the previous version:

If you stop caching the source format you'll end up validating the crop=20
rectangle against the current source format. What will happen if the format=
=20
changed since the last VIDIOC_S_FMT call ?

And thinking about it, are sources allowed to change their format autonomou=
sly=20
? They surely can detect format changes, but can they update the format=20
without notifying anyone ? Looking at the adv7180 driver for instance, the=
=20
format depends on the TV standard, but the driver doesn't change it. It onl=
y=20
reports newly detected standards and relies on someone then calling the s_s=
td=20
operation. The VIN driver should then in its S_STD handler retrieve the new=
=20
source format, and reset the crop rectangle accordingly.

I believe the same applies to V4L2_SEL_TGT_CROP_BOUNDS and=20
V4L2_SEL_TGT_CROP_DEFAULT.

>  		max_rect.top =3D max_rect.left =3D 0;
> -		max_rect.width =3D vin->source.width;
> -		max_rect.height =3D vin->source.height;
> +		max_rect.width =3D pix.width;
> +		max_rect.height =3D pix.height;
>  		v4l2_rect_map_inside(&r, &max_rect);
>=20
> -		v4l_bound_align_image(&r.width, 2, vin->source.width, 1,
> -				      &r.height, 4, vin->source.height, 2, 0);
> +		v4l_bound_align_image(&r.width, 2, pix.width, 1,
> +				      &r.height, 4, pix.height, 2, 0);
>=20
> -		r.top  =3D clamp_t(s32, r.top, 0, vin->source.height - r.height);
> -		r.left =3D clamp_t(s32, r.left, 0, vin->source.width - r.width);
> +		r.top  =3D clamp_t(s32, r.top, 0, pix.height - r.height);
> +		r.left =3D clamp_t(s32, r.left, 0, pix.width - r.width);
>=20
>  		vin->crop =3D s->r =3D r;
>=20
>  		vin_dbg(vin, "Cropped %dx%d@%d:%d of %dx%d\n",
>  			r.width, r.height, r.left, r.top,
> -			vin->source.width, vin->source.height);
> +			pix.width, pix.height);
>  		break;
>  	case V4L2_SEL_TGT_COMPOSE:
>  		/* Make sure compose rect fits inside output format */
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> 8daba9db0e927a49..39051da31650bd79 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -48,16 +48,6 @@ enum rvin_dma_state {
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
> @@ -124,7 +114,6 @@ struct rvin_info {
>   * @sequence:		V4L2 buffers sequence number
>   * @state:		keeps track of operation state
>   *
> - * @source:		active format from the video source
>   * @format:		active V4L2 pixel format
>   *
>   * @crop:		active cropping
> @@ -151,7 +140,6 @@ struct rvin_dev {
>  	unsigned int sequence;
>  	enum rvin_dma_state state;
>=20
> -	struct rvin_source_fmt source;
>  	struct v4l2_pix_format format;
>=20
>  	struct v4l2_rect crop;


=2D-=20
Regards,

Laurent Pinchart
