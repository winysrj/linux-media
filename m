Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:46607 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751189AbdKTLmW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Nov 2017 06:42:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?=
        <ville.syrjala@linux.intel.com>,
        Carlos Santa <carlos.santa@intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv5 3/3] drm/i915: add DisplayPort CEC-Tunneling-over-AUX support
Date: Mon, 20 Nov 2017 12:42:11 +0100
Message-Id: <20171120114211.21825-4-hverkuil@xs4all.nl>
In-Reply-To: <20171120114211.21825-1-hverkuil@xs4all.nl>
References: <20171120114211.21825-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Implement support for this DisplayPort feature.

The cec device is created whenever it detects an adapter that
has this feature. It is only removed when a new adapter is connected
that does not support this. If a new adapter is connected that has
different properties than the previous one, then the old cec device is
unregistered and a new one is registered to replace the old one.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Changes since v4:

Reworked the last patch (adding CEC to i915) based on Ville's comments
and my MST testing:
	- register/unregister CEC in intel_dp_connector_register/unregister
	- add comment and check if connector is registered in long_pulse
	- unregister CEC if an MST 'connector' is detected.
---
 drivers/gpu/drm/i915/intel_dp.c | 47 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 09f274419eea..853346e8c5e9 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -32,6 +32,7 @@
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <asm/byteorder.h>
+#include <media/cec.h>
 #include <drm/drmP.h>
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_crtc.h>
@@ -4690,6 +4691,7 @@ intel_dp_set_edid(struct intel_dp *intel_dp)
 	intel_connector->detect_edid = edid;
 
 	intel_dp->has_audio = drm_detect_monitor_audio(edid);
+	cec_s_phys_addr_from_edid(intel_dp->aux.cec_adap, edid);
 }
 
 static void
@@ -4699,6 +4701,7 @@ intel_dp_unset_edid(struct intel_dp *intel_dp)
 
 	kfree(intel_connector->detect_edid);
 	intel_connector->detect_edid = NULL;
+	cec_phys_addr_invalidate(intel_dp->aux.cec_adap);
 
 	intel_dp->has_audio = false;
 }
@@ -4773,6 +4776,14 @@ intel_dp_long_pulse(struct intel_connector *intel_connector)
 		 * with EDID on it
 		 */
 		status = connector_status_disconnected;
+		if (connector->registered) {
+			/*
+			 * CEC is not supported for an MST device, unregister
+			 * the existing CEC adapter, if any.
+			 */
+			cec_unregister_adapter(intel_dp->aux.cec_adap);
+			intel_dp->aux.cec_adap = NULL;
+		}
 		goto out;
 	} else {
 		/*
@@ -4822,6 +4833,25 @@ intel_dp_long_pulse(struct intel_connector *intel_connector)
 	if (status != connector_status_connected && !intel_dp->is_mst)
 		intel_dp_unset_edid(intel_dp);
 
+	if (status == connector_status_connected && connector->registered) {
+		/*
+		 * A new DP-to-HDMI adapter could have been plugged in, so
+		 * call drm_dp_cec_configure_adapter to check if a CEC device
+		 * should be unregistered and/or registered, depending on the
+		 * CEC capabilities of the adapter.
+		 *
+		 * The CEC device is associated with the connector, so it
+		 * sticks around when the adapter is unplugged and is only
+		 * unregistered if the connector is unregistered or if another
+		 * adapter is plugged in with no or different CEC capabilities.
+		 *
+		 * This is what CEC applications expect.
+		 */
+		drm_dp_cec_configure_adapter(&intel_dp->aux,
+					     connector->name, dev->dev,
+					     intel_connector->detect_edid);
+	}
+
 	intel_display_power_put(to_i915(dev), intel_dp->aux_power_domain);
 	return status;
 }
@@ -4902,6 +4932,7 @@ static int
 intel_dp_connector_register(struct drm_connector *connector)
 {
 	struct intel_dp *intel_dp = intel_attached_dp(connector);
+	struct drm_device *dev = connector->dev;
 	int ret;
 
 	ret = intel_connector_register(connector);
@@ -4913,6 +4944,15 @@ intel_dp_connector_register(struct drm_connector *connector)
 	DRM_DEBUG_KMS("registering %s bus for %s\n",
 		      intel_dp->aux.name, connector->kdev->kobj.name);
 
+	if (connector->status == connector_status_connected &&
+	    !intel_dp->is_mst && !intel_dp->aux.cec_adap) {
+		struct intel_connector *intel_connector =
+			intel_dp->attached_connector;
+
+		drm_dp_cec_configure_adapter(&intel_dp->aux,
+					     connector->name, dev->dev,
+					     intel_connector->detect_edid);
+	}
 	intel_dp->aux.dev = connector->kdev;
 	return drm_dp_aux_register(&intel_dp->aux);
 }
@@ -4920,7 +4960,11 @@ intel_dp_connector_register(struct drm_connector *connector)
 static void
 intel_dp_connector_unregister(struct drm_connector *connector)
 {
-	drm_dp_aux_unregister(&intel_attached_dp(connector)->aux);
+	struct intel_dp *intel_dp = intel_attached_dp(connector);
+
+	cec_unregister_adapter(intel_dp->aux.cec_adap);
+	intel_dp->aux.cec_adap = NULL;
+	drm_dp_aux_unregister(&intel_dp->aux);
 	intel_connector_unregister(connector);
 }
 
@@ -5129,6 +5173,7 @@ intel_dp_hpd_pulse(struct intel_digital_port *intel_dig_port, bool long_hpd)
 	}
 
 	if (!intel_dp->is_mst) {
+		drm_dp_cec_irq(&intel_dp->aux);
 		if (!intel_dp_short_pulse(intel_dp)) {
 			intel_dp->detect_done = false;
 			goto put_power;
-- 
2.14.1
