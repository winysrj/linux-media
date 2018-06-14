Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:42119 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752759AbeFNHva (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 03:51:30 -0400
Date: Thu, 14 Jun 2018 09:51:18 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Krzysztof Witos <kwitos@cadence.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "open list:CADENCE MIPI-CSI2 BRIDGES" <linux-media@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] added support for csirx dphy
Message-ID: <20180614075118.ukxhr5b73ofjnz6c@flea>
References: <20180608103304.16054-1-kwitos@cadence.com>
 <20180608103304.16054-3-kwitos@cadence.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2addyrvuhlq6nvx5"
Content-Disposition: inline
In-Reply-To: <20180608103304.16054-3-kwitos@cadence.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--2addyrvuhlq6nvx5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 08, 2018 at 11:33:04AM +0100, Krzysztof Witos wrote:
> Signed-off-by: Krzysztof Witos <kwitos@cadence.com>

A commit log explaining what you're doing here would be nice.

> ---
>  drivers/media/platform/cadence/cdns-csi2rx.c | 342 +++++++++++++++++++++=
+++---
>  1 file changed, 313 insertions(+), 29 deletions(-)
>=20
> diff --git a/drivers/media/platform/cadence/cdns-csi2rx.c b/drivers/media=
/platform/cadence/cdns-csi2rx.c
> index a0f02916006b..9251ea6015f0 100644
> --- a/drivers/media/platform/cadence/cdns-csi2rx.c
> +++ b/drivers/media/platform/cadence/cdns-csi2rx.c
> @@ -2,14 +2,16 @@
>  /*
>   * Driver for Cadence MIPI-CSI2 RX Controller v1.3
>   *
> - * Copyright (C) 2017 Cadence Design Systems Inc.
> + * Copyright (C) 2017,2018 Cadence Design Systems Inc.
>   */
> =20
>  #include <linux/clk.h>
> +#include <linux/iopoll.h>
>  #include <linux/delay.h>
>  #include <linux/io.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> +#include <linux/of_address.h>
>  #include <linux/of_graph.h>
>  #include <linux/phy/phy.h>
>  #include <linux/platform_device.h>
> @@ -44,6 +46,33 @@
>  #define CSI2RX_LANES_MAX	4
>  #define CSI2RX_STREAMS_MAX	4
> =20
> +/* DPHY registers */
> +#define DPHY_PMA_CMN(reg)       (reg)
> +#define DPHY_PMA_LCLK(reg)      (0x100 + (reg))
> +#define DPHY_PMA_LDATA(lane, reg)   (0x200 + ((lane) * 0x100) + (reg))
> +#define DPHY_PMA_RCLK(reg)      (0x600 + (reg))
> +#define DPHY_PMA_RDATA(lane, reg)   (0x700 + ((lane) * 0x100) + (reg))
> +#define DPHY_PCS(reg)           (0xb00 + (reg))
> +
> +#define DPHY_CMN_SSM            DPHY_PMA_CMN(0x20)
> +#define DPHY_CMN_SSM_EN         BIT(0)
> +#define DPHY_CMN_RX_MODE_EN     BIT(10)
> +
> +#define DPHY_CMN_PWM            DPHY_PMA_CMN(0x40)
> +#define DPHY_CMN_PWM_DIV(x)     ((x) << 20)
> +#define DPHY_CMN_PWM_LOW(x)     ((x) << 10)
> +#define DPHY_CMN_PWM_HIGH(x)        (x)
> +
> +#define DPHY_CMN_PLL_CFG	DPHY_PMA_CMN(0xE8)
> +#define PLL_LOCKED		BIT(2)
> +
> +#define DPHY_PSM_CFG            DPHY_PCS(0x4)
> +#define DPHY_PSM_CFG_FROM_REG       BIT(0)
> +#define DPHY_PSM_CLK_DIV(x)     ((x) << 1)
> +
> +#define DPHY_BAND_CTRL          DPHY_PCS(0x0)
> +#define DPHY_BAND_LEFT_VAL(x)	(x)
> +
>  enum csi2rx_pads {
>  	CSI2RX_PAD_SINK,
>  	CSI2RX_PAD_SOURCE_STREAM0,
> @@ -67,7 +96,7 @@ struct csi2rx_priv {
>  	struct clk			*sys_clk;
>  	struct clk			*p_clk;
>  	struct clk			*pixel_clk[CSI2RX_STREAMS_MAX];
> -	struct phy			*dphy;
> +	struct clk			*hs_clk;
> =20
>  	u8				lanes[CSI2RX_LANES_MAX];
>  	u8				num_lanes;
> @@ -83,8 +112,175 @@ struct csi2rx_priv {
>  	struct v4l2_async_subdev	asd;
>  	struct v4l2_subdev		*source_subdev;
>  	int				source_pad;
> +	struct cdns_dphy		*dphy;
> +};
> +
> +struct cdns_dphy_cfg {
> +	unsigned int nlanes;
> +};
> +
> +struct cdns_dphy;
> +
> +enum cdns_dphy_clk_lane_cfg {
> +	DPHY_CLK_CFG_LEFT_DRIVES_ALL =3D 0,
> +	DPHY_CLK_CFG_LEFT_DRIVES_RIGHT =3D 1,
> +	DPHY_CLK_CFG_LEFT_DRIVES_LEFT =3D 2,
> +	DPHY_CLK_CFG_RIGHT_DRIVES_ALL =3D 3
> +};
> +
> +struct cdns_dphy_ops {
> +	int (*probe)(struct cdns_dphy *dphy);
> +	void (*remove)(struct cdns_dphy *dphy);
> +	void (*set_psm_div)(struct cdns_dphy *dphy, u8 div);
> +	void (*set_pll_cfg)(struct cdns_dphy *dphy);
> +	void (*set_clk_lane_cfg)(struct cdns_dphy *dphy,
> +		enum cdns_dphy_clk_lane_cfg cfg);
> +	void (*is_pll_locked)(struct cdns_dphy *dphy);
> +	void (*set_band_ctrl)(struct cdns_dphy *dphy, u8 value);
> +};
> +
> +struct cdns_dphy {
> +	struct cdns_dphy_cfg cfg;
> +	void __iomem *regs;
> +	struct clk *psm_clk;
> +	const struct cdns_dphy_ops *ops;
>  };
> =20
> +static int cdns_dphy_set_band_ctrl(struct cdns_dphy *dphy,
> +	struct csi2rx_priv *csirx)
> +{
> +	u8 band_value;
> +	u32 hs_freq_mhz =3D clk_get_rate(csirx->hs_clk);
> +
> +	if (hs_freq_mhz >=3D 80 && hs_freq_mhz < 100)
> +		band_value =3D 0;
> +	else if (hs_freq_mhz >=3D 100 && hs_freq_mhz < 120)
> +		band_value =3D 1;
> +	else if (hs_freq_mhz >=3D 120 && hs_freq_mhz < 160)
> +		band_value =3D 2;
> +	else if (hs_freq_mhz >=3D 160 && hs_freq_mhz < 200)
> +		band_value =3D 3;
> +	else if (hs_freq_mhz >=3D 200 && hs_freq_mhz < 240)
> +		band_value =3D 4;
> +	else if (hs_freq_mhz >=3D 240 && hs_freq_mhz < 280)
> +		band_value =3D 5;
> +	else if (hs_freq_mhz >=3D 280 && hs_freq_mhz < 320)
> +		band_value =3D 6;
> +	else if (hs_freq_mhz >=3D 320 && hs_freq_mhz < 360)
> +		band_value =3D 7;
> +	else if (hs_freq_mhz >=3D 360 && hs_freq_mhz < 400)
> +		band_value =3D 8;
> +	else if (hs_freq_mhz >=3D 400 && hs_freq_mhz < 480)
> +		band_value =3D 9;
> +	else if (hs_freq_mhz >=3D 480 && hs_freq_mhz < 560)
> +		band_value =3D 10;
> +	else if (hs_freq_mhz >=3D 560 && hs_freq_mhz < 640)
> +		band_value =3D 11;
> +	else if (hs_freq_mhz >=3D 640 && hs_freq_mhz < 720)
> +		band_value =3D 12;
> +	else if (hs_freq_mhz >=3D 720 && hs_freq_mhz < 800)
> +		band_value =3D 13;
> +	else if (hs_freq_mhz >=3D 800 && hs_freq_mhz < 880)
> +		band_value =3D 14;
> +	else if (hs_freq_mhz >=3D 880 && hs_freq_mhz < 1040)
> +		band_value =3D 15;
> +	else if (hs_freq_mhz >=3D 1040 && hs_freq_mhz < 1200)
> +		band_value =3D 16;
> +	else if (hs_freq_mhz >=3D 1200 && hs_freq_mhz < 1350)
> +		band_value =3D 17;
> +	else if (hs_freq_mhz >=3D 1350 && hs_freq_mhz < 1500)
> +		band_value =3D 18;
> +	else if (hs_freq_mhz >=3D 1500 && hs_freq_mhz < 1750)
> +		band_value =3D 19;
> +	else if (hs_freq_mhz >=3D 1750 && hs_freq_mhz < 2000)
> +		band_value =3D 20;
> +	else if (hs_freq_mhz >=3D 2000 && hs_freq_mhz < 2250)
> +		band_value =3D 21;
> +	else if (hs_freq_mhz >=3D 2250 && hs_freq_mhz <=3D 2500)
> +		band_value =3D 22;
> +	else
> +		return -EINVAL;
> +
> +	if (dphy->ops->set_band_ctrl)
> +		dphy->ops->set_band_ctrl(dphy, band_value);
> +
> +	return 0;
> +}
> +
> +static int cdns_dphy_setup_psm(struct cdns_dphy *dphy)
> +{
> +	unsigned long psm_clk_hz =3D clk_get_rate(dphy->psm_clk);
> +	unsigned long psm_div;
> +
> +	if (!psm_clk_hz || psm_clk_hz > 100000000)
> +		return -EINVAL;
> +
> +	psm_div =3D DIV_ROUND_CLOSEST(psm_clk_hz, 1000000);
> +	if (dphy->ops->set_psm_div)
> +		dphy->ops->set_psm_div(dphy, psm_div);
> +
> +	return 0;
> +}
> +
> +static void cdns_dphy_set_clk_lane_cfg(struct cdns_dphy *dphy,
> +	enum cdns_dphy_clk_lane_cfg cfg)
> +{
> +	if (dphy->ops->set_clk_lane_cfg)
> +		dphy->ops->set_clk_lane_cfg(dphy, cfg);
> +}
> +
> +static void cdns_dphy_set_pll_cfg(struct cdns_dphy *dphy)
> +{
> +	if (dphy->ops->set_pll_cfg)
> +		dphy->ops->set_pll_cfg(dphy);
> +}
> +
> +static void cdns_dphy_is_pll_locked(struct cdns_dphy *dphy)
> +{
> +	if (dphy->ops->is_pll_locked)
> +		dphy->ops->is_pll_locked(dphy);
> +}
> +
> +static void cdns_csirx_dphy_init(struct csi2rx_priv *csi2rx,
> +	const struct cdns_dphy_cfg *dphy_cfg)
> +{
> +
> +	/*
> +	 * Configure the band control settings.
> +	 */
> +	cdns_dphy_set_band_ctrl(csi2rx->dphy, csi2rx);
> +
> +	/*
> +	 * Configure the internal PSM clk divider so that the DPHY has a
> +	 * 1MHz clk (or something close).
> +	 */
> +	WARN_ON_ONCE(cdns_dphy_setup_psm(csi2rx->dphy));
> +
> +	/*
> +	 * Configure attach clk lanes to data lanes: the DPHY has 2 clk lanes
> +	 * and 8 data lanes, each clk lane can be attache different set of
> +	 * data lanes. The 2 groups are named 'left' and 'right', so here we
> +	 * just say that we want the 'left' clk lane to drive the 'left' data
> +	 * lanes.
> +	 */
> +	cdns_dphy_set_clk_lane_cfg(csi2rx->dphy,
> +		DPHY_CLK_CFG_LEFT_DRIVES_LEFT);
> +
> +	/*
> +	 * Configure the DPHY PLL that will be used to generate the TX byte
> +	 * clk.
> +	 */
> +	cdns_dphy_set_pll_cfg(csi2rx->dphy);
> +
> +	/*  Start RX state machine. */
> +	writel(DPHY_CMN_SSM_EN | DPHY_CMN_RX_MODE_EN,
> +		csi2rx->dphy->regs + DPHY_CMN_SSM);
> +
> +	/* Checking if PLL is locked */
> +	cdns_dphy_is_pll_locked(csi2rx->dphy);
> +
> +}
> +

That part looks like it's pretty much the same thing than the PHY
support in the DSI bridge found there:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/dri=
vers/gpu/drm/bridge/cdns-dsi.c#n493

This code shouldn't be duplicated, but shared, ideally through the phy
framework. That would require some changes to that framework though.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--2addyrvuhlq6nvx5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlsiHnUACgkQ0rTAlCFN
r3Sysw//ZajYAd+lCv/XILZCOifa0LNqhk6p/P9yMFX2g8pNgjCSbs0GkotVAcaY
Xawr4MceLvMINurqsEyeokBACyAQQQZSlLIDjED+KbIVkbSX8/DxozeZ3IbdT/Bx
DeiR8nEeF9NJm+EpbHSmvpi52pTb1KIXE0ajoN0GDo5o7CPsrblHTh0BlZd74XzH
9kCGG2K9c0/IIfDaOmRTBL0112rv4H4V0rjdnQmkaQQU/KsgMz43qvek6fFEQ0hb
e2ycQ7lf2PTTnCLfVR9qVunopmSi+SpVJVKZZFABkGXDLRYcXm71llarxoVGg/sb
k5b4soKn52oJqPsHxQvkjOcEXsnC9NgQ4fKrFJbg9dYnq0LO2g1dO7QhZLzG20eW
a7dtVIbJSutTLxsuep6qVXg54Od3z69hIVXZ/W2a1S67h4zD9Reld5MpVHtkN0RC
vlglmIktI2fFY4rZzEomviCKszsxWLEKc7GCf3g4Knn4x3tRXqQCLnJjCo+iQqNI
vauLnuoPneEc+rdEwTD1d761lwkPTAbhEEh2xl+ByJBlBFvePb743ajDdSpwY0LV
r0m/m6+dyjyNZ811mlkTsivoviC1mfD5FUetxrv6Hr5GSZ0h1e5iyOHJ9hjPuMpE
JnNR69IUWDWZRfs4ry1lKotU36pBoT1CkTMLTS6D4qgC/LwtNbI=
=wj1H
-----END PGP SIGNATURE-----

--2addyrvuhlq6nvx5--
