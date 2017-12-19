Return-path: <linux-media-owner@vger.kernel.org>
Received: from kadath.azazel.net ([81.187.231.250]:42216 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751128AbdLSQfP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 11:35:15 -0500
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.89)
        (envelope-from <jeremy@azazel.net>)
        id 1eRKrJ-0002Lr-Lj
        for linux-media@vger.kernel.org; Tue, 19 Dec 2017 16:35:13 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: atomisp: convert default struct values to use compound-literals with designated initializers.
Date: Tue, 19 Dec 2017 16:35:13 +0000
Message-Id: <20171219163513.31378-1-jeremy@azazel.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CSS API uses a lot of nested anonymous structs defined in object
macros to assign default values to its data-structures.  These have been
changed to use compound-literals and designated initializers to make
them more comprehensible and less fragile.

The compound-literals can also be used in assignment, which means we can
get rid of some temporary variables whose only purpose is to be
initialized by one of these anonymous structs and then serve as the
rvalue in an assignment expression.

A lot of the members of the default struct values used by the CSS API
were explicitly initialized to zero values.  Designated initializers
have allowed these members, and in some case whole default struct
values, to be removed.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 .../hive_isp_css_common/input_formatter_global.h   |  16 ---
 .../pci/atomisp2/css2400/ia_css_frame_public.h     |  29 ++----
 .../atomisp/pci/atomisp2/css2400/ia_css_pipe.h     | 113 ++++++++-------------
 .../pci/atomisp2/css2400/ia_css_pipe_public.h      | 108 +++-----------------
 .../atomisp/pci/atomisp2/css2400/ia_css_types.h    |  64 +++---------
 .../isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h     |  50 +--------
 .../kernels/sdis/common/ia_css_sdis_common_types.h |  31 ++----
 .../isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c   |   3 +-
 .../runtime/binary/interface/ia_css_binary.h       |  88 ++--------------
 .../atomisp2/css2400/runtime/binary/src/binary.c   |   3 +-
 .../isp_param/interface/ia_css_isp_param_types.h   |  10 --
 .../runtime/pipeline/interface/ia_css_pipeline.h   |  24 ++---
 .../css2400/runtime/pipeline/src/pipeline.c        |   7 +-
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |  31 ++----
 .../atomisp/pci/atomisp2/css2400/sh_css_legacy.h   |  11 --
 .../atomisp/pci/atomisp2/css2400/sh_css_metrics.h  |  21 ----
 16 files changed, 116 insertions(+), 493 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/input_formatter_global.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/input_formatter_global.h
index 5654d911db65..7558f4964313 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/input_formatter_global.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/input_formatter_global.h
@@ -107,22 +107,6 @@ struct input_formatter_cfg_s {
 	uint32_t	block_no_reqs;
 };
 
-#define DEFAULT_IF_CONFIG \
-{ \
-	0,          /* start_line */\
-	0,          /* start_column */\
-	0,          /* left_padding */\
-	0,          /* cropped_height */\
-	0,          /* cropped_width */\
-	0,          /* deinterleaving */\
-	0,          /*.buf_vecs */\
-	0,          /* buf_start_index */\
-	0,          /* buf_increment */\
-	0,          /* buf_eol_offset */\
-	false,      /* is_yuv420_format */\
-	false       /* block_no_reqs */\
-}
-
 extern const hrt_address HIVE_IF_SRST_ADDRESS[N_INPUT_FORMATTER_ID];
 extern const hrt_data HIVE_IF_SRST_MASK[N_INPUT_FORMATTER_ID];
 extern const uint8_t HIVE_IF_SWITCH_CODE[N_INPUT_FORMATTER_ID];
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_frame_public.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_frame_public.h
index ba7a076c3afa..0beb7347a4f3 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_frame_public.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_frame_public.h
@@ -121,15 +121,9 @@ struct ia_css_frame_info {
 };
 
 #define IA_CSS_BINARY_DEFAULT_FRAME_INFO \
-{ \
-	{0,                      /* width */ \
-	 0},                     /* height */ \
-	0,                       /* padded_width */ \
-	IA_CSS_FRAME_FORMAT_NUM, /* format */ \
-	0,                       /* raw_bit_depth */ \
-	IA_CSS_BAYER_ORDER_NUM,  /* raw_bayer_order */ \
-	{0,                       /*start col */ \
-	 0},                       /*start line */ \
+(struct ia_css_frame_info) { \
+	.format			= IA_CSS_FRAME_FORMAT_NUM,  \
+	.raw_bayer_order	= IA_CSS_BAYER_ORDER_NUM, \
 }
 
 /**
@@ -190,18 +184,11 @@ struct ia_css_frame {
 };
 
 #define DEFAULT_FRAME \
-{ \
-	IA_CSS_BINARY_DEFAULT_FRAME_INFO,	/* info */ \
-	0,					/* data */ \
-	0,					/* data_bytes */ \
-	SH_CSS_INVALID_QUEUE_ID,		/* dynamic_data_index */ \
-	IA_CSS_BUFFER_TYPE_INVALID,			/* buf_type */ \
-	IA_CSS_FRAME_FLASH_STATE_NONE,		/* flash_state */ \
-	0,					/* exp_id */ \
-	0,					/* isp_config_id */ \
-	false,					/* valid */ \
-	false,					/* contiguous  */ \
-	{ 0 }					/* planes */ \
+(struct ia_css_frame) { \
+	.info			= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
+	.dynamic_queue_id	= SH_CSS_INVALID_QUEUE_ID, \
+	.buf_type		= IA_CSS_BUFFER_TYPE_INVALID, \
+	.flash_state		= IA_CSS_FRAME_FLASH_STATE_NONE, \
 }
 
 /* @brief Fill a frame with zeros
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe.h
index d0c0e6b92025..f6870fa7a18c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe.h
@@ -33,22 +33,17 @@ struct ia_css_preview_settings {
 	/* 2401 only for these two - do we in fact use them for anything real */
 	struct ia_css_frame *delay_frames[MAX_NUM_DELAY_FRAMES];
 	struct ia_css_frame *tnr_frames[NUM_TNR_FRAMES];
-	
+
 	struct ia_css_pipe *copy_pipe;
 	struct ia_css_pipe *capture_pipe;
 	struct ia_css_pipe *acc_pipe;
 };
 
 #define IA_CSS_DEFAULT_PREVIEW_SETTINGS \
-{ \
-	IA_CSS_BINARY_DEFAULT_SETTINGS,	/* copy_binary */\
-	IA_CSS_BINARY_DEFAULT_SETTINGS,	/* preview_binary */\
-	IA_CSS_BINARY_DEFAULT_SETTINGS,	/* vf_pp_binary */\
-	{ NULL },			/* dvs_frames */ \
-	{ NULL },			/* tnr_frames */ \
-	NULL,				/* copy_pipe */\
-	NULL,				/* capture_pipe */\
-	NULL,				/* acc_pipe */\
+(struct ia_css_preview_settings) { \
+	.copy_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+	.preview_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+	.vf_pp_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
 }
 
 struct ia_css_capture_settings {
@@ -70,20 +65,15 @@ struct ia_css_capture_settings {
 };
 
 #define IA_CSS_DEFAULT_CAPTURE_SETTINGS \
-{ \
-	IA_CSS_BINARY_DEFAULT_SETTINGS,	/* copy_binary */\
-	{IA_CSS_BINARY_DEFAULT_SETTINGS},	/* primary_binary */\
-	0,				/* num_primary_stage */\
-	IA_CSS_BINARY_DEFAULT_SETTINGS,	/* pre_isp_binary */\
-	IA_CSS_BINARY_DEFAULT_SETTINGS,	/* anr_gdc_binary */\
-	IA_CSS_BINARY_DEFAULT_SETTINGS,	/* post_isp_binary */\
-	IA_CSS_BINARY_DEFAULT_SETTINGS,	/* capture_pp_binary */\
-	IA_CSS_BINARY_DEFAULT_SETTINGS,	/* vf_pp_binary */\
-	IA_CSS_BINARY_DEFAULT_SETTINGS,	/* capture_ldc_binary */\
-	NULL,				/* yuv_scaler_binary */ \
-	{ NULL },			/* delay_frames[ref_frames] */ \
-	NULL,				/* is_output_stage */ \
-	0,				/* num_yuv_scaler */ \
+(struct ia_css_capture_settings) { \
+	.copy_binary		= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+	.primary_binary		= {IA_CSS_BINARY_DEFAULT_SETTINGS}, \
+	.pre_isp_binary		= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+	.anr_gdc_binary		= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+	.post_isp_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+	.capture_pp_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+	.vf_pp_binary		= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+	.capture_ldc_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
 }
 
 struct ia_css_video_settings {
@@ -105,18 +95,10 @@ struct ia_css_video_settings {
 };
 
 #define IA_CSS_DEFAULT_VIDEO_SETTINGS \
-{ \
-	IA_CSS_BINARY_DEFAULT_SETTINGS,	/* copy_binary */ \
-	IA_CSS_BINARY_DEFAULT_SETTINGS,	/* video_binary */ \
-	IA_CSS_BINARY_DEFAULT_SETTINGS,	/* vf_pp_binary */ \
-	NULL,				/* yuv_scaler_binary */ \
-	{ NULL },			/* delay_frames */ \
-	{ NULL },			/* tnr_frames */ \
-	NULL,				/* vf_pp_in_frame */ \
-	NULL,				/* copy_pipe */ \
-	NULL,				/* capture_pipe */ \
-	NULL,				/* is_output_stage */ \
-	0,				/* num_yuv_scaler */ \
+(struct ia_css_video_settings) { \
+	.copy_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+	.video_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+	.vf_pp_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
 }
 
 struct ia_css_yuvpp_settings {
@@ -130,14 +112,8 @@ struct ia_css_yuvpp_settings {
 };
 
 #define IA_CSS_DEFAULT_YUVPP_SETTINGS \
-{ \
-	IA_CSS_BINARY_DEFAULT_SETTINGS,		/* copy_binary */ \
-	NULL,					/* yuv_scaler_binary */ \
-	NULL,					/* vf_pp_binary */ \
-	NULL,					/* is_output_stage */ \
-	0,					/* num_yuv_scaler */ \
-	0,					/* num_vf_pp */ \
-	0,					/* num_output */ \
+(struct ia_css_yuvpp_settings) { \
+	.copy_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
 }
 
 struct osys_object;
@@ -185,35 +161,26 @@ struct ia_css_pipe {
 };
 
 #define IA_CSS_DEFAULT_PIPE \
-{ \
-	false,					/* stop_requested */ \
-	DEFAULT_PIPE_CONFIG,			/* config */ \
-	DEFAULT_PIPE_EXTRA_CONFIG,		/* extra_config */ \
-	DEFAULT_PIPE_INFO,			/* info */ \
-	IA_CSS_PIPE_ID_ACC,			/* mode (pipe_id) */ \
-	NULL,					/* shading_table */ \
-	DEFAULT_PIPELINE,			/* pipeline */ \
-	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* output_info */ \
-	IA_CSS_BINARY_DEFAULT_FRAME_INFO,	/* bds_output_info */ \
-	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* vf_output_info */ \
-	IA_CSS_BINARY_DEFAULT_FRAME_INFO,	/* out_yuv_ds_input_info */ \
-	IA_CSS_BINARY_DEFAULT_FRAME_INFO,	/* vf_yuv_ds_input_info */ \
-	NULL,					/* output_stage */ \
-	NULL,					/* vf_stage */ \
-	SH_CSS_BDS_FACTOR_1_00,			/* required_bds_factor */ \
-	1,					/* dvs_frame_delay */ \
-	0,					/* num_invalid_frames */ \
-	{true},					/* enable_viewfinder */ \
-	NULL,					/* stream */ \
-	DEFAULT_FRAME,				/* in_frame_struct */ \
-	DEFAULT_FRAME,				/* out_frame_struct */ \
-	DEFAULT_FRAME,				/* vf_frame_struct */ \
-	{ NULL },				/* continuous_frames */ \
-	{ NULL },				/* cont_md_buffers */ \
-	{ IA_CSS_DEFAULT_PREVIEW_SETTINGS },	/* pipe_settings */ \
-	0,					/* scaler_pp_lut */ \
-	NULL,					/* osys object */ \
-	PIPE_ENTRY_EMPTY_TOKEN,			/* pipe_num */\
+(struct ia_css_pipe) { \
+	.config			= DEFAULT_PIPE_CONFIG, \
+	.info			= DEFAULT_PIPE_INFO, \
+	.mode			= IA_CSS_PIPE_ID_ACC, /* (pipe_id) */ \
+	.pipeline		= DEFAULT_PIPELINE, \
+	.output_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
+	.bds_output_info	= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
+	.vf_output_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
+	.out_yuv_ds_input_info	= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
+	.vf_yuv_ds_input_info	= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
+	.required_bds_factor	= SH_CSS_BDS_FACTOR_1_00, \
+	.dvs_frame_delay	= 1, \
+	.enable_viewfinder	= {true}, \
+	.in_frame_struct	= DEFAULT_FRAME, \
+	.out_frame_struct	= DEFAULT_FRAME, \
+	.vf_frame_struct	= DEFAULT_FRAME, \
+	.pipe_settings		= { \
+		.preview = IA_CSS_DEFAULT_PREVIEW_SETTINGS \
+	}, \
+	.pipe_num		= PIPE_ENTRY_EMPTY_TOKEN, \
 }
 
 void ia_css_pipe_map_queue(struct ia_css_pipe *pipe, bool map);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe_public.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe_public.h
index df0aad9a6ab9..002eff7315bb 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe_public.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe_public.h
@@ -152,82 +152,20 @@ struct ia_css_pipe_config {
 };
 
 
-#ifdef ISP2401
-/**
- * Default origin of internal frame positioned on shading table.
- */
-#define IA_CSS_PIPE_DEFAULT_INTERNAL_FRAME_ORIGIN_BQS_ON_SCTBL \
-{ \
-	0,					/* x [bqs] */ \
-	0					/* y [bqs] */ \
-}
-
-/**
- * Default settings for newly created pipe configurations.
- */
-#define DEFAULT_PIPE_CONFIG \
-{ \
-	IA_CSS_PIPE_MODE_PREVIEW,		/* mode */ \
-	1,					/* isp_pipe_version */ \
-	{ 0, 0 },				/* pipe_effective_input_res */ \
-	{ 0, 0 },				/* bayer_ds_out_res */ \
-	{ 0, 0 },				/* vf_pp_in_res */ \
-	{ 0, 0 },				/* capt_pp_in_res */ \
-	{ 0, 0 },				/* output_system_in_res */ \
-	{ 0, 0 },				/* dvs_crop_out_res */ \
-	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* output_info */ \
-	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* vf_output_info */ \
-	NULL,					/* acc_extension */ \
-	NULL,					/* acc_stages */ \
-	0,					/* num_acc_stages */ \
-	DEFAULT_CAPTURE_CONFIG,			/* default_capture_config */ \
-	{ 0, 0 },				/* dvs_envelope */ \
-	IA_CSS_FRAME_DELAY_1,			/* dvs_frame_delay */ \
-	-1,					/* acc_num_execs */ \
-	false,					/* enable_dz */ \
-	false,					/* enable_dpc */ \
-	false,					/* enable_vfpp_bci */ \
-	false,					/* enable_luma_only */ \
-	false,					/* enable_tnr */ \
-	NULL,					/* p_isp_config */\
-	{ 0, 0 },				/* gdc_in_buffer_res */ \
-	{ 0, 0 },				/* gdc_in_buffer_offset */ \
-	IA_CSS_PIPE_DEFAULT_INTERNAL_FRAME_ORIGIN_BQS_ON_SCTBL	/* internal_frame_origin_bqs_on_sctbl */ \
-}
-
-#else
-
 /**
  * Default settings for newly created pipe configurations.
  */
 #define DEFAULT_PIPE_CONFIG \
-{ \
-	IA_CSS_PIPE_MODE_PREVIEW,		/* mode */ \
-	1,					/* isp_pipe_version */ \
-	{ 0, 0 },				/* pipe_effective_input_res */ \
-	{ 0, 0 },				/* bayer_ds_out_res */ \
-	{ 0, 0 },				/* vf_pp_in_res */ \
-	{ 0, 0 },				/* capt_pp_in_res */ \
-	{ 0, 0 },				/* dvs_crop_out_res */ \
-	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* output_info */ \
-	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* vf_output_info */ \
-	NULL,					/* acc_extension */ \
-	NULL,					/* acc_stages */ \
-	0,					/* num_acc_stages */ \
-	DEFAULT_CAPTURE_CONFIG,			/* default_capture_config */ \
-	{ 0, 0 },				/* dvs_envelope */ \
-	IA_CSS_FRAME_DELAY_1,			/* dvs_frame_delay */ \
-	-1,					/* acc_num_execs */ \
-	false,					/* enable_dz */ \
-	false,					/* enable_dpc */ \
-	false,					/* enable_vfpp_bci */ \
-	NULL,					/* p_isp_config */\
-	{ 0, 0 },				/* gdc_in_buffer_res */ \
-	{ 0, 0 }				/* gdc_in_buffer_offset */ \
+(struct ia_css_pipe_config) { \
+	.mode			= IA_CSS_PIPE_MODE_PREVIEW, \
+	.isp_pipe_version	= 1, \
+	.output_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
+	.vf_output_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
+	.default_capture_config	= DEFAULT_CAPTURE_CONFIG, \
+	.dvs_frame_delay	= IA_CSS_FRAME_DELAY_1, \
+	.acc_num_execs		= -1, \
 }
 
-#endif
-
 /* Pipe info, this struct describes properties of a pipe after it's stream has
  * been created.
  * ~~~** DO NOT ADD NEW FIELD **~~~ This structure will be deprecated.
@@ -272,33 +210,15 @@ struct ia_css_pipe_info {
 /**
  * Defaults for ia_css_pipe_info structs.
  */
-#ifdef ISP2401
-
-#define DEFAULT_PIPE_INFO \
-{ \
-	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* output_info */ \
-	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* vf_output_info */ \
-	IA_CSS_BINARY_DEFAULT_FRAME_INFO,	/* raw_output_info */ \
-	{ 0, 0},				/* output system in res */ \
-	DEFAULT_SHADING_INFO,			/* shading_info */ \
-	DEFAULT_GRID_INFO,			/* grid_info */ \
-	0					/* num_invalid_frames */ \
-}
-
-#else
-
 #define DEFAULT_PIPE_INFO \
-{ \
-	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* output_info */ \
-	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* vf_output_info */ \
-	IA_CSS_BINARY_DEFAULT_FRAME_INFO,	/* raw_output_info */ \
-	DEFAULT_SHADING_INFO,			/* shading_info */ \
-	DEFAULT_GRID_INFO,			/* grid_info */ \
-	0					/* num_invalid_frames */ \
+(struct ia_css_pipe_info) { \
+	.output_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
+	.vf_output_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
+	.raw_output_info	= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
+	.shading_info		= DEFAULT_SHADING_INFO, \
+	.grid_info		= DEFAULT_GRID_INFO, \
 }
 
-#endif
-
 /* @brief Load default pipe configuration
  * @param[out]	pipe_config The pipe configuration.
  * @return	None
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_types.h
index 725b90072cfe..259ab3f074ba 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_types.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_types.h
@@ -370,52 +370,20 @@ struct ia_css_shading_info {
 	} info;
 };
 
-#ifndef ISP2401
-
-/* Default Shading Correction information of Shading Correction Type 1. */
-#define DEFAULT_SHADING_INFO_TYPE_1 \
-{ \
-	IA_CSS_SHADING_CORRECTION_TYPE_1,	/* type */ \
-	{					/* info */ \
-		{ \
-			0,	/* enable */ \
-			0,	/* num_hor_grids */ \
-			0,	/* num_ver_grids */ \
-			0,	/* bqs_per_grid_cell */ \
-			1,	/* bayer_scale_hor_ratio_in */ \
-			1,	/* bayer_scale_hor_ratio_out */ \
-			1,	/* bayer_scale_ver_ratio_in */ \
-			1,	/* bayer_scale_ver_ratio_out */ \
-			0,	/* sc_bayer_origin_x_bqs_on_shading_table */ \
-			0	/* sc_bayer_origin_y_bqs_on_shading_table */ \
-		} \
-	} \
-}
-
-#else
-
 /* Default Shading Correction information of Shading Correction Type 1. */
 #define DEFAULT_SHADING_INFO_TYPE_1 \
-{ \
-	IA_CSS_SHADING_CORRECTION_TYPE_1,	/* type */ \
-	{					/* info */ \
-		{ \
-			0,			/* num_hor_grids */ \
-			0,			/* num_ver_grids */ \
-			0,			/* bqs_per_grid_cell */ \
-			1,			/* bayer_scale_hor_ratio_in */ \
-			1,			/* bayer_scale_hor_ratio_out */ \
-			1,			/* bayer_scale_ver_ratio_in */ \
-			1,			/* bayer_scale_ver_ratio_out */ \
-			{0, 0},			/* isp_input_sensor_data_res_bqs */ \
-			{0, 0},			/* sensor_data_res_bqs */ \
-			{0, 0}			/* sensor_data_origin_bqs_on_sctbl */ \
+(struct ia_css_shading_info) { \
+	.type = IA_CSS_SHADING_CORRECTION_TYPE_1, \
+	.info = { \
+		.type_1 = { \
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
 
@@ -438,12 +406,9 @@ struct ia_css_grid_info {
 
 /* defaults for ia_css_grid_info structs */
 #define DEFAULT_GRID_INFO \
-{ \
-	0,				/* isp_in_width */ \
-	0,				/* isp_in_height */ \
-	DEFAULT_3A_GRID_INFO,		/* s3a_grid */ \
-	DEFAULT_DVS_GRID_INFO,		/* dvs_grid */ \
-	IA_CSS_VAMEM_TYPE_1		/* vamem_type */ \
+(struct ia_css_grid_info) { \
+	.dvs_grid	= DEFAULT_DVS_GRID_INFO, \
+	.vamem_type	= IA_CSS_VAMEM_TYPE_1 \
 }
 
 /* Morphing table, used for geometric distortion and chromatic abberration
@@ -534,11 +499,8 @@ struct ia_css_capture_config {
 
 /* default settings for ia_css_capture_config structs */
 #define DEFAULT_CAPTURE_CONFIG \
-{ \
-	IA_CSS_CAPTURE_MODE_PRIMARY,	/* mode (capture) */ \
-	false,				/* enable_xnr */ \
-	false,				/* enable_raw_output */ \
-	false				/* enable_capture_pp_bli */ \
+(struct ia_css_capture_config) { \
+	.mode	= IA_CSS_CAPTURE_MODE_PRIMARY, \
 }
 
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h
index 8d674d2c6427..63e70669f085 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h
@@ -28,7 +28,7 @@
 /* 3A configuration. This configures the 3A statistics collection
  *  module.
  */
- 
+
 /* 3A statistics grid
  *
  *  ISP block: S3A1 (3A Support for 3A ver.1 (Histogram is not used for AE))
@@ -54,7 +54,7 @@ struct ia_css_3a_grid_info {
   	uint32_t awb_fr_enable;					/** awb_fr enabled in binary,
 								   0:disabled, 1:enabled */
 	struct awb_fr_public_grid_config	awb_fr_grd_info;/** see description in awb_fr_public.h*/
-  
+
         uint32_t elem_bit_depth;    /** TODO:Taken from BYT  - need input from AIQ
 					if needed for SKC
 					Bit depth of element used
@@ -98,52 +98,6 @@ struct ia_css_3a_grid_info {
 };
 
 
-#if defined(SYSTEM_css_skycam_c0_system)
-#if defined USE_NEW_AE_STRUCT || defined USE_NEW_AWB_STRUCT
-#define DEFAULT_3A_GRID_INFO \
-{ \
-	0,				/* ae_enable */ \
-	{0,0,0,0,0,0,0},	        /* AE:     width,height,b_width,b_height,x_start,y_start*/ \
-	0,				/* awb_enable */ \
-	{0,0,0,0,0,0},			/* AWB:    width,height,b_width,b_height,x_start,y_start*/ \
-	0,				/* af_enable */ \
-	{0,0,0,0,0,0,0},		/* AF:     width,height,b_width,b_height,x_start,y_start,ff_en*/ \
-	0,				/* awb_fr_enable */ \
-	{0,0,0,0,0,0,0},                  /* AWB_FR: width,height,b_width,b_height,x_start,y_start,ff_en*/ \
-	0,				/* elem_bit_depth */ \
-}
-#else
-#define DEFAULT_3A_GRID_INFO \
-{ \
-	0,				/* ae_enable */ \
-	{0,0,0,0,0,0,0,0,0},	        /* AE:     width,height,b_width,b_height,x_start,y_start,x_end,y_end*/ \
-	0,				/* awb_enable */ \
-	{0,0,0,0,0,0,0,0},              /* AWB:    width,height,b_width,b_height,x_start,y_start,x_end,y_end*/ \
-	0,				/* af_enable */ \
-	{0,0,0,0,0,0,0},		/* AF:     width,height,b_width,b_height,x_start,y_start,ff_en*/ \
-	0,				/* awb_fr_enable */ \
-	{0,0,0,0,0,0,0},                  /* AWB_FR: width,height,b_width,b_height,x_start,y_start,ff_en*/ \
-	0,				/* elem_bit_depth */ \
-}
-#endif /* USE_NEW_AE_STRUCT || defined USE_NEW_AWB_STRUCT */
-
-#else
-#define DEFAULT_3A_GRID_INFO \
-{ \
-	0,				/* enable */ \
-	0,				/* use_dmem */ \
-	0,				/* has_histogram */ \
-	0,				/* width */ \
-	0,				/* height */ \
-	0,				/* aligned_width */ \
-	0,				/* aligned_height */ \
-	0,				/* bqs_per_grid_cell */ \
-	0,				/* deci_factor_log2 */ \
-	0,				/* elem_bit_depth */ \
-}
-
-#endif
-
 /* This struct should be split into 3, for AE, AWB and AF.
  * However, that will require driver/ 3A lib modifications.
  */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/common/ia_css_sdis_common_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/common/ia_css_sdis_common_types.h
index 031983c357e4..381e5730d405 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/common/ia_css_sdis_common_types.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/common/ia_css_sdis_common_types.h
@@ -41,20 +41,6 @@ struct ia_css_sdis_info {
 	uint32_t deci_factor_log2;
 };
 
-#define IA_CSS_DEFAULT_SDIS_INFO \
-	{	\
-		{	{ 0, 0 },	/* dim */ \
-			{ 0, 0 },	/* pad */ \
-		},	/* grid */ \
-		{	{ 0, 0 },	/* dim */ \
-			{ 0, 0 },	/* pad */ \
-		},	/* coef */ \
-		{	{ 0, 0 },	/* dim */ \
-			{ 0, 0 },	/* pad */ \
-		},	/* proj */ \
-		0,	/* dis_deci_factor_log2 */ \
-	}
-
 /* DVS statistics grid
  *
  *  ISP block: SDVS1 (DIS/DVS Support for DIS/DVS ver.1 (2-axes))
@@ -209,16 +195,17 @@ struct ia_css_dvs_stat_grid_info {
 
 /* DVS statistics generated by accelerator default grid info
  */
-#define DEFAULT_DVS_GRID_INFO { \
-{ \
-	{ 0, 0, 0},	/* GBL CFG reg: kappa, match_shifrt, binning mode*/ \
-	{{{0, 0, 0, 0}, {0, 0, 0}, {0, 0} }, \
-	{{0, 0, 0, 0}, {0, 0, 0}, {0, 0} }, \
-	{{0, 0, 0, 0}, {0, 0, 0}, {0, 0} } }, \
-	{{0, 0, 0, 0}, {4, 0, 0, 0}, {0, 0, 0, 0} } } \
+#define DEFAULT_DVS_GRID_INFO \
+(union ia_css_dvs_grid_u) { \
+	.dvs_stat_grid_info = (struct ia_css_dvs_stat_grid_info) { \
+		.fe_roi_cfg = { \
+			[1] = (struct dvs_stat_public_dvs_level_fe_roi_cfg) { \
+				.x_start = 4 \
+			} \
+		} \
+	} \
 }
 
-
 /* Union that holds all types of DVS statistics grid info in
  *  CSS format
  * */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c
index 9478c12abe89..0fdd696bf654 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c
@@ -169,8 +169,7 @@ ia_css_sdis_init_info(
 	unsigned enabled)
 {
 	if (!enabled) {
-		struct ia_css_sdis_info default_dis = IA_CSS_DEFAULT_SDIS_INFO;
-		*dis = default_dis;
+		*dis = (struct ia_css_sdis_info) { };
 		return;
 	}
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/interface/ia_css_binary.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/interface/ia_css_binary.h
index 5a58abe2b233..732e49a241eb 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/interface/ia_css_binary.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/interface/ia_css_binary.h
@@ -93,17 +93,6 @@ struct ia_css_cas_binary_descr {
 	bool *is_output_stage;
 };
 
-#define IA_CSS_DEFAULT_CAS_BINARY_DESCR \
-{ \
-	0,		\
-	0,		\
-	NULL,		\
-	NULL,		\
-	NULL,		\
-	NULL,		\
-	NULL,		\
-}
-
 struct ia_css_binary_descr {
 	int mode;
 	bool online;
@@ -171,80 +160,15 @@ struct ia_css_binary {
 	struct ia_css_isp_param_css_segments  css_params;
 };
 
-#ifdef ISP2401
-
 #define IA_CSS_BINARY_DEFAULT_SETTINGS \
-{ \
-	NULL, \
-	IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY, \
-	IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
-	IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
-	{IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
-	{ 0, 0},/* effective_in_frame_res */ \
-	IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
-	0,	/* input_buf_vectors */ \
-	0,	/* deci_factor_log2 */ \
-	0,	/* vf_downscale_log2 */ \
-	0,	/* s3atbl_width */ \
-	0,	/* s3atbl_height */ \
-	0,	/* s3atbl_isp_width */ \
-	0,	/* s3atbl_isp_height */ \
-	0,	/* morph_tbl_width */ \
-	0,	/* morph_tbl_aligned_width */ \
-	0,	/* morph_tbl_height */ \
-	0,	/* sctbl_width_per_color */ \
-	0,	/* sctbl_aligned_width_per_color */ \
-	0,	/* sctbl_height */ \
-	0,	/* sctbl_legacy_width_per_color */ \
-	0,	/* sctbl_legacy_height */ \
-	IA_CSS_DEFAULT_SDIS_INFO, /* dis */ \
-	{ 0, 0},/* dvs_envelope_info */ \
-	false,	/* online */ \
-	0,	/* uds_xc */ \
-	0,	/* uds_yc */ \
-	0,	/* left_padding */ \
-	DEFAULT_BINARY_METRICS,	/* metrics */ \
-	IA_CSS_DEFAULT_ISP_MEM_PARAMS, /* mem_params */ \
-	IA_CSS_DEFAULT_ISP_CSS_PARAMS, /* css_params */ \
+(struct ia_css_binary) { \
+	.input_format		= IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY, \
+	.in_frame_info		= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
+	.internal_frame_info	= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
+	.out_frame_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
+	.vf_frame_info		= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
 }
 
-#else
-
-#define IA_CSS_BINARY_DEFAULT_SETTINGS \
-{ \
-	NULL, \
-	IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY, \
-	IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
-	IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
-	{IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
-	{ 0, 0},/* effective_in_frame_res */ \
-	IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
-	0,	/* input_buf_vectors */ \
-	0,	/* deci_factor_log2 */ \
-	0,	/* vf_downscale_log2 */ \
-	0,	/* s3atbl_width */ \
-	0,	/* s3atbl_height */ \
-	0,	/* s3atbl_isp_width */ \
-	0,	/* s3atbl_isp_height */ \
-	0,	/* morph_tbl_width */ \
-	0,	/* morph_tbl_aligned_width */ \
-	0,	/* morph_tbl_height */ \
-	0,	/* sctbl_width_per_color */ \
-	0,	/* sctbl_aligned_width_per_color */ \
-	0,	/* sctbl_height */ \
-	IA_CSS_DEFAULT_SDIS_INFO, /* dis */ \
-	{ 0, 0},/* dvs_envelope_info */ \
-	false,	/* online */ \
-	0,	/* uds_xc */ \
-	0,	/* uds_yc */ \
-	0,	/* left_padding */ \
-	DEFAULT_BINARY_METRICS,	/* metrics */ \
-	IA_CSS_DEFAULT_ISP_MEM_PARAMS, /* mem_params */ \
-	IA_CSS_DEFAULT_ISP_CSS_PARAMS, /* css_params */ \
-}
-
-#endif
-
 enum ia_css_err
 ia_css_binary_init_infos(void);
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c
index 295e07049393..a0f0e9062c4c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c
@@ -490,7 +490,6 @@ ia_css_binary_get_shading_info_type_1(const struct ia_css_binary *binary,	/* [in
 	struct sh_css_shading_table_bayer_origin_compute_results res;
 #else
 	struct sh_css_binary_sc_requirements scr;
-	struct ia_css_shading_info default_shading_info_type_1 = DEFAULT_SHADING_INFO_TYPE_1;
 #endif
 
 #ifndef ISP2401
@@ -542,7 +541,7 @@ ia_css_binary_get_shading_info_type_1(const struct ia_css_binary *binary,	/* [in
 		&res);
 	if (err != IA_CSS_SUCCESS)
 #else
-	*shading_info = default_shading_info_type_1;
+	*shading_info = DEFAULT_SHADING_INFO_TYPE_1;
 
 	err = sh_css_binary_get_sc_requirements(binary, required_bds_factor, stream_config, &scr);
 	if (err != IA_CSS_SUCCESS) {
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
index 2283dd1c1c9b..2de9f8eda2da 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
@@ -94,14 +94,4 @@ union ia_css_all_memory_offsets {
 	} array[IA_CSS_NUM_PARAM_CLASSES];
 };
 
-#define IA_CSS_DEFAULT_ISP_MEM_PARAMS \
-		{ { { { 0, 0 } } } }
-
-#define IA_CSS_DEFAULT_ISP_CSS_PARAMS \
-		{ { { { 0, 0 } } } }
-
-#define IA_CSS_DEFAULT_ISP_ISP_PARAMS \
-		{ { { { 0, 0 } } } }
-
 #endif /* _IA_CSS_ISP_PARAM_TYPES_H_ */
-
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/interface/ia_css_pipeline.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/interface/ia_css_pipeline.h
index e64936e2d46e..85ed7db0af55 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/interface/ia_css_pipeline.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/interface/ia_css_pipeline.h
@@ -74,21 +74,15 @@ struct ia_css_pipeline {
 };
 
 #define DEFAULT_PIPELINE \
-{ \
-	IA_CSS_PIPE_ID_PREVIEW, /* pipe_id */ \
-	0,			/* pipe_num */ \
-	false,			/* stop_requested */ \
-	NULL,                   /* stages */ \
-	NULL,                   /* current_stage */ \
-	0,                      /* num_stages */ \
-	DEFAULT_FRAME,          /* in_frame */ \
-	{DEFAULT_FRAME},          /* out_frame */ \
-	{DEFAULT_FRAME},          /* vf_frame */ \
-	IA_CSS_FRAME_DELAY_1,   /* frame_delay */ \
-	0,                      /* inout_port_config */ \
-	-1,                     /* num_execs */ \
-	true,					/* acquire_isp_each_stage */\
-	QOS_INVALID             /* pipe_qos_config */\
+(struct ia_css_pipeline) { \
+	.pipe_id		= IA_CSS_PIPE_ID_PREVIEW, \
+	.in_frame		= DEFAULT_FRAME, \
+	.out_frame		= {DEFAULT_FRAME}, \
+	.vf_frame		= {DEFAULT_FRAME}, \
+	.dvs_frame_delay	= IA_CSS_FRAME_DELAY_1, \
+	.num_execs		= -1, \
+	.acquire_isp_each_stage	= true, \
+	.pipe_qos_config	= QOS_INVALID \
 }
 
 /* Stage descriptor used to create a new stage in the pipeline */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/src/pipeline.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/src/pipeline.c
index 8f93d29d1c51..81a50c73ad0b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/src/pipeline.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/src/pipeline.c
@@ -692,17 +692,16 @@ static void pipeline_init_defaults(
 	unsigned int pipe_num,
 	unsigned int dvs_frame_delay)
 {
-	struct ia_css_frame init_frame = DEFAULT_FRAME;
 	unsigned int i;
 
 	pipeline->pipe_id = pipe_id;
 	pipeline->stages = NULL;
 	pipeline->stop_requested = false;
 	pipeline->current_stage = NULL;
-	pipeline->in_frame = init_frame;
+	pipeline->in_frame = DEFAULT_FRAME;
 	for (i = 0; i < IA_CSS_PIPE_MAX_OUTPUT_STAGE; i++) {
-		pipeline->out_frame[i] = init_frame;
-		pipeline->vf_frame[i] = init_frame;
+		pipeline->out_frame[i] = DEFAULT_FRAME;
+		pipeline->vf_frame[i] = DEFAULT_FRAME;
 	}
 	pipeline->num_execs = -1;
 	pipeline->acquire_isp_each_stage = true;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 322bb3de6098..2b1763ccd436 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -112,8 +112,6 @@ static int thread_alive;
 #define STATS_ENABLED(stage) (stage && stage->binary && stage->binary->info && \
         (stage->binary->info->sp.enable.s3a || stage->binary->info->sp.enable.dis))
 
-#define DEFAULT_PLANES { {0, 0, 0, 0} }
-
 struct sh_css my_css;
 
 int (*sh_css_printf) (const char *fmt, va_list args) = NULL;
@@ -2291,25 +2289,19 @@ init_pipe_defaults(enum ia_css_pipe_mode mode,
 	       struct ia_css_pipe *pipe,
 	       bool copy_pipe)
 {
-	static struct ia_css_pipe default_pipe = IA_CSS_DEFAULT_PIPE;
-	static struct ia_css_preview_settings prev  = IA_CSS_DEFAULT_PREVIEW_SETTINGS;
-	static struct ia_css_capture_settings capt  = IA_CSS_DEFAULT_CAPTURE_SETTINGS;
-	static struct ia_css_video_settings   video = IA_CSS_DEFAULT_VIDEO_SETTINGS;
-	static struct ia_css_yuvpp_settings   yuvpp = IA_CSS_DEFAULT_YUVPP_SETTINGS;
-
 	if (pipe == NULL) {
 		IA_CSS_ERROR("NULL pipe parameter");
 		return IA_CSS_ERR_INVALID_ARGUMENTS;
 	}
 
 	/* Initialize pipe to pre-defined defaults */
-	*pipe = default_pipe;
+	*pipe = IA_CSS_DEFAULT_PIPE;
 
 	/* TODO: JB should not be needed, but temporary backward reference */
 	switch (mode) {
 	case IA_CSS_PIPE_MODE_PREVIEW:
 		pipe->mode = IA_CSS_PIPE_ID_PREVIEW;
-		pipe->pipe_settings.preview = prev;
+		pipe->pipe_settings.preview = IA_CSS_DEFAULT_PREVIEW_SETTINGS;
 		break;
 	case IA_CSS_PIPE_MODE_CAPTURE:
 		if (copy_pipe) {
@@ -2317,11 +2309,11 @@ init_pipe_defaults(enum ia_css_pipe_mode mode,
 		} else {
 			pipe->mode = IA_CSS_PIPE_ID_CAPTURE;
 		}
-		pipe->pipe_settings.capture = capt;
+		pipe->pipe_settings.capture = IA_CSS_DEFAULT_CAPTURE_SETTINGS;
 		break;
 	case IA_CSS_PIPE_MODE_VIDEO:
 		pipe->mode = IA_CSS_PIPE_ID_VIDEO;
-		pipe->pipe_settings.video = video;
+		pipe->pipe_settings.video = IA_CSS_DEFAULT_VIDEO_SETTINGS;
 		break;
 	case IA_CSS_PIPE_MODE_ACC:
 		pipe->mode = IA_CSS_PIPE_ID_ACC;
@@ -2331,7 +2323,7 @@ init_pipe_defaults(enum ia_css_pipe_mode mode,
 		break;
 	case IA_CSS_PIPE_MODE_YUVPP:
 		pipe->mode = IA_CSS_PIPE_ID_YUVPP;
-		pipe->pipe_settings.yuvpp = yuvpp;
+		pipe->pipe_settings.yuvpp = IA_CSS_DEFAULT_YUVPP_SETTINGS;
 		break;
 	default:
 		return IA_CSS_ERR_INVALID_ARGUMENTS;
@@ -5588,8 +5580,7 @@ static enum ia_css_err load_video_binaries(struct ia_css_pipe *pipe)
 	/* we build up the pipeline starting at the end */
 	/* YUV post-processing if needed */
 	if (need_scaler) {
-		struct ia_css_cas_binary_descr cas_scaler_descr
-			= IA_CSS_DEFAULT_CAS_BINARY_DESCR;
+		struct ia_css_cas_binary_descr cas_scaler_descr = { };
 
 		/* NV12 is the common format that is supported by both */
 		/* yuv_scaler and the video_xx_isp2_min binaries. */
@@ -6244,8 +6235,8 @@ static enum ia_css_err load_primary_binaries(
 						pipe_out_info->res);
 
 	if (need_extra_yuv_scaler) {
-		struct ia_css_cas_binary_descr cas_scaler_descr
-			= IA_CSS_DEFAULT_CAS_BINARY_DESCR;
+		struct ia_css_cas_binary_descr cas_scaler_descr = { };
+
 		err = ia_css_pipe_create_cas_scaler_desc_single_output(
 			&capt_pp_out_info,
 			pipe_out_info,
@@ -7232,7 +7223,7 @@ load_yuvpp_binaries(struct ia_css_pipe *pipe)
 	struct ia_css_frame_info *vf_pp_in_info[IA_CSS_PIPE_MAX_OUTPUT_STAGE];
 	struct ia_css_yuvpp_settings *mycs;
 	struct ia_css_binary *next_binary;
-	struct ia_css_cas_binary_descr cas_scaler_descr = IA_CSS_DEFAULT_CAS_BINARY_DESCR;
+	struct ia_css_cas_binary_descr cas_scaler_descr = { };
 	unsigned int i, j;
 	bool need_isp_copy_binary = false;
 
@@ -8827,10 +8818,8 @@ sh_css_init_host_sp_control_vars(void)
  */
 void ia_css_pipe_config_defaults(struct ia_css_pipe_config *pipe_config)
 {
-	struct ia_css_pipe_config def_config = DEFAULT_PIPE_CONFIG;
-
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "ia_css_pipe_config_defaults()\n");
-	*pipe_config = def_config;
+	*pipe_config = DEFAULT_PIPE_CONFIG;
 }
 
 void
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_legacy.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_legacy.h
index 4bcc35d219f8..4fd25ba2cd0d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_legacy.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_legacy.h
@@ -52,17 +52,6 @@ struct ia_css_pipe_extra_config {
 	bool disable_vf_pp;
 };
 
-#define DEFAULT_PIPE_EXTRA_CONFIG \
-{ \
-	false,				/* enable_raw_binning */ \
-	false,				/* enable_yuv_ds */ \
-	false,				/* enable_high_speed */ \
-	false,				/* enable_dvs_6axis */ \
-	false,				/* enable_reduced_pipe */ \
-	false,				/* enable_fractional_ds */ \
-	false,				/* disable_vf_pp */ \
-}
-
 enum ia_css_err
 ia_css_pipe_create_extra(const struct ia_css_pipe_config *config,
 			 const struct ia_css_pipe_extra_config *extra_config,
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_metrics.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_metrics.h
index 40840ea318ab..2ef9238d95ad 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_metrics.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_metrics.h
@@ -24,16 +24,6 @@ struct sh_css_pc_histogram {
 	unsigned *msink;
 };
 
-#if !defined(__USE_DESIGNATED_INITIALISERS__)
-#define DEFAULT_PC_HISTOGRAM \
-{ \
-	0, \
-	NULL, \
-	NULL, \
-	NULL \
-}
-#endif
-
 struct sh_css_binary_metrics {
 	unsigned mode;
 	unsigned id;
@@ -42,17 +32,6 @@ struct sh_css_binary_metrics {
 	struct sh_css_binary_metrics *next;
 };
 
-#if !defined(__USE_DESIGNATED_INITIALISERS__)
-#define DEFAULT_BINARY_METRICS \
-{ \
-	0, \
-	0, \
-	DEFAULT_PC_HISTOGRAM, \
-	DEFAULT_PC_HISTOGRAM, \
-	NULL \
-}
-#endif
-
 struct ia_css_frame_metrics {
 	unsigned num_frames;
 };

base-commit: ae49432810c5cca2143afc1445edad6582c9f270
-- 
2.15.1
