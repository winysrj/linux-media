Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58443 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752684AbdEJNWQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 09:22:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 03/16] rcar-vin: fix how pads are handled for v4l2 subdevice operations
Date: Wed, 10 May 2017 16:22:15 +0300
Message-ID: <3039950.nIPF3cxbPq@avalon>
In-Reply-To: <20170314185957.25253-4-niklas.soderlund+renesas@ragnatech.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se> <20170314185957.25253-4-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Tuesday 14 Mar 2017 19:59:44 Niklas S=F6derlund wrote:
> The rcar-vin driver only uses one pad, pad number 0.
>=20
> - All v4l2 operations that did not check that the requested operation=

>   was for pad 0 have been updated with a check to enforce this.
>=20
> - All v4l2 operations that stored (and later restore) the requested p=
ad
>   before substituting it for the subdevice pad number have been updat=
ed
>   to not store the incoming pad and simply restore it to 0 after the
>   subdevice operation is complete.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 26 ++++++++++++++-----=
-------
> 1 file changed, 14 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 7ca27599b9982ffc..610f59e2a9142622 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -550,14 +550,16 @@ static int rvin_enum_dv_timings(struct file *fi=
le,
> void *priv_fh, {
>  =09struct rvin_dev *vin =3D video_drvdata(file);
>  =09struct v4l2_subdev *sd =3D vin_to_source(vin);
> -=09int pad, ret;
> +=09int ret;
> +
> +=09if (timings->pad)
> +=09=09return -EINVAL;
>=20
> -=09pad =3D timings->pad;
>  =09timings->pad =3D vin->sink_pad_idx;
>=20
>  =09ret =3D v4l2_subdev_call(sd, pad, enum_dv_timings, timings);
>=20
> -=09timings->pad =3D pad;
> +=09timings->pad =3D 0;
>=20
>  =09return ret;
>  }
> @@ -600,14 +602,16 @@ static int rvin_dv_timings_cap(struct file *fil=
e, void
> *priv_fh, {
>  =09struct rvin_dev *vin =3D video_drvdata(file);
>  =09struct v4l2_subdev *sd =3D vin_to_source(vin);
> -=09int pad, ret;
> +=09int ret;
> +
> +=09if (cap->pad)
> +=09=09return -EINVAL;
>=20
> -=09pad =3D cap->pad;
>  =09cap->pad =3D vin->sink_pad_idx;
>=20
>  =09ret =3D v4l2_subdev_call(sd, pad, dv_timings_cap, cap);
>=20
> -=09cap->pad =3D pad;
> +=09cap->pad =3D 0;
>=20
>  =09return ret;
>  }
> @@ -616,17 +620,16 @@ static int rvin_g_edid(struct file *file, void =
*fh,
> struct v4l2_edid *edid) {
>  =09struct rvin_dev *vin =3D video_drvdata(file);
>  =09struct v4l2_subdev *sd =3D vin_to_source(vin);
> -=09int input, ret;
> +=09int ret;
>=20
>  =09if (edid->pad)
>  =09=09return -EINVAL;
>=20
> -=09input =3D edid->pad;
>  =09edid->pad =3D vin->sink_pad_idx;
>=20
>  =09ret =3D v4l2_subdev_call(sd, pad, get_edid, edid);
>=20
> -=09edid->pad =3D input;
> +=09edid->pad =3D 0;
>=20
>  =09return ret;
>  }
> @@ -635,17 +638,16 @@ static int rvin_s_edid(struct file *file, void =
*fh,
> struct v4l2_edid *edid) {
>  =09struct rvin_dev *vin =3D video_drvdata(file);
>  =09struct v4l2_subdev *sd =3D vin_to_source(vin);
> -=09int input, ret;
> +=09int ret;
>=20
>  =09if (edid->pad)
>  =09=09return -EINVAL;
>=20
> -=09input =3D edid->pad;
>  =09edid->pad =3D vin->sink_pad_idx;
>=20
>  =09ret =3D v4l2_subdev_call(sd, pad, set_edid, edid);
>=20
> -=09edid->pad =3D input;
> +=09edid->pad =3D 0;
>=20
>  =09return ret;
>  }

--=20
Regards,

Laurent Pinchart
