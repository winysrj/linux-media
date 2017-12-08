Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47207 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751800AbdLHJKq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 04:10:46 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 12/28] rcar-vin: read subdevice format for crop only when needed
Date: Fri, 08 Dec 2017 11:11:05 +0200
Message-ID: <2320016.IGoNK59VHW@avalon>
In-Reply-To: <20171208010842.20047-13-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <20171208010842.20047-13-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 8 December 2017 03:08:26 EET Niklas S=F6derlund wrote:
> Instead of caching the subdevice format each time the video device
> format is set read it directly when it's needed. As it turns out the
> format is only needed when figuring out the max rectangle for cropping.
>=20
> This simplifies the code and makes it clearer what the source format is
> used for.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 88 +++++++++++++----------=
=2D--
>  drivers/media/platform/rcar-vin/rcar-vin.h  | 12 ----
>  2 files changed, 42 insertions(+), 58 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> d6298c684ab2d731..9cf9ff48ac1e2f4f 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -90,24 +90,30 @@ static u32 rvin_format_sizeimage(struct v4l2_pix_form=
at
> *pix) * V4L2
>   */
>=20
> -static int rvin_reset_format(struct rvin_dev *vin)
> +static int rvin_get_sd_format(struct rvin_dev *vin, struct v4l2_pix_form=
at
> *pix)

What does sd stand for here ? How about rvin_get_source_format() ?

As the function retrieves the format on a subdev I'd rather use a=20
v4l2_mbus_framefmt instead of a v4l2_pix_format, and convert in the callers=
 if=20
needed.

> {
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
> +	v4l2_fill_pix_format(pix, &fmt.format);
> +
> +	return 0;
> +}
> +
> +static int rvin_reset_format(struct rvin_dev *vin)
> +{
> +	int ret;
> +
> +	ret =3D rvin_get_sd_format(vin, &vin->format);
> +	if (ret)
> +		return ret;
>=20
>  	/*
>  	 * If the subdevice uses ALTERNATE field mode and G_STD is
> @@ -137,12 +143,12 @@ static int rvin_reset_format(struct rvin_dev *vin)
>  	}
>=20
>  	vin->crop.top =3D vin->crop.left =3D 0;
> -	vin->crop.width =3D mf->width;
> -	vin->crop.height =3D mf->height;
> +	vin->crop.width =3D vin->format.width;
> +	vin->crop.height =3D vin->format.height;
>=20
>  	vin->compose.top =3D vin->compose.left =3D 0;
> -	vin->compose.width =3D mf->width;
> -	vin->compose.height =3D mf->height;
> +	vin->compose.width =3D vin->format.width;
> +	vin->compose.height =3D vin->format.height;
>=20
>  	vin->format.bytesperline =3D rvin_format_bytesperline(&vin->format);
>  	vin->format.sizeimage =3D rvin_format_sizeimage(&vin->format);
> @@ -151,9 +157,7 @@ static int rvin_reset_format(struct rvin_dev *vin)
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
> @@ -186,25 +190,15 @@ static int __rvin_try_format_source(struct rvin_dev
> *vin, v4l2_fill_pix_format(pix, &format.format);
>=20
>  	pix->field =3D field;
> -
> -	source->width =3D pix->width;
> -	source->height =3D pix->height;
> -
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
> @@ -225,7 +219,7 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  	pix->sizeimage =3D 0;
>=20
>  	/* Limit to source capabilities */
> -	ret =3D __rvin_try_format_source(vin, which, pix, source);
> +	ret =3D __rvin_try_format_source(vin, which, pix);
>  	if (ret)
>  		return ret;
>=20
> @@ -234,7 +228,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  	case V4L2_FIELD_BOTTOM:
>  	case V4L2_FIELD_ALTERNATE:
>  		pix->height /=3D 2;
> -		source->height /=3D 2;
>  		break;
>  	case V4L2_FIELD_NONE:
>  	case V4L2_FIELD_INTERLACED_TB:
> @@ -286,30 +279,23 @@ static int rvin_try_fmt_vid_cap(struct file *file,
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
>  	return 0;
> @@ -340,6 +326,8 @@ static int rvin_g_selection(struct file *file, void *=
fh,
> struct v4l2_selection *s)
>  {
>  	struct rvin_dev *vin =3D video_drvdata(file);
> +	struct v4l2_pix_format pix;
> +	int ret;
>=20
>  	if (s->type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
> @@ -347,9 +335,12 @@ static int rvin_g_selection(struct file *file, void
> *fh, switch (s->target) {
>  	case V4L2_SEL_TGT_CROP_BOUNDS:
>  	case V4L2_SEL_TGT_CROP_DEFAULT:
> +		ret =3D rvin_get_sd_format(vin, &pix);
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
> @@ -375,12 +366,14 @@ static int rvin_s_selection(struct file *file, void
> *fh, {
>  	struct rvin_dev *vin =3D video_drvdata(file);
>  	const struct rvin_video_format *fmt;
> +	struct v4l2_pix_format pix;
>  	struct v4l2_rect r =3D s->r;
>  	struct v4l2_rect max_rect;
>  	struct v4l2_rect min_rect =3D {
>  		.width =3D 6,
>  		.height =3D 2,
>  	};
> +	int ret;
>=20
>  	if (s->type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
> @@ -390,22 +383,25 @@ static int rvin_s_selection(struct file *file, void
> *fh, switch (s->target) {
>  	case V4L2_SEL_TGT_CROP:
>  		/* Can't crop outside of source input */
> +		ret =3D rvin_get_sd_format(vin, &pix);
> +		if (ret)
> +			return ret;

I think you can move this code before the switch.

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
> 67541b483ee43c52..f8e0e7cedeaa6c38 100644
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
> @@ -125,7 +115,6 @@ struct rvin_info {
>   * @sequence:		V4L2 buffers sequence number
>   * @state:		keeps track of operation state
>   *
> - * @source:		active format from the video source
>   * @format:		active V4L2 pixel format
>   *
>   * @crop:		active cropping
> @@ -152,7 +141,6 @@ struct rvin_dev {
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
