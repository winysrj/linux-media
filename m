Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53474 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab0C1HrO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Mar 2010 03:47:14 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Zhu, Daniel" <daniel.zhu@intel.com>,
	"Yu, Jinlu" <jinlu.yu@intel.com>,
	"Wang, Wen W" <wen.w.wang@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Hu, Gang A" <gang.a.hu@intel.com>,
	"Ba, Zheng" <zheng.ba@intel.com>,
	"Zhang, Xiaolin" <xiaolin.zhang@intel.com>
Date: Sun, 28 Mar 2010 15:46:52 +0800
Subject: [PATCH v2 1/10] V4L2 patches for Intel Moorestown Camera Imaging
 Drivers
Message-ID: <33AB447FBD802F4E932063B962385B351D6D534B@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 7e2f1f0d8dff9051d234a69d73655c730ad1c16c Mon Sep 17 00:00:00 2001
From: Xiaolin Zhang <xiaolin.zhang@intel.com>
Date: Sun, 28 Mar 2010 13:44:05 +0800
Subject: [PATCH 01/10] This patch is first part of the intel moorestown isp driver and header files collection
 including register spec, frame formats, etc.

Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
---
 drivers/media/video/mrstci/include/ci_isp_common.h |  937 ++++
 .../video/mrstci/include/ci_isp_fmts_common.h      |  124 +
 .../media/video/mrstci/include/ci_sensor_common.h  | 1157 +++++
 drivers/media/video/mrstci/include/ci_va.h         |   46 +
 .../media/video/mrstci/include/v4l2_jpg_review.h   |   47 +
 drivers/media/video/mrstci/mrstisp/include/def.h   |  111 +
 .../media/video/mrstci/mrstisp/include/mrstisp.h   |  245 ++
 .../video/mrstci/mrstisp/include/mrstisp_dp.h      |  257 ++
 .../video/mrstci/mrstisp/include/mrstisp_hw.h      |  176 +
 .../video/mrstci/mrstisp/include/mrstisp_isp.h     |   42 +
 .../video/mrstci/mrstisp/include/mrstisp_jpe.h     |  416 ++
 .../video/mrstci/mrstisp/include/mrstisp_reg.h     | 4499 ++++++++++++++++++++
 .../video/mrstci/mrstisp/include/mrstisp_stdinc.h  |  115 +
 .../video/mrstci/mrstisp/include/reg_access.h      |  119 +
 14 files changed, 8291 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/mrstci/include/ci_isp_common.h
 create mode 100644 drivers/media/video/mrstci/include/ci_isp_fmts_common.h
 create mode 100644 drivers/media/video/mrstci/include/ci_sensor_common.h
 create mode 100644 drivers/media/video/mrstci/include/ci_va.h
 create mode 100644 drivers/media/video/mrstci/include/v4l2_jpg_review.h
 create mode 100644 drivers/media/video/mrstci/mrstisp/include/def.h
 create mode 100644 drivers/media/video/mrstci/mrstisp/include/mrstisp.h
 create mode 100644 drivers/media/video/mrstci/mrstisp/include/mrstisp_dp.h
 create mode 100644 drivers/media/video/mrstci/mrstisp/include/mrstisp_hw.h
 create mode 100644 drivers/media/video/mrstci/mrstisp/include/mrstisp_isp.h
 create mode 100644 drivers/media/video/mrstci/mrstisp/include/mrstisp_jpe.h
 create mode 100644 drivers/media/video/mrstci/mrstisp/include/mrstisp_reg.h
 create mode 100644 drivers/media/video/mrstci/mrstisp/include/mrstisp_stdinc.h
 create mode 100644 drivers/media/video/mrstci/mrstisp/include/reg_access.h

diff --git a/drivers/media/video/mrstci/include/ci_isp_common.h b/drivers/media/video/mrstci/include/ci_isp_common.h
new file mode 100644
index 0000000..83b5624
--- /dev/null
+++ b/drivers/media/video/mrstci/include/ci_isp_common.h
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
+       CI_ISP_YCS_MVRaw,
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
diff --git a/drivers/media/video/mrstci/include/ci_isp_fmts_common.h b/drivers/media/video/mrstci/include/ci_isp_fmts_common.h
new file mode 100644
index 0000000..b01d38f
--- /dev/null
+++ b/drivers/media/video/mrstci/include/ci_isp_fmts_common.h
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
diff --git a/drivers/media/video/mrstci/include/ci_sensor_common.h b/drivers/media/video/mrstci/include/ci_sensor_common.h
new file mode 100644
index 0000000..8d8a40b
--- /dev/null
+++ b/drivers/media/video/mrstci/include/ci_sensor_common.h
@@ -0,0 +1,1157 @@
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
+#ifndef _SENSOR_COMMON_H
+#define _SENSOR_COMMON_H
+
+#include <media/v4l2-subdev.h>
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
+/*
+ * interface version
+ * please increment the version if you add something new to the interface.
+ * This helps upper layer software to deal with different interface versions.
+ */
+#define SENSOR_INTERFACE_VERSION 4
+#define SENSOR_TYPE_SOC        0
+#define SENSOR_TYPE_RAW        1
+#define SENSOR_TYPE_2M 0
+#define SENSOR_TYPE_5M 1
+
+/*
+ * capabilities / configuration
+ */
+
+/*
+ * to expand to a (possibly higher) resolution in marvin, the LSBs will be set
+ * to zero
+ */
+#define SENSOR_BUSWIDTH_8BIT_ZZ    0x00000001
+
+/*
+ * to expand to a (possibly higher) resolution in marvin, the LSBs will be
+ * copied from the MSBs
+ */
+#define SENSOR_BUSWIDTH_8BIT_EX    0x00000002
+
+/*
+ * formerly known as SENSOR_BUSWIDTH_10BIT (at times no marvin derivative was
+ * able to process more than 10 bit)
+ */
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
+/* turns on/off additional black lines at frame start */
+#define SENSOR_BLS_OFF             0x00000001
+#define SENSOR_BLS_TWO_LINES       0x00000002
+/* two lines top and two lines bottom */
+#define SENSOR_BLS_FOUR_LINES      0x00000004
+
+/* turns on/off gamma correction in the sensor ISP */
+#define SENSOR_GAMMA_ON            0x00000001
+#define SENSOR_GAMMA_OFF           0x00000002
+
+/* turns on/off color conversion matrix in the sensor ISP */
+#define SENSOR_CCONV_ON            0x00000001
+#define SENSOR_CCONV_OFF           0x00000002
+
+/* 88x72 */
+#define SENSOR_RES_QQCIF           0x00000001
+
+/* 160x120 */
+#define SENSOR_RES_QQVGA           0x00000002
+
+/* 176x144 */
+#define SENSOR_RES_QCIF            0x00000004
+
+/* 320x240 */
+#define SENSOR_RES_QVGA            0x00000008
+
+/* 352x288 */
+#define SENSOR_RES_CIF             0x00000010
+
+/* 640x480 */
+#define SENSOR_RES_VGA             0x00000020
+
+/* 800x600 */
+#define SENSOR_RES_SVGA            0x00000040
+
+/* 1024x768 */
+#define SENSOR_RES_XGA             0x00000080
+
+/* 1280x960 max. resolution of OV9640 (QuadVGA) */
+#define SENSOR_RES_XGA_PLUS        0x00000100
+
+/* 1280x1024 */
+#define SENSOR_RES_SXGA            0x00000200
+
+/* 1600x1200 */
+#define SENSOR_RES_UXGA            0x00000400
+
+/* 2048x1536 */
+#define SENSOR_RES_QXGA            0x00000800
+#define SENSOR_RES_QXGA_PLUS       0x00001000
+#define SENSOR_RES_RAWMAX          0x00002000
+
+/* 4080x1024 */
+#define SENSOR_RES_YUV_HMAX        0x00004000
+
+/* 1024x4080 */
+#define SENSOR_RES_YUV_VMAX        0x00008000
+
+/* 720x480 */
+#define SENSOR_RES_L_AFM           0x00020000
+
+/* 128x96 */
+#define SENSOR_RES_M_AFM           0x00040000
+
+/* 64x32 */
+#define SENSOR_RES_S_AFM           0x00080000
+
+/* 352x240 */
+#define SENSOR_RES_BP1             0x00100000
+
+/* 2586x2048, quadruple SXGA, 5,3 Mpix */
+#define SENSOR_RES_QSXGA           0x00200000
+
+/* 2600x2048, max. resolution of M5, 5,32 Mpix */
+#define SENSOR_RES_QSXGA_PLUS      0x00400000
+
+/* 2600x1950 */
+#define SENSOR_RES_QSXGA_PLUS2     0x00800000
+
+/* 2686x2048,  5.30M */
+#define SENSOR_RES_QSXGA_PLUS3     0x01000000
+
+/* 3200x2048,  6.56M */
+#define SENSOR_RES_WQSXGA          0x02000000
+
+/* 3200x2400,  7.68M */
+#define SENSOR_RES_QUXGA           0x04000000
+
+/* 3840x2400,  9.22M */
+#define SENSOR_RES_WQUXGA          0x08000000
+
+/* 4096x3072, 12.59M */
+#define SENSOR_RES_HXGA            0x10000000
+#define SENSOR_RES_1080P                  0x20000000
+
+/* 1280x720 */
+#define SENSOR_RES_720P        0x40000000
+
+/* FIXME 1304x980*/
+#define SENSOR_RES_VGA_PLUS    0x80000000
+#define VGA_PLUS_SIZE_H                (1304)
+#define VGA_PLUS_SIZE_V                (980)
+
+#define QSXGA_PLUS4_SIZE_H     (2592)
+#define QSXGA_PLUS4_SIZE_V     (1944)
+#define RES_1080P_SIZE_H       (1920)
+#define RES_1080P_SIZE_V       (1080)
+#define RES_720P_SIZE_H        (1280)
+#define RES_720P_SIZE_V        (720)
+#define QQCIF_SIZE_H              (88)
+#define QQCIF_SIZE_V              (72)
+#define QQVGA_SIZE_H             (160)
+#define QQVGA_SIZE_V             (120)
+#define QCIF_SIZE_H              (176)
+#define QCIF_SIZE_V              (144)
+#define QVGA_SIZE_H              (320)
+#define QVGA_SIZE_V              (240)
+#define CIF_SIZE_H               (352)
+#define CIF_SIZE_V               (288)
+#define VGA_SIZE_H               (640)
+#define VGA_SIZE_V               (480)
+#define SVGA_SIZE_H              (800)
+#define SVGA_SIZE_V              (600)
+#define XGA_SIZE_H              (1024)
+#define XGA_SIZE_V               (768)
+#define XGA_PLUS_SIZE_H         (1280)
+#define XGA_PLUS_SIZE_V          (960)
+#define SXGA_SIZE_H             (1280)
+#define SXGA_SIZE_V             (1024)
+#define QSVGA_SIZE_H            (1600)
+#define QSVGA_SIZE_V            (1200)
+#define UXGA_SIZE_H             (1600)
+#define UXGA_SIZE_V             (1200)
+#define QXGA_SIZE_H             (2048)
+#define QXGA_SIZE_V             (1536)
+#define QXGA_PLUS_SIZE_H        (2592)
+#define QXGA_PLUS_SIZE_V        (1944)
+#define RAWMAX_SIZE_H           (4096)
+#define RAWMAX_SIZE_V           (2048)
+#define YUV_HMAX_SIZE_H         (4080)
+#define YUV_HMAX_SIZE_V         (1024)
+#define YUV_VMAX_SIZE_H         (1024)
+#define YUV_VMAX_SIZE_V         (4080)
+#define BP1_SIZE_H               (352)
+#define BP1_SIZE_V               (240)
+#define L_AFM_SIZE_H             (720)
+#define L_AFM_SIZE_V             (480)
+#define M_AFM_SIZE_H             (128)
+#define M_AFM_SIZE_V              (96)
+#define S_AFM_SIZE_H              (64)
+#define S_AFM_SIZE_V              (32)
+#define QSXGA_SIZE_H            (2560)
+#define QSXGA_SIZE_V            (2048)
+#define QSXGA_MINUS_SIZE_V      (1920)
+#define QSXGA_PLUS_SIZE_H       (2600)
+#define QSXGA_PLUS_SIZE_V       (2048)
+#define QSXGA_PLUS2_SIZE_H      (2600)
+#define QSXGA_PLUS2_SIZE_V      (1950)
+#define QUXGA_SIZE_H            (3200)
+#define QUXGA_SIZE_V            (2400)
+#define SIZE_H_2500             (2500)
+#define QSXGA_PLUS3_SIZE_H      (2686)
+#define QSXGA_PLUS3_SIZE_V      (2048)
+#define QSXGA_PLUS4_SIZE_V      (1944)
+#define WQSXGA_SIZE_H           (3200)
+#define WQSXGA_SIZE_V           (2048)
+#define WQUXGA_SIZE_H           (3200)
+#define WQUXGA_SIZE_V           (2400)
+#define HXGA_SIZE_H             (4096)
+#define HXGA_SIZE_V             (3072)
+
+#define SENSOR_DWNSZ_SUBSMPL       0x00000001
+#define SENSOR_DWNSZ_SCAL_BAY      0x00000002
+#define SENSOR_DWNSZ_SCAL_COS      0x00000004
+
+#define SENSOR_BLC_AUTO            0x00000001
+#define SENSOR_BLC_OFF             0x00000002
+
+#define SENSOR_AGC_AUTO            0x00000001
+#define SENSOR_AGC_OFF             0x00000002
+
+#define SENSOR_AWB_AUTO            0x00000001
+#define SENSOR_AWB_OFF             0x00000002
+
+#define SENSOR_AEC_AUTO            0x00000001
+#define SENSOR_AEC_OFF             0x00000002
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
+/*
+ * sensor capabilities struct: a struct member may have 0, 1 or several bits
+ * set according to the capabilities of the sensor. All struct members must be
+ * unsigned int and no padding is allowed. Thus, access to the fields is also
+ * possible by means of a field of unsigned int values. Indicees for the
+ * field-like access are given below.
+ */
+struct ci_sensor_caps{
+       unsigned int bus_width;
+       unsigned int mode;
+       unsigned int field_inv;
+       unsigned int field_sel;
+       unsigned int ycseq;
+       unsigned int conv422;
+       unsigned int bpat;
+       unsigned int hpol;
+       unsigned int vpol;
+       unsigned int edge;
+       unsigned int bls;
+       unsigned int gamma;
+       unsigned int cconv;
+       unsigned int res;
+       unsigned int dwn_sz;
+       unsigned int blc;
+       unsigned int agc;
+       unsigned int awb;
+       unsigned int aec;
+       unsigned int cie_profile;
+       unsigned int flicker_freq;
+       unsigned int smia_mode;
+       unsigned int mipi_mode;
+       unsigned int type;
+       char name[32];
+
+       struct v4l2_subdev sd;
+};
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
+static inline int ci_sensor_res2size(unsigned int res, unsigned short *h_size,
+                      unsigned short *v_size)
+{
+       unsigned short hsize;
+       unsigned short vsize;
+       int err = 0;
+
+       switch (res) {
+       case SENSOR_RES_QQCIF:
+               hsize = QQCIF_SIZE_H;
+               vsize = QQCIF_SIZE_V;
+               break;
+       case SENSOR_RES_QQVGA:
+               hsize = QQVGA_SIZE_H;
+               vsize = QQVGA_SIZE_V;
+               break;
+       case SENSOR_RES_QCIF:
+               hsize = QCIF_SIZE_H;
+               vsize = QCIF_SIZE_V;
+               break;
+       case SENSOR_RES_QVGA:
+               hsize = QVGA_SIZE_H;
+               vsize = QVGA_SIZE_V;
+               break;
+       case SENSOR_RES_CIF:
+               hsize = CIF_SIZE_H;
+               vsize = CIF_SIZE_V;
+               break;
+       case SENSOR_RES_VGA:
+               hsize = VGA_SIZE_H;
+               vsize = VGA_SIZE_V;
+               break;
+       case SENSOR_RES_SVGA:
+               hsize = SVGA_SIZE_H;
+               vsize = SVGA_SIZE_V;
+               break;
+       case SENSOR_RES_XGA:
+               hsize = XGA_SIZE_H;
+               vsize = XGA_SIZE_V;
+               break;
+       case SENSOR_RES_XGA_PLUS:
+               hsize = XGA_PLUS_SIZE_H;
+               vsize = XGA_PLUS_SIZE_V;
+               break;
+       case SENSOR_RES_SXGA:
+               hsize = SXGA_SIZE_H;
+               vsize = SXGA_SIZE_V;
+               break;
+       case SENSOR_RES_UXGA:
+               hsize = UXGA_SIZE_H;
+               vsize = UXGA_SIZE_V;
+               break;
+       case SENSOR_RES_QXGA:
+               hsize = QXGA_SIZE_H;
+               vsize = QXGA_SIZE_V;
+               break;
+       case SENSOR_RES_QSXGA:
+               hsize = QSXGA_SIZE_H;
+               vsize = QSXGA_SIZE_V;
+               break;
+       case SENSOR_RES_QSXGA_PLUS:
+               hsize = QSXGA_PLUS_SIZE_H;
+               vsize = QSXGA_PLUS_SIZE_V;
+               break;
+       case SENSOR_RES_QSXGA_PLUS2:
+               hsize = QSXGA_PLUS2_SIZE_H;
+               vsize = QSXGA_PLUS2_SIZE_V;
+               break;
+       case SENSOR_RES_QSXGA_PLUS3:
+               hsize = QSXGA_PLUS3_SIZE_H;
+               vsize = QSXGA_PLUS3_SIZE_V;
+               break;
+       case SENSOR_RES_WQSXGA:
+               hsize = WQSXGA_SIZE_H;
+               vsize = WQSXGA_SIZE_V;
+               break;
+       case SENSOR_RES_QUXGA:
+               hsize = QUXGA_SIZE_H;
+               vsize = QUXGA_SIZE_V;
+               break;
+       case SENSOR_RES_WQUXGA:
+               hsize = WQUXGA_SIZE_H;
+               vsize = WQUXGA_SIZE_V;
+               break;
+       case SENSOR_RES_HXGA:
+               hsize = HXGA_SIZE_H;
+               vsize = HXGA_SIZE_V;
+               break;
+       case SENSOR_RES_RAWMAX:
+               hsize = RAWMAX_SIZE_H;
+               vsize = RAWMAX_SIZE_V;
+               break;
+       case SENSOR_RES_YUV_HMAX:
+               hsize = YUV_HMAX_SIZE_H;
+               vsize = YUV_HMAX_SIZE_V;
+               break;
+       case SENSOR_RES_YUV_VMAX:
+               hsize = YUV_VMAX_SIZE_H;
+               vsize = YUV_VMAX_SIZE_V;
+               break;
+       case SENSOR_RES_BP1:
+               hsize = BP1_SIZE_H;
+               vsize = BP1_SIZE_V;
+               break;
+       case SENSOR_RES_L_AFM:
+               hsize = L_AFM_SIZE_H;
+               vsize = L_AFM_SIZE_V;
+               break;
+       case SENSOR_RES_M_AFM:
+               hsize = M_AFM_SIZE_H;
+               vsize = M_AFM_SIZE_V;
+               break;
+       case SENSOR_RES_S_AFM:
+               hsize = S_AFM_SIZE_H;
+               vsize = S_AFM_SIZE_V;
+               break;
+
+       case SENSOR_RES_QXGA_PLUS:
+               hsize = QXGA_PLUS_SIZE_H;
+               vsize = QXGA_PLUS_SIZE_V;
+               break;
+
+       case SENSOR_RES_1080P:
+               hsize = RES_1080P_SIZE_H;
+               vsize = 1080;
+               break;
+
+       case SENSOR_RES_720P:
+               hsize = RES_720P_SIZE_H;
+               vsize = RES_720P_SIZE_V;
+               break;
+
+       case SENSOR_RES_VGA_PLUS:
+               hsize = VGA_PLUS_SIZE_H;
+               vsize = VGA_PLUS_SIZE_V;
+               break;
+
+       default:
+               hsize = 0;
+               vsize = 0;
+               err = -1;
+               printk(KERN_ERR "ci_sensor_res2size: Resolution 0x%08x"
+                      "unknown\n", res);
+               break;
+       }
+
+       if (h_size != NULL)
+               *h_size = hsize;
+       if (v_size != NULL)
+               *v_size = vsize;
+
+       return err;
+}
+#endif
diff --git a/drivers/media/video/mrstci/include/ci_va.h b/drivers/media/video/mrstci/include/ci_va.h
new file mode 100644
index 0000000..2b7f0a5
--- /dev/null
+++ b/drivers/media/video/mrstci/include/ci_va.h
@@ -0,0 +1,46 @@
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
+/*
+ * for buffer sharing between camera and video subsystem to improve preview
+ *  and video capture perofrmance
+ */
+
+#ifndef _CI_VA_H
+#define _CI_VA_H
+
+struct ci_frame_info {
+       unsigned long frame_id; /* in */
+       unsigned int width; /* out */
+       unsigned int height; /* out */
+       unsigned int stride; /* out */
+       unsigned int fourcc; /* out */
+       unsigned int offset; /* out */
+};
+
+#define ISP_IOCTL_GET_FRAME_INFO _IOWR('V', 192 + 5, struct ci_frame_info)
+
+#endif
+
diff --git a/drivers/media/video/mrstci/include/v4l2_jpg_review.h b/drivers/media/video/mrstci/include/v4l2_jpg_review.h
new file mode 100644
index 0000000..d574d83
--- /dev/null
+++ b/drivers/media/video/mrstci/include/v4l2_jpg_review.h
@@ -0,0 +1,47 @@
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
+#ifndef        __V4L2_JPG_REVIEW_EXT_H
+#define        __V4L2_JPG_REVIEW_EXT_H
+
+#include <linux/videodev2.h>
+
+/*
+ * Moorestown JPG image auto review structure and IOCTL.
+ */
+struct v4l2_jpg_review_buffer{
+       __u32   width;          /* in: frame width */
+       __u32   height;         /* in: frame height */
+       __u32   pix_fmt;        /* in: frame fourcc */
+       __u32   jpg_frame;      /* in: corresponding jpg frame id */
+       __u32   bytesperline;   /* out: 0 if not used */
+       __u32   frame_size;     /* out: frame size */
+       __u32   offset;         /* out: mmap offset */
+};
+
+#define        BASE_VIDIOC_PRIVATE_JPG_REVIEW  (BASE_VIDIOC_PRIVATE + 10)
+
+#define        VIDIOC_CREATE_JPG_REVIEW_BUF    _IOWR('V', \
+               BASE_VIDIOC_PRIVATE_JPG_REVIEW + 1, \
+               struct v4l2_jpg_review_buffer)
+#endif
diff --git a/drivers/media/video/mrstci/mrstisp/include/def.h b/drivers/media/video/mrstci/mrstisp/include/def.h
new file mode 100644
index 0000000..75bcbec
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/include/def.h
@@ -0,0 +1,111 @@
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
+#ifndef _DEF_H
+#define _DEF_H
+
+#include <linux/stddef.h>
+
+#ifndef ON
+/* all bits to '1' but prevent "shift overflow" warning */
+#define ON   -1
+#endif
+
+#ifndef OFF
+#define OFF  0
+#endif
+
+#ifndef ENABLE
+/* all bits to '1' but prevent "shift overflow" warning */
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
+#ifndef UNUSED_PARAM
+#define UNUSED_PARAM(x)   ((x) = (x))
+#endif
+
+/* to avoid Lint warnings, use it within const context */
+#ifndef UNUSED_PARAM1
+#define UNUSED_PARAM1(x)
+#endif
+
+/*
+ * documentation keywords for pointer arguments, to tell the direction of the
+ * passing
+ */
+
+#ifndef OUT
+/* pointer content is expected to be filled by called function */
+#define OUT
+#endif
+
+#ifndef IN
+/* pointer content contains parameters from the caller */
+#define IN
+#endif
+
+#ifndef INOUT
+/* content is expected to be read and changed */
+#define INOUT
+#endif
+
+/* some useful macros */
+#ifndef MIN
+#define MIN(x, y)            ((x) < (y) ? (x) : (y))
+#endif
+
+#ifndef MAX
+#define MAX(x, y)            ((x) > (y) ? (x) : (y))
+#endif
+
+#ifndef ABS
+#define ABS(val)            ((val) < 0 ? -(val) : (val))
+#endif
+
+/*
+ * converts a term to a string (two macros are required, never use _VAL2STR()
+ * directly)
+ */
+#define _VAL2STR(x) #x
+#define VAL2STR(x) _VAL2STR(x)
+
+#endif
diff --git a/drivers/media/video/mrstci/mrstisp/include/mrstisp.h b/drivers/media/video/mrstci/mrstisp/include/mrstisp.h
new file mode 100644
index 0000000..f8a7cfd
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/include/mrstisp.h
@@ -0,0 +1,245 @@
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
diff --git a/drivers/media/video/mrstci/mrstisp/include/mrstisp_dp.h b/drivers/media/video/mrstci/mrstisp/include/mrstisp_dp.h
new file mode 100644
index 0000000..9978b05
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/include/mrstisp_dp.h
@@ -0,0 +1,257 @@
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
+
+#ifndef _MRV_SLS_H
+#define _MRV_SLS_H
+
+/* data path descriptor */
+struct ci_isp_datapath_desc {
+       u16 out_w;
+       u16 out_h;
+       u32 flags;
+};
+
+#define CI_ISP_DPD_DISABLE         0x00000000
+#define CI_ISP_DPD_ENABLE          0x00000001
+#define CI_ISP_DPD_NORESIZE        0x00000002
+
+/*
+ * The input picture from ISP is being cropped to match the
+ * aspect ratio of the desired output. If this flag is not
+ * set, different scaling factors for X and Y axis
+ * may be used.
+ */
+#define CI_ISP_DPD_KEEPRATIO       0x00000004
+#define CI_ISP_DPD_MIRROR          0x00000008
+#define CI_ISP_DPD_MODE_MASK          0x00000070
+#define CI_ISP_DPD_MODE_ISPRAW_16B     0x00000000
+#define CI_ISP_DPD_MODE_ISPYC          0x00000010
+#define CI_ISP_DPD_MODE_ISPRAW         0x00000020
+#define CI_ISP_DPD_MODE_ISPJPEG        0x00000030
+/*
+ * YCbCr data from system memory directly routed to the main/self
+ * path (DMA-read, only applicable for self path)
+ */
+#define CI_ISP_DPD_MODE_DMAYC_DIRECT   0x00000040
+
+/*
+ * YCbCr data from system memory routed through the main processing
+ * chain substituting ISP data (DMA-read)
+ */
+#define CI_ISP_DPD_MODE_DMAYC_ISP      0x00000050
+
+/*
+ * YCbCr data from system memory directly routed to the jpeg encoder
+ * (DMA-read, R2B-bufferless encoding, only applicable for main path)
+ */
+#define CI_ISP_DPD_MODE_DMAJPEG_DIRECT 0x00000060
+
+/*
+ * Jpeg encoding with YCbCr data from system memory routed through the
+ * main processing chain substituting ISP data (DMA-read, only applicable
+ * for main path) top blackline support
+ */
+#define CI_ISP_DPD_MODE_DMAJPEG_ISP    0x00000070
+
+#define CI_ISP_DPD_BLACKLINES_TOP  0x00000080
+#define CI_ISP_DPD_CSS_H_MASK      0x00000700
+#define CI_ISP_DPD_CSS_H_OFF       0x00000000
+#define CI_ISP_DPD_CSS_H2          0x00000100
+#define CI_ISP_DPD_CSS_H4          0x00000200
+#define CI_ISP_DPD_CSS_HUP2        0x00000500
+#define CI_ISP_DPD_CSS_HUP4        0x00000600
+#define CI_ISP_DPD_CSS_V_MASK      0x00003800
+#define CI_ISP_DPD_CSS_V_OFF       0x00000000
+#define CI_ISP_DPD_CSS_V2          0x00000800
+#define CI_ISP_DPD_CSS_V4          0x00001000
+#define CI_ISP_DPD_CSS_VUP2        0x00002800
+#define CI_ISP_DPD_CSS_VUP4        0x00003000
+#define CI_ISP_DPD_CSS_HSHIFT      0x00004000
+#define CI_ISP_DPD_CSS_VSHIFT      0x00008000
+
+/*
+ * Hardware RGB conversion (currently, only supported for self path)
+ * output mode mask (3 bits, not all combination used yet)
+ */
+#define CI_ISP_DPD_HWRGB_MASK     0x00070000
+#define CI_ISP_DPD_HWRGB_OFF       0x00000000
+#define CI_ISP_DPD_HWRGB_565       0x00010000
+#define CI_ISP_DPD_HWRGB_666       0x00020000
+#define CI_ISP_DPD_HWRGB_888       0x00030000
+
+#define CI_ISP_DPD_YUV_420     0x00040000
+#define CI_ISP_DPD_YUV_422     0x00050000
+#define CI_ISP_DPD_YUV_NV12    0x00060000
+#define CI_ISP_DPD_YUV_YUYV    0x00070000
+
+#define CI_ISP_DPD_DMA_IN_MASK    0x00180000
+#define CI_ISP_DPD_DMA_IN_422      0x00000000
+#define CI_ISP_DPD_DMA_IN_444      0x00080000
+#define CI_ISP_DPD_DMA_IN_420      0x00100000
+#define CI_ISP_DPD_DMA_IN_411      0x00180000
+
+/*
+ * Upscaling interpolation mode (tells how newly created pixels
+ * will be interpolated from the existing ones)
+ * Upscaling interpolation mode mask (2 bits, not all combinations
+ * used yet)
+ */
+#define CI_ISP_DPD_UPSCALE_MASK       0x00600000
+#define CI_ISP_DPD_UPSCALE_SMOOTH_LIN  0x00000000
+
+/*
+ * sharp edges, no interpolation, just duplicate pixels, creates
+ * the typical 'blocky' effect.
+ */
+#define CI_ISP_DPD_UPSCALE_SHARP       0x00200000
+
+/*
+ * additional luminance phase shift
+ * apply horizontal luminance phase shift by half the sample distance
+ */
+#define CI_ISP_DPD_LUMA_HSHIFT     0x00800000
+/* apply vertical luminance phase shift by half the sample distance */
+#define CI_ISP_DPD_LUMA_VSHIFT     0x01000000
+
+/*
+ * picture flipping and rotation
+ * Note that when combining the flags, the rotation is applied first.
+ * This enables to configure all 8 possible orientations
+ */
+
+/* horizontal flipping - same as mirroring */
+#define CI_ISP_DPD_H_FLIP          CI_ISP_DPD_MIRROR
+/* vertical flipping */
+#define CI_ISP_DPD_V_FLIP          0x02000000
+/* rotation 90 degrees counter-clockwise */
+#define CI_ISP_DPD_90DEG_CCW       0x04000000
+
+/*
+ * switch to differentiate between full range of values for YCbCr (0-255)
+ * and restricted range (16-235 for Y) (16-240 for CbCr)'
+ * if set leads to unrestricted range (0-255) for YCbCr
+ * package length of a system interface transfer
+ */
+#define CI_ISP_DPD_YCBCREXT        0x10000000
+/* burst mask (2 bits) */
+#define CI_ISP_DPD_BURST_MASK      0x60000000
+/* AHB 4 beat burst */
+#define CI_ISP_DPD_BURST_4          0x00000000
+/* AHB 8 beat burst */
+#define CI_ISP_DPD_BURST_8          0x20000000
+/* AHB 16 beat burst */
+#define CI_ISP_DPD_BURST_16         0x40000000
+
+/* configures main and self datapathes and scaler for data coming from the
+ * ISP */
+
+
+int ci_datapath_isp(const struct ci_pl_system_config *sys_conf,
+                   const struct ci_sensor_config *isi_config,
+                   const struct ci_isp_datapath_desc *main,
+                   const struct ci_isp_datapath_desc *self, int zoom);
+
+
+/*
+ * Coordinate transformations: The pixel data coming from the sensor passes
+ * through the ISP output formatter where they may be cropped and through
+ * the main path scaler where they may be stretched and/or squeezed. Thus,
+ * the coordinate systems of input and output are different, but somewhat
+ * related. Further, we can do digital zoom, which adds a third coordinate
+ * system: the virtual input (e.g. a cropped sensor frame zoomed in to the
+ * full sensor frame size. Following routines are intended to transform
+ * pixel resp. window positions from one coordinate systen to another.
+ * Folloin coordinate systems exist: Cam  : original frame coming from the
+ * camera VCam : virtual camera; a system in which a cropped original
+ * camera frame is up-scaled to the camera frame size. If no digital zoom
+ * is to be done, Cam and VCam are identical.  Main : output of main path
+ * Self : output of self path
+ */
+/* coordinate transformation from (real) camera coordinate system to main
+ * path output */
+int ci_transform_cam2_main(
+       const struct ci_isp_window *wnd_in,
+       struct ci_isp_window *wnd_out
+);
+/* coordinate transformation from (real) camera coordinate system to self
+ * path output */
+int ci_transform_cam2_self(
+       const struct ci_isp_window *wnd_in,
+       struct ci_isp_window *wnd_out
+);
+/* coordinate transformation from virtual camera to real camera coordinate
+ * system */
+void ci_transform_vcam2_cam(
+       const struct ci_sensor_config *isi_sensor_config,
+       const struct ci_isp_window *wnd_in,
+       struct ci_isp_window *wnd_out
+);
+
+/*
+ * Still image snapshot support
+ * The routine re-configures the main path for taking the snapshot. On
+ * successful return, the snapshot has been stored in the given memory
+ * location. Note that the settings of MARVIN will not be restored.
+ */
+
+/*
+ * take the desired snapshot. The type of snapshot (YUV, RAW or JPEG) is
+ * determined by the datapath selection bits in ci_isp_datapath_desc::flags.
+ * Note that the MARVIN configuration may be changed but will not be
+ * restored after the snapshot.
+ */
+int ci_do_snapshot(
+       const struct ci_sensor_config *isi_sensor_config,
+       const struct ci_isp_datapath_desc *main,
+       int zoom,
+       u8 jpeg_compression,
+       struct ci_isp_mi_path_conf *isp_mi_path_conf
+);
+
+
+/* Initialization of the Bad Pixel Detection and Correction */
+int ci_bp_init(
+       const struct ci_isp_bp_corr_config *bp_corr_config,
+       const struct ci_isp_bp_det_config *bp_det_config
+);
+/* Bad Pixel Correction */
+int ci_bp_correction(void);
+/* Disable Bad Pixel Correction and dectection */
+int ci_bp_end(const struct ci_isp_bp_corr_config *bp_corr_config);
+
+/* Capture a whole JPEG snapshot */
+u32 ci_jpe_capture(struct mrst_isp_device *intel,
+                  enum ci_isp_conf_update_time update_time);
+int ci_jpe_encode(struct mrst_isp_device *intel,
+                 enum ci_isp_conf_update_time update_time,
+                 enum ci_isp_jpe_enc_mode mrv_jpe_encMode);
+/* Encode motion JPEG */
+int ci_isp_jpe_enc_motion(enum ci_isp_jpe_enc_mode jpe_enc_mode,
+                          u16 frames_num, u32 *byte_count);
+
+void ci_isp_set_yc_mode(void);
+
+#endif
diff --git a/drivers/media/video/mrstci/mrstisp/include/mrstisp_hw.h b/drivers/media/video/mrstci/mrstisp/include/mrstisp_hw.h
new file mode 100644
index 0000000..a9b54d5
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/include/mrstisp_hw.h
@@ -0,0 +1,176 @@
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
+#ifndef _MRV_H
+#define _MRV_H
+
+/* move structure definination to ci_isp_common.h */
+#include "ci_isp_common.h"
+
+/* sensor struct related functions */
+int ci_isp_bp_write_table(
+       const struct ci_sensor_bp_table *bp_table
+);
+int ci_isp_bp_read_table(struct ci_sensor_bp_table *bp_table);
+enum ci_isp_path ci_isp_select_path(
+       const struct ci_sensor_config *isi_cfg,
+       u8 *words_per_pixel
+);
+int ci_isp_set_input_aquisition(
+       const struct ci_sensor_config *isi_cfg
+);
+void ci_isp_set_gamma(
+       const struct ci_sensor_gamma_curve *r,
+       const struct ci_sensor_gamma_curve *g,
+       const struct ci_sensor_gamma_curve *b
+);
+int ci_isp_get_wb_meas(struct ci_sensor_awb_mean *awb_mean);
+int ci_isp_set_bp_correction(
+       const struct ci_isp_bp_corr_config *bp_corr_config
+);
+int ci_isp_set_bp_detection(
+       const struct ci_isp_bp_det_config *bp_det_config
+);
+int ci_isp_clear_bp_int(void);
+u32 ci_isp_get_frame_end_irq_mask_dma(void);
+u32 ci_isp_get_frame_end_irq_mask_isp(void);
+int ci_isp_wait_for_frame_end(struct mrst_isp_device *intel);
+void ci_isp_set_output_formatter(
+       const struct ci_isp_window *window,
+       enum ci_isp_conf_update_time update_time
+);
+
+int ci_isp_is_set_config(const struct ci_isp_is_config *is_config);
+int ci_isp_set_data_path(
+       enum ci_isp_ycs_chn_mode ycs_chn_mode,
+       enum ci_isp_dp_switch dp_switch
+);
+void ci_isp_res_set_main_resize(const struct ci_isp_scale *scale,
+       enum ci_isp_conf_update_time update_time,
+       const struct ci_isp_rsz_lut *rsz_lut
+);
+void ci_isp_res_get_main_resize(struct ci_isp_scale *scale);
+void ci_isp_res_set_self_resize(const struct ci_isp_scale *scale,
+       enum ci_isp_conf_update_time update_time,
+       const struct ci_isp_rsz_lut *rsz_lut
+);
+void ci_isp_res_get_self_resize(struct ci_isp_scale *scale);
+int ci_isp_mif_set_main_buffer(
+       const struct ci_isp_mi_path_conf *mrv_mi_path_conf,
+       enum ci_isp_conf_update_time update_time
+);
+int ci_isp_mif_set_self_buffer(
+       const struct ci_isp_mi_path_conf *mrv_mi_path_conf,
+       enum ci_isp_conf_update_time update_time
+);
+
+int ci_isp_mif_set_dma_buffer(
+       const struct ci_isp_mi_path_conf *mrv_mi_path_conf
+);
+
+void ci_isp_mif_disable_all_paths(int perform_wait_for_frame_end);
+int ci_isp_mif_get_main_buffer(
+       struct ci_isp_mi_path_conf *mrv_mi_path_conf
+);
+int ci_isp_mif_get_self_buffer(
+       struct ci_isp_mi_path_conf *mrv_mi_path_conf
+);
+int ci_isp_mif_set_path_and_orientation(
+       const struct ci_isp_mi_ctrl *mrv_mi_ctrl
+);
+int ci_isp_mif_get_path_and_orientation(
+       struct ci_isp_mi_ctrl *mrv_mi_ctrl
+);
+int ci_isp_mif_set_configuration(
+       const struct ci_isp_mi_ctrl *mrv_mi_ctrl,
+       const struct ci_isp_mi_path_conf *mrv_mi_mp_path_conf,
+       const struct ci_isp_mi_path_conf *mrv_mi_sp_path_conf,
+       const struct ci_isp_mi_dma_conf *mrv_mi_dma_conf
+);
+int ci_isp_mif_set_dma_config(
+       const struct ci_isp_mi_dma_conf *mrv_mi_dma_conf
+);
+int ci_isp_mif_get_pixel_per32_bit_of_line(
+       u8 *pixel_per32_bit,
+       enum ci_isp_mif_col_format mrv_mif_sp_format,
+       enum ci_isp_mif_pic_form mrv_mif_pic_form,
+       int luminance_buffer
+);
+void ci_isp_set_ext_ycmode(void);
+int ci_isp_set_mipi_smia(u32 mode);
+void ci_isp_sml_out_set_path(enum ci_isp_data_path main_path);
+u32 ci_isp_mif_get_byte_cnt(void);
+void ci_isp_start(
+       u16 number_of_frames,
+       enum ci_isp_conf_update_time update_time
+);
+int ci_isp_jpe_init_ex(
+       u16 hsize,
+       u16 vsize,
+       u8 compression_ratio,
+       u8 jpe_scale
+);
+void ci_isp_reset_interrupt_status(void);
+void ci_isp_get_output_formatter(struct ci_isp_window *window);
+int ci_isp_set_auto_focus(const struct ci_isp_af_config *af_config);
+void ci_isp_get_auto_focus_meas(struct ci_isp_af_meas *af_meas);
+int ci_isp_chk_bp_int_stat(void);
+int ci_isp_bls_get_measured_values(
+       struct ci_isp_bls_measured *bls_measured
+);
+int ci_isp_get_wb_measConfig(
+       struct ci_isp_wb_meas_config *wb_meas_config
+);
+void ci_isp_col_set_color_processing(
+       const struct ci_isp_color_settings *col
+);
+int ci_isp_ie_set_config(const struct ci_isp_ie_config *ie_config);
+int ci_isp_set_ls_correction(struct ci_sensor_ls_corr_config *ls_corr_config);
+int ci_isp_ls_correction_on_off(int ls_corr_on_off);
+int ci_isp_activate_filter(int activate_filter);
+int ci_isp_set_filter_params(u8 noise_reduc_level, u8 sharp_level);
+int ci_isp_bls_set_config(const struct ci_isp_bls_config *bls_config);
+int ci_isp_set_wb_mode(enum ci_isp_awb_mode wb_mode);
+int ci_isp_set_wb_meas_config(
+       const struct ci_isp_wb_meas_config *wb_meas_config
+);
+int ci_isp_set_wb_auto_hw_config(
+       const struct ci_isp_wb_auto_hw_config *wb_auto_hw_config
+);
+void ci_isp_init(void);
+void ci_isp_off(void);
+void ci_isp_stop(enum ci_isp_conf_update_time update_time);
+void ci_isp_mif_reset_offsets(enum ci_isp_conf_update_time update_time);
+int ci_isp_get_wb_measConfig(
+       struct ci_isp_wb_meas_config *wb_meas_config
+);
+void ci_isp_set_gamma2(const struct ci_isp_gamma_out_curve *gamma);
+void ci_isp_set_demosaic(
+       enum ci_isp_demosaic_mode demosaic_mode,
+       u8 demosaic_th
+);
+void mrst_isp_disable_interrupt(struct mrst_isp_device *isp);
+void mrst_isp_enable_interrupt(struct mrst_isp_device *isp);
+#endif
diff --git a/drivers/media/video/mrstci/mrstisp/include/mrstisp_isp.h b/drivers/media/video/mrstci/mrstisp/include/mrstisp_isp.h
new file mode 100644
index 0000000..da24d46
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/include/mrstisp_isp.h
@@ -0,0 +1,42 @@
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
+#define MRV_MEAN_LUMA_ARR_SIZE_COL 5
+#define MRV_MEAN_LUMA_ARR_SIZE_ROW 5
+#define MRV_MEAN_LUMA_ARR_SIZE     \
+       (MRV_MEAN_LUMA_ARR_SIZE_COL*MRV_MEAN_LUMA_ARR_SIZE_ROW)
+int ci_isp_meas_exposure_initialize_module(void);
+
+int ci_isp_meas_exposure_set_config(const struct ci_isp_window *wnd,
+       const struct ci_isp_exp_ctrl *isp_exp_ctrl);
+int ci_isp_meas_exposure_get_config(struct ci_isp_window *wnd,
+       struct ci_isp_exp_ctrl *isp_exp_ctrl);
+
+int ci_isp_meas_exposure_get_mean_luma_values(
+       struct ci_isp_mean_luma *mrv_mean_luma);
+int ci_isp_meas_exposure_get_mean_luma_by_num(
+       u8 BlockNum, u8 *luma);
+int ci_isp_meas_exposure_get_mean_luma_by_pos(
+       u8 XPos, u8 YPos, u8 *luma);
+int mrst_isp_set_color_conversion_ex(void);
diff --git a/drivers/media/video/mrstci/mrstisp/include/mrstisp_jpe.h b/drivers/media/video/mrstci/mrstisp/include/mrstisp_jpe.h
new file mode 100644
index 0000000..634c715
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/include/mrstisp_jpe.h
@@ -0,0 +1,416 @@
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
+#include "mrstisp.h"
+
+/* DC luma table according to ISO/IEC 10918-1 annex K */
+static const u8 ci_isp_dc_luma_table_annex_k[] = {
+       0x00, 0x01, 0x05, 0x01, 0x01, 0x01, 0x01, 0x01,
+       0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+       0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
+       0x08, 0x09, 0x0a, 0x0b
+};
+
+/* DC chroma table according to ISO/IEC 10918-1 annex K */
+static const u8 ci_isp_dc_chroma_table_annex_k[] = {
+       0x00, 0x03, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
+       0x01, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00,
+       0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
+       0x08, 0x09, 0x0a, 0x0b
+};
+
+/* AC luma table according to ISO/IEC 10918-1 annex K */
+static const u8 ci_isp_ac_luma_table_annex_k[] = {
+       0x00, 0x02, 0x01, 0x03, 0x03, 0x02, 0x04, 0x03,
+       0x05, 0x05, 0x04, 0x04, 0x00, 0x00, 0x01, 0x7d,
+       0x01, 0x02, 0x03, 0x00, 0x04, 0x11, 0x05, 0x12,
+       0x21, 0x31, 0x41, 0x06, 0x13, 0x51, 0x61, 0x07,
+       0x22, 0x71, 0x14, 0x32, 0x81, 0x91, 0xa1, 0x08,
+       0x23, 0x42, 0xb1, 0xc1, 0x15, 0x52, 0xd1, 0xf0,
+       0x24, 0x33, 0x62, 0x72, 0x82, 0x09, 0x0a, 0x16,
+       0x17, 0x18, 0x19, 0x1a, 0x25, 0x26, 0x27, 0x28,
+       0x29, 0x2a, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39,
+       0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49,
+       0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59,
+       0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69,
+       0x6a, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79,
+       0x7a, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89,
+       0x8a, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98,
+       0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7,
+       0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6,
+       0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3, 0xc4, 0xc5,
+       0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2, 0xd3, 0xd4,
+       0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda, 0xe1, 0xe2,
+       0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea,
+       0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8,
+       0xf9, 0xfa
+};
+
+/* AC Chroma table according to ISO/IEC 10918-1 annex K */
+static const u8 ci_isp_ac_chroma_table_annex_k[] = {
+       0x00, 0x02, 0x01, 0x02, 0x04, 0x04, 0x03, 0x04,
+       0x07, 0x05, 0x04, 0x04, 0x00, 0x01, 0x02, 0x77,
+       0x00, 0x01, 0x02, 0x03, 0x11, 0x04, 0x05, 0x21,
+       0x31, 0x06, 0x12, 0x41, 0x51, 0x07, 0x61, 0x71,
+       0x13, 0x22, 0x32, 0x81, 0x08, 0x14, 0x42, 0x91,
+       0xa1, 0xb1, 0xc1, 0x09, 0x23, 0x33, 0x52, 0xf0,
+       0x15, 0x62, 0x72, 0xd1, 0x0a, 0x16, 0x24, 0x34,
+       0xe1, 0x25, 0xf1, 0x17, 0x18, 0x19, 0x1a, 0x26,
+       0x27, 0x28, 0x29, 0x2a, 0x35, 0x36, 0x37, 0x38,
+       0x39, 0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48,
+       0x49, 0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58,
+       0x59, 0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68,
+       0x69, 0x6a, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78,
+       0x79, 0x7a, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
+       0x88, 0x89, 0x8a, 0x92, 0x93, 0x94, 0x95, 0x96,
+       0x97, 0x98, 0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5,
+       0xa6, 0xa7, 0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4,
+       0xb5, 0xb6, 0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3,
+       0xc4, 0xc5, 0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2,
+       0xd3, 0xd4, 0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda,
+       0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9,
+       0xea, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8,
+       0xf9, 0xfa
+};
+
+/* luma quantization table 75% quality setting */
+static const u8 ci_isp_yq_table75_per_cent[] = {
+       0x08, 0x06, 0x06, 0x07, 0x06, 0x05, 0x08, 0x07,
+       0x07, 0x07, 0x09, 0x09, 0x08, 0x0a, 0x0c, 0x14,
+       0x0d, 0x0c, 0x0b, 0x0b, 0x0c, 0x19, 0x12, 0x13,
+       0x0f, 0x14, 0x1d, 0x1a, 0x1f, 0x1e, 0x1d, 0x1a,
+       0x1c, 0x1c, 0x20, 0x24, 0x2e, 0x27, 0x20, 0x22,
+       0x2c, 0x23, 0x1c, 0x1c, 0x28, 0x37, 0x29, 0x2c,
+       0x30, 0x31, 0x34, 0x34, 0x34, 0x1f, 0x27, 0x39,
+       0x3d, 0x38, 0x32, 0x3c, 0x2e, 0x33, 0x34, 0x32
+};
+
+/* chroma quantization table 75% quality setting */
+static const u8 ci_isp_uv_qtable75_per_cent[] = {
+       0x09, 0x09, 0x09, 0x0c, 0x0b, 0x0c, 0x18, 0x0d,
+       0x0d, 0x18, 0x32, 0x21, 0x1c, 0x21, 0x32, 0x32,
+       0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32,
+       0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32,
+       0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32,
+       0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32,
+       0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32,
+       0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32
+};
+
+/*
+ * luma quantization table very low compression(about factor 2)
+ */
+static const u8 ci_isp_yq_table_low_comp1[] = {
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02
+};
+
+/*
+ * chroma quantization table very low compression
+ * (about factor 2)
+ */
+static const u8 ci_isp_uv_qtable_low_comp1[] = {
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02
+};
+
+/*
+ * The jpg Quantization Tables were parsed by jpeg_parser from
+ * jpg images generated by Jasc PaintShopPro.
+ *
+ */
+
+/* 01% */
+/* luma quantization table */
+static const u8 ci_isp_yq_table01_per_cent[] = {
+       0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
+       0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
+       0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
+       0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
+       0x01, 0x01, 0x01, 0x01, 0x02, 0x02, 0x01, 0x01,
+       0x02, 0x01, 0x01, 0x01, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x01, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02
+};
+
+/* chroma quantization table */
+static const u8 ci_isp_uv_qtable01_per_cent[] = {
+       0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
+       0x01, 0x01, 0x02, 0x01, 0x01, 0x01, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02
+};
+
+/* 20% */
+/* luma quantization table */
+static const u8 ci_isp_yq_table20_per_cent[] = {
+       0x06, 0x04, 0x05, 0x06, 0x05, 0x04, 0x06, 0x06,
+       0x05, 0x06, 0x07, 0x07, 0x06, 0x08, 0x0a, 0x10,
+       0x0a, 0x0a, 0x09, 0x09, 0x0a, 0x14, 0x0e, 0x0f,
+       0x0c, 0x10, 0x17, 0x14, 0x18, 0x18, 0x17, 0x14,
+       0x16, 0x16, 0x1a, 0x1d, 0x25, 0x1f, 0x1a, 0x1b,
+       0x23, 0x1c, 0x16, 0x16, 0x20, 0x2c, 0x20, 0x23,
+       0x26, 0x27, 0x29, 0x2a, 0x29, 0x19, 0x1f, 0x2d,
+       0x30, 0x2d, 0x28, 0x30, 0x25, 0x28, 0x29, 0x28
+};
+
+/* chroma quantization table */
+static const u8 ci_isp_uv_qtable20_per_cent[] = {
+       0x07, 0x07, 0x07, 0x0a, 0x08, 0x0a, 0x13, 0x0a,
+       0x0a, 0x13, 0x28, 0x1a, 0x16, 0x1a, 0x28, 0x28,
+       0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28,
+       0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28,
+       0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28,
+       0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28,
+       0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28,
+       0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28
+};
+
+/* 30% */
+/* luma quantization table */
+static const u8 ci_isp_yq_table30_per_cent[] = {
+       0x0a, 0x07, 0x07, 0x08, 0x07, 0x06, 0x0a, 0x08,
+       0x08, 0x08, 0x0b, 0x0a, 0x0a, 0x0b, 0x0e, 0x18,
+       0x10, 0x0e, 0x0d, 0x0d, 0x0e, 0x1d, 0x15, 0x16,
+       0x11, 0x18, 0x23, 0x1f, 0x25, 0x24, 0x22, 0x1f,
+       0x22, 0x21, 0x26, 0x2b, 0x37, 0x2f, 0x26, 0x29,
+       0x34, 0x29, 0x21, 0x22, 0x30, 0x41, 0x31, 0x34,
+       0x39, 0x3b, 0x3e, 0x3e, 0x3e, 0x25, 0x2e, 0x44,
+       0x49, 0x43, 0x3c, 0x48, 0x37, 0x3d, 0x3e, 0x3b
+};
+
+/* chroma quantization table */
+static const u8 ci_isp_uv_qtable30_per_cent[] = {
+       0x0a, 0x0b, 0x0b, 0x0e, 0x0d, 0x0e, 0x1c, 0x10,
+       0x10, 0x1c, 0x3b, 0x28, 0x22, 0x28, 0x3b, 0x3b,
+       0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b,
+       0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b,
+       0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b,
+       0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b,
+       0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b,
+       0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b
+};
+
+
+/* 40% */
+/* luma quantization table */
+static const u8 ci_isp_yq_table40_per_cent[] = {
+       0x0d, 0x09, 0x0a, 0x0b, 0x0a, 0x08, 0x0d, 0x0b,
+       0x0a, 0x0b, 0x0e, 0x0e, 0x0d, 0x0f, 0x13, 0x20,
+       0x15, 0x13, 0x12, 0x12, 0x13, 0x27, 0x1c, 0x1e,
+       0x17, 0x20, 0x2e, 0x29, 0x31, 0x30, 0x2e, 0x29,
+       0x2d, 0x2c, 0x33, 0x3a, 0x4a, 0x3e, 0x33, 0x36,
+       0x46, 0x37, 0x2c, 0x2d, 0x40, 0x57, 0x41, 0x46,
+       0x4c, 0x4e, 0x52, 0x53, 0x52, 0x32, 0x3e, 0x5a,
+       0x61, 0x5a, 0x50, 0x60, 0x4a, 0x51, 0x52, 0x4f
+};
+
+/* chroma quantization table */
+static const u8 ci_isp_uv_qtable40_per_cent[] = {
+       0x0e, 0x0e, 0x0e, 0x13, 0x11, 0x13, 0x26, 0x15,
+       0x15, 0x26, 0x4f, 0x35, 0x2d, 0x35, 0x4f, 0x4f,
+       0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f,
+       0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f,
+       0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f,
+       0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f,
+       0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f,
+       0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f
+};
+
+/* 50% */
+/* luma quantization table */
+static const u8 ci_isp_yq_table50_per_cent[] = {
+       0x10, 0x0b, 0x0c, 0x0e, 0x0c, 0x0a, 0x10, 0x0e,
+       0x0d, 0x0e, 0x12, 0x11, 0x10, 0x13, 0x18, 0x28,
+       0x1a, 0x18, 0x16, 0x16, 0x18, 0x31, 0x23, 0x25,
+       0x1d, 0x28, 0x3a, 0x33, 0x3d, 0x3c, 0x39, 0x33,
+       0x38, 0x37, 0x40, 0x48, 0x5c, 0x4e, 0x40, 0x44,
+       0x57, 0x45, 0x37, 0x38, 0x50, 0x6d, 0x51, 0x57,
+       0x5f, 0x62, 0x67, 0x68, 0x67, 0x3e, 0x4d, 0x71,
+       0x79, 0x70, 0x64, 0x78, 0x5c, 0x65, 0x67, 0x63
+};
+
+/* chroma quantization table */
+static const u8 ci_isp_uv_qtable50_per_cent[] = {
+       0x11, 0x12, 0x12, 0x18, 0x15, 0x18, 0x2f, 0x1a,
+       0x1a, 0x2f, 0x63, 0x42, 0x38, 0x42, 0x63, 0x63,
+       0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
+       0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
+       0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
+       0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
+       0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
+       0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63
+};
+
+/* 60% */
+/* luma quantization table */
+static const u8 ci_isp_yq_table60_per_cent[] = {
+       0x14, 0x0e, 0x0f, 0x12, 0x0f, 0x0d, 0x14, 0x12,
+       0x10, 0x12, 0x17, 0x15, 0x14, 0x18, 0x1e, 0x32,
+       0x21, 0x1e, 0x1c, 0x1c, 0x1e, 0x3d, 0x2c, 0x2e,
+       0x24, 0x32, 0x49, 0x40, 0x4c, 0x4b, 0x47, 0x40,
+       0x46, 0x45, 0x50, 0x5a, 0x73, 0x62, 0x50, 0x55,
+       0x6d, 0x56, 0x45, 0x46, 0x64, 0x88, 0x65, 0x6d,
+       0x77, 0x7b, 0x81, 0x82, 0x81, 0x4e, 0x60, 0x8d,
+       0x97, 0x8c, 0x7d, 0x96, 0x73, 0x7e, 0x81, 0x7c
+};
+
+/* chroma quantization table */
+static const u8 ci_isp_uv_qtable60_per_cent[] = {
+       0x15, 0x17, 0x17, 0x1e, 0x1a, 0x1e, 0x3b, 0x21,
+       0x21, 0x3b, 0x7c, 0x53, 0x46, 0x53, 0x7c, 0x7c,
+       0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c,
+       0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c,
+       0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c,
+       0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c,
+       0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c,
+       0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c
+};
+
+/* 70% */
+/* luma quantization table */
+static const u8 ci_isp_yq_table70_per_cent[] = {
+       0x1b, 0x12, 0x14, 0x17, 0x14, 0x11, 0x1b, 0x17,
+       0x16, 0x17, 0x1e, 0x1c, 0x1b, 0x20, 0x28, 0x42,
+       0x2b, 0x28, 0x25, 0x25, 0x28, 0x51, 0x3a, 0x3d,
+       0x30, 0x42, 0x60, 0x55, 0x65, 0x64, 0x5f, 0x55,
+       0x5d, 0x5b, 0x6a, 0x78, 0x99, 0x81, 0x6a, 0x71,
+       0x90, 0x73, 0x5b, 0x5d, 0x85, 0xb5, 0x86, 0x90,
+       0x9e, 0xa3, 0xab, 0xad, 0xab, 0x67, 0x80, 0xbc,
+       0xc9, 0xba, 0xa6, 0xc7, 0x99, 0xa8, 0xab, 0xa4
+};
+
+/* chroma quantization table */
+static const u8 ci_isp_uv_qtable70_per_cent[] = {
+       0x1c, 0x1e, 0x1e, 0x28, 0x23, 0x28, 0x4e, 0x2b,
+       0x2b, 0x4e, 0xa4, 0x6e, 0x5d, 0x6e, 0xa4, 0xa4,
+       0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4,
+       0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4,
+       0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4,
+       0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4,
+       0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4,
+       0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4
+};
+
+/* 80% */
+/* luma quantization table */
+static const u8 ci_isp_yq_table80_per_cent[] = {
+       0x28, 0x1c, 0x1e, 0x23, 0x1e, 0x19, 0x28, 0x23,
+       0x21, 0x23, 0x2d, 0x2b, 0x28, 0x30, 0x3c, 0x64,
+       0x41, 0x3c, 0x37, 0x37, 0x3c, 0x7b, 0x58, 0x5d,
+       0x49, 0x64, 0x91, 0x80, 0x99, 0x96, 0x8f, 0x80,
+       0x8c, 0x8a, 0xa0, 0xb4, 0xe6, 0xc3, 0xa0, 0xaa,
+       0xda, 0xad, 0x8a, 0x8c, 0xc8, 0xff, 0xcb, 0xda,
+       0xee, 0xf5, 0xff, 0xff, 0xff, 0x9b, 0xc1, 0xff,
+       0xff, 0xff, 0xfa, 0xff, 0xe6, 0xfd, 0xff, 0xf8
+};
+
+/* chroma quantization table */
+static const u8 ci_isp_uv_qtable80_per_cent[] = {
+       0x2b, 0x2d, 0x2d, 0x3c, 0x35, 0x3c, 0x76, 0x41,
+       0x41, 0x76, 0xf8, 0xa5, 0x8c, 0xa5, 0xf8, 0xf8,
+       0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8,
+       0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8,
+       0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8,
+       0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8,
+       0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8,
+       0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8
+};
+
+/* 90% */
+/* luma quantization table */
+static const u8 ci_isp_yq_table90_per_cent[] = {
+       0x50, 0x37, 0x3c, 0x46, 0x3c, 0x32, 0x50, 0x46,
+       0x41, 0x46, 0x5a, 0x55, 0x50, 0x5f, 0x78, 0xc8,
+       0x82, 0x78, 0x6e, 0x6e, 0x78, 0xf5, 0xaf, 0xb9,
+       0x91, 0xc8, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+};
+
+/* chroma quantization table */
+static const u8 ci_isp_uv_qtable90_per_cent[] = {
+       0x55, 0x5a, 0x5a, 0x78, 0x69, 0x78, 0xeb, 0x82,
+       0x82, 0xeb, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+};
+
+/* 99% */
+/* luma quantization table */
+static const u8 ci_isp_yq_table99_per_cent[] = {
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+};
+
+/* chroma quantization table */
+static const u8 ci_isp_uv_qtable99_per_cent[] = {
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+};
+
+int ci_isp_wait_for_vsyncHelper(void);
+void ci_isp_jpe_set_tables(u8 compression_ratio);
+void ci_isp_jpe_select_tables(void);
+void ci_isp_jpe_set_config(u16 hsize, u16 vsize, int jpe_scale);
+int ci_isp_jpe_generate_header(struct mrst_isp_device *intel, u8 header_mode);
+void ci_isp_jpe_prep_enc(enum ci_isp_jpe_enc_mode jpe_enc_mode);
+int ci_isp_jpe_wait_for_header_gen_done(struct mrst_isp_device *intel);
+int ci_isp_jpe_wait_for_encode_done(struct mrst_isp_device *intel);
+
diff --git a/drivers/media/video/mrstci/mrstisp/include/mrstisp_reg.h b/drivers/media/video/mrstci/mrstisp/include/mrstisp_reg.h
new file mode 100644
index 0000000..1550e66
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/include/mrstisp_reg.h
@@ -0,0 +1,4499 @@
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
+#ifndef _MRV_PRIV_H
+#define _MRV_PRIV_H
+
+#define MRV_ISP_GAMMA_R_Y_ARR_SIZE 17
+#define MRV_ISP_GAMMA_G_Y_ARR_SIZE 17
+#define MRV_ISP_GAMMA_B_Y_ARR_SIZE 17
+#define MRV_ISP_CT_COEFF_ARR_SIZE 9
+#define MRV_ISP_GAMMA_OUT_Y_ARR_SIZE 17
+#define MRV_ISP_BP_NEW_TABLE_ARR_SIZE 8
+#define MRV_ISP_HIST_BIN_ARR_SIZE 16
+
+struct isp_register {
+       u32 vi_ccl;
+       u32 vi_custom_reg1;
+       u32 vi_id;
+       u32 vi_custom_reg2;
+       u32 vi_iccl;
+       u32 vi_ircl;
+       u32 vi_dpcl;
+
+       u32 notused_mrvbase1;
+
+       u32 notused_mrvbase2[(0x200 - 0x20) / 4];
+
+       u32 img_eff_ctrl;
+       u32 img_eff_color_sel;
+       u32 img_eff_mat_1;
+       u32 img_eff_mat_2;
+       u32 img_eff_mat_3;
+       u32 img_eff_mat_4;
+       u32 img_eff_mat_5;
+       u32 img_eff_tint;
+       u32 img_eff_ctrl_shd;
+       u32 notused_imgeff[(0x300 - 0x224) / 4];
+
+       u32 super_imp_ctrl;
+       u32 super_imp_offset_x;
+       u32 super_imp_offset_y;
+       u32 super_imp_color_y;
+       u32 super_imp_color_cb;
+       u32 super_imp_color_cr;
+       u32 notused_simp[(0x400 - 0x318) / 4];
+
+       u32 isp_ctrl;
+       u32 isp_acq_prop;
+       u32 isp_acq_h_offs;
+       u32 isp_acq_v_offs;
+       u32 isp_acq_h_size;
+       u32 isp_acq_v_size;
+       u32 isp_acq_nr_frames;
+       u32 isp_gamma_dx_lo;
+       u32 isp_gamma_dx_hi;
+       u32 isp_gamma_r_y[MRV_ISP_GAMMA_R_Y_ARR_SIZE];
+       u32 isp_gamma_g_y[MRV_ISP_GAMMA_G_Y_ARR_SIZE];
+       u32 isp_gamma_b_y[MRV_ISP_GAMMA_B_Y_ARR_SIZE];
+
+       u32 notused_ispbls1[(0x510 - 0x4F0) / 4];
+
+       u32 isp_awb_prop;
+       u32 isp_awb_h_offs;
+       u32 isp_awb_v_offs;
+       u32 isp_awb_h_size;
+       u32 isp_awb_v_size;
+       u32 isp_awb_frames;
+       u32 isp_awb_ref;
+       u32 isp_awb_thresh;
+
+    u32 notused_ispawb2[(0x538-0x530)/4];
+
+    u32 isp_awb_gain_g;
+    u32 isp_awb_gain_rb;
+
+       u32 isp_awb_white_cnt;
+       u32 isp_awb_mean;
+
+       u32 notused_ispae[(0x570 - 0x548) / 4];
+       u32 isp_cc_coeff_0;
+       u32 isp_cc_coeff_1;
+       u32 isp_cc_coeff_2;
+       u32 isp_cc_coeff_3;
+       u32 isp_cc_coeff_4;
+       u32 isp_cc_coeff_5;
+       u32 isp_cc_coeff_6;
+       u32 isp_cc_coeff_7;
+       u32 isp_cc_coeff_8;
+
+       u32 isp_out_h_offs;
+       u32 isp_out_v_offs;
+       u32 isp_out_h_size;
+       u32 isp_out_v_size;
+
+       u32 isp_demosaic;
+       u32 isp_flags_shd;
+
+       u32 isp_out_h_offs_shd;
+       u32 isp_out_v_offs_shd;
+       u32 isp_out_h_size_shd;
+       u32 isp_out_v_size_shd;
+
+       u32 isp_imsc;
+       u32 isp_ris;
+       u32 isp_mis;
+       u32 isp_icr;
+       u32 isp_isr;
+
+       u32 isp_ct_coeff[MRV_ISP_CT_COEFF_ARR_SIZE];
+
+       u32 isp_gamma_out_mode;
+       u32 isp_gamma_out_y[MRV_ISP_GAMMA_OUT_Y_ARR_SIZE];
+
+       u32 isp_err;
+       u32 isp_err_clr;
+
+       u32 isp_frame_count;
+
+       u32 isp_ct_offset_r;
+       u32 isp_ct_offset_g;
+       u32 isp_ct_offset_b;
+       u32 notused_ispctoffs[(0x660 - 0x654) / 4];
+
+       u32 isp_flash_cmd;
+       u32 isp_flash_config;
+       u32 isp_flash_prediv;
+       u32 isp_flash_delay;
+       u32 isp_flash_time;
+       u32 isp_flash_maxp;
+       u32 notused_ispflash[(0x680 - 0x678) / 4];
+
+       u32 isp_sh_ctrl;
+       u32 isp_sh_prediv;
+       u32 isp_sh_delay;
+       u32 isp_sh_time;
+       u32 notused_ispsh[(0x800 - 0x690) / 4];
+
+       u32 c_proc_ctrl;
+       u32 c_proc_contrast;
+       u32 c_proc_brightness;
+       u32 c_proc_saturation;
+       u32 c_proc_hue;
+       u32 notused_cproc[(0xC00 - 0x814) / 4];
+
+       u32 mrsz_ctrl;
+       u32 mrsz_scale_hy;
+       u32 mrsz_scale_hcb;
+       u32 mrsz_scale_hcr;
+       u32 mrsz_scale_vy;
+       u32 mrsz_scale_vc;
+       u32 mrsz_phase_hy;
+       u32 mrsz_phase_hc;
+       u32 mrsz_phase_vy;
+       u32 mrsz_phase_vc;
+       u32 mrsz_scale_lut_addr;
+       u32 mrsz_scale_lut;
+       u32 mrsz_ctrl_shd;
+       u32 mrsz_scale_hy_shd;
+       u32 mrsz_scale_hcb_shd;
+       u32 mrsz_scale_hcr_shd;
+       u32 mrsz_scale_vy_shd;
+       u32 mrsz_scale_vc_shd;
+       u32 mrsz_phase_hy_shd;
+       u32 mrsz_phase_hc_shd;
+       u32 mrsz_phase_vy_shd;
+       u32 mrsz_phase_vc_shd;
+       u32 notused_mrsz[(0x1000 - 0x0C58) / 4];
+
+       u32 srsz_ctrl;
+       u32 srsz_scale_hy;
+       u32 srsz_scale_hcb;
+       u32 srsz_scale_hcr;
+       u32 srsz_scale_vy;
+       u32 srsz_scale_vc;
+       u32 srsz_phase_hy;
+       u32 srsz_phase_hc;
+       u32 srsz_phase_vy;
+       u32 srsz_phase_vc;
+       u32 srsz_scale_lut_addr;
+       u32 srsz_scale_lut;
+       u32 srsz_ctrl_shd;
+       u32 srsz_scale_hy_shd;
+       u32 srsz_scale_hcb_shd;
+       u32 srsz_scale_hcr_shd;
+       u32 srsz_scale_vy_shd;
+       u32 srsz_scale_vc_shd;
+       u32 srsz_phase_hy_shd;
+       u32 srsz_phase_hc_shd;
+       u32 srsz_phase_vy_shd;
+       u32 srsz_phase_vc_shd;
+       u32 notused_srsz[(0x1400 - 0x1058) / 4];
+
+    u32 mi_ctrl;
+    u32 mi_init;
+    u32 mi_mp_y_base_ad_init;
+    u32 mi_mp_y_size_init;
+    u32 mi_mp_y_offs_cnt_init;
+    u32 mi_mp_y_offs_cnt_start;
+    u32 mi_mp_y_irq_offs_init;
+    u32 mi_mp_cb_base_ad_init;
+    u32 mi_mp_cb_size_init;
+    u32 mi_mp_cb_offs_cnt_init;
+    u32 mi_mp_cb_offs_cnt_start;
+    u32 mi_mp_cr_base_ad_init;
+    u32 mi_mp_cr_size_init;
+    u32 mi_mp_cr_offs_cnt_init;
+    u32 mi_mp_cr_offs_cnt_start;
+    u32 mi_sp_y_base_ad_init;
+    u32 mi_sp_y_size_init;
+    u32 mi_sp_y_offs_cnt_init;
+    u32 mi_sp_y_offs_cnt_start;
+    u32 mi_sp_y_llength;
+    u32 mi_sp_cb_base_ad_init;
+    u32 mi_sp_cb_size_init;
+    u32 mi_sp_cb_offs_cnt_init;
+    u32 mi_sp_cb_offs_cnt_start;
+    u32 mi_sp_cr_base_ad_init;
+    u32 mi_sp_cr_size_init;
+    u32 mi_sp_cr_offs_cnt_init;
+    u32 mi_sp_cr_offs_cnt_start;
+    u32 mi_byte_cnt;
+    u32 mi_ctrl_shd;
+    u32 mi_mp_y_base_ad_shd;
+    u32 mi_mp_y_size_shd;
+    u32 mi_mp_y_offs_cnt_shd;
+    u32 mi_mp_y_irq_offs_shd;
+    u32 mi_mp_cb_base_ad_shd;
+    u32 mi_mp_cb_size_shd;
+    u32 mi_mp_cb_offs_cnt_shd;
+    u32 mi_mp_cr_base_ad_shd;
+    u32 mi_mp_cr_size_shd;
+    u32 mi_mp_cr_offs_cnt_shd;
+    u32 mi_sp_y_base_ad_shd;
+    u32 mi_sp_y_size_shd;
+    u32 mi_sp_y_offs_cnt_shd;
+
+       u32 notused_mi1;
+
+       u32 mi_sp_cb_base_ad_shd;
+       u32 mi_sp_cb_size_shd;
+       u32 mi_sp_cb_offs_cnt_shd;
+       u32 mi_sp_cr_base_ad_shd;
+       u32 mi_sp_cr_size_shd;
+       u32 mi_sp_cr_offs_cnt_shd;
+       u32 mi_dma_y_pic_start_ad;
+       u32 mi_dma_y_pic_width;
+       u32 mi_dma_y_llength;
+       u32 mi_dma_y_pic_size;
+       u32 mi_dma_cb_pic_start_ad;
+       u32 notused_mi2[(0x14E8 - 0x14DC) / 4];
+       u32 mi_dma_cr_pic_start_ad;
+       u32 notused_mi3[(0x14F8 - 0x14EC) / 4];
+       u32 mi_imsc;
+       u32 mi_ris;
+       u32 mi_mis;
+       u32 mi_icr;
+       u32 mi_isr;
+       u32 mi_status;
+       u32 mi_status_clr;
+       u32 mi_sp_y_pic_width;
+       u32 mi_sp_y_pic_height;
+       u32 mi_sp_y_pic_size;
+       u32 mi_dma_ctrl;
+       u32 mi_dma_start;
+       u32 mi_dma_status;
+       u32 notused_mi6[(0x1800 - 0x152C) / 4];
+       u32 jpe_gen_header;
+       u32 jpe_encode;
+
+       u32 jpe_init;
+
+       u32 jpe_y_scale_en;
+       u32 jpe_cbcr_scale_en;
+       u32 jpe_table_flush;
+       u32 jpe_enc_hsize;
+       u32 jpe_enc_vsize;
+       u32 jpe_pic_format;
+       u32 jpe_restart_interval;
+       u32 jpe_tq_y_select;
+       u32 jpe_tq_u_select;
+       u32 jpe_tq_v_select;
+       u32 jpe_dc_table_select;
+       u32 jpe_ac_table_select;
+       u32 jpe_table_data;
+       u32 jpe_table_id;
+       u32 jpe_tac0_len;
+       u32 jpe_tdc0_len;
+       u32 jpe_tac1_len;
+       u32 jpe_tdc1_len;
+       u32 notused_jpe2;
+       u32 jpe_encoder_busy;
+       u32 jpe_header_mode;
+       u32 jpe_encode_mode;
+       u32 jpe_debug;
+       u32 jpe_error_imr;
+       u32 jpe_error_ris;
+       u32 jpe_error_mis;
+       u32 jpe_error_icr;
+       u32 jpe_error_isr;
+       u32 jpe_status_imr;
+       u32 jpe_status_ris;
+       u32 jpe_status_mis;
+       u32 jpe_status_icr;
+       u32 jpe_status_isr;
+       u32 notused_jpe3[(0x1A00 - 0x1890) / 4];
+
+       u32 smia_ctrl;
+       u32 smia_status;
+       u32 smia_imsc;
+       u32 smia_ris;
+       u32 smia_mis;
+       u32 smia_icr;
+       u32 smia_isr;
+       u32 smia_data_format_sel;
+       u32 smia_sof_emb_data_lines;
+
+       u32 smia_emb_hstart;
+       u32 smia_emb_hsize;
+       u32 smia_emb_vstart;
+
+       u32 smia_num_lines;
+       u32 smia_emb_data_fifo;
+
+       u32 smia_fifo_fill_level;
+       u32 notused_smia2[(0x1A40 - 0x1A3C) / 4];
+
+       u32 notused_smia3[(0x1A60 - 0x1A40) / 4];
+       u32 notused_smia4[(0x1C00 - 0x1A60) / 4];
+
+       u32 mipi_ctrl;
+       u32 mipi_status;
+       u32 mipi_imsc;
+       u32 mipi_ris;
+       u32 mipi_mis;
+       u32 mipi_icr;
+       u32 mipi_isr;
+       u32 mipi_cur_data_id;
+       u32 mipi_img_data_sel;
+       u32 mipi_add_data_sel_1;
+       u32 mipi_add_data_sel_2;
+       u32 mipi_add_data_sel_3;
+       u32 mipi_add_data_sel_4;
+       u32 mipi_add_data_fifo;
+       u32 mipi_add_data_fill_level;
+       u32 notused_mipi[(0x2000 - 0x1C3C) / 4];
+
+       u32 isp_afm_ctrl;
+       u32 isp_afm_lt_a;
+       u32 isp_afm_rb_a;
+       u32 isp_afm_lt_b;
+       u32 isp_afm_rb_b;
+       u32 isp_afm_lt_c;
+       u32 isp_afm_rb_c;
+       u32 isp_afm_thres;
+       u32 isp_afm_var_shift;
+       u32 isp_afm_sum_a;
+       u32 isp_afm_sum_b;
+       u32 isp_afm_sum_c;
+       u32 isp_afm_lum_a;
+       u32 isp_afm_lum_b;
+       u32 isp_afm_lum_c;
+       u32 notused_ispafm[(0x2100 - 0x203C) / 4];
+
+       u32 isp_bp_ctrl;
+       u32 isp_bp_cfg1;
+       u32 isp_bp_cfg2;
+       u32 isp_bp_number;
+       u32 isp_bp_table_addr;
+       u32 isp_bp_table_data;
+       u32 isp_bp_new_number;
+       u32 isp_bp_new_table[MRV_ISP_BP_NEW_TABLE_ARR_SIZE];
+
+       u32 notused_ispbp[(0x2200 - 0x213C) / 4];
+
+       u32 isp_lsc_ctrl;
+       u32 isp_lsc_r_table_addr;
+       u32 isp_lsc_g_table_addr;
+       u32 isp_lsc_b_table_addr;
+       u32 isp_lsc_r_table_data;
+       u32 isp_lsc_g_table_data;
+       u32 isp_lsc_b_table_data;
+       u32 notused_isplsc1;
+       u32 isp_lsc_xgrad_01;
+       u32 isp_lsc_xgrad_23;
+       u32 isp_lsc_xgrad_45;
+       u32 isp_lsc_xgrad_67;
+       u32 isp_lsc_ygrad_01;
+       u32 isp_lsc_ygrad_23;
+       u32 isp_lsc_ygrad_45;
+       u32 isp_lsc_ygrad_67;
+       u32 isp_lsc_xsize_01;
+       u32 isp_lsc_xsize_23;
+       u32 isp_lsc_xsize_45;
+       u32 isp_lsc_xsize_67;
+       u32 isp_lsc_ysize_01;
+       u32 isp_lsc_ysize_23;
+       u32 isp_lsc_ysize_45;
+       u32 isp_lsc_ysize_67;
+       u32 notused_isplsc2[(0x2300 - 0x2260) / 4];
+
+       u32 isp_is_ctrl;
+       u32 isp_is_recenter;
+
+       u32 isp_is_h_offs;
+       u32 isp_is_v_offs;
+       u32 isp_is_h_size;
+       u32 isp_is_v_size;
+
+       u32 isp_is_max_dx;
+       u32 isp_is_max_dy;
+       u32 isp_is_displace;
+
+       u32 isp_is_h_offs_shd;
+       u32 isp_is_v_offs_shd;
+       u32 isp_is_h_size_shd;
+       u32 isp_is_v_size_shd;
+       u32 notused_ispis4[(0x2400 - 0x2334) / 4];
+
+       u32 isp_hist_prop;
+       u32 isp_hist_h_offs;
+       u32 isp_hist_v_offs;
+       u32 isp_hist_h_size;
+       u32 isp_hist_v_size;
+       u32 isp_hist_bin[MRV_ISP_HIST_BIN_ARR_SIZE];
+    u32 notused_isphist[(0x2500-0x2454)/4];
+
+       u32 isp_filt_mode;
+       u32 _notused_28[(0x2528 - 0x2504) / 4];
+       u32 isp_filt_thresh_bl0;
+       u32 isp_filt_thresh_bl1;
+       u32 isp_filt_thresh_sh0;
+       u32 isp_filt_thresh_sh1;
+       u32 isp_filt_lum_weight;
+       u32 isp_filt_fac_sh1;
+       u32 isp_filt_fac_sh0;
+       u32 isp_filt_fac_mid;
+       u32 isp_filt_fac_bl0;
+       u32 isp_filt_fac_bl1;
+       u32 notused_ispfilt[(0x2580 - 0x2550) / 4];
+
+       u32 notused_ispcac[(0x2600 - 0x2580) / 4];
+
+       u32 isp_exp_ctrl;
+       u32 isp_exp_h_offset;
+       u32 isp_exp_v_offset;
+       u32 isp_exp_h_size;
+       u32 isp_exp_v_size;
+       u32 isp_exp_mean_00;
+       u32 isp_exp_mean_10;
+       u32 isp_exp_mean_20;
+       u32 isp_exp_mean_30;
+       u32 isp_exp_mean_40;
+       u32 isp_exp_mean_01;
+       u32 isp_exp_mean_11;
+       u32 isp_exp_mean_21;
+       u32 isp_exp_mean_31;
+       u32 isp_exp_mean_41;
+       u32 isp_exp_mean_02;
+       u32 isp_exp_mean_12;
+       u32 isp_exp_mean_22;
+       u32 isp_exp_mean_32;
+       u32 isp_exp_mean_42;
+       u32 isp_exp_mean_03;
+       u32 isp_exp_mean_13;
+       u32 isp_exp_mean_23;
+       u32 isp_exp_mean_33;
+       u32 isp_exp_mean_43;
+       u32 isp_exp_mean_04;
+       u32 isp_exp_mean_14;
+       u32 isp_exp_mean_24;
+       u32 isp_exp_mean_34;
+       u32 isp_exp_mean_44;
+       u32 notused_ispexp[(0x2700 - 0x2678) / 4];
+
+       u32 isp_bls_ctrl;
+       u32 isp_bls_samples;
+       u32 isp_bls_h1_start;
+       u32 isp_bls_h1_stop;
+       u32 isp_bls_v1_start;
+       u32 isp_bls_v1_stop;
+       u32 isp_bls_h2_start;
+       u32 isp_bls_h2_stop;
+       u32 isp_bls_v2_start;
+       u32 isp_bls_v2_stop;
+       u32 isp_bls_a_fixed;
+       u32 isp_bls_b_fixed;
+       u32 isp_bls_c_fixed;
+       u32 isp_bls_d_fixed;
+       u32 isp_bls_a_measured;
+       u32 isp_bls_b_measured;
+       u32 isp_bls_c_measured;
+       u32 isp_bls_d_measured;
+       u32 notused_ispbls2[(0x2800 - 0x2748) / 4];
+};
+
+#define MRV_VI_CCLFDIS
+#define MRV_VI_CCLFDIS_MASK 0x00000004
+#define MRV_VI_CCLFDIS_SHIFT 2
+#define MRV_VI_CCLFDIS_ENABLE  0
+#define MRV_VI_CCLFDIS_DISABLE 1
+
+#define MRV_VI_CCLDISS
+#define MRV_VI_CCLDISS_MASK 0x00000002
+#define MRV_VI_CCLDISS_SHIFT 1
+
+#define MRV_REV_ID
+#define MRV_REV_ID_MASK 0xFFFFFFFF
+#define MRV_REV_ID_SHIFT 0
+
+#define MRV_VI_MIPI_CLK_ENABLE
+#define MRV_VI_MIPI_CLK_ENABLE_MASK 0x00000800
+#define MRV_VI_MIPI_CLK_ENABLE_SHIFT 11
+
+#define MRV_VI_SMIA_CLK_ENABLE
+#define MRV_VI_SMIA_CLK_ENABLE_MASK 0x00000400
+#define MRV_VI_SMIA_CLK_ENABLE_SHIFT 10
+#define MRV_VI_SIMP_CLK_ENABLE
+#define MRV_VI_SIMP_CLK_ENABLE_MASK 0x00000200
+#define MRV_VI_SIMP_CLK_ENABLE_SHIFT 9
+
+#define MRV_VI_IE_CLK_ENABLE
+#define MRV_VI_IE_CLK_ENABLE_MASK 0x00000100
+#define MRV_VI_IE_CLK_ENABLE_SHIFT 8
+
+#define MRV_VI_EMP_CLK_ENABLE_MASK 0
+#define MRV_VI_MI_CLK_ENABLE
+#define MRV_VI_MI_CLK_ENABLE_MASK 0x00000040
+#define MRV_VI_MI_CLK_ENABLE_SHIFT 6
+
+#define MRV_VI_JPEG_CLK_ENABLE
+#define MRV_VI_JPEG_CLK_ENABLE_MASK 0x00000020
+#define MRV_VI_JPEG_CLK_ENABLE_SHIFT 5
+#define MRV_VI_SRSZ_CLK_ENABLE
+#define MRV_VI_SRSZ_CLK_ENABLE_MASK 0x00000010
+#define MRV_VI_SRSZ_CLK_ENABLE_SHIFT 4
+
+#define MRV_VI_MRSZ_CLK_ENABLE
+#define MRV_VI_MRSZ_CLK_ENABLE_MASK 0x00000008
+#define MRV_VI_MRSZ_CLK_ENABLE_SHIFT 3
+#define MRV_VI_CP_CLK_ENABLE
+#define MRV_VI_CP_CLK_ENABLE_MASK 0x00000002
+#define MRV_VI_CP_CLK_ENABLE_SHIFT 1
+#define MRV_VI_ISP_CLK_ENABLE
+#define MRV_VI_ISP_CLK_ENABLE_MASK 0x00000001
+#define MRV_VI_ISP_CLK_ENABLE_SHIFT 0
+
+#define MRV_VI_ALL_CLK_ENABLE
+#define MRV_VI_ALL_CLK_ENABLE_MASK \
+(0 \
+| MRV_VI_MIPI_CLK_ENABLE_MASK \
+| MRV_VI_SMIA_CLK_ENABLE_MASK \
+| MRV_VI_SIMP_CLK_ENABLE_MASK \
+| MRV_VI_IE_CLK_ENABLE_MASK \
+| MRV_VI_EMP_CLK_ENABLE_MASK \
+| MRV_VI_MI_CLK_ENABLE_MASK \
+| MRV_VI_JPEG_CLK_ENABLE_MASK \
+| MRV_VI_SRSZ_CLK_ENABLE_MASK \
+| MRV_VI_MRSZ_CLK_ENABLE_MASK \
+| MRV_VI_CP_CLK_ENABLE_MASK \
+| MRV_VI_ISP_CLK_ENABLE_MASK \
+)
+#define MRV_VI_ALL_CLK_ENABLE_SHIFT 0
+
+#define MRV_VI_MIPI_SOFT_RST
+#define MRV_VI_MIPI_SOFT_RST_MASK 0x00000800
+#define MRV_VI_MIPI_SOFT_RST_SHIFT 11
+
+#define MRV_VI_SMIA_SOFT_RST
+#define MRV_VI_SMIA_SOFT_RST_MASK 0x00000400
+#define MRV_VI_SMIA_SOFT_RST_SHIFT 10
+#define MRV_VI_SIMP_SOFT_RST
+#define MRV_VI_SIMP_SOFT_RST_MASK 0x00000200
+#define MRV_VI_SIMP_SOFT_RST_SHIFT 9
+
+#define MRV_VI_IE_SOFT_RST
+#define MRV_VI_IE_SOFT_RST_MASK 0x00000100
+#define MRV_VI_IE_SOFT_RST_SHIFT 8
+#define MRV_VI_MARVIN_RST
+#define MRV_VI_MARVIN_RST_MASK 0x00000080
+#define MRV_VI_MARVIN_RST_SHIFT 7
+
+#define MRV_VI_EMP_SOFT_RST_MASK 0
+#define MRV_VI_MI_SOFT_RST
+#define MRV_VI_MI_SOFT_RST_MASK 0x00000040
+#define MRV_VI_MI_SOFT_RST_SHIFT 6
+
+#define MRV_VI_JPEG_SOFT_RST
+#define MRV_VI_JPEG_SOFT_RST_MASK 0x00000020
+#define MRV_VI_JPEG_SOFT_RST_SHIFT 5
+#define MRV_VI_SRSZ_SOFT_RST
+#define MRV_VI_SRSZ_SOFT_RST_MASK 0x00000010
+#define MRV_VI_SRSZ_SOFT_RST_SHIFT 4
+
+#define MRV_VI_MRSZ_SOFT_RST
+#define MRV_VI_MRSZ_SOFT_RST_MASK 0x00000008
+#define MRV_VI_MRSZ_SOFT_RST_SHIFT 3
+#define MRV_VI_YCS_SOFT_RST
+#define MRV_VI_YCS_SOFT_RST_MASK 0x00000004
+#define MRV_VI_YCS_SOFT_RST_SHIFT 2
+#define MRV_VI_CP_SOFT_RST
+#define MRV_VI_CP_SOFT_RST_MASK 0x00000002
+#define MRV_VI_CP_SOFT_RST_SHIFT 1
+#define MRV_VI_ISP_SOFT_RST
+#define MRV_VI_ISP_SOFT_RST_MASK 0x00000001
+#define MRV_VI_ISP_SOFT_RST_SHIFT 0
+
+#define MRV_VI_ALL_SOFT_RST
+#define MRV_VI_ALL_SOFT_RST_MASK \
+(0 \
+| MRV_VI_MIPI_SOFT_RST_MASK \
+| MRV_VI_SMIA_SOFT_RST_MASK \
+| MRV_VI_SIMP_SOFT_RST_MASK \
+| MRV_VI_IE_SOFT_RST_MASK \
+| MRV_VI_EMP_SOFT_RST_MASK \
+| MRV_VI_MI_SOFT_RST_MASK \
+| MRV_VI_JPEG_SOFT_RST_MASK \
+| MRV_VI_SRSZ_SOFT_RST_MASK \
+| MRV_VI_MRSZ_SOFT_RST_MASK \
+| MRV_VI_YCS_SOFT_RST_MASK \
+| MRV_VI_CP_SOFT_RST_MASK \
+| MRV_VI_ISP_SOFT_RST_MASK \
+)
+#define MRV_VI_ALL_SOFT_RST_SHIFT 0
+
+#define MRV_VI_DMA_SPMUX
+#define MRV_VI_DMA_SPMUX_MASK 0x00000800
+#define MRV_VI_DMA_SPMUX_SHIFT 11
+#define MRV_VI_DMA_SPMUX_CAM    0
+#define MRV_VI_DMA_SPMUX_DMA    1
+#define MRV_VI_DMA_IEMUX
+#define MRV_VI_DMA_IEMUX_MASK 0x00000400
+#define MRV_VI_DMA_IEMUX_SHIFT 10
+#define MRV_VI_DMA_IEMUX_CAM    0
+#define MRV_VI_DMA_IEMUX_DMA    1
+#define MRV_IF_SELECT
+#define MRV_IF_SELECT_MASK 0x00000300
+#define MRV_IF_SELECT_SHIFT 8
+#define MRV_IF_SELECT_PAR   0
+#define MRV_IF_SELECT_SMIA  1
+#define MRV_IF_SELECT_MIPI  2
+#define MRV_VI_DMA_SWITCH
+#define MRV_VI_DMA_SWITCH_MASK 0x00000070
+#define MRV_VI_DMA_SWITCH_SHIFT 4
+#define MRV_VI_DMA_SWITCH_SELF  0
+#define MRV_VI_DMA_SWITCH_SI    1
+#define MRV_VI_DMA_SWITCH_IE    2
+#define MRV_VI_DMA_SWITCH_JPG   3
+#define MRV_VI_CHAN_MODE
+#define MRV_VI_CHAN_MODE_MASK 0x0000000C
+#define MRV_VI_CHAN_MODE_SHIFT 2
+
+#define MRV_VI_CHAN_MODE_OFF     0x00
+#define MRV_VI_CHAN_MODE_Y       0xFF
+#define MRV_VI_CHAN_MODE_MP_RAW  0x01
+#define MRV_VI_CHAN_MODE_MP      0x01
+#define MRV_VI_CHAN_MODE_SP      0x02
+#define MRV_VI_CHAN_MODE_MP_SP   0x03
+
+#define MRV_VI_MP_MUX
+#define MRV_VI_MP_MUX_MASK 0x00000003
+#define MRV_VI_MP_MUX_SHIFT 0
+
+#define MRV_VI_MP_MUX_JPGDIRECT  0x00
+#define MRV_VI_MP_MUX_MP         0x01
+#define MRV_VI_MP_MUX_RAW        0x01
+#define MRV_VI_MP_MUX_JPEG       0x02
+
+#define MRV_IMGEFF_CFG_UPD
+#define MRV_IMGEFF_CFG_UPD_MASK 0x00000010
+#define MRV_IMGEFF_CFG_UPD_SHIFT 4
+#define MRV_IMGEFF_EFFECT_MODE
+#define MRV_IMGEFF_EFFECT_MODE_MASK 0x0000000E
+#define MRV_IMGEFF_EFFECT_MODE_SHIFT 1
+#define MRV_IMGEFF_EFFECT_MODE_GRAY      0
+#define MRV_IMGEFF_EFFECT_MODE_NEGATIVE  1
+#define MRV_IMGEFF_EFFECT_MODE_SEPIA     2
+#define MRV_IMGEFF_EFFECT_MODE_COLOR_SEL 3
+#define MRV_IMGEFF_EFFECT_MODE_EMBOSS    4
+#define MRV_IMGEFF_EFFECT_MODE_SKETCH    5
+#define MRV_IMGEFF_BYPASS_MODE
+#define MRV_IMGEFF_BYPASS_MODE_MASK 0x00000001
+#define MRV_IMGEFF_BYPASS_MODE_SHIFT 0
+#define MRV_IMGEFF_BYPASS_MODE_PROCESS  1
+#define MRV_IMGEFF_BYPASS_MODE_BYPASS   0
+
+#define MRV_IMGEFF_COLOR_THRESHOLD
+#define MRV_IMGEFF_COLOR_THRESHOLD_MASK 0x0000FF00
+#define MRV_IMGEFF_COLOR_THRESHOLD_SHIFT 8
+#define MRV_IMGEFF_COLOR_SELECTION
+#define MRV_IMGEFF_COLOR_SELECTION_MASK 0x00000007
+#define MRV_IMGEFF_COLOR_SELECTION_SHIFT 0
+#define MRV_IMGEFF_COLOR_SELECTION_RGB  0
+#define MRV_IMGEFF_COLOR_SELECTION_B    1
+#define MRV_IMGEFF_COLOR_SELECTION_G    2
+#define MRV_IMGEFF_COLOR_SELECTION_BG   3
+#define MRV_IMGEFF_COLOR_SELECTION_R    4
+#define MRV_IMGEFF_COLOR_SELECTION_BR   5
+#define MRV_IMGEFF_COLOR_SELECTION_GR   6
+#define MRV_IMGEFF_COLOR_SELECTION_BGR  7
+
+#define MRV_IMGEFF_EMB_COEF_21_EN
+#define MRV_IMGEFF_EMB_COEF_21_EN_MASK 0x00008000
+#define MRV_IMGEFF_EMB_COEF_21_EN_SHIFT 15
+#define MRV_IMGEFF_EMB_COEF_21
+#define MRV_IMGEFF_EMB_COEF_21_MASK 0x00007000
+#define MRV_IMGEFF_EMB_COEF_21_SHIFT 12
+
+#define MRV_IMGEFF_EMB_COEF_21_4
+#define MRV_IMGEFF_EMB_COEF_21_4_MASK 0x0000F000
+#define MRV_IMGEFF_EMB_COEF_21_4_SHIFT 12
+#define MRV_IMGEFF_EMB_COEF_13_EN
+#define MRV_IMGEFF_EMB_COEF_13_EN_MASK 0x00000800
+#define MRV_IMGEFF_EMB_COEF_13_EN_SHIFT 11
+#define MRV_IMGEFF_EMB_COEF_13
+#define MRV_IMGEFF_EMB_COEF_13_MASK 0x00000700
+#define MRV_IMGEFF_EMB_COEF_13_SHIFT 8
+
+#define MRV_IMGEFF_EMB_COEF_13_4
+#define MRV_IMGEFF_EMB_COEF_13_4_MASK 0x00000F00
+#define MRV_IMGEFF_EMB_COEF_13_4_SHIFT 8
+#define MRV_IMGEFF_EMB_COEF_12_EN
+#define MRV_IMGEFF_EMB_COEF_12_EN_MASK 0x00000080
+#define MRV_IMGEFF_EMB_COEF_12_EN_SHIFT 7
+#define MRV_IMGEFF_EMB_COEF_12
+#define MRV_IMGEFF_EMB_COEF_12_MASK 0x00000070
+#define MRV_IMGEFF_EMB_COEF_12_SHIFT 4
+
+#define MRV_IMGEFF_EMB_COEF_12_4
+#define MRV_IMGEFF_EMB_COEF_12_4_MASK 0x000000F0
+#define MRV_IMGEFF_EMB_COEF_12_4_SHIFT 4
+#define MRV_IMGEFF_EMB_COEF_11_EN
+#define MRV_IMGEFF_EMB_COEF_11_EN_MASK 0x00000008
+#define MRV_IMGEFF_EMB_COEF_11_EN_SHIFT 3
+#define MRV_IMGEFF_EMB_COEF_11
+#define MRV_IMGEFF_EMB_COEF_11_MASK 0x00000007
+#define MRV_IMGEFF_EMB_COEF_11_SHIFT 0
+
+#define MRV_IMGEFF_EMB_COEF_11_4
+#define MRV_IMGEFF_EMB_COEF_11_4_MASK 0x0000000F
+#define MRV_IMGEFF_EMB_COEF_11_4_SHIFT 0
+
+#define MRV_IMGEFF_EMB_COEF_32_EN
+#define MRV_IMGEFF_EMB_COEF_32_EN_MASK 0x00008000
+#define MRV_IMGEFF_EMB_COEF_32_EN_SHIFT 15
+#define MRV_IMGEFF_EMB_COEF_32
+#define MRV_IMGEFF_EMB_COEF_32_MASK 0x00007000
+#define MRV_IMGEFF_EMB_COEF_32_SHIFT 12
+
+#define MRV_IMGEFF_EMB_COEF_32_4
+#define MRV_IMGEFF_EMB_COEF_32_4_MASK 0x0000F000
+#define MRV_IMGEFF_EMB_COEF_32_4_SHIFT 12
+#define MRV_IMGEFF_EMB_COEF_31_EN
+#define MRV_IMGEFF_EMB_COEF_31_EN_MASK 0x00000800
+#define MRV_IMGEFF_EMB_COEF_31_EN_SHIFT 11
+#define MRV_IMGEFF_EMB_COEF_31
+#define MRV_IMGEFF_EMB_COEF_31_MASK 0x00000700
+#define MRV_IMGEFF_EMB_COEF_31_SHIFT 8
+
+#define MRV_IMGEFF_EMB_COEF_31_4
+#define MRV_IMGEFF_EMB_COEF_31_4_MASK 0x00000F00
+#define MRV_IMGEFF_EMB_COEF_31_4_SHIFT 8
+#define MRV_IMGEFF_EMB_COEF_23_EN
+#define MRV_IMGEFF_EMB_COEF_23_EN_MASK 0x00000080
+#define MRV_IMGEFF_EMB_COEF_23_EN_SHIFT 7
+#define MRV_IMGEFF_EMB_COEF_23
+#define MRV_IMGEFF_EMB_COEF_23_MASK 0x00000070
+#define MRV_IMGEFF_EMB_COEF_23_SHIFT 4
+
+#define MRV_IMGEFF_EMB_COEF_23_4
+#define MRV_IMGEFF_EMB_COEF_23_4_MASK 0x000000F0
+#define MRV_IMGEFF_EMB_COEF_23_4_SHIFT 4
+
+#define MRV_IMGEFF_EMB_COEF_22_EN
+#define MRV_IMGEFF_EMB_COEF_22_EN_MASK 0x00000008
+#define MRV_IMGEFF_EMB_COEF_22_EN_SHIFT 3
+#define MRV_IMGEFF_EMB_COEF_22
+#define MRV_IMGEFF_EMB_COEF_22_MASK 0x00000007
+#define MRV_IMGEFF_EMB_COEF_22_SHIFT 0
+
+#define MRV_IMGEFF_EMB_COEF_22_4
+#define MRV_IMGEFF_EMB_COEF_22_4_MASK 0x0000000F
+#define MRV_IMGEFF_EMB_COEF_22_4_SHIFT 0
+
+#define MRV_IMGEFF_SKET_COEF_13_EN
+#define MRV_IMGEFF_SKET_COEF_13_EN_MASK 0x00008000
+#define MRV_IMGEFF_SKET_COEF_13_EN_SHIFT 15
+#define MRV_IMGEFF_SKET_COEF_13
+#define MRV_IMGEFF_SKET_COEF_13_MASK 0x00007000
+#define MRV_IMGEFF_SKET_COEF_13_SHIFT 12
+
+#define MRV_IMGEFF_SKET_COEF_13_4
+#define MRV_IMGEFF_SKET_COEF_13_4_MASK 0x0000F000
+#define MRV_IMGEFF_SKET_COEF_13_4_SHIFT 12
+#define MRV_IMGEFF_SKET_COEF_12_EN
+#define MRV_IMGEFF_SKET_COEF_12_EN_MASK 0x00000800
+#define MRV_IMGEFF_SKET_COEF_12_EN_SHIFT 11
+#define MRV_IMGEFF_SKET_COEF_12
+#define MRV_IMGEFF_SKET_COEF_12_MASK 0x00000700
+#define MRV_IMGEFF_SKET_COEF_12_SHIFT 8
+
+#define MRV_IMGEFF_SKET_COEF_12_4
+#define MRV_IMGEFF_SKET_COEF_12_4_MASK 0x00000F00
+#define MRV_IMGEFF_SKET_COEF_12_4_SHIFT 8
+#define MRV_IMGEFF_SKET_COEF_11_EN
+#define MRV_IMGEFF_SKET_COEF_11_EN_MASK 0x00000080
+#define MRV_IMGEFF_SKET_COEF_11_EN_SHIFT 7
+#define MRV_IMGEFF_SKET_COEF_11
+#define MRV_IMGEFF_SKET_COEF_11_MASK 0x00000070
+#define MRV_IMGEFF_SKET_COEF_11_SHIFT 4
+
+#define MRV_IMGEFF_SKET_COEF_11_4
+#define MRV_IMGEFF_SKET_COEF_11_4_MASK 0x000000F0
+#define MRV_IMGEFF_SKET_COEF_11_4_SHIFT 4
+#define MRV_IMGEFF_EMB_COEF_33_EN
+#define MRV_IMGEFF_EMB_COEF_33_EN_MASK 0x00000008
+#define MRV_IMGEFF_EMB_COEF_33_EN_SHIFT 3
+#define MRV_IMGEFF_EMB_COEF_33
+#define MRV_IMGEFF_EMB_COEF_33_MASK 0x00000007
+#define MRV_IMGEFF_EMB_COEF_33_SHIFT 0
+
+#define MRV_IMGEFF_EMB_COEF_33_4
+#define MRV_IMGEFF_EMB_COEF_33_4_MASK 0x0000000F
+#define MRV_IMGEFF_EMB_COEF_33_4_SHIFT 0
+
+#define MRV_IMGEFF_SKET_COEF_31_EN
+#define MRV_IMGEFF_SKET_COEF_31_EN_MASK 0x00008000
+#define MRV_IMGEFF_SKET_COEF_31_EN_SHIFT 15
+#define MRV_IMGEFF_SKET_COEF_31
+#define MRV_IMGEFF_SKET_COEF_31_MASK 0x00007000
+#define MRV_IMGEFF_SKET_COEF_31_SHIFT 12
+
+#define MRV_IMGEFF_SKET_COEF_31_4
+#define MRV_IMGEFF_SKET_COEF_31_4_MASK 0x0000F000
+#define MRV_IMGEFF_SKET_COEF_31_4_SHIFT 12
+#define MRV_IMGEFF_SKET_COEF_23_EN
+#define MRV_IMGEFF_SKET_COEF_23_EN_MASK 0x00000800
+#define MRV_IMGEFF_SKET_COEF_23_EN_SHIFT 11
+#define MRV_IMGEFF_SKET_COEF_23
+#define MRV_IMGEFF_SKET_COEF_23_MASK 0x00000700
+#define MRV_IMGEFF_SKET_COEF_23_SHIFT 8
+
+#define MRV_IMGEFF_SKET_COEF_23_4
+#define MRV_IMGEFF_SKET_COEF_23_4_MASK 0x00000F00
+#define MRV_IMGEFF_SKET_COEF_23_4_SHIFT 8
+#define MRV_IMGEFF_SKET_COEF_22_EN
+#define MRV_IMGEFF_SKET_COEF_22_EN_MASK 0x00000080
+#define MRV_IMGEFF_SKET_COEF_22_EN_SHIFT 7
+#define MRV_IMGEFF_SKET_COEF_22
+#define MRV_IMGEFF_SKET_COEF_22_MASK 0x00000070
+#define MRV_IMGEFF_SKET_COEF_22_SHIFT 4
+
+#define MRV_IMGEFF_SKET_COEF_22_4
+#define MRV_IMGEFF_SKET_COEF_22_4_MASK 0x000000F0
+#define MRV_IMGEFF_SKET_COEF_22_4_SHIFT 4
+#define MRV_IMGEFF_SKET_COEF_21_EN
+#define MRV_IMGEFF_SKET_COEF_21_EN_MASK 0x00000008
+#define MRV_IMGEFF_SKET_COEF_21_EN_SHIFT 3
+#define MRV_IMGEFF_SKET_COEF_21
+#define MRV_IMGEFF_SKET_COEF_21_MASK 0x00000007
+#define MRV_IMGEFF_SKET_COEF_21_SHIFT 0
+
+#define MRV_IMGEFF_SKET_COEF_21_4
+#define MRV_IMGEFF_SKET_COEF_21_4_MASK 0x0000000F
+#define MRV_IMGEFF_SKET_COEF_21_4_SHIFT 0
+
+#define MRV_IMGEFF_SKET_COEF_33_EN
+#define MRV_IMGEFF_SKET_COEF_33_EN_MASK 0x00000080
+#define MRV_IMGEFF_SKET_COEF_33_EN_SHIFT 7
+#define MRV_IMGEFF_SKET_COEF_33
+#define MRV_IMGEFF_SKET_COEF_33_MASK 0x00000070
+#define MRV_IMGEFF_SKET_COEF_33_SHIFT 4
+
+#define MRV_IMGEFF_SKET_COEF_33_4
+#define MRV_IMGEFF_SKET_COEF_33_4_MASK 0x000000F0
+#define MRV_IMGEFF_SKET_COEF_33_4_SHIFT 4
+#define MRV_IMGEFF_SKET_COEF_32_EN
+#define MRV_IMGEFF_SKET_COEF_32_EN_MASK 0x00000008
+#define MRV_IMGEFF_SKET_COEF_32_EN_SHIFT 3
+#define MRV_IMGEFF_SKET_COEF_32
+#define MRV_IMGEFF_SKET_COEF_32_MASK 0x00000007
+#define MRV_IMGEFF_SKET_COEF_32_SHIFT 0
+
+#define MRV_IMGEFF_SKET_COEF_32_4
+#define MRV_IMGEFF_SKET_COEF_32_4_MASK 0x0000000F
+#define MRV_IMGEFF_SKET_COEF_32_4_SHIFT 0
+
+#define MRV_IMGEFF_INCR_CR
+#define MRV_IMGEFF_INCR_CR_MASK 0x0000FF00
+#define MRV_IMGEFF_INCR_CR_SHIFT 8
+#define MRV_IMGEFF_INCR_CB
+#define MRV_IMGEFF_INCR_CB_MASK 0x000000FF
+#define MRV_IMGEFF_INCR_CB_SHIFT 0
+
+#define MRV_IMGEFF_EFFECT_MODE_SHD
+#define MRV_IMGEFF_EFFECT_MODE_SHD_MASK 0x0000000E
+#define MRV_IMGEFF_EFFECT_MODE_SHD_SHIFT 1
+
+#define MRV_SI_TRANSPARENCY_MODE
+#define MRV_SI_TRANSPARENCY_MODE_MASK 0x00000004
+#define MRV_SI_TRANSPARENCY_MODE_SHIFT 2
+#define MRV_SI_TRANSPARENCY_MODE_DISABLED 1
+#define MRV_SI_TRANSPARENCY_MODE_ENABLED  0
+#define MRV_SI_REF_IMAGE
+#define MRV_SI_REF_IMAGE_MASK 0x00000002
+#define MRV_SI_REF_IMAGE_SHIFT 1
+#define MRV_SI_REF_IMAGE_MEM   1
+#define MRV_SI_REF_IMAGE_IE    0
+#define MRV_SI_BYPASS_MODE
+#define MRV_SI_BYPASS_MODE_MASK 0x00000001
+#define MRV_SI_BYPASS_MODE_SHIFT 0
+#define MRV_SI_BYPASS_MODE_BYPASS  0
+#define MRV_SI_BYPASS_MODE_PROCESS 1
+
+#define MRV_SI_OFFSET_X
+#define MRV_SI_OFFSET_X_MASK 0x00001FFE
+#define MRV_SI_OFFSET_X_SHIFT 0
+#define MRV_SI_OFFSET_X_MAX  0x00001FFE
+
+#define MRV_SI_OFFSET_Y
+#define MRV_SI_OFFSET_Y_MASK 0x00000FFF
+#define MRV_SI_OFFSET_Y_SHIFT 0
+#define MRV_SI_OFFSET_Y_MAX  0x00000FFF
+
+#define MRV_SI_Y_COMP
+#define MRV_SI_Y_COMP_MASK 0x000000FF
+#define MRV_SI_Y_COMP_SHIFT 0
+
+#define MRV_SI_CB_COMP
+#define MRV_SI_CB_COMP_MASK 0x000000FF
+#define MRV_SI_CB_COMP_SHIFT 0
+
+#define MRV_SI_CR_COMP
+#define MRV_SI_CR_COMP_MASK 0x000000FF
+#define MRV_SI_CR_COMP_SHIFT 0
+
+#define MRV_ISP_ISP_CSM_C_RANGE
+#define MRV_ISP_ISP_CSM_C_RANGE_MASK 0x00004000
+#define MRV_ISP_ISP_CSM_C_RANGE_SHIFT 14
+#define MRV_ISP_ISP_CSM_C_RANGE_BT601  0
+#define MRV_ISP_ISP_CSM_C_RANGE_FULL   1
+
+#define MRV_ISP_ISP_CSM_Y_RANGE
+#define MRV_ISP_ISP_CSM_Y_RANGE_MASK 0x00002000
+#define MRV_ISP_ISP_CSM_Y_RANGE_SHIFT 13
+#define MRV_ISP_ISP_CSM_Y_RANGE_BT601  0
+#define MRV_ISP_ISP_CSM_Y_RANGE_FULL   1
+#define MRV_ISP_ISP_FLASH_MODE
+#define MRV_ISP_ISP_FLASH_MODE_MASK 0x00001000
+#define MRV_ISP_ISP_FLASH_MODE_SHIFT 12
+#define MRV_ISP_ISP_FLASH_MODE_INDEP  0
+#define MRV_ISP_ISP_FLASH_MODE_SYNC   1
+#define MRV_ISP_ISP_GAMMA_OUT_ENABLE
+#define MRV_ISP_ISP_GAMMA_OUT_ENABLE_MASK 0x00000800
+#define MRV_ISP_ISP_GAMMA_OUT_ENABLE_SHIFT 11
+
+#define MRV_ISP_ISP_GEN_CFG_UPD
+#define MRV_ISP_ISP_GEN_CFG_UPD_MASK 0x00000400
+#define MRV_ISP_ISP_GEN_CFG_UPD_SHIFT 10
+
+#define MRV_ISP_ISP_CFG_UPD
+#define MRV_ISP_ISP_CFG_UPD_MASK 0x00000200
+#define MRV_ISP_ISP_CFG_UPD_SHIFT 9
+
+#define MRV_ISP_ISP_AWB_ENABLE
+#define MRV_ISP_ISP_AWB_ENABLE_MASK 0x00000080
+#define MRV_ISP_ISP_AWB_ENABLE_SHIFT 7
+#define MRV_ISP_ISP_GAMMA_IN_ENABLE
+#define MRV_ISP_ISP_GAMMA_IN_ENABLE_MASK 0x00000040
+#define MRV_ISP_ISP_GAMMA_IN_ENABLE_SHIFT 6
+
+#define MRV_ISP_ISP_INFORM_ENABLE
+#define MRV_ISP_ISP_INFORM_ENABLE_MASK 0x00000010
+#define MRV_ISP_ISP_INFORM_ENABLE_SHIFT 4
+#define MRV_ISP_ISP_MODE
+#define MRV_ISP_ISP_MODE_MASK 0x0000000E
+#define MRV_ISP_ISP_MODE_SHIFT 1
+#define MRV_ISP_ISP_MODE_RAW    0
+#define MRV_ISP_ISP_MODE_656    1
+#define MRV_ISP_ISP_MODE_601    2
+#define MRV_ISP_ISP_MODE_RGB    3
+#define MRV_ISP_ISP_MODE_DATA   4
+#define MRV_ISP_ISP_MODE_RGB656 5
+#define MRV_ISP_ISP_MODE_RAW656 6
+#define MRV_ISP_ISP_ENABLE
+#define MRV_ISP_ISP_ENABLE_MASK 0x00000001
+#define MRV_ISP_ISP_ENABLE_SHIFT 0
+
+#define MRV_ISP_INPUT_SELECTION
+#define MRV_ISP_INPUT_SELECTION_MASK 0x00007000
+#define MRV_ISP_INPUT_SELECTION_SHIFT 12
+#define MRV_ISP_INPUT_SELECTION_12EXT  0
+#define MRV_ISP_INPUT_SELECTION_10ZERO 1
+#define MRV_ISP_INPUT_SELECTION_10MSB  2
+#define MRV_ISP_INPUT_SELECTION_8ZERO  3
+#define MRV_ISP_INPUT_SELECTION_8MSB   4
+#define MRV_ISP_FIELD_SELECTION
+#define MRV_ISP_FIELD_SELECTION_MASK 0x00000600
+#define MRV_ISP_FIELD_SELECTION_SHIFT 9
+#define MRV_ISP_FIELD_SELECTION_BOTH  0
+#define MRV_ISP_FIELD_SELECTION_EVEN  1
+#define MRV_ISP_FIELD_SELECTION_ODD   2
+#define MRV_ISP_CCIR_SEQ
+#define MRV_ISP_CCIR_SEQ_MASK 0x00000180
+#define MRV_ISP_CCIR_SEQ_SHIFT 7
+#define MRV_ISP_CCIR_SEQ_YCBYCR 0
+#define MRV_ISP_CCIR_SEQ_YCRYCB 1
+#define MRV_ISP_CCIR_SEQ_CBYCRY 2
+#define MRV_ISP_CCIR_SEQ_CRYCBY 3
+#define MRV_ISP_CONV_422
+#define MRV_ISP_CONV_422_MASK 0x00000060
+#define MRV_ISP_CONV_422_SHIFT  5
+#define MRV_ISP_CONV_422_CO     0
+#define MRV_ISP_CONV_422_INTER  1
+#define MRV_ISP_CONV_422_NONCO  2
+#define MRV_ISP_BAYER_PAT
+#define MRV_ISP_BAYER_PAT_MASK 0x00000018
+#define MRV_ISP_BAYER_PAT_SHIFT 3
+#define MRV_ISP_BAYER_PAT_RG    0
+#define MRV_ISP_BAYER_PAT_GR    1
+#define MRV_ISP_BAYER_PAT_GB    2
+#define MRV_ISP_BAYER_PAT_BG    3
+#define MRV_ISP_VSYNC_POL
+#define MRV_ISP_VSYNC_POL_MASK 0x00000004
+#define MRV_ISP_VSYNC_POL_SHIFT 2
+#define MRV_ISP_HSYNC_POL
+#define MRV_ISP_HSYNC_POL_MASK 0x00000002
+#define MRV_ISP_HSYNC_POL_SHIFT 1
+#define MRV_ISP_SAMPLE_EDGE
+#define MRV_ISP_SAMPLE_EDGE_MASK 0x00000001
+#define MRV_ISP_SAMPLE_EDGE_SHIFT 0
+
+#define MRV_ISP_ACQ_H_OFFS
+#define MRV_ISP_ACQ_H_OFFS_MASK 0x00003FFF
+#define MRV_ISP_ACQ_H_OFFS_SHIFT 0
+
+#define MRV_ISP_ACQ_V_OFFS
+#define MRV_ISP_ACQ_V_OFFS_MASK 0x00000FFF
+#define MRV_ISP_ACQ_V_OFFS_SHIFT 0
+
+#define MRV_ISP_ACQ_H_SIZE
+#define MRV_ISP_ACQ_H_SIZE_MASK 0x00003FFF
+#define MRV_ISP_ACQ_H_SIZE_SHIFT 0
+
+#define MRV_ISP_ACQ_V_SIZE
+#define MRV_ISP_ACQ_V_SIZE_MASK 0x00000FFF
+#define MRV_ISP_ACQ_V_SIZE_SHIFT 0
+
+
+#define MRV_ISP_ACQ_NR_FRAMES
+#define MRV_ISP_ACQ_NR_FRAMES_MASK 0x000003FF
+#define MRV_ISP_ACQ_NR_FRAMES_SHIFT 0
+#define MRV_ISP_ACQ_NR_FRAMES_MAX \
+       (MRV_ISP_ACQ_NR_FRAMES_MASK >> MRV_ISP_ACQ_NR_FRAMES_SHIFT)
+
+#define MRV_ISP_GAMMA_DX_8
+#define MRV_ISP_GAMMA_DX_8_MASK 0x70000000
+#define MRV_ISP_GAMMA_DX_8_SHIFT 28
+
+#define MRV_ISP_GAMMA_DX_7
+#define MRV_ISP_GAMMA_DX_7_MASK 0x07000000
+#define MRV_ISP_GAMMA_DX_7_SHIFT 24
+
+#define MRV_ISP_GAMMA_DX_6
+#define MRV_ISP_GAMMA_DX_6_MASK 0x00700000
+#define MRV_ISP_GAMMA_DX_6_SHIFT 20
+
+#define MRV_ISP_GAMMA_DX_5
+#define MRV_ISP_GAMMA_DX_5_MASK 0x00070000
+#define MRV_ISP_GAMMA_DX_5_SHIFT 16
+
+#define MRV_ISP_GAMMA_DX_4
+#define MRV_ISP_GAMMA_DX_4_MASK 0x00007000
+#define MRV_ISP_GAMMA_DX_4_SHIFT 12
+
+#define MRV_ISP_GAMMA_DX_3
+#define MRV_ISP_GAMMA_DX_3_MASK 0x00000700
+#define MRV_ISP_GAMMA_DX_3_SHIFT 8
+
+#define MRV_ISP_GAMMA_DX_2
+#define MRV_ISP_GAMMA_DX_2_MASK 0x00000070
+#define MRV_ISP_GAMMA_DX_2_SHIFT 4
+
+#define MRV_ISP_GAMMA_DX_1
+#define MRV_ISP_GAMMA_DX_1_MASK 0x00000007
+#define MRV_ISP_GAMMA_DX_1_SHIFT 0
+
+#define MRV_ISP_GAMMA_DX_16
+#define MRV_ISP_GAMMA_DX_16_MASK 0x70000000
+#define MRV_ISP_GAMMA_DX_16_SHIFT 28
+
+#define MRV_ISP_GAMMA_DX_15
+#define MRV_ISP_GAMMA_DX_15_MASK 0x07000000
+#define MRV_ISP_GAMMA_DX_15_SHIFT 24
+
+#define MRV_ISP_GAMMA_DX_14
+#define MRV_ISP_GAMMA_DX_14_MASK 0x00700000
+#define MRV_ISP_GAMMA_DX_14_SHIFT 20
+
+#define MRV_ISP_GAMMA_DX_13
+#define MRV_ISP_GAMMA_DX_13_MASK 0x00070000
+#define MRV_ISP_GAMMA_DX_13_SHIFT 16
+
+#define MRV_ISP_GAMMA_DX_12
+#define MRV_ISP_GAMMA_DX_12_MASK 0x00007000
+#define MRV_ISP_GAMMA_DX_12_SHIFT 12
+
+#define MRV_ISP_GAMMA_DX_11
+#define MRV_ISP_GAMMA_DX_11_MASK 0x00000700
+#define MRV_ISP_GAMMA_DX_11_SHIFT 8
+
+#define MRV_ISP_GAMMA_DX_10
+#define MRV_ISP_GAMMA_DX_10_MASK 0x00000070
+#define MRV_ISP_GAMMA_DX_10_SHIFT 4
+
+#define MRV_ISP_GAMMA_DX_9
+#define MRV_ISP_GAMMA_DX_9_MASK 0x00000007
+#define MRV_ISP_GAMMA_DX_9_SHIFT 0
+
+#define MRV_ISP_GAMMA_Y
+
+#define MRV_ISP_GAMMA_Y_MASK 0x00000FFF
+
+#define MRV_ISP_GAMMA_Y_SHIFT 0
+#define MRV_ISP_GAMMA_Y_MAX (MRV_ISP_GAMMA_Y_MASK >> MRV_ISP_GAMMA_Y_SHIFT)
+
+#define MRV_ISP_GAMMA_R_Y
+#define MRV_ISP_GAMMA_R_Y_MASK  MRV_ISP_GAMMA_Y_MASK
+#define MRV_ISP_GAMMA_R_Y_SHIFT MRV_ISP_GAMMA_Y_SHIFT
+
+#define MRV_ISP_GAMMA_G_Y
+#define MRV_ISP_GAMMA_G_Y_MASK  MRV_ISP_GAMMA_Y_MASK
+#define MRV_ISP_GAMMA_G_Y_SHIFT MRV_ISP_GAMMA_Y_SHIFT
+
+#define MRV_ISP_GAMMA_B_Y
+#define MRV_ISP_GAMMA_B_Y_MASK  MRV_ISP_GAMMA_Y_MASK
+#define MRV_ISP_GAMMA_B_Y_SHIFT MRV_ISP_GAMMA_Y_SHIFT
+
+#define MRV_ISP_AWB_MEAS_MODE
+#define MRV_ISP_AWB_MEAS_MODE_MASK 0x80000000
+#define MRV_ISP_AWB_MEAS_MODE_SHIFT 31
+#define MRV_ISP_AWB_MAX_EN
+#define MRV_ISP_AWB_MAX_EN_MASK 0x00000004
+#define MRV_ISP_AWB_MAX_EN_SHIFT 2
+#define MRV_ISP_AWB_MODE
+#define MRV_ISP_AWB_MODE_MASK 0x00000003
+#define MRV_ISP_AWB_MODE_SHIFT 0
+#define MRV_ISP_AWB_MODE_MEAS   2
+#define MRV_ISP_AWB_MODE_NOMEAS 0
+
+#define MRV_ISP_AWB_H_OFFS
+#define MRV_ISP_AWB_H_OFFS_MASK 0x00000FFF
+#define MRV_ISP_AWB_H_OFFS_SHIFT 0
+
+#define MRV_ISP_AWB_V_OFFS
+#define MRV_ISP_AWB_V_OFFS_MASK 0x00000FFF
+#define MRV_ISP_AWB_V_OFFS_SHIFT 0
+
+#define MRV_ISP_AWB_H_SIZE
+#define MRV_ISP_AWB_H_SIZE_MASK 0x00001FFF
+#define MRV_ISP_AWB_H_SIZE_SHIFT 0
+
+#define MRV_ISP_AWB_V_SIZE
+#define MRV_ISP_AWB_V_SIZE_MASK 0x00000FFF
+#define MRV_ISP_AWB_V_SIZE_SHIFT 0
+
+#define MRV_ISP_AWB_FRAMES
+#define MRV_ISP_AWB_FRAMES_MASK 0x00000007
+#define MRV_ISP_AWB_FRAMES_SHIFT 0
+
+#define MRV_ISP_AWB_REF_CR__MAX_R
+#define MRV_ISP_AWB_REF_CR__MAX_R_MASK 0x0000FF00
+#define MRV_ISP_AWB_REF_CR__MAX_R_SHIFT 8
+#define MRV_ISP_AWB_REF_CB__MAX_B
+#define MRV_ISP_AWB_REF_CB__MAX_B_MASK 0x000000FF
+#define MRV_ISP_AWB_REF_CB__MAX_B_SHIFT 0
+
+#define MRV_ISP_AWB_MAX_Y
+#define MRV_ISP_AWB_MAX_Y_MASK 0xFF000000
+#define MRV_ISP_AWB_MAX_Y_SHIFT 24
+
+#define MRV_ISP_AWB_MIN_Y__MAX_G
+#define MRV_ISP_AWB_MIN_Y__MAX_G_MASK 0x00FF0000
+#define MRV_ISP_AWB_MIN_Y__MAX_G_SHIFT 16
+
+#define MRV_ISP_AWB_MAX_CSUM
+#define MRV_ISP_AWB_MAX_CSUM_MASK 0x0000FF00
+#define MRV_ISP_AWB_MAX_CSUM_SHIFT 8
+#define MRV_ISP_AWB_MIN_C
+#define MRV_ISP_AWB_MIN_C_MASK 0x000000FF
+#define MRV_ISP_AWB_MIN_C_SHIFT 0
+
+#define MRV_ISP_AWB_GAIN_GR
+#define MRV_ISP_AWB_GAIN_GR_MASK 0x03FF0000
+#define MRV_ISP_AWB_GAIN_GR_SHIFT 16
+#define MRV_ISP_AWB_GAIN_GR_MAX  (MRV_ISP_AWB_GAIN_GR_MASK >> \
+                                 MRV_ISP_AWB_GAIN_GR_SHIFT)
+#define MRV_ISP_AWB_GAIN_GB
+#define MRV_ISP_AWB_GAIN_GB_MASK 0x000003FF
+#define MRV_ISP_AWB_GAIN_GB_SHIFT 0
+#define MRV_ISP_AWB_GAIN_GB_MAX  (MRV_ISP_AWB_GAIN_GB_MASK >> \
+                                 MRV_ISP_AWB_GAIN_GB_SHIFT)
+
+#define MRV_ISP_AWB_GAIN_R
+#define MRV_ISP_AWB_GAIN_R_MASK 0x03FF0000
+#define MRV_ISP_AWB_GAIN_R_SHIFT 16
+#define MRV_ISP_AWB_GAIN_R_MAX  (MRV_ISP_AWB_GAIN_R_MASK >> \
+                                MRV_ISP_AWB_GAIN_R_SHIFT)
+#define MRV_ISP_AWB_GAIN_B
+#define MRV_ISP_AWB_GAIN_B_MASK 0x000003FF
+#define MRV_ISP_AWB_GAIN_B_SHIFT 0
+#define MRV_ISP_AWB_GAIN_B_MAX  (MRV_ISP_AWB_GAIN_B_MASK >> \
+                                MRV_ISP_AWB_GAIN_B_SHIFT)
+
+#define MRV_ISP_AWB_WHITE_CNT
+#define MRV_ISP_AWB_WHITE_CNT_MASK 0x03FFFFFF
+#define MRV_ISP_AWB_WHITE_CNT_SHIFT 0
+
+#define MRV_ISP_AWB_MEAN_Y__G
+#define MRV_ISP_AWB_MEAN_Y__G_MASK 0x00FF0000
+#define MRV_ISP_AWB_MEAN_Y__G_SHIFT 16
+#define MRV_ISP_AWB_MEAN_CB__B
+#define MRV_ISP_AWB_MEAN_CB__B_MASK 0x0000FF00
+#define MRV_ISP_AWB_MEAN_CB__B_SHIFT 8
+#define MRV_ISP_AWB_MEAN_CR__R
+#define MRV_ISP_AWB_MEAN_CR__R_MASK 0x000000FF
+#define MRV_ISP_AWB_MEAN_CR__R_SHIFT 0
+
+#define MRV_ISP_CC_COEFF_0
+#define MRV_ISP_CC_COEFF_0_MASK 0x000001FF
+#define MRV_ISP_CC_COEFF_0_SHIFT 0
+
+#define MRV_ISP_CC_COEFF_1
+#define MRV_ISP_CC_COEFF_1_MASK 0x000001FF
+#define MRV_ISP_CC_COEFF_1_SHIFT 0
+
+#define MRV_ISP_CC_COEFF_2
+#define MRV_ISP_CC_COEFF_2_MASK 0x000001FF
+#define MRV_ISP_CC_COEFF_2_SHIFT 0
+
+#define MRV_ISP_CC_COEFF_3
+#define MRV_ISP_CC_COEFF_3_MASK 0x000001FF
+#define MRV_ISP_CC_COEFF_3_SHIFT 0
+
+#define MRV_ISP_CC_COEFF_4
+#define MRV_ISP_CC_COEFF_4_MASK 0x000001FF
+#define MRV_ISP_CC_COEFF_4_SHIFT 0
+
+#define MRV_ISP_CC_COEFF_5
+#define MRV_ISP_CC_COEFF_5_MASK 0x000001FF
+#define MRV_ISP_CC_COEFF_5_SHIFT 0
+
+#define MRV_ISP_CC_COEFF_6
+#define MRV_ISP_CC_COEFF_6_MASK 0x000001FF
+#define MRV_ISP_CC_COEFF_6_SHIFT 0
+
+#define MRV_ISP_CC_COEFF_7
+#define MRV_ISP_CC_COEFF_7_MASK 0x000001FF
+#define MRV_ISP_CC_COEFF_7_SHIFT 0
+
+#define MRV_ISP_CC_COEFF_8
+#define MRV_ISP_CC_COEFF_8_MASK 0x000001FF
+#define MRV_ISP_CC_COEFF_8_SHIFT 0
+
+#define MRV_ISP_ISP_OUT_H_OFFS
+#define MRV_ISP_ISP_OUT_H_OFFS_MASK 0x00000FFF
+#define MRV_ISP_ISP_OUT_H_OFFS_SHIFT 0
+
+#define MRV_ISP_ISP_OUT_V_OFFS
+#define MRV_ISP_ISP_OUT_V_OFFS_MASK 0x00000FFF
+#define MRV_ISP_ISP_OUT_V_OFFS_SHIFT 0
+
+#define MRV_ISP_ISP_OUT_H_SIZE
+#define MRV_ISP_ISP_OUT_H_SIZE_MASK 0x00003FFF
+#define MRV_ISP_ISP_OUT_H_SIZE_SHIFT 0
+
+#define MRV_ISP_ISP_OUT_V_SIZE
+#define MRV_ISP_ISP_OUT_V_SIZE_MASK 0x00000FFF
+#define MRV_ISP_ISP_OUT_V_SIZE_SHIFT 0
+
+#define MRV_ISP_DEMOSAIC_BYPASS
+#define MRV_ISP_DEMOSAIC_BYPASS_MASK 0x00000400
+#define MRV_ISP_DEMOSAIC_BYPASS_SHIFT 10
+
+#define MRV_ISP_DEMOSAIC_MODE
+#define MRV_ISP_DEMOSAIC_MODE_MASK  0x00000300
+#define MRV_ISP_DEMOSAIC_MODE_SHIFT 8
+#define MRV_ISP_DEMOSAIC_MODE_STD   0
+#define MRV_ISP_DEMOSAIC_MODE_ENH   1
+#define MRV_ISP_DEMOSAIC_TH
+#define MRV_ISP_DEMOSAIC_TH_MASK 0x000000FF
+#define MRV_ISP_DEMOSAIC_TH_SHIFT 0
+
+#define MRV_ISP_S_HSYNC
+#define MRV_ISP_S_HSYNC_MASK 0x80000000
+#define MRV_ISP_S_HSYNC_SHIFT 31
+
+#define MRV_ISP_S_VSYNC
+#define MRV_ISP_S_VSYNC_MASK 0x40000000
+#define MRV_ISP_S_VSYNC_SHIFT 30
+
+#define MRV_ISP_S_DATA
+#define MRV_ISP_S_DATA_MASK 0x0FFF0000
+#define MRV_ISP_S_DATA_SHIFT 16
+
+#define MRV_ISP_INFORM_FIELD
+#define MRV_ISP_INFORM_FIELD_MASK 0x00000004
+#define MRV_ISP_INFORM_FIELD_SHIFT 2
+#define MRV_ISP_INFORM_FIELD_ODD   0
+#define MRV_ISP_INFORM_FIELD_EVEN  1
+#define MRV_ISP_INFORM_EN_SHD
+#define MRV_ISP_INFORM_EN_SHD_MASK 0x00000002
+#define MRV_ISP_INFORM_EN_SHD_SHIFT 1
+#define MRV_ISP_ISP_ON_SHD
+#define MRV_ISP_ISP_ON_SHD_MASK 0x00000001
+#define MRV_ISP_ISP_ON_SHD_SHIFT 0
+
+#define MRV_ISP_ISP_OUT_H_OFFS_SHD
+#define MRV_ISP_ISP_OUT_H_OFFS_SHD_MASK 0x00000FFF
+#define MRV_ISP_ISP_OUT_H_OFFS_SHD_SHIFT 0
+
+#define MRV_ISP_ISP_OUT_V_OFFS_SHD
+#define MRV_ISP_ISP_OUT_V_OFFS_SHD_MASK 0x00000FFF
+#define MRV_ISP_ISP_OUT_V_OFFS_SHD_SHIFT 0
+
+#define MRV_ISP_ISP_OUT_H_SIZE_SHD
+#define MRV_ISP_ISP_OUT_H_SIZE_SHD_MASK 0x00003FFF
+#define MRV_ISP_ISP_OUT_H_SIZE_SHD_SHIFT 0
+
+#define MRV_ISP_ISP_OUT_V_SIZE_SHD
+#define MRV_ISP_ISP_OUT_V_SIZE_SHD_MASK 0x00000FFF
+#define MRV_ISP_ISP_OUT_V_SIZE_SHD_SHIFT 0
+
+#define MRV_ISP_IMSC_EXP_END
+#define MRV_ISP_IMSC_EXP_END_MASK 0x00040000
+#define MRV_ISP_IMSC_EXP_END_SHIFT 18
+
+#define MRV_ISP_IMSC_FLASH_CAP
+#define MRV_ISP_IMSC_FLASH_CAP_MASK 0x00020000
+#define MRV_ISP_IMSC_FLASH_CAP_SHIFT 17
+
+#define MRV_ISP_IMSC_BP_DET
+#define MRV_ISP_IMSC_BP_DET_MASK 0x00010000
+#define MRV_ISP_IMSC_BP_DET_SHIFT 16
+#define MRV_ISP_IMSC_BP_NEW_TAB_FUL
+#define MRV_ISP_IMSC_BP_NEW_TAB_FUL_MASK 0x00008000
+#define MRV_ISP_IMSC_BP_NEW_TAB_FUL_SHIFT 15
+#define MRV_ISP_IMSC_AFM_FIN
+#define MRV_ISP_IMSC_AFM_FIN_MASK 0x00004000
+#define MRV_ISP_IMSC_AFM_FIN_SHIFT 14
+#define MRV_ISP_IMSC_AFM_LUM_OF
+#define MRV_ISP_IMSC_AFM_LUM_OF_MASK 0x00002000
+#define MRV_ISP_IMSC_AFM_LUM_OF_SHIFT 13
+#define MRV_ISP_IMSC_AFM_SUM_OF
+#define MRV_ISP_IMSC_AFM_SUM_OF_MASK 0x00001000
+#define MRV_ISP_IMSC_AFM_SUM_OF_SHIFT 12
+#define MRV_ISP_IMSC_SHUTTER_OFF
+#define MRV_ISP_IMSC_SHUTTER_OFF_MASK 0x00000800
+#define MRV_ISP_IMSC_SHUTTER_OFF_SHIFT 11
+#define MRV_ISP_IMSC_SHUTTER_ON
+#define MRV_ISP_IMSC_SHUTTER_ON_MASK 0x00000400
+#define MRV_ISP_IMSC_SHUTTER_ON_SHIFT 10
+#define MRV_ISP_IMSC_FLASH_OFF
+#define MRV_ISP_IMSC_FLASH_OFF_MASK 0x00000200
+#define MRV_ISP_IMSC_FLASH_OFF_SHIFT 9
+#define MRV_ISP_IMSC_FLASH_ON
+#define MRV_ISP_IMSC_FLASH_ON_MASK 0x00000100
+#define MRV_ISP_IMSC_FLASH_ON_SHIFT 8
+
+#define MRV_ISP_IMSC_H_START
+#define MRV_ISP_IMSC_H_START_MASK 0x00000080
+#define MRV_ISP_IMSC_H_START_SHIFT 7
+#define MRV_ISP_IMSC_V_START
+#define MRV_ISP_IMSC_V_START_MASK 0x00000040
+#define MRV_ISP_IMSC_V_START_SHIFT 6
+#define MRV_ISP_IMSC_FRAME_IN
+#define MRV_ISP_IMSC_FRAME_IN_MASK 0x00000020
+#define MRV_ISP_IMSC_FRAME_IN_SHIFT 5
+#define MRV_ISP_IMSC_AWB_DONE
+#define MRV_ISP_IMSC_AWB_DONE_MASK 0x00000010
+#define MRV_ISP_IMSC_AWB_DONE_SHIFT 4
+#define MRV_ISP_IMSC_PIC_SIZE_ERR
+#define MRV_ISP_IMSC_PIC_SIZE_ERR_MASK 0x00000008
+#define MRV_ISP_IMSC_PIC_SIZE_ERR_SHIFT 3
+#define MRV_ISP_IMSC_DATA_LOSS
+#define MRV_ISP_IMSC_DATA_LOSS_MASK 0x00000004
+#define MRV_ISP_IMSC_DATA_LOSS_SHIFT 2
+#define MRV_ISP_IMSC_FRAME
+#define MRV_ISP_IMSC_FRAME_MASK 0x00000002
+#define MRV_ISP_IMSC_FRAME_SHIFT 1
+#define MRV_ISP_IMSC_ISP_OFF
+#define MRV_ISP_IMSC_ISP_OFF_MASK 0x00000001
+#define MRV_ISP_IMSC_ISP_OFF_SHIFT 0
+
+#define MRV_ISP_IMSC_ALL
+#define MRV_ISP_IMSC_ALL_MASK \
+(0 \
+| MRV_ISP_IMSC_EXP_END_MASK \
+| MRV_ISP_IMSC_FLASH_CAP_MASK \
+| MRV_ISP_IMSC_BP_DET_MASK \
+| MRV_ISP_IMSC_BP_NEW_TAB_FUL_MASK \
+| MRV_ISP_IMSC_AFM_FIN_MASK \
+| MRV_ISP_IMSC_AFM_LUM_OF_MASK \
+| MRV_ISP_IMSC_AFM_SUM_OF_MASK \
+| MRV_ISP_IMSC_SHUTTER_OFF_MASK \
+| MRV_ISP_IMSC_SHUTTER_ON_MASK \
+| MRV_ISP_IMSC_FLASH_OFF_MASK \
+| MRV_ISP_IMSC_FLASH_ON_MASK \
+| MRV_ISP_IMSC_H_START_MASK \
+| MRV_ISP_IMSC_V_START_MASK \
+| MRV_ISP_IMSC_FRAME_IN_MASK \
+| MRV_ISP_IMSC_AWB_DONE_MASK \
+| MRV_ISP_IMSC_PIC_SIZE_ERR_MASK \
+| MRV_ISP_IMSC_DATA_LOSS_MASK \
+| MRV_ISP_IMSC_FRAME_MASK \
+| MRV_ISP_IMSC_ISP_OFF_MASK \
+)
+#define MRV_ISP_IMSC_ALL_SHIFT 0
+
+#define MRV_ISP_RIS_EXP_END
+#define MRV_ISP_RIS_EXP_END_MASK 0x00040000
+#define MRV_ISP_RIS_EXP_END_SHIFT 18
+
+#define MRV_ISP_RIS_FLASH_CAP
+#define MRV_ISP_RIS_FLASH_CAP_MASK 0x00020000
+#define MRV_ISP_RIS_FLASH_CAP_SHIFT 17
+
+#define MRV_ISP_RIS_BP_DET
+#define MRV_ISP_RIS_BP_DET_MASK 0x00010000
+#define MRV_ISP_RIS_BP_DET_SHIFT 16
+#define MRV_ISP_RIS_BP_NEW_TAB_FUL
+#define MRV_ISP_RIS_BP_NEW_TAB_FUL_MASK 0x00008000
+#define MRV_ISP_RIS_BP_NEW_TAB_FUL_SHIFT 15
+#define MRV_ISP_RIS_AFM_FIN
+#define MRV_ISP_RIS_AFM_FIN_MASK 0x00004000
+#define MRV_ISP_RIS_AFM_FIN_SHIFT 14
+#define MRV_ISP_RIS_AFM_LUM_OF
+#define MRV_ISP_RIS_AFM_LUM_OF_MASK 0x00002000
+#define MRV_ISP_RIS_AFM_LUM_OF_SHIFT 13
+#define MRV_ISP_RIS_AFM_SUM_OF
+#define MRV_ISP_RIS_AFM_SUM_OF_MASK 0x00001000
+#define MRV_ISP_RIS_AFM_SUM_OF_SHIFT 12
+#define MRV_ISP_RIS_SHUTTER_OFF
+#define MRV_ISP_RIS_SHUTTER_OFF_MASK 0x00000800
+#define MRV_ISP_RIS_SHUTTER_OFF_SHIFT 11
+#define MRV_ISP_RIS_SHUTTER_ON
+#define MRV_ISP_RIS_SHUTTER_ON_MASK 0x00000400
+#define MRV_ISP_RIS_SHUTTER_ON_SHIFT 10
+#define MRV_ISP_RIS_FLASH_OFF
+#define MRV_ISP_RIS_FLASH_OFF_MASK 0x00000200
+#define MRV_ISP_RIS_FLASH_OFF_SHIFT 9
+#define MRV_ISP_RIS_FLASH_ON
+#define MRV_ISP_RIS_FLASH_ON_MASK 0x00000100
+#define MRV_ISP_RIS_FLASH_ON_SHIFT 8
+
+#define MRV_ISP_RIS_H_START
+#define MRV_ISP_RIS_H_START_MASK 0x00000080
+#define MRV_ISP_RIS_H_START_SHIFT 7
+#define MRV_ISP_RIS_V_START
+#define MRV_ISP_RIS_V_START_MASK 0x00000040
+#define MRV_ISP_RIS_V_START_SHIFT 6
+#define MRV_ISP_RIS_FRAME_IN
+#define MRV_ISP_RIS_FRAME_IN_MASK 0x00000020
+#define MRV_ISP_RIS_FRAME_IN_SHIFT 5
+#define MRV_ISP_RIS_AWB_DONE
+#define MRV_ISP_RIS_AWB_DONE_MASK 0x00000010
+#define MRV_ISP_RIS_AWB_DONE_SHIFT 4
+#define MRV_ISP_RIS_PIC_SIZE_ERR
+#define MRV_ISP_RIS_PIC_SIZE_ERR_MASK 0x00000008
+#define MRV_ISP_RIS_PIC_SIZE_ERR_SHIFT 3
+#define MRV_ISP_RIS_DATA_LOSS
+#define MRV_ISP_RIS_DATA_LOSS_MASK 0x00000004
+#define MRV_ISP_RIS_DATA_LOSS_SHIFT 2
+#define MRV_ISP_RIS_FRAME
+#define MRV_ISP_RIS_FRAME_MASK 0x00000002
+#define MRV_ISP_RIS_FRAME_SHIFT 1
+#define MRV_ISP_RIS_ISP_OFF
+#define MRV_ISP_RIS_ISP_OFF_MASK 0x00000001
+#define MRV_ISP_RIS_ISP_OFF_SHIFT 0
+
+#define MRV_ISP_RIS_ALL
+#define MRV_ISP_RIS_ALL_MASK \
+(0 \
+| MRV_ISP_RIS_EXP_END_MASK \
+| MRV_ISP_RIS_FLASH_CAP_MASK \
+| MRV_ISP_RIS_BP_DET_MASK \
+| MRV_ISP_RIS_BP_NEW_TAB_FUL_MASK \
+| MRV_ISP_RIS_AFM_FIN_MASK \
+| MRV_ISP_RIS_AFM_LUM_OF_MASK \
+| MRV_ISP_RIS_AFM_SUM_OF_MASK \
+| MRV_ISP_RIS_SHUTTER_OFF_MASK \
+| MRV_ISP_RIS_SHUTTER_ON_MASK \
+| MRV_ISP_RIS_FLASH_OFF_MASK \
+| MRV_ISP_RIS_FLASH_ON_MASK \
+| MRV_ISP_RIS_H_START_MASK \
+| MRV_ISP_RIS_V_START_MASK \
+| MRV_ISP_RIS_FRAME_IN_MASK \
+| MRV_ISP_RIS_AWB_DONE_MASK \
+| MRV_ISP_RIS_PIC_SIZE_ERR_MASK \
+| MRV_ISP_RIS_DATA_LOSS_MASK \
+| MRV_ISP_RIS_FRAME_MASK \
+| MRV_ISP_RIS_ISP_OFF_MASK \
+)
+#define MRV_ISP_RIS_ALL_SHIFT 0
+
+#define MRV_ISP_MIS_EXP_END
+#define MRV_ISP_MIS_EXP_END_MASK 0x00040000
+#define MRV_ISP_MIS_EXP_END_SHIFT 18
+
+#define MRV_ISP_MIS_FLASH_CAP
+#define MRV_ISP_MIS_FLASH_CAP_MASK 0x00020000
+#define MRV_ISP_MIS_FLASH_CAP_SHIFT 17
+
+#define MRV_ISP_MIS_BP_DET
+#define MRV_ISP_MIS_BP_DET_MASK 0x00010000
+#define MRV_ISP_MIS_BP_DET_SHIFT 16
+#define MRV_ISP_MIS_BP_NEW_TAB_FUL
+#define MRV_ISP_MIS_BP_NEW_TAB_FUL_MASK 0x00008000
+#define MRV_ISP_MIS_BP_NEW_TAB_FUL_SHIFT 15
+#define MRV_ISP_MIS_AFM_FIN
+#define MRV_ISP_MIS_AFM_FIN_MASK 0x00004000
+#define MRV_ISP_MIS_AFM_FIN_SHIFT 14
+#define MRV_ISP_MIS_AFM_LUM_OF
+#define MRV_ISP_MIS_AFM_LUM_OF_MASK 0x00002000
+#define MRV_ISP_MIS_AFM_LUM_OF_SHIFT 13
+#define MRV_ISP_MIS_AFM_SUM_OF
+#define MRV_ISP_MIS_AFM_SUM_OF_MASK 0x00001000
+#define MRV_ISP_MIS_AFM_SUM_OF_SHIFT 12
+#define MRV_ISP_MIS_SHUTTER_OFF
+#define MRV_ISP_MIS_SHUTTER_OFF_MASK 0x00000800
+#define MRV_ISP_MIS_SHUTTER_OFF_SHIFT 11
+#define MRV_ISP_MIS_SHUTTER_ON
+#define MRV_ISP_MIS_SHUTTER_ON_MASK 0x00000400
+#define MRV_ISP_MIS_SHUTTER_ON_SHIFT 10
+#define MRV_ISP_MIS_FLASH_OFF
+#define MRV_ISP_MIS_FLASH_OFF_MASK 0x00000200
+#define MRV_ISP_MIS_FLASH_OFF_SHIFT 9
+#define MRV_ISP_MIS_FLASH_ON
+#define MRV_ISP_MIS_FLASH_ON_MASK 0x00000100
+#define MRV_ISP_MIS_FLASH_ON_SHIFT 8
+
+#define MRV_ISP_MIS_H_START
+#define MRV_ISP_MIS_H_START_MASK 0x00000080
+#define MRV_ISP_MIS_H_START_SHIFT 7
+#define MRV_ISP_MIS_V_START
+#define MRV_ISP_MIS_V_START_MASK 0x00000040
+#define MRV_ISP_MIS_V_START_SHIFT 6
+#define MRV_ISP_MIS_FRAME_IN
+#define MRV_ISP_MIS_FRAME_IN_MASK 0x00000020
+#define MRV_ISP_MIS_FRAME_IN_SHIFT 5
+#define MRV_ISP_MIS_AWB_DONE
+#define MRV_ISP_MIS_AWB_DONE_MASK 0x00000010
+#define MRV_ISP_MIS_AWB_DONE_SHIFT 4
+#define MRV_ISP_MIS_PIC_SIZE_ERR
+#define MRV_ISP_MIS_PIC_SIZE_ERR_MASK 0x00000008
+#define MRV_ISP_MIS_PIC_SIZE_ERR_SHIFT 3
+#define MRV_ISP_MIS_DATA_LOSS
+#define MRV_ISP_MIS_DATA_LOSS_MASK 0x00000004
+#define MRV_ISP_MIS_DATA_LOSS_SHIFT 2
+#define MRV_ISP_MIS_FRAME
+#define MRV_ISP_MIS_FRAME_MASK 0x00000002
+#define MRV_ISP_MIS_FRAME_SHIFT 1
+#define MRV_ISP_MIS_ISP_OFF
+#define MRV_ISP_MIS_ISP_OFF_MASK 0x00000001
+#define MRV_ISP_MIS_ISP_OFF_SHIFT 0
+
+#define MRV_ISP_MIS_ALL
+#define MRV_ISP_MIS_ALL_MASK \
+(0 \
+| MRV_ISP_MIS_EXP_END_MASK \
+| MRV_ISP_MIS_FLASH_CAP_MASK \
+| MRV_ISP_MIS_BP_DET_MASK \
+| MRV_ISP_MIS_BP_NEW_TAB_FUL_MASK \
+| MRV_ISP_MIS_AFM_FIN_MASK \
+| MRV_ISP_MIS_AFM_LUM_OF_MASK \
+| MRV_ISP_MIS_AFM_SUM_OF_MASK \
+| MRV_ISP_MIS_SHUTTER_OFF_MASK \
+| MRV_ISP_MIS_SHUTTER_ON_MASK \
+| MRV_ISP_MIS_FLASH_OFF_MASK \
+| MRV_ISP_MIS_FLASH_ON_MASK \
+| MRV_ISP_MIS_H_START_MASK \
+| MRV_ISP_MIS_V_START_MASK \
+| MRV_ISP_MIS_FRAME_IN_MASK \
+| MRV_ISP_MIS_AWB_DONE_MASK \
+| MRV_ISP_MIS_PIC_SIZE_ERR_MASK \
+| MRV_ISP_MIS_DATA_LOSS_MASK \
+| MRV_ISP_MIS_FRAME_MASK \
+| MRV_ISP_MIS_ISP_OFF_MASK \
+)
+#define MRV_ISP_MIS_ALL_SHIFT 0
+
+#define MRV_ISP_ICR_EXP_END
+#define MRV_ISP_ICR_EXP_END_MASK 0x00040000
+#define MRV_ISP_ICR_EXP_END_SHIFT 18
+#define MRV_ISP_ICR_FLASH_CAP
+#define MRV_ISP_ICR_FLASH_CAP_MASK 0x00020000
+#define MRV_ISP_ICR_FLASH_CAP_SHIFT 17
+
+#define MRV_ISP_ICR_BP_DET
+#define MRV_ISP_ICR_BP_DET_MASK 0x00010000
+#define MRV_ISP_ICR_BP_DET_SHIFT 16
+#define MRV_ISP_ICR_BP_NEW_TAB_FUL
+#define MRV_ISP_ICR_BP_NEW_TAB_FUL_MASK 0x00008000
+#define MRV_ISP_ICR_BP_NEW_TAB_FUL_SHIFT 15
+#define MRV_ISP_ICR_AFM_FIN
+#define MRV_ISP_ICR_AFM_FIN_MASK 0x00004000
+#define MRV_ISP_ICR_AFM_FIN_SHIFT 14
+#define MRV_ISP_ICR_AFM_LUM_OF
+#define MRV_ISP_ICR_AFM_LUM_OF_MASK 0x00002000
+#define MRV_ISP_ICR_AFM_LUM_OF_SHIFT 13
+#define MRV_ISP_ICR_AFM_SUM_OF
+#define MRV_ISP_ICR_AFM_SUM_OF_MASK 0x00001000
+#define MRV_ISP_ICR_AFM_SUM_OF_SHIFT 12
+#define MRV_ISP_ICR_SHUTTER_OFF
+#define MRV_ISP_ICR_SHUTTER_OFF_MASK 0x00000800
+#define MRV_ISP_ICR_SHUTTER_OFF_SHIFT 11
+#define MRV_ISP_ICR_SHUTTER_ON
+#define MRV_ISP_ICR_SHUTTER_ON_MASK 0x00000400
+#define MRV_ISP_ICR_SHUTTER_ON_SHIFT 10
+#define MRV_ISP_ICR_FLASH_OFF
+#define MRV_ISP_ICR_FLASH_OFF_MASK 0x00000200
+#define MRV_ISP_ICR_FLASH_OFF_SHIFT 9
+#define MRV_ISP_ICR_FLASH_ON
+#define MRV_ISP_ICR_FLASH_ON_MASK 0x00000100
+#define MRV_ISP_ICR_FLASH_ON_SHIFT 8
+
+#define MRV_ISP_ICR_H_START
+#define MRV_ISP_ICR_H_START_MASK 0x00000080
+#define MRV_ISP_ICR_H_START_SHIFT 7
+#define MRV_ISP_ICR_V_START
+#define MRV_ISP_ICR_V_START_MASK 0x00000040
+#define MRV_ISP_ICR_V_START_SHIFT 6
+#define MRV_ISP_ICR_FRAME_IN
+#define MRV_ISP_ICR_FRAME_IN_MASK 0x00000020
+#define MRV_ISP_ICR_FRAME_IN_SHIFT 5
+#define MRV_ISP_ICR_AWB_DONE
+#define MRV_ISP_ICR_AWB_DONE_MASK 0x00000010
+#define MRV_ISP_ICR_AWB_DONE_SHIFT 4
+#define MRV_ISP_ICR_PIC_SIZE_ERR
+#define MRV_ISP_ICR_PIC_SIZE_ERR_MASK 0x00000008
+#define MRV_ISP_ICR_PIC_SIZE_ERR_SHIFT 3
+#define MRV_ISP_ICR_DATA_LOSS
+#define MRV_ISP_ICR_DATA_LOSS_MASK 0x00000004
+#define MRV_ISP_ICR_DATA_LOSS_SHIFT 2
+#define MRV_ISP_ICR_FRAME
+#define MRV_ISP_ICR_FRAME_MASK 0x00000002
+#define MRV_ISP_ICR_FRAME_SHIFT 1
+#define MRV_ISP_ICR_ISP_OFF
+#define MRV_ISP_ICR_ISP_OFF_MASK 0x00000001
+#define MRV_ISP_ICR_ISP_OFF_SHIFT 0
+
+#define MRV_ISP_ICR_ALL
+#define MRV_ISP_ICR_ALL_MASK \
+(0 \
+| MRV_ISP_ICR_EXP_END_MASK \
+| MRV_ISP_ICR_FLASH_CAP_MASK \
+| MRV_ISP_ICR_BP_DET_MASK \
+| MRV_ISP_ICR_BP_NEW_TAB_FUL_MASK \
+| MRV_ISP_ICR_AFM_FIN_MASK \
+| MRV_ISP_ICR_AFM_LUM_OF_MASK \
+| MRV_ISP_ICR_AFM_SUM_OF_MASK \
+| MRV_ISP_ICR_SHUTTER_OFF_MASK \
+| MRV_ISP_ICR_SHUTTER_ON_MASK \
+| MRV_ISP_ICR_FLASH_OFF_MASK \
+| MRV_ISP_ICR_FLASH_ON_MASK \
+| MRV_ISP_ICR_H_START_MASK \
+| MRV_ISP_ICR_V_START_MASK \
+| MRV_ISP_ICR_FRAME_IN_MASK \
+| MRV_ISP_ICR_AWB_DONE_MASK \
+| MRV_ISP_ICR_PIC_SIZE_ERR_MASK \
+| MRV_ISP_ICR_DATA_LOSS_MASK \
+| MRV_ISP_ICR_FRAME_MASK \
+| MRV_ISP_ICR_ISP_OFF_MASK \
+)
+#define MRV_ISP_ICR_ALL_SHIFT 0
+
+#define MRV_ISP_ISR_EXP_END
+#define MRV_ISP_ISR_EXP_END_MASK 0x00040000
+#define MRV_ISP_ISR_EXP_END_SHIFT 18
+#define MRV_ISP_ISR_FLASH_CAP
+#define MRV_ISP_ISR_FLASH_CAP_MASK 0x00020000
+#define MRV_ISP_ISR_FLASH_CAP_SHIFT 17
+
+#define MRV_ISP_ISR_BP_DET
+#define MRV_ISP_ISR_BP_DET_MASK 0x00010000
+#define MRV_ISP_ISR_BP_DET_SHIFT 16
+#define MRV_ISP_ISR_BP_NEW_TAB_FUL
+#define MRV_ISP_ISR_BP_NEW_TAB_FUL_MASK 0x00008000
+#define MRV_ISP_ISR_BP_NEW_TAB_FUL_SHIFT 15
+#define MRV_ISP_ISR_AFM_FIN
+#define MRV_ISP_ISR_AFM_FIN_MASK 0x00004000
+#define MRV_ISP_ISR_AFM_FIN_SHIFT 14
+#define MRV_ISP_ISR_AFM_LUM_OF
+#define MRV_ISP_ISR_AFM_LUM_OF_MASK 0x00002000
+#define MRV_ISP_ISR_AFM_LUM_OF_SHIFT 13
+#define MRV_ISP_ISR_AFM_SUM_OF
+#define MRV_ISP_ISR_AFM_SUM_OF_MASK 0x00001000
+#define MRV_ISP_ISR_AFM_SUM_OF_SHIFT 12
+#define MRV_ISP_ISR_SHUTTER_OFF
+#define MRV_ISP_ISR_SHUTTER_OFF_MASK 0x00000800
+#define MRV_ISP_ISR_SHUTTER_OFF_SHIFT 11
+#define MRV_ISP_ISR_SHUTTER_ON
+#define MRV_ISP_ISR_SHUTTER_ON_MASK 0x00000400
+#define MRV_ISP_ISR_SHUTTER_ON_SHIFT 10
+#define MRV_ISP_ISR_FLASH_OFF
+#define MRV_ISP_ISR_FLASH_OFF_MASK 0x00000200
+#define MRV_ISP_ISR_FLASH_OFF_SHIFT 9
+#define MRV_ISP_ISR_FLASH_ON
+#define MRV_ISP_ISR_FLASH_ON_MASK 0x00000100
+#define MRV_ISP_ISR_FLASH_ON_SHIFT 8
+
+#define MRV_ISP_ISR_H_START
+#define MRV_ISP_ISR_H_START_MASK 0x00000080
+#define MRV_ISP_ISR_H_START_SHIFT 7
+#define MRV_ISP_ISR_V_START
+#define MRV_ISP_ISR_V_START_MASK 0x00000040
+#define MRV_ISP_ISR_V_START_SHIFT 6
+#define MRV_ISP_ISR_FRAME_IN
+#define MRV_ISP_ISR_FRAME_IN_MASK 0x00000020
+#define MRV_ISP_ISR_FRAME_IN_SHIFT 5
+#define MRV_ISP_ISR_AWB_DONE
+#define MRV_ISP_ISR_AWB_DONE_MASK 0x00000010
+#define MRV_ISP_ISR_AWB_DONE_SHIFT 4
+#define MRV_ISP_ISR_PIC_SIZE_ERR
+#define MRV_ISP_ISR_PIC_SIZE_ERR_MASK 0x00000008
+#define MRV_ISP_ISR_PIC_SIZE_ERR_SHIFT 3
+#define MRV_ISP_ISR_DATA_LOSS
+#define MRV_ISP_ISR_DATA_LOSS_MASK 0x00000004
+#define MRV_ISP_ISR_DATA_LOSS_SHIFT 2
+#define MRV_ISP_ISR_FRAME
+#define MRV_ISP_ISR_FRAME_MASK 0x00000002
+#define MRV_ISP_ISR_FRAME_SHIFT 1
+#define MRV_ISP_ISR_ISP_OFF
+#define MRV_ISP_ISR_ISP_OFF_MASK 0x00000001
+#define MRV_ISP_ISR_ISP_OFF_SHIFT 0
+
+#define MRV_ISP_ISR_ALL
+#define MRV_ISP_ISR_ALL_MASK \
+(0 \
+| MRV_ISP_ISR_EXP_END_MASK \
+| MRV_ISP_ISR_FLASH_CAP_MASK \
+| MRV_ISP_ISR_BP_DET_MASK \
+| MRV_ISP_ISR_BP_NEW_TAB_FUL_MASK \
+| MRV_ISP_ISR_AFM_FIN_MASK \
+| MRV_ISP_ISR_AFM_LUM_OF_MASK \
+| MRV_ISP_ISR_AFM_SUM_OF_MASK \
+| MRV_ISP_ISR_SHUTTER_OFF_MASK \
+| MRV_ISP_ISR_SHUTTER_ON_MASK \
+| MRV_ISP_ISR_FLASH_OFF_MASK \
+| MRV_ISP_ISR_FLASH_ON_MASK \
+| MRV_ISP_ISR_H_START_MASK \
+| MRV_ISP_ISR_V_START_MASK \
+| MRV_ISP_ISR_FRAME_IN_MASK \
+| MRV_ISP_ISR_AWB_DONE_MASK \
+| MRV_ISP_ISR_PIC_SIZE_ERR_MASK \
+| MRV_ISP_ISR_DATA_LOSS_MASK \
+| MRV_ISP_ISR_FRAME_MASK \
+| MRV_ISP_ISR_ISP_OFF_MASK \
+)
+#define MRV_ISP_ISR_ALL_SHIFT 0
+
+#define MRV_ISP_CT_COEFF
+#define MRV_ISP_CT_COEFF_MASK 0x000007FF
+#define MRV_ISP_CT_COEFF_SHIFT 0
+#define MRV_ISP_CT_COEFF_MAX   (MRV_ISP_CT_COEFF_MASK >> MRV_ISP_CT_COEFF_SHIFT)
+
+#define MRV_ISP_EQU_SEGM
+#define MRV_ISP_EQU_SEGM_MASK 0x00000001
+#define MRV_ISP_EQU_SEGM_SHIFT 0
+#define MRV_ISP_EQU_SEGM_LOG   0
+#define MRV_ISP_EQU_SEGM_EQU   1
+
+#define MRV_ISP_ISP_GAMMA_OUT_Y
+#define MRV_ISP_ISP_GAMMA_OUT_Y_MASK 0x000003FF
+#define MRV_ISP_ISP_GAMMA_OUT_Y_SHIFT 0
+
+#define MRV_ISP_OUTFORM_SIZE_ERR
+#define MRV_ISP_OUTFORM_SIZE_ERR_MASK 0x00000004
+#define MRV_ISP_OUTFORM_SIZE_ERR_SHIFT 2
+#define MRV_ISP_IS_SIZE_ERR
+#define MRV_ISP_IS_SIZE_ERR_MASK 0x00000002
+#define MRV_ISP_IS_SIZE_ERR_SHIFT 1
+#define MRV_ISP_INFORM_SIZE_ERR
+#define MRV_ISP_INFORM_SIZE_ERR_MASK 0x00000001
+#define MRV_ISP_INFORM_SIZE_ERR_SHIFT 0
+
+#define MRV_ISP_ALL_ERR
+#define MRV_ISP_ALL_ERR_MASK \
+(0 \
+| MRV_ISP_OUTFORM_SIZE_ERR_MASK \
+| MRV_ISP_IS_SIZE_ERR_MASK      \
+| MRV_ISP_INFORM_SIZE_ERR_MASK  \
+)
+#define MRV_ISP_ALL_ERR_SHIFT 0
+
+#define MRV_ISP_OUTFORM_SIZE_ERR_CLR
+#define MRV_ISP_OUTFORM_SIZE_ERR_CLR_MASK 0x00000004
+#define MRV_ISP_OUTFORM_SIZE_ERR_CLR_SHIFT 2
+#define MRV_ISP_IS_SIZE_ERR_CLR
+#define MRV_ISP_IS_SIZE_ERR_CLR_MASK 0x00000002
+#define MRV_ISP_IS_SIZE_ERR_CLR_SHIFT 1
+#define MRV_ISP_INFORM_SIZE_ERR_CLR
+#define MRV_ISP_INFORM_SIZE_ERR_CLR_MASK 0x00000001
+#define MRV_ISP_INFORM_SIZE_ERR_CLR_SHIFT 0
+
+#define MRV_ISP_FRAME_COUNTER
+#define MRV_ISP_FRAME_COUNTER_MASK 0x000003FF
+#define MRV_ISP_FRAME_COUNTER_SHIFT 0
+
+#define MRV_ISP_CT_OFFSET_R
+#define MRV_ISP_CT_OFFSET_R_MASK 0x00000FFF
+#define MRV_ISP_CT_OFFSET_R_SHIFT 0
+
+#define MRV_ISP_CT_OFFSET_G
+#define MRV_ISP_CT_OFFSET_G_MASK 0x00000FFF
+#define MRV_ISP_CT_OFFSET_G_SHIFT 0
+
+#define MRV_ISP_CT_OFFSET_B
+#define MRV_ISP_CT_OFFSET_B_MASK 0x00000FFF
+#define MRV_ISP_CT_OFFSET_B_SHIFT 0
+
+#define MRV_FLASH_PREFLASH_ON
+#define MRV_FLASH_PREFLASH_ON_MASK 0x00000004
+#define MRV_FLASH_PREFLASH_ON_SHIFT 2
+#define MRV_FLASH_FLASH_ON
+#define MRV_FLASH_FLASH_ON_MASK 0x00000002
+#define MRV_FLASH_FLASH_ON_SHIFT 1
+#define MRV_FLASH_PRELIGHT_ON
+#define MRV_FLASH_PRELIGHT_ON_MASK 0x00000001
+#define MRV_FLASH_PRELIGHT_ON_SHIFT 0
+
+#define MRV_FLASH_FL_CAP_DEL
+#define MRV_FLASH_FL_CAP_DEL_MASK 0x000000F0
+#define MRV_FLASH_FL_CAP_DEL_SHIFT 4
+#define MRV_FLASH_FL_CAP_DEL_MAX \
+       (MRV_FLASH_FL_CAP_DEL_MASK >> MRV_FLASH_FL_CAP_DEL_SHIFT)
+#define MRV_FLASH_FL_TRIG_SRC
+#define MRV_FLASH_FL_TRIG_SRC_MASK 0x00000008
+#define MRV_FLASH_FL_TRIG_SRC_SHIFT 3
+#define MRV_FLASH_FL_TRIG_SRC_VDS   0
+#define MRV_FLASH_FL_TRIG_SRC_FL    1
+#define MRV_FLASH_FL_POL
+#define MRV_FLASH_FL_POL_MASK 0x00000004
+#define MRV_FLASH_FL_POL_SHIFT 2
+#define MRV_FLASH_FL_POL_HIGH  0
+#define MRV_FLASH_FL_POL_LOW   1
+#define MRV_FLASH_VS_IN_EDGE
+#define MRV_FLASH_VS_IN_EDGE_MASK 0x00000002
+#define MRV_FLASH_VS_IN_EDGE_SHIFT 1
+#define MRV_FLASH_VS_IN_EDGE_NEG   0
+#define MRV_FLASH_VS_IN_EDGE_POS   1
+#define MRV_FLASH_PRELIGHT_MODE
+#define MRV_FLASH_PRELIGHT_MODE_MASK 0x00000001
+#define MRV_FLASH_PRELIGHT_MODE_SHIFT 0
+#define MRV_FLASH_PRELIGHT_MODE_OASF  0
+#define MRV_FLASH_PRELIGHT_MODE_OAEF  1
+
+#define MRV_FLASH_FL_PRE_DIV
+#define MRV_FLASH_FL_PRE_DIV_MASK 0x000003FF
+#define MRV_FLASH_FL_PRE_DIV_SHIFT 0
+#define MRV_FLASH_FL_PRE_DIV_MAX \
+       (MRV_FLASH_FL_PRE_DIV_MASK >> MRV_FLASH_FL_PRE_DIV_SHIFT)
+
+#define MRV_FLASH_FL_DELAY
+#define MRV_FLASH_FL_DELAY_MASK 0x0003FFFF
+#define MRV_FLASH_FL_DELAY_SHIFT 0
+#define MRV_FLASH_FL_DELAY_MAX \
+       (MRV_FLASH_FL_DELAY_MASK >> MRV_FLASH_FL_DELAY_SHIFT)
+
+#define MRV_FLASH_FL_TIME
+#define MRV_FLASH_FL_TIME_MASK 0x0003FFFF
+#define MRV_FLASH_FL_TIME_SHIFT 0
+#define MRV_FLASH_FL_TIME_MAX \
+       (MRV_FLASH_FL_TIME_MASK >> MRV_FLASH_FL_TIME_SHIFT)
+
+#define MRV_FLASH_FL_MAXP
+#define MRV_FLASH_FL_MAXP_MASK 0x0000FFFF
+#define MRV_FLASH_FL_MAXP_SHIFT 0
+#define MRV_FLASH_FL_MAXP_MAX \
+       (MRV_FLASH_FL_MAXP_MASK >> MRV_FLASH_FL_MAXP_SHIFT)
+
+#define MRV_SHUT_SH_OPEN_POL
+#define MRV_SHUT_SH_OPEN_POL_MASK 0x00000010
+#define MRV_SHUT_SH_OPEN_POL_SHIFT 4
+#define MRV_SHUT_SH_OPEN_POL_HIGH  0
+#define MRV_SHUT_SH_OPEN_POL_LOW   1
+#define MRV_SHUT_SH_TRIG_EN
+#define MRV_SHUT_SH_TRIG_EN_MASK 0x00000008
+#define MRV_SHUT_SH_TRIG_EN_SHIFT 3
+#define MRV_SHUT_SH_TRIG_EN_NEG   0
+#define MRV_SHUT_SH_TRIG_EN_POS   1
+#define MRV_SHUT_SH_TRIG_SRC
+#define MRV_SHUT_SH_TRIG_SRC_MASK 0x00000004
+#define MRV_SHUT_SH_TRIG_SRC_SHIFT 2
+#define MRV_SHUT_SH_TRIG_SRC_VDS   0
+#define MRV_SHUT_SH_TRIG_SRC_SHUT  1
+#define MRV_SHUT_SH_REP_EN
+#define MRV_SHUT_SH_REP_EN_MASK 0x00000002
+#define MRV_SHUT_SH_REP_EN_SHIFT 1
+#define MRV_SHUT_SH_REP_EN_ONCE  0
+#define MRV_SHUT_SH_REP_EN_REP   1
+#define MRV_SHUT_SH_EN
+#define MRV_SHUT_SH_EN_MASK 0x00000001
+#define MRV_SHUT_SH_EN_SHIFT 0
+
+#define MRV_SHUT_SH_PRE_DIV
+#define MRV_SHUT_SH_PRE_DIV_MASK 0x000003FF
+#define MRV_SHUT_SH_PRE_DIV_SHIFT 0
+#define MRV_SHUT_SH_PRE_DIV_MAX \
+       (MRV_SHUT_SH_PRE_DIV_MASK >> MRV_SHUT_SH_PRE_DIV_SHIFT)
+
+#define MRV_SHUT_SH_DELAY
+#define MRV_SHUT_SH_DELAY_MASK 0x000FFFFF
+#define MRV_SHUT_SH_DELAY_SHIFT 0
+#define MRV_SHUT_SH_DELAY_MAX \
+       (MRV_SHUT_SH_DELAY_MASK >> MRV_SHUT_SH_DELAY_SHIFT)
+
+#define MRV_SHUT_SH_TIME
+#define MRV_SHUT_SH_TIME_MASK 0x000FFFFF
+#define MRV_SHUT_SH_TIME_SHIFT 0
+#define MRV_SHUT_SH_TIME_MAX (MRV_SHUT_SH_TIME_MASK >> MRV_SHUT_SH_TIME_SHIFT)
+
+#define MRV_CPROC_CPROC_C_OUT_RANGE
+#define MRV_CPROC_CPROC_C_OUT_RANGE_MASK 0x00000008
+#define MRV_CPROC_CPROC_C_OUT_RANGE_SHIFT 3
+#define MRV_CPROC_CPROC_C_OUT_RANGE_BT601 0
+#define MRV_CPROC_CPROC_C_OUT_RANGE_FULL  1
+#define MRV_CPROC_CPROC_Y_IN_RANGE
+#define MRV_CPROC_CPROC_Y_IN_RANGE_MASK 0x00000004
+#define MRV_CPROC_CPROC_Y_IN_RANGE_SHIFT 2
+#define MRV_CPROC_CPROC_Y_IN_RANGE_BT601 0
+#define MRV_CPROC_CPROC_Y_IN_RANGE_FULL  1
+#define MRV_CPROC_CPROC_Y_OUT_RANGE
+#define MRV_CPROC_CPROC_Y_OUT_RANGE_MASK 0x00000002
+#define MRV_CPROC_CPROC_Y_OUT_RANGE_SHIFT 1
+#define MRV_CPROC_CPROC_Y_OUT_RANGE_BT601 0
+#define MRV_CPROC_CPROC_Y_OUT_RANGE_FULL  1
+#define MRV_CPROC_CPROC_ENABLE
+#define MRV_CPROC_CPROC_ENABLE_MASK 0x00000001
+#define MRV_CPROC_CPROC_ENABLE_SHIFT 0
+
+#define MRV_CPROC_CPROC_CONTRAST
+#define MRV_CPROC_CPROC_CONTRAST_MASK 0x000000FF
+#define MRV_CPROC_CPROC_CONTRAST_SHIFT 0
+
+#define MRV_CPROC_CPROC_BRIGHTNESS
+#define MRV_CPROC_CPROC_BRIGHTNESS_MASK 0x000000FF
+#define MRV_CPROC_CPROC_BRIGHTNESS_SHIFT 0
+
+#define MRV_CPROC_CPROC_SATURATION
+#define MRV_CPROC_CPROC_SATURATION_MASK 0x000000FF
+#define MRV_CPROC_CPROC_SATURATION_SHIFT 0
+
+#define MRV_CPROC_CPROC_HUE
+#define MRV_CPROC_CPROC_HUE_MASK 0x000000FF
+#define MRV_CPROC_CPROC_HUE_SHIFT 0
+
+#define MRV_RSZ_SCALE
+#define MRV_RSZ_SCALE_MASK 0x00003FFF
+#define MRV_RSZ_SCALE_SHIFT 0
+#define MRV_RSZ_SCALE_MAX (MRV_RSZ_SCALE_MASK >> MRV_RSZ_SCALE_SHIFT)
+
+#define MRV_MRSZ_CFG_UPD
+#define MRV_MRSZ_CFG_UPD_MASK 0x00000100
+#define MRV_MRSZ_CFG_UPD_SHIFT 8
+#define MRV_MRSZ_SCALE_VC_UP
+#define MRV_MRSZ_SCALE_VC_UP_MASK 0x00000080
+#define MRV_MRSZ_SCALE_VC_UP_SHIFT 7
+#define MRV_MRSZ_SCALE_VC_UP_UPSCALE   1
+#define MRV_MRSZ_SCALE_VC_UP_DOWNSCALE 0
+#define MRV_MRSZ_SCALE_VY_UP
+#define MRV_MRSZ_SCALE_VY_UP_MASK 0x00000040
+#define MRV_MRSZ_SCALE_VY_UP_SHIFT 6
+#define MRV_MRSZ_SCALE_VY_UP_UPSCALE   1
+#define MRV_MRSZ_SCALE_VY_UP_DOWNSCALE 0
+#define MRV_MRSZ_SCALE_HC_UP
+#define MRV_MRSZ_SCALE_HC_UP_MASK 0x00000020
+#define MRV_MRSZ_SCALE_HC_UP_SHIFT 5
+#define MRV_MRSZ_SCALE_HC_UP_UPSCALE   1
+#define MRV_MRSZ_SCALE_HC_UP_DOWNSCALE 0
+#define MRV_MRSZ_SCALE_HY_UP
+#define MRV_MRSZ_SCALE_HY_UP_MASK 0x00000010
+#define MRV_MRSZ_SCALE_HY_UP_SHIFT 4
+#define MRV_MRSZ_SCALE_HY_UP_UPSCALE   1
+#define MRV_MRSZ_SCALE_HY_UP_DOWNSCALE 0
+#define MRV_MRSZ_SCALE_VC_ENABLE
+#define MRV_MRSZ_SCALE_VC_ENABLE_MASK 0x00000008
+#define MRV_MRSZ_SCALE_VC_ENABLE_SHIFT 3
+#define MRV_MRSZ_SCALE_VY_ENABLE
+#define MRV_MRSZ_SCALE_VY_ENABLE_MASK 0x00000004
+#define MRV_MRSZ_SCALE_VY_ENABLE_SHIFT 2
+#define MRV_MRSZ_SCALE_HC_ENABLE
+#define MRV_MRSZ_SCALE_HC_ENABLE_MASK 0x00000002
+#define MRV_MRSZ_SCALE_HC_ENABLE_SHIFT 1
+#define MRV_MRSZ_SCALE_HY_ENABLE
+#define MRV_MRSZ_SCALE_HY_ENABLE_MASK 0x00000001
+#define MRV_MRSZ_SCALE_HY_ENABLE_SHIFT 0
+
+#define MRV_MRSZ_SCALE_HY
+#define MRV_MRSZ_SCALE_HY_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_MRSZ_SCALE_HY_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_MRSZ_SCALE_HCB
+#define MRV_MRSZ_SCALE_HCB_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_MRSZ_SCALE_HCB_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_MRSZ_SCALE_HCR
+#define MRV_MRSZ_SCALE_HCR_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_MRSZ_SCALE_HCR_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_MRSZ_SCALE_VY
+#define MRV_MRSZ_SCALE_VY_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_MRSZ_SCALE_VY_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_MRSZ_SCALE_VC
+#define MRV_MRSZ_SCALE_VC_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_MRSZ_SCALE_VC_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_MRSZ_PHASE_HY
+#define MRV_MRSZ_PHASE_HY_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_MRSZ_PHASE_HY_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_MRSZ_PHASE_HC
+#define MRV_MRSZ_PHASE_HC_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_MRSZ_PHASE_HC_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_MRSZ_PHASE_VY
+#define MRV_MRSZ_PHASE_VY_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_MRSZ_PHASE_VY_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_MRSZ_PHASE_VC
+#define MRV_MRSZ_PHASE_VC_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_MRSZ_PHASE_VC_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_MRSZ_SCALE_LUT_ADDR
+#define MRV_MRSZ_SCALE_LUT_ADDR_MASK 0x0000003F
+#define MRV_MRSZ_SCALE_LUT_ADDR_SHIFT 0
+
+#define MRV_MRSZ_SCALE_LUT
+#define MRV_MRSZ_SCALE_LUT_MASK 0x0000003F
+#define MRV_MRSZ_SCALE_LUT_SHIFT 0
+
+#define MRV_MRSZ_SCALE_VC_UP_SHD
+#define MRV_MRSZ_SCALE_VC_UP_SHD_MASK 0x00000080
+#define MRV_MRSZ_SCALE_VC_UP_SHD_SHIFT 7
+#define MRV_MRSZ_SCALE_VC_UP_SHD_UPSCALE   1
+#define MRV_MRSZ_SCALE_VC_UP_SHD_DOWNSCALE 0
+#define MRV_MRSZ_SCALE_VY_UP_SHD
+#define MRV_MRSZ_SCALE_VY_UP_SHD_MASK 0x00000040
+#define MRV_MRSZ_SCALE_VY_UP_SHD_SHIFT 6
+#define MRV_MRSZ_SCALE_VY_UP_SHD_UPSCALE   1
+#define MRV_MRSZ_SCALE_VY_UP_SHD_DOWNSCALE 0
+#define MRV_MRSZ_SCALE_HC_UP_SHD
+#define MRV_MRSZ_SCALE_HC_UP_SHD_MASK 0x00000020
+#define MRV_MRSZ_SCALE_HC_UP_SHD_SHIFT 5
+#define MRV_MRSZ_SCALE_HC_UP_SHD_UPSCALE   1
+#define MRV_MRSZ_SCALE_HC_UP_SHD_DOWNSCALE 0
+#define MRV_MRSZ_SCALE_HY_UP_SHD
+#define MRV_MRSZ_SCALE_HY_UP_SHD_MASK 0x00000010
+#define MRV_MRSZ_SCALE_HY_UP_SHD_SHIFT 4
+#define MRV_MRSZ_SCALE_HY_UP_SHD_UPSCALE   1
+#define MRV_MRSZ_SCALE_HY_UP_SHD_DOWNSCALE 0
+#define MRV_MRSZ_SCALE_VC_ENABLE_SHD
+#define MRV_MRSZ_SCALE_VC_ENABLE_SHD_MASK 0x00000008
+#define MRV_MRSZ_SCALE_VC_ENABLE_SHD_SHIFT 3
+#define MRV_MRSZ_SCALE_VY_ENABLE_SHD
+#define MRV_MRSZ_SCALE_VY_ENABLE_SHD_MASK 0x00000004
+#define MRV_MRSZ_SCALE_VY_ENABLE_SHD_SHIFT 2
+#define MRV_MRSZ_SCALE_HC_ENABLE_SHD
+#define MRV_MRSZ_SCALE_HC_ENABLE_SHD_MASK 0x00000002
+#define MRV_MRSZ_SCALE_HC_ENABLE_SHD_SHIFT 1
+#define MRV_MRSZ_SCALE_HY_ENABLE_SHD
+#define MRV_MRSZ_SCALE_HY_ENABLE_SHD_MASK 0x00000001
+#define MRV_MRSZ_SCALE_HY_ENABLE_SHD_SHIFT 0
+
+#define MRV_MRSZ_SCALE_HY_SHD
+#define MRV_MRSZ_SCALE_HY_SHD_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_MRSZ_SCALE_HY_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_MRSZ_SCALE_HCB_SHD
+#define MRV_MRSZ_SCALE_HCB_SHD_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_MRSZ_SCALE_HCB_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_MRSZ_SCALE_HCR_SHD
+#define MRV_MRSZ_SCALE_HCR_SHD_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_MRSZ_SCALE_HCR_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_MRSZ_SCALE_VY_SHD
+#define MRV_MRSZ_SCALE_VY_SHD_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_MRSZ_SCALE_VY_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_MRSZ_SCALE_VC_SHD
+#define MRV_MRSZ_SCALE_VC_SHD_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_MRSZ_SCALE_VC_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_MRSZ_PHASE_HY_SHD
+#define MRV_MRSZ_PHASE_HY_SHD_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_MRSZ_PHASE_HY_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_MRSZ_PHASE_HC_SHD
+#define MRV_MRSZ_PHASE_HC_SHD_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_MRSZ_PHASE_HC_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_MRSZ_PHASE_VY_SHD
+#define MRV_MRSZ_PHASE_VY_SHD_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_MRSZ_PHASE_VY_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_MRSZ_PHASE_VC_SHD
+#define MRV_MRSZ_PHASE_VC_SHD_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_MRSZ_PHASE_VC_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_SRSZ_CFG_UPD
+#define MRV_SRSZ_CFG_UPD_MASK 0x00000100
+#define MRV_SRSZ_CFG_UPD_SHIFT 8
+#define MRV_SRSZ_SCALE_VC_UP
+#define MRV_SRSZ_SCALE_VC_UP_MASK 0x00000080
+#define MRV_SRSZ_SCALE_VC_UP_SHIFT 7
+#define MRV_SRSZ_SCALE_VC_UP_UPSCALE   1
+#define MRV_SRSZ_SCALE_VC_UP_DOWNSCALE 0
+#define MRV_SRSZ_SCALE_VY_UP
+#define MRV_SRSZ_SCALE_VY_UP_MASK 0x00000040
+#define MRV_SRSZ_SCALE_VY_UP_SHIFT 6
+#define MRV_SRSZ_SCALE_VY_UP_UPSCALE   1
+#define MRV_SRSZ_SCALE_VY_UP_DOWNSCALE 0
+#define MRV_SRSZ_SCALE_HC_UP
+#define MRV_SRSZ_SCALE_HC_UP_MASK 0x00000020
+#define MRV_SRSZ_SCALE_HC_UP_SHIFT 5
+#define MRV_SRSZ_SCALE_HC_UP_UPSCALE   1
+#define MRV_SRSZ_SCALE_HC_UP_DOWNSCALE 0
+#define MRV_SRSZ_SCALE_HY_UP
+#define MRV_SRSZ_SCALE_HY_UP_MASK 0x00000010
+#define MRV_SRSZ_SCALE_HY_UP_SHIFT 4
+#define MRV_SRSZ_SCALE_HY_UP_UPSCALE   1
+#define MRV_SRSZ_SCALE_HY_UP_DOWNSCALE 0
+
+#define MRV_SRSZ_SCALE_VC_ENABLE
+#define MRV_SRSZ_SCALE_VC_ENABLE_MASK 0x00000008
+#define MRV_SRSZ_SCALE_VC_ENABLE_SHIFT 3
+#define MRV_SRSZ_SCALE_VY_ENABLE
+#define MRV_SRSZ_SCALE_VY_ENABLE_MASK 0x00000004
+#define MRV_SRSZ_SCALE_VY_ENABLE_SHIFT 2
+#define MRV_SRSZ_SCALE_HC_ENABLE
+#define MRV_SRSZ_SCALE_HC_ENABLE_MASK 0x00000002
+#define MRV_SRSZ_SCALE_HC_ENABLE_SHIFT 1
+#define MRV_SRSZ_SCALE_HY_ENABLE
+#define MRV_SRSZ_SCALE_HY_ENABLE_MASK 0x00000001
+#define MRV_SRSZ_SCALE_HY_ENABLE_SHIFT 0
+
+#define MRV_SRSZ_SCALE_HY
+#define MRV_SRSZ_SCALE_HY_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_SRSZ_SCALE_HY_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_SRSZ_SCALE_HCB
+#define MRV_SRSZ_SCALE_HCB_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_SRSZ_SCALE_HCB_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_SRSZ_SCALE_HCR
+#define MRV_SRSZ_SCALE_HCR_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_SRSZ_SCALE_HCR_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_SRSZ_SCALE_VY
+#define MRV_SRSZ_SCALE_VY_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_SRSZ_SCALE_VY_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_SRSZ_SCALE_VC
+#define MRV_SRSZ_SCALE_VC_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_SRSZ_SCALE_VC_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_SRSZ_PHASE_HY
+#define MRV_SRSZ_PHASE_HY_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_SRSZ_PHASE_HY_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_SRSZ_PHASE_HC
+#define MRV_SRSZ_PHASE_HC_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_SRSZ_PHASE_HC_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_SRSZ_PHASE_VY
+#define MRV_SRSZ_PHASE_VY_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_SRSZ_PHASE_VY_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_SRSZ_PHASE_VC
+#define MRV_SRSZ_PHASE_VC_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_SRSZ_PHASE_VC_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_SRSZ_SCALE_LUT_ADDR
+#define MRV_SRSZ_SCALE_LUT_ADDR_MASK 0x0000003F
+#define MRV_SRSZ_SCALE_LUT_ADDR_SHIFT 0
+
+#define MRV_SRSZ_SCALE_LUT
+#define MRV_SRSZ_SCALE_LUT_MASK 0x0000003F
+#define MRV_SRSZ_SCALE_LUT_SHIFT 0
+
+#define MRV_SRSZ_SCALE_VC_UP_SHD
+#define MRV_SRSZ_SCALE_VC_UP_SHD_MASK 0x00000080
+#define MRV_SRSZ_SCALE_VC_UP_SHD_SHIFT 7
+#define MRV_SRSZ_SCALE_VC_UP_SHD_UPSCALE   1
+#define MRV_SRSZ_SCALE_VC_UP_SHD_DOWNSCALE 0
+#define MRV_SRSZ_SCALE_VY_UP_SHD
+#define MRV_SRSZ_SCALE_VY_UP_SHD_MASK 0x00000040
+#define MRV_SRSZ_SCALE_VY_UP_SHD_SHIFT 6
+#define MRV_SRSZ_SCALE_VY_UP_SHD_UPSCALE   1
+#define MRV_SRSZ_SCALE_VY_UP_SHD_DOWNSCALE 0
+#define MRV_SRSZ_SCALE_HC_UP_SHD
+#define MRV_SRSZ_SCALE_HC_UP_SHD_MASK 0x00000020
+#define MRV_SRSZ_SCALE_HC_UP_SHD_SHIFT 5
+#define MRV_SRSZ_SCALE_HC_UP_SHD_UPSCALE   1
+#define MRV_SRSZ_SCALE_HC_UP_SHD_DOWNSCALE 0
+#define MRV_SRSZ_SCALE_HY_UP_SHD
+#define MRV_SRSZ_SCALE_HY_UP_SHD_MASK 0x00000010
+#define MRV_SRSZ_SCALE_HY_UP_SHD_SHIFT 4
+#define MRV_SRSZ_SCALE_HY_UP_SHD_UPSCALE   1
+#define MRV_SRSZ_SCALE_HY_UP_SHD_DOWNSCALE 0
+#define MRV_SRSZ_SCALE_VC_ENABLE_SHD
+#define MRV_SRSZ_SCALE_VC_ENABLE_SHD_MASK 0x00000008
+#define MRV_SRSZ_SCALE_VC_ENABLE_SHD_SHIFT 3
+#define MRV_SRSZ_SCALE_VY_ENABLE_SHD
+#define MRV_SRSZ_SCALE_VY_ENABLE_SHD_MASK 0x00000004
+#define MRV_SRSZ_SCALE_VY_ENABLE_SHD_SHIFT 2
+#define MRV_SRSZ_SCALE_HC_ENABLE_SHD
+#define MRV_SRSZ_SCALE_HC_ENABLE_SHD_MASK 0x00000002
+#define MRV_SRSZ_SCALE_HC_ENABLE_SHD_SHIFT 1
+#define MRV_SRSZ_SCALE_HY_ENABLE_SHD
+#define MRV_SRSZ_SCALE_HY_ENABLE_SHD_MASK 0x00000001
+#define MRV_SRSZ_SCALE_HY_ENABLE_SHD_SHIFT 0
+
+#define MRV_SRSZ_SCALE_HY_SHD
+#define MRV_SRSZ_SCALE_HY_SHD_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_SRSZ_SCALE_HY_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_SRSZ_SCALE_HCB_SHD
+#define MRV_SRSZ_SCALE_HCB_SHD_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_SRSZ_SCALE_HCB_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_SRSZ_SCALE_HCR_SHD
+#define MRV_SRSZ_SCALE_HCR_SHD_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_SRSZ_SCALE_HCR_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_SRSZ_SCALE_VY_SHD
+#define MRV_SRSZ_SCALE_VY_SHD_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_SRSZ_SCALE_VY_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_SRSZ_SCALE_VC_SHD
+#define MRV_SRSZ_SCALE_VC_SHD_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_SRSZ_SCALE_VC_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_SRSZ_PHASE_HY_SHD
+#define MRV_SRSZ_PHASE_HY_SHD_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_SRSZ_PHASE_HY_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_SRSZ_PHASE_HC_SHD
+#define MRV_SRSZ_PHASE_HC_SHD_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_SRSZ_PHASE_HC_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_SRSZ_PHASE_VY_SHD
+#define MRV_SRSZ_PHASE_VY_SHD_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_SRSZ_PHASE_VY_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_SRSZ_PHASE_VC_SHD
+#define MRV_SRSZ_PHASE_VC_SHD_MASK  MRV_RSZ_SCALE_MASK
+#define MRV_SRSZ_PHASE_VC_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
+
+#define MRV_MI_SP_OUTPUT_FORMAT
+#define MRV_MI_SP_OUTPUT_FORMAT_MASK 0x70000000
+#define MRV_MI_SP_OUTPUT_FORMAT_SHIFT 28
+#define MRV_MI_SP_OUTPUT_FORMAT_RGB888 6
+#define MRV_MI_SP_OUTPUT_FORMAT_RGB666 5
+#define MRV_MI_SP_OUTPUT_FORMAT_RGB565 4
+#define MRV_MI_SP_OUTPUT_FORMAT_YUV444 3
+#define MRV_MI_SP_OUTPUT_FORMAT_YUV422 2
+#define MRV_MI_SP_OUTPUT_FORMAT_YUV420 1
+#define MRV_MI_SP_OUTPUT_FORMAT_YUV400 0
+#define MRV_MI_SP_INPUT_FORMAT
+#define MRV_MI_SP_INPUT_FORMAT_MASK 0x0C000000
+#define MRV_MI_SP_INPUT_FORMAT_SHIFT 26
+#define MRV_MI_SP_INPUT_FORMAT_YUV444 3
+#define MRV_MI_SP_INPUT_FORMAT_YUV422 2
+#define MRV_MI_SP_INPUT_FORMAT_YUV420 1
+#define MRV_MI_SP_INPUT_FORMAT_YUV400 0
+#define MRV_MI_SP_WRITE_FORMAT
+#define MRV_MI_SP_WRITE_FORMAT_MASK 0x03000000
+#define MRV_MI_SP_WRITE_FORMAT_SHIFT 24
+#define MRV_MI_SP_WRITE_FORMAT_PLANAR      0
+#define MRV_MI_SP_WRITE_FORMAT_SEMIPLANAR  1
+#define MRV_MI_SP_WRITE_FORMAT_INTERLEAVED 2
+#define MRV_MI_MP_WRITE_FORMAT
+#define MRV_MI_MP_WRITE_FORMAT_MASK 0x00C00000
+#define MRV_MI_MP_WRITE_FORMAT_SHIFT 22
+#define MRV_MI_MP_WRITE_FORMAT_PLANAR      0
+#define MRV_MI_MP_WRITE_FORMAT_SEMIPLANAR  1
+#define MRV_MI_MP_WRITE_FORMAT_INTERLEAVED 2
+#define MRV_MI_MP_WRITE_FORMAT_RAW_8       0
+#define MRV_MI_MP_WRITE_FORMAT_RAW_12      2
+#define MRV_MI_INIT_OFFSET_EN
+#define MRV_MI_INIT_OFFSET_EN_MASK 0x00200000
+#define MRV_MI_INIT_OFFSET_EN_SHIFT 21
+
+#define MRV_MI_INIT_BASE_EN
+#define MRV_MI_INIT_BASE_EN_MASK 0x00100000
+#define MRV_MI_INIT_BASE_EN_SHIFT 20
+#define MRV_MI_BURST_LEN_CHROM
+#define MRV_MI_BURST_LEN_CHROM_MASK 0x000C0000
+#define MRV_MI_BURST_LEN_CHROM_SHIFT 18
+#define MRV_MI_BURST_LEN_CHROM_4      0
+#define MRV_MI_BURST_LEN_CHROM_8      1
+#define MRV_MI_BURST_LEN_CHROM_16     2
+
+#define MRV_MI_BURST_LEN_LUM
+#define MRV_MI_BURST_LEN_LUM_MASK 0x00030000
+#define MRV_MI_BURST_LEN_LUM_SHIFT 16
+#define MRV_MI_BURST_LEN_LUM_4      0
+#define MRV_MI_BURST_LEN_LUM_8      1
+#define MRV_MI_BURST_LEN_LUM_16     2
+
+#define MRV_MI_LAST_PIXEL_SIG_EN
+#define MRV_MI_LAST_PIXEL_SIG_EN_MASK 0x00008000
+#define MRV_MI_LAST_PIXEL_SIG_EN_SHIFT 15
+
+#define MRV_MI_422NONCOSITED
+#define MRV_MI_422NONCOSITED_MASK 0x00000400
+#define MRV_MI_422NONCOSITED_SHIFT 10
+#define MRV_MI_CBCR_FULL_RANGE
+#define MRV_MI_CBCR_FULL_RANGE_MASK 0x00000200
+#define MRV_MI_CBCR_FULL_RANGE_SHIFT 9
+#define MRV_MI_Y_FULL_RANGE
+#define MRV_MI_Y_FULL_RANGE_MASK 0x00000100
+#define MRV_MI_Y_FULL_RANGE_SHIFT 8
+#define MRV_MI_BYTE_SWAP
+#define MRV_MI_BYTE_SWAP_MASK 0x00000080
+#define MRV_MI_BYTE_SWAP_SHIFT 7
+#define MRV_MI_ROT
+#define MRV_MI_ROT_MASK 0x00000040
+#define MRV_MI_ROT_SHIFT 6
+#define MRV_MI_V_FLIP
+#define MRV_MI_V_FLIP_MASK 0x00000020
+#define MRV_MI_V_FLIP_SHIFT 5
+
+#define MRV_MI_H_FLIP
+#define MRV_MI_H_FLIP_MASK 0x00000010
+#define MRV_MI_H_FLIP_SHIFT 4
+#define MRV_MI_RAW_ENABLE
+#define MRV_MI_RAW_ENABLE_MASK 0x00000008
+#define MRV_MI_RAW_ENABLE_SHIFT 3
+#define MRV_MI_JPEG_ENABLE
+#define MRV_MI_JPEG_ENABLE_MASK 0x00000004
+#define MRV_MI_JPEG_ENABLE_SHIFT 2
+#define MRV_MI_SP_ENABLE
+#define MRV_MI_SP_ENABLE_MASK 0x00000002
+#define MRV_MI_SP_ENABLE_SHIFT 1
+#define MRV_MI_MP_ENABLE
+#define MRV_MI_MP_ENABLE_MASK 0x00000001
+#define MRV_MI_MP_ENABLE_SHIFT 0
+
+#define MRV_MI_ROT_AND_FLIP
+#define MRV_MI_ROT_AND_FLIP_MASK   \
+       (MRV_MI_H_FLIP_MASK | MRV_MI_V_FLIP_MASK | MRV_MI_ROT_MASK)
+#define MRV_MI_ROT_AND_FLIP_SHIFT  \
+       (MRV_MI_H_FLIP_SHIFT)
+#define MRV_MI_ROT_AND_FLIP_H_FLIP \
+       (MRV_MI_H_FLIP_MASK >> MRV_MI_ROT_AND_FLIP_SHIFT)
+#define MRV_MI_ROT_AND_FLIP_V_FLIP \
+       (MRV_MI_V_FLIP_MASK >> MRV_MI_ROT_AND_FLIP_SHIFT)
+#define MRV_MI_ROT_AND_FLIP_ROTATE \
+       (MRV_MI_ROT_MASK    >> MRV_MI_ROT_AND_FLIP_SHIFT)
+
+#define MRV_MI_MI_CFG_UPD
+#define MRV_MI_MI_CFG_UPD_MASK 0x00000010
+#define MRV_MI_MI_CFG_UPD_SHIFT 4
+#define MRV_MI_MI_SKIP
+#define MRV_MI_MI_SKIP_MASK 0x00000004
+#define MRV_MI_MI_SKIP_SHIFT 2
+
+#define MRV_MI_MP_Y_BASE_AD_INIT
+#define MRV_MI_MP_Y_BASE_AD_INIT_MASK 0xFFFFFFFC
+#define MRV_MI_MP_Y_BASE_AD_INIT_SHIFT 0
+#define MRV_MI_MP_Y_BASE_AD_INIT_VALID_MASK (MRV_MI_MP_Y_BASE_AD_INIT_MASK &\
+                                            ~0x00000003)
+#define MRV_MI_MP_Y_SIZE_INIT
+#define MRV_MI_MP_Y_SIZE_INIT_MASK 0x01FFFFFC
+#define MRV_MI_MP_Y_SIZE_INIT_SHIFT 0
+#define MRV_MI_MP_Y_SIZE_INIT_VALID_MASK (MRV_MI_MP_Y_SIZE_INIT_MASK &\
+                                         ~0x00000003)
+#define MRV_MI_MP_Y_OFFS_CNT_INIT
+#define MRV_MI_MP_Y_OFFS_CNT_INIT_MASK 0x01FFFFFC
+#define MRV_MI_MP_Y_OFFS_CNT_INIT_SHIFT 0
+#define MRV_MI_MP_Y_OFFS_CNT_INIT_VALID_MASK \
+       (MRV_MI_MP_Y_OFFS_CNT_INIT_MASK & ~0x00000003)
+
+#define MRV_MI_MP_Y_OFFS_CNT_START
+#define MRV_MI_MP_Y_OFFS_CNT_START_MASK 0x01FFFFFC
+#define MRV_MI_MP_Y_OFFS_CNT_START_SHIFT 0
+#define MRV_MI_MP_Y_OFFS_CNT_START_VALID_MASK \
+       (MRV_MI_MP_Y_OFFS_CNT_START_MASK & ~0x00000003)
+
+#define MRV_MI_MP_Y_IRQ_OFFS_INIT
+#define MRV_MI_MP_Y_IRQ_OFFS_INIT_MASK 0x01FFFFFC
+#define MRV_MI_MP_Y_IRQ_OFFS_INIT_SHIFT 0
+#define MRV_MI_MP_Y_IRQ_OFFS_INIT_VALID_MASK \
+       (MRV_MI_MP_Y_IRQ_OFFS_INIT_MASK & ~0x00000003)
+#define MRV_MI_MP_CB_BASE_AD_INIT
+#define MRV_MI_MP_CB_BASE_AD_INIT_MASK 0xFFFFFFFC
+#define MRV_MI_MP_CB_BASE_AD_INIT_SHIFT 0
+#define MRV_MI_MP_CB_BASE_AD_INIT_VALID_MASK \
+       (MRV_MI_MP_CB_BASE_AD_INIT_MASK & ~0x00000003)
+
+#define MRV_MI_MP_CB_SIZE_INIT
+#define MRV_MI_MP_CB_SIZE_INIT_MASK 0x00FFFFFC
+#define MRV_MI_MP_CB_SIZE_INIT_SHIFT 0
+#define MRV_MI_MP_CB_SIZE_INIT_VALID_MASK \
+       (MRV_MI_MP_CB_SIZE_INIT_MASK & ~0x00000003)
+
+#define MRV_MI_MP_CB_OFFS_CNT_INIT
+#define MRV_MI_MP_CB_OFFS_CNT_INIT_MASK 0x00FFFFFC
+#define MRV_MI_MP_CB_OFFS_CNT_INIT_SHIFT 0
+#define MRV_MI_MP_CB_OFFS_CNT_INIT_VALID_MASK \
+       (MRV_MI_MP_CB_OFFS_CNT_INIT_MASK & ~0x00000003)
+
+#define MRV_MI_MP_CB_OFFS_CNT_START
+#define MRV_MI_MP_CB_OFFS_CNT_START_MASK 0x00FFFFFC
+#define MRV_MI_MP_CB_OFFS_CNT_START_SHIFT 0
+#define MRV_MI_MP_CB_OFFS_CNT_START_VALID_MASK \
+       (MRV_MI_MP_CB_OFFS_CNT_START_MASK & ~0x00000003)
+
+#define MRV_MI_MP_CR_BASE_AD_INIT
+#define MRV_MI_MP_CR_BASE_AD_INIT_MASK 0xFFFFFFFC
+#define MRV_MI_MP_CR_BASE_AD_INIT_SHIFT 0
+#define MRV_MI_MP_CR_BASE_AD_INIT_VALID_MASK \
+       (MRV_MI_MP_CR_BASE_AD_INIT_MASK & ~0x00000003)
+
+#define MRV_MI_MP_CR_SIZE_INIT
+#define MRV_MI_MP_CR_SIZE_INIT_MASK 0x00FFFFFC
+#define MRV_MI_MP_CR_SIZE_INIT_SHIFT 0
+#define MRV_MI_MP_CR_SIZE_INIT_VALID_MASK \
+       (MRV_MI_MP_CR_SIZE_INIT_MASK & ~0x00000003)
+
+#define MRV_MI_MP_CR_OFFS_CNT_INIT
+#define MRV_MI_MP_CR_OFFS_CNT_INIT_MASK 0x00FFFFFC
+#define MRV_MI_MP_CR_OFFS_CNT_INIT_SHIFT 0
+#define MRV_MI_MP_CR_OFFS_CNT_INIT_VALID_MASK \
+       (MRV_MI_MP_CR_OFFS_CNT_INIT_MASK & ~0x00000003)
+
+#define MRV_MI_MP_CR_OFFS_CNT_START
+#define MRV_MI_MP_CR_OFFS_CNT_START_MASK 0x00FFFFFC
+#define MRV_MI_MP_CR_OFFS_CNT_START_SHIFT 0
+#define MRV_MI_MP_CR_OFFS_CNT_START_VALID_MASK \
+       (MRV_MI_MP_CR_OFFS_CNT_START_MASK & ~0x00000003)
+
+#define MRV_MI_SP_Y_BASE_AD_INIT
+#define MRV_MI_SP_Y_BASE_AD_INIT_MASK 0xFFFFFFFC
+#define MRV_MI_SP_Y_BASE_AD_INIT_SHIFT 0
+#define MRV_MI_SP_Y_BASE_AD_INIT_VALID_MASK \
+       (MRV_MI_SP_Y_BASE_AD_INIT_MASK & ~0x00000003)
+
+#define MRV_MI_SP_Y_SIZE_INIT
+#define MRV_MI_SP_Y_SIZE_INIT_MASK 0x01FFFFFC
+#define MRV_MI_SP_Y_SIZE_INIT_SHIFT 0
+#define MRV_MI_SP_Y_SIZE_INIT_VALID_MASK \
+       (MRV_MI_SP_Y_SIZE_INIT_MASK & ~0x00000003)
+
+#define MRV_MI_SP_Y_OFFS_CNT_INIT
+#define MRV_MI_SP_Y_OFFS_CNT_INIT_MASK 0x01FFFFFC
+#define MRV_MI_SP_Y_OFFS_CNT_INIT_SHIFT 0
+#define MRV_MI_SP_Y_OFFS_CNT_INIT_VALID_MASK \
+       (MRV_MI_SP_Y_OFFS_CNT_INIT_MASK & ~0x00000003)
+
+#define MRV_MI_SP_Y_OFFS_CNT_START
+#define MRV_MI_SP_Y_OFFS_CNT_START_MASK 0x01FFFFFC
+#define MRV_MI_SP_Y_OFFS_CNT_START_SHIFT 0
+#define MRV_MI_SP_Y_OFFS_CNT_START_VALID_MASK \
+       (MRV_MI_SP_Y_OFFS_CNT_START_MASK & ~0x00000003)
+
+#define MRV_MI_SP_Y_LLENGTH
+#define MRV_MI_SP_Y_LLENGTH_MASK 0x00001FFF
+#define MRV_MI_SP_Y_LLENGTH_SHIFT 0
+#define MRV_MI_SP_Y_LLENGTH_VALID_MASK \
+       (MRV_MI_SP_Y_LLENGTH_MASK & ~0x00000000)
+
+#define MRV_MI_SP_CB_BASE_AD_INIT
+#define MRV_MI_SP_CB_BASE_AD_INIT_MASK 0xFFFFFFFF
+#define MRV_MI_SP_CB_BASE_AD_INIT_SHIFT 0
+#define MRV_MI_SP_CB_BASE_AD_INIT_VALID_MASK \
+       (MRV_MI_SP_CB_BASE_AD_INIT_MASK & ~0x00000003)
+
+#define MRV_MI_SP_CB_SIZE_INIT
+#define MRV_MI_SP_CB_SIZE_INIT_MASK 0x00FFFFFF
+#define MRV_MI_SP_CB_SIZE_INIT_SHIFT 0
+#define MRV_MI_SP_CB_SIZE_INIT_VALID_MASK \
+       (MRV_MI_SP_CB_SIZE_INIT_MASK & ~0x00000003)
+
+#define MRV_MI_SP_CB_OFFS_CNT_INIT
+#define MRV_MI_SP_CB_OFFS_CNT_INIT_MASK 0x00FFFFFF
+#define MRV_MI_SP_CB_OFFS_CNT_INIT_SHIFT 0
+#define MRV_MI_SP_CB_OFFS_CNT_INIT_VALID_MASK \
+       (MRV_MI_SP_CB_OFFS_CNT_INIT_MASK & ~0x00000003)
+
+#define MRV_MI_SP_CB_OFFS_CNT_START
+#define MRV_MI_SP_CB_OFFS_CNT_START_MASK 0x00FFFFFF
+#define MRV_MI_SP_CB_OFFS_CNT_START_SHIFT 0
+#define MRV_MI_SP_CB_OFFS_CNT_START_VALID_MASK \
+       (MRV_MI_SP_CB_OFFS_CNT_START_MASK & ~0x00000003)
+
+#define MRV_MI_SP_CR_BASE_AD_INIT
+#define MRV_MI_SP_CR_BASE_AD_INIT_MASK 0xFFFFFFFF
+#define MRV_MI_SP_CR_BASE_AD_INIT_SHIFT 0
+#define MRV_MI_SP_CR_BASE_AD_INIT_VALID_MASK \
+       (MRV_MI_SP_CR_BASE_AD_INIT_MASK & ~0x00000003)
+
+#define MRV_MI_SP_CR_SIZE_INIT
+#define MRV_MI_SP_CR_SIZE_INIT_MASK 0x00FFFFFF
+#define MRV_MI_SP_CR_SIZE_INIT_SHIFT 0
+#define MRV_MI_SP_CR_SIZE_INIT_VALID_MASK \
+       (MRV_MI_SP_CR_SIZE_INIT_MASK & ~0x00000003)
+
+#define MRV_MI_SP_CR_OFFS_CNT_INIT
+#define MRV_MI_SP_CR_OFFS_CNT_INIT_MASK 0x00FFFFFF
+#define MRV_MI_SP_CR_OFFS_CNT_INIT_SHIFT 0
+#define MRV_MI_SP_CR_OFFS_CNT_INIT_VALID_MASK \
+       (MRV_MI_SP_CR_OFFS_CNT_INIT_MASK & ~0x00000003)
+
+#define MRV_MI_SP_CR_OFFS_CNT_START
+#define MRV_MI_SP_CR_OFFS_CNT_START_MASK 0x00FFFFFF
+#define MRV_MI_SP_CR_OFFS_CNT_START_SHIFT 0
+#define MRV_MI_SP_CR_OFFS_CNT_START_VALID_MASK \
+       (MRV_MI_SP_CR_OFFS_CNT_START_MASK & ~0x00000003)
+
+#define MRV_MI_BYTE_CNT
+#define MRV_MI_BYTE_CNT_MASK 0x01FFFFFF
+#define MRV_MI_BYTE_CNT_SHIFT 0
+
+#define MRV_MI_RAW_ENABLE_OUT
+#define MRV_MI_RAW_ENABLE_OUT_MASK 0x00080000
+#define MRV_MI_RAW_ENABLE_OUT_SHIFT 19
+#define MRV_MI_JPEG_ENABLE_OUT
+#define MRV_MI_JPEG_ENABLE_OUT_MASK 0x00040000
+#define MRV_MI_JPEG_ENABLE_OUT_SHIFT 18
+#define MRV_MI_SP_ENABLE_OUT
+#define MRV_MI_SP_ENABLE_OUT_MASK 0x00020000
+#define MRV_MI_SP_ENABLE_OUT_SHIFT 17
+#define MRV_MI_MP_ENABLE_OUT
+#define MRV_MI_MP_ENABLE_OUT_MASK 0x00010000
+#define MRV_MI_MP_ENABLE_OUT_SHIFT 16
+#define MRV_MI_RAW_ENABLE_IN
+#define MRV_MI_RAW_ENABLE_IN_MASK 0x00000020
+#define MRV_MI_RAW_ENABLE_IN_SHIFT 5
+#define MRV_MI_JPEG_ENABLE_IN
+#define MRV_MI_JPEG_ENABLE_IN_MASK 0x00000010
+#define MRV_MI_JPEG_ENABLE_IN_SHIFT 4
+#define MRV_MI_SP_ENABLE_IN
+#define MRV_MI_SP_ENABLE_IN_MASK 0x00000004
+#define MRV_MI_SP_ENABLE_IN_SHIFT 2
+#define MRV_MI_MP_ENABLE_IN
+#define MRV_MI_MP_ENABLE_IN_MASK 0x00000001
+#define MRV_MI_MP_ENABLE_IN_SHIFT 0
+
+#define MRV_MI_MP_Y_BASE_AD
+#define MRV_MI_MP_Y_BASE_AD_MASK 0xFFFFFFFC
+#define MRV_MI_MP_Y_BASE_AD_SHIFT 0
+#define MRV_MI_MP_Y_BASE_AD_VALID_MASK \
+       (MRV_MI_MP_Y_BASE_AD_MASK & ~0x00000003)
+
+#define MRV_MI_MP_Y_SIZE
+#define MRV_MI_MP_Y_SIZE_MASK 0x01FFFFFC
+#define MRV_MI_MP_Y_SIZE_SHIFT 0
+#define MRV_MI_MP_Y_SIZE_VALID_MASK (MRV_MI_MP_Y_SIZE_MASK & ~0x00000003)
+
+#define MRV_MI_MP_Y_OFFS_CNT
+#define MRV_MI_MP_Y_OFFS_CNT_MASK 0x01FFFFFC
+#define MRV_MI_MP_Y_OFFS_CNT_SHIFT 0
+#define MRV_MI_MP_Y_OFFS_CNT_VALID_MASK \
+       (MRV_MI_MP_Y_OFFS_CNT_MASK & ~0x00000003)
+
+#define MRV_MI_MP_Y_IRQ_OFFS
+#define MRV_MI_MP_Y_IRQ_OFFS_MASK 0x01FFFFFC
+#define MRV_MI_MP_Y_IRQ_OFFS_SHIFT 0
+#define MRV_MI_MP_Y_IRQ_OFFS_VALID_MASK \
+       (MRV_MI_MP_Y_IRQ_OFFS_MASK & ~0x00000003)
+
+#define MRV_MI_MP_CB_BASE_AD
+#define MRV_MI_MP_CB_BASE_AD_MASK 0xFFFFFFFF
+#define MRV_MI_MP_CB_BASE_AD_SHIFT 0
+#define MRV_MI_MP_CB_BASE_AD_VALID_MASK \
+       (MRV_MI_MP_CB_BASE_AD_MASK & ~0x00000003)
+
+#define MRV_MI_MP_CB_SIZE
+#define MRV_MI_MP_CB_SIZE_MASK 0x00FFFFFF
+#define MRV_MI_MP_CB_SIZE_SHIFT 0
+#define MRV_MI_MP_CB_SIZE_VALID_MASK (MRV_MI_MP_CB_SIZE_MASK & ~0x00000003)
+
+#define MRV_MI_MP_CB_OFFS_CNT
+#define MRV_MI_MP_CB_OFFS_CNT_MASK 0x00FFFFFF
+#define MRV_MI_MP_CB_OFFS_CNT_SHIFT 0
+#define MRV_MI_MP_CB_OFFS_CNT_VALID_MASK \
+       (MRV_MI_MP_CB_OFFS_CNT_MASK & ~0x00000003)
+
+#define MRV_MI_MP_CR_BASE_AD
+#define MRV_MI_MP_CR_BASE_AD_MASK 0xFFFFFFFF
+#define MRV_MI_MP_CR_BASE_AD_SHIFT 0
+#define MRV_MI_MP_CR_BASE_AD_VALID_MASK \
+       (MRV_MI_MP_CR_BASE_AD_MASK & ~0x00000003)
+
+#define MRV_MI_MP_CR_SIZE
+#define MRV_MI_MP_CR_SIZE_MASK 0x00FFFFFF
+#define MRV_MI_MP_CR_SIZE_SHIFT 0
+#define MRV_MI_MP_CR_SIZE_VALID_MASK (MRV_MI_MP_CR_SIZE_MASK & ~0x00000003)
+
+#define MRV_MI_MP_CR_OFFS_CNT
+#define MRV_MI_MP_CR_OFFS_CNT_MASK 0x00FFFFFF
+#define MRV_MI_MP_CR_OFFS_CNT_SHIFT 0
+#define MRV_MI_MP_CR_OFFS_CNT_VALID_MASK \
+       (MRV_MI_MP_CR_OFFS_CNT_MASK & ~0x00000003)
+
+#define MRV_MI_SP_Y_BASE_AD
+#define MRV_MI_SP_Y_BASE_AD_MASK 0xFFFFFFFF
+#define MRV_MI_SP_Y_BASE_AD_SHIFT 0
+#define MRV_MI_SP_Y_BASE_AD_VALID_MASK \
+       (MRV_MI_SP_Y_BASE_AD_MASK & ~0x00000003)
+
+#define MRV_MI_SP_Y_SIZE
+#define MRV_MI_SP_Y_SIZE_MASK 0x01FFFFFC
+#define MRV_MI_SP_Y_SIZE_SHIFT 0
+#define MRV_MI_SP_Y_SIZE_VALID_MASK (MRV_MI_SP_Y_SIZE_MASK & ~0x00000003)
+
+#define MRV_MI_SP_Y_OFFS_CNT
+#define MRV_MI_SP_Y_OFFS_CNT_MASK 0x01FFFFFC
+#define MRV_MI_SP_Y_OFFS_CNT_SHIFT 0
+#define MRV_MI_SP_Y_OFFS_CNT_VALID_MASK \
+       (MRV_MI_SP_Y_OFFS_CNT_MASK & ~0x00000003)
+
+#define MRV_MI_SP_CB_BASE_AD
+#define MRV_MI_SP_CB_BASE_AD_MASK 0xFFFFFFFF
+#define MRV_MI_SP_CB_BASE_AD_SHIFT 0
+#define MRV_MI_SP_CB_BASE_AD_VALID_MASK \
+       (MRV_MI_SP_CB_BASE_AD_MASK & ~0x00000003)
+
+#define MRV_MI_SP_CB_SIZE
+#define MRV_MI_SP_CB_SIZE_MASK 0x00FFFFFF
+#define MRV_MI_SP_CB_SIZE_SHIFT 0
+#define MRV_MI_SP_CB_SIZE_VALID_MASK (MRV_MI_SP_CB_SIZE_MASK & ~0x00000003)
+
+#define MRV_MI_SP_CB_OFFS_CNT
+#define MRV_MI_SP_CB_OFFS_CNT_MASK 0x00FFFFFF
+#define MRV_MI_SP_CB_OFFS_CNT_SHIFT 0
+#define MRV_MI_SP_CB_OFFS_CNT_VALID_MASK \
+       (MRV_MI_SP_CB_OFFS_CNT_MASK & ~0x00000003)
+
+#define MRV_MI_SP_CR_BASE_AD
+#define MRV_MI_SP_CR_BASE_AD_MASK 0xFFFFFFFF
+#define MRV_MI_SP_CR_BASE_AD_SHIFT 0
+#define MRV_MI_SP_CR_BASE_AD_VALID_MASK \
+       (MRV_MI_SP_CR_BASE_AD_MASK & ~0x00000003)
+
+#define MRV_MI_SP_CR_SIZE
+#define MRV_MI_SP_CR_SIZE_MASK 0x00FFFFFF
+#define MRV_MI_SP_CR_SIZE_SHIFT 0
+#define MRV_MI_SP_CR_SIZE_VALID_MASK (MRV_MI_SP_CR_SIZE_MASK & ~0x00000003)
+
+#define MRV_MI_SP_CR_OFFS_CNT
+#define MRV_MI_SP_CR_OFFS_CNT_MASK 0x00FFFFFF
+#define MRV_MI_SP_CR_OFFS_CNT_SHIFT 0
+#define MRV_MI_SP_CR_OFFS_CNT_VALID_MASK \
+       (MRV_MI_SP_CR_OFFS_CNT_MASK & ~0x00000003)
+
+
+#define MRV_MI_DMA_Y_PIC_START_AD
+#define MRV_MI_DMA_Y_PIC_START_AD_MASK 0xFFFFFFFF
+#define MRV_MI_DMA_Y_PIC_START_AD_SHIFT 0
+
+#define MRV_MI_DMA_Y_PIC_WIDTH
+#define MRV_MI_DMA_Y_PIC_WIDTH_MASK 0x00001FFF
+#define MRV_MI_DMA_Y_PIC_WIDTH_SHIFT 0
+
+#define MRV_MI_DMA_Y_LLENGTH
+#define MRV_MI_DMA_Y_LLENGTH_MASK 0x00001FFF
+#define MRV_MI_DMA_Y_LLENGTH_SHIFT 0
+
+#define MRV_MI_DMA_Y_PIC_SIZE
+#define MRV_MI_DMA_Y_PIC_SIZE_MASK 0x00FFFFFF
+#define MRV_MI_DMA_Y_PIC_SIZE_SHIFT 0
+
+#define MRV_MI_DMA_CB_PIC_START_AD
+#define MRV_MI_DMA_CB_PIC_START_AD_MASK 0xFFFFFFFF
+#define MRV_MI_DMA_CB_PIC_START_AD_SHIFT 0
+
+
+#define MRV_MI_DMA_CR_PIC_START_AD
+#define MRV_MI_DMA_CR_PIC_START_AD_MASK 0xFFFFFFFF
+#define MRV_MI_DMA_CR_PIC_START_AD_SHIFT 0
+
+
+#define MRV_MI_DMA_READY
+#define MRV_MI_DMA_READY_MASK 0x00000800
+#define MRV_MI_DMA_READY_SHIFT 11
+
+#define MRV_MI_AHB_ERROR
+
+#define MRV_MI_AHB_ERROR_MASK 0x00000400
+#define MRV_MI_AHB_ERROR_SHIFT 10
+#define MRV_MI_WRAP_SP_CR
+
+#define MRV_MI_WRAP_SP_CR_MASK 0x00000200
+#define MRV_MI_WRAP_SP_CR_SHIFT 9
+#define MRV_MI_WRAP_SP_CB
+
+#define MRV_MI_WRAP_SP_CB_MASK 0x00000100
+#define MRV_MI_WRAP_SP_CB_SHIFT 8
+#define MRV_MI_WRAP_SP_Y
+
+#define MRV_MI_WRAP_SP_Y_MASK 0x00000080
+#define MRV_MI_WRAP_SP_Y_SHIFT 7
+#define MRV_MI_WRAP_MP_CR
+
+#define MRV_MI_WRAP_MP_CR_MASK 0x00000040
+#define MRV_MI_WRAP_MP_CR_SHIFT 6
+#define MRV_MI_WRAP_MP_CB
+
+#define MRV_MI_WRAP_MP_CB_MASK 0x00000020
+#define MRV_MI_WRAP_MP_CB_SHIFT 5
+#define MRV_MI_WRAP_MP_Y
+
+#define MRV_MI_WRAP_MP_Y_MASK 0x00000010
+#define MRV_MI_WRAP_MP_Y_SHIFT 4
+#define MRV_MI_FILL_MP_Y
+
+#define MRV_MI_FILL_MP_Y_MASK 0x00000008
+#define MRV_MI_FILL_MP_Y_SHIFT 3
+#define MRV_MI_MBLK_LINE
+
+#define MRV_MI_MBLK_LINE_MASK 0x00000004
+#define MRV_MI_MBLK_LINE_SHIFT 2
+#define MRV_MI_SP_FRAME_END
+#define MRV_MI_SP_FRAME_END_MASK 0x00000002
+#define MRV_MI_SP_FRAME_END_SHIFT 1
+
+#define MRV_MI_MP_FRAME_END
+#define MRV_MI_MP_FRAME_END_MASK 0x00000001
+#define MRV_MI_MP_FRAME_END_SHIFT 0
+
+#ifndef MRV_MI_SP_FRAME_END
+#define MRV_MI_SP_FRAME_END_MASK 0
+#endif
+#ifndef MRV_MI_DMA_FRAME_END
+#define MRV_MI_DMA_FRAME_END_MASK 0
+#endif
+
+
+#define MRV_MI_ALLIRQS
+#define MRV_MI_ALLIRQS_MASK \
+(0 \
+| MRV_MI_DMA_READY_MASK \
+| MRV_MI_AHB_ERROR_MASK \
+| MRV_MI_WRAP_SP_CR_MASK \
+| MRV_MI_WRAP_SP_CB_MASK \
+| MRV_MI_WRAP_SP_Y_MASK \
+| MRV_MI_WRAP_MP_CR_MASK \
+| MRV_MI_WRAP_MP_CB_MASK \
+| MRV_MI_WRAP_MP_Y_MASK \
+| MRV_MI_FILL_MP_Y_MASK \
+| MRV_MI_MBLK_LINE_MASK \
+| MRV_MI_SP_FRAME_END_MASK \
+| MRV_MI_DMA_FRAME_END_MASK \
+| MRV_MI_MP_FRAME_END_MASK \
+)
+#define MRV_MI_ALLIRQS_SHIFT 0
+
+#define MRV_MI_AHB_READ_ERROR
+#define MRV_MI_AHB_READ_ERROR_MASK 0x00000200
+#define MRV_MI_AHB_READ_ERROR_SHIFT 9
+#define MRV_MI_AHB_WRITE_ERROR
+#define MRV_MI_AHB_WRITE_ERROR_MASK 0x00000100
+#define MRV_MI_AHB_WRITE_ERROR_SHIFT 8
+#define MRV_MI_SP_CR_FIFO_FULL
+#define MRV_MI_SP_CR_FIFO_FULL_MASK 0x00000040
+#define MRV_MI_SP_CR_FIFO_FULL_SHIFT 6
+#define MRV_MI_SP_CB_FIFO_FULL
+#define MRV_MI_SP_CB_FIFO_FULL_MASK 0x00000020
+#define MRV_MI_SP_CB_FIFO_FULL_SHIFT 5
+#define MRV_MI_SP_Y_FIFO_FULL
+#define MRV_MI_SP_Y_FIFO_FULL_MASK 0x00000010
+#define MRV_MI_SP_Y_FIFO_FULL_SHIFT 4
+#define MRV_MI_MP_CR_FIFO_FULL
+#define MRV_MI_MP_CR_FIFO_FULL_MASK 0x00000004
+#define MRV_MI_MP_CR_FIFO_FULL_SHIFT 2
+#define MRV_MI_MP_CB_FIFO_FULL
+#define MRV_MI_MP_CB_FIFO_FULL_MASK 0x00000002
+#define MRV_MI_MP_CB_FIFO_FULL_SHIFT 1
+#define MRV_MI_MP_Y_FIFO_FULL
+#define MRV_MI_MP_Y_FIFO_FULL_MASK 0x00000001
+#define MRV_MI_MP_Y_FIFO_FULL_SHIFT 0
+
+#define MRV_MI_ALL_STAT
+#define MRV_MI_ALL_STAT_MASK \
+(0 \
+| MRV_MI_AHB_READ_ERROR_MASK  \
+| MRV_MI_AHB_WRITE_ERROR_MASK \
+| MRV_MI_SP_CR_FIFO_FULL_MASK \
+| MRV_MI_SP_CB_FIFO_FULL_MASK \
+| MRV_MI_SP_Y_FIFO_FULL_MASK  \
+| MRV_MI_MP_CR_FIFO_FULL_MASK \
+| MRV_MI_MP_CB_FIFO_FULL_MASK \
+| MRV_MI_MP_Y_FIFO_FULL_MASK  \
+)
+#define MRV_MI_ALL_STAT_SHIFT 0
+
+#define MRV_MI_SP_Y_PIC_WIDTH
+#define MRV_MI_SP_Y_PIC_WIDTH_MASK 0x00000FFF
+#define MRV_MI_SP_Y_PIC_WIDTH_SHIFT 0
+
+#define MRV_MI_SP_Y_PIC_HEIGHT
+#define MRV_MI_SP_Y_PIC_HEIGHT_MASK 0x00000FFF
+#define MRV_MI_SP_Y_PIC_HEIGHT_SHIFT 0
+
+#define MRV_MI_SP_Y_PIC_SIZE
+#define MRV_MI_SP_Y_PIC_SIZE_MASK 0x01FFFFFF
+#define MRV_MI_SP_Y_PIC_SIZE_SHIFT 0
+
+#define MRV_MI_DMA_FRAME_END_DISABLE
+#define MRV_MI_DMA_FRAME_END_DISABLE_MASK 0x00000400
+#define MRV_MI_DMA_FRAME_END_DISABLE_SHIFT 10
+#define MRV_MI_DMA_CONTINUOUS_EN
+#define MRV_MI_DMA_CONTINUOUS_EN_MASK 0x00000200
+#define MRV_MI_DMA_CONTINUOUS_EN_SHIFT 9
+#define MRV_MI_DMA_BYTE_SWAP
+#define MRV_MI_DMA_BYTE_SWAP_MASK 0x00000100
+#define MRV_MI_DMA_BYTE_SWAP_SHIFT 8
+#define MRV_MI_DMA_INOUT_FORMAT
+#define MRV_MI_DMA_INOUT_FORMAT_MASK 0x000000C0
+#define MRV_MI_DMA_INOUT_FORMAT_SHIFT 6
+#define MRV_MI_DMA_INOUT_FORMAT_YUV444 3
+#define MRV_MI_DMA_INOUT_FORMAT_YUV422 2
+#define MRV_MI_DMA_INOUT_FORMAT_YUV420 1
+#define MRV_MI_DMA_INOUT_FORMAT_YUV400 0
+#define MRV_MI_DMA_READ_FORMAT
+#define MRV_MI_DMA_READ_FORMAT_MASK 0x00000030
+#define MRV_MI_DMA_READ_FORMAT_SHIFT 4
+#define MRV_MI_DMA_READ_FORMAT_PLANAR      0
+#define MRV_MI_DMA_READ_FORMAT_SEMIPLANAR  1
+#define MRV_MI_DMA_READ_FORMAT_INTERLEAVED 2
+#define MRV_MI_DMA_BURST_LEN_CHROM
+#define MRV_MI_DMA_BURST_LEN_CHROM_MASK 0x0000000C
+#define MRV_MI_DMA_BURST_LEN_CHROM_SHIFT 2
+#define MRV_MI_DMA_BURST_LEN_CHROM_4  0
+#define MRV_MI_DMA_BURST_LEN_CHROM_8  1
+#define MRV_MI_DMA_BURST_LEN_CHROM_16 2
+#define MRV_MI_DMA_BURST_LEN_LUM
+#define MRV_MI_DMA_BURST_LEN_LUM_MASK 0x00000003
+#define MRV_MI_DMA_BURST_LEN_LUM_SHIFT 0
+#define MRV_MI_DMA_BURST_LEN_LUM_4  0
+#define MRV_MI_DMA_BURST_LEN_LUM_8  1
+#define MRV_MI_DMA_BURST_LEN_LUM_16 2
+
+#define MRV_MI_DMA_START
+#define MRV_MI_DMA_START_MASK 0x00000001
+#define MRV_MI_DMA_START_SHIFT 0
+
+#define MRV_MI_DMA_ACTIVE
+#define MRV_MI_DMA_ACTIVE_MASK 0x00000001
+#define MRV_MI_DMA_ACTIVE_SHIFT 0
+
+#define MRV_JPE_GEN_HEADER
+#define MRV_JPE_GEN_HEADER_MASK 0x00000001
+#define MRV_JPE_GEN_HEADER_SHIFT 0
+
+#define MRV_JPE_CONT_MODE
+#define MRV_JPE_CONT_MODE_MASK 0x00000030
+#define MRV_JPE_CONT_MODE_SHIFT 4
+#define MRV_JPE_CONT_MODE_STOP   0
+#define MRV_JPE_CONT_MODE_NEXT   1
+#define MRV_JPE_CONT_MODE_HEADER 3
+#define MRV_JPE_ENCODE
+#define MRV_JPE_ENCODE_MASK 0x00000001
+#define MRV_JPE_ENCODE_SHIFT 0
+
+#define MRV_JPE_JP_INIT
+#define MRV_JPE_JP_INIT_MASK 0x00000001
+#define MRV_JPE_JP_INIT_SHIFT 0
+
+#define MRV_JPE_Y_SCALE_EN
+#define MRV_JPE_Y_SCALE_EN_MASK 0x00000001
+#define MRV_JPE_Y_SCALE_EN_SHIFT 0
+
+#define MRV_JPE_CBCR_SCALE_EN
+#define MRV_JPE_CBCR_SCALE_EN_MASK 0x00000001
+#define MRV_JPE_CBCR_SCALE_EN_SHIFT 0
+
+#define MRV_JPE_TABLE_FLUSH
+#define MRV_JPE_TABLE_FLUSH_MASK 0x00000001
+#define MRV_JPE_TABLE_FLUSH_SHIFT 0
+
+#define MRV_JPE_ENC_HSIZE
+#define MRV_JPE_ENC_HSIZE_MASK 0x00001FFF
+#define MRV_JPE_ENC_HSIZE_SHIFT 0
+
+#define MRV_JPE_ENC_VSIZE
+#define MRV_JPE_ENC_VSIZE_MASK 0x00000FFF
+#define MRV_JPE_ENC_VSIZE_SHIFT 0
+
+#define MRV_JPE_ENC_PIC_FORMAT
+#define MRV_JPE_ENC_PIC_FORMAT_MASK 0x00000007
+#define MRV_JPE_ENC_PIC_FORMAT_SHIFT 0
+#define MRV_JPE_ENC_PIC_FORMAT_422 1
+#define MRV_JPE_ENC_PIC_FORMAT_400 4
+
+#define MRV_JPE_RESTART_INTERVAL
+#define MRV_JPE_RESTART_INTERVAL_MASK 0x0000FFFF
+#define MRV_JPE_RESTART_INTERVAL_SHIFT 0
+
+#define MRV_JPE_TQ0_SELECT
+#define MRV_JPE_TQ0_SELECT_MASK 0x00000003
+#define MRV_JPE_TQ0_SELECT_SHIFT 0
+#define MRV_JPE_TQ1_SELECT
+#define MRV_JPE_TQ1_SELECT_MASK 0x00000003
+#define MRV_JPE_TQ1_SELECT_SHIFT 0
+
+#define MRV_JPE_TQ2_SELECT
+#define MRV_JPE_TQ2_SELECT_MASK 0x00000003
+#define MRV_JPE_TQ2_SELECT_SHIFT 0
+
+#define MRV_JPE_TQ_SELECT_TAB3 3
+#define MRV_JPE_TQ_SELECT_TAB2 2
+#define MRV_JPE_TQ_SELECT_TAB1 1
+#define MRV_JPE_TQ_SELECT_TAB0 0
+
+#define MRV_JPE_DC_TABLE_SELECT_Y
+#define MRV_JPE_DC_TABLE_SELECT_Y_MASK 0x00000001
+#define MRV_JPE_DC_TABLE_SELECT_Y_SHIFT 0
+#define MRV_JPE_DC_TABLE_SELECT_U
+#define MRV_JPE_DC_TABLE_SELECT_U_MASK 0x00000002
+#define MRV_JPE_DC_TABLE_SELECT_U_SHIFT 1
+#define MRV_JPE_DC_TABLE_SELECT_V
+#define MRV_JPE_DC_TABLE_SELECT_V_MASK 0x00000004
+#define MRV_JPE_DC_TABLE_SELECT_V_SHIFT 2
+
+#define MRV_JPE_AC_TABLE_SELECT_Y
+#define MRV_JPE_AC_TABLE_SELECT_Y_MASK 0x00000001
+#define MRV_JPE_AC_TABLE_SELECT_Y_SHIFT 0
+#define MRV_JPE_AC_TABLE_SELECT_U
+#define MRV_JPE_AC_TABLE_SELECT_U_MASK 0x00000002
+#define MRV_JPE_AC_TABLE_SELECT_U_SHIFT 1
+#define MRV_JPE_AC_TABLE_SELECT_V
+#define MRV_JPE_AC_TABLE_SELECT_V_MASK 0x00000004
+#define MRV_JPE_AC_TABLE_SELECT_V_SHIFT 2
+
+#define MRV_JPE_TABLE_WDATA_H
+#define MRV_JPE_TABLE_WDATA_H_MASK 0x0000FF00
+#define MRV_JPE_TABLE_WDATA_H_SHIFT 8
+#define MRV_JPE_TABLE_WDATA_L
+#define MRV_JPE_TABLE_WDATA_L_MASK 0x000000FF
+#define MRV_JPE_TABLE_WDATA_L_SHIFT 0
+
+#define MRV_JPE_TABLE_ID
+#define MRV_JPE_TABLE_ID_MASK 0x0000000F
+#define MRV_JPE_TABLE_ID_SHIFT 0
+#define MRV_JPE_TABLE_ID_QUANT0  0
+#define MRV_JPE_TABLE_ID_QUANT1  1
+#define MRV_JPE_TABLE_ID_QUANT2  2
+#define MRV_JPE_TABLE_ID_QUANT3  3
+#define MRV_JPE_TABLE_ID_VLC_DC0 4
+#define MRV_JPE_TABLE_ID_VLC_AC0 5
+#define MRV_JPE_TABLE_ID_VLC_DC1 6
+#define MRV_JPE_TABLE_ID_VLC_AC1 7
+
+#define MRV_JPE_TAC0_LEN
+#define MRV_JPE_TAC0_LEN_MASK 0x000000FF
+#define MRV_JPE_TAC0_LEN_SHIFT 0
+
+#define MRV_JPE_TDC0_LEN
+#define MRV_JPE_TDC0_LEN_MASK 0x000000FF
+#define MRV_JPE_TDC0_LEN_SHIFT 0
+
+#define MRV_JPE_TAC1_LEN
+#define MRV_JPE_TAC1_LEN_MASK 0x000000FF
+#define MRV_JPE_TAC1_LEN_SHIFT 0
+
+#define MRV_JPE_TDC1_LEN
+#define MRV_JPE_TDC1_LEN_MASK 0x000000FF
+#define MRV_JPE_TDC1_LEN_SHIFT 0
+
+#define MRV_JPE_CODEC_BUSY
+#define MRV_JPE_CODEC_BUSY_MASK 0x00000001
+#define MRV_JPE_CODEC_BUSY_SHIFT 0
+
+#define MRV_JPE_HEADER_MODE
+#define MRV_JPE_HEADER_MODE_MASK 0x00000003
+#define MRV_JPE_HEADER_MODE_SHIFT 0
+#define MRV_JPE_HEADER_MODE_NO    0
+#define MRV_JPE_HEADER_MODE_JFIF  2
+
+#define MRV_JPE_ENCODE_MODE
+#define MRV_JPE_ENCODE_MODE_MASK 0x00000001
+#define MRV_JPE_ENCODE_MODE_SHIFT 0
+
+#define MRV_JPE_DEB_BAD_TABLE_ACCESS
+#define MRV_JPE_DEB_BAD_TABLE_ACCESS_MASK 0x00000100
+#define MRV_JPE_DEB_BAD_TABLE_ACCESS_SHIFT 8
+#define MRV_JPE_DEB_VLC_TABLE_BUSY
+#define MRV_JPE_DEB_VLC_TABLE_BUSY_MASK 0x00000020
+#define MRV_JPE_DEB_VLC_TABLE_BUSY_SHIFT 5
+#define MRV_JPE_DEB_R2B_MEMORY_FULL
+#define MRV_JPE_DEB_R2B_MEMORY_FULL_MASK 0x00000010
+#define MRV_JPE_DEB_R2B_MEMORY_FULL_SHIFT 4
+#define MRV_JPE_DEB_VLC_ENCODE_BUSY
+#define MRV_JPE_DEB_VLC_ENCODE_BUSY_MASK 0x00000008
+#define MRV_JPE_DEB_VLC_ENCODE_BUSY_SHIFT 3
+#define MRV_JPE_DEB_QIQ_TABLE_ACC
+#define MRV_JPE_DEB_QIQ_TABLE_ACC_MASK 0x00000004
+#define MRV_JPE_DEB_QIQ_TABLE_ACC_SHIFT 2
+
+#define MRV_JPE_VLC_TABLE_ERR
+#define MRV_JPE_VLC_TABLE_ERR_MASK 0x00000400
+#define MRV_JPE_VLC_TABLE_ERR_SHIFT 10
+#define MRV_JPE_R2B_IMG_SIZE_ERR
+#define MRV_JPE_R2B_IMG_SIZE_ERR_MASK 0x00000200
+#define MRV_JPE_R2B_IMG_SIZE_ERR_SHIFT 9
+#define MRV_JPE_DCT_ERR
+#define MRV_JPE_DCT_ERR_MASK 0x00000080
+#define MRV_JPE_DCT_ERR_SHIFT 7
+#define MRV_JPE_VLC_SYMBOL_ERR
+#define MRV_JPE_VLC_SYMBOL_ERR_MASK 0x00000010
+#define MRV_JPE_VLC_SYMBOL_ERR_SHIFT 4
+
+#define MRV_JPE_ALL_ERR
+#define MRV_JPE_ALL_ERR_MASK \
+(0 \
+| MRV_JPE_VLC_TABLE_ERR_MASK \
+| MRV_JPE_R2B_IMG_SIZE_ERR_MASK \
+| MRV_JPE_DCT_ERR_MASK \
+| MRV_JPE_VLC_SYMBOL_ERR_MASK \
+)
+#define MRV_JPE_ALL_ERR_SHIFT 0
+
+#define MRV_JPE_GEN_HEADER_DONE
+#define MRV_JPE_GEN_HEADER_DONE_MASK 0x00000020
+#define MRV_JPE_GEN_HEADER_DONE_SHIFT 5
+#define MRV_JPE_ENCODE_DONE
+#define MRV_JPE_ENCODE_DONE_MASK 0x00000010
+#define MRV_JPE_ENCODE_DONE_SHIFT 4
+
+#define MRV_JPE_ALL_STAT
+#define MRV_JPE_ALL_STAT_MASK \
+(0 \
+| MRV_JPE_ENCODE_DONE_MASK \
+)
+#define MRV_JPE_ALL_STAT_SHIFT 0
+
+#define MRV_SMIA_DMA_CHANNEL_SEL
+#define MRV_SMIA_DMA_CHANNEL_SEL_MASK 0x00000700
+#define MRV_SMIA_DMA_CHANNEL_SEL_SHIFT 8
+#define MRV_SMIA_SHUTDOWN_LANE
+#define MRV_SMIA_SHUTDOWN_LANE_MASK 0x00000008
+#define MRV_SMIA_SHUTDOWN_LANE_SHIFT 3
+
+#define MRV_SMIA_FLUSH_FIFO
+#define MRV_SMIA_FLUSH_FIFO_MASK 0x00000002
+#define MRV_SMIA_FLUSH_FIFO_SHIFT 1
+
+#define MRV_SMIA_OUTPUT_ENA
+#define MRV_SMIA_OUTPUT_ENA_MASK 0x00000001
+#define MRV_SMIA_OUTPUT_ENA_SHIFT 0
+
+#define MRV_SMIA_DMA_CHANNEL
+#define MRV_SMIA_DMA_CHANNEL_MASK 0x00000700
+#define MRV_SMIA_DMA_CHANNEL_SHIFT 8
+#define MRV_SMIA_EMB_DATA_AVAIL
+#define MRV_SMIA_EMB_DATA_AVAIL_MASK 0x00000001
+#define MRV_SMIA_EMB_DATA_AVAIL_SHIFT 0
+
+#define MRV_SMIA_IMSC_FIFO_FILL_LEVEL
+#define MRV_SMIA_IMSC_FIFO_FILL_LEVEL_MASK 0x00000020
+#define MRV_SMIA_IMSC_FIFO_FILL_LEVEL_SHIFT 5
+
+#define MRV_SMIA_IMSC_SYNC_FIFO_OVFLW
+#define MRV_SMIA_IMSC_SYNC_FIFO_OVFLW_MASK 0x00000010
+#define MRV_SMIA_IMSC_SYNC_FIFO_OVFLW_SHIFT 4
+#define MRV_SMIA_IMSC_ERR_CS
+#define MRV_SMIA_IMSC_ERR_CS_MASK 0x00000008
+#define MRV_SMIA_IMSC_ERR_CS_SHIFT 3
+#define MRV_SMIA_IMSC_ERR_PROTOCOL
+#define MRV_SMIA_IMSC_ERR_PROTOCOL_MASK 0x00000004
+#define MRV_SMIA_IMSC_ERR_PROTOCOL_SHIFT 2
+
+#define MRV_SMIA_IMSC_EMB_DATA_OVFLW
+#define MRV_SMIA_IMSC_EMB_DATA_OVFLW_MASK 0x00000002
+#define MRV_SMIA_IMSC_EMB_DATA_OVFLW_SHIFT 1
+#define MRV_SMIA_IMSC_FRAME_END
+#define MRV_SMIA_IMSC_FRAME_END_MASK 0x00000001
+#define MRV_SMIA_IMSC_FRAME_END_SHIFT 0
+
+#define MRV_SMIA_IMSC_ALL_IRQS
+#define MRV_SMIA_IMSC_ALL_IRQS_MASK \
+(0 \
+| MRV_SMIA_IMSC_FIFO_FILL_LEVEL_MASK \
+| MRV_SMIA_IMSC_SYNC_FIFO_OVFLW_MASK \
+| MRV_SMIA_IMSC_ERR_CS_MASK \
+| MRV_SMIA_IMSC_ERR_PROTOCOL_MASK \
+| MRV_SMIA_IMSC_EMB_DATA_OVFLW_MASK \
+| MRV_SMIA_IMSC_FRAME_END_MASK \
+)
+#define MRV_SMIA_IMSC_ALL_IRQS_SHIFT 0
+
+#define MRV_SMIA_RIS_FIFO_FILL_LEVEL
+#define MRV_SMIA_RIS_FIFO_FILL_LEVEL_MASK 0x00000020
+#define MRV_SMIA_RIS_FIFO_FILL_LEVEL_SHIFT 5
+#define MRV_SMIA_RIS_SYNC_FIFO_OVFLW
+#define MRV_SMIA_RIS_SYNC_FIFO_OVFLW_MASK 0x00000010
+#define MRV_SMIA_RIS_SYNC_FIFO_OVFLW_SHIFT 4
+#define MRV_SMIA_RIS_ERR_CS
+#define MRV_SMIA_RIS_ERR_CS_MASK 0x00000008
+#define MRV_SMIA_RIS_ERR_CS_SHIFT 3
+#define MRV_SMIA_RIS_ERR_PROTOCOL
+#define MRV_SMIA_RIS_ERR_PROTOCOL_MASK 0x00000004
+#define MRV_SMIA_RIS_ERR_PROTOCOL_SHIFT 2
+
+#define MRV_SMIA_RIS_EMB_DATA_OVFLW
+#define MRV_SMIA_RIS_EMB_DATA_OVFLW_MASK 0x00000002
+#define MRV_SMIA_RIS_EMB_DATA_OVFLW_SHIFT 1
+#define MRV_SMIA_RIS_FRAME_END
+#define MRV_SMIA_RIS_FRAME_END_MASK 0x00000001
+#define MRV_SMIA_RIS_FRAME_END_SHIFT 0
+#define MRV_SMIA_RIS_ALL_IRQS
+#define MRV_SMIA_RIS_ALL_IRQS_MASK \
+(0 \
+| MRV_SMIA_RIS_FIFO_FILL_LEVEL_MASK \
+| MRV_SMIA_RIS_SYNC_FIFO_OVFLW_MASK \
+| MRV_SMIA_RIS_ERR_CS_MASK \
+| MRV_SMIA_RIS_ERR_PROTOCOL_MASK \
+| MRV_SMIA_RIS_EMB_DATA_OVFLW_MASK \
+| MRV_SMIA_RIS_FRAME_END_MASK \
+)
+#define MRV_SMIA_RIS_ALL_IRQS_SHIFT 0
+
+#define MRV_SMIA_MIS_FIFO_FILL_LEVEL
+#define MRV_SMIA_MIS_FIFO_FILL_LEVEL_MASK 0x00000020
+#define MRV_SMIA_MIS_FIFO_FILL_LEVEL_SHIFT 5
+#define MRV_SMIA_MIS_SYNC_FIFO_OVFLW
+#define MRV_SMIA_MIS_SYNC_FIFO_OVFLW_MASK 0x00000010
+#define MRV_SMIA_MIS_SYNC_FIFO_OVFLW_SHIFT 4
+#define MRV_SMIA_MIS_ERR_CS
+#define MRV_SMIA_MIS_ERR_CS_MASK 0x00000008
+#define MRV_SMIA_MIS_ERR_CS_SHIFT 3
+#define MRV_SMIA_MIS_ERR_PROTOCOL
+#define MRV_SMIA_MIS_ERR_PROTOCOL_MASK 0x00000004
+#define MRV_SMIA_MIS_ERR_PROTOCOL_SHIFT 2
+
+#define MRV_SMIA_MIS_EMB_DATA_OVFLW
+#define MRV_SMIA_MIS_EMB_DATA_OVFLW_MASK 0x00000002
+#define MRV_SMIA_MIS_EMB_DATA_OVFLW_SHIFT 1
+#define MRV_SMIA_MIS_FRAME_END
+#define MRV_SMIA_MIS_FRAME_END_MASK 0x00000001
+#define MRV_SMIA_MIS_FRAME_END_SHIFT 0
+
+#define MRV_SMIA_MIS_ALL_IRQS
+#define MRV_SMIA_MIS_ALL_IRQS_MASK \
+(0 \
+| MRV_SMIA_MIS_FIFO_FILL_LEVEL_MASK \
+| MRV_SMIA_MIS_SYNC_FIFO_OVFLW_MASK \
+| MRV_SMIA_MIS_ERR_CS_MASK \
+| MRV_SMIA_MIS_ERR_PROTOCOL_MASK \
+| MRV_SMIA_MIS_EMB_DATA_OVFLW_MASK \
+| MRV_SMIA_MIS_FRAME_END_MASK \
+)
+#define MRV_SMIA_MIS_ALL_IRQS_SHIFT 0
+
+
+#define MRV_SMIA_ICR_FIFO_FILL_LEVEL
+#define MRV_SMIA_ICR_FIFO_FILL_LEVEL_MASK 0x00000020
+#define MRV_SMIA_ICR_FIFO_FILL_LEVEL_SHIFT 5
+#define MRV_SMIA_ICR_SYNC_FIFO_OVFLW
+#define MRV_SMIA_ICR_SYNC_FIFO_OVFLW_MASK 0x00000010
+#define MRV_SMIA_ICR_SYNC_FIFO_OVFLW_SHIFT 4
+#define MRV_SMIA_ICR_ERR_CS
+#define MRV_SMIA_ICR_ERR_CS_MASK 0x00000008
+#define MRV_SMIA_ICR_ERR_CS_SHIFT 3
+#define MRV_SMIA_ICR_ERR_PROTOCOL
+#define MRV_SMIA_ICR_ERR_PROTOCOL_MASK 0x00000004
+#define MRV_SMIA_ICR_ERR_PROTOCOL_SHIFT 2
+
+#define MRV_SMIA_ICR_EMB_DATA_OVFLW
+#define MRV_SMIA_ICR_EMB_DATA_OVFLW_MASK 0x00000002
+#define MRV_SMIA_ICR_EMB_DATA_OVFLW_SHIFT 1
+#define MRV_SMIA_ICR_FRAME_END
+#define MRV_SMIA_ICR_FRAME_END_MASK 0x00000001
+#define MRV_SMIA_ICR_FRAME_END_SHIFT 0
+
+#define MRV_SMIA_ICR_ALL_IRQS
+#define MRV_SMIA_ICR_ALL_IRQS_MASK \
+(0 \
+| MRV_SMIA_ICR_FIFO_FILL_LEVEL_MASK \
+| MRV_SMIA_ICR_SYNC_FIFO_OVFLW_MASK \
+| MRV_SMIA_ICR_ERR_CS_MASK \
+| MRV_SMIA_ICR_ERR_PROTOCOL_MASK \
+| MRV_SMIA_ICR_EMB_DATA_OVFLW_MASK \
+| MRV_SMIA_ICR_FRAME_END_MASK \
+)
+#define MRV_SMIA_ICR_ALL_IRQS_SHIFT 0
+
+
+#define MRV_SMIA_ISR_FIFO_FILL_LEVEL
+#define MRV_SMIA_ISR_FIFO_FILL_LEVEL_MASK 0x00000020
+#define MRV_SMIA_ISR_FIFO_FILL_LEVEL_SHIFT 5
+#define MRV_SMIA_ISR_SYNC_FIFO_OVFLW
+#define MRV_SMIA_ISR_SYNC_FIFO_OVFLW_MASK 0x00000010
+#define MRV_SMIA_ISR_SYNC_FIFO_OVFLW_SHIFT 4
+#define MRV_SMIA_ISR_ERR_CS
+#define MRV_SMIA_ISR_ERR_CS_MASK 0x00000008
+#define MRV_SMIA_ISR_ERR_CS_SHIFT 3
+#define MRV_SMIA_ISR_ERR_PROTOCOL
+#define MRV_SMIA_ISR_ERR_PROTOCOL_MASK 0x00000004
+#define MRV_SMIA_ISR_ERR_PROTOCOL_SHIFT 2
+
+#define MRV_SMIA_ISR_EMB_DATA_OVFLW
+#define MRV_SMIA_ISR_EMB_DATA_OVFLW_MASK 0x00000002
+#define MRV_SMIA_ISR_EMB_DATA_OVFLW_SHIFT 1
+#define MRV_SMIA_ISR_FRAME_END
+#define MRV_SMIA_ISR_FRAME_END_MASK 0x00000001
+#define MRV_SMIA_ISR_FRAME_END_SHIFT 0
+
+#define MRV_SMIA_ISR_ALL_IRQS
+#define MRV_SMIA_ISR_ALL_IRQS_MASK \
+(0 \
+| MRV_SMIA_ISR_FIFO_FILL_LEVEL_MASK \
+| MRV_SMIA_ISR_SYNC_FIFO_OVFLW_MASK \
+| MRV_SMIA_ISR_ERR_CS_MASK \
+| MRV_SMIA_ISR_ERR_PROTOCOL_MASK \
+| MRV_SMIA_ISR_EMB_DATA_OVFLW_MASK \
+| MRV_SMIA_ISR_FRAME_END_MASK \
+)
+#define MRV_SMIA_ISR_ALL_IRQS_SHIFT 0
+
+#define MRV_SMIA_DATA_FORMAT_SEL
+#define MRV_SMIA_DATA_FORMAT_SEL_MASK 0x0000000F
+#define MRV_SMIA_DATA_FORMAT_SEL_SHIFT 0
+#define MRV_SMIA_DATA_FORMAT_SEL_YUV422      0
+#define MRV_SMIA_DATA_FORMAT_SEL_YUV420      1
+#define MRV_SMIA_DATA_FORMAT_SEL_RGB444      4
+#define MRV_SMIA_DATA_FORMAT_SEL_RGB565      5
+#define MRV_SMIA_DATA_FORMAT_SEL_RGB888      6
+#define MRV_SMIA_DATA_FORMAT_SEL_RAW6        8
+#define MRV_SMIA_DATA_FORMAT_SEL_RAW7        9
+#define MRV_SMIA_DATA_FORMAT_SEL_RAW8       10
+#define MRV_SMIA_DATA_FORMAT_SEL_RAW10      11
+#define MRV_SMIA_DATA_FORMAT_SEL_RAW12      12
+#define MRV_SMIA_DATA_FORMAT_SEL_RAW8TO10   13
+#define MRV_SMIA_DATA_FORMAT_SEL_COMPRESSED 15
+
+
+#define MRV_SMIA_SOF_EMB_DATA_LINES
+#define MRV_SMIA_SOF_EMB_DATA_LINES_MASK 0x00000007
+#define MRV_SMIA_SOF_EMB_DATA_LINES_SHIFT 0
+#define MRV_SMIA_SOF_EMB_DATA_LINES_MIN  0
+#define MRV_SMIA_SOF_EMB_DATA_LINES_MAX \
+       (MRV_SMIA_SOF_EMB_DATA_LINES_MASK >> MRV_SMIA_SOF_EMB_DATA_LINES_SHIFT)
+#define MRV_SMIA_EMB_HSTART
+#define MRV_SMIA_EMB_HSTART_MASK 0x00003FFF
+#define MRV_SMIA_EMB_HSTART_SHIFT 0
+#define MRV_SMIA_EMB_HSTART_VALID_MASK (MRV_SMIA_EMB_HSTART_MASK & ~0x00000003)
+
+#define MRV_SMIA_EMB_HSIZE
+#define MRV_SMIA_EMB_HSIZE_MASK 0x00003FFF
+#define MRV_SMIA_EMB_HSIZE_SHIFT 0
+#define MRV_SMIA_EMB_HSIZE_VALID_MASK (MRV_SMIA_EMB_HSIZE_MASK & ~0x00000003)
+
+#define MRV_SMIA_EMB_VSTART
+#define MRV_SMIA_EMB_VSTART_MASK 0x00000FFF
+#define MRV_SMIA_EMB_VSTART_SHIFT 0
+
+#define MRV_SMIA_NUM_LINES
+#define MRV_SMIA_NUM_LINES_MASK 0x00000FFF
+
+#define MRV_SMIA_NUM_LINES_SHIFT 0
+#define MRV_SMIA_NUM_LINES_MIN  1
+#define MRV_SMIA_NUM_LINES_MAX \
+       (MRV_SMIA_NUM_LINES_MASK >> MRV_SMIA_NUM_LINES_SHIFT)
+
+#define MRV_SMIA_EMB_DATA_FIFO
+#define MRV_SMIA_EMB_DATA_FIFO_MASK 0xFFFFFFFF
+#define MRV_SMIA_EMB_DATA_FIFO_SHIFT 0
+
+#define MRV_SMIA_FIFO_FILL_LEVEL
+#define MRV_SMIA_FIFO_FILL_LEVEL_MASK 0x000003FF
+#define MRV_SMIA_FIFO_FILL_LEVEL_SHIFT 0
+#define MRV_SMIA_FIFO_FILL_LEVEL_VALID_MASK \
+       (MRV_SMIA_FIFO_FILL_LEVEL_MASK & ~0x00000003)
+
+#define MRV_MIPI_ERR_SOT_SYNC_HS_SKIP
+#define MRV_MIPI_ERR_SOT_SYNC_HS_SKIP_MASK 0x00020000
+#define MRV_MIPI_ERR_SOT_SYNC_HS_SKIP_SHIFT 17
+#define MRV_MIPI_ERR_SOT_HS_SKIP
+#define MRV_MIPI_ERR_SOT_HS_SKIP_MASK 0x00010000
+#define MRV_MIPI_ERR_SOT_HS_SKIP_SHIFT 16
+
+#define MRV_MIPI_NUM_LANES
+#define MRV_MIPI_NUM_LANES_MASK 0x00003000
+#define MRV_MIPI_NUM_LANES_SHIFT 12
+#define MRV_MIPI_SHUTDOWN_LANE
+#define MRV_MIPI_SHUTDOWN_LANE_MASK 0x00000F00
+#define MRV_MIPI_SHUTDOWN_LANE_SHIFT 8
+#define MRV_MIPI_FLUSH_FIFO
+#define MRV_MIPI_FLUSH_FIFO_MASK 0x00000002
+#define MRV_MIPI_FLUSH_FIFO_SHIFT 1
+#define MRV_MIPI_OUTPUT_ENA
+#define MRV_MIPI_OUTPUT_ENA_MASK 0x00000001
+#define MRV_MIPI_OUTPUT_ENA_SHIFT 0
+
+#define MRV_MIPI_STOPSTATE
+#define MRV_MIPI_STOPSTATE_MASK 0x00000F00
+#define MRV_MIPI_STOPSTATE_SHIFT 8
+#define MRV_MIPI_ADD_DATA_AVAIL
+#define MRV_MIPI_ADD_DATA_AVAIL_MASK 0x00000001
+#define MRV_MIPI_ADD_DATA_AVAIL_SHIFT 0
+
+#define MRV_MIPI_IMSC_ADD_DATA_FILL_LEVEL
+#define MRV_MIPI_IMSC_ADD_DATA_FILL_LEVEL_MASK 0x04000000
+#define MRV_MIPI_IMSC_ADD_DATA_FILL_LEVEL_SHIFT 26
+#define MRV_MIPI_IMSC_ADD_DATA_OVFLW
+#define MRV_MIPI_IMSC_ADD_DATA_OVFLW_MASK 0x02000000
+#define MRV_MIPI_IMSC_ADD_DATA_OVFLW_SHIFT 25
+#define MRV_MIPI_IMSC_FRAME_END
+#define MRV_MIPI_IMSC_FRAME_END_MASK 0x01000000
+#define MRV_MIPI_IMSC_FRAME_END_SHIFT 24
+#define MRV_MIPI_IMSC_ERR_CS
+#define MRV_MIPI_IMSC_ERR_CS_MASK 0x00800000
+#define MRV_MIPI_IMSC_ERR_CS_SHIFT 23
+#define MRV_MIPI_IMSC_ERR_ECC1
+#define MRV_MIPI_IMSC_ERR_ECC1_MASK 0x00400000
+#define MRV_MIPI_IMSC_ERR_ECC1_SHIFT 22
+#define MRV_MIPI_IMSC_ERR_ECC2
+#define MRV_MIPI_IMSC_ERR_ECC2_MASK 0x00200000
+#define MRV_MIPI_IMSC_ERR_ECC2_SHIFT 21
+#define MRV_MIPI_IMSC_ERR_PROTOCOL
+#define MRV_MIPI_IMSC_ERR_PROTOCOL_MASK 0x00100000
+#define MRV_MIPI_IMSC_ERR_PROTOCOL_SHIFT 20
+#define MRV_MIPI_IMSC_ERR_CONTROL
+#define MRV_MIPI_IMSC_ERR_CONTROL_MASK 0x000F0000
+#define MRV_MIPI_IMSC_ERR_CONTROL_SHIFT 16
+
+#define MRV_MIPI_IMSC_ERR_EOT_SYNC
+#define MRV_MIPI_IMSC_ERR_EOT_SYNC_MASK 0x0000F000
+#define MRV_MIPI_IMSC_ERR_EOT_SYNC_SHIFT 12
+#define MRV_MIPI_IMSC_ERR_SOT_SYNC
+#define MRV_MIPI_IMSC_ERR_SOT_SYNC_MASK 0x00000F00
+#define MRV_MIPI_IMSC_ERR_SOT_SYNC_SHIFT 8
+#define MRV_MIPI_IMSC_ERR_SOT
+#define MRV_MIPI_IMSC_ERR_SOT_MASK 0x000000F0
+#define MRV_MIPI_IMSC_ERR_SOT_SHIFT 4
+#define MRV_MIPI_IMSC_SYNC_FIFO_OVFLW
+#define MRV_MIPI_IMSC_SYNC_FIFO_OVFLW_MASK 0x0000000F
+#define MRV_MIPI_IMSC_SYNC_FIFO_OVFLW_SHIFT 0
+
+#define MRV_MIPI_IMSC_ALL_IRQS
+#define MRV_MIPI_IMSC_ALL_IRQS_MASK \
+(0 \
+| MRV_MIPI_IMSC_ADD_DATA_FILL_LEVEL_MASK \
+| MRV_MIPI_IMSC_ADD_DATA_OVFLW_MASK \
+| MRV_MIPI_IMSC_FRAME_END_MASK \
+| MRV_MIPI_IMSC_ERR_CS_MASK \
+| MRV_MIPI_IMSC_ERR_ECC1_MASK \
+| MRV_MIPI_IMSC_ERR_ECC2_MASK \
+| MRV_MIPI_IMSC_ERR_PROTOCOL_MASK \
+| MRV_MIPI_IMSC_ERR_CONTROL_MASK \
+| MRV_MIPI_IMSC_ERR_EOT_SYNC_MASK \
+| MRV_MIPI_IMSC_ERR_SOT_SYNC_MASK \
+| MRV_MIPI_IMSC_ERR_SOT_MASK \
+| MRV_MIPI_IMSC_SYNC_FIFO_OVFLW_MASK \
+)
+#define MRV_MIPI_IMSC_ALL_IRQS_SHIFT 0
+
+#define MRV_MIPI_RIS_ADD_DATA_FILL_LEVEL
+#define MRV_MIPI_RIS_ADD_DATA_FILL_LEVEL_MASK 0x04000000
+#define MRV_MIPI_RIS_ADD_DATA_FILL_LEVEL_SHIFT 26
+#define MRV_MIPI_RIS_ADD_DATA_OVFLW
+#define MRV_MIPI_RIS_ADD_DATA_OVFLW_MASK 0x02000000
+#define MRV_MIPI_RIS_ADD_DATA_OVFLW_SHIFT 25
+#define MRV_MIPI_RIS_FRAME_END
+#define MRV_MIPI_RIS_FRAME_END_MASK 0x01000000
+#define MRV_MIPI_RIS_FRAME_END_SHIFT 24
+#define MRV_MIPI_RIS_ERR_CS
+#define MRV_MIPI_RIS_ERR_CS_MASK 0x00800000
+#define MRV_MIPI_RIS_ERR_CS_SHIFT 23
+#define MRV_MIPI_RIS_ERR_ECC1
+#define MRV_MIPI_RIS_ERR_ECC1_MASK 0x00400000
+#define MRV_MIPI_RIS_ERR_ECC1_SHIFT 22
+#define MRV_MIPI_RIS_ERR_ECC2
+#define MRV_MIPI_RIS_ERR_ECC2_MASK 0x00200000
+#define MRV_MIPI_RIS_ERR_ECC2_SHIFT 21
+#define MRV_MIPI_RIS_ERR_PROTOCOL
+#define MRV_MIPI_RIS_ERR_PROTOCOL_MASK 0x00100000
+#define MRV_MIPI_RIS_ERR_PROTOCOL_SHIFT 20
+#define MRV_MIPI_RIS_ERR_CONTROL
+#define MRV_MIPI_RIS_ERR_CONTROL_MASK 0x000F0000
+#define MRV_MIPI_RIS_ERR_CONTROL_SHIFT 16
+#define MRV_MIPI_RIS_ERR_EOT_SYNC
+#define MRV_MIPI_RIS_ERR_EOT_SYNC_MASK 0x0000F000
+#define MRV_MIPI_RIS_ERR_EOT_SYNC_SHIFT 12
+#define MRV_MIPI_RIS_ERR_SOT_SYNC
+#define MRV_MIPI_RIS_ERR_SOT_SYNC_MASK 0x00000F00
+#define MRV_MIPI_RIS_ERR_SOT_SYNC_SHIFT 8
+#define MRV_MIPI_RIS_ERR_SOT
+#define MRV_MIPI_RIS_ERR_SOT_MASK 0x000000F0
+#define MRV_MIPI_RIS_ERR_SOT_SHIFT 4
+#define MRV_MIPI_RIS_SYNC_FIFO_OVFLW
+#define MRV_MIPI_RIS_SYNC_FIFO_OVFLW_MASK 0x0000000F
+#define MRV_MIPI_RIS_SYNC_FIFO_OVFLW_SHIFT 0
+
+#define MRV_MIPI_RIS_ALL_IRQS
+#define MRV_MIPI_RIS_ALL_IRQS_MASK \
+(0 \
+| MRV_MIPI_RIS_ADD_DATA_FILL_LEVEL_MASK \
+| MRV_MIPI_RIS_ADD_DATA_OVFLW_MASK \
+| MRV_MIPI_RIS_FRAME_END_MASK \
+| MRV_MIPI_RIS_ERR_CS_MASK \
+| MRV_MIPI_RIS_ERR_ECC1_MASK \
+| MRV_MIPI_RIS_ERR_ECC2_MASK \
+| MRV_MIPI_RIS_ERR_PROTOCOL_MASK \
+| MRV_MIPI_RIS_ERR_CONTROL_MASK \
+| MRV_MIPI_RIS_ERR_EOT_SYNC_MASK \
+| MRV_MIPI_RIS_ERR_SOT_SYNC_MASK \
+| MRV_MIPI_RIS_ERR_SOT_MASK \
+| MRV_MIPI_RIS_SYNC_FIFO_OVFLW_MASK \
+)
+#define MRV_MIPI_RIS_ALL_IRQS_SHIFT 0
+
+#define MRV_MIPI_MIS_ADD_DATA_FILL_LEVEL
+#define MRV_MIPI_MIS_ADD_DATA_FILL_LEVEL_MASK 0x04000000
+#define MRV_MIPI_MIS_ADD_DATA_FILL_LEVEL_SHIFT 26
+#define MRV_MIPI_MIS_ADD_DATA_OVFLW
+#define MRV_MIPI_MIS_ADD_DATA_OVFLW_MASK 0x02000000
+#define MRV_MIPI_MIS_ADD_DATA_OVFLW_SHIFT 25
+#define MRV_MIPI_MIS_FRAME_END
+#define MRV_MIPI_MIS_FRAME_END_MASK 0x01000000
+#define MRV_MIPI_MIS_FRAME_END_SHIFT 24
+#define MRV_MIPI_MIS_ERR_CS
+#define MRV_MIPI_MIS_ERR_CS_MASK 0x00800000
+#define MRV_MIPI_MIS_ERR_CS_SHIFT 23
+#define MRV_MIPI_MIS_ERR_ECC1
+#define MRV_MIPI_MIS_ERR_ECC1_MASK 0x00400000
+#define MRV_MIPI_MIS_ERR_ECC1_SHIFT 22
+#define MRV_MIPI_MIS_ERR_ECC2
+#define MRV_MIPI_MIS_ERR_ECC2_MASK 0x00200000
+#define MRV_MIPI_MIS_ERR_ECC2_SHIFT 21
+#define MRV_MIPI_MIS_ERR_PROTOCOL
+#define MRV_MIPI_MIS_ERR_PROTOCOL_MASK 0x00100000
+#define MRV_MIPI_MIS_ERR_PROTOCOL_SHIFT 20
+#define MRV_MIPI_MIS_ERR_CONTROL
+#define MRV_MIPI_MIS_ERR_CONTROL_MASK 0x000F0000
+#define MRV_MIPI_MIS_ERR_CONTROL_SHIFT 16
+#define MRV_MIPI_MIS_ERR_EOT_SYNC
+#define MRV_MIPI_MIS_ERR_EOT_SYNC_MASK 0x0000F000
+#define MRV_MIPI_MIS_ERR_EOT_SYNC_SHIFT 12
+#define MRV_MIPI_MIS_ERR_SOT_SYNC
+#define MRV_MIPI_MIS_ERR_SOT_SYNC_MASK 0x00000F00
+#define MRV_MIPI_MIS_ERR_SOT_SYNC_SHIFT 8
+#define MRV_MIPI_MIS_ERR_SOT
+#define MRV_MIPI_MIS_ERR_SOT_MASK 0x000000F0
+#define MRV_MIPI_MIS_ERR_SOT_SHIFT 4
+#define MRV_MIPI_MIS_SYNC_FIFO_OVFLW
+#define MRV_MIPI_MIS_SYNC_FIFO_OVFLW_MASK 0x0000000F
+#define MRV_MIPI_MIS_SYNC_FIFO_OVFLW_SHIFT 0
+
+#define MRV_MIPI_MIS_ALL_IRQS
+#define MRV_MIPI_MIS_ALL_IRQS_MASK \
+(0 \
+| MRV_MIPI_MIS_ADD_DATA_FILL_LEVEL_MASK \
+| MRV_MIPI_MIS_ADD_DATA_OVFLW_MASK \
+| MRV_MIPI_MIS_FRAME_END_MASK \
+| MRV_MIPI_MIS_ERR_CS_MASK \
+| MRV_MIPI_MIS_ERR_ECC1_MASK \
+| MRV_MIPI_MIS_ERR_ECC2_MASK \
+| MRV_MIPI_MIS_ERR_PROTOCOL_MASK \
+| MRV_MIPI_MIS_ERR_CONTROL_MASK \
+| MRV_MIPI_MIS_ERR_EOT_SYNC_MASK \
+| MRV_MIPI_MIS_ERR_SOT_SYNC_MASK \
+| MRV_MIPI_MIS_ERR_SOT_MASK \
+| MRV_MIPI_MIS_SYNC_FIFO_OVFLW_MASK \
+)
+#define MRV_MIPI_MIS_ALL_IRQS_SHIFT 0
+
+#define MRV_MIPI_ICR_ADD_DATA_FILL_LEVEL
+#define MRV_MIPI_ICR_ADD_DATA_FILL_LEVEL_MASK 0x04000000
+#define MRV_MIPI_ICR_ADD_DATA_FILL_LEVEL_SHIFT 26
+#define MRV_MIPI_ICR_ADD_DATA_OVFLW
+#define MRV_MIPI_ICR_ADD_DATA_OVFLW_MASK 0x02000000
+#define MRV_MIPI_ICR_ADD_DATA_OVFLW_SHIFT 25
+#define MRV_MIPI_ICR_FRAME_END
+#define MRV_MIPI_ICR_FRAME_END_MASK 0x01000000
+#define MRV_MIPI_ICR_FRAME_END_SHIFT 24
+#define MRV_MIPI_ICR_ERR_CS
+#define MRV_MIPI_ICR_ERR_CS_MASK 0x00800000
+#define MRV_MIPI_ICR_ERR_CS_SHIFT 23
+#define MRV_MIPI_ICR_ERR_ECC1
+#define MRV_MIPI_ICR_ERR_ECC1_MASK 0x00400000
+#define MRV_MIPI_ICR_ERR_ECC1_SHIFT 22
+#define MRV_MIPI_ICR_ERR_ECC2
+#define MRV_MIPI_ICR_ERR_ECC2_MASK 0x00200000
+#define MRV_MIPI_ICR_ERR_ECC2_SHIFT 21
+#define MRV_MIPI_ICR_ERR_PROTOCOL
+#define MRV_MIPI_ICR_ERR_PROTOCOL_MASK 0x00100000
+#define MRV_MIPI_ICR_ERR_PROTOCOL_SHIFT 20
+#define MRV_MIPI_ICR_ERR_CONTROL
+#define MRV_MIPI_ICR_ERR_CONTROL_MASK 0x000F0000
+#define MRV_MIPI_ICR_ERR_CONTROL_SHIFT 16
+#define MRV_MIPI_ICR_ERR_EOT_SYNC
+#define MRV_MIPI_ICR_ERR_EOT_SYNC_MASK 0x0000F000
+#define MRV_MIPI_ICR_ERR_EOT_SYNC_SHIFT 12
+#define MRV_MIPI_ICR_ERR_SOT_SYNC
+#define MRV_MIPI_ICR_ERR_SOT_SYNC_MASK 0x00000F00
+#define MRV_MIPI_ICR_ERR_SOT_SYNC_SHIFT 8
+#define MRV_MIPI_ICR_ERR_SOT
+#define MRV_MIPI_ICR_ERR_SOT_MASK 0x000000F0
+#define MRV_MIPI_ICR_ERR_SOT_SHIFT 4
+#define MRV_MIPI_ICR_SYNC_FIFO_OVFLW
+#define MRV_MIPI_ICR_SYNC_FIFO_OVFLW_MASK 0x0000000F
+#define MRV_MIPI_ICR_SYNC_FIFO_OVFLW_SHIFT 0
+
+#define MRV_MIPI_ICR_ALL_IRQS
+#define MRV_MIPI_ICR_ALL_IRQS_MASK \
+(0 \
+| MRV_MIPI_ICR_ADD_DATA_FILL_LEVEL_MASK \
+| MRV_MIPI_ICR_ADD_DATA_OVFLW_MASK \
+| MRV_MIPI_ICR_FRAME_END_MASK \
+| MRV_MIPI_ICR_ERR_CS_MASK \
+| MRV_MIPI_ICR_ERR_ECC1_MASK \
+| MRV_MIPI_ICR_ERR_ECC2_MASK \
+| MRV_MIPI_ICR_ERR_PROTOCOL_MASK \
+| MRV_MIPI_ICR_ERR_CONTROL_MASK \
+| MRV_MIPI_ICR_ERR_EOT_SYNC_MASK \
+| MRV_MIPI_ICR_ERR_SOT_SYNC_MASK \
+| MRV_MIPI_ICR_ERR_SOT_MASK \
+| MRV_MIPI_ICR_SYNC_FIFO_OVFLW_MASK \
+)
+#define MRV_MIPI_ICR_ALL_IRQS_SHIFT 0
+
+#define MRV_MIPI_ISR_ADD_DATA_FILL_LEVEL
+#define MRV_MIPI_ISR_ADD_DATA_FILL_LEVEL_MASK 0x04000000
+#define MRV_MIPI_ISR_ADD_DATA_FILL_LEVEL_SHIFT 26
+#define MRV_MIPI_ISR_ADD_DATA_OVFLW
+#define MRV_MIPI_ISR_ADD_DATA_OVFLW_MASK 0x02000000
+#define MRV_MIPI_ISR_ADD_DATA_OVFLW_SHIFT 25
+#define MRV_MIPI_ISR_FRAME_END
+#define MRV_MIPI_ISR_FRAME_END_MASK 0x01000000
+#define MRV_MIPI_ISR_FRAME_END_SHIFT 24
+#define MRV_MIPI_ISR_ERR_CS
+#define MRV_MIPI_ISR_ERR_CS_MASK 0x00800000
+#define MRV_MIPI_ISR_ERR_CS_SHIFT 23
+#define MRV_MIPI_ISR_ERR_ECC1
+#define MRV_MIPI_ISR_ERR_ECC1_MASK 0x00400000
+#define MRV_MIPI_ISR_ERR_ECC1_SHIFT 22
+#define MRV_MIPI_ISR_ERR_ECC2
+#define MRV_MIPI_ISR_ERR_ECC2_MASK 0x00200000
+#define MRV_MIPI_ISR_ERR_ECC2_SHIFT 21
+#define MRV_MIPI_ISR_ERR_PROTOCOL
+#define MRV_MIPI_ISR_ERR_PROTOCOL_MASK 0x00100000
+#define MRV_MIPI_ISR_ERR_PROTOCOL_SHIFT 20
+#define MRV_MIPI_ISR_ERR_CONTROL
+#define MRV_MIPI_ISR_ERR_CONTROL_MASK 0x000F0000
+#define MRV_MIPI_ISR_ERR_CONTROL_SHIFT 16
+#define MRV_MIPI_ISR_ERR_EOT_SYNC
+#define MRV_MIPI_ISR_ERR_EOT_SYNC_MASK 0x0000F000
+#define MRV_MIPI_ISR_ERR_EOT_SYNC_SHIFT 12
+#define MRV_MIPI_ISR_ERR_SOT_SYNC
+#define MRV_MIPI_ISR_ERR_SOT_SYNC_MASK 0x00000F00
+#define MRV_MIPI_ISR_ERR_SOT_SYNC_SHIFT 8
+#define MRV_MIPI_ISR_ERR_SOT
+#define MRV_MIPI_ISR_ERR_SOT_MASK 0x000000F0
+#define MRV_MIPI_ISR_ERR_SOT_SHIFT 4
+#define MRV_MIPI_ISR_SYNC_FIFO_OVFLW
+#define MRV_MIPI_ISR_SYNC_FIFO_OVFLW_MASK 0x0000000F
+#define MRV_MIPI_ISR_SYNC_FIFO_OVFLW_SHIFT 0
+
+#define MRV_MIPI_ISR_ALL_IRQS
+#define MRV_MIPI_ISR_ALL_IRQS_MASK \
+(0 \
+| MRV_MIPI_ISR_ADD_DATA_FILL_LEVEL_MASK \
+| MRV_MIPI_ISR_ADD_DATA_OVFLW_MASK \
+| MRV_MIPI_ISR_FRAME_END_MASK \
+| MRV_MIPI_ISR_ERR_CS_MASK \
+| MRV_MIPI_ISR_ERR_ECC1_MASK \
+| MRV_MIPI_ISR_ERR_ECC2_MASK \
+| MRV_MIPI_ISR_ERR_PROTOCOL_MASK \
+| MRV_MIPI_ISR_ERR_CONTROL_MASK \
+| MRV_MIPI_ISR_ERR_EOT_SYNC_MASK \
+| MRV_MIPI_ISR_ERR_SOT_SYNC_MASK \
+| MRV_MIPI_ISR_ERR_SOT_MASK \
+| MRV_MIPI_ISR_SYNC_FIFO_OVFLW_MASK \
+)
+#define MRV_MIPI_ISR_ALL_IRQS_SHIFT 0
+
+#define MRV_MIPI_VIRTUAL_CHANNEL
+#define MRV_MIPI_VIRTUAL_CHANNEL_MASK 0x000000C0
+#define MRV_MIPI_VIRTUAL_CHANNEL_SHIFT 6
+
+#define MRV_MIPI_VIRTUAL_CHANNEL_MAX \
+       (MRV_MIPI_VIRTUAL_CHANNEL_MASK >> MRV_MIPI_VIRTUAL_CHANNEL_SHIFT)
+#define MRV_MIPI_DATA_TYPE
+#define MRV_MIPI_DATA_TYPE_MASK 0x0000003F
+#define MRV_MIPI_DATA_TYPE_SHIFT 0
+
+#define MRV_MIPI_DATA_TYPE_MAX \
+       (MRV_MIPI_DATA_TYPE_MASK >> MRV_MIPI_DATA_TYPE_SHIFT)
+
+#define MRV_MIPI_VIRTUAL_CHANNEL_SEL
+#define MRV_MIPI_VIRTUAL_CHANNEL_SEL_MASK 0x000000C0
+#define MRV_MIPI_VIRTUAL_CHANNEL_SEL_SHIFT 6
+#define MRV_MIPI_DATA_TYPE_SEL
+#define MRV_MIPI_DATA_TYPE_SEL_MASK 0x0000003F
+#define MRV_MIPI_DATA_TYPE_SEL_SHIFT 0
+#define MRV_MIPI_DATA_TYPE_SEL_YUV420_8BIT        24
+#define MRV_MIPI_DATA_TYPE_SEL_YUV420_10BIT       25
+#define MRV_MIPI_DATA_TYPE_SEL_YUV420_8BIT_LEGACY 26
+#define MRV_MIPI_DATA_TYPE_SEL_YUV420_8BIT_CSPS   28
+#define MRV_MIPI_DATA_TYPE_SEL_YUV420_10BIT_CSPS  29
+#define MRV_MIPI_DATA_TYPE_SEL_YUV422_8BIT        30
+#define MRV_MIPI_DATA_TYPE_SEL_YUV422_10BIT       31
+#define MRV_MIPI_DATA_TYPE_SEL_RGB444             32
+#define MRV_MIPI_DATA_TYPE_SEL_RGB555             33
+#define MRV_MIPI_DATA_TYPE_SEL_RGB565             34
+#define MRV_MIPI_DATA_TYPE_SEL_RGB666             35
+#define MRV_MIPI_DATA_TYPE_SEL_RGB888             36
+#define MRV_MIPI_DATA_TYPE_SEL_RAW6               40
+#define MRV_MIPI_DATA_TYPE_SEL_RAW7               41
+#define MRV_MIPI_DATA_TYPE_SEL_RAW8               42
+#define MRV_MIPI_DATA_TYPE_SEL_RAW10              43
+#define MRV_MIPI_DATA_TYPE_SEL_RAW12              44
+#define MRV_MIPI_DATA_TYPE_SEL_USER1              48
+#define MRV_MIPI_DATA_TYPE_SEL_USER2              49
+#define MRV_MIPI_DATA_TYPE_SEL_USER3              50
+#define MRV_MIPI_DATA_TYPE_SEL_USER4              51
+
+#define MRV_MIPI_ADD_DATA_VC_1
+#define MRV_MIPI_ADD_DATA_VC_1_MASK 0x000000C0
+#define MRV_MIPI_ADD_DATA_VC_1_SHIFT 6
+#define MRV_MIPI_ADD_DATA_TYPE_1
+#define MRV_MIPI_ADD_DATA_TYPE_1_MASK 0x0000003F
+#define MRV_MIPI_ADD_DATA_TYPE_1_SHIFT 0
+
+#define MRV_MIPI_ADD_DATA_VC_2
+#define MRV_MIPI_ADD_DATA_VC_2_MASK 0x000000C0
+#define MRV_MIPI_ADD_DATA_VC_2_SHIFT 6
+#define MRV_MIPI_ADD_DATA_TYPE_2
+#define MRV_MIPI_ADD_DATA_TYPE_2_MASK 0x0000003F
+#define MRV_MIPI_ADD_DATA_TYPE_2_SHIFT 0
+
+#define MRV_MIPI_ADD_DATA_VC_3
+#define MRV_MIPI_ADD_DATA_VC_3_MASK 0x000000C0
+#define MRV_MIPI_ADD_DATA_VC_3_SHIFT 6
+#define MRV_MIPI_ADD_DATA_TYPE_3
+#define MRV_MIPI_ADD_DATA_TYPE_3_MASK 0x0000003F
+#define MRV_MIPI_ADD_DATA_TYPE_3_SHIFT 0
+
+#define MRV_MIPI_ADD_DATA_VC_4
+#define MRV_MIPI_ADD_DATA_VC_4_MASK 0x000000C0
+#define MRV_MIPI_ADD_DATA_VC_4_SHIFT 6
+#define MRV_MIPI_ADD_DATA_TYPE_4
+#define MRV_MIPI_ADD_DATA_TYPE_4_MASK 0x0000003F
+#define MRV_MIPI_ADD_DATA_TYPE_4_SHIFT 0
+
+#define MRV_MIPI_ADD_DATA_FIFO
+#define MRV_MIPI_ADD_DATA_FIFO_MASK 0xFFFFFFFF
+#define MRV_MIPI_ADD_DATA_FIFO_SHIFT 0
+
+#define MRV_MIPI_ADD_DATA_FILL_LEVEL
+#define MRV_MIPI_ADD_DATA_FILL_LEVEL_MASK 0x00001FFC
+#define MRV_MIPI_ADD_DATA_FILL_LEVEL_SHIFT 0
+#define MRV_MIPI_ADD_DATA_FILL_LEVEL_MAX  0x00001FFC
+
+#define MRV_AFM_AFM_EN
+#define MRV_AFM_AFM_EN_MASK 0x00000001
+#define MRV_AFM_AFM_EN_SHIFT 0
+
+#define MRV_AFM_A_H_L
+#define MRV_AFM_A_H_L_MASK 0x0FFF0000
+#define MRV_AFM_A_H_L_SHIFT 16
+#define MRV_AFM_A_H_L_MIN  5
+#define MRV_AFM_A_H_L_MAX  (MRV_AFM_A_H_L_MASK >> MRV_AFM_A_H_L_SHIFT)
+#define MRV_AFM_A_V_T
+#define MRV_AFM_A_V_T_MASK 0x00000FFF
+#define MRV_AFM_A_V_T_SHIFT 0
+#define MRV_AFM_A_V_T_MIN  2
+#define MRV_AFM_A_V_T_MAX  (MRV_AFM_A_V_T_MASK >> MRV_AFM_A_V_T_SHIFT)
+
+#define MRV_AFM_A_H_R
+#define MRV_AFM_A_H_R_MASK 0x0FFF0000
+#define MRV_AFM_A_H_R_SHIFT 16
+#define MRV_AFM_A_H_R_MIN  5
+#define MRV_AFM_A_H_R_MAX  (MRV_AFM_A_H_R_MASK >> MRV_AFM_A_H_R_SHIFT)
+#define MRV_AFM_A_V_B
+#define MRV_AFM_A_V_B_MASK 0x00000FFF
+#define MRV_AFM_A_V_B_SHIFT 0
+#define MRV_AFM_A_V_B_MIN  2
+#define MRV_AFM_A_V_B_MAX  (MRV_AFM_A_V_B_MASK >> MRV_AFM_A_V_B_SHIFT)
+
+#define MRV_AFM_B_H_L
+#define MRV_AFM_B_H_L_MASK 0x0FFF0000
+#define MRV_AFM_B_H_L_SHIFT 16
+#define MRV_AFM_B_H_L_MIN  5
+#define MRV_AFM_B_H_L_MAX  (MRV_AFM_B_H_L_MASK >> MRV_AFM_B_H_L_SHIFT)
+#define MRV_AFM_B_V_T
+#define MRV_AFM_B_V_T_MASK 0x00000FFF
+#define MRV_AFM_B_V_T_SHIFT 0
+#define MRV_AFM_B_V_T_MIN  2
+#define MRV_AFM_B_V_T_MAX  (MRV_AFM_B_V_T_MASK >> MRV_AFM_B_V_T_SHIFT)
+
+#define MRV_AFM_B_H_R
+#define MRV_AFM_B_H_R_MASK 0x0FFF0000
+#define MRV_AFM_B_H_R_SHIFT 16
+#define MRV_AFM_B_H_R_MIN  5
+#define MRV_AFM_B_H_R_MAX  (MRV_AFM_B_H_R_MASK >> MRV_AFM_B_H_R_SHIFT)
+#define MRV_AFM_B_V_B
+#define MRV_AFM_B_V_B_MASK 0x00000FFF
+#define MRV_AFM_B_V_B_SHIFT 0
+#define MRV_AFM_B_V_B_MIN  2
+#define MRV_AFM_B_V_B_MAX  (MRV_AFM_B_V_B_MASK >> MRV_AFM_B_V_B_SHIFT)
+
+#define MRV_AFM_C_H_L
+#define MRV_AFM_C_H_L_MASK 0x0FFF0000
+#define MRV_AFM_C_H_L_SHIFT 16
+#define MRV_AFM_C_H_L_MIN  5
+#define MRV_AFM_C_H_L_MAX  (MRV_AFM_C_H_L_MASK >> MRV_AFM_C_H_L_SHIFT)
+#define MRV_AFM_C_V_T
+#define MRV_AFM_C_V_T_MASK 0x00000FFF
+#define MRV_AFM_C_V_T_SHIFT 0
+#define MRV_AFM_C_V_T_MIN  2
+#define MRV_AFM_C_V_T_MAX  (MRV_AFM_C_V_T_MASK >> MRV_AFM_C_V_T_SHIFT)
+
+#define MRV_AFM_C_H_R
+#define MRV_AFM_C_H_R_MASK 0x0FFF0000
+#define MRV_AFM_C_H_R_SHIFT 16
+#define MRV_AFM_C_H_R_MIN  5
+#define MRV_AFM_C_H_R_MAX  (MRV_AFM_C_H_R_MASK >> MRV_AFM_C_H_R_SHIFT)
+#define MRV_AFM_C_V_B
+#define MRV_AFM_C_V_B_MASK 0x00000FFF
+#define MRV_AFM_C_V_B_SHIFT 0
+#define MRV_AFM_C_V_B_MIN  2
+#define MRV_AFM_C_V_B_MAX  (MRV_AFM_C_V_B_MASK >> MRV_AFM_C_V_B_SHIFT)
+
+#define MRV_AFM_AFM_THRES
+#define MRV_AFM_AFM_THRES_MASK 0x0000FFFF
+#define MRV_AFM_AFM_THRES_SHIFT 0
+
+#define MRV_AFM_LUM_VAR_SHIFT
+#define MRV_AFM_LUM_VAR_SHIFT_MASK 0x00070000
+#define MRV_AFM_LUM_VAR_SHIFT_SHIFT 16
+#define MRV_AFM_AFM_VAR_SHIFT
+#define MRV_AFM_AFM_VAR_SHIFT_MASK 0x00000007
+#define MRV_AFM_AFM_VAR_SHIFT_SHIFT 0
+
+#define MRV_AFM_AFM_SUM_A
+#define MRV_AFM_AFM_SUM_A_MASK 0xFFFFFFFF
+#define MRV_AFM_AFM_SUM_A_SHIFT 0
+
+#define MRV_AFM_AFM_SUM_B
+#define MRV_AFM_AFM_SUM_B_MASK 0xFFFFFFFF
+#define MRV_AFM_AFM_SUM_B_SHIFT 0
+
+#define MRV_AFM_AFM_SUM_C
+#define MRV_AFM_AFM_SUM_C_MASK 0xFFFFFFFF
+#define MRV_AFM_AFM_SUM_C_SHIFT 0
+
+#define MRV_AFM_AFM_LUM_A
+#define MRV_AFM_AFM_LUM_A_MASK 0x00FFFFFF
+#define MRV_AFM_AFM_LUM_A_SHIFT 0
+
+#define MRV_AFM_AFM_LUM_B
+#define MRV_AFM_AFM_LUM_B_MASK 0x00FFFFFF
+#define MRV_AFM_AFM_LUM_B_SHIFT 0
+
+#define MRV_AFM_AFM_LUM_C
+#define MRV_AFM_AFM_LUM_C_MASK 0x00FFFFFF
+#define MRV_AFM_AFM_LUM_C_SHIFT 0
+
+#define MRV_BP_COR_TYPE
+#define MRV_BP_COR_TYPE_MASK 0x00000010
+#define MRV_BP_COR_TYPE_SHIFT 4
+#define MRV_BP_COR_TYPE_TABLE  0
+#define MRV_BP_COR_TYPE_DIRECT 1
+#define MRV_BP_REP_APPR
+#define MRV_BP_REP_APPR_MASK 0x00000008
+#define MRV_BP_REP_APPR_SHIFT 3
+#define MRV_BP_REP_APPR_NEAREST  0
+#define MRV_BP_REP_APPR_INTERPOL 1
+#define MRV_BP_DEAD_COR_EN
+#define MRV_BP_DEAD_COR_EN_MASK 0x00000004
+#define MRV_BP_DEAD_COR_EN_SHIFT 2
+#define MRV_BP_HOT_COR_EN
+#define MRV_BP_HOT_COR_EN_MASK 0x00000002
+#define MRV_BP_HOT_COR_EN_SHIFT 1
+#define MRV_BP_BP_DET_EN
+#define MRV_BP_BP_DET_EN_MASK 0x00000001
+#define MRV_BP_BP_DET_EN_SHIFT 0
+
+#define MRV_BP_HOT_THRES
+#define MRV_BP_HOT_THRES_MASK 0x0FFF0000
+#define MRV_BP_HOT_THRES_SHIFT 16
+#define MRV_BP_DEAD_THRES
+#define MRV_BP_DEAD_THRES_MASK 0x00000FFF
+#define MRV_BP_DEAD_THRES_SHIFT 0
+
+#define MRV_BP_DEV_HOT_THRES
+#define MRV_BP_DEV_HOT_THRES_MASK 0x0FFF0000
+#define MRV_BP_DEV_HOT_THRES_SHIFT 16
+#define MRV_BP_DEV_DEAD_THRES
+#define MRV_BP_DEV_DEAD_THRES_MASK 0x00000FFF
+#define MRV_BP_DEV_DEAD_THRES_SHIFT 0
+
+#define MRV_BP_BP_NUMBER
+#define MRV_BP_BP_NUMBER_MASK 0x00000FFF
+#define MRV_BP_BP_NUMBER_SHIFT 0
+
+#define MRV_BP_BP_TABLE_ADDR
+#define MRV_BP_BP_TABLE_ADDR_MASK 0x000007FF
+
+#define MRV_BP_BP_TABLE_ADDR_SHIFT 0
+#define MRV_BP_BP_TABLE_ADDR_MAX MRV_BP_BP_TABLE_ADDR_MASK
+
+#define MRV_BP_PIX_TYPE
+#define MRV_BP_PIX_TYPE_MASK 0x80000000
+#define MRV_BP_PIX_TYPE_SHIFT 31
+#define MRV_BP_PIX_TYPE_DEAD   0u
+#define MRV_BP_PIX_TYPE_HOT    1u
+
+#define MRV_BP_V_ADDR
+#define MRV_BP_V_ADDR_MASK 0x0FFF0000
+#define MRV_BP_V_ADDR_SHIFT 16
+
+#define MRV_BP_H_ADDR
+#define MRV_BP_H_ADDR_MASK 0x00000FFF
+#define MRV_BP_H_ADDR_SHIFT 0
+
+#define MRV_BP_BP_NEW_NUMBER
+#define MRV_BP_BP_NEW_NUMBER_MASK 0x0000000F
+#define MRV_BP_BP_NEW_NUMBER_SHIFT 0
+
+#define MRV_BP_NEW_VALUE
+#define MRV_BP_NEW_VALUE_MASK 0xF8000000
+#define MRV_BP_NEW_VALUE_SHIFT 27
+#define MRV_BP_NEW_V_ADDR
+
+#define MRV_BP_NEW_V_ADDR_MASK 0x07FF0000
+#define MRV_BP_NEW_V_ADDR_SHIFT 16
+#define MRV_BP_NEW_H_ADDR
+#define MRV_BP_NEW_H_ADDR_MASK 0x00000FFF
+#define MRV_BP_NEW_H_ADDR_SHIFT 0
+
+#define MRV_LSC_LSC_EN
+#define MRV_LSC_LSC_EN_MASK 0x00000001
+#define MRV_LSC_LSC_EN_SHIFT 0
+
+#define MRV_LSC_R_RAM_ADDR
+#define MRV_LSC_R_RAM_ADDR_MASK 0x000000FF
+#define MRV_LSC_R_RAM_ADDR_SHIFT 0
+#define MRV_LSC_R_RAM_ADDR_MIN  0x00000000
+#define MRV_LSC_R_RAM_ADDR_MAX  0x00000098
+
+#define MRV_LSC_G_RAM_ADDR
+#define MRV_LSC_G_RAM_ADDR_MASK 0x000000FF
+#define MRV_LSC_G_RAM_ADDR_SHIFT 0
+#define MRV_LSC_G_RAM_ADDR_MIN  0x00000000
+#define MRV_LSC_G_RAM_ADDR_MAX  0x00000098
+
+#define MRV_LSC_B_RAM_ADDR
+#define MRV_LSC_B_RAM_ADDR_MASK 0x000000FF
+#define MRV_LSC_B_RAM_ADDR_SHIFT 0
+#define MRV_LSC_B_RAM_ADDR_MIN  0x00000000
+#define MRV_LSC_B_RAM_ADDR_MAX  0x00000098
+
+#define MRV_LSC_R_SAMPLE_1
+#define MRV_LSC_R_SAMPLE_1_MASK 0x00FFF000
+#define MRV_LSC_R_SAMPLE_1_SHIFT 12
+#define MRV_LSC_R_SAMPLE_0
+#define MRV_LSC_R_SAMPLE_0_MASK 0x00000FFF
+#define MRV_LSC_R_SAMPLE_0_SHIFT 0
+
+#define MRV_LSC_G_SAMPLE_1
+#define MRV_LSC_G_SAMPLE_1_MASK 0x00FFF000
+#define MRV_LSC_G_SAMPLE_1_SHIFT 12
+#define MRV_LSC_G_SAMPLE_0
+#define MRV_LSC_G_SAMPLE_0_MASK 0x00000FFF
+#define MRV_LSC_G_SAMPLE_0_SHIFT 0
+
+#define MRV_LSC_B_SAMPLE_1
+#define MRV_LSC_B_SAMPLE_1_MASK 0x00FFF000
+#define MRV_LSC_B_SAMPLE_1_SHIFT 12
+#define MRV_LSC_B_SAMPLE_0
+#define MRV_LSC_B_SAMPLE_0_MASK 0x00000FFF
+#define MRV_LSC_B_SAMPLE_0_SHIFT 0
+
+#define MRV_LSC_XGRAD_1
+#define MRV_LSC_XGRAD_1_MASK 0x0FFF0000
+#define MRV_LSC_XGRAD_1_SHIFT 16
+#define MRV_LSC_XGRAD_0
+#define MRV_LSC_XGRAD_0_MASK 0x00000FFF
+#define MRV_LSC_XGRAD_0_SHIFT 0
+
+#define MRV_LSC_XGRAD_3
+#define MRV_LSC_XGRAD_3_MASK 0x0FFF0000
+#define MRV_LSC_XGRAD_3_SHIFT 16
+#define MRV_LSC_XGRAD_2
+#define MRV_LSC_XGRAD_2_MASK 0x00000FFF
+#define MRV_LSC_XGRAD_2_SHIFT 0
+
+#define MRV_LSC_XGRAD_5
+#define MRV_LSC_XGRAD_5_MASK 0x0FFF0000
+#define MRV_LSC_XGRAD_5_SHIFT 16
+
+#define MRV_LSC_XGRAD_4
+#define MRV_LSC_XGRAD_4_MASK 0x00000FFF
+#define MRV_LSC_XGRAD_4_SHIFT 0
+
+#define MRV_LSC_XGRAD_7
+#define MRV_LSC_XGRAD_7_MASK 0x0FFF0000
+#define MRV_LSC_XGRAD_7_SHIFT 16
+
+#define MRV_LSC_XGRAD_6
+#define MRV_LSC_XGRAD_6_MASK 0x00000FFF
+#define MRV_LSC_XGRAD_6_SHIFT 0
+
+#define MRV_LSC_YGRAD_1
+#define MRV_LSC_YGRAD_1_MASK 0x0FFF0000
+#define MRV_LSC_YGRAD_1_SHIFT 16
+#define MRV_LSC_YGRAD_0
+#define MRV_LSC_YGRAD_0_MASK 0x00000FFF
+#define MRV_LSC_YGRAD_0_SHIFT 0
+
+#define MRV_LSC_YGRAD_3
+#define MRV_LSC_YGRAD_3_MASK 0x0FFF0000
+#define MRV_LSC_YGRAD_3_SHIFT 16
+
+#define MRV_LSC_YGRAD_2
+#define MRV_LSC_YGRAD_2_MASK 0x00000FFF
+#define MRV_LSC_YGRAD_2_SHIFT 0
+
+#define MRV_LSC_YGRAD_5
+#define MRV_LSC_YGRAD_5_MASK 0x0FFF0000
+#define MRV_LSC_YGRAD_5_SHIFT 16
+
+#define MRV_LSC_YGRAD_4
+#define MRV_LSC_YGRAD_4_MASK 0x00000FFF
+#define MRV_LSC_YGRAD_4_SHIFT 0
+
+
+#define MRV_LSC_YGRAD_7
+#define MRV_LSC_YGRAD_7_MASK 0x0FFF0000
+#define MRV_LSC_YGRAD_7_SHIFT 16
+
+#define MRV_LSC_YGRAD_6
+#define MRV_LSC_YGRAD_6_MASK 0x00000FFF
+#define MRV_LSC_YGRAD_6_SHIFT 0
+
+
+#define MRV_LSC_X_SECT_SIZE_1
+#define MRV_LSC_X_SECT_SIZE_1_MASK 0x03FF0000
+#define MRV_LSC_X_SECT_SIZE_1_SHIFT 16
+
+#define MRV_LSC_X_SECT_SIZE_0
+#define MRV_LSC_X_SECT_SIZE_0_MASK 0x000003FF
+#define MRV_LSC_X_SECT_SIZE_0_SHIFT 0
+
+
+#define MRV_LSC_X_SECT_SIZE_3
+#define MRV_LSC_X_SECT_SIZE_3_MASK 0x03FF0000
+#define MRV_LSC_X_SECT_SIZE_3_SHIFT 16
+
+#define MRV_LSC_X_SECT_SIZE_2
+#define MRV_LSC_X_SECT_SIZE_2_MASK 0x000003FF
+#define MRV_LSC_X_SECT_SIZE_2_SHIFT 0
+
+
+#define MRV_LSC_X_SECT_SIZE_5
+#define MRV_LSC_X_SECT_SIZE_5_MASK 0x03FF0000
+#define MRV_LSC_X_SECT_SIZE_5_SHIFT 16
+
+#define MRV_LSC_X_SECT_SIZE_4
+#define MRV_LSC_X_SECT_SIZE_4_MASK 0x000003FF
+#define MRV_LSC_X_SECT_SIZE_4_SHIFT 0
+
+#define MRV_LSC_X_SECT_SIZE_7
+#define MRV_LSC_X_SECT_SIZE_7_MASK 0x03FF0000
+#define MRV_LSC_X_SECT_SIZE_7_SHIFT 16
+
+#define MRV_LSC_X_SECT_SIZE_6
+#define MRV_LSC_X_SECT_SIZE_6_MASK 0x000003FF
+#define MRV_LSC_X_SECT_SIZE_6_SHIFT 0
+
+#define MRV_LSC_Y_SECT_SIZE_1
+#define MRV_LSC_Y_SECT_SIZE_1_MASK 0x03FF0000
+#define MRV_LSC_Y_SECT_SIZE_1_SHIFT 16
+#define MRV_LSC_Y_SECT_SIZE_0
+#define MRV_LSC_Y_SECT_SIZE_0_MASK 0x000003FF
+#define MRV_LSC_Y_SECT_SIZE_0_SHIFT 0
+
+#define MRV_LSC_Y_SECT_SIZE_3
+#define MRV_LSC_Y_SECT_SIZE_3_MASK 0x03FF0000
+#define MRV_LSC_Y_SECT_SIZE_3_SHIFT 16
+#define MRV_LSC_Y_SECT_SIZE_2
+#define MRV_LSC_Y_SECT_SIZE_2_MASK 0x000003FF
+#define MRV_LSC_Y_SECT_SIZE_2_SHIFT 0
+
+#define MRV_LSC_Y_SECT_SIZE_5
+#define MRV_LSC_Y_SECT_SIZE_5_MASK 0x03FF0000
+#define MRV_LSC_Y_SECT_SIZE_5_SHIFT 16
+#define MRV_LSC_Y_SECT_SIZE_4
+#define MRV_LSC_Y_SECT_SIZE_4_MASK 0x000003FF
+#define MRV_LSC_Y_SECT_SIZE_4_SHIFT 0
+
+#define MRV_LSC_Y_SECT_SIZE_7
+#define MRV_LSC_Y_SECT_SIZE_7_MASK 0x03FF0000
+#define MRV_LSC_Y_SECT_SIZE_7_SHIFT 16
+#define MRV_LSC_Y_SECT_SIZE_6
+#define MRV_LSC_Y_SECT_SIZE_6_MASK 0x000003FF
+#define MRV_LSC_Y_SECT_SIZE_6_SHIFT 0
+
+#define MRV_IS_IS_EN
+#define MRV_IS_IS_EN_MASK 0x00000001
+#define MRV_IS_IS_EN_SHIFT 0
+
+
+#define MRV_IS_IS_RECENTER
+#define MRV_IS_IS_RECENTER_MASK 0x00000007
+#define MRV_IS_IS_RECENTER_SHIFT 0
+#define MRV_IS_IS_RECENTER_MAX \
+       (MRV_IS_IS_RECENTER_MASK >> MRV_IS_IS_RECENTER_SHIFT)
+
+#define MRV_IS_IS_H_OFFS
+#define MRV_IS_IS_H_OFFS_MASK 0x00001FFF
+#define MRV_IS_IS_H_OFFS_SHIFT 0
+
+#define MRV_IS_IS_V_OFFS
+#define MRV_IS_IS_V_OFFS_MASK 0x00000FFF
+#define MRV_IS_IS_V_OFFS_SHIFT 0
+
+#define MRV_IS_IS_H_SIZE
+#define MRV_IS_IS_H_SIZE_MASK 0x00003FFF
+#define MRV_IS_IS_H_SIZE_SHIFT 0
+
+#define MRV_IS_IS_V_SIZE
+#define MRV_IS_IS_V_SIZE_MASK 0x00000FFF
+#define MRV_IS_IS_V_SIZE_SHIFT 0
+
+#define MRV_IS_IS_MAX_DX
+#define MRV_IS_IS_MAX_DX_MASK 0x00000FFF
+#define MRV_IS_IS_MAX_DX_SHIFT 0
+#define MRV_IS_IS_MAX_DX_MAX (MRV_IS_IS_MAX_DX_MASK >> MRV_IS_IS_MAX_DX_SHIFT)
+
+#define MRV_IS_IS_MAX_DY
+#define MRV_IS_IS_MAX_DY_MASK 0x00000FFF
+#define MRV_IS_IS_MAX_DY_SHIFT 0
+#define MRV_IS_IS_MAX_DY_MAX (MRV_IS_IS_MAX_DY_MASK >> MRV_IS_IS_MAX_DY_SHIFT)
+#define MRV_IS_DY
+#define MRV_IS_DY_MASK 0x0FFF0000
+#define MRV_IS_DY_SHIFT 16
+#define MRV_IS_DY_MAX 0x000007FF
+#define MRV_IS_DY_MIN (~MRV_IS_DY_MAX)
+#define MRV_IS_DX
+#define MRV_IS_DX_MASK 0x00000FFF
+#define MRV_IS_DX_SHIFT 0
+#define MRV_IS_DX_MAX 0x000007FF
+#define MRV_IS_DX_MIN (~MRV_IS_DX_MAX)
+
+#define MRV_IS_IS_H_OFFS_SHD
+#define MRV_IS_IS_H_OFFS_SHD_MASK 0x00001FFF
+#define MRV_IS_IS_H_OFFS_SHD_SHIFT 0
+
+#define MRV_IS_IS_V_OFFS_SHD
+#define MRV_IS_IS_V_OFFS_SHD_MASK 0x00000FFF
+#define MRV_IS_IS_V_OFFS_SHD_SHIFT 0
+
+#define MRV_IS_ISP_H_SIZE_SHD
+#define MRV_IS_ISP_H_SIZE_SHD_MASK 0x00001FFF
+#define MRV_IS_ISP_H_SIZE_SHD_SHIFT 0
+
+#define MRV_IS_ISP_V_SIZE_SHD
+#define MRV_IS_ISP_V_SIZE_SHD_MASK 0x00000FFF
+#define MRV_IS_ISP_V_SIZE_SHD_SHIFT 0
+
+#define MRV_HIST_HIST_PDIV
+#define MRV_HIST_HIST_PDIV_MASK 0x000007F8
+#define MRV_HIST_HIST_PDIV_SHIFT 3
+#define MRV_HIST_HIST_PDIV_MIN  0x00000003
+#define MRV_HIST_HIST_PDIV_MAX  0x000000FF
+#define MRV_HIST_HIST_MODE
+#define MRV_HIST_HIST_MODE_MASK 0x00000007
+#define MRV_HIST_HIST_MODE_SHIFT 0
+#define MRV_HIST_HIST_MODE_MAX  5
+#define MRV_HIST_HIST_MODE_LUM  5
+#define MRV_HIST_HIST_MODE_B    4
+#define MRV_HIST_HIST_MODE_G    3
+#define MRV_HIST_HIST_MODE_R    2
+#define MRV_HIST_HIST_MODE_RGB  1
+#define MRV_HIST_HIST_MODE_NONE 0
+
+#define MRV_HIST_HIST_H_OFFS
+#define MRV_HIST_HIST_H_OFFS_MASK 0x00000FFF
+#define MRV_HIST_HIST_H_OFFS_SHIFT 0
+#define MRV_HIST_HIST_H_OFFS_MAX \
+       (MRV_HIST_HIST_H_OFFS_MASK >> MRV_HIST_HIST_H_OFFS_SHIFT)
+
+#define MRV_HIST_HIST_V_OFFS
+#define MRV_HIST_HIST_V_OFFS_MASK 0x00000FFF
+#define MRV_HIST_HIST_V_OFFS_SHIFT 0
+#define MRV_HIST_HIST_V_OFFS_MAX \
+       (MRV_HIST_HIST_V_OFFS_MASK >> MRV_HIST_HIST_V_OFFS_SHIFT)
+
+#define MRV_HIST_HIST_H_SIZE
+#define MRV_HIST_HIST_H_SIZE_MASK 0x00000FFF
+#define MRV_HIST_HIST_H_SIZE_SHIFT 0
+#define MRV_HIST_HIST_H_SIZE_MAX \
+       (MRV_HIST_HIST_H_SIZE_MASK >> MRV_HIST_HIST_H_SIZE_SHIFT)
+
+#define MRV_HIST_HIST_V_SIZE
+#define MRV_HIST_HIST_V_SIZE_MASK 0x00000FFF
+#define MRV_HIST_HIST_V_SIZE_SHIFT 0
+#define MRV_HIST_HIST_V_SIZE_MAX \
+       (MRV_HIST_HIST_V_SIZE_MASK >> MRV_HIST_HIST_V_SIZE_SHIFT)
+
+#define MRV_HIST_HIST_BIN_N
+#define MRV_HIST_HIST_BIN_N_MASK 0x000000FF
+#define MRV_HIST_HIST_BIN_N_SHIFT 0
+#define MRV_HIST_HIST_BIN_N_MAX \
+       (MRV_HIST_HIST_BIN_N_MASK >> MRV_HIST_HIST_BIN_N_SHIFT)
+
+#define MRV_FILT_STAGE1_SELECT
+#define MRV_FILT_STAGE1_SELECT_MASK 0x00000F00
+#define MRV_FILT_STAGE1_SELECT_SHIFT 8
+#define MRV_FILT_STAGE1_SELECT_MAX_BLUR 0
+#define MRV_FILT_STAGE1_SELECT_DEFAULT  4
+#define MRV_FILT_STAGE1_SELECT_MIN_BLUR 7
+#define MRV_FILT_STAGE1_SELECT_BYPASS   8
+#define MRV_FILT_FILT_CHR_H_MODE
+#define MRV_FILT_FILT_CHR_H_MODE_MASK 0x000000C0
+#define MRV_FILT_FILT_CHR_H_MODE_SHIFT 6
+#define MRV_FILT_FILT_CHR_H_MODE_BYPASS 0
+#define MRV_FILT_FILT_CHR_H_MODE_STATIC 1
+#define MRV_FILT_FILT_CHR_H_MODE_DYN_1  2
+#define MRV_FILT_FILT_CHR_H_MODE_DYN_2  3
+#define MRV_FILT_FILT_CHR_V_MODE
+#define MRV_FILT_FILT_CHR_V_MODE_MASK 0x00000030
+#define MRV_FILT_FILT_CHR_V_MODE_SHIFT 4
+#define MRV_FILT_FILT_CHR_V_MODE_BYPASS   0
+#define MRV_FILT_FILT_CHR_V_MODE_STATIC8  1
+#define MRV_FILT_FILT_CHR_V_MODE_STATIC10 2
+#define MRV_FILT_FILT_CHR_V_MODE_STATIC12 3
+
+#define MRV_FILT_FILT_MODE
+#define MRV_FILT_FILT_MODE_MASK 0x00000002
+#define MRV_FILT_FILT_MODE_SHIFT 1
+#define MRV_FILT_FILT_MODE_STATIC  0
+#define MRV_FILT_FILT_MODE_DYNAMIC 1
+
+#define MRV_FILT_FILT_ENABLE
+#define MRV_FILT_FILT_ENABLE_MASK 0x00000001
+#define MRV_FILT_FILT_ENABLE_SHIFT 0
+
+#define MRV_FILT_FILT_THRESH_BL0
+#define MRV_FILT_FILT_THRESH_BL0_MASK 0x000003FF
+#define MRV_FILT_FILT_THRESH_BL0_SHIFT 0
+
+#define MRV_FILT_FILT_THRESH_BL1
+#define MRV_FILT_FILT_THRESH_BL1_MASK 0x000003FF
+#define MRV_FILT_FILT_THRESH_BL1_SHIFT 0
+
+
+#define MRV_FILT_FILT_THRESH_SH0
+#define MRV_FILT_FILT_THRESH_SH0_MASK 0x000003FF
+#define MRV_FILT_FILT_THRESH_SH0_SHIFT 0
+
+#define MRV_FILT_FILT_THRESH_SH1
+#define MRV_FILT_FILT_THRESH_SH1_MASK 0x000003FF
+#define MRV_FILT_FILT_THRESH_SH1_SHIFT 0
+
+#define MRV_FILT_LUM_WEIGHT_GAIN
+#define MRV_FILT_LUM_WEIGHT_GAIN_MASK 0x00070000
+#define MRV_FILT_LUM_WEIGHT_GAIN_SHIFT 16
+#define MRV_FILT_LUM_WEIGHT_KINK
+#define MRV_FILT_LUM_WEIGHT_KINK_MASK 0x0000FF00
+#define MRV_FILT_LUM_WEIGHT_KINK_SHIFT 8
+#define MRV_FILT_LUM_WEIGHT_MIN
+#define MRV_FILT_LUM_WEIGHT_MIN_MASK 0x000000FF
+#define MRV_FILT_LUM_WEIGHT_MIN_SHIFT 0
+
+#define MRV_FILT_FILT_FAC_SH1
+#define MRV_FILT_FILT_FAC_SH1_MASK 0x0000003F
+#define MRV_FILT_FILT_FAC_SH1_SHIFT 0
+
+#define MRV_FILT_FILT_FAC_SH0
+#define MRV_FILT_FILT_FAC_SH0_MASK 0x0000003F
+#define MRV_FILT_FILT_FAC_SH0_SHIFT 0
+
+#define MRV_FILT_FILT_FAC_MID
+#define MRV_FILT_FILT_FAC_MID_MASK 0x0000003F
+#define MRV_FILT_FILT_FAC_MID_SHIFT 0
+
+#define MRV_FILT_FILT_FAC_BL0
+#define MRV_FILT_FILT_FAC_BL0_MASK 0x0000003F
+#define MRV_FILT_FILT_FAC_BL0_SHIFT 0
+
+#define MRV_FILT_FILT_FAC_BL1
+#define MRV_FILT_FILT_FAC_BL1_MASK 0x0000003F
+#define MRV_FILT_FILT_FAC_BL1_SHIFT 0
+
+#define MRV_AE_EXP_MEAS_MODE
+#define MRV_AE_EXP_MEAS_MODE_MASK 0x80000000
+#define MRV_AE_EXP_MEAS_MODE_SHIFT 31
+
+#define MRV_AE_AUTOSTOP
+#define MRV_AE_AUTOSTOP_MASK 0x00000002
+#define MRV_AE_AUTOSTOP_SHIFT 1
+
+#define MRV_AE_EXP_START
+#define MRV_AE_EXP_START_MASK 0x00000001
+#define MRV_AE_EXP_START_SHIFT 0
+
+#define MRV_AE_ISP_EXP_H_OFFSET
+#define MRV_AE_ISP_EXP_H_OFFSET_MASK 0x00000FFF
+#define MRV_AE_ISP_EXP_H_OFFSET_SHIFT 0
+#define MRV_AE_ISP_EXP_H_OFFSET_MIN  0x00000000
+#define MRV_AE_ISP_EXP_H_OFFSET_MAX  0x00000F50
+
+#define MRV_AE_ISP_EXP_V_OFFSET
+#define MRV_AE_ISP_EXP_V_OFFSET_MASK 0x00000FFF
+#define MRV_AE_ISP_EXP_V_OFFSET_SHIFT 0
+#define MRV_AE_ISP_EXP_V_OFFSET_MIN  0x00000000
+#define MRV_AE_ISP_EXP_V_OFFSET_MAX  0x00000B74
+
+
+#define MRV_AE_ISP_EXP_H_SIZE
+#define MRV_AE_ISP_EXP_H_SIZE_MASK 0x000003FF
+#define MRV_AE_ISP_EXP_H_SIZE_SHIFT 0
+#define MRV_AE_ISP_EXP_H_SIZE_MIN  0x00000023
+#define MRV_AE_ISP_EXP_H_SIZE_MAX  0x00000333
+
+#define MRV_AE_ISP_EXP_V_SIZE
+#define MRV_AE_ISP_EXP_V_SIZE_MASK 0x000003FE
+#define MRV_AE_ISP_EXP_V_SIZE_SHIFT 0
+#define MRV_AE_ISP_EXP_V_SIZE_VALID_MASK \
+       (MRV_AE_ISP_EXP_V_SIZE_MASK & ~0x00000001)
+#define MRV_AE_ISP_EXP_V_SIZE_MIN  0x0000001C
+#define MRV_AE_ISP_EXP_V_SIZE_MAX  0x00000266
+
+#define MRV_AE_ISP_EXP_MEAN_ARR_SIZE1 5
+#define MRV_AE_ISP_EXP_MEAN_ARR_SIZE2 5
+#define MRV_AE_ISP_EXP_MEAN_ARR_OFS1  1
+#define MRV_AE_ISP_EXP_MEAN_ARR_OFS2  MRV_AE_ISP_EXP_MEAN_ARR_SIZE1
+#define MRV_AE_ISP_EXP_MEAN
+#define MRV_AE_ISP_EXP_MEAN_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_00
+#define MRV_AE_ISP_EXP_MEAN_00_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_00_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_10
+#define MRV_AE_ISP_EXP_MEAN_10_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_10_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_20
+#define MRV_AE_ISP_EXP_MEAN_20_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_20_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_30
+#define MRV_AE_ISP_EXP_MEAN_30_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_30_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_40
+#define MRV_AE_ISP_EXP_MEAN_40_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_40_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_01
+#define MRV_AE_ISP_EXP_MEAN_01_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_01_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_11
+#define MRV_AE_ISP_EXP_MEAN_11_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_11_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_21
+#define MRV_AE_ISP_EXP_MEAN_21_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_21_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_31
+#define MRV_AE_ISP_EXP_MEAN_31_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_31_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_41
+#define MRV_AE_ISP_EXP_MEAN_41_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_41_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_02
+#define MRV_AE_ISP_EXP_MEAN_02_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_02_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_12
+#define MRV_AE_ISP_EXP_MEAN_12_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_12_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_22
+#define MRV_AE_ISP_EXP_MEAN_22_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_22_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_32
+#define MRV_AE_ISP_EXP_MEAN_32_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_32_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_42
+#define MRV_AE_ISP_EXP_MEAN_42_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_42_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_03
+#define MRV_AE_ISP_EXP_MEAN_03_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_03_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_13
+#define MRV_AE_ISP_EXP_MEAN_13_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_13_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_23
+#define MRV_AE_ISP_EXP_MEAN_23_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_23_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_33
+#define MRV_AE_ISP_EXP_MEAN_33_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_33_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_43
+#define MRV_AE_ISP_EXP_MEAN_43_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_43_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_04
+#define MRV_AE_ISP_EXP_MEAN_04_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_04_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_14
+#define MRV_AE_ISP_EXP_MEAN_14_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_14_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_24
+#define MRV_AE_ISP_EXP_MEAN_24_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_24_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_34
+#define MRV_AE_ISP_EXP_MEAN_34_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_34_SHIFT 0
+
+#define MRV_AE_ISP_EXP_MEAN_44
+#define MRV_AE_ISP_EXP_MEAN_44_MASK 0x000000FF
+#define MRV_AE_ISP_EXP_MEAN_44_SHIFT 0
+
+#define MRV_BLS_WINDOW_ENABLE
+#define MRV_BLS_WINDOW_ENABLE_MASK 0x0000000C
+#define MRV_BLS_WINDOW_ENABLE_SHIFT 2
+#define MRV_BLS_WINDOW_ENABLE_NONE  0
+#define MRV_BLS_WINDOW_ENABLE_WND1  1
+#define MRV_BLS_WINDOW_ENABLE_WND2  2
+#define MRV_BLS_WINDOW_ENABLE_BOTH  3
+
+#define MRV_BLS_BLS_MODE
+#define MRV_BLS_BLS_MODE_MASK 0x00000002
+#define MRV_BLS_BLS_MODE_SHIFT 1
+#define MRV_BLS_BLS_MODE_MEAS  1
+#define MRV_BLS_BLS_MODE_FIX   0
+
+#define MRV_BLS_BLS_ENABLE
+#define MRV_BLS_BLS_ENABLE_MASK 0x00000001
+#define MRV_BLS_BLS_ENABLE_SHIFT 0
+
+#define MRV_BLS_BLS_SAMPLES
+#define MRV_BLS_BLS_SAMPLES_MASK 0x0000001F
+#define MRV_BLS_BLS_SAMPLES_SHIFT 0
+#define MRV_BLS_BLS_SAMPLES_MAX     (0x00000014)
+
+#define MRV_BLS_BLS_H1_START
+#define MRV_BLS_BLS_H1_START_MASK 0x00000FFF
+#define MRV_BLS_BLS_H1_START_SHIFT 0
+#define MRV_BLS_BLS_H1_START_MAX \
+       (MRV_BLS_BLS_H1_START_MASK >> MRV_BLS_BLS_H1_START_SHIFT)
+
+#define MRV_BLS_BLS_H1_STOP
+#define MRV_BLS_BLS_H1_STOP_MASK 0x00001FFF
+#define MRV_BLS_BLS_H1_STOP_SHIFT 0
+#define MRV_BLS_BLS_H1_STOP_MAX \
+       (MRV_BLS_BLS_H1_STOP_MASK >> MRV_BLS_BLS_H1_STOP_SHIFT)
+
+#define MRV_BLS_BLS_V1_START
+#define MRV_BLS_BLS_V1_START_MASK 0x00001FFF
+#define MRV_BLS_BLS_V1_START_SHIFT 0
+#define MRV_BLS_BLS_V1_START_MAX \
+       (MRV_BLS_BLS_V1_START_MASK >> MRV_BLS_BLS_V1_START_SHIFT)
+
+#define MRV_BLS_BLS_V1_STOP
+#define MRV_BLS_BLS_V1_STOP_MASK 0x00001FFF
+#define MRV_BLS_BLS_V1_STOP_SHIFT 0
+#define MRV_BLS_BLS_V1_STOP_MAX \
+       (MRV_BLS_BLS_V1_STOP_MASK >> MRV_BLS_BLS_V1_STOP_SHIFT)
+
+#define MRV_BLS_BLS_H2_START
+#define MRV_BLS_BLS_H2_START_MASK 0x00001FFF
+#define MRV_BLS_BLS_H2_START_SHIFT 0
+#define MRV_BLS_BLS_H2_START_MAX \
+       (MRV_BLS_BLS_H2_START_MASK >> MRV_BLS_BLS_H2_START_SHIFT)
+
+#define MRV_BLS_BLS_H2_STOP
+#define MRV_BLS_BLS_H2_STOP_MASK 0x00001FFF
+#define MRV_BLS_BLS_H2_STOP_SHIFT 0
+#define MRV_BLS_BLS_H2_STOP_MAX \
+       (MRV_BLS_BLS_H2_STOP_MASK >> MRV_BLS_BLS_H2_STOP_SHIFT)
+
+#define MRV_BLS_BLS_V2_START
+#define MRV_BLS_BLS_V2_START_MASK 0x00001FFF
+#define MRV_BLS_BLS_V2_START_SHIFT 0
+#define MRV_BLS_BLS_V2_START_MAX \
+       (MRV_BLS_BLS_V2_START_MASK >> MRV_BLS_BLS_V2_START_SHIFT)
+
+#define MRV_BLS_BLS_V2_STOP
+#define MRV_BLS_BLS_V2_STOP_MASK 0x00001FFF
+#define MRV_BLS_BLS_V2_STOP_SHIFT 0
+#define MRV_BLS_BLS_V2_STOP_MAX \
+       (MRV_BLS_BLS_V2_STOP_MASK >> MRV_BLS_BLS_V2_STOP_SHIFT)
+
+#define MRV_ISP_BLS_FIX_SUB_MIN     (0xFFFFF001)
+#define MRV_ISP_BLS_FIX_SUB_MAX     (0x00000FFF)
+#define MRV_ISP_BLS_FIX_MASK        (0x00001FFF)
+#define MRV_ISP_BLS_FIX_SHIFT_A              (0)
+#define MRV_ISP_BLS_FIX_SHIFT_B              (0)
+#define MRV_ISP_BLS_FIX_SHIFT_C              (0)
+#define MRV_ISP_BLS_FIX_SHIFT_D              (0)
+#define MRV_ISP_BLS_MEAN_MASK       (0x00000FFF)
+#define MRV_ISP_BLS_MEAN_SHIFT_A             (0)
+#define MRV_ISP_BLS_MEAN_SHIFT_B             (0)
+#define MRV_ISP_BLS_MEAN_SHIFT_C             (0)
+#define MRV_ISP_BLS_MEAN_SHIFT_D             (0)
+
+#define MRV_BLS_BLS_A_FIXED
+#define MRV_BLS_BLS_A_FIXED_MASK (MRV_ISP_BLS_FIX_MASK <<\
+                                 MRV_ISP_BLS_FIX_SHIFT_A)
+#define MRV_BLS_BLS_A_FIXED_SHIFT MRV_ISP_BLS_FIX_SHIFT_A
+
+#define MRV_BLS_BLS_B_FIXED
+#define MRV_BLS_BLS_B_FIXED_MASK (MRV_ISP_BLS_FIX_MASK <<\
+                                 MRV_ISP_BLS_FIX_SHIFT_B)
+#define MRV_BLS_BLS_B_FIXED_SHIFT MRV_ISP_BLS_FIX_SHIFT_B
+
+#define MRV_BLS_BLS_C_FIXED
+#define MRV_BLS_BLS_C_FIXED_MASK (MRV_ISP_BLS_FIX_MASK <<\
+                                 MRV_ISP_BLS_FIX_SHIFT_C)
+#define MRV_BLS_BLS_C_FIXED_SHIFT MRV_ISP_BLS_FIX_SHIFT_C
+
+#define MRV_BLS_BLS_D_FIXED
+#define MRV_BLS_BLS_D_FIXED_MASK (MRV_ISP_BLS_FIX_MASK <<\
+                                 MRV_ISP_BLS_FIX_SHIFT_D)
+#define MRV_BLS_BLS_D_FIXED_SHIFT MRV_ISP_BLS_FIX_SHIFT_D
+
+#define MRV_BLS_BLS_A_MEASURED
+#define MRV_BLS_BLS_A_MEASURED_MASK (MRV_ISP_BLS_MEAN_MASK <<\
+                                    MRV_ISP_BLS_MEAN_SHIFT_A)
+#define MRV_BLS_BLS_A_MEASURED_SHIFT MRV_ISP_BLS_MEAN_SHIFT_A
+
+#define MRV_BLS_BLS_B_MEASURED
+#define MRV_BLS_BLS_B_MEASURED_MASK (MRV_ISP_BLS_MEAN_MASK <<\
+                                    MRV_ISP_BLS_MEAN_SHIFT_B)
+#define MRV_BLS_BLS_B_MEASURED_SHIFT MRV_ISP_BLS_MEAN_SHIFT_B
+
+#define MRV_BLS_BLS_C_MEASURED
+#define MRV_BLS_BLS_C_MEASURED_MASK (MRV_ISP_BLS_MEAN_MASK <<\
+                                    MRV_ISP_BLS_MEAN_SHIFT_C)
+#define MRV_BLS_BLS_C_MEASURED_SHIFT MRV_ISP_BLS_MEAN_SHIFT_C
+
+#define MRV_BLS_BLS_D_MEASURED
+#define MRV_BLS_BLS_D_MEASURED_MASK (MRV_ISP_BLS_MEAN_MASK <<\
+                                    MRV_ISP_BLS_MEAN_SHIFT_D)
+#define MRV_BLS_BLS_D_MEASURED_SHIFT MRV_ISP_BLS_MEAN_SHIFT_D
+
+#define CI_ISP_DELAY_AFTER_RESET 15
+
+#define IRQ_ISP_ERROR  -1
+#define        IRQ_JPE_ERROR   0
+#define IRQ_JPE_SUCCESS        1
+#define IRQ_MI_SUCCESS         2
+#define IRQ_MI_SP_SUCCESS      3
+#define IRQ    1
+
+#endif
diff --git a/drivers/media/video/mrstci/mrstisp/include/mrstisp_stdinc.h b/drivers/media/video/mrstci/mrstisp/include/mrstisp_stdinc.h
new file mode 100644
index 0000000..033a104
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/include/mrstisp_stdinc.h
@@ -0,0 +1,115 @@
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
+#include "ci_sensor_common.h"
+#include "ci_isp_common.h"
+#include "ci_va.h"
+#include "v4l2_jpg_review.h"
+
+#include "def.h"
+#include "mrstisp_reg.h"
+#include "mrstisp.h"
+#include "mrstisp_isp.h"
+#include "mrstisp_hw.h"
+#include "mrstisp_jpe.h"
+#include "mrstisp_dp.h"
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
+#define DBG_entering   dprintk(1, "entering");
+#define DBG_leaving    dprintk(1, "leaving");
+#define DBG_line       dprintk(1, " line: %d", __LINE__);
+
+#include "reg_access.h"
+
+#endif
+#endif
diff --git a/drivers/media/video/mrstci/mrstisp/include/reg_access.h b/drivers/media/video/mrstci/mrstisp/include/reg_access.h
new file mode 100644
index 0000000..1f905fe
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/include/reg_access.h
@@ -0,0 +1,119 @@
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
+#ifndef _REG_ACCESS_H
+#define _REG_ACCESS_H
+
+#define DBG_DD(x) \
+       do { \
+               if (mrstisp_debug >= 4) {       \
+                       printk(KERN_INFO "mrstisp@%s ", __func__);      \
+                       printk x; \
+               }       \
+       } while (0)
+
+static inline u32 _reg_read(u32 reg, const char *text)
+{
+       u32 variable = reg;
+       DBG_DD((text, variable));
+       return variable;
+}
+
+#define REG_READ(reg) \
+_reg_read((reg),  "REG_READ(" VAL2STR(reg) "): 0x%08X\n")
+
+static inline u32 _reg_read_ex(u32 reg, const char *text)
+{
+       u32 variable = reg;
+       DBG_DD((text, variable));
+       return variable;
+}
+
+#define REG_READ_EX(reg) \
+_reg_read_ex((reg),  "REG_READ_EX(" VAL2STR(reg) "): 0x%08X\n")
+
+#define REG_WRITE(reg, value) \
+{ \
+       dprintk(4, \
+       "REG_WRITE(" VAL2STR(reg) ", " VAL2STR(value) "): 0x%08X", (value)); \
+       (reg) = (value); \
+}
+
+#define REG_WRITE_EX(reg, value) \
+{ \
+       (reg) = (value); \
+}
+
+static inline u32 _reg_get_slice(const char *text, u32 val)
+{
+       u32 variable = val;
+       DBG_DD((text, variable));
+       return val;
+}
+
+#define REG_GET_SLICE_EX(reg, name) \
+       (((reg) & (name##_MASK)) >> (name##_SHIFT))
+
+#define REG_GET_SLICE(reg, name) \
+       _reg_get_slice("REG_GET_SLICE(" VAL2STR(reg) ", " VAL2STR(name) \
+                      "): 0x%08X\n" , \
+       (((reg) & (name##_MASK)) >> (name##_SHIFT)))
+
+#define REG_SET_SLICE(reg, name, value) \
+{ \
+       dprintk(4, \
+               "REG_SET_SLICE(" VAL2STR(reg) ", " VAL2STR(name) \
+               ", " VAL2STR(value) "): 0x%08X", \
+               (value));       \
+               ((reg) = (((reg) & ~(name##_MASK)) | \
+               (((value) << (name##_SHIFT)) & (name##_MASK)))); \
+}
+
+#define REG_SET_SLICE_EX(reg, name, value) \
+{ \
+               ((reg) = (((reg) & ~(name##_MASK)) | \
+               (((value) << (name##_SHIFT)) & (name##_MASK)))); \
+}
+
+#define REG_GET_ARRAY_ELEM1(areg, name, idx) \
+((idx < name##_ARR_SIZE) \
+? areg[idx] \
+: 0)
+
+#define REG_SET_ARRAY_ELEM1(areg, name, idx, value) \
+((idx < name##_ARR_SIZE) \
+? areg[idx] = value \
+: 0)
+
+#define REG_GET_ARRAY_ELEM2(areg, name, idx1, idx2) \
+(((idx1 < name##_ARR_SIZE1) && (idx2 < name##_ARR_SIZE2)) \
+? areg[(idx1 * name##_ARR_OFS1) + (idx2 * name##_ARR_OFS2)] \
+: 0)
+
+#define REG_SET_ARRAY_ELEM2(areg, name, idx1, idx2, value) \
+(((idx1 < name##_ARR_SIZE1) && (idx2 < name##_ARR_SIZE2)) \
+? areg[(idx1 * name##_ARR_OFS1) + (idx2 * name##_ARR_OFS2)] = value \
+: 0)
+#endif
--
1.6.3.2

