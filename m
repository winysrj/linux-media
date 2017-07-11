Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:32942 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755267AbdGKGaw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 02:30:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 11/11] sun4i_hdmi: add CEC support
Date: Tue, 11 Jul 2017 08:30:44 +0200
Message-Id: <20170711063044.29849-12-hverkuil@xs4all.nl>
In-Reply-To: <20170711063044.29849-1-hverkuil@xs4all.nl>
References: <20170711063044.29849-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add HDMI CEC support to the Allwinner A10 SoC.

This SoC uses a poor-man's CEC implementation by polling the CEC pin. It is
using the CEC_PIN core implementation for such devices to do the heavy
lifting. It just provides the callbacks to read/drive the CEC pin.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/gpu/drm/sun4i/Kconfig          |  9 ++++++
 drivers/gpu/drm/sun4i/sun4i_hdmi.h     |  8 +++++
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c | 57 +++++++++++++++++++++++++++++++++-
 3 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/Kconfig b/drivers/gpu/drm/sun4i/Kconfig
index 5bcad8f5fb4f..e884d265c0b3 100644
--- a/drivers/gpu/drm/sun4i/Kconfig
+++ b/drivers/gpu/drm/sun4i/Kconfig
@@ -21,6 +21,15 @@ config DRM_SUN4I_HDMI
 	  Choose this option if you have an Allwinner SoC with an HDMI
 	  controller.
 
+config DRM_SUN4I_HDMI_CEC
+       bool "Allwinner A10 HDMI CEC Support"
+       depends on DRM_SUN4I_HDMI
+       select CEC_CORE
+       select CEC_PIN
+       help
+	  Choose this option if you have an Allwinner SoC with an HDMI
+	  controller and want to use CEC.
+
 config DRM_SUN4I_BACKEND
 	tristate "Support for Allwinner A10 Display Engine Backend"
 	depends on DRM_SUN4I
diff --git a/drivers/gpu/drm/sun4i/sun4i_hdmi.h b/drivers/gpu/drm/sun4i/sun4i_hdmi.h
index 2f2f2ff1ea63..8263de225b36 100644
--- a/drivers/gpu/drm/sun4i/sun4i_hdmi.h
+++ b/drivers/gpu/drm/sun4i/sun4i_hdmi.h
@@ -15,6 +15,8 @@
 #include <drm/drm_connector.h>
 #include <drm/drm_encoder.h>
 
+#include <media/cec-pin.h>
+
 #define SUN4I_HDMI_CTRL_REG		0x004
 #define SUN4I_HDMI_CTRL_ENABLE			BIT(31)
 
@@ -86,6 +88,11 @@
 #define SUN4I_HDMI_PLL_DBG0_TMDS_PARENT_MASK	BIT(21)
 #define SUN4I_HDMI_PLL_DBG0_TMDS_PARENT_SHIFT	21
 
+#define SUN4I_HDMI_CEC			0x214
+#define SUN4I_HDMI_CEC_ENABLE			BIT(11)
+#define SUN4I_HDMI_CEC_TX			BIT(9)
+#define SUN4I_HDMI_CEC_RX			BIT(8)
+
 #define SUN4I_HDMI_PKT_CTRL_REG(n)	(0x2f0 + (4 * (n)))
 #define SUN4I_HDMI_PKT_CTRL_TYPE(n, t)		((t) << (((n) % 4) * 4))
 
@@ -149,6 +156,7 @@ struct sun4i_hdmi {
 	struct sun4i_drv	*drv;
 
 	bool			hdmi_monitor;
+	struct cec_adapter	*cec_adap;
 };
 
 int sun4i_ddc_create(struct sun4i_hdmi *hdmi, struct clk *clk);
diff --git a/drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c b/drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c
index d3398f6250ef..8b89b4e25893 100644
--- a/drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c
+++ b/drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c
@@ -271,6 +271,9 @@ static int sun4i_hdmi_get_modes(struct drm_connector *connector)
 	clk_set_rate(hdmi->ddc_clk, 100000);
 
 	edid = drm_do_get_edid(connector, sun4i_hdmi_read_edid_block, hdmi);
+
+	cec_s_phys_addr_from_edid(hdmi->cec_adap, edid);
+
 	if (!edid)
 		return 0;
 
@@ -299,8 +302,10 @@ sun4i_hdmi_connector_detect(struct drm_connector *connector, bool force)
 
 	if (readl_poll_timeout(hdmi->base + SUN4I_HDMI_HPD_REG, reg,
 			       reg & SUN4I_HDMI_HPD_HIGH,
-			       0, 500000))
+			       0, 500000)) {
+		cec_phys_addr_invalidate(hdmi->cec_adap);
 		return connector_status_disconnected;
+	}
 
 	return connector_status_connected;
 }
@@ -315,6 +320,40 @@ static const struct drm_connector_funcs sun4i_hdmi_connector_funcs = {
 	.atomic_destroy_state	= drm_atomic_helper_connector_destroy_state,
 };
 
+#ifdef CONFIG_DRM_SUN4I_HDMI_CEC
+static bool sun4i_hdmi_cec_pin_read(struct cec_adapter *adap)
+{
+	struct sun4i_hdmi *hdmi = cec_get_drvdata(adap);
+
+	return readl(hdmi->base + SUN4I_HDMI_CEC) & SUN4I_HDMI_CEC_RX;
+}
+
+static void sun4i_hdmi_cec_pin_low(struct cec_adapter *adap)
+{
+	struct sun4i_hdmi *hdmi = cec_get_drvdata(adap);
+
+	/* Start driving the CEC pin low */
+	writel(SUN4I_HDMI_CEC_ENABLE, hdmi->base + SUN4I_HDMI_CEC);
+}
+
+static void sun4i_hdmi_cec_pin_high(struct cec_adapter *adap)
+{
+	struct sun4i_hdmi *hdmi = cec_get_drvdata(adap);
+
+	/*
+	 * Stop driving the CEC pin, the pull up will take over
+	 * unless another CEC device is driving the pin low.
+	 */
+	writel(0, hdmi->base + SUN4I_HDMI_CEC);
+}
+
+static const struct cec_pin_ops sun4i_hdmi_cec_pin_ops = {
+	.read = sun4i_hdmi_cec_pin_read,
+	.low = sun4i_hdmi_cec_pin_low,
+	.high = sun4i_hdmi_cec_pin_high,
+};
+#endif
+
 static int sun4i_hdmi_bind(struct device *dev, struct device *master,
 			   void *data)
 {
@@ -430,6 +469,17 @@ static int sun4i_hdmi_bind(struct device *dev, struct device *master,
 	if (!hdmi->encoder.possible_crtcs)
 		return -EPROBE_DEFER;
 
+#ifdef CONFIG_DRM_SUN4I_HDMI_CEC
+	hdmi->cec_adap = cec_pin_allocate_adapter(&sun4i_hdmi_cec_pin_ops,
+		hdmi, "sun4i", CEC_CAP_TRANSMIT | CEC_CAP_LOG_ADDRS |
+		CEC_CAP_PASSTHROUGH | CEC_CAP_RC);
+	ret = PTR_ERR_OR_ZERO(hdmi->cec_adap);
+	if (ret < 0)
+		goto err_cleanup_connector;
+	writel(readl(hdmi->base + SUN4I_HDMI_CEC) & ~SUN4I_HDMI_CEC_TX,
+	       hdmi->base + SUN4I_HDMI_CEC);
+#endif
+
 	drm_connector_helper_add(&hdmi->connector,
 				 &sun4i_hdmi_connector_helper_funcs);
 	ret = drm_connector_init(drm, &hdmi->connector,
@@ -445,11 +495,15 @@ static int sun4i_hdmi_bind(struct device *dev, struct device *master,
 	hdmi->connector.polled = DRM_CONNECTOR_POLL_CONNECT |
 		DRM_CONNECTOR_POLL_DISCONNECT;
 
+	ret = cec_register_adapter(hdmi->cec_adap, dev);
+	if (ret < 0)
+		goto err_cleanup_connector;
 	drm_mode_connector_attach_encoder(&hdmi->connector, &hdmi->encoder);
 
 	return 0;
 
 err_cleanup_connector:
+	cec_delete_adapter(hdmi->cec_adap);
 	drm_encoder_cleanup(&hdmi->encoder);
 	return ret;
 }
@@ -459,6 +513,7 @@ static void sun4i_hdmi_unbind(struct device *dev, struct device *master,
 {
 	struct sun4i_hdmi *hdmi = dev_get_drvdata(dev);
 
+	cec_unregister_adapter(hdmi->cec_adap);
 	drm_connector_cleanup(&hdmi->connector);
 	drm_encoder_cleanup(&hdmi->encoder);
 }
-- 
2.11.0
