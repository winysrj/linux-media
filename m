Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:57653 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049AbcDKMkP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2016 08:40:15 -0400
Date: Mon, 11 Apr 2016 14:39:59 +0200
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
Subject: Re: [PATCH v6 00/24] i2c mux cleanup and locking update
Message-ID: <20160411123959.GA4719@katana>
References: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Peter,

> To summarize the series, there's some i2c-mux infrastructure cleanup work
> first (I think that part stands by itself as desireable regardless), the
> locking changes are in 16/24 and after with the real meat in 18/24. There
> is some documentation added in 19/24 while 20/24 and after are cleanups to
> existing drivers utilizing the new stuff.

My idea is to review and pull in the infrastructure work for 4.7 and the
locking changes to 4.8. This gives us one cycle to fix regressions (if
any) in the infrastructure work first. Is that okay with you?

Thanks,

   Wolfram


--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXC5sfAAoJEBQN5MwUoCm2kUAP/jQGfszmD3bynHq8tQGbqTIh
+jYVRM0/CXpQCPklXZgusOuo99Aq8PqHnuQz8FA4s8OJbdbJcYqlxUFzoFOWwRu2
1OU4hQRfFKEgcbn8uDdH0nkV+Gzs9TLKQX1PJDOQEITi19kK7nncaOJanY1PWhc3
5ySA/jXCjB43IGOicUNyOt9uJKv/+tL2UzZmYB6vR8HaFhlVSneBuVMERsDrDjBl
8IZnUHxPrehmgQCRB/2mc7+8X2Urm1tayi0wslLrFxKr9++as3+UPK3cJ+7GT/Hu
IvuuC20hlyjW2H5e/KhN60rP/sXmz10nZeZk662VpAkC2Y0euqBQbcnT7eO5VCKx
Ovk5cs1VIYpMIn/0QR0ZAMM246v7M+Pjk+6Wi+v+TavG9Fxprd1iNcjD5dz9wi1L
lz/5P3McULOS09SPbUTF4YhqcPPpma0JsMTjz5MqiEryXbqd0Zv/xx3PIzQ6czVA
/PBHtZkkAp3Brmc0Xh7suVwuayxNBypCKHk61/Ka7dO1UYHQsK3kL+GFEbMeky00
2J7jGXyW/HLvQRPHBAn1PJ8feFpNL0PqYY/i1M9HobHeb1PFOh3yndX3TXaBlVDA
L2dASNJ4hfMqjkp2TqoO7LmFnR7ccQLBI9XezCSRQtrOQdQA3Ym3MvRKKsFAR6uE
+1TcE5VAF4XveeTtw0qp
=D4yv
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
