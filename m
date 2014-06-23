Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47310 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbaFWXyH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jun 2014 19:54:07 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 10/23] v4l: vsp1: Cleanup video nodes at removal time
Date: Tue, 24 Jun 2014 01:54:16 +0200
Message-Id: <1403567669-18539-11-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Video nodes created and initialized in the RPF and WPF init code paths
are never unregistered, and the related resources (videobuf alloc
context and media entity) never released.

Fix this by storing a pointer to the vsp1_video object in vsp1_entity
and calling vsp1_video_cleanup() from vsp1_entity_destroy(). This also
allows simplifying the init error code paths.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_entity.c |  3 +++
 drivers/media/platform/vsp1/vsp1_entity.h |  3 +++
 drivers/media/platform/vsp1/vsp1_rpf.c    | 12 ++++++------
 drivers/media/platform/vsp1/vsp1_wpf.c    | 12 ++++++------
 4 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 4416783..ceac0d7 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -20,6 +20,7 @@
 
 #include "vsp1.h"
 #include "vsp1_entity.h"
+#include "vsp1_video.h"
 
 /* -----------------------------------------------------------------------------
  * V4L2 Subdevice Operations
@@ -185,6 +186,8 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 
 void vsp1_entity_destroy(struct vsp1_entity *entity)
 {
+	if (entity->video)
+		vsp1_video_cleanup(entity->video);
 	if (entity->subdev.ctrl_handler)
 		v4l2_ctrl_handler_free(entity->subdev.ctrl_handler);
 	media_entity_cleanup(&entity->subdev.entity);
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 7afbd8a..f0257f6 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -18,6 +18,7 @@
 #include <media/v4l2-subdev.h>
 
 struct vsp1_device;
+struct vsp1_video;
 
 enum vsp1_entity_type {
 	VSP1_ENTITY_BRU,
@@ -68,6 +69,8 @@ struct vsp1_entity {
 
 	struct v4l2_subdev subdev;
 	struct v4l2_mbus_framefmt *formats;
+
+	struct vsp1_video *video;
 };
 
 static inline struct vsp1_entity *to_vsp1_entity(struct v4l2_subdev *subdev)
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index c3d9864..9b3fc70 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -205,7 +205,9 @@ struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index)
 
 	ret = vsp1_video_init(video, &rpf->entity);
 	if (ret < 0)
-		goto error_video;
+		goto error;
+
+	rpf->entity.video = video;
 
 	/* Connect the video device to the RPF. */
 	ret = media_entity_create_link(&rpf->video.video.entity, 0,
@@ -214,13 +216,11 @@ struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index)
 				       MEDIA_LNK_FL_ENABLED |
 				       MEDIA_LNK_FL_IMMUTABLE);
 	if (ret < 0)
-		goto error_link;
+		goto error;
 
 	return rpf;
 
-error_link:
-	vsp1_video_cleanup(video);
-error_video:
-	media_entity_cleanup(&rpf->entity.subdev.entity);
+error:
+	vsp1_entity_destroy(&rpf->entity);
 	return ERR_PTR(ret);
 }
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 1294340..36c4793 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -216,7 +216,9 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 
 	ret = vsp1_video_init(video, &wpf->entity);
 	if (ret < 0)
-		goto error_video;
+		goto error;
+
+	wpf->entity.video = video;
 
 	/* Connect the video device to the WPF. All connections are immutable
 	 * except for the WPF0 source link if a LIF is present.
@@ -229,15 +231,13 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 				       RWPF_PAD_SOURCE,
 				       &wpf->video.video.entity, 0, flags);
 	if (ret < 0)
-		goto error_link;
+		goto error;
 
 	wpf->entity.sink = &wpf->video.video.entity;
 
 	return wpf;
 
-error_link:
-	vsp1_video_cleanup(video);
-error_video:
-	media_entity_cleanup(&wpf->entity.subdev.entity);
+error:
+	vsp1_entity_destroy(&wpf->entity);
 	return ERR_PTR(ret);
 }
-- 
1.8.5.5

