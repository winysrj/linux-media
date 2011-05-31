Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:60939 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263Ab1EaR3k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 13:29:40 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "JAIN, AMBER" <amber@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "sakari.ailus@iki.fi" <sakari.ailus@iki.fi>
Date: Tue, 31 May 2011 22:59:27 +0530
Subject: RE: [PATCH] V4L2: omap_vout: Remove GFP_DMA allocation as ZONE_DMA
 is not configured on OMAP
Message-ID: <19F8576C6E063C45BE387C64729E739404E2DC74D1@dbde02.ent.ti.com>
References: <1306853136-12106-1-git-send-email-amber@ti.com>
In-Reply-To: <1306853136-12106-1-git-send-email-amber@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> -----Original Message-----
> From: JAIN, AMBER
> Sent: Tuesday, May 31, 2011 8:16 PM
> To: linux-media@vger.kernel.org
> Cc: Hiremath, Vaibhav; sakari.ailus@iki.fi; JAIN, AMBER
> Subject: [PATCH] V4L2: omap_vout: Remove GFP_DMA allocation as ZONE_DMA is
> not configured on OMAP
> 
> Remove GFP_DMA from the __get_free_pages() call from omap_vout as ZONE_DMA
> is not configured on OMAP. Earlier the page allocator used to return a
> page
> from ZONE_NORMAL even when GFP_DMA is passed and CONFIG_ZONE_DMA is
> disabled.
> As a result of commit a197b59ae6e8bee56fcef37ea2482dc08414e2ac, page
> allocator
> returns null in such a scenario with a warning emitted to kernel log.
> 
> Signed-off-by: Amber Jain <amber@ti.com>
> ---
[Hiremath, Vaibhav] Tested on OMAP3EVM.

Tested-by: Vaibhav Hiremath <hvaibhav@ti.com>
Acked-by: Vaibhav Hiremath <hvaibhav@ti.com>

Thanks,
Vaibhav

>  drivers/media/video/omap/omap_vout.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/omap/omap_vout.c
> b/drivers/media/video/omap/omap_vout.c
> index 4ada9be..8cac624 100644
> --- a/drivers/media/video/omap/omap_vout.c
> +++ b/drivers/media/video/omap/omap_vout.c
> @@ -181,7 +181,7 @@ static unsigned long omap_vout_alloc_buffer(u32
> buf_size, u32 *phys_addr)
> 
>  	size = PAGE_ALIGN(buf_size);
>  	order = get_order(size);
> -	virt_addr = __get_free_pages(GFP_KERNEL | GFP_DMA, order);
> +	virt_addr = __get_free_pages(GFP_KERNEL, order);
>  	addr = virt_addr;
> 
>  	if (virt_addr) {
> --
> 1.7.1

