Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:36958 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbcD1VsL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2016 17:48:11 -0400
Date: Thu, 28 Apr 2016 23:47:58 +0200
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
Subject: Re: [PATCH v7 22/24] [media] rtl2832: change the i2c gate to be
 mux-locked
Message-ID: <20160428214758.GA4531@katana>
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
 <1461165484-2314-23-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <1461165484-2314-23-git-send-email-peda@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 20, 2016 at 05:18:02PM +0200, Peter Rosin wrote:
> The root i2c adapter lock is then no longer held by the i2c mux during
> accesses behind the i2c gate, and such accesses need to take that lock
> just like any other ordinary i2c accesses do.
>=20
> So, declare the i2c gate mux-locked, and zap the regmap overrides
> that makes the i2c accesses unlocked and use plain old regmap
> accesses. This also removes the need for the regmap wrappers used by
> rtl2832_sdr, so deconvolute the code further and provide the regmap
> handle directly instead of the wrapper functions.
>=20
> Signed-off-by: Peter Rosin <peda@axentia.se>

Antti, I'd need some tag from you since this is not the i2c realm.


--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXIoUOAAoJEBQN5MwUoCm2jusP/j3ToNlZQahVV1UtMvPujy94
AF3AWGq+Gn1OWavfKFBdJXxQHsqAydIuu5lsxX5+sZALJgR7KjOX3mGRdBS5Nle2
xDVL5vQzm8QsXHHJ5r4CKL8nKTFxZaDZZ51i+CeuBuuOVVwR/nzUK8Kdgth0s1az
leYSe8gc7znMcipW5+5JeaCsFOkUX/gHZHcORur5g5vXYHoHjhMvCxbO+KqhTrFc
VHFhGAMN8ltRlayIHpFMvTW3s4chO5/cONVILcTS3uMpV1VftovuwV2fC9TKaUq5
NqB2heSPeEAYboNk4cG6FC2LxOkpsl6ux11HrODI/YkMz2he2bbQG7qod6AT0RW2
yTSPH2Wr0gxlJPBq0JOX4XQF+l0Arx7KY3iR//1H5cCNbBHVE1ABVM7wwTRMhJAF
9mYON8A1OTmWHyaJ/QRVevdU/0jt2iCvrerctBCljkjRtQZGBSNQyhqwS23HIL+0
RDSWK7H/L9Hv0lbzNEUPiUpupDxu5HLveu4oYivrTrt6RCN4HWnVr3sIsaa4x7TD
o0p1LiUew+g2mx0SzGzAy8oXiGxZ6WwYP06GY7jrbqIYwvD180zr+VoFdoKARPzs
GY7gUsgh87x4fQrQ4XYVRqarp4xMuyzhTUYOD8AAbGbaFCiLPEKK58ytDLqoRctO
vGQQGn0rRRdpd3Zq8Fn+
=3zSS
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
