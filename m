Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44650 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbbLQIkk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 03:40:40 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH/RFC 01/48] v4l: vsp1: Use pipeline display list to decide how to write to modules
Date: Thu, 17 Dec 2015 10:39:39 +0200
Message-Id: <1450341626-6695-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This allows getting rid of the vsp1_device::use_dl field.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1.h        | 12 ------------
 drivers/media/platform/vsp1/vsp1_dl.c     |  4 +---
 drivers/media/platform/vsp1/vsp1_dl.h     | 12 ++----------
 drivers/media/platform/vsp1/vsp1_drv.c    |  9 +++------
 drivers/media/platform/vsp1/vsp1_entity.c | 12 ++++++++++++
 drivers/media/platform/vsp1/vsp1_entity.h |  2 ++
 6 files changed, 20 insertions(+), 31 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 910d6b8e8b50..bea232820ead 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -85,8 +85,6 @@ struct vsp1_device {
 	struct media_entity_operations media_ops;
 
 	struct vsp1_drm *drm;
-
-	bool use_dl;
 };
 
 int vsp1_device_get(struct vsp1_device *vsp1);
@@ -104,14 +102,4 @@ static inline void vsp1_write(struct vsp1_device *vsp1, u32 reg, u32 data)
 	iowrite32(data, vsp1->mmio + reg);
 }
 
-#include "vsp1_dl.h"
-
-static inline void vsp1_mod_write(struct vsp1_entity *e, u32 reg, u32 data)
-{
-	if (e->vsp1->use_dl)
-		vsp1_dl_add(e, reg, data);
-	else
-		vsp1_write(e->vsp1, reg, data);
-}
-
 #endif /* __VSP1_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index a4dcccf0778b..1e5cff590e87 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -128,10 +128,8 @@ void vsp1_dl_begin(struct vsp1_dl *dl)
 	list->reg_count = 0;
 }
 
-void vsp1_dl_add(struct vsp1_entity *e, u32 reg, u32 data)
+void vsp1_dl_add(struct vsp1_dl *dl, u32 reg, u32 data)
 {
-	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&e->subdev.entity);
-	struct vsp1_dl *dl = pipe->dl;
 	struct vsp1_dl_list *list = dl->lists.write;
 
 	list->body[list->reg_count].addr = reg;
diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
index 448c4250e54c..f4116ca59c28 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.h
+++ b/drivers/media/platform/vsp1/vsp1_dl.h
@@ -13,7 +13,7 @@
 #ifndef __VSP1_DL_H__
 #define __VSP1_DL_H__
 
-#include "vsp1_entity.h"
+#include <linux/types.h>
 
 struct vsp1_device;
 struct vsp1_dl;
@@ -25,18 +25,10 @@ void vsp1_dl_setup(struct vsp1_device *vsp1);
 
 void vsp1_dl_reset(struct vsp1_dl *dl);
 void vsp1_dl_begin(struct vsp1_dl *dl);
-void vsp1_dl_add(struct vsp1_entity *e, u32 reg, u32 data);
+void vsp1_dl_add(struct vsp1_dl *dl, u32 reg, u32 data);
 void vsp1_dl_commit(struct vsp1_dl *dl);
 
 void vsp1_dl_irq_display_start(struct vsp1_dl *dl);
 void vsp1_dl_irq_frame_end(struct vsp1_dl *dl);
 
-static inline void vsp1_dl_mod_write(struct vsp1_entity *e, u32 reg, u32 data)
-{
-	if (e->vsp1->use_dl)
-		vsp1_dl_add(e, reg, data);
-	else
-		vsp1_write(e->vsp1, reg, data);
-}
-
 #endif /* __VSP1_DL_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 1cfda6b6b659..cf469bd76f43 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -387,13 +387,10 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 			goto done;
 	}
 
-	if (vsp1->info->uapi) {
-		vsp1->use_dl = false;
+	if (vsp1->info->uapi)
 		ret = v4l2_device_register_subdev_nodes(&vsp1->v4l2_dev);
-	} else {
-		vsp1->use_dl = true;
+	else
 		ret = vsp1_drm_init(vsp1);
-	}
 
 done:
 	if (ret < 0)
@@ -461,7 +458,7 @@ static int vsp1_device_init(struct vsp1_device *vsp1)
 	vsp1_write(vsp1, VI6_DPR_HGT_SMPPT, (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
 		   (VI6_DPR_NODE_UNUSED << VI6_DPR_SMPPT_PT_SHIFT));
 
-	if (vsp1->use_dl)
+	if (!vsp1->info->uapi)
 		vsp1_dl_setup(vsp1);
 
 	return 0;
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index d65cf8035a92..5ba535809131 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -19,7 +19,19 @@
 #include <media/v4l2-subdev.h>
 
 #include "vsp1.h"
+#include "vsp1_dl.h"
 #include "vsp1_entity.h"
+#include "vsp1_pipe.h"
+
+void vsp1_mod_write(struct vsp1_entity *e, u32 reg, u32 data)
+{
+	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&e->subdev.entity);
+
+	if (pipe->dl)
+		vsp1_dl_add(pipe->dl, reg, data);
+	else
+		vsp1_write(e->vsp1, reg, data);
+}
 
 bool vsp1_entity_is_streaming(struct vsp1_entity *entity)
 {
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 83570dfde8ec..311d5b64c9a5 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -103,4 +103,6 @@ int vsp1_entity_set_streaming(struct vsp1_entity *entity, bool streaming);
 
 void vsp1_entity_route_setup(struct vsp1_entity *source);
 
+void vsp1_mod_write(struct vsp1_entity *e, u32 reg, u32 data);
+
 #endif /* __VSP1_ENTITY_H__ */
-- 
2.4.10

