Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:64643 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751060AbeDPQhS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 12:37:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 1/9] media: staging: atomisp: get rid of __KERNEL macros
Date: Mon, 16 Apr 2018 12:37:04 -0400
Message-Id: <f96a01ea486411f1f23b0e3b0da501ee0eab0114.1523896259.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523896259.git.mchehab@s-opensource.com>
References: <cover.1523896259.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523896259.git.mchehab@s-opensource.com>
References: <cover.1523896259.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no sense for a Kernel driver to have __KERNEL macros
on it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../css2400/css_2401_csi2p_system/host/system_local.h     | 15 ---------------
 .../css2400/hive_isp_css_common/host/system_local.h       | 15 ---------------
 .../atomisp2/css2400/hive_isp_css_include/math_support.h  |  5 -----
 .../atomisp2/css2400/hive_isp_css_include/print_support.h |  3 ---
 .../media/atomisp/pci/atomisp2/css2400/sh_css_sp.c        |  4 ----
 5 files changed, 42 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/host/system_local.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/host/system_local.h
index c16670989702..5600b32e29f4 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/host/system_local.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/host/system_local.h
@@ -31,23 +31,8 @@
 #define HRT_ADDRESS_WIDTH	64		/* Surprise, this is a local property */
 #endif
 
-#if !defined(__KERNEL__) || (1 == 1)
 /* This interface is deprecated */
 #include "hrt/hive_types.h"
-#else  /* __KERNEL__ */
-#include <type_support.h>
-
-#if HRT_ADDRESS_WIDTH == 64
-typedef uint64_t			hrt_address;
-#elif HRT_ADDRESS_WIDTH == 32
-typedef uint32_t			hrt_address;
-#else
-#error "system_local.h: HRT_ADDRESS_WIDTH must be one of {32,64}"
-#endif
-
-typedef uint32_t			hrt_vaddress;
-typedef uint32_t			hrt_data;
-#endif /* __KERNEL__ */
 
 /*
  * Cell specific address maps
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/system_local.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/system_local.h
index 111b346dfafb..8be1cd020bf4 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/system_local.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/system_local.h
@@ -33,23 +33,8 @@
 #define HRT_ADDRESS_WIDTH	64		/* Surprise, this is a local property */
 #endif
 
-#if !defined(__KERNEL__) || (1==1)
 /* This interface is deprecated */
 #include "hrt/hive_types.h"
-#else  /* __KERNEL__ */
-#include <linux/types.h>
-
-#if HRT_ADDRESS_WIDTH==64
-typedef uint64_t			hrt_address;
-#elif HRT_ADDRESS_WIDTH==32
-typedef uint32_t			hrt_address;
-#else
-#error "system_local.h: HRT_ADDRESS_WIDTH must be one of {32,64}"
-#endif
-
-typedef uint32_t			hrt_vaddress;
-typedef uint32_t			hrt_data;
-#endif /* __KERNEL__ */
 
 /*
  * Cell specific address maps
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/math_support.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/math_support.h
index 6436dae0007e..7c52ba54fcf1 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/math_support.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/math_support.h
@@ -15,9 +15,7 @@
 #ifndef __MATH_SUPPORT_H
 #define __MATH_SUPPORT_H
 
-#if defined(__KERNEL__)
 #include <linux/kernel.h> /* Override the definition of max/min from linux kernel*/
-#endif /*__KERNEL__*/
 
 #if defined(_MSC_VER)
 #include <stdlib.h> /* Override the definition of max/min from stdlib.h*/
@@ -216,8 +214,5 @@ static inline unsigned int ceil_pow2(unsigned int a)
 #define OP_std_modadd(base, offset, size) ((base+offset)%(size))
 #endif /* !defined(__ISP) */
 
-#if !defined(__KERNEL__)
-#define clamp(a, min_val, max_val) MIN(MAX((a), (min_val)), (max_val))
-#endif /* !defined(__KERNEL__) */
 
 #endif /* __MATH_SUPPORT_H */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/print_support.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/print_support.h
index ca0fbbb57788..37e8116b74a4 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/print_support.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/print_support.h
@@ -17,9 +17,6 @@
 
 
 #include <stdarg.h>
-#if !defined(__KERNEL__)
-#include <stdio.h>
-#endif
 
 extern int (*sh_css_printf) (const char *fmt, va_list args);
 /* depends on host supplied print function in ia_css_init() */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c
index 85263725540d..cdbe914787c8 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c
@@ -1592,10 +1592,6 @@ ia_css_pipe_set_irq_mask(struct ia_css_pipe *pipe,
 	 * - compare with (uint16_t)~0 or 0xffff
 	 * - different assert for Linux and Windows
 	 */
-#ifndef __KERNEL__
-	assert(or_mask <= UINT16_MAX);
-	assert(and_mask <= UINT16_MAX);
-#endif
 
 	(void)HIVE_ADDR_host_sp_com; /* Suppres warnings in CRUN */
 
-- 
2.14.3
