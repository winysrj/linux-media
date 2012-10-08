Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:34288 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754172Ab2JHWGs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 18:06:48 -0400
Date: Mon, 8 Oct 2012 15:06:46 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v3 1/3] omap3isp: Add CSI configuration registers from
 control block to ISP resources
Message-ID: <20121008220645.GY13011@atomide.com>
References: <20121007200730.GD14107@valkosipuli.retiisi.org.uk>
 <1349640472-1425-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349640472-1425-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Sakari Ailus <sakari.ailus@iki.fi> [121007 13:09]:
> Add the registers used to configure the CSI-2 receiver PHY on OMAP3430 and
> 3630 and map them in the ISP driver. The register is part of the control
> block but it only is needed by the ISP driver.

Just checking.. These do get reserved with request_mem_region()
in isp_map_mem_resource() before they get ioremapped, right?

And camera is the only user for these registers and they are
not shared with anything else?

If so, then this is OK to merge via the media patches:

Acked-by: Tony Lindgren <tony@atomide.com>
 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  arch/arm/mach-omap2/devices.c         |   10 ++++++++++
>  drivers/media/platform/omap3isp/isp.c |    6 ++++--
>  drivers/media/platform/omap3isp/isp.h |    2 ++
>  3 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
> index c00c689..9e4d5da 100644
> --- a/arch/arm/mach-omap2/devices.c
> +++ b/arch/arm/mach-omap2/devices.c
> @@ -201,6 +201,16 @@ static struct resource omap3isp_resources[] = {
>  		.flags		= IORESOURCE_MEM,
>  	},
>  	{
> +		.start		= OMAP343X_CTRL_BASE + OMAP343X_CONTROL_CSIRXFE,
> +		.end		= OMAP343X_CTRL_BASE + OMAP343X_CONTROL_CSIRXFE + 3,
> +		.flags		= IORESOURCE_MEM,
> +	},
> +	{
> +		.start		= OMAP343X_CTRL_BASE + OMAP3630_CONTROL_CAMERA_PHY_CTRL,
> +		.end		= OMAP343X_CTRL_BASE + OMAP3630_CONTROL_CAMERA_PHY_CTRL + 3,
> +		.flags		= IORESOURCE_MEM,
> +	},
> +	{
>  		.start		= INT_34XX_CAM_IRQ,
>  		.flags		= IORESOURCE_IRQ,
>  	}
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index d7aa513..88fba2c 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -100,7 +100,8 @@ static const struct isp_res_mapping isp_res_maps[] = {
>  		       1 << OMAP3_ISP_IOMEM_RESZ |
>  		       1 << OMAP3_ISP_IOMEM_SBL |
>  		       1 << OMAP3_ISP_IOMEM_CSI2A_REGS1 |
> -		       1 << OMAP3_ISP_IOMEM_CSIPHY2,
> +		       1 << OMAP3_ISP_IOMEM_CSIPHY2 |
> +		       1 << OMAP3_ISP_IOMEM_343X_CONTROL_CSIRXFE,
>  	},
>  	{
>  		.isp_rev = ISP_REVISION_15_0,
> @@ -117,7 +118,8 @@ static const struct isp_res_mapping isp_res_maps[] = {
>  		       1 << OMAP3_ISP_IOMEM_CSI2A_REGS2 |
>  		       1 << OMAP3_ISP_IOMEM_CSI2C_REGS1 |
>  		       1 << OMAP3_ISP_IOMEM_CSIPHY1 |
> -		       1 << OMAP3_ISP_IOMEM_CSI2C_REGS2,
> +		       1 << OMAP3_ISP_IOMEM_CSI2C_REGS2 |
> +		       1 << OMAP3_ISP_IOMEM_3630_CONTROL_CAMERA_PHY_CTRL,
>  	},
>  };
>  
> diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
> index 8be7487..6fed222 100644
> --- a/drivers/media/platform/omap3isp/isp.h
> +++ b/drivers/media/platform/omap3isp/isp.h
> @@ -72,6 +72,8 @@ enum isp_mem_resources {
>  	OMAP3_ISP_IOMEM_CSI2C_REGS1,
>  	OMAP3_ISP_IOMEM_CSIPHY1,
>  	OMAP3_ISP_IOMEM_CSI2C_REGS2,
> +	OMAP3_ISP_IOMEM_343X_CONTROL_CSIRXFE,
> +	OMAP3_ISP_IOMEM_3630_CONTROL_CAMERA_PHY_CTRL,
>  	OMAP3_ISP_IOMEM_LAST
>  };
>  
> -- 
> 1.7.2.5
> 
