Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60281 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754684AbdDLSVp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 14:21:45 -0400
Subject: [PATCH 08/14] atomisp: remove indirection from sh_css_malloc
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Wed, 12 Apr 2017 19:21:33 +0100
Message-ID: <149202128908.16615.8884323049461863996.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
References: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We have one hard coded set of behaviour so unpick the indirection and function
pointers. This isn't the whole story. A lot of the callers are known sizes and
use cases so we can switch them directly to kmalloc later on.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../atomisp/pci/atomisp2/atomisp_compat_css20.c    |    3 -
 .../atomisp/pci/atomisp2/css2400/ia_css_env.h      |   19 -------
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |   52 +++++++++-----------
 3 files changed, 25 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
index 6586842..b830b24 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
@@ -923,9 +923,6 @@ int atomisp_css_load_firmware(struct atomisp_device *isp)
 	isp->css_env.isp_css_fw.data = (void *)isp->firmware->data;
 	isp->css_env.isp_css_fw.bytes = isp->firmware->size;
 
-	isp->css_env.isp_css_env.cpu_mem_env.alloc = atomisp_kernel_zalloc;
-	isp->css_env.isp_css_env.cpu_mem_env.free = atomisp_kernel_free;
-
 	isp->css_env.isp_css_env.hw_access_env.store_8 =
 							atomisp_css2_hw_store_8;
 	isp->css_env.isp_css_env.hw_access_env.store_16 =
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_env.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_env.h
index 4d54aea..1ae9daf 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_env.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_env.h
@@ -39,25 +39,8 @@ enum ia_css_mem_attr {
  *  This is never expected to allocate more than one page of memory (4K bytes).
  */
 struct ia_css_cpu_mem_env {
-	void * (*alloc)(size_t bytes, bool zero_mem);
-	/**< Allocation function with boolean argument to indicate whether
-	     the allocated memory should be zeroed out or not, true (or 1)
-	     meaning the memory given to CSS must be zeroed */
-	void (*free)(void *ptr);
-	/**< Corresponding free function. The function must also accept
-	     a NULL argument, similar to C89 free(). */
 	void (*flush)(struct ia_css_acc_fw *fw);
 	/**< Flush function to flush the cache for given accelerator. */
-#ifdef ISP2401
-
-	#if !defined(__SVOS__)
-	/* a set of matching functions with additional debug params */
-	void * (*alloc_ex)(size_t bytes, bool zero_mem, const char *caller_func, int caller_line);
-	/**< same as alloc above, only with additional debug parameters */
-	void (*free_ex)(void *ptr, const char *caller_func, int caller_line);
-	/**< same as free above, only with additional debug parameters */
-	#endif
-#endif
 };
 
 /** Environment with function pointers to access the CSS hardware. This includes
@@ -103,7 +86,7 @@ struct ia_css_print_env {
  *  Windows and several simulation environments.
  */
 struct ia_css_env {
-	struct ia_css_cpu_mem_env   cpu_mem_env;   /**< local malloc and free. */
+	struct ia_css_cpu_mem_env   cpu_mem_env;   /**< local flush. */
 	struct ia_css_hw_access_env hw_access_env; /**< CSS HW access functions */
 	struct ia_css_print_env     print_env;     /**< Message printing env. */
 };
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index aa19419..30f7196 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -13,6 +13,10 @@
  */
 
 /*! \file */
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+
 #include "ia_css.h"
 #include "sh_css_hrt.h"		/* only for file 2 MIPI */
 #include "ia_css_buffer.h"
@@ -1679,15 +1683,8 @@ ia_css_load_firmware(const struct ia_css_env *env,
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "ia_css_load_firmware() enter\n");
 
 	/* make sure we initialize my_css */
-	if ((my_css.malloc != env->cpu_mem_env.alloc) ||
-		(my_css.free != env->cpu_mem_env.free) ||
-		(my_css.flush != env->cpu_mem_env.flush)
-		)
-	{
+	if (my_css.flush != env->cpu_mem_env.flush) {
 		ia_css_reset_defaults(&my_css);
-
-		my_css.malloc = env->cpu_mem_env.alloc;
-		my_css.free = env->cpu_mem_env.free;
 		my_css.flush = env->cpu_mem_env.flush;
 	}
 
@@ -1715,8 +1712,6 @@ ia_css_init(const struct ia_css_env *env,
 	ia_css_blctrl_cfg blctrl_cfg;
 #endif
 
-	void *(*malloc_func)(size_t size, bool zero_mem);
-	void (*free_func)(void *ptr);
 	void (*flush_func)(struct ia_css_acc_fw *fw);
 	hrt_data select, enable;
 
@@ -1765,8 +1760,6 @@ ia_css_init(const struct ia_css_env *env,
 
 	IA_CSS_ENTER("void");
 
-	malloc_func    = env->cpu_mem_env.alloc;
-	free_func      = env->cpu_mem_env.free;
 	flush_func     = env->cpu_mem_env.flush;
 
 	pipe_global_init();
@@ -1786,16 +1779,9 @@ ia_css_init(const struct ia_css_env *env,
 	ia_css_save_mmu_base_addr(mmu_l1_base);
 #endif
 
-	if (malloc_func == NULL || free_func == NULL) {
-		IA_CSS_LEAVE_ERR(IA_CSS_ERR_INVALID_ARGUMENTS);
-		return IA_CSS_ERR_INVALID_ARGUMENTS;
-	}
-
 	ia_css_reset_defaults(&my_css);
 
 	my_css_save.driver_env = *env;
-	my_css.malloc    = malloc_func;
-	my_css.free      = free_func;
 	my_css.flush     = flush_func;
 
 	err = ia_css_rmgr_init();
@@ -2018,25 +2004,35 @@ ia_css_enable_isys_event_queue(bool enable)
 void *sh_css_malloc(size_t size)
 {
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "sh_css_malloc() enter: size=%d\n",size);
-	if (size > 0 && my_css.malloc)
-		return my_css.malloc(size, false);
-	return NULL;
+	/* FIXME: This first test can probably go away */
+	if (size == 0)
+		return NULL;
+	if (size > PAGE_SIZE)
+		return vmalloc(size);
+	return kmalloc(size, GFP_KERNEL);
 }
 
 void *sh_css_calloc(size_t N, size_t size)
 {
+	void *p;
+
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "sh_css_calloc() enter: N=%d, size=%d\n",N,size);
-	if (size > 0 && my_css.malloc)
-		return my_css.malloc(N*size, true);		
+
+	/* FIXME: this test can probably go away */
+	if (size > 0) {
+		p = sh_css_malloc(N*size);
+		if (p)
+			memset(p, 0, size);
+	}
 	return NULL;
 }
 
 void sh_css_free(void *ptr)
 {
-	IA_CSS_ENTER_PRIVATE("ptr = %p", ptr);
-	if (ptr && my_css.free)
-		my_css.free(ptr);
-	IA_CSS_LEAVE_PRIVATE("void");
+	if (is_vmalloc_addr(ptr))
+		vfree(ptr);
+	else
+		kfree(ptr);
 }
 
 /* For Acceleration API: Flush FW (shared buffer pointer) arguments */
