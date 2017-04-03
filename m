Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:33999 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753605AbdDCOmx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 10:42:53 -0400
Received: by mail-lf0-f53.google.com with SMTP id z15so75754752lfd.1
        for <linux-media@vger.kernel.org>; Mon, 03 Apr 2017 07:42:52 -0700 (PDT)
From: Neil Armstrong <narmstrong@baylibre.com>
To: dri-devel@lists.freedesktop.org,
        laurent.pinchart+renesas@ideasonboard.com, architt@codeaurora.org
Cc: Neil Armstrong <narmstrong@baylibre.com>, Jose.Abreu@synopsys.com,
        kieran.bingham@ideasonboard.com, linux-amlogic@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH v6 6/6] drm: bridge: dw-hdmi: Move HPD handling to PHY operations
Date: Mon,  3 Apr 2017 16:42:38 +0200
Message-Id: <1491230558-10804-7-git-send-email-narmstrong@baylibre.com>
In-Reply-To: <1491230558-10804-1-git-send-email-narmstrong@baylibre.com>
References: <1491230558-10804-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The HDMI TX controller support HPD and RXSENSE signaling from the PHY
via it's STAT0 PHY interface, but some vendor PHYs can manage these
signals independently from the controller, thus these STAT0 handling
should be moved to PHY specific operations and become optional.

The existing STAT0 HPD and RXSENSE handling code is refactored into
a supplementaty set of default PHY operations that are used automatically
when the platform glue doesn't provide its own operations.

Reviewed-by: Jose Abreu <joabreu@synopsys.com>
Reviewed-by: Archit Taneja <architt@codeaurora.org>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 135 ++++++++++++++++++------------
 include/drm/bridge/dw_hdmi.h              |   5 ++
 2 files changed, 86 insertions(+), 54 deletions(-)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
index 16d5fff3..84cc949 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -1229,10 +1229,46 @@ static enum drm_connector_status dw_hdmi_phy_read_hpd(struct dw_hdmi *hdmi,
 		connector_status_connected : connector_status_disconnected;
 }
 
+static void dw_hdmi_phy_update_hpd(struct dw_hdmi *hdmi, void *data,
+				   bool force, bool disabled, bool rxsense)
+{
+	u8 old_mask = hdmi->phy_mask;
+
+	if (force || disabled || !rxsense)
+		hdmi->phy_mask |= HDMI_PHY_RX_SENSE;
+	else
+		hdmi->phy_mask &= ~HDMI_PHY_RX_SENSE;
+
+	if (old_mask != hdmi->phy_mask)
+		hdmi_writeb(hdmi, hdmi->phy_mask, HDMI_PHY_MASK0);
+}
+
+static void dw_hdmi_phy_setup_hpd(struct dw_hdmi *hdmi, void *data)
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
 static const struct dw_hdmi_phy_ops dw_hdmi_synopsys_phy_ops = {
 	.init = dw_hdmi_phy_init,
 	.disable = dw_hdmi_phy_disable,
 	.read_hpd = dw_hdmi_phy_read_hpd,
+	.update_hpd = dw_hdmi_phy_update_hpd,
+	.setup_hpd = dw_hdmi_phy_setup_hpd,
 };
 
 /* -----------------------------------------------------------------------------
@@ -1808,35 +1844,10 @@ static void dw_hdmi_update_power(struct dw_hdmi *hdmi)
  */
 static void dw_hdmi_update_phy_mask(struct dw_hdmi *hdmi)
 {
-	u8 old_mask = hdmi->phy_mask;
-
-	if (hdmi->force || hdmi->disabled || !hdmi->rxsense)
-		hdmi->phy_mask |= HDMI_PHY_RX_SENSE;
-	else
-		hdmi->phy_mask &= ~HDMI_PHY_RX_SENSE;
-
-	if (old_mask != hdmi->phy_mask)
-		hdmi_writeb(hdmi, hdmi->phy_mask, HDMI_PHY_MASK0);
-}
-
-static void dw_hdmi_phy_setup_hpd(struct dw_hdmi *hdmi)
-{
-	/*
-	 * Configure the PHY RX SENSE and HPD interrupts polarities and clear
-	 * any pending interrupt.
-	 */
-	hdmi_writeb(hdmi, HDMI_PHY_HPD | HDMI_PHY_RX_SENSE, HDMI_PHY_POL0);
-	hdmi_writeb(hdmi, HDMI_IH_PHY_STAT0_HPD | HDMI_IH_PHY_STAT0_RX_SENSE,
-		    HDMI_IH_PHY_STAT0);
-
-	/* Enable cable hot plug irq. */
-	hdmi_writeb(hdmi, hdmi->phy_mask, HDMI_PHY_MASK0);
-
-	/* Clear and unmute interrupts. */
-	hdmi_writeb(hdmi, HDMI_IH_PHY_STAT0_HPD | HDMI_IH_PHY_STAT0_RX_SENSE,
-		    HDMI_IH_PHY_STAT0);
-	hdmi_writeb(hdmi, ~(HDMI_IH_PHY_STAT0_HPD | HDMI_IH_PHY_STAT0_RX_SENSE),
-		    HDMI_IH_MUTE_PHY_STAT0);
+	if (hdmi->phy.ops->update_hpd)
+		hdmi->phy.ops->update_hpd(hdmi, hdmi->phy.data,
+					  hdmi->force, hdmi->disabled,
+					  hdmi->rxsense);
 }
 
 static enum drm_connector_status
@@ -2028,6 +2039,41 @@ static irqreturn_t dw_hdmi_hardirq(int irq, void *dev_id)
 	return ret;
 }
 
+void __dw_hdmi_setup_rx_sense(struct dw_hdmi *hdmi, bool hpd, bool rx_sense)
+{
+	mutex_lock(&hdmi->mutex);
+
+	if (!hdmi->force) {
+		/*
+		 * If the RX sense status indicates we're disconnected,
+		 * clear the software rxsense status.
+		 */
+		if (!rx_sense)
+			hdmi->rxsense = false;
+
+		/*
+		 * Only set the software rxsense status when both
+		 * rxsense and hpd indicates we're connected.
+		 * This avoids what seems to be bad behaviour in
+		 * at least iMX6S versions of the phy.
+		 */
+		if (hpd)
+			hdmi->rxsense = true;
+
+		dw_hdmi_update_power(hdmi);
+		dw_hdmi_update_phy_mask(hdmi);
+	}
+	mutex_unlock(&hdmi->mutex);
+}
+
+void dw_hdmi_setup_rx_sense(struct device *dev, bool hpd, bool rx_sense)
+{
+	struct dw_hdmi *hdmi = dev_get_drvdata(dev);
+
+	__dw_hdmi_setup_rx_sense(hdmi, hpd, rx_sense);
+}
+EXPORT_SYMBOL_GPL(dw_hdmi_setup_rx_sense);
+
 static irqreturn_t dw_hdmi_irq(int irq, void *dev_id)
 {
 	struct dw_hdmi *hdmi = dev_id;
@@ -2060,30 +2106,10 @@ static irqreturn_t dw_hdmi_irq(int irq, void *dev_id)
 	 * ask the source to re-read the EDID.
 	 */
 	if (intr_stat &
-	    (HDMI_IH_PHY_STAT0_RX_SENSE | HDMI_IH_PHY_STAT0_HPD)) {
-		mutex_lock(&hdmi->mutex);
-		if (!hdmi->force) {
-			/*
-			 * If the RX sense status indicates we're disconnected,
-			 * clear the software rxsense status.
-			 */
-			if (!(phy_stat & HDMI_PHY_RX_SENSE))
-				hdmi->rxsense = false;
-
-			/*
-			 * Only set the software rxsense status when both
-			 * rxsense and hpd indicates we're connected.
-			 * This avoids what seems to be bad behaviour in
-			 * at least iMX6S versions of the phy.
-			 */
-			if (phy_stat & HDMI_PHY_HPD)
-				hdmi->rxsense = true;
-
-			dw_hdmi_update_power(hdmi);
-			dw_hdmi_update_phy_mask(hdmi);
-		}
-		mutex_unlock(&hdmi->mutex);
-	}
+	    (HDMI_IH_PHY_STAT0_RX_SENSE | HDMI_IH_PHY_STAT0_HPD))
+		__dw_hdmi_setup_rx_sense(hdmi,
+					 phy_stat & HDMI_PHY_HPD,
+					 phy_stat & HDMI_PHY_RX_SENSE);
 
 	if (intr_stat & HDMI_IH_PHY_STAT0_HPD) {
 		dev_dbg(hdmi->dev, "EVENT=%s\n",
@@ -2357,7 +2383,8 @@ static int dw_hdmi_detect_phy(struct dw_hdmi *hdmi)
 #endif
 
 	dw_hdmi_setup_i2c(hdmi);
-	dw_hdmi_phy_setup_hpd(hdmi);
+	if (hdmi->phy.ops->setup_hpd)
+		hdmi->phy.ops->setup_hpd(hdmi, hdmi->phy.data);
 
 	memset(&pdevinfo, 0, sizeof(pdevinfo));
 	pdevinfo.parent = dev;
diff --git a/include/drm/bridge/dw_hdmi.h b/include/drm/bridge/dw_hdmi.h
index 45c2c15..e63d675 100644
--- a/include/drm/bridge/dw_hdmi.h
+++ b/include/drm/bridge/dw_hdmi.h
@@ -117,6 +117,9 @@ struct dw_hdmi_phy_ops {
 		    struct drm_display_mode *mode);
 	void (*disable)(struct dw_hdmi *hdmi, void *data);
 	enum drm_connector_status (*read_hpd)(struct dw_hdmi *hdmi, void *data);
+	void (*update_hpd)(struct dw_hdmi *hdmi, void *data,
+			   bool force, bool disabled, bool rxsense);
+	void (*setup_hpd)(struct dw_hdmi *hdmi, void *data);
 };
 
 struct dw_hdmi_plat_data {
@@ -147,6 +150,8 @@ int dw_hdmi_probe(struct platform_device *pdev,
 int dw_hdmi_bind(struct platform_device *pdev, struct drm_encoder *encoder,
 		 const struct dw_hdmi_plat_data *plat_data);
 
+void dw_hdmi_setup_rx_sense(struct device *dev, bool hpd, bool rx_sense);
+
 void dw_hdmi_set_sample_rate(struct dw_hdmi *hdmi, unsigned int rate);
 void dw_hdmi_audio_enable(struct dw_hdmi *hdmi);
 void dw_hdmi_audio_disable(struct dw_hdmi *hdmi);
-- 
1.9.1
