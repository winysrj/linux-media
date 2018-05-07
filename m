Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:51024 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752007AbeEGNVe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 09:21:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org
Subject: Re: [PATCH 2/2] omap3isp: Don't use GFP_DMA
Date: Mon, 07 May 2018 16:21:50 +0300
Message-ID: <2190885.d6Gm8zIgfg@avalon>
In-Reply-To: <20180507124723.2153-3-sakari.ailus@linux.intel.com>
References: <20180507124723.2153-1-sakari.ailus@linux.intel.com> <20180507124723.2153-3-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Monday, 7 May 2018 15:47:23 EEST Sakari Ailus wrote:
> The isp stat driver allocates memory for DMA and uses GFP_DMA flag for
> dev_alloc_coherent. The flag is no longer needed as the DMA mask is used
> for the purpose. Remove it.
> 
> Reported-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/omap3isp/ispstat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispstat.c
> b/drivers/media/platform/omap3isp/ispstat.c index
> 34a91125da36..c68562189961 100644
> --- a/drivers/media/platform/omap3isp/ispstat.c
> +++ b/drivers/media/platform/omap3isp/ispstat.c
> @@ -371,7 +371,7 @@ static int isp_stat_bufs_alloc_one(struct device *dev,
>  	int ret;
> 
>  	buf->virt_addr = dma_alloc_coherent(dev, size, &buf->dma_addr,
> -					    GFP_KERNEL | GFP_DMA);
> +					    GFP_KERNEL);
>  	if (!buf->virt_addr)
>  		return -ENOMEM;

-- 
Regards,

Laurent Pinchart
