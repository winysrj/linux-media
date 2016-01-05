Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:58138 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbcAESt7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Jan 2016 13:49:59 -0500
Date: Tue, 5 Jan 2016 19:48:19 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Peter Rosin <peda@lysator.liu.se>
Cc: Peter Rosin <peda@axentia.se>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Frank Rowand <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Adriana Reus <adriana.reus@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Nicholas Mc Guire <hofrat@osadl.org>,
	Olli Salonen <olli.salonen@iki.fi>, linux-i2c@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 0/8] i2c mux cleanup and locking update
Message-ID: <20160105184819.GA1743@katana>
References: <1452009438-27347-1-git-send-email-peda@lysator.liu.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <1452009438-27347-1-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Peter,

> PS. needs a bunch of testing, I do not have access to all the involved hw

First of all, thanks for diving into this topic and the huge effort you
apparently have put into it.

It is obviously a quite intrusive series, so it needs careful review.
TBH, I can't really tell when I have the bandwidth to do that, so I hope
other people will step up. And yes, it needs serious testing.

To all: Although I appreciate any review support, I'd think the first
thing to be done should be a very high level review - is this series
worth the huge update? Is the path chosen proper? Stuff like this. I'd
appreciate Acks or Revs for that. Stuff like fixing checkpatch warnings
and other minor stuff should come later.

Thanks,

   Wolfram


--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWjA/zAAoJEBQN5MwUoCm2ClEQAJsS3qEeMVIXykMeWdJGf1r7
b3UDxZ1cQcPK9iXu9hh5v8YEHocbdK3Lma0fMTJzJqLlpvU5BItsx4OfboCyP2d+
OGdF7tq+Rxyq1VC/l8MM72h1qbHFervipIFzhkxy/AqrRwqSc/n1f30AtIEu2Wf/
gtNNsb9nasFOLLlfYFLM+R3trkkD/7zGe99CgtY7JcliiuIU59TCoi7dNtb/1Z5p
d4lotXyweW8tomVss0LZlvvjpC0HAIHolZFURFIeG1wk8q0scqQlSfZTA4MCagUy
9I5g5zPnA3RJXcUtKUd3GybufUdrbZgGs6m0uRRJoK3oY55G7mbu8jnRFgS0TJA5
4X6eeegye4yg2uscHFTEzaVKF7yfqTH7S9eqVMTFcrgzXwUpqcp8nlBDG10xuYod
xbYoles3VIeb8ZDUiNXDphNKbJX4GkdScVu91h5vKrYfOyE86Zva9l7GQ2heAM/F
o3b+Rare0hPQYBfdwEIez9zku0IExh6DK3JT9GRe0Ef0zeRL1nTtBs4rlDUI1REU
bIDu1nrUEBzHTZRZF4XwhpFWwWrlx1Swb9mEbyXseSpw9fbVNuhir6szOHlds1XD
gPLQTP1/6AWWpbWuhlleCAqtOeTGwVb54/FH2Wvubg27rj47h1Vm+0JgsedTpQs0
MTC5diFZPV05T7Rwu17u
=Nlv6
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
