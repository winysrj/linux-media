Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:40235 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab3F0GR4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 02:17:56 -0400
Date: Thu, 27 Jun 2013 09:17:13 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <kishon@ti.com>,
	<linux-media@vger.kernel.org>, <kyungmin.park@samsung.com>,
	<t.figa@samsung.com>, <devicetree-discuss@lists.ozlabs.org>,
	<kgene.kim@samsung.com>, <dh09.lee@samsung.com>,
	<jg1.han@samsung.com>, <inki.dae@samsung.com>,
	<plagnioj@jcrosoft.com>, <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
Message-ID: <20130627061713.GF15455@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372170110-12993-1-git-send-email-s.nawrocki@samsung.com>
 <20130625150649.GA21334@arwen.pp.htv.fi>
 <51CB0212.3050103@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eDB11BtaWSyaBkpc"
Content-Disposition: inline
In-Reply-To: <51CB0212.3050103@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--eDB11BtaWSyaBkpc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2013 at 05:00:34PM +0200, Sylwester Nawrocki wrote:
> Hi,
>=20
> On 06/25/2013 05:06 PM, Felipe Balbi wrote:
> >> +static struct platform_driver exynos_video_phy_driver =3D {
> >> > +	.probe	=3D exynos_video_phy_probe,
> >
> > you *must* provide a remove method. drivers with NULL remove are
> > non-removable :-)
>=20
> Actually the remove() callback can be NULL, it's just missing module_exit
> function that makes a module not unloadable.

look at the implementation of platform_drv_remove():

 499 static int platform_drv_remove(struct device *_dev)
 500 {
 501         struct platform_driver *drv =3D to_platform_driver(_dev->drive=
r);
 502         struct platform_device *dev =3D to_platform_device(_dev);
 503         int ret;
 504=20
 505         ret =3D drv->remove(dev);
 506         if (ACPI_HANDLE(_dev))
 507                 acpi_dev_pm_detach(_dev, true);
 508=20
 509         return ret;
 510 }

that's not a conditional call right :-)

--=20
balbi

--eDB11BtaWSyaBkpc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRy9jpAAoJEIaOsuA1yqRE7iEP/2xOEc7U01/33BpVtGYrsgR8
1Ze72R43SgVQFrvdYuUmZJZol4y0OaEV+6Yg2umXFKD2WVSX50F3SGCRR7qCtorE
5T+kdVCzb8f1K3ubc0NAit0S0srQxU7grX6lHlJYS2LuNCiZr2oa4TMad6OPbAvg
vKCYVKBHF4AEeo355HoOEkVyFSbgRR+W8tEkXD2pOguLT48KbVovrxelRSMRkC1Q
X/HgRV38DEn6xn0aABcgJVY1D3x0FtGXIh2mgeOsBhcn7j1yZ2fvkPDXrY/CYist
Q+r0Fwjv5Kr414FSqKAInBZCIBrnC+YqlK8xdLLquO20d5/OGTinh9P3zN3gz/zj
gKfrGZUjxlpsZ96M0p2PsVGopu5D6BFiX8JjSE62aP0w7ReDL+6l1kw2V8ctijir
XvmqL3zFFrYzmba2u7AY2btBdw5z10g0RqO7QekY51xismEzsOJQUdmtdTiJOaGk
RTuOhygtLly13WH6VdqbWulUlrkpcnCqE+UoxGAjbEEGf1HusEOemEYv3xIHT/OB
NKzlitpuQ+ABjafXQlUan6+tu6gDRYquvB9/KIuote60dGGoe40gXrn7/jOPA/h6
+51HYzMcCx62s/WVl6EPeaHApRPaficHGNpoLFaOFjdlMlkuWmdy/0hqaqUz+vP0
9iypsBXoJvgnctT5DTKm
=T5EP
-----END PGP SIGNATURE-----

--eDB11BtaWSyaBkpc--
