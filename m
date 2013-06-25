Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:42736 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab3FYPJl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 11:09:41 -0400
Date: Tue, 25 Jun 2013 18:09:08 +0300
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
Subject: Re: [PATCH v2 4/5] exynos4-is: Use generic MIPI CSIS PHY driver
Message-ID: <20130625150908.GC21334@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372170110-12993-1-git-send-email-s.nawrocki@samsung.com>
 <1372170110-12993-4-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VywGB/WGlW4DM4P8"
Content-Disposition: inline
In-Reply-To: <1372170110-12993-4-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--VywGB/WGlW4DM4P8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2013 at 04:21:49PM +0200, Sylwester Nawrocki wrote:
> Use the generic PHY API instead of the platform callback to control
> the MIPI CSIS DPHY. The 'phy_label' field is added to the platform
> data structure to allow PHY lookup on non-dt platforms
>=20
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--VywGB/WGlW4DM4P8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRybKUAAoJEIaOsuA1yqREJ/AP+wVZAqcv5RW7YN7jEYIdeToa
DVGR4J/QUAG4mdvLT0UNBbOg85dMXVhq/uWcgj9JliWhEtG/yBek98foL1RJweZN
gEvKRv41uzzrY9TWQI3Q4uYcCWCWLMEzqqBcbB1629wyUOQbrByfxQyhhQ1l9Te/
yELVyYyGofctYqAYkSMM3zUwhWOWV8WaYVopBbV8nG47bujE0noSlU7EqsGJChKE
B4gYXgp/L/f06EEySWY2Agssr5oqm2NuK5M5tRLCohEihl/MdYsZHYwxBLMB4cKL
ODMy3tn6QRofyRtWLYnutJ7D7TwQ9c1B1T8459OZ0tZYkd/zuGmlJycyW9Q4FxD2
lql7V8Qpryg/9snmkMtBicR9hPVqITWzyYaoikichLP2YV7gpD3yAY4XnsXmq2ca
s+kuzu54I52Yw5pff8xJF+PZ4F3g2nsf2QvCSSABuReeIxgfVEgjF2mQI1lBuRQN
PVCkZ+hwFGIt7zypCQg+jF3rC/Gvq83gdLLkVkg5Ny04KT34GoGCiWwG/MGh+Rss
cDPSOxaC7mPBkiKU/iSBHQ2ehZ/8T1Pq3P5DLRaMQbFiqFp1mxkUWnqTvZVI/5qK
2L9eKEChTZ7RK1bDkIj32/2G+DVTiZv3l7j3V0DJkUzikzzYU32lj4UC9j/LLOVL
YeWJUeIme8SU5htkUVsv
=NPCH
-----END PGP SIGNATURE-----

--VywGB/WGlW4DM4P8--
