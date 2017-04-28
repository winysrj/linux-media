Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:29297 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1162404AbdD1MJv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 08:09:51 -0400
Subject: [PATCH 3/8] atomisp: kill off mmgr_free
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Fri, 28 Apr 2017 13:09:46 +0100
Message-ID: <149338138122.2556.9536551144864823400.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149338135275.2556.7708531564733886566.stgit@acox1-desk1.ger.corp.intel.com>
References: <149338135275.2556.7708531564733886566.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is just another wrapper layer around hmm_free that servers no purpose
in this driver.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_acc.c       |    6 +++---
 .../atomisp2/css2400/base/refcount/src/refcount.c  |    8 ++++----
 .../memory_access/memory_access.h                  |   10 ++--------
 .../pci/atomisp2/css2400/ia_css_memory_access.c    |    6 ------
 .../isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c   |    2 +-
 .../isp/kernels/sdis/sdis_2/ia_css_sdis2.host.c    |    2 +-
 .../atomisp2/css2400/runtime/binary/src/binary.c   |    2 +-
 .../pci/atomisp2/css2400/runtime/frame/src/frame.c |    2 +-
 .../css2400/runtime/isp_param/src/isp_param.c      |    2 +-
 .../atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c  |    6 +++---
 .../atomisp2/css2400/runtime/spctrl/src/spctrl.c   |    6 +++---
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |    4 ++--
 .../atomisp/pci/atomisp2/css2400/sh_css_params.c   |   16 ++++++++--------
 .../media/atomisp/pci/atomisp2/hrt/memory_access.c |    7 -------
 14 files changed, 30 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_acc.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_acc.c
index 212e0a7..1eac329 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_acc.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_acc.c
@@ -136,7 +136,7 @@ void atomisp_acc_release(struct atomisp_sub_device *asd)
 	/* Free all mapped memory blocks */
 	list_for_each_entry_safe(atomisp_map, tm, &asd->acc.memory_maps, list) {
 		list_del(&atomisp_map->list);
-		mmgr_free(atomisp_map->ptr);
+		hmm_free(atomisp_map->ptr);
 		kfree(atomisp_map);
 	}
 }
@@ -374,7 +374,7 @@ int atomisp_acc_map(struct atomisp_sub_device *asd, struct atomisp_acc_map *map)
 
 	atomisp_map = kmalloc(sizeof(*atomisp_map), GFP_KERNEL);
 	if (!atomisp_map) {
-		mmgr_free(cssptr);
+		hmm_free(cssptr);
 		return -ENOMEM;
 	}
 	atomisp_map->ptr = cssptr;
@@ -399,7 +399,7 @@ int atomisp_acc_unmap(struct atomisp_sub_device *asd, struct atomisp_acc_map *ma
 		return -EINVAL;
 
 	list_del(&atomisp_map->list);
-	mmgr_free(atomisp_map->ptr);
+	hmm_free(atomisp_map->ptr);
 	kfree(atomisp_map);
 	return 0;
 }
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/base/refcount/src/refcount.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/base/refcount/src/refcount.c
index 05e4bc3..6e3bd77 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/base/refcount/src/refcount.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/base/refcount/src/refcount.c
@@ -108,7 +108,7 @@ void ia_css_refcount_uninit(void)
 			/*	ia_css_debug_dtrace(IA_CSS_DBG_TRACE,
 				"ia_css_refcount_uninit: freeing (%x)\n",
 				entry->data);*/
-			mmgr_free(entry->data);
+			hmm_free(entry->data);
 			entry->data = mmgr_NULL;
 			entry->count = 0;
 			entry->id = 0;
@@ -181,7 +181,7 @@ bool ia_css_refcount_decrement(int32_t id, hrt_vaddress ptr)
 			if (entry->count == 0) {
 				/* ia_css_debug_dtrace(IA_CSS_DBEUG_TRACE,
 				   "ia_css_refcount_decrement: freeing\n");*/
-				mmgr_free(ptr);
+				hmm_free(ptr);
 				entry->data = mmgr_NULL;
 				entry->id = 0;
 			}
@@ -244,9 +244,9 @@ void ia_css_refcount_clear(int32_t id, clear_func clear_func_ptr)
 			} else {
 				ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE,
 						    "ia_css_refcount_clear: "
-						    "using mmgr_free: "
+						    "using hmm_free: "
 						    "no clear_func\n");
-				mmgr_free(entry->data);
+				hmm_free(entry->data);
 			}
 #ifndef ISP2401
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/memory_access/memory_access.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/memory_access/memory_access.h
index 54ab3d9..195c4a5 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/memory_access/memory_access.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/memory_access/memory_access.h
@@ -59,6 +59,8 @@
  */
 #include "device_access.h"
 
+#include "hmm/hmm.h"
+
 /*!
  * \brief
  * Bit masks for specialised allocation functions
@@ -106,14 +108,6 @@ extern hrt_vaddress mmgr_malloc(const size_t size);
  */
 extern hrt_vaddress mmgr_calloc(const size_t N, const size_t size);
 
-/*! Free the memory allocation identified by the address
-
- \param	vaddr[in]		Address of the allocation
-
- \return vaddress
- */
-extern void mmgr_free(hrt_vaddress vaddr);
-
 /*! Return the address of an allocation in memory
 
  \param	size[in]		Size in bytes of the allocation
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c
index 5b2bdfd..f8fc14c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c
@@ -53,12 +53,6 @@ mmgr_calloc(const size_t N, const size_t size)
 }
 
 void
-mmgr_free(hrt_vaddress vaddr)
-{
-	hmm_free(vaddr);
-}
-
-void
 mmgr_clear(hrt_vaddress vaddr, const size_t size)
 {
 	hrt_isp_css_mm_set(vaddr, 0, size);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c
index 0dde842..0daab11 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c
@@ -390,7 +390,7 @@ void
 ia_css_isp_dvs_statistics_free(struct ia_css_isp_dvs_statistics *me)
 {
 	if (me != NULL) {
-		mmgr_free(me->data_ptr);
+		hmm_free(me->data_ptr);
 		sh_css_free(me);
 	}
 }
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_2/ia_css_sdis2.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_2/ia_css_sdis2.host.c
index 930061d..5a0c103 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_2/ia_css_sdis2.host.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_2/ia_css_sdis2.host.c
@@ -304,7 +304,7 @@ void
 ia_css_isp_dvs2_statistics_free(struct ia_css_isp_dvs_statistics *me)
 {
 	if (me != NULL) {
-		mmgr_free(me->data_ptr);
+		hmm_free(me->data_ptr);
 		sh_css_free(me);
 	}
 }
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c
index 34ca534..a8b93a7 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c
@@ -990,7 +990,7 @@ ia_css_binary_uninit(void)
 	for (i = 0; i < IA_CSS_BINARY_NUM_MODES; i++) {
 		for (b = binary_infos[i]; b; b = b->next) {
 			if (b->xmem_addr)
-				mmgr_free(b->xmem_addr);
+				hmm_free(b->xmem_addr);
 			b->xmem_addr = mmgr_NULL;
 		}
 		binary_infos[i] = NULL;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/frame/src/frame.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/frame/src/frame.c
index 604bde6..f1a943c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/frame/src/frame.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/frame/src/frame.c
@@ -345,7 +345,7 @@ void ia_css_frame_free(struct ia_css_frame *frame)
 	IA_CSS_ENTER_PRIVATE("frame = %p", frame);
 
 	if (frame != NULL) {
-		mmgr_free(frame->data);
+		hmm_free(frame->data);
 		sh_css_free(frame);
 	}
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/src/isp_param.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/src/isp_param.c
index 6f2935a..832d9e1 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/src/isp_param.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/src/isp_param.c
@@ -167,7 +167,7 @@ ia_css_isp_param_destroy_isp_parameters(
 			if (mem_params->params[pclass][mem].address)
 				sh_css_free(mem_params->params[pclass][mem].address);
 			if (css_params->params[pclass][mem].address)
-				mmgr_free(css_params->params[pclass][mem].address);
+				hmm_free(css_params->params[pclass][mem].address);
 			mem_params->params[pclass][mem].address = NULL;
 			css_params->params[pclass][mem].address = 0x0;
 		}
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c
index 3aafc0a..fa92d8d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c
@@ -17,7 +17,7 @@
 #include <type_support.h>
 #include <assert_support.h>
 #include <platform_support.h> /* memset */
-#include <memory_access.h>    /* mmmgr_malloc, mmmgr_free */
+#include <memory_access.h>    /* mmmgr_malloc, mhmm_free */
 #include <ia_css_debug.h>
 
 /**
@@ -185,7 +185,7 @@ void ia_css_rmgr_uninit_vbuf(struct ia_css_rmgr_vbuf_pool *pool)
 				      pool->handles[i]->vptr,
 				      pool->handles[i]->count);
 				/* free memory */
-				mmgr_free(pool->handles[i]->vptr);
+				hmm_free(pool->handles[i]->vptr);
 				/* remove from refcount admin */
 				ia_css_rmgr_refcount_release_vbuf(
 					&pool->handles[i]);
@@ -319,7 +319,7 @@ void ia_css_rmgr_rel_vbuf(struct ia_css_rmgr_vbuf_pool *pool,
 	if ((*handle)->count == 1) {
 		if (!pool->recycle) {
 			/* non recycling pool, free mem */
-			mmgr_free((*handle)->vptr);
+			hmm_free((*handle)->vptr);
 		} else {
 			/* recycle to pool */
 			rmgr_push_handle(pool, handle);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c
index fc42c02..b36d7b0 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c
@@ -91,7 +91,7 @@ enum ia_css_err ia_css_spctrl_load_fw(sp_ID_t sp_id,
 	if (sizeof(hrt_vaddress) > sizeof(hrt_data)) {
 		ia_css_debug_dtrace(IA_CSS_DEBUG_ERROR,
 				    "size of hrt_vaddress can not be greater than hrt_data\n");
-		mmgr_free(code_addr);
+		hmm_free(code_addr);
 		code_addr = mmgr_NULL;
 		return IA_CSS_ERR_INTERNAL_ERROR;
 	}
@@ -100,7 +100,7 @@ enum ia_css_err ia_css_spctrl_load_fw(sp_ID_t sp_id,
 	if ((init_dmem_cfg->ddr_data_addr % HIVE_ISP_DDR_WORD_BYTES) != 0) {
 		ia_css_debug_dtrace(IA_CSS_DEBUG_ERROR,
 				    "DDR address pointer is not properly aligned for DMA transfer\n");
-		mmgr_free(code_addr);
+		hmm_free(code_addr);
 		code_addr = mmgr_NULL;
 		return IA_CSS_ERR_INTERNAL_ERROR;
 	}
@@ -143,7 +143,7 @@ enum ia_css_err ia_css_spctrl_unload_fw(sp_ID_t sp_id)
 
 	/*  freeup the resource */
 	if (spctrl_cofig_info[sp_id].code_addr)
-		mmgr_free(spctrl_cofig_info[sp_id].code_addr);
+		hmm_free(spctrl_cofig_info[sp_id].code_addr);
 	spctrl_loaded[sp_id] = false;
 	return IA_CSS_SUCCESS;
 }
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 2359449..73c7658 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -2613,7 +2613,7 @@ ia_css_pipe_destroy(struct ia_css_pipe *pipe)
 
 #ifndef ISP2401
 	if (pipe->scaler_pp_lut != mmgr_NULL) {
-		mmgr_free(pipe->scaler_pp_lut);
+		hmm_free(pipe->scaler_pp_lut);
 		pipe->scaler_pp_lut = mmgr_NULL;
 	}
 #else
@@ -8692,7 +8692,7 @@ acc_unload_extension(struct ia_css_fw_info *firmware)
 	while (hd){
 		hdn = (hd->next) ? &(*hd->next) : NULL;
 		if (hd->info.isp.xmem_addr) {
-			mmgr_free(hd->info.isp.xmem_addr);
+			hmm_free(hd->info.isp.xmem_addr);
 			hd->info.isp.xmem_addr = mmgr_NULL;
 		}
 		hd->isp_code = NULL;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
index 6674f96..561f4a7 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
@@ -2825,7 +2825,7 @@ void
 ia_css_isp_3a_statistics_free(struct ia_css_isp_3a_statistics *me)
 {
 	if (me != NULL) {
-		mmgr_free(me->data_ptr);
+		hmm_free(me->data_ptr);
 		sh_css_free(me);
 	}
 }
@@ -2874,7 +2874,7 @@ ia_css_metadata_free(struct ia_css_metadata *me)
 		 * We found this to be confusing during development
 		 * and debugging. */
 		IA_CSS_ENTER("me=%p", me);
-		mmgr_free(me->address);
+		hmm_free(me->address);
 		sh_css_free(me);
 		IA_CSS_LEAVE("void");
 	}
@@ -3320,7 +3320,7 @@ inline hrt_vaddress sh_css_params_alloc_gdc_lut(void)
 inline void sh_css_params_free_gdc_lut(hrt_vaddress addr)
 {
 	if (addr != mmgr_NULL)
-		mmgr_free(addr);
+		hmm_free(addr);
 }
 
 enum ia_css_err ia_css_pipe_set_bci_scaler_lut(struct ia_css_pipe *pipe,
@@ -3358,7 +3358,7 @@ enum ia_css_err ia_css_pipe_set_bci_scaler_lut(struct ia_css_pipe *pipe,
 	/* Free any existing tables. */
 #ifndef ISP2401
 	if (pipe->scaler_pp_lut != mmgr_NULL) {
-		mmgr_free(pipe->scaler_pp_lut);
+		hmm_free(pipe->scaler_pp_lut);
 		pipe->scaler_pp_lut = mmgr_NULL;
 	}
 #else
@@ -3447,7 +3447,7 @@ void sh_css_params_free_default_gdc_lut(void)
 
 #ifndef ISP2401
 	if (default_gdc_lut != mmgr_NULL) {
-		mmgr_free(default_gdc_lut);
+		hmm_free(default_gdc_lut);
 		default_gdc_lut = mmgr_NULL;
 	}
 #else
@@ -3479,7 +3479,7 @@ static void free_buffer_callback(
 {
 	IA_CSS_ENTER_PRIVATE("void");
 
-	mmgr_free(ptr);
+	hmm_free(ptr);
 
 	IA_CSS_LEAVE_PRIVATE("void");
 }
@@ -3495,8 +3495,8 @@ sh_css_param_clear_param_sets(void)
 }
 
 /*
- * MW: we can define mmgr_free() to return a NULL
- * then you can write ptr = mmgr_free(ptr);
+ * MW: we can define hmm_free() to return a NULL
+ * then you can write ptr = hmm_free(ptr);
  */
 #define safe_free(id, x)      \
 	do {                  \
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hrt/memory_access.c b/drivers/staging/media/atomisp/pci/atomisp2/hrt/memory_access.c
index 9d3900f..6c7f38d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hrt/memory_access.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hrt/memory_access.c
@@ -45,13 +45,6 @@ ia_css_ptr mmgr_calloc(const size_t N, const size_t size)
 		MMGR_ATTRIBUTE_CLEARED|MMGR_ATTRIBUTE_CACHED);
 }
 
-void mmgr_free(ia_css_ptr vaddr)
-{
-/* "free()" should accept NULL, "hmm_free()" may not */
-	if (vaddr)
-		hmm_free(vaddr);
-}
-
 ia_css_ptr mmgr_alloc_attr(const size_t	size, const uint16_t attribute)
 {
 	ia_css_ptr	ptr;
