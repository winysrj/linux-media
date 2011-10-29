Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:60404 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933273Ab1J2Ovo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Oct 2011 10:51:44 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p9TEpep7031776
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 29 Oct 2011 09:51:43 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Nagabhushana Netagunte <nagabhushana.netagunte@ti.com>
Subject: [RFC PATCH v3 4/8] davinci: vpfe: add support for CCDC hardware for dm365
Date: Sat, 29 Oct 2011 20:21:28 +0530
Message-ID: <1319899892-19658-5-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1319899892-19658-1-git-send-email-manjunath.hadli@ti.com>
References: <1319899892-19658-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add support for ccdc on dm365 SoC. ccdc is responsible for
capturing video data- both raw bayer through sync seperate
signals and through BT656/1120 interfaces. This driver implements
the hardware functionality. Mainly- setting of hardware, validation
of parameters, and isr configuration.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Nagabhushana Netagunte <nagabhushana.netagunte@ti.com>
---
 drivers/media/video/davinci/ccdc_types.h      |   43 +
 drivers/media/video/davinci/dm365_ccdc.c      | 1505 +++++++++++++++++++++++++
 drivers/media/video/davinci/dm365_ccdc.h      |   86 ++
 drivers/media/video/davinci/dm365_ccdc_regs.h |  309 +++++
 include/linux/dm365_ccdc.h                    |  621 ++++++++++
 5 files changed, 2564 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/davinci/ccdc_types.h
 create mode 100644 drivers/media/video/davinci/dm365_ccdc.c
 create mode 100644 drivers/media/video/davinci/dm365_ccdc.h
 create mode 100644 drivers/media/video/davinci/dm365_ccdc_regs.h
 create mode 100644 include/linux/dm365_ccdc.h

diff --git a/drivers/media/video/davinci/ccdc_types.h b/drivers/media/video/davinci/ccdc_types.h
new file mode 100644
index 0000000..5773874
--- /dev/null
+++ b/drivers/media/video/davinci/ccdc_types.h
@@ -0,0 +1,43 @@
+/*
+ * Copyright (C) 2008-2009 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ **************************************************************************/
+#ifndef _CCDC_TYPES_H
+#define _CCDC_TYPES_H
+enum ccdc_pixfmt {
+	CCDC_PIXFMT_RAW,
+	CCDC_PIXFMT_YCBCR_16BIT,
+	CCDC_PIXFMT_YCBCR_8BIT
+};
+
+enum ccdc_frmfmt {
+	CCDC_FRMFMT_PROGRESSIVE,
+	CCDC_FRMFMT_INTERLACED
+};
+
+/* PIXEL ORDER IN MEMORY from LSB to MSB */
+/* only applicable for 8-bit input mode  */
+enum ccdc_pixorder {
+	CCDC_PIXORDER_YCBYCR,
+	CCDC_PIXORDER_CBYCRY,
+};
+
+enum ccdc_buftype {
+	CCDC_BUFTYPE_FLD_INTERLEAVED,
+	CCDC_BUFTYPE_FLD_SEPARATED
+};
+#endif
diff --git a/drivers/media/video/davinci/dm365_ccdc.c b/drivers/media/video/davinci/dm365_ccdc.c
new file mode 100644
index 0000000..04d4292
--- /dev/null
+++ b/drivers/media/video/davinci/dm365_ccdc.c
@@ -0,0 +1,1505 @@
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
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/videodev2.h>
+#include <mach/mux.h>
+#include "dm365_ccdc.h"
+#include "vpss.h"
+#include "dm365_ccdc_regs.h"
+#include "ccdc_hw_device.h"
+
+static struct device *dev;
+
+/* Defauts for module configuation paramaters */
+static struct ccdc_config_params_raw ccdc_config_defaults = {
+	.linearize = {
+		.corr_shft = CCDC_NO_SHIFT,
+		.scale_fact = {1, 0},
+	},
+	.gain_offset = {
+		.gain = {
+			.r_ye = {1, 0},
+			.gr_cy = {1, 0},
+			.gb_g = {1, 0},
+			.b_mg = {1, 0},
+		},
+	},
+	.culling = {
+		.hcpat_odd = 0xff,
+		.hcpat_even = 0xff,
+		.vcpat = 0xff
+	},
+	.compress = {
+		.alg = CCDC_ALAW,
+	},
+};
+
+/* ISIF operation configuration */
+struct ccdc_oper_config {
+	enum v4l2_mbus_pixelcode if_type;
+	struct ccdc_ycbcr_config ycbcr;
+	struct ccdc_params_raw bayer;
+	enum ccdc_data_pack data_pack;
+	void *__iomem base_addr;
+	void *__iomem linear_tbl0_addr;
+	void *__iomem linear_tbl1_addr;
+};
+
+static struct ccdc_oper_config ccdc_cfg = {
+	.ycbcr = {
+		.pix_fmt = CCDC_PIXFMT_YCBCR_8BIT,
+		.frm_fmt = CCDC_FRMFMT_INTERLACED,
+		.win = CCDC_WIN_NTSC,
+		.fid_pol = VPFE_PINPOL_POSITIVE,
+		.vd_pol = VPFE_PINPOL_POSITIVE,
+		.hd_pol = VPFE_PINPOL_POSITIVE,
+		.pix_order = CCDC_PIXORDER_CBYCRY,
+		.buf_type = CCDC_BUFTYPE_FLD_INTERLEAVED,
+	},
+	.bayer = {
+		.pix_fmt = CCDC_PIXFMT_RAW,
+		.frm_fmt = CCDC_FRMFMT_PROGRESSIVE,
+		.win = CCDC_WIN_VGA,
+		.fid_pol = VPFE_PINPOL_POSITIVE,
+		.vd_pol = VPFE_PINPOL_POSITIVE,
+		.hd_pol = VPFE_PINPOL_POSITIVE,
+		.gain = {
+			.r_ye = {1, 0},
+			.gr_cy = {1, 0},
+			.gb_g = {1, 0},
+			.b_mg = {1, 0},
+		},
+		.cfa_pat = CCDC_CFA_PAT_MOSAIC,
+		.data_msb = CCDC_BIT_MSB_11,
+		.config_params = {
+			.data_size = CCDC_12_BITS,
+			.data_shift = CCDC_NO_SHIFT,
+			.col_pat_field0 = {
+				.olop = CCDC_GREEN_BLUE,
+				.olep = CCDC_BLUE,
+				.elop = CCDC_RED,
+				.elep = CCDC_GREEN_RED,
+			},
+			.col_pat_field1 = {
+				.olop = CCDC_GREEN_BLUE,
+				.olep = CCDC_BLUE,
+				.elop = CCDC_RED,
+				.elep = CCDC_GREEN_RED,
+			},
+		},
+	},
+	.data_pack = CCDC_DATA_PACK8,
+};
+
+/* Raw Bayer formats */
+static u32 ccdc_raw_bayer_pix_formats[] = { V4L2_PIX_FMT_SBGGR8,
+					      V4L2_PIX_FMT_SBGGR16};
+
+/* Raw YUV formats */
+static u32 ccdc_raw_yuv_pix_formats[] = { V4L2_PIX_FMT_UYVY,
+					      V4L2_PIX_FMT_YUYV };
+
+/* register access routines */
+static inline u32 regr(u32 offset)
+{
+	return readl(ccdc_cfg.base_addr + offset);
+}
+
+static inline void regw(u32 val, u32 offset)
+{
+	writel(val, ccdc_cfg.base_addr + offset);
+}
+
+static inline u32 ccdc_merge(u32 mask, u32 val, u32 offset)
+{
+	u32 new_val = (regr(offset) & ~mask) | (val & mask);
+
+	regw(new_val, offset);
+
+	return new_val;
+}
+
+static inline void regw_lin_tbl(u32 val, u32 offset, int i)
+{
+	if (!i)
+		writel(val, ccdc_cfg.linear_tbl0_addr + offset);
+	else
+		writel(val, ccdc_cfg.linear_tbl1_addr + offset);
+}
+
+static void ccdc_disable_all_modules(void)
+{
+	/* disable BC */
+	regw(0, CLAMPCFG);
+	/* disable vdfc */
+	regw(0, DFCCTL);
+	/* disable CSC */
+	regw(0, CSCCTL);
+	/* disable linearization */
+	regw(0, LINCFG0);
+	/* disable other modules here as they are supported */
+}
+
+static void ccdc_enable(int en)
+{
+	if (!en) {
+		/* Before disable isif, disable all ISIF modules */
+		ccdc_disable_all_modules();
+		/**
+		 * wait for next VD. Assume lowest scan rate is 12 Hz. So
+		 * 100 msec delay is good enough
+		 */
+	}
+	msleep(100);
+	ccdc_merge(CCDC_SYNCEN_VDHDEN_MASK, en, SYNCEN);
+}
+
+static void ccdc_enable_output_to_sdram(int en)
+{
+	ccdc_merge(CCDC_SYNCEN_WEN_MASK, en << CCDC_SYNCEN_WEN_SHIFT, SYNCEN);
+}
+
+static void ccdc_config_culling(struct ccdc_cul *cul)
+{
+	u32 val;
+
+	/* Horizontal pattern */
+	val = cul->hcpat_even << CULL_PAT_EVEN_LINE_SHIFT;
+	val |= cul->hcpat_odd;
+	regw(val, CULH);
+
+	/* vertical pattern */
+	regw(cul->vcpat, CULV);
+
+	/* LPF */
+	ccdc_merge((CCDC_LPF_MASK << CCDC_LPF_SHIFT),
+		   (cul->en_lpf << CCDC_LPF_SHIFT), MODESET);
+}
+
+static void ccdc_config_gain_offset(void)
+{
+	struct ccdc_gain_offsets_adj *gain_off_ptr =
+		&ccdc_cfg.bayer.config_params.gain_offset;
+	u32 val;
+
+	val = ((gain_off_ptr->gain_sdram_en & 1) << GAIN_SDRAM_EN_SHIFT) |
+	((gain_off_ptr->gain_ipipe_en & 1) << GAIN_IPIPE_EN_SHIFT) |
+	((gain_off_ptr->gain_h3a_en & 1) << GAIN_H3A_EN_SHIFT) |
+	((gain_off_ptr->offset_sdram_en & 1) << OFST_SDRAM_EN_SHIFT) |
+	((gain_off_ptr->offset_ipipe_en & 1) << OFST_IPIPE_EN_SHIFT) |
+	((gain_off_ptr->offset_h3a_en & 1) << OFST_H3A_EN_SHIFT);
+
+	ccdc_merge(GAIN_OFFSET_EN_MASK, val, CGAMMAWD);
+
+	val = (gain_off_ptr->gain.r_ye.integer & GAIN_INTEGER_MASK)
+		<< GAIN_INTEGER_SHIFT;
+	val |= ccdc_cfg.bayer.
+		config_params.gain_offset.gain.r_ye.decimal &
+		GAIN_DECIMAL_MASK;
+	regw(val, CRGAIN);
+
+	val = (gain_off_ptr->gain.gr_cy
+		.integer & GAIN_INTEGER_MASK) << GAIN_INTEGER_SHIFT;
+	val |= gain_off_ptr->gain.gr_cy
+		.decimal & GAIN_DECIMAL_MASK;
+	regw(val, CGRGAIN);
+
+	val = (gain_off_ptr->gain.gb_g
+		.integer & GAIN_INTEGER_MASK) << GAIN_INTEGER_SHIFT;
+	val |= gain_off_ptr->gain.gb_g
+		.decimal & GAIN_DECIMAL_MASK;
+	regw(val, CGBGAIN);
+
+	val = (gain_off_ptr->gain.b_mg
+		.integer & GAIN_INTEGER_MASK) << GAIN_INTEGER_SHIFT;
+	val |= gain_off_ptr->gain.b_mg
+		.decimal & GAIN_DECIMAL_MASK;
+	regw(val, CBGAIN);
+
+	regw((gain_off_ptr->offset &
+		OFFSET_MASK), COFSTA);
+}
+
+static void ccdc_restore_defaults(void)
+{
+	enum vpss_ccdc_source_sel source = VPSS_CCDCIN;
+	int i;
+
+	memcpy(&ccdc_cfg.bayer.config_params, &ccdc_config_defaults,
+		sizeof(struct ccdc_config_params_raw));
+
+	dev_dbg(dev, "\nstarting ccdc_restore_defaults...");
+	/* Enable clock to ISIF, IPIPEIF and BL */
+	vpss_enable_clock(VPSS_CCDC_CLOCK, 1);
+	vpss_enable_clock(VPSS_IPIPEIF_CLOCK, 1);
+	vpss_enable_clock(VPSS_BL_CLOCK, 1);
+
+	/* set all registers to default value */
+	for (i = 0; i <= 0x1f8; i += 4)
+		regw(0, i);
+
+	/* no culling support */
+	regw(0xffff, CULH);
+	regw(0xff, CULV);
+
+	/* Set default offset and gain */
+	ccdc_config_gain_offset();
+
+	vpss_select_ccdc_source(source);
+
+	dev_dbg(dev, "\nEnd of ccdc_restore_defaults...");
+}
+
+static int ccdc_open(struct device *device)
+{
+	dev = device;
+	ccdc_restore_defaults();
+
+	return 0;
+}
+
+/* This function will configure the window size to be capture in CCDC reg */
+static void ccdc_setwin(struct v4l2_rect *image_win,
+			enum ccdc_frmfmt frm_fmt, int ppc, int mode)
+{
+	int horz_nr_pixels;
+	int vert_nr_lines;
+	int horz_start;
+	int vert_start;
+	int mid_img;
+
+	dev_dbg(dev, "\nStarting ccdc_setwin...");
+	/**
+	 * ppc - per pixel count. indicates how many pixels per cell
+	 * output to SDRAM. example, for ycbcr, it is one y and one c, so 2.
+	 * raw capture this is 1
+	 */
+	horz_start = image_win->left << (ppc - 1);
+	horz_nr_pixels = (image_win->width << (ppc - 1)) - 1;
+
+	/* Writing the horizontal info into the registers */
+	regw(horz_start & START_PX_HOR_MASK, SPH);
+	regw(horz_nr_pixels & NUM_PX_HOR_MASK, LNH);
+	vert_start = image_win->top;
+
+	if (frm_fmt == CCDC_FRMFMT_INTERLACED) {
+		vert_nr_lines = (image_win->height >> 1) - 1;
+		vert_start >>= 1;
+		/* To account for VD since line 0 doesn't have any data */
+		vert_start += 1;
+	} else {
+		/* To account for VD since line 0 doesn't have any data */
+		vert_start += 1;
+		vert_nr_lines = image_win->height - 1;
+		/* configure VDINT0 and VDINT1 */
+		mid_img = vert_start + (image_win->height / 2);
+		regw(mid_img, VDINT1);
+	}
+
+	if (!mode)
+		regw(0, VDINT0);
+	else
+		regw(vert_nr_lines, VDINT0);
+	regw(vert_start & START_VER_ONE_MASK, SLV0);
+	regw(vert_start & START_VER_TWO_MASK, SLV1);
+	regw(vert_nr_lines & NUM_LINES_VER, LNV);
+}
+
+static void ccdc_config_bclamp(struct ccdc_black_clamp *bc)
+{
+	u32 val;
+
+	/**
+	 * DC Offset is always added to image data irrespective of bc enable
+	 * status
+	 */
+	val = bc->dc_offset & CCDC_BC_DCOFFSET_MASK;
+	regw(val, CLDCOFST);
+
+	if (!bc->en)
+		return;
+
+	val = (bc->bc_mode_color & CCDC_BC_MODE_COLOR_MASK) <<
+		CCDC_BC_MODE_COLOR_SHIFT;
+
+	/* Enable BC and horizontal clamp caculation paramaters */
+	val = val | 1 | ((bc->horz.mode & CCDC_HORZ_BC_MODE_MASK) <<
+	CCDC_HORZ_BC_MODE_SHIFT);
+
+	regw(val, CLAMPCFG);
+
+	if (bc->horz.mode != CCDC_HORZ_BC_DISABLE) {
+		/**
+		  * Window count for calculation
+		  * Base window selection
+		  * pixel limit
+		  * Horizontal size of window
+		  * vertical size of the window
+		  * Horizontal start position of the window
+		  * Vertical start position of the window
+		  */
+		val = (bc->horz.win_count_calc &
+			CCDC_HORZ_BC_WIN_COUNT_MASK) |
+			((bc->horz.base_win_sel_calc & 1)
+			<< CCDC_HORZ_BC_WIN_SEL_SHIFT) |
+			((bc->horz.clamp_pix_limit & 1)
+			<< CCDC_HORZ_BC_PIX_LIMIT_SHIFT) |
+			((bc->horz.win_h_sz_calc &
+			CCDC_HORZ_BC_WIN_H_SIZE_MASK)
+			<< CCDC_HORZ_BC_WIN_H_SIZE_SHIFT) |
+			((bc->horz.win_v_sz_calc &
+			CCDC_HORZ_BC_WIN_V_SIZE_MASK)
+			<< CCDC_HORZ_BC_WIN_V_SIZE_SHIFT);
+
+		regw(val, CLHWIN0);
+
+		val = bc->horz.win_start_h_calc &
+			CCDC_HORZ_BC_WIN_START_H_MASK;
+		regw(val, CLHWIN1);
+
+		val =
+		    bc->horz.
+		      win_start_v_calc & CCDC_HORZ_BC_WIN_START_V_MASK;
+		regw(val, CLHWIN2);
+	}
+
+	/* vertical clamp caculation paramaters */
+
+	/* OB H Valid */
+	val = bc->vert.ob_h_sz_calc & CCDC_VERT_BC_OB_H_SZ_MASK;
+
+	/* Reset clamp value sel for previous line */
+	val |= (bc->vert.reset_val_sel &
+		CCDC_VERT_BC_RST_VAL_SEL_MASK)
+		<< CCDC_VERT_BC_RST_VAL_SEL_SHIFT;
+
+	/* Line average coefficient */
+	val |= bc->vert.line_ave_coef <<
+		CCDC_VERT_BC_LINE_AVE_COEF_SHIFT;
+	regw(val, CLVWIN0);
+
+	/* Configured reset value */
+	if (bc->vert.reset_val_sel ==
+	    CCDC_VERT_BC_USE_CONFIG_CLAMP_VAL) {
+		val =
+		    bc->vert.
+		      reset_clamp_val & CCDC_VERT_BC_RST_VAL_MASK;
+		regw(val, CLVRV);
+	}
+
+	/* Optical Black horizontal start position */
+	val = bc->vert.ob_start_h & CCDC_VERT_BC_OB_START_HORZ_MASK;
+	regw(val, CLVWIN1);
+
+	/* Optical Black vertical start position */
+	val = bc->vert.ob_start_v & CCDC_VERT_BC_OB_START_VERT_MASK;
+	regw(val, CLVWIN2);
+
+	val = bc->vert.ob_v_sz_calc & CCDC_VERT_BC_OB_VERT_SZ_MASK;
+	regw(val, CLVWIN3);
+
+	/* Vertical start position for BC subtraction */
+	val = bc->vert_start_sub & CCDC_BC_VERT_START_SUB_V_MASK;
+	regw(val, CLSV);
+}
+
+static void ccdc_config_linearization(struct ccdc_linearize *linearize)
+{
+	u32 val;
+	u32 i;
+
+	if (!linearize->en) {
+		regw(0, LINCFG0);
+		return;
+	}
+
+	/* shift value for correction */
+	val = (linearize->corr_shft & CCDC_LIN_CORRSFT_MASK)
+	    << CCDC_LIN_CORRSFT_SHIFT;
+	/* enable */
+	val |= 1;
+	regw(val, LINCFG0);
+
+	/* Scale factor */
+	val = (linearize->scale_fact.integer & 1)
+	    << CCDC_LIN_SCALE_FACT_INTEG_SHIFT;
+	val |= linearize->scale_fact.decimal &
+				CCDC_LIN_SCALE_FACT_DECIMAL_MASK;
+	regw(val, LINCFG1);
+
+	for (i = 0; i < CCDC_LINEAR_TAB_SIZE; i++) {
+		val = linearize->table[i] & CCDC_LIN_ENTRY_MASK;
+		if (i%2)
+			regw_lin_tbl(val, ((i >> 1) << 2), 1);
+		else
+			regw_lin_tbl(val, ((i >> 1) << 2), 0);
+	}
+}
+
+static void ccdc_config_dfc(struct ccdc_dfc *vdfc)
+{
+#define DFC_WRITE_WAIT_COUNT	1000
+	u32 count = DFC_WRITE_WAIT_COUNT;
+	u32 val;
+	int i;
+
+	if (!vdfc->en)
+		return;
+
+	/* Correction mode */
+	val = (vdfc->corr_mode & CCDC_VDFC_CORR_MOD_MASK)
+		<< CCDC_VDFC_CORR_MOD_SHIFT;
+
+	/* Correct whole line or partial */
+	if (vdfc->corr_whole_line)
+		val |= 1 << CCDC_VDFC_CORR_WHOLE_LN_SHIFT;
+
+	/* level shift value */
+	val |= (vdfc->def_level_shift & CCDC_VDFC_LEVEL_SHFT_MASK) <<
+		CCDC_VDFC_LEVEL_SHFT_SHIFT;
+
+	regw(val, DFCCTL);
+
+	/* Defect saturation level */
+	val = vdfc->def_sat_level & CCDC_VDFC_SAT_LEVEL_MASK;
+	regw(val, VDFSATLV);
+
+	regw(vdfc->table[0].pos_vert & CCDC_VDFC_POS_MASK, DFCMEM0);
+	regw(vdfc->table[0].pos_horz & CCDC_VDFC_POS_MASK, DFCMEM1);
+	if (vdfc->corr_mode == CCDC_VDFC_NORMAL ||
+	    vdfc->corr_mode == CCDC_VDFC_HORZ_INTERPOL_IF_SAT) {
+		regw(vdfc->table[0].level_at_pos, DFCMEM2);
+		regw(vdfc->table[0].level_up_pixels, DFCMEM3);
+		regw(vdfc->table[0].level_low_pixels, DFCMEM4);
+	}
+
+	val = regr(DFCMEMCTL);
+	/* set DFCMARST and set DFCMWR */
+	val |= 1 << CCDC_DFCMEMCTL_DFCMARST_SHIFT;
+	val |= 1;
+	regw(val, DFCMEMCTL);
+
+	while (count && (regr(DFCMEMCTL) & 0x01))
+		count--;
+
+	val = regr(DFCMEMCTL);
+	if (!count) {
+		dev_dbg(dev, "defect table write timeout !!!\n");
+		return;
+	}
+
+	for (i = 1; i < vdfc->num_vdefects; i++) {
+		regw(vdfc->table[i].pos_vert & CCDC_VDFC_POS_MASK,
+			   DFCMEM0);
+		regw(vdfc->table[i].pos_horz & CCDC_VDFC_POS_MASK,
+			   DFCMEM1);
+		if (vdfc->corr_mode == CCDC_VDFC_NORMAL ||
+		    vdfc->corr_mode == CCDC_VDFC_HORZ_INTERPOL_IF_SAT) {
+			regw(vdfc->table[i].level_at_pos, DFCMEM2);
+			regw(vdfc->table[i].level_up_pixels, DFCMEM3);
+			regw(vdfc->table[i].level_low_pixels, DFCMEM4);
+		}
+		val = regr(DFCMEMCTL);
+		/* clear DFCMARST and set DFCMWR */
+		val &= ~(1 << CCDC_DFCMEMCTL_DFCMARST_SHIFT);
+		val |= 1;
+		regw(val, DFCMEMCTL);
+
+		count = DFC_WRITE_WAIT_COUNT;
+		while (count && (regr(DFCMEMCTL) & 0x01))
+			count--;
+
+		val = regr(DFCMEMCTL);
+		if (!count) {
+			dev_err(dev, "defect table write timeout !!!\n");
+			return;
+		}
+	}
+	if (vdfc->num_vdefects < CCDC_VDFC_TABLE_SIZE) {
+		/* Extra cycle needed */
+		regw(0, DFCMEM0);
+		regw(0x1FFF, DFCMEM1);
+		val = 1;
+		regw(val, DFCMEMCTL);
+	}
+
+	/* enable VDFC */
+	ccdc_merge((1 << CCDC_VDFC_EN_SHIFT), (1 << CCDC_VDFC_EN_SHIFT),
+		   DFCCTL);
+
+	ccdc_merge((1 << CCDC_VDFC_EN_SHIFT), (0 << CCDC_VDFC_EN_SHIFT),
+		   DFCCTL);
+
+	regw(0x6, DFCMEMCTL);
+	for (i = 0 ; i < vdfc->num_vdefects; i++) {
+		count = DFC_WRITE_WAIT_COUNT;
+		while (count && (regr(DFCMEMCTL) & 0x2))
+			count--;
+
+		val = regr(DFCMEMCTL);
+		if (!count) {
+			dev_err(dev, "defect table write timeout !!!\n");
+			return;
+		}
+
+		val = regr(DFCMEM0) | regr(DFCMEM1) | regr(DFCMEM2) |
+			regr(DFCMEM3) | regr(DFCMEM4);
+		regw(0x2, DFCMEMCTL);
+	}
+}
+
+static void ccdc_config_csc(struct ccdc_df_csc *df_csc)
+{
+	u32 val1;
+	u32 val2;
+	u32 i;
+
+	if (!df_csc->csc.en) {
+		regw(0, CSCCTL);
+		return;
+	}
+
+	/* initialize all bits to 0 */
+	val1 = 0;
+
+	for (i = 0; i < CCDC_CSC_NUM_COEFF; i++) {
+		if ((i % 2) == 0) {
+			/* CSCM - LSB */
+			val1 =
+				((df_csc->csc.coeff[i].integer &
+				CCDC_CSC_COEF_INTEG_MASK)
+				<< CCDC_CSC_COEF_INTEG_SHIFT) |
+				((df_csc->csc.coeff[i].decimal &
+				CCDC_CSC_COEF_DECIMAL_MASK));
+		} else {
+
+			/* CSCM - MSB */
+			val2 =
+				((df_csc->csc.coeff[i].integer &
+				CCDC_CSC_COEF_INTEG_MASK)
+				<< CCDC_CSC_COEF_INTEG_SHIFT) |
+				((df_csc->csc.coeff[i].decimal &
+				CCDC_CSC_COEF_DECIMAL_MASK));
+			val2 <<= CCDC_CSCM_MSB_SHIFT;
+			val2 |= val1;
+			regw(val2, (CSCM0 + ((i-1) << 1)));
+		}
+	}
+
+	/* program the active area */
+	regw(df_csc->start_pix & CCDC_DF_CSC_SPH_MASK, FMTSPH);
+	/**
+	 * one extra pixel as required for CSC. Actually number of
+	 * pixel - 1 should be configured in this register. So we
+	 * need to subtract 1 before writing to FMTSPH, but we will
+	 * not do this since csc requires one extra pixel
+	 */
+	regw((df_csc->num_pixels) & CCDC_DF_CSC_SPH_MASK, FMTLNH);
+	regw(df_csc->start_line & CCDC_DF_CSC_SPH_MASK, FMTSLV);
+	/**
+	 * one extra line as required for CSC. See reason documented for
+	 * num_pixels
+	 */
+	regw((df_csc->num_lines) & CCDC_DF_CSC_SPH_MASK, FMTLNV);
+
+	/* Enable CSC */
+	regw(1, CSCCTL);
+}
+
+static int ccdc_config_raw(int mode)
+{
+	struct ccdc_params_raw *params = &ccdc_cfg.bayer;
+	struct ccdc_config_params_raw *module_params =
+		&ccdc_cfg.bayer.config_params;
+	struct vpss_pg_frame_size frame_size;
+	struct vpss_sync_pol sync;
+	u32 val;
+
+	dev_dbg(dev, "\nStarting ccdc_config_raw..\n");
+
+	/* In case of user has set BT656IF earlier, it should be reset
+	   when configuring for raw input.
+	 */
+	regw(0, REC656IF);
+
+	/* Configure CCDCFG register */
+
+	/**
+	 * Set CCD Not to swap input since input is RAW data
+	 * Set FID detection function to Latch at V-Sync
+	 * Set WENLOG - ccdc valid area
+	 * Set TRGSEL
+	 * Set EXTRG
+	 * Packed to 8 or 16 bits
+	 */
+
+	val = CCDC_YCINSWP_RAW | CCDC_CCDCFG_FIDMD_LATCH_VSYNC |
+		CCDC_CCDCFG_WENLOG_AND | CCDC_CCDCFG_TRGSEL_WEN |
+		CCDC_CCDCFG_EXTRG_DISABLE | (ccdc_cfg.data_pack &
+		CCDC_DATA_PACK_MASK);
+
+	dev_dbg(dev, "Writing 0x%x to ...CCDCFG\n", val);
+	regw(val, CCDCFG);
+
+	/**
+	 * Configure the vertical sync polarity(MODESET.VDPOL)
+	 * Configure the horizontal sync polarity (MODESET.HDPOL)
+	 * Configure frame id polarity (MODESET.FLDPOL)
+	 * Configure data polarity
+	 * Configure External WEN Selection
+	 * Configure frame format(progressive or interlace)
+	 * Configure pixel format (Input mode)
+	 * Configure the data shift
+	 */
+
+	val = CCDC_VDHDOUT_INPUT |
+		((params->vd_pol & CCDC_VD_POL_MASK) << CCDC_VD_POL_SHIFT) |
+		((params->hd_pol & CCDC_HD_POL_MASK) << CCDC_HD_POL_SHIFT) |
+		((params->fid_pol & CCDC_FID_POL_MASK) << CCDC_FID_POL_SHIFT) |
+		((CCDC_DATAPOL_NORMAL & CCDC_DATAPOL_MASK)
+			<< CCDC_DATAPOL_SHIFT) |
+		((CCDC_EXWEN_DISABLE & CCDC_EXWEN_MASK) << CCDC_EXWEN_SHIFT) |
+		((params->frm_fmt & CCDC_FRM_FMT_MASK) << CCDC_FRM_FMT_SHIFT) |
+		((params->pix_fmt & CCDC_INPUT_MASK) << CCDC_INPUT_SHIFT) |
+		((params->config_params.data_shift & CCDC_DATASFT_MASK)
+			<< CCDC_DATASFT_SHIFT);
+
+	regw(val, MODESET);
+	dev_dbg(dev, "Writing 0x%x to MODESET...\n", val);
+
+	/**
+	 * Configure GAMMAWD register
+	 * CFA pattern setting
+	 */
+	val = (params->cfa_pat & CCDC_GAMMAWD_CFA_MASK) <<
+		CCDC_GAMMAWD_CFA_SHIFT;
+
+	/* Gamma msb */
+	if (module_params->compress.alg == CCDC_ALAW)
+		val = val | CCDC_ALAW_ENABLE;
+
+	val = val | ((params->data_msb & CCDC_ALAW_GAMA_WD_MASK) <<
+			CCDC_ALAW_GAMA_WD_SHIFT);
+
+	regw(val, CGAMMAWD);
+
+	/* Configure DPCM compression settings */
+	if (module_params->compress.alg == CCDC_DPCM) {
+		val =  1 << CCDC_DPCM_EN_SHIFT;
+		val |= (module_params->compress.pred &
+			CCDC_DPCM_PREDICTOR_MASK) << CCDC_DPCM_PREDICTOR_SHIFT;
+	}
+
+	regw(val, MISC);
+	/* Configure Gain & Offset */
+
+	ccdc_config_gain_offset();
+
+	/* Configure Color pattern */
+	val = params->config_params.col_pat_field0.olop |
+	(params->config_params.col_pat_field0.olep << 2) |
+	(params->config_params.col_pat_field0.elop << 4) |
+	(params->config_params.col_pat_field0.elep << 6) |
+	(params->config_params.col_pat_field1.olop << 8) |
+	(params->config_params.col_pat_field1.olep << 10) |
+	(params->config_params.col_pat_field1.elop << 12) |
+	(params->config_params.col_pat_field1.elep << 14);
+	regw(val, CCOLP);
+	dev_dbg(dev, "Writing %x to CCOLP ...\n", val);
+
+	/* Configure HSIZE register  */
+	val =
+	    (params->
+	     horz_flip_en & CCDC_HSIZE_FLIP_MASK) << CCDC_HSIZE_FLIP_SHIFT;
+
+	/* calculate line offset in 32 bytes based on pack value */
+	if (ccdc_cfg.data_pack == CCDC_PACK_8BIT)
+		val |= ((params->win.width + 31) >> 5) & CCDC_LINEOFST_MASK;
+	else if (ccdc_cfg.data_pack == CCDC_PACK_12BIT)
+		val |= ((((params->win.width +
+			   (params->win.width >> 2)) +
+			  31) >> 5) & CCDC_LINEOFST_MASK);
+	else
+		val |=
+		    (((params->win.width * 2) +
+		       31) >> 5) & CCDC_LINEOFST_MASK;
+	regw(val, HSIZE);
+
+	/* Configure SDOFST register  */
+	if (params->frm_fmt == CCDC_FRMFMT_INTERLACED) {
+		if (params->image_invert_en) {
+			/* For interlace inverse mode */
+			regw(0x4B6D, SDOFST);
+			dev_dbg(dev, "Writing 0x4B6D to SDOFST...\n");
+		} else {
+			/* For interlace non inverse mode */
+			regw(0x0B6D, SDOFST);
+			dev_dbg(dev, "Writing 0x0B6D to SDOFST...\n");
+		}
+	} else if (params->frm_fmt == CCDC_FRMFMT_PROGRESSIVE) {
+		if (params->image_invert_en) {
+			/* For progessive inverse mode */
+			regw(0x4000, SDOFST);
+			dev_dbg(dev, "Writing 0x4000 to SDOFST...\n");
+		} else {
+			/* For progessive non inverse mode */
+			regw(0x0000, SDOFST);
+			dev_dbg(dev, "Writing 0x0000 to SDOFST...\n");
+		}
+	}
+
+	/* Configure video window */
+	ccdc_setwin(&params->win, params->frm_fmt, 1, mode);
+
+	/* Configure Black Clamp */
+	ccdc_config_bclamp(&module_params->bclamp);
+
+	/* Configure Vertical Defection Pixel Correction */
+	ccdc_config_dfc(&module_params->dfc);
+
+	if (!module_params->df_csc.df_or_csc)
+		/* Configure Color Space Conversion */
+		ccdc_config_csc(&module_params->df_csc);
+
+	ccdc_config_linearization(&module_params->linearize);
+
+	/* Configure Culling */
+	ccdc_config_culling(&module_params->culling);
+
+	/* Configure Horizontal and vertical offsets(DFC,LSC,Gain) */
+	val = module_params->horz_offset & CCDC_DATA_H_OFFSET_MASK;
+	regw(val, DATAHOFST);
+
+	val = module_params->vert_offset & CCDC_DATA_V_OFFSET_MASK;
+	regw(val, DATAVOFST);
+
+	/* Setup test pattern if enabled */
+	if (params->config_params.test_pat_gen) {
+		/* Use the HD/VD pol settings from user */
+		sync.ccdpg_hdpol = params->hd_pol & CCDC_HD_POL_MASK;
+		sync.ccdpg_vdpol = params->vd_pol & CCDC_VD_POL_MASK;
+
+		vpss_set_sync_pol(sync);
+
+		frame_size.hlpfr = ccdc_cfg.bayer.win.width;
+		frame_size.pplen = ccdc_cfg.bayer.win.height;
+		vpss_set_pg_frame_size(frame_size);
+		vpss_select_ccdc_source(VPSS_PGLPBK);
+	}
+
+	dev_dbg(dev, "\nEnd of ccdc_config_ycbcr...\n");
+
+	return 0;
+}
+
+static int ccdc_validate_df_csc_params(struct ccdc_df_csc *df_csc)
+{
+	struct ccdc_color_space_conv *csc;
+	int err = -EINVAL;
+	int csc_df_en;
+	int i;
+
+	if (!df_csc->df_or_csc) {
+		/* csc configuration */
+		csc = &df_csc->csc;
+		if (csc->en) {
+			csc_df_en = 1;
+			for (i = 0; i < CCDC_CSC_NUM_COEFF; i++) {
+				if (csc->coeff[i].integer >
+					CCDC_CSC_COEF_INTEG_MASK ||
+				    csc->coeff[i].decimal >
+					CCDC_CSC_COEF_DECIMAL_MASK) {
+					dev_dbg(dev,
+						"invalid csc coefficients\n");
+					return err;
+				}
+			}
+		}
+	}
+
+	if (df_csc->start_pix > CCDC_DF_CSC_SPH_MASK) {
+		dev_dbg(dev, "invalid df_csc start pix value\n");
+		return err;
+	}
+	if (df_csc->num_pixels > CCDC_DF_NUMPIX) {
+		dev_dbg(dev, "invalid df_csc num pixels value\n");
+		return err;
+	}
+	if (df_csc->start_line > CCDC_DF_CSC_LNH_MASK) {
+		dev_dbg(dev, "invalid df_csc start_line value\n");
+		return err;
+	}
+	if (df_csc->num_lines > CCDC_DF_NUMLINES) {
+		dev_dbg(dev, "invalid df_csc num_lines value\n");
+		return err;
+	}
+
+	return 0;
+}
+
+static int ccdc_validate_dfc_params(struct ccdc_dfc *dfc)
+{
+	int err = -EINVAL;
+	int i;
+
+	if (dfc->en) {
+		if (dfc->corr_whole_line > 1) {
+			dev_dbg(dev, "invalid corr_whole_line value\n");
+			return err;
+		}
+
+		if (dfc->def_level_shift > 4) {
+			dev_dbg(dev, "invalid def_level_shift value\n");
+			return err;
+		}
+
+		if (dfc->def_sat_level > 4095) {
+			dev_dbg(dev, "invalid def_sat_level value\n");
+			return err;
+		}
+
+		if ((!dfc->num_vdefects) || (dfc->num_vdefects > 8)) {
+			dev_dbg(dev, "invalid num_vdefects value\n");
+			return err;
+		}
+
+		for (i = 0; i < CCDC_VDFC_TABLE_SIZE; i++) {
+			if (dfc->table[i].pos_vert > 0x1fff) {
+				dev_dbg(dev, "invalid pos_vert value\n");
+				return err;
+			}
+
+			if (dfc->table[i].pos_horz > 0x1fff) {
+				dev_dbg(dev, "invalid pos_horz value\n");
+				return err;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int ccdc_validate_bclamp_params(struct ccdc_black_clamp *bclamp)
+{
+	int err = -EINVAL;
+
+	if (bclamp->dc_offset > 0x1fff) {
+		dev_dbg(dev, "invalid bclamp dc_offset value\n");
+		return err;
+	}
+
+	if (bclamp->en) {
+		if (bclamp->horz.clamp_pix_limit > 1) {
+			dev_dbg(dev,
+				"invalid bclamp horz clamp_pix_limit value\n");
+			return err;
+		}
+
+		if (bclamp->horz.win_count_calc < 1 ||
+		    bclamp->horz.win_count_calc > 32) {
+			dev_dbg(dev,
+				"invalid bclamp horz win_count_calc value\n");
+			return err;
+		}
+
+		if (bclamp->horz.win_start_h_calc > 0x1fff) {
+			dev_dbg(dev,
+				"invalid bclamp win_start_v_calc value\n");
+			return err;
+		}
+
+		if (bclamp->horz.win_start_v_calc > 0x1fff) {
+			dev_dbg(dev,
+				"invalid bclamp win_start_v_calc value\n");
+			return err;
+		}
+
+		if (bclamp->vert.reset_clamp_val > 0xfff) {
+			dev_dbg(dev, "invalid bclamp reset_clamp_val value\n");
+			return err;
+		}
+
+		if (bclamp->vert.ob_v_sz_calc > 0x1fff) {
+			dev_dbg(dev, "invalid bclamp ob_v_sz_calc value\n");
+			return err;
+		}
+
+		if (bclamp->vert.ob_start_h > 0x1fff) {
+			dev_dbg(dev, "invalid bclamp ob_start_h value\n");
+			return err;
+		}
+
+		if (bclamp->vert.ob_start_v > 0x1fff) {
+			dev_dbg(dev, "invalid bclamp ob_start_h value\n");
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static int ccdc_validate_gain_ofst_params(struct ccdc_gain_offsets_adj
+					  *gain_offset)
+{
+	int err = -EINVAL;
+
+	if (gain_offset->gain_sdram_en ||
+	    gain_offset->gain_ipipe_en ||
+	    gain_offset->gain_h3a_en) {
+		if ((gain_offset->gain.r_ye.integer > 7) ||
+		    (gain_offset->gain.r_ye.decimal > 0x1ff)) {
+			dev_dbg(dev, "invalid  gain r_ye\n");
+			return err;
+		}
+		if ((gain_offset->gain.gr_cy.integer > 7) ||
+		    (gain_offset->gain.gr_cy.decimal > 0x1ff)) {
+			dev_dbg(dev, "invalid  gain gr_cy\n");
+			return err;
+		}
+		if ((gain_offset->gain.gb_g.integer > 7) ||
+		    (gain_offset->gain.gb_g.decimal > 0x1ff)) {
+			dev_dbg(dev, "invalid  gain gb_g\n");
+			return err;
+		}
+		if ((gain_offset->gain.b_mg.integer > 7) ||
+		    (gain_offset->gain.b_mg.decimal > 0x1ff)) {
+			dev_dbg(dev, "invalid  gain b_mg\n");
+			return err;
+		}
+	}
+	if (gain_offset->offset_sdram_en ||
+	    gain_offset->offset_ipipe_en ||
+	    gain_offset->offset_h3a_en) {
+		if (gain_offset->offset > 0xfff) {
+			dev_dbg(dev, "invalid  gain b_mg\n");
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static int
+validate_ccdc_config_params_raw(struct ccdc_config_params_raw *params)
+{
+	int err;
+
+	err = ccdc_validate_df_csc_params(&params->df_csc);
+	if (err)
+		goto exit;
+	err = ccdc_validate_dfc_params(&params->dfc);
+	if (err)
+		goto exit;
+	err = ccdc_validate_bclamp_params(&params->bclamp);
+	if (err)
+		goto exit;
+	err = ccdc_validate_gain_ofst_params(&params->gain_offset);
+exit:
+	return err;
+}
+
+static int ccdc_set_buftype(enum ccdc_buftype buf_type)
+{
+	if (ccdc_cfg.if_type == V4L2_MBUS_FMT_SBGGR10_1X10)
+		ccdc_cfg.bayer.buf_type = buf_type;
+	else
+		ccdc_cfg.ycbcr.buf_type = buf_type;
+
+	return 0;
+}
+
+static enum ccdc_buftype ccdc_get_buftype(void)
+{
+	if (ccdc_cfg.if_type == V4L2_MBUS_FMT_SBGGR10_1X10)
+		return ccdc_cfg.bayer.buf_type;
+
+	return ccdc_cfg.ycbcr.buf_type;
+}
+
+static int ccdc_enum_pix(u32 *pix, int i)
+{
+	int ret = -EINVAL;
+
+	if (ccdc_cfg.if_type == V4L2_MBUS_FMT_SBGGR10_1X10) {
+		if (i < ARRAY_SIZE(ccdc_raw_bayer_pix_formats)) {
+			*pix = ccdc_raw_bayer_pix_formats[i];
+			ret = 0;
+		}
+	} else {
+		if (i < ARRAY_SIZE(ccdc_raw_yuv_pix_formats)) {
+			*pix = ccdc_raw_yuv_pix_formats[i];
+			ret = 0;
+		}
+	}
+
+	return ret;
+}
+
+static int ccdc_set_pixel_format(unsigned int pixfmt)
+{
+	if (ccdc_cfg.if_type == V4L2_MBUS_FMT_SBGGR10_1X10) {
+		if (pixfmt == V4L2_PIX_FMT_SBGGR8) {
+			if ((ccdc_cfg.bayer.config_params.compress.alg !=
+					CCDC_ALAW) &&
+			    (ccdc_cfg.bayer.config_params.compress.alg !=
+					CCDC_DPCM)) {
+				dev_dbg(dev, "Either configure A-Law or"
+						"DPCM\n");
+				return -EINVAL;
+			}
+			ccdc_cfg.data_pack = CCDC_PACK_8BIT;
+		} else if (pixfmt == V4L2_PIX_FMT_SBGGR16) {
+			ccdc_cfg.bayer.config_params.compress.alg =
+					CCDC_NO_COMPRESSION;
+			ccdc_cfg.data_pack = CCDC_PACK_16BIT;
+		} else {
+			return -EINVAL;
+		}
+		ccdc_cfg.bayer.pix_fmt = CCDC_PIXFMT_RAW;
+	} else {
+		if (pixfmt == V4L2_PIX_FMT_YUYV)
+			ccdc_cfg.ycbcr.pix_order = CCDC_PIXORDER_YCBYCR;
+		else if (pixfmt == V4L2_PIX_FMT_UYVY)
+			ccdc_cfg.ycbcr.pix_order = CCDC_PIXORDER_CBYCRY;
+		else
+		  return -EINVAL;
+
+		ccdc_cfg.data_pack = CCDC_PACK_8BIT;
+	}
+
+	return 0;
+}
+
+static u32 ccdc_get_pixel_format(void)
+{
+	u32 pixfmt;
+
+	if (ccdc_cfg.if_type == V4L2_MBUS_FMT_SBGGR10_1X10)
+		if (ccdc_cfg.bayer.config_params.compress.alg
+			== CCDC_ALAW
+			|| ccdc_cfg.bayer.config_params.compress.alg
+			== CCDC_DPCM)
+				pixfmt = V4L2_PIX_FMT_SBGGR8;
+		else
+			pixfmt = V4L2_PIX_FMT_SBGGR16;
+	else {
+		if (ccdc_cfg.ycbcr.pix_order == CCDC_PIXORDER_YCBYCR)
+			pixfmt = V4L2_PIX_FMT_YUYV;
+		else
+			pixfmt = V4L2_PIX_FMT_UYVY;
+	}
+	return pixfmt;
+}
+
+static int ccdc_set_image_window(struct v4l2_rect *win)
+{
+	if (ccdc_cfg.if_type == V4L2_MBUS_FMT_SBGGR10_1X10) {
+		ccdc_cfg.bayer.win.top = win->top;
+		ccdc_cfg.bayer.win.left = win->left;
+		ccdc_cfg.bayer.win.width = win->width;
+		ccdc_cfg.bayer.win.height = win->height;
+	} else {
+		ccdc_cfg.ycbcr.win.top = win->top;
+		ccdc_cfg.ycbcr.win.left = win->left;
+		ccdc_cfg.ycbcr.win.width = win->width;
+		ccdc_cfg.ycbcr.win.height = win->height;
+	}
+
+	return 0;
+}
+
+static void ccdc_get_image_window(struct v4l2_rect *win)
+{
+	if (ccdc_cfg.if_type == V4L2_MBUS_FMT_SBGGR10_1X10)
+		*win = ccdc_cfg.bayer.win;
+	else
+		*win = ccdc_cfg.ycbcr.win;
+}
+
+static unsigned int ccdc_get_line_length(void)
+{
+	unsigned int len;
+
+	if (ccdc_cfg.if_type == V4L2_MBUS_FMT_SBGGR10_1X10) {
+		if (ccdc_cfg.data_pack == CCDC_PACK_8BIT)
+			len = ((ccdc_cfg.bayer.win.width));
+		else if (ccdc_cfg.data_pack == CCDC_PACK_12BIT)
+			len = (((ccdc_cfg.bayer.win.width * 2) +
+				 (ccdc_cfg.bayer.win.width >> 2)));
+		else
+			len = (((ccdc_cfg.bayer.win.width * 2)));
+	} else
+		len = (((ccdc_cfg.ycbcr.win.width * 2)));
+
+	return ALIGN(len, 32);
+}
+
+static int ccdc_set_frame_format(enum ccdc_frmfmt frm_fmt)
+{
+	if (ccdc_cfg.if_type == V4L2_MBUS_FMT_SBGGR10_1X10)
+		ccdc_cfg.bayer.frm_fmt = frm_fmt;
+	else
+		ccdc_cfg.ycbcr.frm_fmt = frm_fmt;
+
+	return 0;
+}
+
+static enum ccdc_frmfmt ccdc_get_frame_format(void)
+{
+	if (ccdc_cfg.if_type == V4L2_MBUS_FMT_SBGGR10_1X10)
+		return ccdc_cfg.bayer.frm_fmt;
+	else
+		return ccdc_cfg.ycbcr.frm_fmt;
+}
+
+static int ccdc_getfid(void)
+{
+	return (regr(MODESET) >> 15) & 0x1;
+}
+
+/* misc operations */
+static void ccdc_setfbaddr(unsigned long addr)
+{
+	regw((addr >> 21) & 0x07ff, CADU);
+	regw((addr >> 5) & 0x0ffff, CADL);
+}
+
+static int ccdc_set_hw_if_params(struct vpfe_hw_if_param *params)
+{
+	ccdc_cfg.if_type = params->if_type;
+
+	switch (params->if_type) {
+	case V4L2_MBUS_FMT_YUYV8_2X8:
+	case V4L2_MBUS_FMT_YUYV10_2X10:
+	case V4L2_MBUS_FMT_Y8_1X8:
+		ccdc_cfg.ycbcr.pix_fmt = CCDC_PIXFMT_YCBCR_8BIT;
+		ccdc_cfg.ycbcr.pix_order = CCDC_PIXORDER_CBYCRY;
+		break;
+	case V4L2_MBUS_FMT_YUYV10_1X20:
+	case V4L2_MBUS_FMT_YUYV8_1X16:
+		ccdc_cfg.ycbcr.pix_fmt = CCDC_PIXFMT_YCBCR_16BIT;
+		ccdc_cfg.ycbcr.pix_order = CCDC_PIXORDER_CBYCRY;
+		break;
+	case V4L2_MBUS_FMT_SBGGR10_1X10:
+		ccdc_cfg.bayer.pix_fmt = CCDC_PIXFMT_RAW;
+		break;
+	default:
+		dev_dbg(dev, "Invalid interface type\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* Parameter operations */
+static int ccdc_get_params(void *params)
+{
+	/* only raw module parameters can be set through the IOCTL */
+	if (ccdc_cfg.if_type != V4L2_MBUS_FMT_SBGGR10_1X10)
+		return -EINVAL;
+
+	memcpy(params,
+			&ccdc_cfg.bayer.config_params,
+			sizeof(ccdc_cfg.bayer.config_params));
+
+	return 0;
+}
+
+/* Parameter operations */
+static int ccdc_set_params(void *params)
+{
+	struct ccdc_config_params_raw ccdc_raw_params;
+	int ret = -EINVAL;
+
+	/* only raw module parameters can be set through the IOCTL */
+	if (ccdc_cfg.if_type != V4L2_MBUS_FMT_SBGGR10_1X10)
+		return ret;
+
+	memcpy(&ccdc_raw_params, params, sizeof(ccdc_raw_params));
+
+	if (!validate_ccdc_config_params_raw(&ccdc_raw_params)) {
+		memcpy(&ccdc_cfg.bayer.config_params,
+			&ccdc_raw_params,
+			sizeof(ccdc_raw_params));
+		ret = 0;
+	}
+
+	return ret;
+}
+
+/* This function will configure CCDC for YCbCr parameters. */
+static int ccdc_config_ycbcr(int mode)
+{
+	struct ccdc_ycbcr_config *params = &ccdc_cfg.ycbcr;
+	struct vpss_pg_frame_size frame_size;
+	struct vpss_sync_pol sync;
+	u32 modeset;
+	u32 ccdcfg;
+
+	/**
+	 * first reset the CCDC
+	 * all registers have default values after reset
+	 * This is important since we assume default values to be set in
+	 * a lot of registers that we didn't touch
+	 */
+	dev_dbg(dev, "\nStarting ccdc_config_ycbcr...");
+
+	/* start with all bits zero */
+	modeset = 0;
+	ccdcfg = 0;
+
+	/* configure pixel format or input mode */
+	modeset = modeset | ((params->pix_fmt & CCDC_INPUT_MASK)
+		<< CCDC_INPUT_SHIFT) |
+	((params->frm_fmt & CCDC_FRM_FMT_MASK) << CCDC_FRM_FMT_SHIFT) |
+	(((params->fid_pol & CCDC_FID_POL_MASK) << CCDC_FID_POL_SHIFT))	|
+	(((params->hd_pol & CCDC_HD_POL_MASK) << CCDC_HD_POL_SHIFT)) |
+	(((params->vd_pol & CCDC_VD_POL_MASK) << CCDC_VD_POL_SHIFT));
+
+	/* pack the data to 8-bit CCDCCFG */
+	switch (ccdc_cfg.if_type) {
+	case V4L2_MBUS_FMT_YUYV8_2X8:
+		if (params->pix_fmt != CCDC_PIXFMT_YCBCR_8BIT) {
+			dev_dbg(dev, "Invalid pix_fmt(input mode)\n");
+			return -EINVAL;
+		}
+		modeset |=
+			((VPFE_PINPOL_NEGATIVE & CCDC_VD_POL_MASK)
+			<< CCDC_VD_POL_SHIFT);
+		regw(3, REC656IF);
+		ccdcfg = ccdcfg | CCDC_DATA_PACK8 | CCDC_YCINSWP_YCBCR;
+		break;
+	case V4L2_MBUS_FMT_YUYV10_2X10:
+		if (params->pix_fmt != CCDC_PIXFMT_YCBCR_8BIT) {
+			dev_dbg(dev, "Invalid pix_fmt(input mode)\n");
+			return -EINVAL;
+		}
+		/* setup BT.656, embedded sync  */
+		regw(3, REC656IF);
+		/* enable 10 bit mode in ccdcfg */
+		ccdcfg = ccdcfg | CCDC_DATA_PACK8 | CCDC_YCINSWP_YCBCR |
+			CCDC_BW656_ENABLE;
+		break;
+	case V4L2_MBUS_FMT_YUYV10_1X20:
+		if (params->pix_fmt != CCDC_PIXFMT_YCBCR_16BIT) {
+			dev_dbg(dev, "Invalid pix_fmt(input mode)\n");
+			return -EINVAL;
+		}
+		regw(3, REC656IF);
+		break;
+
+	case V4L2_MBUS_FMT_Y8_1X8:
+		ccdcfg |= CCDC_DATA_PACK8;
+		ccdcfg |= CCDC_YCINSWP_YCBCR;
+		if (params->pix_fmt != CCDC_PIXFMT_YCBCR_8BIT) {
+			dev_dbg(dev, "Invalid pix_fmt(input mode)\n");
+			return -EINVAL;
+		}
+		break;
+	case V4L2_MBUS_FMT_YUYV8_1X16:
+		if (params->pix_fmt != CCDC_PIXFMT_YCBCR_16BIT) {
+			dev_dbg(dev, "Invalid pix_fmt(input mode)\n");
+			return -EINVAL;
+		}
+		break;
+	default:
+		/* should never come here */
+		dev_dbg(dev, "Invalid interface type\n");
+		return -EINVAL;
+	}
+
+	regw(modeset, MODESET);
+
+	/* Set up pix order */
+	ccdcfg |= (params->pix_order & CCDC_PIX_ORDER_MASK) <<
+		CCDC_PIX_ORDER_SHIFT;
+
+	regw(ccdcfg, CCDCFG);
+
+	/* configure video window */
+	if ((ccdc_cfg.if_type == V4L2_MBUS_FMT_YUYV10_1X20) ||
+	    (ccdc_cfg.if_type == V4L2_MBUS_FMT_YUYV8_1X16))
+		ccdc_setwin(&params->win, params->frm_fmt, 1, mode);
+	else
+		ccdc_setwin(&params->win, params->frm_fmt, 2, mode);
+
+	/**
+	 * configure the horizontal line offset
+	 * this is done by rounding up width to a multiple of 16 pixels
+	 * and multiply by two to account for y:cb:cr 4:2:2 data
+	 */
+	regw(((((params->win.width * 2) + 31) & 0xffffffe0) >> 5), HSIZE);
+
+	/* configure the memory line offset */
+	if ((params->frm_fmt == CCDC_FRMFMT_INTERLACED) &&
+	    (params->buf_type == CCDC_BUFTYPE_FLD_INTERLEAVED)) {
+		/* two fields are interleaved in memory */
+		regw(0x00000249, SDOFST);
+	}
+
+	/* Setup test pattern if enabled */
+	if (ccdc_cfg.bayer.config_params.test_pat_gen) {
+		sync.ccdpg_hdpol = (params->hd_pol & CCDC_HD_POL_MASK);
+		sync.ccdpg_vdpol = (params->vd_pol & CCDC_VD_POL_MASK);
+		vpss_set_sync_pol(sync);
+		vpss_set_pg_frame_size(frame_size);
+	}
+
+	return 0;
+}
+
+static int ccdc_configure(int mode)
+{
+	if (ccdc_cfg.if_type == V4L2_MBUS_FMT_SBGGR10_1X10)
+		return ccdc_config_raw(mode);
+	else
+		ccdc_config_ycbcr(mode);
+
+	return 0;
+}
+
+static int ccdc_close(struct device *device)
+{
+	/* copy defaults to module params */
+	memcpy(&ccdc_cfg.bayer.config_params,
+	       &ccdc_config_defaults,
+	       sizeof(struct ccdc_config_params_raw));
+
+	return 0;
+}
+
+static struct ccdc_hw_device ccdc_hw_dev = {
+	.name = "dm365_isif",
+	.owner = THIS_MODULE,
+	.hw_ops = {
+		.open = ccdc_open,
+		.close = ccdc_close,
+		.enable = ccdc_enable,
+		.enable_out_to_sdram = ccdc_enable_output_to_sdram,
+		.set_hw_if_params = ccdc_set_hw_if_params,
+		.set_params = ccdc_set_params,
+		.get_params = ccdc_get_params,
+		.configure = ccdc_configure,
+		.set_buftype = ccdc_set_buftype,
+		.get_buftype = ccdc_get_buftype,
+		.enum_pix = ccdc_enum_pix,
+		.set_pixel_format = ccdc_set_pixel_format,
+		.get_pixel_format = ccdc_get_pixel_format,
+		.set_frame_format = ccdc_set_frame_format,
+		.get_frame_format = ccdc_get_frame_format,
+		.set_image_window = ccdc_set_image_window,
+		.get_image_window = ccdc_get_image_window,
+		.get_line_length = ccdc_get_line_length,
+		.setfbaddr = ccdc_setfbaddr,
+		.getfid = ccdc_getfid,
+	},
+};
+
+struct ccdc_hw_device *get_ccdc_dev(void)
+{
+	return &ccdc_hw_dev;
+}
+
+int ccdc_init(struct platform_device *pdev)
+{
+	static resource_size_t res_len;
+	struct resource *res;
+	void *__iomem addr;
+	int status;
+	int i;
+
+	i = 0;
+	/* Get the ISIF base address, linearization table0 and table1 addr. */
+	while (i < 3) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
+		if (!res) {
+			status = -ENOENT;
+			goto fail_nobase_res;
+		}
+		res_len = res->end - res->start + 1;
+		res = request_mem_region(res->start, res_len, res->name);
+		if (!res) {
+			status = -EBUSY;
+			goto fail_nobase_res;
+		}
+		addr = ioremap_nocache(res->start, res_len);
+		if (!addr) {
+			status = -EBUSY;
+			goto fail_base_iomap;
+		}
+		switch (i) {
+		case 0:
+			/* ISIF base address */
+			ccdc_cfg.base_addr = addr;
+			break;
+		case 1:
+			/* ISIF linear tbl0 address */
+			ccdc_cfg.linear_tbl0_addr = addr;
+			break;
+		default:
+			/* ISIF linear tbl0 address */
+			ccdc_cfg.linear_tbl1_addr = addr;
+			break;
+		}
+		i++;
+	}
+
+	davinci_cfg_reg(DM365_VIN_CAM_WEN);
+	davinci_cfg_reg(DM365_VIN_CAM_VD);
+	davinci_cfg_reg(DM365_VIN_CAM_HD);
+	davinci_cfg_reg(DM365_VIN_YIN4_7_EN);
+	davinci_cfg_reg(DM365_VIN_YIN0_3_EN);
+
+	return 0;
+fail_base_iomap:
+	release_mem_region(res->start, res_len);
+	i--;
+fail_nobase_res:
+	if (ccdc_cfg.base_addr)
+		iounmap(ccdc_cfg.base_addr);
+	if (ccdc_cfg.linear_tbl0_addr)
+		iounmap(ccdc_cfg.linear_tbl0_addr);
+
+	while (i >= 0) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
+		release_mem_region(res->start, res_len);
+		i--;
+	}
+
+	return status;
+}
+
+void ccdc_remove(struct platform_device *pdev)
+{
+	struct resource *res;
+	int i;
+
+	iounmap(ccdc_cfg.base_addr);
+	iounmap(ccdc_cfg.linear_tbl0_addr);
+	iounmap(ccdc_cfg.linear_tbl1_addr);
+
+	i = 0;
+	while (i < 3) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
+		if (res)
+			release_mem_region(res->start,
+					   res->end - res->start + 1);
+		i++;
+	}
+}
diff --git a/drivers/media/video/davinci/dm365_ccdc.h b/drivers/media/video/davinci/dm365_ccdc.h
new file mode 100644
index 0000000..1d40559
--- /dev/null
+++ b/drivers/media/video/davinci/dm365_ccdc.h
@@ -0,0 +1,86 @@
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
+* ccdc header file for DM365 ISIF
+*/
+#ifndef _DM365_CCDC_H
+#define _DM365_CCDC_H
+
+#include <linux/dm365_ccdc.h>
+#include "ccdc_types.h"
+
+struct ccdc_ycbcr_config {
+	/* ccdc pixel format */
+	enum ccdc_pixfmt pix_fmt;
+	/* ccdc frame format */
+	enum ccdc_frmfmt frm_fmt;
+	/* CCDC crop window */
+	struct v4l2_rect win;
+	/* field polarity */
+	enum vpfe_pin_pol fid_pol;
+	/* interface VD polarity */
+	enum vpfe_pin_pol vd_pol;
+	/* interface HD polarity */
+	enum vpfe_pin_pol hd_pol;
+	/* ccdc pix order. Only used for ycbcr capture */
+	enum ccdc_pixorder pix_order;
+	/* ccdc buffer type. Only used for ycbcr capture */
+	enum ccdc_buftype buf_type;
+};
+
+struct ccdc_params_raw {
+	/* ccdc pixel format */
+	enum ccdc_pixfmt pix_fmt;
+	/* ccdc frame format */
+	enum ccdc_frmfmt frm_fmt;
+	/* video window */
+	struct v4l2_rect win;
+	/* field polarity */
+	enum vpfe_pin_pol fid_pol;
+	/* interface VD polarity */
+	enum vpfe_pin_pol vd_pol;
+	/* interface HD polarity */
+	enum vpfe_pin_pol hd_pol;
+	/* buffer type. Applicable for interlaced mode */
+	enum ccdc_buftype buf_type;
+	/* Gain values */
+	struct ccdc_gain gain;
+	/* cfa pattern */
+	enum ccdc_cfa_pattern cfa_pat;
+	/* Data MSB position */
+	enum ccdc_data_msb data_msb;
+	/* Enable horizontal flip */
+	unsigned char horz_flip_en;
+	/* Enable image invert vertically */
+	unsigned char image_invert_en;
+
+	/*all the userland defined stuff*/
+	struct ccdc_config_params_raw config_params;
+};
+
+enum ccdc_data_pack {
+	CCDC_PACK_16BIT,
+	CCDC_PACK_12BIT,
+	CCDC_PACK_8BIT
+};
+
+struct ccdc_hw_device *get_ccdc_dev(void);
+
+#define CCDC_WIN_NTSC				{0, 0, 720, 480}
+#define CCDC_WIN_VGA				{0, 0, 640, 480}
+#define ISP5_CCDCMUX				0x20
+
+#endif
diff --git a/drivers/media/video/davinci/dm365_ccdc_regs.h b/drivers/media/video/davinci/dm365_ccdc_regs.h
new file mode 100644
index 0000000..9e734d5
--- /dev/null
+++ b/drivers/media/video/davinci/dm365_ccdc_regs.h
@@ -0,0 +1,309 @@
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
+#ifndef _DM365_CCDC_REGS_H
+#define _DM365_CCDC_REGS_H
+
+/* ISIF registers relative offsets */
+#define SYNCEN					0x00
+#define MODESET					0x04
+#define HDW					0x08
+#define VDW					0x0c
+#define PPLN					0x10
+#define LPFR					0x14
+#define SPH					0x18
+#define LNH					0x1c
+#define SLV0					0x20
+#define SLV1					0x24
+#define LNV					0x28
+#define CULH					0x2c
+#define CULV					0x30
+#define HSIZE					0x34
+#define SDOFST					0x38
+#define CADU					0x3c
+#define CADL					0x40
+#define LINCFG0					0x44
+#define LINCFG1					0x48
+#define CCOLP					0x4c
+#define CRGAIN					0x50
+#define CGRGAIN					0x54
+#define CGBGAIN					0x58
+#define CBGAIN					0x5c
+#define COFSTA					0x60
+#define FLSHCFG0				0x64
+#define FLSHCFG1				0x68
+#define FLSHCFG2				0x6c
+#define VDINT0					0x70
+#define VDINT1					0x74
+#define VDINT2					0x78
+#define MISC					0x7c
+#define CGAMMAWD				0x80
+#define REC656IF				0x84
+#define CCDCFG					0x88
+/*****************************************************
+* Defect Correction registers
+*****************************************************/
+#define DFCCTL					0x8c
+#define VDFSATLV				0x90
+#define DFCMEMCTL				0x94
+#define DFCMEM0					0x98
+#define DFCMEM1					0x9c
+#define DFCMEM2					0xa0
+#define DFCMEM3					0xa4
+#define DFCMEM4					0xa8
+/****************************************************
+* Black Clamp registers
+****************************************************/
+#define CLAMPCFG				0xac
+#define CLDCOFST				0xb0
+#define CLSV					0xb4
+#define CLHWIN0					0xb8
+#define CLHWIN1					0xbc
+#define CLHWIN2					0xc0
+#define CLVRV					0xc4
+#define CLVWIN0					0xc8
+#define CLVWIN1					0xcc
+#define CLVWIN2					0xd0
+#define CLVWIN3					0xd4
+/****************************************************
+* Lense Shading Correction
+****************************************************/
+#define DATAHOFST				0xd8
+#define DATAVOFST				0xdc
+#define LSCHVAL					0xe0
+#define LSCVVAL					0xe4
+#define TWODLSCCFG				0xe8
+#define TWODLSCOFST				0xec
+#define TWODLSCINI				0xf0
+#define TWODLSCGRBU				0xf4
+#define TWODLSCGRBL				0xf8
+#define TWODLSCGROF				0xfc
+#define TWODLSCORBU				0x100
+#define TWODLSCORBL				0x104
+#define TWODLSCOROF				0x108
+#define TWODLSCIRQEN				0x10c
+#define TWODLSCIRQST				0x110
+/****************************************************
+* Data formatter
+****************************************************/
+#define FMTCFG					0x114
+#define FMTPLEN					0x118
+#define FMTSPH					0x11c
+#define FMTLNH					0x120
+#define FMTSLV					0x124
+#define FMTLNV					0x128
+#define FMTRLEN					0x12c
+#define FMTHCNT					0x130
+#define FMTAPTR_BASE				0x134
+/* Below macro for addresses FMTAPTR0 - FMTAPTR15 */
+#define FMTAPTR(i)			(FMTAPTR_BASE + (i * 4))
+#define FMTPGMVF0				0x174
+#define FMTPGMVF1				0x178
+#define FMTPGMAPU0				0x17c
+#define FMTPGMAPU1				0x180
+#define FMTPGMAPS0				0x184
+#define FMTPGMAPS1				0x188
+#define FMTPGMAPS2				0x18c
+#define FMTPGMAPS3				0x190
+#define FMTPGMAPS4				0x194
+#define FMTPGMAPS5				0x198
+#define FMTPGMAPS6				0x19c
+#define FMTPGMAPS7				0x1a0
+/************************************************
+* Color Space Converter
+************************************************/
+#define CSCCTL					0x1a4
+#define CSCM0					0x1a8
+#define CSCM1					0x1ac
+#define CSCM2					0x1b0
+#define CSCM3					0x1b4
+#define CSCM4					0x1b8
+#define CSCM5					0x1bc
+#define CSCM6					0x1c0
+#define CSCM7					0x1c4
+#define OBWIN0					0x1c8
+#define OBWIN1					0x1cc
+#define OBWIN2					0x1d0
+#define OBWIN3					0x1d4
+#define OBVAL0					0x1d8
+#define OBVAL1					0x1dc
+#define OBVAL2					0x1e0
+#define OBVAL3					0x1e4
+#define OBVAL4					0x1e8
+#define OBVAL5					0x1ec
+#define OBVAL6					0x1f0
+#define OBVAL7					0x1f4
+#define CLKCTL					0x1f8
+
+#define CCDC_LINEAR_LUT0_ADDR			0x1c7c000
+#define CCDC_LINEAR_LUT1_ADDR			0x1c7c400
+
+/* Masks & Shifts below */
+#define START_PX_HOR_MASK			0x7fff
+#define NUM_PX_HOR_MASK				0x7fff
+#define START_VER_ONE_MASK			0x7fff
+#define START_VER_TWO_MASK			0x7fff
+#define NUM_LINES_VER				0x7fff
+
+/* gain - offset masks */
+#define GAIN_INTEGER_MASK			0x7
+#define GAIN_INTEGER_SHIFT			0x9
+#define GAIN_DECIMAL_MASK			0x1ff
+#define OFFSET_MASK				0xfff
+#define GAIN_SDRAM_EN_SHIFT			12
+#define GAIN_IPIPE_EN_SHIFT			13
+#define GAIN_H3A_EN_SHIFT			14
+#define OFST_SDRAM_EN_SHIFT			8
+#define OFST_IPIPE_EN_SHIFT			9
+#define OFST_H3A_EN_SHIFT			10
+#define GAIN_OFFSET_EN_MASK			0x7700
+
+/* Culling */
+#define CULL_PAT_EVEN_LINE_SHIFT		8
+
+/* CCDCFG register */
+#define CCDC_YCINSWP_RAW			(0x00 << 4)
+#define CCDC_YCINSWP_YCBCR			(0x01 << 4)
+#define CCDC_CCDCFG_FIDMD_LATCH_VSYNC		(0x00 << 6)
+#define CCDC_CCDCFG_WENLOG_AND			(0x00 << 8)
+#define CCDC_CCDCFG_TRGSEL_WEN			(0x00 << 9)
+#define CCDC_CCDCFG_EXTRG_DISABLE		(0x00 << 10)
+#define CCDC_LATCH_ON_VSYNC_DISABLE		(0x01 << 15)
+#define CCDC_LATCH_ON_VSYNC_ENABLE		(0x00 << 15)
+#define CCDC_DATA_PACK_MASK			0x03
+#define CCDC_DATA_PACK16			0x0
+#define CCDC_DATA_PACK12			0x1
+#define CCDC_DATA_PACK8				0x2
+#define CCDC_PIX_ORDER_SHIFT			11
+#define CCDC_PIX_ORDER_MASK			0x01
+#define CCDC_BW656_ENABLE			(0x01 << 5)
+
+/* MODESET registers */
+#define CCDC_VDHDOUT_INPUT			(0x00 << 0)
+#define CCDC_INPUT_MASK				0x03
+#define CCDC_INPUT_SHIFT			12
+#define CCDC_RAW_INPUT_MODE			0x00
+#define CCDC_FID_POL_MASK			0x01
+#define CCDC_FID_POL_SHIFT			4
+#define CCDC_HD_POL_MASK			0x01
+#define CCDC_HD_POL_SHIFT			3
+#define CCDC_VD_POL_MASK			0x01
+#define CCDC_VD_POL_SHIFT			2
+#define CCDC_DATAPOL_NORMAL			0x00
+#define CCDC_DATAPOL_MASK			0x01
+#define CCDC_DATAPOL_SHIFT			6
+#define CCDC_EXWEN_DISABLE			0x00
+#define CCDC_EXWEN_MASK				0x01
+#define CCDC_EXWEN_SHIFT			5
+#define CCDC_FRM_FMT_MASK			0x01
+#define CCDC_FRM_FMT_SHIFT			7
+#define CCDC_DATASFT_MASK			0x07
+#define CCDC_DATASFT_SHIFT			8
+#define CCDC_LPF_SHIFT				14
+#define CCDC_LPF_MASK				0x1
+
+/* GAMMAWD registers */
+#define CCDC_ALAW_GAMA_WD_MASK			0xf
+#define CCDC_ALAW_GAMA_WD_SHIFT			1
+#define CCDC_ALAW_ENABLE			0x01
+#define CCDC_GAMMAWD_CFA_MASK			0x01
+#define CCDC_GAMMAWD_CFA_SHIFT			5
+
+/* HSIZE registers */
+#define CCDC_HSIZE_FLIP_MASK			0x01
+#define CCDC_HSIZE_FLIP_SHIFT			12
+#define CCDC_LINEOFST_MASK			0xfff
+
+/* MISC registers */
+#define CCDC_DPCM_EN_SHIFT			12
+#define CCDC_DPCM_EN_MASK			1
+#define CCDC_DPCM_PREDICTOR_SHIFT		13
+#define CCDC_DPCM_PREDICTOR_MASK		1
+
+/* Black clamp related */
+#define CCDC_BC_DCOFFSET_MASK			0x1fff
+#define CCDC_BC_MODE_COLOR_MASK			1
+#define CCDC_BC_MODE_COLOR_SHIFT		4
+#define CCDC_HORZ_BC_MODE_MASK			3
+#define CCDC_HORZ_BC_MODE_SHIFT			1
+#define CCDC_HORZ_BC_WIN_COUNT_MASK		0x1f
+#define CCDC_HORZ_BC_WIN_SEL_SHIFT		5
+#define CCDC_HORZ_BC_PIX_LIMIT_SHIFT		6
+#define CCDC_HORZ_BC_WIN_H_SIZE_MASK		3
+#define CCDC_HORZ_BC_WIN_H_SIZE_SHIFT		8
+#define CCDC_HORZ_BC_WIN_V_SIZE_MASK		3
+#define CCDC_HORZ_BC_WIN_V_SIZE_SHIFT		12
+#define CCDC_HORZ_BC_WIN_START_H_MASK		0x1fff
+#define CCDC_HORZ_BC_WIN_START_V_MASK		0x1fff
+#define CCDC_VERT_BC_OB_H_SZ_MASK		7
+#define CCDC_VERT_BC_RST_VAL_SEL_MASK		3
+#define CCDC_VERT_BC_RST_VAL_SEL_SHIFT		4
+#define CCDC_VERT_BC_LINE_AVE_COEF_SHIFT	8
+#define CCDC_VERT_BC_OB_START_HORZ_MASK		0x1fff
+#define CCDC_VERT_BC_OB_START_VERT_MASK		0x1fff
+#define CCDC_VERT_BC_OB_VERT_SZ_MASK		0x1fff
+#define CCDC_VERT_BC_RST_VAL_MASK		0xfff
+#define CCDC_BC_VERT_START_SUB_V_MASK		0x1fff
+
+/* VDFC registers */
+#define CCDC_VDFC_EN_SHIFT			4
+#define CCDC_VDFC_CORR_MOD_MASK			3
+#define CCDC_VDFC_CORR_MOD_SHIFT		5
+#define CCDC_VDFC_CORR_WHOLE_LN_SHIFT		7
+#define CCDC_VDFC_LEVEL_SHFT_MASK		7
+#define CCDC_VDFC_LEVEL_SHFT_SHIFT		8
+#define CCDC_VDFC_SAT_LEVEL_MASK		0xfff
+#define CCDC_VDFC_POS_MASK			0x1fff
+#define CCDC_DFCMEMCTL_DFCMARST_SHIFT		2
+
+/* CSC registers */
+#define CCDC_CSC_COEF_INTEG_MASK		7
+#define CCDC_CSC_COEF_DECIMAL_MASK		0x1f
+#define CCDC_CSC_COEF_INTEG_SHIFT		5
+#define CCDC_CSCM_MSB_SHIFT			8
+#define CCDC_DF_CSC_SPH_MASK			0x1fff
+#define CCDC_DF_CSC_LNH_MASK			0x1fff
+#define CCDC_DF_CSC_SLV_MASK			0x1fff
+#define CCDC_DF_CSC_LNV_MASK			0x1fff
+#define CCDC_DF_NUMLINES			0x7fff
+#define CCDC_DF_NUMPIX				0x1fff
+
+/* Offsets for LSC/DFC/Gain */
+#define CCDC_DATA_H_OFFSET_MASK			0x1fff
+#define CCDC_DATA_V_OFFSET_MASK			0x1fff
+
+/* Linearization */
+#define CCDC_LIN_CORRSFT_MASK			7
+#define CCDC_LIN_CORRSFT_SHIFT			4
+#define CCDC_LIN_SCALE_FACT_INTEG_SHIFT		10
+#define CCDC_LIN_SCALE_FACT_DECIMAL_MASK	0x3ff
+#define CCDC_LIN_ENTRY_MASK			0x3ff
+
+#define CCDC_DF_FMTRLEN_MASK			0x1fff
+#define CCDC_DF_FMTHCNT_MASK			0x1fff
+
+/* Pattern registers */
+#define CCDC_PG_EN				(1 << 3)
+#define CCDC_SEL_PG_SRC				(3 << 4)
+#define CCDC_PG_VD_POL_SHIFT			0
+#define CCDC_PG_HD_POL_SHIFT			1
+
+/*masks and shifts*/
+#define CCDC_SYNCEN_VDHDEN_MASK			(1 << 0)
+#define CCDC_SYNCEN_WEN_MASK			(1 << 1)
+#define CCDC_SYNCEN_WEN_SHIFT			1
+
+#endif
diff --git a/include/linux/dm365_ccdc.h b/include/linux/dm365_ccdc.h
new file mode 100644
index 0000000..9b2258c
--- /dev/null
+++ b/include/linux/dm365_ccdc.h
@@ -0,0 +1,621 @@
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
+#ifndef _DM365_CCDC_INCLUDE_H
+#define _DM365_CCDC_INCLUDE_H
+
+#include <media/davinci/vpfe.h>
+#include "types.h"
+
+#define VPFE_CMD_S_CCDC_RAW_PARAMS _IOW('V', 1, \
+					struct ccdc_config_params_raw)
+#define VPFE_CMD_G_CCDC_RAW_PARAMS _IOR('V', 2, \
+					struct ccdc_config_params_raw)
+/**
+ * ccdc float type S8Q8/U8Q8
+ */
+struct ccdc_float_8 {
+	__u8 integer;
+	__u8 decimal;
+};
+
+/**
+ * brief ccdc float type U16Q16/S16Q16
+ */
+struct ccdc_float_16 {
+	__u16 integer;
+	__u16 decimal;
+};
+
+/************************************************************************
+ *   Vertical Defect Correction parameters
+ ***********************************************************************/
+
+/**
+ * vertical defect correction methods
+ */
+enum ccdc_vdfc_corr_mode {
+	/* Defect level subtraction. Just fed through if saturating */
+	CCDC_VDFC_NORMAL,
+	/**
+	 * Defect level subtraction. Horizontal interpolation ((i-2)+(i+2))/2
+	 * if data saturating
+	 */
+	CCDC_VDFC_HORZ_INTERPOL_IF_SAT,
+	/* Horizontal interpolation (((i-2)+(i+2))/2) */
+	CCDC_VDFC_HORZ_INTERPOL
+};
+
+/**
+ * Max Size of the Vertical Defect Correction table
+ */
+#define CCDC_VDFC_TABLE_SIZE 8
+
+/**
+ * Values used for shifting up the vdfc defect level
+ */
+enum ccdc_vdfc_shift {
+	/* No Shift */
+	CCDC_VDFC_NO_SHIFT,
+	/* Shift by 1 bit */
+	CCDC_VDFC_SHIFT_1,
+	/* Shift by 2 bit */
+	CCDC_VDFC_SHIFT_2,
+	/* Shift by 3 bit */
+	CCDC_VDFC_SHIFT_3,
+	/* Shift by 4 bit */
+	CCDC_VDFC_SHIFT_4
+};
+
+/**
+ * Defect Correction (DFC) table entry
+ */
+struct ccdc_vdfc_entry {
+	/* vertical position of defect */
+	unsigned short pos_vert;
+	/* horizontal position of defect */
+	unsigned short pos_horz;
+	/**
+	 * Defect level of Vertical line defect position. This is subtracted
+	 * from the data at the defect position
+	 */
+	unsigned char level_at_pos;
+	/**
+	 * Defect level of the pixels upper than the vertical line defect.
+	 * This is subtracted from the data
+	 */
+	unsigned char level_up_pixels;
+	/**
+	 * Defect level of the pixels lower than the vertical line defect.
+	 * This is subtracted from the data
+	 */
+	unsigned char level_low_pixels;
+};
+
+/**
+ * Structure for Defect Correction (DFC) parameter
+ */
+struct ccdc_dfc {
+	/* enable vertical defect correction */
+	unsigned char en;
+	/* Correction methods */
+	enum ccdc_vdfc_corr_mode corr_mode;
+	/**
+	 * 0 - whole line corrected, 1 - not
+	 * pixels upper than the defect
+	 */
+	unsigned char corr_whole_line;
+	/**
+	 * defect level shift value. level_at_pos, level_upper_pos,
+	 * and level_lower_pos can be shifted up by this value
+	 */
+	enum ccdc_vdfc_shift def_level_shift;
+	/* defect saturation level */
+	unsigned short def_sat_level;
+	/* number of vertical defects. Max is CCDC_VDFC_TABLE_SIZE */
+	short num_vdefects;
+	/* VDFC table ptr */
+	struct ccdc_vdfc_entry table[CCDC_VDFC_TABLE_SIZE];
+};
+
+/************************************************************************
+*   Digital/Black clamp or DC Subtract parameters
+************************************************************************/
+/**
+ * Horizontal Black Clamp modes
+ */
+enum ccdc_horz_bc_mode {
+	/**
+	 * Horizontal clamp disabled. Only vertical clamp
+	 * value is subtracted
+	 */
+	CCDC_HORZ_BC_DISABLE,
+	/**
+	 * Horizontal clamp value is calculated and subtracted
+	 * from image data along with vertical clamp value
+	 */
+	CCDC_HORZ_BC_CLAMP_CALC_ENABLED,
+	/**
+	 * Horizontal clamp value calculated from previous image
+	 * is subtracted from image data along with vertical clamp
+	 * value. How the horizontal clamp value for the first image
+	 * is calculated in this case ???
+	 */
+	CCDC_HORZ_BC_CLAMP_NOT_UPDATED
+};
+
+/**
+ * Base window selection for Horizontal Black Clamp calculations
+ */
+enum ccdc_horz_bc_base_win_sel {
+	/* Select Most left window for bc calculation */
+	CCDC_SEL_MOST_LEFT_WIN,
+
+	/* Select Most right window for bc calculation */
+	CCDC_SEL_MOST_RIGHT_WIN,
+};
+
+/* Size of window in horizontal direction for horizontal bc */
+enum ccdc_horz_bc_sz_h {
+	CCDC_HORZ_BC_SZ_H_2PIXELS,
+	CCDC_HORZ_BC_SZ_H_4PIXELS,
+	CCDC_HORZ_BC_SZ_H_8PIXELS,
+	CCDC_HORZ_BC_SZ_H_16PIXELS
+};
+
+/* Size of window in vertcal direction for vertical bc */
+enum ccdc_horz_bc_sz_v {
+	CCDC_HORZ_BC_SZ_H_32PIXELS,
+	CCDC_HORZ_BC_SZ_H_64PIXELS,
+	CCDC_HORZ_BC_SZ_H_128PIXELS,
+	CCDC_HORZ_BC_SZ_H_256PIXELS
+};
+
+/**
+ * Structure for Horizontal Black Clamp config params
+ */
+struct ccdc_horz_bclamp {
+	/* horizontal clamp mode */
+	enum ccdc_horz_bc_mode mode;
+	/**
+	 * pixel value limit enable.
+	 *  0 - limit disabled
+	 *  1 - pixel value limited to 1023
+	 */
+	unsigned char clamp_pix_limit;
+	/**
+	 * Select most left or right window for clamp val
+	 * calculation
+	 */
+	enum ccdc_horz_bc_base_win_sel base_win_sel_calc;
+	/* Window count per color for calculation. range 1-32 */
+	unsigned char win_count_calc;
+	/* Window start position - horizontal for calculation. 0 - 8191 */
+	unsigned short win_start_h_calc;
+	/* Window start position - vertical for calculation 0 - 8191 */
+	unsigned short win_start_v_calc;
+	/* Width of the sample window in pixels for calculation */
+	enum ccdc_horz_bc_sz_h win_h_sz_calc;
+	/* Height of the sample window in pixels for calculation */
+	enum ccdc_horz_bc_sz_v win_v_sz_calc;
+};
+
+/**
+ * Black Clamp vertical reset values
+ */
+enum ccdc_vert_bc_reset_val_sel {
+	/* Reset value used is the clamp value calculated */
+	CCDC_VERT_BC_USE_HORZ_CLAMP_VAL,
+	/* Reset value used is reset_clamp_val configured */
+	CCDC_VERT_BC_USE_CONFIG_CLAMP_VAL,
+	/* No update, previous image value is used */
+	CCDC_VERT_BC_NO_UPDATE
+};
+
+enum ccdc_vert_bc_sz_h {
+	CCDC_VERT_BC_SZ_H_2PIXELS,
+	CCDC_VERT_BC_SZ_H_4PIXELS,
+	CCDC_VERT_BC_SZ_H_8PIXELS,
+	CCDC_VERT_BC_SZ_H_16PIXELS,
+	CCDC_VERT_BC_SZ_H_32PIXELS,
+	CCDC_VERT_BC_SZ_H_64PIXELS
+};
+
+/**
+ * Structure for Vetical Black Clamp configuration params
+ */
+struct ccdc_vert_bclamp {
+	/* Reset value selection for vertical clamp calculation */
+	enum ccdc_vert_bc_reset_val_sel reset_val_sel;
+	/* U12 value if reset_sel = CCDC_BC_VERT_USE_CONFIG_CLAMP_VAL */
+	unsigned short reset_clamp_val;
+	/**
+	 * U8Q8. Line average coefficient used in vertical clamp
+	 * calculation
+	 */
+	unsigned char line_ave_coef;
+	/* Width in pixels of the optical black region used for calculation. */
+	enum ccdc_vert_bc_sz_h ob_h_sz_calc;
+	/* Height of the optical black region for calculation */
+	unsigned short ob_v_sz_calc;
+	/* Optical black region start position - horizontal. 0 - 8191 */
+	unsigned short ob_start_h;
+	/* Optical black region start position - vertical 0 - 8191 */
+	unsigned short ob_start_v;
+};
+
+/**
+ * Structure for Black Clamp configuration params
+ */
+struct ccdc_black_clamp {
+	/**
+	 * this offset value is added irrespective of the clamp
+	 * enable status. S13
+	 */
+	unsigned short dc_offset;
+	/**
+	 * Enable black/digital clamp value to be subtracted
+	 * from the image data
+	 */
+	unsigned char en;
+	/**
+	 * black clamp mode. same/separate clamp for 4 colors
+	 * 0 - disable - same clamp value for all colors
+	 * 1 - clamp value calculated separately for all colors
+	 */
+	unsigned char bc_mode_color;
+	/* Vrtical start position for bc subtraction */
+	unsigned short vert_start_sub;
+	/* Black clamp for horizontal direction */
+	struct ccdc_horz_bclamp horz;
+	/* Black clamp for vertical direction */
+	struct ccdc_vert_bclamp vert;
+};
+
+/*************************************************************************
+** Color Space Convertion (CSC)
+*************************************************************************/
+/**
+ * Number of Coefficient values used for CSC
+ */
+#define CCDC_CSC_NUM_COEFF 16
+
+/*************************************************************************
+**  Color Space Conversion parameters
+*************************************************************************/
+/**
+ * Structure used for CSC config params
+ */
+struct ccdc_color_space_conv {
+	/* Enable color space conversion */
+	unsigned char en;
+	/**
+	 * csc coeffient table. S8Q5, M00 at index 0, M01 at index 1, and
+	 * so forth
+	 */
+	struct ccdc_float_8 coeff[CCDC_CSC_NUM_COEFF];
+};
+
+enum ccdc_data_size {
+	/* 8 bits */
+	CCDC_8_BITS,
+	/* 9 bits */
+	CCDC_9_BITS,
+	/* 10 bits */
+	CCDC_10_BITS,
+	/* 11 bits */
+	CCDC_11_BITS,
+	/* 12 bits */
+	CCDC_12_BITS,
+	/* 13 bits */
+	CCDC_13_BITS,
+	/* 14 bits */
+	CCDC_14_BITS,
+	/* 15 bits */
+	CCDC_15_BITS,
+	/* 16 bits */
+	CCDC_16_BITS
+};
+
+enum ccdc_datasft {
+	/* No Shift */
+	CCDC_NO_SHIFT,
+	/* 1 bit Shift */
+	CCDC_1BIT_SHIFT,
+	/* 2 bit Shift */
+	CCDC_2BIT_SHIFT,
+	/* 3 bit Shift */
+	CCDC_3BIT_SHIFT,
+	/* 4 bit Shift */
+	CCDC_4BIT_SHIFT,
+	/* 5 bit Shift */
+	CCDC_5BIT_SHIFT,
+	/* 6 bit Shift */
+	CCDC_6BIT_SHIFT
+};
+
+enum ccdc_data_msb {
+	/* MSB b15 */
+	CCDC_BIT_MSB_15,
+	/* MSB b14 */
+	CCDC_BIT_MSB_14,
+	/* MSB b13 */
+	CCDC_BIT_MSB_13,
+	/* MSB b12 */
+	CCDC_BIT_MSB_12,
+	/* MSB b11 */
+	CCDC_BIT_MSB_11,
+	/* MSB b10 */
+	CCDC_BIT_MSB_10,
+	/* MSB b9 */
+	CCDC_BIT_MSB_9,
+	/* MSB b8 */
+	CCDC_BIT_MSB_8,
+	/* MSB b7 */
+	CCDC_BIT_MSB_7
+};
+
+/*************************************************************************
+**  Gain parameters
+*************************************************************************/
+/**
+ * Structure for Gain parameters
+ */
+struct ccdc_gain {
+	/* Gain for Red or ye */
+	struct ccdc_float_16 r_ye;
+	/* Gain for Gr or cy */
+	struct ccdc_float_16 gr_cy;
+	/* Gain for Gb or g */
+	struct ccdc_float_16 gb_g;
+	/* Gain for Blue or mg */
+	struct ccdc_float_16 b_mg;
+};
+
+/**
+ * Predicator types for DPCM compression
+ */
+enum ccdc_dpcm_predictor {
+	/* Choose Predictor1 for DPCM compression */
+	CCDC_DPCM_PRED1,
+	/* Choose Predictor2 for DPCM compression */
+	CCDC_DPCM_PRED2
+};
+
+#define CCDC_LINEAR_TAB_SIZE 192
+/*************************************************************************
+**  Linearization parameters
+*************************************************************************/
+/**
+ * Structure for Sensor data linearization
+ */
+struct ccdc_linearize {
+	/* Enable or Disable linearization of data */
+	unsigned char en;
+	/* Shift value applied */
+	enum ccdc_datasft corr_shft;
+	/* scale factor applied U11Q10 */
+	struct ccdc_float_16 scale_fact;
+	/* Size of the linear table */
+	unsigned short table[CCDC_LINEAR_TAB_SIZE];
+};
+
+enum ccdc_cfa_pattern {
+	CCDC_CFA_PAT_MOSAIC,
+	CCDC_CFA_PAT_STRIPE
+};
+
+enum ccdc_colpats {
+	CCDC_RED,
+	CCDC_GREEN_RED,
+	CCDC_GREEN_BLUE,
+	CCDC_BLUE
+};
+
+struct ccdc_col_pat {
+	enum ccdc_colpats olop;
+	enum ccdc_colpats olep;
+	enum ccdc_colpats elop;
+	enum ccdc_colpats elep;
+};
+
+/*************************************************************************
+**  CCDC Raw configuration parameters
+*************************************************************************/
+enum ccdc_fmt_mode {
+	CCDC_SPLIT,
+	CCDC_COMBINE
+};
+
+enum ccdc_lnum {
+	CCDC_1LINE,
+	CCDC_2LINES,
+	CCDC_3LINES,
+	CCDC_4LINES
+};
+
+enum ccdc_line {
+	CCDC_1STLINE,
+	CCDC_2NDLINE,
+	CCDC_3RDLINE,
+	CCDC_4THLINE
+};
+
+struct ccdc_fmtplen {
+	/**
+	 * number of program entries for SET0, range 1 - 16
+	 * when fmtmode is CCDC_SPLIT, 1 - 8 when fmtmode is
+	 * CCDC_COMBINE
+	 */
+	unsigned short plen0;
+	/**
+	 * number of program entries for SET1, range 1 - 16
+	 * when fmtmode is CCDC_SPLIT, 1 - 8 when fmtmode is
+	 * CCDC_COMBINE
+	 */
+	unsigned short plen1;
+	/**
+	 * number of program entries for SET2, range 1 - 16
+	 * when fmtmode is CCDC_SPLIT, 1 - 8 when fmtmode is
+	 * CCDC_COMBINE
+	 */
+	unsigned short plen2;
+	/**
+	 * number of program entries for SET3, range 1 - 16
+	 * when fmtmode is CCDC_SPLIT, 1 - 8 when fmtmode is
+	 * CCDC_COMBINE
+	 */
+	unsigned short plen3;
+};
+
+struct ccdc_fmt_cfg {
+	/* Split or combine or line alternate */
+	enum ccdc_fmt_mode fmtmode;
+	/* enable or disable line alternating mode */
+	unsigned char ln_alter_en;
+	/* Split/combine line number */
+	enum ccdc_lnum lnum;
+	/* Address increment Range 1 - 16 */
+	unsigned int addrinc;
+};
+
+struct ccdc_fmt_addr_ptr {
+	/* Initial address */
+	unsigned int init_addr;
+	/* output line number */
+	enum ccdc_line out_line;
+};
+
+struct ccdc_fmtpgm_ap {
+	/* program address pointer */
+	unsigned char pgm_aptr;
+	/* program address increment or decrement */
+	unsigned char pgmupdt;
+};
+
+struct ccdc_data_formatter {
+	/* Enable/Disable data formatter */
+	unsigned char en;
+	/* data formatter configuration */
+	struct ccdc_fmt_cfg cfg;
+	/* Formatter program entries length */
+	struct ccdc_fmtplen plen;
+	/* first pixel in a line fed to formatter */
+	unsigned short fmtrlen;
+	/* HD interval for output line. Only valid when split line */
+	unsigned short fmthcnt;
+	/* formatter address pointers */
+	struct ccdc_fmt_addr_ptr fmtaddr_ptr[16];
+	/* program enable/disable */
+	unsigned char pgm_en[32];
+	/* program address pointers */
+	struct ccdc_fmtpgm_ap fmtpgm_ap[32];
+};
+
+struct ccdc_df_csc {
+	/* Color Space Conversion confguration, 0 - csc, 1 - df */
+	unsigned int df_or_csc;
+	/* csc configuration valid if df_or_csc is 0 */
+	struct ccdc_color_space_conv csc;
+	/* data formatter configuration valid if df_or_csc is 1 */
+	struct ccdc_data_formatter df;
+	/* start pixel in a line at the input */
+	unsigned int start_pix;
+	/* number of pixels in input line */
+	unsigned int num_pixels;
+	/* start line at the input */
+	unsigned int start_line;
+	/* number of lines at the input */
+	unsigned int num_lines;
+};
+
+struct ccdc_gain_offsets_adj {
+	/* Gain adjustment per color */
+	struct ccdc_gain gain;
+	/* Offset adjustment */
+	unsigned short offset;
+	/* Enable or Disable Gain adjustment for SDRAM data */
+	unsigned char gain_sdram_en;
+	/* Enable or Disable Gain adjustment for IPIPE data */
+	unsigned char gain_ipipe_en;
+	/* Enable or Disable Gain adjustment for H3A data */
+	unsigned char gain_h3a_en;
+	/* Enable or Disable Gain adjustment for SDRAM data */
+	unsigned char offset_sdram_en;
+	/* Enable or Disable Gain adjustment for IPIPE data */
+	unsigned char offset_ipipe_en;
+	/* Enable or Disable Gain adjustment for H3A data */
+	unsigned char offset_h3a_en;
+};
+
+struct ccdc_cul {
+	/* Horizontal Cull pattern for odd lines */
+	unsigned char hcpat_odd;
+	/* Horizontal Cull pattern for even lines */
+	unsigned char hcpat_even;
+	/* Vertical Cull pattern */
+	unsigned char vcpat;
+	/* Enable or disable lpf. Apply when cull is enabled */
+	unsigned char en_lpf;
+};
+
+enum ccdc_compress_alg {
+	CCDC_ALAW,
+	CCDC_DPCM,
+	CCDC_NO_COMPRESSION
+};
+
+struct ccdc_compress {
+	/* Enable or diable A-Law or DPCM compression. */
+	enum ccdc_compress_alg alg;
+	/* Predictor for DPCM compression */
+	enum ccdc_dpcm_predictor pred;
+};
+
+/* all the stuff in this struct will be provided by userland */
+struct ccdc_config_params_raw {
+	/* Linearization parameters for image sensor data input */
+	struct ccdc_linearize linearize;
+	/* Data formatter or CSC */
+	struct ccdc_df_csc df_csc;
+	/* Defect Pixel Correction (DFC) confguration */
+	struct ccdc_dfc dfc;
+	/* Black/Digital Clamp configuration */
+	struct ccdc_black_clamp bclamp;
+	/* Gain, offset adjustments */
+	struct ccdc_gain_offsets_adj gain_offset;
+	/* Culling */
+	struct ccdc_cul culling;
+	/* A-Law and DPCM compression options */
+	struct ccdc_compress compress;
+	/* horizontal offset for Gain/LSC/DFC */
+	unsigned short horz_offset;
+	/* vertical offset for Gain/LSC/DFC */
+	unsigned short vert_offset;
+	/* color pattern for field 0 */
+	struct ccdc_col_pat col_pat_field0;
+	/* color pattern for field 1 */
+	struct ccdc_col_pat col_pat_field1;
+	/* data size from 8 to 16 bits */
+	enum ccdc_data_size data_size;
+	/* Data shift applied before storing to SDRAM */
+	enum ccdc_datasft data_shift;
+	/* enable input test pattern generation */
+	unsigned char test_pat_gen;
+};
+
+#endif
-- 
1.6.2.4

