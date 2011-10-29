Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:60406 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933373Ab1J2Ovq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Oct 2011 10:51:46 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p9TEpfhn031779
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 29 Oct 2011 09:51:43 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Nagabhushana Netagunte <nagabhushana.netagunte@ti.com>
Subject: [RFC PATCH v3 3/8] davinci: vpfe: add IPIPE support for media controller driver
Date: Sat, 29 Oct 2011 20:21:27 +0530
Message-ID: <1319899892-19658-4-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1319899892-19658-1-git-send-email-manjunath.hadli@ti.com>
References: <1319899892-19658-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the IPIPE interfacing layer to the vpfe driver. This patch adds dm365
specific implementation of the genric imp_hw_interface interface for
programming the IPIPE block, mainly setting the resizer and previewer
configuration parameters. This is built as an independent module.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Nagabhushana Netagunte <nagabhushana.netagunte@ti.com>
---
 drivers/media/video/davinci/dm365_def_para.c |  334 +++
 drivers/media/video/davinci/dm365_def_para.h |   39 +
 drivers/media/video/davinci/dm365_ipipe.c    | 4034 ++++++++++++++++++++++++++
 drivers/media/video/davinci/dm365_ipipe.h    |  395 +++
 drivers/media/video/davinci/imp_common.h     |   81 +
 drivers/media/video/davinci/imp_hw_if.h      |  184 ++
 6 files changed, 5067 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/davinci/dm365_def_para.c
 create mode 100644 drivers/media/video/davinci/dm365_def_para.h
 create mode 100644 drivers/media/video/davinci/dm365_ipipe.c
 create mode 100644 drivers/media/video/davinci/dm365_ipipe.h
 create mode 100644 drivers/media/video/davinci/imp_common.h
 create mode 100644 drivers/media/video/davinci/imp_hw_if.h

diff --git a/drivers/media/video/davinci/dm365_def_para.c b/drivers/media/video/davinci/dm365_def_para.c
new file mode 100644
index 0000000..9f95414
--- /dev/null
+++ b/drivers/media/video/davinci/dm365_def_para.c
@@ -0,0 +1,334 @@
+/*
+* Copyright (C) 2011 Texas Instruments Inc
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation version 2.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+*/
+#include <linux/v4l2-mediabus.h>
+#include <media/davinci/vpfe.h>
+#include "dm365_ipipe.h"
+
+/* Defaults for lutdpc */
+struct prev_lutdpc dm365_lutdpc_defaults;
+
+/* Defaults for otfdpc */
+struct prev_lutdpc dm365_otfdpc_defaults;
+
+/* Defaults for 2D - nf */
+struct prev_nf dm365_nf_defaults;
+
+/* defaults for GIC */
+struct prev_gic dm365_gic_defaults;
+
+/* Defaults for white balance */
+struct prev_wb dm365_wb_defaults = {
+	.gain_r = {2, 0x00},
+	.gain_gr = {2, 0x00},
+	.gain_gb = {2, 0x00},
+	.gain_b = {2, 0x00}
+};
+
+/* Defaults for CFA */
+struct prev_cfa dm365_cfa_defaults = {
+	.alg = IPIPE_CFA_ALG_2DIRAC,
+};
+
+/* Defaults for rgb2rgb */
+struct prev_rgb2rgb dm365_rgb2rgb_defaults = {
+	.coef_rr = {1, 0},	/* 256 */
+	.coef_gr = {0, 0},
+	.coef_br = {0, 0},
+	.coef_rg = {0, 0},
+	.coef_gg = {1, 0},	/* 256 */
+	.coef_bg = {0, 0},
+	.coef_rb = {0, 0},
+	.coef_gb = {0, 0},
+	.coef_bb = {1, 0},	/* 256 */
+};
+
+/* Defaults for gamma correction */
+struct prev_gamma dm365_gamma_defaults = {
+	.tbl_sel = IPIPE_GAMMA_TBL_ROM
+};
+
+/* Defaults for 3d lut */
+struct prev_3d_lut dm365_3d_lut_defaults;
+
+/* Defaults for lumina adjustments */
+struct prev_lum_adj dm365_lum_adj_defaults = {
+	.contrast = 16
+};
+
+/* Defaults for rgb2yuv conversion */
+struct prev_rgb2yuv dm365_rgb2yuv_defaults = {
+	.coef_ry = {0, 0x4d},
+	.coef_gy = {0, 0x96},
+	.coef_by = {0, 0x1d},
+	.coef_rcb = {0xf, 0xd5},
+	.coef_gcb = {0xf, 0xab},
+	.coef_bcb = {0, 0x80},
+	.coef_rcr = {0, 0x80},
+	.coef_gcr = {0xf, 0x95},
+	.coef_bcr = {0xf, 0xeb},
+	.out_ofst_y = 0,
+	.out_ofst_cb = 0x80,
+	.out_ofst_cr = 0x80
+};
+
+/* Defaults for GBCE */
+struct prev_gbce dm365_gbce_defaults;
+
+/* Defaults for yuv 422 conversion */
+struct prev_yuv422_conv dm365_yuv422_conv_defaults = {
+	.chrom_pos = IPIPE_YUV422_CHR_POS_COSITE
+};
+
+/* Defaults for Edge Ehnancements  */
+struct prev_yee dm365_yee_defaults;
+
+/* Defaults for CAR conversion */
+struct prev_car dm365_car_defaults;
+
+/* Defaults for CGS */
+struct prev_cgs dm365_cgs_defaults;
+
+#define  WIDTH_I 640
+#define  HEIGHT_I 480
+#define  WIDTH_O 640
+#define  HEIGHT_O 480
+
+/* default ipipeif settings */
+struct ipipeif_5_1 ipipeif_5_1_defaults = {
+	.pack_mode = IPIPEIF_5_1_PACK_16_BIT,
+	.data_shift = IPIPEIF_BITS11_0,
+	.source1 = IPIPEIF_SRC1_PARALLEL_PORT,
+	.clk_div = {
+		.m = 1,	/* clock = sdram clock * (m/n) */
+		.n = 6
+	},
+	.dpcm = {
+		.type = IPIPEIF_DPCM_8BIT_12BIT,
+		.pred = IPIPEIF_DPCM_SIMPLE_PRED
+	},
+	.pix_order = IPIPEIF_CBCR_Y,
+	.isif_port = {
+		.if_type = V4L2_MBUS_FMT_SBGGR10_1X10,
+		.hdpol = VPFE_PINPOL_POSITIVE,
+		.vdpol = VPFE_PINPOL_POSITIVE
+	},
+	.clip = 4095,
+};
+
+struct ipipe_params dm365_ipipe_defs = {
+	.ipipeif_param = {
+		.mode = IPIPEIF_ONE_SHOT,
+		.source = IPIPEIF_SDRAM_RAW,
+		.clock_select = IPIPEIF_SDRAM_CLK,
+		.glob_hor_size = WIDTH_I + 8,
+		.glob_ver_size = HEIGHT_I + 10,
+		.hnum = WIDTH_I,
+		.vnum = HEIGHT_I,
+		.adofs = WIDTH_I * 2,
+		.rsz = 16,	/* resize ratio 16/rsz */
+		.decimation = IPIPEIF_DECIMATION_OFF,
+		.avg_filter = IPIPEIF_AVG_OFF,
+		.gain = 0x200,	/* U10Q9 */
+	},
+	.ipipe_mode = IPIPEIF_ONE_SHOT,
+	.ipipe_dpaths_fmt = IPIPE_RAW2YUV,
+	.ipipe_colpat_olop = IPIPE_GREEN_BLUE,
+	.ipipe_colpat_olep = IPIPE_BLUE,
+	.ipipe_colpat_elop = IPIPE_RED,
+	.ipipe_colpat_elep = IPIPE_GREEN_RED,
+	.ipipe_vsz = HEIGHT_I - 1,
+	.ipipe_hsz = WIDTH_I - 1,
+	.rsz_common = {
+		.vsz = HEIGHT_I - 1,
+		.hsz = WIDTH_I - 1,
+		.src_img_fmt = RSZ_IMG_422,
+		.raw_flip = 1,	/* flip preserve Raw format */
+		.source = IPIPE_DATA,
+		.passthrough = IPIPE_BYPASS_OFF,
+		.yuv_y_max = 255,
+		.yuv_c_max = 255,
+		.rsz_seq_crv = DISABLE,
+		.out_chr_pos = IPIPE_YUV422_CHR_POS_COSITE
+	},
+	.rsz_rsc_param = {
+		{
+			.mode = IPIPEIF_ONE_SHOT,
+			.h_flip = DISABLE,
+			.v_flip = DISABLE,
+			.cen = DISABLE,
+			.yen = DISABLE,
+			.o_vsz = HEIGHT_O - 1,
+			.o_hsz = WIDTH_O - 1,
+			.v_dif = 256,
+			.v_typ_y = RSZ_INTP_CUBIC,
+			.h_typ_c = RSZ_INTP_CUBIC,
+			.h_dif = 256,
+			.h_typ_y = RSZ_INTP_CUBIC,
+			.h_typ_c = RSZ_INTP_CUBIC,
+			.h_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+			.v_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+		},
+		{
+			.mode = IPIPEIF_ONE_SHOT,
+			.h_flip = DISABLE,
+			.v_flip = DISABLE,
+			.cen = DISABLE,
+			.yen = DISABLE,
+			.o_vsz = HEIGHT_O - 1,
+			.o_hsz = WIDTH_O - 1,
+			.v_dif = 256,
+			.v_typ_y = RSZ_INTP_CUBIC,
+			.h_typ_c = RSZ_INTP_CUBIC,
+			.h_dif = 256,
+			.h_typ_y = RSZ_INTP_CUBIC,
+			.h_typ_c = RSZ_INTP_CUBIC,
+			.h_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+			.v_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+		},
+	},
+	.rsz2rgb = {
+		{
+			.rgb_en = DISABLE
+		},
+		{
+			.rgb_en = DISABLE
+		}
+	},
+	.ext_mem_param = {
+		{
+			.rsz_sdr_oft_y = WIDTH_O << 1,
+			.rsz_sdr_ptr_e_y = HEIGHT_O,
+			.rsz_sdr_oft_c = WIDTH_O,
+			.rsz_sdr_ptr_e_c = HEIGHT_O >> 1,
+		},
+		{
+			.rsz_sdr_oft_y = WIDTH_O << 1,
+			.rsz_sdr_ptr_e_y = HEIGHT_O,
+			.rsz_sdr_oft_c = WIDTH_O,
+			.rsz_sdr_ptr_e_c = HEIGHT_O,
+		},
+	},
+	.rsz_en[0] = ENABLE,
+	.rsz_en[1] = DISABLE
+};
+
+struct prev_single_shot_config dm365_prev_ss_config_defs = {
+	.bypass = IPIPE_BYPASS_OFF,
+	.input = {
+		.image_width = WIDTH_I,
+		.image_height = HEIGHT_I,
+		.ppln = WIDTH_I + 8,
+		.lpfr = HEIGHT_I + 10,
+		.pred = IPIPEIF_DPCM_SIMPLE_PRED,
+		.clk_div = {1, 6},
+		.data_shift = IPIPEIF_BITS11_0,
+		.rsz = 16,	/* resize ratio 16/rsz */
+		.avg_filter_en = IPIPEIF_AVG_OFF,
+		.dpc = {0, 0},
+		.gain = 512,
+		.clip = 4095,
+		.pix_fmt = V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
+		.colp_olop = IPIPE_GREEN_BLUE,
+		.colp_olep = IPIPE_BLUE,
+		.colp_elop = IPIPE_RED,
+		.colp_elep = IPIPE_GREEN_RED
+	},
+	.output = {
+		.pix_fmt = V4L2_MBUS_FMT_UYVY8_1X16
+	}
+};
+
+struct prev_continuous_config dm365_prev_cont_config_defs = {
+	.bypass = IPIPE_BYPASS_OFF,
+	.input = {
+		.rsz = 16,
+		.avg_filter_en = IPIPEIF_AVG_OFF,
+		.gain = 512,
+		.clip = 4095,
+		.colp_olop = IPIPE_GREEN_BLUE,
+		.colp_olep = IPIPE_BLUE,
+		.colp_elop = IPIPE_RED,
+		.colp_elep = IPIPE_GREEN_RED
+	},
+};
+
+struct rsz_single_shot_config dm365_rsz_ss_config_defs = {
+	.input = {
+		.image_width = WIDTH_I,
+		.image_height = HEIGHT_I,
+		.ppln = WIDTH_I + 8,
+		.lpfr = HEIGHT_I + 10,
+		.clk_div = {1, 6},
+		.rsz = 16,	/* resize ratio 16/rsz */
+		.avg_filter_en = IPIPEIF_AVG_OFF,
+		.pix_fmt = V4L2_MBUS_FMT_UYVY8_1X16
+	},
+	.output1 = {
+		.enable = 1,
+		.pix_fmt = V4L2_MBUS_FMT_UYVY8_1X16,
+		.width = WIDTH_O,
+		.height = HEIGHT_O,
+		.v_typ_y = RSZ_INTP_CUBIC,
+		.v_typ_c = RSZ_INTP_CUBIC,
+		.h_typ_y = RSZ_INTP_CUBIC,
+		.h_typ_c = RSZ_INTP_CUBIC,
+		.h_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+		.v_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+	},
+	.output2 = {
+		.enable = 1,
+		.pix_fmt = V4L2_MBUS_FMT_UYVY8_1X16,
+		.width = WIDTH_O,
+		.height = HEIGHT_O,
+		.v_typ_y = RSZ_INTP_CUBIC,
+		.v_typ_c = RSZ_INTP_CUBIC,
+		.h_typ_y = RSZ_INTP_CUBIC,
+		.h_typ_c = RSZ_INTP_CUBIC,
+		.h_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+		.v_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+	},
+	.yuv_y_max = 255,
+	.yuv_c_max = 255,
+	.out_chr_pos = IPIPE_YUV422_CHR_POS_COSITE,
+};
+
+struct rsz_continuous_config dm365_rsz_cont_config_defs = {
+	.output1 = {
+		.enable = 1,
+		.v_typ_y = RSZ_INTP_CUBIC,
+		.v_typ_c = RSZ_INTP_CUBIC,
+		.h_typ_y = RSZ_INTP_CUBIC,
+		.h_typ_c = RSZ_INTP_CUBIC,
+		.h_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+		.v_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+	},
+	.output2 = {
+		.enable = 1,
+		.pix_fmt = V4L2_MBUS_FMT_UYVY8_1X16,
+		.width = WIDTH_O,
+		.height = HEIGHT_O,
+		.v_typ_y = RSZ_INTP_CUBIC,
+		.v_typ_c = RSZ_INTP_CUBIC,
+		.h_typ_y = RSZ_INTP_CUBIC,
+		.h_typ_c = RSZ_INTP_CUBIC,
+		.h_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+		.v_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+	},
+	.yuv_y_max = 255,
+	.yuv_c_max = 255,
+	.out_chr_pos = IPIPE_YUV422_CHR_POS_COSITE,
+};
diff --git a/drivers/media/video/davinci/dm365_def_para.h b/drivers/media/video/davinci/dm365_def_para.h
new file mode 100644
index 0000000..872b3cb
--- /dev/null
+++ b/drivers/media/video/davinci/dm365_def_para.h
@@ -0,0 +1,39 @@
+/*
+ * Copyright (C) 2011 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+#include "dm365_ipipe.h"
+extern struct prev_lutdpc dm365_lutdpc_defaults;
+extern struct prev_otfdpc dm365_otfdpc_defaults;
+extern struct prev_nf dm365_nf_defaults;
+extern struct prev_gic dm365_gic_defaults;
+extern struct prev_wb dm365_wb_defaults;
+extern struct prev_cfa dm365_cfa_defaults;
+extern struct prev_rgb2rgb dm365_rgb2rgb_defaults;
+extern struct prev_gamma dm365_gamma_defaults;
+extern struct prev_3d_lut dm365_3d_lut_defaults;
+extern struct prev_lum_adj dm365_lum_adj_defaults;
+extern struct prev_rgb2yuv dm365_rgb2yuv_defaults;
+extern struct prev_yuv422_conv dm365_yuv422_conv_defaults;
+extern struct prev_gbce dm365_gbce_defaults;
+extern struct prev_yee dm365_yee_defaults;
+extern struct prev_car dm365_car_defaults;
+extern struct prev_cgs dm365_cgs_defaults;
+extern struct ipipe_params dm365_ipipe_defs;
+extern struct prev_single_shot_config dm365_prev_ss_config_defs;
+extern struct prev_continuous_config dm365_prev_cont_config_defs;
+extern struct rsz_single_shot_config dm365_rsz_ss_config_defs;
+extern struct rsz_continuous_config dm365_rsz_cont_config_defs;
+extern struct ipipeif_5_1 ipipeif_5_1_defaults;
diff --git a/drivers/media/video/davinci/dm365_ipipe.c b/drivers/media/video/davinci/dm365_ipipe.c
new file mode 100644
index 0000000..4ec8604
--- /dev/null
+++ b/drivers/media/video/davinci/dm365_ipipe.c
@@ -0,0 +1,4034 @@
+/*
+* Copyright (C) 2011 Texas Instruments Inc
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation version 2.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+*/
+
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/dma-mapping.h>
+#include <linux/uaccess.h>
+#include <linux/mutex.h>
+#include <linux/device.h>
+#include <linux/videodev2.h>
+#include <linux/v4l2-mediabus.h>
+#include <media/davinci/vpfe.h>
+#include "dm365_ipipe.h"
+#include "imp_hw_if.h"
+
+#include "dm365_ipipe_hw.h"
+#include "dm365_def_para.h"
+
+static int ipipe_enum_pix(void *ipipe, u32 *pix, int i)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	if (i >= ARRAY_SIZE(oper_state->ipipe_raw_yuv_pix_formats))
+		return -EINVAL;
+
+	*pix = oper_state->ipipe_raw_yuv_pix_formats[i];
+	return 0;
+}
+
+/* IPIPE hardware limits */
+#define IPIPE_MAX_OUTPUT_WIDTH_A	2176
+#define IPIPE_MAX_OUTPUT_WIDTH_B	640
+
+static int ipipe_get_max_output_width(int rsz)
+{
+	if (rsz == RSZ_A)
+		return IPIPE_MAX_OUTPUT_WIDTH_A;
+	return IPIPE_MAX_OUTPUT_WIDTH_B;
+}
+
+/* Based on max resolution supported. QXGA */
+#define IPIPE_MAX_OUTPUT_HEIGHT_A	1536
+/* Based on max resolution supported. VGA */
+#define IPIPE_MAX_OUTPUT_HEIGHT_B	480
+
+static int ipipe_get_max_output_height(int rsz)
+{
+	if (rsz == RSZ_A)
+		return IPIPE_MAX_OUTPUT_HEIGHT_A;
+	return IPIPE_MAX_OUTPUT_HEIGHT_B;
+}
+
+static int ipipe_serialize(void *ipipe)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return oper_state->en_serializer;
+}
+
+static int ipipe_set_ipipe_if_address(void *ipipe, void *config, u32 address)
+{
+	struct ipipeif *if_params;
+
+	if (!config)
+		return -EINVAL;
+
+	if_params = &((struct ipipe_params *)config)->ipipeif_param;
+
+	return ipipeif_set_address(if_params, address);
+}
+
+static void ipipe_lock_chain(void *ipipe)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	mutex_lock(&oper_state->lock);
+	oper_state->resource_in_use = 1;
+	mutex_unlock(&oper_state->lock);
+}
+
+static void ipipe_unlock_chain(void *ipipe)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	mutex_lock(&oper_state->lock);
+	oper_state->resource_in_use = 0;
+	oper_state->prev_config_state = STATE_NOT_CONFIGURED;
+	oper_state->rsz_config_state = STATE_NOT_CONFIGURED;
+	oper_state->rsz_chained = 0;
+	mutex_unlock(&oper_state->lock);
+}
+static int ipipe_process_pix_fmts(enum v4l2_mbus_pixelcode in_pix_fmt,
+				  enum v4l2_mbus_pixelcode out_pix_fmt,
+				  struct ipipe_params *param)
+{
+	enum v4l2_mbus_pixelcode temp_pix_fmt;
+
+	switch (in_pix_fmt) {
+	case V4L2_MBUS_FMT_SBGGR8_1X8:
+		temp_pix_fmt = V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE;
+		param->ipipeif_param.var.if_5_1.pack_mode
+		    = IPIPEIF_5_1_PACK_8_BIT;
+		break;
+	case V4L2_MBUS_FMT_SRGGB10_ALAW8_1X8:
+		param->ipipeif_param.var.if_5_1.pack_mode
+		    = IPIPEIF_5_1_PACK_8_BIT_A_LAW;
+		temp_pix_fmt = V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE;
+		break;
+	case V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8:
+		param->ipipeif_param.var.if_5_1.pack_mode
+		    = IPIPEIF_5_1_PACK_8_BIT;
+		param->ipipeif_param.var.if_5_1.dpcm.en = 1;
+		temp_pix_fmt = V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE;
+		break;
+	case V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE:
+		param->ipipeif_param.var.if_5_1.pack_mode
+		    = IPIPEIF_5_1_PACK_16_BIT;
+		temp_pix_fmt = V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE;
+		break;
+	case V4L2_MBUS_FMT_SBGGR12_1X12:
+		param->ipipeif_param.var.if_5_1.pack_mode
+		    = IPIPEIF_5_1_PACK_12_BIT;
+		temp_pix_fmt = V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE;
+		break;
+	default:
+		temp_pix_fmt = V4L2_MBUS_FMT_UYVY8_1X16;
+	}
+
+	if (temp_pix_fmt == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE) {
+		if (out_pix_fmt == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE)
+			param->ipipe_dpaths_fmt = IPIPE_RAW2RAW;
+		else if ((out_pix_fmt == V4L2_MBUS_FMT_UYVY8_1X16) ||
+			 (out_pix_fmt == V4L2_MBUS_FMT_YUV420SP8_1X8))
+			param->ipipe_dpaths_fmt = IPIPE_RAW2YUV;
+		else
+			return -EINVAL;
+	} else if (temp_pix_fmt == V4L2_MBUS_FMT_UYVY8_1X16) {
+		if (out_pix_fmt == V4L2_MBUS_FMT_UYVY8_1X16)
+			param->ipipe_dpaths_fmt = IPIPE_YUV2YUV;
+		else if (out_pix_fmt == V4L2_MBUS_FMT_YUV420SP8_1X8)
+			param->ipipe_dpaths_fmt = IPIPE_YUV2YUV;
+		else
+			return -EINVAL;
+	}
+	return 0;
+}
+
+/*
+ * calculate_resize_ratios()
+ *   calculates resize ratio for resizer A or B. This is called after setting
+ * the input size or output size
+ */
+static void calculate_resize_ratios(struct ipipe_params *param, int index)
+{
+	param->rsz_rsc_param[index].h_dif =
+	    ((param->ipipe_hsz + 1) * 256) /
+	    (param->rsz_rsc_param[index].o_hsz + 1);
+	param->rsz_rsc_param[index].v_dif =
+	    ((param->ipipe_vsz + 1) * 256) /
+	    (param->rsz_rsc_param[index].o_vsz + 1);
+}
+
+static int ipipe_do_hw_setup(void *ipipe, struct device *dev, void *config)
+{
+	struct ipipe_params *param = (struct ipipe_params *)config;
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	int ret;
+
+	dev_dbg(dev, "ipipe_do_hw_setup\n");
+	ret = mutex_lock_interruptible(&oper_state->lock);
+	if (ret)
+		return ret;
+
+	if (!config && (oper_state->oper_mode == IMP_MODE_CONTINUOUS)) {
+		/* continuous mode */
+		param = oper_state->shared_config_param;
+		if (param->rsz_en[RSZ_A])
+			calculate_resize_ratios(param, RSZ_A);
+		if (param->rsz_en[RSZ_B])
+			calculate_resize_ratios(param, RSZ_B);
+		ret = ipipe_hw_setup(param);
+	}
+	mutex_unlock(&oper_state->lock);
+
+	return ret;
+}
+
+static unsigned int ipipe_rsz_chain_state(void *ipipe)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return oper_state->rsz_chained;
+}
+
+static void ipipe_update_outbuf1_address(void *ipipe,
+					 void *config, unsigned int address)
+
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	if (!config && (oper_state->oper_mode == IMP_MODE_CONTINUOUS))
+		rsz_set_output_address(oper_state->shared_config_param,
+				       0,
+				       address);
+	else
+		rsz_set_output_address((struct ipipe_params *)config,
+				       0,
+				       address);
+}
+
+static void ipipe_update_outbuf2_address(void *ipipe,
+					 void *config, unsigned int address)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	if (!config && (oper_state->oper_mode == IMP_MODE_CONTINUOUS))
+		rsz_set_output_address(oper_state->shared_config_param,
+				       1,
+				       address);
+	else
+		rsz_set_output_address((struct ipipe_params *)config,
+				       1,
+				       address);
+}
+
+static void ipipe_enable(void *ipipe, unsigned char en, void *config)
+{
+	struct ipipe_params *param = (struct ipipe_params *)config;
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	unsigned char ret = 0;
+
+	if (en)
+		en = !!en;
+
+	if (oper_state->oper_mode == IMP_MODE_CONTINUOUS)
+		param = oper_state->shared_config_param;
+
+	if (en && param->rsz_common.source == IPIPE_DATA) {
+		/* wait for IPIPE to become inactive */
+		do {
+			ret = regr_ip(IPIPE_SRC_EN);
+		} while (ret);
+
+		regw_ip(en, IPIPE_SRC_EN);
+	} else {
+		regw_ip(0, IPIPE_SRC_EN);
+	}
+
+	if (en) {
+		/* wait for RSZ_SRC_EN to be reset by hardware */
+		do {
+			ret = regr_rsz(RSZ_SRC_EN);
+		} while (ret);
+	}
+
+	if (param->rsz_en[RSZ_A]) {
+		if (en) {
+			/* wait for RSZ-A to become inactive */
+			do {
+				ret = regr_rsz(RSZ_A);
+			} while (ret);
+		}
+
+		rsz_enable(RSZ_A, en);
+	}
+	if (param->rsz_en[RSZ_B]) {
+		if (en) {
+			/* wait for RSZ-B to become inactive */
+			do {
+				ret = regr_rsz(RSZ_B);
+			} while (ret);
+		}
+
+		rsz_enable(RSZ_B, en);
+	}
+	if (oper_state->oper_mode == IMP_MODE_SINGLE_SHOT) {
+		/* wait for IPIPEIF ENABLE.ENABLE to be reset by hardware */
+		if (en) {
+			do {
+				ret = ipipeif_get_enable();
+			} while (ret & 0x1);
+		}
+
+		ipipeif_set_enable(en, oper_state->oper_mode);
+	}
+}
+
+static int validate_lutdpc_params(struct ipipe_oper_state *oper_state,
+					struct device *dev)
+{
+	int i;
+
+	if (oper_state->lutdpc.en > 1 ||
+	    oper_state->lutdpc.repl_white > 1 ||
+	    oper_state->lutdpc.dpc_size > LUT_DPC_MAX_SIZE)
+		return -EINVAL;
+	if (oper_state->lutdpc.en && !oper_state->lutdpc.table)
+		return -EINVAL;
+	for (i = 0; i < oper_state->lutdpc.dpc_size; i++) {
+		if (oper_state->lutdpc.table[i].horz_pos > LUT_DPC_H_POS_MASK ||
+		    oper_state->lutdpc.table[i].vert_pos > LUT_DPC_V_POS_MASK)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+static int set_lutdpc_params(struct device *dev, void *ipipe, void *param,
+						int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct ipipe_lutdpc_entry *temp_lutdpc;
+	struct prev_lutdpc dpc_param;
+
+	if (!param) {
+		/* Copy defaults for dfc */
+		temp_lutdpc = oper_state->lutdpc.table;
+		memcpy((void *)&oper_state->lutdpc,
+		       (void *)&dm365_lutdpc_defaults,
+		       sizeof(struct prev_lutdpc));
+		oper_state->lutdpc.table = temp_lutdpc;
+		goto success;
+	}
+
+	if (len != sizeof(struct prev_lutdpc)) {
+		dev_err(dev,
+			"set_lutdpc_params: param struct length"
+			" mismatch\n");
+		return -EINVAL;
+	}
+	if (copy_from_user(&dpc_param,
+			    (struct prev_lutdpc *)param,
+			    sizeof(struct prev_lutdpc))) {
+		dev_err(dev,
+			"set_lutdpc_params: Error in copy to kernel\n");
+		return -EFAULT;
+	}
+
+	if (!dpc_param.table) {
+		dev_err(dev, "Invalid user dpc table ptr\n");
+		return -EINVAL;
+	}
+	oper_state->lutdpc.en = dpc_param.en;
+	oper_state->lutdpc.repl_white = dpc_param.repl_white;
+	oper_state->lutdpc.dpc_size = dpc_param.dpc_size;
+	if (copy_from_user
+		(oper_state->lutdpc.table,
+		(struct ipipe_dpc_entry *)dpc_param.table,
+		(oper_state->lutdpc.dpc_size *
+		sizeof(struct ipipe_lutdpc_entry)))) {
+		dev_err(dev,
+			"set_lutdpc_params: Error in copying "
+			"dfc table to kernel\n");
+		return -EFAULT;
+	}
+
+	if (validate_lutdpc_params(oper_state, dev) < 0)
+		return -EINVAL;
+
+
+success:
+	ipipe_set_lutdpc_regs(&oper_state->lutdpc);
+
+	return 0;
+}
+
+static int get_lutdpc_params(struct device *dev, void *ipipe,
+					void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_lutdpc *lut_param = (struct prev_lutdpc *)param;
+	struct prev_lutdpc user_lutdpc;
+
+	if (!lut_param) {
+		dev_err(dev, "get_lutdpc_params: invalid user ptr");
+		return -EINVAL;
+	}
+	if (len != sizeof(struct prev_lutdpc)) {
+		dev_err(dev,
+			"get_lutdpc_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+	if (copy_from_user(&user_lutdpc,
+			   lut_param,
+			   sizeof(struct prev_lutdpc))) {
+		dev_err(dev, "get_lutdpc_params: Error in copy to  kernel\n");
+		return -EFAULT;
+	}
+
+	user_lutdpc.en = oper_state->lutdpc.en;
+	user_lutdpc.repl_white = oper_state->lutdpc.repl_white;
+	user_lutdpc.dpc_size = oper_state->lutdpc.dpc_size;
+	if (!user_lutdpc.table) {
+		dev_err(dev, "get_lutdpc_params:" " Invalid table ptr");
+		return -EINVAL;
+	}
+	if (copy_to_user(user_lutdpc.table,
+			 oper_state->lutdpc.table,
+			 (oper_state->lutdpc.dpc_size *
+			  sizeof(struct ipipe_lutdpc_entry)))) {
+		dev_err(dev,
+			"get_lutdpc_params:Table Error in" " copy to user\n");
+		return -EFAULT;
+	}
+
+	if (copy_to_user(lut_param,
+			 &user_lutdpc,
+			 sizeof(struct prev_lutdpc))) {
+		dev_err(dev, "get_lutdpc_params: Error in copy" " to user\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int validate_otfdpc_params(struct ipipe_oper_state *oper_state,
+						struct device *dev)
+{
+	struct prev_otfdpc *dpc_param =
+			(struct prev_otfdpc *)&oper_state->otfdpc;
+	struct prev_otfdpc_2_0 *dpc_2_0;
+	struct prev_otfdpc_3_0 *dpc_3_0;
+
+	if (dpc_param->en > 1)
+		return -EINVAL;
+	if (dpc_param->alg == IPIPE_OTFDPC_2_0) {
+		dpc_2_0 = &dpc_param->alg_cfg.dpc_2_0;
+		if (dpc_2_0->det_thr.r > OTFDPC_DPC2_THR_MASK ||
+		    dpc_2_0->det_thr.gr > OTFDPC_DPC2_THR_MASK ||
+		    dpc_2_0->det_thr.gb > OTFDPC_DPC2_THR_MASK ||
+		    dpc_2_0->det_thr.b > OTFDPC_DPC2_THR_MASK ||
+		    dpc_2_0->corr_thr.r > OTFDPC_DPC2_THR_MASK ||
+		    dpc_2_0->corr_thr.gr > OTFDPC_DPC2_THR_MASK ||
+		    dpc_2_0->corr_thr.gb > OTFDPC_DPC2_THR_MASK ||
+		    dpc_2_0->corr_thr.b > OTFDPC_DPC2_THR_MASK)
+			return -EINVAL;
+	} else {
+		dpc_3_0 = &dpc_param->alg_cfg.dpc_3_0;
+		if (dpc_3_0->act_adj_shf > OTF_DPC3_0_SHF_MASK ||
+		    dpc_3_0->det_thr > OTF_DPC3_0_DET_MASK ||
+		    dpc_3_0->det_slp > OTF_DPC3_0_SLP_MASK ||
+		    dpc_3_0->det_thr_min > OTF_DPC3_0_DET_MASK ||
+		    dpc_3_0->det_thr_max > OTF_DPC3_0_DET_MASK ||
+		    dpc_3_0->corr_thr > OTF_DPC3_0_CORR_MASK ||
+		    dpc_3_0->corr_slp > OTF_DPC3_0_SLP_MASK ||
+		    dpc_3_0->corr_thr_min > OTF_DPC3_0_CORR_MASK ||
+		    dpc_3_0->corr_thr_max > OTF_DPC3_0_CORR_MASK)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+static int set_otfdpc_params(struct device *dev, void *ipipe,
+				void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_otfdpc *dpc_param = (struct prev_otfdpc *)param;
+
+	if (!param) {
+		/* Copy defaults for dpc2.0 defaults */
+		memcpy((void *)&oper_state->otfdpc,
+		       (void *)&dm365_otfdpc_defaults,
+		       sizeof(struct ipipe_otfdpc_2_0));
+	} else {
+		if (len != sizeof(struct prev_otfdpc)) {
+			dev_err(dev,
+				"set_otfdpc_params: param struct length"
+				" mismatch\n");
+			return -EINVAL;
+		}
+		if (copy_from_user(&oper_state->otfdpc,
+				   dpc_param,
+				   sizeof(struct prev_otfdpc))) {
+			dev_err(dev,
+				"set_otfdpc_params: Error in "
+				"copy to kernel\n");
+			return -EFAULT;
+		}
+
+		if (validate_otfdpc_params(oper_state, dev) < 0)
+			return -EINVAL;
+	}
+
+	ipipe_set_otfdpc_regs(&oper_state->otfdpc);
+
+	return 0;
+}
+
+static int get_otfdpc_params(struct device *dev, void *ipipe,
+					void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_otfdpc *dpc_param = (struct prev_otfdpc *)param;
+
+	if (!dpc_param) {
+		dev_err(dev, "get_otfdpc_params: invalid user ptr");
+		return -EINVAL;
+	}
+	if (len != sizeof(struct prev_otfdpc)) {
+		dev_err(dev,
+			"get_otfdpc_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+	if (copy_to_user(dpc_param,
+			 &oper_state->otfdpc,
+			 sizeof(struct prev_otfdpc))) {
+		dev_err(dev,
+			"get_otfdpc_params: Error in copy dpc "
+			"table to user\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int validate_nf_params(struct ipipe_oper_state *oper_state,
+					struct device *dev, unsigned int id)
+{
+	struct prev_nf *nf_param = &oper_state->nf1;
+	int i;
+
+	if (id)
+		nf_param = &oper_state->nf2;
+	if (nf_param->en > 1 ||
+	    nf_param->shft_val > D2F_SHFT_VAL_MASK ||
+	    nf_param->spread_val > D2F_SPR_VAL_MASK ||
+	    nf_param->apply_lsc_gain > 1 ||
+	    nf_param->edge_det_min_thr > D2F_EDGE_DET_THR_MASK ||
+	    nf_param->edge_det_max_thr > D2F_EDGE_DET_THR_MASK)
+		return -EINVAL;
+
+	for (i = 0; i < IPIPE_NF_THR_TABLE_SIZE; i++)
+		if (nf_param->thr[i] > D2F_THR_VAL_MASK)
+			return -EINVAL;
+	for (i = 0; i < IPIPE_NF_STR_TABLE_SIZE; i++)
+		if (nf_param->str[i] > D2F_STR_VAL_MASK)
+			return -EINVAL;
+	return 0;
+}
+
+static int set_nf_params(struct ipipe_oper_state *oper_state,
+			 struct device *dev, unsigned int id,
+			 void *param, int len)
+{
+	struct prev_nf *nf_param = (struct prev_nf *)param;
+	struct prev_nf *nf = &oper_state->nf1;
+
+	if (id)
+		nf = &oper_state->nf2;
+
+	if (!nf_param) {
+		/* Copy defaults for nf */
+		memcpy((void *)nf,
+		       (void *)&dm365_nf_defaults,
+		       sizeof(struct prev_nf));
+		memset((void *)nf->thr, 0, IPIPE_NF_THR_TABLE_SIZE);
+		memset((void *)nf->str, 0, IPIPE_NF_THR_TABLE_SIZE);
+	} else {
+		if (len != sizeof(struct prev_nf)) {
+			dev_err(dev,
+				"set_nf_params: param struct length"
+				" mismatch\n");
+			return -EINVAL;
+		}
+		if (copy_from_user(nf, nf_param, sizeof(struct prev_nf))) {
+			dev_err(dev,
+				"set_nf_params: Error in copy to kernel\n");
+			return -EFAULT;
+		}
+		if (validate_nf_params(oper_state, dev, id) < 0)
+			return -EINVAL;
+	}
+	/* Now set the values in the hw */
+	ipipe_set_d2f_regs(id, nf);
+
+	return 0;
+}
+
+static int set_nf1_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return set_nf_params(oper_state, dev, 0, param, len);
+}
+
+static int set_nf2_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return set_nf_params(oper_state, dev, 1, param, len);
+}
+
+static int get_nf_params(struct ipipe_oper_state *oper_state,
+			 struct device *dev, unsigned int id,
+			 void *param, int len)
+{
+	struct prev_nf *nf_param = (struct prev_nf *)param;
+	struct prev_nf *nf = &oper_state->nf1;
+
+	if (!nf_param) {
+		dev_err(dev, "get_nf_params: invalid user ptr");
+		return -EINVAL;
+	}
+	if (len != sizeof(struct prev_nf)) {
+		dev_err(dev,
+			"get_nf_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+	if (id)
+		nf = &oper_state->nf2;
+	if (copy_to_user((struct prev_nf *)nf_param, nf,
+			 sizeof(struct prev_nf))) {
+		dev_err(dev, "get_nf_params: Error in copy from kernel\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int get_nf1_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return get_nf_params(oper_state, dev, 0, param, len);
+}
+
+static int get_nf2_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return get_nf_params(oper_state, dev, 1, param, len);
+}
+
+static int validate_gic_params(struct ipipe_oper_state *oper_state,
+				struct device *dev)
+{
+	if (oper_state->gic.en > 1 ||
+	    oper_state->gic.gain > GIC_GAIN_MASK ||
+	    oper_state->gic.thr > GIC_THR_MASK ||
+	    oper_state->gic.slope > GIC_SLOPE_MASK ||
+	    oper_state->gic.apply_lsc_gain > 1 ||
+	    oper_state->gic.nf2_thr_gain.integer > GIC_NFGAN_INT_MASK ||
+	    oper_state->gic.nf2_thr_gain.decimal > GIC_NFGAN_DECI_MASK)
+		return -EINVAL;
+	return 0;
+}
+
+static int set_gic_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_gic *gic_param = (struct prev_gic *)param;
+
+	if (!gic_param) {
+		/* Copy defaults for nf */
+		memcpy((void *)&oper_state->gic,
+		       (void *)&dm365_gic_defaults,
+		       sizeof(struct prev_gic));
+	} else {
+		if (len != sizeof(struct prev_gic)) {
+			dev_err(dev,
+				"set_gic_params: param struct length"
+				" mismatch\n");
+			return -EINVAL;
+		}
+		if (copy_from_user(&oper_state->gic, gic_param,
+					sizeof(struct prev_gic))) {
+			dev_err(dev,
+				"set_gic_params: Error in copy to kernel\n");
+			return -EFAULT;
+		}
+		if (validate_gic_params(oper_state, dev) < 0)
+			return -EINVAL;
+	}
+	/* Now set the values in the hw */
+	ipipe_set_gic_regs(&oper_state->gic);
+
+	return 0;
+}
+
+static int get_gic_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_gic *gic_param = (struct prev_gic *)param;
+
+	if (!gic_param) {
+		dev_err(dev, "get_gic_params: invalid user ptr");
+		return -EINVAL;
+	}
+
+	if (len != sizeof(struct prev_gic)) {
+		dev_err(dev,
+			"get_gic_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+
+	if (copy_to_user((struct prev_gic *)gic_param,
+			 &oper_state->gic,
+			 sizeof(struct prev_gic))) {
+		dev_err(dev, "get_gic_params: Error in copy from kernel\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int validate_wb_params(struct ipipe_oper_state *oper_state,
+					 struct device *dev)
+{
+	if (oper_state->wb.ofst_r > WB_OFFSET_MASK ||
+	    oper_state->wb.ofst_gr > WB_OFFSET_MASK ||
+	    oper_state->wb.ofst_gb > WB_OFFSET_MASK ||
+	    oper_state->wb.ofst_b > WB_OFFSET_MASK ||
+	    oper_state->wb.gain_r.integer > WB_GAIN_INT_MASK ||
+	    oper_state->wb.gain_r.decimal > WB_GAIN_DECI_MASK ||
+	    oper_state->wb.gain_gr.integer > WB_GAIN_INT_MASK ||
+	    oper_state->wb.gain_gr.decimal > WB_GAIN_DECI_MASK ||
+	    oper_state->wb.gain_gb.integer > WB_GAIN_INT_MASK ||
+	    oper_state->wb.gain_gb.decimal > WB_GAIN_DECI_MASK ||
+	    oper_state->wb.gain_b.integer > WB_GAIN_INT_MASK ||
+	    oper_state->wb.gain_b.decimal > WB_GAIN_DECI_MASK)
+		return -EINVAL;
+	return 0;
+}
+static int set_wb_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_wb *wb_param = (struct prev_wb *)param;
+
+	dev_dbg(dev, "set_wb_params");
+	if (!wb_param) {
+		/* Copy defaults for wb */
+		memcpy((void *)&oper_state->wb,
+		       (void *)&dm365_wb_defaults,
+		       sizeof(struct prev_wb));
+	} else {
+		if (len != sizeof(struct prev_wb)) {
+			dev_err(dev,
+				"set_wb_params: param struct length"
+				" mismatch\n");
+			return -EINVAL;
+		}
+		if (copy_from_user(&oper_state->wb, wb_param,
+					sizeof(struct prev_wb))) {
+			dev_err(dev,
+				"set_wb_params: Error in copy to kernel\n");
+			return -EFAULT;
+		}
+		if (validate_wb_params(oper_state, dev) < 0)
+			return -EINVAL;
+	}
+
+	/* Now set the values in the hw */
+	ipipe_set_wb_regs(&oper_state->wb);
+
+	return 0;
+}
+static int get_wb_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_wb *wb_param = (struct prev_wb *)param;
+
+	if (!wb_param) {
+		dev_err(dev, "get_wb_params: invalid user ptr");
+		return -EINVAL;
+	}
+	if (len != sizeof(struct prev_wb)) {
+		dev_err(dev,
+			"get_wb_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+	if (copy_to_user((struct prev_wb *)wb_param,
+			 &oper_state->wb,
+			 sizeof(struct prev_wb))) {
+		dev_err(dev, "get_wb_params: Error in copy from kernel\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int validate_cfa_params(struct ipipe_oper_state *oper_state,
+					struct device *dev)
+{
+	if (oper_state->cfa.hpf_thr_2dir > CFA_HPF_THR_2DIR_MASK ||
+	    oper_state->cfa.hpf_slp_2dir > CFA_HPF_SLOPE_2DIR_MASK ||
+	    oper_state->cfa.hp_mix_thr_2dir > CFA_HPF_MIX_THR_2DIR_MASK ||
+	    oper_state->cfa.hp_mix_slope_2dir > CFA_HPF_MIX_SLP_2DIR_MASK ||
+	    oper_state->cfa.dir_thr_2dir > CFA_DIR_THR_2DIR_MASK ||
+	    oper_state->cfa.dir_slope_2dir > CFA_DIR_SLP_2DIR_MASK ||
+	    oper_state->cfa.nd_wt_2dir > CFA_ND_WT_2DIR_MASK ||
+	    oper_state->cfa.hue_fract_daa > CFA_DAA_HUE_FRA_MASK ||
+	    oper_state->cfa.edge_thr_daa > CFA_DAA_EDG_THR_MASK ||
+	    oper_state->cfa.thr_min_daa > CFA_DAA_THR_MIN_MASK ||
+	    oper_state->cfa.thr_slope_daa > CFA_DAA_THR_SLP_MASK ||
+	    oper_state->cfa.slope_min_daa > CFA_DAA_SLP_MIN_MASK ||
+	    oper_state->cfa.slope_slope_daa > CFA_DAA_SLP_SLP_MASK ||
+	    oper_state->cfa.lp_wt_daa > CFA_DAA_LP_WT_MASK)
+		return -EINVAL;
+	return 0;
+}
+static int set_cfa_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_cfa *cfa_param = (struct prev_cfa *)param;
+
+	dev_dbg(dev, "set_cfa_params");
+	if (!cfa_param) {
+		/* Copy defaults for wb */
+		memcpy((void *)&oper_state->cfa,
+		       (void *)&dm365_cfa_defaults,
+		       sizeof(struct prev_cfa));
+	} else {
+		if (len != sizeof(struct prev_cfa)) {
+			dev_err(dev,
+				"set_cfa_params: param struct length"
+				" mismatch\n");
+			return -EINVAL;
+		}
+		if (copy_from_user(&oper_state->cfa, cfa_param,
+						sizeof(struct prev_cfa))) {
+			dev_err(dev,
+				"set_cfa_params: Error in copy to kernel\n");
+			return -EFAULT;
+		}
+		if (validate_cfa_params(oper_state, dev) < 0)
+			return -EINVAL;
+	}
+
+	/* Now set the values in the hw */
+	ipipe_set_cfa_regs(&oper_state->cfa);
+
+	return 0;
+}
+static int get_cfa_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_cfa *cfa_param = (struct prev_cfa *)param;
+
+	dev_dbg(dev, "get_cfa_params\n");
+	if (!cfa_param) {
+		dev_err(dev, "get_cfa_params: invalid user ptr");
+		return -EINVAL;
+	}
+	if (len != sizeof(struct prev_cfa)) {
+		dev_err(dev,
+			"get_cfa_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+	if (copy_to_user((struct prev_cfa *)cfa_param,
+			 &oper_state->cfa,
+			 sizeof(struct prev_cfa))) {
+		dev_err(dev, "get_cfa_params: Error in copy from kernel\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int validate_rgb2rgb_params(struct ipipe_oper_state *oper_state,
+				   struct device *dev, unsigned int id)
+{
+	struct prev_rgb2rgb *rgb2rgb = &oper_state->rgb2rgb_1;
+	u32 gain_int_upper = RGB2RGB_1_GAIN_INT_MASK;
+	u32 offset_upper = RGB2RGB_1_OFST_MASK;
+
+	if (id) {
+		rgb2rgb = &oper_state->rgb2rgb_2;
+		offset_upper = RGB2RGB_2_OFST_MASK;
+		gain_int_upper = RGB2RGB_2_GAIN_INT_MASK;
+	}
+	if (rgb2rgb->coef_rr.decimal > RGB2RGB_GAIN_DECI_MASK ||
+	    rgb2rgb->coef_rr.integer > gain_int_upper)
+		return -EINVAL;
+
+	if (rgb2rgb->coef_gr.decimal > RGB2RGB_GAIN_DECI_MASK ||
+	    rgb2rgb->coef_gr.integer > gain_int_upper)
+		return -EINVAL;
+
+	if (rgb2rgb->coef_br.decimal > RGB2RGB_GAIN_DECI_MASK ||
+	    rgb2rgb->coef_br.integer > gain_int_upper)
+		return -EINVAL;
+
+	if (rgb2rgb->coef_rg.decimal > RGB2RGB_GAIN_DECI_MASK ||
+	    rgb2rgb->coef_rg.integer > gain_int_upper)
+		return -EINVAL;
+
+	if (rgb2rgb->coef_gg.decimal > RGB2RGB_GAIN_DECI_MASK ||
+	    rgb2rgb->coef_gg.integer > gain_int_upper)
+		return -EINVAL;
+
+	if (rgb2rgb->coef_bg.decimal > RGB2RGB_GAIN_DECI_MASK ||
+	    rgb2rgb->coef_bg.integer > gain_int_upper)
+		return -EINVAL;
+
+	if (rgb2rgb->coef_rb.decimal > RGB2RGB_GAIN_DECI_MASK ||
+	    rgb2rgb->coef_rb.integer > gain_int_upper)
+		return -EINVAL;
+
+	if (rgb2rgb->coef_gb.decimal > RGB2RGB_GAIN_DECI_MASK ||
+	    rgb2rgb->coef_gb.integer > gain_int_upper)
+		return -EINVAL;
+
+	if (rgb2rgb->coef_bb.decimal > RGB2RGB_GAIN_DECI_MASK ||
+	    rgb2rgb->coef_bb.integer > gain_int_upper)
+		return -EINVAL;
+
+	if (rgb2rgb->out_ofst_r > offset_upper ||
+	    rgb2rgb->out_ofst_g > offset_upper ||
+	    rgb2rgb->out_ofst_b > offset_upper)
+		return -EINVAL;
+	return 0;
+}
+
+static int set_rgb2rgb_params(struct ipipe_oper_state *oper_state,
+			      struct device *dev, unsigned int id,
+			      void *param, int len)
+{
+	struct prev_rgb2rgb *rgb2rgb_param = (struct prev_rgb2rgb *)param;
+	struct prev_rgb2rgb *rgb2rgb = &oper_state->rgb2rgb_1;
+
+	if (id)
+		rgb2rgb = &oper_state->rgb2rgb_2;
+	if (!rgb2rgb_param) {
+		/* Copy defaults for rgb2rgb conversion */
+		memcpy((void *)rgb2rgb,
+		       (void *)&dm365_rgb2rgb_defaults,
+		       sizeof(struct prev_rgb2rgb));
+	} else {
+
+		if (len != sizeof(struct prev_rgb2rgb)) {
+			dev_err(dev,
+				"set_rgb2rgb_params: param struct length"
+				" mismatch\n");
+			return -EINVAL;
+		}
+
+		if (copy_from_user(rgb2rgb,
+				   rgb2rgb_param,
+				   sizeof(struct prev_rgb2rgb))) {
+			dev_err(dev,
+				"set_rgb2rgb_params: Error in "
+				"copy to kernel\n");
+			return -EFAULT;
+		}
+		if (validate_rgb2rgb_params(oper_state, dev, id) < 0)
+			return -EINVAL;
+	}
+
+	ipipe_set_rgb2rgb_regs(id, rgb2rgb);
+
+	return 0;
+}
+
+static int set_rgb2rgb_1_params(struct device *dev, void *ipipe,
+					void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return set_rgb2rgb_params(oper_state, dev, 0, param, len);
+}
+
+static int set_rgb2rgb_2_params(struct device *dev, void *ipipe,
+					void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return set_rgb2rgb_params(oper_state, dev, 1, param, len);
+}
+
+static int get_rgb2rgb_params(struct ipipe_oper_state *oper_state,
+			      struct device *dev, unsigned int id,
+			      void *param, int len)
+{
+	struct prev_rgb2rgb *rgb2rgb_param = (struct prev_rgb2rgb *)param;
+	struct prev_rgb2rgb *rgb2rgb = &oper_state->rgb2rgb_1;
+
+	if (!rgb2rgb_param) {
+		dev_err(dev, "get_rgb2rgb_params: invalid user ptr");
+		return -EINVAL;
+	}
+
+	if (len != sizeof(struct prev_rgb2rgb)) {
+		dev_err(dev,
+			"get_rgb2rgb_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+
+	if (id)
+		rgb2rgb = &oper_state->rgb2rgb_2;
+	if (copy_to_user((struct prev_rgb2rgb *)rgb2rgb_param,
+			 rgb2rgb,
+			 sizeof(struct prev_rgb2rgb))) {
+		dev_err(dev, "get_rgb2rgb_params: Error in copy to user\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int get_rgb2rgb_1_params(struct device *dev, void *ipipe,
+				void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return get_rgb2rgb_params(oper_state, dev, 0, param, len);
+}
+
+static int get_rgb2rgb_2_params(struct device *dev, void *ipipe,
+				void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return get_rgb2rgb_params(oper_state, dev, 1, param, len);
+}
+
+static int validate_gamma_entry(struct ipipe_gamma_entry *table, int size)
+{
+	int i;
+
+	if (!table)
+		return -EINVAL;
+
+	for (i = 0; i < size; i++) {
+		if (table[i].slope > GAMMA_MASK ||
+		    table[i].offset > GAMMA_MASK)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+static int validate_gamma_params(struct ipipe_oper_state *oper_state,
+					struct device *dev)
+{
+	int table_size;
+	int err;
+
+	if (oper_state->gamma.bypass_r > 1 ||
+	    oper_state->gamma.bypass_b > 1 ||
+	    oper_state->gamma.bypass_g > 1)
+		return -EINVAL;
+
+	if (oper_state->gamma.tbl_sel != IPIPE_GAMMA_TBL_RAM)
+		return 0;
+
+	table_size = oper_state->gamma.tbl_size;
+	if (!oper_state->gamma.bypass_r) {
+		err = validate_gamma_entry(oper_state->gamma.table_r,
+							table_size);
+		if (err) {
+			dev_err(dev, "GAMMA R - table entry invalid\n");
+			return err;
+		}
+	}
+	if (!oper_state->gamma.bypass_b) {
+		err = validate_gamma_entry(oper_state->gamma.table_b,
+							table_size);
+		if (err) {
+			dev_err(dev, "GAMMA B - table entry invalid\n");
+			return err;
+		}
+	}
+	if (!oper_state->gamma.bypass_g) {
+		err = validate_gamma_entry(oper_state->gamma.table_g,
+							table_size);
+		if (err) {
+			dev_err(dev, "GAMMA G - table entry invalid\n");
+			return err;
+		}
+	}
+	return 0;
+}
+static int set_gamma_params(struct device *dev, void *ipipe,
+					void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_gamma *gamma_param = (struct prev_gamma *)param;
+	struct prev_gamma user_gamma;
+	int table_size;
+
+	if (!gamma_param) {
+		/* Copy defaults for gamma */
+		oper_state->gamma.bypass_r = dm365_gamma_defaults.bypass_r;
+		oper_state->gamma.bypass_g = dm365_gamma_defaults.bypass_g;
+		oper_state->gamma.bypass_b = dm365_gamma_defaults.bypass_b;
+		oper_state->gamma.tbl_sel = dm365_gamma_defaults.tbl_sel;
+		oper_state->gamma.tbl_size = dm365_gamma_defaults.tbl_size;
+		/* By default, we bypass the gamma correction.
+		 * So no values by default for tables
+		 */
+		goto success;
+	}
+
+	if (len != sizeof(struct prev_gamma)) {
+		dev_err(dev,
+			"set_gamma_params: param struct length"
+			" mismatch\n");
+		return -EINVAL;
+	}
+	if (copy_from_user(&user_gamma, gamma_param,
+			    sizeof(struct prev_gamma))) {
+		dev_err(dev,
+			"set_gamma_params: Error in copy to kernel\n");
+		return -EFAULT;
+	}
+
+	if (validate_gamma_params(oper_state, dev) < 0)
+		return -EINVAL;
+
+	oper_state->gamma.bypass_r = user_gamma.bypass_r;
+	oper_state->gamma.bypass_b = user_gamma.bypass_b;
+	oper_state->gamma.bypass_g = user_gamma.bypass_g;
+	oper_state->gamma.tbl_sel = user_gamma.tbl_sel;
+	oper_state->gamma.tbl_size = user_gamma.tbl_size;
+
+	if (user_gamma.tbl_sel != IPIPE_GAMMA_TBL_RAM)
+		goto success;
+
+	table_size = user_gamma.tbl_size;
+
+	if (!user_gamma.bypass_r) {
+		if (!user_gamma.table_r) {
+			dev_err(dev,
+				"set_gamma_params: Invalid"
+				" table ptr for R\n");
+			return -EINVAL;
+		}
+		if (copy_from_user(oper_state->gamma.table_r,
+				    user_gamma.table_r,
+				    (table_size *
+				    sizeof(struct \
+				    ipipe_gamma_entry)))) {
+			dev_err(dev,
+				"set_gamma_params: R-Error"
+				" in copy to kernel\n");
+			return -EFAULT;
+		}
+	}
+
+	if (!user_gamma.bypass_b) {
+		if (!user_gamma.table_b) {
+			dev_err(dev,
+				"set_gamma_params: Invalid"
+				" table ptr for B\n");
+			return -EINVAL;
+		}
+		if (copy_from_user(oper_state->gamma.table_b,
+				    user_gamma.table_b,
+				    (table_size *
+				    sizeof(struct \
+				    ipipe_gamma_entry)))) {
+			dev_err(dev,
+				"set_gamma_params: B-Error"
+				" in copy to kernel\n");
+			return -EFAULT;
+		}
+	}
+
+	if (!user_gamma.bypass_g) {
+		if (!user_gamma.table_g) {
+			dev_err(dev,
+				"set_gamma_params: Invalid"
+				" table ptr for G\n");
+			return -EINVAL;
+		}
+		if (copy_from_user(oper_state->gamma.table_g,
+				    user_gamma.table_g,
+				    (table_size *
+				    sizeof(struct \
+				    ipipe_gamma_entry)))) {
+			dev_err(dev,
+				"set_gamma_params: G-Error "
+				"in copy to kernel\n");
+			return -EFAULT;
+		}
+	}
+
+success:
+	ipipe_set_gamma_regs(&oper_state->gamma);
+
+	return 0;
+}
+
+static int get_gamma_params(struct device *dev, void *ipipe,
+					void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_gamma *gamma_param = (struct prev_gamma *)param;
+	struct prev_gamma user_gamma;
+	int table_size;
+
+	if (!gamma_param) {
+		dev_err(dev, "get_gamma_params: invalid user ptr");
+		return -EINVAL;
+	}
+	if (len != sizeof(struct prev_gamma)) {
+		dev_err(dev,
+			"get_gamma_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+	if (copy_from_user(&user_gamma,
+			   gamma_param,
+			   sizeof(struct prev_gamma))) {
+		dev_err(dev, "get_gamma_params: Error in copy to kernel\n");
+		return -EFAULT;
+	}
+
+	user_gamma.bypass_r = oper_state->gamma.bypass_r;
+	user_gamma.bypass_g = oper_state->gamma.bypass_g;
+	user_gamma.bypass_b = oper_state->gamma.bypass_b;
+	user_gamma.tbl_sel = oper_state->gamma.tbl_sel;
+	user_gamma.tbl_size = oper_state->gamma.tbl_size;
+	if (oper_state->gamma.tbl_sel == IPIPE_GAMMA_TBL_RAM) {
+		table_size = oper_state->gamma.tbl_size;
+
+		if (!oper_state->gamma.bypass_r && !user_gamma.table_r) {
+			dev_err(dev,
+				"get_gamma_params: table ptr empty for R\n");
+			return -EINVAL;
+		} else {
+			if (copy_to_user(user_gamma.table_r,
+					 oper_state->gamma.table_r,
+					 (table_size *
+					 sizeof(struct ipipe_gamma_entry)))) {
+				dev_err(dev,
+					"set_gamma_params: R-Table Error in"
+					" copy to user\n");
+				return -EFAULT;
+			}
+		}
+
+		if (!oper_state->gamma.bypass_b && !user_gamma.table_b) {
+			dev_err(dev,
+				"get_gamma_params: table ptr empty for B\n");
+			return -EINVAL;
+		} else {
+			if (copy_to_user(user_gamma.table_b,
+					 oper_state->gamma.table_b,
+					 (table_size *
+					  sizeof(struct ipipe_gamma_entry)))) {
+				dev_err(dev,
+					"set_gamma_params: B-Table Error in"
+					" copy to user\n");
+				return -EFAULT;
+			}
+		}
+
+		if (!oper_state->gamma.bypass_g && !user_gamma.table_g) {
+			dev_err(dev,
+				"get_gamma_params: table ptr empty for G\n");
+			return -EINVAL;
+		} else {
+			if (copy_from_user(oper_state->gamma.table_g,
+				user_gamma.table_g,
+				(table_size *
+				sizeof(struct ipipe_gamma_entry)))) {
+				dev_err(dev,
+					"set_gamma_params: G-Table"
+					"copy error\n");
+				return -EFAULT;
+			}
+		}
+
+	}
+	if (copy_to_user(gamma_param, &user_gamma,
+		sizeof(struct prev_gamma))) {
+		dev_err(dev, "get_dfc_params: Error in copy from kernel\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int validate_3d_lut_params(struct ipipe_oper_state *oper_state,
+						struct device *dev)
+{
+	int i;
+
+	if (!oper_state->lut_3d.en)
+		return 0;
+
+	for (i = 0; i < MAX_SIZE_3D_LUT; i++) {
+		if (oper_state->lut_3d.table[i].r > D3_LUT_ENTRY_MASK ||
+		    oper_state->lut_3d.table[i].g > D3_LUT_ENTRY_MASK ||
+		    oper_state->lut_3d.table[i].b > D3_LUT_ENTRY_MASK)
+			return -EINVAL;
+	}
+	return 0;
+}
+static int set_3d_lut_params(struct device *dev, void *ipipe,
+				void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_3d_lut *lut_param = (struct prev_3d_lut *)param;
+	struct prev_3d_lut user_3d_lut;
+
+	if (!lut_param) {
+		/* Copy defaults for gamma */
+		oper_state->lut_3d.en = dm365_3d_lut_defaults.en;
+		/* By default, 3D lut is disabled
+		 */
+	} else {
+		if (len != sizeof(struct prev_3d_lut)) {
+			dev_err(dev,
+				"set_3d_lut_params: param struct"
+				" length mismatch\n");
+			return -EINVAL;
+		}
+		if (copy_from_user(&user_3d_lut,
+				   lut_param,
+				   sizeof(struct prev_3d_lut))) {
+			dev_err(dev,
+				"set_3d_lut_params: Error in copy to"
+				" kernel\n");
+			return -EFAULT;
+		}
+		oper_state->lut_3d.en = user_3d_lut.en;
+		if (!user_3d_lut.table) {
+			dev_err(dev, "set_3d_lut_params: Invalid table ptr");
+			return -EINVAL;
+		}
+		if (copy_from_user(oper_state->lut_3d.table,
+				   user_3d_lut.table,
+				   (MAX_SIZE_3D_LUT *
+				   sizeof(struct ipipe_3d_lut_entry)))) {
+			dev_err(dev,
+				"set_3d_lut_params:Error"
+				" in copy to kernel\n");
+			return -EFAULT;
+		}
+
+		if (validate_3d_lut_params(oper_state, dev) < 0)
+			return -EINVAL;
+	}
+
+	ipipe_set_3d_lut_regs(&oper_state->lut_3d);
+
+	return 0;
+}
+static int get_3d_lut_params(struct device *dev, void *ipipe,
+					void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_3d_lut *lut_param = (struct prev_3d_lut *)param;
+	struct prev_3d_lut user_3d_lut;
+
+	if (!lut_param) {
+		dev_err(dev, "get_3d_lut_params: invalid user ptr");
+		return -EINVAL;
+	}
+	if (len != sizeof(struct prev_3d_lut)) {
+		dev_err(dev,
+			"get_3d_lut_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+	if (copy_from_user(&user_3d_lut,
+			   lut_param,
+			   sizeof(struct prev_3d_lut))) {
+		dev_err(dev, "get_3d_lut_params: Error in copy to kernel\n");
+		return -EFAULT;
+	}
+
+	user_3d_lut.en = oper_state->lut_3d.en;
+	if (!user_3d_lut.table) {
+		dev_err(dev, "get_3d_lut_params:" " Invalid table ptr");
+		return -EINVAL;
+	}
+	if (copy_to_user(user_3d_lut.table, oper_state->lut_3d.table,
+			 (MAX_SIZE_3D_LUT *
+			  sizeof(struct ipipe_3d_lut_entry)))) {
+		dev_err(dev,
+			"get_3d_lut_params:Table Error in" " copy to user\n");
+		return -EFAULT;
+	}
+
+	if (copy_to_user(lut_param, &user_3d_lut,
+		sizeof(struct prev_3d_lut))) {
+		dev_err(dev, "get_3d_lut_params: Error in copy" " to user\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int validate_lum_adj_params(struct device *dev)
+{
+	/* nothing to validate */
+	return 0;
+}
+
+static int set_lum_adj_params(struct device *dev, void *ipipe,
+					void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_lum_adj *lum_adj_param = (struct prev_lum_adj *)param;
+
+	if (!lum_adj_param) {
+		/* Copy defaults for Luminance adjustments */
+		memcpy((void *)&oper_state->lum_adj,
+		       (void *)&dm365_lum_adj_defaults,
+		       sizeof(struct prev_lum_adj));
+	} else {
+		if (len != sizeof(struct prev_lum_adj)) {
+			dev_err(dev,
+				"set_lum_adj_params: param struct length"
+				" mismatch\n");
+			return -EINVAL;
+		}
+		if (copy_from_user(&oper_state->lum_adj,
+				   lum_adj_param,
+				   sizeof(struct prev_lum_adj))) {
+			dev_err(dev,
+				"set_lum_adj_params: Error in copy"
+				" from user\n");
+			return -EFAULT;
+		}
+		if (validate_lum_adj_params(dev) < 0)
+			return -EINVAL;
+	}
+
+	ipipe_set_lum_adj_regs(&oper_state->lum_adj);
+
+	return 0;
+}
+
+static int get_lum_adj_params(struct device *dev, void *ipipe,
+					void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_lum_adj *lum_adj_param = (struct prev_lum_adj *)param;
+
+	if (!lum_adj_param) {
+		dev_err(dev, "get_lum_adj_params: invalid user ptr");
+		return -EINVAL;
+	}
+
+	if (len != sizeof(struct prev_lum_adj)) {
+		dev_err(dev,
+			"get_lum_adj_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+
+	if (copy_to_user(lum_adj_param,
+			 &oper_state->lum_adj,
+			 sizeof(struct prev_lum_adj))) {
+		dev_err(dev, "get_lum_adj_params: Error in copy to" " user\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int validate_rgb2yuv_params(struct ipipe_oper_state *oper_state,
+				   struct device *dev)
+{
+	if (oper_state->rgb2yuv.coef_ry.decimal > RGB2YCBCR_COEF_DECI_MASK ||
+	    oper_state->rgb2yuv.coef_ry.integer > RGB2YCBCR_COEF_INT_MASK)
+		return -EINVAL;
+
+	if (oper_state->rgb2yuv.coef_gy.decimal > RGB2YCBCR_COEF_DECI_MASK ||
+	    oper_state->rgb2yuv.coef_gy.integer > RGB2YCBCR_COEF_INT_MASK)
+		return -EINVAL;
+
+	if (oper_state->rgb2yuv.coef_by.decimal > RGB2YCBCR_COEF_DECI_MASK ||
+	    oper_state->rgb2yuv.coef_by.integer > RGB2YCBCR_COEF_INT_MASK)
+		return -EINVAL;
+
+	if (oper_state->rgb2yuv.coef_rcb.decimal > RGB2YCBCR_COEF_DECI_MASK ||
+	    oper_state->rgb2yuv.coef_rcb.integer > RGB2YCBCR_COEF_INT_MASK)
+		return -EINVAL;
+
+	if (oper_state->rgb2yuv.coef_gcb.decimal > RGB2YCBCR_COEF_DECI_MASK ||
+	    oper_state->rgb2yuv.coef_gcb.integer > RGB2YCBCR_COEF_INT_MASK)
+		return -EINVAL;
+
+	if (oper_state->rgb2yuv.coef_bcb.decimal > RGB2YCBCR_COEF_DECI_MASK ||
+	    oper_state->rgb2yuv.coef_bcb.integer > RGB2YCBCR_COEF_INT_MASK)
+		return -EINVAL;
+
+	if (oper_state->rgb2yuv.coef_rcr.decimal > RGB2YCBCR_COEF_DECI_MASK ||
+	    oper_state->rgb2yuv.coef_rcr.integer > RGB2YCBCR_COEF_INT_MASK)
+		return -EINVAL;
+
+	if (oper_state->rgb2yuv.coef_gcr.decimal > RGB2YCBCR_COEF_DECI_MASK ||
+	    oper_state->rgb2yuv.coef_gcr.integer > RGB2YCBCR_COEF_INT_MASK)
+		return -EINVAL;
+
+	if (oper_state->rgb2yuv.coef_bcr.decimal > RGB2YCBCR_COEF_DECI_MASK ||
+	    oper_state->rgb2yuv.coef_bcr.integer > RGB2YCBCR_COEF_INT_MASK)
+		return -EINVAL;
+
+	if (oper_state->rgb2yuv.out_ofst_y > RGB2YCBCR_OFST_MASK ||
+	    oper_state->rgb2yuv.out_ofst_cb > RGB2YCBCR_OFST_MASK ||
+	    oper_state->rgb2yuv.out_ofst_cr > RGB2YCBCR_OFST_MASK)
+		return -EINVAL;
+	return 0;
+}
+static int set_rgb2yuv_params(struct device *dev, void *ipipe,
+					void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_rgb2yuv *rgb2yuv_param = (struct prev_rgb2yuv *)param;
+
+	if (!rgb2yuv_param) {
+		/* Copy defaults for rgb2yuv conversion  */
+		memcpy((void *)&oper_state->rgb2yuv,
+		       (void *)&dm365_rgb2yuv_defaults,
+		       sizeof(struct prev_rgb2yuv));
+	} else {
+		if (len != sizeof(struct prev_rgb2yuv)) {
+			dev_err(dev,
+				"set_rgb2yuv_params: param struct"
+				" length mismatch\n");
+			return -EINVAL;
+		}
+		if (copy_from_user(&oper_state->rgb2yuv,
+				   rgb2yuv_param,
+				   sizeof(struct prev_rgb2yuv))) {
+			dev_err(dev,
+				"set_rgb2yuv_params: Error in copy from"
+				" user\n");
+			return -EFAULT;
+		}
+		if (validate_rgb2yuv_params(oper_state, dev) < 0)
+			return -EINVAL;
+	}
+
+	ipipe_set_rgb2ycbcr_regs(&oper_state->rgb2yuv);
+
+	return 0;
+}
+static int get_rgb2yuv_params(struct device *dev, void *ipipe,
+					void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_rgb2yuv *rgb2yuv_param = (struct prev_rgb2yuv *)param;
+
+	if (!rgb2yuv_param) {
+		dev_err(dev, "get_rgb2yuv_params: invalid user ptr");
+		return -EINVAL;
+	}
+	if (len != sizeof(struct prev_rgb2yuv)) {
+		dev_err(dev,
+			"get_rgb2yuv_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+	if (copy_to_user((struct prev_rgb2yuv *)rgb2yuv_param,
+			 &oper_state->rgb2yuv,
+			 sizeof(struct prev_rgb2yuv))) {
+		dev_err(dev, "get_rgb2yuv_params: Error in copy from"
+			" kernel\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int validate_gbce_params(struct ipipe_oper_state *oper_state,
+				struct device *dev)
+{
+	u32 max = GBCE_Y_VAL_MASK;
+	int i;
+
+	if (!oper_state->gbce.en)
+		return 0;
+
+	if (oper_state->gbce.type == IPIPE_GBCE_GAIN_TBL)
+		max = GBCE_GAIN_VAL_MASK;
+	for (i = 0; i < MAX_SIZE_GBCE_LUT; i++)
+		if (oper_state->gbce.table[i] > max)
+			return -EINVAL;
+	return 0;
+}
+static int set_gbce_params(struct device *dev, void *ipipe,
+				void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_gbce *gbce_param = (struct prev_gbce *)param;
+	struct prev_gbce user_gbce;
+
+	if (!gbce_param)
+		/* Copy defaults for gamma */
+		oper_state->gbce.en = dm365_gbce_defaults.en;
+		/* By default, GBCE is disabled
+		 */
+	else {
+		if (len != sizeof(struct prev_gbce)) {
+			dev_err(dev,
+				"set_gbce_params: param struct"
+				" length mismatch\n");
+			return -EINVAL;
+		}
+		if (copy_from_user(&user_gbce,
+				   gbce_param,
+				   sizeof(struct prev_gbce))) {
+			dev_err(dev,
+				"set_gbce_params: Error in copy to"
+				" kernel\n");
+			return -EFAULT;
+		}
+		oper_state->gbce.en = user_gbce.en;
+		oper_state->gbce.type = user_gbce.type;
+		if (!user_gbce.table) {
+			dev_err(dev, "set_gbce_params:" " Invalid table ptr");
+			return -EINVAL;
+		}
+
+		if (copy_from_user(oper_state->gbce.table,
+				   user_gbce.table,
+				   (MAX_SIZE_GBCE_LUT *
+				   sizeof(unsigned short)))) {
+			dev_err(dev, "set_gbce_params:Error"
+					" in copy to kernel\n");
+			return -EFAULT;
+		}
+		if (validate_gbce_params(oper_state, dev) < 0)
+			return -EINVAL;
+	}
+
+	ipipe_set_gbce_regs(&oper_state->gbce);
+
+	return 0;
+}
+static int get_gbce_params(struct device *dev, void *ipipe,
+				void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_gbce *gbce_param = (struct prev_gbce *)param;
+	struct prev_gbce user_gbce;
+
+	if (!gbce_param) {
+		dev_err(dev, "get_gbce_params: invalid user ptr");
+		return -EINVAL;
+	}
+	if (len != sizeof(struct prev_gbce)) {
+		dev_err(dev,
+			"get_gbce_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+	if (copy_from_user(&user_gbce, gbce_param, sizeof(struct prev_gbce))) {
+		dev_err(dev, "get_gbce_params: Error in copy to" " kernel\n");
+		return -EFAULT;
+	}
+
+	user_gbce.en = oper_state->gbce.en;
+	user_gbce.type = oper_state->gbce.type;
+	if (!user_gbce.table) {
+		dev_err(dev, "get_gbce_params:" " Invalid table ptr");
+		return -EINVAL;
+	}
+	if (copy_to_user(user_gbce.table,
+			 oper_state->gbce.table,
+			 (MAX_SIZE_GBCE_LUT *
+			 sizeof(unsigned short)))) {
+		dev_err(dev,
+			"get_gbce_params:Table Error in" " copy to user\n");
+		return -EFAULT;
+	}
+
+	if (copy_to_user(gbce_param, &user_gbce, sizeof(struct prev_gbce))) {
+		dev_err(dev, "get_gbce_params: Error in copy" " to user\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int validate_yuv422_conv_params(struct ipipe_oper_state *oper_state,
+						struct device *dev)
+{
+	if (oper_state->yuv422_conv.en_chrom_lpf > 1)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int set_yuv422_conv_params(struct device *dev, void *ipipe,
+					void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_yuv422_conv *yuv422_conv_param =
+	    (struct prev_yuv422_conv *)param;
+
+	if (!yuv422_conv_param) {
+		/* Copy defaults for yuv 422 conversion */
+		memcpy((void *)&oper_state->yuv422_conv,
+		       (void *)&dm365_yuv422_conv_defaults,
+		       sizeof(struct prev_yuv422_conv));
+	} else {
+		if (len != sizeof(struct prev_yuv422_conv)) {
+			dev_err(dev,
+				"set_yuv422_conv_params: param struct"
+				" length mismatch\n");
+			return -EINVAL;
+		}
+		if (copy_from_user(&oper_state->yuv422_conv,
+				   yuv422_conv_param,
+				   sizeof(struct prev_yuv422_conv))) {
+			dev_err(dev,
+				"set_yuv422_conv_params: Error in copy"
+				" from user\n");
+			return -EFAULT;
+		}
+		if (validate_yuv422_conv_params(oper_state, dev) < 0)
+			return -EINVAL;
+	}
+
+	ipipe_set_yuv422_conv_regs(&oper_state->yuv422_conv);
+
+	return 0;
+}
+
+static int get_yuv422_conv_params(struct device *dev, void *ipipe,
+					void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_yuv422_conv *yuv422_conv_param =
+	    (struct prev_yuv422_conv *)param;
+
+	if (!yuv422_conv_param) {
+		dev_err(dev, "get_yuv422_conv_params: invalid user ptr");
+		return -EINVAL;
+	}
+	if (len != sizeof(struct prev_yuv422_conv)) {
+		dev_err(dev,
+			"get_yuv422_conv_params: param struct"
+			" length mismatch\n");
+		return -EINVAL;
+	}
+	if (copy_to_user(yuv422_conv_param,
+			 &oper_state->yuv422_conv,
+			 sizeof(struct prev_yuv422_conv))) {
+		dev_err(dev,
+			"get_yuv422_conv_params: Error in copy from kernel\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int validate_yee_params(struct ipipe_oper_state *oper_state,
+			       struct device *dev)
+{
+	int i;
+
+	if (oper_state->yee.en > 1 ||
+	    oper_state->yee.en_halo_red > 1 ||
+	    oper_state->yee.hpf_shft > YEE_HPF_SHIFT_MASK)
+		return -EINVAL;
+
+	if (oper_state->yee.hpf_coef_00 > YEE_COEF_MASK ||
+	    oper_state->yee.hpf_coef_01 > YEE_COEF_MASK ||
+	    oper_state->yee.hpf_coef_02 > YEE_COEF_MASK ||
+	    oper_state->yee.hpf_coef_10 > YEE_COEF_MASK ||
+	    oper_state->yee.hpf_coef_11 > YEE_COEF_MASK ||
+	    oper_state->yee.hpf_coef_12 > YEE_COEF_MASK ||
+	    oper_state->yee.hpf_coef_20 > YEE_COEF_MASK ||
+	    oper_state->yee.hpf_coef_21 > YEE_COEF_MASK ||
+	    oper_state->yee.hpf_coef_22 > YEE_COEF_MASK)
+		return -EINVAL;
+
+	if (oper_state->yee.yee_thr > YEE_THR_MASK ||
+	    oper_state->yee.es_gain > YEE_ES_GAIN_MASK ||
+	    oper_state->yee.es_thr1 > YEE_ES_THR1_MASK ||
+	    oper_state->yee.es_thr2 > YEE_THR_MASK ||
+	    oper_state->yee.es_gain_grad > YEE_THR_MASK ||
+	    oper_state->yee.es_ofst_grad > YEE_THR_MASK)
+		return -EINVAL;
+
+	for (i = 0; i < MAX_SIZE_YEE_LUT ; i++)
+		if (oper_state->yee.table[i] > YEE_ENTRY_MASK)
+			return -EINVAL;
+	return 0;
+}
+static int set_yee_params(struct device *dev, void *ipipe,
+				void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_yee *yee_param = (struct prev_yee *)param;
+	struct prev_yee user_yee;
+	short *temp_table;
+
+	if (!yee_param) {
+		temp_table = oper_state->yee.table;
+		/* Copy defaults for ns */
+		memcpy((void *)&oper_state->yee,
+		       (void *)&dm365_yee_defaults,
+		       sizeof(struct prev_yee));
+		oper_state->yee.table = temp_table;
+	} else {
+		if (len != sizeof(struct prev_yee)) {
+			dev_err(dev,
+				"set_yee_params: param struct"
+				" length mismatch\n");
+			return -EINVAL;
+		}
+		if (copy_from_user(&user_yee,
+				   yee_param,
+				   sizeof(struct prev_yee))) {
+			dev_err(dev,
+				"set_yee_params: Error in copy from user\n");
+			return -EFAULT;
+		}
+		if (!user_yee.table) {
+			dev_err(dev, "set_yee_params: yee table ptr null\n");
+			return -EINVAL;
+		}
+		if (copy_from_user(oper_state->yee.table,
+				   user_yee.table,
+				   (MAX_SIZE_YEE_LUT * sizeof(short)))) {
+			dev_err(dev,
+				"set_yee_params: Error in copy from user\n");
+			return -EFAULT;
+		}
+		temp_table = oper_state->yee.table;
+		memcpy(&oper_state->yee, &user_yee, sizeof(struct prev_yee));
+		oper_state->yee.table = temp_table;
+		if (validate_yee_params(oper_state, dev) < 0)
+			return -EINVAL;
+	}
+
+	ipipe_set_ee_regs(&oper_state->yee);
+
+	return 0;
+}
+static int get_yee_params(struct device *dev, void *ipipe,
+				void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_yee *yee_param = (struct prev_yee *)param;
+	struct prev_yee user_yee;
+	short *temp_table;
+
+	if (!yee_param) {
+		dev_err(dev, "get_yee_params: invalid user ptr");
+		return -EINVAL;
+	}
+	if (len != sizeof(struct prev_yee)) {
+		dev_err(dev,
+			"get_yee_params: param struct"
+			" length mismatch\n");
+		return -EINVAL;
+	}
+	if (copy_from_user(&user_yee, yee_param, sizeof(struct prev_yee))) {
+		dev_err(dev, "get_yee_params: Error in copy to kernel\n");
+		return -EFAULT;
+	}
+	if (!user_yee.table) {
+		dev_err(dev, "get_yee_params: yee table ptr null\n");
+		return -EINVAL;
+	}
+	if (copy_to_user(user_yee.table, oper_state->yee.table,
+			 (MAX_SIZE_YEE_LUT * sizeof(short)))) {
+		dev_err(dev, "get_yee_params: Error in copy from kernel\n");
+		return -EFAULT;
+	}
+	temp_table = user_yee.table;
+	memcpy(&user_yee, &oper_state->yee, sizeof(struct prev_yee));
+	user_yee.table = temp_table;
+
+	if (copy_to_user(yee_param, &user_yee, sizeof(struct prev_yee))) {
+		dev_err(dev, "get_yee_params: Error in copy from kernel\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int validate_car_params(struct ipipe_oper_state *oper_state,
+			       struct device *dev)
+{
+	if (oper_state->car.en > 1 ||
+	    oper_state->car.hpf_shft > CAR_HPF_SHIFT_MASK ||
+	    oper_state->car.gain1.shft > CAR_GAIN1_SHFT_MASK ||
+	    oper_state->car.gain1.gain_min > CAR_GAIN_MIN_MASK ||
+	    oper_state->car.gain2.shft > CAR_GAIN2_SHFT_MASK ||
+	    oper_state->car.gain2.gain_min > CAR_GAIN_MIN_MASK)
+		return -EINVAL;
+	return 0;
+}
+
+static int set_car_params(struct device *dev, void *ipipe,
+				void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_car *car_param = (struct prev_car *)param;
+
+	if (!car_param) {
+		/* Copy defaults for ns */
+		memcpy((void *)&oper_state->car,
+		       (void *)&dm365_car_defaults,
+		       sizeof(struct prev_car));
+	} else {
+		if (len != sizeof(struct prev_car)) {
+			dev_err(dev,
+				"set_car_params: param struct"
+				" length mismatch\n");
+			return -EINVAL;
+		}
+		if (copy_from_user(&oper_state->car, car_param,
+					sizeof(struct prev_car))) {
+			dev_err(dev,
+				"set_car_params: Error in copy from user\n");
+			return -EFAULT;
+		}
+		if (validate_car_params(oper_state, dev) < 0)
+			return -EINVAL;
+	}
+
+	ipipe_set_car_regs(&oper_state->car);
+
+	return 0;
+}
+static int get_car_params(struct device *dev, void *ipipe,
+				void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_car *car_param = (struct prev_car *)param;
+
+	if (!car_param) {
+		dev_err(dev, "get_car_params: invalid user ptr");
+		return -EINVAL;
+	}
+	if (len != sizeof(struct prev_car)) {
+		dev_err(dev,
+			"get_car_params: param struct"
+			" length mismatch\n");
+		return -EINVAL;
+	}
+	if (copy_to_user(car_param, &oper_state->car,
+				sizeof(struct prev_car))) {
+		dev_err(dev, "get_car_params: Error in copy from kernel\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int validate_cgs_params(struct ipipe_oper_state *oper_state,
+					struct device *dev)
+{
+	if (oper_state->cgs.en > 1 ||
+	    oper_state->cgs.h_shft > CAR_SHIFT_MASK)
+		return -EINVAL;
+	return 0;
+}
+
+static int set_cgs_params(struct device *dev, void *ipipe,
+					void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_cgs *cgs_param = (struct prev_cgs *)param;
+
+	if (!cgs_param) {
+		/* Copy defaults for ns */
+		memcpy((void *)&oper_state->cgs,
+		       (void *)&dm365_cgs_defaults,
+		       sizeof(struct prev_cgs));
+	} else {
+		if (len != sizeof(struct prev_cgs)) {
+			dev_err(dev,
+				"set_cgs_params: param struct"
+				" length mismatch\n");
+			return -EINVAL;
+		}
+		if (copy_from_user(&oper_state->cgs, cgs_param,
+					sizeof(struct prev_cgs))) {
+			dev_err(dev,
+				"set_cgs_params: Error in copy from user\n");
+			return -EFAULT;
+		}
+		if (validate_cgs_params(oper_state, dev) < 0)
+			return -EINVAL;
+	}
+
+	ipipe_set_cgs_regs(&oper_state->cgs);
+
+	return 0;
+}
+
+static int get_cgs_params(struct device *dev, void *ipipe,
+					void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_cgs *cgs_param = (struct prev_cgs *)param;
+
+	if (!cgs_param) {
+		dev_err(dev, "get_cgs_params: invalid user ptr");
+		return -EINVAL;
+	}
+	if (len != sizeof(struct prev_cgs)) {
+		dev_err(dev,
+			"get_cgs_params: param struct"
+			" length mismatch\n");
+		return -EINVAL;
+	}
+	if (copy_to_user(cgs_param, &oper_state->cgs,
+				sizeof(struct prev_cgs))) {
+		dev_err(dev, "get_cgs_params: Error in copy from kernel\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static struct prev_module_if prev_modules[PREV_MAX_MODULES] = {
+	{
+		.version = "5.1",
+		.module_id = PREV_LUTDPC,
+		.module_name = "LUT Defect Correction",
+		.control = 0,
+		.path = IMP_RAW2RAW | IMP_RAW2YUV,
+		.set = set_lutdpc_params,
+		.get = get_lutdpc_params
+	},
+	{
+		.version = "5.1",
+		.module_id = PREV_OTFDPC,
+		.module_name = "OTF Defect Pixel Correction",
+		.control = 0,
+		.path = IMP_RAW2RAW | IMP_RAW2YUV,
+		.set = set_otfdpc_params,
+		.get = get_otfdpc_params
+	},
+	{
+		.version = "5.1",
+		.module_id = PREV_NF1,
+		.module_name = "2-D Noise filter - 1",
+		.control = 0,
+		.path = IMP_RAW2RAW | IMP_RAW2YUV,
+		.set = set_nf1_params,
+		.get = get_nf1_params
+	},
+	{
+		.version = "5.1",
+		.module_id = PREV_NF2,
+		.module_name = "2-D Noise filter - 2",
+		.control = 0,
+		.path = IMP_RAW2RAW | IMP_RAW2YUV,
+		.set = set_nf2_params,
+		.get = get_nf2_params
+	},
+	{
+		.version = "5.1",
+		.module_id = PREV_GIC,
+		.module_name = "Green Imbalance Correction",
+		.control = 0,
+		.path = IMP_RAW2RAW | IMP_RAW2YUV,
+		.set = set_gic_params,
+		.get = get_gic_params
+	},
+	{
+		.version = "5.1",
+		.module_id = PREV_WB,
+		.module_name = "White balance",
+		.control = 1,
+		.path = IMP_RAW2RAW | IMP_RAW2YUV,
+		.set = set_wb_params,
+		.get = get_wb_params
+	},
+	{
+		.version = "5.1",
+		.module_id = PREV_CFA,
+		.module_name = "CFA Interpolation",
+		.control = 0,
+		.path = IMP_RAW2YUV,
+		.set = set_cfa_params,
+		.get = get_cfa_params
+	},
+	{
+		.version = "5.1",
+		.module_id = PREV_RGB2RGB_1,
+		.module_name = "RGB-RGB Conversion - 1",
+		.control = 0,
+		.path = IMP_RAW2YUV,
+		.set = set_rgb2rgb_1_params,
+		.get = get_rgb2rgb_1_params
+	},
+	{
+		.version = "5.1",
+		.module_id = PREV_GAMMA,
+		.module_name = "Gamma Correction",
+		.control = 0,
+		.path = IMP_RAW2YUV,
+		.set = set_gamma_params,
+		.get = get_gamma_params
+	},
+	{
+		.version = "5.1",
+		.module_id = PREV_RGB2RGB_2,
+		.module_name = "RGB-RGB Conversion - 2",
+		.control = 0,
+		.path = IMP_RAW2YUV,
+		.set = set_rgb2rgb_2_params,
+		.get = get_rgb2rgb_2_params
+	},
+	{
+		.version = "5.1",
+		.module_id = PREV_3D_LUT,
+		.module_name = "3D LUT",
+		.control = 0,
+		.path = IMP_RAW2YUV,
+		.set = set_3d_lut_params,
+		.get = get_3d_lut_params
+	},
+	{
+		.version = "5.1",
+		.module_id = PREV_RGB2YUV,
+		.module_name = "RGB-YCbCr conversion",
+		.control = 0,
+		.path = IMP_RAW2YUV,
+		.set = set_rgb2yuv_params,
+		.get = get_rgb2yuv_params
+	},
+	{
+		.version = "5.1",
+		.module_id = PREV_GBCE,
+		.module_name = "Global Brightness,Contrast Control",
+		.control = 0,
+		.path = IMP_RAW2YUV,
+		.set = set_gbce_params,
+		.get = get_gbce_params
+	},
+	{
+		.version = "5.1",
+		.module_id = PREV_YUV422_CONV,
+		.module_name = "YUV 422 conversion",
+		.control = 0,
+		.path = IMP_RAW2YUV,
+		.set = set_yuv422_conv_params,
+		.get = get_yuv422_conv_params
+	},
+	{
+		.version = "5.1",
+		.module_id = PREV_LUM_ADJ,
+		.module_name = "Luminance Adjustment",
+		.control = 1,
+		.path = IMP_RAW2YUV,
+		.set = set_lum_adj_params,
+		.get = get_lum_adj_params
+	},
+	{
+		.version = "5.1",
+		.module_id = PREV_YEE,
+		.module_name = "Edge Enhancer",
+		.control = 1,
+		.path = IMP_RAW2YUV | IMP_YUV2YUV,
+		.set = set_yee_params,
+		.get = get_yee_params
+	},
+	{
+		.version = "5.1",
+		.module_id = PREV_CAR,
+		.module_name = "Chromatic Artifact Reduction",
+		.control = 1,
+		.path = IMP_RAW2YUV | IMP_YUV2YUV,
+		.set = set_car_params,
+		.get = get_car_params
+	},
+	{
+		.version = "5.1",
+		.module_id = PREV_CGS,
+		.module_name = "Chromatic Gain Suppression",
+		.control = 1,
+		.path = IMP_RAW2YUV | IMP_YUV2YUV,
+		.set = set_cgs_params,
+		.get = get_cgs_params
+	}
+};
+
+static struct prev_module_if *prev_enum_preview_cap(void *ipipe,
+				struct device *dev, unsigned index)
+{
+	dev_dbg(dev, "prev_enum_preview_cap: index = %d\n", index);
+
+	if (index < 0 || index >= PREV_MAX_MODULES)
+		return NULL;
+
+	return &prev_modules[index];
+}
+
+static int ipipe_set_oper_mode(void *ipipe, unsigned int mode)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	if (oper_state->oper_mode == IMP_MODE_NOT_CONFIGURED)
+		oper_state->oper_mode = mode;
+	else {
+		printk(KERN_ERR "IPIPE is already active!\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void ipipe_reset_oper_mode(void *ipipe)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	oper_state->oper_mode = IMP_MODE_NOT_CONFIGURED;
+	oper_state->prev_config_state = STATE_NOT_CONFIGURED;
+	oper_state->rsz_config_state = STATE_NOT_CONFIGURED;
+	oper_state->rsz_chained = 0;
+}
+
+static unsigned int prev_get_oper_mode(void *ipipe)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return oper_state->oper_mode;
+}
+
+static unsigned int ipipe_get_oper_state(void *ipipe)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return oper_state->state;
+}
+
+static void ipipe_set_oper_state(void *ipipe, unsigned int state)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	mutex_lock(&oper_state->lock);
+	oper_state->state = state;
+	mutex_unlock(&oper_state->lock);
+}
+
+static unsigned int ipipe_get_prev_config_state(void *ipipe)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return oper_state->prev_config_state;
+}
+
+static unsigned int ipipe_get_rsz_config_state(void *ipipe)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return oper_state->rsz_config_state;
+}
+
+/* function: calculate_normal_f_div_param
+ * Algorithm to calculate the frame division parameters for resizer.
+ * in normal mode. Please refer the application note in DM360 functional
+ * spec for details of the algorithm
+ */
+static int calculate_normal_f_div_param(struct device *dev,
+					int input_width,
+					int output_width,
+					struct ipipe_rsz_rescale_param *param)
+{
+	/* rsz = R, input_width = H, output width = h in the equation */
+	unsigned int val1;
+	unsigned int rsz;
+	unsigned int val;
+	unsigned int h1;
+	unsigned int h2;
+	unsigned int o;
+
+	if (output_width > input_width) {
+		dev_err(dev, "frame div mode is used for scale down only\n");
+		return -EINVAL;
+	}
+
+	rsz = (input_width << 8) / output_width;
+	val = rsz << 1;
+	val = ((input_width << 8) / val) + 1;
+	o = 14;
+	if (!(val % 2)) {
+		h1 = val;
+	} else {
+		val = (input_width << 7);
+		val -= (rsz >> 1);
+		val /= (rsz << 1);
+		val <<= 1;
+		val += 2;
+		o += ((CEIL(rsz, 1024)) << 1);
+		h1 = val;
+	}
+	h2 = output_width - h1;
+	/* phi */
+	val = (h1 * rsz) - (((input_width >> 1) - o) << 8);
+	/* skip */
+	val1 = ((val - 1024) >> 9) << 1;
+	param->f_div.num_passes = IPIPE_MAX_PASSES;
+	param->f_div.pass[0].o_hsz = h1 - 1;
+	param->f_div.pass[0].i_hps = 0;
+	param->f_div.pass[0].h_phs = 0;
+	param->f_div.pass[0].src_hps = 0;
+	param->f_div.pass[0].src_hsz = (input_width >> 2) + o;
+	param->f_div.pass[1].o_hsz = h2 - 1;
+	param->f_div.pass[1].i_hps = val1;
+	param->f_div.pass[1].h_phs = (val - (val1 << 8));
+	param->f_div.pass[1].src_hps = (input_width >> 2) - o;
+	param->f_div.pass[1].src_hsz = (input_width >> 2) + o;
+
+	return 0;
+}
+
+/* function: calculate_down_scale_f_div_param
+ * Algorithm to calculate the frame division parameters for resizer in
+ * downscale mode. Please refer the application note in DM360 functional
+ * spec for details of the algorithm
+ */
+static int calculate_down_scale_f_div_param(struct device *dev,
+					    int input_width,
+					    int output_width,
+					    struct ipipe_rsz_rescale_param
+					    *param)
+{
+	/* rsz = R, input_width = H, output width = h in the equation */
+	unsigned int two_power;
+	unsigned int upper_h1;
+	unsigned int upper_h2;
+	unsigned int val1;
+	unsigned int val;
+	unsigned int rsz;
+	unsigned int h1;
+	unsigned int h2;
+	unsigned int o;
+	unsigned int n;
+
+	upper_h1 = input_width >> 1;
+	n = param->h_dscale_ave_sz;
+	/* 2 ^ (scale+1) */
+	two_power = 1 << (n + 1);
+	upper_h1 = (upper_h1 >> (n + 1)) << (n + 1);
+	upper_h2 = input_width - upper_h1;
+	if (upper_h2 % two_power) {
+		dev_err(dev, "frame halves to be a multiple of 2 power n+1\n");
+		return -EINVAL;
+	}
+	two_power = 1 << n;
+	rsz = (input_width << 8) / output_width;
+	val = rsz * two_power;
+	val = ((upper_h1 << 8) / val) + 1;
+	if (!(val % 2))
+		h1 = val;
+	else {
+		val = (upper_h1 << 8);
+		val >>= (n + 1);
+		val -= (rsz >> 1);
+		val /= (rsz << 1);
+		val <<= 1;
+		val += 2;
+		h1 = val;
+	}
+	o = 10 + (two_power << 2);
+	if (((input_width << 7) / rsz) % 2)
+		o += (((CEIL(rsz, 1024)) << 1) << n);
+	h2 = output_width - h1;
+	/* phi */
+	val = (h1 * rsz) - (((upper_h1 - (o - 10)) / two_power) << 8);
+	/* skip */
+	val1 = ((val - 1024) >> 9) << 1;
+	param->f_div.num_passes = IPIPE_MAX_PASSES;
+	param->f_div.pass[0].o_hsz = h1 - 1;
+	param->f_div.pass[0].i_hps = 0;
+	param->f_div.pass[0].h_phs = 0;
+	param->f_div.pass[0].src_hps = 0;
+	param->f_div.pass[0].src_hsz = upper_h1 + o;
+	param->f_div.pass[1].o_hsz = h2 - 1;
+	param->f_div.pass[1].i_hps = 10 + (val1 * two_power);
+	param->f_div.pass[1].h_phs = (val - (val1 << 8));
+	param->f_div.pass[1].src_hps = (upper_h1 - o);
+	param->f_div.pass[1].src_hsz = (upper_h2 + o);
+
+	return 0;
+}
+
+/* update the parameter in param for a given input and output width */
+static int update_preview_f_div_params(struct device *dev,
+				       int input_width,
+				       int output_width,
+				       struct ipipe_rsz_rescale_param *param)
+{
+	unsigned int val;
+
+	val = input_width >> 1;
+	if (val < 8) {
+		dev_err(dev, "input width must me atleast 16 pixels\n");
+		return -EINVAL;
+	}
+	param->f_div.en = 1;
+	param->f_div.num_passes = IPIPE_MAX_PASSES;
+	param->f_div.pass[0].o_hsz = val;
+	param->f_div.pass[0].i_hps = 0;
+	param->f_div.pass[0].h_phs = 0;
+	param->f_div.pass[0].src_hps = 0;
+	param->f_div.pass[0].src_hsz = val + 10;
+	param->f_div.pass[1].o_hsz = val;
+	param->f_div.pass[1].i_hps = 0;
+	param->f_div.pass[1].h_phs = 0;
+	param->f_div.pass[1].src_hps = val - 8;
+	param->f_div.pass[1].src_hsz = val + 10;
+
+	return 0;
+}
+
+/* Use shared to allocate exclusive blocks as required
+ * by resize applications in single shot mode
+ */
+static void *ipipe_alloc_config_block(void *ipipe, struct device *dev)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	/* return common data block */
+	mutex_lock(&oper_state->lock);
+	if (oper_state->resource_in_use) {
+		dev_err(dev, "resource in use\n");
+		mutex_unlock(&oper_state->lock);
+		return NULL;
+	}
+	mutex_unlock(&oper_state->lock);
+
+	return oper_state->shared_config_param;
+}
+
+/* Used to free only non-shared config block allocated through
+ * imp_alloc_config_block
+ */
+static void ipipe_dealloc_config_block(void *ipipe, struct device *dev,
+					void *config_block)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	if (!config_block)
+		return;
+
+	if (config_block != oper_state->shared_config_param)
+		kfree(config_block);
+	else
+		dev_err(dev, "Trying to free shared config block\n");
+}
+
+static void ipipe_dealloc_user_config_block(void *ipipe,
+				struct device *dev, void *config_block)
+{
+	kfree(config_block);
+}
+
+static void *ipipe_alloc_user_config_block(void *ipipe, struct device *dev,
+					   enum imp_log_chan_t chan_type,
+					   int *len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	void *config = NULL;
+
+	if (oper_state->oper_mode == IMP_MODE_SINGLE_SHOT) {
+		if (chan_type == IMP_PREVIEWER) {
+			config =
+			    kmalloc(sizeof(struct prev_single_shot_config),
+				    GFP_KERNEL);
+			*len = sizeof(struct prev_single_shot_config);
+		} else if (chan_type == IMP_RESIZER) {
+			config =
+			    kmalloc(sizeof(struct rsz_single_shot_config),
+				    GFP_KERNEL);
+			*len = sizeof(struct rsz_single_shot_config);
+		}
+
+	} else {
+		if (chan_type == IMP_PREVIEWER) {
+			config =
+			    kmalloc(sizeof(struct prev_continuous_config),
+				    GFP_KERNEL);
+			*len = sizeof(struct prev_continuous_config);
+		} else if (chan_type == IMP_RESIZER) {
+			config =
+			    kmalloc(sizeof(struct rsz_continuous_config),
+				    GFP_KERNEL);
+			*len = sizeof(struct rsz_continuous_config);
+		}
+	}
+
+	return config;
+}
+
+static void ipipe_set_user_config_defaults(void *ipipe, struct device *dev,
+					   enum imp_log_chan_t chan_type,
+					   void *config)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	dev_dbg(dev, "ipipe_set_user_config_defaults\n");
+
+	if (oper_state->oper_mode == IMP_MODE_SINGLE_SHOT) {
+		if (chan_type == IMP_PREVIEWER) {
+			dev_dbg(dev, "SS-Preview\n");
+			/* preview channel in single shot mode */
+			memcpy(config,
+			       (void *)&dm365_prev_ss_config_defs,
+			       sizeof(struct prev_single_shot_config));
+		} else {
+			dev_dbg(dev, "SS-Resize\n");
+			/* resizer channel in single shot mode */
+			memcpy(config,
+			       (void *)&dm365_rsz_ss_config_defs,
+			       sizeof(struct rsz_single_shot_config));
+		}
+	} else if (oper_state->oper_mode == IMP_MODE_CONTINUOUS) {
+		/* Continuous mode */
+		if (chan_type == IMP_PREVIEWER) {
+			dev_dbg(dev, "Cont Preview\n");
+			/* previewer defaults */
+			memcpy(config,
+			       (void *)&dm365_prev_cont_config_defs,
+			       sizeof(struct prev_continuous_config));
+		} else {
+			dev_dbg(dev, "Cont resize\n");
+			/* resizer defaults */
+			memcpy(config,
+			       (void *)&dm365_rsz_cont_config_defs,
+			       sizeof(struct rsz_continuous_config));
+		}
+	} else
+		dev_err(dev, "Incorrect mode used\n");
+}
+
+/* function :calculate_sdram_offsets()
+ *	This function calculates the offsets from start of buffer for the C
+ *	plane when output format is YUV420SP. It also calculates the offsets
+ *	from the start of the buffer when the image is flipped vertically
+ *	or horizontally for ycbcr/y/c planes
+ */
+static int calculate_sdram_offsets(struct ipipe_params *param, int index)
+{
+	int bytesperpixel = 2;
+	int image_height;
+	int image_width;
+	int yuv_420;
+	int offset;
+
+	if (!param->rsz_en[index])
+		return -EINVAL;
+
+	image_height = param->rsz_rsc_param[index].o_vsz + 1;
+	image_width = param->rsz_rsc_param[index].o_hsz + 1;
+	param->ext_mem_param[index].c_offset = 0;
+	param->ext_mem_param[index].flip_ofst_y = 0;
+	param->ext_mem_param[index].flip_ofst_c = 0;
+	if (param->ipipe_dpaths_fmt != IPIPE_RAW2RAW &&
+		param->ipipe_dpaths_fmt != IPIPE_RAW2BOX &&
+		param->rsz_rsc_param[index].cen &&
+		param->rsz_rsc_param[index].yen) {
+		/* YUV 420 */
+		yuv_420 = 1;
+		bytesperpixel = 1;
+	}
+
+	/* set offset value */
+	offset = 0;
+
+	if (param->rsz_rsc_param[index].h_flip)
+		/* width * bytesperpixel - 1 */
+		offset = (image_width * bytesperpixel) - 1;
+	if (param->rsz_rsc_param[index].v_flip)
+		offset += (image_height - 1) *
+			param->ext_mem_param[index].rsz_sdr_oft_y;
+	param->ext_mem_param[index].flip_ofst_y = offset;
+	if (yuv_420) {
+		offset = 0;
+		/* half height for c-plane */
+		if (param->rsz_rsc_param[index].h_flip)
+			/* width * bytesperpixel - 1 */
+			offset = image_width - 1;
+		if (param->rsz_rsc_param[index].v_flip)
+			offset += (((image_height >> 1) - 1) *
+			param->ext_mem_param[index].
+			rsz_sdr_oft_c);
+		param->ext_mem_param[index].flip_ofst_c =
+			offset;
+		param->ext_mem_param[index].c_offset =
+		    param->ext_mem_param[index].
+		    rsz_sdr_oft_y * image_height;
+	}
+
+	return 0;
+}
+
+static void enable_422_420_conversion(struct ipipe_params *param,
+				      int index, boolean_t en)
+{
+	/* Enable 422 to 420 conversion */
+	param->rsz_rsc_param[index].cen = en;
+	param->rsz_rsc_param[index].yen = en;
+}
+
+static void configure_resizer_out_params(struct ipipe_params *param,
+					int index,
+					void *output_spec,
+					unsigned char partial, unsigned flag)
+{
+	struct rsz_output_spec *output;
+
+	if (partial) {
+		struct rsz_part_output_spec *partial_output =
+		    (struct rsz_part_output_spec *)output_spec;
+
+		if (!partial_output->enable) {
+			param->rsz_en[index] = DISABLE;
+			return;
+		}
+
+		param->rsz_en[index] = ENABLE;
+		param->rsz_rsc_param[index].h_flip =
+		    partial_output->h_flip;
+		param->rsz_rsc_param[index].v_flip =
+		    partial_output->v_flip;
+		param->rsz_rsc_param[index].v_typ_y =
+		    partial_output->v_typ_y;
+		param->rsz_rsc_param[index].v_typ_c =
+		    partial_output->v_typ_c;
+		param->rsz_rsc_param[index].v_lpf_int_y =
+		    partial_output->v_lpf_int_y;
+		param->rsz_rsc_param[index].v_lpf_int_c =
+		    partial_output->v_lpf_int_c;
+		param->rsz_rsc_param[index].h_typ_y =
+		    partial_output->h_typ_y;
+		param->rsz_rsc_param[index].h_typ_c =
+		    partial_output->h_typ_c;
+		param->rsz_rsc_param[index].h_lpf_int_y =
+		    partial_output->h_lpf_int_y;
+		param->rsz_rsc_param[index].h_lpf_int_c =
+		    partial_output->h_lpf_int_c;
+		param->rsz_rsc_param[index].dscale_en =
+		    partial_output->en_down_scale;
+		param->rsz_rsc_param[index].h_dscale_ave_sz =
+		    partial_output->h_dscale_ave_sz;
+		param->rsz_rsc_param[index].v_dscale_ave_sz =
+		    partial_output->v_dscale_ave_sz;
+		param->ext_mem_param[index].user_y_ofst =
+		    (partial_output->user_y_ofst + 31) & ~0x1f;
+		param->ext_mem_param[index].user_c_ofst =
+		    (partial_output->user_c_ofst + 31) & ~0x1f;
+
+		return;
+	}
+
+	output = (struct rsz_output_spec *)output_spec;
+
+	if (!output->enable) {
+		param->rsz_en[index] = DISABLE;
+		return;
+	}
+
+	param->rsz_en[index] = ENABLE;
+	param->rsz_rsc_param[index].o_vsz = output->height - 1;
+	param->rsz_rsc_param[index].o_hsz = output->width - 1;
+	param->ext_mem_param[index].rsz_sdr_ptr_s_y =
+	    output->vst_y;
+	param->ext_mem_param[index].rsz_sdr_ptr_e_y =
+	    output->height;
+	param->ext_mem_param[index].rsz_sdr_ptr_s_c =
+	    output->vst_c;
+	param->ext_mem_param[index].rsz_sdr_ptr_e_c =
+	    output->height;
+
+	if (!flag)
+		return;
+
+	/* update common parameters */
+	param->rsz_rsc_param[index].h_flip =
+	    output->h_flip;
+	param->rsz_rsc_param[index].v_flip =
+	    output->v_flip;
+	param->rsz_rsc_param[index].v_typ_y =
+	    output->v_typ_y;
+	param->rsz_rsc_param[index].v_typ_c =
+	    output->v_typ_c;
+	param->rsz_rsc_param[index].v_lpf_int_y =
+	    output->v_lpf_int_y;
+	param->rsz_rsc_param[index].v_lpf_int_c =
+	    output->v_lpf_int_c;
+	param->rsz_rsc_param[index].h_typ_y =
+	    output->h_typ_y;
+	param->rsz_rsc_param[index].h_typ_c =
+	    output->h_typ_c;
+	param->rsz_rsc_param[index].h_lpf_int_y =
+	    output->h_lpf_int_y;
+	param->rsz_rsc_param[index].h_lpf_int_c =
+	    output->h_lpf_int_c;
+	param->rsz_rsc_param[index].dscale_en =
+	    output->en_down_scale;
+	param->rsz_rsc_param[index].h_dscale_ave_sz =
+	    output->h_dscale_ave_sz;
+	param->rsz_rsc_param[index].v_dscale_ave_sz =
+	    output->h_dscale_ave_sz;
+	param->ext_mem_param[index].user_y_ofst =
+	    (output->user_y_ofst + 31) & ~0x1f;
+	param->ext_mem_param[index].user_c_ofst =
+	    (output->user_c_ofst + 31) & ~0x1f;
+
+}
+
+/* function :calculate_line_length()
+ *	This function calculates the line length of various image
+ *	planes at the input and output
+ */
+static void calculate_line_length(enum v4l2_mbus_pixelcode pix,
+				 int width,
+				 int height, int *line_len, int *line_len_c)
+{
+	*line_len = 0;
+	*line_len_c = 0;
+
+	if (pix == V4L2_MBUS_FMT_UYVY8_1X16 ||
+				pix == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE)
+		*line_len = width << 1;
+	else if (pix == V4L2_MBUS_FMT_Y8_1X8 || pix == V4L2_MBUS_FMT_C4_1X8) {
+		*line_len = width;
+		*line_len_c = width;
+	} else {
+		/* YUV 420 */
+		/* round width to upper 32 byte boundary */
+		*line_len = width;
+		*line_len_c = width;
+	}
+	/* adjust the line len to be a multiple of 32 */
+	*line_len += 31;
+	*line_len &= ~0x1f;
+	*line_len_c += 31;
+	*line_len_c &= ~0x1f;
+}
+
+static inline int rsz_validate_input_image_format(struct device *dev,
+						  enum v4l2_mbus_pixelcode pix,
+						  int width,
+						  int height, int *line_len)
+{
+	int val;
+
+	if (pix != V4L2_MBUS_FMT_UYVY8_1X16 && pix != V4L2_MBUS_FMT_Y8_1X8 &&
+		pix != V4L2_MBUS_FMT_C4_1X8) {
+		dev_err(dev,
+			"rsz_validate_out_pix_formats"
+			"pix format not supported, %d\n", pix);
+		return -EINVAL;
+	}
+
+	if (width == 0 || height == 0) {
+		dev_err(dev, "validate_line_length: invalid "
+				"width or height\n");
+		return -EINVAL;
+	}
+
+	if (pix == V4L2_MBUS_FMT_C4_1X8)
+		calculate_line_length(pix,
+				      width,
+				      height,
+				      &val,
+				      line_len);
+	else
+		calculate_line_length(pix,
+				      width,
+				      height,
+				      line_len,
+				      &val);
+
+	return 0;
+}
+
+static inline int rsz_validate_output_image_format(struct device *dev,
+						   enum v4l2_mbus_pixelcode pix,
+						   int width,
+						   int height,
+						   int *in_line_len,
+						   int *in_line_len_c)
+{
+	if (pix != V4L2_MBUS_FMT_UYVY8_1X16 && pix != V4L2_MBUS_FMT_Y8_1X8 &&
+		pix != V4L2_MBUS_FMT_C4_1X8 &&
+		pix != V4L2_MBUS_FMT_YUV420SP8_1X8 &&
+		pix != V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE) {
+		dev_err(dev,
+			"rsz_validate_out_pix_formats"
+			"pix format not supported, %d\n", pix);
+		return -EINVAL;
+	}
+
+	if (width == 0 || height == 0) {
+		dev_err(dev, "validate_line_length: invalid"
+				" width or height\n");
+		return -EINVAL;
+	}
+
+	calculate_line_length(pix,
+			      width,
+			      height, in_line_len, in_line_len_c);
+	return 0;
+}
+
+static void configure_common_rsz_params(struct device *dev,
+			struct ipipe_params *param,
+			struct rsz_single_shot_config *ss_config)
+{
+	param->rsz_common.yuv_y_min = ss_config->yuv_y_min;
+	param->rsz_common.yuv_y_max = ss_config->yuv_y_max;
+	param->rsz_common.yuv_c_min = ss_config->yuv_c_min;
+	param->rsz_common.yuv_c_max = ss_config->yuv_c_max;
+	param->rsz_common.out_chr_pos = ss_config->out_chr_pos;
+	param->rsz_common.rsz_seq_crv = ss_config->chroma_sample_even;
+
+}
+
+static int configure_common_rsz_in_params(struct device *dev,
+					  struct ipipe_params *param,
+					  int flag, int rsz_chained,
+					  void *input_spec)
+{
+	enum v4l2_mbus_pixelcode pix;
+
+	if (!flag) {
+		struct prev_ss_input_spec *in_specs =
+		    (struct prev_ss_input_spec *)input_spec;
+		param->rsz_common.vsz = in_specs->image_height - 1;
+		param->rsz_common.hsz = in_specs->image_width - 1;
+		pix = in_specs->pix_fmt;
+	} else {
+		struct rsz_ss_input_spec *in_specs =
+		    (struct rsz_ss_input_spec *)input_spec;
+		if (!rsz_chained) {
+			param->rsz_common.vps = in_specs->vst;
+			param->rsz_common.hps = in_specs->hst;
+		}
+		param->rsz_common.vsz = in_specs->image_height - 1;
+		param->rsz_common.hsz = in_specs->image_width - 1;
+		pix = in_specs->pix_fmt;
+	}
+	switch (pix) {
+	case V4L2_MBUS_FMT_SBGGR8_1X8:
+	case V4L2_MBUS_FMT_SRGGB10_ALAW8_1X8:
+	case V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8:
+	case V4L2_MBUS_FMT_SBGGR12_1X12:
+	case V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE:
+		param->rsz_common.src_img_fmt = RSZ_IMG_422;
+		param->rsz_common.source = IPIPE_DATA;
+		break;
+	case V4L2_MBUS_FMT_UYVY8_1X16:
+		param->rsz_common.src_img_fmt = RSZ_IMG_422;
+		if (rsz_chained)
+			param->rsz_common.source = IPIPE_DATA;
+		else
+			param->rsz_common.source = IPIPEIF_DATA;
+		param->rsz_common.raw_flip = 0;
+		break;
+	case V4L2_MBUS_FMT_Y8_1X8:
+		param->rsz_common.src_img_fmt = RSZ_IMG_420;
+		/* Select y */
+		param->rsz_common.y_c = 0;
+		param->rsz_common.source = IPIPEIF_DATA;
+		param->rsz_common.raw_flip = 0;
+		break;
+	case V4L2_MBUS_FMT_C4_1X8:
+		param->rsz_common.src_img_fmt = RSZ_IMG_420;
+		/* Select y */
+		param->rsz_common.y_c = 1;
+		param->rsz_common.source = IPIPEIF_DATA;
+		param->rsz_common.raw_flip = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int validate_ipipeif_decimation(struct device *dev,
+				       enum ipipeif_decimation dec_en,
+				       unsigned char rsz,
+				       unsigned char frame_div_mode_en,
+				       int width)
+{
+	if (dec_en && frame_div_mode_en) {
+		dev_err(dev,
+			"Both dec_en & frame_div_mode_en"
+			"can not enabled simultaneously\n");
+		return -EINVAL;
+	}
+	if (frame_div_mode_en) {
+		dev_err(dev, "frame_div_mode mode not supported");
+		return -EINVAL;
+	}
+
+	if (!dec_en)
+		return 0;
+
+	if (width <= IPIPE_MAX_INPUT_WIDTH) {
+		dev_err(dev,
+			"image width to be more than"
+			" %d for decimation\n", IPIPE_MAX_INPUT_WIDTH);
+		return -EINVAL;
+	}
+	if ((rsz < IPIPEIF_RSZ_MIN) || (rsz > IPIPEIF_RSZ_MAX)) {
+		dev_err(dev, "rsz range is %d to %d\n",
+			IPIPEIF_RSZ_MIN, IPIPEIF_RSZ_MAX);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int configure_resizer_in_ss_mode(struct ipipe_oper_state *oper_state,
+					struct device *dev,
+					void *user_config,
+					int resizer_chained,
+					struct ipipe_params *param)
+{
+	/* resizer in standalone mode. In this mode if serializer
+	 * is enabled, we need to set config params in the hw.
+	 */
+	struct rsz_single_shot_config *ss_config =
+	    (struct rsz_single_shot_config *)user_config;
+	int line_len_c;
+	int line_len;
+	int ret;
+
+	ret = rsz_validate_input_image_format(dev,
+					      ss_config->input.pix_fmt,
+					      ss_config->input.image_width,
+					      ss_config->input.image_height,
+					      &line_len);
+
+	if (ret)
+		return -EINVAL;
+
+	/* shared block */
+	if ((!ss_config->output1.enable) && (!ss_config->output2.enable)) {
+		dev_err(dev, "One of the resizer output must be enabled\n");
+		return -EINVAL;
+	}
+	ret = mutex_lock_interruptible(&oper_state->lock);
+	if (ret)
+		return ret;
+	if (!ss_config->input.line_length)
+		param->ipipeif_param.adofs = line_len;
+	else {
+		param->ipipeif_param.adofs = ss_config->input.line_length;
+		param->ipipeif_param.adofs =
+				(param->ipipeif_param.adofs + 31) & ~0x1f;
+	}
+	if (ss_config->output1.enable) {
+		param->rsz_en[RSZ_A] = ENABLE;
+		param->rsz_rsc_param[RSZ_A].mode = IPIPEIF_ONE_SHOT;
+		ret = rsz_validate_output_image_format(dev,
+					ss_config->output1.pix_fmt,
+					ss_config->output1.width,
+					ss_config->output1.height,
+					&line_len, &line_len_c);
+		if (ret) {
+			mutex_unlock(&oper_state->lock);
+			return ret;
+		}
+		param->ext_mem_param[RSZ_A].rsz_sdr_oft_y = line_len;
+		param->ext_mem_param[RSZ_A].rsz_sdr_oft_c = line_len_c;
+		configure_resizer_out_params(param,
+						   RSZ_A,
+						   &ss_config->output1,
+						   0,
+						   1);
+
+		if (ss_config->output1.pix_fmt ==
+					V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE)
+			param->rsz_common.raw_flip = 1;
+		else
+			param->rsz_common.raw_flip = 0;
+
+		if (ss_config->output1.pix_fmt == V4L2_MBUS_FMT_YUV420SP8_1X8)
+			enable_422_420_conversion(param, RSZ_A, ENABLE);
+		else
+			enable_422_420_conversion(param, RSZ_A,
+							  DISABLE);
+	}
+
+	if (ss_config->output2.enable) {
+		param->rsz_en[RSZ_A] = ENABLE;
+		param->rsz_rsc_param[RSZ_B].mode = IPIPEIF_ONE_SHOT;
+		ret = rsz_validate_output_image_format(dev,
+					ss_config->output2.pix_fmt,
+					ss_config->output2.width,
+					ss_config->output2.height,
+					&line_len, &line_len_c);
+		if (ret) {
+			mutex_unlock(&oper_state->lock);
+			return ret;
+		}
+		param->ext_mem_param[RSZ_B].rsz_sdr_oft_y = line_len;
+		param->ext_mem_param[RSZ_B].rsz_sdr_oft_c = line_len_c;
+		configure_resizer_out_params(param,
+						   RSZ_B,
+						   &ss_config->output2,
+						   0,
+						   1);
+		if (ss_config->output2.pix_fmt == V4L2_MBUS_FMT_YUV420SP8_1X8)
+			enable_422_420_conversion(param, RSZ_B, ENABLE);
+		else
+			enable_422_420_conversion(param,
+						  RSZ_B,
+						  DISABLE);
+	}
+	configure_common_rsz_params(dev, param, ss_config);
+	if (resizer_chained) {
+		oper_state->rsz_chained = 1;
+		oper_state->rsz_config_state = STATE_CONFIGURED;
+	} else {
+		oper_state->rsz_chained = 0;
+		ret = validate_ipipeif_decimation(dev,
+						  ss_config->input.dec_en,
+						  ss_config->input.rsz,
+						  ss_config->input.
+						  frame_div_mode_en,
+						  ss_config->input.
+						  image_width);
+		if (ret) {
+			mutex_unlock(&oper_state->lock);
+			return ret;
+		}
+
+		if (ipipe_process_pix_fmts(ss_config->input.pix_fmt,
+				   ss_config->output1.pix_fmt,
+				   param) < 0) {
+			dev_err(dev, "error in input or output pix format\n");
+			mutex_unlock(&oper_state->lock);
+			return -EINVAL;
+		}
+
+		param->ipipeif_param.source = IPIPEIF_SDRAM_YUV;
+		param->ipipeif_param.glob_hor_size = ss_config->input.ppln;
+		param->ipipeif_param.glob_ver_size = ss_config->input.lpfr;
+		param->ipipeif_param.hnum = ss_config->input.image_width;
+		param->ipipeif_param.vnum = ss_config->input.image_height;
+		param->ipipeif_param.var.if_5_1.clk_div =
+		    ss_config->input.clk_div;
+		if (ss_config->input.dec_en) {
+			param->ipipeif_param.decimation = IPIPEIF_DECIMATION_ON;
+			param->ipipeif_param.rsz = ss_config->input.rsz;
+			param->ipipeif_param.avg_filter =
+			    (enum ipipeif_avg_filter)ss_config->input.
+			    avg_filter_en;
+			param->ipipe_hsz =
+			    (((ss_config->input.image_width *
+			       IPIPEIF_RSZ_CONST) / ss_config->input.rsz) - 1);
+		}
+		if (ss_config->input.pix_fmt == V4L2_MBUS_FMT_Y8_1X8 ||
+		  ss_config->input.pix_fmt == V4L2_MBUS_FMT_C4_1X8) {
+			param->ipipeif_param.var.if_5_1.pack_mode
+				= IPIPEIF_5_1_PACK_8_BIT;
+			param->ipipeif_param.var.if_5_1.source1 = IPIPEIF_CCDC;
+			param->ipipeif_param.var.if_5_1.isif_port.if_type
+				= V4L2_MBUS_FMT_YUYV8_1X16;
+			param->ipipeif_param.var.if_5_1.data_shift
+				= IPIPEIF_5_1_BITS11_0;
+
+			param->ipipeif_param.source = IPIPEIF_SDRAM_RAW;
+
+
+		}
+		if (ss_config->input.pix_fmt == V4L2_MBUS_FMT_C4_1X8)
+			param->ipipeif_param.var.if_5_1.isif_port.if_type
+				= V4L2_MBUS_FMT_SBGGR10_1X10;
+		param->ipipe_hsz = ss_config->input.image_width - 1;
+		param->ipipe_vsz = ss_config->input.image_height - 1;
+		param->ipipe_vps = ss_config->input.vst;
+		param->ipipe_hps = ss_config->input.hst;
+		param->ipipe_dpaths_fmt = IPIPE_YUV2YUV;
+		configure_common_rsz_in_params(dev, param, 1, resizer_chained,
+					       &ss_config->input);
+		if (param->rsz_en[RSZ_A]) {
+
+			calculate_resize_ratios(param, RSZ_A);
+			calculate_sdram_offsets(param, RSZ_A);
+
+			/* Overriding resize ratio calculation */
+			if (ss_config->input.pix_fmt == V4L2_MBUS_FMT_C4_1X8) {
+				param->rsz_rsc_param[RSZ_A].v_dif =
+				    (((param->ipipe_vsz + 1) * 2) * 256) /
+				    (param->rsz_rsc_param[RSZ_A].o_vsz + 1);
+			}
+		}
+
+		if (param->rsz_en[RSZ_B]) {
+			calculate_resize_ratios(param, RSZ_B);
+			calculate_sdram_offsets(param, RSZ_B);
+
+			/* Overriding resize ratio calculation */
+			if (ss_config->input.pix_fmt == V4L2_MBUS_FMT_C4_1X8) {
+				param->rsz_rsc_param[RSZ_B].v_dif =
+				    (((param->ipipe_vsz + 1) * 2) * 256) /
+				    (param->rsz_rsc_param[RSZ_B].o_vsz + 1);
+			}
+		}
+	}
+	mutex_unlock(&oper_state->lock);
+
+	return 0;
+}
+
+static int configure_resizer_in_cont_mode(struct ipipe_oper_state *oper_state,
+					  struct device *dev,
+					  void *user_config,
+					  int resizer_chained,
+					  struct ipipe_params *param)
+{
+	/* Continuous mode. This is a shared config block */
+	struct rsz_continuous_config *cont_config =
+	    (struct rsz_continuous_config *)user_config;
+	int line_len_c;
+	int line_len;
+	int ret;
+
+	if (!resizer_chained) {
+		dev_err(dev, "Resizer cannot be configured in standalone"
+			"for continuous mode\n");
+		return -EINVAL;
+	}
+
+	ret = mutex_lock_interruptible(&oper_state->lock);
+	if (ret)
+		return ret;
+	if (!cont_config->output1.enable) {
+		dev_err(dev, "enable resizer - 0\n");
+		mutex_unlock(&oper_state->lock);
+		return -EINVAL;
+	}
+	param->rsz_en[RSZ_A] = ENABLE;
+	param->rsz_rsc_param[RSZ_A].mode = IPIPEIF_CONTINUOUS;
+	configure_resizer_out_params(param,
+				     RSZ_A,
+				     &cont_config->output1,
+				     1,
+				     0);
+	param->rsz_en[RSZ_B] = DISABLE;
+
+	if (cont_config->output2.enable) {
+		param->rsz_rsc_param[RSZ_B].mode = IPIPEIF_CONTINUOUS;
+		ret = rsz_validate_output_image_format(dev,
+						       cont_config->output2.
+						       pix_fmt,
+						       cont_config->output2.
+						       width,
+						       cont_config->output2.
+						       height,
+						       &line_len,
+						       &line_len_c);
+		if (ret) {
+			mutex_unlock(&oper_state->lock);
+			return ret;
+		}
+		param->ext_mem_param[RSZ_B].rsz_sdr_oft_y = line_len;
+		param->ext_mem_param[RSZ_B].rsz_sdr_oft_c = line_len_c;
+		configure_resizer_out_params(param,
+					     RSZ_B,
+					     &cont_config->output2,
+					     0,
+					     1);
+		if (cont_config->output2.pix_fmt == V4L2_MBUS_FMT_YUV420SP8_1X8)
+			enable_422_420_conversion(param,
+						  RSZ_B, ENABLE);
+		else
+			enable_422_420_conversion(param,
+						  RSZ_B, DISABLE);
+	}
+	oper_state->rsz_chained = 1;
+	oper_state->rsz_config_state = STATE_CONFIGURED;
+	mutex_unlock(&oper_state->lock);
+
+	return 0;
+}
+static int ipipe_set_resize_config(void *ipipe, struct device *dev,
+				   int resizer_chained,
+				   void *user_config, void *config)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct ipipe_params *param = (struct ipipe_params *)config;
+	int ret;
+
+	dev_dbg(dev, "ipipe_set_resize_config, resizer_chained = %d\n",
+		resizer_chained);
+	if (!user_config || !config) {
+		dev_err(dev, "Invalid user_config or config ptr\n");
+		return -EINVAL;
+	}
+
+	memcpy((void *)config,
+	       (void *)&dm365_ipipe_defs,
+	       sizeof(struct ipipe_params));
+
+	if (oper_state->oper_mode != IMP_MODE_SINGLE_SHOT)
+		return configure_resizer_in_cont_mode(oper_state, dev,
+						      user_config,
+						      resizer_chained,
+						      param);
+
+	ret = configure_resizer_in_ss_mode(oper_state, dev,
+					    user_config,
+					    resizer_chained,
+					    param);
+	if (!ret && (!oper_state->en_serializer && !resizer_chained))
+		ret = ipipe_hw_setup(config);
+
+	return ret;
+}
+
+static void configure_resize_passthru(struct ipipe_params *param, int bypass)
+{
+	param->rsz_rsc_param[RSZ_A].cen = DISABLE;
+	param->rsz_rsc_param[RSZ_A].yen = DISABLE;
+	param->rsz_rsc_param[RSZ_A].v_phs_y = 0;
+	param->rsz_rsc_param[RSZ_A].v_phs_c = 0;
+	param->rsz_rsc_param[RSZ_A].v_dif = 256;
+	param->rsz_rsc_param[RSZ_A].v_lpf_int_y = 0;
+	param->rsz_rsc_param[RSZ_A].v_lpf_int_c = 0;
+	param->rsz_rsc_param[RSZ_A].h_phs = 0;
+	param->rsz_rsc_param[RSZ_A].h_dif = 256;
+	param->rsz_rsc_param[RSZ_A].h_lpf_int_y = 0;
+	param->rsz_rsc_param[RSZ_A].h_lpf_int_c = 0;
+	param->rsz_rsc_param[RSZ_A].dscale_en = DISABLE;
+	param->rsz2rgb[RSZ_A].rgb_en = DISABLE;
+	param->rsz_en[RSZ_A] = ENABLE;
+	param->rsz_en[RSZ_B] = DISABLE;
+	if (bypass) {
+		param->rsz_rsc_param[RSZ_A].i_vps = 0;
+		param->rsz_rsc_param[RSZ_A].i_hps = 0;
+		/* Raw Bypass */
+		param->rsz_common.passthrough = IPIPE_BYPASS_ON;
+	}
+}
+
+static inline int prev_validate_output_image_format(struct device *dev,
+					enum v4l2_mbus_pixelcode pix,
+					int *line_len,
+					int in_width, int in_height)
+{
+	if (pix != V4L2_MBUS_FMT_UYVY8_1X16 && pix !=
+				V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE) {
+		dev_err(dev,
+			"prev_validate_output_image_format"
+			"pix format not supported, %d\n", pix);
+		return -EINVAL;
+	}
+
+	if ((in_width == 0) || (in_height == 0)) {
+		dev_err(dev,
+			"prev_validate_output_image_format:"
+			" invalid width or height\n");
+		return -EINVAL;
+	}
+
+	*line_len = in_width * 2;
+
+	/* Adjust line length to be a multiple of 32 */
+	*line_len += 31;
+	*line_len &= ~0x1f;
+
+	return 0;
+}
+
+static inline int validate_preview_input_spec(struct device *dev,
+					      enum v4l2_mbus_pixelcode pix,
+					      int width,
+					      int height, int *line_len)
+{
+	if (pix != V4L2_MBUS_FMT_UYVY8_1X16 &&
+	  pix != V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE &&
+	  pix != V4L2_MBUS_FMT_SBGGR8_1X8 &&
+	  pix != V4L2_MBUS_FMT_SRGGB10_ALAW8_1X8 &&
+	  pix != V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8 &&
+	  pix != V4L2_MBUS_FMT_SBGGR12_1X12) {
+		dev_err(dev,
+			"validate_preview_input_spec:"
+			"pix format not supported, %d\n", pix);
+		return -EINVAL;
+	}
+	if (width == 0 || height == 0) {
+		dev_err(dev,
+			"rsz_validate_out_image_formats: "
+			"invalid width or height\n");
+		return -EINVAL;
+	}
+
+	if (pix == V4L2_MBUS_FMT_UYVY8_1X16 ||
+			pix == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE)
+		*line_len = width * 2;
+	else if (pix == V4L2_MBUS_FMT_SBGGR8_1X8 ||
+		 pix == V4L2_MBUS_FMT_SRGGB10_ALAW8_1X8 ||
+		 pix == V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8)
+		*line_len = width;
+	else
+		/* 12 bit */
+		*line_len = width + (width >> 1);
+	/* Adjust line length to be a multiple of 32 */
+	*line_len += 31;
+	*line_len &= ~0x1f;
+
+	return 0;
+}
+
+static int configure_previewer_in_cont_mode(struct ipipe_oper_state *oper_state,
+					    struct device *dev,
+					    void *user_config,
+					    struct ipipe_params *param)
+{
+	struct prev_continuous_config *cont_config =
+	    (struct prev_continuous_config *)user_config;
+	int ret;
+
+	if (cont_config->input.en_df_sub) {
+		dev_err(dev, "DF suV4L2_MBUS_FMT_SBGGR10_1X10btraction "
+				  "is not supported\n");
+		return -EINVAL;
+	}
+	if (cont_config->input.dec_en && ((cont_config->input.rsz <
+		IPIPEIF_RSZ_MIN) || (cont_config->input.rsz >
+		IPIPEIF_RSZ_MAX))) {
+		dev_err(dev, "rsz range is %d to %d\n",
+			IPIPEIF_RSZ_MIN, IPIPEIF_RSZ_MAX);
+		return -EINVAL;
+	}
+	ret = mutex_lock_interruptible(&oper_state->lock);
+	if (ret)
+		return ret;
+	param->rsz_common.passthrough = cont_config->bypass;
+	param->ipipeif_param.source = IPIPEIF_CCDC;
+	param->ipipeif_param.clock_select = IPIPEIF_PIXCEL_CLK;
+	param->ipipeif_param.mode = IPIPEIF_CONTINUOUS;
+	if (cont_config->input.dec_en) {
+		param->ipipeif_param.decimation = IPIPEIF_DECIMATION_ON;
+		param->ipipeif_param.rsz = cont_config->input.rsz;
+		param->ipipeif_param.avg_filter =
+		    (enum ipipeif_avg_filter)cont_config->input.avg_filter_en;
+	}
+	/* IPIPE mode */
+	param->ipipe_mode = IPIPEIF_CONTINUOUS;
+	param->ipipe_colpat_olop = cont_config->input.colp_olop;
+	param->ipipe_colpat_olep = cont_config->input.colp_olep;
+	param->ipipe_colpat_elop = cont_config->input.colp_elop;
+	param->ipipe_colpat_elep = cont_config->input.colp_elep;
+	param->ipipeif_param.gain = cont_config->input.gain;
+	param->ipipeif_param.var.if_5_1.clip = cont_config->input.clip;
+	param->ipipeif_param.var.if_5_1.dpc = cont_config->input.dpc;
+	param->ipipeif_param.var.if_5_1.align_sync =
+	    cont_config->input.align_sync;
+	param->ipipeif_param.var.if_5_1.rsz_start =
+	    cont_config->input.rsz_start;
+	if (!oper_state->rsz_chained) {
+		param->rsz_rsc_param[0].mode = IPIPEIF_CONTINUOUS;
+		/* setup bypass resizer */
+		configure_resize_passthru(param, 0);
+	}
+	if (cont_config->bypass)
+		configure_resize_passthru(param, 1);
+	oper_state->prev_config_state = STATE_CONFIGURED;
+	mutex_unlock(&oper_state->lock);
+
+	return 0;
+}
+
+static int configure_previewer_in_ss_mode(struct ipipe_oper_state *oper_state,
+					  struct device *dev,
+					  void *user_config,
+					  struct ipipe_params *param)
+{
+	struct prev_single_shot_config *ss_config =
+	    (struct prev_single_shot_config *)user_config;
+	int line_len;
+	int ret;
+
+	ret = validate_preview_input_spec(dev,
+					  ss_config->input.pix_fmt,
+					  ss_config->input.image_width,
+					  ss_config->input.image_height,
+					  &line_len);
+	if (ret)
+		return -EINVAL;
+
+	ret = mutex_lock_interruptible(&oper_state->lock);
+	if (ret)
+		return ret;
+
+	if (!ss_config->input.line_length)
+		param->ipipeif_param.adofs = line_len;
+	else {
+		param->ipipeif_param.adofs = ss_config->input.line_length;
+		param->ipipeif_param.adofs =
+				(param->ipipeif_param.adofs + 31) & ~0x1f;
+	}
+	if (ss_config->input.dec_en && ss_config->input.frame_div_mode_en) {
+		dev_err(dev,
+			"Both dec_en & frame_div_mode_en"
+			"can not enabled simultaneously\n");
+		mutex_unlock(&oper_state->lock);
+		return -EINVAL;
+	}
+
+	ret = validate_ipipeif_decimation(dev,
+					  ss_config->input.dec_en,
+					  ss_config->input.rsz,
+					  ss_config->input.frame_div_mode_en,
+					  ss_config->input.image_width);
+	if (ret) {
+		mutex_unlock(&oper_state->lock);
+		return -EINVAL;
+	}
+
+	if (!oper_state->rsz_chained) {
+		ret = prev_validate_output_image_format(dev,
+							ss_config->output.
+							pix_fmt, &line_len,
+							ss_config->input.
+							image_width,
+							ss_config->input.
+							image_height);
+		if (ret) {
+			mutex_unlock(&oper_state->lock);
+			return -EINVAL;
+		}
+		param->ext_mem_param[RSZ_A].rsz_sdr_oft_y = line_len;
+		if (ss_config->input.frame_div_mode_en)
+			ret = update_preview_f_div_params(dev,
+					ss_config->input.
+					image_width,
+					ss_config->input.
+					image_width,
+					&param->
+					rsz_rsc_param[RSZ_A]);
+		if (ret) {
+			mutex_unlock(&oper_state->lock);
+			return -EINVAL;
+		}
+	} else {
+		if (ss_config->input.frame_div_mode_en &&
+		    param->rsz_en[RSZ_A]) {
+			if (!param->rsz_rsc_param[RSZ_A].dscale_en)
+				ret = calculate_normal_f_div_param(
+							dev,
+							ss_config->input.
+							  image_width,
+							param->rsz_rsc_param
+							  [RSZ_A].
+							  o_vsz + 1,
+							&param->rsz_rsc_param
+							  [RSZ_A]);
+			else
+				ret = calculate_down_scale_f_div_param(
+							dev,
+							ss_config->
+							input.image_width,
+							param->rsz_rsc_param
+							  [RSZ_A].o_vsz + 1,
+							&param->rsz_rsc_param
+							  [RSZ_A]);
+			if (ret) {
+				mutex_unlock(&oper_state->lock);
+				return -EINVAL;
+			}
+		}
+		if (ss_config->input.frame_div_mode_en &&
+		    param->rsz_en[RSZ_B]) {
+			if (!param->rsz_rsc_param[RSZ_B].dscale_en)
+				ret = calculate_normal_f_div_param(
+							dev,
+							ss_config->input.
+							   image_width,
+							param->rsz_rsc_param
+							   [RSZ_B].o_vsz + 1,
+							&param->rsz_rsc_param
+							   [RSZ_B]);
+			else
+				ret = calculate_down_scale_f_div_param(
+							dev,
+							ss_config->input.
+							   image_width,
+							param->rsz_rsc_param
+							   [RSZ_B].o_vsz + 1,
+							&param->rsz_rsc_param
+							   [RSZ_B]);
+			if (ret) {
+				mutex_unlock(&oper_state->lock);
+				return -EINVAL;
+			}
+		}
+	}
+	if (ipipe_process_pix_fmts(ss_config->input.pix_fmt,
+				   ss_config->output.pix_fmt,
+				   param) < 0) {
+		dev_err(dev, "error in input or output pix format\n");
+		mutex_unlock(&oper_state->lock);
+		return -EINVAL;
+	}
+	param->ipipeif_param.hnum = ss_config->input.image_width;
+	param->ipipeif_param.vnum = ss_config->input.image_height;
+	param->ipipeif_param.glob_hor_size = ss_config->input.ppln;
+	param->ipipeif_param.glob_ver_size = ss_config->input.lpfr;
+	param->ipipeif_param.var.if_5_1.clk_div = ss_config->input.clk_div;
+	param->ipipeif_param.var.if_5_1.pix_order = ss_config->input.pix_order;
+	param->ipipeif_param.var.if_5_1.align_sync =
+	    ss_config->input.align_sync;
+	param->ipipeif_param.var.if_5_1.rsz_start = ss_config->input.rsz_start;
+	if (param->ipipeif_param.var.if_5_1.dpcm.en) {
+		param->ipipeif_param.var.if_5_1.dpcm.pred =
+		    ss_config->input.pred;
+		param->ipipeif_param.var.if_5_1.dpcm.type =
+		IPIPEIF_DPCM_8BIT_12BIT;
+	}
+	param->ipipeif_param.var.if_5_1.data_shift =
+	    ss_config->input.data_shift;
+
+	param->ipipe_hsz = ss_config->input.image_width - 1;
+	if (ss_config->input.dec_en) {
+		if ((ss_config->input.rsz < IPIPEIF_RSZ_MIN) ||
+		    (ss_config->input.rsz > IPIPEIF_RSZ_MAX)) {
+			dev_err(dev, "rsz range is %d to %d\n",
+				IPIPEIF_RSZ_MIN, IPIPEIF_RSZ_MAX);
+			mutex_unlock(&oper_state->lock);
+			return -EINVAL;
+		}
+		param->ipipeif_param.decimation = IPIPEIF_DECIMATION_ON;
+		param->ipipeif_param.rsz = ss_config->input.rsz;
+		param->ipipeif_param.avg_filter =
+		    (enum ipipeif_avg_filter)ss_config->input.avg_filter_en;
+		param->ipipe_hsz =
+		    (((ss_config->input.image_width * IPIPEIF_RSZ_CONST) /
+		      ss_config->input.rsz) - 1);
+	}
+	param->ipipeif_param.gain = ss_config->input.gain;
+	param->ipipeif_param.var.if_5_1.clip = ss_config->input.clip;
+	param->ipipeif_param.var.if_5_1.dpc = ss_config->input.dpc;
+	param->ipipe_colpat_olop = ss_config->input.colp_olop;
+	param->ipipe_colpat_olep = ss_config->input.colp_olep;
+	param->ipipe_colpat_elop = ss_config->input.colp_elop;
+	param->ipipe_colpat_elep = ss_config->input.colp_elep;
+	param->ipipe_vps = ss_config->input.vst;
+	param->ipipe_hps = ss_config->input.hst;
+	param->ipipe_vsz = ss_config->input.image_height - 1;
+	if (ss_config->input.pix_fmt == V4L2_MBUS_FMT_UYVY8_1X16)
+		param->ipipeif_param.source = IPIPEIF_SDRAM_YUV;
+	else
+		param->ipipeif_param.source = IPIPEIF_SDRAM_RAW;
+
+	configure_common_rsz_in_params(dev, param, 1, oper_state->rsz_chained,
+					       &ss_config->input);
+
+	param->rsz_common.passthrough = ss_config->bypass;
+	/* update the resize parameters */
+	if (ss_config->bypass == IPIPE_BYPASS_ON ||
+	    param->ipipe_dpaths_fmt == IPIPE_RAW2RAW)
+		/* Bypass resizer */
+		configure_resize_passthru(param, 1);
+	else {
+		if (oper_state->rsz_chained) {
+			if (param->rsz_en[RSZ_A]) {
+				calculate_resize_ratios(param, RSZ_A);
+				calculate_sdram_offsets(param, RSZ_A);
+			}
+			if (param->rsz_en[RSZ_B]) {
+				calculate_resize_ratios(param, RSZ_B);
+				calculate_sdram_offsets(param, RSZ_B);
+			}
+		} else {
+			struct rsz_output_spec *output_specs =
+				kmalloc(sizeof(struct rsz_output_spec),
+					GFP_KERNEL);
+			if (!output_specs) {
+				dev_err(dev, "Memory Alloc failure\n");
+				mutex_unlock(&oper_state->lock);
+				return -EINVAL;
+			}
+				/* Using resizer as pass through */
+			configure_resize_passthru(param, 0);
+			memset((void *)output_specs, 0,
+				sizeof(struct rsz_output_spec));
+			output_specs->enable = 1;
+			output_specs->pix_fmt = V4L2_MBUS_FMT_UYVY8_1X16;
+			output_specs->width = ss_config->input.image_width;
+			output_specs->height = ss_config->input.image_height;
+			output_specs->vst_y = ss_config->input.vst;
+			configure_resizer_out_params(param, RSZ_A,
+				output_specs, 0, 0);
+			calculate_sdram_offsets(param, RSZ_A);
+			kfree(output_specs);
+		}
+	}
+	mutex_unlock(&oper_state->lock);
+
+	return 0;
+}
+
+static int ipipe_reconfig_resizer(void *ipipe, struct device *dev,
+				struct rsz_reconfig *reconfig,
+				void *config)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct ipipe_params *param = (struct ipipe_params *)config;
+
+	if (!reconfig) {
+		dev_err(dev, "Null User ptr received for reconfig");
+		return -EINVAL;
+	}
+
+	if (reconfig->pix_format != V4L2_MBUS_FMT_Y8_1X8 &&
+		reconfig->pix_format != V4L2_MBUS_FMT_C4_1X8) {
+		dev_err(dev, "reconfig - pixel format incorrect");
+		return -EINVAL;
+	}
+	if (param->rsz_common.src_img_fmt != RSZ_IMG_420) {
+		dev_err(dev, "reconfig - source format originally"
+				"configured is not YUV420SP\n");
+		return -EINVAL;
+	}
+	if (param->rsz_common.y_c &&
+			reconfig->pix_format == V4L2_MBUS_FMT_C4_1X8) {
+		dev_err(dev, "reconfig - channel is already configured"
+				"for YUV420SP - C data\n");
+		return -EINVAL;
+	}
+	if (!param->rsz_common.y_c &&
+		(reconfig->pix_format == V4L2_MBUS_FMT_Y8_1X8)) {
+		dev_err(dev, "reconfig - channel is already configured"
+				"for YUV420SP - Y data\n");
+		return -EINVAL;
+	}
+	if (reconfig->pix_format == V4L2_MBUS_FMT_Y8_1X8)
+		param->rsz_common.y_c = 0;
+	else
+		param->rsz_common.y_c = 1;
+	if (!oper_state->en_serializer)
+		rsz_set_in_pix_format(param->rsz_common.y_c);
+
+	return 0;
+}
+
+static int ipipe_set_preview_config(void *ipipe, struct device *dev,
+				    void *user_config, void *config)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct ipipe_params *param = (struct ipipe_params *)config;
+	int ret;
+
+	dev_err(dev, "ipipe_set_preview_config\n");
+
+	if (!user_config || !config) {
+		dev_err(dev, "Invalid user_config or config ptr\n");
+		return -EINVAL;
+	}
+
+	if (!oper_state->rsz_chained) {
+		/* For chained resizer, defaults are set by resizer */
+		memcpy((void *)config,
+		       (void *)&dm365_ipipe_defs,
+		       sizeof(struct ipipe_params));
+	}
+
+	/* continuous mode */
+	if (oper_state->oper_mode == IMP_MODE_CONTINUOUS)
+		return configure_previewer_in_cont_mode(oper_state, dev,
+							user_config, param);
+
+	/* shared block */
+	/* previewer in standalone mode. In this mode if serializer
+	 * is enabled, we need to set config params for hw.
+	 */
+	ret = configure_previewer_in_ss_mode(oper_state, dev,
+							user_config, param);
+
+	if ((!ret) && !oper_state->en_serializer)
+		ret = ipipe_hw_setup(config);
+
+	return ret;
+}
+
+static int ipipe_set_input_win(void *ipipe, struct imp_window *win)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct ipipe_params *param = oper_state->shared_config_param;
+	int ret;
+
+	ret = mutex_lock_interruptible(&oper_state->lock);
+	if (ret)
+		return ret;
+	if (param->ipipeif_param.decimation) {
+		param->ipipe_hsz =
+		    ((win->width * IPIPEIF_RSZ_CONST) /
+		     param->ipipeif_param.rsz) - 1;
+	} else
+		param->ipipe_hsz = win->width - 1;
+	if (!oper_state->frame_format) {
+		param->ipipe_vsz = (win->height >> 1) - 1;
+		param->ipipe_vps = (win->vst >> 1);
+	} else {
+		param->ipipe_vsz = win->height - 1;
+		param->ipipe_vps = win->vst;
+	}
+	param->ipipe_hps = win->hst;
+	param->rsz_common.vsz = param->ipipe_vsz;
+	param->rsz_common.hsz = param->ipipe_hsz;
+	mutex_unlock(&oper_state->lock);
+
+	return 0;
+}
+static int ipipe_get_input_win(void *ipipe, struct imp_window *win)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct ipipe_params *param = oper_state->shared_config_param;
+	int ret;
+
+	ret = mutex_lock_interruptible(&oper_state->lock);
+	if (ret)
+		return ret;
+	if (param->ipipeif_param.decimation)
+		win->width =
+		    (((param->ipipe_hsz + 1) * param->ipipeif_param.rsz) >> 4);
+	else
+		win->width = param->ipipe_hsz + 1;
+	if (!oper_state->frame_format) {
+		win->height = (param->ipipe_vsz + 1) << 1;
+		win->vst = (param->ipipe_vps << 1);
+	} else {
+		win->height = param->ipipe_vsz + 1;
+		win->vst = param->ipipe_vps;
+	}
+	win->hst = param->ipipe_hps;
+	mutex_unlock(&oper_state->lock);
+
+	return 0;
+}
+
+static int ipipe_set_in_pixel_format(void *ipipe,
+				     enum v4l2_mbus_pixelcode pix_fmt)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct ipipe_params *param = oper_state->shared_config_param;
+	int ret;
+
+	ret = mutex_lock_interruptible(&oper_state->lock);
+	if (ret)
+		return ret;
+	oper_state->in_pixel_format = pix_fmt;
+	param->rsz_common.src_img_fmt = RSZ_IMG_422;
+	mutex_unlock(&oper_state->lock);
+
+	return 0;
+}
+
+static int ipipe_set_out_pixel_format(void *ipipe,
+				      enum v4l2_mbus_pixelcode pix_fmt)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct ipipe_params *param = oper_state->shared_config_param;
+	int err;
+
+	/* if image is RAW, preserve raw image format while flipping.
+	 * otherwise preserve, preserve ycbcr format while flipping
+	 */
+	if (pix_fmt == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE)
+		param->rsz_common.raw_flip = 1;
+	else
+		param->rsz_common.raw_flip = 0;
+
+	err = mutex_lock_interruptible(&oper_state->lock);
+	if (err)
+		return err;
+	oper_state->out_pixel_format = pix_fmt;
+	err = ipipe_process_pix_fmts(oper_state->in_pixel_format,
+				     oper_state->out_pixel_format,
+				     param);
+
+	mutex_unlock(&oper_state->lock);
+
+	return err;
+}
+
+static int ipipe_set_buftype(void *ipipe, unsigned char buf_type)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	int ret;
+
+	ret = mutex_lock_interruptible(&oper_state->lock);
+	if (ret)
+		return ret;
+	oper_state->buffer_type = buf_type;
+	mutex_unlock(&oper_state->lock);
+
+	return 0;
+}
+
+static int ipipe_set_frame_format(void *ipipe, unsigned char frm_fmt)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	int ret;
+
+	ret = mutex_lock_interruptible(&oper_state->lock);
+	if (ret)
+		return ret;
+	oper_state->frame_format = frm_fmt;
+	mutex_unlock(&oper_state->lock);
+
+	return 0;
+}
+
+static int ipipe_set_output_win(void *ipipe, struct imp_window *win)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct ipipe_params *param = oper_state->shared_config_param;
+	struct rsz_output_spec output_specs;
+	int line_len_c;
+	int line_len;
+	int ret = -EINVAL;
+
+	if (!param->rsz_en[0]) {
+		printk(KERN_ERR "resizer output1 not enabled\n");
+		return ret;
+	}
+	output_specs.enable = 1;
+	output_specs.width = win->width;
+	/* Always set output height same as in height
+	   for de-interlacing
+	 */
+	output_specs.height = win->height;
+	output_specs.vst_y = win->vst;
+	if (oper_state->out_pixel_format == V4L2_MBUS_FMT_YUV420SP8_1X8)
+		output_specs.vst_c = win->vst;
+	ret = mutex_lock_interruptible(&oper_state->lock);
+	if (ret)
+		return ret;
+	configure_resizer_out_params(param, RSZ_A, &output_specs, 0, 0);
+	calculate_line_length(oper_state->out_pixel_format,
+				     param->rsz_rsc_param[0].o_hsz + 1,
+				     param->rsz_rsc_param[0].o_vsz + 1,
+				     &line_len,
+				     &line_len_c);
+	param->ext_mem_param[0].rsz_sdr_oft_y = line_len;
+	param->ext_mem_param[0].rsz_sdr_oft_c = line_len_c;
+	calculate_resize_ratios(param, RSZ_A);
+	if (param->rsz_en[RSZ_B])
+		calculate_resize_ratios(param, RSZ_B);
+	if (oper_state->out_pixel_format == V4L2_MBUS_FMT_YUV420SP8_1X8)
+		enable_422_420_conversion(param, RSZ_A, ENABLE);
+	else
+		enable_422_420_conversion(param, RSZ_A, DISABLE);
+
+	ret = calculate_sdram_offsets(param, RSZ_A);
+	if (param->rsz_en[RSZ_B])
+		ret = calculate_sdram_offsets(param, RSZ_B);
+
+	if (ret)
+		printk(KERN_ERR "error in calculating sdram offsets\n");
+	mutex_unlock(&oper_state->lock);
+
+	return ret;
+}
+static int ipipe_get_output_state(void *ipipe, unsigned char out_sel)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct ipipe_params *param = oper_state->shared_config_param;
+
+	if ((out_sel != RSZ_A) && (out_sel != RSZ_B))
+		return 0;
+
+	return param->rsz_en[out_sel];
+}
+
+/* This should be called only after setting the output
+ * window params. This also assumes the corresponding
+ * output is configured prior to calling this.
+ */
+static int ipipe_get_line_length(void *ipipe, unsigned char out_sel)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct ipipe_params *param = oper_state->shared_config_param;
+
+	if ((out_sel != RSZ_A) && (out_sel != RSZ_B))
+		return -EINVAL;
+	/* assume output is always UYVY. Change this if we
+	 * support RGB
+	 */
+	if (!param->rsz_en[out_sel])
+		return -EINVAL;
+
+	return param->ext_mem_param[out_sel].rsz_sdr_oft_y;
+}
+
+static int ipipe_get_image_height(void *ipipe, unsigned char out_sel)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct ipipe_params *param = oper_state->shared_config_param;
+
+	if ((out_sel != RSZ_A) && (out_sel != RSZ_B))
+		return -EINVAL;
+	if (!param->rsz_en[out_sel])
+		return -EINVAL;
+
+	return param->rsz_rsc_param[out_sel].o_vsz + 1;
+}
+
+/* Assume valid param ptr */
+static int ipipe_set_hw_if_param(void *ipipe, struct vpfe_hw_if_param *if_param)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct ipipe_params *param = oper_state->shared_config_param;
+	int ret;
+
+	ret = mutex_lock_interruptible(&oper_state->lock);
+	if (ret)
+		return ret;
+	param->ipipeif_param.var.if_5_1.isif_port = *if_param;
+	mutex_unlock(&oper_state->lock);
+
+	return 0;
+}
+
+static struct imp_hw_interface dm365_ipipe_interface = {
+	.name = "DM365 IPIPE",
+	.owner = THIS_MODULE,
+	.prev_enum_modules = prev_enum_preview_cap,
+	.set_oper_mode = ipipe_set_oper_mode,
+	.reset_oper_mode = ipipe_reset_oper_mode,
+	.get_oper_mode = prev_get_oper_mode,
+	.get_hw_state = ipipe_get_oper_state,
+	.set_hw_state = ipipe_set_oper_state,
+	.resizer_chain = ipipe_rsz_chain_state,
+	.lock_chain = ipipe_lock_chain,
+	.unlock_chain = ipipe_unlock_chain,
+	.serialize = ipipe_serialize,
+	.alloc_config_block = ipipe_alloc_config_block,
+	.dealloc_config_block = ipipe_dealloc_config_block,
+	.alloc_user_config_block = ipipe_alloc_user_config_block,
+	.dealloc_config_block = ipipe_dealloc_user_config_block,
+	.set_user_config_defaults = ipipe_set_user_config_defaults,
+	.set_preview_config = ipipe_set_preview_config,
+	.set_resizer_config = ipipe_set_resize_config,
+	.reconfig_resizer = ipipe_reconfig_resizer,
+	.update_inbuf_address = ipipe_set_ipipe_if_address,
+	.update_outbuf1_address = ipipe_update_outbuf1_address,
+	.update_outbuf2_address = ipipe_update_outbuf2_address,
+	.enable = ipipe_enable,
+	.enable_resize = rsz_src_enable,
+	.hw_setup = ipipe_do_hw_setup,
+	.get_resizer_config_state = ipipe_get_rsz_config_state,
+	.get_previewer_config_state = ipipe_get_prev_config_state,
+	.set_input_win = ipipe_set_input_win,
+	.get_input_win = ipipe_get_input_win,
+	.set_hw_if_param = ipipe_set_hw_if_param,
+	.set_in_pixel_format = ipipe_set_in_pixel_format,
+	.set_out_pixel_format = ipipe_set_out_pixel_format,
+	.set_buftype = ipipe_set_buftype,
+	.set_frame_format = ipipe_set_frame_format,
+	.set_output_win = ipipe_set_output_win,
+	.get_output_state = ipipe_get_output_state,
+	.get_line_length = ipipe_get_line_length,
+	.get_image_height = ipipe_get_image_height,
+	.get_max_output_width = ipipe_get_max_output_width,
+	.get_max_output_height = ipipe_get_max_output_height,
+	.enum_pix = ipipe_enum_pix,
+};
+
+struct imp_hw_interface *imp_get_hw_if(void)
+{
+	return &dm365_ipipe_interface;
+}
+
+void enable_serializer(void *ipipe, int val)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	oper_state->en_serializer = val;
+}
+
+int ipipe_init(void *ipipe)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	if (!oper_state) {
+		printk(KERN_ERR
+		       "dm365_ipipe_init: failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	/* ipipe module operation state & configuration */
+	oper_state->oper_mode = IMP_MODE_NOT_CONFIGURED;
+	oper_state->ipipe_raw_yuv_pix_formats[0] = V4L2_PIX_FMT_UYVY;
+	oper_state->ipipe_raw_yuv_pix_formats[1] = V4L2_PIX_FMT_NV12;
+
+	oper_state->shared_config_param =
+		kmalloc(sizeof(struct ipipe_params), GFP_KERNEL);
+
+	if (!oper_state->shared_config_param) {
+		printk(KERN_ERR
+		       "dm365_ipipe_init: failed to allocate memory\n");
+		return -ENOMEM;
+	}
+	memcpy(&dm365_ipipe_defs.ipipeif_param.var.if_5_1,
+		&ipipeif_5_1_defaults,
+		sizeof(struct ipipeif_5_1));
+	oper_state->lutdpc.table = oper_state->ipipe_lutdpc_table;
+	oper_state->lut_3d.table = oper_state->ipipe_3d_lut_table;
+	oper_state->gbce.table = oper_state->ipipe_gbce_table;
+	oper_state->gamma.table_r = oper_state->ipipe_gamma_table_r;
+	oper_state->gamma.table_b = oper_state->ipipe_gamma_table_b;
+	oper_state->gamma.table_g = oper_state->ipipe_gamma_table_g;
+	oper_state->yee.table = oper_state->ipipe_yee_table;
+	mutex_init(&oper_state->lock);
+	oper_state->state = CHANNEL_FREE;
+	oper_state->prev_config_state = STATE_NOT_CONFIGURED;
+	oper_state->rsz_config_state = STATE_NOT_CONFIGURED;
+	oper_state->frame_format = 1;
+	oper_state->in_pixel_format = V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE;
+	oper_state->out_pixel_format = V4L2_MBUS_FMT_UYVY8_1X16;
+	oper_state->resource_in_use = 0;
+	oper_state->rsz_chained = 0;
+
+	return 0;
+}
+
+void ipipe_cleanup(void *ipipe)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	kfree(oper_state->shared_config_param);
+}
diff --git a/drivers/media/video/davinci/dm365_ipipe.h b/drivers/media/video/davinci/dm365_ipipe.h
new file mode 100644
index 0000000..dd0db00
--- /dev/null
+++ b/drivers/media/video/davinci/dm365_ipipe.h
@@ -0,0 +1,395 @@
+/*
+* Copyright (C) 2011 Texas Instruments Inc
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation version 2.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+*
+* Feature description
+* ===================
+*
+* VPFE hardware setup
+*
+* case 1: Capture to SDRAM with out IPIPE
+* ****************************************
+*
+*            parallel
+*                port
+*
+* Image sensor/       ________
+* Yuv decoder    ---->| CCDC |--> SDRAM
+*                     |______|
+*
+* case 2: Capture to SDRAM with IPIPE Preview modules in Continuous
+*          (On the Fly mode)
+*
+* Image sensor/       ________    ____________________
+* Yuv decoder    ---->| CCDC |--> | Previewer modules |--> SDRAM
+*                     |______|    |___________________|
+*
+* case 3: Capture to SDRAM with IPIPE Preview modules  & Resizer
+*         in continuous (On the Fly mode)
+*
+* Image sensor/       ________    _____________   ___________
+* Yuv decoder    ---->| CCDC |--> | Previewer  |->| Resizer  |-> SDRAM
+*                     |______|    |____________|  |__________|
+*
+* case 4: Capture to SDRAM with IPIPE Resizer
+*         in continuous (On the Fly mode)
+*
+* Image sensor/       ________    ___________
+* Yuv decoder    ---->| CCDC |--> | Resizer  |-> SDRAM
+*                     |______|    |__________|
+*
+* case 5: Read from SDRAM and do preview and/or Resize
+*         in Single shot mode
+*
+*                   _____________   ___________
+*    SDRAM   ----> | Previewer  |->| Resizer  |-> SDRAM
+*                  |____________|  |__________|
+*
+*
+* Previewer allows fine tuning of the input image using different
+* tuning modules in IPIPE. Some examples :- Noise filter, Defect
+* pixel correction etc. It essentially operate on Bayer Raw data
+* or YUV raw data. To do image tuning, application call,
+* PREV_QUERY_CAP, and then call PREV_SET_PARAM to set parameter
+* for a module.
+*
+*
+* Resizer allows upscaling or downscaling a image to a desired
+* resolution. There are 2 resizer modules. both operating on the
+* same input image, but can have different output resolution.
+*/
+
+#ifndef DM365_IPIPE_H
+#define DM365_IPIPE_H
+
+#include "imp_common.h"
+#include "dm3xx_ipipeif.h"
+#include <linux/davinci_vpfe.h>
+
+/* Used for driver storage */
+struct ipipe_otfdpc_2_0 {
+	/* 0 - disable, 1 - enable */
+	unsigned char en;
+	/* defect detection method */
+	enum ipipe_otfdpc_det_meth det_method;
+	/* Algorith used. Applicable only when IPIPE_DPC_OTF_MIN_MAX2 is
+	 * used
+	 */
+	enum ipipe_otfdpc_alg alg;
+	struct prev_otfdpc_2_0 otfdpc_2_0;
+};
+
+struct ipipe_otfdpc_3_0 {
+	/* 0 - disable, 1 - enable */
+	unsigned char en;
+	/* defect detection method */
+	enum ipipe_otfdpc_det_meth det_method;
+	/* Algorith used. Applicable only when IPIPE_DPC_OTF_MIN_MAX2 is
+	 * used
+	 */
+	enum ipipe_otfdpc_alg alg;
+	struct prev_otfdpc_3_0 otfdpc_3_0;
+};
+
+#define CEIL(a, b)	(((a) + (b-1)) / (b))
+#define IPIPE_MAX_PASSES	2
+
+struct f_div_pass {
+	unsigned int o_hsz;
+	unsigned int i_hps;
+	unsigned int h_phs;
+	unsigned int src_hps;
+	unsigned int src_hsz;
+};
+
+struct f_div_param {
+	unsigned char en;
+	unsigned int num_passes;
+	struct f_div_pass pass[IPIPE_MAX_PASSES];
+};
+
+#define boolean_t	int
+#define ENABLE		1
+#define DISABLE		(!ENABLE)
+
+/* Resizer Rescale Parameters*/
+struct ipipe_rsz_rescale_param {
+	enum ipipe_oper_mode mode;
+	boolean_t h_flip;
+	boolean_t v_flip;
+	boolean_t cen;
+	boolean_t yen;
+	unsigned short i_vps;
+	unsigned short i_hps;
+	unsigned short o_vsz;
+	unsigned short o_hsz;
+	unsigned short v_phs_y;
+	unsigned short v_phs_c;
+	unsigned short v_dif;
+	/* resize method - Luminance */
+	enum rsz_intp_t v_typ_y;
+	/* resize method - Chrominance */
+	enum rsz_intp_t v_typ_c;
+	/* vertical lpf intensity - Luminance */
+	unsigned char v_lpf_int_y;
+	/* vertical lpf intensity - Chrominance */
+	unsigned char v_lpf_int_c;
+	unsigned short h_phs;
+	unsigned short h_dif;
+	/* resize method - Luminance */
+	enum rsz_intp_t h_typ_y;
+	/* resize method - Chrominance */
+	enum rsz_intp_t h_typ_c;
+	/* horizontal lpf intensity - Luminance */
+	unsigned char h_lpf_int_y;
+	/* horizontal lpf intensity - Chrominance */
+	unsigned char h_lpf_int_c;
+	boolean_t dscale_en;
+	enum down_scale_ave_sz h_dscale_ave_sz;
+	enum down_scale_ave_sz v_dscale_ave_sz;
+	/* store the calculated frame division parameter */
+	struct f_div_param f_div;
+};
+
+enum ipipe_rsz_rgb_t {
+	OUTPUT_32BIT,
+	OUTPUT_16BIT
+};
+
+enum ipipe_rsz_rgb_msk_t {
+	NOMASK,
+	MASKLAST2
+};
+
+/* Resizer RGB Conversion Parameters */
+struct ipipe_rsz_resize2rgb {
+	boolean_t rgb_en;
+	enum ipipe_rsz_rgb_t rgb_typ;
+	enum ipipe_rsz_rgb_msk_t rgb_msk0;
+	enum ipipe_rsz_rgb_msk_t rgb_msk1;
+	unsigned int rgb_alpha_val;
+};
+
+/* Resizer External Memory Parameters */
+struct ipipe_ext_mem_param {
+	unsigned int rsz_sdr_oft_y;
+	unsigned int rsz_sdr_ptr_s_y;
+	unsigned int rsz_sdr_ptr_e_y;
+	unsigned int rsz_sdr_oft_c;
+	unsigned int rsz_sdr_ptr_s_c;
+	unsigned int rsz_sdr_ptr_e_c;
+	/* offset to be added to buffer start when flipping for y/ycbcr */
+	unsigned int flip_ofst_y;
+	/* offset to be added to buffer start when flipping for c */
+	unsigned int flip_ofst_c;
+	/* c offset for YUV 420SP */
+	unsigned int c_offset;
+	/* User Defined Y offset for YUV 420SP or YUV420ILE data */
+	unsigned int user_y_ofst;
+	/* User Defined C offset for YUV 420SP data */
+	unsigned int user_c_ofst;
+};
+
+enum rsz_data_source {
+	IPIPE_DATA,
+	IPIPEIF_DATA
+};
+
+/* data paths */
+enum ipipe_data_paths {
+	IPIPE_RAW2YUV,
+	/* Bayer RAW input to YCbCr output */
+	IPIPE_RAW2RAW,
+	/* Bayer Raw to Bayer output */
+	IPIPE_RAW2BOX,
+	/* Bayer Raw to Boxcar output */
+	IPIPE_YUV2YUV
+	/* YUV Raw to YUV Raw output */
+};
+
+enum rsz_src_img_fmt {
+	RSZ_IMG_422,
+	RSZ_IMG_420
+};
+
+struct rsz_common_params {
+	unsigned int vps;
+	unsigned int vsz;
+	unsigned int hps;
+	unsigned int hsz;
+	/* 420 or 422 */
+	enum rsz_src_img_fmt src_img_fmt;
+	/* Y or C when src_fmt is 420, 0 - y, 1 - c */
+	unsigned char y_c;
+	/* flip raw or ycbcr */
+	unsigned char raw_flip;
+	/* IPIPE or IPIPEIF data */
+	enum rsz_data_source source;
+	enum ipipe_dpaths_bypass_t passthrough;
+	unsigned char yuv_y_min;
+	unsigned char yuv_y_max;
+	unsigned char yuv_c_min;
+	unsigned char yuv_c_max;
+	boolean_t rsz_seq_crv;
+	enum ipipe_chr_pos out_chr_pos;
+};
+
+struct ipipe_params {
+	struct ipipeif ipipeif_param;
+	enum ipipe_oper_mode ipipe_mode;
+	/* input/output datapath through IPIPE */
+	enum ipipe_data_paths ipipe_dpaths_fmt;
+	/* color pattern register */
+	enum ipipe_colpat_t ipipe_colpat_elep;
+	enum ipipe_colpat_t ipipe_colpat_elop;
+	enum ipipe_colpat_t ipipe_colpat_olep;
+	enum ipipe_colpat_t ipipe_colpat_olop;
+	/* horizontal/vertical start, horizontal/vertical size
+	 * for both IPIPE and RSZ input
+	 */
+	unsigned int ipipe_vps;
+	unsigned int ipipe_vsz;
+	unsigned int ipipe_hps;
+	unsigned int ipipe_hsz;
+
+	struct rsz_common_params rsz_common;
+	struct ipipe_rsz_rescale_param rsz_rsc_param[2];
+	struct ipipe_rsz_resize2rgb rsz2rgb[2];
+	struct ipipe_ext_mem_param ext_mem_param[2];
+	boolean_t rsz_en[2];
+};
+
+#define MAX_IPIPE_RAW_YUV_PIX_FORMATS		2
+
+/* IPIPE module operation state */
+struct ipipe_oper_state {
+	/* Channel state 0 - free, 1 - busy */
+	unsigned int state;
+	/* Semaphore to protect the common hardware configuration */
+	struct mutex lock;
+	/* previewer config state */
+	unsigned int prev_config_state;
+	/* Shared configuration of the hardware */
+	struct ipipe_params *shared_config_param;
+	/* shared resource in use */
+	unsigned int resource_in_use;
+	/* resizer config state */
+	unsigned int rsz_config_state;
+	/* resizer chained with previewer */
+	unsigned int rsz_chained;
+	/* Buffer type, interleaved or field seperated for interlaced
+	 *  scan
+	 */
+	unsigned int buffer_type;
+	/* frame format, 0 - interlaced, 1 - progressive */
+	unsigned int frame_format;
+	/* input pixel format */
+	enum v4l2_mbus_pixelcode in_pixel_format;
+	/* input pixel format */
+	enum v4l2_mbus_pixelcode out_pixel_format;
+	/* Operation mode of image processor (imp)
+	 * 0 - continuous mode, 1 - single shot mode
+	 * 2 - invalid mode, 4 - not configured
+	 */
+	u32 oper_mode;
+	/* enable/disable serializer */
+	u32 en_serializer;
+	/* LUT Defect pixel correction data */
+	struct prev_lutdpc lutdpc;
+
+	/* LUT Defect pixel correction data */
+	struct prev_otfdpc otfdpc;
+
+	/* Noise filter */
+	struct prev_nf nf1;
+	struct prev_nf nf2;
+
+	/* Green Imbalance Correction */
+	struct prev_gic gic;
+
+	/* White Balance */
+	struct prev_wb wb;
+
+	/* CFA */
+	struct prev_cfa cfa;
+
+	/* RGB2RGB conversion */
+	struct prev_rgb2rgb rgb2rgb_1;
+	struct prev_rgb2rgb rgb2rgb_2;
+
+	/* Gamma correction */
+	struct prev_gamma gamma;
+
+	/* 3D LUT */
+	struct prev_3d_lut lut_3d;
+
+	/* Lumina Adjustment */
+	struct prev_lum_adj lum_adj;
+
+	/* RGB2YUV conversion */
+	struct prev_rgb2yuv rgb2yuv;
+
+	/* YUV 422 conversion */
+	struct prev_yuv422_conv yuv422_conv;
+
+	/* GBCE */
+	struct prev_gbce gbce;
+
+	/* Edge Enhancement */
+	struct prev_yee yee;
+
+	/* Chromatic Artifact Reduction, CAR */
+	struct prev_car car;
+
+	/* Chromatic Artifact Reduction, CAR */
+	struct prev_cgs cgs;
+
+	/* Tables for various tuning modules */
+	struct ipipe_lutdpc_entry ipipe_lutdpc_table[MAX_SIZE_DPC];
+	struct ipipe_3d_lut_entry ipipe_3d_lut_table[MAX_SIZE_3D_LUT];
+	unsigned short ipipe_gbce_table[MAX_SIZE_GBCE_LUT];
+	struct ipipe_gamma_entry ipipe_gamma_table_r[MAX_SIZE_GAMMA];
+	struct ipipe_gamma_entry ipipe_gamma_table_b[MAX_SIZE_GAMMA];
+	struct ipipe_gamma_entry ipipe_gamma_table_g[MAX_SIZE_GAMMA];
+	short ipipe_yee_table[MAX_SIZE_YEE_LUT];
+	/* Raw YUV formats */
+	u32 ipipe_raw_yuv_pix_formats[MAX_IPIPE_RAW_YUV_PIX_FORMATS];
+};
+
+
+void ipipe_set_d2f_regs(unsigned int id, struct prev_nf *noise_filter);
+void ipipe_set_rgb2rgb_regs(unsigned int id, struct prev_rgb2rgb *rgb);
+void rsz_set_output_address(struct ipipe_params *params,
+			      int resize_no, unsigned int address);
+void ipipe_set_yuv422_conv_regs(struct prev_yuv422_conv *conv);
+void ipipe_set_lum_adj_regs(struct prev_lum_adj *lum_adj);
+void ipipe_set_rgb2ycbcr_regs(struct prev_rgb2yuv *yuv);
+void ipipe_set_lutdpc_regs(struct prev_lutdpc *lutdpc);
+void ipipe_set_otfdpc_regs(struct prev_otfdpc *otfdpc);
+void ipipe_set_3d_lut_regs(struct prev_3d_lut *lut_3d);
+void ipipe_set_gamma_regs(struct prev_gamma *gamma);
+int ipipe_hw_setup(struct ipipe_params *config);
+void ipipe_set_gbce_regs(struct prev_gbce *gbce);
+void ipipe_set_gic_regs(struct prev_gic *gic);
+void ipipe_set_cfa_regs(struct prev_cfa *cfa);
+void ipipe_set_car_regs(struct prev_car *car);
+void ipipe_set_cgs_regs(struct prev_cgs *cgs);
+void rsz_set_in_pix_format(unsigned char y_c);
+void ipipe_set_ee_regs(struct prev_yee *ee);
+void ipipe_set_wb_regs(struct prev_wb *wb);
+int rsz_enable(int rsz_id, int enable);
+void rsz_src_enable(int enable);
+
+#endif
diff --git a/drivers/media/video/davinci/imp_common.h b/drivers/media/video/davinci/imp_common.h
new file mode 100644
index 0000000..5e6cc85
--- /dev/null
+++ b/drivers/media/video/davinci/imp_common.h
@@ -0,0 +1,81 @@
+/*
+* Copyright (C) 2011 Texas Instruments Inc
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation version 2.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+*
+* imp_common.h file
+*/
+#ifndef _IMP_COMMON_H
+#define _IMP_COMMON_H
+
+#include <linux/completion.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/mutex.h>
+#define MAX_CHANNELS		2
+#define	MAX_BUFFERS		6
+#define	MAX_PRIORITY		5
+#define	MIN_PRIORITY		0
+#define	DEFAULT_PRIORITY	3
+#define ENABLED			1
+#define DISABLED		0
+#define CHANNEL_BUSY		1
+#define CHANNEL_FREE		0
+#define ISNULL(val) ((val == NULL) ? 1 : 0)
+
+/* driver configured by application */
+#define STATE_CONFIGURED	1
+/* driver not configured by application */
+#define STATE_NOT_CONFIGURED	0
+
+enum imp_log_chan_t {
+	IMP_PREVIEWER,
+	IMP_RESIZER,
+	IMP_HISTOGRAM,
+	IMP_BOXCAR
+};
+
+/* IMP channel structure */
+struct imp_logical_channel {
+	/* channel type */
+	enum imp_log_chan_t type;
+	/* If this channel is chained with another channel, this is set */
+	char chained;
+	/* Set if there is a primary user of this channel */
+	char primary_user;
+	/* channel configuration for this logial channel */
+	void *config;
+	/* Size of the user configuration block */
+	int user_config_size;
+	/* Saves the user configuration */
+	void *user_config;
+	/* configure State of the channel */
+	unsigned int config_state;
+};
+
+/* Where hardware channel is shared, this is used for serialisation */
+struct imp_serializer {
+	/* channel config array for serialization */
+	struct imp_logical_channel *channel_config[MAX_CHANNELS];
+	/* number of elements in the array */
+	int array_count;
+	/* Semaphore for above config array */
+	struct mutex array_sem;
+	/* Completion semaphore when hw channel is common
+	 * Use device specific completion semaphore when request is serialized
+	 */
+	struct completion sem_isr;
+};
+
+#endif
diff --git a/drivers/media/video/davinci/imp_hw_if.h b/drivers/media/video/davinci/imp_hw_if.h
new file mode 100644
index 0000000..45eff12
--- /dev/null
+++ b/drivers/media/video/davinci/imp_hw_if.h
@@ -0,0 +1,184 @@
+/*
+* Copyright (C) 2011 Texas Instruments Inc
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation version 2.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+*/
+
+#ifndef _IMP_HW_IF_H
+#define _IMP_HW_IF_H
+
+#include <linux/davinci_vpfe.h>
+#include "imp_common.h"
+#include <media/davinci/vpfe.h>
+
+struct prev_module_if {
+	/* Version of the preview module */
+	char *version;
+	/* Module IDs as defined above */
+	unsigned short module_id;
+	/* Name of the module */
+	char *module_name;
+	/* control allowed in continous mode ? 1 - allowed , 0 - not allowed */
+	char control;
+	/* path in which module sits */
+	enum imp_data_paths path;
+	int (*set)(struct device *dev, void *ipipe, void *param, int len);
+	int (*get)(struct device *dev, void *ipipe, void *param, int len);
+};
+
+struct ipipe_oper_state;
+
+struct imp_hw_interface {
+	/* Name of the image processor hardware */
+	char *name;
+	/* module owner */
+	struct module *owner;
+	/*
+	 * enumerate preview modules. Return interface to the
+	 * the module
+	 */
+	struct prev_module_if *(*prev_enum_modules) (void *ipipe,
+					struct device *dev, unsigned index);
+	/*
+	 * set operating mode for IPIPE; 1-single shot, 0-continous
+	 */
+	int (*set_oper_mode) (void *ipipe, unsigned int mode);
+	/*
+	 * reset operating mode for IPIPE;
+	 */
+	void (*reset_oper_mode) (void *ipipe);
+	/*
+	 *  get IPIPE operation mode
+	 */
+	unsigned int (*get_oper_mode) (void *ipipe);
+	/* check if hw is busy in continuous mode.
+	 * Used for checking if hw is used by ccdc driver in
+	 * continuous mode. If streaming is ON, this will be
+	 * set to busy
+	 */
+	unsigned int (*get_hw_state) (void *ipipe);
+	/* set hw state */
+	void (*set_hw_state) (void *ipipe, unsigned int state);
+	/* is resizer chained ? */
+	unsigned int (*resizer_chain) (void *ipipe);
+	/* this is used to lock shared resource */
+	void (*lock_chain) (void *ipipe);
+	/* this is used unlock shared resouce */
+	void (*unlock_chain) (void *ipipe);
+	/* Allocate a shared or exclusive config block for hardware
+	 * configuration
+	 */
+	void *(*alloc_config_block) (void *ipipe, struct device *dev);
+	/* hw serialization enabled ?? */
+	int (*serialize) (void *ipipe);
+	/* De-allocate the exclusive config block */
+	void (*dealloc_config_block) (void *ipipe, struct device *dev,
+							void *config);
+	/* Allocate a user confguration block */
+	void *(*alloc_user_config_block) (void *ipipe, struct device *dev,
+				enum imp_log_chan_t chan_type, int *len);
+
+	/* de-allocate user config block */
+	void (*dealloc_user_config_block) (void *ipipe, struct device *dev,
+							void *config);
+
+	/* set default configuration in the config block */
+	void (*set_user_config_defaults) (void *ipipe, struct device *dev,
+					  enum imp_log_chan_t chan_type,
+					  void *user_config);
+	/* set user configuration for preview */
+	int (*set_preview_config) (void *ipipe, struct device *dev,
+				   void *user_config, void *config);
+	/* set user configuration for resize */
+	int (*set_resizer_config) (void *ipipe, struct device *dev,
+				   int resizer_chained, void *user_config,
+				   void *config);
+
+	int (*reconfig_resizer) (void *ipipe, struct device *dev,
+				struct rsz_reconfig *user_config,
+				void *config);
+
+	/* update output buffer address for a channel
+	 * if config is NULL, the shared config is assumed
+	 * this is used only in single shot mode
+	 */
+	int (*update_inbuf_address) (void *ipipe, void *config,
+						unsigned int address);
+	/* update output buffer address for a channel
+	 * if config is NULL, the shared config is assumed
+	 */
+	void (*update_outbuf1_address) (void *ipipe, void *config,
+						unsigned int address);
+	/* update output buffer address for a channel
+	 * if config is NULL, the shared config is assumed
+	 */
+	void (*update_outbuf2_address) (void *ipipe, void *config,
+						unsigned int address);
+	/* enable or disable hw */
+	void (*enable) (void *ipipe, unsigned char en, void *config);
+	/* enable or disable resizer to allow frame by frame resize in
+	 * continuous mode
+	 */
+	void (*enable_resize) (int en);
+	/* setup hardware for processing. if config is NULL,
+	 * shared channel is assumed
+	 */
+	int (*hw_setup) (void *ipipe, struct device *dev, void *config);
+	/* Get configuration state of resizer in continuous mode */
+	unsigned int (*get_resizer_config_state) (void *ipipe);
+	/* Get configuration state of previewer in continuous mode */
+	unsigned int (*get_previewer_config_state) (void *ipipe);
+
+	/* Below APIs assume we are using shared configuration since
+	 * oper mode is continuous
+	 */
+	/* Set the input crop window at the IMP interface and IMP */
+	int (*set_input_win) (void *ipipe, struct imp_window *win);
+	/* Get current input crop window param at the IMP */
+	int (*get_input_win) (void *ipipe, struct imp_window *win);
+	/* Set interface parameter at IPIPEIF. Only valid for DM360 */
+	int (*set_hw_if_param) (void *ipipe, struct vpfe_hw_if_param *param);
+	/* Set input pixel format */
+	int (*set_in_pixel_format) (void *ipipe,
+					enum v4l2_mbus_pixelcode pix_fmt);
+	/* set output pixel format */
+	int (*set_out_pixel_format) (void *ipipe,
+					enum v4l2_mbus_pixelcode pix_fmt);
+	/* 0 - interleaved, 1 - field seperated */
+	int (*set_buftype) (void *ipipe, unsigned char buf_type);
+	/* 0 - interlaced, 1 - progressive */
+	int (*set_frame_format) (void *ipipe, unsigned char frm_fmt);
+	/* Set the output window at the IMP, output selection
+	 * done by out_sel. 0 - output 1 and 1 - output 2
+	 */
+	int (*set_output_win) (void *ipipe, struct imp_window *win);
+	/* Get output enable/disable status */
+	int (*get_output_state) (void *ipipe, unsigned char out_sel);
+	/* Get output line lenght */
+	int (*get_line_length) (void *ipipe, unsigned char out_sel);
+	/* Get the output image height */
+	int (*get_image_height) (void *ipipe, unsigned char out_sel);
+	/* Get current output window param at the IMP */
+	int (*get_output_win) (void *ipipe, struct imp_window *win);
+	/* get maximum output width of rsz-a or rsz_b*/
+	int (*get_max_output_width) (int rsz);
+	/* get maximum output height of rsa-a or rsz-b */
+	int (*get_max_output_height) (int rsz);
+	/* Enumerate pixel format for a given input format */
+	int (*enum_pix) (void *ipipe, u32 *output_pix, int index);
+};
+
+struct imp_hw_interface *imp_get_hw_if(void);
+
+#endif
-- 
1.6.2.4

