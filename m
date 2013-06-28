Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:59583 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214Ab3F1JdX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 05:33:23 -0400
Date: Fri, 28 Jun 2013 12:32:47 +0300
From: Felipe Balbi <balbi@ti.com>
To: Jingoo Han <jg1.han@samsung.com>
CC: <linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>,
	"'Kishon Vijay Abraham I'" <kishon@ti.com>,
	<linux-media@vger.kernel.org>,
	"'Kukjin Kim'" <kgene.kim@samsung.com>,
	"'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
	"'Felipe Balbi'" <balbi@ti.com>,
	"'Tomasz Figa'" <t.figa@samsung.com>,
	<devicetree-discuss@lists.ozlabs.org>,
	"'Inki Dae'" <inki.dae@samsung.com>,
	"'Donghwa Lee'" <dh09.lee@samsung.com>,
	"'Kyungmin Park'" <kyungmin.park@samsung.com>,
	"'Jean-Christophe PLAGNIOL-VILLARD'" <plagnioj@jcrosoft.com>,
	<linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH V2 1/3] phy: Add driver for Exynos DP PHY
Message-ID: <20130628093247.GB11297@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <001f01ce73cf$46d8c940$d48a5bc0$@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Content-Disposition: inline
In-Reply-To: <001f01ce73cf$46d8c940$d48a5bc0$@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 28, 2013 at 04:15:32PM +0900, Jingoo Han wrote:
> Add a PHY provider driver for the Samsung Exynos SoC DP PHY.
>=20
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Now that you fixed Kishon's concerns, this looks pretty good:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzVg/AAoJEIaOsuA1yqREwDYP/AsIqxzypV1GV5FsilYgeiYv
lFFb/+n+AlgOFkoe4JJOJMlxkukMBgu2pTXB4dg+QAbF6Nhb+bJ/3XVeUFERQeae
nzrifhvuFZn9rnqkQ3vhiYucnn7jN2cgbnzIcGogAGGd4KtA+m6JdGsi9tLM/fLS
kZEHv++owa63Cud6EY6eXfMDk5hk+Ym6Yk5e5RLX0+Ox2mhSzjzo4rmvI+vXq7Of
lQh8/+GfE75GUs9giYE6bWmrTjGddVZjKD6euv1AfZE4jq8RLdosfnLn4y2ZIagk
KUSC3vBR2Jk540nUy4ObGxhaG9yT3uR+TU7lXX/AwcL5HwDUDo3gtUUOPOU32wkJ
vu4207RUwd+IPUZeW2nVtv5b4y8HTjKgOW9JFNrcSSb87s5Eez1GABK98CfszCF9
MBuIKhYpNYPnLZoxNzjiizBjY50DUzpVrWZvHqfCl9+knoWJEKu5mLfEvqW1JGtq
7UkCT8jFaKtbHQO+Bdz5JAa1K0+yM3MALWMiFjty2JrNrcckBehFRqGBi/tJZc/U
ZpDKKS11/twI3D7nELf9WFxt/7L96SaduZtLBKwoZVYmKBbx9U0567H6EwR+GCPY
OwGUQ2a0QqYV3JQw5oGVeK5hy8ZIgZ6IvFiIxCwmxIiU8ra1AkoMHVOdzLG4PcOi
N2431qH8bh6agDl78tZh
=BnXT
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
