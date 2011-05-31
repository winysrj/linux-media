Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:51107 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab1EaRKE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 13:10:04 -0400
Date: Tue, 31 May 2011 19:09:53 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Amber Jain <amber@ti.com>
cc: linux-media@vger.kernel.org, hvaibhav@ti.com, sakari.ailus@iki.fi
Subject: Re: [PATCH] OMAP: V4L2: Remove GFP_DMA allocation as ZONE_DMA is
 not configured on OMAP
In-Reply-To: <1306835503-24631-1-git-send-email-amber@ti.com>
Message-ID: <Pine.LNX.4.64.1105311904440.10863@axis700.grange>
References: <1306835503-24631-1-git-send-email-amber@ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 31 May 2011, Amber Jain wrote:

> Remove GFP_DMA from the __get_free_pages() call as ZONE_DMA is not configured
> on OMAP. Earlier the page allocator used to return a page from ZONE_NORMAL
> even when GFP_DMA is passed and CONFIG_ZONE_DMA is disabled.
> As a result of commit a197b59ae6e8bee56fcef37ea2482dc08414e2ac, page allocator
> returns null in such a scenario with a warning emitted to kernel log.
> 
> Signed-off-by: Amber Jain <amber@ti.com>
> ---
>  drivers/media/video/omap/omap_vout.c |    2 +-
>  drivers/media/video/omap24xxcam.c    |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
> index 4ada9be..8cac624 100644
> --- a/drivers/media/video/omap/omap_vout.c
> +++ b/drivers/media/video/omap/omap_vout.c
> @@ -181,7 +181,7 @@ static unsigned long omap_vout_alloc_buffer(u32 buf_size, u32 *phys_addr)
>  
>  	size = PAGE_ALIGN(buf_size);
>  	order = get_order(size);
> -	virt_addr = __get_free_pages(GFP_KERNEL | GFP_DMA, order);
> +	virt_addr = __get_free_pages(GFP_KERNEL , order);

Superfluous space before comma on all 3 occasions

>  	addr = virt_addr;
>  
>  	if (virt_addr) {
> diff --git a/drivers/media/video/omap24xxcam.c b/drivers/media/video/omap24xxcam.c
> index f6626e8..ade9262 100644
> --- a/drivers/media/video/omap24xxcam.c
> +++ b/drivers/media/video/omap24xxcam.c
> @@ -309,11 +309,11 @@ static int omap24xxcam_vbq_alloc_mmap_buffer(struct videobuf_buffer *vb)
>  			order--;
>  
>  		/* try to allocate as many contiguous pages as possible */
> -		page = alloc_pages(GFP_KERNEL | GFP_DMA, order);
> +		page = alloc_pages(GFP_KERNEL , order);
>  		/* if allocation fails, try to allocate smaller amount */
>  		while (page == NULL) {
>  			order--;
> -			page = alloc_pages(GFP_KERNEL | GFP_DMA, order);
> +			page = alloc_pages(GFP_KERNEL , order);
>  			if (page == NULL && !order) {
>  				err = -ENOMEM;
>  				goto out;
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
