Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58553 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751419AbdEJNgD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 09:36:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 14/16] rcar-vin: make use of video_device_alloc() and video_device_release()
Date: Wed, 10 May 2017 16:36:03 +0300
Message-ID: <2171480.vKAhxxIE6q@avalon>
In-Reply-To: <20170314185957.25253-15-niklas.soderlund+renesas@ragnatech.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se> <20170314185957.25253-15-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Tuesday 14 Mar 2017 19:59:55 Niklas S=F6derlund wrote:
> Make use of the helper functions video_device_alloc() and
> video_device_release() to control the lifetime of the struct
> video_device.

It's nice to see you considering lifetime management issues, but this i=
sn't=20
enough. The rvin_release() function accesses the rvin_dev structure, so=
 you=20
need to keep this around until all references to the video device have =
been=20
dropped. This patch won't do so.

I would instead keep the video_device instance embedded in rvin_dev, an=
d=20
implement a custom release handler that will kfree() the rvin_dev insta=
nce.=20
You will obviously need to replace devm_kzalloc() with kzalloc() to all=
ocate=20
the rvin_dev.

> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 44 ++++++++++++++-----=
-------
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  2 +-
>  2 files changed, 25 insertions(+), 21 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> be6f41bf82ac3bc5..c40f5bc3e3d26472 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -489,7 +489,7 @@ static int rvin_enum_input(struct file *file, voi=
d
> *priv, i->std =3D 0;
>  =09} else {
>  =09=09i->capabilities =3D V4L2_IN_CAP_STD;
> -=09=09i->std =3D vin->vdev.tvnorms;
> +=09=09i->std =3D vin->vdev->tvnorms;
>  =09}
>=20
>  =09strlcpy(i->name, "Camera", sizeof(i->name));
> @@ -752,8 +752,8 @@ static int rvin_initialize_device(struct file *fi=
le)
>  =09if (ret < 0)
>  =09=09return ret;
>=20
> -=09pm_runtime_enable(&vin->vdev.dev);
> -=09ret =3D pm_runtime_resume(&vin->vdev.dev);
> +=09pm_runtime_enable(&vin->vdev->dev);
> +=09ret =3D pm_runtime_resume(&vin->vdev->dev);
>  =09if (ret < 0 && ret !=3D -ENOSYS)
>  =09=09goto eresume;
>=20
> @@ -771,7 +771,7 @@ static int rvin_initialize_device(struct file *fi=
le)
>=20
>  =09return 0;
>  esfmt:
> -=09pm_runtime_disable(&vin->vdev.dev);
> +=09pm_runtime_disable(&vin->vdev->dev);
>  eresume:
>  =09rvin_power_off(vin);
>=20
> @@ -823,8 +823,8 @@ static int rvin_release(struct file *file)
>  =09 * Then de-initialize hw module.
>  =09 */
>  =09if (fh_singular) {
> -=09=09pm_runtime_suspend(&vin->vdev.dev);
> -=09=09pm_runtime_disable(&vin->vdev.dev);
> +=09=09pm_runtime_suspend(&vin->vdev->dev);
> +=09=09pm_runtime_disable(&vin->vdev->dev);
>  =09=09rvin_power_off(vin);
>  =09}
>=20
> @@ -846,13 +846,13 @@ static const struct v4l2_file_operations rvin_f=
ops =3D {
> void rvin_v4l2_remove(struct rvin_dev *vin)
>  {
>  =09v4l2_info(&vin->v4l2_dev, "Removing %s\n",
> -=09=09  video_device_node_name(&vin->vdev));
> +=09=09  video_device_node_name(vin->vdev));
>=20
>  =09/* Checks internaly if handlers have been init or not */
>  =09v4l2_ctrl_handler_free(&vin->ctrl_handler);
>=20
>  =09/* Checks internaly if vdev have been init or not */
> -=09video_unregister_device(&vin->vdev);
> +=09video_unregister_device(vin->vdev);
>  }
>=20
>  static void rvin_notify(struct v4l2_subdev *sd,
> @@ -863,7 +863,7 @@ static void rvin_notify(struct v4l2_subdev *sd,
>=20
>  =09switch (notification) {
>  =09case V4L2_DEVICE_NOTIFY_EVENT:
> -=09=09v4l2_event_queue(&vin->vdev, arg);
> +=09=09v4l2_event_queue(vin->vdev, arg);
>  =09=09break;
>  =09default:
>  =09=09break;
> @@ -872,7 +872,7 @@ static void rvin_notify(struct v4l2_subdev *sd,
>=20
>  int rvin_v4l2_probe(struct rvin_dev *vin)
>  {
> -=09struct video_device *vdev =3D &vin->vdev;
> +=09struct video_device *vdev;
>  =09struct v4l2_subdev *sd =3D vin_to_source(vin);
>  =09int ret;
>=20
> @@ -880,16 +880,18 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
>=20
>  =09vin->v4l2_dev.notify =3D rvin_notify;
>=20
> -=09ret =3D v4l2_subdev_call(sd, video, g_tvnorms, &vin->vdev.tvnorms=
);
> +=09vdev =3D video_device_alloc();
> +
> +=09ret =3D v4l2_subdev_call(sd, video, g_tvnorms, &vdev->tvnorms);
>  =09if (ret < 0 && ret !=3D -ENOIOCTLCMD && ret !=3D -ENODEV)
>  =09=09return ret;
>=20
> -=09if (vin->vdev.tvnorms =3D=3D 0) {
> +=09if (vdev->tvnorms =3D=3D 0) {
>  =09=09/* Disable the STD API if there are no tvnorms defined */
> -=09=09v4l2_disable_ioctl(&vin->vdev, VIDIOC_G_STD);
> -=09=09v4l2_disable_ioctl(&vin->vdev, VIDIOC_S_STD);
> -=09=09v4l2_disable_ioctl(&vin->vdev, VIDIOC_QUERYSTD);
> -=09=09v4l2_disable_ioctl(&vin->vdev, VIDIOC_ENUMSTD);
> +=09=09v4l2_disable_ioctl(vdev, VIDIOC_G_STD);
> +=09=09v4l2_disable_ioctl(vdev, VIDIOC_S_STD);
> +=09=09v4l2_disable_ioctl(vdev, VIDIOC_QUERYSTD);
> +=09=09v4l2_disable_ioctl(vdev, VIDIOC_ENUMSTD);
>  =09}
>=20
>  =09/* Add the controls */
> @@ -913,7 +915,7 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
>  =09vdev->v4l2_dev =3D &vin->v4l2_dev;
>  =09vdev->queue =3D &vin->queue;
>  =09strlcpy(vdev->name, KBUILD_MODNAME, sizeof(vdev->name));
> -=09vdev->release =3D video_device_release_empty;
> +=09vdev->release =3D video_device_release;
>  =09vdev->ioctl_ops =3D &rvin_ioctl_ops;
>  =09vdev->lock =3D &vin->lock;
>  =09vdev->ctrl_handler =3D &vin->ctrl_handler;
> @@ -923,16 +925,18 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
>  =09vin->format.pixelformat=09=3D RVIN_DEFAULT_FORMAT;
>  =09rvin_reset_format(vin);
>=20
> -=09ret =3D video_register_device(&vin->vdev, VFL_TYPE_GRABBER, -1);
> +=09ret =3D video_register_device(vdev, VFL_TYPE_GRABBER, -1);
>  =09if (ret) {
>  =09=09vin_err(vin, "Failed to register video device\n");
>  =09=09return ret;
>  =09}
>=20
> -=09video_set_drvdata(&vin->vdev, vin);
> +=09video_set_drvdata(vdev, vin);
>=20
>  =09v4l2_info(&vin->v4l2_dev, "Device registered as %s\n",
> -=09=09  video_device_node_name(&vin->vdev));
> +=09=09  video_device_node_name(vdev));
> +
> +=09vin->vdev =3D vdev;
>=20
>  =09return ret;
>  }
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> 9bfb5a7c4dc4f215..9454ef80bc2b3961 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -122,7 +122,7 @@ struct rvin_dev {
>  =09void __iomem *base;
>  =09enum chip_id chip;
>=20
> -=09struct video_device vdev;
> +=09struct video_device *vdev;
>  =09struct v4l2_device v4l2_dev;
>  =09struct v4l2_ctrl_handler ctrl_handler;
>  =09struct v4l2_async_notifier notifier;

--=20
Regards,

Laurent Pinchart
