Return-path: <mchehab@gaivota>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59168 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758790Ab0LNBVL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 20:21:11 -0500
Date: Tue, 14 Dec 2010 10:15:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankita Garg <ankita@in.ibm.com>,
	BooJin Kim <boojin.kim@samsung.com>,
	Daniel Walker <dwalker@codeaurora.org>,
	Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mel Gorman <mel@csn.ul.ie>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCHv7 06/10] mm: MIGRATE_CMA migration type added
Message-Id: <20101214101508.4199a3dd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <25250c1c5fb3ffd0c33ce744965bc8e958220f58.1292004520.git.m.nazarewicz@samsung.com>
References: <cover.1292004520.git.m.nazarewicz@samsung.com>
	<25250c1c5fb3ffd0c33ce744965bc8e958220f58.1292004520.git.m.nazarewicz@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Mon, 13 Dec 2010 12:26:47 +0100
Michal Nazarewicz <m.nazarewicz@samsung.com> wrote:

> The MIGRATE_CMA migration type has two main characteristics:
> (i) only movable pages can be allocated from MIGRATE_CMA
> pageblocks and (ii) page allocator will never change migration
> type of MIGRATE_CMA pageblocks.
> 
> This guarantees that page in a MIGRATE_CMA page block can
> always be migrated somewhere else (unless there's no memory left
> in the system).
> 
> It is designed to be used with Contiguous Memory Allocator
> (CMA) for allocating big chunks (eg. 10MiB) of physically
> contiguous memory.  Once driver requests contiguous memory,
> CMA will migrate pages from MIGRATE_CMA pageblocks.
> 
> To minimise number of migrations, MIGRATE_CMA migration type
> is the last type tried when page allocator falls back to other
> migration types then requested.
> 
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  include/linux/mmzone.h |   30 +++++++++++---
>  mm/Kconfig             |    8 ++++
>  mm/compaction.c        |   10 +++++
>  mm/internal.h          |    3 +
>  mm/page_alloc.c        |   97 +++++++++++++++++++++++++++++++++++++++--------
>  5 files changed, 124 insertions(+), 24 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 39c24eb..1b95899 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -35,13 +35,24 @@
>   */
>  #define PAGE_ALLOC_COSTLY_ORDER 3
>  
> -#define MIGRATE_UNMOVABLE     0
> -#define MIGRATE_RECLAIMABLE   1
> -#define MIGRATE_MOVABLE       2
> -#define MIGRATE_PCPTYPES      3 /* the number of types on the pcp lists */
> -#define MIGRATE_RESERVE       3
> -#define MIGRATE_ISOLATE       4 /* can't allocate from here */
> -#define MIGRATE_TYPES         5
> +enum {
> +	MIGRATE_UNMOVABLE,
> +	MIGRATE_RECLAIMABLE,
> +	MIGRATE_MOVABLE,
> +	MIGRATE_PCPTYPES,	/* the number of types on the pcp lists */
> +	MIGRATE_RESERVE = MIGRATE_PCPTYPES,
> +	MIGRATE_ISOLATE,	/* can't allocate from here */
> +#ifdef CONFIG_MIGRATE_CMA
> +	MIGRATE_CMA,		/* only movable */
> +#endif
> +	MIGRATE_TYPES
> +};

A nitpick.

I personaly would like to put MIGRATE_ISOLATE to be bottom of enum because it
means _not_for_allocation.


> +
> +#ifdef CONFIG_MIGRATE_CMA
> +#  define is_migrate_cma(migratetype) unlikely((migratetype) == MIGRATE_CMA)
> +#else
> +#  define is_migrate_cma(migratetype) false
> +#endif
>  
>  #define for_each_migratetype_order(order, type) \
>  	for (order = 0; order < MAX_ORDER; order++) \
> @@ -54,6 +65,11 @@ static inline int get_pageblock_migratetype(struct page *page)
>  	return get_pageblock_flags_group(page, PB_migrate, PB_migrate_end);
>  }
>  
> +static inline bool is_pageblock_cma(struct page *page)
> +{
> +	return is_migrate_cma(get_pageblock_migratetype(page));
> +}
> +
>  struct free_area {
>  	struct list_head	free_list[MIGRATE_TYPES];
>  	unsigned long		nr_free;
> diff --git a/mm/Kconfig b/mm/Kconfig
> index b911ad3..7818b07 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1,3 +1,11 @@
> +config MIGRATE_CMA
> +	bool
> +	help
> +	  This option should be selected by code that requires MIGRATE_CMA
> +	  migration type to be present.  Once a page block has this
> +	  migration type, only movable pages can be allocated from it and
> +	  the page block never changes it's migration type.
> +
>  config SELECT_MEMORY_MODEL
>  	def_bool y
>  	depends on EXPERIMENTAL || ARCH_SELECT_MEMORY_MODEL
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 4d709ee..c5e404b 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -113,6 +113,16 @@ static bool suitable_migration_target(struct page *page)
>  	if (migratetype == MIGRATE_ISOLATE || migratetype == MIGRATE_RESERVE)
>  		return false;
>  
> +	/* Keep MIGRATE_CMA alone as well. */
> +	/*
> +	 * XXX Revisit.  We currently cannot let compaction touch CMA
> +	 * pages since compaction insists on changing their migration
> +	 * type to MIGRATE_MOVABLE (see split_free_page() called from
> +	 * isolate_freepages_block() above).
> +	 */
> +	if (is_migrate_cma(migratetype))
> +		return false;
> +
>  	/* If the page is a large free page, then allow migration */
>  	if (PageBuddy(page) && page_order(page) >= pageblock_order)
>  		return true;
> diff --git a/mm/internal.h b/mm/internal.h
> index dedb0af..cc24e74 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -49,6 +49,9 @@ extern void putback_lru_page(struct page *page);
>   * in mm/page_alloc.c
>   */
>  extern void __free_pages_bootmem(struct page *page, unsigned int order);
> +#ifdef CONFIG_MIGRATE_CMA
> +extern void __free_pageblock_cma(struct page *page);
> +#endif
>  extern void prep_compound_page(struct page *page, unsigned long order);
>  #ifdef CONFIG_MEMORY_FAILURE
>  extern bool is_free_buddy_page(struct page *page);
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 997f6c8..537d1f6 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -717,6 +717,30 @@ void __meminit __free_pages_bootmem(struct page *page, unsigned int order)
>  	}
>  }
>  
> +#ifdef CONFIG_MIGRATE_CMA
> +
> +/*
> + * Free whole pageblock and set it's migration type to MIGRATE_CMA.
> + */
> +void __init __free_pageblock_cma(struct page *page)
> +{
> +	struct page *p = page;
> +	unsigned i = pageblock_nr_pages;
> +
> +	prefetchw(p);
> +	do {
> +		if (--i)
> +			prefetchw(p + 1);
> +		__ClearPageReserved(p);
> +		set_page_count(p, 0);
> +	} while (++p, i);
> +
> +	set_page_refcounted(page);
> +	set_pageblock_migratetype(page, MIGRATE_CMA);
> +	__free_pages(page, pageblock_order);
> +}
> +
> +#endif
>  
>  /*
>   * The order of subdivision here is critical for the IO subsystem.
> @@ -824,11 +848,15 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
>   * This array describes the order lists are fallen back to when
>   * the free lists for the desirable migrate type are depleted
>   */
> -static int fallbacks[MIGRATE_TYPES][MIGRATE_TYPES-1] = {
> +static int fallbacks[MIGRATE_TYPES][4] = {
>  	[MIGRATE_UNMOVABLE]   = { MIGRATE_RECLAIMABLE, MIGRATE_MOVABLE,   MIGRATE_RESERVE },
>  	[MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE,   MIGRATE_RESERVE },
> +#ifdef CONFIG_MIGRATE_CMA
> +	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE, MIGRATE_CMA    , MIGRATE_RESERVE },
> +#else
>  	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE, MIGRATE_RESERVE },
> -	[MIGRATE_RESERVE]     = { MIGRATE_RESERVE,     MIGRATE_RESERVE,   MIGRATE_RESERVE }, /* Never used */
> +#endif
> +	[MIGRATE_RESERVE]     = { MIGRATE_RESERVE }, /* Never used */
>  };
>  
>  /*
> @@ -924,12 +952,12 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
>  	/* Find the largest possible block of pages in the other list */
>  	for (current_order = MAX_ORDER-1; current_order >= order;
>  						--current_order) {
> -		for (i = 0; i < MIGRATE_TYPES - 1; i++) {
> +		for (i = 0; i < ARRAY_SIZE(fallbacks[0]); i++) {

Why fallbacks[0] ? and why do you need to change this ?

>  			migratetype = fallbacks[start_migratetype][i];
>  
>  			/* MIGRATE_RESERVE handled later if necessary */
>  			if (migratetype == MIGRATE_RESERVE)
> -				continue;
> +				break;
>  
Isn't this change enough for your purpose ?


>  			area = &(zone->free_area[current_order]);
>  			if (list_empty(&area->free_list[migratetype]))
> @@ -944,19 +972,29 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
>  			 * pages to the preferred allocation list. If falling
>  			 * back for a reclaimable kernel allocation, be more
>  			 * agressive about taking ownership of free pages
> +			 *
> +			 * On the other hand, never change migration
> +			 * type of MIGRATE_CMA pageblocks nor move CMA
> +			 * pages on different free lists. We don't
> +			 * want unmovable pages to be allocated from
> +			 * MIGRATE_CMA areas.
>  			 */
> -			if (unlikely(current_order >= (pageblock_order >> 1)) ||
> -					start_migratetype == MIGRATE_RECLAIMABLE ||
> -					page_group_by_mobility_disabled) {
> -				unsigned long pages;
> +			if (!is_pageblock_cma(page) &&
> +			    (unlikely(current_order >= (pageblock_order >> 1)) ||
> +			     start_migratetype == MIGRATE_RECLAIMABLE ||
> +			     page_group_by_mobility_disabled)) {
> +				int pages;
>  				pages = move_freepages_block(zone, page,
> -								start_migratetype);
> +							     start_migratetype);
>  
> -				/* Claim the whole block if over half of it is free */
> +				/*
> +				 * Claim the whole block if over half
> +				 * of it is free
> +				 */
>  				if (pages >= (1 << (pageblock_order-1)) ||
> -						page_group_by_mobility_disabled)
> +				    page_group_by_mobility_disabled)
>  					set_pageblock_migratetype(page,
> -								start_migratetype);
> +							start_migratetype);
>  
>  				migratetype = start_migratetype;
>  			}
> @@ -966,11 +1004,14 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
>  			rmv_page_order(page);
>  
>  			/* Take ownership for orders >= pageblock_order */
> -			if (current_order >= pageblock_order)
> +			if (current_order >= pageblock_order &&
> +			    !is_pageblock_cma(page))
>  				change_pageblock_range(page, current_order,
>  							start_migratetype);
>  
> -			expand(zone, page, order, current_order, area, migratetype);
> +			expand(zone, page, order, current_order, area,
> +			       is_migrate_cma(start_migratetype)
> +			     ? start_migratetype : migratetype);
>  
>  			trace_mm_page_alloc_extfrag(page, order, current_order,
>  				start_migratetype, migratetype);
> @@ -1042,7 +1083,12 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
>  			list_add(&page->lru, list);
>  		else
>  			list_add_tail(&page->lru, list);
> -		set_page_private(page, migratetype);
> +#ifdef CONFIG_MIGRATE_CMA
> +		if (is_pageblock_cma(page))
> +			set_page_private(page, MIGRATE_CMA);
> +		else
> +#endif
> +			set_page_private(page, migratetype);

Hmm, doesn't this meet your changes which makes MIGRATE_CMA > MIGRATE_PCPLIST ?
And I think putting mixture of pages marked of MIGRATE_TYPE onto a pcplist is ugly.
Could you make this cleaner ?


>  		list = &page->lru;
>  	}
>  	__mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
> @@ -1181,9 +1227,16 @@ void free_hot_cold_page(struct page *page, int cold)
>  	 * offlined but treat RESERVE as movable pages so we can get those
>  	 * areas back if necessary. Otherwise, we may have to free
>  	 * excessively into the page allocator
> +	 *
> +	 * Still, do not change migration type of MIGRATE_CMA pages (if
> +	 * they'd be recorded as MIGRATE_MOVABLE an unmovable page could
> +	 * be allocated from MIGRATE_CMA block and we don't want to allow
> +	 * that).  In this respect, treat MIGRATE_CMA like
> +	 * MIGRATE_ISOLATE.
>  	 */
>  	if (migratetype >= MIGRATE_PCPTYPES) {
> -		if (unlikely(migratetype == MIGRATE_ISOLATE)) {
> +		if (unlikely(migratetype == MIGRATE_ISOLATE
> +			  || is_migrate_cma(migratetype))) {
>  			free_one_page(zone, page, 0, migratetype);
>  			goto out;
>  		}

Doesn't this add *BAD* performance impact for usual use of pages marked as
MIGRATE_CMA ? IIUC, All pcp pages must be _drained_ at page migration after
making migrate_type as ISOLATED. So, this change should be unnecessary.

BTW, How about changing MIGRATE_CMA < MIGRATE_PCPTYPES ? and allow to have
it's own pcp list ?

I think
==
 again:
         if (likely(order == 0)) {
                 struct per_cpu_pages *pcp;
                 struct list_head *list; 
 
                 local_irq_save(flags);
                 pcp = &this_cpu_ptr(zone->pageset)->pcp;
                 list = &pcp->lists[migratetype];
                 if (list_empty(list)) {
                         pcp->count += rmqueue_bulk(zone, 0,
                                         pcp->batch, list,
                                         migratetype, cold);
                         if (unlikely(list_empty(list))) {
+				 if (migrate_type == MIGRATE_MOVABLE) { /*allow extra fallback*/
+					migrate_type == MIGRATE_CMA
+					goto again;
+			 	}
+			 }
                                 goto failed;
                 }

                if (cold)
                        page = list_entry(list->prev, struct page, lru);
                else
                        page = list_entry(list->next, struct page, lru);

                list_del(&page->lru);
                pcp->count--;
==
Will work enough as a fallback path which allows to allocate a memory from CMA area
if there aren't enough free pages. (and makes FALLBACK type as)

fallbacks[MIGRATE_CMA] = {?????},

for no fallbacks.


> @@ -1272,7 +1325,8 @@ int split_free_page(struct page *page)
>  	if (order >= pageblock_order - 1) {
>  		struct page *endpage = page + (1 << order) - 1;
>  		for (; page < endpage; page += pageblock_nr_pages)
> -			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
> +			if (!is_pageblock_cma(page))
> +				set_pageblock_migratetype(page, MIGRATE_MOVABLE);
>  	}
>  
>  	return 1 << order;
> @@ -5366,6 +5420,15 @@ int set_migratetype_isolate(struct page *page)
>  	zone_idx = zone_idx(zone);
>  
>  	spin_lock_irqsave(&zone->lock, flags);
> +	/*
> +	 * Treat MIGRATE_CMA specially since it may contain immobile
> +	 * CMA pages -- that's fine.  CMA is likely going to touch
> +	 * only the mobile pages in the pageblokc.
> +	 */
> +	if (is_pageblock_cma(page)) {
> +		ret = 0;
> +		goto out;
> +	}
>  
>  	pfn = page_to_pfn(page);
>  	arg.start_pfn = pfn;

Hmm, I'm not sure why you dont' have any change in __free_one_page() which overwrite
pageblock type. Is MIGRATE_CMA range is aligned to MAX_ORDER ? If so, please mention
about it in patch description or comment because of the patch order.


Thanks,
-Kame



