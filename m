Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:34256 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbaCYUwf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 16:52:35 -0400
Message-ID: <1395780751.11851.19.camel@nicolas-tpx230>
Subject: [PATCH 4/5] s5p-fimc: Iterate for each memory plane
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: LMML <linux-media@vger.kernel.org>
Cc: s.nawrocki@samsung.com
Date: Tue, 25 Mar 2014 16:52:31 -0400
In-Reply-To: <1395780301.11851.14.camel@nicolas-tpx230>
References: <1395780301.11851.14.camel@nicolas-tpx230>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-KUfMYRzXWp2vnYzp7fws"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-KUfMYRzXWp2vnYzp7fws
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Depth and payload is defined per memory plane. It's better to iterate using
number of memory planes. This was not causing much issue since the rest
of the arrays involved where intialized to zero.

Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
---
 drivers/media/platform/exynos4-is/fimc-core.c | 2 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/=
platform/exynos4-is/fimc-core.c
index 0e94412..ab9450b 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -450,7 +450,7 @@ void fimc_prepare_dma_offset(struct fimc_ctx *ctx, stru=
ct fimc_frame *f)
 	bool pix_hoff =3D ctx->fimc_dev->drv_data->dma_pix_hoff;
 	u32 i, depth =3D 0;
=20
-	for (i =3D 0; i < f->fmt->colplanes; i++)
+	for (i =3D 0; i < f->fmt->memplanes; i++)
 		depth +=3D f->fmt->depth[i];
=20
 	f->dma_offset.y_h =3D f->offs_h;
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/p=
latform/exynos4-is/fimc-m2m.c
index 36971d9..07b8f97 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -342,7 +342,7 @@ static void __set_frame_format(struct fimc_frame *frame=
, struct fimc_fmt *fmt,
 {
 	int i;
=20
-	for (i =3D 0; i < fmt->colplanes; i++) {
+	for (i =3D 0; i < fmt->memplanes; i++) {
 		frame->bytesperline[i] =3D pixm->plane_fmt[i].bytesperline;
 		frame->payload[i] =3D pixm->plane_fmt[i].sizeimage;
 	}
@@ -461,7 +461,7 @@ static int fimc_m2m_try_crop(struct fimc_ctx *ctx, stru=
ct v4l2_crop *cr)
 	else
 		halign =3D ffs(fimc->variant->min_vsize_align) - 1;
=20
-	for (i =3D 0; i < f->fmt->colplanes; i++)
+	for (i =3D 0; i < f->fmt->memplanes; i++)
 		depth +=3D f->fmt->depth[i];
=20
 	v4l_bound_align_image(&cr->c.width, min_size, f->o_width,
--=20
1.8.5.3



--=-KUfMYRzXWp2vnYzp7fws
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlMx7I8ACgkQcVMCLawGqBw4lACdFw+xCjlpupCa0B4W8jYO6ceO
3XoAnjNosFKL0HzPPOiJCixDjZ7v0t4F
=3M0a
-----END PGP SIGNATURE-----

--=-KUfMYRzXWp2vnYzp7fws--

