Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:60328 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732381AbeGLWXO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Jul 2018 18:23:14 -0400
Date: Fri, 13 Jul 2018 00:11:37 +0200
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
Message-ID: <20180712221137.i3osg6viuz4lwvnd@ninjato>
References: <20180620051803.12206-1-peda@axentia.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qm72oajvd5nwh2m6"
Content-Disposition: inline
In-Reply-To: <20180620051803.12206-1-peda@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--qm72oajvd5nwh2m6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 20, 2018 at 07:17:53AM +0200, Peter Rosin wrote:
> Hi!
>=20
> With the introduction of mux-locked I2C muxes, the concept of
> locking only a segment of the I2C adapter tree was added. At the
> time, I did not want to cause a lot of extra churn, so left most
> users of i2c_lock_adapter alone and apparently didn't think enough
> about it; they simply continued to lock the whole adapter tree.
> However, i2c_lock_adapter is in fact wrong for almost every caller
> (there is naturally an exception) that is itself not a driver for
> a root adapter. What normal drivers generally want is to only
> lock the segment of the adapter tree that their device sits on.
>=20
> In fact, if a device sits behind a mux-locked I2C mux, and its
> driver calls i2c_lock_adapter followed by an unlocked I2C transfer,
> things will deadlock (since even a mux-locked I2C adapter will lock
> its parent at some point). If the device is not sitting behind a
> mux-locked I2C mux (i.e. either directly on the root adapter or
> behind a (chain of) parent-locked I2C muxes) the root/segment
> distinction is of no consequence; the root adapter is locked either
> way.
>=20
> Mux-locked I2C muxes are probably not that common, and putting any
> of the affected devices behind one is probably even rarer, which
> is why we have not seen any deadlocks. At least not that I know
> of...
>=20
> Since silently changing the semantics of i2c_lock_adapter might
> be quite a surprise, especially for out-of-tree users, this series
> instead removes the function and forces all users to explicitly
> name I2C_LOCK_SEGMENT or I2C_LOCK_ROOT_ADAPTER in a call to
> i2c_lock_bus, as suggested by Wolfram. Yes, users will be a teensy
> bit more wordy, but open-coding I2C locking from random drivers
> should be avoided, so it's perhaps a good thing if it doesn't look
> too neat?
>=20
> I suggest that Wolfram takes this series through the I2C tree and
> creates an immutable branch for the other subsystems. The series
> is based on v4.18-r1.
>=20
> I do not have *any* of the affected devices, and have thus only
> done build tests.
>=20
> Cheers,
> Peter

Applied to for-next, thanks! And thanks for all the acks. An immutable
branch can be found here:

git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/precise-loc=
king-names_immutable


--qm72oajvd5nwh2m6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAltH0hkACgkQFA3kzBSg
KbZDYg//UGVwnuphbOMKhmwxqf3WAAQyKPV28EuVpX8NIevvAgiCFBuCKmH1aZjk
1z+4AYTgfiefQoJ1hZKoIRv0AGAmQ/jwNtJYhQdDfrVLx/BMUouL9JtZubWosatD
gIcaSKx1fGsvxgYPTfBk5sEnLwlG52g5lWJnSXlMeA5wyKzBBS/zpa6eHGyBiMq6
2zUHEJa09BydQDfZ3yXNY3KU3Y/tlaK2sexiM6y2tt4uzoqV4eExKO1jvVwVZhvK
HSK3RSnWaTQzeim8OVmyWUj/AgnH6rTRvGw9/LijXmKmBdTvqAvqPJpIQRIaklFs
bHyHMB/jcw2QJw5N/6g1myg/8unfkP7Iq0MkA7/K2SckdAdSYGbAudDqhWwOBqPK
p7RWS9Si5LqR2d7hFgzXNZDKdmERzG24/JQOi5vw4IOdaXTZ5FBzPg1V0xHpf7uy
dIzmaN4TeNdS0CFvr0c4gyex+7TD6ejC2CqgtTnX5AGiXqONRDlg/K+K66tMGZyB
n6TzknvGLgWreNKZfnLjs/ZoT0J9joUj2v9DEhGUT4pJIN+j6MjKGwNKvrwfRpmb
V2uL5mNSEJdc5+IpIngTuHLnjtQnbqbq3UlIkEc1iR/iuKZqrNHCUJib9fHErV81
25/XJBC+188GB/Ifm1sMRf40z7GMmpOkpvs70pT8eZCqBtRvNvM=
=3VaW
-----END PGP SIGNATURE-----

--qm72oajvd5nwh2m6--
