Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42028 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab1JRR0o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 13:26:44 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Marek Szyprowski" <m.szyprowski@samsung.com>,
	"Mel Gorman" <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org,
	"Kyungmin Park" <kyungmin.park@samsung.com>,
	"Russell King" <linux@arm.linux.org.uk>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
	"Ankita Garg" <ankita@in.ibm.com>,
	"Daniel Walker" <dwalker@codeaurora.org>,
	"Arnd Bergmann" <arnd@arndb.de>,
	"Jesse Barker" <jesse.barker@linaro.org>,
	"Jonathan Corbet" <corbet@lwn.net>,
	"Shariq Hasnain" <shariq.hasnain@linaro.org>,
	"Chunsang Jeong" <chunsang.jeong@linaro.org>,
	"Dave Hansen" <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/9] mm: alloc_contig_freed_pages() added
References: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com>
 <1317909290-29832-3-git-send-email-m.szyprowski@samsung.com>
 <20111018122109.GB6660@csn.ul.ie>
Date: Tue, 18 Oct 2011 10:26:37 -0700
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v3j5ent03l0zgt@mpn-glaptop>
In-Reply-To: <20111018122109.GB6660@csn.ul.ie>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 18 Oct 2011 05:21:09 -0700, Mel Gorman <mel@csn.ul.ie> wrote:

> At this point, I'm going to apologise for not reviewing this a long long
> time ago.
>
> On Thu, Oct 06, 2011 at 03:54:42PM +0200, Marek Szyprowski wrote:
>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>> This commit introduces alloc_contig_freed_pages() function
>> which allocates (ie. removes from buddy system) free pages
>> in range. Caller has to guarantee that all pages in range
>> are in buddy system.
>>
>
> Straight away, I'm wondering why you didn't use
>
> mm/compaction.c#isolate_freepages()
>
> It knows how to isolate pages within ranges. All its control information
> is passed via struct compact_control() which I recognise may be awkward
> for CMA but compaction.c know how to manage all the isolated pages and
> pass them to migrate.c appropriately.

It is something to consider.  At first glance, I see that isolate_freepages
seem to operate on pageblocks which is not desired for CMA.

> I haven't read all the patches yet but isolate_freepages() does break
> everything up into order-0 pages. This may not be to your liking but it
> would not be possible to change.

Splitting everything into order-0 pages is desired behaviour.

>> Along with this function, a free_contig_pages() function is
>> provided which frees all (or a subset of) pages allocated
>> with alloc_contig_free_pages().

> mm/compaction.c#release_freepages()

It sort of does the same thing but release_freepages() assumes that pages
that are being freed are not-continuous and they need to be on the lru list.
With free_contig_pages(), we can assume all pages are continuous.

>> +#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
>> +/*
>> + * Both PFNs must be from the same zone!  If this function returns
>> + * true, pfn_to_page(pfn1) + (pfn2 - pfn1) == pfn_to_page(pfn2).
>> + */
>> +static inline bool zone_pfn_same_memmap(unsigned long pfn1, unsigned long pfn2)
>> +{
>> +	return pfn_to_section_nr(pfn1) == pfn_to_section_nr(pfn2);
>> +}
>> +
>
> Why do you care what section the page is in? The zone is important all
> right, but not the section. Also, offhand I'm unsure if being in the
> same section guarantees the same zone. sections are ordinarily fully
> populated (except on ARM but hey) but I can't remember anything
> enforcing that zones be section-aligned.
>
> Later I think I see that the intention was to reduce the use of
> pfn_to_page().

That is correct.

> You can do this in a more general fashion by checking the
> zone boundaries and resolving the pfn->page every MAX_ORDER_NR_PAGES.
> That will not be SPARSEMEM specific.

I've tried doing stuff that way but it ended up with much more code.

Dave suggested the above function to check if pointer arithmetic is valid.

Please see also <https://lkml.org/lkml/2011/9/21/220>.

>
>> +#else
>> +
>> +#define zone_pfn_same_memmap(pfn1, pfn2) (true)
>> +
>> +#endif
>> +
>>  #endif /* !__GENERATING_BOUNDS.H */
>>  #endif /* !__ASSEMBLY__ */
>>  #endif /* _LINUX_MMZONE_H */


>> @@ -5706,6 +5706,73 @@ out:
>>  	spin_unlock_irqrestore(&zone->lock, flags);
>>  }
>>
>> +unsigned long alloc_contig_freed_pages(unsigned long start, unsigned long end,
>> +				       gfp_t flag)
>> +{
>> +	unsigned long pfn = start, count;
>> +	struct page *page;
>> +	struct zone *zone;
>> +	int order;
>> +
>> +	VM_BUG_ON(!pfn_valid(start));
>
> VM_BUG_ON seems very harsh here. WARN_ON_ONCE and returning 0 to the
> caller sees reasonable.
>
>> +	page = pfn_to_page(start);
>> +	zone = page_zone(page);
>> +
>> +	spin_lock_irq(&zone->lock);
>> +
>> +	for (;;) {
>> +		VM_BUG_ON(page_count(page) || !PageBuddy(page) ||
>> +			  page_zone(page) != zone);
>> +
>
> Here you will VM_BUG_ON with the zone lock held leading to system
> halting very shortly.
>
>> +		list_del(&page->lru);
>> +		order = page_order(page);
>> +		count = 1UL << order;
>> +		zone->free_area[order].nr_free--;
>> +		rmv_page_order(page);
>> +		__mod_zone_page_state(zone, NR_FREE_PAGES, -(long)count);
>> +
>
> The callers need to check in advance if watermarks are sufficient for
> this. In compaction, it happens in compaction_suitable() because it only
> needed to be checked once. Your requirements might be different.
>
>> +		pfn += count;
>> +		if (pfn >= end)
>> +			break;
>> +		VM_BUG_ON(!pfn_valid(pfn));
>> +
>
> On ARM, it's possible to encounter invalid pages. VM_BUG_ON is serious
> overkill.
>
>> +		if (zone_pfn_same_memmap(pfn - count, pfn))
>> +			page += count;
>> +		else
>> +			page = pfn_to_page(pfn);
>> +	}
>> +
>> +	spin_unlock_irq(&zone->lock);
>> +
>> +	/* After this, pages in the range can be freed one be one */
>> +	count = pfn - start;
>> +	pfn = start;
>> +	for (page = pfn_to_page(pfn); count; --count) {
>> +		prep_new_page(page, 0, flag);
>> +		++pfn;
>> +		if (likely(zone_pfn_same_memmap(pfn - 1, pfn)))
>> +			++page;
>> +		else
>> +			page = pfn_to_page(pfn);
>> +	}
>> +
>
> Here it looks like you have implemented something like split_free_page().

split_free_page() takes a single page, removes it from buddy system, and finally
splits it.  alloc_contig_freed_pages() takes a range of pages, removes them from
buddy system, and finally splits them.  Because it works on a range, it is
made into a separate function.

>> +	return pfn;
>> +}

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
