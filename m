Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:45927 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab2DCJIu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Apr 2012 05:08:50 -0400
Date: Tue, 3 Apr 2012 11:08:45 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH] fc0011: use usleep_range()
Message-ID: <20120403110845.629c1c82@milhouse>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/akjk4z5Vy5XNztd8m0xxBOJ"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/akjk4z5Vy5XNztd8m0xxBOJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Use usleep_range() instead of msleep() to improve power saving opportunitie=
s.

Signed-off-by: Michael Buesch <m@bues.ch>

---

Index: linux/drivers/media/common/tuners/fc0011.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/media/common/tuners/fc0011.c	2012-04-03 10:44:07.243=
418827 +0200
+++ linux/drivers/media/common/tuners/fc0011.c	2012-04-03 10:46:29.34285133=
6 +0200
@@ -167,7 +167,7 @@
 	err =3D fc0011_writereg(priv, FC11_REG_VCOCAL, FC11_VCOCAL_RUN);
 	if (err)
 		return err;
-	msleep(10);
+	usleep_range(10000, 20000);
 	err =3D fc0011_readreg(priv, FC11_REG_VCOCAL, value);
 	if (err)
 		return err;
@@ -423,7 +423,7 @@
 	err =3D fc0011_vcocal_read(priv, NULL);
 	if (err)
 		return err;
-	msleep(10);
+	usleep_range(10000, 50000);
=20
 	err =3D fc0011_readreg(priv, FC11_REG_RCCAL, &regs[FC11_REG_RCCAL]);
 	if (err)


--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/akjk4z5Vy5XNztd8m0xxBOJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPer4dAAoJEPUyvh2QjYsOYb0P/1WlJvwD4c+6FstzVO0YXZPq
5tObRcDIZbukQY2S7vCJNwCr/lfGq3wVQd81ucMchm06u3bKW1xdnKP8q/pl+2vu
0cH6XTZvMqju/cdyEWrnLD+8RXxyW/KB04UDc/Ve94SWQHKAUY7ZxNEDdCSY3QKI
foZPV0kAA2RENnZFQbWqzBFnXPNrSMhuXQFdN4y5kScIP8Ogc06xVeEN88Ypcap+
3w31Bfolva1jtTz3uX8/Iu+Jap7VOrzHBp8qau5Dlszk2zPH8z8GL8IpqX2kbrsQ
cgHVM0xYjwWBp1y35o4VWMEC9AiJJP9hsVh5u8OzBAc2/t1B5xiBRiabeepFuSaB
X/3qm9TtEJzxPIHwav/FfOFUdmPSVePkhO2TBtKliK+A0+qzjWVntqaDk0BQpwgs
a/wium2BDxU9aamywEpaH5g6NbVRA0ld7zSqfP5vbPg3Ts+18YmN1KuDu1hgGNFA
du6Lr6cknA9mCgfz2JCNNRMc+u8lHE8T6UGYz6MeoQ2y7Y0nyP7KQ2GuuYfZeKVX
eC/1QioRZfRbx/LEsu1lkQEW0XwlDdU/fRREfAw/mEMHq6xu9+aBkXXxWzHgVufm
JHqPZ+cDZISzEMvFOi9rbcfPWNgaaUnkx1mBK3AExbIKJjXvc8cXptXtfEjDjbAc
h9r7PpqZkmbEWWqCCtgM
=V843
-----END PGP SIGNATURE-----

--Sig_/akjk4z5Vy5XNztd8m0xxBOJ--
