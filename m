Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35161 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbbCGX2S (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2015 18:28:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	pali.rohar@gmail.com
Subject: Re: [RFC 09/18] omap3isp: Replace mmio_base_phys array with the histogram block base
Date: Sun, 08 Mar 2015 01:28:18 +0200
Message-ID: <2415325.xPjzqFQXie@avalon>
In-Reply-To: <1425764475-27691-10-git-send-email-sakari.ailus@iki.fi>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi> <1425764475-27691-10-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Saturday 07 March 2015 23:41:06 Sakari Ailus wrote:
> Only the histogram sub-block driver uses the physical address. Do not store
> it for other sub-blocks.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/omap3isp/isp.c     |    3 ++-
>  drivers/media/platform/omap3isp/isp.h     |    6 +++---
>  drivers/media/platform/omap3isp/isphist.c |    2 +-
>  3 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index c045318..68d7edfc 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2247,7 +2247,8 @@ static int isp_map_mem_resource(struct platform_device
> *pdev, if (IS_ERR(isp->mmio_base[res]))
>  		return PTR_ERR(isp->mmio_base[res]);
> 
> -	isp->mmio_base_phys[res] = mem->start;
> +	if (res == OMAP3_ISP_IOMEM_HIST)
> +		isp->mmio_hist_base_phys = mem->start;
> 
>  	return 0;
>  }
> diff --git a/drivers/media/platform/omap3isp/isp.h
> b/drivers/media/platform/omap3isp/isp.h index b932a6f..9535524 100644
> --- a/drivers/media/platform/omap3isp/isp.h
> +++ b/drivers/media/platform/omap3isp/isp.h
> @@ -138,8 +138,8 @@ struct isp_xclk {
>   * @irq_num: Currently used IRQ number.
>   * @mmio_base: Array with kernel base addresses for ioremapped ISP register
> *             regions.
> - * @mmio_base_phys: Array with physical L4 bus addresses for ISP register
> - *                  regions.
> + * @mmio_hist_base_phys: Physical L4 bus address for ISP hist block
> register + *			 region.
>   * @mapping: IOMMU mapping
>   * @stat_lock: Spinlock for handling statistics
>   * @isp_mutex: Mutex for serializing requests to ISP.
> @@ -175,7 +175,7 @@ struct isp_device {
>  	unsigned int irq_num;
> 
>  	void __iomem *mmio_base[OMAP3_ISP_IOMEM_LAST];
> -	unsigned long mmio_base_phys[OMAP3_ISP_IOMEM_LAST];
> +	unsigned long mmio_hist_base_phys;
> 
>  	struct dma_iommu_mapping *mapping;
> 
> diff --git a/drivers/media/platform/omap3isp/isphist.c
> b/drivers/media/platform/omap3isp/isphist.c index ce822c3..3bb9c4f 100644
> --- a/drivers/media/platform/omap3isp/isphist.c
> +++ b/drivers/media/platform/omap3isp/isphist.c
> @@ -70,7 +70,7 @@ static void hist_dma_config(struct ispstat *hist)
>  	hist->dma_config.sync_mode = OMAP_DMA_SYNC_ELEMENT;
>  	hist->dma_config.frame_count = 1;
>  	hist->dma_config.src_amode = OMAP_DMA_AMODE_CONSTANT;
> -	hist->dma_config.src_start = isp->mmio_base_phys[OMAP3_ISP_IOMEM_HIST]
> +	hist->dma_config.src_start = isp->mmio_hist_base_phys
>  				   + ISPHIST_DATA;
>  	hist->dma_config.dst_amode = OMAP_DMA_AMODE_POST_INC;
>  	hist->dma_config.src_or_dst_synch = OMAP_DMA_SRC_SYNC;

-- 
Regards,

Laurent Pinchart

