Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57648 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab2AZJBG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 04:01:06 -0500
Date: Thu, 26 Jan 2012 10:00:49 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 07/15] mm: page_alloc: change fallbacks array handling
In-reply-to: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
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
	Benjamin Gaignard <benjamin.gaignard@linaro.org>
Message-id: <1327568457-27734-8-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Michal Nazarewicz <mina86@mina86.com>

This commit adds a row for MIGRATE_ISOLATE type to the fallbacks array
which was missing from it.  It also, changes the array traversal logic
a little making MIGRATE_RESERVE an end marker.  The letter change,
removes the implicit MIGRATE_UNMOVABLE from the end of each row which
was read by __rmqueue_fallback() function.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 mm/page_alloc.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b4f50532..0a9cc8e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -875,11 +875,12 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
  * This array describes the order lists are fallen back to when
  * the free lists for the desirable migrate type are depleted
  */
-static int fallbacks[MIGRATE_TYPES][MIGRATE_TYPES-1] = {
+static int fallbacks[MIGRATE_TYPES][3] = {
 	[MIGRATE_UNMOVABLE]   = { MIGRATE_RECLAIMABLE, MIGRATE_MOVABLE,   MIGRATE_RESERVE },
 	[MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE,   MIGRATE_RESERVE },
 	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE, MIGRATE_RESERVE },
-	[MIGRATE_RESERVE]     = { MIGRATE_RESERVE,     MIGRATE_RESERVE,   MIGRATE_RESERVE }, /* Never used */
+	[MIGRATE_RESERVE]     = { MIGRATE_RESERVE }, /* Never used */
+	[MIGRATE_ISOLATE]     = { MIGRATE_RESERVE }, /* Never used */
 };
 
 /*
@@ -974,12 +975,12 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
 	/* Find the largest possible block of pages in the other list */
 	for (current_order = MAX_ORDER-1; current_order >= order;
 						--current_order) {
-		for (i = 0; i < MIGRATE_TYPES - 1; i++) {
+		for (i = 0;; i++) {
 			migratetype = fallbacks[start_migratetype][i];
 
 			/* MIGRATE_RESERVE handled later if necessary */
 			if (migratetype == MIGRATE_RESERVE)
-				continue;
+				break;
 
 			area = &(zone->free_area[current_order]);
 			if (list_empty(&area->free_list[migratetype]))
-- 
1.7.1.569.g6f426

