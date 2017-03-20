Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:65513 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753019AbdCTOjo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:39:44 -0400
Subject: [PATCH 05/24] atomisp: ia_css_bh_hmem_encode is a no-op so remove it
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:39:21 +0000
Message-ID: <149002074699.17109.16054163338277573885.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
References: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a do nothing function so we can replace it with nothing and eliminate it entirely.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../ia_css_isp_params.c                            |    6 ------
 .../ia_css_isp_params.c                            |    6 ------
 .../ia_css_isp_params.c                            |    6 ------
 .../css2400/isp/kernels/bh/bh_2/ia_css_bh.host.c   |   11 -----------
 .../css2400/isp/kernels/bh/bh_2/ia_css_bh.host.h   |    6 ------
 5 files changed, 35 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_params.c
index 9620bc3..3246d99 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_params.c
@@ -176,15 +176,9 @@ size);
 	{
 		unsigned size   = stage->binary->info->mem_offsets.offsets.param->hmem0.bh.size;
 
-		unsigned offset = stage->binary->info->mem_offsets.offsets.param->hmem0.bh.offset;
-
 		if (size) {
 			ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "ia_css_process_bh() enter:\n");
 
-			ia_css_bh_hmem_encode((struct sh_css_isp_bh_hmem_params *)
-					&stage->binary->mem_params.params[IA_CSS_PARAM_CLASS_PARAM][IA_CSS_ISP_HMEM0].address[offset],
-					&params->s3a_config,
-size);
 			params->isp_params_changed = true;
 			params->isp_mem_params_changed[pipe_id][stage->stage_num][IA_CSS_ISP_HMEM0] = true;
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_params.c
index 87a3308..4c79a31 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_params.c
@@ -175,15 +175,9 @@ size);
 	{
 		unsigned size   = stage->binary->info->mem_offsets.offsets.param->hmem0.bh.size;
 
-		unsigned offset = stage->binary->info->mem_offsets.offsets.param->hmem0.bh.offset;
-
 		if (size) {
 			ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "ia_css_process_bh() enter:\n");
 
-			ia_css_bh_hmem_encode((struct sh_css_isp_bh_hmem_params *)
-					&stage->binary->mem_params.params[IA_CSS_PARAM_CLASS_PARAM][IA_CSS_ISP_HMEM0].address[offset],
-					&params->s3a_config,
-size);
 			params->isp_params_changed = true;
 			params->isp_mem_params_changed[pipe_id][stage->stage_num][IA_CSS_ISP_HMEM0] = true;
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_params.c
index 87a3308..4c79a31 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_params.c
@@ -175,15 +175,9 @@ size);
 	{
 		unsigned size   = stage->binary->info->mem_offsets.offsets.param->hmem0.bh.size;
 
-		unsigned offset = stage->binary->info->mem_offsets.offsets.param->hmem0.bh.offset;
-
 		if (size) {
 			ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "ia_css_process_bh() enter:\n");
 
-			ia_css_bh_hmem_encode((struct sh_css_isp_bh_hmem_params *)
-					&stage->binary->mem_params.params[IA_CSS_PARAM_CLASS_PARAM][IA_CSS_ISP_HMEM0].address[offset],
-					&params->s3a_config,
-size);
 			params->isp_params_changed = true;
 			params->isp_mem_params_changed[pipe_id][stage->stage_num][IA_CSS_ISP_HMEM0] = true;
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bh/bh_2/ia_css_bh.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bh/bh_2/ia_css_bh.host.c
index 0dcafad..99c80d2 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bh/bh_2/ia_css_bh.host.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bh/bh_2/ia_css_bh.host.c
@@ -63,15 +63,4 @@ ia_css_bh_encode(
 	    uDIGIT_FITTING(from->ae_y_coef_b, 16, SH_CSS_AE_YCOEF_SHIFT);
 }
 
-void
-ia_css_bh_hmem_encode(
-	struct sh_css_isp_bh_hmem_params *to,
-	const struct ia_css_3a_config *from,
-	unsigned size)
-{
-	(void)size;
-	(void)from;
-	(void)to;
-}
-
 #endif
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bh/bh_2/ia_css_bh.host.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bh/bh_2/ia_css_bh.host.h
index 339e954..cbb0929 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bh/bh_2/ia_css_bh.host.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bh/bh_2/ia_css_bh.host.h
@@ -29,10 +29,4 @@ ia_css_bh_encode(
 	const struct ia_css_3a_config *from,
 	unsigned size);
 
-void
-ia_css_bh_hmem_encode(
-	struct sh_css_isp_bh_hmem_params *to,
-	const struct ia_css_3a_config *from,
-	unsigned size);
-
 #endif /* __IA_CSS_BH_HOST_H */
