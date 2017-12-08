Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47367 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753993AbdLHKAt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 05:00:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 18/28] rcar-vin: break out format alignment and checking
Date: Fri, 08 Dec 2017 12:01:08 +0200
Message-ID: <5606133.RJMpssMBTL@avalon>
In-Reply-To: <20171208010842.20047-19-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <20171208010842.20047-19-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 8 December 2017 03:08:32 EET Niklas S=F6derlund wrote:
> Part of the format alignment and checking can be shared with the Gen3
> format handling. Break that part out to its own function. While doing
> this clean up the checking and add more checks.

I'd split that in two patches, they are unrelated and should be reviewed=20
separately.

> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 98 +++++++++++++----------=
=2D-
>  1 file changed, 51 insertions(+), 47 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 56c5183f55922e1d..0ffbf0c16fb7b00e 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -86,6 +86,56 @@ static u32 rvin_format_sizeimage(struct v4l2_pix_format
> *pix) return pix->bytesperline * pix->height;
>  }
>=20
> +static int rvin_format_align(struct rvin_dev *vin, struct v4l2_pix_format
> *pix)
> +{
> +	u32 walign;
> +
> +	/* If requested format is not supported fallback to the default */
> +	if (!rvin_format_from_pixel(pix->pixelformat)) {
> +		vin_dbg(vin, "Format 0x%x not found, using default 0x%x\n",
> +			pix->pixelformat, RVIN_DEFAULT_FORMAT);
> +		pix->pixelformat =3D RVIN_DEFAULT_FORMAT;
> +	}
> +
> +	switch (pix->field) {
> +	case V4L2_FIELD_TOP:
> +	case V4L2_FIELD_BOTTOM:
> +	case V4L2_FIELD_NONE:
> +	case V4L2_FIELD_INTERLACED_TB:
> +	case V4L2_FIELD_INTERLACED_BT:
> +	case V4L2_FIELD_INTERLACED:
> +		break;
> +	default:
> +		pix->field =3D V4L2_FIELD_NONE;
> +		break;
> +	}
> +
> +	/* Check that colorspace is reasonable, if not keep current */
> +	if (!pix->colorspace || pix->colorspace >=3D 0xff)

Where does 0xff come from ? It seems a bit random to me.

> +		pix->colorspace =3D vin->format.colorspace;

I don't think that's a good idea. You should pick a default if the colorspa=
ce=20
can't be supported. Beside, what's the point in accepting colorspaces if=20
they're not handled by the driver ? Why don't you just set a fixed value ba=
sed=20
on the colorspace reported by the source ?

> +	/* HW limit width to a multiple of 32 (2^5) for NV16 else 2 (2^1) */
> +	walign =3D vin->format.pixelformat =3D=3D V4L2_PIX_FMT_NV16 ? 5 : 1;
> +
> +	/* Limit to VIN capabilities */
> +	v4l_bound_align_image(&pix->width, 2, vin->info->max_width, walign,
> +			      &pix->height, 4, vin->info->max_height, 2, 0);
> +
> +	pix->bytesperline =3D rvin_format_bytesperline(pix);
> +	pix->sizeimage =3D rvin_format_sizeimage(pix);

You're now hardcoding those values instead of only enforcing a minimum. Why=
 is=20
that ?

> +
> +	if (vin->info->chip =3D=3D RCAR_M1 &&
> +	    pix->pixelformat =3D=3D V4L2_PIX_FMT_XBGR32) {
> +		vin_err(vin, "pixel format XBGR32 not supported on M1\n");
> +		return -EINVAL;
> +	}

You should move this with the other format check at the beginning of the=20
function. and selecting the default format instead of returning an error.

> +	vin_dbg(vin, "Format %ux%u bpl: %d size: %d\n",
> +		pix->width, pix->height, pix->bytesperline, pix->sizeimage);
> +
> +	return 0;
> +}
> +
>  /*
> -------------------------------------------------------------------------=
=2D-
> -- * V4L2
>   */
> @@ -191,64 +241,18 @@ static int __rvin_try_format_source(struct rvin_dev
> *vin, static int __rvin_try_format(struct rvin_dev *vin,
>  			     u32 which, struct v4l2_pix_format *pix)
>  {
> -	u32 walign;
>  	int ret;
>=20
>  	/* Keep current field if no specific one is asked for */
>  	if (pix->field =3D=3D V4L2_FIELD_ANY)
>  		pix->field =3D vin->format.field;
>=20
> -	/* If requested format is not supported fallback to the default */
> -	if (!rvin_format_from_pixel(pix->pixelformat)) {
> -		vin_dbg(vin, "Format 0x%x not found, using default 0x%x\n",
> -			pix->pixelformat, RVIN_DEFAULT_FORMAT);
> -		pix->pixelformat =3D RVIN_DEFAULT_FORMAT;
> -	}
> -
> -	/* Always recalculate */
> -	pix->bytesperline =3D 0;
> -	pix->sizeimage =3D 0;
> -
>  	/* Limit to source capabilities */
>  	ret =3D __rvin_try_format_source(vin, which, pix);
>  	if (ret)
>  		return ret;
>=20
> -	switch (pix->field) {
> -	case V4L2_FIELD_TOP:
> -	case V4L2_FIELD_BOTTOM:
> -	case V4L2_FIELD_NONE:
> -	case V4L2_FIELD_INTERLACED_TB:
> -	case V4L2_FIELD_INTERLACED_BT:
> -	case V4L2_FIELD_INTERLACED:
> -		break;
> -	default:
> -		pix->field =3D V4L2_FIELD_NONE;
> -		break;
> -	}
> -
> -	/* HW limit width to a multiple of 32 (2^5) for NV16 else 2 (2^1) */
> -	walign =3D vin->format.pixelformat =3D=3D V4L2_PIX_FMT_NV16 ? 5 : 1;
> -
> -	/* Limit to VIN capabilities */
> -	v4l_bound_align_image(&pix->width, 2, vin->info->max_width, walign,
> -			      &pix->height, 4, vin->info->max_height, 2, 0);
> -
> -	pix->bytesperline =3D max_t(u32, pix->bytesperline,
> -				  rvin_format_bytesperline(pix));
> -	pix->sizeimage =3D max_t(u32, pix->sizeimage,
> -			       rvin_format_sizeimage(pix));
> -
> -	if (vin->info->chip =3D=3D RCAR_M1 &&
> -	    pix->pixelformat =3D=3D V4L2_PIX_FMT_XBGR32) {
> -		vin_err(vin, "pixel format XBGR32 not supported on M1\n");
> -		return -EINVAL;
> -	}
> -
> -	vin_dbg(vin, "Format %ux%u bpl: %d size: %d\n",
> -		pix->width, pix->height, pix->bytesperline, pix->sizeimage);
> -
> -	return 0;
> +	return rvin_format_align(vin, pix);
>  }
>=20
>  static int rvin_querycap(struct file *file, void *priv,


=2D-=20
Regards,

Laurent Pinchart
