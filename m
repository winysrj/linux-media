Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58426 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752684AbdEJNWO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 09:22:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 05/16] rcar-vin: move subdev source and sink pad index to rvin_graph_entity
Date: Wed, 10 May 2017 16:22:13 +0300
Message-ID: <2412864.T3pvZBx668@avalon>
In-Reply-To: <20170314185957.25253-6-niklas.soderlund+renesas@ragnatech.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se> <20170314185957.25253-6-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Tuesday 14 Mar 2017 19:59:46 Niklas S=F6derlund wrote:
> It makes more sens to store the sink and source pads in struct
> rvin_graph_entity since that contains other subdevice related
> information.
>=20
> The data type to store pad information in is unsigned int and not int=
,
> change this. While we are at it drop the _idx suffix from the names,
> this never made sens.

s/sens/sense/

> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
.se>

With the typo fixed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 20 ++++++++++---------=
-
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  9 +++++----
>  2 files changed, 15 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 7be52c2036bb35fc..1a75191539b0e7d7 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -111,7 +111,7 @@ static int rvin_reset_format(struct rvin_dev *vin=
)
>  =09struct v4l2_mbus_framefmt *mf =3D &fmt.format;
>  =09int ret;
>=20
> -=09fmt.pad =3D vin->src_pad_idx;
> +=09fmt.pad =3D vin->digital.source_pad;
>=20
>  =09ret =3D v4l2_subdev_call(vin_to_source(vin), pad, get_fmt, NULL, =
&fmt);
>  =09if (ret)
> @@ -178,7 +178,7 @@ static int __rvin_try_format_source(struct rvin_d=
ev
> *vin, if (pad_cfg =3D=3D NULL)
>  =09=09return -ENOMEM;
>=20
> -=09format.pad =3D vin->src_pad_idx;
> +=09format.pad =3D vin->digital.source_pad;
>=20
>  =09field =3D pix->field;
>=20
> @@ -559,7 +559,7 @@ static int rvin_enum_dv_timings(struct file *file=
, void
> *priv_fh, if (timings->pad)
>  =09=09return -EINVAL;
>=20
> -=09timings->pad =3D vin->sink_pad_idx;
> +=09timings->pad =3D vin->digital.sink_pad;
>=20
>  =09ret =3D v4l2_subdev_call(sd, pad, enum_dv_timings, timings);
>=20
> @@ -611,7 +611,7 @@ static int rvin_dv_timings_cap(struct file *file,=
 void
> *priv_fh, if (cap->pad)
>  =09=09return -EINVAL;
>=20
> -=09cap->pad =3D vin->sink_pad_idx;
> +=09cap->pad =3D vin->digital.sink_pad;
>=20
>  =09ret =3D v4l2_subdev_call(sd, pad, dv_timings_cap, cap);
>=20
> @@ -629,7 +629,7 @@ static int rvin_g_edid(struct file *file, void *f=
h,
> struct v4l2_edid *edid) if (edid->pad)
>  =09=09return -EINVAL;
>=20
> -=09edid->pad =3D vin->sink_pad_idx;
> +=09edid->pad =3D vin->digital.sink_pad;
>=20
>  =09ret =3D v4l2_subdev_call(sd, pad, get_edid, edid);
>=20
> @@ -647,7 +647,7 @@ static int rvin_s_edid(struct file *file, void *f=
h,
> struct v4l2_edid *edid) if (edid->pad)
>  =09=09return -EINVAL;
>=20
> -=09edid->pad =3D vin->sink_pad_idx;
> +=09edid->pad =3D vin->digital.sink_pad;
>=20
>  =09ret =3D v4l2_subdev_call(sd, pad, set_edid, edid);
>=20
> @@ -920,19 +920,19 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
>  =09vdev->device_caps =3D V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING=
 |
>  =09=09V4L2_CAP_READWRITE;
>=20
> -=09vin->src_pad_idx =3D 0;
> +=09vin->digital.source_pad =3D 0;
>  =09for (pad_idx =3D 0; pad_idx < sd->entity.num_pads; pad_idx++)
>  =09=09if (sd->entity.pads[pad_idx].flags =3D=3D MEDIA_PAD_FL_SOURCE)=

>  =09=09=09break;
>  =09if (pad_idx >=3D sd->entity.num_pads)
>  =09=09return -EINVAL;
>=20
> -=09vin->src_pad_idx =3D pad_idx;
> +=09vin->digital.source_pad =3D pad_idx;
>=20
> -=09vin->sink_pad_idx =3D 0;
> +=09vin->digital.sink_pad =3D 0;
>  =09for (pad_idx =3D 0; pad_idx < sd->entity.num_pads; pad_idx++)
>  =09=09if (sd->entity.pads[pad_idx].flags =3D=3D MEDIA_PAD_FL_SINK) {=

> -=09=09=09vin->sink_pad_idx =3D pad_idx;
> +=09=09=09vin->digital.sink_pad =3D pad_idx;
>  =09=09=09break;
>  =09=09}
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> 727e215c08718eb9..9bfb5a7c4dc4f215 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -74,6 +74,8 @@ struct rvin_video_format {
>   * @subdev:=09subdevice matched using async framework
>   * @code:=09Media bus format from source
>   * @mbus_cfg:=09Media bus format from DT
> + * @source_pad:=09source pad of remote subdevice
> + * @sink_pad:=09sink pad of remote subdevice
>   */
>  struct rvin_graph_entity {
>  =09struct v4l2_async_subdev asd;
> @@ -81,6 +83,9 @@ struct rvin_graph_entity {
>=20
>  =09u32 code;
>  =09struct v4l2_mbus_config mbus_cfg;
> +
> +=09unsigned int source_pad;
> +=09unsigned int sink_pad;
>  };
>=20
>  /**
> @@ -91,8 +96,6 @@ struct rvin_graph_entity {
>   *
>   * @vdev:=09=09V4L2 video device associated with VIN
>   * @v4l2_dev:=09=09V4L2 device
> - * @src_pad_idx:=09source pad index for media controller drivers
> - * @sink_pad_idx:=09sink pad index for media controller drivers
>   * @ctrl_handler:=09V4L2 control handler
>   * @notifier:=09=09V4L2 asynchronous subdevs notifier
>   * @digital:=09=09entity in the DT for local digital subdevice
> @@ -121,8 +124,6 @@ struct rvin_dev {
>=20
>  =09struct video_device vdev;
>  =09struct v4l2_device v4l2_dev;
> -=09int src_pad_idx;
> -=09int sink_pad_idx;
>  =09struct v4l2_ctrl_handler ctrl_handler;
>  =09struct v4l2_async_notifier notifier;
>  =09struct rvin_graph_entity digital;

--=20
Regards,

Laurent Pinchart
