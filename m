Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:46661 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753740AbeEaHvt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 03:51:49 -0400
Subject: Re: [PATCH 2/8] xen/balloon: Move common memory reservation routines
 to a module
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180525153331.31188-1-andr2000@gmail.com>
 <20180525153331.31188-3-andr2000@gmail.com>
 <59ab73b0-967b-a82f-3b0d-95f1b0dc40a5@oracle.com>
 <89de7bdb-8759-419f-63bf-8ed0d57650f0@gmail.com>
 <edfa937b-3311-98db-2e6f-b4083598f796@oracle.com>
 <6ca7f428-eede-2c14-85fe-da4a20bcea0d@gmail.com>
 <5dd3378d-ac32-691e-1f80-7218a5d07fd6@oracle.com>
 <43c17501-8865-6e1f-1a92-d947755d8fa8@gmail.com>
 <c08c380d-17af-b668-acf2-8d8a94333aca@oracle.com>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <b9046572-8802-b213-a74f-68f58a58ae6a@gmail.com>
Date: Thu, 31 May 2018 10:51:45 +0300
MIME-Version: 1.0
In-Reply-To: <c08c380d-17af-b668-acf2-8d8a94333aca@oracle.com>
Content-Type: multipart/mixed;
 boundary="------------7EDD12234581199609D9736A"
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------7EDD12234581199609D9736A
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On 05/30/2018 10:24 PM, Boris Ostrovsky wrote:
> On 05/30/2018 01:46 PM, Oleksandr Andrushchenko wrote:
>> On 05/30/2018 06:54 PM, Boris Ostrovsky wrote:
>>>
>>> BTW, I also think you can further simplify
>>> xenmem_reservation_va_mapping_* routines by bailing out right away if
>>> xen_feature(XENFEAT_auto_translated_physmap). In fact, you might even
>>> make them inlines, along the lines of
>>>
>>> inline void xenmem_reservation_va_mapping_reset(unsigned long count,
>>>                       struct page **pages)
>>> {
>>> #ifdef CONFIG_XEN_HAVE_PVMMU
>>>      if (!xen_feature(XENFEAT_auto_translated_physmap))
>>>          __xenmem_reservation_va_mapping_reset(...)
>>> #endif
>>> }
>> How about:
>>
>> #ifdef CONFIG_XEN_HAVE_PVMMU
>> static inline __xenmem_reservation_va_mapping_reset(struct page *page)
>> {
>> [...]
>> }
>> #endif
>>
>> and
>>
>> void xenmem_reservation_va_mapping_reset(unsigned long count,
>>                       struct page **pages)
>> {
>> #ifdef CONFIG_XEN_HAVE_PVMMU
>>      if (!xen_feature(XENFEAT_auto_translated_physmap)) {
>>          int i;
>>
>>          for (i = 0; i < count; i++)
>>              __xenmem_reservation_va_mapping_reset(pages[i]);
>>      }
>> #endif
>> }
>>
>> This way I can use __xenmem_reservation_va_mapping_reset(page);
>> instead of xenmem_reservation_va_mapping_reset(1, &page);
>
> Sure, this also works.
Could you please take look at the patch attached if this is what we want?
> -boris
>
Thank you,
Oleksandr

--------------7EDD12234581199609D9736A
Content-Type: text/x-patch;
 name="0001-xen-balloon-Share-common-memory-reservation-routines.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-xen-balloon-Share-common-memory-reservation-routines.pa";
 filename*1="tch"

>From d41751068ac80ca5a375909d6c01cb25716a4975 Mon Sep 17 00:00:00 2001
From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Date: Wed, 23 May 2018 16:52:45 +0300
Subject: [PATCH] xen/balloon: Share common memory reservation routines

Memory {increase|decrease}_reservation and VA mappings update/reset
code used in balloon driver can be made common, so other drivers can
also re-use the same functionality without open-coding.
Create a dedicated file for the shared code and export corresponding
symbols for other kernel modules.

Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
---
 drivers/xen/Makefile          |   1 +
 drivers/xen/balloon.c         |  71 ++-------------------
 drivers/xen/mem-reservation.c |  78 +++++++++++++++++++++++
 include/xen/mem-reservation.h | 114 ++++++++++++++++++++++++++++++++++
 4 files changed, 199 insertions(+), 65 deletions(-)
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
index 065f0b607373..1789be76e9c5 100644
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
@@ -486,9 +475,7 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
 		page = balloon_next_page(page);
 	}
 
-	set_xen_guest_handle(reservation.extent_start, frame_list);
-	reservation.nr_extents = nr_pages;
-	rc = HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
+	rc = xenmem_reservation_increase(nr_pages, frame_list);
 	if (rc <= 0)
 		return BP_EAGAIN;
 
@@ -496,29 +483,7 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
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
+		__xenmem_reservation_va_mapping_update(page, frame_list[i]);
 
 		/* Relinquish the page back to the allocator. */
 		free_reserved_page(page);
@@ -535,11 +500,6 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
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
@@ -553,7 +513,7 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 			break;
 		}
 		adjust_managed_page_count(page, -1);
-		scrub_page(page);
+		xenmem_reservation_scrub_page(page);
 		list_add(&page->lru, &pages);
 	}
 
@@ -575,25 +535,8 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 		/* XENMEM_decrease_reservation requires a GFN */
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
+		__xenmem_reservation_va_mapping_reset(page);
 
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
@@ -601,9 +544,7 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 
 	flush_tlb_all();
 
-	set_xen_guest_handle(reservation.extent_start, frame_list);
-	reservation.nr_extents   = nr_pages;
-	ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation, &reservation);
+	ret = xenmem_reservation_decrease(nr_pages, frame_list);
 	BUG_ON(ret != nr_pages);
 
 	balloon_stats.current_pages -= nr_pages;
diff --git a/drivers/xen/mem-reservation.c b/drivers/xen/mem-reservation.c
new file mode 100644
index 000000000000..5347c17a08c1
--- /dev/null
+++ b/drivers/xen/mem-reservation.c
@@ -0,0 +1,78 @@
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
+#include <xen/mem-reservation.h>
+
+/*
+ * Use one extent per PAGE_SIZE to avoid to break down the page into
+ * multiple frame.
+ */
+#define EXTENT_ORDER (fls(XEN_PFN_PER_PAGE) - 1)
+
+#ifdef CONFIG_XEN_SCRUB_PAGES
+void xenmem_reservation_scrub_page(struct page *page)
+{
+	clear_highpage(page);
+}
+EXPORT_SYMBOL_GPL(xenmem_reservation_scrub_page);
+#endif
+
+#ifdef CONFIG_XEN_HAVE_PVMMU
+void xenmem_reservation_va_mapping_update(unsigned long count,
+					  struct page **pages,
+					  xen_pfn_t *frames)
+{
+	int i;
+
+	for (i = 0; i < count; i++)
+		__xenmem_reservation_va_mapping_update(pages[i], frames[i]);
+}
+EXPORT_SYMBOL_GPL(xenmem_reservation_va_mapping_update);
+
+void xenmem_reservation_va_mapping_reset(unsigned long count,
+					 struct page **pages)
+{
+	int i;
+
+	for (i = 0; i < count; i++)
+		__xenmem_reservation_va_mapping_reset(pages[i]);
+}
+EXPORT_SYMBOL_GPL(xenmem_reservation_va_mapping_reset);
+#endif /* CONFIG_XEN_HAVE_PVMMU */
+
+int xenmem_reservation_increase(int count, xen_pfn_t *frames)
+{
+	struct xen_memory_reservation reservation = {
+		.address_bits = 0,
+		.extent_order = EXTENT_ORDER,
+		.domid        = DOMID_SELF
+	};
+
+	set_xen_guest_handle(reservation.extent_start, frames);
+	reservation.nr_extents = count;
+	return HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
+}
+EXPORT_SYMBOL_GPL(xenmem_reservation_increase);
+
+int xenmem_reservation_decrease(int count, xen_pfn_t *frames)
+{
+	struct xen_memory_reservation reservation = {
+		.address_bits = 0,
+		.extent_order = EXTENT_ORDER,
+		.domid        = DOMID_SELF
+	};
+
+	set_xen_guest_handle(reservation.extent_start, frames);
+	reservation.nr_extents = count;
+	return HYPERVISOR_memory_op(XENMEM_decrease_reservation, &reservation);
+}
+EXPORT_SYMBOL_GPL(xenmem_reservation_decrease);
diff --git a/include/xen/mem-reservation.h b/include/xen/mem-reservation.h
new file mode 100644
index 000000000000..d44443cdd60e
--- /dev/null
+++ b/include/xen/mem-reservation.h
@@ -0,0 +1,114 @@
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
+#include <linux/kernel.h>
+#include <linux/slab.h>
+
+#include <asm/xen/hypercall.h>
+#include <asm/tlb.h>
+
+#include <xen/interface/memory.h>
+#include <xen/page.h>
+
+#ifdef CONFIG_XEN_SCRUB_PAGES
+void xenmem_reservation_scrub_page(struct page *page);
+#else
+static inline void xenmem_reservation_scrub_page(struct page *page)
+{
+}
+#endif
+
+static inline void
+__xenmem_reservation_va_mapping_update(struct page *page, xen_pfn_t frame)
+{
+#ifdef CONFIG_XEN_HAVE_PVMMU
+	BUG_ON(page == NULL);
+
+	/*
+	 * We don't support PV MMU when Linux and Xen is using
+	 * different page granularity.
+	 */
+	BUILD_BUG_ON(XEN_PAGE_SIZE != PAGE_SIZE);
+
+	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
+		unsigned long pfn = page_to_pfn(page);
+
+		set_phys_to_machine(pfn, frame);
+
+		/* Link back into the page tables if not highmem. */
+		if (!PageHighMem(page)) {
+			int ret;
+
+			ret = HYPERVISOR_update_va_mapping(
+					(unsigned long)__va(pfn << PAGE_SHIFT),
+					mfn_pte(frame, PAGE_KERNEL),
+					0);
+			BUG_ON(ret);
+		}
+	}
+#endif
+}
+
+static inline void
+__xenmem_reservation_va_mapping_reset(struct page *page)
+{
+#ifdef CONFIG_XEN_HAVE_PVMMU
+	/*
+	 * We don't support PV MMU when Linux and Xen is using
+	 * different page granularity.
+	 */
+	BUILD_BUG_ON(XEN_PAGE_SIZE != PAGE_SIZE);
+
+	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
+		unsigned long pfn = page_to_pfn(page);
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
+#endif
+}
+
+#ifdef CONFIG_XEN_HAVE_PVMMU
+void xenmem_reservation_va_mapping_update(unsigned long count,
+					  struct page **pages,
+					  xen_pfn_t *frames);
+
+void xenmem_reservation_va_mapping_reset(unsigned long count,
+					 struct page **pages);
+#else
+static inline void xenmem_reservation_va_mapping_update(unsigned long count,
+							struct page **pages,
+							xen_pfn_t *frames)
+{
+}
+
+static inline void xenmem_reservation_va_mapping_reset(unsigned long count,
+						       struct page **pages)
+{
+}
+#endif
+
+int xenmem_reservation_increase(int count, xen_pfn_t *frames);
+
+int xenmem_reservation_decrease(int count, xen_pfn_t *frames);
+
+#endif
-- 
2.17.0


--------------7EDD12234581199609D9736A--
