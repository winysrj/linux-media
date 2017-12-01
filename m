Return-path: <linux-media-owner@vger.kernel.org>
Received: from kadath.azazel.net ([81.187.231.250]:39514 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751443AbdLARUB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Dec 2017 12:20:01 -0500
From: Jeremy Sowden <jeremy@azazel.net>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Jeremy Sowden <jeremy@azazel.net>
Subject: [PATCH v2 1/3] media: atomisp: convert default struct values to use compound-literals with designated initializers.
Date: Fri,  1 Dec 2017 17:19:37 +0000
Message-Id: <20171201171939.3432-2-jeremy@azazel.net>
In-Reply-To: <20171201171939.3432-1-jeremy@azazel.net>
References: <20171201150725.cfcp6b4bs2ncqsip@mwanda>
 <20171201171939.3432-1-jeremy@azazel.net>
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

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 .../hive_isp_css_common/input_formatter_global.h   |  31 ++--
 .../pci/atomisp2/css2400/ia_css_frame_public.h     |  56 ++++---
 .../atomisp/pci/atomisp2/css2400/ia_css_pipe.h     | 173 +++++++++++----------
 .../pci/atomisp2/css2400/ia_css_pipe_public.h      | 159 +++++++++----------
 .../atomisp/pci/atomisp2/css2400/ia_css_types.h    |  98 ++++++------
 .../isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h     | 149 +++++++++++++-----
 .../kernels/sdis/common/ia_css_sdis_common_types.h |  96 +++++++++---
 .../isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c   |   3 +-
 .../runtime/binary/interface/ia_css_binary.h       | 155 +++++++++---------
 .../atomisp2/css2400/runtime/binary/src/binary.c   |   3 +-
 .../isp_param/interface/ia_css_isp_param_types.h   |  32 ++--
 .../runtime/pipeline/interface/ia_css_pipeline.h   |  35 +++--
 .../css2400/runtime/pipeline/src/pipeline.c        |   7 +-
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |  22 +--
 .../atomisp/pci/atomisp2/css2400/sh_css_legacy.h   |  21 +--
 .../atomisp/pci/atomisp2/css2400/sh_css_metrics.h  |  36 ++---
 16 files changed, 613 insertions(+), 463 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/input_formatter_global.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/input_formatter_global.h
index 5654d911db65..5e19b5bd56e6 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/input_formatter_global.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/input_formatter_global.h
@@ -107,21 +107,22 @@ struct input_formatter_cfg_s {
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
+#define DEFAULT_IF_CONFIG ( \
+	(struct input_formatter_cfg_s) { \
+		.start_line		= 0, \
+		.start_column		= 0, \
+		.left_padding		= 0, \
+		.cropped_height		= 0, \
+		.cropped_width		= 0, \
+		.deinterleaving		= 0, \
+		.buf_vecs		= 0, \
+		.buf_start_index	= 0, \
+		.buf_increment		= 0, \
+		.buf_eol_offset		= 0, \
+		.is_yuv420_format	= false, \
+		.block_no_reqs		= false \
+	} \
+)
 
 extern const hrt_address HIVE_IF_SRST_ADDRESS[N_INPUT_FORMATTER_ID];
 extern const hrt_data HIVE_IF_SRST_MASK[N_INPUT_FORMATTER_ID];
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_frame_public.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_frame_public.h
index 92f2389176b2..56527feeb558 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_frame_public.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_frame_public.h
@@ -120,17 +120,22 @@ struct ia_css_frame_info {
 	struct ia_css_crop_info crop_info;
 };
 
-#define IA_CSS_BINARY_DEFAULT_FRAME_INFO \
-{ \
-	{0,                      /* width */ \
-	 0},                     /* height */ \
-	0,                       /* padded_width */ \
-	IA_CSS_FRAME_FORMAT_NUM, /* format */ \
-	0,                       /* raw_bit_depth */ \
-	IA_CSS_BAYER_ORDER_NUM,  /* raw_bayer_order */ \
-	{0,                       /*start col */ \
-	 0},                       /*start line */ \
-}
+#define IA_CSS_BINARY_DEFAULT_FRAME_INFO ( \
+	(struct ia_css_frame_info) { \
+		.res			= (struct ia_css_resolution) { \
+						.width = 0, \
+						.height = 0 \
+					}, \
+		.padded_width		= 0, \
+		.format			= IA_CSS_FRAME_FORMAT_NUM,  \
+		.raw_bit_depth		= 0, \
+		.raw_bayer_order	= IA_CSS_BAYER_ORDER_NUM, \
+		.crop_info		= (struct ia_css_crop_info) { \
+						.start_column	= 0, \
+						.start_line	= 0 \
+					}, \
+	} \
+)
 
 /**
  *  Specifies the DVS loop delay in "frame periods"
@@ -189,20 +194,21 @@ struct ia_css_frame {
 		       info.format */
 };
 
-#define DEFAULT_FRAME \
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
-}
+#define DEFAULT_FRAME ( \
+	(struct ia_css_frame) { \
+		.info			= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
+		.data			= 0, \
+		.data_bytes		= 0, \
+		.dynamic_queue_id	= SH_CSS_INVALID_QUEUE_ID, \
+		.buf_type		= IA_CSS_BUFFER_TYPE_INVALID, \
+		.flash_state		= IA_CSS_FRAME_FLASH_STATE_NONE, \
+		.exp_id			= 0, \
+		.isp_config_id		= 0, \
+		.valid			= false, \
+		.contiguous		= false, \
+		.planes			= { 0 } \
+	} \
+)
 
 /** @brief Fill a frame with zeros
  *
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe.h
index d0c0e6b92025..bfebfd8d6e63 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe.h
@@ -33,23 +33,24 @@ struct ia_css_preview_settings {
 	/* 2401 only for these two - do we in fact use them for anything real */
 	struct ia_css_frame *delay_frames[MAX_NUM_DELAY_FRAMES];
 	struct ia_css_frame *tnr_frames[NUM_TNR_FRAMES];
-	
+
 	struct ia_css_pipe *copy_pipe;
 	struct ia_css_pipe *capture_pipe;
 	struct ia_css_pipe *acc_pipe;
 };
 
-#define IA_CSS_DEFAULT_PREVIEW_SETTINGS \
-{ \
-	IA_CSS_BINARY_DEFAULT_SETTINGS,	/* copy_binary */\
-	IA_CSS_BINARY_DEFAULT_SETTINGS,	/* preview_binary */\
-	IA_CSS_BINARY_DEFAULT_SETTINGS,	/* vf_pp_binary */\
-	{ NULL },			/* dvs_frames */ \
-	{ NULL },			/* tnr_frames */ \
-	NULL,				/* copy_pipe */\
-	NULL,				/* capture_pipe */\
-	NULL,				/* acc_pipe */\
-}
+#define IA_CSS_DEFAULT_PREVIEW_SETTINGS  ( \
+	(struct ia_css_preview_settings) { \
+		.copy_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+		.preview_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+		.vf_pp_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+		.delay_frames	= { NULL }, \
+		.tnr_frames	= { NULL }, \
+		.copy_pipe	= NULL, \
+		.capture_pipe	= NULL, \
+		.acc_pipe	= NULL, \
+	} \
+)
 
 struct ia_css_capture_settings {
 	struct ia_css_binary copy_binary;
@@ -69,22 +70,23 @@ struct ia_css_capture_settings {
 	unsigned int num_yuv_scaler;
 };
 
-#define IA_CSS_DEFAULT_CAPTURE_SETTINGS \
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
-}
+#define IA_CSS_DEFAULT_CAPTURE_SETTINGS ( \
+	(struct ia_css_capture_settings) { \
+		.copy_binary		= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+		.primary_binary		= {IA_CSS_BINARY_DEFAULT_SETTINGS}, \
+		.num_primary_stage	= 0, \
+		.pre_isp_binary		= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+		.anr_gdc_binary		= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+		.post_isp_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+		.capture_pp_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+		.vf_pp_binary		= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+		.capture_ldc_binary	= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+		.yuv_scaler_binary	= NULL, \
+		.delay_frames		= { NULL }, \
+		.is_output_stage	= NULL, \
+		.num_yuv_scaler		= 0, \
+	} \
+)
 
 struct ia_css_video_settings {
 	struct ia_css_binary copy_binary;
@@ -104,20 +106,21 @@ struct ia_css_video_settings {
 	unsigned int num_yuv_scaler;
 };
 
-#define IA_CSS_DEFAULT_VIDEO_SETTINGS \
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
-}
+#define IA_CSS_DEFAULT_VIDEO_SETTINGS ( \
+	(struct ia_css_video_settings) { \
+		.copy_binary		= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+		.video_binary		= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+		.vf_pp_binary		= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+		.yuv_scaler_binary	= NULL, \
+		.delay_frames		= { NULL }, \
+		.tnr_frames		= { NULL }, \
+		.vf_pp_in_frame		= NULL, \
+		.copy_pipe		= NULL, \
+		.capture_pipe		= NULL, \
+		.is_output_stage	= NULL, \
+		.num_yuv_scaler		= 0, \
+	} \
+)
 
 struct ia_css_yuvpp_settings {
 	struct ia_css_binary copy_binary;
@@ -129,16 +132,17 @@ struct ia_css_yuvpp_settings {
 	unsigned int num_output;
 };
 
-#define IA_CSS_DEFAULT_YUVPP_SETTINGS \
-{ \
-	IA_CSS_BINARY_DEFAULT_SETTINGS,		/* copy_binary */ \
-	NULL,					/* yuv_scaler_binary */ \
-	NULL,					/* vf_pp_binary */ \
-	NULL,					/* is_output_stage */ \
-	0,					/* num_yuv_scaler */ \
-	0,					/* num_vf_pp */ \
-	0,					/* num_output */ \
-}
+#define IA_CSS_DEFAULT_YUVPP_SETTINGS ( \
+	(struct ia_css_yuvpp_settings) { \
+		.copy_binary		= IA_CSS_BINARY_DEFAULT_SETTINGS, \
+		.yuv_scaler_binary	= NULL, \
+		.vf_pp_binary		= NULL, \
+		.is_output_stage	= NULL, \
+		.num_yuv_scaler		= 0, \
+		.num_vf_pp		= 0, \
+		.num_output		= 0, \
+	} \
+)
 
 struct osys_object;
 
@@ -184,37 +188,40 @@ struct ia_css_pipe {
 	unsigned int pipe_num;
 };
 
-#define IA_CSS_DEFAULT_PIPE \
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
-}
+#define IA_CSS_DEFAULT_PIPE ( \
+	(struct ia_css_pipe) { \
+		.stop_requested		= false, \
+		.config			= DEFAULT_PIPE_CONFIG, \
+		.extra_config		= DEFAULT_PIPE_EXTRA_CONFIG, \
+		.info			= DEFAULT_PIPE_INFO, \
+		.mode			= IA_CSS_PIPE_ID_ACC, /* (pipe_id) */ \
+		.shading_table		= NULL, \
+		.pipeline		= DEFAULT_PIPELINE, \
+		.output_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
+		.bds_output_info	= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
+		.vf_output_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
+		.out_yuv_ds_input_info	= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
+		.vf_yuv_ds_input_info	= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
+		.output_stage		= NULL, \
+		.vf_stage		= NULL, \
+		.required_bds_factor	= SH_CSS_BDS_FACTOR_1_00, \
+		.dvs_frame_delay	= 1, \
+		.num_invalid_frames	= 0, \
+		.enable_viewfinder	= {true}, \
+		.stream			= NULL, \
+		.in_frame_struct	= DEFAULT_FRAME, \
+		.out_frame_struct	= DEFAULT_FRAME, \
+		.vf_frame_struct	= DEFAULT_FRAME, \
+		.continuous_frames	= { NULL }, \
+		.cont_md_buffers	= { NULL }, \
+		.pipe_settings		= { \
+			.preview = IA_CSS_DEFAULT_PREVIEW_SETTINGS \
+		}, \
+		.scaler_pp_lut		= 0, \
+		.osys_obj		= NULL, \
+		.pipe_num		= PIPE_ENTRY_EMPTY_TOKEN, \
+	} \
+)
 
 void ia_css_pipe_map_queue(struct ia_css_pipe *pipe, bool map);
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe_public.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe_public.h
index 733e0ef3afe8..b23e23cdf086 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe_public.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe_public.h
@@ -156,75 +156,76 @@ struct ia_css_pipe_config {
 /**
  * Default origin of internal frame positioned on shading table.
  */
-#define IA_CSS_PIPE_DEFAULT_INTERNAL_FRAME_ORIGIN_BQS_ON_SCTBL \
-{ \
-	0,					/* x [bqs] */ \
-	0					/* y [bqs] */ \
-}
+#define IA_CSS_PIPE_DEFAULT_INTERNAL_FRAME_ORIGIN_BQS_ON_SCTBL ( \
+	(struct ia_css_coordinate) { .x = 0, .y = 0 } \
+)
 
 /**
  * Default settings for newly created pipe configurations.
  */
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
+#define DEFAULT_PIPE_CONFIG ( \
+	(struct ia_css_pipe_config) { \
+		.mode			= IA_CSS_PIPE_MODE_PREVIEW, \
+		.isp_pipe_version	= 1, \
+		.input_effective_res	= { 0, 0 }, \
+		.bayer_ds_out_res	= { 0, 0 }, \
+		.capt_pp_in_res		= { 0, 0 }, \
+		.vf_pp_in_res		= { 0, 0 }, \
+		.output_system_in_res	= { 0, 0 }, \
+		.dvs_crop_out_res	= { 0, 0 }, \
+		.output_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
+		.vf_output_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
+		.acc_extension		= NULL, \
+		.acc_stages		= NULL, \
+		.num_acc_stages		= 0, \
+		.default_capture_config	= DEFAULT_CAPTURE_CONFIG, \
+		.dvs_envelope		= { 0, 0 }, \
+		.dvs_frame_delay	= IA_CSS_FRAME_DELAY_1, \
+		.acc_num_execs		= -1, \
+		.enable_dz		= false, \
+		.enable_dpc		= false, \
+		.enable_vfpp_bci	= false, \
+		.enable_luma_only	= false, \
+		.enable_tnr		= false, \
+		.p_isp_config		= NULL, \
+		.gdc_in_buffer_res	= { 0, 0 }, \
+		.gdc_in_buffer_offset	= { 0, 0 }, \
+		.internal_frame_origin_bqs_on_sctbl \
+					= IA_CSS_PIPE_DEFAULT_INTERNAL_FRAME_ORIGIN_BQS_ON_SCTBL \
+	} \
+)
 
 #else
 
 /**
  * Default settings for newly created pipe configurations.
  */
-#define DEFAULT_PIPE_CONFIG \
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
-}
+#define DEFAULT_PIPE_CONFIG ( \
+	(struct ia_css_pipe_config) { \
+		.mode			= IA_CSS_PIPE_MODE_PREVIEW, \
+		.isp_pipe_version	= 1, \
+		.input_effective_res	= { 0, 0 }, \
+		.bayer_ds_out_res	= { 0, 0 }, \
+		.capt_pp_in_res		= { 0, 0 }, \
+		.vf_pp_in_res		= { 0, 0 }, \
+		.dvs_crop_out_res	= { 0, 0 }, \
+		.output_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
+		.vf_output_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
+		.acc_extension		= NULL, \
+		.acc_stages		= NULL, \
+		.num_acc_stages		= 0, \
+		.default_capture_config	= DEFAULT_CAPTURE_CONFIG, \
+		.dvs_envelope		= { 0, 0 }, \
+		.dvs_frame_delay	= IA_CSS_FRAME_DELAY_1, \
+		.acc_num_execs		= -1, \
+		.enable_dz		= false, \
+		.enable_dpc		= false, \
+		.enable_vfpp_bci	= false, \
+		.p_isp_config		= NULL, \
+		.gdc_in_buffer_res	= { 0, 0 }, \
+		.gdc_in_buffer_offset	= { 0, 0 } \
+	} \
+)
 
 #endif
 
@@ -274,28 +275,30 @@ struct ia_css_pipe_info {
  */
 #ifdef ISP2401
 
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
+#define DEFAULT_PIPE_INFO ( \
+	(struct ia_css_pipe_info) { \
+		.output_info			= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
+		.vf_output_info			= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
+		.raw_output_info		= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
+		.output_system_in_res_info	= { 0, 0 }, \
+		.shading_info			= DEFAULT_SHADING_INFO, \
+		.grid_info			= DEFAULT_GRID_INFO, \
+		.num_invalid_frames		= 0 \
+	} \
+)
 
 #else
 
-#define DEFAULT_PIPE_INFO \
-{ \
-	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* output_info */ \
-	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* vf_output_info */ \
-	IA_CSS_BINARY_DEFAULT_FRAME_INFO,	/* raw_output_info */ \
-	DEFAULT_SHADING_INFO,			/* shading_info */ \
-	DEFAULT_GRID_INFO,			/* grid_info */ \
-	0					/* num_invalid_frames */ \
-}
+#define DEFAULT_PIPE_INFO ( \
+	(struct ia_css_pipe_info) { \
+		.output_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
+		.vf_output_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
+		.raw_output_info	= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
+		.shading_info		= DEFAULT_SHADING_INFO, \
+		.grid_info		= DEFAULT_GRID_INFO, \
+		.num_invalid_frames	= 0 \
+	} \
+)
 
 #endif
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_types.h
index 5fec3d5c89d8..506f92bbc226 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_types.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_types.h
@@ -373,46 +373,48 @@ struct ia_css_shading_info {
 #ifndef ISP2401
 
 /** Default Shading Correction information of Shading Correction Type 1. */
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
+#define DEFAULT_SHADING_INFO_TYPE_1 ( \
+	(struct ia_css_shading_info) { \
+		.type = IA_CSS_SHADING_CORRECTION_TYPE_1, \
+		.info = { \
+			.type_1 = { \
+				.enable					= 0, \
+				.num_hor_grids				= 0, \
+				.num_ver_grids				= 0, \
+				.bqs_per_grid_cell			= 0, \
+				.bayer_scale_hor_ratio_in		= 1, \
+				.bayer_scale_hor_ratio_out		= 1, \
+				.bayer_scale_ver_ratio_in		= 1, \
+				.bayer_scale_ver_ratio_out		= 1, \
+				.sc_bayer_origin_x_bqs_on_shading_table	= 0, \
+				.sc_bayer_origin_y_bqs_on_shading_table	= 0 \
+			} \
 		} \
 	} \
-}
+)
 
 #else
 
 /** Default Shading Correction information of Shading Correction Type 1. */
-#define DEFAULT_SHADING_INFO_TYPE_1 \
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
+#define DEFAULT_SHADING_INFO_TYPE_1 ( \
+	(struct ia_css_shading_info) { \
+		.type = IA_CSS_SHADING_CORRECTION_TYPE_1, \
+		.info = { \
+			.type_1 = { \
+				.num_hor_grids				= 0, \
+				.num_ver_grids				= 0, \
+				.bqs_per_grid_cell			= 0, \
+				.bayer_scale_hor_ratio_in		= 1, \
+				.bayer_scale_hor_ratio_out		= 1, \
+				.bayer_scale_ver_ratio_in		= 1, \
+				.bayer_scale_ver_ratio_out		= 1, \
+				.isp_input_sensor_data_res_bqs		= {0, 0}, \
+				.sensor_data_res_bqs			= {0, 0}, \
+				.sensor_data_origin_bqs_on_sctbl	= {0, 0} \
+			} \
 		} \
 	} \
-}
+)
 
 #endif
 
@@ -437,14 +439,15 @@ struct ia_css_grid_info {
 };
 
 /** defaults for ia_css_grid_info structs */
-#define DEFAULT_GRID_INFO \
-{ \
-	0,				/* isp_in_width */ \
-	0,				/* isp_in_height */ \
-	DEFAULT_3A_GRID_INFO,		/* s3a_grid */ \
-	DEFAULT_DVS_GRID_INFO,		/* dvs_grid */ \
-	IA_CSS_VAMEM_TYPE_1		/* vamem_type */ \
-}
+#define DEFAULT_GRID_INFO ( \
+	(struct ia_css_grid_info) { \
+		.isp_in_width	= 0, \
+		.isp_in_height	= 0, \
+		.s3a_grid	= DEFAULT_3A_GRID_INFO, \
+		.dvs_grid	= DEFAULT_DVS_GRID_INFO, \
+		.vamem_type	= IA_CSS_VAMEM_TYPE_1 \
+	} \
+)
 
 /** Morphing table, used for geometric distortion and chromatic abberration
  *  correction (GDCAC, also called GDC).
@@ -533,13 +536,14 @@ struct ia_css_capture_config {
 };
 
 /** default settings for ia_css_capture_config structs */
-#define DEFAULT_CAPTURE_CONFIG \
-{ \
-	IA_CSS_CAPTURE_MODE_PRIMARY,	/* mode (capture) */ \
-	false,				/* enable_xnr */ \
-	false,				/* enable_raw_output */ \
-	false				/* enable_capture_pp_bli */ \
-}
+#define DEFAULT_CAPTURE_CONFIG ( \
+	(struct ia_css_capture_config) { \
+		.mode			= IA_CSS_CAPTURE_MODE_PRIMARY, \
+		.enable_xnr		= false, \
+		.enable_raw_output	= false, \
+		.enable_capture_pp_bli	= false \
+	} \
+)
 
 
 /** ISP filter configuration. This is a collection of configurations
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h
index f57ed1ec5981..76316fbabbd5 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h
@@ -28,7 +28,7 @@
 /** 3A configuration. This configures the 3A statistics collection
  *  module.
  */
- 
+
 /** 3A statistics grid
  *
  *  ISP block: S3A1 (3A Support for 3A ver.1 (Histogram is not used for AE))
@@ -54,7 +54,7 @@ struct ia_css_3a_grid_info {
   	uint32_t awb_fr_enable;					/**< awb_fr enabled in binary,
 								   0:disabled, 1:enabled */
 	struct awb_fr_public_grid_config	awb_fr_grd_info;/**< see description in awb_fr_public.h*/
-  
+
         uint32_t elem_bit_depth;    /**< TODO:Taken from BYT  - need input from AIQ
 					if needed for SKC
 					Bit depth of element used
@@ -100,47 +100,118 @@ struct ia_css_3a_grid_info {
 
 #if defined(SYSTEM_css_skycam_c0_system)
 #if defined USE_NEW_AE_STRUCT || defined USE_NEW_AWB_STRUCT
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
+#define DEFAULT_3A_GRID_INFO ( \
+	(struct ia_css_3a_grid_info) { \
+		.ae_enable		= 0, \
+		.ae_grd_info		= (struct ae_public_config_grid_config) { \
+						.width = 0, \
+						.height = 0, \
+						.b_width = 0, \
+						.b_height = 0, \
+						.x_start = 0, \
+						.y_start = 0, \
+						.x_end = 0, \
+						.y_end = 0 \
+					  } \
+		.awb_enable		= 0, \
+		.awb_grd_info		= (struct awb_public_config_grid_config) { \
+						.width = 0, \
+						.height = 0, \
+						.b_width = 0, \
+						.b_height = 0, \
+						.x_start = 0, \
+						.y_start = 0, \
+						.x_end = 0, \
+						.y_end = 0 \
+					  }	\
+		.af_enable		= 0, \
+		.af_grd_info		= (struct af_public_grid_config) { \
+						.width = 0, \
+						.height = 0, \
+						.b_width = 0, \
+						.b_height = 0, \
+						.x_start = 0, \
+						.y_start = 0, \
+						.ff_en = 0 \
+					  } \
+		.awb_fr_enable		= 0, \
+		.awb_fr_grd_info	= (struct awb_fr_public_grid_config) { \
+						.width = 0, \
+						.height = 0, \
+						.b_width = 0, \
+						.b_height = 0, \
+						.x_start = 0, \
+						.y_start = 0, \
+						.ff_en = 0 \
+					  } \
+		.elem_bit_depth		= 0, \
+	} \
+)
 #else
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
+#define DEFAULT_3A_GRID_INFO ( \
+	(struct ia_css_3a_grid_info) { \
+		.ae_enable		= 0, \
+		.ae_grd_info		= (struct ae_public_config_grid_config) { \
+						.width = 0, \
+						.height = 0, \
+						.b_width = 0, \
+						.b_height = 0, \
+						.x_start = 0, \
+						.y_start = 0, \
+						.x_end = 0, \
+						.y_end = 0 \
+					  } \
+		.awb_enable		= 0, \
+		.awb_grd_info		= (struct awb_public_config_grid_config) { \
+						.width = 0, \
+						.height = 0, \
+						.b_width = 0, \
+						.b_height = 0, \
+						.x_start = 0, \
+						.y_start = 0, \
+						.x_end = 0, \
+						.y_end = 0 \
+					  }	\
+		.af_enable		= 0, \
+		.af_grd_info		= (struct af_public_grid_config) { \
+						.width = 0, \
+						.height = 0, \
+						.b_width = 0, \
+						.b_height = 0, \
+						.x_start = 0, \
+						.y_start = 0, \
+						.ff_en = 0 \
+					  } \
+		.awb_fr_enable		= 0, \
+		.awb_fr_grd_info	= (struct awb_fr_public_grid_config) { \
+						.width = 0, \
+						.height = 0, \
+						.b_width = 0, \
+						.b_height = 0, \
+						.x_start = 0, \
+						.y_start = 0, \
+						.ff_en = 0 \
+					  } \
+		.elem_bit_depth		= 0, \
+	} \
+)
 #endif /* USE_NEW_AE_STRUCT || defined USE_NEW_AWB_STRUCT */
 
 #else
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
+#define DEFAULT_3A_GRID_INFO ( \
+	(struct ia_css_3a_grid_info) { \
+		.enable			= 0, \
+		.use_dmem		= 0, \
+		.has_histogram		= 0, \
+		.width			= 0, \
+		.height			= 0, \
+		.aligned_width		= 0, \
+		.aligned_height		= 0, \
+		.bqs_per_grid_cell	= 0, \
+		.deci_factor_log2	= 0, \
+		.elem_bit_depth		= 0, \
+	} \
+)
 
 #endif
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/common/ia_css_sdis_common_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/common/ia_css_sdis_common_types.h
index 295dc60b778c..4365049f0049 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/common/ia_css_sdis_common_types.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/common/ia_css_sdis_common_types.h
@@ -41,19 +41,24 @@ struct ia_css_sdis_info {
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
+#define IA_CSS_DEFAULT_SDIS_INFO ( \
+	(struct ia_css_sdis_info) { \
+		.grid = { \
+			.dim = (struct ia_css_dvs_grid_dim) { .width = 0, .height = 0 }, \
+			.pad = (struct ia_css_dvs_grid_dim) { .width = 0, .height = 0 }, \
+		}, \
+		.coef = { \
+			.dim = (struct ia_css_dvs_grid_dim) { .width = 0, .height = 0 }, \
+			.pad = (struct ia_css_dvs_grid_dim) { .width = 0, .height = 0 }, \
+		}, \
+		.proj = { \
+			.dim = (struct ia_css_dvs_grid_dim) { .width = 0, .height = 0 }, \
+			.pad = (struct ia_css_dvs_grid_dim) { .width = 0, .height = 0 }, \
+		}, \
+		.deci_factor_log2 = 0, \
+	} \
+)
+
 
 /** DVS statistics grid
  *
@@ -209,15 +214,64 @@ struct ia_css_dvs_stat_grid_info {
 
 /** DVS statistics generated by accelerator default grid info
  */
-#define DEFAULT_DVS_GRID_INFO { \
-{ \
-	{ 0, 0, 0},	/* GBL CFG reg: kappa, match_shifrt, binning mode*/ \
-	{{{0, 0, 0, 0}, {0, 0, 0}, {0, 0} }, \
-	{{0, 0, 0, 0}, {0, 0, 0}, {0, 0} }, \
-	{{0, 0, 0, 0}, {0, 0, 0}, {0, 0} } }, \
-	{{0, 0, 0, 0}, {4, 0, 0, 0}, {0, 0, 0, 0} } } \
-}
+#define DEFAULT_DVS_STAT_PUBLIC_DVS_GLOBAL_CFG ( \
+	(struct dvs_stat_public_dvs_global_cfg) { \
+		.kappa		= 0, \
+		.match_shift	= 0, \
+		.ybin_mode	= 0, \
+	} \
+)
+
+#define DEFAULT_DVS_STAT_PUBLIC_DVS_GRD_CFG ( \
+	(struct dvs_stat_public_dvs_grd_cfg) { \
+		.grd_cfg	= (struct dvs_stat_public_dvs_level_grid_cfg) { \
+					.grid_width = 0, \
+					.grid_height = 0, \
+					.block_width = 0, \
+					.block_height = 0 \
+				}, \
+		.grd_start	= (struct dvs_stat_public_dvs_level_grid_start) { \
+					.x_start = 0, \
+					.y_start = 0, \
+					.enable = 0 \
+				}, \
+		.grd_end	= (struct dvs_stat_public_dvs_level_grid_end) { \
+					.x_end = 0, \
+					.y_end = 0, \
+				}, \
+	} \
+)
+
+#define DEFAULT_DVS_STAT_PUBLIC_DVS_LEVEL_FE_ROI_CFG(X_START) ( \
+	(struct dvs_stat_public_dvs_level_fe_roi_cfg) { \
+		.x_start = X_START, \
+		.y_start = 0, \
+		.x_end   = 0, \
+		.y_end   = 0, \
+	} \
+)
+
+#define DEFAULT_DVS_STAT_GRID_INFO ( \
+	(struct ia_css_dvs_stat_grid_info) { \
+		.dvs_gbl_cfg = DEFAULT_DVS_STAT_PUBLIC_DVS_GLOBAL_CFG, \
+		.grd_cfg = { \
+			DEFAULT_DVS_STAT_PUBLIC_DVS_GRD_CFG, \
+			DEFAULT_DVS_STAT_PUBLIC_DVS_GRD_CFG, \
+			DEFAULT_DVS_STAT_PUBLIC_DVS_GRD_CFG \
+		}, \
+		.fe_roi_cfg = { \
+			DEFAULT_DVS_STAT_PUBLIC_DVS_LEVEL_FE_ROI_CFG(0), \
+			DEFAULT_DVS_STAT_PUBLIC_DVS_LEVEL_FE_ROI_CFG(4), \
+			DEFAULT_DVS_STAT_PUBLIC_DVS_LEVEL_FE_ROI_CFG(0), \
+		} \
+	} \
+)
 
+#define DEFAULT_DVS_GRID_INFO ( \
+	(union ia_css_dvs_grid_u) { \
+		.dvs_stat_grid_info = DEFAULT_DVS_STAT_GRID_INFO, \
+	} \
+)
 
 /** Union that holds all types of DVS statistics grid info in
  *  CSS format
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c
index 9478c12abe89..e45a3c3fcf4a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c
@@ -169,8 +169,7 @@ ia_css_sdis_init_info(
 	unsigned enabled)
 {
 	if (!enabled) {
-		struct ia_css_sdis_info default_dis = IA_CSS_DEFAULT_SDIS_INFO;
-		*dis = default_dis;
+		*dis = IA_CSS_DEFAULT_SDIS_INFO;
 		return;
 	}
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/interface/ia_css_binary.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/interface/ia_css_binary.h
index c65194619a34..b2934149f76a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/interface/ia_css_binary.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/interface/ia_css_binary.h
@@ -93,16 +93,17 @@ struct ia_css_cas_binary_descr {
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
+#define IA_CSS_DEFAULT_CAS_BINARY_DESCR ( \
+	(struct ia_css_cas_binary_descr) {	\
+		.num_stage		= 0,	\
+		.num_output_stage	= 0,	\
+		.in_info		= NULL,	\
+		.internal_out_info	= NULL,	\
+		.out_info		= NULL,	\
+		.vf_info		= NULL,	\
+		.is_output_stage	= NULL,	\
+	} \
+)
 
 struct ia_css_binary_descr {
 	int mode;
@@ -173,75 +174,77 @@ struct ia_css_binary {
 
 #ifdef ISP2401
 
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
-}
+#define IA_CSS_BINARY_DEFAULT_SETTINGS ( \
+	(struct ia_css_binary) { \
+		.info				= NULL, \
+		.input_format			= IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY, \
+		.in_frame_info			= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
+		.internal_frame_info		= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
+		.out_frame_info			= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
+		.effective_in_frame_res		= { 0, 0 }, \
+		.vf_frame_info			= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
+		.input_buf_vectors		= 0, \
+		.deci_factor_log2		= 0, \
+		.vf_downscale_log2		= 0, \
+		.s3atbl_width			= 0, \
+		.s3atbl_height			= 0, \
+		.s3atbl_isp_width		= 0, \
+		.s3atbl_isp_height		= 0, \
+		.morph_tbl_width		= 0, \
+		.morph_tbl_aligned_width	= 0, \
+		.morph_tbl_height		= 0, \
+		.sctbl_width_per_color		= 0, \
+		.sctbl_aligned_width_per_color	= 0, \
+		.sctbl_height			= 0, \
+		.sctbl_legacy_width_per_color	= 0, \
+		.sctbl_legacy_height		= 0, \
+		.dis				= IA_CSS_DEFAULT_SDIS_INFO, \
+		.dvs_envelope			= { 0, 0 }, \
+		.online				= false, \
+		.uds_xc				= 0, \
+		.uds_yc				= 0, \
+		.left_padding			= 0, \
+		.metrics			= DEFAULT_BINARY_METRICS, \
+		.mem_params			= IA_CSS_DEFAULT_ISP_MEM_PARAMS, \
+		.css_params			= IA_CSS_DEFAULT_ISP_CSS_PARAMS, \
+	} \
+)
 
 #else
 
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
+#define IA_CSS_BINARY_DEFAULT_SETTINGS ( \
+	(struct ia_css_binary) { \
+		.info				= NULL, \
+		.input_format			= IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY, \
+		.in_frame_info			= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
+		.internal_frame_info		= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
+		.out_frame_info			= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
+		.effective_in_frame_res		= { 0, 0 }, \
+		.vf_frame_info			= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
+		.input_buf_vectors		= 0, \
+		.deci_factor_log2		= 0, \
+		.vf_downscale_log2		= 0, \
+		.s3atbl_width			= 0, \
+		.s3atbl_height			= 0, \
+		.s3atbl_isp_width		= 0, \
+		.s3atbl_isp_height		= 0, \
+		.morph_tbl_width		= 0, \
+		.morph_tbl_aligned_width	= 0, \
+		.morph_tbl_height		= 0, \
+		.sctbl_width_per_color		= 0, \
+		.sctbl_aligned_width_per_color	= 0, \
+		.sctbl_height			= 0, \
+		.dis				= IA_CSS_DEFAULT_SDIS_INFO, \
+		.dvs_envelope			= { 0, 0 }, \
+		.online				= false, \
+		.uds_xc				= 0, \
+		.uds_yc				= 0, \
+		.left_padding			= 0, \
+		.metrics			= DEFAULT_BINARY_METRICS, \
+		.mem_params			= IA_CSS_DEFAULT_ISP_MEM_PARAMS, \
+		.css_params			= IA_CSS_DEFAULT_ISP_CSS_PARAMS, \
+	} \
+)
 
 #endif
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c
index 9f8a125f0d74..934cfab60530 100644
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
index 8e651b80345a..f88c23f38e38 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
@@ -94,14 +94,28 @@ union ia_css_all_memory_offsets {
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
+#define IA_CSS_DEFAULT_ISP_MEM_PARAMS ( \
+	(struct ia_css_isp_param_host_segments) { \
+		.params = { { \
+			(struct ia_css_host_data) { .address = NULL, .size = 0 } \
+		} } \
+	} \
+)
+
+#define IA_CSS_DEFAULT_ISP_CSS_PARAMS ( \
+	(struct ia_css_isp_param_css_segments) { \
+		.params = { { \
+			(struct ia_css_data) { .address = 0, .size = 0 } \
+		} } \
+	} \
+)
+
+#define IA_CSS_DEFAULT_ISP_ISP_PARAMS ( \
+	(struct ia_css_isp_param_isp_segments) { \
+		.params = { { \
+			(struct ia_css_isp_data) { .address = 0, .size = 0 } \
+		} } \
+	} \
+)
 
 #endif /* _IA_CSS_ISP_PARAM_TYPES_H_ */
-
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/interface/ia_css_pipeline.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/interface/ia_css_pipeline.h
index 90646f5f8885..4a2dd996364f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/interface/ia_css_pipeline.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/interface/ia_css_pipeline.h
@@ -73,23 +73,24 @@ struct ia_css_pipeline {
 	uint32_t pipe_qos_config;
 };
 
-#define DEFAULT_PIPELINE \
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
-}
+#define DEFAULT_PIPELINE ( \
+	(struct ia_css_pipeline) { \
+		.pipe_id		= IA_CSS_PIPE_ID_PREVIEW, \
+		.pipe_num		= 0, \
+		.stop_requested		= false, \
+		.stages			= NULL, \
+		.current_stage		= NULL, \
+		.num_stages		= 0, \
+		.in_frame		= DEFAULT_FRAME, \
+		.out_frame		= {DEFAULT_FRAME}, \
+		.vf_frame		= {DEFAULT_FRAME}, \
+		.dvs_frame_delay	= IA_CSS_FRAME_DELAY_1, \
+		.inout_port_config	= 0, \
+		.num_execs		= -1, \
+		.acquire_isp_each_stage	= true, \
+		.pipe_qos_config	= QOS_INVALID \
+	} \
+)
 
 /* Stage descriptor used to create a new stage in the pipeline */
 struct ia_css_pipeline_stage_desc {
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/src/pipeline.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/src/pipeline.c
index 95542fc82217..9e74df951d6a 100644
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
index e882b5596813..9439d643fd03 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -112,8 +112,6 @@ static int thread_alive;
 #define STATS_ENABLED(stage) (stage && stage->binary && stage->binary->info && \
         (stage->binary->info->sp.enable.s3a || stage->binary->info->sp.enable.dis))
 
-#define DEFAULT_PLANES { {0, 0, 0, 0} }
-
 struct sh_css my_css;
 
 int (*sh_css_printf) (const char *fmt, va_list args) = NULL;
@@ -2293,25 +2291,19 @@ init_pipe_defaults(enum ia_css_pipe_mode mode,
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
@@ -2319,11 +2311,11 @@ init_pipe_defaults(enum ia_css_pipe_mode mode,
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
@@ -2333,7 +2325,7 @@ init_pipe_defaults(enum ia_css_pipe_mode mode,
 		break;
 	case IA_CSS_PIPE_MODE_YUVPP:
 		pipe->mode = IA_CSS_PIPE_ID_YUVPP;
-		pipe->pipe_settings.yuvpp = yuvpp;
+		pipe->pipe_settings.yuvpp = IA_CSS_DEFAULT_YUVPP_SETTINGS;
 		break;
 	default:
 		return IA_CSS_ERR_INVALID_ARGUMENTS;
@@ -8827,10 +8819,8 @@ sh_css_init_host_sp_control_vars(void)
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
index e12789236bb9..cc9b432b63ef 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_legacy.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_legacy.h
@@ -52,16 +52,17 @@ struct ia_css_pipe_extra_config {
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
+#define DEFAULT_PIPE_EXTRA_CONFIG ( \
+	(struct ia_css_pipe_extra_config) { \
+		.enable_raw_binning	= false, \
+		.enable_yuv_ds		= false, \
+		.enable_high_speed	= false, \
+		.enable_dvs_6axis	= false, \
+		.enable_reduced_pipe	= false, \
+		.enable_fractional_ds	= false, \
+		.disable_vf_pp		= false, \
+	} \
+)
 
 enum ia_css_err
 ia_css_pipe_create_extra(const struct ia_css_pipe_config *config,
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_metrics.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_metrics.h
index 40840ea318ab..e5f49d1f5390 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_metrics.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_metrics.h
@@ -24,15 +24,14 @@ struct sh_css_pc_histogram {
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
+#define DEFAULT_PC_HISTOGRAM ( \
+	(struct sh_css_pc_histogram) { \
+		.length	= 0, \
+		.run	= NULL, \
+		.stall	= NULL, \
+		.msink	= NULL \
+	} \
+)
 
 struct sh_css_binary_metrics {
 	unsigned mode;
@@ -42,16 +41,15 @@ struct sh_css_binary_metrics {
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
+#define DEFAULT_BINARY_METRICS ( \
+	(struct sh_css_binary_metrics) { \
+		.mode		= 0, \
+		.id		= 0, \
+		.isp_histogram	= DEFAULT_PC_HISTOGRAM, \
+		.sp_histogram	= DEFAULT_PC_HISTOGRAM, \
+		.next		= NULL \
+	} \
+)
 
 struct ia_css_frame_metrics {
 	unsigned num_frames;

base-commit: 37cb8e1f8e10c6e9bd2a1b95cdda0620a21b0551
-- 
2.15.0
