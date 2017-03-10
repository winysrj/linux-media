Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9978 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933439AbdCJLeU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 06:34:20 -0500
Subject: [PATCH 4/8] atomisp: remove C_RUN define and code
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Fri, 10 Mar 2017 11:34:11 +0000
Message-ID: <148914564652.25309.16667475152495212677.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <148914560647.25309.2276061224604665212.stgit@acox1-desk1.ger.corp.intel.com>
References: <148914560647.25309.2276061224604665212.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We are not going to be building for anything but Linux so the code bracketed
by C_RUN is not used and not needed.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../css_2400_system/hrt/isp2400_mamoiada_params.h  |    4 --
 .../pci/atomisp2/css2400/css_2400_system/hrt/var.h |   25 --------------
 .../css2400/hive_isp_css_common/host/isp.c         |   19 -----------
 .../css2400/hive_isp_css_common/host/isp_private.h |   20 ++---------
 .../css2400/hive_isp_css_common/host/sp_local.h    |   23 -------------
 .../css2400/hive_isp_css_common/host/sp_private.h  |   35 --------------------
 .../css2400/hive_isp_css_common/host/vmem.c        |   21 ------------
 .../css2400/hive_isp_css_common/vmem_global.h      |    4 --
 .../css2400/hive_isp_css_include/assert_support.h  |    4 --
 .../pci/atomisp2/css2400/runtime/bufq/src/bufq.c   |    4 --
 .../css2400/runtime/debug/src/ia_css_debug.c       |    4 +-
 .../atomisp2/css2400/runtime/spctrl/src/spctrl.c   |    2 +
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |    8 ++---
 .../atomisp/pci/atomisp2/css2400/sh_css_firmware.c |    2 +
 .../media/atomisp/pci/atomisp2/hrt/device_access.c |   11 ------
 15 files changed, 12 insertions(+), 174 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hrt/isp2400_mamoiada_params.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hrt/isp2400_mamoiada_params.h
index c33d241..669060d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hrt/isp2400_mamoiada_params.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hrt/isp2400_mamoiada_params.h
@@ -177,11 +177,7 @@
 
 #define _isp_ceil_div(a,b)                     (((a)+(b)-1)/(b))
 
-#ifdef C_RUN
-#define ISP_VEC_ALIGN                          (_isp_ceil_div(ISP_VEC_WIDTH, 64)*8)
-#else
 #define ISP_VEC_ALIGN                          ISP_VMEM_ALIGN
-#endif
 
 /* HRT specific vector support */
 #define isp2400_mamoiada_vector_alignment         ISP_VEC_ALIGN
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hrt/var.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hrt/var.h
index 19b19ef..5bc0ad3 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hrt/var.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hrt/var.h
@@ -44,29 +44,6 @@
 #define HRT_HOST_TYPE(cell_type)   HRTCAT(hrt_host_type_of_, cell_type)
 #define HRT_INT_TYPE(type)         HRTCAT(hrt_int_type_of_, type)
 
-#ifdef C_RUN
-
-#ifdef C_RUN_DYNAMIC_LINK_PROGRAMS
-extern void *csim_processor_get_crun_symbol(hive_proc_id p, const char *sym);
-#define _hrt_cell_get_crun_symbol(cell,sym)          csim_processor_get_crun_symbol(cell,HRTSTR(sym))
-#define _hrt_cell_get_crun_indexed_symbol(cell,sym)  csim_processor_get_crun_symbol(cell,HRTSTR(sym))
-#else
-#define _hrt_cell_get_crun_symbol(cell,sym)         (&sym)
-#define _hrt_cell_get_crun_indexed_symbol(cell,sym) (sym)
-#endif //  C_RUN_DYNAMIC_LINK_PROGRAMS
-
-#define hrt_scalar_store(cell, type, var, data) \
-	((*(HRT_HOST_TYPE(type)*)_hrt_cell_get_crun_symbol(cell,var)) = (data))
-#define hrt_scalar_load(cell, type, var) \
-	((*(HRT_HOST_TYPE(type)*)_hrt_cell_get_crun_symbol(cell,var)))
-
-#define hrt_indexed_store(cell, type, array, index, data) \
-	((((HRT_HOST_TYPE(type)*)_hrt_cell_get_crun_indexed_symbol(cell,array))[index]) = (data))
-#define hrt_indexed_load(cell, type, array, index) \
-	(((HRT_HOST_TYPE(type)*)_hrt_cell_get_crun_indexed_symbol(cell,array))[index])
-
-#else /* C_RUN */
-
 #define hrt_scalar_store(cell, type, var, data) \
   HRTCAT(hrt_mem_store_,HRT_TYPE_BITS(cell, type))(\
 	       cell, \
@@ -93,7 +70,5 @@ extern void *csim_processor_get_crun_symbol(hive_proc_id p, const char *sym);
 	       HRTCAT(HIVE_MEM_,array), \
 	       (HRTCAT(HIVE_ADDR_,array))+((index)*HRT_TYPE_BYTES(cell, type))))
 
-#endif /* C_RUN */
-
 #endif /* _HRT_VAR_H */
 #endif
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/isp.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/isp.c
index 211c760..47c21e4 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/isp.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/isp.c
@@ -98,51 +98,32 @@ return;
 }
 
 /* ISP functions to control the ISP state from the host, even in crun. */
-#ifdef C_RUN
-volatile uint32_t isp_sleeping[N_ISP_ID] = { 0 }; /* Sleeping state per ISP */
-volatile uint32_t isp_ready   [N_ISP_ID] = { 1 }; /* Ready state per ISP */
-#endif
 
 /* Inspect readiness of an ISP indexed by ID */
 unsigned isp_is_ready(isp_ID_t ID)
 {
 	assert (ID < N_ISP_ID);
-#ifdef C_RUN
-	return isp_ready[ID];
-#else
 	return isp_ctrl_getbit(ID, ISP_SC_REG, ISP_IDLE_BIT);
-#endif
 }
 
 /* Inspect sleeping of an ISP indexed by ID */
 unsigned isp_is_sleeping(isp_ID_t ID)
 {
 	assert (ID < N_ISP_ID);
-#ifdef C_RUN
-	return isp_sleeping[ID];
-#else
 	return isp_ctrl_getbit(ID, ISP_SC_REG, ISP_SLEEPING_BIT);
-#endif
 }
 
 /* To be called by the host immediately before starting ISP ID. */
 void isp_start(isp_ID_t ID)
 {
 	assert (ID < N_ISP_ID);
-#ifdef C_RUN
-	isp_ready[ID] = 0;
-#endif
 }
 
 /* Wake up ISP ID. */
 void isp_wake(isp_ID_t ID)
 {
 	assert (ID < N_ISP_ID);
-#ifdef C_RUN
-	isp_sleeping[ID] = 0;
-#else
 	isp_ctrl_setbit(ID, ISP_SC_REG, ISP_START_BIT);
 	hrt_sleep();
-#endif
 }
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/isp_private.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/isp_private.h
index b33f94a..7f63255 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/isp_private.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/isp_private.h
@@ -21,10 +21,6 @@
 
 #include "isp_public.h"
 
-#ifdef C_RUN
-#include <string.h>		/* memcpy() */
-#endif
-
 #include "device_access.h"
 
 #include "assert_support.h"
@@ -95,9 +91,7 @@ STORAGE_CLASS_ISP_C void isp_dmem_store(
 {
 	assert(ID < N_ISP_ID);
 	assert(ISP_DMEM_BASE[ID] != (hrt_address)-1);
-#ifdef C_RUN
-	memcpy((void *)addr, data, size);
-#elif !defined(HRT_MEMORY_ACCESS)
+#if !defined(HRT_MEMORY_ACCESS)
 	ia_css_device_store(ISP_DMEM_BASE[ID] + addr, data, size);
 #else
 	hrt_master_port_store(ISP_DMEM_BASE[ID] + addr, data, size);
@@ -113,9 +107,7 @@ STORAGE_CLASS_ISP_C void isp_dmem_load(
 {
 	assert(ID < N_ISP_ID);
 	assert(ISP_DMEM_BASE[ID] != (hrt_address)-1);
-#ifdef C_RUN
-	memcpy(data, (void *)addr, size);
-#elif !defined(HRT_MEMORY_ACCESS)
+#if !defined(HRT_MEMORY_ACCESS)
 	ia_css_device_load(ISP_DMEM_BASE[ID] + addr, data, size);
 #else
 	hrt_master_port_load(ISP_DMEM_BASE[ID] + addr, data, size);
@@ -131,9 +123,7 @@ STORAGE_CLASS_ISP_C void isp_dmem_store_uint32(
 	assert(ID < N_ISP_ID);
 	assert(ISP_DMEM_BASE[ID] != (hrt_address)-1);
 	(void)ID;
-#ifdef C_RUN
-	*(uint32_t *)addr = data;
-#elif !defined(HRT_MEMORY_ACCESS)
+#if !defined(HRT_MEMORY_ACCESS)
 	ia_css_device_store_uint32(ISP_DMEM_BASE[ID] + addr, data);
 #else
 	hrt_master_port_store_32(ISP_DMEM_BASE[ID] + addr, data);
@@ -148,9 +138,7 @@ STORAGE_CLASS_ISP_C uint32_t isp_dmem_load_uint32(
 	assert(ID < N_ISP_ID);
 	assert(ISP_DMEM_BASE[ID] != (hrt_address)-1);
 	(void)ID;
-#ifdef C_RUN
-	return *(uint32_t *)addr;
-#elif !defined(HRT_MEMORY_ACCESS)
+#if !defined(HRT_MEMORY_ACCESS)
 	return ia_css_device_load_uint32(ISP_DMEM_BASE[ID] + addr);
 #else
 	return hrt_master_port_uload_32(ISP_DMEM_BASE[ID] + addr);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/sp_local.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/sp_local.h
index 59d85eb..3c70b8f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/sp_local.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/sp_local.h
@@ -44,30 +44,7 @@ struct sp_stall_s {
 	bool	icache_master;
 };
 
-#ifdef C_RUN
-#include "hive_isp_css_sp_hrt.h"
-#define sp_address_of(var)	_hrt_cell_get_crun_indexed_symbol(SP, var)
-#ifdef C_RUN_DYNAMIC_LINK_PROGRAMS
-#ifndef DUMMY_HRT_SYSMEM_FUNCTIONS
-#define DUMMY_HRT_SYSMEM_FUNCTIONS
-/* These two inline functions prevent gcc from generating compiler warnings
- * about unused static functions. */
-static inline void *
-dummy__hrt_sysmem_ident_address(hive_device_id mem, const char *sym)
-{
-	return __hrt_sysmem_ident_address(mem, sym);
-}
-
-static inline void
-dummy_hrt_sysmem_map_var(hive_mem_id mem, const char *ident, volatile void *native_address, unsigned int size)
-{
-	_hrt_sysmem_map_var(mem, ident, native_address, size);
-}
-#endif /* DUMMY_HRT_SYSMEM_FUNCTIONS */
-#endif /* C_RUN */
-#else
 #define sp_address_of(var)	(HIVE_ADDR_ ## var)
-#endif
 
 /*
  * deprecated
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/sp_private.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/sp_private.h
index 3ee9ec2..e6283bf 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/sp_private.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/sp_private.h
@@ -18,9 +18,6 @@
 #include "sp_public.h"
 
 #include "device_access.h"
-#ifdef C_RUN
-#include <string.h>	/* memcpy() */
-#endif
 
 #include "assert_support.h"
 
@@ -81,11 +78,7 @@ STORAGE_CLASS_SP_C void sp_dmem_store(
 {
 assert(ID < N_SP_ID);
 assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
-#ifndef C_RUN
 	ia_css_device_store(SP_DMEM_BASE[ID] + addr, data, size);
-#else
-	memcpy((void *)(uint32_t)addr, data, size);
-#endif
 return;
 }
 
@@ -97,11 +90,7 @@ STORAGE_CLASS_SP_C void sp_dmem_load(
 {
 assert(ID < N_SP_ID);
 assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
-#ifndef C_RUN
 	ia_css_device_load(SP_DMEM_BASE[ID] + addr, data, size);
-#else
-	memcpy(data, (void *)(uint32_t)addr, size);
-#endif
 return;
 }
 
@@ -113,11 +102,7 @@ STORAGE_CLASS_SP_C void sp_dmem_store_uint8(
 assert(ID < N_SP_ID);
 assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
 	(void)ID;
-#ifndef C_RUN
 	ia_css_device_store_uint8(SP_DMEM_BASE[SP0_ID] + addr, data);
-#else
-	*(uint8_t *)(uint32_t)addr = data;
-#endif
 return;
 }
 
@@ -129,11 +114,7 @@ STORAGE_CLASS_SP_C void sp_dmem_store_uint16(
 assert(ID < N_SP_ID);
 assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
 	(void)ID;
-#ifndef C_RUN
 	ia_css_device_store_uint16(SP_DMEM_BASE[SP0_ID] + addr, data);
-#else
-	*(uint16_t *)(uint32_t)addr = data;
-#endif
 return;
 }
 
@@ -145,11 +126,7 @@ STORAGE_CLASS_SP_C void sp_dmem_store_uint32(
 assert(ID < N_SP_ID);
 assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
 	(void)ID;
-#ifndef C_RUN
 	ia_css_device_store_uint32(SP_DMEM_BASE[SP0_ID] + addr, data);
-#else
-	*(uint32_t *)(uint32_t)addr = data;
-#endif
 return;
 }
 
@@ -160,11 +137,7 @@ STORAGE_CLASS_SP_C uint8_t sp_dmem_load_uint8(
 assert(ID < N_SP_ID);
 assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
 	(void)ID;
-#ifndef C_RUN
 	return ia_css_device_load_uint8(SP_DMEM_BASE[SP0_ID] + addr);
-#else
-	return *(uint8_t *)(uint32_t)addr;
-#endif
 }
 
 STORAGE_CLASS_SP_C uint16_t sp_dmem_load_uint16(
@@ -174,11 +147,7 @@ STORAGE_CLASS_SP_C uint16_t sp_dmem_load_uint16(
 assert(ID < N_SP_ID);
 assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
 	(void)ID;
-#ifndef C_RUN
 	return ia_css_device_load_uint16(SP_DMEM_BASE[SP0_ID] + addr);
-#else
-	return *(uint16_t *)(uint32_t)addr;
-#endif
 }
 
 STORAGE_CLASS_SP_C uint32_t sp_dmem_load_uint32(
@@ -188,11 +157,7 @@ STORAGE_CLASS_SP_C uint32_t sp_dmem_load_uint32(
 assert(ID < N_SP_ID);
 assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
 	(void)ID;
-#ifndef C_RUN
 	return ia_css_device_load_uint32(SP_DMEM_BASE[SP0_ID] + addr);
-#else
-	return *(uint32_t *)(uint32_t)addr;
-#endif
 }
 
 #endif /* __SP_PRIVATE_H_INCLUDED__ */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/vmem.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/vmem.c
index b30cceb..ea22c23 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/vmem.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/vmem.c
@@ -131,10 +131,6 @@ static void load_vector (
 {
 	unsigned i;
 	hive_uedge *data;
-#ifdef C_RUN
-	data = (hive_uedge *)from;
-	(void)ID;
-#else
 	unsigned size = sizeof(short)*ISP_NWAY;
 	VMEM_ARRAY(v, 2*ISP_NWAY); /* Need 2 vectors to work around vmem hss bug */
 	assert(ISP_BAMEM_BASE[ID] != (hrt_address)-1);
@@ -144,7 +140,6 @@ static void load_vector (
 	hrt_master_port_load(ISP_BAMEM_BASE[ID] + (unsigned long)from, &v[0][0], size);
 #endif
 	data = (hive_uedge *)v;
-#endif
 	for (i = 0; i < ISP_NWAY; i++) {
 		hive_uedge elem = 0;
 		hive_sim_wide_unpack(data, &elem, ISP_VEC_ELEMBITS, i);
@@ -159,13 +154,6 @@ static void store_vector (
 	const t_vmem_elem	*from)
 {
 	unsigned i;
-#ifdef C_RUN
-	hive_uedge *data = (hive_uedge *)to;
-	(void)ID;
-	for (i = 0; i < ISP_NWAY; i++) {
-		hive_sim_wide_pack(data, (hive_wide)&from[i], ISP_VEC_ELEMBITS, i);
-	}
-#else
 	unsigned size = sizeof(short)*ISP_NWAY;
 	VMEM_ARRAY(v, 2*ISP_NWAY); /* Need 2 vectors to work around vmem hss bug */
 	//load_vector (&v[1][0], &to[ISP_NWAY]); /* Fetch the next vector, since it will be overwritten. */
@@ -181,7 +169,6 @@ static void store_vector (
 	hrt_master_port_store(ISP_BAMEM_BASE[ID] + (unsigned long)to, &v, size);
 #endif
 	hrt_sleep(); /* Spend at least 1 cycles per vector */
-#endif
 }
 
 void isp_vmem_load(
@@ -193,9 +180,7 @@ void isp_vmem_load(
 	unsigned c;
 	const t_vmem_elem *vp = from;
 	assert(ID < N_ISP_ID);
-#ifndef C_RUN
 	assert((unsigned long)from % ISP_VEC_ALIGN == 0);
-#endif
 	assert(elems % ISP_NWAY == 0);
 	for (c = 0; c < elems; c += ISP_NWAY) {
 		load_vector(ID, &to[c], vp);
@@ -212,9 +197,7 @@ void isp_vmem_store(
 	unsigned c;
 	t_vmem_elem *vp = to;
 	assert(ID < N_ISP_ID);
-#ifndef C_RUN
 	assert((unsigned long)to % ISP_VEC_ALIGN == 0);
-#endif
 	assert(elems % ISP_NWAY == 0);
 	for (c = 0; c < elems; c += ISP_NWAY) {
 		store_vector (ID, vp, &from[c]);
@@ -234,9 +217,7 @@ void isp_vmem_2d_load (
 	unsigned h;
 
 	assert(ID < N_ISP_ID);
-#ifndef C_RUN
 	assert((unsigned long)from % ISP_VEC_ALIGN == 0);
-#endif
 	assert(width % ISP_NWAY == 0);
 	assert(stride_from % ISP_NWAY == 0);
 	for (h = 0; h < height; h++) {
@@ -262,9 +243,7 @@ void isp_vmem_2d_store (
 	unsigned h;
 
 	assert(ID < N_ISP_ID);
-#ifndef C_RUN
 	assert((unsigned long)to % ISP_VEC_ALIGN == 0);
-#endif
 	assert(width % ISP_NWAY == 0);
 	assert(stride_to % ISP_NWAY == 0);
 	for (h = 0; h < height; h++) {
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/vmem_global.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/vmem_global.h
index 5223a6e..7867cd1 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/vmem_global.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/vmem_global.h
@@ -19,11 +19,7 @@
 
 #define VMEM_SIZE	ISP_VMEM_DEPTH
 #define VMEM_ELEMBITS	ISP_VMEM_ELEMBITS
-#ifdef C_RUN
-#define VMEM_ALIGN	1
-#else
 #define VMEM_ALIGN	ISP_VMEM_ALIGN
-#endif
 
 #ifndef PIPE_GENERATION
 typedef tvector *pvector;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/assert_support.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/assert_support.h
index b763e1f..92fb15d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/assert_support.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/assert_support.h
@@ -92,16 +92,12 @@
  * The implemenation for the pipe generation tool is in see support.isp.h */
 #define OP___assert(cnd) assert(cnd)
 
-#ifdef C_RUN
-#define compile_time_assert(cond) OP___assert(cond)
-#else
 STORAGE_CLASS_INLINE void compile_time_assert (unsigned cond)
 {
 	/* Call undefined function if cond is false */
 	extern void _compile_time_assert (void);
 	if (!cond) _compile_time_assert();
 }
-#endif
 #endif /* PIPE_GENERATION */
 
 #endif /* __ASSERT_SUPPORT_H_INCLUDED__ */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c
index 30a32902..737ad66 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c
@@ -290,11 +290,7 @@ init_bufq(unsigned int desc_offset,
 	ia_css_queue_remote_t remoteq;
 
 	fw = &sh_css_sp_fw;
-#ifdef C_RUN
-	q_base_addr = (unsigned int)sp_address_of(ia_css_bufq_host_sp_queue);
-#else
 	q_base_addr = fw->info.sp.host_sp_queue;
-#endif
 
 	/* Setup queue location as SP and proc id as SP0_ID */
 	remoteq.location = IA_CSS_QUEUE_LOC_SP;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
index bb89c31..82b3593 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
@@ -177,7 +177,7 @@ void ia_css_debug_dtrace(unsigned int level, const char *fmt, ...)
 	va_end(ap);
 }
 
-#if !defined(C_RUN) && !defined(HRT_UNSCHED)
+#if !defined(HRT_UNSCHED)
 static void debug_dump_long_array_formatted(
 	const sp_ID_t sp_id,
 	hrt_address stack_sp_addr,
@@ -255,7 +255,7 @@ void ia_css_debug_dump_sp_stack_info(void)
 void ia_css_debug_dump_sp_stack_info(void)
 {
 }
-#endif /* #if !C_RUN && !HRT_UNSCHED */
+#endif /* #if !HRT_UNSCHED */
 
 
 void ia_css_debug_set_dtrace_level(const unsigned int trace_level)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c
index 0962a4b..0d2e47d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c
@@ -62,7 +62,7 @@ enum ia_css_err ia_css_spctrl_load_fw(sp_ID_t sp_id,
 
 	spctrl_cofig_info[sp_id].code_addr = mmgr_NULL;
 
-#if defined(C_RUN) || defined(HRT_UNSCHED)
+#if defined(HRT_UNSCHED)
 	(void)init_dmem_cfg;
 	code_addr = mmgr_malloc(1);
 	if (code_addr == mmgr_NULL)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 0a1544d..1b89f7f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -1589,7 +1589,7 @@ static bool sh_css_setup_blctrl_config(const struct ia_css_fw_info *fw,
 	blctrl_cfg->bl_entry = 0;
 	blctrl_cfg->program_name = (char *)(program);
 
-#if !defined(C_RUN) && !defined(HRT_UNSCHED)
+#if !defined(HRT_UNSCHED)
 	blctrl_cfg->ddr_data_offset =  fw->blob.data_source;
 	blctrl_cfg->dmem_data_addr = fw->blob.data_target;
 	blctrl_cfg->dmem_bss_addr = fw->blob.bss_target;
@@ -1616,7 +1616,7 @@ static bool sh_css_setup_spctrl_config(const struct ia_css_fw_info *fw,
 	spctrl_cfg->sp_entry = 0;
 	spctrl_cfg->program_name = (char *)(program);
 
-#if !defined(C_RUN) && !defined(HRT_UNSCHED)
+#if !defined(HRT_UNSCHED)
 	spctrl_cfg->ddr_data_offset =  fw->blob.data_source;
 	spctrl_cfg->dmem_data_addr = fw->blob.data_target;
 	spctrl_cfg->dmem_bss_addr = fw->blob.bss_target;
@@ -8678,7 +8678,7 @@ remove_firmware(struct ia_css_fw_info **l, struct ia_css_fw_info *firmware)
 	return; /* removing single and multiple firmware is handled in acc_unload_extension() */
 }
 
-#if !defined(C_RUN) && !defined(HRT_UNSCHED)
+#if !defined(HRT_UNSCHED)
 static enum ia_css_err
 upload_isp_code(struct ia_css_fw_info *firmware)
 {
@@ -8713,7 +8713,7 @@ upload_isp_code(struct ia_css_fw_info *firmware)
 static enum ia_css_err
 acc_load_extension(struct ia_css_fw_info *firmware)
 {
-#if !defined(C_RUN) && !defined(HRT_UNSCHED)
+#if !defined(HRT_UNSCHED)
 	enum ia_css_err err;
 	struct ia_css_fw_info *hd = firmware;
 	while (hd){
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
index eba96cc..fab3940 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
@@ -95,7 +95,7 @@ setup_binary(struct ia_css_fw_info *fw, const char *fw_data, struct ia_css_fw_in
 
 	*sh_css_fw = *fw;
 
-#if defined(C_RUN) || defined(HRT_UNSCHED)
+#if defined(HRT_UNSCHED)
 	sh_css_fw->blob.code = sh_css_malloc(1);
 #else
 	sh_css_fw->blob.code = sh_css_malloc(fw->blob.size);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hrt/device_access.c b/drivers/staging/media/atomisp/pci/atomisp2/hrt/device_access.c
index 1e1ac99..c870266 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hrt/device_access.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hrt/device_access.c
@@ -4,9 +4,6 @@
 #include "assert_support.h"
 
 #include <hrt/master_port.h>	/* hrt_master_port_load() */
-#ifdef C_RUN
-#include <string.h>				/* memcpy() */
-#endif
 
 /*
  * This is an HRT backend implementation for CSIM
@@ -105,11 +102,7 @@ void device_load(
 	const size_t			size)
 {
 assert(base_address != (sys_address)-1);
-#ifndef C_RUN
 	hrt_master_port_load((uint32_t)(base_address + addr), data, size);
-#else
-	memcpy(data, (void *)addr, size);
-#endif
 }
 
 void device_store(
@@ -118,10 +111,6 @@ void device_store(
 	const size_t			size)
 {
 assert(base_address != (sys_address)-1);
-#ifndef C_RUN
 	hrt_master_port_store((uint32_t)(base_address + addr), data, size);
-#else
-	memcpy((void *)addr, data, size);
-#endif
 return;
 }
