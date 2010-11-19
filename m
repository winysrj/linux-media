Return-path: <mchehab@gaivota>
Received: from smtp.nokia.com ([147.243.128.26]:53548 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab0KSKRG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 05:17:06 -0500
Date: Fri, 19 Nov 2010 12:18:03 +0200
From: David Cohen <david.cohen@nokia.com>
To: ext Sergio Aguirre <saaguirre@ti.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [omap3isp][PATCH v2 7/9] omap3isp: Cleanup isp_power_settings
Message-ID: <20101119101802.GB13490@esdhcp04381.research.nokia.com>
References: <1289831401-593-1-git-send-email-saaguirre@ti.com>
 <1289831401-593-8-git-send-email-saaguirre@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289831401-593-8-git-send-email-saaguirre@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Sergio,

Thanks for the patch.

On Mon, Nov 15, 2010 at 03:29:59PM +0100, ext Sergio Aguirre wrote:
> 1. Get rid of CSI2 / CCP2 power settings, as they are controlled
>    in the receivers code anyways.

CCP2 is not correctly handling this. It's setting SMART STANDBY mode one
when reading from memory. You should fix it before remove such code from
ISP core driver.

> 2. Avoid code duplication.

Agree. But only after considering the comment above.

Regards,

David

> 
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  drivers/media/video/isp/isp.c |   49 ++++++-----------------------------------
>  1 files changed, 7 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/media/video/isp/isp.c b/drivers/media/video/isp/isp.c
> index de9352b..30bdc48 100644
> --- a/drivers/media/video/isp/isp.c
> +++ b/drivers/media/video/isp/isp.c
> @@ -254,48 +254,13 @@ EXPORT_SYMBOL(isp_set_xclk);
>   */
>  static void isp_power_settings(struct isp_device *isp, int idle)
>  {
> -	if (idle) {
> -		isp_reg_writel(isp,
> -			       (ISP_SYSCONFIG_MIDLEMODE_SMARTSTANDBY <<
> -				ISP_SYSCONFIG_MIDLEMODE_SHIFT),
> -			       OMAP3_ISP_IOMEM_MAIN, ISP_SYSCONFIG);
> -		if (omap_rev() == OMAP3430_REV_ES1_0) {
> -			isp_reg_writel(isp, ISPCSI1_AUTOIDLE |
> -				       (ISPCSI1_MIDLEMODE_SMARTSTANDBY <<
> -					ISPCSI1_MIDLEMODE_SHIFT),
> -				       OMAP3_ISP_IOMEM_CSI2A_REGS1,
> -				       ISPCSI2_SYSCONFIG);
> -			isp_reg_writel(isp, ISPCSI1_AUTOIDLE |
> -				       (ISPCSI1_MIDLEMODE_SMARTSTANDBY <<
> -					ISPCSI1_MIDLEMODE_SHIFT),
> -				       OMAP3_ISP_IOMEM_CCP2,
> -				       ISPCCP2_SYSCONFIG);
> -		}
> -		isp_reg_writel(isp, ISPCTRL_SBL_AUTOIDLE, OMAP3_ISP_IOMEM_MAIN,
> -			       ISP_CTRL);
> -
> -	} else {
> -		isp_reg_writel(isp,
> -			       (ISP_SYSCONFIG_MIDLEMODE_FORCESTANDBY <<
> -				ISP_SYSCONFIG_MIDLEMODE_SHIFT),
> -			       OMAP3_ISP_IOMEM_MAIN, ISP_SYSCONFIG);
> -		if (omap_rev() == OMAP3430_REV_ES1_0) {
> -			isp_reg_writel(isp, ISPCSI1_AUTOIDLE |
> -				       (ISPCSI1_MIDLEMODE_FORCESTANDBY <<
> -					ISPCSI1_MIDLEMODE_SHIFT),
> -				       OMAP3_ISP_IOMEM_CSI2A_REGS1,
> -				       ISPCSI2_SYSCONFIG);
> -
> -			isp_reg_writel(isp, ISPCSI1_AUTOIDLE |
> -				       (ISPCSI1_MIDLEMODE_FORCESTANDBY <<
> -					ISPCSI1_MIDLEMODE_SHIFT),
> -				       OMAP3_ISP_IOMEM_CCP2,
> -				       ISPCCP2_SYSCONFIG);
> -		}
> -
> -		isp_reg_writel(isp, ISPCTRL_SBL_AUTOIDLE, OMAP3_ISP_IOMEM_MAIN,
> -			       ISP_CTRL);
> -	}
> +	isp_reg_writel(isp,
> +		       ((idle ? ISP_SYSCONFIG_MIDLEMODE_SMARTSTANDBY :
> +				ISP_SYSCONFIG_MIDLEMODE_FORCESTANDBY) <<
> +			ISP_SYSCONFIG_MIDLEMODE_SHIFT),
> +		       OMAP3_ISP_IOMEM_MAIN, ISP_SYSCONFIG);
> +	isp_reg_writel(isp, ISPCTRL_SBL_AUTOIDLE, OMAP3_ISP_IOMEM_MAIN,
> +		       ISP_CTRL);
>  }
>  
>  /*
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
