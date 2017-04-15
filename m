Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44775 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751494AbdDOHMS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Apr 2017 03:12:18 -0400
Date: Sat, 15 Apr 2017 09:12:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v3 1/2] v4l: Add camera voice coil lens control class,
 current control
Message-ID: <20170415071215.GA6160@amd>
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
 <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170414232332.63850d7b@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <20170414232332.63850d7b@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Worse than that, patch 2/2 gives the false sensation that both
> controls are equal.
>=20
> Ok, I understand that they need to be identical on the existing
> driver, in order to keep backward compatibility, but I'm afraid
> that, without a clear distinction between them at the documentation,
> people may just clone the existing code on other drivers.

Actually, you don't need to workky about the backwards compatibility
there. I'm pretty sure I'm the only user, and I can adapt.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAljxx88ACgkQMOfwapXb+vJTxQCglmJaA/RNv1/P71wcnxjNMVdL
2cgAoK654cRDL/WnO0rotawWMkavgizW
=+d8T
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
