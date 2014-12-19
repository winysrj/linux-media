Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:53942 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751985AbaLSV7Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 16:59:25 -0500
Date: Fri, 19 Dec 2014 19:24:05 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee.jones@linaro.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 06/13] clk: sunxi: Make the mod0 clk driver also a
 platform driver
Message-ID: <20141219182405.GU4820@lukather>
References: <1418836704-15689-1-git-send-email-hdegoede@redhat.com>
 <1418836704-15689-7-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8Tx+BDMK09J610+l"
Content-Disposition: inline
In-Reply-To: <1418836704-15689-7-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--8Tx+BDMK09J610+l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Dec 17, 2014 at 06:18:17PM +0100, Hans de Goede wrote:
> With the prcm in sun6i (and some later SoCs) some mod0 clocks are instant=
iated
> through the mfd framework, and as such do not work with of_clk_declare, s=
ince
> they do not have registers assigned to them yet at of_clk_declare init ti=
me.
>=20
> Silence the error on not finding registers in the of_clk_declare mod0 clk
> setup method, and also register mod0-clk support as a platform driver to =
work
> properly with mfd instantiated mod0 clocks.
>=20
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/clk/sunxi/clk-mod0.c | 41 ++++++++++++++++++++++++++++++++++++--=
---
>  1 file changed, 36 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/clk/sunxi/clk-mod0.c b/drivers/clk/sunxi/clk-mod0.c
> index 658d74f..7ddab6f 100644
> --- a/drivers/clk/sunxi/clk-mod0.c
> +++ b/drivers/clk/sunxi/clk-mod0.c
> @@ -17,6 +17,7 @@
>  #include <linux/clk-provider.h>
>  #include <linux/clkdev.h>
>  #include <linux/of_address.h>
> +#include <linux/platform_device.h>
> =20
>  #include "clk-factors.h"
> =20
> @@ -67,7 +68,7 @@ static struct clk_factors_config sun4i_a10_mod0_config =
=3D {
>  	.pwidth =3D 2,
>  };
> =20
> -static const struct factors_data sun4i_a10_mod0_data __initconst =3D {
> +static const struct factors_data sun4i_a10_mod0_data =3D {
>  	.enable =3D 31,
>  	.mux =3D 24,
>  	.muxmask =3D BIT(1) | BIT(0),
> @@ -82,17 +83,47 @@ static void __init sun4i_a10_mod0_setup(struct device=
_node *node)
>  	void __iomem *reg;
> =20
>  	reg =3D of_iomap(node, 0);
> -	if (!reg) {
> -		pr_err("Could not get registers for mod0-clk: %s\n",
> -		       node->name);
> +	if (!reg)
>  		return;
> -	}

A comment here would be nice to mention that this is intentional.

It looks good otherwise, thanks!

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--8Tx+BDMK09J610+l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUlG1FAAoJEBx+YmzsjxAgG8IP/jQ5/K9ng9byYeZ/xwA1Z5QL
a1HnERImkO9LKl+CVicfJkil+p7jSN21zgWIkObdLgBAsRbNqXnXdbvc5hM9k+fz
RJYCasyQotWFHxrWtgElCqtj17CJNdaWqiAFa2YQjecL4KjN4LPzJ4eFgVb/Dluo
EyYJ5L/gy+EMKHXgKPcgaIhfuikcyr0sLEhpe+bAwgfN6zEW0tIxar7jqo+pDSB9
rlTa+CXts8ABP5pGg/cshlOdpLyxqHJ2+dkxPiZEJ2Ph6JRdJfFQ9uqTtkSNTpVI
NYmTm1/6le5P+7IBCASaFNOSrrqiotRhbw/xD0510KX2nGP9pDmM6NCAfsRlWrk/
tuonA7gt6+DEj+XBqhQ5f9l/E4H9caxiMxry+fmfekkaMYoZlFP1SiT76AHUgWTM
orXQaZf03aX9FqnKiDvNE6Xlwxhu1TyY3ycePlFzSSPFhV0myeR0awTJyyAg/y55
FLdPpVCIRU0BFvoVed27EXpSHZEPp3ImzR1tPJbIgByQwK+5wyfKwBdrxD3xnp1V
QPePtIEXGuJkIMmqblW0v2GcRPDyd9FnbtCVRnNn48AyYxvsFO5Yarc1/Z9TsO8w
pEorBEsNxoAfFdiBkX72UzXC0qNvnQ5cjjvRyNlBw8wWd4Vk61t+0pqRDao56pT+
JawCbUZqlxtr9j1A3qMN
=N/zi
-----END PGP SIGNATURE-----

--8Tx+BDMK09J610+l--
