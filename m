Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52034 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750794AbcIOR4t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 13:56:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Cc: hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        magnus.damm@gmail.com, william.towle@codethink.co.uk
Subject: Re: [PATCH v9 1/2] rcar-vin: implement EDID control ioctls
Date: Thu, 15 Sep 2016 20:57:26 +0300
Message-ID: <12618604.eZDorqjyHh@avalon>
In-Reply-To: <20160915173324.24539-2-ulrich.hecht+renesas@gmail.com>
References: <20160915173324.24539-1-ulrich.hecht+renesas@gmail.com> <20160915173324.24539-2-ulrich.hecht+renesas@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulrich,

Thank you for the patch.

On Thursday 15 Sep 2016 19:33:23 Ulrich Hecht wrote:
> Adds G_EDID and S_EDID.
>=20
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> Acked-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 48 +++++++++++++++++++=
+++++++
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  2 ++
>  2 files changed, 50 insertions(+)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index 61e9b59..f35005c =
100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -613,6 +613,44 @@ static int rvin_dv_timings_cap(struct file *file=
, void
> *priv_fh, return ret;
>  }
>=20
> +static int rvin_g_edid(struct file *file, void *fh, struct v4l2_edid=
 *edid)
> +{
> +=09struct rvin_dev *vin =3D video_drvdata(file);
> +=09struct v4l2_subdev *sd =3D vin_to_source(vin);
> +=09int input, ret;
> +
> +=09if (edid->pad)
> +=09=09return -EINVAL;
> +
> +=09input =3D edid->pad;
> +=09edid->pad =3D vin->sink_pad_idx;
> +
> +=09ret =3D v4l2_subdev_call(sd, pad, get_edid, edid);
> +
> +=09edid->pad =3D input;
> +
> +=09return ret;
> +}
> +
> +static int rvin_s_edid(struct file *file, void *fh, struct v4l2_edid=
 *edid)
> +{
> +=09struct rvin_dev *vin =3D video_drvdata(file);
> +=09struct v4l2_subdev *sd =3D vin_to_source(vin);
> +=09int input, ret;
> +
> +=09if (edid->pad)
> +=09=09return -EINVAL;
> +
> +=09input =3D edid->pad;
> +=09edid->pad =3D vin->sink_pad_idx;
> +
> +=09ret =3D v4l2_subdev_call(sd, pad, set_edid, edid);
> +
> +=09edid->pad =3D input;
> +
> +=09return ret;
> +}
> +
>  static const struct v4l2_ioctl_ops rvin_ioctl_ops =3D {
>  =09.vidioc_querycap=09=09=3D rvin_querycap,
>  =09.vidioc_try_fmt_vid_cap=09=09=3D rvin_try_fmt_vid_cap,
> @@ -635,6 +673,9 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops=
 =3D {
>  =09.vidioc_s_dv_timings=09=09=3D rvin_s_dv_timings,
>  =09.vidioc_query_dv_timings=09=3D rvin_query_dv_timings,
>=20
> +=09.vidioc_g_edid=09=09=09=3D rvin_g_edid,
> +=09.vidioc_s_edid=09=09=09=3D rvin_s_edid,
> +
>  =09.vidioc_querystd=09=09=3D rvin_querystd,
>  =09.vidioc_g_std=09=09=09=3D rvin_g_std,
>  =09.vidioc_s_std=09=09=09=3D rvin_s_std,
> @@ -883,6 +924,13 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
>=20
>  =09vin->src_pad_idx =3D pad_idx;
>=20
> +=09vin->sink_pad_idx =3D 0;
> +=09for (pad_idx =3D 0; pad_idx < sd->entity.num_pads; pad_idx++)
> +=09=09if (sd->entity.pads[pad_idx].flags =3D=3D MEDIA_PAD_FL_SINK) {=

> +=09=09=09vin->sink_pad_idx =3D pad_idx;
> +=09=09=09break;
> +=09=09}
> +
>  =09vin->format.pixelformat=09=3D RVIN_DEFAULT_FORMAT;
>  =09rvin_reset_format(vin);
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index 793184d..727e215 1=
00644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -92,6 +92,7 @@ struct rvin_graph_entity {
>   * @vdev:=09=09V4L2 video device associated with VIN
>   * @v4l2_dev:=09=09V4L2 device
>   * @src_pad_idx:=09source pad index for media controller drivers
> + * @sink_pad_idx:=09sink pad index for media controller drivers
>   * @ctrl_handler:=09V4L2 control handler
>   * @notifier:=09=09V4L2 asynchronous subdevs notifier
>   * @digital:=09=09entity in the DT for local digital subdevice
> @@ -121,6 +122,7 @@ struct rvin_dev {
>  =09struct video_device vdev;
>  =09struct v4l2_device v4l2_dev;
>  =09int src_pad_idx;
> +=09int sink_pad_idx;
>  =09struct v4l2_ctrl_handler ctrl_handler;
>  =09struct v4l2_async_notifier notifier;
>  =09struct rvin_graph_entity digital;

--=20
Regards,

Laurent Pinchart

