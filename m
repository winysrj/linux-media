Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:36048 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab1FAWRW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2011 18:17:22 -0400
Date: Thu, 2 Jun 2011 01:17:18 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Amber Jain <amber@ti.com>
Cc: linux-media@vger.kernel.org, hvaibhav@ti.com
Subject: Re: [PATCH] OMAP2: V4L2: Remove GFP_DMA allocation as ZONE_DMA is
 not configured on OMAP
Message-ID: <20110601221718.GB6073@valkosipuli.localdomain>
References: <1306853136-12106-1-git-send-email-amber@ti.com>
 <1306853136-12106-2-git-send-email-amber@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306853136-12106-2-git-send-email-amber@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Amber,

Thanks for the patch.

On Tue, May 31, 2011 at 08:15:36PM +0530, Amber Jain wrote:
> Remove GFP_DMA from the __get_free_pages() call from omap24xxcam as ZONE_DMA
> is not configured on OMAP. Earlier the page allocator used to return a page
> from ZONE_NORMAL even when GFP_DMA is passed and CONFIG_ZONE_DMA is disabled.
> As a result of commit a197b59ae6e8bee56fcef37ea2482dc08414e2ac, page allocator
> returns null in such a scenario with a warning emitted to kernel log.
> 
> Signed-off-by: Amber Jain <amber@ti.com>
> ---
>  drivers/media/video/omap24xxcam.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

> diff --git a/drivers/media/video/omap24xxcam.c b/drivers/media/video/omap24xxcam.c
> index f6626e8..d92d4c6 100644
> --- a/drivers/media/video/omap24xxcam.c
> +++ b/drivers/media/video/omap24xxcam.c
> @@ -309,11 +309,11 @@ static int omap24xxcam_vbq_alloc_mmap_buffer(struct videobuf_buffer *vb)
>  			order--;
>  
>  		/* try to allocate as many contiguous pages as possible */
> -		page = alloc_pages(GFP_KERNEL | GFP_DMA, order);
> +		page = alloc_pages(GFP_KERNEL, order);
>  		/* if allocation fails, try to allocate smaller amount */
>  		while (page == NULL) {
>  			order--;
> -			page = alloc_pages(GFP_KERNEL | GFP_DMA, order);
> +			page = alloc_pages(GFP_KERNEL, order);
>  			if (page == NULL && !order) {
>  				err = -ENOMEM;
>  				goto out;
> -- 
> 1.7.1
> 

-- 
Sakari Ailus
sakari dot ailus at iki dot fi
