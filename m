Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47418 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751057AbeEFICw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2018 04:02:52 -0400
Date: Sun, 6 May 2018 10:02:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, sre@kernel.org,
        nekit1000@gmail.com, mpartap@gmx.net, merlijn@wizzup.org,
        gshark.jeong@gmail.com, m.chehab@samsung.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org
Subject: [PATCH] media: i2c: lm3560: use conservative defaults
Message-ID: <20180506080250.GA24114@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


If no pdata is found, we should use lowest current settings, not highest.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/media/i2c/lm3560.c b/drivers/media/i2c/lm3560.c
index b600e03a..c4e5ed5 100644
--- a/drivers/media/i2c/lm3560.c
+++ b/drivers/media/i2c/lm3560.c
@@ -420,14 +434,14 @@ static int lm3560_probe(struct i2c_client *client,
 		pdata =3D devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
 		if (pdata =3D=3D NULL)
 			return -ENODEV;
-		pdata->peak =3D LM3560_PEAK_3600mA;
-		pdata->max_flash_timeout =3D LM3560_FLASH_TOUT_MAX;
+		pdata->peak =3D LM3560_PEAK_1600mA;
+		pdata->max_flash_timeout =3D LM3560_FLASH_TOUT_MIN;
 		/* led 1 */
-		pdata->max_flash_brt[LM3560_LED0] =3D LM3560_FLASH_BRT_MAX;
-		pdata->max_torch_brt[LM3560_LED0] =3D LM3560_TORCH_BRT_MAX;
+		pdata->max_flash_brt[LM3560_LED0] =3D LM3560_FLASH_BRT_MIN;
+		pdata->max_torch_brt[LM3560_LED0] =3D LM3560_TORCH_BRT_MIN;
 		/* led 2 */
-		pdata->max_flash_brt[LM3560_LED1] =3D LM3560_FLASH_BRT_MAX;
-		pdata->max_torch_brt[LM3560_LED1] =3D LM3560_TORCH_BRT_MAX;
+		pdata->max_flash_brt[LM3560_LED1] =3D LM3560_FLASH_BRT_MIN;
+		pdata->max_torch_brt[LM3560_LED1] =3D LM3560_TORCH_BRT_MIN;
 	}
 	flash->pdata =3D pdata;
 	flash->dev =3D &client->dev;

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlrutqoACgkQMOfwapXb+vKAhwCgw3VcquxPd6JBDpXbdEgC00AC
jhwAnijIiGbVPSqdr41LZYehCC7/vjiV
=mn6q
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
