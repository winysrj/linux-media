Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58414 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752424AbdEJNVk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 09:21:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 06/16] rcar-vin: refactor pad lookup code
Date: Wed, 10 May 2017 16:21:38 +0300
Message-ID: <1777354.Z7yukgknS8@avalon>
In-Reply-To: <20170314185957.25253-7-niklas.soderlund+renesas@ragnatech.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se> <20170314185957.25253-7-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Tuesday 14 Mar 2017 19:59:47 Niklas S=F6derlund wrote:
> The pad lookup code can be broken out to increase readability and to
> reduce code duplication.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 38 +++++++++++++------=
------
>  1 file changed, 23 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 1a75191539b0e7d7..ce29a21888da48d5 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -870,11 +870,25 @@ static void rvin_notify(struct v4l2_subdev *sd,=

>  =09}
>  }
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
>  int rvin_v4l2_probe(struct rvin_dev *vin)
>  {
>  =09struct video_device *vdev =3D &vin->vdev;
>  =09struct v4l2_subdev *sd =3D vin_to_source(vin);
> -=09int pad_idx, ret;
> +=09int ret;
>=20
>  =09v4l2_set_subdev_hostdata(sd, vin);
>=20
> @@ -920,21 +934,15 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
>  =09vdev->device_caps =3D V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING=
 |
>  =09=09V4L2_CAP_READWRITE;
>=20
> -=09vin->digital.source_pad =3D 0;
> -=09for (pad_idx =3D 0; pad_idx < sd->entity.num_pads; pad_idx++)
> -=09=09if (sd->entity.pads[pad_idx].flags =3D=3D MEDIA_PAD_FL_SOURCE)=

> -=09=09=09break;
> -=09if (pad_idx >=3D sd->entity.num_pads)
> -=09=09return -EINVAL;
> -
> -=09vin->digital.source_pad =3D pad_idx;
> +=09ret =3D rvin_find_pad(sd, MEDIA_PAD_FL_SOURCE);
> +=09if (ret < 0)
> +=09=09return ret;
> +=09vin->digital.source_pad =3D ret;
>=20
> -=09vin->digital.sink_pad =3D 0;
> -=09for (pad_idx =3D 0; pad_idx < sd->entity.num_pads; pad_idx++)
> -=09=09if (sd->entity.pads[pad_idx].flags =3D=3D MEDIA_PAD_FL_SINK) {=

> -=09=09=09vin->digital.sink_pad =3D pad_idx;
> -=09=09=09break;
> -=09=09}
> +=09ret =3D rvin_find_pad(sd, MEDIA_PAD_FL_SINK);
> +=09if (ret < 0)
> +=09=09return ret;
> +=09vin->digital.sink_pad =3D ret;

The driver didn't previously consider the lack of a sink pad as an erro=
r. As=20
camera sensor subdevs typically have no sink pad, I don't think you sho=
uld=20
change this.

>  =09vin->format.pixelformat=09=3D RVIN_DEFAULT_FORMAT;
>  =09rvin_reset_format(vin);

--=20
Regards,

Laurent Pinchart
