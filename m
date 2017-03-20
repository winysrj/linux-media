Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:9428 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755299AbdCTOyl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:54:41 -0400
Subject: [PATCH 06/24] atomisp: kill another define
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:39:38 +0000
Message-ID: <149002076867.17109.6183542354794542722.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
References: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We don't need an ifdef for the sake of 8-12 bytes. This undoes the ifdef added by
fde469701c7efabebf885e785edf367bfb1a8f3f. Instead turn it into a single const string
array at a fixed location thereby saving even more memory.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   |   23 +++++++++-----------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
index e78f02f..1f07c7a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
@@ -1,7 +1,7 @@
 /*
  * Support for Medifield PNW Camera Imaging ISP subsystem.
  *
- * Copyright (c) 2010 Intel Corporation. All Rights Reserved.
+ * Copyright (c) 2010-2017 Intel Corporation. All Rights Reserved.
  *
  * Copyright (c) 2010 Silicon Hive www.siliconhive.com.
  *
@@ -45,14 +45,11 @@ struct hmm_pool	reserved_pool;
 static ia_css_ptr dummy_ptr;
 struct _hmm_mem_stat hmm_mem_stat;
 
-const char *hmm_bo_type_strings[HMM_BO_LAST] = {
-	"p", /* private */
-	"s", /* shared */
-	"u", /* user */
-#ifdef CONFIG_ION
-	"i", /* ion */
-#endif
-};
+/* p: private
+   s: shared
+   u: user
+   i: ion */
+static const char hmm_bo_type_string[] = "psui";
 
 static ssize_t bo_show(struct device *dev, struct device_attribute *attr,
 			char *buf, struct list_head *bo_list, bool active)
@@ -77,8 +74,8 @@ static ssize_t bo_show(struct device *dev, struct device_attribute *attr,
 		if ((active && (bo->status & HMM_BO_ALLOCED)) ||
 			(!active && !(bo->status & HMM_BO_ALLOCED))) {
 			ret = scnprintf(buf + index1, PAGE_SIZE - index1,
-				"%s %d\n",
-				hmm_bo_type_strings[bo->type], bo->pgnr);
+				"%c %d\n",
+				hmm_bo_type_string[bo->type], bo->pgnr);
 
 			total[bo->type] += bo->pgnr;
 			count[bo->type]++;
@@ -92,8 +89,8 @@ static ssize_t bo_show(struct device *dev, struct device_attribute *attr,
 		if (count[i]) {
 			ret = scnprintf(buf + index1 + index2,
 				PAGE_SIZE - index1 - index2,
-				"%ld %s buffer objects: %ld KB\n",
-				count[i], hmm_bo_type_strings[i], total[i] * 4);
+				"%ld %c buffer objects: %ld KB\n",
+				count[i], hmm_bo_type_string[i], total[i] * 4);
 			if (ret > 0)
 				index2 += ret;
 		}
