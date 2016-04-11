Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:58670 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbcDKP7V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2016 11:59:21 -0400
Date: Mon, 11 Apr 2016 17:59:06 +0200
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
Message-ID: <20160411155906.GA1532@katana>
References: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
 <20160411123959.GA4719@katana>
 <570BA845.1060309@lysator.liu.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <570BA845.1060309@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> can obviously take forever. At the same time, many of the patches are kind
> of mechanical, and feels rather safe.

I agree about the mechanical stuff, thus my suggestion. We do what we
can about testing and reviewing. And once it reaches linux-next
(hopefully next week latest), test coverage will increase significantly
and we can fix issues incrementally from there on. Same goes when it
finally hits Linus' tree, coverage will increase more, but we should be
really at a very sane level then ;)

I will  also pick up patch 15 (the removal) for 4.8. So we have the full
4.7 cycle to revert if something goes very wrong.

> Maybe we should give Antti some more time to re-add his tested-by tags
> on 9-12 before they are merged into non-rewritable branches?

Yes. That would be great. I need to sync with the media maintainers
anyhow. I'd like to push all the patches via my tree.

Thanks,

   Wolfram


--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXC8nKAAoJEBQN5MwUoCm2FhoP/0DAY/OPBBWUqB5QPDKZVfLt
IGcL/mPQHHV7KoIvPr6lJU05+zF2ntB7jKMgDZ+MUlKsSR+VK09RR92dYCEX5oWq
M35Sd6KHu/eMs+bBQFs03xpyMvO9mYEZJe3zIkJxn857BYCMHH2b0s7IzRHpdx4+
B5nCTq0haWkGrUKMIcHT0dVVszd1AqHBguAHA+TcfzGCvo+FhV+3pud+EgB+cVfy
TDUSP6NRm0uPQZLDq6cspxFuMKwQMIhkgzBoxlx/pCALtpC54vBM3TGtOobAaqnx
bntA5HbSolpyGO5IS9WMaJ0zlnHoLZqpUfcEKdAfoe4I459vjyLUKlDfpznu0Dyj
+cgJpZz66shkbWKrIuhrQ/KVG4VntGfm3BoLzcRH0JSFK0QAZGZq7u9EtghdEHvy
gDGRFG5yL5mFNV6RSm/Fu1cgoeN4E8sHjXJI1ckTczWPq2cWrdaWu05IoXKf6Lci
GQcJ4i2wdUOQMlypF7eaFVMl4ZHVIohMC29prR/NRu5fysUCXfZ3DHlX3yCNeevf
5BuHCTh4L9ZhW4BUpbgcXD2uOtWyjUexXG5XwRG+4uvwePqYdkVEkzPpJ378+iPs
thCQA6+4V+QmcrtVjk8clVzJ05wMUiw5DejpALGu3mKDQ9L4qBBGPfiP7vg4FrN6
B0+I8uxSf+1LLniLZvyB
=4NJ9
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
