Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:33612 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbeJIVuw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2018 17:50:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] omap3isp: Unregister media device as first
Date: Tue, 09 Oct 2018 17:33:37 +0300
Message-ID: <3170095.c0OUfTCF4a@avalon>
In-Reply-To: <20181009120316.27649-1-sakari.ailus@linux.intel.com>
References: <20181009120316.27649-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Tuesday, 9 October 2018 15:03:16 EEST Sakari Ailus wrote:
> While there are issues related to object lifetime management, unregister the
> media device first when the driver is being unbound. This is slightly
> safer.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/omap3isp/isp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index 93f032a39470..4194ea82e6c4
> 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -1587,6 +1587,8 @@ static void isp_pm_complete(struct device *dev)
> 
>  static void isp_unregister_entities(struct isp_device *isp)
>  {
> +	media_device_unregister(&isp->media_dev);
> +
>  	omap3isp_csi2_unregister_entities(&isp->isp_csi2a);
>  	omap3isp_ccp2_unregister_entities(&isp->isp_ccp2);
>  	omap3isp_ccdc_unregister_entities(&isp->isp_ccdc);
> @@ -1597,7 +1599,6 @@ static void isp_unregister_entities(struct isp_device
> *isp) omap3isp_stat_unregister_entities(&isp->isp_hist);
> 
>  	v4l2_device_unregister(&isp->v4l2_dev);
> -	media_device_unregister(&isp->media_dev);
>  	media_device_cleanup(&isp->media_dev);
>  }


-- 
Regards,

Laurent Pinchart
