Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:36642 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779AbcD1Uuo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2016 16:50:44 -0400
Date: Thu, 28 Apr 2016 22:50:26 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Peter Rosin <peda@axentia.se>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Frank Rowand <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Jiri Slaby <jslaby@suse.com>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Matt Ranostay <matt.ranostay@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Terry Heo <terryheo@google.com>, Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Crestez Dan Leonard <leonard.crestez@intel.com>,
	linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, Peter Rosin <peda@lysator.liu.se>
Subject: Re: [PATCH v7 16/24] i2c: allow adapter drivers to override the
 adapter locking
Message-ID: <20160428205018.GA3553@katana>
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
 <1461165484-2314-17-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
In-Reply-To: <1461165484-2314-17-git-send-email-peda@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 20, 2016 at 05:17:56PM +0200, Peter Rosin wrote:
> Add i2c_lock_bus() and i2c_unlock_bus(), which call the new lock_bus and
> unlock_bus ops in the adapter. These funcs/ops take an additional flags
> argument that indicates for what purpose the adapter is locked.
>=20
> There are two flags, I2C_LOCK_ADAPTER and I2C_LOCK_SEGMENT, but they are
> both implemented the same. For now. Locking the adapter means that the
> whole bus is locked, locking the segment means that only the current bus
> segment is locked (i.e. i2c traffic on the parent side of mux is still
> allowed even if the child side of the mux is locked.
>=20
> Also support a trylock_bus op (but no function to call it, as it is not
> expected to be needed outside of the i2c core).
>=20
> Implement i2c_lock_adapter/i2c_unlock_adapter in terms of the new locking
> scheme (i.e. lock with the I2C_LOCK_ADAPTER flag).
>=20
> Annotate some of the locking with explicit I2C_LOCK_SEGMENT flags.
>=20
> Signed-off-by: Peter Rosin <peda@axentia.se>

Letting you know that I start reviewing the 2nd part of your series. Did
the first glimpse today. Will hopefully do the in-depth part this
weekend. One thing already:

> +static void i2c_adapter_lock_bus(struct i2c_adapter *adapter, int flags)

Shouldn't flags be unsigned?


--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXIneKAAoJEBQN5MwUoCm2FRAP/0xqKvNG6PKzooja0h+oXlg/
KBYBC56fJQkwEQRL80huZaBLGsXFOc8Jllxiz1y0iXfWP9EiyaOfNyngi1bt5YY3
M29BL8wZzxHFE3iMaCcMPTsgkqLTw0+CaQ9MkNl86qtBoHy+vVp/h7xGl0o2h65a
UISpfvdN+wPnWty1EPfXjVdwlz4DVCk9KGJMB6EaRzqYUrGRynkTnv2mrQn9PDeS
KhphipVSSX7ay81wdb/ttVTZ0WyVTwKJiga8k1ntMBiqMCRslzVWT9YlcxSanHh0
aZKJ28Kp81ptTh63aK0XIdHc4cgEFECzR2ZI0P1koSICsjXg4MOnJGmIvHaen+AI
AGqQJq1EmveMMucJOHYaHUcJHUeV/cYicQSrdE9Xt8CFrXmZzTo7y3S3M0HpOguW
xCVouwKg20orkPCH43XQyH+rWMfJEugy05OAs4ZB1PK5DChtpjckFYGfV8v35lx6
iBJVcl1ZP0JATIu45qHv93brTgS8Qu2LeCAgEJDQOnbQOA4UDVrKUnIsN/usBpxe
714LkDFbCq4nF+jEaRcJcIl3S1368fdL2T2lxBXctBzNiuVeToIa0IlwQvwtBYyo
O4XhpD6nbPSXO3AleprLukGGlltBGnJ8AbEN/sQ5cyLYYZD7EhLNAtDnwlSkL2Cj
D133ZEu3VvqGwDKH+Q5H
=qGk7
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
