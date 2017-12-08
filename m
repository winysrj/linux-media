Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47453 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752883AbdLHKVX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 05:21:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 26/28] rcar-vin: enable support for r8a7795
Date: Fri, 08 Dec 2017 12:21:37 +0200
Message-ID: <2036677.NmziRCj8aB@avalon>
In-Reply-To: <20171208010842.20047-27-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <20171208010842.20047-27-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 8 December 2017 03:08:40 EET Niklas S=F6derlund wrote:
> Add the SoC specific information for Renesas r8a7795 ES1.x and ES2.0.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

I'll trust that the routing table is correct. Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/Kconfig     |   2 +-
>  drivers/media/platform/rcar-vin/rcar-core.c | 150 ++++++++++++++++++++++=
+++
>  2 files changed, 151 insertions(+), 1 deletion(-)
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
> 09ebeff1580556dc..66a8144fbba437d3 100644
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
> @@ -956,6 +957,134 @@ static const struct rvin_info rcar_info_gen2 =3D {
>  	.max_height =3D 2048,
>  };
>=20
> +static const struct rvin_info rcar_info_r8a7795 =3D {
> +	.chip =3D RCAR_GEN3,
> +	.use_mc =3D true,
> +	.max_width =3D 4096,
> +	.max_height =3D 4096,
> +
> +	.num_chsels =3D 5,
> +	.chsels =3D {
> +		{
> +			{ .csi =3D RVIN_CSI40, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 0 },
> +		}, {
> +			{ .csi =3D RVIN_CSI20, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 1 },
> +		}, {
> +			{ .csi =3D RVIN_CSI20, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 2 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 2 },
> +		}, {
> +			{ .csi =3D RVIN_CSI40, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 3 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 3 },
> +		}, {
> +			{ .csi =3D RVIN_CSI41, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI41, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI41, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 0 },
> +		}, {
> +			{ .csi =3D RVIN_CSI20, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI41, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI41, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI41, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 1 },
> +		}, {
> +			{ .csi =3D RVIN_CSI20, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI41, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI41, .chan =3D 2 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 2 },
> +		}, {
> +			{ .csi =3D RVIN_CSI41, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI41, .chan =3D 3 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 3 },
> +		},
> +	},
> +};
> +
> +static const struct rvin_info rcar_info_r8a7795es1 =3D {
> +	.chip =3D RCAR_GEN3,
> +	.use_mc =3D true,
> +	.max_width =3D 4096,
> +	.max_height =3D 4096,
> +
> +	.num_chsels =3D 6,
> +	.chsels =3D {
> +		{
> +			{ .csi =3D RVIN_CSI40, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI21, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI21, .chan =3D 0 },
> +		}, {
> +			{ .csi =3D RVIN_CSI20, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI21, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI21, .chan =3D 1 },
> +		}, {
> +			{ .csi =3D RVIN_CSI21, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 2 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 2 },
> +			{ .csi =3D RVIN_CSI21, .chan =3D 2 },
> +		}, {
> +			{ .csi =3D RVIN_CSI40, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI21, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 3 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 3 },
> +			{ .csi =3D RVIN_CSI21, .chan =3D 3 },
> +		}, {
> +			{ .csi =3D RVIN_CSI41, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI21, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI41, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI21, .chan =3D 0 },
> +		}, {
> +			{ .csi =3D RVIN_CSI20, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI21, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI41, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI41, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI21, .chan =3D 1 },
> +		}, {
> +			{ .csi =3D RVIN_CSI21, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI41, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI41, .chan =3D 2 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 2 },
> +			{ .csi =3D RVIN_CSI21, .chan =3D 2 },
> +		}, {
> +			{ .csi =3D RVIN_CSI41, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI21, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI41, .chan =3D 3 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 3 },
> +			{ .csi =3D RVIN_CSI21, .chan =3D 3 },
> +		},
> +	},
> +};
> +
>  static const struct of_device_id rvin_of_id_table[] =3D {
>  	{
>  		.compatible =3D "renesas,vin-r8a7778",
> @@ -985,12 +1114,25 @@ static const struct of_device_id rvin_of_id_table[=
] =3D
> { .compatible =3D "renesas,rcar-gen2-vin",
>  		.data =3D &rcar_info_gen2,
>  	},
> +	{
> +		.compatible =3D "renesas,vin-r8a7795",
> +		.data =3D &rcar_info_r8a7795,
> +	},
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(of, rvin_of_id_table);
>=20
> +static const struct soc_device_attribute r8a7795es1[] =3D {
> +	{
> +		.soc_id =3D "r8a7795", .revision =3D "ES1.*",
> +		.data =3D &rcar_info_r8a7795es1,
> +	},
> +	{ /* sentinel */ }
> +};
> +
>  static int rcar_vin_probe(struct platform_device *pdev)
>  {
> +	const struct soc_device_attribute *attr;
>  	struct rvin_dev *vin;
>  	struct resource *mem;
>  	int irq, ret;
> @@ -1002,6 +1144,14 @@ static int rcar_vin_probe(struct platform_device
> *pdev) vin->dev =3D &pdev->dev;
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
