Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35448 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729477AbeGaBjA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 21:39:00 -0400
Date: Mon, 30 Jul 2018 21:01:23 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 06/22] [media] tvp5150: add FORMAT_TRY support for
 get/set selection handlers
Message-ID: <20180730210123.7f1f2b57@coco.lan>
In-Reply-To: <20180628162054.25613-7-m.felsch@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
        <20180628162054.25613-7-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 28 Jun 2018 18:20:38 +0200
Marco Felsch <m.felsch@pengutronix.de> escreveu:

> Since commit 10d5509c8d50 ("[media] v4l2: remove g/s_crop from video ops")
> the 'which' field for set/get_selection must be FORMAT_ACTIVE. There is
> no way to try different selections. The patch adds a helper function to
> select the correct selection memory space (sub-device file handle or
> driver state) which will be set/returned.
>=20
> The TVP5150 AVID will be updated if the 'which' field is FORMAT_ACTIVE
> and the requested selection rectangle differs from the already set one.
>=20
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> ---
>  drivers/media/i2c/tvp5150.c | 107 ++++++++++++++++++++++++------------
>  1 file changed, 73 insertions(+), 34 deletions(-)
>=20
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index d150487cc2d1..29eaf8166f25 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -18,6 +18,7 @@
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-fwnode.h>
>  #include <media/v4l2-mc.h>
> +#include <media/v4l2-rect.h>
> =20
>  #include "tvp5150_reg.h"
> =20
> @@ -846,20 +847,38 @@ static v4l2_std_id tvp5150_read_std(struct v4l2_sub=
dev *sd)
>  	}
>  }
> =20
> +static struct v4l2_rect *
> +__tvp5150_get_pad_crop(struct tvp5150 *decoder,
> +		       struct v4l2_subdev_pad_config *cfg, unsigned int pad,
> +		       enum v4l2_subdev_format_whence which)
> +{
> +	switch (which) {
> +	case V4L2_SUBDEV_FORMAT_TRY:
> +		return v4l2_subdev_get_try_crop(&decoder->sd, cfg, pad);

This is not ok. It causes compilation breakage if the subdev API is not
selected:

drivers/media/i2c/tvp5150.c: In function =E2=80=98__tvp5150_get_pad_crop=E2=
=80=99:
drivers/media/i2c/tvp5150.c:857:10: error: implicit declaration of function=
 =E2=80=98v4l2_subdev_get_try_crop=E2=80=99; did you mean =E2=80=98v4l2_sub=
dev_has_op=E2=80=99? [-Werror=3Dimplicit-function-declaration]
   return v4l2_subdev_get_try_crop(&decoder->sd, cfg, pad);
          ^~~~~~~~~~~~~~~~~~~~~~~~
          v4l2_subdev_has_op
drivers/media/i2c/tvp5150.c:857:10: warning: returning =E2=80=98int=E2=80=
=99 from a function with return type =E2=80=98struct v4l2_rect *=E2=80=99 m=
akes pointer from integer without a cast [-Wint-conversion]
   return v4l2_subdev_get_try_crop(&decoder->sd, cfg, pad);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The logic should keep working both with and without subdev API.


> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> +		return &decoder->rect;
> +	default:
> +		return NULL;
> +	}
> +}
> +
>  static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
>  		struct v4l2_subdev_pad_config *cfg,
>  		struct v4l2_subdev_format *format)
>  {
>  	struct v4l2_mbus_framefmt *f;
> +	struct v4l2_rect *__crop;
>  	struct tvp5150 *decoder =3D to_tvp5150(sd);
> =20
>  	if (!format || (format->pad !=3D DEMOD_PAD_VID_OUT))
>  		return -EINVAL;
> =20
>  	f =3D &format->format;
> +	__crop =3D __tvp5150_get_pad_crop(decoder, cfg, format->pad,
> +					format->which);
> =20
> -	f->width =3D decoder->rect.width;
> -	f->height =3D decoder->rect.height / 2;
> +	f->width =3D __crop->width;
> +	f->height =3D __crop->height / 2;
> =20
>  	f->code =3D MEDIA_BUS_FMT_UYVY8_2X8;
>  	f->field =3D V4L2_FIELD_ALTERNATE;
> @@ -870,17 +889,51 @@ static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
>  	return 0;
>  }
> =20
> +unsigned int tvp5150_get_hmax(struct v4l2_subdev *sd)
> +{
> +	struct tvp5150 *decoder =3D to_tvp5150(sd);
> +	v4l2_std_id std;
> +
> +	/* Calculate height based on current standard */
> +	if (decoder->norm =3D=3D V4L2_STD_ALL)
> +		std =3D tvp5150_read_std(sd);
> +	else
> +		std =3D decoder->norm;
> +
> +	return (std & V4L2_STD_525_60) ?
> +		TVP5150_V_MAX_525_60 : TVP5150_V_MAX_OTHERS;
> +}
> +
> +static inline void
> +__tvp5150_set_selection(struct v4l2_subdev *sd, struct v4l2_rect rect)
> +{
> +	struct tvp5150 *decoder =3D to_tvp5150(sd);
> +	unsigned int hmax =3D tvp5150_get_hmax(sd);
> +
> +	regmap_write(decoder->regmap, TVP5150_VERT_BLANKING_START, rect.top);
> +	regmap_write(decoder->regmap, TVP5150_VERT_BLANKING_STOP,
> +		     rect.top + rect.height - hmax);
> +	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_ST_MSB,
> +		     rect.left >> TVP5150_CROP_SHIFT);
> +	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_ST_LSB,
> +		     rect.left | (1 << TVP5150_CROP_SHIFT));
> +	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_STP_MSB,
> +		     (rect.left + rect.width - TVP5150_MAX_CROP_LEFT) >>
> +		     TVP5150_CROP_SHIFT);
> +	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_STP_LSB,
> +		     rect.left + rect.width - TVP5150_MAX_CROP_LEFT);
> +}
> +
>  static int tvp5150_set_selection(struct v4l2_subdev *sd,
>  				 struct v4l2_subdev_pad_config *cfg,
>  				 struct v4l2_subdev_selection *sel)
>  {
>  	struct tvp5150 *decoder =3D to_tvp5150(sd);
>  	struct v4l2_rect rect =3D sel->r;
> -	v4l2_std_id std;
> -	int hmax;
> +	struct v4l2_rect *__crop;
> +	unsigned int hmax;
> =20
> -	if (sel->which !=3D V4L2_SUBDEV_FORMAT_ACTIVE ||
> -	    sel->target !=3D V4L2_SEL_TGT_CROP)
> +	if (sel->target !=3D V4L2_SEL_TGT_CROP)
>  		return -EINVAL;
> =20
>  	dev_dbg_lvl(sd->dev, 1, debug, "%s left=3D%d, top=3D%d, width=3D%d, hei=
ght=3D%d\n",
> @@ -889,17 +942,7 @@ static int tvp5150_set_selection(struct v4l2_subdev =
*sd,
>  	/* tvp5150 has some special limits */
>  	rect.left =3D clamp(rect.left, 0, TVP5150_MAX_CROP_LEFT);
>  	rect.top =3D clamp(rect.top, 0, TVP5150_MAX_CROP_TOP);
> -
> -	/* Calculate height based on current standard */
> -	if (decoder->norm =3D=3D V4L2_STD_ALL)
> -		std =3D tvp5150_read_std(sd);
> -	else
> -		std =3D decoder->norm;
> -
> -	if (std & V4L2_STD_525_60)
> -		hmax =3D TVP5150_V_MAX_525_60;
> -	else
> -		hmax =3D TVP5150_V_MAX_OTHERS;
> +	hmax =3D tvp5150_get_hmax(sd);
> =20
>  	/*
>  	 * alignments:
> @@ -912,20 +955,18 @@ static int tvp5150_set_selection(struct v4l2_subdev=
 *sd,
>  			      hmax - TVP5150_MAX_CROP_TOP - rect.top,
>  			      hmax - rect.top, 0, 0);
> =20
> -	regmap_write(decoder->regmap, TVP5150_VERT_BLANKING_START, rect.top);
> -	regmap_write(decoder->regmap, TVP5150_VERT_BLANKING_STOP,
> -		      rect.top + rect.height - hmax);
> -	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_ST_MSB,
> -		      rect.left >> TVP5150_CROP_SHIFT);
> -	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_ST_LSB,
> -		      rect.left | (1 << TVP5150_CROP_SHIFT));
> -	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_STP_MSB,
> -		      (rect.left + rect.width - TVP5150_MAX_CROP_LEFT) >>
> -		      TVP5150_CROP_SHIFT);
> -	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_STP_LSB,
> -		      rect.left + rect.width - TVP5150_MAX_CROP_LEFT);
> +	__crop =3D __tvp5150_get_pad_crop(decoder, cfg, sel->pad,
> +						  sel->which);
> +
> +	/*
> +	 * Update output image size if the selection (crop) rectangle size or
> +	 * position has been modified.
> +	 */
> +	if (!v4l2_rect_equal(&rect, __crop))
> +		if (sel->which =3D=3D V4L2_SUBDEV_FORMAT_ACTIVE)
> +			__tvp5150_set_selection(sd, rect);
> =20
> -	decoder->rect =3D rect;
> +	*__crop =3D rect;
> =20
>  	return 0;
>  }
> @@ -937,9 +978,6 @@ static int tvp5150_get_selection(struct v4l2_subdev *=
sd,
>  	struct tvp5150 *decoder =3D container_of(sd, struct tvp5150, sd);
>  	v4l2_std_id std;
> =20
> -	if (sel->which !=3D V4L2_SUBDEV_FORMAT_ACTIVE)
> -		return -EINVAL;
> -
>  	switch (sel->target) {
>  	case V4L2_SEL_TGT_CROP_BOUNDS:
>  	case V4L2_SEL_TGT_CROP_DEFAULT:
> @@ -958,7 +996,8 @@ static int tvp5150_get_selection(struct v4l2_subdev *=
sd,
>  			sel->r.height =3D TVP5150_V_MAX_OTHERS;
>  		return 0;
>  	case V4L2_SEL_TGT_CROP:
> -		sel->r =3D decoder->rect;
> +		sel->r =3D *__tvp5150_get_pad_crop(decoder, cfg, sel->pad,
> +						      sel->which);
>  		return 0;
>  	default:
>  		return -EINVAL;



Thanks,
Mauro
