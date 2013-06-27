Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:33292 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab3F0HxF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 03:53:05 -0400
Date: Thu, 27 Jun 2013 10:52:23 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: <linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <kishon@ti.com>,
	<linux-media@vger.kernel.org>, <kyungmin.park@samsung.com>,
	<balbi@ti.com>, <t.figa@samsung.com>,
	<devicetree-discuss@lists.ozlabs.org>, <kgene.kim@samsung.com>,
	<dh09.lee@samsung.com>, <jg1.han@samsung.com>,
	<inki.dae@samsung.com>, <plagnioj@jcrosoft.com>,
	<linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH v3 1/5] phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
Message-ID: <20130627075223.GQ15455@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372258946-15607-1-git-send-email-s.nawrocki@samsung.com>
 <1372258946-15607-2-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qnK4RqISe3HuYx1/"
Content-Disposition: inline
In-Reply-To: <1372258946-15607-2-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--qnK4RqISe3HuYx1/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2013 at 05:02:22PM +0200, Sylwester Nawrocki wrote:
> Add a PHY provider driver for the Samsung S5P/Exynos SoC MIPI CSI-2
> receiver and MIPI DSI transmitter DPHYs.
>=20
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--qnK4RqISe3HuYx1/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRy+83AAoJEIaOsuA1yqREx9kP/Rxgg8Ajq+fiVZN0cviNBeJt
oyKEqiTAbdqXrC6ncK+akon4WpyIt+YcubExZI88MTOXXjFmqSpXboB/SqxoznRl
ne8R9QM8oAa00tONvi3njeDzN07etC2X6VCc3hmpZScEmP2iKzD2sB/asZNLuE2n
MAFGeWEeqlEN/2B93aNIZT7EGrHSoTjQI2K5jHmFsbcDmSV/N2UuSOgWBvjPmCab
GY27fKv7fVCUvmp6GdYcJDIVq5XsMbuYKaegS6SEQ15eh/SepFhAO1bQFVTXi0C7
RLBWvIlkj7SrW7KJLG1zWZHl7lIE1ShN9P7EgmTRiR7+o4wmSO1MQNYpcw4FYLZs
UFJe+i2cGCrnBDJE6Se6xcCgXt9/bHjFor0fJ8QuqEAwTqzqeo/bnzM6HQQhqJe5
sIOxIxeFMc564TgP2X1qd6Bayl7NcgF9R8IrDIoFD5GJ9P0HtBgHmu/PyA7WqNYs
s+3IhbCq9wIwX05rTT5HNbWnA3P/5unQGs2tAv5KnItPoemQ7Fk+jH8qj16d+pSM
vJdFx0ewlAyzw9FkHAlF9xjebb21Ljbuiv5DZ8PZxonwSMt1FG/akm2hdrdwTAPZ
RYp8p87n6+nEMD+AOKXaYYVbHXmySe+fkCTsaVubDsjYXFzpFokOkveAoiYLPLAa
ANHgUEeMLIqcrYrvNRoa
=v/Vo
-----END PGP SIGNATURE-----

--qnK4RqISe3HuYx1/--
