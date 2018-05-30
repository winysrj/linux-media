Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33972 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753622AbeE3PvL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 11:51:11 -0400
Subject: Re: [PATCH 2/8] xen/balloon: Move common memory reservation routines
 to a module
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180525153331.31188-1-andr2000@gmail.com>
 <20180525153331.31188-3-andr2000@gmail.com>
 <59ab73b0-967b-a82f-3b0d-95f1b0dc40a5@oracle.com>
 <89de7bdb-8759-419f-63bf-8ed0d57650f0@gmail.com>
 <edfa937b-3311-98db-2e6f-b4083598f796@oracle.com>
 <6ca7f428-eede-2c14-85fe-da4a20bcea0d@gmail.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <5dd3378d-ac32-691e-1f80-7218a5d07fd6@oracle.com>
Date: Wed, 30 May 2018 11:54:10 -0400
MIME-Version: 1.0
In-Reply-To: <6ca7f428-eede-2c14-85fe-da4a20bcea0d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/30/2018 04:29 AM, Oleksandr Andrushchenko wrote:
> On 05/29/2018 11:03 PM, Boris Ostrovsky wrote:
>> On 05/29/2018 02:22 PM, Oleksandr Andrushchenko wrote:
>>> On 05/29/2018 09:04 PM, Boris Ostrovsky wrote:
>>>> On 05/25/2018 11:33 AM, Oleksandr Andrushchenko wrote:
>>>> @@ -463,11 +457,6 @@ static enum bp_state
>>>> increase_reservation(unsigned long nr_pages)
>>>>        int rc;
>>>>        unsigned long i;
>>>>        struct page   *page;
>>>> -    struct xen_memory_reservation reservation = {
>>>> -        .address_bits = 0,
>>>> -        .extent_order = EXTENT_ORDER,
>>>> -        .domid        = DOMID_SELF
>>>> -    };
>>>>          if (nr_pages > ARRAY_SIZE(frame_list))
>>>>            nr_pages = ARRAY_SIZE(frame_list);
>>>> @@ -486,9 +475,7 @@ static enum bp_state
>>>> increase_reservation(unsigned long nr_pages)
>>>>            page = balloon_next_page(page);
>>>>        }
>>>>    -    set_xen_guest_handle(reservation.extent_start, frame_list);
>>>> -    reservation.nr_extents = nr_pages;
>>>> -    rc = HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
>>>> +    rc = xenmem_reservation_increase(nr_pages, frame_list);
>>>>        if (rc <= 0)
>>>>            return BP_EAGAIN;
>>>>    @@ -496,29 +483,7 @@ static enum bp_state
>>>> increase_reservation(unsigned long nr_pages)
>>>>            page = balloon_retrieve(false);
>>>>            BUG_ON(page == NULL);
>>>>    -#ifdef CONFIG_XEN_HAVE_PVMMU
>>>> -        /*
>>>> -         * We don't support PV MMU when Linux and Xen is using
>>>> -         * different page granularity.
>>>> -         */
>>>> -        BUILD_BUG_ON(XEN_PAGE_SIZE != PAGE_SIZE);
>>>> -
>>>> -        if (!xen_feature(XENFEAT_auto_translated_physmap)) {
>>>> -            unsigned long pfn = page_to_pfn(page);
>>>> -
>>>> -            set_phys_to_machine(pfn, frame_list[i]);
>>>> -
>>>> -            /* Link back into the page tables if not highmem. */
>>>> -            if (!PageHighMem(page)) {
>>>> -                int ret;
>>>> -                ret = HYPERVISOR_update_va_mapping(
>>>> -                        (unsigned long)__va(pfn << PAGE_SHIFT),
>>>> -                        mfn_pte(frame_list[i], PAGE_KERNEL),
>>>> -                        0);
>>>> -                BUG_ON(ret);
>>>> -            }
>>>> -        }
>>>> -#endif
>>>> +        xenmem_reservation_va_mapping_update(1, &page,
>>>> &frame_list[i]);
>>>>
>>>> Can you make a single call to xenmem_reservation_va_mapping_update(rc,
>>>> ...)? You need to keep track of pages but presumable they can be put
>>>> into an array (or a list). In fact, perhaps we can have
>>>> balloon_retrieve() return a set of pages.
>>> This is actually how it is used later on for dma-buf, but I just
>>> didn't want
>>> to alter original balloon code too much, but this can be done, in
>>> order of simplicity:
>>>
>>> 1. Similar to frame_list, e.g. static array of struct page* of size
>>> ARRAY_SIZE(frame_list):
>>> more static memory is used, but no allocations
>>>
>>> 2. Allocated at run-time with kcalloc: allocation can fail
>>
>> If this is called in freeing DMA buffer code path or in error path then
>> we shouldn't do it.
>>
>>
>>> 3. Make balloon_retrieve() return a set of pages: will require
>>> list/array allocation
>>> and handling, allocation may fail, balloon_retrieve prototype change
>>
>> balloon pages are strung on the lru list. Can we keep have
>> balloon_retrieve return a list of pages on that list?
> First of all, before we go deep in details, I will highlight
> the goal of the requested change: for balloon driver we call
> xenmem_reservation_va_mapping_update(*1*, &page, &frame_list[i]);
> from increase_reservation
> and
> xenmem_reservation_va_mapping_reset(*1*, &page);
> from decrease_reservation and it seems to be not elegant because of
> that one page/frame passed while we might have multiple pages/frames
> passed at once.
>
> In the balloon driver the producer of pages for increase_reservation
> is balloon_retrieve(false) and for decrease_reservation it is
> alloc_page(gfp).
> In case of decrease_reservation the page is added on the list:
> LIST_HEAD(pages);
> [...]
> list_add(&page->lru, &pages);
>
> and in case of increase_reservation it is retrieved page by page
> and can be put on a list as well with the same code from
> decrease_reservation, e.g.
> LIST_HEAD(pages);
> [...]
> list_add(&page->lru, &pages);
>
> Thus, both decrease_reservation and increase_reservation may hold
> their pages on a list before calling
> xenmem_reservation_va_mapping_{update|reset}.
>
> For that we need a prototype change:
> xenmem_reservation_va_mapping_reset(<nr_pages>, <list of pages>);
> But for xenmem_reservation_va_mapping_update it will look like:
> xenmem_reservation_va_mapping_update(<nr_pages>, <list of pages>,
> <array of frames>)
> which seems to be inconsistent. Converting entries of the static
> frame_list array
> into corresponding list doesn't seem to be cute as well.
>
> For dma-buf use-case arrays are more preferable as dma-buf constructs
> scatter-gather
> tables from array of pages etc. and if page list is passed then it
> needs to be
> converted into page array anyways.
>
> So, we can:
> 1. Keep the prototypes as is, e.g. accept array of pages and use
> nr_pages == 1 in
> case of balloon driver (existing code)
> 2. Statically allocate struct page* array in the balloon driver and
> fill it with pages
> when those pages are retrieved:
> static struct page *page_list[ARRAY_SIZE(frame_list)];
> which will take additional 8KiB of space on 64-bit platform, but
> simplify things a lot.
> 3. Allocate struct page *page_list[ARRAY_SIZE(frame_list)] dynamically
>
> As to Boris' suggestion "balloon pages are strung on the lru list. Can
> we keep have
> balloon_retrieve return a list of pages on that list?"
> Because of alloc_xenballooned_pages' retry logic for page retireval, e.g.
>     while (pgno < nr_pages) {
>         page = balloon_retrieve(true);
>         if (page) {
> [...]
>         } else {
>             ret = add_ballooned_pages(nr_pages - pgno);
> [...]
>     }
> I wouldn't change things that much.
>
> IMO, we can keep 1 page based API with the only overhead for balloon
> driver of
> function calls to xenmem_reservation_va_mapping_{update|reset} for
> each page.



I still think what I suggested is doable but we can come back to it
later and keep your per-page implementation for now.

BTW, I also think you can further simplify
xenmem_reservation_va_mapping_* routines by bailing out right away if
xen_feature(XENFEAT_auto_translated_physmap). In fact, you might even
make them inlines, along the lines of

inline void xenmem_reservation_va_mapping_reset(unsigned long count,
					 struct page **pages)
{
#ifdef CONFIG_XEN_HAVE_PVMMU
	if (!xen_feature(XENFEAT_auto_translated_physmap))
		__xenmem_reservation_va_mapping_reset(...)
#endif
} 

Or some such.

-boris

-boris
