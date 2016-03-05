Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:32948 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbcCESar (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Mar 2016 13:30:47 -0500
Date: Sat, 5 Mar 2016 19:29:35 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Peter Rosin <peda@lysator.liu.se>, Peter Rosin <peda@axentia.se>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Frank Rowand <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Nicholas Mc Guire <hofrat@osadl.org>,
	Olli Salonen <olli.salonen@iki.fi>, linux-i2c@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 0/8] i2c mux cleanup and locking update
Message-ID: <20160305182934.GA1394@katana>
References: <1452265496-22475-1-git-send-email-peda@lysator.liu.se>
 <20160302172904.GC5439@katana>
 <56DB1C07.4040008@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <56DB1C07.4040008@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Perhaps it's one to let sit into at least the next cycle (and get some te=
sting
> on those media devices if we can) but, whilst it is fiddly the gains seen=
 in
> individual drivers (like the example Peter put in response to the V4 seri=
es)
> make it look worthwhile to me.  Also, whilst the invensense part is plain=
 odd
> in many ways, the case Peter had looks rather more normal.
>=20
> At the end of the day, sometimes fiddly problems need fiddly code.=20
> (says a guy who doesn't have to maintain it!)
>=20
> It certainly helps that Peter has done a thorough job, broken the patches
> up cleanly and provided clean descriptions of what he is doing.

Yes, Peter has done a great job so far and the latest results were very
convincing (fixing the invensense issue and the savings for rtl2832).

And yes, I am reluctant to maintain this code alone, so my question
would be:

Peter, are you interested in becoming the i2c-mux maintainer and look
after the code even after it was merged? (From "you reviewing patches and
me picking them up" to "you have your own branch which I pull", we can
discuss the best workflow.)

If that would be the case, I have the same idea like Jonathan: Give it
another cycle for more review & test and aim for the 4.7 merge window.

I have to admit that I still haven't done a more thorough review, so I
can't say if I see a show-stopper in this series. Yet, even if so I am
positive it can be sorted out. Oh, and we should call for people with
special experience in locking.

What do people think?

Regards,

   Wolfram

PS: Peter, have you seen my demuxer driver in my for-next branch? I hope
it won't spoil your design?


--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJW2yWOAAoJEBQN5MwUoCm2h8QQAJpKVERebHnxPRdoWQvKdFgA
bAkwdGd9yBqmnBLvZ7MmxLOqRdZAd9YoXa2D7fVAUeVC20nGiicwpMALB4JwUC/I
6zmMQjEwQtErLKnHx3MUvELmsvnj5jhlFph17KgmtH4scKrJmzSSPdv//L02CxYT
CwdmPCZAfqdSbpa8X+ZIyrMBuy0h1dYcytj5ZXlz8tXugqSSpnk7t0ruwMq3gVuy
L50WIpWF6dJpMQRiRPVh5d5tKUOEYCbb2PbHGjIq7msFYTdD/fg6Ml4dIZuxf80C
Fj8YwNoPEq+OuXFvF0r6PYyYZ2XfW+2wdqNRmRAr9Xt+ECav3wNMZb8E7RqfoVmE
ssXkInXcg0+oofVNPHDzJYFQxjfPqmY4N32nmQ88z1HUCaUwA5Abfmw6SWfcI92f
VcNjAs5AQVDzhfpfwm/atwTGs1xm6gXQymL77hDvmKQnOUvIRATuXHjSB+FLbuSs
ypt52ZDBml0xdMTdwznX8uThijBeM6Ynw4w2UkIqkgipOfCzDuomcHd/+8n8z3i0
WwA5NKx8rI65R72BXkHj0nHy4c9StOuTXfNilMVyBHIsE8K+GDbdu375em3TuKcD
qiJRUHk0xpdmnhrXbURzUzvnbc3BdeG/JDJd/ErVycicx6wSXtktaqtRiEjwreSG
qK61eIj0COHEjoX/hk3s
=rkf3
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
