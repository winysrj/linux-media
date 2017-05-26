Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:38370 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1947935AbdEZPZy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 11:25:54 -0400
Subject: [PATCH 01/12] atompisp: HAS_BL is never defined so lose it
From: Alan Cox <alan@llwyncelyn.cymru>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Date: Fri, 26 May 2017 16:25:48 +0100
Message-ID: <149581234670.17406.8086980349538517529.stgit@builder>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kill off the HAS_BL define and the code and includes it brackets. We never
define HAS_BL or use that functionality.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |  101 --------------------
 .../atomisp/pci/atomisp2/css2400/sh_css_firmware.c |   19 ----
 .../atomisp/pci/atomisp2/css2400/sh_css_internal.h |    7 -
 3 files changed, 1 insertion(+), 126 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 81a21a0..19dc843 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -98,18 +98,12 @@ static int thread_alive;
 
 #include "isp/modes/interface/input_buf.isp.h"
 
-#if defined(HAS_BL)
-#include "support/bootloader/interface/ia_css_blctrl.h"
-#endif
 #if defined(HAS_RES_MGR)
 #include "components/acc_cluster/gen/host/acc_cluster.host.h"
 #endif
 
 /* Name of the sp program: should not be built-in */
 #define SP_PROG_NAME "sp"
-#if defined(HAS_BL)
-#define BL_PROG_NAME "bootloader"
-#endif
 /* Size of Refcount List */
 #define REFCOUNT_SIZE 1000
 
@@ -1571,34 +1565,7 @@ enable_interrupts(enum ia_css_irq_type irq_type)
 }
 
 #endif
-#if defined(HAS_BL)
-static bool sh_css_setup_blctrl_config(const struct ia_css_fw_info *fw,
-							const char *program,
-							ia_css_blctrl_cfg  *blctrl_cfg)
-{
-	if((fw == NULL)||(blctrl_cfg == NULL))
-		return false;
-	blctrl_cfg->bl_entry = 0;
-	blctrl_cfg->program_name = (char *)(program);
-
-#if !defined(HRT_UNSCHED)
-	blctrl_cfg->ddr_data_offset =  fw->blob.data_source;
-	blctrl_cfg->dmem_data_addr = fw->blob.data_target;
-	blctrl_cfg->dmem_bss_addr = fw->blob.bss_target;
-	blctrl_cfg->data_size = fw->blob.data_size ;
-	blctrl_cfg->bss_size = fw->blob.bss_size;
-
-	blctrl_cfg->blctrl_state_dmem_addr = fw->info.bl.sw_state;
-	blctrl_cfg->blctrl_dma_cmd_list = fw->info.bl.dma_cmd_list;
-	blctrl_cfg->blctrl_nr_of_dma_cmds = fw->info.bl.num_dma_cmds;
 
-	blctrl_cfg->code_size = fw->blob.size;
-	blctrl_cfg->code      = fw->blob.code;
-	blctrl_cfg->bl_entry  = fw->info.bl.bl_entry; /* entry function ptr on Bootloader */
-#endif
-	return true;
-}
-#endif
 static bool sh_css_setup_spctrl_config(const struct ia_css_fw_info *fw,
 							const char * program,
 							ia_css_spctrl_cfg  *spctrl_cfg)
@@ -1708,9 +1675,6 @@ ia_css_init(const struct ia_css_env *env,
 {
 	enum ia_css_err err;
 	ia_css_spctrl_cfg spctrl_cfg;
-#if defined(HAS_BL)
-	ia_css_blctrl_cfg blctrl_cfg;
-#endif
 
 	void (*flush_func)(struct ia_css_acc_fw *fw);
 	hrt_data select, enable;
@@ -1863,26 +1827,6 @@ ia_css_init(const struct ia_css_env *env,
 		return err;
 	}
 
-#if defined(HAS_BL)
-	if (!sh_css_setup_blctrl_config(&sh_css_bl_fw, BL_PROG_NAME, &blctrl_cfg))
-		return IA_CSS_ERR_INTERNAL_ERROR;
-	err = ia_css_blctrl_load_fw(&blctrl_cfg);
-	if (err != IA_CSS_SUCCESS) {
-		IA_CSS_LEAVE_ERR(err);
-		return err;
-	}
-
-#ifdef ISP2401
-	err = ia_css_blctrl_add_target_fw_info(&sh_css_sp_fw, IA_CSS_SP0,
-					 get_sp_code_addr(SP0_ID));
-
-#endif
-	if (err != IA_CSS_SUCCESS) {
-		IA_CSS_LEAVE_ERR(err);
-		return err;
-	}
-#endif /* HAS_BL */
-
 #if WITH_PC_MONITORING
 	if (!thread_alive) {
 		thread_alive++;
@@ -2667,9 +2611,6 @@ ia_css_uninit(void)
 	}
 	ia_css_spctrl_unload_fw(SP0_ID);
 	sh_css_sp_set_sp_running(false);
-#if defined(HAS_BL)
-	ia_css_blctrl_unload_fw();
-#endif
 #if defined(USE_INPUT_SYSTEM_VERSION_2) || defined(USE_INPUT_SYSTEM_VERSION_2401)
 	/* check and free any remaining mipi frames */
 	free_mipi_frames(NULL);
@@ -10588,39 +10529,6 @@ ia_css_pipe_get_isp_pipe_version(const struct ia_css_pipe *pipe)
 	return (unsigned int)pipe->config.isp_pipe_version;
 }
 
-#if defined(HAS_BL)
-#define BL_START_TIMEOUT_US 30000000
-static enum ia_css_err
-ia_css_start_bl(void)
-{
-	enum ia_css_err err = IA_CSS_SUCCESS;
-	unsigned long timeout;
-
-	IA_CSS_ENTER("");
-	sh_css_start_bl();
-	/* waiting for the Bootloader to complete execution */
-	timeout = BL_START_TIMEOUT_US;
-	while((ia_css_blctrl_get_state() == BOOTLOADER_BUSY) && timeout) {
-		timeout--;
-		hrt_sleep();
-	}
-	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE,
-			    "Bootloader state %d\n", ia_css_blctrl_get_state());
-	if (timeout == 0) {
-		ia_css_debug_dtrace(IA_CSS_DEBUG_ERROR,
-				    "Bootloader Execution Timeout\n");
-		err = IA_CSS_ERR_INTERNAL_ERROR;
-	}
-	if (ia_css_blctrl_get_state() != BOOTLOADER_OK) {
-		ia_css_debug_dtrace(IA_CSS_DEBUG_ERROR,
-				    "Bootloader Execution Failed\n");
-		err = IA_CSS_ERR_INTERNAL_ERROR;
-	}
-	IA_CSS_LEAVE_ERR(err);
-	return err;
-}
-#endif
-
 #define SP_START_TIMEOUT_US 30000000
 
 enum ia_css_err
@@ -10630,15 +10538,6 @@ ia_css_start_sp(void)
 	enum ia_css_err err = IA_CSS_SUCCESS;
 
 	IA_CSS_ENTER("");
-#if defined(HAS_BL)
-	/* Starting bootloader before Sp0 and Sp1
-	 * and not exposing CSS API */
-	err = ia_css_start_bl();
-	if (err != IA_CSS_SUCCESS) {
-		IA_CSS_LEAVE("Bootloader fails");
-		return err;
-	}
-#endif
 	sh_css_sp_start_isp();
 
 	/* waiting for the SP is completely started */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
index 34cc56f..57b4fe5 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
@@ -63,9 +63,6 @@ static const char *release_version = STR(irci_ecr-master_20150911_0724);
 static char FW_rel_ver_name[MAX_FW_REL_VER_NAME] = "---";
 
 struct ia_css_fw_info	  sh_css_sp_fw;
-#if defined(HAS_BL)
-struct ia_css_fw_info     sh_css_bl_fw;
-#endif /* HAS_BL */
 struct ia_css_blob_descr *sh_css_blob_info; /* Only ISP blob info (no SP) */
 unsigned		  sh_css_num_binaries; /* This includes 1 SP binary */
 
@@ -137,12 +134,7 @@ sh_css_load_blob_info(const char *fw, const struct ia_css_fw_info *bi, struct ia
 	bd->blob = blob;
 	bd->header = *bi;
 
-	if ((bi->type == ia_css_isp_firmware) || (bi->type == ia_css_sp_firmware)
-#if defined(HAS_BL)
-	|| (bi->type == ia_css_bootloader_firmware)
-#endif /* HAS_BL */
-	)
-	{
+	if (bi->type == ia_css_isp_firmware || bi->type == ia_css_sp_firmware) {
 		char *namebuffer;
 		int namelength = (int)strlen(name);
 
@@ -279,15 +271,6 @@ sh_css_load_firmware(const char *fw_data,
 			err = setup_binary(bi, fw_data, &sh_css_sp_fw, i);
 			if (err != IA_CSS_SUCCESS)
 				return err;
-#if defined(HAS_BL)
-		} else if (bi->type == ia_css_bootloader_firmware) {
-			if (i != BOOTLOADER_FIRMWARE)
-				return IA_CSS_ERR_INTERNAL_ERROR;
-			err = setup_binary(bi, fw_data, &sh_css_bl_fw, i);
-			if (err != IA_CSS_SUCCESS)
-				return err;
-			IA_CSS_LOG("Bootloader binary recognized\n");
-#endif
 		} else {
 			/* All subsequent binaries (including bootloaders) (i>NUM_OF_SPS+NUM_OF_BLS) are ISP firmware */
 			if (i < (NUM_OF_SPS + NUM_OF_BLS))
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h
index e2b6f06..5b2b78f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h
@@ -154,18 +154,11 @@
 /* Number of SP's */
 #define NUM_OF_SPS 1
 
-#if defined(HAS_BL)
-#define NUM_OF_BLS 1
-#else
 #define NUM_OF_BLS 0
-#endif
 
 /* Enum for order of Binaries */
 enum sh_css_order_binaries {
 	SP_FIRMWARE = 0,
-#if defined(HAS_BL)
-	BOOTLOADER_FIRMWARE,
-#endif
 	ISP_FIRMWARE
 };
 
