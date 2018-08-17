Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:47114 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727160AbeHQRO5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Aug 2018 13:14:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH (repost) 4/5] drm/nouveau: add DisplayPort CEC-Tunneling-over-AUX support
Date: Fri, 17 Aug 2018 16:11:21 +0200
Message-Id: <20180817141122.9541-5-hverkuil@xs4all.nl>
In-Reply-To: <20180817141122.9541-1-hverkuil@xs4all.nl>
References: <20180817141122.9541-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add DisplayPort CEC-Tunneling-over-AUX support to nouveau.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index 51932c72334e..eb4f766b5958 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -400,8 +400,10 @@ nouveau_connector_destroy(struct drm_connector *connector)
 	kfree(nv_connector->edid);
 	drm_connector_unregister(connector);
 	drm_connector_cleanup(connector);
-	if (nv_connector->aux.transfer)
+	if (nv_connector->aux.transfer) {
+		drm_dp_cec_unregister_connector(&nv_connector->aux);
 		drm_dp_aux_unregister(&nv_connector->aux);
+	}
 	kfree(connector);
 }
 
@@ -608,6 +610,7 @@ nouveau_connector_detect(struct drm_connector *connector, bool force)
 
 		nouveau_connector_set_encoder(connector, nv_encoder);
 		conn_status = connector_status_connected;
+		drm_dp_cec_set_edid(&nv_connector->aux, nv_connector->edid);
 		goto out;
 	}
 
@@ -1108,11 +1111,14 @@ nouveau_connector_hotplug(struct nvif_notify *notify)
 
 	if (rep->mask & NVIF_NOTIFY_CONN_V0_IRQ) {
 		NV_DEBUG(drm, "service %s\n", name);
+		drm_dp_cec_irq(&nv_connector->aux);
 		if ((nv_encoder = find_encoder(connector, DCB_OUTPUT_DP)))
 			nv50_mstm_service(nv_encoder->dp.mstm);
 	} else {
 		bool plugged = (rep->mask != NVIF_NOTIFY_CONN_V0_UNPLUG);
 
+		if (!plugged)
+			drm_dp_cec_unset_edid(&nv_connector->aux);
 		NV_DEBUG(drm, "%splugged %s\n", plugged ? "" : "un", name);
 		if ((nv_encoder = find_encoder(connector, DCB_OUTPUT_DP))) {
 			if (!plugged)
@@ -1302,7 +1308,6 @@ nouveau_connector_create(struct drm_device *dev, int index)
 			kfree(nv_connector);
 			return ERR_PTR(ret);
 		}
-
 		funcs = &nouveau_connector_funcs;
 		break;
 	default:
@@ -1356,6 +1361,14 @@ nouveau_connector_create(struct drm_device *dev, int index)
 		break;
 	}
 
+	switch (type) {
+	case DRM_MODE_CONNECTOR_DisplayPort:
+	case DRM_MODE_CONNECTOR_eDP:
+		drm_dp_cec_register_connector(&nv_connector->aux,
+					      connector->name, dev->dev);
+		break;
+	}
+
 	ret = nvif_notify_init(&disp->disp.object, nouveau_connector_hotplug,
 			       true, NV04_DISP_NTFY_CONN,
 			       &(struct nvif_notify_conn_req_v0) {
-- 
2.18.0
