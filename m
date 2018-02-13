Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44260 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934279AbeBMQNg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 11:13:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 09/30] rcar-vin: read subdevice format for crop only when needed
Date: Tue, 13 Feb 2018 18:14:07 +0200
Message-ID: <2735261.SJ460D8jJd@avalon>
In-Reply-To: <20180129163435.24936-10-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se> <20180129163435.24936-10-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Monday, 29 January 2018 18:34:14 EET Niklas S=F6derlund wrote:
> Instead of caching the subdevice format each time the video device
> format is set read it directly when it's needed. As it turns out the
> format is only needed when figuring out the max rectangle for cropping.
>=20
> This simplifies the code and makes it clearer what the source format is
> used for.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 112 +++++++++++++---------=
=2D-
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  12 ---
>  2 files changed, 61 insertions(+), 63 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> c2265324c7c96308..4d5be2d0c79c9c9a 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -90,35 +90,54 @@ static u32 rvin_format_sizeimage(struct v4l2_pix_form=
at
> *pix) * V4L2
>   */
>=20
> -static void rvin_reset_crop_compose(struct rvin_dev *vin)
> +static int rvin_get_source_format(struct rvin_dev *vin,
> +				  struct v4l2_mbus_framefmt *mbus_fmt)
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
> +	memcpy(mbus_fmt, &fmt.format, sizeof(*mbus_fmt));

You can use

	*mbus_fmt =3D fmt.format;

That way the compiler will catch more mistakes, for instance incompatible=20
types between the two arguments.

> +
> +	return 0;
> +}
> +
> +static int rvin_reset_crop_compose(struct rvin_dev *vin)
> +{
> +	struct v4l2_mbus_framefmt source_fmt;
> +	int ret;
> +
> +	ret =3D rvin_get_source_format(vin, &source_fmt);
> +	if (ret)
> +		return ret;
> +
>  	vin->crop.top =3D vin->crop.left =3D 0;
> -	vin->crop.width =3D vin->source.width;
> -	vin->crop.height =3D vin->source.height;
> +	vin->crop.width =3D source_fmt.width;
> +	vin->crop.height =3D source_fmt.height;
>=20
>  	vin->compose.top =3D vin->compose.left =3D 0;
>  	vin->compose.width =3D vin->format.width;
>  	vin->compose.height =3D vin->format.height;
> +
> +	return 0;
>  }
>=20
>  static int rvin_reset_format(struct rvin_dev *vin)
>  {
> -	struct v4l2_subdev_format fmt =3D {
> -		.which =3D V4L2_SUBDEV_FORMAT_ACTIVE,
> -	};
> -	struct v4l2_mbus_framefmt *mf =3D &fmt.format;
> +	struct v4l2_mbus_framefmt source_fmt;
>  	int ret;
>=20
> -	fmt.pad =3D vin->digital->source_pad;
> -
> -	ret =3D v4l2_subdev_call(vin_to_source(vin), pad, get_fmt, NULL, &fmt);
> +	ret =3D rvin_get_source_format(vin, &source_fmt);
>  	if (ret)
>  		return ret;

You retrieve the source format once here...

> -	vin->format.width	=3D mf->width;
> -	vin->format.height	=3D mf->height;
> -	vin->format.colorspace	=3D mf->colorspace;
> -	vin->format.field	=3D mf->field;
> +	v4l2_fill_pix_format(&vin->format, &source_fmt);
>=20
>  	/*
>  	 * If the subdevice uses ALTERNATE field mode and G_STD is
> @@ -147,7 +166,9 @@ static int rvin_reset_format(struct rvin_dev *vin)
>  		break;
>  	}
>=20
> -	rvin_reset_crop_compose(vin);
> +	ret =3D rvin_reset_crop_compose(vin);

=2E.. and this function then retrieves it a second time. Can't you pass it =
to=20
rvin_reset_crop_compose() ? If the source changes its format autonomously=20
between the two calls you'll end up with an inconsistent result otherwise.

> +	if (ret)
> +		return ret;
>=20
>  	vin->format.bytesperline =3D rvin_format_bytesperline(&vin->format);
>  	vin->format.sizeimage =3D rvin_format_sizeimage(&vin->format);
> @@ -156,9 +177,7 @@ static int rvin_reset_format(struct rvin_dev *vin)
>  }
>=20
>  static int __rvin_try_format_source(struct rvin_dev *vin,
> -				    u32 which,
> -				    struct v4l2_pix_format *pix,
> -				    struct rvin_source_fmt *source)
> +				    u32 which, struct v4l2_pix_format *pix)
>  {
>  	struct v4l2_subdev *sd;
>  	struct v4l2_subdev_pad_config *pad_cfg;
> @@ -190,25 +209,16 @@ static int __rvin_try_format_source(struct rvin_dev
> *vin,
>=20
>  	v4l2_fill_pix_format(pix, &format.format);
>=20
> -	source->width =3D pix->width;
> -	source->height =3D pix->height;
> -
>  	pix->field =3D field;
>  	pix->width =3D width;
>  	pix->height =3D height;
> -
> -	vin_dbg(vin, "Source resolution: %ux%u\n", source->width,
> -		source->height);
> -
>  done:
>  	v4l2_subdev_free_pad_config(pad_cfg);
>  	return ret;
>  }
>=20
>  static int __rvin_try_format(struct rvin_dev *vin,
> -			     u32 which,
> -			     struct v4l2_pix_format *pix,
> -			     struct rvin_source_fmt *source)
> +			     u32 which, struct v4l2_pix_format *pix)
>  {
>  	u32 walign;
>  	int ret;
> @@ -229,7 +239,7 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  	pix->sizeimage =3D 0;
>=20
>  	/* Limit to source capabilities */
> -	ret =3D __rvin_try_format_source(vin, which, pix, source);
> +	ret =3D __rvin_try_format_source(vin, which, pix);
>  	if (ret)
>  		return ret;
>=20
> @@ -238,7 +248,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  	case V4L2_FIELD_BOTTOM:
>  	case V4L2_FIELD_ALTERNATE:
>  		pix->height /=3D 2;
> -		source->height /=3D 2;
>  		break;
>  	case V4L2_FIELD_NONE:
>  	case V4L2_FIELD_INTERLACED_TB:
> @@ -290,35 +299,26 @@ static int rvin_try_fmt_vid_cap(struct file *file,
> void *priv, struct v4l2_format *f)
>  {
>  	struct rvin_dev *vin =3D video_drvdata(file);
> -	struct rvin_source_fmt source;
>=20
> -	return __rvin_try_format(vin, V4L2_SUBDEV_FORMAT_TRY, &f->fmt.pix,
> -				 &source);
> +	return __rvin_try_format(vin, V4L2_SUBDEV_FORMAT_TRY, &f->fmt.pix);
>  }
>=20
>  static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
>  			      struct v4l2_format *f)
>  {
>  	struct rvin_dev *vin =3D video_drvdata(file);
> -	struct rvin_source_fmt source;
>  	int ret;
>=20
>  	if (vb2_is_busy(&vin->queue))
>  		return -EBUSY;
>=20
> -	ret =3D __rvin_try_format(vin, V4L2_SUBDEV_FORMAT_ACTIVE, &f->fmt.pix,
> -				&source);
> +	ret =3D __rvin_try_format(vin, V4L2_SUBDEV_FORMAT_ACTIVE, &f->fmt.pix);
>  	if (ret)
>  		return ret;
>=20
> -	vin->source.width =3D source.width;
> -	vin->source.height =3D source.height;
> -
>  	vin->format =3D f->fmt.pix;
>=20
> -	rvin_reset_crop_compose(vin);
> -
> -	return 0;
> +	return rvin_reset_crop_compose(vin);

Same here, I think you should pass the format that has been retrieved by=20
__rvin_try_format().

If you want to get rid of the rvin_source_fmt structure (and I think we=20
should) then I wouldn't mind if you used v4l2_rect. Another option would be=
 to=20
propose a v4l2_size, but that would be one additional dependency.

>  }
>=20
>  static int rvin_g_fmt_vid_cap(struct file *file, void *priv,
> @@ -346,6 +346,8 @@ static int rvin_g_selection(struct file *file, void *=
fh,
> struct v4l2_selection *s)
>  {
>  	struct rvin_dev *vin =3D video_drvdata(file);
> +	struct v4l2_mbus_framefmt source_fmt;
> +	int ret;
>=20
>  	if (s->type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
> @@ -353,9 +355,12 @@ static int rvin_g_selection(struct file *file, void
> *fh, switch (s->target) {
>  	case V4L2_SEL_TGT_CROP_BOUNDS:
>  	case V4L2_SEL_TGT_CROP_DEFAULT:
> +		ret =3D rvin_get_source_format(vin, &source_fmt);
> +		if (ret)
> +			return ret;
>  		s->r.left =3D s->r.top =3D 0;
> -		s->r.width =3D vin->source.width;
> -		s->r.height =3D vin->source.height;
> +		s->r.width =3D source_fmt.width;
> +		s->r.height =3D source_fmt.height;
>  		break;
>  	case V4L2_SEL_TGT_CROP:
>  		s->r =3D vin->crop;
> @@ -380,6 +385,7 @@ static int rvin_s_selection(struct file *file, void *=
fh,
> struct v4l2_selection *s)
>  {
>  	struct rvin_dev *vin =3D video_drvdata(file);
> +	struct v4l2_mbus_framefmt source_fmt;
>  	const struct rvin_video_format *fmt;
>  	struct v4l2_rect r =3D s->r;
>  	struct v4l2_rect max_rect;
> @@ -387,6 +393,7 @@ static int rvin_s_selection(struct file *file, void *=
fh,
> .width =3D 6,
>  		.height =3D 2,
>  	};
> +	int ret;
>=20
>  	if (s->type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
> @@ -396,22 +403,25 @@ static int rvin_s_selection(struct file *file, void
> *fh, switch (s->target) {
>  	case V4L2_SEL_TGT_CROP:
>  		/* Can't crop outside of source input */
> +		ret =3D rvin_get_source_format(vin, &source_fmt);
> +		if (ret)
> +			return ret;

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
operation.

>  		max_rect.top =3D max_rect.left =3D 0;
> -		max_rect.width =3D vin->source.width;
> -		max_rect.height =3D vin->source.height;
> +		max_rect.width =3D source_fmt.width;
> +		max_rect.height =3D source_fmt.height;
>  		v4l2_rect_map_inside(&r, &max_rect);
>=20
> -		v4l_bound_align_image(&r.width, 2, vin->source.width, 1,
> -				      &r.height, 4, vin->source.height, 2, 0);
> +		v4l_bound_align_image(&r.width, 2, source_fmt.width, 1,
> +				      &r.height, 4, source_fmt.height, 2, 0);
>=20
> -		r.top  =3D clamp_t(s32, r.top, 0, vin->source.height - r.height);
> -		r.left =3D clamp_t(s32, r.left, 0, vin->source.width - r.width);
> +		r.top  =3D clamp_t(s32, r.top, 0, source_fmt.height - r.height);
> +		r.left =3D clamp_t(s32, r.left, 0, source_fmt.width - r.width);
>=20
>  		vin->crop =3D s->r =3D r;
>=20
>  		vin_dbg(vin, "Cropped %dx%d@%d:%d of %dx%d\n",
>  			r.width, r.height, r.left, r.top,
> -			vin->source.width, vin->source.height);
> +			source_fmt.width, source_fmt.height);
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
