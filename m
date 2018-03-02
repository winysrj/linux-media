Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52765 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423169AbeCBLa5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 06:30:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v11 19/32] rcar-vin: add function to manipulate Gen3 chsel value
Date: Fri, 02 Mar 2018 13:31:47 +0200
Message-ID: <1626554.hLmvUq6KA6@avalon>
In-Reply-To: <20180302015751.25596-20-niklas.soderlund+renesas@ragnatech.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se> <20180302015751.25596-20-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 2 March 2018 03:57:38 EET Niklas S=F6derlund wrote:
> On Gen3 the CSI-2 routing is controlled by the VnCSI_IFMD register. One
> feature of this register is that it's only present in the VIN0 and VIN4
> instances. The register in VIN0 controls the routing for VIN0-3 and the
> register in VIN4 controls routing for VIN4-7.
>=20
> To be able to control routing from a media device this function is need
> to control runtime PM for the subgroup master (VIN0 and VIN4). The
> subgroup master must be switched on before the register is manipulated,
> once the operation is complete it's safe to switch the master off and
> the new routing will still be in effect.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 38 ++++++++++++++++++++++++=
+++
>  drivers/media/platform/rcar-vin/rcar-vin.h |  2 ++
>  2 files changed, 40 insertions(+)

By the way it would be useful if you added per-patch changelogs. You can=20
capture them in the commit message below a --- line.

> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> 57bb288b3ca67a60..3fb9c325285c5a5a 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -16,6 +16,7 @@
>=20
>  #include <linux/delay.h>
>  #include <linux/interrupt.h>
> +#include <linux/pm_runtime.h>
>=20
>  #include <media/videobuf2-dma-contig.h>
>=20
> @@ -1228,3 +1229,40 @@ int rvin_dma_register(struct rvin_dev *vin, int ir=
q)
>=20
>  	return ret;
>  }
> +
> +/* ---------------------------------------------------------------------=
=2D--
> + * Gen3 CHSEL manipulation
> + */
> +
> +/*
> + * There is no need to have locking around changing the routing
> + * as it's only possible to do so when no VIN in the group is
> + * streaming so nothing can race with the VNMC register.
> + */
> +int rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel)
> +{
> +	u32 ifmd, vnmc;
> +	int ret;
> +
> +	ret =3D pm_runtime_get_sync(vin->dev);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Make register writes take effect immediately. */
> +	vnmc =3D rvin_read(vin, VNMC_REG);
> +	rvin_write(vin, vnmc & ~VNMC_VUP, VNMC_REG);
> +
> +	ifmd =3D VNCSI_IFMD_DES2 | VNCSI_IFMD_DES1 | VNCSI_IFMD_DES0 |
> +		VNCSI_IFMD_CSI_CHSEL(chsel);
> +
> +	rvin_write(vin, ifmd, VNCSI_IFMD_REG);
> +
> +	vin_dbg(vin, "Set IFMD 0x%x\n", ifmd);
> +
> +	/* Restore VNMC. */
> +	rvin_write(vin, vnmc, VNMC_REG);
> +
> +	pm_runtime_put(vin->dev);
> +
> +	return ret;
> +}
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> b3802651eaa78ea9..666308946eb4994d 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -165,4 +165,6 @@ const struct rvin_video_format
> *rvin_format_from_pixel(u32 pixelformat); /* Cropping, composing and
> scaling */
>  void rvin_crop_scale_comp(struct rvin_dev *vin);
>=20
> +int rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel);
> +
>  #endif

=2D-=20
Regards,

Laurent Pinchart
