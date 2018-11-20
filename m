Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57304 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731003AbeKTHty (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 02:49:54 -0500
Date: Mon, 19 Nov 2018 23:24:20 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>
Subject: Re: [PATCH v2 8/9] phy: Add Cadence D-PHY support
Message-ID: <20181119212420.mlzk2uboduq7npon@valkosipuli.retiisi.org.uk>
References: <cover.c2c2ae47383b9dbbdee6b69cafdd7391c06dde4f.1541516029.git-series.maxime.ripard@bootlin.com>
 <4ec9e47fb5aa9794f69a8e75a04108055094c056.1541516029.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ec9e47fb5aa9794f69a8e75a04108055094c056.1541516029.git-series.maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On Tue, Nov 06, 2018 at 03:54:20PM +0100, Maxime Ripard wrote:
> Cadence has designed a D-PHY that can be used by the, currently in tree,
> DSI bridge (DRM), CSI Transceiver and CSI Receiver (v4l2) drivers.
> 
> Only the DSI driver has an ad-hoc driver for that phy at the moment, while
> the v4l2 drivers are completely missing any phy support. In order to make
> that phy support available to all these drivers, without having to
> duplicate that code three times, let's create a generic phy framework
> driver.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  Documentation/devicetree/bindings/display/bridge/cdns,dsi.txt |  21 +-
>  Documentation/devicetree/bindings/phy/cdns,dphy.txt           |  20 +-

Coould you split out the DT binding changes into a separate patch?

>  drivers/phy/cadence/Kconfig                                   |  13 +-
>  drivers/phy/cadence/Makefile                                  |   1 +-
>  drivers/phy/cadence/cdns-dphy.c                               | 459 +++++++-
>  5 files changed, 492 insertions(+), 22 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/phy/cdns,dphy.txt
>  create mode 100644 drivers/phy/cadence/cdns-dphy.c
> 
> diff --git a/Documentation/devicetree/bindings/display/bridge/cdns,dsi.txt b/Documentation/devicetree/bindings/display/bridge/cdns,dsi.txt
> index f5725bb6c61c..525a4bfd8634 100644
> --- a/Documentation/devicetree/bindings/display/bridge/cdns,dsi.txt
> +++ b/Documentation/devicetree/bindings/display/bridge/cdns,dsi.txt
> @@ -31,28 +31,7 @@ Required subnodes:
>  - one subnode per DSI device connected on the DSI bus. Each DSI device should
>    contain a reg property encoding its virtual channel.
>  
> -Cadence DPHY
> -============
> -
> -Cadence DPHY block.
> -
> -Required properties:
> -- compatible: should be set to "cdns,dphy".
> -- reg: physical base address and length of the DPHY registers.
> -- clocks: DPHY reference clocks.
> -- clock-names: must contain "psm" and "pll_ref".
> -- #phy-cells: must be set to 0.
> -
> -
>  Example:
> -	dphy0: dphy@fd0e0000{
> -		compatible = "cdns,dphy";
> -		reg = <0x0 0xfd0e0000 0x0 0x1000>;
> -		clocks = <&psm_clk>, <&pll_ref_clk>;
> -		clock-names = "psm", "pll_ref";
> -		#phy-cells = <0>;
> -	};
> -
>  	dsi0: dsi@fd0c0000 {
>  		compatible = "cdns,dsi";
>  		reg = <0x0 0xfd0c0000 0x0 0x1000>;
> diff --git a/Documentation/devicetree/bindings/phy/cdns,dphy.txt b/Documentation/devicetree/bindings/phy/cdns,dphy.txt
> new file mode 100644
> index 000000000000..1095bc4e72d9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/cdns,dphy.txt
> @@ -0,0 +1,20 @@
> +Cadence DPHY
> +============
> +
> +Cadence DPHY block.
> +
> +Required properties:
> +- compatible: should be set to "cdns,dphy".
> +- reg: physical base address and length of the DPHY registers.
> +- clocks: DPHY reference clocks.
> +- clock-names: must contain "psm" and "pll_ref".
> +- #phy-cells: must be set to 0.
> +
> +Example:
> +	dphy0: dphy@fd0e0000{
> +		compatible = "cdns,dphy";
> +		reg = <0x0 0xfd0e0000 0x0 0x1000>;
> +		clocks = <&psm_clk>, <&pll_ref_clk>;
> +		clock-names = "psm", "pll_ref";
> +		#phy-cells = <0>;
> +	};
> diff --git a/drivers/phy/cadence/Kconfig b/drivers/phy/cadence/Kconfig
> index 57fff7de4031..240effa81046 100644
> --- a/drivers/phy/cadence/Kconfig
> +++ b/drivers/phy/cadence/Kconfig
> @@ -1,6 +1,7 @@
>  #
> -# Phy driver for Cadence MHDP DisplayPort controller
> +# Phy drivers for Cadence IPs
>  #
> +
>  config PHY_CADENCE_DP
>  	tristate "Cadence MHDP DisplayPort PHY driver"
>  	depends on OF
> @@ -8,3 +9,13 @@ config PHY_CADENCE_DP
>  	select GENERIC_PHY
>  	help
>  	  Support for Cadence MHDP DisplayPort PHY.
> +
> +config PHY_CADENCE_DPHY
> +	tristate "Cadence D-PHY Support"
> +	depends on HAS_IOMEM && OF
> +	select GENERIC_PHY
> +	select GENERIC_PHY_MIPI_DPHY
> +	help
> +	  Choose this option if you have a Cadence D-PHY in your
> +	  system. If M is selected, the module will be called
> +	  cdns-csi.
> diff --git a/drivers/phy/cadence/Makefile b/drivers/phy/cadence/Makefile
> index e5b0a11cf28a..64cb9ea66ceb 100644
> --- a/drivers/phy/cadence/Makefile
> +++ b/drivers/phy/cadence/Makefile
> @@ -1 +1,2 @@
>  obj-$(CONFIG_PHY_CADENCE_DP)	+= phy-cadence-dp.o
> +obj-$(CONFIG_PHY_CADENCE_DPHY)	+= cdns-dphy.o
> diff --git a/drivers/phy/cadence/cdns-dphy.c b/drivers/phy/cadence/cdns-dphy.c
> new file mode 100644
> index 000000000000..a398b401e5d3
> --- /dev/null
> +++ b/drivers/phy/cadence/cdns-dphy.c
> @@ -0,0 +1,459 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright: 2017-2018 Cadence Design Systems, Inc.
> + */
> +
> +#include <linux/bitops.h>
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of_address.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/reset.h>
> +
> +#include <linux/phy/phy.h>
> +#include <linux/phy/phy-mipi-dphy.h>
> +
> +#define REG_WAKEUP_TIME_NS		800
> +#define DPHY_PLL_RATE_HZ		108000000
> +
> +/* DPHY registers */
> +#define DPHY_PMA_CMN(reg)		(reg)
> +#define DPHY_PMA_LCLK(reg)		(0x100 + (reg))
> +#define DPHY_PMA_LDATA(lane, reg)	(0x200 + ((lane) * 0x100) + (reg))
> +#define DPHY_PMA_RCLK(reg)		(0x600 + (reg))
> +#define DPHY_PMA_RDATA(lane, reg)	(0x700 + ((lane) * 0x100) + (reg))
> +#define DPHY_PCS(reg)			(0xb00 + (reg))
> +
> +#define DPHY_CMN_SSM			DPHY_PMA_CMN(0x20)
> +#define DPHY_CMN_SSM_EN			BIT(0)
> +#define DPHY_CMN_TX_MODE_EN		BIT(9)
> +
> +#define DPHY_CMN_PWM			DPHY_PMA_CMN(0x40)
> +#define DPHY_CMN_PWM_DIV(x)		((x) << 20)
> +#define DPHY_CMN_PWM_LOW(x)		((x) << 10)
> +#define DPHY_CMN_PWM_HIGH(x)		(x)
> +
> +#define DPHY_CMN_FBDIV			DPHY_PMA_CMN(0x4c)
> +#define DPHY_CMN_FBDIV_VAL(low, high)	(((high) << 11) | ((low) << 22))
> +#define DPHY_CMN_FBDIV_FROM_REG		(BIT(10) | BIT(21))
> +
> +#define DPHY_CMN_OPIPDIV		DPHY_PMA_CMN(0x50)
> +#define DPHY_CMN_IPDIV_FROM_REG		BIT(0)
> +#define DPHY_CMN_IPDIV(x)		((x) << 1)
> +#define DPHY_CMN_OPDIV_FROM_REG		BIT(6)
> +#define DPHY_CMN_OPDIV(x)		((x) << 7)
> +
> +#define DPHY_PSM_CFG			DPHY_PCS(0x4)
> +#define DPHY_PSM_CFG_FROM_REG		BIT(0)
> +#define DPHY_PSM_CLK_DIV(x)		((x) << 1)
> +
> +#define DSI_HBP_FRAME_OVERHEAD		12
> +#define DSI_HSA_FRAME_OVERHEAD		14
> +#define DSI_HFP_FRAME_OVERHEAD		6
> +#define DSI_HSS_VSS_VSE_FRAME_OVERHEAD	4
> +#define DSI_BLANKING_FRAME_OVERHEAD	6
> +#define DSI_NULL_FRAME_OVERHEAD		6
> +#define DSI_EOT_PKT_SIZE		4
> +
> +struct cdns_dphy_cfg {
> +	u8 pll_ipdiv;
> +	u8 pll_opdiv;
> +	u16 pll_fbdiv;
> +	unsigned int nlanes;
> +};
> +
> +enum cdns_dphy_clk_lane_cfg {
> +	DPHY_CLK_CFG_LEFT_DRIVES_ALL = 0,
> +	DPHY_CLK_CFG_LEFT_DRIVES_RIGHT = 1,
> +	DPHY_CLK_CFG_LEFT_DRIVES_LEFT = 2,
> +	DPHY_CLK_CFG_RIGHT_DRIVES_ALL = 3,
> +};
> +
> +struct cdns_dphy;
> +struct cdns_dphy_ops {
> +	int (*probe)(struct cdns_dphy *dphy);
> +	void (*remove)(struct cdns_dphy *dphy);
> +	void (*set_psm_div)(struct cdns_dphy *dphy, u8 div);
> +	void (*set_clk_lane_cfg)(struct cdns_dphy *dphy,
> +				 enum cdns_dphy_clk_lane_cfg cfg);
> +	void (*set_pll_cfg)(struct cdns_dphy *dphy,
> +			    const struct cdns_dphy_cfg *cfg);
> +	unsigned long (*get_wakeup_time_ns)(struct cdns_dphy *dphy);
> +};
> +
> +struct cdns_dphy {
> +	struct cdns_dphy_cfg cfg;
> +	void __iomem *regs;
> +	struct clk *psm_clk;
> +	struct clk *pll_ref_clk;
> +	const struct cdns_dphy_ops *ops;
> +	struct phy *phy;
> +};
> +
> +static int cdns_dsi_get_dphy_pll_cfg(struct cdns_dphy *dphy,
> +				     struct cdns_dphy_cfg *cfg,
> +				     struct phy_configure_opts_mipi_dphy *opts,
> +				     unsigned int *dsi_hfp_ext)
> +{
> +	u64 dlane_bps, dlane_bps_max, fbdiv, fbdiv_max, adj_dsi_htotal;
> +	unsigned long pll_ref_hz = clk_get_rate(dphy->pll_ref_clk);
> +
> +	memset(cfg, 0, sizeof(*cfg));
> +
> +	if (pll_ref_hz < 9600000 || pll_ref_hz >= 150000000)
> +		return -EINVAL;
> +	else if (pll_ref_hz < 19200000)
> +		cfg->pll_ipdiv = 1;
> +	else if (pll_ref_hz < 38400000)
> +		cfg->pll_ipdiv = 2;
> +	else if (pll_ref_hz < 76800000)
> +		cfg->pll_ipdiv = 4;
> +	else
> +		cfg->pll_ipdiv = 8;
> +
> +	dlane_bps = opts->hs_clk_rate;
> +
> +	if (dlane_bps > 2500000000UL || dlane_bps < 160000000UL)
> +		return -EINVAL;
> +	else if (dlane_bps >= 1250000000)
> +		cfg->pll_opdiv = 1;
> +	else if (dlane_bps >= 630000000)
> +		cfg->pll_opdiv = 2;
> +	else if (dlane_bps >= 320000000)
> +		cfg->pll_opdiv = 4;
> +	else if (dlane_bps >= 160000000)
> +		cfg->pll_opdiv = 8;
> +
> +	/*
> +	 * Allow a deviation of 0.2% on the per-lane data rate to try to
> +	 * recover a potential mismatch between DPI and PPI clks.
> +	 */
> +	dlane_bps_max = dlane_bps + DIV_ROUND_DOWN_ULL(dlane_bps, 500);
> +	fbdiv_max = DIV_ROUND_DOWN_ULL(dlane_bps_max * 2 *
> +				       cfg->pll_opdiv * cfg->pll_ipdiv,
> +				       pll_ref_hz);
> +	fbdiv = DIV_ROUND_UP_ULL(dlane_bps * 2 * cfg->pll_opdiv *
> +				 cfg->pll_ipdiv,
> +				 pll_ref_hz);
> +
> +	/*
> +	 * Iterate over all acceptable fbdiv and try to find an adjusted DSI
> +	 * htotal length providing an exact match.
> +	 *
> +	 * Note that we could do something even trickier by relying on the fact
> +	 * that a new line is not necessarily aligned on a lane boundary, so,
> +	 * by making adj_dsi_htotal non aligned on a dsi_lanes we can improve a
> +	 * bit the precision. With this, the step would be
> +	 *
> +	 *	pll_ref_hz / (2 * opdiv * ipdiv * nlanes)
> +	 *
> +	 * instead of
> +	 *
> +	 *	pll_ref_hz / (2 * opdiv * ipdiv)
> +	 *
> +	 * The drawback of this approach is that we would need to make sure the
> +	 * number or lines is a multiple of the realignment periodicity which is
> +	 * a function of the number of lanes and the original misalignment. For
> +	 * example, for NLANES = 4 and HTOTAL % NLANES = 3, it takes 4 lines
> +	 * to realign on a lane:
> +	 * LINE 0: expected number of bytes, starts emitting first byte of
> +	 *	   LINE 1 on LANE 3
> +	 * LINE 1: expected number of bytes, starts emitting first 2 bytes of
> +	 *	   LINE 2 on LANES 2 and 3
> +	 * LINE 2: expected number of bytes, starts emitting first 3 bytes of
> +	 *	   of LINE 3 on LANES 1, 2 and 3
> +	 * LINE 3: one byte less, now things are realigned on LANE 0 for LINE 4
> +	 *
> +	 * I figured this extra complexity was not worth the benefit, but if
> +	 * someone really has unfixable mismatch, that would be something to
> +	 * investigate.
> +	 */
> +	for (; fbdiv <= fbdiv_max; fbdiv++) {
> +		u32 rem;
> +
> +		/*
> +		 * Do the division in 2 steps to avoid an overflow on the
> +		 * divider.
> +		 */
> +		rem = do_div(adj_dsi_htotal, opts->hs_clk_rate);

Hmm. I don't see adj_dsi_htotal being set anywhere. I suppose that can't be
intended.

> +		if (rem)
> +			continue;
> +
> +		rem = do_div(adj_dsi_htotal,
> +			     cfg->pll_opdiv * cfg->pll_ipdiv * 2 * 8);
> +		if (rem)
> +			continue;

Is fbdiv supposed to be used in the formula somewhere?

> +
> +		cfg->pll_fbdiv = fbdiv;
> +		break;
> +	}
> +
> +	/* No match, let's just reject the display mode. */
> +	if (!cfg->pll_fbdiv)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int cdns_dphy_setup_psm(struct cdns_dphy *dphy)
> +{
> +	unsigned long psm_clk_hz = clk_get_rate(dphy->psm_clk);
> +	unsigned long psm_div;
> +
> +	if (!psm_clk_hz || psm_clk_hz > 100000000)
> +		return -EINVAL;
> +
> +	psm_div = DIV_ROUND_CLOSEST(psm_clk_hz, 1000000);
> +	if (dphy->ops->set_psm_div)
> +		dphy->ops->set_psm_div(dphy, psm_div);
> +
> +	return 0;
> +}
> +
> +static void cdns_dphy_set_clk_lane_cfg(struct cdns_dphy *dphy,
> +				       enum cdns_dphy_clk_lane_cfg cfg)
> +{
> +	if (dphy->ops->set_clk_lane_cfg)
> +		dphy->ops->set_clk_lane_cfg(dphy, cfg);
> +}
> +
> +static void cdns_dphy_set_pll_cfg(struct cdns_dphy *dphy,
> +				  const struct cdns_dphy_cfg *cfg)
> +{
> +	if (dphy->ops->set_pll_cfg)
> +		dphy->ops->set_pll_cfg(dphy, cfg);
> +}
> +
> +static unsigned long cdns_dphy_get_wakeup_time_ns(struct cdns_dphy *dphy)
> +{
> +	return dphy->ops->get_wakeup_time_ns(dphy);
> +}
> +
> +static unsigned long cdns_dphy_ref_get_wakeup_time_ns(struct cdns_dphy *dphy)
> +{
> +	/* Default wakeup time is 800 ns (in a simulated environment). */
> +	return 800;
> +}
> +
> +static void cdns_dphy_ref_set_pll_cfg(struct cdns_dphy *dphy,
> +				      const struct cdns_dphy_cfg *cfg)
> +{
> +	u32 fbdiv_low, fbdiv_high;
> +
> +	fbdiv_low = (cfg->pll_fbdiv / 4) - 2;
> +	fbdiv_high = cfg->pll_fbdiv - fbdiv_low - 2;
> +
> +	writel(DPHY_CMN_IPDIV_FROM_REG | DPHY_CMN_OPDIV_FROM_REG |
> +	       DPHY_CMN_IPDIV(cfg->pll_ipdiv) |
> +	       DPHY_CMN_OPDIV(cfg->pll_opdiv),
> +	       dphy->regs + DPHY_CMN_OPIPDIV);
> +	writel(DPHY_CMN_FBDIV_FROM_REG |
> +	       DPHY_CMN_FBDIV_VAL(fbdiv_low, fbdiv_high),
> +	       dphy->regs + DPHY_CMN_FBDIV);
> +	writel(DPHY_CMN_PWM_HIGH(6) | DPHY_CMN_PWM_LOW(0x101) |
> +	       DPHY_CMN_PWM_DIV(0x8),
> +	       dphy->regs + DPHY_CMN_PWM);
> +}
> +
> +static void cdns_dphy_ref_set_psm_div(struct cdns_dphy *dphy, u8 div)
> +{
> +	writel(DPHY_PSM_CFG_FROM_REG | DPHY_PSM_CLK_DIV(div),
> +	       dphy->regs + DPHY_PSM_CFG);
> +}
> +
> +/*
> + * This is the reference implementation of DPHY hooks. Specific integration of
> + * this IP may have to re-implement some of them depending on how they decided
> + * to wire things in the SoC.
> + */
> +static const struct cdns_dphy_ops ref_dphy_ops = {
> +	.get_wakeup_time_ns = cdns_dphy_ref_get_wakeup_time_ns,
> +	.set_pll_cfg = cdns_dphy_ref_set_pll_cfg,
> +	.set_psm_div = cdns_dphy_ref_set_psm_div,
> +};
> +
> +static int cdns_dphy_config_from_opts(struct phy *phy,
> +				      struct phy_configure_opts_mipi_dphy *opts,
> +				      struct cdns_dphy_cfg *cfg)
> +{
> +	struct cdns_dphy *dphy = phy_get_drvdata(phy);
> +	unsigned int dsi_hfp_ext = 0;
> +	int ret;
> +
> +	ret = phy_mipi_dphy_config_validate(opts);
> +	if (ret)
> +		return ret;
> +
> +	ret = cdns_dsi_get_dphy_pll_cfg(dphy, cfg,
> +					opts, &dsi_hfp_ext);
> +	if (ret)
> +		return ret;
> +
> +	opts->wakeup = cdns_dphy_get_wakeup_time_ns(dphy);
> +
> +	return 0;
> +}
> +
> +static int cdns_dphy_init(struct phy *phy)
> +{
> +	struct cdns_dphy *dphy = phy_get_drvdata(phy);
> +
> +	clk_prepare_enable(dphy->psm_clk);
> +	clk_prepare_enable(dphy->pll_ref_clk);
> +
> +	return 0;
> +}
> +
> +static int cdns_dphy_validate(struct phy *phy, enum phy_mode mode,
> +			      union phy_configure_opts *opts)
> +{
> +	struct cdns_dphy_cfg cfg = { 0 };
> +
> +	if (mode != PHY_MODE_MIPI_DPHY)
> +		return -EINVAL;
> +
> +	return cdns_dphy_config_from_opts(phy, &opts->mipi_dphy, &cfg);
> +}
> +
> +static int cdns_dphy_configure(struct phy *phy, union phy_configure_opts *opts)
> +{
> +	struct cdns_dphy *dphy = phy_get_drvdata(phy);
> +	struct cdns_dphy_cfg cfg = { 0 };
> +	int ret;
> +
> +	ret = cdns_dphy_config_from_opts(phy, &opts->mipi_dphy, &cfg);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Configure the internal PSM clk divider so that the DPHY has a
> +	 * 1MHz clk (or something close).
> +	 */
> +	ret = cdns_dphy_setup_psm(dphy);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Configure attach clk lanes to data lanes: the DPHY has 2 clk lanes
> +	 * and 8 data lanes, each clk lane can be attache different set of
> +	 * data lanes. The 2 groups are named 'left' and 'right', so here we
> +	 * just say that we want the 'left' clk lane to drive the 'left' data
> +	 * lanes.
> +	 */
> +	cdns_dphy_set_clk_lane_cfg(dphy, DPHY_CLK_CFG_LEFT_DRIVES_LEFT);
> +
> +	/*
> +	 * Configure the DPHY PLL that will be used to generate the TX byte
> +	 * clk.
> +	 */
> +	cdns_dphy_set_pll_cfg(dphy, &cfg);
> +
> +	return 0;
> +}
> +
> +static int cdns_dphy_power_on(struct phy *phy)
> +{
> +	struct cdns_dphy *dphy = phy_get_drvdata(phy);
> +
> +	/* Start TX state machine. */
> +	writel(DPHY_CMN_SSM_EN | DPHY_CMN_TX_MODE_EN, dphy->regs + DPHY_CMN_SSM);
> +
> +	return 0;
> +}
> +
> +static int cdns_dphy_exit(struct phy *phy)
> +{
> +	struct cdns_dphy *dphy = phy_get_drvdata(phy);
> +
> +	clk_disable_unprepare(dphy->pll_ref_clk);
> +	clk_disable_unprepare(dphy->psm_clk);

Wouldn't this belong to power_off() (and enabling the clocks to
power_on())?

> +
> +	return 0;
> +}
> +
> +static struct phy_ops cdns_dphy_ops = {

const

> +	.configure	= cdns_dphy_configure,
> +	.validate	= cdns_dphy_validate,
> +	.power_on	= cdns_dphy_power_on,

How does it stop? Or does it? :-)

> +	.init		= cdns_dphy_init,

It'd be nice to maintain the order the same as in here (unless there are
reasons to do otherwise, of course).

> +	.exit		= cdns_dphy_exit,
> +};
> +
> +static int cdns_dphy_probe(struct platform_device *pdev)
> +{
> +	struct phy_provider *phy_provider;
> +	struct cdns_dphy *dphy;
> +	struct resource *res;
> +	int ret;
> +
> +	dphy = devm_kzalloc(&pdev->dev, sizeof(*dphy), GFP_KERNEL);
> +	if (!dphy)
> +		return -ENOMEM;
> +	dev_set_drvdata(&pdev->dev, dphy);
> +
> +	dphy->ops = of_device_get_match_data(&pdev->dev);
> +	if (!dphy->ops)
> +		return -EINVAL;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	dphy->regs = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(dphy->regs))
> +		return PTR_ERR(dphy->regs);
> +
> +	dphy->psm_clk = devm_clk_get(&pdev->dev, "psm");
> +	if (IS_ERR(dphy->psm_clk))
> +		return PTR_ERR(dphy->psm_clk);
> +
> +	dphy->pll_ref_clk = devm_clk_get(&pdev->dev, "pll_ref");
> +	if (IS_ERR(dphy->pll_ref_clk))
> +		return PTR_ERR(dphy->pll_ref_clk);
> +
> +	if (dphy->ops->probe) {

You could declare ret here. Entirely up to you.

> +		ret = dphy->ops->probe(dphy);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	dphy->phy = devm_phy_create(&pdev->dev, NULL, &cdns_dphy_ops);
> +	if (IS_ERR(dphy->phy)) {
> +		dev_err(&pdev->dev, "failed to create PHY\n");
> +		return PTR_ERR(dphy->phy);

Would it be appropriate to call the remove callback here?

> +	}
> +
> +	phy_set_drvdata(dphy->phy, dphy);
> +	phy_provider = devm_of_phy_provider_register(&pdev->dev, of_phy_simple_xlate);
> +
> +	return PTR_ERR_OR_ZERO(phy_provider);
> +}
> +
> +static int cdns_dphy_remove(struct platform_device *pdev)
> +{
> +	struct cdns_dphy *dphy = dev_get_drvdata(&pdev->dev);
> +
> +	if (dphy->ops->remove)
> +		dphy->ops->remove(dphy);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id cdns_dphy_of_match[] = {
> +	{ .compatible = "cdns,dphy", .data = &ref_dphy_ops },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, cdns_dphy_of_match);
> +
> +static struct platform_driver cdns_dphy_platform_driver = {
> +	.probe		= cdns_dphy_probe,
> +	.remove		= cdns_dphy_remove,
> +	.driver		= {
> +		.name		= "cdns-mipi-dphy",
> +		.of_match_table	= cdns_dphy_of_match,
> +	},
> +};
> +module_platform_driver(cdns_dphy_platform_driver);
> +
> +MODULE_AUTHOR("Maxime Ripard <maxime.ripard@bootlin>");

bootlin.com ?

> +MODULE_DESCRIPTION("Cadence MIPI D-PHY Driver");
> +MODULE_LICENSE("GPL");

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
