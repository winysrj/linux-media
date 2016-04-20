Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:45636 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbcDTUwg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2016 16:52:36 -0400
Date: Wed, 20 Apr 2016 22:52:22 +0200
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
Subject: Re: [PATCH v7 00/24] i2c mux cleanup and locking update
Message-ID: <20160420205221.GB1546@katana>
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pk6IbRAofICFmK5e"
Content-Disposition: inline
In-Reply-To: <1461165484-2314-1-git-send-email-peda@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Pk6IbRAofICFmK5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


This was the diff of v6:

>  32 files changed, 1277 insertions(+), 915 deletions(-)

This is v7:

>  32 files changed, 1225 insertions(+), 916 deletions(-)

So, we gained a little overall. And while the individual drivers have a
few lines more now, I still think it is more readable.

So, thanks for doing that!

I'll give people some time for testing. I'll have a further look, too.
Hopefully, I can pick up patches 1-14 by the end of the week.

   Wolfram


--Pk6IbRAofICFmK5e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXF+wFAAoJEBQN5MwUoCm25mEP/i6NKQYFWJO25EYSZWJCerM3
UEw0k1CInID3LqMNI8/8LmcFiLArc1gA7TqmWksf9M9oW0TPi967rmSRnarI6zQN
QbpT0qF7gUHYX0XFo7XlARaz/78s6AbdEvkGdicrXx9GzJz1KQQF8L8pZemUS7xY
FcXsRnCL7/lhzqI+yKyNXrhwlCRLjLd8E6MtLHE20optmZN3nmMuy/jLgD+z3EQs
fulGOcIjJZWgidiHrNZn6BB2dsd71lXN0ZBb5XNZgHjeevnn2HRgSYzXTtzk7Xye
9nOR9EWJ8HCWLqeulEohEwOE95Q4uKPoDrQnSGbeQwEpXksHp21miW9T+AWa91gX
9SI5BYG4aPlDqYGgUrS+pt8+q42Tb0V/gVwP0pFkxMSpZdmpDJxydTZhJ7kCvcQq
h7Xm2VWE3SMKepnb5agzfhnCgZXIH86SBfv6pciVCq6Rzf3ZahEd3zMnbHl8gJu0
BtamEGnghtuoSLWzRGEREg+vGPK3LEL4VvZaSJSfv838VcpG0ePMI6a7N7bRU3ah
y4YTyUi5dd19WCwsqwldSD+zbcJ82xvtbc0Akb3F/bVJBWCdgmh6cAE2cNgfoh/Z
uhQ94aUFRFQLZSuHO2nHYTX6QeJEAxB6IIK0I4bHXg2oAuHDaPsRmcuHaoz8LIE0
PmVKkaxsAB7Wa/6TaR25
=UCS6
-----END PGP SIGNATURE-----

--Pk6IbRAofICFmK5e--
