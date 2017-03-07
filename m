Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:36446 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752207AbdCGRMK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 12:12:10 -0500
Received: by mail-wr0-f174.google.com with SMTP id u108so6053523wrb.3
        for <linux-media@vger.kernel.org>; Tue, 07 Mar 2017 09:11:33 -0800 (PST)
From: Neil Armstrong <narmstrong@baylibre.com>
To: dri-devel@lists.freedesktop.org,
        laurent.pinchart+renesas@ideasonboard.com, architt@codeaurora.org
Cc: Jose.Abreu@synopsys.com, kieran.bingham@ideasonboard.com,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH v3 1/6] drm: bridge: dw-hdmi: Extract PHY interrupt setup to a function
Date: Tue,  7 Mar 2017 17:42:19 +0100
Message-Id: <1488904944-14285-2-git-send-email-narmstrong@baylibre.com>
In-Reply-To: <1488904944-14285-1-git-send-email-narmstrong@baylibre.com>
References: <1488904944-14285-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

In preparation for adding PHY operations to handle RX SENSE and HPD,
group all the PHY interrupt setup code in a single location and extract
it to a separate function.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 50 ++++++++++++++-----------------
 1 file changed, 23 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
index 026a0dc..1ed8bc1 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -1496,7 +1496,7 @@ static int dw_hdmi_setup(struct dw_hdmi *hdmi, struct drm_display_mode *mode)
 }
 
 /* Wait until we are registered to enable interrupts */
-static int dw_hdmi_fb_registered(struct dw_hdmi *hdmi)
+static void dw_hdmi_fb_registered(struct dw_hdmi *hdmi)
 {
 	hdmi_writeb(hdmi, HDMI_PHY_I2CM_INT_ADDR_DONE_POL,
 		    HDMI_PHY_I2CM_INT_ADDR);
@@ -1504,15 +1504,6 @@ static int dw_hdmi_fb_registered(struct dw_hdmi *hdmi)
 	hdmi_writeb(hdmi, HDMI_PHY_I2CM_CTLINT_ADDR_NAC_POL |
 		    HDMI_PHY_I2CM_CTLINT_ADDR_ARBITRATION_POL,
 		    HDMI_PHY_I2CM_CTLINT_ADDR);
-
-	/* enable cable hot plug irq */
-	hdmi_writeb(hdmi, hdmi->phy_mask, HDMI_PHY_MASK0);
-
-	/* Clear Hotplug interrupts */
-	hdmi_writeb(hdmi, HDMI_IH_PHY_STAT0_HPD | HDMI_IH_PHY_STAT0_RX_SENSE,
-		    HDMI_IH_PHY_STAT0);
-
-	return 0;
 }
 
 static void initialize_hdmi_ih_mutes(struct dw_hdmi *hdmi)
@@ -1630,6 +1621,26 @@ static void dw_hdmi_update_phy_mask(struct dw_hdmi *hdmi)
 		hdmi_writeb(hdmi, hdmi->phy_mask, HDMI_PHY_MASK0);
 }
 
+static void dw_hdmi_phy_setup_hpd(struct dw_hdmi *hdmi)
+{
+	/*
+	 * Configure the PHY RX SENSE and HPD interrupts polarities and clear
+	 * any pending interrupt.
+	 */
+	hdmi_writeb(hdmi, HDMI_PHY_HPD | HDMI_PHY_RX_SENSE, HDMI_PHY_POL0);
+	hdmi_writeb(hdmi, HDMI_IH_PHY_STAT0_HPD | HDMI_IH_PHY_STAT0_RX_SENSE,
+		    HDMI_IH_PHY_STAT0);
+
+	/* Enable cable hot plug irq. */
+	hdmi_writeb(hdmi, hdmi->phy_mask, HDMI_PHY_MASK0);
+
+	/* Clear and unmute interrupts. */
+	hdmi_writeb(hdmi, HDMI_IH_PHY_STAT0_HPD | HDMI_IH_PHY_STAT0_RX_SENSE,
+		    HDMI_IH_PHY_STAT0);
+	hdmi_writeb(hdmi, ~(HDMI_IH_PHY_STAT0_HPD | HDMI_IH_PHY_STAT0_RX_SENSE),
+		    HDMI_IH_MUTE_PHY_STAT0);
+}
+
 static enum drm_connector_status
 dw_hdmi_connector_detect(struct drm_connector *connector, bool force)
 {
@@ -2141,29 +2152,14 @@ static int dw_hdmi_detect_phy(struct dw_hdmi *hdmi)
 			hdmi->ddc = NULL;
 	}
 
-	/*
-	 * Configure registers related to HDMI interrupt
-	 * generation before registering IRQ.
-	 */
-	hdmi_writeb(hdmi, HDMI_PHY_HPD | HDMI_PHY_RX_SENSE, HDMI_PHY_POL0);
-
-	/* Clear Hotplug interrupts */
-	hdmi_writeb(hdmi, HDMI_IH_PHY_STAT0_HPD | HDMI_IH_PHY_STAT0_RX_SENSE,
-		    HDMI_IH_PHY_STAT0);
-
 	hdmi->bridge.driver_private = hdmi;
 	hdmi->bridge.funcs = &dw_hdmi_bridge_funcs;
 #ifdef CONFIG_OF
 	hdmi->bridge.of_node = pdev->dev.of_node;
 #endif
 
-	ret = dw_hdmi_fb_registered(hdmi);
-	if (ret)
-		goto err_iahb;
-
-	/* Unmute interrupts */
-	hdmi_writeb(hdmi, ~(HDMI_IH_PHY_STAT0_HPD | HDMI_IH_PHY_STAT0_RX_SENSE),
-		    HDMI_IH_MUTE_PHY_STAT0);
+	dw_hdmi_fb_registered(hdmi);
+	dw_hdmi_phy_setup_hpd(hdmi);
 
 	memset(&pdevinfo, 0, sizeof(pdevinfo));
 	pdevinfo.parent = dev;
-- 
1.9.1
