Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A69E5C282C6
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 15:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7974B218A2
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 15:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbfAYPm6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 10:42:58 -0500
Received: from mail.bootlin.com ([62.4.15.54]:54006 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbfAYPm6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 10:42:58 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id DDC4F20748; Fri, 25 Jan 2019 16:42:54 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-87-206.w90-88.abo.wanadoo.fr [90.88.29.206])
        by mail.bootlin.com (Postfix) with ESMTPSA id A4AF6206A6;
        Fri, 25 Jan 2019 16:42:44 +0100 (CET)
Date:   Fri, 25 Jan 2019 16:42:45 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Jagan Teki <jagan@amarulasolutions.com>
Cc:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Michael Trimarchi <michael@amarulasolutions.com>,
        linux-amarula@amarulasolutions.com, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v7 2/5] media: sun6i: Add A64 CSI block support
Message-ID: <20190125154245.5wx2mwhzsjeaahi3@flea>
References: <20190124180736.28408-1-jagan@amarulasolutions.com>
 <20190124180736.28408-3-jagan@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tnklj4wmwb3jn6kf"
Content-Disposition: inline
In-Reply-To: <20190124180736.28408-3-jagan@amarulasolutions.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--tnklj4wmwb3jn6kf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 24, 2019 at 11:37:33PM +0530, Jagan Teki wrote:
> CSI block in Allwinner A64 has similar features as like in H3,
> but the default CSI_SCLK rate cannot work properly to drive the
> connected sensor interface.
>=20
> The tested mod cock rate is 300 MHz and BSP vfe media driver is also
> using the same rate. Unfortunately there is no valid information about
> clock rate in manual or any other sources except the BSP driver. so more
> faith on BSP code, because same has tested in mainline.
>=20
> So, add support for A64 CSI block by setting updated mod clock rate.
>=20
> Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
> ---
>  drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers=
/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> index ee882b66a5ea..cd2d33242c17 100644
> --- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> @@ -15,6 +15,7 @@
>  #include <linux/ioctl.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> +#include <linux/of_device.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/regmap.h>
> @@ -154,6 +155,7 @@ bool sun6i_csi_is_format_supported(struct sun6i_csi *=
csi,
>  int sun6i_csi_set_power(struct sun6i_csi *csi, bool enable)
>  {
>  	struct sun6i_csi_dev *sdev =3D sun6i_csi_to_dev(csi);
> +	struct device *dev =3D sdev->dev;
>  	struct regmap *regmap =3D sdev->regmap;
>  	int ret;
> =20
> @@ -161,15 +163,20 @@ int sun6i_csi_set_power(struct sun6i_csi *csi, bool=
 enable)
>  		regmap_update_bits(regmap, CSI_EN_REG, CSI_EN_CSI_EN, 0);
> =20
>  		clk_disable_unprepare(sdev->clk_ram);
> +		if (of_device_is_compatible(dev->of_node, "allwinner,sun50i-a64-csi"))
> +			clk_rate_exclusive_put(sdev->clk_mod);
>  		clk_disable_unprepare(sdev->clk_mod);
>  		reset_control_assert(sdev->rstc_bus);
>  		return 0;
>  	}
> =20
> +	if (of_device_is_compatible(dev->of_node, "allwinner,sun50i-a64-csi"))
> +		clk_set_rate_exclusive(sdev->clk_mod, 300000000);
> +
>  	ret =3D clk_prepare_enable(sdev->clk_mod);
>  	if (ret) {
>  		dev_err(sdev->dev, "Enable csi clk err %d\n", ret);
> -		return ret;
> +		goto clk_mod_put;
>  	}
> =20
>  	ret =3D clk_prepare_enable(sdev->clk_ram);
> @@ -192,6 +199,9 @@ int sun6i_csi_set_power(struct sun6i_csi *csi, bool e=
nable)
>  	clk_disable_unprepare(sdev->clk_ram);
>  clk_mod_disable:
>  	clk_disable_unprepare(sdev->clk_mod);
> +clk_mod_put:
> +	if (of_device_is_compatible(dev->of_node, "allwinner,sun50i-a64-csi"))
> +		clk_rate_exclusive_put(sdev->clk_mod);
>  	return ret;

The sequence in the error path and in the disable path aren't the same, why?

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--tnklj4wmwb3jn6kf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXEsudAAKCRDj7w1vZxhR
xUtlAP9qmjr0n5lWso9gLYkmcmovw/38qCAPlv40kaBhVOuxEAEA72tWIsL9UcqJ
eD/tfORhcsC8Rk/qa/Gu4h4ecmwE5Q8=
=Om9h
-----END PGP SIGNATURE-----

--tnklj4wmwb3jn6kf--
