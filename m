Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35626 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752346AbeEQI0Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 04:26:16 -0400
From: Oleksandr Andrushchenko <andr2000@gmail.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, andr2000@gmail.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: [Xen-devel][RFC 1/3] xen/balloon: Allow allocating DMA buffers
Date: Thu, 17 May 2018 11:26:02 +0300
Message-Id: <20180517082604.14828-2-andr2000@gmail.com>
In-Reply-To: <20180517082604.14828-1-andr2000@gmail.com>
References: <20180517082604.14828-1-andr2000@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
---
 drivers/xen/balloon.c     | 214 +++++++++++++++++++++++++++++++-------
 drivers/xen/xen-balloon.c |   2 +
 include/xen/balloon.h     |  11 +-
 3 files changed, 188 insertions(+), 39 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index e4db19e88ab1..e3a145aa9f29 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -415,8 +415,10 @@ static bool balloon_is_inflated(void)
 	return balloon_stats.balloon_low || balloon_stats.balloon_high;
 }
 
-static enum bp_state increase_reservation(unsigned long nr_pages)
+static enum bp_state increase_reservation(unsigned long nr_pages,
+					  struct page **ext_pages)
 {
+	enum bp_state ret = BP_DONE;
 	int rc;
 	unsigned long i;
 	struct page   *page;
@@ -425,32 +427,49 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
 		.extent_order = EXTENT_ORDER,
 		.domid        = DOMID_SELF
 	};
+	xen_pfn_t *frames;
 
-	if (nr_pages > ARRAY_SIZE(frame_list))
-		nr_pages = ARRAY_SIZE(frame_list);
+	if (nr_pages > ARRAY_SIZE(frame_list)) {
+		frames = kcalloc(nr_pages, sizeof(xen_pfn_t), GFP_KERNEL);
+		if (!frames)
+			return BP_ECANCELED;
+	} else {
+		frames = frame_list;
+	}
 
-	page = list_first_entry_or_null(&ballooned_pages, struct page, lru);
-	for (i = 0; i < nr_pages; i++) {
-		if (!page) {
-			nr_pages = i;
-			break;
-		}
+	/* XENMEM_populate_physmap requires a PFN based on Xen
+	 * granularity.
+	 */
+	if (ext_pages) {
+		for (i = 0; i < nr_pages; i++)
+			frames[i] = page_to_xen_pfn(ext_pages[i]);
+	} else {
+		page = list_first_entry_or_null(&ballooned_pages,
+						struct page, lru);
+		for (i = 0; i < nr_pages; i++) {
+			if (!page) {
+				nr_pages = i;
+				break;
+			}
 
-		/* XENMEM_populate_physmap requires a PFN based on Xen
-		 * granularity.
-		 */
-		frame_list[i] = page_to_xen_pfn(page);
-		page = balloon_next_page(page);
+			frames[i] = page_to_xen_pfn(page);
+			page = balloon_next_page(page);
+		}
 	}
 
-	set_xen_guest_handle(reservation.extent_start, frame_list);
+	set_xen_guest_handle(reservation.extent_start, frames);
 	reservation.nr_extents = nr_pages;
 	rc = HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
-	if (rc <= 0)
-		return BP_EAGAIN;
+	if (rc <= 0) {
+		ret = BP_EAGAIN;
+		goto out;
+	}
 
 	for (i = 0; i < rc; i++) {
-		page = balloon_retrieve(false);
+		if (ext_pages)
+			page = ext_pages[i];
+		else
+			page = balloon_retrieve(false);
 		BUG_ON(page == NULL);
 
 #ifdef CONFIG_XEN_HAVE_PVMMU
@@ -463,14 +482,14 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
 		if (!xen_feature(XENFEAT_auto_translated_physmap)) {
 			unsigned long pfn = page_to_pfn(page);
 
-			set_phys_to_machine(pfn, frame_list[i]);
+			set_phys_to_machine(pfn, frames[i]);
 
 			/* Link back into the page tables if not highmem. */
 			if (!PageHighMem(page)) {
 				int ret;
 				ret = HYPERVISOR_update_va_mapping(
 						(unsigned long)__va(pfn << PAGE_SHIFT),
-						mfn_pte(frame_list[i], PAGE_KERNEL),
+						mfn_pte(frames[i], PAGE_KERNEL),
 						0);
 				BUG_ON(ret);
 			}
@@ -478,15 +497,22 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
 #endif
 
 		/* Relinquish the page back to the allocator. */
-		__free_reserved_page(page);
+		if (!ext_pages)
+			__free_reserved_page(page);
 	}
 
-	balloon_stats.current_pages += rc;
+	if (!ext_pages)
+		balloon_stats.current_pages += rc;
 
-	return BP_DONE;
+out:
+	if (frames != frame_list)
+		kfree(frames);
+
+	return ret;
 }
 
-static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
+static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp,
+					  struct page **ext_pages)
 {
 	enum bp_state state = BP_DONE;
 	unsigned long i;
@@ -498,16 +524,26 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 		.domid        = DOMID_SELF
 	};
 	LIST_HEAD(pages);
+	xen_pfn_t *frames;
 
-	if (nr_pages > ARRAY_SIZE(frame_list))
-		nr_pages = ARRAY_SIZE(frame_list);
+	if (nr_pages > ARRAY_SIZE(frame_list)) {
+		frames = kcalloc(nr_pages, sizeof(xen_pfn_t), GFP_KERNEL);
+		if (!frames)
+			return BP_ECANCELED;
+	} else {
+		frames = frame_list;
+	}
 
 	for (i = 0; i < nr_pages; i++) {
-		page = alloc_page(gfp);
-		if (page == NULL) {
-			nr_pages = i;
-			state = BP_EAGAIN;
-			break;
+		if (ext_pages) {
+			page = ext_pages[i];
+		} else {
+			page = alloc_page(gfp);
+			if (page == NULL) {
+				nr_pages = i;
+				state = BP_EAGAIN;
+				break;
+			}
 		}
 		scrub_page(page);
 		list_add(&page->lru, &pages);
@@ -529,7 +565,7 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 	i = 0;
 	list_for_each_entry_safe(page, tmp, &pages, lru) {
 		/* XENMEM_decrease_reservation requires a GFN */
-		frame_list[i++] = xen_page_to_gfn(page);
+		frames[i++] = xen_page_to_gfn(page);
 
 #ifdef CONFIG_XEN_HAVE_PVMMU
 		/*
@@ -552,18 +588,22 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 #endif
 		list_del(&page->lru);
 
-		balloon_append(page);
+		if (!ext_pages)
+			balloon_append(page);
 	}
 
 	flush_tlb_all();
 
-	set_xen_guest_handle(reservation.extent_start, frame_list);
+	set_xen_guest_handle(reservation.extent_start, frames);
 	reservation.nr_extents   = nr_pages;
 	ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation, &reservation);
 	BUG_ON(ret != nr_pages);
 
-	balloon_stats.current_pages -= nr_pages;
+	if (!ext_pages)
+		balloon_stats.current_pages -= nr_pages;
 
+	if (frames != frame_list)
+		kfree(frames);
 	return state;
 }
 
@@ -586,13 +626,13 @@ static void balloon_process(struct work_struct *work)
 
 		if (credit > 0) {
 			if (balloon_is_inflated())
-				state = increase_reservation(credit);
+				state = increase_reservation(credit, NULL);
 			else
 				state = reserve_additional_memory();
 		}
 
 		if (credit < 0)
-			state = decrease_reservation(-credit, GFP_BALLOON);
+			state = decrease_reservation(-credit, GFP_BALLOON, NULL);
 
 		state = update_schedule(state);
 
@@ -631,7 +671,7 @@ static int add_ballooned_pages(int nr_pages)
 		}
 	}
 
-	st = decrease_reservation(nr_pages, GFP_USER);
+	st = decrease_reservation(nr_pages, GFP_USER, NULL);
 	if (st != BP_DONE)
 		return -ENOMEM;
 
@@ -710,6 +750,102 @@ void free_xenballooned_pages(int nr_pages, struct page **pages)
 }
 EXPORT_SYMBOL(free_xenballooned_pages);
 
+int alloc_dma_xenballooned_pages(struct device *dev, bool coherent,
+				 int nr_pages, struct page **pages,
+				 void **vaddr, dma_addr_t *dev_bus_addr)
+{
+	enum bp_state state;
+	unsigned long pfn, start_pfn;
+	int i, ret;
+
+	mutex_lock(&balloon_mutex);
+
+	balloon_stats.dma_pages += nr_pages;
+
+	if (coherent)
+		*vaddr = dma_alloc_coherent(dev, nr_pages << PAGE_SHIFT,
+					    dev_bus_addr,
+					    GFP_KERNEL | __GFP_NOWARN);
+
+	else
+		*vaddr = dma_alloc_wc(dev, nr_pages << PAGE_SHIFT,
+				      dev_bus_addr,
+				      GFP_KERNEL | __GFP_NOWARN);
+	if (!*vaddr) {
+		pr_err("Failed to allocate DMA buffer of size %d\n",
+		       nr_pages << PAGE_SHIFT);
+		mutex_unlock(&balloon_mutex);
+		return -ENOMEM;
+	}
+
+	start_pfn = __phys_to_pfn(*dev_bus_addr);
+	for (pfn = start_pfn, i = 0; pfn < start_pfn + nr_pages; pfn++, i++)
+		pages[i] = pfn_to_page(pfn);
+
+	state = decrease_reservation(nr_pages, GFP_KERNEL, pages);
+	if (state != BP_DONE) {
+		pr_err("Failed to decrease reservation for DMA buffer\n");
+		ret = -ENOMEM;
+		goto out_undo;
+	}
+
+#ifdef CONFIG_XEN_HAVE_PVMMU
+	for (i = 0; i < nr_pages; i++) {
+		struct page *page = pages[i];
+
+		/*
+		 * We don't support PV MMU when Linux and Xen is using
+		 * different page granularity.
+		 */
+		BUILD_BUG_ON(XEN_PAGE_SIZE != PAGE_SIZE);
+
+		ret = xen_alloc_p2m_entry(page_to_pfn(page));
+		if (ret < 0)
+			goto out_undo;
+	}
+#endif
+	mutex_unlock(&balloon_mutex);
+	return 0;
+
+out_undo:
+	mutex_unlock(&balloon_mutex);
+	free_dma_xenballooned_pages(dev, coherent, nr_pages, pages,
+				    *vaddr, *dev_bus_addr);
+	return ret;
+}
+EXPORT_SYMBOL(alloc_dma_xenballooned_pages);
+
+void free_dma_xenballooned_pages(struct device *dev, bool coherent,
+				 int nr_pages, struct page **pages,
+				 void *vaddr, dma_addr_t dev_bus_addr)
+{
+	enum bp_state state;
+
+	mutex_lock(&balloon_mutex);
+
+	balloon_stats.dma_pages -= nr_pages;
+
+	state = increase_reservation(nr_pages, pages);
+	if (state != BP_DONE) {
+		pr_err("Failed to increase reservation for DMA buffer\n");
+		goto out;
+	}
+
+	if (vaddr) {
+		if (coherent)
+			dma_free_coherent(dev, nr_pages << PAGE_SHIFT,
+					  vaddr, dev_bus_addr);
+		else
+			dma_free_wc(dev, nr_pages << PAGE_SHIFT,
+				    vaddr, dev_bus_addr);
+	}
+
+out:
+	mutex_unlock(&balloon_mutex);
+}
+EXPORT_SYMBOL(free_dma_xenballooned_pages);
+
+
 static void __init balloon_add_region(unsigned long start_pfn,
 				      unsigned long pages)
 {
@@ -756,6 +892,8 @@ static int __init balloon_init(void)
 	balloon_stats.retry_count = 1;
 	balloon_stats.max_retry_count = RETRY_UNLIMITED;
 
+	balloon_stats.dma_pages = 0;
+
 #ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
 	set_online_page_callback(&xen_online_page);
 	register_memory_notifier(&xen_memory_nb);
diff --git a/drivers/xen/xen-balloon.c b/drivers/xen/xen-balloon.c
index 79865b8901ba..62b8c1e4422b 100644
--- a/drivers/xen/xen-balloon.c
+++ b/drivers/xen/xen-balloon.c
@@ -123,6 +123,7 @@ subsys_initcall(balloon_init);
 BALLOON_SHOW(current_kb, "%lu\n", PAGES2KB(balloon_stats.current_pages));
 BALLOON_SHOW(low_kb, "%lu\n", PAGES2KB(balloon_stats.balloon_low));
 BALLOON_SHOW(high_kb, "%lu\n", PAGES2KB(balloon_stats.balloon_high));
+BALLOON_SHOW(dma_kb, "%lu\n", PAGES2KB(balloon_stats.dma_pages));
 
 static DEVICE_ULONG_ATTR(schedule_delay, 0444, balloon_stats.schedule_delay);
 static DEVICE_ULONG_ATTR(max_schedule_delay, 0644, balloon_stats.max_schedule_delay);
@@ -205,6 +206,7 @@ static struct attribute *balloon_info_attrs[] = {
 	&dev_attr_current_kb.attr,
 	&dev_attr_low_kb.attr,
 	&dev_attr_high_kb.attr,
+	&dev_attr_dma_kb.attr,
 	NULL
 };
 
diff --git a/include/xen/balloon.h b/include/xen/balloon.h
index d1767dfb0d95..eb917aa911e6 100644
--- a/include/xen/balloon.h
+++ b/include/xen/balloon.h
@@ -17,16 +17,25 @@ struct balloon_stats {
 	unsigned long max_schedule_delay;
 	unsigned long retry_count;
 	unsigned long max_retry_count;
+	unsigned long dma_pages;
 };
 
 extern struct balloon_stats balloon_stats;
 
+struct device;
+
 void balloon_set_new_target(unsigned long target);
 
 int alloc_xenballooned_pages(int nr_pages, struct page **pages);
 void free_xenballooned_pages(int nr_pages, struct page **pages);
 
-struct device;
+int alloc_dma_xenballooned_pages(struct device *dev, bool coherent,
+				 int nr_pages, struct page **pages,
+				 void **vaddr, dma_addr_t *dev_bus_addr);
+void free_dma_xenballooned_pages(struct device *dev, bool coherent,
+				 int nr_pages, struct page **pages,
+				 void *vaddr, dma_addr_t dev_bus_addr);
+
 #ifdef CONFIG_XEN_SELFBALLOONING
 extern int register_xen_selfballooning(struct device *dev);
 #else
-- 
2.17.0
