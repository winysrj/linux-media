Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:33773 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757499Ab3BGRFl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Feb 2013 12:05:41 -0500
Date: Thu, 7 Feb 2013 17:21:06 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH 4/4] fc0011: Return early, if the frequency is already tuned
Message-ID: <20130207172106.1c8f4dd7@milhouse>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/N4X2zqWFhfZdWkL6DK7pu1y"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/N4X2zqWFhfZdWkL6DK7pu1y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Return early, if we already tuned to a frequency.

Signed-off-by: Michael Buesch <m@bues.ch>

---

Index: linux/drivers/media/tuners/fc0011.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/media/tuners/fc0011.c	2013-01-01 23:25:40.000000000 =
+0100
+++ linux/drivers/media/tuners/fc0011.c	2013-01-01 23:27:44.985089712 +0100
@@ -187,6 +187,9 @@
 	u8 fa, fp, vco_sel, vco_cal;
 	u8 regs[FC11_NR_REGS] =3D { };
=20
+	if (priv->frequency =3D=3D p->frequency)
+		return 0;
+
 	regs[FC11_REG_7] =3D 0x0F;
 	regs[FC11_REG_8] =3D 0x3E;
 	regs[FC11_REG_10] =3D 0xB8;


--=20
Greetings, Michael.

PGP: 908D8B0E

--Sig_/N4X2zqWFhfZdWkL6DK7pu1y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRE9RyAAoJEPUyvh2QjYsOzmkP/3sRvZSy4FVAAPQSapYTwHPb
7msH6UFYLHVJQ1pwuRvne3AqNDWp8RhSkuAu3i89pInu/TscsaFpV0BTt2RxxHNQ
BaWqgSco+PKfhbQPd/wO+ggY3GLKji/JkzG2z4hWM27nsjG3AHdj9dnAsjRZkMYa
sXj0PSl2mAO9Yrqi4XvLWZzaNQIjzt9qXfUya2OuyEMs6ryMS8xf6zhqQb5mpfFY
AlvRUPobkUNsMf4olgoX6zHz28qGChXuivuR3exVEscY2k70KRvp73xz8uPNSUuF
Qsf7d/uzWaB9dO9FbllBS9HH9vjKWl8y2wXHF8bO9B8/FrKwj/c6nBMma8uDN3H1
fs9pSVxgKf7+MEfYoZ5uKbBUp+VGKwsh4fbjVx8xF1gNHuR/KdOGZf7cbXvBE6mY
dpFALREqA/LNQ5Twnl/wV6ETnCVcr3BMjhPokqT3uhO+MeMYXNLvpvh3kvJe6Hvu
i6MkK8zQwZrW/Dg76jXzs2ETTT5+b3KLxFwV7j5L+E0ScKT2NcY6nj0STq4F4zt7
7BYos4X5E3ZfAGZggBrbykDKHNS5sLKVKK/e38TB8lMDG4qlDkGjuIWtwz0XBRdH
ECjyW+2k42Z//YlEjJ1mjEIpddhDPeOrEFrg05v+iNqQXaPEgZMpOek8c2fbLzSl
LwEAHkDYgNcZbos4hRj4
=S1Ov
-----END PGP SIGNATURE-----

--Sig_/N4X2zqWFhfZdWkL6DK7pu1y--
