Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:33382 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbcDKVBa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2016 17:01:30 -0400
Date: Mon, 11 Apr 2016 22:59:48 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Peter Rosin <peda@lysator.liu.se>
Cc: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
	Peter Rosin <peda@axentia.se>,
	Rob Herring <robh+dt@kernel.org>,
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
Subject: Re: [PATCH v2 1/8] i2c-mux: add common core data for every mux
 instance
Message-ID: <20160411205948.GB10401@katana>
References: <1452009438-27347-1-git-send-email-peda@lysator.liu.se>
 <1452009438-27347-2-git-send-email-peda@lysator.liu.se>
 <56F3B86E.4050002@mentor.com>
 <56F3CA0E.60906@lysator.liu.se>
 <56F3F89F.8000805@mentor.com>
 <56F43919.1020501@lysator.liu.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5/uDoXvLw7AC5HRs"
Content-Disposition: inline
In-Reply-To: <56F43919.1020501@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

> > I'll try to find some time to review the whole changeset carefully,
> > in fact I briefly reviewed it two months ago, but I didn't find
> > anything obviously wrong that time.
>=20
> Please put that on hold until I have rebased ontop of v4.6-rc1 and
> changed a couple of other things. I'd hate for you to waste your
> time on outdated patches.

v6 is out now. Any help with reviewing/testing is much appreciated!

Thanks,

   Wolfram


--5/uDoXvLw7AC5HRs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXDBBEAAoJEBQN5MwUoCm224UP/0zp4vRM9skuIiLNsfaIxv7E
sjLJjKIJ4h9k8Uv9NZstWCWDqWtizGgcdNQddDaftAPQCDO6TDKGDr5Ctg9T6Mdc
Pk3CBATV3XOKpxUm9ixxFf8ageGkBfYTilStJFci4r8PJe1QLjCbGfrvooc8IKCl
Encm78IvcUVQ4TnAD8VmZ6+7XMGl+pGIVO/dwi4frQ9LlFK60MqyPsUBaLqI1P8C
Q1Qh24DKPnsnX84GcwsiZBj0lsEFHIUKxpZIm+/5zGEI8UmsAkd/xD/Y7BUBYvIN
3rSeYOPoiE1lCfHyo8WZ20zJIlH7YhIv2AhSz0Lk9SbcU1ifhOhCcM//0TiLrhae
8678sa/H2NKE4m3QQMdy01PGVTL13FLpTlye+mvhyJt/Ou/mdiZpsu7GOxf+Mqzt
NPTpr2n8YlWgA9cRhaygve/qLQAO2pE3UsKTv/ZsoEympX7nNAPdiUcr3tJfGfLP
CZYj53MeP4t/ClBJA+T47lBknp+YDkclov0A3xTZyhLAsoCSRwuJyAQALJSD5W3K
FSnLdviraSebkKBa3EGkwkjHVFGy138kT6zSIigUaPoSV3lLr+YUegXeGt4L0dF8
6zEgBxSrJ9MyOWdf4dQQlKZocyq1K7LAbubVVumxvoG5t5Zbl5LCdnSfgFTZJ/KD
pcmufHEh5X7R3jbdB61u
=pWzM
-----END PGP SIGNATURE-----

--5/uDoXvLw7AC5HRs--
