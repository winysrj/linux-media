Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55644 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab1JNX3g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 19:29:36 -0400
Date: Fri, 14 Oct 2011 16:29:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org,
	Michal Nazarewicz <mina86@mina86.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Russell King <linux@arm.linux.org.uk>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Ankita Garg <ankita@in.ibm.com>,
	Daniel Walker <dwalker@codeaurora.org>,
	Mel Gorman <mel@csn.ul.ie>, Arnd Bergmann <arnd@arndb.de>,
	Jesse Barker <jesse.barker@linaro.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shariq Hasnain <shariq.hasnain@linaro.org>,
	Chunsang Jeong <chunsang.jeong@linaro.org>,
	Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/9] mm: alloc_contig_freed_pages() added
Message-Id: <20111014162933.d8fead58.akpm@linux-foundation.org>
In-Reply-To: <1317909290-29832-3-git-send-email-m.szyprowski@samsung.com>
References: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com>
	<1317909290-29832-3-git-send-email-m.szyprowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 06 Oct 2011 15:54:42 +0200
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> This commit introduces alloc_contig_freed_pages() function

The "freed" seems redundant to me.  Wouldn't "alloc_contig_pages" be a
better name?

> which allocates (ie. removes from buddy system) free pages
> in range.  Caller has to guarantee that all pages in range
> are in buddy system.
> 
> Along with this function, a free_contig_pages() function is
> provided which frees all (or a subset of) pages allocated
> with alloc_contig_free_pages().
> 
> Michal Nazarewicz has modified the function to make it easier
> to allocate not MAX_ORDER_NR_PAGES aligned pages by making it
> return pfn of one-past-the-last allocated page.
> 
>
> ...
>
> +#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
> +/*
> + * Both PFNs must be from the same zone!  If this function returns
> + * true, pfn_to_page(pfn1) + (pfn2 - pfn1) == pfn_to_page(pfn2).
> + */
> +static inline bool zone_pfn_same_memmap(unsigned long pfn1, unsigned long pfn2)
> +{
> +	return pfn_to_section_nr(pfn1) == pfn_to_section_nr(pfn2);
> +}
> +
> +#else
> +
> +#define zone_pfn_same_memmap(pfn1, pfn2) (true)

Do this in C, please.  It's nicer and can prevent unused-var warnings.

> +#endif
> +
>
> ...
>
> +unsigned long alloc_contig_freed_pages(unsigned long start, unsigned long end,
> +				       gfp_t flag)
> +{
> +	unsigned long pfn = start, count;
> +	struct page *page;
> +	struct zone *zone;
> +	int order;
> +
> +	VM_BUG_ON(!pfn_valid(start));
> +	page = pfn_to_page(start);
> +	zone = page_zone(page);
> +
> +	spin_lock_irq(&zone->lock);
> +
> +	for (;;) {
> +		VM_BUG_ON(page_count(page) || !PageBuddy(page) ||
> +			  page_zone(page) != zone);
> +
> +		list_del(&page->lru);
> +		order = page_order(page);
> +		count = 1UL << order;
> +		zone->free_area[order].nr_free--;
> +		rmv_page_order(page);
> +		__mod_zone_page_state(zone, NR_FREE_PAGES, -(long)count);

__mod_zone_page_state() generally shouldn't be used - it bypasses the
per-cpu magazines and can introduce high lock contentions.

That's hopefully not an issue on this callpath but it is still a red
flag.  I'd suggest at least the addition of a suitably apologetic code
comment here - we don't want people to naively copy this code.

Plus such a comment would let me know why this was done ;)

> +		pfn += count;
> +		if (pfn >= end)
> +			break;
> +		VM_BUG_ON(!pfn_valid(pfn));
> +
> +		if (zone_pfn_same_memmap(pfn - count, pfn))
> +			page += count;
> +		else
> +			page = pfn_to_page(pfn);
> +	}
> +
> +	spin_unlock_irq(&zone->lock);
> +
> +	/* After this, pages in the range can be freed one be one */
> +	count = pfn - start;
> +	pfn = start;
> +	for (page = pfn_to_page(pfn); count; --count) {
> +		prep_new_page(page, 0, flag);
> +		++pfn;
> +		if (likely(zone_pfn_same_memmap(pfn - 1, pfn)))
> +			++page;
> +		else
> +			page = pfn_to_page(pfn);
> +	}
> +
> +	return pfn;
> +}
> +
> +void free_contig_pages(unsigned long pfn, unsigned nr_pages)
> +{
> +	struct page *page = pfn_to_page(pfn);
> +
> +	while (nr_pages--) {
> +		__free_page(page);
> +		++pfn;
> +		if (likely(zone_pfn_same_memmap(pfn - 1, pfn)))
> +			++page;
> +		else
> +			page = pfn_to_page(pfn);
> +	}
> +}

You're sure these functions don't need EXPORT_SYMBOL()?  Maybe the
design is that only DMA core calls into here (if so, that's good).


>  #ifdef CONFIG_MEMORY_HOTREMOVE
>  /*
>   * All pages in the range must be isolated before calling this.
> -- 
> 1.7.1.569.g6f426
