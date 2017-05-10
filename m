Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58578 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753268AbdEJNjH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 09:39:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 16/16] rcar-vin: fix bug in pixelformat selection
Date: Wed, 10 May 2017 16:39:01 +0300
Message-ID: <3864065.kk1yiLIP8J@avalon>
In-Reply-To: <20170314185957.25253-17-niklas.soderlund+renesas@ragnatech.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se> <20170314185957.25253-17-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Tuesday 14 Mar 2017 19:59:57 Niklas S=F6derlund wrote:
> If the requested pixelformat is not supported only revert to the curr=
ent
> pixelformat, do not revert the entire format. Also if the pixelformat=

> needs to be reverted the pixel information needs to be fetched once
> more.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 956092ba6ef9bc6f..27b7733e96afe3e9 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -226,9 +226,8 @@ static int __rvin_try_format(struct rvin_dev *vin=
,
>  =09if (!info) {
>  =09=09vin_dbg(vin, "Format %x not found, keeping %x\n",
>  =09=09=09pix->pixelformat, vin->format.pixelformat);
> -=09=09*pix =3D vin->format;
> -=09=09pix->width =3D rwidth;
> -=09=09pix->height =3D rheight;
> +=09=09pix->pixelformat =3D vin->format.pixelformat;

You should set a fixed default in this case to achieve a more determini=
stic=20
behaviour. You can for instance pick the first entry of, which will als=
o save=20
you from calling rvin_format_from_pixel() as you can then replace it wi=
th=20
&rvin_formats[0].

> +=09=09info =3D rvin_format_from_pixel(pix->pixelformat);
>  =09}
>=20
>  =09/* Always recalculate */

--=20
Regards,

Laurent Pinchart
