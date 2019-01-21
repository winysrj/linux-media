Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49136C2F441
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 15:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05DD220870
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 15:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730792AbfAUPq0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 10:46:26 -0500
Received: from mail.bootlin.com ([62.4.15.54]:32992 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730642AbfAUPqZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 10:46:25 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id D73BF20CE0; Mon, 21 Jan 2019 16:46:21 +0100 (CET)
Received: from localhost (unknown [185.94.189.187])
        by mail.bootlin.com (Postfix) with ESMTPSA id 48F1020C96;
        Mon, 21 Jan 2019 16:46:01 +0100 (CET)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sean Paul <sean@poorly.run>
Subject: [PATCH v5 9/9] drm/bridge: cdns: Convert to phy framework
Date:   Mon, 21 Jan 2019 16:45:54 +0100
Message-Id: <8772ad061f07cd91fa48bb05880095b25eccec08.1548085432.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.fbf0776c70c0cfb7b7fd88ce6a96b4597d620cac.1548085432.git-series.maxime.ripard@bootlin.com>
References: <cover.fbf0776c70c0cfb7b7fd88ce6a96b4597d620cac.1548085432.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Now that we have everything we need in the phy framework to allow to tune
the phy parameters, let's convert the Cadence DSI bridge to that API
instead of creating a ad-hoc driver for its phy.

Acked-by: Sean Paul <sean@poorly.run>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/gpu/drm/bridge/Kconfig    |   1 +-
 drivers/gpu/drm/bridge/cdns-dsi.c | 485 +++----------------------------
 2 files changed, 60 insertions(+), 426 deletions(-)

diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index 2fee47b0d50b..8840f396a7b6 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -30,6 +30,7 @@ config DRM_CDNS_DSI
 	select DRM_KMS_HELPER
 	select DRM_MIPI_DSI
 	select DRM_PANEL_BRIDGE
+	select GENERIC_PHY_MIPI_DPHY
 	depends on OF
 	help
 	  Support Cadence DPI to DSI bridge. This is an internal
diff --git a/drivers/gpu/drm/bridge/cdns-dsi.c b/drivers/gpu/drm/bridge/cdns-dsi.c
index 796874e76308..713a70b86046 100644
--- a/drivers/gpu/drm/bridge/cdns-dsi.c
+++ b/drivers/gpu/drm/bridge/cdns-dsi.c
@@ -21,6 +21,9 @@
 #include <linux/pm_runtime.h>
 #include <linux/reset.h>
 
+#include <linux/phy/phy.h>
+#include <linux/phy/phy-mipi-dphy.h>
+
 #define IP_CONF				0x0
 #define SP_HS_FIFO_DEPTH(x)		(((x) & GENMASK(30, 26)) >> 26)
 #define SP_LP_FIFO_DEPTH(x)		(((x) & GENMASK(25, 21)) >> 21)
@@ -419,44 +422,11 @@
 #define DSI_NULL_FRAME_OVERHEAD		6
 #define DSI_EOT_PKT_SIZE		4
 
-#define REG_WAKEUP_TIME_NS		800
-#define DPHY_PLL_RATE_HZ		108000000
-
-/* DPHY registers */
-#define DPHY_PMA_CMN(reg)		(reg)
-#define DPHY_PMA_LCLK(reg)		(0x100 + (reg))
-#define DPHY_PMA_LDATA(lane, reg)	(0x200 + ((lane) * 0x100) + (reg))
-#define DPHY_PMA_RCLK(reg)		(0x600 + (reg))
-#define DPHY_PMA_RDATA(lane, reg)	(0x700 + ((lane) * 0x100) + (reg))
-#define DPHY_PCS(reg)			(0xb00 + (reg))
-
-#define DPHY_CMN_SSM			DPHY_PMA_CMN(0x20)
-#define DPHY_CMN_SSM_EN			BIT(0)
-#define DPHY_CMN_TX_MODE_EN		BIT(9)
-
-#define DPHY_CMN_PWM			DPHY_PMA_CMN(0x40)
-#define DPHY_CMN_PWM_DIV(x)		((x) << 20)
-#define DPHY_CMN_PWM_LOW(x)		((x) << 10)
-#define DPHY_CMN_PWM_HIGH(x)		(x)
-
-#define DPHY_CMN_FBDIV			DPHY_PMA_CMN(0x4c)
-#define DPHY_CMN_FBDIV_VAL(low, high)	(((high) << 11) | ((low) << 22))
-#define DPHY_CMN_FBDIV_FROM_REG		(BIT(10) | BIT(21))
-
-#define DPHY_CMN_OPIPDIV		DPHY_PMA_CMN(0x50)
-#define DPHY_CMN_IPDIV_FROM_REG		BIT(0)
-#define DPHY_CMN_IPDIV(x)		((x) << 1)
-#define DPHY_CMN_OPDIV_FROM_REG		BIT(6)
-#define DPHY_CMN_OPDIV(x)		((x) << 7)
-
-#define DPHY_PSM_CFG			DPHY_PCS(0x4)
-#define DPHY_PSM_CFG_FROM_REG		BIT(0)
-#define DPHY_PSM_CLK_DIV(x)		((x) << 1)
-
 struct cdns_dsi_output {
 	struct mipi_dsi_device *dev;
 	struct drm_panel *panel;
 	struct drm_bridge *bridge;
+	union phy_configure_opts phy_opts;
 };
 
 enum cdns_dsi_input_id {
@@ -465,14 +435,6 @@ enum cdns_dsi_input_id {
 	CDNS_DSC_INPUT,
 };
 
-struct cdns_dphy_cfg {
-	u8 pll_ipdiv;
-	u8 pll_opdiv;
-	u16 pll_fbdiv;
-	unsigned long lane_bps;
-	unsigned int nlanes;
-};
-
 struct cdns_dsi_cfg {
 	unsigned int hfp;
 	unsigned int hsa;
@@ -481,34 +443,6 @@ struct cdns_dsi_cfg {
 	unsigned int htotal;
 };
 
-struct cdns_dphy;
-
-enum cdns_dphy_clk_lane_cfg {
-	DPHY_CLK_CFG_LEFT_DRIVES_ALL = 0,
-	DPHY_CLK_CFG_LEFT_DRIVES_RIGHT = 1,
-	DPHY_CLK_CFG_LEFT_DRIVES_LEFT = 2,
-	DPHY_CLK_CFG_RIGHT_DRIVES_ALL = 3,
-};
-
-struct cdns_dphy_ops {
-	int (*probe)(struct cdns_dphy *dphy);
-	void (*remove)(struct cdns_dphy *dphy);
-	void (*set_psm_div)(struct cdns_dphy *dphy, u8 div);
-	void (*set_clk_lane_cfg)(struct cdns_dphy *dphy,
-				 enum cdns_dphy_clk_lane_cfg cfg);
-	void (*set_pll_cfg)(struct cdns_dphy *dphy,
-			    const struct cdns_dphy_cfg *cfg);
-	unsigned long (*get_wakeup_time_ns)(struct cdns_dphy *dphy);
-};
-
-struct cdns_dphy {
-	struct cdns_dphy_cfg cfg;
-	void __iomem *regs;
-	struct clk *psm_clk;
-	struct clk *pll_ref_clk;
-	const struct cdns_dphy_ops *ops;
-};
-
 struct cdns_dsi_input {
 	enum cdns_dsi_input_id id;
 	struct drm_bridge bridge;
@@ -526,7 +460,7 @@ struct cdns_dsi {
 	struct reset_control *dsi_p_rst;
 	struct clk *dsi_sys_clk;
 	bool link_initialized;
-	struct cdns_dphy *dphy;
+	struct phy *dphy;
 };
 
 static inline struct cdns_dsi *input_to_dsi(struct cdns_dsi_input *input)
@@ -554,175 +488,6 @@ static unsigned int mode_to_dpi_hfp(const struct drm_display_mode *mode,
 	return mode->crtc_hsync_start - mode->crtc_hdisplay;
 }
 
-static int cdns_dsi_get_dphy_pll_cfg(struct cdns_dphy *dphy,
-				     struct cdns_dphy_cfg *cfg,
-				     unsigned int dpi_htotal,
-				     unsigned int dpi_bpp,
-				     unsigned int dpi_hz,
-				     unsigned int dsi_htotal,
-				     unsigned int dsi_nlanes,
-				     unsigned int *dsi_hfp_ext)
-{
-	u64 dlane_bps, dlane_bps_max, fbdiv, fbdiv_max, adj_dsi_htotal;
-	unsigned long pll_ref_hz = clk_get_rate(dphy->pll_ref_clk);
-
-	memset(cfg, 0, sizeof(*cfg));
-
-	cfg->nlanes = dsi_nlanes;
-
-	if (pll_ref_hz < 9600000 || pll_ref_hz >= 150000000)
-		return -EINVAL;
-	else if (pll_ref_hz < 19200000)
-		cfg->pll_ipdiv = 1;
-	else if (pll_ref_hz < 38400000)
-		cfg->pll_ipdiv = 2;
-	else if (pll_ref_hz < 76800000)
-		cfg->pll_ipdiv = 4;
-	else
-		cfg->pll_ipdiv = 8;
-
-	/*
-	 * Make sure DSI htotal is aligned on a lane boundary when calculating
-	 * the expected data rate. This is done by extending HFP in case of
-	 * misalignment.
-	 */
-	adj_dsi_htotal = dsi_htotal;
-	if (dsi_htotal % dsi_nlanes)
-		adj_dsi_htotal += dsi_nlanes - (dsi_htotal % dsi_nlanes);
-
-	dlane_bps = (u64)dpi_hz * adj_dsi_htotal;
-
-	/* data rate in bytes/sec is not an integer, refuse the mode. */
-	if (do_div(dlane_bps, dsi_nlanes * dpi_htotal))
-		return -EINVAL;
-
-	/* data rate was in bytes/sec, convert to bits/sec. */
-	dlane_bps *= 8;
-
-	if (dlane_bps > 2500000000UL || dlane_bps < 160000000UL)
-		return -EINVAL;
-	else if (dlane_bps >= 1250000000)
-		cfg->pll_opdiv = 1;
-	else if (dlane_bps >= 630000000)
-		cfg->pll_opdiv = 2;
-	else if (dlane_bps >= 320000000)
-		cfg->pll_opdiv = 4;
-	else if (dlane_bps >= 160000000)
-		cfg->pll_opdiv = 8;
-
-	/*
-	 * Allow a deviation of 0.2% on the per-lane data rate to try to
-	 * recover a potential mismatch between DPI and PPI clks.
-	 */
-	dlane_bps_max = dlane_bps + DIV_ROUND_DOWN_ULL(dlane_bps, 500);
-	fbdiv_max = DIV_ROUND_DOWN_ULL(dlane_bps_max * 2 *
-				       cfg->pll_opdiv * cfg->pll_ipdiv,
-				       pll_ref_hz);
-	fbdiv = DIV_ROUND_UP_ULL(dlane_bps * 2 * cfg->pll_opdiv *
-				 cfg->pll_ipdiv,
-				 pll_ref_hz);
-
-	/*
-	 * Iterate over all acceptable fbdiv and try to find an adjusted DSI
-	 * htotal length providing an exact match.
-	 *
-	 * Note that we could do something even trickier by relying on the fact
-	 * that a new line is not necessarily aligned on a lane boundary, so,
-	 * by making adj_dsi_htotal non aligned on a dsi_lanes we can improve a
-	 * bit the precision. With this, the step would be
-	 *
-	 *	pll_ref_hz / (2 * opdiv * ipdiv * nlanes)
-	 *
-	 * instead of
-	 *
-	 *	pll_ref_hz / (2 * opdiv * ipdiv)
-	 *
-	 * The drawback of this approach is that we would need to make sure the
-	 * number or lines is a multiple of the realignment periodicity which is
-	 * a function of the number of lanes and the original misalignment. For
-	 * example, for NLANES = 4 and HTOTAL % NLANES = 3, it takes 4 lines
-	 * to realign on a lane:
-	 * LINE 0: expected number of bytes, starts emitting first byte of
-	 *	   LINE 1 on LANE 3
-	 * LINE 1: expected number of bytes, starts emitting first 2 bytes of
-	 *	   LINE 2 on LANES 2 and 3
-	 * LINE 2: expected number of bytes, starts emitting first 3 bytes of
-	 *	   of LINE 3 on LANES 1, 2 and 3
-	 * LINE 3: one byte less, now things are realigned on LANE 0 for LINE 4
-	 *
-	 * I figured this extra complexity was not worth the benefit, but if
-	 * someone really has unfixable mismatch, that would be something to
-	 * investigate.
-	 */
-	for (; fbdiv <= fbdiv_max; fbdiv++) {
-		u32 rem;
-
-		adj_dsi_htotal = (u64)fbdiv * pll_ref_hz * dsi_nlanes *
-				 dpi_htotal;
-
-		/*
-		 * Do the division in 2 steps to avoid an overflow on the
-		 * divider.
-		 */
-		rem = do_div(adj_dsi_htotal, dpi_hz);
-		if (rem)
-			continue;
-
-		rem = do_div(adj_dsi_htotal,
-			     cfg->pll_opdiv * cfg->pll_ipdiv * 2 * 8);
-		if (rem)
-			continue;
-
-		cfg->pll_fbdiv = fbdiv;
-		*dsi_hfp_ext = adj_dsi_htotal - dsi_htotal;
-		break;
-	}
-
-	/* No match, let's just reject the display mode. */
-	if (!cfg->pll_fbdiv)
-		return -EINVAL;
-
-	dlane_bps = DIV_ROUND_DOWN_ULL((u64)dpi_hz * adj_dsi_htotal * 8,
-				       dsi_nlanes * dpi_htotal);
-	cfg->lane_bps = dlane_bps;
-
-	return 0;
-}
-
-static int cdns_dphy_setup_psm(struct cdns_dphy *dphy)
-{
-	unsigned long psm_clk_hz = clk_get_rate(dphy->psm_clk);
-	unsigned long psm_div;
-
-	if (!psm_clk_hz || psm_clk_hz > 100000000)
-		return -EINVAL;
-
-	psm_div = DIV_ROUND_CLOSEST(psm_clk_hz, 1000000);
-	if (dphy->ops->set_psm_div)
-		dphy->ops->set_psm_div(dphy, psm_div);
-
-	return 0;
-}
-
-static void cdns_dphy_set_clk_lane_cfg(struct cdns_dphy *dphy,
-				       enum cdns_dphy_clk_lane_cfg cfg)
-{
-	if (dphy->ops->set_clk_lane_cfg)
-		dphy->ops->set_clk_lane_cfg(dphy, cfg);
-}
-
-static void cdns_dphy_set_pll_cfg(struct cdns_dphy *dphy,
-				  const struct cdns_dphy_cfg *cfg)
-{
-	if (dphy->ops->set_pll_cfg)
-		dphy->ops->set_pll_cfg(dphy, cfg);
-}
-
-static unsigned long cdns_dphy_get_wakeup_time_ns(struct cdns_dphy *dphy)
-{
-	return dphy->ops->get_wakeup_time_ns(dphy);
-}
-
 static unsigned int dpi_to_dsi_timing(unsigned int dpi_timing,
 				      unsigned int dpi_bpp,
 				      unsigned int dsi_pkt_overhead)
@@ -784,17 +549,20 @@ static int cdns_dsi_mode2cfg(struct cdns_dsi *dsi,
 	return 0;
 }
 
-static int cdns_dphy_validate(struct cdns_dsi *dsi,
+static int cdns_dsi_adjust_phy_config(struct cdns_dsi *dsi,
 			      struct cdns_dsi_cfg *dsi_cfg,
-			      struct cdns_dphy_cfg *dphy_cfg,
+			      struct phy_configure_opts_mipi_dphy *phy_cfg,
 			      const struct drm_display_mode *mode,
 			      bool mode_valid_check)
 {
 	struct cdns_dsi_output *output = &dsi->output;
+	unsigned long long dlane_bps;
+	unsigned long adj_dsi_htotal;
 	unsigned long dsi_htotal;
-	unsigned int dsi_hfp_ext = 0;
-
-	int ret;
+	unsigned long dpi_htotal;
+	unsigned long dpi_hz;
+	unsigned int dsi_hfp_ext;
+	unsigned int lanes = output->dev->lanes;
 
 	dsi_htotal = dsi_cfg->hbp + DSI_HBP_FRAME_OVERHEAD;
 	if (output->dev->mode_flags & MIPI_DSI_MODE_VIDEO_SYNC_PULSE)
@@ -803,25 +571,27 @@ static int cdns_dphy_validate(struct cdns_dsi *dsi,
 	dsi_htotal += dsi_cfg->hact;
 	dsi_htotal += dsi_cfg->hfp + DSI_HFP_FRAME_OVERHEAD;
 
-	if (mode_valid_check)
-		ret = cdns_dsi_get_dphy_pll_cfg(dsi->dphy, dphy_cfg,
-						mode->htotal,
-						mode->clock * 1000,
-						mipi_dsi_pixel_format_to_bpp(output->dev->format),
-						dsi_htotal,
-						output->dev->lanes,
-						&dsi_hfp_ext);
-	else
-		ret = cdns_dsi_get_dphy_pll_cfg(dsi->dphy, dphy_cfg,
-						mode->crtc_htotal,
-						mipi_dsi_pixel_format_to_bpp(output->dev->format),
-						mode->crtc_clock * 1000,
-						dsi_htotal,
-						output->dev->lanes,
-						&dsi_hfp_ext);
-	if (ret)
-		return ret;
+	/*
+	 * Make sure DSI htotal is aligned on a lane boundary when calculating
+	 * the expected data rate. This is done by extending HFP in case of
+	 * misalignment.
+	 */
+	adj_dsi_htotal = dsi_htotal;
+	if (dsi_htotal % lanes)
+		adj_dsi_htotal += lanes - (dsi_htotal % lanes);
+
+	dpi_hz = (mode_valid_check ? mode->clock : mode->crtc_clock) * 1000;
+	dlane_bps = (unsigned long long)dpi_hz * adj_dsi_htotal;
+
+	/* data rate in bytes/sec is not an integer, refuse the mode. */
+	dpi_htotal = mode_valid_check ? mode->htotal : mode->crtc_htotal;
+	if (do_div(dlane_bps, lanes * dpi_htotal))
+		return -EINVAL;
 
+	/* data rate was in bytes/sec, convert to bits/sec. */
+	phy_cfg->hs_clk_rate = dlane_bps * 8;
+
+	dsi_hfp_ext = adj_dsi_htotal - dsi_htotal;
 	dsi_cfg->hfp += dsi_hfp_ext;
 	dsi_cfg->htotal = dsi_htotal + dsi_hfp_ext;
 
@@ -831,10 +601,10 @@ static int cdns_dphy_validate(struct cdns_dsi *dsi,
 static int cdns_dsi_check_conf(struct cdns_dsi *dsi,
 			       const struct drm_display_mode *mode,
 			       struct cdns_dsi_cfg *dsi_cfg,
-			       struct cdns_dphy_cfg *dphy_cfg,
 			       bool mode_valid_check)
 {
 	struct cdns_dsi_output *output = &dsi->output;
+	struct phy_configure_opts_mipi_dphy *phy_cfg = &output->phy_opts.mipi_dphy;
 	unsigned long dsi_hss_hsa_hse_hbp;
 	unsigned int nlanes = output->dev->lanes;
 	int ret;
@@ -843,7 +613,15 @@ static int cdns_dsi_check_conf(struct cdns_dsi *dsi,
 	if (ret)
 		return ret;
 
-	ret = cdns_dphy_validate(dsi, dsi_cfg, dphy_cfg, mode, mode_valid_check);
+	phy_mipi_dphy_get_default_config(mode->crtc_clock * 1000,
+					 mipi_dsi_pixel_format_to_bpp(output->dev->format),
+					 nlanes, phy_cfg);
+
+	ret = cdns_dsi_adjust_phy_config(dsi, dsi_cfg, phy_cfg, mode, mode_valid_check);
+	if (ret)
+		return ret;
+
+	ret = phy_validate(dsi->dphy, PHY_MODE_MIPI_DPHY, 0, &output->phy_opts);
 	if (ret)
 		return ret;
 
@@ -856,7 +634,7 @@ static int cdns_dsi_check_conf(struct cdns_dsi *dsi,
 	 * is empty before we start a receiving a new line on the DPI
 	 * interface.
 	 */
-	if ((u64)dphy_cfg->lane_bps *
+	if ((u64)phy_cfg->hs_clk_rate *
 	    mode_to_dpi_hfp(mode, mode_valid_check) * nlanes <
 	    (u64)dsi_hss_hsa_hse_hbp *
 	    (mode_valid_check ? mode->clock : mode->crtc_clock) * 1000)
@@ -887,7 +665,6 @@ cdns_dsi_bridge_mode_valid(struct drm_bridge *bridge,
 	struct cdns_dsi_input *input = bridge_to_cdns_dsi_input(bridge);
 	struct cdns_dsi *dsi = input_to_dsi(input);
 	struct cdns_dsi_output *output = &dsi->output;
-	struct cdns_dphy_cfg dphy_cfg;
 	struct cdns_dsi_cfg dsi_cfg;
 	int bpp, ret;
 
@@ -907,7 +684,7 @@ cdns_dsi_bridge_mode_valid(struct drm_bridge *bridge,
 	if ((mode->hdisplay * bpp) % 32)
 		return MODE_H_ILLEGAL;
 
-	ret = cdns_dsi_check_conf(dsi, mode, &dsi_cfg, &dphy_cfg, true);
+	ret = cdns_dsi_check_conf(dsi, mode, &dsi_cfg, true);
 	if (ret)
 		return MODE_BAD;
 
@@ -930,9 +707,9 @@ static void cdns_dsi_bridge_disable(struct drm_bridge *bridge)
 	pm_runtime_put(dsi->base.dev);
 }
 
-static void cdns_dsi_hs_init(struct cdns_dsi *dsi,
-			     const struct cdns_dphy_cfg *dphy_cfg)
+static void cdns_dsi_hs_init(struct cdns_dsi *dsi)
 {
+	struct cdns_dsi_output *output = &dsi->output;
 	u32 status;
 
 	/*
@@ -943,30 +720,10 @@ static void cdns_dsi_hs_init(struct cdns_dsi *dsi,
 	       DPHY_CMN_PDN | DPHY_PLL_PDN,
 	       dsi->regs + MCTL_DPHY_CFG0);
 
-	/*
-	 * Configure the internal PSM clk divider so that the DPHY has a
-	 * 1MHz clk (or something close).
-	 */
-	WARN_ON_ONCE(cdns_dphy_setup_psm(dsi->dphy));
-
-	/*
-	 * Configure attach clk lanes to data lanes: the DPHY has 2 clk lanes
-	 * and 8 data lanes, each clk lane can be attache different set of
-	 * data lanes. The 2 groups are named 'left' and 'right', so here we
-	 * just say that we want the 'left' clk lane to drive the 'left' data
-	 * lanes.
-	 */
-	cdns_dphy_set_clk_lane_cfg(dsi->dphy, DPHY_CLK_CFG_LEFT_DRIVES_LEFT);
-
-	/*
-	 * Configure the DPHY PLL that will be used to generate the TX byte
-	 * clk.
-	 */
-	cdns_dphy_set_pll_cfg(dsi->dphy, dphy_cfg);
-
-	/* Start TX state machine. */
-	writel(DPHY_CMN_SSM_EN | DPHY_CMN_TX_MODE_EN,
-	       dsi->dphy->regs + DPHY_CMN_SSM);
+	phy_init(dsi->dphy);
+	phy_set_mode(dsi->dphy, PHY_MODE_MIPI_DPHY);
+	phy_configure(dsi->dphy, &output->phy_opts);
+	phy_power_on(dsi->dphy);
 
 	/* Activate the PLL and wait until it's locked. */
 	writel(PLL_LOCKED, dsi->regs + MCTL_MAIN_STS_CLR);
@@ -976,7 +733,7 @@ static void cdns_dsi_hs_init(struct cdns_dsi *dsi,
 					status & PLL_LOCKED, 100, 100));
 	/* De-assert data and clock reset lines. */
 	writel(DPHY_CMN_PSO | DPHY_ALL_D_PDN | DPHY_C_PDN | DPHY_CMN_PDN |
-	       DPHY_D_RSTB(dphy_cfg->nlanes) | DPHY_C_RSTB,
+	       DPHY_D_RSTB(output->dev->lanes) | DPHY_C_RSTB,
 	       dsi->regs + MCTL_DPHY_CFG0);
 }
 
@@ -1022,7 +779,7 @@ static void cdns_dsi_bridge_enable(struct drm_bridge *bridge)
 	struct cdns_dsi *dsi = input_to_dsi(input);
 	struct cdns_dsi_output *output = &dsi->output;
 	struct drm_display_mode *mode;
-	struct cdns_dphy_cfg dphy_cfg;
+	struct phy_configure_opts_mipi_dphy *phy_cfg = &output->phy_opts.mipi_dphy;
 	unsigned long tx_byte_period;
 	struct cdns_dsi_cfg dsi_cfg;
 	u32 tmp, reg_wakeup, div;
@@ -1035,9 +792,9 @@ static void cdns_dsi_bridge_enable(struct drm_bridge *bridge)
 	bpp = mipi_dsi_pixel_format_to_bpp(output->dev->format);
 	nlanes = output->dev->lanes;
 
-	WARN_ON_ONCE(cdns_dsi_check_conf(dsi, mode, &dsi_cfg, &dphy_cfg, false));
+	WARN_ON_ONCE(cdns_dsi_check_conf(dsi, mode, &dsi_cfg, false));
 
-	cdns_dsi_hs_init(dsi, &dphy_cfg);
+	cdns_dsi_hs_init(dsi);
 	cdns_dsi_init_link(dsi);
 
 	writel(HBP_LEN(dsi_cfg.hbp) | HSA_LEN(dsi_cfg.hsa),
@@ -1073,9 +830,8 @@ static void cdns_dsi_bridge_enable(struct drm_bridge *bridge)
 		tmp -= DIV_ROUND_UP(DSI_EOT_PKT_SIZE, nlanes);
 
 	tx_byte_period = DIV_ROUND_DOWN_ULL((u64)NSEC_PER_SEC * 8,
-					    dphy_cfg.lane_bps);
-	reg_wakeup = cdns_dphy_get_wakeup_time_ns(dsi->dphy) /
-		     tx_byte_period;
+					    phy_cfg->hs_clk_rate);
+	reg_wakeup = (phy_cfg->hs_prepare + phy_cfg->hs_zero) / tx_byte_period;
 	writel(REG_WAKEUP_TIME(reg_wakeup) | REG_LINE_DURATION(tmp),
 	       dsi->regs + VID_DPHY_TIME);
 
@@ -1389,8 +1145,6 @@ static int __maybe_unused cdns_dsi_resume(struct device *dev)
 	reset_control_deassert(dsi->dsi_p_rst);
 	clk_prepare_enable(dsi->dsi_p_clk);
 	clk_prepare_enable(dsi->dsi_sys_clk);
-	clk_prepare_enable(dsi->dphy->psm_clk);
-	clk_prepare_enable(dsi->dphy->pll_ref_clk);
 
 	return 0;
 }
@@ -1399,8 +1153,6 @@ static int __maybe_unused cdns_dsi_suspend(struct device *dev)
 {
 	struct cdns_dsi *dsi = dev_get_drvdata(dev);
 
-	clk_disable_unprepare(dsi->dphy->pll_ref_clk);
-	clk_disable_unprepare(dsi->dphy->psm_clk);
 	clk_disable_unprepare(dsi->dsi_sys_clk);
 	clk_disable_unprepare(dsi->dsi_p_clk);
 	reset_control_assert(dsi->dsi_p_rst);
@@ -1411,121 +1163,6 @@ static int __maybe_unused cdns_dsi_suspend(struct device *dev)
 static UNIVERSAL_DEV_PM_OPS(cdns_dsi_pm_ops, cdns_dsi_suspend, cdns_dsi_resume,
 			    NULL);
 
-static unsigned long cdns_dphy_ref_get_wakeup_time_ns(struct cdns_dphy *dphy)
-{
-	/* Default wakeup time is 800 ns (in a simulated environment). */
-	return 800;
-}
-
-static void cdns_dphy_ref_set_pll_cfg(struct cdns_dphy *dphy,
-				      const struct cdns_dphy_cfg *cfg)
-{
-	u32 fbdiv_low, fbdiv_high;
-
-	fbdiv_low = (cfg->pll_fbdiv / 4) - 2;
-	fbdiv_high = cfg->pll_fbdiv - fbdiv_low - 2;
-
-	writel(DPHY_CMN_IPDIV_FROM_REG | DPHY_CMN_OPDIV_FROM_REG |
-	       DPHY_CMN_IPDIV(cfg->pll_ipdiv) |
-	       DPHY_CMN_OPDIV(cfg->pll_opdiv),
-	       dphy->regs + DPHY_CMN_OPIPDIV);
-	writel(DPHY_CMN_FBDIV_FROM_REG |
-	       DPHY_CMN_FBDIV_VAL(fbdiv_low, fbdiv_high),
-	       dphy->regs + DPHY_CMN_FBDIV);
-	writel(DPHY_CMN_PWM_HIGH(6) | DPHY_CMN_PWM_LOW(0x101) |
-	       DPHY_CMN_PWM_DIV(0x8),
-	       dphy->regs + DPHY_CMN_PWM);
-}
-
-static void cdns_dphy_ref_set_psm_div(struct cdns_dphy *dphy, u8 div)
-{
-	writel(DPHY_PSM_CFG_FROM_REG | DPHY_PSM_CLK_DIV(div),
-	       dphy->regs + DPHY_PSM_CFG);
-}
-
-/*
- * This is the reference implementation of DPHY hooks. Specific integration of
- * this IP may have to re-implement some of them depending on how they decided
- * to wire things in the SoC.
- */
-static const struct cdns_dphy_ops ref_dphy_ops = {
-	.get_wakeup_time_ns = cdns_dphy_ref_get_wakeup_time_ns,
-	.set_pll_cfg = cdns_dphy_ref_set_pll_cfg,
-	.set_psm_div = cdns_dphy_ref_set_psm_div,
-};
-
-static const struct of_device_id cdns_dphy_of_match[] = {
-	{ .compatible = "cdns,dphy", .data = &ref_dphy_ops },
-	{ /* sentinel */ },
-};
-
-static struct cdns_dphy *cdns_dphy_probe(struct platform_device *pdev)
-{
-	const struct of_device_id *match;
-	struct cdns_dphy *dphy;
-	struct of_phandle_args args;
-	struct resource res;
-	int ret;
-
-	ret = of_parse_phandle_with_args(pdev->dev.of_node, "phys",
-					 "#phy-cells", 0, &args);
-	if (ret)
-		return ERR_PTR(-ENOENT);
-
-	match = of_match_node(cdns_dphy_of_match, args.np);
-	if (!match || !match->data)
-		return ERR_PTR(-EINVAL);
-
-	dphy = devm_kzalloc(&pdev->dev, sizeof(*dphy), GFP_KERNEL);
-	if (!dphy)
-		return ERR_PTR(-ENOMEM);
-
-	dphy->ops = match->data;
-
-	ret = of_address_to_resource(args.np, 0, &res);
-	if (ret)
-		return ERR_PTR(ret);
-
-	dphy->regs = devm_ioremap_resource(&pdev->dev, &res);
-	if (IS_ERR(dphy->regs))
-		return ERR_CAST(dphy->regs);
-
-	dphy->psm_clk = of_clk_get_by_name(args.np, "psm");
-	if (IS_ERR(dphy->psm_clk))
-		return ERR_CAST(dphy->psm_clk);
-
-	dphy->pll_ref_clk = of_clk_get_by_name(args.np, "pll_ref");
-	if (IS_ERR(dphy->pll_ref_clk)) {
-		ret = PTR_ERR(dphy->pll_ref_clk);
-		goto err_put_psm_clk;
-	}
-
-	if (dphy->ops->probe) {
-		ret = dphy->ops->probe(dphy);
-		if (ret)
-			goto err_put_pll_ref_clk;
-	}
-
-	return dphy;
-
-err_put_pll_ref_clk:
-	clk_put(dphy->pll_ref_clk);
-
-err_put_psm_clk:
-	clk_put(dphy->psm_clk);
-
-	return ERR_PTR(ret);
-}
-
-static void cdns_dphy_remove(struct cdns_dphy *dphy)
-{
-	if (dphy->ops->remove)
-		dphy->ops->remove(dphy);
-
-	clk_put(dphy->pll_ref_clk);
-	clk_put(dphy->psm_clk);
-}
-
 static int cdns_dsi_drm_probe(struct platform_device *pdev)
 {
 	struct cdns_dsi *dsi;
@@ -1564,13 +1201,13 @@ static int cdns_dsi_drm_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	dsi->dphy = cdns_dphy_probe(pdev);
+	dsi->dphy = devm_phy_get(&pdev->dev, "dphy");
 	if (IS_ERR(dsi->dphy))
 		return PTR_ERR(dsi->dphy);
 
 	ret = clk_prepare_enable(dsi->dsi_p_clk);
 	if (ret)
-		goto err_remove_dphy;
+		return ret;
 
 	val = readl(dsi->regs + ID_REG);
 	if (REV_VENDOR_ID(val) != 0xcad) {
@@ -1628,9 +1265,6 @@ static int cdns_dsi_drm_probe(struct platform_device *pdev)
 err_disable_pclk:
 	clk_disable_unprepare(dsi->dsi_p_clk);
 
-err_remove_dphy:
-	cdns_dphy_remove(dsi->dphy);
-
 	return ret;
 }
 
@@ -1640,7 +1274,6 @@ static int cdns_dsi_drm_remove(struct platform_device *pdev)
 
 	mipi_dsi_host_unregister(&dsi->base);
 	pm_runtime_disable(&pdev->dev);
-	cdns_dphy_remove(dsi->dphy);
 
 	return 0;
 }
-- 
git-series 0.9.1
