Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:34258 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbaCYUxh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 16:53:37 -0400
Message-ID: <1395780812.11851.20.camel@nicolas-tpx230>
Subject: [PATCH 5/5] s5p-fimc: Reuse calculated sizes
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: LMML <linux-media@vger.kernel.org>
Cc: s.nawrocki@samsung.com
Date: Tue, 25 Mar 2014 16:53:32 -0400
In-Reply-To: <1395780301.11851.14.camel@nicolas-tpx230>
References: <1395780301.11851.14.camel@nicolas-tpx230>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-kbFo81h4lGojY32n7j5k"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-kbFo81h4lGojY32n7j5k
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This formula did not take into account the required tiled alignement for
NV12MT format. As this was already computed an stored in payload array
initially, reuse that value.

Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
---
 drivers/media/platform/exynos4-is/fimc-m2m.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/p=
latform/exynos4-is/fimc-m2m.c
index 07b8f97..c648e5f 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -197,7 +197,7 @@ static int fimc_queue_setup(struct vb2_queue *vq, const=
 struct v4l2_format *fmt,
=20
 	*num_planes =3D f->fmt->memplanes;
 	for (i =3D 0; i < f->fmt->memplanes; i++) {
-		sizes[i] =3D (f->f_width * f->f_height * f->fmt->depth[i]) / 8;
+		sizes[i] =3D f->payload[i];
 		allocators[i] =3D ctx->fimc_dev->alloc_ctx;
 	}
 	return 0;
--=20
1.8.5.3



--=-kbFo81h4lGojY32n7j5k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlMx7MwACgkQcVMCLawGqBxU5QCgvQYK4obP6wGOH5kmvk2OWkDY
GW4An0WSzmw0OLRychsNdIKDJ5zev/k0
=KZXx
-----END PGP SIGNATURE-----

--=-kbFo81h4lGojY32n7j5k--

