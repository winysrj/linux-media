Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:18823 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754249AbdDLSVo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 14:21:44 -0400
Subject: [PATCH 06/14] atomisp: remove most of the uses of
 atomisp_kernel_malloc
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Wed, 12 Apr 2017 19:21:05 +0100
Message-ID: <149202125625.16615.5727158114556004110.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
References: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

They can be replaced by kmalloc. There are a few that do need to pick kmalloc
or vmalloc. Those we leave for the moment.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../atomisp/pci/atomisp2/atomisp_compat_css20.c    |    4 --
 .../media/atomisp/pci/atomisp2/hmm/hmm_bo.c        |   34 ++++++++++----------
 .../atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c    |    8 ++---
 .../atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c   |   14 ++++----
 4 files changed, 28 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
index 2e20a81..6586842 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
@@ -1669,11 +1669,7 @@ int atomisp_alloc_dis_coef_buf(struct atomisp_sub_device *asd)
 
 int atomisp_alloc_metadata_output_buf(struct atomisp_sub_device *asd)
 {
-#ifndef ISP2401
-	int i; /* Coverity CID 298003 - index var must be signed */
-#else
 	int i;
-#endif
 
 	/* We allocate the cpu-side buffer used for communication with user
 	 * space */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
index a51a27b..11162f5 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
@@ -725,8 +725,8 @@ static int alloc_private_pages(struct hmm_buffer_object *bo,
 
 	pgnr = bo->pgnr;
 
-	bo->page_obj = atomisp_kernel_malloc(
-				sizeof(struct hmm_page_object) * pgnr);
+	bo->page_obj = kmalloc(sizeof(struct hmm_page_object) * pgnr,
+				GFP_KERNEL);
 	if (unlikely(!bo->page_obj)) {
 		dev_err(atomisp_dev, "out of memory for bo->page_obj\n");
 		return -ENOMEM;
@@ -860,7 +860,7 @@ static int alloc_private_pages(struct hmm_buffer_object *bo,
 	alloc_pgnr = i;
 	free_private_bo_pages(bo, dypool, repool, alloc_pgnr);
 
-	atomisp_kernel_free(bo->page_obj);
+	kfree(bo->page_obj);
 
 	return -ENOMEM;
 }
@@ -871,7 +871,7 @@ static void free_private_pages(struct hmm_buffer_object *bo,
 {
 	free_private_bo_pages(bo, dypool, repool, bo->pgnr);
 
-	atomisp_kernel_free(bo->page_obj);
+	kfree(bo->page_obj);
 }
 
 /*
@@ -990,17 +990,17 @@ static int alloc_user_pages(struct hmm_buffer_object *bo,
 	struct vm_area_struct *vma;
 	struct page **pages;
 
-	pages = atomisp_kernel_malloc(sizeof(struct page *) * bo->pgnr);
+	pages = kmalloc(sizeof(struct page *) * bo->pgnr, GFP_KERNEL);
 	if (unlikely(!pages)) {
 		dev_err(atomisp_dev, "out of memory for pages...\n");
 		return -ENOMEM;
 	}
 
-	bo->page_obj = atomisp_kernel_malloc(
-				sizeof(struct hmm_page_object) * bo->pgnr);
+	bo->page_obj = kmalloc(sizeof(struct hmm_page_object) * bo->pgnr,
+		GFP_KERNEL);
 	if (unlikely(!bo->page_obj)) {
 		dev_err(atomisp_dev, "out of memory for bo->page_obj...\n");
-		atomisp_kernel_free(pages);
+		kfree(pages);
 		return -ENOMEM;
 	}
 
@@ -1010,8 +1010,8 @@ static int alloc_user_pages(struct hmm_buffer_object *bo,
 	up_read(&current->mm->mmap_sem);
 	if (vma == NULL) {
 		dev_err(atomisp_dev, "find_vma failed\n");
-		atomisp_kernel_free(bo->page_obj);
-		atomisp_kernel_free(pages);
+		kfree(bo->page_obj);
+		kfree(pages);
 		mutex_lock(&bo->mutex);
 		return -EFAULT;
 	}
@@ -1051,15 +1051,15 @@ static int alloc_user_pages(struct hmm_buffer_object *bo,
 		bo->page_obj[i].type = HMM_PAGE_TYPE_GENERAL;
 	}
 	hmm_mem_stat.usr_size += bo->pgnr;
-	atomisp_kernel_free(pages);
+	kfree(pages);
 
 	return 0;
 
 out_of_mem:
 	for (i = 0; i < page_nr; i++)
 		put_page(pages[i]);
-	atomisp_kernel_free(pages);
-	atomisp_kernel_free(bo->page_obj);
+	kfree(pages);
+	kfree(bo->page_obj);
 
 	return -ENOMEM;
 }
@@ -1072,7 +1072,7 @@ static void free_user_pages(struct hmm_buffer_object *bo)
 		put_page(bo->page_obj[i].page);
 	hmm_mem_stat.usr_size -= bo->pgnr;
 
-	atomisp_kernel_free(bo->page_obj);
+	kfree(bo->page_obj);
 }
 
 /*
@@ -1363,7 +1363,7 @@ void *hmm_bo_vmap(struct hmm_buffer_object *bo, bool cached)
 		bo->status &= ~(HMM_BO_VMAPED | HMM_BO_VMAPED_CACHED);
 	}
 
-	pages = atomisp_kernel_malloc(sizeof(*pages) * bo->pgnr);
+	pages = kmalloc(sizeof(*pages) * bo->pgnr, GFP_KERNEL);
 	if (unlikely(!pages)) {
 		mutex_unlock(&bo->mutex);
 		dev_err(atomisp_dev, "out of memory for pages...\n");
@@ -1376,14 +1376,14 @@ void *hmm_bo_vmap(struct hmm_buffer_object *bo, bool cached)
 	bo->vmap_addr = vmap(pages, bo->pgnr, VM_MAP,
 		cached ? PAGE_KERNEL : PAGE_KERNEL_NOCACHE);
 	if (unlikely(!bo->vmap_addr)) {
-		atomisp_kernel_free(pages);
+		kfree(pages);
 		mutex_unlock(&bo->mutex);
 		dev_err(atomisp_dev, "vmap failed...\n");
 		return NULL;
 	}
 	bo->status |= (cached ? HMM_BO_VMAPED_CACHED : HMM_BO_VMAPED);
 
-	atomisp_kernel_free(pages);
+	kfree(pages);
 
 	mutex_unlock(&bo->mutex);
 	return bo->vmap_addr;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c
index 9b35980..19e0e9e 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c
@@ -149,8 +149,8 @@ static int hmm_dynamic_pool_init(void **pool, unsigned int pool_size)
 	if (pool_size == 0)
 		return 0;
 
-	dypool_info = atomisp_kernel_malloc(
-					sizeof(struct hmm_dynamic_pool_info));
+	dypool_info = kmalloc(sizeof(struct hmm_dynamic_pool_info),
+		GFP_KERNEL);
 	if (unlikely(!dypool_info)) {
 		dev_err(atomisp_dev, "out of memory for repool_info.\n");
 		return -ENOMEM;
@@ -160,7 +160,7 @@ static int hmm_dynamic_pool_init(void **pool, unsigned int pool_size)
 						sizeof(struct hmm_page), 0,
 						SLAB_HWCACHE_ALIGN, NULL);
 	if (!dypool_info->pgptr_cache) {
-		atomisp_kernel_free(dypool_info);
+		kfree(dypool_info);
 		return -ENOMEM;
 	}
 
@@ -217,7 +217,7 @@ static void hmm_dynamic_pool_exit(void **pool)
 
 	kmem_cache_destroy(dypool_info->pgptr_cache);
 
-	atomisp_kernel_free(dypool_info);
+	kfree(dypool_info);
 
 	*pool = NULL;
 }
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c
index b51b619..bf65868 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c
@@ -90,18 +90,18 @@ static int hmm_reserved_pool_setup(struct hmm_reserved_pool_info **repool_info,
 {
 	struct hmm_reserved_pool_info *pool_info;
 
-	pool_info = atomisp_kernel_malloc(
-					sizeof(struct hmm_reserved_pool_info));
+	pool_info = kmalloc(sizeof(struct hmm_reserved_pool_info),
+				GFP_KERNEL);
 	if (unlikely(!pool_info)) {
 		dev_err(atomisp_dev, "out of memory for repool_info.\n");
 		return -ENOMEM;
 	}
 
-	pool_info->pages = atomisp_kernel_malloc(
-					sizeof(struct page *) * pool_size);
+	pool_info->pages = kmalloc(sizeof(struct page *) * pool_size,
+			GFP_KERNEL);
 	if (unlikely(!pool_info->pages)) {
 		dev_err(atomisp_dev, "out of memory for repool_info->pages.\n");
-		atomisp_kernel_free(pool_info);
+		kfree(pool_info);
 		return -ENOMEM;
 	}
 
@@ -234,8 +234,8 @@ static void hmm_reserved_pool_exit(void **pool)
 			__free_pages(repool_info->pages[i], 0);
 	}
 
-	atomisp_kernel_free(repool_info->pages);
-	atomisp_kernel_free(repool_info);
+	kfree(repool_info->pages);
+	kfree(repool_info);
 
 	*pool = NULL;
 }
