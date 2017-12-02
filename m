Return-path: <linux-media-owner@vger.kernel.org>
Received: from kadath.azazel.net ([81.187.231.250]:33618 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752359AbdLBWME (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Dec 2017 17:12:04 -0500
From: Jeremy Sowden <jeremy@azazel.net>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH v4 2/3] media: atomisp: delete zero-valued struct members.
Date: Sat,  2 Dec 2017 22:12:00 +0000
Message-Id: <20171202221201.6063-3-jeremy@azazel.net>
In-Reply-To: <20171202221201.6063-1-jeremy@azazel.net>
References: <20171202213443.GC32301@azazel.net>
 <20171202221201.6063-1-jeremy@azazel.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A lot of the members of the default struct values used by the CSS API
were explicitly initialized to zero values.  Designated initializers
have allowed these members to be removed.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 .../hive_isp_css_common/input_formatter_global.h   |  16 ---
 .../pci/atomisp2/css2400/ia_css_frame_public.h     |  17 ----
 .../atomisp/pci/atomisp2/css2400/ia_css_pipe.h     |  44 +--------
 .../pci/atomisp2/css2400/ia_css_pipe_public.h      |  78 ---------------
 .../atomisp/pci/atomisp2/css2400/ia_css_types.h    |  47 +--------
 .../isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h     | 109 ---------------------
 .../kernels/sdis/common/ia_css_sdis_common_types.h |  34 -------
 .../runtime/binary/interface/ia_css_binary.h       |  88 ++---------------
 .../isp_param/interface/ia_css_isp_param_types.h   |   9 --
 .../runtime/pipeline/interface/ia_css_pipeline.h   |   6 --
 .../atomisp/pci/atomisp2/css2400/sh_css_legacy.h   |   7 --
 .../atomisp/pci/atomisp2/css2400/sh_css_metrics.h  |   7 --
 12 files changed, 20 insertions(+), 442 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/input_formatter_global.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/input_formatter_global.h
index 4ce352986296..7558f4964313 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/input_formatter_global.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/input_formatter_global.h
@@ -107,22 +107,6 @@ struct input_formatter_cfg_s {
 	uint32_t	block_no_reqs;
 };
 
-#define DEFAULT_IF_CONFIG \
-(struct input_formatter_cfg_s) { \
-	.start_line		= 0, \
-	.start_column		= 0, \
-	.left_padding		= 0, \
-	.cropped_height		= 0, \
-	.cropped_width		= 0, \
-	.deinterleaving		= 0, \
-	.buf_vecs		= 0, \
-	.buf_start_index	= 0, \
-	.buf_increment		= 0, \
-	.buf_eol_offset		= 0, \
-	.is_yuv420_format	= false, \
-	.block_no_reqs		= false \
-}
-
 extern const hrt_address HIVE_IF_SRST_ADDRESS[N_INPUT_FORMATTER_ID];
 extern const hrt_data HIVE_IF_SRST_MASK[N_INPUT_FORMATTER_ID];
 extern const uint8_t HIVE_IF_SWITCH_CODE[N_INPUT_FORMATTER_ID];
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_frame_public.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_frame_public.h
index 634eca325f07..0beb7347a4f3 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_frame_public.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_frame_public.h
@@ -122,18 +122,8 @@ struct ia_css_frame_info {
 
 #define IA_CSS_BINARY_DEFAULT_FRAME_INFO \
 (struct ia_css_frame_info) { \
-	.res			= (struct ia_css_resolution) { \
-					.width = 0, \
-					.height = 0 \
-				}, \
-	.padded_width		= 0, \
 	.format			= IA_CSS_FRAME_FORMAT_NUM,  \
-	.raw_bit_depth		= 0, \
 	.raw_bayer_order	= IA_CSS_BAYER_ORDER_NUM, \
-	.crop_info		= (struct ia_css_crop_info) { \
-					.start_column	= 0, \
-					.start_line	= 0 \
-				}, \
 }
 
 /**
@@ -196,16 +186,9 @@ struct ia_css_frame {
 #define DEFAULT_FRAME \
 (struct ia_css_frame) { \
 	.info			= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
-	.data			= 0, \
-	.data_bytes		= 0, \
 	.dynamic_queue_id	= SH_CSS_INVALID_QUEUE_ID, \
 	.buf_type		= IA_CSS_BUFFER_TYPE_INVALID, \
 	.flash_state		= IA_CSS_FRAME_FLASH_STATE_NONE, \
-	.exp_id			= 0, \
-	.isp_config_id		= 0, \
-	.valid			= false, \
-	.contiguous		= false, \
-	.planes			= { 0 } \
 }
 
 /* @brief Fill a frame with zeros
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe.h
index fa5e3f6b85a8..522238ec8899 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe.h
@@ -39,16 +39,11 @@ struct ia_css_preview_settings {
 	struct ia_css_pipe *acc_pipe;
 };
 
-#define IA_CSS_DEFAULT_PREVIEW_SETTINGS  \
+#define IA_CSS_DEFAULT_PREVIEW_SETTINGS \
 (struct ia_css_preview_settings) { \
 	.copy_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
 	.preview_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
 	.vf_pp_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
-	.delay_frames	= { NULL }, \
-	.tnr_frames	= { NULL }, \
-	.copy_pipe	= NULL, \
-	.capture_pipe	= NULL, \
-	.acc_pipe	= NULL, \
 }
 
 struct ia_css_capture_settings {
@@ -73,17 +68,12 @@ struct ia_css_capture_settings {
 (struct ia_css_capture_settings) { \
 	.copy_binary		= IA_CSS_BINARY_DEFAULT_SETTINGS, \
 	.primary_binary		= {IA_CSS_BINARY_DEFAULT_SETTINGS}, \
-	.num_primary_stage	= 0, \
 	.pre_isp_binary		= IA_CSS_BINARY_DEFAULT_SETTINGS, \
 	.anr_gdc_binary		= IA_CSS_BINARY_DEFAULT_SETTINGS, \
 	.post_isp_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
 	.capture_pp_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
 	.vf_pp_binary		= IA_CSS_BINARY_DEFAULT_SETTINGS, \
 	.capture_ldc_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
-	.yuv_scaler_binary	= NULL, \
-	.delay_frames		= { NULL }, \
-	.is_output_stage	= NULL, \
-	.num_yuv_scaler		= 0, \
 }
 
 struct ia_css_video_settings {
@@ -106,17 +96,9 @@ struct ia_css_video_settings {
 
 #define IA_CSS_DEFAULT_VIDEO_SETTINGS \
 (struct ia_css_video_settings) { \
-	.copy_binary		= IA_CSS_BINARY_DEFAULT_SETTINGS, \
-	.video_binary		= IA_CSS_BINARY_DEFAULT_SETTINGS, \
-	.vf_pp_binary		= IA_CSS_BINARY_DEFAULT_SETTINGS, \
-	.yuv_scaler_binary	= NULL, \
-	.delay_frames		= { NULL }, \
-	.tnr_frames		= { NULL }, \
-	.vf_pp_in_frame		= NULL, \
-	.copy_pipe		= NULL, \
-	.capture_pipe		= NULL, \
-	.is_output_stage	= NULL, \
-	.num_yuv_scaler		= 0, \
+	.copy_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+	.video_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+	.vf_pp_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
 }
 
 struct ia_css_yuvpp_settings {
@@ -131,13 +113,7 @@ struct ia_css_yuvpp_settings {
 
 #define IA_CSS_DEFAULT_YUVPP_SETTINGS \
 (struct ia_css_yuvpp_settings) { \
-	.copy_binary		= IA_CSS_BINARY_DEFAULT_SETTINGS, \
-	.yuv_scaler_binary	= NULL, \
-	.vf_pp_binary		= NULL, \
-	.is_output_stage	= NULL, \
-	.num_yuv_scaler		= 0, \
-	.num_vf_pp		= 0, \
-	.num_output		= 0, \
+	.copy_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
 }
 
 struct osys_object;
@@ -186,35 +162,25 @@ struct ia_css_pipe {
 
 #define IA_CSS_DEFAULT_PIPE \
 (struct ia_css_pipe) { \
-	.stop_requested		= false, \
 	.config			= DEFAULT_PIPE_CONFIG, \
 	.extra_config		= DEFAULT_PIPE_EXTRA_CONFIG, \
 	.info			= DEFAULT_PIPE_INFO, \
 	.mode			= IA_CSS_PIPE_ID_ACC, /* (pipe_id) */ \
-	.shading_table		= NULL, \
 	.pipeline		= DEFAULT_PIPELINE, \
 	.output_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
 	.bds_output_info	= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
 	.vf_output_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
 	.out_yuv_ds_input_info	= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
 	.vf_yuv_ds_input_info	= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
-	.output_stage		= NULL, \
-	.vf_stage		= NULL, \
 	.required_bds_factor	= SH_CSS_BDS_FACTOR_1_00, \
 	.dvs_frame_delay	= 1, \
-	.num_invalid_frames	= 0, \
 	.enable_viewfinder	= {true}, \
-	.stream			= NULL, \
 	.in_frame_struct	= DEFAULT_FRAME, \
 	.out_frame_struct	= DEFAULT_FRAME, \
 	.vf_frame_struct	= DEFAULT_FRAME, \
-	.continuous_frames	= { NULL }, \
-	.cont_md_buffers	= { NULL }, \
 	.pipe_settings		= { \
 		.preview = IA_CSS_DEFAULT_PREVIEW_SETTINGS \
 	}, \
-	.scaler_pp_lut		= 0, \
-	.osys_obj		= NULL, \
 	.pipe_num		= PIPE_ENTRY_EMPTY_TOKEN, \
 }
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe_public.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe_public.h
index 58f3b5e16daa..002eff7315bb 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe_public.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe_public.h
@@ -152,49 +152,6 @@ struct ia_css_pipe_config {
 };
 
 
-#ifdef ISP2401
-/**
- * Default origin of internal frame positioned on shading table.
- */
-#define IA_CSS_PIPE_DEFAULT_INTERNAL_FRAME_ORIGIN_BQS_ON_SCTBL \
-(struct ia_css_coordinate) { .x = 0, .y = 0 }
-
-/**
- * Default settings for newly created pipe configurations.
- */
-#define DEFAULT_PIPE_CONFIG \
-(struct ia_css_pipe_config) { \
-	.mode			= IA_CSS_PIPE_MODE_PREVIEW, \
-	.isp_pipe_version	= 1, \
-	.input_effective_res	= { 0, 0 }, \
-	.bayer_ds_out_res	= { 0, 0 }, \
-	.capt_pp_in_res		= { 0, 0 }, \
-	.vf_pp_in_res		= { 0, 0 }, \
-	.output_system_in_res	= { 0, 0 }, \
-	.dvs_crop_out_res	= { 0, 0 }, \
-	.output_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
-	.vf_output_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
-	.acc_extension		= NULL, \
-	.acc_stages		= NULL, \
-	.num_acc_stages		= 0, \
-	.default_capture_config	= DEFAULT_CAPTURE_CONFIG, \
-	.dvs_envelope		= { 0, 0 }, \
-	.dvs_frame_delay	= IA_CSS_FRAME_DELAY_1, \
-	.acc_num_execs		= -1, \
-	.enable_dz		= false, \
-	.enable_dpc		= false, \
-	.enable_vfpp_bci	= false, \
-	.enable_luma_only	= false, \
-	.enable_tnr		= false, \
-	.p_isp_config		= NULL, \
-	.gdc_in_buffer_res	= { 0, 0 }, \
-	.gdc_in_buffer_offset	= { 0, 0 }, \
-	.internal_frame_origin_bqs_on_sctbl \
-				= IA_CSS_PIPE_DEFAULT_INTERNAL_FRAME_ORIGIN_BQS_ON_SCTBL \
-}
-
-#else
-
 /**
  * Default settings for newly created pipe configurations.
  */
@@ -202,30 +159,13 @@ struct ia_css_pipe_config {
 (struct ia_css_pipe_config) { \
 	.mode			= IA_CSS_PIPE_MODE_PREVIEW, \
 	.isp_pipe_version	= 1, \
-	.input_effective_res	= { 0, 0 }, \
-	.bayer_ds_out_res	= { 0, 0 }, \
-	.capt_pp_in_res		= { 0, 0 }, \
-	.vf_pp_in_res		= { 0, 0 }, \
-	.dvs_crop_out_res	= { 0, 0 }, \
 	.output_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
 	.vf_output_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
-	.acc_extension		= NULL, \
-	.acc_stages		= NULL, \
-	.num_acc_stages		= 0, \
 	.default_capture_config	= DEFAULT_CAPTURE_CONFIG, \
-	.dvs_envelope		= { 0, 0 }, \
 	.dvs_frame_delay	= IA_CSS_FRAME_DELAY_1, \
 	.acc_num_execs		= -1, \
-	.enable_dz		= false, \
-	.enable_dpc		= false, \
-	.enable_vfpp_bci	= false, \
-	.p_isp_config		= NULL, \
-	.gdc_in_buffer_res	= { 0, 0 }, \
-	.gdc_in_buffer_offset	= { 0, 0 } \
 }
 
-#endif
-
 /* Pipe info, this struct describes properties of a pipe after it's stream has
  * been created.
  * ~~~** DO NOT ADD NEW FIELD **~~~ This structure will be deprecated.
@@ -270,21 +210,6 @@ struct ia_css_pipe_info {
 /**
  * Defaults for ia_css_pipe_info structs.
  */
-#ifdef ISP2401
-
-#define DEFAULT_PIPE_INFO \
-(struct ia_css_pipe_info) { \
-	.output_info			= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
-	.vf_output_info			= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
-	.raw_output_info		= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
-	.output_system_in_res_info	= { 0, 0 }, \
-	.shading_info			= DEFAULT_SHADING_INFO, \
-	.grid_info			= DEFAULT_GRID_INFO, \
-	.num_invalid_frames		= 0 \
-}
-
-#else
-
 #define DEFAULT_PIPE_INFO \
 (struct ia_css_pipe_info) { \
 	.output_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
@@ -292,11 +217,8 @@ struct ia_css_pipe_info {
 	.raw_output_info	= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
 	.shading_info		= DEFAULT_SHADING_INFO, \
 	.grid_info		= DEFAULT_GRID_INFO, \
-	.num_invalid_frames	= 0 \
 }
 
-#endif
-
 /* @brief Load default pipe configuration
  * @param[out]	pipe_config The pipe configuration.
  * @return	None
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_types.h
index 25e30bc8a663..a0ddf989fadf 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_types.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_types.h
@@ -370,52 +370,20 @@ struct ia_css_shading_info {
 	} info;
 };
 
-#ifndef ISP2401
-
-/* Default Shading Correction information of Shading Correction Type 1. */
-#define DEFAULT_SHADING_INFO_TYPE_1 \
-(struct ia_css_shading_info) { \
-	.type = IA_CSS_SHADING_CORRECTION_TYPE_1, \
-	.info = { \
-		.type_1 = { \
-			.enable					= 0, \
-			.num_hor_grids				= 0, \
-			.num_ver_grids				= 0, \
-			.bqs_per_grid_cell			= 0, \
-			.bayer_scale_hor_ratio_in		= 1, \
-			.bayer_scale_hor_ratio_out		= 1, \
-			.bayer_scale_ver_ratio_in		= 1, \
-			.bayer_scale_ver_ratio_out		= 1, \
-			.sc_bayer_origin_x_bqs_on_shading_table	= 0, \
-			.sc_bayer_origin_y_bqs_on_shading_table	= 0 \
-		} \
-	} \
-}
-
-#else
-
 /* Default Shading Correction information of Shading Correction Type 1. */
 #define DEFAULT_SHADING_INFO_TYPE_1 \
 (struct ia_css_shading_info) { \
 	.type = IA_CSS_SHADING_CORRECTION_TYPE_1, \
 	.info = { \
 		.type_1 = { \
-			.num_hor_grids				= 0, \
-			.num_ver_grids				= 0, \
-			.bqs_per_grid_cell			= 0, \
-			.bayer_scale_hor_ratio_in		= 1, \
-			.bayer_scale_hor_ratio_out		= 1, \
-			.bayer_scale_ver_ratio_in		= 1, \
-			.bayer_scale_ver_ratio_out		= 1, \
-			.isp_input_sensor_data_res_bqs		= {0, 0}, \
-			.sensor_data_res_bqs			= {0, 0}, \
-			.sensor_data_origin_bqs_on_sctbl	= {0, 0} \
+			.bayer_scale_hor_ratio_in	= 1, \
+			.bayer_scale_hor_ratio_out	= 1, \
+			.bayer_scale_ver_ratio_in	= 1, \
+			.bayer_scale_ver_ratio_out	= 1, \
 		} \
 	} \
 }
 
-#endif
-
 /* Default Shading Correction information. */
 #define DEFAULT_SHADING_INFO	DEFAULT_SHADING_INFO_TYPE_1
 
@@ -439,8 +407,6 @@ struct ia_css_grid_info {
 /* defaults for ia_css_grid_info structs */
 #define DEFAULT_GRID_INFO \
 (struct ia_css_grid_info) { \
-	.isp_in_width	= 0, \
-	.isp_in_height	= 0, \
 	.s3a_grid	= DEFAULT_3A_GRID_INFO, \
 	.dvs_grid	= DEFAULT_DVS_GRID_INFO, \
 	.vamem_type	= IA_CSS_VAMEM_TYPE_1 \
@@ -535,10 +501,7 @@ struct ia_css_capture_config {
 /* default settings for ia_css_capture_config structs */
 #define DEFAULT_CAPTURE_CONFIG \
 (struct ia_css_capture_config) { \
-	.mode			= IA_CSS_CAPTURE_MODE_PRIMARY, \
-	.enable_xnr		= false, \
-	.enable_raw_output	= false, \
-	.enable_capture_pp_bli	= false \
+	.mode	= IA_CSS_CAPTURE_MODE_PRIMARY, \
 }
 
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h
index 3ba736fee525..988a0e272225 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h
@@ -98,119 +98,10 @@ struct ia_css_3a_grid_info {
 };
 
 
-#if defined(SYSTEM_css_skycam_c0_system)
-#if defined USE_NEW_AE_STRUCT || defined USE_NEW_AWB_STRUCT
-#define DEFAULT_3A_GRID_INFO \
-(struct ia_css_3a_grid_info) { \
-	.ae_enable		= 0, \
-	.ae_grd_info		= (struct ae_public_config_grid_config) { \
-					.width = 0, \
-					.height = 0, \
-					.b_width = 0, \
-					.b_height = 0, \
-					.x_start = 0, \
-					.y_start = 0, \
-					.x_end = 0, \
-					.y_end = 0 \
-				  } \
-	.awb_enable		= 0, \
-	.awb_grd_info		= (struct awb_public_config_grid_config) { \
-					.width = 0, \
-					.height = 0, \
-					.b_width = 0, \
-					.b_height = 0, \
-					.x_start = 0, \
-					.y_start = 0, \
-					.x_end = 0, \
-					.y_end = 0 \
-				  }	\
-	.af_enable		= 0, \
-	.af_grd_info		= (struct af_public_grid_config) { \
-					.width = 0, \
-					.height = 0, \
-					.b_width = 0, \
-					.b_height = 0, \
-					.x_start = 0, \
-					.y_start = 0, \
-					.ff_en = 0 \
-				  } \
-	.awb_fr_enable		= 0, \
-	.awb_fr_grd_info	= (struct awb_fr_public_grid_config) { \
-					.width = 0, \
-					.height = 0, \
-					.b_width = 0, \
-					.b_height = 0, \
-					.x_start = 0, \
-					.y_start = 0, \
-					.ff_en = 0 \
-				  } \
-	.elem_bit_depth		= 0, \
-}
-#else
 #define DEFAULT_3A_GRID_INFO \
 (struct ia_css_3a_grid_info) { \
-	.ae_enable		= 0, \
-	.ae_grd_info		= (struct ae_public_config_grid_config) { \
-					.width = 0, \
-					.height = 0, \
-					.b_width = 0, \
-					.b_height = 0, \
-					.x_start = 0, \
-					.y_start = 0, \
-					.x_end = 0, \
-					.y_end = 0 \
-				  } \
-	.awb_enable		= 0, \
-	.awb_grd_info		= (struct awb_public_config_grid_config) { \
-					.width = 0, \
-					.height = 0, \
-					.b_width = 0, \
-					.b_height = 0, \
-					.x_start = 0, \
-					.y_start = 0, \
-					.x_end = 0, \
-					.y_end = 0 \
-				  }	\
-	.af_enable		= 0, \
-	.af_grd_info		= (struct af_public_grid_config) { \
-					.width = 0, \
-					.height = 0, \
-					.b_width = 0, \
-					.b_height = 0, \
-					.x_start = 0, \
-					.y_start = 0, \
-					.ff_en = 0 \
-				  } \
-	.awb_fr_enable		= 0, \
-	.awb_fr_grd_info	= (struct awb_fr_public_grid_config) { \
-					.width = 0, \
-					.height = 0, \
-					.b_width = 0, \
-					.b_height = 0, \
-					.x_start = 0, \
-					.y_start = 0, \
-					.ff_en = 0 \
-				  } \
-	.elem_bit_depth		= 0, \
 }
-#endif /* USE_NEW_AE_STRUCT || defined USE_NEW_AWB_STRUCT */
 
-#else
-#define DEFAULT_3A_GRID_INFO \
-(struct ia_css_3a_grid_info) { \
-	.enable			= 0, \
-	.use_dmem		= 0, \
-	.has_histogram		= 0, \
-	.width			= 0, \
-	.height			= 0, \
-	.aligned_width		= 0, \
-	.aligned_height		= 0, \
-	.bqs_per_grid_cell	= 0, \
-	.deci_factor_log2	= 0, \
-	.elem_bit_depth		= 0, \
-}
-
-#endif
 
 /* This struct should be split into 3, for AE, AWB and AF.
  * However, that will require driver/ 3A lib modifications.
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/common/ia_css_sdis_common_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/common/ia_css_sdis_common_types.h
index b96c5890f615..e867dadd8a83 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/common/ia_css_sdis_common_types.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/common/ia_css_sdis_common_types.h
@@ -43,19 +43,6 @@ struct ia_css_sdis_info {
 
 #define IA_CSS_DEFAULT_SDIS_INFO \
 (struct ia_css_sdis_info) { \
-	.grid = { \
-		.dim = (struct ia_css_dvs_grid_dim) { .width = 0, .height = 0 }, \
-		.pad = (struct ia_css_dvs_grid_dim) { .width = 0, .height = 0 }, \
-	}, \
-	.coef = { \
-		.dim = (struct ia_css_dvs_grid_dim) { .width = 0, .height = 0 }, \
-		.pad = (struct ia_css_dvs_grid_dim) { .width = 0, .height = 0 }, \
-	}, \
-	.proj = { \
-		.dim = (struct ia_css_dvs_grid_dim) { .width = 0, .height = 0 }, \
-		.pad = (struct ia_css_dvs_grid_dim) { .width = 0, .height = 0 }, \
-	}, \
-	.deci_factor_log2 = 0, \
 }
 
 
@@ -215,36 +202,15 @@ struct ia_css_dvs_stat_grid_info {
  */
 #define DEFAULT_DVS_STAT_PUBLIC_DVS_GLOBAL_CFG \
 (struct dvs_stat_public_dvs_global_cfg) { \
-	.kappa		= 0, \
-	.match_shift	= 0, \
-	.ybin_mode	= 0, \
 }
 
 #define DEFAULT_DVS_STAT_PUBLIC_DVS_GRD_CFG \
 (struct dvs_stat_public_dvs_grd_cfg) { \
-	.grd_cfg	= (struct dvs_stat_public_dvs_level_grid_cfg) { \
-				.grid_width = 0, \
-				.grid_height = 0, \
-				.block_width = 0, \
-				.block_height = 0 \
-			}, \
-	.grd_start	= (struct dvs_stat_public_dvs_level_grid_start) { \
-				.x_start = 0, \
-				.y_start = 0, \
-				.enable = 0 \
-			}, \
-	.grd_end	= (struct dvs_stat_public_dvs_level_grid_end) { \
-				.x_end = 0, \
-				.y_end = 0, \
-			}, \
 }
 
 #define DEFAULT_DVS_STAT_PUBLIC_DVS_LEVEL_FE_ROI_CFG(X_START) \
 (struct dvs_stat_public_dvs_level_fe_roi_cfg) { \
 	.x_start = X_START, \
-	.y_start = 0, \
-	.x_end   = 0, \
-	.y_end   = 0, \
 }
 
 #define DEFAULT_DVS_STAT_GRID_INFO \
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/interface/ia_css_binary.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/interface/ia_css_binary.h
index f7685760ba87..c4abddf28670 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/interface/ia_css_binary.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/interface/ia_css_binary.h
@@ -94,14 +94,7 @@ struct ia_css_cas_binary_descr {
 };
 
 #define IA_CSS_DEFAULT_CAS_BINARY_DESCR \
-(struct ia_css_cas_binary_descr) {	\
-	.num_stage		= 0,	\
-	.num_output_stage	= 0,	\
-	.in_info		= NULL,	\
-	.internal_out_info	= NULL,	\
-	.out_info		= NULL,	\
-	.vf_info		= NULL,	\
-	.is_output_stage	= NULL,	\
+(struct ia_css_cas_binary_descr) { \
 }
 
 struct ia_css_binary_descr {
@@ -171,80 +164,19 @@ struct ia_css_binary {
 	struct ia_css_isp_param_css_segments  css_params;
 };
 
-#ifdef ISP2401
-
-#define IA_CSS_BINARY_DEFAULT_SETTINGS \
-(struct ia_css_binary) { \
-	.info				= NULL, \
-	.input_format			= IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY, \
-	.in_frame_info			= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
-	.internal_frame_info		= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
-	.out_frame_info			= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
-	.effective_in_frame_res		= { 0, 0 }, \
-	.vf_frame_info			= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
-	.input_buf_vectors		= 0, \
-	.deci_factor_log2		= 0, \
-	.vf_downscale_log2		= 0, \
-	.s3atbl_width			= 0, \
-	.s3atbl_height			= 0, \
-	.s3atbl_isp_width		= 0, \
-	.s3atbl_isp_height		= 0, \
-	.morph_tbl_width		= 0, \
-	.morph_tbl_aligned_width	= 0, \
-	.morph_tbl_height		= 0, \
-	.sctbl_width_per_color		= 0, \
-	.sctbl_aligned_width_per_color	= 0, \
-	.sctbl_height			= 0, \
-	.sctbl_legacy_width_per_color	= 0, \
-	.sctbl_legacy_height		= 0, \
-	.dis				= IA_CSS_DEFAULT_SDIS_INFO, \
-	.dvs_envelope			= { 0, 0 }, \
-	.online				= false, \
-	.uds_xc				= 0, \
-	.uds_yc				= 0, \
-	.left_padding			= 0, \
-	.metrics			= DEFAULT_BINARY_METRICS, \
-	.mem_params			= IA_CSS_DEFAULT_ISP_MEM_PARAMS, \
-	.css_params			= IA_CSS_DEFAULT_ISP_CSS_PARAMS, \
-}
-
-#else
-
 #define IA_CSS_BINARY_DEFAULT_SETTINGS \
 (struct ia_css_binary) { \
-	.info				= NULL, \
-	.input_format			= IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY, \
-	.in_frame_info			= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
-	.internal_frame_info		= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
-	.out_frame_info			= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
-	.effective_in_frame_res		= { 0, 0 }, \
-	.vf_frame_info			= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
-	.input_buf_vectors		= 0, \
-	.deci_factor_log2		= 0, \
-	.vf_downscale_log2		= 0, \
-	.s3atbl_width			= 0, \
-	.s3atbl_height			= 0, \
-	.s3atbl_isp_width		= 0, \
-	.s3atbl_isp_height		= 0, \
-	.morph_tbl_width		= 0, \
-	.morph_tbl_aligned_width	= 0, \
-	.morph_tbl_height		= 0, \
-	.sctbl_width_per_color		= 0, \
-	.sctbl_aligned_width_per_color	= 0, \
-	.sctbl_height			= 0, \
-	.dis				= IA_CSS_DEFAULT_SDIS_INFO, \
-	.dvs_envelope			= { 0, 0 }, \
-	.online				= false, \
-	.uds_xc				= 0, \
-	.uds_yc				= 0, \
-	.left_padding			= 0, \
-	.metrics			= DEFAULT_BINARY_METRICS, \
-	.mem_params			= IA_CSS_DEFAULT_ISP_MEM_PARAMS, \
-	.css_params			= IA_CSS_DEFAULT_ISP_CSS_PARAMS, \
+	.input_format		= IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY, \
+	.in_frame_info		= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
+	.internal_frame_info	= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
+	.out_frame_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
+	.vf_frame_info		= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
+	.dis			= IA_CSS_DEFAULT_SDIS_INFO, \
+	.metrics		= DEFAULT_BINARY_METRICS, \
+	.mem_params		= IA_CSS_DEFAULT_ISP_MEM_PARAMS, \
+	.css_params		= IA_CSS_DEFAULT_ISP_CSS_PARAMS, \
 }
 
-#endif
-
 enum ia_css_err
 ia_css_binary_init_infos(void);
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
index ded3a050d5fb..f9b65eb764d8 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
@@ -96,23 +96,14 @@ union ia_css_all_memory_offsets {
 
 #define IA_CSS_DEFAULT_ISP_MEM_PARAMS \
 (struct ia_css_isp_param_host_segments) { \
-	.params = { { \
-		(struct ia_css_host_data) { .address = NULL, .size = 0 } \
-	} } \
 }
 
 #define IA_CSS_DEFAULT_ISP_CSS_PARAMS \
 (struct ia_css_isp_param_css_segments) { \
-	.params = { { \
-		(struct ia_css_data) { .address = 0, .size = 0 } \
-	} } \
 }
 
 #define IA_CSS_DEFAULT_ISP_ISP_PARAMS \
 (struct ia_css_isp_param_isp_segments) { \
-	.params = { { \
-		(struct ia_css_isp_data) { .address = 0, .size = 0 } \
-	} } \
 }
 
 #endif /* _IA_CSS_ISP_PARAM_TYPES_H_ */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/interface/ia_css_pipeline.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/interface/ia_css_pipeline.h
index 99c8f5f4b92e..85ed7db0af55 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/interface/ia_css_pipeline.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/interface/ia_css_pipeline.h
@@ -76,16 +76,10 @@ struct ia_css_pipeline {
 #define DEFAULT_PIPELINE \
 (struct ia_css_pipeline) { \
 	.pipe_id		= IA_CSS_PIPE_ID_PREVIEW, \
-	.pipe_num		= 0, \
-	.stop_requested		= false, \
-	.stages			= NULL, \
-	.current_stage		= NULL, \
-	.num_stages		= 0, \
 	.in_frame		= DEFAULT_FRAME, \
 	.out_frame		= {DEFAULT_FRAME}, \
 	.vf_frame		= {DEFAULT_FRAME}, \
 	.dvs_frame_delay	= IA_CSS_FRAME_DELAY_1, \
-	.inout_port_config	= 0, \
 	.num_execs		= -1, \
 	.acquire_isp_each_stage	= true, \
 	.pipe_qos_config	= QOS_INVALID \
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_legacy.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_legacy.h
index f51b817b4a60..6c78a15485f6 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_legacy.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_legacy.h
@@ -54,13 +54,6 @@ struct ia_css_pipe_extra_config {
 
 #define DEFAULT_PIPE_EXTRA_CONFIG \
 (struct ia_css_pipe_extra_config) { \
-	.enable_raw_binning	= false, \
-	.enable_yuv_ds		= false, \
-	.enable_high_speed	= false, \
-	.enable_dvs_6axis	= false, \
-	.enable_reduced_pipe	= false, \
-	.enable_fractional_ds	= false, \
-	.disable_vf_pp		= false, \
 }
 
 enum ia_css_err
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_metrics.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_metrics.h
index f90ac36a408a..3387e8bafbe7 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_metrics.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_metrics.h
@@ -26,10 +26,6 @@ struct sh_css_pc_histogram {
 
 #define DEFAULT_PC_HISTOGRAM \
 (struct sh_css_pc_histogram) { \
-	.length	= 0, \
-	.run	= NULL, \
-	.stall	= NULL, \
-	.msink	= NULL \
 }
 
 struct sh_css_binary_metrics {
@@ -42,11 +38,8 @@ struct sh_css_binary_metrics {
 
 #define DEFAULT_BINARY_METRICS \
 (struct sh_css_binary_metrics) { \
-	.mode		= 0, \
-	.id		= 0, \
 	.isp_histogram	= DEFAULT_PC_HISTOGRAM, \
 	.sp_histogram	= DEFAULT_PC_HISTOGRAM, \
-	.next		= NULL \
 }
 
 struct ia_css_frame_metrics {
-- 
2.15.0
