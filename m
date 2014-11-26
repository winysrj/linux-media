Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:55304 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752807AbaKZVPE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 16:15:04 -0500
Date: Wed, 26 Nov 2014 22:13:18 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>,
	Boris Brezillon <boris@free-electrons.com>,
	Mike Turquette <mturquette@linaro.org>,
	Chen-Yu Tsai <wens@csie.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH 3/9] clk: sunxi: Add prcm mod0 clock driver
Message-ID: <20141126211318.GN25249@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ztcJpsdPpsnnlAp8"
Content-Disposition: inline
In-Reply-To: <54743DE1.7020704@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ztcJpsdPpsnnlAp8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 25, 2014 at 09:29:21AM +0100, Hans de Goede wrote:
> Hi,
>=20
> On 11/24/2014 11:03 PM, Maxime Ripard wrote:
> >On Fri, Nov 21, 2014 at 10:13:10AM +0100, Hans de Goede wrote:
> >>Hi,
> >>
> >>On 11/21/2014 09:49 AM, Maxime Ripard wrote:
> >>>Hi,
> >>>
> >>>On Thu, Nov 20, 2014 at 04:55:22PM +0100, Hans de Goede wrote:
> >>>>Add a driver for mod0 clocks found in the prcm. Currently there is on=
ly
> >>>>one mod0 clocks in the prcm, the ir clock.
> >>>>
> >>>>Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> >>>>---
> >>>>  Documentation/devicetree/bindings/clock/sunxi.txt |  1 +
> >>>>  drivers/clk/sunxi/Makefile                        |  2 +-
> >>>>  drivers/clk/sunxi/clk-sun6i-prcm-mod0.c           | 63 ++++++++++++=
+++++++++++
> >>>>  drivers/mfd/sun6i-prcm.c                          | 14 +++++
> >>>>  4 files changed, 79 insertions(+), 1 deletion(-)
> >>>>  create mode 100644 drivers/clk/sunxi/clk-sun6i-prcm-mod0.c
> >>>>
> >>>>diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Docu=
mentation/devicetree/bindings/clock/sunxi.txt
> >>>>index ed116df..342c75a 100644
> >>>>--- a/Documentation/devicetree/bindings/clock/sunxi.txt
> >>>>+++ b/Documentation/devicetree/bindings/clock/sunxi.txt
> >>>>@@ -56,6 +56,7 @@ Required properties:
> >>>>  	"allwinner,sun4i-a10-usb-clk" - for usb gates + resets on A10 / A20
> >>>>  	"allwinner,sun5i-a13-usb-clk" - for usb gates + resets on A13
> >>>>  	"allwinner,sun6i-a31-usb-clk" - for usb gates + resets on A31
> >>>>+	"allwinner,sun6i-a31-ir-clk" - for the ir clock on A31
> >>>>
> >>>>  Required properties for all clocks:
> >>>>  - reg : shall be the control register address for the clock.
> >>>>diff --git a/drivers/clk/sunxi/Makefile b/drivers/clk/sunxi/Makefile
> >>>>index 7ddc2b5..daf8b1c 100644
> >>>>--- a/drivers/clk/sunxi/Makefile
> >>>>+++ b/drivers/clk/sunxi/Makefile
> >>>>@@ -10,4 +10,4 @@ obj-y +=3D clk-sun8i-mbus.o
> >>>>
> >>>>  obj-$(CONFIG_MFD_SUN6I_PRCM) +=3D \
> >>>>  	clk-sun6i-ar100.o clk-sun6i-apb0.o clk-sun6i-apb0-gates.o \
> >>>>-	clk-sun8i-apb0.o
> >>>>+	clk-sun8i-apb0.o clk-sun6i-prcm-mod0.o
> >>>>diff --git a/drivers/clk/sunxi/clk-sun6i-prcm-mod0.c b/drivers/clk/su=
nxi/clk-sun6i-prcm-mod0.c
> >>>>new file mode 100644
> >>>>index 0000000..e80f18e
> >>>>--- /dev/null
> >>>>+++ b/drivers/clk/sunxi/clk-sun6i-prcm-mod0.c
> >>>>@@ -0,0 +1,63 @@
> >>>>+/*
> >>>>+ * Allwinner A31 PRCM mod0 clock driver
> >>>>+ *
> >>>>+ * Copyright (C) 2014 Hans de Goede <hdegoede@redhat.com>
> >>>>+ *
> >>>>+ * This program is free software; you can redistribute it and/or mod=
ify
> >>>>+ * it under the terms of the GNU General Public License as published=
 by
> >>>>+ * the Free Software Foundation; either version 2 of the License, or
> >>>>+ * (at your option) any later version.
> >>>>+ *
> >>>>+ * This program is distributed in the hope that it will be useful,
> >>>>+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >>>>+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>>>+ * GNU General Public License for more details.
> >>>>+ */
> >>>>+
> >>>>+#include <linux/clk-provider.h>
> >>>>+#include <linux/clkdev.h>
> >>>>+#include <linux/module.h>
> >>>>+#include <linux/of_address.h>
> >>>>+#include <linux/platform_device.h>
> >>>>+
> >>>>+#include "clk-factors.h"
> >>>>+#include "clk-mod0.h"
> >>>>+
> >>>>+static const struct of_device_id sun6i_a31_prcm_mod0_clk_dt_ids[] =
=3D {
> >>>>+	{ .compatible =3D "allwinner,sun6i-a31-ir-clk" },
> >>>>+	{ /* sentinel */ }
> >>>>+};
> >>>>+
> >>>>+static DEFINE_SPINLOCK(sun6i_prcm_mod0_lock);
> >>>>+
> >>>>+static int sun6i_a31_prcm_mod0_clk_probe(struct platform_device *pde=
v)
> >>>>+{
> >>>>+	struct device_node *np =3D pdev->dev.of_node;
> >>>>+	struct resource *r;
> >>>>+	void __iomem *reg;
> >>>>+
> >>>>+	if (!np)
> >>>>+		return -ENODEV;
> >>>>+
> >>>>+	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >>>>+	reg =3D devm_ioremap_resource(&pdev->dev, r);
> >>>>+	if (IS_ERR(reg))
> >>>>+		return PTR_ERR(reg);
> >>>>+
> >>>>+	sunxi_factors_register(np, &sun4i_a10_mod0_data,
> >>>>+			       &sun6i_prcm_mod0_lock, reg);
> >>>>+	return 0;
> >>>>+}
> >>>>+
> >>>>+static struct platform_driver sun6i_a31_prcm_mod0_clk_driver =3D {
> >>>>+	.driver =3D {
> >>>>+		.name =3D "sun6i-a31-prcm-mod0-clk",
> >>>>+		.of_match_table =3D sun6i_a31_prcm_mod0_clk_dt_ids,
> >>>>+	},
> >>>>+	.probe =3D sun6i_a31_prcm_mod0_clk_probe,
> >>>>+};
> >>>>+module_platform_driver(sun6i_a31_prcm_mod0_clk_driver);
> >>>>+
> >>>>+MODULE_DESCRIPTION("Allwinner A31 PRCM mod0 clock driver");
> >>>>+MODULE_AUTHOR("Hans de Goede <hdegoede@redhat.com>");
> >>>>+MODULE_LICENSE("GPL");
> >>>
> >>>I don't think this is the right approach, mainly for two reasons: the
> >>>compatible shouldn't change, and you're basically duplicating code
> >>>there.
> >>>
> >>>I understand that you need the new compatible in order to avoid a
> >>>double probing: one by CLK_OF_DECLARE, and one by the usual mechanism,
> >>>and that also implies the second reason.
> >>
> >>Not only for that, we need a new compatible also because the mfd framew=
ork
> >>needs a separate compatible per sub-node as that is how it finds nodes
> >>to attach to the platform devices, so we need a new compatible anyways,
> >>with your make the mod0 clock driver a platform driver solution we could
> >>use:
> >
> >We have a single mod0 clock in there, so no, not really.
>=20
> We have a single mod0 clock there today, but who knows what tomorrow brin=
gs,
> arguably the 1wire clock is a mod0 clock too, so we already have 2 today.

I remember someone (Chen-Yu? Boris?) saying that the 1wire clock was
not really a mod0 clk. From what I could gather from the source code,
it seems to have a wider m divider, so we could argue that it should
need a new compatible.

> >Plus, that seems like a bogus limitation from MFD, and it really
> >shouldn't work that way.
>=20
> Well AFAIK that is how it works.

That kind of argument doesn't work. You could make exactly the same
statement about the fact that two identical hardware blocks in the DT
should have the same compatible, and it's how it works.

With the minor exception that we can't change that fact for the DT,
while we can change the MTD code.

> >>	compatible =3D "allwinner,sun6i-a31-ir-clk", "allwinner,sun4i-a10-mod0=
-clk";
> >>
> >>To work around this, but there are other problems, your make mod0clk a
> >>platform driver solution cannot work because the clocks node in the dtsi
> >>is not simple-bus compatible, so no platform-devs will be instantiated =
for
> >>the clocks there.
> >
> >Then add the simple-bus compatible.
>=20
> No, just no, that goes against the whole design of how of-clocks work.

Which is... ?

There's a number of other clocks being platform drivers, including on
other platforms, and as far as I know, CLK_OF_DECLARE is only really
useful on clocks that are critical. Mike, what's your view on this?

> >>Besides the compatible (which as said we need a separate one anyways),
> >>your other worry is code duplication, but I've avoided that as much
> >>as possible already, the new drivers/clk/sunxi/clk-sun6i-prcm-mod0.c is
> >>just a very thin wrapper, waying in with all of 63 lines including
> >>16 lines GPL header.
> >
> >47 lines that are doing exactly the same thing as the other code is
> >doing. I'm sorry but you can't really argue it's not code duplication,
> >it really is.
>=20
> It is not doing the exact same thing, it is a platform driver, where as
> the other code is an of_clk driver.
>=20
> >>So sorry, I disagree I believe that this is the best solution.
> >>
> >>>However, as those are not critical clocks that need to be here early
> >>>at boot, you can also fix this by turning the mod0 driver into a
> >>>platform driver itself. The compatible will be kept, the driver will
> >>>be the same.
> >>>
> >>>The only thing we need to pay attention to is how "client" drivers
> >>>react when they cannot grab their clock. They should return
> >>>-EPROBE_DEFER, but that remains to be checked.
> >>
> >>-EPROBE_DEFER is yet another reason to not make mod0-clk a platform
> >>driver. Yes drivers should be able to handle this, but it is a pain,
> >>and the more we use it the more pain it is. Also it makes booting a lot
> >>slower as any driver using a mod0 clk now, will not complete its probe
> >>until all the other drivers are done probing and the late_initcall
> >>which starts the deferred-probe wq runs.
> >
> >The whole EPROBE_DEFER mechanism might need some fixing, but it's not
> >really the point is it?
>=20
> Well one reasons why clocks are instantiated the way they are is to have
> them available as early as possible, which is really convenient and works
> really well.

Yeah, you need them early for critical and early stuff like timers,
console, etc. You really don't need this mechanism if you don't have
to handle early probed devices.

> You are asking for a whole lot of stuff to be changed, arguably in a way
> which makes it worse, just to save 47 lines of code...

No, really, I'm not. All I ask for is adding 1 line in the DT, and
removing 5 lines in clk-sunxi.c. That's all.

You're the one being unhappy with EPROBE_DEFER, not me.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--ztcJpsdPpsnnlAp8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUdkJuAAoJEBx+YmzsjxAgLtQQAJqwzGImTnQ6mSEYO85T3oMz
bEj/8xgpcpLMREdfYXh8M4StwcUueZ7LUjf0APQMSLm6cev78S8iI19bF8it/JVB
XYwj+1Heybd6+TOF1bhZPBvJSL0doZopNKe5HYio5cujaxbiHyC4RZN9RKSey61+
qmhyMYM0Qd5xHz4tzA+7ZEdZoIl5pFJ9/HUTNiSgFiE8gAmtcqLsDBYodesZ601i
1g8c3MIVx7XHCxr4degzueRLFUp63DiN479C+h5BQtRkZ8PV/eTvi/jn2v95yB7v
NtwmRjSdu+kW0yP3oqzJ/uWdHSzK2mbv/L5PuiNJa5jx9qeTBsMDzoym1pPONOgt
URws4i+JWpOR22rP1zuwlEn5CboYkYzdgGRHuwIxL1fciVM6O1MlkbRv9OUjyspS
dBFVRV8DbFZ7GEiFOGkcM5dD6ESVGzo2Jf7GieAGYTacznTI+ieXC5MaA7I8eFd/
Ub8h7tG7bXLIgS4XLfEvXjQMiWe5ZFM3O1ezTWKFNGMSSEOfkv8qc3/c9EKLCszk
+x1zk1lEXCOfgIE7rjbUI/fHvA8NLfTgGmRsXjQkhJE97QW6veEufGm2CIxM6p+y
4AfDwFhPCb9FDoh/4ChH7n+Y4vHglFvnloXW/RW4BQOOYEkCwe9zf1F+h8uM7OH1
/KrDdPMMuXVJHe+l9SEw
=tSG3
-----END PGP SIGNATURE-----

--ztcJpsdPpsnnlAp8--
