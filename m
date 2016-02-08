Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:49513 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbcBHKyW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2016 05:54:22 -0500
Date: Mon, 8 Feb 2016 11:54:17 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: tvp5150 regression after commit 9f924169c035
Message-ID: <20160208105417.GD2220@tetsubishi>
References: <56B204CB.60602@osg.samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i7F3eY7HS/tUJxUd"
Content-Disposition: inline
In-Reply-To: <56B204CB.60602@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--i7F3eY7HS/tUJxUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 03, 2016 at 10:46:51AM -0300, Javier Martinez Canillas wrote:
> Hello Wolfram,
>=20
> I've a issue with a I2C video decoder driver (drivers/media/i2c/tvp5150.c=
).
>=20
> In v4.5-rc1, the driver gets I2C read / writes timeouts when accessing the
> device I2C registers:
>=20
> tvp5150 1-005c: i2c i/o error: rc =3D=3D -110
> tvp5150: probe of 1-005c failed with error -110
>=20
> The driver used to work up to v4.4 so this is a regression in v4.5-rc1:
>=20
> tvp5150 1-005c: tvp5151 (1.0) chip found @ 0xb8 (OMAP I2C adapter)
> tvp5150 1-005c: tvp5151 detected.
>=20
> I tracked down to commit 9f924169c035 ("i2c: always enable RuntimePM for
> the adapter device") and reverting that commit makes things to work again.
>=20
> The tvp5150 driver doesn't have runtime PM support but the I2C controller
> driver does (drivers/i2c/busses/i2c-omap.c) FWIW.
>=20
> I tried adding runtime PM support to tvp5150 (basically calling pm_runtime
> enable/get on probe before the first I2C read to resume the controller) b=
ut
> that it did not work.
>=20
> Not filling the OMAP I2C driver's runtime PM callbacks does not help eith=
er.
>=20
> Any hints about the proper way to fix this issue?

Asking linux-pm for help:

The commit in question enables RuntimePM for the logical adapter device
which sits between the HW I2C controller and the I2C client device. This
adapter device has been used with pm_runtime_no_callbacks before
enabling RPM. Now, Alan explained to me that "suspend events will
propagate from the I2C clients all the way up to the adapter's parent."
with RPM enabled for the adapter device. Which should be a no-op if the
client doesn't do any PM at all? What do I miss?

Thanks,

   Wolfram


--i7F3eY7HS/tUJxUd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWuHPZAAoJEBQN5MwUoCm2YTgP/Rf7A5fE0r5RO35C+SzKhqxf
OfWaBW14ZyhelbuRFhGKc2MhnnSQ+5ndfb4hPmSY6pE/nxUsNsDNQWTKKrWOM41f
5JiNeC+Mub1ybSXukWm58+l00WyIM79/30XeoO+mZWw1oeh3E0janTpbatCnZl7m
n3kyOF1lfI7C/tlF3Q4CjKpQHjn2p237x9dzSBWKbvshx+Nc0eUpLgP1Ct0PgAdT
MuGSY24gPDcQeKXTE8d1IcN+yh5NJkgX2cBpcjwpuIvC4TFfYLh8ElDt1Q5XmCZm
k5eh41F92koZOY0Z1GN1uFd75fit2lmaee8O3/RS/FPEnr2y9GgEwQRYwavmfHaF
RWjciIBz8hlLXO2zTo1Y6bayVP82/8nBLOw7bhitMt9s4qwyQgo1R8dNai2PzTVq
hKFBzpIeRkyt30KP1KhSTWk+gQoc7kDOaUkNmqcAvGASSbUsPAhNScx15LT7d0KI
w06IlsnrqsVIzPxjf8Xb+BgRi6zyDNFgOnjopS365fReM5WoiYEhvTnBWzRS9d8g
lhBxUTcatOWmRHid5vJxaLfj2nftWCckRJajHkQHQJpYt6JQ2MA55pc1sfjQPONa
docCUOZ7VwvVejTDCUo4ug1T0HZIYpTSsC/r+tqqXLsxGHjQ5fYi148wOcFLwq87
Vsfe9nfyLQX8LhJ8lLoI
=tpVa
-----END PGP SIGNATURE-----

--i7F3eY7HS/tUJxUd--
