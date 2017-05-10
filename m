Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58473 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753029AbdEJNZL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 09:25:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 07/16] rcar-vin: move pad lookup to async bound handler
Date: Wed, 10 May 2017 16:25 +0300
Message-ID: <2997341.MYY7UBqxJ7@avalon>
In-Reply-To: <20170314185957.25253-8-niklas.soderlund+renesas@ragnatech.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se> <20170314185957.25253-8-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Tuesday 14 Mar 2017 19:59:48 Niklas S=F6derlund wrote:
> Information about pads will be needed when enumerating the media bus
> codes in the async complete handler which is run before
> rvin_v4l2_probe(). Move the pad lookup to the async bound handler so
> they are available when needed.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
.se>
> ---
> drivers/media/platform/rcar-vin/rcar-core.c | 32 ++++++++++++++++++++=
+++++-
> drivers/media/platform/rcar-vin/rcar-v4l2.c | 24 --------------------=
--
> 2 files changed, 31 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> 098a0b1cc10a26ba..d7aba15f6761259b 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -31,6 +31,20 @@
>=20
>  #define notifier_to_vin(n) container_of(n, struct rvin_dev, notifier=
)
>=20
> +static int rvin_find_pad(struct v4l2_subdev *sd, int direction)
> +{
> +=09unsigned int pad;
> +
> +=09if (sd->entity.num_pads <=3D 1)
> +=09=09return 0;
> +
> +=09for (pad =3D 0; pad < sd->entity.num_pads; pad++)
> +=09=09if (sd->entity.pads[pad].flags & direction)
> +=09=09=09return pad;
> +
> +=09return -EINVAL;
> +}
> +
>  static bool rvin_mbus_supported(struct rvin_graph_entity *entity)
>  {
>  =09struct v4l2_subdev *sd =3D entity->subdev;
> @@ -101,12 +115,28 @@ static int rvin_digital_notify_bound(struct
> v4l2_async_notifier *notifier, struct v4l2_async_subdev *asd)
>  {
>  =09struct rvin_dev *vin =3D notifier_to_vin(notifier);
> +=09int ret;
>=20
>  =09v4l2_set_subdev_hostdata(subdev, vin);
>=20
>  =09if (vin->digital.asd.match.of.node =3D=3D subdev->dev->of_node) {=

> -=09=09vin_dbg(vin, "bound digital subdev %s\n", subdev->name);
> +=09=09/* Find surce and sink pad of remote subdevice */
> +
> +=09=09ret =3D rvin_find_pad(subdev, MEDIA_PAD_FL_SOURCE);
> +=09=09if (ret < 0)
> +=09=09=09return ret;
> +=09=09vin->digital.source_pad =3D ret;
> +
> +=09=09ret =3D rvin_find_pad(subdev, MEDIA_PAD_FL_SINK);
> +=09=09if (ret < 0)
> +=09=09=09return ret;
> +=09=09vin->digital.sink_pad =3D ret;
> +
>  =09=09vin->digital.subdev =3D subdev;
> +
> +=09=09vin_dbg(vin, "bound subdev %s source pad: %d sink pad: %d\n",
> +=09=09=09subdev->name, vin->digital.source_pad,
> +=09=09=09vin->digital.sink_pad);

As source_pad and sink_pad are unsigned, s/%d/%u/g

>  =09=09return 0;
>  =09}
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> ce29a21888da48d5..be6f41bf82ac3bc5 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -870,20 +870,6 @@ static void rvin_notify(struct v4l2_subdev *sd,
>  =09}
>  }
>=20
> -static int rvin_find_pad(struct v4l2_subdev *sd, int direction)
> -{
> -=09unsigned int pad;
> -
> -=09if (sd->entity.num_pads <=3D 1)
> -=09=09return 0;
> -
> -=09for (pad =3D 0; pad < sd->entity.num_pads; pad++)
> -=09=09if (sd->entity.pads[pad].flags & direction)
> -=09=09=09return pad;
> -
> -=09return -EINVAL;
> -}
> -
>  int rvin_v4l2_probe(struct rvin_dev *vin)
>  {
>  =09struct video_device *vdev =3D &vin->vdev;
> @@ -934,16 +920,6 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
>  =09vdev->device_caps =3D V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING=
 |
>  =09=09V4L2_CAP_READWRITE;
>=20
> -=09ret =3D rvin_find_pad(sd, MEDIA_PAD_FL_SOURCE);
> -=09if (ret < 0)
> -=09=09return ret;
> -=09vin->digital.source_pad =3D ret;
> -
> -=09ret =3D rvin_find_pad(sd, MEDIA_PAD_FL_SINK);
> -=09if (ret < 0)
> -=09=09return ret;
> -=09vin->digital.sink_pad =3D ret;
> -
>  =09vin->format.pixelformat=09=3D RVIN_DEFAULT_FORMAT;
>  =09rvin_reset_format(vin);

--=20
Regards,

Laurent Pinchart
