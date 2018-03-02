Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52260 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425094AbeCBJ2U (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 04:28:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v11 11/32] rcar-vin: set a default field to fallback on
Date: Fri, 02 Mar 2018 11:29:09 +0200
Message-ID: <1558965.WHi4tbhD4W@avalon>
In-Reply-To: <20180302015751.25596-12-niklas.soderlund+renesas@ragnatech.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se> <20180302015751.25596-12-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 2 March 2018 03:57:30 EET Niklas S=F6derlund wrote:
> If the field is not supported by the driver it should not try to keep
> the current field. Instead it should set it to a default fallback. Since
> trying a format should always result in the same state regardless of the
> current state of the device.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> c2265324c7c96308..ebcd78b1bb6e8cb6 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -23,6 +23,7 @@
>  #include "rcar-vin.h"
>=20
>  #define RVIN_DEFAULT_FORMAT	V4L2_PIX_FMT_YUYV
> +#define RVIN_DEFAULT_FIELD	V4L2_FIELD_NONE
>=20
>  /*
> -------------------------------------------------------------------------=
=2D-
> -- * Format Conversions
> @@ -143,7 +144,7 @@ static int rvin_reset_format(struct rvin_dev *vin)
>  	case V4L2_FIELD_INTERLACED:
>  		break;
>  	default:
> -		vin->format.field =3D V4L2_FIELD_NONE;
> +		vin->format.field =3D RVIN_DEFAULT_FIELD;
>  		break;
>  	}
>=20
> @@ -213,10 +214,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  	u32 walign;
>  	int ret;
>=20
> -	/* Keep current field if no specific one is asked for */
> -	if (pix->field =3D=3D V4L2_FIELD_ANY)
> -		pix->field =3D vin->format.field;
> -
>  	/* If requested format is not supported fallback to the default */
>  	if (!rvin_format_from_pixel(pix->pixelformat)) {
>  		vin_dbg(vin, "Format 0x%x not found, using default 0x%x\n",
> @@ -246,7 +243,7 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  	case V4L2_FIELD_INTERLACED:
>  		break;
>  	default:
> -		pix->field =3D V4L2_FIELD_NONE;
> +		pix->field =3D RVIN_DEFAULT_FIELD;
>  		break;
>  	}


=2D-=20
Regards,

Laurent Pinchart
