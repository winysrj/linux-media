Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34698 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750969AbdIKSvS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 14:51:18 -0400
Date: Mon, 11 Sep 2017 20:51:15 +0200
From: Vincent Hervieux <vincent.hervieux@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        alan@llwyncelyn.cymru, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, rvarsha016@gmail.com,
        dan.carpenter@oracle.com, fengguang.wu@intel.com,
        daeseok.youn@gmail.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, vincent.hervieux@gmail.com
Subject: [PATCH 2/2] staging: atomisp: fix compilation errors in case of
 ISP2401.
Message-ID: <eb7714c464199ecb81d3a9bf9c57b5bf2689ac4b.1505142435.git.vincent.hervieux@gmail.com>
References: <cover.1505142435.git.vincent.hervieux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1505142435.git.vincent.hervieux@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Vincent Hervieux <vincent.hervieux@gmail.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |  5 ++---
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      |  6 +++++-
 .../pci/atomisp2/css2400/ia_css_acc_types.h        |  1 +
 .../css2400/runtime/debug/src/ia_css_debug.c       |  3 ---
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    | 24 ++++++++++------------
 .../atomisp/pci/atomisp2/css2400/sh_css_params.c   |  8 +-------
 6 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index f48bf451c1f5..d79a3cfb834d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -1045,9 +1045,8 @@ void atomisp_buf_done(struct atomisp_sub_device *asd, int error,
 				asd->re_trigger_capture = false;
 				dev_dbg(isp->dev, "Trigger capture again for new buffer. err=%d\n",
 						err);
-			} else {
-				asd->re_trigger_capture = true;
-			}
+		} else {
+			asd->re_trigger_capture = true;
 #endif
 		}
 		break;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index 663aa916e3ca..1e61f66437d2 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -1602,4 +1602,8 @@ module_exit(atomisp_exit);
 MODULE_AUTHOR("Wen Wang <wen.w.wang@intel.com>");
 MODULE_AUTHOR("Xiaolin Zhang <xiaolin.zhang@intel.com>");
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Intel ATOM Platform ISP Driver");
+#if defined(ISP2400) || defined(ISP2400B0)
+MODULE_DESCRIPTION("Intel ATOM Platform ISP Driver 2400");
+#elif defined(ISP2401)
+MODULE_DESCRIPTION("Intel ATOM Platform ISP Driver 2401");
+#endif
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_acc_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_acc_types.h
index a2a1873aca83..3bcbd0fa0637 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_acc_types.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_acc_types.h
@@ -222,6 +222,7 @@ struct ia_css_binary_info {
 		uint8_t	luma_only;
 		uint8_t	input_yuv;
 		uint8_t	input_raw;
+		uint8_t	lace_stats;
 #endif
 		uint8_t	reduced_pipe;
 		uint8_t	vf_veceven;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
index 0fa7cb2423d8..6f6e30cb7550 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
@@ -49,9 +49,6 @@
 #include "assert_support.h"
 #include "print_support.h"
 #include "string_support.h"
-#ifdef ISP2401
-#include "ia_css_system_ctrl.h"
-#endif
 
 #include "fifo_monitor.h"
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index e882b5596813..1d2e56e74e01 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -1496,7 +1496,7 @@ sh_css_invalidate_shading_tables(struct ia_css_stream *stream)
 		"sh_css_invalidate_shading_tables() leave: return_void\n");
 }
 
-#ifndef ISP2401
+#if 1 /* was ndef ISP2401 but this function is used by ISP2401 on line 1758 */
 static void
 enable_interrupts(enum ia_css_irq_type irq_type)
 {
@@ -1709,7 +1709,7 @@ ia_css_init(const struct ia_css_env *env,
 	enable = gpio_reg_load(GPIO0_ID, _gpio_block_reg_do_e)
 							| GPIO_FLASH_PIN_MASK;
 	sh_css_mmu_set_page_table_base_index(mmu_l1_base);
-#ifndef ISP2401
+#if 1 /* was ndef ISP2401 but ia_css_save_mmu_base_addr is not declared */
 	my_css_save.mmu_base = mmu_l1_base;
 #else
 	ia_css_save_mmu_base_addr(mmu_l1_base);
@@ -1726,7 +1726,7 @@ ia_css_init(const struct ia_css_env *env,
 		return err;
 	}
 
-#ifndef ISP2401
+#if 1 /* was ndef ISP2401 but ia_css_save_restore_data_init is not declared */
 	IA_CSS_LOG("init: %d", my_css_save_initialized);
 #else
 	ia_css_save_restore_data_init();
@@ -1750,7 +1750,7 @@ ia_css_init(const struct ia_css_env *env,
 
 #endif
 	my_css.irq_type = irq_type;
-#ifndef ISP2401
+#if 1 /* was ndef ISP2401 but ia_css_save_irq_type is not declared */
 	my_css_save.irq_type = irq_type;
 #else
 	ia_css_save_irq_type(irq_type);
@@ -9776,7 +9776,7 @@ ia_css_stream_create(const struct ia_css_stream_config *stream_config,
 	*stream = curr_stream;
 
 ERR:
-#ifndef ISP2401
+#if 1 /* was ndef ISP2401, but ia_css_save_stream is not declared */
 	if (err == IA_CSS_SUCCESS)
 	{
 		/* working mode: enter into the seed list */
@@ -9819,7 +9819,7 @@ ia_css_stream_destroy(struct ia_css_stream *stream)
 	enum ia_css_err err = IA_CSS_SUCCESS;
 #ifdef ISP2401
 	enum ia_css_err err1 = IA_CSS_SUCCESS;
-	enum ia_css_err err2 = IA_CSS_SUCCESS;
+	/* unused enum ia_css_err err2 = IA_CSS_SUCCESS; */
 #endif
 
 	IA_CSS_ENTER_PRIVATE("stream = %p", stream);
@@ -9915,7 +9915,7 @@ ia_css_stream_destroy(struct ia_css_stream *stream)
 	kfree(stream->pipes);
 	stream->pipes = NULL;
 	stream->num_pipes = 0;
-#ifndef ISP2401
+#if 1 /*was ndef ISP2401, but ia_css_save_restore_remove_stream is not declared */
 	/* working mode: take out of the seed list */
 	if (my_css_save.mode == sh_css_mode_working)
 		for(i=0;i<MAX_ACTIVE_STREAMS;i++)
@@ -10113,7 +10113,6 @@ ia_css_stream_has_stopped(struct ia_css_stream *stream)
 	return stopped;
 }
 
-#ifndef ISP2401
 /*
  * Destroy the stream and all the pipes related to it.
  * The stream handle is used to identify the correct entry in the css_save struct
@@ -10141,7 +10140,6 @@ ia_css_stream_unload(struct ia_css_stream *stream)
 	return IA_CSS_SUCCESS;
 }
 
-#endif
 enum ia_css_err
 ia_css_temp_pipe_to_pipe_id(const struct ia_css_pipe *pipe, enum ia_css_pipe_id *pipe_id)
 {
@@ -10427,7 +10425,7 @@ ia_css_start_sp(void)
 	sh_css_setup_queues();
 	ia_css_bufq_dump_queue_info();
 
-#ifdef ISP2401
+#if 0 /* was def ISP2401, but ia_css_is_system_mode_suspend_or_resume and ia_css_set_system_mode are not declared */
 	if (ia_css_is_system_mode_suspend_or_resume() == false) { /* skip in suspend/resume flow */
 		ia_css_set_system_mode(IA_CSS_SYS_MODE_WORKING);
 	}
@@ -10495,7 +10493,7 @@ ia_css_stop_sp(void)
 
 	sh_css_hmm_buffer_record_uninit();
 
-#ifndef ISP2401
+#if 1 /* was ndef ISP2401, but ia_css_is_system_mode_suspend_or_resume is not declared */
 	/* clear pending param sets from refcount */
 	sh_css_param_clear_param_sets();
 #else
@@ -11003,7 +11001,7 @@ sh_css_hmm_buffer_record_init(void)
 {
 	int i;
 
-#ifndef ISP2401
+#if 1 /* was ndef ISP2401 but ia_css_is_system_mode_suspend_or_resume is not defined */
 	for (i = 0; i < MAX_HMM_BUFFER_NUM; i++) {
 		sh_css_hmm_buffer_record_reset(&hmm_buffer_record[i]);
 #else
@@ -11021,7 +11019,7 @@ sh_css_hmm_buffer_record_uninit(void)
 	int i;
 	struct sh_css_hmm_buffer_record *buffer_record = NULL;
 
-#ifndef ISP2401
+#if 1 /* was ndef ISP2401 but ia_css_is_system_mode_suspend_or_resume is not defined */
 	buffer_record = &hmm_buffer_record[0];
 	for (i = 0; i < MAX_HMM_BUFFER_NUM; i++) {
 		if (buffer_record->in_use) {
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
index 48224370b8bf..2f51a5404e1f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
@@ -46,7 +46,7 @@
 #include "ia_css_pipeline.h"
 #include "ia_css_debug.h"
 #include "memory_access.h"
-#if 0   /* FIXME */
+#ifdef ISP2401
 #include "memory_realloc.h"
 #endif
 #include "ia_css_isp_param.h"
@@ -3128,9 +3128,6 @@ sh_css_init_isp_params_from_global(struct ia_css_stream *stream,
 
 		ia_css_sdis_clear_coefficients(&params->dvs_coefs);
 		params->dis_coef_table_changed = true;
-#ifdef ISP2401
-		ia_css_tnr3_set_default_config(&params->tnr3_config);
-#endif
 	}
 	else
 	{
@@ -3929,9 +3926,6 @@ sh_css_param_update_isp_params(struct ia_css_pipe *curr_pipe,
 			 */
 			g_param_buffer_enqueue_count++;
 			assert(g_param_buffer_enqueue_count < g_param_buffer_dequeue_count+50);
-#ifdef ISP2401
-			ia_css_save_latest_paramset_ptr(pipe, cpy);
-#endif
 			/*
 			 * Tell the SP which queues are not empty,
 			 * by sending the software event.
-- 
2.11.0
