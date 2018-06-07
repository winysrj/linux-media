Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34738 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750903AbeFGVnT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2018 17:43:19 -0400
Subject: Re: [Xen-devel] [PATCH v2 5/9] xen/gntdev: Allow mappings for DMA
 buffers
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com,
        Stefano Stabellini <sstabellini@kernel.org>
Cc: daniel.vetter@intel.com, matthew.d.roper@intel.com,
        dongwon.kim@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180601114132.22596-1-andr2000@gmail.com>
 <20180601114132.22596-6-andr2000@gmail.com>
 <64facf05-0a51-c3d9-9d3b-780893248628@oracle.com>
 <84217eac-b83b-710f-39ab-c93cad65bf9a@gmail.com>
 <a172746d-7a97-159f-71a7-511b2d239089@oracle.com>
 <30fa03c0-1b75-c0b1-b14f-8b52ea584e20@gmail.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <78dc2fc4-cdac-05b7-2c34-22b69e7e009c@oracle.com>
Date: Thu, 7 Jun 2018 17:46:53 -0400
MIME-Version: 1.0
In-Reply-To: <30fa03c0-1b75-c0b1-b14f-8b52ea584e20@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Stefano, question for you at the end)

On 06/07/2018 02:39 AM, Oleksandr Andrushchenko wrote:
> On 06/07/2018 12:19 AM, Boris Ostrovsky wrote:
>> On 06/06/2018 04:14 AM, Oleksandr Andrushchenko wrote:
>>> On 06/04/2018 11:12 PM, Boris Ostrovsky wrote:
>>>> On 06/01/2018 07:41 AM, Oleksandr Andrushchenko wrote:
>>>> @@ -121,8 +146,27 @@ static void gntdev_free_map(struct grant_map
>>>> *map)
>>>>        if (map == NULL)
>>>>            return;
>>>>    +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
> *Option 1: kfree(map->frames);*
>>>> +    if (map->dma_vaddr) {
>>>> +        struct gnttab_dma_alloc_args args;
>>>> +
>>>> +        args.dev = map->dma_dev;
>>>> +        args.coherent = map->dma_flags & GNTDEV_DMA_FLAG_COHERENT;
>>>> +        args.nr_pages = map->count;
>>>> +        args.pages = map->pages;
>>>> +        args.frames = map->frames;
>>>> +        args.vaddr = map->dma_vaddr;
>>>> +        args.dev_bus_addr = map->dma_bus_addr;
>>>> +
>>>> +        gnttab_dma_free_pages(&args);
> *Option 2: kfree(map->frames);*
>>>> +    } else
>>>> +#endif
>>>>        if (map->pages)
>>>>            gnttab_free_pages(map->count, map->pages);
>>>> +
>>>> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
>>>> +    kfree(map->frames);
>>>> +#endif
>>>>
>>>> Can this be done under if (map->dma_vaddr) ?
>>>>    In other words, is it
>>>> possible for dma_vaddr to be NULL and still have unallocated frames
>>>> pointer?
>>> It is possible to have vaddr == NULL and frames != NULL as we
>>> allocate frames outside of gnttab_dma_alloc_pages which
>>> may fail. Calling kfree on NULL pointer is safe,
>>
>> I am not questioning safety of the code, I would like avoid another
>> ifdef.
> Ah, I now understand, so you are asking if we can have
> that kfree(map->frames); in the place *Option 2* I marked above.
> Unfortunately no: map->frames is allocated before we try to
> allocate DMA memory, e.g. before dma_vaddr is set:
> [...]
>         add->frames = kcalloc(count, sizeof(add->frames[0]),
>                       GFP_KERNEL);
>         if (!add->frames)
>             goto err;
>
> [...]
>         if (gnttab_dma_alloc_pages(&args))
>             goto err;
>
>         add->dma_vaddr = args.vaddr;
> [...]
> err:
>     gntdev_free_map(add);
>
> So, it is possible to enter gntdev_free_map with
> frames != NULL and dma_vaddr == NULL. Option 1 above cannot be used
> as map->frames is needed for gnttab_dma_free_pages(&args);
> and Option 2 cannot be used as frames != NULL and dma_vaddr == NULL.
> Thus, I think that unfortunately we need that #ifdef.
> Option 3 below can also be considered, but that seems to be not good
> as we free resources in different places which looks inconsistent.


I was only thinking of option 2. But if it is possible to have frames !=
NULL and dma_vaddr == NULL then perhaps we indeed will have to live with
the extra ifdef.


>
> Sorry if I'm still missing your point.
>>
>>> so
>>> I see no reason to change this code.
>>>>>        kfree(map->pages);
>>>>>        kfree(map->grants);
>>>>>        kfree(map->map_ops);
>>>>> @@ -132,7 +176,8 @@ static void gntdev_free_map(struct grant_map
>>>>> *map)
>>>>>        kfree(map);
>>>>>    }
>>>>>    -static struct grant_map *gntdev_alloc_map(struct gntdev_priv
>>>>> *priv, int count)
>>>>> +static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv,
>>>>> int count,
>>>>> +                      int dma_flags)
>>>>>    {
>>>>>        struct grant_map *add;
>>>>>        int i;
>>>>> @@ -155,6 +200,37 @@ static struct grant_map
>>>>> *gntdev_alloc_map(struct gntdev_priv *priv, int count)
>>>>>            NULL == add->pages)
>>>>>            goto err;
>>>>>    +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
>>>>> +    add->dma_flags = dma_flags;
>>>>> +
>>>>> +    /*
>>>>> +     * Check if this mapping is requested to be backed
>>>>> +     * by a DMA buffer.
>>>>> +     */
>>>>> +    if (dma_flags & (GNTDEV_DMA_FLAG_WC |
>>>>> GNTDEV_DMA_FLAG_COHERENT)) {
>>>>> +        struct gnttab_dma_alloc_args args;
>>>>> +
>>>>> +        add->frames = kcalloc(count, sizeof(add->frames[0]),
>>>>> +                      GFP_KERNEL);
>>>>> +        if (!add->frames)
>>>>> +            goto err;
>>>>> +
>>>>> +        /* Remember the device, so we can free DMA memory. */
>>>>> +        add->dma_dev = priv->dma_dev;
>>>>> +
>>>>> +        args.dev = priv->dma_dev;
>>>>> +        args.coherent = dma_flags & GNTDEV_DMA_FLAG_COHERENT;
>>>>> +        args.nr_pages = count;
>>>>> +        args.pages = add->pages;
>>>>> +        args.frames = add->frames;
>>>>> +
>>>>> +        if (gnttab_dma_alloc_pages(&args))
> *Option 3: kfree(map->frames);*
>>>>> +            goto err;
>>>>> +
>>>>> +        add->dma_vaddr = args.vaddr;
>>>>> +        add->dma_bus_addr = args.dev_bus_addr;
>>>>> +    } else
>>>>> +#endif
>>>>>        if (gnttab_alloc_pages(count, add->pages))
>>>>>            goto err;
>>>>>    @@ -325,6 +401,14 @@ static int map_grant_pages(struct grant_map
>>>>> *map)
>>>>>            map->unmap_ops[i].handle = map->map_ops[i].handle;
>>>>>            if (use_ptemod)
>>>>>                map->kunmap_ops[i].handle = map->kmap_ops[i].handle;
>>>>> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
>>>>> +        else if (map->dma_vaddr) {
>>>>> +            unsigned long mfn;
>>>>> +
>>>>> +            mfn = __pfn_to_mfn(page_to_pfn(map->pages[i]));
>>>> Not pfn_to_mfn()?
>>> I'd love to, but pfn_to_mfn is only defined for x86, not ARM: [1]
>>> and [2]
>>> Thus,
>>>
>>> drivers/xen/gntdev.c:408:10: error: implicit declaration of function
>>> ‘pfn_to_mfn’ [-Werror=implicit-function-declaration]
>>>      mfn = pfn_to_mfn(page_to_pfn(map->pages[i]));
>>>
>>> So, I'll keep __pfn_to_mfn
>>
>> How will this work on non-PV x86?
> So, you mean I need:
> #ifdef CONFIG_X86
> mfn = pfn_to_mfn(page_to_pfn(map->pages[i]));
> #else
> mfn = __pfn_to_mfn(page_to_pfn(map->pages[i]));
> #endif
>

I'd rather fix it in ARM code. Stefano, why does ARM uses the
underscored version?


-boris
