Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44459 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755050Ab3IECcg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Sep 2013 22:32:36 -0400
Message-ID: <1378348354.27597.18.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH v2 4/4] [media] lirc_bt829: Note in TODO why it can't be a
 normal PCI driver yet
From: Ben Hutchings <ben@decadent.org.uk>
To: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Date: Thu, 05 Sep 2013 03:32:34 +0100
In-Reply-To: <1378348215.27597.14.camel@deadeye.wl.decadent.org.uk>
References: <1378348215.27597.14.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-iUdp9dw8k7NmB8AQHJ+X"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-iUdp9dw8k7NmB8AQHJ+X
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/media/lirc/TODO | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/media/lirc/TODO b/drivers/staging/media/lirc/T=
ODO
index b6cb593..cbea5d8 100644
--- a/drivers/staging/media/lirc/TODO
+++ b/drivers/staging/media/lirc/TODO
@@ -2,6 +2,11 @@
   (see drivers/media/IR/mceusb.c vs. lirc_mceusb.c in lirc cvs for an
   example of a previously completed port).
=20
+- lirc_bt829 uses registers on a Mach64 VT, which has a separate kernel
+  framebuffer driver (atyfb) and userland X driver (mach64).  It can't
+  simply be converted to a normal PCI driver, but ideally it should be
+  coordinated with the other drivers.
+
 Please send patches to:
 Jarod Wilson <jarod@wilsonet.com>
 Greg Kroah-Hartman <greg@kroah.com>


--=-iUdp9dw8k7NmB8AQHJ+X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUiftQue/yOyVhhEJAQrYRw//UqB21FDOi+de8SA9pk4HTOLLY7q7e46N
dLsLhTsED1dSj3qwgHRcmbRwreyjsBYwQ3w3kY73Mh8l7LkC1x+LtMbIyy1/u23d
hwJ3MRalZpinnDcb9ZNQ26FNBJPoVbr80HBXps5djT7IIqgsothkS0OHsQ4CY2sk
N/Vep2WaBqg0kOQJOGj9TMbS1qd3fu6cLrEWorEXFy3heKkjc55EJKaX7cNiXLsh
67M5z5o8Yq6cXEqOMP0VoPOvR+T+Bzg6cxb0eX0tO41btMU7ZAZBOuvVmNkx69xj
vU1xc7Yho5sRibCbkXylP/1ofufXzVKJgae5q1m3IC7jDTH4NbZHDIo2BC0BVLZC
0VqHN1CAUmlT2EmwRhyY6oa5PeJjr+d5VTuTUds/YU88eohjjQFmlnS2MWMeJNJx
N0+gKTzQkoF5NZVqyyg35hl6EDD4ejEbSIr7GmXy4QeX4GcR96PtSwXpiPY7XGFN
yfvElO14Aa7a7gHTEUKu2Ew2FA3AOnEfww00ZfWE031QkkJwOHTbBKtttoX8qSlE
blcV94g6FYLur6OyBYdi3ZzXkgtltdFbMbyNkvFbcT6s1Qn9QliaI1fPdRsKT3Hu
Hmm8Wb8asCkbgn9RgffOe48CoRgamVjY6RK7Q91LwcHHD8rJeOVpuVYJn/JcGotL
d9qVUnIX2dA=
=Ch6C
-----END PGP SIGNATURE-----

--=-iUdp9dw8k7NmB8AQHJ+X--
