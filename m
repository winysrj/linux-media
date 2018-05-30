Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:44211 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935905AbeE3Gru (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 02:47:50 -0400
Subject: Re: [PATCH 4/8] xen/gntdev: Allow mappings for DMA buffers
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180525153331.31188-1-andr2000@gmail.com>
 <20180525153331.31188-5-andr2000@gmail.com>
 <9f2999a8-7786-5811-bdf0-ff7f30301cf2@oracle.com>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <c4cca97f-bd36-75bd-36aa-1edf3b140d15@gmail.com>
Date: Wed, 30 May 2018 09:47:46 +0300
MIME-Version: 1.0
In-Reply-To: <9f2999a8-7786-5811-bdf0-ff7f30301cf2@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/30/2018 12:52 AM, Boris Ostrovsky wrote:
> On 05/25/2018 11:33 AM, Oleksandr Andrushchenko wrote:
>>   
>>   struct unmap_notify {
>> @@ -96,10 +104,28 @@ struct grant_map {
>>   	struct gnttab_unmap_grant_ref *kunmap_ops;
>>   	struct page **pages;
>>   	unsigned long pages_vm_start;
>> +
>> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
>> +	/*
>> +	 * If dmabuf_vaddr is not NULL then this mapping is backed by DMA
>> +	 * capable memory.
>> +	 */
>> +
>> +	/* Device for which DMA memory is allocated. */
>> +	struct device *dma_dev;
>> +	/* Flags used to create this DMA buffer: GNTDEV_DMABUF_FLAG_XXX. */
>> +	bool dma_flags;
> Again, I think most of the comments here can be dropped. Except possibly
> for the flags.
will drop most of those
>> +	/* Virtual/CPU address of the DMA buffer. */
>> +	void *dma_vaddr;
>> +	/* Bus address of the DMA buffer. */
>> +	dma_addr_t dma_bus_addr;
>> +#endif
>>   };
>>   
>>   static int unmap_grant_pages(struct grant_map *map, int offset, int pages);
>>   
>> +static struct miscdevice gntdev_miscdev;
>> +
>>   /* ------------------------------------------------------------------ */
>>   
>>   static void gntdev_print_maps(struct gntdev_priv *priv,
>> @@ -121,8 +147,26 @@ static void gntdev_free_map(struct grant_map *map)
>>   	if (map == NULL)
>>   		return;
>>   
>> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
>> +	if (map->dma_vaddr) {
>> +		struct gnttab_dma_alloc_args args;
>> +
>> +		args.dev = map->dma_dev;
>> +		args.coherent = map->dma_flags & GNTDEV_DMA_FLAG_COHERENT;
>> +		args.nr_pages = map->count;
>> +		args.pages = map->pages;
>> +		args.vaddr = map->dma_vaddr;
>> +		args.dev_bus_addr = map->dma_bus_addr;
>> +
>> +		gnttab_dma_free_pages(&args);
>> +	} else if (map->pages) {
>> +		gnttab_free_pages(map->count, map->pages);
>> +	}
>> +#else
>>   	if (map->pages)
>>   		gnttab_free_pages(map->count, map->pages);
>> +#endif
>> +
> } else
> #endif
>      if (map->pages)
>          gnttab_free_pages(map->count, map->pages);
>
>
> (and elsewhere)
ok, just wasn't sure if it is ok to violate kernel coding style here ;)
>>   	kfree(map->pages);
>>   	kfree(map->grants);
>>   	kfree(map->map_ops);
>
>
>>   
>> diff --git a/include/uapi/xen/gntdev.h b/include/uapi/xen/gntdev.h
>> index 6d1163456c03..2d5a4672f07c 100644
>> --- a/include/uapi/xen/gntdev.h
>> +++ b/include/uapi/xen/gntdev.h
>> @@ -200,4 +200,19 @@ struct ioctl_gntdev_grant_copy {
>>   /* Send an interrupt on the indicated event channel */
>>   #define UNMAP_NOTIFY_SEND_EVENT 0x2
>>   
>> +/*
>> + * Flags to be used while requesting memory mapping's backing storage
>> + * to be allocated with DMA API.
>> + */
>> +
>> +/*
>> + * The buffer is backed with memory allocated with dma_alloc_wc.
>> + */
>> +#define GNTDEV_DMA_FLAG_WC		(1 << 1)
>
> Is there a reason you are not using bit 0?
No reason for that, will start from 0
>
> -boris
Thank you,
Oleksandr
>> +
>> +/*
>> + * The buffer is backed with memory allocated with dma_alloc_coherent.
>> + */
>> +#define GNTDEV_DMA_FLAG_COHERENT	(1 << 2)
>> +
>>   #endif /* __LINUX_PUBLIC_GNTDEV_H__ */
