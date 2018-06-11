Return-path: <linux-media-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:54522 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932292AbeFKR5J (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 13:57:09 -0400
Subject: Re: [Xen-devel] [PATCH v2 5/9] xen/gntdev: Allow mappings for DMA
 buffers
To: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Andrushchenko <andr2000@gmail.com>
Cc: jgross@suse.com, dongwon.kim@intel.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        daniel.vetter@intel.com, xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        matthew.d.roper@intel.com, linux-media@vger.kernel.org
References: <20180601114132.22596-1-andr2000@gmail.com>
 <20180601114132.22596-6-andr2000@gmail.com>
 <64facf05-0a51-c3d9-9d3b-780893248628@oracle.com>
 <84217eac-b83b-710f-39ab-c93cad65bf9a@gmail.com>
 <a172746d-7a97-159f-71a7-511b2d239089@oracle.com>
 <30fa03c0-1b75-c0b1-b14f-8b52ea584e20@gmail.com>
 <78dc2fc4-cdac-05b7-2c34-22b69e7e009c@oracle.com>
 <4be24882-185d-01e3-6aa1-751e341433c7@gmail.com>
 <alpine.DEB.2.10.1806081025030.14699@sstabellini-ThinkPad-X260>
 <c6e1820a-fb57-b213-aa2f-05787dae06ad@oracle.com>
 <06eff3fe-3ffc-47f6-6bd6-d8f2f823b382@gmail.com>
 <alpine.DEB.2.10.1806110949050.14695@sstabellini-ThinkPad-X260>
 <baab493d-bcba-f053-4b48-0f97fb5723b2@epam.com>
 <33984b9b-966a-78bb-0472-37af23b8ba9d@arm.com>
 <c5a94f8e-4b9f-a5e5-aac2-fc9fbd5503de@epam.com>
From: Julien Grall <julien.grall@arm.com>
Message-ID: <c45aa6c9-cc0e-63db-e97a-0518497eb78b@arm.com>
Date: Mon, 11 Jun 2018 18:56:57 +0100
MIME-Version: 1.0
In-Reply-To: <c5a94f8e-4b9f-a5e5-aac2-fc9fbd5503de@epam.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/11/2018 06:49 PM, Oleksandr Andrushchenko wrote:
> On 06/11/2018 08:46 PM, Julien Grall wrote:
>> Hi,
>>
>> On 06/11/2018 06:16 PM, Oleksandr Andrushchenko wrote:
>>> On 06/11/2018 07:51 PM, Stefano Stabellini wrote:
>>>> On Mon, 11 Jun 2018, Oleksandr Andrushchenko wrote:
>>>>> On 06/08/2018 10:21 PM, Boris Ostrovsky wrote:
>>>>>> On 06/08/2018 01:59 PM, Stefano Stabellini wrote:
>>>>>>>>>>>>>>       @@ -325,6 +401,14 @@ static int map_grant_pages(struct
>>>>>>>>>>>>>> grant_map
>>>>>>>>>>>>>> *map)
>>>>>>>>>>>>>>               map->unmap_ops[i].handle =
>>>>>>>>>>>>>> map->map_ops[i].handle;
>>>>>>>>>>>>>>               if (use_ptemod)
>>>>>>>>>>>>>> map->kunmap_ops[i].handle =
>>>>>>>>>>>>>> map->kmap_ops[i].handle;
>>>>>>>>>>>>>> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
>>>>>>>>>>>>>> +        else if (map->dma_vaddr) {
>>>>>>>>>>>>>> +            unsigned long mfn;
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +            mfn = __pfn_to_mfn(page_to_pfn(map->pages[i]));
>>>>>>>>>>>>> Not pfn_to_mfn()?
>>>>>>>>>>>> I'd love to, but pfn_to_mfn is only defined for x86, not ARM:
>>>>>>>>>>>> [1]
>>>>>>>>>>>> and [2]
>>>>>>>>>>>> Thus,
>>>>>>>>>>>>
>>>>>>>>>>>> drivers/xen/gntdev.c:408:10: error: implicit declaration of
>>>>>>>>>>>> function
>>>>>>>>>>>> ‘pfn_to_mfn’ [-Werror=implicit-function-declaration]
>>>>>>>>>>>>         mfn = pfn_to_mfn(page_to_pfn(map->pages[i]));
>>>>>>>>>>>>
>>>>>>>>>>>> So, I'll keep __pfn_to_mfn
>>>>>>>>>>> How will this work on non-PV x86?
>>>>>>>>>> So, you mean I need:
>>>>>>>>>> #ifdef CONFIG_X86
>>>>>>>>>> mfn = pfn_to_mfn(page_to_pfn(map->pages[i]));
>>>>>>>>>> #else
>>>>>>>>>> mfn = __pfn_to_mfn(page_to_pfn(map->pages[i]));
>>>>>>>>>> #endif
>>>>>>>>>>
>>>>>>>>> I'd rather fix it in ARM code. Stefano, why does ARM uses the
>>>>>>>>> underscored version?
>>>>>>>> Do you want me to add one more patch for ARM to wrap __pfn_to_mfn
>>>>>>>> with static inline for ARM? e.g.
>>>>>>>> static inline ...pfn_to_mfn(...)
>>>>>>>> {
>>>>>>>>       __pfn_to_mfn();
>>>>>>>> }
>>>>>>> A Xen on ARM guest doesn't actually know the mfns behind its own
>>>>>>> pseudo-physical pages. This is why we stopped using pfn_to_mfn and
>>>>>>> started using pfn_to_bfn instead, which will generally return "pfn",
>>>>>>> unless the page is a foreign grant. See include/xen/arm/page.h.
>>>>>>> pfn_to_bfn was also introduced on x86. For example, see the usage of
>>>>>>> pfn_to_bfn in drivers/xen/swiotlb-xen.c. Otherwise, if you don't 
>>>>>>> care
>>>>>>> about other mapped grants, you can just use pfn_to_gfn, that always
>>>>>>> returns pfn.
>>>>>> I think then this code needs to use pfn_to_bfn().
>>>>> Ok
>>>>>>
>>>>>>> Also, for your information, we support different page 
>>>>>>> granularities in
>>>>>>> Linux as a Xen guest, see the comment at include/xen/arm/page.h:
>>>>>>>
>>>>>>>     /*
>>>>>>>      * The pseudo-physical frame (pfn) used in all the helpers is 
>>>>>>> always
>>>>>>> based
>>>>>>>      * on Xen page granularity (i.e 4KB).
>>>>>>>      *
>>>>>>>      * A Linux page may be split across multiple non-contiguous 
>>>>>>> Xen page so
>>>>>>> we
>>>>>>>      * have to keep track with frame based on 4KB page granularity.
>>>>>>>      *
>>>>>>>      * PV drivers should never make a direct usage of those helpers
>>>>>>> (particularly
>>>>>>>      * pfn_to_gfn and gfn_to_pfn).
>>>>>>>      */
>>>>>>>
>>>>>>> A Linux page could be 64K, but a Xen page is always 4K. A granted 
>>>>>>> page
>>>>>>> is also 4K. We have helpers to take into account the offsets to map
>>>>>>> multiple Xen grants in a single Linux page, see for example
>>>>>>> drivers/xen/grant-table.c:gnttab_foreach_grant. Most PV drivers have
>>>>>>> been converted to be able to work with 64K pages correctly, but if I
>>>>>>> remember correctly gntdev.c is the only remaining driver that 
>>>>>>> doesn't
>>>>>>> support 64K pages yet, so you don't have to deal with it if you 
>>>>>>> don't
>>>>>>> want to.
>>>>>> I believe somewhere in this series there is a test for PAGE_SIZE vs.
>>>>>> XEN_PAGE_SIZE. Right, Oleksandr?
>>>>> Not in gntdev. You might have seen this in xen-drmfront/xen-sndfront,
>>>>> but I didn't touch gntdev for that. Do you want me to add yet 
>>>>> another patch
>>>>> in the series to check for that?
>>>> gntdev.c is already not capable of handling PAGE_SIZE != XEN_PAGE_SIZE,
>>>> so you are not going to break anything that is not already broken 
>>>> :-) If
>>>> your new gntdev.c code relies on PAGE_SIZE == XEN_PAGE_SIZE, it 
>>>> might be
>>>> good to add an in-code comment about it, just to make it easier to fix
>>>> the whole of gntdev.c in the future.
>>>>
>>> Yes, I just mean I can add something like [1] as a separate patch to 
>>> the series,
>>> so we are on the safe side here
>>
>> See my comment on Stefano's e-mail. I believe gntdev is able to handle 
>> PAGE_SIZE != XEN_PAGE_SIZE. So I would rather keep the behavior we 
>> have today for such case.
>>
> Sure, with a note that we waste most of a 64KiB page ;)

That's the second definition of "64KB page" ;). In the case of grants, 
it is actually quite hard to merge them in a single page. So quite a few 
places still allocate 64KB but only map the first 4KB.

You would need to rework most the grant framework (not only gntdev) to 
avoid that waste. Patches are welcomed.

Cheers,

-- 
Julien Grall
