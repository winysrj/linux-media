Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59998 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732266AbeHCQif (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Aug 2018 12:38:35 -0400
Date: Fri, 3 Aug 2018 15:41:53 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: 698668@bugs.debian.org, linux-media <linux-media@vger.kernel.org>
Message-ID: <20180803144153.GA18030@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
Subject: [PATCH] Documentation/media: uapi: Explicitly say there are no
 Invariant Sections
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The GNU Free Documentation License allows for a work to specify
Invariant Sections that are not allowed to be modified.  (Debian
considers that this makes such works non-free.)

The Linux Media Infrastructure userspace API documentation does not
specify any such sections, but it also doesn't say there are none (as
is recommended by the license text).  Make it explicit that there are
none.

References: https://bugs.debian.org/698668
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/media/media_uapi.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/media_uapi.rst b/Documentation/media/media=
_uapi.rst
index 28eb35a1f965..5198ff24a094 100644
--- a/Documentation/media/media_uapi.rst
+++ b/Documentation/media/media_uapi.rst
@@ -10,9 +10,9 @@ Linux Media Infrastructure userspace API
=20
 Permission is granted to copy, distribute and/or modify this document
 under the terms of the GNU Free Documentation License, Version 1.1 or
-any later version published by the Free Software Foundation. A copy of
-the license is included in the chapter entitled "GNU Free Documentation
-License".
+any later version published by the Free Software Foundation, with no
+Invariant Sections. A copy of the license is included in the chapter
+entitled "GNU Free Documentation License".
=20
 .. only:: html
=20

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBW2Rpsee/yOyVhhEJAQocIg//WRG5v+6QYqbBTDGqapTEpTtCY1/2Z6vv
1sasThrIhcAoKT7TwJIpQVLPF3+GlaV2v5wkVldDrS5mBx0Ty/j8KE21Zho27Rkm
szERDyDFquBTmForZf646wjDGhu8gaWscU2/Ys/dPITXaDViNs2hSiE82PjJEslM
dHJWbltXd4rjDX6G3y8G1810kR46tRaZNMXLHT5gY4afECkHGvFthdjSUD6SN0ef
LbFPFnioKBhAKAr9BO5kd3jo/mE6ys0dX2g3oecJiwFUUdXSNVf6ymjHh7EF+n9I
8AoDrb5v9VflXtgZgaWjYVKaNBQotM+5RlSwX4svr8g6g5sTzRjfk9fCCBLArbPm
awWHMeNXR8hSfh6YLcK78mjijwwbKvd/2jctJBsprL+Hh61/VPKyOfZErvSsbS/2
EOo+JxVuB45eMeb4gsiLC5yLbFGHsy8PvCuTzzRat06bBAe9uhA95uVHiky17AXC
ZZcQumLtKRWo6MJFMFIjHOdY0V9CcIPBU/tBh2zqAjWYqE5a7VfLQsLlwrmUg8zz
73LEaFFg56kz8SS5goPEPJgCMN6dzqJXMP2WmVDP7mnto3k9e/Ub6Uj4BSRGW5WT
MriW5eJuN2+gfRVuBGsdXiIQE+bg/QXTGp1kdT3r4DDO/FJyS93M5n5I9/T8Q0c8
qzrZwVb+6fQ=
=19Fm
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
