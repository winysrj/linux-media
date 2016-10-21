Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36184 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933813AbcJUOLo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 10:11:44 -0400
Received: by mail-lf0-f68.google.com with SMTP id b75so6115977lfg.3
        for <linux-media@vger.kernel.org>; Fri, 21 Oct 2016 07:11:43 -0700 (PDT)
From: Tvrtko Ursulin <tursulin@ursulin.net>
To: Intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5/5] drm/i915: Use __sg_alloc_table_from_pages for userptr allocations
Date: Fri, 21 Oct 2016 15:11:23 +0100
Message-Id: <1477059083-3500-6-git-send-email-tvrtko.ursulin@linux.intel.com>
In-Reply-To: <1477059083-3500-1-git-send-email-tvrtko.ursulin@linux.intel.com>
References: <1477059083-3500-1-git-send-email-tvrtko.ursulin@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

With the addition of __sg_alloc_table_from_pages we can control
the maximum coallescing size and eliminate a separate path for
allocating backing store here.

This also makes the tables as compact as possible in all cases.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
---
 drivers/gpu/drm/i915/i915_drv.h         |  9 +++++++++
 drivers/gpu/drm/i915/i915_gem.c         | 11 +----------
 drivers/gpu/drm/i915/i915_gem_userptr.c | 29 +++++++----------------------
 3 files changed, 17 insertions(+), 32 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 5b2b7f3c6e76..577a3a87f680 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -4001,4 +4001,13 @@ int remap_io_mapping(struct vm_area_struct *vma,
 	__T;								\
 })
 
+static inline unsigned int i915_swiotlb_max_size(void)
+{
+#if IS_ENABLED(CONFIG_SWIOTLB)
+	return swiotlb_nr_tbl() << IO_TLB_SHIFT;
+#else
+	return UINT_MAX;
+#endif
+}
+
 #endif
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 4bf675568a37..18125d7279c6 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2205,15 +2205,6 @@ i915_gem_object_put_pages(struct drm_i915_gem_object *obj)
 	return 0;
 }
 
-static unsigned int swiotlb_max_size(void)
-{
-#if IS_ENABLED(CONFIG_SWIOTLB)
-	return swiotlb_nr_tbl() << IO_TLB_SHIFT;
-#else
-	return UINT_MAX;
-#endif
-}
-
 static int
 i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj)
 {
@@ -2222,7 +2213,7 @@ i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj)
 	struct address_space *mapping;
 	struct sg_table *st;
 	struct page *page, **pages;
-	unsigned int max_segment = swiotlb_max_size();
+	unsigned int max_segment = i915_swiotlb_max_size();
 	int ret;
 	gfp_t gfp;
 
diff --git a/drivers/gpu/drm/i915/i915_gem_userptr.c b/drivers/gpu/drm/i915/i915_gem_userptr.c
index e537930c64b5..17dca225a3e0 100644
--- a/drivers/gpu/drm/i915/i915_gem_userptr.c
+++ b/drivers/gpu/drm/i915/i915_gem_userptr.c
@@ -397,36 +397,21 @@ struct get_pages_work {
 	struct task_struct *task;
 };
 
-#if IS_ENABLED(CONFIG_SWIOTLB)
-#define swiotlb_active() swiotlb_nr_tbl()
-#else
-#define swiotlb_active() 0
-#endif
-
 static int
 st_set_pages(struct sg_table **st, struct page **pvec, int num_pages)
 {
-	struct scatterlist *sg;
-	int ret, n;
+	unsigned int max_segment = i915_swiotlb_max_size();
+	int ret;
 
 	*st = kmalloc(sizeof(**st), GFP_KERNEL);
 	if (*st == NULL)
 		return -ENOMEM;
 
-	if (swiotlb_active()) {
-		ret = sg_alloc_table(*st, num_pages, GFP_KERNEL);
-		if (ret)
-			goto err;
-
-		for_each_sg((*st)->sgl, sg, num_pages, n)
-			sg_set_page(sg, pvec[n], PAGE_SIZE, 0);
-	} else {
-		ret = sg_alloc_table_from_pages(*st, pvec, num_pages,
-						0, num_pages << PAGE_SHIFT,
-						GFP_KERNEL);
-		if (ret)
-			goto err;
-	}
+	ret = __sg_alloc_table_from_pages(*st, pvec, num_pages, 0,
+					  num_pages << PAGE_SHIFT,
+					  GFP_KERNEL, max_segment);
+	if (ret)
+		goto err;
 
 	return 0;
 
-- 
2.7.4

