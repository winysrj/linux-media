Return-path: <mchehab@gaivota>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25566 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab0KSP6b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 10:58:31 -0500
Date: Fri, 19 Nov 2010 16:58:07 +0100
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [RFCv6 09/13] mm: alloc_contig_free_pages() added
In-reply-to: <cover.1290172312.git.m.nazarewicz@samsung.com>
To: mina86@mina86.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Ankita Garg <ankita@in.ibm.com>,
	Bryan Huntsman <bryanh@codeaurora.org>,
	Daniel Walker <dwalker@codeaurora.org>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Johan Mossberg <johan.xx.mossberg@stericsson.com>,
	Jonathan Corbet <corbet@lwn.net>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Marcus LORENTZON <marcus.xm.lorentzon@stericsson.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Mel Gorman <mel@csn.ul.ie>, Pawel Osciak <pawel@osciak.com>,
	Russell King <linux@arm.linux.org.uk>,
	Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
	Zach Pfeffer <zpfeffer@codeaurora.org>, dipankar@in.ibm.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org
Message-id: <a9658e48e1bdb78788f50e28e9e44d41cce1cf98.1290172312.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1290172312.git.m.nazarewicz@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This commit introduces alloc_contig_free_pages() function
which allocates (ie. removes from buddy system) free pages
in range.  Caller has to guarantee that all pages in range
are in buddy system.

Along with alloc_contig_free_pages(), a free_contig_pages()
function is provided which frees (or a subset of) pages
allocated with alloc_contig_free_pages().

I, Michal Nazarewicz, have modified the
alloc_contig_free_pages() function slightly from the original
version, mostly to make it easier to allocate note MAX_ORDER
aligned pages.  This is done by making the function return
a pfn of a page one past the one allocated which may be
further then caller requested.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/page-isolation.h |    3 ++
 mm/page_alloc.c                |   42 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/include/linux/page-isolation.h b/include/linux/page-isolation.h
index 58cdbac..f1417ed 100644
--- a/include/linux/page-isolation.h
+++ b/include/linux/page-isolation.h
@@ -32,6 +32,9 @@ test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn);
  */
 extern int set_migratetype_isolate(struct page *page);
 extern void unset_migratetype_isolate(struct page *page);
+extern unsigned long alloc_contig_freed_pages(unsigned long start,
+					      unsigned long end, gfp_t flag);
+extern void free_contig_pages(struct page *page, int nr_pages);
 
 /*
  * For migration.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 07a6544..6dd2854 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5424,6 +5424,48 @@ out:
 	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
+unsigned long alloc_contig_freed_pages(unsigned long start,
+				       unsigned long end, gfp_t flag)
+{
+	unsigned long pfn = start, count;
+	struct page *page;
+	struct zone *zone;
+	int order;
+
+	VM_BUG_ON(!pfn_valid(pfn));
+	page = pfn_to_page(pfn);
+
+	zone = page_zone(page);
+	spin_lock_irq(&zone->lock);
+	for (;;) {
+		VM_BUG_ON(page_count(page) || !PageBuddy(page));
+		list_del(&page->lru);
+		order = page_order(page);
+		zone->free_area[order].nr_free--;
+		rmv_page_order(page);
+		__mod_zone_page_state(zone, NR_FREE_PAGES, -(1UL << order));
+		pfn  += 1 << order;
+		if (pfn >= end)
+			break;
+		VM_BUG_ON(!pfn_valid(pfn));
+		page += 1 << order;
+	}
+	spin_unlock_irq(&zone->lock);
+
+	/* After this, pages in the range can be freed one be one */
+	page = pfn_to_page(start);
+	for (count = pfn - start; count; --count, ++page)
+		prep_new_page(page, 0, flag);
+
+	return pfn;
+}
+
+void free_contig_pages(struct page *page, int nr_pages)
+{
+	for (; nr_pages; --nr_pages, ++page)
+		__free_page(page);
+}
+
 #ifdef CONFIG_MEMORY_HOTREMOVE
 /*
  * All pages in the range must be isolated before calling this.
-- 
1.7.2.3

