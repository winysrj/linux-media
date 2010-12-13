Return-path: <mchehab@gaivota>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:61457 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab0LML1L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 06:27:11 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 13 Dec 2010 12:26:48 +0100
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv7 07/10] mm: MIGRATE_CMA isolation functions added
In-reply-to: <cover.1292004520.git.m.nazarewicz@samsung.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Ankita Garg <ankita@in.ibm.com>,
	BooJin Kim <boojin.kim@samsung.com>,
	Daniel Walker <dwalker@codeaurora.org>,
	Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mel Gorman <mel@csn.ul.ie>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	Michal Nazarewicz <m.nazarewicz@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <de44570cf13cd2043c14b17dd4a4ac268ccd3112.1292004520.git.m.nazarewicz@samsung.com>
References: <cover.1292004520.git.m.nazarewicz@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This commit changes various functions that change pages and
pageblocks migrate type between MIGRATE_ISOLATE and
MIGRATE_MOVABLE in such a way as to allow to work with
MIGRATE_CMA migrate type.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/page-isolation.h |   39 ++++++++++++++++++++++++++-------------
 mm/page_alloc.c                |    6 +++---
 mm/page_isolation.c            |   15 ++++++++-------
 3 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/include/linux/page-isolation.h b/include/linux/page-isolation.h
index f1417ed..56f0e13 100644
--- a/include/linux/page-isolation.h
+++ b/include/linux/page-isolation.h
@@ -3,35 +3,49 @@
 
 /*
  * Changes migrate type in [start_pfn, end_pfn) to be MIGRATE_ISOLATE.
- * If specified range includes migrate types other than MOVABLE,
+ * If specified range includes migrate types other than MOVABLE or CMA,
  * this will fail with -EBUSY.
  *
  * For isolating all pages in the range finally, the caller have to
  * free all pages in the range. test_page_isolated() can be used for
  * test it.
  */
-extern int
-start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn);
+int __start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
+			       unsigned migratetype);
+
+static inline int
+start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn)
+{
+	return __start_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
+}
+
+int __undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
+			      unsigned migratetype);
 
 /*
  * Changes MIGRATE_ISOLATE to MIGRATE_MOVABLE.
  * target range is [start_pfn, end_pfn)
  */
-extern int
-undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn);
+static inline int
+undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn)
+{
+	return __undo_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
+}
 
 /*
- * test all pages in [start_pfn, end_pfn)are isolated or not.
+ * Test all pages in [start_pfn, end_pfn) are isolated or not.
  */
-extern int
-test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn);
+int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn);
 
 /*
- * Internal funcs.Changes pageblock's migrate type.
- * Please use make_pagetype_isolated()/make_pagetype_movable().
+ * Internal functions. Changes pageblock's migrate type.
  */
-extern int set_migratetype_isolate(struct page *page);
-extern void unset_migratetype_isolate(struct page *page);
+int set_migratetype_isolate(struct page *page);
+void __unset_migratetype_isolate(struct page *page, unsigned migratetype);
+static inline void unset_migratetype_isolate(struct page *page)
+{
+	__unset_migratetype_isolate(page, MIGRATE_MOVABLE);
+}
 extern unsigned long alloc_contig_freed_pages(unsigned long start,
 					      unsigned long end, gfp_t flag);
 extern void free_contig_pages(struct page *page, int nr_pages);
@@ -39,7 +53,6 @@ extern void free_contig_pages(struct page *page, int nr_pages);
 /*
  * For migration.
  */
-
 int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn);
 unsigned long scan_lru_pages(unsigned long start, unsigned long end);
 int do_migrate_range(unsigned long start_pfn, unsigned long end_pfn);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 537d1f6..084f1a9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5474,7 +5474,7 @@ out:
 	return ret;
 }
 
-void unset_migratetype_isolate(struct page *page)
+void __unset_migratetype_isolate(struct page *page, unsigned migratetype)
 {
 	struct zone *zone;
 	unsigned long flags;
@@ -5482,8 +5482,8 @@ void unset_migratetype_isolate(struct page *page)
 	spin_lock_irqsave(&zone->lock, flags);
 	if (get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
 		goto out;
-	set_pageblock_migratetype(page, MIGRATE_MOVABLE);
-	move_freepages_block(zone, page, MIGRATE_MOVABLE);
+	set_pageblock_migratetype(page, migratetype);
+	move_freepages_block(zone, page, migratetype);
 out:
 	spin_unlock_irqrestore(&zone->lock, flags);
 }
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 077cf19..ea9781e 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -23,10 +23,11 @@ __first_valid_page(unsigned long pfn, unsigned long nr_pages)
 }
 
 /*
- * start_isolate_page_range() -- make page-allocation-type of range of pages
+ * __start_isolate_page_range() -- make page-allocation-type of range of pages
  * to be MIGRATE_ISOLATE.
  * @start_pfn: The lower PFN of the range to be isolated.
  * @end_pfn: The upper PFN of the range to be isolated.
+ * @migratetype: migrate type to set in error recovery.
  *
  * Making page-allocation-type to be MIGRATE_ISOLATE means free pages in
  * the range will never be allocated. Any free pages and pages freed in the
@@ -35,8 +36,8 @@ __first_valid_page(unsigned long pfn, unsigned long nr_pages)
  * start_pfn/end_pfn must be aligned to pageblock_order.
  * Returns 0 on success and -EBUSY if any part of range cannot be isolated.
  */
-int
-start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn)
+int __start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
+			       unsigned migratetype)
 {
 	unsigned long pfn;
 	unsigned long undo_pfn;
@@ -59,7 +60,7 @@ undo:
 	for (pfn = start_pfn;
 	     pfn < undo_pfn;
 	     pfn += pageblock_nr_pages)
-		unset_migratetype_isolate(pfn_to_page(pfn));
+		__unset_migratetype_isolate(pfn_to_page(pfn), migratetype);
 
 	return -EBUSY;
 }
@@ -67,8 +68,8 @@ undo:
 /*
  * Make isolated pages available again.
  */
-int
-undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn)
+int __undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
+			      unsigned migratetype)
 {
 	unsigned long pfn;
 	struct page *page;
@@ -80,7 +81,7 @@ undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn)
 		page = __first_valid_page(pfn, pageblock_nr_pages);
 		if (!page || get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
 			continue;
-		unset_migratetype_isolate(page);
+		__unset_migratetype_isolate(page, migratetype);
 	}
 	return 0;
 }
-- 
1.7.2.3

