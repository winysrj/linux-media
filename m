Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37052 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753454AbdC0PO3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 11:14:29 -0400
Subject: [PATCH 1/5] atomisp: remove dead code
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 27 Mar 2017 16:13:44 +0100
Message-ID: <149062762280.15399.12714375439154128065.stgit@rszulisx-mobl.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HAS_SEC_ISP is never defined so we can scrub all the code that is within the
defines for it.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../atomisp2/css2400/runtime/spctrl/src/spctrl.c   |    5 -
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |  110 --------------------
 .../atomisp/pci/atomisp2/css2400/sh_css_firmware.c |   17 ---
 .../atomisp/pci/atomisp2/css2400/sh_css_firmware.h |    3 -
 .../atomisp/pci/atomisp2/css2400/sh_css_internal.h |    7 -
 .../media/atomisp/pci/atomisp2/css2400/sh_css_sp.c |   80 ---------------
 .../media/atomisp/pci/atomisp2/css2400/sh_css_sp.h |   14 ---
 7 files changed, 1 insertion(+), 235 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c
index 0d2e47d..fc42c02 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c
@@ -185,11 +185,6 @@ ia_css_spctrl_sp_sw_state ia_css_spctrl_get_state(sp_ID_t sp_id)
 	(void)HIVE_ADDR_sp_sw_state; /* Suppres warnings in CRUN */
 	if (sp_id == SP0_ID)
 		state = sp_dmem_load_uint32(sp_id, (unsigned)sp_address_of(sp_sw_state));
-#if defined(HAS_SEC_SP)
-	else
-		state = sp_dmem_load_uint32(sp_id, (unsigned)sp1_address_of(sp_sw_state));
-#endif /* HAS_SEC_SP */
-
 	return state;
 }
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 3cbdcef..7e337e0 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -103,9 +103,6 @@ static int thread_alive;
 
 /* Name of the sp program: should not be built-in */
 #define SP_PROG_NAME "sp"
-#if defined(HAS_SEC_SP)
-#define SP1_PROG_NAME "sp1"
-#endif /* HAS_SEC_SP */
 #if defined(HAS_BL)
 #define BL_PROG_NAME "bootloader"
 #endif
@@ -415,14 +412,6 @@ static void get_pipe_extra_pixel(struct ia_css_pipe *pipe,
 		unsigned int *extra_row, unsigned int *extra_column);
 #endif
 
-#if defined(HAS_SEC_SP)
-static enum ia_css_err
-sh_css_start_sp1(void);
-
-static enum ia_css_err
-sh_css_stop_sp1(void);
-#endif
-
 #ifdef ISP2401
 #ifdef USE_INPUT_SYSTEM_VERSION_2401
 static enum ia_css_err
@@ -1725,9 +1714,6 @@ ia_css_init(const struct ia_css_env *env,
 #if defined(HAS_BL)
 	ia_css_blctrl_cfg blctrl_cfg;
 #endif
-#if defined(HAS_SEC_SP)
-	ia_css_spctrl_cfg sp1ctrl_cfg;
-#endif /* HAS_SEC_SP */
 
 	void *(*malloc_func)(size_t size, bool zero_mem);
 	void (*free_func)(void *ptr);
@@ -1890,15 +1876,6 @@ ia_css_init(const struct ia_css_env *env,
 		IA_CSS_LEAVE_ERR(err);
 		return err;
 	}
-#if defined(HAS_SEC_SP)
-	if(!sh_css_setup_spctrl_config(&sh_css_sp1_fw,SP1_PROG_NAME,&sp1ctrl_cfg))
-		return IA_CSS_ERR_INTERNAL_ERROR;
-	err = ia_css_spctrl_load_fw(SP1_ID, &sp1ctrl_cfg);
-	if (err != IA_CSS_SUCCESS) {
-		IA_CSS_LEAVE_ERR(err);
-		return err;
-	}
-#endif /* HAS_SEC_SP */
 
 #if defined(HAS_BL)
 	if (!sh_css_setup_blctrl_config(&sh_css_bl_fw, BL_PROG_NAME, &blctrl_cfg))
@@ -1908,14 +1885,7 @@ ia_css_init(const struct ia_css_env *env,
 		IA_CSS_LEAVE_ERR(err);
 		return err;
 	}
-#if defined(HAS_SEC_SP)
-	err = ia_css_blctrl_add_target_fw_info(&sh_css_sp1_fw, IA_CSS_SP1,
-					 get_sp_code_addr(SP1_ID));
-	if (err != IA_CSS_SUCCESS) {
-		IA_CSS_LEAVE_ERR(err);
-		return err;
-	}
-#endif
+
 #ifdef ISP2401
 	err = ia_css_blctrl_add_target_fw_info(&sh_css_sp_fw, IA_CSS_SP0,
 					 get_sp_code_addr(SP0_ID));
@@ -2709,11 +2679,6 @@ ia_css_uninit(void)
 	}
 	ia_css_spctrl_unload_fw(SP0_ID);
 	sh_css_sp_set_sp_running(false);
-#if defined(HAS_SEC_SP)
-	ia_css_spctrl_unload_fw(SP1_ID);
-	sh_css_sp1_set_sp1_running(false);
-#endif /* HAS_SEC_SP */
-
 #if defined(HAS_BL)
 	ia_css_blctrl_unload_fw();
 #endif
@@ -10668,33 +10633,6 @@ ia_css_start_bl(void)
 
 #define SP_START_TIMEOUT_US 30000000
 
-#if defined(HAS_SEC_SP)
-
-static enum ia_css_err
-sh_css_start_sp1(void)
-{
-
-	unsigned long timeout;
-
-	IA_CSS_ENTER_PRIVATE("void");
-	sh_css_sp1_start();
-	/* waiting for the SP is completely started */
-	timeout = SP_START_TIMEOUT_US;
-	while((ia_css_spctrl_get_state(SP1_ID) != IA_CSS_SP_SW_INITIALIZED) && timeout) {
-		timeout--;
-		hrt_sleep();
-	}
-	if (timeout == 0) {
-		IA_CSS_LEAVE_ERR_PRIVATE(IA_CSS_ERR_INTERNAL_ERROR);
-		return IA_CSS_ERR_INTERNAL_ERROR;
-	}
-	sh_css_write_host2sp1_command(host2sp_cmd_ready);
-
-	IA_CSS_LEAVE_ERR_PRIVATE(IA_CSS_SUCCESS);
-	return IA_CSS_SUCCESS;
-}
-#endif
-
 enum ia_css_err
 ia_css_start_sp(void)
 {
@@ -10735,11 +10673,6 @@ ia_css_start_sp(void)
 	sh_css_setup_queues();
 	ia_css_bufq_dump_queue_info();
 
-#if defined(HAS_SEC_SP)
-	/* Start the SP1 Core */
-	err = sh_css_start_sp1();
-#endif /* HAS_SEC_SP */
-
 #ifdef ISP2401
 	if (ia_css_is_system_mode_suspend_or_resume() == false) { /* skip in suspend/resume flow */
 		ia_css_set_system_mode(IA_CSS_SYS_MODE_WORKING);
@@ -10756,42 +10689,6 @@ ia_css_start_sp(void)
  */
 #define SP_SHUTDOWN_TIMEOUT_US 200000
 
-#if defined(HAS_SEC_SP)
-
-static enum ia_css_err
-sh_css_stop_sp1(void)
-{
-	unsigned long timeout;
-
-	IA_CSS_ENTER_PRIVATE("void");
-
-	/* For now, stop whole SP1 */
-	sh_css_write_host2sp1_command(host2sp_cmd_terminate);
-	sh_css_sp1_set_sp1_running(false);
-
-	timeout = SP_SHUTDOWN_TIMEOUT_US;
-	while ((ia_css_spctrl_get_state(SP1_ID)!= IA_CSS_SP_SW_TERMINATED) && timeout) {
-		timeout--;
-		hrt_sleep();
-	}
-	if (timeout == 0) {
-		IA_CSS_WARNING("SP1 is not terminated");
-	} else {
-		timeout = SP_SHUTDOWN_TIMEOUT_US;
-		while (!ia_css_spctrl_is_idle(SP1_ID) && 0 != timeout) {
-			timeout--;
-			hrt_sleep();
-		}
-		if (0 == timeout) {
-			IA_CSS_WARNING("SP1 is not idle");
-		}
-	}
-
-	IA_CSS_LEAVE_ERR_PRIVATE(IA_CSS_SUCCESS);
-	return IA_CSS_SUCCESS;
-}
-#endif
-
 enum ia_css_err
 ia_css_stop_sp(void)
 {
@@ -10855,11 +10752,6 @@ ia_css_stop_sp(void)
 	}
 #endif
 
-#if defined(HAS_SEC_SP)
-	/* Stop SP1 Core */
-	sh_css_stop_sp1();
-#endif /* HAS_SEC_SP */
-
 	IA_CSS_LEAVE_ERR(err);
 	return err;
 }
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
index 2f227a8..95f72e5 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
@@ -60,9 +60,6 @@ static const char *release_version = STR(irci_ecr-master_20150911_0724);
 static char FW_rel_ver_name[MAX_FW_REL_VER_NAME] = "---";
 
 struct ia_css_fw_info	  sh_css_sp_fw;
-#if defined(HAS_SEC_SP)
-struct ia_css_fw_info	  sh_css_sp1_fw;
-#endif /* HAS_SEC_SP */
 #if defined(HAS_BL)
 struct ia_css_fw_info     sh_css_bl_fw;
 #endif /* HAS_BL */
@@ -138,9 +135,6 @@ sh_css_load_blob_info(const char *fw, const struct ia_css_fw_info *bi, struct ia
 	bd->header = *bi;
 
 	if ((bi->type == ia_css_isp_firmware) || (bi->type == ia_css_sp_firmware)
-#if defined(HAS_SEC_SP)
-	|| (bi->type == ia_css_sp1_firmware)
-#endif /* HAS_SEC_SP */
 #if defined(HAS_BL)
 	|| (bi->type == ia_css_bootloader_firmware)
 #endif /* HAS_BL */
@@ -282,14 +276,6 @@ sh_css_load_firmware(const char *fw_data,
 			err = setup_binary(bi, fw_data, &sh_css_sp_fw, i);
 			if (err != IA_CSS_SUCCESS)
 				return err;
-#if defined(HAS_SEC_SP)
-		} else if (bi->type == ia_css_sp1_firmware) {
-			if (i != SP1_FIRMWARE)
-				return IA_CSS_ERR_INTERNAL_ERROR;
-			err = setup_binary(bi, fw_data, &sh_css_sp1_fw, i);
-			if (err != IA_CSS_SUCCESS)
-				return err;
-#endif /* HAS_SEC_SP */
 #if defined(HAS_BL)
 		} else if (bi->type == ia_css_bootloader_firmware) {
 			if (i != BOOTLOADER_FIRMWARE)
@@ -332,9 +318,6 @@ void sh_css_unload_firmware(void)
 	}
 
 	memset(&sh_css_sp_fw, 0, sizeof(sh_css_sp_fw));
-#if defined(HAS_SEC_SP)
-	memset(&sh_css_sp1_fw, 0, sizeof(sh_css_sp1_fw));
-#endif /* HAS_SEC_SP */
 	if (sh_css_blob_info) {
 		sh_css_free(sh_css_blob_info);
 		sh_css_blob_info = NULL;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.h
index 97bdf2e..588aabd 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.h
@@ -28,9 +28,6 @@ struct  sh_css_fw_bi_file_h {
 };
 
 extern struct ia_css_fw_info     sh_css_sp_fw;
-#if defined(HAS_SEC_SP)
-extern struct ia_css_fw_info     sh_css_sp1_fw;
-#endif /* HAS_SEC_SP */
 #if defined(HAS_BL)
 extern struct ia_css_fw_info     sh_css_bl_fw;
 #endif /* HAS_BL */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h
index 9a3fe2b..a108923 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h
@@ -152,11 +152,7 @@
 #define SIZE_OF_IA_CSS_PTR		sizeof(uint32_t)
 
 /* Number of SP's */
-#if defined(HAS_SEC_SP)
-#define NUM_OF_SPS 2
-#else
 #define NUM_OF_SPS 1
-#endif /* HAS_SEC_SP */
 
 #if defined(HAS_BL)
 #define NUM_OF_BLS 1
@@ -167,9 +163,6 @@
 /* Enum for order of Binaries */
 enum sh_css_order_binaries {
 	SP_FIRMWARE = 0,
-#if defined(HAS_SEC_SP)
-	SP1_FIRMWARE,
-#endif /* HAS_SEC_SP */
 #if defined(HAS_BL)
 	BOOTLOADER_FIRMWARE,
 #endif
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c
index 00b2d16..ada64bf 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c
@@ -78,9 +78,6 @@ static struct sh_css_sp_per_frame_data per_frame_data;
 /* For the moment there is only code that sets this bool to true */
 /* TODO: add code that sets this bool to false */
 static bool sp_running;
-#if defined(HAS_SEC_SP)
-static bool sp1_running;
-#endif /* HAS_SEC_SP */
 
 static enum ia_css_err
 set_output_frame_buffer(const struct ia_css_frame *frame,
@@ -152,11 +149,6 @@ store_sp_per_frame_data(const struct ia_css_fw_info *fw)
 	case ia_css_sp_firmware:
 		HIVE_ADDR_sp_per_frame_data = fw->info.sp.per_frame_data;
 		break;
-#if defined(HAS_SEC_SP)
-	case ia_css_sp1_firmware:
-		(void)fw;
-		break;
-#endif /* HAS_SEC_SP */
 	case ia_css_acc_firmware:
 		HIVE_ADDR_sp_per_frame_data = fw->info.acc.per_frame_data;
 		break;
@@ -1385,23 +1377,6 @@ sh_css_sp_uninit_pipeline(unsigned int pipe_num)
 	sh_css_sp_group.pipe[thread_id].num_stages = 0;
 }
 
-#if defined(HAS_SEC_SP)
-void
-sh_css_write_host2sp1_command(enum host2sp_commands host2sp_command)
-{
-	unsigned int HIVE_ADDR_host_sp1_com = sh_css_sp1_fw.info.sp1.host_sp_com;
-	unsigned int offset = (unsigned int)offsetof(struct host_sp_communication, host2sp_command)
-				/ sizeof(int);
-	(void)HIVE_ADDR_host_sp1_com; /* Suppres warnings in CRUN */
-
-	/* Previous command must be handled by SP1 (by design) */
-	if (host2sp_command == host2sp_cmd_terminate)
-		assert(load_sp1_array_uint(host_sp1_com, offset) == host2sp_cmd_ready);
-
-	store_sp1_array_uint(host_sp1_com, offset, host2sp_command);
-}
-#endif /* HAS_SEC_SP */
-
 bool sh_css_write_host2sp_command(enum host2sp_commands host2sp_command)
 {
 	unsigned int HIVE_ADDR_host_sp_com = sh_css_sp_fw.info.sp.host_sp_com;
@@ -1698,67 +1673,12 @@ sh_css_sp_set_sp_running(bool flag)
 	sp_running = flag;
 }
 
-#if defined(HAS_SEC_SP)
-void
-sh_css_sp1_set_sp1_running(bool flag)
-{
-	sp1_running = flag;
-}
-#endif /* HAS_SEC_SP */
-
 bool
 sh_css_sp_is_running(void)
 {
 	return sp_running;
 }
 
-#if defined(HAS_SEC_SP)
-void
-sh_css_sp1_start(void)
-{
-	const struct ia_css_fw_info *fw;
-	unsigned int HIVE_ADDR_sp_sw_state;
-	fw = &sh_css_sp1_fw;
-	HIVE_ADDR_sp_sw_state = fw->info.sp1.sw_state;
-
-	if (sp1_running)
-		return;
-
-	(void)HIVE_ADDR_sp_sw_state; /* Suppres warnings in CRUN */
-
-	/* no longer here, sp started immediately */
-	/*ia_css_debug_pipe_graph_dump_epilogue();*/
-
-	/*store_sp_group_data();
-	store_sp_per_frame_data(fw);*/
-	sp_dmem_store_uint32(SP1_ID,
-		(unsigned int)sp1_address_of(sp_sw_state),
-		(uint32_t)(IA_CSS_SP_SW_TERMINATED));
-
-	/* Note 1: The sp_start_isp function contains a wait till
-	 * the input network is configured by the SP.
-	 * Note 2: Not all SP binaries supports host2sp_commands.
-	 * In case a binary does support it, the host2sp_command
-	 * will have status cmd_ready after return of the function
-	 * sh_css_hrt_sp_start_isp. There is no race-condition here
-	 * because only after the process_frame command has been
-	 * received, the SP starts configuring the input network.
-	 */
-
-	/* we need to set sp_running before we call ia_css_mmu_invalidate_cache
-	 * as ia_css_mmu_invalidate_cache checks on sp_running to
-	 * avoid that it accesses dmem while the SP is not powered
-	 */
-	sp1_running = true;
-	/* ia_css_mmu_invalidate_cache(); */
-	/* Invalidate all MMU caches */
-	/* mmu_invalidate_cache_all(); */
-
-	ia_css_spctrl_start(SP1_ID);
-
-}
-#endif /* HAS_SEC_SP */
-
 void
 sh_css_sp_start_isp(void)
 {
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.h
index 5b73011..98444a3 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.h
@@ -79,11 +79,6 @@ sh_css_sp_uninit_pipeline(unsigned int pipe_num);
 
 bool sh_css_write_host2sp_command(enum host2sp_commands host2sp_command);
 
-#if defined(HAS_SEC_SP)
-void
-sh_css_write_host2sp1_command(enum host2sp_commands host2sp_command);
-#endif /* HAS_SEC_SP */
-
 enum host2sp_commands
 sh_css_read_host2sp_command(void);
 
@@ -147,19 +142,10 @@ sh_css_event_init_irq_mask(void);
 
 void
 sh_css_sp_start_isp(void);
-#if defined(HAS_SEC_SP)
-void
-sh_css_sp1_start(void);
-#endif /* HAS_SEC_SP */
 
 void
 sh_css_sp_set_sp_running(bool flag);
 
-#if defined(HAS_SEC_SP)
-void
-sh_css_sp1_set_sp1_running(bool flag);
-#endif /* HAS_SEC_SP */
-
 bool
 sh_css_sp_is_running(void);
 
