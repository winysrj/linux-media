Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56949 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751500AbdFZSMd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 14:12:33 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 05/14] v4l: vsp1: Don't create links for DRM pipeline
Date: Mon, 26 Jun 2017 21:12:17 +0300
Message-Id: <20170626181226.29575-6-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the VSP1 is used in a DRM pipeline the driver doesn't register the
media device. Links between entities are not exposed to userspace, but
are still used internally for the sole purpose of setting up internal
source to sink pointers through the link setup handler.

Instead of going through this complex procedure, remove link creation
and set the sink pointers directly.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 53 ++++------------------------------
 drivers/media/platform/vsp1/vsp1_drm.h |  1 -
 drivers/media/platform/vsp1/vsp1_drv.c | 16 ++++------
 3 files changed, 12 insertions(+), 58 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 2d5a74e95e09..c72d021ff820 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -487,6 +487,7 @@ void vsp1_du_atomic_flush(struct device *dev)
 
 		vsp1->bru->inputs[i].rpf = rpf;
 		rpf->bru_input = i;
+		rpf->entity.sink = &vsp1->bru->entity;
 		rpf->entity.sink_pad = i;
 
 		dev_dbg(vsp1->dev, "%s: connecting RPF.%u to BRU:%u\n",
@@ -564,53 +565,6 @@ EXPORT_SYMBOL_GPL(vsp1_du_unmap_sg);
  * Initialization
  */
 
-int vsp1_drm_create_links(struct vsp1_device *vsp1)
-{
-	const u32 flags = MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE;
-	unsigned int i;
-	int ret;
-
-	/*
-	 * VSPD instances require a BRU to perform composition and a LIF to
-	 * output to the DU.
-	 */
-	if (!vsp1->bru || !vsp1->lif)
-		return -ENXIO;
-
-	for (i = 0; i < vsp1->info->rpf_count; ++i) {
-		struct vsp1_rwpf *rpf = vsp1->rpf[i];
-
-		ret = media_create_pad_link(&rpf->entity.subdev.entity,
-					    RWPF_PAD_SOURCE,
-					    &vsp1->bru->entity.subdev.entity,
-					    i, flags);
-		if (ret < 0)
-			return ret;
-
-		rpf->entity.sink = &vsp1->bru->entity;
-		rpf->entity.sink_pad = i;
-	}
-
-	ret = media_create_pad_link(&vsp1->bru->entity.subdev.entity,
-				    vsp1->bru->entity.source_pad,
-				    &vsp1->wpf[0]->entity.subdev.entity,
-				    RWPF_PAD_SINK, flags);
-	if (ret < 0)
-		return ret;
-
-	vsp1->bru->entity.sink = &vsp1->wpf[0]->entity;
-	vsp1->bru->entity.sink_pad = RWPF_PAD_SINK;
-
-	ret = media_create_pad_link(&vsp1->wpf[0]->entity.subdev.entity,
-				    RWPF_PAD_SOURCE,
-				    &vsp1->lif->entity.subdev.entity,
-				    LIF_PAD_SINK, flags);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
 int vsp1_drm_init(struct vsp1_device *vsp1)
 {
 	struct vsp1_pipeline *pipe;
@@ -631,6 +585,11 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
 		list_add_tail(&input->entity.list_pipe, &pipe->entities);
 	}
 
+	vsp1->bru->entity.sink = &vsp1->wpf[0]->entity;
+	vsp1->bru->entity.sink_pad = 0;
+	vsp1->wpf[0]->entity.sink = &vsp1->lif->entity;
+	vsp1->wpf[0]->entity.sink_pad = 0;
+
 	list_add_tail(&vsp1->bru->entity.list_pipe, &pipe->entities);
 	list_add_tail(&vsp1->wpf[0]->entity.list_pipe, &pipe->entities);
 	list_add_tail(&vsp1->lif->entity.list_pipe, &pipe->entities);
diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
index cbdbb8a39883..67d6549edfad 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.h
+++ b/drivers/media/platform/vsp1/vsp1_drm.h
@@ -48,6 +48,5 @@ static inline struct vsp1_drm *to_vsp1_drm(struct vsp1_pipeline *pipe)
 
 int vsp1_drm_init(struct vsp1_device *vsp1);
 void vsp1_drm_cleanup(struct vsp1_device *vsp1);
-int vsp1_drm_create_links(struct vsp1_device *vsp1);
 
 #endif /* __VSP1_DRM_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 9b3a0790f92a..5a467b118a1c 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -423,19 +423,15 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 			goto done;
 	}
 
-	/* Create links. */
-	if (vsp1->info->uapi)
-		ret = vsp1_uapi_create_links(vsp1);
-	else
-		ret = vsp1_drm_create_links(vsp1);
-	if (ret < 0)
-		goto done;
-
 	/*
-	 * Register subdev nodes if the userspace API is enabled or initialize
-	 * the DRM pipeline otherwise.
+	 * Create links and register subdev nodes if the userspace API is
+	 * enabled or initialize the DRM pipeline otherwise.
 	 */
 	if (vsp1->info->uapi) {
+		ret = vsp1_uapi_create_links(vsp1);
+		if (ret < 0)
+			goto done;
+
 		ret = v4l2_device_register_subdev_nodes(&vsp1->v4l2_dev);
 		if (ret < 0)
 			goto done;
-- 
Regards,

Laurent Pinchart
