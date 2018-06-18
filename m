Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:48592 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932870AbeFRLyx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 07:54:53 -0400
Date: Mon, 18 Jun 2018 20:54:46 +0900
From: Wolfram Sang <wsa@the-dreams.de>
To: Peter Rosin <peda@axentia.se>
Cc: linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@kernel.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>, Crt Mori <cmo@melexis.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Lee Jones <lee.jones@linaro.org>,
        linux-integrity@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 01/11] i2c: add helpers for locking the I2C segment
Message-ID: <20180618115444.pgjmfntp767zuvmw@ninjato>
References: <20180615101506.8012-1-peda@axentia.se>
 <20180615101506.8012-2-peda@axentia.se>
 <20180618110502.cb5s24srp4frahm6@ninjato>
 <b860025e-3d4b-f333-80b4-3831dd969757@axentia.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="odyilowjkqhfymya"
Content-Disposition: inline
In-Reply-To: <b860025e-3d4b-f333-80b4-3831dd969757@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--odyilowjkqhfymya
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > I wonder if i2c_lock_segment() and i2c_lock_root_adapter() are really
> > more readable and convenient than i2c_lock_bus() with the flag. I think
> > the flags have speaking names, too.
> >=20
> > Is that an idea to remove these functions altogether and start using
> > i2c_lock_bus()?
>=20
> That would be fine with me. I don't have a strong opinion and agree that
> both are readable enough...
>=20
> It would make for a reduction of the number of lines so that's nice, but
> the macro in drivers/i2c/busses/i2c-gpio.c (patch 11) would not fit in
> the current \-width (or whatever you'd call that line of backslashes to
> the right in a multi-line macro).
>=20
> Does anyone have a strong opinion?

I have a strong opinion on making i2c.h less bloated. And yes, less
number of lines is nice, too. I think that surely pays off the
whitespace exception.

Thanks!


--odyilowjkqhfymya
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlsnnXsACgkQFA3kzBSg
KbanHg//QoW7vYFlzaQmn4GWdT8DHxpMggaefmiIzNdCezeBGZf+7umVKJ9JwScH
L7tMU76PFrWS8PRJv678TUzIgCamMUepR8AX99kR79q2VKTucHnprWc68WEelO71
j5C9y/Vc7Oa+AnD6DlnV5JySSjcHTNH1beivLlpU/AATcT1qJf6acYkJfV8h4JCP
F+wOu6gt2SjsjPY/Naj8NiCXzW1n1be46vOKuwvTcxEcIvs1qSkoMr52S34y/VUP
DuXFqwsySm0Yb/Z+lF7nOKwEgJ8PV2Y5IPvsnK+KAt86d5X4ivnLgr5Lw6DCGShX
VhUGaYI9amhtSVT77mpiz+TvUoi3vvUccVKvVUMicGFvNG0b+45wHQwJiGRYxuzn
57/Fdm+7Dr5/IhqP0HRNc7rWorrT2NcDCJp+Pea5xcSXpsKkoMdLaCW994T1aT0g
78utxNnqS21O3GCdITN/IO4xbCN1dNX9+x/6sl5Ks9xO0WA3Fvl1fOlslvVknSAp
4cJRMWOlxqK6NCU4dHy762yptyVrpzp/01jcofLJhpkLRxQjXSiJpk/C6BxZsipa
a1uyKean7DC8imJX2StUVaKCA9ava33fJau+HBC3TPLXzh54mU8FI+FZTrxB89Aj
g+8WH14/n0PrTsvFDkLcgGRVY4uQwPkWkM3HYkauUmyyPFs+wYE=
=CA/X
-----END PGP SIGNATURE-----

--odyilowjkqhfymya--
