Return-path: <mchehab@pedra>
Received: from ganesha.gnumonks.org ([213.95.27.120]:42399 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab1BYIWM (ORCPT
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
Subject: [PATCH 2/5] [media] s5p-tvout: Add Graphic layer control for S5P TVOUT driver
Date: Fri, 25 Feb 2011 16:53:30 +0900
Message-Id: <1298620413-24182-3-git-send-email-a.kesavan@samsung.com>
In-Reply-To: <1298620413-24182-1-git-send-email-a.kesavan@samsung.com>
References: <1298620413-24182-1-git-send-email-a.kesavan@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Jiun Yu <jiun.yu@samsung.com>

This patch is for graphic driver. It controls mixer.

The Mixer overlaps or blends input data such as graphic, video, background
and sends the resulting data to the HDMI or analog TV interface. Along with
the YUV444 input from VP interface, the mixer can receive two RGB inputs.
It allows for layer blending, alpha blending, chroma key, scaling etc.

[based on work originally written by Sunil Choi <sunil111.choi@samsung.com>]
Cc: Kukjin Kim <kgene.kim@samsung.com>
Acked-by: KyungHwan Kim <kh.k.kim@samsung.com>
Signed-off-by: Jiun Yu <jiun.yu@samsung.com>
Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
---
 drivers/media/video/s5p-tvout/hw_if/mixer.c    |  816 ++++++++++++++++++
 drivers/media/video/s5p-tvout/s5p_mixer_ctrl.c |  975 +++++++++++++++++++++
 drivers/media/video/s5p-tvout/s5p_tvout_v4l2.c | 1081 ++++++++++++++++++++++++
 drivers/media/video/s5p-tvout/s5p_tvout_v4l2.h |   18 +
 4 files changed, 2890 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/s5p-tvout/hw_if/mixer.c
 create mode 100644 drivers/media/video/s5p-tvout/s5p_mixer_ctrl.c
 create mode 100644 drivers/media/video/s5p-tvout/s5p_tvout_v4l2.c
 create mode 100644 drivers/media/video/s5p-tvout/s5p_tvout_v4l2.h

diff --git a/drivers/media/video/s5p-tvout/hw_if/mixer.c b/drivers/media/video/s5p-tvout/hw_if/mixer.c
new file mode 100644
index 0000000..7c2d21d
--- /dev/null
+++ b/drivers/media/video/s5p-tvout/hw_if/mixer.c
@@ -0,0 +1,816 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Mixer raw ftn  file for Samsung TVOUT driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/io.h>
+
+#include <mach/regs-mixer.h>
+
+#include "../s5p_tvout_common_lib.h"
+#include "../s5p_tvout_ctrl.h"
+#include "hw_if.h"
+
+#undef tvout_dbg
+
+#ifdef CONFIG_MIXER_DEBUG
+#define tvout_dbg(fmt, ...)					\
+		printk(KERN_INFO "\t[MIXER] %s(): " fmt,	\
+			__func__, ##__VA_ARGS__)
+#else
+#define tvout_dbg(fmt, ...)
+#endif
+
+void __iomem	*mixer_base;
+spinlock_t	lock_mixer;
+
+int s5p_mixer_set_show(enum s5p_mixer_layer layer, bool show)
+{
+	u32 mxr_config;
+
+	tvout_dbg("%d, %d\n", layer, show);
+
+	switch (layer) {
+	case MIXER_VIDEO_LAYER:
+		mxr_config = (show) ?
+				(readl(mixer_base + S5P_MXR_CFG) |
+					S5P_MXR_CFG_VIDEO_ENABLE) :
+				(readl(mixer_base + S5P_MXR_CFG) &
+					~S5P_MXR_CFG_VIDEO_ENABLE);
+		break;
+
+	case MIXER_GPR0_LAYER:
+		mxr_config = (show) ?
+				(readl(mixer_base + S5P_MXR_CFG) |
+					S5P_MXR_CFG_GRAPHIC0_ENABLE) :
+				(readl(mixer_base + S5P_MXR_CFG) &
+					~S5P_MXR_CFG_GRAPHIC0_ENABLE);
+		break;
+
+	case MIXER_GPR1_LAYER:
+		mxr_config = (show) ?
+				(readl(mixer_base + S5P_MXR_CFG) |
+					S5P_MXR_CFG_GRAPHIC1_ENABLE) :
+				(readl(mixer_base + S5P_MXR_CFG) &
+					~S5P_MXR_CFG_GRAPHIC1_ENABLE);
+		break;
+
+	default:
+		tvout_err("invalid layer parameter = %d\n", layer);
+		return -1;
+	}
+
+	writel(mxr_config, mixer_base + S5P_MXR_CFG);
+
+	return 0;
+}
+
+int s5p_mixer_set_priority(enum s5p_mixer_layer layer, u32 priority)
+{
+	u32 layer_cfg;
+
+	tvout_dbg("%d, %d\n", layer, priority);
+
+	switch (layer) {
+	case MIXER_VIDEO_LAYER:
+		layer_cfg = S5P_MXR_LAYER_CFG_VID_PRIORITY_CLR(
+				readl(mixer_base + S5P_MXR_LAYER_CFG)) |
+				S5P_MXR_LAYER_CFG_VID_PRIORITY(priority);
+		break;
+
+	case MIXER_GPR0_LAYER:
+		layer_cfg = S5P_MXR_LAYER_CFG_GRP0_PRIORITY_CLR(
+				readl(mixer_base + S5P_MXR_LAYER_CFG)) |
+				S5P_MXR_LAYER_CFG_GRP0_PRIORITY(priority);
+		break;
+
+	case MIXER_GPR1_LAYER:
+		layer_cfg = S5P_MXR_LAYER_CFG_GRP1_PRIORITY_CLR(
+				readl(mixer_base + S5P_MXR_LAYER_CFG)) |
+				S5P_MXR_LAYER_CFG_GRP1_PRIORITY(priority);
+		break;
+
+	default:
+		tvout_err("invalid layer parameter = %d\n", layer);
+		return -1;
+	}
+
+	writel(layer_cfg, mixer_base + S5P_MXR_LAYER_CFG);
+
+	return 0;
+}
+
+void s5p_mixer_set_pre_mul_mode(enum s5p_mixer_layer layer, bool enable)
+{
+	u32 reg;
+
+	switch (layer) {
+	case MIXER_GPR0_LAYER:
+		reg = readl(mixer_base + S5P_MXR_GRAPHIC0_CFG);
+
+		if (enable)
+			reg |= S5P_MXR_PRE_MUL_MODE;
+		else
+			reg &= ~S5P_MXR_PRE_MUL_MODE;
+
+		writel(reg, mixer_base + S5P_MXR_GRAPHIC0_CFG);
+		break;
+
+	case MIXER_GPR1_LAYER:
+		reg = readl(mixer_base + S5P_MXR_GRAPHIC1_CFG);
+
+		if (enable)
+			reg |= S5P_MXR_PRE_MUL_MODE;
+		else
+			reg &= ~S5P_MXR_PRE_MUL_MODE;
+
+		writel(reg, mixer_base + S5P_MXR_GRAPHIC1_CFG);
+		break;
+
+	case MIXER_VIDEO_LAYER:
+		break;
+	}
+}
+
+int s5p_mixer_set_pixel_blend(enum s5p_mixer_layer layer, bool enable)
+{
+	u32 temp_reg;
+
+	tvout_dbg("%d, %d\n", layer, enable);
+
+	switch (layer) {
+	case MIXER_GPR0_LAYER:
+		temp_reg = readl(mixer_base + S5P_MXR_GRAPHIC0_CFG)
+			& (~S5P_MXR_PIXEL_BLEND_ENABLE) ;
+
+		if (enable)
+			temp_reg |= S5P_MXR_PIXEL_BLEND_ENABLE;
+		else
+			temp_reg |= S5P_MXR_PIXEL_BLEND_DISABLE;
+
+		writel(temp_reg, mixer_base + S5P_MXR_GRAPHIC0_CFG);
+		break;
+
+	case MIXER_GPR1_LAYER:
+		temp_reg = readl(mixer_base + S5P_MXR_GRAPHIC1_CFG)
+			& (~S5P_MXR_PIXEL_BLEND_ENABLE) ;
+
+		if (enable)
+			temp_reg |= S5P_MXR_PIXEL_BLEND_ENABLE;
+		else
+			temp_reg |= S5P_MXR_PIXEL_BLEND_DISABLE;
+
+		writel(temp_reg, mixer_base + S5P_MXR_GRAPHIC1_CFG);
+		break;
+
+	default:
+		tvout_err("invalid layer parameter = %d\n", layer);
+
+		return -1;
+	}
+
+	return 0;
+}
+
+int s5p_mixer_set_layer_blend(enum s5p_mixer_layer layer, bool enable)
+{
+	u32 temp_reg;
+
+	tvout_dbg("%d, %d\n", layer, enable);
+
+	switch (layer) {
+	case MIXER_VIDEO_LAYER:
+		temp_reg = readl(mixer_base + S5P_MXR_VIDEO_CFG)
+			   & (~S5P_MXR_VIDEO_CFG_BLEND_EN) ;
+
+		if (enable)
+			temp_reg |= S5P_MXR_VIDEO_CFG_BLEND_EN;
+		else
+			temp_reg |= S5P_MXR_VIDEO_CFG_BLEND_DIS;
+
+		writel(temp_reg, mixer_base + S5P_MXR_VIDEO_CFG);
+		break;
+
+	case MIXER_GPR0_LAYER:
+		temp_reg = readl(mixer_base + S5P_MXR_GRAPHIC0_CFG)
+			   & (~S5P_MXR_WIN_BLEND_ENABLE) ;
+
+		if (enable)
+			temp_reg |= S5P_MXR_WIN_BLEND_ENABLE;
+		else
+			temp_reg |= S5P_MXR_WIN_BLEND_DISABLE;
+
+		writel(temp_reg, mixer_base + S5P_MXR_GRAPHIC0_CFG);
+		break;
+
+	case MIXER_GPR1_LAYER:
+		temp_reg = readl(mixer_base + S5P_MXR_GRAPHIC1_CFG)
+			   & (~S5P_MXR_WIN_BLEND_ENABLE) ;
+
+		if (enable)
+			temp_reg |= S5P_MXR_WIN_BLEND_ENABLE;
+		else
+			temp_reg |= S5P_MXR_WIN_BLEND_DISABLE;
+
+		writel(temp_reg, mixer_base + S5P_MXR_GRAPHIC1_CFG);
+		break;
+
+	default:
+		tvout_err("invalid layer parameter = %d\n", layer);
+
+		return -1;
+	}
+
+	return 0;
+}
+
+int s5p_mixer_set_alpha(enum s5p_mixer_layer layer, u32 alpha)
+{
+	u32 temp_reg;
+
+	tvout_dbg("%d, %d\n", layer, alpha);
+
+	switch (layer) {
+	case MIXER_VIDEO_LAYER:
+		temp_reg = readl(mixer_base + S5P_MXR_VIDEO_CFG)
+			   & (~S5P_MXR_VIDEO_CFG_ALPHA_MASK) ;
+		temp_reg |= S5P_MXR_VIDEO_CFG_ALPHA_VALUE(alpha);
+		writel(temp_reg, mixer_base + S5P_MXR_VIDEO_CFG);
+		break;
+
+	case MIXER_GPR0_LAYER:
+		temp_reg = readl(mixer_base + S5P_MXR_GRAPHIC0_CFG)
+			   & (~S5P_MXR_VIDEO_CFG_ALPHA_MASK) ;
+		temp_reg |= S5P_MXR_GRP_ALPHA_VALUE(alpha);
+		writel(temp_reg, mixer_base + S5P_MXR_GRAPHIC0_CFG);
+		break;
+
+	case MIXER_GPR1_LAYER:
+		temp_reg = readl(mixer_base + S5P_MXR_GRAPHIC1_CFG)
+			   & (~S5P_MXR_VIDEO_CFG_ALPHA_MASK) ;
+		temp_reg |= S5P_MXR_GRP_ALPHA_VALUE(alpha);
+		writel(temp_reg, mixer_base + S5P_MXR_GRAPHIC1_CFG);
+		break;
+
+	default:
+		tvout_err("invalid layer parameter = %d\n", layer);
+		return -1;
+	}
+
+	return 0;
+}
+
+int s5p_mixer_set_grp_base_address(enum s5p_mixer_layer layer, u32 base_addr)
+{
+	tvout_dbg("%d, 0x%x\n", layer, base_addr);
+
+	if (S5P_MXR_GRP_ADDR_ILLEGAL(base_addr)) {
+		tvout_err("address is not word align = %d\n", base_addr);
+		return -1;
+	}
+
+	switch (layer) {
+	case MIXER_GPR0_LAYER:
+		writel(S5P_MXR_GPR_BASE(base_addr),
+			mixer_base + S5P_MXR_GRAPHIC0_BASE);
+		break;
+
+	case MIXER_GPR1_LAYER:
+		writel(S5P_MXR_GPR_BASE(base_addr),
+			mixer_base + S5P_MXR_GRAPHIC1_BASE);
+		break;
+
+	default:
+		tvout_err("invalid layer parameter = %d\n", layer);
+		return -1;
+	}
+
+	return 0;
+}
+
+int s5p_mixer_set_grp_layer_dst_pos(enum s5p_mixer_layer layer,
+				    u32 dst_offs_x, u32 dst_offs_y)
+{
+	tvout_dbg("%d, %d, %d\n", layer, dst_offs_x, dst_offs_y);
+
+	switch (layer) {
+	case MIXER_GPR0_LAYER:
+		writel(S5P_MXR_GRP_DESTX(dst_offs_x) |
+			S5P_MXR_GRP_DESTY(dst_offs_y),
+			mixer_base + S5P_MXR_GRAPHIC0_DXY);
+		break;
+
+	case MIXER_GPR1_LAYER:
+		writel(S5P_MXR_GRP_DESTX(dst_offs_x) |
+			S5P_MXR_GRP_DESTY(dst_offs_y),
+			mixer_base + S5P_MXR_GRAPHIC1_DXY);
+		break;
+
+	default:
+		tvout_err("invalid layer parameter = %d\n", layer);
+		return -1;
+	}
+
+	return 0;
+}
+
+int s5p_mixer_set_grp_layer_src_pos(enum s5p_mixer_layer layer,
+				    u32 src_offs_x, u32 src_offs_y, u32 span,
+				    u32 width, u32 height)
+{
+	tvout_dbg("%d, %d, %d, %d, %d, %d\n", layer, span, width, height, src_offs_x, src_offs_y);
+
+	switch (layer) {
+	case MIXER_GPR0_LAYER:
+		writel(S5P_MXR_GRP_SPAN(span),
+			mixer_base + S5P_MXR_GRAPHIC0_SPAN);
+		writel(S5P_MXR_GRP_WIDTH(width) | S5P_MXR_GRP_HEIGHT(height),
+		       mixer_base + S5P_MXR_GRAPHIC0_WH);
+		writel(S5P_MXR_GRP_STARTX(src_offs_x) |
+			S5P_MXR_GRP_STARTY(src_offs_y),
+		       mixer_base + S5P_MXR_GRAPHIC0_SXY);
+		break;
+
+	case MIXER_GPR1_LAYER:
+		writel(S5P_MXR_GRP_SPAN(span),
+			mixer_base + S5P_MXR_GRAPHIC1_SPAN);
+		writel(S5P_MXR_GRP_WIDTH(width) | S5P_MXR_GRP_HEIGHT(height),
+		       mixer_base + S5P_MXR_GRAPHIC1_WH);
+		writel(S5P_MXR_GRP_STARTX(src_offs_x) |
+			S5P_MXR_GRP_STARTY(src_offs_y),
+		       mixer_base + S5P_MXR_GRAPHIC1_SXY);
+		break;
+
+	default:
+		tvout_err(" invalid layer parameter = %d\n", layer);
+		return -1;
+	}
+
+	return 0;
+}
+
+void s5p_mixer_set_bg_color(enum s5p_mixer_bg_color_num colornum,
+			    u32 color_y, u32 color_cb, u32 color_cr)
+{
+	u32 reg_value;
+
+	reg_value = S5P_MXR_BG_COLOR_Y(color_y) |
+			S5P_MXR_BG_COLOR_CB(color_cb) |
+			S5P_MXR_BG_COLOR_CR(color_cr);
+
+	switch (colornum) {
+	case MIXER_BG_COLOR_0:
+		writel(reg_value, mixer_base + S5P_MXR_BG_COLOR0);
+		break;
+
+	case MIXER_BG_COLOR_1:
+		writel(reg_value, mixer_base + S5P_MXR_BG_COLOR1);
+		break;
+
+	case MIXER_BG_COLOR_2:
+		writel(reg_value, mixer_base + S5P_MXR_BG_COLOR2);
+		break;
+	}
+}
+
+void s5p_mixer_init_status_reg(enum s5p_mixer_burst_mode burst,
+			       enum s5p_tvout_endian endian)
+{
+	u32 temp_reg = 0;
+
+	temp_reg = S5P_MXR_STATUS_SYNC_ENABLE | S5P_MXR_STATUS_OPERATING;
+
+	switch (burst) {
+	case MIXER_BURST_8:
+		temp_reg |= S5P_MXR_STATUS_8_BURST;
+		break;
+	case MIXER_BURST_16:
+		temp_reg |= S5P_MXR_STATUS_16_BURST;
+		break;
+	}
+
+	switch (endian) {
+	case TVOUT_BIG_ENDIAN:
+		temp_reg |= S5P_MXR_STATUS_BIG_ENDIAN;
+		break;
+	case TVOUT_LITTLE_ENDIAN:
+		temp_reg |= S5P_MXR_STATUS_LITTLE_ENDIAN;
+		break;
+	}
+
+	writel(temp_reg, mixer_base + S5P_MXR_STATUS);
+}
+
+int s5p_mixer_init_display_mode(enum s5p_tvout_disp_mode mode,
+				enum s5p_tvout_o_mode output_mode)
+{
+	u32 temp_reg = readl(mixer_base + S5P_MXR_CFG);
+
+	tvout_dbg("%d, %d\n", mode, output_mode);
+
+	switch (mode) {
+	case TVOUT_NTSC_M:
+	case TVOUT_NTSC_443:
+		temp_reg &= ~S5P_MXR_CFG_HD;
+		temp_reg &= ~S5P_MXR_CFG_PAL;
+		temp_reg &= S5P_MXR_CFG_INTERLACE;
+		break;
+
+	case TVOUT_PAL_BDGHI:
+	case TVOUT_PAL_M:
+	case TVOUT_PAL_N:
+	case TVOUT_PAL_NC:
+	case TVOUT_PAL_60:
+		temp_reg &= ~S5P_MXR_CFG_HD;
+		temp_reg |= S5P_MXR_CFG_PAL;
+		temp_reg &= S5P_MXR_CFG_INTERLACE;
+		break;
+
+	case TVOUT_480P_60_16_9:
+	case TVOUT_480P_60_4_3:
+	case TVOUT_480P_59:
+		temp_reg &= ~S5P_MXR_CFG_HD;
+		temp_reg &= ~S5P_MXR_CFG_PAL;
+		temp_reg |= S5P_MXR_CFG_PROGRASSIVE;
+		temp_reg |= MIXER_RGB601_16_235<<9;
+		break;
+
+	case TVOUT_576P_50_16_9:
+	case TVOUT_576P_50_4_3:
+		temp_reg &= ~S5P_MXR_CFG_HD;
+		temp_reg |= S5P_MXR_CFG_PAL;
+		temp_reg |= S5P_MXR_CFG_PROGRASSIVE;
+		temp_reg |= MIXER_RGB601_16_235<<9;
+		break;
+
+	case TVOUT_720P_50:
+	case TVOUT_720P_59:
+	case TVOUT_720P_60:
+		temp_reg |= S5P_MXR_CFG_HD;
+		temp_reg &= ~S5P_MXR_CFG_HD_1080I;
+		temp_reg |= S5P_MXR_CFG_PROGRASSIVE;
+		temp_reg |= MIXER_RGB709_16_235<<9;
+		break;
+
+	case TVOUT_1080I_50:
+	case TVOUT_1080I_59:
+	case TVOUT_1080I_60:
+		temp_reg |= S5P_MXR_CFG_HD;
+		temp_reg |= S5P_MXR_CFG_HD_1080I;
+		temp_reg &= S5P_MXR_CFG_INTERLACE;
+		temp_reg |= MIXER_RGB709_16_235<<9;
+		break;
+
+	case TVOUT_1080P_50:
+	case TVOUT_1080P_59:
+	case TVOUT_1080P_60:
+	case TVOUT_1080P_30:
+		temp_reg |= S5P_MXR_CFG_HD;
+		temp_reg |= S5P_MXR_CFG_HD_1080P;
+		temp_reg |= S5P_MXR_CFG_PROGRASSIVE;
+		temp_reg |= MIXER_RGB709_16_235<<9;
+		break;
+
+	default:
+		tvout_err("invalid mode parameter = %d\n", mode);
+		return -1;
+	}
+
+	switch (output_mode) {
+	case TVOUT_COMPOSITE:
+		temp_reg &= S5P_MXR_CFG_TV_OUT;
+		temp_reg &= ~(0x1<<8);
+		temp_reg |= MIXER_YUV444<<8;
+		break;
+
+	case TVOUT_HDMI_RGB:
+	case TVOUT_DVI:
+		temp_reg |= S5P_MXR_CFG_HDMI_OUT;
+		temp_reg &= ~(0x1<<8);
+		temp_reg |= MIXER_RGB888<<8;
+		break;
+
+	case TVOUT_HDMI:
+		temp_reg |= S5P_MXR_CFG_HDMI_OUT;
+		temp_reg &= ~(0x1<<8);
+		temp_reg |= MIXER_YUV444<<8;
+		break;
+
+	default:
+		tvout_err("invalid mode parameter = %d\n", mode);
+		return -1;
+	}
+
+	writel(temp_reg, mixer_base + S5P_MXR_CFG);
+
+	return 0;
+}
+
+void s5p_mixer_scaling(enum s5p_mixer_layer layer,
+		       struct s5ptvfb_user_scaling scaling)
+{
+	u32 reg, ver_val = 0, hor_val = 0;
+
+	switch (scaling.ver) {
+	case VERTICAL_X1:
+		ver_val = 0;
+		break;
+
+	case VERTICAL_X2:
+		ver_val = 1;
+		break;
+	}
+
+	switch (scaling.hor) {
+	case HORIZONTAL_X1:
+		hor_val = 0;
+		break;
+
+	case HORIZONTAL_X2:
+		hor_val = 1;
+		break;
+	}
+
+	switch (layer) {
+	case MIXER_GPR0_LAYER:
+		reg = readl(mixer_base + S5P_MXR_GRAPHIC0_WH);
+		reg |= S5P_MXR_GRP_V_SCALE(ver_val);
+		reg |= S5P_MXR_GRP_H_SCALE(hor_val);
+		writel(reg, mixer_base + S5P_MXR_GRAPHIC0_WH);
+		break;
+
+	case MIXER_GPR1_LAYER:
+		reg = readl(mixer_base + S5P_MXR_GRAPHIC1_WH);
+		reg |= S5P_MXR_GRP_V_SCALE(ver_val);
+		reg |= S5P_MXR_GRP_H_SCALE(hor_val);
+		writel(reg, mixer_base + S5P_MXR_GRAPHIC1_WH);
+		break;
+
+	case MIXER_VIDEO_LAYER:
+		break;
+	}
+}
+
+void s5p_mixer_set_color_format(enum s5p_mixer_layer layer,
+				enum s5p_mixer_color_fmt format)
+{
+	u32 reg;
+
+	switch (layer) {
+	case MIXER_GPR0_LAYER:
+		reg = readl(mixer_base + S5P_MXR_GRAPHIC0_CFG);
+		reg &= ~(S5P_MXR_EG_COLOR_FORMAT(0xf));
+		reg |= S5P_MXR_EG_COLOR_FORMAT(format);
+		writel(reg, mixer_base + S5P_MXR_GRAPHIC0_CFG);
+		break;
+
+	case MIXER_GPR1_LAYER:
+		reg = readl(mixer_base + S5P_MXR_GRAPHIC1_CFG);
+		reg &= ~(S5P_MXR_EG_COLOR_FORMAT(0xf));
+		reg |= S5P_MXR_EG_COLOR_FORMAT(format);
+		writel(reg, mixer_base + S5P_MXR_GRAPHIC1_CFG);
+		break;
+
+	case MIXER_VIDEO_LAYER:
+		break;
+	}
+}
+
+void s5p_mixer_set_chroma_key(enum s5p_mixer_layer layer, bool enabled, u32 key)
+{
+	u32 reg;
+
+	switch (layer) {
+	case MIXER_GPR0_LAYER:
+		reg = readl(mixer_base + S5P_MXR_GRAPHIC0_CFG);
+
+		if (enabled)
+			reg &= ~S5P_MXR_BLANK_CHANGE_NEW_PIXEL;
+		else
+			reg |= S5P_MXR_BLANK_CHANGE_NEW_PIXEL;
+
+		writel(reg, mixer_base + S5P_MXR_GRAPHIC0_CFG);
+		writel(S5P_MXR_GPR_BLANK_COLOR(key),
+			mixer_base + S5P_MXR_GRAPHIC0_BLANK);
+		break;
+
+	case MIXER_GPR1_LAYER:
+		reg = readl(mixer_base + S5P_MXR_GRAPHIC1_CFG);
+
+		if (enabled)
+			reg &= ~S5P_MXR_BLANK_CHANGE_NEW_PIXEL;
+		else
+			reg |= S5P_MXR_BLANK_CHANGE_NEW_PIXEL;
+
+		writel(reg, mixer_base + S5P_MXR_GRAPHIC1_CFG);
+		writel(S5P_MXR_GPR_BLANK_COLOR(key),
+				mixer_base + S5P_MXR_GRAPHIC1_BLANK);
+		break;
+
+	case MIXER_VIDEO_LAYER:
+		break;
+	}
+}
+
+void s5p_mixer_init_bg_dither_enable(bool cr_dither_enable,
+				     bool cb_dither_enable,
+				     bool y_dither_enable)
+{
+	u32 temp_reg = 0;
+
+	tvout_dbg("%d, %d, %d\n", cr_dither_enable, cb_dither_enable,
+		y_dither_enable);
+
+	temp_reg = (cr_dither_enable) ?
+		   (temp_reg | S5P_MXR_BG_CR_DIHER_EN) :
+		   (temp_reg & ~S5P_MXR_BG_CR_DIHER_EN);
+	temp_reg = (cb_dither_enable) ?
+		   (temp_reg | S5P_MXR_BG_CB_DIHER_EN) :
+		   (temp_reg & ~S5P_MXR_BG_CB_DIHER_EN);
+	temp_reg = (y_dither_enable) ?
+		   (temp_reg | S5P_MXR_BG_Y_DIHER_EN) :
+		   (temp_reg & ~S5P_MXR_BG_Y_DIHER_EN);
+
+	writel(temp_reg, mixer_base + S5P_MXR_BG_CFG);
+
+}
+
+void s5p_mixer_init_csc_coef_default(enum s5p_mixer_csc_type csc_type)
+{
+	tvout_dbg("%d\n", csc_type);
+
+	switch (csc_type) {
+	case MIXER_CSC_601_LR:
+		writel((0 << 30) | (153 << 20) | (300 << 10) | (58 << 0),
+			mixer_base + S5P_MXR_CM_COEFF_Y);
+		writel((936 << 20) | (851 << 10) | (262 << 0),
+			mixer_base + S5P_MXR_CM_COEFF_CB);
+		writel((262 << 20) | (805 << 10) | (982 << 0),
+			mixer_base + S5P_MXR_CM_COEFF_CR);
+		break;
+
+	case MIXER_CSC_601_FR:
+		writel((1 << 30) | (132 << 20) | (258 << 10) | (50 << 0),
+			mixer_base + S5P_MXR_CM_COEFF_Y);
+		writel((948 << 20) | (875 << 10) | (225 << 0),
+			mixer_base + S5P_MXR_CM_COEFF_CB);
+		writel((225 << 20) | (836 << 10) | (988 << 0),
+			mixer_base + S5P_MXR_CM_COEFF_CR);
+		break;
+
+	case MIXER_CSC_709_LR:
+		writel((0 << 30) | (109 << 20) | (366 << 10) | (36 << 0),
+			mixer_base + S5P_MXR_CM_COEFF_Y);
+		writel((964 << 20) | (822 << 10) | (216 << 0),
+			mixer_base + S5P_MXR_CM_COEFF_CB);
+		writel((262 << 20) | (787 << 10) | (1000 << 0),
+			mixer_base + S5P_MXR_CM_COEFF_CR);
+		break;
+
+	case MIXER_CSC_709_FR:
+		writel((1 << 30) | (94 << 20) | (314 << 10) | (32 << 0),
+			mixer_base + S5P_MXR_CM_COEFF_Y);
+		writel((972 << 20) | (851 << 10) | (225 << 0),
+			mixer_base + S5P_MXR_CM_COEFF_CB);
+		writel((225 << 20) | (820 << 10) | (1004 << 0),
+			mixer_base + S5P_MXR_CM_COEFF_CR);
+		break;
+
+	default:
+		tvout_err("invalid csc_type parameter = %d\n", csc_type);
+		break;
+	}
+}
+
+void s5p_mixer_start(void)
+{
+	writel((readl(mixer_base + S5P_MXR_STATUS) | S5P_MXR_STATUS_RUN),
+		mixer_base + S5P_MXR_STATUS);
+}
+
+void s5p_mixer_stop(void)
+{
+	u32 reg = readl(mixer_base + S5P_MXR_STATUS);
+
+	reg &= ~S5P_MXR_STATUS_RUN;
+
+	writel(reg, mixer_base + S5P_MXR_STATUS);
+
+	do {
+		reg = readl(mixer_base + S5P_MXR_STATUS);
+	} while (!(reg & S5P_MXR_STATUS_IDLE_MODE));
+}
+
+void s5p_mixer_set_underflow_int_enable(enum s5p_mixer_layer layer, bool en)
+{
+	u32 enable_mask = 0;
+
+	switch (layer) {
+	case MIXER_VIDEO_LAYER:
+		enable_mask = S5P_MXR_INT_EN_VP_ENABLE;
+		break;
+
+	case MIXER_GPR0_LAYER:
+		enable_mask = S5P_MXR_INT_EN_GRP0_ENABLE;
+		break;
+
+	case MIXER_GPR1_LAYER:
+		enable_mask = S5P_MXR_INT_EN_GRP1_ENABLE;
+		break;
+	}
+
+	if (en)
+		writel((readl(mixer_base + S5P_MXR_INT_EN) | enable_mask),
+			mixer_base + S5P_MXR_INT_EN);
+	else
+		writel((readl(mixer_base + S5P_MXR_INT_EN) & ~enable_mask),
+			mixer_base + S5P_MXR_INT_EN);
+}
+
+void s5p_mixer_set_vsync_interrupt(bool en)
+{
+	if (en) {
+		writel(S5P_MXR_INT_STATUS_VSYNC_CLEARED, mixer_base +
+			S5P_MXR_INT_STATUS);
+		writel((readl(mixer_base + S5P_MXR_INT_EN) |
+			S5P_MXR_INT_EN_VSYNC_ENABLE),
+			mixer_base + S5P_MXR_INT_EN);
+	} else {
+		writel((readl(mixer_base + S5P_MXR_INT_EN) &
+			~S5P_MXR_INT_EN_VSYNC_ENABLE),
+			mixer_base + S5P_MXR_INT_EN);
+	}
+
+	tvout_dbg("%s mixer VSYNC interrupt.\n", en ? "Enable" : "Disable");
+}
+
+void s5p_mixer_clear_pend_all(void)
+{
+	writel(S5P_MXR_INT_STATUS_INT_FIRED | S5P_MXR_INT_STATUS_VP_FIRED |
+		S5P_MXR_INT_STATUS_GRP0_FIRED | S5P_MXR_INT_STATUS_GRP1_FIRED,
+		mixer_base + S5P_MXR_INT_STATUS);
+}
+
+irqreturn_t s5p_mixer_irq(int irq, void *dev_id)
+{
+	bool v_i_f;
+	bool g0_i_f;
+	bool g1_i_f;
+	bool mxr_i_f;
+	u32 temp_reg = 0;
+
+	spin_lock_irq(&lock_mixer);
+
+	v_i_f = (readl(mixer_base + S5P_MXR_INT_STATUS)
+			& S5P_MXR_INT_STATUS_VP_FIRED) ? true : false;
+	g0_i_f = (readl(mixer_base + S5P_MXR_INT_STATUS)
+			& S5P_MXR_INT_STATUS_GRP0_FIRED) ? true : false;
+	g1_i_f = (readl(mixer_base + S5P_MXR_INT_STATUS)
+			& S5P_MXR_INT_STATUS_GRP1_FIRED) ? true : false;
+	mxr_i_f = (readl(mixer_base + S5P_MXR_INT_STATUS)
+			& S5P_MXR_INT_STATUS_INT_FIRED) ? true : false;
+
+	if (mxr_i_f) {
+		temp_reg |= S5P_MXR_INT_STATUS_INT_FIRED;
+
+		if (v_i_f) {
+			temp_reg |= S5P_MXR_INT_STATUS_VP_FIRED;
+			tvout_dbg("VP fifo under run!!\n");
+		}
+
+		if (g0_i_f) {
+			temp_reg |= S5P_MXR_INT_STATUS_GRP0_FIRED;
+			tvout_dbg("GRP0 fifo under run!!\n");
+		}
+
+		if (g1_i_f) {
+			temp_reg |= S5P_MXR_INT_STATUS_GRP1_FIRED;
+			tvout_dbg("GRP1 fifo under run!!\n");
+		}
+
+		if (!v_i_f && !g0_i_f && !g1_i_f) {
+			writel(S5P_MXR_INT_STATUS_VSYNC_CLEARED,
+				mixer_base + S5P_MXR_INT_STATUS);
+			wake_up(&s5ptv_wq);
+		} else {
+			writel(temp_reg, mixer_base + S5P_MXR_INT_STATUS);
+		}
+	}
+
+	spin_unlock_irq(&lock_mixer);
+
+	return IRQ_HANDLED;
+}
+
+void s5p_mixer_init(void __iomem *addr)
+{
+	mixer_base = addr;
+
+	spin_lock_init(&lock_mixer);
+}
diff --git a/drivers/media/video/s5p-tvout/s5p_mixer_ctrl.c b/drivers/media/video/s5p-tvout/s5p_mixer_ctrl.c
new file mode 100644
index 0000000..fd4b66d
--- /dev/null
+++ b/drivers/media/video/s5p-tvout/s5p_mixer_ctrl.c
@@ -0,0 +1,975 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * Functions of mixer ctrl class for Samsung TVOUT driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/clk.h>
+#include <linux/slab.h>
+#include <linux/dma-mapping.h>
+
+#include "hw_if/hw_if.h"
+#include "s5p_tvout_ctrl.h"
+
+enum {
+	ACLK,
+	MUX,
+	NO_OF_CLK
+};
+
+struct s5p_bg_color {
+	u32 color_y;
+	u32 color_cb;
+	u32 color_cr;
+};
+
+struct s5p_mixer_video_layer_info {
+	bool layer_blend;
+	u32 alpha;
+	u32 priority;
+
+	bool use_video_layer;
+};
+
+struct s5p_mixer_grp_layer_info {
+	bool pixel_blend;
+	bool layer_blend;
+	u32 alpha;
+
+	bool chroma_enable;
+	u32 chroma_key;
+
+	bool pre_mul_mode;
+
+	u32 src_x;
+	u32 src_y;
+	u32 dst_x;
+	u32 dst_y;
+	u32 width;
+	u32 height;
+	dma_addr_t fb_addr;
+
+	bool use_grp_layer;
+
+	u32 priority;
+	enum s5p_mixer_color_fmt format;
+
+	enum s5ptvfb_ver_scaling_t ver;
+	enum s5ptvfb_hor_scaling_t hor;
+};
+
+struct s5p_mixer_ctrl_private_data {
+	char					*pow_name;
+	struct s5p_tvout_clk_info		clk[NO_OF_CLK];
+	struct irq_info				irq;
+	struct reg_mem_info			reg_mem;
+
+	enum s5p_mixer_burst_mode		burst;
+	enum s5p_tvout_endian			endian;
+	struct s5p_bg_color			bg_color[3];
+
+	struct s5p_mixer_video_layer_info	v_layer;
+	struct s5p_mixer_grp_layer_info		layer[S5PTV_FB_CNT];
+
+	bool					running;
+};
+
+static struct s5p_mixer_ctrl_private_data s5p_mixer_ctrl_private = {
+	.pow_name	= "mixer_pd",
+
+	.clk[ACLK] = {
+		.name		= "mixer",
+		.ptr		= NULL
+	},
+	.clk[MUX] = {
+		.name		= "sclk_mixer",
+		.ptr		= NULL
+	},
+	.irq = {
+		.name		= "s5p-mixer",
+		.handler	= s5p_mixer_irq,
+		.no		= -1
+	},
+	.reg_mem = {
+		.name		= "s5p-mixer",
+		.res		= NULL,
+		.base		= NULL
+	},
+
+	.burst		= MIXER_BURST_16,
+	.endian		= TVOUT_LITTLE_ENDIAN,
+
+	.bg_color[0].color_y	= 0,
+	.bg_color[0].color_cb	= 128,
+	.bg_color[0].color_cr	= 128,
+	.bg_color[1].color_y	= 0,
+	.bg_color[1].color_cb	= 128,
+	.bg_color[1].color_cr	= 128,
+	.bg_color[2].color_y	= 0,
+	.bg_color[2].color_cb	= 128,
+	.bg_color[2].color_cr	= 128,
+
+	.v_layer = {
+		.layer_blend	= false,
+		.alpha		= 0xff,
+		.priority	= 10
+	},
+	.layer[MIXER_GPR0_LAYER] = {
+		.pixel_blend	= false,
+		.layer_blend	= false,
+		.alpha		= 0xff,
+		.chroma_enable	= false,
+		.chroma_key	= 0x0,
+		.pre_mul_mode	= false,
+		.src_x		= 0,
+		.src_y		= 0,
+		.dst_x		= 0,
+		.dst_y		= 0,
+		.width		= 0,
+		.height		= 0,
+		.priority	= 10,
+		.format		= MIXER_RGB8888,
+		.ver		= VERTICAL_X1,
+		.hor		= HORIZONTAL_X1
+	},
+	.layer[MIXER_GPR1_LAYER] = {
+		.pixel_blend	= false,
+		.layer_blend	= false,
+		.alpha		= 0xff,
+		.chroma_enable	= false,
+		.chroma_key	= 0x0,
+		.pre_mul_mode	= false,
+		.src_x		= 0,
+		.src_y		= 0,
+		.dst_x		= 0,
+		.dst_y		= 0,
+		.width		= 0,
+		.height		= 0,
+		.priority	= 10,
+		.format		= MIXER_RGB8888,
+		.ver		= VERTICAL_X1,
+		.hor		= HORIZONTAL_X1
+	},
+	.running	= false,
+};
+
+static int s5p_mixer_ctrl_set_reg(enum s5p_mixer_layer layer)
+{
+	bool layer_blend;
+	u32 alpha;
+	u32 priority;
+	struct s5ptvfb_user_scaling scaling;
+
+	switch (layer) {
+	case MIXER_VIDEO_LAYER:
+		layer_blend = s5p_mixer_ctrl_private.v_layer.layer_blend;
+		alpha = s5p_mixer_ctrl_private.v_layer.alpha;
+		priority = s5p_mixer_ctrl_private.v_layer.priority;
+		break;
+
+	case MIXER_GPR0_LAYER:
+	case MIXER_GPR1_LAYER:
+		layer_blend = s5p_mixer_ctrl_private.layer[layer].layer_blend;
+		alpha = s5p_mixer_ctrl_private.layer[layer].alpha;
+		priority = s5p_mixer_ctrl_private.layer[layer].priority;
+
+		s5p_mixer_set_pre_mul_mode(layer,
+			s5p_mixer_ctrl_private.layer[layer].pre_mul_mode);
+
+		s5p_mixer_set_chroma_key(layer,
+			s5p_mixer_ctrl_private.layer[layer].chroma_enable,
+			s5p_mixer_ctrl_private.layer[layer].chroma_key);
+
+		s5p_mixer_set_grp_layer_dst_pos(layer,
+			s5p_mixer_ctrl_private.layer[layer].dst_x,
+			s5p_mixer_ctrl_private.layer[layer].dst_y);
+
+		scaling.ver = s5p_mixer_ctrl_private.layer[layer].ver;
+		scaling.hor = s5p_mixer_ctrl_private.layer[layer].hor;
+
+		s5p_mixer_scaling(layer, scaling);
+		s5p_mixer_set_grp_base_address(layer,
+			s5p_mixer_ctrl_private.layer[layer].fb_addr);
+
+		s5p_mixer_set_color_format(layer,
+			s5p_mixer_ctrl_private.layer[layer].format);
+
+		s5p_mixer_set_grp_layer_src_pos(layer,
+			s5p_mixer_ctrl_private.layer[layer].src_x,
+			s5p_mixer_ctrl_private.layer[layer].src_y,
+			s5p_mixer_ctrl_private.layer[layer].width,
+			s5p_mixer_ctrl_private.layer[layer].width,
+			s5p_mixer_ctrl_private.layer[layer].height);
+
+		s5p_mixer_set_pixel_blend(layer, s5p_mixer_ctrl_private.layer[layer].pixel_blend);
+		break;
+
+	default:
+		tvout_err("invalid layer\n");
+		return -1;
+	}
+
+	s5p_mixer_set_layer_blend(layer, layer_blend);
+	s5p_mixer_set_alpha(layer, alpha);
+	s5p_mixer_set_priority(layer, priority);
+
+	return 0;
+}
+
+static void s5p_mixer_ctrl_clock(bool on)
+{
+	/* power control function is not implemented yet */
+	if (on) {
+		clk_enable(s5p_mixer_ctrl_private.clk[MUX].ptr);
+		clk_enable(s5p_mixer_ctrl_private.clk[ACLK].ptr);
+	} else {
+		clk_disable(s5p_mixer_ctrl_private.clk[ACLK].ptr);
+		clk_disable(s5p_mixer_ctrl_private.clk[MUX].ptr);
+	}
+}
+
+void s5p_mixer_ctrl_init_fb_addr_phy(enum s5p_mixer_layer layer,
+				     dma_addr_t fb_addr)
+{
+	s5p_mixer_ctrl_private.layer[layer].fb_addr = fb_addr;
+}
+
+void s5p_mixer_ctrl_init_grp_layer(enum s5p_mixer_layer layer)
+{
+	struct s5ptvfb_user_scaling scaling;
+
+	if (s5p_mixer_ctrl_private.running) {
+		s5p_mixer_set_priority(layer,
+			s5p_mixer_ctrl_private.layer[layer].priority);
+
+		s5p_mixer_set_pre_mul_mode(layer,
+			s5p_mixer_ctrl_private.layer[layer].pre_mul_mode);
+
+		s5p_mixer_set_chroma_key(layer,
+			s5p_mixer_ctrl_private.layer[layer].chroma_enable,
+			s5p_mixer_ctrl_private.layer[layer].chroma_key);
+
+		s5p_mixer_set_layer_blend(layer,
+			s5p_mixer_ctrl_private.layer[layer].layer_blend);
+
+		s5p_mixer_set_alpha(layer,
+			s5p_mixer_ctrl_private.layer[layer].alpha);
+
+		s5p_mixer_set_grp_layer_dst_pos(layer,
+			s5p_mixer_ctrl_private.layer[layer].dst_x,
+			s5p_mixer_ctrl_private.layer[layer].dst_y);
+
+		scaling.ver = s5p_mixer_ctrl_private.layer[layer].ver;
+		scaling.hor = s5p_mixer_ctrl_private.layer[layer].hor;
+
+		s5p_mixer_scaling(layer, scaling);
+
+		s5p_mixer_set_grp_base_address(layer,
+			s5p_mixer_ctrl_private.layer[layer].fb_addr);
+	}
+}
+
+int s5p_mixer_ctrl_set_pixel_format(enum s5p_mixer_layer layer,
+				    u32 bpp, u32 trans_len)
+{
+	enum s5p_mixer_color_fmt format;
+
+	switch (bpp) {
+	case 16:
+		if (trans_len == 1)
+			format = MIXER_RGB1555;
+		else if (trans_len == 4)
+			format = MIXER_RGB4444;
+		else
+			format = MIXER_RGB565;
+		break;
+
+	case 32:
+		format = MIXER_RGB8888;
+		break;
+
+	default:
+		tvout_err("invalid bits per pixel\n");
+		return -1;
+	}
+	s5p_mixer_ctrl_private.layer[layer].format = format;
+
+	if (s5p_mixer_ctrl_private.running)
+		s5p_mixer_set_color_format(layer, format);
+
+	return 0;
+}
+
+int s5p_mixer_ctrl_enable_layer(enum s5p_mixer_layer layer)
+{
+	switch (layer) {
+	case MIXER_VIDEO_LAYER:
+		s5p_mixer_ctrl_private.v_layer.use_video_layer = true;
+		break;
+
+	case MIXER_GPR0_LAYER:
+	case MIXER_GPR1_LAYER:
+		s5p_mixer_ctrl_private.layer[layer].use_grp_layer = true;
+		break;
+
+	default:
+		tvout_err("invalid layer\n");
+
+		return -1;
+	}
+
+	if (s5p_mixer_ctrl_private.running) {
+		s5p_mixer_ctrl_set_reg(layer);
+		s5p_mixer_set_show(layer, true);
+	}
+
+	return 0;
+}
+
+int s5p_mixer_ctrl_disable_layer(enum s5p_mixer_layer layer)
+{
+	bool use_vid, use_grp0, use_grp1;
+
+	switch (layer) {
+	case MIXER_VIDEO_LAYER:
+		s5p_mixer_ctrl_private.v_layer.use_video_layer = false;
+		break;
+
+	case MIXER_GPR0_LAYER:
+	case MIXER_GPR1_LAYER:
+		s5p_mixer_ctrl_private.layer[layer].use_grp_layer = false;
+		break;
+
+	default:
+		tvout_err("invalid layer\n");
+
+		return -1;
+	}
+
+	use_vid = s5p_mixer_ctrl_private.v_layer.use_video_layer;
+	use_grp0 = s5p_mixer_ctrl_private.layer[MIXER_GPR0_LAYER].use_grp_layer;
+	use_grp1 = s5p_mixer_ctrl_private.layer[MIXER_GPR1_LAYER].use_grp_layer;
+
+	if (s5p_mixer_ctrl_private.running)
+		s5p_mixer_set_show(layer, false);
+
+	return 0;
+}
+
+int s5p_mixer_ctrl_set_priority(enum s5p_mixer_layer layer, int prio)
+{
+	if ((prio < 0) || (prio > 15)) {
+		tvout_err("layer priority range : 0 - 15\n");
+		return -1;
+	}
+
+	switch (layer) {
+	case MIXER_VIDEO_LAYER:
+		s5p_mixer_ctrl_private.v_layer.priority = prio;
+		break;
+
+	case MIXER_GPR0_LAYER:
+	case MIXER_GPR1_LAYER:
+		s5p_mixer_ctrl_private.layer[layer].priority = prio;
+		break;
+
+	default:
+		tvout_err("invalid layer\n");
+
+		return -1;
+	}
+
+	if (s5p_mixer_ctrl_private.running)
+		s5p_mixer_set_priority(layer, (u32)prio);
+
+	return 0;
+}
+
+int s5p_mixer_ctrl_set_dst_win_pos(enum s5p_mixer_layer layer,
+				   int dst_x, int dst_y, u32 w, u32 h)
+{
+	u32 w_t, h_t;
+	enum s5p_tvout_disp_mode std;
+	enum s5p_tvout_o_mode inf;
+
+	if ((layer != MIXER_GPR0_LAYER) && (layer != MIXER_GPR1_LAYER)) {
+		tvout_err("invalid layer\n");
+		return -1;
+	}
+
+	s5p_tvif_ctrl_get_std_if(&std, &inf);
+	tvout_dbg("standard no = %d, output mode no = %d\n", std, inf);
+
+	/*
+	 * When tvout resolution was overscanned, there is no
+	 * adjust method in H/W. So, framebuffer should be resized.
+	 * In this case - TV w/h is greater than FB w/h, grp layer's
+	 * dst offset must be changed to fix tv screen.
+	 */
+
+	switch (std) {
+	case TVOUT_NTSC_M:
+	case TVOUT_480P_60_16_9:
+	case TVOUT_480P_60_4_3:
+	case TVOUT_480P_59:
+		w_t = 720;
+		h_t = 480;
+		break;
+
+	case TVOUT_576P_50_16_9:
+	case TVOUT_576P_50_4_3:
+		w_t = 720;
+		h_t = 576;
+		break;
+
+	case TVOUT_720P_60:
+	case TVOUT_720P_59:
+	case TVOUT_720P_50:
+		w_t = 1280;
+		h_t = 720;
+		break;
+
+	case TVOUT_1080I_60:
+	case TVOUT_1080I_59:
+	case TVOUT_1080I_50:
+	case TVOUT_1080P_60:
+	case TVOUT_1080P_59:
+	case TVOUT_1080P_50:
+	case TVOUT_1080P_30:
+		w_t = 1920;
+		h_t = 1080;
+		break;
+
+	default:
+		w_t = 0;
+		h_t = 0;
+		break;
+	}
+
+	if (dst_x < 0)
+		dst_x = 0;
+
+	if (dst_y < 0)
+		dst_y = 0;
+
+	if (dst_x + w > w_t)
+		dst_x = w_t - w;
+
+	if (dst_y + h > h_t)
+		dst_y = h_t - h;
+
+	tvout_dbg("destination coordinates : x = %d, y = %d\n", dst_x, dst_y);
+	tvout_dbg("output device screen size : width = %d, height = %d", w_t, h_t);
+
+	s5p_mixer_ctrl_private.layer[layer].dst_x = dst_x;
+	s5p_mixer_ctrl_private.layer[layer].dst_y = dst_y;
+
+	if (s5p_mixer_ctrl_private.running)
+		s5p_mixer_set_grp_layer_dst_pos(layer, dst_x, dst_y);
+
+	return 0;
+}
+
+int s5p_mixer_ctrl_set_src_win_pos(enum s5p_mixer_layer layer,
+				   u32 src_x, u32 src_y, u32 w, u32 h)
+{
+	if ((layer != MIXER_GPR0_LAYER) && (layer != MIXER_GPR1_LAYER)) {
+		tvout_err("invalid layer\n");
+		return -1;
+	}
+
+	tvout_dbg("source coordinates : x = %d, y = %d\n", src_x, src_y);
+	tvout_dbg("source size : width = %d, height = %d\n", w, h);
+
+	s5p_mixer_ctrl_private.layer[layer].src_x = src_x;
+	s5p_mixer_ctrl_private.layer[layer].src_y = src_y;
+	s5p_mixer_ctrl_private.layer[layer].width = w;
+	s5p_mixer_ctrl_private.layer[layer].height = h;
+
+	if (s5p_mixer_ctrl_private.running)
+		s5p_mixer_set_grp_layer_src_pos(layer, src_x, src_y, w, w, h);
+
+	return 0;
+}
+
+int s5p_mixer_ctrl_set_buffer_address(enum s5p_mixer_layer layer,
+				      dma_addr_t start_addr)
+{
+	if ((layer != MIXER_GPR0_LAYER) && (layer != MIXER_GPR1_LAYER)) {
+		tvout_err("invalid layer\n");
+		return -1;
+	}
+
+	tvout_dbg("TV frame buffer base address = 0x%x\n", start_addr);
+
+	s5p_mixer_ctrl_private.layer[layer].fb_addr = start_addr;
+
+	if (s5p_mixer_ctrl_private.running)
+		s5p_mixer_set_grp_base_address(layer, start_addr);
+
+	return 0;
+}
+
+int s5p_mixer_ctrl_set_chroma_key(enum s5p_mixer_layer layer,
+				  struct s5ptvfb_chroma chroma)
+{
+	bool enabled = (chroma.enabled) ? true : false;
+
+	if ((layer != MIXER_GPR0_LAYER) && (layer != MIXER_GPR1_LAYER)) {
+		tvout_err("invalid layer\n");
+		return -1;
+	}
+
+	s5p_mixer_ctrl_private.layer[layer].chroma_enable = enabled;
+	s5p_mixer_ctrl_private.layer[layer].chroma_key = chroma.key;
+
+	if (s5p_mixer_ctrl_private.running)
+		s5p_mixer_set_chroma_key(layer, enabled, chroma.key);
+
+	return 0;
+}
+
+int s5p_mixer_ctrl_set_alpha(enum s5p_mixer_layer layer, u32 alpha)
+{
+	switch (layer) {
+	case MIXER_VIDEO_LAYER:
+		s5p_mixer_ctrl_private.v_layer.alpha = alpha;
+		break;
+
+	case MIXER_GPR0_LAYER:
+	case MIXER_GPR1_LAYER:
+		s5p_mixer_ctrl_private.layer[layer].alpha = alpha;
+		break;
+
+	default:
+		tvout_err("invalid layer\n");
+
+		return -1;
+	}
+
+	tvout_dbg("alpha value = 0x%x\n", alpha);
+
+	if (s5p_mixer_ctrl_private.running)
+		s5p_mixer_set_alpha(layer, alpha);
+
+	return 0;
+}
+
+int s5p_mixer_ctrl_set_blend_mode(enum s5p_mixer_layer layer,
+				  enum s5ptvfb_alpha_t mode)
+{
+	if ((layer != MIXER_VIDEO_LAYER) && (layer != MIXER_GPR0_LAYER) &&
+		(layer != MIXER_GPR1_LAYER)) {
+		tvout_err("invalid layer\n");
+		return -1;
+	}
+
+	if ((layer == MIXER_VIDEO_LAYER) && (mode == PIXEL_BLENDING)) {
+		tvout_err("video layer doesn't support pixel blending\n");
+		return -1;
+	}
+
+	switch (mode) {
+	case PIXEL_BLENDING:
+		tvout_dbg("pixel blending\n");
+
+		s5p_mixer_ctrl_private.layer[layer].pixel_blend = true;
+
+		if (s5p_mixer_ctrl_private.running)
+			s5p_mixer_set_pixel_blend(layer, true);
+		break;
+
+	case LAYER_BLENDING:
+		tvout_dbg("layer blending\n");
+
+		if (layer == MIXER_VIDEO_LAYER)
+			s5p_mixer_ctrl_private.v_layer.layer_blend = true;
+		else /* graphic layer */
+			s5p_mixer_ctrl_private.layer[layer].layer_blend = true;
+
+		if (s5p_mixer_ctrl_private.running)
+			s5p_mixer_set_layer_blend(layer, true);
+		break;
+
+	case NONE_BLENDING:
+		tvout_dbg("alpha blending off\n");
+
+		if (layer == MIXER_VIDEO_LAYER) {
+			s5p_mixer_ctrl_private.v_layer.layer_blend = false;
+
+			if (s5p_mixer_ctrl_private.running)
+				s5p_mixer_set_layer_blend(layer, false);
+		} else { /* graphic layer */
+			s5p_mixer_ctrl_private.layer[layer].pixel_blend = false;
+			s5p_mixer_ctrl_private.layer[layer].layer_blend = false;
+
+			if (s5p_mixer_ctrl_private.running) {
+				s5p_mixer_set_layer_blend(layer, false);
+				s5p_mixer_set_pixel_blend(layer, false);
+			}
+		}
+		break;
+
+	default:
+		tvout_err("invalid blending mode\n");
+
+		return -1;
+	}
+
+	return 0;
+}
+
+int s5p_mixer_ctrl_set_alpha_blending(enum s5p_mixer_layer layer,
+				      enum s5ptvfb_alpha_t blend_mode,
+				      unsigned int alpha)
+{
+	if ((layer != MIXER_GPR0_LAYER) && (layer != MIXER_GPR1_LAYER)) {
+		tvout_err("invalid layer\n");
+		return -1;
+	}
+
+	switch (blend_mode) {
+	case PIXEL_BLENDING:
+		tvout_dbg("pixel blending\n");
+
+		s5p_mixer_ctrl_private.layer[layer].pixel_blend = true;
+
+		if (s5p_mixer_ctrl_private.running)
+			s5p_mixer_set_pixel_blend(layer, true);
+		break;
+
+	case LAYER_BLENDING:
+		tvout_dbg("layer blending : alpha value = 0x%x\n", alpha);
+
+		s5p_mixer_ctrl_private.layer[layer].layer_blend = true;
+		s5p_mixer_ctrl_private.layer[layer].alpha = alpha;
+
+		if (s5p_mixer_ctrl_private.running) {
+			s5p_mixer_set_layer_blend(layer, true);
+			s5p_mixer_set_alpha(layer, alpha);
+		}
+		break;
+
+	case NONE_BLENDING:
+		tvout_dbg("alpha blending off\n");
+		s5p_mixer_ctrl_private.layer[layer].pixel_blend = false;
+		s5p_mixer_ctrl_private.layer[layer].layer_blend = false;
+		if (s5p_mixer_ctrl_private.running) {
+			s5p_mixer_set_pixel_blend(layer, false);
+			s5p_mixer_set_layer_blend(layer, false);
+		}
+		break;
+
+	default:
+		tvout_err("invalid blending mode\n");
+
+		return -1;
+	}
+
+	return 0;
+}
+
+int s5p_mixer_ctrl_scaling(enum s5p_mixer_layer layer,
+			   struct s5ptvfb_user_scaling scaling)
+{
+	if ((layer != MIXER_GPR0_LAYER) && (layer != MIXER_GPR1_LAYER)) {
+		tvout_err("invalid layer\n");
+
+		return -1;
+	}
+
+	if ((scaling.ver != VERTICAL_X1) && (scaling.ver != VERTICAL_X2)) {
+		tvout_err("invalid vertical size\n");
+
+		return -1;
+	}
+
+	if ((scaling.hor != HORIZONTAL_X1) && (scaling.hor != HORIZONTAL_X2)) {
+		tvout_err("invalid horizontal size\n");
+
+		return -1;
+	}
+
+	s5p_mixer_ctrl_private.layer[layer].ver = scaling.ver;
+	s5p_mixer_ctrl_private.layer[layer].hor = scaling.hor;
+
+	if (s5p_mixer_ctrl_private.running)
+		s5p_mixer_scaling(layer, scaling);
+
+	return 0;
+}
+
+int s5p_mixer_ctrl_mux_clk(struct clk *ptr)
+{
+	if (clk_set_parent(s5p_mixer_ctrl_private.clk[MUX].ptr, ptr)) {
+		tvout_err("mixer clock mux failed\n");
+
+		return -1;
+	}
+	return 0;
+}
+
+void s5p_mixer_ctrl_set_int_enable(bool en)
+{
+	tvout_dbg("mixer layers' underflow interrupts are %s\n",
+				en ? "enabled" : "disabled");
+
+	if (s5p_mixer_ctrl_private.running) {
+		s5p_mixer_set_underflow_int_enable(MIXER_VIDEO_LAYER, en);
+		s5p_mixer_set_underflow_int_enable(MIXER_GPR0_LAYER, en);
+		s5p_mixer_set_underflow_int_enable(MIXER_GPR1_LAYER, en);
+	}
+}
+
+void s5p_mixer_ctrl_set_vsync_interrupt(bool en)
+{
+	if (s5p_mixer_ctrl_private.running)
+		s5p_mixer_set_vsync_interrupt(en);
+}
+
+void s5p_mixer_ctrl_clear_pend_all(void)
+{
+	if (s5p_mixer_ctrl_private.running)
+		s5p_mixer_clear_pend_all();
+}
+
+void s5p_mixer_ctrl_stop(void)
+{
+	if (s5p_mixer_ctrl_private.running) {
+		s5p_mixer_stop();
+
+		s5p_mixer_ctrl_clock(0);
+		s5p_mixer_ctrl_private.running = false;
+	}
+}
+
+void s5p_mixer_ctrl_internal_start(void)
+{
+	if (s5p_mixer_ctrl_private.running)
+		s5p_mixer_start();
+}
+
+int s5p_mixer_ctrl_start(enum s5p_tvout_disp_mode disp,
+			 enum s5p_tvout_o_mode out)
+{
+	int i;
+	enum s5p_mixer_burst_mode burst = s5p_mixer_ctrl_private.burst;
+	enum s5p_tvout_endian endian = s5p_mixer_ctrl_private.endian;
+	struct clk *sclk_mixer = s5p_mixer_ctrl_private.clk[MUX].ptr;
+
+	/*
+	 * Getting mega struct member variable will
+	 * be replaced another tvout interface
+	 */
+	struct s5p_tvout_status *st = &s5ptv_status;
+
+	switch (out) {
+	case TVOUT_COMPOSITE:
+		clk_set_parent(sclk_mixer, st->sclk_dac);
+
+		if (!s5p_mixer_ctrl_private.running) {
+			s5p_mixer_ctrl_clock(true);
+			s5p_mixer_ctrl_private.running = true;
+		}
+
+		s5p_mixer_init_csc_coef_default(MIXER_CSC_601_FR);
+		break;
+
+	case TVOUT_HDMI_RGB:
+	case TVOUT_HDMI:
+	case TVOUT_DVI:
+		clk_set_parent(sclk_mixer, st->sclk_hdmi);
+		clk_set_parent(st->sclk_hdmi, st->sclk_hdmiphy);
+
+		if (!s5p_mixer_ctrl_private.running) {
+			s5p_mixer_ctrl_clock(true);
+			s5p_mixer_ctrl_private.running = true;
+		}
+
+		switch (disp) {
+
+		case TVOUT_480P_60_16_9:
+		case TVOUT_480P_60_4_3:
+		case TVOUT_480P_59:
+		case TVOUT_576P_50_16_9:
+		case TVOUT_576P_50_4_3:
+			s5p_mixer_init_csc_coef_default(MIXER_CSC_601_FR);
+			break;
+
+		case TVOUT_720P_60:
+		case TVOUT_720P_50:
+		case TVOUT_720P_59:
+		case TVOUT_1080I_60:
+		case TVOUT_1080I_59:
+		case TVOUT_1080I_50:
+		case TVOUT_1080P_60:
+		case TVOUT_1080P_30:
+		case TVOUT_1080P_59:
+		case TVOUT_1080P_50:
+			s5p_mixer_init_csc_coef_default(MIXER_CSC_709_FR);
+			break;
+		default:
+			break;
+		}
+		break;
+
+	default:
+		tvout_err("invalid tvout output mode = %d\n", out);
+		return -1;
+	}
+
+	tvout_dbg("%s burst mode\n", burst ? "16" : "8");
+	tvout_dbg("%s endian\n", endian ? "big" : "little");
+
+	if ((burst != MIXER_BURST_8) && (burst != MIXER_BURST_16)) {
+		tvout_err("invalid burst mode\n");
+		return -1;
+	}
+
+	if ((endian != TVOUT_BIG_ENDIAN) && (endian != TVOUT_LITTLE_ENDIAN)) {
+		tvout_err("invalid endian\n");
+		return -1;
+	}
+
+	s5p_mixer_init_status_reg(burst, endian);
+
+	tvout_dbg("tvout standard = 0x%X, output mode = %d\n", disp, out);
+
+	/* error handling will be implemented */
+	s5p_mixer_init_display_mode(disp, out);
+
+	for (i = MIXER_BG_COLOR_0; i <= MIXER_BG_COLOR_2; i++) {
+		s5p_mixer_set_bg_color(i,
+			s5p_mixer_ctrl_private.bg_color[i].color_y,
+			s5p_mixer_ctrl_private.bg_color[i].color_cb,
+			s5p_mixer_ctrl_private.bg_color[i].color_cr);
+	}
+
+	if (s5p_mixer_ctrl_private.v_layer.use_video_layer) {
+		s5p_mixer_ctrl_set_reg(MIXER_VIDEO_LAYER);
+		s5p_mixer_set_show(MIXER_VIDEO_LAYER, true);
+	}
+	if (s5p_mixer_ctrl_private.layer[MIXER_GPR0_LAYER].use_grp_layer) {
+		s5p_mixer_ctrl_set_reg(MIXER_GPR0_LAYER);
+		s5p_mixer_set_show(MIXER_GPR0_LAYER, true);
+	}
+	if (s5p_mixer_ctrl_private.layer[MIXER_GPR0_LAYER].use_grp_layer) {
+		s5p_mixer_ctrl_set_reg(MIXER_GPR0_LAYER);
+		s5p_mixer_set_show(MIXER_GPR0_LAYER, true);
+	}
+
+	s5p_mixer_start();
+
+	return 0;
+}
+
+wait_queue_head_t s5ptv_wq;
+
+int s5p_mixer_ctrl_constructor(struct platform_device *pdev)
+{
+	int ret = 0, i;
+
+	ret = s5p_tvout_map_resource_mem(
+		pdev,
+		s5p_mixer_ctrl_private.reg_mem.name,
+		&(s5p_mixer_ctrl_private.reg_mem.base),
+		&(s5p_mixer_ctrl_private.reg_mem.res));
+
+	if (ret)
+		goto err_on_res;
+
+	for (i = ACLK; i < NO_OF_CLK; i++) {
+		s5p_mixer_ctrl_private.clk[i].ptr =
+			clk_get(&pdev->dev, s5p_mixer_ctrl_private.clk[i].name);
+
+		if (IS_ERR(s5p_mixer_ctrl_private.clk[i].ptr)) {
+			printk(KERN_ERR "Failed to find clock %s\n",
+				s5p_mixer_ctrl_private.clk[i].name);
+			ret = -ENOENT;
+			goto err_on_clk;
+		}
+	}
+
+	s5p_mixer_ctrl_private.irq.no =
+		platform_get_irq_byname(pdev, s5p_mixer_ctrl_private.irq.name);
+
+	if (s5p_mixer_ctrl_private.irq.no < 0) {
+		tvout_err("Failed to call platform_get_irq_byname() for %s\n",
+			s5p_mixer_ctrl_private.irq.name);
+		ret = s5p_mixer_ctrl_private.irq.no;
+		goto err_on_irq;
+	}
+
+	ret = request_irq(s5p_mixer_ctrl_private.irq.no,
+			s5p_mixer_ctrl_private.irq.handler, IRQF_DISABLED,
+			s5p_mixer_ctrl_private.irq.name, NULL);
+	if (ret) {
+		tvout_err("Failed to call request_irq() for %s\n",
+			s5p_mixer_ctrl_private.irq.name);
+		goto err_on_irq;
+	}
+
+	/* Initializing wait queue for mixer vsync interrupt */
+	init_waitqueue_head(&s5ptv_wq);
+
+	s5p_mixer_init(s5p_mixer_ctrl_private.reg_mem.base);
+
+	return 0;
+
+err_on_irq:
+err_on_clk:
+	iounmap(s5p_mixer_ctrl_private.reg_mem.base);
+	release_resource(s5p_mixer_ctrl_private.reg_mem.res);
+	kfree(s5p_mixer_ctrl_private.reg_mem.res);
+
+err_on_res:
+	return ret;
+}
+
+void s5p_mixer_ctrl_destructor(void)
+{
+	int i;
+	int irq_no = s5p_mixer_ctrl_private.irq.no;
+
+	if (irq_no >= 0)
+		free_irq(irq_no, NULL);
+
+	s5p_tvout_unmap_resource_mem(
+		s5p_mixer_ctrl_private.reg_mem.base,
+		s5p_mixer_ctrl_private.reg_mem.res);
+
+	for (i = ACLK; i < NO_OF_CLK; i++) {
+		if (s5p_mixer_ctrl_private.clk[i].ptr) {
+			clk_disable(s5p_mixer_ctrl_private.clk[i].ptr);
+			clk_put(s5p_mixer_ctrl_private.clk[i].ptr);
+		}
+	}
+}
+
+bool pm_running;
+
+void s5p_mixer_ctrl_suspend(void)
+{
+	pm_running = s5p_mixer_ctrl_private.running;
+
+	if (s5p_mixer_ctrl_private.running) {
+		s5p_mixer_stop();
+		s5p_mixer_ctrl_clock(0);
+		s5p_mixer_ctrl_private.running = false;
+	}
+}
+
+void s5p_mixer_ctrl_resume(void)
+{
+	if (pm_running) {
+		if (!s5p_mixer_ctrl_private.running) {
+			s5p_mixer_ctrl_clock(1);
+			s5p_mixer_ctrl_private.running = true;
+		}
+	}
+}
diff --git a/drivers/media/video/s5p-tvout/s5p_tvout_v4l2.c b/drivers/media/video/s5p-tvout/s5p_tvout_v4l2.c
new file mode 100644
index 0000000..67b39a0
--- /dev/null
+++ b/drivers/media/video/s5p-tvout/s5p_tvout_v4l2.c
@@ -0,0 +1,1081 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * V4L2 API for Samsung S5P TVOOUT driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/version.h>
+#include <linux/slab.h>
+#include <linux/videodev2_samsung.h>
+
+#include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
+
+#include "s5p_tvout_common_lib.h"
+#include "s5p_tvout_ctrl.h"
+#include "s5p_tvout_v4l2.h"
+
+#define MAJOR_VERSION		0
+#define MINOR_VERSION		9
+#define RELEASE_VERSION		0
+
+#define V4L2_STD_ALL_HD				((v4l2_std_id)0xffffffff)
+
+#define S5P_TVOUT_TVIF_MINOR			14
+#define S5P_TVOUT_VO_MINOR			21
+
+#define V4L2_OUTPUT_TYPE_COMPOSITE		5
+#define V4L2_OUTPUT_TYPE_HDMI			10
+#define V4L2_OUTPUT_TYPE_HDMI_RGB		11
+#define V4L2_OUTPUT_TYPE_DVI			12
+
+#define V4L2_STD_PAL_BDGHI	(V4L2_STD_PAL_B | V4L2_STD_PAL_D |	\
+				 V4L2_STD_PAL_G | V4L2_STD_PAL_H |	\
+				 V4L2_STD_PAL_I)
+
+#define V4L2_STD_480P_60_16_9	((v4l2_std_id)0x04000000)
+#define V4L2_STD_480P_60_4_3	((v4l2_std_id)0x05000000)
+#define V4L2_STD_576P_50_16_9	((v4l2_std_id)0x06000000)
+#define V4L2_STD_576P_50_4_3	((v4l2_std_id)0x07000000)
+#define V4L2_STD_720P_60	((v4l2_std_id)0x08000000)
+#define V4L2_STD_720P_50	((v4l2_std_id)0x09000000)
+#define V4L2_STD_1080P_60	((v4l2_std_id)0x0a000000)
+#define V4L2_STD_1080P_50	((v4l2_std_id)0x0b000000)
+#define V4L2_STD_1080I_60	((v4l2_std_id)0x0c000000)
+#define V4L2_STD_1080I_50	((v4l2_std_id)0x0d000000)
+#define V4L2_STD_480P_59	((v4l2_std_id)0x0e000000)
+#define V4L2_STD_720P_59	((v4l2_std_id)0x0f000000)
+#define V4L2_STD_1080I_59	((v4l2_std_id)0x10000000)
+#define V4L2_STD_1080P_59	((v4l2_std_id)0x11000000)
+#define V4L2_STD_1080P_30	((v4l2_std_id)0x12000000)
+
+#define CVBS_S_VIDEO (V4L2_STD_NTSC_M | V4L2_STD_NTSC_M_JP|		\
+		      V4L2_STD_PAL | V4L2_STD_PAL_M |			\
+		      V4L2_STD_PAL_N | V4L2_STD_PAL_Nc |		\
+		      V4L2_STD_PAL_60 | V4L2_STD_NTSC_443)
+
+struct v4l2_vid_overlay_src {
+	void			*base_y;
+	void			*base_c;
+	struct v4l2_pix_format	pix_fmt;
+};
+
+static const struct v4l2_output s5p_tvout_tvif_output[] = {
+	{
+		.index		= 0,
+		.name		= "Analog COMPOSITE",
+		.type		= V4L2_OUTPUT_TYPE_COMPOSITE,
+		.audioset	= 0,
+		.modulator	= 0,
+		.std		= CVBS_S_VIDEO,
+	}, {
+		.index		= 1,
+		.name		= "Digital HDMI(YCbCr)",
+		.type		= V4L2_OUTPUT_TYPE_HDMI,
+		.audioset	= 2,
+		.modulator	= 0,
+		.std		= V4L2_STD_480P_60_16_9 |
+				  V4L2_STD_480P_60_16_9 |
+				  V4L2_STD_720P_60 |
+				  V4L2_STD_720P_50 |
+				  V4L2_STD_1080P_60 |
+				  V4L2_STD_1080P_50 |
+				  V4L2_STD_1080I_60 |
+				  V4L2_STD_1080I_50 |
+				  V4L2_STD_480P_59 |
+				  V4L2_STD_720P_59 |
+				  V4L2_STD_1080I_59 |
+				  V4L2_STD_1080P_59 |
+				  V4L2_STD_1080P_30,
+	}, {
+		.index		= 2,
+		.name		= "Digital HDMI(RGB)",
+		.type		= V4L2_OUTPUT_TYPE_HDMI_RGB,
+		.audioset	= 2,
+		.modulator	= 0,
+		.std		= V4L2_STD_480P_60_16_9 |
+				  V4L2_STD_480P_60_16_9 |
+				  V4L2_STD_720P_60 |
+				  V4L2_STD_720P_50 |
+				  V4L2_STD_1080P_60 |
+				  V4L2_STD_1080P_50 |
+				  V4L2_STD_1080I_60 |
+				  V4L2_STD_1080I_50 |
+				  V4L2_STD_480P_59 |
+				  V4L2_STD_720P_59 |
+				  V4L2_STD_1080I_59 |
+				  V4L2_STD_1080P_59 |
+				  V4L2_STD_1080P_30,
+	}, {
+		.index		= 3,
+		.name		= "Digital DVI",
+		.type		= V4L2_OUTPUT_TYPE_DVI,
+		.audioset	= 2,
+		.modulator	= 0,
+		.std		= V4L2_STD_480P_60_16_9 |
+				  V4L2_STD_480P_60_16_9 |
+				  V4L2_STD_720P_60 |
+				  V4L2_STD_720P_50 |
+				  V4L2_STD_1080P_60 |
+				  V4L2_STD_1080P_50 |
+				  V4L2_STD_1080I_60 |
+				  V4L2_STD_1080I_50 |
+				  V4L2_STD_480P_59 |
+				  V4L2_STD_720P_59 |
+				  V4L2_STD_1080I_59 |
+				  V4L2_STD_1080P_59 |
+				  V4L2_STD_1080P_30,
+	}
+
+};
+
+#define S5P_TVOUT_TVIF_NO_OF_OUTPUT ARRAY_SIZE(s5p_tvout_tvif_output)
+
+static const struct v4l2_standard s5p_tvout_tvif_standard[] = {
+	{
+		.index	= 0,
+		.id	= V4L2_STD_NTSC_M,
+		.name	= "NTSC_M",
+	}, {
+		.index	= 1,
+		.id	= V4L2_STD_PAL_BDGHI,
+		.name	= "PAL_BDGHI",
+	}, {
+		.index	= 2,
+		.id	= V4L2_STD_PAL_M,
+		.name	= "PAL_M",
+	}, {
+		.index	= 3,
+		.id	= V4L2_STD_PAL_N,
+		.name	= "PAL_N",
+	}, {
+		.index	= 4,
+		.id	= V4L2_STD_PAL_Nc,
+		.name	= "PAL_Nc",
+	}, {
+		.index	= 5,
+		.id	= V4L2_STD_PAL_60,
+		.name	= "PAL_60",
+	}, {
+		.index	= 6,
+		.id	= V4L2_STD_NTSC_443,
+		.name	= "NTSC_443",
+	}, {
+		.index	= 7,
+		.id	= V4L2_STD_480P_60_16_9,
+		.name	= "480P_60_16_9",
+	}, {
+		.index	= 8,
+		.id	= V4L2_STD_480P_60_4_3,
+		.name	= "480P_60_4_3",
+	}, {
+		.index	= 9,
+		.id	= V4L2_STD_576P_50_16_9,
+		.name	= "576P_50_16_9",
+	}, {
+		.index	= 10,
+		.id	= V4L2_STD_576P_50_4_3,
+		.name	= "576P_50_4_3",
+	}, {
+		.index	= 11,
+		.id	= V4L2_STD_720P_60,
+		.name	= "720P_60",
+	}, {
+		.index	= 12,
+		.id	= V4L2_STD_720P_50,
+		.name	= "720P_50",
+	}, {
+		.index	= 13,
+		.id	= V4L2_STD_1080P_60,
+		.name	= "1080P_60",
+	}, {
+		.index	= 14,
+		.id	= V4L2_STD_1080P_50,
+		.name	= "1080P_50",
+	}, {
+		.index	= 15,
+		.id	= V4L2_STD_1080I_60,
+		.name	= "1080I_60",
+	}, {
+		.index	= 16,
+		.id	= V4L2_STD_1080I_50,
+		.name	= "1080I_50",
+	}, {
+		.index	= 17,
+		.id	= V4L2_STD_480P_59,
+		.name	= "480P_59",
+	}, {
+		.index	= 18,
+		.id	= V4L2_STD_720P_59,
+		.name	= "720P_59",
+	}, {
+		.index	= 19,
+		.id	= V4L2_STD_1080I_59,
+		.name	= "1080I_59",
+	}, {
+		.index	= 20,
+		.id	= V4L2_STD_1080P_59,
+		.name	= "1080I_50",
+	}, {
+		.index	= 21,
+		.id	= V4L2_STD_1080P_30,
+		.name	= "1080I_30",
+	}
+};
+
+#define S5P_TVOUT_TVIF_NO_OF_STANDARD ARRAY_SIZE(s5p_tvout_tvif_standard)
+
+static const struct v4l2_fmtdesc s5p_tvout_vo_fmt_desc[] = {
+	{
+		.index		= 0,
+		.type		= V4L2_BUF_TYPE_PRIVATE,
+		.pixelformat	= V4L2_PIX_FMT_NV12,
+		.description	= "NV12 (Linear YUV420 2 Planes)",
+	}, {
+		.index		= 1,
+		.type		= V4L2_BUF_TYPE_PRIVATE,
+		.pixelformat	= V4L2_PIX_FMT_NV12T,
+		.description	= "NV12T (Tiled YUV420 2 Planes)",
+	}, {
+		.index		= 2,
+		.type		= V4L2_BUF_TYPE_PRIVATE,
+		.pixelformat	= V4L2_PIX_FMT_NV21,
+		.description	= "NV12 (Linear YUV420 2 Planes)",
+	}, {
+		.index		= 3,
+		.type		= V4L2_BUF_TYPE_PRIVATE,
+		.pixelformat	= V4L2_PIX_FMT_NV21T,
+		.description	= "NV12T (Tiled YUV420 2 Planes)",
+	},
+};
+
+static DEFINE_MUTEX(s5p_tvout_tvif_mutex);
+static DEFINE_MUTEX(s5p_tvout_vo_mutex);
+
+struct s5p_tvout_v4l2_private_data {
+	struct v4l2_vid_overlay_src	vo_src_fmt;
+	struct v4l2_rect		vo_src_rect;
+	struct v4l2_window		vo_dst_fmt;
+	struct v4l2_framebuffer		vo_dst_plane;
+
+	int				tvif_output_index;
+	v4l2_std_id			tvif_standard_id;
+
+	atomic_t			tvif_use;
+	atomic_t			vo_use;
+};
+
+static struct s5p_tvout_v4l2_private_data s5p_tvout_v4l2_private = {
+	.tvif_output_index	= -1,
+	.tvif_standard_id	= 0,
+
+	.tvif_use		= ATOMIC_INIT(0),
+	.vo_use			= ATOMIC_INIT(0),
+};
+
+static void s5p_tvout_v4l2_init_private(void)
+{
+}
+
+static int s5p_tvout_tvif_querycap(struct file *file, void *fh,
+				   struct v4l2_capability *cap)
+{
+	strcpy(cap->driver, "s5p-tvout-tvif");
+	strcpy(cap->card, "Samsung TVOUT TV Interface");
+	cap->capabilities = V4L2_CAP_VIDEO_OUTPUT;
+	cap->version = KERNEL_VERSION(MAJOR_VERSION, MINOR_VERSION, RELEASE_VERSION);
+
+	return 0;
+}
+
+static int s5p_tvout_tvif_g_std(struct file *file, void *fh,
+				v4l2_std_id *norm)
+{
+	if (s5p_tvout_v4l2_private.tvif_standard_id == 0) {
+		tvout_err("Standard has not set\n");
+		return -1;
+	}
+
+	*norm = s5p_tvout_v4l2_private.tvif_standard_id;
+
+	return 0;
+}
+
+static int s5p_tvout_tvif_s_std(struct file *file, void *fh,
+				v4l2_std_id *norm)
+{
+	int i;
+	v4l2_std_id std_id = *norm;
+
+	for (i = 0; i < S5P_TVOUT_TVIF_NO_OF_STANDARD; i++) {
+		if (s5p_tvout_tvif_standard[i].id == std_id)
+			break;
+	}
+
+	if (i == S5P_TVOUT_TVIF_NO_OF_STANDARD) {
+		tvout_err("There is no TV standard(0x%08Lx)\n", std_id);
+
+		return -EINVAL;
+	}
+
+	s5p_tvout_v4l2_private.tvif_standard_id = std_id;
+
+	tvout_dbg("standard id=0x%X, name=\"%s\"\n", (u32) std_id, s5p_tvout_tvif_standard[i].name);
+
+	return 0;
+}
+
+static int s5p_tvout_tvif_enum_output(struct file *file, void *fh,
+				      struct v4l2_output *a)
+{
+	unsigned int index = a->index;
+
+	if (index >= S5P_TVOUT_TVIF_NO_OF_OUTPUT) {
+		tvout_err("Invalid index(%d)\n", index);
+
+		return -EINVAL;
+	}
+
+	memcpy(a, &s5p_tvout_tvif_output[index], sizeof(struct v4l2_output));
+
+	return 0;
+}
+
+static int s5p_tvout_tvif_g_output(struct file *file, void *fh, unsigned int *i)
+{
+	if (s5p_tvout_v4l2_private.tvif_output_index == -1) {
+		tvout_err("Output has not set\n");
+		return -EINVAL;
+	}
+
+	*i = s5p_tvout_v4l2_private.tvif_output_index;
+
+	return 0;
+}
+
+static int s5p_tvout_tvif_s_output(struct file *file, void *fh, unsigned int i)
+{
+	enum s5p_tvout_disp_mode	tv_std;
+	enum s5p_tvout_o_mode		tv_if;
+
+	if (i >= S5P_TVOUT_TVIF_NO_OF_OUTPUT) {
+		tvout_err("Invalid index(%d)\n", i);
+		return -EINVAL;
+	}
+
+	s5p_tvout_v4l2_private.tvif_output_index = i;
+
+	tvout_dbg("output id=%d, name=\"%s\"\n", (int) i, s5p_tvout_tvif_output[i].name);
+
+	switch (s5p_tvout_tvif_output[i].type) {
+	case V4L2_OUTPUT_TYPE_COMPOSITE:
+		tv_if =	TVOUT_COMPOSITE;
+		break;
+
+	case V4L2_OUTPUT_TYPE_HDMI:
+		tv_if =	TVOUT_HDMI;
+		break;
+
+	case V4L2_OUTPUT_TYPE_HDMI_RGB:
+		tv_if =	TVOUT_HDMI_RGB;
+		break;
+
+	case V4L2_OUTPUT_TYPE_DVI:
+		tv_if =	TVOUT_DVI;
+		break;
+
+	default:
+		tvout_err("Invalid output type(%d)\n", s5p_tvout_tvif_output[i].type);
+
+		return -1;
+	}
+
+	switch (s5p_tvout_v4l2_private.tvif_standard_id) {
+	case V4L2_STD_NTSC_M:
+		tv_std = TVOUT_NTSC_M;
+		break;
+
+	case V4L2_STD_PAL_BDGHI:
+		tv_std = TVOUT_PAL_BDGHI;
+		break;
+
+	case V4L2_STD_PAL_M:
+		tv_std = TVOUT_PAL_M;
+		break;
+
+	case V4L2_STD_PAL_N:
+		tv_std = TVOUT_PAL_N;
+		break;
+
+	case V4L2_STD_PAL_Nc:
+		tv_std = TVOUT_PAL_NC;
+		break;
+
+	case V4L2_STD_PAL_60:
+		tv_std = TVOUT_PAL_60;
+		break;
+
+	case V4L2_STD_NTSC_443:
+		tv_std = TVOUT_NTSC_443;
+		break;
+
+	case V4L2_STD_480P_60_16_9:
+		tv_std = TVOUT_480P_60_16_9;
+		break;
+
+	case V4L2_STD_480P_60_4_3:
+		tv_std = TVOUT_480P_60_4_3;
+		break;
+
+	case V4L2_STD_480P_59:
+		tv_std = TVOUT_480P_59;
+		break;
+	case V4L2_STD_576P_50_16_9:
+		tv_std = TVOUT_576P_50_16_9;
+		break;
+
+	case V4L2_STD_576P_50_4_3:
+		tv_std = TVOUT_576P_50_4_3;
+		break;
+
+	case V4L2_STD_720P_60:
+		tv_std = TVOUT_720P_60;
+		break;
+
+	case V4L2_STD_720P_59:
+		tv_std = TVOUT_720P_59;
+		break;
+
+	case V4L2_STD_720P_50:
+		tv_std = TVOUT_720P_50;
+		break;
+
+	case V4L2_STD_1080I_60:
+		tv_std = TVOUT_1080I_60;
+		break;
+
+	case V4L2_STD_1080I_59:
+		tv_std = TVOUT_1080I_59;
+		break;
+
+	case V4L2_STD_1080I_50:
+		tv_std = TVOUT_1080I_50;
+		break;
+
+	case V4L2_STD_1080P_30:
+		tv_std = TVOUT_1080P_30;
+		break;
+
+	case V4L2_STD_1080P_60:
+		tv_std = TVOUT_1080P_60;
+		break;
+
+	case V4L2_STD_1080P_59:
+		tv_std = TVOUT_1080P_59;
+		break;
+
+	case V4L2_STD_1080P_50:
+		tv_std = TVOUT_1080P_50;
+		break;
+
+	default:
+		tvout_err("Invalid standard id(0x%08Lx)\n",
+			s5p_tvout_v4l2_private.tvif_standard_id);
+
+		return -1;
+	}
+
+	s5p_tvif_ctrl_start(tv_std, tv_if);
+
+	return 0;
+};
+
+static int s5p_tvout_tvif_cropcap(struct file *file, void *fh,
+				  struct v4l2_cropcap *a)
+{
+	enum s5p_tvout_disp_mode std;
+	enum s5p_tvout_o_mode inf;
+
+	struct v4l2_cropcap *cropcap = a;
+
+	if (cropcap->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		tvout_err("Invalid buf type(%d)\n", cropcap->type);
+		return -EINVAL;
+	}
+
+	/* below part will be modified and moved to tvif ctrl class */
+	s5p_tvif_ctrl_get_std_if(&std, &inf);
+
+	switch (std) {
+	case TVOUT_NTSC_M:
+	case TVOUT_NTSC_443:
+	case TVOUT_480P_60_16_9:
+	case TVOUT_480P_60_4_3:
+	case TVOUT_480P_59:
+		cropcap->bounds.top = 0;
+		cropcap->bounds.left = 0;
+		cropcap->bounds.width = 720;
+		cropcap->bounds.height = 480;
+
+		cropcap->defrect.top = 0;
+		cropcap->defrect.left = 0;
+		cropcap->defrect.width = 720;
+		cropcap->defrect.height = 480;
+		break;
+
+	case TVOUT_PAL_M:
+	case TVOUT_PAL_BDGHI:
+	case TVOUT_PAL_N:
+	case TVOUT_PAL_NC:
+	case TVOUT_PAL_60:
+	case TVOUT_576P_50_16_9:
+	case TVOUT_576P_50_4_3:
+		cropcap->bounds.top = 0;
+		cropcap->bounds.left = 0;
+		cropcap->bounds.width = 720;
+		cropcap->bounds.height = 576;
+
+		cropcap->defrect.top = 0;
+		cropcap->defrect.left = 0;
+		cropcap->defrect.width = 720;
+		cropcap->defrect.height = 576;
+		break;
+
+	case TVOUT_720P_60:
+	case TVOUT_720P_59:
+	case TVOUT_720P_50:
+		cropcap->bounds.top = 0;
+		cropcap->bounds.left = 0;
+		cropcap->bounds.width = 1280;
+		cropcap->bounds.height = 720;
+
+		cropcap->defrect.top = 0;
+		cropcap->defrect.left = 0;
+		cropcap->defrect.width = 1280;
+		cropcap->defrect.height = 720;
+		break;
+
+	case TVOUT_1080I_60:
+	case TVOUT_1080I_59:
+	case TVOUT_1080I_50:
+	case TVOUT_1080P_60:
+	case TVOUT_1080P_59:
+	case TVOUT_1080P_50:
+	case TVOUT_1080P_30:
+		cropcap->bounds.top = 0;
+		cropcap->bounds.left = 0;
+		cropcap->bounds.width = 1920;
+		cropcap->bounds.height = 1080;
+
+		cropcap->defrect.top = 0;
+		cropcap->defrect.left = 0;
+		cropcap->defrect.width = 1920;
+		cropcap->defrect.height = 1080;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int s5p_tvout_tvif_wait_for_vsync(void)
+{
+	sleep_on_timeout(&s5ptv_wq, HZ / 10);
+
+	return 0;
+}
+
+const struct v4l2_ioctl_ops s5p_tvout_tvif_ioctl_ops = {
+	.vidioc_querycap	= s5p_tvout_tvif_querycap,
+	.vidioc_g_std		= s5p_tvout_tvif_g_std,
+	.vidioc_s_std		= s5p_tvout_tvif_s_std,
+	.vidioc_enum_output	= s5p_tvout_tvif_enum_output,
+	.vidioc_g_output	= s5p_tvout_tvif_g_output,
+	.vidioc_s_output	= s5p_tvout_tvif_s_output,
+	.vidioc_cropcap		= s5p_tvout_tvif_cropcap,
+};
+
+#define VIDIOC_HDCP_ENABLE	_IOWR('V', 100, unsigned int)
+#define VIDIOC_HDCP_STATUS	_IOR('V', 101, unsigned int)
+#define VIDIOC_HDCP_PROT_STATUS	_IOR('V', 102, unsigned int)
+#define VIDIOC_INIT_AUDIO	_IOR('V', 103, unsigned int)
+#define VIDIOC_AV_MUTE		_IOR('V', 104, unsigned int)
+#define VIDIOC_G_AVMUTE		_IOR('V', 105, unsigned int)
+#define VIDIOC_SET_VSYNC_INT	_IOR('V', 106, unsigned int)
+#define VIDIOC_WAITFORVSYNC	_IOR('V', 107, unsigned int)
+
+long s5p_tvout_tvif_ioctl(struct file *file, unsigned int cmd,
+			  unsigned long arg)
+{
+	void *argp = (void *) arg;
+
+	switch (cmd) {
+	case VIDIOC_INIT_AUDIO:
+		tvout_dbg("VIDIOC_INIT_AUDIO(%d)\n", (int) arg);
+
+		if (arg)
+			s5p_tvif_ctrl_set_audio(true);
+		else
+			s5p_tvif_ctrl_set_audio(false);
+
+		return 0;
+
+	case VIDIOC_AV_MUTE:
+		tvout_dbg("VIDIOC_AV_MUTE(%d)\n", (int) arg);
+
+		if (arg)
+			s5p_tvif_ctrl_set_av_mute(true);
+		else
+			s5p_tvif_ctrl_set_av_mute(false);
+
+		return 0;
+
+	case VIDIOC_G_AVMUTE:
+		return s5p_hdmi_ctrl_get_mute();
+
+	case VIDIOC_HDCP_ENABLE:
+		tvout_dbg("VIDIOC_HDCP_ENABLE(%d)\n", (int) arg);
+
+		s5p_hdmi_ctrl_set_hdcp((bool) arg);
+		return 0;
+
+	case VIDIOC_HDCP_STATUS: {
+		unsigned int *status = (unsigned int *)&arg;
+
+		*status = 1;
+
+		return 0;
+	}
+
+	case VIDIOC_HDCP_PROT_STATUS: {
+		unsigned int *prot = (unsigned int *)&arg;
+
+		*prot = 1;
+
+		return 0;
+	}
+
+	case VIDIOC_ENUMSTD: {
+		struct v4l2_standard *p = (struct v4l2_standard *)arg;
+
+		if (p->index >= S5P_TVOUT_TVIF_NO_OF_STANDARD) {
+			tvout_dbg("VIDIOC_ENUMSTD: Invalid index(%d)\n",
+					p->index);
+
+			return -EINVAL;
+		}
+
+		memcpy(p, &s5p_tvout_tvif_standard[p->index],
+			sizeof(struct v4l2_standard));
+
+		return 0;
+	}
+
+	case VIDIOC_SET_VSYNC_INT:
+		s5p_mixer_ctrl_set_vsync_interrupt((int)argp);
+		break;
+
+	case VIDIOC_WAITFORVSYNC:
+		s5p_tvout_tvif_wait_for_vsync();
+		break;
+
+	default:
+		break;
+	}
+
+	return video_ioctl2(file, cmd, arg);
+}
+
+
+static int s5p_tvout_tvif_open(struct file *file)
+{
+	mutex_lock(&s5p_tvout_tvif_mutex);
+
+	atomic_inc(&s5p_tvout_v4l2_private.tvif_use);
+
+	mutex_unlock(&s5p_tvout_tvif_mutex);
+
+	tvout_dbg("count=%d\n", atomic_read(&s5p_tvout_v4l2_private.tvif_use));
+
+	return 0;
+}
+
+static int s5p_tvout_tvif_release(struct file *file)
+{
+	tvout_dbg("count=%d\n", atomic_read(&s5p_tvout_v4l2_private.tvif_use));
+
+	mutex_lock(&s5p_tvout_tvif_mutex);
+
+	atomic_dec(&s5p_tvout_v4l2_private.tvif_use);
+
+	if (atomic_read(&s5p_tvout_v4l2_private.tvif_use) == 0)
+		s5p_tvif_ctrl_stop();
+
+	mutex_unlock(&s5p_tvout_tvif_mutex);
+
+	return 0;
+}
+
+static struct v4l2_file_operations s5p_tvout_tvif_fops = {
+	.owner		= THIS_MODULE,
+	.open		= s5p_tvout_tvif_open,
+	.release	= s5p_tvout_tvif_release,
+	.ioctl		= s5p_tvout_tvif_ioctl
+};
+
+static int s5p_tvout_vo_querycap(struct file *file, void *fh,
+				 struct v4l2_capability *cap)
+{
+	strcpy(cap->driver, "s5p-tvout-vo");
+	strcpy(cap->card, "Samsung TVOUT Video Overlay");
+	cap->capabilities = V4L2_CAP_VIDEO_OVERLAY;
+	cap->version = KERNEL_VERSION(MAJOR_VERSION, MINOR_VERSION, RELEASE_VERSION);
+
+	return 0;
+}
+
+static int s5p_tvout_vo_enum_fmt_type_private(struct file *file, void *fh,
+					      struct v4l2_fmtdesc *f)
+{
+	int index = f->index;
+
+	if (index >= ARRAY_SIZE(s5p_tvout_vo_fmt_desc)) {
+		tvout_err("Invalid index(%d)\n", index);
+
+		return -EINVAL;
+	}
+
+	memcpy(f, &s5p_tvout_vo_fmt_desc[index], sizeof(struct v4l2_fmtdesc));
+
+	return 0;
+}
+
+static int s5p_tvout_vo_g_fmt_type_private(struct file *file, void *fh,
+					   struct v4l2_format *a)
+{
+	memcpy(a->fmt.raw_data,	&s5p_tvout_v4l2_private.vo_src_fmt,
+		sizeof(struct v4l2_vid_overlay_src));
+
+	return 0;
+}
+
+static int s5p_tvout_vo_s_fmt_type_private(struct file *file, void *fh,
+					   struct v4l2_format *a)
+{
+	struct v4l2_vid_overlay_src	vparam;
+	struct v4l2_pix_format		*pix_fmt;
+	enum s5p_vp_src_color		color;
+	enum s5p_vp_field		field;
+
+	memcpy(&vparam, a->fmt.raw_data, sizeof(struct v4l2_vid_overlay_src));
+
+	pix_fmt = &vparam.pix_fmt;
+
+	tvout_dbg("base_y=0x%X, base_c=0x%X, field=%d\n",
+			(u32) vparam.base_y, (u32) vparam.base_c,
+			pix_fmt->field);
+
+	/* check progressive or not */
+	if (pix_fmt->field == V4L2_FIELD_NONE) {
+		/* progressive */
+		switch (pix_fmt->pixelformat) {
+		case V4L2_PIX_FMT_NV12:
+			/* linear */
+			tvout_dbg("pixelformat=V4L2_PIX_FMT_NV12\n");
+
+			color = VP_SRC_COLOR_NV12;
+			break;
+
+		case V4L2_PIX_FMT_NV12T:
+			/* tiled */
+			tvout_dbg("pixelformat=V4L2_PIX_FMT_NV12T\n");
+			color = VP_SRC_COLOR_TILE_NV12;
+			break;
+
+		case V4L2_PIX_FMT_NV21:
+			/* linear */
+			color = VP_SRC_COLOR_NV21;
+			break;
+
+		case V4L2_PIX_FMT_NV21T:
+			/* tiled */
+			color = VP_SRC_COLOR_TILE_NV21;
+			break;
+
+		default:
+			tvout_err("src img format not supported\n");
+			goto error_on_s_fmt_type_private;
+		}
+		field = VP_TOP_FIELD;
+
+	} else if ((pix_fmt->field == V4L2_FIELD_TOP) ||
+			(pix_fmt->field == V4L2_FIELD_BOTTOM)) {
+		/* interlaced */
+		switch (pix_fmt->pixelformat) {
+		case V4L2_PIX_FMT_NV12:
+			/* linear */
+			tvout_dbg("pixelformat=V4L2_PIX_FMT_NV12\n");
+			color = VP_SRC_COLOR_NV12IW;
+			break;
+
+		case V4L2_PIX_FMT_NV12T:
+			/* tiled */
+			tvout_dbg("pixelformat=V4L2_PIX_FMT_NV12T\n");
+			color = VP_SRC_COLOR_TILE_NV12IW;
+			break;
+
+		case V4L2_PIX_FMT_NV21:
+			/* linear */
+			color = VP_SRC_COLOR_NV21IW;
+			break;
+
+		case V4L2_PIX_FMT_NV21T:
+			/* tiled */
+			color = VP_SRC_COLOR_TILE_NV21IW;
+			break;
+
+		default:
+			tvout_err("src img format not supported\n");
+			goto error_on_s_fmt_type_private;
+		}
+		field = (pix_fmt->field == V4L2_FIELD_BOTTOM) ?
+				VP_BOTTOM_FIELD : VP_TOP_FIELD;
+
+	} else {
+		tvout_err("this field id not supported\n");
+
+		goto error_on_s_fmt_type_private;
+	}
+
+	s5p_tvout_v4l2_private.vo_src_fmt = vparam;
+
+	s5p_vp_ctrl_set_src_plane((u32) vparam.base_y, (u32) vparam.base_c,
+				pix_fmt->width, pix_fmt->height, color, field);
+	return 0;
+
+error_on_s_fmt_type_private:
+	return -1;
+}
+
+static int s5p_tvout_vo_g_fmt_vid_overlay(struct file *file, void *fh,
+					  struct v4l2_format *a)
+{
+	a->fmt.win = s5p_tvout_v4l2_private.vo_dst_fmt;
+
+	return 0;
+}
+
+static int s5p_tvout_vo_s_fmt_vid_overlay(struct file *file, void *fh,
+					  struct v4l2_format *a)
+{
+	struct v4l2_rect *rect = &a->fmt.win.w;
+
+	tvout_dbg("l=%d, t=%d, w=%d, h=%d, g_alpha_value=%d\n",
+			rect->left, rect->top, rect->width, rect->height,
+			a->fmt.win.global_alpha);
+
+	s5p_tvout_v4l2_private.vo_dst_fmt = a->fmt.win;
+
+	s5p_vp_ctrl_set_dest_win_alpha_val(a->fmt.win.global_alpha);
+	s5p_vp_ctrl_set_dest_win(rect->left, rect->top, rect->width, rect->height);
+
+	return 0;
+}
+
+static int s5p_tvout_vo_g_crop(struct file *file, void *fh, struct v4l2_crop *a)
+{
+	switch (a->type) {
+	case V4L2_BUF_TYPE_PRIVATE:
+		a->c = s5p_tvout_v4l2_private.vo_src_rect;
+		break;
+
+	default:
+		tvout_err("Invalid buf type(0x%08x)\n", a->type);
+		break;
+	}
+
+	return 0;
+}
+
+static int s5p_tvout_vo_s_crop(struct file *file, void *fh, struct v4l2_crop *a)
+{
+	switch (a->type) {
+	case V4L2_BUF_TYPE_PRIVATE: {
+		struct v4l2_rect *rect = &s5p_tvout_v4l2_private.vo_src_rect;
+
+		*rect = a->c;
+
+		tvout_dbg("l=%d, t=%d, w=%d, h=%d\n",
+			rect->left, rect->top, rect->width, rect->height);
+
+		s5p_vp_ctrl_set_src_win(rect->left, rect->top,
+					rect->width, rect->height);
+		break;
+
+	}
+	default:
+		tvout_err("Invalid buf type(0x%08x)\n", a->type);
+		break;
+	}
+
+	return 0;
+}
+
+static int s5p_tvout_vo_g_fbuf(struct file *file, void *fh,
+			       struct v4l2_framebuffer *a)
+{
+	*a = s5p_tvout_v4l2_private.vo_dst_plane;
+
+	a->capability = V4L2_FBUF_CAP_GLOBAL_ALPHA;
+
+	return 0;
+}
+
+static int s5p_tvout_vo_s_fbuf(struct file *file, void *fh,
+			       struct v4l2_framebuffer *a)
+{
+	s5p_tvout_v4l2_private.vo_dst_plane = *a;
+
+	tvout_dbg("g_alpha_enable=%d, priority=%d\n",
+		(a->flags & V4L2_FBUF_FLAG_GLOBAL_ALPHA) ? 1 : 0, a->fmt.priv);
+
+	s5p_vp_ctrl_set_dest_win_blend(
+		(a->flags & V4L2_FBUF_FLAG_GLOBAL_ALPHA) ? 1 : 0);
+
+	s5p_vp_ctrl_set_dest_win_priority(a->fmt.priv);
+
+	return 0;
+}
+
+static int s5p_tvout_vo_overlay(struct file *file, void *fh,
+				unsigned int i)
+{
+	tvout_dbg("%s\n", (i) ? "start" : "stop");
+
+	if (i)
+		s5p_vp_ctrl_start();
+	else
+		s5p_vp_ctrl_stop();
+
+	return 0;
+}
+
+const struct v4l2_ioctl_ops s5p_tvout_vo_ioctl_ops = {
+	.vidioc_querycap		= s5p_tvout_vo_querycap,
+
+	.vidioc_enum_fmt_type_private	= s5p_tvout_vo_enum_fmt_type_private,
+	.vidioc_g_fmt_type_private	= s5p_tvout_vo_g_fmt_type_private,
+	.vidioc_s_fmt_type_private	= s5p_tvout_vo_s_fmt_type_private,
+
+	.vidioc_g_fmt_vid_overlay	= s5p_tvout_vo_g_fmt_vid_overlay,
+	.vidioc_s_fmt_vid_overlay	= s5p_tvout_vo_s_fmt_vid_overlay,
+
+	.vidioc_g_crop			= s5p_tvout_vo_g_crop,
+	.vidioc_s_crop			= s5p_tvout_vo_s_crop,
+
+	.vidioc_g_fbuf			= s5p_tvout_vo_g_fbuf,
+	.vidioc_s_fbuf			= s5p_tvout_vo_s_fbuf,
+
+	.vidioc_overlay			= s5p_tvout_vo_overlay,
+};
+
+static int s5p_tvout_vo_open(struct file *file)
+{
+	int ret = 0;
+
+	tvout_dbg("\n");
+
+	mutex_lock(&s5p_tvout_vo_mutex);
+
+	if (atomic_read(&s5p_tvout_v4l2_private.vo_use)) {
+		tvout_err("Can't open TVOUT TVIF control\n");
+		ret = -EBUSY;
+	} else
+		atomic_inc(&s5p_tvout_v4l2_private.vo_use);
+
+	mutex_unlock(&s5p_tvout_vo_mutex);
+
+	return ret;
+}
+
+static int s5p_tvout_vo_release(struct file *file)
+{
+	tvout_dbg("\n");
+
+	s5p_vp_ctrl_stop();
+
+	s5p_mixer_ctrl_disable_layer(MIXER_VIDEO_LAYER);
+
+	atomic_dec(&s5p_tvout_v4l2_private.vo_use);
+
+	return 0;
+}
+
+static struct v4l2_file_operations s5p_tvout_vo_fops = {
+	.owner		= THIS_MODULE,
+	.open		= s5p_tvout_vo_open,
+	.release	= s5p_tvout_vo_release,
+	.ioctl		= video_ioctl2
+};
+
+static void s5p_tvout_video_dev_release(struct video_device *vdev)
+{
+	/* dummy function for release callback of v4l2 video device */
+}
+
+static struct video_device s5p_tvout_video_dev[] = {
+	[0] = {
+		.name		= "S5P TVOUT TVIF control",
+		.fops		= &s5p_tvout_tvif_fops,
+		.ioctl_ops	= &s5p_tvout_tvif_ioctl_ops,
+		.minor		= S5P_TVOUT_TVIF_MINOR,
+		.release	= s5p_tvout_video_dev_release,
+		.tvnorms	= V4L2_STD_ALL_HD,
+	},
+	[1] = {
+		.name		= "S5P TVOUT Video Overlay",
+		.fops		= &s5p_tvout_vo_fops,
+		.ioctl_ops	= &s5p_tvout_vo_ioctl_ops,
+		.release	= s5p_tvout_video_dev_release,
+		.minor		= S5P_TVOUT_VO_MINOR
+	}
+};
+
+int s5p_tvout_v4l2_constructor(struct platform_device *pdev)
+{
+	int i;
+
+	/* v4l2 video device registration */
+	for (i = 0; i < ARRAY_SIZE(s5p_tvout_video_dev); i++) {
+
+		if (video_register_device(
+				&s5p_tvout_video_dev[i],
+				VFL_TYPE_GRABBER,
+				s5p_tvout_video_dev[i].minor) != 0) {
+			tvout_err("Fail to register v4l2 video device\n");
+
+			return -1;
+		}
+	}
+
+#ifdef CONFIG_S5P_HDMI_HPD
+	s5p_hpd_set_kobj(&(s5p_tvout_video_dev[0].dev.kobj),
+			 &(s5p_tvout_video_dev[1].dev.kobj));
+#endif
+	s5p_tvout_v4l2_init_private();
+
+	return 0;
+}
+
+void s5p_tvout_v4l2_destructor(void)
+{
+	mutex_destroy(&s5p_tvout_tvif_mutex);
+	mutex_destroy(&s5p_tvout_vo_mutex);
+}
diff --git a/drivers/media/video/s5p-tvout/s5p_tvout_v4l2.h b/drivers/media/video/s5p-tvout/s5p_tvout_v4l2.h
new file mode 100644
index 0000000..9119ce9
--- /dev/null
+++ b/drivers/media/video/s5p-tvout/s5p_tvout_v4l2.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * Video4Linux API header for Samsung S5P TVOUT driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef __S5P_TVOUT_V4L2_H_
+#define __S5P_TVOUT_V4L2_H_ __FILE__
+
+extern int s5p_tvout_v4l2_constructor(struct platform_device *pdev);
+extern void s5p_tvout_v4l2_destructor(void);
+
+#endif /* __S5P_TVOUT_V4L2_H_ */
-- 
1.7.1

