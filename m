Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:54541 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752384AbdHBSlO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Aug 2017 14:41:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCHv3 2/4] drm/bridge: dw-hdmi: add better clock disable control
Date: Wed,  2 Aug 2017 20:41:06 +0200
Message-Id: <20170802184108.7913-3-hverkuil@xs4all.nl>
In-Reply-To: <20170802184108.7913-1-hverkuil@xs4all.nl>
References: <20170802184108.7913-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Russell King <rmk+kernel@armlinux.org.uk>

The video setup path aways sets the clock disable register to a specific
value, which has the effect of disabling the CEC engine.  When we add the
CEC driver, this becomes a problem.

Fix this by only setting/clearing the bits that the video path needs to.

Reviewed-by: Jose Abreu <joabreu@synopsys.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
index 108495862cac..0ac1e3240cc3 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -166,6 +166,7 @@ struct dw_hdmi {
 	bool bridge_is_on;		/* indicates the bridge is on */
 	bool rxsense;			/* rxsense state */
 	u8 phy_mask;			/* desired phy int mask settings */
+	u8 mc_clkdis;			/* clock disable register */
 
 	spinlock_t audio_lock;
 	struct mutex audio_mutex;
@@ -551,8 +552,11 @@ EXPORT_SYMBOL_GPL(dw_hdmi_set_sample_rate);
 
 static void hdmi_enable_audio_clk(struct dw_hdmi *hdmi, bool enable)
 {
-	hdmi_modb(hdmi, enable ? 0 : HDMI_MC_CLKDIS_AUDCLK_DISABLE,
-		  HDMI_MC_CLKDIS_AUDCLK_DISABLE, HDMI_MC_CLKDIS);
+	if (enable)
+		hdmi->mc_clkdis &= ~HDMI_MC_CLKDIS_AUDCLK_DISABLE;
+	else
+		hdmi->mc_clkdis |= HDMI_MC_CLKDIS_AUDCLK_DISABLE;
+	hdmi_writeb(hdmi, hdmi->mc_clkdis, HDMI_MC_CLKDIS);
 }
 
 static void dw_hdmi_ahb_audio_enable(struct dw_hdmi *hdmi)
@@ -1574,8 +1578,6 @@ static void hdmi_av_composer(struct dw_hdmi *hdmi,
 /* HDMI Initialization Step B.4 */
 static void dw_hdmi_enable_video_path(struct dw_hdmi *hdmi)
 {
-	u8 clkdis;
-
 	/* control period minimum duration */
 	hdmi_writeb(hdmi, 12, HDMI_FC_CTRLDUR);
 	hdmi_writeb(hdmi, 32, HDMI_FC_EXCTRLDUR);
@@ -1587,17 +1589,21 @@ static void dw_hdmi_enable_video_path(struct dw_hdmi *hdmi)
 	hdmi_writeb(hdmi, 0x21, HDMI_FC_CH2PREAM);
 
 	/* Enable pixel clock and tmds data path */
-	clkdis = 0x7F;
-	clkdis &= ~HDMI_MC_CLKDIS_PIXELCLK_DISABLE;
-	hdmi_writeb(hdmi, clkdis, HDMI_MC_CLKDIS);
+	hdmi->mc_clkdis |= HDMI_MC_CLKDIS_HDCPCLK_DISABLE |
+			   HDMI_MC_CLKDIS_CSCCLK_DISABLE |
+			   HDMI_MC_CLKDIS_AUDCLK_DISABLE |
+			   HDMI_MC_CLKDIS_PREPCLK_DISABLE |
+			   HDMI_MC_CLKDIS_TMDSCLK_DISABLE;
+	hdmi->mc_clkdis &= ~HDMI_MC_CLKDIS_PIXELCLK_DISABLE;
+	hdmi_writeb(hdmi, hdmi->mc_clkdis, HDMI_MC_CLKDIS);
 
-	clkdis &= ~HDMI_MC_CLKDIS_TMDSCLK_DISABLE;
-	hdmi_writeb(hdmi, clkdis, HDMI_MC_CLKDIS);
+	hdmi->mc_clkdis &= ~HDMI_MC_CLKDIS_TMDSCLK_DISABLE;
+	hdmi_writeb(hdmi, hdmi->mc_clkdis, HDMI_MC_CLKDIS);
 
 	/* Enable csc path */
 	if (is_color_space_conversion(hdmi)) {
-		clkdis &= ~HDMI_MC_CLKDIS_CSCCLK_DISABLE;
-		hdmi_writeb(hdmi, clkdis, HDMI_MC_CLKDIS);
+		hdmi->mc_clkdis &= ~HDMI_MC_CLKDIS_CSCCLK_DISABLE;
+		hdmi_writeb(hdmi, hdmi->mc_clkdis, HDMI_MC_CLKDIS);
 	}
 
 	/* Enable color space conversion if needed */
@@ -2272,6 +2278,7 @@ __dw_hdmi_probe(struct platform_device *pdev,
 	hdmi->disabled = true;
 	hdmi->rxsense = true;
 	hdmi->phy_mask = (u8)~(HDMI_PHY_HPD | HDMI_PHY_RX_SENSE);
+	hdmi->mc_clkdis = 0x7f;
 
 	mutex_init(&hdmi->mutex);
 	mutex_init(&hdmi->audio_mutex);
-- 
2.13.2
