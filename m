Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:59114 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751927AbeENCFy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 May 2018 22:05:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: rcar-vin: enable support for r8a77965
Date: Mon, 14 May 2018 05:06:11 +0300
Message-ID: <3586332.p7dOIGCUmf@avalon>
In-Reply-To: <20180513190023.16170-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180513190023.16170-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Sunday, 13 May 2018 22:00:23 EEST Niklas S=F6derlund wrote:
> Add the SoC specific information for Renesas r8a77965.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 48 +++++++++++++++++++++
>  1 file changed, 48 insertions(+)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> d3072e166a1ca24f..f7bfd05accbfde67 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -974,6 +974,50 @@ static const struct rvin_info rcar_info_r8a7796 =3D {
>  	.routes =3D rcar_info_r8a7796_routes,
>  };
>=20
> +static const struct rvin_group_route _rcar_info_r8a77965_routes[] =3D {
> +	{ .csi =3D RVIN_CSI40, .channel =3D 0, .vin =3D 0, .mask =3D BIT(0) | B=
IT(3) },
> +	{ .csi =3D RVIN_CSI20, .channel =3D 0, .vin =3D 0, .mask =3D BIT(1) | B=
IT(4) },
> +	{ .csi =3D RVIN_CSI40, .channel =3D 1, .vin =3D 0, .mask =3D BIT(2) },
> +	{ .csi =3D RVIN_CSI20, .channel =3D 0, .vin =3D 1, .mask =3D BIT(0) },
> +	{ .csi =3D RVIN_CSI40, .channel =3D 1, .vin =3D 1, .mask =3D BIT(1) | B=
IT(3) },
> +	{ .csi =3D RVIN_CSI40, .channel =3D 0, .vin =3D 1, .mask =3D BIT(2) },
> +	{ .csi =3D RVIN_CSI20, .channel =3D 1, .vin =3D 1, .mask =3D BIT(4) },
> +	{ .csi =3D RVIN_CSI20, .channel =3D 1, .vin =3D 2, .mask =3D BIT(0) },
> +	{ .csi =3D RVIN_CSI40, .channel =3D 0, .vin =3D 2, .mask =3D BIT(1) },
> +	{ .csi =3D RVIN_CSI20, .channel =3D 0, .vin =3D 2, .mask =3D BIT(2) },
> +	{ .csi =3D RVIN_CSI40, .channel =3D 2, .vin =3D 2, .mask =3D BIT(3) },
> +	{ .csi =3D RVIN_CSI20, .channel =3D 2, .vin =3D 2, .mask =3D BIT(4) },
> +	{ .csi =3D RVIN_CSI40, .channel =3D 1, .vin =3D 3, .mask =3D BIT(0) },
> +	{ .csi =3D RVIN_CSI20, .channel =3D 1, .vin =3D 3, .mask =3D BIT(1) | B=
IT(2) },
> +	{ .csi =3D RVIN_CSI40, .channel =3D 3, .vin =3D 3, .mask =3D BIT(3) },
> +	{ .csi =3D RVIN_CSI20, .channel =3D 3, .vin =3D 3, .mask =3D BIT(4) },
> +	{ .csi =3D RVIN_CSI40, .channel =3D 0, .vin =3D 4, .mask =3D BIT(0) | B=
IT(3) },
> +	{ .csi =3D RVIN_CSI20, .channel =3D 0, .vin =3D 4, .mask =3D BIT(1) | B=
IT(4) },
> +	{ .csi =3D RVIN_CSI40, .channel =3D 1, .vin =3D 4, .mask =3D BIT(2) },
> +	{ .csi =3D RVIN_CSI20, .channel =3D 0, .vin =3D 5, .mask =3D BIT(0) },
> +	{ .csi =3D RVIN_CSI40, .channel =3D 1, .vin =3D 5, .mask =3D BIT(1) | B=
IT(3) },
> +	{ .csi =3D RVIN_CSI40, .channel =3D 0, .vin =3D 5, .mask =3D BIT(2) },
> +	{ .csi =3D RVIN_CSI20, .channel =3D 1, .vin =3D 5, .mask =3D BIT(4) },
> +	{ .csi =3D RVIN_CSI20, .channel =3D 1, .vin =3D 6, .mask =3D BIT(0) },
> +	{ .csi =3D RVIN_CSI40, .channel =3D 0, .vin =3D 6, .mask =3D BIT(1) },
> +	{ .csi =3D RVIN_CSI20, .channel =3D 0, .vin =3D 6, .mask =3D BIT(2) },
> +	{ .csi =3D RVIN_CSI40, .channel =3D 2, .vin =3D 6, .mask =3D BIT(3) },
> +	{ .csi =3D RVIN_CSI20, .channel =3D 2, .vin =3D 6, .mask =3D BIT(4) },
> +	{ .csi =3D RVIN_CSI40, .channel =3D 1, .vin =3D 7, .mask =3D BIT(0) },
> +	{ .csi =3D RVIN_CSI20, .channel =3D 1, .vin =3D 7, .mask =3D BIT(1) | B=
IT(2) },
> +	{ .csi =3D RVIN_CSI40, .channel =3D 3, .vin =3D 7, .mask =3D BIT(3) },
> +	{ .csi =3D RVIN_CSI20, .channel =3D 3, .vin =3D 7, .mask =3D BIT(4) },
> +	{ /* Sentinel */ }
> +};
> +
> +static const struct rvin_info rcar_info_r8a77965 =3D {
> +	.model =3D RCAR_GEN3,
> +	.use_mc =3D true,
> +	.max_width =3D 4096,
> +	.max_height =3D 4096,
> +	.routes =3D _rcar_info_r8a77965_routes,
> +};
> +
>  static const struct rvin_group_route _rcar_info_r8a77970_routes[] =3D {
>  	{ .csi =3D RVIN_CSI40, .channel =3D 0, .vin =3D 0, .mask =3D BIT(0) | B=
IT(3) },
>  	{ .csi =3D RVIN_CSI40, .channel =3D 0, .vin =3D 1, .mask =3D BIT(2) },
> @@ -1030,6 +1074,10 @@ static const struct of_device_id rvin_of_id_table[=
] =3D
> { .compatible =3D "renesas,vin-r8a7796",
>  		.data =3D &rcar_info_r8a7796,
>  	},
> +	{
> +		.compatible =3D "renesas,vin-r8a77965",
> +		.data =3D &rcar_info_r8a77965,
> +	},
>  	{
>  		.compatible =3D "renesas,vin-r8a77970",
>  		.data =3D &rcar_info_r8a77970,

=2D-=20
Regards,

Laurent Pinchart
