Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:56785 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752380AbdHBSlO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Aug 2017 14:41:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCHv3 1/4] drm/bridge: dw-hdmi: add cec notifier support
Date: Wed,  2 Aug 2017 20:41:05 +0200
Message-Id: <20170802184108.7913-2-hverkuil@xs4all.nl>
In-Reply-To: <20170802184108.7913-1-hverkuil@xs4all.nl>
References: <20170802184108.7913-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Russell King <rmk+kernel@armlinux.org.uk>

Add CEC notifier support to the HDMI bridge driver, so that the CEC
part of the IP can receive its physical address.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
[hans.verkuil: added missing cec_notifier_put to remove()]
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/gpu/drm/bridge/synopsys/Kconfig   |  1 +
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 25 ++++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/synopsys/Kconfig b/drivers/gpu/drm/bridge/synopsys/Kconfig
index 53e78d092d18..351db000599a 100644
--- a/drivers/gpu/drm/bridge/synopsys/Kconfig
+++ b/drivers/gpu/drm/bridge/synopsys/Kconfig
@@ -2,6 +2,7 @@ config DRM_DW_HDMI
 	tristate
 	select DRM_KMS_HELPER
 	select REGMAP_MMIO
+	select CEC_CORE if CEC_NOTIFIER
 
 config DRM_DW_HDMI_AHB_AUDIO
 	tristate "Synopsys Designware AHB Audio interface"
diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
index ead11242c4b9..108495862cac 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -36,7 +36,10 @@
 #include "dw-hdmi.h"
 #include "dw-hdmi-audio.h"
 
+#include <media/cec-notifier.h>
+
 #define DDC_SEGMENT_ADDR	0x30
+
 #define HDMI_EDID_LEN		512
 
 enum hdmi_datamap {
@@ -175,6 +178,8 @@ struct dw_hdmi {
 	struct regmap *regm;
 	void (*enable_audio)(struct dw_hdmi *hdmi);
 	void (*disable_audio)(struct dw_hdmi *hdmi);
+
+	struct cec_notifier *cec_notifier;
 };
 
 #define HDMI_IH_PHY_STAT0_RX_SENSE \
@@ -1896,6 +1901,7 @@ static int dw_hdmi_connector_get_modes(struct drm_connector *connector)
 		hdmi->sink_is_hdmi = drm_detect_hdmi_monitor(edid);
 		hdmi->sink_has_audio = drm_detect_monitor_audio(edid);
 		drm_mode_connector_update_edid_property(connector, edid);
+		cec_notifier_set_phys_addr_from_edid(hdmi->cec_notifier, edid);
 		ret = drm_add_edid_modes(connector, edid);
 		/* Store the ELD */
 		drm_edid_to_eld(connector, edid);
@@ -2119,11 +2125,16 @@ static irqreturn_t dw_hdmi_irq(int irq, void *dev_id)
 	 * ask the source to re-read the EDID.
 	 */
 	if (intr_stat &
-	    (HDMI_IH_PHY_STAT0_RX_SENSE | HDMI_IH_PHY_STAT0_HPD))
+	    (HDMI_IH_PHY_STAT0_RX_SENSE | HDMI_IH_PHY_STAT0_HPD)) {
 		__dw_hdmi_setup_rx_sense(hdmi,
 					 phy_stat & HDMI_PHY_HPD,
 					 phy_stat & HDMI_PHY_RX_SENSE);
 
+		if ((phy_stat & (HDMI_PHY_RX_SENSE | HDMI_PHY_HPD)) == 0)
+			cec_notifier_set_phys_addr(hdmi->cec_notifier,
+						   CEC_PHYS_ADDR_INVALID);
+	}
+
 	if (intr_stat & HDMI_IH_PHY_STAT0_HPD) {
 		dev_dbg(hdmi->dev, "EVENT=%s\n",
 			phy_int_pol & HDMI_PHY_HPD ? "plugin" : "plugout");
@@ -2376,6 +2387,12 @@ __dw_hdmi_probe(struct platform_device *pdev,
 	if (ret)
 		goto err_iahb;
 
+	hdmi->cec_notifier = cec_notifier_get(dev);
+	if (!hdmi->cec_notifier) {
+		ret = -ENOMEM;
+		goto err_iahb;
+	}
+
 	/*
 	 * To prevent overflows in HDMI_IH_FC_STAT2, set the clk regenerator
 	 * N and cts values before enabling phy
@@ -2452,6 +2469,9 @@ __dw_hdmi_probe(struct platform_device *pdev,
 		hdmi->ddc = NULL;
 	}
 
+	if (hdmi->cec_notifier)
+		cec_notifier_put(hdmi->cec_notifier);
+
 	clk_disable_unprepare(hdmi->iahb_clk);
 err_isfr:
 	clk_disable_unprepare(hdmi->isfr_clk);
@@ -2469,6 +2489,9 @@ static void __dw_hdmi_remove(struct dw_hdmi *hdmi)
 	/* Disable all interrupts */
 	hdmi_writeb(hdmi, ~0, HDMI_IH_MUTE_PHY_STAT0);
 
+	if (hdmi->cec_notifier)
+		cec_notifier_put(hdmi->cec_notifier);
+
 	clk_disable_unprepare(hdmi->iahb_clk);
 	clk_disable_unprepare(hdmi->isfr_clk);
 
-- 
2.13.2
