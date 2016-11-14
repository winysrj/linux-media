Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:39559 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753144AbcKNPXE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 10:23:04 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [RFCv2 PATCH 3/5] drm/bridge: dw_hdmi: add HDMI notifier support
Date: Mon, 14 Nov 2016 16:22:46 +0100
Message-Id: <1479136968-24477-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1479136968-24477-1-git-send-email-hverkuil@xs4all.nl>
References: <1479136968-24477-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Russell King <rmk+kernel@arm.linux.org.uk>

Add HDMI notifiers to the HDMI bridge driver.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/gpu/drm/bridge/Kconfig   |  1 +
 drivers/gpu/drm/bridge/dw-hdmi.c | 25 ++++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index 10e12e7..5f4ebe9 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -27,6 +27,7 @@ config DRM_DUMB_VGA_DAC
 config DRM_DW_HDMI
 	tristate
 	select DRM_KMS_HELPER
+	select HDMI_NOTIFIERS
 
 config DRM_DW_HDMI_AHB_AUDIO
 	tristate "Synopsis Designware AHB Audio interface"
diff --git a/drivers/gpu/drm/bridge/dw-hdmi.c b/drivers/gpu/drm/bridge/dw-hdmi.c
index ab7023e..bd02da5 100644
--- a/drivers/gpu/drm/bridge/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/dw-hdmi.c
@@ -16,6 +16,7 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/hdmi.h>
+#include <linux/hdmi-notifier.h>
 #include <linux/mutex.h>
 #include <linux/of_device.h>
 #include <linux/spinlock.h>
@@ -114,6 +115,7 @@ struct dw_hdmi {
 
 	struct hdmi_data_info hdmi_data;
 	const struct dw_hdmi_plat_data *plat_data;
+	struct hdmi_notifier *n;
 
 	int vic;
 
@@ -1448,9 +1450,11 @@ static int dw_hdmi_connector_get_modes(struct drm_connector *connector)
 		hdmi->sink_is_hdmi = drm_detect_hdmi_monitor(edid);
 		hdmi->sink_has_audio = drm_detect_monitor_audio(edid);
 		drm_mode_connector_update_edid_property(connector, edid);
+		hdmi_event_new_edid(hdmi->n, edid, 0);
 		ret = drm_add_edid_modes(connector, edid);
 		/* Store the ELD */
 		drm_edid_to_eld(connector, edid);
+		hdmi_event_new_eld(hdmi->n, connector->eld);
 		kfree(edid);
 	} else {
 		dev_dbg(hdmi->dev, "failed to get edid\n");
@@ -1579,6 +1583,12 @@ static irqreturn_t dw_hdmi_irq(int irq, void *dev_id)
 			dw_hdmi_update_phy_mask(hdmi);
 		}
 		mutex_unlock(&hdmi->mutex);
+
+		if ((phy_stat & (HDMI_PHY_RX_SENSE | HDMI_PHY_HPD)) == 0)
+			hdmi_event_disconnect(hdmi->n);
+		else if ((phy_stat & (HDMI_PHY_RX_SENSE | HDMI_PHY_HPD)) ==
+			 (HDMI_IH_PHY_STAT0_RX_SENSE | HDMI_PHY_HPD))
+			hdmi_event_connect(hdmi->n);
 	}
 
 	if (intr_stat & HDMI_IH_PHY_STAT0_HPD) {
@@ -1732,11 +1742,17 @@ int dw_hdmi_bind(struct device *dev, struct device *master,
 
 	initialize_hdmi_ih_mutes(hdmi);
 
+	hdmi->n = hdmi_notifier_get(dev);
+	if (!hdmi->n) {
+		ret = -ENOMEM;
+		goto err_iahb;
+	}
+
 	ret = devm_request_threaded_irq(dev, irq, dw_hdmi_hardirq,
 					dw_hdmi_irq, IRQF_SHARED,
 					dev_name(dev), hdmi);
 	if (ret)
-		goto err_iahb;
+		goto err_hdmi_not;
 
 	/*
 	 * To prevent overflows in HDMI_IH_FC_STAT2, set the clk regenerator
@@ -1788,6 +1804,8 @@ int dw_hdmi_bind(struct device *dev, struct device *master,
 
 	return 0;
 
+err_hdmi_not:
+	hdmi_notifier_put(hdmi->n);
 err_iahb:
 	clk_disable_unprepare(hdmi->iahb_clk);
 err_isfr:
@@ -1804,6 +1822,11 @@ void dw_hdmi_unbind(struct device *dev, struct device *master, void *data)
 	if (hdmi->audio && !IS_ERR(hdmi->audio))
 		platform_device_unregister(hdmi->audio);
 
+	hdmi_notifier_put(hdmi->n);
+
+	if (!IS_ERR(hdmi->cec))
+		platform_device_unregister(hdmi->cec);
+
 	/* Disable all interrupts */
 	hdmi_writeb(hdmi, ~0, HDMI_IH_MUTE_PHY_STAT0);
 
-- 
2.8.1

