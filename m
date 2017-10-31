Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:47385 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752369AbdJaQE2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 12:04:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 5/7] media: atomisp: get rid of wrong stddef.h include
Date: Tue, 31 Oct 2017 12:04:18 -0400
Message-Id: <d2e59b395d3ed98c9e3fefc0ac6ae95a0a0fb74c.1509465351.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1509465351.git.mchehab@s-opensource.com>
References: <cover.1509465351.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1509465351.git.mchehab@s-opensource.com>
References: <cover.1509465351.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The places at atomisp.h that use stddef.h are wrong: the
types it needs are actually defined at linux/types.h. Also,
it causes lots of smatch warnings due to the redefinition of
ofsetof() macro:

/opt/gcc-7.1.0/x86/lib/gcc/x86_64-pc-linux-gnu/7.1.0/include/stddef.h:417:9: warning: preprocessor token offsetof redefined
./include/linux/stddef.h:16:9: this was the original definition

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../css2400/hive_isp_css_common/host/dma.c         |  2 +-
 .../hive_isp_css_include/host/hmem_public.h        |  4 +--
 .../css2400/hive_isp_css_include/type_support.h    | 42 ----------------------
 3 files changed, 3 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/dma.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/dma.c
index 87a25d4289ec..770db7dff5d3 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/dma.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/dma.c
@@ -12,7 +12,7 @@
  * more details.
  */
 
-#include <stddef.h>		/* NULL */
+#include <linux/kernel.h>
 
 #include "dma.h"
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/hmem_public.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/hmem_public.h
index 9b8e7c92442d..8538f86ab5e6 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/hmem_public.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/hmem_public.h
@@ -15,10 +15,10 @@
 #ifndef __HMEM_PUBLIC_H_INCLUDED__
 #define __HMEM_PUBLIC_H_INCLUDED__
 
-#include <stddef.h>		/* size_t */
+#include <linux/types.h>		/* size_t */
 
 /*! Return the size of HMEM[ID]
- 
+
  \param	ID[in]				HMEM identifier
 
  \Note: The size is the byte size of the area it occupies
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/type_support.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/type_support.h
index b82fa3eba79f..bc77537fa73a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/type_support.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/type_support.h
@@ -30,27 +30,6 @@
 #define IA_CSS_INT32_T_BITS						32
 #define IA_CSS_UINT64_T_BITS					64
 
-#if defined(_MSC_VER)
-#include <stdint.h>
-/* For ATE compilation define the bool */
-#if defined(_ATE_)
-#define bool int
-#define true 1
-#define false 0
-#else
-#include <stdbool.h>
-#endif
-#include <stddef.h>
-#include <limits.h>
-#include <errno.h>
-#if defined(_M_X64)
-#define HOST_ADDRESS(x) (unsigned long long)(x)
-#else
-#define HOST_ADDRESS(x) (unsigned long)(x)
-#endif
-
-#elif defined(__KERNEL__)
-
 #define CHAR_BIT (8)
 
 #include <linux/types.h>
@@ -58,25 +37,4 @@
 #include <linux/errno.h>
 #define HOST_ADDRESS(x) (unsigned long)(x)
 
-#elif defined(__GNUC__)
-#ifndef __STDC_LIMIT_MACROS
-#define __STDC_LIMIT_MACROS 1
-#endif
-#include <stdint.h>
-#include <stdbool.h>
-#include <stddef.h>
-#include <limits.h>
-#include <errno.h>
-#define HOST_ADDRESS(x) (unsigned long)(x)
-
-#else /* default is for the FIST environment */
-#include <stdint.h>
-#include <stdbool.h>
-#include <stddef.h>
-#include <limits.h>
-#include <errno.h>
-#define HOST_ADDRESS(x) (unsigned long)(x)
-
-#endif
-
 #endif /* __TYPE_SUPPORT_H_INCLUDED__ */
-- 
2.13.6
