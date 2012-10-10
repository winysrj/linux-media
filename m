Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48744 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab2JJXr3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 19:47:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	tony@atomide.com, khilman@deeprootsystems.com
Subject: Re: [PATCH v4 2/3] omap3isp: Add PHY routing configuration
Date: Thu, 11 Oct 2012 01:48:12 +0200
Message-ID: <2439138.6ymQVbVvlT@avalon>
In-Reply-To: <1349899302-9041-2-git-send-email-sakari.ailus@iki.fi>
References: <20121010200115.GO14107@valkosipuli.retiisi.org.uk> <1349899302-9041-2-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Wednesday 10 October 2012 23:01:41 Sakari Ailus wrote:
> Add PHY routing configuration for both 3430 and 3630. Also add register bit
> definitions of CSIRXFE and CAMERA_PHY_CTRL registers on OMAP 3430 and 3630,
> respectively.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/platform/omap3isp/ispcsiphy.c |   92 ++++++++++++++++++++++++
>  drivers/media/platform/omap3isp/ispreg.h    |   22 +++++++
>  2 files changed, 114 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c
> b/drivers/media/platform/omap3isp/ispcsiphy.c index 348f67e..12ae394 100644
> --- a/drivers/media/platform/omap3isp/ispcsiphy.c
> +++ b/drivers/media/platform/omap3isp/ispcsiphy.c
> @@ -32,6 +32,98 @@
>  #include "ispreg.h"
>  #include "ispcsiphy.h"
> 
> +static void csiphy_routing_cfg_3630(struct isp_csiphy *phy, u32 iface,
> +				    bool ccp2_strobe)
> +{
> +	u32 reg = isp_reg_readl(
> +		phy->isp, OMAP3_ISP_IOMEM_3630_CONTROL_CAMERA_PHY_CTRL, 0);
> +	u32 shift, mode;
> +
> +	switch (iface) {
> +	case ISP_INTERFACE_CCP2B_PHY1:
> +		reg &= ~OMAP3630_CONTROL_CAMERA_PHY_CTRL_CSI1_RX_SEL_PHY2;
> +		shift = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_PHY1_SHIFT;
> +		break;
> +	case ISP_INTERFACE_CSI2C_PHY1:
> +		shift = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_PHY1_SHIFT;
> +		mode = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_DPHY;
> +		break;
> +	case ISP_INTERFACE_CCP2B_PHY2:
> +		reg |= OMAP3630_CONTROL_CAMERA_PHY_CTRL_CSI1_RX_SEL_PHY2;
> +		shift = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_PHY2_SHIFT;
> +		break;
> +	case ISP_INTERFACE_CSI2A_PHY2:
> +		shift = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_PHY2_SHIFT;
> +		mode = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_DPHY;
> +		break;
> +	}
> +
> +	/* Select data/clock or data/strobe mode for CCP2 */
> +	switch (iface) {
> +	case ISP_INTERFACE_CCP2B_PHY1:
> +	case ISP_INTERFACE_CCP2B_PHY2:
> +		if (ccp2_strobe)
> +			mode = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_CCP2_DATA_STROBE;
> +		else
> +			mode = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_CCP2_DATA_CLOCK;
> +	}
> +
> +	reg &= ~(OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_MASK << shift);
> +	reg |= mode << shift;
> +
> +	isp_reg_writel(phy->isp, reg,
> +		       OMAP3_ISP_IOMEM_3630_CONTROL_CAMERA_PHY_CTRL, 0);
> +}
> +
> +static void csiphy_routing_cfg_3430(struct isp_csiphy *phy, u32 iface, bool
> on,
> +				    bool ccp2_strobe)
> +{
> +	uint32_t csirxfe = OMAP343X_CONTROL_CSIRXFE_PWRDNZ
> +		| OMAP343X_CONTROL_CSIRXFE_RESET;

Anything wrong with u32 ? :-)

(I would also align the | with the = but that's nitpicking)

> +
> +	/* Nothing to configure here. */
> +	if (iface == ISP_INTERFACE_CSI2A_PHY2)
> +		return;
> +
> +	if (iface != ISP_INTERFACE_CCP2B_PHY1)
> +		return;

Can't you get rid of the first check ?

> +	if (!on) {
> +		isp_reg_writel(phy->isp, 0,
> +			       OMAP3_ISP_IOMEM_343X_CONTROL_CSIRXFE, 0);
> +		return;
> +	}
> +
> +	if (ccp2_strobe)
> +		csirxfe |= OMAP343X_CONTROL_CSIRXFE_SELFORM;
> +
> +	isp_reg_writel(phy->isp, csirxfe,
> +		       OMAP3_ISP_IOMEM_343X_CONTROL_CSIRXFE, 0);
> +}
> +
> +/**
> + * Configure OMAP 3 CSI PHY routing.
> + *
> + * Note that the underlying routing configuration registers are part
> + * of the control (SCM) register space and part of the CORE power
> + * domain on both 3430 and 3630, so they will not hold their contents
> + * in off-mode.

Could you please add a sentence to explain why that's not an issue ?

> + * @phy: relevant phy device
> + * @iface: ISP_INTERFACE_*
> + * @on: power on or off
> + * @ccp2_strobe: false: data/clock, true: data/strobe
> + */
> +static void csiphy_routing_cfg(struct isp_csiphy *phy, u32 iface, bool on,
> +			       bool ccp2_strobe)
> +{
> +	if (phy->isp->mmio_base[OMAP3_ISP_IOMEM_3630_CONTROL_CAMERA_PHY_CTRL]
> +	    && on)
> +		return csiphy_routing_cfg_3630(phy, iface, ccp2_strobe);
> +	if (phy->isp->mmio_base[OMAP3_ISP_IOMEM_343X_CONTROL_CSIRXFE])
> +		return csiphy_routing_cfg_3430(phy, iface, on, ccp2_strobe);
> +}
> +
>  /*
>   * csiphy_lanes_config - Configuration of CSIPHY lanes.
>   *
> diff --git a/drivers/media/platform/omap3isp/ispreg.h
> b/drivers/media/platform/omap3isp/ispreg.h index e2c57f3..148108b 100644
> --- a/drivers/media/platform/omap3isp/ispreg.h
> +++ b/drivers/media/platform/omap3isp/ispreg.h
> @@ -1583,4 +1583,26 @@
>  #define ISPCSIPHY_REG2_CCP2_SYNC_PATTERN_MASK		\
>  	(0x7fffff << ISPCSIPHY_REG2_CCP2_SYNC_PATTERN_SHIFT)
> 
> +/*
> ---------------------------------------------------------------------------
> -- + * CONTROL registers for CSI-2 phy routing
> + */
> +
> +/* OMAP343X_CONTROL_CSIRXFE */
> +#define OMAP343X_CONTROL_CSIRXFE_CSIB_INV	(1 << 7)
> +#define OMAP343X_CONTROL_CSIRXFE_RESENABLE	(1 << 8)
> +#define OMAP343X_CONTROL_CSIRXFE_SELFORM	(1 << 10)
> +#define OMAP343X_CONTROL_CSIRXFE_PWRDNZ		(1 << 12)
> +#define OMAP343X_CONTROL_CSIRXFE_RESET		(1 << 13)
> +
> +/* OMAP3630_CONTROL_CAMERA_PHY_CTRL */
> +#define OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_PHY1_SHIFT	2
> +#define OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_PHY2_SHIFT	0
> +#define OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_DPHY		0x0
> +#define OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_CCP2_DATA_STROBE 0x1
> +#define OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_CCP2_DATA_CLOCK 0x2
> +#define OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_GPI		0x3
> +#define OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_MASK		0x3
> +/* CCP2B: set to receive data from PHY2 instead of PHY1 */
> +#define OMAP3630_CONTROL_CAMERA_PHY_CTRL_CSI1_RX_SEL_PHY2	(1 << 4)
> +

As the registers addresses are declared in a platform header, do you think it 
would make sense to declare those there as well ? If not I'm fine with keeping 
them here.

>  #endif	/* OMAP3_ISP_REG_H */

-- 
Regards,

Laurent Pinchart

