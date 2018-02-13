Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44760 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934210AbeBMQlC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 11:41:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 13/30] rcar-vin: add function to manipulate Gen3 chsel value
Date: Tue, 13 Feb 2018 18:41:33 +0200
Message-ID: <6540925.qhrue9hUJl@avalon>
In-Reply-To: <20180129163435.24936-14-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se> <20180129163435.24936-14-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Monday, 29 January 2018 18:34:18 EET Niklas S=F6derlund wrote:
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
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 28 ++++++++++++++++++++++++=
+++
>  drivers/media/platform/rcar-vin/rcar-vin.h |  2 ++
>  2 files changed, 30 insertions(+)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> 2f9ad1bec1c8a92f..ae286742f15a3ab5 100644
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
> @@ -1228,3 +1229,30 @@ int rvin_dma_register(struct rvin_dev *vin, int ir=
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
> +void rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel)
> +{
> +	u32 ifmd, vnmc;
> +
> +	pm_runtime_get_sync(vin->dev);

No need to check for errors ?

> +
> +	/* Make register writes take effect immediately */
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
> +	/* Restore VNMC */
> +	rvin_write(vin, vnmc, VNMC_REG);

No need for locking around all this ? What happens if this VIN instance=20
decides to write to another VIN register (for instance due to a userpace ca=
ll)=20
when this function has disabled VNMC_VUP ?

> +	pm_runtime_put(vin->dev);
> +}
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> 146683142e6533fa..a5dae5b5e9cb704b 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -165,4 +165,6 @@ const struct rvin_video_format
> *rvin_format_from_pixel(u32 pixelformat); /* Cropping, composing and
> scaling */
>  void rvin_crop_scale_comp(struct rvin_dev *vin);
>=20
> +void rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel);
> +
>  #endif

=2D-=20
Regards,

Laurent Pinchart
