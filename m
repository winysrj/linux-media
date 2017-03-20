Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:11087 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755464AbdCTOjD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:39:03 -0400
Subject: [PATCH 04/24] atomisp: remove another layer of allocator indirection
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:38:59 +0000
Message-ID: <149002072997.17109.8941544331685965974.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
References: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Our driver only ever uses one set of routines for the allocators used by the CSS layer to
manage memory and the memory management on the ISP. We can thus remove the function vectors
and simply call the intended routines directly.

These routines in turn are simply wrappers around another layer of code so remove this
second layer of wrappers and call the hrt methods directly. In time we can remove this layer
of indirection as well.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../atomisp/pci/atomisp2/atomisp_compat_css20.c    |   66 --------------------
 .../ia_css_isp_states.h                            |    1 
 .../ia_css_isp_states.h                            |    1 
 .../ia_css_isp_states.h                            |    1 
 .../atomisp/pci/atomisp2/css2400/ia_css_env.h      |   48 ---------------
 .../pci/atomisp2/css2400/ia_css_memory_access.c    |   64 +++++++++++--------
 .../pci/atomisp2/css2400/ia_css_memory_access.h    |   24 -------
 .../css2400/isp/kernels/bh/bh_2/ia_css_bh.host.c   |    1 
 .../raw_aa_binning_1.0/ia_css_raa.host.c           |    1 
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |    4 -
 10 files changed, 35 insertions(+), 176 deletions(-)
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.h

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
index 760f06d..2e20a81 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
@@ -92,65 +92,6 @@ unsigned int atomisp_css_debug_get_dtrace_level(void)
 	return ia_css_debug_trace_level;
 }
 
-static ia_css_ptr atomisp_css2_mm_alloc(size_t bytes, uint32_t attr)
-{
-	if (attr & IA_CSS_MEM_ATTR_ZEROED) {
-		if (attr & IA_CSS_MEM_ATTR_CACHED) {
-			if (attr & IA_CSS_MEM_ATTR_CONTIGUOUS)
-				return (ia_css_ptr) hrt_isp_css_mm_calloc_contiguous(bytes);
-			else
-				return (ia_css_ptr) hrt_isp_css_mm_calloc_cached(bytes);
-		} else {
-			if (attr & IA_CSS_MEM_ATTR_CONTIGUOUS)
-				return (ia_css_ptr) hrt_isp_css_mm_calloc_contiguous(bytes);
-			else
-				return (ia_css_ptr) hrt_isp_css_mm_calloc(bytes);
-		}
-	} else {
-		if (attr & IA_CSS_MEM_ATTR_CACHED) {
-			if (attr & IA_CSS_MEM_ATTR_CONTIGUOUS)
-				return (ia_css_ptr) hrt_isp_css_mm_alloc_contiguous(bytes);
-			else
-				return (ia_css_ptr) hrt_isp_css_mm_alloc_cached(bytes);
-		} else {
-			if (attr & IA_CSS_MEM_ATTR_CONTIGUOUS)
-				return (ia_css_ptr) hrt_isp_css_mm_alloc_contiguous(bytes);
-			else
-				return (ia_css_ptr) hrt_isp_css_mm_alloc(bytes);
-		}
-	}
-}
-
-static void atomisp_css2_mm_free(ia_css_ptr ptr)
-{
-	hrt_isp_css_mm_free(ptr);
-}
-
-static int atomisp_css2_mm_load(ia_css_ptr ptr, void *data, size_t bytes)
-{
-	return hrt_isp_css_mm_load(ptr, data, bytes);
-}
-
-static int atomisp_css2_mm_store(ia_css_ptr ptr, const void *data, size_t bytes)
-{
-	return hrt_isp_css_mm_store(ptr, data, bytes);
-}
-
-static int atomisp_css2_mm_set(ia_css_ptr ptr, int c, size_t bytes)
-{
-	return hrt_isp_css_mm_set(ptr, c, bytes);
-}
-
-static ia_css_ptr atomisp_css2_mm_mmap(const void *ptr, const size_t size,
-		   uint16_t attribute, void *context)
-{
-	struct hrt_userbuffer_attr *userbuffer_attr = context;
-	return hrt_isp_css_mm_alloc_user_ptr(
-			size, (void *)ptr, userbuffer_attr->pgnr,
-			userbuffer_attr->type,
-			attribute & HRT_BUF_FLAG_CACHED);
-}
-
 void atomisp_css2_hw_store_8(hrt_address addr, uint8_t data)
 {
 	unsigned long flags;
@@ -985,13 +926,6 @@ int atomisp_css_load_firmware(struct atomisp_device *isp)
 	isp->css_env.isp_css_env.cpu_mem_env.alloc = atomisp_kernel_zalloc;
 	isp->css_env.isp_css_env.cpu_mem_env.free = atomisp_kernel_free;
 
-	isp->css_env.isp_css_env.css_mem_env.alloc = atomisp_css2_mm_alloc;
-	isp->css_env.isp_css_env.css_mem_env.free = atomisp_css2_mm_free;
-	isp->css_env.isp_css_env.css_mem_env.load = atomisp_css2_mm_load;
-	isp->css_env.isp_css_env.css_mem_env.store = atomisp_css2_mm_store;
-	isp->css_env.isp_css_env.css_mem_env.set = atomisp_css2_mm_set;
-	isp->css_env.isp_css_env.css_mem_env.mmap = atomisp_css2_mm_mmap;
-
 	isp->css_env.isp_css_env.hw_access_env.store_8 =
 							atomisp_css2_hw_store_8;
 	isp->css_env.isp_css_env.hw_access_env.store_16 =
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_states.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_states.h
index 939dc36..732adaf 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_states.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_states.h
@@ -13,7 +13,6 @@
  */
 
 #define IA_CSS_INCLUDE_STATES
-#include "ia_css_memory_access.h"
 #include "isp/kernels/aa/aa_2/ia_css_aa2.host.h"
 #include "isp/kernels/cnr/cnr_1.0/ia_css_cnr.host.h"
 #include "isp/kernels/cnr/cnr_2/ia_css_cnr2.host.h"
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_states.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_states.h
index 939dc36..732adaf 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_states.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_states.h
@@ -13,7 +13,6 @@
  */
 
 #define IA_CSS_INCLUDE_STATES
-#include "ia_css_memory_access.h"
 #include "isp/kernels/aa/aa_2/ia_css_aa2.host.h"
 #include "isp/kernels/cnr/cnr_1.0/ia_css_cnr.host.h"
 #include "isp/kernels/cnr/cnr_2/ia_css_cnr2.host.h"
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_states.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_states.h
index 939dc36..732adaf 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_states.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_states.h
@@ -13,7 +13,6 @@
  */
 
 #define IA_CSS_INCLUDE_STATES
-#include "ia_css_memory_access.h"
 #include "isp/kernels/aa/aa_2/ia_css_aa2.host.h"
 #include "isp/kernels/cnr/cnr_1.0/ia_css_cnr.host.h"
 #include "isp/kernels/cnr/cnr_2/ia_css_cnr2.host.h"
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_env.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_env.h
index b4bf842..4d54aea 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_env.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_env.h
@@ -60,53 +60,6 @@ struct ia_css_cpu_mem_env {
 #endif
 };
 
-/** Environment with function pointers for allocation of memory for the CSS.
- *  The CSS uses its own MMU which has its own set of page tables. These
- *  functions are expected to use and/or update those page tables.
- *  This type of memory allocation is expected to be used for large buffers
- *  for images and statistics.
- *  ISP pointers are always 32 bits whereas IA pointer widths will depend
- *  on the platform.
- *  Attributes can be a combination (OR'ed) of ia_css_mem_attr values.
- */
-struct ia_css_css_mem_env {
-	ia_css_ptr(*alloc)(size_t bytes, uint32_t attributes);
-	/**< Allocate memory, cached or uncached, zeroed out or not. */
-	void (*free)(ia_css_ptr ptr);
-	/**< Free ISP shared memory. The function must also accept
-	     a NULL argument, similar to C89 free(). */
-	int (*load)(ia_css_ptr ptr, void *data, size_t bytes);
-	/**< Load from ISP shared memory. This function is necessary because
-	     the IA MMU does not share page tables with the ISP MMU. This means
-	     that the IA needs to do the virtual-to-physical address
-	     translation in software. This function performs this translation.*/
-	int (*store)(ia_css_ptr ptr, const void *data, size_t bytes);
-	/**< Same as the above load function but then to write data into ISP
-	     shared memory. */
-	int (*set)(ia_css_ptr ptr, int c, size_t bytes);
-	/**< Set an ISP shared memory region to a particular value. Each byte
-	     in this region will be set to this value. In most cases this is
-	     used to zero-out memory sections in which case the argument c
-	     would have the value zero. */
-	ia_css_ptr (*mmap)(const void *ptr, const size_t size,
-			   uint16_t attribute, void *context);
-	/**< Map an pre-allocated memory region to an address. */
-#ifdef ISP2401
-
-	/* a set of matching functions with additional debug params */
-	ia_css_ptr(*alloc_ex)(size_t bytes, uint32_t attributes, const char *caller_func, int caller_line);
-	/**< same as alloc above, only with additional debug parameters */
-	void (*free_ex)(ia_css_ptr ptr, const char *caller_func, int caller_line);
-	/**< same as free above, only with additional debug parameters */
-	int (*load_ex)(ia_css_ptr ptr, void *data, size_t bytes, const char *caller_func, int caller_line);
-	/**< same as load above, only with additional debug parameters */
-	int (*store_ex)(ia_css_ptr ptr, const void *data, size_t bytes, const char *caller_func, int caller_line);
-	/**< same as store above, only with additional debug parameters */
-	int (*set_ex)(ia_css_ptr ptr, int c, size_t bytes, const char *caller_func, int caller_line);
-	/**< same as set above, only with additional debug parameters */
-#endif
-};
-
 /** Environment with function pointers to access the CSS hardware. This includes
  *  registers and local memories.
  */
@@ -151,7 +104,6 @@ struct ia_css_print_env {
  */
 struct ia_css_env {
 	struct ia_css_cpu_mem_env   cpu_mem_env;   /**< local malloc and free. */
-	struct ia_css_css_mem_env   css_mem_env;   /**< CSS/ISP buffer alloc/free */
 	struct ia_css_hw_access_env hw_access_env; /**< CSS HW access functions */
 	struct ia_css_print_env     print_env;     /**< Message printing env. */
 };
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c
index a140cec..8d559aa 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c
@@ -12,26 +12,16 @@
  * more details.
  */
 
-#include "ia_css_memory_access.h"
 #include <type_support.h>
 #include <system_types.h>
 #include <assert_support.h>
 #include <memory_access.h>
 #include <ia_css_env.h>
+#include <hrt/hive_isp_css_mm_hrt.h>
 
 const hrt_vaddress mmgr_NULL = (hrt_vaddress)0;
 const hrt_vaddress mmgr_EXCEPTION = (hrt_vaddress)-1;
 
-static struct ia_css_css_mem_env my_env;
-
-void
-ia_css_memory_access_init(const struct ia_css_css_mem_env *env)
-{
-	assert(env != NULL);
-
-	my_env = *env;
-}
-
 hrt_vaddress
 mmgr_malloc(const size_t size)
 {
@@ -40,21 +30,33 @@ mmgr_malloc(const size_t size)
 
 hrt_vaddress mmgr_alloc_attr(const size_t size, const uint16_t attrs)
 {
-	uint32_t my_attrs = 0;
 	uint16_t masked_attrs = attrs & MMGR_ATTRIBUTE_MASK;
-	hrt_vaddress ptr;
-
-	if (masked_attrs & MMGR_ATTRIBUTE_CACHED)
-		my_attrs |= IA_CSS_MEM_ATTR_CACHED;
-	if (masked_attrs & MMGR_ATTRIBUTE_CLEARED)
-		my_attrs |= IA_CSS_MEM_ATTR_ZEROED;
-	if (masked_attrs & MMGR_ATTRIBUTE_CONTIGUOUS)
-		my_attrs |= IA_CSS_MEM_ATTR_CONTIGUOUS;
-	if (masked_attrs & MMGR_ATTRIBUTE_PAGEALIGN)
-		my_attrs |= IA_CSS_MEM_ATTR_PAGEALIGN;
 
-	ptr = my_env.alloc(size, my_attrs);
-	return ptr;
+	if (masked_attrs & MMGR_ATTRIBUTE_CLEARED) {
+		if (masked_attrs & MMGR_ATTRIBUTE_CACHED) {
+			if (masked_attrs & MMGR_ATTRIBUTE_CONTIGUOUS)
+				return (ia_css_ptr) hrt_isp_css_mm_calloc_contiguous(size);
+			else
+				return (ia_css_ptr) hrt_isp_css_mm_calloc_cached(size);
+		} else {
+			if (masked_attrs & MMGR_ATTRIBUTE_CONTIGUOUS)
+				return (ia_css_ptr) hrt_isp_css_mm_calloc_contiguous(size);
+			else
+				return (ia_css_ptr) hrt_isp_css_mm_calloc(size);
+		}
+	} else {
+		if (masked_attrs & MMGR_ATTRIBUTE_CACHED) {
+			if (masked_attrs & MMGR_ATTRIBUTE_CONTIGUOUS)
+				return (ia_css_ptr) hrt_isp_css_mm_alloc_contiguous(size);
+			else
+				return (ia_css_ptr) hrt_isp_css_mm_alloc_cached(size);
+		} else {
+			if (masked_attrs & MMGR_ATTRIBUTE_CONTIGUOUS)
+				return (ia_css_ptr) hrt_isp_css_mm_alloc_contiguous(size);
+			else
+				return (ia_css_ptr) hrt_isp_css_mm_alloc(size);
+		}
+	}
 }
 
 hrt_vaddress
@@ -66,30 +68,34 @@ mmgr_calloc(const size_t N, const size_t size)
 void
 mmgr_free(hrt_vaddress vaddr)
 {
-	my_env.free(vaddr);
+	hrt_isp_css_mm_free(vaddr);
 }
 
 void
 mmgr_clear(hrt_vaddress vaddr, const size_t size)
 {
-	my_env.set(vaddr, 0, size);
+	hrt_isp_css_mm_set(vaddr, 0, size);
 }
 
 void
 mmgr_load(const hrt_vaddress vaddr, void *data, const size_t size)
 {
-	my_env.load(vaddr, data, size);
+	hrt_isp_css_mm_load(vaddr, data, size);
 }
 
 void
 mmgr_store(const hrt_vaddress vaddr, const void *data, const size_t size)
 {
-	my_env.store(vaddr, data, size);
+	hrt_isp_css_mm_store(vaddr, data, size);
 }
 
 hrt_vaddress
 mmgr_mmap(const void *ptr, const size_t size,
 	  uint16_t attribute, void *context)
 {
-	return my_env.mmap(ptr, size, attribute, context);
+	struct hrt_userbuffer_attr *userbuffer_attr = context;
+	return hrt_isp_css_mm_alloc_user_ptr(
+			size, (void *)ptr, userbuffer_attr->pgnr,
+			userbuffer_attr->type,
+			attribute & HRT_BUF_FLAG_CACHED);
 }
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.h
deleted file mode 100644
index 1d6db0b..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/*
- * Support for Intel Camera Imaging ISP subsystem.
- * Copyright (c) 2015, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- */
-
-#ifndef _IA_CSS_MEMORY_ACCESS_H_
-#define _IA_CSS_MEMORY_ACCESS_H_
-
-#include "ia_css_env.h"
-
-void
-ia_css_memory_access_init(const struct ia_css_css_mem_env *env);
-
-#endif /* _IA_CSS_MEMORY_ACCESS_H_ */
-
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bh/bh_2/ia_css_bh.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bh/bh_2/ia_css_bh.host.c
index 69e708f..0dcafad 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bh/bh_2/ia_css_bh.host.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bh/bh_2/ia_css_bh.host.c
@@ -14,7 +14,6 @@
 
 #if !defined(HAS_NO_HMEM)
 
-#include "ia_css_memory_access.h"
 #include "memory_access.h"
 #include "ia_css_types.h"
 #include "sh_css_internal.h"
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/raw_aa_binning/raw_aa_binning_1.0/ia_css_raa.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/raw_aa_binning/raw_aa_binning_1.0/ia_css_raa.host.c
index 74521c9..9216821 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/raw_aa_binning/raw_aa_binning_1.0/ia_css_raa.host.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/raw_aa_binning/raw_aa_binning_1.0/ia_css_raa.host.c
@@ -14,7 +14,6 @@
 
 #if !defined(HAS_NO_HMEM)
 
-#include "ia_css_memory_access.h"
 #include "memory_access.h"
 #include "ia_css_types.h"
 #include "sh_css_internal.h"
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 2eab07d..3cbdcef 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -33,7 +33,6 @@
 #include "ia_css_rmgr.h"
 #include "ia_css_debug.h"
 #include "ia_css_debug_pipe.h"
-#include "ia_css_memory_access.h"
 #include "ia_css_device_access.h"
 #include "device_access.h"
 #include "sh_css_legacy.h"
@@ -1690,8 +1689,6 @@ ia_css_load_firmware(const struct ia_css_env *env,
 
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "ia_css_load_firmware() enter\n");
 
-	ia_css_memory_access_init(&env->css_mem_env);
-
 	/* make sure we initialize my_css */
 	if ((my_css.malloc != env->cpu_mem_env.alloc) ||
 		(my_css.free != env->cpu_mem_env.free) ||
@@ -1791,7 +1788,6 @@ ia_css_init(const struct ia_css_env *env,
 	ia_css_queue_map_init();
 
 	ia_css_device_access_init(&env->hw_access_env);
-	ia_css_memory_access_init(&env->css_mem_env);
 
 	select = gpio_reg_load(GPIO0_ID, _gpio_block_reg_do_select)
 						& (~GPIO_FLASH_PIN_MASK);
