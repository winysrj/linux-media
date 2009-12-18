Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:46288 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbZLRX6b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2009 18:58:31 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	khilman@deeprootsystems.com, hvaibhav@ti.com, nsekhar@ti.com
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH - v2 1/6] V4L - vpfe capture - header files for ISIF driver
Date: Fri, 18 Dec 2009 18:58:22 -0500
Message-Id: <1261180705-8150-3-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1261180705-8150-2-git-send-email-m-karicheri2@ti.com>
References: <1261180705-8150-1-git-send-email-m-karicheri2@ti.com>
 <1261180705-8150-2-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

Updated based on comments against v1 of the patch

This is the header file for ISIF driver on DM365.  ISIF driver is equivalent
to CCDC driver on DM355 and DM644x. This driver is tested for
YUV capture from TVP514x driver. This patch contains the header files required for
this driver. The name of the file is changed to reflect the name of IP.

Reviewed-by: Nori, Sekhar <nsekhar@ti.com>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl> 
Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to linux-next tree of v4l-dvb
 drivers/media/video/davinci/isif_regs.h |  269 ++++++++++++++++
 include/media/davinci/isif.h            |  531 +++++++++++++++++++++++++++++++
 2 files changed, 800 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/davinci/isif_regs.h
 create mode 100644 include/media/davinci/isif.h

diff --git a/drivers/media/video/davinci/isif_regs.h b/drivers/media/video/davinci/isif_regs.h
new file mode 100644
index 0000000..f7b8893
--- /dev/null
+++ b/drivers/media/video/davinci/isif_regs.h
@@ -0,0 +1,269 @@
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
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef _ISIF_REGS_H
+#define _ISIF_REGS_H
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
+#define CRGAIN 					0x50
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
+#define MISC 					0x7c
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
+/* Masks & Shifts below */
+#define START_PX_HOR_MASK			0x7FFF
+#define NUM_PX_HOR_MASK				0x7FFF
+#define START_VER_ONE_MASK			0x7FFF
+#define START_VER_TWO_MASK			0x7FFF
+#define NUM_LINES_VER				0x7FFF
+
+/* gain - offset masks */
+#define GAIN_INTEGER_SHIFT			9
+#define OFFSET_MASK			  	0xFFF
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
+#define ISIF_YCINSWP_RAW			(0x00 << 4)
+#define ISIF_YCINSWP_YCBCR			(0x01 << 4)
+#define ISIF_CCDCFG_FIDMD_LATCH_VSYNC		(0x00 << 6)
+#define ISIF_CCDCFG_WENLOG_AND			(0x00 << 8)
+#define ISIF_CCDCFG_TRGSEL_WEN			(0x00 << 9)
+#define ISIF_CCDCFG_EXTRG_DISABLE		(0x00 << 10)
+#define ISIF_LATCH_ON_VSYNC_DISABLE		(0x01 << 15)
+#define ISIF_LATCH_ON_VSYNC_ENABLE		(0x00 << 15)
+#define ISIF_DATA_PACK_MASK			3
+#define ISIF_DATA_PACK16			0
+#define ISIF_DATA_PACK12			1
+#define ISIF_DATA_PACK8				2
+#define ISIF_PIX_ORDER_SHIFT			11
+#define ISIF_BW656_ENABLE			(0x01 << 5)
+
+/* MODESET registers */
+#define ISIF_VDHDOUT_INPUT			(0x00 << 0)
+#define ISIF_INPUT_SHIFT			12
+#define ISIF_RAW_INPUT_MODE			0
+#define ISIF_FID_POL_SHIFT			4
+#define ISIF_HD_POL_SHIFT			3
+#define ISIF_VD_POL_SHIFT			2
+#define ISIF_DATAPOL_NORMAL			0
+#define ISIF_DATAPOL_SHIFT			6
+#define ISIF_EXWEN_DISABLE 			0
+#define ISIF_EXWEN_SHIFT			5
+#define ISIF_FRM_FMT_SHIFT			7
+#define ISIF_DATASFT_SHIFT			8
+#define ISIF_LPF_SHIFT				14
+#define ISIF_LPF_MASK				1
+
+/* GAMMAWD registers */
+#define ISIF_ALAW_GAMA_WD_MASK			0xF
+#define ISIF_ALAW_GAMA_WD_SHIFT			1
+#define ISIF_ALAW_ENABLE			1
+#define ISIF_GAMMAWD_CFA_SHIFT			5
+
+/* HSIZE registers */
+#define ISIF_HSIZE_FLIP_MASK			1
+#define ISIF_HSIZE_FLIP_SHIFT			12
+
+/* MISC registers */
+#define ISIF_DPCM_EN_SHIFT			12
+#define ISIF_DPCM_PREDICTOR_SHIFT		13
+
+/* Black clamp related */
+#define ISIF_BC_MODE_COLOR_SHIFT		4
+#define ISIF_HORZ_BC_MODE_SHIFT			1
+#define ISIF_HORZ_BC_WIN_SEL_SHIFT		5
+#define ISIF_HORZ_BC_PIX_LIMIT_SHIFT		6
+#define ISIF_HORZ_BC_WIN_H_SIZE_SHIFT		8
+#define ISIF_HORZ_BC_WIN_V_SIZE_SHIFT		12
+#define	ISIF_VERT_BC_RST_VAL_SEL_SHIFT		4
+#define ISIF_VERT_BC_LINE_AVE_COEF_SHIFT	8
+
+/* VDFC registers */
+#define ISIF_VDFC_EN_SHIFT			4
+#define ISIF_VDFC_CORR_MOD_SHIFT		5
+#define ISIF_VDFC_CORR_WHOLE_LN_SHIFT		7
+#define ISIF_VDFC_LEVEL_SHFT_SHIFT		8
+#define ISIF_VDFC_POS_MASK			0x1FFF
+#define ISIF_DFCMEMCTL_DFCMARST_SHIFT		2
+
+/* CSC registers */
+#define ISIF_CSC_COEF_INTEG_MASK		7
+#define ISIF_CSC_COEF_DECIMAL_MASK		0x1f
+#define ISIF_CSC_COEF_INTEG_SHIFT		5
+#define ISIF_CSCM_MSB_SHIFT			8
+#define ISIF_DF_CSC_SPH_MASK			0x1FFF
+#define ISIF_DF_CSC_LNH_MASK			0x1FFF
+#define ISIF_DF_CSC_SLV_MASK			0x1FFF
+#define ISIF_DF_CSC_LNV_MASK			0x1FFF
+#define ISIF_DF_NUMLINES			0x7FFF
+#define ISIF_DF_NUMPIX				0x1FFF
+
+/* Offsets for LSC/DFC/Gain */
+#define ISIF_DATA_H_OFFSET_MASK			0x1FFF
+#define ISIF_DATA_V_OFFSET_MASK			0x1FFF
+
+/* Linearization */
+#define ISIF_LIN_CORRSFT_SHIFT			4
+#define ISIF_LIN_SCALE_FACT_INTEG_SHIFT		10
+
+
+/* Pattern registers */
+#define ISIF_PG_EN				(1 << 3)
+#define ISIF_SEL_PG_SRC				(3 << 4)
+#define ISIF_PG_VD_POL_SHIFT			0
+#define ISIF_PG_HD_POL_SHIFT			1
+
+/*random other junk*/
+#define ISIF_SYNCEN_VDHDEN_MASK			(1 << 0)
+#define ISIF_SYNCEN_WEN_MASK			(1 << 1)
+#define ISIF_SYNCEN_WEN_SHIFT			1
+
+#endif
diff --git a/include/media/davinci/isif.h b/include/media/davinci/isif.h
new file mode 100644
index 0000000..b0b74ad
--- /dev/null
+++ b/include/media/davinci/isif.h
@@ -0,0 +1,531 @@
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
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * isif header file
+ */
+#ifndef _ISIF_H
+#define _ISIF_H
+
+#include <media/davinci/ccdc_types.h>
+#include <media/davinci/vpfe_types.h>
+
+/* isif float type S8Q8/U8Q8 */
+struct isif_float_8 {
+	/* 8 bit integer part */
+	__u8 integer;
+	/* 8 bit decimal part */
+	__u8 decimal;
+};
+
+/* isif float type U16Q16/S16Q16 */
+struct isif_float_16 {
+	/* 16 bit integer part */
+	__u16 integer;
+	/* 16 bit decimal part */
+	__u16 decimal;
+};
+
+/************************************************************************
+ *   Vertical Defect Correction parameters
+ ***********************************************************************/
+/* Defect Correction (DFC) table entry */
+struct isif_vdfc_entry {
+	/* vertical position of defect */
+	__u16 pos_vert;
+	/* horizontal position of defect */
+	__u16 pos_horz;
+	/*
+	 * Defect level of Vertical line defect position. This is subtracted
+	 * from the data at the defect position
+	 */
+	__u8 level_at_pos;
+	/*
+	 * Defect level of the pixels upper than the vertical line defect.
+	 * This is subtracted from the data
+	 */
+	__u8 level_up_pixels;
+	/*
+	 * Defect level of the pixels lower than the vertical line defect.
+	 * This is subtracted from the data
+	 */
+	__u8 level_low_pixels;
+};
+
+#define ISIF_VDFC_TABLE_SIZE		8
+struct isif_dfc {
+	/* enable vertical defect correction */
+	__u8 en;
+	/* Defect level subtraction. Just fed through if saturating */
+#define	ISIF_VDFC_NORMAL		0
+	/*
+	 * Defect level subtraction. Horizontal interpolation ((i-2)+(i+2))/2
+	 * if data saturating
+	 */
+#define ISIF_VDFC_HORZ_INTERPOL_IF_SAT	1
+	/* Horizontal interpolation (((i-2)+(i+2))/2) */
+#define	ISIF_VDFC_HORZ_INTERPOL		2
+	/* one of the vertical defect correction modes above */
+	__u8 corr_mode;
+	/* 0 - whole line corrected, 1 - not pixels upper than the defect */
+	__u8 corr_whole_line;
+#define ISIF_VDFC_NO_SHIFT		0
+#define ISIF_VDFC_SHIFT_1		1
+#define ISIF_VDFC_SHIFT_2		2
+#define ISIF_VDFC_SHIFT_3		3
+#define ISIF_VDFC_SHIFT_4		4
+	/*
+	 * defect level shift value. level_at_pos, level_upper_pos,
+	 * and level_lower_pos can be shifted up by this value. Choose
+	 * one of the values above
+	 */
+	__u8 def_level_shift;
+	/* defect saturation level */
+	__u16 def_sat_level;
+	/* number of vertical defects. Max is ISIF_VDFC_TABLE_SIZE */
+	__u16 num_vdefects;
+	/* VDFC table ptr */
+	struct isif_vdfc_entry table[ISIF_VDFC_TABLE_SIZE];
+};
+
+struct isif_horz_bclamp {
+
+	/* Horizontal clamp disabled. Only vertical clamp value is subtracted */
+#define	ISIF_HORZ_BC_DISABLE		0
+	/*
+	 * Horizontal clamp value is calculated and subtracted from image data
+	 * along with vertical clamp value
+	 */
+#define ISIF_HORZ_BC_CLAMP_CALC_ENABLED	1
+	/*
+	 * Horizontal clamp value calculated from previous image is subtracted
+	 * from image data along with vertical clamp value.
+	 */
+#define ISIF_HORZ_BC_CLAMP_NOT_UPDATED	2
+	/* horizontal clamp mode. One of the values above */
+	__u8 mode;
+	/*
+	 * pixel value limit enable.
+	 *  0 - limit disabled
+	 *  1 - pixel value limited to 1023
+	 */
+	__u8 clamp_pix_limit;
+	/* Select Most left window for bc calculation */
+#define	ISIF_SEL_MOST_LEFT_WIN		0
+	/* Select Most right window for bc calculation */
+#define ISIF_SEL_MOST_RIGHT_WIN		1
+	/* Select most left or right window for clamp val calculation */
+	__u8 base_win_sel_calc;
+	/* Window count per color for calculation. range 1-32 */
+	__u8 win_count_calc;
+	/* Window start position - horizontal for calculation. 0 - 8191 */
+	__u16 win_start_h_calc;
+	/* Window start position - vertical for calculation 0 - 8191 */
+	__u16 win_start_v_calc;
+#define ISIF_HORZ_BC_SZ_H_2PIXELS	0
+#define ISIF_HORZ_BC_SZ_H_4PIXELS	1
+#define ISIF_HORZ_BC_SZ_H_8PIXELS	2
+#define ISIF_HORZ_BC_SZ_H_16PIXELS	3
+	/* Width of the sample window in pixels for calculation */
+	__u8 win_h_sz_calc;
+#define ISIF_HORZ_BC_SZ_V_32PIXELS	0
+#define ISIF_HORZ_BC_SZ_V_64PIXELS	1
+#define	ISIF_HORZ_BC_SZ_V_128PIXELS	2
+#define ISIF_HORZ_BC_SZ_V_256PIXELS	3
+	/* Height of the sample window in pixels for calculation */
+	__u8 win_v_sz_calc;
+};
+
+/************************************************************************
+ *  Black Clamp parameters
+ ***********************************************************************/
+struct isif_vert_bclamp {
+	/* Reset value used is the clamp value calculated */
+#define	ISIF_VERT_BC_USE_HORZ_CLAMP_VAL		0
+	/* Reset value used is reset_clamp_val configured */
+#define	ISIF_VERT_BC_USE_CONFIG_CLAMP_VAL	1
+	/* No update, previous image value is used */
+#define	ISIF_VERT_BC_NO_UPDATE			2
+	/*
+	 * Reset value selector for vertical clamp calculation. Use one of
+	 * the above values
+	 */
+	__u8 reset_val_sel;
+	/* U8Q8. Line average coefficient used in vertical clamp calculation */
+	__u8 line_ave_coef;
+	/* Height of the optical black region for calculation */
+	__u16 ob_v_sz_calc;
+	/* Optical black region start position - horizontal. 0 - 8191 */
+	__u16 ob_start_h;
+	/* Optical black region start position - vertical 0 - 8191 */
+	__u16 ob_start_v;
+};
+
+struct isif_black_clamp {
+	/*
+	 * This offset value is added irrespective of the clamp enable status.
+	 * S13
+	 */
+	__u16 dc_offset;
+	/*
+	 * Enable black/digital clamp value to be subtracted from the image data
+	 */
+	__u8 en;
+	/*
+	 * black clamp mode. same/separate clamp for 4 colors
+	 * 0 - disable - same clamp value for all colors
+	 * 1 - clamp value calculated separately for all colors
+	 */
+	__u8 bc_mode_color;
+	/* Vrtical start position for bc subtraction */
+	__u16 vert_start_sub;
+	/* Black clamp for horizontal direction */
+	struct isif_horz_bclamp horz;
+	/* Black clamp for vertical direction */
+	struct isif_vert_bclamp vert;
+};
+
+/*************************************************************************
+** Color Space Convertion (CSC)
+*************************************************************************/
+#define ISIF_CSC_NUM_COEFF	16
+struct isif_color_space_conv {
+	/* Enable color space conversion */
+	__u8 en;
+	/*
+	 * csc coeffient table. S8Q5, M00 at index 0, M01 at index 1, and
+	 * so forth
+	 */
+	struct isif_float_8 coeff[ISIF_CSC_NUM_COEFF];
+};
+
+
+/*************************************************************************
+**  Black  Compensation parameters
+*************************************************************************/
+struct isif_black_comp {
+	/* Comp for Red */
+	__s8 r_comp;
+	/* Comp for Gr */
+	__s8 gr_comp;
+	/* Comp for Blue */
+	__s8 b_comp;
+	/* Comp for Gb */
+	__s8 gb_comp;
+};
+
+/*************************************************************************
+**  Gain parameters
+*************************************************************************/
+struct isif_gain {
+	/* Gain for Red or ye */
+	struct isif_float_16 r_ye;
+	/* Gain for Gr or cy */
+	struct isif_float_16 gr_cy;
+	/* Gain for Gb or g */
+	struct isif_float_16 gb_g;
+	/* Gain for Blue or mg */
+	struct isif_float_16 b_mg;
+};
+
+#define ISIF_LINEAR_TAB_SIZE	192
+/*************************************************************************
+**  Linearization parameters
+*************************************************************************/
+struct isif_linearize {
+	/* Enable or Disable linearization of data */
+	__u8 en;
+	/* Shift value applied */
+	__u8 corr_shft;
+	/* scale factor applied U11Q10 */
+	struct isif_float_16 scale_fact;
+	/* Size of the linear table */
+	__u16 table[ISIF_LINEAR_TAB_SIZE];
+};
+
+/* Color patterns */
+#define ISIF_RED	0
+#define	ISIF_GREEN_RED	1
+#define ISIF_GREEN_BLUE	2
+#define ISIF_BLUE	3
+struct isif_col_pat {
+	__u8 olop;
+	__u8 olep;
+	__u8 elop;
+	__u8 elep;
+};
+
+/*************************************************************************
+**  Data formatter parameters
+*************************************************************************/
+struct isif_fmtplen {
+	/*
+	 * number of program entries for SET0, range 1 - 16
+	 * when fmtmode is ISIF_SPLIT, 1 - 8 when fmtmode is
+	 * ISIF_COMBINE
+	 */
+	__u16 plen0;
+	/*
+	 * number of program entries for SET1, range 1 - 16
+	 * when fmtmode is ISIF_SPLIT, 1 - 8 when fmtmode is
+	 * ISIF_COMBINE
+	 */
+	__u16 plen1;
+	/**
+	 * number of program entries for SET2, range 1 - 16
+	 * when fmtmode is ISIF_SPLIT, 1 - 8 when fmtmode is
+	 * ISIF_COMBINE
+	 */
+	__u16 plen2;
+	/**
+	 * number of program entries for SET3, range 1 - 16
+	 * when fmtmode is ISIF_SPLIT, 1 - 8 when fmtmode is
+	 * ISIF_COMBINE
+	 */
+	__u16 plen3;
+};
+
+struct isif_fmt_cfg {
+#define ISIF_SPLIT		0
+#define ISIF_COMBINE		1
+	/* Split or combine or line alternate */
+	__u8 fmtmode;
+	/* enable or disable line alternating mode */
+	__u8 ln_alter_en;
+#define ISIF_1LINE		0
+#define	ISIF_2LINES		1
+#define	ISIF_3LINES		2
+#define	ISIF_4LINES		3
+	/* Split/combine line number */
+	__u8 lnum;
+	/* Address increment Range 1 - 16 */
+	__u8 addrinc;
+};
+
+struct isif_fmt_addr_ptr {
+	/* Initial address */
+	__u32 init_addr;
+	/* output line number */
+#define ISIF_1STLINE		0
+#define	ISIF_2NDLINE		1
+#define	ISIF_3RDLINE		2
+#define	ISIF_4THLINE		3
+	__u8 out_line;
+};
+
+struct isif_fmtpgm_ap {
+	/* program address pointer */
+	__u8 pgm_aptr;
+	/* program address increment or decrement */
+	__u8 pgmupdt;
+};
+
+struct isif_data_formatter {
+	/* Enable/Disable data formatter */
+	__u8 en;
+	/* data formatter configuration */
+	struct isif_fmt_cfg cfg;
+	/* Formatter program entries length */
+	struct isif_fmtplen plen;
+	/* first pixel in a line fed to formatter */
+	__u16 fmtrlen;
+	/* HD interval for output line. Only valid when split line */
+	__u16 fmthcnt;
+	/* formatter address pointers */
+	struct isif_fmt_addr_ptr fmtaddr_ptr[16];
+	/* program enable/disable */
+	__u8 pgm_en[32];
+	/* program address pointers */
+	struct isif_fmtpgm_ap fmtpgm_ap[32];
+};
+
+struct isif_df_csc {
+	/* Color Space Conversion confguration, 0 - csc, 1 - df */
+	__u8 df_or_csc;
+	/* csc configuration valid if df_or_csc is 0 */
+	struct isif_color_space_conv csc;
+	/* data formatter configuration valid if df_or_csc is 1 */
+	struct isif_data_formatter df;
+	/* start pixel in a line at the input */
+	__u32 start_pix;
+	/* number of pixels in input line */
+	__u32 num_pixels;
+	/* start line at the input */
+	__u32 start_line;
+	/* number of lines at the input */
+	__u32 num_lines;
+};
+
+struct isif_gain_offsets_adj {
+	/* Gain adjustment per color */
+	struct isif_gain gain;
+	/* Offset adjustment */
+	__u16 offset;
+	/* Enable or Disable Gain adjustment for SDRAM data */
+	__u8 gain_sdram_en;
+	/* Enable or Disable Gain adjustment for IPIPE data */
+	__u8 gain_ipipe_en;
+	/* Enable or Disable Gain adjustment for H3A data */
+	__u8 gain_h3a_en;
+	/* Enable or Disable Gain adjustment for SDRAM data */
+	__u8 offset_sdram_en;
+	/* Enable or Disable Gain adjustment for IPIPE data */
+	__u8 offset_ipipe_en;
+	/* Enable or Disable Gain adjustment for H3A data */
+	__u8 offset_h3a_en;
+};
+
+struct isif_cul {
+	/* Horizontal Cull pattern for odd lines */
+	__u8 hcpat_odd;
+	/* Horizontal Cull pattern for even lines */
+	__u8 hcpat_even;
+	/* Vertical Cull pattern */
+	__u8 vcpat;
+	/* Enable or disable lpf. Apply when cull is enabled */
+	__u8 en_lpf;
+};
+
+struct isif_compress {
+#define ISIF_ALAW		0
+#define ISIF_DPCM		1
+#define ISIF_NO_COMPRESSION	2
+	/* Compression Algorithm used */
+	__u8 alg;
+	/* Choose Predictor1 for DPCM compression */
+#define ISIF_DPCM_PRED1		0
+	/* Choose Predictor2 for DPCM compression */
+#define ISIF_DPCM_PRED2		1
+	/* Predictor for DPCM compression */
+	__u8 pred;
+};
+
+/* all the stuff in this struct will be provided by userland */
+struct isif_config_params_raw {
+	/* Linearization parameters for image sensor data input */
+	struct isif_linearize linearize;
+	/* Data formatter or CSC */
+	struct isif_df_csc df_csc;
+	/* Defect Pixel Correction (DFC) confguration */
+	struct isif_dfc dfc;
+	/* Black/Digital Clamp configuration */
+	struct isif_black_clamp bclamp;
+	/* Gain, offset adjustments */
+	struct isif_gain_offsets_adj gain_offset;
+	/* Culling */
+	struct isif_cul culling;
+	/* A-Law and DPCM compression options */
+	struct isif_compress compress;
+	/* horizontal offset for Gain/LSC/DFC */
+	__u16 horz_offset;
+	/* vertical offset for Gain/LSC/DFC */
+	__u16 vert_offset;
+	/* color pattern for field 0 */
+	struct isif_col_pat col_pat_field0;
+	/* color pattern for field 1 */
+	struct isif_col_pat col_pat_field1;
+#define ISIF_NO_SHIFT		0
+#define	ISIF_1BIT_SHIFT		1
+#define	ISIF_2BIT_SHIFT		2
+#define	ISIF_3BIT_SHIFT		3
+#define	ISIF_4BIT_SHIFT		4
+#define ISIF_5BIT_SHIFT		5
+#define ISIF_6BIT_SHIFT		6
+	/* Data shift applied before storing to SDRAM */
+	__u8 data_shift;
+	/* enable input test pattern generation */
+	__u8 test_pat_gen;
+};
+
+#ifdef __KERNEL__
+struct isif_ycbcr_config {
+	/* isif pixel format */
+	enum ccdc_pixfmt pix_fmt;
+	/* isif frame format */
+	enum ccdc_frmfmt frm_fmt;
+	/* ISIF crop window */
+	struct v4l2_rect win;
+	/* field polarity */
+	enum vpfe_pin_pol fid_pol;
+	/* interface VD polarity */
+	enum vpfe_pin_pol vd_pol;
+	/* interface HD polarity */
+	enum vpfe_pin_pol hd_pol;
+	/* isif pix order. Only used for ycbcr capture */
+	enum ccdc_pixorder pix_order;
+	/* isif buffer type. Only used for ycbcr capture */
+	enum ccdc_buftype buf_type;
+};
+
+/* MSB of image data connected to sensor port */
+enum isif_data_msb {
+	ISIF_BIT_MSB_15,
+	ISIF_BIT_MSB_14,
+	ISIF_BIT_MSB_13,
+	ISIF_BIT_MSB_12,
+	ISIF_BIT_MSB_11,
+	ISIF_BIT_MSB_10,
+	ISIF_BIT_MSB_9,
+	ISIF_BIT_MSB_8,
+	ISIF_BIT_MSB_7
+};
+
+enum isif_cfa_pattern {
+	ISIF_CFA_PAT_MOSAIC,
+	ISIF_CFA_PAT_STRIPE
+};
+
+struct isif_params_raw {
+	/* isif pixel format */
+	enum ccdc_pixfmt pix_fmt;
+	/* isif frame format */
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
+	struct isif_gain gain;
+	/* cfa pattern */
+	enum isif_cfa_pattern cfa_pat;
+	/* Data MSB position */
+	enum isif_data_msb data_msb;
+	/* Enable horizontal flip */
+	unsigned char horz_flip_en;
+	/* Enable image invert vertically */
+	unsigned char image_invert_en;
+
+	/* all the userland defined stuff*/
+	struct isif_config_params_raw config_params;
+};
+
+enum isif_data_pack {
+	ISIF_PACK_16BIT,
+	ISIF_PACK_12BIT,
+	ISIF_PACK_8BIT
+};
+
+#define ISIF_WIN_NTSC				{0, 0, 720, 480}
+#define ISIF_WIN_VGA				{0, 0, 640, 480}
+
+#endif
+#endif
-- 
1.6.0.4

