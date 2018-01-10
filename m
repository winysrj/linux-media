Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752721AbeAJAZx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 19:25:53 -0500
Date: Tue, 9 Jan 2018 18:25:44 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-pci@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] pci-dma-compat: remove handling of NULL pdev
 arguments
Message-ID: <20180110002544.GA157182@bhelgaas-glaptop.roam.corp.google.com>
References: <20180109203939.5930-1-hch@lst.de>
 <20180109203939.5930-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180109203939.5930-4-hch@lst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

s/pci-dma-compat: remove handling of NULL pdev
 /PCI: Remove NULL device handling from DMA API/

On Tue, Jan 09, 2018 at 09:39:39PM +0100, Christoph Hellwig wrote:
> Historically some ISA drivers used the old pci DMA API with a NULL pdev
> argument, but these days this isn't used and not too useful due to the
> per-device DMA ops, so remove it.

s/pci/PCI/

I like this a lot, thanks!

It looks like "pci_free_consistent(NULL" is still used in
drivers/net/ethernet/tundra/tsi108_eth.c.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

With Mauro's ack on the media/ttusb-dev patches, I could merge the
whole series via the PCI tree?

> ---
>  include/linux/pci-dma-compat.h | 27 +++++++++++++--------------
>  1 file changed, 13 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/pci-dma-compat.h b/include/linux/pci-dma-compat.h
> index d1f9fdade1e0..0dd1a3f7b309 100644
> --- a/include/linux/pci-dma-compat.h
> +++ b/include/linux/pci-dma-compat.h
> @@ -17,91 +17,90 @@ static inline void *
>  pci_alloc_consistent(struct pci_dev *hwdev, size_t size,
>  		     dma_addr_t *dma_handle)
>  {
> -	return dma_alloc_coherent(hwdev == NULL ? NULL : &hwdev->dev, size, dma_handle, GFP_ATOMIC);
> +	return dma_alloc_coherent(&hwdev->dev, size, dma_handle, GFP_ATOMIC);
>  }
>  
>  static inline void *
>  pci_zalloc_consistent(struct pci_dev *hwdev, size_t size,
>  		      dma_addr_t *dma_handle)
>  {
> -	return dma_zalloc_coherent(hwdev == NULL ? NULL : &hwdev->dev,
> -				   size, dma_handle, GFP_ATOMIC);
> +	return dma_zalloc_coherent(&hwdev->dev, size, dma_handle, GFP_ATOMIC);
>  }
>  
>  static inline void
>  pci_free_consistent(struct pci_dev *hwdev, size_t size,
>  		    void *vaddr, dma_addr_t dma_handle)
>  {
> -	dma_free_coherent(hwdev == NULL ? NULL : &hwdev->dev, size, vaddr, dma_handle);
> +	dma_free_coherent(&hwdev->dev, size, vaddr, dma_handle);
>  }
>  
>  static inline dma_addr_t
>  pci_map_single(struct pci_dev *hwdev, void *ptr, size_t size, int direction)
>  {
> -	return dma_map_single(hwdev == NULL ? NULL : &hwdev->dev, ptr, size, (enum dma_data_direction)direction);
> +	return dma_map_single(&hwdev->dev, ptr, size, (enum dma_data_direction)direction);
>  }
>  
>  static inline void
>  pci_unmap_single(struct pci_dev *hwdev, dma_addr_t dma_addr,
>  		 size_t size, int direction)
>  {
> -	dma_unmap_single(hwdev == NULL ? NULL : &hwdev->dev, dma_addr, size, (enum dma_data_direction)direction);
> +	dma_unmap_single(&hwdev->dev, dma_addr, size, (enum dma_data_direction)direction);
>  }
>  
>  static inline dma_addr_t
>  pci_map_page(struct pci_dev *hwdev, struct page *page,
>  	     unsigned long offset, size_t size, int direction)
>  {
> -	return dma_map_page(hwdev == NULL ? NULL : &hwdev->dev, page, offset, size, (enum dma_data_direction)direction);
> +	return dma_map_page(&hwdev->dev, page, offset, size, (enum dma_data_direction)direction);
>  }
>  
>  static inline void
>  pci_unmap_page(struct pci_dev *hwdev, dma_addr_t dma_address,
>  	       size_t size, int direction)
>  {
> -	dma_unmap_page(hwdev == NULL ? NULL : &hwdev->dev, dma_address, size, (enum dma_data_direction)direction);
> +	dma_unmap_page(&hwdev->dev, dma_address, size, (enum dma_data_direction)direction);
>  }
>  
>  static inline int
>  pci_map_sg(struct pci_dev *hwdev, struct scatterlist *sg,
>  	   int nents, int direction)
>  {
> -	return dma_map_sg(hwdev == NULL ? NULL : &hwdev->dev, sg, nents, (enum dma_data_direction)direction);
> +	return dma_map_sg(&hwdev->dev, sg, nents, (enum dma_data_direction)direction);
>  }
>  
>  static inline void
>  pci_unmap_sg(struct pci_dev *hwdev, struct scatterlist *sg,
>  	     int nents, int direction)
>  {
> -	dma_unmap_sg(hwdev == NULL ? NULL : &hwdev->dev, sg, nents, (enum dma_data_direction)direction);
> +	dma_unmap_sg(&hwdev->dev, sg, nents, (enum dma_data_direction)direction);
>  }
>  
>  static inline void
>  pci_dma_sync_single_for_cpu(struct pci_dev *hwdev, dma_addr_t dma_handle,
>  		    size_t size, int direction)
>  {
> -	dma_sync_single_for_cpu(hwdev == NULL ? NULL : &hwdev->dev, dma_handle, size, (enum dma_data_direction)direction);
> +	dma_sync_single_for_cpu(&hwdev->dev, dma_handle, size, (enum dma_data_direction)direction);
>  }
>  
>  static inline void
>  pci_dma_sync_single_for_device(struct pci_dev *hwdev, dma_addr_t dma_handle,
>  		    size_t size, int direction)
>  {
> -	dma_sync_single_for_device(hwdev == NULL ? NULL : &hwdev->dev, dma_handle, size, (enum dma_data_direction)direction);
> +	dma_sync_single_for_device(&hwdev->dev, dma_handle, size, (enum dma_data_direction)direction);
>  }
>  
>  static inline void
>  pci_dma_sync_sg_for_cpu(struct pci_dev *hwdev, struct scatterlist *sg,
>  		int nelems, int direction)
>  {
> -	dma_sync_sg_for_cpu(hwdev == NULL ? NULL : &hwdev->dev, sg, nelems, (enum dma_data_direction)direction);
> +	dma_sync_sg_for_cpu(&hwdev->dev, sg, nelems, (enum dma_data_direction)direction);
>  }
>  
>  static inline void
>  pci_dma_sync_sg_for_device(struct pci_dev *hwdev, struct scatterlist *sg,
>  		int nelems, int direction)
>  {
> -	dma_sync_sg_for_device(hwdev == NULL ? NULL : &hwdev->dev, sg, nelems, (enum dma_data_direction)direction);
> +	dma_sync_sg_for_device(&hwdev->dev, sg, nelems, (enum dma_data_direction)direction);
>  }
>  
>  static inline int
> -- 
> 2.14.2
> 
