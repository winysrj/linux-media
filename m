Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:51952 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727536AbeJEDoh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 23:44:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 2/3] rcar-vin: add support for UDS (Up Down Scaler)
Date: Thu, 04 Oct 2018 23:49:51 +0300
Message-ID: <1571215.HXSiu0SUD0@avalon>
In-Reply-To: <20181004200402.15113-3-niklas.soderlund+renesas@ragnatech.se>
References: <20181004200402.15113-1-niklas.soderlund+renesas@ragnatech.se> <20181004200402.15113-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Thursday, 4 October 2018 23:04:01 EEST Niklas S=F6derlund wrote:
> Some VIN instances have access to a Up Down Scaler (UDS). The UDS are on
> most SoCs shared between two VINs, the UDS can of course only be used by
> one VIN at a time.

I would drop the "of course" as it's not so evident.

s/the UDS can of course only/but a UDS can only/

> Add support to configure the UDS registers which are mapped to both VINs
> sharing the UDS address-space. While validations the format at stream

s/validations/validating/

> start make sure the companion VIN is not already using the scaler. If
> the scaler already is in use return -EBUSY.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 134 ++++++++++++++++++++-
>  drivers/media/platform/rcar-vin/rcar-vin.h |  24 ++++
>  2 files changed, 152 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> e752bc86e40153b1..f33146bda9300c21 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -74,6 +74,10 @@
>=20
>  /* Register offsets specific for Gen3 */
>  #define VNCSI_IFMD_REG		0x20 /* Video n CSI2 Interface Mode Register */
> +#define VNUDS_CTRL_REG		0x80 /* Video n scaling control register */
> +#define VNUDS_SCALE_REG		0x84 /* Video n scaling factor register */
> +#define VNUDS_PASS_BWIDTH_REG	0x90 /* Video n passband register */
> +#define VNUDS_CLIP_SIZE_REG	0xa4 /* Video n UDS output size clipping reg=
 */
>=20
>  /* Register bit fields for R-Car VIN */
>  /* Video n Main Control Register bits */
> @@ -129,6 +133,9 @@
>  #define VNCSI_IFMD_CSI_CHSEL(n) (((n) & 0xf) << 0)
>  #define VNCSI_IFMD_CSI_CHSEL_MASK 0xf
>=20
> +/* Video n scaling control register (Gen3) */
> +#define VNUDS_CTRL_AMD		(1 << 30)
> +
>  struct rvin_buffer {
>  	struct vb2_v4l2_buffer vb;
>  	struct list_head list;
> @@ -572,6 +579,78 @@ static void rvin_crop_scale_comp_gen2(struct rvin_dev
> *vin) 0, 0);
>  }
>=20
> +static unsigned int rvin_scale_ratio(unsigned int in, unsigned int out)
> +{
> +	unsigned int ratio;
> +
> +	ratio =3D in * 4096 / out;
> +	return ratio >=3D 0x10000 ? 0xffff : ratio;
> +}
> +
> +static unsigned int rvin_ratio_to_bwidth(unsigned int ratio)

I initially thought this referred to a bandwidth as in a throughput. How ab=
out=20
renaming the function to rvin_ratio_to_filter_width() ? Or possibly=20
standardize the UDS function naming to rvin_uds_*, and name it=20
rvin_uds_filter_width() or rvin_uds_passband_width() ?

> +{
> +	unsigned int mant, frac;
> +
> +	mant =3D (ratio & 0xF000) >> 12;
> +	frac =3D ratio & 0x0FFF;

Maybe lowercase hex constants ?

> +	if (mant)
> +		return 64 * 4096 * mant / (4096 * mant + frac);

Isn't the denumerator equal to ratio ? How about

	if (ratio >=3D 0x1000)
		return 64 * (ratio & 0xf000) / ratio;
	else
		return 64;

> +	return 64;
> +}
> +
> +static bool rvin_gen3_need_scaling(struct rvin_dev *vin)
> +{
> +	if (vin->info->model !=3D RCAR_GEN3)
> +		return false;

One of the two callers don't need this check, so you could move it to the=20
caller that does.

> +	return vin->crop.width !=3D vin->format.width ||
> +		vin->crop.height !=3D vin->format.height;
> +}
> +
> +static void rvin_crop_scale_comp_gen3(struct rvin_dev *vin)
> +{
> +	unsigned int ratio_h, ratio_v;
> +	unsigned int bwidth_h, bwidth_v;
> +	u32 vnmc, clip_size;
> +
> +	if (!rvin_gen3_need_scaling(vin))
> +		return;
> +
> +	ratio_h =3D rvin_scale_ratio(vin->crop.width, vin->format.width);

Is there anything that prevents the output width to be so massively bigger=
=20
than the input width to result in a ratio of 0, crashing the passband filte=
r=20
width computation ?

> +	bwidth_h =3D rvin_ratio_to_bwidth(ratio_h);
> +
> +	ratio_v =3D rvin_scale_ratio(vin->crop.height, vin->format.height);
> +	bwidth_v =3D rvin_ratio_to_bwidth(ratio_v);
> +
> +	clip_size =3D vin->format.width << 16;
> +
> +	switch (vin->format.field) {
> +	case V4L2_FIELD_INTERLACED_TB:
> +	case V4L2_FIELD_INTERLACED_BT:
> +	case V4L2_FIELD_INTERLACED:
> +	case V4L2_FIELD_SEQ_TB:
> +	case V4L2_FIELD_SEQ_BT:
> +		clip_size |=3D vin->format.height / 2;
> +		break;
> +	default:
> +		clip_size |=3D vin->format.height;
> +		break;
> +	}
> +
> +	vnmc =3D rvin_read(vin, VNMC_REG);
> +	rvin_write(vin, (vnmc & ~VNMC_VUP) | VNMC_SCLE, VNMC_REG);
> +	rvin_write(vin, VNUDS_CTRL_AMD, VNUDS_CTRL_REG);
> +	rvin_write(vin, (ratio_h << 16) | ratio_v, VNUDS_SCALE_REG);
> +	rvin_write(vin, (bwidth_h << 16) | bwidth_v, VNUDS_PASS_BWIDTH_REG);
> +	rvin_write(vin, clip_size, VNUDS_CLIP_SIZE_REG);
> +	rvin_write(vin, vnmc, VNMC_REG);
> +
> +	vin_dbg(vin, "Pre-Clip: %ux%u@%u:%u Post-Clip: %ux%u@%u:%u\n",
> +		vin->crop.width, vin->crop.height, vin->crop.left,
> +		vin->crop.top, vin->format.width, vin->format.height, 0, 0);

Now that you have (hopefully :-)) debugged the code, do you still need this=
 ?

> +}
> +
>  void rvin_crop_scale_comp(struct rvin_dev *vin)
>  {
>  	/* Set Start/End Pixel/Line Pre-Clip */
> @@ -593,8 +672,9 @@ void rvin_crop_scale_comp(struct rvin_dev *vin)
>  		break;
>  	}
>=20
> -	/* TODO: Add support for the UDS scaler. */
> -	if (vin->info->model !=3D RCAR_GEN3)
> +	if (vin->info->model =3D=3D RCAR_GEN3)
> +		rvin_crop_scale_comp_gen3(vin);
> +	else
>  		rvin_crop_scale_comp_gen2(vin);
>=20
>  	rvin_write(vin, vin->format.width, VNIS_REG);
> @@ -748,6 +828,9 @@ static int rvin_setup(struct rvin_dev *vin)
>  			vnmc |=3D VNMC_DPINE;
>  	}
>=20
> +	if (rvin_gen3_need_scaling(vin))
> +		vnmc |=3D VNMC_SCLE;
> +
>  	/* Progressive or interlaced mode */
>  	interrupts =3D progressive ? VNIE_FIE : VNIE_EFE;
>=20
> @@ -1078,10 +1161,42 @@ static int rvin_mc_validate_format(struct rvin_dev
> *vin, struct v4l2_subdev *sd, return -EPIPE;
>  	}
>=20
> -	if (fmt.format.width !=3D vin->format.width ||
> -	    fmt.format.height !=3D vin->format.height ||
> -	    fmt.format.code !=3D vin->mbus_code)
> -		return -EPIPE;
> +	vin->crop.width =3D fmt.format.width;
> +	vin->crop.height =3D fmt.format.height;

Isn't the crop rectangle supposed to come from userspace ?

> +	if (rvin_gen3_need_scaling(vin)) {
> +		const struct rvin_group_scaler *scaler;
> +		struct rvin_dev *companion;
> +
> +		if (fmt.format.code !=3D vin->mbus_code)
> +			return -EPIPE;

As this check is needed in both cases I'd move it above the scaling check.

> +		if (!vin->info->scalers)
> +			return -EPIPE;
> +
> +		for (scaler =3D vin->info->scalers;
> +		     scaler->vin || scaler->companion; scaler++)
> +			if (scaler->vin =3D=3D vin->id)
> +				break;
> +
> +		/* No scaler found for VIN. */
> +		if (!scaler->vin && !scaler->companion)
> +			return -EPIPE;
> +
> +		/* Make sure companion not using scaler. */
> +		if (scaler->companion !=3D -1) {
> +			companion =3D vin->group->vin[scaler->companion];
> +			if (companion &&
> +			    companion->state !=3D STOPPED &&
> +			    rvin_gen3_need_scaling(companion))
> +				return -EBUSY;

Without any locking, this screams of a race condition :-)

> +		}
> +	} else {
> +		if (fmt.format.width !=3D vin->format.width ||
> +		    fmt.format.height !=3D vin->format.height ||
> +		    fmt.format.code !=3D vin->mbus_code)
> +			return -EPIPE;
> +	}
>=20
>  	return 0;
>  }
> @@ -1189,6 +1304,7 @@ static void rvin_stop_streaming(struct vb2_queue *v=
q)
>  	struct rvin_dev *vin =3D vb2_get_drv_priv(vq);
>  	unsigned long flags;
>  	int retries =3D 0;
> +	u32 vnmc;
>=20
>  	spin_lock_irqsave(&vin->qlock, flags);
>=20
> @@ -1220,6 +1336,12 @@ static void rvin_stop_streaming(struct vb2_queue *=
vq)
> vin->state =3D STOPPED;
>  	}
>=20
> +	/* Clear UDS usage after we have stopped */
> +	if (vin->info->model =3D=3D RCAR_GEN3) {
> +		vnmc =3D rvin_read(vin, VNMC_REG) & ~(VNMC_SCLE | VNMC_VUP);
> +		rvin_write(vin, vnmc, VNMC_REG);
> +	}

You have quite a few read-modify-write sequences for the VNMC register in t=
he=20
driver, would it make sense to cache its value ?

>  	/* Release all active buffers */
>  	return_all_buffers(vin, VB2_BUF_STATE_ERROR);
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> 0b13b34d03e3dce4..5a617a30ba8c9a5a 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -122,6 +122,28 @@ struct rvin_group_route {
>  	unsigned int mask;
>  };
>=20
> +/**
> + * struct rvin_group_scaler - describes a scaler attached to a VIN
> + *
> + * @vin:	Numerical VIN id that have access to a UDS.

s/have/has/

> + * @companion:  Numerical VIN id that @vin share the UDS with.

s/share/shares/

And I think I would write "Numerical ID of the VIN ..." for both.

> + *
> + * -- note::
> + *	Some R-Car VIN instances have access to a Up Down Scaler (UDS).
> + *	If a VIN have a UDS attached it's almost always shared between

s/have/has/

> + *	two VIN instances. The UDS can only be used by one VIN at a time,
> + *	so the companion relationship needs to be described as well.
> + *
> + *	There are at most two VINs sharing a UDS. For each UDS shared
> + *	between two VINs there needs to be two instances of struct
> + *	rvin_group_scaler describing each of the VINs individually. If
> + *	a VIN do not share its UDS set companion to -1.

s/do/does/
s/companion/@companion/

> + */
> +struct rvin_group_scaler {
> +	int vin;

unsigned int ?

> +	int companion;
> +};
> +
>  /**
>   * struct rvin_info - Information about the particular VIN implementation
>   * @model:		VIN model
> @@ -130,6 +152,7 @@ struct rvin_group_route {
>   * @max_height:		max input height the VIN supports
>   * @routes:		list of possible routes from the CSI-2 recivers to
>   *			all VINs. The list mush be NULL terminated.
> + * @scalers:		List of available scalers, must be NULL terminated.
>   */
>  struct rvin_info {
>  	enum model_id model;
> @@ -138,6 +161,7 @@ struct rvin_info {
>  	unsigned int max_width;
>  	unsigned int max_height;
>  	const struct rvin_group_route *routes;
> +	const struct rvin_group_scaler *scalers;
>  };
>=20
>  /**

=2D-=20
Regards,

Laurent Pinchart
