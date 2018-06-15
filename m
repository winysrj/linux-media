Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35278 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755801AbeFOG2G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 02:28:06 -0400
From: Oleksandr Andrushchenko <andr2000@gmail.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, andr2000@gmail.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: [PATCH v4 2/9] xen/grant-table: Make set/clear page private code shared
Date: Fri, 15 Jun 2018 09:27:46 +0300
Message-Id: <20180615062753.9229-3-andr2000@gmail.com>
In-Reply-To: <20180615062753.9229-1-andr2000@gmail.com>
References: <20180615062753.9229-1-andr2000@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

Make set/clear page private code shared and accessible to
other kernel modules which can re-use these instead of open-coding.

Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 drivers/xen/grant-table.c | 54 +++++++++++++++++++++++++--------------
 include/xen/grant_table.h |  3 +++
 2 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index ba36ff3e4903..dbb48a89e987 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -769,29 +769,18 @@ void gnttab_free_auto_xlat_frames(void)
 }
 EXPORT_SYMBOL_GPL(gnttab_free_auto_xlat_frames);
 
-/**
- * gnttab_alloc_pages - alloc pages suitable for grant mapping into
- * @nr_pages: number of pages to alloc
- * @pages: returns the pages
- */
-int gnttab_alloc_pages(int nr_pages, struct page **pages)
+int gnttab_pages_set_private(int nr_pages, struct page **pages)
 {
 	int i;
-	int ret;
-
-	ret = alloc_xenballooned_pages(nr_pages, pages);
-	if (ret < 0)
-		return ret;
 
 	for (i = 0; i < nr_pages; i++) {
 #if BITS_PER_LONG < 64
 		struct xen_page_foreign *foreign;
 
 		foreign = kzalloc(sizeof(*foreign), GFP_KERNEL);
-		if (!foreign) {
-			gnttab_free_pages(nr_pages, pages);
+		if (!foreign)
 			return -ENOMEM;
-		}
+
 		set_page_private(pages[i], (unsigned long)foreign);
 #endif
 		SetPagePrivate(pages[i]);
@@ -799,14 +788,30 @@ int gnttab_alloc_pages(int nr_pages, struct page **pages)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(gnttab_alloc_pages);
+EXPORT_SYMBOL_GPL(gnttab_pages_set_private);
 
 /**
- * gnttab_free_pages - free pages allocated by gnttab_alloc_pages()
- * @nr_pages; number of pages to free
- * @pages: the pages
+ * gnttab_alloc_pages - alloc pages suitable for grant mapping into
+ * @nr_pages: number of pages to alloc
+ * @pages: returns the pages
  */
-void gnttab_free_pages(int nr_pages, struct page **pages)
+int gnttab_alloc_pages(int nr_pages, struct page **pages)
+{
+	int ret;
+
+	ret = alloc_xenballooned_pages(nr_pages, pages);
+	if (ret < 0)
+		return ret;
+
+	ret = gnttab_pages_set_private(nr_pages, pages);
+	if (ret < 0)
+		gnttab_free_pages(nr_pages, pages);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(gnttab_alloc_pages);
+
+void gnttab_pages_clear_private(int nr_pages, struct page **pages)
 {
 	int i;
 
@@ -818,6 +823,17 @@ void gnttab_free_pages(int nr_pages, struct page **pages)
 			ClearPagePrivate(pages[i]);
 		}
 	}
+}
+EXPORT_SYMBOL_GPL(gnttab_pages_clear_private);
+
+/**
+ * gnttab_free_pages - free pages allocated by gnttab_alloc_pages()
+ * @nr_pages; number of pages to free
+ * @pages: the pages
+ */
+void gnttab_free_pages(int nr_pages, struct page **pages)
+{
+	gnttab_pages_clear_private(nr_pages, pages);
 	free_xenballooned_pages(nr_pages, pages);
 }
 EXPORT_SYMBOL_GPL(gnttab_free_pages);
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index 2e37741f6b8d..de03f2542bb7 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -198,6 +198,9 @@ void gnttab_free_auto_xlat_frames(void);
 int gnttab_alloc_pages(int nr_pages, struct page **pages);
 void gnttab_free_pages(int nr_pages, struct page **pages);
 
+int gnttab_pages_set_private(int nr_pages, struct page **pages);
+void gnttab_pages_clear_private(int nr_pages, struct page **pages);
+
 int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 		    struct gnttab_map_grant_ref *kmap_ops,
 		    struct page **pages, unsigned int count);
-- 
2.17.1
