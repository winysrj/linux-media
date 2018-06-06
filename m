Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:39617 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932371AbeFFHv3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 03:51:29 -0400
Subject: Re: [PATCH v2 4/9] xen/grant-table: Allow allocating buffers suitable
 for DMA
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180601114132.22596-1-andr2000@gmail.com>
 <20180601114132.22596-5-andr2000@gmail.com>
 <9214078e-6e94-e31b-6b36-c066e1aa5e40@oracle.com>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <35dd20e9-381a-2098-85e1-00b135e1370d@gmail.com>
Date: Wed, 6 Jun 2018 10:51:24 +0300
MIME-Version: 1.0
In-Reply-To: <9214078e-6e94-e31b-6b36-c066e1aa5e40@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/04/2018 09:46 PM, Boris Ostrovsky wrote:
> On 06/01/2018 07:41 AM, Oleksandr Andrushchenko wrote:
>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>
>> Extend grant table module API to allow allocating buffers that can
>> be used for DMA operations and mapping foreign grant references
>> on top of those.
>> The resulting buffer is similar to the one allocated by the balloon
>> driver in terms that proper memory reservation is made
>> ({increase|decrease}_reservation and VA mappings updated if needed).
>> This is useful for sharing foreign buffers with HW drivers which
>> cannot work with scattered buffers provided by the balloon driver,
>> but require DMAable memory instead.
>>
>> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>> ---
>>   drivers/xen/Kconfig       |  13 +++++
>>   drivers/xen/grant-table.c | 109 ++++++++++++++++++++++++++++++++++++++
>>   include/xen/grant_table.h |  18 +++++++
>>   3 files changed, 140 insertions(+)
>>
>> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
>> index e5d0c28372ea..39536ddfbce4 100644
>> --- a/drivers/xen/Kconfig
>> +++ b/drivers/xen/Kconfig
>> @@ -161,6 +161,19 @@ config XEN_GRANT_DEV_ALLOC
>>   	  to other domains. This can be used to implement frontend drivers
>>   	  or as part of an inter-domain shared memory channel.
>>   
>> +config XEN_GRANT_DMA_ALLOC
>> +	bool "Allow allocating DMA capable buffers with grant reference module"
>> +	depends on XEN && HAS_DMA
>> +	help
>> +	  Extends grant table module API to allow allocating DMA capable
>> +	  buffers and mapping foreign grant references on top of it.
>> +	  The resulting buffer is similar to one allocated by the balloon
>> +	  driver in terms that proper memory reservation is made
>> +	  ({increase|decrease}_reservation and VA mappings updated if needed).
>> +	  This is useful for sharing foreign buffers with HW drivers which
>> +	  cannot work with scattered buffers provided by the balloon driver,
>> +	  but require DMAable memory instead.
>> +
>>   config SWIOTLB_XEN
>>   	def_bool y
>>   	select SWIOTLB
>> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
>> index dbb48a89e987..5658e58d9cc6 100644
>> --- a/drivers/xen/grant-table.c
>> +++ b/drivers/xen/grant-table.c
>> @@ -45,6 +45,9 @@
>>   #include <linux/workqueue.h>
>>   #include <linux/ratelimit.h>
>>   #include <linux/moduleparam.h>
>> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
>> +#include <linux/dma-mapping.h>
>> +#endif
>>   
>>   #include <xen/xen.h>
>>   #include <xen/interface/xen.h>
>> @@ -57,6 +60,7 @@
>>   #ifdef CONFIG_X86
>>   #include <asm/xen/cpuid.h>
>>   #endif
>> +#include <xen/mem-reservation.h>
>>   #include <asm/xen/hypercall.h>
>>   #include <asm/xen/interface.h>
>>   
>> @@ -811,6 +815,73 @@ int gnttab_alloc_pages(int nr_pages, struct page **pages)
>>   }
>>   EXPORT_SYMBOL_GPL(gnttab_alloc_pages);
>>   
>> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
>> +/**
>> + * gnttab_dma_alloc_pages - alloc DMAable pages suitable for grant mapping into
>> + * @args: arguments to the function
>> + */
>> +int gnttab_dma_alloc_pages(struct gnttab_dma_alloc_args *args)
>> +{
>> +	unsigned long pfn, start_pfn;
>> +	size_t size;
>> +	int i, ret;
>> +
>> +	size = args->nr_pages << PAGE_SHIFT;
>> +	if (args->coherent)
>> +		args->vaddr = dma_alloc_coherent(args->dev, size,
>> +						 &args->dev_bus_addr,
>> +						 GFP_KERNEL | __GFP_NOWARN);
>> +	else
>> +		args->vaddr = dma_alloc_wc(args->dev, size,
>> +					   &args->dev_bus_addr,
>> +					   GFP_KERNEL | __GFP_NOWARN);
>> +	if (!args->vaddr) {
>> +		pr_err("Failed to allocate DMA buffer of size %zu\n", size);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	start_pfn = __phys_to_pfn(args->dev_bus_addr);
>> +	for (pfn = start_pfn, i = 0; pfn < start_pfn + args->nr_pages;
>> +			pfn++, i++) {
>> +		struct page *page = pfn_to_page(pfn);
>> +
>> +		args->pages[i] = page;
>> +		args->frames[i] = xen_page_to_gfn(page);
>> +		xenmem_reservation_scrub_page(page);
>> +	}
>> +
>> +	xenmem_reservation_va_mapping_reset(args->nr_pages, args->pages);
>> +
>> +	ret = xenmem_reservation_decrease(args->nr_pages, args->frames);
>> +	if (ret != args->nr_pages) {
>> +		pr_err("Failed to decrease reservation for DMA buffer\n");
>> +		ret = -EFAULT;
>> +		goto fail_free_dma;
>> +	}
>> +
>> +	ret = gnttab_pages_set_private(args->nr_pages, args->pages);
>> +	if (ret < 0)
>> +		goto fail_clear_private;
>> +
>> +	return 0;
>> +
>> +fail_clear_private:
>> +	gnttab_pages_clear_private(args->nr_pages, args->pages);
>> +fail_free_dma:
>> +	xenmem_reservation_increase(args->nr_pages, args->frames);
>> +	xenmem_reservation_va_mapping_update(args->nr_pages, args->pages,
>> +					     args->frames);
>> +	if (args->coherent)
>> +		dma_free_coherent(args->dev, size,
>> +				  args->vaddr, args->dev_bus_addr);
>> +	else
>> +		dma_free_wc(args->dev, size,
>> +			    args->vaddr, args->dev_bus_addr);
>> +	return ret;
>> +}
>
> Would it be possible to call gnttab_dma_free_pages() here?
As we moved frames array outside - yes, I'll call gnttab_dma_free_pages
on failure then.
>
>> +EXPORT_SYMBOL_GPL(gnttab_dma_alloc_pages);
>> +#endif
>> +
>>   void gnttab_pages_clear_private(int nr_pages, struct page **pages)
>>   {
>>   	int i;
>> @@ -838,6 +909,44 @@ void gnttab_free_pages(int nr_pages, struct page **pages)
>>   }
>>   EXPORT_SYMBOL_GPL(gnttab_free_pages);
>>   
>> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
> I'd move this after (or before) gnttab_dma_alloc_page() to keep both
> inside a single ifdef block.
Ok, will also move and regroup functions to be implemented
close to each other:
gnttab_dma_{alloc|free}_pages
gnttab_{alloc|free}_pages
gnttab_pages_{set|clear}_private
> -boris
>
>
>> +/**
>> + * gnttab_dma_free_pages - free DMAable pages
>> + * @args: arguments to the function
>> + */
>> +int gnttab_dma_free_pages(struct gnttab_dma_alloc_args *args)
>> +{
>> +	size_t size;
>> +	int i, ret;
>> +
>> +	gnttab_pages_clear_private(args->nr_pages, args->pages);
>> +
>> +	for (i = 0; i < args->nr_pages; i++)
>> +		args->frames[i] = page_to_xen_pfn(args->pages[i]);
>> +
>> +	ret = xenmem_reservation_increase(args->nr_pages, args->frames);
>> +	if (ret != args->nr_pages) {
>> +		pr_err("Failed to decrease reservation for DMA buffer\n");
>> +		ret = -EFAULT;
>> +	} else {
>> +		ret = 0;
>> +	}
>> +
>> +	xenmem_reservation_va_mapping_update(args->nr_pages, args->pages,
>> +					     args->frames);
>> +
>> +	size = args->nr_pages << PAGE_SHIFT;
>> +	if (args->coherent)
>> +		dma_free_coherent(args->dev, size,
>> +				  args->vaddr, args->dev_bus_addr);
>> +	else
>> +		dma_free_wc(args->dev, size,
>> +			    args->vaddr, args->dev_bus_addr);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(gnttab_dma_free_pages);
>> +#endif
>> +
>>   /* Handling of paged out grant targets (GNTST_eagain) */
>>   #define MAX_DELAY 256
>>   static inline void
>> diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
>> index de03f2542bb7..9bc5bc07d4d3 100644
>> --- a/include/xen/grant_table.h
>> +++ b/include/xen/grant_table.h
>> @@ -198,6 +198,24 @@ void gnttab_free_auto_xlat_frames(void);
>>   int gnttab_alloc_pages(int nr_pages, struct page **pages);
>>   void gnttab_free_pages(int nr_pages, struct page **pages);
>>   
>> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
>> +struct gnttab_dma_alloc_args {
>> +	/* Device for which DMA memory will be/was allocated. */
>> +	struct device *dev;
>> +	/* If set then DMA buffer is coherent and write-combine otherwise. */
>> +	bool coherent;
>> +
>> +	int nr_pages;
>> +	struct page **pages;
>> +	xen_pfn_t *frames;
>> +	void *vaddr;
>> +	dma_addr_t dev_bus_addr;
>> +};
>> +
>> +int gnttab_dma_alloc_pages(struct gnttab_dma_alloc_args *args);
>> +int gnttab_dma_free_pages(struct gnttab_dma_alloc_args *args);
>> +#endif
>> +
>>   int gnttab_pages_set_private(int nr_pages, struct page **pages);
>>   void gnttab_pages_clear_private(int nr_pages, struct page **pages);
>>   
