Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38651 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab2A0Jfu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 04:35:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 1/1] omap3isp: Prevent crash at module unload
Date: Fri, 27 Jan 2012 10:36:02 +0100
Cc: linux-media@vger.kernel.org, ohad@wizery.com
References: <1327655155-6038-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1327655155-6038-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201271036.02588.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Friday 27 January 2012 10:05:55 Sakari Ailus wrote:
> iommu_domain_free() was called in isp_remove() before omap3isp_put().
> omap3isp_put() must not save the context if the IOMMU no longer is there.
> Fix this.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
> The issue only seems to affect the staging/for_v3.4 branch in
> media-tree.git.
> 
>  drivers/media/video/omap3isp/isp.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/isp.c
> b/drivers/media/video/omap3isp/isp.c index 12d5f92..c3ff142 100644
> --- a/drivers/media/video/omap3isp/isp.c
> +++ b/drivers/media/video/omap3isp/isp.c
> @@ -1112,7 +1112,8 @@ isp_restore_context(struct isp_device *isp, struct
> isp_reg *reg_list) static void isp_save_ctx(struct isp_device *isp)
>  {
>  	isp_save_context(isp, isp_reg_list);
> -	omap_iommu_save_ctx(isp->dev);
> +	if (isp->domain)
> +		omap_iommu_save_ctx(isp->dev);

What about skipping the isp_save_ctx() call completely in omap3isp_put() when 
isp->domain is NULL ? We don't need to save the ISP context either.

>  }
> 
>  /*
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
