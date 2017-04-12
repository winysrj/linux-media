Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:2697 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754951AbdDLSWD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 14:22:03 -0400
Subject: [PATCH 10/14] atomisp: remove contiguous handling
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Wed, 12 Apr 2017 19:21:59 +0100
Message-ID: <149202131191.16615.13699388826603926824.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
References: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The base hmm MMU code doesn't support contiguous allocations (they BUG), so
remove support from them from the higher levels of the heirarchy.

We still need to unwind all these layers but it turns out that some of the init
order stuff is rather sensitive and the simple cleanup breaks everything

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../pci/atomisp2/css2400/ia_css_memory_access.c    |   31 ++++++--------------
 .../atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c |   11 -------
 .../atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h |    3 --
 .../media/atomisp/pci/atomisp2/hrt/memory_access.c |   31 ++++----------------
 4 files changed, 15 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c
index 8d559aa..1f6ae20 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c
@@ -31,31 +31,18 @@ mmgr_malloc(const size_t size)
 hrt_vaddress mmgr_alloc_attr(const size_t size, const uint16_t attrs)
 {
 	uint16_t masked_attrs = attrs & MMGR_ATTRIBUTE_MASK;
+	WARN_ON(attrs & MMGR_ATTRIBUTE_CONTIGUOUS);
 
 	if (masked_attrs & MMGR_ATTRIBUTE_CLEARED) {
-		if (masked_attrs & MMGR_ATTRIBUTE_CACHED) {
-			if (masked_attrs & MMGR_ATTRIBUTE_CONTIGUOUS)
-				return (ia_css_ptr) hrt_isp_css_mm_calloc_contiguous(size);
-			else
-				return (ia_css_ptr) hrt_isp_css_mm_calloc_cached(size);
-		} else {
-			if (masked_attrs & MMGR_ATTRIBUTE_CONTIGUOUS)
-				return (ia_css_ptr) hrt_isp_css_mm_calloc_contiguous(size);
-			else
-				return (ia_css_ptr) hrt_isp_css_mm_calloc(size);
-		}
+		if (masked_attrs & MMGR_ATTRIBUTE_CACHED)
+			return (ia_css_ptr) hrt_isp_css_mm_calloc_cached(size);
+		else
+			return (ia_css_ptr) hrt_isp_css_mm_calloc(size);
 	} else {
-		if (masked_attrs & MMGR_ATTRIBUTE_CACHED) {
-			if (masked_attrs & MMGR_ATTRIBUTE_CONTIGUOUS)
-				return (ia_css_ptr) hrt_isp_css_mm_alloc_contiguous(size);
-			else
-				return (ia_css_ptr) hrt_isp_css_mm_alloc_cached(size);
-		} else {
-			if (masked_attrs & MMGR_ATTRIBUTE_CONTIGUOUS)
-				return (ia_css_ptr) hrt_isp_css_mm_alloc_contiguous(size);
-			else
-				return (ia_css_ptr) hrt_isp_css_mm_alloc(size);
-		}
+		if (masked_attrs & MMGR_ATTRIBUTE_CACHED)
+			return (ia_css_ptr) hrt_isp_css_mm_alloc_cached(size);
+		else
+			return (ia_css_ptr) hrt_isp_css_mm_alloc(size);
 	}
 }
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c
index 9f8267a..78b4709 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c
@@ -180,14 +180,3 @@ phys_addr_t hrt_isp_css_virt_to_phys(ia_css_ptr virt_addr)
 	return hmm_virt_to_phys(virt_addr);
 }
 
-ia_css_ptr hrt_isp_css_mm_alloc_contiguous(size_t bytes)
-{
-	BUG_ON(false);
-	return 0;
-}
-ia_css_ptr hrt_isp_css_mm_calloc_contiguous(size_t bytes)
-{
-	BUG_ON(false);
-	return 0;
-}
-
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h
index 41c6d14..4783206 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h
@@ -81,8 +81,5 @@ int hrt_isp_css_mm_store_int(ia_css_ptr virt_addr, int data);
    the display driver on  the FPGA system */
 phys_addr_t hrt_isp_css_virt_to_phys(ia_css_ptr virt_addr);
 
-ia_css_ptr hrt_isp_css_mm_alloc_contiguous(size_t bytes);
-ia_css_ptr hrt_isp_css_mm_calloc_contiguous(size_t bytes);
-
 void hrt_isp_css_mm_clear(void);
 #endif /* _hive_isp_css_mm_hrt_h_ */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hrt/memory_access.c b/drivers/staging/media/atomisp/pci/atomisp2/hrt/memory_access.c
index dcc4c91..7694ee4 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hrt/memory_access.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hrt/memory_access.c
@@ -60,42 +60,23 @@ ia_css_ptr mmgr_alloc_attr(const size_t	size, const uint16_t attribute)
 
 	assert(page_table_base_address != (sys_address)-1);
 	assert((attribute & MMGR_ATTRIBUTE_UNUSED) == 0);
+	WARN_ON(attribute & MMGR_ATTRIBUTE_CONTIGUOUS);
 
 	if (attribute & MMGR_ATTRIBUTE_CLEARED) {
 		if (attribute & MMGR_ATTRIBUTE_CACHED) {
-			if (attribute & MMGR_ATTRIBUTE_CONTIGUOUS) /* { */
-				ptr = hrt_isp_css_mm_calloc_contiguous(
+			ptr = hrt_isp_css_mm_calloc_cached(
 						aligned_size + extra_space);
-			/* } */ else /* { */
-				ptr = hrt_isp_css_mm_calloc_cached(
-						aligned_size + extra_space);
-			/* } */
 		} else { /* !MMGR_ATTRIBUTE_CACHED */
-			if (attribute & MMGR_ATTRIBUTE_CONTIGUOUS) /* { */
-				ptr = hrt_isp_css_mm_calloc_contiguous(
-						aligned_size + extra_space);
-			/* } */ else /* { */
-				ptr = hrt_isp_css_mm_calloc(
+			ptr = hrt_isp_css_mm_calloc(
 						aligned_size + extra_space);
-			/* } */
 		}
 	} else { /* MMGR_ATTRIBUTE_CLEARED */
 		if (attribute & MMGR_ATTRIBUTE_CACHED) {
-			if (attribute & MMGR_ATTRIBUTE_CONTIGUOUS) /* { */
-				ptr = hrt_isp_css_mm_alloc_contiguous(
-						aligned_size + extra_space);
-			/* } */ else /* { */
-				ptr = hrt_isp_css_mm_alloc_cached(
+			ptr = hrt_isp_css_mm_alloc_cached(
 						aligned_size + extra_space);
-			/* } */
 		} else { /* !MMGR_ATTRIBUTE_CACHED */
-			if (attribute & MMGR_ATTRIBUTE_CONTIGUOUS) /* { */
-				ptr = hrt_isp_css_mm_alloc_contiguous(
-						aligned_size + extra_space);
-			/* } */ else /* { */
-				ptr = hrt_isp_css_mm_alloc(
-						aligned_size + extra_space);
-			/* } */
+			ptr = hrt_isp_css_mm_alloc(
+					aligned_size + extra_space);
 		}
 	}
 	return ptr;
