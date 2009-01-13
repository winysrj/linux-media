Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:50590 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745AbZAMCDo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2009 21:03:44 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"Nagalla, Hari" <hnagalla@ti.com>
Date: Mon, 12 Jan 2009 20:03:15 -0600
Subject: [REVIEW PATCH 04/14] OMAP: CAM: Add ISP user header and register
 defs
Message-ID: <A24693684029E5489D1D202277BE894416429F9A@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds the defines used by ISP driver (ispreg.h), and the defines
needed by the user to operate ISP in app level (isp_user.h)

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 arch/arm/plat-omap/include/mach/isp_user.h |  668 +++++++++++
 drivers/media/video/isp/ispreg.h           | 1652 ++++++++++++++++++++++++++++
 2 files changed, 2320 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/plat-omap/include/mach/isp_user.h
 create mode 100644 drivers/media/video/isp/ispreg.h

diff --git a/arch/arm/plat-omap/include/mach/isp_user.h b/arch/arm/plat-omap/include/mach/isp_user.h
new file mode 100644
index 0000000..5eb5598
--- /dev/null
+++ b/arch/arm/plat-omap/include/mach/isp_user.h
@@ -0,0 +1,668 @@
+/*
+ * include/asm-arm/arch-omap/isp_user.h
+ *
+ * Include file for OMAP ISP module in TI's OMAP3.
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
+       __u16 saturation_limit;
+       __u16 win_height;
+       __u16 win_width;
+       __u16 ver_win_count;
+       __u16 hor_win_count;
+       __u16 ver_win_start;
+       __u16 hor_win_start;
+       __u16 blk_ver_win_start;
+       __u16 blk_win_height;
+       __u16 subsample_ver_inc;
+       __u16 subsample_hor_inc;
+       __u8 alaw_enable;
+       __u8 aewb_enable;
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
+       __u32 shutter;
+       __u16 gain;
+       __u32 shutter_cap;
+       __u16 gain_cap;
+       __u16 dgain;
+       __u16 wb_gain_b;
+       __u16 wb_gain_r;
+       __u16 wb_gain_gb;
+       __u16 wb_gain_gr;
+       __u16 frame_number;
+       __u16 curr_frame;
+       __u8 update;
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
+       __u8 hist_source;               /* CCDC or Memory */
+       __u8 input_bit_width;   /* Needed o know the size per pixel */
+       __u8 hist_frames;               /* Num of frames to be processed and
+                                * accumulated
+                                */
+       __u8 hist_h_v_info;     /* frame-input width and height if source is
+                                * memory
+                                */
+       __u16 hist_radd;                /* frame-input address in memory */
+       __u16 hist_radd_off;    /* line-offset for frame-input */
+       __u16 hist_bins;        /* number of bins: 32, 64, 128, or 256 */
+       __u16 wb_gain_R;        /* White Balance Field-to-Pattern Assignments */
+       __u16 wb_gain_RG;       /* White Balance Field-to-Pattern Assignments */
+       __u16 wb_gain_B;        /* White Balance Field-to-Pattern Assignments */
+       __u16 wb_gain_BG;       /* White Balance Field-to-Pattern Assignments */
+       __u8 num_regions;               /* number of regions to be configured */
+       __u16 reg0_hor;         /* Region 0 size and position */
+       __u16 reg0_ver;         /* Region 0 size and position */
+       __u16 reg1_hor;         /* Region 1 size and position */
+       __u16 reg1_ver;         /* Region 1 size and position */
+       __u16 reg2_hor;         /* Region 2 size and position */
+       __u16 reg2_ver;         /* Region 2 size and position */
+       __u16 reg3_hor;         /* Region 3 size and position */
+       __u16 reg3_ver;         /* Region 3 size and position */
+};
+
+struct isp_hist_data {
+       __u32 *hist_statistics_buf;     /* Pointer to pass to user */
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
+       __u16 offset;
+       __u8 gain_mode_n;
+       __u8 gain_mode_m;
+       __u8 gain_format;
+       __u16 fmtsph;
+       __u16 fmtlnh;
+       __u16 fmtslv;
+       __u16 fmtlnv;
+       __u8 initial_x;
+       __u8 initial_y;
+       __u32 size;
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
+       __u8 obgain;
+       __u8 obstpixel;
+       __u8 oblines;
+       __u8 oblen;
+       __u16 dcsubval;
+};
+
+/**
+ * ispccdc_fpc - Structure for FPC
+ * @fpnum: Number of faulty pixels to be corrected in the frame.
+ * @fpcaddr: Memory address of the FPC Table
+ */
+struct ispccdc_fpc {
+       __u16 fpnum;
+       __u32 fpcaddr;
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
+       __u8 b_mg;
+       __u8 gb_g;
+       __u8 gr_cy;
+       __u8 r_ye;
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
+       __u8 v_pattern;
+       __u16 h_odd;
+       __u16 h_even;
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
+       __u16 update;
+       __u16 flag;
+       enum alaw_ipwidth alawip;
+       struct ispccdc_bclamp *bclamp;
+       struct ispccdc_blcomp *blcomp;
+       struct ispccdc_fpc *fpc;
+       struct ispccdc_lsc_config *lsc_cfg;
+       struct ispccdc_culling *cull;
+       __u32 colptn;
+       __u8 *lsc;
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
+       __u8 odddist;
+       __u8 evendist;
+       __u8 thres;
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
+       __u8 cfa_gradthrs_vert;
+       __u8 cfa_gradthrs_horz;
+       __u32 *cfa_table;
+};
+
+/**
+ * struct ispprev_csup - Structure for Chrominance Suppression.
+ * @gain: Gain.
+ * @thres: Threshold.
+ * @hypf_en: Flag to enable/disable the High Pass Filter.
+ */
+struct ispprev_csup {
+       __u8 gain;
+       __u8 thres;
+       __u8 hypf_en;
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
+       __u16 dgain;
+       __u8 coef3;
+       __u8 coef2;
+       __u8 coef1;
+       __u8 coef0;
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
+       __u8 red;
+       /*Black level offset adjustment for Green in 2's complement format */
+       __u8 green;
+       /* Black level offset adjustment for Blue in 2's complement format */
+       __u8 blue;
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
+       __u16 matrix[3][3];
+       __u16 offset[3];
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
+       __u16 matrix[RGB_MAX][RGB_MAX];
+       __s16 offset[RGB_MAX];
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
+       __u8 minC;
+       __u8 maxC;
+       __u8 minY;
+       __u8 maxY;
+};
+
+/**
+ * struct ispprev_dcor - Structure for Defect correction.
+ * @couplet_mode_en: Flag to enable or disable the couplet dc Correction in NF
+ * @detect_correct: Thresholds for correction bit 0:10 detect 16:25 correct
+ */
+struct ispprev_dcor {
+       __u8 couplet_mode_en;
+       __u32 detect_correct[4];
+};
+
+/**
+ * struct ispprev_nf - Structure for Noise Filter
+ * @spread: Spread value to be used in Noise Filter
+ * @table: Pointer to the Noise Filter table
+ */
+struct ispprev_nf {
+       __u8 spread;
+       __u32 table[64];
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
+       __u16 update;
+       __u16 flag;
+       void *yen;
+       __u32 shading_shift;
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
+       __u32 *red_gamma;
+       __u32 *green_gamma;
+       __u32 *blue_gamma;
+};
+
+#endif /* OMAP_ISP_USER_H */
diff --git a/drivers/media/video/isp/ispreg.h b/drivers/media/video/isp/ispreg.h
new file mode 100644
index 0000000..7be09d9
--- /dev/null
+++ b/drivers/media/video/isp/ispreg.h
@@ -0,0 +1,1652 @@
+/*
+ * drivers/media/video/isp/ispreg.h
+ *
+ * Header file for all the ISP module in TI's OMAP3 Camera ISP.
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
+#include <mach/omap34xx.h>
+
+#if 0
+#define OMAP_ISPCTRL_DEBUG
+#define OMAP_ISPCCDC_DEBUG
+#define OMAP_ISPPREV_DEBUG
+#define OMAP_ISPRESZ_DEBUG
+#define OMAP_ISPMMU_DEBUG
+#define OMAP_ISPH3A_DEBUG
+#define OMAP_ISP_AF_DEBUG
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
+#ifdef OMAP_ISP_AF_DEBUG
+#define DPRINTK_ISP_AF(format, ...)\
+       printk(KERN_INFO "ISP_AF: " format, ## __VA_ARGS__)
+#define is_isp_af_debug_enabled()              1
+#else
+#define DPRINTK_ISP_AF(format, ...)
+#define is_isp_af_debug_enabled()              0
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
+#define CONTROL_CSIRXFE                        (L4_34XX_BASE + 0x22DC)
+#define CONTROL_CSI                    (L4_34XX_BASE + 0x2530)
+
+#define CM_CAM_MCLK_HZ                 216000000
+
+/* ISP Submodules offset */
+
+#define OMAP3ISP_REG_BASE              OMAP3_ISP_BASE
+#define OMAP3ISP_REG(offset)           (OMAP3ISP_REG_BASE + (offset))
+
+#define OMAP3ISP_CBUFF_REG_OFFSET      0x0100
+#define OMAP3ISP_CBUFF_REG_BASE                (OMAP3ISP_REG_BASE + OMAP3ISP_CBUFF_REG_OFFSET)
+#define OMAP3ISP_CBUFF_REG(offset)     (OMAP3ISP_CBUFF_REG_BASE + (offset))
+
+#define OMAP3ISP_CCP2_REG_OFFSET       0x0400
+#define OMAP3ISP_CCP2_REG_BASE         (OMAP3ISP_REG_BASE + OMAP3ISP_CCP2_REG_OFFSET)
+#define OMAP3ISP_CCP2_REG(offset)      (OMAP3ISP_CCP2_REG_BASE + (offset))
+
+#define OMAP3ISP_CCDC_REG_OFFSET       0x0600
+#define OMAP3ISP_CCDC_REG_BASE         (OMAP3ISP_REG_BASE + OMAP3ISP_CCDC_REG_OFFSET)
+#define OMAP3ISP_CCDC_REG(offset)      (OMAP3ISP_CCDC_REG_BASE + (offset))
+
+#define OMAP3ISP_HIST_REG_OFFSET       0x0A00
+#define OMAP3ISP_HIST_REG_BASE         (OMAP3ISP_REG_BASE + OMAP3ISP_HIST_REG_OFFSET)
+#define OMAP3ISP_HIST_REG(offset)      (OMAP3ISP_HIST_REG_BASE + (offset))
+
+#define OMAP3ISP_H3A_REG_OFFSET                0x0C00
+#define OMAP3ISP_H3A_REG_BASE          (OMAP3ISP_REG_BASE + OMAP3ISP_H3A_REG_OFFSET)
+#define OMAP3ISP_H3A_REG(offset)       (OMAP3ISP_H3A_REG_BASE + (offset))
+
+#define OMAP3ISP_PREV_REG_OFFSET       0x0E00
+#define OMAP3ISP_PREV_REG_BASE         (OMAP3ISP_REG_BASE + OMAP3ISP_PREV_REG_OFFSET)
+#define OMAP3ISP_PREV_REG(offset)      (OMAP3ISP_PREV_REG_BASE + (offset))
+
+#define OMAP3ISP_RESZ_REG_OFFSET       0x1000
+#define OMAP3ISP_RESZ_REG_BASE         (OMAP3ISP_REG_BASE + OMAP3ISP_RESZ_REG_OFFSET)
+#define OMAP3ISP_RESZ_REG(offset)      (OMAP3ISP_RESZ_REG_BASE + (offset))
+
+#define OMAP3ISP_SBL_REG_OFFSET                0x1200
+#define OMAP3ISP_SBL_REG_BASE          (OMAP3ISP_REG_BASE + OMAP3ISP_SBL_REG_OFFSET)
+#define OMAP3ISP_SBL_REG(offset)       (OMAP3ISP_SBL_REG_BASE + (offset))
+
+#define OMAP3ISP_MMU_REG_OFFSET                0x1400
+#define OMAP3ISP_MMU_REG_BASE          (OMAP3ISP_REG_BASE + OMAP3ISP_MMU_REG_OFFSET)
+#define OMAP3ISP_MMU_REG(offset)       (OMAP3ISP_MMU_REG_BASE + (offset))
+
+#define OMAP3ISP_CSI2A_REG_OFFSET      0x1800
+#define OMAP3ISP_CSI2A_REG_BASE                (OMAP3ISP_REG_BASE + OMAP3ISP_CSI2A_REG_OFFSET)
+#define OMAP3ISP_CSI2A_REG(offset)     (OMAP3ISP_CSI2A_REG_BASE + (offset))
+
+#define OMAP3ISP_CSI2PHY_REG_OFFSET    0x1970
+#define OMAP3ISP_CSI2PHY_REG_BASE      (OMAP3ISP_REG_BASE + OMAP3ISP_CSI2PHY_REG_OFFSET)
+#define OMAP3ISP_CSI2PHY_REG(offset)   (OMAP3ISP_CSI2PHY_REG_BASE + (offset))
+
+/* ISP module register offset */
+
+#define ISP_REVISION                   (0x000)
+#define ISP_SYSCONFIG                  (0x004)
+#define ISP_SYSSTATUS                  (0x008)
+#define ISP_IRQ0ENABLE                 (0x00C)
+#define ISP_IRQ0STATUS                 (0x010)
+#define ISP_IRQ1ENABLE                 (0x014)
+#define ISP_IRQ1STATUS                 (0x018)
+#define ISP_TCTRL_GRESET_LENGTH                (0x030)
+#define ISP_TCTRL_PSTRB_REPLAY         (0x034)
+#define ISP_CTRL                       (0x040)
+#define ISP_SECURE                     (0x044)
+#define ISP_TCTRL_CTRL                 (0x050)
+#define ISP_TCTRL_FRAME                        (0x054)
+#define ISP_TCTRL_PSTRB_DELAY          (0x058)
+#define ISP_TCTRL_STRB_DELAY           (0x05C)
+#define ISP_TCTRL_SHUT_DELAY           (0x060)
+#define ISP_TCTRL_PSTRB_LENGTH         (0x064)
+#define ISP_TCTRL_STRB_LENGTH          (0x068)
+#define ISP_TCTRL_SHUT_LENGTH          (0x06C)
+#define ISP_PING_PONG_ADDR             (0x070)
+#define ISP_PING_PONG_MEM_RANGE                (0x074)
+#define ISP_PING_PONG_BUF_SIZE         (0x078)
+
+/* CSI1 receiver registers (ES2.0) */
+#define ISPCSI1_REVISION               (0x000)
+#define ISPCSI1_SYSCONFIG              (0x004)
+#define ISPCSI1_SYSSTATUS              (0x008)
+#define ISPCSI1_LC01_IRQENABLE         (0x00C)
+#define ISPCSI1_LC01_IRQSTATUS         (0x010)
+#define ISPCSI1_LC23_IRQENABLE         (0x014)
+#define ISPCSI1_LC23_IRQSTATUS         (0x018)
+#define ISPCSI1_LCM_IRQENABLE          (0x02C)
+#define ISPCSI1_LCM_IRQSTATUS          (0x030)
+#define ISPCSI1_CTRL                   (0x040)
+#define ISPCSI1_DBG                    (0x044)
+#define ISPCSI1_GNQ                    (0x048)
+#define ISPCSI1_LCx_CTRL(x)            ((0x050)+0x30*(x))
+#define ISPCSI1_LCx_CODE(x)            ((0x054)+0x30*(x))
+#define ISPCSI1_LCx_STAT_START(x)      ((0x058)+0x30*(x))
+#define ISPCSI1_LCx_STAT_SIZE(x)       ((0x05C)+0x30*(x))
+#define ISPCSI1_LCx_SOF_ADDR(x)                ((0x060)+0x30*(x))
+#define ISPCSI1_LCx_EOF_ADDR(x)                ((0x064)+0x30*(x))
+#define ISPCSI1_LCx_DAT_START(x)       ((0x068)+0x30*(x))
+#define ISPCSI1_LCx_DAT_SIZE(x)                ((0x06C)+0x30*(x))
+#define ISPCSI1_LCx_DAT_PING_ADDR(x)   ((0x070)+0x30*(x))
+#define ISPCSI1_LCx_DAT_PONG_ADDR(x)   ((0x074)+0x30*(x))
+#define ISPCSI1_LCx_DAT_OFST(x)                ((0x078)+0x30*(x))
+#define ISPCSI1_LCM_CTRL               (0x1D0)
+#define ISPCSI1_LCM_VSIZE              (0x1D4)
+#define ISPCSI1_LCM_HSIZE              (0x1D8)
+#define ISPCSI1_LCM_PREFETCH           (0x1DC)
+#define ISPCSI1_LCM_SRC_ADDR           (0x1E0)
+#define ISPCSI1_LCM_SRC_OFST           (0x1E4)
+#define ISPCSI1_LCM_DST_ADDR           (0x1E8)
+#define ISPCSI1_LCM_DST_OFST           (0x1EC)
+#define ISP_CSIB_SYSCONFIG             ISPCSI1_SYSCONFIG
+#define ISP_CSIA_SYSCONFIG             ISPCSI2_SYSCONFIG
+
+/* ISP_CBUFF Registers */
+
+#define ISP_CBUFF_SYSCONFIG            (0x010)
+#define ISP_CBUFF_IRQENABLE            (0x01C)
+
+#define ISP_CBUFF0_CTRL                        (0x020)
+#define ISP_CBUFF1_CTRL                        (0x024)
+
+#define ISP_CBUFF0_START               (0x040)
+#define ISP_CBUFF1_START               (0x044)
+
+#define ISP_CBUFF0_END                 (0x050)
+#define ISP_CBUFF1_END                 (0x054)
+
+#define ISP_CBUFF0_WINDOWSIZE          (0x060)
+#define ISP_CBUFF1_WINDOWSIZE          (0x064)
+
+#define ISP_CBUFF0_THRESHOLD           (0x070)
+#define ISP_CBUFF1_THRESHOLD           (0x074)
+
+/* CCDC module register offset */
+
+#define ISPCCDC_PID                    (0x000)
+#define ISPCCDC_PCR                    (0x004)
+#define ISPCCDC_SYN_MODE               (0x008)
+#define ISPCCDC_HD_VD_WID              (0x00C)
+#define ISPCCDC_PIX_LINES              (0x010)
+#define ISPCCDC_HORZ_INFO              (0x014)
+#define ISPCCDC_VERT_START             (0x018)
+#define ISPCCDC_VERT_LINES             (0x01C)
+#define ISPCCDC_CULLING                        (0x020)
+#define ISPCCDC_HSIZE_OFF              (0x024)
+#define ISPCCDC_SDOFST                 (0x028)
+#define ISPCCDC_SDR_ADDR               (0x02C)
+#define ISPCCDC_CLAMP                  (0x030)
+#define ISPCCDC_DCSUB                  (0x034)
+#define ISPCCDC_COLPTN                 (0x038)
+#define ISPCCDC_BLKCMP                 (0x03C)
+#define ISPCCDC_FPC                    (0x040)
+#define ISPCCDC_FPC_ADDR               (0x044)
+#define ISPCCDC_VDINT                  (0x048)
+#define ISPCCDC_ALAW                   (0x04C)
+#define ISPCCDC_REC656IF               (0x050)
+#define ISPCCDC_CFG                    (0x054)
+#define ISPCCDC_FMTCFG                 (0x058)
+#define ISPCCDC_FMT_HORZ               (0x05C)
+#define ISPCCDC_FMT_VERT               (0x060)
+#define ISPCCDC_FMT_ADDR0              (0x064)
+#define ISPCCDC_FMT_ADDR1              (0x068)
+#define ISPCCDC_FMT_ADDR2              (0x06C)
+#define ISPCCDC_FMT_ADDR3              (0x070)
+#define ISPCCDC_FMT_ADDR4              (0x074)
+#define ISPCCDC_FMT_ADDR5              (0x078)
+#define ISPCCDC_FMT_ADDR6              (0x07C)
+#define ISPCCDC_FMT_ADDR7              (0x080)
+#define ISPCCDC_PRGEVEN0               (0x084)
+#define ISPCCDC_PRGEVEN1               (0x088)
+#define ISPCCDC_PRGODD0                        (0x08C)
+#define ISPCCDC_PRGODD1                        (0x090)
+#define ISPCCDC_VP_OUT                 (0x094)
+
+#define ISPCCDC_LSC_CONFIG             (0x098)
+#define ISPCCDC_LSC_INITIAL            (0x09C)
+#define ISPCCDC_LSC_TABLE_BASE         (0x0A0)
+#define ISPCCDC_LSC_TABLE_OFFSET       (0x0A4)
+
+/* Histogram registers */
+#define ISPHIST_PID                    (0x000)
+#define ISPHIST_PCR                    (0x004)
+#define ISPHIST_CNT                    (0x008)
+#define ISPHIST_WB_GAIN                        (0x00C)
+#define ISPHIST_R0_HORZ                        (0x010)
+#define ISPHIST_R0_VERT                        (0x014)
+#define ISPHIST_R1_HORZ                        (0x018)
+#define ISPHIST_R1_VERT                        (0x01C)
+#define ISPHIST_R2_HORZ                        (0x020)
+#define ISPHIST_R2_VERT                        (0x024)
+#define ISPHIST_R3_HORZ                        (0x028)
+#define ISPHIST_R3_VERT                        (0x02C)
+#define ISPHIST_ADDR                   (0x030)
+#define ISPHIST_DATA                   (0x034)
+#define ISPHIST_RADD                   (0x038)
+#define ISPHIST_RADD_OFF               (0x03C)
+#define ISPHIST_H_V_INFO               (0x040)
+
+/* H3A module registers */
+#define ISPH3A_PID                     (0x000)
+#define ISPH3A_PCR                     (0x004)
+#define ISPH3A_AEWWIN1                 (0x04C)
+#define ISPH3A_AEWINSTART              (0x050)
+#define ISPH3A_AEWINBLK                        (0x054)
+#define ISPH3A_AEWSUBWIN               (0x058)
+#define ISPH3A_AEWBUFST                        (0x05C)
+#define ISPH3A_AFPAX1                  (0x008)
+#define ISPH3A_AFPAX2                  (0x00C)
+#define ISPH3A_AFPAXSTART              (0x010)
+#define ISPH3A_AFIIRSH                 (0x014)
+#define ISPH3A_AFBUFST                 (0x018)
+#define ISPH3A_AFCOEF010               (0x01C)
+#define ISPH3A_AFCOEF032               (0x020)
+#define ISPH3A_AFCOEF054               (0x024)
+#define ISPH3A_AFCOEF076               (0x028)
+#define ISPH3A_AFCOEF098               (0x02C)
+#define ISPH3A_AFCOEF0010              (0x030)
+#define ISPH3A_AFCOEF110               (0x034)
+#define ISPH3A_AFCOEF132               (0x038)
+#define ISPH3A_AFCOEF154               (0x03C)
+#define ISPH3A_AFCOEF176               (0x040)
+#define ISPH3A_AFCOEF198               (0x044)
+#define ISPH3A_AFCOEF1010              (0x048)
+
+#define ISPPRV_PCR                     (0x004)
+#define ISPPRV_HORZ_INFO               (0x008)
+#define ISPPRV_VERT_INFO               (0x00C)
+#define ISPPRV_RSDR_ADDR               (0x010)
+#define ISPPRV_RADR_OFFSET             (0x014)
+#define ISPPRV_DSDR_ADDR               (0x018)
+#define ISPPRV_DRKF_OFFSET             (0x01C)
+#define ISPPRV_WSDR_ADDR               (0x020)
+#define ISPPRV_WADD_OFFSET             (0x024)
+#define ISPPRV_AVE                     (0x028)
+#define ISPPRV_HMED                    (0x02C)
+#define ISPPRV_NF                      (0x030)
+#define ISPPRV_WB_DGAIN                        (0x034)
+#define ISPPRV_WBGAIN                  (0x038)
+#define ISPPRV_WBSEL                   (0x03C)
+#define ISPPRV_CFA                     (0x040)
+#define ISPPRV_BLKADJOFF               (0x044)
+#define ISPPRV_RGB_MAT1                        (0x048)
+#define ISPPRV_RGB_MAT2                        (0x04C)
+#define ISPPRV_RGB_MAT3                        (0x050)
+#define ISPPRV_RGB_MAT4                        (0x054)
+#define ISPPRV_RGB_MAT5                        (0x058)
+#define ISPPRV_RGB_OFF1                        (0x05C)
+#define ISPPRV_RGB_OFF2                        (0x060)
+#define ISPPRV_CSC0                    (0x064)
+#define ISPPRV_CSC1                    (0x068)
+#define ISPPRV_CSC2                    (0x06C)
+#define ISPPRV_CSC_OFFSET              (0x070)
+#define ISPPRV_CNT_BRT                 (0x074)
+#define ISPPRV_CSUP                    (0x078)
+#define ISPPRV_SETUP_YC                        (0x07C)
+#define ISPPRV_SET_TBL_ADDR            (0x080)
+#define ISPPRV_SET_TBL_DATA            (0x084)
+#define ISPPRV_CDC_THR0                        (0x090)
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
+#define ISPRSZ_MIN_OUTPUT              64
+#define ISPRSZ_MAX_OUTPUT              3312
+
+/* Resizer module register offset */
+#define ISPRSZ_PID                     (0x000)
+#define ISPRSZ_PCR                     (0x004)
+#define ISPRSZ_CNT                     (0x008)
+#define ISPRSZ_OUT_SIZE                        (0x00C)
+#define ISPRSZ_IN_START                        (0x010)
+#define ISPRSZ_IN_SIZE                 (0x014)
+#define ISPRSZ_SDR_INADD               (0x018)
+#define ISPRSZ_SDR_INOFF               (0x01C)
+#define ISPRSZ_SDR_OUTADD              (0x020)
+#define ISPRSZ_SDR_OUTOFF              (0x024)
+#define ISPRSZ_HFILT10                 (0x028)
+#define ISPRSZ_HFILT32                 (0x02C)
+#define ISPRSZ_HFILT54                 (0x030)
+#define ISPRSZ_HFILT76                 (0x034)
+#define ISPRSZ_HFILT98                 (0x038)
+#define ISPRSZ_HFILT1110               (0x03C)
+#define ISPRSZ_HFILT1312               (0x040)
+#define ISPRSZ_HFILT1514               (0x044)
+#define ISPRSZ_HFILT1716               (0x048)
+#define ISPRSZ_HFILT1918               (0x04C)
+#define ISPRSZ_HFILT2120               (0x050)
+#define ISPRSZ_HFILT2322               (0x054)
+#define ISPRSZ_HFILT2524               (0x058)
+#define ISPRSZ_HFILT2726               (0x05C)
+#define ISPRSZ_HFILT2928               (0x060)
+#define ISPRSZ_HFILT3130               (0x064)
+#define ISPRSZ_VFILT10                 (0x068)
+#define ISPRSZ_VFILT32                 (0x06C)
+#define ISPRSZ_VFILT54                 (0x070)
+#define ISPRSZ_VFILT76                 (0x074)
+#define ISPRSZ_VFILT98                 (0x078)
+#define ISPRSZ_VFILT1110               (0x07C)
+#define ISPRSZ_VFILT1312               (0x080)
+#define ISPRSZ_VFILT1514               (0x084)
+#define ISPRSZ_VFILT1716               (0x088)
+#define ISPRSZ_VFILT1918               (0x08C)
+#define ISPRSZ_VFILT2120               (0x090)
+#define ISPRSZ_VFILT2322               (0x094)
+#define ISPRSZ_VFILT2524               (0x098)
+#define ISPRSZ_VFILT2726               (0x09C)
+#define ISPRSZ_VFILT2928               (0x0A0)
+#define ISPRSZ_VFILT3130               (0x0A4)
+#define ISPRSZ_YENH                    (0x0A8)
+
+/* MMU module registers */
+#define ISPMMU_REVISION                        (0x000)
+#define ISPMMU_SYSCONFIG               (0x010)
+#define ISPMMU_SYSSTATUS               (0x014)
+#define ISPMMU_IRQSTATUS               (0x018)
+#define ISPMMU_IRQENABLE               (0x01C)
+#define ISPMMU_WALKING_ST              (0x040)
+#define ISPMMU_CNTL                    (0x044)
+#define ISPMMU_FAULT_AD                        (0x048)
+#define ISPMMU_TTB                     (0x04C)
+#define ISPMMU_LOCK                    (0x050)
+#define ISPMMU_LD_TLB                  (0x054)
+#define ISPMMU_CAM                     (0x058)
+#define ISPMMU_RAM                     (0x05C)
+#define ISPMMU_GFLUSH                  (0x060)
+#define ISPMMU_FLUSH_ENTRY             (0x064)
+#define ISPMMU_READ_CAM                        (0x068)
+#define ISPMMU_READ_RAM                        (0x06c)
+#define ISPMMU_EMU_FAULT_AD            (0x070)
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
+#define ISPCTRL_SYNC_DETECT_MASK       (0x3 << ISPCTRL_SYNC_DETECT_SHIFT)
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
+#define ISPCCDC_BLKCMP_GR_CY_SHIFT             16
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
+#define ISPCCDC_CFG_WENLOG_AND                 (0 << 8)
+#define ISPCCDC_CFG_WENLOG_OR          (1 << 8)
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
+/* CSI2 receiver registers (ES2.0) */
+#define ISPCSI2_REVISION                       (0x000)
+#define ISPCSI2_SYSCONFIG                      (0x010)
+#define ISPCSI2_SYSCONFIG_MSTANDBY_MODE_SHIFT  12
+#define ISPCSI2_SYSCONFIG_MSTANDBY_MODE_MASK \
+                               (0x3 << ISPCSI2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
+#define ISPCSI2_SYSCONFIG_MSTANDBY_MODE_FORCE \
+                               (0x0 << ISPCSI2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
+#define ISPCSI2_SYSCONFIG_MSTANDBY_MODE_NO \
+                               (0x1 << ISPCSI2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
+#define ISPCSI2_SYSCONFIG_MSTANDBY_MODE_SMART \
+                               (0x2 << ISPCSI2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
+#define ISPCSI2_SYSCONFIG_SOFT_RESET_SHIFT     1
+#define ISPCSI2_SYSCONFIG_SOFT_RESET_MASK \
+                               (0x1 << ISPCSI2_SYSCONFIG_SOFT_RESET_SHIFT)
+#define ISPCSI2_SYSCONFIG_SOFT_RESET_NORMAL \
+                               (0x0 << ISPCSI2_SYSCONFIG_SOFT_RESET_SHIFT)
+#define ISPCSI2_SYSCONFIG_SOFT_RESET_RESET \
+                               (0x1 << ISPCSI2_SYSCONFIG_SOFT_RESET_SHIFT)
+#define ISPCSI2_SYSCONFIG_AUTO_IDLE_SHIFT      0
+#define ISPCSI2_SYSCONFIG_AUTO_IDLE_MASK \
+                               (0x1 << ISPCSI2_SYSCONFIG_AUTO_IDLE_SHIFT)
+#define ISPCSI2_SYSCONFIG_AUTO_IDLE_FREE \
+                               (0x0 << ISPCSI2_SYSCONFIG_AUTO_IDLE_SHIFT)
+#define ISPCSI2_SYSCONFIG_AUTO_IDLE_AUTO \
+                               (0x1 << ISPCSI2_SYSCONFIG_AUTO_IDLE_SHIFT)
+#define ISPCSI2_SYSSTATUS                      (0x014)
+#define ISPCSI2_SYSSTATUS_RESET_DONE_SHIFT     0
+#define ISPCSI2_SYSSTATUS_RESET_DONE_MASK \
+                               (0x1 << ISPCSI2_SYSSTATUS_RESET_DONE_SHIFT)
+#define ISPCSI2_SYSSTATUS_RESET_DONE_ONGOING \
+                               (0x0 << ISPCSI2_SYSSTATUS_RESET_DONE_SHIFT)
+#define ISPCSI2_SYSSTATUS_RESET_DONE_DONE \
+                               (0x1 << ISPCSI2_SYSSTATUS_RESET_DONE_SHIFT)
+#define ISPCSI2_IRQSTATUS                              (0x018)
+#define ISPCSI2_IRQSTATUS_OCP_ERR_IRQ                  (1 << 14)
+#define ISPCSI2_IRQSTATUS_SHORT_PACKET_IRQ             (1 << 13)
+#define ISPCSI2_IRQSTATUS_ECC_CORRECTION_IRQ           (1 << 12)
+#define ISPCSI2_IRQSTATUS_ECC_NO_CORRECTION_IRQ                (1 << 11)
+#define ISPCSI2_IRQSTATUS_COMPLEXIO2_ERR_IRQ           (1 << 10)
+#define ISPCSI2_IRQSTATUS_COMPLEXIO1_ERR_IRQ           (1 << 9)
+#define ISPCSI2_IRQSTATUS_FIFO_OVF_IRQ                 (1 << 8)
+#define ISPCSI2_IRQSTATUS_CONTEXT(n)                   (1 << (n))
+
+#define ISPCSI2_IRQENABLE                      (0x01C)
+#define ISPCSI2_CTRL                           (0x040)
+#define ISPCSI2_CTRL_VP_CLK_EN_SHIFT   15
+#define ISPCSI2_CTRL_VP_CLK_EN_MASK    (0x1 << ISPCSI2_CTRL_VP_CLK_EN_SHIFT)
+#define ISPCSI2_CTRL_VP_CLK_EN_DISABLE (0x0 << ISPCSI2_CTRL_VP_CLK_EN_SHIFT)
+#define ISPCSI2_CTRL_VP_CLK_EN_ENABLE  (0x1 << ISPCSI2_CTRL_VP_CLK_EN_SHIFT)
+
+#define ISPCSI2_CTRL_VP_ONLY_EN_SHIFT  11
+#define ISPCSI2_CTRL_VP_ONLY_EN_MASK   (0x1 << ISPCSI2_CTRL_VP_ONLY_EN_SHIFT)
+#define ISPCSI2_CTRL_VP_ONLY_EN_DISABLE        (0x0 << ISPCSI2_CTRL_VP_ONLY_EN_SHIFT)
+#define ISPCSI2_CTRL_VP_ONLY_EN_ENABLE (0x1 << ISPCSI2_CTRL_VP_ONLY_EN_SHIFT)
+
+#define ISPCSI2_CTRL_VP_OUT_CTRL_SHIFT         8
+#define ISPCSI2_CTRL_VP_OUT_CTRL_MASK          (0x3 << \
+                                               ISPCSI2_CTRL_VP_OUT_CTRL_SHIFT)
+#define ISPCSI2_CTRL_VP_OUT_CTRL_DISABLE       (0x0 << \
+                                               ISPCSI2_CTRL_VP_OUT_CTRL_SHIFT)
+#define ISPCSI2_CTRL_VP_OUT_CTRL_DIV2          (0x1 << \
+                                               ISPCSI2_CTRL_VP_OUT_CTRL_SHIFT)
+#define ISPCSI2_CTRL_VP_OUT_CTRL_DIV3          (0x2 << \
+                                               ISPCSI2_CTRL_VP_OUT_CTRL_SHIFT)
+#define ISPCSI2_CTRL_VP_OUT_CTRL_DIV4          (0x3 << \
+                                               ISPCSI2_CTRL_VP_OUT_CTRL_SHIFT)
+
+#define ISPCSI2_CTRL_DBG_EN_SHIFT      7
+#define ISPCSI2_CTRL_DBG_EN_MASK       (0x1 << ISPCSI2_CTRL_DBG_EN_SHIFT)
+#define ISPCSI2_CTRL_DBG_EN_DISABLE    (0x0 << ISPCSI2_CTRL_DBG_EN_SHIFT)
+#define ISPCSI2_CTRL_DBG_EN_ENABLE     (0x1 << ISPCSI2_CTRL_DBG_EN_SHIFT)
+
+#define ISPCSI2_CTRL_BURST_SIZE_SHIFT          5
+#define ISPCSI2_CTRL_BURST_SIZE_MASK           (0x3 << \
+                                               ISPCSI2_CTRL_BURST_SIZE_SHIFT)
+#define ISPCSI2_CTRL_BURST_SIZE_MYSTERY_VAL            (0x2 << \
+                                               ISPCSI2_CTRL_BURST_SIZE_SHIFT)
+
+#define ISPCSI2_CTRL_FRAME_SHIFT       3
+#define ISPCSI2_CTRL_FRAME_MASK                (0x1 << ISPCSI2_CTRL_FRAME_SHIFT)
+#define ISPCSI2_CTRL_FRAME_DISABLE_IMM (0x0 << ISPCSI2_CTRL_FRAME_SHIFT)
+#define ISPCSI2_CTRL_FRAME_DISABLE_FEC (0x1 << ISPCSI2_CTRL_FRAME_SHIFT)
+
+#define ISPCSI2_CTRL_ECC_EN_SHIFT      2
+#define ISPCSI2_CTRL_ECC_EN_MASK       (0x1 << ISPCSI2_CTRL_ECC_EN_SHIFT)
+#define ISPCSI2_CTRL_ECC_EN_DISABLE    (0x0 << ISPCSI2_CTRL_ECC_EN_SHIFT)
+#define ISPCSI2_CTRL_ECC_EN_ENABLE     (0x1 << ISPCSI2_CTRL_ECC_EN_SHIFT)
+
+#define ISPCSI2_CTRL_SECURE_SHIFT      1
+#define ISPCSI2_CTRL_SECURE_MASK       (0x1 << ISPCSI2_CTRL_SECURE_SHIFT)
+#define ISPCSI2_CTRL_SECURE_DISABLE    (0x0 << ISPCSI2_CTRL_SECURE_SHIFT)
+#define ISPCSI2_CTRL_SECURE_ENABLE     (0x1 << ISPCSI2_CTRL_SECURE_SHIFT)
+
+#define ISPCSI2_CTRL_IF_EN_SHIFT       0
+#define ISPCSI2_CTRL_IF_EN_MASK                (0x1 << ISPCSI2_CTRL_IF_EN_SHIFT)
+#define ISPCSI2_CTRL_IF_EN_DISABLE     (0x0 << ISPCSI2_CTRL_IF_EN_SHIFT)
+#define ISPCSI2_CTRL_IF_EN_ENABLE      (0x1 << ISPCSI2_CTRL_IF_EN_SHIFT)
+
+#define ISPCSI2_DBG_H                          (0x044)
+#define ISPCSI2_GNQ                            (0x048)
+#define ISPCSI2_COMPLEXIO_CFG1                 (0x050)
+#define ISPCSI2_COMPLEXIO_CFG1_RESET_DONE_SHIFT                29
+#define ISPCSI2_COMPLEXIO_CFG1_RESET_DONE_MASK \
+                       (0x1 << ISPCSI2_COMPLEXIO_CFG1_RESET_DONE_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_RESET_DONE_ONGOING \
+                       (0x0 << ISPCSI2_COMPLEXIO_CFG1_RESET_DONE_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_RESET_DONE_DONE \
+                       (0x1 << ISPCSI2_COMPLEXIO_CFG1_RESET_DONE_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_CMD_SHIFT           27
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_CMD_MASK \
+                       (0x3 << ISPCSI2_COMPLEXIO_CFG1_PWR_CMD_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_CMD_OFF \
+                       (0x0 << ISPCSI2_COMPLEXIO_CFG1_PWR_CMD_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_CMD_ON \
+                       (0x1 << ISPCSI2_COMPLEXIO_CFG1_PWR_CMD_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_CMD_ULPW \
+                       (0x2 << ISPCSI2_COMPLEXIO_CFG1_PWR_CMD_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_STATUS_SHIFT                25
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_STATUS_MASK \
+                       (0x3 << ISPCSI2_COMPLEXIO_CFG1_PWR_STATUS_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_STATUS_OFF \
+                       (0x0 << ISPCSI2_COMPLEXIO_CFG1_PWR_STATUS_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_STATUS_ON \
+                       (0x1 << ISPCSI2_COMPLEXIO_CFG1_PWR_STATUS_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_STATUS_ULPW \
+                       (0x2 << ISPCSI2_COMPLEXIO_CFG1_PWR_STATUS_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_AUTO_SHIFT          24
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_AUTO_MASK \
+                       (0x1 << ISPCSI2_COMPLEXIO_CFG1_PWR_AUTO_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_AUTO_DISABLE \
+                       (0x0 << ISPCSI2_COMPLEXIO_CFG1_PWR_AUTO_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_AUTO_ENABLE \
+                       (0x1 << ISPCSI2_COMPLEXIO_CFG1_PWR_AUTO_SHIFT)
+
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POL_SHIFT(n)       (3 + ((n) * 4))
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POL_MASK(n) (0x1 << \
+                               ISPCSI2_COMPLEXIO_CFG1_DATA_POL_SHIFT(n))
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POL_PN(n) (0x0 << \
+                               ISPCSI2_COMPLEXIO_CFG1_DATA_POL_SHIFT(n))
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POL_NP(n) (0x1 << \
+                               ISPCSI2_COMPLEXIO_CFG1_DATA_POL_SHIFT(n))
+
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_SHIFT(n)  ((n) * 4)
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_MASK(n)   (0x7 << \
+                               ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_SHIFT(n))
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_NC(n)     (0x0 << \
+                               ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_SHIFT(n))
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_1(n)      (0x1 << \
+                               ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_SHIFT(n))
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_2(n)      (0x2 << \
+                               ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_SHIFT(n))
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_3(n)      (0x3 << \
+                               ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_SHIFT(n))
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_4(n)      (0x4 << \
+                               ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_SHIFT(n))
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_5(n)      (0x5 << \
+                               ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_SHIFT(n))
+
+#define ISPCSI2_COMPLEXIO_CFG1_CLOCK_POL_SHIFT         3
+#define ISPCSI2_COMPLEXIO_CFG1_CLOCK_POL_MASK \
+                       (0x1 << ISPCSI2_COMPLEXIO_CFG1_CLOCK_POL_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_CLOCK_POL_PN \
+                       (0x0 << ISPCSI2_COMPLEXIO_CFG1_CLOCK_POL_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_CLOCK_POL_NP \
+                       (0x1 << ISPCSI2_COMPLEXIO_CFG1_CLOCK_POL_SHIFT)
+
+#define ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_SHIFT            0
+#define ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_MASK \
+                       (0x7 << ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_1 \
+                       (0x1 << ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_2 \
+                       (0x2 << ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_3 \
+                       (0x3 << ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_4 \
+                       (0x4 << ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_5 \
+                       (0x5 << ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_SHIFT)
+
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS                   (0x054)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_STATEALLULPMEXIT  (1 << 26)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_STATEALLULPMENTER (1 << 25)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_STATEULPM5                (1 << 24)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_STATEULPM4                (1 << 23)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_STATEULPM3                (1 << 22)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_STATEULPM2                (1 << 21)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_STATEULPM1                (1 << 20)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRCONTROL5       (1 << 19)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRCONTROL4       (1 << 18)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRCONTROL3       (1 << 17)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRCONTROL2       (1 << 16)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRCONTROL1       (1 << 15)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRESC5           (1 << 14)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRESC4           (1 << 13)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRESC3           (1 << 12)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRESC2           (1 << 11)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRESC1           (1 << 10)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRSOTSYNCHS5     (1 << 9)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRSOTSYNCHS4     (1 << 8)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRSOTSYNCHS3     (1 << 7)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRSOTSYNCHS2     (1 << 6)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRSOTSYNCHS1     (1 << 5)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRSOTHS5         (1 << 4)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRSOTHS4         (1 << 3)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRSOTHS3         (1 << 2)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRSOTHS2         (1 << 1)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRSOTHS1         1
+
+#define ISPCSI2_SHORT_PACKET           (0x05C)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE                   (0x060)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_STATEALLULPMEXIT  (1 << 26)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_STATEALLULPMENTER (1 << 25)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_STATEULPM5                (1 << 24)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_STATEULPM4                (1 << 23)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_STATEULPM3                (1 << 22)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_STATEULPM2                (1 << 21)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_STATEULPM1                (1 << 20)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRCONTROL5       (1 << 19)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRCONTROL4       (1 << 18)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRCONTROL3       (1 << 17)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRCONTROL2       (1 << 16)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRCONTROL1       (1 << 15)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRESC5           (1 << 14)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRESC4           (1 << 13)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRESC3           (1 << 12)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRESC2           (1 << 11)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRESC1           (1 << 10)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRSOTSYNCHS5     (1 << 9)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRSOTSYNCHS4     (1 << 8)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRSOTSYNCHS3     (1 << 7)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRSOTSYNCHS2     (1 << 6)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRSOTSYNCHS1     (1 << 5)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRSOTHS5         (1 << 4)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRSOTHS4         (1 << 3)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRSOTHS3         (1 << 2)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRSOTHS2         (1 << 1)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRSOTHS1         1
+#define ISPCSI2_DBG_P                  (0x068)
+#define ISPCSI2_TIMING                 (0x06C)
+
+
+#define ISPCSI2_TIMING_FORCE_RX_MODE_IO_SHIFT(n)       ((16 * ((n) - 1)) + 15)
+#define ISPCSI2_TIMING_FORCE_RX_MODE_IO_MASK(n)        (0x1 << \
+                               ISPCSI2_TIMING_FORCE_RX_MODE_IO_SHIFT(n))
+#define ISPCSI2_TIMING_FORCE_RX_MODE_IO_DISABLE(n)     (0x0 << \
+                               ISPCSI2_TIMING_FORCE_RX_MODE_IO_SHIFT(n))
+#define ISPCSI2_TIMING_FORCE_RX_MODE_IO_ENABLE(n)      (0x1 << \
+                               ISPCSI2_TIMING_FORCE_RX_MODE_IO_SHIFT(n))
+#define ISPCSI2_TIMING_STOP_STATE_X16_IO_SHIFT(n)      ((16 * ((n) - 1)) + 14)
+#define ISPCSI2_TIMING_STOP_STATE_X16_IO_MASK(n)       (0x1 << \
+                               ISPCSI2_TIMING_STOP_STATE_X16_IO_SHIFT(n))
+#define ISPCSI2_TIMING_STOP_STATE_X16_IO_DISABLE(n)    (0x0 << \
+                               ISPCSI2_TIMING_STOP_STATE_X16_IO_SHIFT(n))
+#define ISPCSI2_TIMING_STOP_STATE_X16_IO_ENABLE(n)     (0x1 << \
+                               ISPCSI2_TIMING_STOP_STATE_X16_IO_SHIFT(n))
+#define ISPCSI2_TIMING_STOP_STATE_X4_IO_SHIFT(n)       ((16 * ((n) - 1)) + 13)
+#define ISPCSI2_TIMING_STOP_STATE_X4_IO_MASK(n)                (0x1 << \
+                               ISPCSI2_TIMING_STOP_STATE_X4_IO_SHIFT(n))
+#define ISPCSI2_TIMING_STOP_STATE_X4_IO_DISABLE(n)     (0x0 << \
+                               ISPCSI2_TIMING_STOP_STATE_X4_IO_SHIFT(n))
+#define ISPCSI2_TIMING_STOP_STATE_X4_IO_ENABLE(n)              (0x1 << \
+                               ISPCSI2_TIMING_STOP_STATE_X4_IO_SHIFT(n))
+#define ISPCSI2_TIMING_STOP_STATE_COUNTER_IO_SHIFT(n)  (16 * ((n) - 1))
+#define ISPCSI2_TIMING_STOP_STATE_COUNTER_IO_MASK(n)   (0x1FFF << \
+                               ISPCSI2_TIMING_STOP_STATE_COUNTER_IO_SHIFT(n))
+
+#define ISPCSI2_CTX_CTRL1(n)           ((0x070) + 0x20 * (n))
+#define ISPCSI2_CTX_CTRL1_COUNT_SHIFT          8
+#define ISPCSI2_CTX_CTRL1_COUNT_MASK           (0xFF << \
+                                               ISPCSI2_CTX_CTRL1_COUNT_SHIFT)
+#define ISPCSI2_CTX_CTRL1_EOF_EN_SHIFT         7
+#define ISPCSI2_CTX_CTRL1_EOF_EN_MASK          (0x1 << \
+                                               ISPCSI2_CTX_CTRL1_EOF_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_EOF_EN_DISABLE       (0x0 << \
+                                               ISPCSI2_CTX_CTRL1_EOF_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_EOF_EN_ENABLE                (0x1 << \
+                                               ISPCSI2_CTX_CTRL1_EOF_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_EOL_EN_SHIFT         6
+#define ISPCSI2_CTX_CTRL1_EOL_EN_MASK          (0x1 << \
+                                               ISPCSI2_CTX_CTRL1_EOL_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_EOL_EN_DISABLE       (0x0 << \
+                                               ISPCSI2_CTX_CTRL1_EOL_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_EOL_EN_ENABLE                (0x1 << \
+                                               ISPCSI2_CTX_CTRL1_EOL_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_CS_EN_SHIFT          5
+#define ISPCSI2_CTX_CTRL1_CS_EN_MASK           (0x1 << \
+                                               ISPCSI2_CTX_CTRL1_CS_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_CS_EN_DISABLE                (0x0 << \
+                                               ISPCSI2_CTX_CTRL1_CS_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_CS_EN_ENABLE         (0x1 << \
+                                               ISPCSI2_CTX_CTRL1_CS_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_COUNT_UNLOCK_EN_SHIFT                4
+#define ISPCSI2_CTX_CTRL1_COUNT_UNLOCK_EN_MASK         (0x1 << \
+                                       ISPCSI2_CTX_CTRL1_COUNT_UNLOCK_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_COUNT_UNLOCK_EN_DISABLE      (0x0 << \
+                                       ISPCSI2_CTX_CTRL1_COUNT_UNLOCK_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_COUNT_UNLOCK_EN_ENABLE       (0x1 << \
+                                       ISPCSI2_CTX_CTRL1_COUNT_UNLOCK_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_PING_PONG_SHIFT      3
+#define ISPCSI2_CTX_CTRL1_PING_PONG_MASK       (0x1 << \
+                                       ISPCSI2_CTX_CTRL1_PING_PONG_SHIFT)
+#define ISPCSI2_CTX_CTRL1_CTX_EN_SHIFT         0
+#define ISPCSI2_CTX_CTRL1_CTX_EN_MASK          (0x1 << \
+                                               ISPCSI2_CTX_CTRL1_CTX_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_CTX_EN_DISABLE       (0x0 << \
+                                               ISPCSI2_CTX_CTRL1_CTX_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_CTX_EN_ENABLE                (0x1 << \
+                                               ISPCSI2_CTX_CTRL1_CTX_EN_SHIFT)
+
+#define ISPCSI2_CTX_CTRL2(n)           ((0x074) + 0x20 * (n))
+#define ISPCSI2_CTX_CTRL2_VIRTUAL_ID_SHIFT     11
+#define ISPCSI2_CTX_CTRL2_VIRTUAL_ID_MASK      (0x3 << \
+                                       ISPCSI2_CTX_CTRL2_VIRTUAL_ID_SHIFT)
+#define ISPCSI2_CTX_CTRL2_FORMAT_SHIFT 0
+#define ISPCSI2_CTX_CTRL2_FORMAT_MASK  (0x3FF << \
+                                       ISPCSI2_CTX_CTRL2_FORMAT_SHIFT)
+
+#define ISPCSI2_CTX_DAT_OFST(n)                ((0x078) + 0x20 * (n))
+#define ISPCSI2_CTX_DAT_OFST_OFST_SHIFT        5
+#define ISPCSI2_CTX_DAT_OFST_OFST_MASK (0x7FF << \
+                                               ISPCSI2_CTX_DAT_OFST_OFST_SHIFT)
+
+#define ISPCSI2_CTX_DAT_PING_ADDR(n)   ((0x07C) + 0x20 * (n))
+#define ISPCSI2_CTX_DAT_PONG_ADDR(n)   ((0x080) + 0x20 * (n))
+#define ISPCSI2_CTX_IRQENABLE(n)       ((0x084) + 0x20 * (n))
+#define ISPCSI2_CTX_IRQENABLE_ECC_CORRECTION_IRQ               (1 << 8)
+#define ISPCSI2_CTX_IRQENABLE_LINE_NUMBER_IRQ          (1 << 7)
+#define ISPCSI2_CTX_IRQENABLE_FRAME_NUMBER_IRQ         (1 << 6)
+#define ISPCSI2_CTX_IRQENABLE_CS_IRQ                   (1 << 5)
+#define ISPCSI2_CTX_IRQENABLE_LE_IRQ                   (1 << 3)
+#define ISPCSI2_CTX_IRQENABLE_LS_IRQ                   (1 << 2)
+#define ISPCSI2_CTX_IRQENABLE_FE_IRQ                   (1 << 1)
+#define ISPCSI2_CTX_IRQENABLE_FS_IRQ                   1
+#define ISPCSI2_CTX_IRQSTATUS(n)       ((0x088) + 0x20 * (n))
+#define ISPCSI2_CTX_IRQSTATUS_ECC_CORRECTION_IRQ               (1 << 8)
+#define ISPCSI2_CTX_IRQSTATUS_LINE_NUMBER_IRQ          (1 << 7)
+#define ISPCSI2_CTX_IRQSTATUS_FRAME_NUMBER_IRQ         (1 << 6)
+#define ISPCSI2_CTX_IRQSTATUS_CS_IRQ                   (1 << 5)
+#define ISPCSI2_CTX_IRQSTATUS_LE_IRQ                   (1 << 3)
+#define ISPCSI2_CTX_IRQSTATUS_LS_IRQ                   (1 << 2)
+#define ISPCSI2_CTX_IRQSTATUS_FE_IRQ                   (1 << 1)
+#define ISPCSI2_CTX_IRQSTATUS_FS_IRQ                   1
+
+#define ISPCSI2_CTX_CTRL3(n)           ((0x08C) + 0x20 * (n))
+#define ISPCSI2_CTX_CTRL3_ALPHA_SHIFT  5
+#define ISPCSI2_CTX_CTRL3_ALPHA_MASK   (0x3FFF << \
+                                               ISPCSI2_CTX_CTRL3_ALPHA_SHIFT)
+
+#define ISPCSI2PHY_CFG0                                (0x000)
+#define ISPCSI2PHY_CFG0_THS_TERM_SHIFT         8
+#define ISPCSI2PHY_CFG0_THS_TERM_MASK \
+                               (0xFF << ISPCSI2PHY_CFG0_THS_TERM_SHIFT)
+#define ISPCSI2PHY_CFG0_THS_TERM_RESETVAL \
+                               (0x04 << ISPCSI2PHY_CFG0_THS_TERM_SHIFT)
+#define ISPCSI2PHY_CFG0_THS_SETTLE_SHIFT               0
+#define ISPCSI2PHY_CFG0_THS_SETTLE_MASK \
+                               (0xFF << ISPCSI2PHY_CFG0_THS_SETTLE_SHIFT)
+#define ISPCSI2PHY_CFG0_THS_SETTLE_RESETVAL \
+                               (0x27 << ISPCSI2PHY_CFG0_THS_SETTLE_SHIFT)
+#define ISPCSI2PHY_CFG1                                (0x004)
+#define ISPCSI2PHY_CFG1_TCLK_TERM_SHIFT                18
+#define ISPCSI2PHY_CFG1_TCLK_TERM_MASK \
+                               (0x7F << ISPCSI2PHY_CFG1_TCLK_TERM_SHIFT)
+#define ISPCSI2PHY_CFG1_TCLK_TERM__RESETVAL \
+                               (0x00 << ISPCSI2PHY_CFG1_TCLK_TERM_SHIFT)
+#define ISPCSI2PHY_CFG1_RESERVED1_SHIFT                10
+#define ISPCSI2PHY_CFG1_RESERVED1_MASK \
+                               (0xFF << ISPCSI2PHY_CFG1_RESERVED1_SHIFT)
+#define ISPCSI2PHY_CFG1_RESERVED1__RESETVAL \
+                               (0xB8 << ISPCSI2PHY_CFG1_RESERVED1_SHIFT)
+#define ISPCSI2PHY_CFG1_TCLK_MISS_SHIFT                8
+#define ISPCSI2PHY_CFG1_TCLK_MISS_MASK \
+                               (0x3 << ISPCSI2PHY_CFG1_TCLK_MISS_SHIFT)
+#define ISPCSI2PHY_CFG1_TCLK_MISS__RESETVAL \
+                               (0x1 << ISPCSI2PHY_CFG1_TCLK_MISS_SHIFT)
+#define ISPCSI2PHY_CFG1_TCLK_SETTLE_SHIFT              0
+#define ISPCSI2PHY_CFG1_TCLK_SETTLE_MASK \
+                               (0xFF << ISPCSI2PHY_CFG1_TCLK_TERM_SHIFT)
+#define ISPCSI2PHY_CFG1_TCLK_SETTLE__RESETVAL \
+                               (0x0E << ISPCSI2PHY_CFG1_TCLK_TERM_SHIFT)
+#define ISPCSI2PHY_CFG1__RESETVAL      (ISPCSI2PHY_CFG1_TCLK_TERM__RESETVAL | \
+                                       ISPCSI2PHY_CFG1_RESERVED1__RESETVAL | \
+                                       ISPCSI2PHY_CFG1_TCLK_MISS__RESETVAL | \
+                                       ISPCSI2PHY_CFG1_TCLK_SETTLE__RESETVAL)
+#define ISPCSI2PHY_CFG1__EDITABLE_MASK (ISPCSI2PHY_CFG1_TCLK_TERM_MASK | \
+                                       ISPCSI2PHY_CFG1_RESERVED1_MASK | \
+                                       ISPCSI2PHY_CFG1_TCLK_MISS_MASK | \
+                                       ISPCSI2PHY_CFG1_TCLK_SETTLE_MASK)
+
+#endif /* __ISPREG_H__ */
--
1.5.6.5

