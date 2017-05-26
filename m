Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:38436 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1035629AbdEZP3w (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 11:29:52 -0400
Subject: [PATCH 11/11] atomisp: de-duplicate
 sh_css_mmu_set_page_table_base_index
From: Alan Cox <alan@llwyncelyn.cymru>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Date: Fri, 26 May 2017 16:29:48 +0100
Message-ID: <149581258243.17585.12872560475108453102.stgit@builder>
In-Reply-To: <149581243155.17585.8164899156710160858.stgit@builder>
References: <149581243155.17585.8164899156710160858.stgit@builder>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Between the ISP2400 and ISP2401 code base this function moved file. The merge
of the drivers left us with two version in ifdefs. Resolve this down to a
single copy.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../pci/atomisp2/css2400/ia_css_mmu_private.h      |    2 --
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |   24 +-------------------
 .../atomisp/pci/atomisp2/css2400/sh_css_mmu.c      |    6 -----
 3 files changed, 1 insertion(+), 31 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_mmu_private.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_mmu_private.h
index 7c85009..1021e4f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_mmu_private.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_mmu_private.h
@@ -1,4 +1,3 @@
-#ifdef ISP2401
 /*
  * Support for Intel Camera Imaging ISP subsystem.
  * Copyright (c) 2015, Intel Corporation.
@@ -28,4 +27,3 @@ void
 sh_css_mmu_set_page_table_base_index(hrt_data base_index);
 
 #endif /* __IA_CSS_MMU_PRIVATE_H */
-#endif
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index dfef219..471f2be 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -64,7 +64,7 @@
 #include "input_system.h"
 #endif
 #include "mmu_device.h"		/* mmu_set_page_table_base_index(), ... */
-//#include "ia_css_mmu_private.h" /* sh_css_mmu_set_page_table_base_index() */
+#include "ia_css_mmu_private.h" /* sh_css_mmu_set_page_table_base_index() */
 #include "gdc_device.h"		/* HRT_GDC_N */
 #include "dma.h"		/* dma_set_max_burst_size() */
 #include "irq.h"			/* virq */
@@ -242,11 +242,6 @@ ia_css_reset_defaults(struct sh_css* css);
 static void
 sh_css_init_host_sp_control_vars(void);
 
-#ifndef ISP2401
-static void
-sh_css_mmu_set_page_table_base_index(hrt_data base_index);
-
-#endif
 static enum ia_css_err set_num_primary_stages(unsigned int *num, enum ia_css_pipe_version version);
 
 static bool
@@ -2595,23 +2590,6 @@ ia_css_uninit(void)
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "ia_css_uninit() leave: return_void\n");
 }
 
-#ifndef ISP2401
-/* Deprecated, this is an HRT backend function (memory_access.h) */
-static void
-sh_css_mmu_set_page_table_base_index(hrt_data base_index)
-{
-	int i;
-	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "sh_css_mmu_set_page_table_base_index() enter: base_index=0x%08x\n",base_index);
-	my_css.page_table_base_index = base_index;
-	for (i = 0; i < (int)N_MMU_ID; i++) {
-		mmu_ID_t mmu_id = (mmu_ID_t)i;
-		mmu_set_page_table_base_index(mmu_id, base_index);
-		mmu_invalidate_cache(mmu_id);
-	}
-	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "sh_css_mmu_set_page_table_base_index() leave: return_void\n");
-}
-
-#endif
 #if defined(HAS_IRQ_MAP_VERSION_2)
 enum ia_css_err ia_css_irq_translate(
 	unsigned int *irq_infos)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_mmu.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_mmu.c
index 6de8472..237e38b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_mmu.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_mmu.c
@@ -13,16 +13,12 @@
  */
 
 #include "ia_css_mmu.h"
-#ifdef ISP2401
 #include "ia_css_mmu_private.h"
-#endif
 #include <ia_css_debug.h>
 #include "sh_css_sp.h"
 #include "sh_css_firmware.h"
 #include "sp.h"
-#ifdef ISP2401
 #include "mmu_device.h"
-#endif
 
 void
 ia_css_mmu_invalidate_cache(void)
@@ -44,7 +40,6 @@ ia_css_mmu_invalidate_cache(void)
 	}
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "ia_css_mmu_invalidate_cache() leave\n");
 }
-#ifdef ISP2401
 
 /* Deprecated, this is an HRT backend function (memory_access.h) */
 void
@@ -59,4 +54,3 @@ sh_css_mmu_set_page_table_base_index(hrt_data base_index)
 	}
 	IA_CSS_LEAVE_PRIVATE("");
 }
-#endif
