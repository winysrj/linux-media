Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45872 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379Ab0ESDJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 23:09:31 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 19 May 2010 11:08:37 +0800
Subject: [PATCH v3 03/10] V4L2 ISP driver patchset for Intel Moorestown
 Camera Imaging Subsystem
Message-ID: <33AB447FBD802F4E932063B962385B351E895D90@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 8f90de786b5fb38957efdc9d34359cf9e046c1b1 Mon Sep 17 00:00:00 2001
From: Xiaolin Zhang <xiaolin.zhang@intel.com>
Date: Tue, 18 May 2010 15:42:02 +0800
Subject: [PATCH 03/10] This patch is a part of v4l2 ISP patchset for Intel Moorestown camera imaging
 subsystem support which control the ISP 3A statistics setting.

Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
---
 drivers/media/video/mrstisp/include/mrstisp_isp.h |   42 +
 drivers/media/video/mrstisp/mrstisp_isp.c         | 1639 +++++++++++++++++++++
 2 files changed, 1681 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/mrstisp/include/mrstisp_isp.h
 create mode 100644 drivers/media/video/mrstisp/mrstisp_isp.c

diff --git a/drivers/media/video/mrstisp/include/mrstisp_isp.h b/drivers/media/video/mrstisp/include/mrstisp_isp.h
new file mode 100644
index 0000000..da24d46
--- /dev/null
+++ b/drivers/media/video/mrstisp/include/mrstisp_isp.h
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
diff --git a/drivers/media/video/mrstisp/mrstisp_isp.c b/drivers/media/video/mrstisp/mrstisp_isp.c
new file mode 100644
index 0000000..4c587b8
--- /dev/null
+++ b/drivers/media/video/mrstisp/mrstisp_isp.c
@@ -0,0 +1,1639 @@
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
+int mrst_isp_set_color_conversion_ex(void)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_0, MRV_ISP_CC_COEFF_0, 0x00001021);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_1, MRV_ISP_CC_COEFF_1, 0x00001040);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_2, MRV_ISP_CC_COEFF_2, 0x0000100D);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_3, MRV_ISP_CC_COEFF_3, 0x00000FED);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_4, MRV_ISP_CC_COEFF_4, 0x00000FDB);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_5, MRV_ISP_CC_COEFF_5, 0x00001038);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_6, MRV_ISP_CC_COEFF_6, 0x00001038);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_7, MRV_ISP_CC_COEFF_7, 0x00000FD1);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_8, MRV_ISP_CC_COEFF_8, 0x00000FF7);
+
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * Selects the ISP path that will become active while processing
+ * data coming from an image sensor configured by the given ISI
+ * configuration struct.
+ */
+enum ci_isp_path ci_isp_select_path(const struct ci_sensor_config *isi_cfg,
+                                   u8 *words_per_pixel)
+{
+       u8 words;
+       enum ci_isp_path ret_val;
+
+       switch (isi_cfg->mode) {
+       case SENSOR_MODE_DATA:
+               ret_val = CI_ISP_PATH_RAW;
+               words = 1;
+               break;
+       case SENSOR_MODE_PICT:
+               ret_val = CI_ISP_PATH_RAW;
+               words = 1;
+               break;
+       case SENSOR_MODE_RGB565:
+               ret_val = CI_ISP_PATH_RAW;
+               words = 2;
+               break;
+       case SENSOR_MODE_BT601:
+               ret_val = CI_ISP_PATH_YCBCR;
+               words = 2;
+               break;
+       case SENSOR_MODE_BT656:
+               ret_val = CI_ISP_PATH_YCBCR;
+               words = 2;
+               break;
+       case SENSOR_MODE_BAYER:
+               ret_val = CI_ISP_PATH_BAYER;
+               words = 1;
+               break;
+
+       case SENSOR_MODE_SMIA:
+               switch (isi_cfg->smia_mode) {
+               case SENSOR_SMIA_MODE_RAW_12:
+               case SENSOR_SMIA_MODE_RAW_10:
+               case SENSOR_SMIA_MODE_RAW_8:
+               case SENSOR_SMIA_MODE_RAW_8_TO_10_DECOMP:
+                       ret_val = CI_ISP_PATH_BAYER;
+                       words = 1;
+                       break;
+               case SENSOR_SMIA_MODE_YUV_422:
+                       ret_val = CI_ISP_PATH_YCBCR;
+                       words = 2;
+                       break;
+               case SENSOR_SMIA_MODE_YUV_420:
+               case SENSOR_SMIA_MODE_RGB_444:
+               case SENSOR_SMIA_MODE_RGB_565:
+               case SENSOR_SMIA_MODE_RGB_888:
+               case SENSOR_SMIA_MODE_COMPRESSED:
+               case SENSOR_SMIA_MODE_RAW_7:
+               case SENSOR_SMIA_MODE_RAW_6:
+               default:
+                       ret_val = CI_ISP_PATH_RAW;
+                       words = 1;
+                       break;
+               }
+               break;
+
+       case SENSOR_MODE_MIPI:
+               switch (isi_cfg->mipi_mode) {
+               case SENSOR_MIPI_MODE_RAW_12:
+               case SENSOR_MIPI_MODE_RAW_10:
+               case SENSOR_MIPI_MODE_RAW_8:
+                       ret_val = CI_ISP_PATH_BAYER;
+                       words = 1;
+                       break;
+               case SENSOR_MIPI_MODE_YUV422_8:
+               case SENSOR_MIPI_MODE_YUV422_10:
+                       ret_val = CI_ISP_PATH_YCBCR;
+                       words = 2;
+                       break;
+               case SENSOR_MIPI_MODE_YUV420_8:
+               case SENSOR_MIPI_MODE_YUV420_10:
+               case SENSOR_MIPI_MODE_LEGACY_YUV420_8:
+               case SENSOR_MIPI_MODE_YUV420_CSPS_8:
+               case SENSOR_MIPI_MODE_YUV420_CSPS_10:
+               case SENSOR_MIPI_MODE_RGB444:
+               case SENSOR_MIPI_MODE_RGB555:
+               case SENSOR_MIPI_MODE_RGB565:
+               case SENSOR_MIPI_MODE_RGB666:
+               case SENSOR_MIPI_MODE_RGB888:
+               case SENSOR_MIPI_MODE_RAW_7:
+               case SENSOR_MIPI_MODE_RAW_6:
+               default:
+                       ret_val = CI_ISP_PATH_RAW;
+                       words = 1;
+                       break;
+               }
+               break;
+       case SENSOR_MODE_BAY_BT656:
+               ret_val = CI_ISP_PATH_BAYER;
+               words = 1;
+               break;
+       case SENSOR_MODE_RAW_BT656:
+               ret_val = CI_ISP_PATH_RAW;
+               words = 1;
+               break;
+       default:
+               ret_val = CI_ISP_PATH_UNKNOWN;
+               words = 1;
+       }
+
+       if (words_per_pixel)
+               *words_per_pixel = words ;
+       return ret_val;
+}
+
+/*
+ * configures the input acquisition according to the
+ * given config structure
+ */
+int ci_isp_set_input_aquisition(const struct ci_sensor_config *isi_cfg)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 isp_ctrl = REG_READ(mrv_reg->isp_ctrl);
+       u32 isp_acq_prop = REG_READ(mrv_reg->isp_acq_prop);
+       u8 sample_factor;
+       u8 black_lines;
+
+       if (ci_isp_select_path(isi_cfg, &sample_factor)
+           == CI_ISP_PATH_UNKNOWN) {
+               eprintk("failed to select path");
+               return CI_STATUS_NOTSUPP;
+       }
+
+       switch (isi_cfg->mode) {
+       case SENSOR_MODE_DATA:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
+                             MRV_ISP_ISP_MODE_DATA);
+               break;
+       case SENSOR_MODE_PICT:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
+                             MRV_ISP_ISP_MODE_RAW);
+               break;
+       case SENSOR_MODE_RGB565:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
+                             MRV_ISP_ISP_MODE_RAW);
+               break;
+       case SENSOR_MODE_BT601:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
+                             MRV_ISP_ISP_MODE_601);
+               break;
+       case SENSOR_MODE_BT656:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
+                             MRV_ISP_ISP_MODE_656);
+               break;
+       case SENSOR_MODE_BAYER:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
+                             MRV_ISP_ISP_MODE_RGB);
+               break;
+       case SENSOR_MODE_BAY_BT656:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
+                             MRV_ISP_ISP_MODE_RGB656);
+               break;
+       case SENSOR_MODE_RAW_BT656:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
+                             MRV_ISP_ISP_MODE_RAW656);
+               break;
+
+       case SENSOR_MODE_SMIA:
+               switch (isi_cfg->smia_mode) {
+               case SENSOR_SMIA_MODE_RAW_12:
+               case SENSOR_SMIA_MODE_RAW_10:
+               case SENSOR_SMIA_MODE_RAW_8:
+               case SENSOR_SMIA_MODE_RAW_8_TO_10_DECOMP:
+               case SENSOR_SMIA_MODE_RAW_7:
+               case SENSOR_SMIA_MODE_RAW_6:
+               case SENSOR_SMIA_MODE_YUV_422:
+               case SENSOR_SMIA_MODE_YUV_420:
+               case SENSOR_SMIA_MODE_RGB_888:
+               case SENSOR_SMIA_MODE_RGB_565:
+               case SENSOR_SMIA_MODE_RGB_444:
+               case SENSOR_SMIA_MODE_COMPRESSED:
+                       return CI_STATUS_SUCCESS;
+                       break;
+               default:
+                       return CI_STATUS_NOTSUPP;
+               }
+               break;
+
+       case SENSOR_MODE_MIPI:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
+                             MRV_ISP_ISP_MODE_RGB);
+               REG_WRITE(mrv_reg->mipi_img_data_sel, 0x02b);
+               break;
+
+       default:
+               return CI_STATUS_NOTSUPP;
+       }
+
+       switch (isi_cfg->bus_width) {
+       case SENSOR_BUSWIDTH_12BIT:
+               /* 000- 12Bit external Interface */
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_INPUT_SELECTION,
+                             MRV_ISP_INPUT_SELECTION_12EXT);
+               break;
+       case SENSOR_BUSWIDTH_10BIT_ZZ:
+               /* 001- 10Bit Interface, append 2 zeroes as LSBs */
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_INPUT_SELECTION,
+                             MRV_ISP_INPUT_SELECTION_10ZERO);
+               break;
+       case SENSOR_BUSWIDTH_10BIT_EX:
+               /* 010- 10Bit Interface, append 2 MSBs as LSBs */
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_INPUT_SELECTION,
+                             MRV_ISP_INPUT_SELECTION_10MSB);
+               break;
+       case SENSOR_BUSWIDTH_8BIT_ZZ:
+               /* 011- 8Bit Interface, append 4 zeroes as LSBs */
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_INPUT_SELECTION,
+                             MRV_ISP_INPUT_SELECTION_8ZERO);
+               break;
+       case SENSOR_BUSWIDTH_8BIT_EX:
+               /* 100- 8Bit Interface, append 4 MSBs as LSBs */
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_INPUT_SELECTION,
+                             MRV_ISP_INPUT_SELECTION_8MSB);
+               break;
+               /* 101...111 reserved */
+       default:
+               return CI_STATUS_NOTSUPP;
+       }
+
+       switch (isi_cfg->field_sel) {
+       case SENSOR_FIELDSEL_ODD:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_FIELD_SELECTION,
+                             MRV_ISP_FIELD_SELECTION_ODD);
+               break;
+       case SENSOR_FIELDSEL_EVEN:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_FIELD_SELECTION,
+                             MRV_ISP_FIELD_SELECTION_EVEN);
+               break;
+       case SENSOR_FIELDSEL_BOTH:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_FIELD_SELECTION,
+                             MRV_ISP_FIELD_SELECTION_BOTH);
+               break;
+       default:
+               return CI_STATUS_NOTSUPP;
+       }
+
+       switch (isi_cfg->ycseq) {
+       case SENSOR_YCSEQ_CRYCBY:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_CCIR_SEQ,
+                             MRV_ISP_CCIR_SEQ_CRYCBY);
+               break;
+       case SENSOR_YCSEQ_CBYCRY:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_CCIR_SEQ,
+                             MRV_ISP_CCIR_SEQ_CBYCRY);
+               break;
+       case SENSOR_YCSEQ_YCRYCB:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_CCIR_SEQ,
+                             MRV_ISP_CCIR_SEQ_YCRYCB);
+               break;
+       case SENSOR_YCSEQ_YCBYCR:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_CCIR_SEQ,
+                             MRV_ISP_CCIR_SEQ_YCBYCR);
+               break;
+       default:
+               return CI_STATUS_NOTSUPP;
+       }
+
+       switch (isi_cfg->conv422) {
+       case SENSOR_CONV422_INTER:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_CONV_422,
+                       MRV_ISP_CONV_422_INTER);
+               break;
+
+       case SENSOR_CONV422_NOCOSITED:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_CONV_422,
+                     MRV_ISP_CONV_422_NONCO);
+               break;
+       case SENSOR_CONV422_COSITED:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_CONV_422,
+                     MRV_ISP_CONV_422_CO);
+               break;
+       default:
+       return CI_STATUS_NOTSUPP;
+       }
+
+       switch (isi_cfg->bpat) {
+       case SENSOR_BPAT_BGBGGRGR:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_BAYER_PAT,
+                     MRV_ISP_BAYER_PAT_BG);
+               break;
+       case SENSOR_BPAT_GBGBRGRG:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_BAYER_PAT,
+                     MRV_ISP_BAYER_PAT_GB);
+               break;
+       case SENSOR_BPAT_GRGRBGBG:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_BAYER_PAT,
+                     MRV_ISP_BAYER_PAT_GR);
+               break;
+       case SENSOR_BPAT_RGRGGBGB:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_BAYER_PAT,
+                     MRV_ISP_BAYER_PAT_RG);
+               break;
+       default:
+               return CI_STATUS_NOTSUPP;
+       }
+
+       switch (isi_cfg->vpol) {
+       case SENSOR_VPOL_POS:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_VSYNC_POL, 1);
+               break;
+       case SENSOR_VPOL_NEG:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_VSYNC_POL, 0);
+               break;
+       default:
+               return CI_STATUS_NOTSUPP;
+       }
+
+       switch (isi_cfg->hpol) {
+       /* vsync_pol = 1 triggers on positive edge whereas */
+       /* hsync_pol = 1 triggers on negative edge and vice versa */
+       case SENSOR_HPOL_SYNCPOS:
+               /* trigger on negative edge */
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_HSYNC_POL, 1);
+               break;
+       case SENSOR_HPOL_SYNCNEG:
+               /* trigger on positive edge */
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_HSYNC_POL, 0);
+               break;
+       case SENSOR_HPOL_REFPOS:
+               /* trigger on positive edge */
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_HSYNC_POL, 0);
+               break;
+       case SENSOR_HPOL_REFNEG:
+               /* trigger on negative edge */
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_HSYNC_POL, 1);
+               break;
+       default:
+               return CI_STATUS_NOTSUPP;
+       }
+
+       switch (isi_cfg->edge) {
+       case SENSOR_EDGE_RISING:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_SAMPLE_EDGE, 1);
+               break;
+       case SENSOR_EDGE_FALLING:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_SAMPLE_EDGE, 0);
+               break;
+       default:
+               return CI_STATUS_NOTSUPP;
+       }
+       dprintk(2, "isp_acq_prop = 0x%x", isp_acq_prop);
+
+       /* now write values to registers */
+       REG_WRITE(mrv_reg->isp_ctrl, isp_ctrl);
+       REG_WRITE(mrv_reg->isp_acq_prop, isp_acq_prop);
+
+       /* number of additional black lines at frame start */
+       switch (isi_cfg->bls) {
+       case SENSOR_BLS_OFF:
+               black_lines = 0;
+               break;
+       case SENSOR_BLS_TWO_LINES:
+               black_lines = 2;
+               break;
+       case SENSOR_BLS_FOUR_LINES:
+               black_lines = 4;
+               break;
+       default:
+               return CI_STATUS_NOTSUPP;
+       }
+
+       REG_SET_SLICE(mrv_reg->isp_acq_h_offs, MRV_ISP_ACQ_H_OFFS,
+                     0 * sample_factor);
+       REG_SET_SLICE(mrv_reg->isp_acq_v_offs, MRV_ISP_ACQ_V_OFFS, 0);
+
+       dprintk(2, "res = %x", isi_cfg->res);
+       switch (isi_cfg->res) {
+       /* 88x72 */
+       case SENSOR_RES_QQCIF:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             QQCIF_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QQCIF_SIZE_V + black_lines);
+               break;
+       /* 160x120 */
+       case SENSOR_RES_QQVGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             QQVGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QQVGA_SIZE_V + black_lines);
+               break;
+       /* 176x144 */
+       case SENSOR_RES_QCIF:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             QCIF_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QCIF_SIZE_V + black_lines);
+               break;
+       /* 320x240 */
+       case SENSOR_RES_QVGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             QVGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QVGA_SIZE_V + black_lines);
+               break;
+       /* 352x288 */
+       case SENSOR_RES_CIF:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             CIF_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             CIF_SIZE_V + black_lines);
+               break;
+       /* 640x480 */
+       case SENSOR_RES_VGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             VGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             VGA_SIZE_V + black_lines);
+               break;
+       /* 800x600 */
+       case SENSOR_RES_SVGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             SVGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             SVGA_SIZE_V + black_lines);
+               break;
+       /* 1024x768 */
+       case SENSOR_RES_XGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             XGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             XGA_SIZE_V + black_lines);
+               break;
+       case SENSOR_RES_720P:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             RES_720P_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             RES_720P_SIZE_V + black_lines);
+               break;
+       /* 1280x960 */
+       case SENSOR_RES_XGA_PLUS:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             XGA_PLUS_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             XGA_PLUS_SIZE_V + black_lines);
+               break;
+       /* 1280x1024 */
+       case SENSOR_RES_SXGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             SXGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             SXGA_SIZE_V + black_lines);
+               break;
+       /* 1600x1200 */
+       case SENSOR_RES_UXGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             QSVGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QSVGA_SIZE_V + black_lines);
+               break;
+       /* 1920x1280 */
+       case SENSOR_RES_1080P:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             1920 * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             1080 + black_lines);
+               break;
+       /* 2048x1536 */
+       case SENSOR_RES_QXGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             QXGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QXGA_SIZE_V + black_lines);
+               break;
+       /* 2586x2048 */
+       case SENSOR_RES_QSXGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             QSXGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QSXGA_SIZE_V + black_lines);
+               break;
+       /* 2600x2048 */
+       case SENSOR_RES_QSXGA_PLUS:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             QSXGA_PLUS_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QSXGA_PLUS_SIZE_V + black_lines);
+               break;
+       /* 2600x1950 */
+       case SENSOR_RES_QSXGA_PLUS2:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             QSXGA_PLUS2_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QSXGA_PLUS2_SIZE_V + black_lines);
+               break;
+       /* 2686x2048,  5.30M */
+       case SENSOR_RES_QSXGA_PLUS3:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             QSXGA_PLUS3_SIZE_V * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QSXGA_PLUS3_SIZE_V + black_lines);
+               break;
+       /* 2592*1944 5M */
+       case SENSOR_RES_QXGA_PLUS:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                               QXGA_PLUS_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QXGA_PLUS_SIZE_V + black_lines);
+               break;
+       /* 3200x2048,  6.56M */
+       case SENSOR_RES_WQSXGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             WQSXGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             WQSXGA_SIZE_V + black_lines);
+               break;
+       /* 3200x2400,  7.68M */
+       case SENSOR_RES_QUXGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             QUXGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QUXGA_SIZE_V + black_lines);
+               break;
+       /* 3840x2400,  9.22M */
+       case SENSOR_RES_WQUXGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             WQUXGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             WQUXGA_SIZE_V + black_lines);
+               break;
+       /* 4096x3072, 12.59M */
+       case SENSOR_RES_HXGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             HXGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             HXGA_SIZE_V + black_lines);
+               break;
+       /* 4080x1024 */
+       case SENSOR_RES_YUV_HMAX:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             YUV_HMAX_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             YUV_HMAX_SIZE_V);
+               break;
+       /* 1024x4080 */
+       case SENSOR_RES_YUV_VMAX:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             YUV_VMAX_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             YUV_VMAX_SIZE_V);
+               break;
+       /* 4096x2048 */
+       case SENSOR_RES_RAWMAX:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             RAWMAX_SIZE_H);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             RAWMAX_SIZE_V);
+               break;
+       /* 352x240 */
+       case SENSOR_RES_BP1:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             BP1_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             BP1_SIZE_V);
+               break;
+       /* 720x480 */
+       case SENSOR_RES_L_AFM:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             L_AFM_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             L_AFM_SIZE_V);
+               break;
+       /* 128x96 */
+       case SENSOR_RES_M_AFM:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             M_AFM_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             M_AFM_SIZE_V);
+               break;
+       /* 64x32 */
+       case SENSOR_RES_S_AFM:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             S_AFM_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             S_AFM_SIZE_V);
+               break;
+       /* 1304x980 */
+       case SENSOR_RES_VGA_PLUS:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             VGA_PLUS_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             VGA_PLUS_SIZE_V);
+               break;
+
+       default:
+               return CI_STATUS_NOTSUPP;
+       }
+
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * sets output window
+ */
+void ci_isp_set_output_formatter(const struct ci_isp_window *window,
+                                enum ci_isp_conf_update_time update_time)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       if (window) {
+               REG_SET_SLICE(mrv_reg->isp_out_h_offs, MRV_IS_IS_H_OFFS,
+                       window->hoffs);
+               REG_SET_SLICE(mrv_reg->isp_out_v_offs, MRV_IS_IS_V_OFFS,
+                       window->voffs);
+               REG_SET_SLICE(mrv_reg->isp_out_h_size, MRV_IS_IS_H_SIZE,
+                       window->hsize);
+               REG_SET_SLICE(mrv_reg->isp_out_v_size, MRV_IS_IS_V_SIZE,
+                       window->vsize);
+
+               REG_SET_SLICE(mrv_reg->isp_is_h_offs, MRV_IS_IS_H_OFFS, 0);
+               REG_SET_SLICE(mrv_reg->isp_is_v_offs, MRV_IS_IS_V_OFFS, 0);
+               REG_SET_SLICE(mrv_reg->isp_is_h_size, MRV_IS_IS_H_SIZE,
+                       window->hsize);
+               REG_SET_SLICE(mrv_reg->isp_is_v_size, MRV_IS_IS_V_SIZE,
+                       window->vsize);
+
+               switch (update_time) {
+               case CI_ISP_CFG_UPDATE_FRAME_SYNC:
+                       /* frame synchronous update of shadow registers */
+                       REG_SET_SLICE(mrv_reg->isp_ctrl,
+                               MRV_ISP_ISP_GEN_CFG_UPD, ON);
+                       break;
+               case CI_ISP_CFG_UPDATE_IMMEDIATE:
+                       /* immediate update of shadow registers */
+                       REG_SET_SLICE(mrv_reg->isp_ctrl,
+                               MRV_ISP_ISP_CFG_UPD, ON);
+                       break;
+               case CI_ISP_CFG_UPDATE_LATER:
+                       /* no update from within this function */
+                       break;
+               default:
+                       break;
+               }
+       }
+}
+
+/*
+ * programs the given Bayer pattern demosaic parameters
+ */
+void ci_isp_set_demosaic(enum ci_isp_demosaic_mode demosaic_mode,
+                        u8 demosaic_th)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 isp_demosaic = REG_READ(mrv_reg->isp_demosaic);
+
+       switch (demosaic_mode) {
+       case CI_ISP_DEMOSAIC_STANDARD:
+               REG_SET_SLICE(isp_demosaic, MRV_ISP_DEMOSAIC_MODE,
+                             MRV_ISP_DEMOSAIC_MODE_STD);
+               break;
+       case CI_ISP_DEMOSAIC_ENHANCED:
+               REG_SET_SLICE(isp_demosaic, MRV_ISP_DEMOSAIC_MODE,
+                             MRV_ISP_DEMOSAIC_MODE_ENH);
+               break;
+       default:
+               WARN_ON(!(false));
+       }
+
+       REG_SET_SLICE(isp_demosaic, MRV_ISP_DEMOSAIC_TH, demosaic_th);
+       REG_WRITE(mrv_reg->isp_demosaic, isp_demosaic);
+}
+
+/*
+ * Sets the dedicated AWB block mode.
+ */
+int ci_isp_set_wb_mode(enum ci_isp_awb_mode wb_mode)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       switch (wb_mode) {
+       case CI_ISP_AWB_COMPLETELY_OFF:
+               /* manual WB, no measurements*/
+               REG_SET_SLICE(mrv_reg->isp_awb_prop, MRV_ISP_AWB_MODE,
+                             MRV_ISP_AWB_MODE_NOMEAS);
+               /* switch ABW block off */
+               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_AWB_ENABLE,
+                             DISABLE);
+               break;
+       case CI_ISP_AWB_MAN_MEAS:
+       case CI_ISP_AWB_AUTO:
+       case CI_ISP_AWB_MAN_PUSH_AUTO:
+       case CI_ISP_AWB_ONLY_MEAS:
+               /* manual white balance, measure YCbCr means */
+               REG_SET_SLICE(mrv_reg->isp_awb_prop, MRV_ISP_AWB_MODE,
+                       MRV_ISP_AWB_MODE_MEAS);
+               /* switch ABW block on */
+               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_AWB_ENABLE,
+                       ENABLE);
+               break;
+       case CI_ISP_AWB_MAN_NOMEAS:
+               /* manual white balance, no measurements */
+               REG_SET_SLICE(mrv_reg->isp_awb_prop, MRV_ISP_AWB_MODE,
+                       MRV_ISP_AWB_MODE_NOMEAS);
+               /* switch ABW block on */
+               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_AWB_ENABLE,
+                             ENABLE);
+               break;
+       default:
+               REG_SET_SLICE(mrv_reg->isp_awb_prop, MRV_ISP_AWB_MODE,
+                       MRV_ISP_AWB_MODE_NOMEAS);
+               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_AWB_ENABLE,
+                       DISABLE);
+               return CI_STATUS_FAILURE;
+       }
+
+       return CI_STATUS_SUCCESS;
+}
+
+int ci_isp_get_wb_mode(enum ci_isp_awb_mode *wb_mode)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       if (!wb_mode)
+               return CI_STATUS_NULL_POINTER;
+
+       if (REG_GET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_AWB_ENABLE) ==
+               DISABLE) {
+               *wb_mode = CI_ISP_AWB_COMPLETELY_OFF;
+       } else {
+
+               switch (REG_GET_SLICE(mrv_reg->isp_awb_prop,
+                       MRV_ISP_AWB_MODE)) {
+               case MRV_ISP_AWB_MODE_MEAS:
+                       *wb_mode = CI_ISP_AWB_MAN_MEAS;
+                       break;
+               case MRV_ISP_AWB_MODE_NOMEAS:
+                       *wb_mode = CI_ISP_AWB_MAN_NOMEAS;
+                       break;
+               default:
+                       *wb_mode = CI_ISP_AWB_COMPLETELY_OFF;
+                       return CI_STATUS_FAILURE;
+               }
+       }
+       return CI_STATUS_SUCCESS;
+}
+
+int ci_isp_set_wb_meas_config(const struct ci_isp_wb_meas_config
+                             *wb_meas_config)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 isp_awb_thresh = REG_READ(mrv_reg->isp_awb_thresh);
+
+       if (!wb_meas_config)
+               return CI_STATUS_NULL_POINTER;
+
+       /* measurement window */
+       REG_SET_SLICE(mrv_reg->isp_awb_h_size, MRV_ISP_AWB_H_SIZE,
+               (u32) wb_meas_config->awb_window.hsize);
+       REG_SET_SLICE(mrv_reg->isp_awb_v_size, MRV_ISP_AWB_V_SIZE,
+               (u32) wb_meas_config->awb_window.vsize);
+       REG_SET_SLICE(mrv_reg->isp_awb_h_offs, MRV_ISP_AWB_H_OFFS,
+               (u32) wb_meas_config->awb_window.hoffs);
+       REG_SET_SLICE(mrv_reg->isp_awb_v_offs, MRV_ISP_AWB_V_OFFS,
+               (u32) wb_meas_config->awb_window.voffs);
+
+       /* adjust awb properties (Y_MAX compare) */
+       if (wb_meas_config->max_y == 0) {
+               REG_SET_SLICE(mrv_reg->isp_awb_prop, MRV_ISP_AWB_MAX_EN,
+                       DISABLE);
+       } else {
+               REG_SET_SLICE(mrv_reg->isp_awb_prop, MRV_ISP_AWB_MAX_EN,
+                       ENABLE);
+       }
+
+       /* measurement thresholds */
+       REG_SET_SLICE(isp_awb_thresh, MRV_ISP_AWB_MAX_Y,
+                     (u32) wb_meas_config->max_y);
+       REG_SET_SLICE(isp_awb_thresh, MRV_ISP_AWB_MIN_Y__MAX_G,
+                     (u32) wb_meas_config->min_y_max_g);
+       REG_SET_SLICE(isp_awb_thresh, MRV_ISP_AWB_MAX_CSUM,
+                     (u32) wb_meas_config->max_csum);
+       REG_SET_SLICE(isp_awb_thresh, MRV_ISP_AWB_MIN_C,
+                     (u32) wb_meas_config->min_c);
+       REG_WRITE(mrv_reg->isp_awb_thresh, isp_awb_thresh);
+       REG_SET_SLICE(mrv_reg->isp_awb_ref, MRV_ISP_AWB_REF_CR__MAX_R,
+                     (u32)(wb_meas_config->ref_cr_max_r));
+       REG_SET_SLICE(mrv_reg->isp_awb_ref, MRV_ISP_AWB_REF_CB__MAX_B,
+                     (u32)(wb_meas_config->ref_cb_max_b));
+
+       /* amount of measurement frames */
+       REG_SET_SLICE(mrv_reg->isp_awb_frames, MRV_ISP_AWB_FRAMES,
+                     (u32) wb_meas_config->frames);
+
+       /* set measurement mode */
+       REG_SET_SLICE(mrv_reg->isp_awb_prop, MRV_ISP_AWB_MEAS_MODE,
+                     (u32)(wb_meas_config->meas_mode));
+
+       return CI_STATUS_SUCCESS;
+}
+
+int ci_isp_get_wb_meas_config(struct ci_isp_wb_meas_config *wb_meas_config)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       if (!wb_meas_config)
+               return CI_STATUS_NULL_POINTER;
+
+       /* measurement window */
+       wb_meas_config->awb_window.hsize =
+           (u16) REG_GET_SLICE(mrv_reg->isp_awb_h_size, MRV_ISP_AWB_H_SIZE);
+       wb_meas_config->awb_window.vsize =
+           (u16) REG_GET_SLICE(mrv_reg->isp_awb_v_size, MRV_ISP_AWB_V_SIZE);
+       wb_meas_config->awb_window.hoffs =
+           (u16) REG_GET_SLICE(mrv_reg->isp_awb_h_offs, MRV_ISP_AWB_H_OFFS);
+       wb_meas_config->awb_window.voffs =
+           (u16) REG_GET_SLICE(mrv_reg->isp_awb_v_offs, MRV_ISP_AWB_V_OFFS);
+
+       /* measurement thresholds */
+       wb_meas_config->min_c =
+           (u8) REG_GET_SLICE(mrv_reg->isp_awb_thresh, MRV_ISP_AWB_MIN_C);
+       wb_meas_config->max_csum =
+           (u8) REG_GET_SLICE(mrv_reg->isp_awb_thresh, MRV_ISP_AWB_MAX_CSUM);
+       wb_meas_config->min_y_max_g =
+           (u8) REG_GET_SLICE(mrv_reg->isp_awb_thresh,
+                              MRV_ISP_AWB_MIN_Y__MAX_G);
+       wb_meas_config->max_y =
+           (u8) REG_GET_SLICE(mrv_reg->isp_awb_thresh, MRV_ISP_AWB_MAX_Y);
+       wb_meas_config->ref_cb_max_b =
+           (u8)REG_GET_SLICE(mrv_reg->isp_awb_ref, MRV_ISP_AWB_REF_CB__MAX_B);
+       wb_meas_config->ref_cr_max_r =
+           (u8)REG_GET_SLICE(mrv_reg->isp_awb_ref, MRV_ISP_AWB_REF_CR__MAX_R);
+
+       /* amount of measurement frames */
+       wb_meas_config->frames =
+           (u8) REG_GET_SLICE(mrv_reg->isp_awb_frames, MRV_ISP_AWB_FRAMES);
+
+       /* overwrite max_y if the feature is disabled */
+       if (REG_GET_SLICE(mrv_reg->isp_awb_prop, MRV_ISP_AWB_MAX_EN) ==
+           DISABLE) {
+               wb_meas_config->max_y = 0;
+       }
+
+       /* get measurement mode */
+       wb_meas_config->meas_mode = REG_GET_SLICE(mrv_reg->isp_awb_prop,
+                                                 MRV_ISP_AWB_MEAS_MODE);
+       return CI_STATUS_SUCCESS;
+}
+
+int ci_isp_get_wb_meas(struct ci_sensor_awb_mean *awb_mean)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       if (awb_mean == NULL)
+               return CI_STATUS_NULL_POINTER;
+
+       awb_mean->white = REG_GET_SLICE(mrv_reg->isp_awb_white_cnt,
+                                       MRV_ISP_AWB_WHITE_CNT);
+       awb_mean->mean_y_g = (u8) REG_GET_SLICE(mrv_reg->isp_awb_mean,
+                                                MRV_ISP_AWB_MEAN_Y__G);
+       awb_mean->mean_cb_b = (u8) REG_GET_SLICE(mrv_reg->isp_awb_mean,
+                                                 MRV_ISP_AWB_MEAN_CB__B);
+       awb_mean->mean_cr_r = (u8) REG_GET_SLICE(mrv_reg->isp_awb_mean,
+                                                 MRV_ISP_AWB_MEAN_CR__R);
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * calculates left-top and right-bottom register values
+ * for a given AF measurement window
+ */
+static int ci_isp_afm_wnd2_regs(const struct ci_isp_window *wnd, u32 *lt,
+                               u32 *rb)
+{
+       WARN_ON(!((wnd != NULL) && (lt != NULL) && (rb != NULL)));
+
+       if (wnd->hsize && wnd->vsize) {
+               u32 left = wnd->hoffs;
+               u32 top = wnd->voffs;
+               u32 right = left + wnd->hsize - 1;
+               u32 bottom = top + wnd->vsize - 1;
+
+               if ((left < MRV_AFM_A_H_L_MIN)
+                   || (left > MRV_AFM_A_H_L_MAX)
+                   || (top < MRV_AFM_A_V_T_MIN)
+                   || (top > MRV_AFM_A_V_T_MAX)
+                   || (right < MRV_AFM_A_H_R_MIN)
+                   || (right > MRV_AFM_A_H_R_MAX)
+                   || (bottom < MRV_AFM_A_V_B_MIN)
+                   || (bottom > MRV_AFM_A_V_B_MAX)) {
+                       return CI_STATUS_OUTOFRANGE;
+               }
+
+               /* combine the values and return */
+               REG_SET_SLICE(*lt, MRV_AFM_A_H_L, left);
+               REG_SET_SLICE(*lt, MRV_AFM_A_V_T, top);
+               REG_SET_SLICE(*rb, MRV_AFM_A_H_R, right);
+               REG_SET_SLICE(*rb, MRV_AFM_A_V_B, bottom);
+       } else {
+               *lt = 0;
+               *rb = 0;
+       }
+
+       return CI_STATUS_SUCCESS;
+}
+
+int ci_isp_set_auto_focus(const struct ci_isp_af_config *af_config)
+{
+
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 result = CI_STATUS_SUCCESS;
+       u32 lt;
+       u32 rb;
+       /* disable measurement module */
+       REG_SET_SLICE(mrv_reg->isp_afm_ctrl, MRV_AFM_AFM_EN, DISABLE);
+
+       if (!af_config)
+               return result;
+
+       result = ci_isp_afm_wnd2_regs(&(af_config->wnd_pos_a), &lt, &rb);
+       /* set measurement window boundaries */
+       if (result != CI_STATUS_SUCCESS)
+               return result;
+
+       REG_WRITE(mrv_reg->isp_afm_lt_a, lt);
+       REG_WRITE(mrv_reg->isp_afm_rb_a, rb);
+
+       result = ci_isp_afm_wnd2_regs(&(af_config->wnd_pos_b),
+                                     &lt, &rb);
+
+       if (result != CI_STATUS_SUCCESS)
+               return result;
+
+       REG_WRITE(mrv_reg->isp_afm_lt_b, lt);
+       REG_WRITE(mrv_reg->isp_afm_rb_b, rb);
+
+       result = ci_isp_afm_wnd2_regs(&(af_config->wnd_pos_c),
+                                     &lt, &rb);
+
+       if (result != CI_STATUS_SUCCESS)
+               return result;
+
+       REG_WRITE(mrv_reg->isp_afm_lt_c, lt);
+       REG_WRITE(mrv_reg->isp_afm_rb_c, rb);
+
+       /* set other af measurement paraneters */
+       REG_SET_SLICE(mrv_reg->isp_afm_thres, MRV_AFM_AFM_THRES,
+                     af_config->threshold);
+       REG_SET_SLICE(mrv_reg->isp_afm_var_shift, MRV_AFM_LUM_VAR_SHIFT,
+               (af_config->var_shift >> 16));
+       REG_SET_SLICE(mrv_reg->isp_afm_var_shift, MRV_AFM_AFM_VAR_SHIFT,
+               (af_config->var_shift >> 0));
+
+       /* enable measurement module */
+       REG_SET_SLICE(mrv_reg->isp_afm_ctrl, MRV_AFM_AFM_EN, ENABLE);
+
+       return result;
+}
+
+
+void ci_isp_get_auto_focus_meas(struct ci_isp_af_meas *af_meas)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       WARN_ON(!(af_meas != NULL));
+
+       af_meas->afm_sum_a =
+           REG_GET_SLICE(mrv_reg->isp_afm_sum_a, MRV_AFM_AFM_SUM_A);
+       af_meas->afm_sum_b =
+           REG_GET_SLICE(mrv_reg->isp_afm_sum_b, MRV_AFM_AFM_SUM_B);
+       af_meas->afm_sum_c =
+           REG_GET_SLICE(mrv_reg->isp_afm_sum_c, MRV_AFM_AFM_SUM_C);
+       af_meas->afm_lum_a =
+           REG_GET_SLICE(mrv_reg->isp_afm_lum_a, MRV_AFM_AFM_LUM_A);
+       af_meas->afm_lum_b =
+           REG_GET_SLICE(mrv_reg->isp_afm_lum_b, MRV_AFM_AFM_LUM_B);
+       af_meas->afm_lum_c =
+           REG_GET_SLICE(mrv_reg->isp_afm_lum_c, MRV_AFM_AFM_LUM_C);
+}
+
+int ci_isp_set_ls_correction(struct ci_sensor_ls_corr_config *ls_corr_config)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 i, n;
+       u32 data = 0;
+       int enabled = false;
+
+       if (!ls_corr_config) {
+               REG_SET_SLICE(mrv_reg->isp_lsc_ctrl, MRV_LSC_LSC_EN, DISABLE);
+               return CI_STATUS_SUCCESS;
+       }
+
+       if (REG_GET_SLICE(mrv_reg->isp_lsc_ctrl, MRV_LSC_LSC_EN)) {
+               REG_SET_SLICE(mrv_reg->isp_lsc_ctrl,
+                             MRV_LSC_LSC_EN, DISABLE);
+               msleep(1000);
+               enabled = true;
+       }
+
+       /* clear address counters */
+       REG_WRITE(mrv_reg->isp_lsc_r_table_addr, 0);
+       REG_WRITE(mrv_reg->isp_lsc_g_table_addr, 0);
+       REG_WRITE(mrv_reg->isp_lsc_b_table_addr, 0);
+
+       WARN_ON(!(((CI_ISP_MAX_LSC_SECTORS + 1) *
+               ((CI_ISP_MAX_LSC_SECTORS + 2) / 2)) ==
+               (MRV_LSC_R_RAM_ADDR_MAX + 1)));
+
+       /* 17 steps */
+       for (n = 0;
+       n < ((CI_ISP_MAX_LSC_SECTORS + 1) *
+            (CI_ISP_MAX_LSC_SECTORS + 1));
+       n += CI_ISP_MAX_LSC_SECTORS + 1) {
+               for (i = 0; i < (CI_ISP_MAX_LSC_SECTORS); i += 2) {
+                       REG_SET_SLICE(data, MRV_LSC_R_SAMPLE_0,
+                               ls_corr_config->ls_rdata_tbl[n + i]);
+                       REG_SET_SLICE(data, MRV_LSC_R_SAMPLE_1,
+                               ls_corr_config->ls_rdata_tbl
+                               [n + i + 1]);
+                       REG_WRITE(mrv_reg->isp_lsc_r_table_data, data);
+                       REG_SET_SLICE(data, MRV_LSC_G_SAMPLE_0,
+                               ls_corr_config->ls_gdata_tbl
+                               [n + i]);
+                       REG_SET_SLICE(data, MRV_LSC_G_SAMPLE_1,
+                               ls_corr_config->ls_gdata_tbl
+                               [n + i + 1]);
+                       REG_WRITE(mrv_reg->isp_lsc_g_table_data, data);
+                       REG_SET_SLICE(data, MRV_LSC_B_SAMPLE_0,
+                               ls_corr_config->ls_bdata_tbl[n + i]);
+                       REG_SET_SLICE(data, MRV_LSC_B_SAMPLE_1,
+                               ls_corr_config->ls_bdata_tbl
+                               [n + i + 1]);
+                       REG_WRITE(mrv_reg->isp_lsc_b_table_data, data);
+               }
+
+               REG_SET_SLICE(data, MRV_LSC_R_SAMPLE_0,
+                       ls_corr_config->ls_rdata_tbl
+                       [n + CI_ISP_MAX_LSC_SECTORS]);
+               REG_SET_SLICE(data, MRV_LSC_R_SAMPLE_1, 0);
+               REG_WRITE(mrv_reg->isp_lsc_r_table_data, data);
+               REG_SET_SLICE(data, MRV_LSC_G_SAMPLE_0,
+                       ls_corr_config->ls_gdata_tbl
+                       [n + CI_ISP_MAX_LSC_SECTORS]);
+               REG_SET_SLICE(data, MRV_LSC_G_SAMPLE_1, 0);
+               REG_WRITE(mrv_reg->isp_lsc_g_table_data, data);
+               REG_SET_SLICE(data, MRV_LSC_B_SAMPLE_0,
+                       ls_corr_config->ls_bdata_tbl
+                       [n + CI_ISP_MAX_LSC_SECTORS]);
+               REG_SET_SLICE(data, MRV_LSC_B_SAMPLE_1, 0);
+               REG_WRITE(mrv_reg->isp_lsc_b_table_data, data);
+       }
+
+       /* program x size tables */
+       REG_SET_SLICE(mrv_reg->isp_lsc_xsize_01, MRV_LSC_X_SECT_SIZE_0,
+                     ls_corr_config->ls_xsize_tbl[0]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_xsize_01, MRV_LSC_X_SECT_SIZE_1,
+                     ls_corr_config->ls_xsize_tbl[1]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_xsize_23, MRV_LSC_X_SECT_SIZE_2,
+                     ls_corr_config->ls_xsize_tbl[2]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_xsize_23, MRV_LSC_X_SECT_SIZE_3,
+                     ls_corr_config->ls_xsize_tbl[3]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_xsize_45, MRV_LSC_X_SECT_SIZE_4,
+                     ls_corr_config->ls_xsize_tbl[4]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_xsize_45, MRV_LSC_X_SECT_SIZE_5,
+                     ls_corr_config->ls_xsize_tbl[5]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_xsize_67, MRV_LSC_X_SECT_SIZE_6,
+                     ls_corr_config->ls_xsize_tbl[6]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_xsize_67, MRV_LSC_X_SECT_SIZE_7,
+                     ls_corr_config->ls_xsize_tbl[7]);
+
+       /* program y size tables */
+       REG_SET_SLICE(mrv_reg->isp_lsc_ysize_01, MRV_LSC_Y_SECT_SIZE_0,
+                     ls_corr_config->ls_ysize_tbl[0]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_ysize_01, MRV_LSC_Y_SECT_SIZE_1,
+                     ls_corr_config->ls_ysize_tbl[1]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_ysize_23, MRV_LSC_Y_SECT_SIZE_2,
+                     ls_corr_config->ls_ysize_tbl[2]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_ysize_23, MRV_LSC_Y_SECT_SIZE_3,
+                     ls_corr_config->ls_ysize_tbl[3]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_ysize_45, MRV_LSC_Y_SECT_SIZE_4,
+                     ls_corr_config->ls_ysize_tbl[4]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_ysize_45, MRV_LSC_Y_SECT_SIZE_5,
+                     ls_corr_config->ls_ysize_tbl[5]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_ysize_67, MRV_LSC_Y_SECT_SIZE_6,
+                     ls_corr_config->ls_ysize_tbl[6]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_ysize_67, MRV_LSC_Y_SECT_SIZE_7,
+                     ls_corr_config->ls_ysize_tbl[7]);
+
+       /* program x grad tables */
+       REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_01, MRV_LSC_XGRAD_0,
+                     ls_corr_config->ls_xgrad_tbl[0]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_01, MRV_LSC_XGRAD_1,
+                     ls_corr_config->ls_xgrad_tbl[1]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_23, MRV_LSC_XGRAD_2,
+                     ls_corr_config->ls_xgrad_tbl[2]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_23, MRV_LSC_XGRAD_3,
+                     ls_corr_config->ls_xgrad_tbl[3]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_45, MRV_LSC_XGRAD_4,
+                     ls_corr_config->ls_xgrad_tbl[4]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_45, MRV_LSC_XGRAD_5,
+                     ls_corr_config->ls_xgrad_tbl[5]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_67, MRV_LSC_XGRAD_6,
+                     ls_corr_config->ls_xgrad_tbl[6]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_67, MRV_LSC_XGRAD_7,
+                     ls_corr_config->ls_xgrad_tbl[7]);
+
+       /* program y grad tables */
+       REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_01, MRV_LSC_YGRAD_0,
+                     ls_corr_config->ls_ygrad_tbl[0]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_01, MRV_LSC_YGRAD_1,
+                     ls_corr_config->ls_ygrad_tbl[1]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_23, MRV_LSC_YGRAD_2,
+                     ls_corr_config->ls_ygrad_tbl[2]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_23, MRV_LSC_YGRAD_3,
+                     ls_corr_config->ls_ygrad_tbl[3]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_45, MRV_LSC_YGRAD_4,
+                     ls_corr_config->ls_ygrad_tbl[4]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_45, MRV_LSC_YGRAD_5,
+                     ls_corr_config->ls_ygrad_tbl[5]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_67, MRV_LSC_YGRAD_6,
+                     ls_corr_config->ls_ygrad_tbl[6]);
+       REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_67, MRV_LSC_YGRAD_7,
+                     ls_corr_config->ls_ygrad_tbl[7]);
+
+       if (enabled) {
+               /* switch on lens chading correction */
+               REG_SET_SLICE(mrv_reg->isp_lsc_ctrl,
+                             MRV_LSC_LSC_EN, ENABLE);
+       }
+
+       return CI_STATUS_SUCCESS;
+}
+
+int ci_isp_ls_correction_on_off(int ls_corr_on_off)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       if (ls_corr_on_off) {
+               /* switch on lens chading correction */
+               REG_SET_SLICE(mrv_reg->isp_lsc_ctrl, MRV_LSC_LSC_EN, ENABLE);
+       } else {
+               /* switch off lens chading correction */
+               REG_SET_SLICE(mrv_reg->isp_lsc_ctrl, MRV_LSC_LSC_EN, DISABLE);
+       }
+
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * Sets the Bad Pixel Correction configuration
+ */
+int ci_isp_set_bp_correction(const struct ci_isp_bp_corr_config
+                             *bp_corr_config)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 isp_bp_ctrl = REG_READ(mrv_reg->isp_bp_ctrl);
+
+       if (!bp_corr_config) {
+               /* disable correction module */
+               REG_SET_SLICE(isp_bp_ctrl, MRV_BP_HOT_COR_EN, DISABLE);
+               REG_SET_SLICE(isp_bp_ctrl, MRV_BP_DEAD_COR_EN, DISABLE);
+       } else {
+               if (bp_corr_config->bp_corr_type == CI_ISP_BP_CORR_DIRECT) {
+                       u32 isp_bp_cfg1 = REG_READ(mrv_reg->isp_bp_cfg1);
+                       u32 isp_bp_cfg2 = REG_READ(mrv_reg->isp_bp_cfg2);
+
+                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_COR_TYPE,
+                                     MRV_BP_COR_TYPE_DIRECT);
+
+                       WARN_ON(!(!REG_GET_SLICE(mrv_reg->isp_bp_ctrl,
+                                                MRV_BP_BP_DET_EN)));
+
+                       /* threshold register only used for direct mode */
+                       REG_SET_SLICE(isp_bp_cfg1, MRV_BP_HOT_THRES,
+                                     bp_corr_config->bp_abs_hot_thres);
+                       REG_SET_SLICE(isp_bp_cfg1, MRV_BP_DEAD_THRES,
+                                     bp_corr_config->bp_abs_dead_thres);
+                       REG_WRITE(mrv_reg->isp_bp_cfg1, isp_bp_cfg1);
+                       REG_SET_SLICE(isp_bp_cfg2, MRV_BP_DEV_HOT_THRES,
+                                     bp_corr_config->bp_dev_hot_thres);
+                       REG_SET_SLICE(isp_bp_cfg2, MRV_BP_DEV_DEAD_THRES,
+                                     bp_corr_config->bp_dev_dead_thres);
+                       REG_WRITE(mrv_reg->isp_bp_cfg2, isp_bp_cfg2);
+               } else {
+                       /* use bad pixel table */
+                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_COR_TYPE,
+                                     MRV_BP_COR_TYPE_TABLE);
+               }
+
+               if (bp_corr_config->bp_corr_rep == CI_ISP_BP_CORR_REP_LIN) {
+                       /* use linear approch */
+                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_REP_APPR,
+                                     MRV_BP_REP_APPR_INTERPOL);
+               } else {
+                       /* use best neighbour */
+                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_REP_APPR,
+                                     MRV_BP_REP_APPR_NEAREST);
+               }
+
+               switch (bp_corr_config->bp_corr_mode) {
+               case CI_ISP_BP_CORR_HOT_EN:
+                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_HOT_COR_EN, ENABLE);
+                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_DEAD_COR_EN, DISABLE);
+                       break;
+               case CI_ISP_BP_CORR_DEAD_EN:
+                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_HOT_COR_EN, DISABLE);
+                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_DEAD_COR_EN, ENABLE);
+                       break;
+               case CI_ISP_BP_CORR_HOT_DEAD_EN:
+               default:
+                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_HOT_COR_EN, ENABLE);
+                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_DEAD_COR_EN, ENABLE);
+                       break;
+               }
+       }
+
+       REG_WRITE(mrv_reg->isp_bp_ctrl, isp_bp_ctrl);
+
+       return CI_STATUS_SUCCESS;
+
+}
+
+/*
+ * Sets the Bad Pixel configuration for detection
+ */
+int ci_isp_set_bp_detection(const struct ci_isp_bp_det_config *bp_det_config)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       if (!bp_det_config) {
+               REG_SET_SLICE(mrv_reg->isp_bp_ctrl, MRV_BP_BP_DET_EN, DISABLE);
+       } else {
+               WARN_ON(!(REG_GET_SLICE(mrv_reg->isp_bp_ctrl, MRV_BP_COR_TYPE)
+                         == MRV_BP_COR_TYPE_TABLE));
+
+               /* set dead threshold for bad pixel detection */
+               REG_SET_SLICE(mrv_reg->isp_bp_cfg1, MRV_BP_DEAD_THRES,
+                             bp_det_config->bp_dead_thres);
+
+               /* enable measurement module */
+               REG_SET_SLICE(mrv_reg->isp_bp_ctrl, MRV_BP_BP_DET_EN, ENABLE);
+       }
+
+       return CI_STATUS_SUCCESS;
+}
+
+int ci_isp_clear_bp_int(void)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       /* clear bp_det irq (only if it is signalled to prevent loss of irqs) */
+       if (REG_GET_SLICE(mrv_reg->isp_ris, MRV_ISP_RIS_BP_DET))
+               REG_SET_SLICE(mrv_reg->isp_icr, MRV_ISP_ICR_BP_DET, 1);
+
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * Initializes Isp filter registers with default reset values.
+ */
+static int ci_isp_initialize_filter_registers(void)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       mrv_reg->isp_filt_mode = 0x00000000;
+       mrv_reg->isp_filt_fac_sh1 = 0x00000010;
+       mrv_reg->isp_filt_fac_sh0 = 0x0000000C;
+       mrv_reg->isp_filt_fac_mid = 0x0000000A;
+       mrv_reg->isp_filt_fac_bl0 = 0x00000006;
+       mrv_reg->isp_filt_fac_bl1 = 0x00000002;
+       mrv_reg->isp_filt_thresh_bl0 = 0x0000000D;
+       mrv_reg->isp_filt_thresh_bl1 = 0x00000005;
+       mrv_reg->isp_filt_thresh_sh0 = 0x0000001A;
+       mrv_reg->isp_filt_thresh_sh1 = 0x0000002C;
+       mrv_reg->isp_filt_lum_weight = 0x00032040;
+
+       return CI_STATUS_SUCCESS;
+}
+
+int ci_isp_activate_filter(int activate_filter)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       int retval = CI_STATUS_SUCCESS;
+
+       /* Initialize ISP filter control registers first */
+       retval = ci_isp_initialize_filter_registers();
+       if (retval != CI_STATUS_SUCCESS)
+               return retval;
+
+       /* Activate or deactivate filter algorythm */
+       REG_SET_SLICE(mrv_reg->isp_filt_mode, MRV_FILT_FILT_ENABLE,
+               (activate_filter) ? ENABLE : DISABLE);
+
+       return retval;
+}
+
+/*
+ * Write coefficient and threshold values into Isp filter
+ * registers for noise, sharpness and blurring filtering.
+ */
+u32 sharp_fac_table[11][5] = {
+       /* fac1_sh1, fac_sh0, fac_mid, fac_bl0, fac_bl1 */
+       {0x00000004, 0x00000004, 0x00000004, 0x00000002, 0x00000000},
+       {0x00000008, 0x00000007, 0x00000006, 0x00000002, 0x00000000},
+       {0x0000000C, 0x0000000A, 0x00000008, 0x00000004, 0x00000000},
+       {0x00000010, 0x0000000C, 0x0000000A, 0x00000006, 0x00000002},
+       {0x00000016, 0x00000010, 0x0000000C, 0x00000008, 0x00000004},
+       {0x0000001B, 0x00000014, 0x00000010, 0x0000000A, 0x00000004},
+       {0x00000020, 0x0000001A, 0x00000013, 0x0000000C, 0x00000006},
+       {0x00000026, 0x0000001E, 0x00000017, 0x00000010, 0x00000008},
+       {0x0000002C, 0x00000024, 0x0000001D, 0x00000015, 0x0000000D},
+       {0x00000030, 0x0000002A, 0x00000022, 0x0000001A, 0x00000014},
+       {0x0000003F, 0x00000030, 0x00000028, 0x00000024, 0x00000020},
+
+};
+
+u32 noise_table[12][7] = {
+       /* sh1, sh0, bl0, bl1, mode, vmode, hmode */
+       {0x000000, 0x000000, 0x000000, 0x000000, 6, 1, 0},
+       {33, 18, 8, 2, 6, 3, 3},
+       {44, 26, 13, 4, 3, 3},
+       {51, 36, 23, 10, 4, 3, 3},
+       {67, 41, 26, 15, 3, 3, 3},
+       {100, 75, 50, 20, 3, 3, 3},
+       {120, 90, 60, 26, 2, 3, 3},
+       {150, 120, 80, 51, 2, 3, 3},
+       {200, 170, 140, 100, 2, 3, 3},
+       {300, 250, 180, 150, 0, 3, 3},
+       {1023, 1023, 1023, 1023, 0, 3, 3},
+       /* noise reduction level 99 */
+       {0x000003FF, 0x000003FF, 0x000003FF, 0x000003FF, 0, 0, 0},
+};
+
+int ci_isp_set_filter_params(u8 noise_reduc_level, u8 sharp_level)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 isp_filt_mode = 0;
+
+       if (!REG_GET_SLICE(mrv_reg->isp_filt_mode, MRV_FILT_FILT_ENABLE))
+               return CI_STATUS_CANCELED;
+
+       REG_WRITE(mrv_reg->isp_filt_mode, isp_filt_mode);
+
+       if (sharp_level > 10)
+               return CI_STATUS_OUTOFRANGE;
+       if (noise_reduc_level != 99 && noise_reduc_level > 10)
+               return CI_STATUS_OUTOFRANGE;
+
+       if (noise_reduc_level == 99) {
+               REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
+                             MRV_FILT_FILT_THRESH_SH1, noise_table[11][0]);
+               REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
+                             MRV_FILT_FILT_THRESH_SH0, noise_table[11][1]);
+               REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
+                             MRV_FILT_FILT_THRESH_BL0, noise_table[11][2]);
+               REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
+                             MRV_FILT_FILT_THRESH_BL1, noise_table[11][3]);
+               REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT,
+                               noise_table[11][4]);
+               REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
+                             noise_table[11][5]);
+               REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
+                             noise_table[11][6]);
+       } else {
+               REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
+                                 MRV_FILT_FILT_THRESH_SH1,
+                                 noise_table[noise_reduc_level][0]);
+               REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
+                                 MRV_FILT_FILT_THRESH_SH0,
+                                 noise_table[noise_reduc_level][1]);
+               REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
+                                 MRV_FILT_FILT_THRESH_BL0,
+                                 noise_table[noise_reduc_level][2]);
+               REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
+                                 MRV_FILT_FILT_THRESH_BL1,
+                                 noise_table[noise_reduc_level][3]);
+               REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT,
+                                 noise_table[noise_reduc_level][4]);
+               REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
+                                 noise_table[noise_reduc_level][5]);
+               REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
+                                 noise_table[noise_reduc_level][6]);
+       }
+
+       if (noise_reduc_level == 9) {
+               REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT,
+                             (sharp_level > 3) ? 2 : 1);
+       }
+
+       if (noise_reduc_level == 10) {
+               REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT,
+                             (sharp_level > 5) ? 2 :
+                             ((sharp_level > 3) ? 1 : 0));
+       }
+
+       /* sharp setting */
+       if (sharp_level == 8) {
+               REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
+                             MRV_FILT_FILT_THRESH_SH0, 0x00000013);
+               if (REG_GET_SLICE(mrv_reg->isp_filt_thresh_sh1,
+                    MRV_FILT_FILT_THRESH_SH1) > 0x0000008A) {
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
+                                     MRV_FILT_FILT_THRESH_SH1,
+                                     0x0000008A);
+               }
+       } else if (sharp_level == 9) {
+               REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
+                             MRV_FILT_FILT_THRESH_SH0, 0x00000013);
+               if (REG_GET_SLICE(mrv_reg->isp_filt_thresh_sh1,
+                       MRV_FILT_FILT_THRESH_SH1) > 0x0000008A) {
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
+                                     MRV_FILT_FILT_THRESH_SH1,
+                                     0x0000008A);
+               }
+       }
+
+       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh1,
+               MRV_FILT_FILT_FAC_SH1, sharp_fac_table[sharp_level][0]);
+       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh0,
+               MRV_FILT_FILT_FAC_SH0, sharp_fac_table[sharp_level][1]);
+       REG_SET_SLICE(mrv_reg->isp_filt_fac_mid,
+               MRV_FILT_FILT_FAC_MID, sharp_fac_table[sharp_level][2]);
+       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
+               MRV_FILT_FILT_FAC_BL0, sharp_fac_table[sharp_level][3]);
+       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
+               MRV_FILT_FILT_FAC_BL1, sharp_fac_table[sharp_level][4]);
+
+       if (noise_reduc_level > 7) {
+               if (sharp_level > 7) {
+                       u32 filt_fac_bl0 = REG_GET_SLICE
+                               (mrv_reg->isp_filt_fac_bl0,
+                               MRV_FILT_FILT_FAC_BL0);
+                       u32 filt_fac_bl1 =
+                           REG_GET_SLICE(mrv_reg->isp_filt_fac_bl1,
+                               MRV_FILT_FILT_FAC_BL1);
+                       /* * 0.50 */
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
+                               MRV_FILT_FILT_FAC_BL0,
+                               (filt_fac_bl0) >> 1);
+                       /* * 0.25 */
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
+                               MRV_FILT_FILT_FAC_BL1,
+                               (filt_fac_bl1) >> 2);
+               } else if (sharp_level > 4) {
+                       u32 filt_fac_bl0 =
+                           REG_GET_SLICE(mrv_reg->isp_filt_fac_bl0,
+                               MRV_FILT_FILT_FAC_BL0);
+                       u32 filt_fac_bl1 =
+                           REG_GET_SLICE(mrv_reg->
+                                         isp_filt_fac_bl1,
+                                         MRV_FILT_FILT_FAC_BL1);
+                       /* * 0.75 */
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
+                               MRV_FILT_FILT_FAC_BL0,
+                               (filt_fac_bl0 * 3) >> 2);
+                       /* * 0.50 */
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
+                               MRV_FILT_FILT_FAC_BL1,
+                               (filt_fac_bl1) >> 1);
+               }
+       }
+
+       /* Set ISP filter mode register values */
+       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_MODE,
+                     MRV_FILT_FILT_MODE_DYNAMIC);
+
+       /* enable filter */
+       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_ENABLE, ENABLE);
+       REG_WRITE(mrv_reg->isp_filt_mode, isp_filt_mode);
+
+       return CI_STATUS_SUCCESS;
+}
+
+int ci_isp_meas_exposure_initialize_module(void)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       REG_SET_SLICE(mrv_reg->isp_exp_h_size, MRV_AE_ISP_EXP_H_SIZE, 0);
+       REG_SET_SLICE(mrv_reg->isp_exp_v_size, MRV_AE_ISP_EXP_V_SIZE, 0);
+       REG_SET_SLICE(mrv_reg->isp_exp_h_offset, MRV_AE_ISP_EXP_H_OFFSET, 0);
+       REG_SET_SLICE(mrv_reg->isp_exp_v_offset, MRV_AE_ISP_EXP_V_OFFSET, 0);
+
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * Configures the exposure measurement module.
+ */
+int ci_isp_meas_exposure_set_config(const struct ci_isp_window *wnd,
+                                   const struct ci_isp_exp_ctrl *isp_exp_ctrl)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       if (!wnd) {
+               REG_SET_SLICE(mrv_reg->isp_exp_ctrl, MRV_AE_AUTOSTOP, ON);
+               REG_SET_SLICE(mrv_reg->isp_exp_ctrl, MRV_AE_EXP_START, OFF);
+               return CI_STATUS_SUCCESS;
+       }
+
+       /* range check */
+       if ((wnd->hoffs > MRV_AE_ISP_EXP_H_OFFSET_MAX)
+           || (wnd->hsize > MRV_AE_ISP_EXP_H_SIZE_MAX)
+           || (wnd->voffs > MRV_AE_ISP_EXP_V_OFFSET_MAX)
+           || (wnd->vsize > MRV_AE_ISP_EXP_V_SIZE_MAX)
+           || (wnd->vsize & ~MRV_AE_ISP_EXP_V_SIZE_VALID_MASK))
+               return CI_STATUS_OUTOFRANGE;
+
+       /* configure measurement windows */
+       REG_SET_SLICE(mrv_reg->isp_exp_h_size, MRV_AE_ISP_EXP_H_SIZE,
+                     wnd->hsize);
+       REG_SET_SLICE(mrv_reg->isp_exp_v_size, MRV_AE_ISP_EXP_V_SIZE,
+                     wnd->vsize);
+       REG_SET_SLICE(mrv_reg->isp_exp_h_offset, MRV_AE_ISP_EXP_H_OFFSET,
+                     wnd->hoffs);
+       REG_SET_SLICE(mrv_reg->isp_exp_v_offset, MRV_AE_ISP_EXP_V_OFFSET,
+                     wnd->voffs);
+
+       /* set exposure measurement mode */
+       REG_SET_SLICE(mrv_reg->isp_exp_ctrl, MRV_AE_EXP_MEAS_MODE,
+               (isp_exp_ctrl->exp_meas_mode) ? ON : OFF);
+
+       /* set or clear AE autostop bit */
+       REG_SET_SLICE(mrv_reg->isp_exp_ctrl, MRV_AE_AUTOSTOP,
+                     (isp_exp_ctrl->auto_stop) ? ON : OFF);
+       REG_SET_SLICE(mrv_reg->isp_exp_ctrl, MRV_AE_EXP_START,
+                     (isp_exp_ctrl->exp_start) ? ON : OFF);
+
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * Programs the given gamma curve for the input gamma
+ * block. Enables or disables gamma processing for the
+ * input gamma block.
+ */
+void ci_isp_set_gamma(const struct ci_sensor_gamma_curve *r,
+                     const struct ci_sensor_gamma_curve *g,
+                     const struct ci_sensor_gamma_curve *b)
+{
+       struct isp_register *mrv_reg = (struct isp_register *)MEM_MRV_REG_BASE;
+       const u8 shift_val = 16 - 12 /*MARVIN_FEATURE_CAMBUSWIDTH*/;
+       const u16 round_ofs = 0 << (shift_val - 1);
+       s32 i;
+
+       if (r) {
+               REG_WRITE(mrv_reg->isp_gamma_dx_lo, r->gamma_dx0);
+               REG_WRITE(mrv_reg->isp_gamma_dx_hi, r->gamma_dx1);
+
+               for (i = 0; i < MRV_ISP_GAMMA_R_Y_ARR_SIZE; i++) {
+                       REG_SET_SLICE(mrv_reg->isp_gamma_r_y[i],
+                             MRV_ISP_GAMMA_R_Y,
+                             (r->isp_gamma_y[i] + round_ofs) >> shift_val);
+                       REG_SET_SLICE(mrv_reg->isp_gamma_g_y[i],
+                             MRV_ISP_GAMMA_G_Y,
+                             (g->isp_gamma_y[i] + round_ofs) >> shift_val);
+                       REG_SET_SLICE(mrv_reg->isp_gamma_b_y[i],
+                             MRV_ISP_GAMMA_B_Y,
+                             (b->isp_gamma_y[i] + round_ofs) >> shift_val);
+               }
+
+               REG_SET_SLICE(mrv_reg->isp_ctrl,
+               MRV_ISP_ISP_GAMMA_IN_ENABLE, ENABLE);
+       } else {
+               REG_SET_SLICE(mrv_reg->isp_ctrl,
+               MRV_ISP_ISP_GAMMA_IN_ENABLE, DISABLE);
+       }
+}
+
+/*
+ * Programs the given gamma curve for the output gamma
+ * block. Enables or disables gamma processing for the
+ * output gamma block.
+ */
+void ci_isp_set_gamma2(const struct ci_isp_gamma_out_curve *gamma)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       s32 i;
+
+       if (gamma) {
+               WARN_ON(!(MRV_ISP_GAMMA_OUT_Y_ARR_SIZE ==
+                       CI_ISP_GAMMA_OUT_CURVE_ARR_SIZE));
+
+               for (i = 0; i < MRV_ISP_GAMMA_OUT_Y_ARR_SIZE; i++) {
+                       REG_SET_SLICE(mrv_reg->isp_gamma_out_y[i],
+                                     MRV_ISP_ISP_GAMMA_OUT_Y,
+                                     gamma->isp_gamma_y[i]);
+               }
+
+               REG_SET_SLICE(mrv_reg->isp_gamma_out_mode, MRV_ISP_EQU_SEGM,
+                             gamma->gamma_segmentation);
+               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_GAMMA_OUT_ENABLE,
+                             ENABLE);
+       } else {
+               REG_SET_SLICE(mrv_reg->isp_ctrl,
+               MRV_ISP_ISP_GAMMA_OUT_ENABLE, DISABLE);
+       }
+
+}
--
1.6.3.2

