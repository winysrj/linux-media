Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:38400 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933683AbdEZP1n (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 11:27:43 -0400
Subject: [PATCHv2 03/11] atomisp2: remove HRT_UNSCHED
From: Alan Cox <alan@llwyncelyn.cymru>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Date: Fri, 26 May 2017 16:27:40 +0100
Message-ID: <149581245503.17585.8098940232809927961.stgit@builder>
In-Reply-To: <149581243155.17585.8164899156710160858.stgit@builder>
References: <149581243155.17585.8164899156710160858.stgit@builder>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HRT_UNSCHED is never defined or set in the driver, so this is dead code that
can be retired, simplifying the code a bit further.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../css2400/runtime/debug/src/ia_css_debug.c       |    7 -------
 .../atomisp2/css2400/runtime/spctrl/src/spctrl.c   |    8 +-------
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |   10 ++--------
 .../atomisp/pci/atomisp2/css2400/sh_css_firmware.c |    5 -----
 4 files changed, 3 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
index bcc0d46..0fa7cb2 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
@@ -176,7 +176,6 @@ void ia_css_debug_dtrace(unsigned int level, const char *fmt, ...)
 	va_end(ap);
 }
 
-#if !defined(HRT_UNSCHED)
 static void debug_dump_long_array_formatted(
 	const sp_ID_t sp_id,
 	hrt_address stack_sp_addr,
@@ -249,12 +248,6 @@ void ia_css_debug_dump_sp_stack_info(void)
 {
 	debug_dump_sp_stack_info(SP0_ID);
 }
-#else
-/* Empty def for crun */
-void ia_css_debug_dump_sp_stack_info(void)
-{
-}
-#endif /* #if !HRT_UNSCHED */
 
 
 void ia_css_debug_set_dtrace_level(const unsigned int trace_level)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c
index b36d7b0..b3a28ba 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c
@@ -62,12 +62,6 @@ enum ia_css_err ia_css_spctrl_load_fw(sp_ID_t sp_id,
 
 	spctrl_cofig_info[sp_id].code_addr = mmgr_NULL;
 
-#if defined(HRT_UNSCHED)
-	(void)init_dmem_cfg;
-	code_addr = mmgr_malloc(1);
-	if (code_addr == mmgr_NULL)
-		return IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
-#else
 	init_dmem_cfg = &spctrl_cofig_info[sp_id].dmem_config;
 	init_dmem_cfg->dmem_data_addr = spctrl_cfg->dmem_data_addr;
 	init_dmem_cfg->dmem_bss_addr  = spctrl_cfg->dmem_bss_addr;
@@ -104,7 +98,7 @@ enum ia_css_err ia_css_spctrl_load_fw(sp_ID_t sp_id,
 		code_addr = mmgr_NULL;
 		return IA_CSS_ERR_INTERNAL_ERROR;
 	}
-#endif
+
 	spctrl_cofig_info[sp_id].sp_entry = spctrl_cfg->sp_entry;
 	spctrl_cofig_info[sp_id].code_addr = code_addr;
 	spctrl_cofig_info[sp_id].program_name = spctrl_cfg->program_name;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 19dc843..231c3f8 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -1575,7 +1575,6 @@ static bool sh_css_setup_spctrl_config(const struct ia_css_fw_info *fw,
 	spctrl_cfg->sp_entry = 0;
 	spctrl_cfg->program_name = (char *)(program);
 
-#if !defined(HRT_UNSCHED)
 	spctrl_cfg->ddr_data_offset =  fw->blob.data_source;
 	spctrl_cfg->dmem_data_addr = fw->blob.data_target;
 	spctrl_cfg->dmem_bss_addr = fw->blob.bss_target;
@@ -1588,7 +1587,7 @@ static bool sh_css_setup_spctrl_config(const struct ia_css_fw_info *fw,
 	spctrl_cfg->code_size = fw->blob.size;
 	spctrl_cfg->code      = fw->blob.code;
 	spctrl_cfg->sp_entry  = fw->info.sp.sp_entry; /* entry function ptr on SP */
-#endif
+
 	return true;
 }
 void
@@ -8570,9 +8569,7 @@ remove_firmware(struct ia_css_fw_info **l, struct ia_css_fw_info *firmware)
 	return; /* removing single and multiple firmware is handled in acc_unload_extension() */
 }
 
-#if !defined(HRT_UNSCHED)
-static enum ia_css_err
-upload_isp_code(struct ia_css_fw_info *firmware)
+static enum ia_css_err upload_isp_code(struct ia_css_fw_info *firmware)
 {
 	hrt_vaddress binary;
 
@@ -8600,12 +8597,10 @@ upload_isp_code(struct ia_css_fw_info *firmware)
 		return IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 	return IA_CSS_SUCCESS;
 }
-#endif
 
 static enum ia_css_err
 acc_load_extension(struct ia_css_fw_info *firmware)
 {
-#if !defined(HRT_UNSCHED)
 	enum ia_css_err err;
 	struct ia_css_fw_info *hd = firmware;
 	while (hd){
@@ -8614,7 +8609,6 @@ acc_load_extension(struct ia_css_fw_info *firmware)
 			return err;
 		hd = hd->next;
 	}
-#endif
 
 	if (firmware == NULL)
 		return IA_CSS_ERR_INVALID_ARGUMENTS;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
index a179de5..eecd8cf 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
@@ -92,12 +92,7 @@ setup_binary(struct ia_css_fw_info *fw, const char *fw_data, struct ia_css_fw_in
 
 	*sh_css_fw = *fw;
 
-#if defined(HRT_UNSCHED)
-	sh_css_fw->blob.code = vmalloc(1);
-#else
 	sh_css_fw->blob.code = vmalloc(fw->blob.size);
-#endif
-
 	if (sh_css_fw->blob.code == NULL)
 		return IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 
