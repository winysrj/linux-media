Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:38422 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030511AbdEZP3T (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 11:29:19 -0400
Subject: [PATCH 08/11] atomisp: Unify load_preview_binaries for the most part
From: Alan Cox <alan@llwyncelyn.cymru>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Date: Fri, 26 May 2017 16:29:15 +0100
Message-ID: <149581254152.17585.17036659992372839972.stgit@builder>
In-Reply-To: <149581243155.17585.8164899156710160858.stgit@builder>
References: <149581243155.17585.8164899156710160858.stgit@builder>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ISP2401 introduced a rather sensible change to cut through the structure
spaghetti. Adopt that for the ISP2400 as well. It makes no difference to the
actual code other than readability.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |   40 +-------------------
 1 file changed, 1 insertion(+), 39 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 8e1cd12..55d2a69 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -2923,11 +2923,8 @@ load_preview_binaries(struct ia_css_pipe *pipe)
 #endif
 	/* preview only have 1 output pin now */
 	struct ia_css_frame_info *pipe_out_info = &pipe->output_info[0];
-#ifdef ISP2401
 	struct ia_css_preview_settings *mycs  = &pipe->pipe_settings.preview;
 
-#endif
-
 	IA_CSS_ENTER_PRIVATE("");
 	assert(pipe != NULL);
 	assert(pipe->stream != NULL);
@@ -2939,11 +2936,7 @@ load_preview_binaries(struct ia_css_pipe *pipe)
 	sensor = pipe->stream->config.mode == IA_CSS_INPUT_MODE_SENSOR;
 #endif
 
-#ifndef ISP2401
-	if (pipe->pipe_settings.preview.preview_binary.info)
-#else
 	if (mycs->preview_binary.info)
-#endif
 		return IA_CSS_SUCCESS;
 
 	err = ia_css_util_check_input(&pipe->stream->config, false, false);
@@ -2996,12 +2989,7 @@ load_preview_binaries(struct ia_css_pipe *pipe)
 			&prev_vf_info);
 	if (err != IA_CSS_SUCCESS)
 		return err;
-	err = ia_css_binary_find(&preview_descr,
-#ifndef ISP2401
-				 &pipe->pipe_settings.preview.preview_binary);
-#else
-				 &mycs->preview_binary);
-#endif
+	err = ia_css_binary_find(&preview_descr, &mycs->preview_binary);
 	if (err != IA_CSS_SUCCESS)
 		return err;
 
@@ -3017,24 +3005,15 @@ load_preview_binaries(struct ia_css_pipe *pipe)
 
 #endif
 	/* The vf_pp binary is needed when (further) YUV downscaling is required */
-#ifndef ISP2401
-	need_vf_pp |= pipe->pipe_settings.preview.preview_binary.out_frame_info[0].res.width != pipe_out_info->res.width;
-	need_vf_pp |= pipe->pipe_settings.preview.preview_binary.out_frame_info[0].res.height != pipe_out_info->res.height;
-#else
 	need_vf_pp |= mycs->preview_binary.out_frame_info[0].res.width != pipe_out_info->res.width;
 	need_vf_pp |= mycs->preview_binary.out_frame_info[0].res.height != pipe_out_info->res.height;
-#endif
 
 	/* When vf_pp is needed, then the output format of the selected
 	 * preview binary must be yuv_line. If this is not the case,
 	 * then the preview binary selection is done again.
 	 */
 	if (need_vf_pp &&
-#ifndef ISP2401
-		(pipe->pipe_settings.preview.preview_binary.out_frame_info[0].format != IA_CSS_FRAME_FORMAT_YUV_LINE)) {
-#else
 		(mycs->preview_binary.out_frame_info[0].format != IA_CSS_FRAME_FORMAT_YUV_LINE)) {
-#endif
 
 		/* Preview step 2 */
 		if (pipe->vf_yuv_ds_input_info.res.width)
@@ -3055,11 +3034,7 @@ load_preview_binaries(struct ia_css_pipe *pipe)
 		if (err != IA_CSS_SUCCESS)
 			return err;
 		err = ia_css_binary_find(&preview_descr,
-#ifndef ISP2401
-				&pipe->pipe_settings.preview.preview_binary);
-#else
 				&mycs->preview_binary);
-#endif
 		if (err != IA_CSS_SUCCESS)
 			return err;
 	}
@@ -3069,18 +3044,10 @@ load_preview_binaries(struct ia_css_pipe *pipe)
 
 		/* Viewfinder post-processing */
 		ia_css_pipe_get_vfpp_binarydesc(pipe, &vf_pp_descr,
-#ifndef ISP2401
-			&pipe->pipe_settings.preview.preview_binary.out_frame_info[0],
-#else
 			&mycs->preview_binary.out_frame_info[0],
-#endif
 			pipe_out_info);
 		err = ia_css_binary_find(&vf_pp_descr,
-#ifndef ISP2401
-				 &pipe->pipe_settings.preview.vf_pp_binary);
-#else
 				 &mycs->vf_pp_binary);
-#endif
 		if (err != IA_CSS_SUCCESS)
 			return err;
 	}
@@ -3106,13 +3073,8 @@ load_preview_binaries(struct ia_css_pipe *pipe)
 	/* Copy */
 	if (need_isp_copy_binary) {
 		err = load_copy_binary(pipe,
-#ifndef ISP2401
-				       &pipe->pipe_settings.preview.copy_binary,
-				       &pipe->pipe_settings.preview.preview_binary);
-#else
 				       &mycs->copy_binary,
 				       &mycs->preview_binary);
-#endif
 		if (err != IA_CSS_SUCCESS)
 			return err;
 	}
