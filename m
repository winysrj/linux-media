Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47314 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753749AbdLHJqz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 04:46:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 15/28] rcar-vin: enable Gen3 hardware configuration
Date: Fri, 08 Dec 2017 11:47:13 +0200
Message-ID: <5504263.YnyVsq6zZe@avalon>
In-Reply-To: <20171208010842.20047-16-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <20171208010842.20047-16-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 8 December 2017 03:08:29 EET Niklas S=F6derlund wrote:
> Add the register needed to work with Gen3 hardware. This patch adds
> the logic for how to work with the Gen3 hardware. More work is required
> to enable the subdevice structure needed to configure capturing.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 94 ++++++++++++++++++------=
=2D--
>  drivers/media/platform/rcar-vin/rcar-vin.h |  1 +
>  2 files changed, 64 insertions(+), 31 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> d7660f485a2df9e4..ace95d5b543a17e3 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -33,21 +33,23 @@
>  #define VNELPRC_REG	0x10	/* Video n End Line Pre-Clip Register */
>  #define VNSPPRC_REG	0x14	/* Video n Start Pixel Pre-Clip Register */
>  #define VNEPPRC_REG	0x18	/* Video n End Pixel Pre-Clip Register */
> -#define VNSLPOC_REG	0x1C	/* Video n Start Line Post-Clip Register */
> -#define VNELPOC_REG	0x20	/* Video n End Line Post-Clip Register */
> -#define VNSPPOC_REG	0x24	/* Video n Start Pixel Post-Clip Register */
> -#define VNEPPOC_REG	0x28	/* Video n End Pixel Post-Clip Register */
>  #define VNIS_REG	0x2C	/* Video n Image Stride Register */
>  #define VNMB_REG(m)	(0x30 + ((m) << 2)) /* Video n Memory Base m Register
> */ #define VNIE_REG	0x40	/* Video n Interrupt Enable Register */
>  #define VNINTS_REG	0x44	/* Video n Interrupt Status Register */
>  #define VNSI_REG	0x48	/* Video n Scanline Interrupt Register */
>  #define VNMTC_REG	0x4C	/* Video n Memory Transfer Control Register */
> -#define VNYS_REG	0x50	/* Video n Y Scale Register */
> -#define VNXS_REG	0x54	/* Video n X Scale Register */
>  #define VNDMR_REG	0x58	/* Video n Data Mode Register */
>  #define VNDMR2_REG	0x5C	/* Video n Data Mode Register 2 */
>  #define VNUVAOF_REG	0x60	/* Video n UV Address Offset Register */
> +
> +/* Register offsets specific for Gen2 */
> +#define VNSLPOC_REG	0x1C	/* Video n Start Line Post-Clip Register */
> +#define VNELPOC_REG	0x20	/* Video n End Line Post-Clip Register */
> +#define VNSPPOC_REG	0x24	/* Video n Start Pixel Post-Clip Register */
> +#define VNEPPOC_REG	0x28	/* Video n End Pixel Post-Clip Register */
> +#define VNYS_REG	0x50	/* Video n Y Scale Register */
> +#define VNXS_REG	0x54	/* Video n X Scale Register */
>  #define VNC1A_REG	0x80	/* Video n Coefficient Set C1A Register */
>  #define VNC1B_REG	0x84	/* Video n Coefficient Set C1B Register */
>  #define VNC1C_REG	0x88	/* Video n Coefficient Set C1C Register */
> @@ -73,9 +75,13 @@
>  #define VNC8B_REG	0xF4	/* Video n Coefficient Set C8B Register */
>  #define VNC8C_REG	0xF8	/* Video n Coefficient Set C8C Register */
>=20
> +/* Register offsets specific for Gen3 */
> +#define VNCSI_IFMD_REG		0x20 /* Video n CSI2 Interface Mode Register */
>=20
>  /* Register bit fields for R-Car VIN */
>  /* Video n Main Control Register bits */
> +#define VNMC_DPINE		(1 << 27) /* Gen3 specific */
> +#define VNMC_SCLE		(1 << 26) /* Gen3 specific */
>  #define VNMC_FOC		(1 << 21)
>  #define VNMC_YCAL		(1 << 19)
>  #define VNMC_INF_YUV8_BT656	(0 << 16)
> @@ -119,6 +125,13 @@
>  #define VNDMR2_FTEV		(1 << 17)
>  #define VNDMR2_VLV(n)		((n & 0xf) << 12)
>=20
> +/* Video n CSI2 Interface Mode Register (Gen3) */
> +#define VNCSI_IFMD_DES2		(1 << 27)
> +#define VNCSI_IFMD_DES1		(1 << 26)
> +#define VNCSI_IFMD_DES0		(1 << 25)
> +#define VNCSI_IFMD_CSI_CHSEL(n) ((n & 0xf) << 0)

*Always* enclose macro arguments in parentheses otherwise they are subject =
to=20
side effects.

#define VNCSI_IFMD_CSI_CHSEL(n) (((n) & 0xf) << 0)

> +#define VNCSI_IFMD_CSI_CHSEL_MASK 0xf
> +
>  struct rvin_buffer {
>  	struct vb2_v4l2_buffer vb;
>  	struct list_head list;
> @@ -514,28 +527,10 @@ static void rvin_set_coeff(struct rvin_dev *vin,
> unsigned short xs) rvin_write(vin, p_set->coeff_set[23], VNC8C_REG);
>  }
>=20
> -static void rvin_crop_scale_comp(struct rvin_dev *vin)
> +static void rvin_crop_scale_comp_gen2(struct rvin_dev *vin)
>  {
>  	u32 xs, ys;
>=20
> -	/* Set Start/End Pixel/Line Pre-Clip */
> -	rvin_write(vin, vin->crop.left, VNSPPRC_REG);
> -	rvin_write(vin, vin->crop.left + vin->crop.width - 1, VNEPPRC_REG);
> -	switch (vin->format.field) {
> -	case V4L2_FIELD_INTERLACED:
> -	case V4L2_FIELD_INTERLACED_TB:
> -	case V4L2_FIELD_INTERLACED_BT:
> -		rvin_write(vin, vin->crop.top / 2, VNSLPRC_REG);
> -		rvin_write(vin, (vin->crop.top + vin->crop.height) / 2 - 1,
> -			   VNELPRC_REG);
> -		break;
> -	default:
> -		rvin_write(vin, vin->crop.top, VNSLPRC_REG);
> -		rvin_write(vin, vin->crop.top + vin->crop.height - 1,
> -			   VNELPRC_REG);
> -		break;
> -	}
> -
>  	/* Set scaling coefficient */
>  	ys =3D 0;
>  	if (vin->crop.height !=3D vin->compose.height)
> @@ -573,11 +568,6 @@ static void rvin_crop_scale_comp(struct rvin_dev *vi=
n)
>  		break;
>  	}
>=20
> -	if (vin->format.pixelformat =3D=3D V4L2_PIX_FMT_NV16)
> -		rvin_write(vin, ALIGN(vin->format.width, 0x20), VNIS_REG);
> -	else
> -		rvin_write(vin, ALIGN(vin->format.width, 0x10), VNIS_REG);
> -
>  	vin_dbg(vin,
>  		"Pre-Clip: %ux%u@%u:%u YS: %d XS: %d Post-Clip: %ux%u@%u:%u\n",
>  		vin->crop.width, vin->crop.height, vin->crop.left,

Would it make sense to keep the debug message in the common function, or il=
l=20
cropping and composing be handled through subdevs for Gen3 ?

With these two issues addressed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> @@ -585,6 +575,37 @@ static void rvin_crop_scale_comp(struct rvin_dev *vi=
n)
>  		0, 0);
>  }
>=20
> +static void rvin_crop_scale_comp(struct rvin_dev *vin)
> +{
> +	/* Set Start/End Pixel/Line Pre-Clip */
> +	rvin_write(vin, vin->crop.left, VNSPPRC_REG);
> +	rvin_write(vin, vin->crop.left + vin->crop.width - 1, VNEPPRC_REG);
> +
> +	switch (vin->format.field) {
> +	case V4L2_FIELD_INTERLACED:
> +	case V4L2_FIELD_INTERLACED_TB:
> +	case V4L2_FIELD_INTERLACED_BT:
> +		rvin_write(vin, vin->crop.top / 2, VNSLPRC_REG);
> +		rvin_write(vin, (vin->crop.top + vin->crop.height) / 2 - 1,
> +			   VNELPRC_REG);
> +		break;
> +	default:
> +		rvin_write(vin, vin->crop.top, VNSLPRC_REG);
> +		rvin_write(vin, vin->crop.top + vin->crop.height - 1,
> +			   VNELPRC_REG);
> +		break;
> +	}
> +
> +	/* TODO: Add support for the UDS scaler. */
> +	if (vin->info->chip !=3D RCAR_GEN3)
> +		rvin_crop_scale_comp_gen2(vin);
> +
> +	if (vin->format.pixelformat =3D=3D V4L2_PIX_FMT_NV16)
> +		rvin_write(vin, ALIGN(vin->format.width, 0x20), VNIS_REG);
> +	else
> +		rvin_write(vin, ALIGN(vin->format.width, 0x10), VNIS_REG);
> +}
> +
>  /* ---------------------------------------------------------------------=
=2D--
>   * Hardware setup
>   */
> @@ -659,7 +680,10 @@ static int rvin_setup(struct rvin_dev *vin)
>  	}
>=20
>  	/* Enable VSYNC Field Toogle mode after one VSYNC input */
> -	dmr2 =3D VNDMR2_FTEV | VNDMR2_VLV(1);
> +	if (vin->info->chip =3D=3D RCAR_GEN3)
> +		dmr2 =3D VNDMR2_FTEV;
> +	else
> +		dmr2 =3D VNDMR2_FTEV | VNDMR2_VLV(1);
>=20
>  	/* Hsync Signal Polarity Select */
>  	if (!(vin->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
> @@ -711,6 +735,14 @@ static int rvin_setup(struct rvin_dev *vin)
>  	if (input_is_yuv =3D=3D output_is_yuv)
>  		vnmc |=3D VNMC_BPS;
>=20
> +	if (vin->info->chip =3D=3D RCAR_GEN3) {
> +		/* Select between CSI-2 and Digital input */
> +		if (vin->mbus_cfg.type =3D=3D V4L2_MBUS_CSI2)
> +			vnmc &=3D ~VNMC_DPINE;
> +		else
> +			vnmc |=3D VNMC_DPINE;
> +	}
> +
>  	/* Progressive or interlaced mode */
>  	interrupts =3D progressive ? VNIE_FIE : VNIE_EFE;
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> 118f45b656920d39..a440effe4b86af31 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -33,6 +33,7 @@ enum chip_id {
>  	RCAR_H1,
>  	RCAR_M1,
>  	RCAR_GEN2,
> +	RCAR_GEN3,
>  };
>=20
>  /**

=2D-=20
Regards,

Laurent Pinchart
