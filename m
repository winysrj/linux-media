Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45047 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965277AbeBMRuy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 12:50:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 19/30] rcar-vin: set a default field to fallback on
Date: Tue, 13 Feb 2018 19:51:25 +0200
Message-ID: <2513002.daXBhrgmYI@avalon>
In-Reply-To: <20180129163435.24936-20-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se> <20180129163435.24936-20-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Monday, 29 January 2018 18:34:24 EET Niklas S=F6derlund wrote:
> If the field is not supported by the driver it should not try to keep
> the current field. Instead it should set it to a default fallback. Since
> trying a format should always result in the same state regardless of the
> current state of the device.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 6403650aff22a2ed..f69ae76b3fda50c7 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -23,6 +23,7 @@
>  #include "rcar-vin.h"
>=20
>  #define RVIN_DEFAULT_FORMAT	V4L2_PIX_FMT_YUYV
> +#define RVIN_DEFAULT_FIELD	V4L2_FIELD_NONE
>  #define RVIN_DEFAULT_COLORSPACE	V4L2_COLORSPACE_SRGB
>=20
>  /* ---------------------------------------------------------------------=
=2D--
> @@ -171,7 +172,7 @@ static int rvin_get_source_format(struct rvin_dev
> *vin, fmt.format.height *=3D 2;
>  		break;
>  	default:
> -		vin->format.field =3D V4L2_FIELD_NONE;
> +		vin->format.field =3D RVIN_DEFAULT_FIELD;
>  		break;
>  	}
>=20
> @@ -267,9 +268,8 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  {
>  	int ret;
>=20
> -	/* Keep current field if no specific one is asked for */
>  	if (pix->field =3D=3D V4L2_FIELD_ANY)
> -		pix->field =3D vin->format.field;
> +		pix->field =3D RVIN_DEFAULT_FIELD;

Won't this also be caught by the field check in the above function, called=
=20
from __rvin_try_format_source() ? You could just remove this check complete=
ly.

However as mentioned in a comment for a previous patch I don't think the fi=
eld=20
handling belongs in rvin_get_source_format(), so you could merge both here.=
=20
Or, if you repurpose and rename rvin_get_source_format(), then the check ca=
n=20
probably be removed completely. I haven't checked the consolidated code aft=
er=20
applying all patches from this series, but some refactoring might be useful=
=2E=20
We'll see.

>  	/* Limit to source capabilities */
>  	ret =3D __rvin_try_format_source(vin, which, pix);

=2D-=20
Regards,

Laurent Pinchart
