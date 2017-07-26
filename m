Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55765 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751034AbdGZLYs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Jul 2017 07:24:48 -0400
Date: Wed, 26 Jul 2017 13:24:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Petr Cvek <petr.cvek@tul.cz>,
        Sebastian Reichel <sre@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: v4l: use WARN_ON(1) instead of __WARN()
Message-ID: <20170726112447.GD6033@amd>
References: <20170725154001.294864-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OaZoDhBhXzo6bW1J"
Content-Disposition: inline
In-Reply-To: <20170725154001.294864-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--OaZoDhBhXzo6bW1J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2017-07-25 17:39:14, Arnd Bergmann wrote:
> __WARN() cannot be used in portable code, since it is only
> available on some architectures and configurations:
>=20
> drivers/media/platform/pxa_camera.c: In function 'pxa_mbus_config_compati=
ble':
> drivers/media/platform/pxa_camera.c:642:3: error: implicit declaration of=
 function '__WARN'; did you mean '__WALL'? [-Werror=3Dimplicit-function-dec=
laration]
>=20
> The common way to express an unconditional warning is WARN_ON(1),
> so let's use that here.
>=20
> Fixes: 97bbdf02d905 ("media: v4l: Add support for CSI-1 and CCP2 busses")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Pavel Machek <pavel@ucw.cz>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--OaZoDhBhXzo6bW1J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAll4e/8ACgkQMOfwapXb+vK0wQCgo1tn2wTeoLqePfkj/HxNGTtw
3awAoKajCM0vnmPmPG699EL5L2pIsfBN
=+Q0J
-----END PGP SIGNATURE-----

--OaZoDhBhXzo6bW1J--
