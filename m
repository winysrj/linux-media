Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:39661 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728137AbeIENqO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Sep 2018 09:46:14 -0400
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
Subject: [PATCH 08/10] drm/bridge: cdns: Separate DSI and D-PHY configuration
Date: Wed,  5 Sep 2018 11:16:39 +0200
Message-Id: <10b1a1deb248353f33b3a6fe0b59f7db3736939e.1536138624.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
References: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
References: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current configuration of the DSI bridge and its associated D-PHY is
intertwined. In order to ease the future conversion to the phy framework
for the D-PHY part, let's split the configuration in two.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/gpu/drm/bridge/cdns-dsi.c | 87 +++++++++++++++++++++++---------
 1 file changed, 64 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/bridge/cdns-dsi.c b/drivers/gpu/drm/bridge/cdns-dsi.c
index 6474e6d999b7..bb9a71ad3d91 100644
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
@@ -730,14 +735,12 @@ static unsigned int dpi_to_dsi_timing(unsigned int dpi_timing,
 
 static int cdns_dsi_mode2cfg(struct cdns_dsi *dsi,
 			     const struct drm_display_mode *mode,
-			     struct cdns_dsi_cfg *dsi_cfg,
-			     struct cdns_dphy_cfg *dphy_cfg)
+			     struct cdns_dsi_cfg *dsi_cfg)
 {
-	unsigned long dsi_htotal = 0, dsi_hss_hsa_hse_hbp = 0;
 	struct cdns_dsi_output *output = &dsi->output;
-	unsigned int dsi_hfp_ext = 0, dpi_hfp, tmp;
+	unsigned int tmp;
 	bool sync_pulse = false;
-	int bpp, nlanes, ret;
+	int bpp, nlanes;
 
 	memset(dsi_cfg, 0, sizeof(*dsi_cfg));
 
@@ -751,44 +754,84 @@ static int cdns_dsi_mode2cfg(struct cdns_dsi *dsi,
 		(sync_pulse ? mode->crtc_hsync_end : mode->crtc_hsync_start);
 
 	dsi_cfg->hbp = dpi_to_dsi_timing(tmp, bpp, DSI_HBP_FRAME_OVERHEAD);
-	dsi_htotal += dsi_cfg->hbp + DSI_HBP_FRAME_OVERHEAD;
-	dsi_hss_hsa_hse_hbp += dsi_cfg->hbp + DSI_HBP_FRAME_OVERHEAD;
 
 	if (sync_pulse) {
 		tmp = mode->crtc_hsync_end - mode->crtc_hsync_start;
 
 		dsi_cfg->hsa = dpi_to_dsi_timing(tmp, bpp,
 						 DSI_HSA_FRAME_OVERHEAD);
-		dsi_htotal += dsi_cfg->hsa + DSI_HSA_FRAME_OVERHEAD;
-		dsi_hss_hsa_hse_hbp += dsi_cfg->hsa + DSI_HSA_FRAME_OVERHEAD;
 	}
 
 	dsi_cfg->hact = dpi_to_dsi_timing(mode->crtc_hdisplay,
 					  bpp, 0);
-	dsi_htotal += dsi_cfg->hact;
+	dsi_cfg->hfp = dpi_to_dsi_timing(mode_to_dpi_hfp(mode), bpp,
+					 DSI_HFP_FRAME_OVERHEAD);
+
+	return 0;
+}
 
-	dpi_hfp = mode->crtc_hsync_start - mode->crtc_hdisplay;
-	dsi_cfg->hfp = dpi_to_dsi_timing(dpi_hfp, bpp, DSI_HFP_FRAME_OVERHEAD);
+static int cdns_dphy_validate(struct cdns_dsi *dsi,
+			      struct cdns_dsi_cfg *dsi_cfg,
+			      struct cdns_dphy_cfg *dphy_cfg,
+			      const struct drm_display_mode *mode)
+{
+	struct cdns_dsi_output *output = &dsi->output;
+	unsigned long dsi_htotal;
+	unsigned int dsi_hfp_ext = 0;
+
+	int ret;
+
+	dsi_htotal = dsi_cfg->hbp + DSI_HBP_FRAME_OVERHEAD;
+	if (output->dev->mode_flags & MIPI_DSI_MODE_VIDEO_SYNC_PULSE)
+		dsi_htotal += dsi_cfg->hsa + DSI_HSA_FRAME_OVERHEAD;
+
+	dsi_htotal += dsi_cfg->hact;
 	dsi_htotal += dsi_cfg->hfp + DSI_HFP_FRAME_OVERHEAD;
 
 	ret = cdns_dsi_get_dphy_pll_cfg(dsi->dphy, dphy_cfg,
-					mode->crtc_htotal, bpp,
+					mode->crtc_htotal,
+					mipi_dsi_pixel_format_to_bpp(output->dev->format),
 					mode->crtc_clock * 1000,
-					dsi_htotal, nlanes,
+					dsi_htotal,
+					output->dev->lanes,
 					&dsi_hfp_ext);
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
+			       struct cdns_dphy_cfg *dphy_cfg)
+{
+	struct cdns_dsi_output *output = &dsi->output;
+	unsigned long dsi_hss_hsa_hse_hbp;
+	unsigned int nlanes = output->dev->lanes;
+	int ret;
+
+	ret = cdns_dsi_mode2cfg(dsi, mode, dsi_cfg);
+	if (ret)
+		return ret;
+
+	ret = cdns_dphy_validate(dsi, dsi_cfg, dphy_cfg, mode);
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
 	    (u64)dsi_hss_hsa_hse_hbp * mode->crtc_clock * 1000)
 		return -EINVAL;
 
@@ -819,7 +862,7 @@ cdns_dsi_bridge_mode_valid(struct drm_bridge *bridge,
 	struct cdns_dsi_output *output = &dsi->output;
 	struct cdns_dphy_cfg dphy_cfg;
 	struct cdns_dsi_cfg dsi_cfg;
-	int bpp, nlanes, ret;
+	int bpp, ret;
 
 	/*
 	 * VFP_DSI should be less than VFP_DPI and VFP_DSI should be at
@@ -837,11 +880,9 @@ cdns_dsi_bridge_mode_valid(struct drm_bridge *bridge,
 	if ((mode->hdisplay * bpp) % 32)
 		return MODE_H_ILLEGAL;
 
-	nlanes = output->dev->lanes;
-
-	ret = cdns_dsi_mode2cfg(dsi, mode, &dsi_cfg, &dphy_cfg);
+	ret = cdns_dsi_check_conf(dsi, mode, &dsi_cfg, &dphy_cfg);
 	if (ret)
-		return MODE_CLOCK_RANGE;
+		return MODE_BAD;
 
 	return MODE_OK;
 }
@@ -967,7 +1008,7 @@ static void cdns_dsi_bridge_enable(struct drm_bridge *bridge)
 	bpp = mipi_dsi_pixel_format_to_bpp(output->dev->format);
 	nlanes = output->dev->lanes;
 
-	WARN_ON_ONCE(cdns_dsi_mode2cfg(dsi, mode, &dsi_cfg, &dphy_cfg));
+	WARN_ON_ONCE(cdns_dsi_check_conf(dsi, mode, &dsi_cfg, &dphy_cfg));
 
 	cdns_dsi_hs_init(dsi, &dphy_cfg);
 	cdns_dsi_init_link(dsi);
-- 
git-series 0.9.1
