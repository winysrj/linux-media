Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57780 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030976AbeBNPPb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 10:15:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2] videodev2.h: add helper to validate colorspace
Date: Wed, 14 Feb 2018 17:16:04 +0200
Message-ID: <3434065.V6QgqqWRc5@avalon>
In-Reply-To: <20180214103643.8245-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180214103643.8245-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Wednesday, 14 February 2018 12:36:43 EET Niklas S=F6derlund wrote:
> There is no way for drivers to validate a colorspace value, which could
> be provided by user-space by VIDIOC_S_FMT for example. Add a helper to
> validate that the colorspace value is part of enum v4l2_colorspace.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  include/uapi/linux/videodev2.h | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> Hi,
>=20
> I hope this is the correct header to add this helper to. I think it's
> since if it's in uapi not only can v4l2 drivers use it but tools like
> v4l-compliance gets access to it and can be updated to use this instead
> of the hard-coded check of just < 0xff as it was last time I checked.
>=20
> * Changes since v1
> - Cast colorspace to u32 as suggested by Sakari and only check the upper
>   boundary to address a potential issue brought up by Laurent if the
>   data type tested is u32 which is not uncommon:
>=20
>     enum.c:30:16: warning: comparison of unsigned expression >=3D 0 is al=
ways
> true [-Wtype-limits]
>       return V4L2_COLORSPACE_IS_VALID(colorspace);
>=20
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev=
2.h
> index 9827189651801e12..1f27c0f4187cbded 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -238,6 +238,10 @@ enum v4l2_colorspace {
>  	V4L2_COLORSPACE_DCI_P3        =3D 12,
>  };
>=20
> +/* Determine if a colorspace is defined in enum v4l2_colorspace */
> +#define V4L2_COLORSPACE_IS_VALID(colorspace)		\
> +	((u32)(colorspace) <=3D V4L2_COLORSPACE_DCI_P3)
> +

Casting to u32 has the added benefit that the colorspace expression is=20
evaluated once only, I like that.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  /*
>   * Determine how COLORSPACE_DEFAULT should map to a proper colorspace.
>   * This depends on whether this is a SDTV image (use SMPTE 170M), an


=2D-=20
Regards,

Laurent Pinchart
