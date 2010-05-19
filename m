Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:55173 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423Ab0ESDRN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 23:17:13 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 19 May 2010 11:16:13 +0800
Subject: [PATCH v3 08/10] V4L2 ISP driver patchset for Intel Moorestown
 Camera Imaging Subsystem
Message-ID: <33AB447FBD802F4E932063B962385B351E895DA3@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From f387e310745d641f475f548b2e72c3dca9d968ec Mon Sep 17 00:00:00 2001
From: Xiaolin Zhang <xiaolin.zhang@intel.com>
Date: Tue, 18 May 2010 15:51:04 +0800
Subject: [PATCH 08/10] This patch is a part of v4l2 ISP patchset for Intel Moorestown camera imaging
 subsystem support which isp/sensor data structure declare.

Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
---
 .../media/video/mrstisp/include/ci_isp_common.h    |  937 ++++++++++++++++++++
 .../video/mrstisp/include/ci_isp_fmts_common.h     |  124 +++
 .../media/video/mrstisp/include/ci_sensor_common.h |  766 ++++++++++++++++
 drivers/media/video/mrstisp/include/mrstisp.h      |  248 ++++++
 .../media/video/mrstisp/include/mrstisp_stdinc.h   |  146 +++
 5 files changed, 2221 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/mrstisp/include/ci_isp_common.h
 create mode 100644 drivers/media/video/mrstisp/include/ci_isp_fmts_common.h
 create mode 100644 drivers/media/video/mrstisp/include/ci_sensor_common.h
 create mode 100644 drivers/media/video/mrstisp/include/mrstisp.h
 create mode 100644 drivers/media/video/mrstisp/include/mrstisp_stdinc.h

diff --git a/drivers/media/video/mrstisp/include/ci_isp_common.h b/drivers/media/video/mrstisp/include/ci_isp_common.h
new file mode 100644
index 0000000..8240b3a
--- /dev/null
+++ b/drivers/media/video/mrstisp/include/ci_isp_common.h
@@ -0,0 +1,937 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * Copyright (c) Silicon Image 2008  www.siliconimage.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#ifndef _CI_ISP_COMMON_H
+#define _CI_ISP_COMMON_H
+
+#include "v4l2_jpg_review.h"
+
+/*
+ * MARVIN VI ID defines -> changed to MARVIN_FEATURE_CHIP_ID and moved to
+ * the other chip features in project_settings.h
+ * JPEG compression ratio defines
+ */
+
+#define CI_ISP_JPEG_HIGH_COMPRESSION    1
+#define CI_ISP_JPEG_LOW_COMPRESSION     2
+
+/* Low Compression / High Quality */
+#define CI_ISP_JPEG_01_PERCENT          3
+#define CI_ISP_JPEG_20_PERCENT          4
+#define CI_ISP_JPEG_30_PERCENT          5
+#define CI_ISP_JPEG_40_PERCENT          6
+
+/* Mid Compression / Mid Quality */
+#define CI_ISP_JPEG_50_PERCENT          7
+#define CI_ISP_JPEG_60_PERCENT          8
+#define CI_ISP_JPEG_70_PERCENT          9
+#define CI_ISP_JPEG_80_PERCENT         10
+#define CI_ISP_JPEG_90_PERCENT         11
+
+/* High Compression / Low Quality */
+#define CI_ISP_JPEG_99_PERCENT         12
+
+/* Size of lens shading data table in 16 Bit words */
+#define CI_ISP_DATA_TBL_SIZE      289
+/* Size of lens shading grad table in 16 Bit words */
+#define CI_ISP_GRAD_TBL_SIZE        8
+/* Number of lens shading sectors in x or y direction */
+#define CI_ISP_MAX_LSC_SECTORS     16
+
+/*
+ * Value representing 1.0 for fixed-point values
+ * used by marvin drivers
+ */
+#define CI_ISP_FIXEDPOINT_ONE   (0x1000)
+
+enum ci_isp_jpe_enc_mode {
+       CI_ISP_JPE_LARGE_CONT_MODE = 0x04,
+       CI_ISP_JPE_SHORT_CONT_MODE = 0x02,
+       CI_ISP_JPE_SINGLE_SHOT = 0x01
+};
+
+/* for demosaic mode */
+enum ci_isp_demosaic_mode {
+       CI_ISP_DEMOSAIC_STANDARD,
+       CI_ISP_DEMOSAIC_ENHANCED
+};
+
+struct ci_isp_window{
+       unsigned short hoffs;
+       unsigned short voffs;
+       unsigned short hsize;
+       unsigned short vsize;
+};
+
+/* scale settings for both self and main resize unit */
+struct ci_isp_scale {
+       u32 scale_hy;
+       u32 scale_hcb;
+       u32 scale_hcr;
+       u32 scale_vy;
+       u32 scale_vc;
+       u16 phase_hy;
+       u16 phase_hc;
+       u16 phase_vy;
+       u16 phase_vc;
+};
+
+/* A Lookup table for the upscale parameter in the self and main scaler */
+struct ci_isp_rsz_lut{
+       u8 rsz_lut[64];
+};
+
+/* flag to set in scalefactor values to enable upscaling */
+#define RSZ_UPSCALE_ENABLE 0x8000
+
+
+/*
+ * Flag to set in scalefactor values to bypass the scaler block.
+ * Since this define is also used in calculations of scale factors and
+ * coordinates, it needs to reflect the scale factor precision. In other
+ * words:
+ * RSZ_SCALER_BYPASS = max. scalefactor value> + 1
+ */
+#define RSZ_SCALER_BYPASS  0x4000
+#define RSZ_FLAGS_MASK (RSZ_UPSCALE_ENABLE | RSZ_SCALER_BYPASS)
+
+/* color settings */
+struct ci_isp_color_settings {
+       u8 contrast;
+       u8 brightness;
+       u8 saturation;
+       u8 hue;
+       u32 flags;
+};
+
+/* color processing chrominance clipping range */
+#define CI_ISP_CPROC_C_OUT_RANGE       0x08
+/* color processing luminance input range (offset processing) */
+#define CI_ISP_CPROC_Y_IN_RANGE        0x04
+/* color processing luminance output clipping range */
+#define CI_ISP_CPROC_Y_OUT_RANGE       0x02
+/* color processing enable */
+#define CI_ISP_CPROC_ENABLE            0x01
+
+/* black level config */
+struct ci_isp_blc_config {
+       int bls_auto;
+       int henable;
+       int venable;
+       u16 hstart;
+       u16 hstop;
+       u16 vstart;
+       u16 vstop;
+       u8 blc_samples;
+       u8 ref_a;
+       u8 ref_b;
+       u8 ref_c;
+       u8 ref_d;
+};
+
+/* black level compensation mean values */
+struct ci_isp_blc_mean {
+       u8 mean_a;
+       u8 mean_b;
+       u8 mean_c;
+       u8 mean_d;
+};
+
+/* BLS window */
+struct ci_isp_bls_window {
+       int enable_window;
+       u16 start_h;
+       u16 stop_h;
+       u16 start_v;
+       u16 stop_v;
+};
+
+/* BLS mean measured values */
+struct ci_isp_bls_measured {
+       u16 meas_a;
+       u16 meas_b;
+       u16 meas_c;
+       u16 meas_d;
+};
+
+/*
+ * BLS fixed subtraction values. The values will be subtracted from the sensor
+ * values.  Therefore a negative value means addition instead of subtraction
+ */
+struct ci_isp_bls_subtraction {
+       s16 fixed_a;
+       s16 fixed_b;
+       s16 fixed_c;
+       s16 fixed_d;
+};
+
+/* BLS configuration */
+struct ci_isp_bls_config {
+       int enable_automatic;
+       int disable_h;
+       int disable_v;
+       struct ci_isp_bls_window isp_bls_window1;
+       struct ci_isp_bls_window isp_bls_window2;
+       u8 bls_samples;
+       struct ci_isp_bls_subtraction bls_subtraction;
+};
+
+/* white balancing modes for the marvin hardware */
+enum ci_isp_awb_mode {
+       CI_ISP_AWB_COMPLETELY_OFF = 0,
+       CI_ISP_AWB_AUTO,
+       CI_ISP_AWB_MAN_MEAS,
+       CI_ISP_AWB_MAN_NOMEAS,
+       CI_ISP_AWB_MAN_PUSH_AUTO,
+       CI_ISP_AWB_ONLY_MEAS
+};
+
+/* white balancing modes for the marvin hardware */
+enum ci_isp_awb_sub_mode {
+       CI_ISP_AWB_SUB_OFF = 0,
+       CI_ISP_AWB_MAN_DAYLIGHT,
+       CI_ISP_AWB_MAN_CLOUDY,
+       CI_ISP_AWB_MAN_SHADE,
+       CI_ISP_AWB_MAN_FLUORCNT,
+       CI_ISP_AWB_MAN_FLUORCNTH,
+       CI_ISP_AWB_MAN_TUNGSTEN,
+       CI_ISP_AWB_MAN_TWILIGHT,
+       CI_ISP_AWB_MAN_SUNSET,
+       CI_ISP_AWB_MAN_FLASH,
+       CI_ISP_AWB_MAN_CIE_D65,
+       CI_ISP_AWB_MAN_CIE_D75,
+       CI_ISP_AWB_MAN_CIE_F2,
+       CI_ISP_AWB_MAN_CIE_F11,
+       CI_ISP_AWB_MAN_CIE_F12,
+       CI_ISP_AWB_MAN_CIE_A,
+       CI_ISP_AWB_AUTO_ON
+};
+
+/*
+ * white balancing gains
+ * xiaolin, typedef ci_sensor_component_gain tsMrvWbGains;
+ * white balancing measurement configuration
+ */
+struct ci_isp_wb_meas_config {
+       struct ci_isp_window awb_window;
+       u8 max_y;
+       u8 ref_cr_max_r;
+       u8 min_y_max_g;
+       u8 ref_cb_max_b;
+       u8 max_csum;
+       u8 min_c;
+       u8 frames;
+       u8 meas_mode;
+};
+
+/* white balancing measurement configuration limits */
+struct ci_isp_wb_meas_conf_limit {
+       u8 min_y_max;
+       u8 min_y_min;
+       u8 min_c_max;
+       u8 min_c_min;
+       u8 max_csum_max;
+       u8 max_csum_min;
+       u8 white_percent_max;
+       u8 white_percent_min;
+       u8 error_counter;
+};
+
+/* white balancing HW automatic configuration */
+struct ci_isp_wb_auto_hw_config {
+       u8 ref_cr;
+       u8 ref_cb;
+       u8 unlock_dly;
+       u8 unlock_rng;
+       u8 lock_dly;
+       u8 lock_rng;
+       u8 step;
+       u8 max_gain;
+       u8 min_gain;
+};
+
+/* white balancing configuration */
+struct ci_isp_wb_config {
+       enum ci_isp_awb_mode mrv_wb_mode;
+       enum ci_isp_awb_sub_mode mrv_wb_sub_mode;
+       struct ci_isp_wb_meas_config mrv_wb_meas_conf;
+       struct ci_isp_wb_auto_hw_config mrv_wb_auto_hw_conf;
+       struct ci_isp_wb_meas_conf_limit mrv_wb_meas_conf_limit;
+       u8 awb_pca_damping;
+       u8 awb_prior_exp_damping;
+       u8 awb_pca_push_damping;
+       u8 awb_prior_exp_push_damping;
+       u8 awb_auto_max_y;
+       u8 awb_push_max_y;
+       u8 awb_measure_max_y;
+       u16 awb_underexp_det;
+       u16 awb_push_underexp_det;
+
+};
+
+/* possible AEC modes */
+enum ci_isp_aec_mode {
+       CI_ISP_AEC_OFF,
+       CI_ISP_AEC_INTEGRAL,
+       CI_ISP_AEC_SPOT,
+       CI_ISP_AEC_MFIELD5,
+       CI_ISP_AEC_MFIELD9
+};
+
+/*
+ * histogram weight 5x5 matrix coefficients
+* (possible values are 1=0x10,15/16=0x0F,14/16,...,1/16,0)
+*/
+struct ci_isp_hist_matrix {
+       u8 weight_00; u8 weight_10; u8 weight_20; u8 weight_30; u8 weight_40;
+       u8 weight_01; u8 weight_11; u8 weight_21; u8 weight_31; u8 weight_41;
+       u8 weight_02; u8 weight_12; u8 weight_22; u8 weight_32; u8 weight_42;
+       u8 weight_03; u8 weight_13; u8 weight_23; u8 weight_33; u8 weight_43;
+       u8 weight_04; u8 weight_14; u8 weight_24; u8 weight_34; u8 weight_44;
+};
+
+/* autoexposure config */
+struct ci_isp_aec_config {
+       struct ci_isp_window isp_aec_mean_luma_window;
+       struct ci_isp_window isp_aec_hist_calc_window;
+       struct ci_isp_hist_matrix isp_aec_hist_calc_weight;
+       enum ci_isp_aec_mode advanced_aec_mode;
+};
+
+/* autoexposure mean values */
+struct ci_isp_aec_mean {
+       u8 occ;
+       u8 mean;
+       u8 max;
+       u8 min;
+};
+
+/* histogram weight 5x5 matrix coefficients
+ * (possible values are 1=0x10,15/16=0x0F,14/16,...,1/16,0)
+ */
+struct tsMrvHistMatrix {
+       u8 weight_00; u8 weight_10; u8 weight_20; u8 weight_30; u8 weight_40;
+       u8 weight_01; u8 weight_11; u8 weight_21; u8 weight_31; u8 weight_41;
+       u8 weight_02; u8 weight_12; u8 weight_22; u8 weight_32; u8 weight_42;
+       u8 weight_03; u8 weight_13; u8 weight_23; u8 weight_33; u8 weight_43;
+       u8 weight_04; u8 weight_14; u8 weight_24; u8 weight_34; u8 weight_44;
+};
+
+/*
+ * vi_dpcl path selector, channel mode
+ * Configuration of the Y/C splitter
+ */
+enum ci_isp_ycs_chn_mode {
+       CI_ISP_YCS_Y,
+       CI_ISP_YCS_MV_SP,
+       CI_ISP_YCS_MV,
+       CI_ISP_YCS_SP,
+       CI_ISP_YCS_MVRAW,
+       CI_ISP_YCS_OFF
+};
+
+/* vi_dpcl path selector, main path cross-switch */
+enum ci_isp_dp_switch {
+       CI_ISP_DP_RAW,
+       CI_ISP_DP_JPEG,
+       CI_ISP_DP_MV
+};
+
+/* ISP path selector */
+enum ci_isp_path {
+       CI_ISP_PATH_UNKNOWN = 0,
+       CI_ISP_PATH_RAW = 1,
+       CI_ISP_PATH_YCBCR = 2,
+       CI_ISP_PATH_BAYER = 3
+};
+
+/* possible autofocus measurement modes */
+enum ci_isp_afm_mode {
+       CI_ISP_AFM_OFF,
+       CI_ISP_AFM_HW,
+       CI_ISP_AFM_SW_TENENGRAD,
+       CI_ISP_AFM_SW_TRESH_SQRT_GRAD,
+       CI_ISP_AFM_SW_FSWMEDIAN,
+       CI_ISP_AFM_HW_norm,
+       CI_ISP_AFM_SW_TENENGRAD_norm,
+       CI_ISP_AFM_SW_FSWMEDIAN_norm
+};
+
+/* possible autofocus search strategy modes */
+enum ci_isp_afss_mode {
+       CI_ISP_AFSS_OFF,
+       CI_ISP_AFSS_FULL_RANGE,
+       CI_ISP_AFSS_HILLCLIMBING,
+       CI_ISP_AFSS_ADAPTIVE_RANGE,
+       CI_ISP_AFSS_HELIMORPH_OPT,
+};
+
+/* possible bad pixel correction type */
+enum ci_isp_bp_corr_type {
+       CI_ISP_BP_CORR_TABLE,
+       CI_ISP_BP_CORR_DIRECT
+};
+
+/* possible bad pixel replace approach */
+enum ci_isp_bp_corr_rep {
+       CI_ISP_BP_CORR_REP_NB,
+       CI_ISP_BP_CORR_REP_LIN
+};
+
+/* possible bad pixel correction mode */
+enum ci_isp_bp_corr_mode {
+       CI_ISP_BP_CORR_HOT_EN,
+       CI_ISP_BP_CORR_DEAD_EN,
+       CI_ISP_BP_CORR_HOT_DEAD_EN
+};
+
+/* Gamma out curve (independent from the sensor characteristic). */
+#define CI_ISP_GAMMA_OUT_CURVE_ARR_SIZE (17)
+
+struct ci_isp_gamma_out_curve {
+       u16 isp_gamma_y[CI_ISP_GAMMA_OUT_CURVE_ARR_SIZE];
+       u8 gamma_segmentation;
+};
+
+/* configuration of autofocus measurement block */
+struct ci_isp_af_config {
+       struct ci_isp_window wnd_pos_a;
+       struct ci_isp_window wnd_pos_b;
+       struct ci_isp_window wnd_pos_c;
+       u32 threshold;
+       u32 var_shift;
+};
+
+/* measurement results of autofocus measurement block */
+struct ci_isp_af_meas {
+       u32 afm_sum_a;
+       u32 afm_sum_b;
+       u32 afm_sum_c;
+       u32 afm_lum_a;
+       u32 afm_lum_b;
+       u32 afm_lum_c;
+};
+
+/* configuration for correction of bad pixel block */
+struct ci_isp_bp_corr_config {
+       enum ci_isp_bp_corr_type bp_corr_type;
+       enum ci_isp_bp_corr_rep bp_corr_rep;
+       enum ci_isp_bp_corr_mode bp_corr_mode;
+       u16 bp_abs_hot_thres;
+       u16 bp_abs_dead_thres;
+       u16 bp_dev_hot_thres;
+       u16 bp_dev_dead_thres;
+};
+
+/* configuration for correction of lens shading */
+struct ci_isp_ls_corr_config {
+       u16 ls_rdata_tbl[CI_ISP_DATA_TBL_SIZE];
+       u16 ls_gdata_tbl[CI_ISP_DATA_TBL_SIZE];
+       u16 ls_bdata_tbl[CI_ISP_DATA_TBL_SIZE];
+       u16 ls_xgrad_tbl[CI_ISP_GRAD_TBL_SIZE];
+       u16 ls_ygrad_tbl[CI_ISP_GRAD_TBL_SIZE];
+       u16 ls_xsize_tbl[CI_ISP_GRAD_TBL_SIZE];
+       u16 ls_ysize_tbl[CI_ISP_GRAD_TBL_SIZE];
+
+};
+
+/* configuration for detection of bad pixel block */
+struct ci_isp_bp_det_config {
+       u32 bp_dead_thres;
+};
+
+/* new table element */
+struct ci_isp_bp_new_table_elem {
+       u16 bp_ver_addr;
+       u16 bp_hor_addr;
+       u8 bp_msb_value;
+};
+
+/* new Bad Pixel table */
+struct ci_isp_bp_new_table {
+       u32 bp_number;
+       struct ci_isp_bp_new_table_elem bp_new_table_elem[8];
+};
+
+/* image effect modes */
+enum ci_isp_ie_mode {
+       CI_ISP_IE_MODE_OFF,
+       CI_ISP_IE_MODE_GRAYSCALE,
+       CI_ISP_IE_MODE_NEGATIVE,
+       CI_ISP_IE_MODE_SEPIA,
+       CI_ISP_IE_MODE_COLOR_SEL,
+       CI_ISP_IE_MODE_EMBOSS,
+       CI_ISP_IE_MODE_SKETCH
+};
+
+/* image effect color selection */
+enum ci_isp_ie_color_sel {
+       CI_ISP_IE_MAINTAIN_RED = 0x04,
+       CI_ISP_IE_MAINTAIN_GREEN = 0x02,
+       CI_ISP_IE_MAINTAIN_BLUE = 0x01
+};
+
+/*
+ * image effect 3x3 matrix coefficients (possible values are -8, -4, -2, -1,
+ * 0, 1, 2, 4, 8)
+ */
+struct ci_isp_ie_matrix {
+       s8 coeff_11;
+       s8 coeff_12;
+       s8 coeff_13;
+       s8 coeff_21;
+       s8 coeff_22;
+       s8 coeff_23;
+       s8 coeff_31;
+       s8 coeff_32;
+       s8 coeff_33;
+};
+
+/* image effect configuration struct */
+struct ci_isp_ie_config {
+       enum ci_isp_ie_mode mode;
+       u8 color_sel;
+       u8 color_thres;
+       u8 tint_cb;
+       u8 tint_cr;
+       struct ci_isp_ie_matrix mat_emboss;
+       struct ci_isp_ie_matrix mat_sketch;
+};
+
+/* super impose transparency modes */
+enum ci_isp_si_trans_mode {
+       CI_ISP_SI_TRANS_UNKNOWN = 0,
+       CI_ISP_SI_TRANS_ENABLE = 1,
+       CI_ISP_SI_TRANS_DISABLE = 2
+};
+
+/* super impose reference image */
+enum ci_isp_si_ref_image {
+       CI_ISP_SI_REF_IMG_UNKNOWN = 0,
+       CI_ISP_SI_REF_IMG_SENSOR = 1,
+       CI_ISP_SI_REF_IMG_MEMORY = 2
+};
+
+/* super impose configuration struct */
+struct ci_isp_si_config {
+       enum ci_isp_si_trans_mode trans_mode;
+       enum ci_isp_si_ref_image ref_image;
+       u16 offs_x;
+       u16 offs_y;
+       u8 trans_comp_y;
+       u8 trans_comp_cb;
+       u8 trans_comp_cr;
+};
+
+/* image stabilisation modes */
+enum ci_isp_is_mode {
+       CI_ISP_IS_MODE_UNKNOWN = 0,
+       CI_ISP_IS_MODE_ON = 1,
+       CI_ISP_IS_MODE_OFF = 2
+};
+
+/* image stabilisation configuration struct */
+struct ci_isp_is_config {
+       struct ci_isp_window mrv_is_window;
+       u16 max_dx;
+       u16 max_dy;
+};
+
+/* image stabilisation control struct */
+struct ci_isp_is_ctrl {
+       enum ci_isp_is_mode is_mode;
+       u8 recenter;
+};
+
+/* for data path switching */
+enum ci_isp_data_path {
+       CI_ISP_PATH_RAW816,
+       CI_ISP_PATH_RAW8,
+       CI_ISP_PATH_JPE,
+       CI_ISP_PATH_OFF,
+       CI_ISP_PATH_ON
+};
+
+/* buffer for memory interface */
+struct ci_isp_buffer_old {
+       u8 *pucbuffer;
+       u32 size;
+       u32 offs;
+       u32 irq_offs_llength;
+       u8 *pucmalloc_start;
+};
+
+/* color format for self picture input/output and DMA input */
+enum ci_isp_mif_col_format {
+       CI_ISP_MIF_COL_FORMAT_YCBCR_422 = 0,
+       CI_ISP_MIF_COL_FORMAT_YCBCR_444 = 1,
+       CI_ISP_MIF_COL_FORMAT_YCBCR_420 = 2,
+       CI_ISP_MIF_COL_FORMAT_YCBCR_400 = 3,
+       CI_ISP_MIF_COL_FORMAT_RGB_565 = 4,
+       CI_ISP_MIF_COL_FORMAT_RGB_666 = 5,
+       CI_ISP_MIF_COL_FORMAT_RGB_888 = 6
+};
+
+/* color range for self picture input of RGB m*/
+enum ci_isp_mif_col_range {
+    mrv_mif_col_range_std  = 0,
+    mrv_mif_col_range_full = 1
+};
+
+/* color phase for self picture input of RGB */
+enum ci_isp_mif_col_phase {
+    mrv_mif_col_phase_cosited     = 0,
+    mrv_mif_col_phase_non_cosited = 1
+};
+
+/*
+ * picture write/read format
+ * The following examples apply to YCbCr 4:2:2 images, as all modes
+ */
+ enum ci_isp_mif_pic_form {
+       CI_ISP_MIF_PIC_FORM_PLANAR = 0,
+       CI_ISP_MIF_PIC_FORM_SEMI_PLANAR = 1,
+       CI_ISP_MIF_PIC_FORM_INTERLEAVED = 2
+};
+
+/* self picture operating modes */
+enum ci_isp_mif_sp_mode {
+       CI_ISP_MIF_SP_ORIGINAL = 0,
+       CI_ISP_MIF_SP_VERTICAL_FLIP = 1,
+       CI_ISP_MIF_SP_HORIZONTAL_FLIP = 2,
+       CI_ISP_MIF_SP_ROTATION_090_DEG = 3,
+       CI_ISP_MIF_SP_ROTATION_180_DEG = 4,
+       CI_ISP_MIF_SP_ROTATION_270_DEG = 5,
+       CI_ISP_MIF_SP_ROT_090_V_FLIP = 6,
+       CI_ISP_MIF_SP_ROT_270_V_FLIP = 7
+};
+
+/* MI burst length settings */
+enum ci_isp_mif_burst_length {
+       CI_ISP_MIF_BURST_LENGTH_4 = 0,
+       CI_ISP_MIF_BURST_LENGTH_8 = 1,
+       CI_ISP_MIF_BURST_LENGTH_16 = 2
+};
+
+
+/* MI apply initial values settings */
+enum ci_isp_mif_init_vals {
+       CI_ISP_MIF_NO_INIT_VALS = 0,
+       CI_ISP_MIF_INIT_OFFS = 1,
+       CI_ISP_MIF_INIT_BASE = 2,
+       CI_ISP_MIF_INIT_OFFSAndBase = 3
+};
+
+/* MI when to update configuration */
+enum ci_isp_conf_update_time {
+       CI_ISP_CFG_UPDATE_FRAME_SYNC = 0,
+       CI_ISP_CFG_UPDATE_IMMEDIATE = 1,
+       CI_ISP_CFG_UPDATE_LATER = 2
+};
+
+/* control register of the MI */
+struct ci_isp_mi_ctrl {
+       enum ci_isp_mif_col_format mrv_mif_sp_out_form;
+       enum ci_isp_mif_col_format mrv_mif_sp_in_form;
+       enum ci_isp_mif_col_range mrv_mif_sp_in_range;
+       enum ci_isp_mif_col_phase mrv_mif_sp_in_phase;
+       enum ci_isp_mif_pic_form mrv_mif_sp_pic_form;
+       enum ci_isp_mif_pic_form mrv_mif_mp_pic_form;
+       enum ci_isp_mif_burst_length burst_length_chrom;
+       enum ci_isp_mif_burst_length burst_length_lum;
+       enum ci_isp_mif_init_vals init_vals;
+       int byte_swap_enable;
+       int last_pixel_enable;
+       enum ci_isp_mif_sp_mode mrv_mif_sp_mode;
+       enum ci_isp_data_path main_path;
+       enum ci_isp_data_path self_path;
+       u32 irq_offs_init;
+
+};
+
+/* buffer for memory interface */
+struct ci_isp_buffer {
+       u8 *pucbuffer;
+       u32 size;
+       u32 offs;
+};
+
+/* main or self picture path, or DMA configuration */
+struct ci_isp_mi_path_conf {
+       u32 ypic_width;
+       u32 ypic_height;
+       u32 llength;
+       struct ci_isp_buffer ybuffer;
+       struct ci_isp_buffer cb_buffer;
+       struct ci_isp_buffer cr_buffer;
+};
+
+/* DMA configuration */
+struct ci_isp_mi_dma_conf {
+       int start_dma;
+       int frame_end_disable;
+       int byte_swap_enable;
+       int continuous_enable;
+       enum ci_isp_mif_col_format mrv_mif_col_format;
+       enum ci_isp_mif_pic_form mrv_mif_pic_form;
+       enum ci_isp_mif_burst_length burst_length_chrom;
+       enum ci_isp_mif_burst_length burst_length_lum;
+       int via_cam_path;
+};
+
+/*
+ * configuration of chromatic aberration correction block (given to the
+ * CAC driver)
+ */
+struct ci_isp_cac_config {
+       u16 hsize;
+       u16 vsize;
+       s16 hcenter_offset;
+       s16 vcenter_offset;
+       u8 hclip_mode;
+       u8 vclip_mode;
+       u16 ablue;
+       u16 ared;
+       u16 bblue;
+       u16 bred;
+       u16 cblue;
+       u16 cred;
+       float aspect_ratio;
+};
+
+/*
+ * register values of chromatic aberration correction block (delivered by
+ * the CAC driver)
+ */
+struct ci_isp_cac_reg_values {
+       u8 hclip_mode;
+       u8 vclip_mode;
+       int cac_enabled;
+       u16 hcount_start;
+       u16 vcount_start;
+       u16 ablue;
+       u16 ared;
+       u16 bblue;
+       u16 bred;
+       u16 cblue;
+       u16 cred;
+       u8 xnorm_shift;
+       u8 xnorm_factor;
+       u8 ynorm_shift;
+       u8 ynorm_factor;
+};
+
+struct ci_snapshot_config {
+       u32 flags;
+       int user_zoom;
+       int user_w;
+       int user_h;
+       u8 compression_ratio;
+};
+
+struct ci_isp_view_finder_config {
+       u32 flags;
+       int zoom;
+       int lcd_contrast;
+       int x;
+       int y;
+       int w;
+       int h;
+       int keep_aspect;
+};
+
+#define CI_ISP_HIST_DATA_BIN_ARR_SIZE 16
+
+struct ci_isp_hist_data_bin {
+       u8 hist_bin[CI_ISP_HIST_DATA_BIN_ARR_SIZE];
+};
+
+#define MRV_MEAN_LUMA_ARR_SIZE_COL 5
+#define MRV_MEAN_LUMA_ARR_SIZE_ROW 5
+#define MRV_MEAN_LUMA_ARR_SIZE     \
+       (MRV_MEAN_LUMA_ARR_SIZE_COL*MRV_MEAN_LUMA_ARR_SIZE_ROW)
+
+struct ci_isp_mean_luma {
+    u8 mean_luma_block[MRV_MEAN_LUMA_ARR_SIZE_COL][MRV_MEAN_LUMA_ARR_SIZE_ROW];
+};
+
+/* Structure contains bits autostop and exp_meas_mode of isp_exp_ctrl */
+struct ci_isp_exp_ctrl {
+    int auto_stop;
+    int exp_meas_mode;
+    int exp_start;
+} ;
+
+
+struct ci_isp_cfg_flags {
+       /*
+        * following flag tripels controls the behaviour of the associated
+        * marvin control loops.
+        * For feature XXX, the 3 flags are totally independant and
+        * have the following meaning:
+        * fXXX:
+        * If set, there is any kind of software interaction during runtime
+        * thatmay lead to a modification of the feature-dependant settings.
+        * For each frame, a feature specific loop control routine is called
+        * may perform other actions based on feature specific configuration.
+        * If not set, only base settings will be applied during setup, or the
+        * reset values are left unchanged. No control routine will be called
+        * inside the processing loop.
+        * fXXXprint:
+        * If set, some status informations will be printed out inside
+        * the processing loop.  Status printing is independant of the
+        * other flags regarding this feature.
+        * fXXX_dis:
+        * If set, the feature dependant submodule of the marvin is
+        * disabled or is turned into bypass mode. Note that it is
+        * still possible to set one or more of the other flags too,
+        * but this wouldn't make much sense...
+        * lens shading correction
+        */
+
+       unsigned int lsc:1;
+       unsigned int lscprint:1;
+       unsigned int lsc_dis:1;
+
+       unsigned int bpc:1;
+       unsigned int bpcprint:1;
+       unsigned int bpc_dis:1;
+
+       unsigned int bls:1;
+       unsigned int bls_man:1;
+       unsigned int bls_smia:1;
+       unsigned int blsprint:1;
+       unsigned int bls_dis:1;
+
+       unsigned int awb:1;
+       unsigned int awbprint:1;
+       unsigned int awbprint2:1;
+       unsigned int awb_dis:1;
+
+       unsigned int aec:1;
+       unsigned int aecprint:1;
+       unsigned int aec_dis:1;
+       unsigned int aec_sceval:1;
+
+       unsigned int af:1;
+       unsigned int afprint:1;
+       unsigned int af_dis:1;
+
+       unsigned int cp:1;
+       unsigned int gamma:1;
+       unsigned int cconv:1;
+       unsigned int demosaic:1;
+       unsigned int gamma2:1;
+       unsigned int isp_filters:1;
+       unsigned int cac:1;
+
+       unsigned int cp_sat_loop:1;
+       unsigned int cp_contr_loop:1;
+       unsigned int cp_bright_loop:1;
+       unsigned int scaler_loop:1;
+       unsigned int cconv_basic:1;
+
+       unsigned int cycle_ie_mode:1;
+
+       unsigned int continous_af:1;
+
+       unsigned int bad_pixel_generation:1;
+       unsigned int ycbcr_full_range:1;
+       unsigned int ycbcr_non_cosited:1;
+};
+
+struct ci_isp_config {
+       struct ci_isp_cfg_flags flags;
+       struct ci_sensor_ls_corr_config lsc_cfg;
+       struct ci_isp_bp_corr_config bpc_cfg;
+       struct ci_isp_bp_det_config bpd_cfg;
+       struct ci_isp_wb_config wb_config;
+       struct ci_isp_cac_config cac_config;
+       struct ci_isp_aec_config aec_cfg;
+       struct ci_isp_window aec_v2_wnd;
+       struct ci_isp_bls_config bls_cfg;
+       struct ci_isp_af_config af_cfg;
+       struct ci_isp_color_settings color;
+       struct ci_isp_ie_config img_eff_cfg;
+       enum ci_isp_demosaic_mode demosaic_mode;
+       u8 demosaic_th;
+       u8 exposure;
+       enum ci_isp_aec_mode advanced_aec_mode;
+       u32 report_details;
+       struct ci_isp_view_finder_config view_finder;
+       struct ci_snapshot_config snapshot_a;
+       struct ci_snapshot_config snapshot_b;
+       enum ci_isp_afm_mode afm_mode;
+       enum ci_isp_afss_mode afss_mode;
+       int wb_get_gains_from_sensor_driver;
+       u8 filter_level_noise_reduc;
+       u8 filter_level_sharp;
+       u8 jpeg_enc_ratio;
+};
+
+struct ci_isp_mem_info {
+       u32 isp_bar0_pa;
+       u32 isp_bar0_size;
+       u32 isp_bar1_pa;
+       u32 isp_bar1_size;
+};
+
+struct ci_pl_system_config {
+       struct ci_sensor_config *isi_config;
+       struct ci_sensor_caps *isi_caps;
+       struct ci_sensor_awb_profile *sensor_awb_profile;
+
+       struct ci_isp_config isp_cfg;
+       u32 focus_max;
+       unsigned int isp_hal_enable;
+       struct v4l2_jpg_review_buffer jpg_review;
+       int jpg_review_enable;
+};
+
+/* intel private ioctl code for ci isp hal interface */
+#define BASE BASE_VIDIOC_PRIVATE
+
+#define VIDIOC_SET_SYS_CFG _IOWR('V', BASE + 1, struct ci_pl_system_config)
+#define VIDIOC_SET_JPG_ENC_RATIO _IOWR('V', BASE + 2, int)
+#define VIDIOC_GET_ISP_MEM_INFO _IOWR('V', BASE + 4, struct ci_isp_mem_info)
+
+/* buffer sharing with video subsystem */
+#include "ci_va.h"
+
+/* support camera flash on CDK */
+struct ci_isp_flash_cmd {
+       int preflash_on;
+       int flash_on;
+       int prelight_on;
+};
+
+struct ci_isp_flash_config {
+       int prelight_off_at_end_of_flash;
+       int vsync_edge_positive;
+       int output_polarity_low_active;
+       int use_external_trigger;
+       u8 capture_delay;
+};
+#endif
diff --git a/drivers/media/video/mrstisp/include/ci_isp_fmts_common.h b/drivers/media/video/mrstisp/include/ci_isp_fmts_common.h
new file mode 100644
index 0000000..b01d38f
--- /dev/null
+++ b/drivers/media/video/mrstisp/include/ci_isp_fmts_common.h
@@ -0,0 +1,124 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#ifndef _ISP_FMTS_COMMON_H
+#define _ISP_FMTS_COMMON_H
+
+#define intel_fourcc(d, c, b, a) \
+       (((__u32)(d)<<0)|((__u32)(c)<<8)|((__u32)(b)<<16)|((__u32)(a)<<24))
+
+/* bayer pattern formats support by ISP */
+#define INTEL_PIX_FMT_RAW08  intel_fourcc('R', 'W', '0', '8')
+#define INTEL_PIX_FMT_RAW10 intel_fourcc('R', 'W', '1', '0')
+#define INTEL_PIX_FMT_RAW12  intel_fourcc('R', 'W', '1', '2')
+
+
+/*
+ * various config and info structs concentrated into one struct
+ * for simplification
+ */
+#define FORMAT_FLAGS_DITHER       0x01
+#define FORMAT_FLAGS_PACKED       0x02
+#define FORMAT_FLAGS_PLANAR       0x04
+#define FORMAT_FLAGS_RAW          0x08
+#define FORMAT_FLAGS_CrCb         0x10
+
+struct intel_fmt {
+       char *name;
+       unsigned long fourcc; /* v4l2 format id */
+       int depth;
+       int flags;
+};
+
+static struct intel_fmt fmts[] = {
+       {
+       .name = "565 bpp RGB",
+       .fourcc = V4L2_PIX_FMT_RGB565,
+       .depth = 16,
+       .flags = FORMAT_FLAGS_PACKED,
+       },
+       {
+       .name = "888 bpp BGR",
+       .fourcc = V4L2_PIX_FMT_BGR32,
+       .depth = 32,
+       .flags = FORMAT_FLAGS_PLANAR,
+       },
+       {
+       .name = "4:2:2, packed, YUYV",
+       .fourcc = V4L2_PIX_FMT_YUYV,
+       .depth = 16,
+       .flags = FORMAT_FLAGS_PACKED,
+       },
+       {
+       .name = "4:2:2 planar, YUV422P",
+       .fourcc = V4L2_PIX_FMT_YUV422P,
+       .depth = 16,
+       .flags = FORMAT_FLAGS_PLANAR,
+       },
+       {
+       .name = "4:2:0 planar, YUV420",
+       .fourcc = V4L2_PIX_FMT_YUV420,
+       .depth = 12,
+       .flags = FORMAT_FLAGS_PLANAR,
+       },
+       {
+       .name = "4:2:0 planar, YVU420",
+       .fourcc = V4L2_PIX_FMT_YVU420,
+       .depth = 12,
+       .flags = FORMAT_FLAGS_PLANAR,
+       },
+       {
+       .name = "4:2:0 semi planar, NV12",
+       .fourcc = V4L2_PIX_FMT_NV12,
+       .depth = 12,
+       .flags = FORMAT_FLAGS_PLANAR,
+       },
+       {
+       .name = "Compressed format, JPEG",
+       .fourcc = V4L2_PIX_FMT_JPEG,
+       .depth = 12,
+       .flags = FORMAT_FLAGS_PLANAR,
+       },
+       {
+       .name = "Sequential RGB",
+       .fourcc = INTEL_PIX_FMT_RAW08,
+       .depth = 8,
+       .flags = FORMAT_FLAGS_RAW,
+       },
+       {
+       .name = "Sequential RGB",
+       .fourcc = INTEL_PIX_FMT_RAW10,
+       .depth = 16,
+       .flags = FORMAT_FLAGS_RAW,
+       },
+       {
+       .name = "Sequential RGB",
+       .fourcc = INTEL_PIX_FMT_RAW12,
+       .depth = 16,
+       .flags = FORMAT_FLAGS_RAW,
+       },
+};
+
+static int NUM_FORMATS = sizeof(fmts) / sizeof(struct intel_fmt);
+#endif /* _ISP_FMTS_H */
+
diff --git a/drivers/media/video/mrstisp/include/ci_sensor_common.h b/drivers/media/video/mrstisp/include/ci_sensor_common.h
new file mode 100644
index 0000000..77a75fc
--- /dev/null
+++ b/drivers/media/video/mrstisp/include/ci_sensor_common.h
@@ -0,0 +1,766 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * Copyright (c) Silicon Image 2008  www.siliconimage.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#ifndef _SENSOR_COMMON_H
+#define _SENSOR_COMMON_H
+
+#include "mrst_sensor_common.h"
+
+#define AEC_ALGO_V1    1
+#define AEC_ALGO_V2    2
+#define AEC_ALGO_V3    3
+#define AEC_ALGO_V4    4
+
+#ifndef AEC_ALGO
+#define AEC_ALGO       AEC_ALGO_V3
+#endif
+
+#define SENSOR_INTERFACE_VERSION 4
+#define SENSOR_TYPE_SOC        0
+#define SENSOR_TYPE_RAW        1
+#define SENSOR_TYPE_2M 0
+#define SENSOR_TYPE_5M 1
+
+#define SENSOR_BUSWIDTH_8BIT_ZZ    0x00000001
+#define SENSOR_BUSWIDTH_8BIT_EX    0x00000002
+#define SENSOR_BUSWIDTH_10BIT_EX   0x00000004
+#define SENSOR_BUSWIDTH_10BIT_ZZ   0x00000008
+#define SENSOR_BUSWIDTH_12BIT      0x00000010
+#define SENSOR_BUSWIDTH_10BIT      SENSOR_BUSWIDTH_10BIT_EX
+
+/* YUV-Data with separate h/v sync lines (ITU-R BT.601) */
+#define SENSOR_MODE_BT601            0x00000001
+
+/* YUV-Data with sync words inside the datastream (ITU-R BT.656) */
+#define SENSOR_MODE_BT656            0x00000002
+
+/* Bayer data with separate h/v sync lines */
+#define SENSOR_MODE_BAYER            0x00000004
+
+/*
+ * Any binary data without line/column-structure, (e.g. already JPEG encoded)
+ * h/v sync lines act as data valid signals
+ */
+#define SENSOR_MODE_DATA             0x00000008
+
+/* RAW picture data with separate h/v sync lines */
+#define SENSOR_MODE_PICT             0x00000010
+
+/* RGB565 data with separate h/v sync lines */
+#define SENSOR_MODE_RGB565           0x00000020
+
+/* SMIA conform data stream (see ulSmiaMode for details) */
+#define SENSOR_MODE_SMIA             0x00000040
+
+/* MIPI conform data stream (see ulMipiMode for details) */
+#define SENSOR_MODE_MIPI             0x00000080
+/*
+ * Bayer data with sync words inside the datastream (similar to ITU-R BT.656)
+ */
+#define SENSOR_MODE_BAY_BT656        0x00000100
+
+/*
+ * Raw picture data with sync words inside the datastream (similar to ITU-R
+ * BT.656)
+ */
+#define SENSOR_MODE_RAW_BT656        0x00000200
+
+/* compression mode */
+#define SENSOR_SMIA_MODE_COMPRESSED           0x00000001
+
+/* 8bit to 10 bit decompression */
+#define SENSOR_SMIA_MODE_RAW_8_TO_10_DECOMP   0x00000002
+
+/* 12 bit RAW Bayer Data */
+#define SENSOR_SMIA_MODE_RAW_12               0x00000004
+
+/* 10 bit RAW Bayer Data */
+#define SENSOR_SMIA_MODE_RAW_10               0x00000008
+
+/* 8 bit RAW Bayer Data */
+#define SENSOR_SMIA_MODE_RAW_8                0x00000010
+
+/* 7 bit RAW Bayer Data */
+#define SENSOR_SMIA_MODE_RAW_7                0x00000020
+
+/* 6 bit RAW Bayer Data */
+#define SENSOR_SMIA_MODE_RAW_6                0x00000040
+
+/* RGB 888 Display ready Data */
+#define SENSOR_SMIA_MODE_RGB_888              0x00000080
+
+/* RGB 565 Display ready Data */
+#define SENSOR_SMIA_MODE_RGB_565              0x00000100
+
+/* RGB 444 Display ready Data */
+#define SENSOR_SMIA_MODE_RGB_444              0x00000200
+
+/* YUV420 Data */
+#define SENSOR_SMIA_MODE_YUV_420              0x00000400
+
+/* YUV422 Data */
+#define SENSOR_SMIA_MODE_YUV_422              0x00000800
+
+/* SMIA is disabled */
+#define SENSOR_SMIA_OFF                       0x80000000
+
+/* YUV 420  8-bit */
+#define SENSOR_MIPI_MODE_YUV420_8             0x00000001
+
+/* YUV 420 10-bit */
+#define SENSOR_MIPI_MODE_YUV420_10            0x00000002
+
+/* Legacy YUV 420 8-bit */
+#define SENSOR_MIPI_MODE_LEGACY_YUV420_8      0x00000004
+
+/* YUV 420 8-bit (CSPS) */
+#define SENSOR_MIPI_MODE_YUV420_CSPS_8        0x00000008
+
+/* YUV 420 10-bit (CSPS) */
+#define SENSOR_MIPI_MODE_YUV420_CSPS_10       0x00000010
+
+/* YUV 422 8-bit */
+#define SENSOR_MIPI_MODE_YUV422_8             0x00000020
+
+/* YUV 422 10-bit */
+#define SENSOR_MIPI_MODE_YUV422_10            0x00000040
+
+/* RGB 444 */
+#define SENSOR_MIPI_MODE_RGB444               0x00000080
+
+/* RGB 555 */
+#define SENSOR_MIPI_MODE_RGB555               0x00000100
+
+/* RGB 565 */
+#define SENSOR_MIPI_MODE_RGB565               0x00000200
+
+/* RGB 666 */
+#define SENSOR_MIPI_MODE_RGB666               0x00000400
+
+/* RGB 888 */
+#define SENSOR_MIPI_MODE_RGB888               0x00000800
+
+/* RAW_6 */
+#define SENSOR_MIPI_MODE_RAW_6                0x00001000
+
+/* RAW_7 */
+#define SENSOR_MIPI_MODE_RAW_7                0x00002000
+
+/* RAW_8 */
+#define SENSOR_MIPI_MODE_RAW_8                0x00004000
+
+/* RAW_10 */
+#define SENSOR_MIPI_MODE_RAW_10               0x00008000
+
+/* RAW_12 */
+#define SENSOR_MIPI_MODE_RAW_12               0x00010000
+
+/* MIPI is disabled */
+#define SENSOR_MIPI_OFF                       0x80000000
+
+#define SENSOR_FIELDINV_NOSWAP     0x00000001
+#define SENSOR_FIELDINV_SWAP       0x00000002
+#define SENSOR_FIELDSEL_BOTH       0x00000001
+#define SENSOR_FIELDSEL_EVEN       0x00000002
+#define SENSOR_FIELDSEL_ODD        0x00000004
+
+#define SENSOR_YCSEQ_YCBYCR        0x00000001
+#define SENSOR_YCSEQ_YCRYCB        0x00000002
+#define SENSOR_YCSEQ_CBYCRY        0x00000004
+#define SENSOR_YCSEQ_CRYCBY        0x00000008
+
+#define SENSOR_CONV422_COSITED     0x00000001
+#define SENSOR_CONV422_INTER       0x00000002
+#define SENSOR_CONV422_NOCOSITED   0x00000004
+
+#define SENSOR_BPAT_RGRGGBGB       0x00000001
+#define SENSOR_BPAT_GRGRBGBG       0x00000002
+#define SENSOR_BPAT_GBGBRGRG       0x00000004
+#define SENSOR_BPAT_BGBGGRGR       0x00000008
+
+/* sync signal pulses high between lines */
+#define SENSOR_HPOL_SYNCPOS        0x00000001
+
+/* sync signal pulses low between lines */
+#define SENSOR_HPOL_SYNCNEG        0x00000002
+
+/* reference signal is high as long as sensor puts out line data */
+#define SENSOR_HPOL_REFPOS         0x00000004
+
+/* reference signal is low as long as sensor puts out line data */
+#define SENSOR_HPOL_REFNEG         0x00000008
+
+#define SENSOR_VPOL_POS            0x00000001
+#define SENSOR_VPOL_NEG            0x00000002
+
+#define SENSOR_EDGE_RISING         0x00000001
+#define SENSOR_EDGE_FALLING        0x00000002
+
+/* turns on/off color conversion matrix in the sensor ISP */
+#define SENSOR_CCONV_ON            0x00000001
+#define SENSOR_CCONV_OFF           0x00000002
+
+#define SENSOR_DWNSZ_SUBSMPL       0x00000001
+#define SENSOR_DWNSZ_SCAL_BAY      0x00000002
+#define SENSOR_DWNSZ_SCAL_COS      0x00000004
+
+#define ISI_AEC_MODE_STAND      0x00000001
+#define ISI_AEC_MODE_SLOW       0x00000002
+#define ISI_AEC_MODE_FAST       0x00000004
+#define ISI_AEC_MODE_NORMAL     0x00000008
+#define SENSOR_CIEPROF_A           0x00000001
+#define SENSOR_CIEPROF_B           0x00000002
+#define SENSOR_CIEPROF_C           0x00000004
+#define SENSOR_CIEPROF_D50         0x00000008
+#define SENSOR_CIEPROF_D55         0x00000010
+#define SENSOR_CIEPROF_D65         0x00000020
+#define SENSOR_CIEPROF_D75         0x00000040
+#define SENSOR_CIEPROF_E           0x00000080
+#define SENSOR_CIEPROF_FLUOR       0x00000100
+#define SENSOR_CIEPROF_FLUORH      0x00000200
+#define SENSOR_CIEPROF_TUNG        0x00000400
+#define SENSOR_CIEPROF_TWI         0x00000800
+#define SENSOR_CIEPROF_SUN         0x00001000
+#define SENSOR_CIEPROF_FLASH       0x00002000
+#define SENSOR_CIEPROF_SHADE       0x00004000
+#define SENSOR_CIEPROF_DAY         0x00008000
+#define SENSOR_CIEPROF_F1          0x00010000
+#define SENSOR_CIEPROF_F2          0x00020000
+#define SENSOR_CIEPROF_F3          0x00040000
+#define SENSOR_CIEPROF_F4          0x00080000
+#define SENSOR_CIEPROF_F5          0x00100000
+#define SENSOR_CIEPROF_F6          0x00200000
+#define SENSOR_CIEPROF_F7          0x00400000
+#define SENSOR_CIEPROF_F8          0x00800000
+#define SENSOR_CIEPROF_F9          0x01000000
+#define SENSOR_CIEPROF_F10         0x02000000
+#define SENSOR_CIEPROF_F11         0x04000000
+#define SENSOR_CIEPROF_F12         0x08000000
+#define SENSOR_CIEPROF_CLOUDY      0x10000000
+#define SENSOR_CIEPROF_SUNNY       0x20000000
+#define SENSOR_CIEPROF_OLDISS      0x80000000
+#define SENSOR_CIEPROF_DEFAULT     0x00000000
+
+/* no compensation for flickering environmental illumination */
+#define SENSOR_FLICKER_OFF         0x00000001
+
+/* compensation for 100Hz flicker frequency (at 50Hz mains frequency) */
+#define SENSOR_FLICKER_100         0x00000002
+
+/* compensation for 120Hz flicker frequency (at 60Hz mains frequency) */
+#define SENSOR_FLICKER_120         0x00000004
+
+#define SENSOR_CAP_BUSWIDTH         0
+#define SENSOR_CAP_MODE             1
+#define SENSOR_CAP_FIELDINV         2
+#define SENSOR_CAP_FIELDSEL         3
+#define SENSOR_CAP_YCSEQ            4
+#define SENSOR_CAP_CONV422          5
+#define SENSOR_CAP_BPAT             6
+#define SENSOR_CAP_HPOL             7
+#define SENSOR_CAP_VPOL             8
+#define SENSOR_CAP_EDGE             9
+#define SENSOR_CAP_BLS             10
+#define SENSOR_CAP_GAMMA           11
+#define SENSOR_CAP_CCONF           12
+#define SENSOR_CAP_RES             13
+#define SENSOR_CAP_DWNSZ           14
+#define SENSOR_CAP_BLC             15
+#define SENSOR_CAP_AGC             16
+#define SENSOR_CAP_AWB             17
+#define SENSOR_CAP_AEC             18
+#define SENSOR_CAP_CIEPROFILE      19
+#define SENSOR_CAP_FLICKERFREQ     20
+#define SENSOR_CAP_SMIAMODE        21
+#define SENSOR_CAP_MIPIMODE        22
+#define SENSOR_CAP_AECMODE         23
+
+/* size of capabilities array (in number of unsigned int fields) */
+#define SENSOR_CAP_COUNT           24
+
+/*
+ * Sensor configuration struct: same layout as the capabilities struct, but to
+ * configure the sensor all struct members which are supported by the sensor
+ * must have only 1 bit set. Members which are not supported by the sensor
+ * must not have any bits set.
+ */
+#define ci_sensor_config       ci_sensor_caps
+
+/* exposure time */
+#define SENSOR_PARM_EXPOSURE      0
+
+/* index in the AE control table */
+#define SENSOR_PARM_EXPTBL_INDEX  1
+
+/* overall gain (all components) */
+#define SENSOR_PARM_GAIN          2
+
+/* component gain of the red pixels */
+#define SENSOR_PARM_CGAIN_R       3
+
+/* component gain of the green pixels */
+#define SENSOR_PARM_CGAIN_G       4
+
+/* component gain of the blue pixels */
+#define SENSOR_PARM_CGAIN_B       5
+#define SENSOR_PARM_CGAINB_GR     6
+#define SENSOR_PARM_CGAINB_GB     7
+
+/* black-level adjustment (all components) */
+#define SENSOR_PARM_BLKL          8
+
+/* component black-level of the red pixels */
+#define SENSOR_PARM_CBLKL_R       9
+
+/* component black-level of the green pixels */
+#define SENSOR_PARM_CBLKL_G      10
+
+/* component black-level of the blue pixels */
+#define SENSOR_PARM_CBLKL_B      11
+
+#define SENSOR_PARM_CBLKLB_GR    12
+#define SENSOR_PARM_CBLKLB_GB    13
+
+#define SENSOR_PARM_BASERES_X    14
+#define SENSOR_PARM_BASERES_Y    15
+#define SENSOR_PARM_WINDOW_X     16
+#define SENSOR_PARM_WINDOW_Y     17
+#define SENSOR_PARM_WINDOW_W     18
+#define SENSOR_PARM_WINDOW_H     19
+
+#define SENSOR_PARM_FRAMERATE_FPS    20
+#define SENSOR_PARM_FRAMERATE_PITCH  21
+#define SENSOR_PARM_CLK_DIVIDER      22
+
+/* input clock in Hz. */
+#define SENSOR_PARM_CLK_INPUT        23
+#define SENSOR_PARM_CLK_PIXEL        24
+
+/* number of parameter IDs */
+#define SENSOR_PARM_COUNT       25
+
+/* parameter can be retrieved from the sensor */
+#define SENSOR_PARMINFO_GET       0x00000001
+
+/* parameter can be set into the sensor */
+#define SENSOR_PARMINFO_SET       0x00000002
+
+/* parameter can change at any time during operation */
+#define SENSOR_PARMINFO_VOLATILE  0x00000004
+
+/* range information available for the parameter in question */
+#define SENSOR_PARMINFO_RANGE     0x00000008
+
+/* range of possible values is not continous. */
+#define SENSOR_PARMINFO_DISCRETE  0x00000010
+
+/* parameter may change after a configuration update. */
+#define SENSOR_PARMINFO_CONFIG    0x00000020
+
+/* range information may change after a configuration update. */
+#define SENSOR_PARMINFO_RCONFIG   0x00000040
+
+/* multi-camera support */
+#define SENSOR_UNKNOWN_SENSOR_ID       (0)
+
+/*
+ * Input gamma correction curve for R, G or B of the sensor.  Since this gamma
+ * curve is sensor specific, it will be deliveres by the sensors specific code.
+ * This curve will be programmed into Marvin registers.
+ */
+#define SENSOR_GAMMA_CURVE_ARR_SIZE (17)
+
+struct ci_sensor_gamma_curve{
+       unsigned short isp_gamma_y[SENSOR_GAMMA_CURVE_ARR_SIZE];
+       unsigned int gamma_dx0;
+       unsigned int gamma_dx1;
+};
+
+/*
+ * SENSOR fixed point constant values They are represented as signed fixed point
+ * numbers with 12 bit integer and 20 bit fractional part, thus ranging from
+ * -2048.0000000 (0x80000000) to +2047.9999990 (0x7FFFFFFF).  In the following
+ *  some frequently used constant values are defined.
+ */
+
+/* -0.794944 */
+#define SENSOR_FP_M0000_794944     (0xFFF347E9)
+
+/* -0.500000 */
+#define SENSOR_FP_M0000_500000     (0xFFF80000)
+
+/* -0.404473 */
+#define SENSOR_FP_M0000_404473     (0xFFF98748)
+
+/* -0.062227 */
+#define SENSOR_FP_M0000_062227     (0xFFFF011F)
+
+/* -0.024891 */
+#define SENSOR_FP_M0000_024891     (0xFFFF9A0C)
+
+/* 0.000000 */
+#define SENSOR_FP_P0000_000000     (0x00000000)
+
+/* +0.500000 */
+#define SENSOR_FP_P0000_500000     (0x00080000)
+
+/* +1.000000 */
+#define SENSOR_FP_P0001_000000     (0x00100000)
+
+/* +1.163636 */
+#define SENSOR_FP_P0001_163636     (0x00129E40)
+
+/* +1.600778 */
+#define SENSOR_FP_P0001_600778     (0x00199CC9)
+
+/* +1.991249 */
+#define SENSOR_FP_P0001_991249     (0x001FDC27)
+
+/* +16.000000 */
+#define SENSOR_FP_P0016_000000     (0x01000000)
+
+/* +128.000000 */
+#define SENSOR_FP_P0128_000000     (0x08000000)
+
+/* +255.000000 */
+#define SENSOR_FP_P0255_000000     (0x0FF00000)
+
+/* +256.000000 */
+#define SENSOR_FP_P0256_000000     (0x10000000)
+
+/*
+ * Matrix coefficients used for CrossTalk and/or color conversion. The 9
+ * coefficients are laid out as follows (zero based index):
+ *    0 | 1 | 2
+ *    3 | 4 | 5
+ *    6 | 7 | 8
+ * They are represented as signed fixed point numbers with 12 bit integer and
+ * 20 bit fractional part, thus ranging from -2048.0000000 (0x80000000) to
+ * +2047.9999990 (0x7FFFFFFF).
+ */
+struct ci_sensor_3x3_matrix{
+       int coeff[9];
+};
+
+/*
+ * Matrix coefficients used for CrossTalk and/or color conversion. The 9
+ * coefficients are laid out as follows (zero based index):
+ *    0 | 1 | 2
+ *    3 | 4 | 5
+ *    6 | 7 | 8
+ * They are represented as float numbers
+ */
+struct ci_sensor_3x3_float_matrix{
+       float coeff[9];
+};
+
+struct ci_sensor_3x1_float_matrix{
+       float coeff[3];
+};
+
+struct ci_sensor_4x1_float_matrix{
+       float coeff[4];
+};
+
+struct ci_sensor_3x2_float_matrix{
+       float coeff[6];
+};
+
+struct ci_sensor_2x1_float_matrix{
+       float coeff[2];
+};
+
+struct ci_sensor_2x2_float_matrix{
+       float coeff[4];
+};
+
+struct ci_sensor_1x1_float_matrix{
+       float coeff[1];
+};
+
+struct ci_sensor_gauss_factor{
+       float gauss_factor;
+};
+
+struct isp_pca_values{
+       float pcac1;
+       float pcac2;
+};
+
+/*
+ * CrossTalk offset. In addition to the matrix multiplication an offset can be
+ * added to the pixel values for R, G and B separately. This offset is applied
+ * after the matrix multiplication. The values are arranged as unified, see
+ * above.
+ */
+struct ci_sensor_xtalk_offset{
+       int ct_offset_red;
+       int ct_offset_green;
+       int ct_offset_blue;
+};
+
+struct ci_sensor_xtalk_float_offset{
+       float ct_offset_red;
+       float ct_offset_green;
+       float ct_offset_blue;
+};
+
+/*
+ * white balancing gains There are two green gains: One for the green Bayer
+ * patterns in the red and one for the blue line. In the case the used MARVIN
+ * derivative is not able to apply separate green gains the mean value of both
+ * greens will be used for the green gain.  The component gains are represented
+ * as signed fixed point numbers with 12 bit integer and 20 bit fractional
+ * part, thus ranging from -2048.0000000 (0x80000000) to +2047.9999990
+ * (0x7FFFFFFF).  Example: +1.0 is represented by 0x00100000.
+ */
+struct ci_sensor_component_gain{
+       float red;
+       float green_r;
+       float green_b;
+       float blue;
+};
+
+/*
+ * white balance values, default is 0x80 for all components.  The struct can be
+ * used to provide linear scaling factors to achive a suitable white balance
+ * for certain lightning conditions.
+ */
+struct ci_sensor_comp_gain{
+       float red;
+       float green;
+       float blue;
+};
+
+/*
+ * cross-talk matrix dependent minimum / maximum red and blue gains
+ */
+struct ci_sensor_component_gain_limits{
+       unsigned short red_lower_limit;
+       unsigned short red_upper_limit;
+       unsigned short blue_lower_limit;
+       unsigned short blue_upper_limit;
+       unsigned int next_cie_higher_temp;
+       unsigned int next_cie_lower_temp;
+};
+
+/*
+* sensor characteristic struct. Is filled in by sensor specific code after
+* main configuration. Features not supported by the sensor driver code
+* will be initialized with default values (1x linear gamma, standard
+* color conversion, cross talk and component gain settings).
+*/
+struct ci_sensor_awb_profile{
+       /* input gammaR */
+       const struct ci_sensor_gamma_curve *gamma_curve_r;
+       /* input gammaG */
+       const struct ci_sensor_gamma_curve *gamma_curve_g;
+       /* input gammaB */
+       const struct ci_sensor_gamma_curve *gamma_curve_b;
+       /* ColorConversion  matrix coefficients */
+       const struct ci_sensor_3x3_float_matrix *color_conv_coeff;
+       /* CrossTalk matrix coefficients */
+       const struct ci_sensor_3x3_float_matrix *cross_talk_coeff;
+       /* CrossTalk offsets */
+       const struct ci_sensor_xtalk_float_offset *cross_talk_offset;
+       const struct ci_sensor_3x1_float_matrix *svd_mean_value;
+       const struct ci_sensor_3x2_float_matrix *pca_matrix;
+       const struct ci_sensor_2x1_float_matrix *gauss_mean_value;
+       const struct ci_sensor_2x2_float_matrix *covariance_matrix;
+       const struct ci_sensor_gauss_factor *gauss_factor;
+       const struct ci_sensor_2x1_float_matrix *threshold;
+       const struct ci_sensor_1x1_float_matrix *k_factor;
+       const struct ci_sensor_1x1_float_matrix *gexp_middle;
+       const struct ci_sensor_1x1_float_matrix *var_distr_in;
+       const struct ci_sensor_1x1_float_matrix *mean_distr_in;
+       const struct ci_sensor_1x1_float_matrix *var_distr_out;
+       const struct ci_sensor_1x1_float_matrix *mean_distr_out;
+       const struct ci_sensor_component_gain *component_gain;
+       const struct ci_sensor_loc_dist *loc_dist;
+
+};
+
+/*
+ *  General purpose window.  Normally it is used to describe a WOI (Window Of
+ *  Interest) inside the background area (e.g. image data area). The offset
+ *  values count from 0 of the background area. The defined point is the upper
+ *  left corner of the WOI with the specified width and height.
+ */
+struct ci_sensor_window{
+       unsigned short hoffs;
+       unsigned short voffs;
+       unsigned short hsize;
+       unsigned short vsize;
+};
+
+/*
+ *  Image data description.  The frame size describes the complete image data
+ *  area output of the sensor.  This includes dummy, black, dark, visible and
+ *  manufacturer specific pixels which could be combined in rows and / or in
+ *  columns.  The visible window describes the visible pixel area inside the
+ *  image data area. In the case the image data area does only contain visible
+ *  pixels, the offset values have to be 0 and the horizontal and vertical
+ *  sizes are equal to the frame size.
+ */
+struct ci_sensor_image_data_info{
+       unsigned short frame_h_size;
+       unsigned short frame_v_size;
+       struct ci_sensor_window visible_window;
+};
+
+/* black level compensation mean values */
+struct ci_sensor_blc_mean{
+       unsigned char mean_a;
+       unsigned char mean_b;
+       unsigned char mean_c;
+       unsigned char mean_d;
+};
+
+/* autowhitebalance mean values */
+struct ci_sensor_awb_mean{
+       unsigned int white;
+       unsigned char mean_y_g;
+       unsigned char mean_cb_b;
+       unsigned char mean_cr_r;
+};
+
+/* autowhitebalance mean values */
+struct ci_sensor_awb_float_mean{
+       unsigned int white;
+       float mean_y;
+       float mean_cb;
+       float mean_cr;
+};
+
+/* autoexposure mean values */
+struct ci_sensor_aec_mean{
+       unsigned char occ;
+       unsigned char mean;
+       unsigned char max;
+       unsigned char min;
+};
+
+/* bad pixel element attribute */
+enum ci_sensor_bp_corr_attr{
+       SENSOR_BP_HOT,
+       SENSOR_BP_DEAD
+};
+
+/* table element */
+struct ci_sensor_bp_table_elem{
+       unsigned short bp_ver_addr;
+       unsigned short bp_hor_addr;
+       enum ci_sensor_bp_corr_attr bp_type;
+};
+
+/* Bad Pixel table */
+struct ci_sensor_bp_table{
+       unsigned int bp_number;
+       struct ci_sensor_bp_table_elem *bp_table_elem;
+       unsigned int bp_table_elem_num;
+};
+
+#define        SENSOR_CTRL_TYPE_INTEGER        1
+#define        SENSOR_CTRL_TYPE_BOOLEAN        2
+#define        SENSOR_CTRL_TYPE_MENU           3
+#define        SENSOR_CTRL_TYPE_BUTTON         4
+#define        SENSOR_CTRL_TYPE_INTEGER64      5
+#define        SENSOR_CTRL_TYPE_CTRL_CLASS     6
+
+#define SENSOR_CTRL_CLASS_USER 0x00980000
+#define SENSOR_CID_BASE                        (SENSOR_CTRL_CLASS_USER | 0x900)
+#define SENSOR_CID_USER_BASE           SENSOR_CID_BASE
+
+/*  IDs reserved for driver specific controls */
+#define SENSOR_CID_PRIVATE_BASE                0x08000000
+
+#define SENSOR_CID_USER_CLASS          (SENSOR_CTRL_CLASS_USER | 1)
+#define SENSOR_CID_BRIGHTNESS          (SENSOR_CID_BASE+0)
+#define SENSOR_CID_CONTRAST            (SENSOR_CID_BASE+1)
+#define SENSOR_CID_SATURATION          (SENSOR_CID_BASE+2)
+#define SENSOR_CID_HUE                 (SENSOR_CID_BASE+3)
+#define SENSOR_CID_AUDIO_VOLUME                (SENSOR_CID_BASE+5)
+#define SENSOR_CID_AUDIO_BALANCE       (SENSOR_CID_BASE+6)
+#define SENSOR_CID_AUDIO_BASS          (SENSOR_CID_BASE+7)
+#define SENSOR_CID_AUDIO_TREBLE                (SENSOR_CID_BASE+8)
+#define SENSOR_CID_AUDIO_MUTE          (SENSOR_CID_BASE+9)
+#define SENSOR_CID_AUDIO_LOUDNESS      (SENSOR_CID_BASE+10)
+#define SENSOR_CID_BLACK_LEVEL         (SENSOR_CID_BASE+11)
+#define SENSOR_CID_AUTO_WHITE_BALANCE  (SENSOR_CID_BASE+12)
+#define SENSOR_CID_DO_WHITE_BALANCE    (SENSOR_CID_BASE+13)
+#define SENSOR_CID_RED_BALANCE         (SENSOR_CID_BASE+14)
+#define SENSOR_CID_BLUE_BALANCE                (SENSOR_CID_BASE+15)
+#define SENSOR_CID_GAMMA               (SENSOR_CID_BASE+16)
+#define SENSOR_CID_WHITENESS           (SENSOR_CID_GAMMA)
+#define SENSOR_CID_EXPOSURE            (SENSOR_CID_BASE+17)
+#define SENSOR_CID_AUTOGAIN            (SENSOR_CID_BASE+18)
+#define SENSOR_CID_GAIN                        (SENSOR_CID_BASE+19)
+#define SENSOR_CID_HFLIP               (SENSOR_CID_BASE+20)
+#define SENSOR_CID_VFLIP               (SENSOR_CID_BASE+21)
+#define SENSOR_CID_HCENTER             (SENSOR_CID_BASE+22)
+#define SENSOR_CID_VCENTER             (SENSOR_CID_BASE+23)
+#define SENSOR_CID_LASTP1              (SENSOR_CID_BASE+24)
+
+struct ci_sensor_parm{
+       unsigned int index;
+       int value;
+       int max;
+       int min;
+       int info;
+       int type;
+       char name[32];
+       int step;
+       int def_value;
+       int flags;
+};
+
+#define MRV_GRAD_TBL_SIZE      8
+#define MRV_DATA_TBL_SIZE      289
+
+struct ci_sensor_ls_corr_config{
+       unsigned short ls_rdata_tbl[MRV_DATA_TBL_SIZE];
+       unsigned short ls_gdata_tbl[MRV_DATA_TBL_SIZE];
+       unsigned short ls_bdata_tbl[MRV_DATA_TBL_SIZE];
+       unsigned short ls_xgrad_tbl[MRV_GRAD_TBL_SIZE];
+       unsigned short ls_ygrad_tbl[MRV_GRAD_TBL_SIZE];
+       unsigned short ls_xsize_tbl[MRV_GRAD_TBL_SIZE];
+       unsigned short ls_ysize_tbl[MRV_GRAD_TBL_SIZE];
+};
+
+struct ci_sensor_reg{
+       unsigned int addr;
+       unsigned int value;
+};
+
+struct ci_sensor_loc_dist{
+       float pca1_low_temp;
+       float pca1_high_temp;
+       float locus_distance;
+       float a2;
+       float a1;
+       float a0;
+};
+
+#endif
diff --git a/drivers/media/video/mrstisp/include/mrstisp.h b/drivers/media/video/mrstisp/include/mrstisp.h
new file mode 100644
index 0000000..023a608
--- /dev/null
+++ b/drivers/media/video/mrstisp/include/mrstisp.h
@@ -0,0 +1,248 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#ifndef _MRSTISP_H
+#define _MRSTISP_H
+
+#define INTEL_MAJ_VER   0
+#define INTEL_MIN_VER   5
+#define INTEL_PATCH_VER  0
+#define DRIVER_NAME "lnw isp"
+#define VID_HARDWARE_INTEL     100
+
+#define INTEL_VERSION(a, b, c) (((a) << 16) + ((b) << 8) + (c))
+
+#define MRST_ISP_REG_MEMORY_MAP 0xFF0E0000
+
+#define INTEL_MIN_WIDTH  32
+#define INTEL_MIN_HEIGHT 16
+
+/* self path maximum width/height, VGA */
+#define INTEL_MAX_WIDTH  640
+#define INTEL_MAX_HEIGHT 480
+
+/* main path maximum widh/height, 5M */
+#define INTEL_MAX_WIDTH_MP 2600
+#define INTEL_MAX_HEIGHT_MP 2048
+
+/* image size returned by the driver */
+#define INTEL_IMAGE_WIDTH  640
+#define INTEL_IMAGE_HEIGHT 480
+
+/* Default capture queue buffers. */
+#define INTEL_CAPTURE_BUFFERS 3
+
+/* Default capture buffer size.  */
+#define INTEL_CAPTURE_BUFSIZE PAGE_ALIGN(INTEL_MAX_WIDTH * INTEL_MAX_HEIGHT * 2)
+#define INTEL_IMAGE_BUFSIEZE (INTEL_IMAGE_WIDTH * INTEL_IMAGE_HEIGHT * 2)
+
+#define MAX_KMALLOC_MEM (4*1024*1024)
+
+#define MEM_SNAPSHOT_MAX_SIZE (1*1024*1024)
+
+#include <media/v4l2-device.h>
+
+enum frame_state {
+       S_UNUSED = 0,   /* unused */
+       S_QUEUED,       /* ready to capture */
+       S_GRABBING,     /* in the process of being captured */
+       S_DONE,         /* finished grabbing, but not been synced yet */
+       S_ERROR,        /* something bad happened while capturing */
+};
+
+struct frame_info {
+       enum frame_state state;
+       u32 flags;
+};
+
+struct fifo {
+       int front;
+       int back;
+       int data[INTEL_CAPTURE_BUFFERS + 1];
+       struct frame_info info[INTEL_CAPTURE_BUFFERS + 1];
+};
+
+enum mrst_isp_state {
+       S_NOTREADY,     /* Not yet initialized */
+       S_IDLE,         /* Just hanging around */
+       S_FLAKED,       /* Some sort of problem */
+       S_STREAMING     /* Streaming data */
+};
+
+struct mrst_isp_buffer {
+       struct videobuf_buffer vb;
+       int fmt_useless;
+};
+
+struct mrst_isp_device {
+       struct v4l2_device v4l2_dev;
+       /* v4l2 device handler */
+       struct video_device *vdev;
+
+       /* locks this structure */
+       struct mutex mutex;
+
+       /* if the port is open or not */
+       int open;
+
+       /* pci information */
+       struct pci_dev *pci_dev;
+       unsigned long mb0;
+       unsigned long mb0_size;
+       unsigned char *regs;
+       unsigned long mb1;
+       unsigned long mb1_size;
+       unsigned char *mb1_va;
+       unsigned short vendorID;
+       unsigned short deviceID;
+       unsigned char revision;
+
+       /* subdev */
+       struct v4l2_subdev *sensor_soc;
+       int sensor_soc_index;
+       struct v4l2_subdev *sensor_raw;
+       int sensor_raw_index;
+       struct v4l2_subdev *sensor_curr;
+       struct v4l2_subdev *motor;
+       struct v4l2_subdev *flash;
+       struct i2c_adapter *adapter_sensor;
+       struct i2c_adapter *adapter_flash;
+
+       int streaming;
+       int buffer_required;
+
+       /* interrupt */
+       unsigned char int_enable;
+       unsigned long int_flag;
+       unsigned long interrupt_count;
+
+       /* allocated memory for km_mmap */
+       char *fbuffer;
+
+       /* virtual address of cap buf */
+       char *capbuf;
+
+       /* physcial address of cap buf */
+       u32 capbuf_pa;
+
+       struct fifo frame_queue;
+
+       /* current capture frame number */
+       int cap_frame;
+
+       /* total frames */
+       int num_frames;
+
+       u32 field_count;
+       u32 pixelformat;
+       u16 depth;
+       u32 bufwidth;
+       u32 bufheight;
+       u32 frame_size;
+       u32 frame_size_used;
+
+       enum mrst_isp_state state;
+
+       /* active mappings*/
+       int vmas;
+
+       /* isp system configuration */
+       struct ci_pl_system_config sys_conf;
+
+       struct completion jpe_complete;
+       struct completion mi_complete;
+       int irq_stat;
+
+       spinlock_t lock;
+       spinlock_t qlock;
+       struct videobuf_buffer *active;
+       struct videobuf_buffer *next;
+       struct list_head capture;
+       u32 streambufs;
+       u32 stopbuf;
+       u32 stopflag;
+};
+
+struct mrst_isp_fh {
+       struct mrst_isp_device *dev;
+       struct videobuf_queue vb_q;
+       u32 qbuf_flag;
+};
+
+/* viewfinder mode mask */
+#define VFFLAG_MODE_MASK           0x0000000F
+#define VFFLAG_MODE_FULLLCD_DSONLY  0x00000000
+#define VFFLAG_MODE_FULLLCD_USDS    0x00000001
+#define VFFLAG_MODE_LETTERBOX       0x00000002
+#define VFFLAG_MODE_USER            0x00000003
+#define VFFLAG_HWRGB                0x00000010
+#define VFFLAG_MIRROR               0x00000020
+#define VFFLAG_USE_MAINPATH         0x00000040
+#define VFFLAG_V_FLIP               0x00000100
+#define VFFLAG_ROT90_CCW            0x00000200
+
+/* abbreviations for local debug control ( level | module ) */
+#define DERR  (DBG_ERR  | DBG_MRV)
+#define DWARN (DBG_WARN | DBG_MRV)
+#define DINFO (DBG_INFO | DBG_MRV)
+
+struct ci_isp_rect {
+       int x;
+       int y;
+       int w;
+       int h;
+};
+
+/* the address/size of one region */
+struct ci_frame_region {
+       unsigned char *phy_addr;
+       unsigned int size;
+};
+
+struct ci_frame_addr {
+       int num_of_regs;
+       struct ci_frame_region *regs;
+};
+
+/* type in mrst_camer*/
+#define MRST_CAMERA_NONE       -1
+#define MRST_CAMERA_SOC        0
+#define MRST_CAMERA_RAW        1
+
+struct mrst_camera {
+       int type;
+       char *name;
+       u8 sensor_addr;
+       char *motor_name;
+       u8 motor_addr;
+};
+
+#define MRST_I2C_BUS_FLASH 0
+#define MRST_I2C_BUS_SENSOR 1
+
+long mrst_isp_vidioc_default(struct file *file, void *fh,
+                            int cmd, void *arg);
+void mrst_timer_start(void);
+void mrst_timer_stop(void);
+unsigned long mrst_get_micro_sec(void);
+#endif
diff --git a/drivers/media/video/mrstisp/include/mrstisp_stdinc.h b/drivers/media/video/mrstisp/include/mrstisp_stdinc.h
new file mode 100644
index 0000000..91ec062
--- /dev/null
+++ b/drivers/media/video/mrstisp/include/mrstisp_stdinc.h
@@ -0,0 +1,146 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * Copyright (c) Silicon Image 2008  www.siliconimage.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#ifndef _MRSTISP_STDINC_H
+#define _MRSTISP_STDINC_H
+
+#ifdef __KERNEL__
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+
+#include <linux/proc_fs.h>
+#include <linux/ctype.h>
+#include <linux/pagemap.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+
+#include <linux/uaccess.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
+
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
+#include <asm/kmap_types.h>
+#include <linux/delay.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <linux/timer.h>
+#include <asm/system.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <linux/time.h>
+#include <linux/syscalls.h>
+
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/dma-mapping.h>
+#include <media/videobuf-core.h>
+#include <media/videobuf-dma-contig.h>
+
+#ifdef CONFIG_KMOD
+#include <linux/kmod.h>
+#endif
+
+#include <linux/stddef.h>
+#include <linux/kernel.h>
+#include <linux/stringify.h>
+
+#include "ci_sensor_common.h"
+#include "ci_isp_common.h"
+#include "ci_va.h"
+#include "v4l2_jpg_review.h"
+
+#include "mrstisp_reg.h"
+#include "mrstisp.h"
+#include "mrstisp_isp.h"
+#include "mrstisp_hw.h"
+#include "mrstisp_jpe.h"
+#include "mrstisp_dp.h"
+#include "mrstisp_snr_conf.h"
+
+/* all bits to '1' but prevent "shift overflow" warning */
+#ifndef ON
+#define ON   -1
+#endif
+
+#ifndef OFF
+#define OFF  0
+#endif
+
+/* all bits to '1' but prevent "shift overflow" warning */
+#ifndef ENABLE
+#define ENABLE   -1
+#endif
+
+#ifndef DISABLE
+#define DISABLE  0
+#endif
+
+#define crop_flag 0
+#define CI_STATUS_SUCCESS         0
+#define CI_STATUS_FAILURE         1
+#define CI_STATUS_NOTSUPP         2
+#define CI_STATUS_BUSY            3
+#define CI_STATUS_CANCELED        4
+#define CI_STATUS_OUTOFMEM        5
+#define CI_STATUS_OUTOFRANGE      6
+#define CI_STATUS_IDLE            7
+#define CI_STATUS_WRONG_HANDLE    8
+#define CI_STATUS_NULL_POINTER    9
+#define CI_STATUS_NOTAVAILABLE    10
+
+extern unsigned char *mrst_isp_regs;
+#define MEM_CSC_REG_BASE                (0x08500000)
+#define MEM_MRV_REG_BASE (mrst_isp_regs)
+#define ALIGN_TO_4(f)  (((f) + 3) & ~3)
+
+/* for debug */
+extern int mrstisp_debug;
+#define dprintk(level, fmt, arg...) do {                       \
+       if (mrstisp_debug >= level)                                     \
+               printk(KERN_DEBUG "mrstisp@%s: " fmt "\n", \
+                      __func__, ## arg); } \
+       while (0)
+
+#define eprintk(fmt, arg...)   \
+       printk(KERN_ERR "mrstisp@%s" fmt "\n",  \
+              __func__, ## arg);
+
+#include "reg_access.h"
+
+#endif
+#endif
--
1.6.3.2

