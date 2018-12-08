Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C24AC04EB8
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 22:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 483D120837
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 22:52:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 483D120837
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=collabora.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbeLHWwU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 8 Dec 2018 17:52:20 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:36424 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbeLHWwU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2018 17:52:20 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 70E72260E1F
Message-ID: <3aeb99c505fd1c33199fcc26fe5e0bf239dee57e.camel@collabora.com>
Subject: Re: [PATCH 04/10] arm: implement DMA_ATTR_NON_CONSISTENT
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     Christoph Hellwig <hch@lst.de>, iommu@lists.linux-foundation.org
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-snps-arc@lists.infradead.org, linux-media@vger.kernel.org,
        linux-arm-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        sparclinux@vger.kernel.org, openrisc@lists.librecores.org,
        linux-parisc@vger.kernel.org, linux-mips@vger.kernel.org
Date:   Sat, 08 Dec 2018 19:52:04 -0300
In-Reply-To: <20181208173702.15158-5-hch@lst.de>
References: <20181208173702.15158-1-hch@lst.de>
         <20181208173702.15158-5-hch@lst.de>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sat, 2018-12-08 at 09:36 -0800, Christoph Hellwig wrote:
> For the iommu ops we can just use the implementaton for DMA coherent
> devices.  For the regular ops we need mix and match a bit so that
> we either use the CMA allocator without remapping, but with a special
> error handling case for highmem pages, or the simple allocator.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  arch/arm/mm/dma-mapping.c | 49 ++++++++++++++++++++++++++++-----------
>  1 file changed, 35 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 2cfb17bad1e6..b3b66b41c450 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -49,6 +49,7 @@ struct arm_dma_alloc_args {
>  	const void *caller;
>  	bool want_vaddr;
>  	int coherent_flag;
> +	bool nonconsistent_flag;
>  };
>  
>  struct arm_dma_free_args {
> @@ -57,6 +58,7 @@ struct arm_dma_free_args {
>  	void *cpu_addr;
>  	struct page *page;
>  	bool want_vaddr;
> +	bool nonconsistent_flag;
>  };
>  
>  #define NORMAL	    0
> @@ -348,7 +350,8 @@ static void __dma_free_buffer(struct page *page, size_t size)
>  static void *__alloc_from_contiguous(struct device *dev, size_t size,
>  				     pgprot_t prot, struct page **ret_page,
>  				     const void *caller, bool want_vaddr,
> -				     int coherent_flag, gfp_t gfp);
> +				     int coherent_flag, bool nonconsistent_flag,
> +				     gfp_t gfp);
>  
>  static void *__alloc_remap_buffer(struct device *dev, size_t size, gfp_t gfp,
>  				 pgprot_t prot, struct page **ret_page,
> @@ -405,7 +408,7 @@ static int __init atomic_pool_init(void)
>  	if (dev_get_cma_area(NULL))
>  		ptr = __alloc_from_contiguous(NULL, atomic_pool_size, prot,
>  				      &page, atomic_pool_init, true, NORMAL,
> -				      GFP_KERNEL);
> +				      false, GFP_KERNEL);
>  	else
>  		ptr = __alloc_remap_buffer(NULL, atomic_pool_size, gfp, prot,
>  					   &page, atomic_pool_init, true);
> @@ -579,7 +582,8 @@ static int __free_from_pool(void *start, size_t size)
>  static void *__alloc_from_contiguous(struct device *dev, size_t size,
>  				     pgprot_t prot, struct page **ret_page,
>  				     const void *caller, bool want_vaddr,
> -				     int coherent_flag, gfp_t gfp)
> +				     int coherent_flag, bool nonconsistent_flag,
> +				     gfp_t gfp)
>  {
>  	unsigned long order = get_order(size);
>  	size_t count = size >> PAGE_SHIFT;
> @@ -595,12 +599,16 @@ static void *__alloc_from_contiguous(struct device *dev, size_t size,
>  	if (!want_vaddr)
>  		goto out;
>  
> +	if (nonconsistent_flag) {
> +		if (PageHighMem(page))
> +			goto fail;
> +		goto out;
> +	}
> +
>  	if (PageHighMem(page)) {
>  		ptr = __dma_alloc_remap(page, size, GFP_KERNEL, prot, caller);
> -		if (!ptr) {
> -			dma_release_from_contiguous(dev, page, count);
> -			return NULL;
> -		}
> +		if (!ptr)
> +			goto fail;
>  	} else {
>  		__dma_remap(page, size, prot);
>  		ptr = page_address(page);
> @@ -609,12 +617,15 @@ static void *__alloc_from_contiguous(struct device *dev, size_t size,
>   out:
>  	*ret_page = page;
>  	return ptr;
> + fail:
> +	dma_release_from_contiguous(dev, page, count);
> +	return NULL;
>  }
>  
>  static void __free_from_contiguous(struct device *dev, struct page *page,
> -				   void *cpu_addr, size_t size, bool want_vaddr)
> +				   void *cpu_addr, size_t size, bool remapped)
>  {
> -	if (want_vaddr) {
> +	if (remapped) {
>  		if (PageHighMem(page))
>  			__dma_free_remap(cpu_addr, size);
>  		else
> @@ -635,7 +646,11 @@ static void *__alloc_simple_buffer(struct device *dev, size_t size, gfp_t gfp,
>  				   struct page **ret_page)
>  {
>  	struct page *page;
> -	/* __alloc_simple_buffer is only called when the device is coherent */
> +	/*
> +	 * __alloc_simple_buffer is only called when the device is coherent,
> +	 * or if the caller explicitly asked for an allocation that is not
> +	 * consistent.
> +	 */
>  	page = __dma_alloc_buffer(dev, size, gfp, COHERENT);
>  	if (!page)
>  		return NULL;
> @@ -667,13 +682,15 @@ static void *cma_allocator_alloc(struct arm_dma_alloc_args *args,
>  	return __alloc_from_contiguous(args->dev, args->size, args->prot,
>  				       ret_page, args->caller,
>  				       args->want_vaddr, args->coherent_flag,
> +				       args->nonconsistent_flag,
>  				       args->gfp);
>  }
>  
>  static void cma_allocator_free(struct arm_dma_free_args *args)
>  {
>  	__free_from_contiguous(args->dev, args->page, args->cpu_addr,
> -			       args->size, args->want_vaddr);
> +			       args->size,
> +			       args->want_vaddr || args->nonconsistent_flag);
>  }
>  
>  static struct arm_dma_allocator cma_allocator = {
> @@ -735,6 +752,7 @@ static void *__dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
>  		.caller = caller,
>  		.want_vaddr = ((attrs & DMA_ATTR_NO_KERNEL_MAPPING) == 0),
>  		.coherent_flag = is_coherent ? COHERENT : NORMAL,
> +		.nonconsistent_flag = (attrs & DMA_ATTR_NON_CONSISTENT),
>  	};
>  
>  #ifdef CONFIG_DMA_API_DEBUG
> @@ -773,7 +791,7 @@ static void *__dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
>  
>  	if (cma)
>  		buf->allocator = &cma_allocator;
> -	else if (is_coherent)
> +	else if (is_coherent || (attrs & DMA_ATTR_NON_CONSISTENT))
>  		buf->allocator = &simple_allocator;

Reading through your code I can't really see where the pgprot is changed
for non-consistent requests. Namely, __get_dma_pgprot only
returns writecombine or coherent memory.

Regards,
Ezequiel

