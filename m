Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:52914 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752836AbaKUIuE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Nov 2014 03:50:04 -0500
Date: Fri, 21 Nov 2014 09:49:33 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH 3/9] clk: sunxi: Add prcm mod0 clock driver
Message-ID: <20141121084933.GL24143@lukather>
References: <1416498928-1300-1-git-send-email-hdegoede@redhat.com>
 <1416498928-1300-4-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WkHPBKJ2pKcVUM5H"
Content-Disposition: inline
In-Reply-To: <1416498928-1300-4-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--WkHPBKJ2pKcVUM5H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Nov 20, 2014 at 04:55:22PM +0100, Hans de Goede wrote:
> Add a driver for mod0 clocks found in the prcm. Currently there is only
> one mod0 clocks in the prcm, the ir clock.
>=20
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  Documentation/devicetree/bindings/clock/sunxi.txt |  1 +
>  drivers/clk/sunxi/Makefile                        |  2 +-
>  drivers/clk/sunxi/clk-sun6i-prcm-mod0.c           | 63 +++++++++++++++++=
++++++
>  drivers/mfd/sun6i-prcm.c                          | 14 +++++
>  4 files changed, 79 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/clk/sunxi/clk-sun6i-prcm-mod0.c
>=20
> diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Document=
ation/devicetree/bindings/clock/sunxi.txt
> index ed116df..342c75a 100644
> --- a/Documentation/devicetree/bindings/clock/sunxi.txt
> +++ b/Documentation/devicetree/bindings/clock/sunxi.txt
> @@ -56,6 +56,7 @@ Required properties:
>  	"allwinner,sun4i-a10-usb-clk" - for usb gates + resets on A10 / A20
>  	"allwinner,sun5i-a13-usb-clk" - for usb gates + resets on A13
>  	"allwinner,sun6i-a31-usb-clk" - for usb gates + resets on A31
> +	"allwinner,sun6i-a31-ir-clk" - for the ir clock on A31
> =20
>  Required properties for all clocks:
>  - reg : shall be the control register address for the clock.
> diff --git a/drivers/clk/sunxi/Makefile b/drivers/clk/sunxi/Makefile
> index 7ddc2b5..daf8b1c 100644
> --- a/drivers/clk/sunxi/Makefile
> +++ b/drivers/clk/sunxi/Makefile
> @@ -10,4 +10,4 @@ obj-y +=3D clk-sun8i-mbus.o
> =20
>  obj-$(CONFIG_MFD_SUN6I_PRCM) +=3D \
>  	clk-sun6i-ar100.o clk-sun6i-apb0.o clk-sun6i-apb0-gates.o \
> -	clk-sun8i-apb0.o
> +	clk-sun8i-apb0.o clk-sun6i-prcm-mod0.o
> diff --git a/drivers/clk/sunxi/clk-sun6i-prcm-mod0.c b/drivers/clk/sunxi/=
clk-sun6i-prcm-mod0.c
> new file mode 100644
> index 0000000..e80f18e
> --- /dev/null
> +++ b/drivers/clk/sunxi/clk-sun6i-prcm-mod0.c
> @@ -0,0 +1,63 @@
> +/*
> + * Allwinner A31 PRCM mod0 clock driver
> + *
> + * Copyright (C) 2014 Hans de Goede <hdegoede@redhat.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clk-provider.h>
> +#include <linux/clkdev.h>
> +#include <linux/module.h>
> +#include <linux/of_address.h>
> +#include <linux/platform_device.h>
> +
> +#include "clk-factors.h"
> +#include "clk-mod0.h"
> +
> +static const struct of_device_id sun6i_a31_prcm_mod0_clk_dt_ids[] =3D {
> +	{ .compatible =3D "allwinner,sun6i-a31-ir-clk" },
> +	{ /* sentinel */ }
> +};
> +
> +static DEFINE_SPINLOCK(sun6i_prcm_mod0_lock);
> +
> +static int sun6i_a31_prcm_mod0_clk_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np =3D pdev->dev.of_node;
> +	struct resource *r;
> +	void __iomem *reg;
> +
> +	if (!np)
> +		return -ENODEV;
> +
> +	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	reg =3D devm_ioremap_resource(&pdev->dev, r);
> +	if (IS_ERR(reg))
> +		return PTR_ERR(reg);
> +
> +	sunxi_factors_register(np, &sun4i_a10_mod0_data,
> +			       &sun6i_prcm_mod0_lock, reg);
> +	return 0;
> +}
> +
> +static struct platform_driver sun6i_a31_prcm_mod0_clk_driver =3D {
> +	.driver =3D {
> +		.name =3D "sun6i-a31-prcm-mod0-clk",
> +		.of_match_table =3D sun6i_a31_prcm_mod0_clk_dt_ids,
> +	},
> +	.probe =3D sun6i_a31_prcm_mod0_clk_probe,
> +};
> +module_platform_driver(sun6i_a31_prcm_mod0_clk_driver);
> +
> +MODULE_DESCRIPTION("Allwinner A31 PRCM mod0 clock driver");
> +MODULE_AUTHOR("Hans de Goede <hdegoede@redhat.com>");
> +MODULE_LICENSE("GPL");

I don't think this is the right approach, mainly for two reasons: the
compatible shouldn't change, and you're basically duplicating code
there.

I understand that you need the new compatible in order to avoid a
double probing: one by CLK_OF_DECLARE, and one by the usual mechanism,
and that also implies the second reason.

However, as those are not critical clocks that need to be here early
at boot, you can also fix this by turning the mod0 driver into a
platform driver itself. The compatible will be kept, the driver will
be the same.

The only thing we need to pay attention to is how "client" drivers
react when they cannot grab their clock. They should return
-EPROBE_DEFER, but that remains to be checked.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--WkHPBKJ2pKcVUM5H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUbvydAAoJEBx+YmzsjxAguE8P/1Q8eFC4Hr76eSWw2bzgTqoX
yOuZoW3Mlqwt3BCRKtxCq3o3c68KYyoLM1tDWeli+ACTpdUTxczbfvl0YCDFaiRF
pFgQR8nnsw4wLWM4mwJqib2QFa6UeSq/CEwRNdpCKiS7YzWOJZJ/qNlzKEEjcMNN
Ushw+uCeDtcSBV9V8BM1Y9ATbx9CT/ZFdek3TYTW89mMmxDov004rBZ+LIxFbzKH
u2MVaR7GfsK8tA+O/6OvPGtmd3H3DYJeKZ+U8kYhwB6HbhIoyUA3czxkd8epInUV
EwvMYdS+sikWaLO/GA95+hdsap05lD0sDO4ApN8uWImdduJ+J9wH/wj+phDURxDK
3fCoffmB2aAQfTaGHM19j6IhZ+WcpGz1uAy8tl4K13zUC+ZrKfuORoIfWPIp/ECd
/zJGsw0qHR+duOvzRLpm/wuVv43raY7VgGZkN2MubvaKTMrDhQ1NvbPIwu3qfp/K
PeIlcxwR9iqs8R4Q1k3Ys8jvJNAVNTiWPiN+5GM9UxLp9tpCM3QGCHxmePETVsgK
LcA4oBizdckfVGZugT1DjDR2UiOUB0XgWoTZ0NMtw4+IyFx3FRuHquf96Qj2O9MX
iuVsS+dSzJhmgrU0M1SfIPLBj8zc0klE+YtJKrXqY7p8caF3i/wp4UNPu+LvtuF4
1xWvJHhJ5/zPZvcFepV0
=b85z
-----END PGP SIGNATURE-----

--WkHPBKJ2pKcVUM5H--
