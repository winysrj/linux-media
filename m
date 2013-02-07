Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:33774 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758939Ab3BGRFn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Feb 2013 12:05:43 -0500
Date: Thu, 7 Feb 2013 17:13:13 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH 1/4] fc0011: fp/fa value overflow fix
Message-ID: <20130207171313.272e9078@milhouse>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vNXkq3u=6zfiw49iMfqQ=89"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/vNXkq3u=6zfiw49iMfqQ=89
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Assign the maximum instead of masking with the maximum on value overflow.

Signed-off-by: Michael Buesch <m@bues.ch>

---

Index: linux/drivers/media/tuners/fc0011.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/media/tuners/fc0011.c	2012-10-22 16:11:27.634183359 =
+0200
+++ linux/drivers/media/tuners/fc0011.c	2012-10-22 16:13:29.140465225 +0200
@@ -247,8 +247,8 @@
 		fa +=3D 8;
 	}
 	if (fp > 0x1F) {
-		fp &=3D 0x1F;
-		fa &=3D 0xF;
+		fp =3D 0x1F;
+		fa =3D 0xF;
 	}
 	if (fa >=3D fp) {
 		dev_warn(&priv->i2c->dev,


--=20
Greetings, Michael.

PGP: 908D8B0E

--Sig_/vNXkq3u=6zfiw49iMfqQ=89
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRE9KZAAoJEPUyvh2QjYsO2JEP+wR0hcOj0ZdW78ayDr9guq1A
QUUGVCZLSxD4V5heze4/JgW1WhSJVJuX+9U6SG1A9z6nks1S3uk88CkXNVGLdlgG
JkHodTZAttukQwIrCJNkBh5B65oEYNzoPxufFO8TJfjm/PthTzFhCSepGx1K+a56
0hn7VgY1zhV9/U6aSZYXJUNKcVOf/kNES3IgVzh7Wc53QYUTLSIxbCJ7ZZIKi8dR
8hgsSo+dUysp1e9kD2C2Sd9kyyUrxwsm/U9kPHDtuHufm5Hc36Ta6ci7XwAgIP4E
N+KTJN5ipqb5A1+E1gJpIaRtyHx5MhY1SdxyIa4v+Iz5YSR+6FKGKCpBEWE4iqPV
LFwsR1lmwKWwmsQP/z0S6iJ7avjdS5dJdQlnryasKDDaREjjV9xdeP4FRVyDOx9S
xvoUJwH6qTjqKjZsKEPXt7LXWHyZY+2lRRG1eoEC0GJCFTZ81kCFZB3a0PhDaBAH
pZ5NY1GUscAOiuziPZN/HNYeWw5QnQBYID19FxCaVQQdn6i4y0jr+jLEs/gTLEOe
LhaIumLnfPvD1AtETAYo2oPrX38+oaKt/U4ijsH9RGQ18lYmMNqhkzUHY+m9FPVU
9GhaUMot9O6nbzJqQ6I2Oqtqelf0T6W3tv5KATFx1CmGbSG+cDLb2JTSGCio0IX8
Re2Pp+MX3HqIc5mc0IIW
=A/+Y
-----END PGP SIGNATURE-----

--Sig_/vNXkq3u=6zfiw49iMfqQ=89--
