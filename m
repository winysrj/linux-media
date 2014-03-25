Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:34245 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbaCYUpG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 16:45:06 -0400
Message-ID: <1395780301.11851.14.camel@nicolas-tpx230>
Subject: [PATCH 0/5] s5p-fimc: Misc fixes
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: LMML <linux-media@vger.kernel.org>
Cc: s.nawrocki@samsung.com
Date: Tue, 25 Mar 2014 16:45:01 -0400
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-xz2227++Z4lA3oKW8FKM"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-xz2227++Z4lA3oKW8FKM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This patch series fixes several bugs found in the s5p-fimc driver. These
bugs relate to bad parameters in the formats definition and short size
of image buffers.

Nicolas Dufresne (5):
  s5p-fimc: Reuse calculated sizes
  s5p-fimc: Iterate for each memory plane
  s5p-fimc: Align imagesize to row size for tiled formats
  s5p-fimc: Fix YUV422P depth
  s5p-fimc: Changed RGB32 to BGR32

 drivers/media/platform/exynos4-is/fimc-core.c | 21 +++++++++++++++------
 drivers/media/platform/exynos4-is/fimc-m2m.c  |  6 +++---
 2 files changed, 18 insertions(+), 9 deletions(-)


--=-xz2227++Z4lA3oKW8FKM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlMx6s0ACgkQcVMCLawGqBxMnwCfT88D37VLgifZfClSKxWB5RmO
RbcAn1vTRzbH99naZfo1RPka9+hYr0DD
=pKFw
-----END PGP SIGNATURE-----

--=-xz2227++Z4lA3oKW8FKM--

