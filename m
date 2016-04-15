Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:46530 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbcDOLXd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 07:23:33 -0400
Date: Fri, 15 Apr 2016 13:23:19 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Peter Rosin <peda@lysator.liu.se>
Cc: linux-kernel@vger.kernel.org, Peter Rosin <peda@axentia.se>,
	Jonathan Corbet <corbet@lwn.net>,
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matt Ranostay <matt.ranostay@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Terry Heo <terryheo@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v6 01/24] i2c-mux: add common data for every i2c-mux
 instance
Message-ID: <20160415112318.GA3999@katana>
References: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
 <1459673574-11440-2-git-send-email-peda@lysator.liu.se>
 <20160411204630.GA10401@katana>
 <570E4BAE.7060108@lysator.liu.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <570E4BAE.7060108@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > I'd suggest to rename 'adapters' into 'num_adapters' throughout this
> > patch. I think it makes the code a lot easier to understand.
>=20
> Hmm, you mean just the variable names, right? And not function names
> such as i2c_mux_reserve_(num_)adapters?

Yes, only variable names.

> > Despite that I wonder why not using some of the realloc functions, I
>=20
> When I wrote it, I found no devm_ version of realloc. I'm not finding
> anything now either...

Right, there is no devm_ version of it :(

> > wonder even more if we couldn't supply num_adapters to i2c_mux_alloc()
> > and reserve the memory statically. i2c busses are not
> > dynamic/hot-pluggable so that should be good enough?
>=20
> Yes, that would work, but it would take some restructuring in some of
> the drivers that currently don't know how many child adapters they
> are going to need when they call i2c_mux_alloc.

Which ones?

> Because you thought about removing i2c_mux_reserve_adapters completely,
> and not provide any means of adding more adapters than specified in
> the i2c_mux_alloc call, right?

Yes. I assumed I2C to be static enough that such information is known in
advance.

> > Ignoring the 80 char limit here makes the code more readable.
>=20
> That is only true if you actually have more than 80 characters, so I don't
> agree. Are you adamant about it? (I'm not)

No. Keep it if you prefer it.

> >> +EXPORT_SYMBOL_GPL(i2c_mux_one_adapter);
> >=20
> > Are you sure the above function pays off? Its argument list is very
> > complex and it doesn't save a lot of code. Having seperate calls is
> > probably more understandable in drivers? Then again, I assume it makes
> > the conversion of existing drivers easier.
>=20
> I added it in v4, you can check earlier versions if you like. Without
> it most gate-muxes (i.e. typically the muxes in drivers/media) grew
> since the i2c_add_mux_adapter call got replaced by two calls, i.e.
> i2c_mux_alloc followed by i2c_max_add_adapter, and coupled with
> error checks made it look more complex than before. So, this wasn't
> much of a cleanup from the point of those drivers.

Hmm, v3 didn't have the driver patches posted with it. Can you push it
to your branch? I am also not too strong with this one, but having a
look how it looks without would be nice.


--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXEM8mAAoJEBQN5MwUoCm2vqsQAI3yJI+B6O3czvil6A1eykpH
g4woawT6xVkslGuCxiz+bXsjE3ldfGG7YH2BICfyhYLEvIkvVBgfVb1JQrsEsR4C
AfpX3HyO2N29JO+S0Zk5NUToJ+6W2e6cMiAXKgBCGP3sODITuqx0Fku3Nvf7zfTB
pR1wOH9lAg/+qSiBTtpclX0l8i2chQiRHJqFxUJUoErClZudrZkizbTugMkfsXJf
qiywt1GsBgkPLcnAmISq71J/9QgsQZeMfJc85qCeEWng0YEkOruK8JFDHvqhffZw
10P1GWYsFF3do2qeMgCh90xeZNWijzOJl8a/YcOnTRGgJRjfLeUu5Y93k+IhdZiq
wJkSiybtFrz9Qq84DVwG53QHu9huZN/MW+GUxWKi45B2ZikM4UkPQMA3DBUVcn23
AWTYhhGI7FenWI63NceG0Nl9+o3UxAO97SHIRcqvNmeZfMd0lsYi7oqDI+SuaOSy
wI0NhdoWSl1mutULlojkMqWBiGHN+RweLTNpv6dVUgR+qBb/7+tCC7DRFQBA/G9a
mA3d8EEEOoxo7mcP2F7PYmYiA42gN6TRiP+Lce3rqNyRMe+G3YoA/agWwgcsoehf
p0pIWzU8vH/5jcz32FTHlooMQIgsx5IqT0FxbxIDPoTaNOuNcsgdOHArv84v/9j4
H7duOm2CeCS5eX2uuQPU
=Px0Y
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
