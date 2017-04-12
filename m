Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11596 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752095AbdDLSW4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 14:22:56 -0400
Subject: [PATCH 14/14] atomisp: remove UDS kernel code
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Wed, 12 Apr 2017 19:22:46 +0100
Message-ID: <149202136244.16615.14834078586870499181.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
References: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

UDS is another layer which actually boils down to some trivial assignments so
remove it so inline the code.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../ia_css_isp_params.c                            |   12 ++++---
 .../ia_css_isp_params.c                            |   12 ++++---
 .../ia_css_isp_params.c                            |   12 ++++---
 .../isp/kernels/uds/uds_1.0/ia_css_uds.host.c      |   35 --------------------
 .../isp/kernels/uds/uds_1.0/ia_css_uds.host.h      |   33 -------------------
 .../css2400/runtime/debug/src/ia_css_debug.c       |    2 +
 .../atomisp/pci/atomisp2/css2400/sh_css_params.c   |    2 +
 7 files changed, 23 insertions(+), 85 deletions(-)
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/uds/uds_1.0/ia_css_uds.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/uds/uds_1.0/ia_css_uds.host.h

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_params.c
index 49a5cdf..d418e76 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_params.c
@@ -43,7 +43,7 @@
 #include "isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.h"
 #include "isp/kernels/sdis/sdis_2/ia_css_sdis2.host.h"
 #include "isp/kernels/tnr/tnr_1.0/ia_css_tnr.host.h"
-#include "isp/kernels/uds/uds_1.0/ia_css_uds.host.h"
+#include "isp/kernels/uds/uds_1.0/ia_css_uds_param.h"
 #include "isp/kernels/wb/wb_1.0/ia_css_wb.host.h"
 #include "isp/kernels/xnr/xnr_1.0/ia_css_xnr.host.h"
 #include "isp/kernels/xnr/xnr_3.0/ia_css_xnr3.host.h"
@@ -719,12 +719,14 @@ ia_css_process_uds(
 		unsigned offset = stage->binary->info->mem_offsets.offsets.param->dmem.uds.offset;
 
 		if (size) {
+			struct sh_css_sp_uds_params *p;
 			ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "ia_css_process_uds() enter:\n");
 
-			ia_css_uds_encode((struct sh_css_sp_uds_params *)
-					&stage->binary->mem_params.params[IA_CSS_PARAM_CLASS_PARAM][IA_CSS_ISP_DMEM].address[offset],
-					&params->uds_config,
-size);
+			p = (struct sh_css_sp_uds_params *)
+				&stage->binary->mem_params.params[IA_CSS_PARAM_CLASS_PARAM][IA_CSS_ISP_DMEM].address[offset];
+			p->crop_pos = params->uds_config.crop_pos;
+			p->uds = params->uds_config.uds;
+
 			params->isp_params_changed = true;
 			params->isp_mem_params_changed[pipe_id][stage->stage_num][IA_CSS_ISP_DMEM] = true;
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_params.c
index 41b8a5f..11e4463 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_params.c
@@ -44,7 +44,7 @@
 #include "isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.h"
 #include "isp/kernels/sdis/sdis_2/ia_css_sdis2.host.h"
 #include "isp/kernels/tnr/tnr_1.0/ia_css_tnr.host.h"
-#include "isp/kernels/uds/uds_1.0/ia_css_uds.host.h"
+#include "isp/kernels/uds/uds_1.0/ia_css_uds_param.h"
 #include "isp/kernels/wb/wb_1.0/ia_css_wb.host.h"
 #include "isp/kernels/xnr/xnr_1.0/ia_css_xnr.host.h"
 #include "isp/kernels/xnr/xnr_3.0/ia_css_xnr3.host.h"
@@ -718,12 +718,14 @@ ia_css_process_uds(
 		unsigned offset = stage->binary->info->mem_offsets.offsets.param->dmem.uds.offset;
 
 		if (size) {
+			struct sh_css_sp_uds_params *p;
 			ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "ia_css_process_uds() enter:\n");
 
-			ia_css_uds_encode((struct sh_css_sp_uds_params *)
-					&stage->binary->mem_params.params[IA_CSS_PARAM_CLASS_PARAM][IA_CSS_ISP_DMEM].address[offset],
-					&params->uds_config,
-size);
+			p = (struct sh_css_sp_uds_params *)
+				&stage->binary->mem_params.params[IA_CSS_PARAM_CLASS_PARAM][IA_CSS_ISP_DMEM].address[offset];
+			p->crop_pos = params->uds_config.crop_pos;
+			p->uds = params->uds_config.uds;
+
 			params->isp_params_changed = true;
 			params->isp_mem_params_changed[pipe_id][stage->stage_num][IA_CSS_ISP_DMEM] = true;
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_params.c
index 41b8a5f..11e4463 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_params.c
@@ -44,7 +44,7 @@
 #include "isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.h"
 #include "isp/kernels/sdis/sdis_2/ia_css_sdis2.host.h"
 #include "isp/kernels/tnr/tnr_1.0/ia_css_tnr.host.h"
-#include "isp/kernels/uds/uds_1.0/ia_css_uds.host.h"
+#include "isp/kernels/uds/uds_1.0/ia_css_uds_param.h"
 #include "isp/kernels/wb/wb_1.0/ia_css_wb.host.h"
 #include "isp/kernels/xnr/xnr_1.0/ia_css_xnr.host.h"
 #include "isp/kernels/xnr/xnr_3.0/ia_css_xnr3.host.h"
@@ -718,12 +718,14 @@ ia_css_process_uds(
 		unsigned offset = stage->binary->info->mem_offsets.offsets.param->dmem.uds.offset;
 
 		if (size) {
+			struct sh_css_sp_uds_params *p;
 			ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "ia_css_process_uds() enter:\n");
 
-			ia_css_uds_encode((struct sh_css_sp_uds_params *)
-					&stage->binary->mem_params.params[IA_CSS_PARAM_CLASS_PARAM][IA_CSS_ISP_DMEM].address[offset],
-					&params->uds_config,
-size);
+			p = (struct sh_css_sp_uds_params *)
+				&stage->binary->mem_params.params[IA_CSS_PARAM_CLASS_PARAM][IA_CSS_ISP_DMEM].address[offset];
+			p->crop_pos = params->uds_config.crop_pos;
+			p->uds = params->uds_config.uds;
+
 			params->isp_params_changed = true;
 			params->isp_mem_params_changed[pipe_id][stage->stage_num][IA_CSS_ISP_DMEM] = true;
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/uds/uds_1.0/ia_css_uds.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/uds/uds_1.0/ia_css_uds.host.c
deleted file mode 100644
index 20fd68b..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/uds/uds_1.0/ia_css_uds.host.c
+++ /dev/null
@@ -1,35 +0,0 @@
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
-#include "ia_css_uds.host.h"
-
-void
-ia_css_uds_encode(
-	struct sh_css_sp_uds_params *to,
-	const struct ia_css_uds_config *from,
-	unsigned size)
-{
-	(void)size;
-	to->crop_pos = from->crop_pos;
-	to->uds      = from->uds;
-}
-
-void
-ia_css_uds_dump(
-	const struct sh_css_sp_uds_params *uds,
-	unsigned level);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/uds/uds_1.0/ia_css_uds.host.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/uds/uds_1.0/ia_css_uds.host.h
deleted file mode 100644
index 984c5bd..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/uds/uds_1.0/ia_css_uds.host.h
+++ /dev/null
@@ -1,33 +0,0 @@
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
-#ifndef __IA_CSS_UDS_HOST_H
-#define __IA_CSS_UDS_HOST_H
-
-#include "sh_css_params.h"
-
-#include "ia_css_uds_param.h"
-
-void
-ia_css_uds_encode(
-	struct sh_css_sp_uds_params *to,
-	const struct ia_css_uds_config *from,
-	unsigned size);
-
-void
-ia_css_uds_dump(
-	const struct sh_css_sp_uds_params *uds,
-	unsigned level);
-
-#endif /* __IA_CSS_UDS_HOST_H */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
index 7d64318..030810b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
@@ -95,7 +95,7 @@
 #include "s3a/s3a_1.0/ia_css_s3a.host.h"
 #include "sc/sc_1.0/ia_css_sc.host.h"
 #include "tnr/tnr_1.0/ia_css_tnr.host.h"
-#include "uds/uds_1.0/ia_css_uds.host.h"
+#include "uds/uds_1.0/ia_css_uds_param.h"
 #include "wb/wb_1.0/ia_css_wb.host.h"
 #include "ynr/ynr_1.0/ia_css_ynr.host.h"
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
index 36d9177..6674f96 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
@@ -80,7 +80,7 @@
 #include "sc/sc_1.0/ia_css_sc.host.h"
 #include "sdis/sdis_1.0/ia_css_sdis.host.h"
 #include "tnr/tnr_1.0/ia_css_tnr.host.h"
-#include "uds/uds_1.0/ia_css_uds.host.h"
+#include "uds/uds_1.0/ia_css_uds_param.h"
 #include "wb/wb_1.0/ia_css_wb.host.h"
 #include "ynr/ynr_1.0/ia_css_ynr.host.h"
 #include "xnr/xnr_1.0/ia_css_xnr.host.h"
