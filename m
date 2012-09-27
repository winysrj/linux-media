Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42292 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab2I0JUL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 05:20:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: paul@pwsan.com, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 1/2] omap3: Provide means for changing CSI2 PHY configuration
Date: Thu, 27 Sep 2012 11:20:48 +0200
Message-ID: <2067951.ZTSQvUdPug@avalon>
In-Reply-To: <1348696236-3470-1-git-send-email-sakari.ailus@iki.fi>
References: <20120926215001.GA14107@valkosipuli.retiisi.org.uk> <1348696236-3470-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Thursday 27 September 2012 00:50:35 Sakari Ailus wrote:
> The OMAP 3630 has configuration how the ISP CSI-2 PHY pins are connected to
> the actual CSI-2 receivers outside the ISP itself. Allow changing this
> configuration from the ISP driver.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Just one small comment below, otherwise

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  arch/arm/mach-omap2/control.c              |   86 +++++++++++++++++++++++++
>  arch/arm/mach-omap2/control.h              |   15 +++++
>  arch/arm/mach-omap2/include/mach/control.h |   13 ++++
>  3 files changed, 114 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-omap2/include/mach/control.h
> 
> diff --git a/arch/arm/mach-omap2/control.c b/arch/arm/mach-omap2/control.c
> index 3223b81..11bb900 100644
> --- a/arch/arm/mach-omap2/control.c
> +++ b/arch/arm/mach-omap2/control.c
> @@ -12,9 +12,12 @@
>   */
>  #undef DEBUG
> 
> +#include <linux/export.h>
>  #include <linux/kernel.h>
>  #include <linux/io.h>
> 
> +#include <mach/control.h>
> +
>  #include <plat/hardware.h>
>  #include <plat/sdrc.h>
> 
> @@ -607,4 +610,87 @@ int omap3_ctrl_save_padconf(void)
>  	return 0;
>  }
> 
> +static int omap3630_ctrl_csi2_phy_cfg(u32 phy, u32 flags)
> +{
> +	u32 cam_phy_ctrl =
> +		omap_ctrl_readl(OMAP3630_CONTROL_CAMERA_PHY_CTRL);
> +	u32 shift, mode;
> +
> +	switch (phy) {
> +	case OMAP3_CTRL_CSI2_PHY1_CCP2B:
> +		cam_phy_ctrl &= ~OMAP3630_CONTROL_CAMERA_PHY_CTRL_CSI1_RX_SEL_PHY2;
> +		shift = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_PHY1_SHIFT;
> +		break;
> +	case OMAP3_CTRL_CSI2_PHY1_CSI2C:
> +		shift = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_PHY1_SHIFT;
> +		mode = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_DPHY;
> +		break;
> +	case OMAP3_CTRL_CSI2_PHY2_CCP2B:
> +		cam_phy_ctrl |= OMAP3630_CONTROL_CAMERA_PHY_CTRL_CSI1_RX_SEL_PHY2;
> +		shift = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_PHY2_SHIFT;
> +		break;
> +	case OMAP3_CTRL_CSI2_PHY2_CSI2A:
> +		shift = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_PHY2_SHIFT;
> +		mode = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_DPHY;
> +		break;
> +	default:
> +		pr_warn("bad phy %d\n", phy);
> +		return -EINVAL;
> +	}
> +
> +	/* Select data/clock or data/strobe mode for CCP2 */
> +	switch (phy) {
> +	case OMAP3_CTRL_CSI2_PHY1_CCP2B:
> +	case OMAP3_CTRL_CSI2_PHY2_CCP2B:
> +		if (flags & OMAP3_CTRL_CSI2_CFG_CCP2_DATA_STROBE)
> +			mode = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_CCP2_DATA_STROBE;
> +		else
> +			mode = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_CCP2_DATA_CLOCK;
> +		break;
> +	}
> +
> +	cam_phy_ctrl &= ~(OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_MASK << 
shift);
> +	cam_phy_ctrl |= mode << shift;
> +
> +	omap_ctrl_writel(cam_phy_ctrl,
> +			 OMAP3630_CONTROL_CAMERA_PHY_CTRL);

This can fit on one line.

> +
> +	return 0;
> +}
> +
> +static int omap3430_ctrl_csi2_phy_cfg(u32 phy, bool on, u32 flags)
> +{
> +	uint32_t csirxfe = OMAP343X_CONTROL_CSIRXFE_PWRDNZ
> +		| OMAP343X_CONTROL_CSIRXFE_RESET;
> +
> +	/* Nothing to configure here. */
> +	if (phy == OMAP3_CTRL_CSI2_PHY2_CSI2A)
> +		return 0;
> +
> +	if (phy != OMAP3_CTRL_CSI2_PHY1_CCP2B)
> +		return -EINVAL;
> +
> +	if (!on) {
> +		omap_ctrl_writel(0, OMAP343X_CONTROL_CSIRXFE);
> +		return 0;
> +	}
> +
> +	if (flags & OMAP3_CTRL_CSI2_CFG_CCP2_DATA_STROBE)
> +		csirxfe |= OMAP343X_CONTROL_CSIRXFE_SELFORM;
> +
> +	omap_ctrl_writel(csirxfe, OMAP343X_CONTROL_CSIRXFE);
> +
> +	return 0;
> +}
> +
> +int omap3_ctrl_csi2_phy_cfg(u32 phy, bool on, u32 flags)
> +{
> +	if (cpu_is_omap3630() && on)
> +		return omap3630_ctrl_csi2_phy_cfg(phy, flags);
> +	if (cpu_is_omap3430())
> +		return omap3430_ctrl_csi2_phy_cfg(phy, on, flags);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(omap3_ctrl_csi2_phy_cfg);
> +
>  #endif /* CONFIG_ARCH_OMAP3 && CONFIG_PM */
> diff --git a/arch/arm/mach-omap2/control.h b/arch/arm/mach-omap2/control.h
> index b8cdc85..7b2ee5d 100644
> --- a/arch/arm/mach-omap2/control.h
> +++ b/arch/arm/mach-omap2/control.h
> @@ -132,6 +132,11 @@
>  #define OMAP343X_CONTROL_MEM_DFTRW1	(OMAP2_CONTROL_GENERAL + 0x000c)
>  #define OMAP343X_CONTROL_DEVCONF1	(OMAP2_CONTROL_GENERAL + 0x0068)
>  #define OMAP343X_CONTROL_CSIRXFE		(OMAP2_CONTROL_GENERAL + 0x006c)
> +#define OMAP343X_CONTROL_CSIRXFE_CSIB_INV	(1 << 7)
> +#define OMAP343X_CONTROL_CSIRXFE_RESENABLE	(1 << 8)
> +#define OMAP343X_CONTROL_CSIRXFE_SELFORM	(1 << 10)
> +#define OMAP343X_CONTROL_CSIRXFE_PWRDNZ		(1 << 12)
> +#define OMAP343X_CONTROL_CSIRXFE_RESET		(1 << 13)
>  #define OMAP343X_CONTROL_SEC_STATUS		(OMAP2_CONTROL_GENERAL + 0x0070)
>  #define OMAP343X_CONTROL_SEC_ERR_STATUS		(OMAP2_CONTROL_GENERAL + 
0x0074)
>  #define OMAP343X_CONTROL_SEC_ERR_STATUS_DEBUG	(OMAP2_CONTROL_GENERAL +
> 0x0078)

-- 
Regards,

Laurent Pinchart

