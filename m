Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52301 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425873AbeCBJn3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 04:43:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v11 13/32] rcar-vin: update bytesperline and sizeimage calculation
Date: Fri, 02 Mar 2018 11:44:19 +0200
Message-ID: <16898253.IUsSDvYluU@avalon>
In-Reply-To: <20180302015751.25596-14-niklas.soderlund+renesas@ragnatech.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se> <20180302015751.25596-14-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 2 March 2018 03:57:32 EET Niklas S=F6derlund wrote:
> Remove over complicated logic to calculate the value for bytesperline
> and sizeimage that was carried over from the soc_camera port. There is
> no need to find the max value of bytesperline and sizeimage from
> user-space as they are set to 0 before the max_t() operation.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> cef9070884d93ba6..652b85300b4ef9db 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -194,10 +194,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  		pix->pixelformat =3D RVIN_DEFAULT_FORMAT;
>  	}
>=20
> -	/* Always recalculate */
> -	pix->bytesperline =3D 0;
> -	pix->sizeimage =3D 0;
> -
>  	/* Limit to source capabilities */
>  	ret =3D __rvin_try_format_source(vin, which, pix, source);
>  	if (ret)
> @@ -232,10 +228,8 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  	v4l_bound_align_image(&pix->width, 2, vin->info->max_width, walign,
>  			      &pix->height, 4, vin->info->max_height, 2, 0);
>=20
> -	pix->bytesperline =3D max_t(u32, pix->bytesperline,
> -				  rvin_format_bytesperline(pix));
> -	pix->sizeimage =3D max_t(u32, pix->sizeimage,
> -			       rvin_format_sizeimage(pix));
> +	pix->bytesperline =3D rvin_format_bytesperline(pix);
> +	pix->sizeimage =3D rvin_format_sizeimage(pix);
>=20
>  	if (vin->info->model =3D=3D RCAR_M1 &&
>  	    pix->pixelformat =3D=3D V4L2_PIX_FMT_XBGR32) {


=2D-=20
Regards,

Laurent Pinchart
