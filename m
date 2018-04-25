Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40558 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751027AbeDYGPk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 02:15:40 -0400
Date: Tue, 24 Apr 2018 23:15:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        mjpeg-users@lists.sourceforge.net, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: zoran: move to dma-mapping interface
Message-ID: <20180425061537.GA23383@infradead.org>
References: <20180424204158.2764095-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180424204158.2764095-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 24, 2018 at 10:40:45PM +0200, Arnd Bergmann wrote:
> No drivers should use virt_to_bus() any more. This converts
> one of the few remaining ones to the DMA mapping interface.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/pci/zoran/Kconfig        |  2 +-
>  drivers/media/pci/zoran/zoran.h        | 10 +++++--
>  drivers/media/pci/zoran/zoran_card.c   | 10 +++++--
>  drivers/media/pci/zoran/zoran_device.c | 16 +++++-----
>  drivers/media/pci/zoran/zoran_driver.c | 54 +++++++++++++++++++++++++---------
>  5 files changed, 63 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/media/pci/zoran/Kconfig b/drivers/media/pci/zoran/Kconfig
> index 39ec35bd21a5..26f40e124a32 100644
> --- a/drivers/media/pci/zoran/Kconfig
> +++ b/drivers/media/pci/zoran/Kconfig
> @@ -1,6 +1,6 @@
>  config VIDEO_ZORAN
>  	tristate "Zoran ZR36057/36067 Video For Linux"
> -	depends on PCI && I2C_ALGOBIT && VIDEO_V4L2 && VIRT_TO_BUS
> +	depends on PCI && I2C_ALGOBIT && VIDEO_V4L2
>  	depends on !ALPHA
>  	help
>  	  Say Y for support for MJPEG capture cards based on the Zoran
> diff --git a/drivers/media/pci/zoran/zoran.h b/drivers/media/pci/zoran/zoran.h
> index 9bb3c21aa275..9ff3a9acb60a 100644
> --- a/drivers/media/pci/zoran/zoran.h
> +++ b/drivers/media/pci/zoran/zoran.h
> @@ -183,13 +183,14 @@ struct zoran_buffer {
>  	struct zoran_sync bs;		/* DONE: info to return to application */
>  	union {
>  		struct {
> -			__le32 *frag_tab;	/* addresses of frag table */
> -			u32 frag_tab_bus;	/* same value cached to save time in ISR */
> +			__le32 *frag_tab;	/* DMA addresses of frag table */
> +			void **frag_virt_tab;	/* virtual addresses of frag table */
> +			dma_addr_t frag_tab_dma;/* same value cached to save time in ISR */
>  		} jpg;
>  		struct {
>  			char *fbuffer;		/* virtual address of frame buffer */
>  			unsigned long fbuffer_phys;/* physical address of frame buffer */
> -			unsigned long fbuffer_bus;/* bus address of frame buffer */
> +			dma_addr_t fbuffer_dma;/* bus address of frame buffer */
>  		} v4l;
>  	};
>  };
> @@ -221,6 +222,7 @@ struct zoran_fh {
>  
>  	struct zoran_overlay_settings overlay_settings;
>  	u32 *overlay_mask;			/* overlay mask */
> +	dma_addr_t overlay_mask_dma;
>  	enum zoran_lock_activity overlay_active;/* feature currently in use? */
>  
>  	struct zoran_buffer_col buffers;	/* buffers' info */
> @@ -307,6 +309,7 @@ struct zoran {
>  
>  	struct zoran_overlay_settings overlay_settings;
>  	u32 *overlay_mask;	/* overlay mask */
> +	dma_addr_t overlay_mask_dma;
>  	enum zoran_lock_activity overlay_active;	/* feature currently in use? */
>  
>  	wait_queue_head_t v4l_capq;
> @@ -346,6 +349,7 @@ struct zoran {
>  
>  	/* zr36057's code buffer table */
>  	__le32 *stat_com;		/* stat_com[i] is indexed by dma_head/tail & BUZ_MASK_STAT_COM */
> +	dma_addr_t stat_com_dma;
>  
>  	/* (value & BUZ_MASK_FRAME) corresponds to index in pend[] queue */
>  	int jpg_pend[BUZ_MAX_FRAME];
> diff --git a/drivers/media/pci/zoran/zoran_card.c b/drivers/media/pci/zoran/zoran_card.c
> index a6b9ebd20263..dabd8bf77472 100644
> --- a/drivers/media/pci/zoran/zoran_card.c
> +++ b/drivers/media/pci/zoran/zoran_card.c
> @@ -890,6 +890,7 @@ zoran_open_init_params (struct zoran *zr)
>  	/* User must explicitly set a window */
>  	zr->overlay_settings.is_set = 0;
>  	zr->overlay_mask = NULL;
> +	zr->overlay_mask_dma = 0;

I don't think this zeroing is required, and given that 0 is a valid
dma address on some platforms is also is rather confusing.:w

>  
>  		mask_line_size = (BUZ_MAX_WIDTH + 31) / 32;
> -		reg = virt_to_bus(zr->overlay_mask);
> +		reg = zr->overlay_mask_dma;
>  		btwrite(reg, ZR36057_MMTR);
> -		reg = virt_to_bus(zr->overlay_mask + mask_line_size);
> +		reg = zr->overlay_mask_dma + mask_line_size;

I think this would be easier to read if the reg assignments got
removed, e.g.

	btwrite(zr->overlay_mask_dma, ZR36057_MMTR);
	btwrite(zr->overlay_mask_dma + mask_line_size, ZR36057_MMBR);

Same in a few other places.

> +		virt_tab = (void *)get_zeroed_page(GFP_KERNEL);
> +		if (!mem || !virt_tab) {
>  			dprintk(1,
>  				KERN_ERR
>  				"%s: %s - get_zeroed_page (frag_tab) failed for buffer %d\n",
>  				ZR_DEVNAME(zr), __func__, i);
> +			kfree(mem);
> +			kfree(virt_tab);
>  			jpg_fbuffer_free(fh);
>  			return -ENOBUFS;
>  		}
>  		fh->buffers.buffer[i].jpg.frag_tab = (__le32 *)mem;
> -		fh->buffers.buffer[i].jpg.frag_tab_bus = virt_to_bus(mem);
> +		fh->buffers.buffer[i].jpg.frag_virt_tab = virt_tab;

>From a quick look it seems like frag_tab should be a dma_alloc_coherent
allocation, or you would need a lot of cache sync operations.

That probably also means it can use dma_mmap_coherent instead of the
handcrafted remap_pfn_range loop and the PageReserved abuse.
