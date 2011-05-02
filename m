Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60574 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061Ab1EBNsX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 May 2011 09:48:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
Subject: Re: [PATCH v2 1/2] OMAP3: ISP: Add regulator control for omap34xx
Date: Mon, 2 May 2011 15:48:41 +0200
Cc: maurochehab@gmail.com, tony@atomide.com,
	linux-omap@vger.kernel.org, linux-media@vger.kernel.org
References: <1304327777-31231-1-git-send-email-kalle.jokiniemi@nokia.com> <1304327777-31231-2-git-send-email-kalle.jokiniemi@nokia.com>
In-Reply-To: <1304327777-31231-2-git-send-email-kalle.jokiniemi@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105021548.43076.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Kalle,

Thanks for the patch.

On Monday 02 May 2011 11:16:16 Kalle Jokiniemi wrote:
> The current omap3isp driver is missing regulator handling
> for CSIb complex in omap34xx based devices. This patch
> adds a mechanism for this to the omap3isp driver.
> 
> Signed-off-by: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/video/omap3isp/ispccp2.c |   27 +++++++++++++++++++++++++--
>  drivers/media/video/omap3isp/ispccp2.h |    1 +
>  2 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispccp2.c
> b/drivers/media/video/omap3isp/ispccp2.c index 0e16cab..ec9e395 100644
> --- a/drivers/media/video/omap3isp/ispccp2.c
> +++ b/drivers/media/video/omap3isp/ispccp2.c
> @@ -30,6 +30,7 @@
>  #include <linux/module.h>
>  #include <linux/mutex.h>
>  #include <linux/uaccess.h>
> +#include <linux/regulator/consumer.h>
> 
>  #include "isp.h"
>  #include "ispreg.h"
> @@ -163,6 +164,9 @@ static void ccp2_if_enable(struct isp_ccp2_device
> *ccp2, u8 enable) struct isp_pipeline *pipe =
> to_isp_pipeline(&ccp2->subdev.entity); int i;
> 
> +	if (enable && ccp2->vdds_csib)
> +		regulator_enable(ccp2->vdds_csib);
> +
>  	/* Enable/Disable all the LCx channels */
>  	for (i = 0; i < CCP2_LCx_CHANS_NUM; i++)
>  		isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_LCx_CTRL(i),
> @@ -186,6 +190,9 @@ static void ccp2_if_enable(struct isp_ccp2_device
> *ccp2, u8 enable) ISPCCP2_LC01_IRQENABLE,
>  				    ISPCCP2_LC01_IRQSTATUS_LC0_FS_IRQ);
>  	}
> +
> +	if (!enable && ccp2->vdds_csib)
> +		regulator_disable(ccp2->vdds_csib);
>  }
> 
>  /*
> @@ -1137,6 +1144,9 @@ error:
>   */
>  void omap3isp_ccp2_cleanup(struct isp_device *isp)
>  {
> +	struct isp_ccp2_device *ccp2 = &isp->isp_ccp2;
> +
> +	regulator_put(ccp2->vdds_csib);
>  }
> 
>  /*
> @@ -1151,14 +1161,27 @@ int omap3isp_ccp2_init(struct isp_device *isp)
> 
>  	init_waitqueue_head(&ccp2->wait);
> 
> -	/* On the OMAP36xx, the CCP2 uses the CSI PHY1 or PHY2, shared with
> +	/*
> +	 * On the OMAP34xx the CSI1 receiver is operated in the CSIb IO
> +	 * complex, which is powered by vdds_csib power rail. Hence the
> +	 * request for the regulator.
> +	 *
> +	 * On the OMAP36xx, the CCP2 uses the CSI PHY1 or PHY2, shared with
>  	 * the CSI2c or CSI2a receivers. The PHY then needs to be explicitly
>  	 * configured.
>  	 *
>  	 * TODO: Don't hardcode the usage of PHY1 (shared with CSI2c).
>  	 */
> -	if (isp->revision == ISP_REVISION_15_0)
> +	if (isp->revision == ISP_REVISION_2_0) {
> +		ccp2->vdds_csib = regulator_get(isp->dev, "vdds_csib");
> +		if (IS_ERR(ccp2->vdds_csib)) {
> +			dev_dbg(isp->dev,
> +				"Could not get regulator vdds_csib\n");
> +			ccp2->vdds_csib = NULL;
> +		}
> +	} else if (isp->revision == ISP_REVISION_15_0) {
>  		ccp2->phy = &isp->isp_csiphy1;
> +	}
> 
>  	ret = ccp2_init_entities(ccp2);
>  	if (ret < 0)
> diff --git a/drivers/media/video/omap3isp/ispccp2.h
> b/drivers/media/video/omap3isp/ispccp2.h index 5505a86..6674e9d 100644
> --- a/drivers/media/video/omap3isp/ispccp2.h
> +++ b/drivers/media/video/omap3isp/ispccp2.h
> @@ -81,6 +81,7 @@ struct isp_ccp2_device {
>  	struct isp_interface_mem_config mem_cfg;
>  	struct isp_video video_in;
>  	struct isp_csiphy *phy;
> +	struct regulator *vdds_csib;
>  	unsigned int error;
>  	enum isp_pipeline_stream_state state;
>  	wait_queue_head_t wait;

-- 
Regards,

Laurent Pinchart
