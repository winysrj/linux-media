Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42364 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751392AbdFHQkH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 12:40:07 -0400
Date: Thu, 8 Jun 2017 18:40:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "[media] et8ek8: Export OF device ID as module
 aliases"
Message-ID: <20170608164004.GA23674@amd>
References: <20170608090156.2373326-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <20170608090156.2373326-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2017-06-08 11:01:37, Arnd Bergmann wrote:
> This one got applied twice, causing a build error with clang:
>=20
> drivers/media/i2c/et8ek8/et8ek8_driver.c:1499:1: error: redefinition of '=
__mod_of__et8ek8_of_table_device_table'
>=20
> Fixes: 9ae05fd1e791 ("[media] et8ek8: Export OF device ID as module alias=
es")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Pavel Machek <pavel@ucw.cz>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlk5feQACgkQMOfwapXb+vJWWwCcCJ8AZ6XYfcJZiRJvTQbZ91hd
m3YAn31Tmbk00v35Ap26pIF0X/uqd0ef
=aV6u
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
