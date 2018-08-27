Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:47565 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726802AbeH0Lw1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 07:52:27 -0400
Subject: [PATCH 4/5] drm/nouveau: add DisplayPort CEC-Tunneling-over-AUX
 support
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: nouveau@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        Maling list - DRI developers
        <dri-devel@lists.freedesktop.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180827075820.41109-1-hverkuil@xs4all.nl>
 <20180827075820.41109-3-hverkuil@xs4all.nl>
Message-ID: <5c0b907d-0bf2-7b80-b4b6-cbde78b03f0d@xs4all.nl>
Date: Mon, 27 Aug 2018 10:06:51 +0200
MIME-Version: 1.0
In-Reply-To: <20180827075820.41109-3-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add DisplayPort CEC-Tunneling-over-AUX support to nouveau.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
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
