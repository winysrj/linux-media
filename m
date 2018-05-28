Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:34633 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751085AbeE1G40 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 02:56:26 -0400
Date: Mon, 28 May 2018 08:56:24 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] media: v4l: cadence: include linux/slab.h
Message-ID: <20180528065624.oxh5d4q62squs7eg@flea>
References: <20180525152523.2821369-1-arnd@arndb.de>
 <20180525152523.2821369-2-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hlp46vecmnemhdda"
Content-Disposition: inline
In-Reply-To: <20180525152523.2821369-2-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--hlp46vecmnemhdda
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 25, 2018 at 05:25:09PM +0200, Arnd Bergmann wrote:
> I ran into a randconfig build error with the new driver:
>=20
> drivers/media/platform/cadence/cdns-csi2tx.c: In function 'csi2tx_probe':
> drivers/media/platform/cadence/cdns-csi2tx.c:477:11: error: implicit decl=
aration of function 'kzalloc'; did you mean 'd_alloc'? [-Werror=3Dimplicit-=
function-declaration]
>=20
> kzalloc() is declared in linux/slab.h, so let's include this to make it
> build in all configurations.
>=20
> Fixes: 84b477e6d4bc ("media: v4l: cadence: Add Cadence MIPI-CSI2 TX drive=
r")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--hlp46vecmnemhdda
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlsLqBcACgkQ0rTAlCFN
r3QfHw/9HMdqauGqWybHAHCIC/11t6ZsEHQDfZbx1ZD7koHjH7bRl5aOG8EBRbBW
vF9BqCik/x+ajIvh3oyoR2a2RO87tszXu30q4XDeBcXbIr1pdQgSCQlC+ytcnMFS
WEsUKnbyvz1h8PwG0ZvWcDDRDghKFP6mofMrpvtj3qQe9NZll/c8BwQr5vFR8h1p
t1t2MgZKJKeEfuz5ms7EqhYIrLqZIN3MRHe/JG28LtDC7AxlRvoQRPPLaj/eL7Y4
KCITImOk7j/Q5Mzd1h7HGKJtE+XxzttX2LUUADJLr0vLQd4PbP/GbtX/cCqcFWiS
6Bx6XvhtYHgeOI6L4cfvQSNFqERM3Gxfx1kP9qf9QtwA+Ednzharm/CYd1goCPyO
pb1ghFwdcbpYI3Hkybl5OZaZ/2fccWeFtPAHZZ2HxsLPPS/8ofvz9P3NOyc1MJ13
6cVmy0IP21oPnZThvUvkCgzpQDqqnj6zRjYbRmCHNUF8q2rUpZD5Hxstm+7qJOZ9
i5Hca7YuKtgM83Ogv/QxuUzHbQ3TPk0i3PqkDbJw3E6vGJqCxfaU96l1r10w96k3
+X9xS1SBXyTd3oEmlbuO1HOuDIp8cxOrGuo702zY8LUpurKF6RKabhc62J4g1ei4
Psl/uUNJCfFBMx1VfOfC6/N2C8DahcqbQR+daGENi3iDTxFPS0g=
=VWnk
-----END PGP SIGNATURE-----

--hlp46vecmnemhdda--
