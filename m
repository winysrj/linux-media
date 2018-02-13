Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52700 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965843AbeBMVyY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 16:54:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 29/30] rcar-vin: enable support for r8a7796
Date: Tue, 13 Feb 2018 23:54:55 +0200
Message-ID: <5136578.MxM64rYMOm@avalon>
In-Reply-To: <20180129163435.24936-30-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se> <20180129163435.24936-30-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Monday, 29 January 2018 18:34:34 EET Niklas S=F6derlund wrote:
> Add the SoC specific information for Renesas r8a7796.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 44 +++++++++++++++++++++++=
+++
>  1 file changed, 44 insertions(+)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> 43d2fa83875817f0..2305fedd293db241 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -914,6 +914,46 @@ static const struct rvin_info rcar_info_r8a7795es1 =
=3D {
>  	.routes =3D rcar_info_r8a7795es1_routes,
>  };
>=20
> +static const struct rvin_group_route rcar_info_r8a7796_routes[] =3D {
> +	{ .vin =3D 0, .csi =3D RVIN_CSI40, .chan =3D 0, .mask =3D BIT(0) | BIT(=
3) },
> +	{ .vin =3D 0, .csi =3D RVIN_CSI20, .chan =3D 0, .mask =3D BIT(1) | BIT(=
4) },
> +	{ .vin =3D 1, .csi =3D RVIN_CSI20, .chan =3D 0, .mask =3D BIT(0) },
> +	{ .vin =3D 1, .csi =3D RVIN_CSI40, .chan =3D 0, .mask =3D BIT(2) },
> +	{ .vin =3D 1, .csi =3D RVIN_CSI40, .chan =3D 1, .mask =3D BIT(3) },
> +	{ .vin =3D 1, .csi =3D RVIN_CSI20, .chan =3D 1, .mask =3D BIT(4) },
> +	{ .vin =3D 2, .csi =3D RVIN_CSI40, .chan =3D 0, .mask =3D BIT(1) },
> +	{ .vin =3D 2, .csi =3D RVIN_CSI20, .chan =3D 0, .mask =3D BIT(2) },
> +	{ .vin =3D 2, .csi =3D RVIN_CSI40, .chan =3D 2, .mask =3D BIT(3) },
> +	{ .vin =3D 2, .csi =3D RVIN_CSI20, .chan =3D 2, .mask =3D BIT(4) },
> +	{ .vin =3D 3, .csi =3D RVIN_CSI40, .chan =3D 1, .mask =3D BIT(0) },
> +	{ .vin =3D 3, .csi =3D RVIN_CSI20, .chan =3D 1, .mask =3D BIT(1) },
> +	{ .vin =3D 3, .csi =3D RVIN_CSI40, .chan =3D 3, .mask =3D BIT(3) },
> +	{ .vin =3D 3, .csi =3D RVIN_CSI20, .chan =3D 3, .mask =3D BIT(4) },
> +	{ .vin =3D 4, .csi =3D RVIN_CSI40, .chan =3D 0, .mask =3D BIT(0) | BIT(=
3) },
> +	{ .vin =3D 4, .csi =3D RVIN_CSI20, .chan =3D 0, .mask =3D BIT(1) | BIT(=
4) },
> +	{ .vin =3D 5, .csi =3D RVIN_CSI20, .chan =3D 0, .mask =3D BIT(0) },
> +	{ .vin =3D 5, .csi =3D RVIN_CSI40, .chan =3D 0, .mask =3D BIT(2) },
> +	{ .vin =3D 5, .csi =3D RVIN_CSI40, .chan =3D 1, .mask =3D BIT(3) },
> +	{ .vin =3D 5, .csi =3D RVIN_CSI20, .chan =3D 1, .mask =3D BIT(4) },
> +	{ .vin =3D 6, .csi =3D RVIN_CSI40, .chan =3D 0, .mask =3D BIT(1) },
> +	{ .vin =3D 6, .csi =3D RVIN_CSI20, .chan =3D 0, .mask =3D BIT(2) },
> +	{ .vin =3D 6, .csi =3D RVIN_CSI40, .chan =3D 2, .mask =3D BIT(3) },
> +	{ .vin =3D 6, .csi =3D RVIN_CSI20, .chan =3D 2, .mask =3D BIT(4) },
> +	{ .vin =3D 7, .csi =3D RVIN_CSI40, .chan =3D 1, .mask =3D BIT(0) },
> +	{ .vin =3D 7, .csi =3D RVIN_CSI20, .chan =3D 1, .mask =3D BIT(1) },
> +	{ .vin =3D 7, .csi =3D RVIN_CSI40, .chan =3D 3, .mask =3D BIT(3) },
> +	{ .vin =3D 7, .csi =3D RVIN_CSI20, .chan =3D 3, .mask =3D BIT(4) },
> +	{ /* Sentinel */ }
> +};
> +
> +static const struct rvin_info rcar_info_r8a7796 =3D {
> +	.model =3D RCAR_GEN3,
> +	.use_mc =3D true,
> +	.max_width =3D 4096,
> +	.max_height =3D 4096,
> +	.routes =3D rcar_info_r8a7796_routes,
> +};
> +
>  static const struct of_device_id rvin_of_id_table[] =3D {
>  	{
>  		.compatible =3D "renesas,vin-r8a7778",
> @@ -947,6 +987,10 @@ static const struct of_device_id rvin_of_id_table[] =
=3D {
> .compatible =3D "renesas,vin-r8a7795",
>  		.data =3D &rcar_info_r8a7795,
>  	},
> +	{
> +		.compatible =3D "renesas,vin-r8a7796",
> +		.data =3D &rcar_info_r8a7796,
> +	},
>  	{ /* Sentinel */ },
>  };
>  MODULE_DEVICE_TABLE(of, rvin_of_id_table);


=2D-=20
Regards,

Laurent Pinchart
