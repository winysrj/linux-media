Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16636 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933595AbdCJLdx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 06:33:53 -0500
Subject: [PATCH 2/8] atomisp: remove unused code and unify a header
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Fri, 10 Mar 2017 11:33:45 +0000
Message-ID: <148914562054.25309.14661265320713382193.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <148914560647.25309.2276061224604665212.stgit@acox1-desk1.ger.corp.intel.com>
References: <148914560647.25309.2276061224604665212.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

KLOCWORK is never defined so we can remove the workarounds for this in the
code.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../css2400/hive_isp_css_include/assert_support.h  |   11 -------
 .../atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c  |   32 +-------------------
 2 files changed, 1 insertion(+), 42 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/assert_support.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/assert_support.h
index 95f3892..4d68405 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/assert_support.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/assert_support.h
@@ -17,17 +17,6 @@
 
 #include "storage_class.h"
 
-#ifdef __KLOCWORK__
-/* Klocwork does not see that assert will lead to abortion
- * as there is no good way to tell this to KW and the code
- * should not depend on assert to function (actually the assert
- * could be disabled in a release build) it was decided to
- * disable the assert for KW scans (by defining NDEBUG)
- * see also: http://www.klocwork.com/products/documentation/current/Tuning_C/C%2B%2B_analysis#Assertions
- */
-#define NDEBUG
-#endif /* __KLOCWORK__ */
-
 /**
  * The following macro can help to test the size of a struct at compile
  * time rather than at run-time. It does not work for all compilers; see
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c
index dc30e7c..3aafc0a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c
@@ -1,7 +1,6 @@
-#ifndef ISP2401
 /*
  * Support for Intel Camera Imaging ISP subsystem.
- * Copyright (c) 2015, Intel Corporation.
+ * Copyright (c) 2010-2015, Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -12,21 +11,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  */
-#else
-/**
-Support for Intel Camera Imaging ISP subsystem.
-Copyright (c) 2010 - 2015, Intel Corporation.
-
-This program is free software; you can redistribute it and/or modify it
-under the terms and conditions of the GNU General Public License,
-version 2, as published by the Free Software Foundation.
-
-This program is distributed in the hope it will be useful, but WITHOUT
-ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
-FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
-more details.
-*/
-#endif
 
 #include "ia_css_rmgr.h"
 
@@ -279,21 +263,7 @@ void rmgr_pop_handle(struct ia_css_rmgr_vbuf_pool *pool,
 void ia_css_rmgr_acq_vbuf(struct ia_css_rmgr_vbuf_pool *pool,
 			  struct ia_css_rmgr_vbuf_handle **handle)
 {
-#ifdef __KLOCWORK__
-	/* KW sees the *handle = h; assignment about 20 lines down
-	   and thinks that we are assigning a local to a global.
-	   What it does not see is that in ia_css_i_host_rmgr_pop_handle
-	   a new value is assigned to handle.
-	   So this is a false positive KW issue.
-	   To fix that we make the struct static for KW so it will
-	   think that h remains alive; we do not want this in our
-	   production code though as it breaks reentrancy of the code
-	 */
-
-	static struct ia_css_rmgr_vbuf_handle h;
-#else /* __KLOCWORK__ */
 	struct ia_css_rmgr_vbuf_handle h;
-#endif /* __KLOCWORK__ */
 
 	if ((pool == NULL) || (handle == NULL) || (*handle == NULL)) {
 		IA_CSS_LOG("Invalid inputs");
