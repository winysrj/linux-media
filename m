Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:47914 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726797AbeGKMc3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jul 2018 08:32:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, ville.syrjala@linux.intel.com,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv9 3/3] drm/i915: add DisplayPort CEC-Tunneling-over-AUX support
Date: Wed, 11 Jul 2018 14:28:19 +0200
Message-Id: <20180711122819.80457-4-hverkuil@xs4all.nl>
In-Reply-To: <20180711122819.80457-1-hverkuil@xs4all.nl>
References: <20180711122819.80457-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Implement support for this DisplayPort feature.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/intel_dp.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 16faea30114a..c3045262eba1 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -4466,6 +4466,9 @@ intel_dp_short_pulse(struct intel_dp *intel_dp)
 			DRM_DEBUG_DRIVER("CP or sink specific irq unhandled\n");
 	}
 
+	/* Handle CEC interrupts, if any */
+	drm_dp_cec_irq(&intel_dp->aux);
+
 	/* defer to the hotplug work for link retraining if needed */
 	if (intel_dp_needs_link_retrain(intel_dp))
 		return false;
@@ -4780,6 +4783,7 @@ intel_dp_set_edid(struct intel_dp *intel_dp)
 	intel_connector->detect_edid = edid;
 
 	intel_dp->has_audio = drm_detect_monitor_audio(edid);
+	drm_dp_cec_set_edid(&intel_dp->aux, edid);
 }
 
 static void
@@ -4787,6 +4791,7 @@ intel_dp_unset_edid(struct intel_dp *intel_dp)
 {
 	struct intel_connector *intel_connector = intel_dp->attached_connector;
 
+	drm_dp_cec_unset_edid(&intel_dp->aux);
 	kfree(intel_connector->detect_edid);
 	intel_connector->detect_edid = NULL;
 
@@ -4975,6 +4980,7 @@ static int
 intel_dp_connector_register(struct drm_connector *connector)
 {
 	struct intel_dp *intel_dp = intel_attached_dp(connector);
+	struct drm_device *dev = connector->dev;
 	int ret;
 
 	ret = intel_connector_register(connector);
@@ -4987,13 +4993,20 @@ intel_dp_connector_register(struct drm_connector *connector)
 		      intel_dp->aux.name, connector->kdev->kobj.name);
 
 	intel_dp->aux.dev = connector->kdev;
-	return drm_dp_aux_register(&intel_dp->aux);
+	ret = drm_dp_aux_register(&intel_dp->aux);
+	if (!ret)
+		drm_dp_cec_register_connector(&intel_dp->aux,
+					      connector->name, dev->dev);
+	return ret;
 }
 
 static void
 intel_dp_connector_unregister(struct drm_connector *connector)
 {
-	drm_dp_aux_unregister(&intel_attached_dp(connector)->aux);
+	struct intel_dp *intel_dp = intel_attached_dp(connector);
+
+	drm_dp_cec_unregister_connector(&intel_dp->aux);
+	drm_dp_aux_unregister(&intel_dp->aux);
 	intel_connector_unregister(connector);
 }
 
-- 
2.18.0
