Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:33495 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933706AbcJUOLm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 10:11:42 -0400
Received: by mail-lf0-f66.google.com with SMTP id l131so5858890lfl.0
        for <linux-media@vger.kernel.org>; Fri, 21 Oct 2016 07:11:41 -0700 (PDT)
From: Tvrtko Ursulin <tursulin@ursulin.net>
To: Intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 2/5] lib/scatterlist: Avoid potential scatterlist entry overflow
Date: Fri, 21 Oct 2016 15:11:20 +0100
Message-Id: <1477059083-3500-3-git-send-email-tvrtko.ursulin@linux.intel.com>
In-Reply-To: <1477059083-3500-1-git-send-email-tvrtko.ursulin@linux.intel.com>
References: <1477059083-3500-1-git-send-email-tvrtko.ursulin@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Since the scatterlist length field is an unsigned int, make
sure that sg_alloc_table_from_pages does not overflow it while
coallescing pages to a single entry.

It is I think only a theoretical possibility at the moment,
but the ability to limit the coallesced size will have
another use in following patches.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: linux-kernel@vger.kernel.org
---
 lib/scatterlist.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index e05e7fc98892..d928fa04aee3 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -394,7 +394,8 @@ int sg_alloc_table_from_pages(struct sg_table *sgt,
 	unsigned int offset, unsigned long size,
 	gfp_t gfp_mask)
 {
-	unsigned int chunks;
+	const unsigned int max_segment = ~0;
+	unsigned int seg_len, chunks;
 	unsigned int i;
 	unsigned int cur_page;
 	int ret;
@@ -402,9 +403,16 @@ int sg_alloc_table_from_pages(struct sg_table *sgt,
 
 	/* compute number of contiguous chunks */
 	chunks = 1;
-	for (i = 1; i < n_pages; ++i)
-		if (page_to_pfn(pages[i]) != page_to_pfn(pages[i - 1]) + 1)
+	seg_len = PAGE_SIZE;
+	for (i = 1; i < n_pages; ++i) {
+		if (seg_len >= max_segment ||
+		    page_to_pfn(pages[i]) != page_to_pfn(pages[i - 1]) + 1) {
 			++chunks;
+			seg_len = PAGE_SIZE;
+		} else {
+			seg_len += PAGE_SIZE;
+		}
+	}
 
 	ret = sg_alloc_table(sgt, chunks, gfp_mask);
 	if (unlikely(ret))
@@ -413,17 +421,22 @@ int sg_alloc_table_from_pages(struct sg_table *sgt,
 	/* merging chunks and putting them into the scatterlist */
 	cur_page = 0;
 	for_each_sg(sgt->sgl, s, sgt->orig_nents, i) {
-		unsigned long chunk_size;
+		unsigned int chunk_size;
 		unsigned int j;
 
 		/* look for the end of the current chunk */
+		seg_len = PAGE_SIZE;
 		for (j = cur_page + 1; j < n_pages; ++j)
-			if (page_to_pfn(pages[j]) !=
+			if (seg_len >= max_segment ||
+			    page_to_pfn(pages[j]) !=
 			    page_to_pfn(pages[j - 1]) + 1)
 				break;
+			else
+				seg_len += PAGE_SIZE;
 
 		chunk_size = ((j - cur_page) << PAGE_SHIFT) - offset;
-		sg_set_page(s, pages[cur_page], min(size, chunk_size), offset);
+		sg_set_page(s, pages[cur_page],
+			    min_t(unsigned long, size, chunk_size), offset);
 		size -= chunk_size;
 		offset = 0;
 		cur_page = j;
-- 
2.7.4

