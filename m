Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44830 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965186AbeBMQ6X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 11:58:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 16/30] rcar-vin: update bytesperline and sizeimage calculation
Date: Tue, 13 Feb 2018 18:58:54 +0200
Message-ID: <6654769.EFGEBSbQ1Q@avalon>
In-Reply-To: <20180129163435.24936-17-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se> <20180129163435.24936-17-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Monday, 29 January 2018 18:34:21 EET Niklas S=F6derlund wrote:
> Remove over complicated logic to calculate the value for bytesperline

s/over complicated/overcomplicated/

> and sizeimage that was carried over from the soc_camera port. Update the
> calculations to match how other drivers are doing it.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 1169e6a279ecfb55..bca6e204a574772f 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -118,10 +118,8 @@ static int rvin_format_align(struct rvin_dev *vin,
> struct v4l2_pix_format *pix) v4l_bound_align_image(&pix->width, 2,
> vin->info->max_width, walign, &pix->height, 4, vin->info->max_height, 2,
> 0);
>=20
> -	pix->bytesperline =3D max_t(u32, pix->bytesperline,
> -				  rvin_format_bytesperline(pix));
> -	pix->sizeimage =3D max_t(u32, pix->sizeimage,
> -			       rvin_format_sizeimage(pix));
> +	pix->bytesperline =3D rvin_format_bytesperline(pix);
> +	pix->sizeimage =3D rvin_format_sizeimage(pix);

Thus this mean that the driver will stop supporting configurable strides ?=
=20
Isn't that a regression ?

>  	if (vin->info->model =3D=3D RCAR_M1 &&
>  	    pix->pixelformat =3D=3D V4L2_PIX_FMT_XBGR32) {
> @@ -270,11 +268,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  	if (pix->field =3D=3D V4L2_FIELD_ANY)
>  		pix->field =3D vin->format.field;
>=20
> -
> -	/* Always recalculate */
> -	pix->bytesperline =3D 0;
> -	pix->sizeimage =3D 0;
> -
>  	/* Limit to source capabilities */
>  	ret =3D __rvin_try_format_source(vin, which, pix);
>  	if (ret)


=2D-=20
Regards,

Laurent Pinchart
