Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:37930 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755029Ab3F1Jfn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 05:35:43 -0400
Date: Fri, 28 Jun 2013 12:35:00 +0300
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
Subject: Re: [PATCH V2 3/3] video: exynos_dp: Use the generic PHY driver
Message-ID: <20130628093459.GD11297@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <002101ce73cf$ac989b70$05c9d250$@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="76DTJ5CE0DCVQemd"
Content-Disposition: inline
In-Reply-To: <002101ce73cf$ac989b70$05c9d250$@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--76DTJ5CE0DCVQemd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 28, 2013 at 04:18:23PM +0900, Jingoo Han wrote:
> Use the generic PHY API instead of the platform callback to control
> the DP PHY. The 'phy_label' field is added to the platform data
> structure to allow PHY lookup on non-dt platforms.
>=20
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  .../devicetree/bindings/video/exynos_dp.txt        |   17 ---
>  drivers/video/exynos/exynos_dp_core.c              |  118 ++------------=
------
>  drivers/video/exynos/exynos_dp_core.h              |    2 +
>  include/video/exynos_dp.h                          |    6 +-
>  4 files changed, 15 insertions(+), 128 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/video/exynos_dp.txt b/Docu=
mentation/devicetree/bindings/video/exynos_dp.txt
> index 84f10c1..a8320e3 100644
> --- a/Documentation/devicetree/bindings/video/exynos_dp.txt
> +++ b/Documentation/devicetree/bindings/video/exynos_dp.txt
> @@ -1,17 +1,6 @@
>  The Exynos display port interface should be configured based on
>  the type of panel connected to it.
> =20
> -We use two nodes:
> -	-dp-controller node
> -	-dptx-phy node(defined inside dp-controller node)
> -
> -For the DP-PHY initialization, we use the dptx-phy node.
> -Required properties for dptx-phy:
> -	-reg:
> -		Base address of DP PHY register.
> -	-samsung,enable-mask:
> -		The bit-mask used to enable/disable DP PHY.
> -
>  For the Panel initialization, we read data from dp-controller node.
>  Required properties for dp-controller:
>  	-compatible:
> @@ -67,12 +56,6 @@ SOC specific portion:
>  		interrupt-parent =3D <&combiner>;
>  		clocks =3D <&clock 342>;
>  		clock-names =3D "dp";
> -
> -		dptx-phy {
> -			reg =3D <0x10040720>;
> -			samsung,enable-mask =3D <1>;
> -		};
> -
>  	};
> =20
>  Board Specific portion:
> diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos=
/exynos_dp_core.c
> index 12bbede..bac515b 100644
> --- a/drivers/video/exynos/exynos_dp_core.c
> +++ b/drivers/video/exynos/exynos_dp_core.c
> @@ -19,6 +19,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/delay.h>
>  #include <linux/of.h>
> +#include <linux/phy/phy.h>
> =20
>  #include <video/exynos_dp.h>
> =20
> @@ -960,84 +961,15 @@ static struct exynos_dp_platdata *exynos_dp_dt_pars=
e_pdata(struct device *dev)
>  		return ERR_PTR(-EINVAL);
>  	}
> =20
> -	return pd;
> -}
> -
> -static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
> -{
> -	struct device_node *dp_phy_node =3D of_node_get(dp->dev->of_node);
> -	u32 phy_base;
> -	int ret =3D 0;
> -
> -	dp_phy_node =3D of_find_node_by_name(dp_phy_node, "dptx-phy");
> -	if (!dp_phy_node) {
> -		dev_err(dp->dev, "could not find dptx-phy node\n");
> -		return -ENODEV;
> -	}
> -
> -	if (of_property_read_u32(dp_phy_node, "reg", &phy_base)) {
> -		dev_err(dp->dev, "failed to get reg for dptx-phy\n");
> -		ret =3D -EINVAL;
> -		goto err;
> -	}
> -
> -	if (of_property_read_u32(dp_phy_node, "samsung,enable-mask",
> -				&dp->enable_mask)) {
> -		dev_err(dp->dev, "failed to get enable-mask for dptx-phy\n");
> -		ret =3D -EINVAL;
> -		goto err;
> -	}
> -
> -	dp->phy_addr =3D ioremap(phy_base, SZ_4);
> -	if (!dp->phy_addr) {
> -		dev_err(dp->dev, "failed to ioremap dp-phy\n");
> -		ret =3D -ENOMEM;
> -		goto err;
> -	}
> -
> -err:
> -	of_node_put(dp_phy_node);
> -
> -	return ret;
> -}
> -
> -static void exynos_dp_phy_init(struct exynos_dp_device *dp)
> -{
> -	u32 reg;
> -
> -	reg =3D __raw_readl(dp->phy_addr);
> -	reg |=3D dp->enable_mask;
> -	__raw_writel(reg, dp->phy_addr);
> -}
> -
> -static void exynos_dp_phy_exit(struct exynos_dp_device *dp)
> -{
> -	u32 reg;
> +	pd->phy_label =3D "dp";

only the label, which I would use 'display-port'. Other than that:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--76DTJ5CE0DCVQemd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzVjDAAoJEIaOsuA1yqRE/QAP/ii2WXuARRTzMFm+mbqJxxw0
O/eHemAN1v3WdoKmgzdfo+1Jctf3VBsUvwx8uSLlKfLZvkrHA4wDQARXmtydjw79
RxWdTsLPewbo0jm+OcyMdaCKNkPzJtlga0ghOGZeRub8o2hWxAJsYN7EKz9SfBjV
ECCcY5W5ekM0u3hQgwyKvGXZCMNlsaS0x6EUFprPxdgXWE3mwNA4rU+ymNIO3yJC
OBDmUfxIuBEt/qB0hYMC2G2LRTeMhOj8UMfPq3vsb2pA3HxFzwsr2d6TjmjcF6jr
5ggsNa7pPhTPelyxMAKD8jxBqHmziltbNSGyKDoNYIKu1cKEds7bo12ym8XAmX2q
oNffv1kxzpXgANfYYV2pM5XCKR8m2iQVOhKTROnhqfjaECsRvIGYBbtQ6G+3fLcH
5ctHIWReeyXw+DOrSPVJi0XBUSGl3uGOPk9XPgo6tkT7MNH+bTaHtqg7g4XD70gL
LCVyU00uR1d2CvK02bDo5uDPrWHAiYj8ZXeio58DRGfJWmLz/6TecBK1N/lj7st0
19Yl8QW7iJcFC3RlYrQl0juq4/Z2JLaolHr58VvP9OxlgEDlcR2OCY+2Qw9rz9y6
ybP+TNkFKGgRPUSTty53YdvDEFSus6XHXAg34lk6Rak3U+UKmTlgUI7s+cB7WNQC
+BV+N5Bf/Ndfm0vJ5DNB
=x3dN
-----END PGP SIGNATURE-----

--76DTJ5CE0DCVQemd--
