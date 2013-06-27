Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:34736 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3F0Ikl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 04:40:41 -0400
Date: Thu, 27 Jun 2013 11:40:04 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <kishon@ti.com>,
	<linux-media@vger.kernel.org>, <kyungmin.park@samsung.com>,
	<t.figa@samsung.com>, <devicetree-discuss@lists.ozlabs.org>,
	<kgene.kim@samsung.com>, <dh09.lee@samsung.com>,
	<jg1.han@samsung.com>, <inki.dae@samsung.com>,
	<plagnioj@jcrosoft.com>, <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH v3 1/5] phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
Message-ID: <20130627084004.GS15455@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372258946-15607-1-git-send-email-s.nawrocki@samsung.com>
 <1372258946-15607-2-git-send-email-s.nawrocki@samsung.com>
 <20130627075223.GQ15455@arwen.pp.htv.fi>
 <51CBF9B8.70103@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wnBGVoaGQwxWUIo6"
Content-Disposition: inline
In-Reply-To: <51CBF9B8.70103@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--wnBGVoaGQwxWUIo6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 27, 2013 at 10:37:12AM +0200, Sylwester Nawrocki wrote:
> On 06/27/2013 09:52 AM, Felipe Balbi wrote:
> > On Wed, Jun 26, 2013 at 05:02:22PM +0200, Sylwester Nawrocki wrote:
> >> Add a PHY provider driver for the Samsung S5P/Exynos SoC MIPI CSI-2
> >> receiver and MIPI DSI transmitter DPHYs.
> >>
> >> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >=20
> > Acked-by: Felipe Balbi <balbi@ti.com>
>=20
> Thank you for your review and ack!
>=20
> Just for the record, I have tested this driver as a loadable
> module on Exynos4412 TRATS2 board and it all worked fine for
> both the camera and display side.

Awesome dude :-) very cool, let's hope more users convert to Kishon's
generic phy layer :-)

--=20
balbi

--wnBGVoaGQwxWUIo6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRy/pkAAoJEIaOsuA1yqRE0usP/0kXzaQLwW6FcUZS/DU+PZ03
Blwk6lKVGICnyrhp/xYuqQKmSgSk1wMJ+KIfu8mRi0OPJ2p0u4sDAPQ8sq0oLNVS
rCwj75LqkbjqRWXYziFwyiSQqEsP1D4rvD3aDJXot+A5As86XAqc/YY629WZRraO
jbpeY4FpK1A9eWgNyW4uBtyhJQKxe2/kV3Jipw6/TOl/cO2yCE+snWJXZTbrEaOy
M1LxjHLhKqNjltxrWs5HJe2iQPSXl0zpgWZHuNht26u6wZY7F+Eo83RQeLnwzzlZ
tK25jRT5e66UZ5vkQvKv/4cDdjGdESf5L68pAUKiUa35Bmre20GiO1IIdFy1n95f
fb0FcK0Ye3RghjVDF8qqBqYnCGIR7+rHmRHp76/7PqbOujUHX0Nt8h3hqzthpA3I
Uqrow12JDInJuVEgRsSEGkSU2+DT1bbZSJT2f5AYQKLu6bYLa4QU8ZuF4Ap5vysR
UFVN8ZN2faPsB1+eQ8V2+qet5Enh46N+AAHnpe+iOJHb5khnJ8w+OKQFXwQPjag6
2f1t9Jywy0CRWueJRhIWMv07dgZAb311JLBMzT06GzmqjsfHWo3iSkuhrWXO1Ota
znPhyjEEifx4MeeMXfRJfE9PpcC59YH9YxWykbRFuWm3qApZFgBYq1hl5sZoGQxx
di/7prNpFT4B2wAJF3Nu
=OBbu
-----END PGP SIGNATURE-----

--wnBGVoaGQwxWUIo6--
