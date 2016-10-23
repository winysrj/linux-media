Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35251 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754177AbcJWUsA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Oct 2016 16:48:00 -0400
Date: Sun, 23 Oct 2016 22:47:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161023204756.GA7659@amd>
References: <20161023200355.GA5391@amd>
 <20161023201954.GI9460@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <20161023201954.GI9460@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun 2016-10-23 23:19:54, Sakari Ailus wrote:
> Hi Pavel,
>=20
> Thanks, this answered half of my questions already. ;-)
>=20
> Do all the modes work for you currently btw.?

I pushed current kernel sources to kernel.org:

git push
git@gitolite.kernel.org:pub/scm/linux/kernel/git/pavel/linux-n900.git
camera-v4.9:camera-v4.9

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgNIfwACgkQMOfwapXb+vJ4/QCfdlZn0vPgbHt4ClSJFUp2e2vz
BmMAniw1hBkFyXOkaKNdNHzxs/ZdN3v/
=pJvD
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
