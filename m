Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41781 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbeKLT41 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 14:56:27 -0500
Message-ID: <5770340b744926d5abd653a2235f194f58bd97a2.camel@bootlin.com>
Subject: Re: [PATCH] media: v4l: v4l2-controls.h must include types.h
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Jean Delvare <jdelvare@suse.de>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Date: Mon, 12 Nov 2018 11:03:55 +0100
In-Reply-To: <20181112110146.5baee2ea@endymion>
References: <20181112110146.5baee2ea@endymion>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-DAMxBxaT/6p/4hsALK+/"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-DAMxBxaT/6p/4hsALK+/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 2018-11-12 at 11:01 +0100, Jean Delvare wrote:
> Fix the following build-time warning:
> ./usr/include/linux/v4l2-controls.h:1105: found __[us]{8,16,32,64} type w=
ithout #include <linux/types.h>

We already have a similar fix in the media tree:
https://git.linuxtv.org/media_tree.git/commit/?h=3Drequest_api&id=3Ddafb7f9=
aef2fd44991ff1691721ff765a23be27b

So it looks like we won't be needing this one!

Cheers,

Paul

> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Fixes: c27bb30e7b6d ("media: v4l: Add definitions for MPEG-2 slice format=
 and metadata")
> Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> ---
>  include/uapi/linux/v4l2-controls.h |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> --- linux-4.20-rc2.orig/include/uapi/linux/v4l2-controls.h	2018-11-12 09:=
34:20.869048454 +0100
> +++ linux-4.20-rc2/include/uapi/linux/v4l2-controls.h	2018-11-12 10:54:38=
.864904194 +0100
> @@ -50,6 +50,8 @@
>  #ifndef __LINUX_V4L2_CONTROLS_H
>  #define __LINUX_V4L2_CONTROLS_H
> =20
> +#include <linux/types.h>		/* for __u* typedefs */
> +
>  /* Control classes */
>  #define V4L2_CTRL_CLASS_USER		0x00980000	/* Old-style 'user' controls */
>  #define V4L2_CTRL_CLASS_MPEG		0x00990000	/* MPEG-compression controls */
>=20
>=20
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-DAMxBxaT/6p/4hsALK+/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlvpUAwACgkQ3cLmz3+f
v9Hlugf+N9ZaxKbEqptLEsfVyxZxMzhzrDvzJO+NFmNF+bZZnlaVNBzwQUF1iVln
F9pTvNfZChBNNS3fCboGpd9dgZ+HaVtSAwUbfIwyp1QifDYCAvhDYHHdp/5Fqgby
3s9EnxhrGdZ9Ewc8OHGbI6yohGgh1bXcgi9e+FH/BfF6emOb5UBKoUYHegDr+ZJ1
r7/ZQ97xomeKx+zojG0AueGX/lJoGH6tnfVKYBCaUDv0Y80tgYom7JfzxxteBejs
ypHDbyYVOERiO9hy6rDnLDmVWMAZq/mRduxwiFiC9uYIBoVQxI43aljKYKkpFlG1
LFkbU9F42Q3GQfZkNLVxXJl5uNJL8w==
=enNC
-----END PGP SIGNATURE-----

--=-DAMxBxaT/6p/4hsALK+/--
