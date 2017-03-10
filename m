Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:9803 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933595AbdCJLdu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 06:33:50 -0500
Subject: [PATCH 1/8] atomisp: remove dead code for SSSE3
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Fri, 10 Mar 2017 11:33:33 +0000
Message-ID: <148914560647.25309.2276061224604665212.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is another define which is never used and references a header that doesn't
exist, so consider it dead. Our memcpy is pretty smart anyway.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   |   32 +-------------------
 1 file changed, 1 insertion(+), 31 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
index 358d340..b041e56 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
@@ -39,10 +39,6 @@
 #include "mmu/isp_mmu.h"
 #include "mmu/sh_mmu_mrfld.h"
 
-#ifdef USE_SSSE3
-#include <asm/ssse3.h>
-#endif
-
 struct hmm_bo_device bo_device;
 struct hmm_pool	dynamic_pool;
 struct hmm_pool	reserved_pool;
@@ -53,9 +49,7 @@ const char *hmm_bo_type_strings[HMM_BO_LAST] = {
 	"p", /* private */
 	"s", /* shared */
 	"u", /* user */
-#ifdef CONFIG_ION
 	"i", /* ion */
-#endif
 };
 
 static ssize_t bo_show(struct device *dev, struct device_attribute *attr,
@@ -356,12 +350,7 @@ static int load_and_flush_by_kmap(ia_css_ptr virt, void *data, unsigned int byte
 		virt += len;	/* update virt for next loop */
 
 		if (des) {
-
-#ifdef USE_SSSE3
-			_ssse3_memcpy(des, src, len);
-#else
 			memcpy(des, src, len);
-#endif
 			des += len;
 		}
 
@@ -388,11 +377,7 @@ static int load_and_flush(ia_css_ptr virt, void *data, unsigned int bytes)
 		void *src = bo->vmap_addr;
 
 		src += (virt - bo->start);
-#ifdef USE_SSSE3
-		_ssse3_memcpy(data, src, bytes);
-#else
 		memcpy(data, src, bytes);
-#endif
 		if (bo->status & HMM_BO_VMAPED_CACHED)
 			clflush_cache_range(src, bytes);
 	} else {
@@ -404,11 +389,7 @@ static int load_and_flush(ia_css_ptr virt, void *data, unsigned int bytes)
 		else
 			vptr = vptr + (virt - bo->start);
 
-#ifdef USE_SSSE3
-		_ssse3_memcpy(data, vptr, bytes);
-#else
 		memcpy(data, vptr, bytes);
-#endif
 		clflush_cache_range(vptr, bytes);
 		hmm_bo_vunmap(bo);
 	}
@@ -450,11 +431,7 @@ int hmm_store(ia_css_ptr virt, const void *data, unsigned int bytes)
 		void *dst = bo->vmap_addr;
 
 		dst += (virt - bo->start);
-#ifdef USE_SSSE3
-		_ssse3_memcpy(dst, data, bytes);
-#else
 		memcpy(dst, data, bytes);
-#endif
 		if (bo->status & HMM_BO_VMAPED_CACHED)
 			clflush_cache_range(dst, bytes);
 	} else {
@@ -464,11 +441,7 @@ int hmm_store(ia_css_ptr virt, const void *data, unsigned int bytes)
 		if (vptr) {
 			vptr = vptr + (virt - bo->start);
 
-#ifdef USE_SSSE3
-			_ssse3_memcpy(vptr, data, bytes);
-#else
 			memcpy(vptr, data, bytes);
-#endif
 			clflush_cache_range(vptr, bytes);
 			hmm_bo_vunmap(bo);
 			return 0;
@@ -504,11 +477,8 @@ int hmm_store(ia_css_ptr virt, const void *data, unsigned int bytes)
 
 		virt += len;
 
-#ifdef USE_SSSE3
-		_ssse3_memcpy(des, src, len);
-#else
 		memcpy(des, src, len);
-#endif
+
 		src += len;
 
 		clflush_cache_range(des, len);
