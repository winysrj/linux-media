Return-path: <linux-media-owner@vger.kernel.org>
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:37493 "EHLO
        faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754447AbdGJS5F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 14:57:05 -0400
From: Philipp Guendisch <philipp.guendisch@fau.de>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        jeremy.lefaure@lse.epita.fr, fabf@skynet.be, rvarsha016@gmail.com,
        philipp.guendisch@fau.de, chris.baller@gmx.de, robsonde@gmail.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de
Subject: [PATCH 2/2] staging: atomisp2: hmm: Alignment code
Date: Mon, 10 Jul 2017 20:56:21 +0200
Message-Id: <1499712981-18363-2-git-send-email-philipp.guendisch@fau.de>
In-Reply-To: <1499712981-18363-1-git-send-email-philipp.guendisch@fau.de>
References: <1499712981-18363-1-git-send-email-philipp.guendisch@fau.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixed code alignment to open paranthesis.
Semantic should not be affected by this patch.

Signed-off-by: Philipp Guendisch <philipp.guendisch@fau.de>
Signed-off-by: Chris Baller <chris.baller@gmx.de>
---
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   | 79 +++++++++++-----------
 1 file changed, 39 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
index 12affa6..7025da3 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
@@ -54,7 +54,7 @@ struct _hmm_mem_stat hmm_mem_stat;
 static const char hmm_bo_type_string[] = "psui";
 
 static ssize_t bo_show(struct device *dev, struct device_attribute *attr,
-			char *buf, struct list_head *bo_list, bool active)
+		       char *buf, struct list_head *bo_list, bool active)
 {
 	ssize_t ret = 0;
 	struct hmm_buffer_object *bo;
@@ -74,10 +74,10 @@ static ssize_t bo_show(struct device *dev, struct device_attribute *attr,
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
@@ -90,9 +90,10 @@ static ssize_t bo_show(struct device *dev, struct device_attribute *attr,
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
@@ -103,22 +104,22 @@ static ssize_t bo_show(struct device *dev, struct device_attribute *attr,
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
 
@@ -130,7 +131,7 @@ static ssize_t reserved_pool_show(struct device *dev,
 
 	spin_lock_irqsave(&pinfo->list_lock, flags);
 	ret = scnprintf(buf, PAGE_SIZE, "%d out of %d pages available\n",
-					pinfo->index, pinfo->pgnr);
+			pinfo->index, pinfo->pgnr);
 	spin_unlock_irqrestore(&pinfo->list_lock, flags);
 
 	if (ret > 0)
@@ -140,8 +141,8 @@ static ssize_t reserved_pool_show(struct device *dev,
 };
 
 static ssize_t dynamic_pool_show(struct device *dev,
-		struct device_attribute *attr,
-		char *buf)
+				 struct device_attribute *attr,
+				 char *buf)
 {
 	ssize_t ret = 0;
 
@@ -153,7 +154,7 @@ static ssize_t dynamic_pool_show(struct device *dev,
 
 	spin_lock_irqsave(&pinfo->list_lock, flags);
 	ret = scnprintf(buf, PAGE_SIZE, "%d (max %d) pages available\n",
-					pinfo->pgnr, pinfo->pool_size);
+			pinfo->pgnr, pinfo->pool_size);
 	spin_unlock_irqrestore(&pinfo->list_lock, flags);
 
 	if (ret > 0)
@@ -199,7 +200,7 @@ int hmm_init(void)
 
 	if (!ret) {
 		ret = sysfs_create_group(&atomisp_dev->kobj,
-				atomisp_attribute_group);
+					 atomisp_attribute_group);
 		if (ret)
 			dev_err(atomisp_dev,
 				"%s Failed to create sysfs\n", __func__);
@@ -220,7 +221,7 @@ void hmm_cleanup(void)
 }
 
 ia_css_ptr hmm_alloc(size_t bytes, enum hmm_bo_type type,
-		int from_highmem, void *userptr, bool cached)
+		     int from_highmem, void *userptr, bool cached)
 {
 	unsigned int pgnr;
 	struct hmm_buffer_object *bo;
@@ -246,8 +247,7 @@ ia_css_ptr hmm_alloc(size_t bytes, enum hmm_bo_type type,
 	/* Allocate pages for memory */
 	ret = hmm_bo_alloc_pages(bo, type, from_highmem, userptr, cached);
 	if (ret) {
-		dev_err(atomisp_dev,
-			    "hmm_bo_alloc_pages failed.\n");
+		dev_err(atomisp_dev, "hmm_bo_alloc_pages failed.\n");
 		goto alloc_page_err;
 	}
 
@@ -280,8 +280,8 @@ void hmm_free(ia_css_ptr virt)
 
 	if (!bo) {
 		dev_err(atomisp_dev,
-			    "can not find buffer object start with "
-			    "address 0x%x\n", (unsigned int)virt);
+			"can not find buffer object start with address 0x%x\n",
+			(unsigned int)virt);
 		return;
 	}
 
@@ -296,21 +296,20 @@ static inline int hmm_check_bo(struct hmm_buffer_object *bo, unsigned int ptr)
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
 
@@ -318,7 +317,8 @@ static inline int hmm_check_bo(struct hmm_buffer_object *bo, unsigned int ptr)
 }
 
 /* Read function in ISP memory management */
-static int load_and_flush_by_kmap(ia_css_ptr virt, void *data, unsigned int bytes)
+static int load_and_flush_by_kmap(ia_css_ptr virt, void *data,
+				  unsigned int bytes)
 {
 	struct hmm_buffer_object *bo;
 	unsigned int idx, offset, len;
@@ -400,7 +400,7 @@ int hmm_load(ia_css_ptr virt, void *data, unsigned int bytes)
 {
 	if (!data) {
 		dev_err(atomisp_dev,
-			 "hmm_load NULL argument\n");
+			"hmm_load NULL argument\n");
 		return -EINVAL;
 	}
 	return load_and_flush(virt, data, bytes);
@@ -458,8 +458,8 @@ int hmm_store(ia_css_ptr virt, const void *data, unsigned int bytes)
 
 		if (!des) {
 			dev_err(atomisp_dev,
-				    "kmap buffer object page failed: "
-				    "pg_idx = %d\n", idx);
+				"kmap buffer object page failed: pg_idx = %d\n",
+				idx);
 			return -EINVAL;
 		}
 
@@ -598,8 +598,8 @@ void *hmm_vmap(ia_css_ptr virt, bool cached)
 	bo = hmm_bo_device_search_in_range(&bo_device, virt);
 	if (!bo) {
 		dev_err(atomisp_dev,
-			    "can not find buffer object contains address 0x%x\n",
-			    virt);
+			"can not find buffer object contains address 0x%x\n",
+			virt);
 		return NULL;
 	}
 
@@ -618,8 +618,8 @@ void hmm_flush_vmap(ia_css_ptr virt)
 	bo = hmm_bo_device_search_in_range(&bo_device, virt);
 	if (!bo) {
 		dev_warn(atomisp_dev,
-			    "can not find buffer object contains address 0x%x\n",
-			    virt);
+			 "can not find buffer object contains address 0x%x\n",
+			 virt);
 		return;
 	}
 
@@ -633,16 +633,15 @@ void hmm_vunmap(ia_css_ptr virt)
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
-- 
2.7.4
