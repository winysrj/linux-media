Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:32971 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab2A3NoJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jan 2012 08:44:09 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2 1/1] omap3isp: Prevent crash at module unload
Date: Mon, 30 Jan 2012 14:44:24 +0100
Cc: linux-media@vger.kernel.org
References: <1327659531-1547-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1327659531-1547-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201301444.26029.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Friday 27 January 2012 11:18:51 Sakari Ailus wrote:
> iommu_domain_free() was called in isp_remove() before omap3isp_put().
> omap3isp_put() must not save the context if the IOMMU no longer is there.
> Fix this.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Applied to my tree.

> ---
> Compared to v1, neither the ISP context is saved.
> 
>  drivers/media/video/omap3isp/isp.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/isp.c
> b/drivers/media/video/omap3isp/isp.c index 12d5f92..d4e0905 100644
> --- a/drivers/media/video/omap3isp/isp.c
> +++ b/drivers/media/video/omap3isp/isp.c
> @@ -1495,7 +1495,8 @@ void omap3isp_put(struct isp_device *isp)
>  	BUG_ON(isp->ref_count == 0);
>  	if (--isp->ref_count == 0) {
>  		isp_disable_interrupts(isp);
> -		isp_save_ctx(isp);
> +		if (isp->domain)
> +			isp_save_ctx(isp);
>  		if (isp->needs_reset) {
>  			isp_reset(isp);
>  			isp->needs_reset = false;
> @@ -1981,6 +1982,7 @@ static int isp_remove(struct platform_device *pdev)
>  	omap3isp_get(isp);
>  	iommu_detach_device(isp->domain, &pdev->dev);
>  	iommu_domain_free(isp->domain);
> +	isp->domain = NULL;
>  	omap3isp_put(isp);
> 
>  	free_irq(isp->irq_num, isp);

-- 
Regards,

Laurent Pinchart
