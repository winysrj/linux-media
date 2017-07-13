Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49351 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751050AbdGMLM0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 07:12:26 -0400
Date: Thu, 13 Jul 2017 13:12:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 7/8] omap3isp: Check for valid port in endpoints
Message-ID: <20170713111224.GG1363@amd>
References: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
 <20170705230019.5461-8-sakari.ailus@linux.intel.com>
 <20170706111149.ws6olipu7ph4tcyd@earth>
 <20170707130432.g4di5a3he2bf5baw@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vJguvTgX93MxBIIe"
Content-Disposition: inline
In-Reply-To: <20170707130432.g4di5a3he2bf5baw@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--vJguvTgX93MxBIIe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > On Thu, Jul 06, 2017 at 02:00:18AM +0300, Sakari Ailus wrote:
> > > Check that we do have a valid port in an endpoint, return an error if=
 not.
> > >=20
> > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >=20
> > Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
>=20
> Thanks for the reviews, Sebastian and Pavel!
>=20
> I'll send a pull request on these for 4.14 once we have -rc1 in the media
> tree.

I can update my patches when updated ccp2 branch is ready.

And actually, I'd quite like to get rest of support ready for 4.14,
too. I believe we are close enough.

I re-checked, and it seems to work w/o the "smiapp-pll: Take existing
divisor into account in minimum divisor check" patch; so with
"omap3isp: add CSI1 support" plus the other ccp2 patches, plus dts
changes, we should be ok.

Best regards,
									Pavel

commit eba2751794239780efb256ce7079294a4d4c6e74
Author: Pavel <pavel@ucw.cz>
Date:   Mon Feb 13 21:18:27 2017 +0100

   =20
   =20
    From: Sakari Ailus <sakari.ailus@iki.fi>
   =20
    Required added multiplier (and divisor) calculation did not take into
    account the existing divisor when checking the values against the
    minimum divisor. Do just that.
   =20
    Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
    Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
    Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index 771db56..0ada972 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -227,7 +227,8 @@ static int __smiapp_pll_calculate(
=20
 	more_mul_factor =3D lcm(div, pll->pre_pll_clk_div) / div;
 	dev_dbg(dev, "more_mul_factor: %u\n", more_mul_factor);
-	more_mul_factor =3D lcm(more_mul_factor, op_limits->min_sys_clk_div);
+	more_mul_factor =3D lcm(more_mul_factor,
+			      DIV_ROUND_UP(op_limits->min_sys_clk_div, div));
 	dev_dbg(dev, "more_mul_factor: min_op_sys_clk_div: %d\n",
 		more_mul_factor);
 	i =3D roundup(more_mul_min, more_mul_factor);

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--vJguvTgX93MxBIIe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllnVZgACgkQMOfwapXb+vINdwCgjMu022etDMgI2wMEWtoB4NKv
FwcAoIJa8W1+3pQufcRdM9pYfz/9+SnL
=SC+w
-----END PGP SIGNATURE-----

--vJguvTgX93MxBIIe--
