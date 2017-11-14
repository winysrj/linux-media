Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50428 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751245AbdKNKvA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Nov 2017 05:51:00 -0500
Date: Tue, 14 Nov 2017 11:50:58 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: et8ek8: select V4L2_FWNODE
Message-ID: <20171114105057.GA2576@amd>
References: <20171113135658.3208951-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <20171113135658.3208951-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2017-11-13 14:56:45, Arnd Bergmann wrote:
> v4l2_async_register_subdev_sensor_common() is only provided when
> CONFIG_V4L2_FWNODE is enabled, otherwise we get a link failure:
>=20
> drivers/media/i2c/et8ek8/et8ek8_driver.o: In function `et8ek8_probe':
> et8ek8_driver.c:(.text+0x884): undefined reference to `v4l2_async_registe=
r_subdev_sensor_common'
>=20
> This adds a Kconfig 'select' statement like all the other users of
> this interface have.
>=20
> Fixes: d8932f38c10f ("media: et8ek8: Add support for flash and lens devic=
es")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Pavel Machek <pavel@ucw.cz>

Thanks!
									Pavel
								=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAloKypEACgkQMOfwapXb+vIxoACgnnqxRGF1fGeZOFE+TlF6Nb+y
BbwAn0DhRvO4AyVXPSPuh/MlLY/TQqTy
=DTLW
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
