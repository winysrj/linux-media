Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:34196 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933741AbcJUOLn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 10:11:43 -0400
Received: by mail-qk0-f196.google.com with SMTP id n189so7280150qke.1
        for <linux-media@vger.kernel.org>; Fri, 21 Oct 2016 07:11:42 -0700 (PDT)
From: Tvrtko Ursulin <tursulin@ursulin.net>
To: Intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 4/5] drm/i915: Use __sg_alloc_table_from_pages for allocating object backing store
Date: Fri, 21 Oct 2016 15:11:22 +0100
Message-Id: <1477059083-3500-5-git-send-email-tvrtko.ursulin@linux.intel.com>
In-Reply-To: <1477059083-3500-1-git-send-email-tvrtko.ursulin@linux.intel.com>
References: <1477059083-3500-1-git-send-email-tvrtko.ursulin@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

With the current way of allocating backing store which over-estimates
the number of sg entries required we typically waste around 1-6 MiB of
memory on unused sg entries at runtime.

We can instead have the intermediate step of storing our pages in an
array and use __sg_alloc_table_from_pages which will create us the
most compact list possible.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
---
 drivers/gpu/drm/i915/i915_gem.c | 72 ++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 37 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 8ed8e24025ac..4bf675568a37 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2208,9 +2208,9 @@ i915_gem_object_put_pages(struct drm_i915_gem_object *obj)
 static unsigned int swiotlb_max_size(void)
 {
 #if IS_ENABLED(CONFIG_SWIOTLB)
-	return rounddown(swiotlb_nr_tbl() << IO_TLB_SHIFT, PAGE_SIZE);
+	return swiotlb_nr_tbl() << IO_TLB_SHIFT;
 #else
-	return 0;
+	return UINT_MAX;
 #endif
 }
 
@@ -2221,11 +2221,8 @@ i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj)
 	int page_count, i;
 	struct address_space *mapping;
 	struct sg_table *st;
-	struct scatterlist *sg;
-	struct sgt_iter sgt_iter;
-	struct page *page;
-	unsigned long last_pfn = 0;	/* suppress gcc warning */
-	unsigned int max_segment;
+	struct page *page, **pages;
+	unsigned int max_segment = swiotlb_max_size();
 	int ret;
 	gfp_t gfp;
 
@@ -2236,18 +2233,16 @@ i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj)
 	BUG_ON(obj->base.read_domains & I915_GEM_GPU_DOMAINS);
 	BUG_ON(obj->base.write_domain & I915_GEM_GPU_DOMAINS);
 
-	max_segment = swiotlb_max_size();
-	if (!max_segment)
-		max_segment = rounddown(UINT_MAX, PAGE_SIZE);
-
-	st = kmalloc(sizeof(*st), GFP_KERNEL);
-	if (st == NULL)
-		return -ENOMEM;
-
 	page_count = obj->base.size / PAGE_SIZE;
-	if (sg_alloc_table(st, page_count, GFP_KERNEL)) {
-		kfree(st);
+	pages = drm_malloc_gfp(page_count, sizeof(struct page *),
+			       GFP_TEMPORARY | __GFP_ZERO);
+	if (!pages)
 		return -ENOMEM;
+
+	st = kmalloc(sizeof(*st), GFP_KERNEL);
+	if (st == NULL) {
+		ret = -ENOMEM;
+		goto err_st;
 	}
 
 	/* Get the list of pages out of our struct file.  They'll be pinned
@@ -2258,8 +2253,6 @@ i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj)
 	mapping = obj->base.filp->f_mapping;
 	gfp = mapping_gfp_constraint(mapping, ~(__GFP_IO | __GFP_RECLAIM));
 	gfp |= __GFP_NORETRY | __GFP_NOWARN;
-	sg = st->sgl;
-	st->nents = 0;
 	for (i = 0; i < page_count; i++) {
 		page = shmem_read_mapping_page_gfp(mapping, i, gfp);
 		if (IS_ERR(page)) {
@@ -2281,29 +2274,28 @@ i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj)
 				goto err_pages;
 			}
 		}
-		if (!i ||
-		    sg->length >= max_segment ||
-		    page_to_pfn(page) != last_pfn + 1) {
-			if (i)
-				sg = sg_next(sg);
-			st->nents++;
-			sg_set_page(sg, page, PAGE_SIZE, 0);
-		} else {
-			sg->length += PAGE_SIZE;
-		}
-		last_pfn = page_to_pfn(page);
+
+		pages[i] = page;
 
 		/* Check that the i965g/gm workaround works. */
-		WARN_ON((gfp & __GFP_DMA32) && (last_pfn >= 0x00100000UL));
+		WARN_ON((gfp & __GFP_DMA32) &&
+			(page_to_pfn(page) >= 0x00100000UL));
 	}
-	if (sg) /* loop terminated early; short sg table */
-		sg_mark_end(sg);
+
+	ret = __sg_alloc_table_from_pages(st, pages, page_count, 0,
+					  obj->base.size, GFP_KERNEL,
+					  max_segment);
+	if (ret)
+		goto err_pages;
+
 	obj->pages = st;
 
 	ret = i915_gem_gtt_prepare_object(obj);
 	if (ret)
 		goto err_pages;
 
+	drm_free_large(pages);
+
 	if (i915_gem_object_needs_bit17_swizzle(obj))
 		i915_gem_object_do_bit_17_swizzle(obj);
 
@@ -2314,10 +2306,13 @@ i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj)
 	return 0;
 
 err_pages:
-	sg_mark_end(sg);
-	for_each_sgt_page(page, sgt_iter, st)
-		put_page(page);
-	sg_free_table(st);
+	for (i = 0; i < page_count; i++) {
+		if (pages[i])
+			put_page(pages[i]);
+		else
+			break;
+	}
+
 	kfree(st);
 
 	/* shmemfs first checks if there is enough memory to allocate the page
@@ -2331,6 +2326,9 @@ i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj)
 	if (ret == -ENOSPC)
 		ret = -ENOMEM;
 
+err_st:
+	drm_free_large(pages);
+
 	return ret;
 }
 
-- 
2.7.4

