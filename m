Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47035 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752481AbdLHIHv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 03:07:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 05/28] rcar-vin: move chip information to own struct
Date: Fri, 08 Dec 2017 10:08:08 +0200
Message-ID: <25215448.lzARv6kaXr@avalon>
In-Reply-To: <20171208010842.20047-6-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <20171208010842.20047-6-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 8 December 2017 03:08:19 EET Niklas S=F6derlund wrote:
> When Gen3 support is added to the driver more than chip ID will be
> different for the different SoCs. To avoid a lot of if statements in the
> code create a struct chip_info to store this information.

The structure is called rvin_info.

> And while we are at it sort the compatible string entries and make use
> of of_device_get_match_data() which will always work as the driver is DT
> only, so there's always a valid match.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 54 +++++++++++++++++++++--=
=2D--
>  drivers/media/platform/rcar-vin/rcar-v4l2.c |  3 +-
>  drivers/media/platform/rcar-vin/rcar-vin.h  | 12 +++++--
>  3 files changed, 53 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> 6ab51acd676641ec..73c1700a409bfd35 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -230,21 +230,53 @@ static int rvin_digital_graph_init(struct rvin_dev
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
> +		.compatible =3D "renesas,vin-r8a7778",
> +		.data =3D &rcar_info_m1,
> +	},
> +	{
> +		.compatible =3D "renesas,vin-r8a7779",
> +		.data =3D &rcar_info_h1,
> +	},
> +	{
> +		.compatible =3D "renesas,vin-r8a7790",
> +		.data =3D &rcar_info_gen2,
> +	},
> +	{
> +		.compatible =3D "renesas,vin-r8a7791",
> +		.data =3D &rcar_info_gen2,
> +	},
> +	{
> +		.compatible =3D "renesas,vin-r8a7793",
> +		.data =3D &rcar_info_gen2,
> +	},
> +	{
> +		.compatible =3D "renesas,vin-r8a7794",
> +		.data =3D &rcar_info_gen2,
> +	},
> +	{
> +		.compatible =3D "renesas,rcar-gen2-vin",
> +		.data =3D &rcar_info_gen2,
> +	},
>  	{ },

{ /* Sentinel */ } is usually used to emphasize the need of an empty entry.

>  };
>  MODULE_DEVICE_TABLE(of, rvin_of_id_table);
>=20
>  static int rcar_vin_probe(struct platform_device *pdev)
>  {
> -	const struct of_device_id *match;
>  	struct rvin_dev *vin;
>  	struct resource *mem;
>  	int irq, ret;
> @@ -253,12 +285,8 @@ static int rcar_vin_probe(struct platform_device *pd=
ev)
> if (!vin)
>  		return -ENOMEM;
>=20
> -	match =3D of_match_device(of_match_ptr(rvin_of_id_table), &pdev->dev);
> -	if (!match)
> -		return -ENODEV;
> -
>  	vin->dev =3D &pdev->dev;
> -	vin->chip =3D (enum chip_id)match->data;
> +	vin->info =3D of_device_get_match_data(&pdev->dev);
>=20
>  	mem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (mem =3D=3D NULL)
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 4a0610a6b4503501..b1caa04921aa23bb 100644
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
> 85cb7ec53d2b08b5..0d3949c8c08c8f63 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -88,11 +88,19 @@ struct rvin_graph_entity {
>  	unsigned int sink_pad;
>  };
>=20
> +/**
> + * struct rvin_info - Information about the particular VIN implementation
> + * @chip:		type of VIN chip

While at it, how about also renaming "chip" to something more appropriate, =
as=20
the VIN isn't a chip ? Maybe "model" ?

With this fixed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

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
