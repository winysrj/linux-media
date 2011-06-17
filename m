Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:33730 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756131Ab1FQHBt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2011 03:01:49 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p5H71jkN018355
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 17 Jun 2011 02:01:47 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [RESEND PATCH v19 3/6] davinci vpbe: OSD(On Screen Display) block
Date: Fri, 17 Jun 2011 12:31:33 +0530
Message-ID: <1308294096-25743-4-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1308294096-25743-1-git-send-email-manjunath.hadli@ti.com>
References: <1308294096-25743-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch implements the functionality of the OSD block
of the VPBE. The OSD in total supports 4 planes or Video
sources - 2 mainly RGB and 2 Video. The patch implements general
handling of all the planes, with specific emphasis on the Video
plane capabilities as the Video planes are supported through the
V4L2 driver.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/davinci/vpbe_osd.c      | 1231 +++++++++++++++++++++++++++
 drivers/media/video/davinci/vpbe_osd_regs.h |  364 ++++++++
 include/media/davinci/vpbe_osd.h            |  394 +++++++++
 3 files changed, 1989 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/davinci/vpbe_osd.c
 create mode 100644 drivers/media/video/davinci/vpbe_osd_regs.h
 create mode 100644 include/media/davinci/vpbe_osd.h

diff --git a/drivers/media/video/davinci/vpbe_osd.c b/drivers/media/video/davinci/vpbe_osd.c
new file mode 100644
index 0000000..5352884
--- /dev/null
+++ b/drivers/media/video/davinci/vpbe_osd.c
@@ -0,0 +1,1231 @@
+/*
+ * Copyright (C) 2007-2010 Texas Instruments Inc
+ * Copyright (C) 2007 MontaVista Software, Inc.
+ *
+ * Andy Lowe (alowe@mvista.com), MontaVista Software
+ * - Initial version
+ * Murali Karicheri (mkaricheri@gmail.com), Texas Instruments Ltd.
+ * - ported to sub device interface
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation version 2.
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
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/slab.h>
+
+#include <mach/io.h>
+#include <mach/cputype.h>
+#include <mach/hardware.h>
+
+#include <media/davinci/vpss.h>
+#include <media/v4l2-device.h>
+#include <media/davinci/vpbe_types.h>
+#include <media/davinci/vpbe_osd.h>
+
+#include <linux/io.h>
+#include "vpbe_osd_regs.h"
+
+#define MODULE_NAME	VPBE_OSD_SUBDEV_NAME
+
+/* register access routines */
+static inline u32 osd_read(struct osd_state *sd, u32 offset)
+{
+	struct osd_state *osd = sd;
+
+	return readl(osd->osd_base + offset);
+}
+
+static inline u32 osd_write(struct osd_state *sd, u32 val, u32 offset)
+{
+	struct osd_state *osd = sd;
+
+	writel(val, osd->osd_base + offset);
+
+	return val;
+}
+
+static inline u32 osd_set(struct osd_state *sd, u32 mask, u32 offset)
+{
+	struct osd_state *osd = sd;
+
+	u32 addr = osd->osd_base + offset;
+	u32 val = readl(addr) | mask;
+
+	writel(val, addr);
+
+	return val;
+}
+
+static inline u32 osd_clear(struct osd_state *sd, u32 mask, u32 offset)
+{
+	struct osd_state *osd = sd;
+
+	u32 addr = osd->osd_base + offset;
+	u32 val = readl(addr) & ~mask;
+
+	writel(val, addr);
+
+	return val;
+}
+
+static inline u32 osd_modify(struct osd_state *sd, u32 mask, u32 val,
+				 u32 offset)
+{
+	struct osd_state *osd = sd;
+
+	u32 addr = osd->osd_base + offset;
+	u32 new_val = (readl(addr) & ~mask) | (val & mask);
+
+	writel(new_val, addr);
+
+	return new_val;
+}
+
+/* define some macros for layer and pixfmt classification */
+#define is_osd_win(layer) (((layer) == WIN_OSD0) || ((layer) == WIN_OSD1))
+#define is_vid_win(layer) (((layer) == WIN_VID0) || ((layer) == WIN_VID1))
+#define is_rgb_pixfmt(pixfmt) \
+	(((pixfmt) == PIXFMT_RGB565) || ((pixfmt) == PIXFMT_RGB888))
+#define is_yc_pixfmt(pixfmt) \
+	(((pixfmt) == PIXFMT_YCbCrI) || ((pixfmt) == PIXFMT_YCrCbI) || \
+	((pixfmt) == PIXFMT_NV12))
+#define MAX_WIN_SIZE OSD_VIDWIN0XP_V0X
+#define MAX_LINE_LENGTH (OSD_VIDWIN0OFST_V0LO << 5)
+
+/**
+ * _osd_dm6446_vid0_pingpong() - field inversion fix for DM6446
+ * @sd - ptr to struct osd_state
+ * @field_inversion - inversion flag
+ * @fb_base_phys - frame buffer address
+ * @lconfig - ptr to layer config
+ *
+ * This routine implements a workaround for the field signal inversion silicon
+ * erratum described in Advisory 1.3.8 for the DM6446.  The fb_base_phys and
+ * lconfig parameters apply to the vid0 window.  This routine should be called
+ * whenever the vid0 layer configuration or start address is modified, or when
+ * the OSD field inversion setting is modified.
+ * Returns: 1 if the ping-pong buffers need to be toggled in the vsync isr, or
+ *          0 otherwise
+ */
+static int _osd_dm6446_vid0_pingpong(struct osd_state *sd,
+				     int field_inversion,
+				     unsigned long fb_base_phys,
+				     const struct osd_layer_config *lconfig)
+{
+	struct osd_platform_data *pdata;
+
+	pdata = (struct osd_platform_data *)sd->dev->platform_data;
+	if (pdata->field_inv_wa_enable) {
+
+		if (!field_inversion || !lconfig->interlaced) {
+			osd_write(sd, fb_base_phys & ~0x1F, OSD_VIDWIN0ADR);
+			osd_write(sd, fb_base_phys & ~0x1F, OSD_PPVWIN0ADR);
+			osd_modify(sd, OSD_MISCCTL_PPSW | OSD_MISCCTL_PPRV, 0,
+				   OSD_MISCCTL);
+			return 0;
+		} else {
+			unsigned miscctl = OSD_MISCCTL_PPRV;
+
+			osd_write(sd,
+				(fb_base_phys & ~0x1F) - lconfig->line_length,
+				OSD_VIDWIN0ADR);
+			osd_write(sd,
+				(fb_base_phys & ~0x1F) + lconfig->line_length,
+				OSD_PPVWIN0ADR);
+			osd_modify(sd,
+				OSD_MISCCTL_PPSW | OSD_MISCCTL_PPRV, miscctl,
+				OSD_MISCCTL);
+
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static void _osd_set_field_inversion(struct osd_state *sd, int enable)
+{
+	unsigned fsinv = 0;
+
+	if (enable)
+		fsinv = OSD_MODE_FSINV;
+
+	osd_modify(sd, OSD_MODE_FSINV, fsinv, OSD_MODE);
+}
+
+static void _osd_set_blink_attribute(struct osd_state *sd, int enable,
+				     enum osd_blink_interval blink)
+{
+	u32 osdatrmd = 0;
+
+	if (enable) {
+		osdatrmd |= OSD_OSDATRMD_BLNK;
+		osdatrmd |= blink << OSD_OSDATRMD_BLNKINT_SHIFT;
+	}
+	/* caller must ensure that OSD1 is configured in attribute mode */
+	osd_modify(sd, OSD_OSDATRMD_BLNKINT | OSD_OSDATRMD_BLNK, osdatrmd,
+		  OSD_OSDATRMD);
+}
+
+static void _osd_set_rom_clut(struct osd_state *sd,
+			      enum osd_rom_clut rom_clut)
+{
+	if (rom_clut == ROM_CLUT0)
+		osd_clear(sd, OSD_MISCCTL_RSEL, OSD_MISCCTL);
+	else
+		osd_set(sd, OSD_MISCCTL_RSEL, OSD_MISCCTL);
+}
+
+static void _osd_set_palette_map(struct osd_state *sd,
+				 enum osd_win_layer osdwin,
+				 unsigned char pixel_value,
+				 unsigned char clut_index,
+				 enum osd_pix_format pixfmt)
+{
+	static const int map_2bpp[] = { 0, 5, 10, 15 };
+	static const int map_1bpp[] = { 0, 15 };
+	int bmp_offset;
+	int bmp_shift;
+	int bmp_mask;
+	int bmp_reg;
+
+	switch (pixfmt) {
+	case PIXFMT_1BPP:
+		bmp_reg = map_1bpp[pixel_value & 0x1];
+		break;
+	case PIXFMT_2BPP:
+		bmp_reg = map_2bpp[pixel_value & 0x3];
+		break;
+	case PIXFMT_4BPP:
+		bmp_reg = pixel_value & 0xf;
+		break;
+	default:
+		return;
+	}
+
+	switch (osdwin) {
+	case OSDWIN_OSD0:
+		bmp_offset = OSD_W0BMP01 + (bmp_reg >> 1) * sizeof(u32);
+		break;
+	case OSDWIN_OSD1:
+		bmp_offset = OSD_W1BMP01 + (bmp_reg >> 1) * sizeof(u32);
+		break;
+	default:
+		return;
+	}
+
+	if (bmp_reg & 1) {
+		bmp_shift = 8;
+		bmp_mask = 0xff << 8;
+	} else {
+		bmp_shift = 0;
+		bmp_mask = 0xff;
+	}
+
+	osd_modify(sd, bmp_mask, clut_index << bmp_shift, bmp_offset);
+}
+
+static void _osd_set_rec601_attenuation(struct osd_state *sd,
+					enum osd_win_layer osdwin, int enable)
+{
+	switch (osdwin) {
+	case OSDWIN_OSD0:
+		osd_modify(sd, OSD_OSDWIN0MD_ATN0E,
+			  enable ? OSD_OSDWIN0MD_ATN0E : 0,
+			  OSD_OSDWIN0MD);
+		break;
+	case OSDWIN_OSD1:
+		osd_modify(sd, OSD_OSDWIN1MD_ATN1E,
+			  enable ? OSD_OSDWIN1MD_ATN1E : 0,
+			  OSD_OSDWIN1MD);
+		break;
+	}
+}
+
+static void _osd_set_blending_factor(struct osd_state *sd,
+				     enum osd_win_layer osdwin,
+				     enum osd_blending_factor blend)
+{
+	switch (osdwin) {
+	case OSDWIN_OSD0:
+		osd_modify(sd, OSD_OSDWIN0MD_BLND0,
+			  blend << OSD_OSDWIN0MD_BLND0_SHIFT, OSD_OSDWIN0MD);
+		break;
+	case OSDWIN_OSD1:
+		osd_modify(sd, OSD_OSDWIN1MD_BLND1,
+			  blend << OSD_OSDWIN1MD_BLND1_SHIFT, OSD_OSDWIN1MD);
+		break;
+	}
+}
+
+static void _osd_enable_color_key(struct osd_state *sd,
+				  enum osd_win_layer osdwin,
+				  unsigned colorkey,
+				  enum osd_pix_format pixfmt)
+{
+	switch (pixfmt) {
+	case PIXFMT_RGB565:
+		osd_write(sd, colorkey & OSD_TRANSPVAL_RGBTRANS,
+			  OSD_TRANSPVAL);
+		break;
+	default:
+		break;
+	}
+
+	switch (osdwin) {
+	case OSDWIN_OSD0:
+		osd_set(sd, OSD_OSDWIN0MD_TE0, OSD_OSDWIN0MD);
+		break;
+	case OSDWIN_OSD1:
+		osd_set(sd, OSD_OSDWIN1MD_TE1, OSD_OSDWIN1MD);
+		break;
+	}
+}
+
+static void _osd_disable_color_key(struct osd_state *sd,
+				   enum osd_win_layer osdwin)
+{
+	switch (osdwin) {
+	case OSDWIN_OSD0:
+		osd_clear(sd, OSD_OSDWIN0MD_TE0, OSD_OSDWIN0MD);
+		break;
+	case OSDWIN_OSD1:
+		osd_clear(sd, OSD_OSDWIN1MD_TE1, OSD_OSDWIN1MD);
+		break;
+	}
+}
+
+static void _osd_set_osd_clut(struct osd_state *sd,
+			      enum osd_win_layer osdwin,
+			      enum osd_clut clut)
+{
+	u32 winmd = 0;
+
+	switch (osdwin) {
+	case OSDWIN_OSD0:
+		if (clut == RAM_CLUT)
+			winmd |= OSD_OSDWIN0MD_CLUTS0;
+		osd_modify(sd, OSD_OSDWIN0MD_CLUTS0, winmd, OSD_OSDWIN0MD);
+		break;
+	case OSDWIN_OSD1:
+		if (clut == RAM_CLUT)
+			winmd |= OSD_OSDWIN1MD_CLUTS1;
+		osd_modify(sd, OSD_OSDWIN1MD_CLUTS1, winmd, OSD_OSDWIN1MD);
+		break;
+	}
+}
+
+static void _osd_set_zoom(struct osd_state *sd, enum osd_layer layer,
+			  enum osd_zoom_factor h_zoom,
+			  enum osd_zoom_factor v_zoom)
+{
+	u32 winmd = 0;
+
+	switch (layer) {
+	case WIN_OSD0:
+		winmd |= (h_zoom << OSD_OSDWIN0MD_OHZ0_SHIFT);
+		winmd |= (v_zoom << OSD_OSDWIN0MD_OVZ0_SHIFT);
+		osd_modify(sd, OSD_OSDWIN0MD_OHZ0 | OSD_OSDWIN0MD_OVZ0, winmd,
+			  OSD_OSDWIN0MD);
+		break;
+	case WIN_VID0:
+		winmd |= (h_zoom << OSD_VIDWINMD_VHZ0_SHIFT);
+		winmd |= (v_zoom << OSD_VIDWINMD_VVZ0_SHIFT);
+		osd_modify(sd, OSD_VIDWINMD_VHZ0 | OSD_VIDWINMD_VVZ0, winmd,
+			  OSD_VIDWINMD);
+		break;
+	case WIN_OSD1:
+		winmd |= (h_zoom << OSD_OSDWIN1MD_OHZ1_SHIFT);
+		winmd |= (v_zoom << OSD_OSDWIN1MD_OVZ1_SHIFT);
+		osd_modify(sd, OSD_OSDWIN1MD_OHZ1 | OSD_OSDWIN1MD_OVZ1, winmd,
+			  OSD_OSDWIN1MD);
+		break;
+	case WIN_VID1:
+		winmd |= (h_zoom << OSD_VIDWINMD_VHZ1_SHIFT);
+		winmd |= (v_zoom << OSD_VIDWINMD_VVZ1_SHIFT);
+		osd_modify(sd, OSD_VIDWINMD_VHZ1 | OSD_VIDWINMD_VVZ1, winmd,
+			  OSD_VIDWINMD);
+		break;
+	}
+}
+
+static void _osd_disable_layer(struct osd_state *sd, enum osd_layer layer)
+{
+	switch (layer) {
+	case WIN_OSD0:
+		osd_clear(sd, OSD_OSDWIN0MD_OACT0, OSD_OSDWIN0MD);
+		break;
+	case WIN_VID0:
+		osd_clear(sd, OSD_VIDWINMD_ACT0, OSD_VIDWINMD);
+		break;
+	case WIN_OSD1:
+		/* disable attribute mode as well as disabling the window */
+		osd_clear(sd, OSD_OSDWIN1MD_OASW | OSD_OSDWIN1MD_OACT1,
+			  OSD_OSDWIN1MD);
+		break;
+	case WIN_VID1:
+		osd_clear(sd, OSD_VIDWINMD_ACT1, OSD_VIDWINMD);
+		break;
+	}
+}
+
+static void osd_disable_layer(struct osd_state *sd, enum osd_layer layer)
+{
+	struct osd_state *osd = sd;
+	struct osd_window_state *win = &osd->win[layer];
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	if (!win->is_enabled) {
+		spin_unlock_irqrestore(&osd->lock, flags);
+		return;
+	}
+	win->is_enabled = 0;
+
+	_osd_disable_layer(sd, layer);
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+static void _osd_enable_attribute_mode(struct osd_state *sd)
+{
+	/* enable attribute mode for OSD1 */
+	osd_set(sd, OSD_OSDWIN1MD_OASW, OSD_OSDWIN1MD);
+}
+
+static void _osd_enable_layer(struct osd_state *sd, enum osd_layer layer)
+{
+	switch (layer) {
+	case WIN_OSD0:
+		osd_set(sd, OSD_OSDWIN0MD_OACT0, OSD_OSDWIN0MD);
+		break;
+	case WIN_VID0:
+		osd_set(sd, OSD_VIDWINMD_ACT0, OSD_VIDWINMD);
+		break;
+	case WIN_OSD1:
+		/* enable OSD1 and disable attribute mode */
+		osd_modify(sd, OSD_OSDWIN1MD_OASW | OSD_OSDWIN1MD_OACT1,
+			  OSD_OSDWIN1MD_OACT1, OSD_OSDWIN1MD);
+		break;
+	case WIN_VID1:
+		osd_set(sd, OSD_VIDWINMD_ACT1, OSD_VIDWINMD);
+		break;
+	}
+}
+
+static int osd_enable_layer(struct osd_state *sd, enum osd_layer layer,
+			    int otherwin)
+{
+	struct osd_state *osd = sd;
+	struct osd_window_state *win = &osd->win[layer];
+	struct osd_layer_config *cfg = &win->lconfig;
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	/*
+	 * use otherwin flag to know this is the other vid window
+	 * in YUV420 mode, if is, skip this check
+	 */
+	if (!otherwin && (!win->is_allocated ||
+			!win->fb_base_phys ||
+			!cfg->line_length ||
+			!cfg->xsize ||
+			!cfg->ysize)) {
+		spin_unlock_irqrestore(&osd->lock, flags);
+		return -1;
+	}
+
+	if (win->is_enabled) {
+		spin_unlock_irqrestore(&osd->lock, flags);
+		return 0;
+	}
+	win->is_enabled = 1;
+
+	if (cfg->pixfmt != PIXFMT_OSD_ATTR)
+		_osd_enable_layer(sd, layer);
+	else {
+		_osd_enable_attribute_mode(sd);
+		_osd_set_blink_attribute(sd, osd->is_blinking, osd->blink);
+	}
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+
+	return 0;
+}
+
+static void _osd_start_layer(struct osd_state *sd, enum osd_layer layer,
+			     unsigned long fb_base_phys,
+			     unsigned long cbcr_ofst)
+{
+	switch (layer) {
+	case WIN_OSD0:
+		osd_write(sd, fb_base_phys & ~0x1F, OSD_OSDWIN0ADR);
+		break;
+	case WIN_VID0:
+		osd_write(sd, fb_base_phys & ~0x1F, OSD_VIDWIN0ADR);
+		break;
+	case WIN_OSD1:
+		osd_write(sd, fb_base_phys & ~0x1F, OSD_OSDWIN1ADR);
+		break;
+	case WIN_VID1:
+		osd_write(sd, fb_base_phys & ~0x1F, OSD_VIDWIN1ADR);
+		break;
+	}
+}
+
+static void osd_start_layer(struct osd_state *sd, enum osd_layer layer,
+			    unsigned long fb_base_phys,
+			    unsigned long cbcr_ofst)
+{
+	struct osd_state *osd = sd;
+	struct osd_window_state *win = &osd->win[layer];
+	struct osd_layer_config *cfg = &win->lconfig;
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	win->fb_base_phys = fb_base_phys & ~0x1F;
+	_osd_start_layer(sd, layer, fb_base_phys, cbcr_ofst);
+
+	if (layer == WIN_VID0) {
+		osd->pingpong =
+		    _osd_dm6446_vid0_pingpong(sd, osd->field_inversion,
+						       win->fb_base_phys,
+						       cfg);
+	}
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+static void osd_get_layer_config(struct osd_state *sd, enum osd_layer layer,
+				 struct osd_layer_config *lconfig)
+{
+	struct osd_state *osd = sd;
+	struct osd_window_state *win = &osd->win[layer];
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	*lconfig = win->lconfig;
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+/**
+ * try_layer_config() - Try a specific configuration for the layer
+ * @sd  - ptr to struct osd_state
+ * @layer - layer to configure
+ * @lconfig - layer configuration to try
+ *
+ * If the requested lconfig is completely rejected and the value of lconfig on
+ * exit is the current lconfig, then try_layer_config() returns 1.  Otherwise,
+ * try_layer_config() returns 0.  A return value of 0 does not necessarily mean
+ * that the value of lconfig on exit is identical to the value of lconfig on
+ * entry, but merely that it represents a change from the current lconfig.
+ */
+static int try_layer_config(struct osd_state *sd, enum osd_layer layer,
+			    struct osd_layer_config *lconfig)
+{
+	struct osd_state *osd = sd;
+	struct osd_window_state *win = &osd->win[layer];
+	int bad_config;
+
+	/* verify that the pixel format is compatible with the layer */
+	switch (lconfig->pixfmt) {
+	case PIXFMT_1BPP:
+	case PIXFMT_2BPP:
+	case PIXFMT_4BPP:
+	case PIXFMT_8BPP:
+	case PIXFMT_RGB565:
+		bad_config = !is_osd_win(layer);
+		break;
+	case PIXFMT_YCbCrI:
+	case PIXFMT_YCrCbI:
+		bad_config = !is_vid_win(layer);
+		break;
+	case PIXFMT_RGB888:
+		bad_config = !is_vid_win(layer);
+		break;
+	case PIXFMT_NV12:
+		bad_config = 1;
+		break;
+	case PIXFMT_OSD_ATTR:
+		bad_config = (layer != WIN_OSD1);
+		break;
+	default:
+		bad_config = 1;
+		break;
+	}
+	if (bad_config) {
+		/*
+		 * The requested pixel format is incompatible with the layer,
+		 * so keep the current layer configuration.
+		 */
+		*lconfig = win->lconfig;
+		return bad_config;
+	}
+
+	/* DM6446: */
+	/* only one OSD window at a time can use RGB pixel formats */
+	if (is_osd_win(layer) && is_rgb_pixfmt(lconfig->pixfmt)) {
+		enum osd_pix_format pixfmt;
+		if (layer == WIN_OSD0)
+			pixfmt = osd->win[WIN_OSD1].lconfig.pixfmt;
+		else
+			pixfmt = osd->win[WIN_OSD0].lconfig.pixfmt;
+
+		if (is_rgb_pixfmt(pixfmt)) {
+			/*
+			 * The other OSD window is already configured for an
+			 * RGB, so keep the current layer configuration.
+			 */
+			*lconfig = win->lconfig;
+			return 1;
+		}
+	}
+
+	/* DM6446: only one video window at a time can use RGB888 */
+	if (is_vid_win(layer) && lconfig->pixfmt == PIXFMT_RGB888) {
+		enum osd_pix_format pixfmt;
+
+		if (layer == WIN_VID0)
+			pixfmt = osd->win[WIN_VID1].lconfig.pixfmt;
+		else
+			pixfmt = osd->win[WIN_VID0].lconfig.pixfmt;
+
+		if (pixfmt == PIXFMT_RGB888) {
+			/*
+			 * The other video window is already configured for
+			 * RGB888, so keep the current layer configuration.
+			 */
+			*lconfig = win->lconfig;
+			return 1;
+		}
+	}
+
+	/* window dimensions must be non-zero */
+	if (!lconfig->line_length || !lconfig->xsize || !lconfig->ysize) {
+		*lconfig = win->lconfig;
+		return 1;
+	}
+
+	/* round line_length up to a multiple of 32 */
+	lconfig->line_length = ((lconfig->line_length + 31) / 32) * 32;
+	lconfig->line_length =
+	    min(lconfig->line_length, (unsigned)MAX_LINE_LENGTH);
+	lconfig->xsize = min(lconfig->xsize, (unsigned)MAX_WIN_SIZE);
+	lconfig->ysize = min(lconfig->ysize, (unsigned)MAX_WIN_SIZE);
+	lconfig->xpos = min(lconfig->xpos, (unsigned)MAX_WIN_SIZE);
+	lconfig->ypos = min(lconfig->ypos, (unsigned)MAX_WIN_SIZE);
+	lconfig->interlaced = (lconfig->interlaced != 0);
+	if (lconfig->interlaced) {
+		/* ysize and ypos must be even for interlaced displays */
+		lconfig->ysize &= ~1;
+		lconfig->ypos &= ~1;
+	}
+
+	return 0;
+}
+
+static void _osd_disable_vid_rgb888(struct osd_state *sd)
+{
+	/*
+	 * The DM6446 supports RGB888 pixel format in a single video window.
+	 * This routine disables RGB888 pixel format for both video windows.
+	 * The caller must ensure that neither video window is currently
+	 * configured for RGB888 pixel format.
+	 */
+	osd_clear(sd, OSD_MISCCTL_RGBEN, OSD_MISCCTL);
+}
+
+static void _osd_enable_vid_rgb888(struct osd_state *sd,
+				   enum osd_layer layer)
+{
+	/*
+	 * The DM6446 supports RGB888 pixel format in a single video window.
+	 * This routine enables RGB888 pixel format for the specified video
+	 * window.  The caller must ensure that the other video window is not
+	 * currently configured for RGB888 pixel format, as this routine will
+	 * disable RGB888 pixel format for the other window.
+	 */
+	if (layer == WIN_VID0) {
+		osd_modify(sd, OSD_MISCCTL_RGBEN | OSD_MISCCTL_RGBWIN,
+			  OSD_MISCCTL_RGBEN, OSD_MISCCTL);
+	} else if (layer == WIN_VID1) {
+		osd_modify(sd, OSD_MISCCTL_RGBEN | OSD_MISCCTL_RGBWIN,
+			  OSD_MISCCTL_RGBEN | OSD_MISCCTL_RGBWIN,
+			  OSD_MISCCTL);
+	}
+}
+
+static void _osd_set_cbcr_order(struct osd_state *sd,
+				enum osd_pix_format pixfmt)
+{
+	/*
+	 * The caller must ensure that all windows using YC pixfmt use the same
+	 * Cb/Cr order.
+	 */
+	if (pixfmt == PIXFMT_YCbCrI)
+		osd_clear(sd, OSD_MODE_CS, OSD_MODE);
+	else if (pixfmt == PIXFMT_YCrCbI)
+		osd_set(sd, OSD_MODE_CS, OSD_MODE);
+}
+
+static void _osd_set_layer_config(struct osd_state *sd, enum osd_layer layer,
+				  const struct osd_layer_config *lconfig)
+{
+	u32 winmd = 0, winmd_mask = 0, bmw = 0;
+
+	_osd_set_cbcr_order(sd, lconfig->pixfmt);
+
+	switch (layer) {
+	case WIN_OSD0:
+		winmd_mask |= OSD_OSDWIN0MD_RGB0E;
+		if (lconfig->pixfmt == PIXFMT_RGB565)
+			winmd |= OSD_OSDWIN0MD_RGB0E;
+
+		winmd_mask |= OSD_OSDWIN0MD_BMW0 | OSD_OSDWIN0MD_OFF0;
+
+		switch (lconfig->pixfmt) {
+		case PIXFMT_1BPP:
+			bmw = 0;
+			break;
+		case PIXFMT_2BPP:
+			bmw = 1;
+			break;
+		case PIXFMT_4BPP:
+			bmw = 2;
+			break;
+		case PIXFMT_8BPP:
+			bmw = 3;
+			break;
+		default:
+			break;
+		}
+		winmd |= (bmw << OSD_OSDWIN0MD_BMW0_SHIFT);
+
+		if (lconfig->interlaced)
+			winmd |= OSD_OSDWIN0MD_OFF0;
+
+		osd_modify(sd, winmd_mask, winmd, OSD_OSDWIN0MD);
+		osd_write(sd, lconfig->line_length >> 5, OSD_OSDWIN0OFST);
+		osd_write(sd, lconfig->xpos, OSD_OSDWIN0XP);
+		osd_write(sd, lconfig->xsize, OSD_OSDWIN0XL);
+		if (lconfig->interlaced) {
+			osd_write(sd, lconfig->ypos >> 1, OSD_OSDWIN0YP);
+			osd_write(sd, lconfig->ysize >> 1, OSD_OSDWIN0YL);
+		} else {
+			osd_write(sd, lconfig->ypos, OSD_OSDWIN0YP);
+			osd_write(sd, lconfig->ysize, OSD_OSDWIN0YL);
+		}
+		break;
+	case WIN_VID0:
+		winmd_mask |= OSD_VIDWINMD_VFF0;
+		if (lconfig->interlaced)
+			winmd |= OSD_VIDWINMD_VFF0;
+
+		osd_modify(sd, winmd_mask, winmd, OSD_VIDWINMD);
+		osd_write(sd, lconfig->line_length >> 5, OSD_VIDWIN0OFST);
+		osd_write(sd, lconfig->xpos, OSD_VIDWIN0XP);
+		osd_write(sd, lconfig->xsize, OSD_VIDWIN0XL);
+		/*
+		 * For YUV420P format the register contents are
+		 * duplicated in both VID registers
+		 */
+		if (lconfig->interlaced) {
+			osd_write(sd, lconfig->ypos >> 1, OSD_VIDWIN0YP);
+			osd_write(sd, lconfig->ysize >> 1, OSD_VIDWIN0YL);
+		} else {
+			osd_write(sd, lconfig->ypos, OSD_VIDWIN0YP);
+			osd_write(sd, lconfig->ysize, OSD_VIDWIN0YL);
+		}
+		break;
+	case WIN_OSD1:
+		/*
+		 * The caller must ensure that OSD1 is disabled prior to
+		 * switching from a normal mode to attribute mode or from
+		 * attribute mode to a normal mode.
+		 */
+		if (lconfig->pixfmt == PIXFMT_OSD_ATTR) {
+			winmd_mask |=
+			    OSD_OSDWIN1MD_ATN1E | OSD_OSDWIN1MD_RGB1E |
+			    OSD_OSDWIN1MD_CLUTS1 |
+			    OSD_OSDWIN1MD_BLND1 | OSD_OSDWIN1MD_TE1;
+		} else {
+			winmd_mask |= OSD_OSDWIN1MD_RGB1E;
+			if (lconfig->pixfmt == PIXFMT_RGB565)
+				winmd |= OSD_OSDWIN1MD_RGB1E;
+
+			winmd_mask |= OSD_OSDWIN1MD_BMW1;
+			switch (lconfig->pixfmt) {
+			case PIXFMT_1BPP:
+				bmw = 0;
+				break;
+			case PIXFMT_2BPP:
+				bmw = 1;
+				break;
+			case PIXFMT_4BPP:
+				bmw = 2;
+				break;
+			case PIXFMT_8BPP:
+				bmw = 3;
+				break;
+			default:
+				break;
+			}
+			winmd |= (bmw << OSD_OSDWIN1MD_BMW1_SHIFT);
+		}
+
+		winmd_mask |= OSD_OSDWIN1MD_OFF1;
+		if (lconfig->interlaced)
+			winmd |= OSD_OSDWIN1MD_OFF1;
+
+		osd_modify(sd, winmd_mask, winmd, OSD_OSDWIN1MD);
+		osd_write(sd, lconfig->line_length >> 5, OSD_OSDWIN1OFST);
+		osd_write(sd, lconfig->xpos, OSD_OSDWIN1XP);
+		osd_write(sd, lconfig->xsize, OSD_OSDWIN1XL);
+		if (lconfig->interlaced) {
+			osd_write(sd, lconfig->ypos >> 1, OSD_OSDWIN1YP);
+			osd_write(sd, lconfig->ysize >> 1, OSD_OSDWIN1YL);
+		} else {
+			osd_write(sd, lconfig->ypos, OSD_OSDWIN1YP);
+			osd_write(sd, lconfig->ysize, OSD_OSDWIN1YL);
+		}
+		break;
+	case WIN_VID1:
+		winmd_mask |= OSD_VIDWINMD_VFF1;
+		if (lconfig->interlaced)
+			winmd |= OSD_VIDWINMD_VFF1;
+
+		osd_modify(sd, winmd_mask, winmd, OSD_VIDWINMD);
+		osd_write(sd, lconfig->line_length >> 5, OSD_VIDWIN1OFST);
+		osd_write(sd, lconfig->xpos, OSD_VIDWIN1XP);
+		osd_write(sd, lconfig->xsize, OSD_VIDWIN1XL);
+		/*
+		 * For YUV420P format the register contents are
+		 * duplicated in both VID registers
+		 */
+		osd_modify(sd, OSD_MISCCTL_S420D, ~OSD_MISCCTL_S420D,
+			   OSD_MISCCTL);
+
+		if (lconfig->interlaced) {
+			osd_write(sd, lconfig->ypos >> 1, OSD_VIDWIN1YP);
+			osd_write(sd, lconfig->ysize >> 1, OSD_VIDWIN1YL);
+		} else {
+			osd_write(sd, lconfig->ypos, OSD_VIDWIN1YP);
+			osd_write(sd, lconfig->ysize, OSD_VIDWIN1YL);
+		}
+		break;
+	}
+}
+
+static int osd_set_layer_config(struct osd_state *sd, enum osd_layer layer,
+				struct osd_layer_config *lconfig)
+{
+	struct osd_state *osd = sd;
+	struct osd_window_state *win = &osd->win[layer];
+	struct osd_layer_config *cfg = &win->lconfig;
+	unsigned long flags;
+	int reject_config;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	reject_config = try_layer_config(sd, layer, lconfig);
+	if (reject_config) {
+		spin_unlock_irqrestore(&osd->lock, flags);
+		return reject_config;
+	}
+
+	/* update the current Cb/Cr order */
+	if (is_yc_pixfmt(lconfig->pixfmt))
+		osd->yc_pixfmt = lconfig->pixfmt;
+
+	/*
+	 * If we are switching OSD1 from normal mode to attribute mode or from
+	 * attribute mode to normal mode, then we must disable the window.
+	 */
+	if (layer == WIN_OSD1) {
+		if (((lconfig->pixfmt == PIXFMT_OSD_ATTR) &&
+		  (cfg->pixfmt != PIXFMT_OSD_ATTR)) ||
+		  ((lconfig->pixfmt != PIXFMT_OSD_ATTR) &&
+		  (cfg->pixfmt == PIXFMT_OSD_ATTR))) {
+			win->is_enabled = 0;
+			_osd_disable_layer(sd, layer);
+		}
+	}
+
+	_osd_set_layer_config(sd, layer, lconfig);
+
+	if (layer == WIN_OSD1) {
+		struct osd_osdwin_state *osdwin_state =
+		    &osd->osdwin[OSDWIN_OSD1];
+
+		if ((lconfig->pixfmt != PIXFMT_OSD_ATTR) &&
+		  (cfg->pixfmt == PIXFMT_OSD_ATTR)) {
+			/*
+			 * We just switched OSD1 from attribute mode to normal
+			 * mode, so we must initialize the CLUT select, the
+			 * blend factor, transparency colorkey enable, and
+			 * attenuation enable (DM6446 only) bits in the
+			 * OSDWIN1MD register.
+			 */
+			_osd_set_osd_clut(sd, OSDWIN_OSD1,
+						   osdwin_state->clut);
+			_osd_set_blending_factor(sd, OSDWIN_OSD1,
+							  osdwin_state->blend);
+			if (osdwin_state->colorkey_blending) {
+				_osd_enable_color_key(sd, OSDWIN_OSD1,
+							       osdwin_state->
+							       colorkey,
+							       lconfig->pixfmt);
+			} else
+				_osd_disable_color_key(sd, OSDWIN_OSD1);
+			_osd_set_rec601_attenuation(sd, OSDWIN_OSD1,
+						    osdwin_state->
+						    rec601_attenuation);
+		} else if ((lconfig->pixfmt == PIXFMT_OSD_ATTR) &&
+		  (cfg->pixfmt != PIXFMT_OSD_ATTR)) {
+			/*
+			 * We just switched OSD1 from normal mode to attribute
+			 * mode, so we must initialize the blink enable and
+			 * blink interval bits in the OSDATRMD register.
+			 */
+			_osd_set_blink_attribute(sd, osd->is_blinking,
+							  osd->blink);
+		}
+	}
+
+	/*
+	 * If we just switched to a 1-, 2-, or 4-bits-per-pixel bitmap format
+	 * then configure a default palette map.
+	 */
+	if ((lconfig->pixfmt != cfg->pixfmt) &&
+	  ((lconfig->pixfmt == PIXFMT_1BPP) ||
+	  (lconfig->pixfmt == PIXFMT_2BPP) ||
+	  (lconfig->pixfmt == PIXFMT_4BPP))) {
+		enum osd_win_layer osdwin =
+		    ((layer == WIN_OSD0) ? OSDWIN_OSD0 : OSDWIN_OSD1);
+		struct osd_osdwin_state *osdwin_state =
+		    &osd->osdwin[osdwin];
+		unsigned char clut_index;
+		unsigned char clut_entries = 0;
+
+		switch (lconfig->pixfmt) {
+		case PIXFMT_1BPP:
+			clut_entries = 2;
+			break;
+		case PIXFMT_2BPP:
+			clut_entries = 4;
+			break;
+		case PIXFMT_4BPP:
+			clut_entries = 16;
+			break;
+		default:
+			break;
+		}
+		/*
+		 * The default palette map maps the pixel value to the clut
+		 * index, i.e. pixel value 0 maps to clut entry 0, pixel value
+		 * 1 maps to clut entry 1, etc.
+		 */
+		for (clut_index = 0; clut_index < 16; clut_index++) {
+			osdwin_state->palette_map[clut_index] = clut_index;
+			if (clut_index < clut_entries) {
+				_osd_set_palette_map(sd, osdwin, clut_index,
+						     clut_index,
+						     lconfig->pixfmt);
+			}
+		}
+	}
+
+	*cfg = *lconfig;
+	/* DM6446: configure the RGB888 enable and window selection */
+	if (osd->win[WIN_VID0].lconfig.pixfmt == PIXFMT_RGB888)
+		_osd_enable_vid_rgb888(sd, WIN_VID0);
+	else if (osd->win[WIN_VID1].lconfig.pixfmt == PIXFMT_RGB888)
+		_osd_enable_vid_rgb888(sd, WIN_VID1);
+	else
+		_osd_disable_vid_rgb888(sd);
+
+	if (layer == WIN_VID0) {
+		osd->pingpong =
+		    _osd_dm6446_vid0_pingpong(sd, osd->field_inversion,
+						       win->fb_base_phys,
+						       cfg);
+	}
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+
+	return 0;
+}
+
+static void osd_init_layer(struct osd_state *sd, enum osd_layer layer)
+{
+	struct osd_state *osd = sd;
+	struct osd_window_state *win = &osd->win[layer];
+	enum osd_win_layer osdwin;
+	struct osd_osdwin_state *osdwin_state;
+	struct osd_layer_config *cfg = &win->lconfig;
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	win->is_enabled = 0;
+	_osd_disable_layer(sd, layer);
+
+	win->h_zoom = ZOOM_X1;
+	win->v_zoom = ZOOM_X1;
+	_osd_set_zoom(sd, layer, win->h_zoom, win->v_zoom);
+
+	win->fb_base_phys = 0;
+	_osd_start_layer(sd, layer, win->fb_base_phys, 0);
+
+	cfg->line_length = 0;
+	cfg->xsize = 0;
+	cfg->ysize = 0;
+	cfg->xpos = 0;
+	cfg->ypos = 0;
+	cfg->interlaced = 0;
+	switch (layer) {
+	case WIN_OSD0:
+	case WIN_OSD1:
+		osdwin = (layer == WIN_OSD0) ? OSDWIN_OSD0 : OSDWIN_OSD1;
+		osdwin_state = &osd->osdwin[osdwin];
+		/*
+		 * Other code relies on the fact that OSD windows default to a
+		 * bitmap pixel format when they are deallocated, so don't
+		 * change this default pixel format.
+		 */
+		cfg->pixfmt = PIXFMT_8BPP;
+		_osd_set_layer_config(sd, layer, cfg);
+		osdwin_state->clut = RAM_CLUT;
+		_osd_set_osd_clut(sd, osdwin, osdwin_state->clut);
+		osdwin_state->colorkey_blending = 0;
+		_osd_disable_color_key(sd, osdwin);
+		osdwin_state->blend = OSD_8_VID_0;
+		_osd_set_blending_factor(sd, osdwin, osdwin_state->blend);
+		osdwin_state->rec601_attenuation = 0;
+		_osd_set_rec601_attenuation(sd, osdwin,
+						     osdwin_state->
+						     rec601_attenuation);
+		if (osdwin == OSDWIN_OSD1) {
+			osd->is_blinking = 0;
+			osd->blink = BLINK_X1;
+		}
+		break;
+	case WIN_VID0:
+	case WIN_VID1:
+		cfg->pixfmt = osd->yc_pixfmt;
+		_osd_set_layer_config(sd, layer, cfg);
+		break;
+	}
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+static void osd_release_layer(struct osd_state *sd, enum osd_layer layer)
+{
+	struct osd_state *osd = sd;
+	struct osd_window_state *win = &osd->win[layer];
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	if (!win->is_allocated) {
+		spin_unlock_irqrestore(&osd->lock, flags);
+		return;
+	}
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+	osd_init_layer(sd, layer);
+	spin_lock_irqsave(&osd->lock, flags);
+
+	win->is_allocated = 0;
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+static int osd_request_layer(struct osd_state *sd, enum osd_layer layer)
+{
+	struct osd_state *osd = sd;
+	struct osd_window_state *win = &osd->win[layer];
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	if (win->is_allocated) {
+		spin_unlock_irqrestore(&osd->lock, flags);
+		return -1;
+	}
+	win->is_allocated = 1;
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+
+	return 0;
+}
+
+static void _osd_init(struct osd_state *sd)
+{
+	osd_write(sd, 0, OSD_MODE);
+	osd_write(sd, 0, OSD_VIDWINMD);
+	osd_write(sd, 0, OSD_OSDWIN0MD);
+	osd_write(sd, 0, OSD_OSDWIN1MD);
+	osd_write(sd, 0, OSD_RECTCUR);
+	osd_write(sd, 0, OSD_MISCCTL);
+}
+
+static void osd_set_left_margin(struct osd_state *sd, u32 val)
+{
+	osd_write(sd, val, OSD_BASEPX);
+}
+
+static void osd_set_top_margin(struct osd_state *sd, u32 val)
+{
+	osd_write(sd, val, OSD_BASEPY);
+}
+
+static int osd_initialize(struct osd_state *osd)
+{
+	if (osd == NULL)
+		return -ENODEV;
+	_osd_init(osd);
+
+	/* set default Cb/Cr order */
+	osd->yc_pixfmt = PIXFMT_YCbCrI;
+
+	_osd_set_field_inversion(osd, osd->field_inversion);
+	_osd_set_rom_clut(osd, osd->rom_clut);
+
+	osd_init_layer(osd, WIN_OSD0);
+	osd_init_layer(osd, WIN_VID0);
+	osd_init_layer(osd, WIN_OSD1);
+	osd_init_layer(osd, WIN_VID1);
+
+	return 0;
+}
+
+static const struct vpbe_osd_ops osd_ops = {
+	.initialize = osd_initialize,
+	.request_layer = osd_request_layer,
+	.release_layer = osd_release_layer,
+	.enable_layer = osd_enable_layer,
+	.disable_layer = osd_disable_layer,
+	.set_layer_config = osd_set_layer_config,
+	.get_layer_config = osd_get_layer_config,
+	.start_layer = osd_start_layer,
+	.set_left_margin = osd_set_left_margin,
+	.set_top_margin = osd_set_top_margin,
+};
+
+static int osd_probe(struct platform_device *pdev)
+{
+	struct osd_platform_data *pdata;
+	struct osd_state *osd;
+	struct resource *res;
+	int ret = 0;
+
+	osd = kzalloc(sizeof(struct osd_state), GFP_KERNEL);
+	if (osd == NULL)
+		return -ENOMEM;
+
+	osd->dev = &pdev->dev;
+	pdata = (struct osd_platform_data *)pdev->dev.platform_data;
+	osd->vpbe_type = (enum vpbe_version)pdata->vpbe_type;
+	if (NULL == pdev->dev.platform_data) {
+		dev_err(osd->dev, "No platform data defined for OSD"
+			" sub device\n");
+		ret = -ENOENT;
+		goto free_mem;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(osd->dev, "Unable to get OSD register address map\n");
+		ret = -ENODEV;
+		goto free_mem;
+	}
+	osd->osd_base_phys = res->start;
+	osd->osd_size = res->end - res->start + 1;
+	if (!request_mem_region(osd->osd_base_phys, osd->osd_size,
+				MODULE_NAME)) {
+		dev_err(osd->dev, "Unable to reserve OSD MMIO region\n");
+		ret = -ENODEV;
+		goto free_mem;
+	}
+	osd->osd_base = (unsigned long)ioremap_nocache(res->start,
+							osd->osd_size);
+	if (!osd->osd_base) {
+		dev_err(osd->dev, "Unable to map the OSD region\n");
+		ret = -ENODEV;
+		goto release_mem_region;
+	}
+	spin_lock_init(&osd->lock);
+	osd->ops = osd_ops;
+	platform_set_drvdata(pdev, osd);
+	dev_notice(osd->dev, "OSD sub device probe success\n");
+	return ret;
+
+release_mem_region:
+	release_mem_region(osd->osd_base_phys, osd->osd_size);
+free_mem:
+	kfree(osd);
+	return ret;
+}
+
+static int osd_remove(struct platform_device *pdev)
+{
+	struct osd_state *osd = platform_get_drvdata(pdev);
+
+	iounmap((void *)osd->osd_base);
+	release_mem_region(osd->osd_base_phys, osd->osd_size);
+	kfree(osd);
+	return 0;
+}
+
+static struct platform_driver osd_driver = {
+	.probe		= osd_probe,
+	.remove		= osd_remove,
+	.driver		= {
+		.name	= MODULE_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int osd_init(void)
+{
+	if (platform_driver_register(&osd_driver)) {
+		printk(KERN_ERR "Unable to register davinci osd driver\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static void osd_exit(void)
+{
+	platform_driver_unregister(&osd_driver);
+}
+
+module_init(osd_init);
+module_exit(osd_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("DaVinci OSD Manager Driver");
+MODULE_AUTHOR("Texas Instruments");
diff --git a/drivers/media/video/davinci/vpbe_osd_regs.h b/drivers/media/video/davinci/vpbe_osd_regs.h
new file mode 100644
index 0000000..584520f
--- /dev/null
+++ b/drivers/media/video/davinci/vpbe_osd_regs.h
@@ -0,0 +1,364 @@
+/*
+ * Copyright (C) 2006-2010 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef _VPBE_OSD_REGS_H
+#define _VPBE_OSD_REGS_H
+
+/* VPBE Global Registers */
+#define VPBE_PID				0x0
+#define VPBE_PCR				0x4
+
+/* VPSS CLock Registers */
+#define VPSSCLK_PID				0x00
+#define VPSSCLK_CLKCTRL				0x04
+
+/* VPSS Buffer Logic Registers */
+#define VPSSBL_PID				0x00
+#define VPSSBL_PCR				0x04
+#define VPSSBL_BCR				0x08
+#define VPSSBL_INTSTAT				0x0C
+#define VPSSBL_INTSEL				0x10
+#define VPSSBL_EVTSEL				0x14
+#define VPSSBL_MEMCTRL				0x18
+#define VPSSBL_CCDCMUX				0x1C
+
+/* DM365 ISP5 system configuration */
+#define ISP5_PID				0x0
+#define ISP5_PCCR				0x4
+#define ISP5_BCR				0x8
+#define ISP5_INTSTAT				0xC
+#define ISP5_INTSEL1				0x10
+#define ISP5_INTSEL2				0x14
+#define ISP5_INTSEL3				0x18
+#define ISP5_EVTSEL				0x1c
+#define ISP5_CCDCMUX				0x20
+
+/* VPBE On-Screen Display Subsystem Registers (OSD) */
+#define OSD_MODE				0x00
+#define OSD_VIDWINMD				0x04
+#define OSD_OSDWIN0MD				0x08
+#define OSD_OSDWIN1MD				0x0C
+#define OSD_OSDATRMD				0x0C
+#define OSD_RECTCUR				0x10
+#define OSD_VIDWIN0OFST				0x18
+#define OSD_VIDWIN1OFST				0x1C
+#define OSD_OSDWIN0OFST				0x20
+#define OSD_OSDWIN1OFST				0x24
+#define OSD_VIDWINADH				0x28
+#define OSD_VIDWIN0ADL				0x2C
+#define OSD_VIDWIN0ADR				0x2C
+#define OSD_VIDWIN1ADL				0x30
+#define OSD_VIDWIN1ADR				0x30
+#define OSD_OSDWINADH				0x34
+#define OSD_OSDWIN0ADL				0x38
+#define OSD_OSDWIN0ADR				0x38
+#define OSD_OSDWIN1ADL				0x3C
+#define OSD_OSDWIN1ADR				0x3C
+#define OSD_BASEPX				0x40
+#define OSD_BASEPY				0x44
+#define OSD_VIDWIN0XP				0x48
+#define OSD_VIDWIN0YP				0x4C
+#define OSD_VIDWIN0XL				0x50
+#define OSD_VIDWIN0YL				0x54
+#define OSD_VIDWIN1XP				0x58
+#define OSD_VIDWIN1YP				0x5C
+#define OSD_VIDWIN1XL				0x60
+#define OSD_VIDWIN1YL				0x64
+#define OSD_OSDWIN0XP				0x68
+#define OSD_OSDWIN0YP				0x6C
+#define OSD_OSDWIN0XL				0x70
+#define OSD_OSDWIN0YL				0x74
+#define OSD_OSDWIN1XP				0x78
+#define OSD_OSDWIN1YP				0x7C
+#define OSD_OSDWIN1XL				0x80
+#define OSD_OSDWIN1YL				0x84
+#define OSD_CURXP				0x88
+#define OSD_CURYP				0x8C
+#define OSD_CURXL				0x90
+#define OSD_CURYL				0x94
+#define OSD_W0BMP01				0xA0
+#define OSD_W0BMP23				0xA4
+#define OSD_W0BMP45				0xA8
+#define OSD_W0BMP67				0xAC
+#define OSD_W0BMP89				0xB0
+#define OSD_W0BMPAB				0xB4
+#define OSD_W0BMPCD				0xB8
+#define OSD_W0BMPEF				0xBC
+#define OSD_W1BMP01				0xC0
+#define OSD_W1BMP23				0xC4
+#define OSD_W1BMP45				0xC8
+#define OSD_W1BMP67				0xCC
+#define OSD_W1BMP89				0xD0
+#define OSD_W1BMPAB				0xD4
+#define OSD_W1BMPCD				0xD8
+#define OSD_W1BMPEF				0xDC
+#define OSD_VBNDRY				0xE0
+#define OSD_EXTMODE				0xE4
+#define OSD_MISCCTL				0xE8
+#define OSD_CLUTRAMYCB				0xEC
+#define OSD_CLUTRAMCR				0xF0
+#define OSD_TRANSPVAL				0xF4
+#define OSD_TRANSPVALL				0xF4
+#define OSD_TRANSPVALU				0xF8
+#define OSD_TRANSPBMPIDX			0xFC
+#define OSD_PPVWIN0ADR				0xFC
+
+/* bit definitions */
+#define VPBE_PCR_VENC_DIV			(1 << 1)
+#define VPBE_PCR_CLK_OFF			(1 << 0)
+
+#define VPSSBL_INTSTAT_HSSIINT			(1 << 14)
+#define VPSSBL_INTSTAT_CFALDINT			(1 << 13)
+#define VPSSBL_INTSTAT_IPIPE_INT5		(1 << 12)
+#define VPSSBL_INTSTAT_IPIPE_INT4		(1 << 11)
+#define VPSSBL_INTSTAT_IPIPE_INT3		(1 << 10)
+#define VPSSBL_INTSTAT_IPIPE_INT2		(1 << 9)
+#define VPSSBL_INTSTAT_IPIPE_INT1		(1 << 8)
+#define VPSSBL_INTSTAT_IPIPE_INT0		(1 << 7)
+#define VPSSBL_INTSTAT_IPIPEIFINT		(1 << 6)
+#define VPSSBL_INTSTAT_OSDINT			(1 << 5)
+#define VPSSBL_INTSTAT_VENCINT			(1 << 4)
+#define VPSSBL_INTSTAT_H3AINT			(1 << 3)
+#define VPSSBL_INTSTAT_CCDC_VDINT2		(1 << 2)
+#define VPSSBL_INTSTAT_CCDC_VDINT1		(1 << 1)
+#define VPSSBL_INTSTAT_CCDC_VDINT0		(1 << 0)
+
+/* DM365 ISP5 bit definitions */
+#define ISP5_INTSTAT_VENCINT			(1 << 21)
+#define ISP5_INTSTAT_OSDINT			(1 << 20)
+
+/* VMOD TVTYP options for HDMD=0 */
+#define SDTV_NTSC				0
+#define SDTV_PAL				1
+/* VMOD TVTYP options for HDMD=1 */
+#define HDTV_525P				0
+#define HDTV_625P				1
+#define HDTV_1080I				2
+#define HDTV_720P				3
+
+#define OSD_MODE_CS				(1 << 15)
+#define OSD_MODE_OVRSZ				(1 << 14)
+#define OSD_MODE_OHRSZ				(1 << 13)
+#define OSD_MODE_EF				(1 << 12)
+#define OSD_MODE_VVRSZ				(1 << 11)
+#define OSD_MODE_VHRSZ				(1 << 10)
+#define OSD_MODE_FSINV				(1 << 9)
+#define OSD_MODE_BCLUT				(1 << 8)
+#define OSD_MODE_CABG_SHIFT			0
+#define OSD_MODE_CABG				(0xff << 0)
+
+#define OSD_VIDWINMD_VFINV			(1 << 15)
+#define OSD_VIDWINMD_V1EFC			(1 << 14)
+#define OSD_VIDWINMD_VHZ1_SHIFT			12
+#define OSD_VIDWINMD_VHZ1			(3 << 12)
+#define OSD_VIDWINMD_VVZ1_SHIFT			10
+#define OSD_VIDWINMD_VVZ1			(3 << 10)
+#define OSD_VIDWINMD_VFF1			(1 << 9)
+#define OSD_VIDWINMD_ACT1			(1 << 8)
+#define OSD_VIDWINMD_V0EFC			(1 << 6)
+#define OSD_VIDWINMD_VHZ0_SHIFT			4
+#define OSD_VIDWINMD_VHZ0			(3 << 4)
+#define OSD_VIDWINMD_VVZ0_SHIFT			2
+#define OSD_VIDWINMD_VVZ0			(3 << 2)
+#define OSD_VIDWINMD_VFF0			(1 << 1)
+#define OSD_VIDWINMD_ACT0			(1 << 0)
+
+#define OSD_OSDWIN0MD_ATN0E			(1 << 14)
+#define OSD_OSDWIN0MD_RGB0E			(1 << 13)
+#define OSD_OSDWIN0MD_BMP0MD_SHIFT		13
+#define OSD_OSDWIN0MD_BMP0MD			(3 << 13)
+#define OSD_OSDWIN0MD_CLUTS0			(1 << 12)
+#define OSD_OSDWIN0MD_OHZ0_SHIFT		10
+#define OSD_OSDWIN0MD_OHZ0			(3 << 10)
+#define OSD_OSDWIN0MD_OVZ0_SHIFT		8
+#define OSD_OSDWIN0MD_OVZ0			(3 << 8)
+#define OSD_OSDWIN0MD_BMW0_SHIFT		6
+#define OSD_OSDWIN0MD_BMW0			(3 << 6)
+#define OSD_OSDWIN0MD_BLND0_SHIFT		3
+#define OSD_OSDWIN0MD_BLND0			(7 << 3)
+#define OSD_OSDWIN0MD_TE0			(1 << 2)
+#define OSD_OSDWIN0MD_OFF0			(1 << 1)
+#define OSD_OSDWIN0MD_OACT0			(1 << 0)
+
+#define OSD_OSDWIN1MD_OASW			(1 << 15)
+#define OSD_OSDWIN1MD_ATN1E			(1 << 14)
+#define OSD_OSDWIN1MD_RGB1E			(1 << 13)
+#define OSD_OSDWIN1MD_BMP1MD_SHIFT		13
+#define OSD_OSDWIN1MD_BMP1MD			(3 << 13)
+#define OSD_OSDWIN1MD_CLUTS1			(1 << 12)
+#define OSD_OSDWIN1MD_OHZ1_SHIFT		10
+#define OSD_OSDWIN1MD_OHZ1			(3 << 10)
+#define OSD_OSDWIN1MD_OVZ1_SHIFT		8
+#define OSD_OSDWIN1MD_OVZ1			(3 << 8)
+#define OSD_OSDWIN1MD_BMW1_SHIFT		6
+#define OSD_OSDWIN1MD_BMW1			(3 << 6)
+#define OSD_OSDWIN1MD_BLND1_SHIFT		3
+#define OSD_OSDWIN1MD_BLND1			(7 << 3)
+#define OSD_OSDWIN1MD_TE1			(1 << 2)
+#define OSD_OSDWIN1MD_OFF1			(1 << 1)
+#define OSD_OSDWIN1MD_OACT1			(1 << 0)
+
+#define OSD_OSDATRMD_OASW			(1 << 15)
+#define OSD_OSDATRMD_OHZA_SHIFT			10
+#define OSD_OSDATRMD_OHZA			(3 << 10)
+#define OSD_OSDATRMD_OVZA_SHIFT			8
+#define OSD_OSDATRMD_OVZA			(3 << 8)
+#define OSD_OSDATRMD_BLNKINT_SHIFT		6
+#define OSD_OSDATRMD_BLNKINT			(3 << 6)
+#define OSD_OSDATRMD_OFFA			(1 << 1)
+#define OSD_OSDATRMD_BLNK			(1 << 0)
+
+#define OSD_RECTCUR_RCAD_SHIFT			8
+#define OSD_RECTCUR_RCAD			(0xff << 8)
+#define OSD_RECTCUR_CLUTSR			(1 << 7)
+#define OSD_RECTCUR_RCHW_SHIFT			4
+#define OSD_RECTCUR_RCHW			(7 << 4)
+#define OSD_RECTCUR_RCVW_SHIFT			1
+#define OSD_RECTCUR_RCVW			(7 << 1)
+#define OSD_RECTCUR_RCACT			(1 << 0)
+
+#define OSD_VIDWIN0OFST_V0LO			(0x1ff << 0)
+
+#define OSD_VIDWIN1OFST_V1LO			(0x1ff << 0)
+
+#define OSD_OSDWIN0OFST_O0LO			(0x1ff << 0)
+
+#define OSD_OSDWIN1OFST_O1LO			(0x1ff << 0)
+
+#define OSD_WINOFST_AH_SHIFT			9
+
+#define OSD_VIDWIN0OFST_V0AH			(0xf << 9)
+#define OSD_VIDWIN1OFST_V1AH			(0xf << 9)
+#define OSD_OSDWIN0OFST_O0AH			(0xf << 9)
+#define OSD_OSDWIN1OFST_O1AH			(0xf << 9)
+
+#define OSD_VIDWINADH_V1AH_SHIFT		8
+#define OSD_VIDWINADH_V1AH			(0x7f << 8)
+#define OSD_VIDWINADH_V0AH_SHIFT		0
+#define OSD_VIDWINADH_V0AH			(0x7f << 0)
+
+#define OSD_VIDWIN0ADL_V0AL			(0xffff << 0)
+
+#define OSD_VIDWIN1ADL_V1AL			(0xffff << 0)
+
+#define OSD_OSDWINADH_O1AH_SHIFT		8
+#define OSD_OSDWINADH_O1AH			(0x7f << 8)
+#define OSD_OSDWINADH_O0AH_SHIFT		0
+#define OSD_OSDWINADH_O0AH			(0x7f << 0)
+
+#define OSD_OSDWIN0ADL_O0AL			(0xffff << 0)
+
+#define OSD_OSDWIN1ADL_O1AL			(0xffff << 0)
+
+#define OSD_BASEPX_BPX				(0x3ff << 0)
+
+#define OSD_BASEPY_BPY				(0x1ff << 0)
+
+#define OSD_VIDWIN0XP_V0X			(0x7ff << 0)
+
+#define OSD_VIDWIN0YP_V0Y			(0x7ff << 0)
+
+#define OSD_VIDWIN0XL_V0W			(0x7ff << 0)
+
+#define OSD_VIDWIN0YL_V0H			(0x7ff << 0)
+
+#define OSD_VIDWIN1XP_V1X			(0x7ff << 0)
+
+#define OSD_VIDWIN1YP_V1Y			(0x7ff << 0)
+
+#define OSD_VIDWIN1XL_V1W			(0x7ff << 0)
+
+#define OSD_VIDWIN1YL_V1H			(0x7ff << 0)
+
+#define OSD_OSDWIN0XP_W0X			(0x7ff << 0)
+
+#define OSD_OSDWIN0YP_W0Y			(0x7ff << 0)
+
+#define OSD_OSDWIN0XL_W0W			(0x7ff << 0)
+
+#define OSD_OSDWIN0YL_W0H			(0x7ff << 0)
+
+#define OSD_OSDWIN1XP_W1X			(0x7ff << 0)
+
+#define OSD_OSDWIN1YP_W1Y			(0x7ff << 0)
+
+#define OSD_OSDWIN1XL_W1W			(0x7ff << 0)
+
+#define OSD_OSDWIN1YL_W1H			(0x7ff << 0)
+
+#define OSD_CURXP_RCSX				(0x7ff << 0)
+
+#define OSD_CURYP_RCSY				(0x7ff << 0)
+
+#define OSD_CURXL_RCSW				(0x7ff << 0)
+
+#define OSD_CURYL_RCSH				(0x7ff << 0)
+
+#define OSD_EXTMODE_EXPMDSEL			(1 << 15)
+#define OSD_EXTMODE_SCRNHEXP_SHIFT		13
+#define OSD_EXTMODE_SCRNHEXP			(3 << 13)
+#define OSD_EXTMODE_SCRNVEXP			(1 << 12)
+#define OSD_EXTMODE_OSD1BLDCHR			(1 << 11)
+#define OSD_EXTMODE_OSD0BLDCHR			(1 << 10)
+#define OSD_EXTMODE_ATNOSD1EN			(1 << 9)
+#define OSD_EXTMODE_ATNOSD0EN			(1 << 8)
+#define OSD_EXTMODE_OSDHRSZ15			(1 << 7)
+#define OSD_EXTMODE_VIDHRSZ15			(1 << 6)
+#define OSD_EXTMODE_ZMFILV1HEN			(1 << 5)
+#define OSD_EXTMODE_ZMFILV1VEN			(1 << 4)
+#define OSD_EXTMODE_ZMFILV0HEN			(1 << 3)
+#define OSD_EXTMODE_ZMFILV0VEN			(1 << 2)
+#define OSD_EXTMODE_EXPFILHEN			(1 << 1)
+#define OSD_EXTMODE_EXPFILVEN			(1 << 0)
+
+#define OSD_MISCCTL_BLDSEL			(1 << 15)
+#define OSD_MISCCTL_S420D			(1 << 14)
+#define OSD_MISCCTL_BMAPT			(1 << 13)
+#define OSD_MISCCTL_DM365M			(1 << 12)
+#define OSD_MISCCTL_RGBEN			(1 << 7)
+#define OSD_MISCCTL_RGBWIN			(1 << 6)
+#define OSD_MISCCTL_DMANG			(1 << 6)
+#define OSD_MISCCTL_TMON			(1 << 5)
+#define OSD_MISCCTL_RSEL			(1 << 4)
+#define OSD_MISCCTL_CPBSY			(1 << 3)
+#define OSD_MISCCTL_PPSW			(1 << 2)
+#define OSD_MISCCTL_PPRV			(1 << 1)
+
+#define OSD_CLUTRAMYCB_Y_SHIFT			8
+#define OSD_CLUTRAMYCB_Y			(0xff << 8)
+#define OSD_CLUTRAMYCB_CB_SHIFT			0
+#define OSD_CLUTRAMYCB_CB			(0xff << 0)
+
+#define OSD_CLUTRAMCR_CR_SHIFT			8
+#define OSD_CLUTRAMCR_CR			(0xff << 8)
+#define OSD_CLUTRAMCR_CADDR_SHIFT		0
+#define OSD_CLUTRAMCR_CADDR			(0xff << 0)
+
+#define OSD_TRANSPVAL_RGBTRANS			(0xffff << 0)
+
+#define OSD_TRANSPVALL_RGBL			(0xffff << 0)
+
+#define OSD_TRANSPVALU_Y_SHIFT			8
+#define OSD_TRANSPVALU_Y			(0xff << 8)
+#define OSD_TRANSPVALU_RGBU_SHIFT		0
+#define OSD_TRANSPVALU_RGBU			(0xff << 0)
+
+#define OSD_TRANSPBMPIDX_BMP1_SHIFT		8
+#define OSD_TRANSPBMPIDX_BMP1			(0xff << 8)
+#define OSD_TRANSPBMPIDX_BMP0_SHIFT		0
+#define OSD_TRANSPBMPIDX_BMP0			0xff
+
+#endif				/* _DAVINCI_VPBE_H_ */
diff --git a/include/media/davinci/vpbe_osd.h b/include/media/davinci/vpbe_osd.h
new file mode 100644
index 0000000..d7e397a
--- /dev/null
+++ b/include/media/davinci/vpbe_osd.h
@@ -0,0 +1,394 @@
+/*
+ * Copyright (C) 2007-2009 Texas Instruments Inc
+ * Copyright (C) 2007 MontaVista Software, Inc.
+ *
+ * Andy Lowe (alowe@mvista.com), MontaVista Software
+ * - Initial version
+ * Murali Karicheri (mkaricheri@gmail.com), Texas Instruments Ltd.
+ * - ported to sub device interface
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation version 2..
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
+ */
+#ifndef _OSD_H
+#define _OSD_H
+
+#include <media/davinci/vpbe_types.h>
+
+#define VPBE_OSD_SUBDEV_NAME "vpbe-osd"
+
+/**
+ * enum osd_layer
+ * @WIN_OSD0: On-Screen Display Window 0
+ * @WIN_VID0: Video Window 0
+ * @WIN_OSD1: On-Screen Display Window 1
+ * @WIN_VID1: Video Window 1
+ *
+ * Description:
+ * An enumeration of the osd display layers.
+ */
+enum osd_layer {
+	WIN_OSD0,
+	WIN_VID0,
+	WIN_OSD1,
+	WIN_VID1,
+};
+
+/**
+ * enum osd_win_layer
+ * @OSDWIN_OSD0: On-Screen Display Window 0
+ * @OSDWIN_OSD1: On-Screen Display Window 1
+ *
+ * Description:
+ * An enumeration of the OSD Window layers.
+ */
+enum osd_win_layer {
+	OSDWIN_OSD0,
+	OSDWIN_OSD1,
+};
+
+/**
+ * enum osd_pix_format
+ * @PIXFMT_1BPP: 1-bit-per-pixel bitmap
+ * @PIXFMT_2BPP: 2-bits-per-pixel bitmap
+ * @PIXFMT_4BPP: 4-bits-per-pixel bitmap
+ * @PIXFMT_8BPP: 8-bits-per-pixel bitmap
+ * @PIXFMT_RGB565: 16-bits-per-pixel RGB565
+ * @PIXFMT_YCbCrI: YUV 4:2:2
+ * @PIXFMT_RGB888: 24-bits-per-pixel RGB888
+ * @PIXFMT_YCrCbI: YUV 4:2:2 with chroma swap
+ * @PIXFMT_NV12: YUV 4:2:0 planar
+ * @PIXFMT_OSD_ATTR: OSD Attribute Window pixel format (4bpp)
+ *
+ * Description:
+ * An enumeration of the DaVinci pixel formats.
+ */
+enum osd_pix_format {
+	PIXFMT_1BPP = 0,
+	PIXFMT_2BPP,
+	PIXFMT_4BPP,
+	PIXFMT_8BPP,
+	PIXFMT_RGB565,
+	PIXFMT_YCbCrI,
+	PIXFMT_RGB888,
+	PIXFMT_YCrCbI,
+	PIXFMT_NV12,
+	PIXFMT_OSD_ATTR,
+};
+
+/**
+ * enum osd_h_exp_ratio
+ * @H_EXP_OFF: no expansion (1/1)
+ * @H_EXP_9_OVER_8: 9/8 expansion ratio
+ * @H_EXP_3_OVER_2: 3/2 expansion ratio
+ *
+ * Description:
+ * An enumeration of the available horizontal expansion ratios.
+ */
+enum osd_h_exp_ratio {
+	H_EXP_OFF,
+	H_EXP_9_OVER_8,
+	H_EXP_3_OVER_2,
+};
+
+/**
+ * enum osd_v_exp_ratio
+ * @V_EXP_OFF: no expansion (1/1)
+ * @V_EXP_6_OVER_5: 6/5 expansion ratio
+ *
+ * Description:
+ * An enumeration of the available vertical expansion ratios.
+ */
+enum osd_v_exp_ratio {
+	V_EXP_OFF,
+	V_EXP_6_OVER_5,
+};
+
+/**
+ * enum osd_zoom_factor
+ * @ZOOM_X1: no zoom (x1)
+ * @ZOOM_X2: x2 zoom
+ * @ZOOM_X4: x4 zoom
+ *
+ * Description:
+ * An enumeration of the available zoom factors.
+ */
+enum osd_zoom_factor {
+	ZOOM_X1,
+	ZOOM_X2,
+	ZOOM_X4,
+};
+
+/**
+ * enum osd_clut
+ * @ROM_CLUT: ROM CLUT
+ * @RAM_CLUT: RAM CLUT
+ *
+ * Description:
+ * An enumeration of the available Color Lookup Tables (CLUTs).
+ */
+enum osd_clut {
+	ROM_CLUT,
+	RAM_CLUT,
+};
+
+/**
+ * enum osd_rom_clut
+ * @ROM_CLUT0: Macintosh CLUT
+ * @ROM_CLUT1: CLUT from DM270 and prior devices
+ *
+ * Description:
+ * An enumeration of the ROM Color Lookup Table (CLUT) options.
+ */
+enum osd_rom_clut {
+	ROM_CLUT0,
+	ROM_CLUT1,
+};
+
+/**
+ * enum osd_blending_factor
+ * @OSD_0_VID_8: OSD pixels are fully transparent
+ * @OSD_1_VID_7: OSD pixels contribute 1/8, video pixels contribute 7/8
+ * @OSD_2_VID_6: OSD pixels contribute 2/8, video pixels contribute 6/8
+ * @OSD_3_VID_5: OSD pixels contribute 3/8, video pixels contribute 5/8
+ * @OSD_4_VID_4: OSD pixels contribute 4/8, video pixels contribute 4/8
+ * @OSD_5_VID_3: OSD pixels contribute 5/8, video pixels contribute 3/8
+ * @OSD_6_VID_2: OSD pixels contribute 6/8, video pixels contribute 2/8
+ * @OSD_8_VID_0: OSD pixels are fully opaque
+ *
+ * Description:
+ * An enumeration of the DaVinci pixel blending factor options.
+ */
+enum osd_blending_factor {
+	OSD_0_VID_8,
+	OSD_1_VID_7,
+	OSD_2_VID_6,
+	OSD_3_VID_5,
+	OSD_4_VID_4,
+	OSD_5_VID_3,
+	OSD_6_VID_2,
+	OSD_8_VID_0,
+};
+
+/**
+ * enum osd_blink_interval
+ * @BLINK_X1: blink interval is 1 vertical refresh cycle
+ * @BLINK_X2: blink interval is 2 vertical refresh cycles
+ * @BLINK_X3: blink interval is 3 vertical refresh cycles
+ * @BLINK_X4: blink interval is 4 vertical refresh cycles
+ *
+ * Description:
+ * An enumeration of the DaVinci pixel blinking interval options.
+ */
+enum osd_blink_interval {
+	BLINK_X1,
+	BLINK_X2,
+	BLINK_X3,
+	BLINK_X4,
+};
+
+/**
+ * enum osd_cursor_h_width
+ * @H_WIDTH_1: horizontal line width is 1 pixel
+ * @H_WIDTH_4: horizontal line width is 4 pixels
+ * @H_WIDTH_8: horizontal line width is 8 pixels
+ * @H_WIDTH_12: horizontal line width is 12 pixels
+ * @H_WIDTH_16: horizontal line width is 16 pixels
+ * @H_WIDTH_20: horizontal line width is 20 pixels
+ * @H_WIDTH_24: horizontal line width is 24 pixels
+ * @H_WIDTH_28: horizontal line width is 28 pixels
+ */
+enum osd_cursor_h_width {
+	H_WIDTH_1,
+	H_WIDTH_4,
+	H_WIDTH_8,
+	H_WIDTH_12,
+	H_WIDTH_16,
+	H_WIDTH_20,
+	H_WIDTH_24,
+	H_WIDTH_28,
+};
+
+/**
+ * enum davinci_cursor_v_width
+ * @V_WIDTH_1: vertical line width is 1 line
+ * @V_WIDTH_2: vertical line width is 2 lines
+ * @V_WIDTH_4: vertical line width is 4 lines
+ * @V_WIDTH_6: vertical line width is 6 lines
+ * @V_WIDTH_8: vertical line width is 8 lines
+ * @V_WIDTH_10: vertical line width is 10 lines
+ * @V_WIDTH_12: vertical line width is 12 lines
+ * @V_WIDTH_14: vertical line width is 14 lines
+ */
+enum osd_cursor_v_width {
+	V_WIDTH_1,
+	V_WIDTH_2,
+	V_WIDTH_4,
+	V_WIDTH_6,
+	V_WIDTH_8,
+	V_WIDTH_10,
+	V_WIDTH_12,
+	V_WIDTH_14,
+};
+
+/**
+ * struct osd_cursor_config
+ * @xsize: horizontal size in pixels
+ * @ysize: vertical size in lines
+ * @xpos: horizontal offset in pixels from the left edge of the display
+ * @ypos: vertical offset in lines from the top of the display
+ * @interlaced: Non-zero if the display is interlaced, or zero otherwise
+ * @h_width: horizontal line width
+ * @v_width: vertical line width
+ * @clut: the CLUT selector (ROM or RAM) for the cursor color
+ * @clut_index: an index into the CLUT for the cursor color
+ *
+ * Description:
+ * A structure describing the configuration parameters of the hardware
+ * rectangular cursor.
+ */
+struct osd_cursor_config {
+	unsigned xsize;
+	unsigned ysize;
+	unsigned xpos;
+	unsigned ypos;
+	int interlaced;
+	enum osd_cursor_h_width h_width;
+	enum osd_cursor_v_width v_width;
+	enum osd_clut clut;
+	unsigned char clut_index;
+};
+
+/**
+ * struct osd_layer_config
+ * @pixfmt: pixel format
+ * @line_length: offset in bytes between start of each line in memory
+ * @xsize: number of horizontal pixels displayed per line
+ * @ysize: number of lines displayed
+ * @xpos: horizontal offset in pixels from the left edge of the display
+ * @ypos: vertical offset in lines from the top of the display
+ * @interlaced: Non-zero if the display is interlaced, or zero otherwise
+ *
+ * Description:
+ * A structure describing the configuration parameters of an On-Screen Display
+ * (OSD) or video layer related to how the image is stored in memory.
+ * @line_length must be a multiple of the cache line size (32 bytes).
+ */
+struct osd_layer_config {
+	enum osd_pix_format pixfmt;
+	unsigned line_length;
+	unsigned xsize;
+	unsigned ysize;
+	unsigned xpos;
+	unsigned ypos;
+	int interlaced;
+};
+
+/* parameters that apply on a per-window (OSD or video) basis */
+struct osd_window_state {
+	int is_allocated;
+	int is_enabled;
+	unsigned long fb_base_phys;
+	enum osd_zoom_factor h_zoom;
+	enum osd_zoom_factor v_zoom;
+	struct osd_layer_config lconfig;
+};
+
+/* parameters that apply on a per-OSD-window basis */
+struct osd_osdwin_state {
+	enum osd_clut clut;
+	enum osd_blending_factor blend;
+	int colorkey_blending;
+	unsigned colorkey;
+	int rec601_attenuation;
+	/* index is pixel value */
+	unsigned char palette_map[16];
+};
+
+/* hardware rectangular cursor parameters */
+struct osd_cursor_state {
+	int is_enabled;
+	struct osd_cursor_config config;
+};
+
+struct osd_state;
+
+struct vpbe_osd_ops {
+	int (*initialize)(struct osd_state *sd);
+	int (*request_layer)(struct osd_state *sd, enum osd_layer layer);
+	void (*release_layer)(struct osd_state *sd, enum osd_layer layer);
+	int (*enable_layer)(struct osd_state *sd, enum osd_layer layer,
+			    int otherwin);
+	void (*disable_layer)(struct osd_state *sd, enum osd_layer layer);
+	int (*set_layer_config)(struct osd_state *sd, enum osd_layer layer,
+				struct osd_layer_config *lconfig);
+	void (*get_layer_config)(struct osd_state *sd, enum osd_layer layer,
+				 struct osd_layer_config *lconfig);
+	void (*start_layer)(struct osd_state *sd, enum osd_layer layer,
+			    unsigned long fb_base_phys,
+			    unsigned long cbcr_ofst);
+	void (*set_left_margin)(struct osd_state *sd, u32 val);
+	void (*set_top_margin)(struct osd_state *sd, u32 val);
+	void (*set_interpolation_filter)(struct osd_state *sd, int filter);
+	int (*set_vid_expansion)(struct osd_state *sd,
+					enum osd_h_exp_ratio h_exp,
+					enum osd_v_exp_ratio v_exp);
+	void (*get_vid_expansion)(struct osd_state *sd,
+					enum osd_h_exp_ratio *h_exp,
+					enum osd_v_exp_ratio *v_exp);
+	void (*set_zoom)(struct osd_state *sd, enum osd_layer layer,
+				enum osd_zoom_factor h_zoom,
+				enum osd_zoom_factor v_zoom);
+};
+
+struct osd_state {
+	enum vpbe_version vpbe_type;
+	spinlock_t lock;
+	struct device *dev;
+	dma_addr_t osd_base_phys;
+	unsigned long osd_base;
+	unsigned long osd_size;
+	/* 1-->the isr will toggle the VID0 ping-pong buffer */
+	int pingpong;
+	int interpolation_filter;
+	int field_inversion;
+	enum osd_h_exp_ratio osd_h_exp;
+	enum osd_v_exp_ratio osd_v_exp;
+	enum osd_h_exp_ratio vid_h_exp;
+	enum osd_v_exp_ratio vid_v_exp;
+	enum osd_clut backg_clut;
+	unsigned backg_clut_index;
+	enum osd_rom_clut rom_clut;
+	int is_blinking;
+	/* attribute window blinking enabled */
+	enum osd_blink_interval blink;
+	/* YCbCrI or YCrCbI */
+	enum osd_pix_format yc_pixfmt;
+	/* columns are Y, Cb, Cr */
+	unsigned char clut_ram[256][3];
+	struct osd_cursor_state cursor;
+	/* OSD0, VID0, OSD1, VID1 */
+	struct osd_window_state win[4];
+	/* OSD0, OSD1 */
+	struct osd_osdwin_state osdwin[2];
+	/* OSD device Operations */
+	struct vpbe_osd_ops ops;
+};
+
+struct osd_platform_data {
+	enum vpbe_version vpbe_type;
+	int  field_inv_wa_enable;
+};
+
+#endif
-- 
1.6.2.4

