Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58443 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752890AbdEJNWS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 09:22:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 01/16] rcar-vin: reset bytesperline and sizeimage when resetting format
Date: Wed, 10 May 2017 16:22:17 +0300
Message-ID: <10910699.GTaH7yxk2V@avalon>
In-Reply-To: <20170314185957.25253-2-niklas.soderlund+renesas@ragnatech.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se> <20170314185957.25253-2-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Tuesday 14 Mar 2017 19:59:42 Niklas S=F6derlund wrote:
> These two where forgotten when refactoring the format reset code. If
> they are not also reset at the same time as width and height the form=
at
> returned from G_FMT will not match reality.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
.se>

With the commit message typo fixed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 2bbe6d495fa634da..69bc4cfea6a8aeb5 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -151,6 +151,9 @@ static int rvin_reset_format(struct rvin_dev *vin=
)
>=20
>  =09rvin_reset_crop_compose(vin);
>=20
> +=09vin->format.bytesperline =3D rvin_format_bytesperline(&vin->forma=
t);
> +=09vin->format.sizeimage =3D rvin_format_sizeimage(&vin->format);
> +
>  =09return 0;
>  }

--=20
Regards,

Laurent Pinchart
