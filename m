Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44363 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933927AbeBMQ0D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 11:26:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 10/30] rcar-vin: fix handling of single field frames (top, bottom and alternate fields)
Date: Tue, 13 Feb 2018 18:26:34 +0200
Message-ID: <1615346.M5jUZRACzr@avalon>
In-Reply-To: <20180129163435.24936-11-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se> <20180129163435.24936-11-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Monday, 29 January 2018 18:34:15 EET Niklas S=F6derlund wrote:
> There was never proper support in the VIN driver to deliver ALTERNATING
> field format to user-space, remove this field option. The problem is
> that ALTERNATING filed order requires the sequence numbers of buffers
> returned to userspace to reflect if fields where dropped or not,
> something which is not possible with the VIN drivers capture logic.
>=20
> The VIN driver can still capture from a video source which delivers
> frames in ALTERNATING field order, but needs to combine them using the
> VIN hardware into INTERLACED field order. Before this change if a source
> was delivering fields using ALTERNATE the driver would default to
> combining them using this hardware feature. Only if the user explicitly
> requested ALTERNATE filed order would incorrect frames be delivered.
>=20
> The height should not be cut in half for the format for TOP or BOTTOM
> fields settings. This was a mistake and it was made visible by the
> scaling refactoring. Correct behavior is that the user should request a
> frame size that fits the half height frame reflected in the field
> setting. If not the VIN will do its best to scale the top or bottom to
> the requested format and cropping and scaling do not work as expected.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c  | 15 +-------
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 53 ++++++++++++-----------=
=2D--
>  2 files changed, 24 insertions(+), 44 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> fd14be20a6604d7a..c8831e189d362c8b 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -617,7 +617,6 @@ static int rvin_setup(struct rvin_dev *vin)
>  	case V4L2_FIELD_INTERLACED_BT:
>  		vnmc =3D VNMC_IM_FULL | VNMC_FOC;
>  		break;
> -	case V4L2_FIELD_ALTERNATE:
>  	case V4L2_FIELD_NONE:
>  		if (vin->continuous) {
>  			vnmc =3D VNMC_IM_ODD_EVEN;
> @@ -757,18 +756,6 @@ static int rvin_get_active_slot(struct rvin_dev *vin,
> u32 vnms) return 0;
>  }
>=20
> -static enum v4l2_field rvin_get_active_field(struct rvin_dev *vin, u32
> vnms)
> -{
> -	if (vin->format.field =3D=3D V4L2_FIELD_ALTERNATE) {
> -		/* If FS is set it's a Even field */
> -		if (vnms & VNMS_FS)
> -			return V4L2_FIELD_BOTTOM;
> -		return V4L2_FIELD_TOP;
> -	}
> -
> -	return vin->format.field;
> -}
> -
>  static void rvin_set_slot_addr(struct rvin_dev *vin, int slot, dma_addr_t
> addr) {
>  	const struct rvin_video_format *fmt;
> @@ -941,7 +928,7 @@ static irqreturn_t rvin_irq(int irq, void *data)
>  		goto done;
>=20
>  	/* Capture frame */
> -	vin->queue_buf[slot]->field =3D rvin_get_active_field(vin, vnms);
> +	vin->queue_buf[slot]->field =3D vin->format.field;
>  	vin->queue_buf[slot]->sequence =3D sequence;
>  	vin->queue_buf[slot]->vb2_buf.timestamp =3D ktime_get_ns();
>  	vb2_buffer_done(&vin->queue_buf[slot]->vb2_buf, VB2_BUF_STATE_DONE);
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 4d5be2d0c79c9c9a..9f7902d29c62e205 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -103,6 +103,28 @@ static int rvin_get_source_format(struct rvin_dev *v=
in,
> if (ret)
>  		return ret;
>=20
> +	switch (fmt.format.field) {
> +	case V4L2_FIELD_TOP:
> +	case V4L2_FIELD_BOTTOM:
> +	case V4L2_FIELD_NONE:
> +	case V4L2_FIELD_INTERLACED_TB:
> +	case V4L2_FIELD_INTERLACED_BT:
> +	case V4L2_FIELD_INTERLACED:
> +		break;
> +	case V4L2_FIELD_ALTERNATE:
> +		/*
> +		 * Driver do not (yet) support outputting ALTERNATE to a
> +		 * userspace. It dose support outputting INTERLACED so use

s/dose/does/

> +		 * the VIN hardware to combine the two fields.
> +		 */
> +		fmt.format.field =3D V4L2_FIELD_INTERLACED;
> +		fmt.format.height *=3D 2;
> +		break;

I don't like this much. The rvin_get_source_format() function is supposed t=
o=20
return the media bus format for the bus between the source and the VIN. It'=
s=20
the caller that should take the field limitations into account, otherwise y=
ou=20
end up with a mix of source and VIN data in the same structure.

> +	default:
> +		vin->format.field =3D V4L2_FIELD_NONE;
> +		break;
> +	}
> +
>  	memcpy(mbus_fmt, &fmt.format, sizeof(*mbus_fmt));
>=20
>  	return 0;
> @@ -139,33 +161,6 @@ static int rvin_reset_format(struct rvin_dev *vin)
>=20
>  	v4l2_fill_pix_format(&vin->format, &source_fmt);
>=20
> -	/*
> -	 * If the subdevice uses ALTERNATE field mode and G_STD is
> -	 * implemented use the VIN HW to combine the two fields to
> -	 * one INTERLACED frame. The ALTERNATE field mode can still
> -	 * be requested in S_FMT and be respected, this is just the
> -	 * default which is applied at probing or when S_STD is called.
> -	 */
> -	if (vin->format.field =3D=3D V4L2_FIELD_ALTERNATE &&
> -	    v4l2_subdev_has_op(vin_to_source(vin), video, g_std))
> -		vin->format.field =3D V4L2_FIELD_INTERLACED;
> -
> -	switch (vin->format.field) {
> -	case V4L2_FIELD_TOP:
> -	case V4L2_FIELD_BOTTOM:
> -	case V4L2_FIELD_ALTERNATE:
> -		vin->format.height /=3D 2;
> -		break;
> -	case V4L2_FIELD_NONE:
> -	case V4L2_FIELD_INTERLACED_TB:
> -	case V4L2_FIELD_INTERLACED_BT:
> -	case V4L2_FIELD_INTERLACED:
> -		break;
> -	default:
> -		vin->format.field =3D V4L2_FIELD_NONE;
> -		break;
> -	}
> -
>  	ret =3D rvin_reset_crop_compose(vin);
>  	if (ret)
>  		return ret;
> @@ -243,12 +238,10 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  	if (ret)
>  		return ret;
>=20
> +	/* Reject ALTERNATE  until support is added to the driver */
>  	switch (pix->field) {
>  	case V4L2_FIELD_TOP:
>  	case V4L2_FIELD_BOTTOM:
> -	case V4L2_FIELD_ALTERNATE:
> -		pix->height /=3D 2;
> -		break;
>  	case V4L2_FIELD_NONE:
>  	case V4L2_FIELD_INTERLACED_TB:
>  	case V4L2_FIELD_INTERLACED_BT:

You will then set the field to V4L2_FIELD_NONE, but the source will still=20
provide V4L2_FIELD_ALTERNATE. What will happen in the VIN, what will it=20
produce ?

=2D-=20
Regards,

Laurent Pinchart
