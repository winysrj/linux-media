Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbbGMO4B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2015 10:56:01 -0400
From: Jan Kara <jack@suse.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-samsung-soc@vger.kernel.org, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 2/9] mm: Provide new get_vaddr_frames() helper
Date: Mon, 13 Jul 2015 16:55:44 +0200
Message-Id: <1436799351-21975-3-git-send-email-jack@suse.com>
In-Reply-To: <1436799351-21975-1-git-send-email-jack@suse.com>
References: <1436799351-21975-1-git-send-email-jack@suse.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

Provide new function get_vaddr_frames().  This function maps virtual
addresses from given start and fills given array with page frame numbers of
the corresponding pages. If given start belongs to a normal vma, the function
grabs reference to each of the pages to pin them in memory. If start
belongs to VM_IO | VM_PFNMAP vma, we don't touch page structures. Caller
must make sure pfns aren't reused for anything else while he is using
them.

This function is created for various drivers to simplify handling of
their buffers.

Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/mm.h |  44 ++++++++++
 mm/Kconfig         |   3 +
 mm/Makefile        |   1 +
 mm/frame_vector.c  | 231 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 279 insertions(+)
 create mode 100644 mm/frame_vector.c

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2e872f92dbac..79ad29a8a60a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -20,6 +20,7 @@
 #include <linux/shrinker.h>
 #include <linux/resource.h>
 #include <linux/page_ext.h>
+#include <linux/err.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -1198,6 +1199,49 @@ long get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
 		    int write, int force, struct page **pages);
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
+
+/* Container for pinned pfns / pages */
+struct frame_vector {
+	unsigned int nr_allocated;	/* Number of frames we have space for */
+	unsigned int nr_frames;	/* Number of frames stored in ptrs array */
+	bool got_ref;		/* Did we pin pages by getting page ref? */
+	bool is_pfns;		/* Does array contain pages or pfns? */
+	void *ptrs[0];		/* Array of pinned pfns / pages. Use
+				 * pfns_vector_pages() or pfns_vector_pfns()
+				 * for access */
+};
+
+struct frame_vector *frame_vector_create(unsigned int nr_frames);
+void frame_vector_destroy(struct frame_vector *vec);
+int get_vaddr_frames(unsigned long start, unsigned int nr_pfns,
+		     bool write, bool force, struct frame_vector *vec);
+void put_vaddr_frames(struct frame_vector *vec);
+int frame_vector_to_pages(struct frame_vector *vec);
+void frame_vector_to_pfns(struct frame_vector *vec);
+
+static inline unsigned int frame_vector_count(struct frame_vector *vec)
+{
+	return vec->nr_frames;
+}
+
+static inline struct page **frame_vector_pages(struct frame_vector *vec)
+{
+	if (vec->is_pfns) {
+		int err = frame_vector_to_pages(vec);
+
+		if (err)
+			return ERR_PTR(err);
+	}
+	return (struct page **)(vec->ptrs);
+}
+
+static inline unsigned long *frame_vector_pfns(struct frame_vector *vec)
+{
+	if (!vec->is_pfns)
+		frame_vector_to_pfns(vec);
+	return (unsigned long *)(vec->ptrs);
+}
+
 struct kvec;
 int get_kernel_pages(const struct kvec *iov, int nr_pages, int write,
 			struct page **pages);
diff --git a/mm/Kconfig b/mm/Kconfig
index e79de2bd12cd..7f146dd32fc5 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -654,3 +654,6 @@ config DEFERRED_STRUCT_PAGE_INIT
 	  when kswapd starts. This has a potential performance impact on
 	  processes running early in the lifetime of the systemm until kswapd
 	  finishes the initialisation.
+
+config FRAME_VECTOR
+	bool
diff --git a/mm/Makefile b/mm/Makefile
index 98c4eaeabdcb..be5d5c866305 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -78,3 +78,4 @@ obj-$(CONFIG_CMA)	+= cma.o
 obj-$(CONFIG_MEMORY_BALLOON) += balloon_compaction.o
 obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
 obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
+obj-$(CONFIG_FRAME_VECTOR) += frame_vector.o
diff --git a/mm/frame_vector.c b/mm/frame_vector.c
new file mode 100644
index 000000000000..f76b579e46f1
--- /dev/null
+++ b/mm/frame_vector.c
@@ -0,0 +1,231 @@
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/pagemap.h>
+#include <linux/sched.h>
+
+/*
+ * get_vaddr_frames() - map virtual addresses to pfns
+ * @start:	starting user address
+ * @nr_frames:	number of pages / pfns from start to map
+ * @write:	whether pages will be written to by the caller
+ * @force:	whether to force write access even if user mapping is
+ *		readonly. See description of the same argument of
+		get_user_pages().
+ * @vec:	structure which receives pages / pfns of the addresses mapped.
+ *		It should have space for at least nr_frames entries.
+ *
+ * This function maps virtual addresses from @start and fills @vec structure
+ * with page frame numbers or page pointers to corresponding pages (choice
+ * depends on the type of the vma underlying the virtual address). If @start
+ * belongs to a normal vma, the function grabs reference to each of the pages
+ * to pin them in memory. If @start belongs to VM_IO | VM_PFNMAP vma, we don't
+ * touch page structures and the caller must make sure pfns aren't reused for
+ * anything else while he is using them.
+ *
+ * The function returns number of pages mapped which may be less than
+ * @nr_frames. In particular we stop mapping if there are more vmas of
+ * different type underlying the specified range of virtual addresses.
+ * When the function isn't able to map a single page, it returns error.
+ *
+ * This function takes care of grabbing mmap_sem as necessary.
+ */
+int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
+		     bool write, bool force, struct frame_vector *vec)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+	int ret = 0;
+	int err;
+	int locked;
+
+	if (nr_frames == 0)
+		return 0;
+
+	if (WARN_ON_ONCE(nr_frames > vec->nr_allocated))
+		nr_frames = vec->nr_allocated;
+
+	down_read(&mm->mmap_sem);
+	locked = 1;
+	vma = find_vma_intersection(mm, start, start + 1);
+	if (!vma) {
+		ret = -EFAULT;
+		goto out;
+	}
+	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP))) {
+		vec->got_ref = true;
+		vec->is_pfns = false;
+		ret = get_user_pages_locked(current, mm, start, nr_frames,
+			write, force, (struct page **)(vec->ptrs), &locked);
+		goto out;
+	}
+
+	vec->got_ref = false;
+	vec->is_pfns = true;
+	do {
+		unsigned long *nums = frame_vector_pfns(vec);
+
+		while (ret < nr_frames && start + PAGE_SIZE <= vma->vm_end) {
+			err = follow_pfn(vma, start, &nums[ret]);
+			if (err) {
+				if (ret == 0)
+					ret = err;
+				goto out;
+			}
+			start += PAGE_SIZE;
+			ret++;
+		}
+		/*
+		 * We stop if we have enough pages or if VMA doesn't completely
+		 * cover the tail page.
+		 */
+		if (ret >= nr_frames || start < vma->vm_end)
+			break;
+		vma = find_vma_intersection(mm, start, start + 1);
+	} while (vma && vma->vm_flags & (VM_IO | VM_PFNMAP));
+out:
+	if (locked)
+		up_read(&mm->mmap_sem);
+	if (!ret)
+		ret = -EFAULT;
+	if (ret > 0)
+		vec->nr_frames = ret;
+	return ret;
+}
+EXPORT_SYMBOL(get_vaddr_frames);
+
+/**
+ * put_vaddr_frames() - drop references to pages if get_vaddr_frames() acquired
+ *			them
+ * @vec:	frame vector to put
+ *
+ * Drop references to pages if get_vaddr_frames() acquired them. We also
+ * invalidate the frame vector so that it is prepared for the next call into
+ * get_vaddr_frames().
+ */
+void put_vaddr_frames(struct frame_vector *vec)
+{
+	int i;
+	struct page **pages;
+
+	if (!vec->got_ref)
+		goto out;
+	pages = frame_vector_pages(vec);
+	/*
+	 * frame_vector_pages() might needed to do a conversion when
+	 * get_vaddr_frames() got pages but vec was later converted to pfns.
+	 * But it shouldn't really fail to convert pfns back...
+	 */
+	if (WARN_ON(IS_ERR(pages)))
+		goto out;
+	for (i = 0; i < vec->nr_frames; i++)
+		put_page(pages[i]);
+	vec->got_ref = false;
+out:
+	vec->nr_frames = 0;
+}
+EXPORT_SYMBOL(put_vaddr_frames);
+
+/**
+ * frame_vector_to_pages - convert frame vector to contain page pointers
+ * @vec:	frame vector to convert
+ *
+ * Convert @vec to contain array of page pointers.  If the conversion is
+ * successful, return 0. Otherwise return an error. Note that we do not grab
+ * page references for the page structures.
+ */
+int frame_vector_to_pages(struct frame_vector *vec)
+{
+	int i;
+	unsigned long *nums;
+	struct page **pages;
+
+	if (!vec->is_pfns)
+		return 0;
+	nums = frame_vector_pfns(vec);
+	for (i = 0; i < vec->nr_frames; i++)
+		if (!pfn_valid(nums[i]))
+			return -EINVAL;
+	pages = (struct page **)nums;
+	for (i = 0; i < vec->nr_frames; i++)
+		pages[i] = pfn_to_page(nums[i]);
+	vec->is_pfns = false;
+	return 0;
+}
+EXPORT_SYMBOL(frame_vector_to_pages);
+
+/**
+ * frame_vector_to_pfns - convert frame vector to contain pfns
+ * @vec:	frame vector to convert
+ *
+ * Convert @vec to contain array of pfns.
+ */
+void frame_vector_to_pfns(struct frame_vector *vec)
+{
+	int i;
+	unsigned long *nums;
+	struct page **pages;
+
+	if (vec->is_pfns)
+		return;
+	pages = (struct page **)(vec->ptrs);
+	nums = (unsigned long *)pages;
+	for (i = 0; i < vec->nr_frames; i++)
+		nums[i] = page_to_pfn(pages[i]);
+	vec->is_pfns = true;
+}
+EXPORT_SYMBOL(frame_vector_to_pfns);
+
+/**
+ * frame_vector_create() - allocate & initialize structure for pinned pfns
+ * @nr_frames:	number of pfns slots we should reserve
+ *
+ * Allocate and initialize struct pinned_pfns to be able to hold @nr_pfns
+ * pfns.
+ */
+struct frame_vector *frame_vector_create(unsigned int nr_frames)
+{
+	struct frame_vector *vec;
+	int size = sizeof(struct frame_vector) + sizeof(void *) * nr_frames;
+
+	if (WARN_ON_ONCE(nr_frames == 0))
+		return NULL;
+	/*
+	 * This is absurdly high. It's here just to avoid strange effects when
+	 * arithmetics overflows.
+	 */
+	if (WARN_ON_ONCE(nr_frames > INT_MAX / sizeof(void *) / 2))
+		return NULL;
+	/*
+	 * Avoid higher order allocations, use vmalloc instead. It should
+	 * be rare anyway.
+	 */
+	if (size <= PAGE_SIZE)
+		vec = kmalloc(size, GFP_KERNEL);
+	else
+		vec = vmalloc(size);
+	if (!vec)
+		return NULL;
+	vec->nr_allocated = nr_frames;
+	vec->nr_frames = 0;
+	return vec;
+}
+EXPORT_SYMBOL(frame_vector_create);
+
+/**
+ * frame_vector_destroy() - free memory allocated to carry frame vector
+ * @vec:	Frame vector to free
+ *
+ * Free structure allocated by frame_vector_create() to carry frames.
+ */
+void frame_vector_destroy(struct frame_vector *vec)
+{
+	/* Make sure put_vaddr_frames() got called properly... */
+	VM_BUG_ON(vec->nr_frames > 0);
+	kvfree(vec);
+}
+EXPORT_SYMBOL(frame_vector_destroy);
+
-- 
2.1.4

