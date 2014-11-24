Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:43925 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750729AbaKXWFF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 17:05:05 -0500
Date: Mon, 24 Nov 2014 23:03:27 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH 3/9] clk: sunxi: Add prcm mod0 clock driver
Message-ID: <20141124220327.GS4752@lukather>
References: <1416498928-1300-1-git-send-email-hdegoede@redhat.com>
 <1416498928-1300-4-git-send-email-hdegoede@redhat.com>
 <20141121084933.GL24143@lukather>
 <546F0226.2040700@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jo46wx5DSA4a/gWG"
Content-Disposition: inline
In-Reply-To: <546F0226.2040700@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--jo46wx5DSA4a/gWG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2014 at 10:13:10AM +0100, Hans de Goede wrote:
> Hi,
>=20
> On 11/21/2014 09:49 AM, Maxime Ripard wrote:
> > Hi,
> >=20
> > On Thu, Nov 20, 2014 at 04:55:22PM +0100, Hans de Goede wrote:
> >> Add a driver for mod0 clocks found in the prcm. Currently there is only
> >> one mod0 clocks in the prcm, the ir clock.
> >>
> >> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> >> ---
> >>  Documentation/devicetree/bindings/clock/sunxi.txt |  1 +
> >>  drivers/clk/sunxi/Makefile                        |  2 +-
> >>  drivers/clk/sunxi/clk-sun6i-prcm-mod0.c           | 63 ++++++++++++++=
+++++++++
> >>  drivers/mfd/sun6i-prcm.c                          | 14 +++++
> >>  4 files changed, 79 insertions(+), 1 deletion(-)
> >>  create mode 100644 drivers/clk/sunxi/clk-sun6i-prcm-mod0.c
> >>
> >> diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Docum=
entation/devicetree/bindings/clock/sunxi.txt
> >> index ed116df..342c75a 100644
> >> --- a/Documentation/devicetree/bindings/clock/sunxi.txt
> >> +++ b/Documentation/devicetree/bindings/clock/sunxi.txt
> >> @@ -56,6 +56,7 @@ Required properties:
> >>  	"allwinner,sun4i-a10-usb-clk" - for usb gates + resets on A10 / A20
> >>  	"allwinner,sun5i-a13-usb-clk" - for usb gates + resets on A13
> >>  	"allwinner,sun6i-a31-usb-clk" - for usb gates + resets on A31
> >> +	"allwinner,sun6i-a31-ir-clk" - for the ir clock on A31
> >> =20
> >>  Required properties for all clocks:
> >>  - reg : shall be the control register address for the clock.
> >> diff --git a/drivers/clk/sunxi/Makefile b/drivers/clk/sunxi/Makefile
> >> index 7ddc2b5..daf8b1c 100644
> >> --- a/drivers/clk/sunxi/Makefile
> >> +++ b/drivers/clk/sunxi/Makefile
> >> @@ -10,4 +10,4 @@ obj-y +=3D clk-sun8i-mbus.o
> >> =20
> >>  obj-$(CONFIG_MFD_SUN6I_PRCM) +=3D \
> >>  	clk-sun6i-ar100.o clk-sun6i-apb0.o clk-sun6i-apb0-gates.o \
> >> -	clk-sun8i-apb0.o
> >> +	clk-sun8i-apb0.o clk-sun6i-prcm-mod0.o
> >> diff --git a/drivers/clk/sunxi/clk-sun6i-prcm-mod0.c b/drivers/clk/sun=
xi/clk-sun6i-prcm-mod0.c
> >> new file mode 100644
> >> index 0000000..e80f18e
> >> --- /dev/null
> >> +++ b/drivers/clk/sunxi/clk-sun6i-prcm-mod0.c
> >> @@ -0,0 +1,63 @@
> >> +/*
> >> + * Allwinner A31 PRCM mod0 clock driver
> >> + *
> >> + * Copyright (C) 2014 Hans de Goede <hdegoede@redhat.com>
> >> + *
> >> + * This program is free software; you can redistribute it and/or modi=
fy
> >> + * it under the terms of the GNU General Public License as published =
by
> >> + * the Free Software Foundation; either version 2 of the License, or
> >> + * (at your option) any later version.
> >> + *
> >> + * This program is distributed in the hope that it will be useful,
> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> + * GNU General Public License for more details.
> >> + */
> >> +
> >> +#include <linux/clk-provider.h>
> >> +#include <linux/clkdev.h>
> >> +#include <linux/module.h>
> >> +#include <linux/of_address.h>
> >> +#include <linux/platform_device.h>
> >> +
> >> +#include "clk-factors.h"
> >> +#include "clk-mod0.h"
> >> +
> >> +static const struct of_device_id sun6i_a31_prcm_mod0_clk_dt_ids[] =3D=
 {
> >> +	{ .compatible =3D "allwinner,sun6i-a31-ir-clk" },
> >> +	{ /* sentinel */ }
> >> +};
> >> +
> >> +static DEFINE_SPINLOCK(sun6i_prcm_mod0_lock);
> >> +
> >> +static int sun6i_a31_prcm_mod0_clk_probe(struct platform_device *pdev)
> >> +{
> >> +	struct device_node *np =3D pdev->dev.of_node;
> >> +	struct resource *r;
> >> +	void __iomem *reg;
> >> +
> >> +	if (!np)
> >> +		return -ENODEV;
> >> +
> >> +	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >> +	reg =3D devm_ioremap_resource(&pdev->dev, r);
> >> +	if (IS_ERR(reg))
> >> +		return PTR_ERR(reg);
> >> +
> >> +	sunxi_factors_register(np, &sun4i_a10_mod0_data,
> >> +			       &sun6i_prcm_mod0_lock, reg);
> >> +	return 0;
> >> +}
> >> +
> >> +static struct platform_driver sun6i_a31_prcm_mod0_clk_driver =3D {
> >> +	.driver =3D {
> >> +		.name =3D "sun6i-a31-prcm-mod0-clk",
> >> +		.of_match_table =3D sun6i_a31_prcm_mod0_clk_dt_ids,
> >> +	},
> >> +	.probe =3D sun6i_a31_prcm_mod0_clk_probe,
> >> +};
> >> +module_platform_driver(sun6i_a31_prcm_mod0_clk_driver);
> >> +
> >> +MODULE_DESCRIPTION("Allwinner A31 PRCM mod0 clock driver");
> >> +MODULE_AUTHOR("Hans de Goede <hdegoede@redhat.com>");
> >> +MODULE_LICENSE("GPL");
> >=20
> > I don't think this is the right approach, mainly for two reasons: the
> > compatible shouldn't change, and you're basically duplicating code
> > there.
> >=20
> > I understand that you need the new compatible in order to avoid a
> > double probing: one by CLK_OF_DECLARE, and one by the usual mechanism,
> > and that also implies the second reason.
>=20
> Not only for that, we need a new compatible also because the mfd framework
> needs a separate compatible per sub-node as that is how it finds nodes
> to attach to the platform devices, so we need a new compatible anyways,
> with your make the mod0 clock driver a platform driver solution we could
> use:

We have a single mod0 clock in there, so no, not really.

Plus, that seems like a bogus limitation from MFD, and it really
shouldn't work that way.

> 	compatible =3D "allwinner,sun6i-a31-ir-clk", "allwinner,sun4i-a10-mod0-c=
lk";
>=20
> To work around this, but there are other problems, your make mod0clk a
> platform driver solution cannot work because the clocks node in the dtsi
> is not simple-bus compatible, so no platform-devs will be instantiated for
> the clocks there.

Then add the simple-bus compatible.

> Besides the compatible (which as said we need a separate one anyways),
> your other worry is code duplication, but I've avoided that as much
> as possible already, the new drivers/clk/sunxi/clk-sun6i-prcm-mod0.c is
> just a very thin wrapper, waying in with all of 63 lines including
> 16 lines GPL header.

47 lines that are doing exactly the same thing as the other code is
doing. I'm sorry but you can't really argue it's not code duplication,
it really is.

> So sorry, I disagree I believe that this is the best solution.
>=20
> > However, as those are not critical clocks that need to be here early
> > at boot, you can also fix this by turning the mod0 driver into a
> > platform driver itself. The compatible will be kept, the driver will
> > be the same.
> >=20
> > The only thing we need to pay attention to is how "client" drivers
> > react when they cannot grab their clock. They should return
> > -EPROBE_DEFER, but that remains to be checked.
>=20
> -EPROBE_DEFER is yet another reason to not make mod0-clk a platform
> driver. Yes drivers should be able to handle this, but it is a pain,
> and the more we use it the more pain it is. Also it makes booting a lot
> slower as any driver using a mod0 clk now, will not complete its probe
> until all the other drivers are done probing and the late_initcall
> which starts the deferred-probe wq runs.

The whole EPROBE_DEFER mechanism might need some fixing, but it's not
really the point is it?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--jo46wx5DSA4a/gWG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUc6suAAoJEBx+YmzsjxAgZXQP/ixn5vw+qyUNdyLXJV7+y9ip
KNyT2Oai0fb+dKW4zeO3q1WxVw+aCgIDrgyfGCIDrY3kSkbj93zr2SvW0p1y8uEO
La4Ki901CP2qCloLN0Lv90+I0EojAxL31cdarf34YGYiePo3mee9d2/A9scZMufL
zYirJeizHEUb2we46bhvGua1UZb5kR+CIPhWTUD48IbLpXJl8M02OIeJADTVlmvd
hRgwWa2cb6F5SHIXMh6PLcwmmTgc/80g7uNbZjAiwkJxU73+m+NF+W/bUzTIgu/I
Q/6l3Vu1JJ5JlX62OOWJlvEsgrD3OO2NnBEByW8hiP4/YU3NvXJDOMQugKS9SWkc
AWKO7fBYrqhTf2h1YBp6ZM3BN/A9vJkq4JOCNTHKb0fZyn8JpzTrc2gHEfSJnLIf
YQw0U/JBRlp/v/kkZqX7dW2rUXK1KHSE2Zsw9/iOoUDjORL3DVN/lOiQKAEAKJKA
BRhI8+rpR/vTRxdhfpKYmsWZjcP+dbJCpPaHBLCREZyoWgBGcD7dkWH2eNlfHVoN
zqiPK2etP+A7gn92FOd/4jVVGH/y8Vm832uKsL65NGyfdqupwRr5eJ1FZ6f16ypI
iP/lZw0Ow8kOyqQgXSZW7nA8K7aqH8oRLvpReAD9kwriEN2ifVQJJzZDAM9ucH0r
1CJ22+8k6Kf+jXPBT8W8
=qkld
-----END PGP SIGNATURE-----

--jo46wx5DSA4a/gWG--
