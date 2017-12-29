Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57472 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750801AbdL2M7Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 07:59:16 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, yong.zhi@intel.com
Subject: [PATCH 2/2] intel-ipu3: Rename arr_size macro, use min
Date: Fri, 29 Dec 2017 14:59:14 +0200
Message-Id: <20171229125914.7218-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20171229125914.7218-1-sakari.ailus@linux.intel.com>
References: <20171229125914.7218-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The arr_size() macro which is used to calculate the size of the chunk in the
array to be arranged resembles ARRAY_SIZE naming-wise. Avoid confusion by
renaming it to CHUNK_SIZE instead.

Also use min() macro to calculate the minimum of two numbers.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 941caa987dab..52827d572493 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1894,20 +1894,17 @@ static void arrange(void *ptr, size_t elem_size, size_t elems, size_t start)
 		{ start, elems - 1 },
 	};
 
-#define arr_size(a) ((a)->end - (a)->begin + 1)
+#define CHUNK_SIZE(a) ((a)->end - (a)->begin + 1)
 
 	/* Loop as long as we have out-of-place entries */
-	while (arr_size(&arr[0]) && arr_size(&arr[1])) {
+	while (CHUNK_SIZE(&arr[0]) && CHUNK_SIZE(&arr[1])) {
 		size_t size0, i;
 
 		/*
 		 * Find the number of entries that can be arranged on this
 		 * iteration.
 		 */
-		if (arr_size(&arr[0]) > arr_size(&arr[1]))
-			size0 = arr_size(&arr[1]);
-		else
-			size0 = arr_size(&arr[0]);
+		size0 = min(CHUNK_SIZE(&arr[0]), CHUNK_SIZE(&arr[1]));
 
 		/* Swap the entries in two parts of the array. */
 		for (i = 0; i < size0; i++) {
@@ -1919,7 +1916,7 @@ static void arrange(void *ptr, size_t elem_size, size_t elems, size_t start)
 				swap(d[j], s[j]);
 		}
 
-		if (arr_size(&arr[0]) > arr_size(&arr[1])) {
+		if (CHUNK_SIZE(&arr[0]) > CHUNK_SIZE(&arr[1])) {
 			/* The end of the first array remains unarranged. */
 			arr[0].begin += size0;
 		} else {
-- 
2.11.0
