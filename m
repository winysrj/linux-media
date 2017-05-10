Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58565 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753089AbdEJNgy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 09:36:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 15/16] rcar-vin: add missing error check to propagate error
Date: Wed, 10 May 2017 16:36:54 +0300
Message-ID: <4052433.1TBrlrNN8j@avalon>
In-Reply-To: <20170314185957.25253-16-niklas.soderlund+renesas@ragnatech.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se> <20170314185957.25253-16-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Tuesday 14 Mar 2017 19:59:56 Niklas S=F6derlund wrote:
> The return value of __rvin_try_format_source is not checked, add a ch=
eck
> and propagate the error.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> c40f5bc3e3d26472..956092ba6ef9bc6f 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -208,6 +208,7 @@ static int __rvin_try_format(struct rvin_dev *vin=
,
>  {
>  =09const struct rvin_video_format *info;
>  =09u32 rwidth, rheight, walign;
> +=09int ret;
>=20
>  =09/* Requested */
>  =09rwidth =3D pix->width;
> @@ -235,7 +236,9 @@ static int __rvin_try_format(struct rvin_dev *vin=
,
>  =09pix->sizeimage =3D 0;
>=20
>  =09/* Limit to source capabilities */
> -=09__rvin_try_format_source(vin, which, pix, source);
> +=09ret =3D __rvin_try_format_source(vin, which, pix, source);
> +=09if (ret)
> +=09=09return ret;
>=20
>  =09switch (pix->field) {
>  =09case V4L2_FIELD_TOP:

--=20
Regards,

Laurent Pinchart
