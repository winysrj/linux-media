Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44127 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933774AbeBMPqu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 10:46:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 04/30] rcar-vin: move subdevice handling to async callbacks
Date: Tue, 13 Feb 2018 17:47:21 +0200
Message-ID: <3353710.u2zpV3FslG@avalon>
In-Reply-To: <20180129163435.24936-5-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se> <20180129163435.24936-5-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Monday, 29 January 2018 18:34:09 EET Niklas S=F6derlund wrote:
> In preparation for Gen3 support move the subdevice initialization and
> clean up from rvin_v4l2_{register,unregister}() directly to the async
> callbacks. This simplifies the addition of Gen3 support as the
> rvin_v4l2_register() can be shared for both Gen2 and Gen3 while direct
> subdevice control are only used on Gen2.
>=20
> While moving this code drop a large comment which is copied from the
> framework documentation and fold rvin_mbus_supported() into its only
> caller. Also move the initialization and cleanup code to separate
> functions to increase readability.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 108 ++++++++++++++++++----=
=2D-
>  drivers/media/platform/rcar-vin/rcar-v4l2.c |  35 ---------
>  2 files changed, 74 insertions(+), 69 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> 47f06acde2e698f2..663309ca9c04f208 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -46,46 +46,88 @@ static int rvin_find_pad(struct v4l2_subdev *sd, int
> direction) return -EINVAL;
>  }
>=20
> -static bool rvin_mbus_supported(struct rvin_graph_entity *entity)
> +/* The vin lock shuld be held when calling the subdevice attach and deta=
ch
> */ +static int rvin_digital_subdevice_attach(struct rvin_dev *vin,
> +					 struct v4l2_subdev *subdev)
>  {
> -	struct v4l2_subdev *sd =3D entity->subdev;
>  	struct v4l2_subdev_mbus_code_enum code =3D {
>  		.which =3D V4L2_SUBDEV_FORMAT_ACTIVE,
>  	};
> +	int ret;
>=20
> +	/* Find source and sink pad of remote subdevice */
> +	ret =3D rvin_find_pad(subdev, MEDIA_PAD_FL_SOURCE);
> +	if (ret < 0)
> +		return ret;
> +	vin->digital->source_pad =3D ret;
> +
> +	ret =3D rvin_find_pad(subdev, MEDIA_PAD_FL_SINK);
> +	vin->digital->sink_pad =3D ret < 0 ? 0 : ret;
> +
> +	/* Find compatible subdevices mbus format */
> +	vin->digital->code =3D 0;
>  	code.index =3D 0;
> -	code.pad =3D entity->source_pad;
> -	while (!v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code)) {
> +	code.pad =3D vin->digital->source_pad;
> +	while (!vin->digital->code &&
> +	       !v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL, &code)) {
>  		code.index++;
>  		switch (code.code) {
>  		case MEDIA_BUS_FMT_YUYV8_1X16:
>  		case MEDIA_BUS_FMT_UYVY8_2X8:
>  		case MEDIA_BUS_FMT_UYVY10_2X10:
>  		case MEDIA_BUS_FMT_RGB888_1X24:
> -			entity->code =3D code.code;
> -			return true;
> +			vin->digital->code =3D code.code;
> +			vin_dbg(vin, "Found media bus format for %s: %d\n",
> +				subdev->name, vin->digital->code);
> +			break;
>  		default:
>  			break;
>  		}
>  	}
>=20
> -	return false;
> -}
> -
> -static int rvin_digital_notify_complete(struct v4l2_async_notifier
> *notifier) -{
> -	struct rvin_dev *vin =3D notifier_to_vin(notifier);
> -	int ret;
> -
> -	/* Verify subdevices mbus format */
> -	if (!rvin_mbus_supported(vin->digital)) {
> +	if (!vin->digital->code) {
>  		vin_err(vin, "Unsupported media bus format for %s\n",
> -			vin->digital->subdev->name);
> +			subdev->name);
>  		return -EINVAL;
>  	}
>=20
> -	vin_dbg(vin, "Found media bus format for %s: %d\n",
> -		vin->digital->subdev->name, vin->digital->code);
> +	/* Read tvnorms */
> +	ret =3D v4l2_subdev_call(subdev, video, g_tvnorms, &vin->vdev.tvnorms);
> +	if (ret < 0 && ret !=3D -ENOIOCTLCMD && ret !=3D -ENODEV)
> +		return ret;
> +
> +	/* Add the controls */
> +	ret =3D v4l2_ctrl_handler_init(&vin->ctrl_handler, 16);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret =3D v4l2_ctrl_add_handler(&vin->ctrl_handler, subdev->ctrl_handler,
> +				    NULL);
> +	if (ret < 0) {
> +		v4l2_ctrl_handler_free(&vin->ctrl_handler);
> +		return ret;
> +	}
> +
> +	vin->vdev.ctrl_handler =3D &vin->ctrl_handler;
> +
> +	vin->digital->subdev =3D subdev;
> +
> +	return 0;
> +}
> +
> +static void rvin_digital_subdevice_detach(struct rvin_dev *vin)
> +{
> +	rvin_v4l2_unregister(vin);
> +	v4l2_ctrl_handler_free(&vin->ctrl_handler);
> +
> +	vin->vdev.ctrl_handler =3D NULL;
> +	vin->digital->subdev =3D NULL;
> +}
> +
> +static int rvin_digital_notify_complete(struct v4l2_async_notifier
> *notifier) +{
> +	struct rvin_dev *vin =3D notifier_to_vin(notifier);
> +	int ret;
>=20
>  	ret =3D v4l2_device_register_subdev_nodes(&vin->v4l2_dev);
>  	if (ret < 0) {
> @@ -103,8 +145,10 @@ static void rvin_digital_notify_unbind(struct
> v4l2_async_notifier *notifier, struct rvin_dev *vin =3D
> notifier_to_vin(notifier);
>=20
>  	vin_dbg(vin, "unbind digital subdev %s\n", subdev->name);
> -	rvin_v4l2_unregister(vin);
> -	vin->digital->subdev =3D NULL;
> +
> +	mutex_lock(&vin->lock);
> +	rvin_digital_subdevice_detach(vin);
> +	mutex_unlock(&vin->lock);
>  }
>=20
>  static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifie=
r,
> @@ -114,33 +158,27 @@ static int rvin_digital_notify_bound(struct
> v4l2_async_notifier *notifier, struct rvin_dev *vin =3D
> notifier_to_vin(notifier);
>  	int ret;
>=20
> +	mutex_lock(&vin->lock);
> +	ret =3D rvin_digital_subdevice_attach(vin, subdev);
> +	mutex_unlock(&vin->lock);
> +	if (ret)
> +		return ret;
> +
>  	v4l2_set_subdev_hostdata(subdev, vin);
>=20
> -	/* Find source and sink pad of remote subdevice */
> -
> -	ret =3D rvin_find_pad(subdev, MEDIA_PAD_FL_SOURCE);
> -	if (ret < 0)
> -		return ret;
> -	vin->digital->source_pad =3D ret;
> -
> -	ret =3D rvin_find_pad(subdev, MEDIA_PAD_FL_SINK);
> -	vin->digital->sink_pad =3D ret < 0 ? 0 : ret;
> -
> -	vin->digital->subdev =3D subdev;
> -
>  	vin_dbg(vin, "bound subdev %s source pad: %u sink pad: %u\n",
>  		subdev->name, vin->digital->source_pad,
>  		vin->digital->sink_pad);
>=20
>  	return 0;
>  }
> +
>  static const struct v4l2_async_notifier_operations rvin_digital_notify_o=
ps
> =3D { .bound =3D rvin_digital_notify_bound,
>  	.unbind =3D rvin_digital_notify_unbind,
>  	.complete =3D rvin_digital_notify_complete,
>  };
>=20
> -
>  static int rvin_digital_parse_v4l2(struct device *dev,
>  				   struct v4l2_fwnode_endpoint *vep,
>  				   struct v4l2_async_subdev *asd)
> @@ -277,6 +315,8 @@ static int rcar_vin_remove(struct platform_device *pd=
ev)
> v4l2_async_notifier_unregister(&vin->notifier);
>  	v4l2_async_notifier_cleanup(&vin->notifier);
>=20
> +	v4l2_ctrl_handler_free(&vin->ctrl_handler);
> +
>  	rvin_dma_unregister(vin);
>=20
>  	return 0;
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 32a658214f48fa49..4a0610a6b4503501 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -847,9 +847,6 @@ void rvin_v4l2_unregister(struct rvin_dev *vin)
>  	v4l2_info(&vin->v4l2_dev, "Removing %s\n",
>  		  video_device_node_name(&vin->vdev));
>=20
> -	/* Checks internaly if handlers have been init or not */
> -	v4l2_ctrl_handler_free(&vin->ctrl_handler);
> -
>  	/* Checks internaly if vdev have been init or not */
>  	video_unregister_device(&vin->vdev);
>  }
> @@ -872,41 +869,10 @@ static void rvin_notify(struct v4l2_subdev *sd,
>  int rvin_v4l2_register(struct rvin_dev *vin)
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
> @@ -915,7 +881,6 @@ int rvin_v4l2_register(struct rvin_dev *vin)
>  	vdev->release =3D video_device_release_empty;
>  	vdev->ioctl_ops =3D &rvin_ioctl_ops;
>  	vdev->lock =3D &vin->lock;
> -	vdev->ctrl_handler =3D &vin->ctrl_handler;
>  	vdev->device_caps =3D V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
>  		V4L2_CAP_READWRITE;


=2D-=20
Regards,

Laurent Pinchart
