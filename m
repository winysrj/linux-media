Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47247 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753270AbdLHJfC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 04:35:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 13/28] rcar-vin: fix handling of single field frames (top, bottom and alternate fields)
Date: Fri, 08 Dec 2017 11:35:18 +0200
Message-ID: <1830403.Cn442MVTMc@avalon>
In-Reply-To: <20171208010842.20047-14-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <20171208010842.20047-14-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 8 December 2017 03:08:27 EET Niklas S=F6derlund wrote:
> There was never proper support in the VIN driver to deliver ALTERNATING
> field format to user-space, remove this field option. For sources using
> this field format instead use the VIN hardware feature of combining the
> fields to an interlaced format. This mode of operation was previously
> the default behavior and ALTERNATING was only delivered to user-space if
> explicitly requested. Allowing this to be explicitly requested was a
> mistake and was never properly tested and never worked due to the
> constraints put on the field format when it comes to sequence numbers and
> timestamps etc.

I'm puzzled, why can't we support V4L2_FIELD_ALTERNATE if we can support=20
V4L2_FIELD_TOP and V4L2_FIELD_BOTTOM ? I don't dispute the fact that the=20
currently implemented logic might be wrong (although I haven't double-check=
ed=20
that), but what prevents us from implementing it correctly ?

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
>  drivers/media/platform/rcar-vin/rcar-dma.c  | 15 +--------
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 48 ++++++++++-------------=
=2D--
>  2 files changed, 19 insertions(+), 44 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> 7be5080f742825fb..e6478088d9464221 100644
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
> 9cf9ff48ac1e2f4f..37fe1f6c646b0ea3 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -102,6 +102,24 @@ static int rvin_get_sd_format(struct rvin_dev *vin,
> struct v4l2_pix_format *pix) if (ret)
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
> +		/* Use VIN hardware to combine the two fields */
> +		fmt.format.field =3D V4L2_FIELD_INTERLACED;
> +		fmt.format.height *=3D 2;
> +		break;

I don't think this is right. If V4L2_FIELD_ALTERNATE isn't supported it sho=
uld=20
be rejected in the set format handler, or rather this logic should be moved=
=20
there. It doesn't belong here, rvin_get_sd_format() should only be called w=
ith=20
a validated and supported field.

=46urthermore treating the pix parameter of this function as both input and=
=20
output seems very confusing to me. If you want to extend rvin_get_sd_format=
()=20
beyond just getting the format from the subdev then please document the=20
function with kerneldoc, and let's try to make its API clear.

> +	default:
> +		vin->format.field =3D V4L2_FIELD_NONE;
> +		break;
> +	}
> +
>  	v4l2_fill_pix_format(pix, &fmt.format);
>=20
>  	return 0;
> @@ -115,33 +133,6 @@ static int rvin_reset_format(struct rvin_dev *vin)
>  	if (ret)
>  		return ret;
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
>  	vin->crop.top =3D vin->crop.left =3D 0;
>  	vin->crop.width =3D vin->format.width;
>  	vin->crop.height =3D vin->format.height;
> @@ -226,9 +217,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  	switch (pix->field) {
>  	case V4L2_FIELD_TOP:
>  	case V4L2_FIELD_BOTTOM:
> -	case V4L2_FIELD_ALTERNATE:
> -		pix->height /=3D 2;
> -		break;
>  	case V4L2_FIELD_NONE:
>  	case V4L2_FIELD_INTERLACED_TB:
>  	case V4L2_FIELD_INTERLACED_BT:

=2D-=20
Regards,

Laurent Pinchart
