Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0208.hostedemail.com ([216.40.44.208]:52575 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935529AbdD2TKY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Apr 2017 15:10:24 -0400
From: Joe Perches <joe@perches.com>
To: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH V2] staging: atomisp: Add __printf validation and fix fallout
Date: Sat, 29 Apr 2017 12:10:08 -0700
Message-Id: <4844a7afd2e34aec4665d6995a2a301c328b4bc2.1493492862.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

__printf validation adds format and argument validation.

Fix the various broken format/argument mismatches.

Signed-off-by: Joe Perches <joe@perches.com>
---

v2: bah, now without unrelated changes to other staging files...

I'm not at all sure all the modifications are appropriate.

Some maybe should use the original format types like
%x instead of %p with *pointer instead of just pointer

 .../isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c      |  6 +++---
 .../isp/kernels/sdis/sdis_2/ia_css_sdis2.host.c       |  2 +-
 .../css2400/isp/kernels/tnr/tnr_1.0/ia_css_tnr.host.c |  2 +-
 .../css2400/runtime/debug/interface/ia_css_debug.h    |  1 +
 .../atomisp2/css2400/runtime/debug/src/ia_css_debug.c |  6 +++---
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c       | 19 ++++++++++---------
 .../media/atomisp/pci/atomisp2/css2400/sh_css_mipi.c  |  2 +-
 .../atomisp/pci/atomisp2/css2400/sh_css_params.c      | 10 +++++-----
 8 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c
index 0dde8425c67d..4c77e1463aaa 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c
@@ -265,9 +265,9 @@ ia_css_translate_dvs_statistics(
 	assert(isp_stats->hor_proj != NULL);
 	assert(isp_stats->ver_proj != NULL);
 
-	IA_CSS_ENTER("hproj=%p, vproj=%p, haddr=%x, vaddr=%x",
-			host_stats->hor_proj, host_stats->ver_proj,
-			isp_stats->hor_proj, isp_stats->ver_proj);
+	IA_CSS_ENTER("hproj=%p, vproj=%p, haddr=%p, vaddr=%p",
+		     host_stats->hor_proj, host_stats->ver_proj,
+		     isp_stats->hor_proj, isp_stats->ver_proj);
 
 	hor_num_isp = host_stats->grid.aligned_height;
 	ver_num_isp = host_stats->grid.aligned_width;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_2/ia_css_sdis2.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_2/ia_css_sdis2.host.c
index 930061d48df7..5ac81f87bfa3 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_2/ia_css_sdis2.host.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_2/ia_css_sdis2.host.c
@@ -213,7 +213,7 @@ ia_css_translate_dvs2_statistics(
 		     "hor_coefs.even_real=%p, hor_coefs.even_imag=%p, "
 		     "ver_coefs.odd_real=%p, ver_coefs.odd_imag=%p, "
 		     "ver_coefs.even_real=%p, ver_coefs.even_imag=%p, "
-		     "haddr=%x, vaddr=%x",
+		     "haddr=%p, vaddr=%p",
 		host_stats->hor_prod.odd_real, host_stats->hor_prod.odd_imag,
 		host_stats->hor_prod.even_real, host_stats->hor_prod.even_imag,
 		host_stats->ver_prod.odd_real, host_stats->ver_prod.odd_imag,
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/tnr/tnr_1.0/ia_css_tnr.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/tnr/tnr_1.0/ia_css_tnr.host.c
index 804c19ab4485..222a7bd7f176 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/tnr/tnr_1.0/ia_css_tnr.host.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/tnr/tnr_1.0/ia_css_tnr.host.c
@@ -55,7 +55,7 @@ ia_css_tnr_dump(
 			"tnr_coef", tnr->coef);
 	ia_css_debug_dtrace(level, "\t%-32s = %d\n",
 			"tnr_threshold_Y", tnr->threshold_Y);
-	ia_css_debug_dtrace(level, "\t%-32s = %d\n"
+	ia_css_debug_dtrace(level, "\t%-32s = %d\n",
 			"tnr_threshold_C", tnr->threshold_C);
 }
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/interface/ia_css_debug.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/interface/ia_css_debug.h
index be7df3a30c21..91c105cc6204 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/interface/ia_css_debug.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/interface/ia_css_debug.h
@@ -137,6 +137,7 @@ ia_css_debug_vdtrace(unsigned int level, const char *fmt, va_list args)
 		sh_css_vprint(fmt, args);
 }
 
+__printf(2, 3)
 extern void ia_css_debug_dtrace(unsigned int level, const char *fmt, ...);
 
 /*! @brief Dump sp thread's stack contents
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
index 030810bd0878..bcc0d464084f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
@@ -3148,8 +3148,8 @@ ia_css_debug_dump_pipe_config(
 		ia_css_debug_dump_frame_info(&config->vf_output_info[i],
 				"vf_output_info");
 	}
-	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "acc_extension: 0x%x\n",
-			config->acc_extension);
+	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "acc_extension: %p\n",
+			    config->acc_extension);
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "num_acc_stages: %d\n",
 			config->num_acc_stages);
 	ia_css_debug_dump_capture_config(&config->default_capture_config);
@@ -3179,7 +3179,7 @@ ia_css_debug_dump_stream_config_source(
 		ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "timeout: %d\n",
 				config->source.port.timeout);
 		ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "compression: %d\n",
-				config->source.port.compression);
+				config->source.port.compression.type);
 		break;
 	case IA_CSS_INPUT_MODE_TPG:
 		ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "source.tpg\n");
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 235944921d84..08feb25882fd 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -2003,7 +2003,7 @@ ia_css_enable_isys_event_queue(bool enable)
 
 void *sh_css_malloc(size_t size)
 {
-	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "sh_css_malloc() enter: size=%d\n",size);
+	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "sh_css_malloc() enter: size=%zu\n",size);
 	/* FIXME: This first test can probably go away */
 	if (size == 0)
 		return NULL;
@@ -2016,7 +2016,7 @@ void *sh_css_calloc(size_t N, size_t size)
 {
 	void *p;
 
-	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "sh_css_calloc() enter: N=%d, size=%d\n",N,size);
+	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "sh_css_calloc() enter: N=%zu, size=%zu\n",N,size);
 
 	/* FIXME: this test can probably go away */
 	if (size > 0) {
@@ -2059,7 +2059,8 @@ map_sp_threads(struct ia_css_stream *stream, bool map)
 	enum ia_css_pipe_id pipe_id;
 
 	assert(stream != NULL);
-	IA_CSS_ENTER_PRIVATE("stream = %p, map = %p", stream, map);
+	IA_CSS_ENTER_PRIVATE("stream = %p, map = %s",
+			     stream, map ? "true" : "false");
 
 	if (stream == NULL) {
 		IA_CSS_LEAVE_ERR_PRIVATE(IA_CSS_ERR_INVALID_ARGUMENTS);
@@ -2766,7 +2767,7 @@ enum ia_css_err ia_css_irq_translate(
 		*irq_infos = infos;
 
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "ia_css_irq_translate() "
-		"leave: irq_infos=%p\n", infos);
+		"leave: irq_infos=%u\n", infos);
 
 	return IA_CSS_SUCCESS;
 }
@@ -4514,7 +4515,7 @@ ia_css_pipe_enqueue_buffer(struct ia_css_pipe *pipe,
 #else
 		if (hmm_buffer_record) {
 #endif
-			IA_CSS_LOG("send vbuf=0x%x", h_vbuf);
+			IA_CSS_LOG("send vbuf=%p", h_vbuf);
 		} else {
 			return_err = IA_CSS_ERR_INTERNAL_ERROR;
 			IA_CSS_ERROR("hmm_buffer_record[]: no available slots\n");
@@ -4624,7 +4625,7 @@ ia_css_pipe_dequeue_buffer(struct ia_css_pipe *pipe,
 			ia_css_rmgr_rel_vbuf(hmm_buffer_pool, &hmm_buffer_record->h_vbuf);
 			sh_css_hmm_buffer_record_reset(hmm_buffer_record);
 		} else {
-			IA_CSS_ERROR("hmm_buffer_record not found (0x%p) buf_type(%d)",
+			IA_CSS_ERROR("hmm_buffer_record not found (0x%u) buf_type(%d)",
 				 ddr_buffer_addr, buf_type);
 			IA_CSS_LEAVE_ERR(IA_CSS_ERR_INTERNAL_ERROR);
 			return IA_CSS_ERR_INTERNAL_ERROR;
@@ -4640,8 +4641,8 @@ ia_css_pipe_dequeue_buffer(struct ia_css_pipe *pipe,
 		if ((ddr_buffer.kernel_ptr == 0) ||
 		    (kernel_ptr != HOST_ADDRESS(ddr_buffer.kernel_ptr))) {
 			IA_CSS_ERROR("kernel_ptr invalid");
-			IA_CSS_ERROR("expected: (0x%p)", kernel_ptr);
-			IA_CSS_ERROR("actual: (0x%p)", HOST_ADDRESS(ddr_buffer.kernel_ptr));
+			IA_CSS_ERROR("expected: (0x%llx)", (u64)kernel_ptr);
+			IA_CSS_ERROR("actual: (0x%llx)", (u64)HOST_ADDRESS(ddr_buffer.kernel_ptr));
 			IA_CSS_ERROR("buf_type: %d\n", buf_type);
 			IA_CSS_LEAVE_ERR(IA_CSS_ERR_INTERNAL_ERROR);
 			return IA_CSS_ERR_INTERNAL_ERROR;
@@ -6621,7 +6622,7 @@ allocate_delay_frames(struct ia_css_pipe *pipe)
 	IA_CSS_ENTER_PRIVATE("");
 
 	if (pipe == NULL) {
-		IA_CSS_ERROR("Invalid args - pipe %x", pipe);
+		IA_CSS_ERROR("Invalid args - pipe %p", pipe);
 		return IA_CSS_ERR_INVALID_ARGUMENTS;
 	}
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_mipi.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_mipi.c
index 7e3893c6c08a..36aaa3019a15 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_mipi.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_mipi.c
@@ -681,7 +681,7 @@ send_mipi_frames(struct ia_css_pipe *pipe)
 	unsigned int port = 0;
 #endif
 
-	IA_CSS_ENTER_PRIVATE("pipe=%d", pipe);
+	IA_CSS_ENTER_PRIVATE("pipe=%p", pipe);
 
 	assert(pipe != NULL);
 	assert(pipe->stream != NULL);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
index 6674f9609a2c..e2dc68a1ae1b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
@@ -3375,7 +3375,7 @@ enum ia_css_err ia_css_pipe_set_bci_scaler_lut(struct ia_css_pipe *pipe,
 #endif
 		if (pipe->scaler_pp_lut == mmgr_NULL) {
 #ifndef ISP2401
-			IA_CSS_LEAVE("lut(%p) err=%d", pipe->scaler_pp_lut, err);
+			IA_CSS_LEAVE("lut(%u) err=%d", pipe->scaler_pp_lut, err);
 			return IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 #else
 			ia_css_debug_dtrace(IA_CSS_DEBUG_ERROR,
@@ -3397,7 +3397,7 @@ enum ia_css_err ia_css_pipe_set_bci_scaler_lut(struct ia_css_pipe *pipe,
 #endif
 	}
 
-	IA_CSS_LEAVE("lut(%p) err=%d", pipe->scaler_pp_lut, err);
+	IA_CSS_LEAVE("lut(%u) err=%d", pipe->scaler_pp_lut, err);
 	return err;
 }
 
@@ -3437,7 +3437,7 @@ enum ia_css_err sh_css_params_map_and_store_default_gdc_lut(void)
 	mmgr_store(default_gdc_lut, (int *)interleaved_lut_temp,
 		sizeof(zoom_table));
 
-	IA_CSS_LEAVE_PRIVATE("lut(%p) err=%d", default_gdc_lut, err);
+	IA_CSS_LEAVE_PRIVATE("lut(%u) err=%d", default_gdc_lut, err);
 	return err;
 }
 
@@ -3859,7 +3859,7 @@ sh_css_param_update_isp_params(struct ia_css_pipe *curr_pipe,
 		/* When API change is implemented making good distinction between
 		* stream config and pipe config this skipping code can be moved out of the #ifdef */
 		if (pipe_in && (pipe != pipe_in)) {
-			IA_CSS_LOG("skipping pipe %x", pipe);
+			IA_CSS_LOG("skipping pipe %p", pipe);
 			continue;
 		}
 
@@ -4590,7 +4590,7 @@ free_ia_css_isp_parameter_set_info(
 	unsigned int i;
 	hrt_vaddress *addrs = (hrt_vaddress *)&isp_params_info.mem_map;
 
-	IA_CSS_ENTER_PRIVATE("ptr = %p", ptr);
+	IA_CSS_ENTER_PRIVATE("ptr = %u", ptr);
 
 	/* sanity check - ptr must be valid */
 	if (!ia_css_refcount_is_valid(ptr)) {
-- 
2.10.0.rc2.1.g053435c
