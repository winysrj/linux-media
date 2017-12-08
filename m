Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47050 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751021AbdLHIK0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 03:10:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 06/28] rcar-vin: move max width and height information to chip information
Date: Fri, 08 Dec 2017 10:10:45 +0200
Message-ID: <1517674.IBOQih2ykn@avalon>
In-Reply-To: <20171208010842.20047-7-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <20171208010842.20047-7-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 8 December 2017 03:08:20 EET Niklas S=F6derlund wrote:
> On Gen3 the max supported width and height will be different from Gen2.
> Move the limits to the struct rvin_info to prepare for Gen3 support.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 6 ++++++
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 6 ++----
>  drivers/media/platform/rcar-vin/rcar-vin.h  | 6 ++++++
>  3 files changed, 14 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> 73c1700a409bfd35..03d3cd63e38bee11 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -232,14 +232,20 @@ static int rvin_digital_graph_init(struct rvin_dev
> *vin)
>=20
>  static const struct rvin_info rcar_info_h1 =3D {
>  	.chip =3D RCAR_H1,
> +	.max_width =3D 2048,
> +	.max_height =3D 2048,
>  };
>=20
>  static const struct rvin_info rcar_info_m1 =3D {
>  	.chip =3D RCAR_M1,
> +	.max_width =3D 2048,
> +	.max_height =3D 2048,
>  };
>=20
>  static const struct rvin_info rcar_info_gen2 =3D {
>  	.chip =3D RCAR_GEN2,
> +	.max_width =3D 2048,
> +	.max_height =3D 2048,
>  };
>=20
>  static const struct of_device_id rvin_of_id_table[] =3D {
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> b1caa04921aa23bb..59ec6d3d119590aa 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -23,8 +23,6 @@
>  #include "rcar-vin.h"
>=20
>  #define RVIN_DEFAULT_FORMAT	V4L2_PIX_FMT_YUYV
> -#define RVIN_MAX_WIDTH		2048
> -#define RVIN_MAX_HEIGHT		2048
>=20
>  /*
> -------------------------------------------------------------------------=
=2D-
> -- * Format Conversions
> @@ -258,8 +256,8 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  	walign =3D vin->format.pixelformat =3D=3D V4L2_PIX_FMT_NV16 ? 5 : 1;
>=20
>  	/* Limit to VIN capabilities */
> -	v4l_bound_align_image(&pix->width, 2, RVIN_MAX_WIDTH, walign,
> -			      &pix->height, 4, RVIN_MAX_HEIGHT, 2, 0);
> +	v4l_bound_align_image(&pix->width, 2, vin->info->max_width, walign,
> +			      &pix->height, 4, vin->info->max_height, 2, 0);
>=20
>  	pix->bytesperline =3D max_t(u32, pix->bytesperline,
>  				  rvin_format_bytesperline(pix));
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> 0d3949c8c08c8f63..646f897f5c05ec4e 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -91,9 +91,15 @@ struct rvin_graph_entity {
>  /**
>   * struct rvin_info - Information about the particular VIN implementation
>   * @chip:		type of VIN chip
> + *

Nitpicking, there's no need for a blank line here.

> + * max_width:		max input width the VIN supports
> + * max_height:		max input height the VIN supports

And you're missing the @ before the field names. Please make sure to compil=
e=20
the documentation to check for kerneldoc errors.

With this fixed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>   */
>  struct rvin_info {
>  	enum chip_id chip;
> +
> +	unsigned int max_width;
> +	unsigned int max_height;
>  };
>=20
>  /**

=2D-=20
Regards,

Laurent Pinchart
