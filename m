Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60849 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755088AbcJWSdi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Oct 2016 14:33:38 -0400
Date: Sun, 23 Oct 2016 20:33:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, sre@kernel.org,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: v4.9-rc1: smiapp divides by zero
Message-ID: <20161023183334.GA11216@amd>
References: <1465659593-16858-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20161023073322.GA3523@amd>
 <20161023102213.GA13705@amd>
 <20161023140911.GF9460@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <20161023140911.GF9460@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > +#define DEBUG
> > +
> >  #include <linux/device.h>
> >  #include <linux/gcd.h>
> >  #include <linux/lcm.h>
> > @@ -457,6 +459,10 @@ int smiapp_pll_calculate(struct device *dev,
> >  	i =3D gcd(pll->pll_op_clk_freq_hz, pll->ext_clk_freq_hz);
> >  	mul =3D div_u64(pll->pll_op_clk_freq_hz, i);
> >  	div =3D pll->ext_clk_freq_hz / i;
> > +	if (!mul) {
>=20
> Something must be very wrong if you get here.
>=20
> What are the values of pll->pll_op_clk_freq_hz and pll->ext_clk_freq_hz?
> Or... what does dmesg say?

Yep, it was very wrong. I mismerged the stuff, and hwcfg->lanes
initialization was missing. Now it appears to work.

(I have pushed the changes to camera-v4.9 branch).

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgNAn4ACgkQMOfwapXb+vLdbgCeL69GwEB22IKzJZf2O9mmgIAU
NaIAn1aSClb7PcBKCNiCwbHXUgU+LUdW
=nbZx
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
