Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44858 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965285AbeBMRDP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 12:03:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 17/30] rcar-vin: update pixelformat check for M1
Date: Tue, 13 Feb 2018 19:03:46 +0200
Message-ID: <1940936.O8uNz50EkU@avalon>
In-Reply-To: <20180129163435.24936-18-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se> <20180129163435.24936-18-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Monday, 29 January 2018 18:34:22 EET Niklas S=F6derlund wrote:
> If the pixelformat is not supported it should not fail but be set to
> something that works. While we are at it move the check together with
> other pixelformat checks of this function.

Please ignore my related comment to patch 16/30 :-) However, could you move=
=20
this patch before 16/30 ?

> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> bca6e204a574772f..841d62ca27e026d7 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -97,6 +97,10 @@ static int rvin_format_align(struct rvin_dev *vin, str=
uct
> v4l2_pix_format *pix) pix->pixelformat =3D RVIN_DEFAULT_FORMAT;
>  	}
>=20
> +	if (vin->info->model =3D=3D RCAR_M1 &&
> +	    pix->pixelformat =3D=3D V4L2_PIX_FMT_XBGR32)
> +		pix->pixelformat =3D RVIN_DEFAULT_FORMAT;
> +
>  	/* Reject ALTERNATE  until support is added to the driver */
>  	switch (pix->field) {
>  	case V4L2_FIELD_TOP:
> @@ -121,12 +125,6 @@ static int rvin_format_align(struct rvin_dev *vin,
> struct v4l2_pix_format *pix) pix->bytesperline =3D
> rvin_format_bytesperline(pix);
>  	pix->sizeimage =3D rvin_format_sizeimage(pix);
>=20
> -	if (vin->info->model =3D=3D RCAR_M1 &&
> -	    pix->pixelformat =3D=3D V4L2_PIX_FMT_XBGR32) {
> -		vin_err(vin, "pixel format XBGR32 not supported on M1\n");
> -		return -EINVAL;
> -	}
> -
>  	vin_dbg(vin, "Format %ux%u bpl: %d size: %d\n",
>  		pix->width, pix->height, pix->bytesperline, pix->sizeimage);

=2D-=20
Regards,

Laurent Pinchart
