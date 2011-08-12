Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:50039 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab1HLK6j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2011 06:58:39 -0400
Date: Fri, 12 Aug 2011 12:58:25 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 3/9] mm: alloc_contig_range() added
In-reply-to: <1313146711-1767-1-git-send-email-m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Russell King <linux@arm.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Ankita Garg <ankita@in.ibm.com>,
	Daniel Walker <dwalker@codeaurora.org>,
	Mel Gorman <mel@csn.ul.ie>, Arnd Bergmann <arnd@arndb.de>,
	Jesse Barker <jesse.barker@linaro.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shariq Hasnain <shariq.hasnain@linaro.org>,
	Chunsang Jeong <chunsang.jeong@linaro.org>
Message-id: <1313146711-1767-4-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1313146711-1767-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Michal Nazarewicz <m.nazarewicz@samsung.com>

This commit adds the alloc_contig_range() function which tries
to allecate given range of pages.  It tries to migrate all
already allocated pages that fall in the range thus freeing them.
Once all pages in the range are freed they are removed from the
buddy system thus allocated for the caller to use.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
[m.szyprowski: renamed some variables for easier code reading]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Michal Nazarewicz <mina86@mina86.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/page-isolation.h |    2 +
 mm/page_alloc.c                |  144 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 146 insertions(+), 0 deletions(-)

diff --git a/include/linux/page-isolation.h b/include/linux/page-isolation.h
index f1417ed..c5d1a7c 100644
--- a/include/linux/page-isolation.h
+++ b/include/linux/page-isolation.h
@@ -34,6 +34,8 @@ extern int set_migratetype_isolate(struct page *page);
 extern void unset_migratetype_isolate(struct page *page);
 extern unsigned long alloc_contig_freed_pages(unsigned long start,
 					      unsigned long end, gfp_t flag);
+extern int alloc_contig_range(unsigned long start, unsigned long end,
+			      gfp_t flags);
 extern void free_contig_pages(struct page *page, int nr_pages);
 
 /*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ad6ae3f..35423c2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5706,6 +5706,150 @@ unsigned long alloc_contig_freed_pages(unsigned long start, unsigned long end,
 	return pfn;
 }
 
+static unsigned long pfn_to_maxpage(unsigned long pfn)
+{
+	return pfn & ~(MAX_ORDER_NR_PAGES - 1);
+}
+
+static unsigned long pfn_to_maxpage_up(unsigned long pfn)
+{
+	return ALIGN(pfn, MAX_ORDER_NR_PAGES);
+}
+
+#define MIGRATION_RETRY	5
+static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
+{
+	int migration_failed = 0, ret;
+	unsigned long pfn = start;
+
+	/*
+	 * Some code "borrowed" from KAMEZAWA Hiroyuki's
+	 * __alloc_contig_pages().
+	 */
+
+	for (;;) {
+		pfn = scan_lru_pages(pfn, end);
+		if (!pfn || pfn >= end)
+			break;
+
+		ret = do_migrate_range(pfn, end);
+		if (!ret) {
+			migration_failed = 0;
+		} else if (ret != -EBUSY
+			|| ++migration_failed >= MIGRATION_RETRY) {
+			return ret;
+		} else {
+			/* There are unstable pages.on pagevec. */
+			lru_add_drain_all();
+			/*
+			 * there may be pages on pcplist before
+			 * we mark the range as ISOLATED.
+			 */
+			drain_all_pages();
+		}
+		cond_resched();
+	}
+
+	if (!migration_failed) {
+		/* drop all pages in pagevec and pcp list */
+		lru_add_drain_all();
+		drain_all_pages();
+	}
+
+	/* Make sure all pages are isolated */
+	if (WARN_ON(test_pages_isolated(start, end)))
+		return -EBUSY;
+
+	return 0;
+}
+
+/**
+ * alloc_contig_range() -- tries to allocate given range of pages
+ * @start:	start PFN to allocate
+ * @end:	one-past-the-last PFN to allocate
+ * @flags:	flags passed to alloc_contig_freed_pages().
+ *
+ * The PFN range does not have to be pageblock or MAX_ORDER_NR_PAGES
+ * aligned, hovewer it's callers responsibility to guarantee that we
+ * are the only thread that changes migrate type of pageblocks the
+ * pages fall in.
+ *
+ * Returns zero on success or negative error code.  On success all
+ * pages which PFN is in (start, end) are allocated for the caller and
+ * need to be freed with free_contig_pages().
+ */
+int alloc_contig_range(unsigned long start, unsigned long end,
+		       gfp_t flags)
+{
+	unsigned long outer_start, outer_end;
+	int ret;
+
+	/*
+	 * What we do here is we mark all pageblocks in range as
+	 * MIGRATE_ISOLATE.  Because of the way page allocator work, we
+	 * align the range to MAX_ORDER pages so that page allocator
+	 * won't try to merge buddies from different pageblocks and
+	 * change MIGRATE_ISOLATE to some other migration type.
+	 *
+	 * Once the pageblocks are marked as MIGRATE_ISOLATE, we
+	 * migrate the pages from an unaligned range (ie. pages that
+	 * we are interested in).  This will put all the pages in
+	 * range back to page allocator as MIGRATE_ISOLATE.
+	 *
+	 * When this is done, we take the pages in range from page
+	 * allocator removing them from the buddy system.  This way
+	 * page allocator will never consider using them.
+	 *
+	 * This lets us mark the pageblocks back as
+	 * MIGRATE_CMA/MIGRATE_MOVABLE so that free pages in the
+	 * MAX_ORDER aligned range but not in the unaligned, original
+	 * range are put back to page allocator so that buddy can use
+	 * them.
+	 */
+
+	ret = start_isolate_page_range(pfn_to_maxpage(start),
+				       pfn_to_maxpage_up(end));
+	if (ret)
+		goto done;
+
+	ret = __alloc_contig_migrate_range(start, end);
+	if (ret)
+		goto done;
+
+	/*
+	 * Pages from [start, end) are within a MAX_ORDER_NR_PAGES
+	 * aligned blocks that are marked as MIGRATE_ISOLATE.  What's
+	 * more, all pages in [start, end) are free in page allocator.
+	 * What we are going to do is to allocate all pages from
+	 * [start, end) (that is remove them from page allocater).
+	 *
+	 * The only problem is that pages at the beginning and at the
+	 * end of interesting range may be not aligned with pages that
+	 * page allocator holds, ie. they can be part of higher order
+	 * pages.  Because of this, we reserve the bigger range and
+	 * once this is done free the pages we are not interested in.
+	 */
+
+	ret = 0;
+	while (!PageBuddy(pfn_to_page(start & (~0UL << ret))))
+		if (WARN_ON(++ret >= MAX_ORDER))
+			return -EINVAL;
+
+	outer_start = start & (~0UL << ret);
+	outer_end   = alloc_contig_freed_pages(outer_start, end, flags);
+
+	/* Free head and tail (if any) */
+	if (start != outer_start)
+		free_contig_pages(pfn_to_page(outer_start), start - outer_start);
+	if (end != outer_end)
+		free_contig_pages(pfn_to_page(end), outer_end - end);
+
+	ret = 0;
+done:
+	undo_isolate_page_range(pfn_to_maxpage(start), pfn_to_maxpage_up(end));
+	return ret;
+}
+
 void free_contig_pages(struct page *page, int nr_pages)
 {
 	for (; nr_pages; --nr_pages, ++page)
-- 
1.7.1.569.g6f426

