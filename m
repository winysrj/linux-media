Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:37822 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaDAONM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Apr 2014 10:13:12 -0400
Message-ID: <1396361586.18172.0.camel@nicolas-tpx230>
Subject: Re: [PATCH 0/5] s5p-fimc: Misc fixes
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: LMML <linux-media@vger.kernel.org>
Cc: s.nawrocki@samsung.com
Date: Tue, 01 Apr 2014 10:13:06 -0400
In-Reply-To: <1395780301.11851.14.camel@nicolas-tpx230>
References: <1395780301.11851.14.camel@nicolas-tpx230>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-X3HZtp/4kFFadw2PUxPE"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-X3HZtp/4kFFadw2PUxPE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Any comment/input ?

Le mardi 25 mars 2014 =C3=A0 16:45 -0400, Nicolas Dufresne a =C3=A9crit :
> This patch series fixes several bugs found in the s5p-fimc driver. These
> bugs relate to bad parameters in the formats definition and short size
> of image buffers.
>=20
> Nicolas Dufresne (5):
>   s5p-fimc: Reuse calculated sizes
>   s5p-fimc: Iterate for each memory plane
>   s5p-fimc: Align imagesize to row size for tiled formats
>   s5p-fimc: Fix YUV422P depth
>   s5p-fimc: Changed RGB32 to BGR32
>=20
>  drivers/media/platform/exynos4-is/fimc-core.c | 21 +++++++++++++++------
>  drivers/media/platform/exynos4-is/fimc-m2m.c  |  6 +++---
>  2 files changed, 18 insertions(+), 9 deletions(-)
>=20


--=-X3HZtp/4kFFadw2PUxPE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlM6yXIACgkQcVMCLawGqBzM2ACgkF58b10qeJO/NiG9/23Z3Chc
uXoAnR0ibT8yoMg5SuTQ6YNrgRl6OKOt
=jcsi
-----END PGP SIGNATURE-----

--=-X3HZtp/4kFFadw2PUxPE--

