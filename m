Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21244 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933734AbdCJLeH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 06:34:07 -0500
Subject: [PATCH 3/8] atomisp: remove HIVECC
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Fri, 10 Mar 2017 11:33:59 +0000
Message-ID: <148914563226.25309.2394834497801740817.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <148914560647.25309.2276061224604665212.stgit@acox1-desk1.ger.corp.intel.com>
References: <148914560647.25309.2276061224604665212.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We are only going to be building for Linux with gcc, so we can lose bits of
material related to other build targets.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../css2400/hive_isp_css_common/dma_global.h       |   52 --------------------
 .../css2400/hive_isp_css_include/assert_support.h  |    9 ---
 .../css2400/hive_isp_css_include/error_support.h   |    7 ---
 .../css2400/hive_isp_css_include/storage_class.h   |    2 -
 .../css2400/hive_isp_css_include/type_support.h    |   11 ----
 .../pci/atomisp2/css2400/ia_css_device_access.h    |    6 --
 .../css2400/isp/modes/interface/isp_const.h        |    8 ---
 .../css2400/runtime/debug/src/ia_css_debug.c       |    2 -
 .../atomisp/pci/atomisp2/css2400/sh_css_internal.h |    2 -
 9 files changed, 1 insertion(+), 98 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/dma_global.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/dma_global.h
index dff6110..60d6de1 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/dma_global.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/dma_global.h
@@ -93,38 +93,6 @@ typedef enum {
    DMA_PACK_WIDTH_B(width_b) | \
    DMA_PACK_HEIGHT(height))
 
-#ifdef __HIVECC
-#define hive_dma_move_data(dma_id, read, channel, addr_a, addr_b, to_is_var, from_is_var) \
-{ \
-  /*hive_dma_snd(dma_id, DMA_PACK_CMD_CHANNEL(read?_DMA_V2_MOVE_B2A_COMMAND:_DMA_V2_MOVE_A2B_COMMAND, channel)); \
-  hive_dma_snd(dma_id, read?(unsigned)(addr_b):(unsigned)(addr_a)); \
-  hive_dma_snd(dma_id, read?(unsigned)(addr_a):(unsigned)(addr_b)); */\
-  if (read) { \
-    hive_dma_snd(dma_id, DMA_PACK_CMD_CHANNEL(_DMA_V2_MOVE_B2A_COMMAND, channel)); \
-    hive_dma_snd(dma_id, (unsigned)(addr_b)); \
-    hive_dma_snd(dma_id, (unsigned)(addr_a)); \
-  } else { \
-    hive_dma_snd(dma_id, DMA_PACK_CMD_CHANNEL(_DMA_V2_MOVE_A2B_COMMAND, channel)); \
-    hive_dma_snd(dma_id, (unsigned)(addr_a)); \
-    hive_dma_snd(dma_id, (unsigned)(addr_b)); \
-  } \
-}
-#define hive_dma_move_data_no_ack(dma_id, read, channel, addr_a, addr_b, to_is_var, from_is_var) \
-{ \
-  /*hive_dma_snd(dma_id, DMA_PACK_CMD_CHANNEL(read?_DMA_V2_NO_ACK_MOVE_B2A_NO_SYNC_CHK_COMMAND:_DMA_V2_NO_ACK_MOVE_A2B_NO_SYNC_CHK_COMMAND, channel)); \
-  hive_dma_snd(dma_id, read?(unsigned)(addr_b):(unsigned)(addr_a)); \
-  hive_dma_snd(dma_id, read?(unsigned)(addr_a):(unsigned)(addr_b)); */\
-  if (read) { \
-    hive_dma_snd(dma_id, DMA_PACK_CMD_CHANNEL(_DMA_V2_NO_ACK_MOVE_B2A_NO_SYNC_CHK_COMMAND, channel)); \
-    hive_dma_snd(dma_id, (unsigned)(addr_b)); \
-    hive_dma_snd(dma_id, (unsigned)(addr_a)); \
-  } else { \
-    hive_dma_snd(dma_id, DMA_PACK_CMD_CHANNEL(_DMA_V2_NO_ACK_MOVE_A2B_NO_SYNC_CHK_COMMAND, channel)); \
-    hive_dma_snd(dma_id, (unsigned)(addr_a)); \
-    hive_dma_snd(dma_id, (unsigned)(addr_b)); \
-  } \
-}
-#else
 #define hive_dma_move_data(dma_id, read, channel, addr_a, addr_b, to_is_var, from_is_var) \
 { \
   hive_dma_snd(dma_id, DMA_PACK(_DMA_V2_SET_CRUN_COMMAND, CMD)); \
@@ -143,7 +111,6 @@ typedef enum {
   hive_dma_snd(dma_id, to_is_var); \
   hive_dma_snd(dma_id, from_is_var); \
 }
-#endif
 
 #define hive_dma_move_b2a_data(dma_id, channel, to_addr, from_addr, to_is_var, from_is_var) \
 { \
@@ -155,14 +122,6 @@ typedef enum {
   hive_dma_move_data(dma_id, false, channel, from_addr, to_addr, from_is_var, to_is_var) \
 }
 
-#ifdef __HIVECC
-#define hive_dma_set_data(dma_id, channel, address, value, is_var) \
-{ \
-  hive_dma_snd(dma_id, _DMA_V2_PACK_CHANNEL_CMD(_DMA_V2_INIT_A_COMMAND, channel)); \
-  hive_dma_snd(dma_id, value); \
-  hive_dma_snd(dma_id, address); \
-}
-#else
 #define hive_dma_set_data(dma_id, channel, address, value, is_var) \
 { \
   hive_dma_snd(dma_id, DMA_PACK(_DMA_V2_SET_CRUN_COMMAND, CMD)); \
@@ -171,7 +130,6 @@ typedef enum {
   hive_dma_snd(dma_id, address); \
   hive_dma_snd(dma_id, is_var); \
 }
-#endif
 
 #define hive_dma_clear_data(dma_id, channel, address, is_var) hive_dma_set_data(dma_id, channel, address, 0, is_var)
 
@@ -190,15 +148,6 @@ typedef enum {
   hive_dma_snd(dma_id, height); \
 }
 
-#ifdef __HIVECC
-/* If the command is "set" the 5th argument holds the value */
-#define hive_dma_execute(dma_id, channel, cmd, to_addr, from_addr_value, to_is_var, from_is_var) \
-{ \
-  hive_dma_snd(dma_id, DMA_PACK_CMD_CHANNEL(cmd, channel)); \
-  hive_dma_snd(dma_id, to_addr); \
-  hive_dma_snd(dma_id, from_addr_value); \
-}
-#else
 #define hive_dma_execute(dma_id, channel, cmd, to_addr, from_addr_value, to_is_var, from_is_var) \
 { \
   hive_dma_snd(dma_id, DMA_PACK(_DMA_V2_SET_CRUN_COMMAND, CMD)); \
@@ -210,7 +159,6 @@ typedef enum {
 	hive_dma_snd(dma_id, from_is_var); \
   } \
 }
-#endif
 
 #define hive_dma_configure_fast(dma_id, channel, connection, extension, elems_A, elems_B) \
 { \
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/assert_support.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/assert_support.h
index 4d68405..b763e1f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/assert_support.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/assert_support.h
@@ -61,15 +61,6 @@
 #include <assert.h>
 #endif
 
-#elif defined(__HIVECC)
-
-/* enable assert for unsched, disable assert for sched and target */
-#if defined(HRT_UNSCHED)
-#define assert(cnd) OP___csim_assert(cnd)
-#else
-#define assert(cnd) ((void)0)
-#endif
-
 #elif defined(__KERNEL__)
 #include <linux/bug.h>
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/error_support.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/error_support.h
index 46af7ec..6e5e5dd 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/error_support.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/error_support.h
@@ -29,13 +29,6 @@
 #define ENOBUFS 233
 
 
-#elif defined(__HIVECC)
-#include <errno.h>
-/*
- * Put here everything __HIVECC specific not covered in
- * "errno.h"
- */
-
 #elif defined(__KERNEL__)
 #include <linux/errno.h>
 /*
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/storage_class.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/storage_class.h
index 3812c80..3908e66 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/storage_class.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/storage_class.h
@@ -24,8 +24,6 @@
 
 #if defined(_MSC_VER)
 #define STORAGE_CLASS_INLINE static __inline
-#elif defined(__HIVECC)
-#define STORAGE_CLASS_INLINE static inline
 #else
 #define STORAGE_CLASS_INLINE static inline
 #endif
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/type_support.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/type_support.h
index 1f991bb..b82fa3e 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/type_support.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/type_support.h
@@ -49,17 +49,6 @@
 #define HOST_ADDRESS(x) (unsigned long)(x)
 #endif
 
-#elif defined(__HIVECC)
-#ifndef PIPE_GENERATION
-#include <hive/cell_support.h> /* for HAVE_STDINT */
-#endif
-#define __INDIRECT_STDINT_INCLUDE
-#include <stdint/stdint.h>
-#include <stdbool.h>
-#include <stddef.h>
-#include <limits.h>
-#define HOST_ADDRESS(x) (unsigned long)(x)
-
 #elif defined(__KERNEL__)
 
 #define CHAR_BIT (8)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_device_access.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_device_access.h
index 8e45180..59459f7 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_device_access.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_device_access.h
@@ -35,11 +35,8 @@ ia_css_device_load_uint16(const hrt_address addr);
 uint32_t
 ia_css_device_load_uint32(const hrt_address addr);
 
-/* 64 bit types not supported by hivecc */
-#ifndef __HIVECC
 uint64_t
 ia_css_device_load_uint64(const hrt_address addr);
-#endif
 
 void
 ia_css_device_store_uint8(const hrt_address addr, const uint8_t data);
@@ -50,11 +47,8 @@ ia_css_device_store_uint16(const hrt_address addr, const uint16_t data);
 void
 ia_css_device_store_uint32(const hrt_address addr, const uint32_t data);
 
-/* 64 bit types not supported by hivecc */
-#ifndef __HIVECC
 void
 ia_css_device_store_uint64(const hrt_address addr, const uint64_t data);
-#endif
 
 void
 ia_css_device_load(const hrt_address addr, void *data, const size_t size);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/modes/interface/isp_const.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/modes/interface/isp_const.h
index b3f5b78..005eaaa 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/modes/interface/isp_const.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/modes/interface/isp_const.h
@@ -35,21 +35,13 @@ more details.
 
 /* Binary independent constants */
 
-#ifdef MODE
-//#error __FILE__ "is mode independent"
-#endif
-
 #ifndef NO_HOIST
 #  define		NO_HOIST 	HIVE_ATTRIBUTE (( no_hoist ))
 #endif
 
 #define NO_HOIST_CSE HIVE_ATTRIBUTE ((no_hoist, no_cse))
 
-#ifdef __HIVECC
-#define UNION union
-#else
 #define UNION struct /* Union constructors not allowed in C++ */
-#endif
 
 /* ISP binary identifiers.
    These determine the order in which the binaries are looked up, do not change
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
index 25194eb..bb89c31 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
@@ -255,7 +255,7 @@ void ia_css_debug_dump_sp_stack_info(void)
 void ia_css_debug_dump_sp_stack_info(void)
 {
 }
-#endif /* #if __HIVECC */
+#endif /* #if !C_RUN && !HRT_UNSCHED */
 
 
 void ia_css_debug_set_dtrace_level(const unsigned int trace_level)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h
index 6dbe77c..a70a72a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h
@@ -976,7 +976,6 @@ struct host_sp_queues {
 
 extern int (*sh_css_printf)(const char *fmt, va_list args);
 
-#ifndef __HIVECC
 STORAGE_CLASS_INLINE void
 sh_css_print(const char *fmt, ...)
 {
@@ -995,7 +994,6 @@ sh_css_vprint(const char *fmt, va_list args)
 	if (sh_css_printf)
 		sh_css_printf(fmt, args);
 }
-#endif
 
 /* The following #if is there because this header file is also included
    by SP and ISP code but they do not need this data and HIVECC has alignment
