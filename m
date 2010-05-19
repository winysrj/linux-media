Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52285 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab0ESDHm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 23:07:42 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 19 May 2010 11:06:28 +0800
Subject: [PATCH v3 02/10] V4L2 ISP driver patchset for Intel Moorestown
 Camera Imaging Subsystem
Message-ID: <33AB447FBD802F4E932063B962385B351E895D87@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 8e64f34ecdff9ea61bde0f901fc298927019964e Mon Sep 17 00:00:00 2001
From: Xiaolin Zhang <xiaolin.zhang@intel.com>
Date: Tue, 18 May 2010 15:38:29 +0800
Subject: [PATCH 02/10] This patch is a part of v4l2 ISP patchset for Intel Moorestown camera imaging
 subsystem support which control the ISP functional block setting.

Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
---
 drivers/media/video/mrstisp/include/mrstisp_hw.h |  173 +++
 drivers/media/video/mrstisp/mrstisp_hw.c         | 1362 ++++++++++++++++++++++
 2 files changed, 1535 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/mrstisp/include/mrstisp_hw.h
 create mode 100644 drivers/media/video/mrstisp/mrstisp_hw.c

diff --git a/drivers/media/video/mrstisp/include/mrstisp_hw.h b/drivers/media/video/mrstisp/include/mrstisp_hw.h
new file mode 100644
index 0000000..010db05
--- /dev/null
+++ b/drivers/media/video/mrstisp/include/mrstisp_hw.h
@@ -0,0 +1,173 @@
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
+int ci_isp_get_wb_meas_config(
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
+void ci_isp_set_gamma2(const struct ci_isp_gamma_out_curve *gamma);
+void ci_isp_set_demosaic(
+       enum ci_isp_demosaic_mode demosaic_mode,
+       u8 demosaic_th
+);
+void mrst_isp_disable_interrupt(struct mrst_isp_device *isp);
+void mrst_isp_enable_interrupt(struct mrst_isp_device *isp);
+#endif
diff --git a/drivers/media/video/mrstisp/mrstisp_hw.c b/drivers/media/video/mrstisp/mrstisp_hw.c
new file mode 100644
index 0000000..3df7d92
--- /dev/null
+++ b/drivers/media/video/mrstisp/mrstisp_hw.c
@@ -0,0 +1,1362 @@
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
+static unsigned long jiffies_start;
+
+void mrst_timer_start(void)
+{
+       jiffies_start = jiffies;
+}
+
+void mrst_timer_stop(void)
+{
+       jiffies_start = 0;
+}
+
+unsigned long mrst_get_micro_sec(void)
+{
+       unsigned long time_diff = 0;
+
+       time_diff = jiffies - jiffies_start;
+
+       return jiffies_to_msecs(time_diff);
+}
+
+/*
+ * Returns the ISP hardware ID.
+ */
+static u32 ci_isp_get_ci_isp_id(void)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 result = 0;
+
+       result = REG_GET_SLICE(mrv_reg->vi_id, MRV_REV_ID);
+
+       return result;
+}
+
+/*
+ * Gets the hardware ID and compares it with the expected one.
+ */
+static int ci_isp_verify_chip_id(void)
+{
+       u32 mrv_id = ci_isp_get_ci_isp_id();
+       dprintk(1, "HW-Id: 0x%08X", mrv_id);
+
+       if (mrv_id != 0x20453010) {
+               /* marvin5_v4_r20 */
+               eprintk("HW-Id does not match! read:0x%08X, expected:0x%08X",
+                       mrv_id, 0x20453010);
+               return CI_STATUS_FAILURE;
+       }
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * Triggers an entire reset of MARVIN (equaling an asynchronous
+ * hardware reset).
+ * Checks the hardware ID. A debug warning is issued if the
+ * module ID does not match the expected ID.
+ * Enables all clocks of all sub-modules.
+ * MARVIN is in idle state afterwards.
+ */
+void ci_isp_init(void)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       ci_isp_verify_chip_id();
+
+       /* enable main clock */
+       REG_SET_SLICE(mrv_reg->vi_ccl, MRV_VI_CCLFDIS, MRV_VI_CCLFDIS_ENABLE);
+
+       /*
+        * enable all clocks to make sure that all submodules will be able to
+        * perform the reset correctly
+        */
+       REG_SET_SLICE(mrv_reg->vi_iccl, MRV_VI_ALL_CLK_ENABLE, ENABLE);
+       REG_SET_SLICE(mrv_reg->vi_ircl, MRV_VI_MARVIN_RST, ON);
+       msleep(CI_ISP_DELAY_AFTER_RESET);
+}
+
+void ci_isp_off(void)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       REG_SET_SLICE(mrv_reg->vi_ccl, MRV_VI_CCLFDIS,
+                     MRV_VI_CCLFDIS_DISABLE);
+       REG_SET_SLICE(mrv_reg->vi_iccl, MRV_VI_ALL_CLK_ENABLE, DISABLE);
+}
+
+u32 ci_isp_get_frame_end_irq_mask_isp(void)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       switch (REG_GET_SLICE(mrv_reg->vi_dpcl, MRV_VI_DMA_SWITCH)) {
+       case MRV_VI_DMA_SWITCH_IE:
+               return 0;
+       case MRV_VI_DMA_SWITCH_SELF:
+       case MRV_VI_DMA_SWITCH_SI:
+       case MRV_VI_DMA_SWITCH_JPG:
+       default:
+               {
+                       switch (REG_GET_SLICE
+                               (mrv_reg->vi_dpcl, MRV_VI_CHAN_MODE)) {
+                       case MRV_VI_CHAN_MODE_MP:
+                               return MRV_MI_MP_FRAME_END_MASK;
+                       case MRV_VI_CHAN_MODE_SP:
+                               return MRV_MI_SP_FRAME_END_MASK;
+                       case MRV_VI_CHAN_MODE_MP_SP:
+                               return MRV_MI_MP_FRAME_END_MASK |
+                                   MRV_MI_SP_FRAME_END_MASK;
+                       default:
+                               return 0;
+                       }
+               }
+       }
+
+}
+
+/*
+ * Programs the number of frames to capture. Clears frame end
+ * interrupt to allow waiting in ci_isp_wait_for_frame_end().
+ * Enables the ISP input acquisition and output formatter.
+ * If immediate=false, the hardware assures that enabling is
+ * done frame synchronously.
+ */
+void ci_isp_start(u16 number_of_frames,
+                 enum ci_isp_conf_update_time update_time)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 isp_ctrl = REG_READ(mrv_reg->isp_ctrl);
+       u32 eof_irq_mask = ci_isp_get_frame_end_irq_mask_isp();
+
+       /* max. 10 bits allowed */
+       WARN_ON(!(number_of_frames <= MRV_ISP_ACQ_NR_FRAMES_MAX));
+       REG_SET_SLICE(mrv_reg->isp_acq_nr_frames, MRV_ISP_ACQ_NR_FRAMES,
+                     number_of_frames);
+
+       /* clear frame end interrupt */
+       REG_WRITE(mrv_reg->mi_icr, eof_irq_mask);
+
+       /*
+        * Input Acquisition is always enabled synchronous to the image sensor
+        * (no configuration update required). As soon as the input
+        * acquisition is started bit in_enable_shd in the register
+        * isp_flags_shd is set by hardware. In the following a frame end
+        * recognized by the input acquisition unit leads to
+        * ris_in_frame_end=1 in isp_ris. However a recognized frame end and
+        * no signaled errors are no guarantee for a valid configuration.
+        */
+
+       /*
+        * The output formatter is enabled frame synchronously according to
+        * the internal sync signals. Bit MRV_GEN_CFG_UPD has to be set. Bit
+        * isp_on_shd in isp_flags_shd is set when the output formatter is
+        * started. A recognized frame end is signaled with ris_out_frame_end
+        * in isp_ris.
+        */
+
+       /*
+        * The configuration of the input acquisition and the output
+        * formatter has to be correct to generate proper internal sync
+        * signals and thus a proper frame-synchronous update signal.
+        */
+
+       /* If the output formatter does not start check the following:
+        * sync polarities
+        * sample edge
+        * mode in register isp_ctrl
+        * sampling window of input acquisition <= picture size of image
+        * sensor
+        * output formatter window <= sampling window of input
+        * acquisition
+        */
+
+       /*
+        * If problems with the window sizes are suspected preferably add some
+        * offsets and reduce the window sizes, so that the above relations
+        * are true by all means.
+        */
+
+       switch (update_time) {
+       case CI_ISP_CFG_UPDATE_FRAME_SYNC:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_GEN_CFG_UPD, ENABLE);
+               break;
+       case CI_ISP_CFG_UPDATE_IMMEDIATE:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_CFG_UPD, ENABLE);
+               break;
+       case CI_ISP_CFG_UPDATE_LATER:
+               break;
+       default:
+               break;
+       }
+
+       REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_INFORM_ENABLE, ENABLE);
+       REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_ENABLE, ENABLE);
+       REG_WRITE(mrv_reg->isp_ctrl, isp_ctrl);
+
+       dprintk(3, "ISP_CTRL  = 0x%08X", mrv_reg->isp_ctrl);
+}
+
+/*
+ * Clear frame end interrupt to allow waiting in
+ * ci_isp_wait_for_frame_end(). Disable output formatter (frame
+ * synchronously).
+ */
+void ci_isp_stop(enum ci_isp_conf_update_time update_time)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 isp_ctrl = REG_READ(mrv_reg->isp_ctrl);
+       u32 eof_irq_mask = ci_isp_get_frame_end_irq_mask_isp();
+
+       /* clear frame end interrupt */
+       REG_WRITE(mrv_reg->mi_icr, eof_irq_mask);
+       REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_ENABLE, DISABLE);
+
+       switch (update_time) {
+       case CI_ISP_CFG_UPDATE_FRAME_SYNC:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_GEN_CFG_UPD, ENABLE);
+               break;
+       case CI_ISP_CFG_UPDATE_IMMEDIATE:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_CFG_UPD, ENABLE);
+               break;
+       case CI_ISP_CFG_UPDATE_LATER:
+               break;
+       default:
+               break;
+       }
+
+       REG_WRITE(mrv_reg->isp_ctrl, isp_ctrl);
+}
+
+/*
+ * Changes the data path settings.
+ */
+int ci_isp_set_data_path(enum ci_isp_ycs_chn_mode ycs_chn_mode,
+                        enum ci_isp_dp_switch dp_switch)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 vi_dpcl = REG_READ(mrv_reg->vi_dpcl);
+       u32 vi_chan_mode;
+       u32 vi_mp_mux;
+
+       /* get desired setting for ycs_chan_mode (or vi_chan_mode) bits */
+       switch (ycs_chn_mode) {
+       case CI_ISP_YCS_OFF:
+               vi_chan_mode = MRV_VI_CHAN_MODE_OFF;
+               break;
+       case CI_ISP_YCS_Y:
+               vi_chan_mode = MRV_VI_CHAN_MODE_Y;
+               break;
+       case CI_ISP_YCS_MVRAW:
+               vi_chan_mode = MRV_VI_CHAN_MODE_MP_RAW;
+               break;
+       case CI_ISP_YCS_MV:
+               vi_chan_mode = MRV_VI_CHAN_MODE_MP;
+               break;
+       case CI_ISP_YCS_SP:
+               vi_chan_mode = MRV_VI_CHAN_MODE_SP;
+               break;
+       case CI_ISP_YCS_MV_SP:
+               vi_chan_mode = MRV_VI_CHAN_MODE_MP_SP;
+               break;
+       default:
+               eprintk("unknown value for ycs_chn_mode");
+               return CI_STATUS_NOTSUPP;
+       }
+
+       if (vi_chan_mode & ~(MRV_VI_CHAN_MODE_MASK >> MRV_VI_CHAN_MODE_SHIFT)) {
+               eprintk("enum ci_isp_ycs_chn_mode not supported");
+               return CI_STATUS_NOTSUPP;
+       }
+
+       /* get desired setting for vi_dp_switch (or vi_dp_mux) bits */
+       switch (dp_switch) {
+       case CI_ISP_DP_RAW:
+               vi_mp_mux = MRV_VI_MP_MUX_RAW;
+               break;
+       case CI_ISP_DP_JPEG:
+               vi_mp_mux = MRV_VI_MP_MUX_JPEG;
+               break;
+       case CI_ISP_DP_MV:
+               vi_mp_mux = MRV_VI_MP_MUX_MP;
+               break;
+       default:
+               eprintk("unknown value for dp_switch");
+               return CI_STATUS_NOTSUPP;
+       }
+
+       if (vi_mp_mux & ~MRV_VI_MP_MUX_MASK) {
+               eprintk("dp_switch value not supported");
+               return CI_STATUS_NOTSUPP;
+       }
+
+       /* program settings into MARVIN vi_dpcl register */
+       REG_SET_SLICE(vi_dpcl, MRV_VI_CHAN_MODE, vi_chan_mode);
+       REG_SET_SLICE(vi_dpcl, MRV_VI_MP_MUX, vi_mp_mux);
+       REG_WRITE(mrv_reg->vi_dpcl, vi_dpcl);
+
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * Changes the data path settings to SMIA or MIPI.
+ */
+int ci_isp_set_mipi_smia(u32 mode)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 if_select;
+
+       /* get desired setting for if_select bits */
+       switch (mode) {
+       case SENSOR_MODE_SMIA:
+               if_select = MRV_IF_SELECT_SMIA;
+               break;
+       case SENSOR_MODE_MIPI:
+               if_select = MRV_IF_SELECT_MIPI;
+               break;
+       case SENSOR_MODE_BAYER:
+       case SENSOR_MODE_BT601:
+       case SENSOR_MODE_BT656:
+       case SENSOR_MODE_PICT:
+       case SENSOR_MODE_DATA:
+       case SENSOR_MODE_BAY_BT656:
+       case SENSOR_MODE_RAW_BT656:
+               if_select = MRV_IF_SELECT_PAR;
+               break;
+       default:
+               eprintk("unknown value for mode");
+               return CI_STATUS_NOTSUPP;
+       }
+
+       /* program settings into MARVIN vi_dpcl register */
+       REG_SET_SLICE(mrv_reg->vi_dpcl, MRV_IF_SELECT, if_select);
+
+       if (if_select == MRV_IF_SELECT_MIPI)
+               REG_WRITE(mrv_reg->mipi_ctrl, 0x1001);
+
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * Waits until the specified bits becomes signaled in the mi_ris
+ * register.
+ */
+static int ci_isp_wait_for_mi(struct mrst_isp_device *intel, u32 bit_mask)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 irq;
+       static int err_frame_cnt;
+       mrst_timer_start();
+       /*
+        * Wait for the curr BitMask. If the BitMask is zero, then it's no
+        * waiting.
+        */
+       while ((mrv_reg->mi_ris & bit_mask) != bit_mask) {
+
+               irq = REG_READ(mrv_reg->isp_ris);
+               if (irq & (MRV_ISP_RIS_DATA_LOSS_MASK
+                          | MRV_ISP_RIS_PIC_SIZE_ERR_MASK)){
+                       err_frame_cnt++;
+                       dprintk(1, "irq = 0x%x, err rumber = %d", irq,
+                               err_frame_cnt);
+               }
+               if (mrst_get_micro_sec() > 1000) {
+                       dprintk(1, "time out");
+                       mrst_timer_stop();
+                       /*
+                        * Try to recover. Softreset of submodules (but not
+                        * entire marvin) resets processing and status
+                        * information, but not configuration register
+                        * content. Bits are sticky. So we have to clear them.
+                        * Reset affects the MARVIN 1..2 clock cycles after
+                        * the bits are set to high. So we don't have to wait
+                        * in software before clearing them.
+                        */
+                       REG_SET_SLICE(mrv_reg->vi_ircl,
+                                     MRV_VI_ALL_SOFT_RST, ON);
+                       REG_SET_SLICE(mrv_reg->vi_ircl,
+                                     MRV_VI_ALL_SOFT_RST, OFF);
+                       msleep(CI_ISP_DELAY_AFTER_RESET);
+                       REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_CFG_UPD,
+                                     ON);
+                       return CI_STATUS_FAILURE;
+               }
+       }
+
+       mrst_timer_stop();
+       if (REG_GET_SLICE(mrv_reg->isp_ris, MRV_ISP_RIS_DATA_LOSS))
+               dprintk(1, "no failure, but MRV_ISPINT_DATA_LOSS");
+
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * Waits until a frame is written to memory (frame end
+ * interrupt occurs).
+ * Waits for the frame end interrupt of the memory
+ * interface.
+ */
+int ci_isp_wait_for_frame_end(struct mrst_isp_device *intel)
+{
+       return ci_isp_wait_for_mi(intel, ci_isp_get_frame_end_irq_mask_isp());
+}
+
+void ci_isp_reset_interrupt_status(void)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       /* ISP interrupt clear register */
+       REG_SET_SLICE(mrv_reg->isp_icr, MRV_ISP_ICR_ALL, ON);
+       REG_SET_SLICE(mrv_reg->isp_err_clr, MRV_ISP_ALL_ERR, ON);
+       REG_SET_SLICE(mrv_reg->mi_icr, MRV_MI_ALLIRQS, ON);
+       /* JPEG error interrupt clear register */
+       REG_SET_SLICE(mrv_reg->jpe_error_icr, MRV_JPE_ALL_ERR, ON);
+       /* JPEG status interrupt clear register */
+       REG_SET_SLICE(mrv_reg->jpe_status_icr, MRV_JPE_ALL_STAT, ON);
+
+       REG_WRITE(mrv_reg->mipi_icr, 0xffffffff);
+}
+
+void mrst_isp_disable_interrupt(struct mrst_isp_device *isp)
+{
+       struct isp_register *mrv_reg = (struct isp_register *)MEM_MRV_REG_BASE;
+       REG_SET_SLICE(mrv_reg->isp_imsc, MRV_ISP_IMSC_ALL, OFF);
+       REG_SET_SLICE(mrv_reg->mi_imsc, MRV_MI_ALLIRQS, OFF);
+       REG_SET_SLICE(mrv_reg->jpe_error_imr, MRV_JPE_ALL_ERR, OFF);
+       REG_SET_SLICE(mrv_reg->jpe_status_imr, MRV_JPE_ALL_STAT, OFF);
+       REG_WRITE(mrv_reg->mipi_imsc, 0x00000000);
+}
+
+void mrst_isp_enable_interrupt(struct mrst_isp_device *isp)
+{
+       struct isp_register *mrv_reg = (struct isp_register *)MEM_MRV_REG_BASE;
+
+       REG_SET_SLICE(mrv_reg->isp_imsc, MRV_ISP_IMSC_DATA_LOSS, ON);
+       REG_SET_SLICE(mrv_reg->isp_imsc, MRV_ISP_IMSC_PIC_SIZE_ERR, ON);
+       REG_WRITE(mrv_reg->mi_imsc, MRV_MI_MP_FRAME_END_MASK);
+       REG_SET_SLICE(mrv_reg->mi_imsc, MRV_MI_MBLK_LINE, ON);
+       REG_SET_SLICE(mrv_reg->jpe_error_imr, MRV_JPE_ALL_ERR, ON);
+       REG_SET_SLICE(mrv_reg->jpe_status_imr, MRV_JPE_ALL_STAT, ON);
+       REG_WRITE(mrv_reg->mipi_imsc, 0x00f00000);
+
+       ci_isp_reset_interrupt_status();
+}
+
+/*
+ * Set extended mode with unrestricted values for YCbCr
+ * Y (0-255) CbCr (0-255)
+ */
+void ci_isp_set_ext_ycmode(void)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 isp_ctrl = REG_READ(mrv_reg->isp_ctrl);
+
+       /* modify isp_ctrl register */
+       REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_CSM_C_RANGE,
+                     MRV_ISP_ISP_CSM_C_RANGE_FULL);
+       REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_CSM_Y_RANGE,
+                     MRV_ISP_ISP_CSM_Y_RANGE_FULL);
+       REG_WRITE(mrv_reg->isp_ctrl, isp_ctrl);
+
+       /* program RGB to YUV color conversion with extended range */
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_0, MRV_ISP_CC_COEFF_0, 0x0026);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_1, MRV_ISP_CC_COEFF_1, 0x004B);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_2, MRV_ISP_CC_COEFF_2, 0x000F);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_3, MRV_ISP_CC_COEFF_3, 0x01EA);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_4, MRV_ISP_CC_COEFF_4, 0x01D6);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_5, MRV_ISP_CC_COEFF_5, 0x0040);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_6, MRV_ISP_CC_COEFF_6, 0x0040);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_7, MRV_ISP_CC_COEFF_7, 0x01CA);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_8, MRV_ISP_CC_COEFF_8, 0x01F6);
+}
+
+void ci_isp_set_yc_mode(void)
+{
+       struct isp_register *mrv_reg = (struct isp_register *)MEM_MRV_REG_BASE;
+       u32 isp_ctrl = REG_READ(mrv_reg->isp_ctrl);
+
+       /* modify isp_ctrl register */
+       REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_CSM_C_RANGE,
+               MRV_ISP_ISP_CSM_Y_RANGE_BT601);
+       REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_CSM_Y_RANGE,
+               MRV_ISP_ISP_CSM_Y_RANGE_BT601);
+       REG_WRITE(mrv_reg->isp_ctrl, isp_ctrl);
+
+       /* program RGB to YUV color conversion with extended range */
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_0, MRV_ISP_CC_COEFF_0, 0x0021);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_1, MRV_ISP_CC_COEFF_1, 0x0040);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_2, MRV_ISP_CC_COEFF_2, 0x000D);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_3, MRV_ISP_CC_COEFF_3, 0x01ED);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_4, MRV_ISP_CC_COEFF_4, 0x01DB);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_5, MRV_ISP_CC_COEFF_5, 0x0038);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_6, MRV_ISP_CC_COEFF_6, 0x0038);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_7, MRV_ISP_CC_COEFF_7, 0x01D1);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_8, MRV_ISP_CC_COEFF_8, 0x01F7);
+}
+
+/*
+ * writes the color values for contrast, brightness,
+ * saturation and hue into the appropriate Marvin
+ * registers
+ */
+void ci_isp_col_set_color_processing(
+       const struct ci_isp_color_settings *col)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+
+       if (col == NULL)
+               mrv_reg->c_proc_ctrl = 0;
+       else {
+               mrv_reg->c_proc_contrast = col->contrast;
+               mrv_reg->c_proc_brightness = col->brightness;
+               mrv_reg->c_proc_saturation = col->saturation;
+               mrv_reg->c_proc_hue = col->hue;
+
+               if (col->flags & CI_ISP_CPROC_C_OUT_RANGE) {
+                       mrv_reg->c_proc_ctrl =
+                           mrv_reg->c_proc_ctrl | CI_ISP_CPROC_C_OUT_RANGE;
+               }
+
+               if (col->flags & CI_ISP_CPROC_Y_IN_RANGE) {
+                       mrv_reg->c_proc_ctrl =
+                           mrv_reg->c_proc_ctrl | CI_ISP_CPROC_Y_IN_RANGE;
+               }
+
+               if (col->flags & CI_ISP_CPROC_Y_OUT_RANGE) {
+                       mrv_reg->c_proc_ctrl =
+                           mrv_reg->c_proc_ctrl | CI_ISP_CPROC_Y_OUT_RANGE;
+               }
+
+               if (col->flags & CI_ISP_CPROC_ENABLE) {
+                       mrv_reg->c_proc_ctrl =
+                           mrv_reg->c_proc_ctrl | CI_ISP_CPROC_ENABLE;
+               }
+       }
+}
+
+/*
+ * Translates a chrominance component value from usual
+ * representation (range 16..240, 128=neutral grey)
+ * to the one used by the ie_tint register
+ * The value is returned as 32 bit unsigned to support shift
+ * operation without explicit cast.
+ * The translation formular implemented here is taken from
+ * the image effects functional specification document,
+ * Doc-ID 30-001-481.130, revision 1.1 from november, 21st. 2005
+ */
+static u32 ci_isp_ie_tint_cx2_reg_val(u8 cx)
+{
+       s32 temp;
+       u32 reg_val;
+
+       temp = 128 - (s32) cx;
+       temp = ((temp * 64) / 110);
+
+       /* convert from two's complement to sign/value */
+       if (temp < 0) {
+               reg_val = 0x80;
+               temp *= (-1);
+       } else
+               reg_val = 0;
+
+       /* saturate at 7 bits */
+       if (temp > 0x7F)
+               temp = 0x7F;
+
+       /* combine sign and value to build the regiter value */
+       reg_val |= (u32) temp;
+
+       return reg_val;
+}
+
+/*
+ * Translates usual (decimal) matrix coefficient into the
+ * 4 bit  register representation (used in the ie_mat_X registers).
+ * for unsupported decimal numbers, a supported replacement is
+ * selected automatically.
+ * The value is returned as 32 bit unsigned to support shift
+ * operation without explicit cast.
+ * The translation formular implemented here is taken from
+ * the image effects functional specification document,
+ * Doc-ID 30-001-481.130, revision 1.1 from november, 21st. 2005
+ */
+static u32 ci_isp_ie_mx_dec2_reg_val(s8 dec)
+{
+       u32 val;
+       switch (dec) {
+       case -2:
+               val = 0x0d;
+               break;
+       case -1:
+               val = 0x0c;
+               break;
+       case 0:
+               val = 0x00;
+               break;
+       case 1:
+               val = 0x08;
+               break;
+       case 2:
+               val = 0x09;
+               break;
+       default:
+               if (dec <= (-6))
+                       val = 0x0f;
+               else if (dec <= (-3))
+                       val = 0x0e;
+               else if (dec < 6)
+                       val = 0x0a;
+               else
+                       val = 0x0b;
+               break;
+       }
+
+       return val;
+}
+
+/*
+ * translates the values of the given configuration
+ * structure into register settings for the image effects
+ * submodule and loads the registers.
+ */
+int ci_isp_ie_set_config(const struct ci_isp_ie_config *ie_config)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       if (!ie_config) {
+               REG_SET_SLICE(mrv_reg->img_eff_ctrl, MRV_IMGEFF_BYPASS_MODE,
+                             MRV_IMGEFF_BYPASS_MODE_BYPASS);
+       } else {
+               /* apply the given settings */
+               u32 ul_ie_ctrl = REG_READ(mrv_reg->img_eff_ctrl);
+               u32 ul_ie_csel = REG_READ(mrv_reg->img_eff_color_sel);
+               u32 ul_ie_tint = REG_READ(mrv_reg->img_eff_tint);
+               u32 ul_ie_mat1 = REG_READ(mrv_reg->img_eff_mat_1);
+               u32 ul_ie_mat2 = REG_READ(mrv_reg->img_eff_mat_2);
+               u32 ul_ie_mat3 = REG_READ(mrv_reg->img_eff_mat_3);
+               u32 ul_ie_mat4 = REG_READ(mrv_reg->img_eff_mat_4);
+               u32 ul_ie_mat5 = REG_READ(mrv_reg->img_eff_mat_5);
+
+               /* overall operation mode */
+               switch (ie_config->mode) {
+               case CI_ISP_IE_MODE_OFF:
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_BYPASS_MODE,
+                                     MRV_IMGEFF_BYPASS_MODE_BYPASS);
+                       break;
+               case CI_ISP_IE_MODE_GRAYSCALE:
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_EFFECT_MODE,
+                                     MRV_IMGEFF_EFFECT_MODE_GRAY);
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_BYPASS_MODE,
+                                     MRV_IMGEFF_BYPASS_MODE_PROCESS);
+                       break;
+               case CI_ISP_IE_MODE_NEGATIVE:
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_EFFECT_MODE,
+                                     MRV_IMGEFF_EFFECT_MODE_NEGATIVE);
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_BYPASS_MODE,
+                                     MRV_IMGEFF_BYPASS_MODE_PROCESS);
+                       break;
+               case CI_ISP_IE_MODE_SEPIA:
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_EFFECT_MODE,
+                                     MRV_IMGEFF_EFFECT_MODE_SEPIA);
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_BYPASS_MODE,
+                                     MRV_IMGEFF_BYPASS_MODE_PROCESS);
+                       break;
+               case CI_ISP_IE_MODE_COLOR_SEL:
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_EFFECT_MODE,
+                                     MRV_IMGEFF_EFFECT_MODE_COLOR_SEL);
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_BYPASS_MODE,
+                                     MRV_IMGEFF_BYPASS_MODE_PROCESS);
+                       break;
+               case CI_ISP_IE_MODE_EMBOSS:
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_EFFECT_MODE,
+                                     MRV_IMGEFF_EFFECT_MODE_EMBOSS);
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_BYPASS_MODE,
+                                     MRV_IMGEFF_BYPASS_MODE_PROCESS);
+                       break;
+               case CI_ISP_IE_MODE_SKETCH:
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_EFFECT_MODE,
+                                     MRV_IMGEFF_EFFECT_MODE_SKETCH);
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_BYPASS_MODE,
+                                     MRV_IMGEFF_BYPASS_MODE_PROCESS);
+                       break;
+               default:
+                       return CI_STATUS_OUTOFRANGE;
+               }
+
+               /* use next frame sync update */
+               REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_CFG_UPD, ON);
+
+               /* color selection settings */
+               REG_SET_SLICE(ul_ie_csel, MRV_IMGEFF_COLOR_THRESHOLD,
+                             (u32) (ie_config->color_thres));
+               REG_SET_SLICE(ul_ie_csel, MRV_IMGEFF_COLOR_SELECTION,
+                             (u32) (ie_config->color_sel));
+
+               /* tint color settings */
+               REG_SET_SLICE(ul_ie_tint, MRV_IMGEFF_INCR_CB,
+                             ci_isp_ie_tint_cx2_reg_val(ie_config->tint_cb));
+               REG_SET_SLICE(ul_ie_tint, MRV_IMGEFF_INCR_CR,
+                             ci_isp_ie_tint_cx2_reg_val(ie_config->tint_cr));
+
+               /* matrix coefficients */
+               REG_SET_SLICE(ul_ie_mat1, MRV_IMGEFF_EMB_COEF_11_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
+                   coeff_11));
+               REG_SET_SLICE(ul_ie_mat1, MRV_IMGEFF_EMB_COEF_12_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
+                   coeff_12));
+               REG_SET_SLICE(ul_ie_mat1, MRV_IMGEFF_EMB_COEF_13_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
+                   coeff_13));
+               REG_SET_SLICE(ul_ie_mat1, MRV_IMGEFF_EMB_COEF_21_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
+                   coeff_21));
+               REG_SET_SLICE(ul_ie_mat2, MRV_IMGEFF_EMB_COEF_22_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
+                   coeff_22));
+               REG_SET_SLICE(ul_ie_mat2, MRV_IMGEFF_EMB_COEF_23_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
+                   coeff_23));
+               REG_SET_SLICE(ul_ie_mat2, MRV_IMGEFF_EMB_COEF_31_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
+                   coeff_31));
+               REG_SET_SLICE(ul_ie_mat2, MRV_IMGEFF_EMB_COEF_32_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
+                   coeff_32));
+               REG_SET_SLICE(ul_ie_mat3, MRV_IMGEFF_EMB_COEF_33_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
+                   coeff_33));
+               REG_SET_SLICE(ul_ie_mat3, MRV_IMGEFF_SKET_COEF_11_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
+                   coeff_11));
+               REG_SET_SLICE(ul_ie_mat3, MRV_IMGEFF_SKET_COEF_12_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
+                   coeff_12));
+               REG_SET_SLICE(ul_ie_mat3, MRV_IMGEFF_SKET_COEF_13_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
+                   coeff_13));
+               REG_SET_SLICE(ul_ie_mat4, MRV_IMGEFF_SKET_COEF_21_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
+                   coeff_21));
+               REG_SET_SLICE(ul_ie_mat4, MRV_IMGEFF_SKET_COEF_22_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
+                   coeff_22));
+               REG_SET_SLICE(ul_ie_mat4, MRV_IMGEFF_SKET_COEF_23_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
+                   coeff_23));
+               REG_SET_SLICE(ul_ie_mat4, MRV_IMGEFF_SKET_COEF_31_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
+                   coeff_31));
+               REG_SET_SLICE(ul_ie_mat5, MRV_IMGEFF_SKET_COEF_32_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
+                   coeff_32));
+               REG_SET_SLICE(ul_ie_mat5, MRV_IMGEFF_SKET_COEF_33_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
+                   coeff_33));
+
+               /* write changed values back to registers */
+               REG_WRITE(mrv_reg->img_eff_ctrl, ul_ie_ctrl);
+               REG_WRITE(mrv_reg->img_eff_color_sel, ul_ie_csel);
+               REG_WRITE(mrv_reg->img_eff_tint, ul_ie_tint);
+               REG_WRITE(mrv_reg->img_eff_mat_1, ul_ie_mat1);
+               REG_WRITE(mrv_reg->img_eff_mat_2, ul_ie_mat2);
+               REG_WRITE(mrv_reg->img_eff_mat_3, ul_ie_mat3);
+               REG_WRITE(mrv_reg->img_eff_mat_4, ul_ie_mat4);
+               REG_WRITE(mrv_reg->img_eff_mat_5, ul_ie_mat5);
+
+               /* frame synchronous update of shadow registers */
+               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_GEN_CFG_UPD, ON);
+       }
+
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * Applies the new image stabilisation settings to the module.
+ */
+int ci_isp_is_set_config(const struct ci_isp_is_config *is_config)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       if (!is_config) {
+               eprintk("is_config NULL");
+               return CI_STATUS_NULL_POINTER;
+       }
+
+       /* set maximal margin distance for X */
+       if (is_config->max_dx > MRV_IS_IS_MAX_DX_MAX) {
+               REG_SET_SLICE(mrv_reg->isp_is_max_dx, MRV_IS_IS_MAX_DX,
+                             (u32) (MRV_IS_IS_MAX_DX_MAX));
+       } else {
+               REG_SET_SLICE(mrv_reg->isp_is_max_dx, MRV_IS_IS_MAX_DX,
+                             (u32) (is_config->max_dx));
+       }
+
+       /* set maximal margin distance for Y */
+       if (is_config->max_dy > MRV_IS_IS_MAX_DY_MAX) {
+               REG_SET_SLICE(mrv_reg->isp_is_max_dy, MRV_IS_IS_MAX_DY,
+                             (u32) (MRV_IS_IS_MAX_DY_MAX));
+       } else {
+               REG_SET_SLICE(mrv_reg->isp_is_max_dy, MRV_IS_IS_MAX_DY,
+                             (u32) (is_config->max_dy));
+       }
+
+       REG_SET_SLICE(mrv_reg->isp_is_h_offs, MRV_IS_IS_H_OFFS,
+                     (u32) (is_config->mrv_is_window.hoffs));
+       REG_SET_SLICE(mrv_reg->isp_is_v_offs, MRV_IS_IS_V_OFFS,
+                     (u32) (is_config->mrv_is_window.voffs));
+       REG_SET_SLICE(mrv_reg->isp_is_h_size, MRV_IS_IS_H_SIZE,
+                     (u32) (is_config->mrv_is_window.hsize));
+       REG_SET_SLICE(mrv_reg->isp_is_v_size, MRV_IS_IS_V_SIZE,
+                     (u32) (is_config->mrv_is_window.vsize));
+
+       return CI_STATUS_SUCCESS;
+}
+
+static int ci_isp_bls_set_fixed_values(const struct ci_isp_bls_subtraction
+                                      *bls_subtraction)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       if (!bls_subtraction)
+               return CI_STATUS_NULL_POINTER;
+
+       if ((bls_subtraction->fixed_a > MRV_ISP_BLS_FIX_SUB_MAX) ||
+           (bls_subtraction->fixed_b > MRV_ISP_BLS_FIX_SUB_MAX) ||
+           (bls_subtraction->fixed_c > MRV_ISP_BLS_FIX_SUB_MAX) ||
+           (bls_subtraction->fixed_d > MRV_ISP_BLS_FIX_SUB_MAX) ||
+           (bls_subtraction->fixed_a < (s16) MRV_ISP_BLS_FIX_SUB_MIN) ||
+           (bls_subtraction->fixed_b < (s16) MRV_ISP_BLS_FIX_SUB_MIN) ||
+           (bls_subtraction->fixed_c < (s16) MRV_ISP_BLS_FIX_SUB_MIN) ||
+           (bls_subtraction->fixed_d < (s16) MRV_ISP_BLS_FIX_SUB_MIN)) {
+               return CI_STATUS_OUTOFRANGE;
+       } else {
+               REG_SET_SLICE(mrv_reg->isp_bls_a_fixed, MRV_BLS_BLS_A_FIXED,
+                             bls_subtraction->fixed_a);
+               REG_SET_SLICE(mrv_reg->isp_bls_b_fixed, MRV_BLS_BLS_B_FIXED, \
+                             bls_subtraction->fixed_b);
+               REG_SET_SLICE(mrv_reg->isp_bls_c_fixed, MRV_BLS_BLS_C_FIXED,
+                             bls_subtraction->fixed_c);
+               REG_SET_SLICE(mrv_reg->isp_bls_d_fixed, MRV_BLS_BLS_D_FIXED,
+                             bls_subtraction->fixed_d);
+       }
+
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * Sets the desired configuration values to the BLS registers,
+ * if possible. In the case the parameter (bls_config == NULL)
+ * the BLS module will be deactivated.
+ */
+int ci_isp_bls_set_config(const struct ci_isp_bls_config *bls_config)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 isp_bls_ctrl = 0;
+
+       int error = CI_STATUS_FAILURE;
+
+       if (!bls_config) {
+               REG_SET_SLICE(mrv_reg->isp_bls_ctrl,
+                       MRV_BLS_BLS_ENABLE, DISABLE);
+               return CI_STATUS_SUCCESS;
+       }
+
+       /* measurement window 2, enable_window =0 */
+       if (bls_config->isp_bls_window2.enable_window) {
+               if ((bls_config->isp_bls_window2.start_h >
+                    MRV_BLS_BLS_H2_START_MAX)
+                   || (bls_config->isp_bls_window2.stop_h >
+                       MRV_BLS_BLS_H2_STOP_MAX)
+                   || (bls_config->isp_bls_window2.start_v >
+                       MRV_BLS_BLS_V2_START_MAX)
+                   || (bls_config->isp_bls_window2.stop_v >
+                       MRV_BLS_BLS_V2_STOP_MAX)) {
+                       return CI_STATUS_OUTOFRANGE;
+               } else {
+                       REG_SET_SLICE(mrv_reg->isp_bls_h2_start,
+                                     MRV_BLS_BLS_H2_START,
+                                     bls_config->isp_bls_window2.start_h);
+                       REG_SET_SLICE(mrv_reg->isp_bls_h2_stop,
+                                     MRV_BLS_BLS_H2_STOP,
+                                     bls_config->isp_bls_window2.stop_h);
+                       REG_SET_SLICE(mrv_reg->isp_bls_v2_start,
+                                     MRV_BLS_BLS_V2_START,
+                                     bls_config->isp_bls_window2.start_v);
+                       REG_SET_SLICE(mrv_reg->isp_bls_v2_stop,
+                                     MRV_BLS_BLS_V2_STOP,
+                                     bls_config->isp_bls_window2.stop_v);
+               }
+       }
+
+       /* measurement window 1, enable_window=0 */
+       if (bls_config->isp_bls_window1.enable_window) {
+               if ((bls_config->isp_bls_window1.start_h >
+                    MRV_BLS_BLS_H1_START_MAX)
+                   || (bls_config->isp_bls_window1.stop_h >
+                       MRV_BLS_BLS_H1_STOP_MAX)
+                   || (bls_config->isp_bls_window1.start_v >
+                       MRV_BLS_BLS_V1_START_MAX)
+                   || (bls_config->isp_bls_window1.stop_v >
+                       MRV_BLS_BLS_V1_STOP_MAX)) {
+                       return CI_STATUS_OUTOFRANGE;
+               } else {
+                       REG_SET_SLICE(mrv_reg->isp_bls_h1_start,
+                                     MRV_BLS_BLS_H1_START,
+                                     bls_config->isp_bls_window1.start_h);
+                       REG_SET_SLICE(mrv_reg->isp_bls_h1_stop,
+                                     MRV_BLS_BLS_H1_STOP,
+                                     bls_config->isp_bls_window1.stop_h);
+                       REG_SET_SLICE(mrv_reg->isp_bls_v1_start,
+                                     MRV_BLS_BLS_V1_START,
+                                     bls_config->isp_bls_window1.start_v);
+                       REG_SET_SLICE(mrv_reg->isp_bls_v1_stop,
+                                     MRV_BLS_BLS_V1_STOP,
+                                     bls_config->isp_bls_window1.stop_v);
+               }
+       }
+
+       if (bls_config->bls_samples > MRV_BLS_BLS_SAMPLES_MAX) {
+               return CI_STATUS_OUTOFRANGE;
+       } else {
+               REG_SET_SLICE(mrv_reg->isp_bls_samples, MRV_BLS_BLS_SAMPLES,
+                             bls_config->bls_samples);
+       }
+
+       /* fixed subtraction values, enable_automatic=0 */
+       if (!bls_config->enable_automatic) {
+               error = ci_isp_bls_set_fixed_values(
+                   &(bls_config->bls_subtraction));
+               if (error != CI_STATUS_SUCCESS)
+                       return error;
+       }
+
+       if ((bls_config->disable_h) || (bls_config->disable_v))
+               return CI_STATUS_OUTOFRANGE;
+
+       isp_bls_ctrl = REG_READ(mrv_reg->isp_bls_ctrl);
+
+       /* enable measurement window(s) */
+       REG_SET_SLICE(isp_bls_ctrl, MRV_BLS_WINDOW_ENABLE,
+                     ((bls_config->isp_bls_window1.enable_window)
+                     ? MRV_BLS_WINDOW_ENABLE_WND1 : 0) |
+                     ((bls_config->isp_bls_window2.enable_window)
+                     ? MRV_BLS_WINDOW_ENABLE_WND2 : 0));
+
+       REG_SET_SLICE(isp_bls_ctrl, MRV_BLS_BLS_MODE,
+                     (bls_config->enable_automatic) ? MRV_BLS_BLS_MODE_MEAS :
+                     MRV_BLS_BLS_MODE_FIX);
+
+       /* enable module */
+       REG_SET_SLICE(isp_bls_ctrl, MRV_BLS_BLS_ENABLE, ENABLE);
+
+       /* write into register */
+       REG_WRITE(mrv_reg->isp_bls_ctrl, isp_bls_ctrl);
+
+       return CI_STATUS_SUCCESS;
+}
+
+#define RSZ_FLAGS_MASK (RSZ_UPSCALE_ENABLE | RSZ_SCALER_BYPASS)
+
+/*
+ * writes the scaler values to the appropriate Marvin registers.
+ */
+void ci_isp_res_set_main_resize(const struct ci_isp_scale *scale,
+                               enum ci_isp_conf_update_time update_time,
+                               const struct ci_isp_rsz_lut *rsz_lut)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 mrsz_ctrl = REG_READ(mrv_reg->mrsz_ctrl);
+       u32 i;
+       int upscaling = false;
+
+       /* flags must be "outside" scaler value */
+       WARN_ON(!((RSZ_FLAGS_MASK & MRV_RSZ_SCALE_MASK) == 0));
+       WARN_ON(!((scale->scale_hy & ~RSZ_FLAGS_MASK) <= MRV_RSZ_SCALE_MAX));
+       WARN_ON(!((scale->scale_hcb & ~RSZ_FLAGS_MASK) <= MRV_RSZ_SCALE_MAX));
+       WARN_ON(!((scale->scale_hcr & ~RSZ_FLAGS_MASK) <= MRV_RSZ_SCALE_MAX));
+       WARN_ON(!((scale->scale_vy & ~RSZ_FLAGS_MASK) <= MRV_RSZ_SCALE_MAX));
+       WARN_ON(!((scale->scale_vc & ~RSZ_FLAGS_MASK) <= MRV_RSZ_SCALE_MAX));
+
+       /* horizontal luminance scale factor */
+       dprintk(1, "scale_hy = %d( %x )", scale->scale_hy, scale->scale_hy);
+
+       if (scale->scale_hy & RSZ_SCALER_BYPASS) {
+               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HY_ENABLE, DISABLE);
+       } else {
+               /* enable scaler */
+               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HY_ENABLE, ENABLE);
+               /* program scale factor and phase */
+               REG_SET_SLICE(mrv_reg->mrsz_scale_hy, MRV_MRSZ_SCALE_HY,
+                             (u32) scale->scale_hy);
+               REG_SET_SLICE(mrv_reg->mrsz_phase_hy, MRV_MRSZ_PHASE_HY,
+                             (u32) scale->phase_hy);
+
+               if (scale->scale_hy & RSZ_UPSCALE_ENABLE) {
+                       /* enable upscaling mode */
+                       dprintk(1, "enable up scale");
+                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HY_UP,
+                                     MRV_MRSZ_SCALE_HY_UP_UPSCALE);
+                       /* scaler and upscaling enabled */
+                       upscaling = true;
+               } else
+                       /* disable upscaling mode */
+                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HY_UP,
+                                     MRV_MRSZ_SCALE_HY_UP_DOWNSCALE);
+       }
+
+       /* horizontal chrominance scale factors */
+       WARN_ON(!((scale->scale_hcb & RSZ_FLAGS_MASK) == (scale->scale_hcr &
+                                                         RSZ_FLAGS_MASK)));
+       dprintk(1, "scale_hcb  = %d( %x )", scale->scale_hcb, scale->scale_hcb);
+
+       if (scale->scale_hcb & RSZ_SCALER_BYPASS) {
+               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HC_ENABLE, DISABLE);
+       } else {
+               /* enable scaler */
+               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HC_ENABLE, ENABLE);
+               /* program scale factor and phase */
+               REG_SET_SLICE(mrv_reg->mrsz_scale_hcb, MRV_MRSZ_SCALE_HCB,
+                             (u32) scale->scale_hcb);
+               REG_SET_SLICE(mrv_reg->mrsz_scale_hcr, MRV_MRSZ_SCALE_HCB,
+                             (u32) scale->scale_hcr);
+               REG_SET_SLICE(mrv_reg->mrsz_phase_hc, MRV_MRSZ_PHASE_HC,
+                             (u32) scale->phase_hc);
+
+               if (scale->scale_hcb & RSZ_UPSCALE_ENABLE) {
+                       /* enable upscaling mode */
+                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HC_UP,
+                                     MRV_MRSZ_SCALE_HC_UP_UPSCALE);
+                       /* scaler and upscaling enabled */
+                       upscaling = true;
+               } else {
+                       /* disable upscaling mode */
+                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HC_UP,
+                                     MRV_MRSZ_SCALE_HC_UP_DOWNSCALE);
+               }
+       }
+
+       /* vertical luminance scale factor */
+       dprintk(1, "scale_vy = %d ( %x )", scale->scale_vy, scale->scale_vy);
+
+       if (scale->scale_vy & RSZ_SCALER_BYPASS) {
+               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VY_ENABLE,
+                             DISABLE);
+       } else {
+               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VY_ENABLE, ENABLE);
+               REG_SET_SLICE(mrv_reg->mrsz_scale_vy, MRV_MRSZ_SCALE_VY,
+                   (u32) scale->scale_vy);
+               REG_SET_SLICE(mrv_reg->mrsz_phase_vy, MRV_MRSZ_PHASE_VY,
+                   (u32) scale->phase_vy);
+
+               if (scale->scale_vy & RSZ_UPSCALE_ENABLE) {
+                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VY_UP,
+                                     MRV_MRSZ_SCALE_VY_UP_UPSCALE);
+                       upscaling = true;
+               } else {
+                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VY_UP,
+                                     MRV_MRSZ_SCALE_VY_UP_DOWNSCALE);
+               }
+       }
+
+       /* vertical chrominance scale factor */
+       dprintk(1, "scale_vc = %d( %x )", scale->scale_vc, scale->scale_vc);
+
+       if (scale->scale_vc & RSZ_SCALER_BYPASS) {
+               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VC_ENABLE,
+                             DISABLE);
+       } else {
+               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VC_ENABLE, ENABLE);
+               REG_SET_SLICE(mrv_reg->mrsz_scale_vc, MRV_MRSZ_SCALE_VC,
+                             (u32) scale->scale_vc);
+               REG_SET_SLICE(mrv_reg->mrsz_phase_vc, MRV_MRSZ_PHASE_VC,
+                             (u32) scale->phase_vc);
+
+               if (scale->scale_vc & RSZ_UPSCALE_ENABLE) {
+                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VC_UP,
+                                     MRV_MRSZ_SCALE_VC_UP_UPSCALE);
+                       upscaling = true;
+               } else {
+                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VC_UP,
+                                     MRV_MRSZ_SCALE_VC_UP_DOWNSCALE);
+               }
+       }
+
+       /* apply upscaling lookup table */
+       if (rsz_lut) {
+               for (i = 0; i <= MRV_MRSZ_SCALE_LUT_ADDR_MASK; i++) {
+                       REG_SET_SLICE(mrv_reg->mrsz_scale_lut_addr,
+                                     MRV_MRSZ_SCALE_LUT_ADDR, i);
+                       REG_SET_SLICE(mrv_reg->mrsz_scale_lut,
+                                     MRV_MRSZ_SCALE_LUT,
+                                     rsz_lut->rsz_lut[i]);
+               }
+       } else if (upscaling) {
+               eprintk("Upscaling requires lookup table!");
+               WARN_ON(1);
+       }
+
+       /* handle immediate update flag and write mrsz_ctrl */
+       switch (update_time) {
+       case CI_ISP_CFG_UPDATE_FRAME_SYNC:
+               /* frame synchronous update of shadow registers */
+               REG_WRITE(mrv_reg->mrsz_ctrl, mrsz_ctrl);
+               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_GEN_CFG_UPD, ON);
+               break;
+       case CI_ISP_CFG_UPDATE_IMMEDIATE:
+               /* immediate update of shadow registers */
+               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_CFG_UPD, ON);
+               REG_WRITE(mrv_reg->mrsz_ctrl, mrsz_ctrl);
+               break;
+       case CI_ISP_CFG_UPDATE_LATER:
+       default:
+               /* no update from within this function */
+               REG_WRITE(mrv_reg->mrsz_ctrl, mrsz_ctrl);
+               break;
+       }
+}
+
+/*
+ * writes the scaler values to the appropriate Marvin registers.
+ */
+void ci_isp_res_set_self_resize(const struct ci_isp_scale *scale,
+                               enum ci_isp_conf_update_time update_time,
+                               const struct ci_isp_rsz_lut *rsz_lut)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 srsz_ctrl = REG_READ(mrv_reg->srsz_ctrl);
+       u32 i;
+       int upscaling = false;
+
+       /* flags must be "outside" scaler value */
+       WARN_ON(!((RSZ_FLAGS_MASK & MRV_RSZ_SCALE_MASK) == 0));
+       WARN_ON(!((scale->scale_hy & ~RSZ_FLAGS_MASK) <= MRV_RSZ_SCALE_MAX));
+       WARN_ON(!((scale->scale_hcb & ~RSZ_FLAGS_MASK) <= MRV_RSZ_SCALE_MAX));
+       WARN_ON(!((scale->scale_hcr & ~RSZ_FLAGS_MASK) <= MRV_RSZ_SCALE_MAX));
+       WARN_ON(!((scale->scale_vy & ~RSZ_FLAGS_MASK) <= MRV_RSZ_SCALE_MAX));
+       WARN_ON(!((scale->scale_vc & ~RSZ_FLAGS_MASK) <= MRV_RSZ_SCALE_MAX));
+
+       /* horizontal luminance scale factor */
+       dprintk(1, "scale_hy = %d,%x", scale->scale_hy, scale->scale_hy);
+
+       if (scale->scale_hy & RSZ_SCALER_BYPASS) {
+               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HY_ENABLE,
+                             DISABLE);
+       } else {
+               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HY_ENABLE, ENABLE);
+               REG_SET_SLICE(mrv_reg->srsz_scale_hy, MRV_SRSZ_SCALE_HY,
+                             (u32) scale->scale_hy);
+               REG_SET_SLICE(mrv_reg->srsz_phase_hy, MRV_SRSZ_PHASE_HY,
+                             (u32) scale->phase_hy);
+
+               if (scale->scale_hy & RSZ_UPSCALE_ENABLE) {
+                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HY_UP,
+                                     MRV_SRSZ_SCALE_HY_UP_UPSCALE);
+                       upscaling = true;
+               } else {
+                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HY_UP,
+                                     MRV_SRSZ_SCALE_HY_UP_DOWNSCALE);
+               }
+       }
+
+       /* horizontal chrominance scale factors */
+       WARN_ON(!((scale->scale_hcb & RSZ_FLAGS_MASK) == (scale->scale_hcr &
+                                                         RSZ_FLAGS_MASK)));
+
+       dprintk(1, "scale_hcb  = %d,%x", scale->scale_hcb, scale->scale_hcb);
+
+       if (scale->scale_hcb & RSZ_SCALER_BYPASS) {
+               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HC_ENABLE,
+                             DISABLE);
+       } else {
+               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HC_ENABLE, ENABLE);
+               REG_SET_SLICE(mrv_reg->srsz_scale_hcb, MRV_SRSZ_SCALE_HCB,
+                             (u32) scale->scale_hcb);
+               REG_SET_SLICE(mrv_reg->srsz_scale_hcr, MRV_SRSZ_SCALE_HCB,
+                             (u32) scale->scale_hcr);
+
+               REG_SET_SLICE(mrv_reg->srsz_phase_hc, MRV_SRSZ_PHASE_HC,
+                   (u32) scale->phase_hc);
+
+               if (scale->scale_hcb & RSZ_UPSCALE_ENABLE) {
+                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HC_UP,
+                                     MRV_SRSZ_SCALE_HC_UP_UPSCALE);
+                       upscaling = true;
+               } else {
+                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HC_UP,
+                                     MRV_SRSZ_SCALE_HC_UP_DOWNSCALE);
+               }
+       }
+
+       /* vertical luminance scale factor */
+       dprintk(1, "scale_vy = %d,%x", scale->scale_vy, scale->scale_vy);
+
+       if (scale->scale_vy & RSZ_SCALER_BYPASS) {
+               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VY_ENABLE,
+                             DISABLE);
+       } else {
+               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VY_ENABLE, ENABLE);
+               REG_SET_SLICE(mrv_reg->srsz_scale_vy, MRV_SRSZ_SCALE_VY,
+                             (u32) scale->scale_vy);
+               REG_SET_SLICE(mrv_reg->srsz_phase_vy, MRV_SRSZ_PHASE_VY,
+                             (u32) scale->phase_vy);
+
+               if (scale->scale_vy & RSZ_UPSCALE_ENABLE) {
+                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VY_UP,
+                                     MRV_SRSZ_SCALE_VY_UP_UPSCALE);
+                       upscaling = true;
+               } else {
+                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VY_UP,
+                                     MRV_SRSZ_SCALE_VY_UP_DOWNSCALE);
+               }
+       }
+
+       /* vertical chrominance scale factor */
+       dprintk(1, "scale_vc = %d,%x", scale->scale_vc, scale->scale_vc);
+
+       if (scale->scale_vc & RSZ_SCALER_BYPASS) {
+               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VC_ENABLE,
+                             DISABLE);
+       } else {
+               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VC_ENABLE, ENABLE);
+               REG_SET_SLICE(mrv_reg->srsz_scale_vc, MRV_SRSZ_SCALE_VC,
+                             (u32) scale->scale_vc);
+               REG_SET_SLICE(mrv_reg->srsz_phase_vc, MRV_SRSZ_PHASE_VC,
+                             (u32) scale->phase_vc);
+
+               if (scale->scale_vc & RSZ_UPSCALE_ENABLE) {
+                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VC_UP,
+                                     MRV_SRSZ_SCALE_VC_UP_UPSCALE);
+                       upscaling = true;
+               } else {
+                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VC_UP,
+                                     MRV_SRSZ_SCALE_VC_UP_DOWNSCALE);
+               }
+       }
+
+       /* apply upscaling lookup table */
+       if (rsz_lut) {
+               for (i = 0; i <= MRV_SRSZ_SCALE_LUT_ADDR_MASK; i++) {
+                       REG_SET_SLICE(mrv_reg->srsz_scale_lut_addr,
+                                     MRV_SRSZ_SCALE_LUT_ADDR, i);
+                       REG_SET_SLICE(mrv_reg->srsz_scale_lut,
+                                     MRV_SRSZ_SCALE_LUT,
+                                     rsz_lut->rsz_lut[i]);
+               }
+       } else if (upscaling) {
+               eprintk("Upscaling requires lookup table!");
+               WARN_ON(1);
+       }
+
+       /* handle immediate update flag and write mrsz_ctrl */
+       switch (update_time) {
+       case CI_ISP_CFG_UPDATE_FRAME_SYNC:
+               /* frame synchronous update of shadow registers */
+               REG_WRITE(mrv_reg->srsz_ctrl, srsz_ctrl);
+               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_GEN_CFG_UPD,
+                             ON);
+               break;
+       case CI_ISP_CFG_UPDATE_IMMEDIATE:
+               /* immediate update of shadow registers */
+               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_CFG_UPD, ON);
+               REG_WRITE(mrv_reg->srsz_ctrl, srsz_ctrl);
+               break;
+       case CI_ISP_CFG_UPDATE_LATER:
+       default:
+               /* no update from within this function */
+               REG_WRITE(mrv_reg->srsz_ctrl, srsz_ctrl);
+               break;
+       }
+}
+
+/* bad pixel table */
+static struct ci_sensor_bp_table bp_table = { 0 };
+
+/*
+ * Initialization of the Bad Pixel Detection and Correction.
+ */
+int ci_bp_init(const struct ci_isp_bp_corr_config *bp_corr_config,
+              const struct ci_isp_bp_det_config *bp_det_config)
+{
+       int error = CI_STATUS_SUCCESS;
+
+       #define MRVSLS_BPINIT_MAX_TABLE 2048
+
+       /* check the parameters */
+       if (!bp_corr_config || !bp_det_config)
+               return CI_STATUS_NULL_POINTER;
+
+       if (bp_corr_config->bp_corr_type == CI_ISP_BP_CORR_TABLE) {
+               error |= ci_isp_set_bp_correction(bp_corr_config);
+               error |= ci_isp_set_bp_detection(bp_det_config);
+               bp_table.bp_number = 0;
+               if (!bp_table.bp_table_elem) {
+                       bp_table.bp_table_elem =
+                           (struct ci_sensor_bp_table_elem *)
+                           kmalloc((sizeof(struct ci_sensor_bp_table_elem)*
+                                    MRVSLS_BPINIT_MAX_TABLE), GFP_KERNEL);
+                       if (!bp_table.bp_table_elem)
+                               error |= CI_STATUS_FAILURE;
+               }
+
+               bp_table.bp_table_elem_num = MRVSLS_BPINIT_MAX_TABLE;
+               error |= ci_isp_clear_bp_int();
+       } else {
+               if (bp_corr_config->bp_corr_type == CI_ISP_BP_CORR_DIRECT) {
+                       error |= ci_isp_set_bp_correction(bp_corr_config);
+                       error |= ci_isp_set_bp_detection(NULL);
+               } else {
+                       return CI_STATUS_NOTSUPP;
+               }
+       }
+       return error;
+}
+
+/*
+ *  Disable the Bad Pixel Detection and Correction.
+ */
+int ci_bp_end(const struct ci_isp_bp_corr_config *bp_corr_config)
+{
+       int result = CI_STATUS_SUCCESS;
+
+       /* check the parameter */
+       if (!bp_corr_config)
+               return CI_STATUS_NULL_POINTER;
+
+       result |= ci_isp_set_bp_correction(NULL);
+       result |= ci_isp_set_bp_detection(NULL);
+
+       if (bp_corr_config->bp_corr_type == CI_ISP_BP_CORR_TABLE) {
+               result |= ci_isp_clear_bp_int();
+               /* deallocate BP Table */
+               kfree(bp_table.bp_table_elem);
+               bp_table.bp_table_elem = NULL;
+       }
+       return result;
+}
--
1.6.3.2

