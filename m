Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:45916 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab2DCJFM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Apr 2012 05:05:12 -0400
Date: Tue, 3 Apr 2012 11:05:03 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH] fc0011: Reduce number of retries
Message-ID: <20120403110503.392c8432@milhouse>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/MAjqN74ROLgNqcL3rvD7w7D"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/MAjqN74ROLgNqcL3rvD7w7D
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Now that i2c transfers are fixed, 3 retries are enough.

Signed-off-by: Michael Buesch <m@bues.ch>

---

Index: linux/drivers/media/common/tuners/fc0011.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/media/common/tuners/fc0011.c	2012-04-03 08:48:39.000=
000000 +0200
+++ linux/drivers/media/common/tuners/fc0011.c	2012-04-03 10:44:07.24341882=
7 +0200
@@ -314,7 +314,7 @@
 	if (err)
 		return err;
 	vco_retries =3D 0;
-	while (!(vco_cal & FC11_VCOCAL_OK) && vco_retries < 6) {
+	while (!(vco_cal & FC11_VCOCAL_OK) && vco_retries < 3) {
 		/* Reset the tuner and try again */
 		err =3D fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
 				   FC0011_FE_CALLBACK_RESET, priv->addr);


--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/MAjqN74ROLgNqcL3rvD7w7D
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPer0/AAoJEPUyvh2QjYsOYpAQALTnZu/3h2FpcWAC/KkwEi1x
Pwoc2G1+RwHv9XT30zHWFwgN88pOkmCUamkzX1ly0uumdBjiuCfulxQm5YiY4m9K
7rPrwx30ubY0zFZ+poc3QpMlN/dc56L9WFd1yIIWV/KoFQpSnGWfAaLzqQiO4X/b
PwMndP6Wq0gfnCam+5rt0U5tYhrP/e86mpGdTKCaGpDA/oBonp8WxzQSk4nj86fK
kZadiTGAJsyLAF8/edv9OHiwSpiVonrGzQg20bPnGXn902cOlbLaDGPQORh7HqFM
BgzERUxMVel1sy8VBkaFhv+uSazszqg+BlUJWGLiDtrSlpqaOtY1rqF1ly9yYUDP
MHrc4ZbdTQHWLCB5BlQInmcrgpUYHWwqMP2LbMEPmKNYoPrcTXt5WUIEKqXF0zCO
4XhJAd3glhaTohoaY5LBGPW1ODKkxiwlsKPixoKQRxrpdFSVmUb6T9bkZ9TnXw5Q
HYT/p8BPRFBaPAb4dKToomCJGPYkgA9ycsW/YxFj+OTPpUHmeBt9KiTFiNmv3q9E
d9vw9GlhsCiP26M5wpEsfv8xI9zrQlbvT7Y4xsrNgB6jQUKgokJO1/VQg16p9eji
uRkRB610ycKdfqh6ACvGJnfvWWcW69pW3tOOZzIeJr/YfdX4Nu7kbmqdJU1tFCW8
tIARxu3ux1Fu6eepHmI9
=Z359
-----END PGP SIGNATURE-----

--Sig_/MAjqN74ROLgNqcL3rvD7w7D--
