Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64126 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab1JNXfU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 19:35:20 -0400
Date: Fri, 14 Oct 2011 16:35:16 -0700
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
	Dave Hansen <dave@linux.vnet.ibm.com>,
	Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 3/9] mm: alloc_contig_range() added
Message-Id: <20111014163516.7d19a61a.akpm@linux-foundation.org>
In-Reply-To: <1317909290-29832-4-git-send-email-m.szyprowski@samsung.com>
References: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com>
	<1317909290-29832-4-git-send-email-m.szyprowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 06 Oct 2011 15:54:43 +0200
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> From: Michal Nazarewicz <m.nazarewicz@samsung.com>
> 
> This commit adds the alloc_contig_range() function which tries
> to allocate given range of pages.  It tries to migrate all
> already allocated pages that fall in the range thus freeing them.
> Once all pages in the range are freed they are removed from the
> buddy system thus allocated for the caller to use.
> 
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> [m.szyprowski: renamed some variables for easier code reading]
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> CC: Michal Nazarewicz <mina86@mina86.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Where-is: Mel Gorman <mel@csn.ul.ie>

> +#define MIGRATION_RETRY	5
> +static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
> +{
> +	int migration_failed = 0, ret;
> +	unsigned long pfn = start;
> +
> +	/*
> +	 * Some code "borrowed" from KAMEZAWA Hiroyuki's
> +	 * __alloc_contig_pages().
> +	 */
> +
> +	/* drop all pages in pagevec and pcp list */
> +	lru_add_drain_all();
> +	drain_all_pages();

These operations are sometimes wrong ;) Have you confirmed that we
really need to perform them here?  If so, a little comment explaining
why we're using them here would be good.

> +	for (;;) {
> +		pfn = scan_lru_pages(pfn, end);
> +		if (!pfn || pfn >= end)
> +			break;
> +
> +		ret = do_migrate_range(pfn, end);
> +		if (!ret) {
> +			migration_failed = 0;
> +		} else if (ret != -EBUSY
> +			|| ++migration_failed >= MIGRATION_RETRY) {

Sigh, magic numbers.

Have you ever seen this retry loop actually expire in testing?

migrate_pages() tries ten times.  This code tries five times.  Is there
any science to all of this?

> +			return ret;
> +		} else {
> +			/* There are unstable pages.on pagevec. */
> +			lru_add_drain_all();
> +			/*
> +			 * there may be pages on pcplist before
> +			 * we mark the range as ISOLATED.
> +			 */
> +			drain_all_pages();
> +		}
> +		cond_resched();
> +	}
> +
> +	if (!migration_failed) {
> +		/* drop all pages in pagevec and pcp list */
> +		lru_add_drain_all();
> +		drain_all_pages();

hm.

> +	}
> +
> +	/* Make sure all pages are isolated */
> +	if (WARN_ON(test_pages_isolated(start, end)))
> +		return -EBUSY;
> +
> +	return 0;
> +}
> +
> +/**
> + * alloc_contig_range() -- tries to allocate given range of pages
> + * @start:	start PFN to allocate
> + * @end:	one-past-the-last PFN to allocate
> + * @flags:	flags passed to alloc_contig_freed_pages().
> + *
> + * The PFN range does not have to be pageblock or MAX_ORDER_NR_PAGES
> + * aligned, hovewer it's callers responsibility to guarantee that we

"however"

"however it is the caller's responsibility.."

> + * are the only thread that changes migrate type of pageblocks the
> + * pages fall in.
> + *
> + * Returns zero on success or negative error code.  On success all
> + * pages which PFN is in (start, end) are allocated for the caller and
> + * need to be freed with free_contig_pages().
> + */
>
> ...
>

