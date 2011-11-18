Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37537 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758178Ab1KRQna (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Nov 2011 11:43:30 -0500
Date: Fri, 18 Nov 2011 17:43:14 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 07/11] mm: page_isolation: MIGRATE_CMA isolation functions added
In-reply-to: <1321634598-16859-1-git-send-email-m.szyprowski@samsung.com>
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
	Chunsang Jeong <chunsang.jeong@linaro.org>,
	Dave Hansen <dave@linux.vnet.ibm.com>
Message-id: <1321634598-16859-8-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1321634598-16859-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Michal Nazarewicz <mina86@mina86.com>

This commit changes various functions that change pages and
pageblocks migrate type between MIGRATE_ISOLATE and
MIGRATE_MOVABLE in such a way as to allow to work with
MIGRATE_CMA migrate type.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 include/linux/page-isolation.h |   23 ++++++++++++-----------
 mm/memory-failure.c            |    2 +-
 mm/memory_hotplug.c            |    6 +++---
 mm/page_alloc.c                |   18 ++++++++++++------
 mm/page_isolation.c            |   15 ++++++++-------
 5 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/include/linux/page-isolation.h b/include/linux/page-isolation.h
index af650db..c8004dc 100644
--- a/include/linux/page-isolation.h
+++ b/include/linux/page-isolation.h
@@ -3,7 +3,7 @@
 
 /*
  * Changes migrate type in [start_pfn, end_pfn) to be MIGRATE_ISOLATE.
- * If specified range includes migrate types other than MOVABLE,
+ * If specified range includes migrate types other than MOVABLE or CMA,
  * this will fail with -EBUSY.
  *
  * For isolating all pages in the range finally, the caller have to
@@ -11,30 +11,31 @@
  * test it.
  */
 extern int
-start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn);
+start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
+			 unsigned migratetype);
 
 /*
  * Changes MIGRATE_ISOLATE to MIGRATE_MOVABLE.
  * target range is [start_pfn, end_pfn)
  */
 extern int
-undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn);
+undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
+			unsigned migratetype);
 
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
+void unset_migratetype_isolate(struct page *page, unsigned migratetype);
 
 /* The below functions must be run on a range from a single zone. */
-int alloc_contig_range(unsigned long start, unsigned long end);
+int alloc_contig_range(unsigned long start, unsigned long end,
+		       unsigned migratetype);
 void free_contig_range(unsigned long pfn, unsigned nr_pages);
 
 /* CMA stuff */
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 06d3479..3cf809d 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1400,7 +1400,7 @@ static int get_any_page(struct page *p, unsigned long pfn, int flags)
 		/* Not a free page */
 		ret = 1;
 	}
-	unset_migratetype_isolate(p);
+	unset_migratetype_isolate(p, MIGRATE_MOVABLE);
 	unlock_memory_hotplug();
 	return ret;
 }
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 2168489..2a44d55 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -891,7 +891,7 @@ static int __ref offline_pages(unsigned long start_pfn,
 	nr_pages = end_pfn - start_pfn;
 
 	/* set above range as isolated */
-	ret = start_isolate_page_range(start_pfn, end_pfn);
+	ret = start_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
 	if (ret)
 		goto out;
 
@@ -956,7 +956,7 @@ repeat:
 	   We cannot do rollback at this point. */
 	offline_isolated_pages(start_pfn, end_pfn);
 	/* reset pagetype flags and makes migrate type to be MOVABLE */
-	undo_isolate_page_range(start_pfn, end_pfn);
+	undo_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
 	/* removal success */
 	zone->present_pages -= offlined_pages;
 	zone->zone_pgdat->node_present_pages -= offlined_pages;
@@ -981,7 +981,7 @@ failed_removal:
 		start_pfn, end_pfn);
 	memory_notify(MEM_CANCEL_OFFLINE, &arg);
 	/* pushback to free area */
-	undo_isolate_page_range(start_pfn, end_pfn);
+	undo_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
 
 out:
 	unlock_memory_hotplug();
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9ec73f4..714b1c1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5710,7 +5710,7 @@ out:
 	return ret;
 }
 
-void unset_migratetype_isolate(struct page *page)
+void unset_migratetype_isolate(struct page *page, unsigned migratetype)
 {
 	struct zone *zone;
 	unsigned long flags;
@@ -5718,8 +5718,8 @@ void unset_migratetype_isolate(struct page *page)
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
@@ -5842,6 +5842,10 @@ done:
  * alloc_contig_range() -- tries to allocate given range of pages
  * @start:	start PFN to allocate
  * @end:	one-past-the-last PFN to allocate
+ * @migratetype:	migratetype of the underlaying pageblocks (either
+ *			#MIGRATE_MOVABLE or #MIGRATE_CMA).  All pageblocks
+ *			in range must have the same migratetype and it must
+ *			be either of the two.
  *
  * The PFN range does not have to be pageblock or MAX_ORDER_NR_PAGES
  * aligned, hovewer it's callers responsibility to guarantee that we
@@ -5852,7 +5856,8 @@ done:
  * pages which PFN is in (start, end) are allocated for the caller and
  * need to be freed with free_contig_range().
  */
-int alloc_contig_range(unsigned long start, unsigned long end)
+int alloc_contig_range(unsigned long start, unsigned long end,
+		       unsigned migratetype)
 {
 	unsigned long outer_start, outer_end;
 	int ret;
@@ -5881,7 +5886,8 @@ int alloc_contig_range(unsigned long start, unsigned long end)
 	 */
 
 	ret = start_isolate_page_range(pfn_align_to_maxpage_down(start),
-				       pfn_align_to_maxpage_up(end));
+				       pfn_align_to_maxpage_up(end),
+				       migratetype);
 	if (ret)
 		goto done;
 
@@ -5928,7 +5934,7 @@ int alloc_contig_range(unsigned long start, unsigned long end)
 	ret = 0;
 done:
 	undo_isolate_page_range(pfn_align_to_maxpage_down(start),
-				pfn_align_to_maxpage_up(end));
+				pfn_align_to_maxpage_up(end), migratetype);
 	return ret;
 }
 
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 4ae42bb..c9f0477 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -24,6 +24,7 @@ __first_valid_page(unsigned long pfn, unsigned long nr_pages)
  * to be MIGRATE_ISOLATE.
  * @start_pfn: The lower PFN of the range to be isolated.
  * @end_pfn: The upper PFN of the range to be isolated.
+ * @migratetype: migrate type to set in error recovery.
  *
  * Making page-allocation-type to be MIGRATE_ISOLATE means free pages in
  * the range will never be allocated. Any free pages and pages freed in the
@@ -32,8 +33,8 @@ __first_valid_page(unsigned long pfn, unsigned long nr_pages)
  * start_pfn/end_pfn must be aligned to pageblock_order.
  * Returns 0 on success and -EBUSY if any part of range cannot be isolated.
  */
-int
-start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn)
+int start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
+			     unsigned migratetype)
 {
 	unsigned long pfn;
 	unsigned long undo_pfn;
@@ -56,7 +57,7 @@ undo:
 	for (pfn = start_pfn;
 	     pfn < undo_pfn;
 	     pfn += pageblock_nr_pages)
-		unset_migratetype_isolate(pfn_to_page(pfn));
+		unset_migratetype_isolate(pfn_to_page(pfn), migratetype);
 
 	return -EBUSY;
 }
@@ -64,8 +65,8 @@ undo:
 /*
  * Make isolated pages available again.
  */
-int
-undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn)
+int undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
+			    unsigned migratetype)
 {
 	unsigned long pfn;
 	struct page *page;
@@ -77,7 +78,7 @@ undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn)
 		page = __first_valid_page(pfn, pageblock_nr_pages);
 		if (!page || get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
 			continue;
-		unset_migratetype_isolate(page);
+		unset_migratetype_isolate(page, migratetype);
 	}
 	return 0;
 }
@@ -86,7 +87,7 @@ undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn)
  * all pages in [start_pfn...end_pfn) must be in the same zone.
  * zone->lock must be held before call this.
  *
- * Returns 1 if all pages in the range is isolated.
+ * Returns 1 if all pages in the range are isolated.
  */
 static int
 __test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn)
-- 
1.7.1.569.g6f426

