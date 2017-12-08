Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52256 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbdLHUpn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 15:45:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 25/28] rcar-vin: extend {start,stop}_streaming to work with media controller
Date: Fri, 08 Dec 2017 22:45:41 +0200
Message-ID: <9062233.viFt96TuT9@avalon>
In-Reply-To: <20171208010842.20047-26-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <20171208010842.20047-26-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 8 December 2017 03:08:39 EET Niklas S=F6derlund wrote:
> The procedure to start or stop streaming using the non-MC single
> subdevice and the MC graph and multiple subdevices are quite different.
> Create a new function to abstract which method is used based on which
> mode the driver is running in and add logic to start the MC graph.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 112 +++++++++++++++++++++++=
+--
>  1 file changed, 105 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> 6c5df13b30d6dd14..8a6674a891aab357 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -1087,15 +1087,115 @@ static void rvin_buffer_queue(struct vb2_buffer
> *vb) spin_unlock_irqrestore(&vin->qlock, flags);
>  }
>=20
> +static int rvin_set_stream(struct rvin_dev *vin, int on)
> +{
> +	struct v4l2_subdev_format fmt =3D {
> +		.which =3D V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +	struct media_pipeline *pipe;
> +	struct  v4l2_subdev *sd;
> +	struct media_pad *pad;
> +	int ret;
> +
> +	/* No media controller used, simply pass operation to subdevice */
> +	if (!vin->info->use_mc) {
> +		ret =3D v4l2_subdev_call(vin->digital->subdev, video, s_stream,
> +				       on);
> +
> +		return ret =3D=3D -ENOIOCTLCMD ? 0 : ret;
> +	}
> +
> +	pad =3D media_entity_remote_pad(&vin->pad);
> +	if (!pad)
> +		return -EPIPE;
> +
> +	sd =3D media_entity_to_v4l2_subdev(pad->entity);
> +	if (!sd)
> +		return -EPIPE;

Can a pad have no entity ?

> +	if (!on) {
> +		media_pipeline_stop(&vin->vdev.entity);
> +		return v4l2_subdev_call(sd, video, s_stream, 0);
> +	}
> +
> +	fmt.pad =3D pad->index;
> +	if (v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt))
> +		return -EPIPE;
> +
> +	switch (fmt.format.code) {
> +	case MEDIA_BUS_FMT_YUYV8_1X16:
> +	case MEDIA_BUS_FMT_UYVY8_2X8:
> +	case MEDIA_BUS_FMT_UYVY10_2X10:
> +	case MEDIA_BUS_FMT_RGB888_1X24:
> +		vin->code =3D fmt.format.code;
> +		break;
> +	default:
> +		return -EPIPE;
> +	}
> +
> +	switch (fmt.format.field) {
> +	case V4L2_FIELD_TOP:
> +	case V4L2_FIELD_BOTTOM:
> +	case V4L2_FIELD_NONE:
> +	case V4L2_FIELD_INTERLACED_TB:
> +	case V4L2_FIELD_INTERLACED_BT:
> +	case V4L2_FIELD_INTERLACED:
> +	case V4L2_FIELD_SEQ_TB:
> +	case V4L2_FIELD_SEQ_BT:
> +		/* Supported natively */
> +		break;
> +	case V4L2_FIELD_ALTERNATE:
> +		switch (vin->format.field) {
> +		case V4L2_FIELD_TOP:
> +		case V4L2_FIELD_BOTTOM:
> +		case V4L2_FIELD_NONE:
> +			break;
> +		case V4L2_FIELD_INTERLACED_TB:
> +		case V4L2_FIELD_INTERLACED_BT:
> +		case V4L2_FIELD_INTERLACED:
> +		case V4L2_FIELD_SEQ_TB:
> +		case V4L2_FIELD_SEQ_BT:
> +			/* Use VIN hardware to combine the two fields */
> +			fmt.format.height *=3D 2;
> +			break;
> +		default:
> +			return -EPIPE;
> +		}
> +		break;
> +	default:
> +		return -EPIPE;
> +	}
> +
> +	if (fmt.format.width !=3D vin->format.width ||
> +	    fmt.format.height !=3D vin->format.height)
> +		return -EPIPE;

Shouldn't you also validate the media bus pixel code against the pixel form=
at=20
?

> +	pipe =3D sd->entity.pipe ? sd->entity.pipe : &vin->vdev.pipe;

How is this protected against race conditions if you call VIDIOC_STREAMON o=
n=20
two VIN instances connected to the same CSI-2 receiver ?

And how does this handle two VIN instances connected to two different CSI-2=
=20
receivers that are both connected to the same source ? We will use two=20
different pipeline objects, is that a problem ?

> +	if (media_pipeline_start(&vin->vdev.entity, pipe))
> +		return -EPIPE;
> +
> +	ret =3D v4l2_subdev_call(sd, video, s_stream, 1);
> +	if (ret =3D=3D -ENOIOCTLCMD)
> +		ret =3D 0;
> +	if (ret)
> +		media_pipeline_stop(&vin->vdev.entity);
> +
> +	return ret;
> +}
> +
>  static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
>  {
>  	struct rvin_dev *vin =3D vb2_get_drv_priv(vq);
> -	struct v4l2_subdev *sd;
>  	unsigned long flags;
>  	int ret;
>=20
> -	sd =3D vin_to_source(vin);
> -	v4l2_subdev_call(sd, video, s_stream, 1);
> +	ret =3D rvin_set_stream(vin, 1);
> +	if (ret) {
> +		spin_lock_irqsave(&vin->qlock, flags);
> +		return_all_buffers(vin, VB2_BUF_STATE_QUEUED);
> +		spin_unlock_irqrestore(&vin->qlock, flags);
> +		return ret;
> +	}
>=20
>  	spin_lock_irqsave(&vin->qlock, flags);
>=20
> @@ -1104,7 +1204,7 @@ static int rvin_start_streaming(struct vb2_queue *v=
q,
> unsigned int count) ret =3D rvin_capture_start(vin);
>  	if (ret) {
>  		return_all_buffers(vin, VB2_BUF_STATE_QUEUED);
> -		v4l2_subdev_call(sd, video, s_stream, 0);
> +		rvin_set_stream(vin, 0);
>  	}
>=20
>  	spin_unlock_irqrestore(&vin->qlock, flags);
> @@ -1115,7 +1215,6 @@ static int rvin_start_streaming(struct vb2_queue *v=
q,
> unsigned int count) static void rvin_stop_streaming(struct vb2_queue *vq)
>  {
>  	struct rvin_dev *vin =3D vb2_get_drv_priv(vq);
> -	struct v4l2_subdev *sd;
>  	unsigned long flags;
>  	int retries =3D 0;
>=20
> @@ -1154,8 +1253,7 @@ static void rvin_stop_streaming(struct vb2_queue *v=
q)
>=20
>  	spin_unlock_irqrestore(&vin->qlock, flags);
>=20
> -	sd =3D vin_to_source(vin);
> -	v4l2_subdev_call(sd, video, s_stream, 0);
> +	rvin_set_stream(vin, 0);
>=20
>  	/* disable interrupts */
>  	rvin_disable_interrupts(vin);

=2D-=20
Regards,

Laurent Pinchart
