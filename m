Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52688 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965843AbeBMVvo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 16:51:44 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 28/30] rcar-vin: enable support for r8a7795
Date: Tue, 13 Feb 2018 23:52:15 +0200
Message-ID: <4218499.oSW5kOTnQH@avalon>
In-Reply-To: <20180129163435.24936-29-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se> <20180129163435.24936-29-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Monday, 29 January 2018 18:34:33 EET Niklas S=F6derlund wrote:
> Add the SoC specific information for Renesas r8a7795 ES1.x and ES2.0.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/Kconfig     |   2 +-
>  drivers/media/platform/rcar-vin/rcar-core.c | 120 ++++++++++++++++++++++=
+++
>  2 files changed, 121 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/Kconfig
> b/drivers/media/platform/rcar-vin/Kconfig index
> af4c98b44d2e22cb..8fa7ee468c63afb9 100644
> --- a/drivers/media/platform/rcar-vin/Kconfig
> +++ b/drivers/media/platform/rcar-vin/Kconfig
> @@ -6,7 +6,7 @@ config VIDEO_RCAR_VIN
>  	select V4L2_FWNODE
>  	---help---
>  	  Support for Renesas R-Car Video Input (VIN) driver.
> -	  Supports R-Car Gen2 SoCs.
> +	  Supports R-Car Gen2 and Gen3 SoCs.
>=20
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called rcar-vin.
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> 7ceff0de40078580..43d2fa83875817f0 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -21,6 +21,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/slab.h>
> +#include <linux/sys_soc.h>
>=20
>  #include <media/v4l2-async.h>
>  #include <media/v4l2-fwnode.h>
> @@ -815,6 +816,104 @@ static const struct rvin_info rcar_info_gen2 =3D {
>  	.max_height =3D 2048,
>  };
>=20
> +static const struct rvin_group_route rcar_info_r8a7795_routes[] =3D {
> +	{ .vin =3D 0, .csi =3D RVIN_CSI40, .chan =3D 0, .mask =3D BIT(0) | BIT(=
3) },
> +	{ .vin =3D 0, .csi =3D RVIN_CSI20, .chan =3D 0, .mask =3D BIT(1) | BIT(=
4) },
> +	{ .vin =3D 0, .csi =3D RVIN_CSI40, .chan =3D 1, .mask =3D BIT(2) },
> +	{ .vin =3D 1, .csi =3D RVIN_CSI20, .chan =3D 0, .mask =3D BIT(0) },
> +	{ .vin =3D 1, .csi =3D RVIN_CSI40, .chan =3D 1, .mask =3D BIT(1) | BIT(=
3) },
> +	{ .vin =3D 1, .csi =3D RVIN_CSI40, .chan =3D 0, .mask =3D BIT(2) },
> +	{ .vin =3D 1, .csi =3D RVIN_CSI20, .chan =3D 1, .mask =3D BIT(4) },
> +	{ .vin =3D 2, .csi =3D RVIN_CSI20, .chan =3D 1, .mask =3D BIT(0) },
> +	{ .vin =3D 2, .csi =3D RVIN_CSI40, .chan =3D 0, .mask =3D BIT(1) },
> +	{ .vin =3D 2, .csi =3D RVIN_CSI20, .chan =3D 0, .mask =3D BIT(2) },
> +	{ .vin =3D 2, .csi =3D RVIN_CSI40, .chan =3D 2, .mask =3D BIT(3) },
> +	{ .vin =3D 2, .csi =3D RVIN_CSI20, .chan =3D 2, .mask =3D BIT(4) },
> +	{ .vin =3D 3, .csi =3D RVIN_CSI40, .chan =3D 1, .mask =3D BIT(0) },
> +	{ .vin =3D 3, .csi =3D RVIN_CSI20, .chan =3D 1, .mask =3D BIT(1) | BIT(=
2) },
> +	{ .vin =3D 3, .csi =3D RVIN_CSI40, .chan =3D 3, .mask =3D BIT(3) },
> +	{ .vin =3D 3, .csi =3D RVIN_CSI20, .chan =3D 3, .mask =3D BIT(4) },
> +	{ .vin =3D 4, .csi =3D RVIN_CSI41, .chan =3D 0, .mask =3D BIT(0) | BIT(=
3) },
> +	{ .vin =3D 4, .csi =3D RVIN_CSI20, .chan =3D 0, .mask =3D BIT(1) | BIT(=
4) },
> +	{ .vin =3D 4, .csi =3D RVIN_CSI41, .chan =3D 1, .mask =3D BIT(2) },
> +	{ .vin =3D 5, .csi =3D RVIN_CSI20, .chan =3D 0, .mask =3D BIT(0) },
> +	{ .vin =3D 5, .csi =3D RVIN_CSI41, .chan =3D 1, .mask =3D BIT(1) | BIT(=
3) },
> +	{ .vin =3D 5, .csi =3D RVIN_CSI41, .chan =3D 0, .mask =3D BIT(2) },
> +	{ .vin =3D 5, .csi =3D RVIN_CSI20, .chan =3D 1, .mask =3D BIT(4) },
> +	{ .vin =3D 6, .csi =3D RVIN_CSI20, .chan =3D 1, .mask =3D BIT(0) },
> +	{ .vin =3D 6, .csi =3D RVIN_CSI41, .chan =3D 0, .mask =3D BIT(1) },
> +	{ .vin =3D 6, .csi =3D RVIN_CSI20, .chan =3D 0, .mask =3D BIT(2) },
> +	{ .vin =3D 6, .csi =3D RVIN_CSI41, .chan =3D 2, .mask =3D BIT(3) },
> +	{ .vin =3D 6, .csi =3D RVIN_CSI20, .chan =3D 2, .mask =3D BIT(4) },
> +	{ .vin =3D 7, .csi =3D RVIN_CSI41, .chan =3D 1, .mask =3D BIT(0) },
> +	{ .vin =3D 7, .csi =3D RVIN_CSI20, .chan =3D 1, .mask =3D BIT(1) | BIT(=
2) },
> +	{ .vin =3D 7, .csi =3D RVIN_CSI41, .chan =3D 3, .mask =3D BIT(3) },
> +	{ .vin =3D 7, .csi =3D RVIN_CSI20, .chan =3D 3, .mask =3D BIT(4) },
> +	{ /* Sentinel */ }
> +};
> +
> +static const struct rvin_info rcar_info_r8a7795 =3D {
> +	.model =3D RCAR_GEN3,
> +	.use_mc =3D true,
> +	.max_width =3D 4096,
> +	.max_height =3D 4096,
> +	.routes =3D rcar_info_r8a7795_routes,
> +};
> +
> +static const struct rvin_group_route rcar_info_r8a7795es1_routes[] =3D {
> +	{ .vin =3D 0, .csi =3D RVIN_CSI40, .chan =3D 0, .mask =3D BIT(0) | BIT(=
3) },
> +	{ .vin =3D 0, .csi =3D RVIN_CSI20, .chan =3D 0, .mask =3D BIT(1) | BIT(=
4) },
> +	{ .vin =3D 0, .csi =3D RVIN_CSI21, .chan =3D 0, .mask =3D BIT(2) | BIT(=
5) },
> +	{ .vin =3D 1, .csi =3D RVIN_CSI20, .chan =3D 0, .mask =3D BIT(0) },
> +	{ .vin =3D 1, .csi =3D RVIN_CSI21, .chan =3D 0, .mask =3D BIT(1) },
> +	{ .vin =3D 1, .csi =3D RVIN_CSI40, .chan =3D 0, .mask =3D BIT(2) },
> +	{ .vin =3D 1, .csi =3D RVIN_CSI40, .chan =3D 1, .mask =3D BIT(3) },
> +	{ .vin =3D 1, .csi =3D RVIN_CSI20, .chan =3D 1, .mask =3D BIT(4) },
> +	{ .vin =3D 1, .csi =3D RVIN_CSI21, .chan =3D 1, .mask =3D BIT(5) },
> +	{ .vin =3D 2, .csi =3D RVIN_CSI21, .chan =3D 0, .mask =3D BIT(0) },
> +	{ .vin =3D 2, .csi =3D RVIN_CSI40, .chan =3D 0, .mask =3D BIT(1) },
> +	{ .vin =3D 2, .csi =3D RVIN_CSI20, .chan =3D 0, .mask =3D BIT(2) },
> +	{ .vin =3D 2, .csi =3D RVIN_CSI40, .chan =3D 2, .mask =3D BIT(3) },
> +	{ .vin =3D 2, .csi =3D RVIN_CSI20, .chan =3D 2, .mask =3D BIT(4) },
> +	{ .vin =3D 2, .csi =3D RVIN_CSI21, .chan =3D 2, .mask =3D BIT(5) },
> +	{ .vin =3D 3, .csi =3D RVIN_CSI40, .chan =3D 1, .mask =3D BIT(0) },
> +	{ .vin =3D 3, .csi =3D RVIN_CSI20, .chan =3D 1, .mask =3D BIT(1) },
> +	{ .vin =3D 3, .csi =3D RVIN_CSI21, .chan =3D 1, .mask =3D BIT(2) },
> +	{ .vin =3D 3, .csi =3D RVIN_CSI40, .chan =3D 3, .mask =3D BIT(3) },
> +	{ .vin =3D 3, .csi =3D RVIN_CSI20, .chan =3D 3, .mask =3D BIT(4) },
> +	{ .vin =3D 3, .csi =3D RVIN_CSI21, .chan =3D 3, .mask =3D BIT(5) },
> +	{ .vin =3D 4, .csi =3D RVIN_CSI41, .chan =3D 0, .mask =3D BIT(0) | BIT(=
3) },
> +	{ .vin =3D 4, .csi =3D RVIN_CSI20, .chan =3D 0, .mask =3D BIT(1) | BIT(=
4) },
> +	{ .vin =3D 4, .csi =3D RVIN_CSI21, .chan =3D 0, .mask =3D BIT(2) | BIT(=
5) },
> +	{ .vin =3D 5, .csi =3D RVIN_CSI20, .chan =3D 0, .mask =3D BIT(0) },
> +	{ .vin =3D 5, .csi =3D RVIN_CSI21, .chan =3D 0, .mask =3D BIT(1) },
> +	{ .vin =3D 5, .csi =3D RVIN_CSI41, .chan =3D 0, .mask =3D BIT(2) },
> +	{ .vin =3D 5, .csi =3D RVIN_CSI41, .chan =3D 1, .mask =3D BIT(3) },
> +	{ .vin =3D 5, .csi =3D RVIN_CSI20, .chan =3D 1, .mask =3D BIT(4) },
> +	{ .vin =3D 5, .csi =3D RVIN_CSI21, .chan =3D 1, .mask =3D BIT(5) },
> +	{ .vin =3D 6, .csi =3D RVIN_CSI21, .chan =3D 0, .mask =3D BIT(0) },
> +	{ .vin =3D 6, .csi =3D RVIN_CSI41, .chan =3D 0, .mask =3D BIT(1) },
> +	{ .vin =3D 6, .csi =3D RVIN_CSI20, .chan =3D 0, .mask =3D BIT(2) },
> +	{ .vin =3D 6, .csi =3D RVIN_CSI41, .chan =3D 2, .mask =3D BIT(3) },
> +	{ .vin =3D 6, .csi =3D RVIN_CSI20, .chan =3D 2, .mask =3D BIT(4) },
> +	{ .vin =3D 6, .csi =3D RVIN_CSI21, .chan =3D 2, .mask =3D BIT(5) },
> +	{ .vin =3D 7, .csi =3D RVIN_CSI41, .chan =3D 1, .mask =3D BIT(0) },
> +	{ .vin =3D 7, .csi =3D RVIN_CSI20, .chan =3D 1, .mask =3D BIT(1) },
> +	{ .vin =3D 7, .csi =3D RVIN_CSI21, .chan =3D 1, .mask =3D BIT(2) },
> +	{ .vin =3D 7, .csi =3D RVIN_CSI41, .chan =3D 3, .mask =3D BIT(3) },
> +	{ .vin =3D 7, .csi =3D RVIN_CSI20, .chan =3D 3, .mask =3D BIT(4) },
> +	{ .vin =3D 7, .csi =3D RVIN_CSI21, .chan =3D 3, .mask =3D BIT(5) },
> +	{ /* Sentinel */ }
> +};
> +
> +static const struct rvin_info rcar_info_r8a7795es1 =3D {
> +	.model =3D RCAR_GEN3,
> +	.use_mc =3D true,
> +	.max_width =3D 4096,
> +	.max_height =3D 4096,
> +	.routes =3D rcar_info_r8a7795es1_routes,
> +};
> +
>  static const struct of_device_id rvin_of_id_table[] =3D {
>  	{
>  		.compatible =3D "renesas,vin-r8a7778",
> @@ -844,12 +943,25 @@ static const struct of_device_id rvin_of_id_table[]=
 =3D
> { .compatible =3D "renesas,rcar-gen2-vin",
>  		.data =3D &rcar_info_gen2,
>  	},
> +	{
> +		.compatible =3D "renesas,vin-r8a7795",
> +		.data =3D &rcar_info_r8a7795,
> +	},
>  	{ /* Sentinel */ },
>  };
>  MODULE_DEVICE_TABLE(of, rvin_of_id_table);
>=20
> +static const struct soc_device_attribute r8a7795es1[] =3D {
> +	{
> +		.soc_id =3D "r8a7795", .revision =3D "ES1.*",
> +		.data =3D &rcar_info_r8a7795es1,
> +	},
> +	{ /* Sentinel */ }
> +};
> +
>  static int rcar_vin_probe(struct platform_device *pdev)
>  {
> +	const struct soc_device_attribute *attr;
>  	struct rvin_dev *vin;
>  	struct resource *mem;
>  	int irq, ret;
> @@ -861,6 +973,14 @@ static int rcar_vin_probe(struct platform_device *pd=
ev)
> vin->dev =3D &pdev->dev;
>  	vin->info =3D of_device_get_match_data(&pdev->dev);
>=20
> +	/*
> +	 * Special care is needed on r8a7795 ES1.x since it
> +	 * uses different routing than r8a7795 ES2.0.
> +	 */
> +	attr =3D soc_device_match(r8a7795es1);
> +	if (attr)
> +		vin->info =3D attr->data;
> +
>  	mem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (mem =3D=3D NULL)
>  		return -EINVAL;

=2D-=20
Regards,

Laurent Pinchart
