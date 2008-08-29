Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7TNfege028421
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 19:41:41 -0400
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7TNfQkp004553
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 19:41:26 -0400
Received: from dlep95.itg.ti.com ([157.170.170.107])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id m7TNfLwc028040
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 18:41:26 -0500
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep95.itg.ti.com (8.13.8/8.13.8) with ESMTP id m7TNfLx8021845
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 18:41:21 -0500 (CDT)
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Fri, 29 Aug 2008 18:41:17 -0500
Message-ID: <A24693684029E5489D1D202277BE89441191E340@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 9/15] OMAP3 camera driver: Add ISP Modules.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

From: Sergio Aguirre <saaguirre@ti.com>

OMAP: CAM: Add ISP Modules

This adds the OMAP ISP modules to the kernel. Includes:
* ISP Core Driver
* ISP CCDC Driver
* ISP Autofocus Driver
* ISP H3A Driver
* ISP Histogram Driver
* ISP MMU Driver
* ISP Preview Driver
* ISP Resizer Driver

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 arch/arm/plat-omap/include/mach/isp_user.h |  617 ++++++++
 drivers/media/video/isp/Kconfig            |    9
 drivers/media/video/isp/Makefile           |   19
 drivers/media/video/isp/isp.c              | 2228 +++++++++++++++++++++++++++++
 drivers/media/video/isp/isp.h              |  348 ++++
 drivers/media/video/isp/isp_af.c           |  812 ++++++++++
 drivers/media/video/isp/isp_af.h           |  139 +
 drivers/media/video/isp/ispccdc.c          | 1491 +++++++++++++++++++
 drivers/media/video/isp/ispccdc.h          |  210 ++
 drivers/media/video/isp/isph3a.c           |  915 +++++++++++
 drivers/media/video/isp/isph3a.h           |  139 +
 drivers/media/video/isp/isphist.c          |  644 ++++++++
 drivers/media/video/isp/isphist.h          |   97 +
 drivers/media/video/isp/ispmmu.c           |  735 +++++++++
 drivers/media/video/isp/ispmmu.h           |  117 +
 drivers/media/video/isp/isppreview.c       | 1868 ++++++++++++++++++++++++
 drivers/media/video/isp/isppreview.h       |  349 ++++
 drivers/media/video/isp/ispreg.h           | 1281 ++++++++++++++++
 drivers/media/video/isp/ispresizer.c       |  866 +++++++++++
 drivers/media/video/isp/ispresizer.h       |  153 +
 20 files changed, 13037 insertions(+)

Index: linux-omap-2.6/arch/arm/plat-omap/include/mach/isp_user.h
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/arch/arm/plat-omap/include/mach/isp_user.h   2008-08-28 19:08:43.000000000 -0500
@@ -0,0 +1,617 @@
+/*
+ * include/asm-arm/arch-omap/isp_user.h
+ *
+ * Include file for OMAP ISP module in TI's OMAP3430.
+ *
+ * Copyright (C) 2008 Texas Instruments, Inc.
+ *
+ * Contributors:
+ *     Mohit Jalori <mjalori@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#ifndef OMAP_ISP_USER_H
+#define OMAP_ISP_USER_H
+
+/* AE/AWB related structures and flags*/
+
+/* Flags for update field */
+#define REQUEST_STATISTICS     (1 << 0)
+#define SET_COLOR_GAINS                (1 << 1)
+#define SET_DIGITAL_GAIN       (1 << 2)
+#define SET_EXPOSURE           (1 << 3)
+#define SET_ANALOG_GAIN                (1 << 4)
+
+#define MAX_FRAME_COUNT                0x0FFF
+#define MAX_FUTURE_FRAMES      10
+
+/**
+ * struct isph3a_aewb_config - AE AWB configuration reset values.
+ * saturation_limit: Saturation limit.
+ * @win_height: Window Height. Range 2 - 256, even values only.
+ * @win_width: Window Width. Range 6 - 256, even values only.
+ * @ver_win_count: Vertical Window Count. Range 1 - 128.
+ * @hor_win_count: Horizontal Window Count. Range 1 - 36.
+ * @ver_win_start: Vertical Window Start. Range 0 - 4095.
+ * @hor_win_start: Horizontal Window Start. Range 0 - 4095.
+ * @blk_ver_win_start: Black Vertical Windows Start. Range 0 - 4095.
+ * @blk_win_height: Black Window Height. Range 2 - 256, even values only.
+ * @subsample_ver_inc: Subsample Vertical points increment Range 2 - 32, even
+ *                     values only.
+ * @subsample_hor_inc: Subsample Horizontal points increment Range 2 - 32, even
+ *                     values only.
+ * @alaw_enable: AEW ALAW EN flag.
+ * @aewb_enable: AE AWB stats generation EN flag.
+ */
+struct isph3a_aewb_config {
+       u16 saturation_limit;
+       u16 win_height;
+       u16 win_width;
+       u16 ver_win_count;
+       u16 hor_win_count;
+       u16 ver_win_start;
+       u16 hor_win_start;
+       u16 blk_ver_win_start;
+       u16 blk_win_height;
+       u16 subsample_ver_inc;
+       u16 subsample_hor_inc;
+       u8 alaw_enable;
+       u8 aewb_enable;
+};
+
+/**
+ * struct isph3a_aewb_data - Structure of data sent to or received from user
+ * @h3a_aewb_statistics_buf: Pointer to pass to user.
+ * @shutter: Shutter speed.
+ * @gain: Sensor analog Gain.
+ * @shutter_cap: Shutter speed for capture.
+ * @gain_cap: Sensor Gain for capture.
+ * @dgain: White balance digital gain.
+ * @wb_gain_b: White balance color gain blue.
+ * @wb_gain_r: White balance color gain red.
+ * @wb_gain_gb: White balance color gain green blue.
+ * @wb_gain_gr: White balance color gain green red.
+ * @frame_number: Frame number of requested stats.
+ * @curr_frame: Current frame number being processed.
+ * @update: Bitwise flags to update parameters.
+ * @ts: Timestamp of returned framestats.
+ * @field_count: Sequence number of returned framestats.
+ */
+struct isph3a_aewb_data {
+       void *h3a_aewb_statistics_buf;
+       u32 shutter;
+       u16 gain;
+       u32 shutter_cap;
+       u16 gain_cap;
+       u16 dgain;
+       u16 wb_gain_b;
+       u16 wb_gain_r;
+       u16 wb_gain_gb;
+       u16 wb_gain_gr;
+       u16 frame_number;
+       u16 curr_frame;
+       u8 update;
+       struct timeval ts;
+       unsigned long field_count;
+};
+
+
+/* Histogram related structs */
+/* Flags for number of bins */
+#define BINS_32                        0x0
+#define BINS_64                        0x1
+#define BINS_128               0x2
+#define BINS_256               0x3
+
+struct isp_hist_config {
+       u8 hist_source;         /* CCDC or Memory */
+       u8 input_bit_width;     /* Needed o know the size per pixel */
+       u8 hist_frames;         /* Num of frames to be processed and
+                                * accumulated
+                                */
+       u8 hist_h_v_info;       /* frame-input width and height if source is
+                                * memory
+                                */
+       u16 hist_radd;          /* frame-input address in memory */
+       u16 hist_radd_off;      /* line-offset for frame-input */
+       u16 hist_bins;          /* number of bins: 32, 64, 128, or 256 */
+       u16 wb_gain_R;          /* White Balance Field-to-Pattern Assignments */
+       u16 wb_gain_RG;         /* White Balance Field-to-Pattern Assignments */
+       u16 wb_gain_B;          /* White Balance Field-to-Pattern Assignments */
+       u16 wb_gain_BG;         /* White Balance Field-to-Pattern Assignments */
+       u8 num_regions;         /* number of regions to be configured */
+       u16 reg0_hor;           /* Region 0 size and position */
+       u16 reg0_ver;           /* Region 0 size and position */
+       u16 reg1_hor;           /* Region 1 size and position */
+       u16 reg1_ver;           /* Region 1 size and position */
+       u16 reg2_hor;           /* Region 2 size and position */
+       u16 reg2_ver;           /* Region 2 size and position */
+       u16 reg3_hor;           /* Region 3 size and position */
+       u16 reg3_ver;           /* Region 3 size and position */
+};
+
+struct isp_hist_data {
+       u32 *hist_statistics_buf;       /* Pointer to pass to user */
+};
+
+/* Auto Focus related structs */
+
+#define AF_NUMBER_OF_COEF              11
+
+/* Flags for update field */
+#define REQUEST_STATISTICS             (1 << 0)
+#define LENS_DESIRED_POSITION  (1 << 1)
+#define LENS_CURRENT_POSITION  (1 << 2)
+
+/**
+ * struct isp_af_xtrastats - Extra statistics related to AF generated stats.
+ * @ts: Timestamp when the frame gets delivered to the user.
+ * @field_count: Field count of the frame delivered to the user.
+ * @lens_position: Lens position when the stats are being generated.
+ */
+struct isp_af_xtrastats {
+       struct timeval ts;
+       unsigned long field_count;
+       __u16 lens_position;
+};
+
+/**
+ * struct isp_af_data - AF statistics data to transfer between driver and user.
+ * @af_statistics_buf: Pointer to pass to user.
+ * @lens_current_position: Read value of lens absolute position.
+ * @desired_lens_direction: Lens desired location.
+ * @update: Bitwise flags to update parameters.
+ * @frame_number: Data for which frame is desired/given.
+ * @curr_frame: Current frame number being processed by AF module.
+ * @xtrastats: Extra statistics structure.
+ */
+struct isp_af_data {
+       void *af_statistics_buf;
+       __u16 lens_current_position;
+       __u16 desired_lens_direction;
+       __u16 update;
+       __u16 frame_number;
+       __u16 curr_frame;
+       struct isp_af_xtrastats xtrastats;
+};
+
+/* enum used for status of specific feature */
+enum af_alaw_enable {
+       H3A_AF_ALAW_DISABLE = 0,
+       H3A_AF_ALAW_ENABLE = 1
+};
+
+enum af_hmf_enable {
+       H3A_AF_HMF_DISABLE = 0,
+       H3A_AF_HMF_ENABLE = 1
+};
+
+enum af_config_flag {
+       H3A_AF_CFG_DISABLE = 0,
+       H3A_AF_CFG_ENABLE = 1
+};
+
+enum af_mode {
+       ACCUMULATOR_SUMMED = 0,
+       ACCUMULATOR_PEAK = 1
+};
+
+/* Red, Green, and blue pixel location in the AF windows */
+enum rgbpos {
+       GR_GB_BAYER = 0,        /* GR and GB as Bayer pattern */
+       RG_GB_BAYER = 1,        /* RG and GB as Bayer pattern */
+       GR_BG_BAYER = 2,        /* GR and BG as Bayer pattern */
+       RG_BG_BAYER = 3,        /* RG and BG as Bayer pattern */
+       GG_RB_CUSTOM = 4,       /* GG and RB as custom pattern */
+       RB_GG_CUSTOM = 5        /* RB and GG as custom pattern */
+};
+
+/* Contains the information regarding the Horizontal Median Filter */
+struct af_hmf {
+       enum af_hmf_enable enable;      /* Status of Horizontal Median Filter */
+       unsigned int threshold; /* Threshhold Value for Horizontal Median
+                                * Filter
+                                */
+};
+
+/* Contains the information regarding the IIR Filters */
+struct af_iir {
+       unsigned int hz_start_pos;      /* IIR Start Register Value */
+       int coeff_set0[AF_NUMBER_OF_COEF];      /*
+                                                * IIR Filter Coefficient for
+                                                * Set 0
+                                                */
+       int coeff_set1[AF_NUMBER_OF_COEF];      /*
+                                                * IIR Filter Coefficient for
+                                                * Set 1
+                                                */
+};
+
+/* Contains the information regarding the Paxels Structure in AF Engine */
+struct af_paxel {
+       unsigned int width;     /* Width of the Paxel */
+       unsigned int height;    /* Height of the Paxel */
+       unsigned int hz_start;  /* Horizontal Start Position */
+       unsigned int vt_start;  /* Vertical Start Position */
+       unsigned int hz_cnt;    /* Horizontal Count */
+       unsigned int vt_cnt;    /* vertical Count */
+       unsigned int line_incr; /* Line Increment */
+};
+/* Contains the parameters required for hardware set up of AF Engine */
+struct af_configuration {
+       enum af_alaw_enable alaw_enable;        /*ALWAW status */
+       struct af_hmf hmf_config;       /*HMF configurations */
+       enum rgbpos rgb_pos;            /*RGB Positions */
+       struct af_iir iir_config;       /*IIR filter configurations */
+       struct af_paxel paxel_config;   /*Paxel parameters */
+       enum af_mode mode;              /*Accumulator mode */
+       enum af_config_flag af_config; /*Flag indicates Engine is configured */
+};
+
+/* ISP CCDC structs */
+
+/* Abstraction layer CCDC configurations */
+#define ISP_ABS_CCDC_ALAW              (1 << 0)
+#define ISP_ABS_CCDC_LPF               (1 << 1)
+#define ISP_ABS_CCDC_BLCLAMP           (1 << 2)
+#define ISP_ABS_CCDC_BCOMP             (1 << 3)
+#define ISP_ABS_CCDC_FPC               (1 << 4)
+#define ISP_ABS_CCDC_CULL              (1 << 5)
+#define ISP_ABS_CCDC_COLPTN            (1 << 6)
+#define ISP_ABS_CCDC_CONFIG_LSC                (1 << 7)
+#define ISP_ABS_TBL_LSC                        (1 << 8)
+
+#define RGB_MAX                                3
+
+/* Enumeration constants for Alaw input width */
+enum alaw_ipwidth {
+       ALAW_BIT12_3 = 0x3,
+       ALAW_BIT11_2 = 0x4,
+       ALAW_BIT10_1 = 0x5,
+       ALAW_BIT9_0 = 0x6
+};
+
+/* Enumeration constants for Video Port */
+enum vpin {
+       BIT12_3 = 3,
+       BIT11_2 = 4,
+       BIT10_1 = 5,
+       BIT9_0 = 6
+};
+
+enum vpif_freq {
+       PIXCLKBY2,
+       PIXCLKBY3_5,
+       PIXCLKBY4_5,
+       PIXCLKBY5_5,
+       PIXCLKBY6_5
+};
+
+/**
+ * struct ispccdc_lsc_config - Structure for LSC configuration.
+ * @offset: Table Offset of the gain table.
+ * @gain_mode_n: Vertical dimension of a paxel in LSC configuration.
+ * @gain_mode_m: Horizontal dimension of a paxel in LSC configuration.
+ * @gain_format: Gain table format.
+ * @fmtsph: Start pixel horizontal from start of the HS sync pulse.
+ * @fmtlnh: Number of pixels in horizontal direction to use for the data
+ *          reformatter.
+ * @fmtslv: Start line from start of VS sync pulse for the data reformatter.
+ * @fmtlnv: Number of lines in vertical direction for the data reformatter.
+ * @initial_x: X position, in pixels, of the first active pixel in reference
+ *             to the first active paxel. Must be an even number.
+ * @initial_y: Y position, in pixels, of the first active pixel in reference
+ *             to the first active paxel. Must be an even number.
+ * @size: Size of LSC gain table. Filled when loaded from userspace.
+ */
+struct ispccdc_lsc_config {
+       u8 offset;
+       u8 gain_mode_n;
+       u8 gain_mode_m;
+       u8 gain_format;
+       u16 fmtsph;
+       u16 fmtlnh;
+       u16 fmtslv;
+       u16 fmtlnv;
+       u8 initial_x;
+       u8 initial_y;
+       u32 size;
+};
+
+/**
+ * struct ispccdc_bclamp - Structure for Optical & Digital black clamp subtract
+ * @obgain: Optical black average gain.
+ * @obstpixel: Start Pixel w.r.t. HS pulse in Optical black sample.
+ * @oblines: Optical Black Sample lines.
+ * @oblen: Optical Black Sample Length.
+ * @dcsubval: Digital Black Clamp subtract value.
+ */
+struct ispccdc_bclamp {
+       u8 obgain;
+       u8 obstpixel;
+       u8 oblines;
+       u8 oblen;
+       u16 dcsubval;
+};
+
+/**
+ * ispccdc_fpc - Structure for FPC
+ * @fpnum: Number of faulty pixels to be corrected in the frame.
+ * @fpcaddr: Memory address of the FPC Table
+ */
+struct ispccdc_fpc {
+       u16 fpnum;
+       u32 fpcaddr;
+};
+
+/**
+ * ispccdc_blcomp - Structure for Black Level Compensation parameters.
+ * @b_mg: B/Mg pixels. 2's complement. -128 to +127.
+ * @gb_g: Gb/G pixels. 2's complement. -128 to +127.
+ * @gr_cy: Gr/Cy pixels. 2's complement. -128 to +127.
+ * @r_ye: R/Ye pixels. 2's complement. -128 to +127.
+ */
+struct ispccdc_blcomp {
+       u8 b_mg;
+       u8 gb_g;
+       u8 gr_cy;
+       u8 r_ye;
+};
+
+/**
+ * struct ispccdc_vp - Structure for Video Port parameters
+ * @bitshift_sel: Video port input select. 3 - bits 12-3, 4 - bits 11-2,
+ *                5 - bits 10-1, 6 - bits 9-0.
+ * @freq_sel: Video port data ready frequency. 1 - 1/3.5, 2 - 1/4.5,
+ *            3 - 1/5.5, 4 - 1/6.5.
+ */
+struct ispccdc_vp {
+       enum vpin bitshift_sel;
+       enum vpif_freq freq_sel;
+};
+
+/**
+ * ispccdc_culling - Structure for Culling parameters.
+ * @v_pattern: Vertical culling pattern.
+ * @h_odd: Horizontal Culling pattern for odd lines.
+ * @h_even: Horizontal Culling pattern for even lines.
+ */
+struct ispccdc_culling {
+       u8 v_pattern;
+       u16 h_odd;
+       u16 h_even;
+};
+
+/**
+ * ispccdc_update_config - Structure for CCDC configuration.
+ * @update: Specifies which CCDC registers should be updated.
+ * @flag: Specifies which CCDC functions should be enabled.
+ * @alawip: Enable/Disable A-Law compression.
+ * @bclamp: Black clamp control register.
+ * @blcomp: Black level compensation value for RGrGbB Pixels. 2's complement.
+ * @fpc: Number of faulty pixels corrected in the frame, address of FPC table.
+ * @cull: Cull control register.
+ * @colptn: Color pattern of the sensor.
+ * @lsc: Pointer to LSC gain table.
+ */
+struct ispccdc_update_config {
+       u16 update;
+       u16 flag;
+       enum alaw_ipwidth alawip;
+       struct ispccdc_bclamp *bclamp;
+       struct ispccdc_blcomp *blcomp;
+       struct ispccdc_fpc *fpc;
+       struct ispccdc_lsc_config *lsc_cfg;
+       struct ispccdc_culling *cull;
+       u32 colptn;
+       u8 *lsc;
+};
+
+/* Preview configuration */
+
+/*Abstraction layer preview configurations*/
+#define ISP_ABS_PREV_LUMAENH           (1 << 0)
+#define ISP_ABS_PREV_INVALAW           (1 << 1)
+#define ISP_ABS_PREV_HRZ_MED           (1 << 2)
+#define ISP_ABS_PREV_CFA               (1 << 3)
+#define ISP_ABS_PREV_CHROMA_SUPP       (1 << 4)
+#define ISP_ABS_PREV_WB                        (1 << 5)
+#define ISP_ABS_PREV_BLKADJ            (1 << 6)
+#define ISP_ABS_PREV_RGB2RGB           (1 << 7)
+#define ISP_ABS_PREV_COLOR_CONV                (1 << 8)
+#define ISP_ABS_PREV_YC_LIMIT          (1 << 9)
+#define ISP_ABS_PREV_DEFECT_COR                (1 << 10)
+#define ISP_ABS_PREV_GAMMABYPASS       (1 << 11)
+#define ISP_ABS_TBL_NF                         (1 << 12)
+#define ISP_ABS_TBL_REDGAMMA           (1 << 13)
+#define ISP_ABS_TBL_GREENGAMMA         (1 << 14)
+#define ISP_ABS_TBL_BLUEGAMMA          (1 << 15)
+
+/**
+ * struct ispprev_hmed - Structure for Horizontal Median Filter.
+ * @odddist: Distance between consecutive pixels of same color in the odd line.
+ * @evendist: Distance between consecutive pixels of same color in the even
+ *            line.
+ * @thres: Horizontal median filter threshold.
+ */
+struct ispprev_hmed {
+       u8 odddist;
+       u8 evendist;
+       u8 thres;
+};
+
+/*
+ * Enumeration for CFA Formats supported by preview
+ */
+enum cfa_fmt {
+       CFAFMT_BAYER, CFAFMT_SONYVGA, CFAFMT_RGBFOVEON,
+       CFAFMT_DNSPL, CFAFMT_HONEYCOMB, CFAFMT_RRGGBBFOVEON
+};
+
+/**
+ * struct ispprev_cfa - Structure for CFA Inpterpolation.
+ * @cfafmt: CFA Format Enum value supported by preview.
+ * @cfa_gradthrs_vert: CFA Gradient Threshold - Vertical.
+ * @cfa_gradthrs_horz: CFA Gradient Threshold - Horizontal.
+ * @cfa_table: Pointer to the CFA table.
+ */
+struct ispprev_cfa {
+       enum cfa_fmt cfafmt;
+       u8 cfa_gradthrs_vert;
+       u8 cfa_gradthrs_horz;
+       u32 *cfa_table;
+};
+
+/**
+ * struct ispprev_csup - Structure for Chrominance Suppression.
+ * @gain: Gain.
+ * @thres: Threshold.
+ * @hypf_en: Flag to enable/disable the High Pass Filter.
+ */
+struct ispprev_csup {
+       u8 gain;
+       u8 thres;
+       u8 hypf_en;
+};
+
+/**
+ * struct ispprev_wbal - Structure for White Balance.
+ * @dgain: Digital gain (U10Q8).
+ * @coef3: White balance gain - COEF 3 (U8Q5).
+ * @coef2: White balance gain - COEF 2 (U8Q5).
+ * @coef1: White balance gain - COEF 1 (U8Q5).
+ * @coef0: White balance gain - COEF 0 (U8Q5).
+ */
+struct ispprev_wbal {
+       u16 dgain;
+       u8 coef3;
+       u8 coef2;
+       u8 coef1;
+       u8 coef0;
+};
+
+/**
+ * struct ispprev_blkadj - Structure for Black Adjustment.
+ * @red: Black level offset adjustment for Red in 2's complement format
+ * @green: Black level offset adjustment for Green in 2's complement format
+ * @blue: Black level offset adjustment for Blue in 2's complement format
+ */
+struct ispprev_blkadj {
+       /*Black level offset adjustment for Red in 2's complement format */
+       u8 red;
+       /*Black level offset adjustment for Green in 2's complement format */
+       u8 green;
+       /* Black level offset adjustment for Blue in 2's complement format */
+       u8 blue;
+};
+
+/**
+ * struct ispprev_rgbtorgb - Structure for RGB to RGB Blending.
+ * @matrix: Blending values(S12Q8 format)
+ *              [RR] [GR] [BR]
+ *              [RG] [GG] [BG]
+ *              [RB] [GB] [BB]
+ * @offset: Blending offset value for R,G,B in 2's complement integer format.
+ */
+struct ispprev_rgbtorgb {
+       u16 matrix[3][3];
+       u16 offset[3];
+};
+
+/**
+ * struct ispprev_csc - Structure for Color Space Conversion from RGB-YCbYCr
+ * @matrix: Color space conversion coefficients(S10Q8)
+ *              [CSCRY]  [CSCGY]  [CSCBY]
+ *              [CSCRCB] [CSCGCB] [CSCBCB]
+ *              [CSCRCR] [CSCGCR] [CSCBCR]
+ * @offset: CSC offset values for Y offset, CB offset and CR offset respectively
+ */
+struct ispprev_csc {
+       u16 matrix[RGB_MAX][RGB_MAX];
+       s16 offset[RGB_MAX];
+};
+
+/**
+ * struct ispprev_yclimit - Structure for Y, C Value Limit.
+ * @minC: Minimum C value
+ * @maxC: Maximum C value
+ * @minY: Minimum Y value
+ * @maxY: Maximum Y value
+ */
+struct ispprev_yclimit {
+       u8 minC;
+       u8 maxC;
+       u8 minY;
+       u8 maxY;
+};
+
+/**
+ * struct ispprev_dcor - Structure for Defect correction.
+ * @couplet_mode_en: Flag to enable or disable the couplet dc Correction in NF
+ * @detect_correct: Thresholds for correction bit 0:10 detect 16:25 correct
+ */
+struct ispprev_dcor {
+       u8 couplet_mode_en;
+       u32 detect_correct[4];
+};
+
+/**
+ * struct ispprev_nf - Structure for Noise Filter
+ * @spread: Spread value to be used in Noise Filter
+ * @table: Pointer to the Noise Filter table
+ */
+struct ispprev_nf {
+       u8 spread;
+       u32 table[64];
+};
+
+/**
+ * struct ispprv_update_config - Structure for Preview Configuration (user).
+ * @update: Specifies which ISP Preview registers should be updated.
+ * @flag: Specifies which ISP Preview functions should be enabled.
+ * @yen: Pointer to luma enhancement table.
+ * @shading_shift: 3bit value of shift used in shading compensation.
+ * @prev_hmed: Pointer to structure containing the odd and even distance.
+ *             between the pixels in the image along with the filter threshold.
+ * @prev_cfa: Pointer to structure containing the CFA interpolation table, CFA.
+ *            format in the image, vertical and horizontal gradient threshold.
+ * @csup: Pointer to Structure for Chrominance Suppression coefficients.
+ * @prev_wbal: Pointer to structure for White Balance.
+ * @prev_blkadj: Pointer to structure for Black Adjustment.
+ * @rgb2rgb: Pointer to structure for RGB to RGB Blending.
+ * @prev_csc: Pointer to structure for Color Space Conversion from RGB-YCbYCr.
+ * @yclimit: Pointer to structure for Y, C Value Limit.
+ * @prev_dcor: Pointer to structure for defect correction.
+ * @prev_nf: Pointer to structure for Noise Filter
+ * @red_gamma: Pointer to red gamma correction table.
+ * @green_gamma: Pointer to green gamma correction table.
+ * @blue_gamma: Pointer to blue gamma correction table.
+ */
+struct ispprv_update_config {
+       u16 update;
+       u16 flag;
+       void *yen;
+       u32 shading_shift;
+       struct ispprev_hmed *prev_hmed;
+       struct ispprev_cfa *prev_cfa;
+       struct ispprev_csup *csup;
+       struct ispprev_wbal *prev_wbal;
+       struct ispprev_blkadj *prev_blkadj;
+       struct ispprev_rgbtorgb *rgb2rgb;
+       struct ispprev_csc *prev_csc;
+       struct ispprev_yclimit *yclimit;
+       struct ispprev_dcor *prev_dcor;
+       struct ispprev_nf *prev_nf;
+       u32 *red_gamma;
+       u32 *green_gamma;
+       u32 *blue_gamma;
+};
+
+#endif /* OMAP_ISP_USER_H */
Index: linux-omap-2.6/drivers/media/video/isp/Kconfig
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/isp/Kconfig      2008-08-28 19:08:43.000000000 -0500
@@ -0,0 +1,9 @@
+# Kconfig for OMAP3 ISP driver
+
+config VIDEO_OMAP34XX_ISP_PREVIEWER
+       tristate "OMAP ISP Previewer"
+       depends on !ARCH_OMAP3410
+
+config VIDEO_OMAP34XX_ISP_RESIZER
+       tristate "OMAP ISP Resizer"
+       depends on !ARCH_OMAP3410
Index: linux-omap-2.6/drivers/media/video/isp/Makefile
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/isp/Makefile     2008-08-28 19:08:43.000000000 -0500
@@ -0,0 +1,19 @@
+# Makefile for OMAP3 ISP driver
+
+ifdef CONFIG_ARCH_OMAP3410
+isp-mod-objs += \
+       isp.o ispccdc.o ispmmu.o
+else
+isp-mod-objs += \
+       isp.o ispccdc.o ispmmu.o \
+       isppreview.o ispresizer.o isph3a.o isphist.o isp_af.o
+
+obj-$(CONFIG_VIDEO_OMAP34XX_ISP_PREVIEWER) += \
+       omap_previewer.o
+
+obj-$(CONFIG_VIDEO_OMAP34XX_ISP_RESIZER) += \
+       omap_resizer.o
+
+endif
+
+obj-$(CONFIG_VIDEO_OMAP3) += isp-mod.o
Index: linux-omap-2.6/drivers/media/video/isp/isp.c
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/isp/isp.c        2008-08-28 19:08:43.000000000 -0500
@@ -0,0 +1,2228 @@
+/*
+ * drivers/media/video/isp/isp.c
+ *
+ * Driver Library for ISP Control module in TI's OMAP3430 Camera ISP
+ * ISP interface and IRQ related APIs are defined here.
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ * Copyright (C) 2008 Nokia.
+ *
+ * Contributors:
+ *     Sameer Venkatraman <sameerv@ti.com>
+ *     Mohit Jalori <mjalori@ti.com>
+ *     Sakari Ailus <sakari.ailus@nokia.com>
+ *     Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
+ *     Toni Leinonen <toni.leinonen@nokia.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/clk.h>
+#include <asm/irq.h>
+#include <linux/bitops.h>
+#include <linux/scatterlist.h>
+#include <asm/mach-types.h>
+#include <mach/clock.h>
+#include <mach/io.h>
+#include <linux/device.h>
+#include <linux/videodev2.h>
+
+#include "isp.h"
+#include "ispmmu.h"
+#include "ispreg.h"
+#include "ispccdc.h"
+#include "isph3a.h"
+#include "isphist.h"
+#include "isp_af.h"
+#include "isppreview.h"
+#include "ispresizer.h"
+
+/* List of image formats supported via OMAP ISP */
+const static struct v4l2_fmtdesc isp_formats[] = {
+       {
+               .description = "UYVY, packed",
+               .pixelformat = V4L2_PIX_FMT_UYVY,
+       },
+       {
+               .description = "YUYV (YUV 4:2:2), packed",
+               .pixelformat = V4L2_PIX_FMT_YUYV,
+       },
+       {
+               .description = "Bayer10 (GrR/BGb)",
+               .pixelformat = V4L2_PIX_FMT_SGRBG10,
+       },
+};
+
+/* ISP Crop capabilities */
+static struct v4l2_rect ispcroprect;
+static struct v4l2_rect cur_rect;
+
+/**
+ * struct vcontrol - Video control structure.
+ * @qc: V4L2 Query control structure.
+ * @current_value: Current value of the control.
+ */
+static struct vcontrol {
+       struct v4l2_queryctrl qc;
+       int current_value;
+} video_control[] = {
+       {
+               {
+                       .id = V4L2_CID_BRIGHTNESS,
+                       .type = V4L2_CTRL_TYPE_INTEGER,
+                       .name = "Brightness",
+                       .minimum = ISPPRV_BRIGHT_LOW,
+                       .maximum = ISPPRV_BRIGHT_HIGH,
+                       .step = ISPPRV_BRIGHT_STEP,
+                       .default_value = ISPPRV_BRIGHT_DEF,
+               },
+               .current_value = ISPPRV_BRIGHT_DEF,
+       },
+       {
+               {
+                       .id = V4L2_CID_CONTRAST,
+                       .type = V4L2_CTRL_TYPE_INTEGER,
+                       .name = "Contrast",
+                       .minimum = ISPPRV_CONTRAST_LOW,
+                       .maximum = ISPPRV_CONTRAST_HIGH,
+                       .step = ISPPRV_CONTRAST_STEP,
+                       .default_value = ISPPRV_CONTRAST_DEF,
+               },
+               .current_value = ISPPRV_CONTRAST_DEF,
+       },
+       {
+               {
+                       .id = V4L2_CID_PRIVATE_ISP_COLOR_FX,
+                       .type = V4L2_CTRL_TYPE_INTEGER,
+                       .name = "Color Effects",
+                       .minimum = PREV_DEFAULT_COLOR,
+                       .maximum = PREV_SEPIA_COLOR,
+                       .step = 1,
+                       .default_value = PREV_DEFAULT_COLOR,
+               },
+               .current_value = PREV_DEFAULT_COLOR,
+       }
+};
+
+
+/**
+ * struct ispirq - Structure for containing callbacks to be called in ISP ISR.
+ * @isp_callbk: Array which stores callback functions, indexed by the type of
+ *              callback (8 possible types).
+ * @isp_callbk_arg1: Pointer to array containing pointers to the first argument
+ *                   to be passed to the requested callback function.
+ * @isp_callbk_arg2: Pointer to array containing pointers to the second
+ *                   argument to be passed to the requested callback function.
+ *
+ * This structure is used to contain all the callback functions related for
+ * each callback type (CBK_CCDC_VD0, CBK_CCDC_VD1, CBK_PREV_DONE,
+ * CBK_RESZ_DONE, CBK_MMU_ERR, CBK_H3A_AWB_DONE, CBK_HIST_DONE, CBK_HS_VS,
+ * CBK_LSC_ISR).
+ */
+static struct ispirq {
+       isp_callback_t isp_callbk[CBK_END];
+       isp_vbq_callback_ptr isp_callbk_arg1[CBK_END];
+       void *isp_callbk_arg2[CBK_END];
+} ispirq_obj;
+
+/**
+ * struct isp - Structure for storing ISP Control module information
+ * @lock: Spinlock to sync between isr and processes.
+ * @isp_temp_buf_lock: Temporary spinlock for buffer control.
+ * @isp_mutex: Semaphore used to get access to the ISP.
+ * @if_status: Type of interface used in ISP.
+ * @interfacetype: (Not used).
+ * @ref_count: Reference counter.
+ * @cam_ick: Pointer to ISP Interface clock.
+ * @cam_fck: Pointer to ISP Functional clock.
+ *
+ * This structure is used to store the OMAP ISP Control Information.
+ */
+static struct isp {
+       spinlock_t lock;        /* For handling registered ISP callbacks */
+       spinlock_t isp_temp_buf_lock;   /* For handling isp buffers state */
+       struct mutex isp_mutex; /* For handling ref_count field */
+       u8 if_status;
+       u8 interfacetype;
+       int ref_count;
+       struct clk *cam_ick;
+       struct clk *cam_mclk;
+} isp_obj;
+
+struct isp_sgdma ispsg;
+
+/**
+ * struct ispmodule - Structure for storing ISP sub-module information.
+ * @isp_pipeline: Bit mask for submodules enabled within the ISP.
+ * @isp_temp_state: State of current buffers.
+ * @applyCrop: Flag to do a crop operation when video buffer queue ISR is done
+ * @pix: Structure containing the format and layout of the output image.
+ * @ccdc_input_width: ISP CCDC module input image width.
+ * @ccdc_input_height: ISP CCDC module input image height.
+ * @ccdc_output_width: ISP CCDC module output image width.
+ * @ccdc_output_height: ISP CCDC module output image height.
+ * @preview_input_width: ISP Preview module input image width.
+ * @preview_input_height: ISP Preview module input image height.
+ * @preview_output_width: ISP Preview module output image width.
+ * @preview_output_height: ISP Preview module output image height.
+ * @resizer_input_width: ISP Resizer module input image width.
+ * @resizer_input_height: ISP Resizer module input image height.
+ * @resizer_output_width: ISP Resizer module output image width.
+ * @resizer_output_height: ISP Resizer module output image height.
+ */
+struct ispmodule {
+       unsigned int isp_pipeline;
+       int isp_temp_state;
+       int applyCrop;
+       struct v4l2_pix_format pix;
+       unsigned int ccdc_input_width;
+       unsigned int ccdc_input_height;
+       unsigned int ccdc_output_width;
+       unsigned int ccdc_output_height;
+       unsigned int preview_input_width;
+       unsigned int preview_input_height;
+       unsigned int preview_output_width;
+       unsigned int preview_output_height;
+       unsigned int resizer_input_width;
+       unsigned int resizer_input_height;
+       unsigned int resizer_output_width;
+       unsigned int resizer_output_height;
+};
+
+static struct ispmodule ispmodule_obj = {
+       .isp_pipeline = OMAP_ISP_CCDC,
+       .isp_temp_state = ISP_BUF_INIT,
+       .applyCrop = 0,
+       .pix = {
+               .width = ISP_OUTPUT_WIDTH_DEFAULT,
+               .height = ISP_OUTPUT_HEIGHT_DEFAULT,
+               .pixelformat = V4L2_PIX_FMT_UYVY,
+               .field = V4L2_FIELD_NONE,
+               .bytesperline = ISP_OUTPUT_WIDTH_DEFAULT * ISP_BYTES_PER_PIXEL,
+               .colorspace = V4L2_COLORSPACE_JPEG,
+               .priv = 0,
+       },
+};
+
+/* Structure for saving/restoring ISP module registers */
+static struct isp_reg isp_reg_list[] = {
+       {ISP_SYSCONFIG, 0},
+       {ISP_IRQ0ENABLE, 0},
+       {ISP_IRQ1ENABLE, 0},
+       {ISP_TCTRL_GRESET_LENGTH, 0},
+       {ISP_TCTRL_PSTRB_REPLAY, 0},
+       {ISP_CTRL, 0},
+       {ISP_TCTRL_CTRL, 0},
+       {ISP_TCTRL_FRAME, 0},
+       {ISP_TCTRL_PSTRB_DELAY, 0},
+       {ISP_TCTRL_STRB_DELAY, 0},
+       {ISP_TCTRL_SHUT_DELAY, 0},
+       {ISP_TCTRL_PSTRB_LENGTH, 0},
+       {ISP_TCTRL_STRB_LENGTH, 0},
+       {ISP_TCTRL_SHUT_LENGTH, 0},
+       {ISP_CBUFF_SYSCONFIG, 0},
+       {ISP_CBUFF_IRQENABLE, 0},
+       {ISP_CBUFF0_CTRL, 0},
+       {ISP_CBUFF1_CTRL, 0},
+       {ISP_CBUFF0_START, 0},
+       {ISP_CBUFF1_START, 0},
+       {ISP_CBUFF0_END, 0},
+       {ISP_CBUFF1_END, 0},
+       {ISP_CBUFF0_WINDOWSIZE, 0},
+       {ISP_CBUFF1_WINDOWSIZE, 0},
+       {ISP_CBUFF0_THRESHOLD, 0},
+       {ISP_CBUFF1_THRESHOLD, 0},
+       {ISP_TOK_TERM, 0}
+};
+
+/*
+ *
+ * V4L2 Handling
+ *
+ */
+
+/**
+ * find_vctrl - Returns the index of the ctrl array of the requested ctrl ID.
+ * @id: Requested control ID.
+ *
+ * Returns 0 if successful, -EINVAL if not found, or -EDOM if its out of
+ * domain.
+ **/
+static int find_vctrl(int id)
+{
+       int i;
+
+       if (id < V4L2_CID_BASE)
+               return -EDOM;
+
+       for (i = (ARRAY_SIZE(video_control) - 1); i >= 0; i--)
+               if (video_control[i].qc.id == id)
+                       break;
+
+       if (i < 0)
+               i = -EINVAL;
+
+       return i;
+}
+
+/**
+ * isp_open - Reserve ISP submodules for operation
+ **/
+void isp_open(void)
+{
+       ispccdc_request();
+       isppreview_request();
+       ispresizer_request();
+       return;
+}
+EXPORT_SYMBOL(isp_set_pipeline);
+
+/**
+ * isp_close - Free ISP submodules
+ **/
+void isp_close(void)
+{
+       ispccdc_free();
+       isppreview_free();
+       ispresizer_free();
+       return;
+}
+EXPORT_SYMBOL(omapisp_unset_callback);
+
+/* Flag to check first time of isp_get */
+static int off_mode;
+
+/**
+ * isp_set_sgdma_callback - Set Scatter-Gather DMA Callback.
+ * @sgdma_state: Pointer to structure with the SGDMA state for each videobuffer
+ * @func_ptr: Callback function pointer for SG-DMA management
+ **/
+static int isp_set_sgdma_callback(struct isp_sgdma_state *sgdma_state,
+                                               isp_vbq_callback_ptr func_ptr)
+{
+       if ((ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER) &&
+                                               is_ispresizer_enabled()) {
+               isp_set_callback(CBK_RESZ_DONE, sgdma_state->callback,
+                                               func_ptr, sgdma_state->arg);
+       }
+
+       if ((ispmodule_obj.isp_pipeline & OMAP_ISP_PREVIEW) &&
+                                               is_isppreview_enabled()) {
+                       isp_set_callback(CBK_PREV_DONE, sgdma_state->callback,
+                                               func_ptr, sgdma_state->arg);
+       }
+
+       if (ispmodule_obj.isp_pipeline & OMAP_ISP_CCDC) {
+               isp_set_callback(CBK_CCDC_VD0, sgdma_state->callback, func_ptr,
+                                                       sgdma_state->arg);
+               isp_set_callback(CBK_CCDC_VD1, sgdma_state->callback, func_ptr,
+                                                       sgdma_state->arg);
+               isp_set_callback(CBK_LSC_ISR, NULL, NULL, NULL);
+       }
+
+       isp_set_callback(CBK_HS_VS, sgdma_state->callback, func_ptr,
+                                                       sgdma_state->arg);
+       return 0;
+}
+
+/**
+ * isp_set_callback - Sets the callback for the ISP module done events.
+ * @type: Type of the event for which callback is requested.
+ * @callback: Method to be called as callback in the ISR context.
+ * @arg1: First argument to be passed when callback is called in ISR.
+ * @arg2: Second argument to be passed when callback is called in ISR.
+ *
+ * This function sets a callback function for a done event in the ISP
+ * module, and enables the corresponding interrupt.
+ **/
+int isp_set_callback(enum isp_callback_type type, isp_callback_t callback,
+                                               isp_vbq_callback_ptr arg1,
+                                               void *arg2)
+{
+       unsigned long irqflags = 0;
+
+       if (callback == NULL) {
+               DPRINTK_ISPCTRL("ISP_ERR : Null Callback\n");
+               return -EINVAL;
+       }
+
+       spin_lock_irqsave(&isp_obj.lock, irqflags);
+       ispirq_obj.isp_callbk[type] = callback;
+       ispirq_obj.isp_callbk_arg1[type] = arg1;
+       ispirq_obj.isp_callbk_arg2[type] = arg2;
+       spin_unlock_irqrestore(&isp_obj.lock, irqflags);
+
+       switch (type) {
+       case CBK_HS_VS:
+               omap_writel(IRQ0ENABLE_HS_VS_IRQ, ISP_IRQ0STATUS);
+               omap_writel(omap_readl(ISP_IRQ0ENABLE) | IRQ0ENABLE_HS_VS_IRQ,
+                                                       ISP_IRQ0ENABLE);
+               break;
+       case CBK_PREV_DONE:
+               omap_writel(IRQ0ENABLE_PRV_DONE_IRQ, ISP_IRQ0STATUS);
+               omap_writel(omap_readl(ISP_IRQ0ENABLE) |
+                                       IRQ0ENABLE_PRV_DONE_IRQ,
+                                       ISP_IRQ0ENABLE);
+               break;
+       case CBK_RESZ_DONE:
+               omap_writel(IRQ0ENABLE_RSZ_DONE_IRQ, ISP_IRQ0STATUS);
+               omap_writel(omap_readl(ISP_IRQ0ENABLE) |
+                                       IRQ0ENABLE_RSZ_DONE_IRQ,
+                                       ISP_IRQ0ENABLE);
+               break;
+       case CBK_MMU_ERR:
+               omap_writel(omap_readl(ISP_IRQ0ENABLE) |
+                                       IRQ0ENABLE_MMU_ERR_IRQ,
+                                       ISP_IRQ0ENABLE);
+
+               omap_writel(omap_readl(ISPMMU_IRQENABLE) |
+                                       IRQENABLE_MULTIHITFAULT |
+                                       IRQENABLE_TWFAULT |
+                                       IRQENABLE_EMUMISS |
+                                       IRQENABLE_TRANSLNFAULT |
+                                       IRQENABLE_TLBMISS,
+                                       ISPMMU_IRQENABLE);
+               break;
+       case CBK_H3A_AWB_DONE:
+               omap_writel(IRQ0ENABLE_H3A_AWB_DONE_IRQ, ISP_IRQ0STATUS);
+               omap_writel(omap_readl(ISP_IRQ0ENABLE) |
+                                       IRQ0ENABLE_H3A_AWB_DONE_IRQ,
+                                       ISP_IRQ0ENABLE);
+               break;
+       case CBK_H3A_AF_DONE:
+               omap_writel(IRQ0ENABLE_H3A_AF_DONE_IRQ, ISP_IRQ0STATUS);
+               omap_writel(omap_readl(ISP_IRQ0ENABLE)|
+                               IRQ0ENABLE_H3A_AF_DONE_IRQ,
+                               ISP_IRQ0ENABLE);
+               break;
+       case CBK_HIST_DONE:
+               omap_writel(IRQ0ENABLE_HIST_DONE_IRQ, ISP_IRQ0STATUS);
+               omap_writel(omap_readl(ISP_IRQ0ENABLE) |
+                                       IRQ0ENABLE_HIST_DONE_IRQ,
+                                       ISP_IRQ0ENABLE);
+               break;
+       case CBK_LSC_ISR:
+               omap_writel(IRQ0ENABLE_CCDC_LSC_DONE_IRQ |
+                                       IRQ0ENABLE_CCDC_LSC_PREF_COMP_IRQ |
+                                       IRQ0ENABLE_CCDC_LSC_PREF_ERR_IRQ,
+                                       ISP_IRQ0STATUS);
+               omap_writel(omap_readl(ISP_IRQ0ENABLE) |
+                                       IRQ0ENABLE_CCDC_LSC_DONE_IRQ |
+                                       IRQ0ENABLE_CCDC_LSC_PREF_COMP_IRQ |
+                                       IRQ0ENABLE_CCDC_LSC_PREF_ERR_IRQ,
+                                       ISP_IRQ0ENABLE);
+               break;
+       default:
+               break;
+       }
+
+       return 0;
+}
+EXPORT_SYMBOL(isp_set_callback);
+
+/**
+ * isp_unset_callback - Clears the callback for the ISP module done events.
+ * @type: Type of the event for which callback to be cleared.
+ *
+ * This function clears a callback function for a done event in the ISP
+ * module, and disables the corresponding interrupt.
+ **/
+int isp_unset_callback(enum isp_callback_type type)
+{
+       unsigned long irqflags = 0;
+
+       spin_lock_irqsave(&isp_obj.lock, irqflags);
+       ispirq_obj.isp_callbk[type] = NULL;
+       ispirq_obj.isp_callbk_arg1[type] = NULL;
+       ispirq_obj.isp_callbk_arg2[type] = NULL;
+       spin_unlock_irqrestore(&isp_obj.lock, irqflags);
+
+       switch (type) {
+       case CBK_CCDC_VD0:
+               omap_writel((omap_readl(ISP_IRQ0ENABLE)) &
+                                               ~IRQ0ENABLE_CCDC_VD0_IRQ,
+                                               ISP_IRQ0ENABLE);
+               break;
+       case CBK_CCDC_VD1:
+               omap_writel((omap_readl(ISP_IRQ0ENABLE)) &
+                                               ~IRQ0ENABLE_CCDC_VD1_IRQ,
+                                               ISP_IRQ0ENABLE);
+               break;
+       case CBK_PREV_DONE:
+               omap_writel((omap_readl(ISP_IRQ0ENABLE)) &
+                                               ~IRQ0ENABLE_PRV_DONE_IRQ,
+                                               ISP_IRQ0ENABLE);
+               break;
+       case CBK_RESZ_DONE:
+               omap_writel((omap_readl(ISP_IRQ0ENABLE)) &
+                                               ~IRQ0ENABLE_RSZ_DONE_IRQ,
+                                               ISP_IRQ0ENABLE);
+               break;
+       case CBK_MMU_ERR:
+               omap_writel(omap_readl(ISPMMU_IRQENABLE) &
+                                               ~(IRQENABLE_MULTIHITFAULT |
+                                               IRQENABLE_TWFAULT |
+                                               IRQENABLE_EMUMISS |
+                                               IRQENABLE_TRANSLNFAULT |
+                                               IRQENABLE_TLBMISS),
+                                               ISPMMU_IRQENABLE);
+               break;
+       case CBK_H3A_AWB_DONE:
+               omap_writel((omap_readl(ISP_IRQ0ENABLE)) &
+                                               ~IRQ0ENABLE_H3A_AWB_DONE_IRQ,
+                                               ISP_IRQ0ENABLE);
+               break;
+       case CBK_H3A_AF_DONE:
+               omap_writel((omap_readl(ISP_IRQ0ENABLE))&
+                               (~IRQ0ENABLE_H3A_AF_DONE_IRQ), ISP_IRQ0ENABLE);
+               break;
+       case CBK_HIST_DONE:
+               omap_writel((omap_readl(ISP_IRQ0ENABLE)) &
+                                               ~IRQ0ENABLE_HIST_DONE_IRQ,
+                                               ISP_IRQ0ENABLE);
+               break;
+       case CBK_HS_VS:
+               omap_writel((omap_readl(ISP_IRQ0ENABLE)) &
+                                               ~IRQ0ENABLE_HS_VS_IRQ,
+                                               ISP_IRQ0ENABLE);
+               break;
+       case CBK_LSC_ISR:
+               omap_writel(omap_readl(ISP_IRQ0ENABLE) &
+                                       ~(IRQ0ENABLE_CCDC_LSC_DONE_IRQ |
+                                       IRQ0ENABLE_CCDC_LSC_PREF_COMP_IRQ |
+                                       IRQ0ENABLE_CCDC_LSC_PREF_ERR_IRQ),
+                                       ISP_IRQ0ENABLE);
+               break;
+       default:
+               break;
+       }
+
+       return 0;
+}
+EXPORT_SYMBOL(isp_unset_callback);
+
+/**
+ * isp_request_interface - Requests an ISP interface type (parallel or serial).
+ * @if_t: Type of requested ISP interface (parallel or serial).
+ *
+ * This function requests for allocation of an ISP interface type.
+ **/
+int isp_request_interface(enum isp_interface_type if_t)
+{
+       if (isp_obj.if_status & if_t) {
+               DPRINTK_ISPCTRL("ISP_ERR : Requested Interface already \
+                       allocated\n");
+               goto err_ebusy;
+       }
+       if ((isp_obj.if_status == (ISP_PARLL | ISP_CSIA))
+                       || isp_obj.if_status == (ISP_CSIA | ISP_CSIB)) {
+               DPRINTK_ISPCTRL("ISP_ERR : No Free interface now\n");
+               goto err_ebusy;
+       }
+
+       if (((isp_obj.if_status == ISP_PARLL) && (if_t == ISP_CSIA)) ||
+                               ((isp_obj.if_status == ISP_CSIA) &&
+                               (if_t == ISP_PARLL)) ||
+                               ((isp_obj.if_status == ISP_CSIA) &&
+                               (if_t == ISP_CSIB)) ||
+                               ((isp_obj.if_status == ISP_CSIB) &&
+                               (if_t == ISP_CSIA)) ||
+                               (isp_obj.if_status == 0)) {
+               isp_obj.if_status |= if_t;
+               return 0;
+       } else {
+               DPRINTK_ISPCTRL("ISP_ERR : Invalid Combination Serial- \
+                       Parallel interface\n");
+               return -EINVAL;
+       }
+
+err_ebusy:
+       return -EBUSY;
+}
+EXPORT_SYMBOL(isp_request_interface);
+
+/**
+ * isp_free_interface - Frees an ISP interface type (parallel or serial).
+ * @if_t: Type of ISP interface to be freed (parallel or serial).
+ *
+ * This function frees the allocation of an ISP interface type.
+ **/
+int isp_free_interface(enum isp_interface_type if_t)
+{
+       isp_obj.if_status &= ~if_t;
+       return 0;
+}
+EXPORT_SYMBOL(isp_free_interface);
+
+/**
+ * isp_set_xclk - Configures the specified cam_xclk to the desired frequency.
+ * @xclk: Desired frequency of the clock in Hz.
+ * @xclksel: XCLK to configure (0 = A, 1 = B).
+ *
+ * Configures the specified MCLK divisor in the ISP timing control register
+ * (TCTRL_CTRL) to generate the desired xclk clock value.
+ *
+ * Divisor = CM_CAM_MCLK_HZ / xclk
+ *
+ * Returns the final frequency that is actually being generated
+ **/
+u32 isp_set_xclk(u32 xclk, u8 xclksel)
+{
+       u32 divisor;
+       u32 currentxclk;
+
+       if (xclk >= CM_CAM_MCLK_HZ) {
+               divisor = ISPTCTRL_CTRL_DIV_BYPASS;
+               currentxclk = CM_CAM_MCLK_HZ;
+       } else if (xclk >= 2) {
+               divisor = CM_CAM_MCLK_HZ / xclk;
+               if (divisor >= ISPTCTRL_CTRL_DIV_BYPASS)
+                       divisor = ISPTCTRL_CTRL_DIV_BYPASS - 1;
+               currentxclk = CM_CAM_MCLK_HZ / divisor;
+       } else {
+               divisor = xclk;
+               currentxclk = 0;
+       }
+
+       switch (xclksel) {
+       case 0:
+               omap_writel((omap_readl(ISP_TCTRL_CTRL) &
+                               ~ISPTCTRL_CTRL_DIVA_MASK) |
+                               (divisor << ISPTCTRL_CTRL_DIVA_SHIFT),
+                               ISP_TCTRL_CTRL);
+               DPRINTK_ISPCTRL("isp_set_xclk(): cam_xclka set to %d Hz\n",
+                                                               currentxclk);
+               break;
+       case 1:
+               omap_writel((omap_readl(ISP_TCTRL_CTRL) &
+                               ~ISPTCTRL_CTRL_DIVB_MASK) |
+                               (divisor << ISPTCTRL_CTRL_DIVB_SHIFT),
+                               ISP_TCTRL_CTRL);
+               DPRINTK_ISPCTRL("isp_set_xclk(): cam_xclkb set to %d Hz\n",
+                                                               currentxclk);
+               break;
+       default:
+               DPRINTK_ISPCTRL("ISP_ERR: isp_set_xclk(): Invalid requested "
+                                               "xclk. Must be 0 (A) or 1 (B)."
+                                               "\n");
+               return -EINVAL;
+       }
+
+       return currentxclk;
+}
+EXPORT_SYMBOL(isp_set_xclk);
+
+/**
+ * isp_get_xclk - Returns the frequency in Hz of the desired cam_xclk.
+ * @xclksel: XCLK to retrieve (0 = A, 1 = B).
+ *
+ * This function returns the External Clock (XCLKA or XCLKB) value generated
+ * by the ISP.
+ **/
+u32 isp_get_xclk(u8 xclksel)
+{
+       u32 xclkdiv;
+       u32 xclk;
+
+       switch (xclksel) {
+       case 0:
+               xclkdiv = omap_readl(ISP_TCTRL_CTRL) & ISPTCTRL_CTRL_DIVA_MASK;
+               xclkdiv = xclkdiv >> ISPTCTRL_CTRL_DIVA_SHIFT;
+               break;
+       case 1:
+               xclkdiv = omap_readl(ISP_TCTRL_CTRL) & ISPTCTRL_CTRL_DIVB_MASK;
+               xclkdiv = xclkdiv >> ISPTCTRL_CTRL_DIVB_SHIFT;
+               break;
+       default:
+               DPRINTK_ISPCTRL("ISP_ERR: isp_get_xclk(): Invalid requested "
+                                               "xclk. Must be 0 (A) or 1 (B)."
+                                               "\n");
+               return -EINVAL;
+       }
+
+       switch (xclkdiv) {
+       case 0:
+       case 1:
+               xclk = 0;
+               break;
+       case 0x1f:
+               xclk = CM_CAM_MCLK_HZ;
+               break;
+       default:
+               xclk = CM_CAM_MCLK_HZ / xclkdiv;
+               break;
+       }
+
+       return xclk;
+}
+EXPORT_SYMBOL(isp_get_xclk);
+
+/**
+ * isp_power_settings - Sysconfig settings, for Power Management.
+ * @isp_sysconfig: Structure containing the power settings for ISP to configure
+ *
+ * Sets the power settings for the ISP, and SBL bus.
+ **/
+void isp_power_settings(struct isp_sysc isp_sysconfig)
+{
+       if (isp_sysconfig.idle_mode) {
+               omap_writel(ISP_SYSCONFIG_AUTOIDLE |
+                               (ISP_SYSCONFIG_MIDLEMODE_SMARTSTANDBY <<
+                               ISP_SYSCONFIG_MIDLEMODE_SHIFT),
+                               ISP_SYSCONFIG);
+
+               omap_writel(ISPMMU_AUTOIDLE | (ISPMMU_SIDLEMODE_SMARTIDLE <<
+                                               ISPMMU_SIDLEMODE_SHIFT),
+                                               ISPMMU_SYSCONFIG);
+               if (is_sil_rev_equal_to(OMAP3430_REV_ES1_0)) {
+                       omap_writel(ISPCSI1_AUTOIDLE |
+                                       (ISPCSI1_MIDLEMODE_SMARTSTANDBY <<
+                                       ISPCSI1_MIDLEMODE_SHIFT),
+                                       ISP_CSIA_SYSCONFIG);
+                       omap_writel(ISPCSI1_AUTOIDLE |
+                                       (ISPCSI1_MIDLEMODE_SMARTSTANDBY <<
+                                       ISPCSI1_MIDLEMODE_SHIFT),
+                                       ISP_CSIB_SYSCONFIG);
+               }
+               omap_writel(ISPCTRL_SBL_AUTOIDLE, ISP_CTRL);
+
+       } else {
+               omap_writel(ISP_SYSCONFIG_AUTOIDLE |
+                               (ISP_SYSCONFIG_MIDLEMODE_FORCESTANDBY <<
+                               ISP_SYSCONFIG_MIDLEMODE_SHIFT),
+                               ISP_SYSCONFIG);
+
+               omap_writel(ISPMMU_AUTOIDLE |
+                       (ISPMMU_SIDLEMODE_NOIDLE << ISPMMU_SIDLEMODE_SHIFT),
+                                                       ISPMMU_SYSCONFIG);
+               if (is_sil_rev_equal_to(OMAP3430_REV_ES1_0)) {
+                       omap_writel(ISPCSI1_AUTOIDLE |
+                                       (ISPCSI1_MIDLEMODE_FORCESTANDBY <<
+                                       ISPCSI1_MIDLEMODE_SHIFT),
+                                       ISP_CSIA_SYSCONFIG);
+
+                       omap_writel(ISPCSI1_AUTOIDLE |
+                                       (ISPCSI1_MIDLEMODE_FORCESTANDBY <<
+                                       ISPCSI1_MIDLEMODE_SHIFT),
+                                       ISP_CSIB_SYSCONFIG);
+               }
+
+               omap_writel(ISPCTRL_SBL_AUTOIDLE, ISP_CTRL);
+       }
+}
+EXPORT_SYMBOL(isp_power_settings);
+
+#define BIT_SET(var, shift, mask, val)         \
+       do {                                    \
+               var = (var & ~(mask << shift))  \
+                       | (val << shift);       \
+       } while (0)
+
+static int isp_init_csi(struct isp_interface_config *config)
+{
+       u32 i = 0, val, reg;
+       int format;
+
+       switch (config->u.csi.format) {
+       case V4L2_PIX_FMT_SGRBG10:
+               format = 0x16;          /* RAW10+VP */
+               break;
+       case V4L2_PIX_FMT_SGRBG10DPCM8:
+               format = 0x12;          /* RAW8+DPCM10+VP */
+               break;
+       default:
+               printk(KERN_ERR "isp_init_csi: bad csi format\n");
+               return -EINVAL;
+       }
+
+       /* Reset the CSI and wait for reset to complete */
+       omap_writel(omap_readl(ISPCSI1_SYSCONFIG) | BIT(1), ISPCSI1_SYSCONFIG);
+       while (!(omap_readl(ISPCSI1_SYSSTATUS) & BIT(0))) {
+               udelay(10);
+               if (i++ > 10)
+                       break;
+       }
+       if (!(omap_readl(ISPCSI1_SYSSTATUS) & BIT(0))) {
+               printk(KERN_WARNING
+                       "omap3_isp: timeout waiting for csi reset\n");
+       }
+
+       /* CONTROL_CSIRXFE */
+       omap_writel(
+               /* CSIb receiver data/clock or data/strobe mode */
+               (config->u.csi.signalling << 10)
+               | BIT(12)       /* Enable differential transceiver */
+               | BIT(13)       /* Disable reset */
+#ifdef TERM_RESISTOR
+               | BIT(8)        /* Enable internal CSIb resistor (no effect) */
+#endif
+/*             | BIT(7) */     /* Strobe/clock inversion (no effect) */
+       , CONTROL_CSIRXFE);
+
+#ifdef TERM_RESISTOR
+       /* Set CONTROL_CSI */
+       val = omap_readl(CONTROL_CSI);
+       val &= ~(0x1F<<16);
+       val |= BIT(31) | (TERM_RESISTOR<<16);
+       omap_writel(val, CONTROL_CSI);
+#endif
+
+       /* ISPCSI1_CTRL */
+       val = omap_readl(ISPCSI1_CTRL);
+       val &= ~BIT(11);        /* Enable VP only off ->
+                               extract embedded data to interconnect */
+       BIT_SET(val, 8, 0x3, config->u.csi.vpclk);      /* Video port clock */
+/*     val |= BIT(3);  */      /* Wait for FEC before disabling interface */
+       val |= BIT(2);          /* I/O cell output is parallel
+                               (no effect, but errata says should be enabled
+                               for class 1/2) */
+       val |= BIT(12);         /* VP clock polarity to falling edge
+                               (needed or bad picture!) */
+
+       /* Data/strobe physical layer */
+       BIT_SET(val, 1, 1, config->u.csi.signalling);
+       BIT_SET(val, 10, 1, config->u.csi.strobe_clock_inv);
+       val |= BIT(4);          /* Magic bit to enable CSI1 and strobe mode */
+       omap_writel(val, ISPCSI1_CTRL);
+
+       /* ISPCSI1_LCx_CTRL logical channel #0 */
+       reg = ISPCSI1_LCx_CTRL(0);      /* reg = ISPCSI1_CTRL1; */
+       val = omap_readl(reg);
+       /* Format = RAW10+VP or RAW8+DPCM10+VP*/
+       BIT_SET(val, 3, 0x1f, format);
+       /* Enable setting of frame regions of interest */
+       BIT_SET(val, 1, 1, 1);
+       BIT_SET(val, 2, 1, config->u.csi.crc);
+       omap_writel(val, reg);
+
+       /* ISPCSI1_DAT_START for logical channel #0 */
+       reg = ISPCSI1_LCx_DAT_START(0);         /* reg = ISPCSI1_DAT_START; */
+       val = omap_readl(reg);
+       BIT_SET(val, 16, 0xfff, config->u.csi.data_start);
+       omap_writel(val, reg);
+
+       /* ISPCSI1_DAT_SIZE for logical channel #0 */
+       reg = ISPCSI1_LCx_DAT_SIZE(0);          /* reg = ISPCSI1_DAT_SIZE; */
+       val = omap_readl(reg);
+       BIT_SET(val, 16, 0xfff, config->u.csi.data_size);
+       omap_writel(val, reg);
+
+       /* Clear status bits for logical channel #0 */
+       omap_writel(0xFFF & ~BIT(6), ISPCSI1_LC01_IRQSTATUS);
+
+       /* Enable CSI1 */
+       val = omap_readl(ISPCSI1_CTRL);
+       val |=  BIT(0) | BIT(4);
+       omap_writel(val, ISPCSI1_CTRL);
+
+       if (!(omap_readl(ISPCSI1_CTRL) & BIT(4))) {
+               printk(KERN_WARNING "OMAP3 CSI1 bus not available\n");
+               if (config->u.csi.signalling)   /* Strobe mode requires CSI1 */
+                       return -EIO;
+       }
+
+       return 0;
+}
+
+/**
+ * isp_configure_interface - Configures ISP Control I/F related parameters.
+ * @config: Pointer to structure containing the desired configuration for the
+ *     ISP.
+ *
+ * Configures ISP control register (ISP_CTRL) with the values specified inside
+ * the config structure. Controls:
+ * - Selection of parallel or serial input to the preview hardware.
+ * - Data lane shifter.
+ * - Pixel clock polarity.
+ * - 8 to 16-bit bridge at the input of CCDC module.
+ * - HS or VS synchronization signal detection
+ **/
+int isp_configure_interface(struct isp_interface_config *config)
+{
+       u32 ispctrl_val = omap_readl(ISP_CTRL);
+       u32 ispccdc_vdint_val;
+       int r;
+
+       ispctrl_val &= ISPCTRL_SHIFT_MASK;
+       ispctrl_val |= (config->dataline_shift << ISPCTRL_SHIFT_SHIFT);
+       ispctrl_val &= ~ISPCTRL_PAR_CLK_POL_INV;
+
+       ispctrl_val &= (ISPCTRL_PAR_SER_CLK_SEL_MASK);
+       switch (config->ccdc_par_ser) {
+       case ISP_PARLL:
+               ispctrl_val |= ISPCTRL_PAR_SER_CLK_SEL_PARALLEL;
+               ispctrl_val |= (config->u.par.par_clk_pol
+                                               << ISPCTRL_PAR_CLK_POL_SHIFT);
+               ispctrl_val &= ~ISPCTRL_PAR_BRIDGE_BENDIAN;
+               ispctrl_val |= (config->u.par.par_bridge
+                                               << ISPCTRL_PAR_BRIDGE_SHIFT);
+               break;
+       case ISP_CSIB:
+               ispctrl_val |= ISPCTRL_PAR_SER_CLK_SEL_CSIB;
+               r = isp_init_csi(config);
+               if (r)
+                       return r;
+               break;
+       default:
+               return -EINVAL;
+       }
+
+       ispctrl_val &= ~(ISPCTRL_SYNC_DETECT_VSRISE);
+       ispctrl_val |= (config->hsvs_syncdetect);
+
+       omap_writel(ispctrl_val, ISP_CTRL);
+
+       ispccdc_vdint_val = omap_readl(ISPCCDC_VDINT);
+       ispccdc_vdint_val &= ~(ISPCCDC_VDINT_0_MASK << ISPCCDC_VDINT_0_SHIFT);
+       ispccdc_vdint_val &= ~(ISPCCDC_VDINT_1_MASK << ISPCCDC_VDINT_1_SHIFT);
+       omap_writel((config->vdint0_timing << ISPCCDC_VDINT_0_SHIFT) |
+                                               (config->vdint1_timing <<
+                                               ISPCCDC_VDINT_1_SHIFT),
+                                               ISPCCDC_VDINT);
+
+       return 0;
+}
+EXPORT_SYMBOL(isp_configure_interface);
+
+/**
+ * isp_CCDC_VD01_enable - Enables VD0 and VD1 IRQs.
+ *
+ * Sets VD0 and VD1 bits in IRQ0STATUS to reset the flag, and sets them in
+ * IRQ0ENABLE to enable the corresponding IRQs.
+ **/
+void isp_CCDC_VD01_enable(void)
+{
+       omap_writel(IRQ0STATUS_CCDC_VD0_IRQ | IRQ0STATUS_CCDC_VD1_IRQ,
+                                                       ISP_IRQ0STATUS);
+       omap_writel(omap_readl(ISP_IRQ0ENABLE) | IRQ0ENABLE_CCDC_VD0_IRQ |
+                                               IRQ0ENABLE_CCDC_VD1_IRQ,
+                                               ISP_IRQ0ENABLE);
+}
+
+/**
+ * isp_CCDC_VD01_disable - Disables VD0 and VD1 IRQs.
+ *
+ * Clears VD0 and VD1 bits in IRQ0ENABLE register.
+ **/
+void isp_CCDC_VD01_disable(void)
+{
+       omap_writel(omap_readl(ISP_IRQ0ENABLE) & ~(IRQ0ENABLE_CCDC_VD0_IRQ |
+                                               IRQ0ENABLE_CCDC_VD1_IRQ),
+                                               ISP_IRQ0ENABLE);
+}
+
+/**
+ * omap34xx_isp_isr - Interrupt Service Routine for Camera ISP module.
+ * @irq: Not used currently.
+ * @ispirq_disp: Pointer to the object that is passed while request_irq is
+ *               called. This is the ispirq_obj object containing info on the
+ *               callback.
+ *
+ * Handles the corresponding callback if plugged in.
+ *
+ * Returns IRQ_HANDLED when IRQ was correctly handled, or IRQ_NONE when the
+ * IRQ wasn't handled.
+ **/
+static irqreturn_t omap34xx_isp_isr(int irq, void *ispirq_disp)
+{
+       struct ispirq *irqdis = (struct ispirq *)ispirq_disp;
+       u32 irqstatus = 0;
+       unsigned long irqflags = 0;
+       u8 is_irqhandled = 0;
+
+       irqstatus = omap_readl(ISP_IRQ0STATUS);
+
+       spin_lock_irqsave(&isp_obj.lock, irqflags);
+
+       if (irqdis->isp_callbk[CBK_CATCHALL])
+               irqdis->isp_callbk[CBK_CATCHALL](
+                       irqstatus,
+                       irqdis->isp_callbk_arg1[CBK_CATCHALL],
+                       irqdis->isp_callbk_arg2[CBK_CATCHALL]);
+
+       if ((irqstatus & MMU_ERR) == MMU_ERR) {
+               if (irqdis->isp_callbk[CBK_MMU_ERR])
+                       irqdis->isp_callbk[CBK_MMU_ERR](irqstatus,
+                               irqdis->isp_callbk_arg1[CBK_MMU_ERR],
+                               irqdis->isp_callbk_arg2[CBK_MMU_ERR]);
+               is_irqhandled = 1;
+               goto out;
+       }
+
+       if ((irqstatus & CCDC_VD1) == CCDC_VD1) {
+               if (irqdis->isp_callbk[CBK_CCDC_VD1])
+                               irqdis->isp_callbk[CBK_CCDC_VD1](CCDC_VD1,
+                               irqdis->isp_callbk_arg1[CBK_CCDC_VD1],
+                               irqdis->isp_callbk_arg2[CBK_CCDC_VD1]);
+               is_irqhandled = 1;
+       }
+
+       if ((irqstatus & CCDC_VD0) == CCDC_VD0) {
+               if (irqdis->isp_callbk[CBK_CCDC_VD0])
+                       irqdis->isp_callbk[CBK_CCDC_VD0](CCDC_VD0,
+                               irqdis->isp_callbk_arg1[CBK_CCDC_VD0],
+                               irqdis->isp_callbk_arg2[CBK_CCDC_VD0]);
+               is_irqhandled = 1;
+       }
+
+       if ((irqstatus & PREV_DONE) == PREV_DONE) {
+               if (irqdis->isp_callbk[CBK_PREV_DONE])
+                       irqdis->isp_callbk[CBK_PREV_DONE](PREV_DONE,
+                               irqdis->isp_callbk_arg1[CBK_PREV_DONE],
+                               irqdis->isp_callbk_arg2[CBK_PREV_DONE]);
+               is_irqhandled = 1;
+       }
+
+       if ((irqstatus & RESZ_DONE) == RESZ_DONE) {
+               if (irqdis->isp_callbk[CBK_RESZ_DONE])
+                       irqdis->isp_callbk[CBK_RESZ_DONE](RESZ_DONE,
+                               irqdis->isp_callbk_arg1[CBK_RESZ_DONE],
+                               irqdis->isp_callbk_arg2[CBK_RESZ_DONE]);
+               is_irqhandled = 1;
+       }
+
+       if ((irqstatus & H3A_AWB_DONE) == H3A_AWB_DONE) {
+               if (irqdis->isp_callbk[CBK_H3A_AWB_DONE])
+                       irqdis->isp_callbk[CBK_H3A_AWB_DONE](H3A_AWB_DONE,
+                               irqdis->isp_callbk_arg1[CBK_H3A_AWB_DONE],
+                               irqdis->isp_callbk_arg2[CBK_H3A_AWB_DONE]);
+               is_irqhandled = 1;
+       }
+
+       if ((irqstatus & HIST_DONE) == HIST_DONE) {
+               if (irqdis->isp_callbk[CBK_HIST_DONE])
+                       irqdis->isp_callbk[CBK_HIST_DONE](HIST_DONE,
+                               irqdis->isp_callbk_arg1[CBK_HIST_DONE],
+                               irqdis->isp_callbk_arg2[CBK_HIST_DONE]);
+               is_irqhandled = 1;
+       }
+
+       if ((irqstatus & HS_VS) == HS_VS) {
+               if (irqdis->isp_callbk[CBK_HS_VS])
+                       irqdis->isp_callbk[CBK_HS_VS](HS_VS,
+                               irqdis->isp_callbk_arg1[CBK_HS_VS],
+                               irqdis->isp_callbk_arg2[CBK_HS_VS]);
+               is_irqhandled = 1;
+       }
+
+       if ((irqstatus & H3A_AF_DONE) == H3A_AF_DONE) {
+               if (irqdis->isp_callbk[CBK_H3A_AF_DONE])
+                       irqdis->isp_callbk[CBK_H3A_AF_DONE](H3A_AF_DONE,
+                               irqdis->isp_callbk_arg1[CBK_H3A_AF_DONE],
+                               irqdis->isp_callbk_arg2[CBK_H3A_AF_DONE]);
+               is_irqhandled = 1;
+       }
+
+       if (irqstatus & LSC_PRE_ERR) {
+               printk(KERN_ERR "isp_sr: LSC_PRE_ERR \n");
+               omap_writel(irqstatus, ISP_IRQ0STATUS);
+               ispccdc_enable_lsc(0);
+               ispccdc_enable_lsc(1);
+               spin_unlock_irqrestore(&isp_obj.lock, irqflags);
+               return IRQ_HANDLED;
+       }
+
+       if (irqstatus & IRQ0STATUS_CSIB_IRQ) {
+               u32 ispcsi1_irqstatus;
+
+               ispcsi1_irqstatus = omap_readl(ISPCSI1_LC01_IRQSTATUS);
+               DPRINTK_ISPCTRL("%x\n", ispcsi1_irqstatus);
+       }
+
+out:
+       omap_writel(irqstatus, ISP_IRQ0STATUS);
+       spin_unlock_irqrestore(&isp_obj.lock, irqflags);
+
+       if (is_irqhandled)
+               return IRQ_HANDLED;
+       else
+               return IRQ_NONE;
+}
+/* Device name, needed for resource tracking layer */
+struct device_driver camera_drv = {
+       .name = "camera"
+};
+
+struct device camera_dev = {
+       .driver = &camera_drv,
+};
+
+/**
+ * isp_set_pipeline - Set bit mask for submodules enabled within the ISP.
+ * @soc_type: Sensor to use: 1 - Smart sensor, 0 - Raw sensor.
+ *
+ * Sets Previewer and Resizer in the bit mask only if its a Raw sensor.
+ **/
+void isp_set_pipeline(int soc_type)
+{
+       ispmodule_obj.isp_pipeline |= OMAP_ISP_CCDC;
+
+       if (!soc_type)
+               ispmodule_obj.isp_pipeline |= (OMAP_ISP_PREVIEW |
+                                                       OMAP_ISP_RESIZER);
+
+       return;
+}
+EXPORT_SYMBOL(isp_open);
+
+/**
+ * omapisp_unset_callback - Unsets all the callbacks associated with ISP module
+ **/
+void omapisp_unset_callback()
+{
+       isp_unset_callback(CBK_HS_VS);
+
+       if ((ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER) &&
+                                               is_ispresizer_enabled())
+               isp_unset_callback(CBK_RESZ_DONE);
+
+       if ((ispmodule_obj.isp_pipeline & OMAP_ISP_PREVIEW) &&
+                                               is_isppreview_enabled())
+               isp_unset_callback(CBK_PREV_DONE);
+
+       if (ispmodule_obj.isp_pipeline & OMAP_ISP_CCDC) {
+               isp_unset_callback(CBK_CCDC_VD0);
+               isp_unset_callback(CBK_CCDC_VD1);
+               isp_unset_callback(CBK_LSC_ISR);
+       }
+       omap_writel(omap_readl(ISP_IRQ0STATUS) | ISP_INT_CLR, ISP_IRQ0STATUS);
+}
+EXPORT_SYMBOL(isp_close);
+
+/**
+ * isp_start - Starts ISP submodule
+ *
+ * Start the needed isp components assuming these components
+ * are configured correctly.
+ **/
+void isp_start(void)
+{
+       if ((ispmodule_obj.isp_pipeline & OMAP_ISP_PREVIEW) &&
+                                               is_isppreview_enabled())
+               isppreview_enable(1);
+
+       return;
+}
+EXPORT_SYMBOL(isp_start);
+
+/**
+ * isp_stop - Stops isp submodules
+ **/
+void isp_stop()
+{
+       int timeout;
+
+       spin_lock(&isp_obj.isp_temp_buf_lock);
+       ispmodule_obj.isp_temp_state = ISP_FREE_RUNNING;
+       spin_unlock(&isp_obj.isp_temp_buf_lock);
+       omapisp_unset_callback();
+
+       if ((ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER) &&
+                                               is_ispresizer_enabled()) {
+               ispresizer_enable(0);
+               timeout = 0;
+               while (ispresizer_busy() && (timeout < 20)) {
+                       timeout++;
+                       mdelay(10);
+               }
+       }
+
+       if ((ispmodule_obj.isp_pipeline & OMAP_ISP_PREVIEW) &&
+                                               is_isppreview_enabled()) {
+               isppreview_enable(0);
+               timeout = 0;
+               while (isppreview_busy() && (timeout < 20)) {
+                       timeout++;
+                       mdelay(10);
+               }
+       }
+
+       if (ispmodule_obj.isp_pipeline & OMAP_ISP_CCDC) {
+               ispccdc_enable_lsc(0);
+               ispccdc_enable(0);
+               timeout = 0;
+               while (ispccdc_busy() && (timeout < 20)) {
+                       timeout++;
+                       mdelay(10);
+               }
+       }
+       if (ispccdc_busy() || isppreview_busy() || ispresizer_busy()) {
+               isp_save_ctx();
+               omap_writel(omap_readl(ISP_SYSCONFIG) |
+                       ISP_SYSCONFIG_SOFTRESET, ISP_SYSCONFIG);
+               timeout = 0;
+               while ((!(omap_readl(ISP_SYSSTATUS) & 0x1)) && timeout < 20) {
+                       timeout++;
+                       mdelay(1);
+               }
+       isp_restore_ctx();
+       }
+}
+
+/**
+ * isp_set_buf - Sets output address for submodules.
+ * @sgdma_state: Pointer to structure with the SGDMA state for each videobuffer
+ **/
+void isp_set_buf(struct isp_sgdma_state *sgdma_state)
+{
+       if ((ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER) &&
+                                               is_ispresizer_enabled())
+               ispresizer_set_outaddr(sgdma_state->isp_addr);
+       else if ((ispmodule_obj.isp_pipeline & OMAP_ISP_PREVIEW) &&
+                                               is_isppreview_enabled())
+               isppreview_set_outaddr(sgdma_state->isp_addr);
+       else if (ispmodule_obj.isp_pipeline & OMAP_ISP_CCDC)
+               ispccdc_set_outaddr(sgdma_state->isp_addr);
+
+}
+
+/**
+ * isp_calc_pipeline - Sets pipeline depending of input and output pixel format
+ * @pix_input: Pointer to V4L2 pixel format structure for input image.
+ * @pix_output: Pointer to V4L2 pixel format structure for output image.
+ **/
+void isp_calc_pipeline(struct v4l2_pix_format *pix_input,
+                                       struct v4l2_pix_format *pix_output)
+{
+       ispmodule_obj.isp_pipeline = OMAP_ISP_CCDC;
+       if ((pix_input->pixelformat == V4L2_PIX_FMT_SGRBG10) &&
+               (pix_output->pixelformat != V4L2_PIX_FMT_SGRBG10)) {
+               ispmodule_obj.isp_pipeline |= (OMAP_ISP_PREVIEW |
+                                                       OMAP_ISP_RESIZER);
+               ispccdc_config_datapath(CCDC_RAW, CCDC_OTHERS_VP);
+               isppreview_config_datapath(PRV_RAW_CCDC, PREVIEW_RSZ);
+               ispresizer_config_datapath(RSZ_OTFLY_YUV);
+       } else {
+               if (pix_input->pixelformat == V4L2_PIX_FMT_SGRBG10)
+                       ispccdc_config_datapath(CCDC_RAW, CCDC_OTHERS_MEM);
+               else
+                       ispccdc_config_datapath(CCDC_YUV_SYNC,
+                                                       CCDC_OTHERS_MEM);
+       }
+       return;
+}
+
+/**
+ * isp_config_pipeline - Configures the image size and ycpos for ISP submodules
+ * @pix_input: Pointer to V4L2 pixel format structure for input image.
+ * @pix_output: Pointer to V4L2 pixel format structure for output image.
+ *
+ * The configuration of ycpos depends on the output pixel format for both the
+ * Preview and Resizer submodules.
+ **/
+void isp_config_pipeline(struct v4l2_pix_format *pix_input,
+                                       struct v4l2_pix_format *pix_output)
+{
+       ispccdc_config_size(ispmodule_obj.ccdc_input_width,
+                       ispmodule_obj.ccdc_input_height,
+                       ispmodule_obj.ccdc_output_width,
+                       ispmodule_obj.ccdc_output_height);
+
+       if (ispmodule_obj.isp_pipeline & OMAP_ISP_PREVIEW)
+               isppreview_config_size(ispmodule_obj.preview_input_width,
+                       ispmodule_obj.preview_input_height,
+                       ispmodule_obj.preview_output_width,
+                       ispmodule_obj.preview_output_height);
+
+       if (ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER)
+               ispresizer_config_size(ispmodule_obj.resizer_input_width,
+                       ispmodule_obj.resizer_input_height,
+                       ispmodule_obj.resizer_output_width,
+                       ispmodule_obj.resizer_output_height);
+
+       if (pix_output->pixelformat == V4L2_PIX_FMT_UYVY) {
+               isppreview_config_ycpos(YCPOS_YCrYCb);
+               if (is_ispresizer_enabled())
+                       ispresizer_config_ycpos(0);
+       } else {
+               isppreview_config_ycpos(YCPOS_CrYCbY);
+               if (is_ispresizer_enabled())
+                       ispresizer_config_ycpos(1);
+       }
+
+       return;
+}
+
+/**
+ * isp_vbq_done - Callback for interrupt completion
+ * @status: IRQ0STATUS register value. Passed by the ISR, or the caller.
+ * @arg1: Pointer to callback function for SG-DMA management.
+ * @arg2: Pointer to videobuffer structure managed by ISP.
+ **/
+void isp_vbq_done(unsigned long status, isp_vbq_callback_ptr arg1, void *arg2)
+{
+       struct videobuf_buffer *vb = (struct videobuf_buffer *) arg2;
+       int notify = 0;
+       int rval = 0;
+       unsigned long flags;
+
+       switch (status) {
+       case CCDC_VD0:
+               ispccdc_config_shadow_registers();
+               if ((ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER) ||
+                       (ispmodule_obj.isp_pipeline & OMAP_ISP_PREVIEW))
+                       return;
+               else {
+                       spin_lock(&isp_obj.isp_temp_buf_lock);
+                       if (ispmodule_obj.isp_temp_state != ISP_BUF_INIT) {
+                               spin_unlock(&isp_obj.isp_temp_buf_lock);
+                               return;
+
+                       } else {
+                               spin_unlock(&isp_obj.isp_temp_buf_lock);
+                               break;
+                       }
+               }
+               break;
+       case CCDC_VD1:
+               if ((ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER) ||
+                       (ispmodule_obj.isp_pipeline & OMAP_ISP_PREVIEW))
+                       return;
+               spin_lock(&isp_obj.isp_temp_buf_lock);
+               if (ispmodule_obj.isp_temp_state == ISP_BUF_INIT) {
+                       spin_unlock(&isp_obj.isp_temp_buf_lock);
+                       ispccdc_enable(0);
+                       return;
+               }
+               spin_unlock(&isp_obj.isp_temp_buf_lock);
+               return;
+               break;
+       case PREV_DONE:
+               if (is_isppreview_enabled()) {
+                       if (ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER) {
+                               if (!ispmodule_obj.applyCrop && (ispmodule_obj.
+                                                       isp_temp_state ==
+                                                       ISP_BUF_INIT))
+                                       ispresizer_enable(1);
+                               if (ispmodule_obj.applyCrop &&
+                                                       !ispresizer_busy()) {
+                                       ispresizer_enable(0);
+                                       ispresizer_applycrop();
+                                       ispmodule_obj.applyCrop = 0;
+                               }
+                       }
+                       isppreview_config_shadow_registers();
+                       isph3a_update_wb();
+                       if (ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER)
+                               return;
+               }
+               break;
+       case RESZ_DONE:
+               if (is_ispresizer_enabled()) {
+                       ispresizer_config_shadow_registers();
+                       spin_lock(&isp_obj.isp_temp_buf_lock);
+                       if (ispmodule_obj.isp_temp_state != ISP_BUF_INIT) {
+                               spin_unlock(&isp_obj.isp_temp_buf_lock);
+                               return;
+                       }
+                       spin_unlock(&isp_obj.isp_temp_buf_lock);
+               }
+               break;
+       case HS_VS:
+               spin_lock(&isp_obj.isp_temp_buf_lock);
+               if (ispmodule_obj.isp_temp_state == ISP_BUF_TRAN) {
+                       isp_CCDC_VD01_enable();
+                       ispmodule_obj.isp_temp_state = ISP_BUF_INIT;
+               }
+               spin_unlock(&isp_obj.isp_temp_buf_lock);
+               return;
+       default:
+               break;
+       }
+
+       spin_lock_irqsave(&ispsg.lock, flags);
+       ispsg.free_sgdma++;
+       if (ispsg.free_sgdma > NUM_SG_DMA)
+               ispsg.free_sgdma = NUM_SG_DMA;
+       spin_unlock_irqrestore(&ispsg.lock, flags);
+
+       rval = arg1(vb);
+
+       if (rval)
+               isp_sgdma_process(&ispsg, 1, &notify, arg1);
+
+       return;
+}
+
+/**
+ * isp_sgdma_init - Initializes Scatter Gather DMA status and operations.
+ **/
+void isp_sgdma_init()
+{
+       int sg;
+
+       ispsg.free_sgdma = NUM_SG_DMA;
+       ispsg.next_sgdma = 0;
+       for (sg = 0; sg < NUM_SG_DMA; sg++) {
+               ispsg.sg_state[sg].status = 0;
+               ispsg.sg_state[sg].callback = NULL;
+               ispsg.sg_state[sg].arg = NULL;
+       }
+}
+EXPORT_SYMBOL(isp_stop);
+
+/**
+ * isp_sgdma_process - Sets operations and config for specified SG DMA
+ * @sgdma: SG-DMA function to work on.
+ * @irq: Flag to specify if an IRQ is associated with the DMA completion.
+ * @dma_notify: Pointer to flag that says when the ISP has to be started.
+ * @func_ptr: Callback function pointer for SG-DMA setup.
+ **/
+void isp_sgdma_process(struct isp_sgdma *sgdma, int irq, int *dma_notify,
+                                               isp_vbq_callback_ptr func_ptr)
+{
+       struct isp_sgdma_state *sgdma_state;
+       unsigned long flags;
+       spin_lock_irqsave(&sgdma->lock, flags);
+
+       if (NUM_SG_DMA > sgdma->free_sgdma) {
+               sgdma_state = sgdma->sg_state +
+                       (sgdma->next_sgdma + sgdma->free_sgdma) % NUM_SG_DMA;
+               if (!irq) {
+                       if (*dma_notify) {
+                               isp_set_sgdma_callback(sgdma_state, func_ptr);
+                               isp_set_buf(sgdma_state);
+                               ispccdc_enable(1);
+                               isp_start();
+                               *dma_notify = 0;
+                               ispmodule_obj.isp_temp_state = ISP_BUF_TRAN;
+                       } else {
+                               if (ispmodule_obj.isp_temp_state ==
+                                                       ISP_FREE_RUNNING) {
+                                       isp_set_sgdma_callback(sgdma_state,
+                                                               func_ptr);
+                                       isp_set_buf(sgdma_state);
+                                       ispccdc_enable(1);
+                                       ispmodule_obj.isp_temp_state =
+                                                               ISP_BUF_TRAN;
+                               }
+                       }
+               } else {
+                       isp_set_sgdma_callback(sgdma_state, func_ptr);
+                       isp_set_buf(sgdma_state);
+                       ispccdc_enable(1);
+                       ispmodule_obj.isp_temp_state = ISP_BUF_INIT;
+
+                       if (*dma_notify) {
+                               isp_start();
+                               *dma_notify = 0;
+                       }
+               }
+       } else {
+               spin_lock(&isp_obj.isp_temp_buf_lock);
+               isp_CCDC_VD01_disable();
+               ispmodule_obj.isp_temp_state = ISP_FREE_RUNNING;
+               spin_unlock(&isp_obj.isp_temp_buf_lock);
+       }
+       spin_unlock_irqrestore(&sgdma->lock, flags);
+       return;
+}
+
+/**
+ * isp_sgdma_queue - Queues a Scatter-Gather DMA videobuffer.
+ * @vdma: Pointer to structure containing the desired DMA video buffer
+ *        transfer parameters.
+ * @vb: Pointer to structure containing the target videobuffer.
+ * @irq: Flag to specify if an IRQ is associated with the DMA completion.
+ * @dma_notify: Pointer to flag that says when the ISP has to be started.
+ * @func_ptr: Callback function pointer for SG-DMA setup.
+ *
+ * Returns 0 if successful, -EINVAL if invalid SG linked list setup, or -EBUSY
+ * if the ISP SG-DMA is not free.
+ **/
+int isp_sgdma_queue(struct videobuf_dmabuf *vdma, struct videobuf_buffer *vb,
+                                               int irq, int *dma_notify,
+                                               isp_vbq_callback_ptr func_ptr)
+{
+       unsigned long flags;
+       struct isp_sgdma_state *sg_state;
+       const struct scatterlist *sglist = vdma->sglist;
+       int sglen = vdma->sglen;
+
+       if ((sglen < 0) || ((sglen > 0) & !sglist))
+               return -EINVAL;
+
+       spin_lock_irqsave(&ispsg.lock, flags);
+
+       if (!ispsg.free_sgdma) {
+               spin_unlock_irqrestore(&ispsg.lock, flags);
+               return -EBUSY;
+       }
+
+       sg_state = ispsg.sg_state + ispsg.next_sgdma;
+       sg_state->isp_addr = ispsg.isp_addr_capture[vb->i];
+       sg_state->status = 0;
+       sg_state->callback = isp_vbq_done;
+       sg_state->arg = vb;
+
+       ispsg.next_sgdma = (ispsg.next_sgdma + 1) % NUM_SG_DMA;
+       ispsg.free_sgdma--;
+
+       spin_unlock_irqrestore(&ispsg.lock, flags);
+
+       isp_sgdma_process(&ispsg, irq, dma_notify, func_ptr);
+
+       return 0;
+}
+EXPORT_SYMBOL(isp_sgdma_queue);
+
+/**
+ * isp_vbq_prepare - Videobuffer queue prepare.
+ * @vbq: Pointer to videobuf_queue structure.
+ * @vb: Pointer to videobuf_buffer structure.
+ * @field: Requested Field order for the videobuffer.
+ *
+ * Returns 0 if successful, or -EIO if the ispmmu was unable to map a
+ * scatter-gather linked list data space.
+ **/
+int isp_vbq_prepare(struct videobuf_queue *vbq, struct videobuf_buffer *vb,
+                                                       enum v4l2_field field)
+{
+       unsigned int isp_addr;
+       struct videobuf_dmabuf  *vdma;
+
+       int err = 0;
+
+       vdma = videobuf_to_dma(vb);
+
+       isp_addr = ispmmu_map_sg(vdma->sglist, vdma->sglen);
+
+       if (!isp_addr)
+               err = -EIO;
+       else
+               ispsg.isp_addr_capture[vb->i] = isp_addr;
+
+       return err;
+}
+EXPORT_SYMBOL(isp_vbq_prepare);
+
+/**
+ * isp_vbq_release - Videobuffer queue release.
+ * @vbq: Pointer to videobuf_queue structure.
+ * @vb: Pointer to videobuf_buffer structure.
+ **/
+void isp_vbq_release(struct videobuf_queue *vbq, struct videobuf_buffer *vb)
+{
+       ispmmu_unmap(ispsg.isp_addr_capture[vb->i]);
+       ispsg.isp_addr_capture[vb->i] = (dma_addr_t) NULL;
+       return;
+}
+EXPORT_SYMBOL(isp_vbq_release);
+
+/**
+ * isp_queryctrl - Query V4L2 control from existing controls in ISP.
+ * @a: Pointer to v4l2_queryctrl structure. It only needs the id field filled.
+ *
+ * Returns 0 if successful, or -EINVAL if not found in ISP.
+ **/
+int isp_queryctrl(struct v4l2_queryctrl *a)
+{
+       int i;
+
+       i = find_vctrl(a->id);
+       if (i == -EINVAL)
+               a->flags = V4L2_CTRL_FLAG_DISABLED;
+
+       if (i < 0)
+               return -EINVAL;
+
+       *a = video_control[i].qc;
+       return 0;
+}
+EXPORT_SYMBOL(isp_queryctrl);
+
+/**
+ * isp_g_ctrl - Gets value of the desired V4L2 control.
+ * @a: V4L2 control to read actual value from.
+ *
+ * Return 0 if successful, or -EINVAL if chosen control is not found.
+ **/
+int isp_g_ctrl(struct v4l2_control *a)
+{
+       u8 current_value;
+       int rval = 0;
+
+       switch (a->id) {
+       case V4L2_CID_BRIGHTNESS:
+               isppreview_query_brightness(&current_value);
+               a->value = current_value / ISPPRV_BRIGHT_UNITS;
+               break;
+       case V4L2_CID_CONTRAST:
+               isppreview_query_contrast(&current_value);
+               a->value = current_value / ISPPRV_CONTRAST_UNITS;
+               break;
+       case V4L2_CID_PRIVATE_ISP_COLOR_FX:
+               isppreview_get_color(&current_value);
+               a->value = current_value;
+               break;
+       default:
+               rval = -EINVAL;
+               break;
+       }
+
+       return rval;
+}
+EXPORT_SYMBOL(isp_g_ctrl);
+
+/**
+ * isp_s_ctrl - Sets value of the desired V4L2 control.
+ * @a: V4L2 control to read actual value from.
+ *
+ * Return 0 if successful, -EINVAL if chosen control is not found or value
+ * is out of bounds, -EFAULT if copy_from_user or copy_to_user operation fails
+ * from camera abstraction layer related controls or the transfered user space
+ * pointer via the value field is not set properly.
+ **/
+int isp_s_ctrl(struct v4l2_control *a)
+{
+       int rval = 0;
+       u8 new_value = a->value;
+
+       switch (a->id) {
+       case V4L2_CID_BRIGHTNESS:
+               if (new_value > ISPPRV_BRIGHT_HIGH)
+                       rval = -EINVAL;
+               else
+                       isppreview_update_brightness(&new_value);
+               break;
+       case V4L2_CID_CONTRAST:
+               if (new_value > ISPPRV_CONTRAST_HIGH)
+                       rval = -EINVAL;
+               else
+                       isppreview_update_contrast(&new_value);
+               break;
+       case V4L2_CID_PRIVATE_ISP_COLOR_FX:
+               if (new_value > PREV_SEPIA_COLOR)
+                       rval = -EINVAL;
+               else
+                       isppreview_set_color(&new_value);
+               break;
+       default:
+               rval = -EINVAL;
+               break;
+       }
+
+       return rval;
+}
+EXPORT_SYMBOL(isp_s_ctrl);
+
+/**
+ * isp_handle_private - Handle all private ioctls for isp module.
+ * @cmd: ioctl cmd value
+ * @arg: ioctl arg value
+ *
+ * Return 0 if successful, -EINVAL if chosen cmd value is not handled or value
+ * is out of bounds, -EFAULT if ioctl arg value is not valid.
+ * Function simply routes the input ioctl cmd id to the appropriate handler in
+ * the isp module.
+ **/
+int isp_handle_private(int cmd, void *arg)
+{
+       int rval = 0;
+
+       switch (cmd) {
+       case VIDIOC_PRIVATE_ISP_CCDC_CFG:
+               rval = omap34xx_isp_ccdc_config(arg);
+               break;
+       case VIDIOC_PRIVATE_ISP_PRV_CFG:
+               rval = omap34xx_isp_preview_config(arg);
+               break;
+       case VIDIOC_PRIVATE_ISP_AEWB_CFG: {
+               struct isph3a_aewb_config *params;
+               params = (struct isph3a_aewb_config *) arg;
+               rval = isph3a_aewb_configure(params);
+               }
+               break;
+       case VIDIOC_PRIVATE_ISP_AEWB_REQ: {
+               struct isph3a_aewb_data *data;
+               data = (struct isph3a_aewb_data *) arg;
+               rval = isph3a_aewb_request_statistics(data);
+               }
+               break;
+       case VIDIOC_PRIVATE_ISP_HIST_CFG: {
+               struct isp_hist_config *params;
+               params = (struct isp_hist_config *) arg;
+               rval = isp_hist_configure(params);
+               }
+               break;
+       case VIDIOC_PRIVATE_ISP_HIST_REQ: {
+               struct isp_hist_data *data;
+               data = (struct isp_hist_data *) arg;
+               rval = isp_hist_request_statistics(data);
+               }
+               break;
+       case VIDIOC_PRIVATE_ISP_AF_CFG: {
+               struct af_configuration *params;
+               params = (struct af_configuration *) arg;
+               rval = isp_af_configure(params);
+               }
+       break;
+       case VIDIOC_PRIVATE_ISP_AF_REQ: {
+               struct isp_af_data *data;
+               data = (struct isp_af_data *) arg;
+               rval = isp_af_request_statistics(data);
+               }
+       break;
+       default:
+               rval = -EINVAL;
+               break;
+       }
+       return rval;
+}
+EXPORT_SYMBOL(isp_handle_private);
+
+/**
+ * isp_enum_fmt_cap - Gets more information of chosen format index and type
+ * @f: Pointer to structure containing index and type of format to read from.
+ *
+ * Returns 0 if successful, or -EINVAL if format index or format type is
+ * invalid.
+ **/
+int isp_enum_fmt_cap(struct v4l2_fmtdesc *f)
+{
+       int index = f->index;
+       enum v4l2_buf_type type = f->type;
+       int rval = -EINVAL;
+
+       if (index >= NUM_ISP_CAPTURE_FORMATS)
+               goto err;
+
+       memset(f, 0, sizeof(*f));
+       f->index = index;
+       f->type = type;
+
+       switch (f->type) {
+       case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+               rval = 0;
+               break;
+       default:
+               goto err;
+       }
+
+       f->flags = isp_formats[index].flags;
+       strncpy(f->description, isp_formats[index].description,
+                                               sizeof(f->description));
+       f->pixelformat = isp_formats[index].pixelformat;
+err:
+       return rval;
+}
+EXPORT_SYMBOL(isp_enum_fmt_cap);
+
+/**
+ * isp_g_fmt_cap - Gets current output image format.
+ * @f: Pointer to V4L2 format structure to be filled with current output format
+ **/
+void isp_g_fmt_cap(struct v4l2_pix_format *pix)
+{
+       *pix = ispmodule_obj.pix;
+       return;
+}
+EXPORT_SYMBOL(isp_g_fmt_cap);
+
+/**
+ * isp_s_fmt_cap - Sets I/O formats and crop and configures pipeline in ISP
+ * @f: Pointer to V4L2 format structure to be filled with current output format
+ *
+ * Returns 0 if successful, or return value of either isp_try_size or
+ * isp_try_fmt if there is an error.
+ **/
+int isp_s_fmt_cap(struct v4l2_pix_format *pix_input,
+                                       struct v4l2_pix_format *pix_output)
+{
+       int crop_scaling_w, crop_scaling_h = 0;
+       int rval = 0;
+
+       isp_calc_pipeline(pix_input, pix_output);
+       rval = isp_try_size(pix_input, pix_output);
+
+       if (rval)
+               goto out;
+
+       rval = isp_try_fmt(pix_input, pix_output);
+       if (rval)
+               goto out;
+
+       if (ispcroprect.width != pix_output->width) {
+               crop_scaling_w = 1;
+               ispcroprect.left = 0;
+               ispcroprect.width = pix_output->width;
+       }
+
+       if (ispcroprect.height != pix_output->height) {
+               crop_scaling_h = 1;
+               ispcroprect.top = 0;
+               ispcroprect.height = pix_output->height;
+       }
+
+       isp_config_pipeline(pix_input, pix_output);
+
+       if (crop_scaling_h || crop_scaling_w)
+               isp_config_crop(pix_output);
+
+out:
+       return rval;
+}
+EXPORT_SYMBOL(isp_s_fmt_cap);
+
+/**
+ * isp_config_crop - Configures crop parameters in isp resizer.
+ * @croppix: Pointer to V4L2 pixel format structure containing crop parameters
+ **/
+void isp_config_crop(struct v4l2_pix_format *croppix)
+{
+       u8 crop_scaling_w;
+       u8 crop_scaling_h;
+       struct v4l2_pix_format *pix = croppix;
+
+       crop_scaling_w = (ispmodule_obj.preview_output_width * 10) /
+                                                               pix->width;
+       crop_scaling_h = (ispmodule_obj.preview_output_height * 10) /
+                                                               pix->height;
+
+       cur_rect.left = (ispcroprect.left * crop_scaling_w) / 10;
+       cur_rect.top = (ispcroprect.top * crop_scaling_h) / 10;
+       cur_rect.width = (ispcroprect.width * crop_scaling_w) / 10;
+       cur_rect.height = (ispcroprect.height * crop_scaling_h) / 10;
+
+       ispresizer_trycrop(cur_rect.left, cur_rect.top, cur_rect.width,
+                                       cur_rect.height,
+                                       ispmodule_obj.resizer_output_width,
+                                       ispmodule_obj.resizer_output_height);
+
+       return;
+}
+EXPORT_SYMBOL(isp_config_crop);
+
+/**
+ * isp_g_crop - Gets crop rectangle size and position.
+ * @a: Pointer to V4L2 crop structure to be filled.
+ *
+ * Always returns 0.
+ **/
+int isp_g_crop(struct v4l2_crop *a)
+{
+       struct v4l2_crop *crop = a;
+
+       crop->c = ispcroprect;
+       return 0;
+}
+EXPORT_SYMBOL(isp_g_crop);
+
+/**
+ * isp_s_crop - Sets crop rectangle size and position and queues crop operation
+ * @a: Pointer to V4L2 crop structure with desired parameters.
+ * @pix: Pointer to V4L2 pixel format structure with desired parameters.
+ *
+ * Returns 0 if successful, or -EINVAL if crop parameters are out of bounds.
+ **/
+int isp_s_crop(struct v4l2_crop *a, struct v4l2_pix_format *pix)
+{
+       struct v4l2_crop *crop = a;
+       int rval = 0;
+
+       if ((crop->c.left + crop->c.width) > pix->width) {
+               rval = -EINVAL;
+               goto out;
+       }
+
+       if ((crop->c.top + crop->c.height) > pix->height) {
+               rval = -EINVAL;
+               goto out;
+       }
+
+       ispcroprect.left = crop->c.left;
+       ispcroprect.top = crop->c.top;
+       ispcroprect.width = crop->c.width;
+       ispcroprect.height = crop->c.height;
+
+       isp_config_crop(pix);
+
+       ispmodule_obj.applyCrop = 1;
+out:
+       return rval;
+}
+EXPORT_SYMBOL(isp_s_crop);
+
+/**
+ * isp_try_fmt_cap - Tries desired input/output image formats
+ * @pix_input: Pointer to V4L2 pixel format structure for input image.
+ * @pix_output: Pointer to V4L2 pixel format structure for output image.
+ *
+ * Returns 0 if successful, or return value of either isp_try_size or
+ * isp_try_fmt if there is an error.
+ **/
+int isp_try_fmt_cap(struct v4l2_pix_format *pix_input,
+                                       struct v4l2_pix_format *pix_output)
+{
+       int rval = 0;
+
+       isp_calc_pipeline(pix_input, pix_output);
+       rval = isp_try_size(pix_input, pix_output);
+
+       if (rval)
+               goto out;
+
+       rval = isp_try_fmt(pix_input, pix_output);
+
+       if (rval)
+               goto out;
+
+out:
+       return rval;
+}
+EXPORT_SYMBOL(isp_try_fmt_cap);
+
+/**
+ * isp_try_size - Tries size configuration for I/O images of each ISP submodule
+ * @pix_input: Pointer to V4L2 pixel format structure for input image.
+ * @pix_output: Pointer to V4L2 pixel format structure for output image.
+ *
+ * Returns 0 if successful, or return value of ispccdc_try_size,
+ * isppreview_try_size, or ispresizer_try_size (depending on the pipeline
+ * configuration) if there is an error.
+ **/
+int isp_try_size(struct v4l2_pix_format *pix_input,
+                                       struct v4l2_pix_format *pix_output)
+{
+       int rval = 0;
+       ispmodule_obj.ccdc_input_width = pix_input->width;
+       ispmodule_obj.ccdc_input_height = pix_input->height;
+       ispmodule_obj.resizer_output_width = pix_output->width;
+       ispmodule_obj.resizer_output_height = pix_output->height;
+
+       if (ispmodule_obj.isp_pipeline & OMAP_ISP_CCDC) {
+               rval = ispccdc_try_size(ispmodule_obj.ccdc_input_width,
+                                       ispmodule_obj.ccdc_input_height,
+                                       &ispmodule_obj.ccdc_output_width,
+                                       &ispmodule_obj.ccdc_output_height);
+               pix_output->width = ispmodule_obj.ccdc_output_width;
+               pix_output->height = ispmodule_obj.ccdc_output_height;
+       }
+
+       if (ispmodule_obj.isp_pipeline & OMAP_ISP_PREVIEW) {
+               ispmodule_obj.preview_input_width =
+                                       ispmodule_obj.ccdc_output_width;
+               ispmodule_obj.preview_input_height =
+                                       ispmodule_obj.ccdc_output_height;
+               rval = isppreview_try_size(ispmodule_obj.preview_input_width,
+                                       ispmodule_obj.preview_input_height,
+                                       &ispmodule_obj.preview_output_width,
+                                       &ispmodule_obj.preview_output_height);
+               pix_output->width = ispmodule_obj.preview_output_width;
+               pix_output->height = ispmodule_obj.preview_output_height;
+       }
+
+       if (ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER) {
+               ispmodule_obj.resizer_input_width =
+                                       ispmodule_obj.preview_output_width;
+               ispmodule_obj.resizer_input_height =
+                                       ispmodule_obj.preview_output_height;
+               rval = ispresizer_try_size(&ispmodule_obj.resizer_input_width,
+                                       &ispmodule_obj.resizer_input_height,
+                                       &ispmodule_obj.resizer_output_width,
+                                       &ispmodule_obj.resizer_output_height);
+               pix_output->width = ispmodule_obj.resizer_output_width;
+               pix_output->height = ispmodule_obj.resizer_output_height;
+       }
+
+       return rval;
+}
+EXPORT_SYMBOL(isp_try_size);
+
+/**
+ * isp_try_fmt - Validates input/output format parameters.
+ * @pix_input: Pointer to V4L2 pixel format structure for input image.
+ * @pix_output: Pointer to V4L2 pixel format structure for output image.
+ *
+ * Always returns 0.
+ **/
+int isp_try_fmt(struct v4l2_pix_format *pix_input,
+                                       struct v4l2_pix_format *pix_output)
+{
+       int ifmt;
+
+       for (ifmt = 0; ifmt < NUM_ISP_CAPTURE_FORMATS; ifmt++) {
+               if (pix_output->pixelformat == isp_formats[ifmt].pixelformat)
+                       break;
+       }
+       if (ifmt == NUM_ISP_CAPTURE_FORMATS)
+               ifmt = 1;
+       pix_output->pixelformat = isp_formats[ifmt].pixelformat;
+       pix_output->field = V4L2_FIELD_NONE;
+       pix_output->bytesperline = pix_output->width * ISP_BYTES_PER_PIXEL;
+       pix_output->sizeimage =
+               PAGE_ALIGN(pix_output->bytesperline * pix_output->height);
+       pix_output->priv = 0;
+       switch (pix_output->pixelformat) {
+       case V4L2_PIX_FMT_YUYV:
+       case V4L2_PIX_FMT_UYVY:
+               pix_output->colorspace = V4L2_COLORSPACE_JPEG;
+               break;
+       default:
+               pix_output->colorspace = V4L2_COLORSPACE_SRGB;
+               break;
+       }
+
+       ispmodule_obj.pix.pixelformat = pix_output->pixelformat;
+       ispmodule_obj.pix.width = pix_output->width;
+       ispmodule_obj.pix.height = pix_output->height;
+       ispmodule_obj.pix.field = pix_output->field;
+       ispmodule_obj.pix.bytesperline = pix_output->bytesperline;
+       ispmodule_obj.pix.sizeimage = pix_output->sizeimage;
+       ispmodule_obj.pix.priv = pix_output->priv;
+       ispmodule_obj.pix.colorspace = pix_output->colorspace;
+
+       return 0;
+}
+EXPORT_SYMBOL(isp_try_fmt);
+
+/**
+ * isp_save_ctx - Saves ISP, CCDC, HIST, H3A, PREV, RESZ & MMU context.
+ *
+ * Routine for saving the context of each module in the ISP.
+ * CCDC, HIST, H3A, PREV, RESZ and MMU.
+ **/
+void isp_save_ctx(void)
+{
+       isp_save_context(isp_reg_list);
+       ispccdc_save_context();
+       ispmmu_save_context();
+       isphist_save_context();
+       isph3a_save_context();
+       isppreview_save_context();
+       ispresizer_save_context();
+}
+EXPORT_SYMBOL(isp_save_ctx);
+
+/**
+ * isp_restore_ctx - Restores ISP, CCDC, HIST, H3A, PREV, RESZ & MMU context.
+ *
+ * Routine for restoring the context of each module in the ISP.
+ * CCDC, HIST, H3A, PREV, RESZ and MMU.
+ **/
+void isp_restore_ctx(void)
+{
+       isp_restore_context(isp_reg_list);
+       ispccdc_restore_context();
+       ispmmu_restore_context();
+       isphist_restore_context();
+       isph3a_restore_context();
+       isppreview_restore_context();
+       ispresizer_restore_context();
+}
+EXPORT_SYMBOL(isp_restore_ctx);
+
+/**
+ * isp_get - Adquires the ISP resource.
+ *
+ * Initializes the clocks for the first acquire.
+ **/
+int isp_get(void)
+{
+       int ret_err = 0;
+       DPRINTK_ISPCTRL("isp_get: old %d\n", isp_obj.ref_count);
+       mutex_lock(&(isp_obj.isp_mutex));
+       if (isp_obj.ref_count == 0) {
+               isp_obj.cam_ick = clk_get(&camera_dev, "cam_ick");
+               if (IS_ERR(isp_obj.cam_ick)) {
+                       DPRINTK_ISPCTRL("ISP_ERR: clk_get for "
+                                                       "cam_ick failed\n");
+                       ret_err = PTR_ERR(isp_obj.cam_ick);
+                       goto out_clk_get_ick;
+               }
+               isp_obj.cam_mclk = clk_get(&camera_dev, "cam_mclk");
+               if (IS_ERR(isp_obj.cam_mclk)) {
+                       DPRINTK_ISPCTRL("ISP_ERR: clk_get for "
+                                                       "cam_mclk failed\n");
+                       ret_err = PTR_ERR(isp_obj.cam_mclk);
+                       goto out_clk_get_mclk;
+               }
+               ret_err = clk_enable(isp_obj.cam_ick);
+               if (ret_err) {
+                       DPRINTK_ISPCTRL("ISP_ERR: clk_en for ick failed\n");
+                       goto out_clk_enable_ick;
+               }
+               ret_err = clk_enable(isp_obj.cam_mclk);
+               if (ret_err) {
+                       DPRINTK_ISPCTRL("ISP_ERR: clk_en for mclk failed\n");
+                       goto out_clk_enable_mclk;
+               }
+               if (off_mode == 1)
+                       isp_restore_ctx();
+       }
+       isp_obj.ref_count++;
+       mutex_unlock(&(isp_obj.isp_mutex));
+
+
+       DPRINTK_ISPCTRL("isp_get: new %d\n", isp_obj.ref_count);
+       return isp_obj.ref_count;
+
+out_clk_enable_mclk:
+       clk_disable(isp_obj.cam_ick);
+out_clk_enable_ick:
+       clk_put(isp_obj.cam_mclk);
+out_clk_get_mclk:
+       clk_put(isp_obj.cam_ick);
+out_clk_get_ick:
+
+       mutex_unlock(&(isp_obj.isp_mutex));
+
+       return ret_err;
+}
+EXPORT_SYMBOL(isp_get);
+
+/**
+ * isp_put - Releases the ISP resource.
+ *
+ * Releases the clocks also for the last release.
+ **/
+int isp_put(void)
+{
+       DPRINTK_ISPCTRL("isp_put: old %d\n", isp_obj.ref_count);
+       mutex_lock(&(isp_obj.isp_mutex));
+       if (isp_obj.ref_count)
+               if (--isp_obj.ref_count == 0) {
+                       isp_save_ctx();
+                       off_mode = 1;
+
+                       clk_disable(isp_obj.cam_ick);
+                       clk_disable(isp_obj.cam_mclk);
+                       clk_put(isp_obj.cam_ick);
+                       clk_put(isp_obj.cam_mclk);
+               }
+       mutex_unlock(&(isp_obj.isp_mutex));
+       DPRINTK_ISPCTRL("isp_put: new %d\n", isp_obj.ref_count);
+       return isp_obj.ref_count;
+}
+EXPORT_SYMBOL(isp_put);
+
+/**
+ * isp_save_context - Saves the values of the ISP module registers.
+ * @reg_list: Structure containing pairs of register address and value to
+ *            modify on OMAP.
+ **/
+void isp_save_context(struct isp_reg *reg_list)
+{
+       struct isp_reg *next = reg_list;
+
+       for (; next->reg != ISP_TOK_TERM; next++)
+               next->val = omap_readl(next->reg);
+}
+EXPORT_SYMBOL(isp_save_context);
+
+/**
+ * isp_restore_context - Restores the values of the ISP module registers.
+ * @reg_list: Structure containing pairs of register address and value to
+ *            modify on OMAP.
+ **/
+void isp_restore_context(struct isp_reg *reg_list)
+{
+       struct isp_reg *next = reg_list;
+
+       for (; next->reg != ISP_TOK_TERM; next++)
+               omap_writel(next->val, next->reg);
+}
+EXPORT_SYMBOL(isp_restore_context);
+
+/**
+ * isp_init - ISP module initialization.
+ **/
+static int __init isp_init(void)
+{
+       DPRINTK_ISPCTRL("+isp_init for Omap 3430 Camera ISP\n");
+       isp_obj.ref_count = 0;
+
+       mutex_init(&(isp_obj.isp_mutex));
+       spin_lock_init(&isp_obj.isp_temp_buf_lock);
+       spin_lock_init(&isp_obj.lock);
+
+       if (request_irq(INT_34XX_CAM_IRQ, omap34xx_isp_isr, IRQF_SHARED,
+                               "Omap 34xx Camera ISP", &ispirq_obj)) {
+               DPRINTK_ISPCTRL("Could not install ISR\n");
+               return -EINVAL;
+       }
+
+       isp_ccdc_init();
+       isp_hist_init();
+       isph3a_aewb_init();
+       ispmmu_init();
+       isp_preview_init();
+       isp_resizer_init();
+       isp_af_init();
+
+       DPRINTK_ISPCTRL("-isp_init for Omap 3430 Camera ISP\n");
+       return 0;
+}
+EXPORT_SYMBOL(isp_sgdma_init);
+
+/**
+ * isp_cleanup - ISP module cleanup.
+ **/
+static void __exit isp_cleanup(void)
+{
+       isp_af_exit();
+       isp_resizer_cleanup();
+       isp_preview_cleanup();
+       ispmmu_cleanup();
+       isph3a_aewb_cleanup();
+       isp_hist_cleanup();
+       isp_ccdc_cleanup();
+       free_irq(INT_34XX_CAM_IRQ, &ispirq_obj);
+}
+
+/**
+ * isp_print_status - Prints the values of the ISP Control Module registers
+ *
+ * Also prints other debug information stored in the ISP module structure.
+ **/
+void isp_print_status(void)
+{
+       if (!is_ispctrl_debug_enabled())
+               return;
+
+       DPRINTK_ISPCTRL("###CM_FCLKEN_CAM=0x%x\n", omap_readl(CM_FCLKEN_CAM));
+       DPRINTK_ISPCTRL("###CM_ICLKEN_CAM=0x%x\n", omap_readl(CM_ICLKEN_CAM));
+       DPRINTK_ISPCTRL("###CM_CLKSEL_CAM=0x%x\n", omap_readl(CM_CLKSEL_CAM));
+       DPRINTK_ISPCTRL("###CM_AUTOIDLE_CAM=0x%x\n",
+                                               omap_readl(CM_AUTOIDLE_CAM));
+       DPRINTK_ISPCTRL("###CM_CLKEN_PLL[18:16] should be 0x7, = 0x%x\n",
+                                               omap_readl(CM_CLKEN_PLL));
+       DPRINTK_ISPCTRL("###CM_CLKSEL2_PLL[18:8] should be 0x2D, [6:0] should "
+                               "be 1 = 0x%x\n", omap_readl(CM_CLKSEL2_PLL));
+       DPRINTK_ISPCTRL("###CTRL_PADCONF_CAM_HS=0x%x\n",
+                                       omap_readl(CTRL_PADCONF_CAM_HS));
+       DPRINTK_ISPCTRL("###CTRL_PADCONF_CAM_XCLKA=0x%x\n",
+                                       omap_readl(CTRL_PADCONF_CAM_XCLKA));
+       DPRINTK_ISPCTRL("###CTRL_PADCONF_CAM_D1=0x%x\n",
+                                       omap_readl(CTRL_PADCONF_CAM_D1));
+       DPRINTK_ISPCTRL("###CTRL_PADCONF_CAM_D3=0x%x\n",
+                                       omap_readl(CTRL_PADCONF_CAM_D3));
+       DPRINTK_ISPCTRL("###CTRL_PADCONF_CAM_D5=0x%x\n",
+                                       omap_readl(CTRL_PADCONF_CAM_D5));
+       DPRINTK_ISPCTRL("###CTRL_PADCONF_CAM_D7=0x%x\n",
+                                       omap_readl(CTRL_PADCONF_CAM_D7));
+       DPRINTK_ISPCTRL("###CTRL_PADCONF_CAM_D9=0x%x\n",
+                                       omap_readl(CTRL_PADCONF_CAM_D9));
+       DPRINTK_ISPCTRL("###CTRL_PADCONF_CAM_D11=0x%x\n",
+                                       omap_readl(CTRL_PADCONF_CAM_D11));
+}
+EXPORT_SYMBOL(isp_print_status);
+
+module_init(isp_init);
+module_exit(isp_cleanup);
+
+MODULE_AUTHOR("Texas Instruments");
+MODULE_DESCRIPTION("ISP Control Module Library");
+MODULE_LICENSE("GPL");
Index: linux-omap-2.6/drivers/media/video/isp/isp.h
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/isp/isp.h        2008-08-28 19:08:43.000000000 -0500
@@ -0,0 +1,348 @@
+/*
+ * drivers/media/video/isp/isp.h
+ *
+ * Top level public header file for ISP Control module in
+ * TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ * Copyright (C) 2008 Nokia.
+ *
+ * Contributors:
+ *     Sameer Venkatraman <sameerv@ti.com>
+ *     Mohit Jalori <mjalori@ti.com>
+ *     Sakari Ailus <sakari.ailus@nokia.com>
+ *     Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#ifndef OMAP_ISP_TOP_H
+#define OMAP_ISP_TOP_H
+#include <media/videobuf-dma-sg.h>
+#include <linux/videodev2.h>
+#define OMAP_ISP_CCDC          (1 << 0)
+#define OMAP_ISP_PREVIEW       (1 << 1)
+#define OMAP_ISP_RESIZER       (1 << 2)
+#define OMAP_ISP_AEWB          (1 << 3)
+#define OMAP_ISP_AF            (1 << 4)
+#define OMAP_ISP_HIST          (1 << 5)
+
+/* Our ISP specific controls */
+#define V4L2_CID_PRIVATE_ISP_COLOR_FX          (V4L2_CID_PRIVATE_BASE + 0)
+
+/* ISP Private IOCTLs */
+#define VIDIOC_PRIVATE_ISP_CCDC_CFG    \
+       _IOWR('V', BASE_VIDIOC_PRIVATE + 1, struct ispccdc_update_config)
+#define VIDIOC_PRIVATE_ISP_PRV_CFG \
+       _IOWR('V', BASE_VIDIOC_PRIVATE + 2, struct ispprv_update_config)
+#define VIDIOC_PRIVATE_ISP_AEWB_CFG \
+       _IOWR('V', BASE_VIDIOC_PRIVATE + 4, struct isph3a_aewb_config)
+#define VIDIOC_PRIVATE_ISP_AEWB_REQ \
+       _IOWR('V', BASE_VIDIOC_PRIVATE + 5, struct isph3a_aewb_data)
+#define VIDIOC_PRIVATE_ISP_HIST_CFG \
+       _IOWR('V', BASE_VIDIOC_PRIVATE + 6, struct isp_hist_config)
+#define VIDIOC_PRIVATE_ISP_HIST_REQ \
+       _IOWR('V', BASE_VIDIOC_PRIVATE + 7, struct isp_hist_data)
+#define VIDIOC_PRIVATE_ISP_AF_CFG \
+       _IOWR('V', BASE_VIDIOC_PRIVATE + 8, struct af_configuration)
+#define VIDIOC_PRIVATE_ISP_AF_REQ \
+       _IOWR('V', BASE_VIDIOC_PRIVATE + 9, struct isp_af_data)
+
+#define ISP_TOK_TERM           0xFFFFFFFF      /*
+                                                * terminating token for ISP
+                                                * modules reg list
+                                                */
+#define NUM_SG_DMA             (VIDEO_MAX_FRAME + 2)
+
+#define ISP_BUF_INIT           0
+#define ISP_FREE_RUNNING       1
+#define ISP_BUF_TRAN           2
+
+#ifndef CONFIG_ARCH_OMAP3410
+#define USE_ISP_PREVIEW
+#define USE_ISP_RESZ
+#define is_isppreview_enabled()                1
+#define is_ispresizer_enabled()                1
+#else
+#define is_isppreview_enabled()                0
+#define is_ispresizer_enabled()                0
+#endif
+
+#ifdef OMAP_ISPCTRL_DEBUG
+#define is_ispctrl_debug_enabled()             1
+#else
+#define is_ispctrl_debug_enabled()             0
+#endif
+
+#define ISP_XCLKA_DEFAULT              0x12
+#define ISP_OUTPUT_WIDTH_DEFAULT       176
+#define ISP_OUTPUT_HEIGHT_DEFAULT      144
+#define ISP_BYTES_PER_PIXEL            2
+#define NUM_ISP_CAPTURE_FORMATS        (sizeof(isp_formats) /\
+                                                       sizeof(isp_formats[0]))
+
+typedef int (*isp_vbq_callback_ptr) (struct videobuf_buffer *vb);
+typedef void (*isp_callback_t) (unsigned long status,
+                                       isp_vbq_callback_ptr arg1, void *arg2);
+
+enum isp_interface_type {
+       ISP_PARLL = 1,
+       ISP_CSIA = 2,
+       ISP_CSIB = 4
+};
+
+enum isp_irqevents {
+       CCDC_VD0 = 0x100,
+       CCDC_VD1 = 0x200,
+       CCDC_VD2 = 0x400,
+       CCDC_ERR = 0x800,
+       H3A_AWB_DONE = 0x2000,
+       H3A_AF_DONE = 0x1000,
+       HIST_DONE = 0x10000,
+       PREV_DONE = 0x100000,
+       LSC_DONE = 0x20000,
+       LSC_PRE_COMP = 0x40000,
+       LSC_PRE_ERR = 0x80000,
+       RESZ_DONE = 0x1000000,
+       SBL_OVF = 0x2000000,
+       MMU_ERR = 0x10000000,
+       OCP_ERR = 0x20000000,
+       HS_VS = 0x80000000
+};
+
+enum isp_callback_type {
+       CBK_CCDC_VD0,
+       CBK_CCDC_VD1,
+       CBK_PREV_DONE,
+       CBK_RESZ_DONE,
+       CBK_MMU_ERR,
+       CBK_H3A_AWB_DONE,
+       CBK_HIST_DONE,
+       CBK_HS_VS,
+       CBK_LSC_ISR,
+       CBK_H3A_AF_DONE,
+       CBK_CATCHALL,
+       CBK_END,
+};
+
+/**
+ * struct isp_reg - Structure for ISP register values.
+ * @reg: 32-bit Register address.
+ * @val: 32-bit Register value.
+ */
+struct isp_reg {
+       u32 reg;
+       u32 val;
+};
+
+/**
+ * struct isp_sgdma_state - SG-DMA state for each videobuffer + 2 overlays
+ * @isp_addr: ISP space address mapped by ISP MMU.
+ * @status: DMA return code mapped by ISP MMU.
+ * @callback: Pointer to ISP callback function.
+ * @arg: Pointer to argument passed to the specified callback function.
+ */
+struct isp_sgdma_state {
+       dma_addr_t isp_addr;
+       u32 status;
+       isp_callback_t callback;
+       void *arg;
+};
+
+/**
+ * struct isp_sgdma - ISP Scatter Gather DMA status.
+ * @isp_addr_capture: Array of ISP space addresses mapped by the ISP MMU.
+ * @lock: Spinlock used to check free_sgdma field.
+ * @free_sgdma: Number of free SG-DMA slots.
+ * @next_sgdma: Index of next SG-DMA slot to use.
+ */
+struct isp_sgdma {
+       dma_addr_t isp_addr_capture[VIDEO_MAX_FRAME];
+       spinlock_t lock;        /* For handling current buffer */
+       int free_sgdma;
+       int next_sgdma;
+       struct isp_sgdma_state sg_state[NUM_SG_DMA];
+};
+
+/**
+ * struct isp_interface_config - ISP interface configuration.
+ * @ccdc_par_ser: ISP interface type. 0 - Parallel, 1 - CSIA, 2 - CSIB to CCDC.
+ * @par_bridge: CCDC Bridge input control. Parallel interface.
+ *                  0 - Disable, 1 - Enable, first byte->cam_d(bits 7 to 0)
+ *                  2 - Enable, first byte -> cam_d(bits 15 to 8)
+ * @par_clk_pol: Pixel clock polarity on the parallel interface.
+ *                    0 - Non Inverted, 1 - Inverted
+ * @dataline_shift: Data lane shifter.
+ *                      0 - No Shift, 1 - CAMEXT[13 to 2]->CAM[11 to 0]
+ *                      2 - CAMEXT[13 to 4]->CAM[9 to 0]
+ *                      3 - CAMEXT[13 to 6]->CAM[7 to 0]
+ * @hsvs_syncdetect: HS or VS synchronization signal detection.
+ *                       0 - HS Falling, 1 - HS rising
+ *                       2 - VS falling, 3 - VS rising
+ * @vdint0_timing: VD0 Interrupt timing.
+ * @vdint1_timing: VD1 Interrupt timing.
+ * @strobe: Strobe related parameter.
+ * @prestrobe: PreStrobe related parameter.
+ * @shutter: Shutter related parameter.
+ */
+struct isp_interface_config {
+       enum isp_interface_type ccdc_par_ser;
+       u8 dataline_shift;
+       u32 hsvs_syncdetect;
+       u16 vdint0_timing;
+       u16 vdint1_timing;
+       int strobe;
+       int prestrobe;
+       int shutter;
+       union {
+               struct par {
+                       unsigned par_bridge:2;
+                       unsigned par_clk_pol:1;
+               } par;
+               struct csi {
+                       unsigned crc:1;
+                       unsigned mode:1;
+                       unsigned edge:1;
+                       unsigned signalling:1;
+                       unsigned strobe_clock_inv:1;
+                       unsigned vs_edge:1;
+                       unsigned channel:3;
+                       unsigned vpclk:2;       /* Video port output clock */
+                       unsigned int data_start;
+                       unsigned int data_size;
+                       u32 format;             /* V4L2_PIX_FMT_* */
+               } csi;
+       } u;
+};
+
+/**
+ * struct isp_sysc - ISP Power switches to set.
+ * @reset: Flag for setting ISP reset.
+ * @idle_mode: Flag for setting ISP idle mode.
+ */
+struct isp_sysc {
+       char reset;
+       char idle_mode;
+};
+
+void isp_open(void);
+
+void isp_close(void);
+
+void isp_start(void);
+
+void isp_stop(void);
+
+void isp_sgdma_init(void);
+
+void isp_vbq_done(unsigned long status, isp_vbq_callback_ptr arg1, void *arg2);
+
+void isp_sgdma_process(struct isp_sgdma *sgdma, int irq, int *dma_notify,
+                                               isp_vbq_callback_ptr func_ptr);
+
+int isp_sgdma_queue(struct videobuf_dmabuf *vdma, struct videobuf_buffer *vb,
+                                               int irq, int *dma_notify,
+                                               isp_vbq_callback_ptr func_ptr);
+
+int isp_vbq_prepare(struct videobuf_queue *vbq, struct videobuf_buffer *vb,
+                                                       enum v4l2_field field);
+
+void isp_vbq_release(struct videobuf_queue *vbq, struct videobuf_buffer *vb);
+
+int isp_set_callback(enum isp_callback_type type, isp_callback_t callback,
+                                       isp_vbq_callback_ptr arg1, void *arg2);
+
+void omapisp_unset_callback(void);
+
+int isp_unset_callback(enum isp_callback_type type);
+
+u32 isp_set_xclk(u32 xclk, u8 xclksel);
+
+u32 isp_get_xclk(u8 xclksel);
+
+int isp_request_interface(enum isp_interface_type if_t);
+
+int isp_free_interface(enum isp_interface_type if_t);
+
+void isp_power_settings(struct isp_sysc);
+
+int isp_configure_interface(struct isp_interface_config *config);
+
+void isp_CCDC_VD01_disable(void);
+
+void isp_CCDC_VD01_enable(void);
+
+int isp_get(void);
+
+int isp_put(void);
+
+void isp_set_pipeline(int soc_type);
+
+void isp_config_pipeline(struct v4l2_pix_format *pix_input,
+                                       struct v4l2_pix_format *pix_output);
+
+int isp_queryctrl(struct v4l2_queryctrl *a);
+
+int isp_g_ctrl(struct v4l2_control *a);
+
+int isp_s_ctrl(struct v4l2_control *a);
+
+int isp_enum_fmt_cap(struct v4l2_fmtdesc *f);
+
+int isp_try_fmt_cap(struct v4l2_pix_format *pix_input,
+                                       struct v4l2_pix_format *pix_output);
+
+void isp_g_fmt_cap(struct v4l2_pix_format *pix);
+
+int isp_s_fmt_cap(struct v4l2_pix_format *pix_input,
+                                       struct v4l2_pix_format *pix_output);
+
+int isp_g_crop(struct v4l2_crop *a);
+
+int isp_s_crop(struct v4l2_crop *a, struct v4l2_pix_format *pix);
+
+void isp_config_crop(struct v4l2_pix_format *pix);
+
+int isp_try_size(struct v4l2_pix_format *pix_input,
+                                       struct v4l2_pix_format *pix_output);
+
+int isp_try_fmt(struct v4l2_pix_format *pix_input,
+                                       struct v4l2_pix_format *pix_output);
+
+int isp_handle_private(int cmd, void *arg);
+
+void isp_save_context(struct isp_reg *);
+
+void isp_restore_context(struct isp_reg *);
+
+void isp_save_ctx(void);
+
+void isp_restore_ctx(void);
+
+void isp_print_status(void);
+
+
+int __init isp_ccdc_init(void);
+int __init isp_hist_init(void);
+int __init isph3a_aewb_init(void);
+int __init ispmmu_init(void);
+int __init isp_preview_init(void);
+int __init isp_resizer_init(void);
+int __init isp_af_init(void);
+
+void __exit isp_ccdc_cleanup(void);
+void __exit isp_hist_cleanup(void);
+void __exit isph3a_aewb_cleanup(void);
+void __exit ispmmu_cleanup(void);
+void __exit isp_preview_cleanup(void);
+void __exit isp_hist_cleanup(void);
+void __exit isp_resizer_cleanup(void);
+void __exit isp_af_exit(void);
+
+#endif /* OMAP_ISP_TOP_H */
Index: linux-omap-2.6/drivers/media/video/isp/isp_af.c
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/isp/isp_af.c     2008-08-28 19:08:43.000000000 -0500
@@ -0,0 +1,812 @@
+/*
+ * drivers/media/video/isp/isp_af.c
+ *
+ * AF module for TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+/* Linux specific include files */
+#include <linux/cdev.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <asm/cacheflush.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+
+#include <linux/mman.h>
+#include <linux/syscalls.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/dma-mapping.h>
+
+#include <media/v4l2-int-device.h>
+#include "isp.h"
+#include "ispreg.h"
+#include "isph3a.h"
+#include "isp_af.h"
+#include "ispmmu.h"
+
+/**
+ * struct isp_af_buffer - AF frame stats buffer.
+ * @virt_addr: Virtual address to mmap the buffer.
+ * @phy_addr: Physical address of the buffer.
+ * @addr_align: Virtual Address 32 bytes aligned.
+ * @ispmmu_addr: Address of the buffer mapped by the ISPMMU.
+ * @mmap_addr: Mapped memory area of buffer. For userspace access.
+ * @locked: 1 - Buffer locked from write. 0 - Buffer can be overwritten.
+ * @frame_num: Frame number from which the statistics are taken.
+ * @lens_position: Lens position currently set in the DW9710 Coil motor driver.
+ * @next: Pointer to link next buffer.
+ */
+struct isp_af_buffer {
+       unsigned long virt_addr;
+       unsigned long phy_addr;
+       unsigned long addr_align;
+       unsigned long ispmmu_addr;
+       unsigned long mmap_addr;
+
+       u8 locked;
+       u16 frame_num;
+       struct isp_af_xtrastats xtrastats;
+       struct isp_af_buffer *next;
+};
+
+/**
+ * struct isp_af_status - AF status.
+ * @initialized: 1 - Buffers initialized.
+ * @update: 1 - Update registers.
+ * @stats_req: 1 - Future stats requested.
+ * @stats_done: 1 - Stats ready for user.
+ * @frame_req: Number of frame requested for statistics.
+ * @af_buff: Array of statistics buffers to access.
+ * @stats_buf_size: Statistics buffer size.
+ * @min_buf_size: Minimum statisitics buffer size.
+ * @frame_count: Frame Count.
+ * @stats_wait: Wait primitive for locking/unlocking the stats request.
+ * @buffer_lock: Spinlock for statistics buffers access.
+ */
+static struct isp_af_status {
+       u8 initialized;
+       u8 update;
+       u8 stats_req;
+       u8 stats_done;
+       u16 frame_req;
+
+       struct isp_af_buffer af_buff[H3A_MAX_BUFF];
+       unsigned int stats_buf_size;
+       unsigned int min_buf_size;
+
+       u32 frame_count;
+       wait_queue_head_t stats_wait;
+       spinlock_t buffer_lock;         /* For stats buffers read/write sync */
+} afstat;
+
+struct af_device *af_dev_configptr;
+static struct isp_af_buffer *active_buff;
+static int af_major = -1;
+static int camnotify;
+
+
+/**
+ * isp_af_setxtrastats - Receives extra statistics from prior frames.
+ * @xtrastats: Pointer to structure containing extra statistics fields like
+ *             field count and timestamp of frame.
+ *
+ * Called from update_vbq in camera driver
+ **/
+void isp_af_setxtrastats(struct isp_af_xtrastats *xtrastats, u8 updateflag)
+{
+       int i, past_i;
+
+       if (active_buff == NULL)
+               return;
+
+       for (i = 0; i < H3A_MAX_BUFF; i++) {
+               if (afstat.af_buff[i].frame_num == active_buff->frame_num)
+                       break;
+       }
+
+       if (i == H3A_MAX_BUFF)
+               return;
+
+       if (i == 0) {
+               if (afstat.af_buff[H3A_MAX_BUFF - 1].locked == 0)
+                       past_i = H3A_MAX_BUFF - 1;
+               else
+                       past_i = H3A_MAX_BUFF - 2;
+       } else if (i == 1) {
+               if (afstat.af_buff[0].locked == 0)
+                       past_i = 0;
+               else
+                       past_i = H3A_MAX_BUFF - 1;
+       } else {
+               if (afstat.af_buff[i - 1].locked == 0)
+                       past_i = i - 1;
+               else
+                       past_i = i - 2;
+       }
+
+       if (updateflag & AF_UPDATEXS_TS)
+               afstat.af_buff[past_i].xtrastats.ts = xtrastats->ts;
+
+       if (updateflag & AF_UPDATEXS_FIELDCOUNT)
+               afstat.af_buff[past_i].xtrastats.field_count =
+                                                       xtrastats->field_count;
+}
+EXPORT_SYMBOL(isp_af_setxtrastats);
+
+/*
+ * Helper function to update buffer cache pages
+ */
+static void isp_af_update_req_buffer(struct isp_af_buffer *buffer)
+{
+       int size = afstat.stats_buf_size;
+
+       size = PAGE_ALIGN(size);
+       /* Update the kernel pages of the requested buffer */
+       dmac_inv_range((void *)buffer->addr_align, (void *)buffer->addr_align +
+                                                                       size);
+}
+
+/* Function to check paxel parameters */
+int isp_af_check_paxel(void)
+{
+       /* Check horizontal Count */
+       if ((af_dev_configptr->config->paxel_config.hz_cnt
+            < AF_PAXEL_HORIZONTAL_COUNT_MIN)
+           || (af_dev_configptr->config->paxel_config.hz_cnt
+               > AF_PAXEL_HORIZONTAL_COUNT_MAX)) {
+               DPRINTK_ISPH3A("Error : Horizontal Count is incorrect");
+               return -AF_ERR_HZ_COUNT;
+       }
+
+       /*Check Vertical Count */
+       if ((af_dev_configptr->config->paxel_config.vt_cnt
+            < AF_PAXEL_VERTICAL_COUNT_MIN)
+           || (af_dev_configptr->config->paxel_config.vt_cnt
+               > AF_PAXEL_VERTICAL_COUNT_MAX)) {
+               DPRINTK_ISPH3A("Error : Vertical Count is incorrect");
+               return -AF_ERR_VT_COUNT;
+       }
+
+       /*Check Height */
+       if ((af_dev_configptr->config->paxel_config.height
+            < AF_PAXEL_HEIGHT_MIN)
+           || (af_dev_configptr->config->paxel_config.height
+               > AF_PAXEL_HEIGHT_MAX)) {
+               DPRINTK_ISPH3A("Error : Height is incorrect");
+               return -AF_ERR_HEIGHT;
+       }
+
+       /*Check width */
+       if ((af_dev_configptr->config->paxel_config.width < AF_PAXEL_WIDTH_MIN)
+           || (af_dev_configptr->config->paxel_config.width
+               > AF_PAXEL_WIDTH_MAX)) {
+               DPRINTK_ISPH3A("Error : Width is incorrect");
+               return -AF_ERR_WIDTH;
+       }
+
+       /*Check Line Increment */
+       if ((af_dev_configptr->config->paxel_config.line_incr
+            < AF_PAXEL_INCREMENT_MIN)
+           || (af_dev_configptr->config->paxel_config.line_incr
+               > AF_PAXEL_INCREMENT_MAX)) {
+               DPRINTK_ISPH3A("Error : Line Increment is incorrect");
+               return -AF_ERR_INCR;
+       }
+
+       /*Check Horizontal Start */
+       if ((af_dev_configptr->config->paxel_config.hz_start % 2 != 0)
+           || (af_dev_configptr->config->paxel_config.hz_start
+               < (af_dev_configptr->config->iir_config.hz_start_pos + 2))
+           || (af_dev_configptr->config->paxel_config.hz_start
+               > AF_PAXEL_HZSTART_MAX)
+           || (af_dev_configptr->config->paxel_config.hz_start
+               < AF_PAXEL_HZSTART_MIN)) {
+               DPRINTK_ISPH3A("Error : Horizontal Start is incorrect");
+               return -AF_ERR_HZ_START;
+       }
+
+       /*Check Vertical Start */
+       if ((af_dev_configptr->config->paxel_config.vt_start
+            < AF_PAXEL_VTSTART_MIN)
+           || (af_dev_configptr->config->paxel_config.vt_start
+               > AF_PAXEL_VTSTART_MAX)) {
+               DPRINTK_ISPH3A("Error : Vertical Start is incorrect");
+               return -AF_ERR_VT_START;
+       }
+       return 0;               /*Success */
+}
+
+/**
+ * isp_af_check_iir - Function to check IIR Coefficient.
+ **/
+int isp_af_check_iir(void)
+{
+       int index;
+
+       for (index = 0; index < AF_NUMBER_OF_COEF; index++) {
+               if ((af_dev_configptr->config->iir_config.coeff_set0[index])
+                   > AF_COEF_MAX) {
+                       DPRINTK_ISPH3A(
+                               "Error : Coefficient for set 0 is incorrect");
+                       return -AF_ERR_IIR_COEF;
+               }
+
+               if ((af_dev_configptr->config->iir_config.coeff_set1[index])
+                   > AF_COEF_MAX) {
+                       DPRINTK_ISPH3A(
+                               "Error : Coefficient for set 1 is incorrect");
+                       return -AF_ERR_IIR_COEF;
+               }
+       }
+
+       if ((af_dev_configptr->config->iir_config.hz_start_pos < AF_IIRSH_MIN)
+           || (af_dev_configptr->config->iir_config.hz_start_pos >
+               AF_IIRSH_MAX)) {
+               DPRINTK_ISPH3A("Error : IIRSH is incorrect");
+               return -AF_ERR_IIRSH;
+       }
+
+       return 0;
+}
+/**
+ * isp_af_unlock_buffers - Helper function to unlock all buffers.
+ **/
+static void isp_af_unlock_buffers(void)
+{
+       int i;
+       unsigned long irqflags;
+
+       spin_lock_irqsave(&afstat.buffer_lock, irqflags);
+       for (i = 0; i < H3A_MAX_BUFF; i++)
+               afstat.af_buff[i].locked = 0;
+
+       spin_unlock_irqrestore(&afstat.buffer_lock, irqflags);
+}
+
+/*
+ * Helper function to link allocated buffers
+ */
+static void isp_af_link_buffers(void)
+{
+       int i;
+
+       for (i = 0; i < H3A_MAX_BUFF; i++) {
+               if ((i + 1) < H3A_MAX_BUFF)
+                       afstat.af_buff[i].next = &afstat.af_buff[i + 1];
+               else
+                       afstat.af_buff[i].next = &afstat.af_buff[0];
+       }
+}
+
+/*
+ * Helper function to munmap kernel buffers from user space.
+ */
+static int isp_af_munmap(struct isp_af_buffer *buffer)
+{
+       /* TO DO: munmap succesfully the kernel buffers, so they can be
+          remmaped again */
+       buffer->mmap_addr = 0;
+       return 0;
+}
+
+/*
+ * Helper function to mmap buffers to user space.
+ * buffer passed need to already have a valid physical address: buffer->phy_addr
+ * It returns user pointer as unsigned long in buffer->mmap_addr
+ */
+static int isp_af_mmap_buffers(struct isp_af_buffer *buffer)
+{
+       struct vm_area_struct vma;
+       struct mm_struct *mm = current->mm;
+       int size = afstat.stats_buf_size;
+       unsigned long addr = 0;
+       unsigned long pgoff = 0, flags = MAP_SHARED | MAP_ANONYMOUS;
+       unsigned long prot = PROT_READ | PROT_WRITE;
+       void *pos = (void *)buffer->addr_align;
+
+       size = PAGE_ALIGN(size);
+
+       addr = get_unmapped_area(NULL, addr, size, pgoff, flags);
+       vma.vm_mm = mm;
+       vma.vm_start = addr;
+       vma.vm_end = addr + size;
+       vma.vm_flags = calc_vm_prot_bits(prot) | calc_vm_flag_bits(flags);
+       vma.vm_pgoff = pgoff;
+       vma.vm_file = NULL;
+       vma.vm_page_prot = vm_get_page_prot(vma.vm_flags);
+
+       while (size > 0) {
+               if (vm_insert_page(&vma, addr, vmalloc_to_page(pos)))
+                       return -EAGAIN;
+               addr += PAGE_SIZE;
+               pos += PAGE_SIZE;
+               size -= PAGE_SIZE;
+       }
+
+       buffer->mmap_addr = vma.vm_start;
+       return 0;
+}
+
+/* Function to perform hardware set up */
+int isp_af_configure(struct af_configuration *afconfig)
+{
+       int result;
+       int buff_size, i;
+       unsigned int busyaf;
+
+       if (NULL == afconfig) {
+               printk(KERN_ERR "Null argument in configuration. \n");
+               return -EINVAL;
+       }
+
+       af_dev_configptr->config = afconfig;
+       /* Get the value of PCR register */
+       busyaf = omap_readl(ISPH3A_PCR);
+
+       if ((busyaf & AF_BUSYAF) == AF_BUSYAF) {
+               DPRINTK_ISPH3A("AF_register_setup_ERROR : Engine Busy");
+               DPRINTK_ISPH3A("\n Configuration cannot be done ");
+               return -AF_ERR_ENGINE_BUSY;
+       }
+
+       /*Check IIR Coefficient and start Values */
+       result = isp_af_check_iir();
+       if (result < 0)
+               return result;
+
+       /*Check Paxel Values */
+       result = isp_af_check_paxel();
+       if (result < 0)
+               return result;
+
+       /*Check HMF Threshold Values */
+       if (af_dev_configptr->config->hmf_config.threshold > AF_THRESHOLD_MAX) {
+               DPRINTK_ISPH3A("Error : HMF Threshold is incorrect");
+               return -AF_ERR_THRESHOLD;
+       }
+
+       /* Compute buffer size */
+       buff_size =
+           (af_dev_configptr->config->paxel_config.hz_cnt + 1) *
+           (af_dev_configptr->config->paxel_config.vt_cnt + 1) * AF_PAXEL_SIZE;
+
+       /*Deallocate the previous buffers */
+       if (afstat.stats_buf_size && (buff_size > afstat.stats_buf_size)) {
+               isp_af_enable(0);
+               for (i = 0; i < H3A_MAX_BUFF; i++) {
+                       isp_af_munmap(&afstat.af_buff[i]);
+                       ispmmu_unmap(afstat.af_buff[i].ispmmu_addr);
+                       dma_free_coherent(NULL,
+                                 afstat.min_buf_size + 64,
+                                 (void *)afstat.af_buff[i].virt_addr,
+                                 (dma_addr_t)afstat.af_buff[i].phy_addr);
+                       afstat.af_buff[i].virt_addr = 0;
+               }
+               afstat.stats_buf_size = 0;
+       }
+
+       if (!afstat.af_buff[0].virt_addr) {
+               afstat.stats_buf_size = buff_size;
+               afstat.min_buf_size = PAGE_ALIGN(afstat.stats_buf_size);
+
+               for (i = 0; i < H3A_MAX_BUFF; i++) {
+                       afstat.af_buff[i].virt_addr =
+                               (unsigned long)dma_alloc_coherent(NULL,
+                                               afstat.min_buf_size,
+                                               (dma_addr_t *)
+                                                &afstat.af_buff[i].phy_addr,
+                                               GFP_KERNEL | GFP_DMA);
+                       if (afstat.af_buff[i].virt_addr == 0) {
+                               printk(KERN_ERR "Can't acquire memory for "
+                                       "buffer[%d]\n", i);
+                               return -ENOMEM;
+                       }
+                       afstat.af_buff[i].addr_align =
+                                       afstat.af_buff[i].virt_addr;
+                       while ((afstat.af_buff[i].addr_align & 0xFFFFFFC0) !=
+                                      afstat.af_buff[i].addr_align)
+                               afstat.af_buff[i].addr_align++;
+                       afstat.af_buff[i].ispmmu_addr =
+                               ispmmu_map(afstat.af_buff[i].phy_addr,
+                                          afstat.min_buf_size);
+               }
+               isp_af_unlock_buffers();
+               isp_af_link_buffers();
+
+               /* First active buffer */
+               if (active_buff == NULL)
+                       active_buff = &afstat.af_buff[0];
+               isp_af_set_address(active_buff->ispmmu_addr);
+       }
+       /* Always remap when calling Configure */
+       for (i = 0; i < H3A_MAX_BUFF; i++) {
+               if (afstat.af_buff[i].mmap_addr)
+                       isp_af_munmap(&afstat.af_buff[i]);
+               isp_af_mmap_buffers(&afstat.af_buff[i]);
+       }
+
+       result = isp_af_register_setup(af_dev_configptr);
+       if (result < 0)
+               return result;
+       af_dev_configptr->size_paxel = buff_size;
+       afstat.initialized = 1;
+       /*Set configuration flag to indicate HW setup done */
+       if (af_dev_configptr->config->af_config)
+               isp_af_enable(1);
+       else
+               isp_af_enable(0);
+
+       /*Success */
+       return 0;
+}
+EXPORT_SYMBOL(isp_af_configure);
+
+int isp_af_register_setup(struct af_device *af_dev)
+{
+       unsigned int pcr = 0, pax1 = 0, pax2 = 0, paxstart = 0;
+       unsigned int coef = 0;
+       unsigned int base_coef_set0 = 0;
+       unsigned int base_coef_set1 = 0;
+       int index;
+
+
+       /* Configure Hardware Registers */
+       /* Set PCR Register */
+       pcr = omap_readl(ISPH3A_PCR);   /* Read PCR Register */
+
+       /*Set Accumulator Mode */
+       if (af_dev->config->mode == ACCUMULATOR_PEAK)
+               pcr |= FVMODE;
+       else
+               pcr &= ~FVMODE;
+
+       /*Set A-law */
+       if (af_dev->config->alaw_enable == H3A_AF_ALAW_ENABLE)
+               pcr |= AF_ALAW_EN;
+       else
+               pcr &= ~AF_ALAW_EN;
+
+       /*Set RGB Position */
+       pcr &= ~RGBPOS;
+       pcr |= (af_dev->config->rgb_pos) << AF_RGBPOS_SHIFT;
+
+       /*HMF Configurations */
+       if (af_dev->config->hmf_config.enable == H3A_AF_HMF_ENABLE) {
+               pcr &= ~AF_MED_EN;
+               /* Enable HMF */
+               pcr |= AF_MED_EN;
+
+               /* Set Median Threshold */
+               pcr &= ~MED_TH;
+               pcr |=
+                   (af_dev->config->hmf_config.threshold) << AF_MED_TH_SHIFT;
+       } else
+               pcr &= ~AF_MED_EN;
+
+       omap_writel(pcr, ISPH3A_PCR);
+
+       pax1 &= ~PAXW;
+       pax1 |= (af_dev->config->paxel_config.width) << AF_PAXW_SHIFT;
+
+       /* Set height in AFPAX1 */
+       pax1 &= ~PAXH;
+       pax1 |= af_dev->config->paxel_config.height;
+
+       omap_writel(pax1, ISPH3A_AFPAX1);
+
+       /* Configure AFPAX2 Register */
+       /* Set Line Increment in AFPAX2 Register */
+       pax2 &= ~AFINCV;
+       pax2 |= (af_dev->config->paxel_config.line_incr) << AF_LINE_INCR_SHIFT;
+       /* Set Vertical Count */
+       pax2 &= ~PAXVC;
+       pax2 |= (af_dev->config->paxel_config.vt_cnt) << AF_VT_COUNT_SHIFT;
+       /* Set Horizontal Count */
+       pax2 &= ~PAXHC;
+       pax2 |= af_dev->config->paxel_config.hz_cnt;
+       omap_writel(pax2, ISPH3A_AFPAX2);
+
+       /* Configure PAXSTART Register */
+       /*Configure Horizontal Start */
+       paxstart &= ~PAXSH;
+       paxstart |=
+           (af_dev->config->paxel_config.hz_start) << AF_HZ_START_SHIFT;
+       /* Configure Vertical Start */
+       paxstart &= ~PAXSV;
+       paxstart |= af_dev->config->paxel_config.vt_start;
+       omap_writel(paxstart, ISPH3A_AFPAXSTART);
+
+       /*SetIIRSH Register */
+       omap_writel(af_dev->config->iir_config.hz_start_pos, ISPH3A_AFIIRSH);
+
+       /*Set IIR Filter0 Coefficients */
+       base_coef_set0 = ISPH3A_AFCOEF010;
+       for (index = 0; index <= 8; index += 2) {
+               coef &= ~COEF_MASK0;
+               coef |= af_dev->config->iir_config.coeff_set0[index];
+               coef &= ~COEF_MASK1;
+               coef |=
+                   (af_dev->config->iir_config.
+                    coeff_set0[index + 1]) << AF_COEF_SHIFT;
+               omap_writel(coef, base_coef_set0);
+
+               base_coef_set0 = base_coef_set0 + AFCOEF_OFFSET;
+       }
+
+       /* set AFCOEF0010 Register */
+       omap_writel(af_dev->config->iir_config.coeff_set0[10],
+                                                       ISPH3A_AFCOEF010);
+
+       /*Set IIR Filter1 Coefficients */
+
+       base_coef_set1 = ISPH3A_AFCOEF110;
+       for (index = 0; index <= 8; index += 2) {
+               coef &= ~COEF_MASK0;
+               coef |= af_dev->config->iir_config.coeff_set1[index];
+               coef &= ~COEF_MASK1;
+               coef |=
+                   (af_dev->config->iir_config.
+                    coeff_set1[index + 1]) << AF_COEF_SHIFT;
+               omap_writel(coef, base_coef_set1);
+
+               base_coef_set1 = base_coef_set1 + AFCOEF_OFFSET;
+       }
+       omap_writel(af_dev->config->iir_config.coeff_set1[10],
+                                                       ISPH3A_AFCOEF1010);
+
+       return 0;
+}
+
+/* Function to set address */
+void isp_af_set_address(unsigned long address)
+{
+       omap_writel(address, ISPH3A_AFBUFST);
+}
+
+static int isp_af_stats_available(struct isp_af_data *afdata)
+{
+       int i;
+       unsigned long irqflags;
+
+       spin_lock_irqsave(&afstat.buffer_lock, irqflags);
+       for (i = 0; i < H3A_MAX_BUFF; i++) {
+               if ((afdata->frame_number == afstat.af_buff[i].frame_num)
+                       && (afstat.af_buff[i].frame_num !=
+                               active_buff->frame_num)) {
+                       afstat.af_buff[i].locked = 1;
+                       spin_unlock_irqrestore(&afstat.buffer_lock, irqflags);
+                       isp_af_update_req_buffer(&afstat.af_buff[i]);
+                       afstat.af_buff[i].frame_num = 0;
+                       afdata->af_statistics_buf = (void *)
+                               afstat.af_buff[i].mmap_addr;
+                       afdata->xtrastats.ts = afstat.af_buff[i].xtrastats.ts;
+                       afdata->xtrastats.field_count =
+                               afstat.af_buff[i].xtrastats.field_count;
+                       return 0;
+               }
+       }
+       spin_unlock_irqrestore(&afstat.buffer_lock, irqflags);
+       /* Stats unavailable */
+
+       afdata->af_statistics_buf = NULL;
+       return -1;
+}
+
+void isp_af_notify(int notify)
+{
+       camnotify = notify;
+       if (camnotify && afstat.initialized) {
+               printk(KERN_DEBUG "Warning Camera Off \n");
+               afstat.stats_req = 0;
+               afstat.stats_done = 1;
+               wake_up_interruptible(&afstat.stats_wait);
+       }
+}
+EXPORT_SYMBOL(isp_af_notify);
+/*
+ * This API allows the user to update White Balance gains, as well as
+ * exposure time and analog gain. It is also used to request frame
+ * statistics.
+ */
+int isp_af_request_statistics(struct isp_af_data *afdata)
+{
+       int ret = 0;
+       u16 frame_diff = 0;
+       u16 frame_cnt = afstat.frame_count;
+       wait_queue_t wqt;
+
+       if (!af_dev_configptr->config->af_config) {
+               printk(KERN_ERR "AF engine not enabled\n");
+               return -EINVAL;
+       }
+       afdata->af_statistics_buf = NULL;
+
+       if (afdata->update != 0) {
+               if (afdata->update & REQUEST_STATISTICS) {
+                       isp_af_unlock_buffers();
+                               /* Stats available? */
+                       DPRINTK_ISPH3A("Stats available?\n");
+                       ret = isp_af_stats_available(afdata);
+                       if (!ret)
+                               goto out;
+
+                       /* Stats in near future? */
+                       DPRINTK_ISPH3A("Stats in near future?\n");
+                       if (afdata->frame_number > frame_cnt) {
+                               frame_diff = afdata->frame_number - frame_cnt;
+                       } else if (afdata->frame_number < frame_cnt) {
+                               if ((frame_cnt >
+                                       (MAX_FRAME_COUNT - MAX_FUTURE_FRAMES))
+                                       && (afdata->frame_number
+                                               < MAX_FRAME_COUNT))
+                                       frame_diff = afdata->frame_number
+                                                   + MAX_FRAME_COUNT
+                                                   - frame_cnt;
+                               else {
+                                       /* Frame unavailable */
+                                       frame_diff = MAX_FUTURE_FRAMES + 1;
+                                       afdata->af_statistics_buf = NULL;
+                               }
+                       }
+
+                       if (frame_diff > MAX_FUTURE_FRAMES) {
+                               printk(KERN_ERR "Invalid frame requested\n");
+                       } else if (!camnotify) {
+                               /* Block until frame in near future completes */
+                               afstat.frame_req = afdata->frame_number;
+                               afstat.stats_req = 1;
+                               afstat.stats_done = 0;
+                               init_waitqueue_entry(&wqt, current);
+                               ret =
+                                  wait_event_interruptible(afstat.stats_wait,
+                                               afstat.stats_done == 1);
+                               if (ret < 0)
+                                       return ret;
+                       DPRINTK_ISPH3A("ISP AF request status"
+                                               " interrupt raised\n");
+
+                               /* Stats now available */
+                               ret = isp_af_stats_available(afdata);
+                               if (ret) {
+                                       printk(KERN_ERR "After waiting for"
+                                               " stats, stats not available!!"
+                                               "\n");
+                               }
+                       }
+               }
+       }
+
+out:
+       afdata->curr_frame = afstat.frame_count;
+
+       return 0;
+}
+EXPORT_SYMBOL(isp_af_request_statistics);
+
+/* This function will handle the H3A interrupt. */
+static void isp_af_isr(unsigned long status, isp_vbq_callback_ptr arg1,
+                                                               void *arg2)
+{
+       u16 frame_align;
+
+       if ((H3A_AF_DONE & status) != H3A_AF_DONE)
+               return;
+
+       /* Exchange buffers */
+       active_buff = active_buff->next;
+       if (active_buff->locked == 1)
+               active_buff = active_buff->next;
+       isp_af_set_address(active_buff->ispmmu_addr);
+
+       /* Update frame counter */
+       afstat.frame_count++;
+       frame_align = afstat.frame_count;
+       if (afstat.frame_count > MAX_FRAME_COUNT) {
+               afstat.frame_count = 1;
+               frame_align++;
+       }
+       active_buff->frame_num = afstat.frame_count;
+
+       /* Future Stats requested? */
+       if (afstat.stats_req) {
+               /* Is the frame we want already done? */
+               if (frame_align >= (afstat.frame_req + 1)) {
+                       afstat.stats_req = 0;
+                       afstat.stats_done = 1;
+                       wake_up_interruptible(&afstat.stats_wait);
+               }
+       }
+}
+
+/* Function to Enable/Disable AF Engine */
+int isp_af_enable(int enable)
+{
+       unsigned int pcr;
+
+       pcr = omap_readl(ISPH3A_PCR);
+
+       /* Set AF_EN bit in PCR Register */
+       if (enable) {
+               if (isp_set_callback(CBK_H3A_AF_DONE, isp_af_isr,
+                                               (void *)NULL, (void *)NULL)) {
+                       printk(KERN_ERR "No callback for AF\n");
+                       return -EINVAL;
+               }
+
+               pcr |= AF_EN;
+       } else {
+               isp_unset_callback(CBK_H3A_AF_DONE);
+               pcr &= ~AF_EN;
+       }
+       omap_writel(pcr, ISPH3A_PCR);
+       return 0;
+}
+
+/* Function to register the AF character device driver. */
+int __init isp_af_init(void)
+{
+       /*allocate memory for device structure and initialize it with 0 */
+       af_dev_configptr = kzalloc(sizeof(struct af_device), GFP_KERNEL);
+       if (!af_dev_configptr)
+               goto err_nomem1;
+
+       active_buff = NULL;
+
+       af_dev_configptr->config = (struct af_configuration *)
+                       kzalloc(sizeof(struct af_configuration), GFP_KERNEL);
+
+       if (af_dev_configptr->config == NULL)
+               goto err_nomem2;
+
+       printk(KERN_DEBUG "isp_af_init\n");
+       memset(&afstat, 0, sizeof(afstat));
+
+       init_waitqueue_head(&afstat.stats_wait);
+       spin_lock_init(&afstat.buffer_lock);
+
+       return 0;
+
+err_nomem2:
+       kfree(af_dev_configptr);
+err_nomem1:
+       printk(KERN_ERR "Error: kmalloc fail");
+       return -ENOMEM;
+}
+
+void __exit isp_af_exit(void)
+{
+       int i;
+
+       if (afstat.af_buff) {
+               /* Free buffers */
+               for (i = 0; i < H3A_MAX_BUFF; i++) {
+                       ispmmu_unmap(afstat.af_buff[i].ispmmu_addr);
+                       dma_free_coherent(NULL,
+                               afstat.min_buf_size + 64,
+                               (void *)afstat.af_buff[i].virt_addr,
+                               (dma_addr_t)afstat.af_buff[i].phy_addr);
+               }
+       }
+       kfree(af_dev_configptr->config);
+       kfree(af_dev_configptr);
+
+       memset(&afstat, 0, sizeof(afstat));
+
+       af_major = -1;
+       isp_af_enable(0);
+}
Index: linux-omap-2.6/drivers/media/video/isp/isp_af.h
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/isp/isp_af.h     2008-08-28 19:08:43.000000000 -0500
@@ -0,0 +1,139 @@
+/*
+ * drivers/media/video/isp/isp_af.h
+ *
+ * Include file for AF module in TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments, Inc.
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+/* Device Constants */
+#ifndef OMAP_ISP_AF_H
+#define OMAP_ISP_AF_H
+
+#include <mach/isp_user.h>
+
+#define AF_MAJOR_NUMBER                        0
+#define ISPAF_NAME                     "OMAPISP_AF"
+#define AF_NR_DEVS                     1
+#define AF_TIMEOUT                     ((300 * HZ) / 1000)
+
+
+/* Range Constants */
+#define AF_IIRSH_MIN                   0
+#define AF_IIRSH_MAX                   4094
+#define AF_PAXEL_HORIZONTAL_COUNT_MIN  0
+#define AF_PAXEL_HORIZONTAL_COUNT_MAX  35
+#define AF_PAXEL_VERTICAL_COUNT_MIN    0
+#define AF_PAXEL_VERTICAL_COUNT_MAX    127
+#define AF_PAXEL_INCREMENT_MIN         0
+#define AF_PAXEL_INCREMENT_MAX         14
+#define AF_PAXEL_HEIGHT_MIN            0
+#define AF_PAXEL_HEIGHT_MAX            127
+#define AF_PAXEL_WIDTH_MIN             0
+#define AF_PAXEL_WIDTH_MAX             127
+#define AF_PAXEL_HZSTART_MIN           2
+#define AF_PAXEL_HZSTART_MAX           4094
+
+#define AF_PAXEL_VTSTART_MIN           0
+#define AF_PAXEL_VTSTART_MAX           4095
+#define AF_THRESHOLD_MAX               255
+#define AF_COEF_MAX                    4095
+#define AF_PAXEL_SIZE                  48
+
+/* Print Macros */
+/*list of error code */
+#define AF_ERR_HZ_COUNT                        800     /* Invalid Horizontal Count */
+#define AF_ERR_VT_COUNT                        801     /* Invalid Vertical Count */
+#define AF_ERR_HEIGHT                  802     /* Invalid Height */
+#define AF_ERR_WIDTH                   803     /* Invalid width */
+#define AF_ERR_INCR                    804     /* Invalid Increment */
+#define AF_ERR_HZ_START                        805     /* Invalid horizontal Start */
+#define AF_ERR_VT_START                        806     /* Invalud vertical Start */
+#define AF_ERR_IIRSH                   807     /* Invalid IIRSH value */
+#define AF_ERR_IIR_COEF                        808     /* Invalid Coefficient */
+#define AF_ERR_SETUP                   809     /* Setup not done */
+#define AF_ERR_THRESHOLD               810     /* Invalid Threshold */
+#define AF_ERR_ENGINE_BUSY             811     /* Engine is busy */
+
+#define AFPID                          0x0     /* Peripheral Revision
+                                                * and Class Information
+                                                */
+
+#define AFCOEF_OFFSET                  0x00000004      /* COEFFICIENT BASE
+                                                        * ADDRESS
+                                                        */
+
+/*
+ * PCR fields
+ */
+#define AF_BUSYAF                      (1 << 15)
+#define FVMODE                         (1 << 14)
+#define RGBPOS                         (0x7 << 11)
+#define MED_TH                         (0xFF << 3)
+#define AF_MED_EN                      (1 << 2)
+#define AF_ALAW_EN                     (1 << 1)
+#define AF_EN                          (1 << 0)
+
+/*
+ * AFPAX1 fields
+ */
+#define PAXW                           (0x7F << 16)
+#define PAXH                           0x7F
+
+/*
+ * AFPAX2 fields
+ */
+#define AFINCV                         (0xF << 13)
+#define PAXVC                          (0x7F << 6)
+#define PAXHC                          0x3F
+
+/*
+ * AFPAXSTART fields
+ */
+#define PAXSH                          (0xFFF<<16)
+#define PAXSV                          0xFFF
+
+/*
+ * COEFFICIENT MASK
+ */
+
+#define COEF_MASK0                     0xFFF
+#define COEF_MASK1                     (0xFFF<<16)
+
+/* BIT SHIFTS */
+#define AF_RGBPOS_SHIFT                        11
+#define AF_MED_TH_SHIFT                        3
+#define AF_PAXW_SHIFT                  16
+#define AF_LINE_INCR_SHIFT             13
+#define AF_VT_COUNT_SHIFT              6
+#define AF_HZ_START_SHIFT              16
+#define AF_COEF_SHIFT                  16
+
+#define AF_UPDATEXS_TS                 (1 << 0)
+#define AF_UPDATEXS_FIELDCOUNT (1 << 1)
+#define AF_UPDATEXS_LENSPOS            (1 << 2)
+
+/* Structure for device of AF Engine */
+struct af_device {
+       struct af_configuration *config; /*Device configuration structure */
+       int size_paxel;         /*Paxel size in bytes */
+};
+
+int isp_af_check_paxel(void);
+int isp_af_check_iir(void);
+int isp_af_register_setup(struct af_device *af_dev);
+int isp_af_enable(int);
+void isp_af_notify(int notify);
+int isp_af_request_statistics(struct isp_af_data *afdata);
+int isp_af_configure(struct af_configuration *afconfig);
+void isp_af_set_address(unsigned long);
+void isp_af_setxtrastats(struct isp_af_xtrastats *xtrastats, u8 updateflag);
+#endif /* OMAP_ISP_AF_H */
Index: linux-omap-2.6/drivers/media/video/isp/ispccdc.c
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/isp/ispccdc.c    2008-08-28 19:08:43.000000000 -0500
@@ -0,0 +1,1491 @@
+/*
+ * drivers/media/video/isp/ispccdc.c
+ *
+ * Driver Library for CCDC module in TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments, Inc.
+ *
+ * Contributors:
+ *     Senthilvadivu Guruswamy <svadivu@ti.com>
+ *     Pallavi Kulkarni <p-kulkarni@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#include <linux/mutex.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+#include <linux/types.h>
+#include <asm/mach-types.h>
+#include <mach/clock.h>
+#include <linux/io.h>
+#include <linux/scatterlist.h>
+#include <linux/uaccess.h>
+
+#include "isp.h"
+#include "ispreg.h"
+#include "ispccdc.h"
+#include "ispmmu.h"
+
+static u32 *fpc_table_add;
+static unsigned long fpc_table_add_m;
+
+/**
+ * struct isp_ccdc - Structure for the CCDC module to store its own information
+ * @ccdc_inuse: Flag to determine if CCDC has been reserved or not (0 or 1).
+ * @ccdcout_w: CCDC output width.
+ * @ccdcout_h: CCDC output height.
+ * @ccdcin_w: CCDC input width.
+ * @ccdcin_h: CCDC input height.
+ * @ccdcin_woffset: CCDC input horizontal offset.
+ * @ccdcin_hoffset: CCDC input vertical offset.
+ * @crop_w: Crop width.
+ * @crop_h: Crop weight.
+ * @ccdc_inpfmt: CCDC input format.
+ * @ccdc_outfmt: CCDC output format.
+ * @vpout_en: Video port output enable.
+ * @wen: Data write enable.
+ * @exwen: External data write enable.
+ * @refmt_en: Reformatter enable.
+ * @ccdcslave: CCDC slave mode enable.
+ * @syncif_ipmod: Image
+ * @obclamp_en: Data input format.
+ * @mutexlock: Mutex used to get access to the CCDC.
+ */
+static struct isp_ccdc {
+       u8 ccdc_inuse;
+       u32 ccdcout_w;
+       u32 ccdcout_h;
+       u32 ccdcin_w;
+       u32 ccdcin_h;
+       u32 ccdcin_woffset;
+       u32 ccdcin_hoffset;
+       u32 crop_w;
+       u32 crop_h;
+       u8 ccdc_inpfmt;
+       u8 ccdc_outfmt;
+       u8 vpout_en;
+       u8 wen;
+       u8 exwen;
+       u8 refmt_en;
+       u8 ccdcslave;
+       u8 syncif_ipmod;
+       u8 obclamp_en;
+       u8 lsc_en;
+       struct mutex mutexlock; /* For checking/modifying ccdc_inuse */
+} ispccdc_obj;
+
+static struct ispccdc_lsc_config lsc_config;
+static u8 *lsc_gain_table;
+static unsigned long lsc_ispmmu_addr;
+static int lsc_initialized;
+static int size_mismatch;
+static u8 ccdc_use_lsc;
+static u8 ispccdc_lsc_tbl[] = {
+       #include "ispccd_lsc.dat"
+};
+
+/* Structure for saving/restoring CCDC module registers*/
+static struct isp_reg ispccdc_reg_list[] = {
+       {ISPCCDC_SYN_MODE, 0},
+       {ISPCCDC_HD_VD_WID, 0},
+       {ISPCCDC_PIX_LINES, 0},
+       {ISPCCDC_HORZ_INFO, 0},
+       {ISPCCDC_VERT_START, 0},
+       {ISPCCDC_VERT_LINES, 0},
+       {ISPCCDC_CULLING, 0},
+       {ISPCCDC_HSIZE_OFF, 0},
+       {ISPCCDC_SDOFST, 0},
+       {ISPCCDC_SDR_ADDR, 0},
+       {ISPCCDC_CLAMP, 0},
+       {ISPCCDC_DCSUB, 0},
+       {ISPCCDC_COLPTN, 0},
+       {ISPCCDC_BLKCMP, 0},
+       {ISPCCDC_FPC, 0},
+       {ISPCCDC_FPC_ADDR, 0},
+       {ISPCCDC_VDINT, 0},
+       {ISPCCDC_ALAW, 0},
+       {ISPCCDC_REC656IF, 0},
+       {ISPCCDC_CFG, 0},
+       {ISPCCDC_FMTCFG, 0},
+       {ISPCCDC_FMT_HORZ, 0},
+       {ISPCCDC_FMT_VERT, 0},
+       {ISPCCDC_FMT_ADDR0, 0},
+       {ISPCCDC_FMT_ADDR1, 0},
+       {ISPCCDC_FMT_ADDR2, 0},
+       {ISPCCDC_FMT_ADDR3, 0},
+       {ISPCCDC_FMT_ADDR4, 0},
+       {ISPCCDC_FMT_ADDR5, 0},
+       {ISPCCDC_FMT_ADDR6, 0},
+       {ISPCCDC_FMT_ADDR7, 0},
+       {ISPCCDC_PRGEVEN0, 0},
+       {ISPCCDC_PRGEVEN1, 0},
+       {ISPCCDC_PRGODD0, 0},
+       {ISPCCDC_PRGODD1, 0},
+       {ISPCCDC_VP_OUT, 0},
+       {ISPCCDC_LSC_CONFIG, 0},
+       {ISPCCDC_LSC_INITIAL, 0},
+       {ISPCCDC_LSC_TABLE_BASE, 0},
+       {ISPCCDC_LSC_TABLE_OFFSET, 0},
+       {ISP_TOK_TERM, 0}
+};
+
+/**
+ * omap34xx_isp_ccdc_config - Sets CCDC configuration from userspace
+ * @userspace_add: Structure containing CCDC configuration sent from userspace.
+ *
+ * Returns 0 if successful, -EINVAL if the pointer to the configuration
+ * structure is null, or the copy_from_user function fails to copy user space
+ * memory to kernel space memory.
+ **/
+int omap34xx_isp_ccdc_config(void *userspace_add)
+{
+       struct ispccdc_bclamp bclamp_t;
+       struct ispccdc_blcomp blcomp_t;
+       struct ispccdc_fpc fpc_t;
+       struct ispccdc_culling cull_t;
+       struct ispccdc_update_config *ccdc_struct;
+       u32 old_size;
+
+       if (userspace_add == NULL)
+               return -EINVAL;
+
+       ccdc_struct = (struct ispccdc_update_config *) userspace_add;
+
+       if ((ISP_ABS_CCDC_ALAW & ccdc_struct->flag) == ISP_ABS_CCDC_ALAW) {
+               if ((ISP_ABS_CCDC_ALAW & ccdc_struct->update) ==
+                                                       ISP_ABS_CCDC_ALAW)
+                       ispccdc_config_alaw(ccdc_struct->alawip);
+               ispccdc_enable_alaw(1);
+       } else if ((ISP_ABS_CCDC_ALAW & ccdc_struct->update) ==
+                                                       ISP_ABS_CCDC_ALAW)
+               ispccdc_enable_alaw(0);
+
+       if ((ISP_ABS_CCDC_LPF & ccdc_struct->flag) == ISP_ABS_CCDC_LPF)
+               ispccdc_enable_lpf(1);
+       else
+               ispccdc_enable_lpf(0);
+
+       if ((ISP_ABS_CCDC_BLCLAMP & ccdc_struct->flag) ==
+               ISP_ABS_CCDC_BLCLAMP) {
+               if ((ISP_ABS_CCDC_BLCLAMP & ccdc_struct->update) ==
+                       ISP_ABS_CCDC_BLCLAMP) {
+                       if (copy_from_user(&bclamp_t, (struct ispccdc_bclamp *)
+                                               (ccdc_struct->bclamp),
+                                               sizeof(struct ispccdc_bclamp)))
+                               goto copy_from_user_err;
+
+                       ispccdc_config_black_clamp(bclamp_t);
+               }
+               ispccdc_enable_black_clamp(1);
+       } else if ((ISP_ABS_CCDC_BLCLAMP & ccdc_struct->update) ==
+                                                       ISP_ABS_CCDC_BLCLAMP)
+                       ispccdc_enable_black_clamp(0);
+
+       if ((ISP_ABS_CCDC_BCOMP & ccdc_struct->update) == ISP_ABS_CCDC_BCOMP) {
+               if (copy_from_user(&blcomp_t, (struct ispccdc_blcomp *)
+                                                       (ccdc_struct->blcomp),
+                                                       sizeof(blcomp_t)))
+                       goto copy_from_user_err;
+
+               ispccdc_config_black_comp(blcomp_t);
+       }
+
+       if ((ISP_ABS_CCDC_FPC & ccdc_struct->flag) == ISP_ABS_CCDC_FPC) {
+               if ((ISP_ABS_CCDC_FPC & ccdc_struct->update) ==
+                                                       ISP_ABS_CCDC_FPC) {
+                       if (copy_from_user(&fpc_t, (struct ispccdc_fpc *)
+                                                       (ccdc_struct->fpc),
+                                                       sizeof(fpc_t)))
+                               goto copy_from_user_err;
+                       fpc_table_add = kmalloc((64 + (fpc_t.fpnum * 4)),
+                                                       GFP_KERNEL | GFP_DMA);
+                       if (!fpc_table_add) {
+                               printk(KERN_ERR "Cannot allocate memory for"
+                                                               " FPC table");
+                               return -ENOMEM;
+                       }
+                       while (((int)fpc_table_add & 0xFFFFFFC0) !=
+                                                       (int)fpc_table_add)
+                               fpc_table_add++;
+
+                       fpc_table_add_m = ispmmu_map(virt_to_phys
+                                                       (fpc_table_add),
+                                                       (fpc_t.fpnum) * 4);
+
+                       if (copy_from_user(fpc_table_add, (u32 *)fpc_t.fpcaddr,
+                                                       fpc_t.fpnum * 4))
+                               goto copy_from_user_err;
+
+                       fpc_t.fpcaddr = fpc_table_add_m;
+                       ispccdc_config_fpc(fpc_t);
+               }
+               ispccdc_enable_fpc(1);
+       } else if ((ISP_ABS_CCDC_FPC & ccdc_struct->update) ==
+                                                       ISP_ABS_CCDC_FPC)
+                       ispccdc_enable_fpc(0);
+
+       if ((ISP_ABS_CCDC_CULL & ccdc_struct->update) == ISP_ABS_CCDC_CULL) {
+               if (copy_from_user(&cull_t, (struct ispccdc_culling *)
+                                                       (ccdc_struct->cull),
+                                                       sizeof(cull_t)))
+                       goto copy_from_user_err;
+               ispccdc_config_culling(cull_t);
+       }
+
+       if (is_isplsc_activated()) {
+               if ((ISP_ABS_CCDC_CONFIG_LSC & ccdc_struct->flag) ==
+                                               ISP_ABS_CCDC_CONFIG_LSC) {
+                       if ((ISP_ABS_CCDC_CONFIG_LSC & ccdc_struct->update) ==
+                                               ISP_ABS_CCDC_CONFIG_LSC) {
+                               old_size = lsc_config.size;
+                               if (copy_from_user(&lsc_config,
+                                               (struct ispccdc_lsc_config *)
+                                               (ccdc_struct->lsc_cfg),
+                                               sizeof(struct
+                                               ispccdc_lsc_config)))
+                                       goto copy_from_user_err;
+                               lsc_initialized = 0;
+                               if (lsc_config.size <= old_size)
+                                       size_mismatch = 0;
+                               else
+                                       size_mismatch = 1;
+                               ispccdc_config_lsc(&lsc_config);
+                       }
+                       ccdc_use_lsc = 1;
+               } else if ((ISP_ABS_CCDC_CONFIG_LSC & ccdc_struct->update) ==
+                                               ISP_ABS_CCDC_CONFIG_LSC) {
+                               ispccdc_enable_lsc(0);
+                               ccdc_use_lsc = 0;
+               }
+               if ((ISP_ABS_TBL_LSC & ccdc_struct->update)
+                       == ISP_ABS_TBL_LSC) {
+                       if (size_mismatch) {
+                               ispmmu_unmap(lsc_ispmmu_addr);
+                               kfree(lsc_gain_table);
+                               lsc_gain_table = kmalloc(
+                                       lsc_config.size,
+                                       GFP_KERNEL | GFP_DMA);
+                               if (!lsc_gain_table) {
+                                       printk(KERN_ERR
+                                               "Cannot allocate\
+                                               memory for \
+                                               gain tables \n");
+                                       return -ENOMEM;
+                               }
+                               lsc_ispmmu_addr = ispmmu_map(
+                                       virt_to_phys(lsc_gain_table),
+                                       lsc_config.size);
+                               omap_writel(lsc_ispmmu_addr,
+                                       ISPCCDC_LSC_TABLE_BASE);
+                               lsc_initialized = 1;
+                               size_mismatch = 0;
+                       }
+                       if (copy_from_user(lsc_gain_table,
+                               (ccdc_struct->lsc), lsc_config.size))
+                               goto copy_from_user_err;
+               }
+       }
+
+       if ((ISP_ABS_CCDC_COLPTN & ccdc_struct->update) == ISP_ABS_CCDC_COLPTN)
+               ispccdc_config_imgattr(ccdc_struct->colptn);
+
+       return 0;
+
+copy_from_user_err:
+       printk(KERN_ERR "CCDC Config:Copy From User Error");
+       return -EINVAL ;
+}
+EXPORT_SYMBOL(omap34xx_isp_ccdc_config);
+
+/**
+ * ispccdc_request - Reserves the CCDC module.
+ *
+ * Reserves the CCDC module and assures that is used only once at a time.
+ *
+ * Returns 0 if successful, or -EBUSY if CCDC module is busy.
+ **/
+int ispccdc_request(void)
+{
+       mutex_lock(&ispccdc_obj.mutexlock);
+       if (ispccdc_obj.ccdc_inuse) {
+               mutex_unlock(&ispccdc_obj.mutexlock);
+               DPRINTK_ISPCCDC("ISP_ERR : CCDC Module Busy");
+               return -EBUSY;
+       }
+
+       ispccdc_obj.ccdc_inuse = 1;
+       mutex_unlock(&ispccdc_obj.mutexlock);
+       omap_writel((omap_readl(ISP_CTRL)) | ISPCTRL_CCDC_RAM_EN |
+                                                       ISPCTRL_CCDC_CLK_EN |
+                                                       ISPCTRL_SBL_WR1_RAM_EN,
+                                                       ISP_CTRL);
+       omap_writel((omap_readl(ISPCCDC_CFG)) | ISPCCDC_CFG_VDLC, ISPCCDC_CFG);
+       return 0;
+}
+EXPORT_SYMBOL(ispccdc_request);
+
+/**
+ * ispccdc_free - Frees the CCDC module.
+ *
+ * Frees the CCDC module so it can be used by another process.
+ *
+ * Returns 0 if successful, or -EINVAL if module has been already freed.
+ **/
+int ispccdc_free(void)
+{
+       mutex_lock(&ispccdc_obj.mutexlock);
+       if (!ispccdc_obj.ccdc_inuse) {
+               mutex_unlock(&ispccdc_obj.mutexlock);
+               DPRINTK_ISPCCDC("ISP_ERR: CCDC Module already freed\n");
+               return -EINVAL;
+       }
+
+       ispccdc_obj.ccdc_inuse = 0;
+       mutex_unlock(&ispccdc_obj.mutexlock);
+       omap_writel((omap_readl(ISP_CTRL)) & ~(ISPCTRL_CCDC_CLK_EN |
+                                               ISPCTRL_CCDC_RAM_EN |
+                                               ISPCTRL_SBL_WR1_RAM_EN),
+                                               ISP_CTRL);
+       return 0;
+}
+EXPORT_SYMBOL(ispccdc_free);
+
+/**
+ * ispccdc_load_lsc - Load Lens Shading Compensation table.
+ * @table_size: LSC gain table size.
+ *
+ * Returns 0 if successful, or -ENOMEM of its no memory available.
+ **/
+int ispccdc_load_lsc(u32 table_size)
+{
+       if (!is_isplsc_activated())
+               return 0;
+
+       if (table_size == 0)
+               return -EINVAL;
+
+       if (lsc_initialized)
+               return 0;
+
+       ispccdc_enable_lsc(0);
+       lsc_gain_table = kmalloc(table_size, GFP_KERNEL | GFP_DMA);
+
+       if (!lsc_gain_table) {
+               printk(KERN_ERR "Cannot allocate memory for gain tables \n");
+               return -ENOMEM;
+       }
+
+       memcpy(lsc_gain_table, ispccdc_lsc_tbl, table_size);
+       lsc_ispmmu_addr = ispmmu_map(virt_to_phys(lsc_gain_table), table_size);
+       omap_writel(lsc_ispmmu_addr, ISPCCDC_LSC_TABLE_BASE);
+       lsc_initialized = 1;
+       return 0;
+}
+EXPORT_SYMBOL(ispccdc_load_lsc);
+
+/**
+ * ispccdc_config_lsc - Configures the lens shading compensation module
+ * @lsc_cfg: LSC configuration structure
+ **/
+void ispccdc_config_lsc(struct ispccdc_lsc_config *lsc_cfg)
+{
+       int reg;
+
+       if (!is_isplsc_activated())
+               return;
+
+       ispccdc_enable_lsc(0);
+       omap_writel(lsc_cfg->offset, ISPCCDC_LSC_TABLE_OFFSET);
+
+       reg = 0;
+       reg |= (lsc_cfg->gain_mode_n << ISPCCDC_LSC_GAIN_MODE_N_SHIFT);
+       reg |= (lsc_cfg->gain_mode_m << ISPCCDC_LSC_GAIN_MODE_M_SHIFT);
+       reg |= (lsc_cfg->gain_format << ISPCCDC_LSC_GAIN_FORMAT_SHIFT);
+       omap_writel(reg, ISPCCDC_LSC_CONFIG);
+
+       reg = 0;
+       reg &= ~ISPCCDC_LSC_INITIAL_X_MASK;
+       reg |= (lsc_cfg->initial_x << ISPCCDC_LSC_INITIAL_X_SHIFT);
+       reg &= ~ISPCCDC_LSC_INITIAL_Y_MASK;
+       reg |= (lsc_cfg->initial_y << ISPCCDC_LSC_INITIAL_Y_SHIFT);
+       omap_writel(reg, ISPCCDC_LSC_INITIAL);
+}
+EXPORT_SYMBOL(ispccdc_config_lsc);
+
+/**
+ * ispccdc_enable_lsc - Enables/Disables the Lens Shading Compensation module.
+ * @enable: 0 Disables LSC, 1 Enables LSC.
+ **/
+void ispccdc_enable_lsc(u8 enable)
+{
+       if (!is_isplsc_activated())
+               return;
+
+       if (enable) {
+               omap_writel(omap_readl(ISP_CTRL) | ISPCTRL_SBL_SHARED_RPORTB |
+                                       ISPCTRL_SBL_RD_RAM_EN, ISP_CTRL);
+               omap_writel(omap_readl(ISPCCDC_LSC_CONFIG) | 0x1,
+                                                       ISPCCDC_LSC_CONFIG);
+               ispccdc_obj.lsc_en = 1;
+       } else {
+               omap_writel(omap_readl(ISPCCDC_LSC_CONFIG) & 0xFFFE,
+                                                       ISPCCDC_LSC_CONFIG);
+               ispccdc_obj.lsc_en = 0;
+       }
+}
+EXPORT_SYMBOL(ispccdc_enable_lsc);
+
+
+/**
+ * ispccdc_config_crop - Configures crop parameters for the ISP CCDC.
+ * @left: Left offset of the crop area.
+ * @top: Top offset of the crop area.
+ * @height: Height of the crop area.
+ * @width: Width of the crop area.
+ *
+ * The following restrictions are applied for the crop settings. If incoming
+ * values do not follow these restrictions then we map the settings to the
+ * closest acceptable crop value.
+ * 1) Left offset is always odd. This can be avoided if we enable byte swap
+ *    option for incoming data into CCDC.
+ * 2) Top offset is always even.
+ * 3) Crop height is always even.
+ * 4) Crop width is always a multiple of 16 pixels
+ **/
+void ispccdc_config_crop(u32 left, u32 top, u32 height, u32 width)
+{
+       ispccdc_obj.ccdcin_woffset = left + ((left + 1) % 2);
+       ispccdc_obj.ccdcin_hoffset = top + (top % 2);
+
+       ispccdc_obj.crop_w = width - (width % 16);
+       ispccdc_obj.crop_h = height + (height % 2);
+
+       DPRINTK_ISPCCDC("\n\tOffsets L %d T %d W %d H %d\n",
+                                               ispccdc_obj.ccdcin_woffset,
+                                               ispccdc_obj.ccdcin_hoffset,
+                                               ispccdc_obj.crop_w,
+                                               ispccdc_obj.crop_h);
+}
+
+/**
+ * ispccdc_config_datapath - Specifies the input and output modules for CCDC.
+ * @input: Indicates the module that inputs the image to the CCDC.
+ * @output: Indicates the module to which the CCDC outputs the image.
+ *
+ * Configures the default configuration for the CCDC to work with.
+ *
+ * The valid values for the input are CCDC_RAW (0), CCDC_YUV_SYNC (1),
+ * CCDC_YUV_BT (2), and CCDC_OTHERS (3).
+ *
+ * The valid values for the output are CCDC_YUV_RSZ (0), CCDC_YUV_MEM_RSZ (1),
+ * CCDC_OTHERS_VP (2), CCDC_OTHERS_MEM (3), CCDC_OTHERS_VP_MEM (4).
+ *
+ * Returns 0 if successful, or -EINVAL if wrong I/O combination or wrong input
+ * or output values.
+ **/
+int ispccdc_config_datapath(enum ccdc_input input, enum ccdc_output output)
+{
+       u32 syn_mode = 0;
+       struct ispccdc_vp vpcfg;
+       struct ispccdc_syncif syncif;
+       struct ispccdc_bclamp blkcfg;
+
+       u32 colptn = (ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP0PLC0_SHIFT) |
+               (ISPCCDC_COLPTN_R_Ye << ISPCCDC_COLPTN_CP0PLC1_SHIFT) |
+               (ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP0PLC2_SHIFT) |
+               (ISPCCDC_COLPTN_R_Ye << ISPCCDC_COLPTN_CP0PLC3_SHIFT) |
+               (ISPCCDC_COLPTN_B_Mg << ISPCCDC_COLPTN_CP1PLC0_SHIFT) |
+               (ISPCCDC_COLPTN_Gb_G << ISPCCDC_COLPTN_CP1PLC1_SHIFT) |
+               (ISPCCDC_COLPTN_B_Mg << ISPCCDC_COLPTN_CP1PLC2_SHIFT) |
+               (ISPCCDC_COLPTN_Gb_G << ISPCCDC_COLPTN_CP1PLC3_SHIFT) |
+               (ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP2PLC0_SHIFT) |
+               (ISPCCDC_COLPTN_R_Ye << ISPCCDC_COLPTN_CP2PLC1_SHIFT) |
+               (ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP2PLC2_SHIFT) |
+               (ISPCCDC_COLPTN_R_Ye << ISPCCDC_COLPTN_CP2PLC3_SHIFT) |
+               (ISPCCDC_COLPTN_B_Mg << ISPCCDC_COLPTN_CP3PLC0_SHIFT) |
+               (ISPCCDC_COLPTN_Gb_G << ISPCCDC_COLPTN_CP3PLC1_SHIFT) |
+               (ISPCCDC_COLPTN_B_Mg << ISPCCDC_COLPTN_CP3PLC2_SHIFT) |
+               (ISPCCDC_COLPTN_Gb_G << ISPCCDC_COLPTN_CP3PLC3_SHIFT);
+
+       /* CCDC does not convert the image format */
+       if (((input == CCDC_RAW) || (input == CCDC_OTHERS)) &&
+                                               (output == CCDC_YUV_RSZ)) {
+               DPRINTK_ISPCCDC("ISP_ERR: Wrong CCDC I/O Combination\n");
+               return -EINVAL;
+       }
+
+       syn_mode = omap_readl(ISPCCDC_SYN_MODE);
+
+       switch (output) {
+       case CCDC_YUV_RSZ:
+               syn_mode |= ISPCCDC_SYN_MODE_SDR2RSZ;
+               syn_mode &= ~ISPCCDC_SYN_MODE_WEN;
+               break;
+
+       case CCDC_YUV_MEM_RSZ:
+               syn_mode |= ISPCCDC_SYN_MODE_SDR2RSZ;
+               ispccdc_obj.wen = 1;
+               syn_mode |= ISPCCDC_SYN_MODE_WEN;
+               break;
+
+       case CCDC_OTHERS_VP:
+               syn_mode &= ~ISPCCDC_SYN_MODE_VP2SDR;
+               syn_mode &= ~ISPCCDC_SYN_MODE_SDR2RSZ;
+               syn_mode &= ~ISPCCDC_SYN_MODE_WEN;
+               vpcfg.bitshift_sel = BIT9_0;
+               vpcfg.freq_sel = PIXCLKBY2;
+               ispccdc_config_vp(vpcfg);
+               ispccdc_enable_vp(1);
+               break;
+
+       case CCDC_OTHERS_MEM:
+               syn_mode &= ~ISPCCDC_SYN_MODE_VP2SDR;
+               syn_mode &= ~ISPCCDC_SYN_MODE_SDR2RSZ;
+               syn_mode |= ISPCCDC_SYN_MODE_WEN;
+               syn_mode |= ISPCCDC_SYN_MODE_EXWEN;
+               omap_writel((omap_readl(ISPCCDC_CFG)) | ISPCCDC_CFG_WENLOG,
+                                                               ISPCCDC_CFG);
+               break;
+
+       case CCDC_OTHERS_VP_MEM:
+               syn_mode |= ISPCCDC_SYN_MODE_VP2SDR;
+               syn_mode |= ISPCCDC_SYN_MODE_WEN;
+               syn_mode |= ISPCCDC_SYN_MODE_EXWEN;
+               omap_writel((omap_readl(ISPCCDC_CFG)) | ISPCCDC_CFG_WENLOG,
+                                                               ISPCCDC_CFG);
+               vpcfg.bitshift_sel = BIT9_0;
+               vpcfg.freq_sel = PIXCLKBY2;
+               ispccdc_config_vp(vpcfg);
+               ispccdc_enable_vp(1);
+               break;
+       default:
+               DPRINTK_ISPCCDC("ISP_ERR: Wrong CCDC Output");
+               return -EINVAL;
+       };
+
+       if (is_isplsc_activated()) {
+               if (input == CCDC_RAW) {
+                       lsc_config.initial_x = 0;
+                       lsc_config.initial_y = 0;
+                       lsc_config.gain_mode_n = 0x6;
+                       lsc_config.gain_mode_m = 0x6;
+                       lsc_config.gain_format = 0x4;
+                       lsc_config.offset = 0x60;
+                       ispccdc_config_lsc(&lsc_config);
+                       ispccdc_load_lsc((u32)sizeof(ispccdc_lsc_tbl));
+               }
+       }
+
+       omap_writel(syn_mode, ISPCCDC_SYN_MODE);
+
+       switch (input) {
+       case CCDC_RAW:
+               syncif.ccdc_mastermode = 0;
+               syncif.datapol = 0;
+               syncif.datsz = DAT10;
+               syncif.fldmode = 0;
+               syncif.fldout = 0;
+               syncif.fldpol = 0;
+               syncif.fldstat = 0;
+               syncif.hdpol = 0;
+               syncif.ipmod = RAW;
+               syncif.vdpol = 0;
+               ispccdc_config_sync_if(syncif);
+               ispccdc_config_imgattr(colptn);
+               blkcfg.dcsubval = 42;
+               ispccdc_config_black_clamp(blkcfg);
+               break;
+       case CCDC_YUV_SYNC:
+               syncif.ccdc_mastermode = 0;
+               syncif.datapol = 0;
+               syncif.datsz = DAT8;
+               syncif.fldmode = 0;
+               syncif.fldout = 0;
+               syncif.fldpol = 0;
+               syncif.fldstat = 0;
+               syncif.hdpol = 0;
+               syncif.ipmod = YUV16;
+               syncif.vdpol = 0;
+               ispccdc_config_imgattr(0);
+               ispccdc_config_sync_if(syncif);
+               blkcfg.dcsubval = 0;
+               ispccdc_config_black_clamp(blkcfg);
+               break;
+       case CCDC_YUV_BT:
+               break;
+       case CCDC_OTHERS:
+               break;
+       default:
+               DPRINTK_ISPCCDC("ISP_ERR: Wrong CCDC Input");
+               return -EINVAL;
+       }
+
+       ispccdc_obj.ccdc_inpfmt = input;
+       ispccdc_obj.ccdc_outfmt = output;
+               ispccdc_print_status();
+               isp_print_status();
+       return 0;
+}
+EXPORT_SYMBOL(ispccdc_config_datapath);
+
+/**
+ * ispccdc_config_sync_if - Sets the sync i/f params between sensor and CCDC.
+ * @syncif: Structure containing the sync parameters like field state, CCDC in
+ *          master/slave mode, raw/yuv data, polarity of data, field, hs, vs
+ *          signals.
+ **/
+void ispccdc_config_sync_if(struct ispccdc_syncif syncif)
+{
+       u32 syn_mode = omap_readl(ISPCCDC_SYN_MODE);
+
+       syn_mode |= ISPCCDC_SYN_MODE_VDHDEN;
+
+       if (syncif.fldstat)
+               syn_mode |= ISPCCDC_SYN_MODE_FLDSTAT;
+       else
+               syn_mode &= ~ISPCCDC_SYN_MODE_FLDSTAT;
+
+       syn_mode &= ISPCCDC_SYN_MODE_INPMOD_MASK;
+       ispccdc_obj.syncif_ipmod = syncif.ipmod;
+
+       switch (syncif.ipmod) {
+       case RAW:
+               break;
+       case YUV16:
+               syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR16;
+               break;
+       case YUV8:
+               syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR8;
+               break;
+       };
+
+       syn_mode &= ISPCCDC_SYN_MODE_DATSIZ_MASK;
+       switch (syncif.datsz) {
+       case DAT8:
+               syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_8;
+               break;
+       case DAT10:
+               syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_10;
+               break;
+       case DAT11:
+               syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_11;
+               break;
+       case DAT12:
+               syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_12;
+               break;
+       };
+
+       if (syncif.fldmode)
+               syn_mode |= ISPCCDC_SYN_MODE_FLDMODE;
+       else
+               syn_mode &= ~ISPCCDC_SYN_MODE_FLDMODE;
+
+       if (syncif.datapol)
+               syn_mode |= ISPCCDC_SYN_MODE_DATAPOL;
+       else
+               syn_mode &= ~ISPCCDC_SYN_MODE_DATAPOL;
+
+       if (syncif.fldpol)
+               syn_mode |= ISPCCDC_SYN_MODE_FLDPOL;
+       else
+               syn_mode &= ~ISPCCDC_SYN_MODE_FLDPOL;
+
+       if (syncif.hdpol)
+               syn_mode |= ISPCCDC_SYN_MODE_HDPOL;
+       else
+               syn_mode &= ~ISPCCDC_SYN_MODE_HDPOL;
+
+       if (syncif.vdpol)
+               syn_mode |= ISPCCDC_SYN_MODE_VDPOL;
+       else
+               syn_mode &= ~ISPCCDC_SYN_MODE_VDPOL;
+
+       if (syncif.ccdc_mastermode) {
+               syn_mode |= ISPCCDC_SYN_MODE_FLDOUT | ISPCCDC_SYN_MODE_VDHDOUT;
+               omap_writel((syncif.hs_width << ISPCCDC_HD_VD_WID_HDW_SHIFT)
+                                               | (syncif.vs_width <<
+                                               ISPCCDC_HD_VD_WID_VDW_SHIFT),
+                                               ISPCCDC_HD_VD_WID);
+
+               omap_writel(syncif.ppln << ISPCCDC_PIX_LINES_PPLN_SHIFT
+                       | syncif.hlprf << ISPCCDC_PIX_LINES_HLPRF_SHIFT,
+                       ISPCCDC_PIX_LINES);
+       } else
+               syn_mode &= ~(ISPCCDC_SYN_MODE_FLDOUT |
+                                               ISPCCDC_SYN_MODE_VDHDOUT);
+
+       omap_writel(syn_mode, ISPCCDC_SYN_MODE);
+
+       if (!(syncif.bt_r656_en)) {
+               omap_writel((omap_readl(ISPCCDC_REC656IF)) &
+                                               ~ISPCCDC_REC656IF_R656ON,
+                                               ISPCCDC_REC656IF);
+       }
+}
+EXPORT_SYMBOL(ispccdc_config_sync_if);
+
+/**
+ * ispccdc_config_black_clamp - Configures the clamp parameters in CCDC.
+ * @bclamp: Structure containing the optical black average gain, optical black
+ *          sample length, sample lines, and the start pixel position of the
+ *          samples w.r.t the HS pulse.
+ * Configures the clamp parameters in CCDC. Either if its being used the
+ * optical black clamp, or the digital clamp. If its a digital clamp, then
+ * assures to put a valid DC substraction level.
+ *
+ * Returns always 0 when completed.
+ **/
+int ispccdc_config_black_clamp(struct ispccdc_bclamp bclamp)
+{
+       u32 bclamp_val = 0;
+
+       if (ispccdc_obj.obclamp_en) {
+               bclamp_val |= bclamp.obgain << ISPCCDC_CLAMP_OBGAIN_SHIFT;
+               bclamp_val |= bclamp.oblen << ISPCCDC_CLAMP_OBSLEN_SHIFT;
+               bclamp_val |= bclamp.oblines << ISPCCDC_CLAMP_OBSLN_SHIFT;
+               bclamp_val |= bclamp.obstpixel << ISPCCDC_CLAMP_OBST_SHIFT;
+               omap_writel(bclamp_val, ISPCCDC_CLAMP);
+       } else {
+               if (is_sil_rev_less_than(OMAP3430_REV_ES2_0))
+                       if ((ispccdc_obj.syncif_ipmod == YUV16) ||
+                                       (ispccdc_obj.syncif_ipmod == YUV8) ||
+                                       ((omap_readl(ISPCCDC_REC656IF) &
+                                       ISPCCDC_REC656IF_R656ON) ==
+                                       ISPCCDC_REC656IF_R656ON))
+                               bclamp.dcsubval = 0;
+               omap_writel(bclamp.dcsubval, ISPCCDC_DCSUB);
+       }
+       return 0;
+}
+EXPORT_SYMBOL(ispccdc_config_black_clamp);
+
+/**
+ * ispccdc_enable_black_clamp - Enables/Disables the optical black clamp.
+ * @enable: 0 Disables optical black clamp, 1 Enables optical black clamp.
+ *
+ * Enables or disables the optical black clamp. When disabled, the digital
+ * clamp operates.
+ **/
+void ispccdc_enable_black_clamp(u8 enable)
+{
+       if (enable) {
+               omap_writel((omap_readl(ISPCCDC_CLAMP))|ISPCCDC_CLAMP_CLAMPEN,
+                                                               ISPCCDC_CLAMP);
+               ispccdc_obj.obclamp_en = 1;
+       } else {
+               omap_writel((omap_readl(ISPCCDC_CLAMP)) &
+                                       ~ISPCCDC_CLAMP_CLAMPEN, ISPCCDC_CLAMP);
+               ispccdc_obj.obclamp_en = 0;
+       }
+}
+EXPORT_SYMBOL(ispccdc_enable_black_clamp);
+
+/**
+ * ispccdc_config_fpc - Configures the Faulty Pixel Correction parameters.
+ * @fpc: Structure containing the number of faulty pixels corrected in the
+ *       frame, address of the FPC table.
+ *
+ * Returns 0 if successful, or -EINVAL if FPC Address is not on the 64 byte
+ * boundary.
+ **/
+int ispccdc_config_fpc(struct ispccdc_fpc fpc)
+{
+       u32 fpc_val = 0;
+
+       fpc_val = omap_readl(ISPCCDC_FPC);
+
+       if ((fpc.fpcaddr & 0xFFFFFFC0) == fpc.fpcaddr) {
+               omap_writel(fpc_val&(~ISPCCDC_FPC_FPCEN), ISPCCDC_FPC);
+               omap_writel(fpc.fpcaddr, ISPCCDC_FPC_ADDR);
+       } else {
+               DPRINTK_ISPCCDC("FPC Address should be on 64byte boundary\n");
+               return -EINVAL;
+       }
+       omap_writel(fpc_val | (fpc.fpnum << ISPCCDC_FPC_FPNUM_SHIFT),
+                                                               ISPCCDC_FPC);
+       return 0;
+}
+EXPORT_SYMBOL(ispccdc_config_fpc);
+
+/**
+ * ispccdc_enable_fpc - Enables the Faulty Pixel Correction.
+ * @enable: 0 Disables FPC, 1 Enables FPC.
+ **/
+void ispccdc_enable_fpc(u8 enable)
+{
+       if (enable) {
+               omap_writel(omap_readl(ISPCCDC_FPC) | ISPCCDC_FPC_FPCEN,
+                                                               ISPCCDC_FPC);
+       } else {
+               omap_writel(omap_readl(ISPCCDC_FPC) & ~ISPCCDC_FPC_FPCEN,
+                                                               ISPCCDC_FPC);
+       }
+}
+EXPORT_SYMBOL(ispccdc_enable_fpc);
+
+/**
+ * ispccdc_config_black_comp - Configures Black Level Compensation parameters.
+ * @blcomp: Structure containing the black level compensation value for RGrGbB
+ *          pixels. in 2's complement.
+ **/
+void ispccdc_config_black_comp(struct ispccdc_blcomp blcomp)
+{
+       u32 blcomp_val = 0;
+
+       blcomp_val |= blcomp.b_mg << ISPCCDC_BLKCMP_B_MG_SHIFT;
+       blcomp_val |= blcomp.gb_g << ISPCCDC_BLKCMP_GB_G_SHIFT;
+       blcomp_val |= blcomp.gr_cy << ISPCCDC_BLKCMP_GR_CY_SHIFT;
+       blcomp_val |= blcomp.r_ye << ISPCCDC_BLKCMP_R_YE_SHIFT;
+
+       omap_writel(blcomp_val, ISPCCDC_BLKCMP);
+}
+EXPORT_SYMBOL(ispccdc_config_black_comp);
+
+/**
+ * ispccdc_config_vp - Configures the Video Port Configuration parameters.
+ * @vpcfg: Structure containing the Video Port input frequency, and the 10 bit
+ *         format.
+ **/
+void ispccdc_config_vp(struct ispccdc_vp vpcfg)
+{
+       u32 fmtcfg_vp = omap_readl(ISPCCDC_FMTCFG);
+
+       fmtcfg_vp &= ISPCCDC_FMTCFG_VPIN_MASK & ISPCCDC_FMTCF_VPIF_FRQ_MASK;
+
+       switch (vpcfg.bitshift_sel) {
+       case BIT9_0:
+               fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_9_0;
+               break;
+       case BIT10_1:
+               fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_10_1;
+               break;
+       case BIT11_2:
+               fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_11_2;
+               break;
+       case BIT12_3:
+               fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_12_3;
+               break;
+       };
+       switch (vpcfg.freq_sel) {
+       case PIXCLKBY2:
+               fmtcfg_vp |= ISPCCDC_FMTCF_VPIF_FRQ_BY2;
+               break;
+       case PIXCLKBY3_5:
+               fmtcfg_vp |= ISPCCDC_FMTCF_VPIF_FRQ_BY3;
+               break;
+       case PIXCLKBY4_5:
+               fmtcfg_vp |= ISPCCDC_FMTCF_VPIF_FRQ_BY4;
+               break;
+       case PIXCLKBY5_5:
+               fmtcfg_vp |= ISPCCDC_FMTCF_VPIF_FRQ_BY5;
+               break;
+       case PIXCLKBY6_5:
+               fmtcfg_vp |= ISPCCDC_FMTCF_VPIF_FRQ_BY6;
+               break;
+       };
+       omap_writel(fmtcfg_vp, ISPCCDC_FMTCFG);
+}
+EXPORT_SYMBOL(ispccdc_config_vp);
+
+/**
+ * ispccdc_enable_vp - Enables the Video Port.
+ * @enable: 0 Disables VP, 1 Enables VP
+ **/
+void ispccdc_enable_vp(u8 enable)
+{
+       if (enable) {
+               omap_writel((omap_readl(ISPCCDC_FMTCFG)) |
+                                       ISPCCDC_FMTCFG_VPEN, ISPCCDC_FMTCFG);
+       } else {
+               omap_writel(omap_readl(ISPCCDC_FMTCFG) &
+                                       ~ISPCCDC_FMTCFG_VPEN, ISPCCDC_FMTCFG);
+       }
+}
+EXPORT_SYMBOL(ispccdc_enable_vp);
+
+/**
+ * ispccdc_config_reformatter - Configures the Reformatter.
+ * @refmt: Structure containing the memory address to format and the bit fields
+ *         for the reformatter registers.
+ *
+ * Configures the Reformatter register values if line alternating is disabled.
+ * Else, just enabling line alternating is enough.
+ **/
+void ispccdc_config_reformatter(struct ispccdc_refmt refmt)
+{
+       u32 fmtcfg_val = 0;
+
+       fmtcfg_val = omap_readl(ISPCCDC_FMTCFG);
+
+       if (refmt.lnalt)
+               fmtcfg_val |= ISPCCDC_FMTCFG_LNALT;
+       else {
+               fmtcfg_val &= ~ISPCCDC_FMTCFG_LNALT;
+               fmtcfg_val &= 0xFFFFF003;
+               fmtcfg_val |= refmt.lnum << ISPCCDC_FMTCFG_LNUM_SHIFT;
+               fmtcfg_val |= refmt.plen_even <<
+                                               ISPCCDC_FMTCFG_PLEN_EVEN_SHIFT;
+               fmtcfg_val |= refmt.plen_odd << ISPCCDC_FMTCFG_PLEN_ODD_SHIFT;
+
+               omap_writel(refmt.prgeven0, ISPCCDC_PRGEVEN0);
+               omap_writel(refmt.prgeven1, ISPCCDC_PRGEVEN1);
+               omap_writel(refmt.prgodd0, ISPCCDC_PRGODD0);
+               omap_writel(refmt.prgodd1, ISPCCDC_PRGODD1);
+               omap_writel(refmt.fmtaddr0, ISPCCDC_FMT_ADDR0);
+               omap_writel(refmt.fmtaddr1, ISPCCDC_FMT_ADDR1);
+               omap_writel(refmt.fmtaddr2, ISPCCDC_FMT_ADDR2);
+               omap_writel(refmt.fmtaddr3, ISPCCDC_FMT_ADDR3);
+               omap_writel(refmt.fmtaddr4, ISPCCDC_FMT_ADDR4);
+               omap_writel(refmt.fmtaddr5, ISPCCDC_FMT_ADDR5);
+               omap_writel(refmt.fmtaddr6, ISPCCDC_FMT_ADDR6);
+               omap_writel(refmt.fmtaddr7, ISPCCDC_FMT_ADDR7);
+       }
+       omap_writel(fmtcfg_val, ISPCCDC_FMTCFG);
+}
+EXPORT_SYMBOL(ispccdc_config_reformatter);
+
+/**
+ * ispccdc_enable_reformatter - Enables the Reformatter.
+ * @enable: 0 Disables Reformatter, 1- Enables Data Reformatter
+ **/
+void ispccdc_enable_reformatter(u8 enable)
+{
+       if (enable) {
+               omap_writel((omap_readl(ISPCCDC_FMTCFG)) |
+                                                       ISPCCDC_FMTCFG_FMTEN,
+                                                       ISPCCDC_FMTCFG);
+               ispccdc_obj.refmt_en = 1;
+       } else {
+               omap_writel((omap_readl(ISPCCDC_FMTCFG)) &
+                                                       ~ISPCCDC_FMTCFG_FMTEN,
+                                                       ISPCCDC_FMTCFG);
+               ispccdc_obj.refmt_en = 0;
+       }
+}
+EXPORT_SYMBOL(ispccdc_enable_reformatter);
+
+/**
+ * ispccdc_config_culling - Configures the culling parameters.
+ * @cull: Structure containing the vertical culling pattern, and horizontal
+ *        culling pattern for odd and even lines.
+ **/
+void ispccdc_config_culling(struct ispccdc_culling cull)
+{
+       u32 culling_val = 0;
+
+       culling_val |= cull.v_pattern << ISPCCDC_CULLING_CULV_SHIFT;
+       culling_val |= cull.h_even << ISPCCDC_CULLING_CULHEVN_SHIFT;
+       culling_val |= cull.h_odd << ISPCCDC_CULLING_CULHODD_SHIFT;
+
+       omap_writel(culling_val, ISPCCDC_CULLING);
+}
+EXPORT_SYMBOL(ispccdc_config_culling);
+
+/**
+ * ispccdc_enable_lpf - Enables the Low-Pass Filter (LPF).
+ * @enable: 0 Disables LPF, 1 Enables LPF
+ **/
+void ispccdc_enable_lpf(u8 enable)
+{
+       if (enable) {
+               omap_writel(omap_readl(ISPCCDC_SYN_MODE) |
+                                                       ISPCCDC_SYN_MODE_LPF,
+                                                       ISPCCDC_SYN_MODE);
+       } else {
+               omap_writel(omap_readl(ISPCCDC_SYN_MODE) &
+                                                       ~ISPCCDC_SYN_MODE_LPF,
+                                                       ISPCCDC_SYN_MODE);
+       }
+}
+EXPORT_SYMBOL(ispccdc_enable_lpf);
+
+/**
+ * ispccdc_config_alaw - Configures the input width for A-law.
+ * @ipwidth: Input width for A-law
+ **/
+void ispccdc_config_alaw(enum alaw_ipwidth ipwidth)
+{
+       omap_writel(ipwidth << ISPCCDC_ALAW_GWDI_SHIFT, ISPCCDC_ALAW);
+}
+EXPORT_SYMBOL(ispccdc_config_alaw);
+
+/**
+ * ispccdc_enable_alaw - Enables the A-law compression.
+ * @enable: 0 - Disables A-law, 1 - Enables A-law
+ **/
+void ispccdc_enable_alaw(u8 enable)
+{
+       if (enable) {
+               omap_writel((omap_readl(ISPCCDC_ALAW)) | ISPCCDC_ALAW_CCDTBL,
+                                                               ISPCCDC_ALAW);
+       } else {
+               omap_writel((omap_readl(ISPCCDC_ALAW)) & ~ISPCCDC_ALAW_CCDTBL,
+                                                               ISPCCDC_ALAW);
+       }
+}
+EXPORT_SYMBOL(ispccdc_enable_alaw);
+
+/**
+ * ispccdc_config_imgattr - Configures the sensor image specific attributes.
+ * @colptn: Color pattern of the sensor.
+ **/
+void ispccdc_config_imgattr(u32 colptn)
+{
+       omap_writel(colptn, ISPCCDC_COLPTN);
+}
+EXPORT_SYMBOL(ispccdc_config_imgattr);
+
+/**
+ * ispccdc_config_shadow_registers - Programs the shadow registers for CCDC.
+ **/
+void ispccdc_config_shadow_registers(void)
+{
+       if (ccdc_use_lsc && !ispccdc_obj.lsc_en && (ispccdc_obj.ccdc_inpfmt ==
+                                                               CCDC_RAW))
+               ispccdc_enable_lsc(1);
+
+}
+EXPORT_SYMBOL(ispccdc_config_shadow_registers);
+
+/**
+ * ispccdc_try_size - Checks if requested Input/output dimensions are valid
+ * @input_w: input width for the CCDC in number of pixels per line
+ * @input_h: input height for the CCDC in number of lines
+ * @output_w: output width from the CCDC in number of pixels per line
+ * @output_h: output height for the CCDC in number of lines
+ *
+ * Calculates the number of pixels cropped if the reformater is disabled,
+ * Fills up the output width and height variables in the isp_ccdc structure.
+ *
+ * Returns 0 if successful, or -EINVAL if the input width is less than 2 pixels
+ **/
+int ispccdc_try_size(u32 input_w, u32 input_h, u32 *output_w, u32 *output_h)
+{
+       if (input_w < 2) {
+               DPRINTK_ISPCCDC("ISP_ERR: CCDC cannot handle input width less"
+                                                       " than 2 pixels\n");
+               return -EINVAL;
+       }
+
+       if (ispccdc_obj.crop_w)
+               *output_w = ispccdc_obj.crop_w;
+       else
+               *output_w = input_w;
+
+       if (ispccdc_obj.crop_h)
+               *output_h = ispccdc_obj.crop_h;
+       else
+               *output_h = input_h;
+
+       if ((!ispccdc_obj.refmt_en) && (ispccdc_obj.ccdc_outfmt !=
+                                                       CCDC_OTHERS_MEM))
+               *output_h -= 1;
+
+       if ((ispccdc_obj.ccdc_outfmt == CCDC_OTHERS_MEM) ||
+                                               (ispccdc_obj.ccdc_outfmt ==
+                                               CCDC_OTHERS_VP_MEM)) {
+               if (*output_w % 16) {
+                       *output_w -= (*output_w % 16);
+                       *output_w += 16;
+               }
+       }
+
+       ispccdc_obj.ccdcout_w = *output_w;
+       ispccdc_obj.ccdcout_h = *output_h;
+       ispccdc_obj.ccdcin_w = input_w;
+       ispccdc_obj.ccdcin_h = input_h;
+
+       DPRINTK_ISPCCDC("try size: ccdcin_w=%u,ccdcin_h=%u,ccdcout_w=%u,"
+                                                       " ccdcout_h=%u\n",
+                                                       ispccdc_obj.ccdcin_w,
+                                                       ispccdc_obj.ccdcin_h,
+                                                       ispccdc_obj.ccdcout_w,
+                                                       ispccdc_obj.ccdcout_h);
+
+       return 0;
+}
+EXPORT_SYMBOL(ispccdc_try_size);
+
+/**
+ * ispccdc_config_size - Configure the dimensions of the CCDC input/output
+ * @input_w: input width for the CCDC in number of pixels per line
+ * @input_h: input height for the CCDC in number of lines
+ * @output_w: output width from the CCDC in number of pixels per line
+ * @output_h: output height for the CCDC in number of lines
+ *
+ * Configures the appropriate values stored in the isp_ccdc structure to
+ * HORZ/VERT_INFO registers and the VP_OUT depending on whether the image
+ * is stored in memory or given to the another module in the ISP pipeline.
+ *
+ * Returns 0 if successful, or -EINVAL if try_size was not called before to
+ * validate the requested dimensions.
+ **/
+int ispccdc_config_size(u32 input_w, u32 input_h, u32 output_w, u32 output_h)
+{
+       DPRINTK_ISPCCDC("config size: input_w=%u, input_h=%u, output_w=%u,"
+                                                       " output_h=%u\n",
+                                                       input_w, input_h,
+                                                       output_w, output_h);
+       if ((output_w != ispccdc_obj.ccdcout_w) || (output_h !=
+                                               ispccdc_obj.ccdcout_h)) {
+               DPRINTK_ISPCCDC("ISP_ERR : ispccdc_try_size should"
+                                       " be called before config size\n");
+               return -EINVAL;
+       }
+
+       if (ispccdc_obj.ccdc_outfmt == CCDC_OTHERS_VP) {
+               omap_writel((ispccdc_obj.ccdcin_woffset <<
+                                       ISPCCDC_FMT_HORZ_FMTSPH_SHIFT) |
+                                       (ispccdc_obj.ccdcin_w <<
+                                       ISPCCDC_FMT_HORZ_FMTLNH_SHIFT),
+                                       ISPCCDC_FMT_HORZ);
+               omap_writel((ispccdc_obj.ccdcin_hoffset <<
+                                       ISPCCDC_FMT_VERT_FMTSLV_SHIFT) |
+                                       (ispccdc_obj.ccdcin_h <<
+                                       ISPCCDC_FMT_VERT_FMTLNV_SHIFT),
+                                       ISPCCDC_FMT_VERT);
+               omap_writel((ispccdc_obj.ccdcout_w <<
+                                       ISPCCDC_VP_OUT_HORZ_NUM_SHIFT) |
+                                       (ispccdc_obj.ccdcout_h <<
+                                       ISPCCDC_VP_OUT_VERT_NUM_SHIFT),
+                                       ISPCCDC_VP_OUT);
+               omap_writel((((ispccdc_obj.ccdcout_h - 25) &
+                                       ISPCCDC_VDINT_0_MASK) <<
+                                       ISPCCDC_VDINT_0_SHIFT) |
+                                       ((50 & ISPCCDC_VDINT_1_MASK) <<
+                                       ISPCCDC_VDINT_1_SHIFT), ISPCCDC_VDINT);
+
+       } else if (ispccdc_obj.ccdc_outfmt == CCDC_OTHERS_MEM) {
+               if (cpu_is_omap3410()) {
+                       omap_writel(0 << ISPCCDC_HORZ_INFO_SPH_SHIFT |
+                                               ((ispccdc_obj.ccdcout_w - 1) <<
+                                               ISPCCDC_HORZ_INFO_NPH_SHIFT),
+                                               ISPCCDC_HORZ_INFO);
+               } else {
+                       omap_writel(1 << ISPCCDC_HORZ_INFO_SPH_SHIFT |
+                                               ((ispccdc_obj.ccdcout_w - 1) <<
+                                               ISPCCDC_HORZ_INFO_NPH_SHIFT),
+                                               ISPCCDC_HORZ_INFO);
+               }
+               omap_writel(0 << ISPCCDC_VERT_START_SLV0_SHIFT,
+                                                       ISPCCDC_VERT_START);
+               omap_writel((ispccdc_obj.ccdcout_h - 1) <<
+                                               ISPCCDC_VERT_LINES_NLV_SHIFT,
+                                               ISPCCDC_VERT_LINES);
+
+               ispccdc_config_outlineoffset(ispccdc_obj.ccdcout_w * 2, 0, 0);
+               omap_writel((((ispccdc_obj.ccdcout_h - 1) &
+                                       ISPCCDC_VDINT_0_MASK) <<
+                                       ISPCCDC_VDINT_0_SHIFT) |
+                                       ((50 & ISPCCDC_VDINT_1_MASK) <<
+                                       ISPCCDC_VDINT_1_SHIFT), ISPCCDC_VDINT);
+       } else if (ispccdc_obj.ccdc_outfmt == CCDC_OTHERS_VP_MEM) {
+               omap_writel((1 << ISPCCDC_FMT_HORZ_FMTSPH_SHIFT) |
+                                       (ispccdc_obj.ccdcin_w <<
+                                       ISPCCDC_FMT_HORZ_FMTLNH_SHIFT),
+                                       ISPCCDC_FMT_HORZ);
+               omap_writel((0 << ISPCCDC_FMT_VERT_FMTSLV_SHIFT) |
+                                       ((ispccdc_obj.ccdcin_h) <<
+                                       ISPCCDC_FMT_VERT_FMTLNV_SHIFT),
+                                       ISPCCDC_FMT_VERT);
+               omap_writel((ispccdc_obj.ccdcout_w
+                                       << ISPCCDC_VP_OUT_HORZ_NUM_SHIFT) |
+                                       (ispccdc_obj.ccdcout_h <<
+                                       ISPCCDC_VP_OUT_VERT_NUM_SHIFT),
+                                       ISPCCDC_VP_OUT);
+               omap_writel(0 << ISPCCDC_HORZ_INFO_SPH_SHIFT |
+                                       ((ispccdc_obj.ccdcout_w - 1) <<
+                                       ISPCCDC_HORZ_INFO_NPH_SHIFT),
+                                       ISPCCDC_HORZ_INFO);
+               omap_writel(0 << ISPCCDC_VERT_START_SLV0_SHIFT,
+                                       ISPCCDC_VERT_START);
+               omap_writel((ispccdc_obj.ccdcout_h - 1) <<
+                                       ISPCCDC_VERT_LINES_NLV_SHIFT,
+                                       ISPCCDC_VERT_LINES);
+               ispccdc_config_outlineoffset(ispccdc_obj.ccdcout_w * 2, 0, 0);
+               omap_writel((((ispccdc_obj.ccdcout_h - 25) &
+                                       ISPCCDC_VDINT_0_MASK) <<
+                                       ISPCCDC_VDINT_0_SHIFT) |
+                                       ((50 & ISPCCDC_VDINT_1_MASK) <<
+                                       ISPCCDC_VDINT_1_SHIFT), ISPCCDC_VDINT);
+       }
+
+       if (is_isplsc_activated()) {
+               if (ispccdc_obj.ccdc_inpfmt == CCDC_RAW) {
+                       ispccdc_config_lsc(&lsc_config);
+                       ispccdc_load_lsc(lsc_config.size);
+               }
+       }
+
+       return 0;
+}
+EXPORT_SYMBOL(ispccdc_config_size);
+
+/**
+ * ispccdc_config_outlineoffset - Configures the output line offset
+ * @offset: Must be twice the Output width and aligned on 32 byte boundary
+ * @oddeven: Specifies the odd/even line pattern to be chosen to store the
+ *           output.
+ * @numlines: Set the value 0-3 for +1-4lines, 4-7 for -1-4lines.
+ *
+ * - Configures the output line offset when stored in memory
+ * - Sets the odd/even line pattern to store the output
+ *    (EVENEVEN (1), ODDEVEN (2), EVENODD (3), ODDODD (4))
+ * - Configures the number of even and odd line fields in case of rearranging
+ * the lines.
+ *
+ * Returns 0 if successful, or -EINVAL if the offset is not in 32 byte
+ * boundary.
+ **/
+int ispccdc_config_outlineoffset(u32 offset, u8 oddeven, u8 numlines)
+{
+       if ((offset & ISP_32B_BOUNDARY_OFFSET) == offset)
+               omap_writel((offset & 0xFFFF), ISPCCDC_HSIZE_OFF);
+       else {
+               DPRINTK_ISPCCDC("ISP_ERR : Offset should be in 32 byte"
+                                                               " boundary");
+               return -EINVAL;
+       }
+
+       omap_writel((omap_readl(ISPCCDC_SDOFST) & (~ISPCCDC_SDOFST_FINV)),
+                                                       ISPCCDC_SDOFST);
+
+       omap_writel(omap_readl(ISPCCDC_SDOFST) & ISPCCDC_SDOFST_FOFST_1L,
+                                                       ISPCCDC_SDOFST);
+
+       switch (oddeven) {
+       case EVENEVEN:
+               omap_writel((omap_readl(ISPCCDC_SDOFST)) | ((numlines & 0x7) <<
+                                               ISPCCDC_SDOFST_LOFST0_SHIFT),
+                                               ISPCCDC_SDOFST);
+               break;
+       case ODDEVEN:
+               omap_writel((omap_readl(ISPCCDC_SDOFST)) | ((numlines & 0x7) <<
+                                               ISPCCDC_SDOFST_LOFST1_SHIFT),
+                                               ISPCCDC_SDOFST);
+               break;
+       case EVENODD:
+               omap_writel((omap_readl(ISPCCDC_SDOFST)) | ((numlines & 0x7) <<
+                                               ISPCCDC_SDOFST_LOFST2_SHIFT),
+                                               ISPCCDC_SDOFST);
+               break;
+       case ODDODD:
+               omap_writel((omap_readl(ISPCCDC_SDOFST)) | ((numlines & 0x7) <<
+                                               ISPCCDC_SDOFST_LOFST3_SHIFT),
+                                               ISPCCDC_SDOFST);
+               break;
+       default:
+               break;
+       }
+       return 0;
+}
+EXPORT_SYMBOL(ispccdc_config_outlineoffset);
+
+/**
+ * ispccdc_set_outaddr - Sets the memory address where the output will be saved
+ * @addr: 32-bit memory address aligned on 32 byte boundary.
+ *
+ * Sets the memory address where the output will be saved.
+ *
+ * Returns 0 if successful, or -EINVAL if the address is not in the 32 byte
+ * boundary.
+ **/
+int ispccdc_set_outaddr(u32 addr)
+{
+       if ((addr & ISP_32B_BOUNDARY_BUF) == addr) {
+               omap_writel(addr, ISPCCDC_SDR_ADDR);
+               return 0;
+       } else {
+               DPRINTK_ISPCCDC("ISP_ERR : Address should be in 32 byte"
+                                                               " boundary");
+               return -EINVAL;
+       }
+
+}
+EXPORT_SYMBOL(ispccdc_set_outaddr);
+
+/**
+ * ispccdc_enable - Enables the CCDC module.
+ * @enable: 0 Disables CCDC, 1 Enables CCDC
+ *
+ * Client should configure all the sub modules in CCDC before this.
+ **/
+void ispccdc_enable(u8 enable)
+{
+       if (enable) {
+               omap_writel(omap_readl(ISPCCDC_PCR) | (ISPCCDC_PCR_EN),
+                                                               ISPCCDC_PCR);
+       } else {
+               omap_writel(omap_readl(ISPCCDC_PCR) & ~(ISPCCDC_PCR_EN),
+                                                               ISPCCDC_PCR);
+       }
+
+}
+EXPORT_SYMBOL(ispccdc_enable);
+
+/**
+ * ispccdc_busy - Gets busy state of the CCDC.
+ **/
+int ispccdc_busy(void)
+{
+       return omap_readl(ISPCCDC_PCR) & ISPCCDC_PCR_BUSY;
+}
+EXPORT_SYMBOL(ispccdc_busy);
+
+/**
+ * ispccdc_save_context - Saves the values of the CCDC module registers
+ **/
+void ispccdc_save_context(void)
+{
+       DPRINTK_ISPCCDC("Saving context\n");
+       isp_save_context(ispccdc_reg_list);
+
+}
+EXPORT_SYMBOL(ispccdc_save_context);
+
+/**
+ * ispccdc_restore_context - Restores the values of the CCDC module registers
+ **/
+void ispccdc_restore_context(void)
+{
+       DPRINTK_ISPCCDC("Restoring context\n");
+       isp_restore_context(ispccdc_reg_list);
+}
+EXPORT_SYMBOL(ispccdc_restore_context);
+
+/**
+ * ispccdc_print_status - Prints the values of the CCDC Module registers
+ *
+ * Also prints other debug information stored in the CCDC module.
+ **/
+void ispccdc_print_status(void)
+{
+       if (!is_ispccdc_debug_enabled())
+               return;
+
+       DPRINTK_ISPCCDC("Module in use =%d\n", ispccdc_obj.ccdc_inuse);
+       DPRINTK_ISPCCDC("Accepted CCDC Input (width = %d,Height = %d)\n",
+                                                       ispccdc_obj.ccdcin_w,
+                                                       ispccdc_obj.ccdcin_h);
+       DPRINTK_ISPCCDC("Accepted CCDC Output (width = %d,Height = %d)\n",
+                                                       ispccdc_obj.ccdcout_w,
+                                                       ispccdc_obj.ccdcout_h);
+       DPRINTK_ISPCCDC("###CCDC PCR=0x%x\n", omap_readl(ISPCCDC_PCR));
+       DPRINTK_ISPCCDC("ISP_CTRL =0x%x\n", omap_readl(ISP_CTRL));
+       switch (ispccdc_obj.ccdc_inpfmt) {
+       case CCDC_RAW:
+               DPRINTK_ISPCCDC("ccdc input format is CCDC_RAW\n");
+               break;
+       case CCDC_YUV_SYNC:
+               DPRINTK_ISPCCDC("ccdc input format is CCDC_YUV_SYNC\n");
+               break;
+       case CCDC_YUV_BT:
+               DPRINTK_ISPCCDC("ccdc input format is CCDC_YUV_BT\n");
+               break;
+       }
+
+       switch (ispccdc_obj.ccdc_outfmt) {
+       case CCDC_OTHERS_VP:
+               DPRINTK_ISPCCDC("ccdc output format is CCDC_OTHERS_VP\n");
+               break;
+       case CCDC_OTHERS_MEM:
+               DPRINTK_ISPCCDC("ccdc output format is CCDC_OTHERS_MEM\n");
+               break;
+       case CCDC_YUV_RSZ:
+               DPRINTK_ISPCCDC("ccdc output format is CCDC_YUV_RSZ\n");
+               break;
+       }
+
+       DPRINTK_ISPCCDC("###ISP_CTRL in ccdc =0x%x\n", omap_readl(ISP_CTRL));
+       DPRINTK_ISPCCDC("###ISP_IRQ0ENABLE in ccdc =0x%x\n",
+                                               omap_readl(ISP_IRQ0ENABLE));
+       DPRINTK_ISPCCDC("###ISP_IRQ0STATUS in ccdc =0x%x\n",
+                                               omap_readl(ISP_IRQ0STATUS));
+       DPRINTK_ISPCCDC("###CCDC SYN_MODE=0x%x\n",
+                                               omap_readl(ISPCCDC_SYN_MODE));
+       DPRINTK_ISPCCDC("###CCDC HORZ_INFO=0x%x\n",
+                                               omap_readl(ISPCCDC_HORZ_INFO));
+       DPRINTK_ISPCCDC("###CCDC VERT_START=0x%x\n",
+                                       omap_readl(ISPCCDC_VERT_START));
+       DPRINTK_ISPCCDC("###CCDC VERT_LINES=0x%x\n",
+                                       omap_readl(ISPCCDC_VERT_LINES));
+       DPRINTK_ISPCCDC("###CCDC CULLING=0x%x\n", omap_readl(ISPCCDC_CULLING));
+       DPRINTK_ISPCCDC("###CCDC HSIZE_OFF=0x%x\n",
+                                               omap_readl(ISPCCDC_HSIZE_OFF));
+       DPRINTK_ISPCCDC("###CCDC SDOFST=0x%x\n", omap_readl(ISPCCDC_SDOFST));
+       DPRINTK_ISPCCDC("###CCDC SDR_ADDR=0x%x\n",
+                                               omap_readl(ISPCCDC_SDR_ADDR));
+       DPRINTK_ISPCCDC("###CCDC CLAMP=0x%x\n", omap_readl(ISPCCDC_CLAMP));
+       DPRINTK_ISPCCDC("###CCDC COLPTN=0x%x\n", omap_readl(ISPCCDC_COLPTN));
+       DPRINTK_ISPCCDC("###CCDC CFG=0x%x\n", omap_readl(ISPCCDC_CFG));
+       DPRINTK_ISPCCDC("###CCDC VP_OUT=0x%x\n", omap_readl(ISPCCDC_VP_OUT));
+       DPRINTK_ISPCCDC("###CCDC_SDR_ADDR= 0x%x\n",
+                                               omap_readl(ISPCCDC_SDR_ADDR));
+       DPRINTK_ISPCCDC("###CCDC FMTCFG=0x%x\n", omap_readl(ISPCCDC_FMTCFG));
+       DPRINTK_ISPCCDC("###CCDC FMT_HORZ=0x%x\n",
+                                               omap_readl(ISPCCDC_FMT_HORZ));
+       DPRINTK_ISPCCDC("###CCDC FMT_VERT=0x%x\n",
+                                               omap_readl(ISPCCDC_FMT_VERT));
+       DPRINTK_ISPCCDC("###CCDC LSC_CONFIG=0x%x\n",
+                                       omap_readl(ISPCCDC_LSC_CONFIG));
+       DPRINTK_ISPCCDC("###CCDC LSC_INIT=0x%x\n",
+                                       omap_readl(ISPCCDC_LSC_INITIAL));
+       DPRINTK_ISPCCDC("###CCDC LSC_TABLE BASE=0x%x\n",
+                                       omap_readl(ISPCCDC_LSC_TABLE_BASE));
+       DPRINTK_ISPCCDC("###CCDC LSC TABLE OFFSET=0x%x\n",
+                                       omap_readl(ISPCCDC_LSC_TABLE_OFFSET));
+}
+EXPORT_SYMBOL(ispccdc_print_status);
+
+/**
+ * isp_ccdc_init - CCDC module initialization.
+ *
+ * Always returns 0
+ **/
+int __init isp_ccdc_init(void)
+{
+       ispccdc_obj.ccdc_inuse = 0;
+       ispccdc_config_crop(0, 0, 0, 0);
+       mutex_init(&ispccdc_obj.mutexlock);
+
+       if (is_isplsc_activated()) {
+               lsc_config.initial_x = 0;
+               lsc_config.initial_y = 0;
+               lsc_config.gain_mode_n = 0x6;
+               lsc_config.gain_mode_m = 0x6;
+               lsc_config.gain_format = 0x4;
+               lsc_config.offset = 0x60;
+               lsc_config.size = sizeof(ispccdc_lsc_tbl);
+               ccdc_use_lsc = 1;
+       }
+
+       return 0;
+}
+
+/**
+ * isp_ccdc_cleanup - CCDC module cleanup.
+ **/
+void isp_ccdc_cleanup(void)
+{
+       if (is_isplsc_activated()) {
+               if (lsc_initialized) {
+                       ispmmu_unmap(lsc_ispmmu_addr);
+                       kfree(lsc_gain_table);
+                       lsc_initialized = 0;
+               }
+       }
+
+       if (fpc_table_add_m != 0) {
+               ispmmu_unmap(fpc_table_add_m);
+               kfree(fpc_table_add);
+       }
+}
Index: linux-omap-2.6/drivers/media/video/isp/ispccdc.h
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/isp/ispccdc.h    2008-08-28 19:08:43.000000000 -0500
@@ -0,0 +1,210 @@
+/*
+ * drivers/media/video/isp/ispccdc.h
+ *
+ * Driver header file for CCDC module in TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments, Inc.
+ *
+ * Contributors:
+ *     Senthilvadivu Guruswamy <svadivu@ti.com>
+ *     Pallavi Kulkarni <p-kulkarni@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#ifndef OMAP_ISP_CCDC_H
+#define OMAP_ISP_CCDC_H
+
+#include <mach/isp_user.h>
+
+#ifndef CONFIG_ARCH_OMAP3410
+# define cpu_is_omap3410()             0
+# define is_isplsc_activated()         1
+#else
+# define cpu_is_omap3410()             1
+# define is_isplsc_activated()         0
+#endif
+
+#ifdef OMAP_ISPCCDC_DEBUG
+# define is_ispccdc_debug_enabled()            1
+#else
+# define is_ispccdc_debug_enabled()            0
+#endif
+
+/* Enumeration constants for CCDC input output format */
+enum ccdc_input {
+       CCDC_RAW,
+       CCDC_YUV_SYNC,
+       CCDC_YUV_BT,
+       CCDC_OTHERS
+};
+
+enum ccdc_output {
+       CCDC_YUV_RSZ,
+       CCDC_YUV_MEM_RSZ,
+       CCDC_OTHERS_VP,
+       CCDC_OTHERS_MEM,
+       CCDC_OTHERS_VP_MEM
+};
+
+/* Enumeration constants for the sync interface parameters */
+enum inpmode {
+       RAW,
+       YUV16,
+       YUV8
+};
+enum datasize {
+       DAT8,
+       DAT10,
+       DAT11,
+       DAT12
+};
+
+
+/**
+ * struct ispccdc_syncif - Structure for Sync Interface between sensor and CCDC
+ * @ccdc_mastermode: Master mode. 1 - Master, 0 - Slave.
+ * @fldstat: Field state. 0 - Odd Field, 1 - Even Field.
+ * @ipmod: Input mode.
+ * @datsz: Data size.
+ * @fldmode: 0 - Progressive, 1 - Interlaced.
+ * @datapol: 0 - Positive, 1 - Negative.
+ * @fldpol: 0 - Positive, 1 - Negative.
+ * @hdpol: 0 - Positive, 1 - Negative.
+ * @vdpol: 0 - Positive, 1 - Negative.
+ * @fldout: 0 - Input, 1 - Output.
+ * @hs_width: Width of the Horizontal Sync pulse, used for HS/VS Output.
+ * @vs_width: Width of the Vertical Sync pulse, used for HS/VS Output.
+ * @ppln: Number of pixels per line, used for HS/VS Output.
+ * @hlprf: Number of half lines per frame, used for HS/VS Output.
+ * @bt_r656_en: 1 - Enable ITU-R BT656 mode, 0 - Sync mode.
+ */
+struct ispccdc_syncif {
+       u8 ccdc_mastermode;
+       u8 fldstat;
+       enum inpmode ipmod;
+       enum datasize datsz;
+       u8 fldmode;
+       u8 datapol;
+       u8 fldpol;
+       u8 hdpol;
+       u8 vdpol;
+       u8 fldout;
+       u8 hs_width;
+       u8 vs_width;
+       u8 ppln;
+       u8 hlprf;
+       u8 bt_r656_en;
+};
+
+/**
+ * ispccdc_refmt - Structure for Reformatter parameters
+ * @lnalt: Line alternating mode enable. 0 - Enable, 1 - Disable.
+ * @lnum: Number of output lines from 1 input line. 1 to 4 lines.
+ * @plen_even: Number of program entries in even line minus 1.
+ * @plen_odd: Number of program entries in odd line minus 1.
+ * @prgeven0: Program entries 0-7 for even lines register
+ * @prgeven1: Program entries 8-15 for even lines register
+ * @prgodd0: Program entries 0-7 for odd lines register
+ * @prgodd1: Program entries 8-15 for odd lines register
+ * @fmtaddr0: Output line in which the original pixel is to be placed
+ * @fmtaddr1: Output line in which the original pixel is to be placed
+ * @fmtaddr2: Output line in which the original pixel is to be placed
+ * @fmtaddr3: Output line in which the original pixel is to be placed
+ * @fmtaddr4: Output line in which the original pixel is to be placed
+ * @fmtaddr5: Output line in which the original pixel is to be placed
+ * @fmtaddr6: Output line in which the original pixel is to be placed
+ * @fmtaddr7: Output line in which the original pixel is to be placed
+ */
+struct ispccdc_refmt {
+       u8 lnalt;
+       u8 lnum;
+       u8 plen_even;
+       u8 plen_odd;
+       u32 prgeven0;
+       u32 prgeven1;
+       u32 prgodd0;
+       u32 prgodd1;
+       u32 fmtaddr0;
+       u32 fmtaddr1;
+       u32 fmtaddr2;
+       u32 fmtaddr3;
+       u32 fmtaddr4;
+       u32 fmtaddr5;
+       u32 fmtaddr6;
+       u32 fmtaddr7;
+};
+
+int ispccdc_request(void);
+
+int ispccdc_free(void);
+
+int ispccdc_config_datapath(enum ccdc_input input, enum ccdc_output output);
+
+void ispccdc_config_crop(u32 left, u32 top, u32 height, u32 width);
+
+void ispccdc_config_sync_if(struct ispccdc_syncif syncif);
+
+int ispccdc_config_black_clamp(struct ispccdc_bclamp bclamp);
+
+void ispccdc_enable_black_clamp(u8 enable);
+
+int ispccdc_config_fpc(struct ispccdc_fpc fpc);
+
+void ispccdc_enable_fpc(u8 enable);
+
+void ispccdc_config_black_comp(struct ispccdc_blcomp blcomp);
+
+void ispccdc_config_vp(struct ispccdc_vp vp);
+
+void ispccdc_enable_vp(u8 enable);
+
+void ispccdc_config_reformatter(struct ispccdc_refmt refmt);
+
+void ispccdc_enable_reformatter(u8 enable);
+
+void ispccdc_config_culling(struct ispccdc_culling culling);
+
+void ispccdc_enable_lpf(u8 enable);
+
+void ispccdc_config_alaw(enum alaw_ipwidth ipwidth);
+
+void ispccdc_enable_alaw(u8 enable);
+
+int ispccdc_load_lsc(u32 table_size);
+
+void ispccdc_config_lsc(struct ispccdc_lsc_config *lsc_cfg);
+
+void ispccdc_enable_lsc(u8 enable);
+
+void ispccdc_config_imgattr(u32 colptn);
+
+void ispccdc_config_shadow_registers(void);
+
+int ispccdc_try_size(u32 input_w, u32 input_h, u32 *output_w, u32 *output_h);
+
+int ispccdc_config_size(u32 input_w, u32 input_h, u32 output_w, u32 output_h);
+
+int ispccdc_config_outlineoffset(u32 offset, u8 oddeven, u8 numlines);
+
+int ispccdc_set_outaddr(u32 addr);
+
+void ispccdc_enable(u8 enable);
+
+int ispccdc_busy(void);
+
+void ispccdc_save_context(void);
+
+void ispccdc_restore_context(void);
+
+void ispccdc_print_status(void);
+
+int omap34xx_isp_ccdc_config(void *userspace_add);
+
+#endif         /* OMAP_ISP_CCDC_H */
Index: linux-omap-2.6/drivers/media/video/isp/isph3a.c
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/isp/isph3a.c     2008-08-28 19:08:43.000000000 -0500
@@ -0,0 +1,915 @@
+/*
+ * drivers/media/video/isp/isph3a.c
+ *
+ * H3A module for TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ *
+ * Contributors:
+ *     Sergio Aguirre <saaguirre@ti.com>
+ *     Troy Laramy <t-laramy@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/syscalls.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <asm/cacheflush.h>
+
+#include "isp.h"
+#include "ispreg.h"
+#include "isph3a.h"
+#include "ispmmu.h"
+#include "isppreview.h"
+
+/**
+ * struct isph3a_aewb_buffer - AE, AWB frame stats buffer.
+ * @virt_addr: Virtual address to mmap the buffer.
+ * @phy_addr: Physical address of the buffer.
+ * @addr_align: Virtual Address 32 bytes aligned.
+ * @ispmmu_addr: Address of the buffer mapped by the ISPMMU.
+ * @mmap_addr: Mapped memory area of buffer. For userspace access.
+ * @locked: 1 - Buffer locked from write. 0 - Buffer can be overwritten.
+ * @frame_num: Frame number from which the statistics are taken.
+ * @next: Pointer to link next buffer.
+ */
+struct isph3a_aewb_buffer {
+       unsigned long virt_addr;
+       unsigned long phy_addr;
+       unsigned long addr_align;
+       unsigned long ispmmu_addr;
+       unsigned long mmap_addr;        /* For userspace */
+
+       u8 locked;
+       u16 frame_num;
+       struct isph3a_aewb_buffer *next;
+};
+
+/**
+ * struct isph3a_aewb_status - AE, AWB status.
+ * @initialized: 1 - Buffers initialized.
+ * @update: 1 - Update registers.
+ * @stats_req: 1 - Future stats requested.
+ * @stats_done: 1 - Stats ready for user.
+ * @frame_req: Number of frame requested for statistics.
+ * @h3a_buff: Array of statistics buffers to access.
+ * @stats_buf_size: Statistics buffer size.
+ * @min_buf_size: Minimum statisitics buffer size.
+ * @win_count: Window Count.
+ * @frame_count: Frame Count.
+ * @stats_wait: Wait primitive for locking/unlocking the stats request.
+ * @buffer_lock: Spinlock for statistics buffers access.
+ */
+static struct isph3a_aewb_status {
+       u8 initialized;
+       u8 update;
+       u8 stats_req;
+       u8 stats_done;
+       u16 frame_req;
+
+       struct isph3a_aewb_buffer h3a_buff[H3A_MAX_BUFF];
+       unsigned int stats_buf_size;
+       unsigned int min_buf_size;
+
+       u16 win_count;
+       u32 frame_count;
+       wait_queue_head_t stats_wait;
+       spinlock_t buffer_lock;         /* For stats buffers read/write sync */
+} aewbstat;
+
+/**
+ * struct isph3a_aewb_regs - Current value of AE, AWB configuration registers.
+ * reg_pcr: Peripheral control register.
+ * reg_win1: Control register.
+ * reg_start: Start position register.
+ * reg_blk: Black line register.
+ * reg_subwin: Configuration register.
+ */
+static struct isph3a_aewb_regs {
+       u32 reg_pcr;
+       u32 reg_win1;
+       u32 reg_start;
+       u32 reg_blk;
+       u32 reg_subwin;
+} aewb_regs;
+
+static struct isph3a_aewb_config aewb_config_local = {
+       .saturation_limit = 0x3FF,
+       .win_height = 0,
+       .win_width = 0,
+       .ver_win_count = 0,
+       .hor_win_count = 0,
+       .ver_win_start = 0,
+       .hor_win_start = 0,
+       .blk_ver_win_start = 0,
+       .blk_win_height = 0,
+       .subsample_ver_inc = 0,
+       .subsample_hor_inc = 0,
+       .alaw_enable = 0,
+       .aewb_enable = 0,
+};
+
+/* Structure for saving/restoring h3a module registers */
+static struct isp_reg isph3a_reg_list[] = {
+       {ISPH3A_AEWWIN1, 0},
+       {ISPH3A_AEWINSTART, 0},
+       {ISPH3A_AEWINBLK, 0},
+       {ISPH3A_AEWSUBWIN, 0},
+       {ISPH3A_AEWBUFST, 0},
+       {ISPH3A_AFPAX1, 0},
+       {ISPH3A_AFPAX2, 0},
+       {ISPH3A_AFPAXSTART, 0},
+       {ISPH3A_AFIIRSH, 0},
+       {ISPH3A_AFBUFST, 0},
+       {ISPH3A_AFCOEF010, 0},
+       {ISPH3A_AFCOEF032, 0},
+       {ISPH3A_AFCOEF054, 0},
+       {ISPH3A_AFCOEF076, 0},
+       {ISPH3A_AFCOEF098, 0},
+       {ISPH3A_AFCOEF0010, 0},
+       {ISPH3A_AFCOEF110, 0},
+       {ISPH3A_AFCOEF132, 0},
+       {ISPH3A_AFCOEF154, 0},
+       {ISPH3A_AFCOEF176, 0},
+       {ISPH3A_AFCOEF198, 0},
+       {ISPH3A_AFCOEF1010, 0},
+       {ISP_TOK_TERM, 0}
+};
+
+static struct ispprev_wbal h3awb_update;
+static struct isph3a_aewb_buffer *active_buff;
+static struct isph3a_aewb_xtrastats h3a_xtrastats[H3A_MAX_BUFF];
+static int camnotify;
+static int wb_update;
+static void isph3a_print_status(void);
+
+/**
+ * isph3a_aewb_setxtrastats - Receives extra statistics from prior frames.
+ * @xtrastats: Pointer to structure containing extra statistics fields like
+ *             field count and timestamp of frame.
+ *
+ * Called from update_vbq in camera driver
+ **/
+void isph3a_aewb_setxtrastats(struct isph3a_aewb_xtrastats *xtrastats)
+{
+       int i;
+       if (active_buff == NULL)
+               return;
+
+       for (i = 0; i < H3A_MAX_BUFF; i++) {
+               if (aewbstat.h3a_buff[i].frame_num == active_buff->frame_num) {
+                       if (i == 0) {
+                               if (aewbstat.h3a_buff[H3A_MAX_BUFF - 1].
+                                                               locked == 0)
+                                       h3a_xtrastats[H3A_MAX_BUFF - 1] =
+                                                               *xtrastats;
+                               else
+                                       h3a_xtrastats[H3A_MAX_BUFF - 2] =
+                                                               *xtrastats;
+                       } else if (i == 1) {
+                               if (aewbstat.h3a_buff[0].locked == 0)
+                                       h3a_xtrastats[0] = *xtrastats;
+                               else
+                                       h3a_xtrastats[H3A_MAX_BUFF - 1] =
+                                                               *xtrastats;
+                       } else {
+                               if (aewbstat.h3a_buff[i - 1].locked == 0)
+                                       h3a_xtrastats[i - 1] = *xtrastats;
+                               else
+                                       h3a_xtrastats[i - 2] = *xtrastats;
+                       }
+                       return;
+               }
+       }
+}
+EXPORT_SYMBOL(isph3a_aewb_setxtrastats);
+
+/**
+ * isph3a_aewb_enable - Enables AE, AWB engine in the H3A module.
+ * @enable: 1 - Enables the AE & AWB engine.
+ *
+ * Client should configure all the AE & AWB registers in H3A before this.
+ **/
+static void isph3a_aewb_enable(u8 enable)
+{
+       omap_writel(IRQ0STATUS_H3A_AWB_DONE_IRQ, ISP_IRQ0STATUS);
+
+       if (enable) {
+               aewb_regs.reg_pcr |= ISPH3A_PCR_AEW_EN;
+               omap_writel(omap_readl(ISPH3A_PCR) | ISPH3A_PCR_AEW_EN,
+                                                               ISPH3A_PCR);
+               DPRINTK_ISPH3A("    H3A enabled \n");
+       } else {
+               aewb_regs.reg_pcr &= ~ISPH3A_PCR_AEW_EN;
+               omap_writel(omap_readl(ISPH3A_PCR) & ~ISPH3A_PCR_AEW_EN,
+                                                               ISPH3A_PCR);
+               DPRINTK_ISPH3A("    H3A disabled \n");
+       }
+       aewb_config_local.aewb_enable = enable;
+}
+
+/**
+ * isph3a_update_wb - Updates WB parameters.
+ *
+ * Needs to be called when no ISP Preview processing is taking place.
+ **/
+void isph3a_update_wb(void)
+{
+       if (wb_update) {
+               isppreview_config_whitebalance(h3awb_update);
+               wb_update = 0;
+       }
+       return;
+}
+EXPORT_SYMBOL(isph3a_update_wb);
+
+/**
+ * isph3a_aewb_update_regs - Helper function to update h3a registers.
+ **/
+static void isph3a_aewb_update_regs(void)
+{
+       omap_writel(aewb_regs.reg_pcr, ISPH3A_PCR);
+       omap_writel(aewb_regs.reg_win1, ISPH3A_AEWWIN1);
+       omap_writel(aewb_regs.reg_start, ISPH3A_AEWINSTART);
+       omap_writel(aewb_regs.reg_blk, ISPH3A_AEWINBLK);
+       omap_writel(aewb_regs.reg_subwin, ISPH3A_AEWSUBWIN);
+
+       aewbstat.update = 0;
+       aewbstat.frame_count = 0;
+}
+
+/**
+ * isph3a_aewb_update_req_buffer - Helper function to update buffer cache pages
+ * @buffer: Pointer to structure
+ **/
+static void isph3a_aewb_update_req_buffer(struct isph3a_aewb_buffer *buffer)
+{
+       int size = aewbstat.stats_buf_size;
+
+       size = PAGE_ALIGN(size);
+       dmac_inv_range((void *)buffer->addr_align,
+               (void *)buffer->addr_align + size);
+}
+
+/**
+ * isph3a_aewb_stats_available - Check for stats available of specified frame.
+ * @aewbdata: Pointer to return AE AWB statistics data
+ *
+ * Returns 0 if successful, or -1 if statistics are unavailable.
+ **/
+static int isph3a_aewb_stats_available(struct isph3a_aewb_data *aewbdata)
+{
+       int i;
+       unsigned long irqflags;
+
+       spin_lock_irqsave(&aewbstat.buffer_lock, irqflags);
+       for (i = 0; i < H3A_MAX_BUFF; i++) {
+               if ((aewbdata->frame_number == aewbstat.h3a_buff[i].frame_num)
+                                       && (aewbstat.h3a_buff[i].frame_num !=
+                                       active_buff->frame_num)) {
+                       aewbstat.h3a_buff[i].locked = 1;
+                       spin_unlock_irqrestore(&aewbstat.buffer_lock, irqflags);
+                       isph3a_aewb_update_req_buffer(&aewbstat.h3a_buff[i]);
+                       aewbstat.h3a_buff[i].frame_num = 0;
+                       aewbdata->h3a_aewb_statistics_buf = (void *)
+                                               aewbstat.h3a_buff[i].mmap_addr;
+                       aewbdata->ts = h3a_xtrastats[i].ts;
+                       aewbdata->field_count = h3a_xtrastats[i].field_count;
+                       return 0;
+               }
+       }
+       spin_unlock_irqrestore(&aewbstat.buffer_lock, irqflags);
+
+       aewbdata->h3a_aewb_statistics_buf = NULL;
+       return -1;
+}
+
+/**
+ * isph3a_aewb_link_buffers - Helper function to link allocated buffers.
+ **/
+static void isph3a_aewb_link_buffers(void)
+{
+       int i;
+
+       for (i = 0; i < H3A_MAX_BUFF; i++) {
+               if ((i + 1) < H3A_MAX_BUFF) {
+                       aewbstat.h3a_buff[i].next = &aewbstat.h3a_buff[i + 1];
+                       h3a_xtrastats[i].next = &h3a_xtrastats[i + 1];
+               } else {
+                       aewbstat.h3a_buff[i].next = &aewbstat.h3a_buff[0];
+                       h3a_xtrastats[i].next = &h3a_xtrastats[0];
+               }
+       }
+}
+
+/**
+ * isph3a_aewb_unlock_buffers - Helper function to unlock all buffers.
+ **/
+static void isph3a_aewb_unlock_buffers(void)
+{
+       int i;
+       unsigned long irqflags;
+
+       spin_lock_irqsave(&aewbstat.buffer_lock, irqflags);
+       for (i = 0; i < H3A_MAX_BUFF; i++)
+               aewbstat.h3a_buff[i].locked = 0;
+
+       spin_unlock_irqrestore(&aewbstat.buffer_lock, irqflags);
+}
+
+/**
+ * isph3a_aewb_isr - Callback from ISP driver for H3A AEWB interrupt.
+ * @status: IRQ0STATUS in case of MMU error, 0 for H3A interrupt.
+ * @arg1: Not used as of now.
+ * @arg2: Not used as of now.
+ */
+static void isph3a_aewb_isr(unsigned long status, isp_vbq_callback_ptr arg1,
+                                                               void *arg2)
+{
+       u16 frame_align;
+
+       if ((H3A_AWB_DONE & status) != H3A_AWB_DONE)
+               return;
+
+       active_buff = active_buff->next;
+       if (active_buff->locked == 1)
+               active_buff = active_buff->next;
+       omap_writel(active_buff->ispmmu_addr, ISPH3A_AEWBUFST);
+
+       aewbstat.frame_count++;
+       frame_align = aewbstat.frame_count;
+       if (aewbstat.frame_count > MAX_FRAME_COUNT) {
+               aewbstat.frame_count = 1;
+               frame_align++;
+       }
+       active_buff->frame_num = aewbstat.frame_count;
+
+       if (aewbstat.stats_req) {
+               DPRINTK_ISPH3A("waiting for frame %d\n", aewbstat.frame_req);
+               if (frame_align >= (aewbstat.frame_req + 1)) {
+                       aewbstat.stats_req = 0;
+                       aewbstat.stats_done = 1;
+                       wake_up_interruptible(&aewbstat.stats_wait);
+               }
+       }
+
+       if (aewbstat.update)
+               isph3a_aewb_update_regs();
+
+       DPRINTK_ISPH3A(".");
+}
+
+/**
+ * isph3a_aewb_set_params - Helper function to check & store user given params.
+ * @user_cfg: Pointer to AE and AWB parameters struct.
+ *
+ * As most of them are busy-lock registers, need to wait until AEW_BUSY = 0 to
+ * program them during ISR.
+ *
+ * Returns 0 if successful, or -EINVAL if any of the parameters are invalid.
+ **/
+static int isph3a_aewb_set_params(struct isph3a_aewb_config *user_cfg)
+{
+       if (unlikely(user_cfg->saturation_limit > MAX_SATURATION_LIM)) {
+               printk(KERN_ERR "Invalid Saturation_limit: %d\n",
+                       user_cfg->saturation_limit);
+               return -EINVAL;
+       } else if (aewb_config_local.saturation_limit !=
+                                               user_cfg->saturation_limit) {
+               WRITE_SAT_LIM(aewb_regs.reg_pcr, user_cfg->saturation_limit);
+               aewb_config_local.saturation_limit =
+                                               user_cfg->saturation_limit;
+               aewbstat.update = 1;
+       }
+
+       if (aewb_config_local.alaw_enable != user_cfg->alaw_enable) {
+               WRITE_ALAW(aewb_regs.reg_pcr, user_cfg->alaw_enable);
+               aewb_config_local.alaw_enable = user_cfg->alaw_enable;
+               aewbstat.update = 1;
+       }
+
+       if (unlikely((user_cfg->win_height < MIN_WIN_H) ||
+                                       (user_cfg->win_height > MAX_WIN_H) ||
+                                       (user_cfg->win_height & 0x01))) {
+               printk(KERN_ERR "Invalid window height: %d\n",
+                                                       user_cfg->win_height);
+               return -EINVAL;
+       } else if (aewb_config_local.win_height != user_cfg->win_height) {
+               WRITE_WIN_H(aewb_regs.reg_win1, user_cfg->win_height);
+               aewb_config_local.win_height = user_cfg->win_height;
+               aewbstat.update = 1;
+       }
+
+       if (unlikely((user_cfg->win_width < MIN_WIN_W) ||
+                                       (user_cfg->win_width > MAX_WIN_W) ||
+                                       (user_cfg->win_width & 0x01))) {
+               printk(KERN_ERR "Invalid window width: %d\n",
+                                                       user_cfg->win_width);
+               return -EINVAL;
+       } else if (aewb_config_local.win_width != user_cfg->win_width) {
+               WRITE_WIN_W(aewb_regs.reg_win1, user_cfg->win_width);
+               aewb_config_local.win_width = user_cfg->win_width;
+               aewbstat.update = 1;
+       }
+
+       if (unlikely((user_cfg->ver_win_count < 1) ||
+                               (user_cfg->ver_win_count > MAX_WINVC))) {
+               printk(KERN_ERR "Invalid vertical window count: %d\n",
+                                               user_cfg->ver_win_count);
+               return -EINVAL;
+       } else if (aewb_config_local.ver_win_count
+                                               != user_cfg->ver_win_count) {
+               WRITE_VER_C(aewb_regs.reg_win1, user_cfg->ver_win_count);
+               aewb_config_local.ver_win_count = user_cfg->ver_win_count;
+               aewbstat.update = 1;
+       }
+
+       if (unlikely((user_cfg->hor_win_count < 1) ||
+                               (user_cfg->hor_win_count > MAX_WINHC))) {
+               printk(KERN_ERR "Invalid horizontal window count: %d\n",
+                                               user_cfg->hor_win_count);
+               return -EINVAL;
+       } else if (aewb_config_local.hor_win_count
+                                               != user_cfg->hor_win_count) {
+               WRITE_HOR_C(aewb_regs.reg_win1,
+                                       user_cfg->hor_win_count);
+               aewb_config_local.hor_win_count =
+                                       user_cfg->hor_win_count;
+               aewbstat.update = 1;
+       }
+
+       if (unlikely(user_cfg->ver_win_start > MAX_WINSTART)) {
+               printk(KERN_ERR "Invalid vertical window start: %d\n",
+                       user_cfg->ver_win_start);
+               return -EINVAL;
+       } else if (aewb_config_local.ver_win_start
+                                               != user_cfg->ver_win_start) {
+               WRITE_VER_WIN_ST(aewb_regs.reg_start, user_cfg->ver_win_start);
+               aewb_config_local.ver_win_start = user_cfg->ver_win_start;
+               aewbstat.update = 1;
+       }
+
+       if (unlikely(user_cfg->hor_win_start > MAX_WINSTART)) {
+               printk(KERN_ERR "Invalid horizontal window start: %d\n",
+                       user_cfg->hor_win_start);
+               return -EINVAL;
+       } else if (aewb_config_local.hor_win_start
+                               != user_cfg->hor_win_start){
+               WRITE_HOR_WIN_ST(aewb_regs.reg_start,
+                                        user_cfg->hor_win_start);
+               aewb_config_local.hor_win_start =
+                                       user_cfg->hor_win_start;
+               aewbstat.update = 1;
+       }
+
+       if (unlikely(user_cfg->blk_ver_win_start > MAX_WINSTART)) {
+               printk(KERN_ERR "Invalid black vertical window start: %d\n",
+                       user_cfg->blk_ver_win_start);
+               return -EINVAL;
+       } else if (aewb_config_local.blk_ver_win_start
+                               != user_cfg->blk_ver_win_start){
+               WRITE_BLK_VER_WIN_ST(aewb_regs.reg_blk,
+                                       user_cfg->blk_ver_win_start);
+               aewb_config_local.blk_ver_win_start =
+                                       user_cfg->blk_ver_win_start;
+               aewbstat.update = 1;
+       }
+
+       if (unlikely((user_cfg->blk_win_height < MIN_WIN_H)
+                       || (user_cfg->blk_win_height > MAX_WIN_H)
+                       || (user_cfg->blk_win_height & 0x01))) {
+               printk(KERN_ERR "Invalid black window height: %d\n",
+                       user_cfg->blk_win_height);
+               return -EINVAL;
+       } else if (aewb_config_local.blk_win_height
+                               != user_cfg->blk_win_height) {
+               WRITE_BLK_WIN_H(aewb_regs.reg_blk,
+                               user_cfg->blk_win_height);
+               aewb_config_local.blk_win_height
+                               = user_cfg->blk_win_height;
+               aewbstat.update = 1;
+       }
+
+       if (unlikely((user_cfg->subsample_ver_inc < MIN_SUB_INC)
+                       || (user_cfg->subsample_ver_inc > MAX_SUB_INC)
+                       || (user_cfg->subsample_ver_inc & 0x01))) {
+               printk(KERN_ERR "Invalid vertical subsample increment: %d\n",
+                       user_cfg->subsample_ver_inc);
+               return -EINVAL;
+       } else if (aewb_config_local.subsample_ver_inc
+                               != user_cfg->subsample_ver_inc) {
+               WRITE_SUB_VER_INC(aewb_regs.reg_subwin,
+                                               user_cfg->subsample_ver_inc);
+               aewb_config_local.subsample_ver_inc
+                                       = user_cfg->subsample_ver_inc;
+               aewbstat.update = 1;
+       }
+
+       if (unlikely((user_cfg->subsample_hor_inc < MIN_SUB_INC)
+                       || (user_cfg->subsample_hor_inc > MAX_SUB_INC)
+                       || (user_cfg->subsample_hor_inc & 0x01))) {
+               printk(KERN_ERR "Invalid horizontal subsample increment: %d\n",
+                       user_cfg->subsample_hor_inc);
+               return -EINVAL;
+       } else if (aewb_config_local.subsample_hor_inc
+                               != user_cfg->subsample_hor_inc) {
+               WRITE_SUB_HOR_INC(aewb_regs.reg_subwin,
+                                               user_cfg->subsample_hor_inc);
+               aewb_config_local.subsample_hor_inc
+                                       = user_cfg->subsample_hor_inc;
+               aewbstat.update = 1;
+       }
+
+       if ((!aewbstat.initialized) || (0 == aewb_config_local.aewb_enable)) {
+               isph3a_aewb_update_regs();
+               aewbstat.initialized = 1;
+       }
+       return 0;
+}
+
+/**
+ * isph3a_aewb_munmap - Unmap kernel buffer memory from user space.
+ * @buffer: Pointer to structure containing buffer information.
+ *
+ * Always returns 0.
+ **/
+static int isph3a_aewb_munmap(struct isph3a_aewb_buffer *buffer)
+{
+       buffer->mmap_addr = 0;
+       return 0;
+}
+
+/**
+ * isph3a_aewb_mmap_buffers - Map buffer memory to user space.
+ * @buffer: Pointer to structure containing buffer information.
+ *
+ * Buffer passed need to already have a valid physical address:
+ *      buffer->phy_addr
+ *
+ * Returns user pointer as unsigned long in buffer->mmap_addr
+ **/
+static int isph3a_aewb_mmap_buffers(struct isph3a_aewb_buffer *buffer)
+{
+       struct vm_area_struct vma;
+       struct mm_struct *mm = current->mm;
+       int size = aewbstat.stats_buf_size;
+       unsigned long addr = 0;
+       unsigned long pgoff = 0, flags = MAP_SHARED | MAP_ANONYMOUS;
+       unsigned long prot = PROT_READ | PROT_WRITE;
+       void *pos = (void *)buffer->addr_align;
+
+       size = PAGE_ALIGN(size);
+
+       addr = get_unmapped_area(NULL, addr, size, pgoff, flags);
+       vma.vm_mm = mm;
+       vma.vm_start = addr;
+       vma.vm_end = addr + size;
+       vma.vm_flags = calc_vm_prot_bits(prot) | calc_vm_flag_bits(flags);
+       vma.vm_pgoff = pgoff;
+       vma.vm_file = NULL;
+       vma.vm_page_prot = vm_get_page_prot(vma.vm_flags);
+
+       while (size > 0) {
+               if (vm_insert_page(&vma, addr, vmalloc_to_page(pos)))
+                       return -EAGAIN;
+               addr += PAGE_SIZE;
+               pos += PAGE_SIZE;
+               size -= PAGE_SIZE;
+       }
+
+       buffer->mmap_addr = vma.vm_start;
+       return 0;
+}
+
+/**
+ * isph3a_aewb_configure - Configure AEWB regs, enable/disable H3A engine.
+ * @aewbcfg: Pointer to AEWB config structure.
+ *
+ * Returns 0 if successful, -EINVAL if aewbcfg pointer is NULL, -ENOMEM if
+ * was unable to allocate memory for the buffer, of other errors if H3A
+ * callback is not set or the parameters for AEWB are invalid.
+ **/
+int isph3a_aewb_configure(struct isph3a_aewb_config *aewbcfg)
+{
+       int ret = 0;
+       int i;
+       int win_count = 0;
+
+       if (NULL == aewbcfg) {
+               printk(KERN_ERR "Null argument in configuration. \n");
+               return -EINVAL;
+       }
+
+       if (!aewbstat.initialized) {
+               DPRINTK_ISPH3A("Setting callback for H3A\n");
+               ret = isp_set_callback(CBK_H3A_AWB_DONE, isph3a_aewb_isr,
+                                       (void *)NULL, (void *)NULL);
+               if (ret) {
+                       printk(KERN_ERR "No callback for H3A\n");
+                       return ret;
+               }
+       }
+
+       ret = isph3a_aewb_set_params(aewbcfg);
+       if (ret) {
+               printk(KERN_ERR "Invalid parameters! \n");
+               return ret;
+       }
+
+       win_count = (aewbcfg->ver_win_count * aewbcfg->hor_win_count);
+       win_count += aewbcfg->hor_win_count;
+       ret = (win_count / 8);
+       win_count += (win_count % 8) ? 1 : 0;
+       win_count += ret;
+
+       aewbstat.win_count = win_count;
+
+       if (aewbstat.stats_buf_size && ((win_count * AEWB_PACKET_SIZE) >
+                                               aewbstat.stats_buf_size)) {
+               DPRINTK_ISPH3A("There was a previous buffer... \n");
+               isph3a_aewb_enable(0);
+               for (i = 0; i < H3A_MAX_BUFF; i++) {
+                       isph3a_aewb_munmap(&aewbstat.h3a_buff[i]);
+                       ispmmu_unmap(aewbstat.h3a_buff[i].ispmmu_addr);
+                       dma_free_coherent(NULL, aewbstat.min_buf_size + 64,
+                                       (void *)aewbstat.h3a_buff[i].
+                                       virt_addr, (dma_addr_t)aewbstat.
+                                       h3a_buff[i].phy_addr);
+                       aewbstat.h3a_buff[i].virt_addr = 0;
+               }
+               aewbstat.stats_buf_size = 0;
+       }
+
+       if (!aewbstat.h3a_buff[0].virt_addr) {
+               aewbstat.stats_buf_size = win_count * AEWB_PACKET_SIZE;
+               aewbstat.min_buf_size = PAGE_ALIGN(aewbstat.stats_buf_size);
+
+               for (i = 0; i < H3A_MAX_BUFF; i++) {
+                       aewbstat.h3a_buff[i].virt_addr =
+                                       (unsigned long)dma_alloc_coherent(NULL,
+                                               aewbstat.min_buf_size,
+                                               (dma_addr_t *)
+                                               &aewbstat.h3a_buff[i].
+                                               phy_addr, GFP_KERNEL |
+                                               GFP_DMA);
+                       if (aewbstat.h3a_buff[i].virt_addr == 0) {
+                               printk(KERN_ERR "Can't acquire memory for "
+                                       "buffer[%d]\n", i);
+                               return -ENOMEM;
+                       }
+                       aewbstat.h3a_buff[i].addr_align =
+                                       aewbstat.h3a_buff[i].virt_addr;
+                       while ((aewbstat.h3a_buff[i].addr_align &
+                                                       0xFFFFFFC0) !=
+                                                       aewbstat.h3a_buff[i].
+                                                       addr_align)
+                               aewbstat.h3a_buff[i].addr_align++;
+                       aewbstat.h3a_buff[i].ispmmu_addr =
+                                                       ispmmu_map(aewbstat.
+                                                       h3a_buff[i].phy_addr,
+                                                       aewbstat.min_buf_size);
+               }
+               isph3a_aewb_unlock_buffers();
+               isph3a_aewb_link_buffers();
+
+               if (active_buff == NULL)
+                       active_buff = &aewbstat.h3a_buff[0];
+               omap_writel(active_buff->ispmmu_addr, ISPH3A_AEWBUFST);
+       }
+       for (i = 0; i < H3A_MAX_BUFF; i++) {
+               if (aewbstat.h3a_buff[i].mmap_addr) {
+                       isph3a_aewb_munmap(&aewbstat.h3a_buff[i]);
+                       DPRINTK_ISPH3A("We have munmaped buffer 0x%lX\n",
+                               aewbstat.h3a_buff[i].virt_addr);
+               }
+               isph3a_aewb_mmap_buffers(&aewbstat.h3a_buff[i]);
+               DPRINTK_ISPH3A("buff[%d] addr is:\n    virt    0x%lX\n"
+                                       "    aligned 0x%lX\n"
+                                       "    phys    0x%lX\n"
+                                       "    ispmmu  0x%08lX\n"
+                                       "    mmapped 0x%lX\n", i,
+                                       aewbstat.h3a_buff[i].virt_addr,
+                                       aewbstat.h3a_buff[i].addr_align,
+                                       aewbstat.h3a_buff[i].phy_addr,
+                                       aewbstat.h3a_buff[i].ispmmu_addr,
+                                       aewbstat.h3a_buff[i].mmap_addr);
+       }
+       isph3a_aewb_enable(aewbcfg->aewb_enable);
+       isph3a_print_status();
+
+       return 0;
+}
+EXPORT_SYMBOL(isph3a_aewb_configure);
+
+/**
+ * isph3a_aewb_request_statistics - REquest statistics and update gains in AEWB
+ * @aewbdata: Pointer to return AE AWB statistics data.
+ *
+ * This API allows the user to update White Balance gains, as well as
+ * exposure time and analog gain. It is also used to request frame
+ * statistics.
+ *
+ * Returns 0 if successful, -EINVAL when H3A engine is not enabled, or other
+ * errors when setting gains.
+ **/
+int isph3a_aewb_request_statistics(struct isph3a_aewb_data *aewbdata)
+{
+       int ret = 0;
+       u16 frame_diff = 0;
+       u16 frame_cnt = aewbstat.frame_count;
+       wait_queue_t wqt;
+
+       if (!aewb_config_local.aewb_enable) {
+               printk(KERN_ERR "H3A engine not enabled\n");
+               return -EINVAL;
+       }
+       aewbdata->h3a_aewb_statistics_buf = NULL;
+
+       DPRINTK_ISPH3A("User data received: \n");
+       DPRINTK_ISPH3A("Digital gain = 0x%04x\n", aewbdata->dgain);
+       DPRINTK_ISPH3A("WB gain b *=   0x%04x\n", aewbdata->wb_gain_b);
+       DPRINTK_ISPH3A("WB gain r *=   0x%04x\n", aewbdata->wb_gain_r);
+       DPRINTK_ISPH3A("WB gain gb =   0x%04x\n", aewbdata->wb_gain_gb);
+       DPRINTK_ISPH3A("WB gain gr =   0x%04x\n", aewbdata->wb_gain_gr);
+       DPRINTK_ISPH3A("ISP AEWB request status wait for interrupt\n");
+
+       if (aewbdata->update != 0) {
+               if (aewbdata->update & SET_DIGITAL_GAIN)
+                       h3awb_update.dgain = (u16)aewbdata->dgain;
+               if (aewbdata->update & SET_COLOR_GAINS) {
+                       h3awb_update.coef3 = (u8)aewbdata->wb_gain_b;
+                       h3awb_update.coef2 = (u8)aewbdata->wb_gain_gr;
+                       h3awb_update.coef1 = (u8)aewbdata->wb_gain_gb;
+                       h3awb_update.coef0 = (u8)aewbdata->wb_gain_r;
+               }
+               if (aewbdata->update & (SET_COLOR_GAINS | SET_DIGITAL_GAIN))
+                       wb_update = 1;
+
+               if (aewbdata->update & REQUEST_STATISTICS) {
+                       isph3a_aewb_unlock_buffers();
+
+                       DPRINTK_ISPH3A("Stats available?\n");
+                       ret = isph3a_aewb_stats_available(aewbdata);
+                       if (!ret)
+                               goto out;
+
+                       DPRINTK_ISPH3A("Stats in near future?\n");
+                       if (aewbdata->frame_number > frame_cnt) {
+                               frame_diff = aewbdata->frame_number - frame_cnt;
+                       } else if (aewbdata->frame_number < frame_cnt) {
+                               if ((frame_cnt > (MAX_FRAME_COUNT -
+                                                       MAX_FUTURE_FRAMES))
+                                                       && (aewbdata->
+                                                       frame_number
+                                                       < MAX_FRAME_COUNT))
+                                       frame_diff = aewbdata->frame_number
+                                                       + MAX_FRAME_COUNT
+                                                       - frame_cnt;
+                               else {
+                                       frame_diff = MAX_FUTURE_FRAMES + 1;
+                                       aewbdata->h3a_aewb_statistics_buf =
+                                                                       NULL;
+                               }
+                       }
+
+                       if (frame_diff > MAX_FUTURE_FRAMES) {
+                               printk(KERN_ERR "Invalid frame requested\n");
+
+                       } else if (!camnotify) {
+                               aewbstat.frame_req = aewbdata->frame_number;
+                               aewbstat.stats_req = 1;
+                               aewbstat.stats_done = 0;
+                               init_waitqueue_entry(&wqt, current);
+                               ret = wait_event_interruptible
+                                               (aewbstat.stats_wait,
+                                               aewbstat.stats_done == 1);
+                               if (ret < 0)
+                                       return ret;
+
+                               DPRINTK_ISPH3A("ISP AEWB request status"
+                                               " interrupt raised\n");
+                               ret = isph3a_aewb_stats_available(aewbdata);
+                               if (ret) {
+                                       DPRINTK_ISPH3A
+                                               ("After waiting for stats,"
+                                               " stats not available!!\n");
+                               }
+                       }
+               }
+       }
+out:
+       aewbdata->curr_frame = aewbstat.frame_count;
+
+       return 0;
+}
+EXPORT_SYMBOL(isph3a_aewb_request_statistics);
+
+/**
+ * isph3a_aewb_init - Module Initialisation.
+ *
+ * Always returns 0.
+ **/
+int __init isph3a_aewb_init(void)
+{
+       memset(&aewbstat, 0, sizeof(aewbstat));
+       memset(&aewb_regs, 0, sizeof(aewb_regs));
+
+       init_waitqueue_head(&aewbstat.stats_wait);
+       spin_lock_init(&aewbstat.buffer_lock);
+       return 0;
+}
+
+/**
+ * isph3a_aewb_cleanup - Module exit.
+ **/
+void __exit isph3a_aewb_cleanup(void)
+{
+       int i;
+       isph3a_aewb_enable(0);
+       isp_unset_callback(CBK_H3A_AWB_DONE);
+
+       if (aewbstat.h3a_buff) {
+               for (i = 0; i < H3A_MAX_BUFF; i++) {
+                       ispmmu_unmap(aewbstat.h3a_buff[i].ispmmu_addr);
+                       dma_free_coherent(NULL, aewbstat.min_buf_size + 64,
+                                       (void *)aewbstat.h3a_buff[i].
+                                       virt_addr, (dma_addr_t)aewbstat.
+                                       h3a_buff[i].phy_addr);
+               }
+       }
+       memset(&aewbstat, 0, sizeof(aewbstat));
+       memset(&aewb_regs, 0, sizeof(aewb_regs));
+}
+
+/**
+ * isph3a_print_status - Debug print. Values of H3A related registers.
+ **/
+static void isph3a_print_status(void)
+{
+       DPRINTK_ISPH3A("ISPH3A_PCR = 0x%08x\n", omap_readl(ISPH3A_PCR));
+       DPRINTK_ISPH3A("ISPH3A_AEWWIN1 = 0x%08x\n",
+                                               omap_readl(ISPH3A_AEWWIN1));
+       DPRINTK_ISPH3A("ISPH3A_AEWINSTART = 0x%08x\n",
+                                               omap_readl(ISPH3A_AEWINSTART));
+       DPRINTK_ISPH3A("ISPH3A_AEWINBLK = 0x%08x\n",
+                                               omap_readl(ISPH3A_AEWINBLK));
+       DPRINTK_ISPH3A("ISPH3A_AEWSUBWIN = 0x%08x\n",
+                                               omap_readl(ISPH3A_AEWSUBWIN));
+       DPRINTK_ISPH3A("ISPH3A_AEWBUFST = 0x%08x\n",
+                                               omap_readl(ISPH3A_AEWBUFST));
+       DPRINTK_ISPH3A("stats windows = %d\n", aewbstat.win_count);
+       DPRINTK_ISPH3A("stats buff size = %d\n", aewbstat.stats_buf_size);
+}
+
+/**
+ * isph3a_notify - Unblocks user request for statistics when camera is off
+ * @notify: 1 - Camera is turned off
+ *
+ * Used when the user has requested statistics about a future frame, but the
+ * camera is turned off before it happens, and this function unblocks the
+ * request so the user can continue in its program.
+ **/
+void isph3a_notify(int notify)
+{
+       camnotify = notify;
+       if (camnotify && aewbstat.initialized) {
+               printk(KERN_DEBUG "Warning Camera Off \n");
+               aewbstat.stats_req = 0;
+               aewbstat.stats_done = 1;
+               wake_up_interruptible(&aewbstat.stats_wait);
+       }
+}
+EXPORT_SYMBOL(isph3a_notify);
+
+/**
+ * isph3a_save_context - Saves the values of the h3a module registers.
+ **/
+void isph3a_save_context(void)
+{
+       DPRINTK_ISPH3A(" Saving context\n");
+       isp_save_context(isph3a_reg_list);
+}
+EXPORT_SYMBOL(isph3a_save_context);
+
+/**
+ * isph3a_restore_context - Restores the values of the h3a module registers.
+ **/
+void isph3a_restore_context(void)
+{
+       DPRINTK_ISPH3A(" Restoring context\n");
+       isp_restore_context(isph3a_reg_list);
+}
+EXPORT_SYMBOL(isph3a_restore_context);
Index: linux-omap-2.6/drivers/media/video/isp/isph3a.h
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/isp/isph3a.h     2008-08-28 19:08:43.000000000 -0500
@@ -0,0 +1,139 @@
+/*
+ * drivers/media/video/isp/isph3a.h
+ *
+ * Include file for H3A module in TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments, Inc.
+ *
+ * Contributors:
+ *     Sergio Aguirre <saaguirre@ti.com>
+ *     Troy Laramy <t-laramy@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#ifndef OMAP_ISP_H3A_H
+#define OMAP_ISP_H3A_H
+
+#include <mach/isp_user.h>
+
+#define AEWB_PACKET_SIZE       16
+#define H3A_MAX_BUFF           5
+
+/* Flags for changed registers */
+#define PCR_CHNG               (1 << 0)
+#define AEWWIN1_CHNG           (1 << 1)
+#define AEWINSTART_CHNG                (1 << 2)
+#define AEWINBLK_CHNG          (1 << 3)
+#define AEWSUBWIN_CHNG         (1 << 4)
+#define PRV_WBDGAIN_CHNG       (1 << 5)
+#define PRV_WBGAIN_CHNG                (1 << 6)
+
+/* Flags for update field */
+#define REQUEST_STATISTICS     (1 << 0)
+#define SET_COLOR_GAINS                (1 << 1)
+#define SET_DIGITAL_GAIN       (1 << 2)
+#define SET_EXPOSURE           (1 << 3)
+#define SET_ANALOG_GAIN                (1 << 4)
+
+#define MAX_SATURATION_LIM     1023
+#define MIN_WIN_H              2
+#define MAX_WIN_H              256
+#define MIN_WIN_W              6
+#define MAX_WIN_W              256
+#define MAX_WINVC              128
+#define MAX_WINHC              36
+#define MAX_WINSTART           4095
+#define MIN_SUB_INC            2
+#define MAX_SUB_INC            32
+
+
+/* ISPH3A REGISTERS bits */
+#define ISPH3A_PCR_AF_EN       (1 << 0)
+#define ISPH3A_PCR_AF_ALAW_EN  (1 << 1)
+#define ISPH3A_PCR_AF_MED_EN   (1 << 2)
+#define ISPH3A_PCR_AF_BUSY     (1 << 15)
+#define ISPH3A_PCR_AEW_EN      (1 << 16)
+#define ISPH3A_PCR_AEW_ALAW_EN (1 << 17)
+#define ISPH3A_PCR_AEW_BUSY    (1 << 18)
+
+#define WRITE_SAT_LIM(reg, sat_limit)  \
+               (reg = (reg & (~(ISPH3A_PCR_AEW_AVE2LMT_MASK))) \
+                       | (sat_limit << ISPH3A_PCR_AEW_AVE2LMT_SHIFT))
+
+#define WRITE_ALAW(reg, alaw_en) \
+               (reg = (reg & (~(ISPH3A_PCR_AEW_ALAW_EN))) \
+                       | ((alaw_en & ISPH3A_PCR_AF_ALAW_EN) \
+                       << ISPH3A_PCR_AEW_ALAW_EN_SHIFT))
+
+#define WRITE_WIN_H(reg, height) \
+               (reg = (reg & (~(ISPH3A_AEWWIN1_WINH_MASK))) \
+                       | (((height >> 1) - 1) << ISPH3A_AEWWIN1_WINH_SHIFT))
+
+#define WRITE_WIN_W(reg, width) \
+               (reg = (reg & (~(ISPH3A_AEWWIN1_WINW_MASK))) \
+                       | (((width >> 1) - 1) << ISPH3A_AEWWIN1_WINW_SHIFT))
+
+#define WRITE_VER_C(reg, ver_count) \
+               (reg = (reg & ~(ISPH3A_AEWWIN1_WINVC_MASK)) \
+                       | ((ver_count - 1) << ISPH3A_AEWWIN1_WINVC_SHIFT))
+
+#define WRITE_HOR_C(reg, hor_count) \
+               (reg = (reg & ~(ISPH3A_AEWWIN1_WINHC_MASK)) \
+                       | ((hor_count - 1) << ISPH3A_AEWWIN1_WINHC_SHIFT))
+
+#define WRITE_VER_WIN_ST(reg, ver_win_st) \
+               (reg = (reg & ~(ISPH3A_AEWINSTART_WINSV_MASK)) \
+                       | (ver_win_st << ISPH3A_AEWINSTART_WINSV_SHIFT))
+
+#define WRITE_HOR_WIN_ST(reg, hor_win_st) \
+               (reg = (reg & ~(ISPH3A_AEWINSTART_WINSH_MASK)) \
+                       | (hor_win_st << ISPH3A_AEWINSTART_WINSH_SHIFT))
+
+#define WRITE_BLK_VER_WIN_ST(reg, blk_win_st) \
+               (reg = (reg & ~(ISPH3A_AEWINBLK_WINSV_MASK)) \
+                       | (blk_win_st << ISPH3A_AEWINBLK_WINSV_SHIFT))
+
+#define WRITE_BLK_WIN_H(reg, height) \
+               (reg = (reg & ~(ISPH3A_AEWINBLK_WINH_MASK)) \
+                       | (((height >> 1) - 1) << ISPH3A_AEWINBLK_WINH_SHIFT))
+
+#define WRITE_SUB_VER_INC(reg, sub_ver_inc) \
+               (reg = (reg & ~(ISPH3A_AEWSUBWIN_AEWINCV_MASK)) \
+               | (((sub_ver_inc >> 1) - 1) << ISPH3A_AEWSUBWIN_AEWINCV_SHIFT))
+
+#define WRITE_SUB_HOR_INC(reg, sub_hor_inc) \
+               (reg = (reg & ~(ISPH3A_AEWSUBWIN_AEWINCH_MASK)) \
+               | (((sub_hor_inc >> 1) - 1) << ISPH3A_AEWSUBWIN_AEWINCH_SHIFT))
+
+/**
+ * struct isph3a_aewb_xtrastats - Structure with extra statistics sent by cam.
+ * @ts: Timestamp of returned framestats.
+ * @field_count: Sequence number of returned framestats.
+ * @isph3a_aewb_xtrastats: Pointer to next buffer with extra stats.
+ */
+struct isph3a_aewb_xtrastats {
+       struct timeval ts;
+       unsigned long field_count;
+       struct isph3a_aewb_xtrastats *next;
+};
+
+void isph3a_aewb_setxtrastats(struct isph3a_aewb_xtrastats *xtrastats);
+
+int isph3a_aewb_configure(struct isph3a_aewb_config *aewbcfg);
+
+int isph3a_aewb_request_statistics(struct isph3a_aewb_data *aewbdata);
+
+void isph3a_save_context(void);
+
+void isph3a_restore_context(void);
+
+void isph3a_update_wb(void);
+
+#endif         /* OMAP_ISP_H3A_H */
Index: linux-omap-2.6/drivers/media/video/isp/isphist.c
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/isp/isphist.c    2008-08-28 19:08:43.000000000 -0500
@@ -0,0 +1,644 @@
+/*
+ * drivers/media/video/isp/isphist.c
+ *
+ * HISTOGRAM module for TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ *
+ * Contributors:
+ *     Sergio Aguirre <saaguirre@ti.com>
+ *     Troy Laramy <t-laramy@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/syscalls.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/types.h>
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <asm/cacheflush.h>
+
+#include "isp.h"
+#include "ispreg.h"
+#include "isphist.h"
+#include "ispmmu.h"
+#include "isppreview.h"
+
+/**
+ * struct isp_hist_status - Histogram status.
+ * @hist_enable: Enables the histogram module.
+ * @initialized: Flag to indicate that the module is correctly initializated.
+ * @frame_cnt: Actual frame count.
+ * @frame_req: Frame requested by user.
+ * @completed: Flag to indicate if a frame request is completed.
+ */
+struct isp_hist_status {
+       u8 hist_enable;
+       u8 initialized;
+       u8 frame_cnt;
+       u8 frame_req;
+       u8 completed;
+} histstat;
+
+/**
+ * struct isp_hist_buffer - Frame histogram buffer.
+ * @virt_addr: Virtual address to mmap the buffer.
+ * @phy_addr: Physical address of the buffer.
+ * @addr_align: Virtual Address 32 bytes aligned.
+ * @ispmmu_addr: Address of the buffer mapped by the ISPMMU.
+ * @mmap_addr: Mapped memory area of buffer. For userspace access.
+ */
+struct isp_hist_buffer {
+       unsigned long virt_addr;
+       unsigned long phy_addr;
+       unsigned long addr_align;
+       unsigned long ispmmu_addr;
+       unsigned long mmap_addr;
+} hist_buff;
+
+/**
+ * struct isp_hist_regs - Current value of Histogram configuration registers.
+ * @reg_pcr: Peripheral control register.
+ * @reg_cnt: Histogram control register.
+ * @reg_wb_gain: Histogram white balance gain register.
+ * @reg_r0_h: Region 0 horizontal register.
+ * @reg_r0_v: Region 0 vertical register.
+ * @reg_r1_h: Region 1 horizontal register.
+ * @reg_r1_v: Region 1 vertical register.
+ * @reg_r2_h: Region 2 horizontal register.
+ * @reg_r2_v: Region 2 vertical register.
+ * @reg_r3_h: Region 3 horizontal register.
+ * @reg_r3_v: Region 3 vertical register.
+ * @reg_hist_addr: Histogram address register.
+ * @reg_hist_data: Histogram data.
+ * @reg_hist_radd: Address register. When input data comes from mem.
+ * @reg_hist_radd_off: Address offset register. When input data comes from mem.
+ * @reg_h_v_info: Image size register. When input data comes from mem.
+ */
+static struct isp_hist_regs {
+       u32 reg_pcr;
+       u32 reg_cnt;
+       u32 reg_wb_gain;
+       u32 reg_r0_h;
+       u32 reg_r0_v;
+       u32 reg_r1_h;
+       u32 reg_r1_v;
+       u32 reg_r2_h;
+       u32 reg_r2_v;
+       u32 reg_r3_h;
+       u32 reg_r3_v;
+       u32 reg_hist_addr;
+       u32 reg_hist_data;
+       u32 reg_hist_radd;
+       u32 reg_hist_radd_off;
+       u32 reg_h_v_info;
+} hist_regs;
+
+/* Structure for saving/restoring histogram module registers */
+struct isp_reg isphist_reg_list[] = {
+       {ISPHIST_CNT, 0},
+       {ISPHIST_WB_GAIN, 0},
+       {ISPHIST_R0_HORZ, 0},
+       {ISPHIST_R0_VERT, 0},
+       {ISPHIST_R1_HORZ, 0},
+       {ISPHIST_R1_VERT, 0},
+       {ISPHIST_R2_HORZ, 0},
+       {ISPHIST_R2_VERT, 0},
+       {ISPHIST_R3_HORZ, 0},
+       {ISPHIST_R3_VERT, 0},
+       {ISPHIST_ADDR, 0},
+       {ISPHIST_RADD, 0},
+       {ISPHIST_RADD_OFF, 0},
+       {ISPHIST_H_V_INFO, 0},
+       {ISP_TOK_TERM, 0}
+};
+
+static void isp_hist_print_status(void);
+
+/**
+ * isp_hist_enable - Enables ISP Histogram submodule operation.
+ * @enable: 1 - Enables the histogram submodule.
+ *
+ * Client should configure all the Histogram registers before calling this
+ * function.
+ **/
+static void isp_hist_enable(u8 enable)
+{
+       if (enable) {
+               omap_writel(omap_readl(ISPHIST_PCR) | (ISPHIST_PCR_EN),
+                                                               ISPHIST_PCR);
+               DPRINTK_ISPHIST("   histogram enabled \n");
+       } else {
+               omap_writel(omap_readl(ISPHIST_PCR) & ~ISPHIST_PCR_EN,
+                                                               ISPHIST_PCR);
+               DPRINTK_ISPHIST("   histogram disabled \n");
+       }
+
+       histstat.hist_enable = enable;
+}
+
+/**
+ * isp_hist_update_regs - Helper function to update Histogram registers.
+ **/
+static void isp_hist_update_regs(void)
+{
+       omap_writel(hist_regs.reg_pcr, ISPHIST_PCR);
+       omap_writel(hist_regs.reg_cnt, ISPHIST_CNT);
+       omap_writel(hist_regs.reg_wb_gain, ISPHIST_WB_GAIN);
+       omap_writel(hist_regs.reg_r0_h, ISPHIST_R0_HORZ);
+       omap_writel(hist_regs.reg_r0_v, ISPHIST_R0_VERT);
+       omap_writel(hist_regs.reg_r1_h, ISPHIST_R1_HORZ);
+       omap_writel(hist_regs.reg_r1_v, ISPHIST_R1_VERT);
+       omap_writel(hist_regs.reg_r2_h, ISPHIST_R2_HORZ);
+       omap_writel(hist_regs.reg_r2_v, ISPHIST_R2_VERT);
+       omap_writel(hist_regs.reg_r3_h, ISPHIST_R3_HORZ);
+       omap_writel(hist_regs.reg_r3_v, ISPHIST_R3_VERT);
+       omap_writel(hist_regs.reg_hist_addr, ISPHIST_ADDR);
+       omap_writel(hist_regs.reg_hist_data, ISPHIST_DATA);
+       omap_writel(hist_regs.reg_hist_radd, ISPHIST_RADD);
+       omap_writel(hist_regs.reg_hist_radd_off, ISPHIST_RADD_OFF);
+       omap_writel(hist_regs.reg_h_v_info, ISPHIST_H_V_INFO);
+
+}
+
+/**
+ * isp_hist_isr - Callback from ISP driver for HIST interrupt.
+ * @status: IRQ0STATUS in case of MMU error, 0 for hist interrupt.
+ *          arg1 and arg2 Not used as of now.
+ **/
+static void isp_hist_isr(unsigned long status, isp_vbq_callback_ptr arg1,
+                                                               void *arg2)
+{
+       isp_hist_enable(0);
+
+       if ((HIST_DONE & status) != HIST_DONE)
+               return;
+
+       if (!histstat.completed) {
+               if (histstat.frame_req == histstat.frame_cnt) {
+                       histstat.frame_cnt = 0;
+                       histstat.frame_req = 0;
+                       histstat.completed = 1;
+               } else {
+                       isp_hist_enable(1);
+                       histstat.frame_cnt++;
+               }
+       }
+}
+
+/**
+ * isp_hist_reset_mem - clear Histogram memory before start stats engine.
+ *
+ * Returns 0 after histogram memory was cleared.
+ **/
+static int isp_hist_reset_mem(void)
+{
+       int i;
+
+       omap_writel((omap_readl(ISPHIST_CNT)) | ISPHIST_CNT_CLR_EN,
+                                                               ISPHIST_CNT);
+
+       for (i = 0; i < HIST_MEM_SIZE; i++)
+               omap_readl(ISPHIST_DATA);
+
+       omap_writel((omap_readl(ISPHIST_CNT)) & ~ISPHIST_CNT_CLR_EN,
+                                                               ISPHIST_CNT);
+
+       return 0;
+}
+
+/**
+ * isp_hist_set_params - Helper function to check and store user given params.
+ * @user_cfg: Pointer to user configuration structure.
+ *
+ * Returns 0 on success configuration.
+ **/
+static int isp_hist_set_params(struct isp_hist_config *user_cfg)
+{
+
+       int reg_num = 0;
+       int bit_shift = 0;
+
+
+       if (omap_readl(ISPHIST_PCR) & ISPHIST_PCR_BUSY_MASK)
+               return -EINVAL;
+
+       if (user_cfg->input_bit_width > MIN_BIT_WIDTH)
+               WRITE_DATA_SIZE(hist_regs.reg_cnt, 0);
+       else
+               WRITE_DATA_SIZE(hist_regs.reg_cnt, 1);
+
+       WRITE_SOURCE(hist_regs.reg_cnt, user_cfg->hist_source);
+
+       if (user_cfg->hist_source) {
+               WRITE_HV_INFO(hist_regs.reg_h_v_info, user_cfg->hist_h_v_info);
+
+               if ((user_cfg->hist_radd & ISP_32B_BOUNDARY_BUF) ==
+                   user_cfg->hist_radd) {
+                       WRITE_RADD(hist_regs.reg_hist_radd,
+                                  user_cfg->hist_radd);
+               } else {
+                       printk(KERN_ERR "Address should be in 32 byte boundary"
+                                                                       "\n");
+                       return -EINVAL;
+               }
+
+               if ((user_cfg->hist_radd_off & ISP_32B_BOUNDARY_OFFSET) ==
+                   user_cfg->hist_radd_off) {
+                       WRITE_RADD_OFF(hist_regs.reg_hist_radd_off,
+                                      user_cfg->hist_radd_off);
+               } else {
+                       printk(KERN_ERR "Offset should be in 32 byte boundary"
+                                                                       "\n");
+                       return -EINVAL;
+               }
+
+       }
+
+       isp_hist_reset_mem();
+       DPRINTK_ISPHIST("ISPHIST: Memory Cleared\n");
+       histstat.frame_req = user_cfg->hist_frames;
+
+       if (unlikely((user_cfg->wb_gain_R > MAX_WB_GAIN) ||
+                               (user_cfg->wb_gain_RG > MAX_WB_GAIN) ||
+                               (user_cfg->wb_gain_B > MAX_WB_GAIN) ||
+                               (user_cfg->wb_gain_BG > MAX_WB_GAIN))) {
+               printk(KERN_ERR "Invalid WB gain\n");
+               return -EINVAL;
+       } else {
+               WRITE_WB_R(hist_regs.reg_wb_gain, user_cfg->wb_gain_R);
+               WRITE_WB_RG(hist_regs.reg_wb_gain, user_cfg->wb_gain_RG);
+               WRITE_WB_B(hist_regs.reg_wb_gain, user_cfg->wb_gain_B);
+               WRITE_WB_BG(hist_regs.reg_wb_gain, user_cfg->wb_gain_BG);
+       }
+
+       /* Regions size and position */
+
+       if (user_cfg->num_regions > MAX_REGIONS)
+               return -EINVAL;
+
+       if (likely((user_cfg->reg0_hor & ISPHIST_REGHORIZ_HEND_MASK) -
+                                       ((user_cfg->reg0_hor &
+                                       ISPHIST_REGHORIZ_HSTART_MASK) >>
+                                       ISPHIST_REGHORIZ_HSTART_SHIFT))) {
+               WRITE_REG_HORIZ(hist_regs.reg_r0_h, user_cfg->reg0_hor);
+               reg_num++;
+       } else {
+               printk(KERN_ERR "Invalid Region parameters\n");
+               return -EINVAL;
+       }
+
+       if (likely((user_cfg->reg0_ver & ISPHIST_REGVERT_VEND_MASK)
+                    - ((user_cfg->reg0_ver & ISPHIST_REGVERT_VSTART_MASK)
+                       >> ISPHIST_REGVERT_VSTART_SHIFT))) {
+               WRITE_REG_VERT(hist_regs.reg_r0_v, user_cfg->reg0_ver);
+       } else {
+               printk(KERN_ERR "Invalid Region parameters\n");
+               return -EINVAL;
+       }
+
+       if (user_cfg->num_regions >= 1) {
+               if (likely((user_cfg->reg1_hor & ISPHIST_REGHORIZ_HEND_MASK) -
+                                       ((user_cfg->reg1_hor &
+                                       ISPHIST_REGHORIZ_HSTART_MASK) >>
+                                       ISPHIST_REGHORIZ_HSTART_SHIFT))) {
+                       WRITE_REG_HORIZ(hist_regs.reg_r1_h, user_cfg->reg1_hor);
+               } else {
+                       printk(KERN_ERR "Invalid Region parameters\n");
+                       return -EINVAL;
+               }
+
+               if (likely((user_cfg->reg1_ver & ISPHIST_REGVERT_VEND_MASK) -
+                                       ((user_cfg->reg1_ver &
+                                       ISPHIST_REGVERT_VSTART_MASK) >>
+                                       ISPHIST_REGVERT_VSTART_SHIFT))) {
+                       WRITE_REG_VERT(hist_regs.reg_r1_v, user_cfg->reg1_ver);
+               } else {
+                       printk(KERN_ERR "Invalid Region parameters\n");
+                       return -EINVAL;
+               }
+       }
+
+       if (user_cfg->num_regions >= 2) {
+               if (likely((user_cfg->reg2_hor & ISPHIST_REGHORIZ_HEND_MASK) -
+                                       ((user_cfg->reg2_hor &
+                                       ISPHIST_REGHORIZ_HSTART_MASK) >>
+                                       ISPHIST_REGHORIZ_HSTART_SHIFT))) {
+                       WRITE_REG_HORIZ(hist_regs.reg_r2_h, user_cfg->reg2_hor);
+               } else {
+                       printk(KERN_ERR "Invalid Region parameters\n");
+                       return -EINVAL;
+               }
+
+               if (likely((user_cfg->reg2_ver & ISPHIST_REGVERT_VEND_MASK) -
+                                       ((user_cfg->reg2_ver &
+                                       ISPHIST_REGVERT_VSTART_MASK) >>
+                                       ISPHIST_REGVERT_VSTART_SHIFT))) {
+                       WRITE_REG_VERT(hist_regs.reg_r2_v, user_cfg->reg2_ver);
+               } else {
+                       printk(KERN_ERR "Invalid Region parameters\n");
+                       return -EINVAL;
+               }
+       }
+
+       if (user_cfg->num_regions >= 3) {
+               if (likely((user_cfg->reg3_hor & ISPHIST_REGHORIZ_HEND_MASK) -
+                                       ((user_cfg->reg3_hor &
+                                       ISPHIST_REGHORIZ_HSTART_MASK) >>
+                                       ISPHIST_REGHORIZ_HSTART_SHIFT))) {
+                       WRITE_REG_HORIZ(hist_regs.reg_r3_h, user_cfg->reg3_hor);
+               } else {
+                       printk(KERN_ERR "Invalid Region parameters\n");
+                       return -EINVAL;
+               }
+
+               if (likely((user_cfg->reg3_ver & ISPHIST_REGVERT_VEND_MASK) -
+                                       ((user_cfg->reg3_ver &
+                                       ISPHIST_REGVERT_VSTART_MASK) >>
+                                       ISPHIST_REGVERT_VSTART_SHIFT))) {
+                       WRITE_REG_VERT(hist_regs.reg_r3_v, user_cfg->reg3_ver);
+               } else {
+                       printk(KERN_ERR "Invalid Region parameters\n");
+                       return -EINVAL;
+               }
+       }
+       reg_num = user_cfg->num_regions;
+       if (unlikely(((user_cfg->hist_bins > BINS_256) &&
+                               (user_cfg->hist_bins != BINS_32)) ||
+                               ((user_cfg->hist_bins == BINS_256) &&
+                               reg_num != 0) || ((user_cfg->hist_bins ==
+                               BINS_128) && reg_num >= 2))) {
+               printk(KERN_ERR "Invalid Bins Number: %d\n",
+                                                       user_cfg->hist_bins);
+               return -EINVAL;
+       } else {
+               WRITE_NUM_BINS(hist_regs.reg_cnt, user_cfg->hist_bins);
+       }
+
+       if ((user_cfg->input_bit_width > MAX_BIT_WIDTH) ||
+                               (user_cfg->input_bit_width < MIN_BIT_WIDTH)) {
+               printk(KERN_ERR "Invalid Bit Width: %d\n",
+                                               user_cfg->input_bit_width);
+               return -EINVAL;
+       } else {
+               switch (user_cfg->hist_bins) {
+               case BINS_256:
+                       bit_shift = user_cfg->input_bit_width - 8;
+                       break;
+               case BINS_128:
+                       bit_shift = user_cfg->input_bit_width - 7;
+                       break;
+               case BINS_64:
+                       bit_shift = user_cfg->input_bit_width - 6;
+                       break;
+               case BINS_32:
+                       bit_shift = user_cfg->input_bit_width - 5;
+                       break;
+               default:
+                       return -EINVAL;
+               }
+               WRITE_BIT_SHIFT(hist_regs.reg_cnt, bit_shift);
+       }
+
+       isp_hist_update_regs();
+       histstat.initialized = 1;
+
+       return 0;
+}
+
+/**
+ * isp_hist_mmap_buffer - Map buffer memory to user space.
+ * @buffer: Pointer to buffer structure.
+ * Helper function to mmap buffers to user space. Buffer passed need to
+ * already have a valid physical address: buffer->phy_addr. It returns user
+ * pointer as unsigned long in buffer->mmap_addr.
+ *
+ * Returns 0 on success buffer mapped.
+ **/
+static int isp_hist_mmap_buffer(struct isp_hist_buffer *buffer)
+{
+       struct vm_area_struct vma;
+       struct mm_struct *mm = current->mm;
+       int size = PAGE_SIZE;
+       unsigned long addr = 0;
+       unsigned long pgoff = 0, flags = MAP_SHARED | MAP_ANONYMOUS;
+       unsigned long prot = PROT_READ | PROT_WRITE;
+       void *pos = (void *)buffer->virt_addr;
+
+       size = PAGE_ALIGN(size);
+
+       addr = get_unmapped_area(NULL, addr, size, pgoff, flags);
+       vma.vm_mm = mm;
+       vma.vm_start = addr;
+       vma.vm_end = addr + size;
+       vma.vm_flags = calc_vm_prot_bits(prot) | calc_vm_flag_bits(flags);
+       vma.vm_pgoff = pgoff;
+       vma.vm_file = NULL;
+       vma.vm_page_prot = vm_get_page_prot(vma.vm_flags);
+
+       if (vm_insert_page(&vma, addr, vmalloc_to_page(pos)))
+               return -EAGAIN;
+
+       buffer->mmap_addr = vma.vm_start;
+       return 0;
+}
+
+/**
+ * isp_hist_configure - API to configure HIST registers.
+ * @histcfg: Pointer to user configuration structure.
+ *
+ * Returns 0 on success configuration.
+ **/
+int isp_hist_configure(struct isp_hist_config *histcfg)
+{
+
+       int ret = 0;
+
+       if (NULL == histcfg) {
+               printk(KERN_ERR "Null argument in configuration. \n");
+               return -EINVAL;
+       }
+
+       if (!histstat.initialized) {
+               DPRINTK_ISPHIST("Setting callback for HISTOGRAM\n");
+               ret = isp_set_callback(CBK_HIST_DONE, isp_hist_isr,
+                                               (void *)NULL, (void *)NULL);
+               if (ret) {
+                       printk(KERN_ERR "No callback for HIST\n");
+                       return ret;
+               }
+       }
+
+       ret = isp_hist_set_params(histcfg);
+       if (ret) {
+               printk(KERN_ERR "Invalid parameters! \n");
+               return ret;
+       }
+
+       if (hist_buff.virt_addr != 0) {
+               hist_buff.mmap_addr = 0;
+               ispmmu_unmap(hist_buff.ispmmu_addr);
+               dma_free_coherent(NULL, PAGE_SIZE, (void *)hist_buff.virt_addr,
+                                       (dma_addr_t)hist_buff.phy_addr);
+       }
+
+       hist_buff.virt_addr = (unsigned long)dma_alloc_coherent(NULL,
+                                               PAGE_SIZE, (dma_addr_t *)
+                                               &hist_buff.phy_addr,
+                                               GFP_KERNEL | GFP_DMA);
+       if (hist_buff.virt_addr == 0) {
+               printk(KERN_ERR "Can't acquire memory for ");
+               return -ENOMEM;
+       }
+
+       hist_buff.ispmmu_addr = ispmmu_map(hist_buff.phy_addr, PAGE_SIZE);
+
+       if (hist_buff.mmap_addr) {
+               hist_buff.mmap_addr = 0;
+               DPRINTK_ISPHIST("We have munmaped buffer 0x%lX\n",
+                               hist_buff.virt_addr);
+       }
+
+       isp_hist_mmap_buffer(&hist_buff);
+
+       histstat.frame_cnt = 0;
+       histstat.completed = 0;
+       isp_hist_enable(1);
+       isp_hist_print_status();
+
+       return 0;
+}
+EXPORT_SYMBOL(isp_hist_configure);
+
+/**
+ * isp_hist_request_statistics - Request statistics in Histogram.
+ * @histdata: Pointer to data structure.
+ *
+ * This API allows the user to request for histogram statistics.
+ *
+ * Returns 0 on successful request.
+ **/
+int isp_hist_request_statistics(struct isp_hist_data *histdata)
+{
+       int i;
+
+       if (omap_readl(ISPHIST_PCR) & ISPHIST_PCR_BUSY_MASK)
+               return -EBUSY;
+
+       if (!histstat.completed && histstat.initialized)
+               return -EINVAL;
+
+       omap_writel((omap_readl(ISPHIST_CNT)) | ISPHIST_CNT_CLR_EN,
+                                                               ISPHIST_CNT);
+       histdata->hist_statistics_buf = (u32 *)hist_buff.mmap_addr;
+
+       for (i = 0; i < HIST_MEM_SIZE; i++) {
+               *(histdata->hist_statistics_buf + i) =
+                                               omap_readl(ISPHIST_DATA);
+       }
+
+       omap_writel((omap_readl(ISPHIST_CNT)) & ~ISPHIST_CNT_CLR_EN,
+                                                               ISPHIST_CNT);
+       histstat.completed = 0;
+       return 0;
+}
+EXPORT_SYMBOL(isp_hist_request_statistics);
+
+/**
+ * isp_hist_init - Module Initialization.
+ *
+ * Returns 0 if successful.
+ **/
+int __init isp_hist_init(void)
+{
+       memset(&histstat, 0, sizeof(histstat));
+       memset(&hist_regs, 0, sizeof(hist_regs));
+
+       return 0;
+}
+
+/**
+ * isp_hist_cleanup - Module cleanup.
+ **/
+void __exit isp_hist_cleanup(void)
+{
+       isp_hist_enable(0);
+       mdelay(100);
+       isp_unset_callback(CBK_HIST_DONE);
+
+       if (hist_buff.ispmmu_addr) {
+               ispmmu_unmap(hist_buff.ispmmu_addr);
+               dma_free_coherent(NULL, PAGE_SIZE, (void *)hist_buff.virt_addr,
+                                       (dma_addr_t) hist_buff.phy_addr);
+       }
+
+       memset(&histstat, 0, sizeof(histstat));
+       memset(&hist_regs, 0, sizeof(hist_regs));
+}
+
+/**
+ * isphist_save_context - Saves the values of the histogram module registers.
+ **/
+void
+isphist_save_context(void)
+{
+       DPRINTK_ISPHIST(" Saving context\n");
+       isp_save_context(isphist_reg_list);
+}
+EXPORT_SYMBOL(isphist_save_context);
+
+/**
+ * isphist_restore_context - Restores the values of the histogram module regs.
+ **/
+void
+isphist_restore_context(void)
+{
+       DPRINTK_ISPHIST(" Restoring context\n");
+       isp_restore_context(isphist_reg_list);
+}
+EXPORT_SYMBOL(isphist_restore_context);
+
+/**
+ * isp_hist_print_status - Debug print
+ **/
+static void isp_hist_print_status(void)
+{
+       DPRINTK_ISPHIST("ISPHIST_PCR = 0x%08x\n", omap_readl(ISPHIST_PCR));
+       DPRINTK_ISPHIST("ISPHIST_CNT = 0x%08x\n", omap_readl(ISPHIST_CNT));
+       DPRINTK_ISPHIST("ISPHIST_WB_GAIN = 0x%08x\n",
+                                               omap_readl(ISPHIST_WB_GAIN));
+       DPRINTK_ISPHIST("ISPHIST_R0_HORZ = 0x%08x\n",
+                                               omap_readl(ISPHIST_R0_HORZ));
+       DPRINTK_ISPHIST("ISPHIST_R0_VERT = 0x%08x\n",
+                                               omap_readl(ISPHIST_R0_VERT));
+       DPRINTK_ISPHIST("ISPHIST_R1_HORZ = 0x%08x\n",
+                                               omap_readl(ISPHIST_R1_HORZ));
+       DPRINTK_ISPHIST("ISPHIST_R1_VERT = 0x%08x\n",
+                                               omap_readl(ISPHIST_R1_VERT));
+       DPRINTK_ISPHIST("ISPHIST_R2_HORZ = 0x%08x\n",
+                                               omap_readl(ISPHIST_R2_HORZ));
+       DPRINTK_ISPHIST("ISPHIST_R2_VERT = 0x%08x\n",
+                                               omap_readl(ISPHIST_R2_VERT));
+       DPRINTK_ISPHIST("ISPHIST_R3_HORZ = 0x%08x\n",
+                                               omap_readl(ISPHIST_R3_HORZ));
+       DPRINTK_ISPHIST("ISPHIST_R3_VERT = 0x%08x\n",
+                                               omap_readl(ISPHIST_R3_VERT));
+       DPRINTK_ISPHIST("ISPHIST_ADDR = 0x%08x\n", omap_readl(ISPHIST_ADDR));
+       DPRINTK_ISPHIST("ISPHIST_RADD = 0x%08x\n", omap_readl(ISPHIST_RADD));
+       DPRINTK_ISPHIST("ISPHIST_RADD_OFF = 0x%08x\n",
+                                               omap_readl(ISPHIST_RADD_OFF));
+       DPRINTK_ISPHIST("ISPHIST_H_V_INFO = 0x%08x\n",
+                                               omap_readl(ISPHIST_H_V_INFO));
+}
Index: linux-omap-2.6/drivers/media/video/isp/isphist.h
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/isp/isphist.h    2008-08-28 19:08:43.000000000 -0500
@@ -0,0 +1,97 @@
+/*
+ * drivers/media/video/isp/isphist.h
+ *
+ * Header file for HISTOGRAM module in TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments, Inc.
+ *
+ * Contributors:
+ *     Sergio Aguirre <saaguirre@ti.com>
+ *     Troy Laramy <t-laramy@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#ifndef OMAP_ISP_HIST_H
+#define OMAP_ISP_HIST_H
+
+#include <mach/isp_user.h>
+
+#define MAX_REGIONS            0x4
+#define MAX_WB_GAIN            255
+#define MIN_WB_GAIN            0x0
+#define MAX_BIT_WIDTH          14
+#define MIN_BIT_WIDTH          8
+
+#define ISPHIST_PCR_EN         (1 << 0)
+#define HIST_MEM_SIZE          1024
+#define ISPHIST_CNT_CLR_EN     (1 << 7)
+
+#define WRITE_SOURCE(reg, source)      \
+               (reg = (reg & ~(ISPHIST_CNT_SOURCE_MASK)) \
+               | (source << ISPHIST_CNT_SOURCE_SHIFT))
+
+#define WRITE_HV_INFO(reg, hv_info) \
+               (reg = ((reg & ~(ISPHIST_HV_INFO_MASK)) \
+               | (hv_info & ISPHIST_HV_INFO_MASK)))
+
+#define WRITE_RADD(reg, radd) \
+               (reg = (reg & ~(ISPHIST_RADD_MASK)) \
+               | (radd << ISPHIST_RADD_SHIFT))
+
+#define WRITE_RADD_OFF(reg, radd_off) \
+               (reg = (reg & ~(ISPHIST_RADD_OFF_MASK)) \
+               | (radd_off << ISPHIST_RADD_OFF_SHIFT))
+
+#define WRITE_BIT_SHIFT(reg, bit_shift) \
+               (reg = (reg & ~(ISPHIST_CNT_SHIFT_MASK)) \
+               | (bit_shift << ISPHIST_CNT_SHIFT_SHIFT))
+
+#define WRITE_DATA_SIZE(reg, data_size) \
+               (reg = (reg & ~(ISPHIST_CNT_DATASIZE_MASK)) \
+               | (data_size << ISPHIST_CNT_DATASIZE_SHIFT))
+
+#define WRITE_NUM_BINS(reg, num_bins) \
+               (reg = (reg & ~(ISPHIST_CNT_BINS_MASK)) \
+               | (num_bins << ISPHIST_CNT_BINS_SHIFT))
+
+#define WRITE_WB_R(reg, reg_wb_gain) \
+               reg = ((reg & ~(ISPHIST_WB_GAIN_WG00_MASK)) \
+               | (reg_wb_gain << ISPHIST_WB_GAIN_WG00_SHIFT))
+
+#define WRITE_WB_RG(reg, reg_wb_gain) \
+               (reg = (reg & ~(ISPHIST_WB_GAIN_WG01_MASK)) \
+               | (reg_wb_gain << ISPHIST_WB_GAIN_WG01_SHIFT))
+
+#define WRITE_WB_B(reg, reg_wb_gain) \
+               (reg = (reg & ~(ISPHIST_WB_GAIN_WG02_MASK)) \
+               | (reg_wb_gain << ISPHIST_WB_GAIN_WG02_SHIFT))
+
+#define WRITE_WB_BG(reg, reg_wb_gain) \
+               (reg = (reg & ~(ISPHIST_WB_GAIN_WG03_MASK)) \
+               | (reg_wb_gain << ISPHIST_WB_GAIN_WG03_SHIFT))
+
+#define WRITE_REG_HORIZ(reg, reg_n_hor) \
+               (reg = ((reg & ~ISPHIST_REGHORIZ_MASK) \
+               | (reg_n_hor & ISPHIST_REGHORIZ_MASK)))
+
+#define WRITE_REG_VERT(reg, reg_n_vert) \
+               (reg = ((reg & ~ISPHIST_REGVERT_MASK) \
+               | (reg_n_vert & ISPHIST_REGVERT_MASK)))
+
+
+int isp_hist_configure(struct isp_hist_config *histcfg);
+
+int isp_hist_request_statistics(struct isp_hist_data *histdata);
+
+void isphist_save_context(void);
+
+void isphist_restore_context(void);
+
+#endif                         /* OMAP_ISP_HIST */
Index: linux-omap-2.6/drivers/media/video/isp/ispmmu.c
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/isp/ispmmu.c     2008-08-28 19:08:43.000000000 -0500
@@ -0,0 +1,735 @@
+/*
+ * drivers/media/video/isp/ispmmu.c
+ *
+ * Driver Library for ISP MMU module in TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ *
+ * Contributors:
+ *     Senthilvadivu Guruswamy <svadivu@ti.com>
+ *     Thara Gopinath <thara@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/types.h>
+#include <linux/dma-mapping.h>
+#include <linux/mm.h>
+
+#include <linux/io.h>
+#include <linux/scatterlist.h>
+#include <linux/semaphore.h>
+#include <asm/byteorder.h>
+#include <asm/irq.h>
+
+#include "isp.h"
+#include "ispreg.h"
+#include "ispmmu.h"
+
+/**
+ * struct ispmmu_mapattr - Struct for Mapping Attributes in L1, L2 descriptor
+ * endianism: Endianism.
+ * element_size: Bit size of the element.
+ * mixed_size: Mixed region type.
+ * map_size: Mapping size.
+ */
+struct ispmmu_mapattr {
+       enum ISPMMU_MAP_ENDIAN endianism;
+       enum ISPMMU_MAP_ELEMENTSIZE element_size;
+       enum ISPMMU_MAP_MIXEDREGION mixed_size;
+       enum ISPMMU_MAP_SIZE map_size;
+};
+
+/* Structure for saving/restoring mmu module registers */
+static struct isp_reg ispmmu_reg_list[] = {
+       {ISPMMU_SYSCONFIG, 0x0000},
+       {ISPMMU_IRQENABLE, 0x0000},
+       {ISPMMU_CNTL, 0x0000},
+       {ISPMMU_TTB, 0x0000},
+       {ISPMMU_LOCK, 0x0000},
+       {ISPMMU_LD_TLB, 0x0000},
+       {ISPMMU_CAM, 0x0000},
+       {ISPMMU_RAM, 0x0000},
+       {ISPMMU_GFLUSH, 0x0000},
+       {ISPMMU_FLUSH_ENTRY, 0x0000},
+       {ISP_TOK_TERM, 0x0000}
+};
+
+/* Page structure for statically allocated l1 and l2 page tables */
+static struct page *ttb_page;
+static struct page *l2p_page;
+
+/*
+* Allocate the same number as of TTB entries for easy tracking
+* even though L2P tables are limited to 16 or so
+*/
+static u32 l2p_table_addr[4096];
+
+/* An array of flags to keep the L2P table allotted */
+static int l2p_table_allotted[L2P_TABLE_NR];
+
+/* TTB virtual and physical address */
+static u32 *ttb, ttb_p;
+
+/* Worst case allocation for TTB for 16KB alignment */
+static u32 ttb_aligned_size;
+
+/* L2 page table base virtural and physical address */
+static u32 l2_page_cache, l2_page_cache_p;
+
+static struct ispmmu_mapattr l1_mapattr_obj, l2_mapattr_obj;
+
+/**
+ * ispmmu_set_pte - Sets the L1, L2 descriptor.
+ * @pte_addr: Pointer to the Indexed address in the L1 Page table ie TTB.
+ * @phy_addr: Section/Supersection/L2page table physical address.
+ * @mapattr: Mapping attributes applicable for Section/Supersections.
+ *
+ * Set with section/supersection/Largepage/Smallpage base address or with L2
+ * Page table address depending on the size parameter.
+ *
+ * Returns the written L1/L2 descriptor.
+ **/
+static u32 ispmmu_set_pte(u32 *pte_addr, u32 phy_addr,
+                                               struct ispmmu_mapattr mapattr)
+{
+       u32 pte = 0;
+
+       switch (mapattr.map_size) {
+       case PAGE:
+               pte = ISPMMU_L1D_TYPE_PAGE << ISPMMU_L1D_TYPE_SHIFT;
+               pte |= (phy_addr >> ISPMMU_L1D_PAGE_ADDR_SHIFT)
+                                               << ISPMMU_L1D_PAGE_ADDR_SHIFT;
+               break;
+       case SMALLPAGE:
+               pte = ISPMMU_L2D_TYPE_SMALL_PAGE << ISPMMU_L2D_TYPE_SHIFT;
+               pte &= ~ISPMMU_L2D_M_ACCESSBASED;
+               if (mapattr.endianism)
+                       pte |= ISPMMU_L2D_E_BIGENDIAN;
+               else
+                       pte &= ~ISPMMU_L2D_E_BIGENDIAN;
+               pte &= ISPMMU_L2D_ES_MASK;
+               pte |= mapattr.element_size << ISPMMU_L2D_ES_SHIFT;
+               pte |= (phy_addr >> ISPMMU_L2D_SMALL_ADDR_SHIFT)
+                                               << ISPMMU_L2D_SMALL_ADDR_SHIFT;
+               break;
+       case L1DFAULT:
+               pte = ISPMMU_L1D_TYPE_FAULT << ISPMMU_L1D_TYPE_SHIFT;
+               break;
+       case L2DFAULT:
+               pte = ISPMMU_L2D_TYPE_FAULT << ISPMMU_L2D_TYPE_SHIFT;
+               break;
+       default:
+               break;
+       };
+
+       *pte_addr = pte;
+       return pte;
+}
+
+/**
+ * find_free_region_index - Returns the index in the ttb for a free 32MB region
+ *
+ * Returns 0 as an error code, if run out of regions.
+ **/
+static u32 find_free_region_index(void)
+{
+       int idx = 0;
+       for (idx = ISPMMU_REGION_ENTRIES_NR; idx < ISPMMU_TTB_ENTRIES_NR;
+                                       idx += ISPMMU_REGION_ENTRIES_NR) {
+               if (((*(ttb + idx)) & ISPMMU_L1D_TYPE_MASK) ==
+                                               (ISPMMU_L1D_TYPE_FAULT <<
+                                               ISPMMU_L1D_TYPE_SHIFT))
+                       break;
+       }
+       if (idx == ISPMMU_TTB_ENTRIES_NR) {
+               DPRINTK_ISPMMU("run out of virtual space\n");
+               return 0;
+       }
+       return idx;
+}
+
+/**
+ * page_aligned_addr - Returns the Page aligned address.
+ * @addr: Address to be page aligned.
+ **/
+static inline u32 page_aligned_addr(u32 addr)
+{
+       u32 paddress;
+       paddress = addr & ~(PAGE_SIZE-1);
+       return paddress;
+}
+
+
+/**
+ * l2_page_paddr - Returns the physical address of the allocated L2 page Table.
+ * @l2_table: Virtual address of the allocated l2 table.
+ **/
+static inline u32 l2_page_paddr(u32 l2_table)
+{
+       return l2_page_cache_p + (l2_table - l2_page_cache);
+}
+
+/**
+ * init_l2_page_cache - Allocates contigous memory for L2 page tables.
+ *
+ * Returns 0 if successful, or -ENOMEM if no memory for L2 page tables.
+ **/
+static int init_l2_page_cache(void)
+{
+       int i;
+       u32 *l2p;
+
+       l2p_page = alloc_pages(GFP_KERNEL, get_order(L2P_TABLES_SIZE));
+       if (!l2p_page) {
+               DPRINTK_ISPMMU("ISP_ERR : No Memory for L2 page tables\n");
+               return -ENOMEM;
+       }
+       l2p = page_address(l2p_page);
+       l2_page_cache = (u32)l2p;
+       l2_page_cache_p = __pa(l2p);
+       l2_page_cache = (u32)ioremap_nocache(l2_page_cache_p, L2P_TABLES_SIZE);
+
+       for (i = 0; i < L2P_TABLE_NR; i++)
+               l2p_table_allotted[i] = 0;
+
+       DPRINTK_ISPMMU("Mem for L2 page tables at l2_paddr = %x,"
+                                       " l2_vaddr = 0x%x, of bytes = 0x%x\n",
+                                       l2_page_cache_p, l2_page_cache,
+                                       L2P_TABLES_SIZE);
+
+       if (is_sil_rev_less_than(OMAP3430_REV_ES2_0))
+               l2_mapattr_obj.endianism = B_ENDIAN;
+       else
+               l2_mapattr_obj.endianism = L_ENDIAN;
+       l2_mapattr_obj.element_size = ES_8BIT;
+       l2_mapattr_obj.mixed_size = ACCESS_BASED;
+       l2_mapattr_obj.map_size = L2DFAULT;
+       return 0;
+}
+
+/**
+ * cleanup_l2_page_cache - Frees the memory of L2 page tables.
+ **/
+static void cleanup_l2_page_cache(void)
+{
+       if (l2p_page) {
+               ioremap_cached(l2_page_cache_p, L2P_TABLES_SIZE);
+               __free_pages(l2p_page, get_order(L2P_TABLES_SIZE));
+       }
+}
+
+/**
+ * request_l2_page_table - Requests L2 Page table slot.
+ *
+ * Finds a free L2 Page table slot.
+ * Fills the allotted L2 Page table with default entries.
+ * Returns the virtual address of the allocatted L2 Pagetable, or 0 if cannot
+ * allocate the requested L2 pagetables
+ **/
+static u32 request_l2_page_table(void)
+{
+       int i, j;
+       u32 l2_table;
+
+       for (i = 0; i < L2P_TABLE_NR; i++) {
+               if (!l2p_table_allotted[i])
+                       break;
+       }
+       if (i < L2P_TABLE_NR) {
+               l2p_table_allotted[i] = 1;
+               l2_table = l2_page_cache + (i * L2P_TABLE_SIZE);
+               l2_mapattr_obj.map_size = L2DFAULT;
+               for (j = 0; j < ISPMMU_L2D_ENTRIES_NR; j++)
+                       ispmmu_set_pte((u32 *)l2_table + j, 0, l2_mapattr_obj);
+               DPRINTK_ISPMMU("Allotted l2 page table at 0x%x\n",
+                                       (u32)l2_table);
+               return l2_table;
+       } else {
+               DPRINTK_ISPMMU("ISP_ERR : Cannot allocate more than 16 L2\
+                               Page Tables");
+               return 0;
+       }
+}
+
+/**
+ * free_l2_page_table - Frees the allocatted L2 Page table slot.
+ * @l2_table: 32 bit address for L2 Table to be freed.
+ *
+ * Returns 0 if successful, or -EINVAL if table is not found.
+ **/
+static int free_l2_page_table(u32 l2_table)
+{
+       int i;
+
+       DPRINTK_ISPMMU("Free l2 page table at 0x%x\n", l2_table);
+       for (i = 0; i < L2P_TABLE_NR; i++)
+               if (l2_table == (l2_page_cache + (i * L2P_TABLE_SIZE))) {
+                       if (!l2p_table_allotted[i])
+                               DPRINTK_ISPMMU("L2 page not in use\n");
+
+                       l2p_table_allotted[i] = 0;
+                       return 0;
+               }
+       DPRINTK_ISPMMU("L2 table not found\n");
+       return -EINVAL;
+}
+
+/**
+ * ispmmu_map - Map a physically contiguous buffer to ISP space.
+ * @p_addr: Physical address of the contigous mem to be mapped.
+ * @size: Size of the contigous mem to be mapped.
+ *
+ * This call is used to map a frame buffer.
+ *
+ * Returns a valid address when successful, 0 if no memory could be mapped,
+ * or -EINVAL if runned out of virtual space.
+ **/
+dma_addr_t ispmmu_map(u32 p_addr, int size)
+{
+       int i, j, idx, num;
+       u32 sz, first_padding;
+       u32 p_addr_align, p_addr_align_end;
+       u32 pd;
+       u32 *l2_table;
+       dma_addr_t ret_addr;
+
+       DPRINTK_ISPMMU("map: p_addr = 0x%x, size = 0x%x\n", p_addr, size);
+
+       p_addr_align = page_aligned_addr(p_addr);
+
+       first_padding = p_addr - p_addr_align;
+       if (first_padding > size)
+               sz = 0;
+       else
+               sz = size - first_padding;
+
+       num = (sz / PAGE_SIZE) + ((sz % PAGE_SIZE) ? 1 : 0) +
+                                               (first_padding ? 1 : 0);
+       p_addr_align_end = p_addr_align + num * PAGE_SIZE;
+
+       DPRINTK_ISPMMU("buffer at 0x%x of size 0x%x spans to %d pages\n",
+                                                       p_addr, size, num);
+
+       idx = find_free_region_index();
+       if (!idx) {
+               DPRINTK_ISPMMU("Runs out of virtual space");
+               return -EINVAL;
+       }
+       DPRINTK_ISPMMU("allocating region %d\n", idx/ISPMMU_REGION_ENTRIES_NR);
+
+       num = num / ISPMMU_L2D_ENTRIES_NR +
+                               ((num % ISPMMU_L2D_ENTRIES_NR) ? 1 : 0);
+       DPRINTK_ISPMMU("need %d second-level page tables (1KB each)\n", num);
+
+       for (i = 0; i < num; i++) {
+               l2_table = (u32 *)request_l2_page_table();
+               if (!l2_table) {
+                       DPRINTK_ISPMMU("no memory\n");
+                       i--;
+                       goto release_mem;
+               }
+
+               l1_mapattr_obj.map_size = PAGE;
+               pd = ispmmu_set_pte(ttb+idx+i, l2_page_paddr((u32)l2_table),
+                       l1_mapattr_obj);
+               DPRINTK_ISPMMU("L1 pte[%d] = 0x%x\n", idx+i, pd);
+
+               l2_mapattr_obj.map_size = SMALLPAGE;
+               for (j = 0; j < ISPMMU_L2D_ENTRIES_NR; j++) {
+                       pd = ispmmu_set_pte(l2_table + j, p_addr_align,
+                                                       l2_mapattr_obj);
+                       p_addr_align += PAGE_SIZE;
+                       if (p_addr_align == p_addr_align_end)
+                               break;
+               }
+               l2p_table_addr[idx + i] = (u32)l2_table;
+       }
+
+       DPRINTK_ISPMMU("mapped to ISP virtual address 0x%x\n",
+               (u32)((idx << 20) + (p_addr & (PAGE_SIZE - 1))));
+
+       omap_writel(1, ISPMMU_GFLUSH);
+       ret_addr = (dma_addr_t)((idx << 20) + (p_addr & (PAGE_SIZE - 1)));
+       return ret_addr;
+
+release_mem:
+       for (; i >= 0; i--) {
+               free_l2_page_table(l2p_table_addr[idx + i]);
+               l2p_table_addr[idx + i] = 0;
+       }
+       return 0;
+}
+EXPORT_SYMBOL_GPL(ispmmu_map);
+
+/**
+ * ispmmu_map_sg - Map a physically discontiguous buffer to ISP space.
+ * @sg_list: Address of the Scatter gather linked list.
+ * @sglen: Number of elements in the sg list.
+ *
+ * This call is used to map a user buffer or a vmalloc buffer. The sg list is
+ * a set of pages.
+ *
+ * Returns a valid address when successful, 0 if no memory could be mapped,
+ * or -EINVAL if runned out of virtual space.
+ **/
+dma_addr_t ispmmu_map_sg(const struct scatterlist *sglist, int sglen)
+{
+       int i, j, idx, num, sg_num = 0;
+       u32 pd, sg_element_addr;
+       u32 *l2_table;
+       dma_addr_t ret_addr;
+
+       DPRINTK_ISPMMU("Map_sg: sglen (num of pages) = %d\n", sglen);
+
+       idx = find_free_region_index();
+       if (!idx) {
+               DPRINTK_ISPMMU("Runs out of virtual space");
+               return -EINVAL;
+       }
+
+       DPRINTK_ISPMMU("allocating region %d\n", idx/ISPMMU_REGION_ENTRIES_NR);
+
+       num = sglen / ISPMMU_L2D_ENTRIES_NR +
+                       ((sglen % ISPMMU_L2D_ENTRIES_NR) ? 1 : 0);
+       DPRINTK_ISPMMU("Need %d second-level page tables (1KB each)\n", num);
+
+       for (i = 0; i < num; i++) {
+               l2_table = (u32 *)request_l2_page_table();
+               if (!l2_table) {
+                       DPRINTK_ISPMMU("No memory\n");
+                       i--;
+                       goto release_mem;
+               }
+               l1_mapattr_obj.map_size = PAGE;
+               pd = ispmmu_set_pte(ttb + idx + i,
+                                               l2_page_paddr((u32)l2_table),
+                                               l1_mapattr_obj);
+               DPRINTK_ISPMMU("L1 pte[%d] = 0x%x\n", idx + i, pd);
+
+               l2_mapattr_obj.map_size = SMALLPAGE;
+               for (j = 0; j < ISPMMU_L2D_ENTRIES_NR; j++) {
+                       sg_element_addr = sg_dma_address(sglist + sg_num);
+                       if ((sg_num > 0) && page_aligned_addr(sg_element_addr)
+                                                       != sg_element_addr)
+                               DPRINTK_ISPMMU("ISP_ERR : Intermediate SG"
+                                               " elements are not"
+                                               " page aligned = 0x%x\n",
+                                               sg_element_addr);
+                       pd = ispmmu_set_pte(l2_table + j, sg_element_addr,
+                                                       l2_mapattr_obj);
+
+                       /* DPRINTK_ISPMMU("L2 pte[%d] = 0x%x\n", j, pd); */
+
+                       sg_num++;
+                       if (sg_num == sglen)
+                               break;
+               }
+               /* save it so we can free this l2 table later */
+               l2p_table_addr[idx + i] = (u32)l2_table;
+       }
+
+       DPRINTK_ISPMMU("mapped sg list to ISP virtual address 0x%x, idx=%d\n",
+               (u32)((idx << 20) + (sg_dma_address(sglist + 0) &
+                                               (PAGE_SIZE - 1))), idx);
+
+       omap_writel(1, ISPMMU_GFLUSH);
+       ret_addr = (dma_addr_t)((idx << 20) + (sg_dma_address(sglist + 0) &
+                                                       (PAGE_SIZE - 1)));
+       return ret_addr;
+
+release_mem:
+       for (; i >= 0; i--) {
+               free_l2_page_table(l2p_table_addr[idx + i]);
+               l2p_table_addr[idx + i] = 0;
+       }
+       return 0;
+}
+EXPORT_SYMBOL_GPL(ispmmu_map_sg);
+
+/**
+ * ispmmu_unmap - Unmap a ISP space that was mmapped before.
+ * @v_addr: Virtural address to be unmapped
+ *
+ * Works with mmapped spaces either with ispmmu_map or ispmmu_map_sg.
+ *
+ * Returns 0 if successful, or -EINVAL if wrong region, or non region-aligned
+ **/
+int ispmmu_unmap(dma_addr_t v_addr)
+{
+       u32 v_addr_align;
+       int idx;
+
+       DPRINTK_ISPMMU("+ispmmu_unmap: 0x%x\n", v_addr);
+
+       v_addr_align = page_aligned_addr(v_addr);
+       idx = v_addr_align >> 20;
+       if ((idx < ISPMMU_REGION_ENTRIES_NR) || (idx >
+                                       (ISPMMU_REGION_ENTRIES_NR *
+                                       (ISPMMU_REGION_NR - 1))) ||
+                                       ((idx << 20) != v_addr_align) ||
+                                       (idx % ISPMMU_REGION_ENTRIES_NR)) {
+               DPRINTK_ISPMMU("Cannot unmap a non region-aligned space"
+                                                       " 0x%x\n", v_addr);
+               return -EINVAL;
+       }
+
+       if (((*(ttb + idx)) & (ISPMMU_L1D_TYPE_MASK <<
+                                               ISPMMU_L1D_TYPE_SHIFT)) !=
+                                               (ISPMMU_L1D_TYPE_PAGE <<
+                                               ISPMMU_L1D_TYPE_SHIFT)) {
+               DPRINTK_ISPMMU("unmap a wrong region\n");
+               return -EINVAL;
+       }
+
+       while (((*(ttb + idx)) & (ISPMMU_L1D_TYPE_MASK <<
+                                               ISPMMU_L1D_TYPE_SHIFT)) ==
+                                               (ISPMMU_L1D_TYPE_PAGE <<
+                                               ISPMMU_L1D_TYPE_SHIFT)) {
+               *(ttb + idx) = (ISPMMU_L1D_TYPE_FAULT <<
+                                               ISPMMU_L1D_TYPE_SHIFT);
+               free_l2_page_table(l2p_table_addr[idx]);
+               l2p_table_addr[idx++] = 0;
+               if (!(idx % ISPMMU_REGION_ENTRIES_NR)) {
+                       DPRINTK_ISPMMU("Do not exceed this 32M region\n");
+                       break;
+               }
+       }
+       omap_writel(1, ISPMMU_GFLUSH);
+
+       DPRINTK_ISPMMU("-ispmmu_unmap()\n");
+       return 0;
+}
+EXPORT_SYMBOL_GPL(ispmmu_unmap);
+
+/**
+ * ispmmu_isr - Callback from ISP driver for MMU interrupt.
+ * @status: IRQ status of ISPMMU
+ * @arg1: Not used as of now.
+ * @arg2: Not used as of now.
+ **/
+static void ispmmu_isr(unsigned long status, isp_vbq_callback_ptr arg1,
+                                                               void *arg2)
+{
+       u32 irqstatus = 0;
+
+       irqstatus = omap_readl(ISPMMU_IRQSTATUS);
+       DPRINTK_ISPMMU("mmu error 0x%lx, 0x%x\n", status, irqstatus);
+       if (irqstatus & IRQENABLE_TLBMISS)
+               DPRINTK_ISPMMU("ISP_ERR: TLB Miss\n");
+       if (irqstatus & IRQENABLE_TRANSLNFAULT)
+               DPRINTK_ISPMMU("ISP_ERR: Invalide descriptor in the"
+                                               " translation table -"
+                                               " Translation Fault\n");
+       if (irqstatus & IRQENABLE_EMUMISS) {
+               DPRINTK_ISPMMU("ISP_ERR: TLB Miss during debug -"
+                                                       " Emulation mode\n");
+       }
+       if (irqstatus & IRQENABLE_TWFAULT)
+               DPRINTK_ISPMMU("ISP_ERR: Table Walk Fault\n");
+       if (irqstatus & IRQENABLE_MULTIHITFAULT)
+               DPRINTK_ISPMMU("ISP_ERR: Multiple Matches in the TLB\n");
+       DPRINTK_ISPMMU("Fault address for the ISPMMU is 0x%x",
+                                               omap_readl(ISPMMU_FAULT_AD));
+       omap_writel(irqstatus, ISPMMU_IRQSTATUS);
+}
+
+/**
+ * ispmmu_init - ISP MMU Initialization.
+ *
+ * - Reserves memory for L1 and L2 Page tables.
+ * - Initializes the ISPMMU with TTB address, fault entries as default in the
+ * - TTB table.
+ * - Enables MMU and TWL.
+ * - Sets the callback for the MMU error events.
+ *
+ * Returns 0 if successful, -ENODEV if can't take ISP MMU out of reset, -ENOMEM
+ * when no memory for TTB, or init_l2_page_cache return value if L2 page cache
+ * init fails.
+ **/
+int __init ispmmu_init(void)
+{
+       int i, val = 0;
+       struct isp_sysc isp_sysconfig;
+
+       isp_get();
+
+       omap_writel(2, ISPMMU_SYSCONFIG);
+       while (((omap_readl(ISPMMU_SYSSTATUS) & 0x1) != 0x1) && val--)
+               udelay(10);
+
+       if ((omap_readl(ISPMMU_SYSSTATUS) & 0x1) != 0x1) {
+               DPRINTK_ISPMMU("can't take ISP MMU out of reset\n");
+               isp_put();
+               return -ENODEV;
+       }
+       isp_sysconfig.reset = 0;
+       isp_sysconfig.idle_mode = 1;
+       isp_power_settings(isp_sysconfig);
+
+       ttb_page = alloc_pages(GFP_KERNEL, get_order(ISPMMU_TTB_ENTRIES_NR *
+                                                                       4));
+       if (!ttb_page) {
+               DPRINTK_ISPMMU("No Memory for TTB\n");
+               isp_put();
+               return -ENOMEM;
+       }
+
+       ttb = page_address(ttb_page);
+       ttb_p = __pa(ttb);
+       ttb_aligned_size = ISPMMU_TTB_ENTRIES_NR * 4;
+       ttb = ioremap_nocache(ttb_p, ttb_aligned_size);
+       if ((ttb_p & 0xFFFFC000) != ttb_p) {
+               DPRINTK_ISPMMU("ISP_ERR : TTB address not aligned at 16KB\n");
+               __free_pages(ttb_page, get_order(ISPMMU_TTB_ENTRIES_NR * 4));
+               ttb_aligned_size = (ISPMMU_TTB_ENTRIES_NR * 4) +
+                                               (ISPMMU_TTB_MISALIGN_SIZE);
+               ttb_page = alloc_pages(GFP_KERNEL,
+                                               get_order(ttb_aligned_size));
+               if (!ttb_page) {
+                       DPRINTK_ISPMMU("No Memory for TTB\n");
+                       isp_put();
+                       return -ENOMEM;
+               }
+               ttb = page_address(ttb_page);
+               ttb_p = __pa(ttb);
+               ttb = ioremap_nocache(ttb_p, ttb_aligned_size);
+               if ((ttb_p & 0xFFFFC000) != ttb_p) {
+                       ttb = (u32 *)(((u32)ttb & 0xFFFFC000) + 0x4000);
+                       ttb_p = __pa(ttb);
+               }
+       }
+
+       DPRINTK_ISPMMU("TTB allocated at p = 0x%x, v = 0x%x, size = 0x%x\n",
+               ttb_p, (u32)ttb, ttb_aligned_size);
+
+       if (is_sil_rev_less_than(OMAP3430_REV_ES2_0))
+               l1_mapattr_obj.endianism = B_ENDIAN;
+       else
+               l1_mapattr_obj.endianism = L_ENDIAN;
+       l1_mapattr_obj.element_size = ES_8BIT;
+       l1_mapattr_obj.mixed_size = ACCESS_BASED;
+       l1_mapattr_obj.map_size = L1DFAULT;
+
+       val = init_l2_page_cache();
+       if (val) {
+               DPRINTK_ISPMMU("ISP_ERR: init l2 page cache\n");
+               ttb = page_address(ttb_page);
+               ttb_p = __pa(ttb);
+               ioremap_cached(ttb_p, ttb_aligned_size);
+               __free_pages(ttb_page, get_order(ttb_aligned_size));
+               isp_put();
+               return val;
+       }
+
+       for (i = 0; i < ISPMMU_TTB_ENTRIES_NR; i++)
+               ispmmu_set_pte(ttb + i, 0, l1_mapattr_obj);
+
+       omap_writel(ttb_p, ISPMMU_TTB);
+
+       omap_writel((ISPMMU_MMUCNTL_MMU_EN|ISPMMU_MMUCNTL_TWL_EN),
+                       ISPMMU_CNTL);
+       omap_writel(omap_readl(ISPMMU_IRQSTATUS), ISPMMU_IRQSTATUS);
+       omap_writel(0xf, ISPMMU_IRQENABLE);
+
+       isp_set_callback(CBK_MMU_ERR, ispmmu_isr, (void *)NULL, (void *)NULL);
+
+       val = omap_readl(ISPMMU_REVISION);
+       DPRINTK_ISPMMU("ISP MMU Rev %c.%c initialized\n",
+                       (val >> ISPMMU_REVISION_REV_MAJOR_SHIFT) + '0',
+                       (val & ISPMMU_REVISION_REV_MINOR_MASK) + '0');
+       isp_put();
+       return 0;
+
+}
+
+/**
+ * ispmmu_cleanup - Frees the L1, L2 Page tables. Unsets the callback for MMU.
+ **/
+void __exit ispmmu_cleanup(void)
+{
+       ttb = page_address(ttb_page);
+       ttb_p = __pa(ttb);
+       ioremap_cached(ttb_p, ttb_aligned_size);
+       __free_pages(ttb_page, get_order(ttb_aligned_size));
+       isp_unset_callback(CBK_MMU_ERR);
+       cleanup_l2_page_cache();
+
+       return;
+}
+
+/**
+ * ispmmu_save_context - Saves the values of the mmu module registers.
+ **/
+void ispmmu_save_context(void)
+{
+       DPRINTK_ISPMMU(" Saving context\n");
+       isp_save_context(ispmmu_reg_list);
+}
+EXPORT_SYMBOL_GPL(ispmmu_save_context);
+
+/**
+ * ispmmu_restore_context - Restores the values of the mmu module registers.
+ **/
+void ispmmu_restore_context(void)
+{
+       DPRINTK_ISPMMU(" Restoring context\n");
+       isp_restore_context(ispmmu_reg_list);
+}
+EXPORT_SYMBOL_GPL(ispmmu_restore_context);
+
+/**
+ * ispmmu_print_status - Prints the values of the ISPMMU registers
+ * Also prints other debug information stored
+ **/
+void ispmmu_print_status(void)
+{
+       if (!is_ispmmu_debug_enabled())
+               return;
+       DPRINTK_ISPMMU("TTB v_addr = 0x%x, p_addr = 0x%x\n", (u32)ttb, ttb_p);
+       DPRINTK_ISPMMU("L2P base v_addr = 0x%x, p_addr = 0x%x\n"
+                               , l2_page_cache, l2_page_cache_p);
+       DPRINTK_ISPMMU("ISPMMU_REVISION = 0x%x\n",
+                                               omap_readl(ISPMMU_REVISION));
+       DPRINTK_ISPMMU("ISPMMU_SYSCONFIG = 0x%x\n",
+                                               omap_readl(ISPMMU_SYSCONFIG));
+       DPRINTK_ISPMMU("ISPMMU_SYSSTATUS = 0x%x\n",
+                                               omap_readl(ISPMMU_SYSSTATUS));
+       DPRINTK_ISPMMU("ISPMMU_IRQSTATUS = 0x%x\n",
+                                               omap_readl(ISPMMU_IRQSTATUS));
+       DPRINTK_ISPMMU("ISPMMU_IRQENABLE = 0x%x\n",
+                                               omap_readl(ISPMMU_IRQENABLE));
+       DPRINTK_ISPMMU("ISPMMU_WALKING_ST = 0x%x\n",
+                                               omap_readl(ISPMMU_WALKING_ST));
+       DPRINTK_ISPMMU("ISPMMU_CNTL = 0x%x\n", omap_readl(ISPMMU_CNTL));
+       DPRINTK_ISPMMU("ISPMMU_FAULT_AD = 0x%x\n",
+                                               omap_readl(ISPMMU_FAULT_AD));
+       DPRINTK_ISPMMU("ISPMMU_TTB = 0x%x\n", omap_readl(ISPMMU_TTB));
+       DPRINTK_ISPMMU("ISPMMU_LOCK = 0x%x\n", omap_readl(ISPMMU_LOCK));
+       DPRINTK_ISPMMU("ISPMMU_LD_TLB= 0x%x\n", omap_readl(ISPMMU_LD_TLB));
+       DPRINTK_ISPMMU("ISPMMU_CAM = 0x%x\n", omap_readl(ISPMMU_CAM));
+       DPRINTK_ISPMMU("ISPMMU_RAM = 0x%x\n", omap_readl(ISPMMU_RAM));
+       DPRINTK_ISPMMU("ISPMMU_GFLUSH = 0x%x\n", omap_readl(ISPMMU_GFLUSH));
+       DPRINTK_ISPMMU("ISPMMU_FLUSH_ENTRY = 0x%x\n",
+                                       omap_readl(ISPMMU_FLUSH_ENTRY));
+       DPRINTK_ISPMMU("ISPMMU_READ_CAM = 0x%x\n",
+                                               omap_readl(ISPMMU_READ_CAM));
+       DPRINTK_ISPMMU("ISPMMU_READ_RAM = 0x%x\n",
+                                               omap_readl(ISPMMU_READ_RAM));
+}
+EXPORT_SYMBOL_GPL(ispmmu_print_status);
Index: linux-omap-2.6/drivers/media/video/isp/ispmmu.h
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/isp/ispmmu.h     2008-08-28 19:08:43.000000000 -0500
@@ -0,0 +1,117 @@
+/*
+ * drivers/media/video/isp/ispmmu.h
+ *
+ * OMAP3430 Camera ISP MMU API
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ *
+ * Contributors:
+ *     Senthilvadivu Guruswamy <svadivu@ti.com>
+ *     Thara Gopinath <thara@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#ifndef OMAP_ISP_MMU_H
+#define OMAP_ISP_MMU_H
+
+#define ISPMMU_L1D_TYPE_SHIFT          0
+#define ISPMMU_L1D_TYPE_MASK           0x3
+#define ISPMMU_L1D_TYPE_FAULT          0
+#define ISPMMU_L1D_TYPE_FAULT1         3
+#define ISPMMU_L1D_TYPE_PAGE           1
+#define ISPMMU_L1D_TYPE_SECTION                2
+#define ISPMMU_L1D_PAGE_ADDR_SHIFT     10
+
+#define ISPMMU_L2D_TYPE_SHIFT          0
+#define ISPMMU_L2D_TYPE_MASK           0x3
+#define ISPMMU_L2D_TYPE_FAULT          0
+#define ISPMMU_L2D_TYPE_LARGE_PAGE     1
+#define ISPMMU_L2D_TYPE_SMALL_PAGE     2
+#define ISPMMU_L2D_SMALL_ADDR_SHIFT    12
+#define ISPMMU_L2D_SMALL_ADDR_MASK     0xFFFFF000
+#define ISPMMU_L2D_M_ACCESSBASED       (1 << 11)
+#define ISPMMU_L2D_E_BIGENDIAN         (1 << 9)
+#define ISPMMU_L2D_ES_SHIFT            4
+#define ISPMMU_L2D_ES_MASK             (~(3 << 4))
+#define ISPMMU_L2D_ES_8BIT             0
+#define ISPMMU_L2D_ES_16BIT            1
+#define ISPMMU_L2D_ES_32BIT            2
+#define ISPMMU_L2D_ES_NOENCONV         3
+
+#define ISPMMU_TTB_ENTRIES_NR          4096
+
+/* Number 1MB entries in TTB in one 32MB region */
+#define ISPMMU_REGION_ENTRIES_NR       32
+
+/* 128 region entries */
+#define ISPMMU_REGION_NR (ISPMMU_TTB_ENTRIES_NR / ISPMMU_REGION_ENTRIES_NR)
+
+/* Each region is 32MB */
+#define ISPMMU_REGION_SIZE             (ISPMMU_REGION_ENTRIES_NR * (1 << 20))
+
+/* Number of entries per L2 Page table */
+#define ISPMMU_L2D_ENTRIES_NR          256
+
+/*
+ * Statically allocate 16KB for L2 page tables. 16KB can be used for
+ * up to 16 L2 page tables which cover up to 16MB space. We use an array of 16
+ * to keep track of these 16 L2 page table's status.
+ */
+#define L2P_TABLE_SIZE                 1024
+#define L2P_TABLE_NR                   41 /* Currently supports 4*5MP shots */
+#define L2P_TABLES_SIZE                (L2P_TABLE_SIZE * L2P_TABLE_NR)
+
+/* Extra memory allocated to get ttb aligned on 16KB */
+#define ISPMMU_TTB_MISALIGN_SIZE       0x3000
+
+#ifdef CONFIG_ARCH_OMAP3410
+#include <linux/scatterlist.h>
+#endif
+
+enum ISPMMU_MAP_ENDIAN {
+       L_ENDIAN,
+       B_ENDIAN
+};
+
+enum ISPMMU_MAP_ELEMENTSIZE {
+       ES_8BIT,
+       ES_16BIT,
+       ES_32BIT,
+       ES_NOENCONV
+};
+
+enum ISPMMU_MAP_MIXEDREGION {
+       ACCESS_BASED,
+       PAGE_BASED
+};
+
+enum ISPMMU_MAP_SIZE {
+       L1DFAULT,
+       PAGE,
+       SECTION,
+       SUPERSECTION,
+       L2DFAULT,
+       LARGEPAGE,
+       SMALLPAGE
+};
+
+dma_addr_t ispmmu_map(unsigned int p_addr, int size);
+
+dma_addr_t ispmmu_map_sg(const struct scatterlist *sglist, int sglen);
+
+int ispmmu_unmap(dma_addr_t isp_addr);
+
+void ispmmu_print_status(void);
+
+void ispmmu_save_context(void);
+
+void ispmmu_restore_context(void);
+
+#endif /* OMAP_ISP_MMU_H */
Index: linux-omap-2.6/drivers/media/video/isp/isppreview.c
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/isp/isppreview.c 2008-08-28 19:08:43.000000000 -0500
@@ -0,0 +1,1868 @@
+/*
+ * drivers/media/video/isp/isppreview.c
+ *
+ * Driver Library for Preview module in TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments, Inc.
+ *
+ * Contributors:
+ *     Senthilvadivu Guruswamy <svadivu@ti.com>
+ *     Pallavi Kulkarni <p-kulkarni@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#include <linux/io.h>
+#include <linux/errno.h>
+#include <linux/mutex.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+
+#include "isp.h"
+#include "ispreg.h"
+#include "isppreview.h"
+
+static struct ispprev_nf prev_nf_t;
+static struct prev_params *params;
+static int RG_update, GG_update, BG_update, NF_enable, NF_update;
+
+/* Structure for saving/restoring preview module registers */
+static struct isp_reg ispprev_reg_list[] = {
+       {ISPPRV_HORZ_INFO, 0x0000},
+       {ISPPRV_VERT_INFO, 0x0000},
+       {ISPPRV_RSDR_ADDR, 0x0000},
+       {ISPPRV_RADR_OFFSET, 0x0000},
+       {ISPPRV_DSDR_ADDR, 0x0000},
+       {ISPPRV_DRKF_OFFSET, 0x0000},
+       {ISPPRV_WSDR_ADDR, 0x0000},
+       {ISPPRV_WADD_OFFSET, 0x0000},
+       {ISPPRV_AVE, 0x0000},
+       {ISPPRV_HMED, 0x0000},
+       {ISPPRV_NF, 0x0000},
+       {ISPPRV_WB_DGAIN, 0x0000},
+       {ISPPRV_WBGAIN, 0x0000},
+       {ISPPRV_WBSEL, 0x0000},
+       {ISPPRV_CFA, 0x0000},
+       {ISPPRV_BLKADJOFF, 0x0000},
+       {ISPPRV_RGB_MAT1, 0x0000},
+       {ISPPRV_RGB_MAT2, 0x0000},
+       {ISPPRV_RGB_MAT3, 0x0000},
+       {ISPPRV_RGB_MAT4, 0x0000},
+       {ISPPRV_RGB_MAT5, 0x0000},
+       {ISPPRV_RGB_OFF1, 0x0000},
+       {ISPPRV_RGB_OFF2, 0x0000},
+       {ISPPRV_CSC0, 0x0000},
+       {ISPPRV_CSC1, 0x0000},
+       {ISPPRV_CSC2, 0x0000},
+       {ISPPRV_CSC_OFFSET, 0x0000},
+       {ISPPRV_CNT_BRT, 0x0000},
+       {ISPPRV_CSUP, 0x0000},
+       {ISPPRV_SETUP_YC, 0x0000},
+       {ISPPRV_SET_TBL_ADDR, 0x0000},
+       {ISPPRV_SET_TBL_DATA, 0x0000},
+       {ISPPRV_CDC_THR0, 0x0000},
+       {ISPPRV_CDC_THR1, 0x0000},
+       {ISPPRV_CDC_THR2, 0x0000},
+       {ISPPRV_CDC_THR3, 0x0000},
+       {ISP_TOK_TERM, 0x0000}
+};
+
+
+/* Default values in Office Flourescent Light for RGBtoRGB Blending */
+static struct ispprev_rgbtorgb flr_rgb2rgb = {
+       {       /* RGB-RGB Matrix */
+               {0x01E2, 0x0F30, 0x0FEE},
+               {0x0F9B, 0x01AC, 0x0FB9},
+               {0x0FE0, 0x0EC0, 0x0260}
+       },      /* RGB Offset */
+               {0x0000, 0x0000, 0x0000}
+};
+
+/* Default values in Office Flourescent Light for RGB to YUV Conversion*/
+static struct ispprev_csc flr_prev_csc[] = {
+       {
+               {       /* CSC Coef Matrix */
+                       {66, 129, 25},
+                       {-38, -75, 112},
+                       {112, -94 , -18}
+               },      /* CSC Offset */
+                       {0x0, 0x0, 0x0}
+       },
+       {
+               {       /* CSC Coef Matrix Sepia */
+                       {19, 38, 7},
+                       {0, 0, 0},
+                       {0, 0, 0}
+               },      /* CSC Offset */
+                       {0x0, 0xE7, 0x14}
+       },
+       {
+               {       /* CSC Coef Matrix BW */
+                       {66, 129, 25},
+                       {0, 0, 0},
+                       {0, 0, 0}
+               },      /* CSC Offset */
+                       {0x0, 0x0, 0x0}
+       }
+};
+
+
+/* Default values in Office Flourescent Light for CFA Gradient*/
+static u8 flr_cfa_gradthrs_horz = 0x28;
+static u8 flr_cfa_gradthrs_vert = 0x28;
+
+/* Default values in Office Flourescent Light for Chroma Suppression*/
+static u8 flr_csup_gain = 0x0D;
+static u8 flr_csup_thres = 0xEB;
+
+/* Default values in Office Flourescent Light for Noise Filter*/
+static u8 flr_nf_strgth = 0x03;
+
+/* Default values in Office Flourescent Light for White Balance*/
+static u16 flr_wbal_dgain = 0x100;
+static u8 flr_wbal_coef0 = 0x68;
+static u8 flr_wbal_coef1 = 0x5c;
+static u8 flr_wbal_coef2 = 0x5c;
+static u8 flr_wbal_coef3 = 0x94;
+
+/* Default values in Office Flourescent Light for Black Adjustment*/
+static u8 flr_blkadj_blue = 0x0;
+static u8 flr_blkadj_green = 0x0;
+static u8 flr_blkadj_red = 0x0;
+
+static int update_color_matrix;
+
+/**
+ * struct isp_prev - Structure for storing ISP Preview module information
+ * @prev_inuse: Flag to determine if CCDC has been reserved or not (0 or 1).
+ * @prevout_w: Preview output width.
+ * @prevout_h: Preview output height.
+ * @previn_w: Preview input width.
+ * @previn_h: Preview input height.
+ * @prev_inpfmt: Preview input format.
+ * @prev_outfmt: Preview output format.
+ * @hmed_en: Horizontal median filter enable.
+ * @nf_en: Noise filter enable.
+ * @dcor_en: Defect correction enable.
+ * @cfa_en: Color Filter Array (CFA) interpolation enable.
+ * @csup_en: Chrominance suppression enable.
+ * @yenh_en: Luma enhancement enable.
+ * @fmtavg: Number of horizontal pixels to average in input formatter. The
+ *          input width should be a multiple of this number.
+ * @brightness: Brightness in preview module.
+ * @contrast: Contrast in preview module.
+ * @color: Color effect in preview module.
+ * @cfafmt: Color Filter Array (CFA) Format.
+ * @ispprev_mutex: Mutex for isp preview.
+ *
+ * This structure is used to store the OMAP ISP Preview module Information.
+ */
+static struct isp_prev {
+       u8 prev_inuse;
+       u32 prevout_w;
+       u32 prevout_h;
+       u32 previn_w;
+       u32 previn_h;
+       enum preview_input prev_inpfmt;
+       enum preview_output prev_outfmt;
+       u8 hmed_en;
+       u8 nf_en;
+       u8 dcor_en;
+       u8 cfa_en;
+       u8 csup_en;
+       u8 yenh_en;
+       u8 fmtavg;
+       u8 brightness;
+       u8 contrast;
+       enum preview_color_effect color;
+       enum cfa_fmt cfafmt;
+       struct mutex ispprev_mutex; /* For checking/modifying prev_inuse */
+} ispprev_obj;
+
+/* Saved parameters */
+struct prev_params *prev_config_params;
+
+/*
+ * Coeficient Tables for the submodules in Preview.
+ * Array is initialised with the values from.the tables text file.
+ */
+
+/*
+ * CFA Filter Coefficient Table
+ *
+ */
+static u32 cfa_coef_table[] = {
+#include "cfa_coef_table.h"
+};
+
+/*
+ * Gamma Correction Table - Red
+ */
+static u32 redgamma_table[] = {
+#include "redgamma_table.h"
+};
+
+/*
+ * Gamma Correction Table - Green
+ */
+static u32 greengamma_table[] = {
+#include "greengamma_table.h"
+};
+
+/*
+ * Gamma Correction Table - Blue
+ */
+static u32 bluegamma_table[] = {
+#include "bluegamma_table.h"
+};
+
+/*
+ * Noise Filter Threshold table
+ */
+static u32 noise_filter_table[] = {
+#include "noise_filter_table.h"
+};
+
+/*
+ * Luminance Enhancement Table
+ */
+static u32 luma_enhance_table[] = {
+#include "luma_enhance_table.h"
+};
+
+/**
+ * omap34xx_isp_preview_config - Abstraction layer Preview configuration.
+ * @userspace_add: Pointer from Userspace to structure with flags and data to
+ *                 update.
+ **/
+int omap34xx_isp_preview_config(void *userspace_add)
+{
+       struct ispprev_hmed prev_hmed_t;
+       struct ispprev_cfa prev_cfa_t;
+       struct ispprev_csup csup_t;
+       struct ispprev_wbal prev_wbal_t;
+       struct ispprev_blkadj prev_blkadj_t;
+       struct ispprev_rgbtorgb rgb2rgb_t;
+       struct ispprev_csc prev_csc_t;
+       struct ispprev_yclimit yclimit_t;
+       struct ispprev_dcor prev_dcor_t;
+       struct ispprv_update_config *preview_struct;
+       struct isptables_update isp_table_update;
+       int yen_t[128];
+
+       if (userspace_add == NULL)
+               return -EINVAL;
+
+       preview_struct = (struct ispprv_update_config *) userspace_add;
+
+       if ((ISP_ABS_PREV_LUMAENH & preview_struct->flag) ==
+                                                       ISP_ABS_PREV_LUMAENH) {
+               if ((ISP_ABS_PREV_LUMAENH & preview_struct->update) ==
+                                                       ISP_ABS_PREV_LUMAENH) {
+                       if (copy_from_user(yen_t, preview_struct->yen,
+                                                               sizeof(yen_t)))
+                               goto err_copy_from_user;
+                       isppreview_config_luma_enhancement(yen_t);
+               }
+               params->features |= PREV_LUMA_ENHANCE;
+       } else if ((ISP_ABS_PREV_LUMAENH & preview_struct->update) ==
+                                                       ISP_ABS_PREV_LUMAENH)
+                       params->features &= ~PREV_LUMA_ENHANCE;
+
+       if ((ISP_ABS_PREV_INVALAW & preview_struct->flag) ==
+                                                       ISP_ABS_PREV_INVALAW) {
+               isppreview_enable_invalaw(1);
+               params->features |= PREV_INVERSE_ALAW;
+       } else {
+               isppreview_enable_invalaw(0);
+               params->features &= ~PREV_INVERSE_ALAW;
+       }
+
+       if ((ISP_ABS_PREV_HRZ_MED & preview_struct->flag) ==
+                                                       ISP_ABS_PREV_HRZ_MED) {
+               if ((ISP_ABS_PREV_HRZ_MED & preview_struct->update) ==
+                                                       ISP_ABS_PREV_HRZ_MED) {
+                       if (copy_from_user(&prev_hmed_t,
+                                               (struct ispprev_hmed *)
+                                               (preview_struct->prev_hmed),
+                                               sizeof(struct ispprev_hmed)))
+                               goto err_copy_from_user;
+                       isppreview_config_hmed(prev_hmed_t);
+               }
+               isppreview_enable_hmed(1);
+               params->features |= PREV_HORZ_MEDIAN_FILTER;
+       } else if ((ISP_ABS_PREV_HRZ_MED & preview_struct->update) ==
+                                                       ISP_ABS_PREV_HRZ_MED) {
+               isppreview_enable_hmed(0);
+               params->features &= ~PREV_HORZ_MEDIAN_FILTER;
+       }
+       if ((ISP_ABS_PREV_CFA & preview_struct->flag) == ISP_ABS_PREV_CFA) {
+               if ((ISP_ABS_PREV_CFA & preview_struct->update) ==
+                                                       ISP_ABS_PREV_CFA) {
+                       if (copy_from_user(&prev_cfa_t,
+                                               (struct ispprev_cfa *)
+                                               (preview_struct->prev_cfa),
+                                               sizeof(struct ispprev_cfa)))
+                               goto err_copy_from_user;
+
+                       isppreview_config_cfa(prev_cfa_t);
+               }
+               isppreview_enable_cfa(1);
+               params->features |= PREV_CFA;
+       } else if ((ISP_ABS_PREV_CFA & preview_struct->update) ==
+                                                       ISP_ABS_PREV_CFA) {
+               isppreview_enable_cfa(0);
+               params->features &= ~PREV_CFA;
+       }
+
+       if ((ISP_ABS_PREV_CHROMA_SUPP & preview_struct->flag) ==
+                                               ISP_ABS_PREV_CHROMA_SUPP) {
+               if ((ISP_ABS_PREV_CHROMA_SUPP & preview_struct->update) ==
+                                               ISP_ABS_PREV_CHROMA_SUPP) {
+                       if (copy_from_user(&csup_t,
+                                               (struct ispprev_csup *)
+                                               (preview_struct->csup),
+                                               sizeof(struct ispprev_csup)))
+                               goto err_copy_from_user;
+                       isppreview_config_chroma_suppression(csup_t);
+               }
+               isppreview_enable_chroma_suppression(1);
+               params->features |= PREV_CHROMA_SUPPRESS;
+       } else if ((ISP_ABS_PREV_CHROMA_SUPP & preview_struct->update) ==
+                                               ISP_ABS_PREV_CHROMA_SUPP) {
+               isppreview_enable_chroma_suppression(0);
+               params->features &= ~PREV_CHROMA_SUPPRESS;
+       }
+
+       if ((ISP_ABS_PREV_WB & preview_struct->update) == ISP_ABS_PREV_WB) {
+               if (copy_from_user(&prev_wbal_t, (struct ispprev_wbal *)
+                                               (preview_struct->prev_wbal),
+                                               sizeof(struct ispprev_wbal)))
+                       goto err_copy_from_user;
+               isppreview_config_whitebalance(prev_wbal_t);
+       }
+
+       if ((ISP_ABS_PREV_BLKADJ & preview_struct->update) ==
+                                                       ISP_ABS_PREV_BLKADJ) {
+               if (copy_from_user(&prev_blkadj_t, (struct ispprev_blkadjl *)
+                                       (preview_struct->prev_blkadj),
+                                       sizeof(struct ispprev_blkadj)))
+                       goto err_copy_from_user;
+               isppreview_config_blkadj(prev_blkadj_t);
+       }
+
+       if ((ISP_ABS_PREV_RGB2RGB & preview_struct->update) ==
+                                                       ISP_ABS_PREV_RGB2RGB) {
+               if (copy_from_user(&rgb2rgb_t, (struct ispprev_rgbtorgb *)
+                                       (preview_struct->rgb2rgb),
+                                       sizeof(struct ispprev_rgbtorgb)))
+                       goto err_copy_from_user;
+               isppreview_config_rgb_blending(rgb2rgb_t);
+       }
+
+       if ((ISP_ABS_PREV_COLOR_CONV & preview_struct->update) ==
+                                               ISP_ABS_PREV_COLOR_CONV) {
+               if (copy_from_user(&prev_csc_t, (struct ispprev_csc *)
+                                               (preview_struct->prev_csc),
+                                               sizeof(struct ispprev_csc)))
+                       goto err_copy_from_user;
+               isppreview_config_rgb_to_ycbcr(prev_csc_t);
+       }
+
+       if ((ISP_ABS_PREV_YC_LIMIT & preview_struct->update) ==
+               ISP_ABS_PREV_YC_LIMIT) {
+               if (copy_from_user(&yclimit_t, (struct ispprev_yclimit *)
+                                       (preview_struct->yclimit),
+                                       sizeof(struct ispprev_yclimit)))
+                       goto err_copy_from_user;
+               isppreview_config_yc_range(yclimit_t);
+       }
+
+       if ((ISP_ABS_PREV_DEFECT_COR & preview_struct->flag) ==
+                                               ISP_ABS_PREV_DEFECT_COR) {
+               if ((ISP_ABS_PREV_DEFECT_COR & preview_struct->update) ==
+                                               ISP_ABS_PREV_DEFECT_COR) {
+                       if (copy_from_user(&prev_dcor_t,
+                                               (struct ispprev_dcor *)
+                                               (preview_struct->prev_dcor),
+                                               sizeof(struct ispprev_dcor)))
+                               goto err_copy_from_user;
+                       isppreview_config_dcor(prev_dcor_t);
+               }
+               isppreview_enable_dcor(1);
+               params->features |= PREV_DEFECT_COR;
+       } else if ((ISP_ABS_PREV_DEFECT_COR & preview_struct->update) ==
+                                               ISP_ABS_PREV_DEFECT_COR) {
+               isppreview_enable_dcor(0);
+               params->features &= ~PREV_DEFECT_COR;
+       }
+
+       if ((ISP_ABS_PREV_GAMMABYPASS & preview_struct->flag) ==
+                                               ISP_ABS_PREV_GAMMABYPASS) {
+               isppreview_enable_gammabypass(1);
+               params->features |= PREV_GAMMA_BYPASS;
+       } else {
+               isppreview_enable_gammabypass(0);
+               params->features &= ~PREV_GAMMA_BYPASS;
+       }
+
+       isp_table_update.update = preview_struct->update;
+       isp_table_update.flag = preview_struct->flag;
+       isp_table_update.prev_nf = preview_struct->prev_nf;
+       isp_table_update.red_gamma = preview_struct->red_gamma;
+       isp_table_update.green_gamma = preview_struct->green_gamma;
+       isp_table_update.blue_gamma = preview_struct->blue_gamma;
+
+       if (omap34xx_isp_tables_update(&isp_table_update))
+               goto err_copy_from_user;
+
+       return 0;
+
+err_copy_from_user:
+       printk(KERN_ERR "Preview Config: Copy From User Error");
+       return -EINVAL;
+}
+EXPORT_SYMBOL(omap34xx_isp_preview_config);
+
+/**
+ * omap34xx_isp_tables_update - Abstraction layer Tables update.
+ * @isptables_struct: Pointer from Userspace to structure with flags and table
+ *                 data to update.
+ **/
+int omap34xx_isp_tables_update(struct isptables_update *isptables_struct)
+{
+
+       if ((ISP_ABS_TBL_NF & isptables_struct->flag) == ISP_ABS_TBL_NF) {
+               NF_enable = 1;
+               params->features |= (PREV_NOISE_FILTER);
+               if ((ISP_ABS_TBL_NF & isptables_struct->update) ==
+                                                       ISP_ABS_TBL_NF) {
+                       if (copy_from_user(&prev_nf_t, (struct ispprev_nf *)
+                                               (isptables_struct->prev_nf),
+                                               sizeof(struct ispprev_nf)))
+                               goto err_copy_from_user;
+
+                       NF_update = 1;
+               } else
+                       NF_update = 0;
+       } else {
+               NF_enable = 0;
+               params->features &= ~(PREV_NOISE_FILTER);
+               if ((ISP_ABS_TBL_NF & isptables_struct->update) ==
+                                                               ISP_ABS_TBL_NF)
+                       NF_update = 1;
+               else
+                       NF_update = 0;
+       }
+
+       if ((ISP_ABS_TBL_REDGAMMA & isptables_struct->update) ==
+                                                       ISP_ABS_TBL_REDGAMMA) {
+               if (copy_from_user(redgamma_table, isptables_struct->red_gamma,
+                                               sizeof(redgamma_table))) {
+                       goto err_copy_from_user;
+               }
+               RG_update = 1;
+       } else
+               RG_update = 0;
+
+       if ((ISP_ABS_TBL_GREENGAMMA & isptables_struct->update) ==
+                                               ISP_ABS_TBL_GREENGAMMA) {
+               if (copy_from_user(greengamma_table,
+                                               isptables_struct->green_gamma,
+                                               sizeof(greengamma_table)))
+                       goto err_copy_from_user;
+               GG_update = 1;
+       } else
+               GG_update = 0;
+
+       if ((ISP_ABS_TBL_BLUEGAMMA & isptables_struct->update) ==
+                                       ISP_ABS_TBL_BLUEGAMMA) {
+               if (copy_from_user(bluegamma_table, (isptables_struct->
+                                               blue_gamma),
+                                               sizeof(bluegamma_table))) {
+                       goto err_copy_from_user;
+               }
+               BG_update = 1;
+       } else
+               BG_update = 0;
+
+       return 0;
+
+err_copy_from_user:
+       printk(KERN_ERR "Preview Tables:Copy From User Error");
+       return -EINVAL;
+}
+
+/**
+ * isppreview_config_shadow_registers - Program shadow registers for preview.
+ *
+ * Allows user to program shadow registers associated with preview module.
+ **/
+void isppreview_config_shadow_registers()
+{
+       u8 current_brightness_contrast;
+       int ctr, prv_disabled;
+
+       isppreview_query_brightness(&current_brightness_contrast);
+       if (current_brightness_contrast != ((ispprev_obj.brightness) *
+                                                       ISPPRV_BRIGHT_UNITS)) {
+               DPRINTK_ISPPREV(" Changing Brightness level to %d\n",
+                                               ispprev_obj.brightness);
+               isppreview_config_brightness((ispprev_obj.brightness) *
+                                                       ISPPRV_BRIGHT_UNITS);
+       }
+
+       isppreview_query_contrast(&current_brightness_contrast);
+       if (current_brightness_contrast != ((ispprev_obj.contrast) *
+                                               ISPPRV_CONTRAST_UNITS)) {
+               DPRINTK_ISPPREV(" Changing Contrast level to %d\n",
+                                                       ispprev_obj.contrast);
+               isppreview_config_contrast((ispprev_obj.contrast) *
+                                                       ISPPRV_CONTRAST_UNITS);
+       }
+       if (update_color_matrix) {
+               isppreview_config_rgb_to_ycbcr(flr_prev_csc[ispprev_obj.
+                                                               color]);
+               update_color_matrix = 0;
+       }
+       if (GG_update || RG_update || BG_update || NF_update) {
+               isppreview_enable(0);
+               prv_disabled = 1;
+       }
+
+       if (GG_update) {
+               omap_writel(0x400, ISPPRV_SET_TBL_ADDR);
+
+               for (ctr = 0; ctr < ISP_GAMMA_TABLE_SIZE; ctr++) {
+                       omap_writel(greengamma_table[ctr],
+                                                       ISPPRV_SET_TBL_DATA);
+               }
+               GG_update = 0;
+       }
+
+       if (RG_update) {
+               omap_writel(0, ISPPRV_SET_TBL_ADDR);
+
+               for (ctr = 0; ctr < ISP_GAMMA_TABLE_SIZE; ctr++)
+                       omap_writel(redgamma_table[ctr], ISPPRV_SET_TBL_DATA);
+               RG_update = 0;
+       }
+
+       if (BG_update) {
+               omap_writel(0x800, ISPPRV_SET_TBL_ADDR);
+
+               for (ctr = 0; ctr < ISP_GAMMA_TABLE_SIZE; ctr++)
+                       omap_writel(bluegamma_table[ctr], ISPPRV_SET_TBL_DATA);
+               BG_update = 0;
+       }
+
+       if (NF_update && NF_enable) {
+               omap_writel(0xC00, ISPPRV_SET_TBL_ADDR);
+               omap_writel(prev_nf_t.spread, ISPPRV_NF);
+               for (ctr = 0; ctr < 64; ctr++)
+                       omap_writel(prev_nf_t.table[ctr],
+                                                       ISPPRV_SET_TBL_DATA);
+               isppreview_enable_noisefilter(1);
+               NF_update = 0;
+       }
+
+       if (~NF_update && NF_enable)
+               isppreview_enable_noisefilter(1);
+
+       if (NF_update && ~NF_enable)
+               isppreview_enable_noisefilter(0);
+
+       if (prv_disabled) {
+               isppreview_enable(1);
+               prv_disabled = 0;
+       }
+}
+EXPORT_SYMBOL(isppreview_config_shadow_registers);
+
+/**
+ * isppreview_request - Reserves the preview module.
+ *
+ * Returns 0 if successful, or -EBUSY if the module was already reserved.
+ **/
+int isppreview_request()
+{
+       mutex_lock(&ispprev_obj.ispprev_mutex);
+       if (!(ispprev_obj.prev_inuse)) {
+               ispprev_obj.prev_inuse = 1;
+               mutex_unlock(&ispprev_obj.ispprev_mutex);
+               omap_writel((omap_readl(ISP_CTRL)) | ISPCTRL_PREV_RAM_EN |
+                       ISPCTRL_PREV_CLK_EN | ISPCTRL_SBL_WR1_RAM_EN
+                       , ISP_CTRL);
+               return 0;
+       } else {
+               mutex_unlock(&ispprev_obj.ispprev_mutex);
+               printk(KERN_ERR "ISP_ERR : Preview Module Busy\n");
+               return -EBUSY;
+       }
+}
+EXPORT_SYMBOL(isppreview_request);
+
+/**
+ * isppreview_free - Frees the preview module.
+ *
+ * Returns 0 if successful, or -EINVAL if the module was already freed.
+ **/
+int isppreview_free()
+{
+       mutex_lock(&ispprev_obj.ispprev_mutex);
+       if (ispprev_obj.prev_inuse) {
+               ispprev_obj.prev_inuse = 0;
+               mutex_unlock(&ispprev_obj.ispprev_mutex);
+               omap_writel(omap_readl(ISP_CTRL) & ~(ISPCTRL_PREV_CLK_EN |
+                                       ISPCTRL_PREV_RAM_EN |
+                                       ISPCTRL_SBL_WR1_RAM_EN), ISP_CTRL);
+               return 0;
+       } else {
+               mutex_unlock(&ispprev_obj.ispprev_mutex);
+               DPRINTK_ISPPREV("ISP_ERR : Preview Module already freed\n");
+               return -EINVAL;
+       }
+
+}
+EXPORT_SYMBOL(isppreview_free);
+
+/** isppreview_config_datapath - Specifies input and output modules for Preview
+ * @input: Indicates the module that gives the image to preview.
+ * @output: Indicates the module to which the preview outputs to.
+ *
+ * Configures the default configuration for the CCDC to work with.
+ *
+ * The valid values for the input are PRV_RAW_CCDC (0), PRV_RAW_MEM (1),
+ * PRV_RGBBAYERCFA (2), PRV_COMPCFA (3), PRV_CCDC_DRKF (4), PRV_OTHERS (5).
+ *
+ * The valid values for the output are PREVIEW_RSZ (0), PREVIEW_MEM (1).
+ *
+ * Returns 0 if successful, or -EINVAL if wrong input or output values are
+ * specified.
+ **/
+int isppreview_config_datapath(enum preview_input input,
+                                               enum preview_output output)
+{
+       u32 pcr = 0;
+       u8 enable = 0;
+       struct prev_params *params = prev_config_params;
+       struct ispprev_yclimit yclimit;
+
+       pcr = omap_readl(ISPPRV_PCR);
+
+       switch (input) {
+       case PRV_RAW_CCDC:
+               pcr &= ~(ISPPRV_PCR_SOURCE);
+               pcr &= ~(ISPPRV_PCR_ONESHOT);
+               ispprev_obj.prev_inpfmt = PRV_RAW_CCDC;
+               break;
+       case PRV_RAW_MEM:
+               pcr |= ISPPRV_PCR_SOURCE;
+               pcr |= ISPPRV_PCR_ONESHOT;
+               ispprev_obj.prev_inpfmt = PRV_RAW_MEM;
+               break;
+       case PRV_CCDC_DRKF:
+               pcr |= ISPPRV_PCR_DRKFCAP;
+               pcr |= ISPPRV_PCR_ONESHOT;
+               ispprev_obj.prev_inpfmt = PRV_CCDC_DRKF;
+               break;
+       case PRV_COMPCFA:
+               ispprev_obj.prev_inpfmt = PRV_COMPCFA;
+               break;
+       case PRV_OTHERS:
+               ispprev_obj.prev_inpfmt = PRV_OTHERS;
+               break;
+       case PRV_RGBBAYERCFA:
+               ispprev_obj.prev_inpfmt = PRV_RGBBAYERCFA;
+               break;
+       default:
+               printk(KERN_ERR "ISP_ERR : Wrong Input\n");
+               return -EINVAL;
+       };
+
+       if (output == PREVIEW_RSZ) {
+               pcr |= ISPPRV_PCR_RSZPORT;
+               pcr &= ~ISPPRV_PCR_SDRPORT;
+               ispprev_obj.prev_outfmt = PREVIEW_RSZ;
+       } else if (output == PREVIEW_MEM) {
+               pcr &= ~ISPPRV_PCR_RSZPORT;
+               pcr |= ISPPRV_PCR_SDRPORT;
+               ispprev_obj.prev_outfmt = PREVIEW_MEM;
+       } else {
+               printk(KERN_ERR "ISP_ERR : Wrong Output\n");
+               return -EINVAL;
+       }
+       omap_writel(pcr, ISPPRV_PCR);
+
+       isppreview_config_ycpos(params->pix_fmt);
+
+       if (params->cfa.cfa_table != NULL)
+               isppreview_config_cfa(params->cfa);
+       if (params->csup.hypf_en == 1)
+               isppreview_config_chroma_suppression(params->csup);
+       if (params->ytable != NULL)
+               isppreview_config_luma_enhancement(params->ytable);
+
+       if (params->gtable.redtable != NULL)
+               isppreview_config_gammacorrn(params->gtable);
+
+       enable = ((params->features & PREV_CFA) == PREV_CFA) ? 1 : 0;
+       isppreview_enable_cfa(enable);
+
+       enable = ((params->features & PREV_CHROMA_SUPPRESS) ==
+                                               PREV_CHROMA_SUPPRESS) ? 1 : 0;
+       isppreview_enable_chroma_suppression(enable);
+
+       enable = ((params->features & PREV_LUMA_ENHANCE) ==
+                                               PREV_LUMA_ENHANCE) ? 1 : 0;
+       isppreview_enable_luma_enhancement(enable);
+
+       enable = ((params->features & PREV_NOISE_FILTER) ==
+                                               PREV_NOISE_FILTER) ? 1 : 0;
+       if (enable)
+               isppreview_config_noisefilter(params->nf);
+       isppreview_enable_noisefilter(enable);
+
+       enable = ((params->features & PREV_DEFECT_COR) ==
+                                               PREV_DEFECT_COR) ? 1 : 0;
+       if (enable)
+               isppreview_config_dcor(params->dcor);
+       isppreview_enable_dcor(enable);
+
+       enable = ((params->features & PREV_GAMMA_BYPASS) ==
+                                               PREV_GAMMA_BYPASS) ? 1 : 0;
+       isppreview_enable_gammabypass(enable);
+
+       isppreview_config_whitebalance(params->wbal);
+       isppreview_config_blkadj(params->blk_adj);
+       isppreview_config_rgb_blending(params->rgb2rgb);
+       isppreview_config_rgb_to_ycbcr(params->rgb2ycbcr);
+
+       isppreview_config_contrast(params->contrast * ISPPRV_CONTRAST_UNITS);
+       isppreview_config_brightness(params->brightness * ISPPRV_BRIGHT_UNITS);
+
+       yclimit.minC = ISPPRV_YC_MIN;
+       yclimit.maxC = ISPPRV_YC_MAX;
+       yclimit.minY = ISPPRV_YC_MIN;
+       yclimit.maxY = ISPPRV_YC_MAX;
+       isppreview_config_yc_range(yclimit);
+
+       return 0;
+}
+EXPORT_SYMBOL(isppreview_config_datapath);
+
+/**
+ * isppreview_config_ycpos - Configure byte layout of YUV image.
+ * @mode: Indicates the required byte layout.
+ **/
+void isppreview_config_ycpos(enum preview_ycpos_mode mode)
+{
+       u32 pcr = omap_readl(ISPPRV_PCR);
+       pcr &= ~ISPPRV_PCR_YCPOS_CrYCbY;
+       pcr |= (mode << ISPPRV_PCR_YCPOS_SHIFT);
+       omap_writel(pcr, ISPPRV_PCR);
+}
+EXPORT_SYMBOL(isppreview_config_ycpos);
+
+/**
+ * isppreview_config_averager - Enable / disable / configure averager
+ * @average: Average value to be configured.
+ **/
+void isppreview_config_averager(u8 average)
+{
+       int reg = 0;
+
+       reg = AVE_ODD_PIXEL_DIST | AVE_EVEN_PIXEL_DIST | average;
+       omap_writel(reg, ISPPRV_AVE);
+}
+EXPORT_SYMBOL(isppreview_config_averager);
+
+/**
+ * isppreview_enable_invalaw - Enable/Disable Inverse A-Law module in Preview.
+ * @enable: 1 - Reverse the A-Law done in CCDC.
+ **/
+void isppreview_enable_invalaw(u8 enable)
+{
+       u32 pcr_val = 0;
+       pcr_val = omap_readl(ISPPRV_PCR);
+
+       if (enable)
+               omap_writel(pcr_val | ISPPRV_PCR_WIDTH | ISPPRV_PCR_INVALAW,
+                                                               ISPPRV_PCR);
+       else
+               omap_writel(pcr_val & ~(ISPPRV_PCR_WIDTH | ISPPRV_PCR_INVALAW),
+                                                               ISPPRV_PCR);
+}
+EXPORT_SYMBOL(isppreview_enable_invalaw);
+
+/**
+ * isppreview_enable_drkframe - Enable/Disable of the darkframe subtract.
+ * @enable: 1 - Acquires memory bandwidth since the pixels in each frame is
+ *          subtracted with the pixels in the current frame.
+ *
+ * The proccess is applied for each captured frame.
+ **/
+void isppreview_enable_drkframe(u8 enable)
+{
+       if (enable)
+               omap_writel(omap_readl(ISPPRV_PCR) | ISPPRV_PCR_DRKFEN,
+                                                               ISPPRV_PCR);
+       else
+               omap_writel((omap_readl(ISPPRV_PCR)) & ~ISPPRV_PCR_DRKFEN,
+                                                               ISPPRV_PCR);
+}
+EXPORT_SYMBOL(isppreview_enable_drkframe);
+
+/**
+ * isppreview_enable_shadcomp - Enables/Disables the shading compensation.
+ * @enable: 1 - Enables the shading compensation.
+ *
+ * If dark frame subtract won't be used, then enable this shading
+ * compensation.
+ **/
+void isppreview_enable_shadcomp(u8 enable)
+{
+
+       if (enable) {
+               omap_writel((omap_readl(ISPPRV_PCR)) | ISPPRV_PCR_SCOMP_EN,
+                                                               ISPPRV_PCR);
+               isppreview_enable_drkframe(1);
+       } else {
+               omap_writel((omap_readl(ISPPRV_PCR)) & ~ISPPRV_PCR_SCOMP_EN,
+                                                               ISPPRV_PCR);
+       }
+}
+EXPORT_SYMBOL(isppreview_enable_shadcomp);
+
+/**
+ * isppreview_config_drkf_shadcomp - Configures shift value in shading comp.
+ * @scomp_shtval: 3bit value of shift used in shading compensation.
+ **/
+void isppreview_config_drkf_shadcomp(u8 scomp_shtval)
+{
+       u32 pcr_val = omap_readl(ISPPRV_PCR);
+
+       pcr_val &= ISPPRV_PCR_SCOMP_SFT_MASK;
+       omap_writel(pcr_val | (scomp_shtval << ISPPRV_PCR_SCOMP_SFT_SHIFT),
+                                                               ISPPRV_PCR);
+}
+EXPORT_SYMBOL(isppreview_config_drkf_shadcomp);
+
+/**
+ * isppreview_enable_hmed - Enables/Disables of the Horizontal Median Filter.
+ * @enable: 1 - Enables Horizontal Median Filter.
+ **/
+void isppreview_enable_hmed(u8 enable)
+{
+       if (enable) {
+               omap_writel((omap_readl(ISPPRV_PCR)) | ISPPRV_PCR_HMEDEN,
+                       ISPPRV_PCR);
+               ispprev_obj.hmed_en = 1;
+       } else {
+               omap_writel((omap_readl(ISPPRV_PCR)) & ~ISPPRV_PCR_HMEDEN,
+                       ISPPRV_PCR);
+               ispprev_obj.hmed_en = 0;
+       }
+}
+EXPORT_SYMBOL(isppreview_enable_hmed);
+
+/**
+ * isppreview_config_hmed - Configures the Horizontal Median Filter.
+ * @prev_hmed: Structure containing the odd and even distance between the
+ *             pixels in the image along with the filter threshold.
+ **/
+void isppreview_config_hmed(struct ispprev_hmed prev_hmed)
+{
+
+       u32 odddist = 0;
+       u32 evendist = 0;
+
+       if (prev_hmed.odddist == 1)
+               odddist = ~ISPPRV_HMED_ODDDIST;
+       else
+               odddist = ISPPRV_HMED_ODDDIST;
+
+       if (prev_hmed.evendist == 1)
+               evendist = ~ISPPRV_HMED_EVENDIST;
+       else
+               evendist = ISPPRV_HMED_EVENDIST;
+
+       omap_writel(odddist | evendist | (prev_hmed.thres <<
+                                               ISPPRV_HMED_THRESHOLD_SHIFT),
+                                               ISPPRV_HMED);
+
+}
+EXPORT_SYMBOL(isppreview_config_hmed);
+
+/**
+ * isppreview_config_noisefilter - Configures the Noise Filter.
+ * @prev_nf: Structure containing the noisefilter table, strength to be used
+ *           for the noise filter and the defect correction enable flag.
+ **/
+void isppreview_config_noisefilter(struct ispprev_nf prev_nf)
+{
+       int i = 0;
+       omap_writel(prev_nf.spread, ISPPRV_NF);
+       omap_writel(ISPPRV_NF_TABLE_ADDR, ISPPRV_SET_TBL_ADDR);
+       for (i = 0; i < 64; i++)
+               omap_writel(prev_nf.table[i], ISPPRV_SET_TBL_DATA);
+}
+EXPORT_SYMBOL(isppreview_config_noisefilter);
+
+/**
+ * isppreview_config_dcor - Configures the defect correction
+ * @prev_nf: Structure containing the defect correction structure
+ **/
+void isppreview_config_dcor(struct ispprev_dcor prev_dcor)
+{
+       if (prev_dcor.couplet_mode_en) {
+               omap_writel(prev_dcor.detect_correct[0], ISPPRV_CDC_THR0);
+               omap_writel(prev_dcor.detect_correct[1], ISPPRV_CDC_THR1);
+               omap_writel(prev_dcor.detect_correct[2], ISPPRV_CDC_THR2);
+               omap_writel(prev_dcor.detect_correct[3], ISPPRV_CDC_THR3);
+               omap_writel((omap_readl(ISPPRV_PCR)) | ISPPRV_PCR_DCCOUP,
+                                                               ISPPRV_PCR);
+       } else {
+               omap_writel((omap_readl(ISPPRV_PCR)) & ~ISPPRV_PCR_DCCOUP,
+                                                               ISPPRV_PCR);
+       }
+}
+EXPORT_SYMBOL(isppreview_config_dcor);
+
+/**
+ * isppreview_config_cfa - Configures the CFA Interpolation parameters.
+ * @prev_cfa: Structure containing the CFA interpolation table, CFA format
+ *            in the image, vertical and horizontal gradient threshold.
+ **/
+void isppreview_config_cfa(struct ispprev_cfa prev_cfa)
+{
+       int i = 0;
+       ispprev_obj.cfafmt = prev_cfa.cfafmt;
+
+       omap_writel((omap_readl(ISPPRV_PCR)) | (prev_cfa.cfafmt <<
+                                       ISPPRV_PCR_CFAFMT_SHIFT), ISPPRV_PCR);
+
+       omap_writel((prev_cfa.cfa_gradthrs_vert <<
+                                               ISPPRV_CFA_GRADTH_VER_SHIFT) |
+                                               (prev_cfa.cfa_gradthrs_horz <<
+                                               ISPPRV_CFA_GRADTH_HOR_SHIFT),
+                                               ISPPRV_CFA);
+
+       omap_writel(ISPPRV_CFA_TABLE_ADDR, ISPPRV_SET_TBL_ADDR);
+
+       for (i = 0; i < 576; i++)
+               omap_writel(prev_cfa.cfa_table[i], ISPPRV_SET_TBL_DATA);
+}
+EXPORT_SYMBOL(isppreview_config_cfa);
+
+/**
+ * isppreview_config_gammacorrn - Configures the Gamma Correction table values
+ * @gtable: Structure containing the table for red, blue, green gamma table.
+ **/
+void isppreview_config_gammacorrn(struct ispprev_gtable gtable)
+{
+       int i = 0;
+
+       omap_writel(ISPPRV_REDGAMMA_TABLE_ADDR, ISPPRV_SET_TBL_ADDR);
+       for (i = 0; i < 1024; i++)
+               omap_writel(gtable.redtable[i], ISPPRV_SET_TBL_DATA);
+
+       omap_writel(ISPPRV_GREENGAMMA_TABLE_ADDR, ISPPRV_SET_TBL_ADDR);
+       for (i = 0; i < 1024; i++)
+               omap_writel(gtable.greentable[i], ISPPRV_SET_TBL_DATA);
+
+       omap_writel(ISPPRV_BLUEGAMMA_TABLE_ADDR, ISPPRV_SET_TBL_ADDR);
+       for (i = 0; i < 1024; i++)
+               omap_writel(gtable.bluetable[i], ISPPRV_SET_TBL_DATA);
+}
+EXPORT_SYMBOL(isppreview_config_gammacorrn);
+
+/**
+ * isppreview_config_luma_enhancement - Sets the Luminance Enhancement table.
+ * @ytable: Structure containing the table for Luminance Enhancement table.
+ **/
+void isppreview_config_luma_enhancement(u32 *ytable)
+{
+       int i = 0;
+       omap_writel(ISPPRV_YENH_TABLE_ADDR, ISPPRV_SET_TBL_ADDR);
+       for (i = 0; i < 128; i++)
+               omap_writel(ytable[i], ISPPRV_SET_TBL_DATA);
+}
+EXPORT_SYMBOL(isppreview_config_luma_enhancement);
+
+/**
+ * isppreview_config_chroma_suppression - Configures the Chroma Suppression.
+ * @csup: Structure containing the threshold value for suppression
+ *        and the hypass filter enable flag.
+ **/
+void isppreview_config_chroma_suppression(struct ispprev_csup csup)
+{
+       omap_writel(csup.gain | (csup.thres << ISPPRV_CSUP_THRES_SHIFT) |
+                               (csup.hypf_en << ISPPRV_CSUP_HPYF_SHIFT),
+                               ISPPRV_CSUP);
+}
+EXPORT_SYMBOL(isppreview_config_chroma_suppression);
+
+/**
+ * isppreview_enable_noisefilter - Enables/Disables the Noise Filter.
+ * @enable: 1 - Enables the Noise Filter.
+ **/
+void isppreview_enable_noisefilter(u8 enable)
+{
+       if (enable) {
+               omap_writel((omap_readl(ISPPRV_PCR)) | ISPPRV_PCR_NFEN,
+                                                               ISPPRV_PCR);
+               ispprev_obj.nf_en = 1;
+       } else {
+               omap_writel((omap_readl(ISPPRV_PCR)) & ~ISPPRV_PCR_NFEN,
+                                                               ISPPRV_PCR);
+               ispprev_obj.nf_en = 0;
+       }
+}
+EXPORT_SYMBOL(isppreview_enable_noisefilter);
+
+/**
+ * isppreview_enable_dcor - Enables/Disables the defect correction.
+ * @enable: 1 - Enables the defect correction.
+ **/
+void isppreview_enable_dcor(u8 enable)
+{
+       if (enable) {
+               omap_writel((omap_readl(ISPPRV_PCR)) | ISPPRV_PCR_DCOREN,
+                                                               ISPPRV_PCR);
+               ispprev_obj.dcor_en = 1;
+       } else {
+               omap_writel((omap_readl(ISPPRV_PCR)) & ~ISPPRV_PCR_DCOREN,
+                                                               ISPPRV_PCR);
+               ispprev_obj.dcor_en = 0;
+       }
+}
+EXPORT_SYMBOL(isppreview_enable_dcor);
+
+/**
+ * isppreview_enable_cfa - Enable/Disable the CFA Interpolation.
+ * @enable: 1 - Enables the CFA.
+ **/
+void isppreview_enable_cfa(u8 enable)
+{
+       if (enable) {
+               omap_writel((omap_readl(ISPPRV_PCR)) | ISPPRV_PCR_CFAEN,
+                                                               ISPPRV_PCR);
+               ispprev_obj.cfa_en = 1;
+       } else {
+               omap_writel((omap_readl(ISPPRV_PCR)) & ~ISPPRV_PCR_CFAEN,
+                                                               ISPPRV_PCR);
+               ispprev_obj.cfa_en = 0;
+       }
+
+}
+EXPORT_SYMBOL(isppreview_enable_cfa);
+
+/**
+ * isppreview_enable_gammabypass - Enables/Disables the GammaByPass
+ * @enable: 1 - Bypasses Gamma - 10bit input is cropped to 8MSB.
+ *          0 - Goes through Gamma Correction. input and output is 10bit.
+ **/
+void isppreview_enable_gammabypass(u8 enable)
+{
+       if (enable) {
+               omap_writel((omap_readl(ISPPRV_PCR)) | ISPPRV_PCR_GAMMA_BYPASS,
+                                                               ISPPRV_PCR);
+       } else {
+               omap_writel((omap_readl(ISPPRV_PCR)) &
+                                               ~ISPPRV_PCR_GAMMA_BYPASS,
+                                               ISPPRV_PCR);
+       }
+}
+EXPORT_SYMBOL(isppreview_enable_gammabypass);
+
+/**
+ * isppreview_enable_luma_enhancement - Enables/Disables Luminance Enhancement
+ * @enable: 1 - Enable the Luminance Enhancement.
+ **/
+void isppreview_enable_luma_enhancement(u8 enable)
+{
+       if (enable) {
+               omap_writel((omap_readl(ISPPRV_PCR)) | ISPPRV_PCR_YNENHEN,
+                                                               ISPPRV_PCR);
+               ispprev_obj.yenh_en = 1;
+       } else {
+               omap_writel((omap_readl(ISPPRV_PCR)) & ~ISPPRV_PCR_YNENHEN,
+                                                               ISPPRV_PCR);
+               ispprev_obj.yenh_en = 0;
+       }
+}
+EXPORT_SYMBOL(isppreview_enable_luma_enhancement);
+
+/**
+ * isppreview_enable_chroma_suppression - Enables/Disables Chrominance Suppr.
+ * @enable: 1 - Enable the Chrominance Suppression.
+ **/
+void isppreview_enable_chroma_suppression(u8 enable)
+{
+       if (enable) {
+               omap_writel((omap_readl(ISPPRV_PCR)) | ISPPRV_PCR_SUPEN,
+                                                               ISPPRV_PCR);
+               ispprev_obj.csup_en = 1;
+       } else {
+               omap_writel((omap_readl(ISPPRV_PCR)) & ~ISPPRV_PCR_SUPEN,
+                                                               ISPPRV_PCR);
+               ispprev_obj.csup_en = 0;
+       }
+}
+EXPORT_SYMBOL(isppreview_enable_chroma_suppression);
+
+/**
+ * isppreview_config_whitebalance - Configures the White Balance parameters.
+ * @prev_wbal: Structure containing the digital gain and white balance
+ *             coefficient.
+ *
+ * Coefficient matrix always with default values.
+ **/
+void isppreview_config_whitebalance(struct ispprev_wbal prev_wbal)
+{
+
+       omap_writel(prev_wbal.dgain, ISPPRV_WB_DGAIN);
+       omap_writel(prev_wbal.coef0 |
+                               prev_wbal.coef1 << ISPPRV_WBGAIN_COEF1_SHIFT |
+                               prev_wbal.coef2 << ISPPRV_WBGAIN_COEF2_SHIFT |
+                               prev_wbal.coef3 << ISPPRV_WBGAIN_COEF3_SHIFT,
+                               ISPPRV_WBGAIN);
+
+       omap_writel((ISPPRV_WBSEL_COEF0 << ISPPRV_WBSEL_N0_0_SHIFT) |
+                       (ISPPRV_WBSEL_COEF1 << ISPPRV_WBSEL_N0_1_SHIFT) |
+                       (ISPPRV_WBSEL_COEF0 << ISPPRV_WBSEL_N0_2_SHIFT) |
+                       (ISPPRV_WBSEL_COEF1 << ISPPRV_WBSEL_N0_3_SHIFT) |
+                       (ISPPRV_WBSEL_COEF2 << ISPPRV_WBSEL_N1_0_SHIFT) |
+                       (ISPPRV_WBSEL_COEF3 << ISPPRV_WBSEL_N1_1_SHIFT) |
+                       (ISPPRV_WBSEL_COEF2 << ISPPRV_WBSEL_N1_2_SHIFT) |
+                       (ISPPRV_WBSEL_COEF3 << ISPPRV_WBSEL_N1_3_SHIFT) |
+                       (ISPPRV_WBSEL_COEF0 << ISPPRV_WBSEL_N2_0_SHIFT) |
+                       (ISPPRV_WBSEL_COEF1 << ISPPRV_WBSEL_N2_1_SHIFT) |
+                       (ISPPRV_WBSEL_COEF0 << ISPPRV_WBSEL_N2_2_SHIFT) |
+                       (ISPPRV_WBSEL_COEF1 << ISPPRV_WBSEL_N2_3_SHIFT) |
+                       (ISPPRV_WBSEL_COEF2 << ISPPRV_WBSEL_N3_0_SHIFT) |
+                       (ISPPRV_WBSEL_COEF3 << ISPPRV_WBSEL_N3_1_SHIFT) |
+                       (ISPPRV_WBSEL_COEF2 << ISPPRV_WBSEL_N3_2_SHIFT) |
+                       (ISPPRV_WBSEL_COEF3 << ISPPRV_WBSEL_N3_3_SHIFT),
+                       ISPPRV_WBSEL);
+
+}
+EXPORT_SYMBOL(isppreview_config_whitebalance);
+
+/**
+ * isppreview_config_whitebalance2 - Configures the White Balance parameters.
+ * @prev_wbal: Structure containing the digital gain and white balance
+ *             coefficient.
+ *
+ * Coefficient matrix can be changed.
+ **/
+void isppreview_config_whitebalance2(struct prev_white_balance prev_wbal)
+{
+       omap_writel(prev_wbal.wb_dgain, ISPPRV_WB_DGAIN);
+       omap_writel(prev_wbal.wb_gain[0] |
+               (prev_wbal.wb_gain[1] << ISPPRV_WBGAIN_COEF1_SHIFT) |
+               (prev_wbal.wb_gain[2] << ISPPRV_WBGAIN_COEF2_SHIFT) |
+               (prev_wbal.wb_gain[3] << ISPPRV_WBGAIN_COEF3_SHIFT),
+               ISPPRV_WBGAIN);
+
+       omap_writel(prev_wbal.wb_coefmatrix[0][0] << ISPPRV_WBSEL_N0_0_SHIFT |
+               prev_wbal.wb_coefmatrix[0][1] << ISPPRV_WBSEL_N0_1_SHIFT |
+               prev_wbal.wb_coefmatrix[0][2] << ISPPRV_WBSEL_N0_2_SHIFT |
+               prev_wbal.wb_coefmatrix[0][3] << ISPPRV_WBSEL_N0_3_SHIFT |
+               prev_wbal.wb_coefmatrix[1][0] << ISPPRV_WBSEL_N1_0_SHIFT |
+               prev_wbal.wb_coefmatrix[1][1] << ISPPRV_WBSEL_N1_1_SHIFT |
+               prev_wbal.wb_coefmatrix[1][2] << ISPPRV_WBSEL_N1_2_SHIFT |
+               prev_wbal.wb_coefmatrix[1][3] << ISPPRV_WBSEL_N1_3_SHIFT |
+               prev_wbal.wb_coefmatrix[2][0] << ISPPRV_WBSEL_N2_0_SHIFT |
+               prev_wbal.wb_coefmatrix[2][1] << ISPPRV_WBSEL_N2_1_SHIFT |
+               prev_wbal.wb_coefmatrix[2][2] << ISPPRV_WBSEL_N2_2_SHIFT |
+               prev_wbal.wb_coefmatrix[2][3] << ISPPRV_WBSEL_N2_3_SHIFT |
+               prev_wbal.wb_coefmatrix[3][0] << ISPPRV_WBSEL_N3_0_SHIFT |
+               prev_wbal.wb_coefmatrix[3][1] << ISPPRV_WBSEL_N3_1_SHIFT |
+               prev_wbal.wb_coefmatrix[3][2] << ISPPRV_WBSEL_N3_2_SHIFT |
+               prev_wbal.wb_coefmatrix[3][3] << ISPPRV_WBSEL_N3_3_SHIFT,
+               ISPPRV_WBSEL);
+}
+EXPORT_SYMBOL(isppreview_config_whitebalance2);
+
+/**
+ * isppreview_config_blkadj - Configures the Black Adjustment parameters.
+ * @prev_blkadj: Structure containing the black adjustment towards red, green,
+ *               blue.
+ **/
+void isppreview_config_blkadj(struct ispprev_blkadj prev_blkadj)
+{
+       omap_writel(prev_blkadj.blue | (prev_blkadj.green <<
+                                       ISPPRV_BLKADJOFF_G_SHIFT) |
+                                       (prev_blkadj.red <<
+                                       ISPPRV_BLKADJOFF_R_SHIFT),
+                                       ISPPRV_BLKADJOFF);
+}
+EXPORT_SYMBOL(isppreview_config_blkadj);
+
+/**
+ * isppreview_config_rgb_blending - Configures the RGB-RGB Blending matrix.
+ * @rgb2rgb: Structure containing the rgb to rgb blending matrix and the rgb
+ *           offset.
+ **/
+void isppreview_config_rgb_blending(struct ispprev_rgbtorgb rgb2rgb)
+{
+       omap_writel((rgb2rgb.matrix[0][0] << ISPPRV_RGB_MAT1_MTX_RR_SHIFT) |
+                                               (rgb2rgb.matrix[0][1] <<
+                                               ISPPRV_RGB_MAT1_MTX_GR_SHIFT),
+                                               ISPPRV_RGB_MAT1);
+       omap_writel((rgb2rgb.matrix[0][2] << ISPPRV_RGB_MAT2_MTX_BR_SHIFT) |
+                                               (rgb2rgb.matrix[1][0] <<
+                                               ISPPRV_RGB_MAT2_MTX_RG_SHIFT),
+                                               ISPPRV_RGB_MAT2);
+
+       omap_writel((rgb2rgb.matrix[1][1] << ISPPRV_RGB_MAT3_MTX_GG_SHIFT) |
+                                               (rgb2rgb.matrix[1][2] <<
+                                               ISPPRV_RGB_MAT3_MTX_BG_SHIFT),
+                                               ISPPRV_RGB_MAT3);
+
+       omap_writel((rgb2rgb.matrix[2][0] << ISPPRV_RGB_MAT4_MTX_RB_SHIFT) |
+                                               (rgb2rgb.matrix[2][1] <<
+                                               ISPPRV_RGB_MAT4_MTX_GB_SHIFT),
+                                               ISPPRV_RGB_MAT4);
+
+       omap_writel((rgb2rgb.matrix[2][2] << ISPPRV_RGB_MAT5_MTX_BB_SHIFT),
+                                               ISPPRV_RGB_MAT5);
+
+       omap_writel((rgb2rgb.offset[0] << ISPPRV_RGB_OFF1_MTX_OFFG_SHIFT) |
+                                       (rgb2rgb.offset[1] <<
+                                       ISPPRV_RGB_OFF1_MTX_OFFR_SHIFT),
+                                       ISPPRV_RGB_OFF1);
+
+       omap_writel(rgb2rgb.offset[2] << ISPPRV_RGB_OFF2_MTX_OFFB_SHIFT,
+                                               ISPPRV_RGB_OFF2);
+
+}
+EXPORT_SYMBOL(isppreview_config_rgb_blending);
+
+/**
+ * Configures the RGB-YCbYCr conversion matrix
+ * @prev_csc: Structure containing the RGB to YCbYCr matrix and the
+ *            YCbCr offset.
+ **/
+void isppreview_config_rgb_to_ycbcr(struct ispprev_csc prev_csc)
+{
+       omap_writel(prev_csc.matrix[0][0] << ISPPRV_CSC0_RY_SHIFT |
+                               prev_csc.matrix[0][1] << ISPPRV_CSC0_GY_SHIFT |
+                               prev_csc.matrix[0][2] << ISPPRV_CSC0_BY_SHIFT,
+                               ISPPRV_CSC0);
+
+       omap_writel(prev_csc.matrix[1][0] << ISPPRV_CSC1_RCB_SHIFT |
+                       prev_csc.matrix[1][1] << ISPPRV_CSC1_GCB_SHIFT |
+                       prev_csc.matrix[1][2] << ISPPRV_CSC1_BCB_SHIFT,
+                       ISPPRV_CSC1);
+
+       omap_writel(prev_csc.matrix[2][0] << ISPPRV_CSC2_RCR_SHIFT |
+                       prev_csc.matrix[2][1] << ISPPRV_CSC2_GCR_SHIFT |
+                       prev_csc.matrix[2][2] << ISPPRV_CSC2_BCR_SHIFT,
+                       ISPPRV_CSC2);
+
+       omap_writel(prev_csc.offset[0] << ISPPRV_CSC_OFFSET_CR_SHIFT |
+                       prev_csc.offset[1] << ISPPRV_CSC_OFFSET_CB_SHIFT |
+                       prev_csc.offset[2] << ISPPRV_CSC_OFFSET_Y_SHIFT,
+                       ISPPRV_CSC_OFFSET);
+}
+EXPORT_SYMBOL(isppreview_config_rgb_to_ycbcr);
+
+/**
+ * isppreview_query_contrast - Query the contrast.
+ * @contrast: Pointer to hold the current programmed contrast value.
+ **/
+void isppreview_query_contrast(u8 *contrast)
+{
+       u32 brt_cnt_val = 0;
+       brt_cnt_val = omap_readl(ISPPRV_CNT_BRT);
+       *contrast = (brt_cnt_val >> ISPPRV_CNT_BRT_CNT_SHIFT) & 0xFF;
+       DPRINTK_ISPPREV(" Current brt cnt value in hw is %x\n", brt_cnt_val);
+}
+EXPORT_SYMBOL(isppreview_query_contrast);
+
+/**
+ * isppreview_update_contrast - Updates the contrast.
+ * @contrast: Pointer to hold the current programmed contrast value.
+ *
+ * Value should be programmed before enabling the module.
+ **/
+void isppreview_update_contrast(u8 *contrast)
+{
+       ispprev_obj.contrast = *contrast;
+}
+EXPORT_SYMBOL(isppreview_update_contrast);
+
+/**
+ * isppreview_config_contrast - Configures the Contrast.
+ * @contrast: 8 bit value in U8Q4 format.
+ *
+ * Value should be programmed before enabling the module.
+ **/
+void isppreview_config_contrast(u8 contrast)
+{
+       u32 brt_cnt_val = 0;
+
+       brt_cnt_val = omap_readl(ISPPRV_CNT_BRT);
+       brt_cnt_val &= ~(0xFF << ISPPRV_CNT_BRT_CNT_SHIFT);
+       contrast &= 0xFF;
+       omap_writel(brt_cnt_val | (contrast << ISPPRV_CNT_BRT_CNT_SHIFT),
+                                                       ISPPRV_CNT_BRT);
+}
+EXPORT_SYMBOL(isppreview_config_contrast);
+
+/**
+ * isppreview_get_contrast_range - Gets the range contrast value.
+ * @min_contrast: Pointer to hold the minimum Contrast value.
+ * @max_contrast: Pointer to hold the maximum Contrast value.
+ **/
+void isppreview_get_contrast_range(u8 *min_contrast, u8 *max_contrast)
+{
+       *min_contrast = ISPPRV_CONTRAST_MIN;
+       *max_contrast = ISPPRV_CONTRAST_MAX;
+}
+EXPORT_SYMBOL(isppreview_get_contrast_range);
+
+/**
+ * isppreview_update_brightness - Updates the brightness in preview module.
+ * @brightness: Pointer to hold the current programmed brightness value.
+ *
+ **/
+void isppreview_update_brightness(u8 *brightness)
+{
+       ispprev_obj.brightness = *brightness;
+}
+EXPORT_SYMBOL(isppreview_update_brightness);
+
+/**
+ * isppreview_config_brightness - Configures the brightness.
+ * @contrast: 8bitvalue in U8Q0 format.
+ **/
+void isppreview_config_brightness(u8 brightness)
+{
+       u32 brt_cnt_val = 0;
+       DPRINTK_ISPPREV("\tConfiguring brightness in ISP: %d\n", brightness);
+       brt_cnt_val = omap_readl(ISPPRV_CNT_BRT);
+       brt_cnt_val &= ~(0xFF << ISPPRV_CNT_BRT_BRT_SHIFT);
+       brightness &= 0xFF;
+       omap_writel(brt_cnt_val | (brightness << ISPPRV_CNT_BRT_BRT_SHIFT),
+                                                       ISPPRV_CNT_BRT);
+}
+EXPORT_SYMBOL(isppreview_config_brightness);
+
+/**
+ * isppreview_query_brightness - Query the brightness.
+ * @brightness: Pointer to hold the current programmed brightness value.
+ **/
+void isppreview_query_brightness(u8 *brightness)
+{
+
+       *brightness = omap_readl(ISPPRV_CNT_BRT);
+}
+EXPORT_SYMBOL(isppreview_query_brightness);
+
+/**
+ * isppreview_get_brightness_range - Gets the range brightness value
+ * @min_brightness: Pointer to hold the minimum brightness value
+ * @max_brightness: Pointer to hold the maximum brightness value
+ **/
+void isppreview_get_brightness_range(u8 *min_brightness, u8 *max_brightness)
+{
+       *min_brightness = ISPPRV_BRIGHT_MIN;
+       *max_brightness = ISPPRV_BRIGHT_MAX;
+}
+EXPORT_SYMBOL(isppreview_get_brightness_range);
+
+/**
+ * isppreview_set_color - Sets the color effect.
+ * @mode: Indicates the required color effect.
+ **/
+void isppreview_set_color(u8 *mode)
+{
+       ispprev_obj.color = *mode;
+       update_color_matrix = 1;
+}
+EXPORT_SYMBOL(isppreview_set_color);
+
+/**
+ * isppreview_get_color - Gets the current color effect.
+ * @mode: Indicates the current color effect.
+ **/
+void isppreview_get_color(u8 *mode)
+{
+       *mode = ispprev_obj.color;
+}
+EXPORT_SYMBOL(isppreview_get_color);
+
+/**
+ * isppreview_config_yc_range - Configures the max and min Y and C values.
+ * @yclimit: Structure containing the range of Y and C values.
+ **/
+void isppreview_config_yc_range(struct ispprev_yclimit yclimit)
+{
+       omap_writel(((yclimit.maxC << ISPPRV_SETUP_YC_MAXC_SHIFT) |
+                               (yclimit.maxY << ISPPRV_SETUP_YC_MAXY_SHIFT) |
+                               (yclimit.minC << ISPPRV_SETUP_YC_MINC_SHIFT) |
+                               (yclimit.minY << ISPPRV_SETUP_YC_MINY_SHIFT)),
+                               ISPPRV_SETUP_YC);
+}
+EXPORT_SYMBOL(isppreview_config_yc_range);
+
+/**
+ * isppreview_try_size - Calculates output dimensions with the modules enabled.
+ * @input_w: input width for the preview in number of pixels per line
+ * @input_h: input height for the preview in number of lines
+ * @output_w: output width from the preview in number of pixels per line
+ * @output_h: output height for the preview in number of lines
+ *
+ * Calculates the number of pixels cropped in the submodules that are enabled,
+ * Fills up the output width height variables in the isp_prev structure.
+ **/
+int isppreview_try_size(u32 input_w, u32 input_h, u32 *output_w, u32 *output_h)
+{
+       u32 prevout_w = input_w;
+       u32 prevout_h = input_h;
+       u32 div = 0;
+       int max_out;
+
+       ispprev_obj.previn_w = input_w;
+       ispprev_obj.previn_h = input_h;
+
+       if (is_sil_rev_equal_to(OMAP3430_REV_ES1_0))
+               max_out = ISPPRV_MAXOUTPUT_WIDTH;
+       else
+               max_out = ISPPRV_MAXOUTPUT_WIDTH_ES2;
+
+       ispprev_obj.fmtavg = 0;
+
+       if (input_w > max_out) {
+               div = (input_w/max_out);
+               if (div >= 2 && div < 4) {
+                       ispprev_obj.fmtavg = 1;
+                       prevout_w /= 2;
+               } else if (div >= 4 && div < 8) {
+                       ispprev_obj.fmtavg = 2;
+                       prevout_w /= 4;
+               } else if (div >= 8) {
+                       ispprev_obj.fmtavg = 3;
+                       prevout_w /= 8;
+               }
+       }
+
+       if (ispprev_obj.hmed_en)
+               prevout_w -= 4;
+       if (ispprev_obj.nf_en) {
+               prevout_w -= 4;
+               prevout_h -= 4;
+       }
+       if (ispprev_obj.cfa_en) {
+               switch (ispprev_obj.cfafmt) {
+               case CFAFMT_BAYER:
+               case CFAFMT_SONYVGA:
+                       prevout_w -= 4;
+                       prevout_h -= 4;
+                       break;
+               case CFAFMT_RGBFOVEON:
+               case CFAFMT_RRGGBBFOVEON:
+               case CFAFMT_DNSPL:
+               case CFAFMT_HONEYCOMB:
+                       prevout_h -= 2;
+                       break;
+               };
+       }
+       if ((ispprev_obj.yenh_en) || (ispprev_obj.csup_en))
+               prevout_w -= 2;
+
+       prevout_w -= 4;
+
+       if (prevout_w % 2)
+               prevout_w -= 1;
+
+       if (ispprev_obj.prev_outfmt == PREVIEW_MEM) {
+               if (((prevout_w * 2) & ISP_32B_BOUNDARY_OFFSET) != (prevout_w *
+                                                                       2)) {
+                       prevout_w = ((prevout_w * 2) &
+                                               ISP_32B_BOUNDARY_OFFSET) / 2;
+               }
+       }
+       *output_w = prevout_w;
+       ispprev_obj.prevout_w = prevout_w;
+       *output_h = prevout_h;
+       ispprev_obj.prevout_h = prevout_h;
+       return 0;
+}
+EXPORT_SYMBOL(isppreview_try_size);
+
+/**
+ * isppreview_config_size - Sets the size of ISP preview output.
+ * @input_w: input width for the preview in number of pixels per line
+ * @input_h: input height for the preview in number of lines
+ * @output_w: output width from the preview in number of pixels per line
+ * @output_h: output height for the preview in number of lines
+ *
+ * Configures the appropriate values stored in the isp_prev structure to
+ * HORZ/VERT_INFO. Configures PRV_AVE if needed for downsampling as calculated
+ * in trysize.
+ **/
+int isppreview_config_size(u32 input_w, u32 input_h, u32 output_w,
+                                                               u32 output_h)
+{
+       u32 prevsdroff;
+
+       if ((output_w != ispprev_obj.prevout_w) ||
+                                       (output_h != ispprev_obj.prevout_h)) {
+               printk(KERN_ERR "ISP_ERR : isppreview_try_size should "
+                                       "be called before config size\n");
+               return -EINVAL;
+       }
+
+       omap_writel((4 << ISPPRV_HORZ_INFO_SPH_SHIFT) |
+                                               (ispprev_obj.previn_w - 1),
+                                               ISPPRV_HORZ_INFO);
+       omap_writel((0 << ISPPRV_VERT_INFO_SLV_SHIFT) |
+                                               (ispprev_obj.previn_h - 1),
+                                               ISPPRV_VERT_INFO);
+
+       if (ispprev_obj.cfafmt == CFAFMT_BAYER)
+               omap_writel(ISPPRV_AVE_EVENDIST_2 <<
+                                       ISPPRV_AVE_EVENDIST_SHIFT |
+                                       ISPPRV_AVE_ODDDIST_2 <<
+                                       ISPPRV_AVE_ODDDIST_SHIFT |
+                                       ispprev_obj.fmtavg,
+                                       ISPPRV_AVE);
+
+       if (ispprev_obj.prev_outfmt == PREVIEW_MEM) {
+               prevsdroff = ispprev_obj.prevout_w * 2;
+               if ((prevsdroff & ISP_32B_BOUNDARY_OFFSET) != prevsdroff) {
+                       DPRINTK_ISPPREV("ISP_WARN: Preview output buffer line"
+                                               " size is truncated"
+                                               " to 32byte boundary\n");
+                       prevsdroff &= ISP_32B_BOUNDARY_BUF ;
+               }
+               isppreview_config_outlineoffset(prevsdroff);
+       }
+       return 0;
+}
+EXPORT_SYMBOL(isppreview_config_size);
+
+/**
+ * isppreview_config_inlineoffset - Configures the Read address line offset.
+ * @offset: Line Offset for the input image.
+ **/
+int isppreview_config_inlineoffset(u32 offset)
+{
+       if ((offset & ISP_32B_BOUNDARY_OFFSET) == offset)
+               omap_writel(offset & 0xFFFF, ISPPRV_RADR_OFFSET);
+       else {
+               printk(KERN_ERR "ISP_ERR : Offset should be in 32 byte "
+                                                               "boundary\n");
+               return -EINVAL;
+       }
+       return 0;
+}
+EXPORT_SYMBOL(isppreview_config_inlineoffset);
+
+/**
+ * isppreview_set_inaddr - Sets memory address of input frame.
+ * @addr: 32bit memory address aligned on 32byte boundary.
+ *
+ * Configures the memory address from which the input frame is to be read.
+ **/
+int isppreview_set_inaddr(u32 addr)
+{
+       if ((addr & ISP_32B_BOUNDARY_BUF) == addr)
+               omap_writel(addr, ISPPRV_RSDR_ADDR);
+       else {
+               printk(KERN_ERR "ISP_ERR: Address should be in 32 byte "
+                                                               "boundary\n");
+               return -EINVAL;
+       }
+       return 0;
+}
+EXPORT_SYMBOL(isppreview_set_inaddr);
+
+/**
+ * isppreview_config_outlineoffset - Configures the Write address line offset.
+ * @offset: Line Offset for the preview output.
+ **/
+int isppreview_config_outlineoffset(u32 offset)
+{
+       if ((offset & ISP_32B_BOUNDARY_OFFSET) == offset) {
+               omap_writel(offset & 0xFFFF, ISPPRV_WADD_OFFSET);
+       } else {
+               printk(KERN_ERR "ISP_ERR : Offset should be in 32 byte "
+                                                               "boundary\n");
+               return -EINVAL;
+       }
+       return 0;
+}
+EXPORT_SYMBOL(isppreview_config_outlineoffset);
+
+/**
+ * isppreview_set_outaddr - Sets the memory address to store output frame
+ * @addr: 32bit memory address aligned on 32byte boundary.
+ *
+ * Configures the memory address to which the output frame is written.
+ **/
+int isppreview_set_outaddr(u32 addr)
+{
+       if ((addr & ISP_32B_BOUNDARY_BUF) == addr) {
+               omap_writel(addr, ISPPRV_WSDR_ADDR);
+       } else {
+               printk(KERN_ERR "ISP_ERR: Address should be in 32 byte "
+                                                               "boundary\n");
+               return -EINVAL;
+       }
+       return 0;
+}
+EXPORT_SYMBOL(isppreview_set_outaddr);
+
+/**
+ * isppreview_config_darklineoffset - Sets the Dark frame address line offset.
+ * @offset: Line Offset for the Darkframe.
+ **/
+int isppreview_config_darklineoffset(u32 offset)
+{
+       if ((offset & ISP_32B_BOUNDARY_OFFSET) == offset)
+               omap_writel(offset & 0xFFFF, ISPPRV_DRKF_OFFSET);
+       else {
+               printk(KERN_ERR "ISP_ERR : Offset should be in 32 byte "
+                                                               "boundary\n");
+               return -EINVAL;
+       }
+       return 0;
+}
+EXPORT_SYMBOL(isppreview_config_darklineoffset);
+
+/**
+ * isppreview_set_darkaddr - Sets the memory address to store Dark frame.
+ * @addr: 32bit memory address aligned on 32 bit boundary.
+ **/
+int isppreview_set_darkaddr(u32 addr)
+{
+       if ((addr & ISP_32B_BOUNDARY_BUF) == addr)
+               omap_writel(addr, ISPPRV_DSDR_ADDR);
+       else {
+               printk(KERN_ERR "ISP_ERR : Address should be in 32 byte "
+                                                               "boundary\n");
+               return -EINVAL;
+       }
+       return 0;
+}
+EXPORT_SYMBOL(isppreview_set_darkaddr);
+
+/**
+ * isppreview_enable - Enables the Preview module.
+ * @enable: 1 - Enables the preview module.
+ *
+ * Client should configure all the sub modules in Preview before this.
+ **/
+void isppreview_enable(u8 enable)
+{
+
+       if (enable) {
+               omap_writel((omap_readl(ISPPRV_PCR)) | ISPPRV_PCR_EN,
+                                                               ISPPRV_PCR);
+       } else {
+               omap_writel((omap_readl(ISPPRV_PCR)) & ~ISPPRV_PCR_EN,
+                                                               ISPPRV_PCR);
+       }
+}
+EXPORT_SYMBOL(isppreview_enable);
+
+/**
+ * isppreview_busy - Gets busy state of preview module.
+ **/
+int isppreview_busy(void)
+{
+       return omap_readl(ISPPRV_PCR) & ISPPRV_PCR_BUSY;
+}
+EXPORT_SYMBOL(isppreview_busy);
+
+/**
+ * isppreview_get_config - Gets parameters of preview module.
+ **/
+struct prev_params *isppreview_get_config(void)
+{
+       return prev_config_params;
+}
+EXPORT_SYMBOL(isppreview_get_config);
+
+/**
+ * isppreview_save_context - Saves the values of the preview module registers.
+ **/
+void isppreview_save_context(void)
+{
+       DPRINTK_ISPPREV("Saving context\n");
+       isp_save_context(ispprev_reg_list);
+}
+EXPORT_SYMBOL(isppreview_save_context);
+
+/**
+ * isppreview_restore_context - Restores the values of preview module registers
+ **/
+void isppreview_restore_context(void)
+{
+       DPRINTK_ISPPREV("Restoring context\n");
+       isp_restore_context(ispprev_reg_list);
+}
+EXPORT_SYMBOL(isppreview_restore_context);
+
+/**
+ * isppreview_print_status - Prints the values of the Preview Module registers.
+ *
+ * Also prints other debug information stored in the preview moduel.
+ **/
+void isppreview_print_status(void)
+{
+#ifdef OMAP_ISPPREV_DEBUG
+       printk("Module in use =%d\n", ispprev_obj.prev_inuse);
+       DPRINTK_ISPPREV("Preview Input format =%d, Output Format =%d\n",
+                                               ispprev_obj.prev_inpfmt,
+                                               ispprev_obj.prev_outfmt);
+       DPRINTK_ISPPREV("Accepted Preview Input (width = %d,Height = %d)\n",
+                                               ispprev_obj.previn_w,
+                                               ispprev_obj.previn_h);
+       DPRINTK_ISPPREV("Accepted Preview Output (width = %d,Height = %d)\n",
+                                               ispprev_obj.prevout_w,
+                                               ispprev_obj.prevout_h);
+       DPRINTK_ISPPREV("###ISP_CTRL in preview =0x%x\n",
+                                               omap_readl(ISP_CTRL));
+       DPRINTK_ISPPREV("###ISP_IRQ0ENABLE in preview =0x%x\n",
+                                               omap_readl(ISP_IRQ0ENABLE));
+       DPRINTK_ISPPREV("###ISP_IRQ0STATUS in preview =0x%x\n",
+                                               omap_readl(ISP_IRQ0STATUS));
+       DPRINTK_ISPPREV("###PRV PCR =0x%x\n", omap_readl(ISPPRV_PCR));
+       DPRINTK_ISPPREV("###PRV HORZ_INFO =0x%x\n",
+                                               omap_readl(ISPPRV_HORZ_INFO));
+       DPRINTK_ISPPREV("###PRV VERT_INFO =0x%x\n",
+                                               omap_readl(ISPPRV_VERT_INFO));
+       DPRINTK_ISPPREV("###PRV WSDR_ADDR =0x%x\n",
+                                               omap_readl(ISPPRV_WSDR_ADDR));
+       DPRINTK_ISPPREV("###PRV WADD_OFFSET =0x%x\n",
+                                       omap_readl(ISPPRV_WADD_OFFSET));
+       DPRINTK_ISPPREV("###PRV AVE =0x%x\n", omap_readl(ISPPRV_AVE));
+       DPRINTK_ISPPREV("###PRV HMED =0x%x\n", omap_readl(ISPPRV_HMED));
+       DPRINTK_ISPPREV("###PRV NF =0x%x\n", omap_readl(ISPPRV_NF));
+       DPRINTK_ISPPREV("###PRV WB_DGAIN =0x%x\n",
+                                               omap_readl(ISPPRV_WB_DGAIN));
+       DPRINTK_ISPPREV("###PRV WBGAIN =0x%x\n", omap_readl(ISPPRV_WBGAIN));
+       DPRINTK_ISPPREV("###PRV WBSEL =0x%x\n", omap_readl(ISPPRV_WBSEL));
+       DPRINTK_ISPPREV("###PRV CFA =0x%x\n", omap_readl(ISPPRV_CFA));
+       DPRINTK_ISPPREV("###PRV BLKADJOFF =0x%x\n",
+                                               omap_readl(ISPPRV_BLKADJOFF));
+       DPRINTK_ISPPREV("###PRV RGB_MAT1 =0x%x\n",
+                                               omap_readl(ISPPRV_RGB_MAT1));
+       DPRINTK_ISPPREV("###PRV RGB_MAT2 =0x%x\n",
+                                               omap_readl(ISPPRV_RGB_MAT2));
+       DPRINTK_ISPPREV("###PRV RGB_MAT3 =0x%x\n",
+                                               omap_readl(ISPPRV_RGB_MAT3));
+       DPRINTK_ISPPREV("###PRV RGB_MAT4 =0x%x\n",
+                                               omap_readl(ISPPRV_RGB_MAT4));
+       DPRINTK_ISPPREV("###PRV RGB_MAT5 =0x%x\n",
+                                               omap_readl(ISPPRV_RGB_MAT5));
+       DPRINTK_ISPPREV("###PRV RGB_OFF1 =0x%x\n",
+                                               omap_readl(ISPPRV_RGB_OFF1));
+       DPRINTK_ISPPREV("###PRV RGB_OFF2 =0x%x\n",
+                                               omap_readl(ISPPRV_RGB_OFF2));
+       DPRINTK_ISPPREV("###PRV CSC0 =0x%x\n", omap_readl(ISPPRV_CSC0));
+       DPRINTK_ISPPREV("###PRV CSC1 =0x%x\n", omap_readl(ISPPRV_CSC1));
+       DPRINTK_ISPPREV("###PRV CSC2 =0x%x\n", omap_readl(ISPPRV_CSC2));
+       DPRINTK_ISPPREV("###PRV CSC_OFFSET =0x%x\n",
+                                               omap_readl(ISPPRV_CSC_OFFSET));
+       DPRINTK_ISPPREV("###PRV CNT_BRT =0x%x\n", omap_readl(ISPPRV_CNT_BRT));
+       DPRINTK_ISPPREV("###PRV CSUP =0x%x\n", omap_readl(ISPPRV_CSUP));
+       DPRINTK_ISPPREV("###PRV SETUP_YC =0x%x\n",
+                                               omap_readl(ISPPRV_SETUP_YC));
+#endif
+}
+EXPORT_SYMBOL(isppreview_print_status);
+
+/**
+ * isp_preview_init - Module Initialization.
+ **/
+int __init isp_preview_init(void)
+{
+       int i = 0;
+
+       prev_config_params = kmalloc(sizeof(*prev_config_params), GFP_KERNEL);
+       if (prev_config_params == NULL) {
+               printk(KERN_ERR "Can't get memory for isp_preview params!\n");
+               return -ENOMEM;
+       }
+       params = prev_config_params;
+
+       ispprev_obj.prev_inuse = 0;
+       mutex_init(&ispprev_obj.ispprev_mutex);
+
+       if (is_sil_rev_equal_to(OMAP3430_REV_ES2_0)) {
+               flr_wbal_coef0 = 0x23;
+               flr_wbal_coef1 = 0x20;
+               flr_wbal_coef2 = 0x20;
+               flr_wbal_coef3 = 0x39;
+       }
+
+       /* Init values */
+       ispprev_obj.color = PREV_DEFAULT_COLOR;
+       ispprev_obj.contrast = ISPPRV_CONTRAST_DEF;
+       params->contrast = ISPPRV_CONTRAST_DEF;
+       ispprev_obj.brightness = ISPPRV_BRIGHT_DEF;
+       params->brightness = ISPPRV_BRIGHT_DEF;
+       params->average = NO_AVE;
+       params->lens_shading_shift = 0;
+       params->pix_fmt = YCPOS_YCrYCb;
+       params->cfa.cfafmt = CFAFMT_BAYER;
+       params->cfa.cfa_table = cfa_coef_table;
+       params->cfa.cfa_gradthrs_horz = flr_cfa_gradthrs_horz;
+       params->cfa.cfa_gradthrs_vert = flr_cfa_gradthrs_vert;
+       params->csup.gain = flr_csup_gain;
+       params->csup.thres = flr_csup_thres;
+       params->csup.hypf_en = 0;
+       params->ytable = luma_enhance_table;
+       params->nf.spread = flr_nf_strgth;
+       memcpy(params->nf.table, noise_filter_table, sizeof(params->nf.table));
+       params->dcor.couplet_mode_en = 1;
+       for (i = 0; i < 4; i++)
+               params->dcor.detect_correct[i] = 0xE;
+       params->gtable.bluetable = bluegamma_table;
+       params->gtable.greentable = greengamma_table;
+       params->gtable.redtable = redgamma_table;
+       params->wbal.dgain = flr_wbal_dgain;
+       params->wbal.coef0 = flr_wbal_coef0;
+       params->wbal.coef1 = flr_wbal_coef1;
+       params->wbal.coef2 = flr_wbal_coef2;
+       params->wbal.coef3 = flr_wbal_coef3;
+       params->blk_adj.red = flr_blkadj_red;
+       params->blk_adj.green = flr_blkadj_green;
+       params->blk_adj.blue = flr_blkadj_blue;
+       params->rgb2rgb = flr_rgb2rgb;
+       params->rgb2ycbcr = flr_prev_csc[ispprev_obj.color];
+
+       params->features = PREV_CFA | PREV_CHROMA_SUPPRESS | PREV_LUMA_ENHANCE
+                               | PREV_DEFECT_COR | PREV_NOISE_FILTER;
+       params->features &= ~(PREV_AVERAGER | PREV_INVERSE_ALAW |
+                                               PREV_HORZ_MEDIAN_FILTER |
+                                               PREV_GAMMA_BYPASS |
+                                               PREV_DARK_FRAME_SUBTRACT |
+                                               PREV_LENS_SHADING |
+                                               PREV_DARK_FRAME_CAPTURE);
+       return 0;
+}
+
+/**
+ * isp_preview_cleanup - Module Cleanup.
+ **/
+void __exit isp_preview_cleanup(void)
+{
+       kfree(prev_config_params);
+       prev_config_params = NULL;
+}
Index: linux-omap-2.6/drivers/media/video/isp/isppreview.h
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/isp/isppreview.h 2008-08-28 19:08:43.000000000 -0500
@@ -0,0 +1,349 @@
+/*
+ * drivers/media/video/isp/isppreview.h
+ *
+ * Driver header file for Preview module in TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments, Inc.
+ *
+ * Contributors:
+ *     Senthilvadivu Guruswamy <svadivu@ti.com>
+ *     Pallavi Kulkarni <p-kulkarni@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#ifndef OMAP_ISP_PREVIEW_H
+#define OMAP_ISP_PREVIEW_H
+
+#include <mach/isp_user.h>
+/* Isp query control structure */
+
+#define ISPPRV_BRIGHT_STEP             0x1
+#define ISPPRV_BRIGHT_DEF              0x1
+#define ISPPRV_BRIGHT_LOW              0x0
+#define ISPPRV_BRIGHT_HIGH             0xF
+#define ISPPRV_BRIGHT_UNITS            0x7
+
+#define ISPPRV_CONTRAST_STEP           0x1
+#define ISPPRV_CONTRAST_DEF            0x2
+#define ISPPRV_CONTRAST_LOW            0x0
+#define ISPPRV_CONTRAST_HIGH           0xF
+#define ISPPRV_CONTRAST_UNITS          0x5
+
+#define NO_AVE                         0x0
+#define AVE_2_PIX                      0x1
+#define AVE_4_PIX                      0x2
+#define AVE_8_PIX                      0x3
+#define AVE_ODD_PIXEL_DIST             (1 << 4) /* For Bayer Sensors */
+#define AVE_EVEN_PIXEL_DIST            (1 << 2)
+
+#define WB_GAIN_MAX                    4
+
+/* Features list */
+#define PREV_AVERAGER                  (1 << 0)
+#define PREV_INVERSE_ALAW              (1 << 1)
+#define PREV_HORZ_MEDIAN_FILTER                (1 << 2)
+#define PREV_NOISE_FILTER              (1 << 3)
+#define PREV_CFA                       (1 << 4)
+#define PREV_GAMMA_BYPASS              (1 << 5)
+#define PREV_LUMA_ENHANCE              (1 << 6)
+#define PREV_CHROMA_SUPPRESS           (1 << 7)
+#define PREV_DARK_FRAME_SUBTRACT       (1 << 8)
+#define PREV_LENS_SHADING              (1 << 9)
+#define PREV_DARK_FRAME_CAPTURE                (1 << 10)
+#define PREV_DEFECT_COR                        (1 << 11)
+
+
+#define ISP_NF_TABLE_SIZE              (1 << 10)
+
+#define ISP_GAMMA_TABLE_SIZE           (1 << 10)
+
+/*
+ *Enumeration Constants for input and output format
+ */
+enum preview_input {
+       PRV_RAW_CCDC,
+       PRV_RAW_MEM,
+       PRV_RGBBAYERCFA,
+       PRV_COMPCFA,
+       PRV_CCDC_DRKF,
+       PRV_OTHERS
+};
+enum preview_output {
+       PREVIEW_RSZ,
+       PREVIEW_MEM
+};
+/*
+ * Configure byte layout of YUV image
+ */
+enum preview_ycpos_mode {
+       YCPOS_YCrYCb = 0,
+       YCPOS_YCbYCr = 1,
+       YCPOS_CbYCrY = 2,
+       YCPOS_CrYCbY = 3
+};
+
+enum preview_color_effect {
+       PREV_DEFAULT_COLOR = 0,
+       PREV_BW_COLOR = 1,
+       PREV_SEPIA_COLOR = 2
+};
+
+
+/**
+ * struct ispprev_gtable - Structure for Gamma Correction.
+ * @redtable: Pointer to the red gamma table.
+ * @greentable: Pointer to the green gamma table.
+ * @bluetable: Pointer to the blue gamma table.
+ */
+struct ispprev_gtable {
+       u32 *redtable;
+       u32 *greentable;
+       u32 *bluetable;
+};
+
+/**
+ * struct prev_white_balance - Structure for White Balance 2.
+ * @wb_dgain: White balance common gain.
+ * @wb_gain: Individual color gains.
+ * @wb_coefmatrix: Coefficient matrix
+ */
+struct prev_white_balance {
+       u16 wb_dgain; /* white balance common gain */
+       u8 wb_gain[WB_GAIN_MAX]; /* individual color gains */
+       u8 wb_coefmatrix[WB_GAIN_MAX][WB_GAIN_MAX];
+};
+
+/**
+ * struct prev_size_params - Structure for size parameters.
+ * @hstart: Starting pixel.
+ * @vstart: Starting line.
+ * @hsize: Width of input image.
+ * @vsize: Height of input image.
+ * @pixsize: Pixel size of the image in terms of bits.
+ * @in_pitch: Line offset of input image.
+ * @out_pitch: Line offset of output image.
+ */
+struct prev_size_params {
+       unsigned int hstart;
+       unsigned int vstart;
+       unsigned int hsize;
+       unsigned int vsize;
+       unsigned char pixsize;
+       unsigned short in_pitch;
+       unsigned short out_pitch;
+};
+
+/**
+ * struct prev_rgb2ycbcr_coeffs - Structure RGB2YCbCr parameters.
+ * @coeff: Color conversion gains in 3x3 matrix.
+ * @offset: Color conversion offsets.
+ */
+struct prev_rgb2ycbcr_coeffs {
+       short coeff[RGB_MAX][RGB_MAX];
+       short offset[RGB_MAX];
+};
+
+/**
+ * struct prev_darkfrm_params - Structure for Dark frame suppression.
+ * @addr: Memory start address.
+ * @offset: Line offset.
+ */
+struct prev_darkfrm_params {
+       u32 addr;
+       u32 offset;
+};
+
+/**
+ * struct prev_params - Structure for all configuration
+ * @features: Set of features enabled.
+ * @pix_fmt: Output pixel format.
+ * @cfa: CFA coefficients.
+ * @csup: Chroma suppression coefficients.
+ * @ytable: Pointer to Luma enhancement coefficients.
+ * @nf: Noise filter coefficients.
+ * @dcor: Noise filter coefficients.
+ * @gtable: Gamma coefficients.
+ * @wbal: White Balance parameters.
+ * @blk_adj: Black adjustment parameters.
+ * @rgb2rgb: RGB blending parameters.
+ * @rgb2ycbcr: RGB to ycbcr parameters.
+ * @hmf_params: Horizontal median filter.
+ * @size_params: Size parameters.
+ * @drkf_params: Darkframe parameters.
+ * @lens_shading_shift:
+ * @average: Downsampling rate for averager.
+ * @contrast: Contrast.
+ * @brightness: Brightness.
+ */
+struct prev_params {
+       u16 features;
+       enum preview_ycpos_mode pix_fmt;
+       struct ispprev_cfa cfa;
+       struct ispprev_csup csup;
+       u32 *ytable;
+       struct ispprev_nf nf;
+       struct ispprev_dcor dcor;
+       struct ispprev_gtable gtable;
+       struct ispprev_wbal wbal;
+       struct ispprev_blkadj blk_adj;
+       struct ispprev_rgbtorgb rgb2rgb;
+       struct ispprev_csc rgb2ycbcr;
+       struct ispprev_hmed hmf_params;
+       struct prev_size_params size_params;
+       struct prev_darkfrm_params drkf_params;
+       u8 lens_shading_shift;
+       u8 average;
+       u8 contrast;
+       u8 brightness;
+};
+
+/**
+ * struct isptables_update - Structure for Table Configuration.
+ * @update: Specifies which tables should be updated.
+ * @flag: Specifies which tables should be enabled.
+ * @prev_nf: Pointer to structure for Noise Filter
+ * @lsc: Pointer to LSC gain table. (currently not used)
+ * @red_gamma: Pointer to red gamma correction table.
+ * @green_gamma: Pointer to green gamma correction table.
+ * @blue_gamma: Pointer to blue gamma correction table.
+ */
+struct isptables_update {
+       u16 update;
+       u16 flag;
+       struct ispprev_nf *prev_nf;
+       u32 *lsc;
+       u32 *red_gamma;
+       u32 *green_gamma;
+       u32 *blue_gamma;
+};
+
+void isppreview_config_shadow_registers(void);
+
+int isppreview_request(void);
+
+int isppreview_free(void);
+
+int isppreview_config_datapath(enum preview_input input,
+                                       enum preview_output output);
+
+void isppreview_config_ycpos(enum preview_ycpos_mode mode);
+
+void isppreview_config_averager(u8 average);
+
+void isppreview_enable_invalaw(u8 enable);
+
+void isppreview_enable_drkframe(u8 enable);
+
+void isppreview_enable_shadcomp(u8 enable);
+
+void isppreview_config_drkf_shadcomp(u8 scomp_shtval);
+
+void isppreview_enable_gammabypass(u8 enable);
+
+void isppreview_enable_hmed(u8 enable);
+
+void isppreview_config_hmed(struct ispprev_hmed);
+
+void isppreview_enable_noisefilter(u8 enable);
+
+void isppreview_config_noisefilter(struct ispprev_nf prev_nf);
+
+void isppreview_enable_dcor(u8 enable);
+
+void isppreview_config_dcor(struct ispprev_dcor prev_dcor);
+
+
+void isppreview_config_cfa(struct ispprev_cfa);
+
+void isppreview_config_gammacorrn(struct ispprev_gtable);
+
+void isppreview_config_chroma_suppression(struct ispprev_csup csup);
+
+void isppreview_enable_cfa(u8 enable);
+
+void isppreview_config_luma_enhancement(u32 *ytable);
+
+void isppreview_enable_luma_enhancement(u8 enable);
+
+void isppreview_enable_chroma_suppression(u8 enable);
+
+void isppreview_config_whitebalance(struct ispprev_wbal);
+
+void isppreview_config_blkadj(struct ispprev_blkadj);
+
+void isppreview_config_rgb_blending(struct ispprev_rgbtorgb);
+
+void isppreview_config_rgb_to_ycbcr(struct ispprev_csc);
+
+void isppreview_update_contrast(u8 *contrast);
+
+void isppreview_query_contrast(u8 *contrast);
+
+void isppreview_config_contrast(u8 contrast);
+
+void isppreview_get_contrast_range(u8 *min_contrast, u8 *max_contrast);
+
+void isppreview_update_brightness(u8 *brightness);
+
+void isppreview_config_brightness(u8 brightness);
+
+void isppreview_get_brightness_range(u8 *min_brightness, u8 *max_brightness);
+
+void isppreview_set_color(u8 *mode);
+
+void isppreview_get_color(u8 *mode);
+
+void isppreview_query_brightness(u8 *brightness);
+
+void isppreview_config_yc_range(struct ispprev_yclimit yclimit);
+
+int isppreview_try_size(u32 input_w, u32 input_h, u32 *output_w,
+                               u32 *output_h);
+
+int isppreview_config_size(u32 input_w, u32 input_h, u32 output_w,
+                       u32 output_h);
+
+int isppreview_config_inlineoffset(u32 offset);
+
+int isppreview_set_inaddr(u32 addr);
+
+int isppreview_config_outlineoffset(u32 offset);
+
+int isppreview_set_outaddr(u32 addr);
+
+int isppreview_config_darklineoffset(u32 offset);
+
+int isppreview_set_darkaddr(u32 addr);
+
+void isppreview_enable(u8 enable);
+
+int isppreview_busy(void);
+
+struct prev_params *isppreview_get_config(void);
+
+void isppreview_print_status(void);
+
+#ifndef CONFIG_ARCH_OMAP3410
+void isppreview_save_context(void);
+#else
+static inline void isppreview_save_context(void) {}
+#endif
+
+#ifndef CONFIG_ARCH_OMAP3410
+void isppreview_restore_context(void);
+#else
+static inline void isppreview_restore_context(void) {}
+#endif
+
+int omap34xx_isp_preview_config(void *userspace_add);
+
+int omap34xx_isp_tables_update(struct isptables_update *isptables_struct);
+
+#endif/* OMAP_ISP_PREVIEW_H */
Index: linux-omap-2.6/drivers/media/video/isp/ispreg.h
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/isp/ispreg.h     2008-08-28 19:08:43.000000000 -0500
@@ -0,0 +1,1281 @@
+/*
+ * drivers/media/video/isp/ispreg.h
+ *
+ * Header file for all the ISP module in TI's OMAP3430 Camera ISP.
+ * It has the OMAP HW register definitions.
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ * Copyright (C) 2008 Nokia.
+ *
+ * Contributors:
+ *     Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
+ *     Thara Gopinath <thara@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#ifndef __ISPREG_H__
+#define __ISPREG_H__
+
+#if 0
+#define OMAP_ISPCTRL_DEBUG
+#define OMAP_ISPCCDC_DEBUG
+#define OMAP_ISPPREV_DEBUG
+#define OMAP_ISPRESZ_DEBUG
+#define OMAP_ISPMMU_DEBUG
+#define OMAP_ISPH3A_DEBUG
+#define OMAP_ISPHIST_DEBUG
+#endif
+
+#ifdef OMAP_ISPCTRL_DEBUG
+#define DPRINTK_ISPCTRL(format, ...)\
+       printk(KERN_INFO "ISPCTRL: " format, ## __VA_ARGS__)
+#define is_ispctrl_debug_enabled()             1
+#else
+#define DPRINTK_ISPCTRL(format, ...)
+#define is_ispctrl_debug_enabled()             0
+#endif
+
+#ifdef OMAP_ISPCCDC_DEBUG
+#define DPRINTK_ISPCCDC(format, ...)\
+       printk(KERN_INFO "ISPCCDC: " format, ## __VA_ARGS__)
+#define is_ispccdc_debug_enabled()             1
+#else
+#define DPRINTK_ISPCCDC(format, ...)
+#define is_ispccdc_debug_enabled()             0
+#endif
+
+#ifdef OMAP_ISPPREV_DEBUG
+#define DPRINTK_ISPPREV(format, ...)\
+       printk(KERN_INFO "ISPPREV: " format, ## __VA_ARGS__)
+#define is_ispprev_debug_enabled()             1
+#else
+#define DPRINTK_ISPPREV(format, ...)
+#define is_ispprev_debug_enabled()             0
+#endif
+
+#ifdef OMAP_ISPRESZ_DEBUG
+#define DPRINTK_ISPRESZ(format, ...)\
+       printk(KERN_INFO "ISPRESZ: " format, ## __VA_ARGS__)
+#define is_ispresz_debug_enabled()             1
+#else
+#define DPRINTK_ISPRESZ(format, ...)
+#define is_ispresz_debug_enabled()             0
+#endif
+
+#ifdef OMAP_ISPMMU_DEBUG
+#define DPRINTK_ISPMMU(format, ...)\
+       printk(KERN_INFO "ISPMMU: " format, ## __VA_ARGS__)
+#define is_ispmmu_debug_enabled()              1
+#else
+#define DPRINTK_ISPMMU(format, ...)
+#define is_ispmmu_debug_enabled()              0
+#endif
+
+#ifdef OMAP_ISPH3A_DEBUG
+#define DPRINTK_ISPH3A(format, ...)\
+       printk(KERN_INFO "ISPH3A: " format, ## __VA_ARGS__)
+#define is_isph3a_debug_enabled()              1
+#else
+#define DPRINTK_ISPH3A(format, ...)
+#define is_isph3a_debug_enabled()              0
+#endif
+
+#ifdef OMAP_ISPHIST_DEBUG
+#define DPRINTK_ISPHIST(format, ...)\
+       printk(KERN_INFO "ISPHIST: " format, ## __VA_ARGS__)
+#define is_isphist_debug_enabled()             1
+#else
+#define DPRINTK_ISPHIST(format, ...)
+#define is_isphist_debug_enabled()             0
+#endif
+
+#define ISP_32B_BOUNDARY_BUF           0xFFFFFFE0
+#define ISP_32B_BOUNDARY_OFFSET                0x0000FFE0
+
+#define CONTROL_CSIRXFE                        0x480022DC
+#define CONTROL_CSI                    0x48002530
+
+/*PRCM Clock definition*/
+
+#define CM_FCLKEN_CAM                  0x48004f00
+#define CM_ICLKEN_CAM                  0x48004f10
+#define CM_AUTOIDLE_CAM                        0x48004f30
+#define CM_CLKSEL_CAM                  0x48004f40
+#define CM_CLKEN_PLL                   0x48004D00
+#define CM_CLKSEL2_PLL                 0x48004D44
+#define CTRL_PADCONF_CAM_HS            0x4800210C
+#define CTRL_PADCONF_CAM_XCLKA         0x48002110
+#define CTRL_PADCONF_CAM_D1            0x48002118
+#define CTRL_PADCONF_CAM_D3            0x4800211C
+#define CTRL_PADCONF_CAM_D5            0x48002120
+
+#define CTRL_PADCONF_CAM_D7            0x48002124
+#define CTRL_PADCONF_CAM_D9            0x48002128
+#define CTRL_PADCONF_CAM_D11           0x4800212C
+
+#define CM_ICLKEN_CAM_EN               0x1
+#define CM_FCLKEN_CAM_EN               0x1
+
+#define CM_CAM_MCLK_HZ                 216000000
+
+/* ISP Submodules offset */
+
+#define ISP_REG_BASE                   0x480BC000
+#define ISP_REG_SIZE                   0x00001600
+
+#define ISPCBUFF_REG_BASE              0x480BC100
+#define ISPCBUFF_REG(offset)           (ISPCBUFF_REG_BASE + (offset))
+
+#define ISPCCP2A_REG_OFFSET            0x00000200
+#define ISPCCP2A_REG_BASE              0x480BC200
+
+#define ISPCCP2B_REG_OFFSET            0x00000400
+#define ISPCCP2B_REG_BASE              0x480BC400
+
+#define ISPCCDC_REG_OFFSET             0x00000600
+#define ISPCCDC_REG_BASE               0x480BC600
+
+#define ISPSCMP_REG_OFFSET             0x00000800
+#define ISPSCMP_REG_BASE               0x480BC800
+
+#define ISPHIST_REG_OFFSET             0x00000A00
+#define ISPHIST_REG_BASE               0x480BCA00
+#define ISPHIST_REG(offset)            (ISPHIST_REG_BASE + (offset))
+
+#define ISPH3A_REG_OFFSET              0x00000C00
+#define ISPH3A_REG_BASE                                0x480BCC00
+#define ISPH3A_REG(offset)             (ISPH3A_REG_BASE + (offset))
+
+#define ISPPREVIEW_REG_OFFSET          0x00000E00
+#define ISPPREVIEW_REG_BASE            0x480BCE00
+
+#define ISPRESIZER_REG_OFFSET          0x00001000
+#define ISPRESIZER_REG_BASE            0x480BD000
+
+#define ISPSBL_REG_OFFSET              0x00001200
+#define ISPSBL_REG_BASE                        0x480BD200
+
+#define ISPMMU_REG_OFFSET              0x00001400
+#define ISPMMU_REG_BASE                        0x480BD400
+
+/* ISP module register offset */
+
+#define ISP_REVISION                   0x480BC000
+#define ISP_SYSCONFIG                  0x480BC004
+#define ISP_SYSSTATUS                  0x480BC008
+#define ISP_IRQ0ENABLE                 0x480BC00C
+#define ISP_IRQ0STATUS                 0x480BC010
+#define ISP_IRQ1ENABLE                 0x480BC014
+#define ISP_IRQ1STATUS                 0x480BC018
+#define ISP_TCTRL_GRESET_LENGTH                0x480BC030
+#define ISP_TCTRL_PSTRB_REPLAY         0x480BC034
+#define ISP_CTRL                       0x480BC040
+#define ISP_SECURE                     0x480BC044
+#define ISP_TCTRL_CTRL                 0x480BC050
+#define ISP_TCTRL_FRAME                        0x480BC054
+#define ISP_TCTRL_PSTRB_DELAY          0x480BC058
+#define ISP_TCTRL_STRB_DELAY           0x480BC05C
+#define ISP_TCTRL_SHUT_DELAY           0x480BC060
+#define ISP_TCTRL_PSTRB_LENGTH         0x480BC064
+#define ISP_TCTRL_STRB_LENGTH          0x480BC068
+#define ISP_TCTRL_SHUT_LENGTH          0x480BC06C
+#define ISP_PING_PONG_ADDR             0x480BC070
+#define ISP_PING_PONG_MEM_RANGE                0x480BC074
+#define ISP_PING_PONG_BUF_SIZE         0x480BC078
+
+/* CSI1 receiver registers (ES2.0) */
+#define ISPCSI1_REVISION               0x480BC400
+#define ISPCSI1_SYSCONFIG              0x480BC404
+#define ISPCSI1_SYSSTATUS              0x480BC408
+#define ISPCSI1_LC01_IRQENABLE         0x480BC40C
+#define ISPCSI1_LC01_IRQSTATUS         0x480BC410
+#define ISPCSI1_LC23_IRQENABLE         0x480BC414
+#define ISPCSI1_LC23_IRQSTATUS         0x480BC418
+#define ISPCSI1_LCM_IRQENABLE          0x480BC42C
+#define ISPCSI1_LCM_IRQSTATUS          0x480BC430
+#define ISPCSI1_CTRL                   0x480BC440
+#define ISPCSI1_DBG                    0x480BC444
+#define ISPCSI1_GNQ                    0x480BC448
+#define ISPCSI1_LCx_CTRL(x)            (0x480BC450+0x30*(x))
+#define ISPCSI1_LCx_CODE(x)            (0x480BC454+0x30*(x))
+#define ISPCSI1_LCx_STAT_START(x)      (0x480BC458+0x30*(x))
+#define ISPCSI1_LCx_STAT_SIZE(x)       (0x480BC45C+0x30*(x))
+#define ISPCSI1_LCx_SOF_ADDR(x)                (0x480BC460+0x30*(x))
+#define ISPCSI1_LCx_EOF_ADDR(x)                (0x480BC464+0x30*(x))
+#define ISPCSI1_LCx_DAT_START(x)       (0x480BC468+0x30*(x))
+#define ISPCSI1_LCx_DAT_SIZE(x)                (0x480BC46C+0x30*(x))
+#define ISPCSI1_LCx_DAT_PING_ADDR(x)   (0x480BC470+0x30*(x))
+#define ISPCSI1_LCx_DAT_PONG_ADDR(x)   (0x480BC474+0x30*(x))
+#define ISPCSI1_LCx_DAT_OFST(x)                (0x480BC478+0x30*(x))
+#define ISPCSI1_LCM_CTRL               0x480BC5D0
+#define ISPCSI1_LCM_VSIZE              0x480BC5D4
+#define ISPCSI1_LCM_HSIZE              0x480BC5D8
+#define ISPCSI1_LCM_PREFETCH           0x480BC5DC
+#define ISPCSI1_LCM_SRC_ADDR           0x480BC5E0
+#define ISPCSI1_LCM_SRC_OFST           0x480BC5E4
+#define ISPCSI1_LCM_DST_ADDR           0x480BC5E8
+#define ISPCSI1_LCM_DST_OFST           0x480BC5EC
+
+/* CSI2 receiver registers (ES2.0) */
+#define ISPCSI2_REVISION               0x480BD800
+#define ISPCSI2_SYSCONFIG              0x480BD810
+#define ISPCSI2_SYSSTATUS              0x480BD814
+#define ISPCSI2_IRQSTATUS              0x480BD818
+#define ISPCSI2_IRQENABLE              0x480BD81C
+#define ISPCSI2_CTRL                   0x480BD840
+#define ISPCSI2_DBG_H                  0x480BD844
+#define ISPCSI2_GNQ                    0x480BD848
+#define ISPCSI2_COMPLEXIO_CFG1         0x480BD850
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS   0x480BD854
+#define ISPCSI2_SHORT_PACKET           0x480BD85C
+#define ISPCSI2_COMPLEXIO1_IRQENABLE   0x480BD860
+#define ISPCSI2_DBG_P                  0x480BD868
+#define ISPCSI2_TIMING                 0x480BD86C
+#define ISPCSI2_CTX_CTRL1(n)           (0x480BD870+0x20*(n))
+#define ISPCSI2_CTX_CTRL2(n)           (0x480BD874+0x20*(n))
+#define ISPCSI2_CTX_DAT_OFST(n)                (0x480BD878+0x20*(n))
+#define ISPCSI2_CTX_DAT_PING_ADDR(n)   (0x480BD87C+0x20*(n))
+#define ISPCSI2_CTX_DAT_PONG_ADDR(n)   (0x480BD880+0x20*(n))
+#define ISPCSI2_CTX_IRQENABLE(n)       (0x480BD884+0x20*(n))
+#define ISPCSI2_CTX_IRQSTATUS(n)       (0x480BD888+0x20*(n))
+#define ISPCSI2_CTX_CTRL3(n)           (0x480BD88C+0x20*(n))
+
+#define ISP_CSIB_SYSCONFIG             ISPCSI1_SYSCONFIG
+#define ISP_CSIA_SYSCONFIG             ISPCSI2_SYSCONFIG
+
+/* ISP_CBUFF Registers */
+
+#define ISP_CBUFF_SYSCONFIG            ISPCBUFF_REG(0x010)
+#define ISP_CBUFF_IRQENABLE            ISPCBUFF_REG(0x01C)
+
+#define ISP_CBUFF0_CTRL                        ISPCBUFF_REG(0x020)
+#define ISP_CBUFF1_CTRL                        (ISP_CBUFF0_CTRL + (0x004))
+
+#define ISP_CBUFF0_START               ISPCBUFF_REG(0x040)
+#define ISP_CBUFF1_START               (ISP_CBUFF0_START + (0x004))
+
+#define ISP_CBUFF0_END                 ISPCBUFF_REG(0x050)
+#define ISP_CBUFF1_END                 (ISP_CBUFF0_END + (0x04))
+
+#define ISP_CBUFF0_WINDOWSIZE          ISPCBUFF_REG(0x060)
+#define ISP_CBUFF1_WINDOWSIZE          (ISP_CBUFF0_WINDOWSIZE + (0x004))
+
+#define ISP_CBUFF0_THRESHOLD           ISPCBUFF_REG(0x070)
+#define ISP_CBUFF1_THRESHOLD           (ISP_CBUFF0_THRESHOLD + (0x004))
+
+/* CCDC module register offset */
+
+#define ISPCCDC_PID                    0x480BC600
+#define ISPCCDC_PCR                    0x480BC604
+#define ISPCCDC_SYN_MODE               0x480BC608
+#define ISPCCDC_HD_VD_WID              0x480BC60C
+#define ISPCCDC_PIX_LINES              0x480BC610
+#define ISPCCDC_HORZ_INFO              0x480BC614
+#define ISPCCDC_VERT_START             0x480BC618
+#define ISPCCDC_VERT_LINES             0x480BC61C
+#define ISPCCDC_CULLING                        0x480BC620
+#define ISPCCDC_HSIZE_OFF              0x480BC624
+#define ISPCCDC_SDOFST                 0x480BC628
+#define ISPCCDC_SDR_ADDR               0x480BC62C
+#define ISPCCDC_CLAMP                  0x480BC630
+#define ISPCCDC_DCSUB                  0x480BC634
+#define ISPCCDC_COLPTN                 0x480BC638
+#define ISPCCDC_BLKCMP                 0x480BC63C
+#define ISPCCDC_FPC                    0x480BC640
+#define ISPCCDC_FPC_ADDR               0x480BC644
+#define ISPCCDC_VDINT                  0x480BC648
+#define ISPCCDC_ALAW                   0x480BC64C
+#define ISPCCDC_REC656IF               0x480BC650
+#define ISPCCDC_CFG                    0x480BC654
+#define ISPCCDC_FMTCFG                 0x480BC658
+#define ISPCCDC_FMT_HORZ               0x480BC65C
+#define ISPCCDC_FMT_VERT               0x480BC660
+#define ISPCCDC_FMT_ADDR0              0x480BC664
+#define ISPCCDC_FMT_ADDR1              0x480BC668
+#define ISPCCDC_FMT_ADDR2              0x480BC66C
+#define ISPCCDC_FMT_ADDR3              0x480BC670
+#define ISPCCDC_FMT_ADDR4              0x480BC674
+#define ISPCCDC_FMT_ADDR5              0x480BC678
+#define ISPCCDC_FMT_ADDR6              0x480BC67C
+#define ISPCCDC_FMT_ADDR7              0x480BC680
+#define ISPCCDC_PRGEVEN0               0x480BC684
+#define ISPCCDC_PRGEVEN1               0x480BC688
+#define ISPCCDC_PRGODD0                        0x480BC68C
+#define ISPCCDC_PRGODD1                        0x480BC690
+#define ISPCCDC_VP_OUT                 0x480BC694
+
+#define ISPCCDC_LSC_CONFIG             0x480BC698
+#define ISPCCDC_LSC_INITIAL            0x480BC69C
+#define ISPCCDC_LSC_TABLE_BASE         0x480BC6A0
+#define ISPCCDC_LSC_TABLE_OFFSET       0x480BC6A4
+
+/* Histogram registers */
+#define ISPHIST_PID                    ISPHIST_REG(0x000)
+#define ISPHIST_PCR                    ISPHIST_REG(0x004)
+#define ISPHIST_CNT                    ISPHIST_REG(0x008)
+#define ISPHIST_WB_GAIN                        ISPHIST_REG(0x00C)
+#define ISPHIST_R0_HORZ                        ISPHIST_REG(0x010)
+#define ISPHIST_R0_VERT                        ISPHIST_REG(0x014)
+#define ISPHIST_R1_HORZ                        ISPHIST_REG(0x018)
+#define ISPHIST_R1_VERT                        ISPHIST_REG(0x01C)
+#define ISPHIST_R2_HORZ                        ISPHIST_REG(0x020)
+#define ISPHIST_R2_VERT                        ISPHIST_REG(0x024)
+#define ISPHIST_R3_HORZ                        ISPHIST_REG(0x028)
+#define ISPHIST_R3_VERT                        ISPHIST_REG(0x02C)
+#define ISPHIST_ADDR                   ISPHIST_REG(0x030)
+#define ISPHIST_DATA                   ISPHIST_REG(0x034)
+#define ISPHIST_RADD                   ISPHIST_REG(0x038)
+#define ISPHIST_RADD_OFF               ISPHIST_REG(0x03C)
+#define ISPHIST_H_V_INFO               ISPHIST_REG(0x040)
+
+/* H3A module registers */
+#define ISPH3A_PID                     ISPH3A_REG(0x000)
+#define ISPH3A_PCR                     ISPH3A_REG(0x004)
+#define ISPH3A_AEWWIN1                 ISPH3A_REG(0x04C)
+#define ISPH3A_AEWINSTART              ISPH3A_REG(0x050)
+#define ISPH3A_AEWINBLK                        ISPH3A_REG(0x054)
+#define ISPH3A_AEWSUBWIN               ISPH3A_REG(0x058)
+#define ISPH3A_AEWBUFST                        ISPH3A_REG(0x05C)
+#define ISPH3A_AFPAX1                  ISPH3A_REG(0x008)
+#define ISPH3A_AFPAX2                  ISPH3A_REG(0x00C)
+#define ISPH3A_AFPAXSTART              ISPH3A_REG(0x010)
+#define ISPH3A_AFIIRSH                 ISPH3A_REG(0x014)
+#define ISPH3A_AFBUFST                 ISPH3A_REG(0x018)
+#define ISPH3A_AFCOEF010               ISPH3A_REG(0x01C)
+#define ISPH3A_AFCOEF032               ISPH3A_REG(0x020)
+#define ISPH3A_AFCOEF054               ISPH3A_REG(0x024)
+#define ISPH3A_AFCOEF076               ISPH3A_REG(0x028)
+#define ISPH3A_AFCOEF098               ISPH3A_REG(0x02C)
+#define ISPH3A_AFCOEF0010              ISPH3A_REG(0x030)
+#define ISPH3A_AFCOEF110               ISPH3A_REG(0x034)
+#define ISPH3A_AFCOEF132               ISPH3A_REG(0x038)
+#define ISPH3A_AFCOEF154               ISPH3A_REG(0x03C)
+#define ISPH3A_AFCOEF176               ISPH3A_REG(0x040)
+#define ISPH3A_AFCOEF198               ISPH3A_REG(0x044)
+#define ISPH3A_AFCOEF1010              ISPH3A_REG(0x048)
+
+#define ISPPRV_PCR                     0x480BCE04
+#define ISPPRV_HORZ_INFO               0x480BCE08
+#define ISPPRV_VERT_INFO               0x480BCE0C
+#define ISPPRV_RSDR_ADDR               0x480BCE10
+#define ISPPRV_RADR_OFFSET             0x480BCE14
+#define ISPPRV_DSDR_ADDR               0x480BCE18
+#define ISPPRV_DRKF_OFFSET             0x480BCE1C
+#define ISPPRV_WSDR_ADDR               0x480BCE20
+#define ISPPRV_WADD_OFFSET             0x480BCE24
+#define ISPPRV_AVE                     0x480BCE28
+#define ISPPRV_HMED                    0x480BCE2C
+#define ISPPRV_NF                      0x480BCE30
+#define ISPPRV_WB_DGAIN                        0x480BCE34
+#define ISPPRV_WBGAIN                  0x480BCE38
+#define ISPPRV_WBSEL                   0x480BCE3C
+#define ISPPRV_CFA                     0x480BCE40
+#define ISPPRV_BLKADJOFF               0x480BCE44
+#define ISPPRV_RGB_MAT1                        0x480BCE48
+#define ISPPRV_RGB_MAT2                        0x480BCE4C
+#define ISPPRV_RGB_MAT3                        0x480BCE50
+#define ISPPRV_RGB_MAT4                        0x480BCE54
+#define ISPPRV_RGB_MAT5                        0x480BCE58
+#define ISPPRV_RGB_OFF1                        0x480BCE5C
+#define ISPPRV_RGB_OFF2                        0x480BCE60
+#define ISPPRV_CSC0                    0x480BCE64
+#define ISPPRV_CSC1                    0x480BCE68
+#define ISPPRV_CSC2                    0x480BCE6C
+#define ISPPRV_CSC_OFFSET              0x480BCE70
+#define ISPPRV_CNT_BRT                 0x480BCE74
+#define ISPPRV_CSUP                    0x480BCE78
+#define ISPPRV_SETUP_YC                        0x480BCE7C
+#define ISPPRV_SET_TBL_ADDR            0x480BCE80
+#define ISPPRV_SET_TBL_DATA            0x480BCE84
+#define ISPPRV_CDC_THR0                        0x480BCE90
+#define ISPPRV_CDC_THR1                        (ISPPRV_CDC_THR0 + (0x4))
+#define ISPPRV_CDC_THR2                        (ISPPRV_CDC_THR0 + (0x4) * 2)
+#define ISPPRV_CDC_THR3                        (ISPPRV_CDC_THR0 + (0x4) * 3)
+
+#define ISPPRV_REDGAMMA_TABLE_ADDR     0x0000
+#define ISPPRV_GREENGAMMA_TABLE_ADDR   0x0400
+#define ISPPRV_BLUEGAMMA_TABLE_ADDR    0x0800
+#define ISPPRV_NF_TABLE_ADDR           0x0C00
+#define ISPPRV_YENH_TABLE_ADDR         0x1000
+#define ISPPRV_CFA_TABLE_ADDR          0x1400
+
+#define ISPPRV_MAXOUTPUT_WIDTH         1280
+#define ISPPRV_MAXOUTPUT_WIDTH_ES2     3300
+
+/* Resizer module register offset */
+#define ISPRSZ_PID                     0x480BD000
+#define ISPRSZ_PCR                     0x480BD004
+#define ISPRSZ_CNT                     0x480BD008
+#define ISPRSZ_OUT_SIZE                        0x480BD00C
+#define ISPRSZ_IN_START                        0x480BD010
+#define ISPRSZ_IN_SIZE                 0x480BD014
+#define ISPRSZ_SDR_INADD               0x480BD018
+#define ISPRSZ_SDR_INOFF               0x480BD01C
+#define ISPRSZ_SDR_OUTADD              0x480BD020
+#define ISPRSZ_SDR_OUTOFF              0x480BD024
+#define ISPRSZ_HFILT10                 0x480BD028
+#define ISPRSZ_HFILT32                 0x480BD02C
+#define ISPRSZ_HFILT54                 0x480BD030
+#define ISPRSZ_HFILT76                 0x480BD034
+#define ISPRSZ_HFILT98                 0x480BD038
+#define ISPRSZ_HFILT1110               0x480BD03C
+#define ISPRSZ_HFILT1312               0x480BD040
+#define ISPRSZ_HFILT1514               0x480BD044
+#define ISPRSZ_HFILT1716               0x480BD048
+#define ISPRSZ_HFILT1918               0x480BD04C
+#define ISPRSZ_HFILT2120               0x480BD050
+#define ISPRSZ_HFILT2322               0x480BD054
+#define ISPRSZ_HFILT2524               0x480BD058
+#define ISPRSZ_HFILT2726               0x480BD05C
+#define ISPRSZ_HFILT2928               0x480BD060
+#define ISPRSZ_HFILT3130               0x480BD064
+#define ISPRSZ_VFILT10                 0x480BD068
+#define ISPRSZ_VFILT32                 0x480BD06C
+#define ISPRSZ_VFILT54                 0x480BD070
+#define ISPRSZ_VFILT76                 0x480BD074
+#define ISPRSZ_VFILT98                 0x480BD078
+#define ISPRSZ_VFILT1110               0x480BD07C
+#define ISPRSZ_VFILT1312               0x480BD080
+#define ISPRSZ_VFILT1514               0x480BD084
+#define ISPRSZ_VFILT1716               0x480BD088
+#define ISPRSZ_VFILT1918               0x480BD08C
+#define ISPRSZ_VFILT2120               0x480BD090
+#define ISPRSZ_VFILT2322               0x480BD094
+#define ISPRSZ_VFILT2524               0x480BD098
+#define ISPRSZ_VFILT2726               0x480BD09C
+#define ISPRSZ_VFILT2928               0x480BD0A0
+#define ISPRSZ_VFILT3130               0x480BD0A4
+#define ISPRSZ_YENH                    0x480BD0A8
+
+/* MMU module registers */
+#define ISPMMU_REVISION                        0x480BD400
+#define ISPMMU_SYSCONFIG               0x480BD410
+#define ISPMMU_SYSSTATUS               0x480BD414
+#define ISPMMU_IRQSTATUS               0x480BD418
+#define ISPMMU_IRQENABLE               0x480BD41C
+#define ISPMMU_WALKING_ST              0x480BD440
+#define ISPMMU_CNTL                    0x480BD444
+#define ISPMMU_FAULT_AD                        0x480BD448
+#define ISPMMU_TTB                     0x480BD44C
+#define ISPMMU_LOCK                    0x480BD450
+#define ISPMMU_LD_TLB                  0x480BD454
+#define ISPMMU_CAM                     0x480BD458
+#define ISPMMU_RAM                     0x480BD45C
+#define ISPMMU_GFLUSH                  0x480BD460
+#define ISPMMU_FLUSH_ENTRY             0x480BD464
+#define ISPMMU_READ_CAM                        0x480BD468
+#define ISPMMU_READ_RAM                        0x480BD46c
+#define ISPMMU_EMU_FAULT_AD            0x480BD470
+
+#define ISP_INT_CLR                    0xFF113F11
+#define ISPPRV_PCR_EN                  1
+#define ISPPRV_PCR_BUSY                        (1 << 1)
+#define ISPPRV_PCR_SOURCE              (1 << 2)
+#define ISPPRV_PCR_ONESHOT             (1 << 3)
+#define ISPPRV_PCR_WIDTH               (1 << 4)
+#define ISPPRV_PCR_INVALAW             (1 << 5)
+#define ISPPRV_PCR_DRKFEN              (1 << 6)
+#define ISPPRV_PCR_DRKFCAP             (1 << 7)
+#define ISPPRV_PCR_HMEDEN              (1 << 8)
+#define ISPPRV_PCR_NFEN                        (1 << 9)
+#define ISPPRV_PCR_CFAEN               (1 << 10)
+#define ISPPRV_PCR_CFAFMT_SHIFT                11
+#define ISPPRV_PCR_CFAFMT_MASK         0x7800
+#define ISPPRV_PCR_CFAFMT_BAYER                (0 << 11)
+#define ISPPRV_PCR_CFAFMT_SONYVGA      (1 << 11)
+#define ISPPRV_PCR_CFAFMT_RGBFOVEON    (2 << 11)
+#define ISPPRV_PCR_CFAFMT_DNSPL                (3 << 11)
+#define ISPPRV_PCR_CFAFMT_HONEYCOMB    (4 << 11)
+#define ISPPRV_PCR_CFAFMT_RRGGBBFOVEON (5 << 11)
+#define ISPPRV_PCR_YNENHEN             (1 << 15)
+#define ISPPRV_PCR_SUPEN               (1 << 16)
+#define ISPPRV_PCR_YCPOS_SHIFT         17
+#define ISPPRV_PCR_YCPOS_YCrYCb                (0 << 17)
+#define ISPPRV_PCR_YCPOS_YCbYCr                (1 << 17)
+#define ISPPRV_PCR_YCPOS_CbYCrY                (2 << 17)
+#define ISPPRV_PCR_YCPOS_CrYCbY                (3 << 17)
+#define ISPPRV_PCR_RSZPORT             (1 << 19)
+#define ISPPRV_PCR_SDRPORT             (1 << 20)
+#define ISPPRV_PCR_SCOMP_EN            (1 << 21)
+#define ISPPRV_PCR_SCOMP_SFT_SHIFT     (22)
+#define ISPPRV_PCR_SCOMP_SFT_MASK      (~(7 << 22))
+#define ISPPRV_PCR_GAMMA_BYPASS                (1 << 26)
+#define ISPPRV_PCR_DCOREN              (1 << 27)
+#define ISPPRV_PCR_DCCOUP              (1 << 28)
+#define ISPPRV_PCR_DRK_FAIL            (1 << 31)
+
+#define ISPPRV_HORZ_INFO_EPH_SHIFT     0
+#define ISPPRV_HORZ_INFO_EPH_MASK      0x3fff
+#define ISPPRV_HORZ_INFO_SPH_SHIFT     16
+#define ISPPRV_HORZ_INFO_SPH_MASK      0x3fff0
+
+#define ISPPRV_VERT_INFO_ELV_SHIFT     0
+#define ISPPRV_VERT_INFO_ELV_MASK      0x3fff
+#define ISPPRV_VERT_INFO_SLV_SHIFT     16
+#define ISPPRV_VERT_INFO_SLV_MASK      0x3fff0
+
+#define ISPPRV_AVE_EVENDIST_SHIFT      2
+#define ISPPRV_AVE_EVENDIST_1          0x0
+#define ISPPRV_AVE_EVENDIST_2          0x1
+#define ISPPRV_AVE_EVENDIST_3          0x2
+#define ISPPRV_AVE_EVENDIST_4          0x3
+#define ISPPRV_AVE_ODDDIST_SHIFT       4
+#define ISPPRV_AVE_ODDDIST_1           0x0
+#define ISPPRV_AVE_ODDDIST_2           0x1
+#define ISPPRV_AVE_ODDDIST_3           0x2
+#define ISPPRV_AVE_ODDDIST_4           0x3
+
+#define ISPPRV_HMED_THRESHOLD_SHIFT    0
+#define ISPPRV_HMED_EVENDIST           (1 << 8)
+#define ISPPRV_HMED_ODDDIST            (1 << 9)
+
+#define ISPPRV_WBGAIN_COEF0_SHIFT      0
+#define ISPPRV_WBGAIN_COEF1_SHIFT      8
+#define ISPPRV_WBGAIN_COEF2_SHIFT      16
+#define ISPPRV_WBGAIN_COEF3_SHIFT      24
+
+#define ISPPRV_WBSEL_COEF0             0x0
+#define ISPPRV_WBSEL_COEF1             0x1
+#define ISPPRV_WBSEL_COEF2             0x2
+#define ISPPRV_WBSEL_COEF3             0x3
+
+#define ISPPRV_WBSEL_N0_0_SHIFT                0
+#define ISPPRV_WBSEL_N0_1_SHIFT                2
+#define ISPPRV_WBSEL_N0_2_SHIFT                4
+#define ISPPRV_WBSEL_N0_3_SHIFT                6
+#define ISPPRV_WBSEL_N1_0_SHIFT                8
+#define ISPPRV_WBSEL_N1_1_SHIFT                10
+#define ISPPRV_WBSEL_N1_2_SHIFT                12
+#define ISPPRV_WBSEL_N1_3_SHIFT                14
+#define ISPPRV_WBSEL_N2_0_SHIFT                16
+#define ISPPRV_WBSEL_N2_1_SHIFT                18
+#define ISPPRV_WBSEL_N2_2_SHIFT                20
+#define ISPPRV_WBSEL_N2_3_SHIFT                22
+#define ISPPRV_WBSEL_N3_0_SHIFT                24
+#define ISPPRV_WBSEL_N3_1_SHIFT                26
+#define ISPPRV_WBSEL_N3_2_SHIFT                28
+#define ISPPRV_WBSEL_N3_3_SHIFT                30
+
+#define ISPPRV_CFA_GRADTH_HOR_SHIFT    0
+#define ISPPRV_CFA_GRADTH_VER_SHIFT    8
+
+#define ISPPRV_BLKADJOFF_B_SHIFT       0
+#define ISPPRV_BLKADJOFF_G_SHIFT       8
+#define ISPPRV_BLKADJOFF_R_SHIFT       16
+
+#define ISPPRV_RGB_MAT1_MTX_RR_SHIFT   0
+#define ISPPRV_RGB_MAT1_MTX_GR_SHIFT   16
+
+#define ISPPRV_RGB_MAT2_MTX_BR_SHIFT   0
+#define ISPPRV_RGB_MAT2_MTX_RG_SHIFT   16
+
+#define ISPPRV_RGB_MAT3_MTX_GG_SHIFT   0
+#define ISPPRV_RGB_MAT3_MTX_BG_SHIFT   16
+
+#define ISPPRV_RGB_MAT4_MTX_RB_SHIFT   0
+#define ISPPRV_RGB_MAT4_MTX_GB_SHIFT   16
+
+#define ISPPRV_RGB_MAT5_MTX_BB_SHIFT   0
+
+#define ISPPRV_RGB_OFF1_MTX_OFFG_SHIFT 0
+#define ISPPRV_RGB_OFF1_MTX_OFFR_SHIFT 16
+
+#define ISPPRV_RGB_OFF2_MTX_OFFB_SHIFT 0
+
+#define ISPPRV_CSC0_RY_SHIFT           0
+#define ISPPRV_CSC0_GY_SHIFT           10
+#define ISPPRV_CSC0_BY_SHIFT           20
+
+#define ISPPRV_CSC1_RCB_SHIFT          0
+#define ISPPRV_CSC1_GCB_SHIFT          10
+#define ISPPRV_CSC1_BCB_SHIFT          20
+
+#define ISPPRV_CSC2_RCR_SHIFT          0
+#define ISPPRV_CSC2_GCR_SHIFT          10
+#define ISPPRV_CSC2_BCR_SHIFT          20
+
+#define ISPPRV_CSC_OFFSET_CR_SHIFT     0
+#define ISPPRV_CSC_OFFSET_CB_SHIFT     8
+#define ISPPRV_CSC_OFFSET_Y_SHIFT      16
+
+#define ISPPRV_CNT_BRT_BRT_SHIFT       0
+#define ISPPRV_CNT_BRT_CNT_SHIFT       8
+
+#define ISPPRV_CONTRAST_MAX            0x10
+#define ISPPRV_CONTRAST_MIN            0xFF
+#define ISPPRV_BRIGHT_MIN              0x00
+#define ISPPRV_BRIGHT_MAX              0xFF
+
+#define ISPPRV_CSUP_CSUPG_SHIFT                0
+#define ISPPRV_CSUP_THRES_SHIFT                8
+#define ISPPRV_CSUP_HPYF_SHIFT         16
+
+#define ISPPRV_SETUP_YC_MINC_SHIFT     0
+#define ISPPRV_SETUP_YC_MAXC_SHIFT     8
+#define ISPPRV_SETUP_YC_MINY_SHIFT     16
+#define ISPPRV_SETUP_YC_MAXY_SHIFT     24
+#define ISPPRV_YC_MAX                  0xFF
+#define ISPPRV_YC_MIN                  0x0
+
+/* Define bit fields within selected registers */
+#define ISP_REVISION_SHIFT                     0
+
+#define ISP_SYSCONFIG_AUTOIDLE                 0
+#define ISP_SYSCONFIG_SOFTRESET                        (1 << 1)
+#define ISP_SYSCONFIG_MIDLEMODE_SHIFT          12
+#define ISP_SYSCONFIG_MIDLEMODE_FORCESTANDBY   0x0
+#define ISP_SYSCONFIG_MIDLEMODE_NOSTANBY       0x1
+#define ISP_SYSCONFIG_MIDLEMODE_SMARTSTANDBY   0x2
+
+#define ISP_SYSSTATUS_RESETDONE                        0
+
+#define IRQ0ENABLE_CSIA_IRQ                    1
+#define IRQ0ENABLE_CSIA_LC1_IRQ                        (1 << 1)
+#define IRQ0ENABLE_CSIA_LC2_IRQ                        (1 << 2)
+#define IRQ0ENABLE_CSIA_LC3_IRQ                        (1 << 3)
+#define IRQ0ENABLE_CSIB_IRQ                    (1 << 4)
+#define IRQ0ENABLE_CSIB_LC1_IRQ                        (1 << 5)
+#define IRQ0ENABLE_CSIB_LC2_IRQ                        (1 << 6)
+#define IRQ0ENABLE_CSIB_LC3_IRQ                        (1 << 7)
+#define IRQ0ENABLE_CCDC_VD0_IRQ                        (1 << 8)
+#define IRQ0ENABLE_CCDC_VD1_IRQ                        (1 << 9)
+#define IRQ0ENABLE_CCDC_VD2_IRQ                        (1 << 10)
+#define IRQ0ENABLE_CCDC_ERR_IRQ                        (1 << 11)
+#define IRQ0ENABLE_H3A_AF_DONE_IRQ             (1 << 12)
+#define IRQ0ENABLE_H3A_AWB_DONE_IRQ            (1 << 13)
+#define IRQ0ENABLE_HIST_DONE_IRQ               (1 << 16)
+#define IRQ0ENABLE_CCDC_LSC_DONE_IRQ           (1 << 17)
+#define IRQ0ENABLE_CCDC_LSC_PREF_COMP_IRQ      (1 << 18)
+#define IRQ0ENABLE_CCDC_LSC_PREF_ERR_IRQ       (1 << 19)
+#define IRQ0ENABLE_PRV_DONE_IRQ                        (1 << 20)
+#define IRQ0ENABLE_RSZ_DONE_IRQ                        (1 << 24)
+#define IRQ0ENABLE_OVF_IRQ                     (1 << 25)
+#define IRQ0ENABLE_PING_IRQ                    (1 << 26)
+#define IRQ0ENABLE_PONG_IRQ                    (1 << 27)
+#define IRQ0ENABLE_MMU_ERR_IRQ                 (1 << 28)
+#define IRQ0ENABLE_OCP_ERR_IRQ                 (1 << 29)
+#define IRQ0ENABLE_SEC_ERR_IRQ                 (1 << 30)
+#define IRQ0ENABLE_HS_VS_IRQ                   (1 << 31)
+
+#define IRQ0STATUS_CSIA_IRQ                    1
+#define IRQ0STATUS_CSIA_LC1_IRQ                        (1 << 1)
+#define IRQ0STATUS_CSIA_LC2_IRQ                        (1 << 2)
+#define IRQ0STATUS_CSIA_LC3_IRQ                        (1 << 3)
+#define IRQ0STATUS_CSIB_IRQ                    (1 << 4)
+#define IRQ0STATUS_CSIB_LC1_IRQ                        (1 << 5)
+#define IRQ0STATUS_CSIB_LC2_IRQ                        (1 << 6)
+#define IRQ0STATUS_CSIB_LC3_IRQ                        (1 << 7)
+#define IRQ0STATUS_CCDC_VD0_IRQ                        (1 << 8)
+#define IRQ0STATUS_CCDC_VD1_IRQ                        (1 << 9)
+#define IRQ0STATUS_CCDC_VD2_IRQ                        (1 << 10)
+#define IRQ0STATUS_CCDC_ERR_IRQ                        (1 << 11)
+#define IRQ0STATUS_H3A_AF_DONE_IRQ             (1 << 12)
+#define IRQ0STATUS_H3A_AWB_DONE_IRQ            (1 << 13)
+#define IRQ0STATUS_HIST_DONE_IRQ               (1 << 16)
+#define IRQ0STATUS_PRV_DONE_IRQ                        (1 << 20)
+#define IRQ0STATUS_RSZ_DONE_IRQ                        (1 << 24)
+#define IRQ0STATUS_OVF_IRQ                     (1 << 25)
+#define IRQ0STATUS_PING_IRQ                    (1 << 26)
+#define IRQ0STATUS_PONG_IRQ                    (1 << 27)
+#define IRQ0STATUS_MMU_ERR_IRQ                 (1 << 28)
+#define IRQ0STATUS_OCP_ERR_IRQ                 (1 << 29)
+#define IRQ0STATUS_SEC_ERR_IRQ                 (1 << 30)
+#define IRQ0STATUS_HS_VS_IRQ                   (1 << 31)
+
+#define TCTRL_GRESET_LEN                       0
+
+#define TCTRL_PSTRB_REPLAY_DELAY               0
+#define TCTRL_PSTRB_REPLAY_COUNTER_SHIFT       25
+
+#define ISPCTRL_PAR_SER_CLK_SEL_PARALLEL       0x0
+#define ISPCTRL_PAR_SER_CLK_SEL_CSIA           0x1
+#define ISPCTRL_PAR_SER_CLK_SEL_CSIB           0x2
+#define ISPCTRL_PAR_SER_CLK_SEL_MASK           0xFFFFFFFC
+
+#define ISPCTRL_PAR_BRIDGE_SHIFT               2
+#define ISPCTRL_PAR_BRIDGE_DISABLE             (0x0 << 2)
+#define ISPCTRL_PAR_BRIDGE_LENDIAN             (0x2 << 2)
+#define ISPCTRL_PAR_BRIDGE_BENDIAN             (0x3 << 2)
+
+#define ISPCTRL_PAR_CLK_POL_SHIFT              4
+#define ISPCTRL_PAR_CLK_POL_INV                        (1 << 4)
+#define ISPCTRL_PING_PONG_EN                   (1 << 5)
+#define ISPCTRL_SHIFT_SHIFT                    6
+#define ISPCTRL_SHIFT_0                                (0x0 << 6)
+#define ISPCTRL_SHIFT_2                                (0x1 << 6)
+#define ISPCTRL_SHIFT_4                                (0x2 << 6)
+#define ISPCTRL_SHIFT_MASK                     (~(0x3 << 6))
+
+#define ISPCTRL_CCDC_CLK_EN                    (1 << 8)
+#define ISPCTRL_SCMP_CLK_EN                    (1 << 9)
+#define ISPCTRL_H3A_CLK_EN                     (1 << 10)
+#define ISPCTRL_HIST_CLK_EN                    (1 << 11)
+#define ISPCTRL_PREV_CLK_EN                    (1 << 12)
+#define ISPCTRL_RSZ_CLK_EN                     (1 << 13)
+#define ISPCTRL_SYNC_DETECT_SHIFT              14
+#define ISPCTRL_SYNC_DETECT_HSFALL     (0x0 << ISPCTRL_SYNC_DETECT_SHIFT)
+#define ISPCTRL_SYNC_DETECT_HSRISE     (0x1 << ISPCTRL_SYNC_DETECT_SHIFT)
+#define ISPCTRL_SYNC_DETECT_VSFALL     (0x2 << ISPCTRL_SYNC_DETECT_SHIFT)
+#define ISPCTRL_SYNC_DETECT_VSRISE     (0x3 << ISPCTRL_SYNC_DETECT_SHIFT)
+
+#define ISPCTRL_CCDC_RAM_EN            (1 << 16)
+#define ISPCTRL_PREV_RAM_EN            (1 << 17)
+#define ISPCTRL_SBL_RD_RAM_EN          (1 << 18)
+#define ISPCTRL_SBL_WR1_RAM_EN         (1 << 19)
+#define ISPCTRL_SBL_WR0_RAM_EN         (1 << 20)
+#define ISPCTRL_SBL_AUTOIDLE           (1 << 21)
+#define ISPCTRL_SBL_SHARED_RPORTB      (1 << 28)
+#define ISPCTRL_JPEG_FLUSH             (1 << 30)
+#define ISPCTRL_CCDC_FLUSH             (1 << 31)
+
+#define ISPSECURE_SECUREMODE           0
+
+#define ISPTCTRL_CTRL_DIV_LOW          0x0
+#define ISPTCTRL_CTRL_DIV_HIGH         0x1
+#define ISPTCTRL_CTRL_DIV_BYPASS       0x1F
+
+#define ISPTCTRL_CTRL_DIVA_SHIFT       0
+#define ISPTCTRL_CTRL_DIVA_MASK                (0x1F << ISPTCTRL_CTRL_DIVA_SHIFT)
+
+#define ISPTCTRL_CTRL_DIVB_SHIFT       5
+#define ISPTCTRL_CTRL_DIVB_MASK                (0x1F << ISPTCTRL_CTRL_DIVB_SHIFT)
+
+#define ISPTCTRL_CTRL_DIVC_SHIFT       10
+#define ISPTCTRL_CTRL_DIVC_NOCLOCK     (0x0 << 10)
+
+#define ISPTCTRL_CTRL_SHUTEN           (1 << 21)
+#define ISPTCTRL_CTRL_PSTRBEN          (1 << 22)
+#define ISPTCTRL_CTRL_STRBEN           (1 << 23)
+#define ISPTCTRL_CTRL_SHUTPOL          (1 << 24)
+#define ISPTCTRL_CTRL_STRBPSTRBPOL     (1 << 26)
+
+#define ISPTCTRL_CTRL_INSEL_SHIFT      27
+#define ISPTCTRL_CTRL_INSEL_PARALLEL   (0x0 << 27)
+#define ISPTCTRL_CTRL_INSEL_CSIA       (0x1 << 27)
+#define ISPTCTRL_CTRL_INSEL_CSIB       (0x2 << 27)
+
+#define ISPTCTRL_CTRL_GRESETEn         (1 << 29)
+#define ISPTCTRL_CTRL_GRESETPOL                (1 << 30)
+#define ISPTCTRL_CTRL_GRESETDIR                (1 << 31)
+
+#define ISPTCTRL_FRAME_SHUT_SHIFT              0
+#define ISPTCTRL_FRAME_PSTRB_SHIFT             6
+#define ISPTCTRL_FRAME_STRB_SHIFT              12
+
+#define ISPCCDC_PID_PREV_SHIFT                 0
+#define ISPCCDC_PID_CID_SHIFT                  8
+#define ISPCCDC_PID_TID_SHIFT                  16
+
+#define ISPCCDC_PCR_EN                         1
+#define ISPCCDC_PCR_BUSY                       (1 << 1)
+
+#define ISPCCDC_SYN_MODE_VDHDOUT               0x1
+#define ISPCCDC_SYN_MODE_FLDOUT                        (1 << 1)
+#define ISPCCDC_SYN_MODE_VDPOL                 (1 << 2)
+#define ISPCCDC_SYN_MODE_HDPOL                 (1 << 3)
+#define ISPCCDC_SYN_MODE_FLDPOL                        (1 << 4)
+#define ISPCCDC_SYN_MODE_EXWEN                 (1 << 5)
+#define ISPCCDC_SYN_MODE_DATAPOL               (1 << 6)
+#define ISPCCDC_SYN_MODE_FLDMODE               (1 << 7)
+#define ISPCCDC_SYN_MODE_DATSIZ_MASK           0xFFFFF8FF
+#define ISPCCDC_SYN_MODE_DATSIZ_8_16           (0x0 << 8)
+#define ISPCCDC_SYN_MODE_DATSIZ_12             (0x4 << 8)
+#define ISPCCDC_SYN_MODE_DATSIZ_11             (0x5 << 8)
+#define ISPCCDC_SYN_MODE_DATSIZ_10             (0x6 << 8)
+#define ISPCCDC_SYN_MODE_DATSIZ_8              (0x7 << 8)
+#define ISPCCDC_SYN_MODE_PACK8                 (1 << 11)
+#define ISPCCDC_SYN_MODE_INPMOD_MASK           0xFFFFCFFF
+#define ISPCCDC_SYN_MODE_INPMOD_RAW            (0 << 12)
+#define ISPCCDC_SYN_MODE_INPMOD_YCBCR16                (1 << 12)
+#define ISPCCDC_SYN_MODE_INPMOD_YCBCR8         (2 << 12)
+#define ISPCCDC_SYN_MODE_LPF                   (1 << 14)
+#define ISPCCDC_SYN_MODE_FLDSTAT               (1 << 15)
+#define ISPCCDC_SYN_MODE_VDHDEN                        (1 << 16)
+#define ISPCCDC_SYN_MODE_WEN                   (1 << 17)
+#define ISPCCDC_SYN_MODE_VP2SDR                        (1 << 18)
+#define ISPCCDC_SYN_MODE_SDR2RSZ               (1 << 19)
+
+#define ISPCCDC_HD_VD_WID_VDW_SHIFT            0
+#define ISPCCDC_HD_VD_WID_HDW_SHIFT            16
+
+#define ISPCCDC_PIX_LINES_HLPRF_SHIFT          0
+#define ISPCCDC_PIX_LINES_PPLN_SHIFT           16
+
+#define ISPCCDC_HORZ_INFO_NPH_SHIFT            0
+#define ISPCCDC_HORZ_INFO_NPH_MASK             0xFFFF8000
+#define ISPCCDC_HORZ_INFO_SPH_MASK             0x1000FFFF
+#define ISPCCDC_HORZ_INFO_SPH_SHIFT            16
+
+#define ISPCCDC_VERT_START_SLV0_SHIFT          16
+#define ISPCCDC_VERT_START_SLV0_MASK           0x1000FFFF
+#define ISPCCDC_VERT_START_SLV1_SHIFT          0
+
+#define ISPCCDC_VERT_LINES_NLV_MASK            0xFFFF8000
+#define ISPCCDC_VERT_LINES_NLV_SHIFT           0
+
+#define ISPCCDC_CULLING_CULV_SHIFT             0
+#define ISPCCDC_CULLING_CULHODD_SHIFT          16
+#define ISPCCDC_CULLING_CULHEVN_SHIFT          24
+
+#define ISPCCDC_HSIZE_OFF_SHIFT                        0
+
+#define ISPCCDC_SDOFST_FINV                    (1 << 14)
+#define ISPCCDC_SDOFST_FOFST_1L                        (~(3 << 12))
+#define ISPCCDC_SDOFST_FOFST_4L                        (3 << 12)
+#define ISPCCDC_SDOFST_LOFST3_SHIFT            0
+#define ISPCCDC_SDOFST_LOFST2_SHIFT            3
+#define ISPCCDC_SDOFST_LOFST1_SHIFT            6
+#define ISPCCDC_SDOFST_LOFST0_SHIFT            9
+#define EVENEVEN                               1
+#define ODDEVEN                                        2
+#define EVENODD                                        3
+#define ODDODD                                 4
+
+#define ISPCCDC_CLAMP_OBGAIN_SHIFT             0
+#define ISPCCDC_CLAMP_OBST_SHIFT               10
+#define ISPCCDC_CLAMP_OBSLN_SHIFT              25
+#define ISPCCDC_CLAMP_OBSLEN_SHIFT             28
+#define ISPCCDC_CLAMP_CLAMPEN                  (1 << 31)
+
+#define ISPCCDC_COLPTN_R_Ye                    0x0
+#define ISPCCDC_COLPTN_Gr_Cy                   0x1
+#define ISPCCDC_COLPTN_Gb_G                    0x2
+#define ISPCCDC_COLPTN_B_Mg                    0x3
+#define ISPCCDC_COLPTN_CP0PLC0_SHIFT           0
+#define ISPCCDC_COLPTN_CP0PLC1_SHIFT           2
+#define ISPCCDC_COLPTN_CP0PLC2_SHIFT           4
+#define ISPCCDC_COLPTN_CP0PLC3_SHIFT           6
+#define ISPCCDC_COLPTN_CP1PLC0_SHIFT           8
+#define ISPCCDC_COLPTN_CP1PLC1_SHIFT           10
+#define ISPCCDC_COLPTN_CP1PLC2_SHIFT           12
+#define ISPCCDC_COLPTN_CP1PLC3_SHIFT           14
+#define ISPCCDC_COLPTN_CP2PLC0_SHIFT           16
+#define ISPCCDC_COLPTN_CP2PLC1_SHIFT           18
+#define ISPCCDC_COLPTN_CP2PLC2_SHIFT           20
+#define ISPCCDC_COLPTN_CP2PLC3_SHIFT           22
+#define ISPCCDC_COLPTN_CP3PLC0_SHIFT           24
+#define ISPCCDC_COLPTN_CP3PLC1_SHIFT           26
+#define ISPCCDC_COLPTN_CP3PLC2_SHIFT           28
+#define ISPCCDC_COLPTN_CP3PLC3_SHIFT           30
+
+#define ISPCCDC_BLKCMP_B_MG_SHIFT              0
+#define ISPCCDC_BLKCMP_GB_G_SHIFT              8
+#define ISPCCDC_BLKCMP_GR_CY_SHIFT             6
+#define ISPCCDC_BLKCMP_R_YE_SHIFT              24
+
+#define ISPCCDC_FPC_FPNUM_SHIFT                        0
+#define ISPCCDC_FPC_FPCEN                      (1 << 15)
+#define ISPCCDC_FPC_FPERR                      (1 << 16)
+
+#define ISPCCDC_VDINT_1_SHIFT                  0
+#define ISPCCDC_VDINT_0_SHIFT                  16
+#define ISPCCDC_VDINT_0_MASK                   0x7FFF
+#define ISPCCDC_VDINT_1_MASK                   0x7FFF
+
+#define ISPCCDC_ALAW_GWDI_SHIFT                        0
+#define ISPCCDC_ALAW_CCDTBL                    (1 << 3)
+
+#define ISPCCDC_REC656IF_R656ON                        1
+#define ISPCCDC_REC656IF_ECCFVH                        (1 << 1)
+
+#define ISPCCDC_CFG_BW656                      (1 << 5)
+#define ISPCCDC_CFG_FIDMD_SHIFT                        6
+#define ISPCCDC_CFG_WENLOG                     (1 << 8)
+#define ISPCCDC_CFG_Y8POS                      (1 << 11)
+#define ISPCCDC_CFG_BSWD                       (1 << 12)
+#define ISPCCDC_CFG_MSBINVI                    (1 << 13)
+#define ISPCCDC_CFG_VDLC                       (1 << 15)
+
+#define ISPCCDC_FMTCFG_FMTEN                   0x1
+#define ISPCCDC_FMTCFG_LNALT                   (1 << 1)
+#define ISPCCDC_FMTCFG_LNUM_SHIFT              2
+#define ISPCCDC_FMTCFG_PLEN_ODD_SHIFT          4
+#define ISPCCDC_FMTCFG_PLEN_EVEN_SHIFT         8
+#define ISPCCDC_FMTCFG_VPIN_MASK               0xFFFF8000
+#define ISPCCDC_FMTCFG_VPIN_12_3               (0x3 << 12)
+#define ISPCCDC_FMTCFG_VPIN_11_2               (0x4 << 12)
+#define ISPCCDC_FMTCFG_VPIN_10_1               (0x5 << 12)
+#define ISPCCDC_FMTCFG_VPIN_9_0                        (0x6 << 12)
+#define ISPCCDC_FMTCFG_VPEN                    (1 << 15)
+
+#define ISPCCDC_FMTCF_VPIF_FRQ_MASK            0xFFF8FFFF
+#define ISPCCDC_FMTCF_VPIF_FRQ_BY2             (0x0 << 16)
+#define ISPCCDC_FMTCF_VPIF_FRQ_BY3             (0x1 << 16)
+#define ISPCCDC_FMTCF_VPIF_FRQ_BY4             (0x2 << 16)
+#define ISPCCDC_FMTCF_VPIF_FRQ_BY5             (0x3 << 16)
+#define ISPCCDC_FMTCF_VPIF_FRQ_BY6             (0x4 << 16)
+
+#define ISPCCDC_FMT_HORZ_FMTLNH_SHIFT          0
+#define ISPCCDC_FMT_HORZ_FMTSPH_SHIFT          16
+
+#define ISPCCDC_FMT_VERT_FMTLNV_SHIFT          0
+#define ISPCCDC_FMT_VERT_FMTSLV_SHIFT          16
+
+#define ISPCCDC_FMT_HORZ_FMTSPH_MASK           0x1FFF0000
+#define ISPCCDC_FMT_HORZ_FMTLNH_MASK           0x1FFF
+
+#define ISPCCDC_FMT_VERT_FMTSLV_MASK           0x1FFF0000
+#define ISPCCDC_FMT_VERT_FMTLNV_MASK           0x1FFF
+
+#define ISPCCDC_VP_OUT_HORZ_ST_SHIFT           0
+#define ISPCCDC_VP_OUT_HORZ_NUM_SHIFT          4
+#define ISPCCDC_VP_OUT_VERT_NUM_SHIFT          17
+
+#define ISPRSZ_PID_PREV_SHIFT                  0
+#define ISPRSZ_PID_CID_SHIFT                   8
+#define ISPRSZ_PID_TID_SHIFT                   16
+
+#define ISPRSZ_PCR_ENABLE                      0x5
+#define ISPRSZ_PCR_BUSY                                (1 << 1)
+
+#define ISPRSZ_CNT_HRSZ_SHIFT                  0
+#define ISPRSZ_CNT_HRSZ_MASK                   0x3FF
+#define ISPRSZ_CNT_VRSZ_SHIFT                  10
+#define ISPRSZ_CNT_VRSZ_MASK                   0xFFC00
+#define ISPRSZ_CNT_HSTPH_SHIFT                 20
+#define ISPRSZ_CNT_HSTPH_MASK                  0x700000
+#define ISPRSZ_CNT_VSTPH_SHIFT                 23
+#define        ISPRSZ_CNT_VSTPH_MASK                   0x3800000
+#define        ISPRSZ_CNT_CBILIN_MASK                  0x20000000
+#define        ISPRSZ_CNT_INPTYP_MASK                  0x08000000
+#define        ISPRSZ_CNT_PIXFMT_MASK                  0x04000000
+#define ISPRSZ_CNT_YCPOS                       (1 << 26)
+#define ISPRSZ_CNT_INPTYP                      (1 << 27)
+#define ISPRSZ_CNT_INPSRC                      (1 << 28)
+#define ISPRSZ_CNT_CBILIN                      (1 << 29)
+
+#define ISPRSZ_OUT_SIZE_HORZ_SHIFT             0
+#define ISPRSZ_OUT_SIZE_HORZ_MASK              0x7FF
+#define ISPRSZ_OUT_SIZE_VERT_SHIFT             16
+#define ISPRSZ_OUT_SIZE_VERT_MASK              0x7FF0000
+
+
+#define ISPRSZ_IN_START_HORZ_ST_SHIFT          0
+#define ISPRSZ_IN_START_HORZ_ST_MASK           0x1FFF
+#define ISPRSZ_IN_START_VERT_ST_SHIFT          16
+#define ISPRSZ_IN_START_VERT_ST_MASK           0x1FFF0000
+
+
+#define ISPRSZ_IN_SIZE_HORZ_SHIFT              0
+#define ISPRSZ_IN_SIZE_HORZ_MASK               0x1FFF
+#define ISPRSZ_IN_SIZE_VERT_SHIFT              16
+#define ISPRSZ_IN_SIZE_VERT_MASK               0x1FFF0000
+
+#define ISPRSZ_SDR_INADD_ADDR_SHIFT            0
+#define ISPRSZ_SDR_INADD_ADDR_MASK             0xFFFFFFFF
+
+#define ISPRSZ_SDR_INOFF_OFFSET_SHIFT          0
+#define ISPRSZ_SDR_INOFF_OFFSET_MASK           0xFFFF
+
+#define ISPRSZ_SDR_OUTADD_ADDR_SHIFT           0
+#define ISPRSZ_SDR_OUTADD_ADDR_MASK            0xFFFFFFFF
+
+
+#define ISPRSZ_SDR_OUTOFF_OFFSET_SHIFT         0
+#define ISPRSZ_SDR_OUTOFF_OFFSET_MASK          0xFFFF
+
+#define ISPRSZ_HFILT10_COEF0_SHIFT             0
+#define ISPRSZ_HFILT10_COEF0_MASK              0x3FF
+#define ISPRSZ_HFILT10_COEF1_SHIFT             16
+#define ISPRSZ_HFILT10_COEF1_MASK              0x3FF0000
+
+#define ISPRSZ_HFILT32_COEF2_SHIFT             0
+#define ISPRSZ_HFILT32_COEF2_MASK              0x3FF
+#define ISPRSZ_HFILT32_COEF3_SHIFT             16
+#define ISPRSZ_HFILT32_COEF3_MASK              0x3FF0000
+
+#define ISPRSZ_HFILT54_COEF4_SHIFT             0
+#define ISPRSZ_HFILT54_COEF4_MASK              0x3FF
+#define ISPRSZ_HFILT54_COEF5_SHIFT             16
+#define ISPRSZ_HFILT54_COEF5_MASK              0x3FF0000
+
+#define ISPRSZ_HFILT76_COEFF6_SHIFT            0
+#define ISPRSZ_HFILT76_COEFF6_MASK             0x3FF
+#define ISPRSZ_HFILT76_COEFF7_SHIFT            16
+#define ISPRSZ_HFILT76_COEFF7_MASK             0x3FF0000
+
+#define ISPRSZ_HFILT98_COEFF8_SHIFT            0
+#define ISPRSZ_HFILT98_COEFF8_MASK             0x3FF
+#define ISPRSZ_HFILT98_COEFF9_SHIFT            16
+#define ISPRSZ_HFILT98_COEFF9_MASK             0x3FF0000
+
+#define ISPRSZ_HFILT1110_COEF10_SHIFT          0
+#define ISPRSZ_HFILT1110_COEF10_MASK           0x3FF
+#define ISPRSZ_HFILT1110_COEF11_SHIFT          16
+#define ISPRSZ_HFILT1110_COEF11_MASK           0x3FF0000
+
+#define ISPRSZ_HFILT1312_COEFF12_SHIFT         0
+#define ISPRSZ_HFILT1312_COEFF12_MASK          0x3FF
+#define ISPRSZ_HFILT1312_COEFF13_SHIFT         16
+#define ISPRSZ_HFILT1312_COEFF13_MASK          0x3FF0000
+
+#define ISPRSZ_HFILT1514_COEFF14_SHIFT         0
+#define ISPRSZ_HFILT1514_COEFF14_MASK          0x3FF
+#define ISPRSZ_HFILT1514_COEFF15_SHIFT         16
+#define ISPRSZ_HFILT1514_COEFF15_MASK          0x3FF0000
+
+#define ISPRSZ_HFILT1716_COEF16_SHIFT          0
+#define ISPRSZ_HFILT1716_COEF16_MASK           0x3FF
+#define ISPRSZ_HFILT1716_COEF17_SHIFT          16
+#define ISPRSZ_HFILT1716_COEF17_MASK           0x3FF0000
+
+#define ISPRSZ_HFILT1918_COEF18_SHIFT          0
+#define ISPRSZ_HFILT1918_COEF18_MASK           0x3FF
+#define ISPRSZ_HFILT1918_COEF19_SHIFT          16
+#define ISPRSZ_HFILT1918_COEF19_MASK           0x3FF0000
+
+#define ISPRSZ_HFILT2120_COEF20_SHIFT          0
+#define ISPRSZ_HFILT2120_COEF20_MASK           0x3FF
+#define ISPRSZ_HFILT2120_COEF21_SHIFT          16
+#define ISPRSZ_HFILT2120_COEF21_MASK           0x3FF0000
+
+#define ISPRSZ_HFILT2322_COEF22_SHIFT          0
+#define ISPRSZ_HFILT2322_COEF22_MASK           0x3FF
+#define ISPRSZ_HFILT2322_COEF23_SHIFT          16
+#define ISPRSZ_HFILT2322_COEF23_MASK           0x3FF0000
+
+#define ISPRSZ_HFILT2524_COEF24_SHIFT          0
+#define ISPRSZ_HFILT2524_COEF24_MASK           0x3FF
+#define ISPRSZ_HFILT2524_COEF25_SHIFT          16
+#define ISPRSZ_HFILT2524_COEF25_MASK           0x3FF0000
+
+#define ISPRSZ_HFILT2726_COEF26_SHIFT          0
+#define ISPRSZ_HFILT2726_COEF26_MASK           0x3FF
+#define ISPRSZ_HFILT2726_COEF27_SHIFT          16
+#define ISPRSZ_HFILT2726_COEF27_MASK           0x3FF0000
+
+#define ISPRSZ_HFILT2928_COEF28_SHIFT          0
+#define ISPRSZ_HFILT2928_COEF28_MASK           0x3FF
+#define ISPRSZ_HFILT2928_COEF29_SHIFT          16
+#define ISPRSZ_HFILT2928_COEF29_MASK           0x3FF0000
+
+#define ISPRSZ_HFILT3130_COEF30_SHIFT          0
+#define ISPRSZ_HFILT3130_COEF30_MASK           0x3FF
+#define ISPRSZ_HFILT3130_COEF31_SHIFT          16
+#define ISPRSZ_HFILT3130_COEF31_MASK           0x3FF0000
+
+#define ISPRSZ_VFILT10_COEF0_SHIFT             0
+#define ISPRSZ_VFILT10_COEF0_MASK              0x3FF
+#define ISPRSZ_VFILT10_COEF1_SHIFT             16
+#define ISPRSZ_VFILT10_COEF1_MASK              0x3FF0000
+
+#define ISPRSZ_VFILT32_COEF2_SHIFT             0
+#define ISPRSZ_VFILT32_COEF2_MASK              0x3FF
+#define ISPRSZ_VFILT32_COEF3_SHIFT             16
+#define ISPRSZ_VFILT32_COEF3_MASK              0x3FF0000
+
+#define ISPRSZ_VFILT54_COEF4_SHIFT             0
+#define ISPRSZ_VFILT54_COEF4_MASK              0x3FF
+#define ISPRSZ_VFILT54_COEF5_SHIFT             16
+#define ISPRSZ_VFILT54_COEF5_MASK              0x3FF0000
+
+#define ISPRSZ_VFILT76_COEFF6_SHIFT            0
+#define ISPRSZ_VFILT76_COEFF6_MASK             0x3FF
+#define ISPRSZ_VFILT76_COEFF7_SHIFT            16
+#define ISPRSZ_VFILT76_COEFF7_MASK             0x3FF0000
+
+#define ISPRSZ_VFILT98_COEFF8_SHIFT            0
+#define ISPRSZ_VFILT98_COEFF8_MASK             0x3FF
+#define ISPRSZ_VFILT98_COEFF9_SHIFT            16
+#define ISPRSZ_VFILT98_COEFF9_MASK             0x3FF0000
+
+#define ISPRSZ_VFILT1110_COEF10_SHIFT          0
+#define ISPRSZ_VFILT1110_COEF10_MASK           0x3FF
+#define ISPRSZ_VFILT1110_COEF11_SHIFT          16
+#define ISPRSZ_VFILT1110_COEF11_MASK           0x3FF0000
+
+#define ISPRSZ_VFILT1312_COEFF12_SHIFT         0
+#define ISPRSZ_VFILT1312_COEFF12_MASK          0x3FF
+#define ISPRSZ_VFILT1312_COEFF13_SHIFT         16
+#define ISPRSZ_VFILT1312_COEFF13_MASK          0x3FF0000
+
+#define ISPRSZ_VFILT1514_COEFF14_SHIFT         0
+#define ISPRSZ_VFILT1514_COEFF14_MASK          0x3FF
+#define ISPRSZ_VFILT1514_COEFF15_SHIFT         16
+#define ISPRSZ_VFILT1514_COEFF15_MASK          0x3FF0000
+
+#define ISPRSZ_VFILT1716_COEF16_SHIFT          0
+#define ISPRSZ_VFILT1716_COEF16_MASK           0x3FF
+#define ISPRSZ_VFILT1716_COEF17_SHIFT          16
+#define ISPRSZ_VFILT1716_COEF17_MASK           0x3FF0000
+
+#define ISPRSZ_VFILT1918_COEF18_SHIFT          0
+#define ISPRSZ_VFILT1918_COEF18_MASK           0x3FF
+#define ISPRSZ_VFILT1918_COEF19_SHIFT          16
+#define ISPRSZ_VFILT1918_COEF19_MASK           0x3FF0000
+
+#define ISPRSZ_VFILT2120_COEF20_SHIFT          0
+#define ISPRSZ_VFILT2120_COEF20_MASK           0x3FF
+#define ISPRSZ_VFILT2120_COEF21_SHIFT          16
+#define ISPRSZ_VFILT2120_COEF21_MASK           0x3FF0000
+
+#define ISPRSZ_VFILT2322_COEF22_SHIFT          0
+#define ISPRSZ_VFILT2322_COEF22_MASK           0x3FF
+#define ISPRSZ_VFILT2322_COEF23_SHIFT          16
+#define ISPRSZ_VFILT2322_COEF23_MASK           0x3FF0000
+
+#define ISPRSZ_VFILT2524_COEF24_SHIFT          0
+#define ISPRSZ_VFILT2524_COEF24_MASK           0x3FF
+#define ISPRSZ_VFILT2524_COEF25_SHIFT          16
+#define ISPRSZ_VFILT2524_COEF25_MASK           0x3FF0000
+
+#define ISPRSZ_VFILT2726_COEF26_SHIFT          0
+#define ISPRSZ_VFILT2726_COEF26_MASK           0x3FF
+#define ISPRSZ_VFILT2726_COEF27_SHIFT          16
+#define ISPRSZ_VFILT2726_COEF27_MASK           0x3FF0000
+
+#define ISPRSZ_VFILT2928_COEF28_SHIFT          0
+#define ISPRSZ_VFILT2928_COEF28_MASK           0x3FF
+#define ISPRSZ_VFILT2928_COEF29_SHIFT          16
+#define ISPRSZ_VFILT2928_COEF29_MASK           0x3FF0000
+
+#define ISPRSZ_VFILT3130_COEF30_SHIFT          0
+#define ISPRSZ_VFILT3130_COEF30_MASK           0x3FF
+#define ISPRSZ_VFILT3130_COEF31_SHIFT          16
+#define ISPRSZ_VFILT3130_COEF31_MASK           0x3FF0000
+
+#define ISPRSZ_YENH_CORE_SHIFT                 0
+#define ISPRSZ_YENH_CORE_MASK                  0xFF
+#define ISPRSZ_YENH_SLOP_SHIFT                 8
+#define ISPRSZ_YENH_SLOP_MASK                  0xF00
+#define ISPRSZ_YENH_GAIN_SHIFT                 12
+#define ISPRSZ_YENH_GAIN_MASK                  0xF000
+#define ISPRSZ_YENH_ALGO_SHIFT                 16
+#define ISPRSZ_YENH_ALGO_MASK                  0x30000
+
+#define ISPH3A_PCR_AEW_ALAW_EN_SHIFT           1
+#define ISPH3A_PCR_AF_MED_TH_SHIFT             3
+#define ISPH3A_PCR_AF_RGBPOS_SHIFT             11
+#define ISPH3A_PCR_AEW_AVE2LMT_SHIFT           22
+#define ISPH3A_PCR_AEW_AVE2LMT_MASK            0xFFC00000
+
+#define ISPH3A_AEWWIN1_WINHC_SHIFT             0
+#define ISPH3A_AEWWIN1_WINHC_MASK              0x3F
+#define ISPH3A_AEWWIN1_WINVC_SHIFT             6
+#define ISPH3A_AEWWIN1_WINVC_MASK              0x1FC0
+#define ISPH3A_AEWWIN1_WINW_SHIFT              13
+#define ISPH3A_AEWWIN1_WINW_MASK               0xFE000
+#define ISPH3A_AEWWIN1_WINH_SHIFT              24
+#define ISPH3A_AEWWIN1_WINH_MASK               0x7F000000
+
+#define ISPH3A_AEWINSTART_WINSH_SHIFT          0
+#define ISPH3A_AEWINSTART_WINSH_MASK           0x0FFF
+#define ISPH3A_AEWINSTART_WINSV_SHIFT          16
+#define ISPH3A_AEWINSTART_WINSV_MASK           0x0FFF0000
+
+#define ISPH3A_AEWINBLK_WINH_SHIFT             0
+#define ISPH3A_AEWINBLK_WINH_MASK              0x7F
+#define ISPH3A_AEWINBLK_WINSV_SHIFT            16
+#define ISPH3A_AEWINBLK_WINSV_MASK             0x0FFF0000
+
+#define ISPH3A_AEWSUBWIN_AEWINCH_SHIFT         0
+#define ISPH3A_AEWSUBWIN_AEWINCH_MASK          0x0F
+#define ISPH3A_AEWSUBWIN_AEWINCV_SHIFT         8
+#define ISPH3A_AEWSUBWIN_AEWINCV_MASK          0x0F00
+
+#define ISPHIST_PCR_ENABLE_SHIFT       0
+#define ISPHIST_PCR_ENABLE_MASK                0x01
+#define ISPHIST_PCR_BUSY_SHIFT         1
+#define ISPHIST_PCR_BUSY_MASK          0x02
+
+#define ISPHIST_CNT_DATASIZE_SHIFT     8
+#define ISPHIST_CNT_DATASIZE_MASK      0x0100
+#define ISPHIST_CNT_CLEAR_SHIFT                7
+#define ISPHIST_CNT_CLEAR_MASK         0x080
+#define ISPHIST_CNT_CFA_SHIFT          6
+#define ISPHIST_CNT_CFA_MASK           0x040
+#define ISPHIST_CNT_BINS_SHIFT         4
+#define ISPHIST_CNT_BINS_MASK          0x030
+#define ISPHIST_CNT_SOURCE_SHIFT       3
+#define ISPHIST_CNT_SOURCE_MASK                0x08
+#define ISPHIST_CNT_SHIFT_SHIFT                0
+#define ISPHIST_CNT_SHIFT_MASK         0x07
+
+#define ISPHIST_WB_GAIN_WG00_SHIFT     24
+#define ISPHIST_WB_GAIN_WG00_MASK      0xFF000000
+#define ISPHIST_WB_GAIN_WG01_SHIFT     16
+#define ISPHIST_WB_GAIN_WG01_MASK      0xFF0000
+#define ISPHIST_WB_GAIN_WG02_SHIFT     8
+#define ISPHIST_WB_GAIN_WG02_MASK      0xFF00
+#define ISPHIST_WB_GAIN_WG03_SHIFT     0
+#define ISPHIST_WB_GAIN_WG03_MASK      0xFF
+
+#define ISPHIST_REGHORIZ_HSTART_SHIFT          16      /*
+                                                       * REGION 0 to 3 HORZ
+                                                       * and VERT
+                                                       */
+#define ISPHIST_REGHORIZ_HSTART_MASK           0x3FFF0000
+#define ISPHIST_REGHORIZ_HEND_SHIFT            0
+#define ISPHIST_REGHORIZ_HEND_MASK             0x3FFF
+#define ISPHIST_REGVERT_VSTART_SHIFT           16
+#define ISPHIST_REGVERT_VSTART_MASK            0x3FFF0000
+#define ISPHIST_REGVERT_VEND_SHIFT             0
+#define ISPHIST_REGVERT_VEND_MASK              0x3FFF
+
+#define ISPHIST_REGHORIZ_MASK                  0x3FFF3FFF
+#define ISPHIST_REGVERT_MASK                   0x3FFF3FFF
+
+#define ISPHIST_ADDR_SHIFT                     0
+#define ISPHIST_ADDR_MASK                      0x3FF
+
+#define ISPHIST_DATA_SHIFT                     0
+#define ISPHIST_DATA_MASK                      0xFFFFF
+
+#define ISPHIST_RADD_SHIFT                     0
+#define ISPHIST_RADD_MASK                      0xFFFFFFFF
+
+#define ISPHIST_RADD_OFF_SHIFT                 0
+#define ISPHIST_RADD_OFF_MASK                  0xFFFF
+
+#define ISPHIST_HV_INFO_HSIZE_SHIFT            16
+#define ISPHIST_HV_INFO_HSIZE_MASK             0x3FFF0000
+#define ISPHIST_HV_INFO_VSIZE_SHIFT            0
+#define ISPHIST_HV_INFO_VSIZE_MASK             0x3FFF
+
+#define ISPHIST_HV_INFO_MASK                   0x3FFF3FFF
+
+#define ISPCCDC_LSC_GAIN_MODE_N_MASK           0x700
+#define ISPCCDC_LSC_GAIN_MODE_N_SHIFT          8
+#define ISPCCDC_LSC_GAIN_MODE_M_MASK           0x3800
+#define ISPCCDC_LSC_GAIN_MODE_M_SHIFT          12
+#define ISPCCDC_LSC_GAIN_FORMAT_MASK           0xE
+#define ISPCCDC_LSC_GAIN_FORMAT_SHIFT          1
+#define ISPCCDC_LSC_AFTER_REFORMATTER_MASK     (1<<6)
+
+#define ISPCCDC_LSC_INITIAL_X_MASK             0x3F
+#define ISPCCDC_LSC_INITIAL_X_SHIFT            0
+#define ISPCCDC_LSC_INITIAL_Y_MASK             0x3F0000
+#define ISPCCDC_LSC_INITIAL_Y_SHIFT            16
+
+#define ISPMMU_REVISION_REV_MINOR_MASK         0xF
+#define ISPMMU_REVISION_REV_MAJOR_SHIFT                0x4
+
+#define IRQENABLE_MULTIHITFAULT                        (1<<4)
+#define IRQENABLE_TWFAULT                      (1<<3)
+#define IRQENABLE_EMUMISS                      (1<<2)
+#define IRQENABLE_TRANSLNFAULT                 (1<<1)
+#define IRQENABLE_TLBMISS                      (1)
+
+#define ISPMMU_MMUCNTL_MMU_EN                  (1<<1)
+#define ISPMMU_MMUCNTL_TWL_EN                  (1<<2)
+#define ISPMMU_MMUCNTL_EMUTLBUPDATE            (1<<3)
+#define ISPMMU_AUTOIDLE                                0x1
+#define ISPMMU_SIDLEMODE_FORCEIDLE             0
+#define ISPMMU_SIDLEMODE_NOIDLE                        1
+#define ISPMMU_SIDLEMODE_SMARTIDLE             2
+#define ISPMMU_SIDLEMODE_SHIFT                 3
+
+#define ISPCSI1_AUTOIDLE                       0x1
+#define ISPCSI1_MIDLEMODE_SHIFT                        12
+#define ISPCSI1_MIDLEMODE_FORCESTANDBY         0x0
+#define ISPCSI1_MIDLEMODE_NOSTANDBY            0x1
+#define ISPCSI1_MIDLEMODE_SMARTSTANDBY         0x2
+
+#endif /* __ISPREG_H__ */
Index: linux-omap-2.6/drivers/media/video/isp/ispresizer.c
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/isp/ispresizer.c 2008-08-28 19:42:53.000000000 -0500
@@ -0,0 +1,866 @@
+/*
+ * drivers/media/video/isp/ispresizer.c
+ *
+ * Driver Library for Resizer module in TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C)2008 Texas Instruments, Inc.
+ *
+ * Contributors:
+ *     Sameer Venkatraman <sameerv@ti.com>
+ *     Mohit Jalori <mjalori@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#include <linux/io.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/semaphore.h>
+
+#include "isp.h"
+#include "ispreg.h"
+#include "ispresizer.h"
+
+/* Default configuration of resizer,filter coefficients,yenh for camera isp */
+static struct isprsz_yenh ispreszdefaultyenh = {0, 0, 0, 0};
+static struct isprsz_coef ispreszdefcoef = {
+       {
+               0x0000, 0x0100, 0x0000, 0x0000,
+               0x03FA, 0x00F6, 0x0010, 0x0000,
+               0x03F9, 0x00DB, 0x002C, 0x0000,
+               0x03FB, 0x00B3, 0x0053, 0x03FF,
+               0x03FD, 0x0082, 0x0084, 0x03FD,
+               0x03FF, 0x0053, 0x00B3, 0x03FB,
+               0x0000, 0x002C, 0x00DB, 0x03F9,
+               0x0000, 0x0010, 0x00F6, 0x03FA
+       },
+       {
+               0x0000, 0x0100, 0x0000, 0x0000,
+               0x03FA, 0x00F6, 0x0010, 0x0000,
+               0x03F9, 0x00DB, 0x002C, 0x0000,
+               0x03FB, 0x00B3, 0x0053, 0x03FF,
+               0x03FD, 0x0082, 0x0084, 0x03FD,
+               0x03FF, 0x0053, 0x00B3, 0x03FB,
+               0x0000, 0x002C, 0x00DB, 0x03F9,
+               0x0000, 0x0010, 0x00F6, 0x03FA
+       },
+       {
+               0x0004, 0x0023, 0x005A, 0x0058,
+               0x0023, 0x0004, 0x0000, 0x0002,
+               0x0018, 0x004d, 0x0060, 0x0031,
+               0x0008, 0x0000, 0x0001, 0x000f,
+               0x003f, 0x0062, 0x003f, 0x000f,
+               0x0001, 0x0000, 0x0008, 0x0031,
+               0x0060, 0x004d, 0x0018, 0x0002
+       },
+       {
+               0x0004, 0x0023, 0x005A, 0x0058,
+               0x0023, 0x0004, 0x0000, 0x0002,
+               0x0018, 0x004d, 0x0060, 0x0031,
+               0x0008, 0x0000, 0x0001, 0x000f,
+               0x003f, 0x0062, 0x003f, 0x000f,
+               0x0001, 0x0000, 0x0008, 0x0031,
+               0x0060, 0x004d, 0x0018, 0x0002
+       }
+};
+
+/**
+ * struct isp_res - Structure for the resizer module to store its information.
+ * @res_inuse: Indicates if resizer module has been reserved. 1 - Reserved,
+ *             0 - Freed.
+ * @h_startphase: Horizontal starting phase.
+ * @v_startphase: Vertical starting phase.
+ * @h_resz: Horizontal resizing value.
+ * @v_resz: Vertical resizing value.
+ * @outputwidth: Output Image Width in pixels.
+ * @outputheight: Output Image Height in pixels.
+ * @inputwidth: Input Image Width in pixels.
+ * @inputheight: Input Image Height in pixels.
+ * @algo: Algorithm select. 0 - Disable, 1 - [-1 2 -1]/2 high-pass filter,
+ *        2 - [-1 -2 6 -2 -1]/4 high-pass filter.
+ * @ipht_crop: Vertical start line for cropping.
+ * @ipwd_crop: Horizontal start pixel for cropping.
+ * @cropwidth: Crop Width.
+ * @cropheight: Crop Height.
+ * @resinput: Resizer input.
+ * @coeflist: Register configuration for Resizer.
+ * @ispres_mutex: Mutex for isp resizer.
+ */
+static struct isp_res {
+       u8 res_inuse;
+       u8 h_startphase;
+       u8 v_startphase;
+       u16 h_resz;
+       u16 v_resz;
+       u32 outputwidth;
+       u32 outputheight;
+       u32 inputwidth;
+       u32 inputheight;
+       u8 algo;
+       u32 ipht_crop;
+       u32 ipwd_crop;
+       u32 cropwidth;
+       u32 cropheight;
+       enum ispresizer_input resinput;
+       struct isprsz_coef coeflist;
+       struct mutex ispres_mutex; /* For checking/modifying res_inuse */
+} ispres_obj;
+
+/* Structure for saving/restoring resizer module registers */
+static struct isp_reg isprsz_reg_list[] = {
+       {ISPRSZ_CNT, 0x0000},
+       {ISPRSZ_OUT_SIZE, 0x0000},
+       {ISPRSZ_IN_START, 0x0000},
+       {ISPRSZ_IN_SIZE, 0x0000},
+       {ISPRSZ_SDR_INADD, 0x0000},
+       {ISPRSZ_SDR_INOFF, 0x0000},
+       {ISPRSZ_SDR_OUTADD, 0x0000},
+       {ISPRSZ_SDR_OUTOFF, 0x0000},
+       {ISPRSZ_HFILT10, 0x0000},
+       {ISPRSZ_HFILT32, 0x0000},
+       {ISPRSZ_HFILT54, 0x0000},
+       {ISPRSZ_HFILT76, 0x0000},
+       {ISPRSZ_HFILT98, 0x0000},
+       {ISPRSZ_HFILT1110, 0x0000},
+       {ISPRSZ_HFILT1312, 0x0000},
+       {ISPRSZ_HFILT1514, 0x0000},
+       {ISPRSZ_HFILT1716, 0x0000},
+       {ISPRSZ_HFILT1918, 0x0000},
+       {ISPRSZ_HFILT2120, 0x0000},
+       {ISPRSZ_HFILT2322, 0x0000},
+       {ISPRSZ_HFILT2524, 0x0000},
+       {ISPRSZ_HFILT2726, 0x0000},
+       {ISPRSZ_HFILT2928, 0x0000},
+       {ISPRSZ_HFILT3130, 0x0000},
+       {ISPRSZ_VFILT10, 0x0000},
+       {ISPRSZ_VFILT32, 0x0000},
+       {ISPRSZ_VFILT54, 0x0000},
+       {ISPRSZ_VFILT76, 0x0000},
+       {ISPRSZ_VFILT98, 0x0000},
+       {ISPRSZ_VFILT1110, 0x0000},
+       {ISPRSZ_VFILT1312, 0x0000},
+       {ISPRSZ_VFILT1514, 0x0000},
+       {ISPRSZ_VFILT1716, 0x0000},
+       {ISPRSZ_VFILT1918, 0x0000},
+       {ISPRSZ_VFILT2120, 0x0000},
+       {ISPRSZ_VFILT2322, 0x0000},
+       {ISPRSZ_VFILT2524, 0x0000},
+       {ISPRSZ_VFILT2726, 0x0000},
+       {ISPRSZ_VFILT2928, 0x0000},
+       {ISPRSZ_VFILT3130, 0x0000},
+       {ISPRSZ_YENH, 0x0000},
+       {ISP_TOK_TERM, 0x0000}
+};
+
+/**
+ * ispresizer_config_shadow_registers - Configure shadow registers.
+ **/
+void ispresizer_config_shadow_registers()
+{
+       return;
+}
+EXPORT_SYMBOL(ispresizer_config_shadow_registers);
+
+/**
+ * ispresizer_trycrop - Validate crop dimensions.
+ * @left: Left distance to start position of crop.
+ * @top: Top distance to start position of crop.
+ * @width: Width of input image.
+ * @height: Height of input image.
+ * @ow: Width of output image.
+ * @oh: Height of output image.
+ **/
+void ispresizer_trycrop(u32 left, u32 top, u32 width, u32 height, u32 ow,
+                                                                       u32 oh)
+{
+       ispres_obj.cropwidth = width + 6;
+       ispres_obj.cropheight = height + 6;
+       ispresizer_try_size(&ispres_obj.cropwidth, &ispres_obj.cropheight, &ow,
+                                                                       &oh);
+       ispres_obj.ipht_crop = top;
+       ispres_obj.ipwd_crop = left;
+}
+EXPORT_SYMBOL(ispresizer_trycrop);
+
+/**
+ * ispresizer_applycrop - Apply crop to input image.
+ **/
+void ispresizer_applycrop()
+{
+       ispresizer_config_size(ispres_obj.cropwidth, ispres_obj.cropheight,
+                                               ispres_obj.outputwidth,
+                                               ispres_obj.outputheight);
+       return;
+}
+EXPORT_SYMBOL(ispresizer_applycrop);
+
+/**
+ * ispresizer_request - Reserves the Resizer module.
+ *
+ * Allows only one user at a time.
+ *
+ * Returns 0 if successful, or -EBUSY if resizer module was already requested.
+ **/
+int ispresizer_request()
+{
+       mutex_lock(&ispres_obj.ispres_mutex);
+       if (!ispres_obj.res_inuse) {
+               ispres_obj.res_inuse = 1;
+               mutex_unlock(&ispres_obj.ispres_mutex);
+               omap_writel(omap_readl(ISP_CTRL) | ISPCTRL_SBL_WR0_RAM_EN |
+                                               ISPCTRL_RSZ_CLK_EN, ISP_CTRL);
+               return 0;
+       } else {
+               mutex_unlock(&ispres_obj.ispres_mutex);
+               printk(KERN_ERR "ISP_ERR : Resizer Module Busy\n");
+               return -EBUSY;
+       }
+}
+EXPORT_SYMBOL(ispresizer_request);
+
+/**
+ * ispresizer_free - Makes Resizer module free.
+ *
+ * Returns 0 if successful, or -EINVAL if resizer module was already freed.
+ **/
+int ispresizer_free()
+{
+       mutex_lock(&ispres_obj.ispres_mutex);
+       if (ispres_obj.res_inuse) {
+               ispres_obj.res_inuse = 0;
+               mutex_unlock(&ispres_obj.ispres_mutex);
+               omap_writel(omap_readl(ISP_CTRL) & ~(ISPCTRL_RSZ_CLK_EN |
+                                       ISPCTRL_SBL_WR0_RAM_EN), ISP_CTRL);
+               return 0;
+       } else {
+               mutex_unlock(&ispres_obj.ispres_mutex);
+               DPRINTK_ISPRESZ("ISP_ERR : Resizer Module already freed\n");
+               return -EINVAL;
+       }
+}
+EXPORT_SYMBOL(ispresizer_free);
+
+/**
+ * ispresizer_config_datapath - Specifies which input to use in resizer module
+ * @input: Indicates the module that gives the image to resizer.
+ *
+ * Sets up the default resizer configuration according to the arguments.
+ *
+ * Returns 0 if successful, or -EINVAL if an unsupported input was requested.
+ **/
+int ispresizer_config_datapath(enum ispresizer_input input)
+{
+       u32 cnt = 0;
+       DPRINTK_ISPRESZ("ispresizer_config_datapath()+\n");
+       ispres_obj.resinput = input;
+       switch (input) {
+       case RSZ_OTFLY_YUV:
+               cnt &= ~ISPRSZ_CNT_INPTYP;
+               cnt &= ~ISPRSZ_CNT_INPSRC;
+               ispresizer_set_inaddr(0);
+               ispresizer_config_inlineoffset(0);
+               break;
+       case RSZ_MEM_YUV:
+               cnt |= ISPRSZ_CNT_INPSRC;
+               cnt &= ~ISPRSZ_CNT_INPTYP;
+               break;
+       case RSZ_MEM_COL8:
+               cnt |= ISPRSZ_CNT_INPSRC;
+               cnt |= ISPRSZ_CNT_INPTYP;
+               break;
+       default:
+               printk(KERN_ERR "ISP_ERR : Wrong Input\n");
+               return -EINVAL;
+       }
+       omap_writel(omap_readl(ISPRSZ_CNT) | cnt, ISPRSZ_CNT);
+       ispresizer_config_ycpos(0);
+       ispresizer_config_filter_coef(&ispreszdefcoef);
+       ispresizer_enable_cbilin(0);
+       ispresizer_config_luma_enhance(&ispreszdefaultyenh);
+       DPRINTK_ISPRESZ("ispresizer_config_datapath()-\n");
+       return 0;
+}
+EXPORT_SYMBOL(ispresizer_config_datapath);
+
+/**
+ * ispresizer_try_size - Validates input and output images size.
+ * @input_w: input width for the resizer in number of pixels per line
+ * @input_h: input height for the resizer in number of lines
+ * @output_w: output width from the resizer in number of pixels per line
+ *            resizer when writing to memory needs this to be multiple of 16.
+ * @output_h: output height for the resizer in number of lines, must be even.
+ *
+ * Calculates the horizontal and vertical resize ratio, number of pixels to
+ * be cropped in the resizer module and checks the validity of various
+ * parameters. Formula used for calculation is:-
+ *
+ * 8-phase 4-tap mode :-
+ * inputwidth = (32 * sph + (ow - 1) * hrsz + 16) >> 8 + 7
+ * inputheight = (32 * spv + (oh - 1) * vrsz + 16) >> 8 + 4
+ * endpahse for width = ((32 * sph + (ow - 1) * hrsz + 16) >> 5) % 8
+ * endphase for height = ((32 * sph + (oh - 1) * hrsz + 16) >> 5) % 8
+ *
+ * 4-phase 7-tap mode :-
+ * inputwidth = (64 * sph + (ow - 1) * hrsz + 32) >> 8 + 7
+ * inputheight = (64 * spv + (oh - 1) * vrsz + 32) >> 8 + 7
+ * endpahse for width = ((64 * sph + (ow - 1) * hrsz + 32) >> 6) % 4
+ * endphase for height = ((64 * sph + (oh - 1) * hrsz + 32) >> 6) % 4
+ *
+ * Where:
+ * sph = Start phase horizontal
+ * spv = Start phase vertical
+ * ow = Output width
+ * oh = Output height
+ * hrsz = Horizontal resize value
+ * vrsz = Vertical resize value
+ *
+ * Fills up the output/input widht/height, horizontal/vertical resize ratio,
+ * horizontal/vertical crop variables in the isp_res structure.
+ **/
+int ispresizer_try_size(u32 *input_width, u32 *input_height, u32 *output_w,
+                                                               u32 *output_h)
+{
+       u32 rsz, rsz_7, rsz_4;
+       u32 sph;
+       u32 input_w, input_h;
+       int max_in_otf, max_out_7tap;
+       input_w = *input_width;
+       input_h = *input_height;
+
+       input_w -= 6;
+       input_h -= 6;
+
+       if (input_h > MAX_IN_HEIGHT)
+               return -EINVAL;
+
+       if (*output_w < 16)
+               *output_w = 16;
+
+       if (*output_h < 2)
+               *output_h = 2;
+
+       if (is_sil_rev_equal_to(OMAP3430_REV_ES1_0)) {
+               max_in_otf = MAX_IN_WIDTH_ONTHEFLY_MODE;
+               max_out_7tap = MAX_7TAP_VRSZ_OUTWIDTH;
+       } else {
+               max_in_otf = MAX_IN_WIDTH_ONTHEFLY_MODE_ES2;
+               max_out_7tap = MAX_7TAP_VRSZ_OUTWIDTH_ES2;
+       }
+
+       if (ispres_obj.resinput == RSZ_OTFLY_YUV) {
+               if (input_w > max_in_otf)
+                       return -EINVAL;
+       } else {
+               if (input_w > MAX_IN_WIDTH_MEMORY_MODE)
+                       return -EINVAL;
+       }
+
+       *output_h &= 0xfffffffe;
+       sph = DEFAULTSTPHASE;
+
+       rsz_7 = ((input_h - 7) * 256) / (*output_h - 1);
+       rsz_4 = ((input_h - 4) * 256) / (*output_h - 1);
+
+       rsz = (input_h * 256) / *output_h;
+
+       if (rsz <= MID_RESIZE_VALUE) {
+               rsz = rsz_4;
+               if (rsz < MINIMUM_RESIZE_VALUE) {
+                       rsz = MINIMUM_RESIZE_VALUE;
+                       *output_h = (((input_h - 4) * 256) / rsz) + 1;
+                       printk(KERN_INFO "%s: using output_h %d instead\n",
+                              __func__, *output_h);
+               }
+       } else {
+               rsz = rsz_7;
+               if (*output_w > max_out_7tap)
+                       *output_w = max_out_7tap;
+               if (rsz > MAXIMUM_RESIZE_VALUE) {
+                       rsz = MAXIMUM_RESIZE_VALUE;
+                       *output_h = (((input_h - 7) * 256) / rsz) + 1;
+                       printk(KERN_INFO "%s: using output_h %d instead\n",
+                              __func__, *output_h);
+               }
+       }
+
+       if (rsz > MID_RESIZE_VALUE)
+               input_h =
+                       (((64 * sph) + ((*output_h - 1) * rsz) + 32) / 256) + 7;
+       else
+               input_h =
+                       (((32 * sph) + ((*output_h - 1) * rsz) + 16) / 256) + 4;
+
+       ispres_obj.outputheight = *output_h;
+       ispres_obj.v_resz = rsz;
+       ispres_obj.inputheight = input_h;
+       ispres_obj.ipht_crop = DEFAULTSTPIXEL;
+       ispres_obj.v_startphase = sph;
+
+       *output_w &= 0xfffffff0;
+       sph = DEFAULTSTPHASE;
+
+       rsz_7 = ((input_w - 7) * 256) / (*output_w - 1);
+       rsz_4 = ((input_w - 4) * 256) / (*output_w - 1);
+
+       rsz = (input_w * 256) / *output_w;
+       if (rsz > MID_RESIZE_VALUE) {
+               rsz = rsz_7;
+               if (rsz > MAXIMUM_RESIZE_VALUE) {
+                       rsz = MAXIMUM_RESIZE_VALUE;
+                       *output_w = (((input_w - 7) * 256) / rsz) + 1;
+                       *output_w = (*output_w + 0xf) & 0xfffffff0;
+                       printk(KERN_INFO "%s: using output_w %d instead\n",
+                              __func__, *output_w);
+               }
+       } else {
+               rsz = rsz_4;
+               if (rsz < MINIMUM_RESIZE_VALUE) {
+                       rsz = MINIMUM_RESIZE_VALUE;
+                       *output_w = (((input_w - 4) * 256) / rsz) + 1;
+                       *output_w = (*output_w + 0xf) & 0xfffffff0;
+                       printk(KERN_INFO "%s: using output_w %d instead\n",
+                              __func__, *output_w);
+               }
+       }
+
+       /* Recalculate input based on TRM equations */
+       if (rsz > MID_RESIZE_VALUE)
+               input_w =
+                       (((64 * sph) + ((*output_w - 1) * rsz) + 32) / 256) + 7;
+       else
+               input_w =
+                       (((32 * sph) + ((*output_w - 1) * rsz) + 16) / 256) + 7;
+
+       ispres_obj.outputwidth = *output_w;
+       ispres_obj.h_resz = rsz;
+       ispres_obj.inputwidth = input_w;
+       ispres_obj.ipwd_crop = DEFAULTSTPIXEL;
+       ispres_obj.h_startphase = sph;
+
+       *input_height = input_h;
+       *input_width = input_w;
+       return 0;
+}
+EXPORT_SYMBOL(ispresizer_try_size);
+
+/**
+ * ispresizer_config_size - Configures input and output image size.
+ * @input_w: input width for the resizer in number of pixels per line.
+ * @input_h: input height for the resizer in number of lines.
+ * @output_w: output width from the resizer in number of pixels per line.
+ * @output_h: output height for the resizer in number of lines.
+ *
+ * Configures the appropriate values stored in the isp_res structure in the
+ * resizer registers.
+ *
+ * Returns 0 if successful, or -EINVAL if passed values haven't been verified
+ * with ispresizer_try_size() previously.
+ **/
+int ispresizer_config_size(u32 input_w, u32 input_h, u32 output_w,
+                                                               u32 output_h)
+{
+       int i, j;
+       u32 res;
+       DPRINTK_ISPRESZ("ispresizer_config_size()+, input_w = %d,input_h ="
+                                               " %d, output_w = %d, output_h"
+                                               " = %d,hresz = %d,vresz = %d,"
+                                               " hcrop = %d, vcrop = %d,"
+                                               " hstph = %d, vstph = %d\n",
+                                               ispres_obj.inputwidth,
+                                               ispres_obj.inputheight,
+                                               ispres_obj.outputwidth,
+                                               ispres_obj.outputheight,
+                                               ispres_obj.h_resz,
+                                               ispres_obj.v_resz,
+                                               ispres_obj.ipwd_crop,
+                                               ispres_obj.ipht_crop,
+                                               ispres_obj.h_startphase,
+                                               ispres_obj.v_startphase);
+       if ((output_w != ispres_obj.outputwidth)
+                       || (output_h != ispres_obj.outputheight)) {
+               printk(KERN_ERR "Output parameters passed do not match the"
+                                               " values calculated by the"
+                                               " trysize passed w %d, h %d"
+                                               " \n", output_w , output_h);
+               return -EINVAL;
+       }
+       res = omap_readl(ISPRSZ_CNT) & (~(ISPRSZ_CNT_HSTPH_MASK |
+                                       ISPRSZ_CNT_VSTPH_MASK));
+       omap_writel(res | (ispres_obj.h_startphase << ISPRSZ_CNT_HSTPH_SHIFT) |
+                                               (ispres_obj.v_startphase <<
+                                               ISPRSZ_CNT_VSTPH_SHIFT),
+                                               ISPRSZ_CNT);
+       omap_writel(((ispres_obj.ipwd_crop * 2) <<
+                                       ISPRSZ_IN_START_HORZ_ST_SHIFT) |
+                                       (ispres_obj.ipht_crop <<
+                                       ISPRSZ_IN_START_VERT_ST_SHIFT),
+                                       ISPRSZ_IN_START);
+
+       omap_writel((ispres_obj.inputwidth << ISPRSZ_IN_SIZE_HORZ_SHIFT) |
+                                               (ispres_obj.inputheight <<
+                                               ISPRSZ_IN_SIZE_VERT_SHIFT),
+                                               ISPRSZ_IN_SIZE);
+       if (!ispres_obj.algo) {
+               omap_writel((output_w << ISPRSZ_OUT_SIZE_HORZ_SHIFT) |
+                                               (output_h <<
+                                               ISPRSZ_OUT_SIZE_VERT_SHIFT),
+                                               ISPRSZ_OUT_SIZE);
+       } else {
+               omap_writel(((output_w - 4) << ISPRSZ_OUT_SIZE_HORZ_SHIFT) |
+                                               (output_h <<
+                                               ISPRSZ_OUT_SIZE_VERT_SHIFT),
+                                               ISPRSZ_OUT_SIZE);
+       }
+
+       res = omap_readl(ISPRSZ_CNT) & (~(ISPRSZ_CNT_HRSZ_MASK |
+                                               ISPRSZ_CNT_VRSZ_MASK));
+       omap_writel(res | ((ispres_obj.h_resz - 1) << ISPRSZ_CNT_HRSZ_SHIFT) |
+                                               ((ispres_obj.v_resz - 1) <<
+                                               ISPRSZ_CNT_VRSZ_SHIFT),
+                                               ISPRSZ_CNT);
+       if (ispres_obj.h_resz <= MID_RESIZE_VALUE) {
+               j = 0;
+               for (i = 0; i < 16; i++) {
+                       omap_writel((ispres_obj.coeflist.
+                                               h_filter_coef_4tap[j] <<
+                                               ISPRSZ_HFILT10_COEF0_SHIFT) |
+                                               (ispres_obj.coeflist.
+                                               h_filter_coef_4tap[j + 1] <<
+                                               ISPRSZ_HFILT10_COEF1_SHIFT),
+                                               ISPRSZ_HFILT10 + (i * 0x04));
+               }
+       } else {
+               j = 0;
+               for (i = 0; i < 16; i++) {
+                       if ((i + 1) % 4 == 0) {
+                               omap_writel((ispres_obj.coeflist.
+                                               h_filter_coef_7tap[j] <<
+                                               ISPRSZ_HFILT10_COEF0_SHIFT),
+                                               ISPRSZ_HFILT10 + (i * 0x04));
+                               j += 1;
+                       } else {
+                               omap_writel((ispres_obj.coeflist.
+                                               h_filter_coef_7tap[j] <<
+                                               ISPRSZ_HFILT10_COEF0_SHIFT) |
+                                               (ispres_obj.coeflist.
+                                               h_filter_coef_7tap[j+1] <<
+                                               ISPRSZ_HFILT10_COEF1_SHIFT),
+                                               ISPRSZ_HFILT10 + (i * 0x04));
+                               j += 2;
+                       }
+               }
+       }
+       if (ispres_obj.v_resz <= MID_RESIZE_VALUE) {
+               j = 0;
+               for (i = 0; i < 16; i++) {
+                       omap_writel((ispres_obj.coeflist.
+                                               v_filter_coef_4tap[j] <<
+                                               ISPRSZ_VFILT10_COEF0_SHIFT) |
+                                               (ispres_obj.coeflist.
+                                               v_filter_coef_4tap[j + 1] <<
+                                               ISPRSZ_VFILT10_COEF1_SHIFT),
+                                               ISPRSZ_VFILT10 + (i * 0x04));
+                       j += 2;
+               }
+       } else {
+               j = 0;
+               for (i = 0; i < 16; i++) {
+                       if ((i + 1) % 4 == 0) {
+                               omap_writel((ispres_obj.coeflist.
+                                               v_filter_coef_7tap[j] <<
+                                               ISPRSZ_VFILT10_COEF0_SHIFT),
+                                               ISPRSZ_VFILT10 + (i * 0x04));
+                               j += 1;
+                       } else {
+                               omap_writel((ispres_obj.coeflist.
+                                               v_filter_coef_7tap[j] <<
+                                               ISPRSZ_VFILT10_COEF0_SHIFT) |
+                                               (ispres_obj.coeflist.
+                                               v_filter_coef_7tap[j+1] <<
+                                               ISPRSZ_VFILT10_COEF1_SHIFT),
+                                               ISPRSZ_VFILT10 + (i * 0x04));
+                               j += 2;
+                       }
+               }
+       }
+
+       ispresizer_config_outlineoffset(output_w*2);
+       DPRINTK_ISPRESZ("ispresizer_config_size()-\n");
+       return 0;
+}
+EXPORT_SYMBOL(ispresizer_config_size);
+
+/**
+ * ispresizer_enable - Enables the resizer module.
+ * @enable: 1 - Enable, 0 - Disable
+ *
+ * Client should configure all the sub modules in resizer before this.
+ **/
+void ispresizer_enable(u8 enable)
+{
+       DPRINTK_ISPRESZ("+ispresizer_enable()+\n");
+       if (enable)
+               omap_writel((omap_readl(ISPRSZ_PCR)) | ISPRSZ_PCR_ENABLE,
+                                                               ISPRSZ_PCR);
+       else {
+               omap_writel((omap_readl(ISPRSZ_PCR)) & ~ISPRSZ_PCR_ENABLE,
+                                                               ISPRSZ_PCR);
+       }
+       DPRINTK_ISPRESZ("+ispresizer_enable()-\n");
+}
+EXPORT_SYMBOL(ispresizer_enable);
+
+/**
+ * ispresizer_busy - Checks if ISP resizer is busy.
+ *
+ * Returns busy field from ISPRSZ_PCR register.
+ **/
+int ispresizer_busy(void)
+{
+       return omap_readl(ISPRSZ_PCR) & ISPPRV_PCR_BUSY;
+}
+EXPORT_SYMBOL(ispresizer_busy);
+
+/**
+ * ispresizer_config_startphase - Sets the horizontal and vertical start phase.
+ * @hstartphase: horizontal start phase (0 - 7).
+ * @vstartphase: vertical startphase (0 - 7).
+ *
+ * This API just updates the isp_res struct. Actual register write happens in
+ * ispresizer_config_size.
+ **/
+void ispresizer_config_startphase(u8 hstartphase, u8 vstartphase)
+{
+       DPRINTK_ISPRESZ("ispresizer_config_startphase()+\n");
+       ispres_obj.h_startphase = hstartphase;
+       ispres_obj.v_startphase = vstartphase;
+       DPRINTK_ISPRESZ("ispresizer_config_startphase()-\n");
+}
+EXPORT_SYMBOL(ispresizer_config_startphase);
+
+/**
+ * ispresizer_config_ycpos - Specifies if output should be in YC or CY format.
+ * @yc: 0 - YC format, 1 - CY format
+ **/
+void ispresizer_config_ycpos(u8 yc)
+{
+       DPRINTK_ISPRESZ("ispresizer_config_ycpos()+\n");
+       if (yc)
+               omap_writel((omap_readl(ISPRSZ_CNT)) |
+                       (ISPRSZ_CNT_YCPOS), ISPRSZ_CNT);
+       else
+               omap_writel((omap_readl(ISPRSZ_CNT)) &
+                       (~ISPRSZ_CNT_YCPOS), ISPRSZ_CNT);
+       DPRINTK_ISPRESZ("ispresizer_config_ycpos()-\n");
+}
+EXPORT_SYMBOL(ispresizer_config_ycpos);
+
+/**
+ * Sets the chrominance algorithm
+ * @cbilin: 0 - chrominance uses same processing as luminance,
+ *          1 - bilinear interpolation processing
+ **/
+void ispresizer_enable_cbilin(u8 enable)
+{
+       DPRINTK_ISPRESZ("ispresizer_enable_cbilin()+\n");
+       if (enable) {
+               omap_writel(omap_readl(ISPRSZ_CNT) | ISPRSZ_CNT_CBILIN,
+                                                               ISPRSZ_CNT);
+       } else {
+               omap_writel(omap_readl(ISPRSZ_CNT) & ~ISPRSZ_CNT_CBILIN,
+                                                               ISPRSZ_CNT);
+       }
+       DPRINTK_ISPRESZ("ispresizer_enable_cbilin()-\n");
+}
+EXPORT_SYMBOL(ispresizer_enable_cbilin);
+
+/**
+ * ispresizer_config_luma_enhance - Configures luminance enhancer parameters.
+ * @yenh: Pointer to structure containing desired values for core, slope, gain
+ *        and algo parameters.
+ **/
+void ispresizer_config_luma_enhance(struct isprsz_yenh *yenh)
+{
+       DPRINTK_ISPRESZ("ispresizer_config_luma_enhance()+\n");
+       ispres_obj.algo = yenh->algo;
+       omap_writel((yenh->algo << ISPRSZ_YENH_ALGO_SHIFT) |
+                       (yenh->gain << ISPRSZ_YENH_GAIN_SHIFT) |
+                       (yenh->slope << ISPRSZ_YENH_SLOP_SHIFT) |
+                       (yenh->coreoffset << ISPRSZ_YENH_CORE_SHIFT),
+                       ISPRSZ_YENH);
+       DPRINTK_ISPRESZ("ispresizer_config_luma_enhance()-\n");
+}
+EXPORT_SYMBOL(ispresizer_config_luma_enhance);
+
+/**
+ * ispresizer_config_filter_coef - Sets filter coefficients for 4 & 7-tap mode.
+ * This API just updates the isp_res struct.Actual register write happens in
+ * ispresizer_config_size.
+ * @coef: Structure containing horizontal and vertical filter coefficients for
+ *        both 4-tap and 7-tap mode.
+ **/
+void ispresizer_config_filter_coef(struct isprsz_coef *coef)
+{
+       int i;
+       DPRINTK_ISPRESZ("ispresizer_config_filter_coef()+\n");
+       for (i = 0; i < 32; i++) {
+               ispres_obj.coeflist.h_filter_coef_4tap[i] =
+                                               coef->h_filter_coef_4tap[i];
+               ispres_obj.coeflist.v_filter_coef_4tap[i] =
+                                               coef->v_filter_coef_4tap[i];
+       }
+       for (i = 0; i < 28; i++) {
+               ispres_obj.coeflist.h_filter_coef_7tap[i] =
+                                               coef->h_filter_coef_7tap[i];
+               ispres_obj.coeflist.v_filter_coef_7tap[i] =
+                                               coef->v_filter_coef_7tap[i];
+       }
+       DPRINTK_ISPRESZ("ispresizer_config_filter_coef()-\n");
+}
+EXPORT_SYMBOL(ispresizer_config_filter_coef);
+
+/**
+ * ispresizer_config_inlineoffset - Configures the read address line offset.
+ * @offset: Line Offset for the input image.
+ *
+ * Returns 0 if successful, or -EINVAL if offset is not 32 bits aligned.
+ **/
+int ispresizer_config_inlineoffset(u32 offset)
+{
+       DPRINTK_ISPRESZ("ispresizer_config_inlineoffset()+\n");
+       if (offset%32)
+               return -EINVAL;
+       omap_writel(offset << ISPRSZ_SDR_INOFF_OFFSET_SHIFT, ISPRSZ_SDR_INOFF);
+       DPRINTK_ISPRESZ("ispresizer_config_inlineoffset()-\n");
+       return 0;
+}
+EXPORT_SYMBOL(ispresizer_config_inlineoffset);
+
+/**
+ * ispresizer_set_inaddr - Sets the memory address of the input frame.
+ * @addr: 32bit memory address aligned on 32byte boundary.
+ *
+ * Returns 0 if successful, or -EINVAL if address is not 32 bits aligned.
+ **/
+int ispresizer_set_inaddr(u32 addr)
+{
+       DPRINTK_ISPRESZ("ispresizer_set_inaddr()+\n");
+       if (addr%32)
+               return -EINVAL;
+       omap_writel(addr << ISPRSZ_SDR_INADD_ADDR_SHIFT, ISPRSZ_SDR_INADD);
+       DPRINTK_ISPRESZ("ispresizer_set_inaddr()-\n");
+       return 0;
+}
+EXPORT_SYMBOL(ispresizer_set_inaddr);
+
+/**
+ * ispresizer_config_outlineoffset - Configures the write address line offset.
+ * @offset: Line offset for the preview output.
+ *
+ * Returns 0 if successful, or -EINVAL if address is not 32 bits aligned.
+ **/
+int ispresizer_config_outlineoffset(u32 offset)
+{
+       DPRINTK_ISPRESZ("ispresizer_config_outlineoffset()+\n");
+       if (offset%32)
+               return -EINVAL;
+       omap_writel(offset << ISPRSZ_SDR_OUTOFF_OFFSET_SHIFT,
+                                                       ISPRSZ_SDR_OUTOFF);
+       DPRINTK_ISPRESZ("ispresizer_config_outlineoffset()-\n");
+       return 0;
+}
+EXPORT_SYMBOL(ispresizer_config_outlineoffset);
+
+/**
+ * Configures the memory address to which the output frame is written.
+ * @addr: 32bit memory address aligned on 32byte boundary.
+ **/
+int ispresizer_set_outaddr(u32 addr)
+{
+       DPRINTK_ISPRESZ("ispresizer_set_outaddr()+\n");
+       if (addr%32)
+               return -EINVAL;
+       omap_writel(addr << ISPRSZ_SDR_OUTADD_ADDR_SHIFT, ISPRSZ_SDR_OUTADD);
+
+       DPRINTK_ISPRESZ("ispresizer_set_outaddr()-\n");
+       return 0;
+}
+EXPORT_SYMBOL(ispresizer_set_outaddr);
+
+/**
+ * ispresizer_save_context - Saves the values of the resizer module registers.
+ **/
+void ispresizer_save_context(void)
+{
+       DPRINTK_ISPRESZ("Saving context\n");
+       isp_save_context(isprsz_reg_list);
+}
+EXPORT_SYMBOL(ispresizer_save_context);
+
+/**
+ * ispresizer_restore_context - Restores resizer module register values.
+ **/
+void ispresizer_restore_context(void)
+{
+       DPRINTK_ISPRESZ("Restoring context\n");
+       isp_restore_context(isprsz_reg_list);
+}
+EXPORT_SYMBOL(ispresizer_restore_context);
+
+/**
+ * ispresizer_print_status - Prints the values of the resizer module registers.
+ **/
+void ispresizer_print_status()
+{
+       if (!is_ispresz_debug_enabled())
+               return;
+       DPRINTK_ISPRESZ("###ISP_CTRL inresizer =0x%x\n", omap_readl(ISP_CTRL));
+
+       DPRINTK_ISPRESZ("###ISP_IRQ0ENABLE in resizer =0x%x\n",
+                                               omap_readl(ISP_IRQ0ENABLE));
+       DPRINTK_ISPRESZ("###ISP_IRQ0STATUS in resizer =0x%x\n",
+                                               omap_readl(ISP_IRQ0STATUS));
+       DPRINTK_ISPRESZ("###RSZ PCR =0x%x\n", omap_readl(ISPRSZ_PCR));
+       DPRINTK_ISPRESZ("###RSZ CNT =0x%x\n", omap_readl(ISPRSZ_CNT));
+       DPRINTK_ISPRESZ("###RSZ OUT SIZE =0x%x\n",
+                                               omap_readl(ISPRSZ_OUT_SIZE));
+       DPRINTK_ISPRESZ("###RSZ IN START =0x%x\n",
+                                               omap_readl(ISPRSZ_IN_START));
+       DPRINTK_ISPRESZ("###RSZ IN SIZE =0x%x\n", omap_readl(ISPRSZ_IN_SIZE));
+       DPRINTK_ISPRESZ("###RSZ SDR INADD =0x%x\n",
+                                               omap_readl(ISPRSZ_SDR_INADD));
+       DPRINTK_ISPRESZ("###RSZ SDR INOFF =0x%x\n",
+                                               omap_readl(ISPRSZ_SDR_INOFF));
+       DPRINTK_ISPRESZ("###RSZ SDR OUTADD =0x%x\n",
+                                               omap_readl(ISPRSZ_SDR_OUTADD));
+       DPRINTK_ISPRESZ("###RSZ SDR OTOFF =0x%x\n",
+                                               omap_readl(ISPRSZ_SDR_OUTOFF));
+       DPRINTK_ISPRESZ("###RSZ YENH =0x%x\n", omap_readl(ISPRSZ_YENH));
+}
+EXPORT_SYMBOL(ispresizer_print_status);
+
+/**
+ * isp_resizer_init - Module Initialisation.
+ *
+ * Always returns 0.
+ **/
+int __init isp_resizer_init(void)
+{
+       mutex_init(&ispres_obj.ispres_mutex);
+       return 0;
+}
+
+/**
+ * isp_resizer_cleanup - Module Cleanup.
+ **/
+void __exit isp_resizer_cleanup(void)
+{
+}
Index: linux-omap-2.6/drivers/media/video/isp/ispresizer.h
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/isp/ispresizer.h 2008-08-28 19:08:43.000000000 -0500
@@ -0,0 +1,153 @@
+/*
+ * drivers/media/video/isp/ispresizer.h
+ *
+ * Driver header file for Resizer module in TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments, Inc.
+ *
+ * Contributors:
+ *     Sameer Venkatraman <sameerv@ti.com>
+ *     Mohit Jalori <mjalori@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#ifndef OMAP_ISP_RESIZER_H
+#define OMAP_ISP_RESIZER_H
+
+/*
+ * Resizer Constants
+ */
+#define MAX_IN_WIDTH_MEMORY_MODE       4095
+
+#define MAX_IN_WIDTH_ONTHEFLY_MODE     1280
+#define MAX_IN_WIDTH_ONTHEFLY_MODE_ES2 4095
+#define MAX_IN_HEIGHT                  4095
+#define MINIMUM_RESIZE_VALUE           64
+#define MAXIMUM_RESIZE_VALUE           1024
+#define MID_RESIZE_VALUE               512
+
+#define MAX_7TAP_HRSZ_OUTWIDTH         1280
+#define MAX_7TAP_VRSZ_OUTWIDTH         640
+
+#define MAX_7TAP_HRSZ_OUTWIDTH_ES2     3300
+#define MAX_7TAP_VRSZ_OUTWIDTH_ES2     1650
+
+#define DEFAULTSTPIXEL                 0
+#define DEFAULTSTPHASE                 1
+#define DEFAULTHSTPIXEL4TAPMODE                3
+#define FOURPHASE                      4
+#define EIGHTPHASE                     8
+#define RESIZECONSTANT                 256
+#define SHIFTER4TAPMODE                        0
+#define SHIFTER7TAPMODE                        1
+#define DEFAULTOFFSET                  7
+#define OFFSETVERT4TAPMODE             4
+#define OPWDALIGNCONSTANT              0xFFFFFFF0
+
+/*
+ * The client is supposed to call resizer API in the following sequence:
+ *     - request()
+ *     - config_datatpath()
+ *     - optionally config/enable sub modules
+ *     - try/config size
+ *     - setup callback
+ *     - setup in/out memory offsets and ptrs
+ *     - enable()
+ *     ...
+ *     - disable()
+ *     - free()
+ */
+
+enum ispresizer_input {
+       RSZ_OTFLY_YUV,
+       RSZ_MEM_YUV,
+       RSZ_MEM_COL8
+};
+
+/**
+ * struct isprsz_coef - Structure for resizer filter coeffcients.
+ * @h_filter_coef_4tap: Horizontal filter coefficients for 8-phase/4-tap
+ *                     mode (.5x-4x)
+ * @v_filter_coef_4tap: Vertical filter coefficients for 8-phase/4-tap
+ *                     mode (.5x-4x)
+ * @h_filter_coef_7tap: Horizontal filter coefficients for 4-phase/7-tap
+ *                     mode (.25x-.5x)
+ * @v_filter_coef_7tap: Vertical filter coefficients for 4-phase/7-tap
+ *                     mode (.25x-.5x)
+ */
+struct isprsz_coef {
+       u16 h_filter_coef_4tap[32];
+       u16 v_filter_coef_4tap[32];
+       u16 h_filter_coef_7tap[28];
+       u16 v_filter_coef_7tap[28];
+};
+
+/**
+ * struct isprsz_yenh - Structure for resizer luminance enhancer parameters.
+ * @algo: Algorithm select.
+ * @gain: Maximum gain.
+ * @slope: Slope.
+ * @coreoffset: Coring offset.
+ */
+struct isprsz_yenh {
+       u8 algo;
+       u8 gain;
+       u8 slope;
+       u8 coreoffset;
+};
+
+void ispresizer_config_shadow_registers(void);
+
+int ispresizer_request(void);
+
+int ispresizer_free(void);
+
+int ispresizer_config_datapath(enum ispresizer_input input);
+
+void ispresizer_enable_cbilin(u8 enable);
+
+void ispresizer_config_ycpos(u8 yc);
+
+void ispresizer_config_startphase(u8 hstartphase, u8 vstartphase);
+
+void ispresizer_config_filter_coef(struct isprsz_coef *coef);
+
+void ispresizer_config_luma_enhance(struct isprsz_yenh *yenh);
+
+int ispresizer_try_size(u32 *input_w, u32 *input_h, u32 *output_w,
+                                                               u32 *output_h);
+
+void ispresizer_applycrop(void);
+
+void ispresizer_trycrop(u32 left, u32 top, u32 width, u32 height, u32 ow,
+                                                               u32 oh);
+
+int ispresizer_config_size(u32 input_w, u32 input_h, u32 output_w,
+                                                               u32 output_h);
+
+int ispresizer_config_inlineoffset(u32 offset);
+
+int ispresizer_set_inaddr(u32 addr);
+
+int ispresizer_config_outlineoffset(u32 offset);
+
+int ispresizer_set_outaddr(u32 addr);
+
+void ispresizer_enable(u8 enable);
+
+int ispresizer_busy(void);
+
+void ispresizer_save_context(void);
+
+void ispresizer_restore_context(void);
+
+void ispresizer_print_status(void);
+
+#endif         /* OMAP_ISP_RESIZER_H */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
