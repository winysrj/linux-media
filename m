Return-path: <mchehab@pedra>
Received: from ganesha.gnumonks.org ([213.95.27.120]:42416 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab1BYIWM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 03:22:12 -0500
From: Abhilash Kesavan <a.kesavan@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Ilho Lee <ilho215.lee@samsung.com>,
	Jiun Yu <jiun.yu@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Abhilash Kesavan <a.kesavan@samsung.com>
Subject: [PATCH 1/5] [media] s5p-tvout: Add TVOUT core driver for S5P SoCs
Date: Fri, 25 Feb 2011 16:53:29 +0900
Message-Id: <1298620413-24182-2-git-send-email-a.kesavan@samsung.com>
In-Reply-To: <1298620413-24182-1-git-send-email-a.kesavan@samsung.com>
References: <1298620413-24182-1-git-send-email-a.kesavan@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Jiun Yu <jiun.yu@samsung.com>

The S5P TVOUT driver is composed of 3 kinds of drivers logically.

- Video driver controls video processor and follows V4L2 interface
- Graphic driver controls mixer and follows framebuffer interface
- TV interface driver selects hdmi or analog TV interface and
  follows V4L2 interface

This patch is for video driver. It mainly controls video processor.

The video processor is responsible for video scaling, de-interlacing, and
video post processing of TVOUT data path. It reads reconstructed YCbCr video
sequences from DRAM, processes the sequence, and sends it to mixer on-the-fly.
Input to VP is NV12 and NV21 (Linear and tiled) format while the output to
the mixer is YUV444.

Following is S/W DESIGN diagram.
===============================================================================
        -----------------------------------------------------------------------
                                        VFS
        -----------------------------------------------------------------------
KERNEL       |                               |
             V                               V
        ----------                       --------            ------------------
        V4L2 STACK                       FB STACK            Linux Driver Model
        ----------                       --------            ------------------
             |                               |                        |
=============+===============================+========================+========
             |                               |                        |
             |                               |          +-------------|
             |                               |          |             |
             V                               V          V             |
      +---------------------------------------------------------------+-------+
      |                                                               |       |
      |                                                               |       |
      | ------------    -------------   -----------                   |       |
      |  Video Ctrl  -- Graphics Ctrl -- TVOUT I/F                    |       |
      | ------------    -------------   -----------                   V       |
      |      |               |             |    |__________       ----------- |
      |      |               |             |               |       HPD Driver |
      |      V               V             V               V        (GPIO)    |
      | -----------     -----------   -----------   -----------   ----------- |
      |     VP I/F       Mixer I/F     Analog I/F    HDMI I/F                 |
      | -----------     -----------   -----------   -----------               |
      |      |               |               |         |   |                  |
DEVICE|      |               |               |         |   |_______________   |
DRIVER|      |               |               |         |           |       |  |
      |      |               |               |         |           V       V  |
      |      |               |               |         |         -----  ------|
      |      |               |               |         |          CEC    HDCP |
      |      |               |               |         |         -----  ------|
      |      |               |               |         |___________|_______|  |
      |      |               |               |                                |
      +------+---------------+---------------+--------------------------------+
             |               |               |         |
             |               |               |         |
=============+===============+===============+=================================
             |               |               |         |
             V               V               V         |
        -----------     -----------     -----------    |         --------
            VP     ---->   Mixer   ----> TV Encoder ---+-------->   DAC
        -----------     -----------  |  -----------    |         --------
                                     |                 |
HARDWARE                             |                 V
                                     |           ----------      --------
                                     +----------> HDMI Link  --> HDMI PHY
                                                 ----------      --------
===============================================================================

[based on work originally written by Sunil Choi <sunil111.choi@samsung.com>]
Cc: Kukjin Kim <kgene.kim@samsung.com>
Acked-by: KyungHwan Kim <kh.k.kim@samsung.com>
Signed-off-by: Jiun Yu <jiun.yu@samsung.com>
Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
---
 drivers/media/video/s5p-tvout/hw_if/hw_if.h        |  651 +++++++++++++++++
 drivers/media/video/s5p-tvout/hw_if/vp.c           |  731 ++++++++++++++++++++
 drivers/media/video/s5p-tvout/s5p_tvout.c          |  210 ++++++
 .../media/video/s5p-tvout/s5p_tvout_common_lib.c   |   99 +++
 .../media/video/s5p-tvout/s5p_tvout_common_lib.h   |  187 +++++
 drivers/media/video/s5p-tvout/s5p_tvout_ctrl.h     |  126 ++++
 drivers/media/video/s5p-tvout/s5p_tvout_fb.c       |  639 +++++++++++++++++
 drivers/media/video/s5p-tvout/s5p_tvout_fb.h       |   20 +
 drivers/media/video/s5p-tvout/s5p_vp_ctrl.c        |  586 ++++++++++++++++
 9 files changed, 3249 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/s5p-tvout/hw_if/hw_if.h
 create mode 100644 drivers/media/video/s5p-tvout/hw_if/vp.c
 create mode 100644 drivers/media/video/s5p-tvout/s5p_tvout.c
 create mode 100644 drivers/media/video/s5p-tvout/s5p_tvout_common_lib.c
 create mode 100644 drivers/media/video/s5p-tvout/s5p_tvout_common_lib.h
 create mode 100644 drivers/media/video/s5p-tvout/s5p_tvout_ctrl.h
 create mode 100644 drivers/media/video/s5p-tvout/s5p_tvout_fb.c
 create mode 100644 drivers/media/video/s5p-tvout/s5p_tvout_fb.h
 create mode 100644 drivers/media/video/s5p-tvout/s5p_vp_ctrl.c

diff --git a/drivers/media/video/s5p-tvout/hw_if/hw_if.h b/drivers/media/video/s5p-tvout/hw_if/hw_if.h
new file mode 100644
index 0000000..ac46166
--- /dev/null
+++ b/drivers/media/video/s5p-tvout/hw_if/hw_if.h
@@ -0,0 +1,651 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Header file for interface of Samsung TVOUT-related hardware
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef __S5P_TVOUT_HW_IF_H_
+#define __S5P_TVOUT_HW_IF_H_ __FILE__
+
+/*
+ * This file includes declarations for external functions of
+ * Samsung TVOUT-related hardware. So only external functions
+ * to be used by higher layer must exist in this file.
+ *
+ * Higher layer must use only the declarations included in this file.
+ */
+
+#include <linux/irqreturn.h>
+#include <linux/stddef.h>
+
+#include "../s5p_tvout_common_lib.h"
+
+/* Common */
+
+enum s5p_tvout_endian {
+	TVOUT_LITTLE_ENDIAN = 0,
+	TVOUT_BIG_ENDIAN = 1
+};
+
+/* for MIXER */
+
+enum s5p_mixer_layer {
+	MIXER_VIDEO_LAYER = 2,
+	MIXER_GPR0_LAYER = 0,
+	MIXER_GPR1_LAYER = 1
+};
+
+enum s5p_mixer_bg_color_num {
+	MIXER_BG_COLOR_0 = 0,
+	MIXER_BG_COLOR_1 = 1,
+	MIXER_BG_COLOR_2 = 2
+};
+
+enum s5p_mixer_color_fmt {
+	MIXER_RGB565  = 4,
+	MIXER_RGB1555 = 5,
+	MIXER_RGB4444 = 6,
+	MIXER_RGB8888 = 7
+};
+
+enum s5p_mixer_csc_type {
+	MIXER_CSC_601_LR,
+	MIXER_CSC_601_FR,
+	MIXER_CSC_709_LR,
+	MIXER_CSC_709_FR
+};
+
+enum s5p_mixer_rgb {
+	MIXER_RGB601_0_255,
+	MIXER_RGB601_16_235,
+	MIXER_RGB709_0_255,
+	MIXER_RGB709_16_235
+};
+
+enum s5p_mixer_out_type {
+	MIXER_YUV444,
+	MIXER_RGB888
+};
+
+extern int s5p_mixer_set_show(enum s5p_mixer_layer layer, bool show);
+extern int s5p_mixer_set_priority(enum s5p_mixer_layer layer, u32 priority);
+extern void s5p_mixer_set_pre_mul_mode(enum s5p_mixer_layer layer, bool enable);
+extern int s5p_mixer_set_pixel_blend(enum s5p_mixer_layer layer, bool enable);
+extern int s5p_mixer_set_layer_blend(enum s5p_mixer_layer layer, bool enable);
+extern int s5p_mixer_set_alpha(enum s5p_mixer_layer layer, u32 alpha);
+extern int s5p_mixer_set_grp_base_address(enum s5p_mixer_layer layer,
+					  u32 baseaddr);
+extern int s5p_mixer_set_grp_layer_dst_pos(enum s5p_mixer_layer layer,
+					   u32 dst_offs_x, u32 dst_offs_y);
+extern int s5p_mixer_set_grp_layer_src_pos(enum s5p_mixer_layer layer,
+					   u32 span, u32 width, u32 height,
+					   u32 src_offs_x, u32 src_offs_y);
+extern void s5p_mixer_set_bg_color(enum s5p_mixer_bg_color_num colornum,
+				   u32 color_y, u32 color_cb, u32 color_cr);
+extern void s5p_mixer_init_status_reg(enum s5p_mixer_burst_mode burst,
+				      enum s5p_tvout_endian endian);
+extern int s5p_mixer_init_display_mode(enum s5p_tvout_disp_mode mode,
+				       enum s5p_tvout_o_mode output_mode);
+extern void s5p_mixer_scaling(enum s5p_mixer_layer layer,
+			      struct s5ptvfb_user_scaling scaling);
+extern void s5p_mixer_set_color_format(enum s5p_mixer_layer layer,
+				       enum s5p_mixer_color_fmt format);
+extern void s5p_mixer_set_chroma_key(enum s5p_mixer_layer layer,
+				     bool enabled, u32 key);
+extern void s5p_mixer_init_bg_dither_enable(bool cr_dither_enable,
+					    bool cdither_enable,
+					    bool y_dither_enable);
+extern void s5p_mixer_init_csc_coef_default(enum s5p_mixer_csc_type csc_type);
+extern void s5p_mixer_start(void);
+extern void s5p_mixer_stop(void);
+extern void s5p_mixer_set_underflow_int_enable(enum s5p_mixer_layer layer,
+					       bool en);
+extern void s5p_mixer_set_vsync_interrupt(bool);
+extern void s5p_mixer_clear_pend_all(void);
+extern irqreturn_t s5p_mixer_irq(int irq, void *dev_id);
+extern void s5p_mixer_init(void __iomem *addr);
+
+/* for HDMI */
+
+#define HDMI_MASK_8(x)		((x) & 0xFF)
+#define HDMI_MASK_16(x)		(((x) >> 8) & 0xFF)
+#define HDMI_MASK_24(x)		(((x) >> 16) & 0xFF)
+#define HDMI_MASK_32(x)		(((x) >> 24) & 0xFF)
+
+#define hdmi_write_16(x, y)				\
+	do {						\
+		writeb(HDMI_MASK_8(x), y);		\
+		writeb(HDMI_MASK_16(x), y + 4);		\
+	} while (0);
+
+#define hdmi_write_24(x, y)				\
+	do {						\
+		writeb(HDMI_MASK_8(x), y);		\
+		writeb(HDMI_MASK_16(x), y + 4);		\
+		writeb(HDMI_MASK_24(x), y + 8);		\
+	} while (0);
+
+#define hdmi_write_32(x, y)				\
+	do {						\
+		writeb(HDMI_MASK_8(x), y);		\
+		writeb(HDMI_MASK_16(x), y + 4);		\
+		writeb(HDMI_MASK_24(x), y + 8);		\
+		writeb(HDMI_MASK_32(x), y + 12);	\
+	} while (0);
+
+#define hdmi_write_l(buff, base, start, count)		\
+	do {						\
+		u8 *ptr = buff;				\
+		int i = 0;				\
+		int a = start;				\
+		do {					\
+			writeb(ptr[i], base + a);	\
+			a += 4;				\
+			i++;				\
+		} while (i <= (count - 1));		\
+	} while (0);
+
+#define hdmi_read_l(buff, base, start, count)		\
+	do {						\
+		u8 *ptr = buff;				\
+		int i = 0;				\
+		int a = start;				\
+		do {					\
+			ptr[i] = readb(base + a);	\
+			a += 4;				\
+			i++;				\
+		} while (i <= (count - 1));		\
+	} while (0);
+
+#define hdmi_bit_set(en, reg, val)			\
+	do {						\
+		if (en)					\
+			reg |= val;			\
+		else					\
+			reg &= ~val;			\
+	} while (0);
+
+enum s5p_hdmi_transmit {
+	HDMI_DO_NOT_TANS,
+	HDMI_TRANS_ONCE,
+	HDMI_TRANS_EVERY_SYNC,
+};
+
+enum s5p_tvout_audio_codec_type {
+	PCM = 1,
+	AC3,
+	MP3,
+	WMA
+};
+
+enum s5p_hdmi_infoframe_type {
+	HDMI_VSI_INFO = 0x81,
+	HDMI_AVI_INFO,
+	HDMI_SPD_INFO,
+	HDMI_AUI_INFO,
+	HDMI_MPG_INFO,
+};
+
+enum s5p_hdmi_color_depth {
+	HDMI_CD_48,
+	HDMI_CD_36,
+	HDMI_CD_30,
+	HDMI_CD_24
+};
+
+enum s5p_hdmi_interrrupt {
+	HDMI_IRQ_PIN_POLAR_CTL	= 7,
+	HDMI_IRQ_GLOBAL		= 6,
+	HDMI_IRQ_I2S		= 5,
+	HDMI_IRQ_CEC		= 4,
+	HDMI_IRQ_HPD_PLUG	= 3,
+	HDMI_IRQ_HPD_UNPLUG	= 2,
+	HDMI_IRQ_SPDIF		= 1,
+	HDMI_IRQ_HDCP		= 0
+};
+
+enum phy_freq {
+	ePHY_FREQ_25_200,
+	ePHY_FREQ_25_175,
+	ePHY_FREQ_27,
+	ePHY_FREQ_27_027,
+	ePHY_FREQ_54,
+	ePHY_FREQ_54_054,
+	ePHY_FREQ_74_250,
+	ePHY_FREQ_74_176,
+	ePHY_FREQ_148_500,
+	ePHY_FREQ_148_352,
+	ePHY_FREQ_108_108,
+	ePHY_FREQ_72,
+	ePHY_FREQ_25,
+	ePHY_FREQ_65,
+	ePHY_FREQ_108,
+	ePHY_FREQ_162
+};
+
+struct s5p_hdmi_infoframe {
+	enum s5p_hdmi_infoframe_type	type;
+	u8				version;
+	u8				length;
+};
+
+struct s5p_hdmi_o_trans {
+	enum s5p_hdmi_transmit	avi;
+	enum s5p_hdmi_transmit	mpg;
+	enum s5p_hdmi_transmit	spd;
+	enum s5p_hdmi_transmit	gcp;
+	enum s5p_hdmi_transmit	gmp;
+	enum s5p_hdmi_transmit	isrc;
+	enum s5p_hdmi_transmit	acp;
+	enum s5p_hdmi_transmit	aui;
+	enum s5p_hdmi_transmit	acr;
+};
+
+struct s5p_hdmi_o_reg {
+	u8			pxl_fmt;
+	u8			preemble;
+	u8			mode;
+	u8			pxl_limit;
+	u8			dvi;
+};
+
+struct s5p_hdmi_v_frame {
+	u8			vic;
+	u8			vic_16_9;
+	u8			repetition;
+	u8			polarity;
+	u8			i_p;
+
+	u16			h_active;
+	u16			v_active;
+
+	u16			h_total;
+	u16			h_blank;
+
+	u16			v_total;
+	u16			v_blank;
+
+	enum phy_freq		pixel_clock;
+};
+
+struct s5p_hdmi_tg_sync {
+	u16			begin;
+	u16			end;
+};
+
+struct s5p_hdmi_v_format {
+	struct s5p_hdmi_v_frame	frame;
+
+	struct s5p_hdmi_tg_sync	h_sync;
+	struct s5p_hdmi_tg_sync	v_sync_top;
+	struct s5p_hdmi_tg_sync	v_sync_bottom;
+	struct s5p_hdmi_tg_sync	v_sync_h_pos;
+
+	struct s5p_hdmi_tg_sync	v_blank_f;
+
+	u8			mhl_hsync;
+	u8			mhl_vsync;
+};
+
+extern int s5p_hdmi_phy_power(bool on);
+extern s32 s5p_hdmi_phy_config(enum phy_freq freq,
+			       enum s5p_hdmi_color_depth cd);
+
+extern void s5p_hdmi_set_gcp(enum s5p_hdmi_color_depth depth, u8 *gcp);
+extern void s5p_hdmi_reg_acr(u8 *acr);
+extern void s5p_hdmi_reg_asp(u8 *asp);
+extern void s5p_hdmi_reg_gcp(u8 i_p, u8 *gcp);
+extern void s5p_hdmi_reg_acp(u8 *header, u8 *acp);
+extern void s5p_hdmi_reg_isrc(u8 *isrc1, u8 *isrc2);
+extern void s5p_hdmi_reg_gmp(u8 *gmp);
+extern void s5p_hdmi_reg_infoframe(struct s5p_hdmi_infoframe *info, u8 *data);
+extern void s5p_hdmi_reg_tg(struct s5p_hdmi_v_frame *frame);
+extern void s5p_hdmi_reg_v_timing(struct s5p_hdmi_v_format *v);
+extern void s5p_hdmi_reg_bluescreen_clr(u8 cb_b, u8 y_g, u8 cr_r);
+extern void s5p_hdmi_reg_bluescreen(bool en);
+extern void s5p_hdmi_reg_clr_range(u8 y_min, u8 y_max, u8 c_min, u8 c_max);
+extern void s5p_hdmi_reg_tg_cmd(bool time, bool bt656, bool tg);
+extern void s5p_hdmi_reg_enable(bool en);
+extern u8 s5p_hdmi_reg_intc_status(void);
+extern u8 s5p_hdmi_reg_intc_get_enabled(void);
+extern void s5p_hdmi_reg_intc_clear_pending(enum s5p_hdmi_interrrupt intr);
+extern void s5p_hdmi_reg_sw_hpd_enable(bool enable);
+extern void s5p_hdmi_reg_set_hpd_onoff(bool on_off);
+extern u8 s5p_hdmi_reg_get_hpd_status(void);
+extern void s5p_hdmi_reg_hpd_gen(void);
+extern int s5p_hdmi_reg_intc_set_isr(irqreturn_t (*isr)(int, void *), u8 num);
+extern void s5p_hdmi_reg_intc_enable(enum s5p_hdmi_interrrupt intr, u8 en);
+extern void s5p_hdmi_reg_audio_enable(u8 en);
+extern int s5p_hdmi_audio_init(enum s5p_tvout_audio_codec_type audio_codec,
+			       u32 sample_rate, u32 bits, u32 frame_size_code);
+extern irqreturn_t s5p_hdmi_irq(int irq, void *dev_id);
+extern void s5p_hdmi_init(void __iomem *hdmi_addr,
+			  void __iomem *hdmi_phy_addr);
+extern void s5p_hdmi_reg_output(struct s5p_hdmi_o_reg *reg);
+extern void s5p_hdmi_reg_packet_trans(struct s5p_hdmi_o_trans *trans);
+extern void s5p_hdmi_reg_mute(bool en);
+
+extern void __iomem *hdmi_base;
+
+/* for SDO */
+
+enum s5p_sdo_level {
+	SDO_LEVEL_0IRE,
+	SDO_LEVEL_75IRE
+};
+
+enum s5p_sdo_vsync_ratio {
+	SDO_VTOS_RATIO_10_4,
+	SDO_VTOS_RATIO_7_3
+};
+
+enum s5p_sdo_order {
+	SDO_O_ORDER_COMPONENT_RGB_PRYPB,
+	SDO_O_ORDER_COMPONENT_RBG_PRPBY,
+	SDO_O_ORDER_COMPONENT_BGR_PBYPR,
+	SDO_O_ORDER_COMPONENT_BRG_PBPRY,
+	SDO_O_ORDER_COMPONENT_GRB_YPRPB,
+	SDO_O_ORDER_COMPONENT_GBR_YPBPR,
+	SDO_O_ORDER_COMPOSITE_CVBS_Y_C,
+	SDO_O_ORDER_COMPOSITE_CVBS_C_Y,
+	SDO_O_ORDER_COMPOSITE_Y_C_CVBS,
+	SDO_O_ORDER_COMPOSITE_Y_CVBS_C,
+	SDO_O_ORDER_COMPOSITE_C_CVBS_Y,
+	SDO_O_ORDER_COMPOSITE_C_Y_CVBS
+};
+
+enum s5p_sdo_sync_sig_pin {
+	SDO_SYNC_SIG_NO,
+	SDO_SYNC_SIG_YG,
+	SDO_SYNC_SIG_ALL
+};
+
+enum s5p_sdo_closed_caption_type {
+	SDO_NO_INS,
+	SDO_INS_1,
+	SDO_INS_2,
+	SDO_INS_OTHERS
+};
+
+enum s5p_sdo_525_copy_permit {
+	SDO_525_COPY_PERMIT,
+	SDO_525_ONECOPY_PERMIT,
+	SDO_525_NOCOPY_PERMIT
+};
+
+enum s5p_sdo_525_mv_psp {
+	SDO_525_MV_PSP_OFF,
+	SDO_525_MV_PSP_ON_2LINE_BURST,
+	SDO_525_MV_PSP_ON_BURST_OFF,
+	SDO_525_MV_PSP_ON_4LINE_BURST,
+};
+
+enum s5p_sdo_525_copy_info {
+	SDO_525_COPY_INFO,
+	SDO_525_DEFAULT,
+};
+
+enum s5p_sdo_525_aspect_ratio {
+	SDO_525_4_3_NORMAL,
+	SDO_525_16_9_ANAMORPIC,
+	SDO_525_4_3_LETTERBOX
+};
+
+enum s5p_sdo_625_subtitles {
+	SDO_625_NO_OPEN_SUBTITLES,
+	SDO_625_INACT_OPEN_SUBTITLES,
+	SDO_625_OUTACT_OPEN_SUBTITLES
+};
+
+enum s5p_sdo_625_camera_film {
+	SDO_625_CAMERA,
+	SDO_625_FILM
+};
+
+enum s5p_sdo_625_color_encoding {
+	SDO_625_NORMAL_PAL,
+	SDO_625_MOTION_ADAPTIVE_COLORPLUS
+};
+
+enum s5p_sdo_625_aspect_ratio {
+	SDO_625_4_3_FULL_576,
+	SDO_625_14_9_LETTERBOX_CENTER_504,
+	SDO_625_14_9_LETTERBOX_TOP_504,
+	SDO_625_16_9_LETTERBOX_CENTER_430,
+	SDO_625_16_9_LETTERBOX_TOP_430,
+	SDO_625_16_9_LETTERBOX_CENTER,
+	SDO_625_14_9_FULL_CENTER_576,
+	SDO_625_16_9_ANAMORPIC_576
+};
+
+struct s5p_sdo_cvbs_compensation {
+	bool cvbs_color_compen;
+	u32 y_lower_mid;
+	u32 y_bottom;
+	u32 y_top;
+	u32 y_upper_mid;
+	u32 radius;
+};
+
+struct s5p_sdo_bright_hue_saturation {
+	bool bright_hue_sat_adj;
+	u32 gain_brightness;
+	u32 offset_brightness;
+	u32 gain0_cb_hue_sat;
+	u32 gain1_cb_hue_sat;
+	u32 gain0_cr_hue_sat;
+	u32 gain1_cr_hue_sat;
+	u32 offset_cb_hue_sat;
+	u32 offset_cr_hue_sat;
+};
+
+struct s5p_sdo_525_data {
+	bool				analog_on;
+	enum s5p_sdo_525_copy_permit	copy_permit;
+	enum s5p_sdo_525_mv_psp		mv_psp;
+	enum s5p_sdo_525_copy_info	copy_info;
+	enum s5p_sdo_525_aspect_ratio	display_ratio;
+};
+
+struct s5p_sdo_625_data {
+	bool				surround_sound;
+	bool				copyright;
+	bool				copy_protection;
+	bool				text_subtitles;
+	enum s5p_sdo_625_subtitles	open_subtitles;
+	enum s5p_sdo_625_camera_film	camera_film;
+	enum s5p_sdo_625_color_encoding	color_encoding;
+	bool				helper_signal;
+	enum s5p_sdo_625_aspect_ratio	display_ratio;
+};
+
+extern int s5p_sdo_set_video_scale_cfg(enum s5p_sdo_level composite_level,
+				       enum s5p_sdo_vsync_ratio composite_ratio);
+extern int s5p_sdo_set_vbi(bool wss_cvbs,
+			   enum s5p_sdo_closed_caption_type caption_cvbs);
+extern void s5p_sdo_set_offset_gain(u32 offset, u32 gain);
+extern void s5p_sdo_set_delay(u32 delay_y, u32 offset_video_start,
+			      u32 offset_video_end);
+extern void s5p_sdo_set_schlock(bool color_sucarrier_pha_adj);
+extern void s5p_sdo_set_brightness_hue_saturation(struct s5p_sdo_bright_hue_saturation bri_hue_sat);
+extern void s5p_sdo_set_cvbs_color_compensation(struct s5p_sdo_cvbs_compensation cvbs_comp);
+extern void s5p_sdo_set_component_porch(u32 back_525, u32 front_525,
+					u32 back_625, u32 front_625);
+extern void s5p_sdo_set_ch_xtalk_cancel_coef(u32 coeff2, u32 coeff1);
+extern void s5p_sdo_set_closed_caption(u32 display_cc, u32 non_display_cc);
+
+extern int s5p_sdo_set_wss525_data(struct s5p_sdo_525_data wss525);
+extern int s5p_sdo_set_wss625_data(struct s5p_sdo_625_data wss625);
+extern int s5p_sdo_set_cgmsa525_data(struct s5p_sdo_525_data cgmsa525);
+extern int s5p_sdo_set_cgmsa625_data(struct s5p_sdo_625_data cgmsa625);
+extern int s5p_sdo_set_display_mode(enum s5p_tvout_disp_mode disp_mode,
+				    enum s5p_sdo_order order);
+extern void s5p_sdo_clock_on(bool on);
+extern void s5p_sdo_dac_on(bool on);
+extern void s5p_sdo_sw_reset(bool active);
+extern void s5p_sdo_set_interrupt_enable(bool vsync_intc_en);
+extern void s5p_sdo_clear_interrupt_pending(void);
+extern void s5p_sdo_init(void __iomem *addr);
+
+/* for VP */
+
+enum s5p_vp_field {
+	VP_TOP_FIELD,
+	VP_BOTTOM_FIELD
+};
+
+enum s5p_vp_line_eq {
+	VP_LINE_EQ_0,
+	VP_LINE_EQ_1,
+	VP_LINE_EQ_2,
+	VP_LINE_EQ_3,
+	VP_LINE_EQ_4,
+	VP_LINE_EQ_5,
+	VP_LINE_EQ_6,
+	VP_LINE_EQ_7,
+	VP_LINE_EQ_DEFAULT
+};
+
+enum s5p_vp_mem_type {
+	VP_YUV420_NV12,
+	VP_YUV420_NV21
+};
+
+enum s5p_vp_mem_mode {
+	VP_LINEAR_MODE,
+	VP_2D_TILE_MODE
+};
+
+enum s5p_vp_chroma_expansion {
+	VP_C_TOP,
+	VP_C_TOP_BOTTOM
+};
+
+enum s5p_vp_pxl_rate {
+	VP_PXL_PER_RATE_1_1,
+	VP_PXL_PER_RATE_1_2,
+	VP_PXL_PER_RATE_1_3,
+	VP_PXL_PER_RATE_1_4
+};
+
+enum s5p_vp_sharpness_control {
+	VP_SHARPNESS_NO,
+	VP_SHARPNESS_MIN,
+	VP_SHARPNESS_MOD,
+	VP_SHARPNESS_MAX
+};
+
+enum s5p_vp_csc_type {
+	VP_CSC_SD_HD,
+	VP_CSC_HD_SD
+};
+
+enum s5p_vp_csc_coeff {
+	VP_CSC_Y2Y_COEF,
+	VP_CSC_CB2Y_COEF,
+	VP_CSC_CR2Y_COEF,
+	VP_CSC_Y2CB_COEF,
+	VP_CSC_CB2CB_COEF,
+	VP_CSC_CR2CB_COEF,
+	VP_CSC_Y2CR_COEF,
+	VP_CSC_CB2CR_COEF,
+	VP_CSC_CR2CR_COEF
+};
+
+
+extern void s5p_vp_set_poly_filter_coef_default(u32 src_width, u32 src_height,
+						u32 dst_width, u32 dst_height,
+						bool ipc_2d);
+extern void s5p_vp_set_field_id(enum s5p_vp_field mode);
+extern int s5p_vp_set_top_field_address(u32 top_y_addr, u32 top_c_addr);
+extern int s5p_vp_set_bottom_field_address(u32 bottom_y_addr,
+					   u32 bottom_c_addr);
+extern int s5p_vp_set_img_size(u32 img_width, u32 img_height);
+extern void s5p_vp_set_src_position(u32 src_off_x, u32 src_x_fract_step,
+				    u32 src_off_y);
+extern void s5p_vp_set_dest_position(u32 dst_off_x, u32 dst_off_y);
+extern void s5p_vp_set_src_dest_size(u32 src_width, u32 src_height,
+				     u32 dst_width, u32 dst_height,
+				     bool ipc_2d);
+extern void s5p_vp_set_op_mode(bool line_skip, enum s5p_vp_mem_type mem_type,
+			       enum s5p_vp_mem_mode mem_mode,
+			       enum s5p_vp_chroma_expansion chroma_exp,
+			       bool auto_toggling);
+extern void s5p_vp_set_pixel_rate_control(enum s5p_vp_pxl_rate rate);
+extern void s5p_vp_set_endian(enum s5p_tvout_endian endian);
+extern void s5p_vp_set_bypass_post_process(bool bypass);
+extern void s5p_vp_set_saturation(u32 sat);
+extern void s5p_vp_set_sharpness(u32 th_h_noise,
+				 enum s5p_vp_sharpness_control sharpness);
+extern void s5p_vp_set_brightness_contrast(u16 b, u8 c);
+extern void s5p_vp_set_brightness_offset(u32 offset);
+extern int s5p_vp_set_brightness_contrast_control(enum s5p_vp_line_eq eq_num,
+						  u32 intc, u32 slope);
+extern void s5p_vp_set_csc_control(bool sub_y_offset_en, bool csc_en);
+extern int s5p_vp_set_csc_coef(enum s5p_vp_csc_coeff csc_coeff, u32 coeff);
+extern int s5p_vp_set_csc_coef_default(enum s5p_vp_csc_type csc_type);
+extern int s5p_vp_update(void);
+extern int s5p_vp_get_update_status(void);
+extern void s5p_vp_sw_reset(void);
+extern int s5p_vp_start(void);
+extern int s5p_vp_stop(void);
+extern void s5p_vp_init(void __iomem *addr);
+
+/* for CEC */
+
+enum cec_state {
+	STATE_RX,
+	STATE_TX,
+	STATE_DONE,
+	STATE_ERROR
+};
+
+struct cec_rx_struct {
+	spinlock_t lock;
+	wait_queue_head_t waitq;
+	atomic_t state;
+	u8 *buffer;
+	unsigned int size;
+};
+
+struct cec_tx_struct {
+	wait_queue_head_t waitq;
+	atomic_t state;
+};
+
+extern struct cec_rx_struct cec_rx_struct;
+extern struct cec_tx_struct cec_tx_struct;
+
+void s5p_cec_set_divider(void);
+void s5p_cec_enable_rx(void);
+void s5p_cec_mask_rx_interrupts(void);
+void s5p_cec_unmask_rx_interrupts(void);
+void s5p_cec_mask_tx_interrupts(void);
+void s5p_cec_unmask_tx_interrupts(void);
+void s5p_cec_reset(void);
+void s5p_cec_tx_reset(void);
+void s5p_cec_rx_reset(void);
+void s5p_cec_threshold(void);
+void s5p_cec_set_tx_state(enum cec_state state);
+void s5p_cec_set_rx_state(enum cec_state state);
+void s5p_cec_copy_packet(char *data, size_t count);
+void s5p_cec_set_addr(u32 addr);
+u32 s5p_cec_get_status(void);
+void s5p_clr_pending_tx(void);
+void s5p_clr_pending_rx(void);
+void s5p_cec_get_rx_buf(u32 size, u8 *buffer);
+void __init s5p_cec_mem_probe(struct platform_device *pdev);
+
+/* for HDCP */
+
+extern int s5p_hdcp_encrypt_stop(bool on);
+extern int __init s5p_hdcp_init(void);
+extern int s5p_hdcp_start(void);
+extern int s5p_hdcp_stop(void);
+
+#endif /* __S5P_TVOUT_HW_IF_H_ */
diff --git a/drivers/media/video/s5p-tvout/hw_if/vp.c b/drivers/media/video/s5p-tvout/hw_if/vp.c
new file mode 100644
index 0000000..0d5e799
--- /dev/null
+++ b/drivers/media/video/s5p-tvout/hw_if/vp.c
@@ -0,0 +1,731 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Hardware interface functions for video processor
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/io.h>
+
+#include <mach/regs-vp.h>
+
+#include "../s5p_tvout_common_lib.h"
+#include "hw_if.h"
+
+#undef tvout_dbg
+
+#ifdef CONFIG_VP_DEBUG
+#define tvout_dbg(fmt, ...)					\
+		printk(KERN_INFO "\t[VP] %s(): " fmt,		\
+			__func__, ##__VA_ARGS__)
+#else
+#define tvout_dbg(fmt, ...)
+#endif
+
+/*
+ * Area for definitions to be used in only this file.
+ * This area can include #define, enum and struct defintition.
+ */
+#define H_RATIO(s_w, d_w) (((s_w) << 16) / (d_w))
+#define V_RATIO(s_h, d_h, ipc_2d) (((s_h) << ((ipc_2d) ? 17 : 16)) / (d_h))
+
+enum s5p_vp_poly_coeff {
+	VP_POLY8_Y0_LL = 0,
+	VP_POLY8_Y0_LH,
+	VP_POLY8_Y0_HL,
+	VP_POLY8_Y0_HH,
+	VP_POLY8_Y1_LL,
+	VP_POLY8_Y1_LH,
+	VP_POLY8_Y1_HL,
+	VP_POLY8_Y1_HH,
+	VP_POLY8_Y2_LL,
+	VP_POLY8_Y2_LH,
+	VP_POLY8_Y2_HL,
+	VP_POLY8_Y2_HH,
+	VP_POLY8_Y3_LL,
+	VP_POLY8_Y3_LH,
+	VP_POLY8_Y3_HL,
+	VP_POLY8_Y3_HH,
+	VP_POLY4_Y0_LL = 32,
+	VP_POLY4_Y0_LH,
+	VP_POLY4_Y0_HL,
+	VP_POLY4_Y0_HH,
+	VP_POLY4_Y1_LL,
+	VP_POLY4_Y1_LH,
+	VP_POLY4_Y1_HL,
+	VP_POLY4_Y1_HH,
+	VP_POLY4_Y2_LL,
+	VP_POLY4_Y2_LH,
+	VP_POLY4_Y2_HL,
+	VP_POLY4_Y2_HH,
+	VP_POLY4_Y3_LL,
+	VP_POLY4_Y3_LH,
+	VP_POLY4_Y3_HL,
+	VP_POLY4_Y3_HH,
+	VP_POLY4_C0_LL,
+	VP_POLY4_C0_LH,
+	VP_POLY4_C0_HL,
+	VP_POLY4_C0_HH,
+	VP_POLY4_C1_LL,
+	VP_POLY4_C1_LH,
+	VP_POLY4_C1_HL,
+	VP_POLY4_C1_HH
+};
+
+enum s5p_vp_filter_h_pp {
+	VP_PP_H_NORMAL,
+	VP_PP_H_8_9,
+	VP_PP_H_1_2,
+	VP_PP_H_1_3,
+	VP_PP_H_1_4
+};
+
+enum s5p_vp_filter_v_pp {
+	VP_PP_V_NORMAL,
+	VP_PP_V_5_6,
+	VP_PP_V_3_4,
+	VP_PP_V_1_2,
+	VP_PP_V_1_3,
+	VP_PP_V_1_4
+};
+
+/* Area for global variables to be used in only this file */
+
+static void __iomem *vp_base;
+
+/* Horizontal Y 8tap  */
+
+const signed char g_s_vp8tap_coef_y_h[] = {
+	/* VP_PP_H_NORMAL */
+	0,	0,	0,	0,	127,	0,	0,	0,
+	0,	1,	-2,	8,	126,	-6,	2,	-1,
+	0,	1,	-5,	16,	125,	-12,	4,	-1,
+	0,	2,	-8,	25,	121,	-16,	5,	-1,
+	-1,	3,	-10,	35,	114,	-18,	6,	-1,
+	-1,	4,	-13,	46,	107,	-20,	6,	-1,
+	-1,	5,	-16,	57,	99,	-21,	6,	-1,
+	-1,	5,	-18,	68,	89,	-20,	6,	-1,
+	-1,	6,	-20,	79,	79,	-20,	6,	-1,
+	-1,	6,	-20,	89,	68,	-18,	5,	-1,
+	-1,	6,	-21,	99,	57,	-16,	5,	-1,
+	-1,	6,	-20,	107,	46,	-13,	4,	-1,
+	-1,	6,	-18,	114,	35,	-10,	3,	-1,
+	-1,	5,	-16,	121,	25,	-8,	2,	0,
+	-1,	4,	-12,	125,	16,	-5,	1,	0,
+	-1,	2,	-6,	126,	8,	-2,	1,	0,
+
+	/* VP_PP_H_8_9 */
+	0,	3,	-7,	12,	112,	12,	-7,	3,
+	-1,	3,	-9,	19,	113,	6,	-5,	2,
+	-1,	3,	-11,	27,	111,	0,	-3,	2,
+	-1,	4,	-13,	35,	108,	-5,	-1,	1,
+	-1,	4,	-14,	43,	104,	-9,	0,	1,
+	-1,	5,	-16,	52,	99,	-12,	1,	0,
+	-1,	5,	-17,	61,	92,	-14,	2,	0,
+	0,	4,	-17,	69,	85,	-16,	3,	0,
+	0,	4,	-17,	77,	77,	-17,	4,	0,
+	0,	3,	-16,	85,	69,	-17,	4,	0,
+	0,	2,	-14,	92,	61,	-17,	5,	-1,
+	0,	1,	-12,	99,	52,	-16,	5,	-1,
+	1,	0,	-9,	104,	43,	-14,	4,	-1,
+	1,	-1,	-5,	108,	35,	-13,	4,	-1,
+	2,	-3,	0,	111,	27,	-11,	3,	-1,
+	2,	-5,	6,	113,	19,	-9,	3,	-1,
+
+	/* VP_PP_H_1_2 */
+	0,	-3,	0,	35,	64,	35,	0,	-3,
+	0,	-3,	1,	38,	64,	32,	-1,	-3,
+	0,	-3,	2,	41,	63,	29,	-2,	-2,
+	0,	-4,	4,	43,	63,	27,	-3,	-2,
+	0,	-4,	5,	46,	62,	24,	-3,	-2,
+	0,	-4,	7,	49,	60,	21,	-3,	-2,
+	-1,	-4,	9,	51,	59,	19,	-4,	-1,
+	-1,	-4,	12,	53,	57,	16,	-4,	-1,
+	-1,	-4,	14,	55,	55,	14,	-4,	-1,
+	-1,	-4,	16,	57,	53,	12,	-4,	-1,
+	-1,	-4,	19,	59,	51,	9,	-4,	-1,
+	-2,	-3,	21,	60,	49,	7,	-4,	0,
+	-2,	-3,	24,	62,	46,	5,	-4,	0,
+	-2,	-3,	27,	63,	43,	4,	-4,	0,
+	-2,	-2,	29,	63,	41,	2,	-3,	0,
+	-3,	-1,	32,	64,	38,	1,	-3,	0,
+
+	/* VP_PP_H_1_3 */
+	0,	0,	10,	32,	44,	32,	10,	0,
+	-1,	0,	11,	33,	45,	31,	9,	0,
+	-1,	0,	12,	35,	45,	29,	8,	0,
+	-1,	1,	13,	36,	44,	28,	7,	0,
+	-1,	1,	15,	37,	44,	26,	6,	0,
+	-1,	2,	16,	38,	43,	25,	5,	0,
+	-1,	2,	18,	39,	43,	23,	5,	-1,
+	-1,	3,	19,	40,	42,	22,	4,	-1,
+	-1,	3,	21,	41,	41,	21,	3,	-1,
+	-1,	4,	22,	42,	40,	19,	3,	-1,
+	-1,	5,	23,	43,	39,	18,	2,	-1,
+	0,	5,	25,	43,	38,	16,	2,	-1,
+	0,	6,	26,	44,	37,	15,	1,	-1,
+	0,	7,	28,	44,	36,	13,	1,	-1,
+	0,	8,	29,	45,	35,	12,	0,	-1,
+	0,	9,	31,	45,	33,	11,	0,	-1,
+
+	/* VP_PP_H_1_4 */
+	0,	2,	13,	30,	38,	30,	13,	2,
+	0,	3,	14,	30,	38,	29,	12,	2,
+	0,	3,	15,	31,	38,	28,	11,	2,
+	0,	4,	16,	32,	38,	27,	10,	1,
+	0,	4,	17,	33,	37,	26,	10,	1,
+	0,	5,	18,	34,	37,	24,	9,	1,
+	0,	5,	19,	34,	37,	24,	8,	1,
+	1,	6,	20,	35,	36,	22,	7,	1,
+	1,	6,	21,	36,	36,	21,	6,	1,
+	1,	7,	22,	36,	35,	20,	6,	1,
+	1,	8,	24,	37,	34,	19,	5,	0,
+	1,	9,	24,	37,	34,	18,	5,	0,
+	1,	10,	26,	37,	33,	17,	4,	0,
+	1,	10,	27,	38,	32,	16,	4,	0,
+	2,	11,	28,	38,	31,	15,	3,	0,
+	2,	12,	29,	38,	30,	14,	3,	0
+};
+
+/* Horizontal C 4tap */
+
+const signed char g_s_vp4tap_coef_c_h[] = {
+	/* VP_PP_H_NORMAL */
+	0,	0,	128,	0,	0,	5,	126,	-3,
+	-1,	11,	124,	-6,	-1,	19,	118,	-8,
+	-2,	27,	111,	-8,	-3,	37,	102,	-8,
+	-4,	48,	92,	-8,	-5,	59,	81,	-7,
+	-6,	70,	70,	-6,	-7,	81,	59,	-5,
+	-8,	92,	48,	-4,	-8,	102,	37,	-3,
+	-8,	111,	27,	-2,	-8,	118,	19,	-1,
+	-6,	124,	11,	-1,	-3,	126,	5,	0,
+
+	/* VP_PP_H_8_9 */
+	0,	8,	112,	8,	-1,	13,	113,	3,
+	-2,	19,	111,	0,	-2,	26,	107,	-3,
+	-3,	34,	101,	-4,	-3,	42,	94,	-5,
+	-4,	51,	86,	-5,	-5,	60,	78,	-5,
+	-5,	69,	69,	-5,	-5,	78,	60,	-5,
+	-5,	86,	51,	-4,	-5,	94,	42,	-3,
+	-4,	101,	34,	-3,	-3,	107,	26,	-2,
+	0,	111,	19,	-2,	3,	113,	13,	-1,
+
+	/* VP_PP_H_1_2 */
+	0,	26,	76,	26,	0,	30,	76,	22,
+	0,	34,	75,	19,	1,	38,	73,	16,
+	1,	43,	71,	13,	2,	47,	69,	10,
+	3,	51,	66,	8,	4,	55,	63,	6,
+	5,	59,	59,	5,	6,	63,	55,	4,
+	8,	66,	51,	3,	10,	69,	47,	2,
+	13,	71,	43,	1,	16,	73,	38,	1,
+	19,	75,	34,	0,	22,	76,	30,	0,
+
+	/* VP_PP_H_1_3 */
+	0,	30,	68,	30,	2,	33,	66,	27,
+	3,	36,	66,	23,	3,	39,	65,	21,
+	4,	43,	63,	18,	5,	46,	62,	15,
+	6,	49,	60,	13,	8,	52,	57,	11,
+	9,	55,	55,	9,	11,	57,	52,	8,
+	13,	60,	49,	6,	15,	62,	46,	5,
+	18,	63,	43,	4,	21,	65,	39,	3,
+	23,	66,	36,	3,	27,	66,	33,	2,
+
+	/*  VP_PP_H_1_4 */
+	0,	31,	66,	31,	3,	34,	63,	28,
+	4,	37,	62,	25,	4,	40,	62,	22,
+	5,	43,	61,	19,	6,	46,	59,	17,
+	7,	48,	58,	15,	9,	51,	55,	13,
+	11,	53,	53,	11,	13,	55,	51,	9,
+	15,	58,	48,	7,	17,	59,	46,	6,
+	19,	61,	43,	5,	22,	62,	40,	4,
+	25,	62,	37,	4,	28,	63,	34,	3,
+};
+
+/* Vertical Y 8tap  */
+
+const signed char g_s_vp4tap_coef_y_v[] = {
+	/* VP_PP_V_NORMAL  */
+	0,	0,	127,	0,	0,	5,	126,	-3,
+	-1,	11,	124,	-6,	-1,	19,	118,	-8,
+	-2,	27,	111,	-8,	-3,	37,	102,	-8,
+	-4,	48,	92,	-8,	-5,	59,	81,	-7,
+	-6,	70,	70,	-6,	-7,	81,	59,	-5,
+	-8,	92,	48,	-4,	-8,	102,	37,	-3,
+	-8,	111,	27,	-2,	-8,	118,	19,	-1,
+	-6,	124,	11,	-1,	-3,	126,	5,	0,
+
+	/* VP_PP_V_5_6  */
+	0,	11,	106,	11,	-2,	16,	107,	7,
+	-2,	22,	105,	3,	-2,	29,	101,	0,
+	-3,	36,	96,	-1,	-3,	44,	90,	-3,
+	-4,	52,	84,	-4,	-4,	60,	76,	-4,
+	-4,	68,	68,	-4,	-4,	76,	60,	-4,
+	-4,	84,	52,	-4,	-3,	90,	44,	-3,
+	-1,	96,	36,	-3,	0,	101,	29,	-2,
+	3,	105,	22,	-2,	7,	107,	16,	-2,
+
+	/* VP_PP_V_3_4  */
+	0,	15,	98,	15,	-2,	21,	97,	12,
+	-2,	26,	96,	8,	-2,	32,	93,	5,
+	-2,	39,	89,	2,	-2,	46,	84,	0,
+	-3,	53,	79,	-1,	-2,	59,	73,	-2,
+	-2,	66,	66,	-2,	-2,	73,	59,	-2,
+	-1,	79,	53,	-3,	0,	84,	46,	-2,
+	2,	89,	39,	-2,	5,	93,	32,	-2,
+	8,	96,	26,	-2,	12,	97,	21,	-2,
+
+	/* VP_PP_V_1_2  */
+	0,	26,	76,	26,	0,	30,	76,	22,
+	0,	34,	75,	19,	1,	38,	73,	16,
+	1,	43,	71,	13,	2,	47,	69,	10,
+	3,	51,	66,	8,	4,	55,	63,	6,
+	5,	59,	59,	5,	6,	63,	55,	4,
+	8,	66,	51,	3,	10,	69,	47,	2,
+	13,	71,	43,	1,	16,	73,	38,	1,
+	19,	75,	34,	0,	22,	76,	30,	0,
+
+	/* VP_PP_V_1_3  */
+	0,	30,	68,	30,	2,	33,	66,	27,
+	3,	36,	66,	23,	3,	39,	65,	21,
+	4,	43,	63,	18,	5,	46,	62,	15,
+	6,	49,	60,	13,	8,	52,	57,	11,
+	9,	55,	55,	9,	11,	57,	52,	8,
+	13,	60,	49,	6,	15,	62,	46,	5,
+	18,	63,	43,	4,	21,	65,	39,	3,
+	23,	66,	36,	3,	27,	66,	33,	2,
+
+	/* VP_PP_V_1_4  */
+	0,	31,	66,	31,	3,	34,	63,	28,
+	4,	37,	62,	25,	4,	40,	62,	22,
+	5,	43,	61,	19,	6,	46,	59,	17,
+	7,	48,	58,	15,	9,	51,	55,	13,
+	11,	53,	53,	11,	13,	55,	51,	9,
+	15,	58,	48,	7,	17,	59,	46,	6,
+	19,	61,	43,	5,	22,	62,	40,	4,
+	25,	62,	37,	4,	28,	63,	34,	3
+};
+
+/*
+ * Area for functions to be used in only this file.
+ * Functions of this area are defined by static
+ */
+
+static int s5p_vp_set_poly_filter_coef(
+		enum s5p_vp_poly_coeff poly_coeff,
+		signed char ch0, signed char ch1,
+		signed char ch2, signed char ch3)
+{
+	if (poly_coeff > VP_POLY4_C1_HH || poly_coeff < VP_POLY8_Y0_LL ||
+	   (poly_coeff > VP_POLY8_Y3_HH && poly_coeff < VP_POLY4_Y0_LL)) {
+		tvout_err("invaild poly_coeff parameter\n");
+
+		return -1;
+	}
+
+	writel((((0xff & ch0) << 24) | ((0xff & ch1) << 16) |
+		((0xff & ch2) << 8) | (0xff & ch3)),
+			vp_base + S5P_VP_POLY8_Y0_LL + poly_coeff * 4);
+
+	return 0;
+}
+
+/*
+ * Area for functions to be used by other files.
+ * Functions of this area must be defined in header file.
+ */
+
+void s5p_vp_set_poly_filter_coef_default(
+		u32 src_width, u32 src_height,
+		u32 dst_width, u32 dst_height, bool ipc_2d)
+{
+	enum s5p_vp_filter_h_pp e_h_filter;
+	enum s5p_vp_filter_v_pp e_v_filter;
+	u8 *poly_flt_coeff;
+	int i, j;
+
+	u32 h_ratio = H_RATIO(src_width, dst_width);
+	u32 v_ratio = V_RATIO(src_height, dst_height, ipc_2d);
+
+	/*
+	 * For the real interlace mode, the vertical ratio should be
+	 * used after divided by 2. Because in the interlace mode, all
+	 * the VP output is used for SDOUT display and it should be the
+	 * same as one field of the progressive mode. Therefore the same
+	 * filter coefficients should be used for the same the final
+	 * output video. When half of the interlace V_RATIO is same as
+	 * the progressive V_RATIO, the final output video scale is same.
+	 */
+
+	if (h_ratio <= (0x1 << 16))		/* 720->720 or zoom in */
+		e_h_filter = VP_PP_H_NORMAL;
+	else if (h_ratio <= (0x9 << 13))	/* 720->640 */
+		e_h_filter = VP_PP_H_8_9;
+	else if (h_ratio <= (0x1 << 17))	/* 2->1 */
+		e_h_filter = VP_PP_H_1_2;
+	else if (h_ratio <= (0x3 << 16))	/* 2->1 */
+		e_h_filter = VP_PP_H_1_3;
+	else
+		e_h_filter = VP_PP_H_1_4;	/* 4->1 */
+
+	/* Vertical Y 4tap */
+
+	if (v_ratio <= (0x1 << 16))		/* 720->720 or zoom in*/
+		e_v_filter = VP_PP_V_NORMAL;
+	else if (v_ratio <= (0x5 << 14))	/* 4->3*/
+		e_v_filter = VP_PP_V_3_4;
+	else if (v_ratio <= (0x3 << 15))	/*6->5*/
+		e_v_filter = VP_PP_V_5_6;
+	else if (v_ratio <= (0x1 << 17))	/* 2->1*/
+		e_v_filter = VP_PP_V_1_2;
+	else if (v_ratio <= (0x3 << 16))	/* 3->1*/
+		e_v_filter = VP_PP_V_1_3;
+	else
+		e_v_filter = VP_PP_V_1_4;
+
+	poly_flt_coeff = (u8 *)(g_s_vp8tap_coef_y_h + e_h_filter * 16 * 8);
+
+	for (i = 0; i < 4; i++) {
+		for (j = 0; j < 4; j++) {
+			s5p_vp_set_poly_filter_coef(
+				VP_POLY8_Y0_LL + (i*4) + j,
+				*(poly_flt_coeff + 4*j*8 + (7 - i)),
+				*(poly_flt_coeff + (4*j + 1)*8 + (7 - i)),
+				*(poly_flt_coeff + (4*j + 2)*8 + (7 - i)),
+				*(poly_flt_coeff + (4*j + 3)*8 + (7 - i)));
+		}
+	}
+
+	poly_flt_coeff = (u8 *)(g_s_vp4tap_coef_c_h + e_h_filter * 16 * 4);
+
+	for (i = 0; i < 2; i++) {
+		for (j = 0; j < 4; j++) {
+			s5p_vp_set_poly_filter_coef(
+				VP_POLY4_C0_LL + (i*4) + j,
+				*(poly_flt_coeff + 4*j*4 + (3 - i)),
+				*(poly_flt_coeff + (4*j + 1)*4 + (3 - i)),
+				*(poly_flt_coeff + (4*j + 2)*4 + (3 - i)),
+				*(poly_flt_coeff + (4*j + 3)*4 + (3 - i)));
+		}
+	}
+
+	poly_flt_coeff = (u8 *)(g_s_vp4tap_coef_y_v + e_v_filter * 16 * 4);
+
+	for (i = 0; i < 4; i++) {
+		for (j = 0; j < 4; j++) {
+			s5p_vp_set_poly_filter_coef(
+				VP_POLY4_Y0_LL + (i*4) + j,
+				*(poly_flt_coeff + 4*j*4 + (3 - i)),
+				*(poly_flt_coeff + (4*j + 1)*4 + (3 - i)),
+				*(poly_flt_coeff + (4*j + 2)*4 + (3 - i)),
+				*(poly_flt_coeff + (4*j + 3)*4 + (3 - i)));
+		}
+	}
+}
+
+void s5p_vp_set_field_id(enum s5p_vp_field mode)
+{
+	writel((mode == VP_TOP_FIELD) ? VP_TOP_FIELD : VP_BOTTOM_FIELD,
+		vp_base + S5P_VP_FIELD_ID);
+}
+
+int s5p_vp_set_top_field_address(u32 top_y_addr, u32 top_c_addr)
+{
+	if (S5P_VP_PTR_ILLEGAL(top_y_addr) || S5P_VP_PTR_ILLEGAL(top_c_addr)) {
+		tvout_err("address is not double word align = 0x%x, 0x%x\n",
+			top_y_addr, top_c_addr);
+
+		return -1;
+	}
+
+	writel(top_y_addr, vp_base + S5P_VP_TOP_Y_PTR);
+	writel(top_c_addr, vp_base + S5P_VP_TOP_C_PTR);
+
+	return 0;
+}
+
+int s5p_vp_set_bottom_field_address(u32 bottom_y_addr, u32 bottom_c_addr)
+{
+	if (S5P_VP_PTR_ILLEGAL(bottom_y_addr) ||
+			S5P_VP_PTR_ILLEGAL(bottom_c_addr)) {
+		tvout_err("address is not double word align = 0x%x, 0x%x\n",
+			bottom_y_addr, bottom_c_addr);
+
+		return -1;
+	}
+
+	writel(bottom_y_addr, vp_base + S5P_VP_BOT_Y_PTR);
+	writel(bottom_c_addr, vp_base + S5P_VP_BOT_C_PTR);
+
+	return 0;
+}
+
+int s5p_vp_set_img_size(u32 img_width, u32 img_height)
+{
+	if (S5P_VP_IMG_SIZE_ILLEGAL(img_width) ||
+			S5P_VP_IMG_SIZE_ILLEGAL(img_height)) {
+		tvout_err("full image size is not double word align ="
+			"%d, %d\n", img_width, img_height);
+
+		return -1;
+	}
+
+	writel(S5P_VP_IMG_HSIZE(img_width) | S5P_VP_IMG_VSIZE(img_height),
+		vp_base + S5P_VP_IMG_SIZE_Y);
+	writel(S5P_VP_IMG_HSIZE(img_width) | S5P_VP_IMG_VSIZE(img_height / 2),
+		vp_base + S5P_VP_IMG_SIZE_C);
+
+	return 0;
+}
+
+void s5p_vp_set_src_position(u32 src_off_x, u32 src_x_fract_step, u32 src_off_y)
+{
+	writel(S5P_VP_SRC_H_POSITION_VAL(src_off_x) |
+		S5P_VP_SRC_X_FRACT_STEP(src_x_fract_step),
+			vp_base + S5P_VP_SRC_H_POSITION);
+	writel(S5P_VP_SRC_V_POSITION_VAL(src_off_y),
+			vp_base + S5P_VP_SRC_V_POSITION);
+}
+
+void s5p_vp_set_dest_position(u32 dst_off_x, u32 dst_off_y)
+{
+	writel(S5P_VP_DST_H_POSITION_VAL(dst_off_x),
+			vp_base + S5P_VP_DST_H_POSITION);
+	writel(S5P_VP_DST_V_POSITION_VAL(dst_off_y),
+			vp_base + S5P_VP_DST_V_POSITION);
+}
+
+void s5p_vp_set_src_dest_size(u32 src_width, u32 src_height,
+			      u32 dst_width, u32 dst_height, bool ipc_2d)
+{
+	u32 h_ratio = H_RATIO(src_width, dst_width);
+	u32 v_ratio = V_RATIO(src_height, dst_height, ipc_2d);
+
+	writel(S5P_VP_SRC_WIDTH_VAL(src_width), vp_base + S5P_VP_SRC_WIDTH);
+	writel(S5P_VP_SRC_HEIGHT_VAL(src_height), vp_base + S5P_VP_SRC_HEIGHT);
+	writel(S5P_VP_DST_WIDTH_VAL(dst_width), vp_base + S5P_VP_DST_WIDTH);
+	writel(S5P_VP_DST_HEIGHT_VAL(dst_height), vp_base + S5P_VP_DST_HEIGHT);
+	writel(S5P_VP_H_RATIO_VAL(h_ratio), vp_base + S5P_VP_H_RATIO);
+	writel(S5P_VP_V_RATIO_VAL(v_ratio), vp_base + S5P_VP_V_RATIO);
+
+	writel((ipc_2d) ?
+		(readl(vp_base + S5P_VP_MODE) | S5P_VP_MODE_2D_IPC_ENABLE) :
+		(readl(vp_base + S5P_VP_MODE) & ~S5P_VP_MODE_2D_IPC_ENABLE),
+		vp_base + S5P_VP_MODE);
+}
+
+void s5p_vp_set_op_mode(bool line_skip, enum s5p_vp_mem_type mem_type,
+			enum s5p_vp_mem_mode mem_mode,
+			enum s5p_vp_chroma_expansion chroma_exp,
+			bool auto_toggling)
+{
+	u32 temp_reg;
+
+	temp_reg = (mem_type) ?
+			S5P_VP_MODE_IMG_TYPE_YUV420_NV21 : S5P_VP_MODE_IMG_TYPE_YUV420_NV12;
+	temp_reg |= (line_skip) ?
+			S5P_VP_MODE_LINE_SKIP_ON : S5P_VP_MODE_LINE_SKIP_OFF;
+	temp_reg |= (mem_mode == VP_2D_TILE_MODE) ?
+			S5P_VP_MODE_MEM_MODE_2D_TILE :
+			S5P_VP_MODE_MEM_MODE_LINEAR;
+	temp_reg |= (chroma_exp == VP_C_TOP_BOTTOM) ?
+			S5P_VP_MODE_CROMA_EXP_C_TOPBOTTOM_PTR :
+			S5P_VP_MODE_CROMA_EXP_C_TOP_PTR;
+	temp_reg |= (auto_toggling) ?
+			S5P_VP_MODE_FIELD_ID_AUTO_TOGGLING :
+			S5P_VP_MODE_FIELD_ID_MAN_TOGGLING;
+
+	writel(temp_reg, vp_base + S5P_VP_MODE);
+}
+
+void s5p_vp_set_pixel_rate_control(enum s5p_vp_pxl_rate rate)
+{
+	writel(S5P_VP_PEL_RATE_CTRL(rate), vp_base + S5P_VP_PER_RATE_CTRL);
+}
+
+void s5p_vp_set_endian(enum s5p_tvout_endian endian)
+{
+	writel(endian, vp_base + S5P_VP_ENDIAN_MODE);
+}
+
+void s5p_vp_set_bypass_post_process(bool bypass)
+{
+	writel((bypass) ? S5P_VP_BY_PASS_ENABLE : S5P_VP_BY_PASS_DISABLE,
+			vp_base + S5P_PP_BYPASS);
+}
+
+void s5p_vp_set_saturation(u32 sat)
+{
+	writel(S5P_VP_SATURATION(sat), vp_base + S5P_PP_SATURATION);
+}
+
+void s5p_vp_set_sharpness(u32 th_h_noise,
+			  enum s5p_vp_sharpness_control sharpness)
+{
+	writel(S5P_VP_TH_HNOISE(th_h_noise) | S5P_VP_SHARPNESS(sharpness),
+			vp_base + S5P_PP_SHARPNESS);
+}
+
+void s5p_vp_set_brightness_contrast(u16 b, u8 c)
+{
+	int i;
+
+	for (i = 0; i < 8; i++)
+		writel(S5P_VP_LINE_INTC(b) | S5P_VP_LINE_SLOPE(c),
+			vp_base + S5P_PP_LINE_EQ0 + i*4);
+}
+
+void s5p_vp_set_brightness_offset(u32 offset)
+{
+	writel(S5P_VP_BRIGHT_OFFSET(offset), vp_base + S5P_PP_BRIGHT_OFFSET);
+}
+
+int s5p_vp_set_brightness_contrast_control(enum s5p_vp_line_eq eq_num,
+					   u32 intc, u32 slope)
+{
+	if (eq_num > VP_LINE_EQ_7 || eq_num < VP_LINE_EQ_0) {
+		tvout_err("invaild eq_num parameter\n");
+
+		return -1;
+	}
+
+	writel(S5P_VP_LINE_INTC(intc) | S5P_VP_LINE_SLOPE(slope),
+	       vp_base + S5P_PP_LINE_EQ0 + eq_num*4);
+
+	return 0;
+}
+
+void s5p_vp_set_csc_control(bool sub_y_offset_en, bool csc_en)
+{
+	u32 temp_reg;
+
+	temp_reg = (sub_y_offset_en) ? S5P_VP_SUB_Y_OFFSET_ENABLE :
+					S5P_VP_SUB_Y_OFFSET_DISABLE;
+	temp_reg |= (csc_en) ? S5P_VP_CSC_ENABLE : S5P_VP_CSC_DISABLE;
+
+	writel(temp_reg, vp_base + S5P_PP_CSC_EN);
+}
+
+int s5p_vp_set_csc_coef(enum s5p_vp_csc_coeff csc_coeff, u32 coeff)
+{
+	if (csc_coeff > VP_CSC_CR2CR_COEF ||
+			csc_coeff < VP_CSC_Y2Y_COEF) {
+		tvout_err("invaild csc_coeff parameter\n");
+
+		return -1;
+	}
+
+	writel(S5P_PP_CSC_COEF(coeff),
+			vp_base + S5P_PP_CSC_Y2Y_COEF + csc_coeff*4);
+
+	return 0;
+}
+
+int s5p_vp_set_csc_coef_default(enum s5p_vp_csc_type csc_type)
+{
+	switch (csc_type) {
+	case VP_CSC_SD_HD:
+		writel(S5P_PP_Y2Y_COEF_601_TO_709,
+				vp_base + S5P_PP_CSC_Y2Y_COEF);
+		writel(S5P_PP_CB2Y_COEF_601_TO_709,
+				vp_base + S5P_PP_CSC_CB2Y_COEF);
+		writel(S5P_PP_CR2Y_COEF_601_TO_709,
+				vp_base + S5P_PP_CSC_CR2Y_COEF);
+		writel(S5P_PP_Y2CB_COEF_601_TO_709,
+				vp_base + S5P_PP_CSC_Y2CB_COEF);
+		writel(S5P_PP_CB2CB_COEF_601_TO_709,
+				vp_base + S5P_PP_CSC_CB2CB_COEF);
+		writel(S5P_PP_CR2CB_COEF_601_TO_709,
+				vp_base + S5P_PP_CSC_CR2CB_COEF);
+		writel(S5P_PP_Y2CR_COEF_601_TO_709,
+				vp_base + S5P_PP_CSC_Y2CR_COEF);
+		writel(S5P_PP_CB2CR_COEF_601_TO_709,
+				vp_base + S5P_PP_CSC_CB2CR_COEF);
+		writel(S5P_PP_CR2CR_COEF_601_TO_709,
+				vp_base + S5P_PP_CSC_CR2CR_COEF);
+		break;
+
+	case VP_CSC_HD_SD:
+		writel(S5P_PP_Y2Y_COEF_709_TO_601,
+				vp_base + S5P_PP_CSC_Y2Y_COEF);
+		writel(S5P_PP_CB2Y_COEF_709_TO_601,
+				vp_base + S5P_PP_CSC_CB2Y_COEF);
+		writel(S5P_PP_CR2Y_COEF_709_TO_601,
+				vp_base + S5P_PP_CSC_CR2Y_COEF);
+		writel(S5P_PP_Y2CB_COEF_709_TO_601,
+				vp_base + S5P_PP_CSC_Y2CB_COEF);
+		writel(S5P_PP_CB2CB_COEF_709_TO_601,
+				vp_base + S5P_PP_CSC_CB2CB_COEF);
+		writel(S5P_PP_CR2CB_COEF_709_TO_601,
+				vp_base + S5P_PP_CSC_CR2CB_COEF);
+		writel(S5P_PP_Y2CR_COEF_709_TO_601,
+				vp_base + S5P_PP_CSC_Y2CR_COEF);
+		writel(S5P_PP_CB2CR_COEF_709_TO_601,
+				vp_base + S5P_PP_CSC_CB2CR_COEF);
+		writel(S5P_PP_CR2CR_COEF_709_TO_601,
+				vp_base + S5P_PP_CSC_CR2CR_COEF);
+		break;
+
+	default:
+		tvout_err("invalid csc_type parameter = %d\n", csc_type);
+		return -1;
+	}
+
+	return 0;
+}
+
+int s5p_vp_update(void)
+{
+	writel(readl(vp_base + S5P_VP_SHADOW_UPDATE) |
+		S5P_VP_SHADOW_UPDATE_ENABLE,
+			vp_base + S5P_VP_SHADOW_UPDATE);
+
+	return 0;
+}
+
+int s5p_vp_get_update_status(void)
+{
+	if (readl(vp_base + S5P_VP_SHADOW_UPDATE) & S5P_VP_SHADOW_UPDATE_ENABLE)
+		return 0;
+	else
+		return -1;
+}
+
+void s5p_vp_sw_reset(void)
+{
+	writel((readl(vp_base + S5P_VP_SRESET) | S5P_VP_SRESET_PROCESSING),
+		vp_base + S5P_VP_SRESET);
+
+	while (readl(vp_base + S5P_VP_SRESET) & S5P_VP_SRESET_PROCESSING)
+		msleep(20);
+}
+
+int s5p_vp_start(void)
+{
+	writel(S5P_VP_ENABLE_ON, vp_base + S5P_VP_ENABLE);
+
+	s5p_vp_update();
+
+	return 0;
+}
+
+int s5p_vp_stop(void)
+{
+	writel((readl(vp_base + S5P_VP_ENABLE) & ~S5P_VP_ENABLE_ON),
+		vp_base + S5P_VP_ENABLE);
+
+	s5p_vp_update();
+
+	while (!(readl(vp_base + S5P_VP_ENABLE) & S5P_VP_ENABLE_OPERATING))
+		msleep(20);
+
+	return 0;
+}
+
+void s5p_vp_init(void __iomem *addr)
+{
+	vp_base = addr;
+}
diff --git a/drivers/media/video/s5p-tvout/s5p_tvout.c b/drivers/media/video/s5p-tvout/s5p_tvout.c
new file mode 100644
index 0000000..2e67bbb
--- /dev/null
+++ b/drivers/media/video/s5p-tvout/s5p_tvout.c
@@ -0,0 +1,210 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * S5P TVOUT driver main
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/mm.h>
+
+#include "s5p_tvout_common_lib.h"
+#include "s5p_tvout_ctrl.h"
+#include "s5p_tvout_fb.h"
+#include "s5p_tvout_v4l2.h"
+
+#define TV_CLK_GET_WITH_ERR_CHECK(clk, pdev, clk_name)			\
+		do {							\
+			clk = clk_get(&pdev->dev, clk_name);		\
+			if (IS_ERR(clk)) {				\
+				printk(KERN_ERR				\
+				"failed to find clock %s\n", clk_name);	\
+				return -ENOENT;				\
+			}						\
+		} while (0);
+
+struct s5p_tvout_status s5ptv_status;
+
+static int __devinit s5p_tvout_clk_get(struct platform_device *pdev,
+				       struct s5p_tvout_status *ctrl)
+{
+	struct clk *ext_xtal_clk, *mout_vpll_src, *fout_vpll, *mout_vpll;
+
+	TV_CLK_GET_WITH_ERR_CHECK(ctrl->i2c_phy_clk,	pdev, "i2c-hdmiphy");
+
+	TV_CLK_GET_WITH_ERR_CHECK(ctrl->sclk_dac,	pdev, "sclk_dac");
+	TV_CLK_GET_WITH_ERR_CHECK(ctrl->sclk_hdmi,	pdev, "sclk_hdmi");
+
+	TV_CLK_GET_WITH_ERR_CHECK(ctrl->sclk_pixel,	pdev, "sclk_pixel");
+	TV_CLK_GET_WITH_ERR_CHECK(ctrl->sclk_hdmiphy,	pdev, "sclk_hdmiphy");
+
+	TV_CLK_GET_WITH_ERR_CHECK(ext_xtal_clk,		pdev, "ext_xtal");
+	TV_CLK_GET_WITH_ERR_CHECK(mout_vpll_src,	pdev, "vpll_src");
+	TV_CLK_GET_WITH_ERR_CHECK(fout_vpll,		pdev, "fout_vpll");
+	TV_CLK_GET_WITH_ERR_CHECK(mout_vpll,		pdev, "sclk_vpll");
+
+	if (clk_set_rate(fout_vpll, 54000000) < 0)
+		return -1;
+
+	if (clk_set_parent(mout_vpll_src, ext_xtal_clk) < 0)
+		return -1;
+
+	if (clk_set_parent(mout_vpll, fout_vpll) < 0)
+		return -1;
+
+	/* sclk_dac's parent is fixed as mout_vpll */
+	if (clk_set_parent(ctrl->sclk_dac, mout_vpll) < 0)
+		return -1;
+
+	/* It'll be moved in the future */
+	if (clk_enable(ctrl->i2c_phy_clk) < 0)
+		return -1;
+
+	if (clk_enable(mout_vpll_src) < 0)
+		return -1;
+
+	if (clk_enable(fout_vpll) < 0)
+		return -1;
+
+	if (clk_enable(mout_vpll) < 0)
+		return -1;
+
+	clk_put(ext_xtal_clk);
+	clk_put(mout_vpll_src);
+	clk_put(fout_vpll);
+	clk_put(mout_vpll);
+
+	return 0;
+}
+
+static int __devinit s5p_tvout_probe(struct platform_device *pdev)
+{
+	s5p_tvout_pm_runtime_enable(&pdev->dev);
+
+	/* The feature of System MMU will be turned on later */
+
+	if (s5p_tvout_clk_get(pdev, &s5ptv_status) < 0)
+		return -ENODEV;
+
+	if (s5p_vp_ctrl_constructor(pdev) < 0)
+		return -ENODEV;
+
+	/*
+	 * s5p_mixer_ctrl_constructor() must be
+	 * called before s5p_tvif_ctrl_constructor
+	 */
+	if (s5p_mixer_ctrl_constructor(pdev) < 0)
+		return -ENODEV;
+
+	if (s5p_tvif_ctrl_constructor(pdev) < 0)
+		return -ENODEV;
+
+	if (s5p_tvout_v4l2_constructor(pdev) < 0)
+		return -ENODEV;
+
+	if (s5p_tvif_ctrl_start(TVOUT_720P_60, TVOUT_HDMI) < 0)
+		return -ENODEV;
+
+	/* prepare memory */
+	if (s5p_tvout_fb_alloc_framebuffer(&pdev->dev))
+		return -ENODEV;
+
+	if (s5p_tvout_fb_register_framebuffer(&pdev->dev))
+		return -ENODEV;
+
+	return 0;
+}
+
+static void s5p_tvout_remove(struct platform_device *pdev)
+{
+	s5p_vp_ctrl_destructor();
+	s5p_tvif_ctrl_destructor();
+	s5p_mixer_ctrl_destructor();
+
+	s5p_tvout_v4l2_destructor();
+
+	clk_disable(s5ptv_status.sclk_hdmi);
+
+	clk_put(s5ptv_status.sclk_hdmi);
+	clk_put(s5ptv_status.sclk_dac);
+	clk_put(s5ptv_status.sclk_pixel);
+	clk_put(s5ptv_status.sclk_hdmiphy);
+
+	s5p_tvout_pm_runtime_disable(&pdev->dev);
+}
+
+#ifdef CONFIG_PM
+static int s5p_tvout_suspend(struct device *dev)
+{
+	s5p_vp_ctrl_suspend();
+	s5p_mixer_ctrl_suspend();
+	s5p_tvif_ctrl_suspend();
+
+	return 0;
+}
+
+static int s5p_tvout_resume(struct device *dev)
+{
+	s5p_tvif_ctrl_resume();
+	s5p_mixer_ctrl_resume();
+	s5p_vp_ctrl_resume();
+
+	return 0;
+}
+
+static int s5p_tvout_runtime_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static int s5p_tvout_runtime_resume(struct device *dev)
+{
+	return 0;
+}
+
+#else
+#define s5p_tvout_suspend		NULL
+#define s5p_tvout_resume		NULL
+#define s5p_tvout_runtime_suspend	NULL
+#define s5p_tvout_runtime_resume	NULL
+#endif
+
+static const struct dev_pm_ops s5p_tvout_pm_ops = {
+	.suspend		= s5p_tvout_suspend,
+	.resume			= s5p_tvout_resume,
+	.runtime_suspend	= s5p_tvout_runtime_suspend,
+	.runtime_resume		= s5p_tvout_runtime_resume
+};
+
+static struct platform_driver s5p_tvout_driver = {
+	.probe		=  s5p_tvout_probe,
+	.remove		=  s5p_tvout_remove,
+	.driver		=  {
+		.name		= "s5p-tvout",
+		.owner		= THIS_MODULE,
+		.pm		= &s5p_tvout_pm_ops
+	},
+};
+
+static int __init s5p_tvout_init(void)
+{
+	printk(KERN_INFO "S5P TVOUT Driver, Copyright (c) 2011 Samsung Electronics Co., LTD.\n");
+
+	return platform_driver_register(&s5p_tvout_driver);
+}
+
+static void __exit s5p_tvout_exit(void)
+{
+	platform_driver_unregister(&s5p_tvout_driver);
+}
+late_initcall(s5p_tvout_init);
+module_exit(s5p_tvout_exit);
+
+MODULE_AUTHOR("Jiun Yu <jiun.yu@samsung.com>");
+MODULE_DESCRIPTION("Samsung S5P TVOUT driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/s5p-tvout/s5p_tvout_common_lib.c b/drivers/media/video/s5p-tvout/s5p_tvout_common_lib.c
new file mode 100644
index 0000000..550efe0
--- /dev/null
+++ b/drivers/media/video/s5p-tvout/s5p_tvout_common_lib.c
@@ -0,0 +1,99 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Common library for SAMSUNG S5P TVOUT driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+
+#include <linux/pm_runtime.h>
+
+#include "s5p_tvout_common_lib.h"
+
+int s5p_tvout_map_resource_mem(struct platform_device *pdev, char *name,
+			       void __iomem **base, struct resource **res)
+{
+	size_t		size;
+	void __iomem	*tmp_base;
+	struct resource	*tmp_res;
+
+	tmp_res = platform_get_resource_byname(pdev, IORESOURCE_MEM, name);
+
+	if (!tmp_res)
+		goto not_found;
+
+	size = resource_size(tmp_res);
+
+	tmp_res = request_mem_region(tmp_res->start, size, tmp_res->name);
+
+	if (!tmp_res) {
+		tvout_err("%s: fail to get memory region\n", __func__);
+		goto err_on_request_mem_region;
+	}
+
+	tmp_base = ioremap(tmp_res->start, size);
+
+	if (!tmp_base) {
+		tvout_err("%s: fail to ioremap address region\n", __func__);
+		goto err_on_ioremap;
+	}
+
+	*res = tmp_res;
+	*base = tmp_base;
+	return 0;
+
+err_on_ioremap:
+	release_resource(tmp_res);
+	kfree(tmp_res);
+
+err_on_request_mem_region:
+	return -ENXIO;
+
+not_found:
+	tvout_err("%s: fail to get IORESOURCE_MEM for %s\n", __func__, name);
+	return -ENODEV;
+}
+
+void s5p_tvout_unmap_resource_mem(void __iomem *base, struct resource *res)
+{
+	if (!base)
+		iounmap(base);
+
+	if (res != NULL) {
+		release_resource(res);
+		kfree(res);
+	}
+}
+
+/* Libraries for runtime PM */
+
+static struct device	*s5p_tvout_dev;
+
+void s5p_tvout_pm_runtime_enable(struct device *dev)
+{
+	pm_runtime_enable(dev);
+
+	s5p_tvout_dev = dev;
+}
+
+void s5p_tvout_pm_runtime_disable(struct device *dev)
+{
+	pm_runtime_disable(dev);
+}
+
+void s5p_tvout_pm_runtime_get(void)
+{
+	pm_runtime_get_sync(s5p_tvout_dev);
+}
+
+void s5p_tvout_pm_runtime_put(void)
+{
+	pm_runtime_put_sync(s5p_tvout_dev);
+}
diff --git a/drivers/media/video/s5p-tvout/s5p_tvout_common_lib.h b/drivers/media/video/s5p-tvout/s5p_tvout_common_lib.h
new file mode 100644
index 0000000..7e87a03
--- /dev/null
+++ b/drivers/media/video/s5p-tvout/s5p_tvout_common_lib.h
@@ -0,0 +1,187 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Header file of common library for SAMSUNG S5P TVOUT driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef __S5P_TVOUT_COMMON_LIB_H_
+#define __S5P_TVOUT_COMMON_LIB_H_ __FILE__
+
+#include <linux/stddef.h>
+#include <linux/platform_device.h>
+#include <linux/videodev2.h>
+#include <linux/interrupt.h>
+
+/*
+ * This file includes declarations for TVOUT driver's common library.
+ * All files in TVOUT driver can access function or definition in this file.
+ */
+
+#define DRV_NAME	"S5P-TVOUT"
+
+#define tvout_err(fmt, ...)					\
+		printk(KERN_ERR "[%s] %s(): " fmt,		\
+			DRV_NAME, __func__, ##__VA_ARGS__)
+
+#ifndef tvout_dbg
+#ifdef CONFIG_S5P_TVOUT_DEBUG
+#define tvout_dbg(fmt, ...)					\
+		printk(KERN_INFO "[%s] %s(): " fmt,		\
+			DRV_NAME, __func__, ##__VA_ARGS__)
+#else
+#define tvout_dbg(fmt, ...)
+#endif
+#endif
+
+#define S5PTV_FB_CNT		2
+#define HDMI_START_NUM		0x1000
+
+#define to_tvout_plat(d) (to_platform_device(d)->dev.platform_data)
+
+enum s5p_tvout_disp_mode {
+	TVOUT_NTSC_M,
+	TVOUT_PAL_BDGHI,
+	TVOUT_PAL_M,
+	TVOUT_PAL_N,
+	TVOUT_PAL_NC,
+	TVOUT_PAL_60,
+	TVOUT_NTSC_443,
+
+	TVOUT_480P_60_16_9 = HDMI_START_NUM,
+	TVOUT_480P_60_4_3,
+	TVOUT_480P_59,
+
+	TVOUT_576P_50_16_9,
+	TVOUT_576P_50_4_3,
+
+	TVOUT_720P_60,
+	TVOUT_720P_50,
+	TVOUT_720P_59,
+
+	TVOUT_1080P_60,
+	TVOUT_1080P_50,
+	TVOUT_1080P_59,
+	TVOUT_1080P_30,
+
+	TVOUT_1080I_60,
+	TVOUT_1080I_50,
+	TVOUT_1080I_59,
+	TVOUT_INIT_DISP_VALUE
+};
+
+enum s5p_tvout_o_mode {
+	TVOUT_COMPOSITE,
+	TVOUT_HDMI,
+	TVOUT_HDMI_RGB,
+	TVOUT_DVI,
+	TVOUT_INIT_O_VALUE
+};
+
+enum s5p_mixer_burst_mode {
+	MIXER_BURST_8,
+	MIXER_BURST_16,
+};
+
+enum s5ptvfb_data_path_t {
+	DATA_PATH_FIFO,
+	DATA_PATH_DMA,
+};
+
+enum s5ptvfb_alpha_t {
+	LAYER_BLENDING,
+	PIXEL_BLENDING,
+	NONE_BLENDING,
+};
+
+enum s5ptvfb_ver_scaling_t {
+	VERTICAL_X1,
+	VERTICAL_X2,
+};
+
+enum s5ptvfb_hor_scaling_t {
+	HORIZONTAL_X1,
+	HORIZONTAL_X2,
+};
+
+struct s5ptvfb_alpha {
+	enum s5ptvfb_alpha_t	mode;
+	int			channel;
+	unsigned int		value;
+};
+
+struct s5ptvfb_chroma {
+	int		enabled;
+	unsigned int	key;
+};
+
+struct s5ptvfb_user_window {
+	int x;
+	int y;
+};
+
+struct s5ptvfb_user_plane_alpha {
+	int		channel;
+	unsigned char	alpha;
+};
+
+struct s5ptvfb_user_chroma {
+	int		enabled;
+	unsigned char	red;
+	unsigned char	green;
+	unsigned char	blue;
+};
+
+struct s5ptvfb_user_scaling {
+	enum s5ptvfb_ver_scaling_t ver;
+	enum s5ptvfb_hor_scaling_t hor;
+};
+
+struct s5p_tvout_status {
+	struct clk *i2c_phy_clk;
+	struct clk *sclk_hdmiphy;
+	struct clk *sclk_pixel;
+	struct clk *sclk_dac;
+	struct clk *sclk_hdmi;
+};
+
+struct reg_mem_info {
+	char		*name;
+	struct resource *res;
+	void __iomem	*base;
+};
+
+struct irq_info {
+	char		*name;
+	irq_handler_t	handler;
+	int		no;
+};
+
+struct s5p_tvout_clk_info {
+	char		*name;
+	struct clk	*ptr;
+};
+
+extern struct s5p_tvout_status s5ptv_status;
+
+extern int s5p_tvout_vcm_create_unified(void);
+extern int s5p_tvout_vcm_init(void);
+extern void s5p_tvout_vcm_activate(void);
+extern void s5p_tvout_vcm_deactivate(void);
+
+extern int s5p_tvout_map_resource_mem(struct platform_device *pdev,
+				      char *name, void __iomem **base,
+				      struct resource **res);
+extern void s5p_tvout_unmap_resource_mem(void __iomem *base,
+					 struct resource *res);
+
+extern void s5p_tvout_pm_runtime_enable(struct device *dev);
+extern void s5p_tvout_pm_runtime_disable(struct device *dev);
+extern void s5p_tvout_pm_runtime_get(void);
+extern void s5p_tvout_pm_runtime_put(void);
+
+#endif /* __S5P_TVOUT_COMMON_LIB_H_ */
diff --git a/drivers/media/video/s5p-tvout/s5p_tvout_ctrl.h b/drivers/media/video/s5p-tvout/s5p_tvout_ctrl.h
new file mode 100644
index 0000000..03ae958
--- /dev/null
+++ b/drivers/media/video/s5p-tvout/s5p_tvout_ctrl.h
@@ -0,0 +1,126 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Header file for tvout control class of Samsung TVOUT driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef __S5P_TVOUT_CTRL_H_
+#define __S5P_TVOUT_CTRL_H_ __FILE__
+
+/*
+ * This file includes declarations for external functions of
+ * TVOUT driver's control class. So only external functions
+ * to be used by higher layer must exist in this file.
+ *
+ * Higher layer must use only the declarations included in this file.
+ */
+
+#include "hw_if/hw_if.h"
+#include "s5p_tvout_common_lib.h"
+
+/* for Mixer control class */
+
+extern void s5p_mixer_ctrl_init_fb_addr_phy(enum s5p_mixer_layer layer,
+					    dma_addr_t fb_addr);
+extern void s5p_mixer_ctrl_init_grp_layer(enum s5p_mixer_layer layer);
+extern int s5p_mixer_ctrl_set_pixel_format(enum s5p_mixer_layer layer,
+					   u32 bpp, u32 trans_len);
+extern int s5p_mixer_ctrl_enable_layer(enum s5p_mixer_layer layer);
+extern int s5p_mixer_ctrl_disable_layer(enum s5p_mixer_layer layer);
+extern int s5p_mixer_ctrl_set_priority(enum s5p_mixer_layer layer, int prio);
+extern int s5p_mixer_ctrl_set_dst_win_pos(enum s5p_mixer_layer layer,
+					  int dst_x, int dst_y, u32 w, u32 h);
+extern int s5p_mixer_ctrl_set_src_win_pos(enum s5p_mixer_layer layer,
+					  u32 src_x, u32 src_y, u32 w, u32 h);
+extern int s5p_mixer_ctrl_set_buffer_address(enum s5p_mixer_layer layer,
+					     dma_addr_t start_addr);
+extern int s5p_mixer_ctrl_set_chroma_key(enum s5p_mixer_layer layer,
+					 struct s5ptvfb_chroma chroma);
+extern int s5p_mixer_ctrl_set_alpha(enum s5p_mixer_layer layer, u32 alpha);
+extern int s5p_mixer_ctrl_set_blend_mode(enum s5p_mixer_layer layer,
+					 enum s5ptvfb_alpha_t mode);
+extern int s5p_mixer_ctrl_set_alpha_blending(enum s5p_mixer_layer layer,
+					     enum s5ptvfb_alpha_t blend_mode,
+					     unsigned int alpha);
+extern int s5p_mixer_ctrl_scaling(enum s5p_mixer_layer,
+				  struct s5ptvfb_user_scaling scaling);
+extern int s5p_mixer_ctrl_mux_clk(struct clk *ptr);
+extern void s5p_mixer_ctrl_set_int_enable(bool en);
+extern void s5p_mixer_ctrl_set_vsync_interrupt(bool en);
+extern void s5p_mixer_ctrl_clear_pend_all(void);
+extern void s5p_mixer_ctrl_stop(void);
+extern void s5p_mixer_ctrl_internal_start(void);
+extern int s5p_mixer_ctrl_start(enum s5p_tvout_disp_mode disp,
+				enum s5p_tvout_o_mode out);
+extern int s5p_mixer_ctrl_constructor(struct platform_device *pdev);
+extern void s5p_mixer_ctrl_destructor(void);
+extern void s5p_mixer_ctrl_suspend(void);
+extern void s5p_mixer_ctrl_resume(void);
+
+/* Interrupt for Vsync */
+
+struct s5p_tv_irq {
+	wait_queue_head_t	wq;
+	unsigned int		wq_count;
+};
+
+extern wait_queue_head_t s5ptv_wq;
+
+/* for TV interface control class */
+
+extern int s5p_tvif_ctrl_set_audio(bool en);
+extern int s5p_tvif_ctrl_set_av_mute(bool en);
+extern int s5p_tvif_ctrl_get_std_if(enum s5p_tvout_disp_mode *std,
+				    enum s5p_tvout_o_mode *inf);
+extern bool s5p_tvif_ctrl_get_run_state(void);
+extern int s5p_tvif_ctrl_start(enum s5p_tvout_disp_mode std,
+			       enum s5p_tvout_o_mode inf);
+extern void s5p_tvif_ctrl_stop(void);
+
+extern int s5p_tvif_ctrl_constructor(struct platform_device *pdev);
+extern void s5p_tvif_ctrl_destructor(void);
+extern void s5p_tvif_ctrl_suspend(void);
+extern void s5p_tvif_ctrl_resume(void);
+
+extern u8 s5p_hdmi_ctrl_get_mute(void);
+extern void s5p_hdmi_ctrl_set_hdcp(bool en);
+
+extern int s5p_hpd_set_hdmiint(void);
+extern int s5p_hpd_set_eint(void);
+extern void s5p_hpd_set_kobj(struct kobject *tvout_kobj,
+			     struct kobject *video_kobj);
+
+/* for VP control class */
+enum s5p_vp_src_color {
+	VP_SRC_COLOR_NV12,
+	VP_SRC_COLOR_NV12IW,
+	VP_SRC_COLOR_TILE_NV12,
+	VP_SRC_COLOR_TILE_NV12IW,
+	VP_SRC_COLOR_NV21,
+	VP_SRC_COLOR_NV21IW,
+	VP_SRC_COLOR_TILE_NV21,
+	VP_SRC_COLOR_TILE_NV21IW
+};
+
+extern void s5p_vp_ctrl_set_src_plane(u32 base_y, u32 base_c,
+				      u32 width, u32 height,
+				      enum s5p_vp_src_color color,
+				      enum s5p_vp_field field);
+extern void s5p_vp_ctrl_set_src_win(u32 left, u32 top, u32 width, u32 height);
+extern void s5p_vp_ctrl_set_dest_win(u32 left, u32 top, u32 width, u32 height);
+extern void s5p_vp_ctrl_set_dest_win_alpha_val(u32 alpha);
+extern void s5p_vp_ctrl_set_dest_win_blend(bool enable);
+extern void s5p_vp_ctrl_set_dest_win_priority(u32 prio);
+extern int s5p_vp_ctrl_start(void);
+extern void s5p_vp_ctrl_stop(void);
+extern int s5p_vp_ctrl_constructor(struct platform_device *pdev);
+extern void s5p_vp_ctrl_destructor(void);
+extern void s5p_vp_ctrl_suspend(void);
+void s5p_vp_ctrl_resume(void);
+
+#endif /* __S5P_TVOUT_CTRL_H_ */
diff --git a/drivers/media/video/s5p-tvout/s5p_tvout_fb.c b/drivers/media/video/s5p-tvout/s5p_tvout_fb.c
new file mode 100644
index 0000000..5409496
--- /dev/null
+++ b/drivers/media/video/s5p-tvout/s5p_tvout_fb.c
@@ -0,0 +1,639 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Frame buffer for Samsung S5P TVOUT driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/fb.h>
+#include <linux/dma-mapping.h>
+#include <linux/uaccess.h>
+
+#include "s5p_tvout_common_lib.h"
+#include "s5p_tvout_ctrl.h"
+#include "s5p_tvout_v4l2.h"
+
+#define S5PTVFB_NAME		"s5ptvfb"
+
+#define S5PTV_FB_LAYER0_MINOR	10
+#define S5PTV_FB_LAYER1_MINOR	11
+
+#define FB_INDEX(id)	(id - S5PTV_FB_LAYER0_MINOR)
+
+#define S5PTVFB_CHROMA(r, g, b)	\
+	(((r & 0xff) << 16) | ((g & 0xff) << 8) | ((b & 0xff) << 0))
+
+#define S5PTVFB_WIN_POSITION		_IOW('F', 213, struct s5ptvfb_user_window)
+#define S5PTVFB_WIN_SET_PLANE_ALPHA	_IOW('F', 214, struct s5ptvfb_user_plane_alpha)
+#define S5PTVFB_WIN_SET_CHROMA		_IOW('F', 215, struct s5ptvfb_user_chroma)
+#define S5PTVFB_WAITFORVSYNC		_IO('F', 32)
+#define S5PTVFB_SET_VSYNC_INT		_IOW('F', 216, u32)
+#define S5PTVFB_WIN_SET_ADDR		_IOW('F', 219, u32)
+#define S5PTVFB_SCALING			_IOW('F', 222, struct s5ptvfb_user_scaling)
+
+struct s5ptvfb_window {
+	int				id;
+	struct device			*dev_fb;
+	int				enabled;
+	atomic_t			in_use;
+	int				x;
+	int				y;
+	enum s5ptvfb_data_path_t	path;
+	int				local_channel;
+	int				dma_burst;
+	unsigned int			pseudo_pal[16];
+	struct s5ptvfb_alpha		alpha;
+	struct s5ptvfb_chroma		chroma;
+	int				(*suspend_fifo)(void);
+	int				(*resume_fifo)(void);
+};
+
+struct s5ptvfb_lcd_timing {
+	int	h_fp;
+	int	h_bp;
+	int	h_sw;
+	int	v_fp;
+	int	v_fpe;
+	int	v_bp;
+	int	v_bpe;
+	int	v_sw;
+};
+
+struct s5ptvfb_lcd_polarity {
+	int	rise_vclk;
+	int	inv_hsync;
+	int	inv_vsync;
+	int	inv_vden;
+};
+
+struct s5ptvfb_lcd {
+	int				width;
+	int				height;
+	int				bpp;
+	int				freq;
+	struct s5ptvfb_lcd_timing	timing;
+	struct s5ptvfb_lcd_polarity	polarity;
+
+	void				(*init_ldi)(void);
+};
+
+static struct mutex fb_lock;
+
+static struct fb_info *fb[S5PTV_FB_CNT];
+static struct s5ptvfb_lcd lcd = {
+	.width = 1920,
+	.height = 1080,
+	.bpp = 32,
+	.freq = 60,
+
+	.timing = {
+		.h_fp = 49,
+		.h_bp = 17,
+		.h_sw = 33,
+		.v_fp = 4,
+		.v_fpe = 1,
+		.v_bp = 15,
+		.v_bpe = 1,
+		.v_sw = 6,
+	},
+
+	.polarity = {
+		.rise_vclk = 0,
+		.inv_hsync = 1,
+		.inv_vsync = 1,
+		.inv_vden = 0,
+	},
+};
+
+static int s5p_tvout_fb_wait_for_vsync(void)
+{
+	sleep_on_timeout(&s5ptv_wq, HZ / 10);
+
+	return 0;
+}
+
+static inline unsigned int s5p_tvout_fb_chan_to_field(unsigned int chan,
+						      struct fb_bitfield bf)
+{
+	chan &= 0xffff;
+	chan >>= 16 - bf.length;
+
+	return chan << bf.offset;
+}
+
+static int s5p_tvout_fb_set_alpha_info(struct fb_var_screeninfo *var,
+				       struct s5ptvfb_window *win)
+{
+	if (var->transp.length > 0)
+		win->alpha.mode = PIXEL_BLENDING;
+	else
+		win->alpha.mode = NONE_BLENDING;
+
+	return 0;
+}
+
+static int s5p_tvout_fb_set_bitfield(struct fb_var_screeninfo *var)
+{
+	switch (var->bits_per_pixel) {
+	case 16:
+		if (var->transp.length == 1) {
+			var->red.offset = 10;
+			var->red.length = 5;
+			var->green.offset = 5;
+			var->green.length = 5;
+			var->blue.offset = 0;
+			var->blue.length = 5;
+			var->transp.offset = 15;
+		} else if (var->transp.length == 4) {
+			var->red.offset = 8;
+			var->red.length = 4;
+			var->green.offset = 4;
+			var->green.length = 4;
+			var->blue.offset = 0;
+			var->blue.length = 4;
+			var->transp.offset = 12;
+		} else {
+			var->red.offset = 11;
+			var->red.length = 5;
+			var->green.offset = 5;
+			var->green.length = 6;
+			var->blue.offset = 0;
+			var->blue.length = 5;
+			var->transp.offset = 0;
+		}
+		break;
+
+	case 24:
+		var->red.offset = 16;
+		var->red.length = 8;
+		var->green.offset = 8;
+		var->green.length = 8;
+		var->blue.offset = 0;
+		var->blue.length = 8;
+		var->transp.offset = 0;
+		var->transp.length = 0;
+		break;
+
+	case 32:
+		var->red.offset = 16;
+		var->red.length = 8;
+		var->green.offset = 8;
+		var->green.length = 8;
+		var->blue.offset = 0;
+		var->blue.length = 8;
+		var->transp.offset = 24;
+		break;
+	}
+
+	return 0;
+}
+
+static int s5p_tvout_fb_setcolreg(unsigned int regno, unsigned int red,
+				  unsigned int green, unsigned int blue,
+				  unsigned int transp, struct fb_info *fb)
+{
+	unsigned int *pal = (unsigned int *) fb->pseudo_palette;
+	unsigned int val = 0;
+
+	if (regno < 16) {
+		/* fake palette of 16 colors */
+		val |= s5p_tvout_fb_chan_to_field(red, fb->var.red);
+		val |= s5p_tvout_fb_chan_to_field(green, fb->var.green);
+		val |= s5p_tvout_fb_chan_to_field(blue, fb->var.blue);
+		val |= s5p_tvout_fb_chan_to_field(transp, fb->var.transp);
+
+		pal[regno] = val;
+	}
+
+	return 0;
+}
+
+static int s5p_tvout_fb_pan_display(struct fb_var_screeninfo *var,
+				    struct fb_info *fb)
+{
+	dma_addr_t start_addr;
+	enum s5p_mixer_layer layer;
+	struct fb_fix_screeninfo *fix = &fb->fix;
+
+	if (var->yoffset + var->yres > var->yres_virtual) {
+		tvout_err("invalid y offset value\n");
+		return -1;
+	}
+
+	fb->var.yoffset = var->yoffset;
+
+	switch (fb->node) {
+	case S5PTV_FB_LAYER0_MINOR:
+		layer = MIXER_GPR0_LAYER;
+		break;
+
+	case S5PTV_FB_LAYER1_MINOR:
+		layer = MIXER_GPR1_LAYER;
+		break;
+
+	default:
+		tvout_err("invalid layer\n");
+		return -1;
+	}
+
+	start_addr = fix->smem_start + (var->xres_virtual * (var->bits_per_pixel / 8) * var->yoffset);
+
+	s5p_mixer_ctrl_set_buffer_address(layer, start_addr);
+
+	return 0;
+}
+
+static int s5p_tvout_fb_blank(int blank_mode, struct fb_info *fb)
+{
+	enum s5p_mixer_layer layer = MIXER_GPR0_LAYER;
+
+	tvout_dbg("change blank mode\n");
+
+	switch (fb->node) {
+	case S5PTV_FB_LAYER0_MINOR:
+		layer = MIXER_GPR0_LAYER;
+		break;
+
+	case S5PTV_FB_LAYER1_MINOR:
+		layer = MIXER_GPR1_LAYER;
+		break;
+
+	default:
+		tvout_err("not supported layer\n");
+		return -1;
+	}
+
+	switch (blank_mode) {
+	case FB_BLANK_UNBLANK:
+		if (fb->fix.smem_start)
+			s5p_mixer_ctrl_enable_layer(layer);
+		else
+			tvout_dbg("[fb%d] no alloc memory for unblank\n", fb->node);
+		break;
+
+	case FB_BLANK_POWERDOWN:
+		s5p_mixer_ctrl_disable_layer(layer);
+		break;
+
+	default:
+		tvout_err("not supported blank mode\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int s5p_tvout_fb_set_par(struct fb_info *fb)
+{
+	u32 bpp, trans_len;
+	u32 src_x, src_y, w, h;
+	struct s5ptvfb_window *win = fb->par;
+	enum s5p_mixer_layer layer = MIXER_GPR0_LAYER;
+
+	tvout_dbg("[fb%d] set_par\n", win->id);
+
+	if (!fb->fix.smem_start)
+		printk(KERN_INFO " The frame buffer is allocated here\n");
+
+	bpp = fb->var.bits_per_pixel;
+	trans_len = fb->var.transp.length;
+	w = fb->var.xres;
+	h = fb->var.yres;
+	src_x = fb->var.xoffset;
+	src_y = fb->var.yoffset;
+
+	switch (fb->node) {
+	case S5PTV_FB_LAYER0_MINOR:
+		layer = MIXER_GPR0_LAYER;
+		break;
+
+	case S5PTV_FB_LAYER1_MINOR:
+		layer = MIXER_GPR1_LAYER;
+		break;
+
+	default:
+		break;
+	}
+
+	s5p_mixer_ctrl_init_grp_layer(layer);
+	s5p_mixer_ctrl_set_pixel_format(layer, bpp, trans_len);
+	s5p_mixer_ctrl_set_src_win_pos(layer, src_x, src_y, w, h);
+	s5p_mixer_ctrl_set_alpha_blending(layer, win->alpha.mode,
+					  win->alpha.value);
+	return 0;
+}
+
+static int s5p_tvout_fb_check_var(struct fb_var_screeninfo *var,
+				  struct fb_info *fb)
+{
+	struct fb_fix_screeninfo *fix = &fb->fix;
+	struct s5ptvfb_window *win = fb->par;
+
+	tvout_dbg("[fb%d] check_var\n", win->id);
+
+	if (var->bits_per_pixel != 16 && var->bits_per_pixel != 24 &&
+		var->bits_per_pixel != 32) {
+		tvout_err("invalid bits per pixel\n");
+		return -1;
+	}
+
+	if (var->xres > lcd.width)
+		var->xres = lcd.width;
+
+	if (var->yres > lcd.height)
+		var->yres = lcd.height;
+
+	if (var->xres_virtual != var->xres)
+		var->xres_virtual = var->xres;
+
+	if (var->yres_virtual > var->yres * (fb->fix.ypanstep + 1))
+		var->yres_virtual = var->yres * (fb->fix.ypanstep + 1);
+
+	if (var->xoffset != 0)
+		var->xoffset = 0;
+
+	if (var->yoffset + var->yres > var->yres_virtual)
+		var->yoffset = var->yres_virtual - var->yres;
+
+	if (win->x + var->xres > lcd.width)
+		win->x = lcd.width - var->xres;
+
+	if (win->y + var->yres > lcd.height)
+		win->y = lcd.height - var->yres;
+
+	/* modify the fix info */
+	fix->line_length = var->xres_virtual * var->bits_per_pixel / 8;
+	fix->smem_len = fix->line_length * var->yres_virtual;
+
+	s5p_tvout_fb_set_bitfield(var);
+	s5p_tvout_fb_set_alpha_info(var, win);
+
+	return 0;
+}
+
+static int s5p_tvout_fb_release(struct fb_info *fb, int user)
+{
+	struct s5ptvfb_window *win = fb->par;
+
+	atomic_dec(&win->in_use);
+
+	return 0;
+}
+
+static int s5p_tvout_fb_ioctl(struct fb_info *fb, unsigned int cmd,
+			      unsigned long arg)
+{
+	dma_addr_t start_addr;
+	enum s5p_mixer_layer layer;
+	struct fb_var_screeninfo *var = &fb->var;
+	struct s5ptvfb_window *win = fb->par;
+	int ret = 0;
+	void *argp = (void *) arg;
+
+	union {
+		struct s5ptvfb_user_window user_window;
+		struct s5ptvfb_user_plane_alpha user_alpha;
+		struct s5ptvfb_user_chroma user_chroma;
+		struct s5ptvfb_user_scaling user_scaling;
+		int vsync;
+	} p;
+
+	switch (fb->node) {
+	case S5PTV_FB_LAYER0_MINOR:
+		layer = MIXER_GPR0_LAYER;
+		break;
+	case S5PTV_FB_LAYER1_MINOR:
+		layer = MIXER_GPR1_LAYER;
+		break;
+	default:
+		printk(KERN_ERR "[Error] invalid layer\n");
+		return -1;
+	}
+
+	switch (cmd) {
+	case S5PTVFB_WIN_POSITION:
+		if (copy_from_user(&p.user_window, (struct s5ptvfb_user_window __user *) arg, sizeof(p.user_window))) {
+			ret = -EFAULT;
+		} else {
+			s5p_mixer_ctrl_set_dst_win_pos(layer,
+				p.user_window.x, p.user_window.y,
+				var->xres, var->yres);
+		}
+		break;
+
+	case S5PTVFB_WIN_SET_PLANE_ALPHA:
+		if (copy_from_user(&p.user_alpha, (struct s5ptvfb_user_plane_alpha __user *) arg, sizeof(p.user_alpha))) {
+			ret = -EFAULT;
+		} else {
+			win->alpha.mode = LAYER_BLENDING;
+			win->alpha.value = p.user_alpha.alpha;
+			s5p_mixer_ctrl_set_alpha_blending(layer,
+				win->alpha.mode, win->alpha.value);
+		}
+		break;
+
+	case S5PTVFB_WIN_SET_CHROMA:
+		if (copy_from_user(&p.user_chroma, (struct s5ptvfb_user_chroma __user *) arg, sizeof(p.user_chroma))) {
+			ret = -EFAULT;
+		} else {
+			win->chroma.enabled = p.user_chroma.enabled;
+			win->chroma.key = S5PTVFB_CHROMA(p.user_chroma.red, p.user_chroma.green, p.user_chroma.blue);
+
+			s5p_mixer_ctrl_set_chroma_key(layer, win->chroma);
+		}
+		break;
+
+	case S5PTVFB_SET_VSYNC_INT:
+		s5p_mixer_ctrl_set_vsync_interrupt((int)argp);
+		break;
+
+	case S5PTVFB_WAITFORVSYNC:
+		s5p_tvout_fb_wait_for_vsync();
+		break;
+
+	case S5PTVFB_WIN_SET_ADDR:
+		fb->fix.smem_start = (unsigned long)argp;
+		start_addr = fb->fix.smem_start + (var->xres_virtual * (var->bits_per_pixel / 8) * var->yoffset);
+
+		s5p_mixer_ctrl_set_buffer_address(layer, start_addr);
+		break;
+
+	case S5PTVFB_SCALING:
+		if (copy_from_user(&p.user_scaling, (struct s5ptvfb_user_scaling __user *) arg, sizeof(p.user_scaling)))
+			ret = -EFAULT;
+		else
+			s5p_mixer_ctrl_scaling(layer, p.user_scaling);
+		break;
+	}
+
+	return 0;
+}
+
+static int s5p_tvout_fb_open(struct fb_info *fb, int user)
+{
+	struct s5ptvfb_window *win = fb->par;
+	int ret = 0;
+
+	mutex_lock(&fb_lock);
+
+	if (atomic_read(&win->in_use)) {
+		tvout_dbg("do not allow multiple open for tvout framebuffer\n");
+		ret = -EBUSY;
+	} else
+		atomic_inc(&win->in_use);
+
+	mutex_unlock(&fb_lock);
+
+	return ret;
+}
+
+struct fb_ops s5ptvfb_ops = {
+	.owner			= THIS_MODULE,
+	.fb_fillrect		= cfb_fillrect,
+	.fb_copyarea		= cfb_copyarea,
+	.fb_imageblit		= cfb_imageblit,
+	.fb_check_var		= s5p_tvout_fb_check_var,
+	.fb_set_par		= s5p_tvout_fb_set_par,
+	.fb_blank		= s5p_tvout_fb_blank,
+	.fb_pan_display		= s5p_tvout_fb_pan_display,
+	.fb_setcolreg		= s5p_tvout_fb_setcolreg,
+	.fb_ioctl		= s5p_tvout_fb_ioctl,
+	.fb_open		= s5p_tvout_fb_open,
+	.fb_release		= s5p_tvout_fb_release,
+};
+
+static int s5p_tvout_fb_init_fbinfo(int id, struct device *dev_fb)
+{
+	struct fb_fix_screeninfo *fix = &fb[FB_INDEX(id)]->fix;
+	struct fb_var_screeninfo *var = &fb[FB_INDEX(id)]->var;
+	struct s5ptvfb_window *win = fb[FB_INDEX(id)]->par;
+	struct s5ptvfb_alpha *alpha = &win->alpha;
+
+	memset(win, 0, sizeof(struct s5ptvfb_window));
+
+	platform_set_drvdata(to_platform_device(dev_fb), fb[FB_INDEX(id)]);
+
+	strcpy(fix->id, S5PTVFB_NAME);
+
+	/* fimd specific */
+	win->id = id;
+	win->path = DATA_PATH_DMA;
+	win->dma_burst = 16;
+	win->dev_fb = dev_fb;
+	alpha->mode = LAYER_BLENDING;
+	alpha->value = 0xff;
+
+	/* fbinfo */
+	fb[FB_INDEX(id)]->fbops = &s5ptvfb_ops;
+	fb[FB_INDEX(id)]->flags = FBINFO_FLAG_DEFAULT;
+	fb[FB_INDEX(id)]->pseudo_palette = &win->pseudo_pal;
+	fix->xpanstep = 0;
+	fix->ypanstep = 0;
+	fix->type = FB_TYPE_PACKED_PIXELS;
+	fix->accel = FB_ACCEL_NONE;
+	fix->visual = FB_VISUAL_TRUECOLOR;
+	var->xres = lcd.width;
+	var->yres = lcd.height;
+	var->xres_virtual = var->xres;
+	var->yres_virtual = var->yres + (var->yres * fix->ypanstep);
+	var->bits_per_pixel = 32;
+	var->xoffset = 0;
+	var->yoffset = 0;
+	var->width = 0;
+	var->height = 0;
+	var->transp.length = 0;
+
+	fix->line_length = var->xres_virtual * var->bits_per_pixel / 8;
+	fix->smem_len = fix->line_length * var->yres_virtual;
+
+	var->nonstd = 0;
+	var->activate = FB_ACTIVATE_NOW;
+	var->vmode = FB_VMODE_NONINTERLACED;
+	var->hsync_len = lcd.timing.h_sw;
+	var->vsync_len = lcd.timing.v_sw;
+	var->left_margin = lcd.timing.h_fp;
+	var->right_margin = lcd.timing.h_bp;
+	var->upper_margin = lcd.timing.v_fp;
+	var->lower_margin = lcd.timing.v_bp;
+
+	var->pixclock = lcd.freq * (var->left_margin + var->right_margin + var->hsync_len + var->xres)
+				* (var->upper_margin + var->lower_margin + var->vsync_len + var->yres);
+
+	tvout_dbg("pixclock: %d\n", var->pixclock);
+
+	s5p_tvout_fb_set_bitfield(var);
+	s5p_tvout_fb_set_alpha_info(var, win);
+
+	mutex_init(&fb_lock);
+
+	return 0;
+}
+
+int s5p_tvout_fb_alloc_framebuffer(struct device *dev_fb)
+{
+	int ret, i;
+
+	/* alloc for each framebuffer */
+	for (i = 0; i < S5PTV_FB_CNT; i++) {
+		fb[i] = framebuffer_alloc(sizeof(struct s5ptvfb_window), dev_fb);
+		if (!fb[i]) {
+			tvout_err("not enough memory\n");
+			ret = -1;
+			goto err_alloc_fb;
+		}
+
+		ret = s5p_tvout_fb_init_fbinfo(i + S5PTV_FB_LAYER0_MINOR, dev_fb);
+		if (ret) {
+			tvout_err("fail to allocate memory for tv fb\n");
+			ret = -1;
+			goto err_alloc_fb;
+		}
+	}
+
+	return 0;
+
+err_alloc_fb:
+	for (i = 0; i < S5PTV_FB_CNT; i++) {
+		if (fb[i])
+			framebuffer_release(fb[i]);
+	}
+
+	return ret;
+}
+
+int s5p_tvout_fb_register_framebuffer(struct device *dev_fb)
+{
+	int ret, i = 0;
+
+	do {
+		ret = register_framebuffer(fb[0]);
+		if (ret) {
+			tvout_err("fail to register framebuffer device\n");
+			return -1;
+		}
+	} while (fb[0]->node < S5PTV_FB_LAYER0_MINOR);
+
+	for (i = 1; i < S5PTV_FB_CNT; i++) {
+		ret = register_framebuffer(fb[i]);
+		if (ret) {
+			tvout_err("fail to register framebuffer device\n");
+			return -1;
+		}
+	}
+
+	for (i = 0; i < S5PTV_FB_CNT; i++)
+		tvout_dbg("fb[%d] = %d\n", i, fb[i]->node);
+
+	for (i = 0; i < S5PTV_FB_CNT; i++) {
+#ifndef CONFIG_FRAMEBUFFER_CONSOLE
+		s5p_tvout_fb_check_var(&fb[i]->var, fb[i]);
+		s5p_tvout_fb_set_par(fb[i]);
+#endif
+	}
+
+	return 0;
+}
diff --git a/drivers/media/video/s5p-tvout/s5p_tvout_fb.h b/drivers/media/video/s5p-tvout/s5p_tvout_fb.h
new file mode 100644
index 0000000..da0800e
--- /dev/null
+++ b/drivers/media/video/s5p-tvout/s5p_tvout_fb.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Frame Buffer header for Samsung S5P TVOUT driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef __S5P_TVOUT_FB_H_
+#define __S5P_TVOUT_FB_H_ __FILE__
+
+#include <linux/fb.h>
+
+extern int s5p_tvout_fb_alloc_framebuffer(struct device *dev_fb);
+extern int s5p_tvout_fb_register_framebuffer(struct device *dev_fb);
+
+#endif /* __S5P_TVOUT_FB_H_ */
diff --git a/drivers/media/video/s5p-tvout/s5p_vp_ctrl.c b/drivers/media/video/s5p-tvout/s5p_vp_ctrl.c
new file mode 100644
index 0000000..de6981e
--- /dev/null
+++ b/drivers/media/video/s5p-tvout/s5p_vp_ctrl.c
@@ -0,0 +1,586 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Control class for Samsung S5P Video Processor
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+
+#include "hw_if/hw_if.h"
+#include "s5p_tvout_ctrl.h"
+
+#define INTERLACED	0
+#define PROGRESSIVE	1
+
+struct s5p_vp_ctrl_op_mode {
+	bool	ipc;
+	bool	line_skip;
+	bool	auto_toggling;
+};
+
+struct s5p_vp_ctrl_bc_line_eq {
+	enum s5p_vp_line_eq	eq_num;
+	u32			intc;
+	u32			slope;
+};
+
+struct s5p_vp_ctrl_rect {
+	u32	x;
+	u32	y;
+	u32	w;
+	u32	h;
+};
+
+struct s5p_vp_ctrl_plane {
+	u32	top_y_addr;
+	u32	top_c_addr;
+	u32	w;
+	u32	h;
+
+	enum s5p_vp_src_color	color_t;
+	enum s5p_vp_field	field_id;
+	enum s5p_vp_mem_type	mem_type;
+	enum s5p_vp_mem_mode	mem_mode;
+};
+
+struct s5p_vp_ctrl_pp_param {
+	bool				bypass;
+
+	bool csc_en;
+	enum s5p_vp_csc_type		csc_t;
+	bool				csc_default_coef;
+	bool				csc_sub_y_offset_en;
+
+	u32				saturation;
+	u8				contrast;
+	bool				brightness;
+	u32				bright_offset;
+	struct s5p_vp_ctrl_bc_line_eq	bc_line_eq[8];
+
+	/* sharpness */
+	u32				th_hnoise;
+	enum s5p_vp_sharpness_control	sharpness;
+
+
+	bool				default_poly_filter;
+
+	enum s5p_vp_chroma_expansion	chroma_exp;
+};
+
+struct s5p_vp_ctrl_mixer_param {
+	bool	blend;
+	u32	alpha;
+	u32	prio;
+};
+
+struct s5p_vp_ctrl_private_data {
+	struct s5p_vp_ctrl_plane	src_plane;
+	struct s5p_vp_ctrl_rect		src_win;
+
+	struct s5p_vp_ctrl_rect		dst_win;
+	struct s5p_vp_ctrl_op_mode	op_mode;
+
+	struct s5p_vp_ctrl_pp_param	pp_param;
+	struct s5p_vp_ctrl_mixer_param	mixer_param;
+
+	bool				running;
+
+	struct reg_mem_info		reg_mem;
+
+	struct s5p_tvout_clk_info	clk;
+	char				*pow_name;
+};
+
+static struct s5p_vp_ctrl_private_data s5p_vp_ctrl_private = {
+	.reg_mem = {
+		.name			= "s5p-vp",
+		.res			= NULL,
+		.base			= NULL
+	},
+
+	.clk = {
+		.name			= "vp",
+		.ptr			= NULL
+	},
+
+	.pow_name			= "vp_pd",
+
+	.src_plane = {
+		.field_id		= VP_TOP_FIELD,
+	},
+
+	.pp_param = {
+		.default_poly_filter	= true,
+		.bypass			= false,
+
+		.saturation		= 0x80,
+		.brightness		= 0x00,
+		.bright_offset		= 0x00,
+		.contrast		= 0x80,
+
+		.th_hnoise		= 0,
+		.sharpness		= VP_SHARPNESS_NO,
+
+		.chroma_exp		= 0,
+
+		.csc_en			= false,
+		.csc_default_coef	= true,
+		.csc_sub_y_offset_en	= false,
+	},
+
+	.running			= false
+};
+
+static u8 s5p_vp_ctrl_get_src_scan_mode(void)
+{
+	struct s5p_vp_ctrl_plane *src_plane = &s5p_vp_ctrl_private.src_plane;
+	u8 ret = PROGRESSIVE;
+
+	if (src_plane->color_t == VP_SRC_COLOR_NV12IW ||
+		src_plane->color_t == VP_SRC_COLOR_TILE_NV12IW ||
+		src_plane->color_t == VP_SRC_COLOR_NV21IW ||
+		src_plane->color_t == VP_SRC_COLOR_TILE_NV21IW)
+		ret = INTERLACED;
+
+	return ret;
+}
+
+static u8 s5p_vp_ctrl_get_dest_scan_mode(
+		enum s5p_tvout_disp_mode display, enum s5p_tvout_o_mode out)
+{
+	u8 ret = PROGRESSIVE;
+
+	switch (out) {
+	case TVOUT_COMPOSITE:
+		ret = INTERLACED;
+		break;
+
+	case TVOUT_HDMI_RGB:
+	case TVOUT_HDMI:
+	case TVOUT_DVI:
+		if (display == TVOUT_1080I_60 || display == TVOUT_1080I_59 ||
+				display == TVOUT_1080I_50)
+			ret = INTERLACED;
+		break;
+
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static void s5p_vp_ctrl_set_src_dst_win(struct s5p_vp_ctrl_rect src_win,
+					struct s5p_vp_ctrl_rect dst_win,
+					enum s5p_tvout_disp_mode disp,
+					enum s5p_tvout_o_mode out,
+					enum s5p_vp_src_color color_t,
+					bool ipc)
+{
+	src_win.y /= 2;
+	src_win.h /= 2;
+
+	if (s5p_vp_ctrl_get_dest_scan_mode(disp, out) == INTERLACED) {
+		dst_win.y /= 2;
+		dst_win.h /= 2;
+	}
+
+	s5p_vp_set_src_position(src_win.x, 0, src_win.y);
+	s5p_vp_set_dest_position(dst_win.x, dst_win.y);
+	s5p_vp_set_src_dest_size(src_win.w, src_win.h, dst_win.w, dst_win.h, ipc);
+}
+
+static int s5p_vp_ctrl_set_src_addr(u32 top_y_addr, u32 top_c_addr,
+				    u32 img_w, enum s5p_vp_src_color color_t)
+{
+	if (s5p_vp_set_top_field_address(top_y_addr, top_c_addr))
+		return -1;
+
+	if (s5p_vp_ctrl_get_src_scan_mode() == INTERLACED) {
+		u32 bot_y = 0;
+		u32 bot_c = 0;
+
+		if (color_t == VP_SRC_COLOR_NV12IW || color_t == VP_SRC_COLOR_NV21IW) {
+			bot_y = top_y_addr + img_w;
+			bot_c = top_c_addr + img_w;
+		} else if (color_t == VP_SRC_COLOR_TILE_NV12IW || color_t == VP_SRC_COLOR_TILE_NV21IW) {
+			bot_y = top_y_addr + 0x40;
+			bot_c = top_c_addr + 0x40;
+		}
+
+		if (s5p_vp_set_bottom_field_address(bot_y, bot_c))
+			return -1;
+	}
+
+	return 0;
+}
+
+static void s5p_vp_ctrl_init_private(void)
+{
+	int i;
+	struct s5p_vp_ctrl_pp_param *pp_param = &s5p_vp_ctrl_private.pp_param;
+
+	for (i = 0; i < 8; i++)
+		pp_param->bc_line_eq[i].eq_num = VP_LINE_EQ_DEFAULT;
+}
+
+static int s5p_vp_ctrl_set_reg(void)
+{
+	int i;
+	int ret = 0;
+
+	enum s5p_tvout_disp_mode	tv_std;
+	enum s5p_tvout_o_mode		tv_if;
+
+	struct s5p_vp_ctrl_plane *src_plane = &s5p_vp_ctrl_private.src_plane;
+	struct s5p_vp_ctrl_pp_param *pp_param = &s5p_vp_ctrl_private.pp_param;
+	struct s5p_vp_ctrl_op_mode *op_mode = &s5p_vp_ctrl_private.op_mode;
+
+	s5p_tvif_ctrl_get_std_if(&tv_std, &tv_if);
+
+	s5p_vp_sw_reset();
+
+	s5p_vp_set_endian(TVOUT_BIG_ENDIAN);
+
+	s5p_vp_set_op_mode(op_mode->line_skip, src_plane->mem_type,
+			   src_plane->mem_mode, pp_param->chroma_exp,
+			   op_mode->auto_toggling);
+
+	s5p_vp_set_field_id(src_plane->field_id);
+
+	s5p_vp_set_img_size(src_plane->w, src_plane->h);
+
+	s5p_vp_ctrl_set_src_addr(src_plane->top_y_addr, src_plane->top_c_addr,
+				 src_plane->w, src_plane->color_t);
+
+	s5p_vp_ctrl_set_src_dst_win(s5p_vp_ctrl_private.src_win,
+				    s5p_vp_ctrl_private.dst_win,
+				    tv_std, tv_if,
+				    s5p_vp_ctrl_private.src_plane.color_t,
+				    op_mode->ipc);
+
+	if (pp_param->default_poly_filter)
+		s5p_vp_set_poly_filter_coef_default(s5p_vp_ctrl_private.src_win.w,
+						    s5p_vp_ctrl_private.src_win.h,
+						    s5p_vp_ctrl_private.dst_win.w,
+						    s5p_vp_ctrl_private.dst_win.h,
+						    op_mode->ipc);
+
+	s5p_vp_set_bypass_post_process(pp_param->bypass);
+	s5p_vp_set_sharpness(pp_param->th_hnoise, pp_param->sharpness);
+	s5p_vp_set_saturation(pp_param->saturation);
+	s5p_vp_set_brightness_contrast(pp_param->brightness, pp_param->contrast);
+
+	for (i = VP_LINE_EQ_0; i <= VP_LINE_EQ_7; i++) {
+		if (pp_param->bc_line_eq[i].eq_num == i)
+			ret = s5p_vp_set_brightness_contrast_control(pp_param->bc_line_eq[i].eq_num,
+								     pp_param->bc_line_eq[i].intc,
+								     pp_param->bc_line_eq[i].slope);
+
+		if (ret != 0)
+			return -1;
+	}
+
+	s5p_vp_set_brightness_offset(pp_param->bright_offset);
+
+	s5p_vp_set_csc_control(pp_param->csc_sub_y_offset_en, pp_param->csc_en);
+
+	if (pp_param->csc_en && pp_param->csc_default_coef) {
+		if (s5p_vp_set_csc_coef_default(pp_param->csc_t))
+			return -1;
+	}
+
+	if (s5p_vp_start())
+		return -1;
+
+	s5p_mixer_ctrl_enable_layer(MIXER_VIDEO_LAYER);
+
+	return 0;
+}
+
+static void s5p_vp_ctrl_internal_stop(void)
+{
+	s5p_vp_stop();
+
+	s5p_mixer_ctrl_disable_layer(MIXER_VIDEO_LAYER);
+}
+
+static void s5p_vp_ctrl_clock(bool on)
+{
+	if (on)
+		clk_enable(s5p_vp_ctrl_private.clk.ptr);
+	else
+		clk_disable(s5p_vp_ctrl_private.clk.ptr);
+}
+
+void s5p_vp_ctrl_set_src_plane(u32 base_y, u32 base_c, u32 width, u32 height,
+			       enum s5p_vp_src_color color, enum s5p_vp_field field)
+{
+	struct s5p_vp_ctrl_plane *src_plane = &s5p_vp_ctrl_private.src_plane;
+
+	src_plane->color_t	= color;
+	src_plane->field_id	= field;
+
+	src_plane->top_y_addr	= base_y;
+	src_plane->top_c_addr	= base_c;
+
+	src_plane->w		= width;
+	src_plane->h		= height;
+
+	if (s5p_vp_ctrl_private.running) {
+		s5p_vp_set_img_size(width, height);
+
+		s5p_vp_set_field_id(field);
+		s5p_vp_ctrl_set_src_addr(base_y, base_c, width, color);
+
+		s5p_vp_update();
+	}
+}
+
+void s5p_vp_ctrl_set_src_win(u32 left, u32 top, u32 width, u32 height)
+{
+	struct s5p_vp_ctrl_rect *src_win = &s5p_vp_ctrl_private.src_win;
+
+	src_win->x = left;
+	src_win->y = top;
+	src_win->w = width;
+	src_win->h = height;
+
+	if (s5p_vp_ctrl_private.running) {
+		enum s5p_tvout_disp_mode	tv_std;
+		enum s5p_tvout_o_mode		tv_if;
+
+		s5p_tvif_ctrl_get_std_if(&tv_std, &tv_if);
+
+		s5p_vp_ctrl_set_src_dst_win(*src_win,
+					    s5p_vp_ctrl_private.dst_win,
+					    tv_std, tv_if,
+					    s5p_vp_ctrl_private.src_plane.color_t,
+					    s5p_vp_ctrl_private.op_mode.ipc);
+
+		s5p_vp_update();
+	}
+}
+
+void s5p_vp_ctrl_set_dest_win(u32 left, u32 top, u32 width, u32 height)
+{
+	struct s5p_vp_ctrl_rect *dst_win = &s5p_vp_ctrl_private.dst_win;
+
+	dst_win->x = left;
+	dst_win->y = top;
+	dst_win->w = width;
+	dst_win->h = height;
+
+	if (s5p_vp_ctrl_private.running) {
+		enum s5p_tvout_disp_mode	tv_std;
+		enum s5p_tvout_o_mode		tv_if;
+
+		s5p_tvif_ctrl_get_std_if(&tv_std, &tv_if);
+
+		s5p_vp_ctrl_set_src_dst_win(s5p_vp_ctrl_private.src_win,
+					    *dst_win, tv_std, tv_if,
+					    s5p_vp_ctrl_private.src_plane.color_t,
+					    s5p_vp_ctrl_private.op_mode.ipc);
+
+		s5p_vp_update();
+	}
+}
+
+void s5p_vp_ctrl_set_dest_win_alpha_val(u32 alpha)
+{
+	s5p_vp_ctrl_private.mixer_param.alpha = alpha;
+
+	if (s5p_vp_ctrl_private.running)
+		s5p_mixer_ctrl_set_alpha(MIXER_VIDEO_LAYER, alpha);
+}
+
+void s5p_vp_ctrl_set_dest_win_blend(bool enable)
+{
+	s5p_vp_ctrl_private.mixer_param.blend = enable;
+
+	if (s5p_vp_ctrl_private.running)
+		s5p_mixer_ctrl_set_blend_mode(MIXER_VIDEO_LAYER, LAYER_BLENDING);
+}
+
+void s5p_vp_ctrl_set_dest_win_priority(u32 prio)
+{
+	s5p_vp_ctrl_private.mixer_param.prio = prio;
+
+	if (s5p_vp_ctrl_private.running)
+		s5p_mixer_ctrl_set_priority(MIXER_VIDEO_LAYER, (int)prio);
+}
+
+void s5p_vp_ctrl_stop(void)
+{
+	if (s5p_vp_ctrl_private.running) {
+		s5p_vp_ctrl_internal_stop();
+		s5p_vp_ctrl_clock(0);
+
+		s5p_vp_ctrl_private.running = false;
+	}
+}
+
+int s5p_vp_ctrl_start(void)
+{
+	struct s5p_vp_ctrl_plane *src_plane = &s5p_vp_ctrl_private.src_plane;
+	enum s5p_tvout_disp_mode disp;
+	enum s5p_tvout_o_mode out;
+
+	/* 0 for interlaced, 1 for progressive */
+	bool i_mode, o_mode;
+
+	s5p_tvif_ctrl_get_std_if(&disp, &out);
+
+	switch (disp) {
+	case TVOUT_480P_60_16_9:
+	case TVOUT_480P_60_4_3:
+	case TVOUT_576P_50_16_9:
+	case TVOUT_576P_50_4_3:
+	case TVOUT_480P_59:
+		s5p_vp_ctrl_private.pp_param.csc_t = VP_CSC_SD_HD;
+		break;
+
+	case TVOUT_1080I_50:
+	case TVOUT_1080I_60:
+	case TVOUT_1080P_50:
+	case TVOUT_1080P_30:
+	case TVOUT_1080P_60:
+	case TVOUT_720P_59:
+	case TVOUT_1080I_59:
+	case TVOUT_1080P_59:
+	case TVOUT_720P_50:
+	case TVOUT_720P_60:
+		s5p_vp_ctrl_private.pp_param.csc_t = VP_CSC_HD_SD;
+		break;
+
+	default:
+		break;
+	}
+
+	i_mode = s5p_vp_ctrl_get_src_scan_mode();
+	o_mode = s5p_vp_ctrl_get_dest_scan_mode(disp, out);
+
+	/* check o_mode */
+	if (i_mode == INTERLACED) {
+		if (o_mode == INTERLACED) {
+			/* i to i : line skip 1, ipc 0, auto toggle 0 */
+			s5p_vp_ctrl_private.op_mode.line_skip		= true;
+			s5p_vp_ctrl_private.op_mode.ipc			= false;
+			s5p_vp_ctrl_private.op_mode.auto_toggling	= false;
+		} else {
+			/* i to p : line skip 1, ipc 1, auto toggle 0 */
+			s5p_vp_ctrl_private.op_mode.line_skip		= true;
+			s5p_vp_ctrl_private.op_mode.ipc			= true;
+			s5p_vp_ctrl_private.op_mode.auto_toggling	= false;
+		}
+	} else {
+		if (o_mode == INTERLACED) {
+			/* p to i : line skip 1, ipc 0, auto toggle 0 */
+			s5p_vp_ctrl_private.op_mode.line_skip		= true;
+			s5p_vp_ctrl_private.op_mode.ipc			= false;
+			s5p_vp_ctrl_private.op_mode.auto_toggling	= false;
+		} else {
+			/* p to p : line skip 0, ipc 0, auto toggle 0 */
+			s5p_vp_ctrl_private.op_mode.line_skip		= false;
+			s5p_vp_ctrl_private.op_mode.ipc			= false;
+			s5p_vp_ctrl_private.op_mode.auto_toggling	= false;
+		}
+	}
+
+	src_plane->mem_type = ((src_plane->color_t == VP_SRC_COLOR_NV12) ||
+			(src_plane->color_t == VP_SRC_COLOR_NV12IW) ||
+			(src_plane->color_t == VP_SRC_COLOR_TILE_NV12) ||
+			(src_plane->color_t == VP_SRC_COLOR_TILE_NV12IW)) ?
+			VP_YUV420_NV12 : VP_YUV420_NV21;
+	src_plane->mem_mode = ((src_plane->color_t == VP_SRC_COLOR_NV12) ||
+			(src_plane->color_t == VP_SRC_COLOR_NV12IW) ||
+			(src_plane->color_t == VP_SRC_COLOR_NV21) ||
+			(src_plane->color_t == VP_SRC_COLOR_NV21IW)) ?
+			VP_LINEAR_MODE : VP_2D_TILE_MODE;
+
+	if (s5p_vp_ctrl_private.running) {
+		s5p_vp_ctrl_internal_stop();
+	} else {
+		s5p_vp_ctrl_clock(1);
+
+		s5p_vp_ctrl_private.running = true;
+	}
+
+	s5p_vp_ctrl_set_reg();
+
+	return 0;
+}
+
+int s5p_vp_ctrl_constructor(struct platform_device *pdev)
+{
+	int ret;
+
+	ret = s5p_tvout_map_resource_mem(pdev, s5p_vp_ctrl_private.reg_mem.name,
+					 &(s5p_vp_ctrl_private.reg_mem.base),
+					 &(s5p_vp_ctrl_private.reg_mem.res));
+
+	if (ret)
+		goto err_on_res;
+
+	s5p_vp_ctrl_private.clk.ptr = clk_get(&pdev->dev, s5p_vp_ctrl_private.clk.name);
+
+	if (IS_ERR(s5p_vp_ctrl_private.clk.ptr)) {
+		tvout_err("Failed to find clock %s\n", s5p_vp_ctrl_private.clk.name);
+		ret = -ENOENT;
+		goto err_on_clk;
+	}
+
+	s5p_vp_init(s5p_vp_ctrl_private.reg_mem.base);
+	s5p_vp_ctrl_init_private();
+
+	return 0;
+
+err_on_clk:
+	iounmap(s5p_vp_ctrl_private.reg_mem.base);
+	release_resource(s5p_vp_ctrl_private.reg_mem.res);
+	kfree(s5p_vp_ctrl_private.reg_mem.res);
+
+err_on_res:
+	return ret;
+}
+
+void s5p_vp_ctrl_destructor(void)
+{
+	if (s5p_vp_ctrl_private.reg_mem.base)
+		iounmap(s5p_vp_ctrl_private.reg_mem.base);
+
+	if (s5p_vp_ctrl_private.reg_mem.res) {
+		release_resource(s5p_vp_ctrl_private.reg_mem.res);
+		kfree(s5p_vp_ctrl_private.reg_mem.res);
+	}
+
+	if (s5p_vp_ctrl_private.clk.ptr) {
+		if (s5p_vp_ctrl_private.running)
+			clk_disable(s5p_vp_ctrl_private.clk.ptr);
+		clk_put(s5p_vp_ctrl_private.clk.ptr);
+	}
+}
+
+void s5p_vp_ctrl_suspend(void)
+{
+	if (s5p_vp_ctrl_private.running) {
+		s5p_vp_stop();
+		s5p_vp_ctrl_clock(0);
+	}
+}
+
+void s5p_vp_ctrl_resume(void)
+{
+	if (s5p_vp_ctrl_private.running) {
+		s5p_vp_ctrl_clock(1);
+		s5p_vp_ctrl_set_reg();
+	}
+}
-- 
1.7.1

