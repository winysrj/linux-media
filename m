Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:42657 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755815AbeFOG2I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 02:28:08 -0400
From: Oleksandr Andrushchenko <andr2000@gmail.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, andr2000@gmail.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: [PATCH v4 3/9] xen/balloon: Share common memory reservation routines
Date: Fri, 15 Jun 2018 09:27:47 +0300
Message-Id: <20180615062753.9229-4-andr2000@gmail.com>
In-Reply-To: <20180615062753.9229-1-andr2000@gmail.com>
References: <20180615062753.9229-1-andr2000@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

Memory {increase|decrease}_reservation and VA mappings update/reset
code used in balloon driver can be made common, so other drivers can
also re-use the same functionality without open-coding.
Create a dedicated file for the shared code and export corresponding
symbols for other kernel modules.

Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
---
 drivers/xen/Makefile          |   1 +
 drivers/xen/balloon.c         |  75 ++-------------------
 drivers/xen/mem-reservation.c | 118 ++++++++++++++++++++++++++++++++++
 include/xen/mem-reservation.h |  59 +++++++++++++++++
 4 files changed, 184 insertions(+), 69 deletions(-)
 create mode 100644 drivers/xen/mem-reservation.c
 create mode 100644 include/xen/mem-reservation.h

diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 451e833f5931..3c87b0c3aca6 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -2,6 +2,7 @@
 obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
 obj-$(CONFIG_X86)			+= fallback.o
 obj-y	+= grant-table.o features.o balloon.o manage.o preempt.o time.o
+obj-y	+= mem-reservation.o
 obj-y	+= events/
 obj-y	+= xenbus/
 
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 065f0b607373..e12bb256036f 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -71,6 +71,7 @@
 #include <xen/balloon.h>
 #include <xen/features.h>
 #include <xen/page.h>
+#include <xen/mem-reservation.h>
 
 static int xen_hotplug_unpopulated;
 
@@ -157,13 +158,6 @@ static DECLARE_DELAYED_WORK(balloon_worker, balloon_process);
 #define GFP_BALLOON \
 	(GFP_HIGHUSER | __GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC)
 
-static void scrub_page(struct page *page)
-{
-#ifdef CONFIG_XEN_SCRUB_PAGES
-	clear_highpage(page);
-#endif
-}
-
 /* balloon_append: add the given page to the balloon. */
 static void __balloon_append(struct page *page)
 {
@@ -463,11 +457,6 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
 	int rc;
 	unsigned long i;
 	struct page   *page;
-	struct xen_memory_reservation reservation = {
-		.address_bits = 0,
-		.extent_order = EXTENT_ORDER,
-		.domid        = DOMID_SELF
-	};
 
 	if (nr_pages > ARRAY_SIZE(frame_list))
 		nr_pages = ARRAY_SIZE(frame_list);
@@ -479,16 +468,11 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
 			break;
 		}
 
-		/* XENMEM_populate_physmap requires a PFN based on Xen
-		 * granularity.
-		 */
 		frame_list[i] = page_to_xen_pfn(page);
 		page = balloon_next_page(page);
 	}
 
-	set_xen_guest_handle(reservation.extent_start, frame_list);
-	reservation.nr_extents = nr_pages;
-	rc = HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
+	rc = xenmem_reservation_increase(nr_pages, frame_list);
 	if (rc <= 0)
 		return BP_EAGAIN;
 
@@ -496,29 +480,7 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
 		page = balloon_retrieve(false);
 		BUG_ON(page == NULL);
 
-#ifdef CONFIG_XEN_HAVE_PVMMU
-		/*
-		 * We don't support PV MMU when Linux and Xen is using
-		 * different page granularity.
-		 */
-		BUILD_BUG_ON(XEN_PAGE_SIZE != PAGE_SIZE);
-
-		if (!xen_feature(XENFEAT_auto_translated_physmap)) {
-			unsigned long pfn = page_to_pfn(page);
-
-			set_phys_to_machine(pfn, frame_list[i]);
-
-			/* Link back into the page tables if not highmem. */
-			if (!PageHighMem(page)) {
-				int ret;
-				ret = HYPERVISOR_update_va_mapping(
-						(unsigned long)__va(pfn << PAGE_SHIFT),
-						mfn_pte(frame_list[i], PAGE_KERNEL),
-						0);
-				BUG_ON(ret);
-			}
-		}
-#endif
+		xenmem_reservation_va_mapping_update(1, &page, &frame_list[i]);
 
 		/* Relinquish the page back to the allocator. */
 		free_reserved_page(page);
@@ -535,11 +497,6 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 	unsigned long i;
 	struct page *page, *tmp;
 	int ret;
-	struct xen_memory_reservation reservation = {
-		.address_bits = 0,
-		.extent_order = EXTENT_ORDER,
-		.domid        = DOMID_SELF
-	};
 	LIST_HEAD(pages);
 
 	if (nr_pages > ARRAY_SIZE(frame_list))
@@ -553,7 +510,7 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 			break;
 		}
 		adjust_managed_page_count(page, -1);
-		scrub_page(page);
+		xenmem_reservation_scrub_page(page);
 		list_add(&page->lru, &pages);
 	}
 
@@ -572,28 +529,10 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 	 */
 	i = 0;
 	list_for_each_entry_safe(page, tmp, &pages, lru) {
-		/* XENMEM_decrease_reservation requires a GFN */
 		frame_list[i++] = xen_page_to_gfn(page);
 
-#ifdef CONFIG_XEN_HAVE_PVMMU
-		/*
-		 * We don't support PV MMU when Linux and Xen is using
-		 * different page granularity.
-		 */
-		BUILD_BUG_ON(XEN_PAGE_SIZE != PAGE_SIZE);
-
-		if (!xen_feature(XENFEAT_auto_translated_physmap)) {
-			unsigned long pfn = page_to_pfn(page);
+		xenmem_reservation_va_mapping_reset(1, &page);
 
-			if (!PageHighMem(page)) {
-				ret = HYPERVISOR_update_va_mapping(
-						(unsigned long)__va(pfn << PAGE_SHIFT),
-						__pte_ma(0), 0);
-				BUG_ON(ret);
-			}
-			__set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
-		}
-#endif
 		list_del(&page->lru);
 
 		balloon_append(page);
@@ -601,9 +540,7 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 
 	flush_tlb_all();
 
-	set_xen_guest_handle(reservation.extent_start, frame_list);
-	reservation.nr_extents   = nr_pages;
-	ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation, &reservation);
+	ret = xenmem_reservation_decrease(nr_pages, frame_list);
 	BUG_ON(ret != nr_pages);
 
 	balloon_stats.current_pages -= nr_pages;
diff --git a/drivers/xen/mem-reservation.c b/drivers/xen/mem-reservation.c
new file mode 100644
index 000000000000..084799c6180e
--- /dev/null
+++ b/drivers/xen/mem-reservation.c
@@ -0,0 +1,118 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/******************************************************************************
+ * Xen memory reservation utilities.
+ *
+ * Copyright (c) 2003, B Dragovic
+ * Copyright (c) 2003-2004, M Williamson, K Fraser
+ * Copyright (c) 2005 Dan M. Smith, IBM Corporation
+ * Copyright (c) 2010 Daniel Kiper
+ * Copyright (c) 2018 Oleksandr Andrushchenko, EPAM Systems Inc.
+ */
+
+#include <asm/xen/hypercall.h>
+
+#include <xen/interface/memory.h>
+#include <xen/mem-reservation.h>
+
+/*
+ * Use one extent per PAGE_SIZE to avoid to break down the page into
+ * multiple frame.
+ */
+#define EXTENT_ORDER (fls(XEN_PFN_PER_PAGE) - 1)
+
+#ifdef CONFIG_XEN_HAVE_PVMMU
+void __xenmem_reservation_va_mapping_update(unsigned long count,
+					    struct page **pages,
+					    xen_pfn_t *frames)
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		struct page *page = pages[i];
+		unsigned long pfn = page_to_pfn(page);
+
+		BUG_ON(!page);
+
+		/*
+		 * We don't support PV MMU when Linux and Xen is using
+		 * different page granularity.
+		 */
+		BUILD_BUG_ON(XEN_PAGE_SIZE != PAGE_SIZE);
+
+		set_phys_to_machine(pfn, frames[i]);
+
+		/* Link back into the page tables if not highmem. */
+		if (!PageHighMem(page)) {
+			int ret;
+
+			ret = HYPERVISOR_update_va_mapping(
+					(unsigned long)__va(pfn << PAGE_SHIFT),
+					mfn_pte(frames[i], PAGE_KERNEL),
+					0);
+			BUG_ON(ret);
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(__xenmem_reservation_va_mapping_update);
+
+void __xenmem_reservation_va_mapping_reset(unsigned long count,
+					   struct page **pages)
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		struct page *page = pages[i];
+		unsigned long pfn = page_to_pfn(page);
+
+		/*
+		 * We don't support PV MMU when Linux and Xen are using
+		 * different page granularity.
+		 */
+		BUILD_BUG_ON(XEN_PAGE_SIZE != PAGE_SIZE);
+
+		if (!PageHighMem(page)) {
+			int ret;
+
+			ret = HYPERVISOR_update_va_mapping(
+					(unsigned long)__va(pfn << PAGE_SHIFT),
+					__pte_ma(0), 0);
+			BUG_ON(ret);
+		}
+		__set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
+	}
+}
+EXPORT_SYMBOL_GPL(__xenmem_reservation_va_mapping_reset);
+#endif /* CONFIG_XEN_HAVE_PVMMU */
+
+/* @frames is an array of PFNs */
+int xenmem_reservation_increase(int count, xen_pfn_t *frames)
+{
+	struct xen_memory_reservation reservation = {
+		.address_bits = 0,
+		.extent_order = EXTENT_ORDER,
+		.domid        = DOMID_SELF
+	};
+
+	/* XENMEM_populate_physmap requires a PFN based on Xen granularity. */
+	set_xen_guest_handle(reservation.extent_start, frames);
+	reservation.nr_extents = count;
+	return HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
+}
+EXPORT_SYMBOL_GPL(xenmem_reservation_increase);
+
+/* @frames is an array of GFNs */
+int xenmem_reservation_decrease(int count, xen_pfn_t *frames)
+{
+	struct xen_memory_reservation reservation = {
+		.address_bits = 0,
+		.extent_order = EXTENT_ORDER,
+		.domid        = DOMID_SELF
+	};
+
+	/* XENMEM_decrease_reservation requires a GFN */
+	set_xen_guest_handle(reservation.extent_start, frames);
+	reservation.nr_extents = count;
+	return HYPERVISOR_memory_op(XENMEM_decrease_reservation, &reservation);
+}
+EXPORT_SYMBOL_GPL(xenmem_reservation_decrease);
diff --git a/include/xen/mem-reservation.h b/include/xen/mem-reservation.h
new file mode 100644
index 000000000000..80b52b4945e9
--- /dev/null
+++ b/include/xen/mem-reservation.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Xen memory reservation utilities.
+ *
+ * Copyright (c) 2003, B Dragovic
+ * Copyright (c) 2003-2004, M Williamson, K Fraser
+ * Copyright (c) 2005 Dan M. Smith, IBM Corporation
+ * Copyright (c) 2010 Daniel Kiper
+ * Copyright (c) 2018 Oleksandr Andrushchenko, EPAM Systems Inc.
+ */
+
+#ifndef _XENMEM_RESERVATION_H
+#define _XENMEM_RESERVATION_H
+
+#include <linux/highmem.h>
+
+#include <xen/page.h>
+
+static inline void xenmem_reservation_scrub_page(struct page *page)
+{
+#ifdef CONFIG_XEN_SCRUB_PAGES
+	clear_highpage(page);
+#endif
+}
+
+#ifdef CONFIG_XEN_HAVE_PVMMU
+void __xenmem_reservation_va_mapping_update(unsigned long count,
+					    struct page **pages,
+					    xen_pfn_t *frames);
+
+void __xenmem_reservation_va_mapping_reset(unsigned long count,
+					   struct page **pages);
+#endif
+
+static inline void xenmem_reservation_va_mapping_update(unsigned long count,
+							struct page **pages,
+							xen_pfn_t *frames)
+{
+#ifdef CONFIG_XEN_HAVE_PVMMU
+	if (!xen_feature(XENFEAT_auto_translated_physmap))
+		__xenmem_reservation_va_mapping_update(count, pages, frames);
+#endif
+}
+
+static inline void xenmem_reservation_va_mapping_reset(unsigned long count,
+						       struct page **pages)
+{
+#ifdef CONFIG_XEN_HAVE_PVMMU
+	if (!xen_feature(XENFEAT_auto_translated_physmap))
+		__xenmem_reservation_va_mapping_reset(count, pages);
+#endif
+}
+
+int xenmem_reservation_increase(int count, xen_pfn_t *frames);
+
+int xenmem_reservation_decrease(int count, xen_pfn_t *frames);
+
+#endif
-- 
2.17.1
