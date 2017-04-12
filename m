Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:19384 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755181AbdDLSV1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 14:21:27 -0400
Subject: [PATCH 07/14] atomisp: unwrap the _ex malloc/free functions
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Wed, 12 Apr 2017 19:21:22 +0100
Message-ID: <149202127255.16615.7881549692960927512.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
References: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We are not using these for debugging or debug logging so remove the defines,
trim and rename the functions.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |   15 +++------------
 .../atomisp/pci/atomisp2/css2400/sh_css_internal.h |   17 ++++-------------
 2 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 7e337e0..aa19419 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -2015,34 +2015,25 @@ ia_css_enable_isys_event_queue(bool enable)
 	return IA_CSS_SUCCESS;
 }
 
-void *
-sh_css_malloc_ex(size_t size, const char *caller_func, int caller_line)
+void *sh_css_malloc(size_t size)
 {
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "sh_css_malloc() enter: size=%d\n",size);
-	(void)caller_func;
-	(void)caller_line;
 	if (size > 0 && my_css.malloc)
 		return my_css.malloc(size, false);
 	return NULL;
 }
 
-void *
-sh_css_calloc_ex(size_t N, size_t size, const char *caller_func, int caller_line)
+void *sh_css_calloc(size_t N, size_t size)
 {
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "sh_css_calloc() enter: N=%d, size=%d\n",N,size);
-	(void)caller_func;
-	(void)caller_line;
 	if (size > 0 && my_css.malloc)
 		return my_css.malloc(N*size, true);		
 	return NULL;
 }
 
-void
-sh_css_free_ex(void *ptr, const char *caller_func, int caller_line)
+void sh_css_free(void *ptr)
 {
 	IA_CSS_ENTER_PRIVATE("ptr = %p", ptr);
-	(void)caller_func;
-	(void)caller_line;
 	if (ptr && my_css.free)
 		my_css.free(ptr);
 	IA_CSS_LEAVE_PRIVATE("void");
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h
index a108923..e2b6f06 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h
@@ -1002,23 +1002,14 @@ sh_css_params_init(void);
 void
 sh_css_params_uninit(void);
 
-#define sh_css_malloc(size) sh_css_malloc_ex(size, __func__, __LINE__)
-#define sh_css_calloc(N, size) sh_css_calloc_ex(N, size, __func__, __LINE__)
-#define sh_css_free(ptr) sh_css_free_ex(ptr, __func__, __LINE__)
+void *sh_css_malloc(size_t size);
 
+void *sh_css_calloc(size_t N, size_t size);
 
-void *
-sh_css_malloc_ex(size_t size, const char *caller_func, int caller_line);
-
-void *
-sh_css_calloc_ex(size_t N, size_t size, const char *caller_func, int caller_lin);
-
-void
-sh_css_free_ex(void *ptr, const char *caller_func, int caller_line);
+void sh_css_free(void *ptr);
 
 /* For Acceleration API: Flush FW (shared buffer pointer) arguments */
-void
-sh_css_flush(struct ia_css_acc_fw *fw);
+void sh_css_flush(struct ia_css_acc_fw *fw);
 
 
 void
