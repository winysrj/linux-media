Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58435 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752884AbdEJNWP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 09:22:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 04/16] rcar-vin: fix standard in input enumeration
Date: Wed, 10 May 2017 16:22:14 +0300
Message-ID: <1564076.Gvng20emQd@avalon>
In-Reply-To: <20170314185957.25253-5-niklas.soderlund+renesas@ragnatech.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se> <20170314185957.25253-5-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Tuesday 14 Mar 2017 19:59:45 Niklas S=F6derlund wrote:
> If the subdevice supports dv_timings_cap the driver should not fill i=
n
> the standard.

A subdev could have analog TV and digital TV inputs. However, as the rc=
ar-vin=20
driver supports a single input only, this patch is correct. I'd mention=
 this=20
fact in the commit message. Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 610f59e2a9142622..7be52c2036bb35fc 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -483,10 +483,14 @@ static int rvin_enum_input(struct file *file, v=
oid
> *priv, return ret;
>=20
>  =09i->type =3D V4L2_INPUT_TYPE_CAMERA;
> -=09i->std =3D vin->vdev.tvnorms;
>=20
> -=09if (v4l2_subdev_has_op(sd, pad, dv_timings_cap))
> +=09if (v4l2_subdev_has_op(sd, pad, dv_timings_cap)) {
>  =09=09i->capabilities =3D V4L2_IN_CAP_DV_TIMINGS;
> +=09=09i->std =3D 0;
> +=09} else {
> +=09=09i->capabilities =3D V4L2_IN_CAP_STD;
> +=09=09i->std =3D vin->vdev.tvnorms;
> +=09}
>=20
>  =09strlcpy(i->name, "Camera", sizeof(i->name));

--=20
Regards,

Laurent Pinchart
