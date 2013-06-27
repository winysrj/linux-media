Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:45297 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab3F0Hvj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 03:51:39 -0400
Date: Thu, 27 Jun 2013 10:51:00 +0300
From: Felipe Balbi <balbi@ti.com>
To: Andrzej Hajda <a.hajda@samsung.com>
CC: <balbi@ti.com>, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	<linux-fbdev@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
	<t.figa@samsung.com>, <jg1.han@samsung.com>,
	<dh09.lee@samsung.com>, <kishon@ti.com>, <inki.dae@samsung.com>,
	<kyungmin.park@samsung.com>, <kgene.kim@samsung.com>,
	<plagnioj@jcrosoft.com>, <devicetree-discuss@lists.ozlabs.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
Message-ID: <20130627075100.GP15455@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372170110-12993-1-git-send-email-s.nawrocki@samsung.com>
 <20130625150649.GA21334@arwen.pp.htv.fi>
 <51CB0212.3050103@samsung.com>
 <20130627061713.GF15455@arwen.pp.htv.fi>
 <51CBEE23.4010402@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PdAWLd+WEPmMbsbx"
Content-Disposition: inline
In-Reply-To: <51CBEE23.4010402@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--PdAWLd+WEPmMbsbx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 27, 2013 at 09:47:47AM +0200, Andrzej Hajda wrote:
> Hi Felipe,
>=20
> On 06/27/2013 08:17 AM, Felipe Balbi wrote:
> > On Wed, Jun 26, 2013 at 05:00:34PM +0200, Sylwester Nawrocki wrote:
> >> Hi,
> >>
> >> On 06/25/2013 05:06 PM, Felipe Balbi wrote:
> >>>> +static struct platform_driver exynos_video_phy_driver =3D {
> >>>>> +	.probe	=3D exynos_video_phy_probe,
> >>>
> >>> you *must* provide a remove method. drivers with NULL remove are
> >>> non-removable :-)
> >>
> >> Actually the remove() callback can be NULL, it's just missing module_e=
xit
> >> function that makes a module not unloadable.
> >=20
> > look at the implementation of platform_drv_remove():
> >=20
> >  499 static int platform_drv_remove(struct device *_dev)
> >  500 {
> >  501         struct platform_driver *drv =3D to_platform_driver(_dev->d=
river);
> >  502         struct platform_device *dev =3D to_platform_device(_dev);
> >  503         int ret;
> >  504=20
> >  505         ret =3D drv->remove(dev);
> >  506         if (ACPI_HANDLE(_dev))
> >  507                 acpi_dev_pm_detach(_dev, true);
> >  508=20
> >  509         return ret;
> >  510 }
> >=20
> > that's not a conditional call right :-)
>=20
> It is conditional, just condition check is in different place:
>=20
> int platform_driver_register(struct platform_driver *drv)
> {
> 	(...)
> 	if (drv->remove)
> 		drv->driver.remove =3D platform_drv_remove;
> 	(...)
> }

good point :-) thanks. I'll go ack your driver now

--=20
balbi

--PdAWLd+WEPmMbsbx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRy+7kAAoJEIaOsuA1yqRE2FIP/iIkHzTyiGQ2V6Zbn1OASAOp
04rPRzVBX2dvFh4Sqe9lXuh9D4YFDz2+My8EW9WLHQD8TRD3ez5FH47CmrhDhxVN
vPzPO5rawQh7YEb4f4LuUHNgJ/1j4LpFxga1FjS4x/cZWqqEwkvThGjV7ZmbiJd7
iPP9Ve1Zhx6dB4cn2gTK0rorKjz3KYbfRERHr3LUc8YVnwvm30o4QEXMHH1ES8zN
Jj0a3p9UNhT0SnYDRyNXxC7Ga2XJl38LiviXatV0oNgagVhnLhOYyzVSuOs12VYx
9rdhUk0OM7G3CS1NssfnA8I89igxJ/BpAUuTCPtRXSCHnn/kMxjMOdKj4eB40vpN
9wX4S5vLblciEW8UPXzSGh11a5qaQePzE7mV+89V0CztdTPxNTQaIXSIdL4nKSlY
Ksw0b62frgljANfz3QJLKllwvAsOijYxVli7jYLePlkCJqeSS4/S6V1i/FvA5tFe
1UbtD8nt9S4FV5we6SkJH/Ogtf1pxehMOT+fpzlzYcPAG8UNM3f30/IeATm5ISX3
66e3w2JfozxWRDb/9awXztCzHXZPcUYq0guWxqShZT5FYpmPKjRanYegLkkA3iOb
SQ0sJdWzoPsBKVD6sUDxeQQ2YZMURhh2d/e4BFOgKN/9CetpJ68S7QkaHAAFdlo/
UJxuL7vVL01BDY4RAppa
=YrxN
-----END PGP SIGNATURE-----

--PdAWLd+WEPmMbsbx--
