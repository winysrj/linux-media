Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19464 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461Ab0ESDMy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 23:12:54 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 19 May 2010 11:11:44 +0800
Subject: [PATCH v3 05/10] V4L2 ISP driver patchset for Intel Moorestown
 Camera Imaging Subsystem
Message-ID: <33AB447FBD802F4E932063B962385B351E895D99@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 452c66ba35af892c40bfeb7cabdde8670018b7ba Mon Sep 17 00:00:00 2001
From: Xiaolin Zhang <xiaolin.zhang@intel.com>
Date: Tue, 18 May 2010 15:45:32 +0800
Subject: [PATCH 05/10] This patch is a part of v4l2 ISP patchset for Intel Moorestown camera imaging
 subsystem support which control the ISP memory interface setting and register
 spec.

Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
---
 drivers/media/video/mrstisp/include/mrstisp_reg.h | 4499 +++++++++++++++++++++
 drivers/media/video/mrstisp/include/reg_access.h  |   94 +
 drivers/media/video/mrstisp/mrstisp_mif.c         |  703 ++++
 3 files changed, 5296 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/mrstisp/include/mrstisp_reg.h
 create mode 100644 drivers/media/video/mrstisp/include/reg_access.h
 create mode 100644 drivers/media/video/mrstisp/mrstisp_mif.c

diff --git a/drivers/media/video/mrstisp/include/mrstisp_reg.h b/drivers/media/video/mrstisp/include/mrstisp_reg.h
new file mode 100644
index 0000000..1550e66
--- /dev/null
+++ b/drivers/media/video/mrstisp/include/mrstisp_reg.h
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
diff --git a/drivers/media/video/mrstisp/include/reg_access.h b/drivers/media/video/mrstisp/include/reg_access.h
new file mode 100644
index 0000000..069e5d4
--- /dev/null
+++ b/drivers/media/video/mrstisp/include/reg_access.h
@@ -0,0 +1,94 @@
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
+_reg_read((reg),  "REG_READ(" __stringify(reg) "): 0x%08X\n")
+
+static inline u32 _reg_read_ex(u32 reg, const char *text)
+{
+       u32 variable = reg;
+       DBG_DD((text, variable));
+       return variable;
+}
+
+#define REG_READ_EX(reg) \
+_reg_read_ex((reg),  "REG_READ_EX(" __stringify(reg) "): 0x%08X\n")
+
+#define REG_WRITE(reg, value) \
+{ \
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
+       _reg_get_slice("REG_GET_SLICE(" __stringify(reg) ", " __stringify(name) \
+                      "): 0x%08X\n" , \
+       (((reg) & (name##_MASK)) >> (name##_SHIFT)))
+
+#define REG_SET_SLICE(reg, name, value) \
+{ \
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
+#endif
diff --git a/drivers/media/video/mrstisp/mrstisp_mif.c b/drivers/media/video/mrstisp/mrstisp_mif.c
new file mode 100644
index 0000000..e88ffbc
--- /dev/null
+++ b/drivers/media/video/mrstisp/mrstisp_mif.c
@@ -0,0 +1,703 @@
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
+#include "mrstisp_stdinc.h"
+
+/*
+ * sets all main picture and self picture buffer offsets back to 0
+ */
+void ci_isp_mif_reset_offsets(enum ci_isp_conf_update_time update_time)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       REG_SET_SLICE(mrv_reg->mi_mp_y_offs_cnt_init,
+                     MRV_MI_MP_Y_OFFS_CNT_INIT, 0);
+       REG_SET_SLICE(mrv_reg->mi_mp_cb_offs_cnt_init,
+                     MRV_MI_MP_CB_OFFS_CNT_INIT, 0);
+       REG_SET_SLICE(mrv_reg->mi_mp_cr_offs_cnt_init,
+                     MRV_MI_MP_CR_OFFS_CNT_INIT, 0);
+
+       REG_SET_SLICE(mrv_reg->mi_sp_y_offs_cnt_init,
+                     MRV_MI_SP_Y_OFFS_CNT_INIT, 0);
+       REG_SET_SLICE(mrv_reg->mi_sp_cb_offs_cnt_init,
+                     MRV_MI_SP_CB_OFFS_CNT_INIT, 0);
+       REG_SET_SLICE(mrv_reg->mi_sp_cr_offs_cnt_init,
+                     MRV_MI_SP_CR_OFFS_CNT_INIT, 0);
+
+       REG_SET_SLICE(mrv_reg->mi_ctrl, MRV_MI_INIT_OFFSET_EN, ON);
+       REG_SET_SLICE(mrv_reg->mi_ctrl, MRV_MI_INIT_BASE_EN, ON);
+
+       switch (update_time) {
+       case CI_ISP_CFG_UPDATE_FRAME_SYNC:
+               break;
+       case CI_ISP_CFG_UPDATE_IMMEDIATE:
+               REG_SET_SLICE(mrv_reg->mi_init, MRV_MI_MI_CFG_UPD, ON);
+               break;
+       case CI_ISP_CFG_UPDATE_LATER:
+               break;
+       default:
+               break;
+       }
+}
+
+/*
+ * This function get the byte count from the last JPEG or raw data transfer
+ */
+u32 ci_isp_mif_get_byte_cnt(void)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       return (u32) REG_GET_SLICE(mrv_reg->mi_byte_cnt, MRV_MI_BYTE_CNT);
+}
+
+/*
+ * Sets the desired self picture orientation, if possible.
+ */
+static int ci_isp_mif_set_self_pic_orientation(enum ci_isp_mif_sp_mode
+                                               mrv_mif_sp_mode,
+                                               int activate_self_path)
+{
+
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 mi_ctrl = REG_READ(mrv_reg->mi_ctrl);
+
+       u32 output_format = REG_GET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT);
+
+       switch (mrv_mif_sp_mode) {
+       case CI_ISP_MIF_SP_ORIGINAL:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP, 0);
+               break;
+
+       case CI_ISP_MIF_SP_HORIZONTAL_FLIP:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP,
+                             MRV_MI_ROT_AND_FLIP_H_FLIP);
+               break;
+
+       case CI_ISP_MIF_SP_VERTICAL_FLIP:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP,
+                             MRV_MI_ROT_AND_FLIP_V_FLIP);
+               break;
+
+       case CI_ISP_MIF_SP_ROTATION_090_DEG:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP,
+                             MRV_MI_ROT_AND_FLIP_ROTATE);
+               break;
+
+       case CI_ISP_MIF_SP_ROTATION_180_DEG:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP,
+                             MRV_MI_ROT_AND_FLIP_H_FLIP |
+                             MRV_MI_ROT_AND_FLIP_V_FLIP);
+               break;
+
+       case CI_ISP_MIF_SP_ROTATION_270_DEG:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP,
+                             MRV_MI_ROT_AND_FLIP_H_FLIP |
+                             MRV_MI_ROT_AND_FLIP_V_FLIP |
+                             MRV_MI_ROT_AND_FLIP_ROTATE);
+               break;
+
+       case CI_ISP_MIF_SP_ROT_090_V_FLIP:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP,
+                             MRV_MI_ROT_AND_FLIP_V_FLIP |
+                             MRV_MI_ROT_AND_FLIP_ROTATE);
+               break;
+
+       case CI_ISP_MIF_SP_ROT_270_V_FLIP:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP,
+                             MRV_MI_ROT_AND_FLIP_H_FLIP |
+                             MRV_MI_ROT_AND_FLIP_ROTATE);
+               break;
+
+       default:
+               eprintk("unknown value for mrv_mif_sp_mode");
+               return CI_STATUS_NOTSUPP;
+       }
+
+       if (REG_GET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP) &
+           MRV_MI_ROT_AND_FLIP_ROTATE) {
+               switch (output_format) {
+               case MRV_MI_SP_OUTPUT_FORMAT_RGB888:
+               case MRV_MI_SP_OUTPUT_FORMAT_RGB666:
+               case MRV_MI_SP_OUTPUT_FORMAT_RGB565:
+                       break;
+               default:
+                       eprintk("rotation is only allowed for RGB modes.");
+                       return CI_STATUS_NOTSUPP;
+               }
+       }
+
+       REG_SET_SLICE(mi_ctrl, MRV_MI_SP_ENABLE,
+                     (activate_self_path) ? ENABLE : DISABLE);
+       REG_WRITE(mrv_reg->mi_ctrl, mi_ctrl);
+       REG_SET_SLICE(mrv_reg->mi_init, MRV_MI_MI_CFG_UPD, ON);
+
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * Checks the main or self picture path buffer structure.
+ */
+static int ci_isp_mif_check_mi_path_conf(const struct ci_isp_mi_path_conf
+                                        *isp_mi_path_conf, int main_buffer)
+{
+       if (!isp_mi_path_conf) {
+               eprintk("isp_mi_path_conf is NULL");
+               return CI_STATUS_NULL_POINTER;
+       }
+
+       if (!isp_mi_path_conf->ybuffer.pucbuffer) {
+               eprintk("isp_mi_path_conf->ybuffer.pucbuffer is NULL");
+               return CI_STATUS_NULL_POINTER;
+       }
+
+       if (main_buffer) {
+               if ((((unsigned long)(isp_mi_path_conf->ybuffer.pucbuffer)
+                     & ~(MRV_MI_MP_Y_BASE_AD_INIT_VALID_MASK)) != 0)
+                       ||
+                       ((isp_mi_path_conf->ybuffer.size
+                       & ~(MRV_MI_MP_Y_SIZE_INIT_VALID_MASK)) != 0)
+                       ||
+                       ((isp_mi_path_conf->ybuffer.size
+                       & (MRV_MI_MP_Y_SIZE_INIT_VALID_MASK)) == 0)
+                       ||
+                       ((isp_mi_path_conf->ybuffer.offs
+                       & ~(MRV_MI_MP_Y_OFFS_CNT_INIT_VALID_MASK)) != 0)) {
+                               return CI_STATUS_OUTOFRANGE;
+               }
+       } else {
+               if ((((unsigned long) isp_mi_path_conf->ybuffer.pucbuffer
+                       & ~(MRV_MI_SP_Y_BASE_AD_INIT_VALID_MASK)) != 0)
+                       ||
+                       ((isp_mi_path_conf->ybuffer.size &
+                       ~(MRV_MI_SP_Y_SIZE_INIT_VALID_MASK)) != 0)
+                       ||
+                       ((isp_mi_path_conf->ybuffer.size &
+                       (MRV_MI_SP_Y_SIZE_INIT_VALID_MASK)) == 0)
+                       ||
+                       ((isp_mi_path_conf->ybuffer.offs &
+                       ~(MRV_MI_SP_Y_OFFS_CNT_INIT_VALID_MASK)) !=
+                       0)
+                       ||
+                       ((isp_mi_path_conf->llength &
+                       ~(MRV_MI_SP_Y_LLENGTH_VALID_MASK)) != 0)
+                       ||
+                       ((isp_mi_path_conf->
+                       llength & (MRV_MI_SP_Y_LLENGTH_VALID_MASK)) == 0)) {
+                       return CI_STATUS_OUTOFRANGE;
+               }
+       }
+
+       if (isp_mi_path_conf->cb_buffer.pucbuffer != 0) {
+               if (main_buffer) {
+                       if ((((unsigned long)
+                               isp_mi_path_conf->cb_buffer.pucbuffer
+                               & ~(MRV_MI_MP_CB_BASE_AD_INIT_VALID_MASK)) !=
+                               0)
+                               ||
+                               ((isp_mi_path_conf->cb_buffer.size &
+                               ~(MRV_MI_MP_CB_SIZE_INIT_VALID_MASK)) != 0)
+                               ||
+                               ((isp_mi_path_conf->cb_buffer.size &
+                               (MRV_MI_MP_CB_SIZE_INIT_VALID_MASK)) == 0)
+                               ||
+                               ((isp_mi_path_conf->cb_buffer.offs &
+                               ~(MRV_MI_MP_CB_OFFS_CNT_INIT_VALID_MASK)) !=
+                               0)) {
+                                       return CI_STATUS_OUTOFRANGE;
+                       }
+               } else {
+                       if ((((unsigned long)
+                               isp_mi_path_conf->cb_buffer.pucbuffer
+                               & ~(MRV_MI_SP_CB_BASE_AD_INIT_VALID_MASK)) !=
+                               0)
+                               ||
+                               ((isp_mi_path_conf->cb_buffer.size &
+                               ~(MRV_MI_SP_CB_SIZE_INIT_VALID_MASK)) != 0)
+                               ||
+                               ((isp_mi_path_conf->cb_buffer.size &
+                               (MRV_MI_SP_CB_SIZE_INIT_VALID_MASK)) == 0)
+                               ||
+                               ((isp_mi_path_conf->cb_buffer.offs &
+                               ~(MRV_MI_SP_CB_OFFS_CNT_INIT_VALID_MASK)) !=
+                               0)) {
+                                       return CI_STATUS_OUTOFRANGE;
+                       }
+               }
+       }
+
+       if (isp_mi_path_conf->cr_buffer.pucbuffer != 0) {
+               if (main_buffer) {
+                       if ((((unsigned long)
+                               isp_mi_path_conf->cr_buffer.pucbuffer
+                               & ~(MRV_MI_MP_CR_BASE_AD_INIT_VALID_MASK)) !=
+                               0)
+                               ||
+                               ((isp_mi_path_conf->cr_buffer.size &
+                               ~(MRV_MI_MP_CR_SIZE_INIT_VALID_MASK)) != 0)
+                               ||
+                               ((isp_mi_path_conf->cr_buffer.size &
+                               (MRV_MI_MP_CR_SIZE_INIT_VALID_MASK)) == 0)
+                               ||
+                               ((isp_mi_path_conf->cr_buffer.offs &
+                               ~(MRV_MI_MP_CR_OFFS_CNT_INIT_VALID_MASK)) !=
+                               0)){
+                                       return CI_STATUS_OUTOFRANGE;
+                       }
+               } else {
+                       if ((((unsigned long)
+                               isp_mi_path_conf->cr_buffer.pucbuffer
+                               & ~(MRV_MI_SP_CR_BASE_AD_INIT_VALID_MASK))
+                               != 0)
+                           ||
+                           ((isp_mi_path_conf->cr_buffer.size &
+                             ~(MRV_MI_SP_CR_SIZE_INIT_VALID_MASK)) != 0)
+                           ||
+                           ((isp_mi_path_conf->cr_buffer.size &
+                           (MRV_MI_SP_CR_SIZE_INIT_VALID_MASK)) == 0)
+                           ||
+                           ((isp_mi_path_conf->cr_buffer.offs &
+                           ~(MRV_MI_SP_CR_OFFS_CNT_INIT_VALID_MASK)) != 0)) {
+                               return CI_STATUS_OUTOFRANGE;
+                       }
+               }
+       }
+
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * Configures the main picture path buffers of the MI.
+ */
+int ci_isp_mif_set_main_buffer(const struct ci_isp_mi_path_conf
+                              *isp_mi_path_conf,
+                              enum ci_isp_conf_update_time update_time)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       int error = CI_STATUS_FAILURE;
+
+       error = ci_isp_mif_check_mi_path_conf(isp_mi_path_conf, true);
+       if (error != CI_STATUS_SUCCESS)
+               return error;
+
+       /* set register values */
+       REG_SET_SLICE(mrv_reg->mi_mp_y_base_ad_init,
+                     MRV_MI_MP_Y_BASE_AD_INIT,
+                     (u32)(unsigned long)isp_mi_path_conf->ybuffer.pucbuffer);
+       REG_SET_SLICE(mrv_reg->mi_mp_y_size_init, MRV_MI_MP_Y_SIZE_INIT,
+                     isp_mi_path_conf->ybuffer.size);
+       REG_SET_SLICE(mrv_reg->mi_mp_y_offs_cnt_init,
+                     MRV_MI_MP_Y_OFFS_CNT_INIT,
+                     isp_mi_path_conf->ybuffer.offs);
+
+       if (isp_mi_path_conf->cb_buffer.pucbuffer != 0) {
+               REG_SET_SLICE(mrv_reg->mi_mp_cb_base_ad_init,
+                             MRV_MI_MP_CB_BASE_AD_INIT,
+                             (u32)(unsigned long) isp_mi_path_conf->cb_buffer.
+                             pucbuffer);
+               REG_SET_SLICE(mrv_reg->mi_mp_cb_size_init,
+                             MRV_MI_MP_CB_SIZE_INIT,
+                             isp_mi_path_conf->cb_buffer.size);
+               REG_SET_SLICE(mrv_reg->mi_mp_cb_offs_cnt_init,
+                             MRV_MI_MP_CB_OFFS_CNT_INIT,
+                             isp_mi_path_conf->cb_buffer.offs);
+       }
+
+       if (isp_mi_path_conf->cr_buffer.pucbuffer != 0) {
+               REG_SET_SLICE(mrv_reg->mi_mp_cr_base_ad_init,
+                             MRV_MI_MP_CR_BASE_AD_INIT,
+                             (u32)(unsigned long) isp_mi_path_conf->cr_buffer.
+                             pucbuffer);
+               REG_SET_SLICE(mrv_reg->mi_mp_cr_size_init,
+                             MRV_MI_MP_CR_SIZE_INIT,
+                             isp_mi_path_conf->cr_buffer.size);
+               REG_SET_SLICE(mrv_reg->mi_mp_cr_offs_cnt_init,
+                             MRV_MI_MP_CR_OFFS_CNT_INIT,
+                             isp_mi_path_conf->cr_buffer.offs);
+       }
+
+       /*
+        * update base and offset registers during next immediate or
+        * automatic update request
+        */
+       REG_SET_SLICE(mrv_reg->mi_ctrl, MRV_MI_INIT_OFFSET_EN, ENABLE);
+       REG_SET_SLICE(mrv_reg->mi_ctrl, MRV_MI_INIT_BASE_EN, ENABLE);
+
+       switch (update_time) {
+       case CI_ISP_CFG_UPDATE_FRAME_SYNC:
+               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_GEN_CFG_UPD, ON);
+               break;
+       case CI_ISP_CFG_UPDATE_IMMEDIATE:
+               REG_SET_SLICE(mrv_reg->mi_init, MRV_MI_MI_CFG_UPD, ON);
+               break;
+       case CI_ISP_CFG_UPDATE_LATER:
+               break;
+       default:
+               break;
+       }
+
+       return error;
+}
+
+/*
+ * Configures the self picture path buffers of the MI.
+ *
+ */
+int ci_isp_mif_set_self_buffer(const struct ci_isp_mi_path_conf
+                               *isp_mi_path_conf,
+                               enum ci_isp_conf_update_time update_time)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       int error = CI_STATUS_FAILURE;
+
+       error = ci_isp_mif_check_mi_path_conf(isp_mi_path_conf, false);
+       if (error != CI_STATUS_SUCCESS)
+               return error;
+
+       /* set register values */
+       REG_SET_SLICE(mrv_reg->mi_sp_y_base_ad_init,
+                     MRV_MI_SP_Y_BASE_AD_INIT,
+                     (u32)(unsigned long)isp_mi_path_conf->ybuffer.pucbuffer);
+       REG_SET_SLICE(mrv_reg->mi_sp_y_size_init, MRV_MI_SP_Y_SIZE_INIT,
+                     isp_mi_path_conf->ybuffer.size);
+       REG_SET_SLICE(mrv_reg->mi_sp_y_offs_cnt_init,
+                     MRV_MI_SP_Y_OFFS_CNT_INIT,
+                     isp_mi_path_conf->ybuffer.offs);
+
+       /*
+        * llength is counted in pixels and this value could be stored
+        * directly into the register
+        */
+       REG_SET_SLICE(mrv_reg->mi_sp_y_llength, MRV_MI_SP_Y_LLENGTH,
+                     isp_mi_path_conf->llength);
+
+       if (isp_mi_path_conf->cb_buffer.pucbuffer) {
+               REG_SET_SLICE(mrv_reg->mi_sp_cb_base_ad_init,
+                             MRV_MI_SP_CB_BASE_AD_INIT,
+                             (u32) (unsigned long)isp_mi_path_conf->cb_buffer.
+                             pucbuffer);
+               REG_SET_SLICE(mrv_reg->mi_sp_cb_size_init,
+                             MRV_MI_SP_CB_SIZE_INIT,
+                             isp_mi_path_conf->cb_buffer.size);
+               REG_SET_SLICE(mrv_reg->mi_sp_cb_offs_cnt_init,
+                             MRV_MI_SP_CB_OFFS_CNT_INIT,
+                             isp_mi_path_conf->cb_buffer.offs);
+       }
+
+       if (isp_mi_path_conf->cr_buffer.pucbuffer) {
+               REG_SET_SLICE(mrv_reg->mi_sp_cr_base_ad_init,
+                             MRV_MI_SP_CR_BASE_AD_INIT,
+                             (u32) (unsigned long)isp_mi_path_conf->cr_buffer.
+                             pucbuffer);
+               REG_SET_SLICE(mrv_reg->mi_sp_cr_size_init,
+                             MRV_MI_SP_CR_SIZE_INIT,
+                             isp_mi_path_conf->cr_buffer.size);
+               REG_SET_SLICE(mrv_reg->mi_sp_cr_offs_cnt_init,
+                             MRV_MI_SP_CR_OFFS_CNT_INIT,
+                             isp_mi_path_conf->cr_buffer.offs);
+       }
+
+       if ((!isp_mi_path_conf->ypic_width)
+           || (!isp_mi_path_conf->ypic_height)) {
+               return CI_STATUS_FAILURE;
+       }
+
+       REG_SET_SLICE(mrv_reg->mi_sp_y_pic_width, MRV_MI_SP_Y_PIC_WIDTH,
+                     isp_mi_path_conf->ypic_width);
+       REG_SET_SLICE(mrv_reg->mi_sp_y_pic_height, MRV_MI_SP_Y_PIC_HEIGHT,
+                     isp_mi_path_conf->ypic_height);
+       REG_SET_SLICE(mrv_reg->mi_sp_y_pic_size, MRV_MI_SP_Y_PIC_SIZE,
+                     isp_mi_path_conf->ypic_height *
+                     isp_mi_path_conf->llength);
+
+       /*
+        * update base and offset registers during next immediate or
+        * automatic update request
+        */
+       REG_SET_SLICE(mrv_reg->mi_ctrl, MRV_MI_INIT_OFFSET_EN, ENABLE);
+       REG_SET_SLICE(mrv_reg->mi_ctrl, MRV_MI_INIT_BASE_EN, ENABLE);
+
+       switch (update_time) {
+       case CI_ISP_CFG_UPDATE_FRAME_SYNC:
+               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_GEN_CFG_UPD,
+                             ON);
+               break;
+       case CI_ISP_CFG_UPDATE_IMMEDIATE:
+               REG_SET_SLICE(mrv_reg->mi_init, MRV_MI_MI_CFG_UPD, ON);
+               break;
+       case CI_ISP_CFG_UPDATE_LATER:
+               break;
+       default:
+               break;
+       }
+
+       return error;
+}
+
+/*
+ * Configures the DMA path of the MI.
+ *
+ */
+int ci_isp_mif_set_path_and_orientation(const struct ci_isp_mi_ctrl
+                                       *mrv_mi_ctrl)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       int error = CI_STATUS_OUTOFRANGE;
+       u32 mi_ctrl = 0;
+
+       if (!mrv_mi_ctrl) {
+               eprintk("mrv_mi_ctrl is NULL");
+               return CI_STATUS_NULL_POINTER;
+       }
+
+       if ((mrv_mi_ctrl->irq_offs_init &
+            ~(MRV_MI_MP_Y_IRQ_OFFS_INIT_VALID_MASK)) != 0) {
+               eprintk("bad mrv_mi_ctrl->irq_offs_init value");
+               return error;
+       }
+
+       REG_SET_SLICE(mrv_reg->mi_mp_y_irq_offs_init,
+                     MRV_MI_MP_Y_IRQ_OFFS_INIT, mrv_mi_ctrl->irq_offs_init);
+
+       /* main picture path */
+       switch (mrv_mi_ctrl->main_path) {
+       case CI_ISP_PATH_OFF:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_MP_ENABLE, OFF);
+               break;
+       case CI_ISP_PATH_ON:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_MP_ENABLE, ON);
+               break;
+       case CI_ISP_PATH_JPE:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_JPEG_ENABLE, ON);
+               break;
+       case CI_ISP_PATH_RAW8:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_RAW_ENABLE, ON);
+               break;
+       case CI_ISP_PATH_RAW816:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_RAW_ENABLE, ON);
+               REG_SET_SLICE(mi_ctrl, MRV_MI_MP_WRITE_FORMAT,
+                             MRV_MI_MP_WRITE_FORMAT_INTERLEAVED);
+               break;
+       default:
+               eprintk("bad mrv_mi_ctrl->main_path value");
+               return error;
+       }
+
+       /* self picture path output format */
+       switch (mrv_mi_ctrl->mrv_mif_sp_out_form) {
+       case CI_ISP_MIF_COL_FORMAT_YCBCR_422:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT,
+                             MRV_MI_SP_OUTPUT_FORMAT_YUV422);
+               break;
+       case CI_ISP_MIF_COL_FORMAT_YCBCR_444:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT,
+                             MRV_MI_SP_OUTPUT_FORMAT_YUV444);
+               break;
+       case CI_ISP_MIF_COL_FORMAT_YCBCR_420:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT,
+                             MRV_MI_SP_OUTPUT_FORMAT_YUV420);
+               break;
+       case CI_ISP_MIF_COL_FORMAT_YCBCR_400:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT,
+                             MRV_MI_SP_OUTPUT_FORMAT_YUV400);
+               break;
+       case CI_ISP_MIF_COL_FORMAT_RGB_565:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT,
+                             MRV_MI_SP_OUTPUT_FORMAT_RGB565);
+               break;
+       case CI_ISP_MIF_COL_FORMAT_RGB_888:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT,
+                             MRV_MI_SP_OUTPUT_FORMAT_RGB888);
+               break;
+       case CI_ISP_MIF_COL_FORMAT_RGB_666:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT,
+                             MRV_MI_SP_OUTPUT_FORMAT_RGB666);
+               break;
+
+       default:
+               eprintk("bad mrv_mi_ctrl->mrv_mif_sp_out_form value");
+               return error;
+       }
+
+       /* self picture path input format */
+       switch (mrv_mi_ctrl->mrv_mif_sp_in_form) {
+       case CI_ISP_MIF_COL_FORMAT_YCBCR_422:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_INPUT_FORMAT,
+                             MRV_MI_SP_INPUT_FORMAT_YUV422);
+               break;
+       case CI_ISP_MIF_COL_FORMAT_YCBCR_444:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_INPUT_FORMAT,
+                             MRV_MI_SP_INPUT_FORMAT_YUV444);
+               break;
+       case CI_ISP_MIF_COL_FORMAT_YCBCR_420:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_INPUT_FORMAT,
+                             MRV_MI_SP_INPUT_FORMAT_YUV420);
+               break;
+       case CI_ISP_MIF_COL_FORMAT_YCBCR_400:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_INPUT_FORMAT,
+                             MRV_MI_SP_INPUT_FORMAT_YUV400);
+               break;
+       case CI_ISP_MIF_COL_FORMAT_RGB_565:
+       case CI_ISP_MIF_COL_FORMAT_RGB_666:
+       case CI_ISP_MIF_COL_FORMAT_RGB_888:
+       default:
+               eprintk("bad mrv_mi_ctrl->mrv_mif_sp_in_form value");
+               return error;
+       }
+
+       error = CI_STATUS_SUCCESS;
+
+       /* self picture path write format */
+       switch (mrv_mi_ctrl->mrv_mif_sp_pic_form) {
+       case CI_ISP_MIF_PIC_FORM_PLANAR:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_WRITE_FORMAT,
+                             MRV_MI_SP_WRITE_FORMAT_PLANAR);
+               break;
+       case CI_ISP_MIF_PIC_FORM_SEMI_PLANAR:
+               if ((mrv_mi_ctrl->mrv_mif_sp_out_form ==
+                   CI_ISP_MIF_COL_FORMAT_YCBCR_422)
+                   || (mrv_mi_ctrl->mrv_mif_sp_out_form ==
+                   CI_ISP_MIF_COL_FORMAT_YCBCR_420)) {
+                       REG_SET_SLICE(mi_ctrl, MRV_MI_SP_WRITE_FORMAT,
+                                     MRV_MI_SP_WRITE_FORMAT_SEMIPLANAR);
+               } else {
+                       error = CI_STATUS_NOTSUPP;
+               }
+               break;
+       case CI_ISP_MIF_PIC_FORM_INTERLEAVED:
+               if (mrv_mi_ctrl->mrv_mif_sp_out_form ==
+                   CI_ISP_MIF_COL_FORMAT_YCBCR_422) {
+                       REG_SET_SLICE(mi_ctrl, MRV_MI_SP_WRITE_FORMAT,
+                                     MRV_MI_SP_WRITE_FORMAT_INTERLEAVED);
+               } else {
+                       error = CI_STATUS_NOTSUPP;
+               }
+               break;
+       default:
+               error = CI_STATUS_OUTOFRANGE;
+               break;
+
+       }
+
+       if (error != CI_STATUS_SUCCESS) {
+               eprintk("bad mrv_mi_ctrl->mrv_mif_sp_pic_form value");
+               return error;
+       }
+
+       if (mrv_mi_ctrl->main_path == CI_ISP_PATH_ON) {
+               /* for YCbCr mode only, permitted for raw mode */
+               /* main picture path write format */
+               switch (mrv_mi_ctrl->mrv_mif_mp_pic_form) {
+               case CI_ISP_MIF_PIC_FORM_PLANAR:
+                       REG_SET_SLICE(mi_ctrl, MRV_MI_MP_WRITE_FORMAT,
+                                     MRV_MI_MP_WRITE_FORMAT_PLANAR);
+                       break;
+               case CI_ISP_MIF_PIC_FORM_SEMI_PLANAR:
+                       REG_SET_SLICE(mi_ctrl, MRV_MI_MP_WRITE_FORMAT,
+                                     MRV_MI_MP_WRITE_FORMAT_SEMIPLANAR);
+                       break;
+               case CI_ISP_MIF_PIC_FORM_INTERLEAVED:
+                       REG_SET_SLICE(mi_ctrl, MRV_MI_MP_WRITE_FORMAT,
+                                     MRV_MI_MP_WRITE_FORMAT_INTERLEAVED);
+                       break;
+               default:
+                       error = CI_STATUS_OUTOFRANGE;
+                       break;
+               }
+       }
+
+       if (error != CI_STATUS_SUCCESS) {
+               eprintk("bad mrv_mi_ctrl->mrv_mif_mp_pic_form value");
+               return error;
+       }
+
+       REG_SET_SLICE(mi_ctrl, MRV_MI_BURST_LEN_CHROM,
+           MRV_MI_BURST_LEN_CHROM_16);
+
+       if (error != CI_STATUS_SUCCESS) {
+               eprintk("bad mrv_mi_ctrl->burst_length_chrom value");
+               return error;
+       }
+
+       REG_SET_SLICE(mi_ctrl, MRV_MI_BURST_LEN_LUM,
+           MRV_MI_BURST_LEN_LUM_16);
+
+       if (error != CI_STATUS_SUCCESS) {
+               eprintk("bad mrv_mi_ctrl->burst_length_lum value");
+               return error;
+       }
+
+       switch (mrv_mi_ctrl->init_vals) {
+       case CI_ISP_MIF_NO_INIT_VALS:
+               break;
+       case CI_ISP_MIF_INIT_OFFS:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_INIT_OFFSET_EN, ENABLE);
+               break;
+       case CI_ISP_MIF_INIT_BASE:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_INIT_BASE_EN, ENABLE);
+               break;
+       case CI_ISP_MIF_INIT_OFFSAndBase:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_INIT_OFFSET_EN, ENABLE);
+               REG_SET_SLICE(mi_ctrl, MRV_MI_INIT_BASE_EN, ENABLE);
+               break;
+       default:
+               error = CI_STATUS_OUTOFRANGE;
+               break;
+       }
+
+       if (error != CI_STATUS_SUCCESS) {
+               eprintk("bad mrv_mi_ctrl->init_vals value");
+               return error;
+       }
+
+       /* enable change of byte order for write port */
+       REG_SET_SLICE(mi_ctrl, MRV_MI_BYTE_SWAP,
+           (mrv_mi_ctrl->byte_swap_enable) ? ON : OFF);
+
+       /* enable or disable the last pixel signalization */
+       REG_SET_SLICE(mi_ctrl, MRV_MI_LAST_PIXEL_SIG_EN,
+           (mrv_mi_ctrl->last_pixel_enable) ? ON : OFF);
+
+       /* now write settings into register */
+       REG_WRITE(mrv_reg->mi_ctrl, mi_ctrl);
+
+       dprintk(2, "mi_ctrl = 0x%x", mi_ctrl);
+
+       /* self picture path operating mode */
+       if ((mrv_mi_ctrl->self_path == CI_ISP_PATH_ON) ||
+           (mrv_mi_ctrl->self_path == CI_ISP_PATH_OFF)) {
+
+               error = ci_isp_mif_set_self_pic_orientation(
+                                   mrv_mi_ctrl->mrv_mif_sp_mode,
+                                   (int) (mrv_mi_ctrl->self_path
+                                          == CI_ISP_PATH_ON));
+       } else {
+               eprintk("bad mrv_mi_ctrl->self_path value");
+               error = CI_STATUS_OUTOFRANGE;
+       }
+
+       REG_SET_SLICE(mrv_reg->mi_init, MRV_MI_MI_CFG_UPD, ON);
+
+       return error;
+}
--
1.6.3.2

