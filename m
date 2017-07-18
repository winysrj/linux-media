Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56424 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751322AbdGRJAM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 05:00:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: pavel@ucw.cz, linux-media@vger.kernel.org
Subject: Re: [PATCH 7/7] omap3isp: Skip CSI-2 receiver initialisation in CCP2 configuration
Date: Tue, 18 Jul 2017 11:54:21 +0300
Message-ID: <1967838.Hno52fQ337@avalon>
In-Reply-To: <20170717220116.17886-8-sakari.ailus@linux.intel.com>
References: <20170717220116.17886-1-sakari.ailus@linux.intel.com> <20170717220116.17886-8-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Tuesday 18 Jul 2017 01:01:16 Sakari Ailus wrote:
> If the CSI-2 receiver isn't part of the pipeline (or isn't there to begin
> with), skip its initialisation.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/platform/omap3isp/ispcsiphy.c | 41 +++++++++++++++++---------
>  1 file changed, 28 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c
> b/drivers/media/platform/omap3isp/ispcsiphy.c index
> 2028bb519108..bb2906061884 100644
> --- a/drivers/media/platform/omap3isp/ispcsiphy.c
> +++ b/drivers/media/platform/omap3isp/ispcsiphy.c
> @@ -155,6 +155,19 @@ static int csiphy_set_power(struct isp_csiphy *phy, u32
> power) return 0;
>  }
> 
> +static struct isp_pipeline *phy_to_isp_pipeline(struct isp_csiphy *phy)
> +{
> +	if (phy->csi2 && phy->csi2->subdev.entity.pipe)
> +		return to_isp_pipeline(&phy->csi2->subdev.entity);
> +
> +	if (phy->isp->isp_ccp2.subdev.entity.pipe)
> +		return to_isp_pipeline(&phy->isp->isp_ccp2.subdev.entity);
> +
> +	__WARN();
> +
> +	return NULL;

If you changed the phy->csi2 pointer from a isp_csi2_device to a v4l2_subdev 
or media_entity (and renamed it accordingly, to something like "receiver" for 
instance, ideas for a better name are welcome) you could store a pointer to 
the appropriate CSI2 or CCP2 receiver and simplify this function, or even 
inline it as it is currently, calling to_isp_pipeline(phy->receiver). I think 
that would simplify the driver.

> +}
> +
>  /*
>   * TCLK values are OK at their reset values
>   */
> @@ -164,15 +177,18 @@ static int csiphy_set_power(struct isp_csiphy *phy,
> u32 power)
> 
>  static int omap3isp_csiphy_config(struct isp_csiphy *phy)
>  {
> -	struct isp_csi2_device *csi2 = phy->csi2;
> -	struct isp_pipeline *pipe = to_isp_pipeline(&csi2->subdev.entity);
> -	struct isp_bus_cfg *buscfg = pipe->external->host_priv;
> +	struct isp_pipeline *pipe = phy_to_isp_pipeline(phy);
> +	struct isp_bus_cfg *buscfg;
>  	struct isp_csiphy_lanes_cfg *lanes;
>  	int csi2_ddrclk_khz;
>  	unsigned int num_data_lanes, used_lanes = 0;
>  	unsigned int i;
>  	u32 reg;
> 
> +	if (!pipe)
> +		return -EBUSY;
> +
> +	buscfg = pipe->external->host_priv;
>  	if (!buscfg) {
>  		struct isp_async_subdev *isd =
>  			container_of(pipe->external->asd,
> @@ -222,7 +238,7 @@ static int omap3isp_csiphy_config(struct isp_csiphy
> *phy) csi2_ddrclk_khz = pipe->external_rate / 1000
>  		/ (2 * hweight32(used_lanes)) * pipe->external_width;
> 
> -	reg = isp_reg_readl(csi2->isp, phy->phy_regs, ISPCSIPHY_REG0);
> +	reg = isp_reg_readl(phy->isp, phy->phy_regs, ISPCSIPHY_REG0);
> 
>  	reg &= ~(ISPCSIPHY_REG0_THS_TERM_MASK |
>  		 ISPCSIPHY_REG0_THS_SETTLE_MASK);
> @@ -233,9 +249,9 @@ static int omap3isp_csiphy_config(struct isp_csiphy
> *phy) reg |= (DIV_ROUND_UP(90 * csi2_ddrclk_khz, 1000000) + 3)
>  		<< ISPCSIPHY_REG0_THS_SETTLE_SHIFT;
> 
> -	isp_reg_writel(csi2->isp, reg, phy->phy_regs, ISPCSIPHY_REG0);
> +	isp_reg_writel(phy->isp, reg, phy->phy_regs, ISPCSIPHY_REG0);
> 
> -	reg = isp_reg_readl(csi2->isp, phy->phy_regs, ISPCSIPHY_REG1);
> +	reg = isp_reg_readl(phy->isp, phy->phy_regs, ISPCSIPHY_REG1);
> 
>  	reg &= ~(ISPCSIPHY_REG1_TCLK_TERM_MASK |
>  		 ISPCSIPHY_REG1_TCLK_MISS_MASK |
> @@ -244,10 +260,10 @@ static int omap3isp_csiphy_config(struct isp_csiphy
> *phy) reg |= TCLK_MISS << ISPCSIPHY_REG1_TCLK_MISS_SHIFT;
>  	reg |= TCLK_SETTLE << ISPCSIPHY_REG1_TCLK_SETTLE_SHIFT;
> 
> -	isp_reg_writel(csi2->isp, reg, phy->phy_regs, ISPCSIPHY_REG1);
> +	isp_reg_writel(phy->isp, reg, phy->phy_regs, ISPCSIPHY_REG1);
> 
>  	/* DPHY lane configuration */
> -	reg = isp_reg_readl(csi2->isp, phy->cfg_regs, ISPCSI2_PHY_CFG);
> +	reg = isp_reg_readl(phy->isp, phy->cfg_regs, ISPCSI2_PHY_CFG);
> 
>  	for (i = 0; i < num_data_lanes; i++) {
>  		reg &= ~(ISPCSI2_PHY_CFG_DATA_POL_MASK(i + 1) |
> @@ -263,7 +279,7 @@ static int omap3isp_csiphy_config(struct isp_csiphy
> *phy) reg |= lanes->clk.pol << ISPCSI2_PHY_CFG_CLOCK_POL_SHIFT;
>  	reg |= lanes->clk.pos << ISPCSI2_PHY_CFG_CLOCK_POSITION_SHIFT;
> 
> -	isp_reg_writel(csi2->isp, reg, phy->cfg_regs, ISPCSI2_PHY_CFG);
> +	isp_reg_writel(phy->isp, reg, phy->cfg_regs, ISPCSI2_PHY_CFG);
> 
>  	return 0;
>  }
> @@ -311,11 +327,10 @@ int omap3isp_csiphy_acquire(struct isp_csiphy *phy)
> 
>  void omap3isp_csiphy_release(struct isp_csiphy *phy)
>  {
> +	struct isp_pipeline *pipe = phy_to_isp_pipeline(phy);
> +
>  	mutex_lock(&phy->mutex);
> -	if (phy->phy_in_use) {
> -		struct isp_csi2_device *csi2 = phy->csi2;
> -		struct isp_pipeline *pipe =
> -			to_isp_pipeline(&csi2->subdev.entity);
> +	if (phy->phy_in_use && pipe) {
>  		struct isp_bus_cfg *buscfg = pipe->external->host_priv;
> 
>  		csiphy_routing_cfg(phy, buscfg->interface, false,

-- 
Regards,

Laurent Pinchart
