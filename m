Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47836 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751664AbcJWHd1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Oct 2016 03:33:27 -0400
Date: Sun, 23 Oct 2016 09:33:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] media: add et8ek8 camera sensor driver and
 documentation
Message-ID: <20161023073322.GA3523@amd>
References: <1465659593-16858-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <1465659593-16858-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This series adds driver for Toshiba et8ek8 camera sensor found in Nokia N=
900
>=20
> Changes from v2:
>=20
>  - fix build when CONFIG_PM is not defined
>=20
> Changes from v1:
>=20
>  - driver and documentation split into separate patches
>  - removed custom controls
>  - code changed according to the comments on v1

> Ivaylo Dimitrov (2):
>   media: Driver for Toshiba et8ek8 5MP sensor
>   media: et8ek8: Add documentation

Is there any progress here? Is there any way I could help?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgMZ8IACgkQMOfwapXb+vInogCgo65ufs9kfNt2pJcu2fi2m64q
B3IAnRwuS54epBTT/fB/GhgFkicCewbm
=KnTx
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
