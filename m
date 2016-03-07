Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:59188 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbcCGKYP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Mar 2016 05:24:15 -0500
Date: Mon, 7 Mar 2016 11:23:09 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Peter Rosin <peda@lysator.liu.se>
Cc: Jonathan Cameron <jic23@kernel.org>, Peter Rosin <peda@axentia.se>,
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
Message-ID: <20160307102309.GA1405@katana>
References: <1452265496-22475-1-git-send-email-peda@lysator.liu.se>
 <20160302172904.GC5439@katana>
 <56DB1C07.4040008@kernel.org>
 <20160305182934.GA1394@katana>
 <56DD3E1E.5040003@lysator.liu.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <56DD3E1E.5040003@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> My offer is going to be this, I'll look after any unforeseen future problems
> caused by this rework, and I can be the i2c-mux maintainer. But if being

Yay, thanks a lot!

> the i2c-mux maintainer turns out to be a huge time-sink, there is no way I
> can stay on in the long run. But I guess that is the same for any maintainer
> (whose job description does not explicitly include being maintainer).

Well, since I became the I2C maintainer in late 2012, i2c-mux was always
low-bandwidth:

$ git log --pretty=oneline v3.2.. -- drivers/i2c/muxes/ drivers/i2c/i2c-mux.c | wc -l
72

And your patch series is already bigger than what was accepted in the
last year altogether :) I understand the uncertainty feeling about this
step; however, I truly think it is not much work. It is a niche -
though, one I'd like to have supported by your expertise.

> the mux update. The main commonality of the demux and the preexisting muxes
> seems to be that the name includes "mux" and that it is all about i2c. Agreed?

Yes, and because they are quite different, I wasn't sure if it a) is not
affected at all or b) totally breaks the design. Glad to hear it is a).

Thanks again, looks like we have a roadmap now for getting this series
in \o/

   Wolfram


--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJW3VaNAAoJEBQN5MwUoCm22/IP/1RlgbCkTAdpLAodKwAhH57d
ctOvoI7DNgYrKaTcy03vefZirGa79BUwkobZs4LOvXfDoIYCn/+UN3s0ykVJYJyR
gBbGwiUoSDkHgrWI1XuP8vkg2QTG2M5W6n9XffXsdLQSUlwysLkrNICKJ+tDY0Fd
FRH/QjQx/HLXPqjRTOKizLFXjCYeJVm9a7z3KHE3EH2QiC2Rl7tM2P+IPHpPK15V
xOLf4ey5KszkMUrWxH4/ISngNJ2mj7agyQMEgSvFuLdo2SwRZCtjlpNXbvsv27Vw
EcXaLPc40iFJzCrhpQb+cXaEXhn9yEPQLe/ZEO5NkGO5Q2JM11/uS/cGvjEi1Q1G
xW9f3xbvdA3/Alku/ToqTtM5pAjFcmAf1QqacyirqJCPIHUs2MdYuXv9rkSAEm+u
KRX6CST3E/hu/sC2qR9vLUXueaHnf14hpoeNLDIRKzxRkC5VHBEt1LBV8SHLrs/L
JWpLkQOgBIkUaAFast6TTsr67BFOKaGYtvS8OmpnE4+nr0NGai2U+NbXie+pdB0Q
4wi1WE6e03DKB91wexmHIWFG71okoGwE/+dOHEaDORXe8LiiQ98SwkWAuxcUtP/n
Wk24wIWXX5IQqXpjXqTzAA+Pvt1YM1NoIU615joFlBfRUihKxnWWHi92Do7iHpPZ
xCtR0hIAVdtg/nlLDj2y
=2jMg
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
