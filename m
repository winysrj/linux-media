Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62229 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1035826AbdD1MJi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 08:09:38 -0400
Subject: [PATCH 2/8] atomisp: clean up the hmm init/cleanup indirections
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Fri, 28 Apr 2017 13:09:33 +0100
Message-ID: <149338136995.2556.13722378584162244853.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149338135275.2556.7708531564733886566.stgit@acox1-desk1.ger.corp.intel.com>
References: <149338135275.2556.7708531564733886566.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We don't need any of these indirections as we only support one MMU type. Start
by getting rid of the init/clear/free ones. The init ordering check we already
pushed down in a previous patch.

The allocation side is more complicated so leave it for now.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      |    6 ++---
 .../pci/atomisp2/css2400/ia_css_memory_access.c    |    2 +-
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   |    4 ++-
 .../atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c |   26 --------------------
 .../atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h |    5 ----
 .../media/atomisp/pci/atomisp2/hrt/memory_access.c |    4 ++-
 6 files changed, 8 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index 9bd186b..35414c9 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -1454,7 +1454,7 @@ static int atomisp_pci_probe(struct pci_dev *dev,
 	}
 
 	/* Init ISP memory management */
-	hrt_isp_css_mm_init();
+	hmm_init();
 
 	err = devm_request_threaded_irq(&dev->dev, dev->irq,
 					atomisp_isr, atomisp_isr_thread,
@@ -1486,7 +1486,7 @@ static int atomisp_pci_probe(struct pci_dev *dev,
 css_init_fail:
 	devm_free_irq(&dev->dev, dev->irq, isp);
 request_irq_fail:
-	hrt_isp_css_mm_clear();
+	hmm_cleanup();
 	hmm_pool_unregister(HMM_POOL_TYPE_RESERVED);
 hmm_pool_fail:
 	destroy_workqueue(isp->wdt_work_queue);
@@ -1538,7 +1538,7 @@ static void atomisp_pci_remove(struct pci_dev *dev)
 	atomisp_acc_cleanup(isp);
 
 	atomisp_css_unload_firmware(isp);
-	hrt_isp_css_mm_clear();
+	hmm_cleanup();
 
 	pm_runtime_forbid(&dev->dev);
 	pm_runtime_get_noresume(&dev->dev);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c
index 1f6ae20..5b2bdfd 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c
@@ -55,7 +55,7 @@ mmgr_calloc(const size_t N, const size_t size)
 void
 mmgr_free(hrt_vaddress vaddr)
 {
-	hrt_isp_css_mm_free(vaddr);
+	hmm_free(vaddr);
 }
 
 void
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
index 14537ab..3588723 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
@@ -272,6 +272,8 @@ void hmm_free(ia_css_ptr virt)
 {
 	struct hmm_buffer_object *bo;
 
+	WARN_ON(!virt);
+
 	bo = hmm_bo_device_search_start(&bo_device, (unsigned int)virt);
 
 	if (!bo) {
@@ -284,9 +286,7 @@ void hmm_free(ia_css_ptr virt)
 	hmm_mem_stat.tol_cnt -= bo->pgnr;
 
 	hmm_bo_unbind(bo);
-
 	hmm_bo_free_pages(bo);
-
 	hmm_bo_unref(bo);
 }
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c
index 78b4709..63904bc 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c
@@ -28,13 +28,6 @@
 
 #define __page_align(size)	(((size) + (PAGE_SIZE-1)) & (~(PAGE_SIZE-1)))
 
-static unsigned init_done;
-void hrt_isp_css_mm_init(void)
-{
-	hmm_init();
-	init_done = 1;
-}
-
 int hrt_isp_css_mm_set(ia_css_ptr virt_addr, int c, size_t bytes)
 {
 	if (virt_addr)
@@ -57,20 +50,6 @@ int hrt_isp_css_mm_store(ia_css_ptr virt_addr, const void *data, size_t bytes)
 	return -EFAULT;
 }
 
-void hrt_isp_css_mm_free(ia_css_ptr virt_addr)
-{
-	if (virt_addr)
-		hmm_free(virt_addr);
-}
-
-void hrt_isp_css_mm_clear(void)
-{
-	if (init_done) {
-		hmm_cleanup();
-		init_done = 0;
-	}
-}
-
 static void *my_userptr;
 static unsigned my_num_pages;
 static enum hrt_userptr_type my_usr_type;
@@ -89,8 +68,6 @@ static ia_css_ptr __hrt_isp_css_mm_alloc(size_t bytes, void *userptr,
 				    enum hrt_userptr_type type,
 				    bool cached)
 {
-	if (!init_done)
-		hrt_isp_css_mm_init();
 #ifdef CONFIG_ION
 	if (type == HRT_USR_ION)
 		return hmm_alloc(bytes, HMM_BO_ION, 0,
@@ -138,9 +115,6 @@ ia_css_ptr hrt_isp_css_mm_alloc_user_ptr(size_t bytes, void *userptr,
 
 ia_css_ptr hrt_isp_css_mm_alloc_cached(size_t bytes)
 {
-	if (!init_done)
-		hrt_isp_css_mm_init();
-
 	if (my_userptr == NULL)
 		return hmm_alloc(bytes, HMM_BO_PRIVATE, 0, 0,
 						HMM_CACHED);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h
index 4783206..3fe9247 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h
@@ -41,7 +41,6 @@ struct hrt_userbuffer_attr {
 	unsigned int		pgnr;
 };
 
-void hrt_isp_css_mm_init(void);
 void hrt_isp_css_mm_set_user_ptr(void *userptr,
 				unsigned int num_pages, enum hrt_userptr_type);
 
@@ -60,9 +59,6 @@ ia_css_ptr hrt_isp_css_mm_alloc_cached(size_t bytes);
 ia_css_ptr hrt_isp_css_mm_calloc(size_t bytes);
 ia_css_ptr hrt_isp_css_mm_calloc_cached(size_t bytes);
 
-/* Free memory, given a virtual address */
-void hrt_isp_css_mm_free(ia_css_ptr virt_addr);
-
 /* Store data to a virtual address */
 int hrt_isp_css_mm_load(ia_css_ptr virt_addr, void *data, size_t bytes);
 
@@ -81,5 +77,4 @@ int hrt_isp_css_mm_store_int(ia_css_ptr virt_addr, int data);
    the display driver on  the FPGA system */
 phys_addr_t hrt_isp_css_virt_to_phys(ia_css_ptr virt_addr);
 
-void hrt_isp_css_mm_clear(void);
 #endif /* _hive_isp_css_mm_hrt_h_ */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hrt/memory_access.c b/drivers/staging/media/atomisp/pci/atomisp2/hrt/memory_access.c
index 7694ee4..9d3900f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hrt/memory_access.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hrt/memory_access.c
@@ -47,9 +47,9 @@ ia_css_ptr mmgr_calloc(const size_t N, const size_t size)
 
 void mmgr_free(ia_css_ptr vaddr)
 {
-/* "free()" should accept NULL, "hrt_isp_css_mm_free()" may not */
+/* "free()" should accept NULL, "hmm_free()" may not */
 	if (vaddr)
-		hrt_isp_css_mm_free(vaddr);
+		hmm_free(vaddr);
 }
 
 ia_css_ptr mmgr_alloc_attr(const size_t	size, const uint16_t attribute)
