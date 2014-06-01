Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59653 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184AbaFADj1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 May 2014 23:39:27 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 08/18] v4l: vsp1: Setup control handler automatically at stream on time
Date: Sun,  1 Jun 2014 05:39:27 +0200
Message-Id: <1401593977-30660-9-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1401593977-30660-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1401593977-30660-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When setting a control directly on a subdev node the VSP1 driver doesn't
guarantee that the device is powered on. This leads to crashes when the
control handlers writes to hardware registers. One easy way to fix this
is to ensure that the device gets powered on when a subdev node is
opened. However, this consumes power unnecessarily, as there's no need
to power the device on when setting formats on the pipeline.
Furthermore, control handler setup at entity init time suffers from the
same problem as the device isn't powered on easier.

Fix this by extend the entity base object to setup the control handler
automatically when starting the stream. Entities must then skip writing
to registers in the set control handler when not streaming, which can be
tested with the new vsp1_entity_is_streaming() helper function.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_entity.c | 39 +++++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_entity.h |  7 ++++++
 2 files changed, 46 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index ceac0d7..79af71d 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -22,6 +22,41 @@
 #include "vsp1_entity.h"
 #include "vsp1_video.h"
 
+bool vsp1_entity_is_streaming(struct vsp1_entity *entity)
+{
+	bool streaming;
+
+	mutex_lock(&entity->lock);
+	streaming = entity->streaming;
+	mutex_unlock(&entity->lock);
+
+	return streaming;
+}
+
+int vsp1_entity_set_streaming(struct vsp1_entity *entity, bool streaming)
+{
+	int ret;
+
+	mutex_lock(&entity->lock);
+	entity->streaming = streaming;
+	mutex_unlock(&entity->lock);
+
+	if (!streaming)
+		return 0;
+
+	if (!entity->subdev.ctrl_handler)
+		return 0;
+
+	ret = v4l2_ctrl_handler_setup(entity->subdev.ctrl_handler);
+	if (ret < 0) {
+		mutex_lock(&entity->lock);
+		entity->streaming = false;
+		mutex_unlock(&entity->lock);
+	}
+
+	return ret;
+}
+
 /* -----------------------------------------------------------------------------
  * V4L2 Subdevice Operations
  */
@@ -158,6 +193,8 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 	if (i == ARRAY_SIZE(vsp1_routes))
 		return -EINVAL;
 
+	mutex_init(&entity->lock);
+
 	entity->vsp1 = vsp1;
 	entity->source_pad = num_pads - 1;
 
@@ -191,4 +228,6 @@ void vsp1_entity_destroy(struct vsp1_entity *entity)
 	if (entity->subdev.ctrl_handler)
 		v4l2_ctrl_handler_free(entity->subdev.ctrl_handler);
 	media_entity_cleanup(&entity->subdev.entity);
+
+	mutex_destroy(&entity->lock);
 }
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index f0257f6..aa20aaa 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -14,6 +14,7 @@
 #define __VSP1_ENTITY_H__
 
 #include <linux/list.h>
+#include <linux/mutex.h>
 
 #include <media/v4l2-subdev.h>
 
@@ -71,6 +72,9 @@ struct vsp1_entity {
 	struct v4l2_mbus_framefmt *formats;
 
 	struct vsp1_video *video;
+
+	struct mutex lock;		/* Protects the streaming field */
+	bool streaming;
 };
 
 static inline struct vsp1_entity *to_vsp1_entity(struct v4l2_subdev *subdev)
@@ -92,4 +96,7 @@ vsp1_entity_get_pad_format(struct vsp1_entity *entity,
 void vsp1_entity_init_formats(struct v4l2_subdev *subdev,
 			      struct v4l2_subdev_fh *fh);
 
+bool vsp1_entity_is_streaming(struct vsp1_entity *entity);
+int vsp1_entity_set_streaming(struct vsp1_entity *entity, bool streaming);
+
 #endif /* __VSP1_ENTITY_H__ */
-- 
1.8.5.5

