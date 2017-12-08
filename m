Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47419 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752488AbdLHKNs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 05:13:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 19/28] rcar-vin: use different v4l2 operations in media controller mode
Date: Fri, 08 Dec 2017 12:14:05 +0200
Message-ID: <4037381.ip89KhYXee@avalon>
In-Reply-To: <20171208010842.20047-20-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <20171208010842.20047-20-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 8 December 2017 03:08:33 EET Niklas S=F6derlund wrote:
> When the driver runs in media controller mode it should not directly
> control the subdevice instead userspace will be responsible for
> configuring the pipeline. To be able to run in this mode a different set
> of v4l2 operations needs to be used.
>=20
> Add a new set of v4l2 operations to support the running without directly

Maybe s/the running/operation/ ?

> interacting with the source subdevice.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c  |   3 +-
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 155 ++++++++++++++++++++++=
++-
>  drivers/media/platform/rcar-vin/rcar-vin.h  |   1 +
>  3 files changed, 155 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> d2788d8bb9565aaa..6c5df13b30d6dd14 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -628,7 +628,8 @@ static int rvin_setup(struct rvin_dev *vin)
>  		/* Default to TB */
>  		vnmc =3D VNMC_IM_FULL;
>  		/* Use BT if video standard can be read and is 60 Hz format */
> -		if (!v4l2_subdev_call(vin_to_source(vin), video, g_std, &std)) {
> +		if (!vin->info->use_mc &&
> +		    !v4l2_subdev_call(vin_to_source(vin), video, g_std, &std)) {
>  			if (std & V4L2_STD_525_60)
>  				vnmc =3D VNMC_IM_FULL | VNMC_FOC;
>  		}

I think the subdev should be queried in rcar-v4l2.c and the information cac=
hed=20
in the rvin_dev structure instead of queried here. Interactions with the=20
subdev should be minimized in rvin-dma.c. You can fix this in a separate pa=
tch=20
if you prefer.

> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 0ffbf0c16fb7b00e..5fea2856fd61030f 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -23,6 +23,9 @@
>  #include "rcar-vin.h"
>=20
>  #define RVIN_DEFAULT_FORMAT	V4L2_PIX_FMT_YUYV
> +#define RVIN_DEFAULT_WIDTH	800
> +#define RVIN_DEFAULT_HEIGHT	600
> +#define RVIN_DEFAULT_COLORSPACE	V4L2_COLORSPACE_SRGB
>=20
>  /* ---------------------------------------------------------------------=
=2D--
>   * Format Conversions
> @@ -671,6 +674,84 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops =
=3D {
>  	.vidioc_unsubscribe_event	=3D v4l2_event_unsubscribe,
>  };
>=20
> +/* ---------------------------------------------------------------------=
=2D--
>   + * V4L2 Media Controller
> + */
> +
> +static int __rvin_mc_try_format(struct rvin_dev *vin,
> +				struct v4l2_pix_format *pix)
> +{
> +	/* Keep current field if no specific one is asked for */
> +	if (pix->field =3D=3D V4L2_FIELD_ANY)
> +		pix->field =3D vin->format.field;

You should set a default value instead, trying a format should return the s=
ame=20
result regardless of the current state of the device.

> +	return rvin_format_align(vin, pix);
> +}
> +
> +static int rvin_mc_try_fmt_vid_cap(struct file *file, void *priv,
> +				   struct v4l2_format *f)
> +{
> +	struct rvin_dev *vin =3D video_drvdata(file);
> +
> +	return __rvin_mc_try_format(vin, &f->fmt.pix);
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
> +	ret =3D __rvin_mc_try_format(vin, &f->fmt.pix);
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
> +=20
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

The input API makes no sense for MC-based devices.

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
>  /* ---------------------------------------------------------------------=
=2D--
>   * File Operations
>   */
> @@ -814,6 +895,60 @@ static const struct v4l2_file_operations rvin_fops =
=3D {
>  	.read		=3D vb2_fop_read,
>  };
>=20
> +/* ---------------------------------------------------------------------=
=2D--
> + * Media controller file Operations

I'm personally fine with capitalizing all words in a title, or only the fir=
st=20
one, but I don't see a reason to capitalize the first and last only :-)

> + */
> +
> +static int rvin_mc_open(struct file *file)
> +{
> +	struct rvin_dev *vin =3D video_drvdata(file);
> +	int ret;
> +
> +	mutex_lock(&vin->lock);
> +
> +	file->private_data =3D vin;
> +
> +	ret =3D v4l2_fh_open(file);
> +	if (ret)
> +		goto unlock;
> +
> +	pm_runtime_get_sync(vin->dev);

Can't this function return an error ?

> +	v4l2_pipeline_pm_use(&vin->vdev.entity, 1);
> +
> +unlock:
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
> +	/* the release helper will cleanup any on-going streaming */
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
> @@ -849,19 +984,33 @@ int rvin_v4l2_register(struct rvin_dev *vin)
>  	vin->v4l2_dev.notify =3D rvin_notify;
>=20
>  	/* video node */
> -	vdev->fops =3D &rvin_fops;
>  	vdev->v4l2_dev =3D &vin->v4l2_dev;
>  	vdev->queue =3D &vin->queue;
>  	snprintf(vdev->name, sizeof(vdev->name), "%s %s", KBUILD_MODNAME,
>  		 dev_name(vin->dev));
>  	vdev->release =3D video_device_release_empty;
> -	vdev->ioctl_ops =3D &rvin_ioctl_ops;
>  	vdev->lock =3D &vin->lock;
>  	vdev->device_caps =3D V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
>  		V4L2_CAP_READWRITE;
>=20
> +	/* Set some form of default format */

"Some form of" ? :-)

>  	vin->format.pixelformat	=3D RVIN_DEFAULT_FORMAT;
> -	rvin_reset_format(vin);
> +	vin->format.width =3D RVIN_DEFAULT_WIDTH;
> +	vin->format.height =3D RVIN_DEFAULT_HEIGHT;
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
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> 0747873c2b9cb74c..fd3cd781be0ab1cf 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -21,6 +21,7 @@
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-device.h>
> +#include <media/v4l2-mc.h>

Can't you include this header in the .c files instead ? Minimizing the head=
ers=20
included by other headers lowers (pre)compilation time.

>  #include <media/videobuf2-v4l2.h>
>=20
>  /* Number of HW buffers */

=2D-=20
Regards,

Laurent Pinchart
