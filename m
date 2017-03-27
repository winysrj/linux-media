Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55482 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753470AbdC0PO3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 11:14:29 -0400
Subject: [PATCH 3/5] atomisp: kill another define
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 27 Mar 2017 16:14:07 +0100
Message-ID: <149062764305.15399.13881626965784506879.stgit@rszulisx-mobl.ger.corp.intel.com>
In-Reply-To: <149062762280.15399.12714375439154128065.stgit@rszulisx-mobl.ger.corp.intel.com>
References: <149062762280.15399.12714375439154128065.stgit@rszulisx-mobl.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We don't need an ifdef for the sake of 8-12 bytes. Avoid the ifdef added by
fde469701c7efabebf885e785edf367bfb1a8f3f. Instead turn it into a single const
string array at a fixed location thereby saving even more memory.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   |   21 ++++++++++----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
index a362b49..1f07c7a 100644
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
@@ -45,12 +45,11 @@ struct hmm_pool	reserved_pool;
 static ia_css_ptr dummy_ptr;
 struct _hmm_mem_stat hmm_mem_stat;
 
-const char *hmm_bo_type_strings[HMM_BO_LAST] = {
-	"p", /* private */
-	"s", /* shared */
-	"u", /* user */
-	"i", /* ion */
-};
+/* p: private
+   s: shared
+   u: user
+   i: ion */
+static const char hmm_bo_type_string[] = "psui";
 
 static ssize_t bo_show(struct device *dev, struct device_attribute *attr,
 			char *buf, struct list_head *bo_list, bool active)
@@ -75,8 +74,8 @@ static ssize_t bo_show(struct device *dev, struct device_attribute *attr,
 		if ((active && (bo->status & HMM_BO_ALLOCED)) ||
 			(!active && !(bo->status & HMM_BO_ALLOCED))) {
 			ret = scnprintf(buf + index1, PAGE_SIZE - index1,
-				"%s %d\n",
-				hmm_bo_type_strings[bo->type], bo->pgnr);
+				"%c %d\n",
+				hmm_bo_type_string[bo->type], bo->pgnr);
 
 			total[bo->type] += bo->pgnr;
 			count[bo->type]++;
@@ -90,8 +89,8 @@ static ssize_t bo_show(struct device *dev, struct device_attribute *attr,
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
