Return-path: <mchehab@gaivota>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10405 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab0LOUip (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Dec 2010 15:38:45 -0500
Date: Wed, 15 Dec 2010 21:34:30 +0100
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv8 10/12] mm: MIGRATE_CMA support added to CMA
In-reply-to: <cover.1292443200.git.m.nazarewicz@samsung.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Ankita Garg <ankita@in.ibm.com>,
	Daniel Walker <dwalker@codeaurora.org>,
	Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mel Gorman <mel@csn.ul.ie>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org
Message-id: <c3a36b3a91e1c06dbb0538b5410f632024114604.1292443200.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1292443200.git.m.nazarewicz@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This commit adds MIGRATE_CMA migratetype support to the CMA.
The advantage is that an (almost) arbitrary memory range can
be marked as MIGRATE_CMA which may not be the case with
ZONE_MOVABLE.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/cma.h |   58 ++++++++++++++++---
 mm/cma.c            |  161 +++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 194 insertions(+), 25 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index e9575fd..8952531 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -71,9 +71,14 @@
  *   a platform/machine specific function.  For the former CMA
  *   provides the following functions:
  *
+ *     cma_init_migratetype()
  *     cma_reserve()
  *     cma_create()
  *
+ *   The first one initialises a portion of reserved memory so that it
+ *   can be used with CMA.  The second first tries to reserve memory
+ *   (using memblock) and then initialise it.
+ *
  *   The cma_reserve() function must be called when memblock is still
  *   operational and reserving memory with it is still possible.  On
  *   ARM platform the "reserve" machine callback is a perfect place to
@@ -93,21 +98,56 @@ struct cma;
 /* Contiguous Memory chunk */
 struct cm;
 
+#ifdef CONFIG_MIGRATE_CMA
+
+/**
+ * cma_init_migratetype() - initialises range of physical memory to be used
+ *		with CMA context.
+ * @start:	start address of the memory range in bytes.
+ * @size:	size of the memory range in bytes.
+ *
+ * The range must be MAX_ORDER_NR_PAGES aligned and it must have been
+ * already reserved (eg. with memblock).
+ *
+ * The actual initialisation is deferred until subsys initcalls are
+ * evaluated (unless this has already happened).
+ *
+ * Returns zero on success or negative error.
+ */
+int cma_init_migratetype(unsigned long start, unsigned long end);
+
+#else
+
+static inline int cma_init_migratetype(unsigned long start, unsigned long end)
+{
+	(void)start; (void)end;
+	return -EOPNOTSUPP;
+}
+
+#endif
+
 /**
  * cma_reserve() - reserves memory.
  * @start:	start address of the memory range in bytes hint; if unsure
  *		pass zero.
  * @size:	size of the memory to reserve in bytes.
  * @alignment:	desired alignment in bytes (must be power of two or zero).
+ * @init_migratetype:	whether to initialise pageblocks.
+ *
+ * It will use memblock to allocate memory.  If @init_migratetype is
+ * true, the function will also call cma_init_migratetype() on
+ * reserved region so that a non-private CMA context can be created on
+ * given range.
  *
- * It will use memblock to allocate memory.  @start and @size will be
- * aligned to PAGE_SIZE.
+ * @start and @size will be aligned to PAGE_SIZE if @init_migratetype
+ * is false or to (MAX_ORDER_NR_PAGES << PAGE_SHIFT) if
+ * @init_migratetype is true.
  *
  * Returns reserved's area physical address or value that yields true
  * when checked with IS_ERR_VALUE().
  */
 unsigned long cma_reserve(unsigned long start, unsigned long size,
-			  unsigned long alignment);
+			  unsigned long alignment, _Bool init_migratetype);
 
 /**
  * cma_create() - creates a CMA context.
@@ -118,12 +158,14 @@ unsigned long cma_reserve(unsigned long start, unsigned long size,
  *
  * The range must be page aligned.  Different contexts cannot overlap.
  *
- * Unless @private is true the memory range must lay in ZONE_MOVABLE.
- * If @private is true no underlaying memory checking is done and
- * during allocation no pages migration will be performed - it is
- * assumed that the memory is reserved and only CMA manages it.
+ * Unless @private is true the memory range must either lay in
+ * ZONE_MOVABLE or must have been initialised with
+ * cma_init_migratetype() function.  If @private is true no
+ * underlaying memory checking is done and during allocation no pages
+ * migration will be performed - it is assumed that the memory is
+ * reserved and only CMA manages it.
  *
- * @start and @size must be page and @min_alignment alignment.
+ * @start and @size must be page and @min_alignment aligned.
  * @min_alignment specifies the minimal alignment that user will be
  * able to request through cm_alloc() function.  In most cases one
  * will probably pass zero as @min_alignment but if the CMA context
diff --git a/mm/cma.c b/mm/cma.c
index d82361b..4017dee 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -57,21 +57,130 @@ static unsigned long phys_to_pfn(phys_addr_t phys)
 
 /************************* Initialise CMA *************************/
 
+#ifdef CONFIG_MIGRATE_CMA
+
+static struct cma_grabbed {
+	unsigned long start;
+	unsigned long size;
+} cma_grabbed[8] __initdata;
+static unsigned cma_grabbed_count __initdata;
+
+#ifdef CONFIG_DEBUG_VM
+
+static int __cma_give_back(unsigned long start, unsigned long size)
+{
+	unsigned long pfn = phys_to_pfn(start);
+	unsigned i = size >> PAGE_SHIFT;
+	struct zone *zone;
+
+	pr_debug("%s(%p+%p)\n", __func__, (void *)start, (void *)size);
+
+	VM_BUG_ON(!pfn_valid(pfn));
+	zone = page_zone(pfn_to_page(pfn));
+
+	do {
+		VM_BUG_ON(!pfn_valid(pfn));
+		VM_BUG_ON(page_zone(pfn_to_page(pfn)) != zone);
+		if (!(pfn & (pageblock_nr_pages - 1)))
+			__free_pageblock_cma(pfn_to_page(pfn));
+		++pfn;
+	} while (--i);
+
+	return 0;
+}
+
+#else
+
+static int __cma_give_back(unsigned long start, unsigned long size)
+{
+	unsigned i = size >> (PAGE_SHIFT + pageblock_order);
+	struct page *p = phys_to_page(start);
+
+	pr_debug("%s(%p+%p)\n", __func__, (void *)start, (void *)size);
+
+	do {
+		__free_pageblock_cma(p);
+		p += pageblock_nr_pages;
+	} while (--i);
+
+	return 0;
+}
+
+#endif
+
+static int __init __cma_queue_give_back(unsigned long start, unsigned long size)
+{
+	if (cma_grabbed_count == ARRAY_SIZE(cma_grabbed))
+		return -ENOSPC;
+
+	cma_grabbed[cma_grabbed_count].start = start;
+	cma_grabbed[cma_grabbed_count].size  = size;
+	++cma_grabbed_count;
+	return 0;
+}
+
+static int (*cma_give_back)(unsigned long start, unsigned long size) =
+	__cma_queue_give_back;
+
+static int __init cma_give_back_queued(void)
+{
+	struct cma_grabbed *r = cma_grabbed;
+	unsigned i = cma_grabbed_count;
+
+	pr_debug("%s(): will give %u range(s)\n", __func__, i);
+
+	cma_give_back = __cma_give_back;
+
+	for (; i; --i, ++r)
+		__cma_give_back(r->start, r->size);
+
+	return 0;
+}
+subsys_initcall(cma_give_back_queued);
+
+int __ref cma_init_migratetype(unsigned long start, unsigned long size)
+{
+	pr_debug("%s(%p+%p)\n", __func__, (void *)start, (void *)size);
+
+	if (!size)
+		return -EINVAL;
+	if ((start | size) & ((MAX_ORDER_NR_PAGES << PAGE_SHIFT) - 1))
+		return -EINVAL;
+	if (start + size < start)
+		return -EOVERFLOW;
+
+	return cma_give_back(start, size);
+}
+
+#endif
+
 unsigned long cma_reserve(unsigned long start, unsigned long size,
-			  unsigned long alignment)
+			  unsigned long alignment, bool init_migratetype)
 {
 	pr_debug("%s(%p+%p/%p)\n", __func__, (void *)start, (void *)size,
 		 (void *)alignment);
 
+#ifndef CONFIG_MIGRATE_CMA
+	if (init_migratetype)
+		return -EOPNOTSUPP;
+#endif
+
 	/* Sanity checks */
 	if (!size || (alignment & (alignment - 1)))
 		return (unsigned long)-EINVAL;
 
 	/* Sanitise input arguments */
-	start = PAGE_ALIGN(start);
-	size  = PAGE_ALIGN(size);
-	if (alignment < PAGE_SIZE)
-		alignment = PAGE_SIZE;
+	if (init_migratetype) {
+		start = ALIGN(start, MAX_ORDER_NR_PAGES << PAGE_SHIFT);
+		size  = ALIGN(size , MAX_ORDER_NR_PAGES << PAGE_SHIFT);
+		if (alignment < (MAX_ORDER_NR_PAGES << PAGE_SHIFT))
+			alignment = MAX_ORDER_NR_PAGES << PAGE_SHIFT;
+	} else {
+		start = PAGE_ALIGN(start);
+		size  = PAGE_ALIGN(size);
+		if (alignment < PAGE_SIZE)
+			alignment = PAGE_SIZE;
+	}
 
 	/* Reserve memory */
 	if (start) {
@@ -94,6 +203,15 @@ unsigned long cma_reserve(unsigned long start, unsigned long size,
 		}
 	}
 
+	/* CMA Initialise */
+	if (init_migratetype) {
+		int ret = cma_init_migratetype(start, size);
+		if (ret < 0) {
+			memblock_free(start, size);
+			return ret;
+		}
+	}
+
 	return start;
 }
 
@@ -101,12 +219,13 @@ unsigned long cma_reserve(unsigned long start, unsigned long size,
 /************************** CMA context ***************************/
 
 struct cma {
-	bool migrate;
+	int migratetype;
 	struct gen_pool *pool;
 };
 
 static int __cma_check_range(unsigned long start, unsigned long size)
 {
+	int migratetype = MIGRATE_MOVABLE;
 	unsigned long pfn, count;
 	struct page *page;
 	struct zone *zone;
@@ -115,8 +234,13 @@ static int __cma_check_range(unsigned long start, unsigned long size)
 	if (WARN_ON(!pfn_valid(start)))
 		return -EINVAL;
 
+#ifdef CONFIG_MIGRATE_CMA
+	if (page_zonenum(pfn_to_page(start)) != ZONE_MOVABLE)
+		migratetype = MIGRATE_CMA;
+#else
 	if (WARN_ON(page_zonenum(pfn_to_page(start)) != ZONE_MOVABLE))
 		return -EINVAL;
+#endif
 
 	/* First check if all pages are valid and in the same zone */
 	zone  = page_zone(pfn_to_page(start));
@@ -134,20 +258,20 @@ static int __cma_check_range(unsigned long start, unsigned long size)
 	page  = pfn_to_page(start);
 	count = (pfn - start) >> PAGE_SHIFT;
 	do {
-		if (WARN_ON(get_pageblock_migratetype(page) != MIGRATE_MOVABLE))
+		if (WARN_ON(get_pageblock_migratetype(page) != migratetype))
 			return -EINVAL;
 		page += pageblock_nr_pages;
 	} while (--count);
 
-	return 0;
+	return migratetype;
 }
 
 struct cma *cma_create(unsigned long start, unsigned long size,
 		       unsigned long min_alignment, bool private)
 {
 	struct gen_pool *pool;
+	int migratetype, ret;
 	struct cma *cma;
-	int ret;
 
 	pr_debug("%s(%p+%p)\n", __func__, (void *)start, (void *)size);
 
@@ -162,10 +286,12 @@ struct cma *cma_create(unsigned long start, unsigned long size,
 	if (start + size < start)
 		return ERR_PTR(-EOVERFLOW);
 
-	if (!private) {
-		ret = __cma_check_range(start, size);
-		if (ret < 0)
-			return ERR_PTR(ret);
+	if (private) {
+		migratetype = 0;
+	} else {
+		migratetype = __cma_check_range(start, size);
+		if (migratetype < 0)
+			return ERR_PTR(migratetype);
 	}
 
 	cma = kmalloc(sizeof *cma, GFP_KERNEL);
@@ -182,7 +308,7 @@ struct cma *cma_create(unsigned long start, unsigned long size,
 	if (unlikely(ret))
 		goto error2;
 
-	cma->migrate = !private;
+	cma->migratetype = migratetype;
 	cma->pool = pool;
 
 	pr_debug("%s: returning <%p>\n", __func__, (void *)cma);
@@ -238,9 +364,10 @@ struct cm *cm_alloc(struct cma *cma, unsigned long size,
 	if (!start)
 		goto error1;
 
-	if (cma->migrate) {
+	if (cma->migratetype) {
 		unsigned long pfn = phys_to_pfn(start);
-		ret = alloc_contig_range(pfn, pfn + (size >> PAGE_SHIFT), 0);
+		ret = alloc_contig_range(pfn, pfn + (size >> PAGE_SHIFT),
+					 0, cma->migratetype);
 		if (ret)
 			goto error2;
 	}
@@ -275,7 +402,7 @@ void cm_free(struct cm *cm)
 	mutex_lock(&cma_mutex);
 
 	gen_pool_free(cm->cma->pool, cm->phys, cm->size);
-	if (cm->cma->migrate)
+	if (cm->cma->migratetype)
 		free_contig_pages(phys_to_page(cm->phys),
 				  cm->size >> PAGE_SHIFT);
 
-- 
1.7.2.3

