Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35058 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727182AbeGPJen (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jul 2018 05:34:43 -0400
Date: Mon, 16 Jul 2018 11:08:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, sre@kernel.org,
        nekit1000@gmail.com, mpartap@gmx.net, merlijn@wizzup.org,
        gshark.jeong@gmail.com, m.chehab@samsung.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org
Subject: [PATCH v2] media: i2c: lm3560: use conservative defaults
Message-ID: <20180716090814.GA4505@amd>
References: <20180506080250.GA24114@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <20180506080250.GA24114@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

If no pdata is found, we should use lowest current settings, not highest.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

---

v2: I got notification from patchwork that patch no longer applies, so
I'm rediffing the patch.

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

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAltMYH4ACgkQMOfwapXb+vKsegCggcZUJYFiZWFzxBzDTN6kap2b
YsEAnjdMLGatnsTzSchv4dd+8REfgtkz
=Y7Pd
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
