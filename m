Return-path: <linux-media-owner@vger.kernel.org>
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:42199 "EHLO
        faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750807AbdGMG4d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 02:56:33 -0400
From: Philipp Guendisch <philipp.guendisch@fau.de>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        jeremy.lefaure@lse.epita.fr, fabf@skynet.be, rvarsha016@gmail.com,
        philipp.guendisch@fau.de, chris.baller@gmx.de, robsonde@gmail.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de
Subject: [PATCH v2 2/2] staging: atomisp2: hmm: Alignment code (rebased)
Date: Thu, 13 Jul 2017 08:55:43 +0200
Message-Id: <1499928943-9133-2-git-send-email-philipp.guendisch@fau.de>
In-Reply-To: <1499928943-9133-1-git-send-email-philipp.guendisch@fau.de>
References: <20170711152758.3azqdhfyeiyagtv7@valkosipuli.retiisi.org.uk>
 <1499928943-9133-1-git-send-email-philipp.guendisch@fau.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixed code alignment to open paranthesis.
Semantic should not be affected by this patch.

It has been rebased on top of media_tree atomisp branch

Signed-off-by: Philipp Guendisch <philipp.guendisch@fau.de>
Signed-off-by: Chris Baller <chris.baller@gmx.de>
---
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   | 93 +++++++++++-----------
 1 file changed, 45 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
index b345025..b8aae4b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
@@ -55,7 +55,7 @@ struct _hmm_mem_stat hmm_mem_stat;
 static const char hmm_bo_type_string[] = "psui";
 
 static ssize_t bo_show(struct device *dev, struct device_attribute *attr,
-			char *buf, struct list_head *bo_list, bool active)
+		       char *buf, struct list_head *bo_list, bool active)
 {
 	ssize_t ret = 0;
 	struct hmm_buffer_object *bo;
@@ -75,10 +75,10 @@ static ssize_t bo_show(struct device *dev, struct device_attribute *attr,
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
@@ -91,9 +91,10 @@ static ssize_t bo_show(struct device *dev, struct device_attribute *attr,
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
@@ -103,23 +104,21 @@ static ssize_t bo_show(struct device *dev, struct device_attribute *attr,
 	return index1 + index2 + 1;
 }
 
-static ssize_t active_bo_show(struct device *dev,
-		struct device_attribute *attr,
-		char *buf)
+static ssize_t active_bo_show(struct device *dev, struct device_attribute *attr,
+			      char *buf)
 {
 	return bo_show(dev, attr, buf, &bo_device.entire_bo_list, true);
 }
 
-static ssize_t free_bo_show(struct device *dev,
-		struct device_attribute *attr,
-		char *buf)
+static ssize_t free_bo_show(struct device *dev, struct device_attribute *attr,
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
 
@@ -131,7 +130,7 @@ static ssize_t reserved_pool_show(struct device *dev,
 
 	spin_lock_irqsave(&pinfo->list_lock, flags);
 	ret = scnprintf(buf, PAGE_SIZE, "%d out of %d pages available\n",
-					pinfo->index, pinfo->pgnr);
+			pinfo->index, pinfo->pgnr);
 	spin_unlock_irqrestore(&pinfo->list_lock, flags);
 
 	if (ret > 0)
@@ -141,8 +140,8 @@ static ssize_t reserved_pool_show(struct device *dev,
 };
 
 static ssize_t dynamic_pool_show(struct device *dev,
-		struct device_attribute *attr,
-		char *buf)
+				 struct device_attribute *attr,
+				 char *buf)
 {
 	ssize_t ret = 0;
 
@@ -154,7 +153,7 @@ static ssize_t dynamic_pool_show(struct device *dev,
 
 	spin_lock_irqsave(&pinfo->list_lock, flags);
 	ret = scnprintf(buf, PAGE_SIZE, "%d (max %d) pages available\n",
-					pinfo->pgnr, pinfo->pool_size);
+			pinfo->pgnr, pinfo->pool_size);
 	spin_unlock_irqrestore(&pinfo->list_lock, flags);
 
 	if (ret > 0)
@@ -202,7 +201,7 @@ int hmm_init(void)
 
 	if (!ret) {
 		ret = sysfs_create_group(&atomisp_dev->kobj,
-				atomisp_attribute_group);
+					 atomisp_attribute_group);
 		if (ret)
 			dev_err(atomisp_dev,
 				"%s Failed to create sysfs\n", __func__);
@@ -224,7 +223,7 @@ void hmm_cleanup(void)
 }
 
 ia_css_ptr hmm_alloc(size_t bytes, enum hmm_bo_type type,
-		int from_highmem, void *userptr, bool cached)
+		     int from_highmem, void *userptr, bool cached)
 {
 	unsigned int pgnr;
 	struct hmm_buffer_object *bo;
@@ -250,8 +249,7 @@ ia_css_ptr hmm_alloc(size_t bytes, enum hmm_bo_type type,
 	/* Allocate pages for memory */
 	ret = hmm_bo_alloc_pages(bo, type, from_highmem, userptr, cached);
 	if (ret) {
-		dev_err(atomisp_dev,
-			    "hmm_bo_alloc_pages failed.\n");
+		dev_err(atomisp_dev, "hmm_bo_alloc_pages failed.\n");
 		goto alloc_page_err;
 	}
 
@@ -284,8 +282,8 @@ void hmm_free(ia_css_ptr virt)
 
 	if (!bo) {
 		dev_err(atomisp_dev,
-			    "can not find buffer object start with "
-			    "address 0x%x\n", (unsigned int)virt);
+			"can not find buffer object start with address 0x%x\n",
+			(unsigned int)virt);
 		return;
 	}
 
@@ -300,21 +298,20 @@ static inline int hmm_check_bo(struct hmm_buffer_object *bo, unsigned int ptr)
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
 
@@ -322,7 +319,8 @@ static inline int hmm_check_bo(struct hmm_buffer_object *bo, unsigned int ptr)
 }
 
 /* Read function in ISP memory management */
-static int load_and_flush_by_kmap(ia_css_ptr virt, void *data, unsigned int bytes)
+static int load_and_flush_by_kmap(ia_css_ptr virt, void *data,
+				  unsigned int bytes)
 {
 	struct hmm_buffer_object *bo;
 	unsigned int idx, offset, len;
@@ -404,7 +402,7 @@ int hmm_load(ia_css_ptr virt, void *data, unsigned int bytes)
 {
 	if (!data) {
 		dev_err(atomisp_dev,
-			 "hmm_load NULL argument\n");
+			"hmm_load NULL argument\n");
 		return -EINVAL;
 	}
 	return load_and_flush(virt, data, bytes);
@@ -462,8 +460,8 @@ int hmm_store(ia_css_ptr virt, const void *data, unsigned int bytes)
 
 		if (!des) {
 			dev_err(atomisp_dev,
-				    "kmap buffer object page failed: "
-				    "pg_idx = %d\n", idx);
+				"kmap buffer object page failed: pg_idx = %d\n",
+				idx);
 			return -EINVAL;
 		}
 
@@ -602,8 +600,8 @@ void *hmm_vmap(ia_css_ptr virt, bool cached)
 	bo = hmm_bo_device_search_in_range(&bo_device, virt);
 	if (!bo) {
 		dev_err(atomisp_dev,
-			    "can not find buffer object contains address 0x%x\n",
-			    virt);
+			"can not find buffer object contains address 0x%x\n",
+			virt);
 		return NULL;
 	}
 
@@ -622,8 +620,8 @@ void hmm_flush_vmap(ia_css_ptr virt)
 	bo = hmm_bo_device_search_in_range(&bo_device, virt);
 	if (!bo) {
 		dev_warn(atomisp_dev,
-			    "can not find buffer object contains address 0x%x\n",
-			    virt);
+			 "can not find buffer object contains address 0x%x\n",
+			 virt);
 		return;
 	}
 
@@ -637,26 +635,25 @@ void hmm_vunmap(ia_css_ptr virt)
 	bo = hmm_bo_device_search_in_range(&bo_device, virt);
 	if (!bo) {
 		dev_warn(atomisp_dev,
-			"can not find buffer object contains address 0x%x\n",
-			virt);
+			 "can not find buffer object contains address 0x%x\n",
+			 virt);
 		return;
 	}
 
 	hmm_bo_vunmap(bo);
 }
 
-int hmm_pool_register(unsigned int pool_size,
-			enum hmm_pool_type pool_type)
+int hmm_pool_register(unsigned int pool_size, enum hmm_pool_type pool_type)
 {
 	switch (pool_type) {
 	case HMM_POOL_TYPE_RESERVED:
 		reserved_pool.pops = &reserved_pops;
 		return reserved_pool.pops->pool_init(&reserved_pool.pool_info,
-							pool_size);
+						     pool_size);
 	case HMM_POOL_TYPE_DYNAMIC:
 		dynamic_pool.pops = &dynamic_pops;
 		return dynamic_pool.pops->pool_init(&dynamic_pool.pool_info,
-							pool_size);
+						    pool_size);
 	default:
 		dev_err(atomisp_dev, "invalid pool type.\n");
 		return -EINVAL;
@@ -705,10 +702,10 @@ ia_css_ptr hmm_host_vaddr_to_hrt_vaddr(const void *ptr)
 void hmm_show_mem_stat(const char *func, const int line)
 {
 	trace_printk("tol_cnt=%d usr_size=%d res_size=%d res_cnt=%d sys_size=%d  dyc_thr=%d dyc_size=%d.\n",
-			hmm_mem_stat.tol_cnt,
-			hmm_mem_stat.usr_size, hmm_mem_stat.res_size,
-			hmm_mem_stat.res_cnt, hmm_mem_stat.sys_size,
-			hmm_mem_stat.dyc_thr, hmm_mem_stat.dyc_size);
+		     hmm_mem_stat.tol_cnt,
+		     hmm_mem_stat.usr_size, hmm_mem_stat.res_size,
+		     hmm_mem_stat.res_cnt, hmm_mem_stat.sys_size,
+		     hmm_mem_stat.dyc_thr, hmm_mem_stat.dyc_size);
 }
 
 void hmm_init_mem_stat(int res_pgnr, int dyc_en, int dyc_pgnr)
-- 
2.7.4
