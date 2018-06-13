Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr40073.outbound.protection.outlook.com ([40.107.4.73]:4832
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933999AbeFMHQO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 03:16:14 -0400
Subject: Re: [PATCH v3 5/9] xen/gntdev: Allow mappings for DMA buffers
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com
References: <20180612134200.17456-1-andr2000@gmail.com>
 <20180612134200.17456-6-andr2000@gmail.com>
 <b78251d7-462a-fb1f-32e9-868a7236decb@oracle.com>
From: Oleksandr Andrushchenko <Oleksandr_Andrushchenko@epam.com>
Message-ID: <1a79c485-e0bc-d987-32f5-5fdbc1722b6e@epam.com>
Date: Wed, 13 Jun 2018 10:16:05 +0300
MIME-Version: 1.0
In-Reply-To: <b78251d7-462a-fb1f-32e9-868a7236decb@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/13/2018 04:26 AM, Boris Ostrovsky wrote:
>
>
> On 06/12/2018 09:41 AM, Oleksandr Andrushchenko wrote:
>
>>     static void gntdev_print_maps(struct gntdev_priv *priv,
>> @@ -121,8 +146,27 @@ static void gntdev_free_map(struct grant_map *map)
>>       if (map == NULL)
>>           return;
>>   +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
>> +    if (map->dma_vaddr) {
>> +        struct gnttab_dma_alloc_args args;
>> +
>> +        args.dev = map->dma_dev;
>> +        args.coherent = map->dma_flags & GNTDEV_DMA_FLAG_COHERENT;
>
>
> args.coherent = !!(map->dma_flags & GNTDEV_DMA_FLAG_COHERENT);
>
Will fix
>
>> +        args.nr_pages = map->count;
>> +        args.pages = map->pages;
>> +        args.frames = map->frames;
>> +        args.vaddr = map->dma_vaddr;
>> +        args.dev_bus_addr = map->dma_bus_addr;
>> +
>> +        gnttab_dma_free_pages(&args);
>> +    } else
>> +#endif
>>       if (map->pages)
>>           gnttab_free_pages(map->count, map->pages);
>> +
>> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
>> +    kfree(map->frames);
>> +#endif
>>       kfree(map->pages);
>>       kfree(map->grants);
>>       kfree(map->map_ops);
>> @@ -132,7 +176,8 @@ static void gntdev_free_map(struct grant_map *map)
>>       kfree(map);
>>   }
>>   -static struct grant_map *gntdev_alloc_map(struct gntdev_priv 
>> *priv, int count)
>> +static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, 
>> int count,
>> +                      int dma_flags)
>>   {
>>       struct grant_map *add;
>>       int i;
>> @@ -155,6 +200,37 @@ static struct grant_map *gntdev_alloc_map(struct 
>> gntdev_priv *priv, int count)
>>           NULL == add->pages)
>>           goto err;
>>   +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
>> +    add->dma_flags = dma_flags;
>> +
>> +    /*
>> +     * Check if this mapping is requested to be backed
>> +     * by a DMA buffer.
>> +     */
>> +    if (dma_flags & (GNTDEV_DMA_FLAG_WC | GNTDEV_DMA_FLAG_COHERENT)) {
>> +        struct gnttab_dma_alloc_args args;
>> +
>> +        add->frames = kcalloc(count, sizeof(add->frames[0]),
>> +                      GFP_KERNEL);
>> +        if (!add->frames)
>> +            goto err;
>> +
>> +        /* Remember the device, so we can free DMA memory. */
>> +        add->dma_dev = priv->dma_dev;
>> +
>> +        args.dev = priv->dma_dev;
>> +        args.coherent = dma_flags & GNTDEV_DMA_FLAG_COHERENT;
>
>
> And again here.
>
Will fix
>
>> +        args.nr_pages = count;
>> +        args.pages = add->pages;
>> +        args.frames = add->frames;
>> +
>> +        if (gnttab_dma_alloc_pages(&args))
>> +            goto err;
>> +
>> +        add->dma_vaddr = args.vaddr;
>> +        add->dma_bus_addr = args.dev_bus_addr;
>> +    } else
>> +#endif
>>       if (gnttab_alloc_pages(count, add->pages))
>>           goto err;
>>   @@ -325,6 +401,14 @@ static int map_grant_pages(struct grant_map *map)
>>           map->unmap_ops[i].handle = map->map_ops[i].handle;
>>           if (use_ptemod)
>>               map->kunmap_ops[i].handle = map->kmap_ops[i].handle;
>> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
>> +        else if (map->dma_vaddr) {
>> +            unsigned long mfn;
>
>
> This should be called bfn now.
>
Of course
>
>> +
>> +            mfn = pfn_to_bfn(page_to_pfn(map->pages[i]));
>> +            map->unmap_ops[i].dev_bus_addr = __pfn_to_phys(mfn);
>> +        }
>> +#endif
>>       }
>>       return err;
>>   }
>> @@ -548,6 +632,17 @@ static int gntdev_open(struct inode *inode, 
>> struct file *flip)
>>       }
>>         flip->private_data = priv;
>> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
>> +    priv->dma_dev = gntdev_miscdev.this_device;
>> +
>> +    /*
>> +     * The device is not spawn from a device tree, so 
>> arch_setup_dma_ops
>> +     * is not called, thus leaving the device with dummy DMA ops.
>> +     * Fix this call of_dma_configure() with a NULL node to set
>
>
> "Fix this by calling ..." I think.
>
Will fix
>
>> +     * default DMA ops.
>> +     */
>> +    of_dma_configure(priv->dma_dev, NULL);
>> +#endif
>>       pr_debug("priv %p\n", priv);
>>         return 0;
>
>
> With those fixed,
>
> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Thank you,
Oleksandr
