Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:43609 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932405AbeFFIOQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 04:14:16 -0400
Subject: Re: [Xen-devel] [PATCH v2 5/9] xen/gntdev: Allow mappings for DMA
 buffers
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, matthew.d.roper@intel.com,
        dongwon.kim@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180601114132.22596-1-andr2000@gmail.com>
 <20180601114132.22596-6-andr2000@gmail.com>
 <64facf05-0a51-c3d9-9d3b-780893248628@oracle.com>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <84217eac-b83b-710f-39ab-c93cad65bf9a@gmail.com>
Date: Wed, 6 Jun 2018 11:14:12 +0300
MIME-Version: 1.0
In-Reply-To: <64facf05-0a51-c3d9-9d3b-780893248628@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/04/2018 11:12 PM, Boris Ostrovsky wrote:
> On 06/01/2018 07:41 AM, Oleksandr Andrushchenko wrote:
>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>
>> Allow mappings for DMA backed  buffers if grant table module
>> supports such: this extends grant device to not only map buffers
>> made of balloon pages, but also from buffers allocated with
>> dma_alloc_xxx.
>>
>> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>> ---
>>   drivers/xen/gntdev.c      | 99 ++++++++++++++++++++++++++++++++++++++-
>>   include/uapi/xen/gntdev.h | 15 ++++++
>>   2 files changed, 112 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
>> index bd56653b9bbc..9813fc440c70 100644
>> --- a/drivers/xen/gntdev.c
>> +++ b/drivers/xen/gntdev.c
>> @@ -37,6 +37,9 @@
>>   #include <linux/slab.h>
>>   #include <linux/highmem.h>
>>   #include <linux/refcount.h>
>> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
>> +#include <linux/of_device.h>
>> +#endif
>>   
>>   #include <xen/xen.h>
>>   #include <xen/grant_table.h>
>> @@ -72,6 +75,11 @@ struct gntdev_priv {
>>   	struct mutex lock;
>>   	struct mm_struct *mm;
>>   	struct mmu_notifier mn;
>> +
>> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
>> +	/* Device for which DMA memory is allocated. */
>> +	struct device *dma_dev;
>> +#endif
>>   };
>>   
>>   struct unmap_notify {
>> @@ -96,10 +104,27 @@ struct grant_map {
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
>> +	struct device *dma_dev;
>> +	/* Flags used to create this DMA buffer: GNTDEV_DMA_FLAG_XXX. */
>> +	int dma_flags;
>> +	void *dma_vaddr;
>> +	dma_addr_t dma_bus_addr;
>> +	/* This is required for gnttab_dma_{alloc|free}_pages. */
> How about
>
> /* Needed to avoid allocation in gnttab_dma_free_pages(). */
>
Ok
>> +	xen_pfn_t *frames;
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
>> @@ -121,8 +146,27 @@ static void gntdev_free_map(struct grant_map *map)
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
>> +		args.frames = map->frames;
>> +		args.vaddr = map->dma_vaddr;
>> +		args.dev_bus_addr = map->dma_bus_addr;
>> +
>> +		gnttab_dma_free_pages(&args);
>> +	} else
>> +#endif
>>   	if (map->pages)
>>   		gnttab_free_pages(map->count, map->pages);
>> +
>> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
>> +	kfree(map->frames);
>> +#endif
>
> Can this be done under if (map->dma_vaddr) ?

>   In other words, is it
> possible for dma_vaddr to be NULL and still have unallocated frames pointer?
It is possible to have vaddr == NULL and frames != NULL as we
allocate frames outside of gnttab_dma_alloc_pages which
may fail. Calling kfree on NULL pointer is safe, so
I see no reason to change this code.
>
>>   	kfree(map->pages);
>>   	kfree(map->grants);
>>   	kfree(map->map_ops);
>> @@ -132,7 +176,8 @@ static void gntdev_free_map(struct grant_map *map)
>>   	kfree(map);
>>   }
>>   
>> -static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
>> +static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count,
>> +					  int dma_flags)
>>   {
>>   	struct grant_map *add;
>>   	int i;
>> @@ -155,6 +200,37 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
>>   	    NULL == add->pages)
>>   		goto err;
>>   
>> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
>> +	add->dma_flags = dma_flags;
>> +
>> +	/*
>> +	 * Check if this mapping is requested to be backed
>> +	 * by a DMA buffer.
>> +	 */
>> +	if (dma_flags & (GNTDEV_DMA_FLAG_WC | GNTDEV_DMA_FLAG_COHERENT)) {
>> +		struct gnttab_dma_alloc_args args;
>> +
>> +		add->frames = kcalloc(count, sizeof(add->frames[0]),
>> +				      GFP_KERNEL);
>> +		if (!add->frames)
>> +			goto err;
>> +
>> +		/* Remember the device, so we can free DMA memory. */
>> +		add->dma_dev = priv->dma_dev;
>> +
>> +		args.dev = priv->dma_dev;
>> +		args.coherent = dma_flags & GNTDEV_DMA_FLAG_COHERENT;
>> +		args.nr_pages = count;
>> +		args.pages = add->pages;
>> +		args.frames = add->frames;
>> +
>> +		if (gnttab_dma_alloc_pages(&args))
>> +			goto err;
>> +
>> +		add->dma_vaddr = args.vaddr;
>> +		add->dma_bus_addr = args.dev_bus_addr;
>> +	} else
>> +#endif
>>   	if (gnttab_alloc_pages(count, add->pages))
>>   		goto err;
>>   
>> @@ -325,6 +401,14 @@ static int map_grant_pages(struct grant_map *map)
>>   		map->unmap_ops[i].handle = map->map_ops[i].handle;
>>   		if (use_ptemod)
>>   			map->kunmap_ops[i].handle = map->kmap_ops[i].handle;
>> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
>> +		else if (map->dma_vaddr) {
>> +			unsigned long mfn;
>> +
>> +			mfn = __pfn_to_mfn(page_to_pfn(map->pages[i]));
>
> Not pfn_to_mfn()?
I'd love to, but pfn_to_mfn is only defined for x86, not ARM: [1] and [2]
Thus,

drivers/xen/gntdev.c:408:10: error: implicit declaration of function 
‘pfn_to_mfn’ [-Werror=implicit-function-declaration]
     mfn = pfn_to_mfn(page_to_pfn(map->pages[i]));

So, I'll keep __pfn_to_mfn
>
>
> -boris
Thank you,
Oleksandr
>> +			map->unmap_ops[i].dev_bus_addr = __pfn_to_phys(mfn);
>> +		}
>> +#endif
>>   	}
>>   	return err;
>>   }
>> @@ -548,6 +632,17 @@ static int gntdev_open(struct inode *inode, struct file *flip)
>>   	}
>>   
>>   	flip->private_data = priv;
>> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
>> +	priv->dma_dev = gntdev_miscdev.this_device;
>> +
>> +	/*
>> +	 * The device is not spawn from a device tree, so arch_setup_dma_ops
>> +	 * is not called, thus leaving the device with dummy DMA ops.
>> +	 * Fix this call of_dma_configure() with a NULL node to set
>> +	 * default DMA ops.
>> +	 */
>> +	of_dma_configure(priv->dma_dev, NULL);
>> +#endif
>>   	pr_debug("priv %p\n", priv);
>>   
>>   	return 0;
>> @@ -589,7 +684,7 @@ static long gntdev_ioctl_map_grant_ref(struct gntdev_priv *priv,
>>   		return -EINVAL;
>>   
>>   	err = -ENOMEM;
>> -	map = gntdev_alloc_map(priv, op.count);
>> +	map = gntdev_alloc_map(priv, op.count, 0 /* This is not a dma-buf. */);
>>   	if (!map)
>>   		return err;
>>   
>> diff --git a/include/uapi/xen/gntdev.h b/include/uapi/xen/gntdev.h
>> index 6d1163456c03..4b9d498a31d4 100644
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
>> +#define GNTDEV_DMA_FLAG_WC		(1 << 0)
>> +
>> +/*
>> + * The buffer is backed with memory allocated with dma_alloc_coherent.
>> + */
>> +#define GNTDEV_DMA_FLAG_COHERENT	(1 << 1)
>> +
>>   #endif /* __LINUX_PUBLIC_GNTDEV_H__ */
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xenproject.org
> https://lists.xenproject.org/mailman/listinfo/xen-devel
[1] https://elixir.bootlin.com/linux/v4.17/ident/pfn_to_mfn
[2] https://elixir.bootlin.com/linux/v4.17/ident/__pfn_to_mfn
