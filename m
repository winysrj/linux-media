Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:45932 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab2DCJLf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Apr 2012 05:11:35 -0400
Date: Tue, 3 Apr 2012 11:11:30 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH] af9035: Use usleep_range() in fc0011 support code
Message-ID: <20120403111130.6a41e347@milhouse>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Zf6IIa+wywP6t=4/ZoQ6zZt"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/Zf6IIa+wywP6t=4/ZoQ6zZt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Use usleep_range() instead of msleep() to improve power saving opportunitie=
s.

Signed-off-by: Michael Buesch <m@bues.ch>

---

Index: linux/drivers/media/dvb/dvb-usb/af9035.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/media/dvb/dvb-usb/af9035.c	2012-04-03 10:49:18.27036=
4916 +0200
+++ linux/drivers/media/dvb/dvb-usb/af9035.c	2012-04-03 10:49:57.495125781 =
+0200
@@ -590,7 +590,7 @@
 		err =3D af9035_wr_reg_mask(d, 0xd8d1, 1, 1);
 		if (err)
 			return err;
-		msleep(10);
+		usleep_range(10000, 50000);
 		break;
 	case FC0011_FE_CALLBACK_RESET:
 		err =3D af9035_wr_reg(d, 0xd8e9, 1);
@@ -602,11 +602,11 @@
 		err =3D af9035_wr_reg(d, 0xd8e7, 1);
 		if (err)
 			return err;
-		msleep(10);
+		usleep_range(10000, 20000);
 		err =3D af9035_wr_reg(d, 0xd8e7, 0);
 		if (err)
 			return err;
-		msleep(10);
+		usleep_range(10000, 20000);
 		break;
 	default:
 		return -EINVAL;


--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/Zf6IIa+wywP6t=4/ZoQ6zZt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPer7CAAoJEPUyvh2QjYsOHzYP/2eUoAy8G8BgQRgEMPlUCPNr
m1tohffdre5qnw467Xvw+EgsFR6hx2+1pgfe8QHwbnjd99g+5xGqBGFfIOe0tlOt
YBMy2uMmdQJQWjYigMfTQpoAM+4sNZOjnohUh0s1KPUKB9uI6+QEjGC0q/HYqEqZ
2ctPo0JfzuqvCl5UFNhyCXbBcga5LPd6iQna9Y5HzZdacKE2ggMoTpyCXQUwPN8w
6c8c0wb8YqzAishUw4pmaseLbUZitn6ExujhwHstYNCSKnnbbw1aI4S4loof/EOL
DfMkVaRU7Xi3Z3greJof/M7HCLq+KZWJkUM0THOh7abox5t9C7MuLwE7jJ1C2BJL
bqmnMgGJpMb8cCjFC2ee9/iacRu7NRNWb1KRmYyAB0GkOFfwH+kan+lGmdvQ/mPo
hM5u0l5IwH/Ew+0yYffhjqX21GMfXFMNLkrUjzo0iLBGicSzje8uipsjTlYJYiUP
yasoTCJy2cxlzP+1q++L5WWs5qmwkKaMD0ppHn3kYVgoPMU6pDGmK6sNXLpnnsUZ
x/2S+qOKcPr9xt5gJAQO27B9U4016AlNbfGJGQOBeBngoJipys8iicIo9iNS2Uex
aQxjdDFC+l9hKar8T4/T7Fc8C8ugD6p9eJZfJglQwxCZvXo1BvRnA6eq3cfDTWAt
4Xtou05qIAQJ+PVqACyb
=PxXg
-----END PGP SIGNATURE-----

--Sig_/Zf6IIa+wywP6t=4/ZoQ6zZt--
