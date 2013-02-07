Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:33775 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759047Ab3BGRFo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Feb 2013 12:05:44 -0500
Date: Thu, 7 Feb 2013 17:16:55 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH 2/4] fc0011: Fix xin value clamping
Message-ID: <20130207171655.4243e21f@milhouse>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/RodfLT/pvpedfWvL_kd=b/Y"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/RodfLT/pvpedfWvL_kd=b/Y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Fix the xin value clamping and use clamp_t().

Signed-off-by: Michael Buesch <m@bues.ch>

---

Index: linux/drivers/media/tuners/fc0011.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/media/tuners/fc0011.c	2012-10-22 16:13:29.140465225 =
+0200
+++ linux/drivers/media/tuners/fc0011.c	2012-10-22 16:15:46.915056243 +0200
@@ -183,8 +183,7 @@
 	unsigned int i, vco_retries;
 	u32 freq =3D p->frequency / 1000;
 	u32 bandwidth =3D p->bandwidth_hz / 1000;
-	u32 fvco, xin, xdiv, xdivr;
-	u16 frac;
+	u32 fvco, xin, frac, xdiv, xdivr;
 	u8 fa, fp, vco_sel, vco_cal;
 	u8 regs[FC11_NR_REGS] =3D { };
=20
@@ -227,12 +226,8 @@
 		frac +=3D 32786;
 	if (!frac)
 		xin =3D 0;
-	else if (frac < 511)
-		xin =3D 512;
-	else if (frac < 65026)
-		xin =3D frac;
 	else
-		xin =3D 65024;
+		xin =3D clamp_t(u32, frac, 512, 65024);
 	regs[FC11_REG_XINHI] =3D xin >> 8;
 	regs[FC11_REG_XINLO] =3D xin;
=20


--=20
Greetings, Michael.

PGP: 908D8B0E

--Sig_/RodfLT/pvpedfWvL_kd=b/Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRE9N3AAoJEPUyvh2QjYsOKTwP/01gc6smTIvMKw3eCvpA4InU
HQKeeE2Yt0c6JA3wpqyfHQ30MXEfzBcun3tFPMCqTtggxzPB0rXFg4QTDtWGhukN
FXpV9RC6ttQCMyWNWOY1ASZUI6NVzySWvT4XjysTCt9EB9nXUyK5zVxgN6CUwoMF
cJz/7o+2AWHnjwJktv1VXiGYZPo+b5GHYpNa9LpYLeLNxNJ5RJ81Xz0YOCrcnSO5
s7ukQKkC0aoZgNqAt/AJphLhjlFsGCXEdccG7yl7P26QseZM42uwHlHc//ia9JIo
CYSp6yz7sE4tjvO3HCCeNwDILiUwUZqOpK+6Zs8GGOuvt0E4ugEe7znnhT7cH1fK
p5GELI34oepIFSwJc9pCPfxXnGacrmLpapnbgyDdWnEsu3GCs0e8YNraQzeAmtw6
Ok0+ClaIngxcEIkzGtfBW04Ia1yjujl3jU/4IrKSwKWttlek6YV85uhP7pPeYkM5
kDpZqDEHB3+0CX92mwe3mDCWmFETpJY9s4DVKbeDQYdmRZ5wWFhv0G/fwxKzYDqT
r/xaJJx0UQnbqIczZHZ55Suiflc7+b6pH7mI7KA26Eh2+sxTi7ZEDehvWBIkKxLA
mauUXqnViFa+d78erdMFip8nkVPSrBvzhDy7TDAKDdKYreunrDnRiKKt4VmQ5R4e
tEL2wmHQyySAqOwYXZLE
=Y11w
-----END PGP SIGNATURE-----

--Sig_/RodfLT/pvpedfWvL_kd=b/Y--
