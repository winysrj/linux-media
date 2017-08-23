Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55408 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753513AbdHWImk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 04:42:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v6 02/25] rcar-vin: register the video device at probe time
Date: Wed, 23 Aug 2017 11:43:09 +0300
Message-ID: <6104719.MxKyBo7YOL@avalon>
In-Reply-To: <20170822232640.26147-3-niklas.soderlund+renesas@ragnatech.se>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se> <20170822232640.26147-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Wednesday, 23 August 2017 02:26:17 EEST Niklas S=F6derlund wrote:
> The driver registers the video device from the async complete callback
> and unregistered in the async unbind callback. This creates problems if
> if the subdevice is bound, unbound and later rebound. The second time
> video_register_device() is called it fails:
>=20
>    kobject (eb3be918): tried to init an initialized object, something is
> seriously wrong.
>=20
> To prevent this register the video device at prob time and don't allow

s/prob/probe/

> user-space to open the video device if the subdevice have not yet been
> bound.

s/have not yet been bound/is not bound yet/

> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 42 +++++++++++++++++++++++=
+--
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 42 ++++-------------------=
=2D--
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  1 +
>  3 files changed, 47 insertions(+), 38 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> 77dff047c41c803e..aefbe8e3ccddb3e4 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -74,6 +74,7 @@ static bool rvin_mbus_supported(struct rvin_graph_entity
> *entity) static int rvin_digital_notify_complete(struct v4l2_async_notifi=
er
> *notifier) {
>  	struct rvin_dev *vin =3D notifier_to_vin(notifier);
> +	struct v4l2_subdev *sd =3D vin_to_source(vin);
>  	int ret;
>=20
>  	/* Verify subdevices mbus format */
> @@ -92,7 +93,35 @@ static int rvin_digital_notify_complete(struct
> v4l2_async_notifier *notifier) return ret;
>  	}
>=20
> -	return rvin_v4l2_probe(vin);
> +	/* Add the controls */
> +	/*
> +	 * Currently the subdev with the largest number of controls (13) is
> +	 * ov6550. So let's pick 16 as a hint for the control handler. Note
> +	 * that this is a hint only: too large and you waste some memory, too
> +	 * small and there is a (very) small performance hit when looking up
> +	 * controls in the internal hash.

No need to copy the help text from the v4l2_ctrl_handler_init() documentati=
on=20
:-)

> +	 */
> +	ret =3D v4l2_ctrl_handler_init(&vin->ctrl_handler, 16);
> +	if (ret < 0)
> +		return ret;

This is racy. You set vdev->ctrl_handler at probe time, but only initialize=
=20
the control handler later. I think it would be better to leave vdev-
>ctrl_handler to NULL and only set it here after initializing the handler. =
You=20
also need proper locking.

> +	ret =3D v4l2_ctrl_add_handler(&vin->ctrl_handler, sd->ctrl_handler, NUL=
L);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret =3D v4l2_subdev_call(sd, video, g_tvnorms, &vin->vdev.tvnorms);
> +	if (ret < 0 && ret !=3D -ENOIOCTLCMD && ret !=3D -ENODEV)
> +		return ret;
> +
> +	if (vin->vdev.tvnorms =3D=3D 0) {
> +		/* Disable the STD API if there are no tvnorms defined */
> +		v4l2_disable_ioctl(&vin->vdev, VIDIOC_G_STD);
> +		v4l2_disable_ioctl(&vin->vdev, VIDIOC_S_STD);
> +		v4l2_disable_ioctl(&vin->vdev, VIDIOC_QUERYSTD);
> +		v4l2_disable_ioctl(&vin->vdev, VIDIOC_ENUMSTD);
> +	}
> +
> +	return rvin_reset_format(vin);
>  }
>=20
>  static void rvin_digital_notify_unbind(struct v4l2_async_notifier
> *notifier, @@ -102,7 +131,7 @@ static void
> rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier, struct
> rvin_dev *vin =3D notifier_to_vin(notifier);
>=20
>  	vin_dbg(vin, "unbind digital subdev %s\n", subdev->name);
> -	rvin_v4l2_remove(vin);
> +	v4l2_ctrl_handler_free(&vin->ctrl_handler);
>  	vin->digital.subdev =3D NULL;

You need locking here too. Nothing prevents an open file handle from issuin=
g a=20
control ioctl after the handler is freed by the subdev unbind.

>  }
>=20
> @@ -231,6 +260,10 @@ static int rvin_digital_graph_init(struct rvin_dev
> *vin) vin->notifier.unbind =3D rvin_digital_notify_unbind;
>  	vin->notifier.complete =3D rvin_digital_notify_complete;
>=20
> +	ret =3D rvin_v4l2_probe(vin);
> +	if (ret)
> +		return ret;

Registering the V4L2 devnodes in the rvin_digital_graph_init() function sou=
nds=20
weird. Maybe you should rename the function ? And while at it, I'd rename=20
rvin_v4l2_probe() to rvin_v4l2_register().

>  	ret =3D v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
>  	if (ret < 0) {
>  		vin_err(vin, "Notifier registration failed\n");
> @@ -314,6 +347,11 @@ static int rcar_vin_remove(struct platform_device
> *pdev)
>=20
>  	v4l2_async_notifier_unregister(&vin->notifier);
>=20
> +	/* Checks internaly if handlers have been init or not */
> +	v4l2_ctrl_handler_free(&vin->ctrl_handler);
> +
> +	rvin_v4l2_remove(vin);
> +
>  	rvin_dma_remove(vin);
>=20
>  	return 0;
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> dd37ea8116804df3..81ff59c3b4744075 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -103,7 +103,7 @@ static void rvin_reset_crop_compose(struct rvin_dev
> *vin) vin->compose.height =3D vin->format.height;
>  }
>=20
> -static int rvin_reset_format(struct rvin_dev *vin)
> +int rvin_reset_format(struct rvin_dev *vin)
>  {
>  	struct v4l2_subdev_format fmt =3D {
>  		.which =3D V4L2_SUBDEV_FORMAT_ACTIVE,
> @@ -781,6 +781,11 @@ static int rvin_open(struct file *file)
>=20
>  	mutex_lock(&vin->lock);
>=20
> +	if (!vin->digital.subdev) {
> +		ret =3D -ENODEV;
> +		goto unlock;
> +	}

This is racy, vin->digital.subdev is set in the bound notifier, while you=20
initialize the control handler in the complete notifier. I would perform=20
initializations in the bound notifier instead of the complete notifier. Ple=
ase=20
make sure you use proper locking.

>  	file->private_data =3D vin;
>=20
>  	ret =3D v4l2_fh_open(file);
> @@ -844,9 +849,6 @@ void rvin_v4l2_remove(struct rvin_dev *vin)
>  	v4l2_info(&vin->v4l2_dev, "Removing %s\n",
>  		  video_device_node_name(&vin->vdev));
>=20
> -	/* Checks internaly if handlers have been init or not */
> -	v4l2_ctrl_handler_free(&vin->ctrl_handler);
> -
>  	/* Checks internaly if vdev have been init or not */
>  	video_unregister_device(&vin->vdev);
>  }
> @@ -869,41 +871,10 @@ static void rvin_notify(struct v4l2_subdev *sd,
>  int rvin_v4l2_probe(struct rvin_dev *vin)
>  {
>  	struct video_device *vdev =3D &vin->vdev;
> -	struct v4l2_subdev *sd =3D vin_to_source(vin);
>  	int ret;
>=20
> -	v4l2_set_subdev_hostdata(sd, vin);
> -
>  	vin->v4l2_dev.notify =3D rvin_notify;
>=20
> -	ret =3D v4l2_subdev_call(sd, video, g_tvnorms, &vin->vdev.tvnorms);
> -	if (ret < 0 && ret !=3D -ENOIOCTLCMD && ret !=3D -ENODEV)
> -		return ret;
> -
> -	if (vin->vdev.tvnorms =3D=3D 0) {
> -		/* Disable the STD API if there are no tvnorms defined */
> -		v4l2_disable_ioctl(&vin->vdev, VIDIOC_G_STD);
> -		v4l2_disable_ioctl(&vin->vdev, VIDIOC_S_STD);
> -		v4l2_disable_ioctl(&vin->vdev, VIDIOC_QUERYSTD);
> -		v4l2_disable_ioctl(&vin->vdev, VIDIOC_ENUMSTD);
> -	}
> -
> -	/* Add the controls */
> -	/*
> -	 * Currently the subdev with the largest number of controls (13) is
> -	 * ov6550. So let's pick 16 as a hint for the control handler. Note
> -	 * that this is a hint only: too large and you waste some memory, too
> -	 * small and there is a (very) small performance hit when looking up
> -	 * controls in the internal hash.
> -	 */
> -	ret =3D v4l2_ctrl_handler_init(&vin->ctrl_handler, 16);
> -	if (ret < 0)
> -		return ret;
> -
> -	ret =3D v4l2_ctrl_add_handler(&vin->ctrl_handler, sd->ctrl_handler, NUL=
L);
> -	if (ret < 0)
> -		return ret;
> -
>  	/* video node */
>  	vdev->fops =3D &rvin_fops;
>  	vdev->v4l2_dev =3D &vin->v4l2_dev;
> @@ -917,7 +888,6 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
>  		V4L2_CAP_READWRITE;
>=20
>  	vin->format.pixelformat	=3D RVIN_DEFAULT_FORMAT;
> -	rvin_reset_format(vin);
>=20
>  	ret =3D video_register_device(&vin->vdev, VFL_TYPE_GRABBER, -1);
>  	if (ret) {


=2D-=20
Regards,

Laurent Pinchart
