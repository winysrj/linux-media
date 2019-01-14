Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F31C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 13:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5F972086D
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 13:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfANNMi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 08:12:38 -0500
Received: from foss.arm.com ([217.140.101.70]:33102 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbfANNMi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 08:12:38 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 523E8A78;
        Mon, 14 Jan 2019 05:12:37 -0800 (PST)
Received: from [10.1.196.75] (e110467-lin.cambridge.arm.com [10.1.196.75])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F4F73F5AF;
        Mon, 14 Jan 2019 05:12:35 -0800 (PST)
Subject: Re: [PATCH 1/3] dma-mapping: remove the default map_resource
 implementation
To:     Christoph Hellwig <hch@lst.de>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <20190111181731.11782-1-hch@lst.de>
 <20190111181731.11782-2-hch@lst.de>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <c882430e-1dbd-df86-d686-0381dcaa668e@arm.com>
Date:   Mon, 14 Jan 2019 13:12:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190111181731.11782-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 11/01/2019 18:17, Christoph Hellwig wrote:
> Just returning the physical address when not map_resource method is
> present is highly dangerous as it doesn't take any offset in the
> direct mapping into account and does the completely wrong thing for
> IOMMUs.  Instead provide a proper implementation in the direct mapping
> code, and also wire it up for arm and powerpc.

Ignoring the offset was kind of intentional there, because at the time I 
was primarily thinking about it in terms of the Keystone 2 platform 
where the peripherals are all in the same place (0-2GB) in both the bus 
and CPU physical address maps, and only the view of RAM differs between 
the two (2-4GB vs. 32-34GB). However, on something like BCM283x, the 
peripherals region is also offset from its bus address in the CPU view, 
but at a *different* offset relative to that of RAM.

Fortunately, I'm not aware of any platform which has a DMA engine behind 
an IOMMU (and thus *needs* to use dma_map_resource() to avoid said IOMMU 
blocking the slave device register reads/writes) and also has any 
nonzero offsets, and AFAIK the IOMMU-less platforms above aren't using 
dma_map_resource() at all, so this change shouldn't actually break 
anything, but I guess we have a bit of a problem making it truly generic 
and robust :(

Is this perhaps another shove in the direction of overhauling 
dma_pfn_offset into an arbitrary "DMA ranges" lookup table?

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   arch/arm/mm/dma-mapping.c         |  2 ++
>   arch/powerpc/kernel/dma-swiotlb.c |  1 +
>   arch/powerpc/kernel/dma.c         |  1 +
>   include/linux/dma-mapping.h       | 12 +++++++-----
>   kernel/dma/direct.c               | 14 ++++++++++++++
>   5 files changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index f1e2922e447c..3c8534904209 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -188,6 +188,7 @@ const struct dma_map_ops arm_dma_ops = {
>   	.unmap_page		= arm_dma_unmap_page,
>   	.map_sg			= arm_dma_map_sg,
>   	.unmap_sg		= arm_dma_unmap_sg,
> +	.map_resource		= dma_direct_map_resource,
>   	.sync_single_for_cpu	= arm_dma_sync_single_for_cpu,
>   	.sync_single_for_device	= arm_dma_sync_single_for_device,
>   	.sync_sg_for_cpu	= arm_dma_sync_sg_for_cpu,
> @@ -211,6 +212,7 @@ const struct dma_map_ops arm_coherent_dma_ops = {
>   	.get_sgtable		= arm_dma_get_sgtable,
>   	.map_page		= arm_coherent_dma_map_page,
>   	.map_sg			= arm_dma_map_sg,
> +	.map_resource		= dma_direct_map_resource,
>   	.dma_supported		= arm_dma_supported,
>   };
>   EXPORT_SYMBOL(arm_coherent_dma_ops);
> diff --git a/arch/powerpc/kernel/dma-swiotlb.c b/arch/powerpc/kernel/dma-swiotlb.c
> index 7d5fc9751622..fbb2506a414e 100644
> --- a/arch/powerpc/kernel/dma-swiotlb.c
> +++ b/arch/powerpc/kernel/dma-swiotlb.c
> @@ -55,6 +55,7 @@ const struct dma_map_ops powerpc_swiotlb_dma_ops = {
>   	.dma_supported = swiotlb_dma_supported,
>   	.map_page = dma_direct_map_page,
>   	.unmap_page = dma_direct_unmap_page,
> +	.map_resource = dma_direct_map_resource,
>   	.sync_single_for_cpu = dma_direct_sync_single_for_cpu,
>   	.sync_single_for_device = dma_direct_sync_single_for_device,
>   	.sync_sg_for_cpu = dma_direct_sync_sg_for_cpu,
> diff --git a/arch/powerpc/kernel/dma.c b/arch/powerpc/kernel/dma.c
> index b1903ebb2e9c..258b9e8ebb99 100644
> --- a/arch/powerpc/kernel/dma.c
> +++ b/arch/powerpc/kernel/dma.c
> @@ -273,6 +273,7 @@ const struct dma_map_ops dma_nommu_ops = {
>   	.dma_supported			= dma_nommu_dma_supported,
>   	.map_page			= dma_nommu_map_page,
>   	.unmap_page			= dma_nommu_unmap_page,
> +	.map_resource			= dma_direct_map_resource,
>   	.get_required_mask		= dma_nommu_get_required_mask,
>   #ifdef CONFIG_NOT_COHERENT_CACHE
>   	.sync_single_for_cpu 		= dma_nommu_sync_single,
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index cef2127e1d70..d3087829a6df 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -208,6 +208,8 @@ dma_addr_t dma_direct_map_page(struct device *dev, struct page *page,
>   		unsigned long attrs);
>   int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
>   		enum dma_data_direction dir, unsigned long attrs);
> +dma_addr_t dma_direct_map_resource(struct device *dev, phys_addr_t paddr,
> +		size_t size, enum dma_data_direction dir, unsigned long attrs);
>   
>   #if defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_DEVICE) || \
>       defined(CONFIG_SWIOTLB)
> @@ -346,19 +348,19 @@ static inline dma_addr_t dma_map_resource(struct device *dev,
>   					  unsigned long attrs)
>   {
>   	const struct dma_map_ops *ops = get_dma_ops(dev);
> -	dma_addr_t addr;
> +	dma_addr_t addr = DMA_MAPPING_ERROR;
>   
>   	BUG_ON(!valid_dma_direction(dir));
>   
>   	/* Don't allow RAM to be mapped */
>   	BUG_ON(pfn_valid(PHYS_PFN(phys_addr)));
>   
> -	addr = phys_addr;
> -	if (ops && ops->map_resource)
> +	if (dma_is_direct(ops))
> +		addr = dma_direct_map_resource(dev, phys_addr, size, dir, attrs);
> +	else if (ops->map_resource)
>   		addr = ops->map_resource(dev, phys_addr, size, dir, attrs);

Might it be reasonable to do:

	if (!dma_is_direct(ops) && ops->map_resource)
		addr = ops->map_resource(...);
	else
		addr = dma_direct_map_resource(...);

and avoid having to explicitly wire up the dma_direct callback elsewhere?

Robin.

>   
>   	debug_dma_map_resource(dev, phys_addr, size, dir, addr);
> -
>   	return addr;
>   }
>   
> @@ -369,7 +371,7 @@ static inline void dma_unmap_resource(struct device *dev, dma_addr_t addr,
>   	const struct dma_map_ops *ops = get_dma_ops(dev);
>   
>   	BUG_ON(!valid_dma_direction(dir));
> -	if (ops && ops->unmap_resource)
> +	if (!dma_is_direct(ops) && ops->unmap_resource)
>   		ops->unmap_resource(dev, addr, size, dir, attrs);
>   	debug_dma_unmap_resource(dev, addr, size, dir);
>   }
> diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
> index 355d16acee6d..8e0359b04957 100644
> --- a/kernel/dma/direct.c
> +++ b/kernel/dma/direct.c
> @@ -356,6 +356,20 @@ int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
>   }
>   EXPORT_SYMBOL(dma_direct_map_sg);
>   
> +dma_addr_t dma_direct_map_resource(struct device *dev, phys_addr_t paddr,
> +		size_t size, enum dma_data_direction dir, unsigned long attrs)
> +{
> +	dma_addr_t dma_addr = phys_to_dma(dev, paddr);
> +
> +	if (unlikely(!dma_direct_possible(dev, dma_addr, size))) {
> +		report_addr(dev, dma_addr, size);
> +		return DMA_MAPPING_ERROR;
> +	}
> +
> +	return dma_addr;
> +}
> +EXPORT_SYMBOL(dma_direct_map_resource);
> +
>   /*
>    * Because 32-bit DMA masks are so common we expect every architecture to be
>    * able to satisfy them - either by not supporting more physical memory, or by
> 
