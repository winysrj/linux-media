Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42697 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753625AbeDCVrJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2018 17:47:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v13 15/33] rcar-vin: break out format alignment and checking
Date: Wed, 04 Apr 2018 00:47:17 +0300
Message-ID: <1541837.rNncqqP5aT@avalon>
In-Reply-To: <20180326214456.6655-16-niklas.soderlund+renesas@ragnatech.se>
References: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se> <20180326214456.6655-16-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Tuesday, 27 March 2018 00:44:38 EEST Niklas S=F6derlund wrote:
> Part of the format alignment and checking can be shared with the Gen3
> format handling. Break that part out to a separate function.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 85 +++++++++++++++--------=
=2D-
>  1 file changed, 48 insertions(+), 37 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 8dbd764883976ad1..c39891386576afb8 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -87,6 +87,53 @@ static u32 rvin_format_sizeimage(struct v4l2_pix_format
> *pix) return pix->bytesperline * pix->height;
>  }
>=20
> +static int rvin_format_align(struct rvin_dev *vin, struct v4l2_pix_format
> *pix)
> +{
> +	u32 walign;
> +
> +	if (!rvin_format_from_pixel(pix->pixelformat) ||
> +	    (vin->info->model =3D=3D RCAR_M1 &&
> +	     pix->pixelformat =3D=3D V4L2_PIX_FMT_XBGR32))
> +		pix->pixelformat =3D RVIN_DEFAULT_FORMAT;
> +
> +	switch (pix->field) {
> +	case V4L2_FIELD_TOP:
> +	case V4L2_FIELD_BOTTOM:
> +	case V4L2_FIELD_NONE:
> +	case V4L2_FIELD_INTERLACED_TB:
> +	case V4L2_FIELD_INTERLACED_BT:
> +	case V4L2_FIELD_INTERLACED:
> +		break;
> +	case V4L2_FIELD_ALTERNATE:
> +		/*
> +		 * Driver dose not (yet) support outputting ALTERNATE to a

s/dose/does/

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> +		 * userspace. It does support outputting INTERLACED so use
> +		 * the VIN hardware to combine the two fields.
> +		 */
> +		pix->field =3D V4L2_FIELD_INTERLACED;
> +		pix->height *=3D 2;
> +		break;
> +	default:
> +		pix->field =3D RVIN_DEFAULT_FIELD;
> +		break;
> +	}
> +
> +	/* HW limit width to a multiple of 32 (2^5) for NV16 else 2 (2^1) */
> +	walign =3D vin->format.pixelformat =3D=3D V4L2_PIX_FMT_NV16 ? 5 : 1;
> +
> +	/* Limit to VIN capabilities */
> +	v4l_bound_align_image(&pix->width, 2, vin->info->max_width, walign,
> +			      &pix->height, 4, vin->info->max_height, 2, 0);
> +
> +	pix->bytesperline =3D rvin_format_bytesperline(pix);
> +	pix->sizeimage =3D rvin_format_sizeimage(pix);
> +
> +	vin_dbg(vin, "Format %ux%u bpl: %u size: %u\n",
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
> @@ -186,7 +233,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  			     struct v4l2_pix_format *pix,
>  			     struct rvin_source_fmt *source)
>  {
> -	u32 walign;
>  	int ret;
>=20
>  	if (!rvin_format_from_pixel(pix->pixelformat) ||
> @@ -199,42 +245,7 @@ static int __rvin_try_format(struct rvin_dev *vin,
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
> -	case V4L2_FIELD_ALTERNATE:
> -		/*
> -		 * Driver dose not (yet) support outputting ALTERNATE to a
> -		 * userspace. It does support outputting INTERLACED so use
> -		 * the VIN hardware to combine the two fields.
> -		 */
> -		pix->field =3D V4L2_FIELD_INTERLACED;
> -		pix->height *=3D 2;
> -		break;
> -	default:
> -		pix->field =3D RVIN_DEFAULT_FIELD;
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
> -	pix->bytesperline =3D rvin_format_bytesperline(pix);
> -	pix->sizeimage =3D rvin_format_sizeimage(pix);
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
