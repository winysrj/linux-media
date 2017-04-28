Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11646 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1422747AbdD1MKE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 08:10:04 -0400
Subject: [PATCH 4/8] atomisp: remove hmm_load/store/clear indirections
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Fri, 28 Apr 2017 13:10:01 +0100
Message-ID: <149338139398.2556.14080556234914874106.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149338135275.2556.7708531564733886566.stgit@acox1-desk1.ger.corp.intel.com>
References: <149338135275.2556.7708531564733886566.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We have a layer of un-needed wrapping here that can go. In addition there are
some functions that don't exist and one that isn't used which can also go.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |    4 +--
 .../media/atomisp/pci/atomisp2/atomisp_fops.c      |    4 +--
 .../pci/atomisp2/css2400/ia_css_memory_access.c    |   15 ++++++-----
 .../atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c |   27 --------------------
 .../atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h |   20 ---------------
 .../media/atomisp/pci/atomisp2/hrt/memory_access.c |    6 ++--
 6 files changed, 15 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index a8614a9..97093ba 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -2922,7 +2922,7 @@ int atomisp_get_metadata(struct atomisp_sub_device *asd, int flag,
 				   md_buf->md_vptr,
 				   stream_info->metadata_info.size);
 	} else {
-		hrt_isp_css_mm_load(md_buf->metadata->address,
+		hmm_load(md_buf->metadata->address,
 				    asd->params.metadata_user[md_type],
 				    stream_info->metadata_info.size);
 
@@ -3005,7 +3005,7 @@ int atomisp_get_metadata_by_type(struct atomisp_sub_device *asd, int flag,
 				   md_buf->md_vptr,
 				   stream_info->metadata_info.size);
 	} else {
-		hrt_isp_css_mm_load(md_buf->metadata->address,
+		hmm_load(md_buf->metadata->address,
 				    asd->params.metadata_user[md_type],
 				    stream_info->metadata_info.size);
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
index e5a7407..7ce8803 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
@@ -1144,11 +1144,11 @@ static int remove_pad_from_frame(struct atomisp_device *isp,
 
 	load += ISP_LEFT_PAD;
 	for (i = 0; i < height; i++) {
-		ret = hrt_isp_css_mm_load(load, buffer, width*sizeof(load));
+		ret = hmm_load(load, buffer, width*sizeof(load));
 		if (ret < 0)
 			goto remove_pad_error;
 
-		ret = hrt_isp_css_mm_store(store, buffer, width*sizeof(store));
+		ret = hmm_store(store, buffer, width*sizeof(store));
 		if (ret < 0)
 			goto remove_pad_error;
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c
index f8fc14c..2820759 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c
@@ -52,22 +52,23 @@ mmgr_calloc(const size_t N, const size_t size)
 	return mmgr_alloc_attr(size * N, MMGR_ATTRIBUTE_CLEARED);
 }
 
-void
-mmgr_clear(hrt_vaddress vaddr, const size_t size)
+void mmgr_clear(hrt_vaddress vaddr, const size_t size)
 {
-	hrt_isp_css_mm_set(vaddr, 0, size);
+	if (vaddr)
+		hmm_set(vaddr, 0, size);
 }
 
-void
-mmgr_load(const hrt_vaddress vaddr, void *data, const size_t size)
+void mmgr_load(const hrt_vaddress vaddr, void *data, const size_t size)
 {
-	hrt_isp_css_mm_load(vaddr, data, size);
+	if (vaddr && data)
+		hmm_load(vaddr, data, size);
 }
 
 void
 mmgr_store(const hrt_vaddress vaddr, const void *data, const size_t size)
 {
-	hrt_isp_css_mm_store(vaddr, data, size);
+	if (vaddr && data)
+		hmm_store(vaddr, data, size);
 }
 
 hrt_vaddress
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c
index 63904bc..7dff22f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c
@@ -28,28 +28,6 @@
 
 #define __page_align(size)	(((size) + (PAGE_SIZE-1)) & (~(PAGE_SIZE-1)))
 
-int hrt_isp_css_mm_set(ia_css_ptr virt_addr, int c, size_t bytes)
-{
-	if (virt_addr)
-		return hmm_set(virt_addr, c, bytes);
-
-	return -EFAULT;
-}
-
-int hrt_isp_css_mm_load(ia_css_ptr virt_addr, void *data, size_t bytes)
-{
-	if (virt_addr && data)
-		return hmm_load(virt_addr, data, bytes);
-	return -EFAULT;
-}
-
-int hrt_isp_css_mm_store(ia_css_ptr virt_addr, const void *data, size_t bytes)
-{
-	if (virt_addr && data)
-		return hmm_store(virt_addr, data, bytes);
-	return -EFAULT;
-}
-
 static void *my_userptr;
 static unsigned my_num_pages;
 static enum hrt_userptr_type my_usr_type;
@@ -149,8 +127,3 @@ ia_css_ptr hrt_isp_css_mm_calloc_cached(size_t bytes)
 	return ptr;
 }
 
-phys_addr_t hrt_isp_css_virt_to_phys(ia_css_ptr virt_addr)
-{
-	return hmm_virt_to_phys(virt_addr);
-}
-
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h
index 3fe9247..1328944 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h
@@ -44,8 +44,6 @@ struct hrt_userbuffer_attr {
 void hrt_isp_css_mm_set_user_ptr(void *userptr,
 				unsigned int num_pages, enum hrt_userptr_type);
 
-int hrt_isp_css_mm_set(ia_css_ptr virt_addr, int c, size_t bytes);
-
 /* Allocate memory, returns a virtual address */
 ia_css_ptr hrt_isp_css_mm_alloc(size_t bytes);
 ia_css_ptr hrt_isp_css_mm_alloc_user_ptr(size_t bytes, void *userptr,
@@ -59,22 +57,4 @@ ia_css_ptr hrt_isp_css_mm_alloc_cached(size_t bytes);
 ia_css_ptr hrt_isp_css_mm_calloc(size_t bytes);
 ia_css_ptr hrt_isp_css_mm_calloc_cached(size_t bytes);
 
-/* Store data to a virtual address */
-int hrt_isp_css_mm_load(ia_css_ptr virt_addr, void *data, size_t bytes);
-
-/* Load data from a virtual address */
-int hrt_isp_css_mm_store(ia_css_ptr virt_addr, const void *data, size_t bytes);
-
-int hrt_isp_css_mm_load_int(ia_css_ptr virt_addr, int *data);
-int hrt_isp_css_mm_load_short(ia_css_ptr virt_addr, short *data);
-int hrt_isp_css_mm_load_char(ia_css_ptr virt_addr, char *data);
-
-int hrt_isp_css_mm_store_char(ia_css_ptr virt_addr, char data);
-int hrt_isp_css_mm_store_short(ia_css_ptr virt_addr, short data);
-int hrt_isp_css_mm_store_int(ia_css_ptr virt_addr, int data);
-
-/* translate a virtual to a physical address, used to program
-   the display driver on  the FPGA system */
-phys_addr_t hrt_isp_css_virt_to_phys(ia_css_ptr virt_addr);
-
 #endif /* _hive_isp_css_mm_hrt_h_ */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hrt/memory_access.c b/drivers/staging/media/atomisp/pci/atomisp2/hrt/memory_access.c
index 6c7f38d..60e70cb 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hrt/memory_access.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hrt/memory_access.c
@@ -89,15 +89,15 @@ void mmgr_clear(
 	ia_css_ptr			vaddr,
 	const size_t			size)
 {
-	hrt_isp_css_mm_set(vaddr, 0, size);
+	hmm_set(vaddr, 0, size);
 }
 
 void mmgr_load(const ia_css_ptr	vaddr, void *data, const size_t size)
 {
-	hrt_isp_css_mm_load(vaddr, data, size);
+	hmm_load(vaddr, data, size);
 }
 
 void mmgr_store(const ia_css_ptr vaddr,	const void *data, const size_t size)
 {
-	hrt_isp_css_mm_store(vaddr, data, size);
+	hmm_store(vaddr, data, size);
 }
