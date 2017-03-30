Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:33585 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753755AbdC3JEq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 05:04:46 -0400
Received: by mail-wr0-f170.google.com with SMTP id w43so50972034wrb.0
        for <linux-media@vger.kernel.org>; Thu, 30 Mar 2017 02:04:45 -0700 (PDT)
From: Neil Armstrong <narmstrong@baylibre.com>
To: dri-devel@lists.freedesktop.org,
        laurent.pinchart+renesas@ideasonboard.com, architt@codeaurora.org
Cc: Jose.Abreu@synopsys.com, kieran.bingham@ideasonboard.com,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH v5 1/6] drm: bridge: dw-hdmi: Extract PHY interrupt setup to a function
Date: Thu, 30 Mar 2017 11:04:30 +0200
Message-Id: <1490864675-17336-2-git-send-email-narmstrong@baylibre.com>
In-Reply-To: <1490864675-17336-1-git-send-email-narmstrong@baylibre.com>
References: <1490864675-17336-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

In preparation for adding PHY operations to handle RX SENSE and HPD,
group all the PHY interrupt setup code in a single location and extract
it to a separate function.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Jose Abreu <joabreu@synopsys.com>
[narmstrong: renamed dw_hdmi_fb_registered to dw_hdmi_setup_i2c]

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 51 ++++++++++++++-----------------
 1 file changed, 23 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
index 32f02e9..ff1fae3 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -1558,8 +1558,7 @@ static int dw_hdmi_setup(struct dw_hdmi *hdmi, struct drm_display_mode *mode)
 	return 0;
 }
 
-/* Wait until we are registered to enable interrupts */
-static int dw_hdmi_fb_registered(struct dw_hdmi *hdmi)
+static void dw_hdmi_setup_i2c(struct dw_hdmi *hdmi)
 {
 	hdmi_writeb(hdmi, HDMI_PHY_I2CM_INT_ADDR_DONE_POL,
 		    HDMI_PHY_I2CM_INT_ADDR);
@@ -1567,15 +1566,6 @@ static int dw_hdmi_fb_registered(struct dw_hdmi *hdmi)
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
@@ -1693,6 +1683,26 @@ static void dw_hdmi_update_phy_mask(struct dw_hdmi *hdmi)
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
@@ -2204,29 +2214,14 @@ static int dw_hdmi_detect_phy(struct dw_hdmi *hdmi)
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
+	dw_hdmi_setup_i2c(hdmi);
+	dw_hdmi_phy_setup_hpd(hdmi);
 
 	memset(&pdevinfo, 0, sizeof(pdevinfo));
 	pdevinfo.parent = dev;
-- 
1.9.1
