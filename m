Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16613 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab2BQTdt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 14:33:49 -0500
Date: Fri, 17 Feb 2012 20:30:23 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCHv22 03/16] mm: compaction: introduce map_pages()
In-reply-to: <1329507036-24362-1-git-send-email-m.szyprowski@samsung.com>
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
Message-id: <1329507036-24362-4-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1329507036-24362-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Michal Nazarewicz <mina86@mina86.com>

This commit creates a map_pages() function which map pages freed
using split_free_pages().  This merely moves some code from
isolate_freepages() so that it can be reused in other places.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: Robert Nelson <robertcnelson@gmail.com>
---
 mm/compaction.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 72f8685..de22893 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -127,6 +127,16 @@ static bool suitable_migration_target(struct page *page)
 	return false;
 }
 
+static void map_pages(struct list_head *list)
+{
+	struct page *page;
+
+	list_for_each_entry(page, list, lru) {
+		arch_alloc_page(page, 0);
+		kernel_map_pages(page, 1, 1);
+	}
+}
+
 /*
  * Based on information in the current compact_control, find blocks
  * suitable for isolating free pages from and then isolate them.
@@ -206,10 +216,7 @@ static void isolate_freepages(struct zone *zone,
 	}
 
 	/* split_free_page does not map the pages */
-	list_for_each_entry(page, freelist, lru) {
-		arch_alloc_page(page, 0);
-		kernel_map_pages(page, 1, 1);
-	}
+	map_pages(freelist);
 
 	cc->free_pfn = high_pfn;
 	cc->nr_freepages = nr_freepages;
-- 
1.7.1


