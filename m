Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36162 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933737AbcJUOLm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 10:11:42 -0400
Received: by mail-lf0-f68.google.com with SMTP id b75so6115854lfg.3
        for <linux-media@vger.kernel.org>; Fri, 21 Oct 2016 07:11:41 -0700 (PDT)
From: Tvrtko Ursulin <tursulin@ursulin.net>
To: Intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 3/5] lib/scatterlist: Introduce and export __sg_alloc_table_from_pages
Date: Fri, 21 Oct 2016 15:11:21 +0100
Message-Id: <1477059083-3500-4-git-send-email-tvrtko.ursulin@linux.intel.com>
In-Reply-To: <1477059083-3500-1-git-send-email-tvrtko.ursulin@linux.intel.com>
References: <1477059083-3500-1-git-send-email-tvrtko.ursulin@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Drivers like i915 benefit from being able to control the maxium
size of the sg coallesced segment while building the scatter-
gather list.

Introduce and export the __sg_alloc_table_from_pages function
which will allow it that control.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: linux-kernel@vger.kernel.org
---
 include/linux/scatterlist.h | 11 +++++----
 lib/scatterlist.c           | 55 ++++++++++++++++++++++++++++++++++-----------
 2 files changed, 49 insertions(+), 17 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index c981bee1a3ae..29591dbb20fd 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -261,10 +261,13 @@ void sg_free_table(struct sg_table *);
 int __sg_alloc_table(struct sg_table *, unsigned int, unsigned int,
 		     struct scatterlist *, gfp_t, sg_alloc_fn *);
 int sg_alloc_table(struct sg_table *, unsigned int, gfp_t);
-int sg_alloc_table_from_pages(struct sg_table *sgt,
-	struct page **pages, unsigned int n_pages,
-	unsigned int offset, unsigned long size,
-	gfp_t gfp_mask);
+int __sg_alloc_table_from_pages(struct sg_table *sgt, struct page **pages,
+				unsigned int n_pages, unsigned int offset,
+				unsigned long size, gfp_t gfp_mask,
+				unsigned int max_segment);
+int sg_alloc_table_from_pages(struct sg_table *sgt, struct page **pages,
+			      unsigned int n_pages, unsigned int offset,
+			      unsigned long size, gfp_t gfp_mask);
 
 size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void *buf,
 		      size_t buflen, off_t skip, bool to_buffer);
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index d928fa04aee3..0378c5fd7caa 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -370,14 +370,15 @@ int sg_alloc_table(struct sg_table *table, unsigned int nents, gfp_t gfp_mask)
 EXPORT_SYMBOL(sg_alloc_table);
 
 /**
- * sg_alloc_table_from_pages - Allocate and initialize an sg table from
- *			       an array of pages
- * @sgt:	The sg table header to use
- * @pages:	Pointer to an array of page pointers
- * @n_pages:	Number of pages in the pages array
- * @offset:     Offset from start of the first page to the start of a buffer
- * @size:       Number of valid bytes in the buffer (after offset)
- * @gfp_mask:	GFP allocation mask
+ * __sg_alloc_table_from_pages - Allocate and initialize an sg table from
+ *			         an array of pages
+ * @sgt:	 The sg table header to use
+ * @pages:	 Pointer to an array of page pointers
+ * @n_pages:	 Number of pages in the pages array
+ * @offset:      Offset from start of the first page to the start of a buffer
+ * @size:        Number of valid bytes in the buffer (after offset)
+ * @gfp_mask:	 GFP allocation mask
+ * @max_segment: Maximum size of a single scatterlist node in bytes
  *
  *  Description:
  *    Allocate and initialize an sg table from a list of pages. Contiguous
@@ -389,12 +390,11 @@ EXPORT_SYMBOL(sg_alloc_table);
  * Returns:
  *   0 on success, negative error on failure
  */
-int sg_alloc_table_from_pages(struct sg_table *sgt,
-	struct page **pages, unsigned int n_pages,
-	unsigned int offset, unsigned long size,
-	gfp_t gfp_mask)
+int __sg_alloc_table_from_pages(struct sg_table *sgt, struct page **pages,
+				unsigned int n_pages, unsigned int offset,
+				unsigned long size, gfp_t gfp_mask,
+				unsigned int max_segment)
 {
-	const unsigned int max_segment = ~0;
 	unsigned int seg_len, chunks;
 	unsigned int i;
 	unsigned int cur_page;
@@ -444,6 +444,35 @@ int sg_alloc_table_from_pages(struct sg_table *sgt,
 
 	return 0;
 }
+EXPORT_SYMBOL(__sg_alloc_table_from_pages);
+
+/**
+ * sg_alloc_table_from_pages - Allocate and initialize an sg table from
+ *			       an array of pages
+ * @sgt:	 The sg table header to use
+ * @pages:	 Pointer to an array of page pointers
+ * @n_pages:	 Number of pages in the pages array
+ * @offset:      Offset from start of the first page to the start of a buffer
+ * @size:        Number of valid bytes in the buffer (after offset)
+ * @gfp_mask:	 GFP allocation mask
+ *
+ *  Description:
+ *    Allocate and initialize an sg table from a list of pages. Contiguous
+ *    ranges of the pages are squashed into a single scatterlist node. A user
+ *    may provide an offset at a start and a size of valid data in a buffer
+ *    specified by the page array. The returned sg table is released by
+ *    sg_free_table.
+ *
+ * Returns:
+ *   0 on success, negative error on failure
+ */
+int sg_alloc_table_from_pages(struct sg_table *sgt, struct page **pages,
+			      unsigned int n_pages, unsigned int offset,
+			      unsigned long size, gfp_t gfp_mask)
+{
+	return __sg_alloc_table_from_pages(sgt, pages, n_pages, offset,
+					   size, gfp_mask, ~0);
+}
 EXPORT_SYMBOL(sg_alloc_table_from_pages);
 
 void __sg_page_iter_start(struct sg_page_iter *piter,
-- 
2.7.4

