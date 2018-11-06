Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:51820 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389010AbeKGAUQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Nov 2018 19:20:16 -0500
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Kishon Vijay Abraham I <kishon@ti.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v2 7/9] drm/bridge: cdns: Separate DSI and D-PHY configuration
Date: Tue,  6 Nov 2018 15:54:19 +0100
Message-Id: <8214d82bb1cfd2160f900deef8a9934b4efb0685.1541516029.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <cover.c2c2ae47383b9dbbdee6b69cafdd7391c06dde4f.1541516029.git-series.maxime.ripard@bootlin.com>
References: <cover.c2c2ae47383b9dbbdee6b69cafdd7391c06dde4f.1541516029.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current configuration of the DSI bridge and its associated D-PHY is
intertwined. In order to ease the future conversion to the phy framework
for the D-PHY part, let's split the configuration in two.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/gpu/drm/bridge/cdns-dsi.c | 96 ++++++++++++++++++++++----------
 1 file changed, 68 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/bridge/cdns-dsi.c b/drivers/gpu/drm/bridge/cdns-dsi.c
index ce9496d13986..3ac6dd524b6d 100644
--- a/drivers/gpu/drm/bridge/cdns-dsi.c
+++ b/drivers/gpu/drm/bridge/cdns-dsi.c
@@ -545,6 +545,11 @@ bridge_to_cdns_dsi_input(struct drm_bridge *bridge)
 	return container_of(bridge, struct cdns_dsi_input, bridge);
 }
 
+static unsigned int mode_to_dpi_hfp(const struct drm_display_mode *mode)
+{
+	return mode->crtc_hsync_start - mode->crtc_hdisplay;
+}
+
 static int cdns_dsi_get_dphy_pll_cfg(struct cdns_dphy *dphy,
 				     struct cdns_dphy_cfg *cfg,
 				     unsigned int dpi_htotal,
@@ -731,14 +736,12 @@ static unsigned int dpi_to_dsi_timing(unsigned int dpi_timing,
 static int cdns_dsi_mode2cfg(struct cdns_dsi *dsi,
 			     const struct drm_display_mode *mode,
 			     struct cdns_dsi_cfg *dsi_cfg,
-			     struct cdns_dphy_cfg *dphy_cfg,
 			     bool mode_valid_check)
 {
-	unsigned long dsi_htotal = 0, dsi_hss_hsa_hse_hbp = 0;
 	struct cdns_dsi_output *output = &dsi->output;
-	unsigned int dsi_hfp_ext = 0, dpi_hfp, tmp;
+	unsigned int tmp;
 	bool sync_pulse = false;
-	int bpp, nlanes, ret;
+	int bpp, nlanes;
 
 	memset(dsi_cfg, 0, sizeof(*dsi_cfg));
 
@@ -757,8 +760,6 @@ static int cdns_dsi_mode2cfg(struct cdns_dsi *dsi,
 		       mode->crtc_hsync_end : mode->crtc_hsync_start);
 
 	dsi_cfg->hbp = dpi_to_dsi_timing(tmp, bpp, DSI_HBP_FRAME_OVERHEAD);
-	dsi_htotal += dsi_cfg->hbp + DSI_HBP_FRAME_OVERHEAD;
-	dsi_hss_hsa_hse_hbp += dsi_cfg->hbp + DSI_HBP_FRAME_OVERHEAD;
 
 	if (sync_pulse) {
 		if (mode_valid_check)
@@ -768,49 +769,90 @@ static int cdns_dsi_mode2cfg(struct cdns_dsi *dsi,
 
 		dsi_cfg->hsa = dpi_to_dsi_timing(tmp, bpp,
 						 DSI_HSA_FRAME_OVERHEAD);
-		dsi_htotal += dsi_cfg->hsa + DSI_HSA_FRAME_OVERHEAD;
-		dsi_hss_hsa_hse_hbp += dsi_cfg->hsa + DSI_HSA_FRAME_OVERHEAD;
 	}
 
 	dsi_cfg->hact = dpi_to_dsi_timing(mode_valid_check ?
 					  mode->hdisplay : mode->crtc_hdisplay,
 					  bpp, 0);
-	dsi_htotal += dsi_cfg->hact;
+	dsi_cfg->hfp = dpi_to_dsi_timing(mode_to_dpi_hfp(mode), bpp,
+					 DSI_HFP_FRAME_OVERHEAD);
 
-	if (mode_valid_check)
-		dpi_hfp = mode->hsync_start - mode->hdisplay;
-	else
-		dpi_hfp = mode->crtc_hsync_start - mode->crtc_hdisplay;
+	return 0;
+}
+
+static int cdns_dphy_validate(struct cdns_dsi *dsi,
+			      struct cdns_dsi_cfg *dsi_cfg,
+			      struct cdns_dphy_cfg *dphy_cfg,
+			      const struct drm_display_mode *mode,
+			      bool mode_valid_check)
+{
+	struct cdns_dsi_output *output = &dsi->output;
+	unsigned long dsi_htotal;
+	unsigned int dsi_hfp_ext = 0;
+
+	int ret;
 
-	dsi_cfg->hfp = dpi_to_dsi_timing(dpi_hfp, bpp, DSI_HFP_FRAME_OVERHEAD);
+	dsi_htotal = dsi_cfg->hbp + DSI_HBP_FRAME_OVERHEAD;
+	if (output->dev->mode_flags & MIPI_DSI_MODE_VIDEO_SYNC_PULSE)
+		dsi_htotal += dsi_cfg->hsa + DSI_HSA_FRAME_OVERHEAD;
+
+	dsi_htotal += dsi_cfg->hact;
 	dsi_htotal += dsi_cfg->hfp + DSI_HFP_FRAME_OVERHEAD;
 
 	if (mode_valid_check)
 		ret = cdns_dsi_get_dphy_pll_cfg(dsi->dphy, dphy_cfg,
-						mode->htotal, bpp,
+						mode->htotal,
 						mode->clock * 1000,
-						dsi_htotal, nlanes,
+						mipi_dsi_pixel_format_to_bpp(output->dev->format),
+						dsi_htotal,
+						output->dev->lanes,
 						&dsi_hfp_ext);
 	else
 		ret = cdns_dsi_get_dphy_pll_cfg(dsi->dphy, dphy_cfg,
-						mode->crtc_htotal, bpp,
+						mode->crtc_htotal,
+						mipi_dsi_pixel_format_to_bpp(output->dev->format),
 						mode->crtc_clock * 1000,
-						dsi_htotal, nlanes,
+						dsi_htotal,
+						output->dev->lanes,
 						&dsi_hfp_ext);
-
 	if (ret)
 		return ret;
 
 	dsi_cfg->hfp += dsi_hfp_ext;
-	dsi_htotal += dsi_hfp_ext;
-	dsi_cfg->htotal = dsi_htotal;
+	dsi_cfg->htotal = dsi_htotal + dsi_hfp_ext;
+
+	return 0;
+}
+
+static int cdns_dsi_check_conf(struct cdns_dsi *dsi,
+			       const struct drm_display_mode *mode,
+			       struct cdns_dsi_cfg *dsi_cfg,
+			       struct cdns_dphy_cfg *dphy_cfg,
+			       bool mode_valid_check)
+{
+	struct cdns_dsi_output *output = &dsi->output;
+	unsigned long dsi_hss_hsa_hse_hbp;
+	unsigned int nlanes = output->dev->lanes;
+	int ret;
+
+	ret = cdns_dsi_mode2cfg(dsi, mode, dsi_cfg, mode_valid_check);
+	if (ret)
+		return ret;
+
+	ret = cdns_dphy_validate(dsi, dsi_cfg, dphy_cfg, mode, mode_valid_check);
+	if (ret)
+		return ret;
+
+	dsi_hss_hsa_hse_hbp = dsi_cfg->hbp + DSI_HBP_FRAME_OVERHEAD;
+	if (output->dev->mode_flags & MIPI_DSI_MODE_VIDEO_SYNC_PULSE)
+		dsi_hss_hsa_hse_hbp += dsi_cfg->hsa + DSI_HSA_FRAME_OVERHEAD;
 
 	/*
 	 * Make sure DPI(HFP) > DSI(HSS+HSA+HSE+HBP) to guarantee that the FIFO
 	 * is empty before we start a receiving a new line on the DPI
 	 * interface.
 	 */
-	if ((u64)dphy_cfg->lane_bps * dpi_hfp * nlanes <
+	if ((u64)dphy_cfg->lane_bps * mode_to_dpi_hfp(mode) * nlanes <
 	    (u64)dsi_hss_hsa_hse_hbp *
 	    (mode_valid_check ? mode->clock : mode->crtc_clock) * 1000)
 		return -EINVAL;
@@ -842,7 +884,7 @@ cdns_dsi_bridge_mode_valid(struct drm_bridge *bridge,
 	struct cdns_dsi_output *output = &dsi->output;
 	struct cdns_dphy_cfg dphy_cfg;
 	struct cdns_dsi_cfg dsi_cfg;
-	int bpp, nlanes, ret;
+	int bpp, ret;
 
 	/*
 	 * VFP_DSI should be less than VFP_DPI and VFP_DSI should be at
@@ -860,11 +902,9 @@ cdns_dsi_bridge_mode_valid(struct drm_bridge *bridge,
 	if ((mode->hdisplay * bpp) % 32)
 		return MODE_H_ILLEGAL;
 
-	nlanes = output->dev->lanes;
-
-	ret = cdns_dsi_mode2cfg(dsi, mode, &dsi_cfg, &dphy_cfg, true);
+	ret = cdns_dsi_check_conf(dsi, mode, &dsi_cfg, &dphy_cfg, true);
 	if (ret)
-		return MODE_CLOCK_RANGE;
+		return MODE_BAD;
 
 	return MODE_OK;
 }
@@ -990,7 +1030,7 @@ static void cdns_dsi_bridge_enable(struct drm_bridge *bridge)
 	bpp = mipi_dsi_pixel_format_to_bpp(output->dev->format);
 	nlanes = output->dev->lanes;
 
-	WARN_ON_ONCE(cdns_dsi_mode2cfg(dsi, mode, &dsi_cfg, &dphy_cfg, false));
+	WARN_ON_ONCE(cdns_dsi_check_conf(dsi, mode, &dsi_cfg, &dphy_cfg, false));
 
 	cdns_dsi_hs_init(dsi, &dphy_cfg);
 	cdns_dsi_init_link(dsi);
-- 
git-series 0.9.1
