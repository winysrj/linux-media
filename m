Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52854 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965935AbeBMWWe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 17:22:34 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] videodev2.h: add helper to validate colorspace
Date: Wed, 14 Feb 2018 00:23:05 +0200
Message-ID: <2862017.uVaJOSAbcn@avalon>
In-Reply-To: <20180213220847.10856-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180213220847.10856-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Wednesday, 14 February 2018 00:08:47 EET Niklas S=C3=B6derlund wrote:
> There is no way for drivers to validate a colorspace value, which could
> be provided by user-space by VIDIOC_S_FMT for example. Add a helper to
> validate that the colorspace value is part of enum v4l2_colorspace.
>=20
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> ---
>  include/uapi/linux/videodev2.h | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> Hi,
>=20
> I hope this is the correct header to add this helper to. I think it's
> since if it's in uapi not only can v4l2 drivers use it but tools like
> v4l-compliance gets access to it and can be updated to use this instead
> of the hard-coded check of just < 0xff as it was last time I checked.
>=20
> // Niklas
>=20
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev=
2.h
> index 9827189651801e12..843afd7c5b000553 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -238,6 +238,11 @@ enum v4l2_colorspace {
>  	V4L2_COLORSPACE_DCI_P3        =3D 12,
>  };
>=20
> +/* Determine if a colorspace is defined in enum v4l2_colorspace */
> +#define V4L2_COLORSPACE_IS_VALID(colorspace)		\
> +	(((colorspace) >=3D V4L2_COLORSPACE_DEFAULT) &&	\
> +	 ((colorspace) <=3D V4L2_COLORSPACE_DCI_P3))
> +

This looks pretty good to me. I'd remove the parentheses around each test=20
though.

One potential issue is that if this macro operates on an unsigned value (fo=
r=20
instance an u32, which is the type used for the colorspace field in various=
=20
structures) the compiler will generate a warning:

enum.c: In function =E2=80=98test_4=E2=80=99:                              =
                                                                           =
                                                                   =20
enum.c:30:16: warning: comparison of unsigned expression >=3D 0 is always t=
rue=20
[-Wtype-limits]                                                            =
                                                 =20
  return V4L2_COLORSPACE_IS_VALID(colorspace);

Dropping the first check would fix that, but wouldn't catch invalid values=
=20
when operating on a signed type, such as int or enum v4l2_colorspace.

>  /*
>   * Determine how COLORSPACE_DEFAULT should map to a proper colorspace.
>   * This depends on whether this is a SDTV image (use SMPTE 170M), an

=2D-=20
Regards,

Laurent Pinchart
