Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38571 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752282AbdDLSWg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 14:22:36 -0400
Subject: [PATCH 12/14] atomisp: remove fixedbds kernel code
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Wed, 12 Apr 2017 19:22:25 +0100
Message-ID: <149202134077.16615.9955869109062515751.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
References: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a whole pile of code that wraps a single assignment. Remove it and
put the assignment in the caller. Once we have the kernels sorted we should
revisit these and remove all the pointless 1 item structs that go with it.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../ia_css_isp_params.c                            |   11 +++--
 .../ia_css_isp_params.c                            |   11 +++--
 .../ia_css_isp_params.c                            |   11 +++--
 .../fixedbds/fixedbds_1.0/ia_css_fixedbds.host.c   |   47 --------------------
 .../fixedbds/fixedbds_1.0/ia_css_fixedbds.host.h   |   37 ----------------
 .../atomisp/pci/atomisp2/css2400/sh_css_params.c   |    2 -
 6 files changed, 19 insertions(+), 100 deletions(-)
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/fixedbds/fixedbds_1.0/ia_css_fixedbds.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/fixedbds/fixedbds_1.0/ia_css_fixedbds.host.h

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_params.c
index 3246d99..49a5cdf 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_params.c
@@ -28,7 +28,7 @@
 #include "isp/kernels/de/de_1.0/ia_css_de.host.h"
 #include "isp/kernels/de/de_2/ia_css_de2.host.h"
 #include "isp/kernels/dp/dp_1.0/ia_css_dp.host.h"
-#include "isp/kernels/fixedbds/fixedbds_1.0/ia_css_fixedbds.host.h"
+#include "isp/kernels/fixedbds/fixedbds_1.0/ia_css_fixedbds_param.h"
 #include "isp/kernels/fpn/fpn_1.0/ia_css_fpn.host.h"
 #include "isp/kernels/gc/gc_1.0/ia_css_gc.host.h"
 #include "isp/kernels/gc/gc_2/ia_css_gc2.host.h"
@@ -924,12 +924,13 @@ ia_css_process_bds(
 		unsigned offset = stage->binary->info->mem_offsets.offsets.param->dmem.bds.offset;
 
 		if (size) {
+			struct sh_css_isp_bds_params *p;
 			ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "ia_css_process_bds() enter:\n");
 
-			ia_css_bds_encode((struct sh_css_isp_bds_params *)
-					&stage->binary->mem_params.params[IA_CSS_PARAM_CLASS_PARAM][IA_CSS_ISP_DMEM].address[offset],
-					&params->bds_config,
-size);
+			p = (struct sh_css_isp_bds_params *)
+				&stage->binary->mem_params.params[IA_CSS_PARAM_CLASS_PARAM][IA_CSS_ISP_DMEM].address[offset];
+			p->baf_strength = params->bds_config.strength;
+
 			params->isp_params_changed = true;
 			params->isp_mem_params_changed[pipe_id][stage->stage_num][IA_CSS_ISP_DMEM] = true;
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_params.c
index 4c79a31..41b8a5f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_params.c
@@ -29,7 +29,7 @@
 #include "isp/kernels/de/de_1.0/ia_css_de.host.h"
 #include "isp/kernels/de/de_2/ia_css_de2.host.h"
 #include "isp/kernels/dp/dp_1.0/ia_css_dp.host.h"
-#include "isp/kernels/fixedbds/fixedbds_1.0/ia_css_fixedbds.host.h"
+#include "isp/kernels/fixedbds/fixedbds_1.0/ia_css_fixedbds_param.h"
 #include "isp/kernels/fpn/fpn_1.0/ia_css_fpn.host.h"
 #include "isp/kernels/gc/gc_1.0/ia_css_gc.host.h"
 #include "isp/kernels/gc/gc_2/ia_css_gc2.host.h"
@@ -923,12 +923,13 @@ ia_css_process_bds(
 		unsigned offset = stage->binary->info->mem_offsets.offsets.param->dmem.bds.offset;
 
 		if (size) {
+			struct sh_css_isp_bds_params *p;
 			ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "ia_css_process_bds() enter:\n");
 
-			ia_css_bds_encode((struct sh_css_isp_bds_params *)
-					&stage->binary->mem_params.params[IA_CSS_PARAM_CLASS_PARAM][IA_CSS_ISP_DMEM].address[offset],
-					&params->bds_config,
-size);
+			p = (struct sh_css_isp_bds_params *)
+				&stage->binary->mem_params.params[IA_CSS_PARAM_CLASS_PARAM][IA_CSS_ISP_DMEM].address[offset];
+			p->baf_strength = params->bds_config.strength;
+
 			params->isp_params_changed = true;
 			params->isp_mem_params_changed[pipe_id][stage->stage_num][IA_CSS_ISP_DMEM] = true;
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_params.c
index 4c79a31..41b8a5f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_params.c
@@ -29,7 +29,7 @@
 #include "isp/kernels/de/de_1.0/ia_css_de.host.h"
 #include "isp/kernels/de/de_2/ia_css_de2.host.h"
 #include "isp/kernels/dp/dp_1.0/ia_css_dp.host.h"
-#include "isp/kernels/fixedbds/fixedbds_1.0/ia_css_fixedbds.host.h"
+#include "isp/kernels/fixedbds/fixedbds_1.0/ia_css_fixedbds_param.h"
 #include "isp/kernels/fpn/fpn_1.0/ia_css_fpn.host.h"
 #include "isp/kernels/gc/gc_1.0/ia_css_gc.host.h"
 #include "isp/kernels/gc/gc_2/ia_css_gc2.host.h"
@@ -923,12 +923,13 @@ ia_css_process_bds(
 		unsigned offset = stage->binary->info->mem_offsets.offsets.param->dmem.bds.offset;
 
 		if (size) {
+			struct sh_css_isp_bds_params *p;
 			ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "ia_css_process_bds() enter:\n");
 
-			ia_css_bds_encode((struct sh_css_isp_bds_params *)
-					&stage->binary->mem_params.params[IA_CSS_PARAM_CLASS_PARAM][IA_CSS_ISP_DMEM].address[offset],
-					&params->bds_config,
-size);
+			p = (struct sh_css_isp_bds_params *)
+				&stage->binary->mem_params.params[IA_CSS_PARAM_CLASS_PARAM][IA_CSS_ISP_DMEM].address[offset];
+			p->baf_strength = params->bds_config.strength;
+
 			params->isp_params_changed = true;
 			params->isp_mem_params_changed[pipe_id][stage->stage_num][IA_CSS_ISP_DMEM] = true;
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/fixedbds/fixedbds_1.0/ia_css_fixedbds.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/fixedbds/fixedbds_1.0/ia_css_fixedbds.host.c
deleted file mode 100644
index 0ce5ace..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/fixedbds/fixedbds_1.0/ia_css_fixedbds.host.c
+++ /dev/null
@@ -1,47 +0,0 @@
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
-#include "ia_css_types.h"
-#include "sh_css_defs.h"
-#include "ia_css_debug.h"
-
-#include "ia_css_fixedbds.host.h"
-
-void
-ia_css_bds_encode(
-	struct sh_css_isp_bds_params *to,
-	const struct ia_css_aa_config *from,
-	unsigned size)
-{
-	(void)size;
-	to->baf_strength = from->strength;
-}
-
-void
-ia_css_bds_dump(
-	const struct sh_css_isp_bds_params *bds,
-	unsigned level)
-{
-	(void)bds;
-	(void)level;
-}
-
-void
-ia_css_bds_debug_dtrace(
-	const struct ia_css_aa_config *config,
-	unsigned level)
-{
-  (void)config;
-  (void)level;
-}
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/fixedbds/fixedbds_1.0/ia_css_fixedbds.host.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/fixedbds/fixedbds_1.0/ia_css_fixedbds.host.h
deleted file mode 100644
index fdc27ca..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/fixedbds/fixedbds_1.0/ia_css_fixedbds.host.h
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
-#ifndef __IA_CSS_FIXEDBDS_HOST_H
-#define __IA_CSS_FIXEDBDS_HOST_H
-
-#include "ia_css_binary.h"
-#include "ia_css_fixedbds_param.h"
-
-void
-ia_css_bds_encode(
-	struct sh_css_isp_bds_params *to,
-	const struct ia_css_aa_config *from,
-	unsigned size);
-
-void
-ia_css_bds_dump(
-	const struct sh_css_isp_bds_params *bds,
-	unsigned level);
-
-void
-ia_css_bds_debug_dtrace(
-	const struct ia_css_aa_config *config,
-	unsigned level);
-
-#endif /* __IA_CSS_FIXEDBDS_HOST_H */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
index 2807bb8..36d9177 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
@@ -75,7 +75,7 @@
 #include "ctc/ctc_1.0/ia_css_ctc.host.h"
 #include "ob/ob_1.0/ia_css_ob.host.h"
 #include "raw/raw_1.0/ia_css_raw.host.h"
-#include "fixedbds/fixedbds_1.0/ia_css_fixedbds.host.h"
+#include "fixedbds/fixedbds_1.0/ia_css_fixedbds_param.h"
 #include "s3a/s3a_1.0/ia_css_s3a.host.h"
 #include "sc/sc_1.0/ia_css_sc.host.h"
 #include "sdis/sdis_1.0/ia_css_sdis.host.h"
