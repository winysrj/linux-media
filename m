Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42677 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753610AbeDCVne (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2018 17:43:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v13 22/33] rcar-vin: use different v4l2 operations in media controller mode
Date: Wed, 04 Apr 2018 00:43:42 +0300
Message-ID: <2098288.3zehE2cVqO@avalon>
In-Reply-To: <20180326214456.6655-23-niklas.soderlund+renesas@ragnatech.se>
References: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se> <20180326214456.6655-23-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Tuesday, 27 March 2018 00:44:45 EEST Niklas S=F6derlund wrote:
> When the driver runs in media controller mode it should not directly
> control the subdevice instead userspace will be responsible for
> configuring the pipeline. To be able to run in this mode a different set
> of v4l2 operations needs to be used.
>=20
> Add a new set of v4l2 operations to support operation without directly
> interacting with the source subdevice.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>=20
> ---
>=20
> * Changes since v11
> - Fixed error labels name in rvin_mc_open().
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c  |   2 +-
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 161
> +++++++++++++++++++++++++++- 2 files changed, 159 insertions(+), 4
> deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> 1809f5c0190eafb6..a93772c10baaa003 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -627,7 +627,7 @@ static int rvin_setup(struct rvin_dev *vin)
>  		/* Default to TB */
>  		vnmc =3D VNMC_IM_FULL;
>  		/* Use BT if video standard can be read and is 60 Hz format */
> -		if (vin->std & V4L2_STD_525_60)
> +		if (!vin->info->use_mc && vin->std & V4L2_STD_525_60)
>  			vnmc =3D VNMC_IM_FULL | VNMC_FOC;
>  		break;
>  	case V4L2_FIELD_INTERLACED_TB:
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> dd835be0f9cbcc05..2280535ca981993f 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -18,12 +18,16 @@
>=20
>  #include <media/v4l2-event.h>
>  #include <media/v4l2-ioctl.h>
> +#include <media/v4l2-mc.h>
>  #include <media/v4l2-rect.h>
>=20
>  #include "rcar-vin.h"
>=20
>  #define RVIN_DEFAULT_FORMAT	V4L2_PIX_FMT_YUYV
> +#define RVIN_DEFAULT_WIDTH	800
> +#define RVIN_DEFAULT_HEIGHT	600
>  #define RVIN_DEFAULT_FIELD	V4L2_FIELD_NONE
> +#define RVIN_DEFAULT_COLORSPACE	V4L2_COLORSPACE_SRGB
>=20
>  /*
> -------------------------------------------------------------------------=
=2D-
> -- * Format Conversions
> @@ -656,6 +660,74 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops =
=3D {
>  	.vidioc_unsubscribe_event	=3D v4l2_event_unsubscribe,
>  };
>=20
> +/*
> -------------------------------------------------------------------------=
=2D-
> -- + * V4L2 Media Controller
> + */
> +
> +static int rvin_mc_try_fmt_vid_cap(struct file *file, void *priv,
> +				   struct v4l2_format *f)
> +{
> +	struct rvin_dev *vin =3D video_drvdata(file);
> +
> +	return rvin_format_align(vin, &f->fmt.pix);
> +}
> +
> +static int rvin_mc_s_fmt_vid_cap(struct file *file, void *priv,
> +				 struct v4l2_format *f)
> +{
> +	struct rvin_dev *vin =3D video_drvdata(file);
> +	int ret;
> +
> +	if (vb2_is_busy(&vin->queue))
> +		return -EBUSY;
> +
> +	ret =3D rvin_format_align(vin, &f->fmt.pix);
> +	if (ret)
> +		return ret;
> +
> +	vin->format =3D f->fmt.pix;
> +
> +	return 0;
> +}
> +
> +static int rvin_mc_enum_input(struct file *file, void *priv,
> +			      struct v4l2_input *i)
> +{
> +	if (i->index !=3D 0)
> +		return -EINVAL;
> +
> +	i->type =3D V4L2_INPUT_TYPE_CAMERA;
> +	strlcpy(i->name, "Camera", sizeof(i->name));
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ioctl_ops rvin_mc_ioctl_ops =3D {
> +	.vidioc_querycap		=3D rvin_querycap,
> +	.vidioc_try_fmt_vid_cap		=3D rvin_mc_try_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap		=3D rvin_g_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap		=3D rvin_mc_s_fmt_vid_cap,
> +	.vidioc_enum_fmt_vid_cap	=3D rvin_enum_fmt_vid_cap,
> +
> +	.vidioc_enum_input		=3D rvin_mc_enum_input,
> +	.vidioc_g_input			=3D rvin_g_input,
> +	.vidioc_s_input			=3D rvin_s_input,
> +
> +	.vidioc_reqbufs			=3D vb2_ioctl_reqbufs,
> +	.vidioc_create_bufs		=3D vb2_ioctl_create_bufs,
> +	.vidioc_querybuf		=3D vb2_ioctl_querybuf,
> +	.vidioc_qbuf			=3D vb2_ioctl_qbuf,
> +	.vidioc_dqbuf			=3D vb2_ioctl_dqbuf,
> +	.vidioc_expbuf			=3D vb2_ioctl_expbuf,
> +	.vidioc_prepare_buf		=3D vb2_ioctl_prepare_buf,
> +	.vidioc_streamon		=3D vb2_ioctl_streamon,
> +	.vidioc_streamoff		=3D vb2_ioctl_streamoff,
> +
> +	.vidioc_log_status		=3D v4l2_ctrl_log_status,
> +	.vidioc_subscribe_event		=3D rvin_subscribe_event,
> +	.vidioc_unsubscribe_event	=3D v4l2_event_unsubscribe,
> +};
> +
>  /*
> -------------------------------------------------------------------------=
=2D-
> -- * File Operations
>   */
> @@ -799,6 +871,74 @@ static const struct v4l2_file_operations rvin_fops =
=3D {
>  	.read		=3D vb2_fop_read,
>  };
>=20
> +/*
> -------------------------------------------------------------------------=
=2D-
> -- + * Media controller file operations
> + */
> +
> +static int rvin_mc_open(struct file *file)
> +{
> +	struct rvin_dev *vin =3D video_drvdata(file);
> +	int ret;
> +
> +	ret =3D mutex_lock_interruptible(&vin->lock);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D pm_runtime_get_sync(vin->dev);
> +	if (ret < 0)
> +		goto err_unlock;
> +
> +	ret =3D v4l2_pipeline_pm_use(&vin->vdev.entity, 1);
> +	if (ret < 0)
> +		goto err_pm;
> +
> +	file->private_data =3D vin;
> +
> +	ret =3D v4l2_fh_open(file);
> +	if (ret)
> +		goto err_v4l2pm;
> +
> +	mutex_unlock(&vin->lock);
> +
> +	return 0;
> +err_v4l2pm:
> +	v4l2_pipeline_pm_use(&vin->vdev.entity, 0);
> +err_pm:
> +	pm_runtime_put(vin->dev);
> +err_unlock:
> +	mutex_unlock(&vin->lock);
> +
> +	return ret;
> +}
> +
> +static int rvin_mc_release(struct file *file)
> +{
> +	struct rvin_dev *vin =3D video_drvdata(file);
> +	int ret;
> +
> +	mutex_lock(&vin->lock);
> +
> +	/* the release helper will cleanup any on-going streaming. */
> +	ret =3D _vb2_fop_release(file, NULL);
> +
> +	v4l2_pipeline_pm_use(&vin->vdev.entity, 0);
> +	pm_runtime_put(vin->dev);
> +
> +	mutex_unlock(&vin->lock);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_file_operations rvin_mc_fops =3D {
> +	.owner		=3D THIS_MODULE,
> +	.unlocked_ioctl	=3D video_ioctl2,
> +	.open		=3D rvin_mc_open,
> +	.release	=3D rvin_mc_release,
> +	.poll		=3D vb2_fop_poll,
> +	.mmap		=3D vb2_fop_mmap,
> +	.read		=3D vb2_fop_read,
> +};
> +
>  void rvin_v4l2_unregister(struct rvin_dev *vin)
>  {
>  	if (!video_is_registered(&vin->vdev))
> @@ -834,18 +974,33 @@ int rvin_v4l2_register(struct rvin_dev *vin)
>  	vin->v4l2_dev.notify =3D rvin_notify;
>=20
>  	/* video node */
> -	vdev->fops =3D &rvin_fops;
>  	vdev->v4l2_dev =3D &vin->v4l2_dev;
>  	vdev->queue =3D &vin->queue;
>  	strlcpy(vdev->name, KBUILD_MODNAME, sizeof(vdev->name));
>  	vdev->release =3D video_device_release_empty;
> -	vdev->ioctl_ops =3D &rvin_ioctl_ops;
>  	vdev->lock =3D &vin->lock;
>  	vdev->device_caps =3D V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
>  		V4L2_CAP_READWRITE;
>=20
> +	/* Set a default format */
>  	vin->format.pixelformat	=3D RVIN_DEFAULT_FORMAT;
> -	rvin_reset_format(vin);
> +	vin->format.width =3D RVIN_DEFAULT_WIDTH;
> +	vin->format.height =3D RVIN_DEFAULT_HEIGHT;
> +	vin->format.field =3D RVIN_DEFAULT_FIELD;
> +	vin->format.colorspace =3D RVIN_DEFAULT_COLORSPACE;
> +
> +	if (vin->info->use_mc) {
> +		vdev->fops =3D &rvin_mc_fops;
> +		vdev->ioctl_ops =3D &rvin_mc_ioctl_ops;
> +	} else {
> +		vdev->fops =3D &rvin_fops;
> +		vdev->ioctl_ops =3D &rvin_ioctl_ops;
> +		rvin_reset_format(vin);
> +	}
> +
> +	ret =3D rvin_format_align(vin, &vin->format);
> +	if (ret)
> +		return ret;
>=20
>  	ret =3D video_register_device(&vin->vdev, VFL_TYPE_GRABBER, -1);
>  	if (ret) {


=2D-=20
Regards,

Laurent Pinchart
