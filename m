Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47506 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751118AbeEFIGJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2018 04:06:09 -0400
Date: Sun, 6 May 2018 10:06:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, sre@kernel.org,
        nekit1000@gmail.com, mpartap@gmx.net, merlijn@wizzup.org,
        gshark.jeong@gmail.com, m.chehab@samsung.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org
Subject: [PATCH] media: i2c: lm3560: add support for lm3559 chip
Message-ID: <20180506080607.GA24212@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Add support for LM3559, as found in Motorola Droid 4 phone, for
example. SW interface seems to be identical.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/media/i2c/lm3560.c b/drivers/media/i2c/lm3560.c
index b600e03a..c4e5ed5 100644
--- a/drivers/media/i2c/lm3560.c
+++ b/drivers/media/i2c/lm3560.c
@@ -1,6 +1,6 @@
 /*
  * drivers/media/i2c/lm3560.c
- * General device driver for TI lm3560, FLASH LED Driver
+ * General device driver for TI lm3559, lm3560, FLASH LED Driver
  *
  * Copyright (C) 2013 Texas Instruments
  *
@@ -465,6 +479,7 @@ static int lm3560_remove(struct i2c_client *client)
 }
=20
 static const struct i2c_device_id lm3560_id_table[] =3D {
+	{LM3559_NAME, 0},
 	{LM3560_NAME, 0},
 	{}
 };
diff --git a/include/media/i2c/lm3560.h b/include/media/i2c/lm3560.h
index a5bd310..0e2b1c7 100644
--- a/include/media/i2c/lm3560.h
+++ b/include/media/i2c/lm3560.h
@@ -22,6 +22,7 @@
=20
 #include <media/v4l2-subdev.h>
=20
+#define LM3559_NAME	"lm3559"
 #define LM3560_NAME	"lm3560"
 #define LM3560_I2C_ADDR	(0x53)
=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlrut28ACgkQMOfwapXb+vLSzQCgrhkflQFo4Ddsoh2TH1C9Pm55
EAAAoJ2IWkJqV48lRGAuyKu5wjO3vJmh
=SrIF
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
