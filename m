Return-path: <linux-media-owner@vger.kernel.org>
Received: from kadath.azazel.net ([81.187.231.250]:47348 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751308AbdLAVpw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Dec 2017 16:45:52 -0500
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.89)
        (envelope-from <jeremy@azazel.net>)
        id 1eKt83-0006Bv-1k
        for linux-media@vger.kernel.org; Fri, 01 Dec 2017 21:45:51 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 3/3] media: atomisp: delete empty default struct values.
Date: Fri,  1 Dec 2017 21:45:50 +0000
Message-Id: <20171201214550.7369-4-jeremy@azazel.net>
In-Reply-To: <20171201214550.7369-1-jeremy@azazel.net>
References: <20171201150725.cfcp6b4bs2ncqsip@mwanda>
 <20171201214550.7369-1-jeremy@azazel.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Removing zero-valued struct-members left a number of the default
struct-values empty.  These values have now been removed.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 .../atomisp/pci/atomisp2/css2400/ia_css_pipe.h     |  1 -
 .../atomisp/pci/atomisp2/css2400/ia_css_types.h    |  1 -
 .../isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h     |  6 ---
 .../kernels/sdis/common/ia_css_sdis_common_types.h | 46 ++++------------------
 .../isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c   |  2 +-
 .../runtime/binary/interface/ia_css_binary.h       |  9 -----
 .../isp_param/interface/ia_css_isp_param_types.h   | 15 -------
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |  9 ++---
 .../atomisp/pci/atomisp2/css2400/sh_css_legacy.h   |  5 ---
 .../atomisp/pci/atomisp2/css2400/sh_css_metrics.h  | 12 ------
 10 files changed, 12 insertions(+), 94 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe.h
index a68eac6de36a..3f3c85c2f360 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe.h
@@ -167,7 +167,6 @@ struct ia_css_pipe {
 #define IA_CSS_DEFAULT_PIPE ( \
 	(struct ia_css_pipe) { \
 		.config			= DEFAULT_PIPE_CONFIG, \
-		.extra_config		= DEFAULT_PIPE_EXTRA_CONFIG, \
 		.info			= DEFAULT_PIPE_INFO, \
 		.mode			= IA_CSS_PIPE_ID_ACC, /* (pipe_id) */ \
 		.pipeline		= DEFAULT_PIPELINE, \
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_types.h
index e9ab800ae128..914049b56bc7 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_types.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_types.h
@@ -408,7 +408,6 @@ struct ia_css_grid_info {
 /* defaults for ia_css_grid_info structs */
 #define DEFAULT_GRID_INFO ( \
 	(struct ia_css_grid_info) { \
-		.s3a_grid	= DEFAULT_3A_GRID_INFO, \
 		.dvs_grid	= DEFAULT_DVS_GRID_INFO, \
 		.vamem_type	= IA_CSS_VAMEM_TYPE_1 \
 	} \
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h
index 4b8bdc973d4b..63e70669f085 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h
@@ -98,12 +98,6 @@ struct ia_css_3a_grid_info {
 };
 
 
-#define DEFAULT_3A_GRID_INFO ( \
-	(struct ia_css_3a_grid_info) { \
-	} \
-)
-
-
 /* This struct should be split into 3, for AE, AWB and AF.
  * However, that will require driver/ 3A lib modifications.
  */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/common/ia_css_sdis_common_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/common/ia_css_sdis_common_types.h
index b9adc2af7603..f74941d49e8b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/common/ia_css_sdis_common_types.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/common/ia_css_sdis_common_types.h
@@ -41,12 +41,6 @@ struct ia_css_sdis_info {
 	uint32_t deci_factor_log2;
 };
 
-#define IA_CSS_DEFAULT_SDIS_INFO ( \
-	(struct ia_css_sdis_info) { \
-	} \
-)
-
-
 /* DVS statistics grid
  *
  *  ISP block: SDVS1 (DIS/DVS Support for DIS/DVS ver.1 (2-axes))
@@ -201,41 +195,15 @@ struct ia_css_dvs_stat_grid_info {
 
 /* DVS statistics generated by accelerator default grid info
  */
-#define DEFAULT_DVS_STAT_PUBLIC_DVS_GLOBAL_CFG ( \
-	(struct dvs_stat_public_dvs_global_cfg) { \
-	} \
-)
-
-#define DEFAULT_DVS_STAT_PUBLIC_DVS_GRD_CFG ( \
-	(struct dvs_stat_public_dvs_grd_cfg) { \
-	} \
-)
-
-#define DEFAULT_DVS_STAT_PUBLIC_DVS_LEVEL_FE_ROI_CFG(X_START) ( \
-	(struct dvs_stat_public_dvs_level_fe_roi_cfg) { \
-		.x_start = X_START, \
-	} \
-)
-
-#define DEFAULT_DVS_STAT_GRID_INFO ( \
-	(struct ia_css_dvs_stat_grid_info) { \
-		.dvs_gbl_cfg = DEFAULT_DVS_STAT_PUBLIC_DVS_GLOBAL_CFG, \
-		.grd_cfg = { \
-			DEFAULT_DVS_STAT_PUBLIC_DVS_GRD_CFG, \
-			DEFAULT_DVS_STAT_PUBLIC_DVS_GRD_CFG, \
-			DEFAULT_DVS_STAT_PUBLIC_DVS_GRD_CFG \
-		}, \
-		.fe_roi_cfg = { \
-			DEFAULT_DVS_STAT_PUBLIC_DVS_LEVEL_FE_ROI_CFG(0), \
-			DEFAULT_DVS_STAT_PUBLIC_DVS_LEVEL_FE_ROI_CFG(4), \
-			DEFAULT_DVS_STAT_PUBLIC_DVS_LEVEL_FE_ROI_CFG(0), \
-		} \
-	} \
-)
-
 #define DEFAULT_DVS_GRID_INFO ( \
 	(union ia_css_dvs_grid_u) { \
-		.dvs_stat_grid_info = DEFAULT_DVS_STAT_GRID_INFO, \
+		.dvs_stat_grid_info = (struct ia_css_dvs_stat_grid_info) { \
+			.fe_roi_cfg = { \
+				[1] = (struct dvs_stat_public_dvs_level_fe_roi_cfg) { \
+					.x_start = 4 \
+				} \
+			} \
+		} \
 	} \
 )
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c
index e45a3c3fcf4a..0fdd696bf654 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c
@@ -169,7 +169,7 @@ ia_css_sdis_init_info(
 	unsigned enabled)
 {
 	if (!enabled) {
-		*dis = IA_CSS_DEFAULT_SDIS_INFO;
+		*dis = (struct ia_css_sdis_info) { };
 		return;
 	}
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/interface/ia_css_binary.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/interface/ia_css_binary.h
index 23bc33b66018..dbbdc404faa7 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/interface/ia_css_binary.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/interface/ia_css_binary.h
@@ -93,11 +93,6 @@ struct ia_css_cas_binary_descr {
 	bool *is_output_stage;
 };
 
-#define IA_CSS_DEFAULT_CAS_BINARY_DESCR ( \
-	(struct ia_css_cas_binary_descr) { \
-	} \
-)
-
 struct ia_css_binary_descr {
 	int mode;
 	bool online;
@@ -172,10 +167,6 @@ struct ia_css_binary {
 		.internal_frame_info	= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
 		.out_frame_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
 		.vf_frame_info		= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
-		.dis			= IA_CSS_DEFAULT_SDIS_INFO, \
-		.metrics		= DEFAULT_BINARY_METRICS, \
-		.mem_params		= IA_CSS_DEFAULT_ISP_MEM_PARAMS, \
-		.css_params		= IA_CSS_DEFAULT_ISP_CSS_PARAMS, \
 	} \
 )
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
index e49afa2102ae..2de9f8eda2da 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
@@ -94,19 +94,4 @@ union ia_css_all_memory_offsets {
 	} array[IA_CSS_NUM_PARAM_CLASSES];
 };
 
-#define IA_CSS_DEFAULT_ISP_MEM_PARAMS ( \
-	(struct ia_css_isp_param_host_segments) { \
-	} \
-)
-
-#define IA_CSS_DEFAULT_ISP_CSS_PARAMS ( \
-	(struct ia_css_isp_param_css_segments) { \
-	} \
-)
-
-#define IA_CSS_DEFAULT_ISP_ISP_PARAMS ( \
-	(struct ia_css_isp_param_isp_segments) { \
-	} \
-)
-
 #endif /* _IA_CSS_ISP_PARAM_TYPES_H_ */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 20d7fc1f2e4b..2b1763ccd436 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -5580,8 +5580,7 @@ static enum ia_css_err load_video_binaries(struct ia_css_pipe *pipe)
 	/* we build up the pipeline starting at the end */
 	/* YUV post-processing if needed */
 	if (need_scaler) {
-		struct ia_css_cas_binary_descr cas_scaler_descr
-			= IA_CSS_DEFAULT_CAS_BINARY_DESCR;
+		struct ia_css_cas_binary_descr cas_scaler_descr = { };
 
 		/* NV12 is the common format that is supported by both */
 		/* yuv_scaler and the video_xx_isp2_min binaries. */
@@ -6236,8 +6235,8 @@ static enum ia_css_err load_primary_binaries(
 						pipe_out_info->res);
 
 	if (need_extra_yuv_scaler) {
-		struct ia_css_cas_binary_descr cas_scaler_descr
-			= IA_CSS_DEFAULT_CAS_BINARY_DESCR;
+		struct ia_css_cas_binary_descr cas_scaler_descr = { };
+
 		err = ia_css_pipe_create_cas_scaler_desc_single_output(
 			&capt_pp_out_info,
 			pipe_out_info,
@@ -7224,7 +7223,7 @@ load_yuvpp_binaries(struct ia_css_pipe *pipe)
 	struct ia_css_frame_info *vf_pp_in_info[IA_CSS_PIPE_MAX_OUTPUT_STAGE];
 	struct ia_css_yuvpp_settings *mycs;
 	struct ia_css_binary *next_binary;
-	struct ia_css_cas_binary_descr cas_scaler_descr = IA_CSS_DEFAULT_CAS_BINARY_DESCR;
+	struct ia_css_cas_binary_descr cas_scaler_descr = { };
 	unsigned int i, j;
 	bool need_isp_copy_binary = false;
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_legacy.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_legacy.h
index 77fc32a03c72..4fd25ba2cd0d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_legacy.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_legacy.h
@@ -52,11 +52,6 @@ struct ia_css_pipe_extra_config {
 	bool disable_vf_pp;
 };
 
-#define DEFAULT_PIPE_EXTRA_CONFIG ( \
-	(struct ia_css_pipe_extra_config) { \
-	} \
-)
-
 enum ia_css_err
 ia_css_pipe_create_extra(const struct ia_css_pipe_config *config,
 			 const struct ia_css_pipe_extra_config *extra_config,
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_metrics.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_metrics.h
index aa3badd7e9da..2ef9238d95ad 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_metrics.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_metrics.h
@@ -24,11 +24,6 @@ struct sh_css_pc_histogram {
 	unsigned *msink;
 };
 
-#define DEFAULT_PC_HISTOGRAM ( \
-	(struct sh_css_pc_histogram) { \
-	} \
-)
-
 struct sh_css_binary_metrics {
 	unsigned mode;
 	unsigned id;
@@ -37,13 +32,6 @@ struct sh_css_binary_metrics {
 	struct sh_css_binary_metrics *next;
 };
 
-#define DEFAULT_BINARY_METRICS ( \
-	(struct sh_css_binary_metrics) { \
-		.isp_histogram	= DEFAULT_PC_HISTOGRAM, \
-		.sp_histogram	= DEFAULT_PC_HISTOGRAM, \
-	} \
-)
-
 struct ia_css_frame_metrics {
 	unsigned num_frames;
 };
-- 
2.15.0
