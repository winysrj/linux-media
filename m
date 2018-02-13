Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44889 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965444AbeBMRHu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 12:07:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 18/30] rcar-vin: add check for colorspace
Date: Tue, 13 Feb 2018 19:08:21 +0200
Message-ID: <5427648.X2M1hoBuUV@avalon>
In-Reply-To: <20180129163435.24936-19-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se> <20180129163435.24936-19-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Monday, 29 January 2018 18:34:23 EET Niklas S=F6derlund wrote:
> Add a check to ensure the colorspace from user-space is good. On Gen2 it
> works without this change as the sensor sets the colorspace but on Gen3
> this can fail if the colorspace provided by the user is not good. The
> values to check for comes from v4l2-compliance sources which is the tool
> that found this error. If this check is not preformed v4l2-compliance

s/preformed/performed/

> fails when it tests colorspace.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 841d62ca27e026d7..6403650aff22a2ed 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -23,6 +23,7 @@
>  #include "rcar-vin.h"
>=20
>  #define RVIN_DEFAULT_FORMAT	V4L2_PIX_FMT_YUYV
> +#define RVIN_DEFAULT_COLORSPACE	V4L2_COLORSPACE_SRGB
>=20
>  /* ---------------------------------------------------------------------=
=2D--
>   * Format Conversions
> @@ -115,6 +116,10 @@ static int rvin_format_align(struct rvin_dev *vin,
> struct v4l2_pix_format *pix) break;
>  	}
>=20
> +	/* Check that colorspace is reasonable */
> +	if (!pix->colorspace || pix->colorspace >=3D 0xff)

I'd write the first check as

	pix->colorspace =3D=3D V4L2_COLORSPACE_DEFAULT

=46or the second check I don't think 0xff is a meaningful value. We current=
ly=20
have 12 colorspaces defined. If we want to be future-proof I'd add a=20
V4L2_COLORSPACE_MAX entry to enum v4l2_colorspace and use that for the chec=
k.=20
Alternatively you could use V4L2_COLORSPACE_DCI_P3 but the driver would nee=
d=20
to be updated when new colorspaces get added.

> +		pix->colorspace =3D RVIN_DEFAULT_COLORSPACE;
> +
>  	/* HW limit width to a multiple of 32 (2^5) for NV16 else 2 (2^1) */
>  	walign =3D vin->format.pixelformat =3D=3D V4L2_PIX_FMT_NV16 ? 5 : 1;

=2D-=20
Regards,

Laurent Pinchart
