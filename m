Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:51354 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbeJEDKO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 23:10:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 3/3] rcar-vin: declare which VINs can use a Up Down Scaler (UDS)
Date: Thu, 04 Oct 2018 23:15:38 +0300
Message-ID: <3830300.X5acWg0Hot@avalon>
In-Reply-To: <20181004200402.15113-4-niklas.soderlund+renesas@ragnatech.se>
References: <20181004200402.15113-1-niklas.soderlund+renesas@ragnatech.se> <20181004200402.15113-4-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Thursday, 4 October 2018 23:04:02 EEST Niklas S=F6derlund wrote:
> Add information about which VINs on which SoC have access to a UDS
> scaler.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> 01e418c2d4c6792e..337ae8bbe1e0b14c 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -919,12 +919,21 @@ static const struct rvin_group_route
> rcar_info_r8a7795_routes[] =3D { { /* Sentinel */ }
>  };
>=20
> +static const struct rvin_group_scaler rcar_info_h3_m3w_m3n_scalers[] =3D=
 {
> +	{ .vin =3D 0, .companion =3D 1 },
> +	{ .vin =3D 1, .companion =3D 0 },
> +	{ .vin =3D 4, .companion =3D 5 },
> +	{ .vin =3D 5, .companion =3D 4 },
> +	{ /* Sentinel */ }
> +};
> +
>  static const struct rvin_info rcar_info_r8a7795 =3D {
>  	.model =3D RCAR_GEN3,
>  	.use_mc =3D true,
>  	.max_width =3D 4096,
>  	.max_height =3D 4096,
>  	.routes =3D rcar_info_r8a7795_routes,
> +	.scalers =3D rcar_info_h3_m3w_m3n_scalers,
>  };
>=20
>  static const struct rvin_group_route rcar_info_r8a7795es1_routes[] =3D {
> @@ -979,6 +988,7 @@ static const struct rvin_info rcar_info_r8a7795es1 =
=3D {
>  	.max_width =3D 4096,
>  	.max_height =3D 4096,
>  	.routes =3D rcar_info_r8a7795es1_routes,
> +	.scalers =3D rcar_info_h3_m3w_m3n_scalers,
>  };
>=20
>  static const struct rvin_group_route rcar_info_r8a7796_routes[] =3D {
> @@ -1019,6 +1029,7 @@ static const struct rvin_info rcar_info_r8a7796 =3D=
 {
>  	.max_width =3D 4096,
>  	.max_height =3D 4096,
>  	.routes =3D rcar_info_r8a7796_routes,
> +	.scalers =3D rcar_info_h3_m3w_m3n_scalers,
>  };
>=20
>  static const struct rvin_group_route rcar_info_r8a77965_routes[] =3D {
> @@ -1063,6 +1074,7 @@ static const struct rvin_info rcar_info_r8a77965 =
=3D {
>  	.max_width =3D 4096,
>  	.max_height =3D 4096,
>  	.routes =3D rcar_info_r8a77965_routes,
> +	.scalers =3D rcar_info_h3_m3w_m3n_scalers,
>  };
>=20
>  static const struct rvin_group_route rcar_info_r8a77970_routes[] =3D {
> @@ -1088,12 +1100,18 @@ static const struct rvin_group_route
> rcar_info_r8a77995_routes[] =3D { { /* Sentinel */ }
>  };
>=20
> +static const struct rvin_group_scaler rcar_info_r8a77995_scalers[] =3D {
> +	{ .vin =3D 4, .companion =3D -1 },
> +	{ /* Sentinel */ }
> +};
> +
>  static const struct rvin_info rcar_info_r8a77995 =3D {
>  	.model =3D RCAR_GEN3,
>  	.use_mc =3D true,
>  	.max_width =3D 4096,
>  	.max_height =3D 4096,
>  	.routes =3D rcar_info_r8a77995_routes,
> +	.scalers =3D rcar_info_r8a77995_scalers,
>  };
>=20
>  static const struct of_device_id rvin_of_id_table[] =3D {


=2D-=20
Regards,

Laurent Pinchart
