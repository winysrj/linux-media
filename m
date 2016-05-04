Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:46172 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848AbcEDQik (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 12:38:40 -0400
Date: Wed, 4 May 2016 18:38:25 +0200
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
Message-ID: <20160504163825.GA1516@katana>
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
 <1461165484-2314-17-git-send-email-peda@axentia.se>
 <20160428205018.GA3553@katana>
 <470abe38-ab5f-2d0a-305b-e1a3253ce5a9@axentia.se>
 <20160429071604.GB1870@katana>
 <357e6fda-73b3-fb7f-c341-97f09af1943f@axentia.se>
 <20160503213908.GC2018@tetsubishi>
 <87de4033-3b58-3ef6-d22b-b90901885b39@axentia.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <87de4033-3b58-3ef6-d22b-b90901885b39@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> A question on best practices here... I already did a v8 (but only as
> a branch) so I think this will be v9, bit that's a minor detail. The
> real question is what I should do about patches 1-15 that are already
> in next? Send them too? If not, should I send 16-24 with the same old
> patch numbers or should they be numbered 1-9 now? And should such a
> shortened series be rebased on 1-15 in next?
>=20
> Or does it not really matter?

Easiest for me is:

Send as v9, only the patches not yet applied, numbered from 1-9, based
on my for-next.


--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXKiWBAAoJEBQN5MwUoCm2JRwP/3pJfeAOonaG99Z+aFHFcxKb
nV2lgIKSHRzgLxEFInIhnvW1m6gvm9AqJL0IO3ZYOJkmly7bf896FGGMVWSG3wHg
5EepSrn8HuDPIlCf23EDgzTqSvp+J2GChbC/0x7AtQ7PnGw3CmKqGJPz2ecxRUMg
iMGVVo3eNoBaboYB0lAmawHgS3Ui2zyn5t9GHPeZNmD8uFG8CrGK1wPD1KkK298X
2KSKDX3K8G1us81/iVs4Z67E21O+9ls5zZCpBmZi1YSDWA5vzf3Rh8BIYPUj3BaT
K6Dq/RnBt5aVOzG5wWdaonLZca6ozQgF1kgrPcNj+6mPWyv8+nzNSMDDqaqYDXt1
IL6crz1aGIMhz6chlRFQm6HhMVnGp83CCwIjeaUNEnzG6VeFux0UJPMVyWVDc4pQ
qDVs8izEnVbAw46JwbJxCxpqSgRDqDyAnsMdh1/x8XT/SbuPaNHWVFGz7/8G+1FG
7QzlNcX0WGdapK7ZR3dZ4ob2z4tkL3EKiVbiN7jePpqk0C6Uppa61xNj9LdFKAJe
WXSArGjwUzWisLzPZ37w0ko0a+uMVGrQxv2YQGAUixaXpqtaXx75Boj7lIiozflS
ryO/VniaGcVTsHJiAHZo5fpt7XOqPwmfq4cs4qEn38PXkhScKwlfyRwraYcrjtJx
K6HVk05ZVfaPU8CRrIvE
=XLBz
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
