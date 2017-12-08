Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47339 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754054AbdLHJvn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 04:51:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 16/28] rcar-vin: add function to manipulate Gen3 chsel value
Date: Fri, 08 Dec 2017 11:52:01 +0200
Message-ID: <20173129.GKy7R676Pn@avalon>
In-Reply-To: <20171208010842.20047-17-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <20171208010842.20047-17-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 8 December 2017 03:08:30 EET Niklas S=F6derlund wrote:
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
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 25 +++++++++++++++++++++++++
>  drivers/media/platform/rcar-vin/rcar-vin.h |  2 ++
>  2 files changed, 27 insertions(+)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> ace95d5b543a17e3..d2788d8bb9565aaa 100644
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
> @@ -1228,3 +1229,27 @@ int rvin_dma_register(struct rvin_dev *vin, int ir=
q)
>=20
>  	return ret;
>  }
> +
> +/* ---------------------------------------------------------------------=
=2D--
>   + * Gen3 CHSEL manipulation
> + */
> +
> +void rvin_set_chsel(struct rvin_dev *vin, u8 chsel)

How about naming the function a bit more explicitly,=20
rvin_set_channel_routing() for instance ?

> +{
> +	u32 ifmd, vnmc;
> +
> +	pm_runtime_get_sync(vin->dev);

Shouldn't you check the return value of this function ?

> +
> +	/* Make register writes take effect immediately */
> +	vnmc =3D rvin_read(vin, VNMC_REG) & ~VNMC_VUP;
> +	rvin_write(vin, vnmc, VNMC_REG);

Shouldn't you restore the original value of VNMC at the end of the function=
 ?=20
What if this races with device access local to the VIN0 or VIN4 instance ?

> +	ifmd =3D VNCSI_IFMD_DES2 | VNCSI_IFMD_DES1 | VNCSI_IFMD_DES0 |
> +		VNCSI_IFMD_CSI_CHSEL(chsel);
> +
> +	rvin_write(vin, ifmd, VNCSI_IFMD_REG);
> +
> +	vin_dbg(vin, "Set IFMD 0x%x\n", ifmd);
> +
> +	pm_runtime_put(vin->dev);
> +}
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> a440effe4b86af31..7819c760c2c13422 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -163,4 +163,6 @@ void rvin_v4l2_unregister(struct rvin_dev *vin);
>=20
>  const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
>=20
> +void rvin_set_chsel(struct rvin_dev *vin, u8 chsel);
> +
>  #endif

=2D-=20
Regards,

Laurent Pinchart
