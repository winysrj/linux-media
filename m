Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59221 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753415AbdBNNmy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 08:42:54 -0500
Date: Tue, 14 Feb 2017 14:42:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: [RFC 04/13] omap3isp: add support for CSI1 bus
Message-ID: <20170214134246.GA8697@amd>
References: <20170214133947.GA8490@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <20170214133947.GA8490@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Obtain the CSI1/CCP2 bus parameters from the OF node.
>=20
> ISP CSI1 module needs all the bits correctly set to work.
>=20
> OMAP3430 needs various syscon CONTROL_CSIRXFE bits set in order to
> operate. Implement the missing functionality.
>=20
> [FIXME: Laurent has some comments here]
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

Ok, Sakari wanted patch series, so here it goes.

Patches from this one on are for illustration -- I still need to fix
them up. 1-3, I'd like to see merged, so if you have some comments
there, go on.

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlijCVYACgkQMOfwapXb+vJpjQCgvQCiq4DXfvvGXGBW344+AQa3
v9cAnjgtgxg4asRcvBb2chbSMjyKRnXT
=7gyK
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
