Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59112 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753979AbdBNNkH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 08:40:07 -0500
Date: Tue, 14 Feb 2017 14:40:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        ivo.g.dimitrov.75@gmail.com
Subject: [RFC 08/13] smiapp-pll: Take existing divisor into account in
 minimum divisor check
Message-ID: <20170214134004.GA8570@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Sakari Ailus <sakari.ailus@iki.fi>

Required added multiplier (and divisor) calculation did not take into
account the existing divisor when checking the values against the
minimum divisor. Do just that.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/media/i2c/smiapp-pll.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index 771db56..166bbaf 100644
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
@@ -227,7 +229,8 @@ static int __smiapp_pll_calculate(
=20
 	more_mul_factor =3D lcm(div, pll->pre_pll_clk_div) / div;
 	dev_dbg(dev, "more_mul_factor: %u\n", more_mul_factor);
-	more_mul_factor =3D lcm(more_mul_factor, op_limits->min_sys_clk_div);
+	more_mul_factor =3D lcm(more_mul_factor,
+			      DIV_ROUND_UP(op_limits->min_sys_clk_div, div));
 	dev_dbg(dev, "more_mul_factor: min_op_sys_clk_div: %d\n",
 		more_mul_factor);
 	i =3D roundup(more_mul_min, more_mul_factor);
@@ -456,6 +459,10 @@ int smiapp_pll_calculate(struct device *dev,
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
2.1.4


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlijCLQACgkQMOfwapXb+vIunQCgixZvYA1nz3b3HXBa1Kkfbkp2
4uUAnAt7KhAza7G/Ohzl/41KTTcqNbOU
=eCxB
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
