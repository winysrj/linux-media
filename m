Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:33776 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759069Ab3BGRFp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Feb 2013 12:05:45 -0500
Date: Thu, 7 Feb 2013 17:19:30 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH 3/4] fc0011: Add some sanity checks and cleanups
Message-ID: <20130207171930.134fd97f@milhouse>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Ap3EW4+2O7lbT9aQiQ1OmaD"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/Ap3EW4+2O7lbT9aQiQ1OmaD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Add some sanity checks to the calculations and make the REG_16 register wri=
te consistent
with the other ones.

Signed-off-by: Michael Buesch <m@bues.ch>

---

Index: linux/drivers/media/tuners/fc0011.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/media/tuners/fc0011.c	2012-10-22 16:15:46.000000000 =
+0200
+++ linux/drivers/media/tuners/fc0011.c	2012-10-22 16:17:15.280720317 +0200
@@ -220,6 +220,7 @@
=20
 	/* Calc XIN. The PLL reference frequency is 18 MHz. */
 	xdiv =3D fvco / 18000;
+	WARN_ON(xdiv > 0xFF);
 	frac =3D fvco - xdiv * 18000;
 	frac =3D (frac << 15) / 18000;
 	if (frac >=3D 16384)
@@ -346,6 +347,8 @@
 	vco_cal &=3D FC11_VCOCAL_VALUEMASK;
=20
 	switch (vco_sel) {
+	default:
+		WARN_ON(1);
 	case 0:
 		if (vco_cal < 8) {
 			regs[FC11_REG_VCOSEL] &=3D ~(FC11_VCOSEL_1 | FC11_VCOSEL_2);
@@ -427,7 +430,8 @@
 	err =3D fc0011_writereg(priv, FC11_REG_RCCAL, regs[FC11_REG_RCCAL]);
 	if (err)
 		return err;
-	err =3D fc0011_writereg(priv, FC11_REG_16, 0xB);
+	regs[FC11_REG_16] =3D 0xB;
+	err =3D fc0011_writereg(priv, FC11_REG_16, regs[FC11_REG_16]);
 	if (err)
 		return err;
=20


--=20
Greetings, Michael.

PGP: 908D8B0E

--Sig_/Ap3EW4+2O7lbT9aQiQ1OmaD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRE9QSAAoJEPUyvh2QjYsO574P/RNprTej7sGSQME/A/2WYtGJ
38/xAwR0BDZx0IyRVbPztiUOXh9TRpItePDcc4iRkpgxXJZPl61JY7bs2telox+n
xgVqcfqU8s1bPULVDKUNMQ0tPRazTNgjWeddxtvjmfELdOnV2qNM6hNdNbNH+3iY
c73EmviY4xgPFJtfRZ6RXn0i2/ihX7xdVFeHca+dzZXjOD6EKL5IaCy801uE0SqB
kq8XPfpFYn6Yy2kDO0PAx21BxvNpqA0e0KbCUZOIQeu2Kj5NacRD7KbVyzIKwr5c
bUqCekQdL4KvgAgndyVbqDypjPkKfF+A/FdBMTpu7cHo8CU6C0aJz/EgI2ZFnI/+
bsLEEpus7bt5tigAM7Sx4bIasbpdAC/RqEN945dWcwmu40OGU7yk/9zn4tbBfuOY
du8k1a9BNzizeUGz00aG+tZoZXmOfsEsPHIB2G1pnqiES512BVnX7dVYoBRnTq88
jTelNwnDc8VimvprY9Uc0qg3DrtVOoK6e3dCey37bsdwte+OWUDKVIGDkalHgglP
qEBNV9yeN+wdHDKtSnmmCokyCr/RJOHJX/Xq2/uV3/O/sVhouXjlMarRa+nrjlAM
uzwcXTw8BdyLQP7984r/Oslvho0hs/afgh8tcGV16H4eAYk6aJQyHQszDTR62jQs
8Zp7TAo0xl2QQy6NeEPL
=m6Pm
-----END PGP SIGNATURE-----

--Sig_/Ap3EW4+2O7lbT9aQiQ1OmaD--
