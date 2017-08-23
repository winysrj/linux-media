Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57734 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932114AbdHWPtT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 11:49:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v6 03/25] rcar-vin: move chip information to own struct
Date: Wed, 23 Aug 2017 18:49:49 +0300
Message-ID: <2438024.1X1RK6JS63@avalon>
In-Reply-To: <20170822232640.26147-4-niklas.soderlund+renesas@ragnatech.se>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se> <20170822232640.26147-4-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Wednesday, 23 August 2017 02:26:18 EEST Niklas S=F6derlund wrote:
> When Gen3 support is added to the driver more then chip id will be

s/then/than/
s/id/ID/

> different for the different Soc. To avoid a lot of if statements in the

s/Soc/SoCs/

> code create a struct chip_info to contain this information.

s/contain/store/

>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 49 ++++++++++++++++++++---=
=2D-
>  drivers/media/platform/rcar-vin/rcar-v4l2.c |  3 +-
>  drivers/media/platform/rcar-vin/rcar-vin.h  | 12 +++++--
>  3 files changed, 53 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> aefbe8e3ccddb3e4..dae38de706b66b64 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -277,14 +277,47 @@ static int rvin_digital_graph_init(struct rvin_dev
> *vin) * Platform Device Driver
>   */
>=20
> +static const struct rvin_info rcar_info_h1 =3D {
> +	.chip =3D RCAR_H1,
> +};
> +
> +static const struct rvin_info rcar_info_m1 =3D {
> +	.chip =3D RCAR_M1,
> +};
> +
> +static const struct rvin_info rcar_info_gen2 =3D {
> +	.chip =3D RCAR_GEN2,
> +};
> +
>  static const struct of_device_id rvin_of_id_table[] =3D {
> -	{ .compatible =3D "renesas,vin-r8a7794", .data =3D (void *)RCAR_GEN2 },
> -	{ .compatible =3D "renesas,vin-r8a7793", .data =3D (void *)RCAR_GEN2 },
> -	{ .compatible =3D "renesas,vin-r8a7791", .data =3D (void *)RCAR_GEN2 },
> -	{ .compatible =3D "renesas,vin-r8a7790", .data =3D (void *)RCAR_GEN2 },
> -	{ .compatible =3D "renesas,vin-r8a7779", .data =3D (void *)RCAR_H1 },
> -	{ .compatible =3D "renesas,vin-r8a7778", .data =3D (void *)RCAR_M1 },
> -	{ .compatible =3D "renesas,rcar-gen2-vin", .data =3D (void *)RCAR_GEN2 =
},
> +	{
> +		.compatible =3D "renesas,vin-r8a7794",
> +		.data =3D &rcar_info_gen2,
> +	},
> +	{
> +		.compatible =3D "renesas,vin-r8a7793",
> +		.data =3D &rcar_info_gen2,
> +	},
> +	{
> +		.compatible =3D "renesas,vin-r8a7791",
> +		.data =3D &rcar_info_gen2,
> +	},
> +	{
> +		.compatible =3D "renesas,vin-r8a7790",
> +		.data =3D &rcar_info_gen2,
> +	},
> +	{
> +		.compatible =3D "renesas,vin-r8a7779",
> +		.data =3D &rcar_info_h1,
> +	},
> +	{
> +		.compatible =3D "renesas,vin-r8a7778",
> +		.data =3D &rcar_info_m1,
> +	},

How about sorting the entries by compatible string ?

> +	{
> +		.compatible =3D "renesas,rcar-gen2-vin",
> +		.data =3D &rcar_info_gen2,
> +	},

Do we need the SoC-specific entries for the Gen2 SoCs if we have a generic =
one=20
?

>  	{ },
>  };
>  MODULE_DEVICE_TABLE(of, rvin_of_id_table);
> @@ -305,7 +338,7 @@ static int rcar_vin_probe(struct platform_device *pde=
v)
>  		return -ENODEV;
>=20
>  	vin->dev =3D &pdev->dev;
> -	vin->chip =3D (enum chip_id)match->data;
> +	vin->info =3D match->data;
>=20
>  	mem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (mem =3D=3D NULL)
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 81ff59c3b4744075..02a08cf5acfce1ce 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -266,7 +266,8 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  	pix->sizeimage =3D max_t(u32, pix->sizeimage,
>  			       rvin_format_sizeimage(pix));
>=20
> -	if (vin->chip =3D=3D RCAR_M1 && pix->pixelformat =3D=3D V4L2_PIX_FMT_XB=
GR32) {
> +	if (vin->info->chip =3D=3D RCAR_M1 &&
> +	    pix->pixelformat =3D=3D V4L2_PIX_FMT_XBGR32) {
>  		vin_err(vin, "pixel format XBGR32 not supported on M1\n");
>  		return -EINVAL;
>  	}
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> 9d0d4a5001b6ccd8..13466dfd72292fc0 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -88,11 +88,19 @@ struct rvin_graph_entity {
>  	unsigned int sink_pad;
>  };
>=20
> +/**
> + * struct rvin_info - Information about the particular VIN implementation
> + * @chip:		type of VIN chip
> + */
> +struct rvin_info {
> +	enum chip_id chip;
> +};
> +
>  /**
>   * struct rvin_dev - Renesas VIN device structure
>   * @dev:		(OF) device
>   * @base:		device I/O register space remapped to virtual memory
> - * @chip:		type of VIN chip
> + * @info:		info about VIN instance
>   *
>   * @vdev:		V4L2 video device associated with VIN
>   * @v4l2_dev:		V4L2 device
> @@ -120,7 +128,7 @@ struct rvin_graph_entity {
>  struct rvin_dev {
>  	struct device *dev;
>  	void __iomem *base;
> -	enum chip_id chip;
> +	const struct rvin_info *info;
>=20
>  	struct video_device vdev;
>  	struct v4l2_device v4l2_dev;


=2D-=20
Regards,

Laurent Pinchart
