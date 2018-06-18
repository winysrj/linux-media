Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:48248 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933664AbeFRLFL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 07:05:11 -0400
Date: Mon, 18 Jun 2018 20:05:03 +0900
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
Message-ID: <20180618110502.cb5s24srp4frahm6@ninjato>
References: <20180615101506.8012-1-peda@axentia.se>
 <20180615101506.8012-2-peda@axentia.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kyrdsz3663p2mr6a"
Content-Disposition: inline
In-Reply-To: <20180615101506.8012-2-peda@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--kyrdsz3663p2mr6a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> +static inline void
> +i2c_lock_segment(struct i2c_adapter *adapter)
> +{
> +	i2c_lock_bus(adapter, I2C_LOCK_SEGMENT);
> +}
> +
> +static inline int
> +i2c_trylock_segment(struct i2c_adapter *adapter)
> +{
> +	return i2c_trylock_bus(adapter, I2C_LOCK_SEGMENT);
> +}
> +
> +static inline void
> +i2c_unlock_segment(struct i2c_adapter *adapter)
> +{
> +	i2c_unlock_bus(adapter, I2C_LOCK_SEGMENT);
> +}

I wonder if i2c_lock_segment() and i2c_lock_root_adapter() are really
more readable and convenient than i2c_lock_bus() with the flag. I think
the flags have speaking names, too.

Is that an idea to remove these functions altogether and start using
i2c_lock_bus()?


--kyrdsz3663p2mr6a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlsnkdkACgkQFA3kzBSg
KbYHrxAAq5XQSNo6hQGYuXMRkA7MybJvlJqw3Pp8w2csvX2JO0CFIq3RA1WcHkav
nQZKZTByfrB/oCh+La6HhIy59XgmyetlSLo3u+VQ5YinF3XK6JBKfeImWuLUS706
vRiptpAMjjaW2SbGJ3NOalr3mgcZ9ru1j4lhN9yq3iBMvWv7uzDAUMmMRtaNNqWx
aWtIdaWozAyGdKiRh7fhaP0uZXGGC4JDxurrgNE1tGPqkNAMSTD+rGvgEux+A/z3
nO2UTLmQf/UYDv50FJAFsrl6magReFxyLV7WrJz+wj3l3UyzMEYmGEW3i/j0MZ6A
WkfLGPpYHEXeX6HRbDE2p6gCuTpWyXBbLBV3fyvSJ6/2qqGnEIxk08Si0XmGwHJi
Y+t63nhtVzVE2HmU0KssJBKa4C86/bROyDEgkTsq3fijA8ec3i3RtMAgB0DmQat3
WiACufPjP+n36+IgtKn7UzzaqfuRwUVB788O+E4CI+AVHNTN7maHyBjyTB8Sx/cX
k5p2FzxEVlVnsANHTL6Mhw4GfZLMP6ofU5MrIEiKIAX53QSOwvg7EoXXu4skUbgv
JjPqOsqSQOR755iXJ/al/sJCQYnMvpWmTqTgFnqq19jHkLO4bczEa6AoTZlD1XRN
b2aWYQrXXSKySuOB/X1BqGdfw5Kals3WHGOB7/bVf9LKhSaLUsc=
=uT/j
-----END PGP SIGNATURE-----

--kyrdsz3663p2mr6a--
