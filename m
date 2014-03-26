Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:34937 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbaCZWso (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Mar 2014 18:48:44 -0400
Message-ID: <1395874119.32312.28.camel@nicolas-tpx230>
Subject: [PATCH 3/5] s5p-fimc: Roundup imagesize to row size for tiled
 formats
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: LMML <linux-media@vger.kernel.org>
Cc: s.nawrocki@samsung.com
Date: Wed, 26 Mar 2014 18:48:39 -0400
In-Reply-To: <1395873527.32312.27.camel@nicolas-tpx230>
References: <1395780301.11851.14.camel@nicolas-tpx230>
	 <1395780682.11851.18.camel@nicolas-tpx230>
	 <1395873527.32312.27.camel@nicolas-tpx230>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-m0Coo0PWvE54DioDesex"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-m0Coo0PWvE54DioDesex
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

For tiled format, we need to allocated a multiple of the row size. A
good example is for 1280x720, wich get adjusted to 1280x736. In tiles,
this mean Y plane is 20x23 and UV plane 20x12. Because of the rounding,
the previous code would only have enough space to fit half of the last
row.

Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
---
 drivers/media/platform/exynos4-is/fimc-core.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/=
platform/exynos4-is/fimc-core.c
index 2e70fab..7ea15ef 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -736,6 +736,7 @@ void fimc_adjust_mplane_format(struct fimc_fmt *fmt, u3=
2 width, u32 height,
 	for (i =3D 0; i < pix->num_planes; ++i) {
 		struct v4l2_plane_pix_format *plane_fmt =3D &pix->plane_fmt[i];
 		u32 bpl =3D plane_fmt->bytesperline;
+		u32 sizeimage;
=20
 		if (fmt->colplanes > 1 && (bpl =3D=3D 0 || bpl < pix->width))
 			bpl =3D pix->width; /* Planar */
@@ -755,8 +756,16 @@ void fimc_adjust_mplane_format(struct fimc_fmt *fmt, u=
32 width, u32 height,
 			bytesperline /=3D 2;
=20
 		plane_fmt->bytesperline =3D bytesperline;
-		plane_fmt->sizeimage =3D max((pix->width * pix->height *
-				   fmt->depth[i]) / 8, plane_fmt->sizeimage);
+		sizeimage =3D pix->width * pix->height * fmt->depth[i] / 8;
+
+		/* Ensure full last row for tiled formats */
+		if (tiled_fmt(fmt)) {
+			/* 64 * 32 * plane_fmt->bytesperline / 64 */
+			u32 row_size =3D plane_fmt->bytesperline * 32;
+			sizeimage =3D roundup(sizeimage, row_size);
+		}
+
+		plane_fmt->sizeimage =3D max(sizeimage, plane_fmt->sizeimage);
 	}
 }
=20
--=20
1.8.5.3

--=-m0Coo0PWvE54DioDesex
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlMzWUcACgkQcVMCLawGqBzF3gCgu+1EBK4g5FQQ9Gvspgcb3iSY
uOgAoJ0bcgyE9MiFhWkaq8UAn98dhnib
=wZjb
-----END PGP SIGNATURE-----

--=-m0Coo0PWvE54DioDesex--

