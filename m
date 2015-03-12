Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48952 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbbCLJ66 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 05:58:58 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: dri-devel@lists.freedesktop.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: David Airlie <airlied@linux.ie>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Boris Brezillion <boris.brezillon@free-electrons.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Emil Renner Berthing <kernel@esmil.dk>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 07/10] drm/imx: consolidate bus format variable names
Date: Thu, 12 Mar 2015 10:58:13 +0100
Message-Id: <1426154296-30665-8-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1426154296-30665-1-git-send-email-p.zabel@pengutronix.de>
References: <1426154296-30665-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch consolidates the different interface_pix_fmt, pixel_fmt, pix_fmt,
and pixfmt variables to a common name "bus_format" wherever they describe the
pixel format on the bus between display controller and encoder hardware.
At the same time, it renames imx_drm_panel_format to imx_drm_set_bus_format.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 - Also rename pixel_fmt parameter to ipu_dc_init_sync to bus_format
---
 drivers/gpu/drm/imx/dw_hdmi-imx.c      |  2 +-
 drivers/gpu/drm/imx/imx-drm-core.c     | 14 +++++++-------
 drivers/gpu/drm/imx/imx-drm.h          | 10 +++++-----
 drivers/gpu/drm/imx/imx-ldb.c          | 10 +++++-----
 drivers/gpu/drm/imx/imx-tve.c          |  6 +++---
 drivers/gpu/drm/imx/ipuv3-crtc.c       | 13 +++++--------
 drivers/gpu/drm/imx/parallel-display.c | 13 ++++++-------
 drivers/gpu/ipu-v3/ipu-dc.c            |  4 ++--
 include/video/imx-ipu-v3.h             |  2 +-
 9 files changed, 35 insertions(+), 39 deletions(-)

diff --git a/drivers/gpu/drm/imx/dw_hdmi-imx.c b/drivers/gpu/drm/imx/dw_hdmi-imx.c
index 61ef987..1834ac8 100644
--- a/drivers/gpu/drm/imx/dw_hdmi-imx.c
+++ b/drivers/gpu/drm/imx/dw_hdmi-imx.c
@@ -123,7 +123,7 @@ static void dw_hdmi_imx_encoder_commit(struct drm_encoder *encoder)
 
 static void dw_hdmi_imx_encoder_prepare(struct drm_encoder *encoder)
 {
-	imx_drm_panel_format(encoder, MEDIA_BUS_FMT_RGB888_1X24);
+	imx_drm_set_bus_format(encoder, MEDIA_BUS_FMT_RGB888_1X24);
 }
 
 static struct drm_encoder_helper_funcs dw_hdmi_imx_encoder_helper_funcs = {
diff --git a/drivers/gpu/drm/imx/imx-drm-core.c b/drivers/gpu/drm/imx/imx-drm-core.c
index a002f53..c6f2c472 100644
--- a/drivers/gpu/drm/imx/imx-drm-core.c
+++ b/drivers/gpu/drm/imx/imx-drm-core.c
@@ -103,8 +103,8 @@ static struct imx_drm_crtc *imx_drm_find_crtc(struct drm_crtc *crtc)
 	return NULL;
 }
 
-int imx_drm_panel_format_pins(struct drm_encoder *encoder,
-		u32 interface_pix_fmt, int hsync_pin, int vsync_pin)
+int imx_drm_set_bus_format_pins(struct drm_encoder *encoder, u32 bus_format,
+		int hsync_pin, int vsync_pin)
 {
 	struct imx_drm_crtc_helper_funcs *helper;
 	struct imx_drm_crtc *imx_crtc;
@@ -116,16 +116,16 @@ int imx_drm_panel_format_pins(struct drm_encoder *encoder,
 	helper = &imx_crtc->imx_drm_helper_funcs;
 	if (helper->set_interface_pix_fmt)
 		return helper->set_interface_pix_fmt(encoder->crtc,
-				interface_pix_fmt, hsync_pin, vsync_pin);
+					bus_format, hsync_pin, vsync_pin);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(imx_drm_panel_format_pins);
+EXPORT_SYMBOL_GPL(imx_drm_set_bus_format_pins);
 
-int imx_drm_panel_format(struct drm_encoder *encoder, u32 interface_pix_fmt)
+int imx_drm_set_bus_format(struct drm_encoder *encoder, u32 bus_format)
 {
-	return imx_drm_panel_format_pins(encoder, interface_pix_fmt, 2, 3);
+	return imx_drm_set_bus_format_pins(encoder, bus_format, 2, 3);
 }
-EXPORT_SYMBOL_GPL(imx_drm_panel_format);
+EXPORT_SYMBOL_GPL(imx_drm_set_bus_format);
 
 int imx_drm_crtc_vblank_get(struct imx_drm_crtc *imx_drm_crtc)
 {
diff --git a/drivers/gpu/drm/imx/imx-drm.h b/drivers/gpu/drm/imx/imx-drm.h
index 3c559cc..28e776d 100644
--- a/drivers/gpu/drm/imx/imx-drm.h
+++ b/drivers/gpu/drm/imx/imx-drm.h
@@ -18,7 +18,7 @@ struct imx_drm_crtc_helper_funcs {
 	int (*enable_vblank)(struct drm_crtc *crtc);
 	void (*disable_vblank)(struct drm_crtc *crtc);
 	int (*set_interface_pix_fmt)(struct drm_crtc *crtc,
-			u32 pix_fmt, int hsync_pin, int vsync_pin);
+			u32 bus_format, int hsync_pin, int vsync_pin);
 	const struct drm_crtc_helper_funcs *crtc_helper_funcs;
 	const struct drm_crtc_funcs *crtc_funcs;
 };
@@ -40,10 +40,10 @@ void imx_drm_mode_config_init(struct drm_device *drm);
 
 struct drm_gem_cma_object *imx_drm_fb_get_obj(struct drm_framebuffer *fb);
 
-int imx_drm_panel_format_pins(struct drm_encoder *encoder,
-		u32 interface_pix_fmt, int hsync_pin, int vsync_pin);
-int imx_drm_panel_format(struct drm_encoder *encoder,
-		u32 interface_pix_fmt);
+int imx_drm_set_bus_format_pins(struct drm_encoder *encoder,
+		u32 bus_format, int hsync_pin, int vsync_pin);
+int imx_drm_set_bus_format(struct drm_encoder *encoder,
+		u32 bus_format);
 
 int imx_drm_encoder_get_mux_id(struct device_node *node,
 		struct drm_encoder *encoder);
diff --git a/drivers/gpu/drm/imx/imx-ldb.c b/drivers/gpu/drm/imx/imx-ldb.c
index f9ec17a..cd062b1 100644
--- a/drivers/gpu/drm/imx/imx-ldb.c
+++ b/drivers/gpu/drm/imx/imx-ldb.c
@@ -163,24 +163,24 @@ static void imx_ldb_encoder_prepare(struct drm_encoder *encoder)
 {
 	struct imx_ldb_channel *imx_ldb_ch = enc_to_imx_ldb_ch(encoder);
 	struct imx_ldb *ldb = imx_ldb_ch->ldb;
-	u32 pixel_fmt;
+	u32 bus_format;
 
 	switch (imx_ldb_ch->chno) {
 	case 0:
-		pixel_fmt = (ldb->ldb_ctrl & LDB_DATA_WIDTH_CH0_24) ?
+		bus_format = (ldb->ldb_ctrl & LDB_DATA_WIDTH_CH0_24) ?
 			MEDIA_BUS_FMT_RGB888_1X24 : MEDIA_BUS_FMT_RGB666_1X18;
 		break;
 	case 1:
-		pixel_fmt = (ldb->ldb_ctrl & LDB_DATA_WIDTH_CH1_24) ?
+		bus_format = (ldb->ldb_ctrl & LDB_DATA_WIDTH_CH1_24) ?
 			MEDIA_BUS_FMT_RGB888_1X24 : MEDIA_BUS_FMT_RGB666_1X18;
 		break;
 	default:
 		dev_err(ldb->dev, "unable to config di%d panel format\n",
 			imx_ldb_ch->chno);
-		pixel_fmt = MEDIA_BUS_FMT_RGB888_1X24;
+		bus_format = MEDIA_BUS_FMT_RGB888_1X24;
 	}
 
-	imx_drm_panel_format(encoder, pixel_fmt);
+	imx_drm_set_bus_format(encoder, bus_format);
 }
 
 static void imx_ldb_encoder_commit(struct drm_encoder *encoder)
diff --git a/drivers/gpu/drm/imx/imx-tve.c b/drivers/gpu/drm/imx/imx-tve.c
index bcdcb1b..214ecee 100644
--- a/drivers/gpu/drm/imx/imx-tve.c
+++ b/drivers/gpu/drm/imx/imx-tve.c
@@ -301,11 +301,11 @@ static void imx_tve_encoder_prepare(struct drm_encoder *encoder)
 
 	switch (tve->mode) {
 	case TVE_MODE_VGA:
-		imx_drm_panel_format_pins(encoder, MEDIA_BUS_FMT_YUV8_1X24,
-				tve->hsync_pin, tve->vsync_pin);
+		imx_drm_set_bus_format_pins(encoder, MEDIA_BUS_FMT_YUV8_1X24,
+					    tve->hsync_pin, tve->vsync_pin);
 		break;
 	case TVE_MODE_TVOUT:
-		imx_drm_panel_format(encoder, MEDIA_BUS_FMT_YUV8_1X24);
+		imx_drm_set_bus_format(encoder, MEDIA_BUS_FMT_YUV8_1X24);
 		break;
 	}
 }
diff --git a/drivers/gpu/drm/imx/ipuv3-crtc.c b/drivers/gpu/drm/imx/ipuv3-crtc.c
index 98551e3..24e1b49 100644
--- a/drivers/gpu/drm/imx/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3-crtc.c
@@ -45,7 +45,7 @@ struct ipu_crtc {
 	struct drm_pending_vblank_event *page_flip_event;
 	struct drm_framebuffer	*newfb;
 	int			irq;
-	u32			interface_pix_fmt;
+	u32			bus_format;
 	int			di_hsync_pin;
 	int			di_vsync_pin;
 };
@@ -145,7 +145,6 @@ static int ipu_crtc_mode_set(struct drm_crtc *crtc,
 	struct ipu_crtc *ipu_crtc = to_ipu_crtc(crtc);
 	struct ipu_di_signal_cfg sig_cfg = {};
 	unsigned long encoder_types = 0;
-	u32 out_pixel_fmt;
 	int ret;
 
 	dev_dbg(ipu_crtc->dev, "%s: mode->hdisplay: %d\n", __func__,
@@ -171,11 +170,9 @@ static int ipu_crtc_mode_set(struct drm_crtc *crtc,
 	else
 		sig_cfg.clkflags = 0;
 
-	out_pixel_fmt = ipu_crtc->interface_pix_fmt;
-
 	sig_cfg.enable_pol = 1;
 	sig_cfg.clk_pol = 0;
-	sig_cfg.pixel_fmt = out_pixel_fmt;
+	sig_cfg.bus_format = ipu_crtc->bus_format;
 	sig_cfg.v_to_h_sync = 0;
 	sig_cfg.hsync_pin = ipu_crtc->di_hsync_pin;
 	sig_cfg.vsync_pin = ipu_crtc->di_vsync_pin;
@@ -184,7 +181,7 @@ static int ipu_crtc_mode_set(struct drm_crtc *crtc,
 
 	ret = ipu_dc_init_sync(ipu_crtc->dc, ipu_crtc->di,
 			       mode->flags & DRM_MODE_FLAG_INTERLACE,
-			       out_pixel_fmt, mode->hdisplay);
+			       ipu_crtc->bus_format, mode->hdisplay);
 	if (ret) {
 		dev_err(ipu_crtc->dev,
 				"initializing display controller failed with %d\n",
@@ -291,11 +288,11 @@ static void ipu_disable_vblank(struct drm_crtc *crtc)
 }
 
 static int ipu_set_interface_pix_fmt(struct drm_crtc *crtc,
-		u32 pixfmt, int hsync_pin, int vsync_pin)
+		u32 bus_format, int hsync_pin, int vsync_pin)
 {
 	struct ipu_crtc *ipu_crtc = to_ipu_crtc(crtc);
 
-	ipu_crtc->interface_pix_fmt = pixfmt;
+	ipu_crtc->bus_format = bus_format;
 	ipu_crtc->di_hsync_pin = hsync_pin;
 	ipu_crtc->di_vsync_pin = vsync_pin;
 
diff --git a/drivers/gpu/drm/imx/parallel-display.c b/drivers/gpu/drm/imx/parallel-display.c
index e645fe1..74a9ce4 100644
--- a/drivers/gpu/drm/imx/parallel-display.c
+++ b/drivers/gpu/drm/imx/parallel-display.c
@@ -33,7 +33,7 @@ struct imx_parallel_display {
 	struct device *dev;
 	void *edid;
 	int edid_len;
-	u32 interface_pix_fmt;
+	u32 bus_format;
 	int mode_valid;
 	struct drm_display_mode mode;
 	struct drm_panel *panel;
@@ -118,7 +118,7 @@ static void imx_pd_encoder_prepare(struct drm_encoder *encoder)
 {
 	struct imx_parallel_display *imxpd = enc_to_imxpd(encoder);
 
-	imx_drm_panel_format(encoder, imxpd->interface_pix_fmt);
+	imx_drm_set_bus_format(encoder, imxpd->bus_format);
 }
 
 static void imx_pd_encoder_commit(struct drm_encoder *encoder)
@@ -225,14 +225,13 @@ static int imx_pd_bind(struct device *dev, struct device *master, void *data)
 	ret = of_property_read_string(np, "interface-pix-fmt", &fmt);
 	if (!ret) {
 		if (!strcmp(fmt, "rgb24"))
-			imxpd->interface_pix_fmt = MEDIA_BUS_FMT_RGB888_1X24;
+			imxpd->bus_format = MEDIA_BUS_FMT_RGB888_1X24;
 		else if (!strcmp(fmt, "rgb565"))
-			imxpd->interface_pix_fmt = MEDIA_BUS_FMT_RGB565_1X16;
+			imxpd->bus_format = MEDIA_BUS_FMT_RGB565_1X16;
 		else if (!strcmp(fmt, "bgr666"))
-			imxpd->interface_pix_fmt = MEDIA_BUS_FMT_RGB666_1X18;
+			imxpd->bus_format = MEDIA_BUS_FMT_RGB666_1X18;
 		else if (!strcmp(fmt, "lvds666"))
-			imxpd->interface_pix_fmt =
-					MEDIA_BUS_FMT_RGB666_1X24_CPADHI;
+			imxpd->bus_format = MEDIA_BUS_FMT_RGB666_1X24_CPADHI;
 	}
 
 	panel_node = of_parse_phandle(np, "fsl,panel", 0);
diff --git a/drivers/gpu/ipu-v3/ipu-dc.c b/drivers/gpu/ipu-v3/ipu-dc.c
index 651c20c..9ef2e1f 100644
--- a/drivers/gpu/ipu-v3/ipu-dc.c
+++ b/drivers/gpu/ipu-v3/ipu-dc.c
@@ -168,7 +168,7 @@ static int ipu_bus_format_to_map(u32 fmt)
 }
 
 int ipu_dc_init_sync(struct ipu_dc *dc, struct ipu_di *di, bool interlaced,
-		u32 pixel_fmt, u32 width)
+		u32 bus_format, u32 width)
 {
 	struct ipu_dc_priv *priv = dc->priv;
 	u32 reg = 0;
@@ -176,7 +176,7 @@ int ipu_dc_init_sync(struct ipu_dc *dc, struct ipu_di *di, bool interlaced,
 
 	dc->di = ipu_di_get_num(di);
 
-	map = ipu_bus_format_to_map(pixel_fmt);
+	map = ipu_bus_format_to_map(bus_format);
 	if (map < 0) {
 		dev_dbg(priv->dev, "IPU_DISP: No MAP\n");
 		return map;
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 73390c1..85dedca 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -39,7 +39,7 @@ struct ipu_di_signal_cfg {
 
 	struct videomode mode;
 
-	u32 pixel_fmt;
+	u32 bus_format;
 	u32 v_to_h_sync;
 
 #define IPU_DI_CLKMODE_SYNC	(1 << 0)
-- 
2.1.4

