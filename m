Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55254 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab2BVQtM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 11:49:12 -0500
Date: Wed, 22 Feb 2012 17:48:53 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCHv23 12/16] mm: trigger page reclaim in alloc_contig_range() to
 stabilise watermarks
In-reply-to: <1329929337-16648-1-git-send-email-m.szyprowski@samsung.com>
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
	Chunsang Jeong <chunsang.jeong@linaro.org>,
	Dave Hansen <dave@linux.vnet.ibm.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Rob Clark <rob.clark@linaro.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
Message-id: <1329929337-16648-13-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1329929337-16648-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

alloc_contig_range() performs memory allocation so it also should keep
track on keeping the correct level of memory watermarks. This commit adds
a call to *_slowpath style reclaim to grab enough pages to make sure that
the final collection of contiguous pages from freelists will not starve
the system.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Michal Nazarewicz <mina86@mina86.com>
Tested-by: Rob Clark <rob.clark@linaro.org>
Tested-by: Ohad Ben-Cohen <ohad@wizery.com>
Tested-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Tested-by: Robert Nelson <robertcnelson@gmail.com>
---
 include/linux/mmzone.h |    9 +++++++
 mm/page_alloc.c        |   62 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 4781f30..77db8c0 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -63,8 +63,10 @@ enum {
 
 #ifdef CONFIG_CMA
 #  define is_migrate_cma(migratetype) unlikely((migratetype) == MIGRATE_CMA)
+#  define cma_wmark_pages(zone)	zone->min_cma_pages
 #else
 #  define is_migrate_cma(migratetype) false
+#  define cma_wmark_pages(zone) 0
 #endif
 
 #define for_each_migratetype_order(order, type) \
@@ -371,6 +373,13 @@ struct zone {
 	/* see spanned/present_pages for more description */
 	seqlock_t		span_seqlock;
 #endif
+#ifdef CONFIG_CMA
+	/*
+	 * CMA needs to increase watermark levels during the allocation
+	 * process to make sure that the system is not starved.
+	 */
+	unsigned long		min_cma_pages;
+#endif
 	struct free_area	free_area[MAX_ORDER];
 
 #ifndef CONFIG_SPARSEMEM
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7a0d286..39cd74f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5092,6 +5092,11 @@ static void __setup_per_zone_wmarks(void)
 					low + (min >> 2);
 		zone->watermark[WMARK_HIGH] = min_wmark_pages(zone) +
 					low + (min >> 1);
+
+		zone->watermark[WMARK_MIN] += cma_wmark_pages(zone);
+		zone->watermark[WMARK_LOW] += cma_wmark_pages(zone);
+		zone->watermark[WMARK_HIGH] += cma_wmark_pages(zone);
+
 		setup_zone_migrate_reserve(zone);
 		spin_unlock_irqrestore(&zone->lock, flags);
 	}
@@ -5695,6 +5700,56 @@ static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
 	return ret > 0 ? 0 : ret;
 }
 
+/*
+ * Update zone's cma pages counter used for watermark level calculation.
+ */
+static inline void __update_cma_watermarks(struct zone *zone, int count)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&zone->lock, flags);
+	zone->min_cma_pages += count;
+	spin_unlock_irqrestore(&zone->lock, flags);
+	setup_per_zone_wmarks();
+}
+
+/*
+ * Trigger memory pressure bump to reclaim some pages in order to be able to
+ * allocate 'count' pages in single page units. Does similar work as
+ *__alloc_pages_slowpath() function.
+ */
+static int __reclaim_pages(struct zone *zone, gfp_t gfp_mask, int count)
+{
+	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
+	struct zonelist *zonelist = node_zonelist(0, gfp_mask);
+	int did_some_progress = 0;
+	int order = 1;
+	unsigned long watermark;
+
+	/*
+	 * Increase level of watermarks to force kswapd do his job
+	 * to stabilise at new watermark level.
+	 */
+	__update_cma_watermarks(zone, count);
+
+	/* Obey watermarks as if the page was being allocated */
+	watermark = low_wmark_pages(zone) + count;
+	while (!zone_watermark_ok(zone, 0, watermark, 0, 0)) {
+		wake_all_kswapd(order, zonelist, high_zoneidx, zone_idx(zone));
+
+		did_some_progress = __perform_reclaim(gfp_mask, order, zonelist,
+						      NULL);
+		if (!did_some_progress) {
+			/* Exhausted what can be done so it's blamo time */
+			out_of_memory(zonelist, gfp_mask, order, NULL);
+		}
+	}
+
+	/* Restore original watermark levels. */
+	__update_cma_watermarks(zone, -count);
+
+	return count;
+}
+
 /**
  * alloc_contig_range() -- tries to allocate given range of pages
  * @start:	start PFN to allocate
@@ -5793,6 +5848,13 @@ int alloc_contig_range(unsigned long start, unsigned long end,
 		goto done;
 	}
 
+	/*
+	 * Reclaim enough pages to make sure that contiguous allocation
+	 * will not starve the system.
+	 */
+	__reclaim_pages(zone, GFP_HIGHUSER_MOVABLE, end-start);
+
+	/* Grab isolated pages from freelists. */
 	outer_end = isolate_freepages_range(outer_start, end);
 	if (!outer_end) {
 		ret = -EBUSY;
-- 
1.7.1.569.g6f426

