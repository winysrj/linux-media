Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44806 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934845AbeBMQ4T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 11:56:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 15/30] rcar-vin: break out format alignment and checking
Date: Tue, 13 Feb 2018 18:56:49 +0200
Message-ID: <10948341.FPhVVtqtXn@avalon>
In-Reply-To: <20180129163435.24936-16-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se> <20180129163435.24936-16-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Monday, 29 January 2018 18:34:20 EET Niklas S=F6derlund wrote:
> Part of the format alignment and checking can be shared with the Gen3
> format handling. Break that part out to a separate function.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 93 +++++++++++++-----------
>  1 file changed, 50 insertions(+), 43 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> c606942e59b5d934..1169e6a279ecfb55 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -86,6 +86,55 @@ static u32 rvin_format_sizeimage(struct v4l2_pix_format
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

I think you can drop the message.

> +		pix->pixelformat =3D RVIN_DEFAULT_FORMAT;
> +	}
> +
> +	/* Reject ALTERNATE  until support is added to the driver */
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
> +	/* HW limit width to a multiple of 32 (2^5) for NV16 else 2 (2^1) */
> +	walign =3D vin->format.pixelformat =3D=3D V4L2_PIX_FMT_NV16 ? 5 : 1;
> +
> +	/* Limit to VIN capabilities */
> +	v4l_bound_align_image(&pix->width, 2, vin->info->max_width, walign,
> +			      &pix->height, 4, vin->info->max_height, 2, 0);
> +
> +	pix->bytesperline =3D max_t(u32, pix->bytesperline,
> +				  rvin_format_bytesperline(pix));
> +	pix->sizeimage =3D max_t(u32, pix->sizeimage,
> +			       rvin_format_sizeimage(pix));
> +
> +	if (vin->info->model =3D=3D RCAR_M1 &&
> +	    pix->pixelformat =3D=3D V4L2_PIX_FMT_XBGR32) {
> +		vin_err(vin, "pixel format XBGR32 not supported on M1\n");
> +		return -EINVAL;

This shouldn't print a message nor return an error, but default to a suppor=
ted=20
format. You can move the check to the beginning of the function to do so.

> +	}
> +
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
> @@ -215,19 +264,12 @@ static int __rvin_try_format_source(struct rvin_dev
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
>=20
>  	/* Always recalculate */
>  	pix->bytesperline =3D 0;
> @@ -238,42 +280,7 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  	if (ret)
>  		return ret;
>=20
> -	/* Reject ALTERNATE  until support is added to the driver */
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
> -	if (vin->info->model =3D=3D RCAR_M1 &&
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
