Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36936 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab2JJXdr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 19:33:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	tony@atomide.com, khilman@deeprootsystems.com
Subject: Re: [PATCH v4 3/3] omap3isp: Configure CSI-2 phy based on platform data
Date: Thu, 11 Oct 2012 01:34:30 +0200
Message-ID: <2856409.8kZuhLNs9q@avalon>
In-Reply-To: <1349899302-9041-3-git-send-email-sakari.ailus@iki.fi>
References: <20121010200115.GO14107@valkosipuli.retiisi.org.uk> <1349899302-9041-3-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Wednesday 10 October 2012 23:01:42 Sakari Ailus wrote:
> Configure CSI-2 phy based on platform data in the ISP driver. For that, the
> new V4L2_CID_IMAGE_SOURCE_PIXEL_RATE control is used. Previously the same
> was configured from the board code.
> 
> This patch is dependent on "omap3: Provide means for changing CSI2 PHY
> configuration".

Is it still ?

> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/platform/omap3isp/isp.h       |    3 -
>  drivers/media/platform/omap3isp/ispcsiphy.c |  148 ++++++++++++------------
>  drivers/media/platform/omap3isp/ispcsiphy.h |   10 --
>  3 files changed, 78 insertions(+), 83 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.h
> b/drivers/media/platform/omap3isp/isp.h index 6fed222..accb3b0 100644
> --- a/drivers/media/platform/omap3isp/isp.h
> +++ b/drivers/media/platform/omap3isp/isp.h
> @@ -129,9 +129,6 @@ struct isp_reg {
> 
>  struct isp_platform_callback {
>  	u32 (*set_xclk)(struct isp_device *isp, u32 xclk, u8 xclksel);
> -	int (*csiphy_config)(struct isp_csiphy *phy,
> -			     struct isp_csiphy_dphy_cfg *dphy,
> -			     struct isp_csiphy_lanes_cfg *lanes);
>  };
> 
>  /*
> diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c
> b/drivers/media/platform/omap3isp/ispcsiphy.c index 12ae394..754d7a1 100644
> --- a/drivers/media/platform/omap3isp/ispcsiphy.c
> +++ b/drivers/media/platform/omap3isp/ispcsiphy.c
> @@ -125,36 +125,6 @@ static void csiphy_routing_cfg(struct isp_csiphy *phy,
> u32 iface, bool on, }
> 
>  /*
> - * csiphy_lanes_config - Configuration of CSIPHY lanes.
> - *
> - * Updates HW configuration.
> - * Called with phy->mutex taken.
> - */
> -static void csiphy_lanes_config(struct isp_csiphy *phy)
> -{
> -	unsigned int i;
> -	u32 reg;
> -
> -	reg = isp_reg_readl(phy->isp, phy->cfg_regs, ISPCSI2_PHY_CFG);
> -
> -	for (i = 0; i < phy->num_data_lanes; i++) {
> -		reg &= ~(ISPCSI2_PHY_CFG_DATA_POL_MASK(i + 1) |
> -			 ISPCSI2_PHY_CFG_DATA_POSITION_MASK(i + 1));
> -		reg |= (phy->lanes.data[i].pol <<
> -			ISPCSI2_PHY_CFG_DATA_POL_SHIFT(i + 1));
> -		reg |= (phy->lanes.data[i].pos <<
> -			ISPCSI2_PHY_CFG_DATA_POSITION_SHIFT(i + 1));
> -	}
> -
> -	reg &= ~(ISPCSI2_PHY_CFG_CLOCK_POL_MASK |
> -		 ISPCSI2_PHY_CFG_CLOCK_POSITION_MASK);
> -	reg |= phy->lanes.clk.pol << ISPCSI2_PHY_CFG_CLOCK_POL_SHIFT;
> -	reg |= phy->lanes.clk.pos << ISPCSI2_PHY_CFG_CLOCK_POSITION_SHIFT;
> -
> -	isp_reg_writel(phy->isp, reg, phy->cfg_regs, ISPCSI2_PHY_CFG);
> -}
> -
> -/*
>   * csiphy_power_autoswitch_enable
>   * @enable: Sets or clears the autoswitch function enable flag.
>   */
> @@ -199,43 +169,28 @@ static int csiphy_set_power(struct isp_csiphy *phy,
> u32 power) }
> 
>  /*
> - * csiphy_dphy_config - Configure CSI2 D-PHY parameters.
> - *
> - * Called with phy->mutex taken.
> + * TCLK values are OK at their reset values
>   */
> -static void csiphy_dphy_config(struct isp_csiphy *phy)
> -{
> -	u32 reg;
> -
> -	/* Set up ISPCSIPHY_REG0 */
> -	reg = isp_reg_readl(phy->isp, phy->phy_regs, ISPCSIPHY_REG0);
> -
> -	reg &= ~(ISPCSIPHY_REG0_THS_TERM_MASK |
> -		 ISPCSIPHY_REG0_THS_SETTLE_MASK);
> -	reg |= phy->dphy.ths_term << ISPCSIPHY_REG0_THS_TERM_SHIFT;
> -	reg |= phy->dphy.ths_settle << ISPCSIPHY_REG0_THS_SETTLE_SHIFT;
> -
> -	isp_reg_writel(phy->isp, reg, phy->phy_regs, ISPCSIPHY_REG0);
> -
> -	/* Set up ISPCSIPHY_REG1 */
> -	reg = isp_reg_readl(phy->isp, phy->phy_regs, ISPCSIPHY_REG1);
> -
> -	reg &= ~(ISPCSIPHY_REG1_TCLK_TERM_MASK |
> -		 ISPCSIPHY_REG1_TCLK_MISS_MASK |
> -		 ISPCSIPHY_REG1_TCLK_SETTLE_MASK);
> -	reg |= phy->dphy.tclk_term << ISPCSIPHY_REG1_TCLK_TERM_SHIFT;
> -	reg |= phy->dphy.tclk_miss << ISPCSIPHY_REG1_TCLK_MISS_SHIFT;
> -	reg |= phy->dphy.tclk_settle << ISPCSIPHY_REG1_TCLK_SETTLE_SHIFT;
> +#define TCLK_TERM	0
> +#define TCLK_MISS	1
> +#define TCLK_SETTLE	14
> 
> -	isp_reg_writel(phy->isp, reg, phy->phy_regs, ISPCSIPHY_REG1);
> -}
> -
> -static int csiphy_config(struct isp_csiphy *phy,
> -			 struct isp_csiphy_dphy_cfg *dphy,
> -			 struct isp_csiphy_lanes_cfg *lanes)
> +static int omap3isp_csiphy_config(struct isp_csiphy *phy)
>  {
> +	struct isp_csi2_device *csi2 = phy->csi2;
> +	struct isp_pipeline *pipe = to_isp_pipeline(&csi2->subdev.entity);
> +	struct isp_v4l2_subdevs_group *subdevs = pipe->external->host_priv;
> +	struct isp_csiphy_lanes_cfg *lanes;
> +	int csi2_ddrclk_khz;
>  	unsigned int used_lanes = 0;
>  	unsigned int i;
> +	u32 reg;
> +
> +	if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY1
> +	    || subdevs->interface == ISP_INTERFACE_CCP2B_PHY2)
> +		lanes = &subdevs->bus.ccp2.lanecfg;
> +	else
> +		lanes = &subdevs->bus.csi2.lanecfg;
> 
>  	/* Clock and data lanes verification */
>  	for (i = 0; i < phy->num_data_lanes; i++) {
> @@ -254,10 +209,56 @@ static int csiphy_config(struct isp_csiphy *phy,
>  	if (lanes->clk.pos == 0 || used_lanes & (1 << lanes->clk.pos))
>  		return -EINVAL;
> 
> -	mutex_lock(&phy->mutex);
> -	phy->dphy = *dphy;
> -	phy->lanes = *lanes;
> -	mutex_unlock(&phy->mutex);
> +	csiphy_routing_cfg(phy, subdevs->interface, true,
> +			   subdevs->bus.ccp2.phy_layer);
> +
> +	/* DPHY timing configuration */
> +	/* CSI-2 is DDR and we only count used lanes. */
> +	csi2_ddrclk_khz = pipe->external_rate / 1000
> +		/ (2 * hweight32(used_lanes)) * pipe->external_width;
> +
> +	reg = isp_reg_readl(csi2->isp, phy->phy_regs, ISPCSIPHY_REG0);
> +
> +	reg &= ~(ISPCSIPHY_REG0_THS_TERM_MASK |
> +		 ISPCSIPHY_REG0_THS_SETTLE_MASK);
> +	/* THS_TERM: Programmed value = ceil(12.5 ns/DDRClk period) - 1. */
> +	reg |= (DIV_ROUND_UP(25 * csi2_ddrclk_khz, 2000000) - 1)
> +		<< ISPCSIPHY_REG0_THS_TERM_SHIFT;
> +	/* THS_SETTLE: Programmed value = ceil(90 ns/DDRClk period) + 3. */
> +	reg |= (DIV_ROUND_UP(90 * csi2_ddrclk_khz, 1000000) + 3)
> +		<< ISPCSIPHY_REG0_THS_SETTLE_SHIFT;
> +
> +	isp_reg_writel(csi2->isp, reg, phy->phy_regs, ISPCSIPHY_REG0);
> +
> +	reg = isp_reg_readl(csi2->isp, phy->phy_regs, ISPCSIPHY_REG1);
> +
> +	reg &= ~(ISPCSIPHY_REG1_TCLK_TERM_MASK |
> +		 ISPCSIPHY_REG1_TCLK_MISS_MASK |
> +		 ISPCSIPHY_REG1_TCLK_SETTLE_MASK);
> +	reg |= TCLK_TERM << ISPCSIPHY_REG1_TCLK_TERM_SHIFT;
> +	reg |= TCLK_MISS << ISPCSIPHY_REG1_TCLK_MISS_SHIFT;
> +	reg |= TCLK_SETTLE << ISPCSIPHY_REG1_TCLK_SETTLE_SHIFT;
> +
> +	isp_reg_writel(csi2->isp, reg, phy->phy_regs, ISPCSIPHY_REG1);
> +
> +	/* DPHY lane configuration */
> +	reg = isp_reg_readl(csi2->isp, phy->cfg_regs, ISPCSI2_PHY_CFG);
> +
> +	for (i = 0; i < phy->num_data_lanes; i++) {
> +		reg &= ~(ISPCSI2_PHY_CFG_DATA_POL_MASK(i + 1) |
> +			 ISPCSI2_PHY_CFG_DATA_POSITION_MASK(i + 1));
> +		reg |= (lanes->data[i].pol <<
> +			ISPCSI2_PHY_CFG_DATA_POL_SHIFT(i + 1));
> +		reg |= (lanes->data[i].pos <<
> +			ISPCSI2_PHY_CFG_DATA_POSITION_SHIFT(i + 1));
> +	}
> +
> +	reg &= ~(ISPCSI2_PHY_CFG_CLOCK_POL_MASK |
> +		 ISPCSI2_PHY_CFG_CLOCK_POSITION_MASK);
> +	reg |= lanes->clk.pol << ISPCSI2_PHY_CFG_CLOCK_POL_SHIFT;
> +	reg |= lanes->clk.pos << ISPCSI2_PHY_CFG_CLOCK_POSITION_SHIFT;
> +
> +	isp_reg_writel(csi2->isp, reg, phy->cfg_regs, ISPCSI2_PHY_CFG);
> 
>  	return 0;
>  }
> @@ -282,8 +283,9 @@ int omap3isp_csiphy_acquire(struct isp_csiphy *phy)
>  	if (rval < 0)
>  		goto done;
> 
> -	csiphy_dphy_config(phy);
> -	csiphy_lanes_config(phy);
> +	rval = omap3isp_csiphy_config(phy);
> +	if (rval < 0)
> +		goto done;
> 
>  	rval = csiphy_set_power(phy, ISPCSI2_PHY_CFG_PWR_CMD_ON);
>  	if (rval) {
> @@ -303,6 +305,14 @@ void omap3isp_csiphy_release(struct isp_csiphy *phy)
>  {
>  	mutex_lock(&phy->mutex);
>  	if (phy->phy_in_use) {
> +		struct isp_csi2_device *csi2 = phy->csi2;
> +		struct isp_pipeline *pipe =
> +			to_isp_pipeline(&csi2->subdev.entity);
> +		struct isp_v4l2_subdevs_group *subdevs =
> +			pipe->external->host_priv;
> +
> +		csiphy_routing_cfg(phy, subdevs->interface, false,
> +				   subdevs->bus.ccp2.phy_layer);
>  		csiphy_power_autoswitch_enable(phy, false);
>  		csiphy_set_power(phy, ISPCSI2_PHY_CFG_PWR_CMD_OFF);
>  		regulator_disable(phy->vdd);
> @@ -319,8 +329,6 @@ int omap3isp_csiphy_init(struct isp_device *isp)
>  	struct isp_csiphy *phy1 = &isp->isp_csiphy1;
>  	struct isp_csiphy *phy2 = &isp->isp_csiphy2;
> 
> -	isp->platform_cb.csiphy_config = csiphy_config;
> -
>  	phy2->isp = isp;
>  	phy2->csi2 = &isp->isp_csi2a;
>  	phy2->num_data_lanes = ISP_CSIPHY2_NUM_DATA_LANES;
> diff --git a/drivers/media/platform/omap3isp/ispcsiphy.h
> b/drivers/media/platform/omap3isp/ispcsiphy.h index e93a661..14551fd 100644
> --- a/drivers/media/platform/omap3isp/ispcsiphy.h
> +++ b/drivers/media/platform/omap3isp/ispcsiphy.h
> @@ -32,14 +32,6 @@
>  struct isp_csi2_device;
>  struct regulator;
> 
> -struct isp_csiphy_dphy_cfg {
> -	u8 ths_term;
> -	u8 ths_settle;
> -	u8 tclk_term;
> -	unsigned tclk_miss:1;
> -	u8 tclk_settle;
> -};
> -
>  struct isp_csiphy {
>  	struct isp_device *isp;
>  	struct mutex mutex;	/* serialize csiphy configuration */
> @@ -52,8 +44,6 @@ struct isp_csiphy {
>  	unsigned int phy_regs;
> 
>  	u8 num_data_lanes;	/* number of CSI2 Data Lanes supported */
> -	struct isp_csiphy_lanes_cfg lanes;
> -	struct isp_csiphy_dphy_cfg dphy;
>  };
> 
>  int omap3isp_csiphy_acquire(struct isp_csiphy *phy);

-- 
Regards,

Laurent Pinchart

