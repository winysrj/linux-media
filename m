Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55238 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752754AbeFHTRw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2018 15:17:52 -0400
Subject: Re: [Xen-devel] [PATCH v2 5/9] xen/gntdev: Allow mappings for DMA
 buffers
To: Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Andrushchenko <andr2000@gmail.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com, daniel.vetter@intel.com,
        matthew.d.roper@intel.com, dongwon.kim@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        julien.grall@arm.com
References: <20180601114132.22596-1-andr2000@gmail.com>
 <20180601114132.22596-6-andr2000@gmail.com>
 <64facf05-0a51-c3d9-9d3b-780893248628@oracle.com>
 <84217eac-b83b-710f-39ab-c93cad65bf9a@gmail.com>
 <a172746d-7a97-159f-71a7-511b2d239089@oracle.com>
 <30fa03c0-1b75-c0b1-b14f-8b52ea584e20@gmail.com>
 <78dc2fc4-cdac-05b7-2c34-22b69e7e009c@oracle.com>
 <4be24882-185d-01e3-6aa1-751e341433c7@gmail.com>
 <alpine.DEB.2.10.1806081025030.14699@sstabellini-ThinkPad-X260>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <c6e1820a-fb57-b213-aa2f-05787dae06ad@oracle.com>
Date: Fri, 8 Jun 2018 15:21:24 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1806081025030.14699@sstabellini-ThinkPad-X260>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/08/2018 01:59 PM, Stefano Stabellini wrote:
>
>>>>>>>>     @@ -325,6 +401,14 @@ static int map_grant_pages(struct
>>>>>>>> grant_map
>>>>>>>> *map)
>>>>>>>>             map->unmap_ops[i].handle = map->map_ops[i].handle;
>>>>>>>>             if (use_ptemod)
>>>>>>>>                 map->kunmap_ops[i].handle =
>>>>>>>> map->kmap_ops[i].handle;
>>>>>>>> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
>>>>>>>> +        else if (map->dma_vaddr) {
>>>>>>>> +            unsigned long mfn;
>>>>>>>> +
>>>>>>>> +            mfn = __pfn_to_mfn(page_to_pfn(map->pages[i]));
>>>>>>> Not pfn_to_mfn()?
>>>>>> I'd love to, but pfn_to_mfn is only defined for x86, not ARM: [1]
>>>>>> and [2]
>>>>>> Thus,
>>>>>>
>>>>>> drivers/xen/gntdev.c:408:10: error: implicit declaration of function
>>>>>> ‘pfn_to_mfn’ [-Werror=implicit-function-declaration]
>>>>>>       mfn = pfn_to_mfn(page_to_pfn(map->pages[i]));
>>>>>>
>>>>>> So, I'll keep __pfn_to_mfn
>>>>> How will this work on non-PV x86?
>>>> So, you mean I need:
>>>> #ifdef CONFIG_X86
>>>> mfn = pfn_to_mfn(page_to_pfn(map->pages[i]));
>>>> #else
>>>> mfn = __pfn_to_mfn(page_to_pfn(map->pages[i]));
>>>> #endif
>>>>
>>> I'd rather fix it in ARM code. Stefano, why does ARM uses the
>>> underscored version?
>> Do you want me to add one more patch for ARM to wrap __pfn_to_mfn
>> with static inline for ARM? e.g.
>> static inline ...pfn_to_mfn(...)
>> {
>>     __pfn_to_mfn();
>> }
>
> A Xen on ARM guest doesn't actually know the mfns behind its own
> pseudo-physical pages. This is why we stopped using pfn_to_mfn and
> started using pfn_to_bfn instead, which will generally return "pfn",
> unless the page is a foreign grant. See include/xen/arm/page.h.
> pfn_to_bfn was also introduced on x86. For example, see the usage of
> pfn_to_bfn in drivers/xen/swiotlb-xen.c. Otherwise, if you don't care
> about other mapped grants, you can just use pfn_to_gfn, that always
> returns pfn.


I think then this code needs to use pfn_to_bfn().



>
> Also, for your information, we support different page granularities in
> Linux as a Xen guest, see the comment at include/xen/arm/page.h:
>
>   /*
>    * The pseudo-physical frame (pfn) used in all the helpers is always based
>    * on Xen page granularity (i.e 4KB).
>    *
>    * A Linux page may be split across multiple non-contiguous Xen page so we
>    * have to keep track with frame based on 4KB page granularity.
>    *
>    * PV drivers should never make a direct usage of those helpers (particularly
>    * pfn_to_gfn and gfn_to_pfn).
>    */
>
> A Linux page could be 64K, but a Xen page is always 4K. A granted page
> is also 4K. We have helpers to take into account the offsets to map
> multiple Xen grants in a single Linux page, see for example
> drivers/xen/grant-table.c:gnttab_foreach_grant. Most PV drivers have
> been converted to be able to work with 64K pages correctly, but if I
> remember correctly gntdev.c is the only remaining driver that doesn't
> support 64K pages yet, so you don't have to deal with it if you don't
> want to.


I believe somewhere in this series there is a test for PAGE_SIZE vs.
XEN_PAGE_SIZE. Right, Oleksandr?

Thanks for the explanation.

-boris
