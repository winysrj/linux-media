Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51762 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753156AbcJWKwP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Oct 2016 06:52:15 -0400
Date: Sun, 23 Oct 2016 12:52:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: v4.9-rc1: smiapp divides by zero
Message-ID: <20161023105211.GA24117@amd>
References: <1465659593-16858-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20161023073322.GA3523@amd>
 <20161023102213.GA13705@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <20161023102213.GA13705@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> I tried to update camera code on n900 to v4.9-rc1, and I'm getting
> some divide by zero, that eventually cascades into fcam-dev not
> working.
>=20
> mul is zero in my testing, resulting in divide by zero.
>=20
> (Note that this is going from my patched camera-v4.8 tree to
> camera-v4.9 tree.)

If I revert the smiapp changes to the ones in camera-v4.8, I get fcam
back, and can get pictures using the main camera.

There are only few patches between v4.8 and v4.8 in smiapp, so I'll
try to find what is going on there.

Best regards,
								Pavel


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgMllsACgkQMOfwapXb+vJDagCgkz0CAr6vbvOfZ+XKZWv8qQwc
RiYAni/AHQLR/XKGeSTGlxciNftwUGDp
=sZVf
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
