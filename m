Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47475 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753129AbdLHKZA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 05:25:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 27/28] rcar-vin: enable support for r8a7796
Date: Fri, 08 Dec 2017 12:25:18 +0200
Message-ID: <3711108.iWgUgp5RvI@avalon>
In-Reply-To: <20171208010842.20047-28-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <20171208010842.20047-28-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 8 December 2017 03:08:41 EET Niklas S=F6derlund wrote:
> Add the SoC specific information for Renesas r8a7796.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Rob Herring <robh@kernel.org>
> ---
>  .../devicetree/bindings/media/rcar_vin.txt         |  1 +
>  drivers/media/platform/rcar-vin/rcar-core.c        | 64 ++++++++++++++++=
+++
>  2 files changed, 65 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt
> b/Documentation/devicetree/bindings/media/rcar_vin.txt index
> 5a95d9668d2c7dfd..314743532bbb4523 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -20,6 +20,7 @@ on Gen3 to a CSI-2 receiver.
>     - "renesas,vin-r8a7793" for the R8A7793 device
>     - "renesas,vin-r8a7794" for the R8A7794 device
>     - "renesas,vin-r8a7795" for the R8A7795 device
> +   - "renesas,vin-r8a7796" for the R8A7796 device

I would move this to patch 01/28, it would nicely separate code changes fro=
m=20
DT bindings changes.

Apart from that, and the fact that I'll trust that the routing table is=20
correct,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

All this applies to patch 28/28 as well.

>     - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 or RZ/G1 compatible
>       device.
>     - "renesas,rcar-gen3-vin" for a generic R-Car Gen3 compatible device.
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> 66a8144fbba437d3..ed7fbb58ad6846c1 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -1085,6 +1085,66 @@ static const struct rvin_info rcar_info_r8a7795es1=
 =3D
> { },
>  };
>=20
> +static const struct rvin_info rcar_info_r8a7796 =3D {
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
> +			{ .csi =3D RVIN_NC, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 0 },
> +		}, {
> +			{ .csi =3D RVIN_CSI20, .chan =3D 0 },
> +			{ .csi =3D RVIN_NC, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 1 },
> +		}, {
> +			{ .csi =3D RVIN_NC, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 2 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 2 },
> +		}, {
> +			{ .csi =3D RVIN_CSI40, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 1 },
> +			{ .csi =3D RVIN_NC, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 3 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 3 },
> +		}, {
> +			{ .csi =3D RVIN_CSI40, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 0 },
> +			{ .csi =3D RVIN_NC, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 0 },
> +		}, {
> +			{ .csi =3D RVIN_CSI20, .chan =3D 0 },
> +			{ .csi =3D RVIN_NC, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 1 },
> +		}, {
> +			{ .csi =3D RVIN_NC, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 0 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 2 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 2 },
> +		}, {
> +			{ .csi =3D RVIN_CSI40, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 1 },
> +			{ .csi =3D RVIN_NC, .chan =3D 1 },
> +			{ .csi =3D RVIN_CSI40, .chan =3D 3 },
> +			{ .csi =3D RVIN_CSI20, .chan =3D 3 },
> +		},
> +	},
> +};
> +
>  static const struct of_device_id rvin_of_id_table[] =3D {
>  	{
>  		.compatible =3D "renesas,vin-r8a7778",
> @@ -1118,6 +1178,10 @@ static const struct of_device_id rvin_of_id_table[=
] =3D
> { .compatible =3D "renesas,vin-r8a7795",
>  		.data =3D &rcar_info_r8a7795,
>  	},
> +	{
> +		.compatible =3D "renesas,vin-r8a7796",
> +		.data =3D &rcar_info_r8a7796,
> +	},
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(of, rvin_of_id_table);

=2D-=20
Regards,

Laurent Pinchart
