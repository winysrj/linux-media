Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:34259 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbaCYUz3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 16:55:29 -0400
Message-ID: <1395780923.11851.21.camel@nicolas-tpx230>
Subject: [PATCH 1/5] s5p-fimc: Changed RGB32 to BGR32
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: LMML <linux-media@vger.kernel.org>
Cc: s.nawrocki@samsung.com
Date: Tue, 25 Mar 2014 16:55:23 -0400
In-Reply-To: <1395780301.11851.14.camel@nicolas-tpx230>
References: <1395780301.11851.14.camel@nicolas-tpx230>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-gEVTH/OG56WLV2BgwFKZ"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-gEVTH/OG56WLV2BgwFKZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Testing showed that HW produces BGR32 rather then RGB32 as exposed
in the driver. The documentation seems to state the pixels are stored
in little endian order.

Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
---
 drivers/media/platform/exynos4-is/fimc-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/=
platform/exynos4-is/fimc-core.c
index da2fc86..bfb80fb 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -56,8 +56,8 @@ static struct fimc_fmt fimc_formats[] =3D {
 		.colplanes	=3D 1,
 		.flags		=3D FMT_FLAGS_M2M,
 	}, {
-		.name		=3D "ARGB8888, 32 bpp",
-		.fourcc		=3D V4L2_PIX_FMT_RGB32,
+		.name		=3D "BGRB888, 32 bpp",
+		.fourcc		=3D V4L2_PIX_FMT_BGR32,
 		.depth		=3D { 32 },
 		.color		=3D FIMC_FMT_RGB888,
 		.memplanes	=3D 1,
--=20
1.8.5.3



--=-gEVTH/OG56WLV2BgwFKZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlMx7TsACgkQcVMCLawGqBxUwgCeL430AqdXTa09nfG3d0nd2BqA
j+oAoNrTxSBs9gct2TbyfERZyBITHwnT
=OqFo
-----END PGP SIGNATURE-----

--=-gEVTH/OG56WLV2BgwFKZ--

