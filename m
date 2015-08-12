Return-path: <linux-media-owner@vger.kernel.org>
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:48878 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbbHLLwO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 07:52:14 -0400
Received: from /spool/local
	by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-media@vger.kernel.org> from <sebott@linux.vnet.ibm.com>;
	Wed, 12 Aug 2015 12:52:10 +0100
Date: Wed, 12 Aug 2015 13:51:58 +0200 (CEST)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@lst.de>
cc: torvalds@linux-foundation.org, axboe@kernel.dk,
	dan.j.williams@intel.com, vgupta@synopsys.com,
	hskinnemoen@gmail.com, egtvedt@samfundet.no, realmz6@gmail.com,
	dhowells@redhat.com, monstr@monstr.eu, x86@kernel.org,
	dwmw2@infradead.org, alex.williamson@redhat.com,
	grundler@parisc-linux.org, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-alpha@vger.kernel.org,
	linux-ia64@vger.kernel.org, linux-metag@vger.kernel.org,
	linux-mips@linux-mips.org, linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org,
	linux-nvdimm@ml01.01.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 16/31] s390: handle page-less SG entries
In-Reply-To: <1439363150-8661-17-git-send-email-hch@lst.de>
Message-ID: <alpine.LFD.2.11.1508121350090.1732@denkbrett>
References: <1439363150-8661-1-git-send-email-hch@lst.de> <1439363150-8661-17-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 12 Aug 2015, Christoph Hellwig wrote:

> Use sg_phys() instead of page_to_phys(sg_page(sg)) so that we don't
> require a page structure for all DMA memory.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Sebastian Ott <sebott@linux.vnet.ibm.com>


> ---
>  arch/s390/pci/pci_dma.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/s390/pci/pci_dma.c b/arch/s390/pci/pci_dma.c
> index 6fd8d58..aae5a47 100644
> --- a/arch/s390/pci/pci_dma.c
> +++ b/arch/s390/pci/pci_dma.c
> @@ -272,14 +272,13 @@ int dma_set_mask(struct device *dev, u64 mask)
>  }
>  EXPORT_SYMBOL_GPL(dma_set_mask);
>  
> -static dma_addr_t s390_dma_map_pages(struct device *dev, struct page *page,
> -				     unsigned long offset, size_t size,
> +static dma_addr_t s390_dma_map_phys(struct device *dev, unsigned long pa,
> +				     size_t size,
>  				     enum dma_data_direction direction,
>  				     struct dma_attrs *attrs)
>  {
>  	struct zpci_dev *zdev = get_zdev(to_pci_dev(dev));
>  	unsigned long nr_pages, iommu_page_index;
> -	unsigned long pa = page_to_phys(page) + offset;
>  	int flags = ZPCI_PTE_VALID;
>  	dma_addr_t dma_addr;
>  
> @@ -301,7 +300,7 @@ static dma_addr_t s390_dma_map_pages(struct device *dev, struct page *page,
>  
>  	if (!dma_update_trans(zdev, pa, dma_addr, size, flags)) {
>  		atomic64_add(nr_pages, &zdev->mapped_pages);
> -		return dma_addr + (offset & ~PAGE_MASK);
> +		return dma_addr + (pa & ~PAGE_MASK);
>  	}
>  
>  out_free:
> @@ -312,6 +311,16 @@ out_err:
>  	return DMA_ERROR_CODE;
>  }
>  
> +static dma_addr_t s390_dma_map_pages(struct device *dev, struct page *page,
> +				     unsigned long offset, size_t size,
> +				     enum dma_data_direction direction,
> +				     struct dma_attrs *attrs)
> +{
> +	unsigned long pa = page_to_phys(page) + offset;
> +
> +	return s390_dma_map_phys(dev, pa, size, direction, attrs);
> +}
> +
>  static void s390_dma_unmap_pages(struct device *dev, dma_addr_t dma_addr,
>  				 size_t size, enum dma_data_direction direction,
>  				 struct dma_attrs *attrs)
> @@ -384,8 +393,7 @@ static int s390_dma_map_sg(struct device *dev, struct scatterlist *sg,
>  	int i;
>  
>  	for_each_sg(sg, s, nr_elements, i) {
> -		struct page *page = sg_page(s);
> -		s->dma_address = s390_dma_map_pages(dev, page, s->offset,
> +		s->dma_address = s390_dma_map_phys(dev, sg_phys(s),
>  						    s->length, dir, NULL);
>  		if (!dma_mapping_error(dev, s->dma_address)) {
>  			s->dma_length = s->length;
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

