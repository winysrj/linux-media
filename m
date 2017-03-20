Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9429 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753630AbdCTOmE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:42:04 -0400
Subject: [PATCH 17/24] staging/atomisp: remove sh_css_lace_stat code
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:41:38 +0000
Message-ID: <149002089704.17109.4693988717975276634.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
References: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Arnd Bergmann <arnd@arndb.de>

I ran into a build warning on my randconfig build box:

drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c: In function 'ia_css_lace_statistics_free':
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c:2845:64: error: parameter 'me' set but not used [-Werror=unused-but-set-parameter]

It turns out that not only the parameter is unused but the entire function has no
caller. Let's just remove it.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../staging/media/atomisp/pci/atomisp2/Makefile    |    1 -
 .../media/atomisp/pci/atomisp2/css2400/ia_css.h    |    1 -
 .../atomisp/pci/atomisp2/css2400/ia_css_buffer.h   |    1 -
 .../pci/atomisp2/css2400/ia_css_lace_stat.h        |   37 --------------------
 .../atomisp/pci/atomisp2/css2400/sh_css_internal.h |    1 -
 .../pci/atomisp2/css2400/sh_css_lace_stat.c        |   16 ---------
 .../atomisp/pci/atomisp2/css2400/sh_css_params.c   |   15 --------
 7 files changed, 72 deletions(-)
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_lace_stat.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_lace_stat.c

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/Makefile b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
index 162bcbf..ab10fc0 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/Makefile
+++ b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
@@ -106,7 +106,6 @@ atomisp-objs += \
 	css2400/isp/kernels/ipu2_io_ls/bayer_io_ls/ia_css_bayer_io.host.o \
 	css2400/isp/kernels/ipu2_io_ls/yuv444_io_ls/ia_css_yuv444_io.host.o \
 	css2400/isp/kernels/s3a/s3a_1.0/ia_css_s3a.host.o \
-	css2400/sh_css_lace_stat.o \
 	css2400/sh_css_pipe.o \
 	css2400/ia_css_device_access.o \
 	css2400/sh_css_host_data.o \
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css.h
index f67626f..2458b37 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css.h
@@ -42,7 +42,6 @@
 #include "ia_css_stream_format.h"
 #include "ia_css_stream_public.h"
 #include "ia_css_tpg.h"
-#include "ia_css_lace_stat.h"
 #include "ia_css_version.h"
 #include "ia_css_mmu.h"
 #include "ia_css_morph.h"
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_buffer.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_buffer.h
index 26b16f4..b2ecf36 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_buffer.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_buffer.h
@@ -60,7 +60,6 @@ struct ia_css_buffer {
 		struct ia_css_isp_3a_statistics  *stats_3a;    /**< 3A statistics & optionally RGBY statistics. */
 		struct ia_css_isp_dvs_statistics *stats_dvs;   /**< DVS statistics. */
 		struct ia_css_isp_skc_dvs_statistics *stats_skc_dvs;  /**< SKC DVS statistics. */
-		struct ia_css_isp_lace_statistics *stats_lace; /**< LACE statistics. */
 		struct ia_css_frame              *frame;       /**< Frame buffer. */
 		struct ia_css_acc_param          *custom_data; /**< Custom buffer. */
 		struct ia_css_metadata           *metadata;    /**< Sensor metadata. */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_lace_stat.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_lace_stat.h
deleted file mode 100644
index 6fee1e2..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_lace_stat.h
+++ /dev/null
@@ -1,37 +0,0 @@
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
-#ifndef __IA_CSS_LACE_STAT_H
-#define __IA_CSS_LACE_STAT_H
-
-/** @file
- * This file contains types used for LACE statistics
- */
-
-struct ia_css_isp_lace_statistics;
-
-/** @brief Allocate mem for the LACE statistics on the ISP
- * @return	Pointer to the allocated LACE statistics
- *         buffer on the ISP
-*/
-struct ia_css_isp_lace_statistics *ia_css_lace_statistics_allocate(void);
-
-/** @brief Free the ACC LACE statistics memory on the isp
- * @param[in]	me Pointer to the LACE statistics buffer on the
- *       ISP.
- * @return		None
-*/
-void ia_css_lace_statistics_free(struct ia_css_isp_lace_statistics *me);
-
-#endif /*  __IA_CSS_LACE_STAT_H */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h
index a70a72a..9a3fe2b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h
@@ -44,7 +44,6 @@
 #include "ia_css_frame_comm.h"
 #include "ia_css_3a.h"
 #include "ia_css_dvs.h"
-#include "ia_css_lace_stat.h"
 #include "ia_css_metadata.h"
 #include "runtime/bufq/interface/ia_css_bufq.h"
 #include "ia_css_timer.h"
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_lace_stat.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_lace_stat.c
deleted file mode 100644
index 850aa5e..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_lace_stat.c
+++ /dev/null
@@ -1,16 +0,0 @@
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
-/* This file will contain the code to implement the functions declared in ia_css_lace_stat.h
-   and associated helper functions */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
index 36a0c6b..2807bb8 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
@@ -1225,10 +1225,6 @@ struct ia_css_isp_skc_dvs_statistics {
 	ia_css_ptr p_data;
 };
 
-struct ia_css_isp_lace_statistics {
-	ia_css_ptr p_data;
-};
-
 static enum ia_css_err
 ref_sh_css_ddr_address_map(
 		struct sh_css_ddr_address_map *map,
@@ -2839,17 +2835,6 @@ struct ia_css_isp_skc_dvs_statistics *ia_css_skc_dvs_statistics_allocate(void)
 	return NULL;
 }
 
-void
-ia_css_lace_statistics_free(struct ia_css_isp_lace_statistics *me)
-{
-	me = NULL;
-}
-
-struct ia_css_isp_lace_statistics *ia_css_lace_statistics_allocate(void)
-{
-	return NULL;
-}
-
 struct ia_css_metadata *
 ia_css_metadata_allocate(const struct ia_css_metadata_info *metadata_info)
 {
