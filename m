Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:34250 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbaCYUuQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 16:50:16 -0400
Message-ID: <1395780611.11851.17.camel@nicolas-tpx230>
Subject: [PATCH 2/5] s5p-fimc: Fix YUV422P depth
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: LMML <linux-media@vger.kernel.org>
Cc: s.nawrocki@samsung.com
Date: Tue, 25 Mar 2014 16:50:11 -0400
In-Reply-To: <1395780301.11851.14.camel@nicolas-tpx230>
References: <1395780301.11851.14.camel@nicolas-tpx230>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-q58Ce67TWf270KKMrgx2"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-q58Ce67TWf270KKMrgx2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

All YUV 422 has 16bit per pixels.

Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
---
 drivers/media/platform/exynos4-is/fimc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-core.c
b/drivers/media/platform/exynos4-is/fimc-core.c
index bfb80fb..2e70fab 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -122,7 +122,7 @@ static struct fimc_fmt fimc_formats[] =3D {
 	}, {
 		.name		=3D "YUV 4:2:2 planar, Y/Cb/Cr",
 		.fourcc		=3D V4L2_PIX_FMT_YUV422P,
-		.depth		=3D { 12 },
+		.depth		=3D { 16 },
 		.color		=3D FIMC_FMT_YCBYCR422,
 		.memplanes	=3D 1,
 		.colplanes	=3D 3,
--=20
1.8.5.3



--=-q58Ce67TWf270KKMrgx2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlMx7AMACgkQcVMCLawGqByqoQCeJqP4LDCE/L0/H22h34XatQOI
FqgAoMkZrl1COneUYeO9FslPE0lSeuOZ
=bkHP
-----END PGP SIGNATURE-----

--=-q58Ce67TWf270KKMrgx2--

