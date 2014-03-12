Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:58490 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935AbaCLQbz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Mar 2014 12:31:55 -0400
From: Denis Carikli <denis@eukrea.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King <linux@arm.linux.org.uk>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Denis Carikli <denis@eukrea.com>
Subject: [PATCH v10][ 07/10] imx-drm: Prepare imx-drm for extra display-timings retrival.
Date: Wed, 12 Mar 2014 17:31:04 +0100
Message-Id: <1394641867-15629-7-git-send-email-denis@eukrea.com>
In-Reply-To: <1394641867-15629-1-git-send-email-denis@eukrea.com>
References: <1394641867-15629-1-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The hardware behaviour was kept.

Signed-off-by: Denis Carikli <denis@eukrea.com>
---
ChangeLog v9->v10:
- New patch that was splitted out of
  "staging: imx-drm: Use de-active and pixelclk-active
 display-timings."
- The IMXDRM_MODE_FLAG_ are now using the BIT macros.
- The SET_CLK_POL and SET_DE_POL masks were removed.
  The code was updated accordingly.
---
 drivers/staging/imx-drm/imx-drm-core.c      |   10 ++++++++++
 drivers/staging/imx-drm/imx-drm.h           |    6 ++++++
 drivers/staging/imx-drm/imx-hdmi.c          |    3 +++
 drivers/staging/imx-drm/imx-ldb.c           |    3 +++
 drivers/staging/imx-drm/imx-tve.c           |    3 +++
 drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h |    6 ++++--
 drivers/staging/imx-drm/ipu-v3/ipu-di.c     |    7 ++++++-
 drivers/staging/imx-drm/ipuv3-crtc.c        |   12 ++++++++++--
 drivers/staging/imx-drm/parallel-display.c  |    2 ++
 9 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
index 4144a75..6a71cd9 100644
--- a/drivers/staging/imx-drm/imx-drm-core.c
+++ b/drivers/staging/imx-drm/imx-drm-core.c
@@ -492,6 +492,16 @@ int imx_drm_encoder_parse_of(struct drm_device *drm,
 }
 EXPORT_SYMBOL_GPL(imx_drm_encoder_parse_of);
 
+void imx_drm_set_default_timing_flags(struct drm_display_mode *mode)
+{
+	mode->private_flags &= ~IMXDRM_MODE_FLAG_DE_LOW;
+	mode->private_flags &= ~IMXDRM_MODE_FLAG_PIXDATA_POSEDGE;
+
+	mode->private_flags |= IMXDRM_MODE_FLAG_DE_HIGH;
+	mode->private_flags |= IMXDRM_MODE_FLAG_PIXDATA_NEGEDGE;
+}
+EXPORT_SYMBOL_GPL(imx_drm_set_default_timing_flags);
+
 /*
  * @node: device tree node containing encoder input ports
  * @encoder: drm_encoder
diff --git a/drivers/staging/imx-drm/imx-drm.h b/drivers/staging/imx-drm/imx-drm.h
index a322bac..ae07d9d 100644
--- a/drivers/staging/imx-drm/imx-drm.h
+++ b/drivers/staging/imx-drm/imx-drm.h
@@ -1,6 +1,11 @@
 #ifndef _IMX_DRM_H_
 #define _IMX_DRM_H_
 
+#define IMXDRM_MODE_FLAG_DE_HIGH		BIT(0)
+#define IMXDRM_MODE_FLAG_DE_LOW			BIT(1)
+#define IMXDRM_MODE_FLAG_PIXDATA_POSEDGE	BIT(2)
+#define IMXDRM_MODE_FLAG_PIXDATA_NEGEDGE	BIT(3)
+
 struct device_node;
 struct drm_crtc;
 struct drm_connector;
@@ -49,6 +54,7 @@ int imx_drm_encoder_get_mux_id(struct device_node *node,
 		struct drm_encoder *encoder);
 int imx_drm_encoder_parse_of(struct drm_device *drm,
 	struct drm_encoder *encoder, struct device_node *np);
+void imx_drm_set_default_timing_flags(struct drm_display_mode *mode);
 
 int imx_drm_connector_mode_valid(struct drm_connector *connector,
 	struct drm_display_mode *mode);
diff --git a/drivers/staging/imx-drm/imx-hdmi.c b/drivers/staging/imx-drm/imx-hdmi.c
index 4540a9aa..0b215cc 100644
--- a/drivers/staging/imx-drm/imx-hdmi.c
+++ b/drivers/staging/imx-drm/imx-hdmi.c
@@ -1431,6 +1431,9 @@ static bool imx_hdmi_encoder_mode_fixup(struct drm_encoder *encoder,
 			const struct drm_display_mode *mode,
 			struct drm_display_mode *adjusted_mode)
 {
+	drm_mode_copy(adjusted_mode, mode);
+	imx_drm_set_default_timing_flags(ajusted_mode);
+
 	return true;
 }
 
diff --git a/drivers/staging/imx-drm/imx-ldb.c b/drivers/staging/imx-drm/imx-ldb.c
index e6d7bc7..9845a6b 100644
--- a/drivers/staging/imx-drm/imx-ldb.c
+++ b/drivers/staging/imx-drm/imx-ldb.c
@@ -108,6 +108,9 @@ static int imx_ldb_connector_get_modes(struct drm_connector *connector)
 		mode = drm_mode_create(connector->dev);
 		if (!mode)
 			return -EINVAL;
+
+		imx_drm_set_default_timing_flags(&imx_ldb_ch->mode);
+
 		drm_mode_copy(mode, &imx_ldb_ch->mode);
 		mode->type |= DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED;
 		drm_mode_probed_add(connector, mode);
diff --git a/drivers/staging/imx-drm/imx-tve.c b/drivers/staging/imx-drm/imx-tve.c
index 575533f..605013c 100644
--- a/drivers/staging/imx-drm/imx-tve.c
+++ b/drivers/staging/imx-drm/imx-tve.c
@@ -294,6 +294,9 @@ static bool imx_tve_encoder_mode_fixup(struct drm_encoder *encoder,
 				       const struct drm_display_mode *mode,
 				       struct drm_display_mode *adjusted_mode)
 {
+	drm_mode_copy(adjusted_mode, mode);
+	imx_drm_set_default_timing_flags(adjusted_mode);
+
 	return true;
 }
 
diff --git a/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h b/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
index b95cba1..3abeea3 100644
--- a/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
+++ b/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
@@ -29,9 +29,11 @@ enum ipuv3_type {
 
 #define CLK_POL_ACTIVE_LOW	0
 #define CLK_POL_ACTIVE_HIGH	1
+#define CLK_POL_PRESERVE	2
 
 #define ENABLE_POL_NEGEDGE	0
 #define ENABLE_POL_POSEDGE	1
+#define ENABLE_POL_PRESERVE	2
 
 /*
  * Bitfield of Display Interface signal polarities.
@@ -43,10 +45,10 @@ struct ipu_di_signal_cfg {
 	unsigned clksel_en:1;
 	unsigned clkidle_en:1;
 	unsigned data_pol:1;	/* true = inverted */
-	unsigned clk_pol:1;
-	unsigned enable_pol:1;
 	unsigned Hsync_pol:1;	/* true = active high */
 	unsigned Vsync_pol:1;
+	u8 clk_pol;
+	u8 enable_pol;
 
 	u16 width;
 	u16 height;
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-di.c b/drivers/staging/imx-drm/ipu-v3/ipu-di.c
index 53646aa..791080b 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-di.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-di.c
@@ -597,6 +597,8 @@ int ipu_di_init_sync_panel(struct ipu_di *di, struct ipu_di_signal_cfg *sig)
 
 	if (sig->clk_pol == CLK_POL_ACTIVE_HIGH)
 		di_gen |= DI_GEN_POLARITY_DISP_CLK;
+	else if (sig->clk_pol == CLK_POL_ACTIVE_LOW)
+		di_gen &= ~DI_GEN_POLARITY_DISP_CLK;
 
 	ipu_di_write(di, di_gen, DI_GENERAL);
 
@@ -604,10 +606,13 @@ int ipu_di_init_sync_panel(struct ipu_di *di, struct ipu_di_signal_cfg *sig)
 		     DI_SYNC_AS_GEN);
 
 	reg = ipu_di_read(di, DI_POL);
-	reg &= ~(DI_POL_DRDY_DATA_POLARITY | DI_POL_DRDY_POLARITY_15);
+	reg &= ~(DI_POL_DRDY_DATA_POLARITY);
 
 	if (sig->enable_pol == ENABLE_POL_POSEDGE)
 		reg |= DI_POL_DRDY_POLARITY_15;
+	else if (sig->enable_pol == ENABLE_POL_NEGEDGE)
+		reg &= ~DI_POL_DRDY_POLARITY_15;
+
 	if (sig->data_pol)
 		reg |= DI_POL_DRDY_DATA_POLARITY;
 
diff --git a/drivers/staging/imx-drm/ipuv3-crtc.c b/drivers/staging/imx-drm/ipuv3-crtc.c
index 8cfeb47..c935f38 100644
--- a/drivers/staging/imx-drm/ipuv3-crtc.c
+++ b/drivers/staging/imx-drm/ipuv3-crtc.c
@@ -157,8 +157,16 @@ static int ipu_crtc_mode_set(struct drm_crtc *crtc,
 	if (mode->flags & DRM_MODE_FLAG_PVSYNC)
 		sig_cfg.Vsync_pol = 1;
 
-	sig_cfg.enable_pol = ENABLE_POL_POSEDGE;
-	sig_cfg.clk_pol = CLK_POL_ACTIVE_LOW;
+	if (mode->private_flags & IMXDRM_MODE_FLAG_DE_HIGH)
+		sig_cfg.enable_pol = ENABLE_POL_POSEDGE;
+	else if (mode->private_flags & IMXDRM_MODE_FLAG_DE_LOW)
+		sig_cfg.enable_pol = ENABLE_POL_NEGEDGE;
+
+	if (mode->private_flags & IMXDRM_MODE_FLAG_PIXDATA_POSEDGE)
+		sig_cfg.clk_pol = CLK_POL_ACTIVE_HIGH;
+	else if (mode->private_flags & IMXDRM_MODE_FLAG_PIXDATA_NEGEDGE)
+		sig_cfg.clk_pol = CLK_POL_ACTIVE_LOW;
+
 	sig_cfg.width = mode->hdisplay;
 	sig_cfg.height = mode->vdisplay;
 	sig_cfg.pixel_fmt = out_pixel_fmt;
diff --git a/drivers/staging/imx-drm/parallel-display.c b/drivers/staging/imx-drm/parallel-display.c
index 01b7ce5..871a737 100644
--- a/drivers/staging/imx-drm/parallel-display.c
+++ b/drivers/staging/imx-drm/parallel-display.c
@@ -73,6 +73,7 @@ static int imx_pd_connector_get_modes(struct drm_connector *connector)
 		if (!mode)
 			return -EINVAL;
 		drm_mode_copy(mode, &imxpd->mode);
+		imx_drm_set_default_timing_flags(mode);
 		mode->type |= DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED,
 		drm_mode_probed_add(connector, mode);
 		num_modes++;
@@ -84,6 +85,7 @@ static int imx_pd_connector_get_modes(struct drm_connector *connector)
 			return -EINVAL;
 		of_get_drm_display_mode(np, &imxpd->mode, OF_USE_NATIVE_MODE);
 		drm_mode_copy(mode, &imxpd->mode);
+		imx_drm_set_default_timing_flags(mode);
 		mode->type |= DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED,
 		drm_mode_probed_add(connector, mode);
 		num_modes++;
-- 
1.7.9.5

