Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:51296 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbeJEDGZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 23:06:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 1/3] rcar-vin: align width before stream start
Date: Thu, 04 Oct 2018 23:11:50 +0300
Message-ID: <3937980.o2kZMfQ5OL@avalon>
In-Reply-To: <20181004200402.15113-2-niklas.soderlund+renesas@ragnatech.se>
References: <20181004200402.15113-1-niklas.soderlund+renesas@ragnatech.se> <20181004200402.15113-2-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Thursday, 4 October 2018 23:04:00 EEST Niklas S=F6derlund wrote:
> Instead of aligning the image width to match the image stride at stream
> start time do so when configuring the format. This allows the format
> width to strictly match the image stride which is useful when enabling
> scaling on Gen3.

But is this required ? Aren't there use cases where an image with a width n=
ot=20
aligned with the stride requirements should be captured ? As long as the=20
stride itself matches the hardware requirements, I don't see a reason to=20
disallow that.

> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c  | 5 +----
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 9 +++++++++
>  2 files changed, 10 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> 92323310f7352147..e752bc86e40153b1 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -597,10 +597,7 @@ void rvin_crop_scale_comp(struct rvin_dev *vin)
>  	if (vin->info->model !=3D RCAR_GEN3)
>  		rvin_crop_scale_comp_gen2(vin);
>=20
> -	if (vin->format.pixelformat =3D=3D V4L2_PIX_FMT_NV16)
> -		rvin_write(vin, ALIGN(vin->format.width, 0x20), VNIS_REG);
> -	else
> -		rvin_write(vin, ALIGN(vin->format.width, 0x10), VNIS_REG);
> +	rvin_write(vin, vin->format.width, VNIS_REG);
>  }
>=20
>  /*
> -------------------------------------------------------------------------=
=2D-
> -- diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> dc77682b47857c97..94bc559a0cb1e47a 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -96,6 +96,15 @@ static void rvin_format_align(struct rvin_dev *vin,
> struct v4l2_pix_format *pix) pix->pixelformat =3D=3D V4L2_PIX_FMT_XBGR32))
>  		pix->pixelformat =3D RVIN_DEFAULT_FORMAT;
>=20
> +	switch (pix->pixelformat) {
> +	case V4L2_PIX_FMT_NV16:
> +		pix->width =3D ALIGN(pix->width, 0x20);
> +		break;
> +	default:
> +		pix->width =3D ALIGN(pix->width, 0x10);
> +		break;
> +	}
> +
>  	switch (pix->field) {
>  	case V4L2_FIELD_TOP:
>  	case V4L2_FIELD_BOTTOM:

=2D-=20
Regards,

Laurent Pinchart
