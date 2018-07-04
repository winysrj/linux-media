Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:39477 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752897AbeGDPI2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 11:08:28 -0400
Received: by mail-wm0-f48.google.com with SMTP id p11-v6so6215361wmc.4
        for <linux-media@vger.kernel.org>; Wed, 04 Jul 2018 08:08:27 -0700 (PDT)
From: Neil Armstrong <narmstrong@baylibre.com>
To: airlied@linux.ie, hans.verkuil@cisco.com, lee.jones@linaro.org,
        olof@lixom.net, seanpaul@google.com
Cc: Neil Armstrong <narmstrong@baylibre.com>, sadolfsson@google.com,
        felixe@google.com, bleung@google.com, darekm@google.com,
        marcheu@chromium.org, fparent@baylibre.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        ville.syrjala@linux.intel.com, rodrigo.vivi@intel.com
Subject: [PATCH v8 2/6] drm/i915: hdmi: add CEC notifier to intel_hdmi
Date: Wed,  4 Jul 2018 17:08:17 +0200
Message-Id: <1530716901-30164-3-git-send-email-narmstrong@baylibre.com>
In-Reply-To: <1530716901-30164-1-git-send-email-narmstrong@baylibre.com>
References: <1530716901-30164-1-git-send-email-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchs adds the cec_notifier feature to the intel_hdmi part
of the i915 DRM driver. It uses the HDMI DRM connector name to differentiate
between each HDMI ports.
The changes will allow the i915 HDMI code to notify EDID and HPD changes
to an eventual CEC adapter.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
---
 drivers/gpu/drm/i915/Kconfig         |  1 +
 drivers/gpu/drm/i915/intel_display.h | 24 ++++++++++++++++++++++++
 drivers/gpu/drm/i915/intel_drv.h     |  2 ++
 drivers/gpu/drm/i915/intel_hdmi.c    | 13 +++++++++++++
 4 files changed, 40 insertions(+)

diff --git a/drivers/gpu/drm/i915/Kconfig b/drivers/gpu/drm/i915/Kconfig
index dfd9588..2d65d56 100644
--- a/drivers/gpu/drm/i915/Kconfig
+++ b/drivers/gpu/drm/i915/Kconfig
@@ -23,6 +23,7 @@ config DRM_I915
 	select SYNC_FILE
 	select IOSF_MBI
 	select CRC32
+	select CEC_CORE if CEC_NOTIFIER
 	help
 	  Choose this option if you have a system that has "Intel Graphics
 	  Media Accelerator" or "HD Graphics" integrated graphics,
diff --git a/drivers/gpu/drm/i915/intel_display.h b/drivers/gpu/drm/i915/intel_display.h
index 2ef3161..1f176a71 100644
--- a/drivers/gpu/drm/i915/intel_display.h
+++ b/drivers/gpu/drm/i915/intel_display.h
@@ -126,6 +126,30 @@ enum port {
 
 #define port_name(p) ((p) + 'A')
 
+/*
+ * Ports identifier referenced from other drivers.
+ * Expected to remain stable over time
+ */
+static inline const char *port_identifier(enum port port)
+{
+	switch (port) {
+	case PORT_A:
+		return "Port A";
+	case PORT_B:
+		return "Port B";
+	case PORT_C:
+		return "Port C";
+	case PORT_D:
+		return "Port D";
+	case PORT_E:
+		return "Port E";
+	case PORT_F:
+		return "Port F";
+	default:
+		return "<invalid>";
+	}
+}
+
 enum dpio_channel {
 	DPIO_CH0,
 	DPIO_CH1
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 0361130..cfbeee1 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -39,6 +39,7 @@
 #include <drm/drm_dp_mst_helper.h>
 #include <drm/drm_rect.h>
 #include <drm/drm_atomic.h>
+#include <media/cec-notifier.h>
 
 /**
  * __wait_for - magic wait macro
@@ -1017,6 +1018,7 @@ struct intel_hdmi {
 	bool has_audio;
 	bool rgb_quant_range_selectable;
 	struct intel_connector *attached_connector;
+	struct cec_notifier *cec_notifier;
 };
 
 struct intel_dp_mst_encoder;
diff --git a/drivers/gpu/drm/i915/intel_hdmi.c b/drivers/gpu/drm/i915/intel_hdmi.c
index ee929f3..c21b7dd 100644
--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@ -1868,6 +1868,8 @@ intel_hdmi_set_edid(struct drm_connector *connector)
 		connected = true;
 	}
 
+	cec_notifier_set_phys_addr_from_edid(intel_hdmi->cec_notifier, edid);
+
 	return connected;
 }
 
@@ -1876,6 +1878,7 @@ intel_hdmi_detect(struct drm_connector *connector, bool force)
 {
 	enum drm_connector_status status;
 	struct drm_i915_private *dev_priv = to_i915(connector->dev);
+	struct intel_hdmi *intel_hdmi = intel_attached_hdmi(connector);
 
 	DRM_DEBUG_KMS("[CONNECTOR:%d:%s]\n",
 		      connector->base.id, connector->name);
@@ -1891,6 +1894,9 @@ intel_hdmi_detect(struct drm_connector *connector, bool force)
 
 	intel_display_power_put(dev_priv, POWER_DOMAIN_GMBUS);
 
+	if (status != connector_status_connected)
+		cec_notifier_phys_addr_invalidate(intel_hdmi->cec_notifier);
+
 	return status;
 }
 
@@ -2031,6 +2037,8 @@ static void chv_hdmi_pre_enable(struct intel_encoder *encoder,
 
 static void intel_hdmi_destroy(struct drm_connector *connector)
 {
+	if (intel_attached_hdmi(connector)->cec_notifier)
+		cec_notifier_put(intel_attached_hdmi(connector)->cec_notifier);
 	kfree(to_intel_connector(connector)->detect_edid);
 	drm_connector_cleanup(connector);
 	kfree(connector);
@@ -2350,6 +2358,11 @@ void intel_hdmi_init_connector(struct intel_digital_port *intel_dig_port,
 		u32 temp = I915_READ(PEG_BAND_GAP_DATA);
 		I915_WRITE(PEG_BAND_GAP_DATA, (temp & ~0xf) | 0xd);
 	}
+
+	intel_hdmi->cec_notifier = cec_notifier_get_conn(dev->dev,
+							 port_identifier(port));
+	if (!intel_hdmi->cec_notifier)
+		DRM_DEBUG_KMS("CEC notifier get failed\n");
 }
 
 void intel_hdmi_init(struct drm_i915_private *dev_priv,
-- 
2.7.4
