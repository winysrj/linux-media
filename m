Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:34262 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbaCYU4L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 16:56:11 -0400
Message-ID: <1395780967.11851.22.camel@nicolas-tpx230>
Subject: [PATCH 2/5] s5p-fimc: Fix YUV422P depth
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: LMML <linux-media@vger.kernel.org>
Cc: s.nawrocki@samsung.com
Date: Tue, 25 Mar 2014 16:56:07 -0400
In-Reply-To: <1395780301.11851.14.camel@nicolas-tpx230>
References: <1395780301.11851.14.camel@nicolas-tpx230>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-yTBM6p96gXv+t/duwORT"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-yTBM6p96gXv+t/duwORT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

All YUV 422 has 16bit per pixels.

Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
---
 drivers/media/platform/exynos4-is/fimc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/=
platform/exynos4-is/fimc-core.c
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



--=-yTBM6p96gXv+t/duwORT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlMx7WcACgkQcVMCLawGqBy5fQCePFNGALVvVm3pqklqQ+zbd8t7
NEMAoM+q4jEgAAXRF252Uy0OdovLe5wP
=sNoN
-----END PGP SIGNATURE-----

--=-yTBM6p96gXv+t/duwORT--

