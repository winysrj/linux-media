Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51190 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752092AbcJWKWR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Oct 2016 06:22:17 -0400
Date: Sun, 23 Oct 2016 12:22:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: v4.9-rc1: smiapp divides by zero
Message-ID: <20161023102213.GA13705@amd>
References: <1465659593-16858-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20161023073322.GA3523@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <20161023073322.GA3523@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I tried to update camera code on n900 to v4.9-rc1, and I'm getting
some divide by zero, that eventually cascades into fcam-dev not
working.

mul is zero in my testing, resulting in divide by zero.

(Note that this is going from my patched camera-v4.8 tree to
camera-v4.9 tree.)

Best regards,
								Pavel

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index 5ad1edb..e0a6edd 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -16,6 +16,8 @@
  * General Public License for more details.
  */
=20
+#define DEBUG
+
 #include <linux/device.h>
 #include <linux/gcd.h>
 #include <linux/lcm.h>
@@ -457,6 +459,10 @@ int smiapp_pll_calculate(struct device *dev,
 	i =3D gcd(pll->pll_op_clk_freq_hz, pll->ext_clk_freq_hz);
 	mul =3D div_u64(pll->pll_op_clk_freq_hz, i);
 	div =3D pll->ext_clk_freq_hz / i;
+	if (!mul) {
+		dev_err(dev, "forcing mul to 1\n");
+		mul =3D 1;
+	}
 	dev_dbg(dev, "mul %u / div %u\n", mul, div);
=20
 	min_pre_pll_clk_div =3D

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgMj1UACgkQMOfwapXb+vJg3QCdHASBuGgT7LYYLLbM+W0zKpOB
QyQAnj1mB0iN7Gc0qPiTktFnd0oCqZR4
=7567
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
