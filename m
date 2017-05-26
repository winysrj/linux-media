Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:38414 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1947898AbdEZP2p (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 11:28:45 -0400
Subject: [PATCHv2 06/11] atomisp: eliminate dead code under HAS_RES_MGR
From: Alan Cox <alan@llwyncelyn.cymru>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Date: Fri, 26 May 2017 16:28:41 +0100
Message-ID: <149581249137.17585.7671505437752443891.stgit@builder>
In-Reply-To: <149581243155.17585.8164899156710160858.stgit@builder>
References: <149581243155.17585.8164899156710160858.stgit@builder>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This define is never set and these code paths are never used so they can go
away.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../css2400/isp/modes/interface/isp_const.h        |   16 ---------
 .../css2400/isp/modes/interface/isp_exprs.h        |   23 --------------
 .../atomisp2/css2400/runtime/binary/src/binary.c   |   34 --------------------
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |   30 ------------------
 4 files changed, 103 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/modes/interface/isp_const.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/modes/interface/isp_const.h
index 005eaaa..2f215dc 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/modes/interface/isp_const.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/modes/interface/isp_const.h
@@ -398,17 +398,6 @@ more details.
  * so the calc for the output buffer vmem size is:
  * ((width[vectors]/num_of_stripes) + 2[vectors])
  */
-#if defined(HAS_RES_MGR)
-#define MAX_VECTORS_PER_OUTPUT_LINE \
-	(CEIL_DIV(CEIL_DIV(ISP_MAX_OUTPUT_WIDTH, ISP_NUM_STRIPES) + ISP_LEFT_PADDING, ISP_VEC_NELEMS) + \
-	ITERATOR_VECTOR_INCREMENT)
-
-#define MAX_VECTORS_PER_INPUT_LINE	CEIL_DIV(ISP_MAX_INPUT_WIDTH, ISP_VEC_NELEMS)
-#define MAX_VECTORS_PER_INPUT_STRIPE	(CEIL_ROUND_DIV_STRIPE(CEIL_DIV(ISP_MAX_INPUT_WIDTH, ISP_VEC_NELEMS) , \
-							      ISP_NUM_STRIPES, \
-							      ISP_LEFT_PADDING_VECS) + \
-							      ITERATOR_VECTOR_INCREMENT)
-#else /* !defined(HAS_RES_MGR)*/
 #define MAX_VECTORS_PER_OUTPUT_LINE \
 	CEIL_DIV(CEIL_DIV(ISP_MAX_OUTPUT_WIDTH, ISP_NUM_STRIPES) + ISP_LEFT_PADDING, ISP_VEC_NELEMS)
 
@@ -417,7 +406,6 @@ more details.
 #define MAX_VECTORS_PER_INPUT_STRIPE	CEIL_ROUND_DIV_STRIPE(MAX_VECTORS_PER_INPUT_LINE, \
 							      ISP_NUM_STRIPES, \
 							      ISP_LEFT_PADDING_VECS)
-#endif /* HAS_RES_MGR */
 
 
 /* Add 2 for left croppping */
@@ -470,15 +458,11 @@ more details.
 
 #define RAW_BUF_LINES ((ENABLE_RAW_BINNING || ENABLE_FIXED_BAYER_DS) ? 4 : 2)
 
-#if defined(HAS_RES_MGR)
-#define RAW_BUF_STRIDE (MAX_VECTORS_PER_INPUT_STRIPE)
-#else /* !defined(HAS_RES_MGR) */
 #define RAW_BUF_STRIDE \
 	(BINARY_ID == SH_CSS_BINARY_ID_POST_ISP ? MAX_VECTORS_PER_INPUT_CHUNK : \
 	 ISP_NUM_STRIPES > 1 ? MAX_VECTORS_PER_INPUT_STRIPE+_ISP_EXTRA_PADDING_VECS : \
 	 !ENABLE_CONTINUOUS ? MAX_VECTORS_PER_INPUT_LINE : \
 	 MAX_VECTORS_PER_INPUT_CHUNK)
-#endif /* HAS_RES_MGR */
 
 /* [isp vmem] table size[vectors] per line per color (GR,R,B,GB),
    multiples of NWAY */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/modes/interface/isp_exprs.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/modes/interface/isp_exprs.h
index 8b59a8c..e625ba6 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/modes/interface/isp_exprs.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/modes/interface/isp_exprs.h
@@ -214,24 +214,6 @@ more details.
 /******* STRIPING-RELATED MACROS *******/
 #define NO_STRIPING (ISP_NUM_STRIPES == 1)
 
-#if defined(HAS_RES_MGR)
-
-#define ISP_OUTPUT_CHUNK_VECS ISP_INTERNAL_WIDTH_VECS
-
-#if defined(__ISP)
-#define VECTORS_PER_LINE ISP_INTERNAL_WIDTH_VECS
-#else
-#define VECTORS_PER_LINE \
-	(NO_STRIPING 	? ISP_INTERNAL_WIDTH_VECS \
-				: ISP_IO_STRIPE_WIDTH_VECS(ISP_INTERNAL_WIDTH_VECS, ISP_LEFT_PADDING_VECS, ISP_NUM_STRIPES, ISP_MIN_STRIPE_WIDTH) )
-#endif
-
-#define VECTORS_PER_INPUT_LINE \
-	(NO_STRIPING 	? ISP_INPUT_WIDTH_VECS \
-				: ISP_IO_STRIPE_WIDTH_VECS(ISP_INPUT_WIDTH_VECS, ISP_LEFT_PADDING_VECS, ISP_NUM_STRIPES, ISP_MIN_STRIPE_WIDTH) )
-
-#else
-
 #define ISP_OUTPUT_CHUNK_VECS \
 	(NO_STRIPING 	? CEIL_DIV_CHUNKS(ISP_OUTPUT_VECS_EXTRA_CROP, OUTPUT_NUM_CHUNKS) \
 				: ISP_IO_STRIPE_WIDTH_VECS(ISP_OUTPUT_VECS_EXTRA_CROP, ISP_LEFT_PADDING_VECS, ISP_NUM_STRIPES, ISP_MIN_STRIPE_WIDTH) )
@@ -244,7 +226,6 @@ more details.
 	(NO_STRIPING 	? ISP_INPUT_WIDTH_VECS \
 				: ISP_IO_STRIPE_WIDTH_VECS(ISP_INPUT_WIDTH_VECS, ISP_LEFT_PADDING_VECS, ISP_NUM_STRIPES, ISP_MIN_STRIPE_WIDTH)+_ISP_EXTRA_PADDING_VECS)
 
-#endif
 
 #define ISP_MAX_VF_OUTPUT_STRIPE_VECS \
 	(NO_STRIPING 	? ISP_MAX_VF_OUTPUT_VECS \
@@ -282,11 +263,7 @@ more details.
 #define OUTPUT_VECTORS_PER_CHUNK	CEIL_DIV_CHUNKS(VECTORS_PER_LINE,OUTPUT_NUM_CHUNKS)
 
 /* should be even?? */
-#if !defined(HAS_RES_MGR)
 #define OUTPUT_C_VECTORS_PER_CHUNK  	CEIL_DIV(OUTPUT_VECTORS_PER_CHUNK, 2)
-#else
-#define OUTPUT_C_VECTORS_PER_CHUNK  	CEIL_DIV(MAX_VECTORS_PER_CHUNK, 2)
-#endif
 
 #ifndef ISP2401
 /**** SCTBL defs *******/
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c
index ae0b229..9f8a125 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c
@@ -36,10 +36,6 @@
 #endif
 
 #include "camera/pipe/interface/ia_css_pipe_binarydesc.h"
-#if defined(HAS_RES_MGR)
-#include <components/resolutions_mgr/src/host/resolutions_mgr.host.h>
-#include <components/acc_cluster/acc_dvs_stat/host/dvs_stat.host.h>
-#endif
 
 #include "memory_access.h"
 
@@ -110,10 +106,6 @@ ia_css_binary_internal_res(const struct ia_css_frame_info *in_info,
 	internal_res->height = __ISP_INTERNAL_HEIGHT(isp_tmp_internal_height,
 		info->pipeline.top_cropping,
 		binary_dvs_env.height);
-#if defined(HAS_RES_MGR)
-	internal_res->height = (bds_out_info == NULL) ? internal_res->height : bds_out_info->res.height;
-	internal_res->width = (bds_out_info == NULL) ? internal_res->width: bds_out_info->res.width;
-#endif
 }
 
 #ifndef ISP2401
@@ -787,25 +779,6 @@ ia_css_binary_dvs_stat_grid_info(
 	struct ia_css_grid_info *info,
 	struct ia_css_pipe *pipe)
 {
-#if defined(HAS_RES_MGR)
-	struct ia_css_dvs_stat_grid_info *dvs_stat_info;
-	unsigned int i;
-
-	assert(binary != NULL);
-	assert(info != NULL);
-	dvs_stat_info = &info->dvs_grid.dvs_stat_grid_info;
-
-	if (binary->info->sp.enable.dvs_stats) {
-		for (i = 0; i < IA_CSS_SKC_DVS_STAT_NUM_OF_LEVELS; i++) {
-			dvs_stat_info->grd_cfg[i].grd_start.enable = 1;
-		}
-		ia_css_dvs_stat_grid_calculate(pipe, dvs_stat_info);
-	}
-	else {
-		memset(dvs_stat_info, 0, sizeof(struct ia_css_dvs_stat_grid_info));
-	}
-
-#endif
 	(void)pipe;
 	sh_css_binary_common_grid_info(binary, info);
 	return;
@@ -1088,9 +1061,6 @@ binary_in_frame_padded_width(int in_frame_width,
 	/* in other cases, the left padding pixels are always 128 */
 	nr_of_left_paddings = 2*ISP_VEC_NELEMS;
 #endif
-#if defined(HAS_RES_MGR)
-	(void)dvs_env_width;
-#endif
 	if (need_scaling) {
 		/* In SDV use-case, we need to match left-padding of
 		 * primary and the video binary. */
@@ -1101,9 +1071,7 @@ binary_in_frame_padded_width(int in_frame_width,
 					2*ISP_VEC_NELEMS);
 		} else {
 			/* Different than before, we do left&right padding. */
-#if !defined(HAS_RES_MGR) /* dvs env is included already */
 			in_frame_width += dvs_env_width;
-#endif
 			rval =
 				CEIL_MUL(in_frame_width +
 					(left_cropping ? nr_of_left_paddings : 0),
@@ -1214,10 +1182,8 @@ ia_css_binary_fill_info(const struct ia_css_binary_xinfo *xinfo,
 		binary->in_frame_info.res.width = in_info->res.width + info->pipeline.left_cropping;
 		binary->in_frame_info.res.height = in_info->res.height + info->pipeline.top_cropping;
 
-#if !defined(HAS_RES_MGR) /* dvs env is included already */
 		binary->in_frame_info.res.width += dvs_env_width;
 		binary->in_frame_info.res.height += dvs_env_height;
-#endif
 
 		binary->in_frame_info.padded_width =
 			binary_in_frame_padded_width(in_info->res.width,
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 8d44608..4f3a2ea 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -98,10 +98,6 @@ static int thread_alive;
 
 #include "isp/modes/interface/input_buf.isp.h"
 
-#if defined(HAS_RES_MGR)
-#include "components/acc_cluster/gen/host/acc_cluster.host.h"
-#endif
-
 /* Name of the sp program: should not be built-in */
 #define SP_PROG_NAME "sp"
 /* Size of Refcount List */
@@ -6244,9 +6240,6 @@ static enum ia_css_err load_primary_binaries(
 #else
 				 *pipe_vf_out_info;
 #endif
-#if defined(HAS_RES_MGR)
-	struct ia_css_frame_info bds_out_info;
-#endif
 	enum ia_css_err err = IA_CSS_SUCCESS;
 	struct ia_css_capture_settings *mycs;
 	unsigned int i;
@@ -6368,10 +6361,6 @@ static enum ia_css_err load_primary_binaries(
 				&cas_scaler_descr.out_info[i],
 				&cas_scaler_descr.internal_out_info[i],
 				&cas_scaler_descr.vf_info[i]);
-#if defined(HAS_RES_MGR)
-			bds_out_info.res = pipe->config.bayer_ds_out_res;
-			yuv_scaler_descr.bds_out_info = &bds_out_info;
-#endif
 			err = ia_css_binary_find(&yuv_scaler_descr,
 						&mycs->yuv_scaler_binary[i]);
 			if (err != IA_CSS_SUCCESS) {
@@ -6422,10 +6411,6 @@ static enum ia_css_err load_primary_binaries(
 			&capture_pp_descr, &prim_out_info,
 #endif
 			&capt_pp_out_info, &vf_info);
-#if defined(HAS_RES_MGR)
-			bds_out_info.res = pipe->config.bayer_ds_out_res;
-			capture_pp_descr.bds_out_info = &bds_out_info;
-#endif
 		err = ia_css_binary_find(&capture_pp_descr,
 					&mycs->capture_pp_binary);
 		if (err != IA_CSS_SUCCESS) {
@@ -6461,10 +6446,6 @@ static enum ia_css_err load_primary_binaries(
 			if (pipe->enable_viewfinder[IA_CSS_PIPE_OUTPUT_STAGE_0] && (i == mycs->num_primary_stage - 1))
 				local_vf_info = &vf_info;
 			ia_css_pipe_get_primary_binarydesc(pipe, &prim_descr[i], &prim_in_info, &prim_out_info, local_vf_info, i);
-#if defined(HAS_RES_MGR)
-			bds_out_info.res = pipe->config.bayer_ds_out_res;
-			prim_descr[i].bds_out_info = &bds_out_info;
-#endif
 			err = ia_css_binary_find(&prim_descr[i], &mycs->primary_binary[i]);
 			if (err != IA_CSS_SUCCESS) {
 				IA_CSS_LEAVE_ERR_PRIVATE(err);
@@ -6498,10 +6479,6 @@ static enum ia_css_err load_primary_binaries(
 
 		ia_css_pipe_get_vfpp_binarydesc(pipe,
 				&vf_pp_descr, vf_pp_in_info, pipe_vf_out_info);
-#if defined(HAS_RES_MGR)
-		bds_out_info.res = pipe->config.bayer_ds_out_res;
-		vf_pp_descr.bds_out_info = &bds_out_info;
-#endif
 		err = ia_css_binary_find(&vf_pp_descr, &mycs->vf_pp_binary);
 		if (err != IA_CSS_SUCCESS) {
 			IA_CSS_LEAVE_ERR_PRIVATE(err);
@@ -9822,13 +9799,6 @@ ia_css_stream_create(const struct ia_css_stream_config *stream_config,
 		if (err != IA_CSS_SUCCESS)
 			goto ERR;
 
-#if defined(HAS_RES_MGR)
-		/* update acc configuration - striping info is ready */
-		err = ia_css_update_cfg_stripe_info(curr_pipe);
-		if (err != IA_CSS_SUCCESS)
-			goto ERR;
-#endif
-
 		/* handle each pipe */
 		pipe_info = &curr_pipe->info;
 		for (j = 0; j < IA_CSS_PIPE_MAX_OUTPUT_STAGE; j++) {
