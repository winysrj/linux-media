Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42902 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab2BCMTJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2012 07:19:09 -0500
Date: Fri, 03 Feb 2012 13:18:49 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 06/15] mm: page_alloc: introduce alloc_contig_range()
In-reply-to: <1328271538-14502-1-git-send-email-m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Russell King <linux@arm.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Daniel Walker <dwalker@codeaurora.org>,
	Mel Gorman <mel@csn.ul.ie>, Arnd Bergmann <arnd@arndb.de>,
	Jesse Barker <jesse.barker@linaro.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shariq Hasnain <shariq.hasnain@linaro.org>,
	Chunsang Jeong <chunsang.jeong@linaro.org>,
	Dave Hansen <dave@linux.vnet.ibm.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Rob Clark <rob.clark@linaro.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
Message-id: <1328271538-14502-7-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1328271538-14502-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Michal Nazarewicz <mina86@mina86.com>

This commit adds the alloc_contig_range() function which tries
to allocate given range of pages.  It tries to migrate all
already allocated pages that fall in the range thus freeing them.
Once all pages in the range are freed they are removed from the
buddy system thus allocated for the caller to use.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Tested-by: Rob Clark <rob.clark@linaro.org>
Tested-by: Ohad Ben-Cohen <ohad@wizery.com>
Tested-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 include/linux/gfp.h |    8 ++
 mm/page_alloc.c     |  185 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 193 insertions(+), 0 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 581e74b..052a5b6 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -391,4 +391,12 @@ static inline bool pm_suspended_storage(void)
 }
 #endif /* CONFIG_PM_SLEEP */
 
+#ifdef CONFIG_CMA
+
+/* The below functions must be run on a range from a single zone. */
+extern int alloc_contig_range(unsigned long start, unsigned long end);
+extern void free_contig_range(unsigned long pfn, unsigned nr_pages);
+
+#endif
+
 #endif /* __LINUX_GFP_H */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7fe7697..9006e69 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -57,6 +57,7 @@
 #include <linux/ftrace_event.h>
 #include <linux/memcontrol.h>
 #include <linux/prefetch.h>
+#include <linux/migrate.h>
 #include <linux/page-debug-flags.h>
 
 #include <asm/tlbflush.h>
@@ -5505,6 +5506,190 @@ out:
 	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
+#ifdef CONFIG_CMA
+
+static unsigned long pfn_align_to_maxpage_down(unsigned long pfn)
+{
+	return pfn & ~(MAX_ORDER_NR_PAGES - 1);
+}
+
+static unsigned long pfn_align_to_maxpage_up(unsigned long pfn)
+{
+	return ALIGN(pfn, MAX_ORDER_NR_PAGES);
+}
+
+static struct page *
+__alloc_contig_migrate_alloc(struct page *page, unsigned long private,
+			     int **resultp)
+{
+	return alloc_page(GFP_HIGHUSER_MOVABLE);
+}
+
+/* [start, end) must belong to a single zone. */
+static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
+{
+	/* This function is based on compact_zone() from compaction.c. */
+
+	unsigned long pfn = start;
+	unsigned int tries = 0;
+	int ret = 0;
+
+	struct compact_control cc = {
+		.nr_migratepages = 0,
+		.order = -1,
+		.zone = page_zone(pfn_to_page(start)),
+		.sync = true,
+	};
+	INIT_LIST_HEAD(&cc.migratepages);
+
+	migrate_prep_local();
+
+	while (pfn < end || !list_empty(&cc.migratepages)) {
+		if (fatal_signal_pending(current)) {
+			ret = -EINTR;
+			break;
+		}
+
+		if (list_empty(&cc.migratepages)) {
+			cc.nr_migratepages = 0;
+			pfn = isolate_migratepages_range(cc.zone, &cc,
+							 pfn, end);
+			if (!pfn) {
+				ret = -EINTR;
+				break;
+			}
+			tries = 0;
+		} else if (++tries == 5) {
+			ret = ret < 0 ? ret : -EBUSY;
+			break;
+		}
+
+		ret = migrate_pages(&cc.migratepages,
+				    __alloc_contig_migrate_alloc,
+				    0, false, true);
+	}
+
+	putback_lru_pages(&cc.migratepages);
+	return ret > 0 ? 0 : ret;
+}
+
+/**
+ * alloc_contig_range() -- tries to allocate given range of pages
+ * @start:	start PFN to allocate
+ * @end:	one-past-the-last PFN to allocate
+ *
+ * The PFN range does not have to be pageblock or MAX_ORDER_NR_PAGES
+ * aligned, however it's the caller's responsibility to guarantee that
+ * we are the only thread that changes migrate type of pageblocks the
+ * pages fall in.
+ *
+ * The PFN range must belong to a single zone.
+ *
+ * Returns zero on success or negative error code.  On success all
+ * pages which PFN is in [start, end) are allocated for the caller and
+ * need to be freed with free_contig_range().
+ */
+int alloc_contig_range(unsigned long start, unsigned long end)
+{
+	struct zone *zone = page_zone(pfn_to_page(start));
+	unsigned long outer_start, outer_end;
+	int ret = 0, order;
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
+	ret = start_isolate_page_range(pfn_align_to_maxpage_down(start),
+				       pfn_align_to_maxpage_up(end));
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
+	 *
+	 * We don't have to hold zone->lock here because the pages are
+	 * isolated thus they won't get removed from buddy.
+	 */
+
+	lru_add_drain_all();
+	drain_all_pages();
+
+	order = 0;
+	outer_start = start;
+	while (!PageBuddy(pfn_to_page(outer_start))) {
+		if (++order >= MAX_ORDER) {
+			ret = -EBUSY;
+			goto done;
+		}
+		outer_start &= ~0UL << order;
+	}
+
+	/* Make sure the range is really isolated. */
+	if (test_pages_isolated(outer_start, end)) {
+		pr_warn("alloc_contig_range test_pages_isolated(%lx, %lx) failed\n",
+		       outer_start, end);
+		ret = -EBUSY;
+		goto done;
+	}
+
+	outer_end = isolate_freepages_range(outer_start, end);
+	if (!outer_end) {
+		ret = -EBUSY;
+		goto done;
+	}
+
+	/* Free head and tail (if any) */
+	if (start != outer_start)
+		free_contig_range(outer_start, start - outer_start);
+	if (end != outer_end)
+		free_contig_range(end, outer_end - end);
+
+done:
+	undo_isolate_page_range(pfn_align_to_maxpage_down(start),
+				pfn_align_to_maxpage_up(end));
+	return ret;
+}
+
+void free_contig_range(unsigned long pfn, unsigned nr_pages)
+{
+	for (; nr_pages--; ++pfn)
+		__free_page(pfn_to_page(pfn));
+}
+#endif
+
 #ifdef CONFIG_MEMORY_HOTREMOVE
 /*
  * All pages in the range must be isolated before calling this.
-- 
1.7.1.569.g6f426

