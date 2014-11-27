Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:34815 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750784AbaK0S4F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 13:56:05 -0500
Date: Thu, 27 Nov 2014 19:51:19 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Boris Brezillon <boris@free-electrons.com>,
	Mike Turquette <mturquette@linaro.org>,
	Chen-Yu Tsai <wens@csie.org>,
	Emilio Lopez <emilio@elopez.com.ar>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH 3/9] clk: sunxi: Add prcm mod0 clock driver
Message-ID: <20141127185119.GQ25249@lukather>
References: <20141126211318.GN25249@lukather>
 <5476E3A5.4000708@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V2tfspbppmK1TQo2"
Content-Disposition: inline
In-Reply-To: <5476E3A5.4000708@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--V2tfspbppmK1TQo2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 27, 2014 at 09:41:09AM +0100, Hans de Goede wrote:
> Hi,
>=20
> On 11/26/2014 10:13 PM, Maxime Ripard wrote:
> >Hi,
> >
> >On Tue, Nov 25, 2014 at 09:29:21AM +0100, Hans de Goede wrote:
> >>Hi,
> >>
> >>On 11/24/2014 11:03 PM, Maxime Ripard wrote:
> >>>On Fri, Nov 21, 2014 at 10:13:10AM +0100, Hans de Goede wrote:
> >>>>Hi,
> >>>>
> >>>>On 11/21/2014 09:49 AM, Maxime Ripard wrote:
> >>>>>Hi,
> >>>>>
> >>>>>On Thu, Nov 20, 2014 at 04:55:22PM +0100, Hans de Goede wrote:
> >>>>>>Add a driver for mod0 clocks found in the prcm. Currently there is =
only
> >>>>>>one mod0 clocks in the prcm, the ir clock.
> >>>>>>
> >>>>>>Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> >>>>>>---
> >>>>>>  Documentation/devicetree/bindings/clock/sunxi.txt |  1 +
> >>>>>>  drivers/clk/sunxi/Makefile                        |  2 +-
> >>>>>>  drivers/clk/sunxi/clk-sun6i-prcm-mod0.c           | 63 ++++++++++=
+++++++++++++
> >>>>>>  drivers/mfd/sun6i-prcm.c                          | 14 +++++
> >>>>>>  4 files changed, 79 insertions(+), 1 deletion(-)
> >>>>>>  create mode 100644 drivers/clk/sunxi/clk-sun6i-prcm-mod0.c
> >>>>>>
> >>>>>>diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Do=
cumentation/devicetree/bindings/clock/sunxi.txt
> >>>>>>index ed116df..342c75a 100644
> >>>>>>--- a/Documentation/devicetree/bindings/clock/sunxi.txt
> >>>>>>+++ b/Documentation/devicetree/bindings/clock/sunxi.txt
> >>>>>>@@ -56,6 +56,7 @@ Required properties:
> >>>>>>  	"allwinner,sun4i-a10-usb-clk" - for usb gates + resets on A10 / =
A20
> >>>>>>  	"allwinner,sun5i-a13-usb-clk" - for usb gates + resets on A13
> >>>>>>  	"allwinner,sun6i-a31-usb-clk" - for usb gates + resets on A31
> >>>>>>+	"allwinner,sun6i-a31-ir-clk" - for the ir clock on A31
> >>>>>>
> >>>>>>  Required properties for all clocks:
> >>>>>>  - reg : shall be the control register address for the clock.
> >>>>>>diff --git a/drivers/clk/sunxi/Makefile b/drivers/clk/sunxi/Makefile
> >>>>>>index 7ddc2b5..daf8b1c 100644
> >>>>>>--- a/drivers/clk/sunxi/Makefile
> >>>>>>+++ b/drivers/clk/sunxi/Makefile
> >>>>>>@@ -10,4 +10,4 @@ obj-y +=3D clk-sun8i-mbus.o
> >>>>>>
> >>>>>>  obj-$(CONFIG_MFD_SUN6I_PRCM) +=3D \
> >>>>>>  	clk-sun6i-ar100.o clk-sun6i-apb0.o clk-sun6i-apb0-gates.o \
> >>>>>>-	clk-sun8i-apb0.o
> >>>>>>+	clk-sun8i-apb0.o clk-sun6i-prcm-mod0.o
> >>>>>>diff --git a/drivers/clk/sunxi/clk-sun6i-prcm-mod0.c b/drivers/clk/=
sunxi/clk-sun6i-prcm-mod0.c
> >>>>>>new file mode 100644
> >>>>>>index 0000000..e80f18e
> >>>>>>--- /dev/null
> >>>>>>+++ b/drivers/clk/sunxi/clk-sun6i-prcm-mod0.c
> >>>>>>@@ -0,0 +1,63 @@
> >>>>>>+/*
> >>>>>>+ * Allwinner A31 PRCM mod0 clock driver
> >>>>>>+ *
> >>>>>>+ * Copyright (C) 2014 Hans de Goede <hdegoede@redhat.com>
> >>>>>>+ *
> >>>>>>+ * This program is free software; you can redistribute it and/or m=
odify
> >>>>>>+ * it under the terms of the GNU General Public License as publish=
ed by
> >>>>>>+ * the Free Software Foundation; either version 2 of the License, =
or
> >>>>>>+ * (at your option) any later version.
> >>>>>>+ *
> >>>>>>+ * This program is distributed in the hope that it will be useful,
> >>>>>>+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >>>>>>+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>>>>>+ * GNU General Public License for more details.
> >>>>>>+ */
> >>>>>>+
> >>>>>>+#include <linux/clk-provider.h>
> >>>>>>+#include <linux/clkdev.h>
> >>>>>>+#include <linux/module.h>
> >>>>>>+#include <linux/of_address.h>
> >>>>>>+#include <linux/platform_device.h>
> >>>>>>+
> >>>>>>+#include "clk-factors.h"
> >>>>>>+#include "clk-mod0.h"
> >>>>>>+
> >>>>>>+static const struct of_device_id sun6i_a31_prcm_mod0_clk_dt_ids[] =
=3D {
> >>>>>>+	{ .compatible =3D "allwinner,sun6i-a31-ir-clk" },
> >>>>>>+	{ /* sentinel */ }
> >>>>>>+};
> >>>>>>+
> >>>>>>+static DEFINE_SPINLOCK(sun6i_prcm_mod0_lock);
> >>>>>>+
> >>>>>>+static int sun6i_a31_prcm_mod0_clk_probe(struct platform_device *p=
dev)
> >>>>>>+{
> >>>>>>+	struct device_node *np =3D pdev->dev.of_node;
> >>>>>>+	struct resource *r;
> >>>>>>+	void __iomem *reg;
> >>>>>>+
> >>>>>>+	if (!np)
> >>>>>>+		return -ENODEV;
> >>>>>>+
> >>>>>>+	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >>>>>>+	reg =3D devm_ioremap_resource(&pdev->dev, r);
> >>>>>>+	if (IS_ERR(reg))
> >>>>>>+		return PTR_ERR(reg);
> >>>>>>+
> >>>>>>+	sunxi_factors_register(np, &sun4i_a10_mod0_data,
> >>>>>>+			       &sun6i_prcm_mod0_lock, reg);
> >>>>>>+	return 0;
> >>>>>>+}
> >>>>>>+
> >>>>>>+static struct platform_driver sun6i_a31_prcm_mod0_clk_driver =3D {
> >>>>>>+	.driver =3D {
> >>>>>>+		.name =3D "sun6i-a31-prcm-mod0-clk",
> >>>>>>+		.of_match_table =3D sun6i_a31_prcm_mod0_clk_dt_ids,
> >>>>>>+	},
> >>>>>>+	.probe =3D sun6i_a31_prcm_mod0_clk_probe,
> >>>>>>+};
> >>>>>>+module_platform_driver(sun6i_a31_prcm_mod0_clk_driver);
> >>>>>>+
> >>>>>>+MODULE_DESCRIPTION("Allwinner A31 PRCM mod0 clock driver");
> >>>>>>+MODULE_AUTHOR("Hans de Goede <hdegoede@redhat.com>");
> >>>>>>+MODULE_LICENSE("GPL");
> >>>>>
> >>>>>I don't think this is the right approach, mainly for two reasons: the
> >>>>>compatible shouldn't change, and you're basically duplicating code
> >>>>>there.
> >>>>>
> >>>>>I understand that you need the new compatible in order to avoid a
> >>>>>double probing: one by CLK_OF_DECLARE, and one by the usual mechanis=
m,
> >>>>>and that also implies the second reason.
> >>>>
> >>>>Not only for that, we need a new compatible also because the mfd fram=
ework
> >>>>needs a separate compatible per sub-node as that is how it finds nodes
> >>>>to attach to the platform devices, so we need a new compatible anyway=
s,
> >>>>with your make the mod0 clock driver a platform driver solution we co=
uld
> >>>>use:
> >>>
> >>>We have a single mod0 clock in there, so no, not really.
> >>
> >>We have a single mod0 clock there today, but who knows what tomorrow br=
ings,
> >>arguably the 1wire clock is a mod0 clock too, so we already have 2 toda=
y.
> >
> >I remember someone (Chen-Yu? Boris?) saying that the 1wire clock was
> >not really a mod0 clk. From what I could gather from the source code,
> >it seems to have a wider m divider, so we could argue that it should
> >need a new compatible.
> >
> >>>Plus, that seems like a bogus limitation from MFD, and it really
> >>>shouldn't work that way.
> >>
> >>Well AFAIK that is how it works.
> >
> >That kind of argument doesn't work. You could make exactly the same
> >statement about the fact that two identical hardware blocks in the DT
> >should have the same compatible, and it's how it works.
> >
> >With the minor exception that we can't change that fact for the DT,
> >while we can change the MTD code.
>=20
> As I already said, we could do something like this to make clear this
> is a mod0 clock:
>=20
> >>>>	compatible =3D "allwinner,sun6i-a31-ir-clk", "allwinner,sun4i-a10-mo=
d0-clk";
>=20
> The problem with that is it will cause early binding because of
> CLK_OF_DECLARE and early binding does not work on MFD instantiated device=
s,
> because they have no reg property.

That won't cause any early binding if you drop the CLK_OF_DECLARE and
have only a regular platform driver,  which was what I've been
suggesting all along.

> >>>>
> >>>>To work around this, but there are other problems, your make mod0clk a
> >>>>platform driver solution cannot work because the clocks node in the d=
tsi
> >>>>is not simple-bus compatible, so no platform-devs will be instantiate=
d for
> >>>>the clocks there.
> >>>
> >>>Then add the simple-bus compatible.
> >>
> >>No, just no, that goes against the whole design of how of-clocks work.
> >
> >Which is... ?
>=20
> That they are child nodes of a clocks node, which is NOT simple-bus compa=
tible
> and get instantiated early using CLK_OF_DECLARE.

Depending on who you ask to, this might or might not be true. Mark
Rutland for example has been a strong opponent to that clock node. So
your it's-by-design argument is just flawed.

CLK_OF_DECLARE has been designed to be able to parse the DT early to
instantiate the early clocks. It doesn't do anything beyond that. The
clocks node has nothing to do with that whole discussion.

> >There's a number of other clocks being platform drivers, including on
> >other platforms, and as far as I know, CLK_OF_DECLARE is only really
> >useful on clocks that are critical. Mike, what's your view on this?
> >
> >>>>Besides the compatible (which as said we need a separate one anyways),
> >>>>your other worry is code duplication, but I've avoided that as much
> >>>>as possible already, the new drivers/clk/sunxi/clk-sun6i-prcm-mod0.c =
is
> >>>>just a very thin wrapper, waying in with all of 63 lines including
> >>>>16 lines GPL header.
> >>>
> >>>47 lines that are doing exactly the same thing as the other code is
> >>>doing. I'm sorry but you can't really argue it's not code duplication,
> >>>it really is.
> >>
> >>It is not doing the exact same thing, it is a platform driver, where as
> >>the other code is an of_clk driver.
> >>
> >>>>So sorry, I disagree I believe that this is the best solution.
> >>>>
> >>>>>However, as those are not critical clocks that need to be here early
> >>>>>at boot, you can also fix this by turning the mod0 driver into a
> >>>>>platform driver itself. The compatible will be kept, the driver will
> >>>>>be the same.
> >>>>>
> >>>>>The only thing we need to pay attention to is how "client" drivers
> >>>>>react when they cannot grab their clock. They should return
> >>>>>-EPROBE_DEFER, but that remains to be checked.
> >>>>
> >>>>-EPROBE_DEFER is yet another reason to not make mod0-clk a platform
> >>>>driver. Yes drivers should be able to handle this, but it is a pain,
> >>>>and the more we use it the more pain it is. Also it makes booting a l=
ot
> >>>>slower as any driver using a mod0 clk now, will not complete its probe
> >>>>until all the other drivers are done probing and the late_initcall
> >>>>which starts the deferred-probe wq runs.
> >>>
> >>>The whole EPROBE_DEFER mechanism might need some fixing, but it's not
> >>>really the point is it?
> >>
> >>Well one reasons why clocks are instantiated the way they are is to have
> >>them available as early as possible, which is really convenient and wor=
ks
> >>really well.
> >
> >Yeah, you need them early for critical and early stuff like timers,
> >console, etc. You really don't need this mechanism if you don't have
> >to handle early probed devices.
>=20
> And we do need some clocks for that, if we add the simple bus compatible =
then
> *all* of them become platform devices.
>=20
> Or are you suggesting to still bind all the other clocks using CLK_OF_DEC=
LARE
> and only turn mod0 into a platform driver, that would be rather inconsist=
ent.

Not really. Some others clocks that can be probed by MFD are already
platform drivers.

> >>You are asking for a whole lot of stuff to be changed, arguably in a way
> >>which makes it worse, just to save 47 lines of code...
> >
> >No, really, I'm not. All I ask for is adding 1 line in the DT, and
> >removing 5 lines in clk-sunxi.c. That's all.
>=20
> And adding platform driver glue for the mod0 clks, which would pretty much
> introduce the same 47 lines in a different place.

What? It's exactly what your patch is doing. How is that more work?

> I notice that you've not responded to my proposal to simple make the clock
> node a child node of the clocks node in the dt, that should work nicely, =
and
> avoid the need for any kernel level changes to support it, I'm beginning =
to
> think that that is probably the best solution.

And then you're talking about inconsistencies.... Having some of these
clocks and devices exposed through MFD and some others through clocks
is very consistent indeed.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--V2tfspbppmK1TQo2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUd3KnAAoJEBx+YmzsjxAg6E4QAMFfF0nurOzJbUJGOIIEKuDz
SW2DcLucYD0Ydjvwub6yVrMaZy1Eo9xUJ0BJByLgDsROaKUv8eO4eOSNvHPA8wRl
XEcj7iGzkF8azS2L5gzdk77GQhjmBvWqJVXaOnnC/z/xK2hkL+x7DZB0aYAEDjDM
VPtxDSIgQwfQ7V+SPYLha/bwvi7159rfnRW2U2LSKQMSN3EXfjRGbg+6xlJJEL97
ncCbeCbMmOPI06+G7ikuWyGAX6wCEjI3J4miqlct5PLK/lpV05tnnPeRNDfaRimq
wDEZjRoqCDBgDJXGYw/VPbOdc5md72ZnkMCXSck7I83J7336pUAKxQocl7haXSBr
ryPV8z5HO9XYGhKeF7GtrVK7ui8DnO6z0VIH/bqz7Lv86lpvZOHwTS5KOeQMXgsr
qyZfIx1bSeDaNmaPN5RX2yDcRGDmNFjGwxcELh2ExTM2TDZrKoUQNK0TlBacAaIf
rhygNkja/dkm8bkvmAIu5c5kGYazaNlrwB+Zgs7bWtVmfqD5WurWCWOecDmZ0wRI
D8CfEd0/+4dqcHnINuRIjJlytYYpeKEdJBndEFnNarAbdyK7fJcxmo9WJmwLheyp
WyGNSGG67Bj8K4iExy9iP6iPXJlbCdqbxQroW7l3spHw6C0zKmsvt+vTBerm15fO
wl/g+IpXM9C0EZ//FjEN
=sWQN
-----END PGP SIGNATURE-----

--V2tfspbppmK1TQo2--
