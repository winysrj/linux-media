Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:59974 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733084AbeGLVkT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Jul 2018 17:40:19 -0400
Date: Thu, 12 Jul 2018 23:28:51 +0200
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
        linux-samsung-soc@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 00/10] Split i2c_lock_adapter into i2c_lock_root and
 i2c_lock_segment
Message-ID: <20180712212850.axi3rrfwivqymqh5@ninjato>
References: <20180620051803.12206-1-peda@axentia.se>
 <20180626023735.xj7aqhvw7ta2lq6s@ninjato>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="x66e45tdlj2g4bta"
Content-Disposition: inline
In-Reply-To: <20180626023735.xj7aqhvw7ta2lq6s@ninjato>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--x66e45tdlj2g4bta
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 26, 2018 at 11:37:36AM +0900, Wolfram Sang wrote:
> On Wed, Jun 20, 2018 at 07:17:53AM +0200, Peter Rosin wrote:
> > Hi!
> >=20
> > With the introduction of mux-locked I2C muxes, the concept of
> > locking only a segment of the I2C adapter tree was added. At the
> > time, I did not want to cause a lot of extra churn, so left most
> > users of i2c_lock_adapter alone and apparently didn't think enough
> > about it; they simply continued to lock the whole adapter tree.
> > However, i2c_lock_adapter is in fact wrong for almost every caller
> > (there is naturally an exception) that is itself not a driver for
> > a root adapter. What normal drivers generally want is to only
> > lock the segment of the adapter tree that their device sits on.
> >=20
> > In fact, if a device sits behind a mux-locked I2C mux, and its
> > driver calls i2c_lock_adapter followed by an unlocked I2C transfer,
> > things will deadlock (since even a mux-locked I2C adapter will lock
> > its parent at some point). If the device is not sitting behind a
> > mux-locked I2C mux (i.e. either directly on the root adapter or
> > behind a (chain of) parent-locked I2C muxes) the root/segment
> > distinction is of no consequence; the root adapter is locked either
> > way.
> >=20
> > Mux-locked I2C muxes are probably not that common, and putting any
> > of the affected devices behind one is probably even rarer, which
> > is why we have not seen any deadlocks. At least not that I know
> > of...
> >=20
> > Since silently changing the semantics of i2c_lock_adapter might
> > be quite a surprise, especially for out-of-tree users, this series
> > instead removes the function and forces all users to explicitly
> > name I2C_LOCK_SEGMENT or I2C_LOCK_ROOT_ADAPTER in a call to
> > i2c_lock_bus, as suggested by Wolfram. Yes, users will be a teensy
> > bit more wordy, but open-coding I2C locking from random drivers
> > should be avoided, so it's perhaps a good thing if it doesn't look
> > too neat?
> >=20
> > I suggest that Wolfram takes this series through the I2C tree and
> > creates an immutable branch for the other subsystems. The series
> > is based on v4.18-r1.
>=20
> Applied to a seperate branch named "i2c/precise-locking-names" which I
> will merge into for-next, so it will get proper testing already. Once we
> get the missing acks from media, MFD, and IIO maintainers, I will merge
> it into for-4.19.

Ping for media related acks.

Thanks,

   Wolfram


--x66e45tdlj2g4bta
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAltHyA4ACgkQFA3kzBSg
KbZ2HhAAjghhfIxl1PUVt0HWyAG9QvpZUyd/pnXG1rS1R5Ho2LBck9bTQygMLbt2
EjLyMlpLpBTNLIG3eMmsLQY5IN5TisTG72jBrfFk6bj6M9pe1Cv9y9rRwQajKdwH
3Zkppsx+FXVoopq2HqOp9RgGR3srJV+kHzpkPg23tgXoKhMmpSb7qxxk8YnCaMcF
3cU31OC1BF7GrhmhI5RpJyDOc1td7gfJjLWjfUjtj+r9gQPGvvPeB4WwV/agtFRh
TDARV2YNPuvt1+1CkQ4tuowOrBeGB8qtlP9jm1+HcyxejVBbVzEXS27R7Afw6t2d
ZY7Wkq4U+KB0JCgZ+VS5O6Q3g8F0nUUqADBNxDnkH9Vbj/Eshn9+oMQUWjn6D7my
XkEHJnUlwSf4+lN5NvUUwOjNrbG7HhogY0+6fDWgg01eibnfK017SWQm0VHgmb1X
EJIL1CMjBdlLJfCATrndShKwJIQRZmLsARZFmj+94Run5gD7bdZzMeO3CCp8Faly
NZSNeOjGEqFKFX04vmh9zNiJDo/fxMzOPd8cB71pFidYXn6DtkoZyyD74XcZExtz
5aAEBjKKUnZ79hO66oTLwQhiaORP4obH5M+yrlzOacTLIYhww+G7QGJdMdndX6zO
A2j8aCnxOVxr9Di8Pk+DXJOiskU/TyKCQeT49UdT94cSpc4r6IM=
=4bN7
-----END PGP SIGNATURE-----

--x66e45tdlj2g4bta--
