Return-path: <linux-media-owner@vger.kernel.org>
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40193 "EHLO
        faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752335AbdGIRqD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Jul 2017 13:46:03 -0400
From: Philipp Guendisch <philipp.guendisch@fau.de>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        jeremy.lefaure@lse.epita.fr, fabf@skynet.be, rvarsha016@gmail.com,
        philipp.guendisch@fau.de, chris.baller@gmx.de, robsonde@gmail.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de
Subject: [PATCH] checkpatch: fixed alignment and comment style
Date: Sun,  9 Jul 2017 19:39:46 +0200
Message-Id: <1499621986-29717-1-git-send-email-philipp.guendisch@fau.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixed alignment, comment style and one appearance of
misordered constant in an if comparison.
Semantic should not be affected by this patch.

There are still a few warnings and even errors left which require
a semantic change of the code to fix.
e.g. use of in_atomic in drivers

There are also two warnings left about too long lines, which
reduce readability if changed.

Signed-off-by: Philipp Guendisch <philipp.guendisch@fau.de>
Signed-off-by: Chris Baller <chris.baller@gmx.de>
---
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   | 134 +++++++++++----------
 1 file changed, 68 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
index 5729539..41d3534 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
@@ -45,14 +45,16 @@ struct hmm_pool	reserved_pool;
 static ia_css_ptr dummy_ptr;
 struct _hmm_mem_stat hmm_mem_stat;
 
-/* p: private
-   s: shared
-   u: user
-   i: ion */
+/*
+ * p: private
+ * s: shared
+ * u: user
+ * i: ion
+ */
 static const char hmm_bo_type_string[] = "psui";
 
 static ssize_t bo_show(struct device *dev, struct device_attribute *attr,
-			char *buf, struct list_head *bo_list, bool active)
+		       char *buf, struct list_head *bo_list, bool active)
 {
 	ssize_t ret = 0;
 	struct hmm_buffer_object *bo;
@@ -72,10 +74,10 @@ static ssize_t bo_show(struct device *dev, struct device_attribute *attr,
 	spin_lock_irqsave(&bo_device.list_lock, flags);
 	list_for_each_entry(bo, bo_list, list) {
 		if ((active && (bo->status & HMM_BO_ALLOCED)) ||
-			(!active && !(bo->status & HMM_BO_ALLOCED))) {
+		    (!active && !(bo->status & HMM_BO_ALLOCED))) {
 			ret = scnprintf(buf + index1, PAGE_SIZE - index1,
-				"%c %d\n",
-				hmm_bo_type_string[bo->type], bo->pgnr);
+					"%c %d\n",
+					hmm_bo_type_string[bo->type], bo->pgnr);
 
 			total[bo->type] += bo->pgnr;
 			count[bo->type]++;
@@ -88,9 +90,10 @@ static ssize_t bo_show(struct device *dev, struct device_attribute *attr,
 	for (i = 0; i < HMM_BO_LAST; i++) {
 		if (count[i]) {
 			ret = scnprintf(buf + index1 + index2,
-				PAGE_SIZE - index1 - index2,
-				"%ld %c buffer objects: %ld KB\n",
-				count[i], hmm_bo_type_string[i], total[i] * 4);
+					PAGE_SIZE - index1 - index2,
+					"%ld %c buffer objects: %ld KB\n",
+					count[i], hmm_bo_type_string[i],
+					total[i] * 4);
 			if (ret > 0)
 				index2 += ret;
 		}
@@ -101,22 +104,22 @@ static ssize_t bo_show(struct device *dev, struct device_attribute *attr,
 }
 
 static ssize_t active_bo_show(struct device *dev,
-		struct device_attribute *attr,
-		char *buf)
+			      struct device_attribute *attr,
+			      char *buf)
 {
 	return bo_show(dev, attr, buf, &bo_device.entire_bo_list, true);
 }
 
 static ssize_t free_bo_show(struct device *dev,
-		struct device_attribute *attr,
-		char *buf)
+			    struct device_attribute *attr,
+			    char *buf)
 {
 	return bo_show(dev, attr, buf, &bo_device.entire_bo_list, false);
 }
 
 static ssize_t reserved_pool_show(struct device *dev,
-		struct device_attribute *attr,
-		char *buf)
+				  struct device_attribute *attr,
+				  char *buf)
 {
 	ssize_t ret = 0;
 
@@ -128,7 +131,7 @@ static ssize_t reserved_pool_show(struct device *dev,
 
 	spin_lock_irqsave(&pinfo->list_lock, flags);
 	ret = scnprintf(buf, PAGE_SIZE, "%d out of %d pages available\n",
-					pinfo->index, pinfo->pgnr);
+			pinfo->index, pinfo->pgnr);
 	spin_unlock_irqrestore(&pinfo->list_lock, flags);
 
 	if (ret > 0)
@@ -138,8 +141,8 @@ static ssize_t reserved_pool_show(struct device *dev,
 };
 
 static ssize_t dynamic_pool_show(struct device *dev,
-		struct device_attribute *attr,
-		char *buf)
+				 struct device_attribute *attr,
+				 char *buf)
 {
 	ssize_t ret = 0;
 
@@ -151,7 +154,7 @@ static ssize_t dynamic_pool_show(struct device *dev,
 
 	spin_lock_irqsave(&pinfo->list_lock, flags);
 	ret = scnprintf(buf, PAGE_SIZE, "%d (max %d) pages available\n",
-					pinfo->pgnr, pinfo->pool_size);
+			pinfo->pgnr, pinfo->pool_size);
 	spin_unlock_irqrestore(&pinfo->list_lock, flags);
 
 	if (ret > 0)
@@ -197,7 +200,7 @@ int hmm_init(void)
 
 	if (!ret) {
 		ret = sysfs_create_group(&atomisp_dev->kobj,
-				atomisp_attribute_group);
+					 atomisp_attribute_group);
 		if (ret)
 			dev_err(atomisp_dev,
 				"%s Failed to create sysfs\n", __func__);
@@ -210,9 +213,7 @@ void hmm_cleanup(void)
 {
 	sysfs_remove_group(&atomisp_dev->kobj, atomisp_attribute_group);
 
-	/*
-	 * free dummy memory first
-	 */
+	/* free dummy memory first */
 	hmm_free(dummy_ptr);
 	dummy_ptr = 0;
 
@@ -220,36 +221,37 @@ void hmm_cleanup(void)
 }
 
 ia_css_ptr hmm_alloc(size_t bytes, enum hmm_bo_type type,
-		int from_highmem, void *userptr, bool cached)
+		     int from_highmem, void *userptr, bool cached)
 {
 	unsigned int pgnr;
 	struct hmm_buffer_object *bo;
 	int ret;
 
-	/* Check if we are initialized. In the ideal world we wouldn't need
-	   this but we can tackle it once the driver is a lot cleaner */
+	/*
+	 * Check if we are initialized. In the ideal world we wouldn't need
+	 * this but we can tackle it once the driver is a lot cleaner
+	 */
 
 	if (!dummy_ptr)
 		hmm_init();
-	/*Get page number from size*/
+	/* Get page number from size */
 	pgnr = size_to_pgnr_ceil(bytes);
 
-	/*Buffer object structure init*/
+	/* Buffer object structure init */
 	bo = hmm_bo_alloc(&bo_device, pgnr);
 	if (!bo) {
 		dev_err(atomisp_dev, "hmm_bo_create failed.\n");
 		goto create_bo_err;
 	}
 
-	/*Allocate pages for memory*/
+	/* Allocate pages for memory */
 	ret = hmm_bo_alloc_pages(bo, type, from_highmem, userptr, cached);
 	if (ret) {
-		dev_err(atomisp_dev,
-			    "hmm_bo_alloc_pages failed.\n");
+		dev_err(atomisp_dev, "hmm_bo_alloc_pages failed.\n");
 		goto alloc_page_err;
 	}
 
-	/*Combind the virtual address and pages togather*/
+	/* Combind the virtual address and pages togather */
 	ret = hmm_bo_bind(bo);
 	if (ret) {
 		dev_err(atomisp_dev, "hmm_bo_bind failed.\n");
@@ -278,8 +280,8 @@ void hmm_free(ia_css_ptr virt)
 
 	if (!bo) {
 		dev_err(atomisp_dev,
-			    "can not find buffer object start with "
-			    "address 0x%x\n", (unsigned int)virt);
+			"can not find buffer object start with address 0x%x\n",
+			(unsigned int)virt);
 		return;
 	}
 
@@ -294,29 +296,29 @@ static inline int hmm_check_bo(struct hmm_buffer_object *bo, unsigned int ptr)
 {
 	if (!bo) {
 		dev_err(atomisp_dev,
-			    "can not find buffer object contains "
-			    "address 0x%x\n", ptr);
+			"can not find buffer object contains address 0x%x\n",
+			ptr);
 		return -EINVAL;
 	}
 
 	if (!hmm_bo_page_allocated(bo)) {
 		dev_err(atomisp_dev,
-			    "buffer object has no page allocated.\n");
+			"buffer object has no page allocated.\n");
 		return -EINVAL;
 	}
 
 	if (!hmm_bo_allocated(bo)) {
 		dev_err(atomisp_dev,
-			    "buffer object has no virtual address"
-			    " space allocated.\n");
+			"buffer object has no virtual address space allocated.\n");
 		return -EINVAL;
 	}
 
 	return 0;
 }
 
-/*Read function in ISP memory management*/
-static int load_and_flush_by_kmap(ia_css_ptr virt, void *data, unsigned int bytes)
+/* Read function in ISP memory management */
+static int load_and_flush_by_kmap(ia_css_ptr virt, void *data,
+				  unsigned int bytes)
 {
 	struct hmm_buffer_object *bo;
 	unsigned int idx, offset, len;
@@ -358,7 +360,7 @@ static int load_and_flush_by_kmap(ia_css_ptr virt, void *data, unsigned int byte
 	return 0;
 }
 
-/*Read function in ISP memory management*/
+/* Read function in ISP memory management */
 static int load_and_flush(ia_css_ptr virt, void *data, unsigned int bytes)
 {
 	struct hmm_buffer_object *bo;
@@ -393,24 +395,24 @@ static int load_and_flush(ia_css_ptr virt, void *data, unsigned int bytes)
 	return 0;
 }
 
-/*Read function in ISP memory management*/
+/* Read function in ISP memory management */
 int hmm_load(ia_css_ptr virt, void *data, unsigned int bytes)
 {
 	if (!data) {
 		dev_err(atomisp_dev,
-			 "hmm_load NULL argument\n");
+			"hmm_load NULL argument\n");
 		return -EINVAL;
 	}
 	return load_and_flush(virt, data, bytes);
 }
 
-/*Flush hmm data from the data cache*/
+/* Flush hmm data from the data cache */
 int hmm_flush(ia_css_ptr virt, unsigned int bytes)
 {
 	return load_and_flush(virt, NULL, bytes);
 }
 
-/*Write function in ISP memory management*/
+/* Write function in ISP memory management */
 int hmm_store(ia_css_ptr virt, const void *data, unsigned int bytes)
 {
 	struct hmm_buffer_object *bo;
@@ -456,8 +458,8 @@ int hmm_store(ia_css_ptr virt, const void *data, unsigned int bytes)
 
 		if (!des) {
 			dev_err(atomisp_dev,
-				    "kmap buffer object page failed: "
-				    "pg_idx = %d\n", idx);
+				"kmap buffer object page failed: pg_idx = %d\n",
+				idx);
 			return -EINVAL;
 		}
 
@@ -492,7 +494,7 @@ int hmm_store(ia_css_ptr virt, const void *data, unsigned int bytes)
 	return 0;
 }
 
-/*memset function in ISP memory management*/
+/* memset function in ISP memory management */
 int hmm_set(ia_css_ptr virt, int c, unsigned int bytes)
 {
 	struct hmm_buffer_object *bo;
@@ -552,7 +554,7 @@ int hmm_set(ia_css_ptr virt, int c, unsigned int bytes)
 	return 0;
 }
 
-/*Virtual address to physical address convert*/
+/* Virtual address to physical address convert */
 phys_addr_t hmm_virt_to_phys(ia_css_ptr virt)
 {
 	unsigned int idx, offset;
@@ -587,7 +589,7 @@ int hmm_mmap(struct vm_area_struct *vma, ia_css_ptr virt)
 	return hmm_bo_mmap(vma, bo);
 }
 
-/*Map ISP virtual address into IA virtual address*/
+/* Map ISP virtual address into IA virtual address */
 void *hmm_vmap(ia_css_ptr virt, bool cached)
 {
 	struct hmm_buffer_object *bo;
@@ -596,8 +598,8 @@ void *hmm_vmap(ia_css_ptr virt, bool cached)
 	bo = hmm_bo_device_search_in_range(&bo_device, virt);
 	if (!bo) {
 		dev_err(atomisp_dev,
-			    "can not find buffer object contains address 0x%x\n",
-			    virt);
+			"can not find buffer object contains address 0x%x\n",
+			virt);
 		return NULL;
 	}
 
@@ -616,8 +618,8 @@ void hmm_flush_vmap(ia_css_ptr virt)
 	bo = hmm_bo_device_search_in_range(&bo_device, virt);
 	if (!bo) {
 		dev_warn(atomisp_dev,
-			    "can not find buffer object contains address 0x%x\n",
-			    virt);
+			 "can not find buffer object contains address 0x%x\n",
+			 virt);
 		return;
 	}
 
@@ -631,16 +633,15 @@ void hmm_vunmap(ia_css_ptr virt)
 	bo = hmm_bo_device_search_in_range(&bo_device, virt);
 	if (!bo) {
 		dev_warn(atomisp_dev,
-			"can not find buffer object contains address 0x%x\n",
-			virt);
+			 "can not find buffer object contains address 0x%x\n",
+			 virt);
 		return;
 	}
 
 	return hmm_bo_vunmap(bo);
 }
 
-int hmm_pool_register(unsigned int pool_size,
-			enum hmm_pool_type pool_type)
+int hmm_pool_register(unsigned int pool_size, enum hmm_pool_type pool_type)
 {
 	switch (pool_type) {
 	case HMM_POOL_TYPE_RESERVED:
@@ -699,17 +700,18 @@ ia_css_ptr hmm_host_vaddr_to_hrt_vaddr(const void *ptr)
 void hmm_show_mem_stat(const char *func, const int line)
 {
 	trace_printk("tol_cnt=%d usr_size=%d res_size=%d res_cnt=%d sys_size=%d  dyc_thr=%d dyc_size=%d.\n",
-			hmm_mem_stat.tol_cnt,
-			hmm_mem_stat.usr_size, hmm_mem_stat.res_size,
-			hmm_mem_stat.res_cnt, hmm_mem_stat.sys_size,
-			hmm_mem_stat.dyc_thr, hmm_mem_stat.dyc_size);
+		     hmm_mem_stat.tol_cnt,  hmm_mem_stat.usr_size,
+		     hmm_mem_stat.res_size, hmm_mem_stat.res_cnt,
+		     hmm_mem_stat.sys_size, hmm_mem_stat.dyc_thr,
+		     hmm_mem_stat.dyc_size);
 }
 
 void hmm_init_mem_stat(int res_pgnr, int dyc_en, int dyc_pgnr)
 {
 	hmm_mem_stat.res_size = res_pgnr;
+
 	/* If reserved mem pool is not enabled, set its "mem stat" values as -1. */
-	if (0 == hmm_mem_stat.res_size) {
+	if (hmm_mem_stat.res_size == 0) {
 		hmm_mem_stat.res_size = -1;
 		hmm_mem_stat.res_cnt = -1;
 	}
-- 
2.7.4
