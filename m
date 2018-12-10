Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD34AC67839
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 19:19:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D79E2082F
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 19:19:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D79E2082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbeLJTTe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 14:19:34 -0500
Received: from foss.arm.com ([217.140.101.70]:33024 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbeLJTTe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 14:19:34 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E40BEBD;
        Mon, 10 Dec 2018 11:19:34 -0800 (PST)
Received: from [10.1.196.75] (e110467-lin.cambridge.arm.com [10.1.196.75])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C7E903F59C;
        Mon, 10 Dec 2018 11:19:31 -0800 (PST)
Subject: Re: [PATCH 02/10] arm64/iommu: don't remap contiguous allocations for
 coherent devices
To:     Christoph Hellwig <hch@lst.de>, iommu@lists.linux-foundation.org
Cc:     Vineet Gupta <vgupta@synopsys.com>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-snps-arc@lists.infradead.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, sparclinux@vger.kernel.org,
        openrisc@lists.librecores.org, linux-parisc@vger.kernel.org,
        linux-mips@vger.kernel.org
References: <20181208173702.15158-1-hch@lst.de>
 <20181208173702.15158-3-hch@lst.de>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <eaf8ce49-ab5e-7c02-a028-74671172b684@arm.com>
Date:   Mon, 10 Dec 2018 19:19:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181208173702.15158-3-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 08/12/2018 17:36, Christoph Hellwig wrote:
> There is no need to have an additional kernel mapping for a contiguous
> allocation if the device already is DMA coherent, so skip it.

FWIW, the "need" was that it kept the code in this path simple and the 
mapping behaviour consistent with the regular iommu_dma_alloc() case. 
One could quite easily retort that there is no need for the extra 
complexity of this patch, since vmalloc is cheap on a 64-bit architecture ;)

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   arch/arm64/mm/dma-mapping.c | 35 ++++++++++++++++++++++-------------
>   1 file changed, 22 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm64/mm/dma-mapping.c b/arch/arm64/mm/dma-mapping.c
> index 4c0f498069e8..d39b60113539 100644
> --- a/arch/arm64/mm/dma-mapping.c
> +++ b/arch/arm64/mm/dma-mapping.c
> @@ -255,13 +255,18 @@ static void *__iommu_alloc_attrs(struct device *dev, size_t size,
>   						    size >> PAGE_SHIFT);
>   			return NULL;
>   		}
> +
> +		if (coherent) {
> +			memset(addr, 0, size);
> +			return addr;
> +		}
> +
>   		addr = dma_common_contiguous_remap(page, size, VM_USERMAP,
>   						   prot,
>   						   __builtin_return_address(0));
>   		if (addr) {
>   			memset(addr, 0, size);
> -			if (!coherent)
> -				__dma_flush_area(page_to_virt(page), iosize);
> +			__dma_flush_area(page_to_virt(page), iosize);

Oh poo - seems I missed it at the time but the existing logic here is 
wrong. Let me send a separate fix to flip those statements into the 
correct order...

Robin.

>   		} else {
>   			iommu_dma_unmap_page(dev, *handle, iosize, 0, attrs);
>   			dma_release_from_contiguous(dev, page,
> @@ -309,7 +314,9 @@ static void __iommu_free_attrs(struct device *dev, size_t size, void *cpu_addr,
>   
>   		iommu_dma_unmap_page(dev, handle, iosize, 0, attrs);
>   		dma_release_from_contiguous(dev, page, size >> PAGE_SHIFT);
> -		dma_common_free_remap(cpu_addr, size, VM_USERMAP);
> +
> +		if (!dev_is_dma_coherent(dev))
> +			dma_common_free_remap(cpu_addr, size, VM_USERMAP);
>   	} else if (is_vmalloc_addr(cpu_addr)){
>   		struct vm_struct *area = find_vm_area(cpu_addr);
>   
> @@ -336,11 +343,12 @@ static int __iommu_mmap_attrs(struct device *dev, struct vm_area_struct *vma,
>   		return ret;
>   
>   	if (attrs & DMA_ATTR_FORCE_CONTIGUOUS) {
> -		/*
> -		 * DMA_ATTR_FORCE_CONTIGUOUS allocations are always remapped,
> -		 * hence in the vmalloc space.
> -		 */
> -		unsigned long pfn = vmalloc_to_pfn(cpu_addr);
> +		unsigned long pfn;
> +
> +		if (dev_is_dma_coherent(dev))
> +			pfn = virt_to_pfn(cpu_addr);
> +		else
> +			pfn = vmalloc_to_pfn(cpu_addr);
>   		return __swiotlb_mmap_pfn(vma, pfn, size);
>   	}
>   
> @@ -359,11 +367,12 @@ static int __iommu_get_sgtable(struct device *dev, struct sg_table *sgt,
>   	struct vm_struct *area = find_vm_area(cpu_addr);
>   
>   	if (attrs & DMA_ATTR_FORCE_CONTIGUOUS) {
> -		/*
> -		 * DMA_ATTR_FORCE_CONTIGUOUS allocations are always remapped,
> -		 * hence in the vmalloc space.
> -		 */
> -		struct page *page = vmalloc_to_page(cpu_addr);
> +		struct page *page;
> +
> +		if (dev_is_dma_coherent(dev))
> +			page = virt_to_page(cpu_addr);
> +		else
> +			page = vmalloc_to_page(cpu_addr);
>   		return __swiotlb_get_sgtable_page(sgt, page, size);
>   	}
>   
> 
