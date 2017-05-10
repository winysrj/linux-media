Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58449 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753106AbdEJNWR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 09:22:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 02/16] rcar-vin: use rvin_reset_format() in S_DV_TIMINGS
Date: Wed, 10 May 2017 16:22:16 +0300
Message-ID: <5932754.eWeQtlWCiC@avalon>
In-Reply-To: <20170314185957.25253-3-niklas.soderlund+renesas@ragnatech.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se> <20170314185957.25253-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Tuesday 14 Mar 2017 19:59:43 Niklas S=F6derlund wrote:
> Use rvin_reset_format() in rvin_s_dv_timings() instead of just resett=
ing
> a few fields. This fixes an issue where the field format was not
> properly set after S_DV_TIMINGS.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 69bc4cfea6a8aeb5..7ca27599b9982ffc 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -573,12 +573,8 @@ static int rvin_s_dv_timings(struct file *file, =
void
> *priv_fh, if (ret)
>  =09=09return ret;
>=20
> -=09vin->source.width =3D timings->bt.width;
> -=09vin->source.height =3D timings->bt.height;
> -=09vin->format.width =3D timings->bt.width;
> -=09vin->format.height =3D timings->bt.height;
> -
> -=09return 0;
> +=09/* Changing the timings will change the width/height */
> +=09return rvin_reset_format(vin);

vin->source won't be updated anymore. Is this intentional ?

>  }
>=20
>  static int rvin_g_dv_timings(struct file *file, void *priv_fh,

--=20
Regards,

Laurent Pinchart
