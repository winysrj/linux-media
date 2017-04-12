Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:22252 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752643AbdDLSVu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 14:21:50 -0400
Subject: [PATCH 09/14] atomisp: remove sh_css_malloc indirections where we
 can
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Wed, 12 Apr 2017 19:21:44 +0100
Message-ID: <149202130247.16615.11836471432945037118.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
References: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Where we know the buffer size is reasonably constrained we can just use kmalloc,
and where it will be large vmalloc. This still leaves a pile in the middle.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |   92 ++++++++++----------
 .../atomisp/pci/atomisp2/css2400/sh_css_firmware.c |   29 +++---
 .../pci/atomisp2/css2400/sh_css_host_data.c        |    8 +-
 .../pci/atomisp2/css2400/sh_css_param_shading.c    |    8 +-
 4 files changed, 72 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 30f7196..2359449 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -2492,19 +2492,19 @@ create_pipe(enum ia_css_pipe_mode mode,
 		return IA_CSS_ERR_INVALID_ARGUMENTS;
 	}
 
-	me = sh_css_malloc(sizeof(*me));
+	me = kmalloc(sizeof(*me), GFP_KERNEL);
 	if (!me)
 		return IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 
 	err = init_pipe_defaults(mode, me, copy_pipe);
 	if (err != IA_CSS_SUCCESS) {
-		sh_css_free(me);
+		kfree(me);
 		return err;
 	}
 
 	err = pipe_generate_pipe_num(me, &(me->pipe_num));
 	if (err != IA_CSS_SUCCESS) {
-		sh_css_free(me);
+		kfree(me);
 		return err;
 	}
 
@@ -2631,7 +2631,7 @@ ia_css_pipe_destroy(struct ia_css_pipe *pipe)
 	if (pipe->config.acc_extension) {
 		ia_css_pipe_unload_extension(pipe, pipe->config.acc_extension);
 	}
-	sh_css_free(pipe);
+	kfree(pipe);
 	IA_CSS_LEAVE("err = %d", err);
 	return err;
 }
@@ -5764,14 +5764,14 @@ static enum ia_css_err load_video_binaries(struct ia_css_pipe *pipe)
 		if (err != IA_CSS_SUCCESS)
 			return err;
 		mycs->num_yuv_scaler = cas_scaler_descr.num_stage;
-		mycs->yuv_scaler_binary = sh_css_calloc(cas_scaler_descr.num_stage,
-			sizeof(struct ia_css_binary));
+		mycs->yuv_scaler_binary = kzalloc(cas_scaler_descr.num_stage *
+			sizeof(struct ia_css_binary), GFP_KERNEL);
 		if (mycs->yuv_scaler_binary == NULL) {
 			err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 			return err;
 		}
-		mycs->is_output_stage = sh_css_calloc(cas_scaler_descr.num_stage,
-			sizeof(bool));
+		mycs->is_output_stage = kzalloc(cas_scaler_descr.num_stage
+					* sizeof(bool), GFP_KERNEL);
 		if (mycs->is_output_stage == NULL) {
 			err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 			return err;
@@ -5787,7 +5787,7 @@ static enum ia_css_err load_video_binaries(struct ia_css_pipe *pipe)
 			err = ia_css_binary_find(&yuv_scaler_descr,
 						&mycs->yuv_scaler_binary[i]);
 			if (err != IA_CSS_SUCCESS) {
-				sh_css_free(mycs->is_output_stage);
+				kfree(mycs->is_output_stage);
 				mycs->is_output_stage = NULL;
 				return err;
 			}
@@ -6008,9 +6008,9 @@ unload_video_binaries(struct ia_css_pipe *pipe)
 	for (i = 0; i < pipe->pipe_settings.video.num_yuv_scaler; i++)
 		ia_css_binary_unload(&pipe->pipe_settings.video.yuv_scaler_binary[i]);
 
-	sh_css_free(pipe->pipe_settings.video.is_output_stage);
+	kfree(pipe->pipe_settings.video.is_output_stage);
 	pipe->pipe_settings.video.is_output_stage = NULL;
-	sh_css_free(pipe->pipe_settings.video.yuv_scaler_binary);
+	kfree(pipe->pipe_settings.video.yuv_scaler_binary);
 	pipe->pipe_settings.video.yuv_scaler_binary = NULL;
 
 	IA_CSS_LEAVE_ERR_PRIVATE(IA_CSS_SUCCESS);
@@ -6418,15 +6418,15 @@ static enum ia_css_err load_primary_binaries(
 			return err;
 		}
 		mycs->num_yuv_scaler = cas_scaler_descr.num_stage;
-		mycs->yuv_scaler_binary = sh_css_calloc(cas_scaler_descr.num_stage,
-			sizeof(struct ia_css_binary));
+		mycs->yuv_scaler_binary = kzalloc(cas_scaler_descr.num_stage *
+			sizeof(struct ia_css_binary), GFP_KERNEL);
 		if (mycs->yuv_scaler_binary == NULL) {
 			err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 			IA_CSS_LEAVE_ERR_PRIVATE(err);
 			return err;
 		}
-		mycs->is_output_stage = sh_css_calloc(cas_scaler_descr.num_stage,
-			sizeof(bool));
+		mycs->is_output_stage = kzalloc(cas_scaler_descr.num_stage *
+			sizeof(bool), GFP_KERNEL);
 		if (mycs->is_output_stage == NULL) {
 			err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 			IA_CSS_LEAVE_ERR_PRIVATE(err);
@@ -7068,9 +7068,9 @@ unload_capture_binaries(struct ia_css_pipe *pipe)
 	for (i = 0; i < pipe->pipe_settings.capture.num_yuv_scaler; i++)
 		ia_css_binary_unload(&pipe->pipe_settings.capture.yuv_scaler_binary[i]);
 
-	sh_css_free(pipe->pipe_settings.capture.is_output_stage);
+	kfree(pipe->pipe_settings.capture.is_output_stage);
 	pipe->pipe_settings.capture.is_output_stage = NULL;
-	sh_css_free(pipe->pipe_settings.capture.yuv_scaler_binary);
+	kfree(pipe->pipe_settings.capture.yuv_scaler_binary);
 	pipe->pipe_settings.capture.yuv_scaler_binary = NULL;
 
 	IA_CSS_LEAVE_ERR_PRIVATE(IA_CSS_SUCCESS);
@@ -7159,27 +7159,27 @@ static enum ia_css_err ia_css_pipe_create_cas_scaler_desc_single_output(
 		i *= max_scale_factor_per_stage;
 	}
 
-	descr->in_info = sh_css_malloc(descr->num_stage * sizeof(struct ia_css_frame_info));
+	descr->in_info = kmalloc(descr->num_stage * sizeof(struct ia_css_frame_info), GFP_KERNEL);
 	if (descr->in_info == NULL) {
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		goto ERR;
 	}
-	descr->internal_out_info = sh_css_malloc(descr->num_stage * sizeof(struct ia_css_frame_info));
+	descr->internal_out_info = kmalloc(descr->num_stage * sizeof(struct ia_css_frame_info), GFP_KERNEL);
 	if (descr->internal_out_info == NULL) {
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		goto ERR;
 	}
-	descr->out_info = sh_css_malloc(descr->num_stage * sizeof(struct ia_css_frame_info));
+	descr->out_info = kmalloc(descr->num_stage * sizeof(struct ia_css_frame_info), GFP_KERNEL);
 	if (descr->out_info == NULL) {
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		goto ERR;
 	}
-	descr->vf_info = sh_css_malloc(descr->num_stage * sizeof(struct ia_css_frame_info));
+	descr->vf_info = kmalloc(descr->num_stage * sizeof(struct ia_css_frame_info), GFP_KERNEL);
 	if (descr->vf_info == NULL) {
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		goto ERR;
 	}
-	descr->is_output_stage = sh_css_malloc(descr->num_stage * sizeof(bool));
+	descr->is_output_stage = kmalloc(descr->num_stage * sizeof(bool), GFP_KERNEL);
 	if (descr->is_output_stage == NULL) {
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		goto ERR;
@@ -7237,6 +7237,7 @@ static enum ia_css_err ia_css_pipe_create_cas_scaler_desc_single_output(
 	return err;
 }
 
+/* FIXME: merge most of this and single output version */
 static enum ia_css_err ia_css_pipe_create_cas_scaler_desc(struct ia_css_pipe *pipe,
 	struct ia_css_cas_binary_descr *descr)
 {
@@ -7294,27 +7295,27 @@ static enum ia_css_err ia_css_pipe_create_cas_scaler_desc(struct ia_css_pipe *pi
 
 	descr->num_stage = num_stages;
 
-	descr->in_info = sh_css_malloc(descr->num_stage * sizeof(struct ia_css_frame_info));
+	descr->in_info = kmalloc(descr->num_stage * sizeof(struct ia_css_frame_info), GFP_KERNEL);
 	if (descr->in_info == NULL) {
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		goto ERR;
 	}
-	descr->internal_out_info = sh_css_malloc(descr->num_stage * sizeof(struct ia_css_frame_info));
+	descr->internal_out_info = kmalloc(descr->num_stage * sizeof(struct ia_css_frame_info), GFP_KERNEL);
 	if (descr->internal_out_info == NULL) {
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		goto ERR;
 	}
-	descr->out_info = sh_css_malloc(descr->num_stage * sizeof(struct ia_css_frame_info));
+	descr->out_info = kmalloc(descr->num_stage * sizeof(struct ia_css_frame_info), GFP_KERNEL);
 	if (descr->out_info == NULL) {
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		goto ERR;
 	}
-	descr->vf_info = sh_css_malloc(descr->num_stage * sizeof(struct ia_css_frame_info));
+	descr->vf_info = kmalloc(descr->num_stage * sizeof(struct ia_css_frame_info), GFP_KERNEL);
 	if (descr->vf_info == NULL) {
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		goto ERR;
 	}
-	descr->is_output_stage = sh_css_malloc(descr->num_stage * sizeof(bool));
+	descr->is_output_stage = kmalloc(descr->num_stage * sizeof(bool), GFP_KERNEL);
 	if (descr->is_output_stage == NULL) {
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		goto ERR;
@@ -7388,15 +7389,15 @@ static enum ia_css_err ia_css_pipe_create_cas_scaler_desc(struct ia_css_pipe *pi
 static void ia_css_pipe_destroy_cas_scaler_desc(struct ia_css_cas_binary_descr *descr)
 {
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "ia_css_pipe_destroy_cas_scaler_desc() enter:\n");
-	sh_css_free(descr->in_info);
+	kfree(descr->in_info);
 	descr->in_info = NULL;
-	sh_css_free(descr->internal_out_info);
+	kfree(descr->internal_out_info);
 	descr->internal_out_info = NULL;
-	sh_css_free(descr->out_info);
+	kfree(descr->out_info);
 	descr->out_info = NULL;
-	sh_css_free(descr->vf_info);
+	kfree(descr->vf_info);
 	descr->vf_info = NULL;
-	sh_css_free(descr->is_output_stage);
+	kfree(descr->is_output_stage);
 	descr->is_output_stage = NULL;
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE, "ia_css_pipe_destroy_cas_scaler_desc() leave\n");
 }
@@ -7451,14 +7452,14 @@ load_yuvpp_binaries(struct ia_css_pipe *pipe)
 			goto ERR;
 		mycs->num_output = cas_scaler_descr.num_output_stage;
 		mycs->num_yuv_scaler = cas_scaler_descr.num_stage;
-		mycs->yuv_scaler_binary = sh_css_calloc(cas_scaler_descr.num_stage,
-			sizeof(struct ia_css_binary));
+		mycs->yuv_scaler_binary = kzalloc(cas_scaler_descr.num_stage *
+			sizeof(struct ia_css_binary), GFP_KERNEL);
 		if (mycs->yuv_scaler_binary == NULL) {
 			err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 			goto ERR;
 		}
-		mycs->is_output_stage = sh_css_calloc(cas_scaler_descr.num_stage,
-			sizeof(bool));
+		mycs->is_output_stage = kzalloc(cas_scaler_descr.num_stage *
+			sizeof(bool), GFP_KERNEL);
 		if (mycs->is_output_stage == NULL) {
 			err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 			goto ERR;
@@ -7558,7 +7559,8 @@ load_yuvpp_binaries(struct ia_css_pipe *pipe)
 		}
 		mycs->num_vf_pp = 1;
 	}
-	mycs->vf_pp_binary = sh_css_calloc(mycs->num_vf_pp, sizeof(struct ia_css_binary));
+	mycs->vf_pp_binary = kzalloc(mycs->num_vf_pp * sizeof(struct ia_css_binary),
+						GFP_KERNEL);
 	if (mycs->vf_pp_binary == NULL) {
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		goto ERR;
@@ -7607,11 +7609,11 @@ unload_yuvpp_binaries(struct ia_css_pipe *pipe)
 	for (i = 0; i < pipe->pipe_settings.yuvpp.num_vf_pp; i++) {
 		ia_css_binary_unload(&pipe->pipe_settings.yuvpp.vf_pp_binary[i]);
 	}
-	sh_css_free(pipe->pipe_settings.yuvpp.is_output_stage);
+	kfree(pipe->pipe_settings.yuvpp.is_output_stage);
 	pipe->pipe_settings.yuvpp.is_output_stage = NULL;
-	sh_css_free(pipe->pipe_settings.yuvpp.yuv_scaler_binary);
+	kfree(pipe->pipe_settings.yuvpp.yuv_scaler_binary);
 	pipe->pipe_settings.yuvpp.yuv_scaler_binary = NULL;
-	sh_css_free(pipe->pipe_settings.yuvpp.vf_pp_binary);
+	kfree(pipe->pipe_settings.yuvpp.vf_pp_binary);
 	pipe->pipe_settings.yuvpp.vf_pp_binary = NULL;
 
 	IA_CSS_LEAVE_ERR_PRIVATE(IA_CSS_SUCCESS);
@@ -9625,7 +9627,7 @@ ia_css_stream_create(const struct ia_css_stream_config *stream_config,
 	}
 
 	/* allocate the stream instance */
-	curr_stream = sh_css_malloc(sizeof(struct ia_css_stream));
+	curr_stream = kmalloc(sizeof(struct ia_css_stream), GFP_KERNEL);
 	if (curr_stream == NULL) {
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		IA_CSS_LEAVE_ERR(err);
@@ -9637,10 +9639,10 @@ ia_css_stream_create(const struct ia_css_stream_config *stream_config,
 
 	/* allocate pipes */
 	curr_stream->num_pipes = num_pipes;
-	curr_stream->pipes = sh_css_malloc(num_pipes * sizeof(struct ia_css_pipe *));
+	curr_stream->pipes = kzalloc(num_pipes * sizeof(struct ia_css_pipe *), GFP_KERNEL);
 	if (curr_stream->pipes == NULL) {
 		curr_stream->num_pipes = 0;
-		sh_css_free(curr_stream);
+		kfree(curr_stream);
 		curr_stream = NULL;
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		IA_CSS_LEAVE_ERR(err);
@@ -10103,7 +10105,7 @@ ia_css_stream_destroy(struct ia_css_stream *stream)
 		}
 	}
 	/* free associated memory of stream struct */
-	sh_css_free(stream->pipes);
+	kfree(stream->pipes);
 	stream->pipes = NULL;
 	stream->num_pipes = 0;
 #ifndef ISP2401
@@ -10121,7 +10123,7 @@ ia_css_stream_destroy(struct ia_css_stream *stream)
 
 	err1 = (err != IA_CSS_SUCCESS) ? err : err2;
 #endif
-	sh_css_free(stream);
+	kfree(stream);
 #ifndef ISP2401
 	IA_CSS_LEAVE_ERR(err);
 #else
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
index 95f72e5..34cc56f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
@@ -12,6 +12,9 @@
  * more details.
  */
 
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+
 #include <math_support.h>
 #include "platform_support.h"
 #include "sh_css_firmware.h"
@@ -93,9 +96,9 @@ setup_binary(struct ia_css_fw_info *fw, const char *fw_data, struct ia_css_fw_in
 	*sh_css_fw = *fw;
 
 #if defined(HRT_UNSCHED)
-	sh_css_fw->blob.code = sh_css_malloc(1);
+	sh_css_fw->blob.code = vmalloc(1);
 #else
-	sh_css_fw->blob.code = sh_css_malloc(fw->blob.size);
+	sh_css_fw->blob.code = vmalloc(fw->blob.size);
 #endif
 
 	if (sh_css_fw->blob.code == NULL)
@@ -143,11 +146,11 @@ sh_css_load_blob_info(const char *fw, const struct ia_css_fw_info *bi, struct ia
 		char *namebuffer;
 		int namelength = (int)strlen(name);
 
-		namebuffer = (char *) sh_css_malloc(namelength+1);
+		namebuffer = (char *) kmalloc(namelength + 1, GFP_KERNEL);
 		if (namebuffer == NULL)
 			return IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 
-		memcpy(namebuffer, name, namelength+1);
+		memcpy(namebuffer, name, namelength + 1);
 
 		bd->name = fw_minibuffer[index].name = namebuffer;
 	} else {
@@ -159,7 +162,8 @@ sh_css_load_blob_info(const char *fw, const struct ia_css_fw_info *bi, struct ia
 		size_t configstruct_size = sizeof(struct ia_css_config_memory_offsets);
 		size_t statestruct_size = sizeof(struct ia_css_state_memory_offsets);
 
-		char *parambuf = (char *) sh_css_malloc(paramstruct_size + configstruct_size + statestruct_size);
+		char *parambuf = (char *)kmalloc(paramstruct_size + configstruct_size + statestruct_size,
+							GFP_KERNEL);
 		if (parambuf == NULL)
 			return IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 
@@ -239,19 +243,18 @@ sh_css_load_firmware(const char *fw_data,
 	sh_css_num_binaries = file_header->binary_nr;
 	/* Only allocate memory for ISP blob info */
 	if (sh_css_num_binaries > (NUM_OF_SPS + NUM_OF_BLS)) {
-		sh_css_blob_info = sh_css_malloc(
+		sh_css_blob_info = kmalloc(
 					(sh_css_num_binaries - (NUM_OF_SPS + NUM_OF_BLS)) *
-					sizeof(*sh_css_blob_info));
+					sizeof(*sh_css_blob_info), GFP_KERNEL);
 		if (sh_css_blob_info == NULL)
 			return IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 	} else {
 		sh_css_blob_info = NULL;
 	}
 
-	fw_minibuffer = sh_css_malloc(sh_css_num_binaries * sizeof(struct fw_param));
+	fw_minibuffer = kzalloc(sh_css_num_binaries * sizeof(struct fw_param), GFP_KERNEL);
 	if (fw_minibuffer == NULL)
 		return IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
-	memset(fw_minibuffer, 0, sh_css_num_binaries * sizeof(struct fw_param));
 
 	for (i = 0; i < sh_css_num_binaries; i++) {
 		struct ia_css_fw_info *bi = &binaries[i];
@@ -309,17 +312,17 @@ void sh_css_unload_firmware(void)
 		unsigned int i = 0;
 		for (i = 0; i < sh_css_num_binaries; i++) {
 			if (fw_minibuffer[i].name)
-				sh_css_free((void *)fw_minibuffer[i].name);
+				kfree((void *)fw_minibuffer[i].name);
 			if (fw_minibuffer[i].buffer)
-				sh_css_free((void *)fw_minibuffer[i].buffer);
+				vfree((void *)fw_minibuffer[i].buffer);
 		}
-		sh_css_free(fw_minibuffer);
+		kfree(fw_minibuffer);
 		fw_minibuffer = NULL;
 	}
 
 	memset(&sh_css_sp_fw, 0, sizeof(sh_css_sp_fw));
 	if (sh_css_blob_info) {
-		sh_css_free(sh_css_blob_info);
+		kfree(sh_css_blob_info);
 		sh_css_blob_info = NULL;
 	}
 	sh_css_num_binaries = 0;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_host_data.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_host_data.c
index 1919497..348183a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_host_data.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_host_data.c
@@ -12,7 +12,7 @@
  * more details.
  */
 
-#include <stddef.h>
+#include <linux/slab.h>
 #include <ia_css_host_data.h>
 #include <sh_css_internal.h>
 
@@ -20,13 +20,13 @@ struct ia_css_host_data *ia_css_host_data_allocate(size_t size)
 {
 	struct ia_css_host_data *me;
 
-	me =  sh_css_malloc(sizeof(struct ia_css_host_data));
+	me =  kmalloc(sizeof(struct ia_css_host_data), GFP_KERNEL);
 	if (!me)
 		return NULL;
 	me->size = (uint32_t)size;
 	me->address = sh_css_malloc(size);
 	if (!me->address) {
-		sh_css_free(me);
+		kfree(me);
 		return NULL;
 	}
 	return me;
@@ -37,6 +37,6 @@ void ia_css_host_data_free(struct ia_css_host_data *me)
 	if (me) {
 		sh_css_free(me->address);
 		me->address = NULL;
-		sh_css_free(me);
+		kfree(me);
 	}
 }
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_param_shading.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_param_shading.c
index 7c600fa..eaf60e7 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_param_shading.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_param_shading.c
@@ -12,6 +12,8 @@
  * more details.
  */
 
+#include <linux/slab.h>
+
 #include <math_support.h>
 #include "sh_css_param_shading.h"
 #include "ia_css_shading.h"
@@ -362,7 +364,7 @@ ia_css_shading_table_alloc(
 
 	IA_CSS_ENTER("");
 
-	me = sh_css_malloc(sizeof(*me));
+	me = kmalloc(sizeof(*me), GFP_KERNEL);
 	if (me == NULL) {
 		IA_CSS_ERROR("out of memory");
 		return me;
@@ -382,7 +384,7 @@ ia_css_shading_table_alloc(
 				sh_css_free(me->data[j]);
 				me->data[j] = NULL;
 			}
-			sh_css_free(me);
+			kfree(me);
 			return NULL;
 		}
 	}
@@ -410,7 +412,7 @@ ia_css_shading_table_free(struct ia_css_shading_table *table)
 			table->data[i] = NULL;
 		}
 	}
-	sh_css_free(table);
+	kfree(table);
 
 	IA_CSS_LEAVE("");
 }
