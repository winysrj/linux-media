Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48950 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbbCLJ65 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 05:58:57 -0400
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
Subject: [PATCH v3 06/10] drm/imx: switch to use media bus formats
Date: Thu, 12 Mar 2015 10:58:12 +0100
Message-Id: <1426154296-30665-7-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1426154296-30665-1-git-send-email-p.zabel@pengutronix.de>
References: <1426154296-30665-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

imx-drm internally misused the V4L2_PIX_FMT constants, which are supposed to
describe the pixel format of frame buffers in memory, to describe the pixel
format on the bus between the display controller and the encoder hardware.
Now that MEDIA_BUS_FMT constants are available to drm drivers, use those
instead.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/drm/imx/dw_hdmi-imx.c      |  2 +-
 drivers/gpu/drm/imx/imx-ldb.c          |  6 +++---
 drivers/gpu/drm/imx/imx-tve.c          |  4 ++--
 drivers/gpu/drm/imx/parallel-display.c |  8 ++++----
 drivers/gpu/ipu-v3/ipu-dc.c            | 16 ++++++++--------
 5 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/imx/dw_hdmi-imx.c b/drivers/gpu/drm/imx/dw_hdmi-imx.c
index 87fe8ed..61ef987 100644
--- a/drivers/gpu/drm/imx/dw_hdmi-imx.c
+++ b/drivers/gpu/drm/imx/dw_hdmi-imx.c
@@ -123,7 +123,7 @@ static void dw_hdmi_imx_encoder_commit(struct drm_encoder *encoder)
 
 static void dw_hdmi_imx_encoder_prepare(struct drm_encoder *encoder)
 {
-	imx_drm_panel_format(encoder, V4L2_PIX_FMT_RGB24);
+	imx_drm_panel_format(encoder, MEDIA_BUS_FMT_RGB888_1X24);
 }
 
 static struct drm_encoder_helper_funcs dw_hdmi_imx_encoder_helper_funcs = {
diff --git a/drivers/gpu/drm/imx/imx-ldb.c b/drivers/gpu/drm/imx/imx-ldb.c
index 2d6dc94..f9ec17a 100644
--- a/drivers/gpu/drm/imx/imx-ldb.c
+++ b/drivers/gpu/drm/imx/imx-ldb.c
@@ -168,16 +168,16 @@ static void imx_ldb_encoder_prepare(struct drm_encoder *encoder)
 	switch (imx_ldb_ch->chno) {
 	case 0:
 		pixel_fmt = (ldb->ldb_ctrl & LDB_DATA_WIDTH_CH0_24) ?
-			V4L2_PIX_FMT_RGB24 : V4L2_PIX_FMT_BGR666;
+			MEDIA_BUS_FMT_RGB888_1X24 : MEDIA_BUS_FMT_RGB666_1X18;
 		break;
 	case 1:
 		pixel_fmt = (ldb->ldb_ctrl & LDB_DATA_WIDTH_CH1_24) ?
-			V4L2_PIX_FMT_RGB24 : V4L2_PIX_FMT_BGR666;
+			MEDIA_BUS_FMT_RGB888_1X24 : MEDIA_BUS_FMT_RGB666_1X18;
 		break;
 	default:
 		dev_err(ldb->dev, "unable to config di%d panel format\n",
 			imx_ldb_ch->chno);
-		pixel_fmt = V4L2_PIX_FMT_RGB24;
+		pixel_fmt = MEDIA_BUS_FMT_RGB888_1X24;
 	}
 
 	imx_drm_panel_format(encoder, pixel_fmt);
diff --git a/drivers/gpu/drm/imx/imx-tve.c b/drivers/gpu/drm/imx/imx-tve.c
index 4216e47..bcdcb1b 100644
--- a/drivers/gpu/drm/imx/imx-tve.c
+++ b/drivers/gpu/drm/imx/imx-tve.c
@@ -301,11 +301,11 @@ static void imx_tve_encoder_prepare(struct drm_encoder *encoder)
 
 	switch (tve->mode) {
 	case TVE_MODE_VGA:
-		imx_drm_panel_format_pins(encoder, IPU_PIX_FMT_GBR24,
+		imx_drm_panel_format_pins(encoder, MEDIA_BUS_FMT_YUV8_1X24,
 				tve->hsync_pin, tve->vsync_pin);
 		break;
 	case TVE_MODE_TVOUT:
-		imx_drm_panel_format(encoder, V4L2_PIX_FMT_YUV444);
+		imx_drm_panel_format(encoder, MEDIA_BUS_FMT_YUV8_1X24);
 		break;
 	}
 }
diff --git a/drivers/gpu/drm/imx/parallel-display.c b/drivers/gpu/drm/imx/parallel-display.c
index 900dda6..e645fe1 100644
--- a/drivers/gpu/drm/imx/parallel-display.c
+++ b/drivers/gpu/drm/imx/parallel-display.c
@@ -225,14 +225,14 @@ static int imx_pd_bind(struct device *dev, struct device *master, void *data)
 	ret = of_property_read_string(np, "interface-pix-fmt", &fmt);
 	if (!ret) {
 		if (!strcmp(fmt, "rgb24"))
-			imxpd->interface_pix_fmt = V4L2_PIX_FMT_RGB24;
+			imxpd->interface_pix_fmt = MEDIA_BUS_FMT_RGB888_1X24;
 		else if (!strcmp(fmt, "rgb565"))
-			imxpd->interface_pix_fmt = V4L2_PIX_FMT_RGB565;
+			imxpd->interface_pix_fmt = MEDIA_BUS_FMT_RGB565_1X16;
 		else if (!strcmp(fmt, "bgr666"))
-			imxpd->interface_pix_fmt = V4L2_PIX_FMT_BGR666;
+			imxpd->interface_pix_fmt = MEDIA_BUS_FMT_RGB666_1X18;
 		else if (!strcmp(fmt, "lvds666"))
 			imxpd->interface_pix_fmt =
-					v4l2_fourcc('L', 'V', 'D', '6');
+					MEDIA_BUS_FMT_RGB666_1X24_CPADHI;
 	}
 
 	panel_node = of_parse_phandle(np, "fsl,panel", 0);
diff --git a/drivers/gpu/ipu-v3/ipu-dc.c b/drivers/gpu/ipu-v3/ipu-dc.c
index 4864f83..651c20c 100644
--- a/drivers/gpu/ipu-v3/ipu-dc.c
+++ b/drivers/gpu/ipu-v3/ipu-dc.c
@@ -147,20 +147,20 @@ static void dc_write_tmpl(struct ipu_dc *dc, int word, u32 opcode, u32 operand,
 	writel(reg2, priv->dc_tmpl_reg + word * 8 + 4);
 }
 
-static int ipu_pixfmt_to_map(u32 fmt)
+static int ipu_bus_format_to_map(u32 fmt)
 {
 	switch (fmt) {
-	case V4L2_PIX_FMT_RGB24:
+	case MEDIA_BUS_FMT_RGB888_1X24:
 		return IPU_DC_MAP_RGB24;
-	case V4L2_PIX_FMT_RGB565:
+	case MEDIA_BUS_FMT_RGB565_1X16:
 		return IPU_DC_MAP_RGB565;
-	case IPU_PIX_FMT_GBR24:
+	case MEDIA_BUS_FMT_GBR888_1X24:
 		return IPU_DC_MAP_GBR24;
-	case V4L2_PIX_FMT_BGR666:
+	case MEDIA_BUS_FMT_RGB666_1X18:
 		return IPU_DC_MAP_BGR666;
-	case v4l2_fourcc('L', 'V', 'D', '6'):
+	case MEDIA_BUS_FMT_RGB666_1X24_CPADHI:
 		return IPU_DC_MAP_LVDS666;
-	case V4L2_PIX_FMT_BGR24:
+	case MEDIA_BUS_FMT_BGR888_1X24:
 		return IPU_DC_MAP_BGR24;
 	default:
 		return -EINVAL;
@@ -176,7 +176,7 @@ int ipu_dc_init_sync(struct ipu_dc *dc, struct ipu_di *di, bool interlaced,
 
 	dc->di = ipu_di_get_num(di);
 
-	map = ipu_pixfmt_to_map(pixel_fmt);
+	map = ipu_bus_format_to_map(pixel_fmt);
 	if (map < 0) {
 		dev_dbg(priv->dev, "IPU_DISP: No MAP\n");
 		return map;
-- 
2.1.4

