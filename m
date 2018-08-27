Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:33165 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726785AbeH0Lxz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 07:53:55 -0400
Subject: [PATCHv2 5/5] drm/amdgpu: add DisplayPort CEC-Tunneling-over-AUX
 support
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: nouveau@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        Maling list - DRI developers
        <dri-devel@lists.freedesktop.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180827075820.41109-1-hverkuil@xs4all.nl>
 <20180827075820.41109-3-hverkuil@xs4all.nl>
 <5c0b907d-0bf2-7b80-b4b6-cbde78b03f0d@xs4all.nl>
Message-ID: <de9586bb-151e-bae9-b8e3-14db107a60df@xs4all.nl>
Date: Mon, 27 Aug 2018 10:08:18 +0200
MIME-Version: 1.0
In-Reply-To: <5c0b907d-0bf2-7b80-b4b6-cbde78b03f0d@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add DisplayPort CEC-Tunneling-over-AUX support to amdgpu.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c        | 9 ++++++++-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c  | 2 ++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 800f481a6995..85f6c1546bff 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -896,6 +896,7 @@ amdgpu_dm_update_connector_after_detect(struct amdgpu_dm_connector *aconnector)
 		aconnector->dc_sink = sink;
 		if (sink->dc_edid.length == 0) {
 			aconnector->edid = NULL;
+			drm_dp_cec_unset_edid(&aconnector->dm_dp_aux.aux);
 		} else {
 			aconnector->edid =
 				(struct edid *) sink->dc_edid.raw_edid;
@@ -903,10 +904,13 @@ amdgpu_dm_update_connector_after_detect(struct amdgpu_dm_connector *aconnector)

 			drm_connector_update_edid_property(connector,
 					aconnector->edid);
+			drm_dp_cec_set_edid(&aconnector->dm_dp_aux.aux,
+					    aconnector->edid);
 		}
 		amdgpu_dm_add_sink_to_freesync_module(connector, aconnector->edid);

 	} else {
+		drm_dp_cec_unset_edid(&aconnector->dm_dp_aux.aux);
 		amdgpu_dm_remove_sink_from_freesync_module(connector);
 		drm_connector_update_edid_property(connector, NULL);
 		aconnector->num_modes = 0;
@@ -1061,8 +1065,10 @@ static void handle_hpd_rx_irq(void *param)
 	    (dc_link->type == dc_connection_mst_branch))
 		dm_handle_hpd_rx_irq(aconnector);

-	if (dc_link->type != dc_connection_mst_branch)
+	if (dc_link->type != dc_connection_mst_branch) {
+		drm_dp_cec_irq(&aconnector->dm_dp_aux.aux);
 		mutex_unlock(&aconnector->hpd_lock);
+	}
 }

 static void register_hpd_handlers(struct amdgpu_device *adev)
@@ -2730,6 +2736,7 @@ static void amdgpu_dm_connector_destroy(struct drm_connector *connector)
 		dm->backlight_dev = NULL;
 	}
 #endif
+	drm_dp_cec_unregister_connector(&aconnector->dm_dp_aux.aux);
 	drm_connector_unregister(connector);
 	drm_connector_cleanup(connector);
 	kfree(connector);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 9a300732ba37..18a3a6e5ffa0 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -496,6 +496,8 @@ void amdgpu_dm_initialize_dp_connector(struct amdgpu_display_manager *dm,
 	aconnector->dm_dp_aux.ddc_service = aconnector->dc_link->ddc;

 	drm_dp_aux_register(&aconnector->dm_dp_aux.aux);
+	drm_dp_cec_register_connector(&aconnector->dm_dp_aux.aux,
+				      aconnector->base.name, dm->adev->dev);
 	aconnector->mst_mgr.cbs = &dm_mst_cbs;
 	drm_dp_mst_topology_mgr_init(
 		&aconnector->mst_mgr,
-- 
2.18.0
