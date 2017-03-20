Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20525 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755098AbdCTOim (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:38:42 -0400
Subject: [PATCH 02/24] atomisp: remove aa kernel wrappers
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:38:27 +0000
Message-ID: <149002070224.17109.5750931103737656945.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
References: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The aa kernel is used but it consists of nothing more than a set of wrappers
for a memset and an assignment. Replace these at the calling points with the
memset and assignment.

Keep the structures for now - those should disappear as the next layer up
gets unwrapped.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../ia_css_isp_params.c                            |   29 +++++------------
 .../ia_css_isp_states.c                            |    7 +---
 .../ia_css_isp_params.c                            |   27 ++++------------
 .../ia_css_isp_states.c                            |    8 +----
 .../ia_css_isp_params.c                            |   27 ++++------------
 .../ia_css_isp_states.c                            |    8 +----
 .../css2400/isp/kernels/aa/aa_2/ia_css_aa2.host.c  |   34 --------------------
 .../css2400/isp/kernels/aa/aa_2/ia_css_aa2.host.h  |   23 --------------
 .../atomisp/pci/atomisp2/css2400/sh_css_params.c   |    2 -
 9 files changed, 26 insertions(+), 139 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_params.c
index 8a35750..9620bc3 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_params.c
@@ -70,27 +70,16 @@ ia_css_process_aa(
 	const struct ia_css_pipeline_stage *stage,
 	struct ia_css_isp_parameters *params)
 {
-	assert(params != NULL);
-
-	{
-		unsigned size   = stage->binary->info->mem_offsets.offsets.param->dmem.aa.size;
-
-		unsigned offset = stage->binary->info->mem_offsets.offsets.param->dmem.aa.offset;
-
-		if (size) {
-			ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "ia_css_process_aa() enter:\n");
-
-			ia_css_aa_encode((struct sh_css_isp_aa_params *)
-					&stage->binary->mem_params.params[IA_CSS_PARAM_CLASS_PARAM][IA_CSS_ISP_DMEM].address[offset],
-					&params->aa_config,
-size);
-			params->isp_params_changed = true;
-			params->isp_mem_params_changed[pipe_id][stage->stage_num][IA_CSS_ISP_DMEM] = true;
-
-			ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "ia_css_process_aa() leave:\n");
-		}
+	unsigned size   = stage->binary->info->mem_offsets.offsets.param->dmem.aa.size;
+	unsigned offset = stage->binary->info->mem_offsets.offsets.param->dmem.aa.offset;
 
+	if (size) {
+		struct sh_css_isp_aa_params *t =  (struct sh_css_isp_aa_params *)
+				&stage->binary->mem_params.params[IA_CSS_PARAM_CLASS_PARAM][IA_CSS_ISP_DMEM].address[offset];
+		t->strength = params->aa_config.strength;
 	}
+	params->isp_params_changed = true;
+	params->isp_mem_params_changed[pipe_id][stage->stage_num][IA_CSS_ISP_DMEM] = true;
 }
 
 /* Code generated by genparam/gencode.c:gen_process_function() */
@@ -2214,7 +2203,6 @@ ia_css_get_aa_config(const struct ia_css_isp_parameters *params,
 	*config = params->aa_config;
 
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "ia_css_get_aa_config() leave\n");
-	ia_css_aa_debug_dtrace(config, IA_CSS_DEBUG_TRACE);
 }
 
 /* Code generated by genparam/gencode.c:gen_set_function() */
@@ -2228,7 +2216,6 @@ ia_css_set_aa_config(struct ia_css_isp_parameters *params,
 
 	assert(params != NULL);
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "ia_css_set_aa_config() enter:\n");
-	ia_css_aa_debug_dtrace(config, IA_CSS_DEBUG_TRACE);
 	params->aa_config = *config;
 	params->config_changed[IA_CSS_AA_ID] = true;
 #ifndef ISP2401
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_states.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_states.c
index 471ceba..fb3ba08 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_states.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_states.c
@@ -31,11 +31,8 @@ ia_css_initialize_aa_state(
 
 		unsigned offset = binary->info->mem_offsets.offsets.state->vmem.aa.offset;
 
-		if (size) {
-			ia_css_init_aa_state(
-				&binary->mem_params.params[IA_CSS_PARAM_CLASS_STATE][IA_CSS_ISP_VMEM].address[offset],
-				size);
-		}
+		if (size)
+			memset(&binary->mem_params.params[IA_CSS_PARAM_CLASS_STATE][IA_CSS_ISP_VMEM].address[offset], 0, size);
 
 	}
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "ia_css_initialize_aa_state() leave:\n");
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_params.c
index 2672137..87a3308 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_params.c
@@ -71,26 +71,13 @@ ia_css_process_aa(
 	const struct ia_css_pipeline_stage *stage,
 	struct ia_css_isp_parameters *params)
 {
-	assert(params != NULL);
-
-	{
-		unsigned size   = stage->binary->info->mem_offsets.offsets.param->dmem.aa.size;
-
-		unsigned offset = stage->binary->info->mem_offsets.offsets.param->dmem.aa.offset;
-
-		if (size) {
-			ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "ia_css_process_aa() enter:\n");
-
-			ia_css_aa_encode((struct sh_css_isp_aa_params *)
-					&stage->binary->mem_params.params[IA_CSS_PARAM_CLASS_PARAM][IA_CSS_ISP_DMEM].address[offset],
-					&params->aa_config,
-size);
-			params->isp_params_changed = true;
-			params->isp_mem_params_changed[pipe_id][stage->stage_num][IA_CSS_ISP_DMEM] = true;
-
-			ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "ia_css_process_aa() leave:\n");
-		}
+	unsigned size   = stage->binary->info->mem_offsets.offsets.param->dmem.aa.size;
+	unsigned offset = stage->binary->info->mem_offsets.offsets.param->dmem.aa.offset;
 
+	if (size) {
+		struct sh_css_isp_aa_params *t =  (struct sh_css_isp_aa_params *)
+			&stage->binary->mem_params.params[IA_CSS_PARAM_CLASS_PARAM][IA_CSS_ISP_DMEM].address[offset];
+		t->strength = params->aa_config.strength;
 	}
 }
 
@@ -2215,7 +2202,6 @@ ia_css_get_aa_config(const struct ia_css_isp_parameters *params,
 	*config = params->aa_config;
 
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "ia_css_get_aa_config() leave\n");
-	ia_css_aa_debug_dtrace(config, IA_CSS_DEBUG_TRACE);
 }
 
 /* Code generated by genparam/gencode.c:gen_set_function() */
@@ -2229,7 +2215,6 @@ ia_css_set_aa_config(struct ia_css_isp_parameters *params,
 
 	assert(params != NULL);
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "ia_css_set_aa_config() enter:\n");
-	ia_css_aa_debug_dtrace(config, IA_CSS_DEBUG_TRACE);
 	params->aa_config = *config;
 	params->config_changed[IA_CSS_AA_ID] = true;
 #ifndef ISP2401
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_states.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_states.c
index a445d4f..e87d05b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_states.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_states.c
@@ -29,14 +29,10 @@ ia_css_initialize_aa_state(
 
 	{
 		unsigned size   = binary->info->mem_offsets.offsets.state->vmem.aa.size;
-
 		unsigned offset = binary->info->mem_offsets.offsets.state->vmem.aa.offset;
 
-		if (size) {
-			ia_css_init_aa_state(
-				&binary->mem_params.params[IA_CSS_PARAM_CLASS_STATE][IA_CSS_ISP_VMEM].address[offset],
-				size);
-		}
+		if (size)
+			memset(&binary->mem_params.params[IA_CSS_PARAM_CLASS_STATE][IA_CSS_ISP_VMEM].address[offset], 0, size);
 
 	}
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "ia_css_initialize_aa_state() leave:\n");
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_params.c
index 2672137..87a3308 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_params.c
@@ -71,26 +71,13 @@ ia_css_process_aa(
 	const struct ia_css_pipeline_stage *stage,
 	struct ia_css_isp_parameters *params)
 {
-	assert(params != NULL);
-
-	{
-		unsigned size   = stage->binary->info->mem_offsets.offsets.param->dmem.aa.size;
-
-		unsigned offset = stage->binary->info->mem_offsets.offsets.param->dmem.aa.offset;
-
-		if (size) {
-			ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "ia_css_process_aa() enter:\n");
-
-			ia_css_aa_encode((struct sh_css_isp_aa_params *)
-					&stage->binary->mem_params.params[IA_CSS_PARAM_CLASS_PARAM][IA_CSS_ISP_DMEM].address[offset],
-					&params->aa_config,
-size);
-			params->isp_params_changed = true;
-			params->isp_mem_params_changed[pipe_id][stage->stage_num][IA_CSS_ISP_DMEM] = true;
-
-			ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "ia_css_process_aa() leave:\n");
-		}
+	unsigned size   = stage->binary->info->mem_offsets.offsets.param->dmem.aa.size;
+	unsigned offset = stage->binary->info->mem_offsets.offsets.param->dmem.aa.offset;
 
+	if (size) {
+		struct sh_css_isp_aa_params *t =  (struct sh_css_isp_aa_params *)
+			&stage->binary->mem_params.params[IA_CSS_PARAM_CLASS_PARAM][IA_CSS_ISP_DMEM].address[offset];
+		t->strength = params->aa_config.strength;
 	}
 }
 
@@ -2215,7 +2202,6 @@ ia_css_get_aa_config(const struct ia_css_isp_parameters *params,
 	*config = params->aa_config;
 
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "ia_css_get_aa_config() leave\n");
-	ia_css_aa_debug_dtrace(config, IA_CSS_DEBUG_TRACE);
 }
 
 /* Code generated by genparam/gencode.c:gen_set_function() */
@@ -2229,7 +2215,6 @@ ia_css_set_aa_config(struct ia_css_isp_parameters *params,
 
 	assert(params != NULL);
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "ia_css_set_aa_config() enter:\n");
-	ia_css_aa_debug_dtrace(config, IA_CSS_DEBUG_TRACE);
 	params->aa_config = *config;
 	params->config_changed[IA_CSS_AA_ID] = true;
 #ifndef ISP2401
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_states.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_states.c
index a445d4f..e87d05b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_states.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_states.c
@@ -29,14 +29,10 @@ ia_css_initialize_aa_state(
 
 	{
 		unsigned size   = binary->info->mem_offsets.offsets.state->vmem.aa.size;
-
 		unsigned offset = binary->info->mem_offsets.offsets.state->vmem.aa.offset;
 
-		if (size) {
-			ia_css_init_aa_state(
-				&binary->mem_params.params[IA_CSS_PARAM_CLASS_STATE][IA_CSS_ISP_VMEM].address[offset],
-				size);
-		}
+		if (size)
+			memset(&binary->mem_params.params[IA_CSS_PARAM_CLASS_STATE][IA_CSS_ISP_VMEM].address[offset], 0, size);
 
 	}
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "ia_css_initialize_aa_state() leave:\n");
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/aa/aa_2/ia_css_aa2.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/aa/aa_2/ia_css_aa2.host.c
index 942ebe0..f7dd256 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/aa/aa_2/ia_css_aa2.host.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/aa/aa_2/ia_css_aa2.host.c
@@ -30,37 +30,3 @@ const struct ia_css_aa_config default_baa_config = {
 	8191 /* default should be 0 */
 };
 
-void
-ia_css_aa_encode(
-	struct sh_css_isp_aa_params *to,
-	const struct ia_css_aa_config *from,
-	unsigned size)
-{
-	(void)size;
-	to->strength = from->strength;
-}
-
-void
-ia_css_init_aa_state(
-	void *state,
-	size_t size)
-{
-	memset(state, 0, size);
-}
-
-#ifndef IA_CSS_NO_DEBUG
-void
-ia_css_aa_dump(
-	const struct sh_css_isp_aa_params *aa,
-	unsigned level);
-
-void
-ia_css_aa_debug_dtrace(
-	const struct ia_css_aa_config *config,
-	unsigned level)
-{
-	ia_css_debug_dtrace(level,
-		"config.strength=%d\n",
-		config->strength);
-}
-#endif /* IA_CSS_NO_DEBUG */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/aa/aa_2/ia_css_aa2.host.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/aa/aa_2/ia_css_aa2.host.h
index c3785e0..71587d8 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/aa/aa_2/ia_css_aa2.host.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/aa/aa_2/ia_css_aa2.host.h
@@ -24,27 +24,4 @@ extern const struct ia_css_aa_config default_aa_config;
 /* Bayer Anti-Aliasing configuration. */
 extern const struct ia_css_aa_config default_baa_config;
 
-void
-ia_css_aa_encode(
-	struct sh_css_isp_aa_params *to,
-	const struct ia_css_aa_config *from,
-	unsigned size);
-
-void
-ia_css_init_aa_state(
-	void *state,
-	size_t size);
-
-#ifndef IA_CSS_NO_DEBUG
-void
-ia_css_aa_dump(
-	const struct sh_css_isp_aa_params *aa,
-	unsigned level);
-
-void
-ia_css_aa_debug_dtrace(
-	const struct ia_css_aa_config *config,
-	unsigned level);
-#endif /* IA_CSS_NO_DEBUG */
-
 #endif /* __IA_CSS_AA_HOST_H */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
index 9d51f1c..e4599f7 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
@@ -2326,7 +2326,6 @@ sh_css_set_baa_config(struct ia_css_isp_parameters *params,
 	assert(params != NULL);
 
 	IA_CSS_ENTER_PRIVATE("config=%p", config);
-	ia_css_aa_debug_dtrace(config, IA_CSS_DEBUG_TRACE);
 
 	params->bds_config = *config;
 	params->config_changed[IA_CSS_BDS_ID] = true;
@@ -2346,7 +2345,6 @@ sh_css_get_baa_config(const struct ia_css_isp_parameters *params,
 
 	*config = params->bds_config;
 
-	ia_css_aa_debug_dtrace(config, IA_CSS_DEBUG_TRACE);
 	IA_CSS_LEAVE_PRIVATE("void");
 }
 
