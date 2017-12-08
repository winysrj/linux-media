Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47118 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752717AbdLHIdO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 03:33:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 09/28] rcar-vin: all Gen2 boards can scale simplify logic
Date: Fri, 08 Dec 2017 10:33:32 +0200
Message-ID: <2356040.iMAtxJm5sQ@avalon>
In-Reply-To: <20171208010842.20047-10-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <20171208010842.20047-10-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 8 December 2017 03:08:23 EET Niklas S=F6derlund wrote:
> The logic to preserve the requested format width and height are too
> complex and come from a premature optimization for Gen3. All Gen2 SoC
> can scale and the Gen3 implementation will not use these functions at
> all so simply preserve the width and height when interacting with the
> subdevice much like the field is preserved simplifies the logic quite a
> bit.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c  |  8 --------
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 22 ++++++++++------------
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  2 --
>  3 files changed, 10 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> a7cda3922cb74baa..fd14be20a6604d7a 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -585,14 +585,6 @@ void rvin_crop_scale_comp(struct rvin_dev *vin)
>  		0, 0);
>  }
>=20
> -void rvin_scale_try(struct rvin_dev *vin, struct v4l2_pix_format *pix,
> -		    u32 width, u32 height)
> -{
> -	/* All VIN channels on Gen2 have scalers */
> -	pix->width =3D width;
> -	pix->height =3D height;
> -}
> -
>  /*
> -------------------------------------------------------------------------=
=2D-
> -- * Hardware setup
>   */
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 19de99133f048960..1c5e7f6d5b963740 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -166,6 +166,7 @@ static int __rvin_try_format_source(struct rvin_dev
> *vin, .which =3D which,
>  	};
>  	enum v4l2_field field;
> +	u32 width, height;
>  	int ret;
>=20
>  	sd =3D vin_to_source(vin);
> @@ -178,7 +179,10 @@ static int __rvin_try_format_source(struct rvin_dev
> *vin,
>=20
>  	format.pad =3D vin->digital->source_pad;
>=20
> +	/* Allow the video device to override field and to scale */
>  	field =3D pix->field;
> +	width =3D pix->width;
> +	height =3D pix->height;
>=20
>  	ret =3D v4l2_subdev_call(sd, pad, set_fmt, pad_cfg, &format);
>  	if (ret < 0 && ret !=3D -ENOIOCTLCMD)
> @@ -191,6 +195,9 @@ static int __rvin_try_format_source(struct rvin_dev
> *vin, source->width =3D pix->width;
>  	source->height =3D pix->height;
>=20

I would move the pix->field =3D field line not shown above to here.

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> +	pix->width =3D width;
> +	pix->height =3D height;
> +
>  	vin_dbg(vin, "Source resolution: %ux%u\n", source->width,
>  		source->height);
>=20
> @@ -204,13 +211,9 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  			     struct v4l2_pix_format *pix,
>  			     struct rvin_source_fmt *source)
>  {
> -	u32 rwidth, rheight, walign;
> +	u32 walign;
>  	int ret;
>=20
> -	/* Requested */
> -	rwidth =3D pix->width;
> -	rheight =3D pix->height;
> -
>  	/* Keep current field if no specific one is asked for */
>  	if (pix->field =3D=3D V4L2_FIELD_ANY)
>  		pix->field =3D vin->format.field;
> @@ -248,10 +251,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  		break;
>  	}
>=20
> -	/* If source can't match format try if VIN can scale */
> -	if (source->width !=3D rwidth || source->height !=3D rheight)
> -		rvin_scale_try(vin, pix, rwidth, rheight);
> -
>  	/* HW limit width to a multiple of 32 (2^5) for NV16 else 2 (2^1) */
>  	walign =3D vin->format.pixelformat =3D=3D V4L2_PIX_FMT_NV16 ? 5 : 1;
>=20
> @@ -270,9 +269,8 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  		return -EINVAL;
>  	}
>=20
> -	vin_dbg(vin, "Requested %ux%u Got %ux%u bpl: %d size: %d\n",
> -		rwidth, rheight, pix->width, pix->height,
> -		pix->bytesperline, pix->sizeimage);
> +	vin_dbg(vin, "Format %ux%u bpl: %d size: %d\n",
> +		pix->width, pix->height, pix->bytesperline, pix->sizeimage);
>=20
>  	return 0;
>  }
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> 646f897f5c05ec4e..36d0f0cc4ce01a6e 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -176,8 +176,6 @@ void rvin_v4l2_unregister(struct rvin_dev *vin);
>  const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
>=20
>  /* Cropping, composing and scaling */
> -void rvin_scale_try(struct rvin_dev *vin, struct v4l2_pix_format *pix,
> -		    u32 width, u32 height);
>  void rvin_crop_scale_comp(struct rvin_dev *vin);
>=20
>  #endif

=2D-=20
Regards,

Laurent Pinchart
